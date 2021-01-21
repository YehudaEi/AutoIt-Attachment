;===============================================================================
; Author(s):        busysignal
; Version:			1.0.0
; AutoItVer:		3.1.1.+
; Created			2005-10-15
;
; Description:      Formats a files size according to $sFormat & $iDecimal parameters
; Syntax:           _Filesize($iValue, $sFormat, $iNum)
;
; Parameter(s):    	$iValue = The value in "Bytes"
;					$SFormat = Specify the Size format you wish to display, options are:
;					""		- Auto Select based on value entered
;					"GB"	- Display in Gigabytes
;					"MB"	- Display in Megabytes
;					"KB"	- Display in Kilobytes
;					"B"		- Display in Bytes
;					$iDecimal = The number of decimals places to round up converted value to
; Requirement(s):   None
; Return Value(s):  On Success - Returns a string representation of $iValue formatted according to $sFormat
;					On Failure - Returns an empty string "" if no files are found and sets @Error on errors
;						@Error=1 $iValue = 0 ; no value to convert
;						@Error=2 Either $iValue or $iDecimal contains non-numeric characters.
; Note(s):			Example: _Filesize(2152971234,"GB", 2)  would return "2.15 GB"
;
; Credits:			Inspired by _PictureUDF() by SolidSnake <MetalGearX91@Hotmail.com>
;===============================================================================
Func _Filesize($iValue, $sFormat, $iDecimal)
	Local $sReturn, $iB, $iKB, $iMB, $iGB
	If $iValue = 0 Then
		SetError(1)
		Return 0
	EndIf
	If Not StringIsDigit($iValue) Or Not StringIsDigit($iDecimal) Then
		SetError(2)
		Return 0
	EndIf
	; Conversion Chart
	$iB = $iValue
	$iKB = Round($iB / 1024, $iDecimal)
	$iMB = Round($iKB / 1024, $iDecimal)
	$iGB = Round($iMB / 1024, $iDecimal)

	Select
		Case $sFormat = "" ; Auto Select Format Display Type
			If $iMB > 1024 Then
				$iValue = $iGB & " GB"
			ElseIf $iKB > 1024 Then
				$iValue = $iMB & " MB"
			ElseIf $iKB > 0 Then
				$iValue = $iKB & " KB"
			ElseIf $iKB < 0 Then
				$iValue = $iB & " Bytes"
			EndIf
		Case $sFormat = "GB"
			$iValue = $iGB & " GB"
		Case $sFormat = "MB"
			$iValue = $iMB & " MB"
		Case $sFormat = "KB"
			$iValue = $iKB & " KB"
		Case $sFormat = "B"
			$iValue = $iB & " Bytes"				
	EndSelect

	Return $iValue
	
EndFunc   ;==>_Filesize