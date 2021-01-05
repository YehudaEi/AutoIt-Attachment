; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         Alexis Cheng

;$freq is the frequency
;$dur is the duration

$freq = 2000
$dur = 1000
DLLCall("kernel32.dll","int","Beep","long",$freq,"long",$dur);


; ----------------------------------------------------------------------------
; Script Start - Add your code below here
; ----------------------------------------------------------------------------

