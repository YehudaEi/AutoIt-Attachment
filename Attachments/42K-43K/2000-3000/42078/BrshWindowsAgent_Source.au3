#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=BrshWindowsAgent.exe
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Comment=Brsh Windows Agent
#AutoIt3Wrapper_Res_Description=Brsh Windows Agent
#AutoIt3Wrapper_Res_Fileversion=0.1.0.1
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_LegalCopyright=bahadirkaanuysal@gmail.com
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#AutoIt3Wrapper_Run_Tidy=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

Opt("TrayIconHide", 1) ;0=show, 1=hide tray icon
Opt("TrayAutoPause", 0) ;0=no pause, 1=Pause

#include <GUIConstantsEx.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiMenu.au3>
#include <Crypt.au3>
#include <GDIPlus.au3>
;#include <Base64.au3>
#include <Constants.au3>

TCPStartup() ; Starts up TCP
;_Crypt_Startup() ; Starts up Crypt
;_GDIPlus_Startup() ; Starts up GDIPlus



Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")



; Com Error Handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.Number, 8)
	$strMSG = "Error Number: " & $HexNumber & @CRLF
	$strMSG &= "WinDescription: " & $oMyError.WinDescription & @CRLF
	$strMSG &= "Script Line: " & $oMyError.ScriptLine & @CRLF
	ConsoleWrite("ERROR" & $strMSG)
	SetError(1)
EndFunc   ;==>MyErrFunc

#region ;**** Declares you can edit ****
Opt("TrayIconDebug", 1)
Global $BindIP = "0.0.0.0" ; IP Address to listen on.	0.0.0.0 = all available.
Global $BindPort = "33892" ; Port to listen on.
Global $MaxConnections = 1000 ; Maximum number of allowed connections.
Global $PacketSize = 150000 ; Maximum size to receive when packets are checked.
#endregion ;**** Declares you can edit ****

#region ;**** Declares that shouldn't be edited ****
OnAutoItExitRegister("_ServerClose")
Opt("TCPTimeout", 0)
Opt("GUIOnEventMode", 1)
Global $WS2_32 = DllOpen("Ws2_32.dll") ; Opens Ws2_32.dll to be used later.
Global $NTDLL = DllOpen("ntdll.dll") ; Opens NTDll.dll to be used later.
Global $TotalConnections = 0 ; Holds total connection number.
Global $SocketListen = -1 ; Variable for TCPListen()
Global $Connection[$MaxConnections + 1][11] ; Array to connection information.
Global $SocketListen
Global $PacketEND = "*[" & IniRead(@ScriptDir & "\authentication.ini", "AUTH", "KEY", "DEFAULT") & "]*"; "[PACKET_END]" ; Defines the end of a packet
Global $PacketMSG = "[PACKET_TYPE_0001]" ; Plain text message
Global $PacketPNG = "[PACKET_TYPE_0002]" ; Base64 of FÝLE TRANSFER binary.
Global $PacketPCI = "[PACKET_TYPE_0003]" ; UserName@PC name
Global $PacketKEY = "[PACKET_TYPE_0004]" ; Change Agent's Authentication Key
Global $PacketKEYNotMatch = "[PACKET_TYPE_0005]" ; Access Denied
Global $PacketEXT = "[PACKET_TYPE_0006]" ;Name of the file
Global $PacketDEST = "[PACKET_TYPE_0007]" ;Destination of the file to be saved
#endregion ;**** Declares that shouldn't be edited ****

#region ;**** GUI ****
Global $GUI = GUICreate("Server List", 300, 400)
Global $ServerList = GUICtrlCreateListView("#|Socket|IP|User|Computer", 5, 5, 290, 360)
Global $ServerMenu = GUICtrlCreateMenu("Server")
Global $ServerStartListen = GUICtrlCreateMenuItem("On", $ServerMenu, 2, 1)
Global $ServerStopListen = GUICtrlCreateMenuItem("Off", $ServerMenu, 3, 1)
Global $ConnectionMenu = GUICtrlCreateMenu("Connection")
Global $ConnectionKill = GUICtrlCreateMenuItem("Close", $ConnectionMenu, 1)
GUICtrlCreateMenuItem("", $ConnectionMenu, 2)
Global $ConnectionKillAll = GUICtrlCreateMenuItem("Close All", $ConnectionMenu, 3)
GUISetOnEvent($GUI_EVENT_CLOSE, "_ServerClose")
GUICtrlSetOnEvent($ServerStartListen, "_ServerListenStart")
GUICtrlSetOnEvent($ServerStopListen, "_ServerListenStop")
GUICtrlSetOnEvent($ConnectionKill, "_ConnectionKill")
GUICtrlSetOnEvent($ConnectionKillAll, "_ConnectionKillAll")
GUISetState(@SW_HIDE, $GUI)
#endregion ;**** GUI ****

_ServerListenStart()

_Main1() ; Starts the main function

Func _Main1()
	While 1
		_CheckNewConnections()
		_CheckNewPackets()
		_Sleep(100, $NTDLL)

	WEnd
EndFunc   ;==>_Main1

Func _CheckNewConnections()
	Local $SocketAccept = TCPAccept($SocketListen) ; Tries to accept a new connection.
	If $SocketAccept = -1 Then ; If we found no new connections,
		Return ; skip the rest and return to _Main1().
	EndIf

	If $TotalConnections >= $MaxConnections Then ; If we reached the maximum connections allowed,
		TCPSend($SocketAccept, "MAXIMUM_CONNECTIONS_REACHED") ; tell the connecting client that we cannot accept the connection,
		TCPCloseSocket($SocketAccept) ; close the socket,
		Return ; skip the rest and return to _Main1().
	EndIf
	; Since we got this far, we must have a new connection.
	$TotalConnections += 1 ; Add to the total connections.
	$Connection[$TotalConnections][0] = $SocketAccept ; Save the socket number to the next empty array slot, at sub array 0.
	$Connection[$TotalConnections][1] = GUICtrlCreateListViewItem($TotalConnections & "|" & $SocketAccept & "|" & _SocketToIP($SocketAccept), $ServerList) ; Create list view item with connection information
EndFunc   ;==>_CheckNewConnections

Func _CheckBadConnection()
	If $TotalConnections < 1 Then Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main1()
	Local $NewTotalConnections = 0 ; Temporary variable to calculate the new total connections.
	For $i = 1 To $TotalConnections ; Loop through all
		TCPSend($Connection[$i][0], "CONNECTION_TEST") ; Send a test packet
		If @error Then ; If the send fails..
			TCPCloseSocket($Connection[$i][0]) ; Close the socket,
			GUICtrlDelete($Connection[$i][1]) ; Delete the item from the list view,
			$Connection[$i][0] = -"" ; Set socket to nothing,
			$Connection[$i][1] = "" ; Empty gui control,
			ContinueLoop ; and continue checking for more bad connections.
		Else
			$NewTotalConnections += 1 ; If the send succeeded, we count up, because the client is still connected.
		EndIf
	Next

	If $NewTotalConnections < $TotalConnections Then ; If we found any bad connections, then we rearrange the $Connection array.
		If $NewTotalConnections < 1 Then ; If the new total shows no connections,
			$TotalConnections = $NewTotalConnections ; Set the new connection variable,
			Return ; and Return to _Main1()
		EndIf

		; This loop creates a temporary array, cycles through possible old data in the $Connection array and transfers it to the temporary array, rearranged properly.
		Local $Count = 1
		Local $TempArray[$MaxConnections + 1][11]
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] = -1 Or $Connection[$i][0] = "" Then
				ContinueLoop
			EndIf
			For $j = 0 To 10
				$TempArray[$Count][$j] = $Connection[$i][$j]
			Next
			$Count += 1
		Next
		$TotalConnections = $NewTotalConnections ; Self explanitory.
		$Connection = $TempArray ; Transfer the newly arranged temporary array to our main array.

		; This loop doesn't directly affect anything with the connection, but makes the list numbered (or re-numbered, after the array was fixed.)
		For $i = 1 To $TotalConnections
			GUICtrlSetData($Connection[$i][1], $i)
		Next
	EndIf
EndFunc   ;==>_CheckBadConnection
Func _CheckNewPackets()
	If $TotalConnections < 1 Then
		Return ; If we have no connections, there is no reason to check for bad ones, so return to _Main1()
	EndIf
	Local $RecvPacket
	For $i = 1 To $TotalConnections ; Loop through all connections
		$RecvPacket = TCPRecv($Connection[$i][0], $PacketSize) ; Attempt to receive data
		If @error Then ; If there was an error, the connection is probably down.
			_CheckBadConnection() ; So, we call the function to check.
		EndIf
		If $RecvPacket <> "" Then ; If we got data...
			;ConsoleWrite("Current Authentication Key!" & $PacketEND & @CRLF)
			$Connection[$i][2] &= $RecvPacket ; Add it to the packet buffer.
			$PacketEND = "*[" & IniRead("authentication.ini", "AUTH", "KEY", "DEFAULT") & "]*"
			If StringInStr($Connection[$i][2], $PacketPNG) Then
			Else
				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite(">> New Packet from " & _SocketToIP($Connection[$i][0]) & @CRLF & "+> " & $RecvPacket & @CRLF & @CRLF) ; Let us know we got a packet in scite.
			EndIf

		EndIf
		;MsgBox(0, "", $PacketEND)

		If StringInStr($Connection[$i][2], $PacketKEY) Or StringInStr($Connection[$i][2], $PacketPCI) Then
			If Not StringInStr($Connection[$i][2], $PacketEND) Then
				Global $SendSocket = $Connection[$i][0]
				; ConsoleWrite("$RawPackets==" & $RawPackets)
				TCPSend($SendSocket, $PacketKEYNotMatch)
				;ConsoleWrite("Girdi")
				$Connection[$i][2] = ""
			EndIf
		EndIf

		If StringInStr($Connection[$i][2], $PacketEND) Then ; If we received the end of a packet, then we will process it.
			Local $RawPackets = $Connection[$i][2] ; Transfer all the data we have to a new variable.
			Local $LengthOfPAcketEnd = StringLen($PacketEND)
			Local $PrefixSuffixLength = 18 + $LengthOfPAcketEnd
			Local $FirstPacketLength = StringInStr($RawPackets, $PacketEND) - $PrefixSuffixLength ; Get the length of the packet, and subtract the length of the prefix/suffix.
			Local $PacketType = StringLeft($RawPackets, 18) ; Copy the first 18 characters, since that is where the packet type is put.
			$LengthOfPAcketEnd = $LengthOfPAcketEnd - 1
			Local $CompletePacket = StringMid($RawPackets, 19, $FirstPacketLength + $LengthOfPAcketEnd) ; Extract the packet.
			Local $PacketsLeftover = StringTrimLeft($RawPackets, $FirstPacketLength + $PrefixSuffixLength + $LengthOfPAcketEnd) ; Trim what we are using, so we only have what is left over. (any incomplete packets)
			$Connection[$i][2] = $PacketsLeftover ; Transfer any leftover packets back to the buffer.
			; Writes some stuff to the console for debugging.
			If StringInStr($RawPackets, $PacketPNG) Then
			Else
				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite(">> Full packet found!" & @CRLF)
				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("+> Type: " & $PacketType & @CRLF)

				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("+> Packet: " & $CompletePacket & @CRLF)

				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("!> Left in buffer: " & $Connection[$i][2] & @CRLF & @CRLF)
			EndIf
			; Since we extracted a packet, we will send it to the processor.
			Global $SendSocket = $Connection[$i][0]
			_ProcessFullPacket($CompletePacket, $PacketType, $i)
		Else
			;Global $SendSocket = $Connection[$i][0]
			;ConsoleWrite("$RawPackets==" & $RawPackets)
			;TCPSend($SendSocket, $PacketKEYNotMatch)
		EndIf
	Next
EndFunc   ;==>_CheckNewPackets

; I think the processor is generally easy to understand.  It was made to process any packet that is received in a very organized way, making new additions painless.
; Adding new packet types is easy. Define it at the top, and add a new Case statement in this function.  Packet types are defined as "[PACKET_TYPE_0000]"
; Length of the packet type MUST be the same.  If it's not, it will not be processed.  Thus you should only change the number, 0000-9999.
; We process the packet based on the type.

; $PacketMSG Messages pop up in a message box.
; $PacketPNG PNG gets saved/ran.
; $PacketPCI PC info updates the list view with username and computer name.

Func _ProcessFullPacket($CompletePacket, $PacketType, $ArraySlotNumber)
	Switch $PacketType
		Case $PacketMSG
			;TrayTip("New message from " & _SocketToIP($Connection[$ArraySlotNumber][0]), $CompletePacket, 5, 1)
			;MsgBox(0, "", $CompletePacket)
			Dim $DOS = "", $PID = "", $PIDINFO = 0, $Message = '' ;; added "= ''" for show only.
			Local $spaces[500]
			$spaces = StringSplit(String($CompletePacket), " ")
			$rows = UBound($spaces) - 1
			If StringInStr(String($CompletePacket), ".exe") And $rows < 2 Then
				$PID = Run($CompletePacket, "", @SW_HIDE)
				$PIDINFO = 1
			Else
				;MsgBox(0, "", $SPACES[0])
				If StringInStr(String($CompletePacket), ".exe") And StringInStr(String($spaces[0]), ":") And $rows > 2 Then
					$PID = Run($CompletePacket, "", @SW_HIDE)
					$PIDINFO = 1
				Else

					$DOS = Run(@ComSpec & " /c " & $CompletePacket, "", @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
					ProcessWaitClose($DOS)
					$Message = StdoutRead($DOS)
					;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite($Message & @CRLF)
					$PIDINFO = 0

				EndIf
				;$GETINFO = $DOS
			EndIf


			;ConsoleWrite("Program Executed Successfully PID is : " & $PID & @CRLF)
			If $PIDINFO = 1 Then
				TCPSend($SendSocket, $PacketMSG & "Program Executed Successfully PID is : " & $PID & $PacketEND)
			Else
				TCPSend($SendSocket, $PacketMSG & $Message & $PacketEND)
			EndIf;;;;;;;;;;;;;;;;;;;;;;;
			;MsgBox(0, "New Message", "Message From " & _SocketToIP($Connection[$ArraySlotNumber][0]) & @CRLF & @CRLF & $CompletePacket)
		Case $PacketDEST
			Global $destination = $CompletePacket

		Case $PacketEXT
			Global $filename = $CompletePacket

		Case $PacketPNG

			If StringLen($CompletePacket) > 1 Then ; This check must be added because _Base64Decode() will crash the script if it gets empty input.

				;		$FileHandle = FileOpen($destination, 16 + 2 + 8)

				;		$maxlen = 5 * 1024
				;		FileWrite($FileHandle, $CompletePacket) ;recreate the file sent
				;		FileClose($FileHandle)



				Local $sBuff, $sRecv = "", $i = 0


				Local $File = $destination & $filename

				$sBuff = _LZNTDecompress($CompletePacket)

				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("File name and address:" & $File & @CRLF)

				$iFileOp = FileOpen($File, 16 + 2)
				If @error Then Return 0
				FileWrite($iFileOp, $sBuff)
				If @error Then Return 0
				FileClose($iFileOp)





				TCPSend($SendSocket, $PacketMSG & "File Transfer Successfully Finished" & @CRLF & $PacketEND)
				;ShellExecute($File)

			Else
				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("Error Received empty PNG packet.")
				TCPSend($SendSocket, $PacketMSG & "File Transfer Error" & @CRLF & $PacketEND)
			EndIf


		Case $PacketPCI
			Local $PacketPCISplit = StringSplit($CompletePacket, "@", 1)
			Local $UserName = $PacketPCISplit[1]
			Local $CompName = $PacketPCISplit[2]
			GUICtrlSetData($Connection[$ArraySlotNumber][1], "|||" & $UserName & "|" & $CompName)
		Case $PacketKEY
			If StringInStr(String($CompletePacket), " ") Then
				;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite("Authentication key can not contain any spaces." & @CRLF)
				TCPSend($SendSocket, $PacketMSG & "Authentication key can not contain any spaces." & @CRLF & $PacketEND)
			Else

				If IniWrite("authentication.ini", "AUTH", "KEY", $CompletePacket) Then
					;ConsoleWrite("$PacketKEY" & $PacketKEY & @CRLF)
					;ConsoleWrite("$CompletePacket:" & $CompletePacket & @CRLF)
					If $CompletePacket = "" Then
						TCPSend($SendSocket, $PacketMSG & "Authentication key can not be empty" & @CRLF & $PacketEND)
					Else
						TCPSend($SendSocket, $PacketKEY & "Authentication key successfully changed. New key is : " & $CompletePacket & @CRLF & $PacketEND)
						$PacketEND = "*[" & $CompletePacket & "]*"
						;;;;;;;;;;;;;;;;;;;;;;ConsoleWrite(@CRLF & "Authentication key successfully changed. New key is : " & $CompletePacket & @CRLF)
					EndIf
				EndIf
			EndIf

	EndSwitch
EndFunc   ;==>_ProcessFullPacket

Func _ServerListenStart() ; Starts listening.
	If $SocketListen <> -1 Then
		ConsoleWrite("Error Socket already open.")
		Return
	Else
		$SocketListen = TCPListen($BindIP, $BindPort, $MaxConnections) ; Starts listening.
		If $SocketListen = -1 Then
			ConsoleWrite("Error Unable to open socket.")
		EndIf
	EndIf
EndFunc   ;==>_ServerListenStart

Func _ServerListenStop() ; Stops listening.
	If $SocketListen = -1 Then
		ConsoleWrite("Error Socket already closed.")
		Return
	EndIf
	TCPCloseSocket($SocketListen)
	$SocketListen = -1
EndFunc   ;==>_ServerListenStop

Func _ServerClose() ; Exits properly.
	If $TotalConnections >= 1 Then
		For $i = 1 To $TotalConnections
			TCPSend($Connection[$i][0], "SERVER_SHUTDOWN")
			TCPCloseSocket($Connection[$i][0])
		Next
	EndIf
	TCPShutdown()
	_GDIPlus_Shutdown()
	_Crypt_Shutdown()
	DllClose($NTDLL)
	DllClose($WS2_32)
	GUIDelete($GUI)
	Exit
EndFunc   ;==>_ServerClose

Func _SocketToIP($SHOCKET) ; IP of the connecting client.
	Local $sockaddr = DllStructCreate("short;ushort;uint;char[8]")
	Local $aRet = DllCall($WS2_32, "int", "getpeername", "int", $SHOCKET, "ptr", DllStructGetPtr($sockaddr), "int*", DllStructGetSize($sockaddr))
	If Not @error And $aRet[0] = 0 Then
		$aRet = DllCall($WS2_32, "str", "inet_ntoa", "int", DllStructGetData($sockaddr, 3))
		If Not @error Then $aRet = $aRet[0]
	Else
		$aRet = 0
	EndIf
	$sockaddr = 0
	Return $aRet
EndFunc   ;==>_SocketToIP

Func _Sleep($MicroSeconds, $NTDLL = "ntdll.dll") ; Faster sleep than Sleep().
	Local $DllStruct
	$DllStruct = DllStructCreate("int64 time;")
	DllStructSetData($DllStruct, "time", -1 * ($MicroSeconds * 10))
	DllCall($NTDLL, "dword", "ZwDelayExecution", "int", 0, "ptr", DllStructGetPtr($DllStruct))
EndFunc   ;==>_Sleep

Func _ConnectionKill()
	Local $selected = GUICtrlRead(GUICtrlRead($ServerList))
	If Not $selected <> "" Then
		MsgBox(16, "Error", "Please select a connection first.")
		Return
	EndIf
	Local $StringSplit = StringSplit($selected, "|", 1)
	TCPCloseSocket($Connection[$StringSplit[1]][0])
EndFunc   ;==>_ConnectionKill

Func _ConnectionKillAll()
	If $TotalConnections >= 1 Then
		For $i = 1 To $MaxConnections
			If $Connection[$i][0] > 0 Then
				TCPSend($Connection[$i][0], "SERVER_SHUTDOWN")
				TCPCloseSocket($Connection[$i][0])
			EndIf
		Next
	EndIf
EndFunc   ;==>_ConnectionKillAll




; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTDecompress
; Description ...: Decompresses input data.
; Syntax.........: _LZNTDecompress ($bBinary)
; Parameters ....: $vInput - Binary data to decompress.
; Return values .: Success - Returns decompressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error decompressing.
; Author ........: trancexx
; Related .......: _LZNTCompress
; Link ..........; <a href='http://msdn.microsoft.com/en-us/library/bb981784.aspx' class='bbc_url' title='External link' rel='nofollow external'>http://msdn.microsoft.com/en-us/library/bb981784.aspx</a>
;
;==========================================================================================
Func _LZNTDecompress($bBinary)

	If Not IsBinary($bBinary) Then $bBinary = Binary($bBinary)


	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlDecompressBuffer", _
			"ushort", 2, _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error decompressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[6] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTDecompress



; #FUNCTION# ;===============================================================================
;
; Name...........: _LZNTCompress
; Description ...: Compresses input data.
; Syntax.........: _LZNTCompress ($vInput [, $iCompressionFormatAndEngine])
; Parameters ....: $vInput - Data to compress.
;                  $iCompressionFormatAndEngine - Compression format and engine type. Default is 2 (standard compression). Can be:
;                  |2 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_STANDARD
;                  |258 - COMPRESSION_FORMAT_LZNT1 | COMPRESSION_ENGINE_MAXIMUM
; Return values .: Success - Returns compressed binary data.
;                          - Sets @error to 0
;                  Failure - Returns empty string and sets @error:
;                  |1 - Error determining workspace buffer size.
;                  |2 - Error compressing.
; Author ........: trancexx
; Related .......: _LZNTDecompress
; Link ..........; <a href='http://msdn.microsoft.com/en-us/library/bb981783.aspx' class='bbc_url' title='External link' rel='nofollow external'>http://msdn.microsoft.com/en-us/library/bb981783.aspx</a>
;
;==========================================================================================
Func _LZNTCompress($vInput, $iCompressionFormatAndEngine = 2)

	If Not ($iCompressionFormatAndEngine = 258) Then
		$iCompressionFormatAndEngine = 2
	EndIf

	Local $bBinary = Binary($vInput)

	Local $tInput = DllStructCreate("byte[" & BinaryLen($bBinary) & "]")
	DllStructSetData($tInput, 1, $bBinary)

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlGetCompressionWorkSpaceSize", _
			"ushort", $iCompressionFormatAndEngine, _
			"dword*", 0, _
			"dword*", 0)

	If @error Or $a_Call[0] Then
		Return SetError(1, 0, "") ; error determining workspace buffer size
	EndIf

	Local $tWorkSpace = DllStructCreate("byte[" & $a_Call[2] & "]") ; workspace is needed for compression

	Local $tBuffer = DllStructCreate("byte[" & 16 * DllStructGetSize($tInput) & "]") ; initially oversizing buffer

	Local $a_Call = DllCall("ntdll.dll", "int", "RtlCompressBuffer", _
			"ushort", $iCompressionFormatAndEngine, _
			"ptr", DllStructGetPtr($tInput), _
			"dword", DllStructGetSize($tInput), _
			"ptr", DllStructGetPtr($tBuffer), _
			"dword", DllStructGetSize($tBuffer), _
			"dword", 4096, _
			"dword*", 0, _
			"ptr", DllStructGetPtr($tWorkSpace))

	If @error Or $a_Call[0] Then
		Return SetError(2, 0, "") ; error compressing
	EndIf

	Local $tOutput = DllStructCreate("byte[" & $a_Call[7] & "]", DllStructGetPtr($tBuffer))

	Return SetError(0, 0, DllStructGetData($tOutput, 1))

EndFunc   ;==>_LZNTCompress

Func _DecToBin($dec)
	If (Not IsInt($dec)) Or ($dec < 0) Then Return -1
	$bin = ""
	If $dec = 0 Then Return "0"
	While $dec <> 0
		$bin = BitAND($dec, 1) & $bin
		$dec = BitShift($dec, 1)
	WEnd
	Return $bin
EndFunc   ;==>_DecToBin

Func _BinToDec($bin)
	If (Not IsString($bin)) Then Return -1
	$end = StringLen($bin)
	$dec = 0
	For $cpt = 1 To $end
		$char = StringMid($bin, $end + 1 - $cpt, 1)
		Select
			Case $char = "1"
				$dec = BitXOR($dec, BitShift(1, -($cpt - 1)))
			Case $char = "0"
				; nothing
			Case Else
				;error
				Return -1
		EndSelect
	Next
	Return $dec
EndFunc   ;==>_BinToDec

Func _CharToBin($char)
	If (Not IsString($char)) Or (StringLen($char) <> 1) Then Return -1
	$val = Asc($char)
	Return _DecToBin($val)
EndFunc   ;==>_CharToBin

Func _BinToChar($bin)
	If (Not IsString($bin)) Or (StringLen($bin) < 1) Or (StringLen($bin) > 8) Then Return -1
	$dec = _BinToDec($bin)
	If $dec <> -1 Then Return Chr($dec)
	Return -1
EndFunc   ;==>_BinToChar