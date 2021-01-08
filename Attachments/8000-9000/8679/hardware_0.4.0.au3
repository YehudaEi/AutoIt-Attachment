#Include <Array.au3>
#include <Constants.au3>
#Include <Date.au3>
#include <File.au3>
#include <GuiListView.au3>
#include <GuiList.au3>
#NoTrayIcon
FileInstall("E:\Projects\Usefull\devcon32.exe", @TempDir & "\devcon32.exe")
FileInstall("E:\Projects\Usefull\devcon64.exe", @TempDir & "\devcon64.exe")
FileInstall("E:\Projects\Usefull\7z.exe", @TempDir & "\7z.exe")
Global $DevconLastLine, $DevconOutput, $RemoveDevice, $Total_Nr_Devices, $file_log, $RemovingOutput
Global $output, $DirOutputOnce, $DirRemoveSplit, $HKLM
Global $setting_check, $checkdrivers, $driversigningoff, $driversigningon, $DeviceDrivers, $RemoveHardware, $DetectHardware
Global $DriverSearching[10], $SaveValue[10], $button[20]
Global $radio[8], $label[10], $check[16], $status[5]
Global $label[100], $button[20], $tab[10], $group[10]
Global $Unknown_Nr_Devices = "0", $Total_Nr_Devices = "0"
Global $ErrorIsThere = "No"
Dim $devcon, $drivers
Dim $version = "0.4.1", $autor = "MadBoy / AutoIt Owns"
Dim $tag = "Hardware Installer"
Global $log_file = @ScriptDir & "\hardware.log"
Dim $devcon32 = @TempDir & "\devcon32.exe"
Dim $devcon64 = @TempDir & "\devcon64.exe"
Dim $7zip = @TempDir & "\7z.exe"
Global $settings = @ScriptDir & "\hardware.ini"
Global $start = IniRead($settings, "INFO", "start", "")
Global $mode = IniRead($settings, "INFO", "mode", "")
Global $unattended_cd = IniRead($settings, "INFO", "unattended_cd", "")
Global $drivers_drive = IniRead($settings, "INFO", "drivers_drive", "")
Global $drivers_dir = IniRead($settings, "INFO", "drivers_dir", "")
Global $device_manager = IniRead($settings, "INFO", "device_manager", "")
Global $method = IniRead($settings, "INFO", "method","")
Global $logging_to_file = IniRead($settings, "INFO", "logging_to_file", "")
Global $logging_option = IniRead($settings, "INFO", "logging_option", "")
Global $drivers_packed = IniRead($settings, "INFO", "drivers_packed", "")
Global $copy_drivers = IniRead($settings, "INFO", "copy_drivers", "")
Global $copy_where = IniRead($settings, "INFO", "copy_where", "")
Global $delete_drivers = IniRead($settings, "INFO", "delete_drivers", "")
Global $create_backup = IniRead($settings, "INFO", "create_backup", "")
Global $leave_registry_entries = IniRead($settings, "INFO", "leave_registry_entries", "")
;==================================================================
; VARIABLES FOR GUI
;==================================================================
Dim $position1 = 5, $position2 = 10; First "check"
Dim $position3 = 310, $position5 = 5, $position6 = 30
Dim $position10 = 90, $position11 = 320; Autor's positioning
Dim $lenght1 = 300, $height1 = 15
Dim $lenght2 = 399, $height2 = 50
Global $label[100]
Global $button[4]

If WinExists($tag) Then
	;MsgBox(0, "Already Running", "Hardware Installer has already been launched.")
	Exit; It's already running
EndIf

;===========================================
;=============== CODE ======================
;===========================================
;===========================================
SettingCheck()
LogToFile()
_AddLogToFile("=================== Log Start: " & @ComputerName )

;===========================================

If $mode = "unattended" Then
	; HELP WINDOW WHEN NO COMMAND LINE
	If $cmdline[0] = 0 Then 
		    MsgBox(64, "Hardware Installer ver. " & $version, "Read manual for use of command line when in unattended cd mode.")
            Exit
	EndIf
	; DEFAULT VALUES RESET THRU COMMAND LINE	
	If $cmdline[0] = 1 AND $cmdline[1] = "DEFAULT" Then
		    SetDevicePathDefault()
			DriverSigning("On")
	EndIf
	; INSTALL THRU COMMAND LINE	
	If $cmdline[0] = 1 AND $cmdline[1] = "INSTALL" Then		
	SettingCheck()
	DriverSigning("Off")
	CheckDriversPaths()
	DeviceDrivers($drivers)
	EndIf
EndIF

If $mode = "test" Then
Opt("GUICoordMode", 1)
$gui_Main = GUICreate($tag, 450,450)
; START - MENU GORNE
$Menu_Help = GUICtrlCreateMenu('&Help')
$Menu_About = GUICtrlCreateMenuItem('&About', $Menu_Help)
GUICtrlCreateLabel('', 0, 0, 450, 2, $SS_SUNKEN)
; KONIEC - MENU - GORNE

; START - 
$group[1]= GUICtrlCreateGroup ("Status", 5, 5, 440, 50)
GUIStartGroup()

$Label[1]= GUICtrlCreateLabel ("Unknown devices in system: ", 10, 25, 135, 20)
$Label[2]= GUICtrlCreateLabel ("Total number of devices detected:", 220, 25,165, 20)
$Label[3]= GUICtrlCreateLabel ("Checking..", 146, 25, 50, 20)
$Label[4]= GUICtrlCreateLabel ("Checking..", 385, 25, 55, 20)
$Label[5]= GUICtrlCreateLabel('', 7, 210, 437, 2, $SS_SUNKEN)
$Label[6]= GUICtrlCreateLabel(' Log Window', 12, 204, 67, 20)
GUIStartGroup()
$ulist = GUICtrlCreateListView("Nr|Device ID|Device Name|Problem ID", 5, 60, 440, 135, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES))
GUICtrlSetResizing($ulist, $GUI_DOCKALL)
_GUICtrlListViewSetColumnWidth ($ulist, 0, 30)
_GUICtrlListViewSetColumnWidth ($ulist, 1, 145)
_GUICtrlListViewSetColumnWidth ($ulist, 2, 196)
_GUICtrlListViewSetColumnWidth ($ulist, 3, 65)

$LogBox = GuiCtrlCreateList("", 5, 220, 440, 150,BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_DISABLENOSCROLL))
_AddLineBox("Starting program on " & @ComputerName & ".")

; START - GUI O PROGRAMIE
$Gui_about = GUICreate('Help', 300, 120, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), -1, $Gui_Main)
GUICtrlCreateLabel($tag & ' version ' & $version & @LF & @LF & _
		'Program was written to easly install drivers for unknown devices in after-setup stage (within Windows).', 5, 5, 290, 90)
$About_ContactLabel = GUICtrlCreateLabel('Contact Author - ', 5, 100, 95, 15)
GUICtrlSetFont(-1, 9, 400, 0)
GUICtrlSetCursor(-1, 0)
$About_ContactAuthor = GUICtrlCreateLabel('MadBoy / AutoIt Owns', 100, 100, 120, 15)
GUICtrlSetFont(-1, 9, 400, 4)
GUICtrlSetColor(-1, 0x0000ff)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, 'pklys@cdrinfo.pl')
$About_Close = GUICtrlCreateButton('&Close', 220, 90, 75, 25)
; END - GUI O PROGRAMIE
GUISetState(@SW_SHOW, $gui_Main)
;======== REAL CODE START =========
If $ErrorIsThere = "No" Then DetectInfrastructure()
If $ErrorIsThere = "No" Then DetectUnknownDevices()
CheckDriversPaths()

	
If $start = "Manual" Then
	$button[1] = GUICtrlCreateButton ("Clear log", 10, 400, 110, 20)
	$button[2] = GUICtrlCreateButton ("Refresh", 130, 400, 110, 20)
	$button[3] = GUICtrlCreateButton ("Remove and Rescan", 250, 400, 110, 20)
	_AddLineBox("Manual start used - Waiting for orders.")
	While 1 
	    $msg = GUIGetMsg()
        Select
		    Case $msg = $GUI_EVENT_CLOSE
				CleanUp()
				Exit
			Case $msg = $Menu_About
				GUISetState(@SW_SHOW, $gui_About)
			Case $msg = $About_Close
				GUISetState(@SW_HIDE, $gui_About)
			Case $msg = $button[1]
				 GUICtrlSetData($LogBox,"")
			Case $msg = $button[2]
				 DetectUnknownDevices()
			Case $msg = $button[3]
				 RemoveUnknownHardware()
		 EndSelect
	Wend
EndIf
EndIf


If $mode = "standard" Then
Opt("GUICoordMode", 1)
$gui_Main = GUICreate($tag, 450,450)
; START - MENU GORNE
$Menu_Help = GUICtrlCreateMenu('&Help')
$Menu_About = GUICtrlCreateMenuItem('&About', $Menu_Help)
GUICtrlCreateLabel('', 0, 0, 450, 2, $SS_SUNKEN)
; KONIEC - MENU - GORNE

; START - 
$group[1]= GUICtrlCreateGroup ("Status", 5, 5, 440, 50)
GUIStartGroup()

$Label[1]= GUICtrlCreateLabel ("Unknown devices in system: ", 10, 25, 135, 20)
$Label[2]= GUICtrlCreateLabel ("Total number of devices detected:", 220, 25,165, 20)
$Label[3]= GUICtrlCreateLabel ("Checking..", 146, 25, 50, 20)
$Label[4]= GUICtrlCreateLabel ("Checking..", 385, 25, 55, 20)
$Label[5]= GUICtrlCreateLabel('', 7, 210, 437, 2, $SS_SUNKEN)
$Label[6]= GUICtrlCreateLabel(' Log Window', 12, 204, 67, 20)
GUIStartGroup()
$ulist = GUICtrlCreateListView("Nr|Device ID|Device Name|Problem ID", 5, 60, 440, 135, BitOR($LVS_NOSORTHEADER, $LVS_REPORT, $LVS_SHOWSELALWAYS), BitOR($LVS_EX_FULLROWSELECT, $LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES))
GUICtrlSetResizing($ulist, $GUI_DOCKALL)
_GUICtrlListViewSetColumnWidth ($ulist, 0, 30)
_GUICtrlListViewSetColumnWidth ($ulist, 1, 145)
_GUICtrlListViewSetColumnWidth ($ulist, 2, 196)
_GUICtrlListViewSetColumnWidth ($ulist, 3, 65)

$LogBox = GuiCtrlCreateList("", 5, 220, 440, 150,BitOR($WS_BORDER, $WS_VSCROLL, $LBS_NOTIFY,$LBS_DISABLENOSCROLL))
_AddLineBox("Starting program on " & @ComputerName & ".")

; START - GUI O PROGRAMIE
$Gui_about = GUICreate('Help', 300, 120, -1, -1, BitOR($WS_CAPTION, $WS_SYSMENU), -1, $Gui_Main)
GUICtrlCreateLabel($tag & ' version ' & $version & @LF & @LF & _
		'Program was written to easly install drivers for unknown devices in after-setup stage (within Windows).', 5, 5, 290, 90)
$About_ContactLabel = GUICtrlCreateLabel('Contact Author - ', 5, 100, 95, 15)
GUICtrlSetFont(-1, 9, 400, 0)
GUICtrlSetCursor(-1, 0)
$About_ContactAuthor = GUICtrlCreateLabel('MadBoy / MSFN.ORG', 100, 100, 120, 15)
GUICtrlSetFont(-1, 9, 400, 4)
GUICtrlSetColor(-1, 0x0000ff)
GUICtrlSetCursor(-1, 0)
GUICtrlSetTip(-1, 'pklys@cdrinfo.pl')
$About_Close = GUICtrlCreateButton('&Close', 220, 90, 75, 25)
; END - GUI O PROGRAMIE
GUISetState(@SW_SHOW, $gui_Main)
;======== REAL CODE START =========
If $ErrorIsThere = "No" Then DetectInfrastructure()
CheckDriversPaths()
DetectUnknownDevices()


If $start = "Automatic" Then
	_AddLineBox("Automatic start used - GoGoGo..")
	If $ErrorIsThere = "Yes" AND $Unknown_Nr_Devices = "0" Then _AddLineBox("All devices have drivers. There's no need to start program.")
	If $ErrorIsThere = "No" Then DirectoryCreation()
	If $ErrorIsThere = "No" Then CopyDrivers($drivers)
	If $ErrorIsThere = "No" Then PackedDrivers($drivers)
	If $ErrorIsThere = "No" Then DriversBackup()
	If $ErrorIsThere = "No" Then DriverSearching("START")
	If $ErrorIsThere = "No" Then DriverSigning("Off")
	If $ErrorIsThere = "No" Then 
		If $copy_drivers = "Yes" Then DeviceDrivers($copy_where)
	EndIf
	If $ErrorIsThere = "No" Then 	
		If $copy_drivers = "No" Then DeviceDrivers($drivers)
	EndIf
	If $ErrorIsThere = "No" Then RemoveUnknownHardware()
	If $ErrorIsThere = "No" Then DetectPlugAndPlay()
	While 1 
	    $msg = GUIGetMsg()
        Select
		    Case $msg = $GUI_EVENT_CLOSE
				CleanUp()
				Exit
			Case $msg = $Menu_About
				GUISetState(@SW_SHOW, $gui_About)
			Case $msg = $About_Close
				GUISetState(@SW_HIDE, $gui_About)
		EndSelect
	WEnd
EndIf

If $start = "Manual" Then
	$button[1] = GUICtrlCreateButton ("Clear log", 10, 400, 110, 20)
	$button[2] = GUICtrlCreateButton ("Refresh", 130, 400, 110, 20)
	$button[3] = GUICtrlCreateButton ("Remove and Rescan", 250, 400, 110, 20)
	_AddLineBox("Manual start used - Waiting for orders.")
	While 1 
	    $msg = GUIGetMsg()
        Select
		    Case $msg = $GUI_EVENT_CLOSE
				CleanUp()
				Exit
			Case $msg = $Menu_About
				GUISetState(@SW_SHOW, $gui_About)
			Case $msg = $About_Close
				GUISetState(@SW_HIDE, $gui_About)
			Case $msg = $button[1]
				 GUICtrlSetData($LogBox,"")
			Case $msg = $button[2]
				 DetectUnknownDevices()
			 Case $msg = $button[3]
				 If $ErrorIsThere = "Yes" AND $Unknown_Nr_Devices = "0" Then _AddLineBox("All devices have drivers. There's no need to start program.")
				 If $ErrorIsThere = "No" Then DirectoryCreation()
				 If $ErrorIsThere = "No" Then CopyDrivers($drivers)
				 If $ErrorIsThere = "No" Then PackedDrivers($drivers)
				 If $ErrorIsThere = "No" Then DriversBackup()
				 If $ErrorIsThere = "No" Then DriverSearching("START")
				 If $ErrorIsThere = "No" Then DriverSigning("Off")
				 If $ErrorIsThere = "No" Then 
						If $copy_drivers = "Yes" Then DeviceDrivers($copy_where)
				 EndIf
				 If $ErrorIsThere = "No" Then 	
						If $copy_drivers = "No" Then DeviceDrivers($drivers)
				 EndIf
				 If $ErrorIsThere = "No" Then RemoveUnknownHardware()
				 If $ErrorIsThere = "No" Then DetectPlugAndPlay()
		 EndSelect
	Wend
EndIf
 
EndIf


;=================================== NOTHING TO CHECK BELOW ========================
Func LogToFile()
	If $logging_to_file = "Yes" Then
	   If FileExists( $log_file ) Then
		  If FileOpen ( $log_file, 1 ) <> -1 Then
			  
		  Else 
			_FileCreate ( "C:\hardware.log" )
			Global $log_file = "C:\hardware.log"
		  EndIf
			$file_log = FileOpen($log_file,1)
			If $file_log = -1 Then
				MsgBox(0, "Error 1", "Unable to open " & $log_file & ". Fix permissions or Turn Off logging to file and try again. Terminating.")
				Exit
			EndIf
	   Else
			If _FileCreate ( $log_file ) = 0 Then
			   _FileCreate ( "C:\hardware.log" )
			   Global $log_file = "C:\hardware.log"
			EndIf
			$file_log = FileOpen($log_file,1)
			If $file_log = -1 Then
				MsgBox(0, "Error 1", "Unable to open " & $log_file & ". Fix permissions or Turn Off logging to file and try again. Terminating.")
				Exit
			EndIf
		EndIf
	EndIf
	$ErrorIsThere = "No"
EndFunc

Func _AddLogToFile($Text)
	If $logging_to_file = "Yes" Then
		$file_log = FileOpen($log_file,1)
		FileWriteLine($file_log, "["& _NowTime(5) & "] - " & $Text & @CRLF)
		FileClose ( $file_log )
	EndIf
EndFunc

Func _AddLineBox($Text)
	GuiCtrlSetData($LogBox,"["& _NowTime(5) & "] - " & $Text & "|")
	_GUICtrlListSelectIndex($LogBox, _GUICtrlListCount($LogBox)-1)
	_AddLogToFile($Text)
EndFunc

Func Language($choosen_language)
	 If $choosen_language = "ENG" Then
		
     EndIf
	 If $choosen_language = "PL" Then
		
	 EndIf
EndFunc

Func DetectInfrastructure()
	If @OSType = "WIN32_WINDOWS" Then
	;If @OSType = "WIN32_NT" Then
	   _AddLineBox("Unsupported Windows version. Use only on 2000/XP/2003 x32/64.")
	   $ErrorIsThere = "Yes"
	Else
		If @ProcessorArch = "X86" Then
			$HKLM = "HKEY_LOCAL_MACHINE"
			$devcon = $devcon32
			If @OSVersion = "WIN_XP" Then _AddLineBox("Detecting Windows version - Windows XP x32")
			If @OSVersion = "WIN_2000" Then _AddLineBox("Detecting Windows version - Windows 2000 x32")
			If @OSVersion = "WIN_2003" Then _AddLineBox("Detecting Windows version - Windows 2003 x32")
		EndIf
		If @ProcessorArch = "X64" Then 
			$HKLM = "HKEY_LOCAL_MACHINE64"
			$devcon = $devcon64
			If @OSVersion = "WIN_XP" Then _AddLineBox("Detecting Windows version - Windows XP x64")
			If @OSVersion = "WIN_2000" Then _AddLineBox("Detecting Windows version - Windows 2000 x64")
			If @OSVersion = "WIN_2003" Then _AddLineBox("Detecting Windows version - Windows 2003 x64")
		EndIf
	EndIf
EndFunc

Func DirectoryCreation()
	If $copy_drivers = "Yes" AND $copy_where <> "" Then
	_AddLineBox("Checking for directory where drivers will be copied.")
		If FileExists ( $copy_where ) = 0 Then
			If DirCreate( $copy_where ) = 0 Then
				_AddLineBox("Problem creating directory " & $copy_where & ". Terminating!")
				$ErrorIsThere = "Yes"
			Else
				_AddLineBox("Directory (" & $copy_where & ") created successfully.")
			EndIf
		ElseIf FileExists ( $copy_where ) = 1 Then
			_AddLineBox("Directory (" & $copy_where & ") already exists. Using it.")
		EndIf
	EndIf	
EndFunc

Func PackedDrivers($path_to_drivers)
	; Rar support
	If $drivers_packed = "RAR" AND $copy_drivers = "Yes" Then
		_AddLineBox("Searching for rar archives in " & $path_to_drivers)
		$rar_search = FileFindFirstFile($path_to_drivers & "\*.rar")
		If $rar_search = -1 Then
			_AddLineBox("There are no rar archives in " & $path_to_drivers)
			$ErrorIsThere = "Yes"
		EndIf
		While 1
			$rar_file = FileFindNextFile($rar_search) 
			If @error Then ExitLoop
			_AddLineBox("Unpacking drivers from " & $path_to_drivers & "\" & $rar_file)
			$rar_unpack = $7zip & " x -o- -y " & $path_to_drivers & "\" & $rar_file & " " & $copy_where
			RunWait(@ComSpec & " /c " & $rar_unpack, "", @SW_HIDE)
		WEnd
		FileClose($rar_search)
	ElseIf $drivers_packed = "RAR" AND $copy_drivers <> "Yes" Then
		_AddLineBox("Wrong settings for drivers_packed and copy_drivers in .ini file. Terminating!")
		$ErrorIsThere = "Yes"
	EndIf
	; 7zip support
	If $drivers_packed = "7ZIP" AND $copy_drivers = "Yes" Then
		_AddLineBox("Searching for 7zip archives in " & $path_to_drivers)
		$7zip_search = FileFindFirstFile($path_to_drivers & "\*.7z")
		If $7zip_search = -1 Then
			_AddLineBox("There are no 7zip archives in " & $path_to_drivers)
			$ErrorIsThere = "Yes"
		EndIf
		While 1
			$7zip_file = FileFindNextFile($7zip_search) 
			If @error Then ExitLoop
			_AddLineBox("Unpacking drivers from " & $path_to_drivers & "\" & $7zip_file)
			$7zip_unpack = $7zip & " x -y -aos " & $path_to_drivers & "\" & $7zip_file & " -o" & $copy_where
			RunWait(@ComSpec & " /c " & $7zip_unpack, "", @SW_HIDE)
		WEnd
		FileClose($7zip_search)
	ElseIf $drivers_packed = "7ZIP" AND $copy_drivers <> "Yes" Then
		_AddLineBox("Wrong settings for drivers_packed and copy_drivers in .ini file. Terminating!")
		$ErrorIsThere = "Yes"
	EndIf
	If $drivers_packed <> "No" AND $ErrorIsThere <> "Yes" Then
		_AddLineBox("Unpacking completed successfully.")
	EndIf
EndFunc

Func DriversBackup()
	If $create_backup = "Yes" Then
	_AddLineBox("Backup of drivers was started. Please wait!")
	$today_date_time = StringReplace( _Now(), " ", "_")
	$today_date_time = StringReplace($today_date_time, ":","_")
	$7zip_pack = $7zip & ' a -tzip ' & '"C:\backup_drivers-' & $today_date_time & '.zip" "' & @WindowsDir & '\inf\*"'
	MsgBox(1, "dupa", $7zip_pack)
	RunWait(@ComSpec & " /c " & $7zip_pack, "",@SW_HIDE)
	_AddLineBox("Backup of drivers is done.")
	EndIf
EndFunc

Func CopyDrivers($path_to_drivers)
	If $copy_drivers = "Yes" AND FileExists($copy_where) = 1  AND $drivers_packed = "No" Then
	    _AddLineBox("Copying drivers from " & $path_to_drivers & " to " & $copy_where & ". Please wait!")
		DirCopy ( $path_to_drivers, $copy_where, 1 )
		_AddLineBox("Copy process is done.")
	EndIf
EndFunc

Func IniCreate()
	IniWrite ( "hardware.ini", "INFO", "Start", "Manual" ) ; Manual/Auto
	IniWrite ( "hardware.ini", "INFO", "Mode", "Standard" ) ; Standard/Unattended/CommandLine
	IniWrite ( "hardware.ini", "INFO", "Drivers_drive", "CHANGE THIS" ) ; CDROM/REMOVABLE or simply drive letter
	IniWrite ( "hardware.ini", "INFO", "Drivers_dir", "CHANGE THIS" ) ; \Drivers or other dir with \
	IniWrite ( "hardware.ini", "INFO", "Device_manager", "On") ; On/Off
	IniWrite ( "hardware.ini", "INFO", "Method", "RegistryDevicePath") ; RegistryDevicePath (4096 chars max)/SetupCopyOemInf
	IniWrite ( "hardware.ini", "INFO", "Logging_to_file", "Yes") ; Yes/No
	IniWrite ( "hardware.ini", "INFO", "Logging_option", "Simple") ; Simple/Full - full might be slower but usefull for debugging.
	IniWrite ( "hardware.ini", "INFO", "Drivers_Packed", "No") ; Rar/7zip/No
	IniWrite ( "hardware.ini", "INFO", "Copy_drivers", "No") ; Yes/No
	IniWrite ( "hardware.ini", "INFO", "Copy_where", "C:\Drivers") ; Path where to copy drivers - a must to set for Packed Drivers
	IniWrite ( "hardware.ini", "INFO", "Delete_drivers", "No") ; Yes/No - do you want to delete drivers on program close.
	IniWrite ( "hardware.ini", "INFO", "Create_backup", "No")
	IniWrite ( "hardware.ini", "INFO", "Leave_registry_entries", "No")
EndFunc

Func SettingCheck()
	If FileExists ( @ScriptDir & "\hardware.ini" ) = 0 Then
		MsgBox(0, "Information", "Configuration file (hardware.ini) doesn't exist in " & @ScriptDir & @CRLF & "Program will create default hardware.ini file in program directory." & @CRLF & "Make sure to modify it for your needs before starting this application again.")
		IniCreate()
		$setting_check = "FAILED"
		Exit
	Else
		$setting_check = "PASSED"
	EndIf
	If $unattended_cd = "CHANGE THIS" OR $Drivers_drive = "CHANGE THIS" OR $Drivers_dir = "CHANGE THIS" Then
		MsgBox(0, "Information", "Configuration file hardware.ini has default settings. Terminating!")
		Exit
	EndIf
	If $method = "SetupCopyOemInf" OR $method = "RegistryDevicePath" Then
	
	Else
		MsgBox(0, "Information", "Method must be set: SetupCopyOemInf or RegistryDevicePath. Terminating!")
		Exit
	EndIf
EndFunc

Func CheckDriversPaths() ; Output $drivers 
_AddLineBox("Checking for drivers directory existance.")
If $drivers_drive = "CDROM" OR $drivers_drive = "REMOVABLE" Then
   $ErrorIsThere = "Yes"
   $drivers_drive = DriveGetDrive( $drivers_drive )
   If NOT @error Then
   For $i = 1 to $drivers_drive[0]
	  If DriveGetFileSystem ( $drivers_drive[$i] ) <> "1" Then
		;MsgBox(1,1, $drivers_drive[$i] )
		If FileExists($drivers_drive[$i] & $drivers_dir) Then
			$drivers = $drivers_drive[$i] & $drivers_dir
			_AddLineBox("Drivers directory (" & $drivers & ") exist.")
			$checkdrivers = "PASSED"
			$ErrorIsThere = "No"
		    ExitLoop
        EndIf
	  EndIf
   Next
   If $ErrorIsThere = "Yes" Then
      _AddLineBox("Can't find drivers dir specified in hardware.ini. Make sure it exists")
   EndIf
  
	
EndIf
ElseIf $drivers_drive = "" Then
       MsgBox( 0, "Information", "You haven't specified any drive where drivers are located. Terminating!" )
	   $checkdrivers = "FAILED"
       ;Exit
Else
	   If FileExists($drivers_drive & ":" & $drivers_dir) Then
			$drivers = $drivers_drive & ":" & $drivers_dir
			_AddLineBox("Drivers directory (" & $drivers & ") exist.")
			$checkdrivers = "PASSED"
	   Else
			$drivers = $drivers_drive & ":" & $drivers_dir
			MsgBox( 0, "Information", "Path specified in config file doesn't exist (" & $drivers & "). Terminating!" )
			$checkdrivers = "FAILED"
	   EndIf
EndIf

EndFunc

Func DeviceDrivers($path_to_drivers)
	If $method = "RegistryDevicePath" Then
		_AddLineBox("Setting path into registry using RegistryDevicePath method.")
		; Resets DevicePath to DEFAULT
		RegWrite($HKLM & "\SOFTWARE\Microsoft\Windows\CurrentVersion", "DevicePath", "REG_EXPAND_SZ", "%SystemRoot%\inf;")
		$DirOutput = Run(@ComSpec & " /c DIR /A:D /S " & $path_to_drivers, '', @SW_HIDE, 2)
		While 1
			$DirData = StdoutRead($DirOutput)
			If @error Then ExitLoop
			If $DirData Then
				$DirOutputOnce &= $DirData
			Else
				Sleep(10)
			EndIf
		WEnd
		; Remove spaces from output
		$DirOutputOnce = StringStripWS($DirOutputOnce, 3)
		; Split output into array
		$DirSplit = StringSplit($DirOutputOnce, @CRLF,1)
		For $i = 1 To $DirSplit[0]
			If StringInStr($DirSplit[$i], $path_to_drivers) Then
				$registrystring = StringSplit($DirSplit[$i], ": ",1)
				If $registrystring[0] = 2 Then ; Testing amount of elements in array, if more then 2 Exits
					If StringInStr($registrystring[2], $path_to_drivers) Then ; Making sure that Drivers path exists in string
						$drivers_directory = $registrystring[2]
						$search_ini = $drivers_directory & "\*.inf"
						If FileFindFirstFile($search_ini) <> -1 Then
							$registryadd = $drivers_directory & ";"
							;Add things into registry
							$oldkey = RegRead($HKLM & "\SOFTWARE\Microsoft\Windows\CurrentVersion", "DevicePath")
							$newkey = RegWrite($HKLM & "\SOFTWARE\Microsoft\Windows\CurrentVersion", "DevicePath", "REG_EXPAND_SZ", $oldkey & $registryadd)   
							If $logging_option = "Advanced" Then
								_AddLineBox("Added to registry: " & $drivers_directory)
							EndIF						
						EndIF
					EndIf
				EndIf
			EndIf
		Next
		$DeviceDrivers = "PASSED"
		_AddLineBox("Drivers path was set successfully into registry.")
	EndIf
	If $method = "SetupCopyOemInf" Then
		_AddLineBox("Integrating drivers with SetupCopyOemInf method.")
		; Removes all Unknown devices from system and gets output		
		$DirOutput = Run(@ComSpec & " /c DIR /A:D /S " & $path_to_drivers, '', @SW_HIDE, 2)
		While 1
			$DirData = StdoutRead($DirOutput)
			If @error Then ExitLoop
			If $DirData Then
				$DirOutputOnce &= $DirData
			Else
				Sleep(10)
			EndIf
		WEnd
		; Remove spaces from output
		$DirOutputOnce = StringStripWS($DirOutputOnce, 3)
		; Split output into array
		$DirSplit = StringSplit($DirOutputOnce, @CRLF,1)
		$NrCopiedInfs = 0
		For $i = 1 To $DirSplit[0]
			If StringInStr($DirSplit[$i], $path_to_drivers) Then
				$registrystring = StringSplit($DirSplit[$i], ": ",1)
				If $registrystring[0] = 2 Then ; Testing amount of elements in array, if more then 2 Exits
					If StringInStr($registrystring[2], $path_to_drivers) Then ; Making sure that Drivers path exists in string
						$drivers_directory = $registrystring[2]
						
						$search_ini = FileFindFirstFile($drivers_directory & "\*.inf")
						If $search_ini = -1 Then
						Else
							$dll_exe = DllOpen("setupapi.dll")							
							While 1
								$search_file = FileFindNextFile($search_ini) 
								$full_path_to_inf =  $drivers_directory & "\" & $search_file
								If @error Then ExitLoop
								$dll_result = DllCall($dll_exe, "int", "SetupCopyOEMInf", "str", $full_path_to_inf, "str", "", "int", 1, "int", 8, "str", "", "int", 0, "int", 0, "str", "")
								If $logging_option = "Advanced" Then
									If @error = 0 Then
										_AddLineBox("Inf integration passed: " & $drivers_directory & "\" & $search_file)
										$NrCopiedInfs = $NrCopiedInfs + 1
									ElseIf @error = 1 Then
										_AddLineBox("Inf integration failed: " & $drivers_directory & "\" & $search_file)
									ElseIf @error = 2 OR @error = 3 Then
										_AddLineBox("Unknown return type or Function not found in DLL. Tell author about it!")
									EndIf
								EndIf
							WEnd
							DllClose($dll_exe)
						EndIF
						FileClose($search_ini)
					EndIf
				EndIf
			EndIf
		Next
		If $NrCopiedInfs = 1 Then _AddLineBox("SetupCopyOemInf method completed. " & $NrCopiedInfs & " driver was integrated.")
		If $NrCopiedInfs = 0 Then _AddLineBox("SetupCopyOemInf method completed. No drivers were integrated.")
		If $NrCopiedInfs <> 0 AND $NrCopiedInfs <> 1 Then _AddLineBox("SetupCopyOemInf method completed. " & $NrCopiedInfs & " drivers were integrated." )
		$DeviceDrivers = "PASSED"
	EndIf
EndFunc

Func SetDevicePathDefault()
	; Resets DevicePath to DEFAULT 
	If $method = "RegistryDevicePath" Then
		_AddLineBox("Reseting registry DevicePath to default.")
		RegWrite($HKLM & "\SOFTWARE\Microsoft\Windows\CurrentVersion", "DevicePath", "REG_EXPAND_SZ", "%SystemRoot%\inf;")
	EndIf
EndFunc

Func DriverSearching($DriverSearchingStatus)
	$DriverSearching[1] = RegRead($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontSearchWindowsUpdate" )
	$DriverSearching[2] = RegRead($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontPromptForWindowsUpdate" )
	If $DriverSearchingStatus = "START" AND $DriverSearching[1] <> "1" Then
	   $SaveValue[1] = $DriverSearching[1]
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontSearchWindowsUpdate", "REG_DWORD", "1" )
    EndIf
   	If $DriverSearchingStatus = "START" AND $DriverSearching[2] <> "1" Then
	   $SaveValue[2] = $DriverSearching[2]
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontPromptForWindowsUpdate", "REG_DWORD", "1" )
    EndIf
	If $DriverSearchingStatus = "STOP" AND $SaveValue[1] <> "" Then
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontSearchWindowsUpdate", "REG_DWORD", $SaveValue[1] )
    EndIf
   	If $DriverSearchingStatus = "STOP" AND $SaveValue[2] <> "" Then
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontPromptForWindowsUpdate", "REG_DWORD", $SaveValue[2] )
    EndIf
	If $DriverSearchingStatus = "STOP" AND $SaveValue[1] = "" Then
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontSearchWindowsUpdate", "REG_DWORD", "0" )
    EndIf   
	If $DriverSearchingStatus = "STOP" AND $SaveValue[2] = "" Then
	   RegWrite($HKLM & "\SOFTWARE\Policies\Microsoft\Windows\DriverSearching", "DontPromptForWindowsUpdate", "REG_DWORD", "0" )
    EndIf
EndFunc

Func DriverSigning($DriverSigningStatus)
	If $DriverSigningStatus = "On" Then
		RegWrite($HKLM & "\SOFTWARE\Microsoft\Driver Signing", "Policy", "REG_BINARY", "01")
	    RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Driver Signing", "Policy", "REG_DWORD", "1")
	    RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows NT\Driver Signing", "BehaviorOnFailedVerify", "REG_DWORD", "00000001")
	    _AddLineBox("Setting Driver signing to ON.")
		$driversigningon = "PASSED"
	EndIf
	If $DriverSigningStatus = "Off" Then
		RegWrite($HKLM & "\SOFTWARE\Microsoft\Driver Signing", "Policy", "REG_BINARY", "00")
	    RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Driver Signing", "Policy", "REG_DWORD", "0")
	    RegWrite("HKEY_CURRENT_USER\Software\Policies\Microsoft\Windows NT\Driver Signing", "BehaviorOnFailedVerify", "REG_DWORD", "00000000")
		_AddLineBox("Setting Driver signing to OFF.")
		$driversigningoff = "PASSED"
	EndIf
EndFunc

Func DetectUnknownDevices() ; $Total_Nr_Devices,
	Dim $Unknown_Nr_Devices = 0
	_GUICtrlListViewDeleteAllItems ($ulist)
	Local $DevicesStatusOutput, $ListNumber = "0"
	$DevicesStatus = Run(@ComSpec & " /c " & $devcon & " status *", '', @SW_HIDE, 2)
	While 1
		$DevicesStatusData = StdoutRead($DevicesStatus)
		If @error Then ExitLoop
		If $DevicesStatusData Then
		$DevicesStatusOutput &= $DevicesStatusData
		Else
			sleep(10)
		EndIf
	WEnd
	$DevicesStatusOutput = StringStripWS($DevicesStatusOutput, 6) ; Remove spaces from output
	$DevicesStatusOutput = StringSplit($DevicesStatusOutput, @CRLF) ; Split output of devcon into array
	;_ArrayDisplay($DevicesStatusOutput, "DUPA")
	$DevicesLastLine = $DevicesStatusOutput[$DevicesStatusOutput[0]] ; Output of last DEVCON line
	$DevicesLastLineSplit = StringSplit($DevicesLastLine,"matching",1)
	_AddLineBox("Detecting number of devices in system.")
	Local $even = 1
	For $a = 1 to $DevicesStatusOutput[0]
		If StringInStr($DevicesStatusOutput[$a],"Device has a problem:") Then
			If StringInStr($DevicesStatusOutput[$a-2],"\") AND StringInStr($DevicesStatusOutput[$a-1],"Name:") Then
				$DeviceSplit = StringSplit($DevicesStatusOutput[$a-2],"\",1)
				$DeviceSplitName = StringSplit($DevicesStatusOutput[$a-1],"Name: ",1)
				$DeviceSplitProblem = StringSplit($DevicesStatusOutput[$a],"Device has a problem: ",1)
				$DeviceSplitProblem = StringTrimRight ( $DeviceSplitProblem[2], 1 )
				If $DeviceSplit[0] = 3 Then
					 $RemoveDeviceID = $DeviceSplit[1] & "\" & $DeviceSplit[2]
					 $RemoveDeviceName = $DeviceSplitName[2]
					 $RemoveDeviceProblem = $DeviceSplitProblem
					 $ListNumber = $ListNumber + 1
					 $Unknown_Nr_Devices = $Unknown_Nr_Devices + 1
				     ;MsgBox(1,"1","What problem: " & $RemoveDeviceProblem)
					 $lv_item = GUICtrlCreateListViewItem($ListNumber & "|" & $RemoveDeviceID & "|" & $RemoveDeviceName & "|" & $RemoveDeviceProblem, $ulist)
					 If $even Then
						$even = 0
					    GUICtrlSetBkColor($lv_item, 0x5CACEE)
					 Else
						GUICtrlSetBkColor($lv_item, 0x9FB6CD)
						$even = 1
					 EndIf
				EndIf
			EndIf
		EndIf
	Next	
	$Total_Nr_Devices = $DevicesLastLineSplit[1]
	$Unknown_Nr_Devices = $Unknown_Nr_Devices
	If $Unknown_Nr_Devices = 0 Then
	_AddLineBox("Found " & $Total_Nr_Devices & "devices without any problems." )
	$ErrorIsThere = "Yes"
	ElseIf $Unknown_Nr_Devices = 1 Then
	_AddLineBox("Found " & $Total_Nr_Devices & "devices of which " & $Unknown_Nr_Devices & " has problems." )
	Else
	_AddLineBox("Found " & $Total_Nr_Devices & "devices of which " & $Unknown_Nr_Devices & " have problems." )
	EndIf
	GUICtrlSetData( $Label[3], $Unknown_Nr_Devices, $GUI_SHOW )
	GUICtrlSetData( $Label[4], $Total_Nr_Devices, $GUI_SHOW )
EndFunc

Func RemoveUnknownHardware() ; Removes unknown devices from system.
		; Checks for system
		_AddLineBox("Removing unknown hardware from system.")
		; Removes all Unknown devices from system and gets output
		$DevconStatusOutput = Run(@ComSpec & " /c " & $devcon & " status *", '', @SW_HIDE, 2)
		While 1
			$DevconStatusData = StdoutRead($DevconStatusOutput)
			If @error Then ExitLoop
			If $DevconStatusData Then
				$output &= $DevconStatusData
			Else
				Sleep(10)
			EndIf
		WEnd
		$output = StringStripWS($output, 6) ; Remove spaces from output
		$DevconOutput = StringSplit($output, @CRLF) ; Split output of devcon into array
		;_ArrayDisplay($DevconOutput, "1")
		$DevconLastLine = $DevconOutput[$DevconOutput[0]] ; Output of last DEVCON line
		$RemoveHardware = "NOTHING"
		For $a = 1 to $DevconOutput[0]
			If StringInStr($DevconOutput[$a],"Device has a problem: 28") OR StringInStr($DevconOutput[$a],"Device has a problem: 01") Then
			   If StringInStr($DevconOutput[$a-2],"\") AND StringInStr($DevconOutput[$a-1],"Name:") Then
				  $RemoveDeviceSplit = StringSplit($DevconOutput[$a-2],"\",1)
				  If $RemoveDeviceSplit[0] = 3 Then
					 $RemoveDevice = $RemoveDeviceSplit[1] & "\" & $RemoveDeviceSplit[2]
				     ;MsgBox(1,"Numer: " & $a-2, $RemoveDevice)
				     $RemovingDevice = Run(@ComSpec & " /c " & $devcon & ' remove "' & $RemoveDevice & '"', '', @SW_HIDE, 2)
					 While 1
						$DevconRemovingData = StdoutRead($RemovingDevice)
						If @error Then ExitLoop
						If $DevconRemovingData Then
							$RemovingOutput &= $DevconRemovingData
						Else
							Sleep(10)
						EndIf
					WEnd
					 $RemovingOutput = StringStripWS($RemovingOutput, 6) ; Remove spaces from output
					 ;_ArrayDisplay($RemovingOutput,"2")
					 $DevconRemoveDevice = StringSplit($RemovingOutput, @CRLF) ; Split output of devcon into array
					 ;_ArrayDisplay($DevconRemoveDevice,"3")
					 If $logging_option = "Advanced" Then
						For $b = 1 To $DevconRemoveDevice[0]
						_AddLineBox("Advanced Output: " & $DevconRemoveDevice[$b] & @CRLF)
						Next
					 EndIf
				  EndIf
			   EndIf
			   $RemoveHardware = "PASSED"
			EndIf
		Next
		If $RemoveHardware = "PASSED" Then _AddLineBox("Unknown devices were removed successfully.")
		If $RemoveHardware = "NOTHING" Then _AddLineBox("There were no devices removed.")
		If $device_manager = "On" AND $RemoveHardware = "PASSED" Then DeviceManager()

EndFunc ; $RemoveHardware = NOTHING/PASSED

Func DetectPlugAndPlay()
	 Dim $DevconRescan
	 _AddLineBox("Forcing system to detect Plug & Play Devices.")
	 $DevconRescanOutput = Run(@ComSpec & " /c " & $devcon & " rescan", '', @SW_HIDE, 2)
	 While 1
			$DevconRescanData = StdoutRead($DevconRescanOutput)
			If @error Then ExitLoop
			If $DevconRescanData Then
				$DevconRescan &= $DevconRescanData
			Else
				Sleep(10)
			EndIf
	 WEnd
	 $DevconRescan = StringStripWS($DevconRescan, 6) ; Remove spaces from output
	 $DevconRescan = StringSplit($DevconRescan, @CRLF) ; Split output of devcon into array
	 _AddLineBox("System is now detecting and installing drivers for your hardware. Wait!")
	 If $logging_option = "Advanced" Then
		For $a = 1 To $DevconRescan[0]
			_AddLineBox("Advanced Output: " & $DevconRescan[$a])
		Next
	 EndIf
	 ;_ArrayDisplay($DevconRescan, "DUPA2")
	 $DetectHardware = "PASSED"
EndFunc
 
Func DeviceManager()
	_AddLineBox("Starting Device Manager.")
	Run(@ComSpec & " /c devmgmt.msc", '', @SW_HIDE, 2)
EndFunc

Func CleanUp()
	If $Delete_drivers = "Yes" Then DirRemove ( $copy_where, 1)
	If $ErrorIsThere = "No" Then DriverSigning("On")
	If $ErrorIsThere = "No" Then DriverSearching("STOP")
	If $ErrorIsThere = "No" Then SetDevicePathDefault()
	ProcessClose( "mmc.exe" )
	FileDelete ( @TempDir & "\devcon32.exe" )
	FileDelete ( @TempDir & "\devcon64.exe" )
	FileDelete ( @TempDir & "\7z.exe" )
	_AddLogToFile("=================== Log End: " & @ComputerName)
	FileClose($log_file)
EndFunc
