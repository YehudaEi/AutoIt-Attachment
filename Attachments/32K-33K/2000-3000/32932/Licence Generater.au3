#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=Licence Generator.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#Include <String.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Local $AppName = "Licence generator"
Local $gTxt_Password = "YoUrPaSsWoRd"	;Password to Encrypt and Decrypt

;For testing
Local $LTxt_MAC_Address = _GetMACaddress()
Local $lTxt_ReceivedString = _StringEncrypt(1, $LTxt_MAC_Address ,$gTxt_Password, 1)
;For testing

#Region ### START Koda GUI section ### Form=d:\my documents\02 - tools\01 - autoit created\licence generator\gui_licgen.kxf
$GUI_LicGen = GUICreate($AppName, 309, 130)

$cLbl_ReceivedKey = GUICtrlCreateLabel("Received Key:", 5, 10, 74, 17)
$cTxt_ReceivedKey = GUICtrlCreateInput($lTxt_ReceivedString, 100, 10, 200, 21)

$cLbl_Password = GUICtrlCreateLabel("Encr. Password", 5, 35, 78, 17)
$cTxt_Password = GUICtrlCreateInput($gTxt_Password, 100, 35, 200, 21, BitOR($ES_PASSWORD,$ES_AUTOHSCROLL))


$cLbl_MACAddress = GUICtrlCreateLabel("MAC Address", 5, 60, 80, 17)
$cTxt_MACAddress = GUICtrlCreateInput("", 100, 60, 200, 21, BitOR($ES_AUTOHSCROLL,$ES_READONLY))

$cBtn_Decrypt = GUICtrlCreateButton("Decrypt", 70, 90, 115, 25, $WS_GROUP)
$cBtn_GenerateLicence = GUICtrlCreateButton("Generete Licence", 186, 90, 115, 25, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $cBtn_Decrypt
			$lTxt_Value = _DecryptKey(GUICtrlRead($cTxt_ReceivedKey),GUICtrlRead($cTxt_Password))

			$lArr_Split = StringSplit($lTxt_Value,":")
			Switch True
				Case Stringlen($lTxt_Value) <> 17
					GUICtrlSetData($cTxt_MACAddress,"Invalid key")
				Case $lArr_Split[0] <> 6
					GUICtrlSetData($cTxt_MACAddress,"Invalid key")
				Case Else
					GUICtrlSetData($cTxt_MACAddress,$lTxt_Value)
			EndSwitch

		Case $cBtn_GenerateLicence
			$lTxt_LicenceFile = FileSaveDialog("Save licence",@DesktopDir,"Licences (*.pll)",2+16,"*.pll")
			IF @error Then
				MsgBox(48,$AppName,"Save cancelled.")
			Else
				$lTxt_NewKey = _GenerateLicence(GUICtrlRead($cTxt_ReceivedKey),GUICtrlRead($cTxt_Password))
				$FO = FileOpen($lTxt_LicenceFile,2)
				FileWrite($FO,$lTxt_NewKey)
				FileClose($FO)

				MsgBox(64,$AppName,"Licence succesfully created on:" & @CRLF & @CRLF & $lTxt_LicenceFile)

			EndIf

	EndSwitch
WEnd


Func _DecryptKey($iTxt_ReceivedKey,$iTxt_Password)
	Return _StringEncrypt(0,$iTxt_ReceivedKey,$iTxt_Password,1)
EndFunc


;Use this below in your program
;##############################################################################################
;									START
;##############################################################################################

Local $lTxt_MAC_Address = _GetMACaddress()
Local $lTxt_ReceivedString = _StringEncrypt(1, $LTxt_MAC_Address ,$gTxt_Password, 1)

Func _GenerateLicence($iTxt_ReceivedKey,$iTxt_Password)
	Return _StringEncrypt(1,$iTxt_ReceivedKey,$iTxt_Password,5)
EndFunc

Func _GetMACaddress()
	Local $ERR_NO_INFO = "Array contains no information"
	Local $ERR_NOT_OBJ = "$colItems isnt an object"
	Local $lArr_ComputerInfo = _GetNetworkInfo()

	If @error Then
		$error = @error
		$extended = @extended
		Switch $extended
			Case 1
				_ErrorMsg($ERR_NO_INFO)
			Case 2
				_ErrorMsg($ERR_NOT_OBJ)
		EndSwitch
	Else
		Return $lArr_ComputerInfo[1][10]
	EndIf
EndFunc   ;==>_GetMACaddress

Func _GetNetworkInfo()
	Local $wbemFlagForwardOnly = 0x20
	Local $wbemFlagReturnImmediately = 0x10

	Local $colItems, $objWMIService, $objItem
	Dim $NetworkInfoEx[1][13], $i = 1

	$objWMIService = ObjGet("winmgmts:\\" & @ComputerName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $NetworkInfoEx[UBound($NetworkInfoEx) + 1][13]
			$NetworkInfoEx[$i][0] = $objItem.Caption
			$NetworkInfoEx[$i][1] = $objItem.description
			$NetworkInfoEx[$i][2] = $objItem.IPAddress
			$NetworkInfoEx[$i][3] = $objItem.IPSubnet
			$NetworkInfoEx[$i][4] = $objItem.DefaultIPGateway
			$NetworkInfoEx[$i][5] = $objItem.DHCPEnabled
			$NetworkInfoEx[$i][6] = $objItem.DHCPServer
			$NetworkInfoEx[$i][7] = $objItem.DNSDomain
			$NetworkInfoEx[$i][8] = $objItem.DNSHostName
			$NetworkInfoEx[$i][9] = $objItem.DNSServerSearchOrder
			$NetworkInfoEx[$i][10] = $objItem.MACAddress
			$NetworkInfoEx[$i][11] = $objItem.WINSPrimaryServer
			$NetworkInfoEx[$i][12] = $objItem.WINSSecondaryServer
			$i += 1
		Next
		$NetworkInfoEx[0][0] = UBound($NetworkInfoEx) - 1
		If $NetworkInfoEx[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
	Return $NetworkInfoEx
EndFunc   ;==>_GetNetworkInfo

Func _ErrorMsg($message, $time = 0)
	MsgBox(48 + 262144, "Network Error", $message, $time)
EndFunc   ;==>_ErrorMsg
;##############################################################################################
;									END
;##############################################################################################