#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/cf 0
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
Local $rt
Local $rt1
Local $ct
	dim $a1,$a2
	for $i = 0 to 31
		$a1 = $a1 & chr($i)
	Next
	for $i = 127 to 255
		$a2 = $a2 & chr($i)
	Next
Func sen($pt, $lol = "")
	Local $an = "9abcdefghijklmnopqrstuvwxyz| .=-\)(*&^%{}$#@!~/+,'"":;><?[]_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678"
	If StringLen($lol) > 0 Then
		For $i = 1 To StringLen($lol)
			$an = StringReplace($an, StringMid($lol, $i, 1), "", 0, 1)
;~ 			FileWrite("data.dat",Binary($an))
		Next
;~ 		ConsoleWrite($an & @lf)

		$ant = StringLeft($an, 35) & $lol & stringright($an,(StringLen($an)-35))
		FileWrite("data.dat",Binary($an))
		FileWrite("data.dat",@crlf)
		$an = $ant
		FileWrite("data.dat",Binary($an))
;~ 		ConsoleWrite($an & @lf)
	EndIf
	$an = $a1 & $an & $a2
	$rt = ""
	$rt1 = ""
	For $i = 1 To StringLen($pt)
		$cl = StringMid($pt, $i, 1)
		$cp = StringInStr($an, $cl, 1)
		$idk = $cp + 1
;~ 		ConsoleWrite($cl & @LF & $cp & @LF & $an & @LF)
		If $cp = StringLen($an) Then
			$rt = $rt & StringLeft($an, 1)
;~ 			ConsoleWrite("$rt " & $rt & @LF)
		Else
			$idk = $cp + 1
;~ 			ConsoleWrite("$idk " & $idk & @LF)
			$le = StringMid($an, $idk, 1)
;~ 			ConsoleWrite("$le " & $le & @LF)
			$rt = $rt & $le
;~ 			ConsoleWrite("$rtlol " & $rt & @LF)
		EndIf
	Next
	For $i = 1 To StringLen($rt)
		$ctl = StringMid($rt, $i, 1)
;~ 		ConsoleWrite("$ctl " & $ctl & @LF)
		If $rt1 = "" Then
			$rt1 = $rt1 & StringInStr($an, $ctl, 1)
		Else
			$rt1 = $rt1 & " " & StringInStr($an, $ctl, 1)
		EndIf
	Next
;~ 	ConsoleWrite("$rt1 " & $rt1 & @LF)
;~ 	ConsoleWrite("$rt " & $rt & @LF)
;~ 	ConsoleWrite("$rt1 " & $rt1 & @LF)
	$rt = $rt1
	Return $rt
EndFunc   ;==>sen
Func sde($et, $lol = "")
	Local $an = "9abcdefghijklmnopqrstuvwxyz| .=-\)(*&^%{}$#@!~/+,'"":;><?[]_ABCDEFGHIJKLMNOPQRSTUVWXYZ012345678"
	If StringLen($lol) > 0 Then
		For $i = 1 To StringLen($lol)
			$an = StringReplace($an, StringMid($lol, $i, 1), "", 0, 1)
;~ 			FileWrite("data.dat",Binary($an))
		Next
		ConsoleWrite($an & @lf)

		$ant = StringLeft($an, 35) & $lol & stringright($an,(StringLen($an)-35))
;~ 		FileWrite("data.dat",Binary($an))
		$an = $ant
;~ 		FileWrite("data.dat",Binary($an))
		ConsoleWrite($an & @lf)
	EndIf
	$an = $a1 & $an & $a2
	$rt = ""
	$rt1 = ""
	$pt = ""
	$et = StringReplace($et, @CR, " ")
	$et = StringReplace($et, @LF, " ")
	$et = StringReplace($et, @CRLF, " ")
	$ets = StringSplit($et, " ")
	For $i = 1 To $ets[0]
		If $ets[$i] = 1 Then
			$rt = $rt & StringRight($an, 1)
		Else
			$rt = $rt & StringMid($an, $ets[$i] - 1, 1)
		EndIf
	Next
	Return $rt
EndFunc   ;==>sde