#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiButton.au3>
#include <File.au3>
#include <Array.au3>
#include <String.au3>
#include <Date.au3>
#include <Process.au3>

;Forces Variable declaration
Opt("MustDeclareVars", 1)

;Turns on Events
Opt("GUIOnEventMode", 1)

;Declares Global Variables
Global $sES_NUMBER, $sCapture, $sLbl, $sInput, $sCnct, $sDiscnct, $sClose, $shGUI, $sFont, $sX, $sFilePath, $sFileName, $sFindText, $sReplaceText, $sFileContents, $sIPos, $aSplit, $aArray, $Connected

;Sets Constants
Global Const $sPath = "C:\EngineConnect\"
Global Const $sLogfile = $sPath & "ECRun.log"
Global Const $sNetwork_Alive_Lan = 0x1
Global Const $sNetwork_Alive_Wan = 0x2

;Sets Default Font
$sFont = "Arial"

;Opens ECRun.log file, or creates one
	If FileExists($sLogfile) Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "**************************************************************************")
	Else
		_FileCreate($sLogfile)
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - ECRun.log File Created")
	EndIf

;Creates Marker in ECRun.log
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "**************************************************************************")

;Creates the window and buttons
$shGUI = GUICreate ("Amtrak - TCD Engine Connect System", 350 , 450, 600, 75)
$sCnct = GUICtrlCreateButton("Connect", 25, 410, 90, 20)
GUICtrlSetOnEvent(-1, "ConnectPressed")

$sDiscnct = GUICtrlCreateButton("Disconnect", 131, 410, 90, 20)
;button is initially disabled
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlSetOnEvent(-1, "DisconnectPressed")

$sClose = GUICtrlCreateButton("Close", 235, 410, 90, 20)
GUIctrlSetOnEvent(-1, "CLOSEPressed")

;Creates the labels for the text on the window
$sLbl = 250

;Font for next line
GUISetFont(10, 600, "", $sFont)
GUICtrlCreateLabel("Instructions:", 30, 15, $sLbl)

GUISetFont(10, 500, 4, $sFont)
GUICtrlCreateLabel("Connecting:", 30, 35, $sLbl)

;Font for following line
GUISetFont(9, 400, "", $sFont)
GUICtrlCreateLabel("Enter the Engine Number you wish to access", 30, 55, $sLbl)
GUICtrlCreateLabel("then press the Connect button", 30, 70, $sLbl)
GUICtrlCreateLabel("The system will build your connection", 30, 85, $sLbl)
GUICtrlCreateLabel("and launch the LDVR program", 30, 100, $sLbl)

;Font for next line
GUISetFont(10, 500, 4, $sFont)
GUICtrlCreateLabel("Disconnecting:", 30, 145, $sLbl)

;Font for following line
GUISetFont(9, 400, "", $sFont)
GUICtrlCreateLabel("#1 Once finished with the LDVR program", 30, 165, $sLbl)
GUICtrlCreateLabel("#2 Exit the LVDR Program then Disconnect", 30, 180, $sLbl)

;Font for following line
GUISetFont(9, 500, "", $sFont)
GUICtrlCreateLabel("You may now connect to another Engine ", 30, 225, $sLbl)
GUICtrlCreateLabel("or close the program...", 30, 240, $sLbl)

;Creates the input box
GUICtrlCreateLabel("Enter Engine Number here:", 30, 300, $sLbl)
Global $sCapture = GUICtrlCreateInput("", 30, 320, 75, 25, $sES_NUMBER)
;Field Accepts 5 Decimal Digits aximum
GUICtrlSetLimit(-1, 5)
GUICtrlSetOnEvent($sCapture, "ConnectPressed")

;Launches a blank GUI window
GUISetState()
GUICtrlSetState($sCapture, $GUI_FOCUS)

	;Makes Program "Idle" until event happens
	While 1
		Sleep(1000)
	WEnd

;Connect Event
Func ConnectPressed()
	_FileWriteLog($sLogfile, "")
	_FileWriteLog($sLogfile, "Connect Function Started")
	$sInput = GUICtrlRead($sCapture)

	;Checks to see if $sInput is valid
	If $sInput = '' Or Number($sInput) < 0 Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - Engine Number is out of range")
		MsgBox(0, "Engine Number", "Please Enter engine number in the range of 0 to 9999")
		GUICtrlSetState($sCapture, $GUI_FOCUS)
;		Return
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Engine Number is " & $sInput)
	EndIf

	$sInput = GUICtrlRead($sCapture)
	;Checks to see if $sInput is a valid String
	IsString($sInput)
	$sX = StringFormat( "%.0d", 2 )
	If $sX = @error =1 Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - Engine Number Format is not Correct")
		MsgBox(0, "", "Wrong Format")
	EndIf

	;only once input is recognized as valid, add prefix
	$sInput = 'AMT' & $sInput
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Assigning AMT Prefix to " & $sInput)

	;Assigns Static IP address to Ethernet NIC
	SplashTextOn("Status", "Assigning temporary local IP address...", 350, 100, -1, -1, 0, $sFont, 12, 400)
	Sleep(2000)
	RunWait(@ComSpec & " /c " & "netsh interface ip set address local static 223.223.223.2 255.255.255.252 223.223.223.1 1")
;	Sleep(6000)
	SplashOff()
	If @error Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - IP Address was NOT Set to 223.223.223.2")
		MsgBox(0, "Error", "IP Address was NOT Set to 223.223.223.2")
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - IP Address Correctly Set to 223.223.223.2")
		MsgBox(0, "Success", "IP Address was Set to 223.223.223.2")
	EndIf

	;Verifies if the ASUS Device Responds
	Ping("223.223.223.1",250)
	If @error Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - ASUS device Does NOT Respond")
		Msgbox(0, "CRITICAL ERROR", "Cannot See ASUS Device")
		Exit
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - ASUS device is Responding")
	EndIf

	;Inserts the Persistant Route into the Registry
	RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters\PersistentRoutes", "10.10.9.0,255.255.255.0,223.223.223.3,1", "REG_SZ","")
	If @error Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - Persisent Route was NOT Set Correctly")
		Exit
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - Persisent Route was Set Correctly")
	EndIf
	SplashOff()

		;Connect button is now disabled
	GUICtrlSetState($sCnct, $GUI_DISABLE)
	; Disconnect button is now enabled
	GUICtrlSetState($sDiscnct, $GUI_ENABLE)
	$Connected = True
;	RunWait("c:\DVRConfiguration\DVRConfig.exe")"*****************************************************************************"
	If @error Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - LDVR Program did NOT Open Correctly")
		Exit
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - LDVR Program Opened Correctly")
	EndIf
	Sleep(3000)

	_FileWriteLog($sLogfile, "")
	_FileWriteLog($sLogfile, "Now Completing the Connect Function")
EndFunc   ;==>ConnectPressed

;Disconnect Event
Func DisconnectPressed()
	If Not $Connected Then Return
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Now Running the Disconnect Function")
	SplashTextOn("Status", "Please wait while the connection is removed...", 350, 100, -1, -1, 0, $sFont, 12, 400)
	Sleep(2000)
	RunWait(@ComSpec & " /c " & "netsh interface ip set address local dhcp")
	Sleep(6000)
	If @error Then
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Error - Reseting IP address on Local NIC was NOT done")
	Else
		_FileWriteLog($sLogfile, "")
		_FileWriteLog($sLogfile, "Success - Resetting DHCP on Local NIC was Completed")
	EndIf
	SplashOff()
	SplashTextOn("Status", "Please wait for the Ethernet Connection to reset...", 350, 100, -1, -1, 0, $sFont, 12, 400)
	Sleep(30000)
	SplashOff()

	GUICtrlSetData($sCapture, '')
	;Disconnect button is now disabled
	GUICtrlSetState($sDiscnct, $GUI_DISABLE)
	;Connect button is now enabled
	GUICtrlSetState($sCnct, $GUI_ENABLE)
	$Connected = False
EndFunc   ;==>DisconnectPressed

;Closed Event
Func CLOSEPressed()
	    Exit
EndFunc

