#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=H:\My Documents\Website Work\computer-facilities.com\favicon.ico
#AutoIt3Wrapper_Outfile=logon.exe
#AutoIt3Wrapper_Res_Comment=Computer Facilities automated logon script for Windows Domain based networks running 32bit XP/Vista and Windows 7 OS.
#AutoIt3Wrapper_Res_Description=independent automated logon script
#AutoIt3Wrapper_Res_Fileversion=1.1.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Computer Facilities
#AutoIt3Wrapper_Res_Field=Made By| Peter R. Atkin
#AutoIt3Wrapper_Res_Field=date|7th Feb 2010
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Constants.au3>
#include <Array.au3>
#include <NetShare.au3>
#include <Misc.au3>
#include <AD.au3>

Global Const $_SingleTonKey = "07c9623c-2ffb-4e6e-8fd9-f824ede2e9ac" ; e.g. GUID

Global $Paused
;Function keys to pause or terminate the script
HotKeySet("{PAUSE}", "_TogglePause")
HotKeySet("{END}", "_Terminate")
Global $ostemp

Global $network_printers[2]
;last printer becomes the default
$network_printers[0] = "\\dc-2008\hp4700n"
$network_printers[1] = "\\dc-2008\hp4250n"
Global $var_printer = UBound($network_printers) - 1
Global $cmd = UBound($CmdLine) - 1
Global $network_drives[24]
Global $number_of_network_drives

;$strURL = "http://www.computer-facilities.com"
;_SetIEHomepage($strURL)

_single_instance() ; comment this line out if in multi user enviroment.
_EnumerateDrives()
_OSGet()

If $ostemp = "vista_win7" Then
	;this is only needed if your accessing external none windows based NAS devices using Vista or Windows 7
	;read this for more help with Vista and windows 7: http://social.technet.microsoft.com/Forums/en-CA/w7itpronetworking/thread/4606ad12-1f23-4231-8597-8e515422d57d	$operation="Vista and Windows 7"
	$public = "\\10.0.0.4"
	$accounts = "\\10.0.0.3"
	$source = "\\10.0.0.3"
	$chaos = "\\10.0.0.3"
	$homebase = "\\10.0.0.3"
	$operation = "Vista Mode"
ElseIf $ostemp = "winnt" Then
	$public = "\\public"
	$accounts = "\\CF-NAS1"
	$source = "\\CF-NAS1"
	$chaos = "\\CF-NAS1"
	$homebase = "\\CF-NAS1"
	$operation = "XP Mode"
ElseIf $ostemp = "server" Then
	Exit
Else
	MsgBox(16, "OS Incompatability", "this domain fully supports Windows NT/XP/2000, 2003, 2008, Vista and Windows 7 workstations, with partial support for Windows 64bit OS and none for the rest sorry!" & @CRLF & @CRLF & "OS version " & @OSVersion)
EndIf

If $CmdLine[0] = 0 Then
Else
	ReadCmdLineParams()
EndIf

TrayTip("Logon script running", $operation, 7, 1)

ProgressOn("Welcome " & @UserName, "login onto " & @LogonServer & " (" & $operation & ")", "Automated Domain Access Progress", 50, 50, 16)
_AD_Open()
If _AD_isMemberOf("cfu users", @UserName) Then
	; cannot use 'domain users' seems to be some techci reason why that will not work, and make sure you usergroups do not have groups within as they seem not to be read.
	RunAsWait("Administrator", "cfu", "password", 4, "net time " & @LogonServer & " /SET /Y", @SW_HIDE)
	ProgressSet(10, "Removing old network shares please wait...")
	If $number_of_network_drives > 0 Then
		_delmappeddrive("*")
	EndIf
	ProgressSet(15, "Adding default shares")
	_mapdrive("h:", $homebase & "\user$\" & @UserName)
	_mapdrive("p:", $public & "\public")
	ProgressSet(25, "Domain Users home share")
	ProgressSet(35, "Setting up network printers")
	_add_network_printers()
EndIf

If _AD_isMemberOf("Domain Admins", @UserName) Then
	_mapdrive("s:", $source & "\source")
	ProgressSet(40, "Setup admin shares")
EndIf

If _AD_isMemberOf("quoteworks", @UserName) Then
	_mapdrive("w:", $accounts & "\quotewerks")
	ProgressSet(50, "Setup quoteworks share")
EndIf

If _AD_isMemberOf("core", @UserName) Then
	_mapdrive("x:", $accounts & "\core$")
	_mapdrive("q:", $accounts & "\quickbooks$")
	_mapdrive("t:", $accounts & "\clients$")
	_mapdrive("u:", $accounts & "\suppliers$")
	ProgressSet(70, "Setup core shares")
EndIf

If _AD_isMemberOf("Engineers", @UserName) Then
	_mapdrive("s:", $source & "\source")
	ProgressSet(80, "Setup engineer share")
EndIf
_AD_Close()

_users()
ProgressSet(100, "Done", "Complete")
Sleep(500)
ProgressOff()
Sleep(500)
_welcome()

Func _users()
	Switch @UserName
		Case "peter"
			;_mapdrive("n:", $chaos & "\localcoms$")
		Case "tasha"
			;_mapdrive("n:", $chaos & "\localcoms$")
			_mapdrive("m:", "\\10.0.0.53\Tasha  Mabonga-Atkin's Tim")
		Case "accounts"
			;_mapdrive("n:", $chaos & "\localcoms$")
		Case "engineers"
			;_mapdrive("n:", $chaos & "\localcoms$")
		Case "administrator"
			MsgBox(32, "OS Version Machine Diags", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
	EndSwitch
EndFunc   ;==>_users

Func _welcome()
	$local_domain = EnvGet("userdomain")
	$domain_server = EnvGet("logonserver")
	TCPStartup()
	MsgBox(64, "Your IP is: " & TCPNameToIP(@ComputerName) & " network", "Welcome " & @UserName & " to the " & $local_domain & " Network" & @CRLF & @CRLF & "you are running " & @OSVersion & " Version OS" & @CRLF & @CRLF & "If you have any problems or questions with your account please contact Computer Facilities support on 0414-533784" & @CRLF & @CRLF & "Enjoy" & @CRLF & @CRLF & "Logon script in " & $operation & " login on from " & @ComputerName & " using Server " & $domain_server)
	TCPShutdown()
EndFunc   ;==>_welcome

Func _add_network_printers()
	For $x = 0 To $var_printer Step 1
		_PrinterAdd($network_printers[$x], 1)
	Next
EndFunc   ;==>_add_network_printers

Func _mapdrive($DriveLtr, $DrivePath)
	DriveMapAdd($DriveLtr, $DrivePath, 1)
	Switch @error
		Case 1
			MsgBox(16, "OMG Error", "An unknown error occured on " & $DrivePath & " trying to be mapped as local drive " & $DriveLtr)
		Case 2
			MsgBox(16, "Access Error", "Access to the remote share " & $DrivePath & " was denied")
		Case 3
			MsgBox(16, "Delete Drive Error", "The device/drive " & $DriveLtr & " is already assigned")
		Case 4
			MsgBox(16, "Device Error", "Invalid device " & $DriveLtr & " name")
		Case 5
			MsgBox(16, "Remote Drive Error", "Invalid remote share :" & $DrivePath)
		Case 6
			MsgBox(16, "Password Error", "Invalid password")
		Case Else
			;MsgBox(64, "Completed!", "Mapped " & $DriveLtr & " to share " & $DrivePath)
	EndSwitch
	Sleep(500)
EndFunc   ;==>_mapdrive

Func _delmappeddrive($drived)
	Local $i = $number_of_network_drives
	If $drived = "*" Then
		Do
			DriveMapDel($network_drives[$i] & ":")
			Sleep(500)
			$i = $i - 1
		Until $i = 0
	Else
		DriveMapDel($drived)
		Switch @error
			Case 0
				;MsgBox(16, "Error", "An unknown error occured trying to delete local drive :" & $network_drives[$i] & ":")
			Case Else
				;MsgBox(64, "Completed!", "Deleted " & $network_drives[$i])
		EndSwitch
	EndIf
EndFunc   ;==>_delmappeddrive

Func _EnumerateDrives()
	Local $x = 1
	Local $y = 1
	For $dl = 72 To 89 ; (H-Y)
		$network_drives[$x] = Chr($dl)
		$drive = Chr($dl) & ":\"
		$drive_letter = Chr($dl)
		DriveGetFileSystem($drive)
		If @error = 0 Then
			;MsgBox(16, "Network Drive", "Drive in Use " & $drive & @CRLF & @CRLF & " Array Varible :" & $network_drives[$x])
			$x = $x + 1
		Else
			;MsgBox(16,"New Drive " & $network_drives[$y], "Free Drive " & $drive_letter)
			$y = $y + 1
		EndIf
	Next
	$number_of_network_drives = $x - 1
	Return $number_of_network_drives
	;MsgBox(16, "Drives", "Number of network drives in use are " & $number_of_network_drives)
EndFunc   ;==>_EnumerateDrives

Func _CMD($command, $workingdir = '')
	Return RunWait('"' & @ComSpec & '" /c ' & $command, $workingdir, @SW_HIDE)
EndFunc   ;==>_CMD

Func _OSGet()
	Switch @OSVersion
		Case "WIN_7"
			$ostemp = "vista_win7"
		Case "WIN_XP"
			$ostemp = "winnt"
		Case "Win_2000"
			$ostemp = "winnt"
		Case "WIN_VISTA"
			$ostemp = "vista_win7"
		Case "WIN_2008"
			$ostemp = "server"
		Case "WIN_2008R2"
			$ostemp = "server"
		Case "WIN_2003"
			$ostemp = "server"
		Case Else
			MsgBox(32, "OS Version Machine Diags", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
			Exit
	EndSwitch
	_ArchGet()
EndFunc   ;==>_OSGet

Func _ArchGet()
	Switch @OSArch
		Case "X86"
		Case Else
			MsgBox(32, "32/64bit Architecture", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
			Exit
	EndSwitch
EndFunc   ;==>_ArchGet

;$strURL = "http://www.computer-facilities.com"
;If _SetIEHomepage($strURL) Then msgbox(0,"Homepage Set","Successfull")
Func _SetIEHomepage($strURL)
	Return RegWrite("HKCU\SOFTWARE\Microsoft\Internet Explorer\Main", "Start Page", "REG_SZ", $strURL)
EndFunc   ;==>_SetIEHomepage

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

Func ReadCmdLineParams()
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
EndFunc   ;==>ReadCmdLineParams

Func _single_instance()
	;Stop script from running more than once, use http://guidgen.com to make the $_SingleTonKey
	;see http://www.autoitscript.com/forum/index.php?showtopic=108203&st=0&p=762946&hl=_Singleton&fromsearch=1&#entry762946 for more information
	;may need to remove this if your in a terminal enviroment
	If WinExists($_SingleTonKey) Then
		MsgBox(16, "Another instance running", "this script is not ment to be running several instanaces at the same time")
		Exit
	EndIf
EndFunc   ;==>_single_instance

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