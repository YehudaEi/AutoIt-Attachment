; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Setup some useful options that you may want to turn on - see the helpfile for details.

; Expand all types of variables inside strings
;Opt("ExpandEnvStrings", 1)
;Opt("ExpandVarStrings", 1)

; Require that variables are declared (Dim) before use (helps to eliminate silly mistakes)
;Opt("MustDeclareVars", 1)
$var1=0
$var2=0
$var3=0
$wrong=0
While 1

 If _IsPressed('01') = 1 Then $var1=1
 If _IsPressed('04') = 1 Then $var2=1
 If _IsPressed('02') = 1 Then $var3=1
 If _IsPressed('01') = 0 Then $var1=0
 If _IsPressed('04') = 0 Then $var2=0
 If _IsPressed('02') = 0 Then $var3=0

;
if $var1 and $var2=0 and $var3 then ;101
$wrong=1
;tooltip ("wrong")
sleep (500)
tooltip("")
endif
;
if $var1=0 and $var2 and $var3 then ;011
$wrong=1
;tooltip ("wrong")
sleep (500)
;tooltip("")
endif
;
;
if $var1=0 and $var2 and $var3=0 then ;010
$wrong=1
;tooltip ("wrong")
sleep (500)
;tooltip("")
endif
;
if $var1=0 and $var2=0 and $var3=0 and $wrong=1 then ; reset 
$wrong=0
;tooltip ("reseted")
sleep (500)
;tooltip("")
endif
;
;

If $var1 and $var2 and $var3 and $wrong=0 then ; 111 pressed
tooltip ("Machine Shutting Down....")
sleep (2000)
shutdown(9)
tooltip("")
endif

Sleep(10)
Wend

Exit
Func _IsPressed($hexKey)
; $hexKey must be the value of one of the keys.
; _IsPressed will return 0 if the key is not pressed, 1 if it is.

 Local $aR, $bRv;$hexKey
 $hexKey = '0x' & $hexKey
 $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
;If $aR[0] = -32767 Then
 If $aR[0] <> 0 Then
    $bRv = 1
 Else
    $bRv = 0
 EndIf

 Return $bRv
EndFunc ;==>_IsPressed


; ----------------------------------------------------------------------------
; Script Start - Add your code below here
; ----------------------------------------------------------------------------

