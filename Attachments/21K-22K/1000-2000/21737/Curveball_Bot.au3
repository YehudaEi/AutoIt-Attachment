;---------------Minikori's Curveball Bot---------------;
;------For Curveball on www.albinoblacksheep.com-------;
;-------------Special Thanks to Luvmachine-------------;
#include <GUIConstants.au3>
#include <FF.au3>

Global $Paused

HotKeySet("{HOME}", "Start")
HotKeySet("{PAUSE}", "Pause")
HotKeySet("{END}", "Stop")

GUICreate("Curveball Bot Version 1.0", 295, 75)

GUICtrlCreateLabel("Click Roll to open up Curveball, or click Never Mind to exit.", 10, 10)
$OK = GUICtrlCreateButton("Roll", 75, 35, 65, 30)
$Cancel = GUICtrlCreateButton("Never Mind", 155, 35, 65, 30)

GUISetState()
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel Then
		Exit
	EndIf
	If $msg = $OK Then
		$Socket = _FFStart()
		If $Socket > -1 Then
			_FFOpenURL($Socket, "                                                ")
		EndIf
		ExitLoop
	EndIf
WEnd
GUIDelete()
MsgBox(0, "Hotkeys", "Hotkeys:" & @CR & "Start: Home" & @CR & "Pause: Pause|Break" & @CR & "Stop: End")

While 1
	Sleep(100)
WEnd

Func Start()
	$Ball = PixelSearch(340, 265, 810, 580, 0xE5FFDF, 10, 2)
	While 1
		If IsArray($Ball) = 1 Then
			$Ball = PixelSearch(($Ball[0] - 117), ($Ball[1] - 78), ($Ball[0] + 117), ($Ball[1] + 78), 0xE5FFDF, 10, 2)
			Sleep(1)
		EndIf
		If @error Then
			TrayTip("CurveBallBot", "Errored", 1000)
			Sleep(1000)
			Exit
		ElseIf IsArray($Ball) = 1 Then
			MouseMove($Ball[0], $Ball[1], 0)
		Else
			$Ball = PixelSearch(340, 265, 810, 580, 0xE5FFDF, 10, 2)
			If IsArray($Ball) = 1 Then
				MouseClick("left", $Ball[0], $Ball[1])
			EndIf
		EndIf
	WEnd
EndFunc

While 1
	Sleep(100)
WEnd

Func Pause()
    $Paused = NOT $Paused
    While $Paused
        ToolTip("Script is paused", 0, 0)
        sleep(100)
    ToolTip("")
	WEnd
EndFunc

While 1
	Sleep(100)
WEnd

Func Stop()
	Exit
EndFunc