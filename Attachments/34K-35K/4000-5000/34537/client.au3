#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPConnect = TCPConnect(@IPAddress1, 1000)
If $TCPConnect = -1 Then Exit

$Form1 = GUICreate("Client", 152, 48, 192, 114)
$Slider1 = GUICtrlCreateSlider(0, 0, 150, 45)
GUICtrlSetLimit(-1, 100, 0)
GUICtrlSetData($Slider1, 50)
$hSlider = GUICtrlGetHandle(-1)
GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_HSCROLL, "hscroll")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func hscroll($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref
	Local $iVal
	If $ilParam = $hSlider Then
		$iVal = GUICtrlRead($Slider1)
		TCPSend($TCPConnect, String($iVal))
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc
