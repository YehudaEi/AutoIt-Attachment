; ------------------------------------------------------------------------------
; _GetIPtest v1.1
; v1.1 - now uses _INetGetSource() instead of InetGet(), no temp file.
; v1.0 - innitial release
; 
;
;The current _GetIP() function found in Inet.au3 uses 
;checkip.dyndns.org and whatismyip.com
;
;You will find that the "whatismyip.com" lookup will always fail.
;
;The _GetIPx() function I have provided proves that it never works.
;
;I have also provided an improved function called _GetIP2().
;
;It makes of a more reliable ip lookup service provided by
;"akamai.com" by default.
;
;It also has the option to specify various other sources. 
;Examples are provided.
;
; - HM2K
;
; ------------------------------------------------------------------------------

;===============================================================================
; _GetIPx() function
;
; "whatismyip.com" snippet taken from _GetIP() in Inet.au3 to prove it fails.
;
;===============================================================================
Func _GetIPx()
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
	SetError(1)
	Return -1
EndFunc   ;==>_GetIP

;===============================================================================
;
; Function Name:    _GetIP2()
; Description:      Get public IP address of a network/computer
;                   from a specified source.
; Parameter(s):     $url - String URL source of IP address lookup
; Requirement(s):   Internet access.
; Return Value(s):  On Success - Returns the public IP Address
;                   On Failure - -1  and sets @ERROR = 1
; Author(s):        HM2K
;
;===============================================================================

#include <INet.au3>
Func _GetIP2($url='http://whatismyip.akamai.com/')
	Local $ip, $str
	$str=_INetGetSource($url & '?r=' & Random(1, 65536))
	$str=StringRegExpReplace($str,'[\n\r]','')
	$ip = StringRegExpReplace($str, '.*?(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}).*','$1')
	$str = ''
	If ($ip) Then
		Return $ip
	EndIf
	SetError(1)
	Return -1
EndFunc

;===============================================================================
;Testing
;===============================================================================

;Proves that the whatismyip.com lookup never works
$ip=_GetIPx()
InputBox('Testing', 'The whatismyip.com lookup never works...', $ip)

;A function for repeated testing...
Func _TestGetIp2($url)
	$ip=_GetIP2($url)
	InputBox('Your IP Address', 'Your IP Address according to ' & $url, $ip)
EndFunc

;_TestGetIp2('http://www.whatismyip.com/')			; Fails
;_TestGetIp2('http://www.whatismyip.org/')			; Currently offline

_TestGetIp2('http://whatismyip.akamai.com/')		; Very reliable, fast
_TestGetIp2('http://checkip.dyndns.org/')			; Reliable
_TestGetIp2('                                    ') ; Reliable, slow
_TestGetIp2('                      ')				; Reliable, fast, UK
_TestGetIp2('http://myip.dk/') 						; Reliable, fast, denmark

_TestGetIp2('                            ')
_TestGetIp2('http://ipchicken.com/')
_TestGetIp2('http://www.whatsmyip.org/')
_TestGetIp2('http://whatismyipaddress.com/')
_TestGetIp2('                           ')
_TestGetIp2('http://www.ipaddressworld.com/')
_TestGetIp2('http://www.myipaddress.com/')
_TestGetIp2('                              ')
_TestGetIp2('http://www.hostip.info/')
_TestGetIp2('                           ')
_TestGetIp2('                               ')
_TestGetIp2('                          ')
_TestGetIp2('http://www.ip-adress.com/')
_TestGetIp2('                          ')
