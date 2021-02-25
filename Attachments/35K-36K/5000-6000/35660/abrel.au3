#include "WinHttp.au3"
#include "Array.au3"

Local $base_url = 'http://www.gmail.com/abc/ayx/ggg.ph'
Local $replace_url = '../ss/ggh/a.php'
ConsoleWrite($base_url & '===' & $replace_url & @CRLF)
$base_url = abrel($base_url, $replace_url)
ConsoleWrite($base_url & @CRLF)

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

Func __WinCrackUrl($curl)
    Local $curl_temp
    $curl = StringStripCR($curl)
    $curl = StringReplace($curl, @LF, '')
    $curl = StringStripWS($curl, 3)
    $curl_temp = _WinHttpCrackUrl($curl, $ICU_DECODE)
    Return $curl_temp
EndFunc   ;==>__WinCrackUrl