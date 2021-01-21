#include <GuiConstants.au3>
$ipParce = StringLeft(@IPAddress1, 6)
$homeIPparce = "10.70." ;parced to 6 digits, including decimals
$url = "domain.com"
$vncPath = "C:\Program Files\RealVNC\VNC4\vncviewer.exe"
;set var to make compiler stop complaining....
$port = ""
$server = ""

;Setup GUI
GUICreate("VNC Connect", 152, 90, (@DesktopWidth - 152) / 2, (@DesktopHeight - 110) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$Button_Tower = GUICtrlCreateButton("Tower", 10, 10, 130, 30)
$Button_Linux = GUICtrlCreateButton("Server2", 10, 50, 130, 30)

Func _srvConnect()
	;Determin home or outside network
	If $ipParce = $homeIPparce Then
		$run = $vncPath & " " & $server
		Run($run)
		Exit
	Else
		$run = $vncPath & " " & $url & ':' & $port
		Run($run)
		Exit
	EndIf
	Exit
EndFunc   ;==>_srvConnect

;Start GUI
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Button_Tower
			;set port and server infor for Button_1
			$port = "4444"
			$server = "10.70.1.11"
			;Connect to server
			_srvConnect($port & $server)
		Case $msg = $Button_Linux
			;set port and server infor for Button_2
			$port = "5555"
			$server = "10.70.1.12"
			;Connect to server
			_srvConnect($port & $server)
	EndSelect
WEnd
Exit