#include <GUIConstants.au3>
#Include <GuiEdit.au3>
#include <INet.au3>

$internalip = @IPAddress1
$externalip = _GetIP()
$port = 8080

$gui = GUICreate('Header Grabber' ,600,400)
$text_internalip = GUICtrlCreateLabel("(You proxy connect to this) Internal IP: " & $internalip, 10, 5)
$text_externalip = GUICtrlCreateLabel("(They proxy connect to this) External IP: " & $externalip, 10, 20)
$edit = GUICtrlCreateEdit('',10,40,580,350)
GUISetState()

TCPStartUp()
$MainSocket = TCPListen($internalip, $port)

While 1
	$msg = GUIGetMsg()
	$ConnectedSocket = TCPAccept($MainSocket)
	If $msg = $GUI_EVENT_CLOSE Then close()
	If $ConnectedSocket >= 0 Then
		$recv = TCPRecv($ConnectedSocket, 2048)
		While $recv <> ''
			GUICtrlSetData($edit, GUICtrlRead($edit) & '<--- START COPY --->' & @CRLF & @CRLF & $recv & @CRLF & '<--- END COPY --->' & @CRLF & @CRLF)
			FileWrite("HGLog.txt", GUICtrlRead($edit))
			_GUICtrlEditScroll ($edit, $SB_PAGEDOWN)
			_GUICtrlEditScroll ($edit, $SB_PAGEDOWN)
			_GUICtrlEditScroll ($edit, $SB_PAGEDOWN)
			TCPSend($ConnectedSocket, '<html>')
			TCPSend($ConnectedSocket, '<head>')
			TCPSend($ConnectedSocket, '<title>Header Grabbed</title>')
			TCPSend($ConnectedSocket, '</head>')
			TCPSend($ConnectedSocket, '<body>')
			TCPSend($ConnectedSocket, '<center><strong><font size="5" color="red">Header information was grabbed</font></strong></center>')
			TCPSend($ConnectedSocket, '<center><strong><font size="5">Thank you for your support!</font></strong></center>')
			TCPSend($ConnectedSocket, '</body>')
			TCPSend($ConnectedSocket, '</html>')
			TCPCloseSocket($ConnectedSocket)
			ExitLoop
		WEnd
	EndIf
WEnd

Func close()
	If $ConnectedSocket >= 0 Then TCPCloseSocket($ConnectedSocket)
	TCPShutDown()
	Exit
EndFunc
	