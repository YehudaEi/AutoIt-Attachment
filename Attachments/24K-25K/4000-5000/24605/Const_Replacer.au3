#comments-start -----------------------------------------------------------------------------------
	Title:			Const Replacer
	Filename:		Const Replacer.au3
	Description:	Replace constants to their values
	Author:			FireFox
	Version:		01.03.00
	Last Update:	14.02.09
	Requirements:	Unknown, Developed/Tested on WindowsXP Familly Service Pack 3
	Notes:			None
	
	Special thanks to Jos for help and _SciTE_GetText, _SciTE_SetText
	Martin for _SendMessage function and ProgAndy for help
	AutoIt support furum
#comments-end -------------------------------------------------------------------------------------

#NoTrayIcon

#Region Check
If Not FileExists('Const.au3') Then Exit
If Not FileExists('Include.au3') Then Exit
If Not ProcessExists('SciTE.exe') Then Exit
#EndRegion Check

#Region var
Local $SciTE = '[CLASS:SciTEWindow]'
$cgh = ControlGetHandle($SciTE, '', '[CLASS:Scintilla; INSTANCE:1]')
$path = StringTrimRight(WinGetTitle($SciTE), 8)
$s_String = StringSplit($path, '\')
$ScriptPath = StringReplace($path, $s_String[$s_String[0]], '')
$ScriptFullName = $s_String[$s_String[0]]
$ScriptName = StringTrimRight($ScriptFullName, 4)
$text = _SciTE_GetText(1)
$textOut = $text
#EndRegion var

If Not WinActive($SciTE) Then WinActivate($SciTE)
_SciTE_SetText(2, '>Running Const Replacer <d3montools>' & @CR, 0)

#Region Include List
Local $au3[_FileCountLines('Include.au3')]

For $nb = 1 To _FileCountLines('Include.au3') -1
	$IncR = FileReadLine('Include.au3', $nb)
	$au3[$nb] = $IncR
Next
#EndRegion Include List
;

#Region Const Replace
For $Constnb = 1 To _FileCountLines('Const.au3')
	$ConstR = FileReadLine('Const.au3', $Constnb)
	$ConstC = StringLeft($ConstR, StringInStr($ConstR, '=') - 1)
;~ 	ConsoleWrite($ConstC & '=') ;Debug
	$ConstV = StringMid($ConstR, StringInStr($ConstR, '=') + StringLen('='))
;~ 	ConsoleWrite($ConstV & @CRLF) ;Debug
	If StringInStr($text, $ConstC) Then
;~ 		ConsoleWrite('-' & $ConstC & ' Replaced to ' & $ConstV & @CRLF) ;Debug
		$textOut = StringReplace($textOut, $ConstC, $ConstV)
	EndIf
Next
#EndRegion Const Replace

#Region Include Replace
If StringInStr($text, 'Constants.au3>') Then
	For $i = 1 To UBound($au3) - 1
;~ 	ConsoleWrite($au3[$i] & @CRLF) ;Debug
		If StringInStr($text, $au3[$i]) Then
			$textOut = StringReplace($textOut, $au3[$i], ';~ ' & $au3[$i])
;~ 			ConsoleWrite('-' & $au3[$i] & ' Replaced' & @CRLF) ;Debug
		EndIf
	Next
EndIf

$EditCur = _SendMessage($cgh, 2008)
_SciTE_SetText(1, $textOut, 1)
_SendMessage($cgh, 2026, $EditCur)
_SendMessage($cgh, 2141, $EditCur)

If Not WinActive($SciTE) Then WinActivate($SciTE)
Send('^s') ;Save edited script
#EndRegion Include Replace
;

#Region BackUp
If $text <> $textOut Then
	DirCreate($ScriptPath & 'BackUp')
	FileWrite($ScriptPath & 'BackUp\' & $ScriptName & '_Old.au3', $text)
	_SciTE_SetText(2, '+> Const Replacer finished.', 0)
	_SciTE_SetText(2, ' Original copied to: ' & $ScriptPath & 'BackUp\' & $ScriptName & '_Old.au3' & @CR, 0)
EndIf
#EndRegion BackUp
;


; #FUNCTION# =============================================================
; Name............:	_SciTE_GetText
; Description.....:	Return SciTE text
; Return Value(s).:	Return $s_Text
; Author(s).......:	Jos
; Note............:	Modified by FireFox
;=========================================================================
Func _SciTE_GetText($Ctrl)
	$SciTE = '[CLASS:SciTEWindow]'
	$s_Text = ControlGetText($SciTE, '', '[CLASS:Scintilla; INSTANCE:' & $Ctrl & ']')
	$Script = StringToBinary($s_Text, 2)
	$s_Text = BinaryToString($Script, 1)
	Return $s_Text
EndFunc   ;==>_SciTE_GetText


; #FUNCTION# =============================================================
; Name............:	_SciTE_SetText
; Description.....:	Set SciTE text
; Return Value(s).:	None
; Author(s).......:	Jos
; Note............:	Modified by FireFox
;=========================================================================
Func _SciTE_SetText($Ctrl, $s_Text, $overwrite)
	$SciTE = '[CLASS:SciTEWindow]'
	$l_Text = StringToBinary(ControlGetText($SciTE, '', '[CLASS:Scintilla; INSTANCE:' & $Ctrl & ']'), 2)
	$l_Text = BinaryToString($l_Text, 1)
	$l_Text = String($l_Text)
	If $overwrite = 1 Then $l_Text = $s_Text
	If $overwrite <> 1 Then $l_Text &= $s_Text
	$n_Text = StringToBinary($l_Text, 1)
	$n_Text &= StringRight('0000', Mod(StringLen($n_Text), 4) + 2)
	$n_Text = BinaryToString($n_Text, 2)
	ControlSetText($SciTE, '', '[CLASS:Scintilla; INSTANCE:' & $Ctrl & ']', $n_Text)
EndFunc   ;==>_SciTE_SetText


; #FUNCTION# =============================================================
; Name............:	_SendMessage
; Description.....:	Wrapper for commonly used Dll Call
; Return Value(s).:	Return $aResult
; Author(s).......:	Valik
; Note............:	None
;=========================================================================
Func _SendMessage($hWnd, $iMsg, $wParam = 0, $lParam = 0, $iReturn = 0, $wParamType = 'wparam', $lParamType = 'lparam', $sReturnType = 'lparam')
	Local $aResult = DllCall('user32.dll', $sReturnType, 'SendMessage', 'hwnd', $hWnd, 'int', $iMsg, $wParamType, $wParam, $lParamType, $lParam)
	If @error Then Return SetError(@error, @extended, '')
	If $iReturn >= 0 And $iReturn <= 4 Then Return $aResult[$iReturn]
	Return $aResult
EndFunc   ;==>_SendMessage


; #FUNCTION# =============================================================
; Name...........: _FileCountLines
; Description ...: Returns the number of lines in the specified file.
; Return values .: Success - Returns number of lines in the file.
; Author ........: Tylo
; ========================================================================
Func _FileCountLines($sFilePath)
	Local $hFile, $sFileContent, $aTmp
	$hFile = FileOpen($sFilePath, 0)
	If $hFile = -1 Then Return SetError(1, 0, 0)
	$sFileContent = StringStripWS(FileRead($hFile), 2)
	FileClose($hFile)
	If StringInStr($sFileContent, @LF) Then
		$aTmp = StringSplit(StringStripCR($sFileContent), @LF)
	ElseIf StringInStr($sFileContent, @CR) Then
		$aTmp = StringSplit($sFileContent, @CR)
	Else
		If StringLen($sFileContent) Then
			Return 1
		Else
			Return SetError(2, 0, 0)
		EndIf
	EndIf
	Return $aTmp[0]
EndFunc   ;==>_FileCountLines