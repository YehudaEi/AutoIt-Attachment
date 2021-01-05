Func _INetGetImage($s_URL)
	
	Local $s_temp = '', $v_HTTP, $s_HTTP
	
	;object
	$v_HTTP = ObjCreate ("winhttp.winhttprequest.5.1")
	
	;on com error set to @error to 1
	If @error Then
		SetError(1)
		return 0
	EndIf
	
	;send the request
	$v_HTTP.open ("GET", $s_URL)
	$v_HTTP.send ()
	
	;return the response
	$v_HTTP = $v_HTTP.Responsetext
	
	;regexp it
	$v_HTTP = StringRegExp($v_HTTP, '<img(.*?)>', 3)

	;loop and add for each find
	For $i = 0 to UBound($v_HTTP) - 1
		
		;regexp it again
		$s_HTTP = StringRegExp($v_HTTP[$i], 'src="(.*?)"', 3)
		
		;check if matched
		If @extended <> 1 Then ContinueLoop
		
		;add
		$s_temp &= $s_HTTP[0] & '|{)*&%'
		
	Next
	
	;make an array from the temp
	$v_HTTP = StringSplit(StringTrimRight($s_temp, StringLen('|{)*&%')), '|{)*&%', 1)
	
	;get the url and alter it so we can use it as a prefix location
	$s_URL = StringLeft($s_URL, StringInStr($s_URL, '/', 0, -1)-1)
	
	;loop till all is prefix'd
	For $i = 1 To $v_HTTP[0]
		
		;if external do nothing
		If StringLeft($v_HTTP[$i], 7) = 'http://' OR StringLeft($v_HTTP[$i], 8) = 'https://' Then ContinueLoop
		
		;if respective of the location add a '/' if not yet present
		If StringLeft($v_HTTP[$i], 1) <> '/' Then $v_HTTP[$i] = '/' & $v_HTTP[$i]
			
		;add the prefix
		$v_HTTP[$i] = $s_URL & $v_HTTP[$i]
		
	Next
	
	;if no images are found set @error to 2
	If $v_HTTP[1] = $s_URL & '/' Then
		SetError(2)
		return 0
	EndIf
	
	;return the array
	return $v_HTTP
	
EndFunc



#cs
;ALL ROOT URLS MUST END IN '/'
;good: http://www.autoitscript.com/
;good: http://www.autoitscript.com/index.php
;BAD: http://www.autoitscript.com

$var = _INetGetImage('http://www.autoitscript.com/')

If NOT @ERROR Then

For $i = 1 to $var[0]
	ConsoleWrite($var[$i] & @LF)
Next

EndIf
#ce