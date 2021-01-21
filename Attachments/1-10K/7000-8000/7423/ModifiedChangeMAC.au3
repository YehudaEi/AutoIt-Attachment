;includes for getnicid()
#include <GUIConstants.au3>
#include <Constants.au3>
#include <array.au3>

;hwid for nic, must be done while nic is active
$NicId = GetNicId()

;turns off 'Local Area Connection' or the specified connection
NicToggle(0)

;NIC key in registry
$NicKey = "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}\"


$i = 1
While 1
	$returnval = RegRead($NicKey & RegEnumKey($NicKey, $i), "NetCfgInstanceId")
	;tests for the correct subkey based on which subkey contains the correct hwid
	If $returnval = $NicId Then
		;writes the new mac address to registry
		RegWrite($NicKey & RegEnumKey($NicKey, $i), "NetworkAddress", "REG_SZ", NewMAC(RegRead ($NicKey & RegEnumKey($NicKey, $i), "NetworkAddress")))
		ExitLoop
	ElseIf @error = 1 Then
		MsgBox(48, "Error", "Could not find the NIC's reg key")
		ExitLoop
	EndIf
	$i += 1
WEnd

;turns connection back on
NicToggle(1)
sleep(1000)

; Start of Functions


;Gets hwid for nic (nic must be enabled)
Func GetNicId()
	$stdout = Run(@ComSpec & " /c net config rdr", '', @SW_HIDE, 2)
	Global $all
	While 1
		$data = StdoutRead($stdout)
		If @error Then ExitLoop
		If $data Then
			$all &= $data
		Else
			Sleep(10)
		EndIf
	WEnd
	$DataArray = StringSplit($all, @CRLF)
	$id = StringTrimLeft( StringTrimRight($DataArray[13], 15), 13)
	Return $id
EndFunc   ;==>GetNicId

Func NewMAC($CurrentMAC)
	GUICreate ( "ChangeMAC",300, 80, -1, -1)
	GUICtrlCreateLabel ("  The current MAC address is: "&$CurrentMAC, 5, 5, 290,20)
	$NewMAC = GUICtrlCreateInput ("", 5, 25 , 290, 20)
	$SetBtn = GUICtrlCreateButton ("Set",  110, 50, 80)
	GUICtrlSetState($SetBtn,$GUI_FOCUS)
	GUISetState()
	While 1
		$msg = GUIGetMsg()
		Select
		case $msg = $GUI_EVENT_CLOSE
		   Return $CurrentMAC
		case $msg = $SetBtn
		   $MAC=GuiCtrlRead($NewMAC)
		   If $MAC="" Then
		   	return $CurrentMAC
		   Else
		   	return $MAC
		   EndIf
		EndSelect
	Wend
EndFunc   ;==>NewMAC


; turns a network connection on or off
; I used a converted vbs scripts method for doing thisit can be found at
; http://channel9.msdn.com/ShowPost.aspx?PostID=158556
; Or
; http://groups.google.com/group/microsoft.public.scripting.vbscript/browse_frm/thread/9f82ef9e7bb12ff3/2b3fab1141c6c93e#2b3fab1141c6c93e
; the 2nd param is the network connections name
; the third param is dependant on what os you use... the folder is called different things on different versions of windows
;  I have not tried changing the thrid parameter because i run soley xp, and I dont have a clue if changing it will make it work on win2000 and such
Func NicToggle($Toggle, $sConnectionName = "Local Area Connection", $sNetworkFolder = "Network Connections")
	
	$ssfCONTROLS = 3
	$sEnableVerb = "En&able"
	$sDisableVerb = "Disa&ble"
	$shellApp = ObjCreate("shell.application")
	$oControlPanel = $shellApp.Namespace ($ssfCONTROLS)
	$oNetConnections = "nothing"
	
	For $folderitem In $oControlPanel.items
		If $folderitem.name = $sNetworkFolder Then
			$oNetConnections = $folderitem.getfolder
			ExitLoop
		EndIf
	Next
	If $oNetConnections = "nothing" Then
		MsgBox(48, "Error", "Couldn't find " & $sNetworkFolder & " folder")
		Exit
	EndIf
	
	$oLanConnection = "nothing"
	For $folderitem In $oNetConnections.items
		If StringLower($folderitem.name) = StringLower($sConnectionName) Then
			$oLanConnection = $folderitem
			ExitLoop
		EndIf
	Next
	If $oLanConnection = "nothing" Then
		MsgBox(48, "Error", "Couldn't find '" & $sConnectionName & "' item")
		Exit
	EndIf
	
	$bEnabled = True
	$oEnableVerb = "nothing"
	$oDisableVerb = "nothing"
	$s = "Verbs: " & @CRLF
	For $verb In $oLanConnection.verbs
		$s = $s & @CRLF & $verb.name
		
		;enables
		If $verb.name = $sEnableVerb And $Toggle = 1 Then
			$oEnableVerb = $verb
			$oEnableVerb.DoIt
			ExitLoop
			
			;disables
		ElseIf $verb.name = $sDisableVerb And $Toggle = 0 Then
			$oDisableVerb = $verb
			$oDisableVerb.DoIt
			ExitLoop
		Else
			MsgBox(48, "Error", "Tried to disable when already disabled" & @CRLF & "or enable when already enabled")
			Exit
		EndIf
	Next
	Sleep(1000)
EndFunc   ;==>NicToggle