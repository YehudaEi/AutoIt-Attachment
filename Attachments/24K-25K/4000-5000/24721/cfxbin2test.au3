#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#AutoIt3Wrapper_Res_LegalCopyright=Uwe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "cfxbin2.au3"

HotKeySet("{ESC}", "Terminate")
if _opencomm1()>0 and _opencomm2()>0 Then
 	beep(2000,100)
 	beep(3000,100)
 	beep(4000,100)


While True
 		$rr1=_rxByte1(5)
		if stringlen($rr1)>0 Then
			ConsoleWrite("COM1: " & c2s($rr1) & @crlf)
			_tx2($rr1)
			if asc($rr1)>32 then 
				consolewrite($rr1)
			Else
				ConsoleWrite(c2s($rr1) & @crlf)
			EndIf
			if $rr1=@lf then consolewrite(@crlf)
		EndIf
 		$rr2=_rxByte2(100)
 		if stringlen($rr2)>0 Then
 			ConsoleWrite("COM2:                    " & c2s($rr2)& @crlf)
 			_tx1($rr2)
 		EndIf	
			
wend
	
Else
	ConsoleWrite("Open Err"&@crlf)
EndIf

sleep(500)
if _closecomm1() >0 Then
;~ 	beep(4000,100)
;~ 	beep(3000,100)
;~ 	beep(2000,100)
EndIf
if _closecomm2() >0 Then
;~ 	beep(4000,100)
;~ 	beep(3000,100)
;~ 	beep(2000,100)
EndIf


func Terminate()
	if _closecomm1() >0 Then
		beep(8000,100)
		beep(6000,100)
		beep(4000,100)
	EndIf
	if _closecomm2() >0 Then
		beep(7000,100)
		beep(5000,100)
		beep(3000,100)
	EndIf
	
	exit 0
EndFunc	