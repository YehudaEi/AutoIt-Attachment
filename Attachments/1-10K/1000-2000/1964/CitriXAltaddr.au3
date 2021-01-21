;~ INFO
;~ Altaddr for Citrix Metaframe XP by Bruno PELZER  -  bruno@e-pelzer.com

;~ DESCRIPTION
;~ This scrip uses altaddr to query and set the alternate (external) IP address for a MetaFrame XP server. 
;~ The alternate address is returned to ICA Clients that request it and is used to access a MetaFrame XP 
;~ server that is behind a firewall.
;~ This script gets external IP address with www.whatismyip.com and simulates altaddr /set YOUR_EXTERNAL_IP

;~ COMPATIBILITY
;~ Tested with Windows 2003 server SP1 and Citrix Metaframe XP 1.0 FR3

;~ HISTORY
;~ 1.0 : First public release
;~ 2.0 : Function to get IP robust ( check from wathismyip.com AND checkip.dyndns.org)

$Info = "Citrix AltAddr 2.0 - bruno@e-pelzer.com"
$PublicIP = new_GetIP()

If $PublicIP = "-1" Then
	TrayTip($Info, "No internet access ! ", 5, 3)
	Sleep(5000)
	Exit
EndIf

TrayTip($Info, "Updating your dynamic IP address..."&@CRLF&"IP address : "&$PublicIP, 5, 1)
Sleep(5000)
$val = RunWait(@ComSpec & " /c altaddr /set " & $PublicIP,@SystemDir ,@SW_HIDE)

If $val <> 0 Then
	TrayTip($Info, "Update Faild !" &@CRLF& "Error : "& $val, 5, 3)
	Sleep(5000)
	Exit
Else
	TrayTip($Info, "Update successfull"&@CRLF&"IP address : "&$PublicIP, 5, 1)
	Sleep(5000)
EndIf
Exit


Func new_GetIP()
    Local $ip, $t_ip

    If InetGet("http://www.whatismyip.com/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
        $ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
        FileDelete(@TempDir & "\~ip.tmp")
        $ip = StringTrimLeft($ip, StringInStr($ip, "Your ip is") + 10)
        $ip = StringLeft($ip, StringInStr($ip, " ") - 1)
        $ip = StringStripWS($ip, 8)
        $t_ip = StringSplit($ip, '.')
        If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
            Return $ip
        EndIf
    EndIf
    If InetGet("http://checkip.dyndns.org/?rnd1=" & Random(1, 65536) & "&rnd2=" & Random(1, 65536), @TempDir & "\~ip.tmp") Then
        $ip = FileRead(@TempDir & "\~ip.tmp", FileGetSize(@TempDir & "\~ip.tmp"))
        FileDelete(@TempDir & "\~ip.tmp")
        $ip = StringTrimLeft($ip, StringInStr($ip, ":") + 1)
        $ip = StringTrimRight($ip, StringLen($ip) - StringInStr($ip, "/") + 2)
        $t_ip = StringSplit($ip, '.')
        If $t_ip[0] = 4 And StringIsDigit($t_ip[1]) And StringIsDigit($t_ip[2]) And StringIsDigit($t_ip[3]) And StringIsDigit($t_ip[4]) Then
            Return $ip
        EndIf
    EndIf
	
    SetError(1)
    Return -1
EndFunc  ;==>_GetIP