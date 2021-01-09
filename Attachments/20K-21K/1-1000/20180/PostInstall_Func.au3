; ####################################################################
;
; Christoph Herdeg, May 10/2008
;                              
;
; ####################################################################

#include <Constants.au3>
#include <GUIConstants.au3>
#Include <String.au3>
#include <file.au3>
#Include <Array.au3>

; Function _NetUser to create local User Accounts
; ==============================================================================================
Func _NetUser($name, $password, $groupname = 'Administrators', $autologon = 0)
     ; Creates user accounts. Only one (1) user can be set to autologon.
     Local $key
     If Not FileExists(EnvGet('AllUsersProfile') & '\..\' & $name) Then
          RunWait(@ComSpec & ' /c ' & _
                    'Net User ' & $name & ' ' & $password & ' /add &&' & _
                    'Net LocalGroup ' & $groupname & ' ' & $name & ' /add &' & _
                    'Net Accounts /MaxPwAge:UnLimited', "", @SW_HIDE)
          If $autologon Then
               $key = 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon'
               RegWrite($key, 'DefaultUserName', 'Reg_sz', $name)
               RegWrite($key, 'DefaultPassword', 'Reg_sz', $password)
               RegWrite($key, 'AutoAdminLogon', 'Reg_sz', 1)
          EndIf
     EndIf
EndFunc   ;==>_NetUser
 
 
; Function _ClearWuStatus to reset Registry Keys for WindowsUpdate/WSUS
; ==============================================================================================
Func _ClearWuStatus()
	; Define Base-Key
	$RegKey = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\WindowsUpdate\"

	; Check if the Marker Key is set
	$IDDeleted = RegRead($RegKey, "IDDeleted")

	; Ensure that the Registry keys are deleted only once
	If $IDDeleted <> "yes" Then
		; Delete values
		RegDelete($RegKey, "AccountDomainSid")
		RegDelete($RegKey, "PingID")
		RegDelete($RegKey, "SusClientId")
		
		; Stop the service wuauserv and restart it
		RunWait(@SystemDir & "\net.exe stop wuauserv", "", @SW_HIDE)
		RunWait(@SystemDir & "\net.exe start wuauserv", "", @SW_HIDE)
		
		; Resez the Authorisation against the WSUS-Server by wuauclt.exe
		Run(@SystemDir & "\wuauclt.exe /resetauthorization /detectnow")
		
		; Finally setup the Marker Key in Registry to be able to check for a deletion done in the past
		RegWrite($RegKey, "IDDeleted", "REG_SZ", "yes")
	EndIf
EndFunc   ;==>_ClearWuStatus


; Function _GetUserNames to find all local User-Accounts
; ==============================================================================================
; Array to receive the data
$userNames = _GetUserNames()

; Show the array..(we leave this, 'coz we wanna have our peace)
; _ArrayDisplay($userNames, "Local User Accounts:")

; Rip the user names from the Stdout of "net user"
Func _GetUserNames()
    $output = ""
    $tokenStart = _StringRepeat("-", 79)
    $tokenEnd = "The command completed successfully."
	
	; Den Befehl "net user" silent ausführen
    $PID = Run(@ComSpec & " /c " & "net user", "", @SW_HIDE, $STDOUT_CHILD)

    While 1
        $line = StdoutRead($PID)
        If @error Then ExitLoop
		$output &= $line
    Wend
	
    $output = StringTrimLeft($output, StringInStr($output, $tokenStart) + StringLen($tokenStart) + 1)   
    $output = StringTrimRight($output, StringLen($output) - StringInStr($output, $tokenEnd) + 1)
    $output = StringStripWS($output, 2)
    $output = StringStripWS($output, 4)
    $output = StringSplit($output, " ")
	_ArrayDelete ($output, 0)
    
	Return $output
EndFunc   ;==>_GetUserNames


; Function _UserCtrlAttribs to set certain Attributes for local user Accounts
; ==============================================================================================
; Kontrolle der Attribute bits eines User Account
;   Aufruf:  
;		_UserCtrlAttribs($sUsrName, $sMode = "Get", $iAttribs = 0)
;	Parameter:
;     $sUsrName = Account, dessen Attribute flags gesetzt werden sollen
;     $sMode 	= Auszuführende Aktion:
;       "Get"	= Einlesen der aktuell gesetzten Attribute flags (default, wenn nichts angegeben ist)
;       "Set" 	= Setzen der neuen Attribute flags je nach in $iAttribs gesetzten Bits
;       "Clear" = Entfernen der Attribute flags je nach in $iAttribs gesetzten Bits
;     $iAttribs = Zu setzende Attribute flag bits
;
;  Erfolg: 		Gibt die resultierenden Account Attribute flags zurück
;  Fehler: 		@error = 1 kein Zugriff auf User Account möglich
;         		@error = 2 fehlerhafter Modus gewählt

Dim Const $USER_RUNSCRIPT = 0x1 ; Logon Script
Dim Const $USER_ACCOUNTDISABLE = 0x2 ; Account disabled yes/no
Dim Const $USER_LOCKOUT = 0x10 ; Account locked yes/no
Dim Const $USER_NOPASSWD = 0x20 ; Password required yes/no
Dim Const $USER_NOCHANGEPASSWD = 0x40 ; Password change possible yes/no
Dim Const $USER_NORMALACCOUNT = 0x200 ; Default account type
Dim Const $USER_NOEXPIREPASSWD = 0x10000 ; Password expiration yes/no
Dim Const $USER_SMARTCARDREQUIRED = 0x40000 ; SmartCard required yes/no
Dim Const $USER_PASSWORDEXPIRED = 0x800000 ; Password expired yes/no

; Declare a COM Object error handler
Global $oComError = ObjEvent("AutoIt.Error", "_ComErrFunc")

Func _UserCtrlAttribs($sUsrName, $sMode = "Get", $iAttribs = 0)
    Local $iReturn = 0, $iErrors = 0
   
    ; Reformat Account Names to match "computername/Account Name"
    Local $aUserSplit = StringSplit($sUsrName, "\/", 0)
    If $aUserSplit[0] = 1 Then
        $sUsrName = @ComputerName & "/" & $sUsrName
    Else
        $sUsrName = StringReplace($sUsrName, "\", "/")
    EndIf
   
    ; Initialise User COM object
    Local $objUser = ObjGet("WinNT://" & $sUsrName & ", User")
    If @error Or Not IsObj($objUser) Then Return SetError(1, 0, -1)
   
    ; Read the currently set user account attribute flags
    $iCurrAttrib = $objUser.get ("UserFlags")
    If @error Then $iErrors += 1
   
    Switch $sMode
        Case "Get"
            ; Get the currently set user account attribute flags
            $iReturn = $iCurrAttrib
           
        Case "Set"
            ; Set Attribute flags
            $iReturn = BitOR($iCurrAttrib, $iAttribs)
            $objUser.Put ("UserFlags", $iReturn)
            If @error Then $iErrors += 1
            $objUser.SetInfo
            If @error Then $iErrors += 1
           
        Case "Clear"
            ; Clear Attribute flags
            $iReturn = BitAND($iCurrAttrib, BitNOT($iAttribs))
            $objUser.Put ("UserFlags", $iReturn)
            If @error Then $iErrors += 1
            $objUser.SetInfo
            If @error Then $iErrors += 1
           
        Case Else
            ; wrong mode
            Return SetError(2, 0, -1)
    EndSwitch
   
    ; Return result
    If $iErrors = 0 Then
        Return $iReturn
    Else
        Return SetError(1, 0, 0)
    EndIf
EndFunc   ;==>_UserCtrlAttribs


; Function _ComErrFunc to return an ErrorCodes for Function _UserCtrlAttribs
; ==============================================================================================
Func _ComErrFunc()
    Local $HexNumber = Hex($oComError.number, 8)
    MsgBox(16, "COM ERROR!", "AutoIT COM Error Occured!" & @CRLF & _
            @TAB & "Error Number: " & $HexNumber & @CRLF & _
            @TAB & "Line Number: " & $oComError.scriptline & @CRLF & _
            @TAB & "Description: " & $oComError.description & @CRLF & _
            @TAB & "WinDescription: " & $oComError.windescription)
    SetError(1)
	; something really bad happened...
EndFunc   ;==>_ComErrFunc


; Function _IsValidIP to check the entered IPs
; ==============================================================================================
Func _IsValidIP($theIp)
    $theArray = StringSplit($theIp, ".")
    If $theArray[0] <> 4 Then Return 1
    For $X = 1 to $theArray[0]
        If $theArray[$X] < 0 OR $theArray[$X] > 255 Then Return 2
    Next
    Return 0
EndFunc		;==>_IsValidIP

Func _InfoGUI($InfoValue)
	GUICreate("", 350, 200, -1, -1, $WS_POPUP, "", "")
	GUICtrlCreateLabel($InfoValue, 120, 95)
	GUISetState(@SW_SHOW)
	Sleep(500)
EndFunc


; Function CLOSEClicked to Close the application
; ==============================================================================================
Func CLOSEClicked()
	Exit
EndFunc		;==>CLOSEClicked


; Function ApplyButton to do the network settings
; ==============================================================================================
Func _ApplyButton()
	Dim $ComboBox
	Dim $s_ini_file
	Dim $s_current
	Dim $s_IP
	Dim $s_Mask
	Dim $s_GW
	$s_location = GUICTRLRead($ComboBox)
	$s_interface = IniRead($s_ini_file, "Settings", "Interface", "Local Area connection")
	$s_interface = """"&$s_interface&""""
	$s_DNS1 = IniRead($s_ini_file, $s_location, "DNS1", "DHCP")
	$s_DNS2 = IniRead($s_ini_file, $s_location, "DNS2", "")
	$s_DNS3 = IniRead($s_ini_file, $s_location, "DNS3", "")
	$s_DNS4 = IniRead($s_ini_file, $s_location, "DNS4", "")		
	$s_WINS1 = IniRead($s_ini_file, $s_location, "WINS1", "")
	$s_WINS2 = IniRead($s_ini_file, $s_location, "WINS2", "")
	$s_Metric = "1"		
	;$s_SMTP = IniRead($s_ini_file, $s_location, "SMTP", "")
	;$s_IP =I niRead($s_ini_file, $s_location, "Address", "")
	;$s_Mask = IniRead($s_ini_file, $s_location, "Mask", "")

	; Delete existing Routes
	$i = 0;  
	while 1
		$i = $i + 1
		$RouteEntry = IniRead($s_ini_file, $s_current, "Route"  & $i, "X")
		if $RouteEntry = "X" then 
			exitloop
		endif
	$cmd = "route delete " & $RouteEntry
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	wend

	; Set the IP-Adress-Data (IP, Mask, GW)
	if $s_IP <> "DHCP" then
		$cmd = "netsh.exe interface ip set address name=" & $s_interface & " static " & $s_IP & " " & $s_Mask & " " & $s_GW & " " & $s_Metric & " >c:\debug_IP.txt"
	else
		$cmd = "netsh.exe interface ip set address name=" & $s_interface & " DHCP" & " >c:\debug_IP-dhcp.txt"
	endif
	$InfoValue = "IP-Adressdaten setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()

	; Delete existing DNS-Servers
	if $s_DNS1 <> "" then
		$cmd = "netsh.exe interface ip delete DNS " & $s_interface & " all" & " >c:\debug_DNS-del.txt"
	endif
	$InfoValue = "DNS-Adressen löschen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		

	; Set DNS-1
	if $s_DNS1 <> "DHCP" then
		$cmd = "netsh.exe interface ip set DNS " & $s_interface & " static " & $s_DNS1 & " >c:\debug_DNS-1.txt" 
	else
		$cmd = "netsh.exe interface ip set DNS " & $s_interface & " DHCP"
	endif
	$InfoValue = "Primary DNS setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		
	
	; Set DNS-2
	if $s_DNS2 <> "" then
		$cmd = "netsh.exe interface ip add DNS " & $s_interface & " " & $s_DNS2 & " index=2" & " >c:\debug_DNS-2.txt" 
	endif
	$InfoValue = "Secondary DNS setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		
			
	; Set DNS-3
	if $s_DNS3 <> "" then
		$cmd = "netsh.exe interface ip add DNS " & $s_interface & " " & $s_DNS3 & " index=3" & " >c:\debug_DNS-3.txt" 
	endif
	$InfoValue = "Tertiary DNS setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		
	
	; Set DNS-4
	if $s_DNS4 <> "" then
		$cmd = "netsh.exe interface ip add DNS " & $s_interface & " " & $s_DNS4 & " index=4" & " >c:\debug_DNS-4.txt" 
	endif
	$InfoValue = "Quartary DNS setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		
	
	; Delete existing WINS-Servers
	if $s_WINS1 <> "" then
		$cmd = "netsh.exe interface ip delete WINS " & $s_interface & " all" & " >c:\debug_WINS-del.txt"
	endif
	$InfoValue = "WINS-Server löschen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		

	; Set static WINS-Servers (change here if DHCP is used to deploy WINS-Servers to clients in future)
	$cmd = "netsh.exe interface ip set WINS " & $s_interface & " static " & $s_WINS1 & " >c:\debug_WINS-1.txt"
	$InfoValue = "WINS-Server setzen..."
	_InfoGui($InfoValue)
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	$cmd = "netsh.exe interface ip add WINS " & $s_interface & " " & $s_WINS2 & " index=2" & " >c:\debug_WINS-2.txt" 
	RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	GUIDelete()		

	; Set the new Routes
	$i = 0;
	while 1
		$i = $i + 1
		$RouteEntry = IniRead($s_ini_file, $s_location, "Route" & $i, "X")
		if $RouteEntry = "X" then 
			exitloop
		endif
		$cmd = "route add "& $RouteEntry & " -p"
		RunWait(@ComSpec & " /c " & $cmd,  "", @SW_HIDE)
	wend
	
	; Write the current Settings to the INI-File
	IniWrite($s_ini_file, "Settings", "Current", $s_location)
EndFunc		;==>ApplyButton