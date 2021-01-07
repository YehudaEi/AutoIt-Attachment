; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Mike Ratzlaff <mike@ratzlaff.org>
;
; Script Function:
;	Base64 Experiments
;
; ----------------------------------------------------------------------------

; $Alpha64 will be a constant array containing the 64 digits of the base64 alphabet
Global Const $Alpha64 = Alpha64()

;Returns an array containing the base64 alphabet
Func Alpha64()
	Local $aTemp, $i
	$aTemp = StringSplit('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/','')
	For $i = 1 To $aTemp[0]
		$aTemp[$i-1] = $aTemp[$i]
	Next
	ReDim $aTemp[UBound($aTemp) - 1]
	Return $aTemp
EndFunc

;Takes a char (base64 encoded) and returns a numeric value (base64 decoded) in @extended.
;Returns 1 for success and 0 for failure
Func Alpha64ReverseChar($char)
	If $char = '=' Then
		SetExtended(-1)
		Return 1
	EndIf
	For $i = 0 To UBound($Alpha64, 1) - 1
		If $char == $Alpha64[$i] Then
			SetExtended($i)
			Return 1
		EndIf
	Next
	Return 0
EndFunc

;Given 3 binary values, this will return a 4-character base64 encoded string
Func Base64EncBin($i1, $i2=-1, $i3=-1)
	Local $iTemp, $sOut = ''
	Select
		Case $i2 < 0
			$sOut = $sOut + $Alpha64[BitShift($i1,2)]
			$sOut = $sOut + $Alpha64[BitShift(BitAND($i1,3),-4)]
			$sOut = $sOut + '=='
			$sOut = $Alpha64[BitShift($i1,2)] & $Alpha64[BitShift(BitAND($i1,3),-4)] & '=='
		Case $i3 < 0
			$sOut = $Alpha64[BitShift($i1,2)] & $Alpha64[BitShift(BitAND($i1,3),-4) + BitShift($i2,4)] & $Alpha64[BitShift(BitAND($i2,15),-2)] & '='
		Case Else
			$sOut = $Alpha64[BitShift($i1,2)] & $Alpha64[BitShift(BitAND($i1,3),-4) + BitShift($i2,4)] & $Alpha64[BitShift(BitAND($i2,15),-2) + BitShift($i3,6)] & $Alpha64[BitAND($i3,63)]
	EndSelect
	Return $sOut
EndFunc

;Reads in a binary file, writes a base64 encoded version of that file
;It is slow because it reads 1 character at a time from the file
;Output file maximum line length is 
Func Base64EncFile($sInFile, $sOutFile)
	Local $hInFile, $hOutFile, $c1, $c2, $c3, $i=0, $iFileLen, $done=0
	$iFileLen = FileGetSize($sInFile)
	$hInFile = FileOpen($sInFile, 0)
	If @error Then
		SetError(1)
		Return 'There was a problem opening the input file'
	Else
		$hOutFile = FileOpen($sOutFile, 2)
		If @error Then
			SetError(1)
			Return 'There was a problem opening the output file'
		EndIf
		ProgressOn('Base64EncFile','Encoding...','',-1,-1,16)
		While Not $Done
			$c1 = FileRead($hInFile, 1)
			If Not @error Then
				$c2 = FileRead($hInFile, 1)
				If @error Then
					$sOut = Base64EncBin(asc($c1))
					$done = 1
				Else
					$c3 = FileRead($hInFile, 1)
					If @error Then
						$sOut = Base64EncBin(asc($c1),asc($c2))
						$done = 1
					Else
						$sOut = Base64EncBin(asc($c1),asc($c2),asc($c3))
					EndIf
				EndIf
			Else
				$sOut = ''
				$done = 1
			EndIf
			FileWrite($hOutFile, $sOut)
			$i = $i + 1
			If Mod($i, 19) = 0 Then FileWrite($hOutFile, @CRLF)
			ProgressSet($i * 300 / $iFileLen)
		WEnd
		ProgressOff()
		FileClose($hOutFile)
	EndIf
	FileClose($hInFile)
	Return ''
EndFunc

;Takes a simple string as input, returns a base64 encoded version of that string
Func Base64EncStr($sInput)
	Local $sl = stringlen($sInput), $i, $d, $sOut = ''
	For $i = 1 to $sl Step 3
		$d=$sl-$i
		Select
			Case $d=0
				$sOut = $sOut & Base64EncBin(asc(stringmid($sInput, $i, 1)))
			Case $d=1
				$sOut = $sOut & Base64EncBin(asc(stringmid($sInput, $i, 1)), asc(stringmid($sInput, $i + 1, 1)))
			Case Else
				$sOut = $sOut & Base64EncBin(asc(stringmid($sInput, $i, 1)), asc(stringmid($sInput, $i + 1, 1)), asc(stringmid($sInput, $i + 2, 1)))
		EndSelect
		If Mod(stringlen($sOut),76)=0 Then $sOut = $sOut & @CRLF
	Next
	Return $sOut
EndFunc

;Given a base64 encoded file, writes a binary file
;This routine does not work properly, since AutoIt cannot write a binary zero to a file
Func Base64DecFile($sInFile, $sOutFile)
	Local $hInFile, $hOutFile, $c, $ai[4], $i=0, $eof=0, $perfect = 1, $fs = FileGetSize($sInFile), $fp
	$hInFile = FileOpen($sInFile, 0)
	If @error Then
		SetError(1)
		Return 'There was a problem opening the input file'
	Else
		$hOutFile = FileOpen($sOutFile, 2)
		If @error Then
			SetError(2)
			Return 'There was a problem opening the output file'
		Else
			ProgressOn('Base64DecFile','Decoding...','',-1,-1,16)
			;read the input file
			While Not $eof
				;read 4 characters
				$i=0
				While $i < 4
					$c = FileRead($hInFile, 1)
					While Not @error And Not Alpha64ReverseChar($c)
						$perfect = 0
						$c = FileRead($hInFile, 1)
					WEnd
					If @error Then
						$ai[$i] = -1
						$eof = 1
					Else
						$ai[$i] = @extended
					EndIf
					$i = $i + 1
				WEnd
				$fp = $fp + 4
				;decode and write 4 characters
				Select
					Case $ai[0]=-1 ;File ended on a perfect octet
					Case $ai[1]=-1 ;This should never happen
						$perfect = 0
					Case $ai[2]=-1 ;Only the first 2 bytes to be considered
						FileWrite($hOutFile, chr(BitShift($ai[0],-2) + BitShift($ai[1],4)))
					Case $ai[3]=-1 ;Only the first 3 bytes to be considered
						FileWrite($hOutFile, chr(BitShift($ai[0],-2) + BitShift($ai[1],4)))
						FileWrite($hOutFile, chr(BitAND(BitShift($ai[1],-4) + BitShift($ai[2],2), 255)))
					Case Else ;All 4 bytes to be considered
						FileWrite($hOutFile, chr(BitShift($ai[0],-2) + BitShift($ai[1],4)))
						FileWrite($hOutFile, chr(BitAND(BitShift($ai[1],-4) + BitShift($ai[2],2), 255)))
						FileWrite($hOutFile, chr(BitAND(BitShift($ai[2],-6) + $ai[3], 255)))
				EndSelect
				ProgressSet($fp * 100 / $fs)
			WEnd
			ProgressOff()
		FileClose($hOutFile)
		EndIf
	EndIf
	FileClose($hInFile)
EndFunc

$sFileName = InputBox('Base64 Encode','Enter a filename to encode','C:\Projects\AutoIt Scripts\Base64\test.zip')
$iTime=TimerInit()
$RetVal = Base64EncFile($sFileName, $sFileName & '.base64')
$RetVal = Base64DecFile($sFileName & '.base64', $sFileName & '.original')
MsgBox(0,'Finished','Time=' & Round(timerdiff($iTime)/1000,3) & ' seconds' & @CRLF & 'Error=' & @error & @CRLF & 'Return=' & $RetVal)
