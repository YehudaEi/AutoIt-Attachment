#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3script_v10.ico
#AutoIt3Wrapper_Outfile=IPScannerPro.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ Coded by Ian Maxwell (llewxam)
;~ Based off threaded IP script by Manadar
;~ http://www.autoitscript.com/forum/topic/104334-whats-wrong-with-ping-or-with-me/page__view__findpost__p__740697

;~ Build date January 25 2014

#include <iNet.au3>
#include <ClipBoard.au3>
#include <Constants.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <GuiStatusBar.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>


TCPStartup()

;~ HotKeySet("{SPACE}", "Start_Scan")

;~ $HowManyReq = 1 ; number of ping requests in _MSPing
$TimeoutDefault = 500 ; timeout in miliseconds
Global $HostName, $WhichList, $List, $Used, $StartTime, $Finished, $CurrentIP, $CurrentIndex, $FreeCount, $Progress, $CurrentlyScanning, $FinishMessage, $fDblClkMessage
Global Const $MAX_PROCESS = 30 ; maximum processes at once
Global $fDblClk = False, $aLV_Click_Info, $ChosenIP, $zGetGateway, $Gateway, $ScanSTOP=0, $Rescan=False, $DblClkList=0

$Found = 0 ;how many active connections you have
$LocalIP1 = @IPAddress1
$LocalIP2 = @IPAddress2
$LocalIP3 = @IPAddress3
$LocalIP4 = @IPAddress4
If $LocalIP1 <> "0.0.0.0" Then $Found += 1
If $LocalIP2 <> "0.0.0.0" Then $Found += 1
If $LocalIP3 <> "0.0.0.0" Then $Found += 1
If $LocalIP4 <> "0.0.0.0" Then $Found += 1


If $Found == 0 Then
	MsgBox(16, "OOPS", "There are no adapters with an IP address present.  Please check your adapters and cables.")
	Exit
EndIf
If $Found > 1 Then ; if there is more than one network available you will be prompted to choose which to scan
	$Choose = GUICreate("Choose an IP range", 240, 115, (@DesktopWidth / 2) - 120, @DesktopHeight / 4)
	GUISetBkColor(0xb2ccff, $Choose)
	GUISetFont(8.5)
	$IPShow = StringSplit($LocalIP1, ".")
	$Button1 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 5, 5, 110, 40)
	$IPShow = StringSplit($LocalIP2, ".")
	$Button2 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 125, 5, 110, 40)
	$IPShow = StringSplit($LocalIP3, ".")
	$Button3 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 5, 50, 110, 40)
	$IPShow = StringSplit($LocalIP4, ".")
	$Button4 = GUICtrlCreateButton($IPShow[1] & "." & $IPShow[2] & "." & $IPShow[3] & ".xxx", 125, 50, 110, 40)
;~ 	$Box = GUICtrlCreateGraphic(5, 83, 130, 2) ;       <-------------------------------------------|
;~ 	GUICtrlSetGraphic($Box, $GUI_GR_COLOR, 0x787878) ;                                          <--|
;~ 	GUICtrlSetGraphic($Box, $GUI_GR_MOVE, 30, 1) ;                                              <--|  logo :)
;~ 	GUICtrlSetGraphic($Box, $GUI_GR_LINE, 230, 1) ;                                             <--|
;~ 	GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE© 2014", 35, 86, 290, 20) ;                   <--|
;~ 	GUICtrlSetColor(-1, 0x787878) ;                    <-------------------------------------------|
	If @IPAddress1 == "0.0.0.0" Then GUICtrlDelete($Button1)
	If @IPAddress2 == "0.0.0.0" Then GUICtrlDelete($Button2)
	If @IPAddress3 == "0.0.0.0" Then GUICtrlDelete($Button3)
	If @IPAddress4 == "0.0.0.0" Then GUICtrlDelete($Button4)
	GUISetState(@SW_SHOW, "Choose an IP range")
	Do
		$MSG = GUIGetMsg()
		If $MSG == $GUI_EVENT_CLOSE Then Exit
		If $MSG == $Button1 Then
			$ChosenIP = @IPAddress1
			ExitLoop
		EndIf
		If $MSG == $Button2 Then
			$ChosenIP = @IPAddress2
			ExitLoop
		EndIf
		If $MSG == $Button3 Then
			$ChosenIP = @IPAddress3
			ExitLoop
		EndIf
		If $MSG == $Button4 Then
			$ChosenIP = @IPAddress4
			ExitLoop
		EndIf
	Until 1 == 2
	GUIDelete("Choose an IP range")
Else ; if only one network is available, skip the selection GUI and go
	If $LocalIP1 <> "0.0.0.0" Then $ChosenIP = $LocalIP1
	If $LocalIP2 <> "0.0.0.0" Then $ChosenIP = $LocalIP2
	If $LocalIP3 <> "0.0.0.0" Then $ChosenIP = $LocalIP3
	If $LocalIP4 <> "0.0.0.0" Then $ChosenIP = $LocalIP4
EndIf


$GUI = GUICreate("IP Scanner", 510, 400)
GUISetBkColor(0xb2ccff, $GUI)
GUISetFont(8.5)

$Menu1 = GUICtrlCreateMenu("Scanner")
$MenuItem1 = GUICtrlCreateMenuItem("Settings", $Menu1)
$MenuItem2 = GUICtrlCreateMenuItem("Reset", $Menu1)

$MenuItem3 = GUICtrlCreateMenuItem("", $Menu1)
$MenuItem4 = GUICtrlCreateMenuItem("Close", $Menu1)
$Menu2 = GUICtrlCreateMenu("IP Options")
$MenuItem6 = GUICtrlCreateMenu("Open IP", $Menu2, 1)
$MenuItem7 = GUICtrlCreateMenuItem("In WebBrowser", $MenuItem6)
$MenuItem8 = GUICtrlCreateMenuItem("In Explorer", $MenuItem6)
$MenuItem9 = GUICtrlCreateMenuItem("In Remote Desktop", $MenuItem6)
$MenuItem10 = GUICtrlCreateMenuItem("", $Menu2)
$MenuItem11 = GUICtrlCreateMenuItem("Copy Selected", $Menu2)
$MenuItem12 = GUICtrlCreateMenuItem("Export to CSV", $Menu2)
$MenuItem13 = GUICtrlCreateMenuItem("", $Menu2)
$MenuItem14 = GUICtrlCreateMenuItem("Ping Specific", $Menu2)
$MenuItem15 = GUICtrlCreateMenuItem("Get External IP", $Menu2)
;~ $MenuItem16 = GUICtrlCreateMenuItem("Rescan", $Menu1)
$Menu3 = GUICtrlCreateMenu("User Options")
$MenuItem17 = GUICtrlCreateMenu("Get User", $Menu3, 1)
$MenuItem18 = GUICtrlCreateMenuItem("Selected IP", $MenuItem17)
$MenuItem19 = GUICtrlCreateMenuItem("", $MenuItem17)
$MenuItem20 = GUICtrlCreateMenuItem("Custom", $MenuItem17)
$Menu4 = GUICtrlCreateMenu("Tools")
$MenuItem21 = GUICtrlCreateMenuItem("About", $Menu4)
$MenuItem22 = GUICtrlCreateMenuItem("", $Menu4)
$MenuItem23 = GUICtrlCreateMenuItem("Check for Update", $Menu4)


;~ $IPinBrowser = GUICtrlCreateButton("Open With &Web Browser", 10, 5, 160, 20)
;~ GUICtrlSetTip(-1, "The selected IP address will be opened in a web browser (best for printers)")
;~ $IPinWinExplorer = GUICtrlCreateButton("Open With Windows &Explorer", 175, 5, 160, 20)
;~ GUICtrlSetTip(-1, "The selected IP address will be opened in Windows Explorer (best for computers with network shares)")
;~ $IPinRDP = GUICtrlCreateButton("Open With &Remote Desktop", 340, 5, 160, 20)
;~ GUICtrlSetTip(-1, "The selected IP address will be opened in Windows Explorer (best for computers with network shares)")
;~ $CopyToClip = GUICtrlCreateButton("&Copy Selected", 10, 30, 90, 20)
;~ GUICtrlSetTip(-1, "The selected IP address will be copied to the clipboard")
;~ $SaveToFile = GUICtrlCreateButton("E&xport To CSV", 110, 30, 90, 20)
;~ GUICtrlSetTip(-1, "The results of the scan will be saved to a CSV file")
;~ $PingSpecific = GUICtrlCreateButton("&Ping Specific", 210, 30, 90, 20)
;~ GUICtrlSetTip(-1, "Scan a specific IP address")
;~ $GetExternalIP = GUICtrlCreateButton("&Get External IP", 310, 30, 90, 20)
;~ GUICtrlSetTip(-1, "Scan a specific IP address")
;~ $Rescan = GUICtrlCreateButton("Resca&n", 410, 30, 90, 20)
;~ GUICtrlSetTip(-1, "The results of the scan will be saved to a CSV file")
$StartScan_btn = GUICtrlCreateButton ("SCAN", 9, 3, 492, 45)
$StopScan_btn = GUICtrlCreateButton ("STOP", 430, 345, 70, 20)
GUICtrlSetState($StopScan_btn, $GUI_DISABLE)
$Unused = _GUICtrlListView_Create($GUI, "Unused IP Addresses", 10, 55, 140, 260)
_GUICtrlListView_SetColumnWidth($Unused, 0, 120)
$Used = _GUICtrlListView_Create($GUI, "IP Address|Host Name|Time", 160, 55, 340, 260)
_GUICtrlListView_SetColumnWidth($Used, 0, 95)
_GUICtrlListView_SetColumnWidth($Used, 1, 169)
_GUICtrlListView_SetColumnWidth($Used, 2, 50)
$ExternalIP=GUICtrlCreateLabel("", 10, 355, 260, 15)
Local $StatusParts[4] = [250, 510, -1]
$StatusBar = _GUICtrlStatusBar_Create($GUI)
_GUICtrlStatusBar_SetParts($StatusBar, $StatusParts)
;~ $Box = GUICtrlCreateGraphic(10, 358, 500, 2) ;      <----------------------------------------------|
;~ GUICtrlSetGraphic($Box, $GUI_GR_COLOR, 0x787878) ;                                              <--|
;~ GUICtrlSetGraphic($Box, $GUI_GR_MOVE, 295, 1) ;                                                 <--|
;~ GUICtrlSetGraphic($Box, $GUI_GR_LINE, 500, 1) ;                                                 <--|
;~ GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE© 2014", 300, 360, 200, 20, $SS_RIGHT) ;          <--|
;~ GUICtrlSetColor(-1, 0x787878) ;        <-----------------------------------------------------------|
;~ Local $AccelKeys[8][2] = [["^w", $IPinBrowser],["^e", $IPinWinExplorer],["^r", $IPinRDP],["^c", $CopyToClip],["^x", $SaveToFile],["^p", $PingSpecific],["^g", $GetExternalIP],["^n", $Rescan]]
;~ GUISetAccelerators($AccelKeys)
GUISetState(@SW_SHOW, $GUI)

GUIRegisterMsg($WM_NOTIFY, "_DoubleClick")




Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $StartScan_btn And $Rescan=False Then Start_Scan()
	If $MSG == $MenuItem7 Then _OpenInBrowser()
	If $MSG == $MenuItem8 Then _OpenInExplorer()
	If $MSG == $MenuItem9 Then _OpenInRDP()
	If $MSG == $MenuItem11 Then _CopyToClip()
	If $MSG == $MenuItem12 Then _SaveToFlie()
	If $MSG == $MenuItem18 Then _GetUserSelected()
	If $MSG == $MenuItem2 Then _Reset()
	If $MSG == $MenuItem4 Then Exit
	If $MSG == $MenuItem21 Then _About()
	If $MSG == $MenuItem14 Then
		$GetSpecific=InputBox("Ping Specific","Enter an IP Address to ping")
		If @error=1 Then
		Else
		_PingSpecific($GetSpecific)
		EndIf
	EndIf
	If $MSG == $MenuItem20 Then
		$GetSpecific=InputBox("Retrieve User","Enter an IP Address to locate the associated User")
		If @error=1 Then
		Else
		_GetUser($GetSpecific)
		EndIf
	EndIf
	If $MSG == $MenuItem15 Then
		GUICtrlSetData($ExternalIP,"External IP Address: working...")
		$GetExternalIPAddress=_GetExternalIP()
		GUICtrlSetData($ExternalIP,"External IP Address: "&$GetExternalIPAddress)
	EndIf
	If $MSG == $StartScan_btn And $Rescan=True Then
		_GUICtrlListView_DeleteAllItems($Used)
		_GUICtrlListView_DeleteAllItems($Unused)
		_Scan()
	EndIf
	If $fDblClk Then
		$fDblClk = False
		Switch $aLV_Click_Info[1]
			Case 0 ; On Item
				_CopyToClip()
				$DblClkList=0
		EndSwitch
	EndIf
	Sleep(10)
Until 1 == 2
Exit

Func _Reset();Exits, then runs the script again, thus resetting it
	If @Compiled Then
		Run(FileGetShortName(@ScriptFullPath))
	Else
		Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc   ;==>_Reset

Func Start_Scan()
$Gateway=_GetGateway()
_Scan()
EndFunc

func _GetGateway()
	$zPID = Run(@ComSpec & " /c" & "ipconfig","", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $zOutput = ""
	While 1
		$zOutput &= StdoutRead($zPID)
		If @error Then ExitLoop
	Wend
	$zBreak=StringSplit($zOutput,@CR)
	for $a=1 to $zBreak[0]
		if StringInStr($zBreak[$a],$ChosenIP) Then
			$zGetGatewayLine=$zBreak[$a+2]
			$zGetGateway=StringMid($zGetGatewayLine,41,StringLen($zGetGatewayLine)-40)
			ExitLoop
		EndIf
	next
	return $zGetGateway
EndFunc

Func _Scan()
	$Rescan=True
	GUICtrlDelete($FinishMessage)
	GUICtrlDelete($fDblClkMessage)
	GUICtrlSetState($StartScan_btn, $GUI_DISABLE)
	GUICtrlSetState($Menu1, $GUI_DISABLE)
	GUICtrlSetState($MenuItem1, $GUI_DISABLE)
	GUICtrlSetState($Menu2, $GUI_DISABLE)
	GUICtrlSetState($Menu3, $GUI_DISABLE)
	GUICtrlSetState($StopScan_btn, $GUI_ENABLE)
;~ 	GUICtrlSetState($IPinBrowser, $GUI_DISABLE)
;~ 	GUICtrlSetState($IPinWinExplorer, $GUI_DISABLE)
;~ 	GUICtrlSetState($IPinRDP, $GUI_DISABLE)
;~ 	GUICtrlSetState($CopyToClip, $GUI_DISABLE)
;~ 	GUICtrlSetState($SaveToFile, $GUI_DISABLE)
;~ 	GUICtrlSetState($PingSpecific, $GUI_DISABLE)
;~ 	GUICtrlSetState($GetExternalIP, $GUI_DISABLE)
;~ 	GUICtrlSetState($Rescan, $GUI_DISABLE)
	$Progress = GUICtrlCreateProgress(10, 320, 490, 20)
	$ScanningMessage = GUICtrlCreateLabel("Scanning:", 10, 340, 95, 15)
	$CurrentlyScanning = GUICtrlCreateLabel("", 75, 340, 95, 15)

	Local $a_process[$MAX_PROCESS] ; an array to keep a reference to spawned processes, in the next loop we fill it with value 0
	For $n = 0 To UBound($a_process) - 1
		$a_process[$n] = 0
	Next

	$Oct = StringSplit($ChosenIP, ".")
	$Range = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." ; now we just add an incrementing number and ping away
	Local $Address[255]
	For $i = 0 To 254
		$Address[$i] = $Range & $i ; we generate some IPs
	Next

	Local $i = 0 ; a pointer to run through the $Address array
	$Finished = 0 ; <==== new line
	$CurrentIndex = 0; needed to keep the _GUICtrlListView_AddSubItem working right...
	$FreeCount = 0
	AdlibRegister("_Display", 100)
	$StartTime = TimerInit()

	Do
		; check on the current processes, and look if there is one finished for use with our next host in line (from $Address)
		For $n = 0 To UBound($a_process) - 1
			$MSG = GUIGetMsg()
			If $MSG == $GUI_EVENT_CLOSE Then Exit
			If $MSG == $StopScan_btn Then
				ExitLoop 2
				$ScanSTOP=1
			EndIf
			If($i <> UBound($Address) And $a_process[$n] == 0) Then ; check if we need a spot, and there is an existing spot
				; there is an empty spot
				$a_process[$n] = _MSPing($Address[$i])
				$i += 1
			Else
				; something is running here, let's check on the output
				If($a_process[$n] <> 0 And _MSPingIsReady($a_process[$n])) Then
					$CurrentIP = _MSPingGetHostname($a_process[$n])
					$PingTime = _MSPingGetResult($a_process[$n])
					$ShowHost = StringSplit($CurrentIP, ".")
					$LastOct = StringFormat("%.3i", $ShowHost[4])
					If($PingTime <> -1) Then
						_GUICtrlListView_AddItem($Used, $ShowHost[1] & "." & $ShowHost[2] & "." & $ShowHost[3] & "." & $LastOct, $CurrentIndex)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, $PingTime & "ms", 2)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, "looking up host name.....", 1)
						$HostName = _HostName($CurrentIP)
						_GUICtrlListView_AddSubItem($Used, $CurrentIndex, $HostName, 1)
						$CurrentIndex += 1
					Else
						$FreeCount += 1
						_GUICtrlListView_AddItem($Unused, $ShowHost[1] & "." & $ShowHost[2] & "." & $ShowHost[3] & "." & $LastOct, $CurrentIndex)
					EndIf
					; free up an empty space for the next address to Ping
					$a_process[$n] = 0
					$Finished += 1 ; <=== new line
					If($Finished == UBound($Address)) Then
						ExitLoop 2 ; return
					EndIf
				EndIf
			EndIf
		Next
	Until 1 == 2 Or $ScanSTOP=1
	AdlibUnRegister()
	_Display()
	GUICtrlDelete($Progress)
	GUICtrlDelete($ScanningMessage)
	GUICtrlDelete($CurrentlyScanning)
	GUICtrlSetState($StartScan_btn, $GUI_ENABLE)
	GUICtrlSetState($Menu1, $GUI_ENABLE)
	GUICtrlSetState($MenuItem1, $GUI_ENABLE)
	GUICtrlSetState($Menu2, $GUI_ENABLE)
	GUICtrlSetState($Menu3, $GUI_ENABLE)
	GUICtrlSetState($StopScan_btn, $GUI_DISABLE)
;~ 	GUICtrlSetState($IPinBrowser, $GUI_ENABLE)
;~ 	GUICtrlSetState($IPinWinExplorer, $GUI_ENABLE)
;~ 	GUICtrlSetState($IPinRDP, $GUI_ENABLE)
;~ 	GUICtrlSetState($CopyToClip, $GUI_ENABLE)
;~ 	GUICtrlSetState($SaveToFile, $GUI_ENABLE)
;~ 	GUICtrlSetState($PingSpecific, $GUI_ENABLE)
;~ 	GUICtrlSetState($GetExternalIP, $GUI_ENABLE)
;~ 	GUICtrlSetState($Rescan, $GUI_ENABLE)
;~ 	$FinishMessage = GUICtrlCreateLabel("Finished scanning IP range in " & Round((TimerDiff($StartTime) / 1000), 2) & " seconds", 105, 315, 300, 20, $SS_CENTER)
	$fDblClkMessage = GUICtrlCreateLabel("Double click an IP to copy-to-clipboard", 150, 350, 300, 20)
EndFunc   ;==>_Scan

Func _OpenInBrowser()
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		ShellExecute("http://" & $FinalIP)
	Else
		MsgBox(16, "ERROR", "You have not selected an IP address yet.")
	EndIf
EndFunc   ;==>_OpenInBrowser

Func _OpenInExplorer()
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		Local $HostName=_HostName($IP)
;~ 		$Oct = StringSplit($IP, ".")
;~ 		$Last = Number($Oct[4]) ; strips out any leading 0s
;~ 		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		ShellExecute("\\" & $HostName & "\c$")
	Else
		MsgBox(16, "ERROR", "You have not selected an IP address yet.")
	EndIf
EndFunc   ;==>_OpenInExplorer

Func _OpenInRDP()
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		ShellExecute("mstsc", " /v:" & $FinalIP)
	Else
		MsgBox(16, "ERROR", "You have not selected an IP address yet.")
	EndIf
EndFunc   ;==>_OpenInRDP

Func _CopyToClip()
	If $DblClkList=1 Then
		$IP = ""
		$Index = _GUICtrlListView_GetSelectedIndices($Unused, False)
		If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Unused, $Index, 0)
		If $IP <> "" Then
			$Oct = StringSplit($IP, ".")
			$Last = Number($Oct[4]) ; strips out any leading 0s
			$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
			_ClipBoard_SetData($FinalIP)
			TrayTip("", "IP address " & $FinalIP & " sent to clipboard", 8, 16)
		Else
			MsgBox(16, "ERROR", "You have not selected an IP address yet.")
		EndIf
	ElseIf $DblClkList=2 Then
		$IP = ""
		$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
		If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
		If $IP <> "" Then
			$Oct = StringSplit($IP, ".")
			$Last = Number($Oct[4]) ; strips out any leading 0s
			$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
			_ClipBoard_SetData($FinalIP)
			TrayTip("", "IP address " & $FinalIP & " sent to clipboard", 8, 16)
		Else
			MsgBox(16, "ERROR", "You have not selected an IP address yet.")
		EndIf
	EndIf
EndFunc   ;==>_CopyToClip

Func _GetUserSelected()
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		_GetUser($FinalIP)
	Else
		MsgBox(16, "ERROR", "You have not selected an IP address yet.")
	EndIf
EndFunc   ;==>_CopyToClip

Func _SaveToFlie()
	$FileName = FileSaveDialog("Choose a location and name for the file", @DesktopDir, "CSV (*.CSV)", 16, "IPScan Output.csv")
	If $FileName <> "" Then
		FileDelete($FileName)
		$Output = FileOpen($FileName, 1 + 8)
		FileWriteLine($Output, "IP Address,Device Name,Ping Time")
		FileWriteLine($Output, "")
		$Count = _GUICtrlListView_GetItemCount($Used)
		For $a = 0 To $Count - 1
			$Item = _GUICtrlListView_GetItemText($Used, $a, 0)
			$Oct = StringSplit($Item, ".")
			$Last = Number($Oct[4]) ; strips out any leading 0s
			$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
			$DeviceName = _GUICtrlListView_GetItemText($Used, $a, 1)
			$PingTime = _GUICtrlListView_GetItemText($Used, $a, 2)
			FileWriteLine($Output, $FinalIP & "," & $DeviceName & "," & $PingTime)
		Next
		FileWriteLine($Output, "")
		FileWriteLine($Output, "")
		FileWriteLine($Output, "")
		FileWriteLine($Output, ",,,,Scan results saved " & @MON & "-" & @MDAY & "-" & @YEAR & " " & @HOUR & ":" & @MIN & ":" & @SEC)
		FileWriteLine($Output, ",,,,-MaxImuM AdVaNtAgE SofTWarE (C) 2014")
		FileClose($Output)
		TrayTip("Done", "IP address list has been saved", 8, 16)
	Else
	EndIf
EndFunc   ;==>_SaveToFlie

Func _PingSpecific($PingIP)
	SplashTextOn("", "Please wait, pinging " & $PingIP, 200, 80, (@DesktopWidth / 2) - 100, (@DesktopHeight / 2) - 40)
	$CMD = "ping " & $PingIP & " -n 4"
	$PID = Run($CMD, @ScriptDir, @SW_HIDE, "0x2")
	$Text = ""
	While ProcessExists($PID)
		$Line = StdoutRead($PID, 0)
		If @error Then ExitLoop
		$Text &= $Line
	WEnd
	SplashOff()
	MsgBox(64, "Ping Result", $Text)
EndFunc   ;==>_PingSpecific

Func _GetUser($PingIP)
	SplashTextOn("", "Retrieving User" & $PingIP, 200, 80, (@DesktopWidth / 2) - 100, (@DesktopHeight / 2) - 40)
	$CMD = "wmic.exe /node:" & $PingIP & " ComputerSystem Get UserName"
	$PID = Run($CMD, @ScriptDir, @SW_HIDE, $STDIN_CHILD + $STDERR_MERGED)
	$Text = ""
	While ProcessExists($PID)
		$Line = StdoutRead($PID)
		If @error Then ExitLoop
		$Text &= StringStripCR($Line)
	WEnd
	SplashOff()
	Local $Error1=StringInStr($Text, "Access is denied")
	Local $Error2=StringInStr($Text, " The RPC server is unavailable")
	If $Error1>0 Then
		MsgBox(16, "Error", "You do not have permission to view the User of this IP")
	ElseIf $Error2>0 Then
		MsgBox(16, "Error", "This machine does not support this function")
	Else
		MsgBox(64, "Lookup Result", $Text)
	EndIf
EndFunc   ;==>_PingSpecific

Func _MSPing($CurrentIP, $Timeout = $TimeoutDefault)
	Local $Return_Struc[4]
	; [0] = Result (in ms)
	; [1] = The hostname originally used
	; [2] = Process handle (for internal use only)
	; [3] = Buffer (for internal use only)
	$Return_Struc[1] = $CurrentIP
	$Return_Struc[2] = Run("ping " & $CurrentIP & " -n 1 -w " & $Timeout, "", @SW_HIDE, $STDOUT_CHILD)
	Return $Return_Struc
EndFunc   ;==>_MSPing
Func _MSPingIsReady(ByRef $Return_Struc)
	Return ___MSPingReadOutput($Return_Struc)
EndFunc   ;==>_MSPingIsReady
Func _MSPingGetResult($Return_Struc)
	Return $Return_Struc[0]
EndFunc   ;==>_MSPingGetResult
Func _MSPingGetHostname($Return_Struc)
	Return $Return_Struc[1]
EndFunc   ;==>_MSPingGetHostname
; Internal use only
Func ___MSPingReadOutput(ByRef $Return_Struc)
	$data = StdoutRead($Return_Struc[2])
	If(@error) Then
		___MSPingParseResult($Return_Struc)
		Return 1
	Else
		$Return_Struc[3] &= $data
		Return 0
	EndIf
EndFunc   ;==>___MSPingReadOutput
; Internal use only
Func ___MSPingParseResult(ByRef $Return_Struc)
	$Result = StringRegExp($Return_Struc[3], "([0-9]*)ms", 3)
	If @error Then
		$Return_Struc[0] = -1
	Else
		$Return_Struc[0] = $Result[0]
	EndIf
EndFunc   ;==>___MSPingParseResult

Func _HostName($CurIP)
	GUICtrlSetData($CurrentlyScanning, $CurrentIP)
	$DevName = _TCPIpToName($CurIP)
	If @error Then $DevName = "Unknown"
	if $CurIP==$ChosenIP Then
		$DevName&=" (** this PC)"
	endif
	if $CurIP==$Gateway Then
		$DevName&=" (** gateway)"
	endif
	Return $DevName
EndFunc   ;==>_HostName

Func _GetExternalIP()
    Local $bRead = InetRead("http://checkip.dyndns.org/")
    If @error Then $bRead = InetRead("                                              ")
    If Not @error Then
        Local $aIp = StringRegExp(BinaryToString($bRead),'\d{1,3}(\.\d{1,3}){3}',2)
        If Not @error Then Return $aIp[0]
    EndIf
    Return SetError(1,0,'SOMETHING WENT WRONG')
EndFunc   ;==>_GetIP2

Func _Display()
	GUICtrlSetData($Progress, ($Finished / 255) * 100)
	GUICtrlSetData($CurrentlyScanning, $CurrentIP)
	_GUICtrlStatusBar_SetText($StatusBar, "Used IP Addresses: " & $CurrentIndex, 0)
	_GUICtrlStatusBar_SetText($StatusBar, "Free IP Addresses: " & $FreeCount, 1)
EndFunc   ;==>_Display

Func _About()
	Local $AboutText = "Author: Ian Maxwell" & @CRLF & _
					   "AutoIt: autoitscript.com/forum/user/49852-llewxam/" & @CRLF & _
					   "Publish Date: 17 June 2010" & @CRLF & _
					   "Current Version: Rev.8" & @CRLF & _
					   "Last Update: 1/25/14"

	$AboutGUI = GUICreate("About Info", 394, 150, 192, 110)
	$AboutEdit = GUICtrlCreateEdit($AboutText, 35, 10, 325, 85, $ES_READONLY)
	GUICtrlSetState($AboutEdit, $GUI_DISABLE)
	$Box = GUICtrlCreateGraphic(5, 103, 130, 2) ;       <-------------------------------------------|
	GUICtrlSetGraphic($Box, $GUI_GR_COLOR, 0x787878) ;                                          <--|
	GUICtrlSetGraphic($Box, $GUI_GR_MOVE, 30, 1) ;                                              <--|  logo :)
	GUICtrlSetGraphic($Box, $GUI_GR_LINE, 230, 1) ;                                             <--|
	GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE© 2014", 35, 106, 290, 20) ;                   <--|
	GUICtrlSetColor(-1, 0x787878) ;                    <-------------------------------------------|
	GUISetState(@SW_SHOW, $AboutGUI)

     While 1
         ; We can only get messages from the second GUI
         Switch GUIGetMsg()
             Case $GUI_EVENT_CLOSE
                 GUIDelete($AboutGUI)
                 ExitLoop
 		EndSwitch
 	WEnd

EndFunc

; WM_NOTIFY event handler
Func _DoubleClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	If HWnd(DllStructGetData($tNMHDR, "hWndFrom")) == $Used And DllStructGetData($tNMHDR, "Code") == $NM_DBLCLK Then
		$DblClkList=2
		$aLV_Click_Info = _GUICtrlListView_SubItemHitTest($Used)
		; as long as the click was on an item or subitem
		If $aLV_Click_Info[0] <> -1 Then $fDblClk = True
	EndIf
	If HWnd(DllStructGetData($tNMHDR, "hWndFrom")) == $Unused And DllStructGetData($tNMHDR, "Code") == $NM_DBLCLK Then
		$DblClkList=1
		$aLV_Click_Info = _GUICtrlListView_SubItemHitTest($Unused)
		; as long as the click was on an item or subitem
		If $aLV_Click_Info[0] <> -1 Then $fDblClk = True
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_DoubleClick