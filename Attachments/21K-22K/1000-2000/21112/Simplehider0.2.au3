
opt("GUIOnEventMode", 1)
#include <GUIConstants.au3>
$Form1 = GUICreate("Simplehider", 153, 216, 193, 125)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$hide = GUICtrlCreateButton("hide", 0, 0, 169, 57, 0)
GUICtrlSetOnEvent($hide, "hideClick")
$show = GUICtrlCreateButton("show", 0, 56, 169, 65, 0)
GUICtrlSetOnEvent($show, "show")
$minimize = GUICtrlCreateButton("minimize", 0, 120, 169, 49, 0)
GUICtrlSetOnEvent($minimize, "minimizeClick")
GUICtrlSetTip($minimize, "minimize's this window")
GUISetState(@SW_SHOW)
If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer
$sInputBoxAnswer = InputBox("Simplehider","type window title you wish to hide here. if you press cancel do following: go to window you want to hide -> wait few secs and it should pop up window telling that its ready.","Firefox"," ","-1","-1","-1","-1")
Select
	Case @Error = 0
$i = $sInputBoxAnswer
	Case @Error = 1
		sleep(3000)
		$I = WinGetTitle("[active]")
msgbox(0, "simplehider", $I & ": is ready to be hided.")


endselect

$title = $I
While 1
	Sleep(100)
WEnd

Func Form1Close()
Exit
EndFunc
Func Form1Maximize()

EndFunc
Func Form1Minimize()

EndFunc
Func Form1Restore()
	
endfunc

Func hideClick()
WinSetState($Title, "", @SW_HIDE)
EndFunc
Func minimizeClick()
WinSetState("Simplehider", "", @SW_MINIMIZE)


EndFunc
Func show()
WinSetState($Title, "", @SW_SHOW)
EndFunc
