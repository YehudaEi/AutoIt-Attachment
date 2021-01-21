; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Author: Chaos2 
; Script Function:	output basic hardware info
;
; ----------------------------------------------------------------------------

$objWMIService = objget("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

$colSettings = $objWMIService.ExecQuery("Select * from Win32_OperatingSystem")
$colMemory = $objWMIService.ExecQuery("Select * from Win32_ComputerSystem")
$colCPU = $objWMIService.ExecQuery("Select * from CIM_Processor")
$colVideoinfo = $objWMIService.ExecQuery("Select * from Win32_VideoController")
$colSound = $objWMIService.ExecQuery("Select * from Win32_SoundDevice")
$colMouse = $objWMIService.ExecQuery("Select * from Win32_PointingDevice")
$colMonitor = $objWMIService.ExecQuery("Select * from Win32_DesktopMonitor")
$colNIC = $objWMIservice.ExecQuery("Select * from Win32_NetworkAdapter WHERE Netconnectionstatus = 2")
Dim $pcinfo


For $object in $colCPU
	$PcInfo = $pcinfo & StringStripWS($object.Name,1) & @CRLF
Next

For $objOperatingSystem in $colSettings 
    $PcInfo = $PcInfo & $objOperatingSystem.Caption & " Build " & $objOperatingSystem.BuildNumber & " Servicepack " & $objOperatingSystem.ServicePackMajorVersion & "." & $objOperatingSystem.ServicePackMinorVersion & @CRLF
    $PcInfo = $PcInfo & "Available Physical Memory: " & String(Int(Number($objOperatingSystem.FreePhysicalMemory) / 1024)) & " Mb" & @CRLF
Next

For $object in $colMemory
    $PcInfo = $PcInfo & "Total Physical Memory: " & String(Int(Number($object.TotalPhysicalMemory) / (1024 * 1024))) & " Mb" & @CRLF
Next

$objFSO = objCreate("Scripting.FileSystemObject")
$colDrives = $objFSO.Drives

$Opticaldrives = "Opticaldrives : " 

For $object in $colDrives
	If ($object.DriveType == 2) then
		$PcInfo = $PcInfo & "Total space on : " & $object.DriveLetter & ":\  (" & $object.VolumeName & ")  = " & String(Round((Number($object.TotalSize) / (1024 * 1024 * 1024)),2)) & " Gb" & @CRLF
		$PcInfo = $PcInfo & "Free space on  : " & $object.DriveLetter & ":\  (" & $object.VolumeName & ")  = " & String(Round((Number($object.FreeSpace) / (1024 * 1024 * 1024)),2)) & " Gb" & @CRLF
	Else
		$Opticaldrives = $Opticaldrives & $object.DriveLetter & ":\ "
	EndIf
Next

$PcInfo = $PcInfo & $Opticaldrives & @CRLF

For $object in $colVideoinfo
	$PcInfo = $PcInfo & "Video card: " & $object.Description & @CRLF
Next

For $object in $colSound
	$PcInfo = $PcInfo & "Sound device: " & $object.Description & @CRLF
Next

For $object in $colMouse
	$PcInfo = $PcInfo & "Mouse : " & $object.Description & @CRLF
Next

For $object in $colMonitor
	$PcInfo = $PcInfo & "Monitor : " & $object.Description & @CRLF
Next

For $object in $colNIC
	$Pcinfo = $pcinfo & $object.name & @CRLF
Next
ClipPut( $pcinfo )
MsgBox(48,"PCinfo",$PcInfo)
MsgBox( 48, "PCinfo", "Information was copied to clipboard", 5)