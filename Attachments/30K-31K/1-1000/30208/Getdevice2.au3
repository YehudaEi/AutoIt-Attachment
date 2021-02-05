HotKeySet ("{ESC}","Terminate" )

$Control = ObjCreate("ActMulti.ActMLEasyIF") ;Create MX Control object for PLC (Melsoft MX-Change Software for Mitsubishi PLC)
If @error then Exit

while not @error                             ;Main loop
	$Contact=GetDevice(1,"M7000")
	MsgBox(0,"Result:",$Contact)
	If $Contact = -1 then ExitLoop
	sleep(1000)
WEnd

func GetDevice($Logical_station,$device)
	dim $ReturnData=-1			              ; Default value of PLC contact (Error state)
	With $control
		.ActLogicalStationNumber =$Logical_station    ; Set PLC communication mode
		.Open()					   			            ; Open control
		.GetDevice($device, $ReturnData)              ; [Error Code] = GetDevice ([PLC device name] , [Return Value])  <-- !!! The return value is not coming !!! Why?
        .Close()					      ; Close control
	EndWith
	Return $ReturnData
EndFunc

Func Terminate()
	 Exit
EndFunc