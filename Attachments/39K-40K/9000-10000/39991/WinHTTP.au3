#include-once
#include "WinHTTPConstants.au3"

DllOpen("winhttp.dll")



; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpAddRequestHeaders
; Description ...: Adds one or more HTTP request headers to the HTTP request handle.
; Syntax.........: _WinHttpAddRequestHeaders ($hRequest, $sHeaders [, $iModifiers])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest function.
;                  $sHeader - String that contains the header(s) to append to the request.
;                  $iModifier - Contains the flags used to modify the semantics of this function. Default is $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW.
; Return values .: Success - Returns 1 and Sets
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: In case of multiple additions at once, must use @CRLF to separate each $hRequest and responded $sHeaders and $iModifiers.
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384087(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpAddRequestHeaders($hRequest, $sHeader, $iModifier = $WINHTTP_ADDREQ_FLAG_ADD_IF_NEW)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpAddRequestHeaders", _
			"hwnd", $hRequest, _
			"wstr", $sHeader, _
			"dword", -1, _
			"dword", $iModifier)

	If @error Or Not $a_iCall[0] Then
		SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpAddRequestHeaders




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpBinaryConcat
; Description ...: Concatenates two binary data returned by _WinHttpReadData() in binary mode.
; Syntax.........: _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)
; Parameters ....: $bBinary1 - Binary data that is to be concatenated.
;                  $bBinary2 - Binary data to concat.
; Return values .: Success - Returns concatenated binary data.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - Invalid input.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpBinaryConcat(ByRef $bBinary1, ByRef $bBinary2)

	Switch IsBinary($bBinary1) + 2 * IsBinary($bBinary2)
		Case 0
			Return SetError(1, 0, 0)
		Case 1
			Return SetError(0, 0, $bBinary1)
		Case 2
			Return SetError(0, 0, $bBinary2)
	EndSwitch

	Local $tAuxiliary = DllStructCreate("byte[" & BinaryLen($bBinary1) & "];byte[" & BinaryLen($bBinary2) & "]")
	DllStructSetData($tAuxiliary, 1, $bBinary1)
	DllStructSetData($tAuxiliary, 2, $bBinary2)

	Local $tOutput = DllStructCreate("byte[" & DllStructGetSize($tAuxiliary) & "]", DllStructGetPtr($tAuxiliary))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_WinHttpBinaryConcat




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpCheckPlatform
; Description ...: Determines whether the current platform is supported by this version of Microsoft Windows HTTP Services (WinHTTP).
; Syntax.........: _WinHttpCheckPlatform()
; Parameters ....: None
; Return values .: Success - Returns 1 if current platform is supported
;                          - Returns 0 if current platform is not supported
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384089(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpCheckPlatform()

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpCheckPlatform")

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $a_iCall[0])

EndFunc   ;==>_WinHttpCheckPlatform




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpCloseHandle
; Description ...: Closes a single handle.
; Syntax.........: _WinHttpCloseHandle($hInternet)
; Parameters ....: $hInternet - Valid handle to be closed.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384090(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpCloseHandle($hInternet)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpCloseHandle", "hwnd", $hInternet)

	If @error Or Not $a_iCall[0] Then
		SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpCloseHandle




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpConnect
; Description ...: Specifies the initial target server of an HTTP request and returns connection handle to an HTTP session for that initial target.
; Syntax.........: _WinHttpConnect($hSession, $sServerName [, $iServerPort])
; Parameters ....: $hSession - Valid WinHTTP session handle returned by a previous call to WinHttpOpen.
;                  $sServerName - String that contains the host name of an HTTP server.
;                  $iServerPort - Integer that specifies the TCP/IP port on the server to which a connection is made (default is $INTERNET_DEFAULT_PORT)
; Return values .: Success - Returns a valid connection handle to the HTTP session
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: $nServerPort can be defined via global constants $INTERNET_DEFAULT_PORT, $INTERNET_DEFAULT_HTTP_PORT or $INTERNET_DEFAULT_HTTPS_PORT
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384091(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpConnect($hSession, $sServerName, $iServerPort = $INTERNET_DEFAULT_PORT)

	Local $a_hCall = DllCall("winhttp.dll", "hwnd", "WinHttpConnect", _
			"hwnd", $hSession, _
			"wstr", $sServerName, _
			"dword", $iServerPort, _
			"dword", 0)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $a_hCall[0])

EndFunc   ;==>_WinHttpConnect




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpCrackUrl
; Description ...: Separates a URL into its component parts such as host name and path.
; Syntax.........: _WinHttpCrackUrl($sURL [, $iFlag])
; Parameters ....: $sURL - String that contains the canonical URL to separate.
;                  $dwFlag - Flag that control the operation. Default is $ICU_ESCAPE
; Return values .: Success - Returns array which first element [0] is scheme name,
;                                        second element [1] is internet protocol scheme.,
;                                        third element [2] is host name,
;                                        fourth element [3] is port number,
;                                        fifth element [4] is user name,
;                                        sixth element [5] is password,
;                                        seventh element [6] is URL path,
;                                        eighth element [7] is extra information.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: $dwFlag is defined in WinHTTPConstants.au3 and can be:
;                  | $ICU_DECODE - Converts characters that are "escape encoded" (%xx) to their non-escaped form.
;                  | $ICU_ESCAPE - Escapes certain characters to their escape sequences (%xx).
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384092(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpCrackUrl($sURL, $iFlag = $ICU_ESCAPE)

	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"ushort Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength")

	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))

	Local $tBuffers[6]
	Local $iURLLen = StringLen($sURL)

	For $i = 0 To 5
		$tBuffers[$i] = DllStructCreate("wchar[" & $iURLLen + 1 & "]")
	Next

	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $iURLLen)
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5]))

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpCrackUrl", _
			"wstr", $sURL, _
			"dword", $iURLLen, _
			"dword", $iFlag, _
			"ptr", DllStructGetPtr($tURL_COMPONENTS))

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $a_Ret[8] = [DllStructGetData($tBuffers[0], 1), _
			DllStructGetData($tURL_COMPONENTS, "Scheme"), _
			DllStructGetData($tBuffers[1], 1), _
			DllStructGetData($tURL_COMPONENTS, "Port"), _
			DllStructGetData($tBuffers[2], 1), _
			DllStructGetData($tBuffers[3], 1), _
			DllStructGetData($tBuffers[4], 1), _
			DllStructGetData($tBuffers[5], 1)]

	Return SetError(0, 0, $a_Ret)

EndFunc   ;==>_WinHttpCrackUrl




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpCreateUrl
; Description ...: Creates a URL from array of components such as the host name and path.
; Syntax.........: _WinHttpCreateUrl($aURLArray)
; Parameters ....: $sURL - String that contains the canonical URL to separate.
; Return values .: Success - Returns created URL
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - Invalid input.
;                  |2 - Initial DllCall failed.
;                  |3 - Main DllCall failed
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......: Input is one dimensional 8 elements in size array:
;                                        first element [0] is scheme name,
;                                        second element [1] is internet protocol scheme.,
;                                        third element [2] is host name,
;                                        fourth element [3] is port number,
;                                        fifth element [4] is user name,
;                                        sixth element [5] is password,
;                                        seventh element [6] is URL path,
;                                        eighth element [7] is extra information.
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384093(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpCreateUrl($aURLArray)

	If UBound($aURLArray) - 8 Then
		Return SetError(1, 0, "")
	EndIf

	Local $tURL_COMPONENTS = DllStructCreate("dword StructSize;" & _
			"ptr SchemeName;" & _
			"dword SchemeNameLength;" & _
			"int Scheme;" & _
			"ptr HostName;" & _
			"dword HostNameLength;" & _
			"ushort Port;" & _
			"ptr UserName;" & _
			"dword UserNameLength;" & _
			"ptr Password;" & _
			"dword PasswordLength;" & _
			"ptr UrlPath;" & _
			"dword UrlPathLength;" & _
			"ptr ExtraInfo;" & _
			"dword ExtraInfoLength;")

	DllStructSetData($tURL_COMPONENTS, 1, DllStructGetSize($tURL_COMPONENTS))

	Local $tBuffers[6][2]

	$tBuffers[0][1] = StringLen($aURLArray[0])
	If $tBuffers[0][1] Then
		$tBuffers[0][0] = DllStructCreate("wchar[" & $tBuffers[0][1] + 1 & "]")
		DllStructSetData($tBuffers[0][0], 1, $aURLArray[0])
	EndIf

	$tBuffers[1][1] = StringLen($aURLArray[2])
	If $tBuffers[1][1] Then
		$tBuffers[1][0] = DllStructCreate("wchar[" & $tBuffers[1][1] + 1 & "]")
		DllStructSetData($tBuffers[1][0], 1, $aURLArray[2])
	EndIf

	$tBuffers[2][1] = StringLen($aURLArray[4])
	If $tBuffers[2][1] Then
		$tBuffers[2][0] = DllStructCreate("wchar[" & $tBuffers[2][1] + 1 & "]")
		DllStructSetData($tBuffers[2][0], 1, $aURLArray[4])
	EndIf

	$tBuffers[3][1] = StringLen($aURLArray[5])
	If $tBuffers[3][1] Then
		$tBuffers[3][0] = DllStructCreate("wchar[" & $tBuffers[3][1] + 1 & "]")
		DllStructSetData($tBuffers[3][0], 1, $aURLArray[5])
	EndIf

	$tBuffers[4][1] = StringLen($aURLArray[6])
	If $tBuffers[4][1] Then
		$tBuffers[4][0] = DllStructCreate("wchar[" & $tBuffers[4][1] + 1 & "]")
		DllStructSetData($tBuffers[4][0], 1, $aURLArray[6])
	EndIf

	$tBuffers[5][1] = StringLen($aURLArray[7])
	If $tBuffers[5][1] Then
		$tBuffers[5][0] = DllStructCreate("wchar[" & $tBuffers[5][1] + 1 & "]")
		DllStructSetData($tBuffers[5][0], 1, $aURLArray[7])
	EndIf

	DllStructSetData($tURL_COMPONENTS, "SchemeNameLength", $tBuffers[0][1])
	DllStructSetData($tURL_COMPONENTS, "SchemeName", DllStructGetPtr($tBuffers[0][0]))
	DllStructSetData($tURL_COMPONENTS, "HostNameLength", $tBuffers[1][1])
	DllStructSetData($tURL_COMPONENTS, "HostName", DllStructGetPtr($tBuffers[1][0]))
	DllStructSetData($tURL_COMPONENTS, "UserNameLength", $tBuffers[2][1])
	DllStructSetData($tURL_COMPONENTS, "UserName", DllStructGetPtr($tBuffers[2][0]))
	DllStructSetData($tURL_COMPONENTS, "PasswordLength", $tBuffers[3][1])
	DllStructSetData($tURL_COMPONENTS, "Password", DllStructGetPtr($tBuffers[3][0]))
	DllStructSetData($tURL_COMPONENTS, "UrlPathLength", $tBuffers[4][1])
	DllStructSetData($tURL_COMPONENTS, "UrlPath", DllStructGetPtr($tBuffers[4][0]))
	DllStructSetData($tURL_COMPONENTS, "ExtraInfoLength", $tBuffers[5][1])
	DllStructSetData($tURL_COMPONENTS, "ExtraInfo", DllStructGetPtr($tBuffers[5][0]))

	DllStructSetData($tURL_COMPONENTS, "Scheme", $aURLArray[1])
	DllStructSetData($tURL_COMPONENTS, "Port", $aURLArray[3])

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpCreateUrl", _
			"ptr", DllStructGetPtr($tURL_COMPONENTS), _
			"dword", $ICU_ESCAPE, _
			"ptr", 0, _
			"dword*", 0)

	If @error Then
		Return SetError(2, 0, "")
	EndIf

	Local $iURLLen = $a_iCall[4]

	Local $URLBuffer = DllStructCreate("wchar[" & ($iURLLen + 1) & "]")

	$a_iCall = DllCall("winhttp.dll", "int", "WinHttpCreateUrl", _
			"ptr", DllStructGetPtr($tURL_COMPONENTS), _
			"dword", $ICU_ESCAPE, _
			"ptr", DllStructGetPtr($URLBuffer), _
			"dword*", $iURLLen)

	If @error Or Not $a_iCall[0] Then
		Return SetError(3, 0, "")
	EndIf

	Return SetError(0, 0, DllStructGetData($URLBuffer, 1))

EndFunc   ;==>_WinHttpCreateUrl




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpDetectAutoProxyConfigUrl
; Description ...: Finds the URL for the Proxy Auto-Configuration (PAC) file.
; Syntax.........: _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)
; Parameters ....: $iAutoDetectFlags - Specifies what protocols to use to locate the PAC file.
; Return values .: Success - Returns URL for the PAC file.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed.
;                  |2 - Internal failure.
; Author ........: trancexx
; Modified.......:
; Remarks .......: $iAutoDetectFlags defined in WinHTTPconstants.au3
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384094(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpDetectAutoProxyConfigUrl($iAutoDetectFlags)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpDetectAutoProxyConfigUrl", _
			"dword", $iAutoDetectFlags, _
			"ptr*", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	Local $pString = $a_iCall[2]

	If $pString Then
		Local $iLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pString)
		If @error Then
			Return SetError(2, 0, "")
		EndIf
		Local $tString = DllStructCreate("wchar[" & $iLen[0] + 1 & "]", $pString)

		Return SetError(0, 0, DllStructGetData($tString, 1))
	EndIf

	Return SetError(0, 0, "")

EndFunc   ;==>_WinHttpDetectAutoProxyConfigUrl




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpGetDefaultProxyConfiguration
; Description ...: Retrieves the default WinHTTP proxy configuration.
; Syntax.........: _WinHttpGetDefaultProxyConfiguration()
; Parameters ....: None.
; Return values .: Success - Returns array which first element [0] is integer value that contains the access type,
;                                        second element [1] is string value that contains the proxy server list,
;                                        third element [2] is string value that contains the proxy bypass list.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
;                  |2 - Internal failure.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Access types are defined in WinHTTPconstants.au3:
;                  |$WINHTTP_ACCESS_TYPE_DEFAULT_PROXY = 0
;                  |$WINHTTP_ACCESS_TYPE_NO_PROXY = 1
;                  |$WINHTTP_ACCESS_TYPE_NAMED_PROXY = 3
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384095(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpGetDefaultProxyConfiguration()

	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpGetDefaultProxyConfiguration", "ptr", DllStructGetPtr($tWINHTTP_PROXY_INFO))

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $aArray[3] = [DllStructGetData($tWINHTTP_PROXY_INFO, "AccessType"), _
			DllStructGetData($tWINHTTP_PROXY_INFO, "Proxy"), _
			DllStructGetData($tWINHTTP_PROXY_INFO, "ProxyBypass")]

	If $aArray[1] Then
		Local $iProxyLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $aArray[1])
		If @error Then
			Return SetError(2, 0, 0)
		EndIf
		Local $string_Proxy = DllStructCreate("wchar[" & $iProxyLen[0] + 1 & "]", $aArray[1])
		Local $Proxy = DllStructGetData($string_Proxy, 1)
	Else
		$Proxy = ""
	EndIf

	If $aArray[2] Then
		Local $iProxyBypassLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $aArray[2])
		If @error Then
			Return SetError(2, 0, 0)
		EndIf
		Local $string_ProxyBypass = DllStructCreate("wchar[" & $iProxyBypassLen[0] + 1 & "]", $aArray[2])
		Local $ProxyBypass = DllStructGetData($string_ProxyBypass, 1)
	Else
		$ProxyBypass = ""
	EndIf

	Local $a_Ret[3] = [$aArray[0], $Proxy, $ProxyBypass]

	Return SetError(0, 0, $a_Ret)

EndFunc   ;==>_WinHttpGetDefaultProxyConfiguration




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpGetIEProxyConfigForCurrentUser
; Description ...: Retrieves the Internet Explorer proxy configuration for the current user.
; Syntax.........: _WinHttpGetIEProxyConfigForCurrentUser()
; Parameters ....: None.
; Return values .: Success - Returns array which first element [0] if 1 indicates that the Internet Explorer proxy configuration for the current user specifies "automatically detect settings",
;                                        second element [1] is string that contains the auto-configuration URL if the Internet Explorer proxy configuration for the current user specifies "Use automatic proxy configuration",
;                                        third element [2] is string that contains the proxy URL if the Internet Explorer proxy configuration for the current user specifies "use a proxy server",
;                                        fourth element [3] is string that contains the optional proxy by-pass server list.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
;                  |2 - Internal failure.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384096(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpGetIEProxyConfigForCurrentUser()

	Local $tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG = DllStructCreate("int AutoDetect;" & _
			"ptr AutoConfigUrl;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass;")

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpGetIEProxyConfigForCurrentUser", "ptr", DllStructGetPtr($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG))

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $aArray[4] = [DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoDetect"), _
			DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "AutoConfigUrl"), _
			DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "Proxy"), _
			DllStructGetData($tWINHTTP_CURRENT_USER_IE_PROXY_CONFIG, "ProxyBypass")]

	Local $sAutoConfigUrl
	If $aArray[1] Then
		Local $aAutoConfigUrlLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $aArray[1])
		If @error Then
			Return SetError(2, 0, 0)
		EndIf
		Local $tAutoConfigUrl = DllStructCreate("wchar[" & $aAutoConfigUrlLen[0] + 1 & "]", $aArray[1])
		$sAutoConfigUrl = DllStructGetData($tAutoConfigUrl, 1)
	Else
		$sAutoConfigUrl = ""
	EndIf

	Local $sProxy
	If $aArray[2] Then
		Local $aProxyLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $aArray[2])
		If @error Then
			Return SetError(2, 0, 0)
		EndIf
		Local $tProxy = DllStructCreate("wchar[" & $aProxyLen[0] + 1 & "]", $aArray[2])
		$sProxy = DllStructGetData($tProxy, 1)
	Else
		$sProxy = ""
	EndIf

	Local $sProxyBypass
	If $aArray[3] Then
		Local $aProxyBypassLen = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $aArray[3])
		If @error Then
			Return SetError(2, 0, 0)
		EndIf
		Local $tProxyBypass = DllStructCreate("wchar[" & $aProxyBypassLen[0] + 1 & "]", $aArray[3])
		$sProxyBypass = DllStructGetData($tProxyBypass, 1)
	Else
		$sProxyBypass = ""
	EndIf

	Local $aOutput[4] = [$aArray[0], $sAutoConfigUrl, $sProxy, $sProxyBypass]

	Return SetError(0, 0, $aOutput)

EndFunc   ;==>_WinHttpGetIEProxyConfigForCurrentUser




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpOpen
; Description ...: Initializes the use of WinHTTP functions and returns a WinHTTP-session handle.
; Syntax.........: _WinHttpOpen([$sUserAgent [, $iAccessType [, $sProxyName [, $sProxyBypass [, $iFlags ]]]]])
; Parameters ....: $sUserAgent - String that contains the name of the application or entity calling the WinHTTP functions.
;                  $iAccessType - Type of access required.
;                  $sProxyName - String that contains the name of the proxy server to use when proxy access is specified by setting $iAccessType to $WINHTTP_ACCESS_TYPE_NAMED_PROXY.
;                  $sProxyBypass - String that contains an optional list of host names or IP addresses, or both, that should not be routed through the proxy when $iAccessType is set to $WINHTTP_ACCESS_TYPE_NAMED_PROXY.
;                  $iFlag - Integer that contains the flags that indicate various options affecting the behavior of this function.
; Return values .: Success - Returns valid session handle.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: For asynchronous mode set $iFlag to $WINHTTP_FLAG_ASYNC
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384098(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpOpen($sUserAgent = "AutoIt v3", $iAccessType = $WINHTTP_ACCESS_TYPE_NO_PROXY, $sProxyName = $WINHTTP_NO_PROXY_NAME, $sProxyBypass = $WINHTTP_NO_PROXY_BYPASS, $iFlag = 0)

	Local $a_hCall = DllCall("winhttp.dll", "hwnd", "WinHttpOpen", _
			"wstr", $sUserAgent, _
			"dword", $iAccessType, _
			"wstr", $sProxyName, _
			"wstr", $sProxyBypass, _
			"dword", $iFlag)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $a_hCall[0])

EndFunc   ;==>_WinHttpOpen




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpOpenRequest
; Description ...: Creates an HTTP request handle.
; Syntax.........: _WinHttpOpenRequest($hConnect [, $sVerb [, $sObjectName[, $sVersion [, $sReferrer [, $ppwszAcceptTypes [, $iFlags]]]]]])
; Parameters ....: $hConnect - Handle to an HTTP session returned by _WinHttpConnect().
;                  $sVerb - String that contains the HTTP verb to use in the request. Default is "GET".
;                  $sObjectName - String that contains the name of the target resource of the specified HTTP verb.
;                  $sVersion - String that contains the HTTP version. Default is "HTTP/1.1"
;                  $sReferrer - String that specifies the URL of the document from which the URL in the request $sObjectName was obtained. Default is $WINHTTP_NO_REFERER.
;                  $sAcceptTypes - String that specifies media types accepted by the client. Default is $WINHTTP_DEFAULT_ACCEPT_TYPES
;                  $iFlags - Integer that contains the Internet flag values. Default is $WINHTTP_FLAG_ESCAPE_DISABLE
; Return values .: Success - Returns valid session handle.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384099(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpOpenRequest($hConnect, $sVerb = "GET", $sObjectName = "", $sVersion = "HTTP/1.1", $sReferrer = $WINHTTP_NO_REFERER, $sAcceptTypes = $WINHTTP_DEFAULT_ACCEPT_TYPES, $iFlags = $WINHTTP_FLAG_ESCAPE_DISABLE)

	Local $a_hCall = DllCall("winhttp.dll", "hwnd", "WinHttpOpenRequest", _
			"hwnd", $hConnect, _
			"wstr", StringUpper($sVerb), _
			"wstr", $sObjectName, _
			"wstr", StringUpper($sVersion), _
			"wstr", $sReferrer, _
			"wstr*", $sAcceptTypes, _
			"dword", $iFlags)

	If @error Or Not $a_hCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $a_hCall[0])

EndFunc   ;==>_WinHttpOpenRequest




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpQueryDataAvailable
; Description ...: Returns the availability to be read with WinHttpReadData.
; Syntax.........: _WinHttpQueryDataAvailable($hRequest)
; Parameters ....: $hRequest - handle returned by _WinHttpOpenRequest().
; Return values .: Success - Returns 1 if data is available.
;                          - Returns 0 if no data is available.
;                          - @extended receives the number of available bytes.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: _WinHttpReceiveResponse() must have been called for this handle and have completed before _WinHttpQueryDataAvailable is called.
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384101(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpQueryDataAvailable($hRequest)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpQueryDataAvailable", _
			"hwnd", $hRequest, _
			"dword*", 0)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, $a_iCall[2], $a_iCall[0])

EndFunc   ;==>_WinHttpQueryDataAvailable




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpQueryHeaders
; Description ...: Retrieves header information associated with an HTTP request.
; Syntax.........: _WinHttpQueryHeaders($hRequest, $iInfoLevel, $sName)
; Parameters ....: $hRequest - handle returned by _WinHttpOpenRequest().
;                  $iInfoLevel - Specifies a combination of attribute and modifier flags. Default is $WINHTTP_QUERY_RAW_HEADERS_CRLF.
;                  $sName - String that contains the header name. Default is $WINHTTP_HEADER_NAME_BY_INDEX.
; Return values .: Success - Returns string that contains header.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - Initial DllCall failed.
;                  |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384102(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpQueryHeaders($hRequest, $iInfoLevel = $WINHTTP_QUERY_RAW_HEADERS_CRLF, $sName = $WINHTTP_HEADER_NAME_BY_INDEX)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpQueryHeaders", _
			"hwnd", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"ptr", 0, _
			"dword*", 0, _
			"dword*", 0)

	If @error Or $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Local $iSize = $a_iCall[5]

	If Not $iSize Then
		Return SetError(0, 0, "")
	EndIf

	Local $tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")

	$a_iCall = DllCall("winhttp.dll", "int", "WinHttpQueryHeaders", _
			"hwnd", $hRequest, _
			"dword", $iInfoLevel, _
			"wstr", $sName, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword*", $iSize, _
			"dword*", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Return SetError(0, 0, DllStructGetData($tBuffer, 1))

EndFunc   ;==>_WinHttpQueryHeaders




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpQueryOption
; Description ...: Queries an Internet option on the specified handle.
; Syntax.........: _WinHttpQueryOption($hInternet, $iOption)
; Parameters ....: $hInternet - Handle on which to query information.
;                  $iOption - Integer value that contains the Internet option to query.
; Return values .: Success - Returns data containing requested information.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Initial DllCall failed.
;                  |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Type of the returned data varies on request.
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384103(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpQueryOption($hInternet, $iOption)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpQueryOption", _
			"hwnd", $hInternet, _
			"dword", $iOption, _
			"ptr", 0, _
			"dword*", 0)

	If @error Or $a_iCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	Local $iSize = $a_iCall[4]

	Local $tBuffer

	Switch $iOption
		Case $WINHTTP_OPTION_CONNECTION_INFO, $WINHTTP_OPTION_PASSWORD, $WINHTTP_OPTION_PROXY_PASSWORD, $WINHTTP_OPTION_PROXY_USERNAME, $WINHTTP_OPTION_URL, $WINHTTP_OPTION_USERNAME, $WINHTTP_OPTION_USER_AGENT, _
				$WINHTTP_OPTION_PASSPORT_COBRANDING_TEXT, $WINHTTP_OPTION_PASSPORT_COBRANDING_URL
			$tBuffer = DllStructCreate("wchar[" & $iSize + 1 & "]")
		Case $WINHTTP_OPTION_PARENT_HANDLE, $WINHTTP_OPTION_CALLBACK
			$tBuffer = DllStructCreate("ptr")
		Case $WINHTTP_OPTION_CONNECT_TIMEOUT, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_HIGH, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_LOW, $WINHTTP_AUTOLOGON_SECURITY_LEVEL_MEDIUM, _
				$WINHTTP_OPTION_CONFIGURE_PASSPORT_AUTH, $WINHTTP_OPTION_CONNECT_RETRIES, $WINHTTP_OPTION_EXTENDED_ERROR, $WINHTTP_OPTION_HANDLE_TYPE, $WINHTTP_OPTION_MAX_CONNS_PER_1_0_SERVER, _
				$WINHTTP_OPTION_MAX_CONNS_PER_SERVER, $WINHTTP_OPTION_MAX_HTTP_AUTOMATIC_REDIRECTS, $WINHTTP_OPTION_RECEIVE_RESPONSE_TIMEOUT, $WINHTTP_OPTION_RECEIVE_TIMEOUT, _
				$WINHTTP_OPTION_RESOLVE_TIMEOUT, $WINHTTP_OPTION_SECURITY_FLAGS, $WINHTTP_OPTION_SECURITY_KEY_BITNESS, $WINHTTP_OPTION_SEND_TIMEOUT
			$tBuffer = DllStructCreate("int")
		Case Else
			DllStructCreate("byte[" & $iSize & "]")
	EndSwitch

	$a_iCall = DllCall("winhttp.dll", "int", "WinHttpQueryOption", _
			"hwnd", $hInternet, _
			"dword", $iOption, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword*", $iSize)

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, "")
	EndIf

	Return SetError(0, 0, DllStructGetData($tBuffer, 1))

EndFunc   ;==>_WinHttpQueryOption




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpReadData
; Description ...: Reads data from a handle opened by the _WinHttpOpenRequest() function.
; Syntax.........: _WinHttpReadData($hRequest [, iMode [, $iNumberOfBytesToRead]])
; Parameters ....: $hRequest - Valid handle returned from a previous call to _WinHttpOpenRequest().
;                  $iMode - Integer representing reading mode. Default is 0 (charset is decoded as it is ANSI).
;                  $iNumberOfBytesToRead - Integer value that contains the number of bytes to read. Default is 8192 bytes.
; Return values .: Success - Returns data read.
;                          - @extended receives the number of bytes read.
;                          - Sets @error to 0
;                  Special: Sets @error to -1 if no more data to read (end reached).
;                  Failure - Returns empty string and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx, ProgAndy
; Modified.......:
; Remarks .......: iMode can have these values:
;                  |0 - ANSI
;                  |1 - UTF8
;                  |2 - Binary
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384104(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpReadData($hRequest, $iMode = 0, $iNumberOfBytesToRead = 8192)

	Local $tBuffer

	Switch $iMode
		Case 1, 2
			$tBuffer = DllStructCreate("byte[" & $iNumberOfBytesToRead & "]")
		Case Else
			$iMode = 0
			$tBuffer = DllStructCreate("char[" & $iNumberOfBytesToRead & "]")
	EndSwitch

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpReadData", _
			"hwnd", $hRequest, _
			"ptr", DllStructGetPtr($tBuffer), _
			"ulong", $iNumberOfBytesToRead, _
			"dword*", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, "")
	EndIf

	If Not $a_iCall[4] Then
		Return SetError(-1, 0, "")
	EndIf

	Switch $a_iCall[4] < $iNumberOfBytesToRead
		Case True
			Switch $iMode
				Case 0
					Return SetError(0, $a_iCall[4], StringLeft(DllStructGetData($tBuffer, 1), $a_iCall[4]))
				Case 1
					Return SetError(0, $a_iCall[4], BinaryToString(BinaryMid(DllStructGetData($tBuffer, 1), 1, $a_iCall[4]), 4))
				Case 2
					Return SetError(0, $a_iCall[4], BinaryMid(DllStructGetData($tBuffer, 1), 1, $a_iCall[4]))
			EndSwitch
		Case Else
			Switch $iMode
				Case 0, 2
					Return SetError(0, $a_iCall[4], DllStructGetData($tBuffer, 1))
				Case 1
					Return SetError(0, $a_iCall[4], BinaryToString(DllStructGetData($tBuffer, 1), 4))
			EndSwitch
	EndSwitch

EndFunc   ;==>_WinHttpReadData




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpReceiveResponse
; Description ...: Waits to receive the response to an HTTP request initiated by WinHttpSendRequest().
; Syntax.........: _WinHttpReceiveResponse($hRequest)
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest() and sent by _WinHttpSendRequest().
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Must call _WinHttpReceiveResponse() before _WinHttpQueryDataAvailable() and _WinHttpReadData().
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384105(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpReceiveResponse($hRequest)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpReceiveResponse", _
			"hwnd", $hRequest, _
			"ptr", 0)

	If @error Or Not $a_iCall[0] Then
		SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpReceiveResponse




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSendRequest
; Description ...: Sends the specified request to the HTTP server.
; Syntax.........: _WinHttpSendRequest($hRequest [, $sHeaders [, $sOptional [, $iTotalLength [, $iContext]]]])
; Parameters ....: $hRequest - Handle returned by _WinHttpOpenRequest().
;                  $sHeaders - String that contains the additional headers to append to the request. Default is $WINHTTP_NO_ADDITIONAL_HEADERS.
;                  $sOptional - String that contains any optional data to send immediately after the request headers. Default is $WINHTTP_NO_REQUEST_DATA.
;                  $iTotalLength - An unsigned long integer value that contains the length, in bytes, of the total optional data sent. Default is 0.
;                  $iContext - A pointer to a pointer-sized variable that contains an application-defined value that is passed, with the request handle, to any callback functions. Default is 0.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Specifying optional data ($sOptional) will cause $iTotalLength to receive the size of that data if left default value.
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384110(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSendRequest($hRequest, $sHeaders = $WINHTTP_NO_ADDITIONAL_HEADERS, $sOptional = $WINHTTP_NO_REQUEST_DATA, $iTotalLength = 0, $iContext = 0)

	Local $iOptionalLength = StringLen($sOptional)
	Local $structOptional = DllStructCreate("char[" & $iOptionalLength + 1 & "]")
	DllStructSetData($structOptional, 1, $sOptional)

	If Not $iTotalLength Or $iTotalLength < $iOptionalLength Then
		$iTotalLength += $iOptionalLength
	EndIf

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpSendRequest", _
			"hwnd", $hRequest, _
			"wstr", $sHeaders, _
			"dword", 0, _
			"ptr", DllStructGetPtr($structOptional), _
			"dword", $iOptionalLength, _
			"dword", $iTotalLength, _
			"ptr", $iContext)

	If @error Or Not $a_iCall[0] Then
		SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpSendRequest




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSetCredentials
; Description ...: Passes the required authorization credentials to the server.
; Syntax.........: _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)
; Parameters ....: $hRequest - Valid handle returned by _WinHttpOpenRequest().
;                  $iAuthTargets - Integer that specifies a flag that contains the authentication target.
;                  $iAuthScheme - Integer that specifies a flag that contains the authentication scheme.
;                  $sUserName - String that contains a valid user name.
;                  $sPassword - String that contains a valid password.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384112(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSetCredentials($hRequest, $iAuthTargets, $iAuthScheme, $sUserName, $sPassword)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpSetCredentials", _
			"hwnd", $hRequest, _
			"dword", $iAuthTargets, _
			"dword", $iAuthScheme, _
			"wstr", $sUserName, _
			"wstr", $sPassword, _
			"ptr", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpSetCredentials




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSetDefaultProxyConfiguration
; Description ...: Sets the default WinHTTP proxy configuration.
; Syntax.........: _WinHttpSetDefaultProxyConfiguration($iAccessType, $Proxy, $ProxyBypass)
; Parameters ....: $iAccessType - Integer value that contains the access type.
;                  $Proxy - String value that contains the proxy server list.
;                  $ProxyBypass - String value that contains the proxy bypass list.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384113(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSetDefaultProxyConfiguration($iAccessType, $Proxy, $ProxyBypass)

	Local $tProxy = DllStructCreate("wchar[" & StringLen($Proxy) + 1 & "]")
	DllStructSetData($tProxy, 1, $Proxy)

	Local $tProxyBypass = DllStructCreate("wchar[" & StringLen($ProxyBypass) + 1 & "]")
	DllStructSetData($tProxyBypass, 1, $ProxyBypass)

	Local $tWINHTTP_PROXY_INFO = DllStructCreate("dword AccessType;" & _
			"ptr Proxy;" & _
			"ptr ProxyBypass")

	DllStructSetData($tWINHTTP_PROXY_INFO, "AccessType", $iAccessType)
	DllStructSetData($tWINHTTP_PROXY_INFO, "Proxy", DllStructGetPtr($tProxy))
	DllStructSetData($tWINHTTP_PROXY_INFO, "ProxyBypass", DllStructGetPtr($tProxyBypass))

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpSetDefaultProxyConfiguration", "ptr", DllStructGetPtr($tWINHTTP_PROXY_INFO))

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpSetDefaultProxyConfiguration




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSetOption
; Description ...: Sets an Internet option.
; Syntax.........: _WinHttpSetOption($hInternet, $iOption, $sSetting)
; Parameters ....: $hInternet - Handle on which to set data.
;                  $iOption - Integer value that contains the Internet option to set.
;                  $sSetting - String value that contains desired setting.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384114(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSetOption($hInternet, $iOption, $sSetting)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpSetOption", _
			"hwnd", $hInternet, _
			"dword", $iOption, _
			"wstr", $sSetting, _
			"dword", StringLen($sSetting))

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpSetOption




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSetStatusCallback
; Description ...: Sets up a callback function that WinHTTP can call as progress is made during an operation.
; Syntax.........: _WinHttpSetStatusCallback($hInternet, $pInternetCallback, $iNotificationFlags)
; Parameters ....: $hInternet - Handle for which the callback is to be set.
;                  $fInternetCallback - Callback function to call when progress is made.
;                  $iNotificationFlags - Integer value that specifies flags to indicate which events activate the callback function. Default is $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS.
; Return values .: Success - Returns a pointer to the previously defined status callback function or NULL if there was no previously defined status callback function.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: ProgAndy
; Modified.......: trancexx
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384115(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSetStatusCallback($hInternet, $fInternetCallback, $iNotificationFlags = $WINHTTP_CALLBACK_FLAG_ALL_NOTIFICATIONS)

	Local $a_pCall = DllCall("winhttp.dll", "ptr", "WinHttpSetStatusCallback", _
			"hwnd", $hInternet, _
			"ptr", DllCallbackGetPtr($fInternetCallback), _
			"dword", $iNotificationFlags, _
			"ptr", 0)

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, $a_pCall[0])

EndFunc   ;==>_WinHttpSetStatusCallback




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpSetTimeouts
; Description ...: Sets time-outs involved with HTTP transactions.
; Syntax.........: _WinHttpSetTimeouts($hInternet, $iResolveTimeout, $iConnectTimeout, $iSendTimeout, $iReceiveTimeout)
; Parameters ....: $hInternet - Handle returned by _WinHttpOpen() or _WinHttpOpenRequest().
;                  $iResolveTimeout - Integer that specifies the time-out value, in milliseconds, to use for name resolution.
;                  $iConnectTimeout - Integer that specifies the time-out value, in milliseconds, to use for server connection requests.
;                  $iSendTimeout - Integer that specifies the time-out value, in milliseconds, to use for sending requests.
;                  $iReceiveTimeout - integer that specifies the time-out value, in milliseconds, to receive a response to a request.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......: Initial values are: - $iResolveTimeout = 0
;                                      - $iConnectTimeout = 60000
;                                      - $iSendTimeout = 30000
;                                      - $iReceiveTimeout = 30000
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384116(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpSetTimeouts($hInternet, $iResolveTimeout, $iConnectTimeout, $iSendTimeout, $iReceiveTimeout)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpSetTimeouts", _
			"hwnd", $hInternet, _
			"int", $iResolveTimeout, _
			"int", $iConnectTimeout, _
			"int", $iSendTimeout, _
			"int", $iReceiveTimeout)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, 0, 1)

EndFunc   ;==>_WinHttpSetTimeouts




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpTimeFromSystemTime
; Description ...: Formats a system date and time according to the HTTP version 1.0 specification.
; Syntax.........: _WinHttpTimeFromSystemTime()
; Parameters ....: None.
; Return values .: Success - Returns 1.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - Initial DllCall failed.
;                  |2 - Main DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384117(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpTimeFromSystemTime()

	Local $SYSTEMTIME = DllStructCreate("ushort Year;" & _
			"ushort Month;" & _
			"ushort DayOfWeek;" & _
			"ushort Day;" & _
			"ushort Hour;" & _
			"ushort Minute;" & _
			"ushort Second;" & _
			"ushort Milliseconds")

	DllCall("kernel32.dll", "none", "GetSystemTime", "ptr", DllStructGetPtr($SYSTEMTIME))

	If @error Then
		Return SetError(1, 0, 0)
	EndIf

	Local $sTime = DllStructCreate("wchar[62]")

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpTimeFromSystemTime", _
			"ptr", DllStructGetPtr($SYSTEMTIME), _
			"ptr", DllStructGetPtr($sTime))

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Return SetError(0, 0, DllStructGetData($sTime, 1))

EndFunc   ;==>_WinHttpTimeFromSystemTime




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpTimeToSystemTime
; Description ...: Takes an HTTP time/date string and converts it to array (SYSTEMTIME structure values).
; Syntax.........: _WinHttpTimeToSystemTime($sHttpTime)
; Parameters ....: $sHttpTime - Date/time string to convert.
; Return values .: Success - Returns array which first element [0] is Year,
;                                        second element [1] is Month,
;                                        third element [2] is DayOfWeek,
;                                        fourth element [3] is Day,
;                                        fifth element [4] is Hour,
;                                        sixth element [5] is Minute,
;                                        seventh element [6] is Second.,
;                                        eighth element [7] is Milliseconds.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384118(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpTimeToSystemTime($sHttpTime)

	Local $SYSTEMTIME = DllStructCreate("ushort Year;" & _
			"ushort Month;" & _
			"ushort DayOfWeek;" & _
			"ushort Day;" & _
			"ushort Hour;" & _
			"ushort Minute;" & _
			"ushort Second;" & _
			"ushort Milliseconds")

	Local $sTime = DllStructCreate("wchar[62]")
	DllStructSetData($sTime, 1, $sHttpTime)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpTimeToSystemTime", _
			"ptr", DllStructGetPtr($sTime), _
			"ptr", DllStructGetPtr($SYSTEMTIME))

	If @error Or Not $a_iCall[0] Then
		Return SetError(2, 0, 0)
	EndIf

	Local $a_Ret[8] = [DllStructGetData($SYSTEMTIME, "Year"), _
			DllStructGetData($SYSTEMTIME, "Month"), _
			DllStructGetData($SYSTEMTIME, "DayOfWeek"), _
			DllStructGetData($SYSTEMTIME, "Day"), _
			DllStructGetData($SYSTEMTIME, "Hour"), _
			DllStructGetData($SYSTEMTIME, "Minute"), _
			DllStructGetData($SYSTEMTIME, "Second"), _
			DllStructGetData($SYSTEMTIME, "Milliseconds")]

	Return SetError(0, 0, $a_Ret)

EndFunc   ;==>_WinHttpTimeToSystemTime




; #FUNCTION# ;===============================================================================
;
; Name...........: _WinHttpWriteData
; Description ...: Writes request data to an HTTP server.
; Syntax.........: _WinHttpWriteData($hRequest, $data [, $iMode])
; Parameters ....: $hRequest - Valid handle returned by _WinHttpSendRequest().
;                  $data - Data to write.
;                  $iMode - Integer representing writing mode. Default is 0 - write ANSI string.
; Return values .: Success - Returns 1
;                          - @extended receives the number of bytes written.
;                          - Sets @error to 0
;                  Failure - Returns 0 and sets @error:
;                  |1 - DllCall failed.
; Author ........: trancexx, ProgAndy
; Modified.......:
; Remarks .......: $data variable is either string or binary data to write.
;                  $iMode can have these values:
;                  |0 - to write ANSI string
;                  |1 - to write binary data
; Related .......:
; Link ..........; http://msdn.microsoft.com/en-us/library/aa384120(VS.85).aspx
; Example .......; Yes
;
;==========================================================================================
Func _WinHttpWriteData($hRequest, $data, $iMode = 0)

	Local $iNumberOfBytesToWrite, $tData
	Switch $iMode
		Case 1
			$iNumberOfBytesToWrite = BinaryLen($data)
			$tData = DllStructCreate("byte[" & $iNumberOfBytesToWrite & "]")
		Case Else
			$iNumberOfBytesToWrite = StringLen($data)
            $tData = DllStructCreate("char[" & $iNumberOfBytesToWrite + 1 & "]")
	EndSwitch

	DllStructSetData($tData, 1, $data)

	Local $a_iCall = DllCall("winhttp.dll", "int", "WinHttpWriteData", _
			"hwnd", $hRequest, _
			"ptr", DllStructGetPtr($tData), _
			"dword", $iNumberOfBytesToWrite, _
			"dword*", 0)

	If @error Or Not $a_iCall[0] Then
		Return SetError(1, 0, 0)
	EndIf

	Return SetError(0, $a_iCall[4], 1)


EndFunc   ;==>_WinHttpWriteData
