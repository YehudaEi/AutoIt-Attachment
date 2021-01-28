$SCREENWIDTH = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 78)
$SCREENWIDTH = $SCREENWIDTH[0]
$SCREENHEIGHT = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 79)
$SCREENHEIGHT = $SCREENHEIGHT[0]
Global Const $SWH_SCREENWIDTH = $SCREENWIDTH
Global Const $SWH_SCREENHEIGHT = $SCREENHEIGHT