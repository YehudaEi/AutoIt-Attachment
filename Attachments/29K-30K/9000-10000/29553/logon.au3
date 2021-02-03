#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=H:\My Documents\Website Work\computer-facilities.com\favicon.ico
#AutoIt3Wrapper_Outfile=logon.exe
#AutoIt3Wrapper_Res_Comment=Computer Facilities automated logon script for Windows Domain based networks running 32bit XP/Vista and Windows 7 OS.
#AutoIt3Wrapper_Res_Description=independent automated logon script
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
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

Global $Paused
;Function keys to pause or terminate the script
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{END}", "Terminate")
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

EnumerateDrives()
OSGet()
If $ostemp = "vista_win7" Then
	;this is only needed if your accessing external none windows based NAS devices using Vista or Windows 7
	;read this for more help with Vista and windows 7: http://social.technet.microsoft.com/Forums/en-CA/w7itpronetworking/thread/4606ad12-1f23-4231-8597-8e515422d57d	$operation="Vista and Windows 7"
	$accounts = "\\10.0.0.3"
	$source = "\\10.0.0.3"
	$chaos = "\\10.0.0.3"
	$homebase = "\\10.0.0.3"
	$operation = "Vista Mode"
ElseIf $ostemp = "winnt" Then
	$accounts = "\\CF-NAS1"
	$source = "\\CF-NAS1"
	$chaos = "\\CF-NAS1"
	$homebase = "\\CF-NAS1"
	$operation = "XP Mode"
ElseIf $ostemp = "server" Then
	mapdrive("s:", $source & "\source")
	Exit
Else
	MsgBox(16, "OS Incompatability", "this domain fully supports Windows NT/XP/2000, 2003, 2008, Vista and Windows 7 workstations, with partial support for Windows 64bit OS and none for the rest sorry!" & @CRLF & @CRLF & "OS version " & @OSVersion)
EndIf

If $CmdLine[0] = 0 Then
Else
	ReadCmdLineParams()
EndIf

ProgressOn("Welcome " & @UserName, "login onto " & @LogonServer & " (" & $operation & ")", "Automated Domain Access Progress", 50, 50, 16)
If _CMD(@LogonServer & '\netlogon\ifmember Domain Users') Then
	RunAs("Administrator", "cfu", "password", 4, "net time " & @LogonServer & " /SET /Y", @SW_HIDE)
	ProgressSet(5, "Removing old network shares please wait...")
	If $number_of_network_drives > 0 Then
		deldrive("*")
	Else
		;MsgBox(16, "Total Number of network drives", " number of network drives :" & $number_of_network_drives)
	EndIf
	ProgressSet(10, "Removing old network shares please wait...")
	;ShellExecuteWait("net", "use * /delete /yes", "", "", @SW_HIDE)
	ProgressSet(15, "Adding default shares")
	mapdrive("h:", $homebase & "\user$\" & @UserName)
	mapdrive("n:", $chaos & "\localcoms$")
	ProgressSet(25, "Domain Users shares")
	add_network_printers()
	ProgressSet(35, "Setup network printers")
EndIf

If _CMD(@LogonServer & '\netlogon\ifmember Domain Admins') Then
	mapdrive("s:", $source & "\source")
	ProgressSet(40, "Setup admin shares")
EndIf

If _CMD(@LogonServer & '\netlogon\ifmember quoteworks') Then
	mapdrive("w:", $accounts & "\quotewerks")
	ProgressSet(50, "Setup quoteworks share")
EndIf

If _CMD(@LogonServer & '\netlogon\ifmember core') Then
	mapdrive("x:", $accounts & "\core$")
	mapdrive("q:", $accounts & "\quickbooks$")
	mapdrive("t:", $accounts & "\clients$")
	mapdrive("u:", $accounts & "\suppliers$")
	ProgressSet(70, "Setup core shares")
EndIf

If _CMD(@LogonServer & '\netlogon\ifmember Engineers') Then
	mapdrive("s:", $source & "\source")
	ProgressSet(80, "Setup engineer share")
EndIf
ProgressSet(100, "Done", "Complete")
Sleep(500)
ProgressOff()
_users()
_welcome()

Func _users()
	Switch @UserName
		Case 'Peter'
			;MsgBox(16, "Hello", "peter")
		Case 'Tasha'
			;MsgBox(16, "Hello", "Tasha")
		Case 'Administrator'
			MsgBox(32, "OS Version Machine Diags", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
	EndSwitch
EndFunc   ;==>_users

Func _welcome()
	$local_domain = EnvGet("userdomain")
	$domain_server = EnvGet("logonserver")
	MsgBox(64, "Welcome to the " & $local_domain & " network", "Welcome " & @UserName & " to the " & $local_domain & " Network" & @CRLF & @CRLF & "you are running " & @OSVersion & " Version OS" & @CRLF & @CRLF & "If you have any problems or questions with your account please contact Computer Facilities support on 0414-533784" & @CRLF & @CRLF & "Enjoy" & @CRLF & @CRLF & "Logon script in " & $operation & " login on " & @ComputerName & " via Server " & $domain_server)
EndFunc   ;==>_welcome

Func add_network_printers()
	For $x = 0 To $var_printer Step 1
		_PrinterAdd($network_printers[$x], 1)
	Next
EndFunc   ;==>add_network_printers

Func mapdrive($DriveLtr, $DrivePath)
	DriveMapAdd($DriveLtr, $DrivePath, 1)
	Switch @error
		Case 1
			MsgBox(16, "Error", "An unknown error occured on " & $DrivePath & " trying to be mapped as local drive " & $DriveLtr)
		Case 2
			MsgBox(16, "Error", "Access to the remote share " & $DrivePath & " was denied")
		Case 3
			MsgBox(16, "Error", "The device/drive " & $DriveLtr & " is already assigned")
		Case 4
			MsgBox(16, "Error", "Invalid device " & $DriveLtr & " name")
		Case 5
			MsgBox(16, "Error", "Invalid remote share :" & $DrivePath)
		Case 6
			MsgBox(16, "Error", "Invalid password")
		Case Else
			;MsgBox(64, "Completed!", "Mapped " & $DriveLtr & " to share " & $DrivePath)
	EndSwitch
EndFunc   ;==>mapdrive

Func deldrive($drived)
	Local $i = $number_of_network_drives
	If $drived = "*" Then
		Do
			DriveMapDel($network_drives[$i] & ":")
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
EndFunc   ;==>deldrive

Func EnumerateDrives()
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
EndFunc   ;==>EnumerateDrives


Func _CMD($command, $workingdir = '')
	Return RunWait('"' & @ComSpec & '" /c ' & $command, $workingdir, @SW_HIDE)
EndFunc   ;==>_CMD

Func OSGet()
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
	ArchGet()
EndFunc   ;==>OSGet

Func ArchGet()
	Switch @OSArch
		Case "X86"
		Case Else
			MsgBox(32, "32/64bit Architecture", "User " & @UserName & " on computer " & @ComputerName & " running OS " & @OSVersion & " " & @OSArch & " Architecture", 10)
			Exit
	EndSwitch
EndFunc   ;==>ArchGet

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
	For $i = 1 To $cmd
		Select
			Case $CmdLine[$i] = "-update"
				; put code here
			Case $CmdLine[$i] = "-newcomputer"
				; put code here
			Case $CmdLine[$i] = "-repair_domain_profile"
				; put code here
			Case $CmdLine[$i] = "-pc_diags"
				; put code here
			Case $CmdLine[$i] = "-backup_user_profile"
				; put code here
			Case Else
				Exit
		EndSelect
	Next
EndFunc   ;==>ReadCmdLineParams

Func TogglePause()
	$Paused = Not $Paused
	While $Paused
		Sleep(100)
		ToolTip('Script is "Paused"', (1), (8), (1), (8))
	WEnd
	ToolTip("")
EndFunc   ;==>TogglePause

Func Terminate()
	Exit
EndFunc   ;==>Terminate