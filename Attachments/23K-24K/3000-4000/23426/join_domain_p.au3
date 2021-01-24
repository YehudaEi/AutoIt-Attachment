#include <GUIConstants.au3>

;This script will silently join the PC to the domain and rename it conform the Company Policy.
;Written with: SciTE4AutoIt3 Version 1.76
;Compiled with: AutoIt v3.2.12.1
;This script will run just once
;Created by UniPer
;Variables must be declared before using them

AutoItSetOption("TrayMenuMode",1)

;The name of the application (used as title for message boxes)
Global $appName = "Domain Tool V1.1"
Global $logonFlag = 0 ; 0 - Interactive logon with no profile. 1 - Interactive logon with profile. 2 - Network Global $extraParameters = " /silent" ; " /silent" ""
Global $runAsWaitFlag = @SW_SHOW ; @SW_HIDE @SW_SHOW

$netdom = "C:\temp\netdom.exe"

	If Not FileExists ("C:\windows\stage1.chk") Then
	;The registry will be overwritten with a fixed username and password and AutoLogon will be enabled
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUserName")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon")
	RegDelete ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon")

	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultDomainName", "REG_SZ", "")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultUsername" , "REG_SZ", "*******")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "DefaultPassword" , "REG_SZ", "*******")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "AutoAdminLogon" , "REG_SZ", "1")
	RegWrite ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon", "ForceAutoLogon" , "REG_SZ", "1")
	TrayTip($appName & " - Autologon is Enabled", "AutoLogon Enabled.. ", 1)
	TraySetToolTip($appName & " - Autologon is Enabled")
	Sleep ( 3000 )

	;Newsid.exe will run silently and will provide a new ID for the system
	ShellExecute ( "C:\temp\newsid", "/a" )
	Sleep ( 3000 )
	Send ("{SPACE}")
	TrayTip($appName & " - Your SystemID renewed ", "Your SystemID has been renewed", 1)
	TraySetToolTip($appName & " - Your SystemID renewed " )
	
	;Stage1.chk will be copied to the Windows directory to be sure the script came this far
	FileCopy ( "C:\temp\stage1.chk", "C:\windows\")
	
	Sleep ( 3000 )
	TrayTip($appName & " - System reboot..", "System will reboot in a few minutes..", 1)
	TraySetToolTip($appName & " - System reboot.." )
	Sleep ( 10000 )
	Shutdown (2)
	
Else
	If Not FileExists ("C:\windows\stage2.chk") then
		;Script will read the Machine Serialnumber from the registry to convert it into variable $reg
		Dim $reg = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Organization\Setup", "MachineSerial")

		;$reg will be changed with so that the new serial is: NL-XXXXXXX after that this will be converted to variable $serial 
		Dim $serial="NL-"& $reg
		TrayTip($appName & " - Systemserial is:", "The Machines Serial is "& $serial, 1 )
		TraySetToolTip($appName & " - Systemserial is:")
		
		#include <GUIConstants.au3>

		GUICreate("Rename", 255, 85, 255, 255)
		GUICtrlCreateLabel("Please type the new computername", 5, 5)
		GUICtrlSetState(-1, $GUI_DROPACCEPTED)
		$inv = GUICtrlCreateInput($serial, 75, 25, 100, 20)
		$btn = GUICtrlCreateButton("Rename", 95, 55, 60, 20)
		GUISetState(@SW_SHOW)

		While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE
					ExitLoop
				Case $msg = $btn
						_Rename()
					ExitLoop
			EndSelect
		WEnd
		
		Send ("{}")
		Send ("{SPACE}")

		;Stage2.chk will be copied to the Windows directory to be sure the script came this far
		FileCopy ( "C:\temp\stage2.chk", "C:\windows\")
		
		send ("{ENTER}")
			
	Shutdown (2)
	
Else
	If Not FileExists ("C:\windows\stage3.chk") then
		;System will be joined to the Domain
		RunWait (@Comspec & ' /k ' & $netdom & ' join . /Domain:DOMAIN.COM /UserD:******* /PasswordD:******* ')
		Sleep (2000)
		send ("{y}")
		Sleep (2000)
		Send ("{exit}")
		TrayTip($appName & " - System joined DOMAIN", "System joined the DOMAIN.COM Domain", 1)
		TraySetToolTip($appName & " - System joined DOMAIN")
		Sleep ( 3000 )
		TrayTip($appName & " - System reboot..", "System will reboot in a few seconds..", 1)
		TraySetToolTip($appName & " - System reboot..")
	
		;Stage2.chk will be copied to the Windows directory to be sure the script came this far
		FileCopy ( "C:\temp\stage2.chk", "C:\windows\")
		Sleep (10000)

		;The Registry will be restored to his old original state and AutoLogon will be disabled
		ShellExecute ( "C:\windows\regedit", "-s C:\temp\restore_reg.reg" )
		TrayTip($appName & " - Autologon is Disabled", "Autologon disabled again", 1)
		TraySetToolTip($appName & " - Autologon is Disabled")
	
		;Stage3.chk will be copied to the Windows directory to be sure the script came this far
		FileCopy ( "C:\temp\stage3.chk", "C:\windows\")
	
		Sleep ( 3000 )
		TrayTip($appName & " - System reboot..", "System will reboot in a few seconds..", 1)
		TraySetToolTip($appName & " - System reboot..")
		Shutdown ( 2 )
	Else
		MsgBox (4096, "Finished", "System is Configured")
		Shutdown (2)
	EndIf
EndIf
EndIf

	
Func _Rename()

	Run(@ComSpec & " /c sysdm.cpl", "", @SW_HIDE)
	WinWaitActive("System Properties")
	Send("{RIGHT}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{TAB}")
	Send("{ENTER}")
	$x = GUICtrlRead($inv)
	Send($x)
EndFunc   ;==>_Rename

