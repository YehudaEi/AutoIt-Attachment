;-- WHOIS -----------------------------------------------------------------------------------------
;
;-- Autor: Eusebio P�rez Hurtado
;-- Fecha: 03-11-2006
;
;--------------------------------------------------------------------------------------------------
#include-once
#include <Array.au3>
#include <Crypt.au3>
#include <file.au3>

Func _WhoIs($cDomain_req)
	Local $cTLD = ""
	Local $cServerDomain = ""
	Local $cServerIp = ""
	Local $cRedirectTo = ""
	Local $nPort
	Local $cParameters = ""
	Local $result = ""
	Local $nn
	TCPStartup()
	$cDomain_req = StringLower($cDomain_req)
	$cDomain_req = StringReplace($cDomain_req, "http:", "")
	$cDomain_req = StringReplace($cDomain_req, "/", "")
	$cDomain_req = StringReplace($cDomain_req, "www.", "")
	$ret_val = _getTLD($cDomain_req)
	$ret_val = StringSplit($ret_val, '|-|', 1)
	$cTLD = $ret_val[3]
	$cDomain = $ret_val[2]
	$act_domain = $ret_val[1]
	$sec_arr = IniReadSectionNames("WhoIs.INI")
	$ar_ret = _ArraySearch($sec_arr, $cTLD)
	If $ar_ret == -1 Then
		$cTLD = _getTLDDet($cTLD)
	EndIf
	If $cTLD == '' Then
		$result = "Domain Registrar's whois server not found " & $cTLD
		TCPShutdown()
		Return ($result)
	EndIf
	$cServerDomain = IniRead("WhoIs.INI", $cTLD, "ServerDomain", "")
	$cServerIp = IniRead("WhoIs.INI", $cTLD, "ServerIp", "")
	$cRedirectTo = IniRead("WhoIs.INI", $cTLD, "RedirectTo", "")
	$nPort = IniRead("WhoIs.INI", $cTLD, "Port", "43")
	$cParameters = IniRead("WhoIs.INI", $cTLD, "Parameters", "")

	If $cServerDomain = "" Then
		$result = "server not defined in WhoIS.ini"
		Return $result
	Else
		If $cServerIp = "" Then
			$cServerIp = TCPNameToIP($cServerDomain)
			IniWrite("WhoIs.INI", $cTLD, "ServerIp", $cServerIp)
		EndIf
		If $cServerIp = "" Then
			$result = "error retrieving whois server IP"
			Return $result
		Else
			$result = _ConectaServerWhoIs($cServerIp, $nPort, $cDomain, $cParameters, 1)
		EndIf
	EndIf
	If $cRedirectTo <> "" Then
		$nn = StringInStr($result, $cRedirectTo)
		If $nn > 0 Then
			$cServerDomain = StringMid($result, $nn + StringLen($cRedirectTo))
			$cServerDomain = StringMid($cServerDomain, 1, StringInStr($cServerDomain, @CRLF) - 1)
			$cServerDomain = StringStripWS($cServerDomain, 1)
			$cServerDomain = StringStripWS($cServerDomain, 2)
			$cServerIp = IniRead("WhoIs.INI", "Redirect", $cServerDomain, "")
			If $cServerIp = "" Then
				$cServerIp = TCPNameToIP($cServerDomain)
				IniWrite("WhoIs.INI", "Redirect", $cServerDomain, $cServerIp)
			EndIf
			$result = _ConectaServerWhoIs($cServerIp, $nPort, $cDomain, $cParameters, 2)
		EndIf
	EndIf

	$result = _StripUnwanted($result, $cDomain)
	If StringInStr($result, ':', 0, 2) == 0 Then
		$compare = StringCompare($cDomain_req, $cDomain)
		If $compare > 0 Then ; $cDomain_req can never be smaller than $cDomain as $cDomain is a derived entity
			$result = _ConectaServerWhoIs($cServerIp, $nPort, $cDomain_req, $cParameters, 2)
			$result = _StripUnwanted($result, $cDomain)
			If StringInStr($result, ':', 0, 1) <> 0 Then
				_Crypt_Startup()
				$dom_arr = StringSplit($cDomain, '.')
				IniWrite('sTLD.ini', $dom_arr[$dom_arr[0]], $cDomain, '*')
				$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
				IniWrite('hash.ini', 'md5', 'sTLD.ini', $hash)
				_Crypt_Shutdown()
			Else
				Return 'Domain Registrant not found'
			EndIf
		ElseIf $compare == 0 And StringInStr($act_domain, '.', 0, 1) <> 0 Then ;StringInStr($cDomain_req, '.', 0, 1) <> 0

			If StringInStr($result, 'found') > 0 Or StringInStr($result, 'match') > 0 Or StringInStr($result, 'invalid') Then
				If StringInStr($cDomain, 'found', 2) == 0 And StringInStr($cDomain, 'match', 2) == 0 And StringInStr($cDomain, 'invalid', 2) == 0 Then
					If StringInStr($act_domain, '.', 2) <> 0 Then
						$dom_arr = StringReplace($cDomain, $act_domain, '')
						$dom_arr = StringSplit($dom_arr, '.')
						If $dom_arr[0] > 1 Then
							$cDomain = $dom_arr[$dom_arr[0]] & $act_domain
							$result = _WhoIs($cDomain)
							_Crypt_Startup()
							$dom_arr = StringSplit($cDomain, '.')
							IniWrite('sTLD.ini', $dom_arr[$dom_arr[0]], $cDomain, '!')
							$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
							IniWrite('hash.ini', 'md5', 'sTLD.ini', $hash)
							_Crypt_Shutdown()
						EndIf

					EndIf
					Return $result; & '|-|' & $cServerDomain
				EndIf
			Else
				Return $result; & '|-|' & $cServerDomain
			EndIf
		ElseIf $compare == 0 And StringInStr($act_domain, '.', 1) == 0 Then
			If StringInStr($result, 'found') > 0 Or StringInStr($result, 'match') > 0 Or StringInStr($result, 'invalid') Then
				If StringInStr($cDomain, 'found', 2) == 0 And StringInStr($cDomain, 'match', 2) == 0 And StringInStr($cDomain, 'invalid', 2) == 0 Then
					If StringInStr($act_domain, '.', 2) <> 0 Then
						$dom_arr = StringReplace($cDomain, $act_domain, '')
						$dom_arr = StringSplit($dom_arr, '.')
						If $dom_arr[0] > 1 Then
							$cDomain = $dom_arr[$dom_arr[0]] & $act_domain
							$result = _WhoIs($cDomain)
							_Crypt_Startup()
							$dom_arr = StringSplit($cDomain, '.')
							IniWrite('sTLD.ini', $dom_arr[$dom_arr[0]], $cDomain, '!')
							$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
							IniWrite('hash.ini', 'md5', 'sTLD.ini', $hash)
							_Crypt_Shutdown()
						EndIf
					EndIf
					Return $result; & '|-|' & $cServerDomain
				EndIf
			Else
				Return $result; & '|-|' & $cServerDomain
			EndIf
;~ 			Return 'Domain does not exist'
		EndIf
	Else
		If StringInStr($result, 'found') > 0 Or StringInStr($result, 'match') > 0 Or StringInStr($result, 'invalid') > 0 Then
			If StringInStr($cDomain, 'found', 2) == 0 And StringInStr($cDomain, 'match', 2) == 0 And StringInStr($cDomain, 'invalid', 2) == 0 Then
				If StringInStr($act_domain, '.', 2) <> 0 Then
					$dom_arr = StringReplace($cDomain, '.' & $act_domain, '')
					$dom_arr = StringSplit($dom_arr, '.')
					If $dom_arr[0] > 1 Then
						$cDomain = $dom_arr[$dom_arr[0]] & $act_domain
					Else
						$cDomain = $act_domain
					EndIf
					$result = _WhoIs($cDomain)
					_Crypt_Startup()
					$dom_arr = StringSplit($cDomain, '.')
					IniWrite('sTLD.ini', $dom_arr[$dom_arr[0]], $cDomain, '!')
					$hash = _Crypt_HashFile('sTLD.ini', $CALG_MD5)
					IniWrite('hash.ini', 'md5', 'sTLD.ini', $hash)
					_Crypt_Shutdown()
				EndIf
				Return $result; & '|-|' & $cServerDomain
			EndIf
		Else
			Return $result; & '|-|' & $cServerDomain
		EndIf
	EndIf
	TCPShutdown()
	Return ($result) & '|-|' & $cServerDomain
EndFunc   ;==>_WhoIs

Func _ConectaServerWhoIs($cServerIp, $nPort, $cDomain, $cParameters, $type)
	Local $socket
	Local $recv
	Local $result = ""
		$socket = TCPConnect($cServerIp, $nPort)
		If $socket == -1 Or $socket == 0 Then
			Return ''
		EndIf
	If $type == 2 Then $cParameters = ''
	If $cParameters <> "" Then
		TCPSend($socket, $cParameters & " " & $cDomain & @CRLF)
	Else
		TCPSend($socket, $cDomain & @CRLF)
	EndIf
	$i=1
	While $i <= 200
		$recv = TCPRecv($socket, 2048)
		If @error Then ExitLoop
		If $recv <> "" Then
			$result = $result & $recv
		EndIf
		Sleep(10)
		$i+=1
	WEnd
	$result = StringReplace($result, @LF, @CRLF)
	Return ($result)
EndFunc   ;==>_ConectaServerWhoIs

Func _getTLD($cDomain)
	Local $nn
	Local $TLD = '', $sTLD = '', $tTLD = '', $ret = ''
	$dom_arr = StringSplit($cDomain, '.')
	$TLD = IniRead('sTLD.ini', $dom_arr[$dom_arr[0]], $dom_arr[$dom_arr[0]], '')
	If $TLD == '' Then
		$ret = ''
	ElseIf $TLD == '0' Then
		$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		$cDomain = $ret
	ElseIf $TLD == '*' Then
		$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		$cDomain = $ret
	EndIf
	$sTLD = IniRead('sTLD.ini', $dom_arr[$dom_arr[0]], $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]], '')
	If $sTLD == '0' Then
		If $dom_arr[0] > 2 Then
			$ret = $dom_arr[$dom_arr[0] - 2] & '.' & $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
			$cDomain = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		ElseIf $dom_arr < 3 Then
			$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
			$cDomain = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		EndIf
	ElseIf $sTLD == '*' Then
		If $dom_arr[0] > 2 Then
			$ret = $dom_arr[$dom_arr[0] - 2] & '.' & $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
			$cDomain = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		ElseIf $dom_arr < 3 Then
			$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
			$cDomain = $dom_arr[$dom_arr[0]]
		EndIf
	ElseIf $sTLD == '!' Then
		$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		$cDomain = $dom_arr[$dom_arr[0]]
		Return $cDomain & '|-|' & $ret & '|-|' & $dom_arr[$dom_arr[0]]
	ElseIf $sTLD == '' Then
		$ret = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		$cDomain = $dom_arr[$dom_arr[0]]
		Return $cDomain & '|-|' & $ret & '|-|' & $dom_arr[$dom_arr[0]]
	EndIf
	If $dom_arr[0] > 2 Then
		$tTLD = IniRead('sTLD.ini', $dom_arr[$dom_arr[0]], $dom_arr[$dom_arr[0] - 2] & '.' & $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]], '')
		If $tTLD <> '' Then
			$ret = $dom_arr[$dom_arr[0] - 2] & '.' & $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
			$cDomain = $dom_arr[$dom_arr[0] - 1] & '.' & $dom_arr[$dom_arr[0]]
		EndIf
	EndIf

	Return $cDomain & '|-|' & $ret & '|-|' & $dom_arr[$dom_arr[0]]
EndFunc   ;==>_getTLD

Func _getTLDDet($cTLD)
	If FileExists('WhoIs.ini') == 0 Then
		MsgBox(0, 'Error', 'WhoIs.ini not found. Cannot proceed.')
		$cTLD = ''
		Return $cTLD
	EndIf
	$cServerIp = IniRead('WhoIs.INI', 'tld', 'ServerIp', '')
	$cRedirectTo = IniRead("WhoIs.INI", 'tld', "RedirectTo", "")
	$cParameters = ''
	$type = 3
	$nPort = 43
	$result = _ConectaServerWhoIs($cServerIp, $nPort, $cTLD, $cParameters, $type)
	If $cRedirectTo <> "" Then
		$nn = StringInStr($result, $cRedirectTo)
		If $nn > 0 Then
			$cServerDomain = StringMid($result, $nn + StringLen($cRedirectTo))
			$cServerDomain = StringMid($cServerDomain, 1, StringInStr($cServerDomain, @CRLF) - 1)
			$cServerDomain = StringStripWS($cServerDomain, 1)
			$cServerDomain = StringStripWS($cServerDomain, 2)
			$cServerIp = TCPNameToIP($cServerDomain)
			IniWrite("WhoIs.ini", $cTLD, 'ServerDomain', $cServerDomain)
			IniWrite("WhoIs.INI", $cTLD, 'ServerIp', $cServerIp)
			IniWrite("WhoIs.INI", $cTLD, 'Port', 43)
		Else
			$cTLD = ''
		EndIf
	EndIf
	Return $cTLD
EndFunc   ;==>_getTLDDet

Func _StripUnwanted($result, $cDomain)
	Local $string
	$string = StringMid($result, 1, StringInStr($result, $cDomain, 2) - 1 - 20)
	If StringLen($string) > 1 Then
		If StringCompare($result, $string) <> 0 Then $result = StringReplace($result, $string, '')
	EndIf
	$string = StringMid($result, StringInStr($result, 'notice', 2))
	If StringLen($string) > 1 Then
		$result = StringReplace($result, $string, '')
	EndIf

	$result = StringReplace($result, 'http://', '')
;~ 	$res_ar = StringRegExp($result, '[\d]{2}:[\d]{2}:[\d]{2}', 3)
	$result = StringRegExpReplace($result, '[\d]{2}:[\d]{2}:[\d]{2}', '')
	If StringInStr($result, '%', 2) > 0 Then
		$ar_ret = StringSplit($result, @CRLF)
		$i = 1
		While $i <= $ar_ret[0]
			If StringLeft($ar_ret[$i], 1) == '%' Then $ar_ret[$i] = ''
			$i += 1
		WEnd
		$result = _ArrayToString($ar_ret, @CRLF)
		$result = StringStripCR($result)
		$result = StringStripWS($result, 7)
		$result = StringReplace($result, @LF, @CRLF)
	EndIf
	Return $result
EndFunc   ;==>_StripUnwanted

;-- END WHOIS -------------------------------------------------------------------------------------