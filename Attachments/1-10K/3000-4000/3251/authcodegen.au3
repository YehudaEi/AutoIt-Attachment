;Program Information----------------------------------------------------------
;
;	Authorization Code Generator v1.0
;
;	Script Functions:
;		Generate a passcode every minute for use in an outside script
;
;	Author: Telanis Blackwood (a.k.a. Dicemaster Slayer)
;-----------------------------------------------------------------------------
;String Reverse Information---------------------------------------------------
;
; Description:      Reverses the contents of the specified string.
; Syntax:           _StringReverse( $sString )
; Parameter(s):     $sString - String to reverse
; Requirement(s):   None
; Return Value(s):  On Success - Returns reversed string
;                   On Failure - Returns an empty string and sets @error = 1
; Author(s):        Jonathan Bennett <jon at hiddensoft com>
; Note(s):          None
;
;-----------------------------------------------------------------------------
;Authorization Information----------------------------------------------------
;Authorization Code is a combination of macros:
;	@WDAY: Numeric day of week, 1=Sunday, 2=Monday, 3=Tuesday, etc.
;	@MON : Numeric month, 01-12
;	@MDAY: Numeric day of month, 01-31
;	@YEAR: 4-digit year
;	@HOUR: 24-hr format, 00-23, 00=12a, 23=11p
;	@MIN : Minutes past hour, 00-59
;then reversed...
;
;Sunday, January 1, 2005, 10:20p
;	1		01	01	2005  22 20
;		1010120052220>>>$code
;	 <<<0222500210101>>>$auth
;-----------------------------------------------------------------------------
$code = @WDAY & @MON & @MDAY & @YEAR & @HOUR & @MIN
$auth = _StringReverse($code)
Func _StringReverse($sString)
	Local $sReverse
	Local $iCount
	If StringLen($sString) >= 1 Then
		For $iCount = 1 To StringLen($sString)
			$sReverse = StringMid($sString, $iCount, 1) & $sReverse
		Next
		Return $sReverse
	Else
		SetError(1)
		Return ""
	EndIf
EndFunc   ;==>_StringReverse