do
    (x0, y0) <- mouse
    let (x, y) = quantise2 quantum (x0, y0)
    root <- currentPlane
    int_add0  <-  new' "int_add"
    container162 <- container' "panel_int_add.png" (x+(0.0), y+(0.0)) (Inside root)
    in57 <- plugin' (int_add0 ++ "." ++ "x") (x+(-60.0), y+(24.0)) (Outside container162)
    setColour in57 "(0, 1, 0)"
    in58 <- plugin' (int_add0 ++ "." ++ "y") (x+(-60.0), y+(-24.0)) (Outside container162)
    setColour in58 "(0, 1, 0)"
    out60 <- plugout' (int_add0 ++ "." ++ "result") (x+(60.0), y+(0.0)) (Outside container162)
    setColour out60 "(0, 1, 0)"
    recompile
    return ()
