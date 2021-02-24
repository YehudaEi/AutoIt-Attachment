#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Form1", 243, 225, 192, 124)
$ListView1 = GUICtrlCreateListView("Col1|Col2", 13, 48, 220, 160, -1, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_SUBITEMIMAGES, $LVS_EX_INFOTIP))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 108)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 108)
For $i = 1 To 6
	GUICtrlCreateListViewItem("Item" & $i & "|Col2_" & $i, $ListView1)
Next
$Label1 = GUICtrlCreateLabel("WM_Notyfi movement keys", 56, 16, 134, 17)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func WM_NOTIFY($hWnd, $MsgID, $wParam, $lParam)
	Local $tagNMHDR, $event, $hwndFrom, $code
	$tagNMHDR = DllStructCreate("int;int;int", $lParam)
	If @error Then Return 0
	$code = DllStructGetData($tagNMHDR, 3)

	;	If $wParam = $ListView1 And $code = -12 Or $ListView1 And $code = -177 Then
	;		_Showmsg($code)
	;	Else
	;		ConsoleWrite("Code: " & $code & @LF)
	;	EndIf

	If $code <> -121 Then ConsoleWrite("Code: " & $code & @LF)

	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

Func _Showmsg($code)
	MsgBox(64, "Showmsg", "WM_Notyfi $ codde: " & $code)
EndFunc   ;==>_Showmsg
