#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=Beta
#AutoIt3Wrapper_icon=C:\scripts\Tic2.ico
#AutoIt3Wrapper_outfile=C:\scripts\IPSetup\SetIP.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=IP Address Setup
#AutoIt3Wrapper_Res_LegalCopyright=Mark Solesbury
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****



#include <Date.au3>
Global $msg, $hgui, $setfocus, $button, $Address, $ihavepressed = 0, $IhavePressedSubnet = 0, $ihavepressedGateway = 0, $active = "Edit4", $Subnet, $gate
Local $index = 1

#include <GuiIPAddress.au3>
#include <GUIConstants.au3>


If FileExists("C:\F-DIA") Then
	$netName1 = "Local Area Connection 1 on Board"
	$defaultIP = "100.100.100.101"
	$1 = MsgBox(64, "IP Address Setup", "This utility will only configure the On Board Network card." & @CRLF & @CRLF & "The Add in card will need to be set manually.")
	
	
	
Else
	$netName1 = "Local Area Connection"
	$defaultIP = "100.100.100.200"
EndIf


#Region ### START Koda GUI section ### Form=c:\scripts\ipsetup\aform1.kxf
$Form1_1 = GUICreate("IP Address Setup", 460, 525, -1, -1)

$lbl1 = GUICtrlCreateLabel("IP Address", 10, 50, 70, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

$lbl2 = GUICtrlCreateLabel("Subnet", 10, 90, 70, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")

$lbl3 = GUICtrlCreateLabel("Gateway", 10, 130, 70, 20)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")


GUICtrlCreateLabel("", 1000, 90, 1, 1)
GUICtrlSetFont(-1, 10, 400, 0, "Tahoma")





$Address = _GUICtrlIpAddressCreate($Form1_1, 85, 40, 300, 35)
_GUICtrlIpAddressSet($Address, $defaultIP)
_GUICtrlIpAddressSetFont($Address, "Tahoma", 20)

$Subnet = _GUICtrlIpAddressCreate($Form1_1, 85, 80, 300, 35)
_GUICtrlIpAddressSet($Subnet, "255.255.255.0")
_GUICtrlIpAddressSetFont($Subnet, "Tahoma", 20)

$gate = _GUICtrlIpAddressCreate($Form1_1, 85, 120, 300, 35)
_GUICtrlIpAddressSet($gate, "")
_GUICtrlIpAddressSetFont($gate, "Tahoma", 20)

GUICtrlSetFont(-1, 25, 400, 0, "Tahoma")
$a7 = GUICtrlCreateButton("7", 124, 160, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a8 = GUICtrlCreateButton("8", 196, 160, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a9 = GUICtrlCreateButton("9", 268, 160, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a1 = GUICtrlCreateButton("1", 124, 305, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a6 = GUICtrlCreateButton("6", 268, 232, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a4 = GUICtrlCreateButton("4", 124, 232, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a5 = GUICtrlCreateButton("5", 196, 232, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a2 = GUICtrlCreateButton("2", 196, 305, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a3 = GUICtrlCreateButton("3", 268, 305, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$a0 = GUICtrlCreateButton("0", 196, 378, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$ok = GUICtrlCreateButton("OK", 345, 446, 103, 55, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$dot = GUICtrlCreateButton("Tab", 124, 378, 65, 65, 0)
;GUICtrlSetState(-1,$GUI_DISABLE)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$Label1 = GUICtrlCreateLabel("Please enter the IP address for this computer", 68, 10, 389, 29)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$clear = GUICtrlCreateButton("Clear", 268, 378, 65, 65, 0)
GUICtrlSetFont(-1, 14, 400, 0, "Tahoma")
$dhcp = GUICtrlCreateRadio("Set computer to use DHCP", 40, 455, 233, 17)
GUICtrlSetFont(-1, 13, 400, 0, "Tahoma")
$dhcpoff = GUICtrlCreateRadio("Configure Address Manually", 40, 475, 265, 25)
GUICtrlSetFont(-1, 13, 400, 0, "Tahoma")
GUICtrlCreateLabel("Mark Solesbury", 470 - 100, 505, 100, 29)
GUICtrlSetFont(-1, 9, 400, 0, "Tahoma")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



ControlFocus("", "", $Address)
GUICtrlSetState($dhcpoff, $GUI_CHECKED)
GUICtrlSetState($dhcp, $GUI_UNCHECKED)

$hwnd = ControlGetHandle($Form1_1, "", "Class:sysIPaddress32")
;msgbox(0,"",$address)

$GuiCtrlFocus = "Edit"
;$cnt = 4

$active = "Edit4"

While 1
	
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $a0
			
			Pressed(0)
			

		Case $a1
			
			Pressed(1)

		Case $a2
			
			Pressed(2)

		Case $a3
			
			Pressed(3)

		Case $a4
			
			Pressed(4)

		Case $a5
			
			Pressed(5)

		Case $a6
			
			Pressed(6)

		Case $a7
			
			Pressed(7)

		Case $a8
			
			Pressed(8)

		Case $a9
			
			Pressed(9)

		Case $dot
			
			_tabAccross()
			;new bit to jump to required next box on tab


		Case $clear
			
			;new bit for multiline clear
			
			Switch $active
				
				Case "Edit4", "Edit3", "Edit2", "Edit1"
					$temp = GUICtrlRead($Address)
					ControlSetText("", "", $Address, StringTrimRight($temp, 1))
					GUICtrlSetState($dhcp, $GUI_UNCHECKED)
					ControlFocus("", "", "Edit4")
					
				Case "Edit8", "Edit7", "Edit6", "Edit5"
					$temp = GUICtrlRead($Subnet)
					ControlSetText("", "", $Subnet, StringTrimRight($temp, 1))
					GUICtrlSetState($dhcp, $GUI_UNCHECKED)
					ControlFocus("", "", "Edit8")
					
				Case "Edit12", "Edit11", "Edit10", "Edit9"
					$temp = GUICtrlRead($gate)
					ControlSetText("", "", $gate, StringTrimRight($temp, 1))
					GUICtrlSetState($dhcp, $GUI_UNCHECKED)
					ControlFocus("", "", "Edit12")
					
			EndSwitch
			
			
		Case $dhcp
			_GUICtrlIpAddressShowHide($Address, @SW_HIDE)
			_GUICtrlIpAddressShowHide($Subnet, @SW_HIDE)
			_GUICtrlIpAddressShowHide($gate, @SW_HIDE)
			ControlSetText("", "", $lbl1, "")
			ControlSetText("", "", $lbl2, "")
			ControlSetText("", "", $lbl3, "")
			;GUICtrlSetState ($address, $GUI_DISABLE)
			GUICtrlSetState($a0, $GUI_DISABLE)
			GUICtrlSetState($a1, $GUI_DISABLE)
			GUICtrlSetState($a2, $GUI_DISABLE)
			GUICtrlSetState($a3, $GUI_DISABLE)
			GUICtrlSetState($a4, $GUI_DISABLE)
			GUICtrlSetState($a5, $GUI_DISABLE)
			GUICtrlSetState($a6, $GUI_DISABLE)
			GUICtrlSetState($a7, $GUI_DISABLE)
			GUICtrlSetState($a8, $GUI_DISABLE)
			GUICtrlSetState($a9, $GUI_DISABLE)
			GUICtrlSetState($a0, $GUI_DISABLE)
			GUICtrlSetState($clear, $GUI_DISABLE)
			GUICtrlSetState($dot, $GUI_DISABLE)
			
		Case $dhcpoff
			ControlSetText("", "", $lbl1, "IP Address")
			ControlSetText("", "", $lbl2, "Subnet")
			ControlSetText("", "", $lbl3, "Gateway")
			_GUICtrlIpAddressShowHide($Address, @SW_SHOW)
			_GUICtrlIpAddressShowHide($Subnet, @SW_SHOW)
			_GUICtrlIpAddressShowHide($gate, @SW_SHOW)
			GUICtrlSetState($Address, $GUI_ENABLE)
			GUICtrlSetState($a0, $GUI_ENABLE)
			GUICtrlSetState($a1, $GUI_ENABLE)
			GUICtrlSetState($a2, $GUI_ENABLE)
			GUICtrlSetState($a3, $GUI_ENABLE)
			GUICtrlSetState($a4, $GUI_ENABLE)
			GUICtrlSetState($a5, $GUI_ENABLE)
			GUICtrlSetState($a6, $GUI_ENABLE)
			GUICtrlSetState($a7, $GUI_ENABLE)
			GUICtrlSetState($a8, $GUI_ENABLE)
			GUICtrlSetState($a9, $GUI_ENABLE)
			GUICtrlSetState($a0, $GUI_ENABLE)
			GUICtrlSetState($clear, $GUI_ENABLE)
			GUICtrlSetState($dot, $GUI_ENABLE)
			
			
			
		Case $ok
			
			If _GUICtrlIpAddressIsBlank($Address) Then
				MsgBox(0, "Error", "IP Fields are blank")
			Else
				If GUICtrlRead($dhcp) = $GUI_CHECKED Then
					RunWait('netsh interface ip set address "Local Area Connection" dhcp', "", @SW_HIDE)
					;RunWait('netsh interface ip set address "Local Area Connection" dhcp', "")

					Exit
				EndIf
				
				

				
				$newIP1 = _GUICtrlIpAddressGet($Address)
				$newsub = _GUICtrlIpAddressGet($Subnet)
				$newgate = _GUICtrlIpAddressGet($gate)
				

				ConsoleWrite($netName1 & @CRLF & $newIP1 & @CRLF & $newsub & @CRLF & $newgate & @CRLF)



				
				If $newgate = "0.0.0.0" Then
					
					$IP = RunWait('netsh interface ip set address name="' & $netName1 & '" static ' & $newIP1 & " " & $newsub, "", @SW_HIDE)
				Else
					$IP = RunWait('netsh interface ip set address name="' & $netName1 & '" static ' & $newIP1 & " " & $newsub & " " & $newgate & ' 1', "", @SW_HIDE)
				EndIf

				
				GUISetState(@SW_HIDE)
				$duplicate = 0
				While ProcessExists($IP)
					Sleep(100)
					If WinExists("Microsoft TCP/IP", "The static IP") Then
						$duplicate = 1
						WinSetOnTop("Microsoft TCP/IP", "The static IP", 1)
						WinWaitClose("Microsoft TCP/IP", "The static IP")
						ExitLoop
						
					EndIf
					
				WEnd
				
				If $duplicate = 0 Then Exit
				
				GUISetState(@SW_SHOW)
				
			EndIf
			
			
			
		Case Else
			;This is the cunning bit that sets the Focus back to the last input box rather than the last button pressed
			If Not StringInStr(ControlGetFocus(""), "button") Then $active = ControlGetFocus("")
			;pressed("{End}")
	EndSwitch
WEnd


Func Pressed($Key)
	
	;New bit to accomodate all 3 ip boxes on first press
	If $ihavepressed = 0 And $active = "Edit4" Then
		_GUICtrlIpAddressClear($Address)
		_GUICtrlIpAddressGet($Address)
		_GUICtrlIpAddressSet($Address, $Address & "0")
		$ihavepressed = 1
	ElseIf $IhavePressedSubnet = 0 And $active = "Edit8" Then
		_GUICtrlIpAddressClear($Subnet)
		_GUICtrlIpAddressGet($Subnet)
		_GUICtrlIpAddressSet($Subnet, $Subnet & "0")
		$IhavePressedSubnet = 1
	ElseIf $ihavepressedGateway = 0 And $active = "Edit12" Then
		_GUICtrlIpAddressClear($gate)
		_GUICtrlIpAddressGet($gate)
		_GUICtrlIpAddressSet($gate, $gate & "0")
		$ihavepressedGateway = 1
		
	EndIf
	
	ControlFocus("", "", $active)
	ConsoleWrite($active & @CRLF)
	ControlSend("", "", $active, $Key, 0)
	
	;new bit auto tab to get to next ip input
	If StringLen(ControlGetText("", "", $active)) = 3 Then _tabAccross()
EndFunc   ;==>Pressed


Func _tabAccross()
	
	Switch $active
		
		Case "Edit4"
			_GUICtrlIpAddressSetFocus($Address, 1)
		Case "Edit3"
			_GUICtrlIpAddressSetFocus($Address, 2)
		Case "Edit2"
			_GUICtrlIpAddressSetFocus($Address, 3)
		Case "Edit1"
			_GUICtrlIpAddressSetFocus($Subnet, 0)
		Case "Edit8"
			_GUICtrlIpAddressSetFocus($Subnet, 1)
		Case "Edit7"
			_GUICtrlIpAddressSetFocus($Subnet, 2)
		Case "Edit6"
			_GUICtrlIpAddressSetFocus($Subnet, 3)
		Case "Edit5"
			_GUICtrlIpAddressSetFocus($gate, 0)
		Case "Edit12"
			_GUICtrlIpAddressSetFocus($gate, 1)
		Case "Edit11"
			_GUICtrlIpAddressSetFocus($gate, 2)
		Case "Edit10"
			_GUICtrlIpAddressSetFocus($gate, 3)
		Case "Edit9"
			_GUICtrlIpAddressSetFocus($Address, 0)
	EndSwitch
EndFunc   ;==>_tabAccross