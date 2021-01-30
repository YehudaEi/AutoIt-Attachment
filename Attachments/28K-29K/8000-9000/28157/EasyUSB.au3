#include <GUIConstantsEx.au3>
#include <GUIConstants.au3>
#Include <GuiButton.au3>

#Include <Array.au3>
Global $dll = DllOpen("C:\Windows\system32\CH341DLL.DLL")

; Original C functions
;Function CH341SetOutput(iIndex:cardinal; iEnable:cardinal;iSetDirOut:cardinal;iSetDataOut:cardinal ):boolean;Stdcall; external 'CH341DLL.DLL';
;Function CH341Set_D5_D0(iIndex:cardinal; iSetDirOut:cardinal; iSetDataOut:cardinal):boolean;Stdcall; external 'CH341DLL.DLL';
;;// read inputs
;Function CH341GetInput(iIndex:cardinal; iStatus:PULONG ):boolean;Stdcall; external'CH341DLL.DLL';
;Function CH341GetStatus(iIndex:cardinal; iStatus: PULONG ): boolean; Stdcall; external'CH341DLL.DLL';

	Opt("TrayIconDebug", 0)         ;0=no info, 1=debug line info
	Opt("TrayIconHide", 1)          ;0=show, 1=hide tray icon
	Opt("TrayAutoPause",0)
	Opt("TrayMenuMode",1) 			; No default menu
	Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode

$hGUI=GUICreate("CH341 Control", 200, 200, 20, 700)
$handle=DllCall($dll, "ptr", "CH341OpenDevice","ULONG",0)



GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUICtrlCreateGroup ("Output", 5,0,150,130)
$GUICtrlStrobeBAF=GUICtrlCreateRadio("Strobe Back and Fourth", 10, 20,140,15)
$GUICtrlStrobeD8D1=GUICtrlCreateRadio("StrobeD8D1", 10, 40,140,15)
$GUICtrlStrobeD1D8=GUICtrlCreateRadio("StrobeD1D8", 10, 60,140,15)
$GUICtrlAllOn=GUICtrlCreateRadio("LED All ON", 10, 80,140,15)
$GUICtrlAllOff=GUICtrlCreateRadio("LED ALL OFF", 10, 100,140,15)
GUICtrlCreateGroup ("",-99,-99,1,1)

GUICtrlCreateGroup ("Input Buttons", 5,130,150,60)
$Button_K3 = GUICtrlCreateButton ("K3", 10,150)
$Button_K4 = GUICtrlCreateButton ("K4", 40,150)
$Button_K2 = GUICtrlCreateButton ("K2", 70,150)
$Button_K1 = GUICtrlCreateButton ("K1", 100,150)
GUICtrlCreateGroup ("",-99,-99,1,1)

$GUIState=GUISetState()
_CH341ClearOutput()

$flagK1=0
$flagK2=0
$flagK3=0
$flagK4=0

While $GUIState<>$GUI_EVENT_CLOSE

	$GUIState=GUISetState()

	If GUICtrlRead($GUICtrlStrobeBAF)=$GUI_CHECKED Then
		_CH341ClearOutput()
		_CH341StrobeBAF()
	EndIf
	If GUICtrlRead($GUICtrlStrobeD8D1)=$GUI_CHECKED Then
		_CH341ClearOutput()
		_CH341StrobeD8D1()
	EndIf
	If GUICtrlRead($GUICtrlStrobeD1D8)=$GUI_CHECKED Then
		_CH341ClearOutput()
		_CH341StrobeD1D8()
	EndIf
	If GUICtrlRead($GUICtrlAllOff)=$GUI_CHECKED Then
		_CH341ClearOutput()
	EndIf
	If GUICtrlRead($GUICtrlAllOn)=$GUI_CHECKED Then
		$data=0xFF
		_CH341SetOutput($Data)
	EndIf

	;****************GET INPUT*********************

	$input= _CH341GetInput()

	If StringTrimLeft($input,3)=1 Then  								;Button XXX1
		GUICtrlSetStyle($Button_K1,$BS_FLAT)
		$flagK1=1
	EndIf
	If StringTrimLeft($input,3)=0 and $flagK1=1 Then  					;Button XXX0
		GUICtrlSetStyle($Button_K1,$BS_PUSHLIKE)
		$flagK1=0
	EndIf
	If StringTrimRight(StringTrimLeft($input,2),1)=1 Then  				;Button XX1X
		GUICtrlSetStyle($Button_K2,$BS_FLAT)
		$flagK2=1
	EndIf
	If StringTrimRight(StringTrimLeft($input,2),1)=0 AND $flagK2=1 Then ;Button XX0X
		GUICtrlSetStyle($Button_K2,$BS_PUSHLIKE)
		$flagK2=0
	EndIf
	If StringTrimRight($input,3)=1 Then  								;Button 1XXX
		GUICtrlSetStyle($Button_K4,$BS_FLAT)
		$flagK4=1
	EndIf
	If StringTrimRight($input,3)=0 AND $flagK4=1 Then 					;Button 0XXX
		GUICtrlSetStyle($Button_K4,$BS_PUSHLIKE)
		$flagK4=0
	EndIf
	If StringTrimRight(StringTrimLeft($input,1),2)=1 Then  				;Button X1XX
		GUICtrlSetStyle($Button_K3,$BS_FLAT)
		$flagK3=1
	EndIf
	If StringTrimRight(StringTrimLeft($input,1),2)=0 AND $flagK3=1 Then ;Button X0XX
		GUICtrlSetStyle($Button_K3,$BS_PUSHLIKE)
		$flagK3=0
	EndIf

WEnd

_CH341CloseDevice()
DllClose("C:\Windows\system32\CH341DLL.DLL")

Func _CH341StrobeBAF()
	$step=0
	$data=1
	while $step<7
		$data=BitRotate($data,1,"W")
			DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT($Data))
		$step=$step+1
		sleep(150)
	Wend
	$step=0
	while $step<7
		$data=BitRotate($data,-1,"W")
			DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT($Data))
		$step=$step+1
		sleep(150)
	wend
	return
EndFunc

Func _CH341StrobeD1D8()
	$step=0
	$data=1
	while $step<8
		DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT($Data))
		$data=BitRotate($data,1,"W")
		$step=$step+1
		sleep(150)
	wend
	return
EndFunc


Func _CH341StrobeD8D1()
	$step=0
	$data=256
	while $step<8
		$data=BitRotate($data,-1,"W")
			DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT($Data))
		$step=$step+1
		sleep(150)
	wend
	return
EndFunc

Func _Exit()
  _CH341ClearOutput()
  Exit
EndFunc

Func _CH341SetOutput($Data)
	DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT($Data))
	return
EndFunc

Func _CH341ClearOutput()
	DllCall($dll, "none", "CH341SetOutput","ULONG", 0, "ULONG", 0xFF,"ULONG", 0xFF, "ULONG",BitNOT(0x00))
	return
EndFunc

;data is 'returned' in a ULONG structure in HEX.  I modify the hex value to return a binary string representation
Func _CH341GetInput()
	$tULong = DllStructCreate("ulong")
	$pULong = DllStructGetPtr($tULong)
	DllCall($dll, "none", "CH341GetInput","ULONG", 0, "ptr", $pULong)

	return _HexToBinaryString(StringTrimRight(StringTrimLeft(hex(61439-(DllStructGetData($tULong, 1,1))),5),2))	;Conv to Bin Pattern and Strip extra bits
EndFunc

Func _CH341CloseDevice()
	DllCall($dll, "ptr", "CH341CloseDevice","ULONG",0)
	return
EndFunc

; Hex To Binary
; Code stolen from ptrex autoit forums

Func _HexToBinaryString($HexValue)
    Local $Allowed = '0123456789ABCDEF'
    Local $Test,$n
    Local $Result = ''
    if $hexValue = '' then
        SetError(-2)
        Return
    EndIf

    $hexvalue = StringSplit($hexvalue,'')
    for $n = 1 to $hexValue[0]
        if not StringInStr($Allowed,$hexvalue[$n]) Then
            SetError(-1)
            return 0
        EndIf
    Next

    Local $bits = "0000|0001|0010|0011|0100|0101|0110|0111|1000|1001|1010|1011|1100|1101|1110|1111"
    $bits = stringsplit($bits,'|')
    for $n = 1 to $hexvalue[0]
        $Result &=  $bits[Dec($hexvalue[$n])+1]
    Next

    Return $Result

EndFunc
