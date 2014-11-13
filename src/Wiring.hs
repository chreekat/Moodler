{-# LANGUAGE FlexibleContexts #-}

-- These are operations that change the state of the server
-- side synth.

module Wiring(synthConnect,
              deleteCable,
              rotateCables,
              removeAllCablesFrom,
              synthNew,
              synthSet,
              synthQuit,
              synthRecompile,
              undoPoint,
              performUndo, 
              performRedo) where

import Control.Lens
import Control.Monad.Trans
import Control.Monad.State
import qualified Data.Map as M

import Comms
import Cable
import World
import UIElement
import Symbols

synthConnect :: (Functor m, MonadIO m, MonadState GlossWorld m,
                InputHandler m) =>
                UiId -> UiId -> m ()
synthConnect s1 s2 = do
    s1Name <- use (inner . uiElements . ix s1 . name)
    s2Name <- use (inner . uiElements . ix s2 . name)
    sendConnectMessage s1Name s2Name
    previousCables <- use (inner . uiElements . ix s2 . cablesIn)
    {- UNDO -}
    if null previousCables -- XXX case
        then recordUndo (SendDisconnect s2Name)
                        (SendConnect s1Name s2Name)
        else do
            let (Cable o : _) = previousCables
            oName <- use (inner . uiElements . ix o . name)
            recordUndo (SendConnect oName s2Name)
                       (SendConnect s1Name s2Name)
    inner . uiElements . ix s2 . cablesIn %= (Cable.Cable s1 :)

synthNew :: (Functor m, MonadIO m, MonadState GlossWorld m,
            InputHandler m) =>
            String -> String -> m ()
synthNew synthType synthName = do
    {- UNDO Maybe not needed -}
    inner . synthList %= (++ [(synthType, synthName)])
    sendNewSynthMessage synthType synthName

{-
deleteCable' :: (MonadState GlossWorld m, MonadIO m) =>
                Cable -> UiId -> m (Maybe Cable)
deleteCable' c@(Cable c') selectedIn = do
    {- UNDO -}
    c'Name <- use (inner . uiElements . ix c' . name)
    selectedInName <- use (inner . uiElements . ix selectedIn . name)
    recordUndo (SendConnect c'Name selectedInName)
    sendRecompileMessage
    return (Just c)
-}

deleteCable :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
               UiId -> m (Maybe Cable)
deleteCable selectedIn = do
    outPoint <- getElementById "UISupport.hs" selectedIn
    case outPoint ^. cablesIn of
        [] -> return Nothing
        [c@(Cable c')] -> do
            inner . uiElements . ix selectedIn . cablesIn .= []
            selectedInName <- use (inner . uiElements . ix selectedIn . name)
            sendDisconnectMessage selectedInName
            --deleteCable' c selectedIn
            c'Name <- use (inner . uiElements . ix c' . name)
            recordUndo (SendConnect c'Name selectedInName)
                       (SendDisconnect selectedInName)
            --sendRecompileMessage
            return (Just c)
        (c@(Cable c') : rc@(Cable src : _)) -> do
            inner . uiElements . ix selectedIn . cablesIn .= rc
            srcName <- use (inner . uiElements . ix src . name)
            selectedInName <- use (inner . uiElements . ix selectedIn . name)
            sendConnectMessage srcName selectedInName
            c'Name <- use (inner . uiElements . ix c' . name)
            recordUndo (SendConnect c'Name selectedInName)
                       (SendConnect srcName selectedInName)
            --sendRecompileMessage
            return (Just c)

rotateCables :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
                UiId -> m ()
rotateCables selectedIn = do
    outPoint <- getElementById "rotateCables" selectedIn
    case outPoint ^. cablesIn of
        (c@(Cable c') : rc@(Cable src : _)) -> do
            inner . uiElements . ix selectedIn . cablesIn .= rc ++ [c]
            srcName <- use (inner . uiElements . ix src . name)
            selectedInName <- use (inner . uiElements . ix selectedIn . name)
            c'Name <- use (inner . uiElements . ix c' . name)
            sendConnectMessage srcName selectedInName
            {- UNDO -}
            recordUndo (SendConnect c'Name selectedInName)
                       (SendConnect srcName selectedInName)
            --sendRecompileMessage
            return ()
        _ -> return ()

cableIsFrom :: UiId -> Cable -> Bool
cableIsFrom elt (Cable src) = elt == src

removeCablesFrom :: UiId -> UIElement -> UIElement
removeCablesFrom i elt@In {} =
    cablesIn %~ filter (not . cableIsFrom i) $ elt
removeCablesFrom _ elt = elt

-- Remove all cables from src to dst in list cs
removeAllCablesFromTo :: (Functor m, MonadIO m,
                         MonadState GlossWorld m) =>
                         UiId -> UiId -> [Cable] -> m ()
removeAllCablesFromTo src dst cs = do
    unless (null cs) $ do
        let Cable s : _ = cs
        dstName <- use (inner . uiElements . ix dst . name)
        srcName <- use (inner . uiElements . ix src . name)
        when (s == src) $ do
            let newCs = filter (not . cableIsFrom src) cs
            if null newCs
                then do 
                    sendDisconnectMessage dstName
                    recordUndo (SendConnect srcName dstName)
                               (SendDisconnect dstName)
                else do
                    let Cable newSrc : _ = newCs
                    newSrcName <- use (inner . uiElements . ix newSrc . name)
                    sendConnectMessage newSrcName dstName
                    recordUndo (SendConnect srcName dstName)
                               (SendConnect newSrcName dstName)
            {- UNDO -}
            inner . uiElements . ix dst . cablesIn .= newCs
    inner . uiElements . ix dst %= removeCablesFrom src

removeAllCablesFrom :: (Functor m, MonadIO m,
                       MonadState GlossWorld m) =>
                       UiId -> m ()
removeAllCablesFrom i = do
    eltIds <- use (inner . uiElements)
    forM_ (M.toList eltIds) $ \(eltId, elt) ->
        case elt of
            In { _cablesIn = cs } -> removeAllCablesFromTo i eltId cs
            _ -> return ()
    -- sendRecompileMessage

synthSet :: (Functor m, MonadIO m,
            MonadState GlossWorld m) =>
            UiId -> Float -> m ()
synthSet t v = do
    -- Note this is using fact that string is monoid
    -- Not good! XXX
    elt <- getElementById "synthSet" t
    let knobName = UIElement._name elt
    let oldValue = UIElement._setting elt
    inner . uiElements . ix t . UIElement.setting .= v
    sendSetMessage knobName v
    recordUndo (SendSet knobName oldValue)
               (SendSet knobName v)

synthQuit :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
             m ()
synthQuit = sendQuitMessage

synthRecompile :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
                  String -> m ()
synthRecompile =
    sendRecompileMessage

undoPoint :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
             m ()
undoPoint = do
    liftIO $ print "Setting undo point"
    innerState <- use inner
    innerHistory %= (innerState :)
    undoHistory %= (([], []) :)
    innerFuture .= []
    undoFuture .= []

performUndo :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
               m ()
performUndo = do
    history <- use innerHistory
    unless (null history) $ do
        currentInner <- use inner
        let innerState = head history
        cmds@(undos, _) : _ <- use undoHistory
        innerHistory %= tail
        undoHistory %= tail
        inner .= innerState
        innerFuture %= (currentInner :)
        undoFuture %= (cmds :)
        mapM_ (\a -> interpretSend a >> liftIO (putStrLn $ "Undoing: " ++ show a)) undos
        synthRecompile "undo"

performRedo :: (Functor m, MonadIO m, MonadState GlossWorld m) =>
               m ()
performRedo = do
    future <- use innerFuture
    unless (null future) $ do
        currentInner <- use inner
        let innerState = head future
        cmds@(_, redos) : _ <- use undoFuture
        innerFuture %= tail
        undoFuture %= tail
        inner .= innerState
        innerHistory %= (currentInner :)
        undoHistory %= (cmds :)
        mapM_ (\a -> interpretSend a >> liftIO (putStrLn $ "Redoing: " ++ show a)) (reverse redos)
        synthRecompile "redo"