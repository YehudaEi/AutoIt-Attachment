#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Version=beta
#AutoIt3Wrapper_Icon=C:\Program Files (x86)\AutoIt3\Icons\au3script_v10.ico
#AutoIt3Wrapper_UseUpx=n
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

#NoTrayIcon
TCPStartup()

;~ $HowManyReq = 1 ; number of ping requests in _MSPing
$TimeoutDefault = 500 ; timeout in miliseconds
Global $HostName, $WhichList, $List, $Used, $StartTime, $Finished, $CurrentIP, $CurrentIndex, $FreeCount, $Progress, $CurrentlyScanning, $FinishMessage, $fDblClkMessage
Global Const $MAX_PROCESS = 30 ; maximum processes at once
Global $fDblClk = False, $aLV_Click_Info

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
	$Box = GUICtrlCreateGraphic(5, 83, 130, 2) ;       <-------------------------------------------|
	GUICtrlSetGraphic($Box, $GUI_GR_COLOR, 0x787878) ;                                          <--|
	GUICtrlSetGraphic($Box, $GUI_GR_MOVE, 30, 1) ;                                              <--|  logo :)
	GUICtrlSetGraphic($Box, $GUI_GR_LINE, 230, 1) ;                                             <--|
	GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE© 2014", 35, 86, 290, 20) ;                   <--|
	GUICtrlSetColor(-1, 0x787878) ;                    <-------------------------------------------|
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

$GUI = GUICreate("IP Scanner - January 25 2014 build", 510, 400)
GUISetBkColor(0xb2ccff, $GUI)
GUISetFont(8.5)
$IPinBrowser = GUICtrlCreateButton("Open With &Web Browser", 10, 5, 160, 20)
GUICtrlSetTip(-1, "The selected IP address will be opened in a web browser (best for printers)")
$IPinWinExplorer = GUICtrlCreateButton("Open With Windows &Explorer", 175, 5, 160, 20)
GUICtrlSetTip(-1, "The selected IP address will be opened in Windows Explorer (best for computers with network shares)")
$IPinRDP = GUICtrlCreateButton("Open With &Remote Desktop", 340, 5, 160, 20)
GUICtrlSetTip(-1, "The selected IP address will be opened in Windows Explorer (best for computers with network shares)")
$CopyToClip = GUICtrlCreateButton("&Copy Selected", 10, 30, 90, 20)
GUICtrlSetTip(-1, "The selected IP address will be copied to the clipboard")
$SaveToFile = GUICtrlCreateButton("E&xport To CSV", 110, 30, 90, 20)
GUICtrlSetTip(-1, "The results of the scan will be saved to a CSV file")
$PingSpecific = GUICtrlCreateButton("&Ping Specific", 210, 30, 90, 20)
GUICtrlSetTip(-1, "Scan a specific IP address")
$GetExternalIP = GUICtrlCreateButton("&Get External IP", 310, 30, 90, 20)
GUICtrlSetTip(-1, "Scan a specific IP address")
$Rescan = GUICtrlCreateButton("Resca&n", 410, 30, 90, 20)
GUICtrlSetTip(-1, "The results of the scan will be saved to a CSV file")
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
$Box = GUICtrlCreateGraphic(10, 358, 500, 2) ;      <----------------------------------------------|
GUICtrlSetGraphic($Box, $GUI_GR_COLOR, 0x787878) ;                                              <--|
GUICtrlSetGraphic($Box, $GUI_GR_MOVE, 295, 1) ;                                                 <--|
GUICtrlSetGraphic($Box, $GUI_GR_LINE, 500, 1) ;                                                 <--|
GUICtrlCreateLabel("MaxImuM AdVaNtAgE SofTWarE© 2014", 300, 360, 200, 20, $SS_RIGHT) ;          <--|
GUICtrlSetColor(-1, 0x787878) ;        <-----------------------------------------------------------|
Local $AccelKeys[8][2] = [["^w", $IPinBrowser],["^e", $IPinWinExplorer],["^r", $IPinRDP],["^c", $CopyToClip],["^x", $SaveToFile],["^p", $PingSpecific],["^g", $GetExternalIP],["^n", $Rescan]]
GUISetAccelerators($AccelKeys)
GUISetState(@SW_SHOW, $GUI)

GUIRegisterMsg($WM_NOTIFY, "_DoubleClick")

$Gateway=_GetGateway()
_Scan()

Do
	$MSG = GUIGetMsg()
	If $MSG == $GUI_EVENT_CLOSE Then Exit
	If $MSG == $IPinBrowser Then _OpenInBrowser()
	If $MSG == $IPinWinExplorer Then _OpenInExplorer()
	If $MSG == $IPinRDP Then _OpenInRDP()
	If $MSG == $CopyToClip Then _CopyToClip()
	If $MSG == $SaveToFile Then _SaveToFlie()
	If $MSG == $PingSpecific Then
		$GetSpecific=InputBox("Get IP Address","Enter an IP Address to ping")
		_PingSpecific($GetSpecific)
	EndIf
	If $MSG == $GetExternalIP Then
		GUICtrlSetData($ExternalIP,"External IP Address: working...")
		$GetExternalIPAddress=_GetExternalIP()
		GUICtrlSetData($ExternalIP,"External IP Address: "&$GetExternalIPAddress)
	EndIf
	If $MSG == $Rescan Then
		_GUICtrlListView_DeleteAllItems($Used)
		_GUICtrlListView_DeleteAllItems($Unused)
		_Scan()
	EndIf
	If $fDblClk Then
		$fDblClk = False
		Switch $aLV_Click_Info[1]
			Case 0 ; On Item
				$sText = _GUICtrlListView_GetItemText($Used, $aLV_Click_Info[0])
				_PingSpecific($sText)
		EndSwitch
	EndIf
Until 1 == 2
Exit


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
	GUICtrlDelete($FinishMessage)
	GUICtrlDelete($fDblClkMessage)
	GUICtrlSetState($IPinBrowser, $GUI_DISABLE)
	GUICtrlSetState($IPinWinExplorer, $GUI_DISABLE)
	GUICtrlSetState($IPinRDP, $GUI_DISABLE)
	GUICtrlSetState($CopyToClip, $GUI_DISABLE)
	GUICtrlSetState($SaveToFile, $GUI_DISABLE)
	GUICtrlSetState($PingSpecific, $GUI_DISABLE)
	GUICtrlSetState($GetExternalIP, $GUI_DISABLE)
	GUICtrlSetState($Rescan, $GUI_DISABLE)
	$Progress = GUICtrlCreateProgress(10, 310, 490, 20)
	$ScanningMessage = GUICtrlCreateLabel("Currently Scanning:", 10, 340, 95, 15)
	$CurrentlyScanning = GUICtrlCreateLabel("", 105, 340, 80, 15)

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
	Until 1 == 2
	AdlibUnRegister()
	_Display()
	GUICtrlDelete($Progress)
	GUICtrlDelete($ScanningMessage)
	GUICtrlDelete($CurrentlyScanning)
	GUICtrlSetState($IPinBrowser, $GUI_ENABLE)
	GUICtrlSetState($IPinWinExplorer, $GUI_ENABLE)
	GUICtrlSetState($IPinRDP, $GUI_ENABLE)
	GUICtrlSetState($CopyToClip, $GUI_ENABLE)
	GUICtrlSetState($SaveToFile, $GUI_ENABLE)
	GUICtrlSetState($PingSpecific, $GUI_ENABLE)
	GUICtrlSetState($GetExternalIP, $GUI_ENABLE)
	GUICtrlSetState($Rescan, $GUI_ENABLE)
	$FinishMessage = GUICtrlCreateLabel("Finished scanning IP range in " & Round((TimerDiff($StartTime) / 1000), 2) & " seconds", 105, 315, 300, 20, $SS_CENTER)
	$fDblClkMessage = GUICtrlCreateLabel("Double click any used IP to ping", 10, 335, 180, 20)
	ControlFocus("IP Scanner", "MaxImuM AdVaNtAgE SofTWarE", $Used)
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
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		ShellExecute("\\" & $FinalIP)
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
	$IP = ""
	$Index = _GUICtrlListView_GetSelectedIndices($Used, False)
	If $Index <> "" Then $IP = _GUICtrlListView_GetItemText($Used, $Index, 0)
	If $IP <> "" Then
		$Oct = StringSplit($IP, ".")
		$Last = Number($Oct[4]) ; strips out any leading 0s
		$FinalIP = $Oct[1] & "." & $Oct[2] & "." & $Oct[3] & "." & $Last
		_ClipBoard_SetData($FinalIP)
		TrayTip("Done", "IP address " & $FinalIP & " sent to clipboard", 8, 16)
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
		MsgBox(16, "ERROR", "A location or file name were not chosen, nothing was saved.")
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
	MsgBox(64, "Result", $Text)
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

; WM_NOTIFY event handler
Func _DoubleClick($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
	If HWnd(DllStructGetData($tNMHDR, "hWndFrom")) == $Used And DllStructGetData($tNMHDR, "Code") == $NM_DBLCLK Then
		$aLV_Click_Info = _GUICtrlListView_SubItemHitTest($Used)
		; as long as the click was on an item or subitem
		If $aLV_Click_Info[0] <> -1 Then $fDblClk = True
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_DoubleClick