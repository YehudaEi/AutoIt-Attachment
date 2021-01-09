Func Init()
	TCPStartup()
EndFunc
Func GetIP($C)
	Local $cmd, $ec, $Skip, $FirstLine, $Begin, $IP, $TFile, $ThirdLine, $Void, $Ret
	$IP=TCPNameToIP($C)
	If $IP="" Then
		$IP="Unknown Host"
	Else
		$Ret=Ping($C,1000)
		If $Ret=0 Then
			Switch @error
				Case 1
					$IP="Timed Out"
				Case 2
					$IP="Unreachable"
				Case 3
					$IP="Bad Destination"
				Case 4
					$IP="Error"
			EndSwitch
		EndIf
	EndIf
	Return $IP
EndFunc