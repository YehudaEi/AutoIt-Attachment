#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.4.9
 Author:         Jeff deVeer

 Script Function:
	Automatically configure LSUSecure on Windows XP machines.

#ce ----------------------------------------------------------------------------
#include <GUIConstants.au3>
#Include <GuiListView.au3>

;Check for administrative rights.  Required to stop and start the services.
If 0 = IsAdmin ( ) Then
	Msgbox (16, "Insufficient Privileges", "Administrative rights are required to run this utility")
	Exit
EndIf


If 2= MsgBox (1, "Warning", "This Auto Configuration Utility will disable 3rd party Wireless Management Utilities and enable the Windows Wireless Zero Configuration Service." & @CRLF & @CRLF & "This may disable connections to wireless networks that were configured using the 3rd party Management Utility" & @CRLF & @CRLF & "Would you like to continue?")Then Exit

$SSID = "lsusecure"
$RemoveSSID = "lsuwireless (Automatic)"
$PEAPServers = "acs-wlan.net.lsu.edu;acs.wlan.lsu.edu"
$TrustedAuthority = "GTE CyberTrust Global Root"
$WZCSVCStarted = 0


Func FatalWindowError($Window)
	SplashOff()
	;Enable keyboard and mouse input
	BlockInput (0)
	MsgBox (16, "Fatal Window Error", "Unable to automatically configure your Network Connection" & @CRLF & $Window & " window failed to open")
	Exit
EndFunc

Func FatalControlError($Control)
	SplashOff()
	;Enable keyboard and mouse input
	BlockInput (0)
	MsgBox (16, "Fatal Control Error", "Unable to automatically configure your Network Connection" & @CRLF & "Unable to " & $Control)
	Exit
EndFunc

;Checks if a specified service is running.
;Returns 1 if running.  Otherwise returns 0.
Func IsServiceRunning($ServiceName)
	$pid = Run('sc query ' & $ServiceName, '', @SW_HIDE, 2)
	Global $data
	Do
		$data &= StdOutRead($pid)
	Until @error
	If StringInStr($data, 'running') Then 
		Return 1
	Else 
		Return 0
	EndIf
EndFunc

;Waits for a specified control in a specified window to enable for up to 3000 ms.
;Returns 1 if control enabled. Returns 0 if control fails to enable
Func ControlCommandWait ($Win, $Cntrl)
	$LoopCount = 0
	While 0 = ControlCommand ($Win, "", $Cntrl, "IsEnabled", "") and $LoopCount < 3001
		If $LoopCount = 3000 Then Return 0
		Sleep (1)
		$LoopCount = $LoopCount + 1
	WEnd
	Return 1
EndFunc


Func GetWirelessProperties ($ItemIndex)
	;Make sure there are no other selections
	ControlListView("Network Connections", "", 1, "SelectClear")
	If @Error then FatalControlError("Clear the selections in the ""Network Connections"" window")
	;Select the Wireless connection
	ControlListView("Network Connections", "", 1, "Select", $ItemIndex)
	If @Error then FatalControlError("Select the Wireless connection")

	;Open Wireless Connection's Properties
	If Not WinActivate ("Network Connections") Then FatalWindowError("Network Connections")
	ControlSend ("Network Connections", "", "SysListView321", Send("!{Enter}"))
	If @Error then FatalControlError("Open Wireless Connection's Properties")

	;Wait up to 25 seconds for Wireless Connection Proterties Window to open, if not display error and exit
	If not WinWait ($ConnectionPropertiesWin, "", 25) Then FatalControlError("Select the Wireless connection")
EndFunc


Func RemoveSSID ()
	;Wait for "Preferred Networks" list to enable
	If Not ControlCommandWait ($ConnectionPropertiesWin, "SysListView321") Then FatalControlError("wait for the ""Preferred Networks"" list to enable")

	;Search for lsuwireless in the SSID list
	$LSUWirelessIndex = ControlListView ($ConnectionPropertiesWin, "", "SysListView321", "FindItem", $RemoveSSID)
	;Remove the "lsuwireless" SSID if it exists
	If -1 <> $LSUWirelessIndex Then
		ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & @CRLF & @CRLF & "  -Removing the old LSUWireless SSID")
		;Select "lsuwireless"
		ControlListView ($ConnectionPropertiesWin, "", "SysListView321", "Select", $LSUWirelessIndex)
		;Click the remove button
		ControlClick($ConnectionPropertiesWin, "", "Button8")
		If @Error then FatalControlError("Click the remove button on the ""Wireless Network"" tab")
		ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & "...Done")
	EndIf
EndFunc

;Check for Windows XP
If @OSVERSION <> "WIN_XP" Then
	MsgBox(0, "Error:", "This utility is only for Windows XP")
	Exit
EndIf

;Check for Service Pack 2
If @OSServicePack <> "Service Pack 2" Then
	MsgBox(0, "Error:", "The LSUSecure WiFi Network requires Service Pack 2 for Windows XP")
	Exit
EndIf

;Check for KB885453 Hotfix for PEAP Authentication.  If not ask if they want to install it.
RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Updates\Windows XP\SP3\KB885453", "Description")
If @error Then 
	If 1 = Msgbox (1,"Missing Required Update", "The Windows Update KB885453 is required to acccess the LSUSecure WiFi Network." & @CRLF & "Would you like to install this update now?") Then
		RunWait ("WindowsXP-KB885453-x86-enu.exe /passive /norestart")
	Else
		Msgbox (16, "LSUSecure", "Setup Aborted")
		Exit
	EndIf
EndIf





;Check for 3rd party management utilities that are known not to "yield" to the Wireless Zero Configuration Service

;Broadcom Corporation Wireless Card Utility
If 1 = IsServiceRunning("wltrysvc") Then
	If 1 = msgbox (1, "LSUSecure", "You are currently running the Broadcom Corporation Wireless Card Utility." & @CRLF & "The LSUSecure configuration utility cannot run while the Broadcom Utility is enabled" & @CRLF & @CRLF & "Would you like to disable the Broadcom utility and continue?") Then
		;Change startup for the service to manual
		Run ("sc config wltrysvc start= demand","",@SW_HIDE)
		RunWait ("net stop wltrysvc","",@SW_HIDE)
	Else
		Msgbox (16, "LSUSecure", "Setup Aborted")
		Exit
	EndIf
EndIf

SplashTextOn("LSUSecure WiFi", "Please wait while your WiFi adapter is configured for the LSUSecure Network.", 1024, 768, -1, -1, 4, "", 24)

;Check if the Wireless Zero Configuration Service is running.  If not start it.
If 0 = IsServiceRunning("WZCSVC") Then
	ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & @CRLF & @CRLF & "  -Configuring and Starting Wireless Zero Configuration Service")
	;Set Wireless Zero Configuration Service to run automatically
	Run ("sc config WZCSVC start= auto","",@SW_HIDE)
	;Start the Wireless Zero Configuration Service
	RunWait ("net start WZCSVC","",@SW_HIDE)
	
	;Set $WZCSVCStarted to 1 so we know that WZCSVC had to be started
	$WZCSVCStarted = 1
	ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & "...Done")
EndIf


;Disable keyboard and mouse input to prevent user from accidentally interupting profile creation
BlockInput (1)



ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & @CRLF & @CRLF & "  -Locating your Wireless Connection")

;Open the Network Connections control panel
Run ("control.exe ncpa.cpl")

If not WinWaitActive ("Network Connections", "", 25) Then FatalWindowError("Network Connections")

;Find out how many Network Connection items are listed
$ItemCount = ControlListView("Network Connections", "", 1, "GetItemCount")

;Subrtract 1 from the 
$ItemIndex = $ItemCount - 1

;Check each Network Connection item to see if it's got "Wireless" in the connection name
While $ItemIndex > -1
	$ConnectionName = ControlListView("Network Connections", "", 1, "GetText", $ItemIndex)
	If StringInStr ($ConnectionName, "wireless",2) Then 
		ExitLoop
	ElseIf $ItemIndex = 0 Then
		SplashOff()
		;Enable keyboard and mouse input
		BlockInput (0)
		MsgBox (16, "Error", "Unable to locate your Wireless adapter")
		Exit
	Else		
		$ItemIndex = $ItemIndex - 1
	EndIf
Wend

;Set the name of the Connection Properties Window
$ConnectionPropertiesWin = $ConnectionName & " Properties"

;Open the properties for the Wireless Connection
GetWirelessProperties ($ItemIndex)

ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & "...Done")

;Switch to "Wireless Network" tab
ControlCommand ($ConnectionPropertiesWin, "", "SysTabControl321", "TabRight", "")
If @Error then FatalControlError("Switch to ""Wireless Network"" tab")
Sleep (500)

;Sometimes when you check the "Use Windows..." checkbox and WZCSVC has just been started
;you have to apply that change before you get the option to select "WPA" and "TKIP"
;So, if we started WZCSVC and it's not checked we'll check it, then hit "OK" and re-open the properties window.
If Not ControlCommand ($ConnectionPropertiesWin, "","Button1", "IsChecked", "") and $WZCSVCStarted = 1 Then
	ControlCommand ($ConnectionPropertiesWin, "","Button1", "Check", "")
	If @Error then FatalControlError("check the ""Use Windows..."" checkbox")
	;Remove "lsuwireless" SSID
	RemoveSSID ()
	ControlClick($ConnectionPropertiesWin, "", 1)
	If @Error then FatalControlError("click ""OK"" on the Wireless Connection Properties window")
	WinWaitClose ($ConnectionPropertiesWin)

	;Repen the properties for the Wireless Connection
	GetWirelessProperties ($ItemIndex)
	
	;Switch to "Wireless Network" tab
	ControlCommand ($ConnectionPropertiesWin, "", "SysTabControl321", "TabRight", "")
	If @Error then FatalControlError("Switch to ""Wireless Network"" tab")
	Sleep (500)

Else
	ControlCommand ($ConnectionPropertiesWin, "","Button1", "Check", "")
	;Remove "lsuwireless" SSID
	RemoveSSID ()
EndIf



WinClose ("Network Connections")

;Click "Add" button
ControlClick($ConnectionPropertiesWin, "", "Button7")

;Wait up to 25 seconds for window to open and activate, if not display error and exit
If not WinWait ("Wireless network properties", "", 25) then FatalWindowError("Wireless network properties")

ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & @CRLF & @CRLF & "  -Adding the LSUSecure SSID")

;Check if the "SSID" text box is enabled. 
If Not ControlCommandWait ("Wireless network properties", "Edit1") Then FatalControlError("wait for the ""SSID"" text box to enable")

;Enter the SSID stored in the $SSID variable
ControlCommand ( "Wireless network properties", "", "Edit1", "EditPaste", $SSID)
If @Error then FatalControlError("enter the SSID")

;Set "Network Authentication" to WPA
$WPAOccurrence = ControlCommand ("Wireless network properties", "", "ComboBox1", "FindString", 'WPA' )
If @Error then 
	SplashOff()
	;Enable keyboard and mouse input
	BlockInput (0)
	msgbox (16,"LSUSecure", "Your WiFi adapter does not appear to have WPA Support" & @CRLF & "Unable to automatically configure your Network Connection"  & @CRLF & "Check with your hardware manufacturer for an updated driver")
	Exit
EndIf
ControlCommand ( "Wireless network properties", "", "ComboBox1", "SetCurrentSelection", $WPAOccurrence)
If @Error then FatalControlError("Set ""Network Authentication"" to WPA")

;Set "Data Encryption" to TKIP
$TKIPOccurrence = ControlCommand ("Wireless network properties", "", "ComboBox2", "FindString", 'TKIP' )
If @Error then 
	SplashOff()
	;Enable keyboard and mouse input
	BlockInput (0)
	msgbox (16,"LSUSecure", "Your WiFi adapter does not appear to have TKIP Support" & @CRLF & "Unable to automatically configure your Network Connection"  & @CRLF & "Check with your hardware manufacturer for an updated driver")
	Exit
EndIf
ControlCommand ( "Wireless network properties", "", "ComboBox2", "SetCurrentSelection", $TKIPOccurrence)
If @Error then FatalControlError("Set ""Data Encryption"" to TKIP")

;Switch to the "Authentication" tab
ControlCommand ( "Wireless network properties", "", "SysTabControl321", "TabRight", "")
If @Error then FatalControlError("Switch to the ""Authentication"" tab")
Sleep (500)

;Check if the "EAP Type" dropdown is enabled. 
If Not ControlCommandWait ("Wireless network properties", "ComboBox1") Then FatalControlError("wait for the ""EAP Type"" dropdown to enable")


;Find the option in the "EAP Type" dropdown
$PEAPOccurrence = ControlCommand ("Wireless network properties", "", "ComboBox1", "FindString", 'Protected EAP (PEAP)')
If @Error then 
	SplashOff()
	;Enable keyboard and mouse input
	BlockInput (0)
	msgbox (16,"LSUSecure", "Your WiFi adapter does not appear to have Protected EAP (PEAP) Support" & @CRLF & "Unable to automatically configure your Network Connection" & @CRLF & "Check with your hardware manufacturer for an updated driver")
	Exit
EndIf

;Set "EAP Type" to Protected EAP (PEAP)
ControlCommand ( "Wireless network properties", "", "ComboBox1", "SetCurrentSelection", $PEAPOccurrence)
If @Error then FatalControlError("Set ""EAP Type"" to Protected EAP (PEAP)")

;Click the "Properties" button
ControlClick("Wireless network properties", "", "Button2")
If @Error then FatalControlError("Click the ""Properties"" button on the ""Authentication"" tab")

;Wait up to 25 seconds for window to open and activate, if not call FatalWindowError
If not WinWait ("Protected EAP Properties", "", 25) then  FatalWindowError("Protected EAP Properties")

;Check the "Connect to these servers" box
ControlCommand ("Protected EAP Properties", "","Button3", "Check", "")
If @Error then FatalControlError("Check the ""Connect to these servers"" box")

;Populate text box with server names
ControlCommand ( "Protected EAP Properties", "", "Edit1", "EditPaste", $PEAPServers)
If @Error then FatalControlError("Populate text box on the ""Protected EAP Properties"" tab with server names")

; select both "GTE.." certificate authorities.
$GTEIndex = ControlListView ("Protected EAP Properties", "", "SysListView321", "FindItem", $TrustedAuthority)
If @Error then FatalControlError("Find ""Trusted Authority"" in the ""Trusted Root Certification Authorities"" list")
$AuthoritiesHandle = ControlGetHandle ( "Protected EAP Properties", "", "SysListView321")

;Sometimes there are two "GTE CyberTrust Global Root" options. We'll see if there is a second one and check it too.
;If not we'll just check the first one.
If  $TrustedAuthority = ControlListView ("Protected EAP Properties", "", "SysListView321", "GetText", $GTEIndex + 1) Then
	_GUICtrlListViewSetCheckState ( $AuthoritiesHandle, $GTEIndex )
	If @Error then FatalControlError("Select ""Trusted Authority"" in the ""Trusted Root Certification Authorities"" list")
	_GUICtrlListViewSetCheckState ( $AuthoritiesHandle, $GTEIndex + 1)
	If @Error then FatalControlError("Select ""Trusted Authority"" in the ""Trusted Root Certification Authorities"" list")
Else
	_GUICtrlListViewSetCheckState ( $AuthoritiesHandle, $GTEIndex )
	If @Error then FatalControlError("Select ""Trusted Authority"" in the ""Trusted Root Certification Authorities"" list")
EndIf


;Check the "Enable FastReconect" box
ControlCommand ("Protected EAP Properties", "","Button8", "Check", "")
If @Error then FatalControlError("Check the ""Enable FastReconect"" box on the ""Protected EAP Properties"" tab")

;Click the "Configure" button
ControlClick("Protected EAP Properties", "", "Button5")
If @Error then FatalControlError("Click the ""Configure"" button on the ""Protected EAP Properties"" tab")

;Wait up to 25 seconds for window to open and activate, if not display error and exit
If not WinWait ("EAP MSCHAPv2 Properties", "", 25) then FatalWindowError("EAP MSCHAPv2 Properties")

;Uncheck the "Automatically use..." box
ControlCommand ("EAP MSCHAPv2 Properties", "","Button3", "UnCheck", "")
If @Error then FatalControlError("Uncheck the ""Automatically use..."" box"" on the ""EAP MSCHAPv2 Properties"" window" )

;Click OK on the "EAP MSCHAPv2 Properties" window
ControlClick("EAP MSCHAPv2 Properties", "", "Button1")
If @Error then FatalControlError("Click ""OK"" on the ""EAP MSCHAPv2 Properties"" window" )

;Click OK on the "Protected EAP Properties" window
ControlClick("Protected EAP Properties", "", "Button6")
If @Error then FatalControlError("Click ""OK"" on the ""Protected EAP Properties"" window" )

;Click OK on the "Wireless network properties" window
ControlClick("Wireless network properties", "", "Button5")
If @Error then FatalControlError("Click ""OK"" on the ""Wireless network properties"" window" )

;Click OK on Wireless Connection Propterties Window
ControlClick($ConnectionPropertiesWin, "", "Button11")
If @Error then FatalControlError("Click ""OK"" on the ""Wireless Connection Propterties"" window" )
	
ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & "...Done")

WinWaitClose ($ConnectionPropertiesWin, "", 30)

;Stop and start the Wireless Zero Configuration service because sometimes it won't automatically connect to the SSID without it
ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & @CRLF & @CRLF & "  -Restarting Wireless Zero Configuration Service")
RunWait ("net stop WZCSVC","",@SW_HIDE)
RunWait ("net start WZCSVC","",@SW_HIDE)
ControlSetText("LSUSecure WiFi", "", "Static1", ControlGetText ("LSUSecure WiFi", "", "Static1" ) & "...Done")

;Enable keyboard and mouse input
BlockInput (0)

Sleep (3000)


SplashOff()

GUICreate("Configuration Successful")  ; will create a dialog box that when displayed is centered
GUISetState (@SW_SHOW)
GUICtrlCreateLabel ( "Auto configuration was successful!" & @CRLF & @CRLF &"Here's how to enter your username and password the next time you're within" & @CRLF &"range of lsusecure:" & @CRLF & @CRLF &"1) Watch for the bubble (As shown in the image below) to appear in the" & @CRLF & "    System Tray near the clock. This could take up to a minute or two to appear.", 5, 5)
GUICtrlCreatePic("Credential Bubble.gif", 25, 105, 352, 103)
GUICtrlCreateLabel ( "2) Click the bubble when it appears" & @CRLF & @CRLF &"3) When prompted, enter your PAWS user name and password" & @CRLF &"    (Leave the ""Logon domain"" field blank)."& @CRLF & @CRLF &"4) Click ""OK"" on the ""Enter Credentials"" window", 5, 220)
$Button_OK = GUICtrlCreateButton ( "OK",  175, 320, 50, 25)
While 1
    $msg = GUIGetMsg()
    
    If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	If $msg = $Button_OK Then ExitLoop
Wend



Exit

;RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces\", "{CD845A1D-F538-4C24-875F-5EF1777F09DE}")
;RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EAPOL\Parameters\Interfaces\", "{CD845A1D-F538-4C24-875F-5EF1777F09DE}")
;$WiFiGUID = RegEnumKey("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces\", 1)

;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces\" & $WiFiGUID, "ActiveSettings", "REG_BINARY", "c8020000000000000018740a1ad40000090000006c7375736563757265000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000d08c9ddf0115d1118c7a00c04fc297eb0100000032bdfb3142caea48bde54dad3e5981bc0000000002000000000003660000a8000000100000009daf98db78ce4e96ed06e3a33a1efeac0000000004800000a0000000100000000beec3f070cffde2b8cf72ad9a813963280000004beaffff48252dd56e4e0072b14c00759cce492c3daf2ae2ece58c75f82736e269c31ac212c084ff1400000068399a08cccb1b3d994096ee8de35c354fce0188")

;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces\" & $WiFiGUID, "ControlFlags", "REG_DWORD", "125927426")

;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\EAPOL\Parameters\Interfaces\" & $WiFiGUID, "1", "REG_BINARY", "0500000000000000000000c019000000090000006c737573656375726500000000000000000000000000000000000000000000000d00000028000000000000002800000005000000000000000000000000000000000000000000000000000000000000000000000019000000b800000001000000b80000000100000001000000010000008f00000011000000020000001400000097817950d81c9670cc34d809cf794431367ef4741400000097817950d81c9670cc34d809cf794431367ef4746100630073002d0077006c0061006e002e006e00650074002e006c00730075002e006500640075003b006100630073002d0077006c0061006e002e006c00730075002e00650064007500000001000000170000001a0000000100000000000000000000000000000000000000")

;RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\WZCSVC\Parameters\Interfaces\" & $WiFiGUID, "Static#0000", "REG_BINARY", "c8020000000000000000000000000008090000006c7375736563757265000000000000000000000000000000000000000000000004000000000000000000000000000000000000000000000000000000000000000000000000000000000000000100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000003000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001000000d08c9ddf0115d1118c7a00c04fc297eb0100000014cceabbe263074f9802b08d1f6f79380000000002000000000003660000a8000000100000001aea2b699a0cf54e905bcb37ba3d668c0000000004800000a0000000100000003f6c1daee7d0ca33ebecc168972b8cda28000000851c74d256213604ebb7af44401985b2757e53560e96ebcce96b8f200d0785ed6f0aad4c0e1e0ec014000000065e7323077036c3f1995c3f2f16eecf5d0e0d8e")
;Run ("sc config WZCSVC start= auto","",@SW_HIDE)

