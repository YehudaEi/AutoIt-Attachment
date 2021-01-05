#Include <process.au3>
#Include <date.au3>
;Run as administrator account under ScriptLogic
RunAsSet("stanley", "ujcna", "H@ymm3r$", 0)

If @ComputerName="NY-CITRIX01" Then
	Exit(0)
EndIF

If @ComputerName="NY-CITRIX02" Then
	Exit(0)
EndIF

;Current Version on Server
;$current_version=RegRead("\\ny-srvrre7\HKEY_LOCAL_MACHINE\SOFTWARE\BLACKBAUD\REINI\The Raiser's Edge 7\General", "Version")
$current_version=IniRead( "\\ny-srvrre7\d$\Program Files\Blackbaud\The Raisers Edge 7\Deploy\deploy.ini", "General", "ServerDelta", "0" )

;If @error <> 0 Then
;	MsgBox (48, "Install Error", "Error accessing RE 7 Server's Registry")
;	Exit(0)
;EndIf

;Boolean value to trigger whether install is to run
$run="0"

;$version = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\BLACKBAUD\REINI\The Raiser's Edge 7\General", "Version")
$version=IniRead( "c:\Program Files\Blackbaud\The Raisers Edge 7\BBUpdate.ini", "General", "ServerDelta", "0" )

;If @error <> 0 Then
If $version = 0 Then
	;Run Install Wizard - Program is not installed
	$run="1"
Else
	;Check Version in REINI Registry Key vs. $current_version variable (which is set above)
	If $version <> $current_version then
		$run="2"
	EndIf
EndIf

SetError (0)

;If $run = "0" then
;	;Check to see if useAdmin exe was already created
;	If FileExists ("C:\Program Files\Blackbaud\The Raisers Edge 7\RunRE7.exe") = 0 Then
;		;Copy exe that uses Admin rights
;		FileCopy ("\\ny-srvrre7\RE7_Share\AutoInstall\RunRE7.exe", "C:\Program Files\Blackbaud\The Raisers Edge 7\")
;		FileMove (@DesktopCommonDir & "\The Raiser*.*", "C:\Program Files\Blackbaud\The Raiser*.*", 1)
;		FileDelete (@DesktopCommonDir & "\The Raiser*")
;		FileCreateShortcut ("C:\Program Files\Blackbaud\The Raisers Edge 7\RunRE7.exe", @DesktopCommonDir & "\The Raisers Edge 7.lnk","C:\Program Files\Blackbaud\The Raisers Edge 7\","","The Raisers Edge 7", "C:\Program Files\Blackbaud\The Raisers Edge 7\RE7.exe","","","")
;		_RunDOS("regedit.exe /s \\ny-srvrre7\RE7_Share\AutoInstall\columns_registry\relationship_all.reg")
;		_RunDOS("regedit.exe /s \\ny-srvrre7\RE7_Share\AutoInstall\columns_registry\relationship_org.reg")
;	EndIf
;
;	;If FileExists (@DesktopCommonDir + "\The Raiser*.*") = 0 Then
;
;;	$details = FileGetShortcut(@DesktopCommonDir + "\The Raiser*.*")
;;	If $details[0] = "C:\Program Files\Blackbaud\The Raisers Edge 7\RE7.exe" then
;;		;Move Incorrect Shortcut
;;		
;;		;Create Shortcut
;;		FileCreateShortcut ("C:\Program Files\Blackbaud\The Raisers Edge 7\RunRE7.exe", @DesktopCommonDir & "\The Raisers Edge 7.lnk",@ProgramsCommonDir & "\Blackbaud\The Raisers Edge 7\","","The Raisers Edge 7", "C:\Program Files\Blackbaud\The Raisers Edge 7\RunRE7.exe","","","")
;;	EndIf
;
;	RunAsSet()
;	Exit(0)
;Else
If $run <> "0" then

	Run("\\ny-srvrre7\Deploy\Setup.exe")

;	WinWaitActive("InstallShield Wizard", "&Next")
	
	Do
		Sleep(10000)	
	Until (WinExists("InstallShield Wizard", "&Next") = 1)
	
	Send("{ENTER}")

;	WinWaitActive("InstallShield Wizard", "Finish")
	
	Sleep(160000)

	If WinExists("InstallShield Wizard", "InstallShield Wizard Complete") = 0 Then
;		Run("\\ny-srvrre7\re7_share\autoinstall\reregister.exe")
		MsgBox (0, "Install Test", "Press OK to continue")
		WinWaitActive("Install Test", "")
		Send("{ENTER}")
	EndIf

	Do
		Sleep(5000)	
		$Finish = (WinExists("InstallShield Wizard", "Yes, I want to restart my computer now.") = 1)
		
		If $Finish <> 1 Then
			$Finish = (WinExists("InstallShield Wizard", "InstallShield Wizard Complete") = 1)
		EndIf

	Until $Finish = 1

;	$WinText = WinGetText("InstallShield Wizard", "InstallShield W")
	
	If WinExists("InstallShield Wizard", "Yes, I want to restart my computer now.") = 1 Then
		;Autologin next login as Admin if first install
		;If IniRead ("C:\Program Files\Blackbaud\The Raisers Edge 7\RE7AutoInstall.ini", "InitialInstall", "Installed", "0") = 0 Then
			;Copy Autologin
			If FileExists("C:\Program Files\Blackbaud\The Raisers Edge 7") = 0 Then
				DirCreate("C:\Program Files\Blackbaud\The Raisers Edge 7")
			EndIf
			FileCopy ("\\ny-srvrre7\RE7_Share\AutoInstall\autologon.exe", "C:\Program Files\Blackbaud\The Raisers Edge 7\")
			
			;Set aulologin infor to use stanley's login
			run("C:\Program Files\Blackbaud\The Raisers Edge 7\autologon.exe stanley ujcna H@ymm3r$")
			WinWaitActive("AutoLogon", "OK")
			Send("{ENTER}")

			;Create shortcut to new script to run in Startup folder
			FileCreateShortcut ("\\ny-srvrre7\RE7_Share\AutoInstall\resolveuser.exe", @StartupCommonDir & "\resolveuser.lnk", "\\ny-srvrre7\RE7_Share\AutoInstall\", "", "Resolve Admin User Name Reboot", "","","","")

			;Store User Name for Autologin
			;IniWrite ("C:\Program Files\Blackbaud\The Raisers Edge 7\RE7AutoInstall.ini", "InitialInstall", "UserName", @UserName)
		;EndIf
	EndIf

	;Use @ComputerName to keep track of computers updated
	Do
		$file = FileOpen("\\ny-srvrre7\RE7_Share\autoinstall\updatedcomputerlist.txt", 1)
		If $run = "1" Then
			FileWrite($file, @ComputerName & "," & "INSTALL" & "," & _NowCalc() & @CRLF)
		ElseIf $run = "2" Then
			FileWrite($file, @ComputerName & "," & "UPGRADE" & "," & _NowCalc() & @CRLF)
		EndIf
		FileClose ($file)
	Until @error = 0

	Send("{ENTER}")
	RunAsSet()
	Exit(0)
EndIf