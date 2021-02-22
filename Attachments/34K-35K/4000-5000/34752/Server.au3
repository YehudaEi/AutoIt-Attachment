#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

Global $hGUI, $TCPAccept = 10, $TCPListen, $TCPPrevious = 255, $TCPRecv
TCPStartup()
$port = 5000
$TCPListen = TCPListen(@IPAddress1, $port)

#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Server", 148, @DesktopHeight, 0, 0)
$Label1 = GUICtrlCreateLabel("Server IP: ", 8, 8, 54, 17)
$Label2 = GUICtrlCreateLabel("Connected Port:", 8, 40, 81, 17)
$Label3 = GUICtrlCreateLabel("Recieved Data: ", 8, 72, 82, 17)
$Label4 = GUICtrlCreateLabel("Label4", 8, 24, 132, 17)
$Label5 = GUICtrlCreateLabel("Label5", 8, 56, 132, 17)
$Label6 = GUICtrlCreateLabel("Waiting For Connections...", 8, 88, 132, @DesktopHeight)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
GUICtrlSetData($Label4, @IPAddress1)
GUICtrlSetData($Label5, $port)

Do
    $TCPAccept = TCPAccept($TCPListen)
Until $TCPAccept <> -1

GUICtrlSetData($Label6, "Connection Open")

While 1
    $TCPRecv = TCPRecv($TCPAccept, 128)
    If $TCPRecv <> "" And $TCPRecv <> $TCPPrevious Then
        $TCPPrevious = $TCPRecv
        ConsoleWrite("What is recieved >> " & $TCPPrevious & @CRLF)
		FileWrite("MatLabRecived.txt", $TCPPrevious)
        If $TCPPrevious > $TCPPrevious +1 Then
			Do
				$TCPPrevious = $TCPPrevious + 1
			Until $TCPPrevious = $TCPRecv
		EndIf
		If $TCPPrevious < $TCPPrevious -1 Then
			Do
				$TCPPrevious = $TCPPrevious - 1
			Until $TCPPrevious = $TCPRecv
		EndIf
		$array=stringsplit($TCPRecv,@crlf)
		$freq1=$array[5]
		$findchannel2=_arraysearch($array,"channel2")
		$freq2=$array[$findchannel2+4]
		GUICtrlSetData($Label6, Number($freq1) & @CRLF & Number($freq2))
    EndIf
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
	EndSwitch
WEnd

;bciguy2112@gmail.com