#include <GUIConstants.au3>
#include <WindowsConstants.au3>
Global $WM_DROPFILES = 0x233
Global $gaDropFiles[1], $str = ""

### Koda GUI section start ###
$hGUI = GUICreate("Test", 400, 200, 219, 178, -1, BitOR($WS_EX_ACCEPTFILES, $WS_EX_TOPMOST))
$hList = GUICtrlCreateList("", 5, 5, 390, 190)
GUICtrlSetState (-1, $GUI_DROPACCEPTED)
GUISetState(@SW_SHOW)
### Koda GUI section end   ###

GUIRegisterMsg ($WM_DROPFILES, "WM_DROPFILES_UNICODE_FUNC")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
        Case $GUI_EVENT_DROPPED
            $str = ""
            For $i = 0 To UBound($gaDropFiles) - 1
               $str &= "|" & $gaDropFiles[$i]
            Next
            GUICtrlSetData($hList, $str)
	EndSwitch
WEnd

Func WM_DROPFILES_UNICODE_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("wchar[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFileW", "hwnd", $wParam, "int", $i, "int", DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $gaDropFiles[$i + 1]
		$gaDropFiles[$i] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
EndFunc   ;==>WM_DROPFILES_UNICODE_FUNC
