#include-once
#include <Date.au3>

#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _InputDate
; Description ...: Creates a Dialog for a single day or a period entry
; Syntax ........: _InputDate([$dFrom = Default[, $dTill = Default[, $bPeriod = Default[, $bLegality = Default]]]])
; Parameters ....: $dFrom   	   - [optional] Date (if $bPeriod is True, starting the period ) (default = Default)
;				   $dTill		   - [optional] Date ending the Period, unused if $bPeriod is False  (default = Default)
;                  $bPeriod        - [optional] Bolean, if false, dialog will input one date (default = Default)
;                  $bLegality	   - [optional] Period Legality Check (default = Default)
;
; Return values .: Success	- A single dimension array containing following elemnts:
;						[0] - Number of days between From and Till ( is 0 if single date input)
;						[1] - From date
;    					[2] - Till date ( is empty if single date input)
;					Failure	- Returns @error
;                  |1 - Escape pressed
;                  |2 - $bPeriod is not boolean
;                  |3 - $bLegality is not boolean
;
; Requirements ..:
; Author ........: Greencan
; Related .......:
; Remarks .......: Input dates Default to Date_Time_GetLocalTime() unless provided
;				   in 'yyyy/mm/dd' format
;				   Illegal formats will be replaced by Date_Time_GetLocalTime()
;				   function uses DateCalc.au3 (_DateCalc udf) from Sean Hart
; Link ..........;
; Example .......; Yes
	; ===============================================================================================================================
Func _InputDate($dFrom = Default, $dTill = Default, $bPeriod = Default, $bLegality = Default)

	If $dFrom = Default Then $dFrom = ""
	If $dTill = Default Then $dTill = ""
	If $bPeriod = Default Then $bPeriod = True
	If Not IsBool($bPeriod) Then Return SetError(2, 0, 0)
	If $bLegality = Default Then $bLegality = True
	If Not IsBool($bLegality) Then Return SetError(3, 0, 0)

	Local $_msg, $_ok, $Days_between, $sTitle, $iHeight
	Local $sDateFormat = RegRead("HKCU\Control Panel\International", "sShortDate") ; get system locale short Dateformat

	If $bPeriod Then
		$sTitle = "Set Period"
		$iHeight = 170
	Else
		$sTitle = "Set Date"
		$iHeight = 130
	EndIf
	Local $input_Window = GUICreate($sTitle, 170, $iHeight, -1, -1, 0x00800000) ; $WS_BORDER = 0x00800000 requires #include <WindowsConstants.au3>

	If $bPeriod Then
		; period
		GuiCtrlCreateLabel("From:", 10, 22)
		$dFrom = GUICtrlCreateDate($dFrom,  50 , 20, 100, 20, 0 ) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
		GuiCtrlCreateLabel("To:", 10, 52)
		$dTill = GUICtrlCreateDate($dTill, 50 , 50, 100, 20, 0 ) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
	Else
		; Single date
		GuiCtrlCreateLabel("Date:", 10, 22)
		$dFrom = GUICtrlCreateDate($dFrom,  50 , 20, 100, 20, 0 ) ; $DTS_SHORTDATEFORMAT = 0 #include <DateTimeConstants.au3>
	EndIf

	$_ok = GUICtrlCreateButton("OK", 50, $iHeight - 60, 70, 20, 0x0001) ; $BS_DEFPUSHBUTTON = 0x0001 requires #include <ButtonConstants.au3>

	GUISetState()

	; Run the GUI until the dialog is closed
	Do
		$_msg = GUIGetMsg()
		If  $_msg = $_ok Then
			If $bPeriod Then
				$Days_between = _DateDiff('D', _DateCalc(GUICtrlRead($dFrom),$sDateFormat), _DateCalc(GUICtrlRead($dTill),$sDateFormat))
				; period legality check
				If $bLegality = 1 And $Days_between < 0 Then
					GuiCtrlCreateLabel("Incorrect Period", 48, 82,120)
					GUICtrlSetColor ( -1, 0xff0000)
					Beep(2000, 10)
					ContinueLoop
				Else
					Dim $Period[3]
					$Period[0] = $Days_between
					$Period[1] = GUICtrlRead($dFrom)
					$Period[2] = GUICtrlRead($dTill)
					GUIDelete($input_Window)
					Return $Period
				EndIf
			Else
				Dim $Period[3]
				$Period[0] = 0
				$Period[1] = GUICtrlRead($dFrom)
				$Period[2] = ""
				GUIDelete($input_Window)
				Return $Period
			EndIf
			GUISetState()
		EndIf
	Until $_msg = -3 ; $GUI_EVENT_CLOSE = -3  requires #include <GUIConstantsEx.au3>
	GUIDelete($input_Window)
	Return SetError(1, 0, 0)

EndFunc   ;==>_InputDate
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: _DateCalc
; Description ...: Returns the Date [and time] in format YYYY/MM/DD [HH:MM:SS],
;				   give the date / time in the system or specified format.
; Syntax ........: _DateCalc($sSysDateTime[, $dFormat = ""[, $tFormat = ""]])
; Parameters ....: $sSysDateTime	- Input date [and time]
;				   $dFormat		   - [optional] Format of input date (default = "")
;				   $tFormat		   - [optional] Format of input time (default = "")
;
; Return values .: Success - Returns Date in in format YYYY/MM/DD [HH:MM:SS]
;					Failure	- Returns @error
;                  |1 - input date badly formatted
;                  |2 - input time badly formatted
;
; Requirements ..: None
; Author ........: Sean Hart <autoit@hartmail.ca>
; Related .......:
; Remarks .......: Date format can be provided without any separators only in
;				   the format YYYYMMDD.
;				   If system format is used it is current user format, NOT
;				   default user format (which may be different).
;				   2 digit years converted: 	81 - 99 -> 1981-1999
;												00 - 80 -> 2000-2080²
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _DateCalc($sSysDateTime, $dFormat = "", $tFormat = "")
	Local $sDay, $sMonth, $sYear, $sHour, $sMin, $sSec, $dSep, $tSep, $am, $pm, $split1[9], $split2[9], $sSysDate, $sSysTime, $isAM, $isPM, $sTestDate
	;Local $dFormat, $tFormat

	; Read default system time formats and separators from registry unless provided
	if $dFormat = "" then
		$dFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$dSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDate")
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
		$tFormat = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sShortDate")
		$tSep = RegRead("HKEY_CURRENT_USER\Control Panel\International", "sDate")
		$am = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		$pm = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s2359")
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
#FUNCTION# ==============================================================
; #FUNCTION# ====================================================================================================================
; Name ..........: DateFormat
; Description ...: Universal date format converter
;					Converts the (default regional setting) PC Date format into any other specIfied date format:
;					- convert date into another date format (for example ddd dd MMMM, yyyy)
;					- convert date into day (d or dd)
;					- convert date into month ( m, mm or mmm)
;					- convert date into year (yy or yyyy)
; Syntax ........: DateFormat($InputDate[, $DateFmt = "mm/dd/yyyy"])
; Parameters ....: $InputDate      - Date to be converted
;				   $DateFmt		   - [optional] Date format to convert to (default = "mm/dd/yyyy")
;
; Return values .: Success - Returns Date in in requested format
;				   Failure (if escape was pressed) - Returns an empty string
; Return values .: Success	- A single dimension array containing following elemnts:
;						[0] - Number of days between From and Till ( is 0 if single date input)
;						[1] - From date
;    					[2] - Till date ( is empty if single date input)
;					Failure	- Returns @error
;                  |1 - Input date badly formatted
;                  |2 - Invalid Year in Date
;                  |3 - Invalid Month in Date
;                  |4 - Invalid Day in Date
;
; Requirements ..: _DateCalc() - The udf is included in this script
; Author ........: Greencan
; Related .......:
; Remarks .......:  Part of source code was borrowed from the Date conversion example provided by DaRam
;						http://www.autoitscript.com/forum/index.php?showtopic=76984&view=findpost&p=557834
;					DateCalc.au3 (_DateCalc udf) by Sean Hart
;						http://www.autoitscript.com/forum/index.php?showtopic=14084&view=findpost&p=96173
; Link ..........;
; Example .......; Yes
;					DateFormat( _NowCalcDate() , "dd-MM-yyyy" )
; ===============================================================================================================================
Func DateFormat($InputDate, $DateFmt = "mm/dd/yyyy")
	If StringLen($InputDate) < 6 Then Return SetError(1, 0, 0) ; Invalid Date ==> ddmmyy = 6

	Local $sDateFormat = RegRead("HKCU\Control Panel\International", "sShortDate") ; get system locale short Dateformat
	If $DateFmt = "" Then $DateFmt = "dd/mm/yyyy"
	Local $DateValue = _DateCalc($InputDate,$sDateFormat) ; convert the date to yyyy/mm/dd
	$DateValue = StringSplit($DateValue, "/")
	; error checking
	If @error Then Return SetError(1, 0, 0) ; Invalid Input Date
	If $DateValue[0] < 3 Then Return SetError(1, 0, 0) ; less than 3 parts in date not possible
	If Int(Number($DateValue[1])) < 0 Then Return SetError(2, 0, 0) ; Invalid Year in Date
	If Int(Number($DateValue[2])) < 1 Or Int(Number($DateValue[2])) > 12 Then Return SetError(3, 0, 0) ; Invalid Month in Date
	If Int(Number($DateValue[3])) < 1 Or Int(Number($DateValue[3])) > 31 Then Return SetError(4, 0, 0) ; Invalid Day in Date

	If Int(Number($DateValue[1])) < 100 Then $DateValue[1] = StringLeft(@YEAR,2) & $DateValue[1]
	$InputDate = $DateFmt
	$InputDate = StringReplace($InputDate, "d", "@")                                    ; Convert All Day References to @
	$InputDate = StringReplace($InputDate, "m", "#")                                    ; Convert All Month References to #
	$InputDate = StringReplace($InputDate, "y", "&")                                    ; Convert All Year References to &
	$InputDate = StringReplace($InputDate, "&&&&", $DateValue[1])                       ; Century and Year
	$InputDate = StringReplace($InputDate, "&&", StringRight($DateValue[1],2))          ; Year Only
	$InputDate = StringReplace($InputDate, "&", "")                                     ; Discard leftover Year Indicator
	$InputDate = StringReplace($InputDate, "####", _DateToMonth($DateValue[2], 0))      ; Long Month Name
	$InputDate = StringReplace($InputDate, "###", _DateToMonth($DateValue[2], 1))       ; Short Month Name
	If StringLen($DateValue[1]) < 2 Then
		$InputDate = StringReplace($InputDate, "##", "0" & $DateValue[2])               ; Month Number 2 Digit
	Else
		$InputDate = StringReplace($InputDate, "##", $DateValue[2])                     ; Month Number 2 Digit
	EndIf
	$InputDate = StringReplace($InputDate, "#", int($DateValue[2]))                     ; Month Number
	Local $iPos = _DateToDayOfWeek($DateValue[1], $DateValue[2], $DateValue[3])         ; Day of Week Number
	$InputDate = StringReplace($InputDate, "@@@@", _DateDayOfWeek($iPos, 0))            ; Long Weekday Name
	$InputDate = StringReplace($InputDate, "@@@", _DateDayOfWeek($iPos, 1))             ; Short Weekday Name
	$InputDate = StringReplace($InputDate, "@@", $DateValue[3])                         ; Day Number 2 Digit
	$InputDate = StringReplace($InputDate, "@", int($DateValue[3]))                     ; Day Number

	Return $InputDate
EndFunc ;==>DateFormat
#FUNCTION# ==============================================================
