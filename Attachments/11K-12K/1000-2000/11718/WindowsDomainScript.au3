; Script created to assist Production Support Operations members with no Microsoft Experience
#include <GUIConstants.au3>

; User Authentication
$domainuser = ""
$password = ""

Opt("GUIOnEventMode", 1)  ; Change to OnEvent mode 
$mainwindow = GUICreate("Windows Domain Creation Assistance Utility", 400, 550)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
GUICtrlCreateLabel("Please choose the domain to join:", 30, 10)
; CONTEXT MENU
$contextMenu = GuiCtrlCreateContextMenu()
GuiCtrlCreateMenuItem("Context Menu", $contextMenu)
GuiCtrlCreateMenuItem("", $contextMenu) ;separator
GuiCtrlCreateMenuItem("&Properties", $contextMenu)

GuiCtrlCreateGroup("Domain Choices", 30, 80, "", 190)


GUICtrlCreateGroup ("",-99,-99,1,1)  ;close group
$radio1=GUICtrlCreateRadio ("Domain1.local", 40, 100, 120)
$radio2=GUICtrlCreateRadio ("Domain2.local", 40, 120, 120)
$radio3=GUICtrlCreateRadio ("Domain3.local", 40, 140, 120)
$radio4=GUICtrlCreateRadio ("Domain4.local", 40, 160, 120)
$radio5=GUICtrlCreateRadio ("Domain5.local", 40, 180, 120)
$radio6=GUICtrlCreateRadio ("Domain6.local", 40, 200, 120)
$radio7=GUICtrlCreateRadio ("Domain7.local", 40, 220, 120)
$radio8=GUICtrlCreateRadio ("Domain8.local", 40, 240, 120)
$radio9=GUICtrlCreateRadio ("Domain9.local", 40, 240, 120)

GUICtrlCreateLabel ("Enter Domain Name: (if not listed above)",  40, 280, 200,50)
$radio10=GuiCtrlCreateInput("", 40, 293, 200, 20)
GUICtrlSetState( -1, $GUI_FOCUS )

; Domain Options
$joindomain1=GuiCtrlCreateCheckbox("Create a New Domain", 40, 320, 160, 20)
$joindomain2=GuiCtrlCreateCheckbox("Join as a Domain Controller", 40, 340, 150, 20)
$joindomain3=GuiCtrlCreateCheckbox("Join as a Member Server", 40, 360, 140, 20)

GUICtrlCreateLabel("Input credentials to join the domain as:", 55, 395, 300,15)
GUICtrlCreateLabel ("User Name:",  40, 410, 80,15)
$domainuser=GuiCtrlCreateInput("", 110, 410, 140, 20)
GUICtrlCreateLabel ("Password:",  40, 430, 80,15)
$password=GuiCtrlCreateInput("", 110, 430, 140, 20)

$okbutton = GUICtrlCreateButton("OK", 70, 500, 60)
GUICtrlSetOnEvent($okbutton, "OKButton")
GUISetState(@SW_SHOW)

While 1
  Sleep(1000)  ; Idle around
WEnd

Func OKButton()
  ;read in password and logon
  $domainuser = GUICtrlRead($domainuser, 1)
  $password = GUICtrlRead($password, 1)
  For $i = 1 To 9
                $handle = Eval('radio' & $i)
                If GUICtrlRead($handle) = $GUI_CHECKED Then
					$domainname = GUICtrlRead($handle,1)
				EndIf
			Next
			; If I enable the option to read in the users typed domain the script fails...
			;ElseIf GUICtrlRead($radio10, 1) = 0 Then
				;	$domainname = GUICtrlRead($handle,1)
	For $i = 1 To 3
		$handle = Eval('joindomain' & $i)
		If GUICtrlRead($handle) = $GUI_CHECKED  Then
			$joinstate   = GUICtrlRead($handle, 1)
			MsgBox(0, "", $domainuser & " in " & $password)
			MsgBox(0, "", $joinstate & " in " & $domainname)
			If $joinstate = GUICtrlRead($joindomain1, 1) Then
				CreateDomain($domainname)
			EndIf
			If $joinstate = GUICtrlRead($joindomain2, 1) Then
				CheckIfDomainExists($domainname)
				JoinDC($domainname)
			EndIf
			If $joinstate = GUICtrlRead($joindomain3, 1) Then
				CheckIfDomainExists($domainname)
				JoinDomain($domainname)
			EndIf
			$handle = 0
			ExitLoop
		EndIf
	Next
	
  MsgBox(0, "GUI Event", "You pressed OK!")
EndFunc

Func CLOSEClicked()
  ;Note: at this point @GUI_CTRLID would equal $GUI_EVENT_CLOSE, 
  ;and @GUI_WINHANDLE would equal $mainwindow 
  MsgBox(0, "GUI Event", "You clicked CLOSE! Exiting...")
  Exit
EndFunc

Func CreateDomain($domainname)
	Run( "DCpromo" )
	WinWaitActive("Active Directory Installation Wizard", "This wizard helps you install Active Directory")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Domain controllers running Windows Server 2003")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Do you want this server to become a domain controller")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Create a new")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Type the full DNS name")
	Send($domainname)
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "This is the name that users")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "For best performance and recoverability")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "The SYSVOL folder stored the")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "DNS Registration Diagnostics")
	ControlCommand ( "In&stall and configure the DNS", "", 1032, "Check", "" )
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Permissions")
	ControlCommand ( "P&ermissions compatible", "", 1051, "Check", "" )
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Type and confirm the password")
	Send($password)
	Send("{TAB}")
	Send($password)
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "chose to")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Completing the Active Directory Installation")
	Send("{ENTER}")
	WinWaitActive("Active Directory Installation Wizard", "Windows must be restarted before")
	Send("!r")
	Exit
EndFunc

Func JoinDC($domainname)
	Run( "DCpromo" )
	WinWaitActive("Active Directory Installation Wizard", "This wizard helps you install Active Directory")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Domain controllers running Windows Server 2003")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Do you want this server to become a domain controller")
	Send("!a")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Type the user name")
	Send("!u")
	Send($domainuser)
	Send("!p")
	Send($password)
	Send("!d")
	Send($domainname)
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Enter the full DNS name of the existing domain")
	Send("!d")
	Send($domainname)
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "For best performance and recoverability")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "The SYSVOL folder stores the")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Type and confirm the password")
	Send($password)
	Send("{TAB}")
	Send($password)
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "chose to")
	Send("!n")
	WinWaitActive("Active Directory Installation Wizard", "Completing the Active Directory Installation")
	Send("{ENTER}")
	WinWaitActive("Active Directory Installation Wizard", "Windows must be restarted before")
	Send("!r")
	Exit
EndFunc

Func JoinDomain($domainname)
	Run( "rundll32.exe shell32.dll,Control_RunDLL sysdm.cpl,,1" )
	WinWaitActive("System Properties", "Computer Name")
	Send("!c")
	WinWaitActive("Computer Name Changes", "You can change the name and the membership")
	ControlCommand( "Computer Name Changes", "", 1008, "Check", "" )
	Send( "{TAB}" )
	Send($domainname)
	Send( "{ENTER}")
	WinWaitActive("Computer Name Changes", "Enter the name and password of an account")
	Send($domainuser)
	Send( "{TAB}" )
	Send($password)
	Send( "{ENTER}")
	WinWaitActive("Computer Name Changes", "Welcome to the")
	Send( "{ENTER}")
	WinWaitActive("Computer Name Changes", "You must restart this computer")
	Send( "{ENTER}")
	WinWaitActive("System Properties", "Computer Name")
	Send( "{TAB}" )
	Send( "{ENTER}")
	WinWaitActive("System Settings Change", "You must restart your computer before")
	Send("!y")
	Exit
EndFunc

; Does a ping of the domain chosen to try to minimize the failure rate.
Func CheckIfDomainExists($domainname)
	$rv = Ping($domainname); default is 4 seconds
	If NOT $rv Then
		MsgBox(262144,"Connectivity Problem with Domain Controller","A Domain Controller for " & $domainname & " could not be contacted." & @CRLF & "Please verify your DNS Settings.")
		Exit 0
	EndIf
EndFunc