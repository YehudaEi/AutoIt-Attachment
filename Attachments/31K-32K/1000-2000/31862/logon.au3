#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=files\favicon.ico
#AutoIt3Wrapper_Outfile=logon.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=Computer Facilities automated logon script for Windows Domain (AD) based networks running 32bit XP/Vista and Windows 7 OS.
#AutoIt3Wrapper_Res_Description=Independent automated AD logon script
#AutoIt3Wrapper_Res_Fileversion=2.0.0.2
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_ProductVersion=V2
#AutoIt3Wrapper_Res_LegalCopyright=Computer Facilities (Uganda) Ltd.
#AutoIt3Wrapper_Res_Field=Made By| Peter R. Atkin
#AutoIt3Wrapper_Res_Field=Product Name|Automated Logon Script
#AutoIt3Wrapper_Res_Field=Date|%longdate%
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#cs
	Why:
	I wanted reliable and easy way that none expieranced IT people could get there windows domain modle based network up and running with minimal hassle.
	Logon scripts and GPO is beyond most everyday users, so thought it would be nice to help automate the common tasks in a centrol easy to adapt enviroment
	while also allowing the fexability for the experianced admin people.
	
	Main points of this script are:
	1) Fully configurable .ini file where most common setting can be edited without the need for programming knowledge, similar syntax as you would use in a batch file.
	2) Group centric, add shares and printers on a AD group bases
	2a) User centric, add shares and printers on a AD user bases
	3) Basic cleanup of PC when scripts starts, temp files, ie cache, recycle bins
	4) RDP, ncomputing session aware
	5) Excellent diagnostics and information pages as well as all errors been reported to the event logs under applications
	6) Can map none windows device shares in Vista or Windows 7, e.g uses IP instead of UNC names (Problem/Bug with Vista and Windows 7)
	7) Welcome can be verbal (just a bit of fun)
	8) Easy to deploy on almost any size AD network.
	9) Will run on XP, Vista and Windows 7 32bit Client OS, but not on Server OS's (deliberately)
	10) Designed for use with Windows 2003/8 (R2 included) servers, may run on 2000 but have not tested.
	11) test for known malware or unwanted running process, again all read from a sperate .ini file
	
	Updates:
	04-06-2010 logon script and var.ini can not be run from anywhere as long as they are together in the same location/directory.
	05-06-2010 Should var.ini not be found then the script will try and recreate the var.ini in the same location the the script is running from
	05-06-2010 Redo Versioning now starting from 1.1.0.0
	05-06-2010 Splash screen for clients logo while loading
	06-06-2010 Added User Profile detection
	08-07-2010 Added silent option for the welocome() diag screen whichb is now renamed to splash()
	08-07-2010 Tidied up some diags and removed redundent veriables
	08-07-2010 Sorted out bug to do with user home shares in vista mode
	08-08-2010 Added support for per user directory mapping
	10-08-2010 Redid how the user home shares are done, added a paramitor that allows a post fix charactor/s to be appended to the username, e.g. '$' that would then change the username to 'username$' for the user share.
	11-08-2010 Put some basic error control into read_settings_array function
	29-08-2010 Putin in generice array reader to simplify code
	30-08-2010 Put in malware scan very lossly based upon known Mmalware process list http://pcpitstop.com/libraries/process/topmalicous and MaXoFF
	31-09-2010 put in post message variable for future use to display local support contact details etc.
	31-09-2010 put in basic internet test
	16-10-2010 added log file facility
	
	Things to do:
	- A better way to do the Progress bar
	- Add facility to delete all printers (not as easy as it sounds)
	- Better Error control for drives / hosts that are not present
	- detect if computer and/or user is newly joined to the domain
	- silent install of main applications if not present on client system (already done as a seperate app, now need to intergrate it)
	- Redo .ini file paramitors to give more fexability
	- Tidy up script (always present)
	- move over to generic array reader where possible (in progress)
	- Basic Malware process disbale routine Malware / unwanted Processes: done
	
	Things to Note:
	- If your accessing external none windows based NAS devices using Vista or Windows 7 as a client then read the below URL for more
	help with Vista and windows 7, the script sorts out the name to IP but you will still need to modifiy the security setting where applicable.
	http://social.technet.microsoft.com/Forums/en-CA/w7itpronetworking/thread/4606ad12-1f23-4231-8597-8e515422d57d
	
	
	Bugs:
	08-07-2010 seems that the homebase is not working in Vista mode as expected : Solved
	08-07-2010 whatever server you use the user home directories have to be directly under a share name of 'user$' : Solved
	02-09-2010 seems that brocken / disabled the add network printer function from running properly : Solved in version 1.1.0.18
	06-10-2010 seems that brocken / disabled the add network printer function from running properly again? : Solvedish 1.1.0.26, properly solved in version 2.0
	
	Accreditations and Referances
	Drive mapping: 		http://www.autoitscript.com/forum/index.php?showtopic=110567&st=0&gopid=776497&#entry776497
	User Profile Type: 	http://www.autoitscript.com/forum/index.php?showtopic=113711
	Splash Screen:		http://www.autoitscript.com/forum/index.php?showtopic=115441
	IP Stuff:			http://www.autoitscript.com/forum/index.php?showtopic=82733&st=0&p=625302&hl=IP%20gateway&fromsearch=1&#entry625302
	IP Stuff: 			http://www.autoitscript.com/forum/index.php?showtopic=109887&st=0&gopid=772563&#entry772563
	IP Stuff: 			http://msdn.microsoft.com/en-us/library/aa394217(VS.85).aspx
	Malware Scanner:	http://www.autoitscript.com/forum/index.php?showtopic=87144&st=0&gopid=827573&#entry827573
	generic array		http://www.autoitscript.com/forum/index.php?showtopic=119057&st=0&gopid=827940&#entry827940
	
	Dependencies and versions:
	Autoit 3.3.6.1		http://www.autoitscript.com/autoit3/downloads.shtml
	UDF - AD 0.40 		http://www.autoitscript.com/forum/index.php?showtopic=106163
	UDF - Log 1.0
#ce

#include <Constants.au3>
#include <Array.au3>
#include <String.au3>
#include <NetShare.au3>
#include <Misc.au3>
#include <AD.au3>
#include <File.au3>
#include <EventLog.au3>
#include <iNet.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>
#include <log.au3>

Global Const $_SingleTonKey = "07c9623c-2ffb-4e6e-8fd9-f824ede2e9ac" ; e.g. GUID
_single_instance() ; comment this line out if in multi user enviroment.

;Function keys to pause or terminate the script
HotKeySet("{PAUSE}", "_TogglePause")
HotKeySet("{END}", "_Terminate")
Global $Paused

;some Global default settings just in case
Global $voice_welcome = "Yes", $homebase, $homebase_drive, $homebase_post, $userlogonname, $tempfile_clean = "Yes", $IE_clean = "No", $empty_bins = "Yes", $company = "Computer Facilities", $splash = "Yes", $diags = 0
Global $local_IP = GetLanIP(), $ostemp, $post_msg = "support@computer-facilities.com or call on 0414-533784", $InternetStat = 0, $detect_processes = "No"
Global $cmd = ($CmdLine) - 1
Global $error_code = 0
Global $session = ""
Global $ostemp = _OSGet()
Global $greeting = _FuzzyTime()
Global $pbar = 0; progress bar counter

;Global file locations and Verion Information
Global $hLog = _Log_Open(@UserProfileDir & "\" & "logon-" & @UserName & ".log", "###User " & @UserName & " Logon Event Log###")
Global $vars_file = @ScriptDir & "\vars.ini"
Global $malware_file = @ScriptDir & "\malware.ini"
Global $script_version = FileGetVersion(@ScriptFullPath, "FileVersion")
ConsoleWrite(@CRLF & '>>>> Logfile <<<<' & @CRLF & @CRLF)
ConsoleWrite(@UserProfileDir & "\" & "logon-" & @UserName & ".log" & @CRLF)

;Where am I been run from
Global $mediatype = DriveGetType(StringLeft(@ScriptFullPath, 2))

;What type of login profile am I running under
Global $user_profile_type = what_profile()

;Global 2D arrays to be read from .ini
Global $groups[99][2], $network_drives[24], $group_network_printers[99][2], $malware[499][2], $DrivePath[24][2], $settings[100][2], $copyrite[4][2]

; read all Global veribles into assigned 2D arrays and get numbur of active elements back
Global $var_copyrite = generic_read_array($vars_file, "Computer Facilities", $copyrite)
Global $var_settings = generic_read_array($vars_file, "Settings", $settings)
Global $var_malware = generic_read_array($malware_file, "Malware", $malware)
Global $var_groups = generic_read_array($vars_file, "Groups", $groups)
Global $var_network_printers = generic_read_array($vars_file, "Group Printers", $group_network_printers)

ConsoleWrite(@CRLF & '>>>> Global Array Size <<<<' & @CRLF & @CRLF)
ConsoleWrite("malware :" & $var_malware & @CRLF & "Groups :" & $var_groups & @CRLF & "Network printers :" & $var_network_printers & @CRLF & "Settings :" & $var_settings & @CRLF)
_put_event(4, "logon script started Log can be found at :" & $hLog, @error)
_add_log_line("logon script started")

file_resources()
test_ini_file()
read_settings_array()
_session()

If $ostemp = "Server Mode" Then Exit
If Not $CmdLine[0] = 0 Then _ReadCmdLineParams()

_AD_Open()
If @error Then
	MsgBox(16, "Critical Error", "Could not contact Domain Controller for Athentication please contact your IT via the follwing :" & @CRLF & $post_msg & @CRLF & "for support")
	_put_event(1, "Active Directory error :" & @error & " AD connection could not be opened", @error)
	_add_log_line("Active Directory error :" & @error & " AD connection could not be opened")
	Exit
Else
	Local $logo_file = @ScriptDir & "\cfu_logo.bmp"
	_GDIPlus_Startup()
	Local $hImage = _GDIPlus_BitmapCreateFromFile($logo_file)
	Local $iX = _GDIPlus_ImageGetWidth($hImage)
	Local $iY = _GDIPlus_ImageGetHeight($hImage)
	_GDIPlus_BitmapDispose($hImage)
	_GDIPlus_Shutdown()
	SplashImageOn("Splash Screen", $logo_file, $iX, $iY, -1, -1, 1)
	_put_event(4, "Active Directory connection opened succesfully to " & @LogonDNSDomain & _
			@CRLF & " Profile Type :" & $user_profile_type & " Logged on via :" & $mediatype, @error)
	_add_log_line("Active Directory connection opened succesfully to " & @LogonDNSDomain & @CRLF & " Profile Type :" & $user_profile_type & " Logged on via :" & $mediatype)
EndIf

If _AD_IsMemberOf("Domain Users", @UserName, True) Then
	ProgressOn($greeting & " " & @UserName & " | Profile " & $user_profile_type, "login onto " & @LogonServer & " (" & $ostemp & ")", "Automated Domain Access Progress", 50, 50, 16)
	If $voice_welcome = "Yes" Then _say($greeting & " " & @UserName & ", and welcome to the " & $company & " Network, please wait while you are being logged onto the system", 50)
	_add_log_line("Voice Greeting :" & $voice_welcome & @CRLF)
	ProgressSet(1, "Unwanded Processes Scan,...")
	Sleep(750)
	scan_malware($var_malware)
	Sleep(750)
	ProgressSet(10, "Unwanded Processes Scan ended...")
	TrayTip("Logon script running", $ostemp & " Local IP: " & $local_IP, 7, 1)
	ProgressSet(11, "Finding network drives in use...")
Else
	If $diags = 1 Then MsgBox(16, "Invalid User", "Sorry you apper not to have sufficent rights to use this domain")
	_put_event(4, "Invalid User ID: " & @UserName & " tried to log on", @error)
	_add_log_line("Invalid User ID: " & @UserName & " tried to log on")
	$error_code = 1
	Exit
EndIf

ProgressSet(15, "Removing old network shares please wait...")
_delmappeddrive("*")
ProgressSet(20, "Adding default shares")
$pbar = 25
_ifmember()
$pbar = 35
_maphomeshare()
$pbar = 45
_add_network_shares("domain users")
$pbar = 55
_add_network_group_printers()
$pbar = 70
_users()
_AD_Close()
ProgressSet(80, "System Cleanup", "Started")
If $tempfile_clean = "Yes" Then temp_clean()
If $empty_bins = "Yes" Then EmptyRecycleBin()
ProgressSet(85, "System Cleanup", "Complete")
Sleep(500)
ProgressSet(90, "IE Cleanup", "Started")
If $IE_clean = "Yes" Then IE_Clean()
ProgressSet(95, "IE Cleanup", "Complete")
;_users()
ProgressSet(100, "Done", "Logon Complete")
Sleep(500)
ProgressOff()
SplashOff()
If $splash = "Yes" Then
	_splash()
Else
	TrayTip("Logon Errors Detected", "Please see the Event log", 7, 1)
EndIf
_put_event(4, "logon script finished", @error)
_add_log_line("logon script finished")
_Log_Close($hLog)

; >>>> no need to edit beyond this point..

Func _maphomeshare()
	If StringLen($homebase) > 0 Then
		Switch $ostemp
			Case "XP Mode"
				ConsoleWrite('XP Mode' & @CRLF)
				ProgressSet($pbar, "Home share" & $homebase & $userlogonname)
				_mapdrive($homebase_drive, $homebase & $userlogonname)
				_add_log_line($homebase_drive & $homebase & $userlogonname)
			Case "Vista Mode"
				ConsoleWrite('Vista Mode' & @CRLF)
				Local $var_host = _StringBetween($homebase, "\\", "\", -1)
				Local $var_ip = _HostNameToIP($var_host[0])
				ConsoleWrite('Home Share IP: ' & $var_ip & @CRLF)
				Local $rootstartlocation = StringInStr($homebase, "\", 0, 3)
				Local $roothomeshare = StringTrimLeft($homebase, $rootstartlocation - 1)
				Local $var = "\\" & $var_ip & $roothomeshare
				$homebase = $var & "\" & $userlogonname
				ProgressSet($pbar, " Home share " & $homebase)
				$homebase = $var & "\" & $userlogonname
				_mapdrive($homebase_drive, $homebase)
				_add_log_line($homebase_drive & $homebase)
				ConsoleWrite('Home Share UNC: ' & $homebase & @CRLF)
		EndSwitch
	EndIf
EndFunc   ;==>_maphomeshare

Func _users()
	Local $i, $var_u
	TrayTip("Individual preferences", "setup for " & @UserName, 7, 1)
	ProgressSet($pbar, "Find User Shares", "Scanning for user shares")
	$var = IniReadSection($vars_file, @UserName)
	If @error Then
		ProgressSet($pbar, "Personal User Shares", "No User Shares Found")
	Else
		_add_network_shares(@UserName)
	EndIf
	ProgressSet($pbar, "Personal User Shares", "User Shares attached")
	Sleep(500)
EndFunc   ;==>_users

Func _ifmember()
	Local $i
	For $i = 0 To $var_groups Step 1
		ConsoleWrite(@CRLF & '>>>> If Member <<<<' & @CRLF)
		If _AD_isMemberOf($groups[$i][1], @UserName) Then
			_add_log_line("User :" & @UserName & " Member of :" & $groups[$i][1])
			ConsoleWrite("User :" & @UserName & " Member of :" & $groups[$i][1] & @CRLF)
			ProgressSet($pbar + $i, "Setup groups " & $groups[$i][1] & " shares")
			Sleep(450)
			_add_network_shares($groups[$i][1])
		EndIf
	Next
EndFunc   ;==>_ifmember

Func _add_network_group_printers()
	#cs
		
		This function is used in conjunction with the generic_read_array() function, this will compare the
		groups[$j][1] array to the group_network_printers[$j][0] array and if the elements (groups)  match then a printer will be assigned
		to the user a printer based upon the group or groups they are in.
		
	#ce

	Local $j = 1, $printer_share, $var
	ConsoleWrite(@CRLF & ">>>> Printer Share UNC: [" & $var_network_printers & "]" & " <<<<" & @CRLF)

	Do
		$var = _AD_isMemberOf($group_network_printers[$j][0], @UserName, True)
		ConsoleWrite($var & " : " & "Printer Group :" & $groups[$j][1] & " [" & $j & "]" & @CRLF & "Printer Share : " & $group_network_printers[$j][1] & @CRLF)
		If $var = 1 Then
			ProgressSet($pbar + $j, "Setting up" & $group_network_printers[$j][1])
			_add_log_line(": Printer Group :" & $group_network_printers[$j][0] & " [" & $j & "]" & @CRLF & "> Printer Share : " & $group_network_printers[$j][1])
			ConsoleWrite("> T/F " & $var & ": Printer Group :" & $group_network_printers[$j][0] & " [" & $j & "]" & @CRLF & "> Printer Share : " & $group_network_printers[$j][1] & @CRLF)
			_PrinterAdd($group_network_printers[$j][1], 0)
		EndIf
		$j = $j + 1
	Until $j = $var_network_printers + 1
EndFunc   ;==>_add_network_group_printers

Func _add_network_shares($share_group)
	Local $var_host, $var_ip, $var, $var1
	Local $var_network_shares = generic_read_array($vars_file, $share_group, $DrivePath)
	For $j = 1 To $var_network_shares
		_add_log_line("Total Network Shares : " & $j & " of " & $var_network_shares & " Drive : " & $DrivePath[$j][0] & $DrivePath[$j][1])
		$ostemp = _OSGet()
		Switch $ostemp
			Case "XP Mode"
				_mapdrive($DrivePath[$j][0], $DrivePath[$j][1])
			Case "Vista Mode"
				$var_host = _StringBetween($DrivePath[$j][1], "\\", "\", -1)
				$var_ip = _HostNameToIP($var_host[0])
				$var = StringReplace($DrivePath[$j][1], $var_host[0], $var_ip, 0, 2)
				$var1 = $DrivePath[$j][0]
				_mapdrive($var1, $var)
		EndSwitch
	Next
EndFunc   ;==>_add_network_shares

Func read_settings_array()
	Local $len, $i
	ConsoleWrite(@CRLF & '>>>> Basic .INI Settings <<<<' & @CRLF & @CRLF)
	For $i = 1 To $var_settings
		Switch $settings[$i][0]
			Case "voice_welcome"
				$voice_welcome = $settings[$i][1]
			Case "homebase"
				ConsoleWrite(@CRLF & "> Homebase for [" & @UserName & "]" & " <" & @CRLF)
				$len = StringLen($settings[$i][1])
				If $len = 0 Then
					ConsoleWrite('No Home Share for user : ' & @UserName & @CRLF)
					_put_event(4, "No Home Share found in the .ini file for user " & @UserName & " no home share shall be added", @error)
				Else
					$homebase = $settings[$i][1]
					$var_host = _StringBetween($homebase, "\\", "\", -1)
					If @error = 1 Then
						ConsoleWrite("Homebase is not properly formatted :" & $homebase & @UserName & @CRLF)
						ConsoleWrite("Homebase will be reset to null" & @CRLF & @CRLF)
						$homebase = ""
						$settings[$i][1] = ""
					EndIf
					If StringRight($homebase, 1) = "\" Then
						; this just removes the "\" at the end of the string if present old habits die hard!
						$var_len = StringLen($homebase)
						$homebase = StringLeft($homebase, $var_len - 1)
					EndIf
					_add_log_line("Full UNC homebase is : " & $homebase & "\" & @UserName)
					ConsoleWrite("Full UNC homebase is : " & $homebase & "\" & @UserName & @CRLF & @CRLF)
				EndIf
			Case "homebase_drive"
				$homebase_drive = $settings[$i][1]
			Case "homebase_post"
				$homebase_post = $settings[$i][1]
				$len = StringLen($homebase_post)
				If $len = 0 Then
					$userlogonname = @UserName
				Else
					$userlogonname = @UserName & $homebase_post
				EndIf
				If $diags = 1 Then MsgBox(1, "Username", $userlogonname)
			Case "tempfile_clean"
				$tempfile_clean = $settings[$i][1]
			Case "IE_clean"
				$IE_clean = $settings[$i][1]
			Case "empty_bins"
				$empty_bins = $settings[$i][1]
			Case "Company"
				$company = $settings[$i][1]
			Case "Splash"
				$splash = $settings[$i][1]
			Case "Diags"
				$diags = $settings[$i][1]
			Case "post_msg"
				$post_msg = $settings[$i][1]
			Case "detect_processes"
				$detect_processes = $settings[$i][1]
			Case Else
				_add_log_line("Setting error! [" & @error & "] The varible [" & $settings[$i][0] & "] does not exist in " & @CRLF & $vars_file & ", please check that this exists and can be used!")
		EndSwitch
		ConsoleWrite($settings[$i][0] & " = " & $settings[$i][1] & @CRLF)
	Next
EndFunc   ;==>read_settings_array

Func _mapdrive($DriveLtr, $DrivePath)
	Local $var, $var1, $var2, $var_DrivePath
	$var_DrivePath = _StringBetween($DrivePath, "\\", "\")
	_add_log_line($DrivePath & " " & $var_DrivePath)
	$var = $var_DrivePath[0]
	$var1 = _ping($var, 25)
	If $var1 Then
		; so now the function will not try to connect to a device that is not present,
		; make sure your firewall allows ICBM echo requests.
		$var2 = DriveMapAdd($DriveLtr, $DrivePath, 8)
		Switch @error
			Case 1
				_put_event(1, "O.M.G Error, An unknown error occured on " & $DrivePath & " trying to be mapped as local drive " & $DriveLtr & " maybe end device is not avilable for mapping", @error)
				_add_log_line("O.M.G Error, An unknown error occured on " & $DrivePath & " trying to be mapped as local drive " & $DriveLtr & " maybe end device is not avilable for mapping")
				$error_code = 1
			Case 2
				_put_event(1, "Access Error, Access to the remote share " & $DrivePath & " was denied", @error)
				_add_log_line("Access Error, Access to the remote share " & $DrivePath & " was denied")
				$error_code = 1
			Case 3
				_put_event(4, "Map Drive Error, The device/drive " & $DriveLtr & " is already assigned and will be deleted", @error)
				_add_log_line("Map Drive Error, The device/drive " & $DriveLtr & " is already assigned and will be deleted if possible")
				_delmappeddrive($DriveLtr)
			Case 4
				_put_event(1, "Device Error, Invalid device " & $DriveLtr & " name", @error)
				_add_log_line("Device Error, Invalid device " & $DriveLtr & " name")
				$error_code = 1
			Case 5
				_put_event(1, "Connect to Remote Share Error, Invalid remote share :" & $DrivePath, @error)
				_add_log_line("Connect to Remote Share Error, Invalid remote share :" & $DrivePath)
				$error_code = 1
			Case 6
				_put_event(1, "Password Error for user :" & @UserName & " Invalid password for " & $DriveLtr & $DrivePath, @error)
				_add_log_line("Password Error for user :" & @UserName & " Invalid password for " & $DriveLtr & $DrivePath)
				$error_code = 1
		EndSwitch
		If $var2 = 1 Then _add_log_line("Completed! Mapped " & $DriveLtr & " to share " & $DrivePath)
	EndIf
EndFunc   ;==>_mapdrive

Func _delmappeddrive($drived)
	If $drived = "*" Then
		$var = DriveGetDrive("Network")
		If Not @error Then
			For $i = 1 To $var[0] Step 1
				$network_drives[$i] = $var[$i]
			Next
			For $i = 1 To $var[0]
				DriveMapDel($network_drives[$i])
				If @error Then
					$error_code = 1
					_add_log_line("Delete All Drive Error " & $network_drives[$i] & " code :" & @error & " and is already assigned And could Not be deleted")
					_put_event(1, "Delete All Drive Error " & $network_drives[$i] & " code :" & @error & " and is already assigned And could Not be deleted", @error)
				Else
					If $diags = 1 Then MsgBox(64, "Completed!", "Deleted " & $network_drives[$i])
				EndIf
			Next
		Else
		EndIf
	Else
		DriveMapDel($drived)
		If @error Then
			$error_code = 1
			_add_log_line("Delete All Drive Error " & $network_drives[$i] & " code :" & @error & " and is already assigned And could Not be deleted")
			_put_event(1, "Map Drive Error " & $drived & " is already assigned and cannot be deleted", @error)
		Else
			;MsgBox(64, "Completed!", "Deleted " & $network_drives[$i])
		EndIf
	EndIf
EndFunc   ;==>_delmappeddrive

Func GetLanIP()
	;http://www.autoitscript.com/forum/index.php?showtopic=109887&st=0&gopid=772563&#entry772563
	;Thanks to Phodexis for this.
	;http://msdn.microsoft.com/en-us/library/aa394217(VS.85).aspx
	Local $colItems = ""
	Local $strComputer = "localhost"
	Local $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	Local $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration", "WQL", 0x10 + 0x20)
	If IsObj($colItems) Then
		For $objItem In $colItems
			If (StringLen($objItem.IPAddress(0)) > 3) And (StringLen($objItem.DefaultIPGateway(0)) > 3) Then
				If @IPAddress1 = $objItem.IPAddress(0) Then Return @IPAddress1
				If @IPAddress2 = $objItem.IPAddress(0) Then Return @IPAddress2
				If @IPAddress3 = $objItem.IPAddress(0) Then Return @IPAddress3
				If @IPAddress4 = $objItem.IPAddress(0) Then Return @IPAddress4
			EndIf
		Next
	Else
		_put_event(1, "What no IP?", @error)
		$error_code = 1
		Return @IPAddress1 ; if you dont have Gateway
	EndIf
EndFunc   ;==>GetLanIP

Func GetLANobject($obj, $obj2)
	Local $colItems = ""
	Local $strComputer = "localhost"
	Local $objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	Local $colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration", "WQL", 0x10 + 0x20)
	If IsObj($colItems) Then
		For $objItem In $colItems
			If (StringLen($objItem.IPAddress(0)) > 3) And (StringLen(Execute($obj)) > 3) Then
				If @IPAddress1 = $objItem.IPAddress(0) Then Return Execute($obj2)
				If @IPAddress2 = $objItem.IPAddress(0) Then Return Execute($obj2)
				If @IPAddress3 = $objItem.IPAddress(0) Then Return Execute($obj2)
				If @IPAddress4 = $objItem.IPAddress(0) Then Return Execute($obj2)
			EndIf
		Next
	Else
		Return "N/A" ; if you dont have IPSubnet
	EndIf
EndFunc   ;==>GetLANobject

Func temp_clean()
	Switch _OSGet()
		Case "XP Mode"
			EmptyFolder(@UserProfileDir & "\Local Settings\Temporary Internet Files\Content.IE5")
			EmptyFolder(@UserProfileDir & "\Local Settings\Temporary Internet Files")
			EmptyFolder(@UserProfileDir & "\Cookies")
			EmptyFolder(@UserProfileDir & "\Local Settings\History")
			EmptyFolder(@UserProfileDir & "\Recent")
			EmptyFolder(@AppDataDir & "\Microsoft\Office\Recent")
			EmptyFolder(@UserProfileDir & "\Local Settings\Temp")
		Case "Vista Mode"
			;Local
			EmptyFolder(@AppDataDir & "\Local\Temp")
			EmptyFolder(@AppDataDir & "\Local\Microsoft\Windows\Temporary Internet Files")
			;LocalLow
			EmptyFolder(@AppDataDir & "\LocalLow\Temp")
			;protected / locations
			EmptyFolder(@AppDataDir & "\Local\Temporary Internet Files")
			EmptyFolder(@UserProfileDir & "\Local\History")
			EmptyFolder(@UserProfileDir & "\Recent")
			EmptyFolder(@UserProfileDir & "\Cookies")
			;Roaming
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\CryptnetUrlCache\Content")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\CryptnetUrlCache\MetaData")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\Windows\Cookies\Low")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\Windows\IECampatCache\low")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\Windows\IETldCache\low")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\Windows\PrivacIE\low")
			EmptyFolder(@AppDataDir & "\Roaming\Microsoft\Windows\Recent")
			;ProgramData\Microsoft
			EmptyFolder(@UserProfileDir & "\ProgramData\Microsoft\Windows Defender\Quaratine")
			EmptyFolder(@UserProfileDir & "\ProgramData\Microsoft\Caches")
	EndSwitch
	EmptyFolder(@TempDir)
EndFunc   ;==>temp_clean

Func scan_malware($var_malware)
	#cs
		
		Stop and/or detect Malware / unwanted process, all unwonted process are stored in an .ini file
		named malware.ini and  within the section named [malware] this is then read into a 2D array malware[499][2]
		for further processing within this function.
		
		The process is very fast very little overhead, well none that I noticed I have nearly 100 process listed.
		
		All three Global veriables have to be valid $var_malware, $malware_file and $detect_processes for function to run.
		
	#ce

	Local $varmw, $mw, $mwf, $var

	If $detect_processes = "Yes" Then
		If $var_malware > 1 And FileExists($malware_file) Then
			_add_log_line("Hostile Process / Malware Scanner Started")
			For $mw = 1 To $var_malware Step 1
				Local $mwf = 0, $error
				$var = ProcessExists($malware[$mw][0])
				If $var > 0 Then
					$varmw = ProcessClose($malware[$mw][0])
					$error_msg = $malware[$mw][0]
					Switch @error
						Case 1
							ConsoleWrite("OpenProcess Failed, [" & $error_msg & "] you may need Administrator rights")
							_add_log_line("Kill Process Failed, OpenProcess Failed, [" & $error_msg & "] failed to terminate hostile process you may need Administrator rights")
							$error_code = 1
						Case 2
							ConsoleWrite("AdjustTokenPrivileges Failed, [" & $error_msg & "] you may need Administrator rights")
							_add_log_line("Kill Process Failed, AdjustTokenPrivileges Failed [" & $error_msg & "] failed to terminate hostile process you may need Administrator rights")
							$error_code = 1
						Case 3
							ConsoleWrite("Terminate Process Failed, Terminate Process Failed [" & $error_msg & "]")
							_add_log_line("Kill Process Failed [" & $error_msg & "] failed to terminate hostile process you may need Administrator rights")
							$error_code = 1
						Case 4
							ConsoleWrite("Cannot verify if process exists, [" & $error_msg & "] you may need Administrator rights")
							_add_log_line("Kill Process Failed, Cannot verify that process exists [" & $error_msg & "] failed to terminate hostile process you may need Administrator rights")
							$error_code = 1
					EndSwitch
					$mwf = $mwf + 1
				EndIf
			Next
			If $var = 0 Then _add_log_line("No Hostile Process Found that match malware list")
		Else
			$error_code = 1
			_put_event(2, "Malware error, Cannot verify that array has data No. of records :[" & $var_malware & "] or that file exists [" & $var_malware & "]", @error)
			_add_log_line("Malware Error " & @error & " Cannot verify that array has data No. of records :[" & $var_malware & "] or that file exists [" & $var_malware & "]")
		EndIf
	EndIf
EndFunc   ;==>scan_malware

Func EmptyRecycleBin()
	Local $var = DriveGetDrive("FIXED")
	;MsgBox(4096, "", "Found " & $var[0] & " Fixed drives")
	For $i = 1 To $var[0]
		FileRecycleEmpty($var[$i])
		Switch @error
			Case 0
				; success not needed just there for completness
			Case 1
				$error_code = 1
				_put_event(1, "Could not empty recycle bin at " & $var[$i], @error)
		EndSwitch
	Next
EndFunc   ;==>EmptyRecycleBin

Func IE_Clean()
	$var = _IEGet()
	Switch $var
		Case 7 To 8
			ShellExecuteWait("RunDll32.exe", " InetCpl.cpl,ClearMyTracksByProcess 4351", @SW_HIDE)
		Case Else
			$error_code = 1
			_put_event(1, "IE Clean could not be done, IE Version :" & $var & " is not supported requires IE7 or above", @error)
	EndSwitch
EndFunc   ;==>IE_Clean

Func EmptyFolder($FolderToDelete)
	$Debug = 0 ;0 or 1
	$AllFiles = _FileListToArray($FolderToDelete, "*", 0)
	If $Debug Then ConsoleWrite("-->" & $FolderToDelete & @CRLF)
	If IsArray($AllFiles) Then
		If $Debug Then
			_ArrayDisplay($AllFiles, $FolderToDelete)
		EndIf
		For $i = 1 To $AllFiles[0]
			$crt = FileGetTime($FolderToDelete & "\" & $AllFiles[$i], 1)
			If $crt[2] = @MDAY And $crt[0] = @YEAR And $crt[1] = @MON Then
				If $Debug Then
					ConsoleWrite($FolderToDelete & "\" & $AllFiles[$i] & " --> Today's File, Skipping!" & @CRLF)
				EndIf
				ContinueLoop
			EndIf
			$delete = FileDelete($FolderToDelete & "\" & $AllFiles[$i])
			If $Debug Then
				ConsoleWrite($FolderToDelete & "\" & $AllFiles[$i] & " =>" & $delete & @CRLF)
			EndIf
			DirRemove($FolderToDelete & "\" & $AllFiles[$i], 1)
		Next
	EndIf
EndFunc   ;==>EmptyFolder

Func _splash()
	Local $local_domain = @LogonDNSDomain
	Local $domain_server = @LogonServer
	Local $gateway = GetLANobject("$objItem.DefaultIPGateway(0)", "$objItem.DefaultIPGateway(0)")
	Local $dns_server = GetLANobject("$objItem.DNSServerSearchOrder(0)", "$objItem.DNSServerSearchOrder(0)")
	Local $dhcp_server = GetLANobject("$objItem.DHCPServer(0)", "$objItem.DHCPServer(0)")
	Local $subnet_mask = GetLANobject("$objItem.IPSubnet(0)", "$objItem.IPSubnet(0)")
	Local $mac_address = GetLANobject("$objItem.MACAddress(0)", "$objItem.MACAddress(0)")
	Local $welcome = GUICreate("IP: " & $local_IP & " DNS: " & $dns_server & " GW: " & $gateway & " DHCP: " & $dhcp_server, 500, 200)
	GUISetIcon(@ScriptDir & "\help.ico")
	GUICtrlCreateLabel("Welcome " & @UserName & " to the " & $local_domain & " Network" & _
			@CRLF & @CRLF & "you seem to be running " & @OSVersion & " " & @OSServicePack & " OS in " & @OSArch & " mode" & @CRLF & @CRLF & "Your home directory is: " & $homebase & @UserName & _
			@CRLF & @CRLF & "If you have any problems or questions with your account please contact Computer Facilities support on " & @CRLF & "0414-533784 or e-mail: support@computer-facilities.com" & _
			@CRLF & @CRLF & "Logon script in " & $ostemp & " from " & @ComputerName & @CRLF & "MAC : " & $mac_address & " using Server " & $domain_server & _
			@CRLF & "Running session is : " & $session, 10, 10)
	Switch $error_code
		Case 0
			GUICtrlCreateLabel("No Errors Present", 10, 180)
		Case 1
			GUICtrlCreateLabel("*** See Application Event Log ***", 10, 180)
			$diags = "IP: " & $local_IP & " DNS: " & $dns_server & " GW: " & $gateway & " DHCP: " & $dhcp_server & _
					@CRLF & @CRLF & @OSVersion & " " & @OSServicePack & " OS in " & @OSArch & " mode" & @CRLF & @CRLF & _
					@CRLF & @CRLF & "Logon script in " & $ostemp & " from " & @ComputerName & @CRLF & "MAC : " & $mac_address & " using Server " & $domain_server & _
					@CRLF & "Running session is : " & $session & " Script path : " & @ScriptFullPath
			_put_event(4, $diags, @error)
	EndSwitch
	$Link = GUICtrlCreateLabel("About", 460, 180)

	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetFont(-1, Default, Default, 4)
	GUICtrlSetCursor(-1, 2)
	GUISetState(@SW_SHOW, $welcome)

	While WinActive($welcome)
		$aMsg = GUIGetMsg()
		Switch $aMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($welcome)
			Case $Link
				_About()
		EndSwitch
	WEnd
	; About window
EndFunc   ;==>_splash

Func _About()
	$About = GUICreate("Autologin v. " & $script_version, 500, 200)
	GUISetIcon(@ScriptDir & "\windows.ico")
	GUICtrlCreateLabel("Secure login created by Computer Facilities - A Network Admin's best friend." & _
			@CRLF & @CRLF & "Features" & _
			@CRLF & "- integrates with AD domain security" & _
			@CRLF & "- secure verification by MAC, IP and Username" & _
			@CRLF & "- optional secure dongle logon" & _
			@CRLF & "- user level customization" & _
			@CRLF & "- push software installs and updates domain wide" & _
			@CRLF & "- integrates with ZyXEL security appliances" & _
			@CRLF & "- auto setup full user environment" & _
			@CRLF & @CRLF & "Computer Facilities specialists in network installation and network security solutions", 10, 10)
	$Link = GUICtrlCreateLabel("www.computer-facilities.com", 350, 180, 280)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetFont(-1, Default, Default, 4)
	GUICtrlSetCursor(-1, 2)

	GUISetState(@SW_SHOW, $About)

	While WinActive($About)
		$aMsg = GUIGetMsg()
		Switch $aMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($About)
			Case $Link
				ShellExecute("                                  ")
		EndSwitch
	WEnd
	; About window
EndFunc   ;==>_About

Func _put_event($value, $text, $error_id_code)
	;SUCCESS = 0
	;ERROR =1
	;WARNING =2
	;INFORMATION =4
	;AUDIT_SUCCESS =8
	;AUDIT_FAILURE =16
	Local $hEventLog, $aData[4] = [3, 1, 2, 3]

	$hEventLog = _EventLog__Open("", "Logon Script")
	_EventLog__Report($hEventLog, $value, 0, $error_id_code, @UserName, @CRLF & @CRLF & $text & @CRLF & @CRLF & "Contact Computer Facilities for more information, contact details can be found at www.computer-facilities.com or e-mail support@computer-facilities.com", $aData)
	_EventLog__Close($hEventLog)
EndFunc   ;==>_put_event

Func _add_log_line($logmsg)
	_Log_Report($hLog, $logmsg)
	_Log_Report($hLog, "---------")
EndFunc   ;==>_add_log_line

Func _IEGet()
	Local $sVersion = FileGetVersion(@ProgramFilesDir & "\Internet Explorer\iexplore.exe")
	Switch StringLeft($sVersion, 1)
		Case "8"
			Return "8"
		Case "7"
			Return "7"
		Case "6"
			Return "6"
		Case "5"
			Return "5"
		Case "4"
			Return "4"
		Case "3"
			Return "3"
		Case "2"
			Return "2"
		Case Else
			Return "0"
	EndSwitch
EndFunc   ;==>_IEGet

Func _OSGet()
	Switch @OSVersion
		Case "WIN_7"
			Return "Vista Mode"
		Case "WIN_XP"
			Return "XP Mode"
		Case "Win_2000"
			Return "XP Mode"
		Case "WIN_VISTA"
			Return "Vista Mode"
		Case "WIN_2008"
			Return "Server Mode"
		Case "WIN_2008R2"
			Return "Server Mode"
		Case "WIN_2003"
			Return "Server Mode"
		Case Else
			$error_code = 1
			_put_event(1, "Unsupported OS Version, User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", @error)
			Return "unknown"
			Exit
	EndSwitch
	_ArchGet()
EndFunc   ;==>_OSGet

Func _ArchGet()
	Switch @OSArch
		Case "X86"
		Case Else
			;MsgBox(32, "32/64bit Architecture", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
			Exit
	EndSwitch
EndFunc   ;==>_ArchGet

Func _FuzzyTime()
	Switch @HOUR
		Case 5 To 7
			Return "Your the Early Bird"
		Case 8 To 11
			Return "Good Morning"
		Case 12 To 17
			Return "Good Afternoon"
		Case 18 To 20
			Return "Good Evening"
		Case 21 To 23
			Return "It is getting late"
		Case Else
			Return "Get a life"
	EndSwitch
EndFunc   ;==>_FuzzyTime

;some fun
Func _say($v2t, $volume)
	Local $objVoice = False, $temp
	$objVoice = ObjCreate("SAPI.SpVoice")
	; $o_speech.Voice = $o_speech.GetVoices("name=Microsoft Anna" ).Item(0)
	$objVoice.Volume = $volume
	$objVoice.Rate = 0
	$objVoice.Speak($v2t, 0)
EndFunc   ;==>_say

;===============================================================================
;
; Function Name:    _PrinterAdd()
; Description:      Connects to a Network Printer.
; Parameter(s):     $sPrinterName - Computer Network name and printer share name (\\Computer\SharedPrinter).
;                   $fDefault - Set to 1 if Printer should be set to default (optional).
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure, If Printer already exist @error = 1.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterAdd($sPrinterName, $fDefault = 0)
	If _PrinterExist($sPrinterName) Then
		SetError(1)
		Return 0
	Else
		RunWait("rundll32 printui.dll,PrintUIEntry /in /n" & $sPrinterName & " /q")
		If _PrinterExist($sPrinterName) = 0 Then
			$error_code = 1
			_put_event(1, "Could not install printer :" & $sPrinterName & " on local computer " & @ComputerName & "Does shared printer exist on host machine?", @error)
			Return 0
		EndIf
		If $fDefault = 1 Then
			_PrinterDefault($sPrinterName)
		EndIf
		Return 1
	EndIf
EndFunc   ;==>_PrinterAdd

;===============================================================================
;
; Function Name:    _PrinterDefault()
; Description:      Set a printer to default.
; Parameter(s):     $sPrinterName - The name of the printer.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterDefault($sPrinterName)
	If _PrinterExist($sPrinterName) Then
		RunWait("rundll32 printui.dll,PrintUIEntry /y /n" & $sPrinterName)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_PrinterDefault

;===============================================================================
;
; Function Name:    _PrinterDelete()
; Description:      Delete a connection to a network printer.
; Parameter(s):     $sPrinterName - Computer Network name and printer share name.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterDelete($sPrinterName)
	If _PrinterExist($sPrinterName) Then
		RunWait("rundll32 printui.dll,PrintUIEntry /dn /n" & $sPrinterName)
		If _PrinterExist($sPrinterName) Then
			Return 0
		Else
			Return 1
		EndIf
	Else
		Return 0
	EndIf
EndFunc   ;==>_PrinterDelete

;===============================================================================
;
; Function Name:    _PrinterExist()
; Description:      Check if a Printer Exist.
; Parameter(s):     $sPrinterName - The name of the printer.
; Requirement(s):
; Return Value(s):  1 - Success, 0 - Failure.
; Author(s):        Sven Ullstad - Wooltown
; Note(s):          None.
;
;===============================================================================
Func _PrinterExist($sPrinterName)
	Local $hService, $sPrinter, $sPrinterList
	$hService = ObjGet("winmgmts:{impersonationLevel=impersonate}!" & "\\" & @ComputerName & "\root\cimv2")
	If Not @error = 0 Then
		Return 0
	EndIf
	$sPrinterList = $hService.ExecQuery("Select * From Win32_Printer")
	For $sPrinter In $sPrinterList
		If StringUpper($sPrinterName) = StringUpper($sPrinter.name) Then
			Return 1
		EndIf
	Next
EndFunc   ;==>_PrinterExist

Func _ReadCmdLineParams()
	For $ic = 1 To $cmd
		Select
			Case $CmdLine[$ic] = "-update"
				; put code here
			Case $CmdLine[$ic] = "-newcomputer"
				; put code here
			Case $CmdLine[$ic] = "-repair_domain_profile"
				; put code here
			Case $CmdLine[$ic] = "-pc_diags"
				; put code here
			Case $CmdLine[$ic] = "-backup_user_profile"
				; put code here
			Case Else
				Exit
		EndSelect
	Next
EndFunc   ;==>_ReadCmdLineParams

Func generic_read_array(ByRef $file_location, $ini_section, ByRef $array_ptr)
	#cs
		
		for: To read from any standard .ini files extract the settings from a paticulare section and
		then read values into 2D array,  also will return total number of records stored within the section being read.
		
		usage: $var = generic_read_array($vars_file, "[Section]", $array)
		
		[$var] will contain a value equile to the total number of recoreds read, vey useful to know the number of valid
		recoreds within the the array
		
		variables:
		$file_location = ini file, to be used
		$ini_section = the section to be used within the ini. file
		$array_ptr = 2D array that section variables to be put into, this will need to be declared before hand
		something like $users[99][2]
		
	#ce

	Local $var, $var1, $i
	If FileExists($vars_file) Then
		$var = IniReadSection($file_location, $ini_section)
		$var1 = UBound($var) - 1

		ConsoleWrite(@CRLF & ">>>> " & $ini_section & " [" & $var1 & "]" & "<<<<" & @CRLF & @CRLF)
		If @error Then
			$error_code = 1
			;MsgBox(1, "Section does not exist", $ini_section)
			_put_event(1, "The INI file " & $vars_file & " may not exist or the section [" & $ini_section & "] within may not exist", @error)
		Else
			For $i = 1 To $var1 Step 1
				$array_ptr[$i][0] = $var[$i][0]
				$array_ptr[$i][1] = $var[$i][1]
				ConsoleWrite($i & " " & $array_ptr[$i][0] & " = " & $array_ptr[$i][1] & @CRLF)
			Next
		EndIf
	EndIf
	;MsgBox(1, $ini_section, "How meny records :" & $how_many_records)
	Return $var1
EndFunc   ;==>generic_read_array

Func _HostNameToIP($machine_name)
	TCPStartup()
	$varip = TCPNameToIP($machine_name)
	If @error Then
		$error_code = 1
		_put_event(1, "IP Name Resolution Error, Could not resolve Host :" & $machine_name & " to IP address, make sure your DNS records are correct", @error)
	EndIf
	ConsoleWrite('HostNameToIP ' & @CRLF)
	ConsoleWrite("TCPNameToIP(" & $machine_name & ") = " & TCPNameToIP($machine_name) & @CRLF)
	TCPShutdown()
	Return $varip
EndFunc   ;==>_HostNameToIP

Func _IPToHostName($machine_ip)
	TCPStartup()
	$varip = _TCPIpToName($machine_ip, 0)
	If @error Then
		$error_code = 1
		_put_event(1, "Host Name Resolution Error, Could not resolve IP :" & $machine_ip & " to Host Name, make sure your DNS records are correct", @error)
	EndIf
	ConsoleWrite(@CRLF & '>>>> TCPIpToName <<<<' & @CRLF)
	ConsoleWrite("_TCPIpToName(" & $machine_ip & ") = " & _TCPIpToName($machine_ip, 0) & @CRLF)
	TCPShutdown()
	Return $varip
EndFunc   ;==>_IPToHostName

Func _ping($host, $ttl)
	Local $var = Ping($host, $ttl)
	If $var Then
		Return $var
	Else
		Return 0
	EndIf
EndFunc   ;==>_ping

Func InternetTest()
	; 0 = internet on
	; 1 = internet off
	$InternetStat = 0
	$Val = _Ping("www.google.com", 2000)
	If $Val Then
		Return
	EndIf
	$InternetStat = 1
	Return $Val
EndFunc   ;==>InternetTest

Func _single_instance()

	;Stop script from running more than once, use                    to make the $_SingleTonKey
	;see http://www.autoitscript.com/forum/index.php?showtopic=108203&st=0&p=762946&hl=_Singleton&fromsearch=1&#entry762946 for more information
	;may need to remove this if your in a terminal enviroment

	If WinExists($_SingleTonKey) Then
		;MsgBox(16, "Another instance running", "this script is not ment to be running several instanaces at the same time")
		$error_code = 1
		_put_event(1, "Another instance running :" & $_SingleTonKey & " this script is not ment to be running several instanaces at the same time on the same PC", @error)
		Exit
	EndIf
EndFunc   ;==>_single_instance

Func test_ini_file()
	$var = crcfu()
	Switch $var
		Case 1
			_put_event(1, $vars_file & " under Section [Computer Facilities] failed integrety test", $var)
			MsgBox(16, $vars_file, "Critical Error call Computer Facilites for support")
			Exit
	EndSwitch
EndFunc   ;==>test_ini_file

Func crcfu()
	Local $cperror = 0, $i
	ConsoleWrite(@CRLF & ">>>> CFU copyright <<<<" & @CRLF & @CRLF)
	For $i = 1 To $var_copyrite
		Switch $copyrite[$i][0]
			Case "url"
				If Not $copyrite[$i][1] = "www.computer-facilities.com" Then $cperror = 1
			Case "e-mail"
				If Not $copyrite[$i][1] = "support@computer-facilities.com" Then $cperror = 1
			Case "tel"
				If Not $copyrite[$i][1] = "0414-533784" Then $cperror = 1
		EndSwitch
		ConsoleWrite($copyrite[$i][0] & " = " & $copyrite[$i][1] & @CRLF)
	Next
	If $cperror = 0 Then
		$cpmgs = "Copyright Intact"
	Else
		$cpmgs = "Copyright check failed"
	EndIf
	ConsoleWrite("(c) = " & $cpmgs & @CRLF)
	Return $cperror
EndFunc   ;==>crcfu

Func _session()
	;this to see what kinf of session is involved, including nComputing.
	Local $var
	$var = StringLeft(EnvGet("SESSIONNAME"), 3)
	Switch $var
		Case ""
			;if no session verable is found then check to see if nComputing is running.
			;had issues with ncomputing and voice dialoge
			If ProcessExists("KMMSG.EXE") Or FileExists(@ProgramFilesDir & "\NComputing vSpace\KMMSG.EXE") Then
				$voice_welcome = "No"
				$session = "nComputing"
				Sleep(1000)
			Else
				$voice_welcome = "No"
			EndIf
		Case "RDP"
			$voice_welcome = "No"
			Sleep(500)
		Case "Con"
			$session = "Uncomplied / Console"
		Case Else
			$error_code = 1
			_put_event(1, "Unsupported or unknown session type " & $session & " Defaults loaded", @error)
			_Log_Report($hLog, "Unsupported or unknown session type " & $session & " Defaults loaded", @error)
			$session = "unknown"
			Sleep(500)
	EndSwitch
	;MsgBox(1, "Session", $session)
EndFunc   ;==>_session

Func what_profile()
	Local Const $PT_LOCAL = 0
	Local Const $PT_TEMPORARY = 1
	Local Const $PT_ROAMING = 2
	Local Const $PT_MANDATORY = 4
	$tProfileType = DllStructCreate("dword ProfileType")
	DllStructSetData($tProfileType, "ProfileType", 0xFF) ; To verify it changes
	$pProfileType = DllStructGetPtr($tProfileType)
	$aRET = DllCall("UserEnv.dll", "int", "GetProfileType", "ptr", $pProfileType)
	If (@error = 0) And $aRET[0] Then
		$iProfileType = DllStructGetData($tProfileType, "ProfileType")
		Switch $iProfileType
			Case $PT_LOCAL
				$sProfileType = "Local"
			Case $PT_TEMPORARY
				$sProfileType = "Temporary"
			Case $PT_ROAMING
				$sProfileType = "Roaming"
			Case $PT_MANDATORY
				$sProfileType = "Mandatory"
			Case Else
				$sProfileType = "<INVALID>"
		EndSwitch
		ConsoleWrite("Your profile type is:  " & $sProfileType & " (" & $iProfileType & ")" & @LF)
	Else
		ConsoleWrite("Error:  @error = " & @error & "; $aRET[0] = " & $aRET[0] & @LF)
	EndIf
	Return $sProfileType
EndFunc   ;==>what_profile

Func _TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', (1), (8), (1), (8))
	WEnd
	ToolTip("")
EndFunc   ;==>_TogglePause


Func Domain_info()
	Local $colItems, $objWMIService, $objItem

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystem", "WQL", 0x10 + 0x20)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ConsoleWrite($objItem.Domain & @CRLF)
		Next
	EndIf
EndFunc   ;==>Domain_info

Func _Terminate()
	Exit
EndFunc   ;==>_Terminate

Func file_resources()
	FileInstall("files\vars.ini", "vars.ini", 0)
	FileInstall("files\malware.ini", "malware.ini", 0)
	FileInstall("files\cfu_logo.bmp", "cfu_logo.bmp", 0)
EndFunc   ;==>file_resources