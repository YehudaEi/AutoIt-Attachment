; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.2.4.9 
; Author:         Chris Lambert
;
; Script Function: KeyGen for trial/licensed software
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

#include<string.au3>

Local $securityCodeEncryptionKey = "MyPa55w0rd" ;this must match the applications key

$str = InputBox ("ISS Drive Check Registration","Input code")
If @error = 1 then exit
	
$Generate = StringUpper (StringRight ($str,5))
$restore = StringUpper(_StringEncrypt (1, $Generate, $securityCodeEncryptionKey , 1 ))

ClipPut ($restore)

Msgbox (0,"ISS Drive Check","The registration code is: " & $restore & @crlf & @crlf & "The code has been placed on the clipboard")
