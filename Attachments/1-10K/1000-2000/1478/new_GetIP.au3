;===============================================================================
;
; Function Name:        new_GetIP()
; Description:          Get public IP address of a network/computer.
; Parameter(s):         None
; Requirement(s):       Internet access.
; Return Value(s):      On Success - Returns the public IP Address
;                       On Failure - -1  and sets @ERROR = 1
; Proxy Revision by:    warmfuzzy
; Original Author(s):   Larry/Ezzetabi & Jarvis Stubblefield 
; Comments:             Reduces likelihood of Proxy Caching problems
;===============================================================================

; Demo bit
local $PublicIP = new_GetIP()
MsgBox(0, "IP Address", "Your IP Address is: " & $PublicIP)
Exit

; Function replacing _GetIP() in Include\Inet.au3 via #include <Inet.au3>
Func new_GetIP()
	Local $ip
	If InetGet("http://www.whatismyip.com/?rnd1=" & Random (1,65536) & "&rnd2=" & Random (1,65536), @TempDir & "\~ip.tmp") Then
		$ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
		FileDelete(@TempDir & "\~ip.tmp")
		$ip = StringTrimLeft($ip, StringInStr($ip, "<TITLE>Your ip is ") + 17)
		$ip = StringLeft($ip, StringInStr($ip, " WhatIsMyIP.com</TITLE>") - 1)      
		Return $ip
	Else
		SetError(1)
		Return -1
	EndIf
EndFunc ;Function End >> new_GetIP()
