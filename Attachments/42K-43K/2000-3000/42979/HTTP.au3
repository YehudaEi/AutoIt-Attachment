#include-once
#include <Inet.au3>

Global $aHTTPCookieJar[1][4]

;#######################################################################
;-----------------------------------------------------------------------
;		HTMLUnescape - HTML entitie unescape
;-----------------------------------------------------------------------
Func HTMLUnescape($EncodedString)
	$EncodedString = StringReplace($EncodedString, "&nbsp", " ")
	$EncodedString = StringReplace($EncodedString, "&lt", "<")
	$EncodedString = StringReplace($EncodedString, "&gt", ">")
	$EncodedString = StringReplace($EncodedString, "&amp", "&")
	$EncodedString = StringReplace($EncodedString, "&apos;", "'")
	$EncodedString = StringReplace($EncodedString, "&cent", "")
	$EncodedString = StringReplace($EncodedString, "&pound", "")
	$EncodedString = StringReplace($EncodedString, "&yen", "")
	$EncodedString = StringReplace($EncodedString, "&euro", "")
	$EncodedString = StringReplace($EncodedString, "&sect", "")
	$EncodedString = StringReplace($EncodedString, "&copy", "")
	$EncodedString = StringReplace($EncodedString, "&reg", "")
	$EncodedString = StringReplace($EncodedString, "&trade", "")
	Return $EncodedString
EndFunc

;#######################################################################
;-----------------------------------------------------------------------
;		_Base64Encode -
;-----------------------------------------------------------------------
Func _Base64Encode($input)
    $input = Binary($input)
    Local $struct = DllStructCreate("byte[" & BinaryLen($input) & "]")
    DllStructSetData($struct, 1, $input)
    Local $strc = DllStructCreate("int")
    Local $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", 0, _
            "ptr", DllStructGetPtr($strc))
    If @error Or Not $a_Call[0] Then
        Return SetError(1, 0, "") ; error calculating the length of the buffer needed
    EndIf
    Local $a = DllStructCreate("char[" & DllStructGetData($strc, 1) & "]")
    $a_Call = DllCall("Crypt32.dll", "int", "CryptBinaryToString", _
            "ptr", DllStructGetPtr($struct), _
            "int", DllStructGetSize($struct), _
            "int", 1, _
            "ptr", DllStructGetPtr($a), _
            "ptr", DllStructGetPtr($strc))
    If @error Or Not $a_Call[0] Then
        Return SetError(2, 0, ""); error encoding
    EndIf
    Return DllStructGetData($a, 1)
EndFunc

;#######################################################################
;-----------------------------------------------------------------------
;		MyErrFunc - Custom Error handler for COM interaction
;-----------------------------------------------------------------------
Func MyErrFunc()
	Local $error
	If hex($oMyError.number,8) <> "80020009" And hex($oMyError.number,8) <> "80020006" Then
		$error = "COM Error !"    & @CRLF  & @CRLF & _
		"err.description is: " & @TAB & $oMyError.description  & @CRLF & _
		"err.windescription:"   & @TAB & $oMyError.windescription & @CRLF & _
		"err.number is: "       & @TAB & hex($oMyError.number,8)  & @CRLF & _
		"err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
		"err.scriptline is: "   & @TAB & $oMyError.scriptline   & @CRLF & _
		"err.source is: "       & @TAB & $oMyError.source       & @CRLF & _
		"err.helpfile is: "       & @TAB & $oMyError.helpfile     & @CRLF & _
		"err.helpcontext is: " & @TAB & $oMyError.helpcontext & @CRLF
		FileWrite(@ScriptDir&"\error.log", $error)
	EndIf
Endfunc

;#######################################################################
;-----------------------------------------------------------------------
;		HTTPCookieJar -
;-----------------------------------------------------------------------
;Returns an array containing url cookies.  $aCookies[0] will contain total number of cookies
;Requieres Global $aHTTPCookieJar[1][4]
;Set $ResponseHeader to "Purge" to clear all cookies for a domain
Func HTTPCookieJar($url, $ResponseHeader = "")
	Local $aCookies[1], $Domain, $Scope, $OkToAdd = 1
	If StringInStr($url, "/") Then
		$Domain = StringTrimLeft($url, StringInStr($url, "//")+1)
		$Domain = StringLeft($Domain, StringInStr($Domain, "/", 0, 1, 8)-1)
	Else
		$Domain = $url
	EndIf
	;Example header
;token=75b335187f139fbc898dba34ce527143de2a39ea7bc5fbe6; path=/; expires=Sun, 17-Jan-2038 13:17:07 GMT; secure; HttpOnly
	;$aHTTPCookieJar[0][0] = Record count

	If $ResponseHeader <> "" Then
		If $ResponseHeader = "Purge" Then ;Clear all cookies for domain
			If $aHTTPCookieJar[0][0] = "" Then $aHTTPCookieJar[0][0] = 0
			If $aHTTPCookieJar[0][0] > 0 Then
				For $a = 1 To $aHTTPCookieJar[0][0] ;Row X Column
					UBound($aHTTPCookieJar)
					If $a < UBound($aHTTPCookieJar) Then
						If $aHTTPCookieJar[$a][0] = $Domain Then
							_ArrayDelete($aHTTPCookieJar, $a)
							$aHTTPCookieJar[0][0]-=1
						EndIf
					EndIf
				Next
			EndIf
		Else ;Store cookies
			$OkToAdd = 1
			If $aHTTPCookieJar[0][0] > 0 Then
				For $a = 1 To $aHTTPCookieJar[0][0]
					If $aHTTPCookieJar[$a][0] = $Domain Then
						If $aHTTPCookieJar[$a][2] = StringLeft($ResponseHeader, StringInStr($ResponseHeader, "=")-1) Then $OkToAdd = 0
					EndIf
				Next
			EndIf
			If $OkToAdd = 1 Then
				$aHTTPCookieJar[0][0]+=1
				ReDim $aHTTPCookieJar[$aHTTPCookieJar[0][0]+1][4]
				$aHTTPCookieJar[$aHTTPCookieJar[0][0]][0] = $Domain ;$aHTTPCookieJar[0][0] = Domain
				$aHTTPCookieJar[$aHTTPCookieJar[0][0]][1] = StringFetch($ResponseHeader, "path=", ";", 0, 1) ;$aHTTPCookieJar[0][1] = Scope
				$aHTTPCookieJar[$aHTTPCookieJar[0][0]][2] = StringLeft($ResponseHeader, StringInStr($ResponseHeader, "=")-1) ;$aHTTPCookieJar[0][2] = Cookie Name
				$aHTTPCookieJar[$aHTTPCookieJar[0][0]][3] = StringFetch($ResponseHeader, "=", ";", 0, 1);$aHTTPCookieJar[0][3] = Cookie Value
			EndIf
		EndIf
	Else ;Retrive cookies
		$aCookies[0] = 0
		If $aHTTPCookieJar[0][0] > 0 Then
			For $a = 1 To $aHTTPCookieJar[0][0]
				If $aHTTPCookieJar[$a][0] = $Domain Then
					$aCookies[0]+=1
					ReDim $aCookies[$aCookies[0]+1]
					$aCookies[$aCookies[0]] = $aHTTPCookieJar[$a][2]&"="&$aHTTPCookieJar[$a][3]
				EndIf
			Next
		EndIf
		Return $aCookies
	EndIf
EndFunc

;#######################################################################
;-----------------------------------------------------------------------
;		HTTP_Request - HTTP_Request("                              ", "password=admin&seq=2811&login=admin", "", "", "127.0.0.1:8080")
;-----------------------------------------------------------------------
Func HTTP_Request($url, $PostBody = "", $UserName = "", $Password = "", $UserAgent = "", $ContentType = "", $AcceptType = "", $Proxy = "", $RequestType = "")
	const $SslErrorIgnoreFlagsOption = 4 ;Ignore Certificate errors
	const $IgnoreAll = 13056
	Local $aResponse[3], $aCookies[1], $oHTTP, $BaseUrl = $url

	;Perform some URL encoding                                                
	$url = StringReplace($url, " ", "+")
	$url = StringReplace($url, "!", "%21")
	$url = StringReplace($url, '"', "%22")
	$url = StringReplace($url, "#", "%23")
	$url = StringReplace($url, "$", "%24")
	$url = StringReplace($url, "&", "%26")
	$url = StringReplace($url, "'", "%27")
	$url = StringReplace($url, "(", "%28")
	$url = StringReplace($url, ")", "%29")

	If $ContentType = "" Then $ContentType = "text/plain"
	If $UserAgent = "" Then $UserAgent = "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10 (.NET CLR 4.0.20506)"

	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.SetTimeouts(30000, 30000, 30000, 30000)
	If $RequestType <> "" Then
		$oHTTP.Open($RequestType, $url, False)
	Else
		If $PostBody <> "" Then
			$oHTTP.Open("POST", $url, False)
		Else
			$oHTTP.Open("GET", $url, False)
		EndIf
	EndIf
	$oHTTP.SetRequestHeader("User-Agent", $UserAgent)
	$oHTTP.SetRequestHeader("Content-Type", $ContentType) ;Example "application/json"
	If $AcceptType <> "" Then $oHTTP.SetRequestHeader("Accept", $AcceptType) ;Example "application/json"
	If $UserName <> "" Then ;Basic Auth
		$Base64AuthString = _Base64Encode($UserName&":"&$Password)
		$oHTTP.SetRequestHeader("Authorization", "Basic "&$Base64AuthString)
	EndIf
	$aCookies = HTTPCookieJar($BaseUrl)
	If $aCookies[0] > 0 Then
		For $a = 1 To $aCookies[0]
			$oHTTP.SetRequestHeader("Cookie", $aCookies[$a])
		Next
	EndIf
	If $Proxy <> "" Then $oHTTP.SetProxy(2, $Proxy)
	$oHTTP.Option($SslErrorIgnoreFlagsOption) = $IgnoreAll
	$oHTTP.Send($PostBody)
	$oHTTP.WaitForResponse
	$aResponse[1] = $oHTTP.getAllResponseHeaders()  ;Full Response Header
	$aResponse[0] = $oHTTP.Status 					;Response Code
    $aResponse[2] = $oHTTP.ResponseText				;Response Body
	If StringInStr($aResponse[1], "Set-Cookie") Then HTTPCookieJar($BaseUrl, $oHTTP.getResponseHeader("Set-Cookie"))
	$aResponse[2] = HTMLUnescape($aResponse[2])
	Return $aResponse
EndFunc

;#######################################################################
;-----------------------------------------------------------------------
;		StringFetch - better string between
;-----------------------------------------------------------------------
;$c_String - String to search
;$c_StringSearchA - Starting value (start search at)
;$c_StringSearchB - End value (stop search at)
;$i_InstrCaseSense - [optional] 0 = not case sensitive, 1 = case sensitive
;$i_InstrOccurrence - [optional] Which occurrence of the substring to find
;$i_InstrStart - [optional] The starting position of the search
;$i_InstrCount - [optional] The number of characters to search. This effectively limits the search to a portion of the full string.
Func StringFetch($c_String,$c_StringSearchA,$c_StringSearchB,$i_InstrCaseSense=0,$i_InstrOccurrence=1,$i_InstrStart=1,$i_InstrCount=50000)
    Local $c_StringASize=StringLen($c_StringSearchA)
    If $i_InstrStart=False Then $c_StringASize=1
	If StringInStr($c_String,$c_StringSearchA,$i_InstrCaseSense,$i_InstrOccurrence,$i_InstrStart,$i_InstrCount) <> 0 And _
	StringInStr($c_String,$c_StringSearchB,$i_InstrCaseSense,$i_InstrOccurrence,$i_InstrStart,$i_InstrCount) <> 0 Then
		Return StringMid($c_String,StringInStr($c_String,$c_StringSearchA,$i_InstrCaseSense,$i_InstrOccurrence,$i_InstrStart,$i_InstrCount) _
		+$c_StringASize,StringInStr($c_String,$c_StringSearchB,$i_InstrCaseSense,$i_InstrOccurrence,StringInStr($c_String,$c_StringSearchA),$i_InstrCount) _
		-(StringInStr($c_String,$c_StringSearchA,$i_InstrCaseSense,$i_InstrOccurrence,$i_InstrStart,$i_InstrCount)+$c_StringASize))
	Else
		Return "0"
	EndIf
EndFunc