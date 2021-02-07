#include <WinAPI.au3>
#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Author:         DELmE

 Function:
    _TCPFileRecv

Description:
    Receives a file being sent over a TCP connection

Parameters:
	sock				The TCP socket to be used
    rFile      			The name of the file to save to
	offset = 0			The offset to start writing data to the file at (to be used if the transfer is somehow interrupted) default value is 0 (no offset)
	$DataSize = 1024	The number of bytes of data to be received per packet, default value is 1024

Return value:
    Success     _TCPFileRecv returns the number of bytes written to the file
    Failure     _TCPFileRecv returns 0 if the function failed and sets @error to the following:
		1 = Error opening the file
		2 = Failed to set offset
		3 = Failed to receive data on socket (invalid socket)
		4 = Unable to write data to the file
		Also sets @extended to the number of bytes of data that was successfully written to the file

#ce ----------------------------------------------------------------------------
Func _TCPFileRecv($sock, $rFile, $offset = 0, $DataSize = 1024)
	Local $i, $x, $lpszBuff, $nBytes, $rBuff, $hFile
	$nBytes = 0
	$lpszBuff = DllStructCreate("byte["&$DataSize&"]")
	$hFile = _WinAPI_CreateFile($rFile,3,4,4)
	If $hFile = 0 Then
		_WinAPI_CloseHandle($hFile)
		SetError(1)
		SetExtended($nBytes)
		Return 0
	EndIf
	While 1
		If _WinAPI_SetFilePointer($hFile, $offset, 0) = -1 Then
			_WinAPI_CloseHandle($hFile)
			SetError(2)
			SetExtended($nBytes)
			Return 0
		EndIf
		$rBuff = ""
		$rBuff = TCPRecv($sock, $DataSize)
		If $rBuff <> "" Then
			If @error = -1 Then
				_WinAPI_CloseHandle($hFile)
				SetError(3)
				SetExtended($nBytes)
				Return 0
			EndIf
			If $rBuff = @CRLF&@CRLF Then
				ExitLoop
			Else
				DllStructSetData($lpszBuff, 1, $rBuff)
				$x = StringLen(BinaryToString($rBuff))
				If _WinAPI_WriteFile($hFile, DllStructGetPtr($lpszBuff), $x, $i) = False Then
					_WinAPI_CloseHandle($hFile)
					SetError(4)
					SetExtended($nBytes)
					Return 0
				Else
					$nBytes += $i
					$offset += $i
				EndIf
			EndIf
		EndIf
	WEnd
	_WinAPI_CloseHandle($hFile)
	SetExtended($nBytes)
	Return $nBytes
EndFunc ;==> _TCPFileRecv

#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Author:         DELmE

 Function:
    _TCPFileSend

Description:
    Sends a file over a TCP connection

Parameters:
	sock				The tcp socket to be used
    sFile      			The file to be sent
	offset = 0			The offset to start reading data from the file at (to be used if the transfer is somehow interrupted) default value is 0 (no offset)
	$DataSize = 1024	The number of bytes of data to be sent per packet, default value is 1024

Return value:
    Success     _TCPFileSend returns the number of bytes sent
    Failure     _TCPFileSend returns 0 if an error occurred and sets @error to the following:
		1 = The file does not exist
		2 = Failed to set offset
		3 = Failed to read data from file
		4 = Failed to send data through socket
		Also sets @extended to the number of bytes of data that was successfully sent

#ce ----------------------------------------------------------------------------
Func _TCPFileSend($sock, $sFile, $offset = 0, $DataSize = 1024)
	Local $i, $lpszBuff, $nBytes, $sBuff, $hFile, $nFileSize
	$nFileSize = FileGetSize($sFile)
	$nFileSize -= $offset
	If $nFileSize < $DataSize Then $DataSize = $nFileSize
	$nBytes = 0
	$lpszBuff = DllStructCreate("byte["&$DataSize&"]")
	$hFile = _WinAPI_CreateFile($sFile,2,2,2)
	If $hFile = 0 Then
		_WinAPI_CloseHandle($hFile)
		SetError(1)
		SetExtended($nBytes)
		Return 0
	EndIf
	While $nFileSize > 0
		If _WinAPI_SetFilePointer($hFile, $offset, 0) = -1 Then
			_WinAPI_CloseHandle($hFile)
			SetError(2)
			SetExtended($nBytes)
			Return 0
		EndIf
		DllStructSetData($lpszBuff,1,"")
		If _WinAPI_ReadFile($hFile, DllStructGetPtr($lpszBuff), $DataSize, $i) = False Then
			_WinAPI_CloseHandle($hFile)
			SetError(3)
			Return 0
		Else
			$sBuff = DllStructGetData($lpszBuff, 1)
			$i = TCPSend($sock, $sBuff)
			If $i = 0 Then
				_WinAPI_CloseHandle($hFile)
				SetError(4)
				SetExtended($nBytes)
				Return 0
			Else
				$nBytes += $i
				$offset += $i
				$nFileSize -= $i
			EndIf
		EndIf
	WEnd
	_WinAPI_CloseHandle($hFile)
	TCPSend($sock, @CRLF&@CRLF)
	SetExtended($nBytes)
	Return $nBytes
EndFunc ;==> _TCPFileSend



































