do
    plane <- currentPlane
    (x, y) <- fmap (quantise2 quantum) mouse
    panel <- container' "panel_3x1.png" (x, y) (Inside plane)
    lab <- label' "noise" (x-25.0, y+75.0) (Inside plane)
    parent panel lab
    name <- new' "noise"
    out <- plugout' (name ++  ".result") (x+20, y) (Inside plane)
    setColour out "#sample"
    parent panel out
    recompile
    return ()
