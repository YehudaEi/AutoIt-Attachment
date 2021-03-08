; ===========================================================================================================================
; Title .........: Windows Firewall UDF
; AutoIt Version : 3.3.8.0
; UDF Version ...: 1.0
; Language ......: English
; Description ...: Functions for manipulating the Windows Firewall
; OS Support.....: Tested on XP (x86) and Windows 7 (x64)
; Author.........: JLogan3o13
;
; Function List:
; ==================
; _AddAuthorizedApp
; _AddPort
; _AllowExceptions
; _DeleteAuthorizedApp
; _DeleteOpenPort
; _DisableFirewall
; _EnableFirewall
; _ListAuthorizedApps (XP Only)
; _ListFirewallProperties
; _EnableNotifications
; _DisableNotifications
; _RestoreDefault
;============================================================================================================================



; #FUNCTION# ====================================================================================================================
; Name...........: _AddAuthorizedApp
; Description ...: Adds an application to the Windows Firewall Exception List
; Syntax.........: _AddAuthorizedApp($Name, $IPVer = 2, $FilePath, $Scope = 0, $Enabled = True)
; Parameters ....: $Name - Friendly name for the application.
;				   $FilePath - Path to executable.
;				   $IPVer -  IP Version (usually 2)
;				   $Scope - The scope of computers for which this executable is allowed. Options are:
;						0 - Any
;						1 - My network (subnet) only
;						2 - Custom list
;				   $Enabled - Create the application as initially disabled (default) or enabled.
; Notification...: Notification sent if creation fails.
; Example........: _AddAuthorizedApp("Movie Maker", @ProgramFilesDir & "\Movie Maker\moviemk.exe", 2, 0, True)
; ===============================================================================================================================
Func _AddAuthorizedApp($Name, $FilePath, $IPVer, $Scope, $Enabled = False)

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
	$app = ObjCreate("HNetCfg.FwAuthorizedApplication")
		$app.Name = $Name
		$app.IpVersion = $IPVer
		$app.ProcessImageFileName = $FilePath
		;$app.RemoteAddresses = $RemoteAddresses
		$app.Scope = $Scope
		$app.Enabled = $Enabled
	$profile.AuthorizedApplications.Add($app)
		If @error Then MsgBox(0, "", "Adding authorized application failed.")

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _AddPort
; Description ...: Adds a custom port to the Windows Firewall Exception List
; Syntax.........: _AddPort($Name, $PortNumber, $Scope, $Protocol = 6, $Enabled = False)
; Parameters ....: $Name - Friendly name for the port.
;				   $PortNumber - Number for the port.
;				   $Scope - The scope of computers for which this executable is allowed. Options are:
;						0 - Any
;						1 - My network (subnet) only
;						2 - Custom list
;				   $Protocol - TCP (6)[default] or UDP (17)
;				   $Enabled - Create the port as initially disabled (default) or enabled.
; Notification...: Notification sent if creation fails.
; Example........: _AddPort("MyTestPort", 9999, 0, 6, True)
; ===============================================================================================================================
Func _AddPort($Name, $PortNumber, $Scope, $Protocol = 6, $Enabled = False)

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
	$port = ObjCreate("HNetCfg.FWOpenPort")
	$port.Name = $Name
	$port.Port = $PortNumber
	$port.Scope = $Scope
	$port.Protocol = $Protocol
	$port.Enabled = $Enabled
	$profile.GloballyOpenPorts.Add($port)
		If @error Then MsgBox(0, "", "Port creation failed.")

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _AllowExceptions
; Description ...: Enable the Exceptions List of Applications
; Syntax.........: _AllowExceptions()
; Parameters ....: None.
; Example........: _AllowExceptions()
; ===============================================================================================================================
Func _AllowExceptions()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
		$profile.ExceptionsNotAllowed = False

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DeleteAuthorizedApp
; Description ...: Deletes an authorized application from the Exclusions List
; Syntax.........: _DeleteAuthorizedApp($Path)
; Parameters ....: $Path - Path to executable for authorized application.
; Example........: _DeleteAuthorizedApp(@ProgramFilesDir & "\Movie Maker\moviemk.exe")
; ===============================================================================================================================
Func _DeleteAuthorizedApp($Path)

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
	$aApps = $profile.AuthorizedApplications
		$aApps.Remove($Path)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DeleteOpenPort
; Description ...: Deletes a previously opened port from the Exclusions List
; Syntax.........: _DeleteOpenPort($PortNumber, $Protocol = 6)
; Parameters ....: $PortNumber - The port number to be deleted.
;				   $Protocol - TCP (6)[default] or UDP (17)
; Example........: _DeleteOpenPort(9999, 6)
; ===============================================================================================================================
Func _DeleteOpenPort($PortNumber, $Protocol = 6)

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
	$aApps = $profile.GloballyOpenPorts
		$aApps.Remove($PortNumber, $Protocol)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DisableFirewall
; Description ...: Disables the Windows Firewall
; Syntax.........: _DisableFirewall()
; Parameters ....: None
; Notification...: Message Box if Firewall is already disabled.
; Example........: _DisableFirewall()
; ===============================================================================================================================
Func _DisableFirewall()

	If @OSArch = "X64" Then
		$fwMgr = ObjCreate("HNetCfg.FwPolicy2")
		$profile = $fwMgr.CurrentProfileTypes
			If $fwMgr.FirewallEnabled($profile) = True Then
				$fwMgr.FirewallEnabled($profile) = False
			Else
				MsgBox(0, "", "The Firewall is already disabled.")
			EndIf
	Else
		$fwMgr = ObjCreate("HNetCfg.FwMgr")
		$profile = $fwMgr.LocalPolicy.CurrentProfile
			If $profile.FirewallEnabled = True Then
				$profile.FirewallEnabled = False
			Else
				MsgBox(0, "", "The Firewall is already disabled.")
			EndIf
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _EnableFirewall
; Description ...: Enables the Windows Firewall
; Syntax.........: _EnableFirewall()
; Parameters ....: None
; Notification...: Message Box if Firewall is already enabled.
; Example........: _EnableFirewall()
; ===============================================================================================================================
Func _EnableFirewall()

	If @OSArch = "X64" Then
		$fwMgr = ObjCreate("HNetCfg.FwPolicy2")
		$profile = $fwMgr.CurrentProfileTypes
			If $fwMgr.FirewallEnabled($profile) = False Then
				$fwMgr.FirewallEnabled($profile) = True
			Else
				MsgBox(0, "", "The Firewall is already disabled.")
			EndIf
	Else
		$fwMgr = ObjCreate("HNetCfg.FwMgr")
		$profile = $fwMgr.LocalPolicy.CurrentProfile
			If $profile.FirewallEnabled = False Then
				$profile.FirewallEnabled = True
			Else
				MsgBox(0, "", "The Firewall is already disabled.")
			EndIf
	EndIf

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ListAuthorizedApps
; Description ...: List properties of applications in the Exclusions List
; Syntax.........: _ListAuthorizedApps()
; Parameters ....: None
; Notes..........: Works on XP only.
; Example........: _ListAuthorizedApps()
; ===============================================================================================================================
Func _ListAuthorizedApps()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
	$aApps = $profile.AuthorizedApplications

	For $app in $aApps
		MsgBox(0, "", "Authorized application: " & $app.Name & @CRLF & @CRLF & _
			"Application enabled: " & $app.Enabled & @CRLF & @CRLF & _
			"Application IP version: " & $app.IPVersion & @CRLF & @CRLF & _
			"Application process image file name: " & $app.ProcessImageFileName & @CRLF & @CRLF & _
			"Application remote addresses: " & $app.RemoteAddresses & @CRLF & @CRLF & _
			"Application scope: " & $app.Scope & @CRLF)
	Next

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _ListFirewallProperties
; Description ...: List properties of the Windows Firewall
; Syntax.........: _ListFirewallProperties()
; Parameters ....: None
; Example........: _ListFirewallProperties()
; ===============================================================================================================================
Func _ListFirewallProperties()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile

	MsgBox(0, "", "Current profile type: " & $fwMgr.CurrentProfileType & @CRLF & @CRLF & _
			"Firewall enabled: " & $profile.FirewallEnabled & @CRLF & @CRLF & _
			"Exceptions not allowed: " & $profile.ExceptionsNotAllowed & @CRLF & @CRLF & _
			"Notifications disabled: " & $profile.NotificationsDisabled & @CRLF & @CRLF & _
			"Unicast responses to multicast broadcast disabled: " & $profile.UnicastResponsestoMulticastBroadcastDisabled)

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _EnableNotifications
; Description ...: Enables Notification when Windows Firewall blocks a program
; Syntax.........: _EnableNotifications()
; Parameters ....: None
; Example........: _EnableNotifications()
; ===============================================================================================================================
Func _EnableNotifications()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
		$profile.NotificationsDisabled = False

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _DisableNotifications
; Description ...: Disables Notification when Windows Firewall blocks a program
; Syntax.........: _DisableNotifications()
; Parameters ....: None
; Example........: _DisableNotifications()
; ===============================================================================================================================
Func _DisableNotifications()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$profile = $fwMgr.LocalPolicy.CurrentProfile
		$profile.NotificationsDisabled = True

EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _RestoreDefault
; Description ...: Restores the default Windows Firewall configuration.
; Syntax.........: _RestoreDefault()
; Parameters ....: None
; Example........: _RestoreDefault()
; ===============================================================================================================================
Func _RestoreDefault()

	$fwMgr = ObjCreate("HNetCfg.FwMgr")
	$fwMgr.RestoreDefaults()

EndFunc
