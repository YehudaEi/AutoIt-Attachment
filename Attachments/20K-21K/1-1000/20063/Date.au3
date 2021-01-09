
;==============================================================
;Function Name:		Date($Format, [$Timestamp=0])
;Description:		Parses your format and returns a date
;Parameters:		$Format		- A string you want formatted
;					$Timestamp	- A value from _NowCalc ()
;					Example: 2008/05/05 09:53:53
;Return Values:		Returns a formatted string
;Reference:			This is a replica of PHP date (); function
;					Use http://ca3.php.net/date for formatted
;==============================================================
Func Date($Format, $Timestamp=0)
	If $Timestamp = 0 Then $Timestamp = _NowCalc ()
	Local $iSplit = StringSplit($Timestamp, "/ :")
	_ArrayAdd($iSplit, _DateToDayOfWeek($iSplit[1], $iSplit[2], $iSplit[3]))
	_ArrayAdd($iSplit, _DateToDayOfWeekISO($iSplit[1], $iSplit[2], $iSplit[3]))
	
	Local $sSplit = StringSplit($Format, "")
	Local $sRet
	For $n = 1 To $sSplit[0] Step 1
		Switch Asc($sSplit[$n])
			Case 100;[d] - Day of month with leading zero's
				$sRet &= $iSplit[3]
			Case 106;[j] - Day of month without leading zero's
				Local $iTemp = $iSplit[3]
				If StringLeft($iTemp, 1) = "0" Then $iTemp = StringTrimLeft($iTemp, 1)
				$sRet &= $iTemp
			Case 68;[D} - Weekday, three letters
				$sRet &= _DateDayOfWeek($iSplit[7], 1)
			Case 108;[l] - Full weekday (Saturday)
				$sRet &= _DateDayOfWeek($iSplit[7], 0)
			Case 78;[N] - The ISO Standard Weekday(1-7)
				$sRet &= $iSplit[7]
			Case 83;[S] - The suffix for the numbers (st, nd, rd, th)
				Switch $iSplit[3]
					Case "01"
						$sRet &= "st"
					Case "02"
						$sRet &= "nd"
					Case "03"
						$sRet &= "rd"
					Case Else
						$sRet &= "th"
				EndSwitch
			Case 119;[w] - The weekday (0-6)
				$sRet &= $iSplit[8]
			Case 122;[z] - The year day (0 - 365)
				$sRet &= _DateGetDaysInYear($Timestamp)
			Case 87; [W] -  Numeric representation of the day of the week
				$sRet &= _WeekNumberISO($iSplit[1], $iSplit[2], $iSplit[3])
			Case 70; [F] - The month in full form (January - December)
				$sRet &= _DateToMonth($iSplit[2])
			Case 109; [m] - Numeric representation of a month, with leading zeros
				$sRet &= $iSplit[2]
			Case 77; [M] - THe month is short form
				$sRet &= _DateToMonth($iSplit[2], 1)
			Case 110; [n] - The month value without leading zeros
				Local $iTemp = $iSplit[2]
				If StringLeft($iTemp, 1) = "0" Then $iTemp = StringTrimLeft($iTemp, 1)
				$sRet &= $iTemp
			Case 116; [t] - Number of days in a month
				$sRet &= _DateDaysInMonth($iSplit[1], $iSplit[2])
			Case 76; [L] - Leap year
				$sRet &= _DateIsLeapYear($iSplit[1])
			Case 111; [o] - The Year Number
				$sRet &= $iSplit[1]
			Case 89; [Y] - The year Number
				$sRet &= $iSplit[1]
			Case 116; [t] - The last 2 digit year
				$sRet &= StringRight($iSplit[1], 2)
			Case 97; [a] - Lowercase am pm
				If $iSplit[4] > 12 Then
					$sRet &= "pm"
				Else
					$sRet &= "am"
				EndIf
			Case 65; [A] - Uppercase AM PM
				If $iSplit[4] > 12 Then
					$sRet &= "PM"
				Else
					$sRet &= "AM"
				EndIf
			Case 103; [g] - 12-hour format of an hour without leading zeros
				Local $iTemp = $iSplit[4]
				If $iTemp > 12 Then $iTemp -= 12
				If StringLeft($iTemp, 1) = "0" Then $iTemp = StringTrimLeft($iTemp, 1)
				$sRet &= $iTemp
			Case 71; [G] - 24-hour format of an hour without leading zeros
				Local $iTemp = $iSplit[4]
				If StringLeft($iTemp, 1) = "0" Then $iTemp = StringTrimLeft($iTemp, 1)
				$sRet &= $iTemp
			Case 104; [h] - 12-hour format of an hour with leading zeros
				Local $iTemp = $iSplit[4]
				If $iTemp > 12 Then $iTemp -= 12
				$sRet &= $iTemp
			Case 72; [H] - 24-hour format of an hour with leading zeros
				$sRet &= $iSplit[4]
			Case 105; [i] - Minutes
				$sRet &= $iSplit[5]
			Case 115; [s] - Seconds
				$sRet &= $iSplit[6]
			Case 92; [\] - Escape next character
				$n += 1
				$sRet &= $sSplit[$n]
			Case Else
				$sRet &= $sSplit[$n]
		EndSwitch
	Next
	Return $sRet
EndFunc

Func _DateGetDaysInYear($sDate)
	Local $iSplit = StringSplit($sDate, "/ :")
	Local $iYears = 0
	For $n = 1 To $iSplit[2] - 1 Step 1
		$iYears += _DateDaysInMonth($iSplit[1], $n)
	Next
	$iYears += $iSplit[3]
	Return $iYears
EndFunc