do
    plane <- currentPlane
    (x, y) <- fmap (quantise2 quantum) mouse
    panel <- container' "panel_3x1.png" (x, y) (Inside plane)
    lab <- label' "vca" (x-25.0, y+75.0) (Inside plane)
    parent panel lab
    name <- new' "vca"
    inp <- plugin' (name ++ ".cv") (x-21, y+25) (Inside plane)
    setColour inp "#control"
    parent panel inp
    inp <- plugin' (name ++ ".signal") (x-21, y-25) (Inside plane)
    setColour inp "#sample"
    parent panel inp
    out <- plugout' (name ++  ".result") (x+20, y) (Inside plane)
    setColour out "#sample"
    parent panel out
    recompile
    return ()
