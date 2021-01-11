#include-once

; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that return active controls and their state.
;
; ------------------------------------------------------------------------------


;===============================================================================
;
; Description:      Returns 1 if mouse is hovering over given control.
; Syntax:           _GUICtrlIsActive($vControl)
; Parameter(s):     $vControl - Variable returned by GUICtrlCreate functions
; Requirement(s):   Requires #Include <GUIConstants.au3>
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          Very basic and simple function derived mostly from GUIGetCursorInfo().
;
;===============================================================================
Func _ControlIsActive($vControl)
	Local $temp
	$temp = GUIGetCursorInfo()
	If $vControl = $temp[4] Then 
		Return 1
	Else
		Return 0
	EndIf
EndFunc  


;===============================================================================
;
; Description:      Returns 1 if mouse is hovering over given control.
; Syntax:           _GUICtrlIsActive()
; Parameter(s):     None
; Requirement(s):   Requires #Include <GUIConstants.au3>
; Return Value(s):  On Success - Returns control ID (Compare to GUICtrlCreate variable)
;                   On Failure - 0
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          Very basic and simple function derived mostly from GUIGetCursorInfo().
;
;===============================================================================
Func _ControlGetActive()
	Local $temp
	$temp = GUIGetCursorInfo()
	Return $Temp[4]
EndFunc  


;===============================================================================
;
; Description:      Returns the width of given window.
; Syntax:           _WinGetWidth($sTitle [,$sText])
; Parameter(s):		$sTitle				- Title of the window
; 					$sText				- Text of the window
; Requirement(s):   None
; Return Value(s):  On Success - Returns the windows width
;					On Failure - Returns -1
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          None
;
;===============================================================================
Func _WinGetWidth($sTitle, $sText = "")
	Local $temp
	$temp = WinGetPos($sTitle, $sText)
	Return $temp[2]
EndFunc


;===============================================================================
;
; Description:      Returns the width of given window.
; Syntax:           _WinGetWidth($sTitle [,$sText])
; Parameter(s):		$sTitle				- Title of the window
; 					$sText				- Text of the window
; Requirement(s):   None
; Return Value(s):  On Success - Returns the windows width
;					On Failure - Returns -1
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          None
;
;===============================================================================
Func _WinGetHeight($sTitle, $sText = "")
	Local $temp
	$temp = WinGetPos($sTitle, $sText)
	Return $temp[3]
EndFunc


;===============================================================================
;
; Description:      Allows window to be panned around until mouse is released
; Syntax:           _PanWindow($sTitle, [$sText])
; Parameter(s):		$sTitle				- Title of the window
; 					$sText				- Text of the window
; Requirement(s):   Requires #Include <Misc.au3>
; Return Value(s):  None
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          None
;
;===============================================================================
Func _PanWindow($sTitle, $sText = "", $x = "0")
	Local $Mouse = MouseGetPos(), $Win = WinGetPos($sTitle, $sText), $Offset[2], $tempMouse, $tempWin
	$Offset[0] = $Mouse[0] - $Win[0]
	$Offset[1] = $Mouse[1] - $Win[1]
	Do
		Sleep(10)
		$tempMouse = MouseGetPos()
		WinMove($sTitle, $sText, $tempMouse[0] - $Offset[0], $tempMouse[1] - $Offset[1])
	Until _IsPressed("01") = 0 OR (_ControlIsActive($x) = 0 AND WinActive($sTitle, $sText) = 0)
	Return
EndFunc

;===============================================================================
;
; Description:      Allows window to be panned around until mouse is released
; Syntax:           _StringSlideLtoR($sString[, $sModifier])
; Parameter(s):		$sString			- The string to be adjusted
; 					$sModifier			- The string to be added in between split string
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          If the string is Rad, and the modifier is ":", it would return "ad:R"
;					You can make it Marquee when your string is returned hole, then adding 
;					a modifier, then looping without one until its whole again (With the modifier attached)
;===============================================================================
Func _StringSlideLtoR($sString, $sModifier = "")
	Local $sTemp
	$sTemp = StringLeft($sString,1)
	$sString = StringTrimLeft($sString, 1) & $sModifier & $sTemp
	Return $sString
EndFunc

;===============================================================================
;
; Description:      Allows window to be panned around until mouse is released
; Syntax:           _StringSlideRtoL($sString[, $sModifier])
; Parameter(s):		$sString			- The string to be adjusted
; 					$sModifier			- The string to be added in between split string (Default "")
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          If the string is Rad, and the modifier is ":", it would return "ad:R"
;					You can make it Marquee when your string is returned hole, then adding 
;					a modifier, then looping without one until its whole again (With the modifier attached)
;===============================================================================
Func _StringSlideRtoL($sString, $sModifier = "")
	Local $sTemp
	$sTemp = StringRight($sString,1)
	$sString = StringTrimRight($sString, 1) & $sModifier & $sTemp
	Return $sString
EndFunc

;===============================================================================
;
; Description:      Adds a character between every character in a string
; Syntax:           _StringSeed($sString[, $sSeed])
; Parameter(s):		$sString			- The string to be adjusted
; 					$sSeed				- String to be seeded between every character
; Requirement(s):   None
; Return Value(s):  None
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          String Rad with seed ":" would return: "R:a:d"
;
;===============================================================================
Func _StringSeed($sString, $sSeed = " ")
	Local $sTemp[StringLen($sString) + 1], $i
	For $i = 1 to StringLen($sString) -1
		$sTemp[$i] = StringMid($sString, $i,1)
	Next
	$sTemp[StringLen($sString)] = StringRight($sString,1)
	$sString = ""
	For $i = 0 to UBound($sTemp) - 1
		$sString = $sString & $sTemp[$i] & $sSeed
	Next
	$sString = StringTrimLeft($sString, 1)
	$sString = StringTrimRight($sString, 1)
	Return $sString
EndFunc

;===============================================================================
;
; Description:      Counts the number lines that contain a certain string in a file
; Syntax:           _FileCountOccurrences($sFile, $sString)
; Parameter(s):		$sFile				- File to be examined
; 					$sString			- String to be searched for
; Requirement(s):   None
; Return Value(s):  Success				- Returns number of occurences
;					Failure				- Sets @error to 1 and returns 0
; Author(s):        Rad (RadleyGH at GMail dot com)
; Note(s):          None
;
;===============================================================================
Func _FileCountOccurrences($sFile, $sString)
	Local $data, $stringcount, $lines, $linecount, $i
	$data = FileRead($File, 1024)
	$stringcount = 0

	$lines = StringSplit($data, @lf)
	If IsArray($lines) Then
		$linecount = $lines[0]
	Else
		$linecount = 0
	Endif

	For $i = 1 to $linecount
		If StringinStr(FileReadLine($sFile, $i), $sString) Then
			$stringcount = $stringcount + 1
		EndIf
	Next
	If $StringCount > 0 Then
		Return $stringcount
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc