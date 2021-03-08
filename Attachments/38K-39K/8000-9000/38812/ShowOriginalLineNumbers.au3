#include <File.au3>

Local $sScriptPath = FileOpenDialog("select au3", @ScriptDir, "AutoIt3 Script (*.au3)", 3)
If @error Then Exit -1
If FileExists($sScriptPath & "_Debug.au3") Then
	FileDelete($sScriptPath & "_Debug.au3")
EndIf

Local $aLines, $sOutPut = "Global $__iLineNumber=0" & @CRLF
Local $blSkipNextLine = False
Local $iLine = 1, $sCurrentLine, $sFunc = "", $sIndent = ""

_FileReadToArray($sScriptPath, $aLines)

While $iLine <= $aLines[0]
	$sCurrentLine = $aLines[$iLine]
	$sLineStripWS = StringStripWS($aLines[$iLine], 3)

	If StringInStr($sLineStripWS, "#", 0, 1, 1, 1) Or StringInStr($sLineStripWS, ";", 0, 1, 1, 1) Or StringLen($sLineStripWS) = 0 Then
		$sOutPut &= $sCurrentLine & @CRLF
		$iLine += 1
		ContinueLoop
	EndIf

	If StringInStr($sLineStripWS, "Func", 0, 1, 1, 4) Then
		$sFunc = $sCurrentLine
	EndIf

	If $blSkipNextLine Then
		$blSkipNextLine = False
	Else
		$sIndent = ""
		While StringIsSpace(StringLeft($sCurrentLine, StringLen($sIndent) + 1))
			$sIndent = StringLeft($sCurrentLine, StringLen($sIndent) + 1)
		WEnd
		;$sOutPut &= "$__iLineNumber=" & $iLine & " & ': " & StringReplace($sCurrentLine, "'", '"') & "'" & @CRLF
		If $sFunc Then
			$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine & ' & " - " & "' & $sFunc & '"' & @CRLF
		Else
			$sOutPut &= $sIndent & "$__iLineNumber=" & $iLine & @CRLF
		EndIf
	EndIf

	$sOutPut &= $sCurrentLine & @CRLF

	If StringRight($sCurrentLine, 2) = " _" Then
		$blSkipNextLine = True
	EndIf

	$iLine += 1

	If StringInStr($sLineStripWS, "EndFunc", 0, 1, 1, 7) Then
		$sFunc = ""
	EndIf
WEnd

FileWrite($sScriptPath & "_Debug.au3", $sOutPut)