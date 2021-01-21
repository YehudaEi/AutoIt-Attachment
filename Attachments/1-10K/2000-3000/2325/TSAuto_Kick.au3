#include <GuiConstants.au3>

$GUI = GUICreate("Teamspeak Auto-Kick Tool", 300, 300, (@DesktopWidth - 300) / 2, (@DesktopHeight - 300) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

GUICtrlCreateLabel("Teamspeak Auto-Kick Tool", 80, 20, 130, 20)
$CtrlIPAddr = GUICtrlCreateInput("IP Address", 30, 60, 120, 20)
$CtrlPort = GUICtrlCreateInput("TCPQueryPort", 180, 60, 90, 20)
$CtrlAccount = GUICtrlCreateInput("Admin Account", 30, 90, 120, 20)
$CtrlPassword = GUICtrlCreateInput("Admin Password", 180, 90, 90, 20)
$CtrlUnregCli = GUICtrlCreateCheckbox("Unregistered clients", 60, 130, 120, 20)
$CtrlRegCli = GUICtrlCreateCheckbox("Registered Clients", 60, 150, 110, 20)
$CtrlUnRegChan = GUICtrlCreateCheckbox("Kick from Unregistered channels", 60, 170, 170, 20)
$CtrlRegChan = GUICtrlCreateCheckbox("Kick from Registered channels", 60, 190, 180, 20)
$CtrlReason = GUICtrlCreateInput("Reason", 60, 220, 180, 20)
$CtrlStart = GUICtrlCreateButton("Start Idle Kick", 90, 250, 100, 30)

GUISetState()


Dim $good = 0, $IPAddress, $Port, $Account, $Password
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $CtrlStart
			TCPStartup()
			#Region Check IP Address
			If GUICtrlRead($CtrlIPAddr) Not = "IP Address" Then
				$IPAddr = GUICtrlRead($CtrlIPAddr)
				If TCPNametoIP($IPAddr) Not = "" Then
					$IPAddr = TCPNametoIP($IPAddr)
					$good += 1
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Bad IP Address")
				EndIf
			Else
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No IP Address Entered")
			EndIf
			#endregion
			

			#Region Check Port Number
			If GUICtrlRead($CtrlPort) Not = "TCPQueryPort" Then
				$Port = GUICtrlRead($CtrlPort)
				If ($Port = IsInt(Number($Port))) AND (($Port >= 1) AND ($Port <= 65535)) Then
					$good += 2
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Bad Port Number")
				EndIf
			Else
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No Port Entered")
			EndIf
			#endregion

			#Region Check Account Name
			If GUICtrlRead($CtrlAccount) Not = "Admin Account" Then
				$Account = GUICtrlRead($CtrlAccount)
				If IsString($Account) Then
					$good += 4
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Error in verifying Account Name")
				EndIf
			Else
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No Admin Account Entered")
			EndIf
			#endregion

			#Region Check Account Password
			If GUICtrlRead($CtrlPassword) Not = "Admin Password" Then
				$Password = GUICtrlRead($CtrlPassword)
				If IsString($Password) Then
					$good += 8
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Error in verifying Account Password")
				EndIf
			Else
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No Admin Password Entered")
			EndIf
			#endregion
MsgBox(0, "test", $good)
MsgBox(0, "test", $IPAddress)
MsgBox(0, "test", $Port)
MsgBox(0, "test", $Account)
MsgBox(0, "test", $Password)
		EndSelect
	WEnd
	Exit