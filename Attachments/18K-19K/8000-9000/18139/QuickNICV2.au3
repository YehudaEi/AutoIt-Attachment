#include <Array.au3>
Opt("TrayMenuMode",1)
TraySetIcon("Shell32.dll",-150)
TraySetToolTip("QuickNIC")

Global $strEnable = "En&able"
Global $strDisable = "Disa&ble"

Func NetworkConnectionsObject()
	$objShell = ObjCreate("Shell.Application")
	$strNetConn = "Network Connections"
	$objCP = $objShell.Namespace(3)
	Global $colNetwork = ""
	For $clsConn In $objCP.Items
		If $clsConn.Name = $strNetConn Then $colNetwork = $clsConn.GetFolder
	Next
	Return $colNetwork	
EndFunc

Func GetNetworkNames($colNetwork)
	Dim $strNetworks
	For $clsConn In $colNetwork.Items
		If StringInstr($clsConn.Name,"Wizard") = 0 Then
			$strNetworks = $strNetworks & $clsConn.Name & "|"
		EndIf
	Next
	$strNetworks = StringLeft($strNetworks,StringLen($strNetworks)-1)
	$arrNetworks = StringSplit($strNetworks,"|")
	_ArrayDelete($arrNetworks,0)
	_ArraySort($arrNetworks)
	Return $arrNetworks
EndFunc

Func AddTrayItems($arrNetworks)
	For $i = 0 To UBound($arrNetworks) - 1
		For $clsConn In $colNetwork.Items
			If $clsConn.Name = $arrNetworks[$i] Then
				TrayCreateItem($arrNetworks[$i])
				For $clsVerb in $clsConn.verbs
					If $clsVerb.name = $strDisable Then TrayItemSetState(-1,1)
					If $clsVerb.name = $strEnable Then TrayItemSetState(-1,4)
				Next
			EndIf
		Next
	Next
EndFunc

Func ToggleNetworkInterface($strNetwork)
	For $clsConn In $colNetwork.Items
		If $clsConn.Name = $strNetwork Then
			For $clsVerb in $clsConn.verbs
				If $clsVerb.name = $strDisable Then 
					$clsVerb.DoIt
					sleep(200)
					Return 0
				EndIf
				If $clsVerb.name = $strEnable Then 
					$clsVerb.DoIt
					TrayItemSetState($msg,1)
					sleep(200)
					Return 1
				EndIf
			Next
		EndIf
	Next
EndFunc

AddTrayItems(GetNetworkNames(NetworkConnectionsObject()))

$separator = TrayCreateItem("")
$trayabout = TrayCreateItem("About")
$trayexit = TrayCreateItem("Exit")

While 1
	$msg = TrayGetMsg()

	If $msg > 0 and $msg <> $trayabout and $msg <> $trayexit Then 
		ToggleNetworkInterface(TrayItemGetText($msg))
	EndIf

	If $msg = $trayabout Then 
		SplashTextOn("About...","QuickNIC is a tool that provides a quick and easy method to toggle (enable/disable) your Network Connections." & @CRLF & @CRLF & "version 0.2b",300,120)
		sleep(3500)
		SplashOff()
	EndIf
		
	If $msg = $trayexit Then ExitLoop
WEnd