;===========================================================================================
; Function List:
; _CSVGetRecords:		Retreives the contents of a csv file to a 1 Dim Array.
; _CSVGetColumn:		Retreives the column of a csv file to a 1 Dim Array.
; _CSVGetField:			Retreives the fields of a csv record to a 1 Dim Array.
; _CSVRecordToFields:	Converts a given Record (csv line) to a 1 Dim array of Fields
; _CSVStringToField:	Converts a text string to csv format to store in a single field.
; _CSVFieldToString:	Converts the content of a single csv field to a text string.
; Author:			IVAN PEREZ
;===========================================================================================


;===========================================================================================
; Function Name: 	_CSVGetRecords
; Description:		Retreives the contents of a csv file to a 1 Dim Array, where each element
;					represents a record. Each record field is delimited according to $pFlag.
; Syntax:           _CSVGetRecords($pFullPath [,$pEnclose] [,$pDelimiter] [,$pFlag])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pFlag= 0	-	Fields are ',' delimited. (Raw mode)
;					$pFlag= 1	-	Fields are delimited by Opt('GUIDataSeparatorChar').
;					$pFlag= 2	-	Fields are delimited by '|'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array, with delimitor set by $pFlag.
;									$lRecords[0] contains the number of records.
;					On Failure	-	$lRecords[0] = 0 and sets @error = 1 if open or read error
;								-	$lRecords[0] = 0 and sets @error = 2 if no records found.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVGetRecords($pFullPath, $pDelimiter = -1, $pEnclose = -1, $pFlag = 0)
	Dim $lRecords[1] = [0]
	Local $lCVSFileHandle, $lConvertDelimiter, $lFields
	If $pFlag = 1 Then
		$lConvertDelimiter = Opt('GUIDataSeparatorChar')
	ElseIf $pFlag = 2 Then
		$lConvertDelimiter = '|'
	EndIf
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	$lCVSFileHandle = FileOpen($pFullPath, 0)
	If $lCVSFileHandle = -1 Then ; FileOpen error
		SetError(1)
		$lRecords[0] = 0
		Return $lRecords
	EndIf
	; extract redords
	While 1
		$lCurrentLine = FileReadLine($lCVSFileHandle)
		If @error = -1 Then ; end of file reached thus exit the loop
			ExitLoop
		ElseIf @error = 1 Then ; Reading error, file open errors subsumed in FileOpen() above.
			SetError(2)
			$lRecords[0] = 0
			Return $lRecords
		EndIf
		ReDim $lRecords[UBound($lRecords) + 1]
		$lRecords[UBound($lRecords) - 1] = $lCurrentLine
	WEnd
	; set the record count
	$lRecords[0] = UBound($lRecords) - 1
	; Convert delimiter
	If $pFlag Then
		For $i = 1 To $lRecords[0] Step 1 ; iterate the records
			; Retreive Cells array from Record
			$lFields = _CSVRecordToFields($lRecords[$i], $pDelimiter, $pEnclose)
			; empty current record and fill it with new data separated by new delimiter
			$lRecords[$i] = ''
			For $j = 1 To $lFields[0] Step 1
				If $j < $lFields[0] Then
					$lRecords[$i] &= $lFields[$j] & $lConvertDelimiter
				ElseIf $j = $lFields[0] Then
					$lRecords[$i] &= $lFields[$j]
				EndIf
			Next
		Next
	EndIf
	Return $lRecords
EndFunc   ;==>_CSVGetRecords

;===========================================================================================
; Function Name: 	_CSVGetColumn
; Description:		Retreives the column of a csv file to a 1 Dim Array.
; Syntax:           _CSVGetColumn($pFullPath, $pColumnNumber [,$pDelimiter] [,$pEnclose] [,$pFlag])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pFlag= 0	-	Fields are returned in raw csv format.
;					$pFlag= 1	-	Fields are returned in raw text format.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	@error = 1 if $pColumnNumber exceeds columns in file
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVGetColumn($pFullPath, $pColumnNumber, $pDelimiter = -1, $pEnclose = -1, $pFlag = 0)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Local $lRecords = _CSVGetRecords($pFullPath, $pDelimiter, $pEnclose)
	Dim $lColumn[$lRecords[0] + 1] ; $lRecords[0]
	Dim $lCurrentRecord
	For $i = 1 To $lRecords[0] Step 1
		$lCurrentRecord = _CSVRecordToFields($lRecords[$i], $pDelimiter, $pEnclose, $pFlag)
		If $pColumnNumber <= $lCurrentRecord[0] Then
			$lColumn[$i] = $lCurrentRecord[$pColumnNumber]
		Else
			SetError(1)
		EndIf
	Next
	$lColumn[0] = UBound($lColumn) - 1
	Return $lColumn
EndFunc   ;==>_CSVGetColumn

;===========================================================================================
; Function Name: 	_CSVGetField
; Description:		Retreives the fields of a csv record to a 1 Dim Array.
; Syntax:           _CSVGetField(pFullPath, $pColumnNumber, $pRowNumber [,$pEnclose] [,$pDelimiter] [,$pFlag])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pRowNumber	-	The row number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pFlag= 0	-	Fields are returned in raw csv format.
;					$pFlag= 1	-	Fields are returned in raw text format.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	@error = 1 if $pColumnNumber exceeds columns in file
;								-	@error = 2 if $pRowNumber exceeds rows in file
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVGetField($pFullPath, $pColumnNumber, $pRowNumber, $pDelimiter = -1, $pEnclose = -1, $pFlag = 0)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Local $lField = -1
	Dim $lColumn
	$lColumn = _CSVGetColumn($pFullPath, $pColumnNumber, $pDelimiter, $pEnclose, $pFlag)
	If @error = 1 Then
		SetError(1)
	Else
		If $pRowNumber <= $lColumn[0] Then
			$lField = $lColumn[$pRowNumber]
		Else
			SetError(2)
		EndIf
	EndIf
	Return $lField
EndFunc   ;==>_CSVGetField

;===========================================================================================
; Function Name: 	_CSVRecordToFields
; Description:		Converts a given Record (csv line) to a 1 Dim array of Fields
; 					Fields are written in text or raw csv format according to $pFlag.
; Syntax:           _CSVRecordToFields($pRecord [,$pEnclose] [,$pDelimiter] [,$pFlag])
; Parameter(s):     $pRecord	-	Raw record (csv line).
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pFlag= 0	-	Fields are returned in raw csv format.
;					$pFlag= 1	-	Fields are returned in raw text format.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	Errors not defined yet
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordToFields($pRecord, $pDelimiter = -1, $pEnclose = -1, $pFlag = 0)
	Local $lRecordLen = StringLen($pRecord), $lConsecutiveQuotes = ''
	Dim $lFields[1] = [0], $lRecordArray[1] = [$lRecordLen]
	Local $lIsNewField = True, $lIsEnclosed = False, $lEndEnclose = False
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	; populate record array
	For $i = 1 To $lRecordLen Step 1
		ReDim $lRecordArray[UBound($lRecordArray) + 1]
		$lRecordArray[UBound($lRecordArray) - 1] = StringMid($pRecord, $i, 1)
	Next
	; populate the fields array
	For $i = 1 To $lRecordLen Step 1
		; skip to check next field
		If $lEndEnclose And $lRecordArray[$i] = $pDelimiter Then
			$lEndEnclose = False
			ContinueLoop
		EndIf
		
		; create new field
		If $lIsNewField Then
			ReDim $lFields[UBound($lFields) + 1]
			$lFields[0] = UBound($lFields) - 1
			$lIsNewField = False
			If $lRecordArray[$i] = $pEnclose Then
				$lIsEnclosed = True
			Else
				$lIsEnclosed = False
			EndIf
		EndIf
		; not enclosed field
		If Not $lIsEnclosed Then
			$lConsecutiveQuotes = ''
			If $lRecordArray[$i] = $pDelimiter Then ; not enclosed empty field
				$lIsNewField = True
				If $i < $lRecordLen Then
					ContinueLoop
				Else
					ReDim $lFields[UBound($lFields) + 1]
					$lFields[0] = UBound($lFields) - 1
				EndIf
			ElseIf $lRecordArray[$i] <> $pDelimiter Then ; concatenate not enclosed field content
				$lFields[UBound($lFields) - 1] &= $lRecordArray[$i]
				$lIsNewField = False
			EndIf
		EndIf
		; enclosed field
		If $lIsEnclosed Then
			; check escaped quote
			If $lRecordArray[$i] = $pEnclose Then
				$lConsecutiveQuotes &= $lRecordArray[$i] ; concatenate $pEnclose chars
				If $i = $lRecordLen Then ; check end of record
					If StringLen($lFields[UBound($lFields) - 1]) = 0 Then ; case field contains only quote chars
						$lFields[UBound($lFields) - 1] = $lConsecutiveQuotes
					Else ; case field contains chars other than quote
						$lFields[UBound($lFields) - 1] &= $lRecordArray[$i]
					EndIf
					ExitLoop ; (enclosed fields can only terminate in enclose chars)
					; check end of field
				ElseIf $i < $lRecordLen Then
					; end of field first order necessary condition: current char must be an enclose char
					; end of field second order necessary condition: next char is a delimiter
					If $lRecordArray[$i + 1] = $pDelimiter Then
						If StringReplace($lFields[UBound($lFields) - 1], $pEnclose, '', -1) = '' Then ; case field contains only quote chars
							If Mod(StringLen($lConsecutiveQuotes), 2) = 0 Then ; end of field ony if consecutive quotes is even
								$lEndEnclose = True
							EndIf
						ElseIf StringReplace($lFields[UBound($lFields) - 1], $pEnclose, '', -1) <> '' Then ; case field already contains chars
							If Mod(StringLen($lConsecutiveQuotes), 2) <> 0 Then ; end of field ony if consecutive quotes is odd
								$lEndEnclose = True
							EndIf
						EndIf
						; reset variables
						$lFields[UBound($lFields) - 1] &= $lRecordArray[$i]
						$lConsecutiveQuotes = ''
						If $lEndEnclose Then
							$lIsNewField = True
						EndIf
					Else ; the current char is an enclose and the next char is not a delimiter
						If StringLen($lFields[UBound($lFields) - 1]) = 0 Then
							$lFields[UBound($lFields) - 1] = $lConsecutiveQuotes
						ElseIf StringLen($lFields[UBound($lFields) - 1]) > 0 Then
							$lFields[UBound($lFields) - 1] &= $lRecordArray[$i];$lConsecutiveQuotes
						EndIf
					EndIf
				EndIf
			Else
				$lConsecutiveQuotes = '' ; reset $lConsecutiveQuotes
				$lFields[UBound($lFields) - 1] &= $lRecordArray[$i]
			EndIf
		EndIf
	Next
	$lFields[0] = UBound($lFields) - 1
	; convert to text if $pFlag=1
	If $pFlag = 1 Then
		For $i = 1 To $lFields[0] Step 1
			$lFields[$i] = _CSVFieldToString($lFields[$i], $pDelimiter, $pEnclose)
		Next
	EndIf

	Return $lFields
EndFunc   ;==>_CSVRecordToFields

;===========================================================================================
; Function Name: 	_CSVStringToField
; Description:		Converts a text string to csv format to store in a single field.
; Syntax:           _CSVStringToField($pStr [,$pEnclose] [,$pDelimiter])
; Parameter(s):     $pStr		-	Text string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	Errors not defined yet
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVStringToField($pStr, $pDelimiter = -1, $pEnclose = -1)
	Local $lField
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If Not StringInStr($pStr, $pDelimiter) Then
		$lField = $pStr ; no delimiter in field
	Else
		If Not StringInStr($pStr, $pEnclose) Then
			$lField = $pEnclose & $pStr & $pEnclose ; delimiter in field, but no escaped enclose
		Else
			$lField = $pEnclose & StringReplace($pStr, $pEnclose, $pEnclose & $pEnclose) & $pEnclose ; delimiter in field and escaped enclose
		EndIf
	EndIf
	Return $lField
EndFunc   ;==>_CSVStringToField

;===========================================================================================
; Function Name: 	_CSVFieldToString
; Description:		Converts the content of a single csv field to a text string.
; Syntax:           _CSVFieldToString($pRawField [,$pEnclose] [,$pDelimiter])
; Parameter(s):     $pRawField	-	Raw csv string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	Errors not defined yet
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFieldToString($pRawField, $pDelimiter, $pEnclose)
	Local $lStr = $pRawField
	; strip StartEnclose and EndEnclose
	If StringLeft($lStr, 1) = $pEnclose And StringRight($lStr, 1) = $pEnclose Then
		$lStr = StringRight($lStr, StringLen($lStr) - 1)
		$lStr = StringLeft($lStr, StringLen($lStr) - 1)
		$lStr = StringReplace($lStr, $pEnclose & $pEnclose, $pEnclose)
	EndIf
	Return $lStr
EndFunc   ;==>_CSVFieldToString

;~ Func Arr2DimDisplay($Records, $tit)
;~ 	Local $Str
;~ 	For $i = 0 To UBound($Records) - 1 Step 1
;~ 		$Str &= '[' & $i & '][0] = ' & $Records[$i][0] & @CRLF & '[' & $i & '][1] = ' & $Records[$i][1] & @CRLF
;~ 	Next
;~ 	MsgBox(0, $tit, $Str)
;~ EndFunc   ;==>Arr2DimDisplay