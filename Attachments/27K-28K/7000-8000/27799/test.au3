#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3> ; used for Lo/Hi word
Opt("TrayIconDebug",1)
Opt("TrayIconHide",0)
dim $Input[1],$Updown[1]

$Form1_1 = GUICreate("ReDate", 161, 208, 192, 114, -1,  $WS_EX_ACCEPTFILES)
$Label1 = GUICtrlCreateLabel("&Years", 16, 8, 37, 17)
$Input[0] = GUICtrlCreateInput("2000", 72, 8, 72, 21, BitOR($ES_NUMBER, $ES_RIGHT))
$Updown[0] = GUICtrlCreateUpdown($Input[0])
GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE
GUIDelete()

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
    #forceref $hWnd, $iMsg
    Local $hWndFrom, $iIDFrom, $iCode, $hWndEdit
    If Not IsHWnd($Input[0]) Then $hWndAnno = GUICtrlGetHandle($Input[0])
    $hWndFrom = $ilParam
    $iIDFrom = _WinAPI_LoWord($iwParam)
    $iCode = _WinAPI_HiWord($iwParam)
    Switch $hWndFrom
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hWndAnno, $Input[0]
			if $iCode=$EN_CHANGE Then
					GUICtrlSetData($Input[0],StringFormat('%d', GUICtrlRead($Input[0])*1000))
			EndIf
	EndSwitch
EndFunc