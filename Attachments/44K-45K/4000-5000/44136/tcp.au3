#include <MsgBoxConstants.au3>

TCPStartup()
OnAutoItExitRegister("OnAutoItExit")
Local $sIPAddress = "10.5.254.131"
Local $iPort = 23
Local $iSocket = TCPConnect($sIPAddress, $iPort)
local $iError

If @error Then
        ; The server is probably offline/port is not opened on the server.
        Local $iError = @error
        MsgBox(0, "", "Could not connect, Error code: " & $iError)
        Exit
Else
        ;MsgBox($MB_SYSTEMMODAL, "", "Connection successful")
	 EndIf

while 1
   $iRec = TCPRecv($iSocket, 100)
   MsgBox(0,"test1", $iRec)
   ;Looking for username prompt
   if StringInStr($iRec, "name") Then
	  ExitLoop
   Else
	  TCPSend($iSocket, @CRLF)
   EndIf
WEnd

TCPSend($iSocket, "MyUsername" & @CRLF)
Sleep (1000)

;Look for password prompt
if StringInStr($iRec, "word") = 0 Then
   MsgBox(0,"test2", $iRec)
   MsgBox(0,"Error", "Did not receove password prompt")
   Exit
EndIf


TCPCloseSocket($iSocket)

TCPShutdown() ; Close the TCP service.



Func OnAutoItExit()
    TCPShutdown() ; Close the TCP service.
EndFunc   ;==>OnAutoItExit

