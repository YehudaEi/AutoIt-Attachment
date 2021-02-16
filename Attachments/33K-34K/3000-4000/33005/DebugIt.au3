#NoTrayIcon
Opt('MustDeclareVars', 1)
Opt('GUIOnEventMode', 1)
Opt("WinTitleMatchMode", 4)
;debugit-off
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <WindowsConstants.au3>
#cs

	DebugIt.au3

	Run an AutoIt script, outputing each line executed to a window.

	Syntax 1:
	AutoIt3 DebugIt.au3 yourscript.au3 params
	Syntax 2:
	DebugIt.exe yourscript.au3 params

	(If using Syntax 2, note that there may be issues with include files; see
	comments in AutoIt's helpfile regarding switch /AutoIt3ExecuteScript.)

	Run DebugIt - choose a file - the script will then write out a file called
	filename_DebugIt.au3 This file should be identical to your script except that
	before every line of code there is an instruction to write out the original
	script line to a control in a window we create.
	If the script crashes out - or whatever - you just look at the the last line
	written out to indicate where the script crashed.

	Following the executed line is code to send the names and values of all variables
	used in said executed line to the edit control in the debug window.

	You can prevent any particular section of code (such as an AdLib function)
	from having debug code added by placing a line with just ';debugit' before and
	after the section.

	NOTE: Requires AutoIt 3.2.12+!!!

	Revision History:

	Version 1.6
	* changed: StripComments() and ScanForVars() now use regular expressions to
	greatly speed up the code instead of looping through the line character by
	character.
	* changed: turning debugging on and off is now much more flexible. In
	addition to skipping '# cs'/'# ce' blocks, you can now use ';debugit-off'
	and ';debugit-on' to stop and start debugging.
	* changed: in addition to multi-dimensional-arrays being identified as such,
	objects and hwnds will too.
	* other minor changes too numerous to mention (or remember, frankly).

	Version 1.5.1
	* changed: because of the script-breaking changes made in v3.2.12 of AutoIt,
	our include list needed to be updated to the new "standard". If you're using
	an earlier version of AutoIt, note that this script should work with earlier
	versions, however the include list will probably need to be changed.

	Version 1.5
	* fixed: try to reactivate the previously active window if the 'Pause' button
	was used and later the 'Resume' button. Should prevent Send commands in the
	script immediately following resuming from being sent to our debug window.
	* changed: extra characters added to window title changed from brackets to
	braces so we don't use the same character AutoIt does for title matching.

	Version 1.4
	* changed: if user does not have write permissions on the folder containing
	the script, run script in passthru mode instead of failing.
	* changed: exit gracefully if we prompt the user for a file to debug and no
	file was given.
	* added: set focus to Exit button so we can be dismissed with an enter or
	spacebar key.
	* changed: unnecessary StringFormat commands changed to literal strings.

	Version 1.3
	* changed: activate previous window after opening our GUI, in case the
	script we're debugging relies or acts on the active window. Also,
	re-activate our debug window when and if the script we're debugging
	exits.
	* changed: change our debug window title slightly to reduce the possibility
	of our window's title interferring with window title matching in the
	script we're debugging.
	* added: include builtin variables (@'s) in variable outout.

	Version 1.2
	* changed: comment to control debugging changed from ';debug' to ';debugit'.
	* changed: font in edit control from 'Lucidia Console' to 'Courier New'.
	* added: outputs variable names and their values after the executed line.
	* other small changes, such as 'Passthru' mode described in the code.

	Version 1.1
	* changed: calls a single function to do the work, and add said function
	at the bottom of the script. Similar to what Stumpii does in his
	debugger; after all, a good idea deserves stealing.
	* changed: event driven GUI rather than loop mode.
	* changed: font in Edit control is now fixed pitch.
	* added: pause/resume and stop/exit buttons.

	Version 1.0 - initial release

#ce
Global Const $bOutputVars = True ; change to false if you don't want variables output
Global Const $bPassthru = False  ; change to true when you don't want to debug but
;                                  don't want to change the command line that starts
;                                  your script
Global Const $sEditFont = 'Courier New'
Global $aDebugPairs[5][2] = [['|',''],[';debugit',';debugit'],['#cs','#ce'],['#comments-start','#comments-end'],[';debugit-off',';debugit-on']]
Local $bDebugging = True, $sResumeDebugging

Global $sDest, $sRandom = '', $sTitle
Local $sSource, $hSource, $hDest
Local $iLineNumber, $sCurrentLine, $sModifiedLine, $iSavedLine
Local $sIndent, $sTemp, $sAutoItExe, $i, $aArray
Local $sArgs = '', $PID

$sAutoItExe = '"' & @AutoItExe & '"'
If @Compiled Then
	$sAutoItExe &= ' /AutoIt3ExecuteScript'
EndIf

If $CmdLine[0] = 0 Then
	$sSource = FileOpenDialog('Choose script to debug', @WorkingDir, '(*.au3)', 1)
	If $sSource = '' Then Exit (1)
Else
	$sSource = $CmdLine[1]
	For $i = 2 To $CmdLine[0]
		$sArgs &= ' "' & $CmdLine[$i] & '"'
	Next
EndIf
If Not FileExists($sSource) Then
	MsgBox(0, @ScriptName, 'File "' & $sSource & '" not found')
	Exit (1)
EndIf

; You can have all your shortcuts or command lines include this debug script in
; your command line that starts your own scripts. When you want to turn debugging on
; or off you just edit this script, change $bPassthru to True to turn it on and
; change to False to turn it off. With $bPassthru set to True it's as if this
; script were not even there.
;
If $bPassthru Then
	Run($sAutoItExe & ' "' & $sSource & '"' & $sArgs, @WorkingDir)
	Exit
EndIf

Dim $aArray[4]
_PathSplit($sSource, $aArray[0], $aArray[1], $aArray[2], $aArray[3])
; The title of our debug window will be the filename portion only, but with '_DebugIt' added.
$sTitle = $aArray[2] & '_DebugIt'
; Our temporary script will use this title for its name. We also make sure to create the
; temporary script in the same folder as the original, in case it relies on other things
; being found relative to where it is. Placing this temporary file in the temp folder may
; screw some things up, so we don't do that.
$sDest = _PathMake($aArray[0], $aArray[1], $sTitle, $aArray[3])
For $i = 1 To UBound($aDebugPairs) - 1
	$aDebugPairs[0][0] &= $aDebugPairs[$i][0] & '|'
Next
; We use a Random 8 character string for 2 purposes:
;   1) to almost guarantee that the function we add to the script doesn't conflict
;      with the script's own functions, and
;   2) to make sure we're communicating with one and only one debug window, as we
;      look for this random string to be text in the window we want to communicate with.
While StringLen($sRandom) < 8
	$sRandom &= Chr(Random(97, 122, 1))
Wend
; Change title slightly to reduce possibility of our Debug window's title interferring
; with window title matching in the script we're debugging.
$sTitle = '{' & $sTitle & '}'

$hSource = FileOpen($sSource, 0)
If $hSource = -1 Then
	MsgBox(0, @ScriptName, 'File "' & $sSource & '" could not be opened')
	Exit (2)
EndIf
$hDest = FileOpen($sDest, 2)
If $hDest = -1 Then
	; Instead of failing if we can't debug, run the program in passthru mode
	; Useful if the person/account running the script doesn't have write access
	; to the folder containing the script.
	FileClose($hSource)
	Run($sAutoItExe & ' "' & $sSource & '"' & $sArgs, @WorkingDir)
	Exit
EndIf

;debugit-on
$iLineNumber = 0
While True
	$iLineNumber += 1
	$iSavedLine = $iLineNumber
	$sCurrentLine = FileReadLine($hSource) ; , $iLineNumber)
	If @Error = -1 Then ExitLoop
	; look for lines that tell us whether to stop or start adding debugging to the script
	$sTemp = StringStripWS($sCurrentLine, 8)
	If $bDebugging And StringInStr($aDebugPairs[0][0], '|' & $sTemp & '|') > 0 Then
		For $i = 0 To UBound($aDebugPairs) - 1
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
;    1) Updates the edit control in our window with the script line that is about to execute.
;    2) Sets the two variables @Error and @Extended back to what they were before this
;       function was called. This guarantees that the original script's code that relies
;       on these values will continue to execute as intended.
;    3) Eliminates the need to add global variables to the script.
;    4) Watches the debugging form for changes to its controls and either pauses or exits
;       if told to do so.
;    5) Output the name and contents of variables following the just executed script line.

FileWrite($hDest, StringFormat('\n' & _
'\nFunc %s($l, $t, $e, $x)' & _
'\n	Local $o = Opt("WinTitleMatchMode", 4)' & _
'\n	Local $h = WinGetHandle("[TITLE:%s]", "%s"), $w = WinGetHandle("[ACTIVE]")' & _
'\n	Global $%s_w' & _
'\n	If $w <> $h Then $%s_w = $w' & _
'\n	ControlCommand($h, "", "[CLASSNN:Edit1]", "EditPaste", StringFormat("%%04u: %%s", $l, $t) & @CRLF)' & _
'\n	If ControlCommand($h, "", "[TEXT:Pause]", "IsChecked","") Then' & _
'\n		While ControlCommand($h, "", "[TEXT:Pause]", "IsChecked","")' & _
'\n			Sleep(500)' & _
'\n		Wend' & _
'\n		If IsHwnd($%s_w) Then WinActivate($%s_w)' & _
'\n	EndIf' & _
'\n	If ControlCommand($h, "", "[TEXT:Stop]", "IsChecked","") Then Exit' & _
'\n	Opt("WinTitleMatchMode", $o)' & _
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
'\n	ControlCommand("[TITLE:%s]", "%s", "[CLASSNN:Edit1]", "EditPaste", StringFormat("    : %%s... %%s = %%s", $i, $n, String($v)) & @CRLF)' & _
'\n	SetError($e, $x)' & _
'\nEndFunc' & _
'\n', $sRandom, $sTitle, $sRandom, $sRandom, $sRandom, $sRandom, $sRandom, $sRandom, $sTitle, $sRandom))

FileClose($hDest)

; Save the handle of the currently active window. After our GUI is shown we make it
; active again in case something in the script we're debugging relies or works on it.
$sTemp = WinGetHandle('[ACTIVE]')
; We create our form, giving it a single label containing our random string so our
; debug script will have a unique window to communicate with. We also add one Edit
; control that gets updated by the debug script as it executes.
#Region ### START Koda GUI section ### Form=g:\programs\autoit3\koda\forms\dbgform2.kxf
Global $frmMain = GUICreate($sTitle, 876, 429, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, 'frmMainClose')
Global $GroupBox1 = GUICtrlCreateGroup('', 8, 1, 857, 377)
Global $edtCode = GUICtrlCreateEdit('DebugIt V1.5.1 by Klaatu' & @CRLF, 16, 16, 841, 353, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
GUICtrlSetData(-1, '')
GUICtrlSetFont(-1, 10, 400, 0, $sEditFont)
GUICtrlSetLimit(-1, 0x7FFFFFFF)
GUICtrlCreateGroup('', -99, -99, 1, 1)
Global $btnPause = GUICtrlCreateButton('Pa&use', 313, 387, 75, 25, 0)
GUICtrlSetOnEvent(-1, 'btnPause_Click')
Global $btnStop = GUICtrlCreateButton('St&op', 410, 387, 75, 25, 0)
GUICtrlSetOnEvent(-1, 'btnStop_Click')
Global $lblRandom = GUICtrlCreateLabel($sRandom, 56, -100, 65, 17)
Global $cbPause = GUICtrlCreateCheckbox('Pause', 176, -100, 105, 17)
Global $cbStop = GUICtrlCreateCheckbox('Stop', 560, -100, 121, 17)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
WinActivate($sTemp)

; We're ready to start executing the debug script.
$PID = Run($sAutoItExe & ' "' & $sDest & '"' & $sArgs, @WorkingDir)

While True
	Sleep(100)
	If BitAND(GUICtrlRead($cbStop, 0), $GUI_UNCHECKED) = $GUI_UNCHECKED Then
		If Not ProcessExists($PID) Then
			WinActivate($sTitle, $sRandom)
			GUICtrlSetState($cbStop, $GUI_CHECKED)
			GUICtrlSetState($btnPause, $GUI_DISABLE)
			GUICtrlSetState($btnStop, $GUI_DEFBUTTON + $GUI_FOCUS)
			GUICtrlSetData($btnStop, 'E&xit')
		EndIf
	EndIf
Wend
Exit

Func frmMainClose()
	Cleanup()
	Exit
EndFunc	;==>frmMainClose

Func btnPause_Click()
	If BitAND(GUICtrlRead($cbPause, 0), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($cbPause, $GUI_UNCHECKED)
		GUICtrlSetData($btnPause, 'Pa&use')
	Else
		GUICtrlSetState($cbPause, $GUI_CHECKED)
		GUICtrlSetData($btnPause, 'Res&ume')
	EndIf
EndFunc	;==>btnPause_Click

Func btnStop_Click()
	If BitAND(GUICtrlRead($cbStop, 0), $GUI_CHECKED) = $GUI_CHECKED Then
		frmMainClose()
	Else
		If BitAND(GUICtrlRead($cbPause, 0), $GUI_CHECKED) = $GUI_CHECKED Then
			GUICtrlSetState($cbPause, $GUI_UNCHECKED)
			GUICtrlSetState($btnPause, $GUI_DISABLE)
		EndIf
		GUICtrlSetState($cbStop, $GUI_CHECKED)
		GUICtrlSetState($btnStop, $GUI_DEFBUTTON + $GUI_FOCUS)
		GUICtrlSetData($btnStop, 'E&xit')
	EndIf
EndFunc	;==>btnStop_Click

Func Cleanup()
	FileDelete($sDest)
EndFunc	;==>Cleanup

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
EndFunc	;==>ScanForVars

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
EndFunc	;==>StripComment
