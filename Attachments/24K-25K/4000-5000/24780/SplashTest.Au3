#NoTrayIcon
#Include "Splash.Au3"

Local $SplashShown
$SplashShown = True
DisplaySplash()
If @error Then $SplashShown = False
Sleep(1000)

$guiMain = GUICreate("Main GUI", 300, 400, -1, -1)
$MenuFile = GUICtrlCreateMenu("&File")
$mnuFileExit 	 = GUICtrlCreateMenuItem("E&xit", $MenuFile)

$MenuHelp = GUICtrlCreateMenu("&Help")
$mnuHelp = GUICtrlCreateMenuItem("&Help", $MenuHelp)
$mnuAbout = GUICtrlCreateMenuItem("&About", $MenuHelp)
GUISetState()
Sleep(1000)

If $SplashShown Then DismissSplash()
While 1
	$msg = GUIGetMsg()
	Switch $msg
	Case $GUI_EVENT_CLOSE, $mnuFileExit
			 ExitLoop
	case $GUI_EVENT_PRIMARYDOWN
			 GUISetCursor(9) ; = SIZEALL
	case $GUI_EVENT_PRIMARYUP
		   GUISetCursor(0)
	Case $mnuAbout
	     $HotLabelTxt = "About Splash"
			 DisplaySplash()
			 If @error Then $SplashShown = False
			 If $SplashShown Then
				  While 1
				     If Check4KbdOrMousePress() Then ExitLoop
				  WEnd
			    DismissSplash()
			 EndIf
  EndSwitch
Wend

Func Check4KbdOrMousePress()
Local $i
Local $Keycodes = StringSplit("01|02|04|05|06" & _
    "|08|09|0C|0D|10|11|12|13|14|1B|20|21|22" & _
    "|23|24|25|26|27|28|29|2A|2B|2C|2D|2E|30" & _
    "|31|32|33|34|35|36|37|38|39|41|42|43|44" & _
    "|45|46|47|48|49|4A|4B|4C|4D|4E|4F|50|51" & _
    "|52|53|54|55|56|57|58|59|5A|5B|5C|60|61" & _
    "|62|63|64|65|66|67|68|69|6A|6B|6C|6D|6E" & _
    "|6F|70|71|72|73|74|75|76|77|78|79|7A|7B" & _
    "|90|91|A0|A1|A2|A3|A4|A5", "|")
    For $i in $Keycodes
        If _IsPressed(String($i)) Then Return 1
    Next
    Return 0
EndFunc