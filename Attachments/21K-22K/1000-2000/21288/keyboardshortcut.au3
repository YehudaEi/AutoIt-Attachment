#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Local $Label[12], $Input[12], $CancelButton[12], $hInput[12], $Button[12]
$settings = @ScriptDir & "\AutoSaved.kbsc"
$color = "0xFFFFFF"
$F1 = IniRead($settings, "Shortcut", "F1", "")
$F2 = IniRead($settings, "Shortcut", "F2", "")
$F3 = IniRead($settings, "Shortcut", "F3", "")
$F4 = IniRead($settings, "Shortcut", "F4", "")
$F5 = IniRead($settings, "Shortcut", "F5", "")
$F6 = IniRead($settings, "Shortcut", "F6", "")
$F7 = IniRead($settings, "Shortcut", "F7", "")
$F8 = IniRead($settings, "Shortcut", "F8", "")
$F9 = IniRead($settings, "Shortcut", "F9", "")
$F10 = IniRead($settings, "Shortcut", "F10", "")
$F11 = IniRead($settings, "Shortcut", "F11", "")
$RColor = IniRead($settings, "Shortcut", "BGColor", "0x00080")
$sColor = IniRead($settings, "Shortcut", "SColor", "0x223380")
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Keyboard Shortcuts", 405, 320, 193, 125)
GUISetBkColor($RColor)
GUISetFont(7, 400, 0, "Arial")
$x = 27
For $i = 1 To 9
	$Label[$i] = GUICtrlCreateLabel("F" & $i & ":", 10, $x, 45, 17, $SS_RIGHT)
	$x = $x + 24
Next
For $i = 10 To 11
	$Label[$i] = GUICtrlCreateLabel("F" & $i & ":", 5, $x, 50, 17, $SS_RIGHT)
	$x = $x + 24
Next
$Menu = GUICtrlCreateMenu("&File")
$Save = GUICtrlCreateMenuItem("&Save", $Menu)
$SaveAs = GUICtrlCreateMenuItem("&Save As...", $Menu)
$Load = GUICtrlCreateMenuItem("&Load", $Menu)
GUICtrlCreateMenuItem("", $Menu)
$Clear = GUICtrlCreateMenuItem("&Clear All", $Menu)
$Options = GUICtrlCreateMenu("&Options")
$KeyType = GUICtrlCreateMenu("&Key Type", $Options)
$Alt = GUICtrlCreateMenuItem("&Alt +", $KeyType, "1", 1)
$Ctrl = GUICtrlCreateMenuItem("&Ctrl +", $KeyType, "2", 1)
$Shift = GUICtrlCreateMenuItem("&Shift +", $KeyType, "3", 1)
$Plain = GUICtrlCreateMenuItem("&Plain", $KeyType, "3", 1)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateMenuItem("", $Options)
$bgcolor = GUICtrlCreateMenuItem("Random Background Color", $Options)
$View = GUICtrlCreateMenu("&View")
$sttng = GUICtrlCreateMenuItem("&Show Defalt Settings", $View)
;Short Name
GUICtrlCreateLabel("Short Name", 64, 8, 50, 17)
GUICtrlSetColor(-1, "0xFFFFFF")
$Input[1] = GUICtrlCreateInput(_GetShortName($F1), 56, 16 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[2] = GUICtrlCreateInput(_GetShortName($F2), 56, 40 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[3] = GUICtrlCreateInput(_GetShortName($F3), 56, 64 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[4] = GUICtrlCreateInput(_GetShortName($F4), 56, 88 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[5] = GUICtrlCreateInput(_GetShortName($F5), 56, 112 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[6] = GUICtrlCreateInput(_GetShortName($F6), 56, 136 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[7] = GUICtrlCreateInput(_GetShortName($F7), 56, 160 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[8] = GUICtrlCreateInput(_GetShortName($F8), 56, 184 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[9] = GUICtrlCreateInput(_GetShortName($F9), 56, 208 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[10] = GUICtrlCreateInput(_GetShortName($F10), 56, 232 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$Input[11] = GUICtrlCreateInput(_GetShortName($F11), 56, 256 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetState($Input[1], $GUI_Disable)
GUICtrlSetState($Input[2], $GUI_Disable)
GUICtrlSetState($Input[3], $GUI_Disable)
GUICtrlSetState($Input[4], $GUI_Disable)
GUICtrlSetState($Input[5], $GUI_Disable)
GUICtrlSetState($Input[6], $GUI_Disable)
GUICtrlSetState($Input[7], $GUI_Disable)
GUICtrlSetState($Input[8], $GUI_Disable)
GUICtrlSetState($Input[9], $GUI_Disable)
GUICtrlSetState($Input[10], $GUI_Disable)
GUICtrlSetState($Input[11], $GUI_Disable)
;Long Name
GUICtrlCreateLabel("Long Name", 250, 8, 50, 17)
GUICtrlSetColor(-1, "0xFFFFFF")
$hInput[1] = GUICtrlCreateInput($F1, 235 + 8, 16 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[2] = GUICtrlCreateInput($F2, 235 + 8, 40 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[3] = GUICtrlCreateInput($F3, 235 + 8, 64 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[4] = GUICtrlCreateInput($F4, 235 + 8, 88 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[5] = GUICtrlCreateInput($F5, 235 + 8, 112 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[6] = GUICtrlCreateInput($F6, 235 + 8, 136 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[7] = GUICtrlCreateInput($F7, 235 + 8, 160 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[8] = GUICtrlCreateInput($F8, 235 + 8, 184 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[9] = GUICtrlCreateInput($F9, 235 + 8, 208 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[10] = GUICtrlCreateInput($F10, 235 + 8, 232 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
$hInput[11] = GUICtrlCreateInput($F11, 235 + 8, 256 + 8, 100, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetState($hInput[1], $GUI_Disable)
GUICtrlSetState($hInput[2], $GUI_Disable)
GUICtrlSetState($hInput[3], $GUI_Disable)
GUICtrlSetState($hInput[4], $GUI_Disable)
GUICtrlSetState($hInput[5], $GUI_Disable)
GUICtrlSetState($hInput[6], $GUI_Disable)
GUICtrlSetState($hInput[7], $GUI_Disable)
GUICtrlSetState($hInput[8], $GUI_Disable)
GUICtrlSetState($hInput[9], $GUI_Disable)
GUICtrlSetState($hInput[10], $GUI_Disable)
GUICtrlSetState($hInput[11], $GUI_Disable)
;Edit/Add Buttons
$Button[1] = GUICtrlCreateButton("Edit", 158 + 8, 16 + 8, 65, 21, 0)
$Button[2] = GUICtrlCreateButton("Edit", 158 + 8, 40 + 8, 65, 21, 0)
$Button[3] = GUICtrlCreateButton("Edit", 158 + 8, 64 + 8, 65, 21, 0)
$Button[4] = GUICtrlCreateButton("Edit", 158 + 8, 88 + 8, 65, 21, 0)
$Button[5] = GUICtrlCreateButton("Edit", 158 + 8, 112 + 8, 65, 21, 0)
$Button[6] = GUICtrlCreateButton("Edit", 158 + 8, 136 + 8, 65, 21, 0)
$Button[7] = GUICtrlCreateButton("Edit", 158 + 8, 160 + 8, 65, 21, 0)
$Button[8] = GUICtrlCreateButton("Edit", 158 + 8, 184 + 8, 65, 21, 0)
$Button[9] = GUICtrlCreateButton("Edit", 158 + 8, 208 + 8, 65, 21, 0)
$Button[10] = GUICtrlCreateButton("Edit", 158 + 8, 232 + 8, 65, 21, 0)
$Button[11] = GUICtrlCreateButton("Edit", 158 + 8, 256 + 8, 65, 21, 0)
$y = 16 + 8
For $i = 1 To 11
	$CancelButton[$i] = GUICtrlCreateButton("Delete", 344 + 8, $y, 40, 21)
	$y = $y + 24
Next
GUISetState(@SW_SHOW)
_ChangeLabelColor($sColor)
#EndRegion ### START Koda GUI section ### Form=
HotKeySet("{F1}", "_F1")
HotKeySet("{F2}", "_F2")
HotKeySet("{F3}", "_F3")
HotKeySet("{F4}", "_F4")
HotKeySet("{F5}", "_F5")
HotKeySet("{F6}", "_F6")
HotKeySet("{F7}", "_F7")
HotKeySet("{F8}", "_F8")
HotKeySet("{F9}", "_F9")
HotKeySet("{F10}", "_F10")
HotKeySet("{F11}", "_F11")
While 1
	$nMsg = GUIGetMsg()
	_AutoSave()
	If $nMsg = $Alt Then
		If BitAND(GUICtrlRead($Alt), $GUI_CHECKED) = $GUI_CHECKED Then
			HotKeySet("{F1}")
			HotKeySet("{F2}")
			HotKeySet("{F3}")
			HotKeySet("{F4}")
			HotKeySet("{F5}")
			HotKeySet("{F6}")
			HotKeySet("{F7}")
			HotKeySet("{F8}")
			HotKeySet("{F9}")
			HotKeySet("{F10}")
			HotKeySet("{F11}")
			HotKeySet("!{F1}", "_F1")
			HotKeySet("!{F2}", "_F2")
			HotKeySet("!{F3}", "_F3")
			HotKeySet("!{F4}", "_F4")
			HotKeySet("!{F5}", "_F5")
			HotKeySet("!{F6}", "_F6")
			HotKeySet("!{F7}", "_F7")
			HotKeySet("!{F8}", "_F8")
			HotKeySet("!{F9}", "_F9")
			HotKeySet("!{F10}", "_F10")
			HotKeySet("!{F11}", "_F11")
			_ChangeLabelData("Alt + ")
		EndIf
	EndIf
	If $nMsg = $Ctrl Then
		If BitAND(GUICtrlRead($Ctrl), $GUI_CHECKED) = $GUI_CHECKED Then
			HotKeySet("{F1}")
			HotKeySet("{F2}")
			HotKeySet("{F3}")
			HotKeySet("{F4}")
			HotKeySet("{F5}")
			HotKeySet("{F6}")
			HotKeySet("{F7}")
			HotKeySet("{F8}")
			HotKeySet("{F9}")
			HotKeySet("{F10}")
			HotKeySet("{F11}")
			HotKeySet("^{F1}", "_F1")
			HotKeySet("^{F2}", "_F2")
			HotKeySet("^{F3}", "_F3")
			HotKeySet("^{F4}", "_F4")
			HotKeySet("^{F5}", "_F5")
			HotKeySet("^{F6}", "_F6")
			HotKeySet("^{F7}", "_F7")
			HotKeySet("^{F8}", "_F8")
			HotKeySet("^{F9}", "_F9")
			HotKeySet("^{F10}", "_F10")
			HotKeySet("^{F11}", "_F11")
			_ChangeLabelData("Ctrl + ")
		EndIf
	EndIf
	If $nMsg = $Shift Then
		If BitAND(GUICtrlRead($Shift), $GUI_CHECKED) = $GUI_CHECKED Then
			HotKeySet("{F1}")
			HotKeySet("{F2}")
			HotKeySet("{F3}")
			HotKeySet("{F4}")
			HotKeySet("{F5}")
			HotKeySet("{F6}")
			HotKeySet("{F7}")
			HotKeySet("{F8}")
			HotKeySet("{F9}")
			HotKeySet("{F10}")
			HotKeySet("{F11}")
			HotKeySet("+{F1}", "_F1")
			HotKeySet("+{F2}", "_F2")
			HotKeySet("+{F3}", "_F3")
			HotKeySet("+{F4}", "_F4")
			HotKeySet("+{F5}", "_F5")
			HotKeySet("+{F6}", "_F6")
			HotKeySet("+{F7}", "_F7")
			HotKeySet("+{F8}", "_F8")
			HotKeySet("+{F9}", "_F9")
			HotKeySet("+{F10}", "_F10")
			HotKeySet("+{F11}", "_F11")
			_ChangeLabelData("Shift + ")
		EndIf
	EndIf
	If $nMsg = $Plain Then
		If BitAND(GUICtrlRead($Plain), $GUI_CHECKED) = $GUI_CHECKED Then
			HotKeySet("{F1}")
			HotKeySet("{F2}")
			HotKeySet("{F3}")
			HotKeySet("{F4}")
			HotKeySet("{F5}")
			HotKeySet("{F6}")
			HotKeySet("{F7}")
			HotKeySet("{F8}")
			HotKeySet("{F9}")
			HotKeySet("{F10}")
			HotKeySet("{F11}")
			HotKeySet("{F1}", "_F1")
			HotKeySet("{F2}", "_F2")
			HotKeySet("{F3}", "_F3")
			HotKeySet("{F4}", "_F4")
			HotKeySet("{F5}", "_F5")
			HotKeySet("{F6}", "_F6")
			HotKeySet("{F7}", "_F7")
			HotKeySet("{F8}", "_F8")
			HotKeySet("{F9}", "_F9")
			HotKeySet("{F10}", "_F10")
			HotKeySet("{F11}", "_F11")
			_ChangeLabelData("")
		EndIf
	EndIf

	If Not FileExists($settings) Then
		For $i = 1 To 11
			IniWrite($settings, "Shortcut", "F" & $i, "")
		Next
	EndIf
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Save
			_SaveShortcuts()
		Case $SaveAs
			_SaveAsShortcuts()
		Case $Load
			_LoadShortcuts()
		Case $bgcolor
			$RColor = Random(0xDDDDDD, 0x2B1B1B1, 0)
			GUISetBkColor($RColor)
			$sColor = $RColor - 0x111111
			_ChangeLabelColor($sColor)
			_SaveShortcuts()
		Case $sttng
			ShellExecute($settings)
		Case $Clear
			For $o = 1 To 11
				GUICtrlSetData($Input[$o], "")
				GUICtrlSetData($hInput[$o], "")
				IniWrite($settings, "Shortcut", "F" & $o, "")
			Next
			_ChangeLabelColor()
		Case $Button[1]
			$F1 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[1], _GetShortName($F1))
				GUICtrlSetData($hInput[1], $F1)
			EndIf
			IniWrite($settings, "Shortcut", "F1", $F1)
			_ChangeLabelColor()
		Case $Button[2]
			$F2 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[2], _GetShortName($F2))
				GUICtrlSetData($hInput[2], $F2)
			EndIf
			IniWrite($settings, "Shortcut", "F2", $F2)
			_ChangeLabelColor()
		Case $Button[3]
			$F3 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[3], _GetShortName($F3))
				GUICtrlSetData($hInput[3], $F3)
			EndIf
			IniWrite($settings, "Shortcut", "F3", $F3)
			_ChangeLabelColor()
		Case $Button[4]
			$F4 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[4], _GetShortName($F4))
				GUICtrlSetData($hInput[4], $F4)
			EndIf
			IniWrite($settings, "Shortcut", "F4", $F4)
			_ChangeLabelColor()
		Case $Button[5]
			$F5 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[5], _GetShortName($F5))
				GUICtrlSetData($hInput[5], $F5)
			EndIf
			IniWrite($settings, "Shortcut", "F5", $F5)
			_ChangeLabelColor()
		Case $Button[6]
			$F6 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[6], _GetShortName($F6))
				GUICtrlSetData($hInput[6], $F6)
			EndIf
			IniWrite($settings, "Shortcut", "F6", $F6)
			_ChangeLabelColor()
		Case $Button[7]
			$F7 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[7], _GetShortName($F7))
				GUICtrlSetData($hInput[7], $F7)
			EndIf
			IniWrite($settings, "Shortcut", "F7", $F7)
			_ChangeLabelColor()
		Case $Button[8]
			$F8 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[8], _GetShortName($F8))
				GUICtrlSetData($hInput[8], $F8)
			EndIf
			IniWrite($settings, "Shortcut", "F8", $F8)
			_ChangeLabelColor()
		Case $Button[9]
			$F9 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[9], _GetShortName($F9))
				GUICtrlSetData($hInput[9], $F9)
			EndIf
			IniWrite($settings, "Shortcut", "F9", $F9)
			_ChangeLabelColor()
		Case $Button[10]
			$F10 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[10], _GetShortName($F10))
				GUICtrlSetData($hInput[10], $F10)
			EndIf
			IniWrite($settings, "Shortcut", "F10", $F10)
			_ChangeLabelColor()
		Case $Button[11]
			$F11 = FileOpenDialog("Application", @ProgramFilesDir, "Applications (*.exe)|All Files (*.*)")
			If @error Then
			Else
				GUICtrlSetData($Input[11], _GetShortName($F11))
				GUICtrlSetData($hInput[11], $F11)
			EndIf
			IniWrite($settings, "Shortcut", "F11", $F11)
			_ChangeLabelColor()
		Case $CancelButton[1]
			GUICtrlSetData($Input[1], "")
			GUICtrlSetData($hInput[1], "")
			IniWrite($settings, "Shortcut", "F1", "")
			_ChangeLabelColor()
		Case $CancelButton[2]
			GUICtrlSetData($Input[2], "")
			GUICtrlSetData($hInput[2], "")
			IniWrite($settings, "Shortcut", "F2", "")
			_ChangeLabelColor()
		Case $CancelButton[3]
			GUICtrlSetData($Input[3], "")
			GUICtrlSetData($hInput[3], "")
			IniWrite($settings, "Shortcut", "F3", "")
			_ChangeLabelColor()
		Case $CancelButton[4]
			GUICtrlSetData($Input[4], "")
			GUICtrlSetData($hInput[4], "")
			IniWrite($settings, "Shortcut", "F4", "")
			_ChangeLabelColor()
		Case $CancelButton[5]
			GUICtrlSetData($Input[5], "")
			GUICtrlSetData($hInput[5], "")
			IniWrite($settings, "Shortcut", "F5", "")
			_ChangeLabelColor()
		Case $CancelButton[6]
			GUICtrlSetData($Input[6], "")
			GUICtrlSetData($hInput[6], "")
			IniWrite($settings, "Shortcut", "F6", "")
			_ChangeLabelColor()
		Case $CancelButton[7]
			GUICtrlSetData($Input[7], "")
			GUICtrlSetData($hInput[7], "")
			IniWrite($settings, "Shortcut", "F7", "")
			_ChangeLabelColor()
		Case $CancelButton[8]
			GUICtrlSetData($Input[8], "")
			GUICtrlSetData($hInput[8], "")
			IniWrite($settings, "Shortcut", "F8", "")
			_ChangeLabelColor()
		Case $CancelButton[9]
			GUICtrlSetData($Input[9], "")
			GUICtrlSetData($hInput[9], "")
			IniWrite($settings, "Shortcut", "F9", "")
			_ChangeLabelColor()
		Case $CancelButton[10]
			GUICtrlSetData($Input[10], "")
			GUICtrlSetData($hInput[10], "")
			IniWrite($settings, "Shortcut", "F10", "")
			_ChangeLabelColor()
		Case $CancelButton[11]
			GUICtrlSetData($Input[11], "")
			GUICtrlSetData($hInput[11], "")
			IniWrite($settings, "Shortcut", "F11", "")
			_ChangeLabelColor()
			
	EndSwitch
WEnd
Func _F1()
	$READ = GUICtrlRead($hInput[1])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F1
Func _F2()
	$READ = GUICtrlRead($hInput[2])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F2

Func _F3()
	$READ = GUICtrlRead($hInput[3])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F3

Func _F4()
	$READ = GUICtrlRead($hInput[4])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F4

Func _F5()
	$READ = GUICtrlRead($hInput[5])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F5

Func _F6()
	$READ = GUICtrlRead($hInput[6])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F6

Func _F7()
	$READ = GUICtrlRead($hInput[7])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F7

Func _F8()
	$READ = GUICtrlRead($hInput[8])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F8

Func _F9()
	$READ = GUICtrlRead($hInput[9])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F9

Func _F10()
	$READ = GUICtrlRead($hInput[10])
	If $READ = "" Then
		
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F10

Func _F11()
	$READ = GUICtrlRead($hInput[11])
	If $READ = "" Then
	Else
		Run($READ)
	EndIf
EndFunc   ;==>_F11

Func _GetShortName($hData)
	$H = StringSplit($hData, "\")
	$S = $H[$H[0]]
	$hNewData = StringSplit($S, ".")
	Return $hNewData[1]
EndFunc   ;==>_GetShortName

Func _ChangeLabelColor($hColor = 0x223380)
	For $q = 1 To 11
		If GUICtrlRead($Input[$q]) = "" Then
			GUICtrlSetColor($Label[$q], $hColor)
			GUICtrlSetState($CancelButton[$q], $GUI_HIDE)
			GUICtrlSetData($Button[$q], "+ Add")
		Else
			GUICtrlSetColor($Label[$q], "0xFFFFFF")
			GUICtrlSetState($CancelButton[$q], $GUI_Show)
			GUICtrlSetData($Button[$q], "<< Edit >>")
		EndIf
	Next
EndFunc   ;==>_ChangeLabelColor

Func _ChangeLabelData($hText)
	For $i = 1 To 11
		GUICtrlSetData($Label[$i], $hText & "F" & $i & ":")
	Next
EndFunc   ;==>_ChangeLabelData
Func _SaveShortcuts()
	$SaveShortcuts = $settings
	IniWrite($SaveShortcuts, "Shortcut", "F1", $F1)
	IniWrite($SaveShortcuts, "Shortcut", "F2", $F2)
	IniWrite($SaveShortcuts, "Shortcut", "F3", $F3)
	IniWrite($SaveShortcuts, "Shortcut", "F4", $F4)
	IniWrite($SaveShortcuts, "Shortcut", "F5", $F5)
	IniWrite($SaveShortcuts, "Shortcut", "F6", $F6)
	IniWrite($SaveShortcuts, "Shortcut", "F7", $F7)
	IniWrite($SaveShortcuts, "Shortcut", "F8", $F8)
	IniWrite($SaveShortcuts, "Shortcut", "F9", $F9)
	IniWrite($SaveShortcuts, "Shortcut", "F10", $F10)
	IniWrite($SaveShortcuts, "Shortcut", "F11", $F11)
	IniWrite($SaveShortcuts, "Shortcut", "BGColor", $RColor)
	IniWrite($SaveShortcuts, "Shortcut", "SColor", $sColor)
EndFunc   ;==>_SaveShortcuts
Func _SaveAsShortcuts()
	$SaveShortcuts = FileSaveDialog("Save As...", @ScriptDir, "KeyBoard Shortcut Files (*.kbsc)")
	IniWrite($SaveShortcuts, "Shortcut", "F1", $F1)
	IniWrite($SaveShortcuts, "Shortcut", "F2", $F2)
	IniWrite($SaveShortcuts, "Shortcut", "F3", $F3)
	IniWrite($SaveShortcuts, "Shortcut", "F4", $F4)
	IniWrite($SaveShortcuts, "Shortcut", "F5", $F5)
	IniWrite($SaveShortcuts, "Shortcut", "F6", $F6)
	IniWrite($SaveShortcuts, "Shortcut", "F7", $F7)
	IniWrite($SaveShortcuts, "Shortcut", "F8", $F8)
	IniWrite($SaveShortcuts, "Shortcut", "F9", $F9)
	IniWrite($SaveShortcuts, "Shortcut", "F10", $F10)
	IniWrite($SaveShortcuts, "Shortcut", "F11", $F11)
	IniWrite($SaveShortcuts, "Shortcut", "BGColor", $RColor)
	IniWrite($SaveShortcuts, "Shortcut", "SColor", $sColor)
EndFunc   ;==>_SaveAsShortcuts
Func _LoadShortcuts()
	$LoadShortcuts = FileOpenDialog("Load...", @ScriptDir, "KeyBoard Shortcut Files (*.kbsc)")
	If @error Then
	Else
		$F1 = IniRead($LoadShortcuts, "Shortcut", "F1", "")
		$F2 = IniRead($LoadShortcuts, "Shortcut", "F2", "")
		$F3 = IniRead($LoadShortcuts, "Shortcut", "F3", "")
		$F4 = IniRead($LoadShortcuts, "Shortcut", "F4", "")
		$F5 = IniRead($LoadShortcuts, "Shortcut", "F5", "")
		$F6 = IniRead($LoadShortcuts, "Shortcut", "F6", "")
		$F7 = IniRead($LoadShortcuts, "Shortcut", "F7", "")
		$F8 = IniRead($LoadShortcuts, "Shortcut", "F8", "")
		$F9 = IniRead($LoadShortcuts, "Shortcut", "F9", "")
		$F10 = IniRead($LoadShortcuts, "Shortcut", "F10", "")
		$F11 = IniRead($LoadShortcuts, "Shortcut", "F11", "")
		$RColor = IniRead($LoadShortcuts, "Shortcut", "BGColor", "0x00080")
		$sColor = IniRead($LoadShortcuts, "Shortcut", "SColor", "0x223380")
		GUICtrlSetData($Input[1], _GetShortName($F1))
		GUICtrlSetData($Input[2], _GetShortName($F2))
		GUICtrlSetData($Input[3], _GetShortName($F3))
		GUICtrlSetData($Input[4], _GetShortName($F4))
		GUICtrlSetData($Input[5], _GetShortName($F5))
		GUICtrlSetData($Input[6], _GetShortName($F6))
		GUICtrlSetData($Input[7], _GetShortName($F7))
		GUICtrlSetData($Input[8], _GetShortName($F8))
		GUICtrlSetData($Input[9], _GetShortName($F9))
		GUICtrlSetData($Input[10], _GetShortName($F10))
		GUICtrlSetData($Input[11], _GetShortName($F11))
		GUICtrlSetData($hInput[1], $F1)
		GUICtrlSetData($hInput[2], $F2)
		GUICtrlSetData($hInput[3], $F3)
		GUICtrlSetData($hInput[4], $F4)
		GUICtrlSetData($hInput[5], $F5)
		GUICtrlSetData($hInput[6], $F6)
		GUICtrlSetData($hInput[7], $F7)
		GUICtrlSetData($hInput[8], $F8)
		GUICtrlSetData($hInput[9], $F9)
		GUICtrlSetData($hInput[10], $F10)
		GUICtrlSetData($hInput[11], $F11)
		_ChangeLabelColor()
	EndIf
EndFunc   ;==>_LoadShortcuts
Func _AutoSave()
	If @SEC = 00 Then
		WinSetTitle("Keyboard Shortcuts", "", "Keyboard Shortcuts (AutoSave)")
		IniWrite($settings, "Shortcut", "F1", $F1)
		IniWrite($settings, "Shortcut", "F2", $F2)
		IniWrite($settings, "Shortcut", "F3", $F3)
		IniWrite($settings, "Shortcut", "F4", $F4)
		IniWrite($settings, "Shortcut", "F5", $F5)
		IniWrite($settings, "Shortcut", "F6", $F6)
		IniWrite($settings, "Shortcut", "F7", $F7)
		IniWrite($settings, "Shortcut", "F8", $F8)
		IniWrite($settings, "Shortcut", "F9", $F9)
		IniWrite($settings, "Shortcut", "F10", $F10)
		IniWrite($settings, "Shortcut", "F11", $F11)
		IniWrite($settings, "Shortcut", "BGColor", $RColor)
		IniWrite($settings, "Shortcut", "SColor", $sColor)
		Sleep(1000)
		WinSetTitle("Keyboard Shortcuts (AutoSave)", "", "Keyboard Shortcuts")
	EndIf
EndFunc   ;==>_AutoSave