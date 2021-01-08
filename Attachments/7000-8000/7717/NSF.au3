; <AUT2EXE VERSION: 3.1.1.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: F:\Source Code\NSF.au3>
; ----------------------------------------------------------------------------

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\Include\Date.au3>
; ----------------------------------------------------------------------------

; version 2004/12/11 - 4
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Functions that assist with dates and times.
;
; ==============================================================================
; VERSION       DATE       DESCRIPTION
; -------    ----------    -----------------------------------------------------
; v1.0.00    01/21/2004    Initial release
; v1.0.01    02/05/2004    Fixed: _TicksToTime and _TimeToTicks
; v1.0.02    02/06/2004    Fixed: _TicksToTime
; v1.0.03    02/12/2004    Added: _DateAdd, _DateDiff, _DateToDayValue, _DayValueToDate
;                                 _DateTimeFormat, _DateToDayOfWeek, _DateIsValid
;                                 _DateTimeSplit, _Now(), _NowTime(), _NowDate(),_DateDaysInMonth()
;                                 _DateDayOfWeek(), Nowcalc()
; v1.0.04    12/11/2004    Updated: _DateAdd: change logic to make it faster.
; ------------------------------------------------------------------------------

;===============================================================================
;
; Description:      Calculates a new date based on a given date and add an interval.
; Parameter(s):     $sType    D = Add number of days to the given date
;                             M = Add number of months to the given date
;                             Y = Add number of years to the given date
;                             w = Add number of Weeks to the given date
;                             h = Add number of hours to the given date
;                             n = Add number of minutes to the given date
;                             s = Add number of seconds to the given date
;                   $iValToAdd - number to be added
;                   $sDate    - Input date in the format YYYY/MM/DD[ HH:MM:SS]
; Requirement(s):   None
; Return Value(s):  On Success - Date newly calculated date.
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sType
;                                                  2 - Invalid $iValToAdd
;                                                  3 - Invalid $sDate
; Author(s):        Jos van der Zande
; Note(s):          The function will not return an invalid date.
;                   When 3 months is are to '2004/1/31' then the result will be 2004/04/30
;
;
;===============================================================================
Func _DateAdd($sType, $iValToAdd, $sDate)
	Local $asTimePart[4]
	Local $asDatePart[4]
	Local $iJulianDate
	Local $iTimeVal
	Local $iNumDays
	Local $Y
	Local $Day2Add
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("D,M,Y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		SetError(1)
		Return (0)
	EndIf
	; Verify that Value to Add  is Valid
	If Not StringIsInt($iValToAdd) Then
		SetError(2)
		Return (0)
	EndIf
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		SetError(3)
		Return (0)
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	
	; ====================================================
	; adding days then get the julian date
	; add the number of day
	; and convert back to Gregorian
	If $sType = "d" Or $sType = "w" Then
		If $sType = "w" Then $iValToAdd = $iValToAdd * 7
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $iValToAdd
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
	EndIf
	; ====================================================
	; adding Months
	If $sType == "m" Then
		$asDatePart[2] = $asDatePart[2] + $iValToAdd
		; pos number of months
		While $asDatePart[2] > 12
			$asDatePart[2] = $asDatePart[2] - 12
			$asDatePart[1] = $asDatePart[1] + 1
		WEnd
		; Neg number of months
		While $asDatePart[2] < 1
			$asDatePart[2] = $asDatePart[2] + 12
			$asDatePart[1] = $asDatePart[1] - 1
		WEnd
	EndIf
	; ====================================================
	; adding Years
	If $sType = "y" Then
		$asDatePart[1] = $asDatePart[1] + $iValToAdd
	EndIf
	; ====================================================
	; adding Time value
	If $sType = "h" Or $sType = "n" Or $sType = "s" Then
		$iTimeVal = _TimeToTicks($asTimePart[1], $asTimePart[2], $asTimePart[3]) / 1000
		If $sType = "h" Then $iTimeVal = $iTimeVal + $iValToAdd * 3600
		If $sType = "n" Then $iTimeVal = $iTimeVal + $iValToAdd * 60
		If $sType = "s" Then $iTimeVal = $iTimeVal + $iValToAdd
		; calculated days to add
		$Day2Add = Int($iTimeVal/ (24 * 60 * 60))
		$iTimeVal = $iTimeVal - $Day2Add * 24 * 60 * 60
		If $iTimeVal < 0 Then
			$Day2Add = $Day2Add - 1
			$iTimeVal = $iTimeVal + 24 * 60 * 60
		EndIf
		$iJulianDate = _DateToDayValue($asDatePart[1], $asDatePart[2], $asDatePart[3]) + $Day2Add
		; calculate the julian back to date
		_DayValueToDate($iJulianDate, $asDatePart[1], $asDatePart[2], $asDatePart[3])
		; caluculate the new time
		_TicksToTime($iTimeVal * 1000, $asTimePart[1], $asTimePart[2], $asTimePart[3])
	EndIf
	; ====================================================
	; check if the Input day is Greater then the new month last day.
	; if so then change it to the last possible day in the month
	$iNumDays = StringSplit('31,28,31,30,31,30,31,31,30,31,30,31', ',')
	If _DateIsLeapYear($asDatePart[1]) Then $iNumDays[2] = 29
	;
	If $iNumDays[$asDatePart[2]] < $asDatePart[3] Then $asDatePart[3] = $iNumDays[$asDatePart[2]]
	; ========================
	; Format the return date
	; ========================
	; Format the return date
	$sDate = $asDatePart[1] & '/' & StringRight("0" & $asDatePart[2], 2) & '/' & StringRight("0" & $asDatePart[3], 2)
	; add the time when specified in the input
	If $asTimePart[0] > 0 Then
		If $asTimePart[0] > 2 Then
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2) & ':' & StringRight("0" & $asTimePart[3], 2)
		Else
			$sDate = $sDate & " " & StringRight("0" & $asTimePart[1], 2) & ':' & StringRight("0" & $asTimePart[2], 2)
		EndIf
	EndIf
	;
	return ($sDate)
EndFunc   ;==>_DateAdd

;===============================================================================
;
; Description:      Returns the name of the weekday, based on the specified day.
; Parameter(s):     $iDayNum - Day number
;                   $iShort  - Format:
;                              0 = Long name of the weekday
;                              1 = Abbreviated name of the weekday
; Requirement(s):   None
; Return Value(s):  On Success - Weekday name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          English only
;
;===============================================================================
Func _DateDayOfWeek($iDayNum, $iShort = 0)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aDayOfWeek[8]
	
	$aDayOfWeek[1] = "Sunday"
	$aDayOfWeek[2] = "Monday"
	$aDayOfWeek[3] = "Tuesday"
	$aDayOfWeek[4] = "Wednesday"
	$aDayOfWeek[5] = "Thursday"
	$aDayOfWeek[6] = "Friday"
	$aDayOfWeek[7] = "Saturday"
	Select
		Case Not StringIsInt($iDayNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iDayNum < 1 Or $iDayNum > 7
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aDayOfWeek[$iDayNum]
				Case $iShort = 1
					Return StringLeft($aDayOfWeek[$iDayNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateDayOfWeek

;===============================================================================
;
; Function Name:  _DateDaysInMonth()
; Description:    Returns the number of days in a month, based on the specified
;                 month and year.
; Author(s):      Jeremy Landes <jlandes@landeserve.com>
;
;===============================================================================
Func _DateDaysInMonth($iYear, $iMonthNum)
	Local $aiNumDays
	
	$aiNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$aiNumDays = StringSplit($aiNumDays, ",")
	
	If _DateIsMonth($iMonthNum) And _DateIsYear($iYear) Then
		If _DateIsLeapYear($iYear) Then $aiNumDays[2] = $aiNumDays[2] + 1
		SetError(0)
		Return $aiNumDays[$iMonthNum]
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_DateDaysInMonth

;===============================================================================
;
; Description:      Returns the difference between 2 dates, expressed in the type requested
; Parameter(s):     $sType - returns the difference in:
;                               d = days
;                               m = Months
;                               y = Years
;                               w = Weeks
;                               h = Hours
;                               n = Minutes
;                               s = Seconds
;                   $sStartDate    - Input Start date in the format "YYYY/MM/DD[ HH:MM:SS]"
;                   $sEndDate    - Input End date in the format "YYYY/MM/DD[ HH:MM:SS]"
; Requirement(s):   None
; Return Value(s):  On Success - Difference between the 2 dates
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sType
;                                               2 - Invalid $sStartDate
;                                               3 - Invalid $sEndDate
; Author(s):        Jos van der Zande
; Note(s):
;
;===============================================================================
Func _DateDiff($sType, $sStartDate, $sEndDate)
	Local $asStartDatePart[4]
	Local $asStartTimePart[4]
	Local $asEndDatePart[4]
	Local $asEndTimePart[4]
	Local $iTimeDiff
	Local $iYearDiff
	Local $iMonthDiff
	Local $iStartTimeInSecs
	Local $iEndTimeInSecs
	Local $aDaysDiff
	;
	; Verify that $sType is Valid
	$sType = StringLeft($sType, 1)
	If StringInStr("d,m,y,w,h,n,s", $sType) = 0 Or $sType = "" Then
		SetError(1)
		Return (0)
	EndIf
	; Verify If StartDate is valid
	If Not _DateIsValid($sStartDate) Then
		SetError(2)
		Return (0)
	EndIf
	; Verify If EndDate is valid
	If Not _DateIsValid($sEndDate) Then
		SetError(3)
		Return (0)
	EndIf
	; split the StartDate and Time into arrays
	_DateTimeSplit($sStartDate, $asStartDatePart, $asStartTimePart)
	; split the End  Date and time into arrays
	_DateTimeSplit($sEndDate, $asEndDatePart, $asEndTimePart)
	; ====================================================
	; Get the differens in days between the 2 dates
	$aDaysDiff = _DateToDayValue($asEndDatePart[1], $asEndDatePart[2], $asEndDatePart[3]) - _DateToDayValue($asStartDatePart[1], $asStartDatePart[2], $asStartDatePart[3])
	; ====================================================
	; Get the differens in Seconds between the 2 times when specified
	If $asStartTimePart[0] > 1 And $asEndTimePart[0] > 1 Then
		$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
		$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
		$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
		If $iTimeDiff < 0 Then
			$aDaysDiff = $aDaysDiff - 1
			$iTimeDiff = $iTimeDiff + 24 * 60 * 60
		EndIf
	Else
		$iTimeDiff = 0
	EndIf
	Select
		Case $sType = "d"
			Return ($aDaysDiff)
		Case $sType = "m"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			$iMonthDiff = $asEndDatePart[2] - $asStartDatePart[2] + $iYearDiff * 12
			If $asEndDatePart[3] < $asStartDatePart[3] Then $iMonthDiff = $iMonthDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iMonthDiff = $iMonthDiff - 1
			Return ($iMonthDiff)
		Case $sType = "y"
			$iYearDiff = $asEndDatePart[1] - $asStartDatePart[1]
			If $asEndDatePart[2] < $asStartDatePart[2] Then $iYearDiff = $iYearDiff - 1
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] < $asStartDatePart[3] Then $iYearDiff = $iYearDiff - 1
			$iStartTimeInSecs = $asStartTimePart[1] * 3600 + $asStartTimePart[2] * 60 + $asStartTimePart[3]
			$iEndTimeInSecs = $asEndTimePart[1] * 3600 + $asEndTimePart[2] * 60 + $asEndTimePart[3]
			$iTimeDiff = $iEndTimeInSecs - $iStartTimeInSecs
			If $asEndDatePart[2] = $asStartDatePart[2] And $asEndDatePart[3] = $asStartDatePart[3] And $iTimeDiff < 0 Then $iYearDiff = $iYearDiff - 1
			Return ($iYearDiff)
		Case $sType = "w"
			Return (Int($aDaysDiff / 7))
		Case $sType = "h"
			Return ($aDaysDiff * 24 + Int($iTimeDiff / 3600))
		Case $sType = "n"
			Return ($aDaysDiff * 24 * 60 + Int($iTimeDiff / 60))
		Case $sType = "s"
			Return ($aDaysDiff * 24 * 60 * 60 + $iTimeDiff)
	EndSelect
EndFunc   ;==>_DateDiff

;===============================================================================
;
; Description:      Returns 1 if the specified year falls on a leap year and
;                   returns 0 if it does not.
; Parameter(s):     $iYear - Year to check
; Requirement(s):   None
; Return Value(s):  On Success - 0 = Year is not a leap year
;                                1 = Year is a leap year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateIsLeapYear($iYear)
	If StringIsInt($iYear) Then
		Select
			Case Mod($iYear, 4) = 0 And Mod($iYear, 100) <> 0
				Return 1
			Case Mod($iYear, 400) = 0
				Return 1
			Case Else
				Return 0
		EndSelect
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_DateIsLeapYear

;===============================================================================
;
; Function Name:  _DateIsMonth()
; Description:    Checks a given number to see if it is a valid month.
; Author(s):      Jeremy Landes <jlandes@landeserve.com>
;
;===============================================================================
Func _DateIsMonth($iNumber)
	If StringIsInt($iNumber) Then
		If $iNumber >= 1 And $iNumber <= 12 Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_DateIsMonth

;===============================================================================
;
; Description:      Verify if date and time are valid "yyyy/mm/dd[ hh:mm[:ss]]".
; Parameter(s):     $sDate format "yyyy/mm/dd[ hh:mm[:ss]]"
; Requirement(s):   None
; Return Value(s):  On Success - 1
;                   On Failure - 0
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
;                   Jos van der Zande <jdeb@autoitscript.com>
; Note(s):          None
;
;===============================================================================
Func _DateIsValid($sDate)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $iNumDays
	
	$iNumDays = "31,28,31,30,31,30,31,31,30,31,30,31"
	$iNumDays = StringSplit($iNumDays, ",")
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	
	If $asDatePart[0] <> 3 Then
		Return (0)
	EndIf
	; verify valid input date values
	If _DateIsLeapYear($asDatePart[1]) Then $iNumDays[2] = 29
	If $asDatePart[1] < 1900 Or $asDatePart[1] > 2999 Then Return (0)
	If $asDatePart[2] < 1 Or $asDatePart[2] > 12 Then Return (0)
	If $asDatePart[3] < 1 Or $asDatePart[3] > $iNumDays[$asDatePart[2]] Then Return (0)
	
	; verify valid input Time values
	If $asTimePart[0] < 1 Then Return (1)    ; No time specified so date must be correct
	If $asTimePart[0] < 3 Then Return (0)    ; need at least HH:MM when something is specified
	If $asTimePart[1] < 0 Or $asTimePart[1] > 23 Then Return (0)
	If $asTimePart[2] < 0 Or $asTimePart[2] > 59 Then Return (0)
	If $asTimePart[3] < 0 Or $asTimePart[3] > 59 Then Return (0)
	; we got here so date/time must be good
	Return (1)
EndFunc   ;==>_DateIsValid

;===============================================================================
;
; Function Name:  _DateIsYear()
; Description:    Checks a given number to see if it is a valid year.
; Author(s):      Jeremy Landes <jlandes@landeserve.com>
;
;===============================================================================
Func _DateIsYear($iNumber)
	If StringIsInt($iNumber) Then
		If StringLen($iNumber) = 4 Then
			Return 1
		Else
			Return 0
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_DateIsYear

;===============================================================================
;
; Description:      Returns previous weekday number, based on the specified day
;                   of the week.
; Parameter(s):     $iWeekdayNum - Weekday number
; Requirement(s):   None
; Return Value(s):  On Success - Previous weekday number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateLastWeekdayNum($iWeekdayNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastWeekdayNum
	
	Select
		Case Not StringIsInt($iWeekdayNum)
			SetError(1)
			Return 0
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			SetError(1)
			Return 0
		Case Else
			If $iWeekdayNum = 1 Then
				$iLastWeekdayNum = 7
			Else
				$iLastWeekdayNum = $iWeekdayNum - 1
			EndIf
			
			Return $iLastWeekdayNum
	EndSelect
EndFunc   ;==>_DateLastWeekdayNum

;===============================================================================
;
; Description:      Returns previous month number, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
; Requirement(s):   None
; Return Value(s):  On Success - Previous month number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateLastMonthNum($iMonthNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastMonthNum
	
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 1 Then
				$iLastMonthNum = 12
			Else
				$iLastMonthNum = $iMonthNum - 1
			EndIf
			
			$iLastMonthNum = StringFormat( "%02d", $iLastMonthNum)
			Return $iLastMonthNum
	EndSelect
EndFunc   ;==>_DateLastMonthNum

;===============================================================================
;
; Description:      Returns previous month's year, based on the specified month
;                   and year.
; Parameter(s):     $iMonthNum - Month number
;                   $iYear     - Year
; Requirement(s):   None
; Return Value(s):  On Success - Previous month's year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateLastMonthYear($iMonthNum, $iYear)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iLastYear
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 1 Then
				$iLastYear = $iYear - 1
			Else
				$iLastYear = $iYear
			EndIf
			
			$iLastYear = StringFormat( "%04d", $iLastYear)
			Return $iLastYear
	EndSelect
EndFunc   ;==>_DateLastMonthYear

;===============================================================================
;
; Description:      Returns the name of the month, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
;                   $iShort    - Format:
;                                0 = Long name of the month
;                                1 = Abbreviated name of the month
; Requirement(s):   None
; Return Value(s):  On Success - Month name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          English only
;
;===============================================================================
Func _DateMonthOfYear($iMonthNum, $iShort)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aMonthOfYear[13]
	
	$aMonthOfYear[1] = "January"
	$aMonthOfYear[2] = "February"
	$aMonthOfYear[3] = "March"
	$aMonthOfYear[4] = "April"
	$aMonthOfYear[5] = "May"
	$aMonthOfYear[6] = "June"
	$aMonthOfYear[7] = "July"
	$aMonthOfYear[8] = "August"
	$aMonthOfYear[9] = "September"
	$aMonthOfYear[10] = "October"
	$aMonthOfYear[11] = "November"
	$aMonthOfYear[12] = "December"
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iShort)
			SetError(1)
			Return ""
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return ""
		Case Else
			Select
				Case $iShort = 0
					Return $aMonthOfYear[$iMonthNum]
				Case $iShort = 1
					Return StringLeft($aMonthOfYear[$iMonthNum], 3)
				Case Else
					SetError(1)
					Return ""
			EndSelect
	EndSelect
EndFunc   ;==>_DateMonthOfYear

;===============================================================================
;
; Description:      Returns next weekday number, based on the specified day of
;                   the week.
; Parameter(s):     $iWeekdayNum - Weekday number
; Requirement(s):   None
; Return Value(s):  On Success - Next weekday number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateNextWeekdayNum($iWeekdayNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextWeekdayNum
	
	Select
		Case Not StringIsInt($iWeekdayNum)
			SetError(1)
			Return 0
		Case $iWeekdayNum < 1 Or $iWeekdayNum > 7
			SetError(1)
			Return 0
		Case Else
			If $iWeekdayNum = 7 Then
				$iNextWeekdayNum = 1
			Else
				$iNextWeekdayNum = $iWeekdayNum + 1
			EndIf
			
			Return $iNextWeekdayNum
	EndSelect
EndFunc   ;==>_DateNextWeekdayNum

;===============================================================================
;
; Description:      Returns next month number, based on the specified month.
; Parameter(s):     $iMonthNum - Month number
; Requirement(s):   None
; Return Value(s):  On Success - Next month number
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateNextMonthNum($iMonthNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextMonthNum
	
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 12 Then
				$iNextMonthNum = 1
			Else
				$iNextMonthNum = $iMonthNum + 1
			EndIf
			
			$iNextMonthNum = StringFormat( "%02d", $iNextMonthNum)
			Return $iNextMonthNum
	EndSelect
EndFunc   ;==>_DateNextMonthNum

;===============================================================================
;
; Description:      Returns next month's year, based on the specified month and
;                   year.
; Parameter(s):     $iMonthNum - Month number
;                   $iYear     - Year
; Requirement(s):   None
; Return Value(s):  On Success - Next month's year
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jeremy Landes <jlandes@landeserve.com>
; Note(s):          None
;
;===============================================================================
Func _DateNextMonthYear($iMonthNum, $iYear)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iNextYear
	
	Select
		Case Not StringIsInt($iMonthNum) Or Not StringIsInt($iYear)
			SetError(1)
			Return 0
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return 0
		Case Else
			If $iMonthNum = 12 Then
				$iNextYear = $iYear + 1
			Else
				$iNextYear = $iYear
			EndIf
			
			$iNextYear = StringFormat( "%04d", $iNextYear)
			Return $iNextYear
	EndSelect
EndFunc   ;==>_DateNextMonthYear

;===============================================================================
;
; Description:      Split Date and Time into two separateArrays.
; Parameter(s):     $sDate format "yyyy/mm/dd[ hh:mm[:ss]]"
;                    or    format "yyyy/mm/dd[Thh:mm[:ss]]"
;                    or    format "yyyy-mm-dd[ hh:mm[:ss]]"
;                    or    format "yyyy-mm-dd[Thh:mm[:ss]]"
;                    or    format "yyyy.mm.dd[ hh:mm[:ss]]"
;                    or    format "yyyy.mm.dd[Thh:mm[:ss]]"
;                   $asDatePart[4] array that contains the Date
;                   $iTimePart[4] array that contains the Time
; Requirement(s):   None
; Return Value(s):  Always 1
; Author(s):        Jos van der Zande
; Note(s):          Its expected you first do a _DateIsValid( $sDate ) for the input
;
;===============================================================================
Func _DateTimeSplit($sDate, ByRef $asDatePart, ByRef $iTimePart)
	Local $nMM
	Local $nDD
	Local $nYYYY
	Local $sDateTime
	; split the Date and Time portion
	$sDateTime = StringSplit($sDate, " T")
	; split the date portion
	If $sDateTime[0] > 0 Then $asDatePart = StringSplit($sDateTime[1], "/-.")
	; split the Time portion
	If $sDateTime[0] > 1 Then
		; Add the secconf 00 if not in the input
		If StringLen($sDateTime[2]) < 8 Then $sDateTime[2] = $sDateTime[2] & ":00"
		$iTimePart = StringSplit($sDateTime[2], ":")
	EndIf
	Return (1)
EndFunc   ;==>_DateTimeSplit

;===============================================================================
;
; Description:      Returns the number of days since noon 4713 BC January 1.
; Parameter(s):     $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Juliandate
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jos van der Zande / Jeremy Landes
; Note(s):          None
;
;===============================================================================
Func _DateToDayValue($iYear, $iMonth, $iDay)
	Local $i_aFactor
	Local $i_bFactor
	Local $i_cFactor
	Local $i_dFactor
	Local $i_eFactor
	Local $i_fFactor
	Local $asDatePart[4]
	Local $iJulianDate
	; Verify If InputDate is valid
	If Not _DateIsValid(StringFormat( "%04d/%02d/%02d", $iYear, $iMonth, $iDay)) Then
		SetError(1)
		Return ("")
	EndIf
	If $iMonth < 3 Then
		$iMonth = $iMonth + 12
		$iYear = $iYear - 1
	EndIf
	$i_aFactor = Int($iYear / 100)
	$i_bFactor = Int($i_aFactor / 4)
	$i_cFactor = 2 - $i_aFactor + $i_bFactor
	$i_eFactor = Int(1461 * ($iYear + 4716) / 4)
	$i_fFactor = Int(153 * ($iMonth + 1) / 5)
	$iJulianDate = $i_cFactor + $iDay + $i_eFactor + $i_fFactor - 1524.5
	return ($iJulianDate)
EndFunc   ;==>_DateToDayValue

;===============================================================================
;
; Description:      Returns the DayofWeek number for a given Date.  1=Sunday
; Parameter(s):     $Year
;                   $Month
;                   $day
; Requirement(s):   None
; Return Value(s):  On Success - Returns Day of the Week Range is 1 to 7 where 1=Sunday.
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Jos van der Zande <jdeb@autoitscript.com>
; Note(s):          None
;
;===============================================================================
Func _DateToDayOfWeek($iYear, $iMonth, $iDay)
	Local $asDatePart[4]
	Local $i_aFactor
	Local $i_yFactor
	Local $i_mFactor
	Local $i_dFactor
	; Verify If InputDate is valid
	If Not _DateIsValid($iYear & "/" & $iMonth & "/" & $iDay) Then
		SetError(1)
		Return ("")
	EndIf
	$i_aFactor = Int((14 - $iMonth) / 12)
	$i_yFactor = $iYear - $i_aFactor
	$i_mFactor = $iMonth + (12 * $i_aFactor) - 2
	$i_dFactor = Mod($iDay + $i_yFactor + Int($i_yFactor / 4) - Int($i_yFactor / 100) + Int($i_yFactor / 400) + Int((31 * $i_mFactor) / 12), 7)
	return ($i_dFactor + 1)
EndFunc   ;==>_DateToDayOfWeek

;===============================================================================
;
; Description:      Add the given days since noon 4713 BC January 1 and return the date.
; Parameter(s):     $iJulianDate    - Julian date number
;                   $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in the parameter vars
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _DayValueToDate($iJulianDate, ByRef $iYear, ByRef $iMonth, ByRef $iDay)
	Local $i_zFactor
	Local $i_wFactor
	Local $i_aFactor
	Local $i_bFactor
	Local $i_xFactor
	Local $i_cFactor
	Local $i_dFactor
	Local $i_eFactor
	Local $i_fFactor
	; check for valid input date
	If $iJulianDate < 0 Or Not IsNumber($iJulianDate) Then
		SetError(1)
		Return 0
	EndIf
	; calculte the date
	$i_zFactor = Int($iJulianDate + 0.5)
	$i_wFactor = Int(($i_zFactor - 1867216.25) / 36524.25)
	$i_xFactor = Int($i_wFactor / 4)
	$i_aFactor = $i_zFactor + 1 + $i_wFactor - $i_xFactor
	$i_bFactor = $i_aFactor + 1524
	$i_cFactor = Int(($i_bFactor - 122.1) / 365.25)
	$i_dFactor = Int(365.25 * $i_cFactor)
	$i_eFactor = Int(($i_bFactor - $i_dFactor) / 30.6001)
	$i_fFactor = Int(30.6001 * $i_eFactor)
	$iDay = $i_bFactor - $i_dFactor - $i_fFactor
	; (must get number less than or equal to 12)
	If $i_eFactor - 1 < 13 Then
		$iMonth = $i_eFactor - 1
	Else
		$iMonth = $i_eFactor - 13
	EndIf
	If $iMonth < 3 Then
		$iYear = $i_cFactor - 4715    ; (if Month is January or February)
	Else
		$iYear = $i_cFactor - 4716    ;(otherwise)
	EndIf
	Return $iYear & "/" & $iMonth & "/" & $iDay
EndFunc   ;==>_DayValueToDate

;===============================================================================
;
; Description:      Returns the date in the PC's regional settings format.
; Parameter(s):     $date - format "YYYY/MM/DD"
;                   $sType - :
;                      0 - Display a date and/or time. If there is a date part, display it as a short date.
;                          If there is a time part, display it as a long time. If present, both parts are displayed.
;                      1 - Display a date using the long date format specified in your computer's regional settings.
;                      2 - Display a date using the short date format specified in your computer's regional settings.
;                      3 - Display a time using the time format specified in your computer's regional settings.
;                      4 - Display a time using the 24-hour format (hh:mm).
; Requirement(s):   None
; Return Value(s):  On Success - Returns date in proper format
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $sDate
;                                               2 - Invalid $sType
; Author(s):        Jos van der Zande <jdeb@autoitscript.com>
; Note(s):          None...
;
;===============================================================================
Func _DateTimeFormat($sDate, $sType)
	Local $asDatePart[4]
	Local $asTimePart[4]
	Local $sReg_DateValue = ""
	Local $sReg_TimeValue = ""
	Local $sTempDate
	Local $sNewTime
	Local $sNewDate
	Local $sAM
	Local $sPM
	Local $iWday
	; Verify If InputDate is valid
	If Not _DateIsValid($sDate) Then
		SetError(1)
		Return ("")
	EndIf
	; input validation
	If $sType < 0 Or $sType > 4 Or Not IsInt($sType) Then
		SetError(2)
		Return ("")
	EndIf
	; split the date and time into arrays
	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	
	If $sType = 0 Then
		$sReg_DateValue = "sShortDate"
		If $asTimePart[0] > 1 Then $sReg_TimeValue = "sTimeFormat"
	EndIf
	
	If $sType = 1 Then $sReg_DateValue = "sLongDate"
	If $sType = 2 Then $sReg_DateValue = "sShortDate"
	If $sType = 3 Then $sReg_TimeValue = "sTimeFormat"
	If $sType = 4 Then $sReg_TimeValue = "sTime"
	$sNewDate = ""
	If $sReg_DateValue <> "" Then
		$sTempDate = RegRead("HKEY_CURRENT_USER\Control Panel\International", $sReg_DateValue)
		$sAM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		$sPM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s2359")
		If $sAM = "" Then $sAM = "AM"
		If $sPM = "" Then $sPM = "PM"
		$iWday = _DateToDayOfWeek($asDatePart[1], $asDatePart[2], $asDatePart[3])
		$asDatePart[3] = StringRight("0" & $asDatePart[3], 2) ; make sure the length is 2
		$asDatePart[2] = StringRight("0" & $asDatePart[2], 2) ; make sure the length is 2
		$sTempDate = StringReplace($sTempDate, "d", "@")
		$sTempDate = StringReplace($sTempDate, "m", "#")
		$sTempDate = StringReplace($sTempDate, "y", "&")
		$sTempDate = StringReplace($sTempDate, "@@@@", _DateDayOfWeek($iWday, 0))
		$sTempDate = StringReplace($sTempDate, "@@@", _DateDayOfWeek($iWday, 1))
		$sTempDate = StringReplace($sTempDate, "@@", $asDatePart[3])
		$sTempDate = StringReplace($sTempDate, "@", StringReplace(StringLeft($asDatePart[3], 1), "0", "") & StringRight($asDatePart[3], 1))
		$sTempDate = StringReplace($sTempDate, "####", _DateMonthOfYear($asDatePart[2], 0))
		$sTempDate = StringReplace($sTempDate, "###", _DateMonthOfYear($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "##", $asDatePart[2])
		$sTempDate = StringReplace($sTempDate, "#", StringReplace(StringLeft($asDatePart[2], 1), "0", "") & StringRight($asDatePart[2], 1))
		$sTempDate = StringReplace($sTempDate, "&&&&", $asDatePart[1])
		$sTempDate = StringReplace($sTempDate, "&&", StringRight($asDatePart[1], 2))
		$sNewDate = $sTempDate
	EndIf
	If $sReg_TimeValue <> "" Then
		$sNewTime = RegRead("HKEY_CURRENT_USER\Control Panel\International", $sReg_TimeValue)
		If $sType = 4 Then
			$sNewTime = $asTimePart[1] & $sNewTime & $asTimePart[2]
		Else
			If $asTimePart[1] < 12 Then
				$sNewTime = StringReplace($sNewTime, "tt", "AM")
				If $asTimePart[1] = 0 Then $asTimePart[1] = 12
			Else
				$sNewTime = StringReplace($sNewTime, "tt", "PM")
				If $asTimePart[1] > 12 Then $asTimePart[1] = $asTimePart[1] - 12
			EndIf
			$asTimePart[1] = StringRight("0" & $asTimePart[1], 2) ; make sure the length is 2
			$asTimePart[2] = StringRight("0" & $asTimePart[2], 2) ; make sure the length is 2
			$asTimePart[3] = StringRight("0" & $asTimePart[3], 2) ; make sure the length is 2
			$sNewTime = StringReplace($sNewTime, "hh", $asTimePart[1])
			$sNewTime = StringReplace($sNewTime, "h", StringReplace(StringLeft($asTimePart[1], 1), "0", "") & StringRight($asTimePart[1], 1))
			$sNewTime = StringReplace($sNewTime, "mm", $asTimePart[2])
			$sNewTime = StringReplace($sNewTime, "ss", $asTimePart[3])
		EndIf
		$sNewDate = StringStripWS($sNewDate & " " & $sNewTime, 3)
	EndIf
	Return ($sNewDate)
EndFunc   ;==>_DateTimeFormat

;===============================================================================
;
; Description:      Returns the the julian date in format YYDDD
; Parameter(s):     $iJulianDate    - Julian date number
;                   $Year  - Year in format YYYY
;                   $Month - Month in format MM
;                   $sDate - Day of the month format DD
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in the parameter vars
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jeremy Landes / Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _DateJulianDayNo($iYear, $iMonth, $iDay)
	Local $sFullDate
	Local $aiDaysInMonth
	Local $iJDay
	Local $iCntr
	; Verify If InputDate is valid
	$sFullDate = StringFormat( "%04d/%02d/%02d", $iYear, $iMonth, $iDay)
	If Not _DateIsValid($sFullDate) Then
		SetError(1)
		Return ""
	EndIf
	; Build JDay value
	$iJDay = 0
	$aiDaysInMonth = __DaysInMonth($iYear)
	For $iCntr = 1 To $iMonth - 1
		$iJDay = $iJDay + $aiDaysInMonth[$iCntr]
	Next
	$iJDay = ($iYear * 1000) + ($iJDay + $iDay)
	Return $iJDay
EndFunc   ;==>_DateJulianDayNo

;===============================================================================
;
; Description:      Returns the date for a julian date in format YYDDD
; Parameter(s):     $iJDate  - Julian date number
; Requirement(s):   None
; Return Value(s):  On Success - Returns the Date in format YYYY/MM/DD
;                   On Failure - 0  and sets @ERROR = 1
; Author(s):        Jeremy Landes / Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _JulianToDate($iJDay)
	Local $aiDaysInMonth
	Local $iYear
	Local $iMonth
	Local $iDay
	Local $iDays
	Local $iMaxDays
	Local $sSep = "/"
	; Verify If InputDate is valid
	$iYear = Int($iJDay / 1000)
	$iDays = Mod($iJDay, 1000)
	$iMaxDays = 365
	If _DateIsLeapYear($iYear) Then $iMaxDays = 366
	If $iDays > $iMaxDays Then
		SetError(1)
		Return ""
	EndIf
	; Convert to regular date
	$aiDaysInMonth = __DaysInMonth($iYear)
	$iMonth = 1
	While $iDays > $aiDaysInMonth[ $iMonth ]
		$iDays = $iDays - $aiDaysInMonth[ $iMonth ]
		$iMonth = $iMonth + 1
	WEnd
	$iDay = $iDays
	Return StringFormat( "%04d%s%02d%s%02d", $iYear, $sSep, $iMonth, $sSep, $iDay)
EndFunc   ;==>_JulianToDate

;===============================================================================
;
; Description:      Returns the current Date and Time in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _Now()
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 0))
EndFunc   ;==>_Now

;===============================================================================
;
; Description:      Returns the current Date and Time in format YYYY/MM/DD HH:MM:SS
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in in format YYYY/MM/DD HH:MM:SS
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowCalc()
	Return (@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC)
EndFunc   ;==>_NowCalc
;===============================================================================
;
; Description:      Returns the current Date in format YYYY/MM/DD
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in in format YYYY/MM/DD
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowCalcDate()
	Return (@YEAR & "/" & @MON & "/" & @MDAY)
EndFunc   ;==>_NowCalcDate

;===============================================================================
;
; Description:      Returns the current Date in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande (Larry's idea)
; Note(s):          None
;
;===============================================================================
Func _NowDate()
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY, 0))
EndFunc   ;==>_NowDate

;===============================================================================
;
; Description:      Returns the current Date and Time in the pc's format
; Parameter(s):     None
; Requirement(s):   None
; Return Value(s):  On Success - Date in pc's format
; Author(s):        Jos van der Zande
; Note(s):          None
;
;===============================================================================
Func _NowTime()
	Return (_DateTimeFormat(@YEAR & "/" & @MON & "/" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC, 3))
EndFunc   ;==>_NowTime

;===============================================================================
;
; Description:      Converts the specified tick amount to hours, minutes, and
;                   seconds.
; Parameter(s):     $iTicks - Tick amount
;                   $iHours - Variable to store the hours (ByRef)
;                   $iMins  - Variable to store the minutes (ByRef)
;                   $iSecs  - Variable to store the seconds (ByRef)
; Requirement(s):   None
; Return Value(s):  On Success - 1
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Marc <mrd@gmx.de>
; Note(s):          None
;
;===============================================================================
Func _TicksToTime($iTicks, ByRef $iHours, ByRef $iMins, ByRef $iSecs)
	If StringIsInt($iTicks) Then
		$iTicks = Round($iTicks / 1000)
		$iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		$iMins = Int($iTicks / 60)
		$iSecs = Round(Mod($iTicks, 60))
		; If $iHours = 0 then $iHours = 24
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_TicksToTime

;===============================================================================
;
; Description:      Converts the specified hours, minutes, and seconds to ticks.
; Parameter(s):     $iHours - Hours
;                   $iMins  - Minutes
;                   $iSecs  - Seconds
; Requirement(s):   None
; Return Value(s):  On Success - Converted tick amount
;                   On Failure - 0 and sets @ERROR = 1
; Author(s):        Marc <mrd@gmx.de>
; Note(s):          None
;
;===============================================================================
Func _TimeToTicks($iHours, $iMins, $iSecs)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $iTicks
	
	If StringIsInt($iHours) And StringIsInt($iMins) And StringIsInt($iSecs) Then
		$iTicks = 1000 * ((3600 * $iHours) + (60 * $iMins) + $iSecs)
		Return $iTicks
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_TimeToTicks

;===============================================================================
;
; Description:      returns an Array that contains the numbers of days per month
;                   te specified year
; Parameter(s):     $iYear
; Requirement(s):   None
; Return Value(s):  On Success - Array that contains the numbers of days per month
;                   On Failure - none
; Author(s):        Jos van der Zande / Jeremy Landes
; Note(s):          None
;
;===============================================================================
Func __DaysInMonth($iYear)
	Local $aiDays
	$aiDays = StringSplit("31,28,31,30,31,30,31,31,30,31,30,31", ",")
	If _DateIsLeapYear($iYear) Then $aiDays[2] = 29
	Return $aiDays
EndFunc   ;==>__DaysInMonth

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\Include\Date.au3>
; ----------------------------------------------------------------------------


Opt("WinWaitDelay", 100)
Opt("WinTitleMatchMode", 3)
Opt("WinDetectHiddenText", 1)
Opt("MouseCoordMode", 0)
AutoItSetOption("WinWaitDelay", 100)
AutoItSetOption("SendKeyDelay", 0)
HotKeySet("{ESC}", "Terminate")


#region --- Code Start ---
;~ Clean out exsisting files in folder

If FileExists('file.ini') Then
	Run('cmd.exe /c del file.ini')
EndIf


#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ verify mvs is open and word are open and will open if not

WinWait("MVS - RUMBA Mainframe Display")
If Not WinActive("MVS - RUMBA Mainframe Display") Then WinActivate("MVS - RUMBA Mainframe Display")
WinWaitActive("MVS - RUMBA Mainframe Display")

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ String strip data from mvs

Sleep(1000)
Send("{CTRLDOWN}a{CTRLUP}")
Sleep(100)
Send("{CTRLDOWN}c{CTRLUP}")
Sleep(1000)

FileWriteLine('file.ini', ClipGet())
Sleep(50)
$line = FileReadLine('file.ini', 4)
$Busn = StringMid($line, 16, 5)

Sleep(50)
$line = FileReadLine('file.ini', 5)
$Acct = StringMid($line, 16, 9)

Sleep(50)
$line = FileReadLine('file.ini', 5)
$Credit = StringMid($line, 75, 12)

Sleep(50)
$line = FileReadLine('file.ini', 6)
$Name = StringMid($line, 16, 35)

Sleep(50)
$line = FileReadLine('file.ini', 7)
$Address = StringMid($line, 17, 35)

Sleep(50)
$line = FileReadLine('file.ini', 10)
$City = StringMid($line, 16, 18)

Sleep(50)
$line = FileReadLine('file.ini', 10)
$State = StringMid($line, 38, 2)

Sleep(50)
$line = FileReadLine('file.ini', 11)
$Zip = StringMid($line, 17, 5)

Sleep(50)
$line = FileReadLine('file.ini', 13)
$Fax = StringMid($line, 16, 15)

Sleep(50)
$line = FileReadLine('file.ini', 17)
$Bill = StringMid($line, 43, 11)

#endregion --- Code End ---
;~ ##############################################################################################################################
#Region --- Code Start ---

Run("C:\Program Files\Microsoft Office\Office10\Winword.exe C:\NSFReturn.doc")

WinWait("NSFReturn.doc - Microsoft Word", "")
If Not WinActive("NSFReturn.doc - Microsoft Word", "") Then WinActivate("NSFReturn.doc - Microsoft Word", "")
WinWaitActive("NSFReturn.doc - Microsoft Word", "")
; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Program Files\AutoIt3\Include\GuiConstants.au3>
; ----------------------------------------------------------------------------


; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Language:       English
; Description:    Constants to be used in GUI applications.
;
; ------------------------------------------------------------------------------


; Events and messages
Global Const $GUI_EVENT_CLOSE = -3
Global Const $GUI_EVENT_MINIMIZE = -4
Global Const $GUI_EVENT_RESTORE = -5
Global Const $GUI_EVENT_MAXIMIZE = -6
Global Const $GUI_EVENT_PRIMARYDOWN = -7
Global Const $GUI_EVENT_PRIMARYUP = -8
Global Const $GUI_EVENT_SECONDARYDOWN = -9
Global Const $GUI_EVENT_SECONDARYUP = -10
Global Const $GUI_EVENT_MOUSEMOVE = -11


; State
Global Const $GUI_AVISTOP = 0
Global Const $GUI_AVISTART = 1
Global Const $GUI_AVICLOSE = 2

Global Const $GUI_CHECKED = 1
Global Const $GUI_INDETERMINATE = 2
Global Const $GUI_UNCHECKED = 4

Global Const $GUI_ACCEPTFILES = 8

Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global Const $GUI_ENABLE = 64
Global Const $GUI_DISABLE = 128

Global Const $GUI_FOCUS = 256
Global Const $GUI_DEFBUTTON = 512

Global Const $GUI_EXPAND = 1024


; Font
Global Const $GUI_FONTITALIC = 2
Global Const $GUI_FONTUNDER = 4
Global Const $GUI_FONTSTRIKE = 8


; Resizing
Global Const $GUI_DOCKAUTO = 0x0001
Global Const $GUI_DOCKLEFT = 0x0002
Global Const $GUI_DOCKRIGHT = 0x0004
Global Const $GUI_DOCKHCENTER = 0x0008
Global Const $GUI_DOCKTOP = 0x0020
Global Const $GUI_DOCKBOTTOM = 0x0040
Global Const $GUI_DOCKVCENTER = 0x0080
Global Const $GUI_DOCKWIDTH = 0x0100
Global Const $GUI_DOCKHEIGHT = 0x0200

Global Const $GUI_DOCKSIZE = 0x0300; width+height
Global Const $GUI_DOCKMENUBAR = 0x0220; top+height
Global Const $GUI_DOCKSTATEBAR = 0x0240; bottom+height
Global Const $GUI_DOCKALL = 0x0322; left+top+width+height

; Window Styles
Global Const $WS_TILED = 0
Global Const $WS_OVERLAPPED = 0
Global Const $WS_MAXIMIZEBOX = 0x00010000
Global Const $WS_MINIMIZEBOX = 0x00020000
Global Const $WS_TABSTOP = 0x00010000
Global Const $WS_GROUP = 0x00020000
Global Const $WS_SIZEBOX = 0x00040000
Global Const $WS_THICKFRAME = 0x00040000
Global Const $WS_SYSMENU = 0x00080000
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
Global Const $WS_DLGFRAME = 0x00400000
Global Const $WS_BORDER = 0x00800000
Global Const $WS_CAPTION = 0x00C00000
Global Const $WS_OVERLAPPEDWINDOW = 0x00CF0000
Global Const $WS_TILEDWINDOW = 0x00CF0000
Global Const $WS_MAXIMIZE = 0x01000000
Global Const $WS_CLIPCHILDREN = 0x02000000
Global Const $WS_CLIPSIBLINGS = 0x04000000
Global Const $WS_DISABLED = 0x08000000
Global Const $WS_VISIBLE = 0x10000000
Global Const $WS_MINIMIZE = 0x20000000
Global Const $WS_CHILD = 0x40000000
Global Const $WS_POPUP = 0x80000000
Global Const $WS_POPUPWINDOW = 0x80880000

Global Const $DS_MODALFRAME = 0x80
Global Const $DS_SETFOREGROUND = 0x00000200
Global Const $DS_CONTEXTHELP = 0x00002000

; Window Extended Styles
Global Const $WS_EX_ACCEPTFILES = 0x00000010
Global Const $WS_EX_APPWINDOW = 0x00040000
Global Const $WS_EX_CLIENTEDGE = 0x00000200
Global Const $WS_EX_CONTEXTHELP = 0x00000400
Global Const $WS_EX_DLGMODALFRAME = 0x00000001
Global Const $WS_EX_LEFTSCROLLBAR = 0x00004000
Global Const $WS_EX_OVERLAPPEDWINDOW = 0x00000300
Global Const $WS_EX_RIGHT = 0x00001000
Global Const $WS_EX_STATICEDGE = 0x00020000
Global Const $WS_EX_TOOLWINDOW = 0x00000080
Global Const $WS_EX_TOPMOST = 0x00000008
Global Const $WS_EX_TRANSPARENT = 0x00000020
Global Const $WS_EX_WINDOWEDGE = 0x00000100
Global Const $WS_EX_LAYERED = 0x00080000
Global Const $LVS_EX_FULLROWSELECT = 0x00000020


; Label/Pic/Icon
Global Const $SS_CENTER = 1
Global Const $SS_RIGHT = 2
Global Const $SS_ICON = 3
Global Const $SS_BLACKRECT = 4
Global Const $SS_GRAYRECT = 5
Global Const $SS_WHITERECT = 6
Global Const $SS_BLACKFRAME = 7
Global Const $SS_GRAYFRAME = 8
Global Const $SS_WHITEFRAME = 9
Global Const $SS_SIMPLE = 11
Global Const $SS_LEFTNOWORDWRAP = 12
Global Const $SS_BITMAP = 15
Global Const $SS_ETCHEDHORZ = 16
Global Const $SS_ETCHEDVERT = 17
Global Const $SS_ETCHEDFRAME = 18
Global Const $SS_NOPREFIX = 0x0080
Global Const $SS_NOTIFY = 0x0100
Global Const $SS_CENTERIMAGE = 0x0200
Global Const $SS_RIGHTJUST = 0x0400
Global Const $SS_SUNKEN = 0x1000


; Button
Global Const $BS_BOTTOM = 0x0800
Global Const $BS_CENTER = 0x0300
Global Const $BS_DEFPUSHBUTTON = 0x0001
Global Const $BS_LEFT = 0x0100
Global Const $BS_MULTILINE = 0x2000
Global Const $BS_PUSHBOX = 0x000A
Global Const $BS_PUSHLIKE = 0x1000
Global Const $BS_RIGHT = 0x0200
Global Const $BS_RIGHTBUTTON = 0x0020
Global Const $BS_TOP = 0x0400
Global Const $BS_VCENTER = 0x0C00
Global Const $BS_FLAT = 0x8000
Global Const $BS_ICON = 0x0040
Global Const $BS_BITMAP = 0x0080

; Checkbox
Global Const $BS_3STATE = 0x0005
Global Const $BS_AUTO3STATE = 0x0006
Global Const $BS_AUTOCHECKBOX = 0x0003
Global Const $BS_CHECKBOX = 0x0002

; Combo
Global Const $CBS_SIMPLE = 0x0001
Global Const $CBS_DROPDOWN = 0x0002
Global Const $CBS_DROPDOWNLIST = 0x0003
Global Const $CBS_AUTOHSCROLL = 0x0040
Global Const $CBS_OEMCONVERT = 0x0080
Global Const $CBS_SORT = 0x0100
Global Const $CBS_NOINTEGRALHEIGHT = 0x0400
Global Const $CBS_DISABLENOSCROLL = 0x0800
Global Const $CBS_UPPERCASE = 0x2000
Global Const $CBS_LOWERCASE = 0x4000


; Listbox
Global Const $LBS_NOTIFY = 0x0001
Global Const $LBS_SORT = 0x0002
Global Const $LBS_USETABSTOPS = 0x0080
Global Const $LBS_NOINTEGRALHEIGHT = 0x0100
Global Const $LBS_DISABLENOSCROLL = 0x1000
Global Const $LBS_NOSEL = 0x4000
Global Const $LBS_STANDARD = 0xA00003


; Edit/Input
Global Const $ES_LEFT = 0
Global Const $ES_CENTER = 1
Global Const $ES_RIGHT = 2
Global Const $ES_MULTILINE = 4
Global Const $ES_UPPERCASE = 8
Global Const $ES_LOWERCASE = 16
Global Const $ES_PASSWORD = 32
Global Const $ES_AUTOVSCROLL = 64
Global Const $ES_AUTOHSCROLL = 128
Global Const $ES_NOHIDESEL = 256
Global Const $ES_OEMCONVERT = 1024
Global Const $ES_READONLY = 2048
Global Const $ES_WANTRETURN = 4096
Global Const $ES_NUMBER = 8192
;Global Const $ES_DISABLENOSCROLL = 8192
;Global Const $ES_SUNKEN = 16384
;Global Const $ES_VERTICAL = 4194304
;Global Const $ES_SELECTIONBAR = 16777216


; Date
Global Const $DTS_SHORTDATEFORMAT = 0
Global Const $DTS_UPDOWN = 1
Global Const $DTS_SHOWNONE = 2
Global Const $DTS_LONGDATEFORMAT = 4
Global Const $DTS_TIMEFORMAT = 9
Global Const $DTS_RIGHTALIGN = 32

; Progress bar
Global Const $PBS_SMOOTH = 1
Global Const $PBS_VERTICAL = 4


; AVI clip
Global Const $ACS_CENTER = 1
Global Const $ACS_TRANSPARENT = 2
Global Const $ACS_AUTOPLAY = 4
Global Const $ACS_TIMER = 8
Global Const $ACS_NONTRANSPARENT = 16


; Tab
Global Const $TCS_SCROLLOPPOSITE = 0x0001
Global Const $TCS_BOTTOM = 0x0002
Global Const $TCS_RIGHT = 0x0002
Global Const $TCS_MULTISELECT = 0x0004
Global Const $TCS_FLATBUTTONS = 0x0008
Global Const $TCS_FORCEICONLEFT = 0x0010
Global Const $TCS_FORCELABELLEFT = 0x0020
Global Const $TCS_HOTTRACK = 0x0040
Global Const $TCS_VERTICAL = 0x0080
Global Const $TCS_TABS = 0x0000
Global Const $TCS_BUTTONS = 0x0100
Global Const $TCS_SINGLELINE = 0x0000
Global Const $TCS_MULTILINE = 0x0200
Global Const $TCS_RIGHTJUSTIFY = 0x0000
Global Const $TCS_FIXEDWIDTH = 0x0400
Global Const $TCS_RAGGEDRIGHT = 0x0800
Global Const $TCS_FOCUSONBUTTONDOWN = 0x1000
Global Const $TCS_OWNERDRAWFIXED = 0x2000
Global Const $TCS_TOOLTIPS = 0x4000
Global Const $TCS_FOCUSNEVER = 0x8000


; TreeView
Global Const $TVS_HASBUTTONS = 0x0001
Global Const $TVS_HASLINES = 0x0002
Global Const $TVS_LINESATROOT = 0x0004
;Global Const $TVS_EDITLABELS      = 0x0008
Global Const $TVS_DISABLEDRAGDROP = 0x0010
Global Const $TVS_SHOWSELALWAYS = 0x0020
;Global Const $TVS_RTLREADING     = 0x0040
Global Const $TVS_NOTOOLTIPS = 0x0080
Global Const $TVS_CHECKBOXES = 0x0100
Global Const $TVS_TRACKSELECT = 0x0200
Global Const $TVS_SINGLEEXPAND = 0x0400
;Global Const $TVS_INFOTIP        = 0x0800
Global Const $TVS_FULLROWSELECT = 0x1000
Global Const $TVS_NOSCROLL = 0x2000
Global Const $TVS_NONEVENHEIGHT = 0x4000

; Slider
Global Const $TBS_AUTOTICKS = 0x0001
Global Const $TBS_VERT = 0x0002
Global Const $TBS_HORZ = 0x0000
Global Const $TBS_TOP = 0x0004
Global Const $TBS_BOTTOM = 0x0000
Global Const $TBS_LEFT = 0x0004
Global Const $TBS_RIGHT = 0x0000
Global Const $TBS_BOTH = 0x0008
Global Const $TBS_NOTICKS = 0x0010
Global Const $TBS_NOTHUMB = 0x0080

; ListView
Global Const $LVS_REPORT = 0x0001
Global Const $LVS_EDITLABELS = 0x0200
Global Const $LVS_NOCOLUMNHEADER = 0x4000
Global Const $LVS_NOSORTHEADER = 0x8000
Global Const $LVS_SINGLESEL = 0x0004
Global Const $LVS_SHOWSELALWAYS = 0x0008

;Updown
Global Const $UDS_WRAP = 0x0001
Global Const $UDS_ALIGNRIGHT = 0x0004
Global Const $UDS_ALIGNLEFT = 0x0008
Global Const $UDS_ARROWKEYS = 0x0020
Global Const $UDS_HORZ = 0x0040
Global Const $UDS_NOTHOUSANDS = 0x0080

; Control default styles
Global Const $GUI_SS_DEFAULT_AVI = $ACS_TRANSPARENT
Global Const $GUI_SS_DEFAULT_BUTTON = 0
Global Const $GUI_SS_DEFAULT_CHECKBOX = 0
Global Const $GUI_SS_DEFAULT_COMBO = $CBS_DROPDOWN + $CBS_AUTOHSCROLL + $WS_VSCROLL
Global Const $GUI_SS_DEFAULT_DATE = $DTS_LONGDATEFORMAT
Global Const $GUI_SS_DEFAULT_EDIT = $ES_WANTRETURN + $WS_VSCROLL + $WS_HSCROLL + $ES_AUTOVSCROLL + $ES_AUTOHSCROLL
Global Const $GUI_SS_DEFAULT_GROUP = 0
Global Const $GUI_SS_DEFAULT_ICON = $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_INPUT = $ES_LEFT + $ES_AUTOHSCROLL
Global Const $GUI_SS_DEFAULT_LABEL = 0
Global Const $GUI_SS_DEFAULT_LIST = $LBS_SORT + $WS_BORDER + $WS_VSCROLL + $LBS_NOTIFY
Global Const $GUI_SS_DEFAULT_LISTVIEW = $LVS_SHOWSELALWAYS + $LVS_SINGLESEL
Global Const $GUI_SS_DEFAULT_PIC = $SS_NOTIFY
Global Const $GUI_SS_DEFAULT_PROGRESS = 0
Global Const $GUI_SS_DEFAULT_RADIO = 0
Global Const $GUI_SS_DEFAULT_SLIDER = $TBS_AUTOTICKS
Global Const $GUI_SS_DEFAULT_TAB = 0
Global Const $GUI_SS_DEFAULT_TREEVIEW = $TVS_HASBUTTONS + $TVS_HASLINES + $TVS_LINESATROOT + $TVS_DISABLEDRAGDROP + $TVS_SHOWSELALWAYS
Global Const $GUI_SS_DEFAULT_UPDOWN = $UDS_ALIGNRIGHT
Global Const $GUI_SS_DEFAULT_GUI = $WS_MINIMIZEBOX + $WS_CAPTION + $WS_POPUP + $WS_SYSMENU


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Program Files\AutoIt3\Include\GuiConstants.au3>
; ----------------------------------------------------------------------------



GUICreate("Nsf Report", 572, 612, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

WinWait("Nsf Report", "")
If Not WinActive("Nsf Report", "") Then WinActivate("Nsf Report", "")
WinWaitActive("Nsf Report", "")

$Group_1 = GUICtrlCreateGroup("Select the Payment Type", 10, 10, 290, 210)
$Read_1 = GUICtrlCreateList("phone check authorized electronic funds transfer", 30, 40, 250, 162)
GUICtrlSetData(-1, "auto scheduled electronic funds transfer|manual scheduled electronic funds transfer|e-manager sheduled electronic funds transfer|fax check authorized electronic funds transfer|mailed paper check payment", "auto scheduled electronic funds transfer") ; add other item snd set a new default

$Group_3 = GUICtrlCreateGroup("Select the Type of Return", 320, 10, 240, 210)
$Read_2 = GUICtrlCreateList("non sufficient funds", 340, 40, 200, 162)
GUICtrlSetData(-1, "stop payment|closed account|unable to locate|frozen account|uncollected funds", "closed account") ; add other item snd set a new default

$Group_25 = GUICtrlCreateGroup("Return Letter Information", 20, 230, 530, 330)
$Label_5 = GUICtrlCreateLabel("Number of Returns", 130, 250, 120, 20)
$Read_3 = GUICtrlCreateInput("", 320, 250, 160, 20)

$Label_7 = GUICtrlCreateLabel("Return Amount", 130, 280, 120, 20)
$Read_4 = GUICtrlCreateInput("", 320, 280, 160, 20)

$Label_9 = GUICtrlCreateLabel("Customer Contact Person", 130, 310, 130, 20)
$Read_5 = GUICtrlCreateInput("", 320, 310, 160, 20)

$Label_11 = GUICtrlCreateLabel("Select Payment Post Date", 130, 340, 130, 20)
$Read_6 = GUICtrlCreateDate("PostDate", 320, 340, 160, 20, 12)

$Label_13 = GUICtrlCreateLabel("Select the Date of Return", 130, 370, 130, 20)
$Read_7 = GUICtrlCreateDate("ReturnDate", 320, 370, 160, 20, 12)

$Label_15 = GUICtrlCreateLabel("Select Payee Name", 130, 400, 130, 20)
$Read_8 = GUICtrlCreateCombo("TCH LLC", 320, 400, 160, 21)
GUICtrlSetData(-1, "Flying J Inc.|CFJ Properties", "TCH LLC")

$Label_17 = GUICtrlCreateLabel("Select Account Number", 130, 430, 140, 20)
$Read_9 = GUICtrlCreateCombo("300000155", 320, 430, 160, 21)
GUICtrlSetData(-1, "300000171|870306993", "300000155")

$Label_19 = GUICtrlCreateLabel("Enter Your Name", 130, 460, 120, 20)
$Read_10 = GUICtrlCreateInput("", 320, 460, 160, 20)

$Label_21 = GUICtrlCreateLabel("Enter Your Phone Number", 130, 490, 130, 20)
$Read_11 = GUICtrlCreateInput("", 320, 490, 160, 20)

$Label_23 = GUICtrlCreateLabel("Enter Your Email Address", 130, 520, 130, 20)
$Read_12 = GUICtrlCreateInput("", 320, 520, 160, 20)

$Button_1 = GUICtrlCreateButton("Finished", 460, 570, 100, 30)
GUICtrlSetState($Button_1, $GUI_DEFBUTTON)

GUISetState()
$msg = 0
While $msg <> $GUI_EVENT_CLOSE
	$msg = GUIGetMsg()
	Select
		Case $msg = $Button_1
			
			ExitLoop
	EndSelect
WEnd


ClipPut(GUICtrlRead($Read_1))
$Read_1 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_2))
$Read_2 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_3))
$Read_3 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_4))
$Read_4 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_5))
$Read_5 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_6))
$Read_6 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_7))
$Read_7 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_8))
$Read_8 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_9))
$Read_9 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_10))
$Read_10 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_11))
$Read_11 = ClipGet()
Sleep(50)
ClipPut(GUICtrlRead($Read_12))
$Read_12 = ClipGet()
Sleep(50)

If FileExists('file3.ini') Then
	
	FileRecycle('c:\file3.ini')
	
EndIf
Sleep(500)
FileWriteLine('file3.ini', ($Read_1))
Sleep(25)
FileWriteLine('file3.ini', ($Read_2))
Sleep(25)
FileWriteLine('file3.ini', ($Read_3))
Sleep(25)
FileWriteLine('file3.ini', ($Read_4))
Sleep(25)
FileWriteLine('file3.ini', ($Read_5))
Sleep(25)
FileWriteLine('file3.ini', ($Read_6))
Sleep(25)
FileWriteLine('file3.ini', ($Read_7))
Sleep(25)
FileWriteLine('file3.ini', ($Read_8))
Sleep(25)
FileWriteLine('file3.ini', ($Read_9))
Sleep(25)
FileWriteLine('file3.ini', ($Read_10))
Sleep(25)
FileWriteLine('file3.ini', ($Read_11))
Sleep(25)
FileWriteLine('file3.ini', ($Read_12))
Sleep(25)
GUIDelete()
$List_2 = FileReadLine('file3.ini', 1)
Sleep(25)
$List_4 = FileReadLine('file3.ini', 2)
Sleep(25)
$Nsf = FileReadLine('file3.ini', 3)
Sleep(25)
$Dollar = FileReadLine('file3.ini', 4)
Sleep(25)
$Customer = FileReadLine('file3.ini', 5)
Sleep(25)
$PostDate = FileReadLine('file3.ini', 6)
Sleep(25)
$ReturnDate = FileReadLine('file3.ini', 7)
Sleep(25)
$Payee = FileReadLine('file3.ini', 8)
Sleep(25)
$Bank = FileReadLine('file3.ini', 9)
Sleep(25)
$Manager = FileReadLine('file3.ini', 10)
Sleep(25)
$Phone = FileReadLine('file3.ini', 11)
Sleep(25)
$Email = FileReadLine('file3.ini', 12)
Sleep(25)
$balance = Number($Dollar + 20.00)
$FormattedTotal = StringFormat("%.2f", $balance)
GUISetState()
;~ MsgBox(4096, "drag drop file", ($Customer))
#EndRegion --- Code End ---
;~ ##############################################################################################################################
#Region --- Code Start ---
;SplashText features: Title=Yes, Text=Yes, Width=400, Height=200, Always On Top, Center justified text, Fontname=Verdana, Font size=14, Font weight=400

SplashTextOn("Document Build", "Please wait for a moment while your document is being constructed based on your selections.", "400", "200", "-1", "-1", 0, "Verdana", "14", "400")

#EndRegion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Clean Document

WinWait("NSFReturn.doc - Microsoft Word", "")
If Not WinActive("NSFReturn.doc - Microsoft Word", "") Then WinActivate("NSFReturn.doc - Microsoft Word", "")
WinWaitActive("NSFReturn.doc - Microsoft Word", "")
Sleep(2000)

Send("{CTRLDOWN}a{CTRLUP}{DEL}")
Sleep(1000)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Macro Test

SplashOff()
WinWait("NSFReturn.doc - Microsoft Word", "")
If Not WinActive("NSFReturn.doc - Microsoft Word", "") Then WinActivate("NSFReturn.doc - Microsoft Word", "")
WinWaitActive("NSFReturn.doc - Microsoft Word", "")
Sleep(50)
Send("{ALTDOWN}{F8}{ALTUP}")
Sleep(50)
WinWait("Macros", "")
If Not WinActive("Macros", "") Then WinActivate("Macros", "")
WinWaitActive("Macros", "")
Sleep(50)
Send("Macro4")
Sleep(50)
Send("{ALTDOWN}r{ALTUP}")
Sleep(1000)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Send the date
Sleep(50)
Send(_DateTimeFormat( _NowCalc(), 2))
Sleep(50)
Send("{ENTER 3}")
Sleep(50)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Send the name, address, City, State and Zip from carms to word

WinWait("NSFReturn.doc - Microsoft Word", "")
If Not WinActive("NSFReturn.doc - Microsoft Word", "") Then WinActivate("NSFReturn.doc - Microsoft Word", "")
WinWaitActive("NSFReturn.doc - Microsoft Word", "")

Sleep(50)
Send( StringStripWS($Name, 4))
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send( StringStripWS($Address, 4))
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send( StringStripWS($City, 4))
Sleep(50)
Send( StringStripWS($State, 4))
Sleep(50)
Send("{SPACE}")
Sleep(50)
Send( StringStripWS($Zip, 4))
Sleep(50)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Fill the letter

Sleep(50)
Send("{ENTER 3}ATTN: ")
Sleep(50)
Send($Customer)
Sleep(50)
Send("{ENTER}FAX: ")
Sleep(50)
Send( StringStripWS($Fax, 2))
Sleep(50)
Send("{ENTER 2}")
Sleep(50)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Fill the Letter
Sleep(50)
Send("RE:  Today your ")
Sleep(50)
Send($List_2)
Sleep(50)
Send("{SPACE}processed ")
Sleep(50)
Send($PostDate)
Sleep(50)
Send(" was returned as{SPACE}")
Sleep(50)
Send($List_4)
Sleep(50)
Send(".{SPACE}Notice was received on ")
Sleep(50)
Send($ReturnDate)
Sleep(50)
Send(" in the amount of $")
Sleep(50)
Send($Dollar)
Sleep(50)
Send("{SPACE}on your fuel account ")
Sleep(50)
Send( StringStripWS($Busn & $Acct, 8))
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("Please{SPACE}")
Sleep(50)
Send("{CTRLDOWN}b{CTRLUP}")
Send("WIRE TRANSFER TODAY  $")
Sleep(50)
Send($FormattedTotal)
Sleep(50)
Send("{CTRLDOWN}b{CTRLUP}")
Send("{SPACE}which includes the return and a $20.00 process fee.  Please ensure that ")
Sleep(50)
Send($Payee)
Sleep(50)
Send(" receives the replacement wire transfer today so that the fuel service on your account may be reinstated.{ENTER 2}")
Sleep(50)
Send("Listed below are the wire transfer instructions for your wire replacement.  Please send the wire transfer as follows.{ENTER 2}")
Sleep(50)
Send("{TAB}Payee:{TAB}{TAB}{TAB}")
Sleep(50)
Send($Payee)
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send("{TAB}Payee Account #:{TAB}")
Sleep(50)
Send($Bank)
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send("{TAB}Bank Name:{TAB 2}Transportation Alliance Bank{ENTER}")
Sleep(50)
Send("{TAB}{TAB}{TAB}{TAB}4185 Harrison Blvd. Ste 200{ENTER}")
Sleep(50)
Send("{TAB}{TAB}{TAB}{TAB}Ogden Utah  84403{ENTER}")
Sleep(50)
Send("{TAB}Bank Routing#:{TAB}{TAB}124384657{ENTER}")
Sleep(50)
Send("{TAB}Reference:{TAB}{TAB}Your Company Name and Account Number{ENTER 2}")
Sleep(50)
Send("In addition, your account may remain suspended until the{SPACE}")
Sleep(50)
Send($List_4)
Sleep(50)
Send("{Space} return is cleared up.{ENTER 2}")
Sleep(50)
Send("Any future return items may require a security deposit in the amount of the desired credit line upon a credit line review by the Corporate Credit Manager{ENTER 2}")
Sleep(50)
Send("Thank you for your assistance in this matter.{ENTER 2}Sincerely,{ENTER 2}TCH/Flying J Inc. Credit Department")
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send($Manager)
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send($Phone)
Sleep(50)
Send("{ENTER}")
Sleep(50)
Send($Email)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)

#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---
;~ Set for second page
Sleep(50)
Send("{TAB 5}RETURN SUMMARY SHEET{ENTER 2}")
Sleep(50)
Send(_DateTimeFormat( _NowCalc(), 2))
Sleep(50)
Send("{TAB 9}NSF REF:___________ ")
Sleep(50)
Send("{ENTER 3}Customer Name:{TAB}")
Sleep(50)
Send($Name)
Sleep(50)
Send("{ENTER}Account Number:{TAB}")
Sleep(50)
Send( StringStripWS($Busn & $Acct, 8))
Sleep(50)
Send("{ENTER}Credit Line:{TAB 2}")
Sleep(50)
Send( StringStripWS($Credit, 8))
Sleep(50)
Send("{ENTER}Billing Type:{TAB}")
Sleep(50)
Send($Bill)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Date of EFT/DEP:{TAB}")
Sleep(50)
Send($PostDate)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Date of Return:{TAB 2}")
Sleep(50)
Send($ReturnDate)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Amount of Return:{TAB}")
Sleep(50)
Send($Dollar)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Reason for Return:{TAB}")
Sleep(50)
Send($List_4)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Number of Returns:{TAB}")
Sleep(50)
Send($Nsf)
Sleep(50)
Send("{ENTER 2}")
Sleep(50)
Send("{TAB}Date Return Paid:{TAB 2}____________________{ENTER 2}")
Sleep(50)
Send("{TAB}Date of A/R Post Match:{TAB}____________________{ENTER 2}")
Sleep(50)
Send("Credit Mgr Recommend:{TAB 2}______ Convert to Draw Down.{ENTER}{TAB 5}______ Convert to Wire Transfer Method of Payment.{ENTER}{TAB 5}______ Convert to Fully Secured Account.{ENTER}{TAB 5}______ Close the Account.{ENTER}{TAB 5}______ Re-Activate the Account/No Credit Changes.{ENTER}{TAB 5}______ Re-Activate the Account W/Credit Changes.{ENTER}{TAB 5}______ Other.{Enter 2}")
Sleep(50)
Send("Credit MGR Comment:{TAB}_________________________________________________________________{ENTER 2}{TAB 3}_________________________________________________________________{ENTER 2}")
Sleep(50)
Send("TCH Credit MGR{ENTER}Recommendation:{TAB}_________________________________________________________________{ENTER 2}{TAB 3}_________________________________________________________________{ENTER 2}")
Sleep(50)
Send("TCH CR MGR Appr:{TAB}__________________________________{TAB}Date:__________________")
Sleep(50)
;~ WinSetOnTop("NSFReturn.doc - Microsoft Word", "", 0)
;~ WinSetOnTop("MVS - RUMBA Mainframe Display", "", 0)
Sleep(50)
#endregion --- Code End ---
;~ ##############################################################################################################################
#region --- Code Start ---

#region --- Code Start ---
;~ Macro Test

#Region --- CodeWizard generated code Start ---
;SpashText features: Title=Yes, Text=Yes, Width=400, Height=150, Center justified text, Fontname=Verdana, Font size=14, Font weight=400
#Region --- CodeWizard generated code Start ---
;SpashText features: Title=Yes, Text=Yes, Width=400, Height=150, Always On Top, Center justified text, Fontname=Verdana, Font size=14, Font weight=400
SplashTextOn("Printer", "Your NSF Report document has been sent to the HP 4300 Printer", "400", "150", "-1", "-1", 0, "Verdana", "14", "400")
Sleep(2000)
SplashOff()
#EndRegion --- CodeWizard generated code End ---


#EndRegion --- CodeWizard generated code End ---
WinWait("NSFReturn.doc - Microsoft Word", "")
If Not WinActive("NSFReturn.doc - Microsoft Word", "") Then WinActivate("NSFReturn.doc - Microsoft Word", "")
WinWaitActive("NSFReturn.doc - Microsoft Word", "")
Sleep(50)
Send("{ALTDOWN}{F8}{ALTUP}")
Sleep(50)
WinWait("Macros", "")
If Not WinActive("Macros", "") Then WinActivate("Macros", "")
WinWaitActive("Macros", "")
Sleep(50)
Send("Macro2")
Sleep(50)
Send("{ALTDOWN}r{ALTUP}")
Sleep(1000)
#endregion --- Code End ---

Func Terminate()
	Exit 0
EndFunc   ;==>Terminate

Exit

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: F:\Source Code\NSF.au3>
; ----------------------------------------------------------------------------

