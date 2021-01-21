#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=G:\AutoIt\Download Security.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#Tidy_Parameters=/sci 1 /sf
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly /sci 1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.10.0
	Author:         "Nutster" David Nuttall
	
	Script Function:
	Download security updates for Spybot S&D, Ad-Aware SE, and AVG Free.
	
#ce ----------------------------------------------------------------------------

AutoItSetOption("MustDeclareVars", True)

Global $I, $iPos1, $iPos2
Global $E1, $E2
Global $sFileText, $aMatch
Global $sDrive = StringLeft(@ScriptDir, 2) ; should contain <drive>:, like H:
Global $sPrefix = $sDrive & "\Download\" 
Global $sPrefix2 = $sDrive & "\Grisoft\" 
; Global $sGrisoft = @TempDir & "\Grisoft_Update.htm"
Global $sGrisoft = $sPrefix2 & "\Grisoft_Update.htm" 

InetGet("http://www.spybotupdates.com/updates/files/spybotsd_includes.exe", $sPrefix & "spybotsd_includes.exe", 1, 0)
InetGet("http://download.lavasoft.com/public/defs.zip", $sPrefix & "Adaware defs.zip", 1, 0)
InetGet("http://free.grisoft.com/doc/update", $sGrisoft, 1, 0)

; Process links in Grisoft_Update.htm
$sFileText = FileRead($sGrisoft)
; Change new-lines to spaces
$sFileText = StringReplace($sFileText, @CRLF, " ")
$sFileText = StringReplace($sFileText, @CR, " ")
$sFileText = StringReplace($sFileText, @LF, " ")
$sFileText = StringReplace($sFileText, "  ", " ")
While $sFileText > ""
	; Look for <a ... href="u7*.bin" ...>
	$iPos1 = StringInStr($sFileText, "<a ", 2)
	$iPos2 = StringInStr($sFileText, "< a ", 2)
	If $iPos1 = 0 And $iPos2 = 0 Then
		; Not found
		ExitLoop
	ElseIf $iPos1 = 0 Then
		$I = $iPos2
	ElseIf $iPos2 = 0 Then
		$I = $iPos1
	ElseIf $iPos1 < $iPos2 Then
		$I = $iPos1
	Else
		$I = $iPos2
	EndIf
	$sFileText = StringMid($sFileText, $I)
	$I = StringInStr($sFileText, ">")
	If $I = 0 Then $I = StringLen($sFileText)
	$aMatch = StringRegExp(StringLeft($sFileText, $I), '(?i)href *= *"([-[:alnum:]_.%@/:]+)"', 1)
	If @error = 0 Then
		If StringRegExp(BaseName($aMatch[0]), "^u7[[:alpha:]].*\.bin$", 0) = 0 Then
			; Not the correct pattern
		ElseIf StringInStr(BaseName($aMatch[0]), "u7lx", 2) Then
			; Do not take u7lx*.bin - Linux files
		Else
			InetGet($aMatch[0], $sPrefix2 & BaseName($aMatch[0]), 1, 0)
			; MsgBox(48, "Testing", $aMatch[0] & @CRLF & $sPrefix2 & BaseName($aMatch[0]))
		EndIf
	EndIf
	$sFileText = StringMid($sFileText, $I)
WEnd
FileDelete($sGrisoft)

MsgBox(64, "Security Update", "Task Complete")

Func BaseName($sFileName)
	Local $I = StringInStr($sFileName, "/", 0, -1)
	
	If $I = 0 Then $I = StringInStr($sFileName, "\\", 0, -1)
	If $I = 0 Then
		Return $sFileName
	Else
		Return StringMid($sFileName, $I + 1)
	EndIf
EndFunc   ;==>BaseName