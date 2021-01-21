;===============================================================================
;
; Description:      Returns the Date [and time] in format YYYY/MM/DD [HH:MM:SS],
;					give the date / time in the system or specified format.
; Parameter(s):     $sSysDateTime	- Input date [and time]
;					$dFormat		- Format of input date (optional)
;					$tFormat		- Format of input time (optional)
; Requirement(s):   None
; Return Value(s):  On Success		- Date in in format YYYY/MM/DD [HH:MM:SS]
;					On Error		- @ERROR	- 1 (input date badly formatted)
;									- @ERROR	- 2 (input time badly formatted)
; Author(s):        Sean Hart <autoit@hartmail.ca>
; Note(s):          Date format can be provided without any separators only in
;					the format YYYYMMDD.
;					If system format is used it is current user format, NOT
;					default user format (which may be different).
;					2 digit years converted: 	81 - 99 -> 1981-1999
;												00 - 80 -> 2000-2080
;
;===============================================================================
Func _DateCalc($sSysDateTime, $dFormat = "", $tFormat = "")
	Local $sDay
	Local $sMonth
	Local $sYear
	Local $sHour
	Local $sMin
	Local $sSec
	Local $dFormat
	Local $dSep
	Local $tFormat
	Local $tSep
	Local $am
	Local $pm
	Local $split1[9]
	Local $split2[9]
	Local $sSysDate
	Local $sSysTime
	Local $isAM
	Local $isPM
	Local $sTestDate

	; Read default system time formats and separators from registry unless provided
	if $dFormat = "" then
		$dFormat = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$dSep = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "sDate")
	else
		; Extract separator from date format by finding first non recognised character
		for $x = 1 to StringLen ($dFormat)
			if (not (StringMid ($dFormat, $x, 1) = "y")) AND (not (StringMid ($dFormat, $x, 1) = "m")) AND (not (StringMid ($dFormat, $x, 1) = "d")) then
				$dSep = StringMid ($dFormat, $x, 1)
				ExitLoop
			endif
		next
	endif
	if $tFormat = "" then
		$tFormat = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$tSep = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "sDate")
		$am = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		$pm = RegRead ("HKEY_CURRENT_USER\Control Panel\International", "s2359")
	else
		; Extract separator from time format by finding first non hour character
		for $x = 1 to StringLen ($tFormat)
			if (not (StringMid ($tFormat, $x, 1) = "h")) then
				$tSep = StringMid ($tFormat, $x, 1)
				ExitLoop
			endif
		next
		$am = "AM"
		$pm = "PM"
	endif
	
	; Separate date and time if included (make break at first space)
	if StringInStr ($sSysDateTime, " ") then
		$sSysDate = StringLeft ($sSysDateTime, StringInStr ($sSysDateTime, " ") - 1)
		$sSysTime = StringStripWS (StringReplace ($sSysDateTime, $sSysDate, ""), 1)
	else
		$sSysDate = $sSysDateTime
		$sSysTime = ""
	endif
	
	; Simple check of input date format (look for separators and unexpected non numeric characters)
	$sTestDate = StringReplace ($sSysDate, $dSep, "")
	$sTestDate = "1" & $sTestDate
	if (String (Number ($sTestDate)) <> $sTestDate) then
		SetError (1)
		Return
	endif
	if (StringInStr ($sSysDate, $dSep) = 0) AND ($dSep <> "") then
		SetError (1)
		Return
	endif
	if $sSysTime <> "" then
		$sTestDate = StringReplace ($sSysTime, $tSep, "")
		$sTestDate = StringReplace ($sTestDate, $am, "")
		$sTestDate = StringReplace ($sTestDate, $pm, "")
		$sTestDate = StringReplace ($sTestDate, " ", "")
		$sTestDate = "1" & $sTestDate
		if (StringInStr ($sSysTime, $tSep) = 0) or (String (Number ($sTestDate)) <> $sTestDate) then
			SetError (2)
			Return
		endif
	endif

	; Break up date components (using format as a template), unless format is YYYYMMDD
	if $dFormat = "YYYYMMDD" then
		$sYear = StringMid ($sSysDate, 1, 4)
		$sMonth = StringMid ($sSysDate, 5, 2)
		$sDay = StringMid ($sSysDate, 7, 2)
	else
		$split1 = StringSplit ($dFormat, $dSep)
		$split2 = StringSplit ($sSysDate, $dSep)
		for $x = 1 to $split1[0]
			if StringInStr ($split1[$x], "M") then $sMonth = $split2[$x]
			if StringInStr ($split1[$x], "d") then $sDay = $split2[$x]
			if StringInStr ($split1[$x], "y") then $sYear = $split2[$x]
		next
	endif
	
	; Pad values with 0 if required and fix 2 digit year
	if StringLen ($sMonth) = 1 then $sMonth = "0" & $sMonth
	if StringLen ($sDay) = 1 then $sDay = "0" & $sDay
	if StringLen ($sYear) = 2 then
		if $sYear > 80 then
			$sYear = "19" & $sYear
		else
			$sYear = "20" & $sYear
		endif
	endif
	
	; Break up time components (if given)
	if $sSysTime <> "" then
		; Look for AM/PM and note it, then remove from the string
		$isPM = 0
		if StringInStr ($sSysTime, $am) then
			$sSysTime = StringReplace ($sSysTime, " " & $am, "")
			$isPM = 1
		elseif StringInStr ($sSysTime, $pm) then
			$sSysTime = StringReplace ($sSysTime, " " & $pm, "")
			$isPM = 2
		endif
		$split1 = StringSplit ($tFormat, $tSep)
		$split2 = StringSplit ($sSysTime, $tSep)
		$sSec = "00"
		for $x = 1 to $split2[0]
			if StringInStr ($split1[$x], "h") then $sHour = $split2[$x]
			if StringInStr ($split1[$x], "m") then $sMin = $split2[$x]
			if StringInStr ($split1[$x], "s") then $sSec = $split2[$x]
		next
		
		; Clean up time values (change hour to 24h and 0 pad values)
		if ($isPM = 1) and ($sHour = 12) then $sHour = "00"
		if ($isPM = 2) and ($sHour < 12) then $sHour = $sHour + 12
		if StringLen ($sHour) = 1 then $sHour = "0" & $sHour
		if StringLen ($sMin) = 1 then $sMin = "0" & $sMin
		if StringLen ($sSec) = 1 then $sSec = "0" & $sSec
		
		; Return date with time
		Return $sYear & "/" & $sMonth & "/" & $sDay & " " & $sHour & ":" & $sMin & ":" & $sSec
	else
		; Return date only
		Return $sYear & "/" & $sMonth & "/" & $sDay
	endif
EndFunc   ;==>_DateCalc
