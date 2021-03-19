#include <GuiConstants.au3>
#include <File.au3>
#include <array.au3>

Global $But, $But1, $But2, $i, $test_status, $Cancel, $ok
Global $port1, $port2, $port3, $Info1, $Info2, $Info3
Local $MakeMe0 = ""
Local $MakeMe1 = $But1
Local $MakeMe2 = $But, $But2
Dim $aAdapters[10][3]

Ask()
Func Ask()
	GUICreate("IP Config", 400, 500)
	Opt("GUICoordMode", 1)
	GUISetFont(12, 800, 4, "Arial")
	GUICtrlCreateLabel("Simple IP Config Test", 125, 20, 200)
	GUISetFont(10, 800, 0, "Arial")
	GUICtrlCreateLabel("Display", 160, 70, 200)
	Local $value = InputBox("", "What is the TOTAL number of Network Ports?", "", " M2")
	$ok = GUICtrlCreateButton("OK", 100, 400, 80)
	$Cancel = GUICtrlCreateButton("Cancel/Exit", 200, 400, 80)

	GUISetState()
	If $value = 1 Then
		MakeBox()
		NP1_But()
	EndIf

	If $value = 2 Then
		MakeBox()
		NP2_But()
		;EndIf
		Do
			$msg = GUIGetMsg()

			Select
				Case $msg = $Cancel

				Case $msg = $GUI_EVENT_CLOSE
			EndSelect
		Until $msg = $GUI_EVENT_CLOSE Or $msg = $Cancel
	EndIf
	Ask()
EndFunc   ;==>Ask


Func MakeBox()
	GUICreate("IP Config", 400, 500)
	Opt("GUICoordMode", 1)
	GUISetFont(12, 800, 4, "Arial")
	GUICtrlCreateLabel("Simple IP Config Test", 125, 20, 200)
	GUISetFont(10, 800, 0, "Arial")
	GUICtrlCreateLabel("Display", 160, 70, 200)
	$Cancel = GUICtrlCreateButton("Cancel/Exit", 200, 400, 80)
EndFunc   ;==>MakeBox

Func NP1_But() ; NP1 is Network Port 1 (button)
	$But1 = GUICtrlCreateButton("First Network Port", 40, 170, 120, 20)
	GUICtrlCreateLabel("Plug in the Network cable into your first port", 40, 130, 300)
	GUICtrlCreateLabel("Click on the First Network Port Button", 40, 150, 300)
	$test_status = ""
	_Button_color()

	GUISetState(@SW_SHOW)

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $But1
				GetNics()
		EndSwitch
	WEnd
EndFunc   ;==>NP1_But

Func NP2_But() ; NP2 is Network Port 2 (button)
	$But1 = GUICtrlCreateButton("First Network Port", 40, 170, 120, 20)
	GUICtrlCreateLabel("Plug in the Network cable into your first port", 40, 130, 300)
	GUICtrlCreateLabel("Click on the First Network Port Button", 40, 150, 300)
	$test_status = ""
	_Button_color()
	$But2 = GUICtrlCreateButton("Second Network Port", 40, 240, 120, 20)
	GUICtrlCreateLabel("Plug in the Network cable into your second port", 40, 200, 300)
	GUICtrlCreateLabel("Click on the Second Network Port Button", 40, 220, 300)
	$test_status = ""
	_Button_color()

	GUISetState(@SW_SHOW)

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $But2
				GetNics()
		EndSwitch
	WEnd
EndFunc   ;==>NP2_But

Func _Button_color()
	$test_status = GUIGetMsg()
	Select
		Case $test_status = "0"
			GUICtrlSetBkColor($But1, 0xFFFFFF); white
		Case $test_status = "Pass"
			GUICtrlSetBkColor($But1, 0xEE3B3B); green
		Case $test_status = "Fail"
			GUICtrlSetBkColor($But1, 0x228B22); red
	EndSelect
EndFunc   ;==>_Button_color


Func GetNics()
	Global $ConnNum
	Global $avArray[3]
	Global $new ;($aAdapters)
	Local $Info1, $Info2, $Info3, $Info4, $Info5, $Info6
	Local $NETWORK_REG_KEY = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Network\{4D36E972-E325-11CE-BFC1-08002BE10318}\"
	Local $tagIP_ADDRESS_STRING = "char IPAddress[16];"
	Local $tagIP_MASK_STRING = "char IPMask[16];"
	Local $tagIP_ADDR_STRING = "ptr Next;" & $tagIP_ADDRESS_STRING & $tagIP_MASK_STRING & "DWORD Context;"
	Local $tagIP_ADAPTER_INFO = "ptr Next; DWORD ComboIndex; char AdapterName[260];char Description[132]; UINT AddressLength; BYTE Address[8]; dword Index; UINT Type;" & _
			" UINT DhcpEnabled; ptr CurrentIpAddress; ptr IpAddressListNext; char IpAddressListADDRESS[16]; char IpAddressListMASK[16]; DWORD IpAddressListContext; " & _
			"ptr GatewayListNext; char GatewayListADDRESS[16]; char GatewayListMASK[16]; DWORD GatewayListContext; " & _
			"ptr DhcpServerNext; char DhcpServerADDRESS[16]; char DhcpServerMASK[16]; DWORD DhcpServerContext; " & _
			"int HaveWins; " & _
			"ptr PrimaryWinsServerNext; char PrimaryWinsServerADDRESS[16]; char PrimaryWinsServerMASK[16]; DWORD PrimaryWinsServerContext; " & _
			"ptr SecondaryWinsServerNext; char SecondaryWinsServerADDRESS[16]; char SecondaryWinsServerMASK[16]; DWORD SecondaryWinsServerContext; " & _
			"DWORD LeaseObtained; DWORD LeaseExpires;"
	Local $dll = DllOpen("Iphlpapi.dll")
	Local $ret = DllCall($dll, "dword", "GetAdaptersInfo", "ptr", 0, "dword*", 0)
	Local $adapterBuffer = DllStructCreate("byte[" & $ret[2] & "]")
	Local $adapterBuffer_pointer = DllStructGetPtr($adapterBuffer)
	Local $return = DllCall($dll, "dword", "GetAdaptersInfo", "ptr", $adapterBuffer_pointer, "dword*", $ret[2])
	Local $adapter = DllStructCreate($tagIP_ADAPTER_INFO, $adapterBuffer_pointer)


	If Not @error Then
		Dim $aAdapters[10][3]
		;Local $new ($aAdapters)
		$i = 0

		Do
			$aAdapters[$i][0] = DllStructGetData($adapter, "Description")
			$aAdapters[$i][1] = RegRead($NETWORK_REG_KEY & DllStructGetData($adapter, "AdapterName") & "\Connection", "Name")
			$aAdapters[$i][2] = DllStructGetData(DllStructCreate($tagIP_ADDR_STRING, DllStructGetPtr($adapter, "IpAddressListNext")), "IPAddress")
			;_ArrayToString ($aAdapters[$i][1])
			;StringRight ($aAdapters,2)
			$Info1 = ($aAdapters[0][0])
			$Info2 = ($aAdapters[0][1])
			$Info3 = ($aAdapters[0][2])
			$Info4 = ($aAdapters[1][0])
			$Info5 = ($aAdapters[1][1])
			$Info6 = ($aAdapters[1][2])
			_ArrayToString($aAdapters[$i][1])
			Local $endchar = StringRight($aAdapters[$i][1], 2)
			ConsoleWrite($endchar & @LF)

			Select
				Case $endchar = "on"
					$port1 = ($aAdapters[$i][1])
					SplashTextOn("First Network Port", $Info1 & @LF & $Info2 & @LF & $Info3 & @LF)
					Sleep(3000)
					SplashOff()
					If $Info2 = "" Or $Info3 = "0.0.0.0" Then
						$test_status = "Fail"
					Else
						$test_status = "Pass"
					EndIf
					_Button_color()
				Case $endchar = " 1"
					$port2 = ($aAdapters[$i][1])
					SplashTextOn("Second Network Port", $Info4 & @LF & $Info5 & @LF & $Info6 & @LF)
					Sleep(3000)
					SplashOff()
					If $Info5 = "" Or $Info6 = "0.0.0.0" Then
						$test_status = "Fail"
					Else
						$test_status = "Pass"
					EndIf
					_Button_color()
				Case $endchar = " 2"
					$port3 = ($aAdapters[$i][1])

			EndSelect
			$i += 1

			$ptr = DllStructGetData($adapter, "Next")
			$adapter = DllStructCreate($tagIP_ADAPTER_INFO, $ptr)
		Until @error


		ReDim $aAdapters[$i][3]
	EndIf
	Return $aAdapters

EndFunc   ;==>GetNics
