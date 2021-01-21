
#include <math.au3>
;===============================================================================
;
; Description:      returns the date of easter in specified year
;                   between 1583 and 2999
; Parameter(s):     $year
; 
; Return Value(s):  On Success - easterdate
;                   On Failure - -1
; Author(s):        BugFix (bug_fix@web.de)
; Note(s):          
;
;===============================================================================
Func _easter($year)
	;Determination Easter with formula by C. F. Gauss
	;Ermittlung Ostern (Osterformel C. F. Gauss)
	If $year > 1582 And $year < 3000 Then		
		$a = Mod($year,19)
		$b = Mod($year,4)
		$c = Mod($year,7)
		$H1 = _Div($year,100)	; _Div($a, $b) is a userdefined function 
		$H2 = _Div($year,400)	; Int($year / 100) give the same output
		$N = 4 + $H1 - $H2
		$M = 15 + $H1 - $H2 - _Floor(_Div((8 * $H1 + 13),25))
		$d = Mod((19 * $a + $M),30)
		$e = Mod((2 * $b + 4 * $c + 6 * $d + $N),7)
		If $d + $e = 35 Then
			$Easter = 50
		Else
			If $d = 28 And $e =6 And $a > 10 Then
				$Easter = 49
			Else
				$Easter = 22 + $d + $e
			EndIf
		EndIf
		If $Easter < 32 Then
			$EasterDay = $Easter
			$EasterMonth = "03"			
		Else
			$EasterDay = $Easter - 31
			$EasterMonth = "04"
		EndIf
		If $EasterDay < 10 Then
			$EasterDay = "0" & $Easterday
		EndIf
		$EasterDate = $year & "/" & $EasterMonth & "/" & $EasterDay
;		$EasterDate = $EasterDay & "." & $EasterMonth & "." & $year			german notation
	Else
		$EasterDate = -1	; input year is out of range
	EndIf
	Return $EasterDate
EndFunc	;==>_easter()
