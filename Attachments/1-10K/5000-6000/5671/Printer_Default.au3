;Specify a printer as the Default Printer
; Windows XP and 2003 ONLY

$OEvent=ObjEvent("AutoIt.Error","nothing") ; = OnError Resume Next

;Display the Default Printer
$NewDefault = "PrimoPDF"
$strComputer = "."

$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
if IsObj($objWMIService) then 
	$colPrinters = $objWMIService.ExecQuery("Select * From Win32_Printer Where Default = TRUE")
	For $Property in $colPrinters
		$DefPrinter = $Property.DeviceID
	Next
	
	;Set the Default Printer to $NewDefault
	if $DefPrinter <> $NewDefault Then
		$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
		if IsObj($objWMIService) then 
			$colInstalledPrinters =  $objWMIService.ExecQuery("Select * from Win32_Printer Where Name = '" & $NewDefault & "'")
			For $Property in $colInstalledPrinters
				$Property.SetDefaultPrinter()
			Next
		Else
			MsgBox(0, "Error", "Unable to Set the Default Printer to " & $NewDefault)
		EndIf
	EndIf
	;Verify $NewDefault is the Default Printer
	$VobjWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
	if IsObj($VobjWMIService) then 
		$VcolPrinters = $VobjWMIService.ExecQuery("Select * From Win32_Printer Where Default = TRUE")
		For $Property in $VcolPrinters
			$VerifyDef = $Property.DeviceID
		Next
		if $VerifyDef <> $NewDefault Then
			MsgBox(0, "Error", "Failed to set " & $NewDefault & " as the Default Printer" & @CRLF & @CRLF & "Please ensure " & $NewDefault & " is installed properly")
			Exit
		EndIf
	Else
		MsgBox(0, "Error", "Unable to verify " & $NewDefault & " is the Default Printer")
		Exit
	EndIf
	MsgBox(0, "Default Printer", "Your Default Printer is now set for " & $NewDefault)
	
	;listen for a print job sent to $NewDefault
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
	if IsObj($objWMIService) then 	
		$colPrintJobs = $objWMIService.ExecNotificationQuery("Select * From __InstanceCreationEvent " _ 
				& "Within 1 Where TargetInstance ISA 'Win32_PrintJob'")
		While 1
			$objPrintJob = $colPrintJobs.NextEvent
			If StringInStr($objPrintJob.TargetInstance.Name, $NewDefault) Then 
				if _WaitUntilFinished() = 1 Then ExitLoop
			EndIf
		WEnd
	Else
		MsgBox(0, "Error", "Unable to connect to PrintJob Creation Event")
		Exit
	EndIf
Else
	MsgBox(0, "Error", "Unable to determine the Default Printer")
	Exit
EndIf

$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
if IsObj($objWMIService) then
	$colInstalledPrinters =  $objWMIService.ExecQuery("Select * from Win32_Printer Where Name = '" & $DefPrinter & "'")
	For $Property in $colInstalledPrinters
		$Property.SetDefaultPrinter()
	Next
	MsgBox(0, $DefPrinter, "Your Default Printer has been reset")
	Exit
Else
	MsgBox(0, $DefPrinter, "Failed to reset your Default Printer")
	Exit
EndIf

;Function to wait until the Print Job has deleted itself
Func _WaitUntilFinished()
$DobjWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\cimv2")
if IsObj($DobjWMIService) then
	$DcolPrintJobs = $DobjWMIService.ExecNotificationQuery("Select * From __InstanceDeletionEvent Within 1 Where TargetInstance ISA 'Win32_PrintJob'")
	While 1
		$DobjPrintJob = $DcolPrintJobs.NextEvent
		If StringInStr($DobjPrintJob.TargetInstance.Name, $NewDefault) Then 
			$question = MsgBox(4, "Finished Printing ", $DobjPrintJob.TargetInstance.Document & " Has finished Printing." & @CRLF & _
			"Would you like to switch your default Printer back to " & $DefPrinter & " now?")
			;If yes then exits the previous loop this function was called from and sets the default printer back and exits the script
			;If No then the script waits for the next print job to finish and will ask this question again
			if $Question = 6 Then Return 1 
			if $Question = 7 Then Return 0
		EndIf
	WEnd
Else
	Return 1
EndIf
EndFunc