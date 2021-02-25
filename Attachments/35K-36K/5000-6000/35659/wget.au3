#NoTrayIcon
#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=D:\wmi\icons\user_anonymous.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Comment=SPA
#AutoIt3Wrapper_Res_Description=Statistical Phish Analysis
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=MWTI
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3  -w 5 -w 6
#Tidy_Parameters=/gd
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinHttpConstants.au3>
#include "WinHttp.au3"
#include "Array.au3"
#include "string.au3"
#include "file.au3"
Opt("MustDeclareVars", 1)
; Initialize
Global Const $iSizeBufferAsync = 1048576 ; 1MB for example, should be enough
; The buffer
Global Static $tBufferAsync = DllStructCreate("byte[" & $iSizeBufferAsync & "]")
Global $path, $domain, $frame, $frame_array, $redirect, $browser_path_count = 0, $browser_domain
Global $other_domain[1][2]
Global $pBufferAsync
Global $hOpen
Global $hWINHTTP_STATUS_CALLBACK
Global $hConnect
Global $hRequest
Global $sData
Global $frame_recursive_count = 0
Global $meta_temp, $count_meta = 0
Global $result_log = ''
Global $count_server = 0
Global $F_url
Local $url

;~ If $cmdline[0] == 0 Or $cmdline[0] > 1 Then
;~ 	ConsoleWrite('Parameter expected url eg. "http://www.google.com" or "https://www.gmail.com/"' & @CRLF)
;~ Else
;~ 	If StringLower(StringLeft($cmdline[1], 7)) == 'http://' Or StringLower(StringLeft($cmdline[1], 8)) == 'https://' Then
;~ 		$F_url = $cmdline[1]
;~ 		$url = $F_url
;~ 		$url = StringMid($url, 1, StringInStr($url, '%23', -1) - 1)
;~ 		$url = StringMid($url, 1, StringInStr($url, '#', -1) - 1)
;~ 		Local $temp_array = __WinCrackUrl($url)
;~ 		$domain = $temp_array[2]
;~ 		$path = $temp_array[6] & $temp_array[7]
;~ 		$browser_domain = $domain
;~ 		ConsoleWrite('Checking : ' & $F_url & @CRLF)
;~ 		__WinHttpConnect($domain, $path)
;~ 		meta_refresh_redirect()
;~ 		frame_get()
;~ 	Else
;~ 		ConsoleWrite('Parameter expected url eg. "http://www.google.com" or "https://www.gmail.com/"' & @CRLF)
;~ 	EndIf
;~ EndIf

$url = 'https://' & 'www.gmail.com'
$F_url = $url
$url = StringMid($url, 1, StringInStr($url, '%23', -1) - 1)
$url = StringMid($url, 1, StringInStr($url, '#', -1) - 1)
ConsoleWrite('Checking : ' & $url & @CRLF)
Local $temp_array = __WinCrackUrl($url);#Itau_Seguranca
$domain = $temp_array[2]
$path = $temp_array[6] & $temp_array[7]
$browser_domain = $domain
__WinHttpConnect($domain, $path)
meta_refresh_redirect()
frame_get()
ConsoleWrite($sData)
Exit 7

Func __WinCrackUrl($curl)
	Local $curl_temp
	$curl = StringStripCR($curl)
	$curl = StringReplace($curl, @LF, '')
	$curl = StringStripWS($curl, 3)
	$curl_temp = _WinHttpCrackUrl($curl, $ICU_DECODE)
	Return $curl_temp
EndFunc   ;==>__WinCrackUrl

Func meta_refresh_redirect()
	Local $meta, $meta_array, $temp_array
	Local $replace = ''
	Local $script_header
	Local $meta_temp_temp
	$replace = StringMid($sData, StringInStr($sData, '<noscript>'), StringInStr($sData, '</noscript>'))
	If $replace <> '' Then
		$sData = StringReplace($sData, StringMid($sData, StringInStr($sData, '<noscript>'), StringInStr($sData, '</noscript>')), '')
	EndIf
	$meta = IniRead('wget.ini', 'reg', 'meta_tag', '')
	$meta_array = StringRegExp($sData, $meta, 3)

	If IsArray($meta_array) And StringLower(StringLeft($meta_temp, 7)) == 'http://' And $count_meta < UBound($meta_array) And $count_meta < 10 Then
		$script_header = StringMid($sData, StringInStr($sData, '<head>'), StringInStr($sData, '</head>'))
		If StringInStr($script_header, '<script ') == 0 Then ; this looks good
			$meta_temp_temp = StringStripWS(StringMid($meta_array[$count_meta], StringInStr($meta_array[$count_meta], 'url=', 2) + 4), 8)
			If StringLower(StringLeft($redirect, 7)) == 'http://' Or StringLower(StringLeft($redirect, 8)) == 'https://' Then
				$meta_array[0] = abrel($redirect, $meta_temp_temp)
			Else
				$meta_array[0] = $meta_temp & $meta_temp_temp
			EndIf
			$meta_temp = $meta_array[0]
			$redirect = $meta_array[0]
			$count_meta += 1

			$temp_array = __WinCrackUrl($meta_array[0])
			$domain = $temp_array[2]
			$path = $temp_array[6] & $temp_array[7]
			$browser_domain = $domain
			__CWriteRes('MetaTag REDIRECTING to:' & @CRLF & $redirect & @CRLF)
			__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
			meta_refresh_redirect()
		Else
			$script_header = StringMid($sData, StringInStr($sData, '<head>'), StringInStr($sData, '</head>'))
			If StringInStr($meta_array[$count_meta], 'url=', 2) <> 0 Then
				$meta_array[0] = StringStripWS(StringMid($meta_array[$count_meta], StringInStr($meta_array[$count_meta], 'url=', 2) + 4), 8)
				If StringLower(StringLeft($meta_array[0], 7)) == 'http://' Or StringLower(StringLeft($meta_array[0], 8)) == 'https://' Then
					$meta_temp = $meta_array[0]
					$redirect = $meta_array[0]
				Else
					$meta_temp = abrel('http://' & $domain & $path, $meta_array[0])
					$meta_array[0] = $meta_temp
					$redirect = $meta_array[0]
				EndIf
				$temp_array = __WinCrackUrl($meta_array[0])
				$domain = $temp_array[2]
				$path = $temp_array[6] & $temp_array[7]
				$browser_domain = $domain
				If StringInStr($script_header, 'self.location.replace(') Then
					$redirect = $meta_array[0]
					$count_meta += 1
					$temp_array = __WinCrackUrl($meta_array[0])
					$domain = $temp_array[2]
					$path = $temp_array[6] & $temp_array[7]
					$browser_domain = $domain
					__CWriteRes('MtJ=2' & @CRLF)
					__CWriteRes('MetaTag REDIRECTING to:' & @CRLF & $redirect & @CRLF)
					__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
					meta_refresh_redirect()
				Else
					$count_meta += 1
					__CWriteRes('Mt=3' & @CRLF)
					__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
					meta_refresh_redirect()
				EndIf
				$count_meta += 1
			EndIf
		EndIf
	ElseIf IsArray($meta_array) And StringLower(StringLeft($meta_temp, 7)) <> 'http://' And $count_meta < UBound($meta_array) Then
		$script_header = StringMid($sData, StringInStr($sData, '<head>'), StringInStr($sData, '</head>'))
		If StringInStr($meta_array[$count_meta], 'url=', 2) <> 0 Then
			$meta_array[0] = StringStripWS(StringMid($meta_array[$count_meta], StringInStr($meta_array[$count_meta], 'url=', 2) + 4), 8)
			If StringLower(StringLeft($meta_array[0], 7)) == 'http://' Or StringLower(StringLeft($meta_array[0], 8)) == 'https://' Then
				$meta_temp = $meta_array[0]
				$redirect = $meta_array[0]
			Else
				$meta_temp = abrel('http://' & $domain & $path, $meta_array[0])
				$meta_array[0] = $meta_temp
				$redirect = $meta_array[0]
			EndIf
			$temp_array = __WinCrackUrl($meta_array[0])
			$domain = $temp_array[2]
			$path = $temp_array[6] & $temp_array[7]
			$browser_domain = $domain
			If StringInStr(StringMid($sData, StringInStr($sData, '<head>'), StringInStr($sData, '</head>')), '<script ') == 0 Then
				$count_meta += 1
				__CWriteRes('MetaTag Noscript REDIRECTING to:' & @CRLF & $redirect & @CRLF)
				__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
				meta_refresh_redirect()
			Else
				If StringInStr($script_header, 'self.location.replace(') Then
					$redirect = $meta_array[0]
					$count_meta += 1
					$temp_array = __WinCrackUrl($meta_array[0])
					$domain = $temp_array[2]
					$path = $temp_array[6] & $temp_array[7]
					$browser_domain = $domain
					__CWriteRes('MtJ=1' & @CRLF)
					__CWriteRes('MetaTag JS REDIRECTING to:' & @CRLF & $redirect & @CRLF)
					__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
					meta_refresh_redirect()
				Else
					$meta_temp_temp = $meta_array[$count_meta];StringStripWS(StringMid($meta_array[$count_meta], StringInStr($meta_array[$count_meta], 'url=', 2) + 4), 8)
					If StringLower(StringLeft($redirect, 7)) == 'http://' Or StringLower(StringLeft($redirect, 8)) == 'https://' Then
						$meta_array[0] = $meta_temp_temp
					Else
						$meta_array[0] = $meta_temp & $meta_temp_temp
					EndIf
					$meta_temp = $meta_array[0]
					$redirect = $meta_array[0]
					$count_meta += 1
					$temp_array = __WinCrackUrl($meta_array[0])
					$domain = $temp_array[2]
					$path = $temp_array[6] & $temp_array[7]
					$browser_domain = $domain
					__CWriteRes('MtJ=20' & @CRLF)
					__CWriteRes('MetaTag REDIRECTING to:' & @CRLF & $redirect & @CRLF)
					__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
					meta_refresh_redirect()
				EndIf
			EndIf
			$count_meta += 1
		EndIf
	Else
	EndIf
EndFunc   ;==>meta_refresh_redirect

;~ ******************************************

Func frame_get()
	$frame = IniRead('wget.ini', 'reg', 'frame_src', '')
	$frame_array = StringRegExp($sData, $frame, 3)
	$frame_array = urlrecognise($frame_array)
	If $frame_recursive_count < UBound($frame_array) Then
		Local $temp_array = __WinCrackUrl($frame_array[$frame_recursive_count])
		$frame_recursive_count += 1
		__CWriteRes('Downloading Frame : ' & $temp_array[2] & $temp_array[6] & $temp_array[7] & @CRLF)
		__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
		frame_get()
	EndIf
EndFunc   ;==>frame_get

Func script_get()
	Local $script, $script_array, $script_count
	Local $temp_array
	$script = IniRead('wget.ini', 'reg', 'script_src', '')
	$script_array = StringRegExp($sData, $script, 3)
	$script_array = url_action($script_array)
	$script_count = 0
	While $script_count < UBound($script_array)
		$temp_array = __WinCrackUrl($script_array[$script_count])
		$script_count += 1
		__CWriteRes('Downloading Script : ' & $temp_array[2] & $temp_array[6] & $temp_array[7] & @CRLF)
		__WinHttpConnect($temp_array[2], $temp_array[6] & $temp_array[7])
	WEnd
EndFunc   ;==>script_get

Func __CWriteRes($data)
	$result_log &= $data
	ConsoleWrite($data)
EndFunc   ;==>__CWriteRes

;~ ******************************************
Func url_action($url_array)
	Local $arraysize, $count, $browser_path
	$url_array = _ArrayUnique($url_array)
	_ArrayDelete($url_array, 0)
	$arraysize = UBound($url_array)
	If $redirect <> '' Then
		If StringLower(StringLeft($redirect, 7)) == 'http://' Or StringLower(StringLeft($redirect, 8)) == 'https://' Then
			If StringInStr($redirect, '/', 1, 3) <> 0 Then
				$browser_path = $redirect
				$browser_domain = __WinCrackUrl($redirect)
				$browser_domain = $browser_domain[2]
			Else
				$browser_path = $redirect
				$browser_domain = __WinCrackUrl($redirect)
				$browser_domain = $browser_domain[2]
			EndIf
		Else
			$browser_path = 'http://' & $domain & StringMid($path, 1, StringInStr($path, '/', 2, -1))
			$browser_path = abrel($browser_path, $redirect)
			$browser_domain = __WinCrackUrl($browser_path)
			$browser_domain = $browser_domain[2]
		EndIf
	Else
		$browser_path = 'http://' & $domain & StringMid($path, 1, StringInStr($path, '/', 2, -1))
		$browser_domain = $domain
	EndIf

	$arraysize = UBound($url_array)
	For $count = $arraysize - 1 To 0 Step -1
		$url_array[$count] = StringStripWS(StringReplace($url_array[$count], '"', ''), 8)
		$url_array[$count] = StringStripWS(StringReplace($url_array[$count], "'", ''), 8)

		Select
			Case StringInStr(StringStripWS($url_array[$count], 8), 'http://', 2) == 1

			Case StringInStr(StringStripWS($url_array[$count], 8), 'https://', 2) == 1

			Case StringLeft(StringStripWS($url_array[$count], 8), 2) == '//'
				If _ArraySearch($url_array, 'http:' & $url_array[$count]) == -1 Then
					$url_array[$count] = 'http:' & $url_array[$count]
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 1) == '/' ;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 1)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ;$browser_path & StringTrimLeft($url_array[$count], 1)
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 3) == '../' ;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 3)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ;$browser_path & StringTrimLeft($url_array[$count], 3)
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 3) == './' And StringLen(StringStripWS($url_array[$count], 8)) > 2;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 2)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ;$browser_path & StringTrimLeft($url_array[$count], 2)
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
				EndIf
			Case Else
				If _ArraySearch($url_array, $browser_path & StringStripWS($url_array[$count], 8)) == -1 Then
					If StringRight($browser_path, 1) <> '/' Then
						$url_array[$count] = $browser_path & '/' & $url_array[$count]
					Else
						If $url_array[$count] <> '' Then
							$url_array[$count] = $browser_path & $url_array[$count]
						Else
							$arraysize = _ArrayDelete($url_array, $count)
							$arraysize -= 1
						EndIf
					EndIf
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
				EndIf
		EndSelect
	Next
	$url_array = _ArrayUnique($url_array)
	_ArrayDelete($url_array, 0)
	Return $url_array
EndFunc   ;==>url_action

Func urlrecognise($url_array)
	Local $arraysize, $count, $browser_path, $temp
	$url_array = _ArrayUnique($url_array)
	_ArrayDelete($url_array, 0)
	$arraysize = UBound($url_array)
	If $redirect <> '' Then
		If StringLower(StringLeft($redirect, 7)) == 'http://' Or StringLower(StringLeft($redirect, 8)) == 'https://' Then
			If StringInStr($redirect, '/', 1, 3) <> 0 Then
;~ 				$browser_path = StringMid($redirect, 1, StringInStr($redirect, '/', 1, 3))
				$browser_path = $redirect
				$browser_domain = __WinCrackUrl($redirect)
				$browser_domain = $browser_domain[2]

			Else
				$browser_path = $redirect
				$browser_domain = __WinCrackUrl($redirect)
				$browser_domain = $browser_domain[2]
			EndIf
		Else
			$browser_path = 'http://' & $domain & StringMid($path, 1, StringInStr($path, '/', 2, -1))
			$browser_domain = $domain
		EndIf
	Else
		$browser_path = 'http://' & $domain & StringMid($path, 1, StringInStr($path, '/', 2, -1))
		$browser_domain = $domain
	EndIf
	For $count = $arraysize - 1 To 0 Step -1
		$url_array[$count] = StringReplace($url_array[$count], '"', '')
		$url_array[$count] = StringReplace($url_array[$count], "'", '')
		$url_array[$count] = StringReplace($url_array[$count], "www.", '')
		Select
			Case StringInStr(StringStripWS($url_array[$count], 8), 'http://', 2) == 1
				$temp = __WinCrackUrl($url_array[$count])
				If IsArray($temp) == 0 Then

				Else
					If StringInStr($temp[2], $browser_domain, 2) == 1 Then
						$browser_path_count += 1
					Else
						If _ArraySearch($other_domain, $temp[2]) == -1 Then
							ReDim $other_domain[UBound($other_domain, 1) + 1][2]
							$other_domain[UBound($other_domain, 1) - 1][0] = $temp[2]
							$other_domain[UBound($other_domain, 1) - 1][1] = 1
						Else
							$other_domain[_ArraySearch($other_domain, $temp[2])][1] += 1
						EndIf
					EndIf
				EndIf
			Case StringInStr(StringStripWS($url_array[$count], 8), 'https://', 2) == 1
				$temp = __WinCrackUrl($url_array[$count])
				If IsArray($temp) == 1 Then
					If StringInStr($temp[2], $browser_domain, 2) == 1 Then
						$browser_path_count += 1
					Else
						If _ArraySearch($other_domain, $temp[2]) == -1 Then
							ReDim $other_domain[UBound($other_domain, 1) + 1][2]
							$other_domain[UBound($other_domain, 1) - 1][0] = $temp[2]
							$other_domain[UBound($other_domain, 1) - 1][1] = 1
						Else
							$other_domain[_ArraySearch($other_domain, $temp[2])][1] += 1
						EndIf
					EndIf
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 2) == '//'
				If _ArraySearch($url_array, 'http:' & $url_array[$count]) == -1 Then
					$url_array[$count] = 'http:' & $url_array[$count]
					$browser_path_count += 1
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
;~ 					$count += 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 1) == '/' ;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 1)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ; $browser_path & StringTrimLeft($url_array[$count], 1)
					$browser_path_count += 1
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
;~ 					$count += 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 3) == '../' ;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 3)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ;$browser_path & StringTrimLeft($url_array[$count], 3)
					$browser_path_count += 1
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
;~ 					$count += 1
				EndIf
			Case StringLeft(StringStripWS($url_array[$count], 8), 3) == './' And StringLen(StringStripWS($url_array[$count], 8)) > 2 ;relative path
				If _ArraySearch($url_array, $browser_path & StringTrimLeft($url_array[$count], 2)) == -1 Then
					$url_array[$count] = abrel($browser_path, $url_array[$count]) ;$browser_path & StringTrimLeft($url_array[$count], 2)
					$browser_path_count += 1
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
;~ 					$count += 1
				EndIf
			Case Else
				If _ArraySearch($url_array, $browser_path & StringStripWS($url_array[$count], 8)) == -1 Then
					If StringRight($browser_path, 1) <> '/' Then
						$url_array[$count] = $browser_path & '/' & $url_array[$count]
						$browser_path_count += 1
					Else
						If $url_array[$count] <> '' Then
							$url_array[$count] = $browser_path & $url_array[$count]
							$browser_path_count += 1
						Else
							$arraysize = _ArrayDelete($url_array, $count)
							$arraysize -= 1
						EndIf
					EndIf
				Else
					$arraysize = _ArrayDelete($url_array, $count)
					$arraysize -= 1
;~ 					$count += 1
				EndIf
		EndSelect
	Next
	$url_array = _ArrayUnique($url_array)
	_ArrayDelete($url_array, 0)
	Return $url_array
EndFunc   ;==>urlrecognise

;~ ******************************************

Func __WINHTTP_STATUS_CALLBACK($hInternet, $iContext, $iInternetStatus, $pStatusInformation, $iStatusInformationLength)
	#forceref $hInternet, $iContext, $pStatusInformation, $iStatusInformationLength
	Local $sStatus
	Switch $iInternetStatus
		Case $WINHTTP_CALLBACK_STATUS_CLOSING_CONNECTION
			$sStatus = ">> Closing the connection to the server" & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_CONNECTED_TO_SERVER
			$sStatus = ">> Successfully connected to the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_CONNECTING_TO_SERVER
			$sStatus = ">> Connecting to the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_CONNECTION_CLOSED
			$sStatus = ">> Successfully closed the connection to the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_DATA_AVAILABLE
			$sStatus = ">> Data is available to be retrieved with WinHttpReadData." & @CRLF
			__CWriteRes($sStatus & @CRLF)
			__CWriteRes(_WinHttpQueryHeaders($hInternet) & @CRLF)
			_WinHttpSimpleReadDataAsync($hInternet, $pBufferAsync, $iSizeBufferAsync)
			Return
		Case $WINHTTP_CALLBACK_STATUS_HANDLE_CREATED
			$sStatus = ">> An HINTERNET handle has been created: " & $hInternet & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_HANDLE_CLOSING
			$sStatus = ">> This handle value has been terminated: " & $hInternet & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_HEADERS_AVAILABLE
			$sStatus = ">> The response header has been received and is available with WinHttpQueryHeaders." & @CRLF
			__CWriteRes($sStatus & @CRLF)
			__CWriteRes(_WinHttpQueryHeaders($hInternet) & @CRLF)
			_WinHttpQueryDataAvailable($hInternet)
			Return
		Case $WINHTTP_CALLBACK_STATUS_INTERMEDIATE_RESPONSE
			$sStatus = ">> Received an intermediate (100 level) status code message from the server."
		Case $WINHTTP_CALLBACK_STATUS_NAME_RESOLVED
			$sStatus = ">> Successfully found the IP address of the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_READ_COMPLETE
			$sStatus = ">> Data was successfully read from the server." & @CRLF
			__CWriteRes($sStatus & @CRLF)
			Local $sRead = DllStructGetData(DllStructCreate("char[" & $iStatusInformationLength & "]", $pStatusInformation), 1)
			__CWriteRes($sRead & @CRLF)
			Return
		Case $WINHTTP_CALLBACK_STATUS_RECEIVING_RESPONSE
;~             $sStatus = ">> Waiting for the server to respond to a request."&@CRLF
		Case $WINHTTP_CALLBACK_STATUS_REDIRECT
			$sStatus = ">> An HTTP request is about to automatically redirect the request." & @CRLF
			$redirect = _WinHttpQueryHeaders($hInternet)
			$redirect = StringStripCR(StringMid($redirect, StringInStr($redirect, 'Location: ', 2) + StringLen('Location: ')))
			$redirect = StringStripWS(StringMid($redirect, 1, StringInStr($redirect, @LF, 2, 1)), 8)
			__CWriteRes('Server Header REDIRECTING to :' & @CRLF & $redirect & @CRLF)
			$count_server += 1
		Case $WINHTTP_CALLBACK_STATUS_REQUEST_ERROR
			$sStatus = ">> An error occurred while sending an HTTP request." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_REQUEST_SENT
;~             $sStatus = ">> Successfully sent the information request to the server."&@CRLF
		Case $WINHTTP_CALLBACK_STATUS_RESOLVING_NAME
			$sStatus = ">> Looking up the IP address of a server name." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_RESPONSE_RECEIVED
;~             $sStatus = ">> Successfully received a response from the server."&@CRLF
		Case $WINHTTP_CALLBACK_STATUS_SECURE_FAILURE
			$sStatus = ">> One or more errors were encountered while retrieving a Secure Sockets Layer (SSL) certificate from the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_SENDING_REQUEST
			$sStatus = ">> Sending the information request to the server." & @CRLF
		Case $WINHTTP_CALLBACK_STATUS_SENDREQUEST_COMPLETE
			$sStatus = ">> The request completed successfully." & @CRLF
			__CWriteRes($sStatus & @CRLF)
			_WinHttpReceiveResponse($hInternet)
			Return
		Case $WINHTTP_CALLBACK_STATUS_WRITE_COMPLETE
			$sStatus = ">> Data was successfully written to the server." & @CRLF
	EndSwitch
EndFunc   ;==>__WINHTTP_STATUS_CALLBACK

;~ ******************************************

Func hextostring($sString)
	$sString = StringLower($sString)
	$sString = StringReplace($sString, '%3a', ':', 0, 2)
	$sString = StringReplace($sString, '%3b', ';', 0, 2)
	$sString = StringReplace($sString, '%3c', '<', 0, 2)
	$sString = StringReplace($sString, '%3d', '=', 0, 2)
	$sString = StringReplace($sString, '%3e', '>', 0, 2)
	$sString = StringReplace($sString, '%3f', '?', 0, 2)
	$sString = StringReplace($sString, '%20', ' ', 0, 2)
	$sString = StringReplace($sString, '%21', '!', 0, 2)
	$sString = StringReplace($sString, '%22', '"', 0, 2)
	$sString = StringReplace($sString, '%23', '#', 0, 2)
	$sString = StringReplace($sString, '%26', '&', 0, 2)
	$sString = StringReplace($sString, '%27', "'", 0, 2)
	$sString = StringReplace($sString, '%28', '(', 0, 2)
	$sString = StringReplace($sString, '%29', ')', 0, 2)
	$sString = StringReplace($sString, '%2c', ',', 0, 2)
	$sString = StringReplace($sString, '%2f', '/', 0, 2)
	$sString = StringReplace($sString, '%7E', '(', 0, 2)
	$sString = StringReplace($sString, '%25', '%', 0, 2)
	$sString = StringReplace($sString, '%3B', ';', 0, 2)
	$sString = StringReplace($sString, '><', '>' & @CRLF & '<', 0, 2)
	$sString = StringReplace($sString, ';', ';' & @CRLF, 0, 2)
	Return $sString
EndFunc   ;==>hextostring

;~ ******************************************

Func __WinHttpConnect($ldomain, $lpath)
	Local $sChunk
	$pBufferAsync = DllStructGetPtr($tBufferAsync)
	$hWINHTTP_STATUS_CALLBACK = DllCallbackRegister("__WINHTTP_STATUS_CALLBACK", "none", "handle;dword_ptr;dword;ptr;dword")
	$hOpen = _WinHttpOpen()
	If @error Then
		__CWriteRes("Error initializing the usage of WinHTTP functions." & @CRLF)
		__WinhttpClose()
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
;~ 		Exit 1
	EndIf
	_WinHttpSetTimeouts($hOpen,5000,5000,5000,5000)
	_WinHttpSetStatusCallback($hOpen, $hWINHTTP_STATUS_CALLBACK)
	$hConnect = _WinHttpConnect($hOpen, $ldomain)
	If @error Then
		__CWriteRes("Error specifying the initial target server of an HTTP request." & @CRLF)
		__WinhttpClose()
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
		Return
;~ 		Exit 2
	EndIf
	$hRequest = _WinHttpOpenRequest($hConnect, 'Get', $lpath) ;path
	If @error Then
		__CWriteRes("Error creating an HTTP request handle." & @CRLF)
		__WinhttpClose()
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
		Return
;~ 		Exit 3
	EndIf
	_WinHttpAddRequestHeaders($hRequest, "Accept: text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8")
	_WinHttpAddRequestHeaders($hRequest, "Accept-Language: en-us;q=0.5")
	_WinHttpAddRequestHeaders($hRequest, "Accept-Charset: ISO-8859-1,utf-8;q=0.7,*;q=0.7")
	_WinHttpAddRequestHeaders($hRequest, "Keep-Alive: 115")
	_WinHttpAddRequestHeaders($hRequest, "Connection: keep-alive")

	_WinHttpSendRequest($hRequest)
	If @error Then
		__CWriteRes("Error sending specified request." & @CRLF)
		__WinhttpClose()
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
		Return
;~ 		Exit 4
	EndIf
	_WinHttpReceiveResponse($hRequest)
	If @error Then
		__CWriteRes("Error waiting for the response from the server." & @CRLF)
		__WinhttpClose()
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
		Return
;~ 		Exit 5
	EndIf
	If _WinHttpQueryDataAvailable($hRequest) Then
		$sData &= @CRLF & '*****' & @CRLF & $ldomain & $lpath & @CRLF & '*****' & @CRLF
		While 1
			$sChunk = _WinHttpReadData($hRequest)
			If @error Then ExitLoop
			$sData &= $sChunk
		WEnd

		__WinhttpClose()
		Return ;$sData
	Else
		__WinhttpClose()
		__CWriteRes("Site is experiencing problems.")
		FileWriteLine('error.log', $F_url);& @CRLF & 'result=' & $result_log)
		Return
;~ 		Exit 6
	EndIf
EndFunc   ;==>__WinHttpConnect

;~ ******************************************

Func __WinhttpClose()
	_WinHttpCloseHandle($hRequest)
	_WinHttpCloseHandle($hConnect)
	_WinHttpCloseHandle($hOpen)
	DllCallbackFree($hWINHTTP_STATUS_CALLBACK)
EndFunc   ;==>__WinhttpClose

Func abrel($base_url, $replace_url)
	Local $replace_count = 0
	Local $base_url_array, $base_url_array_replace
	Local $replace_url_array
	Local $modify_count = 0
	$replace_url = StringStripWS($replace_url, 8)
	Select
		Case $replace_url = './' Or $replace_url = '../'
			$replace_url &= '$@'
		Case $replace_url = '.' Or $replace_url = '..'
			$replace_url &= '/$@'
	EndSelect
	$base_url_array = __WinCrackUrl($base_url)
	If $base_url_array[7] == '' And StringInStr($base_url_array[6], '.') == 0 And StringRight($base_url_array[6], 1) <> '/' Then
		$base_url_array[6] = $base_url_array[6] & '/'
	EndIf
	If StringInStr($replace_url, '/') > 0 And StringLen($replace_url) == 1 Then
		$base_url_array[6] = ''
		$base_url = _WinHttpCreateUrl($base_url_array)
		Return $base_url
	EndIf

	If $replace_url == '' Then
		Return $base_url
	EndIf

	If StringLower(StringLeft($replace_url, 7)) == 'http://' Or StringLower(StringLeft($replace_url, 8)) == 'https://' Then
		Return $replace_url
	EndIf

	If StringLeft($replace_url, 2) <> './' Or StringLeft($replace_url, 2) <> '..' Then
		If StringLeft($replace_url, 1) == '/' And StringLen($replace_url) > 1 Then
			$replace_url = '.' & $replace_url
		Else
			$replace_url = './' & $replace_url
		EndIf
	EndIf
	$base_url_array_replace = StringSplit($base_url_array[6], '/', 3)
	$replace_url_array = StringSplit($replace_url, './', 3)
;~ 	ConsoleWrite($base_url & @CRLF & $replace_url & @CRLF)

	While $replace_count < UBound($replace_url_array)
		Select
			Case StringLeft($replace_url_array[$replace_count], 1) == '.' And StringLen($replace_url_array[$replace_count]) == 1
				If UBound($base_url_array_replace) > 1 And ($replace_count + 1) < UBound($replace_url_array) Then
					_ArrayDelete($base_url_array_replace, UBound($base_url_array_replace) - 1)
					$base_url_array_replace[UBound($base_url_array_replace) - 1] = $replace_url_array[$replace_count + 1]
				EndIf
				$modify_count += 1
			Case StringLeft($replace_url_array[$replace_count], 1) == '' And StringLen($replace_url_array[$replace_count]) == 0
;~ 				ConsoleWrite(UBound($base_url_array_replace) & '===' & UBound($replace_url_array) & '==' & $replace_count + 1 & '====' & _ArrayToString($replace_url_array, ';') & @CRLF)
				If UBound($base_url_array_replace) > 1 And ($replace_count + 1) < UBound($replace_url_array) Then
					$base_url_array_replace[UBound($base_url_array_replace) - 1] = $replace_url_array[$replace_count + 1]
				EndIf
				$modify_count += 1

		EndSelect
		$replace_count += 1
	WEnd
	$base_url_array[6] = _ArrayToString($base_url_array_replace, '/')
	If $modify_count == 0 Then
		If StringLeft($replace_url, 1) == '/' Then
			$base_url_array[6] = $base_url_array[6] & StringTrimLeft($replace_url, 1)
		Else
			$base_url_array[6] = $base_url_array[6] & $replace_url
		EndIf
	EndIf
	$base_url = _WinHttpCreateUrl($base_url_array)
	$base_url = StringReplace($base_url, '$@', '')
	Return $base_url
EndFunc   ;==>abrel