#include <Array.au3>

$hTimer = TimerInit()
$GetIPInfo = _GetIPInfo()
$iDiff = TimerDiff($hTimer)
ConsoleWrite("Run in " & $iDiff & "ms" & @LF)
_ArrayDisplay($GetIPInfo)


;~ ==========Array returns
#cs
	Visitor from:
	Your IP Number:
	Your Host name:
	Your City:
	Your Region:
	Your Capital:
	Your Country Name:
	Your Country Code:
	Your Language:
	Your Currency:
	IP Organization:
#ce


Func _GetIPInfo()
	Local $vPage = InetRead("                                                            ")
	If @error Or $vPage = "" Then Return SetError(1, 0, "www.find-ip-address.org is propably down")

	Local $vBin = BinaryToString($vPage)
	Local $aInfos[11] = ["Visitor from", "IP Number", "Host name", "City", "Region", "Capital", "Country Name", "Country Code", "Language", "Currency", "IP Organization"]
	Local $sReturn[11][2]
	Local $aReturn

	For $i = 0 To UBound($aInfos) - 1
		$aReturn = StringRegExp($vBin, "(?i)(?U)" & $aInfos[$i] & ": <b>(.*)</b>", 3)
		If @error Then ;~ If someday the site changes
			$sReturn[$i][0] = $aInfos[$i]
			$sReturn[$i][1] = "Not avaible"
			ContinueLoop
		EndIf
		$sReturn[$i][0] = $aInfos[$i]
		$sReturn[$i][1] = $aReturn[0]
	Next
	Return $sReturn
EndFunc   ;==>_GetIPInfo
