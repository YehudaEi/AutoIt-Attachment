#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=CEDUtilv3.1.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=y
#AutoIt3Wrapper_Res_Fileversion=3.1
#AutoIt3Wrapper_Res_SaveSource=y
#AutoIt3Wrapper_AU3Check_Stop_OnWarning=y
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
AutoItSetOption("MustDeclareVars", 1)
Global $iIPAddress, $iIPO1, $iIPO2, $iIPO3, $iIPO4
EmbedCreatePuttyDirectoryFile()
CreatePuttyDir_CopyPutty()
#include <WinAPI.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiIPAddress.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ###
Global $hCEDForm = GUICreate("CED Help Desk Utility", 443, 274, 242, 160)
GUISetBkColor(0xA6CAF0)
Global $hPCTools = GUICtrlCreateGroup("Profit Center Tools", 24, 16, 185, 241)
Global $hLabelPCNum = GUICtrlCreateLabel("PC Number", 40, 40, 58, 17)
Global $hPCNumInput = GUICtrlCreateInput("", 40, 59, 31, 21, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER))
GUICtrlSetLimit(-1, 4)
Global $hButtonCheckBoxStatus = GUICtrlCreateButton("Execute Checked Items", 40, 212, 125, 25)
Global $hCheckboxPingPC = GUICtrlCreateCheckbox("Ping PC Gateway", 40, 92, 115, 25)
Global $hCheckboxFortiWiFiWeb = GUICtrlCreateCheckbox("Forti WiFi Web Login", 40, 122, 115, 25)
Global $hCheckboxFortiWiFiPutty = GUICtrlCreateCheckbox("Forti WiFi Putty Login", 40, 152, 115, 25)
Global $hCheckboxRDCEDSvr = GUICtrlCreateCheckbox("Remote Desktop CED Server", 40, 182, 155, 25)
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $hLableNetworkTools = GUICtrlCreateGroup("Network Tools", 232, 16, 185, 241)
Global $hButtonPingIPInput = GUICtrlCreateButton("Ping IP Address", 248, 122, 125, 25)
Global $hCheckboxClearIP = GUICtrlCreateCheckbox("Clear IP After Execution", 248, 92, 127, 25)
Global $hLabelIPAddress = GUICtrlCreateLabel("IP Address", 248, 40, 58, 17)
Global $hIPAddressInput = GUICtrlCreateInput("", 248, 59, 105, 21)
GUICtrlSetLimit(-1, 15)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $hButtonPingIPInput
			PingIPInput()
		Case $hButtonCheckBoxStatus
			GetPCNumber()
			CheckBoxStatus()
	EndSwitch

	Local $aCursorInfo = GUIGetCursorInfo($hCEDForm)
	If $aCursorInfo[2] Then
		If $aCursorInfo[4] = $hPCNumInput Then GUICtrlSetData($hPCNumInput, "")
	EndIf
WEnd

_WinAPI_SetFocus(ControlGetHandle("CED Help Desk Utility", "", $hPCNumInput))

;Profit Center Tools ----------

;Ping PC Gateway
Func PingPCGateway()
	$iIPO1 = 10
	$iIPO4 = 1
	IPAddress()
	If $iIPO2 = 0 Then
		Return
	EndIf
	PingCmd()
EndFunc   ;==>PingPCGateway

;FortiWiFi Web Login
Func FortiWiFiWebLogin()
	$iIPO1 = 10
	$iIPO4 = 1
	IPAddress()
	If $iIPO2 = 0 Then
		Return
	EndIf
	If $iIPAddress = "10.49.95.1" Then
		ShellExecute("https://" & $iIPAddress & ":444")
	Else
		ShellExecute("https://" & $iIPAddress)
	EndIf
EndFunc   ;==>FortiWiFiWebLogin

;FortiWiFi Putty Login
Func FortiWiFiPuttyLogin()
	$iIPO1 = 10
	$iIPO4 = 1
	IPAddress()
	If $iIPO2 = 0 Then
		Return
	EndIf
	IPAddress()
	PuttyLogin()
EndFunc   ;==>FortiWiFiPuttyLogin

;Remote Desktop to CEDNet Server
Func RDCEDSvr()
	$iIPO1 = 10
	$iIPO4 = 250
	IPAddress()
	Run("mstsc.exe /v:" & $iIPAddress & " /f")
EndFunc   ;==>RDCEDSvr

;Extrapolate Second and Third Octet From PC Number
Func GetPCNumber()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	If $iPCNumber > "" Then
		$iIPO2 = StringRegExpReplace($iPCNumber, "\d{2}$", "")

		$iIPO3 = StringRegExpReplace($iPCNumber, "^\d{2}", "")

		If StringTrimRight($iIPO2, 1) = 0 Then
			$iIPO2 = StringTrimLeft($iIPO2, 1)
		EndIf

		If StringTrimRight($iIPO3, 1) = 0 Then
			$iIPO3 = StringTrimLeft($iIPO3, 1)
		EndIf
		If $iIPO3 = 0 Then
			$iIPO3 = 100
		EndIf
		;MsgBox(0, "", $iIPO2)
		;MsgBox(0, "", $iIPO3)

	ElseIf $iPCNumber = "" Then
		MsgBox(262160, "Invalid Entry", "Please Enter a Valid Four Digit PC Number")
		_WinAPI_SetFocus(ControlGetHandle("CED Help Desk Utility", "", $hPCNumInput))
	EndIf
EndFunc   ;==>GetPCNumber

;Combine IP Address Octets
Func IPAddress()
	$iIPAddress = ($iIPO1 & "." & $iIPO2 & "." & $iIPO3 & "." & $iIPO4)
EndFunc   ;==>IPAddress

;Ping Command
Func PingCmd()
	Run(@ComSpec & " /k" & "ping.exe -t " & $iIPAddress)
EndFunc   ;==>PingCmd

;Putty Login
Func PuttyLogin()
	Run("putty.exe " & $iIPAddress)
EndFunc   ;==>PuttyLogin

;Create Putty Directory and Copy Putty.exe
Func CreatePuttyDir_CopyPutty()
	Local $PuttyFile = "c:\Program files\PuTTY\putty.exe"
	If FileExists($PuttyFile) = 1 Then
		FileDelete(@WorkingDir & "\CreatePuttyDirectory.exe")
		Return
	ElseIf FileExists($PuttyFile) = 0 Then
		ShellExecute("CreatePuttyDirectory.exe", @WorkingDir, @SW_HIDE)
	EndIf
EndFunc   ;==>CreatePuttyDir_CopyPutty

;Embed Putty.exe When Compiled
Func EmbedCreatePuttyDirectoryFile()
	Local $PuttyFile = "c:\Program files\PuTTY\putty.exe"
	If FileExists($PuttyFile) Then
		Return
	Else
		FileInstall("C:\PuTTy\putty.exe", @WorkingDir & "\")
		FileInstall("C:\PuTTy\CreatePuttyDirectory.exe", @WorkingDir & "\")
	EndIf
EndFunc   ;==>EmbedCreatePuttyDirectoryFile

;Check Check Box Status For PC Tools
Func CheckBoxStatus()
	Local $iPCNumber = GUICtrlRead($hPCNumInput)
	If $iPCNumber = "" Then
		Return
	Else
		Local $CheckboxPingPCStatus = ControlCommand($hCEDForm, "", $hCheckboxPingPC, "IsChecked")
		Local $CheckboxFortiWiFiWebStatus = ControlCommand($hCEDForm, "", $hCheckboxFortiWiFiWeb, "IsChecked")
		Local $CheckboxFortiWiFiPuttyStatus = ControlCommand($hCEDForm, "", $hCheckboxFortiWiFiPutty, "IsChecked")
		Local $hCheckboxRDCEDSvrStatus = ControlCommand($hCEDForm, "", $hCheckboxRDCEDSvr, "IsChecked")
		If $CheckboxPingPCStatus = 1 Then
			PingPCGateway()
		EndIf
		If $CheckboxFortiWiFiWebStatus = 1 Then
			FortiWiFiWebLogin()
		EndIf
		If $CheckboxFortiWiFiPuttyStatus = 1 Then
			FortiWiFiPuttyLogin()
		EndIf
		If $hCheckboxRDCEDSvrStatus = 1 Then
			RDCEDSvr()
		EndIf
	EndIf
EndFunc   ;==>CheckBoxStatus


; Network Tools ----------

; Ping IP Address
Func PingIPInput()
	Local $CheckboxClearIPStatus = ControlCommand($hCEDForm, "", $hCheckboxClearIP, "IsChecked")
	Local $PingIPAddressInput = GUICtrlRead($hIPAddressInput)
	Run(@ComSpec & " /k" & "ping.exe -t " & $PingIPAddressInput)
	If $CheckboxClearIPStatus = 1 Then
		GUICtrlSetData($hIPAddressInput, "")
	EndIf
EndFunc   ;==>PingIPInput
