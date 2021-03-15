#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include "GUIConstants.au3"
#include "WindowsConstants.au3"
#include "Misc.au3"

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("ClickCounter", 317, 183, 350, 143)
$Button1 = GUICtrlCreateButton("+", 248, 80, 41, 33)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$Button2 = GUICtrlCreateButton("Start", 88, 80, 137, 33)
$Button4 = GUICtrlCreateButton("-", 16, 80, 49, 33)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel("0", 136, 16, 90, 35)
GUICtrlSetFont(-1, 20, 400, 0, "Times New Roman")
GUICtrlSetResizing(-1, $GUI_DOCKLEFT)
$Button5 = GUICtrlCreateButton("Clear", 104, 144, 105, 25)
GUISetState(@SW_SHOW)
WinSetOnTop ("ClickCounter" , "", 1)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $Button2
			_Func1()
		case $Button5
			$clicks = 0
			GUICtrlSetData($Label1,  $clicks)

	    case $Button1
			$clicks = $clicks + 1
			GUICtrlSetData($Label1,  $clicks)
		 case $Button4
			$clicks = $clicks - 1

			GUICtrlSetData($Label1,  $clicks)




	EndSwitch
WEnd
Func _Func1()
	GLobal $clicks
	While 1
;~
		If _IsPressed(01) Then
			$clicks += 1
			GUICtrlSetData($Label1,  $clicks)
			While _IsPressed(01)
				Sleep(1)
			WEnd

		EndIf

		if _IsPressed(04) Then ExitLoop

	WEnd
EndFunc
