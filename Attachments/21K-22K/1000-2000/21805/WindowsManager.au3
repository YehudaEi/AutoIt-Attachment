#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListBoxConstants.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

;==========================================================================
;Do Not Change
;==========================================================================
Global $CURSOR_TARGET = _WriteResource( _
		"0x000002000100202000000F001000300100001600000028000000200000004000000001000100000000008000" & _
		"00000000000000000000020000000200000000000000FFFFFF0000000000000000000000000000000000000000" & _
		"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
		"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
		"00000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFF83FFFFFE6CFFFFFD837FFFFBEFBFFFF783DFFFF7EFDFFFEAC6AFFFEABAAFFFE0280FFFEABAAFFFEAC6A" & _
		"FFFF7EFDFFFF783DFFFFBEFBFFFFD837FFFFE6CFFFFFF83FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFF")
Global $ICON_TARGET_FULL = _WriteResource( _
		"0x0000010001002020080000000000E80200001600000028000000200000004000000001000400000000000002" & _
		"000000000000000000001000000010000000000000000000800000800000008080008000000080008000808000" & _
		"00C0C0C00080808000FF0000FF0000000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000000000000000" & _
		"00000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFF00000FFFFFFFFFFFF000FFFFFFFFFF00FF0FF00FFFFFFFFFF000FF" & _
		"FFFFFFF0FF00000FF0FFFFFFFFF000FFFFFFFF0FFFFF0FFFFF0FFFFFFFF000FFFFFFF0FFFF00000FFFF0FFFFFF" & _
		"F000FFFFFFF0FFFFFF0FFFFFF0FFFFFFF000FFFFFF0F0F0FF000FF0F0F0FFFFFF000FFFFFF0F0F0F0FFF0F0F0F" & _
		"0FFFFFF000FFFFFF0000000F0F0000000FFFFFF000FFFFFF0F0F0F0FFF0F0F0F0FFFFFF000FFFFFF0F0F0FF000" & _
		"FF0F0F0FFFFFF000FFFFFFF0FFFFFF0FFFFFF0FFFFFFF000FFFFFFF0FFFF00000FFFF0FFFFFFF000FFFFFFFF0F" & _
		"FFFF0FFFFF0FFFFFFFF000FFFFFFFFF0FF00000FF0FFFFFFFFF000FFFFFFFFFF00FF0FF00FFFFFFFFFF000FFFF" & _
		"FFFFFFFF00000FFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0" & _
		"00FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000007770CCCCCCCCCCCCCCCCCCCC" & _
		"C07770007070CCCCCCCCCCCCCCCCCCCCC07070007770CCCCCCCCCCCCCCCCCCCCC0777000000000000000000000" & _
		"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
		"000000000000000000FFFFFFFF8000000080000000800000008000000080000000800000008000000080000000" & _
		"800000008000000080000000800000008000000080000000800000008000000080000000800000008000000080" & _
		"0000008000000080000000800000008000000080000000800000008000000080000000FFFFFFFFFFFFFFFFFFFF" & _
		"FFFF")
Global $ICON_TARGET_EMPTY = _WriteResource( _
		"0x0000010001002020080000000000E80200001600000028000000200000004000000001000400000000000002" & _
		"000000000000000000001000000010000000000000000000800000800000008080008000000080008000808000" & _
		"00C0C0C000808080000000FF0000FF000000FFFF00FF000000FF00FF00FFFF0000FFFFFF000000000000000000" & _
		"00000000000000000000000000000000000000000000000000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFF" & _
		"F000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFF" & _
		"FFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFF" & _
		"FFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFF" & _
		"FFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFF" & _
		"FFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000FFFFFFFFFFFFFFFFFFFFFFFFFFFFF0" & _
		"00FFFFFFFFFFFFFFFFFFFFFFFFFFFFF000000000000000000000000000000000007770CCCCCCCCCCCCCCCCCCCC" & _
		"C07770007070CCCCCCCCCCCCCCCCCCCCC07070007770CCCCCCCCCCCCCCCCCCCCC0777000000000000000000000" & _
		"000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
		"000000000000000000FFFFFFFF8000000080000000800000008000000080000000800000008000000080000000" & _
		"800000008000000080000000800000008000000080000000800000008000000080000000800000008000000080" & _
		"0000008000000080000000800000008000000080000000800000008000000080000000FFFFFFFFFFFFFFFFFFFF" & _
		"FFFF")
Global $g_StartSearch = False, $gFoundWindow = 0, $gOldCursor
Global $WM_MOUSEMOVE = 0x200
Global $WM_LBUTTONUP = 0x202
$hTargetCursor = DllCall("User32.dll", "int", "LoadCursorFromFile", "str", $CURSOR_TARGET)
$hTargetCursor = $hTargetCursor[0]
#Region ### START Koda GUI section ### Form=

$Form1 = GUICreate("Windows Manager", 607, 415, -1, -1)
$List1 = GUICtrlCreateList("", 8, 40, 265, 357)
$var = WinList()

For $i = 1 To $var[0][0]
	; Only display visble windows that have a title
	If $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
		GUICtrlSetData($List1, $var[$i][0])
	EndIf
Next

$Label1 = GUICtrlCreateLabel("Window Titles:", 8, 16, 74, 17)

$Group1 = GUICtrlCreateGroup("Window Options/Customize", 304, 40, 281, 189, BitOR($BS_RIGHT, $BS_FLAT))
GUICtrlSetFont(-1, 9, 400, 0, "Lucida Console")
$Input1 = GUICtrlCreateInput("", 384, 112, 65, 20, $ES_NUMBER)
$Input2 = GUICtrlCreateInput("", 384, 136, 65, 20, $ES_NUMBER)
$Input3 = GUICtrlCreateInput("", 384, 160, 65, 20, $ES_NUMBER)
$Input4 = GUICtrlCreateInput("", 384, 184, 65, 20, $ES_NUMBER)
$hTargetPic = GUICtrlCreateIcon($ICON_TARGET_FULL, 0, 456, 112, 32, 32, BitOR($SS_NOTIFY, $WS_GROUP))
$Combo1 = GUICtrlCreateCombo("", 456, 160, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Pixels|Percent", "Pixels")
$Combo2 = GUICtrlCreateCombo("", 456, 184, 89, 25, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Pixels|Percent", "Pixels")

$Label2 = GUICtrlCreateLabel("Position X", 328, 112, 55, 16)
$Label3 = GUICtrlCreateLabel("Position Y", 328, 136, 55, 16)
$Label4 = GUICtrlCreateLabel("Width", 328, 160, 39, 16)
$Label5 = GUICtrlCreateLabel("Height", 328, 184, 46, 16)

$Center_Button = GUICtrlCreateButton("Center", 312, 64, 54, 17, 0)
$Activate_Button = GUICtrlCreateButton("Activate", 371, 64, 70, 17, 0)
$Minimize_Button = GUICtrlCreateButton("Minimize", 446, 64, 70, 17, 0)
$Close_Button = GUICtrlCreateButton("Close", 520, 64, 59, 17, 0)
$Rename_Button = GUICtrlCreateButton("Rename", 312, 84, 54, 17, 0)
$Min_All_Button = GUICtrlCreateButton("Minimize All", 446, 84, 70, 17, 0)
$Set_Button = GUICtrlCreateButton("Set", 384, 208, 65, 17, 0)
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Label6 = GUICtrlCreateLabel("", 304, 4, 279, 32)
GUICtrlSetFont(-1, 10, 600, 0, "Arial")

$Rename_Input = GUICtrlCreateInput("", 304, 4, 100, 20)
GUICtrlSetState(-1, $GUI_HIDE)
$Rename_OK = GUICtrlCreateButton("OK", 406, 4, 30, 20, 0)
GUICtrlSetState(-1, $GUI_HIDE)
$Rename_CN = GUICtrlCreateButton("Cancel", 440, 4, 54, 20, 0)
GUICtrlSetState(-1, $GUI_HIDE)

$Group2 = GUICtrlCreateGroup("Window Information", 304, 232, 281, 165, BitOR($BS_RIGHT, $BS_FLAT))
GUICtrlSetFont(-1, 9, 400, 0, "Lucida Console")
$Edit1 = GUICtrlCreateEdit("", 320, 256, 249, 129, BitOR($ES_READONLY, $ES_WANTRETURN), 0)
GUICtrlSetData(-1, "")
GUICtrlCreateGroup("", -99, -99, 1, 1)

$Refresh_Button = GUICtrlCreateButton("Refresh", 234, 8, 47, 25, $BS_CENTER)
GUISetState(@SW_SHOW)


GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_MOUSEMOVE, "WM_MOUSEMOVE_FUNC")
GUIRegisterMsg($WM_LBUTTONUP, "WM_LBUTTONUP_FUNC")

;==========================================================================
;Gets Rid of the program manager and start items. if any
;==========================================================================
$num = _GUICtrlListBox_FindString($List1, "Program Manager", True)
_GUICtrlListBox_DeleteString($List1, $num)
$num = _GUICtrlListBox_FindString($List1, "Start", True)
_GUICtrlListBox_DeleteString($List1, $num)
_GUICtrlListBox_SetCurSel($List1, 0)
$aItems = _GUICtrlListBox_GetCurSel($List1)
$bItems = _GUICtrlListBox_GetText($List1, $aItems)
GUICtrlSetData($Label6, $bItems)
CheckWindows()
#EndRegion ### START Koda GUI section ### Form=

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hTargetPic
			$g_StartSearch = True
			DllCall("user32.dll", "hwnd", "SetCapture", "hwnd", $Form1)
			$gOldCursor = DllCall("user32.dll", "int", "SetCursor", "int", $hTargetCursor)
			If Not @error Then $gOldCursor = $gOldCursor[0]
			GUICtrlSetImage($hTargetPic, $ICON_TARGET_EMPTY)
		Case $Rename_Button
			GUICtrlSetState($Rename_OK, $GUI_SHOW)
			GUICtrlSetState($Rename_OK, $GUI_FOCUS)
			GUICtrlSetState($Rename_Input, $GUI_SHOW)
			GUICtrlSetState($Rename_Input, $GUI_FOCUS)
			GUICtrlSetState($Rename_CN, $GUI_SHOW)
			GUICtrlSetState($Label6, $GUI_HIDE)
		Case $Rename_OK
			$a_Title = GUICtrlRead($Label6)
			$c_Title = GUICtrlRead($Rename_Input)
			If $c_Title <> "" Then
			WinSetTitle($a_Title, '', $c_Title)
			GUICtrlSetState($Rename_Input, $GUI_HIDE)
			GUICtrlSetState($Rename_CN, $GUI_HIDE)
			GUICtrlSetState($Rename_OK, $GUI_HIDE)
			GUICtrlSetState($Label6, $GUI_SHOW)
			GUICtrlSetData($Label6, $c_Title)
			GUICtrlSetData($Rename_Input, "")
			CheckWindows()
		Else
			EndIf
		Case $Rename_CN
			GUICtrlSetState($Rename_Input, $GUI_HIDE)
			GUICtrlSetState($Rename_CN, $GUI_HIDE)
			GUICtrlSetState($Rename_OK, $GUI_HIDE)
			GUICtrlSetState($Label6, $GUI_SHOW)
			GUICtrlSetData($Rename_Input, "")
			CheckWindows()
		Case $Center_Button
			$a_Title = GUICtrlRead($Label6)
			$a_Pos = WinGetPos($a_Title)
			$x = (@DesktopWidth / 2) - ($a_Pos[2] / 2)
			$y = (@DesktopHeight / 2) - ($a_Pos[3] / 2)
			GUICtrlSetData($Input1, $x)
			GUICtrlSetData($Input2, $y)
			WinMove($a_Title, '', $x, $y)
		Case $Activate_Button
			$a_Title = GUICtrlRead($Label6)
			WinActivate($a_Title)
		Case $Minimize_Button
			$a_Title = GUICtrlRead($Label6)
			WinSetState($a_Title, '', @SW_MINIMIZE)
		Case $Min_All_Button
			$count = _GUICtrlListBox_GetCount($List1)
			For $C = 0 to $count
				$a_Title = _GUICtrlListBox_GetText($List1, $C)
				If $a_Title = "Windows Manager" Then
					Else
				WinSetState($a_Title, '', @SW_MINIMIZE)
				EndIf
			Next
		Case $Refresh_Button
			CheckWindows()
		Case $Close_Button
			$a_Title = GUICtrlRead($Label6)
			WinClose($a_Title)
			CheckWindows()
		Case $Set_Button
			$a_Title = GUICtrlRead($Label6)
			$x = GUICtrlRead($Input1)
			$y = GUICtrlRead($Input2)
			If GUICtrlRead($Input3) <> "" Then
				If GUICtrlRead($Input4) <> "" Then
					If GUICtrlRead($Combo1) = "Pixels" Then
						$w = GUICtrlRead($Input3)
						WinMove($a_Title, '', $x, $y, $w)
					ElseIf GUICtrlRead($Combo1) = "Percent" Then
						$w = @DesktopWidth * (GUICtrlRead($Input3) / 100)
						WinMove($a_Title, '', $x, $y, $w)
					EndIf
					If GUICtrlRead($Combo2) = "Pixels" Then
						$h = GUICtrlRead($Input4)
						WinMove($a_Title, '', $x, $y, $w, $h)
					ElseIf GUICtrlRead($Combo2) = "Percent" Then
						$h = @DesktopHeight * (GUICtrlRead($Input4) / 100)
						WinMove($a_Title, '', $x, $y, $w, $h)
					EndIf
				EndIf
			EndIf
			WinMove($a_Title, '', $x, $y)
	EndSwitch
WEnd
Func CheckWindows()
	_GUICtrlListBox_ResetContent($List1)
	$var = WinList()

	For $i = 1 To $var[0][0]
		; Only display visble windows that have a title
		If $var[$i][0] <> "" And IsVisible($var[$i][1]) Then
			GUICtrlSetData($List1, $var[$i][0])
		EndIf
	Next
	$num = _GUICtrlListBox_FindString($List1, "Program Manager", True)
	_GUICtrlListBox_DeleteString($List1, $num)
	$num = _GUICtrlListBox_FindString($List1, "Start", True)
	_GUICtrlListBox_DeleteString($List1, $num)
	$aItems = _GUICtrlListBox_GetCurSel($List1)
	$bItems = _GUICtrlListBox_GetText($List1, $aItems)
EndFunc   ;==>CheckWindows

Func IsVisible($handle)
	If BitAND(WinGetState($handle), 2) Then
		Return 1
	Else
		Return 0
	EndIf

EndFunc   ;==>IsVisible

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode
	$hWndList = GUICtrlGetHandle($List1)
	$hWndFrom = $ilParam
	$iIDFrom = _WinAPI_LoWord($iwParam)
	$iCode = _WinAPI_HiWord($iwParam)
	Switch $hWndFrom
		Case $hWndList
			Switch $iCode
				Case $LBN_SELCHANGE
					$aItems = _GUICtrlListBox_GetCurSel($hWndList)
					$bItems = _GUICtrlListBox_GetText($hWndList, $aItems)
					If WinExists($bItems) Then
						GUICtrlSetData($Label6, $bItems)
						$size = WinGetPos($bItems)
						GUICtrlSetData($Edit1, "Title: " & @TAB & $bItems & @CRLF & _
								"Size: " & @TAB & $size[2] & ", " & $size[3] & @CRLF & _
								"Pos: " & @TAB & $size[0] & ", " & $size[1] & @CRLF & _
								"Handle: " & @TAB & WinGetHandle($bItems))
					Else
						CheckWindows()
					EndIf
				Case $LBN_DBLCLK
					$a_Title = GUICtrlRead($Label6)
					WinActivate($a_Title)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

Func _WriteResource($sbStringRes)
	Local $sTempFile
	Do
		$sTempFile = @TempDir & "\temp" & Hex(Random(0, 65535), 4)
	Until Not FileExists($sTempFile)
	Local $hFile = FileOpen($sTempFile, 2 + 16)
	FileWrite($hFile, $sbStringRes)
	FileClose($hFile)
	Return $sTempFile
EndFunc   ;==>_WriteResource

Func WM_MOUSEMOVE_FUNC($hWnd, $nMsg, $wParam, $lParam)
	If Not $g_StartSearch Then Return 1
	Local $mPos = MouseGetPos()
	$hWndUnder = DllCall("user32.dll", "hwnd", "WindowFromPoint", "long", $mPos[0], "long", $mPos[1])
	If Not @error Then $hWndUnder = $hWndUnder[0]
	$r = MouseGetPos()
	GUICtrlSetData($Input1, $r[0])
	GUICtrlSetData($Input2, $r[1])
	$gFoundWindow = $hWndUnder
	Return 1
EndFunc   ;==>WM_MOUSEMOVE_FUNC


Func WM_LBUTTONUP_FUNC($hWnd, $nMsg, $wParam, $lParam)
	If Not $g_StartSearch Then Return 1
	$g_StartSearch = False
	; Release captured cursor
	DllCall("user32.dll", "int", "ReleaseCapture")
	DllCall("user32.dll", "int", "SetCursor", "int", $gOldCursor)
	GUICtrlSetImage($hTargetPic, $ICON_TARGET_FULL)
	;    MsgBox (0, "title", "text")
	Return 1
EndFunc   ;==>WM_LBUTTONUP_FUNC