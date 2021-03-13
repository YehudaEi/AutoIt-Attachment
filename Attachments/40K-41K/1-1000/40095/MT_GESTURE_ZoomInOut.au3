#include <StructureConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>
#include <GuiEdit.au3>
#include <WinAPI.au3>
#include <StaticConstants.au3>
#RequireAdmin

Global $iMemo, $hLab
Global Const $WM_GESTURE = 0x119
Global Const $GID_BEGIN = 0x01
Global Const $GID_END = 0x02
Global Const $GID_ZOOM = 0x03

Local $hGUI

Global $old_ullArg = 0
Global $iFontSize = 9

Global Const $tagPOINTS = "struct;short X;short Y;endstruct"
Global Const $tagGESTUREINFO = "UINT cbSize; DWORD dwFlags; DWORD dwID; HWND hwndTarget;"  & $tagPOINTS &  ";DWORD dwInstanceID; DWORD dwSequenceID; UINT64 ullArgumengs; UINT cbExtraArgs"
_Main()

Func _Main()

    $hGUI = GUICreate("WM_GESTURE", 1080, 640)
    $iMemo = GUICtrlCreateEdit("", 10, 10, 300, 600, $WS_VSCROLL)
	_GUICtrlEdit_SetLimitText($iMemo, 0x80000000)
    GUICtrlSetFont($iMemo, 9, 400, 0, "Courier New")

	$hLab = GUICtrlCreateLabel("TEST",320,0,760,640,$SS_CENTER + $SS_CENTERIMAGE)
	GUICtrlSetFont(-1,$iFontSize)

    GUIRegisterMsg($WM_GESTURE, "WM_GESTURE")

    GUISetState()

    While 1
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop
        EndSwitch
    WEnd

    Exit

EndFunc   ;==>_Main

Func WM_GESTURE($hWnd, $Msg, $wParam, $lParam)

	$GesInfo = DllStructCreate($tagGESTUREINFO)
	DllStructSetData($GesInfo, "cbSize", DllStructGetSize($GesInfo))
	$pGesInfo = DllStructGetPtr($GesInfo)
	DllCall("User32.dll", "BOOL", "GetGestureInfo", "HANDLE", $lParam, "struct*", $pGesInfo)

	Local $dwID = DllStructGetData($GesInfo, "dwID")
	Local $ptsLocX = DllStructGetData($GesInfo, "X")
	Local $ptsLocY = DllStructGetData($GesInfo, "Y")
	Local $ullArg = DllStructGetData($GesInfo, "ullArgumengs")


	GUICtrlSetData($iMemo, "************************************" & @CRLF, 1)
	GUICtrlSetData($iMemo, "dwID: " & $dwID & @CRLF, 1)
    GUICtrlSetData($iMemo, "ptsLocation X: " & $ptsLocX & @CRLF, 1)
    GUICtrlSetData($iMemo, "ptsLocation Y: " & $ptsLocY & @CRLF, 1)
    GUICtrlSetData($iMemo, "ullArgumengs: " & $ullArg & @CRLF, 1)




	Switch $dwID
		Case $GID_BEGIN, $GID_END
			;Reset old_ullArg when event begins/ends
			$old_ullArg = 0
		Case $GID_ZOOM
			;only start the process if old_ullArg set before
			If $old_ullArg > 0 Then
				;if old_ullArg is smaller than new ullArg then start the zoom out process (font smaller)
				If $old_ullArg > $ullArg Then
					$iFontSize -= 4
					If $iFontSize < 1 Then $iFontSize = 1
					GUICtrlSetFont($hLab,$iFontSize)
				Else
					$iFontSize += 4
					GUICtrlSetFont($hLab,$iFontSize)
				EndIf
			EndIf
			$old_ullArg = $ullArg
	EndSwitch

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
