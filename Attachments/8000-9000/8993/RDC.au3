
$RDPini = @ScriptDir & "\RDC.ini"
$TempLoc = @TempDir & "\RDPconn"

#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <GuiCombo.au3>
Opt("RunErrorsFatal", 0)
$vCount = 0
Dim $vPID[250]
Dim $CurrentSel = -1

$Form1 = GUICreate("Remote Desktop Connector", 240, 600, 0, 0)
$menuFile = GUICtrlCreateMenu("File")
$fileExit = GUICtrlCreateMenuitem("E&xit", $menuFile)
$menuTools = GUICtrlCreateMenu("Tools")
$ToolsNew = GUICtrlCreateMenuitem("New Connection Item", $menuTools)
$ToolsCredentials = GUICtrlCreateMenuitem("Update/Add Credentials", $menuTools)

$List1 = GUICtrlCreateListView("Address|Credentials|#", 10, 10, 220, 530, -1, $WS_EX_CLIENTEDGE)
$vConnCurrent = IniReadSection($RDPini, "Connections")
if not @error Then
	for $vCi = 1 to $vConnCurrent[0][0]
		_GUICtrlListViewInsertItem($List1, -1, $vConnCurrent[$vCi][0] & "|" & $vConnCurrent[$vCi][1])
	Next
EndIf
_GUICtrlListViewSetColumnWidth($List1, 0, 100)
_GUICtrlListViewSetColumnWidth($List1, 1, 100)

$ctxListMenu = GUICtrlCreateContextMenu($list1)
$ctxConnect = GUICtrlCreateMenuitem("Connect", $ctxListMenu)
$ctxCconnect = GUICtrlCreateMenuitem("Console Connect", $ctxListMenu)
GUICtrlCreateMenuitem("", $ctxListMenu)
$ctxNew = GUICtrlCreateMenuitem("New Connection", $ctxListMenu)
$ctxDelete = GUICtrlCreateMenuitem("Delete Connection", $ctxListMenu)

GUISetState()
Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($List1)]
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $ctxDelete
		$vSelIdx = _GUICtrlListViewGetCurSel($List1)
		if $vSelIdx <> $LV_ERR Then
			$vSelected = _GUICtrlListViewGetItemTextArray($List1, $vSelIdx)
			if $vSelected[0] = 3 Then
				if MsgBox(308,"Item Delete","Are you sure you want to delete " & $vSelected[1] & "?") = 6 Then
					IniDelete($RDPini, "Connections", $vSelected[1])
					if not @error Then _GUICtrlListViewDeleteItem($List1, $vSelIdx)
				EndIf
			EndIf
		EndIf
		
	Case $msg = $ToolsCredentials
		_CredentialsGUI()
		WinActivate($Form1, "")
		
	Case $msg = $List1
		for $t = 0 to _GUICtrlListViewGetItemCount($list1) - 1
			$vlistOrder = _GUICtrlListViewGetItemTextArray($list1, $t)
			if $vlistOrder[0] = 3 Then
				if not WinExists($vlistOrder[3] & " - " & $vlistOrder[1], "") Then
					_GUICtrlListViewSetItemText($List1, $t, 2, "")
				EndIf
			EndIf
		Next
		_GUICtrlListViewSort($List1, $B_DESCENDING, GUICtrlGetState($List1))

	Case $msg = $GUI_EVENT_PRIMARYDOWN ;clicked on a item in the $listview
		if ControlGetFocus($Form1, "") = "SysListView321" Then
			if _GUICtrlListViewGetCurSel($List1) <> $CurrentSel Then
				$CurrentSel = _GUICtrlListViewGetCurSel($List1)
				if $CurrentSel <> $LV_ERR Then
					$vSelected = _GUICtrlListViewGetItemTextArray($List1, $CurrentSel)
					if $vSelected[0] = 3 Then
						if $vSelected[3] <> "" and WinExists($vSelected[3] & " - " & $vSelected[1], "") Then
							WinActivate($vSelected[3] & " - " & $vSelected[1], "")
						Else
							GUISetCursor(15, 1)
							$winTitle = _RDPcreate($vSelected[1], $vSelected[2], 1)
							GUISetCursor(2, 1)
							if $winTitle <> 0 Then 
								_GUICtrlListViewSetItemText($List1, $CurrentSel, 2, $winTitle)
							Else
								_GUICtrlListViewSetItemText($List1, $CurrentSel, 2, "")
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	
	Case $msg = $ctxConnect
		$vSelIdx = _GUICtrlListViewGetCurSel($List1)
		if $vSelIdx <> $LV_ERR Then
			$vSelected = _GUICtrlListViewGetItemTextArray($List1, $vSelIdx)
			if $vSelected[0] = 3 Then
				if $vSelected[3] <> "" and WinExists($vSelected[3] & " - " & $vSelected[1], "") Then
					WinActivate($vSelected[3] & " - " & $vSelected[1], "")
				Else
					GUISetCursor(15, 1)
					$winTitle = _RDPcreate($vSelected[1], $vSelected[2], 1)
					GUISetCursor(2, 1)
					if $winTitle <> 0 Then 
						_GUICtrlListViewSetItemText($List1, $vSelIdx, 2, $winTitle)
					Else
						_GUICtrlListViewSetItemText($List1, $vSelIdx, 2, "")
					EndIf
				EndIf
			EndIf
		EndIf
	
	Case $msg = $ctxCconnect
		$vSelIdx = _GUICtrlListViewGetCurSel($List1)
		if $vSelIdx <> $LV_ERR Then
			$vSelected = _GUICtrlListViewGetItemTextArray($List1, $vSelIdx)
			if $vSelected[0] = 3 Then
				if $vSelected[3] <> "" and WinExists($vSelected[3] & " - " & $vSelected[1], "") Then
					WinActivate($vSelected[3] & " - " & $vSelected[1], "")
				Else
					GUISetCursor(15, 1)
					$winTitle = _RDPcreate($vSelected[1], $vSelected[2], 1, 1)
					GUISetCursor(2, 1)
					if $winTitle <> 0 Then 
						_GUICtrlListViewSetItemText($List1, $vSelIdx, 2, $winTitle)
					Else
						_GUICtrlListViewSetItemText($List1, $vSelIdx, 2, "")
					EndIf
				EndIf
			EndIf
		EndIf
	
	Case $msg = $ToolsNew or $msg = $ctxNew
		_CreateNewConnection()
		WinActivate($Form1, "")
		
	Case $msg = $GUI_EVENT_CLOSE or $msg = $fileExit
		for $i = 1 to $vPID[0]
			ProcessClose($vPID[$i])
		Next
		sleep(100)
		DirRemove($TempLoc, 1)
		ExitLoop
		
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit


Func _CreateNewConnection()
$childAddNew = GUICreate("Add New Connection", 346, 190, 192, 125, "", "", $Form1)
$aNadds = GUICtrlCreateInput("", 144, 32, 185, 21, -1, $WS_EX_CLIENTEDGE)
$aNcreds = GUICtrlCreateCombo("", 144, 80, 185, 21)
$vaNcreds = IniReadSection($RDPini, "Credentials")
if not @error Then
	Dim $aNdta
	for $i = 1 to $vaNcreds[0][0]
		$aNdta = $aNdta & "|" & $vaNcreds[$i][0]
	Next
	GUICtrlSetData($aNcreds, $aNdta)
EndIf
GUICtrlCreateLabel("Computer Name or IP", 16, 32, 105, 17)
GUICtrlCreateLabel("Credentials to Log in with", 16, 80, 122, 17)
$btnaNsave = GUICtrlCreateButton("Save", 56, 120, 89, 25, $BS_DEFPUSHBUTTON)
$btnaNclose = GUICtrlCreateButton("Close", 184, 120, 89, 25)

GUISetState(@SW_SHOW)
GUISwitch($childAddNew)
While 1
	$msgaN = GuiGetMsg()
	Select
	Case $msgaN = $GUI_EVENT_CLOSE or $msgaN = $btnaNclose
		GUISwitch($Form1)
		GUIDelete($childAddNew)
		return 0

	Case $msgaN = $btnaNsave
		$aNvAdds = GUICtrlRead($aNadds)
		$aNvCred = GUICtrlRead($aNcreds)
		if $aNvAdds = "" or $aNvCred = "" Then
			MsgBox(0, "Error", "You must specify an Address and credentials to connect with")
		Else
			IniWrite($RDPini, "Connections", $aNvAdds, $aNvCred)
			if not @error Then
				if _GUICtrlListViewInsertItem($List1, -1, $aNvAdds & "|" & $aNvCred) <> $LV_ERR Then
					MsgBox(0, "Saved", "The connection item has been saved")
					GUICtrlSetData($aNadds, "")
					_GUICtrlComboSetCurSel($aNcreds, -1)
				Else
					MsgBox(0, "Error", "The connection item has been saved, Unable to update the List.  Please close then re-open the application to see the new connection item")
				EndIf
			Else
				MsgBox(0, "Error", "Unable to save the connection item")
			EndIf
		EndIf
	Case Else
		;;;;;;;
	EndSelect
WEnd
EndFunc



Func _RDPcreate($IP, $Credentials, $Connect = 0, $Console = 0)
if $IP <> "" Then
	$Password = IniRead($RDPini, "Credentials", $Credentials, "")
	$rdpCreds = StringSplit($Credentials, "\")
	if $rdpCreds[1] = "Local" Then
		$rdpUser = $rdpCreds[2]
		$rdpDomain = ""
	Else
		$rdpUser = $rdpCreds[2]
		$rdpDomain = $rdpCreds[1]
	EndIf
	$vCount =$vCount + 1
	$RDPfile = FileOpen($TempLoc & "\" & $vCount & ".rdp", 10)
	if $RDPfile <> -1 Then
		FileWriteLine($RDPfile, "screen mode id:i:1")
		FileWriteLine($RDPfile, "session bpp:i:16")
		FileWriteLine($RDPfile, "winposstr:s:0,1,0,0,640,480")
		FileWriteLine($RDPfile, "full address:s:" & $IP)
		FileWriteLine($RDPfile, "compression:i:1")
		FileWriteLine($RDPfile, "keyboardhook:i:2")
		FileWriteLine($RDPfile, "audiomode:i:0")
		FileWriteLine($RDPfile, "redirectdrives:i:0")
		FileWriteLine($RDPfile, "redirectprinters:i:1")
		FileWriteLine($RDPfile, "redirectcomports:i:0")
		FileWriteLine($RDPfile, "redirectsmartcards:i:1")
		FileWriteLine($RDPfile, "displayconnectionbar:i:1")
		FileWriteLine($RDPfile, "autoreconnection enabled:i:1")
		FileWriteLine($RDPfile, "username:s:" & $rdpUser)
		FileWriteLine($RDPfile, "domain:s:" & $rdpDomain)
		FileWriteLine($RDPfile, "alternate shell:s:")
		FileWriteLine($RDPfile, "shell working directory:s:")
		if $Password <> "" Then FileWriteLine($RDPfile, "password 51:b:" & $Password)
		FileWriteLine($RDPfile, "disable wallpaper:i:0")
		FileWriteLine($RDPfile, "disable full window drag:i:0")
		FileWriteLine($RDPfile, "disable menu anims:i:0")
		FileWriteLine($RDPfile, "disable themes:i:0")
		FileWriteLine($RDPfile, "disable cursor setting:i:0")
		FileWriteLine($RDPfile, "bitmapcachepersistenable:i:1")
		if $Console <> 0 Then
			FileWriteLine($RDPfile, "connect to console:i:1") ;add this line if console connect is checked.
		EndIf
		FileWriteLine($RDPfile, "smart sizing:i:1")
		FileClose($RDPfile)
		if $Connect = 1 Then
			$pidValue = $vCount
			For $i = 1 to $vCount
				if not ProcessExists($vPID[$i]) Then
					$pidValue = $i
					ExitLoop
				EndIf
			Next
			$vPID[$pidValue] = run(@SystemDir & "\mstsc.exe " & $TempLoc & "\" & $vCount & ".rdp", @SystemDir, @SW_HIDE)
			if not @error then 
				while ProcessExists($vPID[$pidValue])
					if WinExists($vCount & " - " & $IP, "") Then
						$vPID[0] = $vCount
						$mainPOS = WinGetPos($Form1, "")
						WinMove($vCount & " - " & $IP, "", $mainPOS[0] + $mainPOS[2], $MainPOS[1], 640, 480)
						WinSetState($vCount & " - " & $IP, "", @SW_SHOW)
						GUISetCursor(2, 1)
						Return $vCount
					EndIf
				WEnd
			EndIf
		Else
			GUISetCursor(2, 1)
			Return $TempLoc & "\" & $vCount & ".rdp"
		EndIf
	EndIf
EndIf
GUISetCursor(2, 1)
Return 0
EndFunc


Func _CredentialsGUI()
Dim $sCredDomain = "|Local"
Dim $sCredUser
$vCredCurrent = IniReadSection($RDPini, "Credentials")
if not @error Then
	for $vCi = 1 to $vCredCurrent[0][0]
		$credSplit = StringSplit($vCredCurrent[$vCi][0], "\")
		if $credSplit[0] = 2 Then
			if not StringInStr($sCredDomain, $credSplit[1]) Then $sCredDomain = $sCredDomain & "|" & $credSplit[1]
			if not StringInStr($sCredUser, $credSplit[2]) Then $sCredUser = $sCredUser & "|" & $credSplit[2]
		EndIf
	Next
EndIf

$GUICred = GUICreate("Add/Update Credentials", 310, 200, 192, 125, "", "", $Form1)
GUICtrlCreateLabel("Domain", 32, 24, 40, 17)
GUICtrlCreateLabel("UserName", 32, 56, 54, 17)
GUICtrlCreateLabel("Password", 32, 88, 50, 17)
$cmboDomain = GUICtrlCreateCombo("", 96, 24, 177, 21)
GUICtrlSetData($cmboDomain, $sCredDomain)
$cmboUser = GUICtrlCreateCombo("", 96, 56, 177, 21)
GUICtrlSetData($cmboUser, $sCredUser)
$inputPwd = GUICtrlCreateInput("", 96, 88, 177, 21, $ES_Password, $WS_EX_CLIENTEDGE)
$btnSave = GUICtrlCreateButton("Save", 56, 128, 81, 25)
GUICtrlSetState($btnSave, $GUI_DEFBUTTON)
$btnCancel = GUICtrlCreateButton("Close", 168, 128, 81, 25)

GUISetState()
GUISwitch($GUICred)
While 1
	$msgCred = GuiGetMsg()
	Select
	Case $msgCred = $GUI_EVENT_CLOSE or $msgCred = $btnCancel
		GUIDelete($GUICred)
		GUISwitch($Form1)
		Return 0
		
	Case $msgCred = $cmboUser
		GUICtrlSetData($inputPwd, IniRead($RDPini, "Credentials", GUICtrlRead($cmboDomain) & "\" & GUICtrlRead($cmboUser), ""))
		
	Case $msgCred = $btnSave
		$sNewDomainCred = GUICtrlRead($cmboDomain)
		$sNewUserCred = GUICtrlRead($cmboUser)
		if $sNewDomainCred = "" or $sNewUserCred = "" Then
			MsgBox(0, "Error", "You must fill out the Domain and Username")
		Else
			GUISetCursor(15, 1)
			_UpdateRDPCred($sNewDomainCred & "\" & $sNewUserCred, GUICtrlRead($inputPwd))
			GUICtrlSetData($inputPwd, "")
			_GUICtrlComboSetCurSel($cmboDomain, -1)
			_GUICtrlComboSetCurSel($cmboUser, -1)
			GUISetCursor(2, 1)
		EndIf
	
	Case Else
		;;;;;;;
	EndSelect
WEnd
EndFunc


Func _UpdateRDPCred($Credentials, $NewPwd)
if $Credentials = "" then
	MsgBox(0, "Error", "The Credentials were not specified")
	return 0
EndIf
$rdpCreds = StringSplit($Credentials, "\")
if @error Then 
	$rdpUser = $Credentials
	$rdpDomain = ""
Else
	$rdpUser = $rdpCreds[2]
	$rdpDomain = $rdpCreds[1]
EndIf
FileDelete(@TempDir & "\RDPpw1.rdp")
run(@SystemDir & "\mstsc.exe /e " & _RDPcreate("TestPCname", $Credentials), @SystemDir)
WinWaitActive("Remote Desktop Connection", "Type the name of the computer")
ControlSetText("Remote Desktop Connection", "Type the name of the computer", "Edit2", $rdpUser)
ControlSetText("Remote Desktop Connection", "Type the name of the computer", "Edit3", $NewPwd)
ControlSetText("Remote Desktop Connection", "Type the name of the computer", "Edit4", $rdpDomain)
ControlCommand("Remote Desktop Connection", "Type the name of the computer", "S&ave my password", "Check", "")
ControlClick("Remote Desktop Connection", "Type the name of the computer", "Sa&ve As...")
WinWaitActive("Save As", "Remote Desktop Files (*.RDP)")
ControlSetText("Save As", "Remote Desktop Files (*.RDP)", "Edit1", $TempLoc & "\RDPpw1.rdp")
ControlClick("Save As", "Remote Desktop Files (*.RDP)", "&Save")
WinWaitActive("Remote Desktop Connection", "Type the name of the computer")
ControlClick("Remote Desktop Connection", "Type the name of the computer", "Cancel")
GUISetCursor(15, 1)
$tmpFile = Run(@SystemDir & "\Notepad.exe " & $TempLoc & "\RDPpw1.rdp", @SystemDir, @SW_HIDE)
Sleep(2500)
$tString = ControlGetText("RDPpw1.rdp", "", "Edit1")
ProcessClose($tmpFile)
if $NewPwd = "" Then IniWrite($RDPini, "Credentials", $Credentials, "")
$vRDPstr = StringSplit($tString, @CRLF)
for $i = 1 to $vRDPstr[0]
	if StringInStr($vRDPstr[$i], "password 51:b:") Then
		$sTmpPW = StringTrimLeft($vRDPstr[$i], 14)
		IniWrite($RDPini, "Credentials", $Credentials, $sTmpPW)
		if not @error Then
			MsgBox(0, "Finished", "Credentials were successfully saved")
			Return 1
		Else
			MsgBox(0, "Error", "Unable to save the specified credentials")
		EndIf
	EndIf
Next
Return 0
EndFunc