; #FUNCTION# ====================================================================================================================
; Name...........: _ParseCSV
; Description ...: Reads a CSV-file
; Syntax.........: _ParseCSV($sFile, $sDelimiters=',', $sQuote='"', $iFormat=0)
; Parameters ....: $sFile       - File to read or string to parse
;                  $sDelimiters - [optional] Fieldseparators of CSV, mulitple are allowed (default: ,;)
;                  $sQuote      - [optional] Character to quote strings (default: ")
;                  $iFormat     - [optional] Encoding of the file (default: 0):
;                  |-1     - No file, plain data given
;                  |0 or 1 - automatic (ASCII)
;                  |2      - Unicode UTF16 Little Endian reading
;                  |3      - Unicode UTF16 Big Endian reading
;                  |4 or 5 - Unicode UTF8 reading
; Return values .: Success - 2D-Array with CSV data (0-based)
;                  Failure - 0, sets @error to:
;                  |1 - could not open file
;                  |2 - error on parsing data
;                  |3 - wrong format chosen
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _WriteCSV
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _ParseCSV($sFile, $sDelimiters=',;', $sQuote='"', $iFormat=0)
	Local Static $aEncoding[6] = [0, 0, 32, 64, 128, 256]
	If $iFormat < -1 Or $iFormat > 6 Then
		Return SetError(3,0,0)
	ElseIf $iFormat > -1 Then
		Local $hFile = FileOpen($sFile, $aEncoding[$iFormat]), $sLine, $aTemp, $aCSV[1], $iReserved, $iCount
		If @error Then Return SetError(1,@error,0)
		$sFile = FileRead($hFile)
		FileClose($hFile)
	EndIf
	If $sDelimiters = "" Or IsKeyword($sDelimiters) Then $sDelimiters = ',;'
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	$sQuote = StringLeft($sQuote, 1)
	Local $srDelimiters = StringRegExpReplace($sDelimiters, '[\\\^\-\[\]]', '\\\0')
	Local $srQuote = StringRegExpReplace($sQuote, '[\\\^\-\[\]]', '\\\0')
	Local $sPattern = StringReplace(StringReplace('(?m)(?:^|[,])\h*(["](?:[^"]|["]{2})*["]|[^,\r\n]*)(\v+)?',',', $srDelimiters, 0, 1),'"', $srQuote, 0, 1)
	Local $aREgex = StringRegExp($sFile, $sPattern, 3)
	If @error Then Return SetError(2,@error,0)
	$sFile = '' ; save memory
	Local $iBound = UBound($aREgex), $iIndex=0, $iSubBound = 1, $iSub = 0
	Local $aResult[$iBound][$iSubBound]
	For $i = 0 To $iBound-1
		Select
			Case StringLen($aREgex[$i])<3 And StringInStr(@CRLF, $aREgex[$i])
				$iIndex += 1
				$iSub = 0
				ContinueLoop
			Case StringLeft(StringStripWS($aREgex[$i], 1),1)=$sQuote
				$aREgex[$i] = StringStripWS($aREgex[$i], 3)
				$aResult[$iIndex][$iSub] = StringReplace(StringMid($aREgex[$i], 2, StringLen($aREgex[$i])-2), $sQuote&$sQuote, $sQuote, 0, 1)
			Case Else
				$aResult[$iIndex][$iSub] = $aREgex[$i]
		EndSelect
		$aREgex[$i]=0 ; save memory
		$iSub += 1
		If $iSub = $iSubBound Then
			$iSubBound += 1
			ReDim $aResult[$iBound][$iSubBound]
		EndIf
	Next
	If $iIndex = 0 Then $iIndex=1
	ReDim $aResult[$iIndex][$iSubBound]
	Return $aResult
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _WriteCSV
; Description ...: Writes a CSV-file
; Syntax.........: _WriteCSV($sFile, Const ByRef $aData, $sDelimiter, $sQuote, $iFormat=0)
; Parameters ....: $sFile      - Destination file
;                  $aData      - [Const ByRef] 0-based 2D-Array with data
;                  $sDelimiter - [optional] Fieldseparator (default: ,)
;                  $sQuote     - [optional] Quote character (default: ")
;                  $iFormat    - [optional] character encoding of file (default: 0)
;                  |0 or 1 - ASCII writing
;                  |2      - Unicode UTF16 Little Endian writing (with BOM)
;                  |3      - Unicode UTF16 Big Endian writing (with BOM)
;                  |4      - Unicode UTF8 writing (with BOM)
;                  |5      - Unicode UTF8 writing (without BOM)
; Return values .: Success - True
;                  Failure - 0, sets @error to:
;                  |1 - No valid 2D-Array
;                  |2 - Could not open file
; Author ........: ProgAndy
; Modified.......:
; Remarks .......:
; Related .......: _ParseCSV
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WriteCSV($sFile, Const ByRef $aData, $sDelimiter=',', $sQuote='"', $iFormat=0)
	Local Static $aEncoding[6] = [2, 2, 34, 66, 130, 258]
	If $sDelimiter = "" Or IsKeyword($sDelimiter) Then $sDelimiter = ','
	If $sQuote = "" Or IsKeyword($sQuote) Then $sQuote = '"'
	Local $iBound = UBound($aData, 1), $iSubBound = UBound($aData, 2)
	If Not $iSubBound Then Return SetError(2,0,0)
	Local $hFile = FileOpen($sFile, $aEncoding[$iFormat])
	If @error Then Return SetError(2,@error,0)
	For $i = 0 To $iBound-1
		For $j = 0 To $iSubBound-1
			FileWrite($hFile, $sQuote & StringReplace($aData[$i][$j], $sQuote, $sQuote&$sQuote, 0, 1) & $sQuote)
			If $j < $iSubBound-1 Then FileWrite($hFile, $sDelimiter)
		Next
		FileWrite($hFile, @CRLF)
	Next
	FileClose($hFile)
	Return True
EndFunc

; === EXAMPLE ===================================================
;~  #include<Array.au3>
;~  $aResult = _ParseCSV(@ScriptDir & '\test.csv', "\", '$', 4)
;~  _ArrayDisplay($aResult)
;~  _WriteCSV(@ScriptDir & '\written.csv', $aResult, ',', '"', 5)
; ===============================================================