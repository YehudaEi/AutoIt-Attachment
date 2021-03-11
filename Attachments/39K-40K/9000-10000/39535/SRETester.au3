; Credit to Szhlopp for the bulk of this work.
; Credit to w0uter for the original GUI layout.

#AutoIt3Wrapper_Res_FileVersion=2.2.0.0
#AutoIt3Wrapper_Au3Check_Parameters=-q -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_res_requestedExecutionLevel=asInvoker
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#Obfuscator_Ignore_Funcs=__IEInternalErrorHandler
#AutoIt3Wrapper_Run_After=del "%scriptdir%\%scriptfile%_Obfuscated.au3"
Opt("MustDeclareVars", 1)

#include <GUIConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <IE.au3>
#include <Date.au3>

Global $CurrentInput, $SREMode = 0, $SREFlag = 0
Global $HSRECombo, $HError, $HExtended, $HOutput
Global $HSRERCombo, $HSRERReplace, $HSRERCount

Main()

Func Main()
	Local $MainGUI = GUICreate("String Regular Expression Tester", 632, 648)
	;
	Local $hFileMenu = GUICtrlCreateMenu("File")
	Local $hTest = GUICtrlCreateMenuItem("Test RegEx" & @TAB & "Ctrl+T", $hFileMenu)
	GUICtrlCreateMenuItem("", $hFileMenu)
	Local $hExit = GUICtrlCreateMenuItem("Exit" & @TAB & "Ctrl+W", $hFileMenu)
	Local $hEditMenu = GUICtrlCreateMenu("Edit")
	Local $hCopy = GUICtrlCreateMenuItem("Copy RegEx" & @TAB & "Ctrl+S", $hEditMenu)
	Local $hCopyReplace = GUICtrlCreateMenuItem("Copy RegEx Replace" & @TAB & "Ctrl+R", $hEditMenu)
	GUICtrlSetState(-1, $GUI_DISABLE)
	;
	Local $HTabMain = GUICtrlCreateTab(5, 5, 620, 210)
	;
	GUICtrlCreateTabItem("Test text")
	Local $hInput1 = GUICtrlCreateEdit("", 10, 32, 608, 176)
	GUICtrlSetLimit(-1, 1000000)
	$CurrentInput = $hInput1
	;
	GUICtrlCreateTabItem("Load file to test")
	Local $LoadFileButton = GUICtrlCreateButton("Open", 15, 45, 60, 20)
	Local $FileLoadedInput = GUICtrlCreateInput("", 90, 45, 528, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $hInput2 = GUICtrlCreateEdit("", 10, 72, 608, 136)
	;
	GUICtrlCreateTabItem("Get website text/HTML")
	Local $WebTextButton = GUICtrlCreateButton("Text", 15, 45, 60, 20)
	Local $WebHTMLButton = GUICtrlCreateButton("HTML", 85, 45, 60, 20)
	Local $WebADDRInput = GUICtrlCreateInput("FULL ADDR HERE", 160, 45, 458, 20)
	Local $hInput3 = GUICtrlCreateEdit("", 10, 72, 608, 136)
	;
	GUICtrlCreateTabItem("Notes")
	Local $LoadFileButton_Notes = GUICtrlCreateButton("Open", 15, 45, 60, 20)
	Local $SaveFileButton_Notes = GUICtrlCreateButton("Save", 90, 45, 60, 20)
	Local $FileLoadedInput_Notes = GUICtrlCreateInput("", 170, 45, 448, 20)
	GUICtrlSetState(-1, $GUI_DISABLE)
	Local $hInput_Notes = GUICtrlCreateEdit(";;; Personal notepad to store anything you want ;;;" & @CRLF, 10, 72, 608, 136)
	;
	GUICtrlCreateTabItem("AutoIt")
	Local $LoadFileButton_AutoIt = GUICtrlCreateButton("Open file", 15, 45, 60, 20)
	Local $SaveFileButton_AutoIt = GUICtrlCreateButton("Save file", 90, 45, 60, 20)
	Local $OpenInScite_AutoIt = GUICtrlCreateButton("SciTE", 165, 45, 60, 20)
	Local $RunButton_AutoIt = GUICtrlCreateButton("Run Script", 240, 45, 60, 20)
	Local $RegExButton_AutoIt = GUICtrlCreateButton("Generate RegEx Code", 315, 45, 120, 20)
	Local $hInput_AutoIt = GUICtrlCreateEdit("; Open, edit or run scripts from here. Default save Location is in ScriptDir\AutoItCode.au3." & @CRLF, 10, 72, 608, 136)
	;
	GUICtrlCreateTabItem("")
	;
	GUICtrlCreateGroup("Pattern", 5, 217, 620, 60)
	$HSRECombo = GUICtrlCreateInput("(.*)", 84, 235, 527, 32)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Reference Sans Serif")
	Local $ButtonTest = GUICtrlCreateButton("Test", 18, 237, 55, 27, 0)
	$HSRERCombo = GUICtrlCreateInput("(.*)", 84, 235, 367, 32)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Reference Sans Serif")
	GUICtrlSetState(-1, $GUI_HIDE)
	$HSRERReplace = GUICtrlCreateInput("", 455, 235, 100, 32)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Reference Sans Serif")
	GUICtrlSetState(-1, $GUI_HIDE)
	$HSRERCount = GUICtrlCreateInput("0", 565, 235, 50, 32)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Reference Sans Serif")
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	;
	GUICtrlCreateGroup("Type", 5, 292, 125, 73)
	Local $HRadioSRE = GUICtrlCreateRadio("StringRegEx", 10, 308, 82, 23)
	GUICtrlSetState(-1, $GUI_CHECKED)
	Local $HRadioSRER = GUICtrlCreateRadio("RegExpReplace", 10, 331, 96, 23)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	;
	GUICtrlCreateGroup("Flag", 5, 370, 125, 138)
	Local $HRadioF0 = GUICtrlCreateRadio("0: True/False", 10, 388, 82, 23)
	GUICtrlSetTip(-1, "Returns 1 (match) or 0 (no match).")
	GUICtrlSetState(-1, $GUI_CHECKED)
	Local $HRadioF1 = GUICtrlCreateRadio("1: Array of matches", 10, 411, 112, 23)
	GUICtrlSetTip(-1, "Return array of matches.")
	Local $HRadioF2 = GUICtrlCreateRadio("2: Array (Perl / PHP)", 10, 433, 112, 23)
	GUICtrlSetTip(-1, "Return array of matches including the full match (Perl / PHP style).")
	Local $HRadioF3 = GUICtrlCreateRadio("3: Global matches", 10, 455, 112, 23)
	GUICtrlSetTip(-1, "Return array of global matches.")
	Local $HRadioF4 = GUICtrlCreateRadio("4: A/A (Perl / PHP)", 10, 477, 112, 23)
	GUICtrlSetTip(-1, "Return an array of arrays containing global matches including the full match (Perl / PHP style).")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	;
	GUICtrlCreateGroup("Return Values", 5, 514, 125, 68)
	GUICtrlCreateLabel("@Error", 13, 532, 37, 17)
	GUICtrlSetColor(-1, 0x3399FF)
	GUICtrlCreateLabel("@Extended", 58, 532, 60, 17)
	GUICtrlSetColor(-1, 0x3399FF)
	$HError = GUICtrlCreateInput("", 13, 552, 37, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$HExtended = GUICtrlCreateInput("", 62, 552, 52, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	;
	$HOutput = GUICtrlCreateEdit("", 135, 284, 490, 339, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
	GUICtrlSetBkColor(-1, 0xFFFFFF)
	Local $ButtonHelp = GUICtrlCreateButton("Help!", 10, 591, 112, 30, 0)
	;
	Local $hSelAll = GUICtrlCreateDummy()

	; accelerators
	Local $accel[5][2] = [["^t", $ButtonTest], ["^s", $hCopy], ["^r", $hCopyReplace], ["^w", $hExit], ["^a", $hSelAll]]
	GUISetAccelerators($accel)

	GUISetState(@SW_SHOW)

	Local $FileSaved = False, $aTime[5], $aTime2, $iDateCalc
	Local $Address, $sPattern, $sReplace, $iCount, $helppath, $oIE

	While 1
		If $FileSaved And WinActive($MainGUI) Then
			$aTime2 = FileGetTime(@ScriptDir & '\AutoItCode.au3')
			$iDateCalc = _DateDiff('s', $aTime[0] & "/" & $aTime[1] & "/" & $aTime[2] & " " & $aTime[3] & ":" & $aTime[4] & ":" & $aTime[5], $aTime2[0] & "/" & $aTime2[1] & "/" & $aTime2[2] & " " & $aTime2[3] & ":" & $aTime2[4] & ":" & $aTime2[5])
			If $iDateCalc >= 1 Then
				GUICtrlSetData($hInput_AutoIt, FileRead(@ScriptDir & '\AutoItCode.au3'))
				$FileSaved = False
			Else
				$FileSaved = False
			EndIf
		EndIf

		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE, $hExit
				Exit
			Case $LoadFileButton
				$Address = FileOpenDialog("Open a file to test", @WorkingDir, "Text Related (*.*)")
				If @error <> 1 Then GUICtrlSetData($hInput2, FileRead($Address))
				GUICtrlSetData($FileLoadedInput, $Address)
			Case $LoadFileButton_Notes
				$Address = FileOpenDialog("Open a file to test", @WorkingDir, "Text Related (*.*)")
				If @error <> 1 Then GUICtrlSetData($hInput_Notes, FileRead($Address))
				GUICtrlSetData($FileLoadedInput_Notes, $Address)
			Case $SaveFileButton_Notes
				$Address = FileSaveDialog("Save Notes", @WorkingDir, "Text (*.txt)", 16)
				If StringRight($Address, 4) <> ".txt" Then $Address &= ".txt"
				FileDelete($Address)
				FileWrite($Address, GUICtrlRead($hInput_Notes))
			Case $LoadFileButton_AutoIt
				$Address = FileOpenDialog("Open a file to test", @WorkingDir, "Text Related (*.*)")
				If @error <> 1 Then GUICtrlSetData($hInput_AutoIt, FileRead($Address))
			Case $SaveFileButton_AutoIt
				$Address = FileSaveDialog("Save Script", @WorkingDir, "Au3 (*.au3)", 16)
				If StringRight($Address, 4) <> ".au3" Then $Address &= ".au3"
				FileDelete($Address)
				FileWrite($Address, GUICtrlRead($hInput_AutoIt))
			Case $OpenInScite_AutoIt
				FileDelete(@ScriptDir & '\AutoItCode.au3')
				FileWrite(@ScriptDir & '\AutoItCode.au3', GUICtrlRead($hInput_AutoIt))
				ShellExecute(@ScriptDir & '\AutoItCode.au3', "", "", "Open")
				$aTime = FileGetTime(@ScriptDir & '\AutoItCode.au3')
				$FileSaved = True
				Sleep(1000)
			Case $RunButton_AutoIt
				FileDelete(@ScriptDir & '\AutoItCode.au3')
				FileWrite(@ScriptDir & '\AutoItCode.au3', GUICtrlRead($hInput_AutoIt))
				ShellExecute(@ScriptDir & '\AutoItCode.au3', "", "", "Run")
			Case $RegExButton_AutoIt
				If $SREMode = 0 Then
					$sPattern = GUICtrlRead($HSRECombo)
					GUICtrlSetData($HOutput, "StringRegExp($Value, " & '"' & $sPattern & '"' & ", " & $SREFlag & ")")
				Else
					$sPattern = GUICtrlRead($HSRERCombo)
					$sReplace = GUICtrlRead($HSRERReplace)
					$iCount = GUICtrlRead($HSRERCount)
					GUICtrlSetData($HOutput, "StringRegExpReplace($Value, " & '"' & $sPattern & '"' & ", " & '"' & $sReplace & '"' & ", " & $iCount & ")")
				EndIf
			Case $HTabMain
				Switch GUICtrlRead($HTabMain)
					Case 0
						$CurrentInput = $hInput1
					Case 1
						$CurrentInput = $hInput2
					Case 2
						$CurrentInput = $hInput3
						GUICtrlSetState($WebADDRInput, $GUI_FOCUS)
						GUICtrlSendMsg($WebADDRInput, $EM_SETSEL, 0, -1)
				EndSwitch
			Case $HRadioSRE
				$SREMode = 0
				GUICtrlSetState($HRadioF0, $GUI_ENABLE)
				GUICtrlSetState($HRadioF1, $GUI_ENABLE)
				GUICtrlSetState($HRadioF2, $GUI_ENABLE)
				GUICtrlSetState($HRadioF3, $GUI_ENABLE)
				GUICtrlSetState($HRadioF4, $GUI_ENABLE)
				GUICtrlSetState($HSRERCombo, $GUI_HIDE)
				GUICtrlSetState($HSRERReplace, $GUI_HIDE)
				GUICtrlSetState($HSRECombo, $GUI_SHOW)
				GUICtrlSetState($HSRERCount, $GUI_HIDE)
				GUICtrlSetState($hCopyReplace, $GUI_DISABLE)
			Case $HRadioSRER
				$SREMode = 1
				GUICtrlSetState($HRadioF0, $GUI_DISABLE)
				GUICtrlSetState($HRadioF1, $GUI_DISABLE)
				GUICtrlSetState($HRadioF2, $GUI_DISABLE)
				GUICtrlSetState($HRadioF3, $GUI_DISABLE)
				GUICtrlSetState($HRadioF4, $GUI_DISABLE)
				GUICtrlSetState($HSRECombo, $GUI_HIDE)
				GUICtrlSetState($HSRERCombo, $GUI_SHOW)
				GUICtrlSetState($HSRERReplace, $GUI_SHOW)
				GUICtrlSetState($HSRERCount, $GUI_SHOW)
				GUICtrlSetState($hCopyReplace, $GUI_ENABLE)
			Case $HRadioF0
				$SREFlag = 0
			Case $HRadioF1
				$SREFlag = 1
			Case $HRadioF2
				$SREFlag = 2
			Case $HRadioF3
				$SREFlag = 3
			Case $HRadioF4
				$SREFlag = 4
			Case $ButtonTest, $hTest
				SRE()
			Case $hCopy
				Switch $SREMode
					Case 0 ; regex
						ClipPut(GUICtrlRead($HSRECombo))
					Case 1 ; regex replace
						ClipPut(GUICtrlRead($HSRERCombo))
				EndSwitch
			Case $hCopyReplace
				If $SREMode = 1 Then
					ClipPut(GUICtrlRead($HSRERReplace))
				EndIf
			Case $ButtonHelp
				If @AutoItX64 Then
					$helppath = RegRead("HKLM\SOFTWARE\Wow6432Node\AutoIt v3\AutoIt", "InstallDir")
				Else
					$helppath = RegRead("HKLM\SOFTWARE\AutoIt v3\AutoIt", "InstallDir")
				EndIf
				Run('"' & $helppath & '\Autoit3Help.exe" StringRegExp')
				If @error Then MsgBox(16, "Error", "Cannot find help file.", 0, $MainGUI)
			Case $WebTextButton
				_IELoadWaitTimeout(30000)
				GUICtrlSetData($hInput3, "Please wait...")
				$oIE = _IECreate(GUICtrlRead($WebADDRInput), 0, 0)
				If @error = 6 Then
					GUICtrlSetData($hInput3, "Load Timeout")
				Else
					GUICtrlSetData($hInput3, _IEBodyReadText($oIE))
				EndIf
				_IEQuit($oIE)
			Case $WebHTMLButton
				_IELoadWaitTimeout(30000)
				GUICtrlSetData($hInput3, "Please wait...")
				$oIE = _IECreate(GUICtrlRead($WebADDRInput), 0, 0)
				If @error = 6 Then
					GUICtrlSetData($hInput3, "Load Timeout")
				Else
					GUICtrlSetData($hInput3, _IEBodyReadHTML($oIE))
				EndIf
				_IEQuit($oIE)
			Case $hSelAll
				Local $hControl = ControlGetHandle($MainGUI, "", "[CLASSNN:" & ControlGetFocus($MainGUI) & "]")
				If _WinAPI_GetClassName($hControl) = "Edit" Then
					GUICtrlSendMsg(_WinAPI_GetDlgCtrlID($hControl), $EM_SETSEL, 0, -1)
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Main

Func SRE()
	Local $sText, $sPattern, $Regex, $iError, $iExt, $RegExSize, $OutputString, $match
	Local $sReplace, $iCount, $sRegExR

	If $SREMode = 0 Then
		$sText = GUICtrlRead($CurrentInput)
		$sPattern = GUICtrlRead($HSRECombo)
		$Regex = StringRegExp($sText, $sPattern, $SREFlag)
		$iError = @error
		$iExt = @extended
		GUICtrlSetData($HError, $iError)
		GUICtrlSetData($HExtended, $iExt)

		If $SREFlag <= 3 Then
			$RegExSize = UBound($Regex)
			If @error = 1 Then
				GUICtrlSetData($HOutput, $Regex)
			Else
				$OutputString = ""
				For $I = 0 To $RegExSize - 1
					$OutputString &= "[" & $I & "] = " & $Regex[$I] & @CRLF
				Next
				GUICtrlSetData($HOutput, $OutputString)
			EndIf
		Else
			$OutputString = ""
			For $I = 0 To UBound($Regex) - 1
				$match = $Regex[$I]
				For $J = 0 To UBound($match) - 1
					$OutputString &= "[" & $I & "," & $J & "] = " & $match[$J] & @CRLF
				Next
			Next
			GUICtrlSetData($HOutput, $OutputString)
		EndIf

		If $iError = 2 Then
			GUICtrlSetData($HOutput, "Error in pattern. Character: " & $iExt - 2)
			GUICtrlSetState($HSRECombo, $GUI_FOCUS)
			GUICtrlSendMsg($HSRECombo, $EM_SETSEL, $iExt - 2, $iExt - 1)
		EndIf
	ElseIf $SREMode = 1 Then
		$sText = GUICtrlRead($CurrentInput)
		$sPattern = GUICtrlRead($HSRERCombo)
		$sReplace = GUICtrlRead($HSRERReplace)
		$iCount = GUICtrlRead($HSRERCount)
		$sRegExR = StringRegExpReplace($sText, $sPattern, $sReplace, $iCount)
		$iError = @error
		$iExt = @extended

		GUICtrlSetData($HError, $iError)
		GUICtrlSetData($HExtended, $iExt)
		GUICtrlSetData($HOutput, $sRegExR)

		If $iError = 2 Then
			GUICtrlSetData($HOutput, "Error in pattern. Character: " & $iExt - 2)
			GUICtrlSetState($HSRERCombo, $GUI_FOCUS)
			GUICtrlSendMsg($HSRERCombo, $EM_SETSEL, $iExt - 2, $iExt - 1)
		EndIf
	EndIf
EndFunc   ;==>SRE
