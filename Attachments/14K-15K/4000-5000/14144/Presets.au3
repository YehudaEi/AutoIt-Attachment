#include <GUIConstants.au3>
#include <GuiCombo.au3>
#include <File.au3>
Dim $newname

$window = GUICreate("New Preset", 343, 189, 354, 256)
$Name = GUICtrlCreateInput("Option you want to change here", 8, 56, 177, 21)
$Value = GUICtrlCreateInput("Value", 200, 56, 129, 21)
$Chooser = GUICtrlCreateCombo("New Preset", 96, 16, 161, 25)
$Add = GUICtrlCreateButton("Add", 90, 96, 81, 25, 0)
$Delete = GUICtrlCreateButton("Delete", 180, 96, 81, 25, 0)
$Exit = GUICtrlCreateButton("Exit", 120, 140, 100, 25, 0)

$filename = @ScriptDir & "\presets\names.txt"
$linenumber = 1
FileOpen($filename, 0)

While 1
	$line = FileReadLine($filename, $linenumber)
	If @error = -1 Then
		ExitLoop
	Else
	_GUICtrlComboAddString($Chooser, $line)
	$linenumber = $linenumber + 1
EndIf
WEnd


GUISetState(@SW_SHOW)
While 1
	$msg = GUIGetMsg()	
	If $msg  = $GUI_EVENT_CLOSE Then
		Exit
	EndIf
	If $msg  = $Exit Then
		Exit
	EndIf
	If $msg = $Delete Then
		$aQuick = GUICtrlRead($Chooser)
		$ret = _GUICtrlComboGetCurSel($Chooser)
		_FileWriteToLine($filename, _GUICtrlComboGetCurSel($Chooser), "", 1)
		_GUICtrlComboDeleteString($Chooser, $ret)
		_GUICtrlComboSetCurSel($Chooser, 0)
		If FileExists(@ScriptDir & "\presets\" & $aQuick & ".txt") Then
			FileDelete(@ScriptDir & "\presets\" & $aQuick & ".txt")
		EndIf
		GUICtrlSetData($Name, "Option you want to change here")
		GUICtrlSetData($Value, "Value")
	EndIf
		
	If $msg = $Add Then
		$Name1 = GUICtrlRead($Name)
		$Value1 = GUICtrlRead($Value)
		$option = GUICtrlRead($Chooser)
		If $option = "New Preset" Then
			$newname = InputBox("Name", "Please sleect a name for your new preset.", "", "", 100, 130)
			If @error = 1 Then
				Else
			FileWrite($filename, $newname & @CRLF)
			_GUICtrlComboInsertString($Chooser, 1, $newname)
			_GUICtrlComboSetCurSel($Chooser, 1)
			EndIf
		Else
			FileWrite(@ScriptDir & "\presets\" & $option & ".txt", 'user_pref("' & $Name1 & '", '& $Value1 & ');' & @CRLF)
		EndIf
		GUICtrlSetData($Name, "Option you want to change here")
		GUICtrlSetData($Value, "Value")
	EndIf
WEnd
