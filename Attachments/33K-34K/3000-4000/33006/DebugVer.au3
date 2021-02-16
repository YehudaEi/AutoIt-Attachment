#NoTrayIcon
Opt('MustDeclareVars', 1)
Opt("WinTitleMatchMode", 4)
#include <File.au3>
#cs

	DebugVer.au3

	Create a debug version of a script.


	Syntax 1:
	AutoIt3 DebugIt.au3 yourscript.au3
	Syntax 2:
	DebugIt.exe yourscript.au3

	(If using Syntax 2, note that there may be issues with include files; see
	comments in AutoIt's helpfile regarding switch /AutoIt3ExecuteScript.)

	Run DebugVer - choose a file - the script will then write out a file called
	filename_Ver.au3 This file should be identical to your script except that
	before every line of code there is an instruction to write out the original
	script line to a file.
	If the script crashes out - or whatever - you just look at the the last line
	written out to indicate where the script crashed.

	Following the executed line is code to send the names and values of all variables
	used in said executed line to the edit control in the debug window.

	You can prevent any particular section of code (such as an AdLib function)
	from having debug code added by placing a line with just ';debugit' before and
	after the section.

	NOTE: Requires AutoIt 3.2.12+!!!

	Revision History:

	Version 1.0 - initial release

#ce
Global Const $bOutputVars = True ; change to false if you don't want variables output
Global $aDebugPairs[5][2] = [['|',''],[';debugit',';debugit'],['#cs','#ce'],['#comments-start','#comments-end'],[';debugit-off',';debugit-on']]
Local $bDebugging = True, $sResumeDebugging
Global $sDest, $sRandom = ''
Local $sSource, $hSource, $hDest, $sLogFile
Local $iLineNumber, $sCurrentLine, $sModifiedLine, $iSavedLine
Local $sIndent, $sTemp, $sAutoItExe, $i, $aArray

If $CmdLine[0] = 0 Then
	$sSource = FileOpenDialog('Choose script to debug', @WorkingDir, '(*.au3)', 1)
	If $sSource = '' Then Exit (1)
Else
	$sSource = $CmdLine[1]
EndIf
If Not FileExists($sSource) Then
	MsgBox(0, @ScriptName, 'File "' & $sSource & '" not found')
	Exit (1)
EndIf

Dim $aArray[4]
_PathSplit($sSource, $aArray[0], $aArray[1], $aArray[2], $aArray[3])
$aArray[2] = $aArray[2] & '_Ver'
$sDest = _PathMake($aArray[0], $aArray[1], $aArray[2], $aArray[3])
$sLogFile = _PathMake($aArray[0], $aArray[1], $aArray[2], "")

For $i = 1 To UBound($aDebugPairs) - 1
	$aDebugPairs[0][0] &= $aDebugPairs[$i][0] & '|'
Next

$hSource = FileOpen($sSource, 0)
If $hSource = -1 Then
	MsgBox(0, @ScriptName, 'File "' & $sSource & '" could not be opened')
	Exit (2)
EndIf
$hDest = FileOpen($sDest, 2)
If $hDest = -1 Then
	FileClose($hSource)
	MsgBox(0, @ScriptName, 'File "' & $sDest & '" could not be opened')
	Exit (2)
EndIf
; We use a Random 8 character string for 2 purposes:
;   1) to almost guarantee that the function we add to the script doesn't conflict
;      with the script's own functions, and
;   2) to make sure we're writing to a unique filename
While StringLen($sRandom) < 8
	$sRandom &= Chr(Random(97, 122, 1))
Wend

FileWrite($hDest, StringFormat( _
'\nGlobal $%s_w = "%s_" & Random(1, 1000000, 1) & ".log"' & _
'\nFunc %s_exit()' & _
'\n	%s_v("@exitCode", @exitCode, @Error, @Extended, "")' & _
'\n	%s_v("@exitMethod", @exitMethod, @Error, @Extended, "")' & _
'\n	FileRecycle($%s_w)' & _
'\nEndFunc' & _
'\nOnAutoItExitRegister("%s_exit")' & _
'\n', $sRandom, $sLogFile, $sRandom, $sRandom, $sRandom, $sRandom, $sRandom))

$iLineNumber = 0
While True
	$iLineNumber += 1
	$iSavedLine = $iLineNumber
	$sCurrentLine = FileReadLine($hSource)
	If @Error = -1 Then ExitLoop
	; look for lines that tell us whether to stop or start adding debugging to the script
	$sTemp = StringStripWS($sCurrentLine, 8)
	If $bDebugging And StringInStr($aDebugPairs[0][0], '|' & $sTemp & '|') > 0 Then
		For $i = 1 To UBound($aDebugPairs) - 1
			If $sTemp = $aDebugPairs[$i][0] Then
				$sResumeDebugging = $aDebugPairs[$i][1]
				$bDebugging = False
				FileWriteLine($hDest, $sCurrentLine)
				ContinueLoop 2
			EndIf
		Next
	ElseIf $sTemp = $sResumeDebugging Then
		$bDebugging = True
		FileWriteLine($hDest, $sCurrentLine)
		ContinueLoop
	EndIf

	$sCurrentLine = StripComment($sCurrentLine) ; Get rid of any comment so it doesn't mess us up
	While StringRight($sCurrentLine, 2) = ' _'
		$sCurrentLine = StringTrimRight($sCurrentLine, 1)
		$iLineNumber += 1
		$sTemp = FileReadLine($hSource)
		If @Error = -1 Then ExitLoop
		$sCurrentLine &= StripComment(StringStripWS($sTemp, 1))
	Wend
	If StringStripWS($sCurrentLine, 3) <> '' Then
		If $bDebugging Then
			; Turn all double quotes into single quotes so we can use double quotes to delimit the
			; line when adding it to the debugging script.
			$sModifiedLine = StringReplace($sCurrentLine, '"', "'")
			; Proper indenting is not really needed, but it makes the temporary script
			; look a hell of a lot better if someone needs to look at it for some reason.
			$sIndent = ''
			$aArray = StringRegExp($sCurrentLine, '^\s*', 1)
			If @Error = 0 Then $sIndent = $aArray[0]
			FileWriteLine($hDest, StringFormat('%s%s(%u, "%s", @Error, @Extended)', $sIndent, $sRandom, $iSavedLine, $sModifiedLine))
		EndIf
		FileWriteLine($hDest, $sCurrentLine)
		If $bDebugging And $bOutputVars Then
			$aArray = ScanForVars($sCurrentLine)
			For $i = 2 To $aArray[0]
				FileWriteLine($hDest, StringFormat('%s%s_v("%s", %s, @Error, @Extended, "%s")', $sIndent, $sRandom, $aArray[$i], $aArray[$i], $sIndent))
			Next
		EndIf
	EndIf
Wend
FileClose($hSource)
FileWriteLine($hDest, $sCurrentLine)

; Create our functions at the very end of the script. They do a few things for us:
;    1) Sets the two variables @Error and @Extended back to what they were before this
;       function was called. This guarantees that the original script's code that relies
;       on these values will continue to execute as intended.
;    2) Eliminates the need to add global variables to the script.
;    3) Output the name and contents of variables following the just executed script line.

FileWrite($hDest, StringFormat( _
'\nFunc %s($l, $t, $e, $x)' & _
'\n	FileWriteLine($%s_w, StringFormat("%%04u: %%s", $l, $t))' & _
'\n	SetError($e, $x)' & _
'\nEndFunc' & _
'\n' & _
'\nFunc %s_v($n, $v, $e, $x, $i)' & _
'\n	Local $j, $a = "", $u' & _
'\n	If IsArray($v) Then' & _
'\n		If UBound($v, 0) = 1 Then' & _
'\n			$u = UBound($v) - 1' & _
'\n			If $u > 10 Then $u = 10' & _
'\n			For $j = 0 to $u' & _
'\n				If IsString($v[$j]) Then $v[$j] = "''" & $v[$j] & "''"' & _
'\n				$a &= ", " & String($v[$j])' & _
'\n			Next' & _
'\n			$v = "[" & StringTrimLeft($a, 2) & "]"' & _
'\n		Else' & _
'\n			$v = "<multi-dimension-array>"' & _
'\n		EndIf' & _
'\n	ElseIf IsObj($v) Then' & _
'\n		$v = "<object>"' & _
'\n	ElseIf IsHwnd($v) Then' & _
'\n		$v = "<hwnd>"' & _
'\n	ElseIf IsString($v) Then' & _
'\n		$v = StringReplace($v,"''","")' & _
'\n		$v = "''" & $v & "''"' & _
'\n	EndIf' & _
'\n	FileWriteLine($%s_w, StringFormat("    : %%s... %%s = %%s", $i, $n, String($v)))' & _
'\n	SetError($e, $x)' & _
'\nEndFunc' & _
'\n\n', $sRandom, $sRandom, $sRandom, $sRandom))

FileClose($hDest)

Exit

;debugit-off
Func ScanForVars($sLine)
	; Look for all variables in the line and return an array of those variable names.
	; Make sure we ignore everything within quotes.
	; Assumes comments have already been stripped.
	; Result is always an array, with the [1] element blank.
	Local $aArray, $i, $sVarList
	$sLine = StringRegExpReplace($sLine, '(".*?"|''.*?'')', '', 0)
	$aArray = StringRegExp($sLine, '(?i)([@$][abcdefghijklmnopqrstuvwxyz1234567890_]*)', 3)
	For $i = 0 to UBound($aArray) - 1
		If StringInStr($sVarList & '|', $aArray[$i] & '|') = 0 Then $sVarList &= '|' & $aArray[$i]
	Next
	Return StringSplit($sVarList, '|')
EndFunc

Func StripComment($sLine)
	; Look for the first semicolon outside of quotes.
	; strip everything after it (including trailing whitespace).
	Local $aArray, $nOffset = 1
	While True
		$aArray = StringRegExp($sLine, '(".*?"|''.*?''|;)', 1, $nOffset)
		If @Error <> 0 Then ExitLoop
		$nOffset = @Extended
		If $aArray[0] = ';' Then
			$sLine = StringLeft($sLine, $nOffset - 2)
			ExitLoop
		EndIf
	WEnd
	Return StringStripWS($sLine, 2)
EndFunc
