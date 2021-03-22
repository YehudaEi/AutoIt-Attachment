#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7
#AutoIt3Wrapper_Version=B
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <FileConstants.au3>
#include <array.au3>


_main()
Func _main()
	Local $vAnswer = MsgBox($MB_YESNOCANCEL, 'What you want to analyze ?', 'Yes = Folder' & @CRLF & 'No = File')
	Switch $vAnswer
		Case $IDYES
			_Check_Local_In_Loop__Folder()
		Case $IDNO
			_Check_Local_In_Loop__File()
	EndSwitch
EndFunc   ;==>_main

Func _Check_Local_In_Loop__File()
	Local $hFile = FileOpenDialog('Select Au3 file to check', @ScriptDir, 'AutoIt3 Files (*.au3)', $FD_FILEMUSTEXIST)
	Local $sTextOut = _Check_Local_In_Loop_Check_File($hFile, True)
	ConsoleWrite(@CRLF & @CRLF)
	ConsoleWrite($sTextOut)
	ConsoleWrite(@CRLF & @CRLF)
	Local $vAnswer = MsgBox($MB_YESNO, 'Result', 'Do you want the following result copied to the clipboard ?' & @CRLF & @CRLF & $sTextOut)
	If $vAnswer = $IDYES Then ClipPut($sTextOut)

	$vAnswer = MsgBox($MB_YESNO, 'Result', 'Do you want open the following files ?' & @CRLF & @CRLF & $hFile)
	If $vAnswer = $IDYES Then ShellExecute($hFile)
EndFunc   ;==>_Check_Local_In_Loop__File

Func _Check_Local_In_Loop__Folder()
	Local $hFile = FileSelectFolder('Select folder with Au3 file to check', '', 4)
	Local $aAu3Files = _FileListToArray($hFile, '*.au3', 1, True)
	Local $sTextTemp = ''
	Local $sTextOut = ''
	For $File In $aAu3Files
		$sTextTemp = _Check_Local_In_Loop_Check_File($File, False)
		If $sTextTemp <> '' Then
			$sTextOut &= '======================================================' & @CRLF
			$sTextOut &= $File & @CRLF
			$sTextOut &= '======================================================' & @CRLF
			$sTextOut &= $sTextTemp
			$sTextOut &= '------------------------------------------------------' & @CRLF
		EndIf
	Next
	ConsoleWrite(@CRLF & @CRLF)
	ConsoleWrite($sTextOut)
	ConsoleWrite(@CRLF & @CRLF)
	Local $vAnswer
	$vAnswer = MsgBox($MB_YESNO, 'Result', 'Do you want the following result copied to the clipboard ?' & @CRLF & @CRLF & $sTextOut)
	If $vAnswer = $IDYES Then ClipPut($sTextOut)

	Local $aAu3FilesToFix = StringRegExp($sTextOut, '(?i)(?:\=*\r\n)(.*.au3)', 3)
	$vAnswer = MsgBox($MB_YESNO, 'Result', 'Do you want open the following files ?' & @CRLF & @CRLF & _ArrayToString($aAu3FilesToFix, @CRLF))
	If $vAnswer = $IDYES Then
		For $File In $aAu3FilesToFix
			ShellExecute($File)
		Next
	EndIf
EndFunc   ;==>_Check_Local_In_Loop__Folder

Func _Check_Local_In_Loop_Check_File($hFile, $fArrayDisplay = True)
	Local $sFileContent = FileRead($hFile)
	Local $sFileName = StringRegExpReplace($hFile, '.*\\', '')

	Local $sTextToFind = _Local_inside_Loop($sFileContent)
	Local $fContinue_EndFunc, $fContinue_Local, $fContinue_Wend, $fContinue_Until, $fContinue_Next
	Do
;~ 		ConsoleWrite(@CRLF)
		$fContinue_EndFunc = _Remove_Func_EndFunc($sTextToFind)
		$fContinue_Local = _Remove_Func_Local($sTextToFind)
		$fContinue_Wend = _Remove_While_Wend($sTextToFind)
		$fContinue_Until = _Remove_DO_UNTIL($sTextToFind)
		$fContinue_Next = _Remove_For_Next($sTextToFind)
	Until $fContinue_EndFunc = False And $fContinue_Local = False And $fContinue_Wend = False And $fContinue_Until = False And $fContinue_Next = False
;~ 	ClipPut($sTextToFind)
;~ 	MsgBox(1, 'Result', $sTextToFind)
	Local $sREGEXP = '', $sTextOut = ''

	$sREGEXP = '(?i)(While .*\r\n)((Local .*\r\n)+)()'
;~ 	$sREGEXP = '(?i)(While .*\r\n)((Local .*\r\n)+|(Global .*\r\n)+|(Dim .*\r\n)+|(Static .*\r\n)+)()'
	Local $aWhileWend = StringRegExp($sTextToFind, $sREGEXP, 3)
	If $fArrayDisplay = True Then _ArrayDisplay($aWhileWend, '$aWhileWend , $sFileName: ' & $sFileName)
	$sTextOut &= _ArrayToString($aWhileWend, @CRLF)

	$sREGEXP = '(?i)(Do\r\n|Do \;\V*\r\n)((Local .*\r\n)+)()'
;~ 	$sREGEXP = '(?i)(Do\r\n|Do \;\V*\r\n)((Local .*\r\n)+|(Global .*\r\n)+|(Dim .*\r\n)+|(Static .*\r\n)+)()'
	Local $aDoUntil = StringRegExp($sTextToFind, $sREGEXP, 3)
	If $fArrayDisplay = True Then _ArrayDisplay($aDoUntil, '$aDoUntil , $sFileName: ' & $sFileName)
	$sTextOut &= _ArrayToString($aDoUntil, @CRLF)

	$sREGEXP = '(?i)(For \$.*\r\n)((Local .*\r\n)+)()'
;~ 	$sREGEXP = '(?i)(For \$.*\r\n)((Local .*\r\n)+|(Global .*\r\n)+|(Dim .*\r\n)+|(Static .*\r\n)+)()'
	Local $aForNext = StringRegExp($sTextToFind, $sREGEXP, 3)
	If $fArrayDisplay = True Then _ArrayDisplay($aForNext, '$aForNext , $sFileName: ' & $sFileName)
	$sTextOut &= _ArrayToString($aForNext, @CRLF)

	Return SetError(1, 0, $sTextOut)
EndFunc   ;==>_Check_Local_In_Loop_Check_File

Func _Local_inside_Loop($sTEXT)
	Local $sREGEXP = '(?is)(?<=\r\n|^)(?:\s*?)(Func \V*|EndFunc\V*|While \V*|Wend\V*|Do(?=\r\n)|Do \;\V*|Until \V*|For \$\V*|Next\V*|Local \V*|Global \V*|Dim \V*|Static \V*)'
	Local $aTEXT = StringRegExp($sTEXT, $sREGEXP, 3)
	Return _ArrayToString($aTEXT, @CRLF)
EndFunc   ;==>_Local_inside_Loop

Func _Remove_Func_EndFunc(ByRef $sText)
	Local $fReturn_IsNotComplex = True
	Local $sREGEXP = '(?i)(Func \V*\r\n)(EndFunc\V*\r\n)'
	$sText = StringRegExpReplace($sText, $sREGEXP, '')
	If @error = 0 And @extended = 0 Then $fReturn_IsNotComplex = False
;~ 	ConsoleWrite('_Remove_Func_EndFunc $fReturn_IsNotComplex = ' & $fReturn_IsNotComplex & @CRLF)
	Return $fReturn_IsNotComplex
EndFunc   ;==>_Remove_Func_EndFunc

Func _Remove_Func_Local(ByRef $sText)
	Local $fReturn_IsNotComplex = True
	Local $sREGEXP = '(?i)(Func .*\r\n)((Local .*\r\n)+|(Static .*\r\n)+)'
	$sText = StringRegExpReplace($sText, $sREGEXP, '$1')
	If @error = 0 And @extended = 0 Then $fReturn_IsNotComplex = False
;~ 	ConsoleWrite('_Remove_Func_Local $fReturn_IsNotComplex = ' & $fReturn_IsNotComplex & @CRLF)
	Return $fReturn_IsNotComplex
EndFunc   ;==>_Remove_Func_Local

Func _Remove_While_Wend(ByRef $sText)
	Local $fReturn_IsNotComplex = True
	Local $sREGEXP = '(?i)(While \V*\r\n)(Wend\V*\r\n)'
	$sText = StringRegExpReplace($sText, $sREGEXP, '')
	If @error = 0 And @extended = 0 Then $fReturn_IsNotComplex = False
;~ 	ConsoleWrite('_Remove_While_Wend $fReturn_IsNotComplex = ' & $fReturn_IsNotComplex & @CRLF)
	Return $fReturn_IsNotComplex
EndFunc   ;==>_Remove_While_Wend

Func _Remove_DO_UNTIL(ByRef $sText)
	Local $fReturn_IsNotComplex = True
	Local $sREGEXP = '(?i)(Do\r\n|Do \;\V*\r\n)(Until \V*\r\n)'
	$sText = StringRegExpReplace($sText, $sREGEXP, '')
	If @error = 0 And @extended = 0 Then $fReturn_IsNotComplex = False
;~ 	ConsoleWrite('_Remove_DO_UNTIL $fReturn_IsNotComplex = ' & $fReturn_IsNotComplex & @CRLF)
	Return $fReturn_IsNotComplex
EndFunc   ;==>_Remove_DO_UNTIL

Func _Remove_For_Next(ByRef $sText)
	Local $fReturn_IsNotComplex = True
	Local $sREGEXP = '(?i)(For \$\V*\r\n)(Next\V*\r\n)'
	$sText = StringRegExpReplace($sText, $sREGEXP, '')
	If @error = 0 And @extended = 0 Then $fReturn_IsNotComplex = False
;~ 	ConsoleWrite('_Remove_For_Next $fReturn_IsNotComplex = ' & $fReturn_IsNotComplex & @CRLF)
	Return $fReturn_IsNotComplex
EndFunc   ;==>_Remove_For_Next

