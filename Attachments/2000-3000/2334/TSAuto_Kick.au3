#include <GuiConstants.au3>
Func TSPrompt()
#Region Create GUI
Dim $GUI
Dim $CtrlIPAddr, $CtrlPort, $CtrlAccount, $CtrlPassword
Dim $CtrlUnregCli, $CtrlRegCli, $CtrlUnRegChan
Dim $CtrlReason, $CtrlMinutes, $CtrlMinutesUpDown
Dim $CtrlStart

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
$CtrlReason = GUICtrlCreateInput("Reason", 45, 220, 120, 20)
$CtrlMinutes = GUICtrlCreateInput(30, 185, 220, 40, 20, $ES_NUMBER)
$CtrlMinutesUpDown = GUICtrlCreateUpdown($CtrlMinutes)
GUICtrlSetLimit($CtrlMinutesUpDown, 120, 10)
GUICtrlCreateLabel("Minutes", 230, 223, 50, 20)
$CtrlStart = GUICtrlCreateButton("Start Idle Kick", 90, 250, 100, 30)
GUISetState()
#endregion

Dim $good, $IPAddr, $Port, $Account, $Password, $Minutes, $Kick, $Reason
While $good <> 15
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $CtrlStart
			TCPStartup()
			$good = 0
			$kick = 0
			#Region Check IP Address
            If StringInStr(StringUpper(GUICtrlRead($CtrlIPAddr)),"IP ADDRESS") Then
                MsgBox(0, "Teamspeak Auto-Kick Tool", "No IP Address Entered")
            Else
                $IPAddr = GUICtrlRead($CtrlIPAddr)
                If StringLen(TCPNametoIP($IPAddr)) > 0 Then
                    $IPAddr = TCPNametoIP($IPAddr)
                    $good += 1
                Else
                    MsgBox(0, "Teamspeak Auto-Kick Tool", "Bad IP Address")
                EndIf
            EndIf
			#endregion		
			#Region Check Port Number
			If StringInStr(StringUpper(GUICtrlRead($CtrlPort)), "TCPQUERYPORT") Then
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No Port Entered")
			Else
				$Port = Int(Number(GUICtrlRead($CtrlPort)))
				
				If IsInt($Port) AND ($Port >= 1) AND ($Port <= 65535) Then
					$good += 2
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Bad Port Number")
				EndIf
			EndIf
			#endregion

			#Region Check Account Name
			If StringInStr(StringUpper(GUICtrlRead($CtrlAccount)), "ADMIN ACCOUNT") Then
				MsgBox(0, "Teamspeak Auto-Kick Tool", "Error in verifying Account Name")
			Else
				$Account = GUICtrlRead($CtrlAccount)
				If IsString($Account) Then
					$good += 4
				Else
					
				EndIf
			EndIf
			#endregion

			#Region Check Account Password
			If StringInStr(StringUpper(GUICtrlRead($CtrlPassword)), "ADMIN PASSWORD") Then
				MsgBox(0, "Teamspeak Auto-Kick Tool", "No Admin Password Entered")
			Else
				$Password = GUICtrlRead($CtrlPassword)
				If IsString($Password) Then
					$good += 8
				Else
					MsgBox(0, "Teamspeak Auto-Kick Tool", "Error in verifying Account Password")
				EndIf
			EndIf
			#endregion
			#Region Check Kick Properties
			#Region Check Kick After X Minutes
			If (Int(Number(GUICtrlRead($CtrlMinutes))) > 120) OR (Int(Number(GUICtrlRead($CtrlMinutes))) < 10) Then
				MsgBox(0, "Teamspeak Auto-Kick Tool", "Invalid Number of Minutes")
				$Minutes = 0
			Else
				$Minutes = Int(Number(GUICtrlRead($CtrlMinutes)))
			EndIf
			#endregion
			#Region Check Who/Where to Kick
			If GUICtrlRead($CtrlUnregCli) = $GUI_CHECKED Then $Kick += 1
			If GUICtrlRead($CtrlRegCli) = $GUI_CHECKED Then $Kick += 2
			If GUICtrlRead($CtrlUnRegChan) = $GUI_CHECKED Then $Kick += 4
			If GUICtrlRead($CtrlRegChan) = $GUI_CHECKED Then $Kick += 8
			#endregion
			#Region Check Reason
			If StringInStr(StringUpper(GUICtrlRead($CtrlReason)), "REASON") Then
				$Reason = "You were kicked from the server for idling more than " & $Minutes & " Minutes."
			Else
				$Reason = GUICtrlRead($CtrlReason)
			EndIf
			#EndRegion
			#endregion
	EndSelect
WEnd
#Region Create Settings Array
Dim $Settings[7]
$Settings[0] = $IPAddr
$Settings[1] = $Port
$Settings[2] = $Account
$Settings[3] = $Password
$Settings[4] = $Minutes
$Settings[5] = $Kick
$Settings[6] = $Reason
#endregion
Return $Settings
EndFunc ;==>TSPrompt()

TSPrompt()