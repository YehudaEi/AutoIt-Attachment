#RequireAdmin
#include <GUIConstants.au3>

Opt("GUICoordMode", 2)
Global $mb[4]
$hGUI = GUICreate("IP Tool", 180, 300)
$ipaddress = GUICtrlCreateButton("IP ADDRESS", 40, 15, 100, 30)
$IPrelease = GUICtrlCreateButton("IP Release", -100, 20, 100)
$IPrenew = GUICtrlCreateButton("IP Renew", -100, 20, 100)
$DNSflush = GUICtrlCreateButton("DNS Flush", -100, 20, 100)
$tcpip = GUICtrlCreateButton("TCP/IP", -100, 20, 100)
$serv = GUICtrlCreateButton("Check Services", -100, 20, 100)
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()
	Switch $msg
		Case $ipaddress
			IP()
		Case $IPrelease
			$mb[0] = MsgBox(4,"WARNING","You are about to release your IP. Do you want to continue?")
			If $mb[0] = 6 Then
			Release()
			EndIf
		Case $IPrenew
			$mb[1] = MsgBox(4,"WARNING","You are about to renew your IP. Do you want to continue?")
			If $mb[1] = 6 Then
			Renew()
			EndIf
		Case $DNSflush
			$mb[2] = MsgBox(4,"WARNING","You are about to delete your apr cache. Do you want to continue?")
			If $mb[2] = 6 Then
			Flush()
			EndIf
		Case $tcpip
			$mb[3] = MsgBox(4,"WARNING","You are about to reset your TCP/IP. Do you want to continue?")
			If $mb[3] = 6 Then
			TCPIP()
			EndIf
		Case $serv
			Services()
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd


Func IP()
	MsgBox(64, "IP Addresses", _IPDet())
EndFunc   ;==>IP

Func Release()
	$IP = _RunStdOutRead('ipconfig /release')
	$IP = StringRegExpReplace($IP, "(?i)(?s).*IP.*?(\d+\.\d+\.\d+\.\d+).* ", '\1')
	MsgBox(64, "IP Release", StringFormat("Your IP Address is: %s", $IP))
EndFunc   ;==>Release

Func Renew()
	$IP = _RunStdOutRead('ipconfig /renew')
	$IP = StringRegExpReplace($IP, "(?i)(?s).*IP.*?(\d+\.\d+\.\d+\.\d+).* ", '\1')
	MsgBox(64, "IP Renew", StringFormat("Your IP Address is: %s", $IP))
EndFunc   ;==>Renew

Func Flush()
	$IP = _RunStdOutRead('netsh int ip delete arpcache & ipconfig/flushdns')
	$IP = StringRegExpReplace($IP, "(?i)(?s).*IP.*?(\d+\.\d+\.\d+\.\d+).*", '\1')
	MsgBox(64, "DNS Flush", StringFormat("%s", $IP))
EndFunc   ;==>Flush

Func TCPIP()
	$IP = _RunStdOutRead('netsh int ip reset resetlog.txt & netsh winsock reset')
	$IP = StringRegExpReplace($IP, "(?i)(?s).*IP.*?(\d+\.\d+\.\d+\.\d+).* ", '\1')
	MsgBox(64, "Reset TCP/IP", StringFormat("%s", $IP))
EndFunc   ;==>TCPIP

Func Services()
	$File = @SystemDir & "\services.msc"
	Run(@SystemDir & "\mmc.exe " & $File)
EndFunc   ;==>Services


Func _IPDet()
	Local $totalReturn = ""
	Local $oWMIService = ObjGet("winmgmts:{impersonationLevel = impersonate}!\\" & "." & "\root\cimv2")
	Local $oColItems = $oWMIService.ExecQuery("Select * From Win32_NetworkAdapterConfiguration", "WQL", 0x30), $aReturn[6] = [5]
	If IsObj($oColItems) Then
		For $oObjectItem In $oColItems
			If IsString($oObjectItem.IPAddress(0)) Then
				If IsString($oObjectItem.Description) Then
					$aReturn[1] = "Description:" & @TAB & $oObjectItem.Description
				Else
					$aReturn[1] = "Description:" & @TAB & "Not Available"
				EndIf

				If IsString($oObjectItem.IPAddress(0)) Then
					$aReturn[2] = "IP Address:" & @TAB & $oObjectItem.IPAddress(0)
				Else
					$aReturn[2] = "IP Address:" & @TAB & "Not Available"
				EndIf

				If IsString($oObjectItem.DefaultIPGateway(0)) Then
					$aReturn[3] = "Default Gateway:" & @TAB & $oObjectItem.DefaultIPGateway(0)
				Else
					$aReturn[3] = "Default Gateway:" & @TAB & "Not Available"
				EndIf

				If IsArray($oObjectItem.DNSServerSearchOrder()) Then
					$aReturn[4] = "DNS Servers:" & @TAB & _WMIArrayToString($oObjectItem.DNSServerSearchOrder(), " - ")
				Else
					$aReturn[4] = "DNS Servers:" & @TAB & "Not Available"
				EndIf

				If IsString($oObjectItem.MACAddress) Then
					$aReturn[5] = "MAC: " & @TAB & @TAB & $oObjectItem.MACAddress
				Else
					$aReturn[5] = "MAC: " & @TAB & @TAB & "Not Available"
				EndIf

				$totalReturn &= $aReturn[1] & @CRLF & $aReturn[2] & @CRLF & $aReturn[3] & @CRLF & $aReturn[4] & @CRLF & $aReturn[5] & @CRLF & @CRLF
			EndIf
		Next
		Return StringTrimRight($totalReturn, 4)
	EndIf
	Return SetError(1, 0, $aReturn)
EndFunc   ;==>_IPDet

Func _RunStdOutRead($sRunCmd)
	Local $iPID = Run(@ComSpec & ' /c ' & $sRunCmd, @ScriptDir, @SW_HIDE, 4 + 2)
	Local $sStdOutRead = ""

	While ProcessExists($iPID)
		$sStdOutRead &= StdoutRead($iPID)
	WEnd

	Return $sStdOutRead
EndFunc   ;==>_RunStdOutRead

Func _WMIArrayToString($aArray, $sDelimeter = "|")
	If IsArray($aArray) = 0 Then
		Return SetError(1, 0, "")
	EndIf
	Local $iUbound = UBound($aArray) - 1, $sString
	For $A = 0 To $iUbound
		$sString &= $aArray[$A] & $sDelimeter
	Next
	Return StringTrimRight($sString, StringLen($sDelimeter))
EndFunc   ;==>_WMIArrayToString