do
    plane <- currentPlane
    (x, y) <- fmap (quantise2 quantum) mouse
    panel <- container' "panel_4x1.png" (x, y) plane
    lab <- label' "dda" (x-25.0, y+75.0) plane
    parent panel lab
    name <- new' "dda"
    inp <- plugin' (name ++ ".reset") (x-21, y+75) plane
    setColour inp "#control"
    parent panel inp
    inp <- plugin' (name ++ ".clock") (x-21, y+25) plane
    setColour inp "#control"
    parent panel inp
    inp <- plugin' (name ++ ".phase") (x-21, y-25) plane
    setColour inp "#control"
    parent panel inp
    inp <- plugin' (name ++ ".dy") (x-21, y-75) plane
    setColour inp "#control"
    parent panel inp
    out <- plugout' (name ++  ".trigger") (x+20, y) plane
    setColour out "#control"
    parent panel out
    recompile
    return ()