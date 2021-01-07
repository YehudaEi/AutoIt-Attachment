;This will add a network printer onto the comptuer.

$PrinterIP = "172.31.63.5"
$PrinterName = "hp deskjet 990c"
$Location = "Quality Assurance Lab"

;Add the Printer Driver
$strComputer = "."
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
if IsObj($objWMIService) then 
	$objDriver = $objWMIService.Get("Win32_PrinterDriver")
	$objWMIService.Security_.Privileges.AddAsString("SeLoadDriverPrivilege", True)
	$objDriver.Name = $PrinterName
	$objDriver.SupportedPlatform = "Windows NT x86"
	$objDriver.Version = "3"
	$objDriver.AddPrinterDriver($objDriver)
	
	;Add the Printer Port
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
	if IsObj($objWMIService) then 
		$objNewPort = $objWMIService.Get("Win32_TCPIPPrinterPort").SpawnInstance_
		$objNewPort.Name = "IP_" & $PrinterIP
		$objNewPort.Protocol = 1
		$objNewPort.HostAddress = $PrinterIP
		$objNewPort.PortNumber = "9100"
		$objNewPort.SNMPEnabled = False
		$objNewPort.Put_
		
		;Add the Printer
		$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
		if IsObj($objWMIService) then 
			$objPrinter = $objWMIService.Get("Win32_Printer").SpawnInstance_
			$objPrinter.DriverName = $PrinterName
			$objPrinter.PortName   = "IP_" & $PrinterIP
			$objPrinter.DeviceID   = $PrinterName
			$objPrinter.Location = $Location
			$objPrinter.Network = True
			$objPrinter.Shared = False
			$objPrinter.Put_

			;Set the Default Printer to the deskjet 990c
			$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
			if IsObj($objWMIService) then 
				$colInstalledPrinters =  $objWMIService.ExecQuery("Select * from Win32_Printer Where Name = '" & $PrinterName & "'")
				For $Property in $colInstalledPrinters
					$Property.SetDefaultPrinter()
				Next
			Else
				MsgBox(0, "Error", "Unable to Set the Default Printer to " & $PrinterName)
			EndIf
			;Verify $NewDefault is the Default Printer
			$VobjWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
			if IsObj($VobjWMIService) then 
				$VcolPrinters = $VobjWMIService.ExecQuery("Select * From Win32_Printer Where Default = TRUE")
				For $Property in $VcolPrinters
					$VerifyDef = $Property.DeviceID
				Next
				if $VerifyDef <> $PrinterName Then
					MsgBox(0, "Error", "Failed to set " & $PrinterName & " as the Default Printer")
					Exit
				EndIf
			Else
				MsgBox(0, "Error", "Unable to verify " & $PrinterName & " is the Default Printer")
				Exit
			EndIf
			MsgBox(0, "Default Printer", "Your Default Printer is now set for " & $PrinterName)
		EndIf
	EndIf
EndIf