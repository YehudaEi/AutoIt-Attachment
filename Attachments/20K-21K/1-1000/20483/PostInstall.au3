; ####################################################################
;
; Christoph Herdeg, June 10/2008
;                              
;
; ####################################################################


; Define the include files
; ==============================================================================================
#include <PostInstall_Func.au3>


; Define global variables
; ==============================================================================================
Global $s_ini_file = "PostInstall.ini"
Global $s_ini_sections = IniReadSectionNames($s_ini_file)
Global $colNetwork = ""
Global $strEnable = "En&able"
Global $strDisable = "Disa&ble"


; Hide the damn Tray-Icon that nobody needs
; ==============================================================================================
#NoTrayIcon


; Recognize the current system's Operation System
; ==============================================================================================
Local $OSver = @OSVersion


; Check if there is a running instance of "PostInstall.exe"
; ==============================================================================================
;$RVal = ProcessExists("PostInstall.exe")
;If $RVal <> 0 Then
;	msgbox(16,"Error! Es läuft bereits eine Instanz von PostInstall.exe!", "")
;	Exit
;EndIf


; Check if the INI-File exists
; ==============================================================================================
$RVal = FileExists($s_ini_file)
If $RVal <> 1 Then
	MsgBox(16, "Error! INI-File " & "PostInstall.ini" & "not found!", "")
	Exit
EndIf


; Choose the Network Connection to configure
; ==============================================================================================
$InfoValue = "Searching for Network Connections on the system..."
_InfoGui($InfoValue)

; Create a list of the NICS
$NICdevices = _GetNetConNames(_NetConsFolderObject())

; Set the default values
$NICdefault = "Local Area Connection"
$NICselected = ""
GUIDelete()

; Configure of the GUI
$MainWindow = GUICreate("Network-Connections", 300, 80)

; Create the ComboBox containing the found network devices
$ComboBox = GUICtrlCreateCombo($NICdevices, 10, 25, 280)

; Create the apply button and the descriptive label
$ApplyButton = GUICtrlCreateButton("Apply", 190, 50, 100)
Opt("GUICoordMode", 1)
GUICtrlCreateLabel("Please choose a network connection: ", 10, 5)

For $i=0 To UBound($NICdevices) - 1
	GUICtrlSetData($ComboBox, $NICdevices[$i], $NICdevices[0])
Next

; Show the GUI
GUISetState(@SW_SHOW)

; Wait for a button to be clicked and do...whatever you shall do
While 1
    	Switch (GUIGetMsg())
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $ApplyButton
			; Return the selected entry
			$NICselected = GUICtrlRead($ComboBox)
			; Write the selected entry to the .ini-File to have it available later
			IniWrite($s_ini_file, "Settings", "Interface", $NICselected)
			GUIDelete()
			ExitLoop
	EndSwitch
WEnd


; Disable the NIC to activate the new settings
; ==============================================================================================
; Read from the .ini-File which network connection to use
$s_interface = IniRead($s_ini_file, "Settings", "Interface", "")

; Disable the NIC
$InfoValue = "Disabling Network Interface Card..."
_InfoGui($InfoValue)
If $OSver = "WIN_2000" Or $OSver = "WIN_XP" Or $OSver = "WIN_2003" Then
	_NicToggleOLD($s_interface, 0)
	Sleep(2000)
Else
	_NicToggleNEW($s_interface, 0)
	Sleep(2000)	
EndIf
GUIDelete()


; Enter the basic network information
; ==============================================================================================
; Enter a static IP-Address
Do
	$s_IP = InputBox("IP-Address", "Please enter an IP-Address (DHCP - Cancel/ESC): ", "", "", 300, 120)
	If @error Then
		$s_IP = "DHCP"
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_IP)
Until $RVal = 0 And $s_IP <> '' Or @error

; Enter a SubNet-Mask
Do
	$s_Mask = InputBox("SubNet-Mask", "Please enter a SubNet-Mask (DHCP - Cancel/ESC): ", "", "", 300, 120)
	If @error Then
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_Mask)
Until $RVal = 0 And $s_Mask <> '' Or @error

; Enter the IP of the local subnet's Gateway
Do
	$s_GW = InputBox("Gateway-IP", "Please enter a Gateway-IP (DHCP - Cancel/ESC): ", "", "", 300, 120)
	If @error Then
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_GW)
Until $RVal = 0 And $s_GW <> '' Or @error


; Choose the IP-Profile to use
; ==============================================================================================
; Configure of the GUI
$MainWindow = GUICreate("Network-Profiles", 300, 80)

; Create the apply button and the descriptive label
$ApplyButton = GUICtrlCreateButton("Apply", 190, 50, 100)
Opt("GUICoordMode", 1)
GUICtrlCreateLabel("Please choose a network profile: ", 10, 5)

; Read the running Settings
$s_current = IniRead($s_ini_file, "Settings", "Current", "")

; Create a list of the network-settings defined in the .ini file
$ComboBox = GUICtrlCreateCombo($s_ini_sections[2], 10, 25, 280)
For $i = 3 To $s_ini_sections[0]
	If $i < $s_ini_sections[0] Then
		GUICtrlSetData($ComboBox, $s_ini_sections[$i])
	Else
		; Set the running settings as Default
		GUICtrlSetData($ComboBox, $s_ini_sections[$i], $s_current)
	EndIf
Next

; Show the GUI
GUISetState(@SW_SHOW)

; Wait for a button to be clicked and do...whatever you shall do
While 1
	Switch (GUIGetMsg())
		Case $GUI_EVENT_CLOSE
			_CloseClicked()
		Case $ApplyButton
			_ApplyButton()
			ExitLoop ; this will get out of the loop
	EndSwitch
WEnd


; Re-enable the NIC to activate the new settings
; ==============================================================================================
; Read from the .ini-File which network connection to use
$s_interface = IniRead($s_ini_file, "Settings", "Interface", "")

; Reactivate the NIC
$InfoValue = "Re-Enabling Network Interface Card..."
_InfoGui($InfoValue)
If $OSver = "WIN_2000" Or $OSver = "WIN_XP" Or $OSver = "WIN_2003" Then
	_NicToggleOLD($s_interface, 1)
	Sleep(5000)
Else
	_NicToggleNEW($s_interface, 1)
	Sleep(5000)	
EndIf
GUIDelete()

; Wait for the NIC to become active and get an IP by DHCP or activate a static IP
Local $s_location 
$s_location = IniRead($s_ini_file, "Settings", "Current", $s_location)
If $s_location = "DHCP" Then
	$InfoValue = "Acquiring an IP-Address (DHCP)..."
	_InfoGui($InfoValue)
	Sleep(30000)
	GUIDelete()
Else
	$InfoValue = "Activating the IP-Address (static)..."
	_InfoGui($InfoValue)
	Sleep(1000)
	GUIDelete()
EndIf


; Read further settings defined in the ini file
; ==============================================================================================
; The settings which Servers and Shares to use
$s_ToolsServer = IniRead($s_ini_file, "Settings", "ToolsServer", "")
$s_ToolsShare = IniRead($s_ini_file, "Settings", "ToolsShare", "")
$s_RegFile = IniRead($s_ini_file, "Settings", "RegFile", "")
$s_ADshare = IniRead($s_ini_file, "Settings", "ADshare", "")

; The settings which User Accounts and Passwords to create
$s_User_1 = IniRead($s_ini_file, "Settings", "User-1", "")
$s_Pass_1 = IniRead($s_ini_file, "Settings", "Pass-1", "")
$s_User_2 = IniRead($s_ini_file, "Settings", "User-2", "")
$s_Pass_2 = IniRead($s_ini_file, "Settings", "Pass-2", "")
$s_User_3 = IniRead($s_ini_file, "Settings", "User-3", "")
$s_Pass_3 = IniRead($s_ini_file, "Settings", "Pass-3", "")

; The settings which administrative Account to use to logon to the ToolsServer
$s_AdminUser = IniRead($s_ini_file, "Settings", "AdminUser", "")
$s_AdminPass = IniRead($s_ini_file, "Settings", "AdminPass", "")


; Reset the Registry Keys relevant for WindowsUpdate / WSUS
; ==============================================================================================
$InfoValue = "Setting up ne new WSUS-Registration..."
_InfoGui($InfoValue)
_ClearWuStatus()
GUIDelete()


; Create the requires additional local users and set the required attributes to all accounts
; ==============================================================================================
$InfoValue = "Creating the D5100 User Accouts..."
_InfoGui($InfoValue)
If $s_User_1 And $s_Pass_1 <> "" Then
	_NetUser($s_User_1, $s_Pass_1)
EndIf
If $s_User_2 And $s_Pass_2 <> "" Then
	_NetUser($s_User_2, $s_Pass_2)
EndIf
If $s_User_3 And $s_Pass_3 <> "" Then
	_NetUser($s_User_3, $s_Pass_3)
EndIf
GUIDelete()

; Find all local User-Accounts
$InfoValue = "Enlisting all local User Accounts..."
_InfoGui($InfoValue)
$userAccounts = _GetUserNames()
GUIDelete()

; Set certain attributes for all localen User-Accounts
$InfoValue = "Clearing the ""Password never exprires"" attribute..."
_InfoGui($InfoValue)
For $i=0 To UBound($UserAccounts) - 1
	$NewBits = BitOR($USER_NOCHANGEPASSWD, $USER_NOEXPIREPASSWD)
	_UserCtrlAttribs($UserAccounts[$i], "Clear", $NewBits)
Next
GUIDelete()


; Process further steps of the compliance configuration: ITSC104, AD-Share, Reg.ACLs, Default Registry, WSUS-Search
; ==============================================================================================
; Logon to the ToolsServer
$InfoValue = """Logon to" & $s_ToolsServer & "..."""
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "net use " & $s_ToolsServer & "\ipc$ /username:" & $s_AdminUser & " " & $s_AdminPass, "", @SW_HIDE)
GUIDelete()

; Import the ITSC104 Security Policy
$InfoValue = "Set ITSC104 Security Policy..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & $s_ToolsShare & "\itscpol.bat", "")
GUIDelete()

; Install the Scheduler-Job for AD_Share
$InfoValue = "Setup AD_Share..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "if not exist %WINDIR%\tasks\At1.job at 06:00 /every:M,T,W,TH,F,S,SU " & $s_ADshare, "", @SW_HIDE)
GUIDelete()

; Set pre-defined ACLs for several Registry Keys
$InfoValue = "Change ACLs on certain Registry Keys..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "regini " & $s_ToolsShare & "\_ntcheck_reg.txt", "", @SW_HIDE)
GUIDelete()

; Set the required Default Registry Keys
$InfoValue = "Set Default Registry Keys..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "regedit " & "/S " & $s_ToolsShare & "\" & $s_RegFile, "", @SW_HIDE)
GUIDelete()

; Immediatley search for WindowsUpdates on WSUS-Server
$InfoValue = "Search for WindowsUpdates..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "wuauclt.exe /detectnow", "", @SW_HIDE)
GUIDelete()


; Tell the user that everything is great (and for fucks sake hope that this is nothing but the bare truth)
; ==============================================================================================
MsgBox(0, "PostInstallation", "PostInstallation successfully completed.")
Exit