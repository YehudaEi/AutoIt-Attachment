#include <GuiConstants.au3>
#include <File.au3>
#include <array.au3>
#include <GuiButton.au3>
#include <WindowsConstants.au3>


Global $But1, $But2, $But3, $But4, $But5, $i, $Cancel, $ok, $msg, $value, $Test_Button
Global $But6, $But7, $But8, $But9, $But10
Global $port1, $port2, $port3, $Info1, $Info2, $Info3, $Info4, $Info5, $Info6, $Info7, $Info8, $Info9
Global $test_status1, $test_status2, $test_status3, $test_status4, $test_status5, $test_status6, $test_status7, $test_status8, $test_status9, $test_status10


Dim $aAdapters[10][3]

Ask()
Func Ask()
	GUICreate("IP Config", 400, 500)
	Opt("GUICoordMode", 1)
	GUISetFont(12, 800, 4, "Arial")
	GUICtrlCreateLabel("Simple IP Config Test", 125, 20, 200)
	GUISetFont(10, 800, 0, "Arial")
	GUICtrlCreateLabel("Display", 160, 70, 200)
	$value = InputBox("", "What is the TOTAL number of Network Ports?", "", " M2")
	$ok = GUICtrlCreateButton("OK", 100, 400, 80)
	$Cancel = GUICtrlCreateButton("Cancel/Exit", 200, 400, 80)

	If $value = 1 Then
		MakeMe()
		Button1()
	EndIf

	If $value = 2 Then
		MakeMe()
		Button2()
	EndIf

	If $value = 3 Then
		MakeMe()
		Button3()
	EndIf

	If $value = 4 Then
		MakeMe()
		Button4()
	EndIf

	If $value = 5 Then
		MakeMe()
		Button5()
	EndIf

	If $value = 6 Then
		MakeMe()
		Button6()
	EndIf

	If $value = 7 Then
		MakeMe()
		Button7()
	EndIf

	If $value = 8 Then
		MakeMe()
		Button8()
	EndIf

	If $value = 9 Then
		MakeMe()
		Button9()
	EndIf

	If $value = 10 Then
		MakeMe()
		Button10()
	EndIf

	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>Ask


Func MakeMe()
	GUICreate("IP Config", 400, 500)
	Opt("GUICoordMode", 1)
	GUISetFont(12, 800, 4, "Arial")
	GUICtrlCreateLabel("Simple IP Config Test", 115, 20, 200)
	GUISetFont(10, 800, 0, "Arial")
	GUICtrlCreateLabel("Ports to Test = ", 140, 70, 200)
	GUICtrlCreateLabel($value, 235, 70)
	$Test_Button = GUICtrlCreateButton("Click to Test", 125, 450, 150, 20)
	GUICtrlCreateLabel("Plug in the Network cable into your first port", 40, 400, 300)
	GUICtrlCreateLabel("Click on the Test Button", 40, 420, 300)

	GUISetState()

EndFunc   ;==>MakeMe


Func Button1()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	If $value = "1" Then
		_GUICtrlButton_Show($But1)
	Else
		_GUICtrlButton_Show($But1, False)
	EndIf
	$test_status1 = ""
	_Button_color()
EndFunc   ;==>Button1

Func Button2()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	If $value = "2" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
	EndIf
	$test_status2 = ""
	_Button_color()
EndFunc   ;==>Button2

Func Button3()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	If $value = "3" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
	EndIf
	$test_status3 = ""
	_Button_color()
EndFunc   ;==>Button3

Func Button4()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	If $value = "4" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
	EndIf
	$test_status4 = ""
	_Button_color()
EndFunc   ;==>Button4

Func Button5()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	If $value = "5" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
	EndIf
	$test_status5 = ""
	_Button_color()
EndFunc   ;==>Button5

Func Button6()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	$But6 = GUICtrlCreateButton("6th Port", 05, 210, 70, 20)
	If $value = "6" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
		_GUICtrlButton_Show($But6)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
		_GUICtrlButton_Show($But6, False)
	EndIf
	$test_status6 = ""
	_Button_color()
EndFunc   ;==>Button6

Func Button7()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	$But6 = GUICtrlCreateButton("6th Port", 05, 210, 70, 20)
	$But7 = GUICtrlCreateButton("7th Port", 85, 210, 70, 20)
	If $value = "7" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
		_GUICtrlButton_Show($But6)
		_GUICtrlButton_Show($But7)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
		_GUICtrlButton_Show($But6, False)
		_GUICtrlButton_Show($But7, False)
	EndIf
	$test_status7 = ""
	_Button_color()
EndFunc   ;==>Button7

Func Button8()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	$But6 = GUICtrlCreateButton("6th Port", 05, 210, 70, 20)
	$But7 = GUICtrlCreateButton("7th Port", 85, 210, 70, 20)
	$But8 = GUICtrlCreateButton("8th Port", 165, 210, 70, 20)
	If $value = "8" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
		_GUICtrlButton_Show($But6)
		_GUICtrlButton_Show($But7)
		_GUICtrlButton_Show($But8)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
		_GUICtrlButton_Show($But6, False)
		_GUICtrlButton_Show($But7, False)
		_GUICtrlButton_Show($But8, False)
	EndIf
	$test_status8 = ""
	_Button_color()
EndFunc   ;==>Button8

Func Button9()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	$But6 = GUICtrlCreateButton("6th Port", 05, 210, 70, 20)
	$But7 = GUICtrlCreateButton("7th Port", 85, 210, 70, 20)
	$But8 = GUICtrlCreateButton("8th Port", 165, 210, 70, 20)
	$But9 = GUICtrlCreateButton("9th Port", 245, 210, 70, 20)
	If $value = "9" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
		_GUICtrlButton_Show($But6)
		_GUICtrlButton_Show($But7)
		_GUICtrlButton_Show($But8)
		_GUICtrlButton_Show($But9)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
		_GUICtrlButton_Show($But6, False)
		_GUICtrlButton_Show($But7, False)
		_GUICtrlButton_Show($But8, False)
		_GUICtrlButton_Show($But9, False)
	EndIf
	$test_status9 = ""
	_Button_color()
EndFunc   ;==>Button9

Func Button10()
	$But1 = GUICtrlCreateButton("1st Port", 05, 170, 70, 20)
	$But2 = GUICtrlCreateButton("2nd Port", 85, 170, 70, 20)
	$But3 = GUICtrlCreateButton("3rd Port", 165, 170, 70, 20)
	$But4 = GUICtrlCreateButton("4th Port", 245, 170, 70, 20)
	$But5 = GUICtrlCreateButton("5th Port", 325, 170, 70, 20)
	$But6 = GUICtrlCreateButton("6th Port", 05, 210, 70, 20)
	$But7 = GUICtrlCreateButton("7th Port", 85, 210, 70, 20)
	$But8 = GUICtrlCreateButton("8th Port", 165, 210, 70, 20)
	$But9 = GUICtrlCreateButton("9th Port", 245, 210, 70, 20)
	$But10 = GUICtrlCreateButton("10th Port", 325, 210, 70, 20)
	If $value = "10" Then
		_GUICtrlButton_Show($But1)
		_GUICtrlButton_Show($But2)
		_GUICtrlButton_Show($But3)
		_GUICtrlButton_Show($But4)
		_GUICtrlButton_Show($But5)
		_GUICtrlButton_Show($But6)
		_GUICtrlButton_Show($But7)
		_GUICtrlButton_Show($But8)
		_GUICtrlButton_Show($But9)
		_GUICtrlButton_Show($But10)
	Else
		_GUICtrlButton_Show($But1, False)
		_GUICtrlButton_Show($But2, False)
		_GUICtrlButton_Show($But3, False)
		_GUICtrlButton_Show($But4, False)
		_GUICtrlButton_Show($But5, False)
		_GUICtrlButton_Show($But6, False)
		_GUICtrlButton_Show($But7, False)
		_GUICtrlButton_Show($But8, False)
		_GUICtrlButton_Show($But9, False)
		_GUICtrlButton_Show($But10, False)
	EndIf
	$test_status10 = ""
	_Button_color()
EndFunc   ;==>Button10



Func _Button_color()
	If $test_status1 = "Fail" Then
		GUICtrlSetBkColor($But1, 0xEE3B3B); red
	ElseIf $test_status1 = "Pass" Then
		GUICtrlSetBkColor($But1, 0x228B22); green
	ElseIf $test_status1 = "" Then
		GUICtrlSetBkColor($But1, 0xFFFFFF); white
	EndIf

	If $test_status2 = "Fail" Then
		GUICtrlSetBkColor($But2, 0xEE3B3B); red
	ElseIf $test_status2 = "Pass" Then
		GUICtrlSetBkColor($But2, 0x228B22); green
	ElseIf $test_status2 = "" Then
		GUICtrlSetBkColor($But2, 0xFFFFFF); white
	EndIf

	If $test_status3 = "Fail" Then
		GUICtrlSetBkColor($But3, 0xEE3B3B); red
	ElseIf $test_status3 = "Pass" Then
		GUICtrlSetBkColor($But3, 0x228B22); green
	ElseIf $test_status3 = "" Then
		GUICtrlSetBkColor($But3, 0xFFFFFF); white
	EndIf

	If $test_status4 = "Fail" Then
		GUICtrlSetBkColor($But4, 0xEE3B3B); red
	ElseIf $test_status4 = "Pass" Then
		GUICtrlSetBkColor($But4, 0x228B22); green
	ElseIf $test_status4 = "" Then
		GUICtrlSetBkColor($But4, 0xFFFFFF); white
	EndIf

	If $test_status5 = "Fail" Then
		GUICtrlSetBkColor($But5, 0xEE3B3B); red
	ElseIf $test_status5 = "Pass" Then
		GUICtrlSetBkColor($But5, 0x228B22); green
	ElseIf $test_status5 = "" Then
		GUICtrlSetBkColor($But5, 0xFFFFFF); white
	EndIf

	If $test_status6 = "Fail" Then
		GUICtrlSetBkColor($But6, 0xEE3B3B); red
	ElseIf $test_status6 = "Pass" Then
		GUICtrlSetBkColor($But6, 0x228B22); green
	ElseIf $test_status6 = "" Then
		GUICtrlSetBkColor($But6, 0xFFFFFF); white
	EndIf

	If $test_status7 = "Fail" Then
		GUICtrlSetBkColor($But7, 0xEE3B3B); red
	ElseIf $test_status7 = "Pass" Then
		GUICtrlSetBkColor($But7, 0x228B22); green
	ElseIf $test_status7 = "" Then
		GUICtrlSetBkColor($But7, 0xFFFFFF); white
	EndIf

	If $test_status8 = "Fail" Then
		GUICtrlSetBkColor($But8, 0xEE3B3B); red
	ElseIf $test_status8 = "Pass" Then
		GUICtrlSetBkColor($But8, 0x228B22); green
	ElseIf $test_status8 = "" Then
		GUICtrlSetBkColor($But8, 0xFFFFFF); white
	EndIf

	If $test_status9 = "Fail" Then
		GUICtrlSetBkColor($But9, 0xEE3B3B); red
	ElseIf $test_status9 = "Pass" Then
		GUICtrlSetBkColor($But9, 0x228B22); green
	ElseIf $test_status9 = "" Then
		GUICtrlSetBkColor($But9, 0xFFFFFF); white
	EndIf

	If $test_status10 = "Fail" Then
		GUICtrlSetBkColor($But10, 0xEE3B3B); red
	ElseIf $test_status10 = "Pass" Then
		GUICtrlSetBkColor($But10, 0x228B22); green
	ElseIf $test_status10 = "" Then
		GUICtrlSetBkColor($But10, 0xFFFFFF); white
	EndIf

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Test_Button
				GetNics()
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch

	WEnd

EndFunc   ;==>_Button_color


Func GetNics()
	Global $ConnNum
	Global $avArray[3]
	Global $new ;($aAdapters)
	Local $Info1 = 0, $Info2 = 0, $Info3 = 0;, $Info4, $Info5, $Info6, $Info7, $Info8, $Info9
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

		$i = 0

		Do
			$aAdapters[$i][0] = DllStructGetData($adapter, "Description")
			$aAdapters[$i][1] = RegRead($NETWORK_REG_KEY & DllStructGetData($adapter, "AdapterName") & "\Connection", "Name")
			$aAdapters[$i][2] = DllStructGetData(DllStructCreate($tagIP_ADDR_STRING, DllStructGetPtr($adapter, "IpAddressListNext")), "IPAddress")
			$Info1 = ($aAdapters[0][0])
			$Info2 = ($aAdapters[0][1])
			$Info3 = ($aAdapters[0][2])

			$i += 1
			$ptr = DllStructGetData($adapter, "Next")
			$adapter = DllStructCreate($tagIP_ADAPTER_INFO, $ptr)

		Until @error


		ReDim $aAdapters[$i][3]

		If $Info2 = "" Then
			$test_status1 = "Fail"
		Else
			$test_status1 = "Pass"
		EndIf

		_Button_color()


		ReDim $aAdapters[$i][3]
	EndIf
	Return $aAdapters

EndFunc   ;==>GetNics

GUISetState(@SW_SHOW)



