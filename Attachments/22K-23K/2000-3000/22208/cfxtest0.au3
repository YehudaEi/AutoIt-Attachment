#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "cfx.au3"


if _opencomm()>0 Then
	beep(2000,100)
	beep(3000,100)
	beep(4000,100)

	_tx("ATZ"& @CRLF)
	sleep(200)
	$rr=_rxwait(9,2000)
	$rrr=_rx()
	ConsoleWrite("_rx()=" & $rrr & @CRLF)

EndIf

sleep(2000)
if _closecomm() >0 Then
	beep(4000,100)
	beep(3000,100)
	beep(2000,100)
EndIf

