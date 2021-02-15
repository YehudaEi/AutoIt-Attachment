TraySetState()
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$strComputer  = "."
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\wmi")
While 1
		$colItems = $objWMIService.ExecQuery( "SELECT * FROM MSAcpi_ThermalZoneTemperature", "WQL",$wbemFlagReturnImmediately + $wbemFlagForwardOnly)
		$Instances = $objWMIService.InstancesOf("MSAcpi_ThermalZoneTemperature")
		$Output=""

		For $objItem in $colItems
			$CurrTemp=$objItem.CurrentTemperature
			$Critical = $objItem.CriticalTripPoint
			$Output&= String(($CurrTemp - 2732) / 10 ) & "°C / Max: "& string(($Critical - 2732) / 10) & "°C"& @crlf
		Next

		If $output = "" then
			TraySetToolTip("No ACPI device found")
		Else
				TraySetToolTip($output)
		EndIf
   Sleep(5000)
WEnd

Exit

