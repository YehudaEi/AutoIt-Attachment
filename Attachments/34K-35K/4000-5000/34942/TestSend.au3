#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

TCPStartup()
$TCPConnect = TCPConnect(@IPAddress1, 5000)

$Form1 = GUICreate("TestSend", 105, 37, 192, 114)
$Button1 = GUICtrlCreateButton("Send", 8, 8, 83, 17)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			;TCPSend($TCPConnect,$read)
			;$rand1 = Random(0,100)
			;$rand2 = Random(0,100)
			;$rand3 = Random(0,100)
			;TCPSend($TCPConnect, "<Start>"&String($rand1)&","&String($rand2)&","&String($rand3)&"<End>")
			$val1 = 0
			$val2 = 0
			$val3 = 0
			Do
				$data = "<Start>"&$val1&","&$val2&","&$val3&"<End>"
				TCPSend($TCPConnect, $data)
				$val1 += 1
				$val2 += 1
				$val3 += 1
				Sleep(50)
			Until $val1 = 101
	EndSwitch
WEnd
