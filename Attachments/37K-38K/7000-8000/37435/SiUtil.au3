#include-once
#AutoIt3Wrapper_UseX64=n

;~ ##################################################################
;~ #		SiUtil UDF written by Andreik (andy@skullbox.info)		#
;~ ##################################################################

Global $hDLL

Func SiUtil_Init($sDLL='SiUtil.dll')
	$hDLL = DllOpen($sDLL)
	If @error Then
		SetError(@error,0,False)
	Else
		Return True
	EndIf
EndFunc

Func SiUtil_UnInit()
	DllClose($hDLL)
	Return True
EndFunc

Func SiUtil_Connect($nComPort=1,$nDisableDialogBoxes=0,$nECprotocol=0,$nBaudRateIndex=0)
	$aRet = DllCall($hDLL,"long","Connect","int",$nComPort,"int",$nDisableDialogBoxes,"int",$nECprotocol,"int",$nBaudRateIndex)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_Disconnect($nComPort=1)
	$aRet = DllCall($hDLL,"long","Disconnect","int",$nComPort)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_ConnectUSB($sSerialNum="",$nECprotocol=0,$nPowerTarget=0,$nDisableDialogBoxes=0)
	$aRet = DllCall($hDLL,"long","ConnectUSB","str",$sSerialNum,"int",$nECprotocol,"int",$nPowerTarget,"int",$nDisableDialogBoxes)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_DisconnectUSB()
	$aRet = DllCall($hDLL,"long","DisconnectUSB")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_Connected()
	$aRet = DllCall($hDLL,"BOOL","Connected")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_Download($sDownloadFile,$nDeviceErase=0,$nDisableDialogBoxes=0,$nDownloadScratchPadSFLE=0,$nBankSelect=-1,$nLockFlash=0,$bPersistFlash=True)
	$aRet = DllCall($hDLL,"long","Download","str",$sDownloadFile,"int",$nDeviceErase,"int",$nDisableDialogBoxes,"int",$nDownloadScratchPadSFLE,"int",$nBankSelect,"int",$nLockFlash,"BOOL",$bPersistFlash)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_ISupportBanking($pSupportedBanks)
	$aRet = DllCall($hDLL,"long","ISupportBanking","ptr",$pSupportedBanks)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetSAFirmwareVersion()
	$aRet = DllCall($hDLL,"int","GetSAFirmwareVersion")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetUSBFirmwareVersion()
	$aRet = DllCall($hDLL,"int","GetUSBFirmwareVersion")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetDLLVersion()
	$aRet = DllCall($hDLL,"str","GetDLLVersion")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetDeviceName($psDeviceName)
	$aRet = DllCall($hDLL,"long","GetDeviceName","ptr",$psDeviceName)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetRAMMemory($ptrMem,$wStartAddress,$nLength)
	$aRet = DllCall($hDLL,"long","GetRAMMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetXRAMMemory($ptrMem,$wStartAddress,$nLength);)
	$aRet = DllCall($hDLL,"long","GetXRAMMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func GetCodeMemory($ptrMem,$wStartAddress,$nLength);)
	$aRet = DllCall($hDLL,"long","GetCodeMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetRAMMemory($ptrMem,$wStartAddress,$nLength)
	$aRet = DllCall($hDLL,"long","SetRAMMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetXRAMMemory($ptrMem,$wStartAddress,$nLength)
	$aRet = DllCall($hDLL,"long","SetXRAMMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetCodeMemory($ptrMem,$wStartAddress,$nLength)
	$aRet = DllCall($hDLL,"long","SetCodeMemory","ptr",$ptrMem,"DWORD",$wStartAddress,"uint",$nLength)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetTargetGo()
	$aRet = DllCall($hDLL,"long","SetTargetGo")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetTargetHalt()
	$aRet = DllCall($hDLL,"long","SetTargetHalt")
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_USBDebugDevices($pdwDevices)
	$aRet = DllCall($hDLL,"long","USBDebugDevices","ptr",$pdwDevices)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetUSBDeviceSN($dwDeviceNum,$psSerialNum)
	$aRet = DllCall($hDLL,"long","GetUSBDeviceSN","DWORD",$dwDeviceNum,"ptr",$psSerialNum)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetUSBDLLVersion($pVersionString)
	$aRet = DllCall($hDLL,"long","GetUSBDLLVersion","ptr",$pVersionString)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_FLASHErase($nComPort=1,$nDisableDialogBoxes=0,$nECprotocol=0)
	$aRet = DllCall($hDLL,"long","FLASHErase","int",$nComPort,"int",$nDisableDialogBoxes,"int",$nECprotocol)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_FLASHEraseUSB($sSerialNum,$nDisableDialogBoxes=0,$nECprotocol=0)
	$aRet = DllCall($hDLL,"long","FLASHEraseUSB","str",$sSerialNum,"int",$nDisableDialogBoxes,"int",$nECprotocol)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetJTAGDeviceAndConnect($nComPort=1,$nDisableDialogBoxes=0,$DevicesBeforeTarget=0,$DevicesAfterTarget=0,$IRBitsBeforeTarget=0,$IRBitsAfterTarget=0)
	$aRet = DllCall($hDLL,"long","SetJTAGDeviceAndConnect","int",$nComPort,"int",$nDisableDialogBoxes,"BYTE",$DevicesBeforeTarget,"BYTE",$DevicesAfterTarget,"WORD",$IRBitsBeforeTarget,"WORD",$IRBitsAfterTarget)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_SetJTAGDeviceAndConnectUSB($sSerialNum,$nPowerTarget=0,$nDisableDialogBoxes=0,$DevicesBeforeTarget=0,$DevicesAfterTarget=0,$IRBitsBeforeTarget=0,$IRBitsAfterTarget=0)
	$aRet = DllCall($hDLL,"long","SetJTAGDeviceAndConnectUSB","str",$sSerialNum,"int",$nPowerTarget,"int",$nDisableDialogBoxes,"BYTE",$DevicesBeforeTarget,"BYTE",$DevicesAfterTarget,"WORD",$IRBitsBeforeTarget,"WORD",$IRBitsAfterTarget)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc

Func SiUtil_GetErrorMsg($errorCode)
	$aRet = DllCall($hDLL,"str","GetErrorMsg","long",$errorCode)
	If @error Then
		SetError(@error,0,False)
	Else
		Return $aRet[0]
	EndIf
EndFunc