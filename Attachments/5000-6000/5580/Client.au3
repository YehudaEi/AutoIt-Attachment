#include <GUIConstants.au3>

$g_IP = InputBox("EQC Client","Enter The Server IP Address",@IPADDRESS1,"",300,200)
$g_port = 33891
HotKeySet("{F1}", "test1")
HotKeySet("{F2}", "test2")
HotKeySet("{F3}", "test3")
HotKeySet("{F4}", "test4")
HotKeySet("{F5}", "clearwindow")
TCPStartUp()

$socket = TCPConnect( $g_IP, $g_port )
;If $socket = -1 Then Exit
If $socket = -1 Then
MsgBox(4096, "ERROR", "Connection was Rejected.", 0)
EndIf
$GOOEY = GUICreate("EQC Client - Status: Online",350,220)
$edit = GUICtrlCreateEdit("",10,40,330,150,$WS_DISABLED)
$input = GUICtrlCreateInput("",10,10,250,20)
$butt = GUICtrlCreateButton("Send",260,10,80,20,$BS_DEFPUSHBUTTON)

$filemenu = GuiCtrlCreateMenu ("File")
$commandsmenu = GuiCtrlCreateMenu ("Commands")
$helpmenu = GuiCtrlCreateMenu ("?")
$aboutitem = GuiCtrlCreateMenuitem ("Creator",$helpmenu)
$exitnow = GuiCtrlCreateMenuitem ("Exit",$filemenu)
$test1 = GuiCtrlCreateMenuitem ("Test1",$commandsmenu)
$test2 = GuiCtrlCreateMenuitem ("Test2",$commandsmenu)
$test3 = GuiCtrlCreateMenuitem ("Test3",$commandsmenu)
$test4 = GuiCtrlCreateMenuitem ("Test4",$commandsmenu)
$clearwindow = GuiCtrlCreateMenuitem ("Clear Console",$commandsmenu)
GUISetState()
While 1
   $msg = GUIGetMsg()
   If $msg = $GUI_EVENT_CLOSE Then ExitLoop
		If $msg = $aboutitem Then
			Msgbox(0,"EQC Client","Jabberwock")
				EndIf
		If $msg = $exitnow Then
			ExitLoop
				EndIf
		If $msg = $test1 Then
			TCPSend( $socket, "~~test1" )
				EndIf
		If $msg = $test2 Then
			TCPSend( $socket, "~~test2" )
				EndIf
		If $msg = $test3 Then
			TCPSend( $socket, "~~test3" )
				EndIf
		If $msg = $test4 Then
			TCPSend( $socket, "~~test4" )
				EndIf
		If $msg = $clearwindow Then
			GUICtrlSetData($edit,"")
				EndIf
   If $msg = $butt Then
      $ret = TCPSend($socket, GUICtrlRead($input))
      If @ERROR Then ExitLoop
      If $ret > 0 Then GUICtrlSetData($edit, GUICtrlRead($edit) & GUICtrlRead($input) & @CRLF)
      GUICtrlSetData($input,"")
   EndIf

   $recv = TCPRecv($socket, 512 )
    $err = @error   

   If $recv = "~~rejected" Then
      GUICtrlSetData($edit, GUICtrlRead($edit) & "~~Connection Rejected" & @CRLF)
      WinSetTitle($GOOEY,"","Connection Rejected")
      MsgBox(4096, "@ERROR", "Connection was Rejected.", 0)
      Sleep(2000)
      TCPSend( $socket, "~~whatever")
      ExitLoop
   ElseIf $recv = "~~bye" Then
      GUICtrlSetData($edit, GUICtrlRead($edit) & "~~Connection Lost" & @CRLF)
      WinSetTitle($GOOEY,"","Connection Lost")
      MsgBox(4096, "@ERROR", "Connection was lost.", 0)
      Sleep(2000)
      ExitLoop
   EndIf

   If $err <> 0 Then ExitLoop
   If $err=0 AND $recv <> "" Then GUICtrlSetData($edit, GUICtrlRead($edit) & ">" & $recv & @CRLF)
WEnd

Func OnAutoItExit()
   TCPSend( $socket, "~~bye" )
   TCPCloseSocket( $socket )
   TCPShutDown()
EndFunc

Func test1()
TCPSend( $socket, "~~test1" )
EndFunc

Func test2()
TCPSend( $socket, "~~test2" )
EndFunc

Func test3()
TCPSend( $socket, "~~test3" )
EndFunc

Func test4()
TCPSend( $socket, "~~test4" )
EndFunc

Func clearwindow()
GUICtrlSetData($edit,"")
EndFunc