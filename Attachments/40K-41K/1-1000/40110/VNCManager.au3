; =================================================================================
; == VNC Manager
; ==
; == Developed and maintained By The Workspace Solution, Inc.
; == The Workspace Solution Copyright March, 2013
; == GUI generated with Koda
; == Change History
; == Jun 18, 2006 - 1.0  - Created
; =================================================================================
#include <File.au3>
#include <Array.au3>

#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Region ### START Koda GUI section ### Form=c:\mytest\rai\formrai.kxf
$FormRAI = GUICreate("Remote Access Interface", 615, 438, 192, 124)
$MuFiles = GUICtrlCreateMenu("&Files")
$MnOpen = GUICtrlCreateMenuItem("Open", $MuFiles)
$MuReload = GUICtrlCreateMenuItem("Reload", $MuFiles)
$MuExit = GUICtrlCreateMenuItem("Exit", $MuFiles)
$MuAbout = GUICtrlCreateMenu("&About")
$LBoxClients = GUICtrlCreateList("", 32, 64, 113, 201, BitOR($LBS_NOTIFY,$WS_VSCROLL,$WS_BORDER))
$CBoxComputers = GUICtrlCreateCombo("", 168, 64, 97, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
$LClients = GUICtrlCreateLabel("Clients", 32, 40, 35, 17)
$LComputer = GUICtrlCreateLabel("Computer", 168, 40, 49, 17)
$BtnConnect = GUICtrlCreateButton("Connect", 48, 344, 73, 25)
$BtnCancel = GUICtrlCreateButton("Cancel", 160, 344, 73, 25)
$Group1 = GUICtrlCreateGroup("VNC IP and Port", 296, 40, 281, 169)
$Label1 = GUICtrlCreateLabel("VNC Server", 312, 64, 60, 17)
$Label2 = GUICtrlCreateLabel("Port", 312, 108, 23, 17)
$TxtWANIP = GUICtrlCreateInput("", 312, 80, 121, 21)
$TxtWANPort = GUICtrlCreateInput("", 312, 125, 89, 21)
$ID = GUICtrlCreateLabel("ID", 312, 154, 15, 17)
$TxtVNCID = GUICtrlCreateInput("", 312, 172, 89, 21)
$Label3 = GUICtrlCreateLabel("Password", 448, 154, 50, 17)
$TxtVNCPwd = GUICtrlCreateInput("", 448, 172, 104, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Computer Info", 296, 220, 281, 169)
$Label4 = GUICtrlCreateLabel("Computer Name", 312, 244, 80, 17)
$TxtCPUName = GUICtrlCreateInput("", 312, 260, 121, 21)
$Label5 = GUICtrlCreateLabel("LAN IP", 312, 288, 38, 17)
$TxtLanIP = GUICtrlCreateInput("", 312, 305, 121, 21)
$Label6 = GUICtrlCreateLabel("Login ID", 312, 334, 44, 17)
$TxtUserID = GUICtrlCreateInput("", 312, 352, 121, 21)
$Label7 = GUICtrlCreateLabel("Password", 448, 334, 50, 17)
$TxtUserPwd = GUICtrlCreateInput("", 448, 352, 105, 21)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


Local $aRecordsOfFields
Global $fields
Local $LBoxItemSelected, $CBItemSelected

LoadFromTable($aRecordsOfFields)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $LBoxClients	; For selected client to populate comp Combobox
			$LBoxItemSelected = GUICtrlRead($LBoxClients)
			LoadComputers($aRecordsOfFields, $LBoxItemSelected, "")
		Case $CBoxComputers	; For selected computer to update VNC Host & Port
			$LBoxItemSelected = GUICtrlRead($LBoxClients)
			$CBItemSelected = GUICtrlRead($CBoxComputers)
			LoadComputers($aRecordsOfFields, $LBoxItemSelected, $CBItemSelected)
		Case $MnOpen
			OpenVNCList()
		Case $MuReload
			LoadFromTable($aRecordsOfFields)
		Case $BtnConnect
			ConnectToHost()
		case $BtnCancel, $MuExit
			Exit
	EndSwitch
WEnd

Func LoadFromTable(ByRef $aRecords)
	Local $fields
	Local $sRecentField = ""
	Local $LBStr = ""
	Local $1stchoice

	; Load VNC table into array of records with fields
	If Not _FileReadToArray("c:\mytest\RAI\VNCTable.csv", $aRecords) Then
		MsgBox(4096, "Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf
	GUICtrlSetData($LBoxClients, "")

	; Fill up the form fields
	For $x = 2 To $aRecords[0]
;		MsgBox(0, 'Record:' & $x, $aRecords[$x])
		$fields = StringSplit($aRecords[$x], ",")
		if $x = 2 then
			$1stClient = $fields[2]
			$1stcpu = $fields[3]
		EndIf
		; Group dup clients
		if $sRecentField <> $fields[2] Then
			;	_ArrayDisplay($fields, "Record")
			if $fields[2] <> "" then $LBStr = $LBStr & $fields[2] & "|"
		EndIf
		$sRecentField = $fields[2]	; Used to remove dup clients
	Next
	; Load up the Client listbox
	GUICtrlSetData($LBoxClients, $LBStr, $1stClient)

	; Load up the computers in combobo for initial first client
	LoadComputers($aRecords, $1stClient, $1stcpu)

EndFunc

Func OpenVNCList()
	Local $message = "Select VNC Table to edit."

	Local $var = FileOpenDialog($message, "c:\mytest\RAI\", "(*.csv)", 1 + 4)

	If @error Then
		MsgBox(4096, "", "No File(s) chosen")
	Else
		$var = StringReplace($var, "|", @CRLF)
		runwait(@WindowsDir & "\system32\notepad.exe " & $var)
;		runwait("C:\Program Files\Microsoft Office\Office14\excel.exe " & $var,"", @SW_MAXIMIZE)
	EndIf
EndFunc

Func ConnectToHost()

	; Get host info - WAN IP, VNC port, ID, and password
	$HostServer = GUICtrlRead($TxtWANIP) & ":" & GUICtrlRead($TxtWANPort)

	$HostID = GUICtrlRead($TxtVNCID)
	$HostPwd = GUICtrlRead($TxtVNCPwd)

	; Get current state of VNC Viewer to determine if we need to run or restore it
	$state = WinGetState("VNC Viewer", "")

	; Start Aloha Manager if not exist or activate if min or max
	If ($state = 0) Then
		Run( "VNCViewer5_Win64bit.exe", "c:\mytest\RAI"); [, flag[, standard_i/o_flag]]] )
		WinWait("VNC Viewer","")
	Else
		; Determine which valid state of VNC Viewer (min, max, or none) then act to get active
		If BitAnd($state, 1) or BitAnd($state, 2) or BitAnd($state, 4) Then
			WinActivate("VNC Viewer", "")
		EndIf
	EndIf
;	WinActivate("VNC Viewer", "")

;	Sleep(3000)
	ControlSetText("VNC Viewer", "", "Edit1", $HostServer )
	Sleep(2000)
	ControlClick("VNC Viewer", "Connect", "Button3", "left")

	WinWait("VNC Viewer - Authentication", "", 2)

	ControlSetText("VNC Viewer - Authentication", "", "Edit1", $HostID )
	ControlSetText("VNC Viewer - Authentication", "", "Edit2", $HostPwd )
	Sleep(1000)
	ControlClick("VNC Viewer - Authentication", "", "Button1", "left")
EndFunc

Func LoadComputers(ByRef $aRecs, $sclient, $sCPUPtr)
	Local $CBStr = ""
	Local $x

;	_ArrayDisplay($aRecs, "Record")

	GUICtrlSetData($CBoxComputers, "")

	For $x = 2 To $aRecs[0]
		$afields = StringSplit($aRecs[$x], ",")
		if $afields[2] = $sclient then
			if $sCPUPtr = "" then $sCPUPtr = $afields[3]
			$CBStr = $CBStr & $afields[3] & "|"
		EndIf
	Next
	GUICtrlSetData($CBoxComputers, $CBStr, $sCPUPtr)
	ShowServerInfo($aRecs, $sclient, $sCPUPtr)
EndFunc

Func ShowServerInfo(ByRef $aRecs, $sclient, $scpu)
	Local $fields
	Local $VNCHost, $VNCPort, $VNCID, $VNCPwd
	Local $x

	For $x = 2 To $aRecs[0]
		$fields = StringSplit($aRecs[$x], ",")
		if $fields[3] = $scpu then
			$VNCHost = $fields[4]
			$VNCPort = $fields[5]
			$VNCID = $fields[7]
			$VNCPwd = $fields[8]
			$sUserComputer = $fields[3]
			$sLANIP = $fields[6]
			$sUserID = $fields[9]
			$sUserPwd = $fields[10]
		EndIf
	Next
	GUICtrlSetData($TxtWANIP, $VNCHost)
	GUICtrlSetData($TxtWANPort, $VNCPort)
	GUICtrlSetData($TxtVNCID, $VNCID)
	GUICtrlSetData($TxtVNCPwd, $VNCPwd)

	GUICtrlSetData($TxtCPUName, $sUserComputer)
	GUICtrlSetData($TxtLanIP, $sLANIP)
	GUICtrlSetData($TxtUserID, $sUserID)
	GUICtrlSetData($TxtUserPwd, $sUserPwd)
EndFunc