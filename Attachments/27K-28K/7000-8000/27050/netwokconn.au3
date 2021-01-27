#include <array.au3> ; include is only needed for _arraydisplay, delete it if you don't need _arraydisplay

Global $ar_networkconnection [26] ; array 4 NetworkConnections

_GetNetworkConnection () ; Reading NetworkConnection from WMI
_ArrayDisplay ($ar_networkconnection) ; Display Array
Exit ; Delete Exit for DriveMapDel

For $i = 0 to 26
	if $ar_networkconnection [$i] <> "" Then DriveMapDel ($ar_networkconnection [$i]) ; Delete Shares you get from WMI
Next		

Func _GetNetworkConnection ()
	$i = 0
	$strComputer = "Localhost"
	$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkConnection")
	For $objItem In $colItems
		if StringInStr ($objItem.RemoteName, "charlie-1") <> 0 Then ; If Servername charlie is in WMI Class Query, then fill array
			$ar_networkconnection [$i] = $objItem.LocalName
			$i += 1
		EndIf
	Next
EndFunc
