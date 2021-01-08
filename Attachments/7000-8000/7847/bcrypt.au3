#include-once
;===============================================================================
;
; Bcrypt.au3 (alpha)
; 	for: Bcrypt 1.1
;
;	Bcrypt uses Paul Kocher's implementation of the blowfish encryption algorithm published by Bruce Schneier in 1993.
;	Project location and DLL files at:  http://bcrypt.sourceforge.net/
;	To run the program, make sure the bcrypt.exe and zlib.dll files are in the same directory.
;		$sFileList: Space delimited path list of files.
;		$sPassPhrase: must be between 8 and 56 characters and are hashed internally to a 448 bit key.
;	Dll Usage is: 	bcrypt.exe -[orc][-sN] file1 file2..
;		-o Write output to standard out when de-crypting. (Implies -r).
;		-r Do NOT remove input files after processing
;		-c Do NOT compress files before encryption
;		-sN How many times to overwrite input files with random data (default=3)
;	ATTENTION: bcrypt deletes files after decryption when no extension available. (i.e. 'somefile.bfe')
;
;	TODO:
;		CHECK:		Maximum stream output size!!
;		Improve:	Error handling - use of component stdout error messages
;===============================================================================
Func _Bcrypt($sFileList, $sPassPhrase, $iToFile = 1, $iCompress = 1, $iRemove = 1, $iOverwrite = 3)
	If Not FileExists(@ScriptDir & "\bcrypt.exe") Or Not FileExists(@ScriptDir & "\zlib.dll") Then
		SetError(1)
		Return ""
	ElseIf StringLen($sPassPhrase) < 8 Or StringLen($sPassPhrase) > 56 Then
		SetError(2)
		Return ""
	EndIf
	Local $sParams = ""
	If $iToFile Then	;; Encrypt/Decrypt to File
		If Not $iCompress And Not $iRemove Then
			$sParams = " -rc"
		Else
			If Not $iCompress Then $sParams = " -c"
			If Not $iRemove Then
				$sParams = " -r"
			Else
				If IsNumber($iOverwrite) And $iOverwrite <> 3 Then $sParams &= " -s" & $iOverwrite
			EndIf
		EndIf
	Else				;; Decrypt to STDOUT
		$sParams = " -o"
	EndIf
	Local $sCMD = @ComSpec & " /C " & '"' & @ScriptDir & "\bcrypt.exe" & '"' & $sParams & ' ' & $sFileList & ''
	Local $hPID = Run($sCMD, @ScriptDir, @SW_HIDE, 1 + 2 + 4)
	StdinWrite($hPID, $sPassPhrase & @CRLF & $sPassPhrase & @CRLF)
	Local $m_data = ""
	While @error = 0
		$m_data = $m_data & StdoutRead($hPID, -1)
	WEnd
	If ProcessExists($hPID) Then ProcessClose($hPID)
	If Not $iToFile Then
		Return $m_data
	Else
		Return 1
	EndIf
EndFunc   ;==>_Bcrypt
