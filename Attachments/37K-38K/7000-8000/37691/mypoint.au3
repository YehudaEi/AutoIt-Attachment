#region
#AutoIt3Wrapper_Res_Fileversion=1.0
#AutoIt3Wrapper_Run_Obfuscator=y
#endregion


; Script Start - Add your code below here
#include <GuiComboBox.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <Array.au3>
#include <StaticConstants.au3>


SetIni()

; Run the GUI until the dialog is closed
While 1
	Switch GUIGetMsg()
		Case $fileitem
			Global $file = FileOpenDialog("Choose file...", @ScriptDir, "Scripts (*.mw3)")
			If @error Then ContinueCase
			ReadPID()
			ExtractKeys()
			SetComboBoxes()
		Case $GUI_EVENT_CLOSE, $CloseButton

			ExitLoop
		Case $Key1
			_GUICtrlComboBox_SetEditText($OomboBox1, "")
		Case $Key2
			_GUICtrlComboBox_SetEditText($OomboBox2, "")
		Case $Key3
			_GUICtrlComboBox_SetEditText($OomboBox3, "")
		Case $Key4
			_GUICtrlComboBox_SetEditText($OomboBox4, "")
		Case $Key5
			_GUICtrlComboBox_SetEditText($OomboBox5, "")
		Case $Key6
			_GUICtrlComboBox_SetEditText($OomboBox6, "")
		Case $Key7
			_GUICtrlComboBox_SetEditText($OomboBox7, "")
		Case $Key8
			_GUICtrlComboBox_SetEditText($OomboBox8, "")
		Case $Key9
			_GUICtrlComboBox_SetEditText($OomboBox9, "")
		Case $Key10
			_GUICtrlComboBox_SetEditText($OomboBox10, "")
		Case $Key11
			_GUICtrlComboBox_SetEditText($OomboBox11, "")
		Case $Key12
			_GUICtrlComboBox_SetEditText($OomboBox12, "")
		Case $Key13
			_GUICtrlComboBox_SetEditText($OomboBox13, "")
		Case $Key14
			_GUICtrlComboBox_SetEditText($OomboBox14, "")
		Case $Key15
			_GUICtrlComboBox_SetEditText($OomboBox15, "")
		Case $Key16
			_GUICtrlComboBox_SetEditText($OomboBox16, "")
		Case $CreateButton
			RunKeys()
			if ($defaultstatus = "PID: 625") then
;~ REPLACE 693 with 625 at $TESTTEMPLATE
				$NewFile = "Script_625_1.mw3"
			Else
				$NewFile = "Script_693_1.mw3"
			Endif
			Local $var = FileSaveDialog("Choose a name.", @DesktopDir, "Scripts (*.mw3)", "", $NewFile)
			FileChangeDir($DatabaseDir)
			FileMove($TestTemplate, $var, 1)
			If @error Then ContinueCase
			$outf = FileOpen($var, 1)
			_ReplaceStringInFile($outf, "625", "aaa")
			ExitLoop
		Case $PID693
			If BitAND(GUICtrlRead($PID693), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($PID693, $GUI_UNCHECKED)
				GUICtrlSetState($PID625, $GUI_CHECKED)
				$defaultstatus="PID: 625"
			Else
				GUICtrlSetState($PID693, $GUI_CHECKED)
				GUICtrlSetState($PID625, $GUI_UNCHECKED)
				$defaultstatus="PID: 693"
			EndIf
			GuiCtrlSetData($Statuslabel,$defaultstatus)
		Case $PID625
			If BitAND(GUICtrlRead($PID625), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($PID625, $GUI_UNCHECKED)
				GUICtrlSetState($PID693, $GUI_CHECKED)
				$defaultstatus="PID: 693"
			Else
				GUICtrlSetState($PID625, $GUI_CHECKED)
				GUICtrlSetState($PID693, $GUI_UNCHECKED)
				$defaultstatus="PID: 625"
			EndIf
			GuiCtrlSetData($Statuslabel,$defaultstatus)

		EndSwitch

WEnd
FileDelete("Script_693_1.mw3")
FileDelete("MicroFolderOnOff.mw3")
DelTempKeys()

;----------------------------------------
Func SetIni()
	Global $defaultstatus = "PID: 693"
	GUICreate("Xkeys Maker", 200, 640, 500, 10)
	$filemenu = GUICtrlCreateMenu("File")
	Global $fileitem = GUICtrlCreateMenuItem("Open", $filemenu)
	Global $helpmenu = GUICtrlCreateMenu("?")
	GUICtrlCreateMenuItem("", $filemenu, 2) ; create a separator line
	global $viewmenu = GUICtrlCreateMenu("Set PID", -1, 1) ; is created before "?" menu
	Global $PID693 = GUICtrlCreateMenuItem("PID: 693", $viewmenu)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Global $PID625 = GUICtrlCreateMenuItem("PID: 625", $viewmenu)
	GUICtrlSetState(-1, $GUI_UNCHECKED)
	Global $statuslabel = GUICtrlCreateLabel($defaultstatus, -1, 600, 300, 15, BitOR($SS_SIMPLE, $SS_SUNKEN))

	Global $CreateButton = GUICtrlCreateButton("Create", 10, 560, 80, 30)
	Global $CloseButton = GUICtrlCreateButton("Close", 110, 560, 80, 30)

	FileChangeDir(@WorkingDir & "\Xkeys DataBase")
	Global $DatabaseDir = @WorkingDir


	FileCopy("MicroFolderOnOff.bak", "MicroFolderOnOff.mw3", 1)

	SetKeyButtons()
	SetComboBoxes()
	GUISetState()

	Global $Dekay = 100

EndFunc   ;==>SetIni


;----------------------------------------
Func ReadPID()

	For $i = 1 To 20
		global $line = FileReadLine($file, $i)
		If StringInStr($line, "PID:")  Then
			$defaultstatus = StringTrimLeft($line, 2)
			ExitLoop
		EndIf
	Next

	if ($defaultstatus = "PID: 625") then
		GUICtrlSetState($PID693, $GUI_UNCHECKED)
		GUICtrlSetState($PID625, $GUI_CHECKED)
	Else
		GUICtrlSetState($PID693, $GUI_CHECKED)
		GUICtrlSetState($PID625, $GUI_UNCHECKED)
	EndIf
	GuiCtrlSetData($Statuslabel,$defaultstatus)
EndFunc   ;==>ReadPID



;----------------------------------------
Func ExtractKeys()
	Local $ButtonList[17] = ["'Button 001", "'Button 002", "'Button 003", "'Button 004", "'Button 005", "'Button 006", "'Button 007", "'Button 008", "'Button 009", "'Button 010", "'Button 011", "'Button 012", "'Button 013", "'Button 014", "'Button 015", "'Button 016", "'ProgSwitch"]
	Local $FileNames[16] = ["Button_001.mw3", "Button_002.mw3", "Button_003.mw3", "Button_004.mw3", "Button_005.mw3", "Button_006.mw3", "Button_007.mw3", "Button_008.mw3", "Button_009.mw3", "Button_010.mw3", "Button_011.mw3", "Button_012.mw3", "Button_013.mw3", "Button_014.mw3", "Button_015.mw3", "Button_016.mw3"]
	FileChangeDir($DatabaseDir)
	$flag = 0
	FileOpen($file, 0)

	For $i = 0 To 15
		$out = FileOpen($FileNames[$i], 2)

		For $x = 1 To _FileCountLines($file)
			$line = FileReadLine($file, $x)
			If (StringInStr($line, $ButtonList[$i + 1]) <> 0) Then $flag = 0
			If $flag Then FileWriteLine($out, $line)
			If (StringInStr($line, $ButtonList[$i]) <> 0) Then $flag = 1
		Next
		FileClose($file)
	Next

EndFunc   ;==>ExtractKeys


;----------------------------------------
Func DelTempKeys()
	Local $FileNames[16] = ["Button_001.mw3", "Button_002.mw3", "Button_003.mw3", "Button_004.mw3", "Button_005.mw3", "Button_006.mw3", "Button_007.mw3", "Button_008.mw3", "Button_009.mw3", "Button_010.mw3", "Button_011.mw3", "Button_012.mw3", "Button_013.mw3", "Button_014.mw3", "Button_015.mw3", "Button_016.mw3"]
	For $i = 0 To 15
		FileDelete($FileNames[$i])
	Next
EndFunc   ;==>DelTempKeys


;----------------------------------------
Func Replace($ToFile, $FromFile, $StringToReplace)
	Local $toReplace

	$toReplace = StringReplace(ReadFile($FromFile), "|", @CRLF)
	_ReplaceStringInFile($ToFile, $StringToReplace, $toReplace)

EndFunc   ;==>Replace


;----------------------------------------
Func RunKeys()

	FileCopy("Template.bak", "Script_693_1.mw3", 1)
	Global $TestTemplate = "Script_693_1.mw3"

	Local $EmptyScript = "Empty.bak"
	If Not (GUICtrlRead($MicroCode) == "") Then _ReplaceStringInFile("MicroFolderOnOff.mw3", "PROJECT_ID", GUICtrlRead($MicroCode))

	If Not (GUICtrlRead($OomboBox1) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox1), "'XkeysButton_01")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_01")
	EndIf
	If Not (GUICtrlRead($OomboBox2) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox2), "'XkeysButton_02")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_02")
	EndIf
	If Not (GUICtrlRead($OomboBox3) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox3), "'XkeysButton_03")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_03")
	EndIf
	If Not (GUICtrlRead($OomboBox4) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox4), "'XkeysButton_04")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_04")
	EndIf
	If Not (GUICtrlRead($OomboBox5) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox5), "'XkeysButton_05")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_05")
	EndIf
	If Not (GUICtrlRead($OomboBox6) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox6), "'XkeysButton_06")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_06")
	EndIf
	If Not (GUICtrlRead($OomboBox7) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox7), "'XkeysButton_07")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_07")
	EndIf
	If Not (GUICtrlRead($OomboBox8) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox8), "'XkeysButton_08")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_08")
	EndIf
	If Not (GUICtrlRead($OomboBox9) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox9), "'XkeysButton_09")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_09")
	EndIf
	If Not (GUICtrlRead($OomboBox10) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox10), "'XkeysButton_10")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_10")
	EndIf
	If Not (GUICtrlRead($OomboBox11) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox11), "'XkeysButton_11")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_11")
	EndIf
	If Not (GUICtrlRead($OomboBox12) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox12), "'XkeysButton_12")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_12")
	EndIf
	If Not (GUICtrlRead($OomboBox13) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox13), "'XkeysButton_13")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_13")
	EndIf
	If Not (GUICtrlRead($OomboBox14) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox14), "'XkeysButton_14")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_14")
	EndIf
	If Not (GUICtrlRead($OomboBox15) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox15), "'XkeysButton_15")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_15")
	EndIf
	If Not (GUICtrlRead($OomboBox16) == "") Then
		Replace($TestTemplate, GUICtrlRead($OomboBox16), "'XkeysButton_16")
	Else
		Replace($TestTemplate, $EmptyScript, "'XkeysButton_16")
	EndIf

EndFunc   ;==>RunKeys




;----------------------------------------
Func SetKeyButtons()

	Global $Key1 = GUICtrlCreateButton("Key1", 10, 20, 35, 25)
	Global $Key2 = GUICtrlCreateButton("Key2", 10, 50, 35, 25)
	Global $Key3 = GUICtrlCreateButton("Key3", 10, 80, 35, 25)
	Global $Key4 = GUICtrlCreateButton("Key4", 10, 110, 35, 25)
	Global $Key5 = GUICtrlCreateButton("Key5", 10, 140, 35, 25)
	Global $Key6 = GUICtrlCreateButton("Key6", 10, 170, 35, 25)
	Global $Key7 = GUICtrlCreateButton("Key7", 10, 200, 35, 25)
	Global $Key8 = GUICtrlCreateButton("Key8", 10, 230, 35, 25)
	Global $Key9 = GUICtrlCreateButton("Key9", 10, 260, 35, 25)
	Global $Key10 = GUICtrlCreateButton("Key10", 10, 290, 35, 25)
	Global $Key11 = GUICtrlCreateButton("Key11", 10, 320, 35, 25)
	Global $Key12 = GUICtrlCreateButton("Key12", 10, 350, 35, 25)
	Global $Key13 = GUICtrlCreateButton("Key13", 10, 380, 35, 25)
	Global $Key14 = GUICtrlCreateButton("Key14", 10, 410, 35, 25)
	Global $Key15 = GUICtrlCreateButton("Key15", 10, 440, 35, 25)
	Global $Key16 = GUICtrlCreateButton("Key16", 10, 470, 35, 25)

	Global $OomboBox1 = GUICtrlCreateCombo("", 60, 20, 120, 25)
	Global $OomboBox2 = GUICtrlCreateCombo("", 60, 50, 120, 25)
	Global $OomboBox3 = GUICtrlCreateCombo("", 60, 80, 120, 25)
	Global $OomboBox4 = GUICtrlCreateCombo("", 60, 110, 120, 25)
	Global $OomboBox5 = GUICtrlCreateCombo("", 60, 140, 120, 25)
	Global $OomboBox6 = GUICtrlCreateCombo("", 60, 170, 120, 25)
	Global $OomboBox7 = GUICtrlCreateCombo("", 60, 200, 120, 25)
	Global $OomboBox8 = GUICtrlCreateCombo("", 60, 230, 120, 25)
	Global $OomboBox9 = GUICtrlCreateCombo("", 60, 260, 120, 25)
	Global $OomboBox10 = GUICtrlCreateCombo("", 60, 290, 120, 25)
	Global $OomboBox11 = GUICtrlCreateCombo("", 60, 320, 120, 25)
	Global $OomboBox12 = GUICtrlCreateCombo("", 60, 350, 120, 25)
	Global $OomboBox13 = GUICtrlCreateCombo("", 60, 380, 120, 25)
	Global $OomboBox14 = GUICtrlCreateCombo("", 60, 410, 120, 25)
	Global $OomboBox15 = GUICtrlCreateCombo("", 60, 440, 120, 25)
	Global $OomboBox16 = GUICtrlCreateCombo("", 60, 470, 120, 25)

	Global $MicroCode = GUICtrlCreateInput("", 10, 520, 90, 25)
	GUICtrlCreateLabel("Microfolder Code", 105, 524)

EndFunc   ;==>SetKeyButtons


;----------------------------------------
Func SetComboBoxes()

	Global $FileList = _FileListToArray(@WorkingDir, "*.mw3")
	_ArrayDelete($FileList, 0)
	$FileList = _ArrayToString($FileList)

	_GUICtrlComboBox_ResetContent($OomboBox1)
	GUICtrlSetData($OomboBox1, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox2)
	GUICtrlSetData($OomboBox2, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox3)
	GUICtrlSetData($OomboBox3, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox4)
	GUICtrlSetData($OomboBox4, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox5)
	GUICtrlSetData($OomboBox5, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox6)
	GUICtrlSetData($OomboBox6, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox7)
	GUICtrlSetData($OomboBox7, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox8)
	GUICtrlSetData($OomboBox8, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox9)
	GUICtrlSetData($OomboBox9, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox10)
	GUICtrlSetData($OomboBox10, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox11)
	GUICtrlSetData($OomboBox11, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox12)
	GUICtrlSetData($OomboBox12, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox13)
	GUICtrlSetData($OomboBox13, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox14)
	GUICtrlSetData($OomboBox14, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox15)
	GUICtrlSetData($OomboBox15, $FileList)
	_GUICtrlComboBox_ResetContent($OomboBox16)
	GUICtrlSetData($OomboBox16, $FileList)

EndFunc   ;==>SetComboBoxes


;---------------------------------------
Func ReadFile($FileToRead)

	Local $ListProject

	If Not _FileReadToArray($FileToRead, $ListProject) Then
		MsgBox(4096, "", "error: " & @error)
		Exit
	EndIf

	_ArrayDelete($ListProject, 0)
	$ListProject = _ArrayToString($ListProject, "|")

	Return $ListProject

EndFunc   ;==>ReadFile

