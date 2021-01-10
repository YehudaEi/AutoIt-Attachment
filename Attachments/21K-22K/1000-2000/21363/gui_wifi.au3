#include <GUIConstants.au3>
#Include <GuiListView.au3>
#Include <GuiComboBox.au3>
;#Include <GuiCombo.au3>
Dim $SS_CENTER = 1
$ledon = 0
$string = ""
$scan = True
$Dll    = DllOpen("WiFiMan.dll")
$nCount = DllCall($Dll, "dword", "EnumerateAdapters")
ConsoleWrite("Adapters:         " & @TAB & $nCount[0] & @LF)

$adapternameBuffer   = DllStructCreate("char[256]")
$netnameBuffer   = DllStructCreate("char[256]")
$idBuffer   = DllStructCreate("char[256]")
$profilenameBuffer   = DllStructCreate("char[256]")


$Form1 = GUICreate("AutoIt Wifi", 362, 266, 193, 115)
$ListView1 = GUICtrlCreateListView("", 8, 40, 345, 177)
_GUICtrlListView_InsertColumn(-1, 0, "SSID", 2, 100)
_GUICtrlListView_InsertColumn(-1, 1, "Signal", 2, 46)
_GUICtrlListView_InsertColumn(-1, 2, "Type", 2, 46)
_GUICtrlListView_InsertColumn(-1, 3, "Secure", 2, 46)
_GUICtrlListView_InsertColumn(-1, 4, "Auth", 2, 46)
_GUICtrlListView_InsertColumn(-1, 5, "Cipher", 2, 46)
$Combo1 = GUICtrlCreateCombo("", 8, 8, 345, 25, BitOR($CBS_DROPDOWNLIST,$CBS_AUTOHSCROLL))
$Button1 = GUICtrlCreateButton("Scan", 8, 224, 81, 33)
$label = GUICtrlCreateLabel("By: CyberZeroCool" & @TAB & "www.cyberzerocool.com", 94, 225, 260, 33)
For $i = 0 To $nCount[0] - 1
	$nResult    = DllCall($Dll, "dword", "GetAdapterName", "int", $i, "ptr", DllStructGetPtr($adapternameBuffer), "int", 256)
	$string = DllStructGetData($adapternameBuffer, 1) & "|" & $string
Next
GUICtrlSetData($Combo1, $string, DllStructGetData($adapternameBuffer, 1))
GUISetState(@SW_SHOW)

While 1
    $msg = GUIGetMsg()
    If $msg = $GUI_EVENT_CLOSE Then
		Exit
	ElseIf $msg = $Button1 Then
		scanbutton()
	EndIf	
Wend


Func scanbutton()
	GUICtrlSetData( $Button1, "Scanning" )
	GUICtrlSetState( $Button1, $GUI_DISABLE )
	$i = _GUICtrlComboBox_FindString($Combo1, GUICtrlRead($Combo1),1)
	$networks    = DllCall($Dll, "dword", "EnumerateAvailableNetworks", "int", $i, "int", 1)
	;_GUICtrlListViewDeleteAllItems($ListView1)
	For $nets = 0 To $networks[0] - 1
		$netnameResult= DllCall($Dll, "dword", "GetAvailableNetworkName", "int", $i, "int", $nets, "ptr", DllStructGetPtr($netnameBuffer), "int", 256)
		$netsignal    = DllCall($Dll, "dword", "GetAvailableNetworkSignalQuality", "int", $i, "int", $nets)
		$nettype      = DllCall($Dll, "dword", "GetAvailableNetworkType", "int", $i, "int", $nets)
		$netsecure    = DllCall($Dll, "dword", "IsAvailableNetworkSecure", "int", $i, "int", $nets)
		If $netsecure[0] = 0 Then
			$netsecure[0] = "No"
		Else
			$netsecure[0] = "Yes"
		EndIf
		$netauth      = DllCall($Dll, "dword", "GetAvailableNetworkAuthMode", "int", $i, "int", $nets)
		$netcipher    = DllCall($Dll, "dword", "GetAvailableNetworkCipherMode", "int", $i, "int", $nets)
		_GUICtrlListView_InsertItem($ListView1, $nets, getcodes(DllStructGetData($netnameBuffer, 1)) & "|" & getcodes($netsignal[0]) & "%|" & typecodes($nettype[0]) & "|" & $netsecure[0] & "|" & authcodes($netauth[0]) & "|" & ciphercodes($netcipher[0]) )
	Next
	GUICtrlSetData( $Button1, "Scan" )
	GUICtrlSetState( $Button1, $GUI_ENABLE )
EndFunc

Func onautoitexit()
	DllClose($Dll)
EndFunc

Func authcodes($code)
	Switch Hex($code)
		;constants
	Case 0x00
		Return "Open"
	Case 0x01
		Return "Shared"
	case 0x02
		Return "AutoSwitch"
	Case 0x03
		Return "WPA"
	Case 0x04
		Return "WPAPSK"
	Case 0x05
		Return "WPANone"
	Case 0x06
		Return "WPA2"
	Case 0x07
		Return "WPA2PSK"
	Case Else
		Return $code
	EndSwitch
EndFunc

Func ciphercodes($code)
	Switch Hex($code)
		;Network Ciphers
	Case 0x00
		Return "None"
	Case 0x01 Or 0x101
		Return "WEP40"
	case 0x02
		Return "TKIP"
	Case 0x03
		Return "CCMP"
	Case 0x04
		Return "WEP104"
	Case 0x05
		Return "WPA Group"
	Case 0x06
		Return "RSN Group"
	Case 0x07
		Return "WEP"
	Case Else
		Return $code
	EndSwitch
EndFunc

Func typecodes($code)
	Switch Hex($code)
		;Network Types
	Case 0x01
		Return "Infrastructure"
	case 0x02
		Return "Independent"
	Case 0x03
		Return "Any"
	Case Else
		Return $code
	EndSwitch
EndFunc

Func getcodes($code)
	Switch Hex($code)
		;Errors
	Case 0x70000000
		Return "Codes offset (0x70000000)"
	Case 0x70000001
		Return "Inialization error (0x70000001)"
	Case 0x70000002
		Return "Enumeration error (0x70000002)"
	Case 0x70000003
		Return "Incorrect adapter index specified (0x70000003)"
	Case 0x70000004
		Return "Too small buffer (0x70000004)"
	Case 0x70000005
		Return "Error at getting a setting (0x70000005)"
	Case 0x70000006
		Return "Adapter is busy (0x70000006)"
	case 0x70000007
		Return "Invalid network index is specified (0x70000007)"
	Case 0x70000008
		Return "invalid profile index is specified (0x70000008)"
	Case 0x70000009
		Return "Error at applying a setting (0x70000009)"
	Case 0x7000000A
		Return "Profile not found (0x7000000A)"
	Case 0x7000000B
		Return "Invalid parameter (0x7000000B)"
	Case 0x7000000C
		Return "The list of networks or profiles has been changed, call EnumXXX function to update the list (0x7000000C)"
	Case 0x7000000D
		Return "Unspecified error (0x7000000D)"
	Case 0x7000000E
		Return "Adapter not found (0x7000000E)"
	Case 0x7000000F
		Return "Error at discovering available networks (0x7000000F)"
	Case 0x70000010
		Return "No current network (0x70000010)"
	Case 0x70000011
		Return "Unsupported feature (0x70000011)"
	Case 0x700000F0
		Return "Feature is not supported in trial version"
	Case 0x700000F1
		Return "trial version is expired (0x700000F0)   NOOOOOOO!!!"			
	Case Else
		Return $code
	EndSwitch
EndFunc