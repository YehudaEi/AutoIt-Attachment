; AUTOIT SPEED TESTER
; What is faster in autoIT3?
; ????????????????????????????????????????????????????????????????????????????
; What I know for sure as of version 3.2.4.9:
;
; 1. For/next loops are champions. Try not to use While/Wend or Do/Until
; 2. If $Val is faster than If $Val = 1 or $Val = TRUE. 
; 3. If $Val = 1 is faster than $Val = TRUE
; 4. If Not $Val is faster than If $Val = 0 or $Val = FALSE. 
; 5. If $Val = 0 is faster than If $Val = FALSE
; 6. < and > are faster than =, >= or >= (Wow!)
; 7. $i += 1 is faster than $i = $i + 1
; 8. If doing a lot of verifications on a single variable:
;    Switch is fastest, Select is second (but slow) and If is slowest.
; 9. If $Val is a string, If Not $Val is faster than If $Val = ""
;    If $Val is faster than If $Val <> "" 
; 10. When doing binary operations, If $Val -128 > 0 is twice as fast
;     as If BitAnd($Val, 128).
;
; IMPORTANT: To get precise timings, TURN OFF ALL RUNNING PROGRAMS!
; To get compiled speeds ... compile and run :) (that was easy)
; Also note different CPU/Chipset/GPUs can affect results.
; It's been brought to my attention by chris95219 that GetTickCount() cannot be properly timed
; Also if you modify $i and $j (both loop counters) you will obviously get incorrect results!
; Other functions that can't be tested ... Exit (!) and Return (for obvious reasons)
; ????????????????????????????????????????????????????????????????????????????

Global $Chrono[21] ; Chronometer values
Global $Mess = "Timer values"&@CR ; String to contain MsgBox content.

; Declare all necessary variables for your test code here
$Val = 0

; Actual timing loops
; ============================================================================
For $i = 1 To 20 ; 20 iterations of set
	$go = TimerInit() ; Start your engines!

	For $j = 1 To 9999 ; 9999 iterations of commands here
					   ; For complex test code, reduce value
					   ; although I suggest to test small bits instead.

		; Insert your test code here
		; Remove all commands to get a base reading (when you substract the base 
		; value from the values you get when you add a command, you will get the
		; true time it took to process your command. 
		; IMPORTANT: Then ConsoleWrite("") serves as a dummy opreation to satisfy
		;            the IF condition.

	If $Val Then ConsoleWrite("")

	Next ; $j

	$Chrono[$i] = TimerDiff($go) ; Ok, how long did it take?
	$Mess &= "Pass "&$i&" = "&$Chrono[$i]&"ms"&@CR ; Jolt it down for the report
	
Next ; $i
; ============================================================================

_Report() ; ... err report it!

Exit

; ==== FUNCTIONS =============================================================
Func _Report()
	$Mess &= @CR ; Add an empty line
	$Mess &= "Min: "&_Minn()&"ms"&@CR ; Find minimum value and add it
	$Mess &= "Max: "&_Maxx()&"ms"&@CR ; Find maximum value and add it
	$Mess &= "Ave: "&_Ave()&"ms"&@CR ; Calculate median value and add it!
	MsgBox(48,"Results",$Mess) ; Show it to the user --> see how @CR works?
EndFunc

Func _Maxx() ; Find maximum value and return it
	Local $i, $Max ; Set local variables
	For $i = 1 To Ubound($Chrono) -1 ; Read all values in $Chrono, from 1 to end
		If $Chrono[$i] > $Max Then $Max = $Chrono[$i] ; If the current value is larger than the current max, it is the new max.
	Next
	Return $Max ; Send back the value
EndFunc

Func _Minn() ; Find minimum value and add it
	Local $i, $Min = $Chrono[1] ; Set local variables. Notice $Min which equals the first value in $Chrono
	For $i = 1 To Ubound($Chrono) -1 ; Read all values in $Chrono, from 1 to end
		If $Chrono[$i] < $Min Then $Min = $Chrono[$i] ; If the current value is lower than the current min, it is the new min.
	Next
	Return $Min ; Send back the value
EndFunc

Func _Ave() ; Find average value and return it
	Local $i, $Ave ; Set local variables
	For $i = 1 To Ubound($Chrono) -1 ; Read all values in $Chrono, from 1 to end
		$Ave += $Chrono[$i] ; Add up all the values
	Next
	Return $Ave / $i ; Send back the value, dividing total by # of numbers added together --> average
EndFunc
