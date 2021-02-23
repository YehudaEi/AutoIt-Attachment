Func _MediaWiki_Edit($site, $loginCookies, $token, $pageName, $text, $pra = "", $section = "", $summary="", $captcha = "")
	If Not IsString($token) Or Not IsString($pageName) Or Not IsString($text) Or Not IsString($pra) Or Not IsString($section) Or Not IsString($summary) Then
		SetError(1)
		Return ""
	EndIf
	If $pra = "append" Or $pra = "prepend" Or $pra = "" Then
	Else
		SetError(1)
		Return ""
	EndIf
	Local $argumentArray = ___MediaWiki_Edit_Set1($pageName, $section, $summary, $pra, $text, $token)
	Local $xml = __winhttprequest($site, True, $argumentArray, $loginCookies)
	If __extractXMLAttribute($xml, "result") <> "Success" Then
		SetError(2)
		Return ""
	EndIf
	Return 1
EndFunc   ;==>_MediaWiki_Edit

Func _MediaWiki_GetToken($site, $loginCookies, $pageName = "Main Page")
	If Not IsString($site) Or Not IsArray($loginCookies) Or Not IsString($pageName) Then
		SetError(1)
		Return ""
	EndIf
	Local $argumentArray = ___MediaWiki_GetToken_Set1($pageName)
	Local $xml = __winhttprequest($site, False, $argumentArray, $loginCookies)
	Local $out = __extractXMLAttribute($xml, "edittoken")
	If @error = 1 Then
		SetError(2)
		Return ""
	EndIf
	If $out = "+\" Then
		SetError(3)
		Return ""
	EndIf
	Return $out
EndFunc   ;==>_MediaWiki_GetToken

Func _MediaWiki_Logout($site, $loginCookies)
	Local $argumentArray[1][2]
	$argumentArray[0][0] = "action"
	$argumentArray[0][0] = "logout"
	__winhttprequest($site, False, $loginCookies, $argumentArray)
EndFunc   ;==>_MediaWiki_Logout

Func _MediaWiki_Login($site, $user, $pass)
	If Not IsString($user) Or Not IsString($pass) Or Not IsString($site) Then
		SetError(1)
		Return ""
	EndIf
	Local $argumentArray = ___MediaWiki_Login_Set1($user, $pass)
	Local $xml = __winhttprequest($site, True, $argumentArray)
	If @error = 1 Then
		SetError(2)
		Return ""
	EndIf
	Local $cookieprefix = __extractXMLAttribute($xml, "cookieprefix")
	Local $cookieArray = ___MediaWiki_Login_Set2($cookieprefix, $xml, $argumentArray)
	$xml = __winhttprequest($site, True, $argumentArray, $cookieArray)
	If __extractXMLAttribute($xml, "result") <> "Success" Then
		SetError(3)
		Return $result
	EndIf
	$out = ___MediaWiki_Login_Set3($cookieprefix, $xml, $cookieArray)
	Return $out
EndFunc   ;==>_MediaWiki_Login

;Low level functions... String & Array processing + actual HTTP requests, not for outside use!

Func __extractXMLAttribute($xml, $att)
	Local $out = ""
	$out = StringRegExp($xml, $att & '="([^"]*)"', 1)
	If @error = 1 Then
		SetError(1)
		Return ""
	EndIf
	Return $out[0]
EndFunc

Func __dataEncode($varsArray, $separator)
	If Not IsArray($varsArray) Then
		SetError(1)
		Return ""
	EndIf
	Local $out = "";
	For $key = 0 To UBound($varsArray) - 1
		If $varsArray[$key][0] <> "" Then
			$out = $out & $varsArray[$key][0] & "=" & __URLEncode($varsArray[$key][1]) & $separator
		EndIf
	Next
	$out = StringMid($out, 1, StringLen($out) - StringLen($separator))
	Return $out
EndFunc

Func __URLEncode($urlText) ;Credit to unknown author, referenced from a post by KaFu at http://www.autoitscript.com/forum/topic/95850-url-encoding/
	Local $url = ""
    For $i = 1 To StringLen($urlText)
        Local $acode = Asc(StringMid($urlText, $i, 1))
        Select
            Case ($acode >= 48 And $acode <= 57) Or _
                    ($acode >= 65 And $acode <= 90) Or _
                    ($acode >= 97 And $acode <= 122)
                $url = $url & StringMid($urlText, $i, 1)
            Case $acode = 32
                $url = $url & "+"
            Case Else
                $url = $url & "%" & Hex($acode, 2)
        EndSelect
    Next
	Return $url
EndFunc

Func __winhttprequest($url, $isPost, $data = "", $cookies = "", $customHeaderName = "", $customHeaderValue = "")
	Local $http = ObjCreate("winhttp.winhttprequest.5.1")
	If $isPost Then
		$http.Open("POST", $url, False)
		$http.SetRequestHeader("Content-Type", "application/x-www-form-urlencoded")
	Else
		$http.Open("GET", $url & "?" & __dataEncode($data, "&"), False)
	EndIf
	If $customHeaderName <> "" And $customHeaderValue <> "" Then
		$http.SetRequestHeader($customHeaderName, $customHeaderValue)
	EndIf
	$http.SetRequestHeader("User-Agent", "Benzrf's MediaWiki UDFs for AutoIt/0.1")
	If $cookies <> "" Then
		$http.SetRequestHeader("Cookie", __dataEncode($cookies, "; "))
	EndIf
	If $isPost Then
		$http.Send(__dataEncode($data, "&"))
	Else
		$http.Send()
	EndIf
	If StringMid(String($http.Status), 1, 1) = "2" Then
		Return $http.ResponseText
	Else
		SetError(1, $http.Status)
		Return ""
	EndIf
EndFunc

;Argument-array-setting functions... Not for outside use!

Func ___MediaWiki_Edit_Set1($pageName, $section, $summary, $pra, $text, $token)
	Local $argumentArray[8][2]
	$argumentArray[0][0] = "action"
	$argumentArray[0][1] = "edit"
	$argumentArray[1][0] = "title"
	$argumentArray[1][1] = $pageName
	$argumentArray[2][0] = "section"
	$argumentArray[2][1] = $section
	$argumentArray[3][0] = "summary"
	$argumentArray[3][1] = $summary
	$argumentArray[4][0] = $pra & "text"
	$argumentArray[4][1] = $text
	$argumentArray[5][0] = "bot"
	$argumentArray[5][1] = "true"
	$argumentArray[6][0] = "token"
	$argumentArray[6][1] = $token
	$argumentArray[7][0] = "format"
	$argumentArray[7][1] = "xml"
	Return $argumentArray
EndFunc

Func ___MediaWiki_GetToken_Set1($pageName)
	Local $argumentArray[5][2]
	$argumentArray[0][0] = "action"
	$argumentArray[0][1] = "query"
	$argumentArray[1][0] = "prop"
	$argumentArray[1][1] = "info"
	$argumentArray[2][0] = "intoken"
	$argumentArray[2][1] = "edit"
	$argumentArray[3][0] = "titles"
	$argumentArray[3][1] = $pageName
	$argumentArray[4][0] = "format"
	$argumentArray[4][1] = "xml"
	Return $argumentArray
EndFunc

Func ___MediaWiki_Login_Set1($user, $pass)
	Local $argumentArray[5][2]
	$argumentArray[0][0] = "action"
	$argumentArray[0][1] = "login"
	$argumentArray[1][0] = "lgname"
	$argumentArray[1][1] = $user
	$argumentArray[2][0] = "lgpassword"
	$argumentArray[2][1] = $pass
	$argumentArray[3][0] = "format"
	$argumentArray[3][1] = "xml"
	Return $argumentArray
EndFunc
Func ___MediaWiki_Login_Set2($cookieprefix, $xml, ByRef $argumentArray)
	Local $cookieArray[4][2]
	$cookieArray[0][0] = $cookieprefix & "_session"
	$cookieArray[0][1] = __extractXMLAttribute($xml, "sessionid")
	$argumentArray[4][0] = "lgtoken"
	$argumentArray[4][1] = __extractXMLAttribute($xml, "token")
	Return $cookieArray
EndFunc
Func ___MediaWiki_Login_Set3($cookieprefix, $xml, $cookieArray)
	$cookieArray[1][0] = $cookieprefix & "UserName"
	$cookieArray[1][1] = __extractXMLAttribute($xml, "lgusername")
	$cookieArray[2][0] = $cookieprefix & "UserID"
	$cookieArray[2][1] = __extractXMLAttribute($xml, "lguserid")
	$cookieArray[3][0] = $cookieprefix & "Token"
	$cookieArray[3][1] = __extractXMLAttribute($xml, "lgtoken")
	Return $cookieArray
EndFunc