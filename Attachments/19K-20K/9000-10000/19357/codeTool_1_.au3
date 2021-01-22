#include <GUIConstants.au3>
#include <INet.au3>

Opt("GUIOnEventMode", 1)
Dim $SaveFile = @WorkingDir & "\Save.ini"
Dim $HostFile = @WorkingDir & "\Host.ini"
Global $Cancel = False


;<			|					|
;<			|	P A R E N T		|
;<			|					|

$GUIParent = GUICreate("CodeTool", 505, 278, 329, 289)
GUISetOnEvent($GUI_EVENT_CLOSE, "GUIParentClose")
$Send = GUICtrlCreateButton("Send", 360, 224, 75, 25, 0)
GUICtrlSetOnEvent(-1, "SendClick")
$Input = GUICtrlCreateInput("", 0, 224, 345, 21)
$List1 = GUICtrlCreateList("", 104, 0, 249, 214)
$ServersCombo = GUICtrlCreateCombo("", 360, 24, 121, 25)
GUICtrlSetData(-1, INISectionNamesToString($SaveFile))
$label1 = GUICtrlCreateLabel("Server:", 368, 8, 38, 15)
$label1 = GUICtrlCreateLabel("Users Connected:", 360, 72, 89, 17)
$List2 = GUICtrlCreateList("", 0, 0, 105, 214)
$UsersConnected = GUICtrlCreateList("", 360, 88, 137, 123)
$JoinServer = GUICtrlCreateButton("Join", 360, 48, 35, 17, 0)
GUICtrlSetOnEvent(-1, "JoinServerClick")
$Button1 = GUICtrlCreateButton("Remove", 400, 48, 51, 17, 0)
GUICtrlSetOnEvent(-1, "RemoveServerClick")
$New = GUICtrlCreateButton("New...", 456, 48, 43, 17, 0)
GUICtrlSetOnEvent(-1, "JoinChatMenuClick")
$MenuItem1 = GUICtrlCreateMenu("&Chat")
$MenuItem2 = GUICtrlCreateMenuItem("Host Chat", $MenuItem1)
GUICtrlSetOnEvent(-1, "HostChatMenuClick")
$MenuItem3 = GUICtrlCreateMenuItem("Join Chat", $MenuItem1)
GUICtrlSetOnEvent(-1, "JoinChatMenuClick")
$MenuItem5 = GUICtrlCreateMenuItem("Exit", $MenuItem1)
GUISetOnEvent(-1, "GUIParentClose")
$MenuItem4 = GUICtrlCreateMenu("&Options")
$MenuItem6 = GUICtrlCreateMenuItem("Edit Preferences", $MenuItem4)
GUISetState(@SW_SHOW)

#region Parent GUI Functions
Func GUIParentClose()
	;Prompt to save log or something
	Exit
EndFunc   ;==>GUIParentClose

Func HostChatMenuClick()
	GUISetState(@SW_SHOW, $HostChild)
	GUICtrlSetData($HostIPInput, _GetIP());Refresh
EndFunc   ;==>HostChatMenuClick

Func JoinServerClick() ;Parent
	If GUICtrlRead($ServersCombo) = "" Then
		MsgBox(0, "Error", "No server selected.")
		Return
	EndIf
	
	Local $IP = IniRead($SaveFile, GUICtrlRead($ServersCombo), "IP", "0")
	Local $Port = IniRead($SaveFile, GUICtrlRead($ServersCombo), "Port", "0")
	GUISetState(@SW_SHOW, $JoiningChild)
	Join($IP, $Port)

EndFunc   ;==>JoinServerClick

Func RemoveServerClick()
	If MsgBox(4, "Remove", 'Are you sure you want to delete the server "' & GUICtrlRead($ServersCombo) & '"?') = 6 Then
		IniDelete($SaveFile, GUICtrlRead($ServersCombo))
	EndIf
	GUICtrlSetData($ServersCombo, INISectionNamesToString($SaveFile))
EndFunc   ;==>RemoveServerClick

Func SendClick()
	
EndFunc   ;==>SendClick
#endregion

;<			|							|
;<			|	H O S T   C H I L D		|
;<			|							|
$HostChild = GUICreate("Host", 204, 179, 384, 364, -1, -1, $GUIParent)
GUISetOnEvent($GUI_EVENT_CLOSE, "HostChildClose")
$HostPortInput = GUICtrlCreateInput("", 80, 32, 41, 21)
GUICtrlSetData(-1, IniRead($HostFile, "My Server", "Port", "3826"))
GUICtrlSetLimit(-1, 5)
GUICtrlCreateLabel("Port:", 8, 32, 26, 17)
$HostButton = GUICtrlCreateButton("Host", 104, 144, 51, 25, 0)
GUICtrlSetOnEvent(-1, "HostButtonClick")
$HostIPInput = GUICtrlCreateInput("", 80, 8, 97, 21, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlCreateLabel("Host IP:", 8, 8, 42, 17)
$HostMaxUsersInput = GUICtrlCreateInput("", 8, 144, 41, 21)
GUICtrlSetData(-1, IniRead($HostFile, "My Server", "Max Users", "2"))
GUICtrlCreateLabel("Max Users", 8, 120, 54, 17)
$HostPasswordInput = GUICtrlCreateInput("", 80, 56, 97, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetData(-1, IniRead($HostFile, "My Server", "Password", ""))
GUICtrlSetLimit(-1, 16)
GUICtrlCreateLabel("Password:", 8, 56, 53, 17)
GUICtrlCreateLabel("Server Name:", 8, 80, 69, 17)
$HostServerNameInput = GUICtrlCreateInput("", 80, 80, 97, 21)
GUICtrlSetData(-1, IniRead($HostFile, "My Server", "Server Name", GUICtrlRead($HostIPInput)))
GUICtrlSetLimit(-1, 30)

#region Host Child GUI Functions
Func HostButtonClick()
	Global $Port = GUICtrlRead($HostPortInput)
	Global $Password = GUICtrlRead($HostPasswordInput)
	Global $MaxUsers = GUICtrlRead($HostMaxUsersInput)
	Global $ServerName = GUICtrlRead($HostServerNameInput)
	IniWrite($HostFile, "My Server", "Server Name", $ServerName)
	IniWrite($HostFile, "My Server", "Password", $Password)
	IniWrite($HostFile, "My Server", "Port", $Port)
	IniWrite($HostFile, "My Server", "Max Users", $MaxUsers)
	GUISetState(@SW_HIDE, $HostChild)
EndFunc   ;==>HostButtonClick

Func HostChildClose()
	GUISetState(@SW_HIDE, $HostChild)
EndFunc   ;==>HostChildClose
#endregion


;<			|							|
;<			|	J O I N   C H I L D		|
;<			|							|
$JoinChild = GUICreate("Join", 236, 146, 211, 147)
GUISetOnEvent($GUI_EVENT_CLOSE, "JoinChildClose")
GUICtrlCreateLabel("Hostname or IP:", 0, 8, 80, 17)
GUICtrlCreateLabel("Port:", 0, 32, 26, 17)
GUICtrlCreateLabel("Name for Server:", 0, 56, 80, 17)
$JoinJoinButton = GUICtrlCreateButton("Join", 24, 102, 59, 25, 0)
GUICtrlSetOnEvent(-1, "JoinChildJoin")
$JoinCancelButton = GUICtrlCreateButton("Cancel", 168, 102, 59, 25, 0)
GUICtrlSetOnEvent(-1, "JoinChildClose")
$JoinCancelButton = GUICtrlCreateButton("Add", 92, 102, 59, 25, 0)
GUICtrlSetOnEvent(-1, "JoinChildAdd")
$JoinIPInput = GUICtrlCreateInput("", 80, 8, 137, 21)
GUICtrlSetLimit(-1, 255)
$JoinPortInput = GUICtrlCreateInput("", 80, 32, 41, 21)
GUICtrlSetLimit($JoinPortInput, 5)
$JoinServerNameInput = GUICtrlCreateInput("", 80, 56, 137, 21)
GUICtrlSetLimit(-1, 32)
#region Join Child GUI Functions
Func JoinChatMenuClick()
	GUISetState(@SW_SHOW, $JoinChild)
EndFunc   ;==>JoinChatMenuClick

Func JoinChildAdd() ;Join child
	Local $IP = GUICtrlRead($JoinIPInput)
	Local $Port = GUICtrlRead($JoinPortInput)
	Local $ServerName = GUICtrlRead($JoinServerNameInput)
	IniWrite($SaveFile, $ServerName, "IP", $IP)
	IniWrite($SaveFile, $ServerName, "Port", $Port)
	GUICtrlSetData($JoinIPInput, "")
	GUICtrlSetData($JoinPortInput, "")
	GUICtrlSetData($JoinServerNameInput, "")
	GUISetState(@SW_HIDE, $JoinChild)
	GUICtrlSetData($ServersCombo, INISectionNamesToString($SaveFile))
EndFunc   ;==>JoinChildAdd

Func JoinChildClose()
	GUISetState(@SW_HIDE, $JoinChild)
EndFunc   ;==>JoinChildClose

Func JoinChildJoin() ;Join child
	Local $IP = GUICtrlRead($JoinIPInput)
	Local $Port = GUICtrlRead($JoinPortInput)
	Local $ServerName = GUICtrlRead($JoinServerNameInput)
	IniWrite($SaveFile, $ServerName, "IP", $IP)
	IniWrite($SaveFile, $ServerName, "Port", $Port)
	GUISetState(@SW_SHOW, $JoiningChild)
	GUICtrlSetData($ServersCombo, "") ;clear
	GUICtrlSetData($ServersCombo, INISectionNamesToString($SaveFile))

	Join($IP, $Port)
	
	GUICtrlSetData($JoinIPInput, "")
	GUICtrlSetData($JoinPortInput, "")
	GUICtrlSetData($JoinServerNameInput, "")
EndFunc   ;==>JoinChildJoin
#endregion

;<			|								|
;<			|	J O I N I N G  C H I L D	|
;<			|								|
$JoiningChild = GUICreate("Dialog", 316, 129, 347, 263, -1, -1, $GUIParent)
GUISetOnEvent($GUI_EVENT_CLOSE, "JoiningCancelButtonClick")
GUICtrlCreateGroup("", 8, 17, 297, 73)
$JoiningHostLabel = GUICtrlCreateLabel("Host:", 16, 32, 281, 17)
$JoiningPortLabel = GUICtrlCreateLabel("Port:", 16, 48, 282, 17)
$JoiningStatusLabel = GUICtrlCreateLabel("Status:", 16, 64, 285, 17, $SS_CENTER)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$JoiningCancel = GUICtrlCreateButton("&Cancel", 114, 99, 75, 25, 0)
GUICtrlSetOnEvent(-1, "JoiningCancelButtonClick")
GUICtrlCreateLabel("Joining Server...", 112, 0, 80, 17)
#region Joining Child GUI Functions
Func JoiningCancelButtonClick()
	GUISetState(@SW_HIDE, $JoiningChild)
	$cancel = True
	;hault TCP operations
EndFunc   ;==>JoiningCancelButtonClick
#endregion

While 1
	Sleep(100)
WEnd















Func INISectionNamesToString($file, $Deliminator = "|") ;for GUICtrlSetData on $ServersCombo
	Local $Sections = IniReadSectionNames($file)
	Local $ServerList = ""
	If (UBound($Sections) > 1) And (Not @error) Then
		$ServerList = $Sections[1]
		For $i = 2 To $Sections[0] ;[0] returns size, will loop for every section
			$ServerList &= $Deliminator
			$ServerList &= $Sections[$i]
		Next
	EndIf
	Return $ServerList	
EndFunc   ;==>INISectionNamesToString


Func _StringIPTypeValid($sIP)
;Created by SmOke_N <http://www.autoitscript.com/forum/index.php?showtopic=39932&hl=_StringIPTypeValid>
	If StringRegExp($sIP, "(?:(\d|[1-9]\d|1\d{2}|2[0-4]\d|25[0-5])(\.)){3}(?:(25[0-5]$|2[0-4]\d$|1\d{2}$|[1-9]\d$|\d$))") Then Return 1
	Return SetError(1, 0, 0)
EndFunc   ;==>_StringIPTypeValid

Func Status($var)
	Switch $Var
	Case 0 
		Return "Pinging Host (not going to connect to anything, incomplete)"
	Case 1 
		Return "Host Address cannot be found. Host is Offline."
	Case 2 
		Return "Host Address cannot be found. Host is unreachable."
	Case 3
		Return "Host Address cannot be found. Bad destination."
	Case 4 
		Return "Host Address cannot be found. Unknown Error."
	Case 5 
		Return "Attempting to connect again in 5 seconds."
	EndSwitch		
EndFunc

Func SetStatus($var)
	GUICtrlSetData($JoiningStatusLabel, "Status: " & Status($var))
EndFunc

Func Join($IP, $Port)
	GUICtrlSetData($JoiningHostLabel, "Host: " & $IP)
	GUICtrlSetData($JoiningPortLabel, "Port: " & $Port)
	SetStatus(0)

	If Not ($Port > 0 And $Port <= 65535) Then
		MsgBox(0, "Error", "Port entered must be (includive) between 1 and 65535.");assert
		GUISetState(@SW_HIDE, $JoiningChild)
		Return
	EndIf
	;could cause problems when using hostname
;~ 	If Not _StringIPTypeValid($IP) Then;assert
;~ 		MsgBox(0,"Error","IP Address entered is invalid.")
;~ 		Return
;~ 	EndIf
	
	If Not Ping($IP) Then
		Switch @error ;some addresses cannot be pinged but may be the host, must consider later
		Case 1
				SetStatus(1)
			Case 2
				SetStatus(2)
			Case 3
				SetStatus(3)
			Case 4
				SetStatus(4)
		EndSwitch
		SetStatus(5)
		Sleep(5000)
		If $cancel = True Then Return
		Join($IP, $Port)
	EndIf	
	
				
	;do some TCPstuff :)
	;GUICtrlSetData(
	;GUISetState(@SW_HIDE,$JoiningChild)
	
	GUICtrlSetData($JoiningHostLabel, "Host:") ;reset
	GUICtrlSetData($JoiningPortLabel, "Port:")
EndFunc   ;==>Join