{-# LANGUAGE FlexibleContexts, ForeignFunctionInterface #-}

module CodeGen where

import Control.Lens hiding (set)
import Control.Monad.State
import Control.Monad.Trans.Error
import Control.Monad.Writer
import Data.Function
import Data.Hashable
import Data.List
import Data.Maybe
import Foreign.C.String
import Foreign.C.Types
import Foreign.Ptr
import Language.C.Data.Ident
import Language.C.Data.Name
import Language.C.Data.Node
import Language.C.Data.Position
import Language.C.Pretty
import Language.C.Syntax.AST
import System.Directory
import System.IO.Temp
import System.Posix.DynamicLinker
import System.Process
import Text.PrettyPrint
import qualified Data.Map as M
import qualified Data.Set as S

import CGen
import CLens
import Module
import MoodlerSymbols
import Parser
import Synth
import Utils

emptyStatement :: CStat -> Bool
emptyStatement (CCompound _ [] _) = True
emptyStatement _ = False

inValues :: (Ord a, Ord b) => M.Map a b -> [b]
inValues = map snd . S.toList . S.fromList . M.toList

-- Topological sort of synth nodes working backwards from
-- output.
orderNodes :: Synth -> Module -> M.Map ModuleName (Int, Module)
orderNodes synth out' =
    snd $ execState (orderNodes' synth out') (0, M.empty) where
    orderNodes' :: M.Map ModuleName Module -> Module ->
                   State (Int, M.Map ModuleName (Int, Module)) ()
    orderNodes' synth' modl@Module { _getNodeName = name
                                  , _inputNodes = inputs} = do
        (level, dict) <- get
        unless (name `M.member` dict) $ do
             put (level+1, M.insert name (level, modl) dict)
             forM_ (inValues inputs) $ \outNode ->
                case outNode of
                    Out nodeName _ -> 
                        let node = fromMaybe (error ("failed to find "++_getModuleName nodeName++" in a "++_getModuleName name)) (M.lookup nodeName synth')
                        in orderNodes' synth' node
                        {-
                    Out _ node _ -> -- XXX Why fromMaybe error?
                        orderNodes' synth' node
                        -}
                    Disconnected -> return ()

foreign import ccall "dynamic"  
  mkCreate :: FunPtr (IO (Ptr ())) -> IO (Ptr ())
foreign import ccall "dynamic"  
  mkInit :: FunPtr (Ptr () -> IO ()) -> Ptr () -> IO ()
foreign import ccall "dynamic"  
  mkInit2 :: FunPtr (Ptr () -> CString -> IO ()) -> Ptr () -> CString -> IO ()
foreign import ccall "dynamic"  
  mkExecute :: FunPtr (Ptr () -> IO ()) -> Ptr () -> IO ()
foreign import ccall "dynamic"  
  mkSet :: FunPtr (Ptr () -> CString -> CString -> CDouble -> IO ()) ->
                   Ptr () -> CString -> CString -> CDouble -> IO ()
foreign import ccall "dynamic"  
  mkSetString :: FunPtr (Ptr () -> CString -> CString -> CString -> IO ()) ->
                         Ptr () -> CString -> CString -> CString -> IO ()

concatMapM :: Monad m => (a -> m [b]) -> [a] -> m [b]
concatMapM f xs = liftM concat (mapM f xs)

varsFromNodeType :: NodeType a -> M.Map String CExpr -> Vars
varsFromNodeType nodeType connections =
    let states = _stateNames nodeType
        ins = _inNames nodeType
        outs = _outNames nodeType
    in Vars states outs ins connections

-- In node_exec() function
instantiateExec3 :: NodeType NodeInfo -> M.Map String CExpr -> CStat
instantiateExec3 nodeType connections = do
    let e = _execCode nodeType
    let variables = varsFromNodeType nodeType connections 
    rewriteVars2 (_getModuleTypeName (_nodeTypeName nodeType)) variables e

-- Inlined in exec()
inlineExec :: ModuleName -> NodeType NodeInfo -> M.Map String CExpr -> Maybe CStat
inlineExec nodeName nodeType connections =
    let e = _execCode nodeType
    in if not (emptyStatement (e ^. funDefStat))
        then let variables = varsFromNodeType nodeType connections 
        in Just (rewriteVars (_getModuleName nodeName) variables e)
    else Nothing

-- Call to node_exec()
-- Why are inputNames separated from their connections?
instantiateExec2 :: ModuleName -> NodeType NodeInfo -> ModuleTypeName -> [String] -> M.Map String Out -> CStat
instantiateExec2 nodeName nodeType typeName inputNames connections =
    cExpr $ cCall (cVar (cIdent (_getModuleTypeName typeName ++ "_exec")))
                  (map (\inputName ->
                            let x = fromMaybe Disconnected (M.lookup inputName connections)
                            in cExprForOut (nodeType ^. inNames) inputName x 
                        ) inputNames ++
                   [cAddr (cVar (cIdent "state") `cArrow` cIdent (_getModuleName nodeName))])

instantiateInit :: ModuleName -> NodeType NodeInfo -> CStat
instantiateInit nodeName nodeType =
    let i = _initCode nodeType
        variables = varsFromNodeType nodeType M.empty
    in rewriteVars (_getModuleName nodeName) variables i

genIncludes :: MonadWriter String m =>
               [String] -> m ()
genIncludes includes = forM_ includes $ \include ->
    tell $ "#include<" ++ include ++ ">\n"

genHeaders :: MonadWriter String m => String -> m ()
genHeaders libDirectory = do
    genIncludes ["stdio.h", "stdlib.h", "stddef.h", "string.h", "math.h"]
    tell $ "#include \"" ++ libDirectory ++ "/moodler_lib.h\"\n"

-- Generate elements of struct corresponding to one primitive module.
definePrimtitiveStructType :: NodeType NodeInfo -> CDecl
definePrimtitiveStructType nodeType =
    let decls = _stateDecls nodeType
        members = decls
        stateStruct1 = CStruct CStructTag
                      (Just (mkIdent nopos (_getModuleTypeName (_nodeTypeName nodeType)) (Name 0)))
                      (Just members) [] undefNode
        stateType1 = CSUType stateStruct1 undefNode
        decl1 = CDecl [CTypeSpec stateType1]
                   [(Nothing, Nothing, Nothing)]
                   undefNode
    in decl1

definePrimtitiveStruct :: ModuleName -> ModuleTypeName -> CDecl
definePrimtitiveStruct nodeName primTypeName =
    --let variables = varsFromNodeType nodeType M.empty
    --members <- mapM (rewriteVarsInStructEverywhere nodeName variables) decls
    let stateStruct2 = CStruct CStructTag
                      (Just (mkIdent nopos (_getModuleTypeName primTypeName) (Name 0)))
                      Nothing [] undefNode
        stateType2 = CSUType stateStruct2 undefNode
        decl2 = CDecl [CTypeSpec stateType2]
                   [(Just (CDeclr (Just (cIdent (_getModuleName nodeName))) [] Nothing [] undefNode), Nothing, Nothing)]
                   undefNode
    in decl2

-- XXX The string is the name of the module but it's stored in the Module
-- so we don't need it kept separately, just get it with _getNodeName.
genStruct :: [(ModuleName, Module)] -> Writer String ()
genStruct moduleList = do
    -- Get all nodes used in synth
    let nodeTypes = map (_getNodeType . snd) moduleList
    let uniqNodeTypes = uniqBy (compare `on` _nodeTypeName) nodeTypes
    let primitiveStructTypes = map definePrimtitiveStructType uniqNodeTypes

    let members2 = flip map moduleList $ \(name, node) -> 
            definePrimtitiveStruct name (_nodeTypeName (_getNodeType node))

    let stateStruct = CDecl [CTypeSpec (CSUType (CStruct CStructTag
                      (Just (cIdent "State"))
                      (Just members2) [] undefNode) undefNode)] [] undefNode

    tell (render (pretty (cTranslUnit (primitiveStructTypes ++ [stateStruct]) [])))
    tell "\n"

    forM_ uniqNodeTypes $ \nodeType -> do
        let helper = genAddressHelper nodeType
        tell (render (pretty helper))
        tell "\n"

    forM_ uniqNodeTypes $ \nodeType@NodeType { _execCode = execFunDef
                                             , _nodeTypeName = typeName } ->
        unless (_isInlined nodeType) $ do
            let codeBody = instantiateExec3 nodeType undefined
            let newFunctionDef = execFunDef & funDefDeclr %~ rewriteShaderDeclr (_getModuleTypeName typeName ++ "_exec") (_getModuleTypeName typeName) (_getModuleTypeName typeName)
                                            & funDefStat .~ codeBody
            tell (render (pretty newFunctionDef))

cExprForOut :: M.Map String CDecl -> String -> Out -> CExpr
cExprForOut inDecls inName Disconnected =
    fromMaybe (intConst 0) $ inDecls ^? ix inName . to getNormalFromCDecl . each

cExprForOut _ _ (Out name' name'') =
        cVar (cIdent "state") `cArrow` cIdent (_getModuleName name') `cDot` cIdent name''

-- The type of the "execute" C function.
executeType :: CDerivedDeclr
executeType =
    CFunDeclr (Right (
              [
                  cPtrTo (structType (cIdent "State")) (cIdent "state"),
                  cPtrTo (CShortType undefNode) (cIdent "buffer")
              ], False))
              [] undefNode

executeFunction :: CStatement NodeInfo -> CFunctionDef NodeInfo
executeFunction stmt = 
    CFunDef [CTypeSpec (CVoidType undefNode)]
            (CDeclr (Just (cIdent "execute"))
                    [executeType]
                    Nothing [] undefNode)
            [] (CCompound [] [CBlockStmt stmt] undefNode) undefNode

genExec :: [(ModuleName, Module)] -> Writer String ()
genExec sortedPrimitives = do
    compoundParts <- forM sortedPrimitives $ \(name, node) -> do
        -- inputNodes maps from names of "in" arguments to
        -- an "Out" from an earlier node.
        let nodeType@NodeType {_inList = inputNames
                                , _nodeTypeName = typeName
                               } = _getNodeType node
        let connections = _inputNodes node
        let connections' = M.mapWithKey (cExprForOut (nodeType ^. inNames)) connections
        if _getModuleName name == "out" || _isInlined nodeType
            then return $ inlineExec name nodeType connections'
            else return $ Just (instantiateExec2 name nodeType typeName
                                {-(map fst $ M.toList connections)-} inputNames connections)
    let compoundStatement = CCompound []
                                      (map CBlockStmt (catMaybes compoundParts))
                                      undefNode

    let iIdent = cIdent "i"
    let iVar = cVar iIdent
    let loop = CFor (Right (CDecl [CTypeSpec (CIntType undefNode)]
                                  [(Just (CDeclr (Just iIdent) [] Nothing [] undefNode),
                                    Just (CInitExpr (intConst 0) undefNode),
                                    Nothing)]
                                  undefNode))
                    (Just (iVar `cLe` intConst 256))
                    (Just (cPreInc iVar))
                    compoundStatement
                    undefNode
    let function = executeFunction loop
    tell (render (pretty function))

structName :: String -> CDecl
structName n = CDecl [CTypeSpec (CSUType (CStruct CStructTag
                     (Just (mkIdent nopos n (Name 0)))
                     Nothing [] undefNode) undefNode)] [] undefNode

addressHelperType :: CDerivedDeclr
addressHelperType =
    CFunDeclr (Right (
              [
                  cConstPtrTo (CCharType undefNode) (cIdent "field")
              ], False))
              [] undefNode

addressHelperFunction :: String -> [CStat] -> CFunDef
addressHelperFunction n stmts = 
    CFunDef [CTypeSpec (CIntType undefNode)]
            (CDeclr (Just (cIdent n))
                    [addressHelperType]
                    Nothing [] undefNode)
            [] (CCompound [] (map CBlockStmt stmts) undefNode) undefNode

genAddressHelper :: NodeType a -> CFunDef
genAddressHelper nodeType =
    let stateVars = _stateNames nodeType
        name = _nodeTypeName nodeType
        name' = _getModuleTypeName name
        stmts = flip map stateVars $ \varName ->
                    cIf (cLNeg (strcmp [cV "field", stringConst varName]))
                                   (cReturn (Just (cOffsetOf (structName name') (cIdent varName))))
                                   Nothing
    in addressHelperFunction (name' ++ "_address")
                                         (stmts ++ [cReturn (Just (intConst (-1)))])

-- Create C function to return offset into state corresponding
-- to fields.
addressType :: CDerivedDeclr
addressType =
    CFunDeclr (Right (
              [
                  cConstPtrTo (CCharType undefNode) (cIdent "node"),
                  cConstPtrTo (CCharType undefNode) (cIdent "field")
              ], False))
              [] undefNode

addressFunction :: [CStat] -> CFunDef
addressFunction stmts = 
    CFunDef [CTypeSpec (CIntType undefNode)]
            (CDeclr (Just (cIdent "address"))
                    [addressType]
                    Nothing [] undefNode)
            [] (CCompound [] (map CBlockStmt stmts) undefNode) undefNode

strcmp :: [CExpr] -> CExpr
strcmp = cCall (cVar (cIdent "strcmp"))

structState :: CDecl
structState = CDecl [CTypeSpec (CSUType (CStruct CStructTag
              (Just (mkIdent nopos "State" (Name 0)))
              Nothing [] undefNode) undefNode)] [] undefNode

genAddress :: [(ModuleName, Module)] -> CFunDef
genAddress moduleList =
    let stmts = flip map moduleList $ \(name, node) ->
                    cIf (cLNeg (strcmp [cV "node", stringConst (_getModuleName name)]))
                           (cReturn (Just (cCall (cV (_getModuleTypeName (_nodeTypeName (_getNodeType node)) ++ "_address"))
                                                 [cV "field"]
                                           `cPlus`
                                           cOffsetOf structState (cIdent (_getModuleName name)))
                        ))
                        Nothing
    in addressFunction (stmts ++ [cReturn (Just (intConst (-1)))])

init2Type :: CDerivedDeclr
init2Type =
    CFunDeclr (Right (
              [
                  cPtrTo (structType (cIdent "State")) (cIdent "state"),
                  cConstPtrTo (CCharType undefNode) (cIdent "node")
              ], False))
              [] undefNode

init2Function :: [CStat] -> CFunDef
init2Function clauses = 
    CFunDef [CTypeSpec (CVoidType undefNode)]
            (CDeclr (Just (cIdent "init2"))
                    [init2Type]
                    Nothing [] undefNode)
            [] (CCompound [] (map CBlockStmt clauses) undefNode) undefNode

{-
addressHelperFunction :: String -> [CStat] -> CFunDef
addressHelperFunction n stmts = 
    CFunDef [CTypeSpec (CIntType undefNode)]
            (CDeclr (Just (cIdent n))
                    [addressHelperType]
                    Nothing [] undefNode)
            [] (CCompound [] (map CBlockStmt stmts) undefNode) undefNode
            -}

-- No need to inline these!
genInit2 :: [(ModuleName, Module)] -> Writer String ()
genInit2 moduleList = --do
    --tell "void init2(struct State *state, const char *node) {\n"

    let clauses = flip map moduleList $ \(name, node) -> 
                    let initSource = instantiateInit name (_getNodeType node)

                    in cIf (cLNeg (strcmp [cV "node", stringConst (_getModuleName name)]))
                                   initSource
                                   Nothing
        --tell (render (pretty cond))
    --tell "}\n"
        function = init2Function clauses
    in do
        tell (render (pretty function))
        tell "\n"

genSet :: Writer String ()
genSet = do
    tell "void set(struct State *state, const char *node,\n"
    tell "                  const char *field, double value) {\n"
    tell "    int offset = address(node, field);\n"
    tell "    *(double *)((char *)state+offset) = value;\n"
    tell "    printf(\"set %s.%s(%d)=%f\\n\",node,field,offset,value);\n"
    tell "}\n"

-- XXX No free for that strdup
genSetString :: Writer String ()
genSetString = do
    tell "void set_string(struct State *state, const char *node,\n"
    tell "                  const char *field, const char *value) {\n"
    tell "    int offset = address(node, field);\n"
    tell "    *(char **)((char *)state+offset) = strdup(value);\n"
    tell "    printf(\"set %s.%s(%d)=%s\\n\",node,field,offset,value);\n"
    tell "}\n"

genCreate :: Writer String ()
genCreate = do
    tell "struct State *create() {\n"
    tell "struct State *x = malloc(1024*1024);\n"
    tell "return x;\n"
    tell "}\n"

sampleRate :: Double
sampleRate = 1.0/48000

sortedNodes :: Synth -> Module -> [(ModuleName, Module)]
sortedNodes synth out' = 
    let x :: [(ModuleName, (Int, Module))]
        x = M.toList $ orderNodes synth out'
    -- Sorted topologically
    in  map (\(a, (_, c)) -> (a, c)) (sortBy (flip compare `on` (fst . snd)) x)

-- Create entire C source code unit.
gen :: String -> Synth -> Module ->
       Writer String ()
gen currentDirectory synth out' = do
    -- Sorted by module number
    let moduleList = sortBy (compare `on` (_moduleNumber . snd)) $ M.toList synth
    --let x = M.toList $ orderNodes synth out'
    -- Sorted topologically
    let sortedPrimitives = sortedNodes synth out'
    genHeaders currentDirectory
    tell $ "const double dt = " ++ show sampleRate ++ ";\n"
    genStruct moduleList
    genCreate
    --genInit moduleList synth
    genInit2 moduleList
    genExec sortedPrimitives
    let address = genAddress moduleList
    tell (render (pretty address))
    genSet
    genSetString

compile :: String -> String -> IO ()
compile sourceName libraryName = do
    let extra_libs = ["delay_line.o", "reverb.o"]
    let clang_options = ["-O3", "-ffast-math"]
    let command = "clang " ++ unwords clang_options
                  ++ " -dynamiclib -lm -std=gnu99 -Wno-logical-op-parentheses moodler_lib.o "
                  ++ unwords extra_libs ++ " " ++ sourceName
                  ++ " -o " ++ libraryName
    --print $ "Running " ++ command
    compileHandle <- runCommand command
    --print $ "Compiling to " ++ libraryName
    void $ waitForProcess compileHandle
    --print $ "Done compiling to " ++ libraryName
    return ()

type CreateFn = IO (Ptr ())
type InitFn = Ptr () -> IO ()
type Init2Fn = Ptr () -> CString -> IO ()
type ExecuteFn = Ptr () -> IO ()
type SetFn = Ptr () -> CString -> CString -> CDouble -> IO ()
type SetStringFn = Ptr () -> CString -> CString -> CString -> IO ()

-- Represents a DSO loaded into memory along with Haskell wrappers
-- around C functions within it.
data DSO = DSO { dl :: DL
               , createFn :: CreateFn
               -- , dsoInitFn :: InitFn
               , dsoInit2Fn :: Init2Fn
               , dsoExecuteFn :: FunPtr ()
               , dsoSetFn :: SetFn
               , dsoSetStringFn :: SetStringFn }

makeDso :: String -> IO DSO
makeDso code = do
    print "---"
    putStr code
    print "---"
    --let tmpDir = "gensrc" ++ show (hash code)
    --createDirectoryIfMissing False tmpDir
    withSystemTempDirectory
        ("gensrc" ++ show (hash code) ++ ".") $ \tmpDir -> do
        let tmpSrcFile = tmpDir ++ "/gen.c"
        let tmpSoFile = tmpDir ++ "/gen.so"
        --print tmpDir
        writeFile tmpSrcFile code
        compile tmpSrcFile tmpSoFile
        so <- dlopen tmpSoFile [RTLD_NOW, RTLD_LOCAL]
        --print $ "Loaded lib " ++ tmpSoFile

        create <- dlsym so "create"
        --ini <- dlsym so "init"
        ini2 <- dlsym so "init2"
        execute <- dlsym so "execute"
        set <- dlsym so "set"
        setString <- dlsym so "set_string"

        return $ DSO so (mkCreate create) {-(mkInit ini)-} (mkInit2 ini2) execute (mkSet set)
                                                                    (mkSetString setString)
    -- End of tmp dir bit

setStateVar :: SetFn -> Ptr () -> String -> String -> Float -> IO ()
setStateVar set dataPtr nodeName stateVar value =
    withCString nodeName $ \nodeString ->
        withCString stateVar $ \stateString ->
            set dataPtr nodeString stateString (realToFrac value)

setStringStateVar :: SetStringFn -> Ptr () -> String -> String -> String -> IO ()
setStringStateVar set dataPtr nodeName stateVar value =
    withCString nodeName $ \nodeString ->
        withCString stateVar $ \stateString ->
            withCString value $ \valueString ->
                set dataPtr nodeString stateString valueString

makeDSOFromSynth :: Synth -> Module -> ErrorT String IO DSO
makeDSOFromSynth synth out' = do
    currentDirectory <- liftIO getCurrentDirectory
    let code' = execWriter (gen currentDirectory synth out')
    liftIO $ makeDso code'
