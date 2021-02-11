#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=files\favicon.ico
#AutoIt3Wrapper_Outfile=logon.exe
#AutoIt3Wrapper_Res_Comment=Computer Facilities automated logon script for Windows Domain based networks running 32bit XP/Vista and Windows 7 OS.
#AutoIt3Wrapper_Res_Description=Care Uganda independent automated logon script
#AutoIt3Wrapper_Res_Fileversion=1.1.0.14
#AutoIt3Wrapper_Res_FileVersion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=Computer Facilities(Uganda) Ltd.
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_Res_Field=Made By| Peter R. Atkin
#AutoIt3Wrapper_Res_Field=date|08 Auguest 2010
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
	29-08-2010 Put in malware scan very lossly based upon known Mmalware process list  http://pcpitstop.com/libraries/process/topmalicous and MaXoFF
	29-08-2010 Putin in generice array reader to simply code

	Things to do:
	- A better way to do the Progress bar
	- Add facility to delete all printers (not as easy as it sounds)
	- Better Error control for drives / hosts that are not present
	- detect if computer and/or user is newly joined to the domain
	- silent install of main applications if not present on client system (already done as a seperate app, now need to intergrate it)
	- Redo .ini file paramitors to give more fexability
	- Tidy up script (always present)
	- move over to generic array reader where possible
	+ Malware done

	Things to Note:
	- If your accessing external none windows based NAS devices using Vista or Windows 7 as a client then read the below URL for more
	help with Vista and windows 7, the script sorts out the name to IP but you will still need to modifiy the security setting where applicable.
	http://social.technet.microsoft.com/Forums/en-CA/w7itpronetworking/thread/4606ad12-1f23-4231-8597-8e515422d57d	$operation="Vista and Windows 7"

	Bugs:
	08-07-2010 seems that the homebase is not working in Vista mode as expected note the whatever server you use the user home directories have to be directly under a share name of 'user$' : SOLVED

	Accreditations and Referances
	Drive mapping: 		http://www.autoitscript.com/forum/index.php?showtopic=110567&st=0&gopid=776497&#entry776497
	User Profile Type: 	http://www.autoitscript.com/forum/index.php?showtopic=113711
	Splash Screen:		http://www.autoitscript.com/forum/index.php?showtopic=115441
	IP Stuff:			http://www.autoitscript.com/forum/index.php?showtopic=82733&st=0&p=625302&hl=IP%20gateway&fromsearch=1&#entry625302
	IP Stuff: 			http://www.autoitscript.com/forum/index.php?showtopic=109887&st=0&gopid=772563&#entry772563
	IP Stuff: 			http://msdn.microsoft.com/en-us/library/aa394217(VS.85).aspx
	Malware Scanner:	http://www.autoitscript.com/forum/index.php?showtopic=87144&st=0&gopid=827573&#entry827573

	Dependencies and versions:
	Autoit 3.3.6.1		http://www.autoitscript.com/autoit3/downloads.shtml
	UDF - AD 0.39 		http://www.autoitscript.com/forum/index.php?showtopic=106163
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

;Function keys to pause or terminate the script
HotKeySet("{PAUSE}", "_TogglePause")
HotKeySet("{END}", "_Terminate")
Global $Paused

Global $vars_file = @ScriptDir & "\vars.ini"
Global $script_version = FileGetVersion(@ScriptFullPath, "FileVersion")
Global $mediatype = DriveGetType(StringLeft(@ScriptFullPath, 2))
Global $user_profile_type = what_profile()

Global Const $_SingleTonKey = "07c9623c-2ffb-4e6e-8fd9-f824ede2e9ac" ; e.g. GUID
_single_instance() ; comment this line out if in multi user enviroment.
Global $obj[499][2], $nobj, $groups[99][2], $domainusersharegroup[99][2], $network_drives[24], $group_printers[99][2], $malware[499][2], $pbar

;some default settings just in case
Global $voice_welcome = "Yes", $homebase, $homebase_drive, $homebase_post, $userlogonname, $tempfile_clean = "Yes", $IE_clean = "No", $empty_bins = "Yes", $company = "Computer Facilities", $splash = "Yes", $diags = 0
Global $local_IP = GetLanIP(), $ostemp
Global $cmd = UBound($CmdLine) - 1
Global $error_code = 0
Global $session = ""
Global $ostemp = _OSGet()
Global $greeting = _FuzzyTime()

file_resources()
read_settings_array()
_session()
test_ini_file()

$var_malware = generic_read_array(@ScriptDir & "\malware.ini", "Malware", "$malware[$i][0]", "$malware[$i][1]")
scan_malware($var_malware)

If $ostemp = "Server Mode" Then Exit
If Not $CmdLine[0] = 0 Then _ReadCmdLineParams()

_AD_Open()
If @error Then
	_put_event(1, "Active Directory error :" & @error & " AD connection could not be opened", @error)
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
EndIf

If _AD_IsMemberOf("domain users", @UserName, True) Then
	_put_event(4, "logon script started", @error)
	ProgressOn($greeting & " " & @UserName & " | Profile " & $user_profile_type, "login onto " & @LogonServer & " (" & $ostemp & ")", "Automated Domain Access Progress", 50, 50, 16)

	If $voice_welcome = "Yes" Then _say($greeting & " " & @UserName & ", and welcome to the " & $company & " Network, please wait while you are being logged onto the system", 50)

	TrayTip("Logon script running", $ostemp & " Local IP: " & $local_IP, 7, 1)
	ProgressSet(2, "Finding network drives in use...")
Else
	If $diags = 1 Then MsgBox(16, "Invalid User", "Sorry you apper not to have sufficent rights to use this domain")
	_put_event(4, "Invalid User ID: " & @UserName & " tried to log on", @error)
	$error_code = 1
	Exit
EndIf

ProgressSet(7, "Removing old network shares please wait...")
_delmappeddrive("*")
ProgressSet(12, "Adding default shares")
_add_network_shares("domain users")
maphomeshare()
_ifmember()
_AD_Close()

ProgressSet(90, "System Cleanup", "Started")
If $tempfile_clean = "Yes" Then temp_clean()
If $empty_bins = "Yes" Then EmptyRecycleBin()
ProgressSet(91, "System Cleanup", "Complete")
Sleep(500)
ProgressSet(92, "IE Cleanup", "Started")
If $IE_clean = "Yes" Then IE_Clean()
ProgressSet(95, "IE Cleanup", "Complete")
_users()
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

; >>>> no need to edit beyond this point..

Func maphomeshare()
	If StringLen($homebase) > 0 Then
		Switch $ostemp
			Case "XP Mode"
				ConsoleWrite('XP Mode' & @CRLF)
				ProgressSet(15, "Home share" & $homebase & $userlogonname)
				_mapdrive($homebase_drive, $homebase & $userlogonname)
			Case "Vista Mode"
				ConsoleWrite('Vista Mode' & @CRLF)
				Local $var_host = _StringBetween($homebase, "\\", "\", -1)
				Local $var_ip = _HostNameToIP($var_host[0])
				ConsoleWrite('Home Share IP: ' & $var_ip & @CRLF)
				Local $rootstartlocation = StringInStr($homebase, "\", 0, 3)
				Local $roothomeshare = StringTrimLeft($homebase, $rootstartlocation - 1)
				Local $var = "\\" & $var_ip & $roothomeshare
				ProgressSet(15, " Home share " & $homebase & $userlogonname)
				$homebase = $var & $userlogonname
				_mapdrive($homebase_drive, $homebase)
				ConsoleWrite('Home Share UNC: ' & $homebase & @CRLF)
		EndSwitch
	EndIf
EndFunc   ;==>maphomeshare

Func _users()
	Local $i, $var_u
	TrayTip("Individual preferences", "setup for " & @UserName, 7, 1)
	ProgressSet(95, "Find User Shares", "Scanning for user shares")
	$var = IniReadSection($vars_file, @UserName)
	If @error Then
		ProgressSet(97, "Personal User Shares", "No User Shares Found")
	Else
		_add_network_shares(@UserName)
	EndIf
	ProgressSet(98, "Personal User Shares", "User Shares attached")
	Sleep(500)
EndFunc   ;==>_users

Func _ifmember()
	_read_domain_groups()
	Local $i
	Local $progress = 20
	Local $progress_end = 85
	;_AD_Open()
	For $i = 1 To _read_domain_groups() Step 1
		$var_g = $groups[$i][1]
		If _AD_isMemberOf($var_g, @UserName) Then
			_add_network_shares($var_g)
			$pbar = $progress + ($progress_end / (_read_domain_groups()) + $i)
			ProgressSet($pbar, "Setup Group " & $var_g & " shares")
		Else
			$pbar = $progress + ($progress_end / (_read_domain_groups()) + $i)
			_add_network_group_printers($var_g, $pbar)
		EndIf
	Next
	;_AD_Close()
EndFunc   ;==>_ifmember

Func _read_domain_groups()
	ConsoleWrite('Domain Groups ' & @CRLF)
	Local $i
	For $i = 1 To read_array($vars_file, "Groups") Step 1
		$groups[$i][0] = $obj[$i][0]
		$groups[$i][1] = $obj[$i][1]
		ConsoleWrite('Key : ' & $groups[$i][0] & @CRLF)
		ConsoleWrite('Value : ' & $groups[$i][1] & @CRLF)
	Next
	$nobj = $i
	Return $nobj
EndFunc   ;==>_read_domain_groups

Func _add_network_shares($share_group)
	Local $tnons = read_array($vars_file, $share_group)
	For $j = 1 To $tnons
		$DriveLtr1 = $obj[$j][0]
		$DrivePath1 = $obj[$j][1]
		If $diags = 1 Then MsgBox(4096, "Total Network Shares : " & $tnons, " Drive : " & $DriveLtr1 & $DrivePath1)
		$ostemp = _OSGet()
		Switch $ostemp
			Case "XP Mode"
				_mapdrive($DriveLtr1, $DrivePath1)
			Case "Vista Mode"
				$var_host = _StringBetween($DrivePath1, "\\", "\", -1)
				$var_ip = _HostNameToIP($var_host[0])
				$var = StringReplace($DrivePath1, $var_host[0], $var_ip, 0, 2)
				_mapdrive($DriveLtr1, $var)
		EndSwitch
	Next
EndFunc   ;==>_add_network_shares

Func _add_network_group_printers($var, $pbar)
	Local $j, $group, $printer
	For $j = 1 To read_array($vars_file, "Group Printers") Step 1
		If $diags = 1 Then MsgBox(4096, "Number of Printers :" & $nobj, "Key: " & $obj[$j][0] & @CRLF & "Value: " & $obj[$j][1])
		$group_printers[$j][0] = $obj[$j][0]
		$group_printers[$j][1] = $obj[$j][1]
		$group = $group_printers[$j][0]
		$printer = $group_printers[$j][1]
		If $var = $group Then
			If $diags = 1 Then MsgBox(1, $var, "Group : " & $group & @CRLF & "Printer : " & $printer)
			ProgressSet($pbar + read_array($vars_file, "Group Printers") + 1, "Setting up" & $printer)
			Sleep(250)
			_PrinterAdd($printer, 0)
		EndIf
	Next
EndFunc   ;==>_add_network_group_printers

Func read_array($ini_file, $ini_section)
	If FileExists($ini_file) Then
		$var = IniReadSection($ini_file, $ini_section)
		If @error Then
			$error_code = 1
			_put_event(1, "The INI file " & $ini_file & " may not exist or the section [" & $ini_section & "] within may not exist", @error)
		Else
			For $i = 1 To $var[0][0] Step 1
				$obj[$i][0] = $var[$i][0]
				$obj[$i][1] = $var[$i][1]
			Next
			$nobj = $var[0][0]
			Return $nobj
		EndIf
	Else
	EndIf
EndFunc   ;==>read_array

Func read_settings_array()
	Local $var, $len, $varend
	$var = IniReadSection($vars_file, "Settings")
	ConsoleWrite('Basic .INI Settings ' & @CRLF)
	For $i = 1 To UBound($var) - 1
		Switch $var[$i][0]
			Case "voice_welcome"
				$voice_welcome = $var[$i][1]
			Case "homebase"
				$len = StringLen($var[$i][1])
				If $len = 0 Then
					ConsoleWrite('No Home Share for user : ' & @UserName & @CRLF)
					_put_event(4, "No Home Share found in the .ini file for user " & @UserName & " no home share shall be added", @error)
				Else
					$homebase = $var[$i][1]
					$var_host = _StringBetween($homebase, "\\", "\", -1)
					If @error = 1 Then
						MsgBox(1, "Setting error! [" & @error & "]", "The varible [" & $var[$i][0] & "] does not seem properly formatted. " & @CRLF & "[" & $homebase & "]" & @CRLF & "please check that it uses normal UNC format e.g. \\server\share\")
						Exit
					EndIf
					$varend = StringRight($homebase, 1)
					If $varend <> "\" Then
						MsgBox(1, "Setting error! [" & @error & "]", "The varible [" & $var[$i][0] & "] does not seem properly formatted. " & @CRLF & "[" & $homebase & "]" & @CRLF & "please check that it uses normal UNC format e.g. \\server\share\")
						Exit
					EndIf
				EndIf
			Case "homebase_drive"
				$homebase_drive = $var[$i][1]
			Case "homebase_post"
				$homebase_post = $var[$i][1]
				$len = StringLen($homebase_post)
				If $len = 0 Then
					$userlogonname = @UserName
				Else
					$userlogonname = @UserName & $homebase_post
				EndIf
				If $diags = 1 Then MsgBox(1, "Username", $userlogonname)
			Case "tempfile_clean"
				$tempfile_clean = $var[$i][1]
			Case "IE_clean"
				$IE_clean = $var[$i][1]
			Case "empty_bins"
				$empty_bins = $var[$i][1]
			Case "Company"
				$company = $var[$i][1]
			Case "Splash"
				$splash = $var[$i][1]
			Case "Diags"
				$diags = $var[$i][1]
			Case Else
				MsgBox(1, "Setting error! [" & @error & "]", "The varible [" & $var[$i][0] & "] does not exist in " & @CRLF & $vars_file & ", please check that this exists and can be used!")
				Exit
		EndSwitch
		ConsoleWrite('Key : ' & $var[$i][0] & @CRLF)
		ConsoleWrite('Value : ' & $var[$i][1] & @CRLF)
	Next
EndFunc   ;==>read_settings_array

Func _mapdrive($DriveLtr, $DrivePath)
	Local $var, $var_DrivePath
	$var_DrivePath = _StringBetween($DrivePath, "\\", "\")
	$var = $var_DrivePath[0]
	If Ping($var, 25) Then
		; so now the function will not try to connect to a device that is not present,
		; make sure your firewall allows ICBM echo requests.
		Sleep(250)
		DriveMapAdd($DriveLtr, $DrivePath, 8)
		Switch @error
			Case 1
				_put_event(1, "O.M.G Error, An unknown error occured on " & $DrivePath & " trying to be mapped as local drive " & $DriveLtr & " maybe end device is not avilable for mapping", @error)
				If $diags = 1 Then MsgBox(1, "O.M.G Error, An unknown error occured on", $DrivePath & " trying to be mapped as local drive " & $DriveLtr & @CRLF & "maybe end device is not avilable for mapping")
				$error_code = 1
			Case 2
				_put_event(1, "Access Error, Access to the remote share " & $DrivePath & " was denied", @error)
				$error_code = 1
			Case 3
				_put_event(4, "Map Drive Error, The device/drive " & $DriveLtr & " is already assigned and will be deleted", @error)
				_delmappeddrive($DriveLtr)
			Case 4
				_put_event(1, "Device Error, Invalid device " & $DriveLtr & " name", @error)
				$error_code = 1
			Case 5
				_put_event(1, "Connect to Remote Share Error, Invalid remote share :" & $DrivePath, @error)
				$error_code = 1
			Case 6
				_put_event(1, "Password Error for user :" & @UserName & " Invalid password for " & $DriveLtr & $DrivePath, @error)
				$error_code = 1
			Case Else
				Sleep(50)
				If $diags = 1 Then MsgBox(64, "Completed!", "Mapped " & $DriveLtr & " to share " & $DrivePath)
		EndSwitch
	Else
		$error_code = 1
		_put_event(1, "Share (" & $DriveLtr & $DrivePath & ") could not be added. The host " & $var_DrivePath[0] & " device is not present or pingable!, make sure host firwall allows ping requests", @error)
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
	For $mw = 1 To $var_malware Step 1
		Local $mwf = 0
		If ProcessExists($malware[$mw][0]) Then
			ProcessClose($malware[$mw][0])
			Switch @error
				;_put_event(1, "Kill Process Faile [" & $malware[$mw][0] & "] failed to terminate hostile process, you may need Administrator rights", @error)
				Case 1
					MsgBox(11, "OpenProcess Failed", "Process [" & $malware[$mw][0] & "] failed to terminate hostile process, call support")
					ConsoleWrite("OpenProcess Failed [" & $malware[$mw][0] & "] you may need Administrator rights")
				Case 2
					MsgBox(11, "AdjustTokenPrivileges Failed", "Process [" & $malware[$mw][0] & "] failed to terminate hostile process, call support")
					ConsoleWrite("AdjustTokenPrivileges Failed [" & $malware[$mw][0] & "] you may need Administrator rights")
				Case 3
					MsgBox(11, "TerminateProcess Failed", "Process [" & $malware[$mw][0] & "] failed to terminate hostile process, you may need Administrator rights")
					ConsoleWrite("Terminate Process Failed [" & $malware[$mw][0] & "]" & @CRLF)
				Case 4
					MsgBox(11, "Cannot verify if process exists", "Process [" & $malware[$mw][0] & "] failed to terminate hostile process, call support")
					ConsoleWrite("Cannot verify if process exists [" & $malware[$mw][0] & "] you may need Administrator rights")
			EndSwitch
			$mwf = $mwf + 1
		EndIf
	Next
EndFunc   ;==>scan_malware

Func generic_read_array($vars_file, $ini_section, $str_var1, $str_var2)
	Local $var
	If FileExists($vars_file) Then
		$var = IniReadSection($vars_file, $ini_section)
		ConsoleWrite(@CRLF & ">>>> " & $ini_section & " <<<<" & @CRLF & @CRLF)
		If @error Then
			$error_code = 1
			;MsgBox(1, "Section does not exist", $ini_section)
			_put_event(1, "The INI file " & $vars_file & " may not exist or the section [" & $ini_section & "] within may not exist", @error)
		Else
			For $i = 1 To $var[0][0] Step 1
				$malware[$i][0] = $var[$i][0]
				$malware[$i][1] = $var[$i][1]
				;Execute($str_var1 = $var[$i][0])
				;Execute($str_var2 = $var[$i][1])
				ConsoleWrite($var[$i][0] & " = " & $var[$i][1] & @CRLF)
			Next
			$nobj = $var[0][0]
			Return $nobj
		EndIf
	Else
	EndIf
EndFunc   ;==>generic_read_array

Func _ping($host)
	$var1 = Ping($host, 1000)
	If $var1 Then Return $var1 & "/ms" & @CRLF
	Switch @error
		Case 1
			Return "Host is offline" & @CRLF
		Case 2
			Return "Host is unreachable" & @CRLF
		Case 3
			Return "Bad destination" & @CRLF
		Case 4
			Return "Other errors" & @CRLF
	EndSwitch
EndFunc   ;==>_ping


Func EmptyRecycleBin()
	Local $var = DriveGetDrive("FIXED")
	;MsgBox(4096, "", "Found " & $var[0] & " Fixed drives")
	For $i = 1 To $var[0]
		FileRecycleEmpty($var[$i])
		Switch @error
			Case 0
				; sucess not needed just there for completness
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

Func _deleteautorun($drive)
EndFunc   ;==>_deleteautorun

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
				ShellExecute("http://www.computer-facilities.com")
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
	ConsoleWrite('TCPIpToName ' & @CRLF)
	ConsoleWrite("_TCPIpToName(" & $machine_ip & ") = " & _TCPIpToName($machine_ip, 0) & @CRLF)
	TCPShutdown()
	Return $varip
EndFunc   ;==>_IPToHostName

Func _single_instance()
	;Stop script from running more than once, use http://guidgen.com to make the $_SingleTonKey
	;see http://www.autoitscript.com/forum/index.php?showtopic=108203&st=0&p=762946&hl=_Singleton&fromsearch=1&#entry762946 for more information
	;may need to remove this if your in a terminal enviroment
	If WinExists($_SingleTonKey) Then
		;MsgBox(16, "Another instance running", "this script is not ment to be running several instanaces at the same time")
		$error_code = 1
		_put_event(1, "Another instance running :" & $_SingleTonKey & " this script is not ment to be running several instanaces at the same time on the same PC", @error)
		Exit (2)
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
	Local $cperror = 0
	$var = IniReadSection($vars_file, "Computer Facilities")
	ConsoleWrite('CFU copyright ' & @CRLF)
	For $i = 1 To UBound($var) - 1
		Switch $var[$i][0]
			Case "url"
				If Not $var[$i][1] = "www.computer-facilities.com" Then $cperror = 1
			Case "e-mail"
				If Not $var[$i][1] = "support@computer-facilities.com" Then $cperror = 1
			Case "tel"
				If Not $var[$i][1] = "0414-533784" Then $cperror = 1
		EndSwitch
		ConsoleWrite('Key : ' & $var[$i][0] & @CRLF)
		ConsoleWrite('Value : ' & $var[$i][1] & @CRLF)
	Next
	ConsoleWrite('Value : ' & $cperror & @CRLF)
	$var = $cperror
	Return $var
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
			$voice_welcome = "No"
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

Func _Terminate()
	Exit
EndFunc   ;==>_Terminate

Func file_resources()
	FileInstall("files\vars.ini", @ScriptDir & "\vars.ini", 0)
	FileInstall("files\cfu_logo.bmp", @ScriptDir & "\cfu_logo.bmp", 0)
	FileInstall("files\malware.ini", @ScriptDir & "\malware.ini", 0)
EndFunc   ;==>file_resources