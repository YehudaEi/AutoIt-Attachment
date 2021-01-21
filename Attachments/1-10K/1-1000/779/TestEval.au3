; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         S.A.Pechler
;
; Script Function:
;	Tests the Eval() function
;
; ----------------------------------------------------------------------------


; First we test the regular variable evaluation
; (Using the example code from AutoIt Help)


Dim $a_b = 12		; Variable to test
Dim $s			; To store the result


$s = Eval("a" & "_" & "b")  ; $s is set to 12

MsgBox (0,"Eval Test", "$s should be 12. Current result is: " & $s)

$s = Eval("c")  ; $s = "" and @error = 1


MsgBox (0,"Eval Test", "$s should be empty. Current result is: " & $s)


; Now we will test a 'true' expression

$s = Eval("1=1")

MsgBox (0,"Eval Test", "Result of expression '1=1' is: " & $s)


; Now we will test a false expression

$s = Eval("1=0")

MsgBox (0,"Eval Test", "Result of expression '1=0' is: " & $s)


; Now we will test a complex expression

$s = Eval('@OSVersion="WIN_XP" and @OSServicePack <= "Service Pack 1"')

MsgBox (0,"Eval Test", 'Result of expression  @OSVersion="WIN_XP" and @OSServicePack <= "Service Pack 1"  is: ' & $s)
