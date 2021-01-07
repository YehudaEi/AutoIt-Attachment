;arcker and randallc vbs to autoit functions
;autoit doesn't support some functions of autoit, so here is the "workaround"


; randallc :
; Here's a function to emulate vbscript;
; I assume you can find the high , low values mentioned; here is example using vbscript object!
; I don't know if native AutoIt can do it!
#include<Date.au3>
#include<Array.au3>

Func _StampDateAdd($lngHigh,$lngLow,$format = "")
	
Local $s_Quotes='"'

;""
$code= "Function Integer8Date(lngHigh,lngLow)"
$code = $code & @CRLF & "Dim WshShell, lngBiasKey,lngTZBias"
$code = $code & @CRLF & 'Set WshShell = CreateObject("WScript.Shell")'
$code = $code & @CRLF & "lngBiasKey=WshShell.RegRead(""HKLM\System\CurrentControlSet\Control\TimeZoneInformation\ActiveTimeBias"")"
$code = $code & @CRLF & "If UCase(TypeName(lngBiasKey)) = ""LONG"" Then"
$code = $code & @CRLF & "lngTZBias = lngBiasKey"
$code = $code & @CRLF & "ElseIf UCase(TypeName(lngBiasKey)) = ""VARIANT()"" Then"
$code = $code & @CRLF & "lngTZBias = 0"
$code = $code & @CRLF & "For k = 0 To UBound(lngBiasKey)"
$code = $code & @CRLF & "lngTZBias = lngTZBias + (lngBiasKey(k) * 256^k)"
$code = $code & @CRLF & "Next"
$code = $code & @CRLF & "End If"
$code = $code & @CRLF & "lngDate = #1/1/1601# + (((lngHigh * (2 ^ 32)) + lngLow) / 600000000 - lngTZBias) / 1440"
$code = $code & @CRLF & "Integer8Date = CDate(lngDate)"
$code =  $code & @CRLF & "end Function"

$vbs = ObjCreate("ScriptControl")
$vbs.language="vbscript"
$vbs.addcode($code)
$retour = $vbs.run("Integer8Date",$lngHigh,$lngLow)
$vbs=""
$Year=StringLeft($retour,4)
$Month=StringMid($retour,5,2)
$Day=StringMid($retour,7,2)
$Hour=StringMid($retour,9,2)
$Minute=StringMid($retour,11,2)
$Second=StringMid($retour,13,2)
;ConsoleWrite($retour)
if $format = "date" then
$retourstring = $Day&"/"&$Month&"/"&$Year&" "&$Hour&":"&$Minute&":"&$Second
Else
$retourstring=$Year&"/"&$Month&"/"&$Day&" "&$Hour&":"&$Minute&":"&$Second
EndIf

return $retourstring
EndFunc ;==>_StampDateAdd


;$retour=_datetointeger8("03/01/2006 09:02:16")
;msgbox(0,"",$retour)
;$splithigh=StringMid($retour,1,8)
;$splitlow=StringMid($retour,9,8)
;$retour=_StampDateAdd($splithigh,$splitlow,"date")
;msgbox(0,"YEEEES",$retour)


Func _datetointeger8($date)
	
	;Obtain local Time Zone bias from machine registry.
Local $s_Quotes='"'	
$code = "function datetointeger8(date)"

;$code = $code & @CRLF & "Option Explicit"

$code = $code & @CRLF & "Dim dtmDateValue, dtmAdjusted, lngSeconds"
$code = $code & @CRLF & "Dim WshShell, lngBiasKey,lngTZBias"
$code = $code & @CRLF & 'Set WshShell = CreateObject("WScript.Shell")'
$code = $code & @CRLF & "dtmDateValue = CDate(date)"
$code = $code & @CRLF & "lngBiasKey=WshShell.RegRead(""HKLM\System\CurrentControlSet\Control\TimeZoneInformation\ActiveTimeBias"")"
$code = $code & @CRLF & "If UCase(TypeName(lngBiasKey)) = ""LONG"" Then"
$code = $code & @CRLF & "lngTZBias = lngBiasKey"
$code = $code & @CRLF & "ElseIf UCase(TypeName(lngBiasKey)) = ""VARIANT()"" Then"
$code = $code & @CRLF & "lngTZBias = 0"
$code = $code & @CRLF & "For k = 0 To UBound(lngBiasKey)"
$code = $code & @CRLF & "lngTZBias = lngTZBias + (lngBiasKey(k) * 256^k)"
$code = $code & @CRLF & "Next"
$code = $code & @CRLF & "End If"

; Convert datetime value to UTC.
$code = $code & @CRLF & "dtmAdjusted = DateAdd(""n"", lngBias, dtmDateValue)"

;' Find number of seconds since 1/1/1601.
$code = $code & @CRLF & "lngSeconds = DateDiff(""s"", #1/1/1601#, dtmAdjusted)"

;' Convert the number of seconds to a string
;' and convert to 100-nanosecond intervals.
$code = $code & @CRLF & "datetointeger8 = CStr(lngSeconds) & ""0000000"""
$code = $code & @CRLF & "end Function"
msgbox(0,"",$code)
$vbs = ObjCreate("ScriptControl")
$vbs.language="vbscript"
$vbs.addcode($code)
$retour = $vbs.run("datetointeger8",$date)	
return $retour

$vbs=""
EndFunc



func _getinfotime($champ,$cheminldap)
	Local $s_Quotes='"'
	$code= "Function Getinfo(champ,cheminldap)"
	$code = $code & @CRLF & "Dim objConnection, objChild , string"
	$code = $code & @CRLF & "Set objEntry = GetObject(""LDAP://"" & cheminldap)"
	$code = $code & @CRLF & 'proplist = array(champ) '
	$code = $code & @CRLF & 'objEntry.getinfoex proplist, 0'
	$code = $code & @CRLF &  'string = objEntry.Get(champ)'
	$code = $code & @CRLF &  'Getinfo = string'
	$code = $code & @CRLF & "end Function"
	;msgbox(0,"",$code)
$vbs = ObjCreate("ScriptControl")
$vbs.language="vbscript"
$vbs.addcode($code)
$retour = $vbs.run("Getinfo",$champ,$cheminldap)	
$Year=StringLeft($retour,4)
$Month=StringMid($retour,5,2)
$Day=StringMid($retour,7,2)
$Hour=StringMid($retour,9,2)
$Minute=StringMid($retour,11,2)
$Second=StringMid($retour,13,2)
$retour = $Day&"/"&$Month&"/"&$Year&" "&$Hour&":"&$Minute&":"&$Second
return $retour
$vbs=""
endfunc


	