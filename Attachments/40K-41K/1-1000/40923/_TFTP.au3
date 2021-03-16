#include-once
#include <String.au3>
#include <Array.au3>

; #INDEX# ========================================================================
; Title .........: _TFTPClient.au3
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: TFTP UDF implementation for AutoIt3
; Author ........: Csaba "KEFE" Barta
; ================================================================================

; #VARIABLES# ====================================================================
Global $TFTP_LastConnection ;  enables the use of -1 to access the last opened connection
Global $TFTPErr ;  Plain text error message holder for TFTP errors (OpCode 0x05)
Global $WSAErr ;  Plain text error message holder for Windows Socket error codes (for details see: http://msdn.microsoft.com/en-us/library/windows/desktop/ms740668(v=vs.85).aspx)
Global Const $TFTP_OK = 0 ;  Successful result
Global Const $TFTP_ERROR = 1 ;  TFTP error
Global Const $TFTPUDFVersion = "0.0.1"
; ==============================================================================

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_Register()
; Description ...: Executes the UDPStartup(), if UDPStartup() failes set the apropiate error messages
; Syntax.........:  _TFTP_Register()
; Return values .: On Success - Returns $TFTP_OK
;                  On Failure - Returns $TFTP_ERROR and both $TFTPErr and $WSAErr are set.
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_Register()
	If UDPStartup() Then
		Return SetError($TFTP_OK, 0, $TFTP_OK)
	Else
		$TFTPErr = "Unable to execute UDPStartup()"
		$WSAErr = @error
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	EndIf
EndFunc

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_UnRegister()
; Description ...: Executes the UDPShutdown(), if UDPShutdown() failes set the apropiate error messages
; Syntax.........:  _TFTP_UnRegister()
; Return values .: On Success - Returns $TFTP_OK
;                  On Failure - Returns $TFTP_ERROR and both $TFTPErr and $WSAErr are set.
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_UnRegister()
	If UDPShutdown() Then
		Return SetError($TFTP_OK, 0, $TFTP_OK)
	Else
		$TFTPErr = "Unable to execute UDPShutdown()"
		$WSAErr = @error
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	EndIf
EndFunc

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_RRQ - TFTP Read Request (download from TFTP server)
; Description ...: Executes a Read Request (OpCode 0x0001), if server responds with DATA (0x0003) or OACK (0x0006) downloads the file, if server responds with ERROR (0x0005) displays the appropiate error message
; Syntax.........: _TFTP_RRQ($TFTPHost, $TFTPPort, $TFTPGetFilename, $FileLocalPath, $TFTPMode = "octet", $BlockSize = "128", $Timeout = 5)
; Return values .: On Success - Returns $TFTP_OK, also the file will be downloaded and copied to the path given in $FileLocalPath, directory will be created if it dosen't exists
;                  On Failure - Returns $TFTP_ERROR and both $TFTPErr and $WSAErr are set.
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_RRQ($TFTPHost, $TFTPPort, $TFTPGetFilename, $FileLocalPath, $TFTPMode = "octet", $BlockSize = "128", $Timeout = 5)
	$UDPSocket = UDPOpen($TFTPHost, $TFTPPort)
	$RRQ = "0x0001" & _StringToHex($TFTPGetFilename) & "00" & _StringToHex($TFTPMode) & "00" & _StringToHex("timeout") & "00" & _StringToHex($Timeout) & "00" & _StringToHex("blksize") & "00" & _StringToHex($BlockSize) & "00" & _StringToHex("tsize") & "00"
	$RRQStatus = UDPSend($UDPSocket, $RRQ)
	$DataRecv = UDPRecv($UDPSocket, $BlockSize, 2)
	$TimeoutLoop = 0
	If $DataRecv <> "" Then
		$UDPSocketEphemeral = $UDPSocket
		$UDPSocketEphemeral[3] = $DataRecv[2]
		$DLFile = _TFTP_DATA($UDPSocketEphemeral, $TFTPGetFilename, $FileLocalPath, $DataRecv, $TFTPMode, $BlockSize, $Timeout, 1)
		If $DLFile = 0 Then
			Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
		Else
			Return $DLFile
		EndIf
	Else
		Do
			$TimeoutLoop = $TimeoutLoop + 1
			Sleep(1000)
		Until $DataRecv <> "" Or $TimeoutLoop = $Timeout
		If $TimeoutLoop = $Timeout Then
			$TFTPErr = "Read Request timed out"
			Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
		ElseIf $DataRecv <> "" Then
		$UDPSocketEphemeral = $UDPSocket
		$UDPSocketEphemeral[3] = $DataRecv[2]
		$DLFile = _TFTP_DATA($UDPSocketEphemeral, $TFTPGetFilename, $FileLocalPath, $DataRecv, $TFTPMode, $BlockSize, $Timeout, 1)
		If $DLFile = 0 Then
			Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
		Else
			Return $DLFile
		EndIf
		Else
			$TFTPErr = "An unhandle error turned up during your Read Request"
			Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
		EndIf
	EndIf
EndFunc

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_DATA - TFTP Data Receive - both for RRQ and for standalone
; Description ...: Handels the TFTP Data Receive (OpCode 0x0003), both in standalone and for RRQ responses also if its needed calls the TFTP ERROR (OpCode 0x0005) handler
; Syntax.........: _TFTP_DATA($UDPSocket (usually on an ephemeral port), $TFTPGetFilename, $FileLocalPath, $FirstDataPacket (or in case of an error, error packet), $TFTPMode = "octet", $BlockSize = "128", $Timeout = 5, $CallMethod = 0 (0 for standalone, 1 for after an RRQ))
; Return values .: On Success - Returns $TFTP_OK, also the received data will be written to $FileLocalPath & "\" & $TFTPGetFilename
;                  On Failure - Returns $TFTP_ERROR and both $TFTPErr and $WSAErr are set.
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_DATA($UDPSocket, $TFTPGetFilename, $FileLocalPath, $FirstDataPacket, $TFTPMode = "octet", $BlockSize = "128", $Timeout = 5, $CallMethod = 0)
;	If $TransferSize = 0 Then $TransferSize = Floor(DriveSpaceFree(@ScriptDir)*1048576)
;	ConsoleWrite($UDPSocket[2] & "-" & $UDPSocket[3] & "-" & $TFTPGetFilename & "-" & $FileLocalPath & "-" & $FirstDataPacket[0] & "-" & $TFTPMode & "-" & $BlockSize & "-" & $Timeout & "-" & $CallMethod & @CR)
	$OpCode = StringLeft(StringTrimLeft($FirstDataPacket[0], 2), 4)
;	ConsoleWrite($OpCode & @CR)
	If $OpCode = "0003" Then
		ConsoleWrite("DATA" & @CR)
	ElseIf $OpCode = "0004" Then
		ConsoleWrite("ACK" & @CR)
	ElseIf $OpCode = "0005" Then
		Return _TFTP_ERROR($FirstDataPacket[0])
	ElseIf $OpCode = "0006" Then
		$WriteOutTo = FileOpen($FileLocalPath & "\" & "DLD_" & $TFTPGetFilename, 2)
		$OACKResp = _TFTP_OACK($UDPSocket, $FirstDataPacket[0], $CallMethod)
		$ReturnSizeWillBe = 0
		$BlockSizeWillBe = 0
		$TimeoutWillBe = 0
		For $OACKCnt = 0 To UBound($OACKResp)-1
			$OACKItem = StringSplit($OACKResp[$OACKCnt], "|")
			If $OACKItem[1] = "tsize" Then $ReturnSizeWillBe = $OACKItem[2]
			If $OACKItem[1] = "blksize" Then $BlockSizeWillBe = $OACKItem[2]
			If $OACKItem[1] = "timeout" Then $TimeoutWillBe = $OACKItem[2]
		Next
		If $BlockSizeWillBe = $BlockSize And $Timeout = $TimeoutWillBe Then
			$NrTotalACK = $ReturnSizeWillBe / $BlockSize
		EndIf
		For $SendLoop = 0 To $NrTotalACK+1
;			If _TFTP_ACK($UDPSocket, 0) And $SendLoop = 0 Then
;			If _TFTP_ACK($UDPSocket, 0) Then
			If _TFTP_ACK($UDPSocket, $SendLoop) Then
				$RecvIs = UDPRecv($UDPSocket, $BlockSize+4)
				ConsoleWrite("Get Back: " & $RecvIs & @CR)
				$RecvIsData = _HexToString(StringTrimLeft($RecvIs, 10))
				FileWrite($WriteOutTo, $RecvIsData)
				$NextPacket = _HexToString("0x" & StringMid(StringTrimLeft($RecvIs, 6), 1, 4))
			EndIf
;			_TFTP_ACK($UDPSocket, $NextPacket)
;			$RecvIs = UDPRecv($UDPSocket, $BlockSize+4)
;			ConsoleWrite($NextPacket & ": Get Back: " & $RecvIs & @CR)
		Next
	FileClose($WriteOutTo)
	Else
		ConsoleWrite("SEND ERROR " & $OpCode & @CR)
	EndIf
EndFunc

Func _TFTP_ACK($UDPSocket, $BlockNr)
	$Send = UDPSend($UDPSocket, "0x0004" & Hex($BlockNr, 4))
	ConsoleWrite("ACK:" & $BlockNr & " * " & Hex($BlockNr, 4) & @CR)
	Return $Send
EndFunc

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_ERROR - Handles TFTP Error (Op Code 0x0005) messages
; Description ...: Handels the TFTP Error (Op Code 0x0005) messages
; Syntax.........: _TFTP_ERROR($ErrorPacket)
; Return values .: On Success - Returns $TFTP_ERROR with the interpreted error message
;                  On Failure - Returns $TFTP_ERROR with a generic error message
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_ERROR($ErrorPacket)
	$ErrorPacket = StringReplace($ErrorPacket, "0x0005", "")
	$ErrorCode = StringLeft($ErrorPacket, 4)
	If $ErrorCode = "0000" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "Undefined Error *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0001" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "File Not Found *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0002" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "Access Violation *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0003" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "Disk Full Or Allocation Exceeded *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0004" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "Illegal TFTP Operation *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0005" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "Unknown Transfer ID *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0006" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "File Already Exists *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	ElseIf $ErrorCode = "0007" Then
		$ReturnError = _HexToString("0x" & StringTrimRight(StringTrimLeft($ErrorPacket, 4), 2))
		$TFTPErr = "No Such User *** Server returned this message: " & $ReturnError
		Return SetError($TFTP_ERROR, 0, $TFTP_ERROR)
	Else
		ConsoleWrite("SEND ERROR BAD ERROR MSG" & @CR)
	EndIf
EndFunc

; #FUNCTION# ===================================================================
; Name ..........: _TFTP_OACK - Handles TFTP Optional Acknowledgement (Op Code 0x0006) messages
; Description ...: Handels the TFTP Optional Acknowledgement (Op Code 0x0006) messages
; Syntax.........: _TFTP_OACK($OACKPacket)
; Return values .: On Success - Returns $TFTP_OK and an array with interpretation of the packet
;                  On Failure - Returns $TFTP_ERROR and sets the failure reason to $TFTPErr
; Author ........: Csaba "KEFE" Barta
; Remarks .......: AutoIt3 v3.3.8.1 or higher
; ==============================================================================
Func _TFTP_OACK($UDPSocket, $OACKPacket, $CallMethod = 0)
	$OACKPacket = StringTrimRight(StringReplace($OACKPacket, "0x0006", ""), 2)
	$OACKArray = StringSplit($OACKPacket, "00", 1)
	_ArrayDelete($OACKArray, 0)
	Global $OACKReturn[UBound($OACKArray)/2]
	For $i = 0 To UBound($OACKArray)/2-1
		$OACKReturn[$i] = _HexToString("0x" & $OACKArray[$i+$i]) & "|" & _HexToString("0x" & $OACKArray[$i+$i+1])
	Next
;	If $CallMethod = 1 Then
;		_TFTP_ACK($UDPSocket, 0)
;	EndIf
	Return $OACKReturn
EndFunc