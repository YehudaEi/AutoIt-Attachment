#include <GUIConstants.au3>
Dim $recv

TCPStartup()

$connectIP = InputBox("Connect:", "                                          ")

$socket = TCPConnect($connectIP, 33000)

If $socket >= 0 Then msgbox(0, "Success", "Connection Established!")
If $socket = -1 Then 
	msgbox(0, "Failed", "Connection Failed")
	Exit
EndIf

Call("UserName")

GUICreate("Client Beta", 400, 450)
$SendButton = GUICtrlCreateButton("Send", 350, 405)
$InputBox = GUICtrlCreateInput("", 10, 405, 300, 20)
$EditWindow = GUICtrlCreateEdit("", 5, 5, 395, 395, $ES_AUTOVSCROLL+$WS_VSCROLL+$ES_READONLY)
GUISetState(@SW_SHOW)

While 1
  $msg = GUIGetMsg()

  Select
  Case $msg = $SendButton
	    $input = GUICtrlRead($InputBox)
		$SendResult = TCPSend($socket, $input)

    Case $msg = $GUI_EVENT_CLOSE
      ExitLoop
  EndSelect
  $recv = TCPRecv($socket, 512)
	If $recv <> "" And StringLeft($recv, 2) <> "@*" Then Call("Process")
	If StringLeft($recv, 2) = "@*" Then Call("ServerComm")
WEnd 

Func UserName()
	$username = InputBox("Username:", "Select the username you would like to use:")
	TCPSend($socket, "@*USERNAME*@" & $username)
	GUISetState(@SW_SHOW)
EndFunc

Func Process()
	$EditWindowData = GUICtrlRead($EditWindow)
	GUICtrlSetData($EditWindow, $EditWindowData & @CRLF & $recv) 
EndFunc

Func ServerComm()
	If $recv = "@*INUSE*@" Then 
		MsgBox(0, "In Use", "The username you selected is currently in use.  Please choose a different one")
		GUISetState(@SW_HIDE)
		Call("UserName")
	EndIf
EndFunc
