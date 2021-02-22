#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7

#include <GUIConstantsEx.au3>
#include <inet.au3>

Opt('MustDeclareVars', 1)

;==============================================
;==============================================
;SERVER!! Start Me First !!!!!!!!!!!!!!!
;==============================================
;==============================================

Example()

Func Example()
	Local $szIPADDRESS = @IPAddress1
	Local $nPORT = 5309
	Local $MainSocket, $GOOEY, $edit, $ConnectedSocket, $szIP_Accepted
	Local $msg, $recv

	; Start The TCP Services
	;==============================================
	TCPStartup()

	; Create a Listening "SOCKET".
	;   Using your IP Address and Port 5309.
	;==============================================
	$MainSocket = TCPListen($szIPADDRESS, $nPORT)

	; If the Socket creation fails, exit.
	If $MainSocket = -1 Then Exit(1)


	; Create a GUI for messages
	;==============================================
	$GOOEY = GUICreate("My Server (IP: " & $szIPADDRESS & ")", 300, 200)
	$edit = GUICtrlCreateEdit("", 10, 10, 280, 180)
	GUISetState()


	; Initialize a variable to represent a connection
	;==============================================
	$ConnectedSocket = -1


	;Wait for and Accept a connection
	;==============================================
	Do
		$ConnectedSocket = TCPAccept($MainSocket)
	Until $ConnectedSocket <> -1


	; Get IP of client connecting
;	$szIP_Accepted = SocketToIP($ConnectedSocket)

	; GUI Message Loop
	;==============================================
	While 1
		$msg = GUIGetMsg()

		; GUI Closed
		;--------------------
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop

		; Try to receive (up to) 2048 bytes
		;----------------------------------------------------------------
		$recv = ""
		$recv = TCPRecv($ConnectedSocket, 20480)

		; If the receive failed with @error then the socket has disconnected
		;----------------------------------------------------------------
		If @error Then ExitLoop

		; Update the edit control with what we have received
		;----------------------------------------------------------------
		If $recv <> "" Then 
			GUICtrlSetData($edit, " > " & $recv & @CRLF & GUICtrlRead($edit))
			FileWriteLine(@ScriptDir & "\URSFeedback.txt", $recv)
		EndIf
	WEnd
	If $ConnectedSocket <> -1 Then TCPCloseSocket($ConnectedSocket)
	TCPShutdown()
EndFunc   ;==>Example