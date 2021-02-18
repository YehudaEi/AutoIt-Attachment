#include-once

;===============================================================================
;
; AutoIt Version: 3.3.5.6
; Language:       English
; Description:    Provide functions for Unix timestamps.
; Requirement(s): Minimum Autoit 3.2.3.0
; Credits : 	  Rob Saunders was the first to write such udf but his udf requires a dll
;
;===============================================================================



;===============================================================================
;
; Description:      GetUnixTimeStamp - Get time as Unix timestamp value for a specified date
;                   to get the current time stamp call GetUnixTimeStamp with no parameters
;                   beware the current time stamp has system UTC included to get timestamp with UTC + 0
;					substract your UTC , exemple your UTC is +2 use GetUnixTimeStamp() - 2*3600
; Parameter(s):     Requierd : None
;                   Optional :
;								- $year => Year ex : 1970 to 2038
;								- $mon  => Month ex : 1 to 12
;								- $days => Day ex : 1 to Max Day OF Month
;								- $hour => Hour ex : 0 to 23
;								- $min  => Minutes ex : 1 to 60
;								- $sec	=> Seconds ex : 1 to 60
; Return Value(s):  On Success - Returns Unix timestamp
;                   On Failure - No Failure if valid parameters are valid
; Author(s):        azrael-sub7 (azrael-sub7@satanic.ro)
; User Calltip:		GetUnixTimeStamp() (required: <_AzUnixTime.au3>)
;
;===============================================================================

Func GetUnixTimeStamp($year = 0, $mon = 0, $days = 0, $hour = 0, $min = 0, $sec = 0)
	If $year = 0 Then $year = Number(@YEAR)
	If $mon = 0 Then $mon = Number(@MON)
	If $days = 0 Then $days = Number(@MDAY)
	If $hour = 0 Then $hour = Number(@HOUR)
	If $min = 0 Then $min = Number(@MIN)
	If $sec = 0 Then $sec = Number(@SEC)
	Local $NormalYears = 0
	Local $LeepYears = 0
	For $i = 1970 To $year - 1 Step +1
		If BoolLeapYear($i) = True Then
			$LeepYears = $LeepYears + 1
		Else
			$NormalYears = $NormalYears + 1
		EndIf
	Next
	Local $yearNum = (366 * $LeepYears * 24 * 3600) + (365 * $NormalYears * 24 * 3600)
	Local $MonNum = 0
	For $i = 1 To $mon - 1 Step +1
		$MonNum = $MonNum + MaxDayInMonth($year, $i)
	Next
	Return $yearNum + ($MonNum * 24 * 3600) + (($days -  1 ) * 24 * 3600) + $hour * 3600 + $min * 60 + $sec
EndFunc   ;==>GetUnixTimeStamp

;===============================================================================
;
; Description:      UnixTimeStampToTime - Converts UnixTime to Date
; Parameter(s):     Requierd : $UnixTimeStamp => UnixTime ex : 1102141493
;                   Optional : None
; Return Value(s):  On Success - Returns Array
;								- $Array[0] => Year ex : 1970 to 2038
;								- $Array[1] => Month ex : 1 to 12
;								- $Array[2] => Day ex : 1 to Max Day OF Month
;								- $Array[3] => Hour ex : 0 to 23
;								- $Array[4] => Minutes ex : 1 to 60
;								- $Array[5]	=> Seconds ex : 1 to 60
;                   On Failure  - No Failure if valid parameter is a valid UnixTimeStamp
; Author(s):        azrael-sub7 (azrael-sub7@satanic.ro)
; User Calltip:		UnixTimeStampToTime() (required: <_AzUnixTime.au3>)
;
;===============================================================================


Func UnixTimeStampToTime($UnixTimeStamp)
Dim $pTime[6]
$pTime[0] = Floor($UnixTimeStamp/31436000) + 1970 ; pTYear
Local $pLeap = Floor(($pTime[0]-1969)/4)
Local $pDays =  Floor($UnixTimeStamp/86400)
$pDays = $pDays - $pLeap
$pDaysSnEp = Mod($pDays,365)
$pTime[1] = 1 ;$pTMon
$pTime[2] = $pDaysSnEp ;$pTDays
If $pTime[2] > 59 And BoolLeapYear($pTime[0]) = True Then $pTime[2] += 1
While 1
If($pTime[2] > 31) Then
$pTime[2] = $pTime[2] - MaxDayInMonth($pTime[1])
$pTime[1]  = $pTime[1] + 1
Else
ExitLoop
EndIf
WEnd
Local $pSec = $UnixTimeStamp - ($pDays + $pLeap) * 86400
$pTime[3] = Floor($pSec/3600) ; $pTHour
$pTime[4] = Floor(($pSec - ($pTime[3] * 3600))/60) ;$pTmin
$pTime[5] = ($pSec -($pTime[3] * 3600)) - ($pTime[4] * 60) ; $pTSec
Return $pTime
EndFunc

;===============================================================================
;
; Description:      BoolLeapYear - Check if Year is Leap Year
; Parameter(s):     Requierd : $year => Year to check ex : 2011
;                   Optional : None
; Return Value(s):  True if $year is Leap Year else False
; Author(s):        azrael-sub7 (azrael-sub7@satanic.ro)
; User Calltip:		BoolLeapYear() (required: <_AzUnixTime.au3>)
; Credits :			Wikipedia Leap Year
;===============================================================================

Func BoolLeapYear($year)
	If Mod($year, 400) = 0 Then
		Return True ;is_leap_year
	ElseIf Mod($year, 100) = 0 Then
		Return False ;is_not_leap_y
	ElseIf Mod($year, 4) = 0 Then
		Return True ;is_leap_year
	Else
		Return False ;is_not_leap_y
	EndIf
EndFunc   ;==>BoolLeapYear

;===============================================================================
;
; Description:      MaxDayInMonth - Converts UnixTime to Date
;					if the function is called with no parameters it returns maximum days for current system set month
;					else it returns maximum days for the specified month in specified year
; Parameter(s):     Requierd : None
;                   Optional :
;								- $year : year : 1970 to 2038
;								- $mon : month : 1 to 12
; Return Value(s):
; Author(s):        azrael-sub7 (azrael-sub7@satanic.ro)
; User Calltip:		MaxDayInMonth() (required: <_AzUnixTime.au3>)
;===============================================================================

Func MaxDayInMonth($year = @YEAR, $mon = @MON)
	If Number($mon) = 2 Then
		If BoolLeapYear($year) = True Then
			Return 29 ;is_leap_year
		Else
			Return 28 ;is_not_leap_y
		EndIf
	Else
	If $mon < 8 Then
    If Mod($mon, 2) = 0 Then
        Return 30
    Else
        Return 31
    EndIf
Else
    If Mod($mon, 2) = 1 Then
        Return 30
    Else
        Return 31
    EndIf
EndIf
	EndIf
EndFunc   ;==>MaxDayInMonth

; Here i Did a test
;$time = UnixTimeStampToTime(GetUnixTimeStamp(2010, 9, 1, 11, 10, 30))
;ClipPut(GetUnixTimeStamp(2010, 9, 1, 11, 10, 30))
;MsgBox(0,0,$time[0] & " " & $time[1] & " " & $time[2] & " " & $time[3] & " " & $time[4] & " " & $time[5] )