#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <TabConstants.au3>
#include <WindowsConstants.au3>
#include <GUIListViewEx.au3>
#include <array.au3>

Opt("GUIOnEventMode", 1)
Opt("GUIResizeMode", 1)

Global $WM_DROPFILES = 0x233
Global $DropFilesArr[1]

Local $FileList, $CancelB, $TitleC


_GUICreate()
_SetOnEvents()

$sel_file_index = 0

While 1
	If _GUIListViewEx_WM_LBUTTONUP_Handler($FileList, "1","","") Then
		_File_Selected()
	EndIf
	Sleep(10)
WEnd

Func _GUICreate()
	#Region ### START Koda GUI section ### Form=Form2 (2).kxf
	$GUI = GUICreate("Akshay", 608, 376, -1, -1, -1, BitOR($WS_EX_ACCEPTFILES, ""))
	$TitleC = GUICtrlCreateCombo("", 74, 59, 256, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL, $WS_GROUP))
	$FileList = GUICtrlCreateListView("Name", 376, 8, 224, 360, BitOR($LVS_SHOWSELALWAYS, $WS_HSCROLL))
	GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_HEADERDRAGDROP, $LVS_EX_HEADERDRAGDROP)
	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
	GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 150)
	GUISetState(@SW_SHOW)
	GUIRegisterMsg($WM_DROPFILES, "WM_DROPFILES_FUNC")
	#EndRegion ### END Koda GUI section ###
EndFunc   ;==>_GUICreate

Func _GUIDelete()
	GUIDelete()
EndFunc   ;==>_GUIDelete

Func _Exit()
	Exit
EndFunc   ;==>_Exit

Func _SetOnEvents()
	GUISetOnEvent($GUI_EVENT_DROPPED, "_DragFileFill")
	GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
EndFunc   ;==>_SetOnEvents


Func _DragFileFill()
	$NotValidExtPath = ""
	$ValidExtCount = 0
	For $i = 1 To UBound($DropFilesArr) - 1
		$ValidExtCount += 1
		GUICtrlCreateListViewItem($DropFilesArr[$i], $FileList)
	Next
	If $ValidExtCount > 0 Then GUICtrlSendMsg($FileList, $LVM_SETCOLUMNWIDTH, 0, -1)
	_GUICtrlListView_SetItemSelected($FileList, 0)
EndFunc   ;==>_DragFileFill

Func _File_Selected()
	$sel_file_text = _GUICtrlListView_GetItemText($FileList, GUICtrlRead($FileList))
	GUICtrlSetData($TitleC, $sel_file_text)
EndFunc   ;==>_File_Selected

Func WM_DROPFILES_FUNC($hWnd, $msgID, $wParam, $lParam)
	Local $nSize, $pFileName
	Local $nAmt = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", 0xFFFFFFFF, "ptr", 0, "int", 255)
	For $i = 0 To $nAmt[0] - 1
		$nSize = DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", 0, "int", 0)
		$nSize = $nSize[0] + 1
		$pFileName = DllStructCreate("char[" & $nSize & "]")
		DllCall("shell32.dll", "int", "DragQueryFile", "hwnd", $wParam, "int", $i, "ptr", _
				DllStructGetPtr($pFileName), "int", $nSize)
		ReDim $DropFilesArr[$i + 2]
		$DropFilesArr[$i + 1] = DllStructGetData($pFileName, 1)
		$pFileName = 0
	Next
	$DropFilesArr[0] = UBound($DropFilesArr) - 1
EndFunc   ;==>WM_DROPFILES_FUNC

