;This script will silently join the PC to the domain and rename it conform the Company Policy.
;Written with: SciTE4AutoIt3 Version 1.76
;Compiled with: AutoIt v3.2.12.1
;This script will run just once
;Variables must be declared before using them

AutoItSetOption("TrayMenuMode",1)

;The name of the application (used as title for message boxes)
Global $appName = "Domain Tool V1.0"
Global $logonFlag = 0 ; 0 - Interactive logon with no profile. 1 - Interactive logon with profile. 2 - Network Global $extraParameters = " /silent" ; " /silent" ""
Global $runAsWaitFlag = @SW_SHOW ; @SW_HIDE @SW_SHOW



If Not FileExists ( " C:\windows\stage1.chk " ) Then
	;The registry will be overwritten with a fixed username and password and AutoLogon will be enabled
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon")

	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName", "REG_SZ", "")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUsername" , "REG_SZ", "******")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword" , "REG_SZ", "******")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon" , "REG_SZ", "1")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon" , "REG_SZ", "1")
	TrayTip($appName & " - Autologon is Enabled", "AutoLogon Enabled.. ", 6000)
	TraySetToolTip($appName & " - Autologon is Enabled")
	Sleep ( 3000 )
	;Newsid.exe will run silently and will provide a new ID for the system
	ShellExecute ( "C:\temp\newsid", "/a" )
	TrayTip($appName & " - Your SystemID renewed ", "Your SystemID has been renewed", 6000)
	TraySetToolTip($appName & " - Your SystemID renewed " )
	;Stage1.chk will be copied to the Windows directory to be sure the script came this far
	FileCopy("C:\temp\chk\stage1.chk", "C:\windows\")
	Sleep ( 3000 )
	TrayTip($appName & " - System reboot..", "System will reboot in a few minutes..", 6000)
	TraySetToolTip($appName & " - System reboot.." )
	Sleep ( 9999999 )
Else
	;Script will check if file 'stage1.chk' is stored in the Windows dir, if not, script will stop
	If Not FileExists ( "C:\windows\stage2.chk" ) Then
		;System will be joined to the Domain
		ShellExecute ( "C:\temp\netdom", "join . /Domain:GROUPINFRA.COM /UserD: /PasswordD:" )
		;Stage2.chk will be copied to the Windows directory to be sure the script came this far
		FileCopy("C:\temp\chk\stage2.chk", "C:\windows\")
		TrayTip($appName & " - System joined GROUPINFRA", "System joined the GROUPINFRA.COM Domain", 6000)
		TraySetToolTip($appName & " - System joined GROUPINFRA")
		Sleep ( 3000 )
		TrayTip($appName & " - System reboot..", "System will reboot in a few seconds..", 6000)
		TraySetToolTip($appName & " - System reboot..")
		Shutdown (2)
EndIf
	Else
		;Script will check if file 'stage2.chk' is stored in the Windows dir, if not, script will stop
		If FileExists ( "C:\stage2.chk" ) Then
			;Script will read the Machine Serialnumber from the registry to convert it into variable $reg
			Dim $reg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Organization\Setup", "MachineSerial")
			;$reg will be changed with so that the new serial is: NL-XXXXXXX after that this will be converted to variable $serial 
			Dim $serial="NL-"& $reg
			TrayTip($appName & " - Systemserial is:", "The Machines Serial is "& $serial, 6000)
			TraySetToolTip($appName & " - Systemserial is:")
			;System will be renamed to $serial
			RunWait ( "C:\temp\netdom renamecomputer . /newname:"& $serial )
			TrayTip($appName & " - System renamed", "System succesfully renamed to "& $serial, 6000 )
			TraySetToolTip($appName & " - System renamed")
			FileCopy("C:\temp\chk\stage3.chk", "C:\windows\")
			;The Registry will be restored to his old original state and AutoLogon will be disabled
			Run ( "C:\windows\regedit", "-s C:\temp\restore_reg.reg" )
			TrayTip($appName & " - Autologon is Disabled", "Autologon disabled again", 6000)
			TraySetToolTip($appName & " - Autologon is Disabled")
			Sleep ( 3000 )
			TrayTip($appName & " - System reboot..", "System will reboot in a few seconds..", 6000)
			TraySetToolTip($appName & " - System reboot..")
			Shutdown (2)
		Else
			MsgBox ( 4096, "Failure", " PC is not joined to GROUPINFRA.COM " )
		EndIf
	Endif
	