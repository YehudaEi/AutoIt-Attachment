--- <code follows, (beware of word-wrap)> ---

Func GetLocaleInfo($LC_CONST)  ; wrapper for the "GetLocaleInfo" api...
Dim $result  ; as Array of Return Values (the first value is the api return value)...
Dim $LCID  ; as long (locale ID)
Dim $sLCData  ; as string
Dim $cbStr  ; as long (byte count)

  ; first, we get the "LCID", that is, the locale Id (number)...
  $result = DllCall("KERNEL32.DLL", "long", "GetUserDefaultLCID")
  $LCID = $result[0]

  ; Private Declare Function GetLocaleInfo Lib "kernel32" Alias "GetLocaleInfoA" (ByVal Locale As Long, ByVal LCType As Long, ByVal lpLCData As String, ByVal cchData As Long) As Long
  $result = DllCall("KERNEL32.DLL", "long", "GetLocaleInfoA", "long", $LCID, "long", $LC_CONST, "str", "", "long", 20)  ; should need less than 20 chars... 
  $cbStr = $result[0]  ; number of chars returned (inc. terminating "0")
  ; note: the $cbStr character count includes a "terminating null character"
  ;   returned by the function.  The following statement removes that null 
  ;   character from the text returned in param 3...
  $sLCData = StringLeft($result[3], $cbStr - 1)  ; strip null 
  Return $sLCData  ; return string result

EndFunc



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
; Revision History:
; 10Sept05: replaced getting date/time formats from registry data (only works with nt and xp),
;    with api calls (which should work with nt/xp _AND_ win9x... (jw)
;===============================================================================

Func _myDateTimeFormat($sDate, $sType)
Const $fName = "[dtFormat], "
;
Local $asDatePart[4]
Local $asTimePart[4]
Local $LC_DATECONST = 0  ; was: $sReg_DateValue = ""
Local $LC_TIMECONST = 0  ; was: $sReg_TimeValue = ""
Local $sTempDate
Local $sNewTime
Local $sNewDate
Local $sAM
Local $sPM
Local $iWday
;
Const $LOCALE_SDATE = 29          ; date separator
Const $LOCALE_STIME = 30          ; time separator
Const $LOCALE_SSHORTDATE = 31     ; short date format string
Const $LOCALE_SLONGDATE = 32      ; long date format string
Const $LOCALE_STIMEFORMAT = 4099  ; time format string
Const $LOCALE_ITIME = 35          ; time format, 0 AM/PM 12-hr format, 1 24-hr format
;
Const $LOCALE_S1159 = 40          ; AM designator
Const $LOCALE_S2359 = 41          ; PM designator

	; Verify If InputDate is valid
	If Not _myDateIsValid($sDate) Then
	    dbPrint($fName & "uh-oh. Flunked the isDateValid test. $sDate: [" & $sDate & "]")
          SetError(1)
	    Return ("")
	EndIf
	; input validation
	If $sType < 0 Or $sType > 4 Or Not IsInt($sType) Then
	    dbPrint($fName & "uh-oh. invalid $sType parameter.. ")
	    SetError(2)
	    Return ("")
	EndIf

	_DateTimeSplit($sDate, $asDatePart, $asTimePart)
	
	If $sType = 0 Then
		; $sReg_DateValue = "sShortDate"
		$LC_DATECONST = $LOCALE_SSHORTDATE
		; If $asTimePart[0] > 1 Then $sReg_TimeValue = "sTimeFormat"
		If $asTimePart[0] > 1 Then $LC_TIMECONST = $LOCALE_STIMEFORMAT
	EndIf
	
	; If $sType = 1 Then $sReg_DateValue = "sLongDate"
	; If $sType = 2 Then $sReg_DateValue = "sShortDate"
	; If $sType = 3 Then $sReg_TimeValue = "sTimeFormat"
	; If $sType = 4 Then $sReg_TimeValue = "sTime"
	If $sType = 1 Then $LC_DATECONST = $LOCALE_SLONGDATE
	If $sType = 2 Then $LC_DATECONST = $LOCALE_SSHORTDATE
	If $sType = 3 Then $LC_TIMECONST = $LOCALE_STIMEFORMAT
	If $sType = 4 Then $LC_TIMECONST = $LOCALE_STIME
	$sNewDate = ""
	; If $sReg_DateValue <> "" Then
	If $LC_DATECONST <> 0 Then
		; $sTempDate = RegRead("HKEY_CURRENT_USER\Control Panel\International", $sReg_DateValue)
		; $sAM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s1159")
		; $sPM = RegRead("HKEY_CURRENT_USER\Control Panel\International", "s2359")
        $sTempDate = GetLocaleInfo($LC_DATECONST)
		; $sAM = GetLocaleInfo($LOCALE_S1159)
		; $sPM = GetLocaleInfo($LOCALE_S2359)
		; If $sAM = "" Then $sAM = "AM"
		; If $sPM = "" Then $sPM = "PM"
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
        dbPrint($fName & "date part finished, result: " & $sNewDate)
	EndIf
	; If $sReg_TimeValue <> "" Then
	If $LC_TIMECONST <> 0 Then
		; $sNewTime = RegRead("HKEY_CURRENT_USER\Control Panel\International", $sReg_TimeValue)
		$sNewTime = GetLocaleInfo($LC_TIMECONST)  ; time separator
		$sAM = GetLocaleInfo($LOCALE_S1159)
		$sPM = GetLocaleInfo($LOCALE_S2359)
		If $sAM = "" Then $sAM = "AM"
		If $sPM = "" Then $sPM = "PM"
		If $sType = 4 Then
			$sNewTime = $asTimePart[1] & $sNewTime & $asTimePart[2]
		Else
			If $asTimePart[1] < 12 Then
				; $sNewTime = StringReplace($sNewTime, "tt", "AM")
				$sNewTime = StringReplace($sNewTime, "tt", $sAM)
				If $asTimePart[1] = 0 Then $asTimePart[1] = 12
			Else
				; $sNewTime = StringReplace($sNewTime, "tt", "PM")
				$sNewTime = StringReplace($sNewTime, "tt", $sPM)
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


