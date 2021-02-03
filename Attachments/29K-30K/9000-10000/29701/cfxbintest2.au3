#cs
	cfxbintest2.au3 
	serial functions using cfxbin udf
	V2.0 
	Uwe Lahni 2010
#ce

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseAnsi=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include "cfxbin.au3"
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
global $CRC=0

$rb=""  
$Form = GUICreate("Test script for cfxbin", 600, 400, 100, 100)
$bSend = GUICtrlCreateButton("Send", 120, 340, 75, 25, 0)
$bend=GUICtrlCreateButton("End", 220, 340, 75, 25, 0)
$ToSend = GUICtrlCreateInput("AT&v", 40, 40, 520, 21)
$Received=GUICtrlCreateEdit("", 40, 80, 520, 240,$WS_VSCROLL)
GUISetState(@SW_SHOW)
if _opencomm("\\.\COM1",9600,0,8,1)>0 Then
 	beep(2000,100)
 	beep(3000,100)
 	beep(4000,100)
	AdlibEnable("poll",2000)
	$z=timerinit()
;	_setcomm(2400,0,8,1)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $bEnd
				ExitLoop
			Case $bSend
				$message =GUICtrlRead($ToSend)
;				$bcc=getbcc($message & $ETX)
;				_tx($STX & $message & $ETX & $bcc)
				_tx($message & @CRLF)
		EndSwitch

		_receive()
		if $RXLEN>=10 Then
;			$rb=c2s(_rx())
;			$rb&=c2s(_rx())&@CRLF
			$rb&=_rx()
			GUICtrlSetData($Received,$rb)
		EndIf	

	WEnd
EndIf
sleep(500)
AdlibDisable()
if _closecomm() >0 Then
 	beep(4000,100)
 	beep(3000,100)
 	beep(2000,100)
EndIf

func poll()
	$l="atz" & @CRLF
;	$l="a"& chr(2) 
;	$l=$l & "S5030500"
;	$l=$l & GUICtrlRead($ToSend)
;	$l=$l & hex(getcrc($l),2)
;	$l=$l&chr(3)
	_tx($l)
EndFunc

func getbcc($t)
	Dim $bcc =0
	Dim $i =0
	For $i = 1 To StringLen($t)
		$b = StringMid($t, $i, 1)
		$bcc =  BitXOR (Asc($b),$bcc)
	Next 
	Return Chr($bcc)
EndFunc

func getcrc($t)
$hurz=crc8(-1)
for $i=1 to stringlen($t)
	$ccrc=crc8(asc(stringmid($t,$i,1)))
Next
return $ccrc
EndFunc

func crc8($x)
	if $x>255 or $x<-1 then return(0)
	if $x=-1 then 
		$CRC=0
		return(0)
	EndIf
$shift=$x
for $i=1 to 8
	$carry=bitand(Bitxor($shift,$CRC),1)
	$CRC=bitshift($CRC,1)
	if $carry<>0 then $CRC=bitxor($CRC,0x8c)
	$shift=bitshift($shift,1)
Next	
return ($CRC)
EndFunc