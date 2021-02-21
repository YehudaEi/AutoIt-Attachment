#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPConnect = TCPConnect(@IPAddress1, 1000)

$Form2 = GUICreate("Pay Attention", 167, 130, 192, 114, -1, $WS_EX_TOPMOST)
$Slider1 = GUICtrlCreateSlider(8, 32, 150, 45)
GUICtrlSetData($Slider1, 100)
$hSlider = GUICtrlGetHandle(-1)
GUICtrlSetLimit(-1, 100, 0)
$Label1 = GUICtrlCreateLabel("Opacity:", 8, 8, 109, 17)
$Label2 = GUICtrlCreateLabel("100%", 128, 8, 30, 17)
$Input1 = GUICtrlCreateInput("Please ignore the input...", 8, 80, 150, 21)
$Button1 = GUICtrlCreateButton("...and button", 8, 105, 150, 20)
GUISetState()

GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func WM_HSCROLL($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref
    Local $iValue
    Local $od
	If $ilParam = $hSlider Then
        $iValue = GUICtrlRead($Slider1) & "%"
        GUICtrlSetData($Label2, $iValue)
		$od = GUICtrlRead($Slider1)
		TCPSend($TCPConnect, String($od))
    EndIf
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_HSCROLL
