#include <GUIConstants.au3>
#include <Date.au3>
Opt("TrayIconDebug", 1)
GUICtrlCreateLabel("00:00:00", 10, 10)
GUISetState()




#Region ### START Koda GUI section ### Form=H:\AutoIt\Ryans Test Code New 15-11\PC_Setup.kxf
$PC_Setup = GUICreate("PC_Setup", 851, 678, 178, 145)
$adminPswrdCB = GUICtrlCreateCheckbox("Set Admin Passwords", 112, 80, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$firewallCB = GUICtrlCreateCheckbox("Turn off Firewall", 112, 112, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$folderOptCB = GUICtrlCreateCheckbox("Set Default Folder Options", 112, 144, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$timeSyncCB = GUICtrlCreateCheckbox("Turn off Auto Time Syncronization", 112, 176, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$securityAlertsCB = GUICtrlCreateCheckbox("Disable Security Alerts", 112, 208, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$errorReportingCB = GUICtrlCreateCheckbox("Disable Error Reporting", 360, 80, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$compDescCB = GUICtrlCreateCheckbox("Description of the Computer", 360, 112, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$winUpdatesCB = GUICtrlCreateCheckbox("Setup Windows Updates", 360, 144, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$disclaimerCB = GUICtrlCreateCheckbox("Install UEC Disclaimer", 360, 176, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$wallpaperCB = GUICtrlCreateCheckbox("Setup UEC Wallpaper", 360, 208, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$networkCB = GUICtrlCreateCheckbox("Setup Network Settings", 552, 80, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$websiteCB = GUICtrlCreateCheckbox("Set Default Website", 552, 112, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$readmeCB = GUICtrlCreateCheckbox("Readme", 552, 144, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$completeCB = GUICtrlCreateCheckbox("To Complete", 552, 176, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)

$vncCB = GUICtrlCreateCheckbox("VNC", 112, 416, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$trendCB = GUICtrlCreateCheckbox("Trend Antivirus", 112, 352, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$adobe9CB = GUICtrlCreateCheckbox("Adobe Reader 9", 112, 384, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$zipcentralCB = GUICtrlCreateCheckbox("ZipCentral", 112, 320, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$outlook03CB = GUICtrlCreateCheckbox("Ms Outlook 03", 112, 448, 185, 33)
;GUICtrlSetState(-1, $GUI_CHECKED)
$outlook07CB = GUICtrlCreateCheckbox("Ms Outlook 07", 112, 480, 185, 33)
;GUICtrlSetState(-1, $GUI_CHECKED)
$javaCB = GUICtrlCreateCheckbox("Java 1.6", 112, 512, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)
$netFrameworkCB = GUICtrlCreateCheckbox("Ms Net Framework", 112, 544, 185, 33)
GUICtrlSetState(-1, $GUI_CHECKED)

$openofficeCB = GUICtrlCreateCheckbox("Open Office", 368, 320, 185, 33)
$officestd03CB = GUICtrlCreateCheckbox("Ms Office Std 03", 368, 352, 185, 33)
$officepro03CB = GUICtrlCreateCheckbox("Ms Office Pro 03", 368, 384, 185, 33)
$officestd07CB = GUICtrlCreateCheckbox("Ms Office Std 07", 368, 416, 185, 33)
$officepro07CB = GUICtrlCreateCheckbox("Ms Office Pro 07", 368, 448, 185, 33)
;$project03CB = GUICtrlCreateCheckbox("Ms Project 03", 368, 480, 185, 33)
$neroCB = GUICtrlCreateCheckbox("Nero", 368, 480, 185, 33)
$svnCB = GUICtrlCreateCheckbox("SVN", 368, 512, 185, 33)
$xpSP3CB = GUICtrlCreateCheckbox("Windows XP SP3", 368, 544, 185, 33)

$sourcesafeCB = GUICtrlCreateCheckbox("Visual SourceSafe", 600, 384, 185, 33)
$codewright6CB = GUICtrlCreateCheckbox("CodeWright 6", 600, 320, 185, 33)
$codewright7CB = GUICtrlCreateCheckbox("CodeWright 7", 600, 352, 185, 33)
$parallelLoaderCB = GUICtrlCreateCheckbox("Parallel Loader", 600, 416, 185, 33)
$irdLoaderCB = GUICtrlCreateCheckbox("IRD Loader", 600, 448, 185, 33)
$uecTerminalCB = GUICtrlCreateCheckbox("UEC Terminal", 600, 480, 185, 33)
$vmPlayerCB = GUICtrlCreateCheckbox("VMWare Player", 600, 512, 185, 33)
$ieCB = GUICtrlCreateCheckbox("IE 7", 600, 544, 185, 33)
$Group1 = GUICtrlCreateGroup("Standard", 64, 32, 713, 249)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Standard Installations", 64, 296, 225, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("Optional Installations", 352, 296, 425, 300)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button1 = GUICtrlCreateButton("Start", 336, 614, 121, 25, 0)
$Button2 = GUICtrlCreateButton("Uncheck All", 586, 614, 121, 25, 0)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



While 1

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If BitAND(GUICtrlRead($trendCB), $GUI_CHECKED) = $GUI_CHECKED Then
				TrendAntiVirus()
				GUICtrlSetFont($trendCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($adminPswrdCB), $GUI_CHECKED) = $GUI_CHECKED Then
				AdminPasswords()
				GUICtrlSetFont($adminPswrdCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($firewallCB), $GUI_CHECKED) = $GUI_CHECKED Then
				Firewall()
				GUICtrlSetFont($firewallCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($folderOptCB), $GUI_CHECKED) = $GUI_CHECKED Then
				FolderOptions()
				GUICtrlSetFont($folderOptCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($timeSyncCB), $GUI_CHECKED) = $GUI_CHECKED Then
				DisableTimeSync()
				GUICtrlSetFont($timeSyncCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($securityAlertsCB), $GUI_CHECKED) = $GUI_CHECKED Then
				DisableSecurityAlerts()
				GUICtrlSetFont($securityAlertsCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($errorReportingCB), $GUI_CHECKED) = $GUI_CHECKED Then
				DisableErrorReporting()
				GUICtrlSetFont($errorReportingCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($compDescCB), $GUI_CHECKED) = $GUI_CHECKED Then
				ComputerDescription()
				GUICtrlSetFont($compDescCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($winUpdatesCB), $GUI_CHECKED) = $GUI_CHECKED Then
				WindowsUpdate()
				GUICtrlSetFont($winUpdatesCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($disclaimerCB), $GUI_CHECKED) = $GUI_CHECKED Then
				UECDisclaimer()
				GUICtrlSetFont($disclaimerCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($wallpaperCB), $GUI_CHECKED) = $GUI_CHECKED Then
				UECWallpaper()
				GUICtrlSetFont($wallpaperCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($networkCB), $GUI_CHECKED) = $GUI_CHECKED Then
				NetworkConnection()
				GUICtrlSetFont($networkCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($websiteCB), $GUI_CHECKED) = $GUI_CHECKED Then
				DefaultSite()
				GUICtrlSetFont($websiteCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($readmeCB), $GUI_CHECKED) = $GUI_CHECKED Then
				Readme()
				GUICtrlSetFont($readmeCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($zipcentralCB), $GUI_CHECKED) = $GUI_CHECKED Then
				ZipCentral()
				GUICtrlSetFont($zipcentralCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($adobe9CB), $GUI_CHECKED) = $GUI_CHECKED Then
				Adobe9()
				GUICtrlSetFont($adobe9CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($vncCB), $GUI_CHECKED) = $GUI_CHECKED Then
				VNCSetup()
				GUICtrlSetFont($vncCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($outlook03CB), $GUI_CHECKED) = $GUI_CHECKED Then
				Outlook03()
				GUICtrlSetFont($outlook03CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($outlook07CB), $GUI_CHECKED) = $GUI_CHECKED Then
				Outlook07()
				GUICtrlSetFont($outlook07CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($javaCB), $GUI_CHECKED) = $GUI_CHECKED Then
				Java()
				GUICtrlSetFont($javaCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($netFrameworkCB), $GUI_CHECKED) = $GUI_CHECKED Then
				netFramework()
				GUICtrlSetFont($netFrameworkCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($openofficeCB), $GUI_CHECKED) = $GUI_CHECKED Then
				OpenOffice()
				GUICtrlSetFont($openofficeCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($officestd03CB), $GUI_CHECKED) = $GUI_CHECKED Then
				OfficeStd03()
				GUICtrlSetFont($officestd03CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($officepro03CB), $GUI_CHECKED) = $GUI_CHECKED Then
				OfficePro03()
				GUICtrlSetFont($officepro03CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($officestd07CB), $GUI_CHECKED) = $GUI_CHECKED Then
				OfficeStd07()
				GUICtrlSetFont($officestd07CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($officepro07CB), $GUI_CHECKED) = $GUI_CHECKED Then
				OfficePro07()
				GUICtrlSetFont($officepro07CB, 8, 400, 8, "MS Sans Serif")
			EndIf
		;	If BitAND(GUICtrlRead($project03CB), $GUI_CHECKED) = $GUI_CHECKED Then
		;		Project03()
		;		GUICtrlSetFont($project03CB, 8, 400, 8, "MS Sans Serif")
		;	EndIf
			If BitAND(GUICtrlRead($neroCB), $GUI_CHECKED) = $GUI_CHECKED Then
				Nero()
				GUICtrlSetFont($neroCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($svnCB), $GUI_CHECKED) = $GUI_CHECKED Then
				SVN()
				GUICtrlSetFont($svnCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($xpSP3CB), $GUI_CHECKED) = $GUI_CHECKED Then
				SVN()
				GUICtrlSetFont($xpSP3CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($codewright6CB), $GUI_CHECKED) = $GUI_CHECKED Then
				codewright6()
				GUICtrlSetFont($codewright6CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($codewright7CB), $GUI_CHECKED) = $GUI_CHECKED Then
				codewright7()
				GUICtrlSetFont($codewright7CB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($xpSP3CB), $GUI_CHECKED) = $GUI_CHECKED Then
				SourceSafe()
				GUICtrlSetFont($sourcesafeCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($parallelLoaderCB), $GUI_CHECKED) = $GUI_CHECKED Then
				ParallelLoader()
				GUICtrlSetFont($parallelLoaderCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($irdLoaderCB), $GUI_CHECKED) = $GUI_CHECKED Then
				IRDLoader()
				GUICtrlSetFont($irdLoaderCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($uecTerminalCB), $GUI_CHECKED) = $GUI_CHECKED Then
				UECTerminal()
				GUICtrlSetFont($uecTerminalCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($vmPlayerCB), $GUI_CHECKED) = $GUI_CHECKED Then
				VMPlayer()
				GUICtrlSetFont($vmPlayerCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($ieCB), $GUI_CHECKED) = $GUI_CHECKED Then
				VMPlayer()
				GUICtrlSetFont($ieCB, 8, 400, 8, "MS Sans Serif")
			EndIf
			If BitAND(GUICtrlRead($completeCB), $GUI_CHECKED) = $GUI_CHECKED Then
				toComplete()
				GUICtrlSetFont($completeCB, 8, 400, 8, "MS Sans Serif")
			EndIf
		Case $Button2
			UncheckAll()
	EndSwitch

WEnd


Func UncheckAll()
	GUICtrlSetState($adminPswrdCB, $GUI_UNCHECKED)
	GUICtrlSetState($firewallCB, $GUI_UNCHECKED)
	GUICtrlSetState($folderOptCB, $GUI_UNCHECKED)
	GUICtrlSetState($timeSyncCB, $GUI_UNCHECKED)
	GUICtrlSetState($securityAlertsCB, $GUI_UNCHECKED)
	GUICtrlSetState($errorReportingCB, $GUI_UNCHECKED)
	GUICtrlSetState($compDescCB, $GUI_UNCHECKED)
	GUICtrlSetState($winUpdatesCB, $GUI_UNCHECKED)
	GUICtrlSetState($disclaimerCB, $GUI_UNCHECKED)
	GUICtrlSetState($wallpaperCB, $GUI_UNCHECKED)
	GUICtrlSetState($networkCB, $GUI_UNCHECKED)
	GUICtrlSetState($websiteCB, $GUI_UNCHECKED)
	GUICtrlSetState($readmeCB, $GUI_UNCHECKED)
	GUICtrlSetState($vncCB, $GUI_UNCHECKED)
	GUICtrlSetState($trendCB, $GUI_UNCHECKED)
	GUICtrlSetState($zipcentralCB, $GUI_UNCHECKED)
	GUICtrlSetState($adobe9CB, $GUI_UNCHECKED)
	GUICtrlSetState($Outlook03CB, $GUI_UNCHECKED)
	GUICtrlSetState($outlook07CB, $GUI_UNCHECKED)
	GUICtrlSetState($javaCB, $GUI_UNCHECKED)
	GUICtrlSetState($netFrameworkCB, $GUI_UNCHECKED)
	GUICtrlSetState($openofficeCB, $GUI_UNCHECKED)
	GUICtrlSetState($officestd03CB, $GUI_UNCHECKED)
	GUICtrlSetState($officepro03CB, $GUI_UNCHECKED)
	GUICtrlSetState($officepro07CB, $GUI_UNCHECKED)
	GUICtrlSetState($officestd07CB, $GUI_UNCHECKED)
;	GUICtrlSetState($project03CB, $GUI_UNCHECKED)
	GUICtrlSetState($svnCB, $GUI_UNCHECKED)
	GUICtrlSetState($xpSP3CB, $GUI_UNCHECKED)
	GUICtrlSetState($codewright6CB, $GUI_UNCHECKED)
	GUICtrlSetState($codewright7CB, $GUI_UNCHECKED)
	GUICtrlSetState($sourcesafeCB, $GUI_UNCHECKED)
	GUICtrlSetState($parallelLoaderCB, $GUI_UNCHECKED)
	GUICtrlSetState($irdLoaderCB, $GUI_UNCHECKED)
	GUICtrlSetState($uecTerminalCB, $GUI_UNCHECKED)
	GUICtrlSetState($vmPlayerCB, $GUI_UNCHECKED)
	GUICtrlSetState($completeCB, $GUI_UNCHECKED)
EndFunc   ;==>UncheckAll


;---------------

Func AdminPasswords()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("compmgmt.msc{ENTER}")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Complete Task", "Please Enter and set Admin Passwords. (incl. Production accounts if applicable." & @CRLF & "Must give admin administrator rights!" & @CRLF & @CRLF & "Press OK once complete.")
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>AdminPasswords

Func ComputerDescription()
	#Region --- CodeWizard generated code Start ---
	;InputBox features: Title=Yes, Prompt=Yes, Default Text=No
	If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswerd
	$sInputBoxAnswerd = InputBox("PC Description", "Please enter in the asset number " & @CRLF & "as the PC Description.", "", " ", "-1", "-1", "-1", "-1")
	Select
		Case @error = 0 ;OK - The string returned is valid
		Case @error = 1 ;The Cancel button was pushed
		Case @error = 3 ;The InputBox failed to open
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("sysdm.cpl{ENTER}")
	WinWait("System Properties", "Microsoft Windows XP")
	If Not WinActive("System Properties", "Microsoft Windows XP") Then WinActivate("System Properties", "Microsoft Windows XP")
	WinWaitActive("System Properties", "Microsoft Windows XP")
	Send("{RIGHT}")
	WinWait("System Properties", "Computer &descriptio")
	If Not WinActive("System Properties", "Computer &descriptio") Then WinActivate("System Properties", "Computer &descriptio")
	WinWaitActive("System Properties", "Computer &descriptio")
	Send("{TAB}")
	Send($sInputBoxAnswerd)
	Send("{SHIFTUP}{ENTER}")
EndFunc   ;==>ComputerDescription


Func Firewall()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("firewall.cpl{ENTER}")
	WinWait("Windows Firewall", "Windows Firewall is ")
	If Not WinActive("Windows Firewall", "Windows Firewall is ") Then WinActivate("Windows Firewall", "Windows Firewall is ")
	WinWaitActive("Windows Firewall", "Windows Firewall is ")
	Send("{DOWN}{ENTER}")
	;WinWait("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;If Not WinActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source") Then WinActivate("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;WinWaitActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")


	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Firewall", "Firewall has been disabled!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout

		Case Else                ;OK

	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>Firewall


Func FolderOptions()
	Send("{LWINDOWN}e{LWINUP}")
	WinWait("My Computer", "FolderView")
	If Not WinActive("My Computer", "FolderView") Then WinActivate("My Computer", "FolderView")
	WinWaitActive("My Computer", "FolderView")
	Send("{F10}to")
	WinWait("Folder Options", "Show common tasks in")
	If Not WinActive("Folder Options", "Show common tasks in") Then WinActivate("Folder Options", "Show common tasks in")
	WinWaitActive("Folder Options", "Show common tasks in")
	Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{RIGHT}")
	WinWait("Folder Options", "Apply to A&ll Folder")
	If Not WinActive("Folder Options", "Apply to A&ll Folder") Then WinActivate("Folder Options", "Apply to A&ll Folder")
	WinWaitActive("Folder Options", "Apply to A&ll Folder")
	Send("{TAB}{TAB}{TAB}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{SPACE}{DOWN}{SPACE}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{SPACE}{TAB}{TAB}{TAB}{TAB}{ENTER}{ENTER}")
	WinWait("Folder views", "Set all the folders ")
	If Not WinActive("Folder views", "Set all the folders ") Then WinActivate("Folder views", "Set all the folders ")
	WinWaitActive("Folder views", "Set all the folders ")
	Send("{ENTER}")
	WinWait("Folder Options", "Apply to A&ll Folder")
	If Not WinActive("Folder Options", "Apply to A&ll Folder") Then WinActivate("Folder Options", "Apply to A&ll Folder")
	WinWaitActive("Folder Options", "Apply to A&ll Folder")
	Send("{TAB}{TAB}{TAB}{TAB}{ENTER}")
	WinWait("My Computer", "FolderView")
	If Not WinActive("My Computer", "FolderView") Then WinActivate("My Computer", "FolderView")
	WinWaitActive("My Computer", "FolderView")
	Send("{ALTDOWN}{F4}{ALTUP}")
	;WinWait("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;If Not WinActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source") Then WinActivate("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;WinWaitActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Folder Options", "Viewing of file extensions enabled" & @CRLF & "Viewing of hidden folders/files enabled" & @CRLF & "Simple File sharing disabled", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>FolderOptions

Func DisableTimeSync()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("timedate.cpl{ENTER}")
	WinWait("Date and Time Properties", "Current time zone:  ")
	If Not WinActive("Date and Time Properties", "Current time zone:  ") Then WinActivate("Date and Time Properties", "Current time zone:  ")
	WinWaitActive("Date and Time Properties", "Current time zone:  ")
	Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{RIGHT}{RIGHT}")
	WinWait("Date and Time Properties", "Automatically &synch")
	If Not WinActive("Date and Time Properties", "Automatically &synch") Then WinActivate("Date and Time Properties", "Automatically &synch")
	WinWaitActive("Date and Time Properties", "Automatically &synch")
	Send("{TAB}{SPACE}{ENTER}")
	;WinWait("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;If Not WinActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source") Then WinActivate("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;WinWaitActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "DateTime", "Time Syncronization disabled!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>DisableTimeSync


Func DisableSecurityAlerts()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("wscui.cpl{ENTER}")
	WinWait("Windows Security Center", "<A HREF=""http://go.m")
	If Not WinActive("Windows Security Center", "<A HREF=""http://go.m") Then WinActivate("Windows Security Center", "<A HREF=""http://go.m")
	WinWaitActive("Windows Security Center", "<A HREF=""http://go.m")
	Send("{TAB}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")
	WinWait("Alert Settings", "Alert me if my compu")
	If Not WinActive("Alert Settings", "Alert me if my compu") Then WinActivate("Alert Settings", "Alert me if my compu")
	WinWaitActive("Alert Settings", "Alert me if my compu")
	Send("{SPACE}{TAB}{SPACE}{TAB}{SPACE}{ENTER}")
	WinWait("Windows Security Center", "<A HREF=""http://go.m")
	If Not WinActive("Windows Security Center", "<A HREF=""http://go.m") Then WinActivate("Windows Security Center", "<A HREF=""http://go.m")
	WinWaitActive("Windows Security Center", "<A HREF=""http://go.m")
	Send("{ALTDOWN}{F4}{ALTUP}")
	;WinWait("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;If Not WinActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source") Then WinActivate("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	;WinWaitActive("C:\Documents and Settings\admin\Desktop\trial.au3 - SciTE","Source")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Security Alerts", "Security Alerts Disabled!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout

		Case Else                ;OK

	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>DisableSecurityAlerts


Func DisableErrorReporting()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("sysdm.cpl{ENTER}")
	WinWait("System Properties", "Microsoft Windows XP")
	If Not WinActive("System Properties", "Microsoft Windows XP") Then WinActivate("System Properties", "Microsoft Windows XP")
	WinWaitActive("System Properties", "Microsoft Windows XP")
	Send("{RIGHT}")
	WinWait("System Properties", "Computer &descriptio")
	If Not WinActive("System Properties", "Computer &descriptio") Then WinActivate("System Properties", "Computer &descriptio")
	WinWaitActive("System Properties", "Computer &descriptio")
	Send("{RIGHT}")
	WinWait("System Properties", "The Device Manager l")
	If Not WinActive("System Properties", "The Device Manager l") Then WinActivate("System Properties", "The Device Manager l")
	WinWaitActive("System Properties", "The Device Manager l")
	Send("{RIGHT}")
	WinWait("System Properties", "You must be logged o")
	If Not WinActive("System Properties", "You must be logged o") Then WinActivate("System Properties", "You must be logged o")
	WinWaitActive("System Properties", "You must be logged o")
	Send("{TAB}{TAB}{TAB}{TAB}{RIGHT}{ENTER}")
	WinWait("Error Reporting", "You can choose to ha")
	If Not WinActive("Error Reporting", "You can choose to ha") Then WinActivate("Error Reporting", "You can choose to ha")
	WinWaitActive("Error Reporting", "You can choose to ha")
	Send("{UP}{ENTER}")
	WinWait("System Properties", "You must be logged o")
	If Not WinActive("System Properties", "You must be logged o") Then WinActivate("System Properties", "You must be logged o")
	WinWaitActive("System Properties", "You must be logged o")
	Send("{TAB}{ENTER}")

	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Error Reporting", "Error Reporting disabled!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>DisableErrorReporting

Func WindowsUpdate()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("gpedit.msc{ENTER}")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=2 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Configure Automatic Updates", "Please go to the Windows Update page, and " & @CRLF & "Open: 'Configure Automatic Updates'", 2)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
	WinWait("Configure Automatic Updates Properties", "Configure Automatic ")
	If Not WinActive("Configure Automatic Updates Properties", "Configure Automatic ") Then WinActivate("Configure Automatic Updates Properties", "Configure Automatic ")
	WinWaitActive("Configure Automatic Updates Properties", "Configure Automatic ")
	Send("{DOWN}{TAB}{UP}{ENTER}")
	;Send("{ALTDOWN}{TAB}{ALTUP}")
	WinWait("Group Policy", "Local Computer Polic")
	If Not WinActive("Group Policy", "Local Computer Polic") Then WinActivate("Group Policy", "Local Computer Polic")
	WinWaitActive("Group Policy", "Local Computer Polic")
	Send("{DOWN}{ENTER}")
	WinWait("Specify intranet Microsoft update service location Properties", "Specify intranet Mic")
	If Not WinActive("Specify intranet Microsoft update service location Properties", "Specify intranet Mic") Then WinActivate("Specify intranet Microsoft update service location Properties", "Specify intranet Mic")
	WinWaitActive("Specify intranet Microsoft update service location Properties", "Specify intranet Mic")
	Send("{DOWN}{TAB}http{SHIFTDOWN};{SHIFTUP}//172.16.10.11{TAB}http{SHIFTDOWN};{SHIFTUP}//172.16.10.11{ENTER}")
	WinWait("Group Policy", "Local Computer Polic")
	If Not WinActive("Group Policy", "Local Computer Polic") Then WinActivate("Group Policy", "Local Computer Polic")
	WinWaitActive("Group Policy", "Local Computer Polic")
	Send("{ALTDOWN}{F4}{ALTUP}")
EndFunc   ;==>WindowsUpdate



Func UECDisclaimer()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\pc{SPACE}setup\std{SPACE}setup\disclaimer\winnt.reg{ENTER}")
	WinWait("Registry Editor", "Are you sure you wan")
	If Not WinActive("Registry Editor", "Are you sure you wan") Then WinActivate("Registry Editor", "Are you sure you wan")
	WinWaitActive("Registry Editor", "Are you sure you wan")
	Send("{ENTER}")
	WinWait("Registry Editor", "Information in \\uec")
	If Not WinActive("Registry Editor", "Information in \\uec") Then WinActivate("Registry Editor", "Information in \\uec")
	WinWaitActive("Registry Editor", "Information in \\uec")
	Send("{ENTER}")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "UEC Disclaimer", "UEC Disclaimer Installed!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
EndFunc   ;==>UECDisclaimer

Func UECWallpaper()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\pc{SPACE}setup\std{SPACE}setup\uec{SPACE}desktop{SPACE}wallpaper{ENTER}")
	WinWait("uec desktop wallpaper", "FolderView")
	If Not WinActive("uec desktop wallpaper", "FolderView") Then WinActivate("uec desktop wallpaper", "FolderView")
	WinWaitActive("uec desktop wallpaper", "FolderView")
	Send("u{CTRLDOWN}c{CTRLUP}{ALTDOWN}{F4}{ALTUP}")
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("c{SHIFTDOWN};{SHIFTUP}/windows{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}\windows\web\wallpaper{ENTER}")
	WinWait("wallpaper", "FolderView")
	If Not WinActive("wallpaper", "FolderView") Then WinActivate("wallpaper", "FolderView")
	WinWaitActive("wallpaper", "FolderView")
	Send("{CTRLDOWN}v{CTRLUP}{ALTDOWN}{F4}{ALTUP}")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "UEC Wallpaper", "UEC Wallpaper Installed!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>UECWallpaper


Func NetworkConnection()
	;-----------------------------Would you like to enter in an IP address or leave it on auto------------------------------
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=Yes and No, Icon=None
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer1
	$iMsgBoxAnswer1 = MsgBox(4, "Network", "Would you like to give the user an IP address??")
	Select
		Case $iMsgBoxAnswer1 = 6 ;Yes
		Case $iMsgBoxAnswer1 = 7 ;No
	EndSelect
	#EndRegion --- CodeWizard generated code End ---
	;------------------------------If yes to entering an IP address, is it for uec house ot factory----------------------------
	If $iMsgBoxAnswer1 = 6 Then
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswerl
		$sInputBoxAnswerl = InputBox("Location for Computer for IP?", "Please type 'f' for a factory computer or" & @CRLF & "Please type 'u' for a computer in UEC house or Annex.", "u", " ", "-1", "-1", "-1", "-1")
		Select
			Case @error = 0 ;OK - The string returned is valid
			Case @error = 1 ;The Cancel button was pushed
			Case @error = 3 ;The InputBox failed to open
		EndSelect
		#EndRegion --- CodeWizard generated code End ---
	EndIf
	;-----------------------------Enter in each section of the ip address---------------------------------------------------------
	If $iMsgBoxAnswer1 = 6 Then
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer2
		If $sInputBoxAnswerl = 'u'  Then
			$sInputBoxAnswer2 = InputBox("enter", "Enter in the specified section of the IP address. ie. 172.16.xx.yyy", "xx", " ", "-1", "-1", "-1", "-1")
		EndIf
		If $sInputBoxAnswerl = 'f'  Then
			$sInputBoxAnswer2 = InputBox("enter", "Enter in the specified section of the IP address. ie. 172.20.xx.yyy", "xx", " ", "-1", "-1", "-1", "-1")
		EndIf
		Select
			Case @error = 0 ;OK - The string returned is valid
			Case @error = 1 ;The Cancel button was pushed
			Case @error = 3 ;The InputBox failed to open
		EndSelect
		#EndRegion --- CodeWizard generated code End ---
		#Region --- CodeWizard generated code Start ---
		;InputBox features: Title=Yes, Prompt=Yes, Default Text=Yes
		If Not IsDeclared("sInputBoxAnswer") Then Local $sInputBoxAnswer3
		If $sInputBoxAnswerl = 'u'  Then
			$sInputBoxAnswer3 = InputBox("enter", "Enter in the specified section of the IP address. ie. 172.16.xx.yyy", "yy", " ", "-1", "-1", "-1", "-1")
		EndIf
		If $sInputBoxAnswerl = 'f'  Then
			$sInputBoxAnswer3 = InputBox("enter", "Enter in the specified section of the IP address. ie. 172.20.xx.yyy", "yy", " ", "-1", "-1", "-1", "-1")
		EndIf
		Select
			Case @error = 0 ;OK - The string returned is valid
			Case @error = 1 ;The Cancel button was pushed
			Case @error = 3 ;The InputBox failed to open
		EndSelect
		#EndRegion --- CodeWizard generated code End ---
	EndIf
	;-------------------------------------------------------------------------------
	If $iMsgBoxAnswer1 = 6 Then
		Send("{LWINDOWN}r{LWINUP}")
		WinWait("Run", "Type the name of a p")
		If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
		WinWaitActive("Run", "Type the name of a p")
		Send("ncpz.cpl{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}a.cpl{ENTER}")
		;WinWait("Network Connections","FolderView")
		;If Not WinActive("Network Connections","FolderView") Then WinActivate("Network Connections","FolderView")
		;WinWaitActive("Network Connections","FolderView")
		;Send("l{APPSKEY}r")
		;WinWait("Local Area Connection Properties","This c&onnection use")
		;If Not WinActive("Local Area Connection Properties","This c&onnection use") Then WinActivate("Local Area Connection Properties","This c&onnection use")
		;WinWaitActive("Local Area Connection Properties","This c&onnection use")
		;Send("{TAB}{TAB}{TAB}{TAB}{SPACE}{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}i{TAB}{TAB}{ENTER}")

		#Region --- CodeWizard generated code Start ---
		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=2 ss
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(64, "TCP/IP Settings", "Please make Connection Visible and go to the TCP/IP Settings.", 2)
		Select
			Case $iMsgBoxAnswer = -1 ;Timeout

			Case Else                ;OK

		EndSelect
		#EndRegion --- CodeWizard generated code End ---


		WinWait("Internet Protocol (TCP/IP) Properties", "You can get IP setti")
		If Not WinActive("Internet Protocol (TCP/IP) Properties", "You can get IP setti") Then WinActivate("Internet Protocol (TCP/IP) Properties", "You can get IP setti")
		WinWaitActive("Internet Protocol (TCP/IP) Properties", "You can get IP setti")
		Send("{DOWN}{TAB}172")
		If $sInputBoxAnswerl = 'u'  Then
			Send("16")
		EndIf
		If $sInputBoxAnswerl = 'f'  Then
			Send("20")
		EndIf
		;	   Send($sInputBoxAnswer1)
		Send("{RIGHT}")
		Send($sInputBoxAnswer2)
		Send("{RIGHT}")
		Send($sInputBoxAnswer3)
		Send("{TAB}{TAB}")
		If $sInputBoxAnswerl = 'u'  Then
			Send("17216{RIGHT}10{RIGHT}2{TAB}{TAB}17216{RIGHT}11{RIGHT}1{TAB}17220{RIGHT}10{RIGHT}3{ENTER}")
		EndIf
		If $sInputBoxAnswerl = 'f'  Then
			Send("17220{RIGHT}0{RIGHT}1{TAB}{TAB}17220{RIGHT}10{RIGHT}3{TAB}172{RIGHT}1{BACKSPACE}{LEFT}16{RIGHT}11{RIGHT}1{ENTER}")
		EndIf

		WinWait("Local Area Connection Properties", "This c&onnection use")
		If Not WinActive("Local Area Connection Properties", "This c&onnection use") Then WinActivate("Local Area Connection Properties", "This c&onnection use")
		WinWaitActive("Local Area Connection Properties", "This c&onnection use")
		Send("{TAB}{TAB}{TAB}{TAB}{TAB}{TAB}{ENTER}")
		WinWait("Network Connections", "FolderView")
		If Not WinActive("Network Connections", "FolderView") Then WinActivate("Network Connections", "FolderView")
		WinWaitActive("Network Connections", "FolderView")
		Send("{ALTDOWN}{F4}{ALTUP}")
		#Region --- CodeWizard generated code Start ---
		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
		If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
		$iMsgBoxAnswer = MsgBox(64, "IP Settings", "IP Settings Set!", 1)
		Select
			Case $iMsgBoxAnswer = -1 ;Timeout
			Case Else                ;OK
		EndSelect
		#EndRegion --- CodeWizard generated code End ---
	EndIf
EndFunc   ;==>NetworkConnection


Func DefaultSite()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("inetcpl.cpl{ENTER}")
	WinWait("Internet Properties", "You can change which")
	If Not WinActive("Internet Properties", "You can change which") Then WinActivate("Internet Properties", "You can change which")
	WinWaitActive("Internet Properties", "You can change which")
	Send("http{SHIFTDOWN};{SHIFTUP}//intraweb.uec.co.za{ENTER}")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info, Timeout=1 ss
	If Not IsDeclared("iMsgBoxAnswer") Then Local $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(64, "Default Webpage", "Default webpage set as intraweb!", 1)
	Select
		Case $iMsgBoxAnswer = -1 ;Timeout
		Case Else                ;OK
	EndSelect
	#EndRegion --- CodeWizard generated code End ---	EndFunc
EndFunc   ;==>DefaultSite

Func VNCSetup()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\Desktop\vnc{SPACE}-{SPACE}uec{SPACE}std{SPACE}install\xxx.reg{ENTER}")
	WinWait("Registry Editor", "Are you sure you wan")
	If Not WinActive("Registry Editor", "Are you sure you wan") Then WinActivate("Registry Editor", "Are you sure you wan")
	WinWaitActive("Registry Editor", "Are you sure you wan")
	Send("{ENTER}")
	WinWait("Registry Editor", "Information in \\uec")
	If Not WinActive("Registry Editor", "Information in \\uec") Then WinActivate("Registry Editor", "Information in \\uec")
	WinWaitActive("Registry Editor", "Information in \\uec")
	Send("{ENTER}")

	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\Desktop\vnc{SPACE}{SPACE}-{BACKSPACE}{BACKSPACE}-{SPACE}uec{SPACE}std{SPACE}install\vnc-3.3.6-x86_win32.exe{ENTER}")
	WinWait("Setup", "This will install VN")
	If Not WinActive("Setup", "This will install VN") Then WinActivate("Setup", "This will install VN")
	WinWaitActive("Setup", "This will install VN")
	Send("{ENTER}")
	WinWait("Setup - VNC", "&Next >")
	If Not WinActive("Setup - VNC", "&Next >") Then WinActivate("Setup - VNC", "&Next >")
	WinWaitActive("Setup - VNC", "&Next >")
	Send("{ENTER}")
	WinWait("Setup - VNC", "< &Back")
	If Not WinActive("Setup - VNC", "< &Back") Then WinActivate("Setup - VNC", "< &Back")
	WinWaitActive("Setup - VNC", "< &Back")
	Send("{TAB}{TAB}{ENTER}")
	WinWait("Setup - VNC", "C:\Program Files\Rea")
	If Not WinActive("Setup - VNC", "C:\Program Files\Rea") Then WinActivate("Setup - VNC", "C:\Program Files\Rea")
	WinWaitActive("Setup - VNC", "C:\Program Files\Rea")
	Send("{ENTER}{ENTER}")
	WinWait("Setup - VNC", "&Don't create a Star")
	If Not WinActive("Setup - VNC", "&Don't create a Star") Then WinActivate("Setup - VNC", "&Don't create a Star")
	WinWaitActive("Setup - VNC", "&Don't create a Star")
	Send("{ENTER}")
	WinWait("Setup - VNC", "Start the VNC Server")
	If Not WinActive("Setup - VNC", "Start the VNC Server") Then WinActivate("Setup - VNC", "Start the VNC Server")
	WinWaitActive("Setup - VNC", "Start the VNC Server")
	Send("{DOWN}{DOWN}{SPACE}{DOWN}{SPACE}{ENTER}{ENTER}")
	WinWait("WinVNC", "The WinVNC service w")
	If Not WinActive("WinVNC", "The WinVNC service w") Then WinActivate("WinVNC", "The WinVNC service w")
	WinWaitActive("WinVNC", "The WinVNC service w")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "VNC Installed", "Please press OK when VNC has complete its installation!")
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>VNCSetup


Func TrendAntiVirus()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("https://ueczaav02.uectech.net:4343/officescan{ENTER}")
	#endregion --- ScriptWriter generated code End ---
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Warning
	MsgBox(48, "Trend Installation", "Please continue with the Trend setup and click OK once complete!")
	#EndRegion --- CodeWizard generated code End ---
EndFunc   ;==>TrendAntiVirus



Func ZipCentral()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\desktop\zipcentral\zipcntrlsetup.exe{ENTER}")
	WinWait("Setup - ZipCentral", "&Next >")
	If Not WinActive("Setup - ZipCentral", "&Next >") Then WinActivate("Setup - ZipCentral", "&Next >")
	WinWaitActive("Setup - ZipCentral", "&Next >")
	Send("{ENTER}")
	WinWait("Setup - ZipCentral", "< &Back")
	If Not WinActive("Setup - ZipCentral", "< &Back") Then WinActivate("Setup - ZipCentral", "< &Back")
	WinWaitActive("Setup - ZipCentral", "< &Back")
	Send("y{TAB}{TAB}{ENTER}")
	WinWait("Setup - ZipCentral", "C:\Program Files\Zip")
	If Not WinActive("Setup - ZipCentral", "C:\Program Files\Zip") Then WinActivate("Setup - ZipCentral", "C:\Program Files\Zip")
	WinWaitActive("Setup - ZipCentral", "C:\Program Files\Zip")
	Send("{ENTER}{ENTER}")
	WinWait("Setup - ZipCentral", "Create a &desktop ic")
	If Not WinActive("Setup - ZipCentral", "Create a &desktop ic") Then WinActivate("Setup - ZipCentral", "Create a &desktop ic")
	WinWaitActive("Setup - ZipCentral", "Create a &desktop ic")
	Send("{ENTER}{ENTER}")
	#endregion --- ScriptWriter generated code End ---
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "ZipCentral Installed", "Please press OK when ZipCentral installation is complete!")
	#EndRegion --- CodeWizard generated code End ---
	Send("{ENTER}")
EndFunc   ;==>ZipCentral

Func OpenOffice()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run","Type the name of a p")
	If Not WinActive("Run","Type the name of a p") Then WinActivate("Run","Type the name of a p")
	WinWaitActive("Run","Type the name of a p")
	Send("\\ueczashr02\data\{SHIFTDOWN}s{SHIFTUP}oftware\{SHIFTDOWN}a{SHIFTUP}pplications\{SHIFTDOWN}d{SHIFTUP}esktop\{SHIFTDOWN}o{SHIFTUP}pen{SPACE}{SHIFTDOWN}o{SHIFTUP}ffice\{SHIFTDOWN}oo{SHIFTUP}o{SHIFTDOWN}-{SHIFTUP}3.0.0.exe{ENTER}")
	WinWait("OpenOffice.org 3.0 Installation Preparation","Thank you for downlo")
	If Not WinActive("OpenOffice.org 3.0 Installation Preparation","Thank you for downlo") Then WinActivate("OpenOffice.org 3.0 Installation Preparation","Thank you for downlo")
	WinWaitActive("OpenOffice.org 3.0 Installation Preparation","Thank you for downlo")
	Send("{ENTER}")
	WinWait("OpenOffice.org 3.0 Installation Preparation ","Nullsoft Install Sys")
	If Not WinActive("OpenOffice.org 3.0 Installation Preparation ","Nullsoft Install Sys") Then WinActivate("OpenOffice.org 3.0 Installation Preparation ","Nullsoft Install Sys")
	WinWaitActive("OpenOffice.org 3.0 Installation Preparation ","Nullsoft Install Sys")
	Send("c{SHIFTDOWN};{SHIFTUP}\{SHIFTDOWN}s{SHIFTUP}oftar{BACKSPACE}{BACKSPACE}ware\{SHIFTDOWN}o{SHIFTUP}pen{SHIFTDOWN}o{SHIFTUP}ffice{ENTER}")
	WinWait("OpenOffice.org 3.0 - Installation Wizard","Build contributed in")
	If Not WinActive("OpenOffice.org 3.0 - Installation Wizard","Build contributed in") Then WinActivate("OpenOffice.org 3.0 - Installation Wizard","Build contributed in")
	WinWaitActive("OpenOffice.org 3.0 - Installation Wizard","Build contributed in")
	Send("{ENTER}")
	WinWait("OpenOffice.org 3.0 - Installation Wizard","&Anyone who uses thi")
	If Not WinActive("OpenOffice.org 3.0 - Installation Wizard","&Anyone who uses thi") Then WinActivate("OpenOffice.org 3.0 - Installation Wizard","&Anyone who uses thi")
	WinWaitActive("OpenOffice.org 3.0 - Installation Wizard","&Anyone who uses thi")
	Send("{SHIFTDOWN}a{SHIFTUP}ltech{SPACE}{SHIFTDOWN}uec{SPACE}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{TAB}{SHIFTDOWN}a{SHIFTUP}ltech{SPACE}{SHIFTDOWN}uec{SPACE}9p{SHIFTUP}ty{SHIFTDOWN}0{SHIFTUP}{SPACE}{SHIFTDOWN}l{SHIFTUP}td{ENTER}")
	WinWait("OpenOffice.org 3.0 - Installation Wizard","Choose the setup typ")
	If Not WinActive("OpenOffice.org 3.0 - Installation Wizard","Choose the setup typ") Then WinActivate("OpenOffice.org 3.0 - Installation Wizard","Choose the setup typ")
	WinWaitActive("OpenOffice.org 3.0 - Installation Wizard","Choose the setup typ")
	Send("{ENTER}")
	WinWait("OpenOffice.org 3.0 - Installation Wizard","The wizard is ready ")
	If Not WinActive("OpenOffice.org 3.0 - Installation Wizard","The wizard is ready ") Then WinActivate("OpenOffice.org 3.0 - Installation Wizard","The wizard is ready ")
	WinWaitActive("OpenOffice.org 3.0 - Installation Wizard","The wizard is ready ")
	Send("{ENTER}")
	WinWait("OpenOffice.org 3.0 - Installation Wizard","Installation Wizard ")
	If Not WinActive("OpenOffice.org 3.0 - Installation Wizard","Installation Wizard ") Then WinActivate("OpenOffice.org 3.0 - Installation Wizard","Installation Wizard ")
	WinWaitActive("OpenOffice.org 3.0 - Installation Wizard","Installation Wizard ")
	Send("{ENTER}")
	MsgBox(64, "Open Office", "Please press OK when Open Office has complete its installation!")
EndFunc   ;==>OpenOffice



Func AdminRights()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("compmgmt.msc{ENTER}")
	WinWait("Computer Management", "Computer Management ")
	If Not WinActive("Computer Management", "Computer Management ") Then WinActivate("Computer Management", "Computer Management ")
	WinWaitActive("Computer Management", "Computer Management ")
	Send("{DOWN}{DOWN}{DOWN}{DOWN}{RIGHT}{DOWN}{DOWN}{TAB}{ENTER}")
	WinWait("Administrators Properties", "D&escription:")
	If Not WinActive("Administrators Properties", "D&escription:") Then WinActivate("Administrators Properties", "D&escription:")
	WinWaitActive("Administrators Properties", "D&escription:")
	Send("{TAB}{TAB}{ENTER}")
	#endregion --- ScriptWriter generated code End ---
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Admin Rights", "Please give the user admin rights." & @CRLF & "When complete click OK!")
EndFunc   ;==>AdminRights


Func OfficePro03()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Application\{BACKSPACE}s\desktop\{SPACE}{BACKSPACE}microsoft{SPACE}office{BACKSPACE}{BACKSPACE}ce\office{SPACE}{BACKSPACE}2003\setuppro.exe{ENTER}")
	;WinWait("Open File - Security Warning","Do you want to run t")
	;If Not WinActive("Open File - Security Warning","Do you want to run t") Then WinActivate("Open File - Security Warning","Do you want to run t")
	;WinWaitActive("Open File - Security Warning","Do you want to run t")
	;Send("r")
	WinWait("Microsoft Office 2003 Setup", "In the boxes below, ")
	If Not WinActive("Microsoft Office 2003 Setup", "In the boxes below, ") Then WinActivate("Microsoft Office 2003 Setup", "In the boxes below, ")
	WinWaitActive("Microsoft Office 2003 Setup", "In the boxes below, ")
	Send("w2d4pg8cdm9j2qdjp66gvjbqy{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office Pro") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	Send("{SHIFTDOWN}ue{SPACE}{SHIFTUP}{BACKSPACE}{SHIFTDOWN}c{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{TAB}{TAB}{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "To continue with Off")
	If Not WinActive("Microsoft Office 2003 Setup", "To continue with Off") Then WinActivate("Microsoft Office 2003 Setup", "To continue with Off")
	WinWaitActive("Microsoft Office 2003 Setup", "To continue with Off")
	Send("{SPACE}{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Type of Installation")
	If Not WinActive("Microsoft Office 2003 Setup", "Type of Installation") Then WinActivate("Microsoft Office 2003 Setup", "Type of Installation")
	WinWaitActive("Microsoft Office 2003 Setup", "Type of Installation")
	Send("{DOWN}{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office Pro") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office Pro")
	Send("{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office 200")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office 200") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office 200")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office 200")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Ms Office Installed", "Please press OK when Ms Office has complete its installation!")
	#EndRegion --- CodeWizard generated code End ---EndFunc
	OfficeSP2()
EndFunc   ;==>OfficePro





Func OfficeStd03()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\Desktop\microf{BACKSPACE}soft{SPACE}windows{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}office\office2003\setupstd.exe{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "In the boxes below, ")
	If Not WinActive("Microsoft Office 2003 Setup", "In the boxes below, ") Then WinActivate("Microsoft Office 2003 Setup", "In the boxes below, ")
	WinWaitActive("Microsoft Office 2003 Setup", "In the boxes below, ")
	Send("w2d4pg8cdm9j2qdjp66gvjbqy{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office Sta") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	Send("{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}r{BACKSPACE}td{TAB}{TAB}{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "To continue with Off")
	If Not WinActive("Microsoft Office 2003 Setup", "To continue with Off") Then WinActivate("Microsoft Office 2003 Setup", "To continue with Off")
	WinWaitActive("Microsoft Office 2003 Setup", "To continue with Off")
	Send("{SPACE}{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Type of Installation")
	If Not WinActive("Microsoft Office 2003 Setup", "Type of Installation") Then WinActivate("Microsoft Office 2003 Setup", "Type of Installation")
	WinWaitActive("Microsoft Office 2003 Setup", "Type of Installation")
	Send("{DOWN}{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office Sta") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office Sta")
	Send("{ENTER}")
	WinWait("Microsoft Office 2003 Setup", "Microsoft Office 200")
	If Not WinActive("Microsoft Office 2003 Setup", "Microsoft Office 200") Then WinActivate("Microsoft Office 2003 Setup", "Microsoft Office 200")
	WinWaitActive("Microsoft Office 2003 Setup", "Microsoft Office 200")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Ms Office Installed", "Please press OK when Ms Office has complete its installation!")
	#EndRegion --- CodeWizard generated code End ---EndFunc
	OfficeSP2()
EndFunc   ;==>OfficeStd

Func Project03()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\dek{BACKSPACE}sktop\ms{BACKSPACE}icrosoft{SPACE}project\se{BACKSPACE}{BACKSPACE}project0{BACKSPACE}2003\setup.exe{ENTER}")
	WinWait("Microsoft Office Project Professional 2003 Setup", "In the boxes below, ")
	If Not WinActive("Microsoft Office Project Professional 2003 Setup", "In the boxes below, ") Then WinActivate("Microsoft Office Project Professional 2003 Setup", "In the boxes below, ")
	WinWaitActive("Microsoft Office Project Professional 2003 Setup", "In the boxes below, ")
	Send("bfwky3pb8dctc3tw38fbf9cmb{ENTER}")
	WinWait("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	If Not WinActive("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro") Then WinActivate("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	WinWaitActive("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	Send("{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9[p{SHIFTUP}{BACKSPACE}{BACKSPACE}{SHIFTDOWN}p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{TAB}{TAB}{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{ENTER}")
	WinWait("Microsoft Office Project Professional 2003 Setup", "To continue with Pro")
	If Not WinActive("Microsoft Office Project Professional 2003 Setup", "To continue with Pro") Then WinActivate("Microsoft Office Project Professional 2003 Setup", "To continue with Pro")
	WinWaitActive("Microsoft Office Project Professional 2003 Setup", "To continue with Pro")
	Send("{SPACE}{ENTER}")
	WinWait("Microsoft Office Project Professional 2003 Setup", "Type of Installation")
	If Not WinActive("Microsoft Office Project Professional 2003 Setup", "Type of Installation") Then WinActivate("Microsoft Office Project Professional 2003 Setup", "Type of Installation")
	WinWaitActive("Microsoft Office Project Professional 2003 Setup", "Type of Installation")
	Send("{DOWN}{ENTER}")
	WinWait("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	If Not WinActive("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro") Then WinActivate("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	WinWaitActive("Microsoft Office Project Professional 2003 Setup", "Microsoft Office Pro")
	Send("{ENTER}{ENTER}")
EndFunc   ;==>Project03

Func SourceSafe()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr02\data\Software\Applications\Desktop\visual{SPACE}sourcesafe{SPACE}6\setup.exe{ENTER}")
	WinWait("Installation Wizard for Visual SourceSafe 6.0d", "The Visual SourceSaf")
	If Not WinActive("Installation Wizard for Visual SourceSafe 6.0d", "The Visual SourceSaf") Then WinActivate("Installation Wizard for Visual SourceSafe 6.0d", "The Visual SourceSaf")
	WinWaitActive("Installation Wizard for Visual SourceSafe 6.0d", "The Visual SourceSaf")
	Send("{ENTER}")
	WinWait("Installation Wizard for Visual SourceSafe 6.0d", "I &accept the agreem")
	If Not WinActive("Installation Wizard for Visual SourceSafe 6.0d", "I &accept the agreem") Then WinActivate("Installation Wizard for Visual SourceSafe 6.0d", "I &accept the agreem")
	WinWaitActive("Installation Wizard for Visual SourceSafe 6.0d", "I &accept the agreem")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Sourcesafe Installing", "Please press OK when Sourcesafe has complete its installation!")
	#EndRegion --- CodeWizard generated code End ---EndFunc
EndFunc   ;==>SourceSafe


Func codewright6()
	Send("{LWINDOWN}r{LWINUP}")
	WinWait("Run", "Type the name of a p")
	If Not WinActive("Run", "Type the name of a p") Then WinActivate("Run", "Type the name of a p")
	WinWaitActive("Run", "Type the name of a p")
	Send("\\ueczashr01\data\Software\Applications\Desktop\codewi{BACKSPACE}right6\setup.exe{ENTER}")
	WinWait("Welcome", "Welcome to the CodeW")
	If Not WinActive("Welcome", "Welcome to the CodeW") Then WinActivate("Welcome", "Welcome to the CodeW")
	WinWaitActive("Welcome", "Welcome to the CodeW")
	Send("{ENTER}")
	WinWait("Software License Agreement", "Please read the foll")
	If Not WinActive("Software License Agreement", "Please read the foll") Then WinActivate("Software License Agreement", "Please read the foll")
	WinWaitActive("Software License Agreement", "Please read the foll")
	Send("y{ENTER}")
	WinWait("User Registration", "For your convenience")
	If Not WinActive("User Registration", "For your convenience") Then WinActivate("User Registration", "For your convenience")
	WinWaitActive("User Registration", "For your convenience")
	Send("{SHIFTDOWN}uec{SHIFTUP}{SPACE}{SHIFTDOWN}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{TAB}{SHIFTDOWN}uec{SPACE}t{SHIFTUP}echnologies{SPACE}{SHIFTDOWN}9p{SHIFTUP}ty{SHIFTDOWN}0{SPACE}l{SHIFTUP}td{TAB}cw600-mwrj-12049{ENTER}")
	WinWait("Installation Directory", "Setup will install t")
	If Not WinActive("Installation Directory", "Setup will install t") Then WinActivate("Installation Directory", "Setup will install t")
	WinWaitActive("Installation Directory", "Setup will install t")
	Send("{ENTER}")
	WinWait("Installation Type", "Click the type of in")
	If Not WinActive("Installation Type", "Click the type of in") Then WinActivate("Installation Type", "Click the type of in")
	WinWaitActive("Installation Type", "Click the type of in")
	Send("{ENTER}")
	WinWait("Initial Keymap Emulation", "Select the initial k")
	If Not WinActive("Initial Keymap Emulation", "Select the initial k") Then WinActivate("Initial Keymap Emulation", "Select the initial k")
	WinWaitActive("Initial Keymap Emulation", "Select the initial k")
	Send("{ENTER}")
	WinWait("CodeWright Sync Technology", "Microsoft Visual Bas")
	If Not WinActive("CodeWright Sync Technology", "Microsoft Visual Bas") Then WinActivate("CodeWright Sync Technology", "Microsoft Visual Bas")
	WinWaitActive("CodeWright Sync Technology", "Microsoft Visual Bas")
	Send("{ENTER}")
	WinWait("Select Program Folder", "Setup will add progr")
	If Not WinActive("Select Program Folder", "Setup will add progr") Then WinActivate("Select Program Folder", "Setup will add progr")
	WinWaitActive("Select Program Folder", "Setup will add progr")
	Send("{ENTER}")
	WinWait("CodeWright", "FolderView")
	If Not WinActive("CodeWright", "FolderView") Then WinActivate("CodeWright", "FolderView")
	WinWaitActive("CodeWright", "FolderView")
	#Region --- CodeWizard generated code Start ---
	;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Info
	MsgBox(64, "Codewright Installing", "Please press OK when Codewright has complete its installation!")
	#EndRegion --- CodeWizard generated code End ---EndFunc
EndFunc   ;==>codewright6


