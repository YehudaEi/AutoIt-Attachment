;Fill in this section
;-----------------------------------
$script = @ScriptFullPath ;Script location - needed for script to be put back in startup (to change the computer name)

$logonusername = "Administrator" ;logon credentials for reboot
$logonpassword = "password" 
$logondomain = @ComputerName 

$domjoinuser = "domain\user" ;user with permissions to join domain
$domjoinpass = "Password"
$domjoindomain = "Domain"

$domtojoin = "Domain.local"
$OU = "OU"
;-----------------------------------

$strComputer = "localhost"
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_SystemEnclosure", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) then
   For $objItem In $colItems
      $newname = "D" & $objItem.SerialNumber
   Next
Else
   Msgbox(0,"WMI Output","No WMI Objects Found for class: " & "Win32_SystemEnclosure" )
   Exit
Endif

If @ComputerName <> $newname Then
	MsgBox(0, "", "")
	Exit
	;_ChangeComputerName($newname, $logonusername, $logonpassword, $logondomain, $script)
Else
	_JoinToDomain($domjoindomain, $domjoinuser, $domjoinpass, $strComputer, $strComputerDomain, $strOU)
EndIf

Exit

;<---  Functions from Prepsys v0.94 - By Andrew Calcutt --->
Func _ChangeComputerName($newcomputername, $logonuser = "", $logonpass = "", $domain = "", $startprogram = "")
	GUICtrlSetData($current_action, "Changing Computer Name")
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ActiveComputerName", "ComputerName", "REG_SZ", $newcomputername)
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Control\ComputerName\ComputerName\", "ComputerName", "REG_SZ", $newcomputername)
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "ComputerName", "REG_SZ", $newcomputername)
	RegWrite("HKLM\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters", "NV Hostname", "REG_SZ", $newcomputername)
	_Shutdown("REBOOT", "ADD", $logonuser, $logonpass, $domain, $startprogram)
EndFunc   ;==>_ChangeComputerName

Func _JoinToDomain($strUserDomain, $strUser, $strPassword, $strComputer, $strComputerDomain, $strOU);joins compuer to domain
	;GUI
	GUICtrlSetData($current_action, "Joining to Domain")
	GUICreate("Joining Computer To Domain", 392, 323, -1, -1, BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
	GUICtrlCreateLabel("Machine Name:", 10, 10, 80, 20)
	$machine_nameJD = GUICtrlCreateInput($strComputer, 100, 10, 280, 20)
	GUICtrlCreateLabel("Join Domain:", 10, 40, 90, 20)
	$jointodomain = GUICtrlCreateInput($strComputerDomain, 100, 40, 280, 20)
	GUICtrlCreateLabel("OU:", 10, 70, 90, 20)
	$JoinToOU = GUICtrlCreateInput($strOU, 100, 70, 280, 20)
	GUICtrlCreateLabel("Username:", 10, 100, 90, 20)
	$usernameJD = GUICtrlCreateInput($strUser, 100, 100, 280, 20)
	GUICtrlCreateLabel("Password:", 10, 130, 90, 20)
	$passwordJD = GUICtrlCreateInput($strPassword, 100, 130, 280, 20, $ES_PASSWORD)
	GUICtrlCreateLabel("Domain", 10, 170, 80, 20)
	$domainJD = GUICtrlCreateInput($strUserDomain, 100, 170, 280, 20)
	$join_edit = GUICtrlCreateEdit("", 10, 230, 370, 170)
	GUISetState()
	
	;Join Domain Script
	Const $JOIN_DOMAIN = 1
	Const $ACCT_CREATE = 2
	Const $ACCT_DELETE = 4
	Const $WIN9X_UPGRADE = 16
	Const $DOMAIN_JOIN_IF_JOINED = 32
	Const $JOIN_UNSECURE = 64
	Const $MACHINE_PASSWORD_PASSED = 128
	Const $DEFERRED_SPN_SET = 256
	Const $INSTALL_INVOCATION = 262144
	
	Dim $strDomainUser
	Dim $strFailString
	Dim $strSucceedString
	
	GUICtrlSetData($join_edit, "Joining Domain")
	$strDomainUser = $strUserDomain & "\" & $strUser
	
	$objNetwork = ObjCreate("WScript.Network")
	$objComputer = ObjGet("winmgmts:{impersonationLevel=Impersonate}!\\" & _
			$strComputer & "\root\cimv2:Win32_ComputerSystem.Name='" & _
			$strComputer & "'")
	$ReturnValue = $objComputer.JoinDomainOrWorkGroup ($strComputerDomain, _
			$strPassword, _
			$strDomainUser, _
			$strOU, _
			$JOIN_DOMAIN + $ACCT_CREATE)
	
	If ($ReturnValue <> 0) Then
		;get the net helpmsg from the error code returned
		Dim $strHelpMsg, $command
		$command = "net helpmsg " & $ReturnValue
		
		$objShell = ObjCreate("WScript.Shell")
		$objScriptExec = $objShell.Exec ($command)
		
		; store the error message into strHelpMsg
		$strHelpMsg = $objScriptExec.StdOut.ReadAll ()
		$strFailString = "Join Failed" & @CRLF & _
				"Computer: " & $strComputer & @CRLF & _
				"Domain: " & $strComputerDomain & @CRLF & _
				"User Name: " & $strDomainUser & @CRLF & _
				"Error Message: " & $strHelpMsg
		GUICtrlSetData($join_edit, $strFailString)
		$join_button = GUICtrlCreateButton("Join Domain", 10, 200, 110, 20)
		$skip_button = GUICtrlCreateButton("Skip Joining Domain", 130, 200, 110, 20)
		GUISetState()
		While 1
			$msg = GUIGetMsg()
			Select
				Case $msg = $GUI_EVENT_CLOSE Or $msg = $skip_button
					GUIDelete("Joining Computer To Domain")
					ExitLoop
				Case $msg = $join_button
					$domainJD = GUICtrlRead($domainJD)
					$usernameJD = GUICtrlRead($usernameJD)
					$passwordJD = GUICtrlRead($passwordJD)
					$machine_nameJD = GUICtrlRead($machine_nameJD)
					$jointodomain = GUICtrlRead($jointodomain)
					$JoinToOU = GUICtrlRead($JoinToOU)
					GUIDelete("Joining Computer To Domain")
					_JoinToDomain($domainJD, $usernameJD, $passwordJD, $machine_nameJD, $jointodomain, $JoinToOU)
					ExitLoop
				Case Else
					;;;
			EndSelect
		WEnd
		Return 0
	Else
		$strSucceedString = "Join Succeeded" & @CRLF & _
				"Computer: " & $strComputer & @CRLF & _
				"Domain: " & $strComputerDomain & @CRLF & _
				"User Name: " & $strDomainUser
		;_RecordData($strComputer, $strUser, $strUserDomain, $strOU)
		GUICtrlSetData($join_edit, $strSucceedString)
		Sleep(5000)
		GUIDelete("Joining Computer To Domain")
		Return 1
	EndIf
EndFunc   ;==>_JoinToDomain

;<---  End Functions from Prepsys v0.94 - By Andrew Calcutt --->
