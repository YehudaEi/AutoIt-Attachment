; Author(s):        GreenCan
; Note(s):  		Example of  _InputDate
#include <_InputDate.au3>

; Example 1 - Default usage, period
$Result = _InputDate()
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; Example 2 - accepts negative returns (no period legality check)
$Result = _InputDate(Default,Default,Default, False)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; Example 3 - Predefined dates
$from = "2009/01/17"
$to = "2009/01/30"
$Result = _InputDate($from,$to)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; example 4 - single date
$date = "2012/05/11"
$Result = _InputDate($date,Default, False)
If @error Then
	ConsoleWrite("Error, Date not confirmed" & @CR)
Else
	ConsoleWrite("Date returned: " & $Result[1] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & @CR )
EndIf

; Example 5 - Input dates in 'yyyy/mm/dd' format
$from = "2013/01/17"
$to = "2013/01/30"
$Result = _InputDate($from,$to)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; Example 6 - Input dates in 'yyyy/mm/dd' format, mixed date formats are not allowed
$from = "27/12/2008" ; not the correct format,  will be replaced by today
$to = "2009/02/12"
$Result = _InputDate($from,$to)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; Example 7 - Input dates converted to 'yyyy/mm/dd' format by _DateCalc
$sDateFormat = RegRead("HKCU\Control Panel\International", "sShortDate")
$from = _DateCalc ("03/04/2008", $sDateFormat)
$to = _DateCalc ("05/04/2013", $sDateFormat)
$Result = _InputDate($from,$to)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf

; Example 8 - dates default to tomorrow
$from = _DateAdd( 'D',1,_NowCalcDate())
$to = $from
$Result = _InputDate($from,$to)
If @error Then
	ConsoleWrite("Days between calculation: Error, Period not confirmed" & @CR)
Else
	ConsoleWrite("Days between calculation: " & $Result[0] & " Days between " & $Result[1] & " and " & $Result[2] & _
	" ==> converted to yyyy/mm/dd: " & DateFormat($Result[1], "yyyy/mm/dd") & " and " & DateFormat($Result[2], "yyyy/mm/dd") & @CR )
EndIf
