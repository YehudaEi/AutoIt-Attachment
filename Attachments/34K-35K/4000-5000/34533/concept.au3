#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>

Opt("WinTitleMatchMode", 2)
$opacity = 255

$Form1 = GUICreate("No", @DesktopWidth, @DesktopHeight,0,0,$WS_POPUP,$WS_EX_TOPMOST)
$Graphic1 = GUICtrlCreateGraphic(0, 0, @DesktopWidth, @DesktopHeight)
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0x000000)
GUISetState()

$Form2 = GUICreate("Pay Attention", 155, 82, 0, 0, -1, $WS_EX_TOPMOST)
$Slider1 = GUICtrlCreateSlider(0, 32, 150, 45)
GUICtrlSetData($Slider1, 100)
$hSlider = GUICtrlGetHandle(-1)
GUICtrlSetLimit(-1, 100, 0)
$Label1 = GUICtrlCreateLabel("Opacity:", 5, 8, 106, 17)
$Label2 = GUICtrlCreateLabel("100%",120,8,30,17)
GUISetState()

WinSetTrans("No", "", $opacity)
GUIRegisterMsg($WM_HSCROLL, "WM_HSCROLL")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

GUIDelete()
GUIDelete()
MsgBox(0, "Messege from Konrad", "Thank you for your time :-)")

Func WM_HSCROLL($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref
    Local $iValue
    If $ilParam = $hSlider Then
        $iValue = GUICtrlRead($Slider1) & "%"
        GUICtrlSetData($Label2, $iValue)
        WinSetTrans($Form1, "", ($iValue / 100) * 255)
    EndIf
    Return "GUI_RUNDEFMSG"
EndFunc   ;==>WM_HSCROLL