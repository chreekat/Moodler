do
    plane <- currentPlane
    (x, y) <- fmap (quantise2 quantum) mouse
    panel <- container' "panel_3x1.png" (x, y) plane
    lab <- label' "audio_sin" (x-25.0, y+75.0) plane
    parent panel lab
    name <- new' "audio_sin"
    inp <- plugin' (name ++ ".freq") (x-21, y+25) plane
    setColour inp "#control"
    parent panel inp
    inp <- plugin' (name ++ ".sync") (x-21, y-25) plane
    setColour inp "#sample"
    parent panel inp
    out <- plugout' (name ++  ".result") (x+20, y) plane
    setColour out "#sample"
    parent panel out
    recompile
    return ()
