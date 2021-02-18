
#include <AD.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

Global $SUserID1, $SDNSDomain, $SHostServer, $SConfiguration, $SPassword, $SUserId, $aTEMP

; User is already a domain member
If @LogonDomain <> "" Then
	; Open Connection to the Active Directory
	_AD_Open()
	$SUserID1 = @UserName
	$SDNSDomain = $sAD_DNSDomain
	$SHostServer = $sAD_HostServer
	$SConfiguration = $sAD_Configuration
	_AD_Close()
EndIf

#region ### START Koda GUI section ### Form=
Global $Form1_1 = GUICreate("Active Directory Functions - Example 1", 515, 300, 250, 112)
GUICtrlCreateLabel("UserId", 8, 12, 39, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
GUICtrlCreateLabel("Windows Login Name:", 96, 12, 131, 21)
Global $IRadio1 = GUICtrlCreateRadio("", 72, 8, 17, 21)
Global $IUserId1 = GUICtrlCreateInput($SUserID1, 241, 8, 259, 21)
GUICtrlCreateLabel("Password", 8, 108, 200, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
Global $IPassword = GUICtrlCreateInput("", 241, 104, 259, 21, $ES_PASSWORD)
GUICtrlCreateLabel("DNSDomain", 8, 140, 200, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
Global $IDNSDomain = GUICtrlCreateInput($SDNSDomain, 241, 140, 259, 21)
GUICtrlCreateLabel("HostServer", 8, 172, 200, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
Global $IHostServer = GUICtrlCreateInput($SHostServer, 241, 172, 259, 21)
GUICtrlCreateLabel("Configuration", 8, 204, 200, 21)
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
Global $IConfiguration = GUICtrlCreateInput($SConfiguration, 241, 204, 259, 21)
Global $BOK = GUICtrlCreateButton("Logon", 8, 246, 130, 33)
Global $BCancel = GUICtrlCreateButton("Cancel", 428, 246, 73, 33)

GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	Global $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE, $BCancel
			Exit
		Case $BOK
			$SPassword = GUICtrlRead($IPassword)
			If $SPassword = "" Then
				MsgBox(16, "Active Directory Functions", "Password is missing!")
				GUICtrlSetState($IPassword, $GUI_FOCUS)
				ContinueCase
			EndIf
			$SDNSDomain = GUICtrlRead($IDNSDomain)
			$SHostServer = GUICtrlRead($IHostServer)
			$SConfiguration = GUICtrlRead($IConfiguration)
			If GUICtrlRead($IRadio1) = $GUI_CHECKED Then
				$SUserId = GUICtrlRead($IUserId1)
			EndIf




; Open Connection to the Active Directory
			If _AD_Open($SUserId, $SPassword, $SDNSDomain, $SHostServer, $SConfiguration) Then
				MsgBox(64, "Active Directory Functions", "Logon was succcessful!")
			ElseIf @error <= 8 Then
				MsgBox(16, "Active Directory Functions", "The logon was not succcessful!" & @CRLF & @CRLF & "@error: " & @error & ", @extended: " & @extended)
			Else
				MsgBox(16, "Active Directory Functions", "The logon was not succcessful!" & @CRLF & @CRLF & "@error: " & @error & ", @extended: " & @extended & _
					@CRLF & @CRLF & "Extended error information will be displayed")
				Global $aError = _AD_GetLastADSIError()
				_ArrayDisplay($aError)
			EndIf
			; Close Connection to the Active Directory
			_AD_Close()



Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.

$AT = TrayCreateMenu("Administrative Tools")
		$ADSS = TrayCreateItem("Active Directory Sites and Services", $AT)
		$ADUC = TrayCreateItem("Active Directory Users and Computers", $AT)
		$DHCP = TrayCreateItem("DHCP", $AT)
		$DNS = TrayCreateItem("DNS", $AT)
		$WSUS = TrayCreateItem("Windows Server Update Services", $AT)
TrayCreateItem("")
	$exit		= TrayCreateItem("Exit")

TraySetState(1)

While 1
$msg = TrayGetMsg()
	Select
		Case $msg = 0
			ContinueLoop
		Case $msg = $exit
			ExitLoop
	EndSelect

	Select
	case $msg = $ADSS
			ShellExecute ("dssite.msc", "", @SystemDir, "")
		EndSelect

	Select
	case $msg = $ADUC
		ShellExecute ("dsa.msc", "", @SystemDir, "")
	EndSelect

	Select
	case $msg = $DHCP
		ShellExecute ("dhcpmgmt.msc", "", @SystemDir, "")
	EndSelect

	Select
	case $msg = $DNS
		ShellExecute ("dnsmgmt.msc", "", @SystemDir, "")
	EndSelect

	Select
	case $msg = $WSUS
		ShellExecute ("Update Services\administrationsnapin\wsus.msc", "", @ProgramFilesDir, "")
	EndSelect

WEnd


EndSwitch
WEnd









