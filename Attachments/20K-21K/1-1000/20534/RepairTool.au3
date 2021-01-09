#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_compression=4
#AutoIt3Wrapper_res_description=Multiple Windows XP Repair Tools
#AutoIt3Wrapper_Res_Fileversion=0.5.0.6
#AutoIt3Wrapper_res_fileversion_autoincrement=y
#AutoIt3Wrapper_res_language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_res_File_Add=secedit.exe
#AutoIt3Wrapper_res_File_Add=subinacl.exe
#AutoIt3Wrapper_run_tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstants.au3>
#include <Process.au3>

Opt("TrayIconHide", 1)

#region Global Variables
$winDir = EnvGet("windir")
$systemDrive = EnvGet("SystemDrive")
$mainWindowTitle = "Windows Repair Tool"
#endregion Global Variables

$hGUI = GUICreate($mainWindowTitle, 400, 350)
Opt("GUICoordMode", 1)

#region Drop-Down Menu
$fileMenu = GUICtrlCreateMenu("&File")
$selectAllProgramMenuItem = GUICtrlCreateMenuItem("&Select All", $fileMenu)
$selectNoneProgramMenuItem = GUICtrlCreateMenuItem("Select &None", $fileMenu)
$seporatorProgramMenuItem = GUICtrlCreateMenuItem("", $fileMenu)
$exitProgramMenuItem = GUICtrlCreateMenuItem("E&xit", $fileMenu)
$helpMenu = GUICtrlCreateMenu("&Help")
$aboutMenuItem = GUICtrlCreateMenuItem("&About...", $helpMenu)
#endregion Drop-Down Menu

#region Repair Options
$wuCheckBox = GUICtrlCreateCheckbox("Repair Windows Update", 20, 10)
$msiCheckBox = GUICtrlCreateCheckbox("Repair Windows Installer", 200, 10)
$cryptCheckBox = GUICtrlCreateCheckbox("Repair Cryptographic Services", 20, 50)
$winsockCheckBox = GUICtrlCreateCheckbox("Repair Winsock", 200, 50)
$wmiCheckBox = GUICtrlCreateCheckbox("Repair WMI Services", 20, 90)
$timeCheckBox = GUICtrlCreateCheckbox("Repair Windows Time Services", 200, 90)
$permCheckBox = GUICtrlCreateCheckbox("Repair Security Permissions", 20, 130)
$aclCheckBox = GUICtrlCreateCheckbox("Repair ACLs", 200, 130)
$printerCheckBox = GUICtrlCreateCheckbox("Repair Printer Spool", 20, 170)
$repairButton = GUICtrlCreateButton("Repair...", 20, 280)
#endregion Repair Options
$exitButton = GUICtrlCreateButton("E&xit", 200, 280)

FileInstall("secedit.exe", $winDir & "\secedit.exe")
FileInstall("subinacl.exe", $winDir & "\subinacl.exe")
GUISetState()

Do
	$msg = GUIGetMsg()
	Switch $msg
		Case $repairButton
			repairFunction()
		Case $selectAllProgramMenuItem
			GUICtrlSetState($wuCheckBox, $GUI_CHECKED)
			GUICtrlSetState($msiCheckBox, $GUI_CHECKED)
			GUICtrlSetState($cryptCheckBox, $GUI_CHECKED)
			GUICtrlSetState($winsockCheckBox, $GUI_CHECKED)
			GUICtrlSetState($wmiCheckBox, $GUI_CHECKED)
			GUICtrlSetState($timeCheckBox, $GUI_CHECKED)
			GUICtrlSetState($permCheckBox, $GUI_CHECKED)
			GUICtrlSetState($aclCheckBox, $GUI_CHECKED)
			GUICtrlSetState($printerCheckBox, $GUI_CHECKED)
		Case $selectNoneProgramMenuItem
			GUICtrlSetState($wuCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($msiCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($cryptCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($winsockCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($wmiCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($timeCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($permCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($aclCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($printerCheckBox, $GUI_UNCHECKED)
		Case $exitButton
			$msg = $GUI_EVENT_CLOSE
		Case $exitProgramMenuItem
			$msg = $GUI_EVENT_CLOSE
		Case $aboutMenuItem
			MsgBox(0, "Windows Repair Tool", "Version " & FileGetVersion("RepairTool.exe") & @LF & "Many of the scripts used here were found at " & @LF & "http://www.kellys-korner-xp.com/xp_tweaks.htm")
	EndSwitch
Until $msg = $GUI_EVENT_CLOSE
FileDelete($winDir & "\secedit.exe")
FileDelete($winDir & "\subinacl.exe")

#region Repair Functions
#comments-start
	I need to add in error detection in these tools (and graceful error detection at that...).
	Currently, any errors thrown by any of the _RunDOS commands (and there are tons) are not handled.
	This is particularly a problem in the aclRepair() function and permRepair() function as both of
	these functions are relying on files that don't reside on the target computer by default.
	Ideally, of course, having error detection throughout would be best, I just need to decide how
	to handle it and how to report those errors back to the user.
#comments-end
Func printerRepair()
	ProgressOn("Repairing Print Spooler", "", "", -1, -1, 16)
	ProgressSet(0, "Stopping Services...")
	_RunDOS("net stop spooler")
	_RunDOS("sc config spooler depend= RPCSS")
	ProgressSet(35, "Removing all print queue items...")
	;del /Q /F /S "%systemroot%\System32\Spool\Printers\*.*"
	DirRemove($winDir & "\System32\Spool\Printers\", 1)
	DirCreate($winDir & "\System32\Spool\Printers\")
	ProgressSet(85, "Starting Services...")
	_RunDOS("net start spooler")
	ProgressSet(100, "Finished Print Spooler Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>printerRepair

Func aclRepair()
	ProgressOn("Repairing ACLs", "", "", -1, -1, 16)
	ProgressSet(0, "HKEY_LM Repair...")
	_RunDOS("subinacl.exe /subkeyreg HKEY_LOCAL_MACHINE /grant=administrators=f /grant=system=f")
	ProgressSet(20, "HKEY_CURRENT_USER Repair...")
	_RunDOS("subinacl.exe /subkeyreg HKEY_CURRENT_USER /grant=administrators=f /grant=system=f")
	ProgressSet(40, "HKEY_CLASSES_ROOT Repair...")
	_RunDOS("subinacl /subkeyreg HKEY_CLASSES_ROOT /grant=administrators=f /grant=system=f")
	ProgressSet(60, "System Drive Repair...")
	_RunDOS("subinacl /subdirectories " & $systemDrive & " /grant=administrators=f /grant=system=f")
	ProgressSet(80, "Windows Directory Repair...")
	_RunDOS("subinacl /subdirectories " & $winDir & "\*.* /grant=administrators=f /grant=system=f")
	;repair windows update acls, need to verify this command...
	;_RunDOS("Subinacl /service wuauserv /sddl=DSadA;;CCLCSWRPWPDTLOCRRC;;;SY)(A;;CCDCLCSWRPWPDTLOCRSDRCWDWO;;;BA)(A; ;CCLCSWLOCRRC;;;AU)(A;;CCLCSWRPWPDTLOCRRC;;;PU)")
	ProgressSet(100, "Finished ACL Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>aclRepair

Func WURepair()
	ProgressOn("Repairing Windows Update", "", "", -1, -1, 16)
	ProgressSet(5, "Stopping Services...")
	$rc = _RunDOS("sc.exe config wuauserv start=auto obj=LocalSystem")
	$rc = _RunDOS("sc.exe config bits start=auto obj=LocalSystem")
	$rc = _RunDOS("net.exe stop bits")
	$rc = _RunDOS("net.exe stop wuauserv")
	$rc = _RunDOS("regsvr32.exe /u wuaueng.dll /s")

	ProgressSet(33, "Removing SoftwareDistribution Files...")
	DirRemove($winDir & "\SoftwareDistribution\", 1)
	DirCreate($winDir & "\SoftwareDistribution\")
	FileDelete($winDir & "\windowsupdate.log")

	ProgressSet(50, "Registering DLL Files...")
	$rc = _RunDOS("regsvr32 wuaueng.dll /s")
	$rc = _RunDOS("regsvr32 wuapi.dll /s")
	$rc = _RunDOS("regsvr32 wuaueng1.dll /s")
	$rc = _RunDOS("regsvr32 wucltui.dll /s")
	$rc = _RunDOS("regsvr32 wups.dll /s")
	$rc = _RunDOS("regsvr32 wups2.dll /s")
	$rc = _RunDOS("regsvr32 wuweb.dll /s")
	$rc = _RunDOS("regsvr32 msxml.dll /s")
	$rc = _RunDOS("regsvr32 msxml2.dll /s")
	$rc = _RunDOS("regsvr32 msxml3.dll /s")
	$rc = _RunDOS("regsvr32 msxml4.dll /s")
	$rc = _RunDOS("regsvr32 qmgr.dll /s")
	$rc = _RunDOS("regsvr32 qmgrprxy.dll /s")
	$rc = _RunDOS("regsvr32 muweb.dll /s")
	$rc = _RunDOS("regsvr32 winhttp.dll /s")
	
	ProgressSet(80, "Restarting Services...")
	$rc = _RunDOS("net start bits")
	$rc = _RunDOS("net start wuauserv")
	$rc = _RunDOS("wuauclt /resetauthorization /detectnow")
	ProgressSet(100, "Finished Windows Update Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>WURepair

Func MSIRepair()
	ProgressOn("Repairing Windows Installer", "", "", -1, -1, 16)
	$rc = _RunDOS("sc config msiserver start=manual")
	$rc = _RunDOS("msiexec /unreg")
	$rc = _RunDOS("msiexec /regserver")
	$rc = _RunDOS("regsvr32 msi.dll /s")
	ProgressSet(100, "Finished Windows Installer Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>MSIRepair

Func CryptRepair()
	ProgressOn("Repairing Cryptographic Services", "", "", -1, -1, 16)
	ProgressSet(10, "Stopping Services...")
	$rc = _RunDOS("sc config cryptsvc start=auto")
	$rc = _RunDOS("net stop cryptsvc")
	
	ProgressSet(25, "Registering DLL Files...")
	$rc = _RunDOS("regsvr32 cryptdlg.dll /s")
	$rc = _RunDOS("regsvr32 cryptui.dll /s")
	$rc = _RunDOS("regsvr32 cryptext.dll /s")
	$rc = _RunDOS("regsvr32 dssenh.dll /s")
	$rc = _RunDOS("regsvr32 gpkcsp.dll /s")
	$rc = _RunDOS("regsvr32 initpki.dll /s")
	$rc = _RunDOS("regsvr32 licdll.dll /s")
	$rc = _RunDOS("regsvr32 mssign32.dll /s")
	$rc = _RunDOS("regsvr32 mssip32.dll /s")
	$rc = _RunDOS("regsvr32 scardssp.dll /s")
	$rc = _RunDOS("regsvr32 sccbase.dll /s")
	$rc = _RunDOS("regsvr32 scecli.dll /s")
	$rc = _RunDOS("regsvr32 softpub.dll /s")
	$rc = _RunDOS("regsvr32 slbcsp.dll /s")
	$rc = _RunDOS("regsvr32 regwizc.dll /s")
	$rc = _RunDOS("regsvr32 rsaenh.dll /s")
	$rc = _RunDOS("regsvr32 winhttp.dll /s")
	$rc = _RunDOS("regsvr32 wintrust.dll /s")
	
	ProgressSet(95, "Restarting Services...")
	$rc = _RunDOS("net start cryptsvc")
	ProgressSet(100, "Finished Cryptographic Services Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>CryptRepair

Func IERepair()
	#comments-start
		not supported yet, these dll commands only work with IE6 and the registry entries are for IE7.  I need to find a
		consistent way to deal with repairing both IE6 and IE7.  This is probably going to be a pain in the ass...
	#comments-end
	;$rc = _RunDOS("rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 F:\WINDOWS\inf\iereset.inf")
	;RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","RunOnceHasShown","REG_DWORD",1)
	;RegWrite("HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\Main","RunOnceComplete","REG_DWORD",1)
EndFunc   ;==>IERepair

Func WinsockRepair()
	ProgressOn("Repairing Winsock", "", "", -1, -1, 16)
	$rc = _RunDOS("netsh winsock reset")
	$rc = _RunDOS("netsh winsock reset catalog")
	$rc = _RunDOS("netsh interface reset all")
	$rc = _RunDOS("firewall reset")
	ProgressSet(100, "Finished Winsock Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>WinsockRepair

Func WMIRepair()
	;not sure how well this works
	ProgressOn("Repairing WMI Services", "", "", -1, -1, 16)
	ProgressSet(5, "Registering DLL Files...")
	$rc = _RunDOS("regsvr32 cimwin32.dll /s")
	$rc = _RunDOS("regsvr32 CmdEvTgProv.dll /s")
	$rc = _RunDOS("regsvr32 dsprov.dll /s")
	$rc = _RunDOS("regsvr32 esscli.dll /s")
	$rc = _RunDOS("regsvr32 evntrprv.dll /s")
	$rc = _RunDOS("regsvr32 fastprox.dll /s")
	$rc = _RunDOS("regsvr32 fwdprov.dll /s")
	$rc = _RunDOS("regsvr32 krnlprov.dll /s")
	$rc = _RunDOS("regsvr32 mofd.dll /s")
	$rc = _RunDOS("regsvr32 msiprov.dll /s")
	$rc = _RunDOS("regsvr32 ncprov.dll /s")
	$rc = _RunDOS("regsvr32 ntevt.dll /s")
	$rc = _RunDOS("regsvr32 policman.dll /s")
	$rc = _RunDOS("regsvr32 repdrvfs.dll /s")
	$rc = _RunDOS("regsvr32 smtpcons.dll /s")
	$rc = _RunDOS("regsvr32 stdprov.dll /s")
	$rc = _RunDOS("regsvr32 tmplprov.dll /s")
	$rc = _RunDOS("regsvr32 trnsprov.dll /s")
	$rc = _RunDOS("regsvr32 updprov.dll /s")
	$rc = _RunDOS("regsvr32 viewprov.dll /s")
	$rc = _RunDOS("regsvr32 wbemads.dll /s")
	$rc = _RunDOS("regsvr32 wbemcntl.dll /s")
	$rc = _RunDOS("regsvr32 wbemcons.dll /s")
	$rc = _RunDOS("regsvr32 wbemcore.dll /s")
	$rc = _RunDOS("regsvr32 wbemdisp.dll /s")
	$rc = _RunDOS("regsvr32 wbemess.dll /s")
	$rc = _RunDOS("regsvr32 wbemperf.dll /s")
	$rc = _RunDOS("regsvr32 wbemprox.dll /s")
	$rc = _RunDOS("regsvr32 wbemsvc.dll /s")
	$rc = _RunDOS("regsvr32 wbemupgd.dll /s")
	$rc = _RunDOS("regsvr32 wmiaprpl.dll /s")
	$rc = _RunDOS("regsvr32 wmicookr.dll /s")
	$rc = _RunDOS("regsvr32 wmidcprv.dll /s")
	$rc = _RunDOS("regsvr32 wmimsg.dll /s")
	$rc = _RunDOS("regsvr32 wmipcima.dll /s")
	$rc = _RunDOS("regsvr32 wmipdskq.dll /s")
	$rc = _RunDOS("regsvr32 wmipiprt.dll /s")
	$rc = _RunDOS("regsvr32 wmiprov.dll /s")
	$rc = _RunDOS("regsvr32 wmipsess.dll /s")
	$rc = _RunDOS("regsvr32 wmisvc.dll /s")
	$rc = _RunDOS("regsvr32 wmitimep.dll /s")
	$rc = _RunDOS("regsvr32 wmiutils.dll /s")
	
	ProgressSet(70, "Stopping Services...")
	$rc = _RunDOS("net stop winmgmt")
	
	ProgressSet(75, "Cleaning Temporary WMI Files...")
	$rc = _RunDOS("winmgmt /kill")
	$rc = _RunDOS("rundll32 wbemupgd.dll, UpgradeRepository")
	$rc = _RunDOS("net stop winmgmt")
	$rc = _RunDOS("winmgmt /clearadap")
	$rc = _RunDOS("winmgmt /unregserver")
	$rc = _RunDOS("winmgmt /regserver")
	$rc = _RunDOS("winmgmt /resyncperf")
	
	ProgressSet(90, "Restarting Services...")
	$rc = _RunDOS("net start winmgmt")
	$rc = _RunDOS("sc config winmgmt start=auto")
	
	ProgressSet(100, "Finished WMI Services Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>WMIRepair

Func TimeRepair()
	ProgressOn("Repairing Windows Time Service", "", "", -1, -1, 16)
	$rc = _RunDOS("net stop w32time")
	$rc = _RunDOS("w32tm /unregister")
	$rc = _RunDOS("w32tm /register")
	$rc = _RunDOS("net start w32time")
	ProgressSet(100, "Finished Windows Time Service Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
EndFunc   ;==>TimeRepair

Func PermRepair()
	;Requires secedit.exe
	$analyze = "secedit.exe /analyze /db " & $winDir & "\sectest.db /cfg " & $winDir & "\inf\defltwk.inf /log " & $winDir & "\security\logs\secanalyze.log"
	$configure = "secedit.exe /configure /db " & $winDir & "\sectest.db /cfg " & $winDir & "\inf\defltwk.inf /log " & $winDir & "\security\logs\secrepair.log"
	ProgressOn("Repairing Windows Permissions", "", "", -1, -1, 16)
	ProgressSet(0, "Analyzing Current Permission Scheme...")
	_RunDOS($analyze)
	ProgressSet(50, "Configuring Proper Permissions...")
	_RunDOS($configure)
	ProgressSet(100, "Finished Windows Permission Repair", "Completed!")
	Sleep(3000)
	ProgressOff()
	MsgBox(0, "Log Files", "Log Files for this procedure stored at: " & $winDir & "\security\logs\secanalyze.log and" & @LF & $winDir & "\security\logs\secrepair.log")
EndFunc   ;==>PermRepair
#endregion Repair Functions

#region General Functions
Func repairFunction()
	Select
		Case GUICtrlRead($wuCheckBox) = $GUI_CHECKED
			WURepair()
			GUICtrlSetState($wuCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($wuCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($msiCheckBox) = $GUI_CHECKED
			MSIRepair()
			GUICtrlSetState($msiCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($msiCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($cryptCheckBox) = $GUI_CHECKED
			CryptRepair()
			GUICtrlSetState($cryptCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($cryptCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($winsockCheckBox) = $GUI_CHECKED
			WinsockRepair()
			GUICtrlSetState($winsockCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($winsockCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($wmiCheckBox) = $GUI_CHECKED
			WMIRepair()
			GUICtrlSetState($wmiCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($wmiCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($timeCheckBox) = $GUI_CHECKED
			TimeRepair()
			GUICtrlSetState($timeCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($timeCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($permCheckBox) = $GUI_CHECKED
			PermRepair()
			GUICtrlSetState($permCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($permCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($aclCheckBox) = $GUI_CHECKED
			aclRepair()
			GUICtrlSetState($aclCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($aclCheckBox, $GUI_DISABLE)
		Case GUICtrlRead($printerCheckBox) = $GUI_CHECKED
			printerRepair()
			GUICtrlSetState($printerCheckBox, $GUI_UNCHECKED)
			GUICtrlSetState($printerCheckBox, $GUI_DISABLE)
		Case Else
			MsgBox(64, "Information", "You must select at least one repair!")
	EndSelect
EndFunc   ;==>repairFunction
#endregion General Functions