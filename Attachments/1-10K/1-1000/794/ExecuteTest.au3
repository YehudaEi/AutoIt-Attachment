; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         S.A.Pechler
;
; Script Function:
;	Tests the Execute() function
;
; ----------------------------------------------------------------------------


Dim $a		; Variable to test

$a = 0

; Test 1, simple variable assignment

Execute("$a=1")

MsgBox (0,"Execute Test", "Test1:" & @CRLF & "$a should be 1: " & @CRLF & "$a=" & $a)


; Test 2, Internal function call

$a = 'Msgbox(0,"Execute Test","Test2:" & @CRLF & "This messagebox was created inside the Execute() function.")'

Execute($a) 

; Test 3, Error suppression

$a = "invalid keyword"

Execute($a,1)

; Script would stop here if an error occured

MsgBox (0,"Execute Test", "Test3:" & @CRLF & "Error suppression of execute function() passed")


; Test 4, without error suppression

MsgBox (0,"Execute Test", "Test4:" & @CRLF & "Without error suppression, this script should fail after pressing 'ok'.")

Execute($a)

; Script should stop here with an error message.
