#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Info 3.ico
#AutoIt3Wrapper_Res_Comment=Displays Service tag, computer name and model
#AutoIt3Wrapper_Res_Fileversion=0.0.0.1
#AutoIt3Wrapper_Res_LegalCopyright=GreenCan
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Misc.au3>

#cs
Get some collection of information to help user open a ticket at the service desk

User ID: 	Login Name of User

Model: 		Model of PC
Service Tag: 	Service tag or serial number of the PC (Tested on Dell)
Computer Name: 	Identification of the PC
IP Address: 	All Network adaptors with IP address
	If not currently used mentions '(Disabled)' after the IP address
		WLan connection : xxx.xxx.xxx.xxx
		LAN Connection   : xxx.xxx.xxx.xxx (Disabled)

Putclip when done
#ce

Global Const $wbemFlagReturnImmediately = 0x10
Global Const $wbemFlagForwardOnly = 0x20
Local $colItems = "", $Output, $Disabled = False

$Output &= "User ID: " & @TAB & @UserName & @CRLF & @CRLF

$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_ComputerSystemProduct", "WQL", _
										  $wbemFlagReturnImmediately + $wbemFlagForwardOnly)

If IsObj($colItems) then
	For $objItem In $colItems
		$Output &= "Model: " & @TAB & @TAB & $objItem.Name & @CRLF
		$Output &= "Service Tag: " & @TAB & $objItem.IdentifyingNumber & @CRLF
		$Output &= "Computer Name: " & @TAB & @ComputerName  & @CRLF
	Next
	Local $Active_Adaptors = GetWMI(2)
	If @error = 2 Then $Disabled = True
	Local $i = 0, $NetworkCard, $Description, $ServiceName, $ServiceNameKeyValue
	While True
		$i += 1
		$NetworkCard = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards", $i)
		If @error <> 0 Then ExitLoop
		$Description = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\" & $NetworkCard , "Description")
		$ServiceName = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkCards\" & $NetworkCard , "ServiceName")
		$ServiceNameKeyValue = RegRead("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\Interfaces\" & $ServiceName , "DhcpIPAddress")
		; check if network  adaptor, otherwise skip
		If StringInStr($Active_Adaptors , $Description ) > 0 Then
			; make it end-user readable
			$Output &= "IP Address: " & @TAB & _Iif(StringInStr($Description, "WLAN") > 0,"WLan connection", "LAN Connection  ") &  _
				" : " & $ServiceNameKeyValue & _Iif(StringInStr($Active_Adaptors , $Description & " (Disabled)")> 0, " (Disabled)", "")  & @CRLF
		EndIf
	WEnd
	; if all adaptors are disabled
	If $Disabled Then
		$Output &= "IP Address: " & @TAB & "All network adaptors are disabled"
	EndIf
	ClipPut($Output)
	Msgbox(0,"Computer Info",$Output & @CRLF & @CRLF & "For selfticketing purpose, the information has been copied to your clipboard." & @CRLF & "You can now paste it into your ticket")
Else
   Msgbox(48,"Computer Info","No WMI Objects Found for class: " & "Win32_ComputerSystemProduct" )
Endif

Exit

Func GetWMI($Status = 0)
	; $Status = 0 ==> enabled
	; $Status = 1 ==> disabled
	; $Status = 2 ==> Both
    Local $Active_Adaptors, $Disabled_Adaptors, $_Adaptors, $colItems
	If $Status = 0 Then
		$colItems = $objWMIService.ExecQuery("SELECT Description FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True", "WQL", 0x00).Count
        If $colItems > 0 Then
            $colItems = $objWMIService.ExecQuery("SELECT Description FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = True", "WQL", 0x30)
            If IsObj($colItems) Then
                For $objItem In $colItems
                    $Active_Adaptors &= $objItem.Description & @CRLF
                Next
                SetError(0)
                Return $Active_Adaptors
            Else
                Return SetError(1)
            EndIf
        Else
			Return SetError(2)
		EndIf
	ElseIf $Status = 1 Then
		$colItems = $objWMIService.ExecQuery("SELECT Description FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = False", "WQL", 0x00).Count
        If $colItems > 0 Then
			$colItems = $objWMIService.ExecQuery("SELECT Description FROM Win32_NetworkAdapterConfiguration WHERE IPEnabled = False", "WQL", 0x30)
			If IsObj($colItems) Then
				For $objItem In $colItems
					$Disabled_Adaptors &= $objItem.Description & " (Disabled)" & @CRLF
				Next
				SetError(0)
				Return $Disabled_Adaptors
			Else
				Return SetError(1)
			EndIf
        Else
			Return SetError(2)
		EndIf
	ElseIf $Status = 2 Then
		$colItems = $objWMIService.ExecQuery("SELECT Description, IPEnabled FROM Win32_NetworkAdapterConfiguration", "WQL", 0x00).Count
        If $colItems > 0 Then
			$colItems = $objWMIService.ExecQuery("SELECT Description, IPEnabled FROM Win32_NetworkAdapterConfiguration", "WQL", 0x30)
			If IsObj($colItems) Then
				For $objItem In $colItems
					$_Adaptors &= $objItem.Description & _iif($objItem.IPEnabled = True,""," (Disabled)") & @CRLF
					ConsoleWrite(@ScriptLineNumber & " " & $objItem.Description & " " & _iif($objItem.IPEnabled = True,""," (Disabled)") & @CRLF)
				Next
				SetError(0)
				Return $_Adaptors
			Else
				Return SetError(1)
			EndIf
        Else
			Return SetError(2)
		EndIf
	EndIf
EndFunc

