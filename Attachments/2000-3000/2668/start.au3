;
; AutoIt Version: 3.1.1.35  (just needs COM support)
; Language:       English
; Platform:       Win98/2000/XP/2003  (only really know 2003 and XP but Im guessing the others work as well)
; Author:         Benjamin Caplins (caplins at yahoo dot com)
;				Special thanks to Majai, Chaos2, and the Dev's who made AutoIT
;
; Script Function:
; 		VERSION 1.1
;  Fixed a small error in the delete half written og part

;	Start this script at login with a bat file via active directory
;		Runs itself logged with certain rights gets a crap load of stuff about your computer and puts it in 
; 	an .ini file log...(the .cfo is just so people can't easily open and mess with it).  It then uploads
;	the file to a network share.  It is currently set up to make a new log every week but that can easily be 
; 	changed by changing the $logname to something that variats at a different rate.
;		In theory you could parse this information into a database and use it for many things.





; makes the system tray icon nonrespnsive to user input... i.e: they cant pasue the script or exit via system tray
Break(0)
TraySetIcon("Shell32.dll", 135)

; All you need to do to make this your own is to change the 6 global vars
;
; specifies the location of the local log, serverpath (place start.exe here), username, full domain name, password
; $logdir and $servpath must have a trailing backslash
; NOTE: The user/pass/domain above must have full access to the $serverpath location or it will not work
;  		I set up a special user that i called "script", that i granted DomainUser rights to... then on the share that
;		this is present on (in my case \\bgeserv\z) I stripped the Domain users	rights to read/execute and gave the
;		"script" user Full control...
;		The user needs read/execute access so they can start the exe and the "script" needs full access to delete/write/modify

Global $logdir = "C:\audit\"
Global $logname = "week " & Round(@YDAY / 7) & ".cfo"
Global $servpath = "\\bgeserv\z\audits\"
Global $UserName = "script"
Global $Password = "script"
Global $FullDomainName = "CAPCORP.local"

; Restarts the script once to gain admin rights
If ClipGet() <> "tr1gg3r" Then
	ClipPut( "tr1gg3r")
	RunAsSet($UserName, $FullDomainName, $Password, 2)
	Run( $servpath & "start.exe", "", @SW_HIDE)
	Exit
EndIf

; Nice long sleep so it doesnt slow the computer while the Win profile is loading
 Sleep(30000)

; dont bother running this process if there is already a log for this week
If FileExists($servpath & @ComputerName & "\" & $logname) = 1 And FileExists($logdir & $logname) = 1 Then
	traytip( "Start.exe", "Log exists already", 10, 1)
	Sleep(3500)	
	ClipPut( "already there")
	Exit
EndIf

; makes sure that the proper directores exist (only useful the first time its run really, unless the user found a way to scre it up)
DirCreate($logdir)

; hides the files from the user so they cant inadvertantly screw em up
DirCreate($servpath & @ComputerName)

RunWait( "attrib +H " & StringTrimRight($logdir, 1), "", @SW_HIDE)
RunWait( "attrib +H " & StringTrimRight($servpath, 1), "", @SW_HIDE)

; deletes in case the files got interrupted last time
FileDelete($logdir & $logname)
FileDelete($servpath & @ComputerName & "\" & $logname)

; Where the logging to a file starts
IniWrite($logdir & $logname, 'Inventoried Computer', 'ComputerName', @ComputerName)

; com stuff... dont really understand it much except that this is how it is done
; Thank Majai for this...
$objWMIService = objget ("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")

; Check For Processor
$Processor = $objWMIService.ExecQuery ("Select * from Win32_Processor")
For $objItem in $Processor
	IniWrite($logdir & $logname, "Processor Information", "Name", StringStripWS($objItem.Name, 7))
	IniWrite($logdir & $logname, "Processor Information", "Manufacturer", $objItem.Manufacturer)
	IniWrite($logdir & $logname, "Processor Information", "Description", $objItem.Description)
	IniWrite($logdir & $logname, "Processor Information", "Current ClockSpeed", $objItem.CurrentClockSpeed)
	IniWrite($logdir & $logname, "Processor Information", "Processor L2CacheSize", $objItem.L2CacheSize)
Next

; Query OS properties
$OS = $objWMIService.ExecQuery ("Select * from Win32_OperatingSystem")
For $objItem in $OS
	IniWrite($logdir & $logname, "Operating System", "Manufacturer", $objItem.Manufacturer)
	IniWrite($logdir & $logname, "Operating System", "Name", $objItem.Name)
	IniWrite($logdir & $logname, "Operating System", "ServicePackMajorVersion", $objItem.ServicePackMajorVersion)
Next

; Query Sound Device properties
$Sound = $objWMIService.ExecQuery ("Select * from Win32_SoundDevice")
For $objItem in $Sound
	IniWrite($logdir & $logname, "SoundCard Information", "Name", $objItem.Name)
	IniWrite($logdir & $logname, "SoundCard Information", "Description", $objItem.Description)
	IniWrite($logdir & $logname, "SoundCard Information", "Manufacturer", $objItem.Manufacturer)
Next

; Query video adapter properties
$Video = $objWMIService.ExecQuery ("Select * from Win32_VideoController")
For $objItem in $Video
	IniWrite($logdir & $logname, "VideoCard Information", "Name", $objItem.Name)
	IniWrite($logdir & $logname, "VideoCard Information", "Description", $objItem.Description)
	IniWrite($logdir & $logname, "VideoCard Information", "Video Processor", $objItem.VideoProcessor)
	IniWrite($logdir & $logname, "VideoCard Information", "Video Memory", (($objItem.AdapterRAM + 524288) / 1048576))
	IniWrite($logdir & $logname, "VideoCard Information", "VideoMode Description", $objItem.VideoModeDescription)
Next

; Query Bios properties
$Bios = $objWMIService.ExecQuery ("Select * from Win32_BIOS")
For $objItem in $Bios
	IniWrite($logdir & $logname, "Bios Information", "Name", $objItem.Name)
	IniWrite($logdir & $logname, "Bios Information", "Version", $objItem.Version)
	IniWrite($logdir & $logname, "Bios Information", "Status", $objItem.Status)
	IniWrite($logdir & $logname, "Bios Information", "ReleaseDate", $objItem.ReleaseDate)
	IniWrite($logdir & $logname, "Bios Information", "Manufacturer", $objItem.Manufacturer)
	IniWrite($logdir & $logname, "Bios Information", "SerialNumber", $objItem.SerialNumber)
Next

; Query DiskDrive properties
$HD = _DriveGetModel()
For $i = 1 To $HD[0]
	IniWrite($logdir & $logname, "LocalDisk Information", "Model (Physical Disk " & ($i - 1) & ")", $HD[$i])
	IniWrite($logdir & $logname, "LocalDisk Information", "Status (Physical Disk" & ($i - 1) & ")", $objItem.Status)
Next

; Enumerates fixed drives
$Fixed = DriveGetDrive( "FIXED")

For $i = 1 To $Fixed[0]
	IniWrite($logdir & $logname, "Fixed Drives", $Fixed[$i] & " (Free space)", Round(DriveSpaceFree($Fixed[$i])))
	IniWrite($logdir & $logname, "Fixed Drives", $Fixed[$i] & " (Total space)", Round(DriveSpaceTotal($Fixed[$i])))
	IniWrite($logdir & $logname, "Fixed Drives", $Fixed[$i] & " (File System)", DriveGetFileSystem($Fixed[$i]))
Next

; Enumerates optical drives
$optical = DriveGetDrive( "CDROM")
If $optical <> 1 Then
	For $i = 1 To $optical[0]
		Dim $letters
		For $i = 1 To $optical[0]
			$letters = $letters & $optical[$i] & " "
		Next
		IniWrite($logdir & $logname, "Optical Drives", "Drive Letters", $letters)
	Next
EndIf

; Enumerates network drives
$netdrives = DriveGetDrive( "NETWORK")
If $netdrives <> 1 Then
	For $i = 1 To $netdrives[0]
		IniWrite($logdir & $logname, "Network Drives", $netdrives[$i] & " (Label)", DriveGetLabel($netdrives[$i]))
	Next
EndIf

; Query Nic properties ...
$IP = $objWMIService.ExecQuery ("Select * from Win32_NetworkAdapterConfiguration where IPEnabled = true")
For $Item In $IP
		IniWrite($logdir & $logname, "NIC Information", "Description", $Item.description)
		IniWrite($logdir & $logname, "NIC Information", "MACAddress", $Item.MACAddress)
		IniWrite($logdir & $logname, "NIC Information", "DefaultGatewayIp", $Item.DefaultIPGateway (0))
		IniWrite($logdir & $logname, "NIC Information", "IpConnectionMetric", $Item.IpConnectionMetric (0))
Next

$mem = MemGetStats()
$IEVersion = RegRead('HKEY_LOCAL_MACHINE\' & 'SOFTWARE\Microsoft\Internet Explorer', 'Version')
$IEPatches = RegRead('HKEY_LOCAL_MACHINE\' & 'SOFTWARE\Microsoft\Windows\CurrentVersion\Internet Settings', 'MinorVersion')
IniWrite($logdir & $logname, 'User Information', 'UserName', @UserName)
IniWrite($logdir & $logname, 'User Information', 'MyDocuments Dir', @MyDocumentsDir)
IniWrite($logdir & $logname, 'User Information', 'Profile Dir', @UserProfileDir)
IniWrite($logdir & $logname, 'User Information', 'Desktop Dir', @DesktopDir)
IniWrite($logdir & $logname, 'User Information', 'Start Menu Dir', @StartMenuCommonDir)
IniWrite($logdir & $logname, 'User Information', 'StartUp Dir', @StartupDir)
IniWrite($logdir & $logname, 'Network Information', 'DNS Domain', @LogonDNSDomain)
IniWrite($logdir & $logname, 'Network Information', 'Logon Domain', @LogonDomain)
IniWrite($logdir & $logname, 'Network Information', 'Logon Server', @LogonServer)
IniWrite($logdir & $logname, 'Network Information', 'IPAddress', @IPAddress1)
IniWrite($logdir & $logname, 'Network Information', 'IPAddress2', @IPAddress2)
IniWrite($logdir & $logname, 'Memory Information', 'Total Physical RAM', $mem[1] & "KB")
IniWrite($logdir & $logname, 'Memory Information', 'Available physical RAM', $mem[2] & "KB")
IniWrite($logdir & $logname, 'Memory Information', 'Total Pagefile', $mem[3] & "KB")
IniWrite($logdir & $logname, 'Memory Information', 'Available Pagefile', $mem[4] & "KB")
IniWrite($logdir & $logname, 'Memory Information', 'Total virtual', $mem[5] & "KB")
IniWrite($logdir & $logname, 'Memory Information', 'Available virtual', $mem[6] & "KB")
IniWrite($logdir & $logname, 'Internet Explorer', 'IE Version', $IEVersion)
IniWrite($logdir & $logname, 'Internet Explorer', 'Update Version', $IEPatches)
IniWrite($logdir & $logname, 'Operating System', 'OS Version', @OSVersion)
IniWrite($logdir & $logname, 'Operating System', 'OS Build', @OSBuild)
IniWrite($logdir & $logname, 'Operating System', 'OS Type', @OSTYPE)
IniWrite($logdir & $logname, 'Operating System', 'Service Pack', @OSServicePack)

; Check for windows Hotfixes
$Fix = $objWMIService.ExecQuery ("Select * from Win32_QuickFixEngineering")
For $objItem in $Fix
	$Hotfix = $objItem.HotFixID
	IniWrite($logdir & $logname, "Windows HotFix", $Hotfix, $objItem.Description)
Next

; Check For windows Services
$Service = $objWMIService.ExecQuery ("Select * from Win32_Service")
For $objItem in $Service
	$SName = $objItem.Name
	IniWrite($logdir & $logname, "Windows Services", $SName, $objItem.State)
Next

_ProglistINI($logdir & $logname)

; Copies the log onto the server share
FileCopy($logdir & $logname, $servpath & @ComputerName & "\" & $logname, 1)
RunAsSet()
ClipPut("bye")

If FileExists( $servpath & @ComputerName & "\" & $logname) = 1 Then
	TrayTip( "Start.exe", "Log Uploaded", 10, 1)
	Sleep(3500)
	Exit
EndIf
If FileExists( $servpath & @ComputerName & "\" & $logname) = 0 Then
	Traytip( "Start.exe", "Log not uploaded", 10, 3)
	Sleep(3500)
EndIf
If FileExists( $logdir & $logname ) = 0 Then
	TrayTip( "Start.exe", "Log not created", 10, 3)
	Sleep(3500)
ElseIf FileExists( $logdir & $logname ) = 1 Then
	TrayTip( "Start.exe", "Log created locally", 10, 2)
	Sleep(3500)
EndIf
Exit

; Function that outputs all the installed programs to a log file of the name of your choosing
Func _ProglistINI($inifile)
	Dim $i = 1, $basekey = "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Uninstall\"
	While RegEnumKey($basekey, $i) <> ""
		Local $fullkey, $subkeyname, $name, $version, $publisher
		$fullkey = $basekey & RegEnumKey($basekey, $i)
		$subkeyname = RegEnumKey($basekey, $i)
		$name = RegRead($fullkey, "Displayname")
		$version = RegRead($fullkey, "Displayversion")
		$publisher = RegRead($fullkey, "Publisher")
		; saves space by ignoreing microsofts repetive nature
		If $publisher = "Microsoft Corporation" Then
			$publisher = ""
		EndIf
		; doesnt waste diskspace for empty values
		If $subkeyname <> "" Then
			IniWrite($inifile, "Installed Programs", $name & " (Key Name)", $subkeyname)
		EndIf
		If $version <> "" Then
			IniWrite($inifile, "Installed Programs", $name & " (Version)", $version)
		EndIf
		If $publisher <> "" Then
			IniWrite($inifile, "Installed Programs", $name & " (Publisher)", $publisher)
		EndIf
		$i = $i + 1
	WEnd
EndFunc   ;==>_ProglistINI

; A function that looks up the drive model numbers
Func _DriveGetModel()
	
	$objWMIService = objget ("winmgmts:{impersonationLevel=impersonate}!\\.\root\cimv2")
	$coldrive = $objWMIService.ExecQuery ("Select * from Win32_diskdrive")
	Local $pcinfo, $drinfo
	
	For $object in $coldrive
		$pcinfo = $pcinfo & $object.model & "|"
	Next
	
	$drinfo = StringSplit($pcinfo, "|")
	$drinfo[0] = $drinfo[0] - 1
	
	Return $drinfo
	
EndFunc   ;==>_DriveGetModel
