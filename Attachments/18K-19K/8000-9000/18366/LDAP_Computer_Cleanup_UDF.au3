#cs
===================================================================================
LDAP Computer Cleanup UDF v1 - January 2, 2008
Written by Andy Flesner
===================================================================================
#ce
#include<Date.au3>
#include<Array.au3>
#cs
===================================================================================
_findComputers($daysold, $dc, $domain, $suffix, $arraymax = 100000)

$daysold - the function will find machines that have not connected in over this many days
$dc - name of domain controller
$domain - name of domain but not the domain suffix
$suffix - the domain suffix (i.e. com, org, net, loc)
$arraymax - the maximum number of machines able to fit into the array, default is 100,000

The function returns an array of machine names based on the number of days it has been since 
the machines last authenticated to a domain controller. For Example:

$oldmachines = _findComputers(70,"dc1","company","com")

The $oldmachines variable is the returned array from the _findComputers() function.
===================================================================================
#ce

Func _findComputers($daysold, $dc, $domain, $suffix, $arraymax = 100000)
	Local $oMyError = ObjEvent("AutoIt.Error","MyErrFunc"), $array[$arraymax]
	$colItems = ObjGet("LDAP://" & $dc & "." & $domain & ".com/CN=Computers,DC=" & $domain & ",DC=" & $suffix)
	$i = 0
	For $objItem in $colItems
		$objComp = ObjGet("LDAP://" & $dc & "." & $domain & ".com/CN=" & $objItem.CN & ",CN=Computers,DC=" & $domain & ",DC=" & $suffix)
		$objLastLogon = $objComp.Get("lastLogon")
		$finaldate = _StampDateAdd($objLastLogon.HighPart,$objLastLogon.LowPart)
		If $finaldate = "//" Then
			$array[$i] = $objItem.CN
			$i = $i + 1
		Else
			$datediff = _DateDiff("d",$finaldate,(@YEAR & "/" & @MON & "/" & @MDAY))
			If $datediff > $daysold Then
				$array[$i] = $objItem.CN
				$i = $i + 1
			Else
			EndIf
		EndIf
	Next
	$i = 0
	Return $array
EndFunc

#cs
===================================================================================
_deleteComputers($array, $dc, $domain, $suffix)

$array - the function will delete machine names within this array
$dc - name of domain controller
$domain - name of domain but not the domain suffix
$suffix - the domain suffix (i.e. com, org, net, loc)

The function deletes machine accounts for computers within $array. For Example:

_deleteComputers($oldmachines,"dc1","company","com")
===================================================================================
#ce
Func _deleteComputers($array, $dc, $domain, $suffix)
	Local $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")
	$i = 0
	While $array[$i] <> ""
		$objOU = ObjGet("LDAP://" & $dc & "." & $domain & ".com/CN=Computers,DC=" & $domain & ",DC=" & $suffix)
		$objOU.Delete ("Computer", "CN=" & $array[$i])
		$i = $i + 1
	WEnd
EndFunc

;_StampDateAdd is used by _findComputers() to return an Integer8Date
;This script was found on the AutoIt forums and has been slightly modified
Func _StampDateAdd($lngHigh,$lngLow)
	Local $s_Quotes='"'
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
	$code=$code & @CRLF & "lngDate = #1/1/1601# + (((lngHigh * (2 ^ 32)) + lngLow) / 600000000 - lngTZBias) / 1440"
	$code=$code & @CRLF & "Integer8Date = CDate(lngDate)"
	$code=$code & @CRLF & "end Function"
	$vbs = ObjCreate("ScriptControl")
	$vbs.language="vbscript"
	$vbs.addcode($code)
	$integerdate = $vbs.run("Integer8Date",$lngHigh,$lngLow)
	$vbs=""
	$Year=StringLeft($integerdate,4)
	$Month=StringMid($integerdate,5,2)
	$Day=StringMid($integerdate,7,2)
	$datestring=$Year&"/"&$Month&"/"&$Day
	return $datestring
EndFunc

Func MyErrFunc()
	;do nothing, proceed upon error
EndFunc