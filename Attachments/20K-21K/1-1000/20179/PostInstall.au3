; ####################################################################
;
; Christoph Herdeg, May 10/2008
;                              
;
; ####################################################################


#include <PostInstall_Func.au3>

$s_ini_file = "PostInstall.ini"
$s_ini_sections = IniReadSectionNames($s_ini_file)

; Check if there is a running instance of "PostInstall.exe"
;$RVal = ProcessExists("PostInstall.exe") 
;If $RVal <> 0 Then
;	msgbox(16,"Error! Es läuft bereits eine Instanz von PostInstall.exe!", "")
;	Exit 
;EndIf

; Check if the INI-File exists
$RVal = FileExists($s_ini_file) 
If $RVal <> 1 Then
        msgbox(16,"Error! INI-Datei " & "PostInstall.ini" & "nicht gefunden!", "")
		Exit
EndIf
	
; Enter a static IP-Address
Do
	$s_IP = InputBox("IP-Adresse", "Bitte IP-Adresse eingeben: ", "", "", 300, 80)
	If @error Then 
		$s_IP = "DHCP"
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_IP)
Until $RVal = 0 And $s_IP <> '' Or @error

; Enter a SubNet-Mask
Do
	$s_Mask = InputBox("SubNet-Mask", "Bitte SubNet-Mask eingeben: ", "", "", 300, 80)
	If @error Then 
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_Mask)
Until $RVal = 0 And $s_Mask <> '' Or @error

; Enter the IP of the local subnet's Gateway
Do
	$s_GW = InputBox("Gateway-IP", "Bitte Gateway eingeben: ", "", "", 300, 80)
	If @error Then 
		ExitLoop
	EndIf
	$RVal = _IsValidIP($s_GW)
Until $RVal = 0 And $s_GW <> '' Or @error

; Configure of the GUI
Opt("GUIOnEventMode", 1)
$MainWindow = GUICreate("Netzwerk-Profile", 300, 80)  
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSEClicked")
Opt("GUICoordMode", 1)
GUICtrlcreateLabel("Bitte Profil auswählen: ", 10, 5)

; Read the running Settings
$s_current = IniRead($s_ini_file, "Settings", "Current", "")

; Create a list of the network-settings defined in the .ini file
$ComboBox = GUICtrlCreateCombo ($s_ini_sections[2],  10, 25, 280)
For $i = 3 To $s_ini_sections[0]
	if $i < $s_ini_sections[0] then 
		GuiCtrlSetData($ComboBox, $s_ini_sections[$i])
	else
		; Set the running settings as Default
		GuiCtrlSetData($ComboBox, $s_ini_sections[$i], $s_current)
	endif
Next

; Create the apply button
$ApplyButton = GUICtrlCreateButton("Anwenden", 190, 50, 100)
GUICtrlSetOnEvent($ApplyButton, "_ApplyButton")

; Show the GUI
GUISetState (@SW_SHOW)

; Run the GUI-Loop
While 1
	sleep(10)
Wend

; Read further settings defined in the ini file
$s_ToolsServer = IniRead($s_ini_file, "Settings", "ToolsServer", "")
$s_ToolsShare = IniRead($s_ini_file, "Settings", "ToolsShare", "")
$s_RegFile = IniRead($s_ini_file, "Settings", "RegFile", "")
$s_ADshare = IniRead($s_ini_file, "Settings", "ADshare", "")

$s_User_1 = IniRead($s_ini_file, "Settings", "User-1", "")
$s_Pass_1 = IniRead($s_ini_file, "Settings", "Pass-1", "")
$s_User_2 = IniRead($s_ini_file, "Settings", "User-2", "")
$s_Pass_2 = IniRead($s_ini_file, "Settings", "Pass-2", "")
$s_User_3 = IniRead($s_ini_file, "Settings", "User-3", "")
$s_Pass_3 = IniRead($s_ini_file, "Settings", "Pass-3", "")

$s_AdminUser = IniRead($s_ini_file, "Settings", "AdminUser", "")
$s_AdminPass = IniRead($s_ini_file, "Settings", "AdminPass", "")

; Create the pre-defined local users
If $s_User_1 And $s_Pass_1 <> "" then
	_NetUser($s_User_1, $s_Pass_1)
EndIf
If $s_User_2 And $s_Pass_2 <> "" then
	_NetUser($s_User_2, $s_Pass_2)
EndIf
If $s_User_3 And $s_Pass_3 <> "" then
	_NetUser($s_User_3, $s_Pass_3)
EndIf

; Reset the Registry Keys relevant for WindowsUpdate / WSUS
_ClearWuStatus()

; Find all local User-Accounts
Dim $output
_GetUserNames()

; Set certain attributes for all localen User-Accounts
For $element In $output
	$NewBits = BitOR($USER_NOCHANGEPASSWD, $USER_NOEXPIREPASSWD)
	_UserCtrlAttribs($element, "Clear", $NewBits)
Next

; Logon to the ToolsServer
$InfoValue = """Logon to" & $s_ToolsServer & "..."""
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "net use " & $s_ToolsServer & "\ipc$ /username:" & $s_AdminUser & " " & $s_AdminPass, "", @SW_HIDE)
GUIDelete()	

; Import the ITSC104 Security Policy
$InfoValue = "ITSC104-Policy setzen..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & $s_ToolsShare & "\itscpol.bat", "")
GUIDelete()	

; Install the Scheduler-Job for AD_Share
$InfoValue = "AD_Share einrichten...."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "if not exist %WINDIR%\tasks\At1.job at 06:00 /every:M,T,W,TH,F,S,SU " & $s_ADshare, "", @SW_HIDE)
GUIDelete()	

; Set pre-defined ACLs for several Registry Keys
$InfoValue = "Registry-ACLs setzen..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "regini " & $s_ToolsShare & "\_ntcheck_reg.txt", "", @SW_HIDE)
GUIDelete()	

; Set the required Default Registry Keys
$InfoValue = "Default Registry Keys setzen..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "regedit " & "/S " & $s_ToolsShare & "\" & $s_RegFile, "", @SW_HIDE)
GUIDelete()	

; Immediatley search for WindowsUpdates on WSUS-Server
$InfoValue = "WindowsUpdate anstossen..."
_InfoGui($InfoValue)
RunWait(@ComSpec & " /c " & "wuauclt.exe /detectnow", "", @SW_HIDE)
GUIDelete()	

MsgBox(0, "PostInstallation", "PostInstallation erfolgreich abgeschlossen.")
Exit