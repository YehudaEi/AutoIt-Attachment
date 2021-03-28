#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Author:         Greencan

 _GetDateInString()

#ce ----------------------------------------------------------------------------
#Include <Misc.au3>
#include <Date.au3>
#include <Array.au3>

Opt('MustDeclareVars', 1)

Global $bTest
Global $sString, $sDateFormat, $sDateReturned
Global $iError = 0

; Mon
$sString = "1a 21May14 03:59:59"
$sDateFormat = "DDMonYY hh:mm:ss"
Test_it()
$sDateFormat = "DMonYY hh:mm:ss"
Test_it()
$sDateFormat = "DMonYY h:mm:ss"
Test_it()
$sDateFormat = "DMonYY h:mm"
Test_it()

$sString = "1b: Program terminated: at 21Apr14 03:30:04Z (multiple colon ':')"
$sDateFormat = "DDMonYY hh:mm:ss"
Test_it()

$sString = "1c - Process Last Run 17 JUN 2013 05:15"
$sDateFormat = "DD Mon YYYY hh:mm"
Test_it()

$sString = "1d - Process Last Run  Mar, 27 2015 12:17:22"
$sDateFormat = "Mon, DD YYYY hh:mm:ss"
Test_it()

$sString = "1e - Process Last Run  Feb, 28 2015 12:17:22"
$sDateFormat = "Mon,  D YYYY hh:mm:ss"
Test_it()

$sString = "1f - Process Last Run 17 JUN at 05:15"
$sDateFormat = "DD Mon at hh:mm"
Test_it()
$sDateFormat = "D Mon at hh:mm"
Test_it()
$sDateFormat = "DD Mon at h:mm"
Test_it()

$sString = "1g: Program terminated: at 21Apr14 03:30:04Z (multiple colon)"
$sDateFormat = "DMonYY hh:mm:ss"
Test_it()

$sString = "1h Program terminated: at 8Apr 03:30:04"
$sDateFormat = "DMon hh:mm:ss"
Test_it()

$sString = "1i - Process Last Run  21May14 23:59" &  " - Second occurence 22Apr14 00:23"
$sDateFormat = "DMonYY hh:mm"
Test_it(True, True)

; MM
$sString = "2a - Process Last Run 15/02/2014 23:57"
$sDateFormat = "DD/MM/YYYY hh:mm"
Test_it()
$sDateFormat = "D/M/YYYY hh:mm"
Test_it()
$sDateFormat = "D/M/YYYY hh:mm"
Test_it()
$sDateFormat = "D/M/YYYY h:mm"
Test_it()

$sString = "2b - Process Last Run 04-02-2014  00:01"
$sDateFormat = "DD-MM-YYYY  hh:mm"
Test_it()

$sString = "2c- Process Last Run 17012013 08:13:25 (no seconds in format)"
$sDateFormat = "DDMMYYYY hh:mm"
Test_it()

$sString = "2d - Process Last Run 16/02 15:50 (No Year)"
$sDateFormat = "DD/MM hh:mm"
Test_it()
$sDateFormat = "D/MM hh:mm"
Test_it()
$sDateFormat = "D/M hh:mm"
Test_it()
$sDateFormat = "D/M h:mm"
Test_it()

$sString = "2e - Process Last Run  05.18.2014  15:50"
$sDateFormat = "MM.DD.YYYY  hh:mm"
Test_it()
$sDateFormat = "M.DD.YYYY  hh:mm"
Test_it()
$sDateFormat = "M.D.YYYY  hh:mm"
Test_it()
$sDateFormat = "M.D.YYYY  h:mm"
Test_it()

$sString = "2f - Process Last Run  20140531 - 12:17 (calendar format)"
$sDateFormat = "YYYYMMDD - hh:mm"
Test_it()
$sDateFormat = "YYYYMMDD - h:mm"
Test_it()

$sString = "2g - Process Last Run  20143001  12:17"
$sDateFormat = "YYYYDDMM  hh:mm"
Test_it()
$sDateFormat = "YYYYDDMM  h:mm"
Test_it()

$sString = "2h - Process Last Run  30.11  23:59"
$sDateFormat = "DD.MM  hh:mm"
Test_it()
$sDateFormat = "D.MM  hh:mm"
Test_it()
$sDateFormat = "D.MM  hh:mm"
Test_it()
$sDateFormat = "D.M   h:mm"
Test_it()
Exit
$sString = "2i - Process Last Run  30.11  23:59" & @CRLF & "Second occurence 01.12  00:23"
$sDateFormat = "DD.MM  hh:mm"
Test_it(True, True)

; M
$sString = "3a - Process Last Run 16/12/2014 00:00"
$sDateFormat = "D/M/YYYY hh:mm"
Test_it()

$sString = "3b - Process Last Run 9.2.2014 23:17"
$sDateFormat = "D.M.YYYY hh:mm"
Test_it()

$sString = "3c - Process Last Run 21.2.2014 17:22"
$sDateFormat = "D.M.YYYY hh:mm"
Test_it()

$sString = "3d - Process Last Run 6/11/2013 07:03"
$sDateFormat = "D/M/YYYY hh:mm"
Test_it()

$sString = "3d - Process Last Run  11.27.13 16:25:17"
$sDateFormat = "M.D.YY h:mm:ss"
Test_it()

$sString = "3e - Process Last Run  7.9.13 15:50"
$sDateFormat = "M.D.YY hh:mm"
Test_it()

$sString = "3f - Process Last Run  11.7.13 15:50"
$sDateFormat = "M.D.YY hh:mm"
Test_it()

$sString = "3g - Process Last Run  5.31.14 15:50"
$sDateFormat = "M.D.YY hh:mm"
Test_it()

$sString = "3h - Process Last Run  5.9.14  15:50 (double space between date and time)"
$sDateFormat = "M.D.YY  hh:mm"
Test_it()

$sString = "3i - Process Last Run  5.2.2012 7:35:15 (seconds)"
$sDateFormat = "M.D.YYYY h:mm:ss"
Test_it()

$sString = "3j - Process Last Run  11.28.2010  7:35:15 (double space between date and time)"
$sDateFormat = "M.D.YYYY  h:mm:ss"
Test_it()

$sString = "3k - Process Last Run  11.28 at  17:35:15"
$sDateFormat = "M.D at  h:mm:ss"
Test_it()

$sString = "3l - Process Last Run:  date 11/05/14 time 17:35:15"
$sDateFormat = "date DD/MM/YY time hh:mm:ss"
Test_it()


If $iError > 0 Then MsgBox(0, "", "there are " & $iError & " errors")

Exit

Func Test_it($bDebug = False, $bLastOccurence = False)
	If $bDebug Then
		$bTest = True
	Else
		$bTest = False
	EndIf
	ConsoleWrite(@CR & "@@ Debug(" & @ScriptLineNumber & ") : $sString: " & $sString & " - $sDateFormat: " & $sDateFormat & @CR)
	$sDateReturned = _GetDateInString($sString, $sDateFormat, $bLastOccurence)
	If @error = 1 Then
		ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : Error!  ==> Date Format: " & $sDateFormat & " - Passed string: " & $sString & " Error: Invalid timestamp!" & @CR)
		ConsoleWrite("=================================" & @CR)
		$iError += 1
	ElseIf @error Then
		ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : Error!  ==> Date Format: " & $sDateFormat & " - Passed string: " & $sString & " Error " & @error & " !" & @CR)
		ConsoleWrite(":=================================" & @CR)
		$iError += 1
	Else
		ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : Passed! ==> Date Format: " & $sDateFormat & " - Passed string: " & $sString & " ==> timestamp returned: " & $sDateReturned & @CR)
	EndIf
EndFunc	;==>Test_it

#FUNCTION# ==============================================================
; #FUNCTION# ;===============================================================================
; Name...........: _GetDateInString
; Description ...: Returns a date time string in "YYYY/MM/DD hh:mm:ss" extracted form the passed $_sString using a format
;                  that is different from the resulting timestamp
; Syntax.........: _GetDateInString($_sString, $_sDateFormat)
; Parameters ....: - $_sString: The string to evaluate.
;				   - $_sDateFormat: the date format to be searched for, some examples:
; 						D Mom hh:mm 		==> -rw-r--r--   1 nobody         3 Dec 20 00:21 20131220.nvt.done
; 						DD Mom hh:mm 		==> -rw-r--r--   1 nobody        03 Dec 20 00:21 20131220.nvt.done
; 						DD/MM/YYYY  hh:mm 	==> 03/12/2013  05:07               425 Messages200612200407.txt
; 						D/M/YY hh:mm 		==> 3/5/13 05:07               425 Messages200612200407.txt
; 						DD/MM hh:mm		 	==> FlightDisplay=15/03 12:55
;						other formats allowed, see examples...
;					 Note about the format:
;						The format is case sensitive !
;						YYYY - Year in 4 numerical format (2014, 2015, 1997, etc)
;						YY   - Year in 2 numerical format (14, 15, 97 (this century), etc)
;						Mon  - Month in 3 letter format (Jan - Dec). Only English abbreviated month names are supported !
;						MM   - Month in 2 numerical format with leading zero (01 - 12)
;						M    - Month in numerical format without leading zero (1 - 12)
;						DD   - Day in 2 numerical format with leading zero (01 - 31)
;						D    - Day in numerical format without leading zero (1 - 31)
;						hh   - hour in 2 numerical format with leading zero (00 - 23), AM/PM format is not supported
;						h    - hour in numerical format without leading zero (0 - 23), AM/PM format is not supported
;						mm   - minutes in 2 numerical format with leading zero (00 - 59), format without leading zero is not supported
;						ss   - seconds in numerical format without leading zero (00 - 59), format without leading zero is not supported
; Return values .: Success - time string in "YYYY/MM/DD hh:mm:ss"
;                  Failure - Returns @Error:
;                  |0 - No error.
;				   |1 - $_sString does not contain a valid date
;                  |2 - $_sString does not contain a recognizable time string (hh between 00 and 24 &nd mm between 00 and 59)
;				   |3 - $_sString does not contain a correct seconds string (ss between 00 and 59)
;				   |4 - $_sString does not contain a valid Month
;				   |10 - $_sDateFormat contains none or a wrong hour minutes identifier (h:mm)
;				   |11 - $_sDateFormat contains invalid Month identifier
;				   |12 - $_sDateFormat Month identifier not found
;				   |13 - $_sDateFormat Day identifier not found

; Author ........: GreenCan
; Modified.......:
; Remarks .......: The format requires at least a combination of day, month, hour and minute.
;					The time format require to contain a colon (:)
;					You can eveluate a string containing only a date format, just put ':' as the first parameter
;				   If Year is not mentioned in the format, year is assumed to be the current year.
; 					Date Format recognition issues:
;						- It is not possible to interprete a date in the leading zero format date combination where Hour, Minutes and Year are tight together
;						  example: DMYYYY hh:mm 122014 10:20 is 1 Feb 2014 10:20,
;                         but 1122014 can be either 11 Feb or 1 Nov
;						  therefore $_sDateFormat containing combinations DMY, MDY, YDM or YMD is not allowed
;						  Accepted leading zero formats are M.D.YYYY (or D.M.YY and more combinations)
;					US Time format hh:mm AM/PM is not yet accepted
;
; Related .......:
; Link ..........;
; Example .......; Yes
;				   Formats tested:
;				 	- DDMonYY hh:mm:ss  ( matches dates like 30May14 03:59:59)
;				 	- DD Mon YYYY hh:mm			- Mon, DD YYYY hh:mm:ss			- Mon, D YYYY hh:mm:ss			- DD Mon at hh:mm
;				 	- DMonYY hh:mm:ss			- DMon hh:mm:ss					- DD/MM/YYYY hh:mm				- DD-MM-YYYY  hh:mm
;				  	- DDMMYYYY hh:mm			- DD/MM hh:mm					- MM.DD.YYYY  hh:mm				- YYYYDDMM  hh:mm
;					- YYYYMMDD - hh:mm			- DD.MM  hh:mm					- D/M/YYYY hh:mm				- D.M.YYYY hh:mm
;					- M.D.YY h:mm:ss			- M.D.YY hh:mm					- M.D.YY  hh:mm					- M.D.YYYY h:mm:ss
;					- M.D.YYYY  h:mm:ss			- M.D at  h:mm:ss				- any fancy format like this date DD/MM/YY time hh:mm:ss
;					Many more untested formats should function
;==========================================================================================
Func _GetDateInString($_sString, $_sDateFormat, $bLastOccurence = False)
	Local $aMonth, $aDay, $fileDateString, $cMonth
	Local $iOccurrence = 0, $sTime, $ColonPosInstring, $ColonPosInFormat = StringInStr($_sDateFormat, ":"), $aDateElements[6]

	If Not StringInStr($_sDateFormat, "h:mm", 1) Then Return SetError(10, 0, 0)
	If StringInStr($_sDateFormat, "DMY", 1) Or StringInStr($_sDateFormat, "MDY", 1) Or StringInStr($_sDateFormat, "YDM", 1) Or StringInStr($_sDateFormat, "YMD", 1) Then Return SetError(11, 0, 0)

	; Get hour first from $_sString, either in hh:mm or in h:mm format
	While "Validate time"

		If $bLastOccurence Then
			$iOccurrence -= 1 ; backwards search
		Else
			$iOccurrence += 1
		EndIf
If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $iOccurrence : >" & $iOccurrence & "<" & @CR)
		$ColonPosInstring = StringInStr($_sString, ":", 0, $iOccurrence)
		If $ColonPosInstring > 2 Then
			$sTime = StringMid($_sString,  $ColonPosInstring - 2, 5)
			; if time is valid then exit loop
			If _IsValidTime($sTime) Then
				ExitLoop
			EndIf
		Else
			; found no time string
			If $ColonPosInstring = 0 Then Return SetError(2, 0, 0)
		EndIf
	WEnd

	$aDateElements[3] = StringTrimRight($sTime,3) ; set hour
	If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : Hour : >" & $aDateElements[3] & "<" & @CR)

	If StringInStr($_sDateFormat, " h:", 1) And StringLeft($aDateElements[3], 1) <> " " Then ; if format h:mm and h > 9 thus in fact hh, change the date format for easier checking
		If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $aDateElements[3] : >" & $aDateElements[3] & "<" & @CR)
		If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $_sDateFormat : >" & $_sDateFormat & "<" & @CR)
		$_sDateFormat = StringReplace($_sDateFormat, " h:", " hh:", 1, 1)
		If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $_sDateFormat : >" & $_sDateFormat & "<" & @CR)
		$ColonPosInFormat += 1 ; increase the colon position with 1
	EndIf

	$aDateElements[4] = StringTrimLeft($sTime,3) ; set minutes
	If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : Minutes : >" & $aDateElements[4] & "<" & @CR)
	; seconds
	If StringInStr($_sDateFormat, ":ss", 1) Then
		$aDateElements[5] = StringMid($_sString, $ColonPosInstring + 4, 2) ; set seconds
		; check time validity once more with the seconds now
		If Not _IsValidTime($aDateElements[3] & ":" & $aDateElements[4] & ":" & $aDateElements[5]) Then Return SetError(3, 0, 0) ; Wrong seconds in Time string
	Else
		$aDateElements[5] = "00" ; set seconds to 00, doesn't need to be validated.
	EndIf

	If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $ColonPosInFormat: " & $ColonPosInFormat & @CR)

	; Year (YYYY or YY)
	If StringInStr($_sDateFormat, "YYYY", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat, 'YYYY', 1): " & StringInStr($_sDateFormat, "YYYY", 1) & @CR)
		$aDateElements[0] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "YYYY", 1) ), 4) ; set Year YYYY
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $aDateElements[0] " & $aDateElements[0] & @CR)
	ElseIf StringInStr($_sDateFormat, "YY", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat, 'YY', 1): " & StringInStr($_sDateFormat, "YY", 1) & @CR)
		$aDateElements[0] = "20" & StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "YY", 1) ), 2) ; set Year YY, add the millenium
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $aDateElements[0] " & $aDateElements[0] & @CR)
	Else
		$aDateElements[0] = @YEAR ; year not mentionned in string defaults to current year
	EndIf

	; Month (Mon, MM or M)
	If StringInStr($_sDateFormat, "Mon", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat, 'Mon', 1): " & StringInStr($_sDateFormat, "Mon", 1) & @CR)
		$aDateElements[1] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "Mon", 1) ), 3) ; set Month Mon format
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : Month " & $aDateElements[1] & @CR)
		For $i = 12 To 1 Step - 1
			$cMonth = StringLeft(_DateToMonth($i , 1), 3) ; truncate to 3 left characters
			If StringInStr($aDateElements[1], $cMonth ) > 0 then
				$aDateElements[1] = $i
				If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : Mon: " & $aDateElements[1] & @CR)
				ExitLoop
			EndIf
		Next

	ElseIf StringInStr($_sDateFormat, "MM", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat, 'MM', 1): " & StringInStr($_sDateFormat, "MM", 1) & @CR)
		$aDateElements[1] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "MM", 1) ), 2) ; set Month MM format

	ElseIf StringInStr($_sDateFormat, "M", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat,'M'): " & StringInStr($_sDateFormat, "M", 1) & @CR)

		$aDateElements[1] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "M", 1)  ) -2, 3)
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $aDateElements[1]: " & $aDateElements[1] & @CR)

		; first check if the DM combination is valid, should at least have one non-numeric character in the extracted substring, and not 3 consecutive numbers
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringRegExp ($aDateElements[1], '[0-9][0-9][0-9]' (result must be 0): " & StringRegExp ($aDateElements[1], "[0-9][0-9][0-9]") & @CR)
		If StringRegExp ($aDateElements[1], "[0-9][0-9][0-9]") = 1 Then Return SetError(4, 0, 0) ; regular expression should return 0, string does not contain a separator, $_sString does not contain a valid Day, Month, year combination

		; now check if middle character is a '1' (meaning a two-digit Month
		If StringMid($aDateElements[1], 2, 1) = "1" Then
			; two-digit Month
			; M.D.YY or D.M.YY combination check
			If StringRegExp (StringRight($aDateElements[1], 1), "[0-9]") = 0 Then ; the rightmost chr is not a digit
				$aDateElements[1] = StringLeft($aDateElements[1], 2) ; set Month M format
			Else
				$aDateElements[1] = StringRight($aDateElements[1], 2) ; set Month M format
			EndIf
			$_sDateFormat = StringReplace($_sDateFormat, "M", "MM", 1, 1)
			If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $_sDateFormat : >" & $_sDateFormat & "<" & @CR)
			$ColonPosInFormat += 1 ; increase the colon position with 1
		Else
			; one-digit Month
			If StringRegExp (StringRight($aDateElements[1], 1), "[0-9]") = 0 Then ; the rightmost chr is not a digit
				$aDateElements[1] = StringMid($aDateElements[1], 2, 1) ; set Month M format
			Else
				$aDateElements[1] = StringRight($aDateElements[1], 1) ; set Month M format
			EndIf
		EndIf

	Else
		Return SetError(12, 0, 0) ; Month identifier not found
	EndIf

	; Day
	If StringInStr($_sDateFormat, "DD", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat, 'DD', 1): " & StringInStr($_sDateFormat, "DD", 1) & @CR)
		$aDateElements[2] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "DD", 1) ), 2) ; set Day DD format

	ElseIf StringInStr($_sDateFormat, "D", 1) Then
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringInStr($_sDateFormat,'D'): " & StringInStr($_sDateFormat, "D", 1) & @CR)

		$aDateElements[2] = StringMid($_sString, $ColonPosInstring - ($ColonPosInFormat - StringInStr($_sDateFormat, "D", 1)  ) -2, 3)
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $aDateElements[2]: " & $aDateElements[2] & @CR)

		; first check if the DM combination is valid, should at least have one non-numeric character in the extracted substring, and not 3 consecutive numbers
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringRegExp ($aDateElements[2], '[0-9][0-9][0-9]' (result must be 0): " & StringRegExp ($aDateElements[2], "[0-9][0-9][0-9]") & @CR)
		If StringRegExp ($aDateElements[2], "[0-9][0-9][0-9]") = 1 Then Return SetError(3, 0, 0) ; regular expression should return 0, string does not contain a separator, $_sString does not contain a valid Day, Month, year combination

		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringMid($aDateElements[2], 2, 1): " & StringMid($aDateElements[2], 2, 1) & @CR)
		If $bTest Then ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : StringRegExp (StringMid($aDateElements[2], 2, 1), '[1-3]'): " & StringRegExp (StringMid($aDateElements[2], 2, 1), "[1-3]") & @CR)

		; now check if middle character is a '1' (meaning a two-digit Day
		If StringRegExp (StringMid($aDateElements[2], 2, 1), "[1-3]") = 1 Then
			; two-digit Day
			; M.D.YY or D.M.YY combination check
			If StringRegExp (StringRight($aDateElements[2], 1), "[0-9]") = 0 Then ; the rightmost chr is not a digit
				$aDateElements[2] = StringLeft($aDateElements[2], 2) ; set Day D format
			Else
				$aDateElements[2] = StringRight($aDateElements[2], 2) ; set Day D format
			EndIf
			; next lines are not required, we're done
			$_sDateFormat = StringReplace($_sDateFormat, "D", "DD", 1, 1)
			If $bTest Then ConsoleWrite( "@@ Debug(" & @ScriptLineNumber & ") : $_sDateFormat : >" & $_sDateFormat & "<" & @CR)
			$ColonPosInFormat += 1 ; increase the colon position with 1
		Else
			; one-digit month
			If StringRegExp (StringRight($aDateElements[2], 1), "[0-9]") = 0 Then ; the rightmost chr is not a digit
				$aDateElements[2] = StringMid($aDateElements[2], 2, 1) ; set Day D format
			Else
				$aDateElements[2] = StringRight($aDateElements[2], 1) ; set Day D format
			EndIf
		EndIf
	Else
		Return SetError(13, 0, 0) ; Day identifier not found
	EndIf
	$fileDateString = StringStripWS($aDateElements[0], 8) & "/" & StringFormat("%02s", StringStripWS($aDateElements[1], 8)) & "/" & StringFormat("%02s",  StringStripWS($aDateElements[2], 8)) & " " & StringFormat("%02s", StringStripWS($aDateElements[3], 8)) & ":" & StringFormat("%02s", StringStripWS($aDateElements[4], 8)) & ":" & StringFormat("%02s", StringStripWS($aDateElements[5], 8))

	ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : Date found in string: " & _ArrayToString($aDateElements, "|")& @CR)
	If Not _DateIsValid($fileDateString) Then Return SetError(1, 0, 0) ; Date found is not valid
	Return $fileDateString
EndFunc   ;==>_GetDateInString
#FUNCTION# ==============================================================
Func _IsValidTime($sTime, $LeadingZero = True)
	; $LeadingZero is really optional, and False is only required if the passed time cannot/should not have a leading zero
	If StringInStr($sTime, ":", 0,2) > 0 Then ; includes seconds
		If $LeadingZero Then Return StringRegExp ($sTime,"^(([ 0-1][0-9])|(2[0-3])):[0-5][0-9]:[0-5][0-9]$")
		Return StringRegExp ($sTime,"^(([0-1][0-9])|(2[0-3])):[0-5][0-9]:[0-5][0-9]$")
	Else
		If $LeadingZero Then Return StringRegExp ($sTime,"^(([ 0-1][0-9])|(2[0-3])):[0-5][0-9]$")
		Return StringRegExp ($sTime,"^(([0-1][0-9])|(2[0-3])):[0-5][0-9]$")
	EndIf
EndFunc  ;==>_IsValidTime
#FUNCTION# ==============================================================