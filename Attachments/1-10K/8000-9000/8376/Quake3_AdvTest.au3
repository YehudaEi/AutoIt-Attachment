#include <GUIConstants.au3>
#include <GUIListView.au3>
#include "Quake3.au3"

; Server information input
Dim $sIP, $iPort, $sPassword
_InputInfo($sIP, $iPort, $sPassword)

; Server information
GUICreate("Quake3 Test", 660, 420)
GUICtrlCreateTab(10, 10, 640, 400, $TCS_BOTTOM)

GUICtrlCreateTabItem("Server Info")

; Info-list
$cInfoLabel = GUICtrlCreateLabel("Info", 20, 20, 200, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cInfoList = GUICtrlCreateListView("Key|Value", 20, 50, 200, 325)
$cInfoMenu = GUICtrlCreateContextMenu($cInfoList)
$cInfoUpd = GUICtrlCreateMenuItem("Update", $cInfoMenu)

; Status-list
$cStatusLabel = GUICtrlCreateLabel("Status", 230, 20, 200, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cStatusList = GUICtrlCreateListView("Key|Value", 230, 50, 200, 325)
$cStatusMenu = GUICtrlCreateContextMenu($cStatusList)
$cStatusUpd = GUICtrlCreateMenuItem("Update", $cStatusMenu)

; Client-list
$cClientLabel = GUICtrlCreateLabel("Client List", 440, 20, 200, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cClientList = GUICtrlCreateListView("Client|Score|Ping", 440, 50, 200, 325)
$cClientMenu = GUICtrlCreateContextMenu($cClientList)
$cClientUpd = GUICtrlCreateMenuItem("Update", $cClientMenu)

GUICtrlCreateTabItem("Admin Control")

; Rcon system
$cRconLabel = GUICtrlCreateLabel("Remote Console", 20, 20, 410, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cRconEdit = GUICtrlCreateEdit("", 20, 50, 410, 290, BitOR($GUI_SS_DEFAULT_EDIT, $WS_VSCROLL, $ES_READONLY, $ES_AUTOHSCROLL))
$cRconInput = GUICtrlCreateInput("", 20, 355, 350, 20)
$cRconSend = GUICtrlCreateButton("Send", 380, 355, 50, 20)

; Rcon Client-list
$cRClientLabel = GUICtrlCreateLabel("Client List", 440, 20, 200, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cRClientList = GUICtrlCreateListView("Number|Name|IP", 440, 50, 200, 140)
$cRClientMenu = GUICtrlCreateContextMenu($cRClientList)
$cRClientUpd = GUICtrlCreateMenuItem("Update", $cRClientMenu)
GUICtrlCreateMenuItem("", $cRClientMenu)
$cRClientKick = GUICtrlCreateMenuItem("Kick client", $cRClientMenu)
$cRClientBan = GUICtrlCreateMenuItem("Ban client", $cRClientMenu)

; Banned IPs
$cBanLabel = GUICtrlCreateLabel("Banned IPs", 440, 205, 200, 20, BitOR($SS_SUNKEN, $SS_CENTER))
$cBanList = GUICtrlCreateList("", 440, 235, 200, 140, $LBS_NOINTEGRALHEIGHT)
$cBanMenu = GUICtrlCreateContextMenu($cBanList)
$cBanUpd = GUICtrlCreateMenuItem("Update", $cBanMenu)
GUICtrlCreateMenuItem("", $cBanMenu)
$cBanRemove = GUICtrlCreateMenuItem("Remove IP", $cBanMenu)

GUICtrlSetState($cRClientUpd, $GUI_DEFBUTTON)
GUICtrlSetState($cRconSend, $GUI_DEFBUTTON)
GUICtrlSetState($cBanUpd, $GUI_DEFBUTTON)
GUICtrlSetColor($cStatusLabel, 0xFFFFFF)
GUICtrlSetColor($cInfoLabel, 0xFFFFFF)
GUICtrlSetColor($cClientLabel, 0xFFFFFF)
GUICtrlSetColor($cRconLabel, 0xFFFFFF)
GUICtrlSetColor($cRClientLabel, 0xFFFFFF)
GUICtrlSetColor($cBanLabel, 0xFFFFFF)
GUICtrlSetBkColor($cStatusLabel, 0x0)
GUICtrlSetBkColor($cInfoLabel, 0x0)
GUICtrlSetBkColor($cClientLabel, 0x0)
GUICtrlSetBkColor($cRconLabel, 0x0)
GUICtrlSetBkColor($cRClientLabel, 0x0)
GUICtrlSetBkColor($cBanLabel, 0x0)
GUICtrlSetFont($cStatusLabel, 10, 1000)
GUICtrlSetFont($cInfoLabel, 10, 1000)
GUICtrlSetFont($cClientLabel, 10, 1000)
GUICtrlSetFont($cRconLabel, 10, 1000)
GUICtrlSetFont($cRClientLabel, 10, 1000)
GUICtrlSetFont($cBanLabel, 10, 1000)
GUICtrlSetFont($cRconEdit, -1, 100, -1, "Courier New")

UDPStartup ()
_UpdateInfo()
_UpdateStatus()
_UpdateClients()
GUISetState()

While 1
	$iMsg = GUIGetMsg()
	If $iMsg = $GUI_EVENT_CLOSE Then Exit
	
	Select
		Case $iMsg = $cInfoUpd
			_UpdateInfo()
			
		Case $iMsg = $cStatusUpd
			_UpdateStatus()
			
		Case $iMsg = $cClientUpd
			_UpdateClients()
			
		Case $iMsg = $cRClientUpd
			_UpdateRClients()
			
		Case $iMsg = $cRClientKick
			If GUICtrlRead($cRClientList) <> "" Then
				$iClient = GUICtrlRead(GUICtrlRead($cRClientList))
				$iClient = StringLeft($iClient, StringInStr($iClient, "|") - 1)
				
				_Q3AdminKick ($sIP, $sPassword, $iClient, False, $iPort)
				If Not @error Then
					Sleep(500)
					_UpdateRClients()
				EndIf
			EndIf
			
		Case $iMsg = $cRClientBan
			If GUICtrlRead($cRClientList) <> "" Then
				$sClient = GUICtrlRead(GUICtrlRead($cRClientList))
				$sClient = StringTrimLeft($sClient, StringInStr($sClient, "|", 0, -1))
				
				_Q3AdminBan ($sIP, $sPassword, $sClient, $iPort)
				If Not @error Then
					Sleep(500)
					_UpdateRClients()
					Sleep(500)
					_UpdateBanList()
				EndIf
			EndIf
			
		Case $iMsg = $cBanUpd
			_UpdateBanList()
			
		Case $iMsg = $cBanRemove
			If GUICtrlRead($cBanList) <> "" Then
				_Q3AdminUnban ($sIP, $sPassword, GUICtrlRead($cBanList), $iPort)
				If Not @error Then
					Sleep(500)
					_UpdateBanList()
				EndIf
			EndIf
			
		Case $iMsg = $cRconSend
			$sCommand = GUICtrlRead($cRconInput)
			If $sCommand <> "" Then
				GUICtrlSetData($cRconEdit, "> " & $sCommand & @CRLF, "upd")
				GUICtrlSetData($cRconInput, "")
				$sRecv = _Q3AdminRcon ($sIP, $sPassword, $sCommand, $iPort)
				If Not @error Then
					GUICtrlSetData($cRconEdit, StringReplace($sRecv, @LF, @CRLF) & @CRLF, "upd")
				Else
					GUICtrlSetData($cRconEdit, "(error : " & @error & ")" & @CRLF, "upd")
				EndIf
			EndIf
	EndSelect
WEnd


Func _UpdateInfo()
	Local $aInfo = _Q3ServerInfo ($sIP, $iPort)
	
	_GUICtrlListViewDeleteAllItems ($cInfoList)
	For $i = 1 To $aInfo[0][0]
		GUICtrlCreateListViewItem($aInfo[$i][0] & "|" & $aInfo[$i][1], $cInfoList)
	Next
EndFunc   ;==>_UpdateInfo

Func _UpdateStatus()
	Local $aStatus = _Q3ServerStatus ($sIP, $iPort)
	
	_GUICtrlListViewDeleteAllItems ($cStatusList)
	For $i = 1 To $aStatus[0][0]
		GUICtrlCreateListViewItem($aStatus[$i][0] & "|" & $aStatus[$i][1], $cStatusList)
	Next
EndFunc   ;==>_UpdateStatus

Func _UpdateClients()
	Local $aClients = _Q3ServerClients ($sIP, $iPort)
	
	_GUICtrlListViewDeleteAllItems ($cClientList)
	For $i = 1 To $aClients[0][0]
		GUICtrlCreateListViewItem(_Q3StripColors ($aClients[$i][0]) & "|" & $aClients[$i][1] & "|" & $aClients[$i][2], $cClientList)
	Next
EndFunc   ;==>_UpdateClients

Func _UpdateRClients()
	Local $aClients = _Q3AdminClients ($sIP, $sPassword, $iPort)
	
	_GUICtrlListViewDeleteAllItems ($cRClientList)
	For $i = 1 To $aClients[0][0]
		GUICtrlCreateListViewItem($aClients[$i][0] & "|" & _Q3StripColors ($aClients[$i][3]) & "|" & $aClients[$i][5], $cRClientList)
	Next
EndFunc   ;==>_UpdateRClients

Func _UpdateBanList()
	Local $aBanList = _Q3AdminBanList ($sIP, $sPassword, $iPort)
	If $aBanList[0] = 0 Then Return
	
	GUICtrlSetData($cBanList, "|")
	For $i = 1 To $aBanList[0]
		GUICtrlSetData($cBanList, $aBanList[$i] & "|")
	Next
EndFunc   ;==>_UpdateBanList

Func _InputInfo(ByRef $sIP, ByRef $iPort, ByRef $sPassword)
	Local $iMsg
	
	GUICreate("Quake3 Test", 180, 180)
	
	Local $cServerLabel = GUICtrlCreateLabel("Server IP", 10, 10, 160, 20, BitOR($SS_SUNKEN, $SS_CENTER))
	Local $cServerIP = GUICtrlCreateInput(@IPAddress1, 10, 40, 100, 20)
	Local $cServerPort = GUICtrlCreateInput(27960, 120, 40, 50, 20, $ES_NUMBER)
	
	Local $cPassLabel = GUICtrlCreateLabel("Rcon Password", 10, 70, 160, 20, BitOR($SS_SUNKEN, $SS_CENTER))
	Local $cServerPass = GUICtrlCreateInput("", 10, 100, 160, 20, $ES_PASSWORD)
	Local $cConfirm = GUICtrlCreateButton("Confirm", 10, 140, 70, 30, $BS_DEFPUSHBUTTON)
	Local $cCancel = GUICtrlCreateButton("Cancel", 100, 140, 70, 30)
	
	GUICtrlCreateLabel(":", 110, 40, 10, 20, BitOR($SS_SUNKEN, $SS_CENTER))
	GUICtrlSetFont(-1, -1, 1000)
	GUICtrlSetFont($cServerLabel, 10, 1000)
	GUICtrlSetFont($cPassLabel, 10, 1000)
	GUICtrlSetBkColor($cServerLabel, 0x0)
	GUICtrlSetBkColor($cPassLabel, 0x0)
	GUICtrlSetColor($cServerLabel, 0xFFFFFF)
	GUICtrlSetColor($cPassLabel, 0xFFFFFF)
	GUICtrlSetTip($cServerIP, "server-ip")
	GUICtrlSetTip($cServerPort, "server-port")
	GUICtrlSetTip($cServerPass, "rcon-password" & @CRLF & "(admin only !)")
	GUICtrlSetLimit($cServerIP, 15)
	GUICtrlSetLimit($cServerPort, 5)
	GUICtrlSetState($cConfirm, $GUI_FOCUS)
	GUISetState()
	
	While 1
		$iMsg = GUIGetMsg()
		If $iMsg = $GUI_EVENT_CLOSE Or $iMsg = $cCancel Then Exit
		
		If $iMsg = $cConfirm And GUICtrlRead($cServerIP) <> "" And GUICtrlRead($cServerPort) <> "" Then ExitLoop
	WEnd
	
	$sIP = GUICtrlRead($cServerIP)
	$iPort = GUICtrlRead($cServerPort)
	$sPassword = GUICtrlRead($cServerPass)	
	GUIDelete()	
EndFunc   ;==>_InputInfo