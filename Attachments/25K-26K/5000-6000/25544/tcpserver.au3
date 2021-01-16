#CS ---------------------
	credits:
	
	Used as a server to send commands to remote systems.
	Connect clients to the server. this is set to be an include
	
	Yeik 4-08-2009
#ce ---------
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <TCP.au3>
#include <array.au3>
#include <String.au3>
#include-once

Global $sockclient
Global $sclientarr[1][2] = [['this computer', '0.0.0.0']]
Global $msglog = ""
Global $edit
Global $edit1
Global $GOOEY
Global $cchklst[1]
Global $cmbo
Global $TCPREC_Wait[2] = [0, ""]

ToolTip("SERVER: Creating server...", 10, 30)
Func _servercreate($sPort = 33891)
	Global $hServer
	$hServer = _TCP_Server_Create($sPort)
	_TCP_RegisterEvent($hServer, $TCP_NEWCLIENT, "NewClient")
	_TCP_RegisterEvent($hServer, $TCP_DISCONNECT, "Disconnect")
	Return $hServer
EndFunc   ;==>_servercreate

Func NewClient($hsocket, $iError)
	Global $sockclient = $hsocket
	Local $clntarr[1][2] = [[$hsocket, SocketToIP($hsocket)]]
	Local $i = UBound($sclientarr)
	ToolTip("SERVER: New client connected." & @CRLF & "Sending connect statement.", 10, 30)
	;_ArrayConcatenate($sclientarr, $clntarr)
	If $sclientarr[0][0] = 'this computer' Then
		$sclientarr[0][0] = $hsocket
		$sclientarr[0][1] = SocketToIP($hsocket)
	Else
		ReDim $sclientarr[$i + 1][2]
		$sclientarr[$i][0] = $hsocket
		$sclientarr[$i][1] = SocketToIP($hsocket)
	EndIf
	
	_TCP_Send($hsocket, "S!;/autoitcall;_sendmsg|New Client Connected!")
	_TCP_RegisterEvent($hsocket, $TCP_RECEIVE, "Received"); Function "Received" will get called when something is received
EndFunc   ;==>NewClient

Func Disconnect($hsocket, $iError)
	If UBound($sclientarr) < 2 Then
		$sclientarr[0][0] = 'this computer'
		$sclientarr[0][1] = '0.0.0.0'
	Else
	For $i = UBound($sclientarr) - 1 To 0 Step -1
		If $sclientarr[$i][0] = $hsocket Then
			_ArrayDelete($sclientarr, $i)
		EndIf
	Next
	EndIf
	ToolTip("SERVER: Client disconnected.", 10, 30)
EndFunc   ;==>Disconnect

Func Received($hsocket, $sReceived, $iError)
	Local $hsocketip
	$hsocketip = SocketToIP($hsocket)
	$msglog = $hsocketip & '> ' & $sReceived & @CRLF & $msglog
	If IsDeclared('edit') Then
		GUICtrlSetData($edit, $msglog)
	EndIf
	If $TCPREC_Wait[0] > 0 Then
		$TCPREC_Wait[0] = $TCPREC_Wait[0] +1
		If $sReceived = $TCPREC_Wait[1] Or $TCPREC_Wait[0] > 5 Then
			$TCPREC_Wait[0] = 0
			$TCPREC_Wait[0] = ""
		EndIf
	EndIf
	ToolTip("Server: We received this: " & $sReceived, 10, 10)
EndFunc   ;==>Received

Func _waitreceive($str)
	$TCPREC_Wait[0] = 1
	$TCPREC_Wait[1] = $str
	While $TCPREC_Wait[0]
	Sleep(5000)
	WEnd
EndFunc

Func _waitreceivemsg($str, $soc = $sockclient)
	_Sendmsg($str, $soc)
	$TCPREC_Wait[0] = 1
	$TCPREC_Wait[1] = 'Finished:> ' & $str
	While $TCPREC_Wait[0]
	Sleep(5000)
	WEnd
EndFunc

Func _listclient()
	_ArrayDisplay($sclientarr, "Client list & ip")
EndFunc   ;==>_listclient

Func ExitScript()
	$clientarr = _TCP_Server_ClientList()
	For $clnt In $clientarr
	_sendmsg("/autoitcall;_exit", $clnt)
	Next
	Exit
EndFunc   ;==>ExitScript

Func _Sendmsggui()
	Local $szData
	$szData = InputBox("Data for Client", @LF & @LF & "Enter data to transmit to the Client:", "", "", "", "", 200, 500)
	_SendMsg($szData)
EndFunc   ;==>_Sendmsggui

Func _Sendmsg($str, $csocket = $sockclient)
	Sleep(1000)
	If $csocket = $sockclient Then
	Else
		Local $clientarr = _TCP_Server_ClientList()
		_ArrayDelete($clientarr, 0)
		If IsArray($clientarr) Then
		For $clnt In $clientarr
			If (TCPNameToIP($csocket) = SocketToIP($clnt)) Then
				$csocket = $clnt
			EndIf
		Next
		EndIf
		;EndIf
	EndIf
	TCPSend($csocket, $str)
EndFunc   ;==>_Sendmsg

Func _Guicreatechk()
	Local $hpos = 216
	Local $vpos = 8
	Local $chkbox

	For $i = UBound($sclientarr) - 1 To 0 Step -1
		$chkbox = GUICtrlCreateCheckbox($sclientarr[$i][1], $vpos, $hpos, 97, 17)
		_ArrayAdd($cchklst, $chkbox)
		$hpos = $hpos + 17
		If $hpos > 400 Then
			$hpos = 216
			$vpos = $vpos + 98
		EndIf
	Next

EndFunc   ;==>_Guicreatechk

Func _CreateGui()
	Opt("GUIResizeMode", 1)
	Opt("GUIOnEventMode", 1)
	Global $GOOEY
	Global $edit
	Global $edit1
	If $GOOEY Then
		GUIDelete($GOOEY)
	EndIf
	$GOOEY = GUICreate("My Server (IP: " & @IPAddress1 & ")", 699, 470, 193, 126)
	GUISetOnEvent($GUI_EVENT_CLOSE, "_guiclose")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Gooeyminimize")
	$edit = GUICtrlCreateEdit($msglog, 5, 8, 602, 89, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL))
	$edit1 = GUICtrlCreateEdit("", 5, 108, 602, 89)
	$Button1 = GUICtrlCreateButton("Send", 8, 442, 75, 25, 0)
	GUICtrlSetOnEvent(-1, "_Ssend")
	$cmbo = GUICtrlCreateCombo("Run", 104, 442) ; create first item
	GUICtrlSetData(-1, "Run wait|Execute Line|Execute Script|CMD|Call Func|Custom")
	_Guicreatechk()
	GUISetState(@SW_SHOW)
EndFunc   ;==>_CreateGui

Func _Ssend()
	Local $msg1
	$msg1 = GUICtrlRead($edit1)
	Switch GUICtrlRead($cmbo)
		Case 'Run wait'
			If Not (StringLeft($msg1, 1) = '/')	Then
				$msg1= '/autoitrunwait;'& $msg1
			EndIf
		Case 'Run'
			If Not (StringLeft($msg1, 1) = '/')	Then
				$msg1= '/autoitrun;'& $msg1
			EndIf
		Case 'Execute Line'
			If Not (StringLeft($msg1, 1) = '/')	Then
				$msg1= '/autoiteline;'& $msg1
			EndIf
		Case 'Execute Script'
			If Not (StringLeft($msg1, 1) = '/')	Then
				$msg1= '/autoitescript;'& $msg1
			EndIf
		Case 'CMD'
			If Not (StringLeft($msg1, 1) = '/')	Then
				$msg1= '/autoitcmd;'& $msg1
			EndIf
		Case 'Call Func'
			If Not (StringLeft($msg1, 1) = '/') Then
				$msg1= '/autoitcall;'& $msg1
			EndIf
		Case 'Custom'
			;You can add more here, I use it for custom
		case Else
			;add others here as well
	EndSwitch		
		
	For $box In $cchklst
		If GUICtrlRead($box) = $GUI_CHECKED Then
			_sendmsg($msg1, GUICtrlRead($box, 1))
		EndIf
	Next
EndFunc   ;==>_Ssend

Func _guiclose()
	If IsDeclared("gooey") Then GUIDelete($GOOEY)
EndFunc   ;==>_guiclose

Func SocketToIP($SHOCKET)
	Local $sockaddr, $aRet

	$sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	$aRet = DllCall("Ws2_32.dll", "int", "getpeername", "int", $SHOCKET, _
			"ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall("Ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf

	$sockaddr = 0

	Return $aRet
EndFunc   ;==>SocketToIP

Func Gooeyminimize()
	GUIDelete($GOOEY)
EndFunc 