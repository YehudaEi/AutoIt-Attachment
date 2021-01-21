;; -------------------------------------
;; Start GUI 
;; -------------------------------------
Opt("GUIOnEventMode", 1)
Global $GUITitle = "Mining Bot v" & $iVersion 
$MyGUI = GUICreate($GUITitle, 200, 200, 0, 0)
GUISetOnEvent($GUI_EVENT_CLOSE, "CheckGUI")
GUISetState()

; Laser Numbers
$MyGUI_LasersLable = GUICtrlCreateLabel("# of Lasers:", 10, 10, 100, 18)
$MyGUI_LasersInput = GUICtrlCreateInput("1", 110, 10, 14, 18) 
GUICtrlSetOnEvent($MyGUI_LasersInput, "CheckGUI")
$MyGUI_LasersSlider = GUICtrlCreateSlider(130, 10, 60, 18)
GUICtrlSetOnEvent($MyGUI_LasersSlider, "CheckGUI")
GUICtrlSetLimit($MyGUI_LasersSlider,8,1)
GUICtrlSetCursor($MyGUI_LasersSlider, 0)

; Belt To use
$MyGUI_BeltLable = GUICtrlCreateLabel("Use Belt:", 10, 30, 100, 18)
$MyGUI_BeltInput = GUICtrlCreateInput( "1", 110, 30, 75, 18) 

; Station To use
$MyGUI_StationLable = GUICtrlCreateLabel("Use Station:", 10, 50, 100, 18)
$MyGUI_StationInput = GUICtrlCreateInput( "1", 110, 50, 75, 18) 

; Mouse To use
$MyGUI_MouseLable = GUICtrlCreateLabel("Mouse Speed:", 10, 70, 100, 18)
$MyGUI_MouseInput = GUICtrlCreateInput( "10", 110, 70, 75, 18) 
  
$MyGUI_StatusLine = GUICtrlCreateLabel("", 10, 90, 180, 18)
$MyGUI_TimerLine  = GUICtrlCreateLabel("", 10, 105, 180, 54)

GUISetFont (12, 550, 0, "Arial", $MyGUI)
; "Start Bot" Button
$MyGUI_StartButton = GUICtrlCreateButton("Start Bot", 10, 150, 90)
GUICtrlSetOnEvent($MyGUI_StartButton, "CheckGUI")
; "Stop Bot" Button
$MyGUI_StopButton = GUICtrlCreateButton("Stop Bot", 100, 150, 90)
GUICtrlSetOnEvent($MyGUI_StopButton, "CheckGUI")

; Copyright....
GUISetFont (8, 400, 0, "Arial", $MyGUI)
$MyGUI_CopyLabel = GUICtrlCreateLabel(" Copyright (c) 2006 All rights reserved.", 5, 183, 190, 12, $SS_CENTER) 


; Tooltips
GUICtrlSetTip($MyGUI_LasersLable, "Number of Lasers your ship has." )
GUICtrlSetTip($MyGUI_BeltLable, "Which asteroid belt should we use." )
GUICtrlSetTip($MyGUI_StationLable, "Which spacestation should we dock at." )
GUICtrlSetTip($MyGUI_MouseLable, "Mouse speed: default 10 = Humanish, 1 = Fasest, 100 = Slowest" )

