;*****************************************************************
; ***************** OEM <=> ANSI conversion UDFs *****************
;*****************************************************************
; * Func _stringOEM($AnsiString)
; * Func _stringANSI($OemString)
;	-> Wrapper functions for the converter
;
; * Func _OAconvert($string, $Destination = "OEM")
;	-> Parses $string for conversion to $Destination format! ;)
; * Func _changeCodePage($pid, $codePageTo, $codePageFrom, $string)
;	-> actually perform the change (called by _OAconvert)
;	-> only safe on characters having ascii codes > 127
;
; **** Also a simpler but more time consuming func. for ANSI->OEM:
; * Func _stringSimpleOEM($AnsiString)
;	-> simpler func. to be used on strings with *few* extended 
;		characters *distributed* in it.
;*****************************************************************


;*****************************************************************
;Testing code, adapt to your need
;*****************************************************************
;example string best suited for the simple function
$teststring = "JÈrÙme"
;example string best suited for the standard functions
;~ $teststring = "&È""'(-Ë_Á‡)=~#{[|` \^@]}+∞^®$£§* µ˘%,;:! ß/.?<≤>‡BHËxcbf dnnfFXBÏDSWH ÚDFH˘ ËFDFB ¿FDB»" & _
;~ 				"sgqsSDG HdsÃf djhng fdj,“XDBHŸsbdg„x bgfdhdsf ıxdbds shÒ√’fgj— ‚dfj ÍÓÙ˚qsh ¬ Œdswhdrs" & _
;~ 				" fj‘€‰ ÎÔˆ¸qsgsehqq vezƒÀœhredqahj÷‹"

$begin = TimerInit()
	$OemString = _stringOEM($teststring)
$Lap1 = int(TimerDiff($begin))
$begin = TimerInit()
	$AnsiString = _stringANSI($OemString)
$Lap2 = int(TimerDiff($begin))

$message = "ANSI Start		:   " & $teststring & @LF & _
			"OEM version  (" & $Lap1 & "ms)	:   " & $OemString & @LF & _
			"back to ANSI (" & $Lap2 & "ms)	:   " & $AnsiString
If $teststring = $AnsiString Then 
	$message = $message & @LF & @LF & "	ANSI Strings are identical."
Else
	$message = $message & @LF & @LF & "*************ANSI Strings are NOT identical.************************"
EndIf

$begin = TimerInit()
	$OemStringb = _stringSimpleOEM($teststring)
$Lap1b = int(TimerDiff($begin))
$message = $message & @LF & @LF & _
			"OEM simple version (" & $Lap1b & "ms)	:   " & $OemStringb


MsgBox(0, "OEM <=> ANSI conversion:", $message)
;*****************************************************************


;*****************************************************************
Func _stringOEM($AnsiString)
;*****************************************************************
	Return  _OAconvert($AnsiString)
EndFunc
;*****************************************************************

;*****************************************************************
Func _stringANSI($OemString)
;*****************************************************************
	Return _OAconvert($OemString, "ANSI")
EndFunc
;*****************************************************************





;*****************************************************************
Func _OAconvert($string, $Destination = "OEM")
;*****************************************************************
	Local $ACP=RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Nls\CodePage", "ACP")
	Local $OEMCP=RegRead("HKLM\SYSTEM\CurrentControlSet\Control\Nls\CodePage", "OEMCP")
	If $ACP = $OEMCP Or $ACP ="" Or $OEMCP = "" then Return $string
	Local $pid, $codePageTo, $codePageFrom
	
	Local $i, $arrString = StringSplit($string,"")
	Local $converted, $accumulator
	
	If StringUpper($Destination) = "OEM" Then
		$codePageTo = $OEMCP
		$codePageFrom = $ACP
		$pid = Run(@ComSpec & ' /K @ECHO OFF &&CHCP ' & $codePageFrom, "", @SW_HIDE, 3)
		StdoutRead($pid)
	Else
		$codePageTo = $ACP
		$codePageFrom = $OEMCP
		$pid = Run(@ComSpec & ' /K @ECHO OFF', "", @SW_HIDE, 3)
	EndIf
	
	For $i = 1 To $arrString[0]
		If Asc($arrString[$i]) > 127 Then 
			$accumulator = $accumulator & $arrString[$i]
		ElseIf $accumulator <> "" then 
			$converted = $converted & _changeCodePage($pid, $accumulator, $codePageTo, $codePageFrom) & $arrString[$i]
			$accumulator = ""
		Else
			$converted = $converted & $arrString[$i]
		EndIf
	Next
	
	If $accumulator <> "" then $converted = $converted & _changeCodePage($pid, $accumulator, $codePageTo, $codePageFrom)
	ProcessClose ($pid)
	
	Return $converted
EndFunc
;*****************************************************************

;*****************************************************************
Func _changeCodePage($pid, $string, $codePageTo, $codePageFrom)
;*****************************************************************
	StdinWrite($pid, 'SET "STR=' & $string & '" &&CHCP ' & $codePageTo & ' >NUL' & @CRLF )
	StdoutRead($pid)
	StdinWrite($pid, 'ECHO.%STR% &&CHCP ' & $codePageFrom & ' >NUL' & @CRLF)
	StdoutRead($pid)
	Return StringStripWS(StdoutRead($pid), 2)
EndFunc
;*****************************************************************




;*****************************************************************
Func _stringSimpleOEM($AnsiString)
;*****************************************************************
	local $i, $oem, $arrString = StringSplit($AnsiString,"")
	
	For $i = 1 To $arrString[0]
		If Asc($arrString[$i]) > 127 Then  $arrString[$i] = StringStripWS(StdoutRead(Run(@ComSpec & " /C ECHO." & $arrString[$i], "", @SW_HIDE, 2)), 2)
		$oem = $oem & $arrString[$i]
	Next
	Return $oem
EndFunc
;*****************************************************************

