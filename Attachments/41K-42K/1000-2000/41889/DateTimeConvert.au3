#include-once
#include <Date.au3>
#AutoIt3Wrapper_AU3Check_Parameters= -d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=Y
; #INDEX# =======================================================================================================================
; Title .........: Time and Date Conversion Library
; AutoIt Version : 3.3.6++
; UDF Version ...: 1.1
; Language ......: English
; Description ...: Converts time between 12 hr and 24 hr with other time and date related functions.
; Dll ...........:
; Author(s) .....: Adam Lawrence (AdamUL)
; Email .........:
; Modified.......:
; Contributors ..:
; Resources .....:
; Remarks .......:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_IsTime12Hr
;_IsTime24Hr
;_Time12HrTo24Hr
;_Time24HrTo12Hr
;_IsCalcDate
;_IsStandardDate
;_IsDateAndTime
;_DateStandardToCalcDate
;_DateCalcToStandardDate
;_IsBetweenTimes
;_IsBetweenDatesTimes
;_IsBetweenDatesTimesLite
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsTime12Hr
; Description ...: Checks to see if a time string is in the 12 hr (AM/PM) format.
; Syntax ........: _IsTime12Hr($sTime)
; Parameters ....: $sTime - A string value in time format.
; Return values .: Success - True
;                  Failure - False, sets @error to:
;                  |0 - String is not in 12 hr time format.
;                  |1 - Invalid time format string.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsTime12Hr($sTime)
	If StringRegExp($sTime, "^(1[0-2]|[1-9]):([0-5]\d):?([0-5]\d)?(?-i:\h*)(?i)([ap]m?)$") Then Return True
	If @error Then Return SetError(1, 0, False)

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsTime24Hr
; Description ...: Checks to see if a time string is in the 24 hr format.
; Syntax ........: _IsTime24Hr($sTime)
; Parameters ....: $sTime - A string value in time format.
; Return values .: Success - True
;                  Failure - False, sets @error to:
;                  |0 - String is not in 24 hr time format.
;                  |1 - Invalid time format string.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsTime24Hr($sTime)
	If StringRegExp($sTime, "^([01]?\d|2[0-3]):([0-5]\d):?([0-5]\d)?$") Then Return True
	If @error Then Return SetError(1, 0, False)

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Time12HrTo24Hr
; Description ...: Convert 12 hr (AM/PM) time string to a 24 hr time string.
; Syntax ........: _Time12HrTo24Hr($sTime[, $fDisplaySecs = True[, $fHourLeadingZero = False]])
; Parameters ....: $sTime - "hh:mm:ss AM/PM" time format.
;                  $fDisplaySecs - [optional] A boolean value to display seconds values. Default is True.
;                  $fHourLeadingZero - [optional] A boolean value to pad leading zero to single digit hours. Default is False.
; Return values .: Success - A string value in "hh:mm:ss" 24 hr time string.
;                  Failure - "", sets @error to:
;                  |1 - Invalid time format string
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......: _Time24HrTo12Hr
; Link ..........:
; Example .......: _Time12HrTo24Hr("12:30AM"), _Time12HrTo24Hr("1:30:45 PM"), _Time12HrTo24Hr("12:30 pm")
; ===============================================================================================================================
Func _Time12HrTo24Hr($sTime, $fDisplaySecs = True, $fHourLeadingZero = False)

	Local $aTime = StringRegExp($sTime, "^(1[0-2]|[1-9]):([0-5]\d):?([0-5]\d)?(?-i:\h*)(?i)([ap]m?)$", 1)
	If @error Then Return SetError(1, 0, "")
	Local $sHour = $aTime[0]
	Local $sMins = $aTime[1]
	Local $sSecs = $aTime[2]
	Local $sAMPM = $aTime[3]

	$sHour = Mod($sHour, 12)
	If StringInStr($sAMPM, "p") Then $sHour += 12

	If $fHourLeadingZero And Number($sHour) < 10 And StringLen($sHour) = 1 Then $sHour = "0" & $sHour
	If $fDisplaySecs And $sSecs = "" Then $sSecs = "00"

	If $fDisplaySecs Then Return $sHour & ":" & $sMins & ":" & $sSecs

	Return $sHour & ":" & $sMins
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _Time24HrTo12Hr
; Description ...: Convert 24 hr time string to a 12 hr (AM/PM) time string.
; Syntax ........: _Time24HrTo12Hr($sTime[, $fDisplaySecs = True[, $fHourLeadingZero = False[, $sAMPMDelim = " "]]])
; Parameters ....: $sTime - A string value in "hh:mm:ss" time format.
;                  $fDisplaySecs - [optional] A boolean value to display seconds values. Default is True.
;                  $fHourLeadingZero - [optional] A boolean value to pad leading zero to single digit hours. Default is False.
;                  $sAMPMDelim - [optional] A string value delimiter to seperate AM/PM from the numeric time. Default is " ".
; Return values .: Success - "hh:mm:ss AM/PM" time format.
;                  Failure - "", sets @error to:
;                  |1 - Invalid time format string.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......: _Time12HrTo24Hr
; Link ..........:
; Example .......: _Time24HrTo12Hr("0:30"), _Time24HrTo12Hr("15:45:36"), _Time24HrTo12Hr("5:36")
; ===============================================================================================================================
Func _Time24HrTo12Hr($sTime, $fDisplaySecs = True, $fHourLeadingZero = False, $sAMPMDelim = " ")

	Local $aTime = StringRegExp($sTime, "^([01]?\d|2[0-3]):([0-5]\d):?([0-5]\d)?$", 1)
	If @error Then Return SetError(1, 0, "")
	If UBound($aTime) = 2 Then ReDim $aTime[3]

	Local $sHour = $aTime[0]
	Local $sMins = $aTime[1]
	Local $sSecs = $aTime[2]
	Local $sAMPM = ""

	Switch $sHour
		Case 0
			$sHour = 12
			$sAMPM = "AM"
		Case 1 To 11
			$sAMPM = "AM"
		Case 12
			$sAMPM = "PM"
		Case 13 To 23
			$sHour = $sHour - 12
			$sAMPM = "PM"
		Case Else
	EndSwitch

	If $fHourLeadingZero And Number($sHour) < 10 And StringLen($sHour) = 1 Then $sHour = "0" & $sHour
	If Not $fHourLeadingZero  And Number($sHour) < 10 And StringLen($sHour) = 2 Then $sHour = Number($sHour)

	If $fDisplaySecs And $sSecs = "" Then $sSecs = "00"

	If $fDisplaySecs Then Return $sHour & ":" & $sMins & ":" & $sSecs & $sAMPMDelim & $sAMPM

	Return $sHour & ":" & $sMins & $sAMPMDelim & $sAMPM
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsCalcDate
; Description ...: Checks to see if a date is in a format for calculations.
; Syntax ........: _IsCalcDate($sDate)
; Parameters ....: $sDate - A string value date format.
; Return values .: Success - True
;                  Failure - False, sets @error to 1.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsCalcDate($sDate)
	If StringRegExp($sDate, "^(\d{4})/(\d{1,2})/(\d{1,2})$") Then Return True
	If @error Then Return SetError(1, 0, False)

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsStandardDate
; Description ...: Checks to see if a date is in a standard date format, "MM/DD/YYYY".
; Syntax ........: _IsStandardDate($sDate)
; Parameters ....: $sDate - A string value in date format.
; Return values .: Success - True
;                  Failure - False, sets @error to 1.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsStandardDate($sDate)
	If StringRegExp($sDate, "^(\d{1,2})/(\d{1,2})/(\d{4})$") Then Return True
	If @error Then Return SetError(1, 0, False)

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsDateAndTime
; Description ...: Checks to see if a string is in a date and time format.
; Syntax ........: _IsDateAndTime($sDateTime)
; Parameters ....: $sDateTime - A string value in date and time format.
; Return values .: Success - True
;                  Failure - False, sets @error to 1.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsDateAndTime($sDateTime)
	Local $sRegEx = "^((?:\d{1,2}/\d{1,2}/\d{4})|(?:\d{4}/\d{1,2}/\d{1,2}))?(?-i:\h*)?((?:1[0-2]|[1-9]):(?:[0-5]\d):?(?:[0-5]\d)?(?-i:\h*)(?i:[ap]m?)|(?:[01]?\d|2[0-3]):(?:[0-5]\d):?(?:[0-5]\d)?)$"

	If StringRegExp($sDateTime, $sRegEx) Then Return True
	If @error Then Return SetError(1, 0, False)

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DateStandardToCalcDate
; Description ...: Convert a date from "MM/DD/YYYY" to "YYYY/MM/DD" format to use in date calculations.
; Syntax ........: _DateStandardToCalcDate($sDate)
; Parameters ....: $sDate - A string value in "MM/DD/YYYY" format.
; Return values .: Success - Calc date string.
;                  Failure - "", sets @error to:
;                  |1 - Invalid date format.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _DateStandardToCalcDate($sDate)
	If Not StringRegExp($sDate, "^(\d{1,2})/(\d{1,2})/(\d{4})$") Then Return SetError(1, 0, "")
	If @error Then Return SetError(1, 0, "")

	Local $sDateNew = StringRegExpReplace($sDate, "(\d{2})/(\d{2})/(\d{4})", "$3/$1/$2")
	$sDateNew = StringRegExpReplace($sDateNew, "(\d{2})/(\d)/(\d{4})", "$3/$1/0$2")
	$sDateNew = StringRegExpReplace($sDateNew, "(\d)/(\d{2})/(\d{4})", "$3/0$1/$2")
	$sDateNew = StringRegExpReplace($sDateNew, "(\d)/(\d)/(\d{4})", "$3/0$1/0$2")

	Return $sDateNew
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _DateCalcToStandardDate
; Description ...: Convert a date from "YYYY/MM/DD" to "MM/DD/YYYY" format.
; Syntax ........: _DateCalcToStandardDate($sDate)
; Parameters ....: $sDate - A string value in "YYYY/MM/DD" format.
; Return values .: Success - Standard date string
;                  Failure - "", sets @error to:
;                  |1 - Invalid date format.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _DateCalcToStandardDate($sDate)
	Local $aDate = StringRegExp($sDate, "^(\d{4})/(\d{1,2})/(\d{1,2})$", 1)
	If @error Then Return SetError(1, 0, "")

	Local $sYear = $aDate[0]
	Local $sMonth = $aDate[1]
	Local $sDay = $aDate[2]

	Return Number($sMonth) & "/" & Number($sDay) & "/" & $sYear

EndFunc

Func _DateTimeStandardToCalcDateTime($sDateTime)
	Local $sRegEx = "^((?:\d{1,2}/\d{1,2}/\d{4})|(?:\d{4}/\d{1,2}/\d{1,2}))?(?-i:\h*)?((?:1[0-2]|[1-9]):(?:[0-5]\d):?(?:[0-5]\d)?(?-i:\h*)(?i:[ap]m?)|(?:[01]?\d|2[0-3]):(?:[0-5]\d):?(?:[0-5]\d)?)$"

	Local $aDateTime = StringRegExp($sDateTime, $sRegEx, 1)
	If @error Then Return SetError(1, 1, "")

	Local $sDate = $aDateTime[0]
	Local $sTime = $aDateTime[1]

	If _IsStandardDate($sDate) Then
		$sDate = _DateStandardToCalcDate($sDate)
		If @error Then Return SetError(2, 1, "")
	EndIf
	If Not _IsCalcDate($sDate) Then Return SetError(2, 2, "")

	If _IsTime12Hr($sTime) Then
		$sTime = _Time12HrTo24Hr($sTime)
		If @error Then Return SetError(3, 1, "")
	EndIf
	If Not _IsTime24Hr($sTime) Then Return SetError(3, 2, "")

	Return $sDate & " " & $sTime
EndFunc

Func _DateTimeCalcToStandardDateTime($sDateTime)
	Local $sRegEx = "^((?:\d{1,2}/\d{1,2}/\d{4})|(?:\d{4}/\d{1,2}/\d{1,2}))?(?-i:\h*)?((?:1[0-2]|[1-9]):(?:[0-5]\d):?(?:[0-5]\d)?(?-i:\h*)(?i:[ap]m?)|(?:[01]?\d|2[0-3]):(?:[0-5]\d):?(?:[0-5]\d)?)$"

	Local $aDateTime = StringRegExp($sDateTime, $sRegEx, 1)
	If @error Then Return SetError(1, 1, "")

	Local $sDate = $aDateTime[0]
	Local $sTime = $aDateTime[1]

	If _IsCalcDate($sDate) Then
		$sDate = _DateCalcToStandardDate($sDate)
		If @error Then Return SetError(2, 1, "")
	EndIf
	If Not _IsStandardDate($sDate) Then Return SetError(2, 2, "")

	If _IsTime24Hr($sTime) Then
		$sTime = _Time24HrTo12Hr($sTime)
		If @error Then Return SetError(3, 1, "")
	EndIf
	If Not _IsTime12Hr($sTime) Then Return SetError(3, 2, "")

	Return $sDate & " " & $sTime
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsBetweenTimes
; Description ...: Test a time to see if it is between the Start Time and the End Time in a 24 hour day.
; Syntax ........: _IsBetweenTimes($sTestTime, $sStartTime, $sEndTime)
; Parameters ....: $sTestTime - A string value time to test, in 12 hr or 24 hr format.
;                  $sStartTime - A string value start Time, must be before End Time in 12 hr or 24 hr format.
;                  $sEndTime - A string value end Time, must be after Start Time in 12 hr or 24 hr format.
; Return values .: Success - True
;                  Failure - False, sets @error to:
;                  |0 - Not between times.
;                  |1 - Invalid 12 Hr format.
;                  |2 - Invalid 24 Hr format.
;                  |3 - Invalid time string.
;                  |4 - End Time before Start Time.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsBetweenTimes($sTestTime, $sStartTime, $sEndTime)

	If _IsTime12Hr($sTestTime) Then
		$sTestTime = _Time12HrTo24Hr($sTestTime)
		If @error Then Return SetError(1, 1, False)
	EndIf

	If _IsTime12Hr($sStartTime) Then
		$sStartTime = _Time12HrTo24Hr($sStartTime)
		If @error Then Return SetError(1, 2, False)
	EndIf

	If _IsTime12Hr($sEndTime) Then
		$sEndTime = _Time12HrTo24Hr($sEndTime)
		If @error Then Return SetError(1, 3, False)
	EndIf

	If Not _IsTime24Hr($sTestTime) Then Return SetError(2, 1, False)
	If Not _IsTime24Hr($sStartTime) Then Return SetError(2, 2, False)
	If Not _IsTime24Hr($sEndTime) Then Return SetError(2, 3, False)

	$sTestTime = StringReplace(StringStripWS($sTestTime, 8), ":", "")
	If @error Or @extended > 2 Then Return SetError(3, 1, False)
	If @extended = 1 Then $sTestTime &= "00"
	Local $iTestTime = Number($sTestTime)

	$sStartTime = StringReplace(StringStripWS($sStartTime, 8), ":", "")
	If @error Or @extended > 2 Then Return SetError(3, 2, False)
	If @extended = 1 Then $sStartTime &= "00"
	Local $iStartTime = Number($sStartTime)

	$sEndTime = StringReplace(StringStripWS($sEndTime, 8), ":", "")
	If @error Or @extended > 2 Then Return SetError(3, 3, False)
	If @extended = 1 Then $sEndTime &= "00"
	Local $iEndTime = Number($sEndTime)

	If $iEndTime < $iStartTime Then Return SetError(4, 0, False)

	If $iTestTime >= $iStartTime And $iTestTime <= $iEndTime Then Return True

	Return False

EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsBetweenDatesTimes
; Description ...: Test a time to see if it is between the Start Date and Time and the End Date and Time.
; Syntax ........: _IsBetweenDatesTimes($sTestDateTime, $sStartDateTime, $sEndDateTime)
; Parameters ....: $sTestDateTime - A string value, Date and Time to test, in 12 hr or 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
;                  $sStartDateTime - A string value, Start Date and Time, must be before End Date and Time in 12 hr or 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
;                  $sEndDateTime - A string value, End Date and Time, must be after Start Date and Time in 12 hr or 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
; Return values .: Success - True
;                  Failure - False, sets @error to:
;                  |1 - Invalid date format.
;                  |2 - Error Converting to Calc date.
;                  |3 - Invalid time format.
;                  |4 - Invalid $sTestDateTime
;                  |5 - Invalid $sStartDateTime
;                  |6 - Invalid $sEndDateTime
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......:
; Related .......: _IsBetweenDatesTimesLite, _IsBetweenTimes
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsBetweenDatesTimes($sTestDateTime, $sStartDateTime, $sEndDateTime)
	Local $sRegEx = "^((?:\d{1,2}/\d{1,2}/\d{4})|(?:\d{4}/\d{1,2}/\d{1,2}))?(?-i:\h*)?((?:1[0-2]|[1-9]):(?:[0-5]\d):?(?:[0-5]\d)?(?-i:\h*)(?i:[ap]m?)|(?:[01]?\d|2[0-3]):(?:[0-5]\d):?(?:[0-5]\d)?)$"

	Local $aTestDateTime = StringRegExp($sTestDateTime, $sRegEx, 1)
	If @error Then Return SetError(1, 1, False)

	Local $sTestDate = $aTestDateTime[0]
	Local $sTestTime = $aTestDateTime[1]

	Local $aStartDateTime = StringRegExp($sStartDateTime, $sRegEx, 1)
	If @error Then Return SetError(1, 2, False)

	Local $sStartDate = $aStartDateTime[0]
	Local $sStartTime = $aStartDateTime[1]

	Local $aEndDateTime = StringRegExp($sEndDateTime, $sRegEx, 1)
	If @error Then Return SetError(1, 3, False)

	Local $sEndDate = $aEndDateTime[0]
	Local $sEndTime = $aEndDateTime[1]

	Select
		Case $sTestDate = "" And $sStartDate = "" And $sEndDate = ""
			$sTestDate = _NowCalcDate()
			$sStartDate = $sTestDate
			$sEndDate = $sTestDate
		Case $sTestDate <> "" And $sStartDate <> "" And $sEndDate <> ""
		Case $sTestDate = "" And $sStartDate <> "" And $sEndDate <> ""
			ContinueCase
		Case $sTestDate <> "" And $sStartDate = "" And $sEndDate <> ""
			ContinueCase
		Case $sTestDate <> "" And $sStartDate <> "" And $sEndDate = ""
			ContinueCase
		Case Else
			Return SetError(1, 4, False)
	EndSelect

	If _IsStandardDate($sTestDate) Then
		$sTestDate = _DateStandardToCalcDate($sTestDate)
		If @error Then Return SetError(2, 1, False)
	EndIf
	If _IsStandardDate($sStartDate) Then
		$sStartDate = _DateStandardToCalcDate($sStartDate)
		If @error Then Return SetError(2, 2, False)
	EndIf
	If _IsStandardDate($sEndDate) Then
		$sEndDate = _DateStandardToCalcDate($sEndDate)
		If @error Then Return SetError(2, 3, False)
	EndIf

	If Not _IsCalcDate($sTestDate) Then Return SetError(3, 1, False)
	If Not _IsCalcDate($sStartDate) Then Return SetError(3, 2, False)
	If Not _IsCalcDate($sEndDate) Then Return SetError(3, 3, False)

	$sTestDate = $sTestDate & " "
	$sStartDate = $sStartDate & " "
	$sEndDate = $sEndDate & " "

	If _IsTime12Hr($sTestTime) Then
		$sTestTime = _Time12HrTo24Hr($sTestTime)
		If @error Then Return SetError(2, 4, False)
	EndIf
	If _IsTime12Hr($sStartTime) Then
		$sStartTime = _Time12HrTo24Hr($sStartTime)
		If @error Then Return SetError(2, 5, False)
	EndIf
	If _IsTime12Hr($sEndTime) Then
		$sEndTime = _Time12HrTo24Hr($sEndTime)
		If @error Then Return SetError(2, 6, False)
	EndIf

	If Not _IsTime24Hr($sTestTime) Then Return SetError(3, 4, False)
	If Not _IsTime24Hr($sStartTime) Then Return SetError(3, 5, False)
	If Not _IsTime24Hr($sEndTime) Then Return SetError(3, 6, False)

	$sTestDateTime = $sTestDate & $sTestTime
	$sStartDateTime = $sStartDate & $sStartTime
	$sEndDateTime = $sEndDate & $sEndTime

	Local $sStartTestDateTimeDiff = _DateDiff("s", $sStartDateTime, $sTestDateTime)
	Switch @error
		Case 2
			Return SetError(5, @error, False)
		Case 3
			Return SetError(4, @error, False)
	EndSwitch

	Local $sEndTestDateTimeDiff = _DateDiff("s", $sTestDateTime, $sEndDateTime)
	Switch @error
		Case 2
			Return SetError(4, @error, False)
		Case 3
			Return SetError(6, @error, False)
	EndSwitch

	If $sStartTestDateTimeDiff >= 0 And $sEndTestDateTimeDiff >= 0 Then Return True

	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _IsBetweenDatesTimesLite
; Description ...: Test a time to see if it is between the Start Date and Time and the End Date and Time.
; Syntax ........: _IsBetweenDatesTimesLite($sTestDateTime, $sStartDateTime, $sEndDateTime)
; Parameters ....: $sTestDateTime - A string value, Date and Time to test, in 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
;                  $sStartDateTime - A string value, Start Date and Time, must be before End Date and Time in 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
;                  $sEndDateTime - A string value, End Date and Time, must be after Start Date and Time in 24 hr format "YYYY/MM/DD[ HH:MM:SS]".
; Return values .: Success - True
;                  Failure - False, sets @error to:
;                  |1 - Invalid sTestDateTime.
;                  |2 - Invalid $sStartDateTime.
;                  |3 - Invalid $sEndDateTime.
; Author ........: Adam Lawrence (AdamUL)
; Modified ......:
; Remarks .......: Faster return than the _IsBetweenDatesTimes function, but more retricted on the format of the date and time entered.
; Related .......: _IsBetweenDatesTimes, _IsBetweenTimes
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func _IsBetweenDatesTimesLite($sTestDateTime, $sStartDateTime, $sEndDateTime)

	Local $sStartTestDateTimeDiff = _DateDiff("s", $sStartDateTime, $sTestDateTime)
	Switch @error
		Case 2
			Return SetError(2, @error, False)
		Case 3
			Return SetError(1, @error, False)
	EndSwitch

	Local $sEndTestDateTimeDiff = _DateDiff("s", $sTestDateTime, $sEndDateTime)
	Switch @error
		Case 2
			Return SetError(1, @error, False)
		Case 3
			Return SetError(3, @error, False)
	EndSwitch

	If $sStartTestDateTimeDiff >= 0 And $sEndTestDateTimeDiff >= 0 Then Return True

	Return False
EndFunc