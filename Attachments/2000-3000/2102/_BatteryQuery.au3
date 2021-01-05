#include-once

;======================================================
;	_BatterQuery()
;	Return information on the Battery
;	Sets @Error on error
;	Returns an array:
;		$array[0]	= ACPower(0=offline, 1=online, 255=unknown)
;		$array[1]	= BatteryFlag(1=High, 2=Low, 4=Critical,
;					  8=Charging 128=No Battery, 255=Unknown
;					  Use BitAnd to test, ie BitAnd($array[1],128)
;		$array[2]	= BatteryLife %(0-100, 255=unknown)
;		$array[3]	= Seconds left of charge, estimate(4294967295=unknown)
;======================================================
Func	_BatteryQuery()
	Local	$SystemPower,$ret,$array

	SetError(0)

;Setup $array and $SystemPower
	Dim $array[4]
	$SystemPower	= DllStructCreate("ubyte;ubyte;ubyte;ubyte;udword;udword")
	if @error Then
		SetError(-1)
		return $array
	EndIf

;make the DllCall
	$ret			= DllCall("kernel32.dll","int","GetSystemPowerStatus",_
								"ptr",DllStructPtr($SystemPower))
	if @error then	;DllCall Failed
		SetError(-2)
		DllStructFree($SystemPower)
		return $array
	EndIf

	if Not $ret[0] Then	;GetSystemPowerStatus Failed
		SetError(-3)
		DllStructFree($SystemPower)
		return $array
	EndIf

;Fill the array
	$array[0]	= DllStructGet($SystemPower,1)	;	AC
	$array[1]	= DllStructGet($SystemPower,2)	;	Battery Charge
	$array[2]	= DllStructGet($SystemPower,3)	;	Battery Charge %
	$array[3]	= DllStructGet($SystemPower,5)	;	Sec Battery Left

;free the struct
	DllStructFree($SystemPower)

	Return $array
EndFunc
