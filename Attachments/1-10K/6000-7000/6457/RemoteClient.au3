; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.99 beta
; Author:         ChrisL
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here



#include <File.au3>
#include <array.au3>
opt("TrayMenuMode", 1)

Global $windowTitle
$windowTitle = IniReadSection("WinClient.ini", "Windows")
$Servers = IniRead("WinClient.ini", "General", "server", "Labserver|")
$ServerList = StringSplit($Servers, "|")
$Port = Int(IniRead("WinClient.ini", "General", "portNo", "8000"))
$UseIP = IniRead("winClient.ini", "General", "UseIP", "0")
$IP = IniRead("winClient.ini", "General", "IPAddress", "")
Global $MainSocket
$Exititem = TrayCreateItem("Exit")

While 1
	$tray = TrayGetMsg()
	Select
		Case $tray = 0
			
			
			For $i = 1 To UBound($windowTitle) - 1 ;go through each window title|text of the ini file
				$Split = StringSplit($windowTitle[$i][1], "|");split the title and the screen text to search
				
				If WinExists($Split[1], $Split[2]) Then ;see if win exists
					Sleep(500)
					$Textread = WinGetText($Split[1], $Split[2]);Read text of window message
					;for each server in list Use sendData() add var for server names
					
					For $i = 1 To UBound($ServerList) - 1
						
						SendData($Textread, $ServerList[$i]);Send the read text
					Next
					WinWaitClose($Split[1], $Split[2]);wait for the "Error" window to close
					;for each server in list Use sendData() add var for server names
					For $i = 1 To UBound($ServerList) - 1
						TCPSend($MainSocket, "~bye");Send ~bye to terminate the Server socket
						TCPCloseSocket($MainSocket);Close the TCP socket
						TCPShutdown();Shutdown TCP
					Next
				EndIf
				
				Sleep(100); prevent maxing out the CPU
				
			Next ;End of window search
			
			Sleep(500)
		Case $tray = $Exititem
			ExitLoop
	EndSelect
WEnd

Func SendData($Data, $Server)
	TCPStartup()
	$MainSocket = TCPConnect(TCPNameToIP($Server), $Port)
	If $MainSocket = -1 Then ;send message success first attempt
		
		;try 10 times to get a connection if not succesful connection
		For $i = 1 To 10
			$MainSocket = TCPConnect(TCPNameToIP($Server), $Port)
			If $MainSocket <> - 1 Then ExitLoop ;exit for loop
		Next
		If $i > 10 Then ;if after 10 attempts no connection then tray tip
			TrayTip("Error", "Could not broadcast message to " & $Server, 5, 3)
		Else
			;if connection success during the 10 attempts then send message
			If $UseIP = 1 Then
				TCPSend($MainSocket, $IP & Chr(01) & "Message on " & @computername & Chr(01) & $Data)
			Else
				TCPSend($MainSocket, @computername & Chr(01) & "Message on " & @computername & Chr(01) & $Data)
			EndIf;end use ip if from retry loop
		EndIf;end the 10 attempt if
		
	Else ;if socket success on first attempt send message
		
		If $UseIP = 1 Then
			TCPSend($MainSocket, $IP & Chr(01) & "Message on " & @computername & Chr(01) & $Data); send data with IP from ini file
		Else
			TCPSend($MainSocket, @computername & Chr(01) & "Message on " & @computername & Chr(01) & $Data);send data with computername, LAN connections
		EndIf ;end use IP if
		
	EndIf
EndFunc   ;==>SendData

Func OnAutoItExit()
	TCPCloseSocket($MainSocket)
	TCPShutdown()
EndFunc   ;==>OnAutoItExit

