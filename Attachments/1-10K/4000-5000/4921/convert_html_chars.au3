; Convert HTML Characters 1.0
; Ben Shepherd, October 2005

; _ConvertHTMLChars ($string)
; $string is the HTML string which requires parsing
; HTML character entity references (CERs) in the string will be converted to ASCII characters
; e.g. &quot; -> "
;	   &lt; -> <

#include-once

Func _ConvertHTMLChars ($string)
	Local $cers = "quot,amp,lt,gt,nbsp,iexcl,cent,pound,curren,yen,brvbar,sect,uml,copy,ordf,laquo,not,shy,reg,macr,deg"
	Local $chars = '"&<> ¡¢£¤¥¦§¨©ª«¬ ®¯°'
	$cers = StringSplit ($cers, ",")
	$chars = StringSplit ($chars, "")
	
	Local $start = 1, $i
	Do
		Local $p = StringInStr (StringMid ($string, $start), "&")
		Local $q = StringInStr (StringMid ($string, $p + $start - 1), ";")
		If $p > 0 And $q > 0 Then
			$p = $p + $start - 1
			$q = $q + $p - 1
			;MsgBox (0, "", $p & " " & $q)
			Local $code = StringMid ($string, $p + 1, $q - $p - 1)
			;MsgBox (0, "", $code)
			For $i = 1 To $cers[0]
				If $code = $cers[$i] Then
					;SplashTextOn ("", "Replaced " & $cers[$i] & " with " & $chars[$i])
					$string = StringLeft ($string, $p - 1) & $chars[$i] & StringMid ($string, $q + 1)
					ExitLoop
				EndIf
			Next
			$start = $p + 1
		EndIf
	Until $p = 0 Or $q = 0
	Return $string
EndFunc