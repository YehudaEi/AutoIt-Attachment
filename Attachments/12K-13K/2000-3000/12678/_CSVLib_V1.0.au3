#include-once
#include <File.au3>
#include <Array.au3>
;~ FUNCTION LIST
;===========================================================================================
; Function List:
; _CSVReadRecords:		Retreives the contents of a csv file to a 1 Dim Array.
; _CSVGetColumn:		Retreives the column of a csv file previously read with
;						_CSVReadRecords to a 1 Dim Array.
; _CSVRecordToFields:	Converts a given Record (csv line) to a 1 Dim Fields array.
; _CSVGetField:			Returns the string in a field from a csv file previously read with
;						_CSVReadRecords to a 1 Dim Array, given a column and row number.
; _CSVStringToField:	Converts a text string to csv format to store in a single field.
; _CSVFieldToString:	Converts the content of a single csv field to a text string.
; _CSVConvertDelimiter:	Converts the delimiter chars in a csv formatted string or array.
; _CSVConvertEnclose:	Converts the enclose chars in a csv formatted string or array.
; _CSVFieldsToRecord:	Converts an array to a string in csv format (with delimiters and
;						enclose chars).
; _CSVFileAppendRecord	Appends a string record returned by _CSVFieldsToRecord at the end of
;						a csv file.
; _CSVFileAppendColumn	Appends a field at the end of each record in a csv file and returns
; 						a 1Dim array with all the records in the file.
; _CSVFileInsertRecord:	Inserts a record in a file and returns a 1 Dim array with all the records
; 						in the file.
; _CSVFileInsertColumn:	Inserts a column in a csv file and returns a 1 Dim array with all the records
; 						in the file
; _CSVFileUpdateRecord:	Updates the field values in a csv file record. Returns a 1Dim array with
;						updated records.
; _CSVFileUpdateColumn:	Update a column in a csv file and returns a 1 Dim array with all the
; 						records in the file (including the update).
; _CSVFileDeleteRecord:	Delete a record in a file.
; _CSVFileDeleteColumn:	Delete a column in a csv file and returns a 1 Dim array with all the records
; 						in the file (including the update).
; Author:			IVAN PEREZ
;===========================================================================================

;;; 2DO
; RANGE FUNCTIONS
;;;

;~ CHANGE LOG:
;===========================================================================================
; Date:					26/12/06
; Renamed:				_CSVGetRecords 			is now called _CSVReadRecords. The name change
;												adequately reflects the fact that the function
;												merely reads the content to an array and no
;												record processing has taken place.
; Changed:				_CSVReadRecords 		(old _CSVGetRecords) no longer requires passing
;												delimitor and enclose parameters, as this is now
;												redundant.
; Changed:				_CSVReadRecords 		(old _CSVGetRecords) no longer admits flags to
;												change delimiters. All records are returned in
;												raw csv format. Reason: The array returned by
;												the function can now be used by other functions
;												to read columns, fields, and so on, in order to
;												avoid reading from the file multiple times.
;												To change the delimitors now you have to explicitly
;												use the function _CSVConvertDelimiter.
; Date:					26/12/06
; Changed:				_CSVGetColumn. 			Passing the full path parameter is obsolete.
; 												Now you must pass the array returned by
; 												_CSVReadRecords. This avoids having to read
;												from the file on multiple occasions, rendering
;												your script execution faster, with the shortcoming
;												of having to add a line of code. However, it
;												also provides more control over error tracking.
; Changed:				_CSVGetColumn 			no longer admits a delimiter conversion flag.
; 												This must now be done explicitly by means of
; 												_CSVConvertDelimiter.
; Changed:				_CSVGetColumn 			improved error checking/tracking:
;												@error = 1 if the length of the delimiter or
;												enclose char>1. This can occur if one of the
;												parameters passed is a composite char, such
;												as @crlf.
;												@error = 2 if $pRecords is not an array.
;												$lColumn[0]=0 is returned.
;												@error = 3 if $pRecords has the wrong format.
;												$lColumn[0] is not an interger.
;												$lColumn[0]=0 is returned.
;												@error = 4 if $pRecords contains a single
;												element. $lColumn[0]=0 is returned.
;												Typically because $pRecords contains no records.
;												@error = 5 if the column number you wish to
;												retreive exceeds the amount of columns in a
;												csv file. Usually the file's amount of columns
;												is set to the number of columns found in the
;												record with most columns.
;												This means that records with empty columns should
;												have been filled with empty values, so the error
;												either occurred because the file was badly
;												formatted or because the column parameter is too high.
;												If @error = 4 occurs, the function returns whatever
;												was retreived up to the point when the inconsistency
;												occurred.
;												@error = 6 if an error occurred while converting
;												one or more records to fields by means of
;												_CSVRecordToFields. The error in _CSVRecordToFields
;												can be tracked using @extended.
; Date:					26/12/06
; Changed:				_CSVRecordToFields. 	In hand with the conversion functions (string,
;												field, delimiter, enclose) the flag parameter
;												has been removed. The conversion functions must
;												now be used explicitly. This avoids confusion
;												between what is converted (csv to text, or vice
;												versa, or changing delimiter or enclose chars).
;												Field contents are returned in raw csv format.
;												If a single column record is passed with an
;												empty field, the empty field array is returned
;												immediately because no processsing is required.
;												This increases execution speed.
;												@error = 1 if the passed record could not be
;												converted to an array.
;												$lFields[0] = 0 is returned.
; Date:					26/12/06
; Changed:				_CSVGetField. 			In hand with the conversion functions (string,
;												field, delimiter, enclose) the flag parameter
;												has been removed. The conversion functions must
;												now be used explicitly. This avoids confusion
;												between what is converted (csv to text, or vice
;												versa, or changing delimiter or enclose chars).
;												Field contents are returned in raw csv format.
; Date:					26/12/06
; Changed:				_CSVFieldToString 		now allows default delimiter='"' and enclose=','.
; Date:					26/12/06
; Added:				_CSVConvertDelimiter. 	Converts the delimiter chars in a csv formatted
;												string or array.
; Date:					26/12/06
; Added:				_CSVConvertEnclose. 	Converts the enclose chars in a csv formatted
;												string or array.
; Date:					27/12/06
; Added:				_CSVFieldsToRecord 		Converts an array to a string in csv format
;												(with delimiters andenclose chars).
; Date:					27/12/06
; Added:				_CSVFileAppendRecord	Appends a record at the end of a csv file
; Date:					28/12/06
; Added:				_CSVFileAppendColumn	Appends a field at the end of each record in a
;												csv file and returns a 1Dim array with all the
;												records in the file.
; Date:					28/12/06
; Added:				_CSVFileInsertRecord	Inserts a record in a file and returns a 1 Dim
; 						 						array with all the records in the file.
; Date:					28/12/06
; Added:				_CSVFileInsertRecord	Inserts a column in a csv file and returns a
; 												1 Dim array with all the recordsin the file
; Date:					28/12/06
; Added:				_CSVFileUpdateRecord	Updates the field values in a csv file record.
;												Returns a 1Dim array with updated records.
; Date:					28/12/06
; Added:				_CSVFileUpdateColumn	Update a column in a csv file and returns a 1 Dim
; 												array with all the records in the file
; 												(including the update).
; Date:					28/12/06
; Added:				_CSVFileDeleteRecord	Delete a record in a file.
; Date:					28/12/06
; Added:				_CSVFileDeleteColumn	Delete a column in a csv file and returns a
; 												1 Dim array with all the records in the file
; 												(including the update).
;===========================================================================================

;===========================================================================================
; Function Name: 	_CSVReadRecords
; Description:		Retreives the contents of a csv file to a 1 Dim Array, where each element
;					represents a record.
; Syntax:           _CSVGetRecords($pFullPath)
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array in raw csv format
;									$lRecords[0] contains the number of records.
;					On Failure	-	@error = 1 if file doesn't exist
;								-	@error = 2 if open or read error, returns $lRecords[0] = 0
;								-	@error = 3 if no records found, returns $lRecords[0] = 0
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVReadRecords($pFullPath)
	Dim $lRecords[1] = [0]
	Local $lCVSFileHandle
	If Not FileExists($pFullPath) Then
		SetError(1)
		Return 0
	EndIf
	$lCVSFileHandle = FileOpen($pFullPath, 0)
	If $lCVSFileHandle = -1 Then ; FileOpen error
		SetError(2)
		$lRecords[0] = 0
		Return $lRecords
	EndIf
	; extract redords
	While 1
		$lCurrentLine = FileReadLine($lCVSFileHandle)
		If @error = -1 Then ; end of file reached thus exit the loop
			ExitLoop
		ElseIf @error = 1 Then ; Reading error, file open errors subsumed in FileOpen() above.
			SetError(3)
			$lRecords[0] = 0
			Return $lRecords
		EndIf
		ReDim $lRecords[UBound($lRecords) + 1]
		$lRecords[UBound($lRecords) - 1] = $lCurrentLine
	WEnd
	; set the record count
	$lRecords[0] = UBound($lRecords) - 1
	Return $lRecords
EndFunc   ;==>_CSVReadRecords

;===========================================================================================
; Function Name: 	_CSVGetColumn
; Description:		Retreives the column of a csv file to a 1 Dim Array.
; Syntax:           _CSVGetColumn($pFullPath, $pColumnNumber  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lColumn array in raw csv format
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									$lColumn[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error = 2 if $pRecords is not an array. $lColumn[0]=0
;									is returned.
;								-	@error = 3 if $pRecords has the wrong format. $lColumn[0]
;									is not an interger. $lColumn[0]=0 is returned.
;								-	@error = 4 if $pRecords contains a single element.
;									$lColumn[0]=0 is returned. Typically because $pRecords
;									contains no records.
;								-	@error = 5 if the column number you wish to retreive exceeds
;									the amount of columns in a csv file. Usually the file's
;									amount of columns is set to the number of columns found in
;									the record with most columns.
;									This means that records with empty columns should have been
;									filled with empty values, so the error either occurred because
;									the file was badly formatted or because the column parameter
;									is too high. If @error = 4 occurs, the function returns whatever
;									was retreived up to the point when the inconsistency occurred.
;								-	@error = 6 if an error occurred while converting one or more
;									records to fields by means of _CSVRecordToFields. The error
;									in _CSVRecordToFields can be tracked using @extended. I left
;									this rather open so that when I complete error tracking on
;									_CSVRecordToFields, the error can be tracked easily without
;									further modification required.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVGetColumn($pRecords, $pColumnNumber, $pDelimiter = -1, $pEnclose = -1)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Dim $lColumn[1] = [0]
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lColumn
	EndIf
	If Not IsArray($pRecords) Then
		SetError(2)
		Return $lColumn
	EndIf
	If Not IsInt($pRecords[0]) Then
		SetError(3)
		Return $lColumn
	ElseIf $pRecords[0] < 1 Then
		SetError(4)
		Return $lColumn
	EndIf
	ReDim $lColumn[UBound($pRecords) ]
	Dim $lCurrentRecord
	For $i = 1 To UBound($pRecords) - 1 Step 1
		$lCurrentRecord = _CSVRecordToFields($pRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(6, @error)
			ExitLoop
		EndIf
		If $pColumnNumber <= $lCurrentRecord[0] Then
			$lColumn[$i] = $lCurrentRecord[$pColumnNumber]
		Else
			SetError(5)
			ExitLoop
		EndIf
	Next
	$lColumn[0] = UBound($lColumn) - 1
	Return $lColumn
EndFunc   ;==>_CSVGetColumn

;===========================================================================================
; Function Name: 	_CSVRecordToFields
; Description:		Converts a given Record (single csv line) to a 1 Dim Fields array.
;					Fields are filled in raw csv format.
; Syntax:           _CSVRecordToFields($pRecord  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRecord	-	Raw record (csv line).
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lFields array
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									$lFields[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error = 2 if the passed record could not be converted
;									to an array.
;									I've spent hours trying to think of errors to track
;									and can't come up with anything else. If you do, please
;									let me know in the forums.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordToFields($pRecord, $pDelimiter = -1, $pEnclose = -1)
	Local $lRecordLen = StringLen($pRecord), $lConsecutiveEnclose = ''
	Dim $lFields[1] = [0], $lRecordStrToArray[1] = [$lRecordLen]
	Local $lIsNewField = True, $lIsEnclosed = False, $lEndEnclose = False
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lFields
	EndIf
	; check empty record (case 1 col csv file with empty current record.)
	If $lRecordLen = 0 Then
		ReDim $lFields[UBound($lFields) + 1]
		$lFields[0] = UBound($lFields) - 1
		Return $lFields
	EndIf
	; convert the given record to an array
	For $i = 1 To $lRecordLen Step 1
		ReDim $lRecordStrToArray[UBound($lRecordStrToArray) + 1]
		$lRecordStrToArray[UBound($lRecordStrToArray) - 1] = StringMid($pRecord, $i, 1)
		If StringLen($lRecordStrToArray[UBound($lRecordStrToArray) - 1]) > 1 Then
			SetError(2)
			Return $lFields ; no assignment has yet taken place so $lFields[0] = 0
		EndIf
	Next
	; populate the fields array
	For $i = 1 To $lRecordLen Step 1
		; skip to check next field because the current char is a field delimiter.
		If $lEndEnclose And $lRecordStrToArray[$i] = $pDelimiter Then
			$lEndEnclose = False
			ContinueLoop
		EndIf
		; create new field
		If $lIsNewField Then
			ReDim $lFields[UBound($lFields) + 1]
			$lFields[0] = UBound($lFields) - 1
			$lIsNewField = False
			; identify if the current field is enclosed or not
			If $lRecordStrToArray[$i] = $pEnclose Then
				$lIsEnclosed = True
			Else
				$lIsEnclosed = False
			EndIf
		EndIf
		; not enclosed field
		If Not $lIsEnclosed Then
			$lConsecutiveEnclose = ''
			If $lRecordStrToArray[$i] = $pDelimiter Then ; not enclosed empty field
				$lIsNewField = True ; set condition for new field
				If $i < $lRecordLen Then
					ContinueLoop
				Else
					ReDim $lFields[UBound($lFields) + 1]
					$lFields[0] = UBound($lFields) - 1
				EndIf
			ElseIf $lRecordStrToArray[$i] <> $pDelimiter Then ; concatenate not enclosed field content
				$lFields[UBound($lFields) - 1] &= $lRecordStrToArray[$i]
				$lIsNewField = False ; continue concatenating content field until a delimiter is found
			EndIf
		EndIf
		; enclosed field
		If $lIsEnclosed Then
			; check escaped quote
			If $lRecordStrToArray[$i] = $pEnclose Then
				$lConsecutiveEnclose &= $lRecordStrToArray[$i] ; concatenate $pEnclose chars
				If $i = $lRecordLen Then ; check end of record
					If StringLen($lFields[UBound($lFields) - 1]) = 0 Then ; case field contains only quote chars
						$lFields[UBound($lFields) - 1] = $lConsecutiveEnclose
					Else ; case field contains chars other than quote
						$lFields[UBound($lFields) - 1] &= $lRecordStrToArray[$i]
					EndIf
					ExitLoop ; (enclosed fields can only terminate in enclose chars)
					; check end of field
				ElseIf $i < $lRecordLen Then
					; end of field first order necessary condition: current char must be an enclose char
					; end of field second order necessary condition: next char is a delimiter
					If $lRecordStrToArray[$i + 1] = $pDelimiter Then
						; case field contains only quote chars
						If StringReplace($lFields[UBound($lFields) - 1], $pEnclose, '', -1) = '' Then
							; end of field ony if length of consecutive enclose is even
							; (otherwise consecutive enclose contains only escaped enclose or escaped delimiters)
							If Mod(StringLen($lConsecutiveEnclose), 2) = 0 Then ; end of field ony if consecutive quotes is even
								$lEndEnclose = True
							EndIf
							; case field already contains non enclose chars
						ElseIf StringReplace($lFields[UBound($lFields) - 1], $pEnclose, '', -1) <> '' Then
							; end of field ony if length of consecutive enclose is odd
							; (otherwise consecutive enclose contains only escaped enclose or escaped delimiters)
							If Mod(StringLen($lConsecutiveEnclose), 2) <> 0 Then
								$lEndEnclose = True
							EndIf
						EndIf
						; reset variables
						$lFields[UBound($lFields) - 1] &= $lRecordStrToArray[$i]
						$lConsecutiveEnclose = ''
						If $lEndEnclose Then
							$lIsNewField = True
						EndIf
						; the current char is an enclose and the next char is not a delimiter, so the field is not ended, regardless.
					Else
						If StringLen($lFields[UBound($lFields) - 1]) = 0 Then ; assign $lConsecutiveEnclose to current field
							$lFields[UBound($lFields) - 1] = $lConsecutiveEnclose
						ElseIf StringLen($lFields[UBound($lFields) - 1]) > 0 Then ; concatenate current char
							$lFields[UBound($lFields) - 1] &= $lRecordStrToArray[$i]
						EndIf
					EndIf
				EndIf
			Else
				$lConsecutiveEnclose = '' ; reset $lConsecutiveEnclose
				; continue concatenating field content until a non escaped delimiter is found
				$lFields[UBound($lFields) - 1] &= $lRecordStrToArray[$i]
			EndIf
		EndIf
	Next
	$lFields[0] = UBound($lFields) - 1
	Return $lFields
EndFunc   ;==>_CSVRecordToFields

;===========================================================================================
; Function Name: 	_CSVGetField
; Description:		Returns the string in a field from a given column and row.
; Syntax:           _CSVGetField(pFullPath, $pColumnNumber, $pRowNumber  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRecords	-	Records read with _CSVReadRecords($pFullPath)
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pRowNumber	-	The row number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	String $lField contents
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									-1 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error = 2 if $pColumnNumber exceeds columns in file
;								-	@error = 3 if $pRowNumber exceeds rows in file
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVGetField($pRecords, $pColumnNumber, $pRowNumber, $pDelimiter = -1, $pEnclose = -1)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Local $lField = -1
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lField
	EndIf
	Dim $lColumn
	$lColumn = _CSVGetColumn($pRecords, $pColumnNumber, $pDelimiter, $pEnclose)
	If @error = 1 Then
		SetError(2)
	Else
		If $pRowNumber <= $lColumn[0] Then
			$lField = $lColumn[$pRowNumber]
		Else
			SetError(3)
		EndIf
	EndIf
	Return $lField
EndFunc   ;==>_CSVGetField

;===========================================================================================
; Function Name: 	_CSVStringToField
; Description:		Converts a text string to csv format to store in a single field.
; Syntax:           _CSVStringToField($pStr  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pStr		-	Text string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	String $lField content
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVStringToField($pStr, $pDelimiter = -1, $pEnclose = -1)
	Local $lField
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
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
; Syntax:           _CSVFieldToString($pRawField  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRawField	-	Converted Text string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	@error = 1 if the length of $pEnclose is >1.
;									0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFieldToString($pRawField, $pEnclose = -1)
	Local $lStr = $pRawField
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pEnclose) = 0 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	; strip StartEnclose and EndEnclose
	If StringLeft($lStr, 1) = $pEnclose And StringRight($lStr, 1) = $pEnclose Then
		$lStr = StringRight($lStr, StringLen($lStr) - 1)
		$lStr = StringLeft($lStr, StringLen($lStr) - 1)
		$lStr = StringReplace($lStr, $pEnclose & $pEnclose, $pEnclose)
	EndIf
	Return $lStr
EndFunc   ;==>_CSVFieldToString

;===========================================================================================
; Function Name: 	_CSVConvertDelimiter
; Description:		Converts the delimiter char of a multiple or single records,
;					single column or single field.
; Syntax:           _CSVConvertDelimiter($pConvert [,$pDelimiter] [,$pEnclose] [,$pNewDelimiter])
; Parameter(s):     $pRawField	-	Raw csv string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pNewDelimiter-	Use -1 for default Opt('GUIDataSeparatorChar') char.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns either array or string according to the type
;									of $pConvert.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose or
;									$pNewDelimiter is >1.
;									$lConverted[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, if unable to convert $pConvert to field(s).
;									Check @extended to obtain @errors inherited from
;									_CSVRecordToFields. If an error occurs, then the
;									function returns whatever was stored in $lConverted
;									up until the error occurred.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertDelimiter($pConvert, $pDelimiter = -1, $pEnclose = -1, $pNewDelimiter = -1)
	Dim $lRecord[1] = [0], $lFields[1] = [0], $lConverted[1] = [0]
	Local $lField
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pNewDelimiter = -1 Then $pNewDelimiter = Opt('GUIDataSeparatorChar')
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pNewDelimiter) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Or StringLen($pNewDelimiter) > 1 Then
		SetError(1)
		Return $lConverted
	EndIf
	If IsArray($pConvert) Then
		For $i = 1 To UBound($pConvert) - 1 Step 1
			$lRecord = _CSVRecordToFields($pConvert[$i], $pDelimiter, $pEnclose)
			If @error Then
				SetError(2, @error)
				Return $lConverted
			EndIf
			ReDim $lConverted[UBound($lConverted) + 1]
			For $j = 1 To $lRecord[0] Step 1
				ReDim $lFields[UBound($lFields) + 1]
				; convert to string
				$lFields[UBound($lFields) - 1] = _CSVFieldToString($lRecord[$j], $pEnclose)
				; convert back to field with changed delimiter
				$lFields[UBound($lFields) - 1] = _CSVStringToField($lRecord[$j], $pNewDelimiter, $pEnclose)
				; field concatenation in record
				If $j = $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1]
				ElseIf $j < $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1] & $pNewDelimiter
				EndIf
			Next
		Next
		$lConverted[0] = UBound($lConverted) - 1
	Else
		; convert to string
		$lField = _CSVFieldToString($pConvert, $pEnclose)
		; convert back to field with changed delimiter
		$lField = _CSVStringToField($lField, $pNewDelimiter, $pEnclose)
		$lConverted = $lField
	EndIf
	Return $lConverted
EndFunc   ;==>_CSVConvertDelimiter

;===========================================================================================
; Function Name: 	_CSVConvertEnclose
; Description:		Converts the enclose char of a record, column, row or field.
;					Returns either array or string according to the type of $pConvert.
; Syntax:           _CSVConvertEnclose($pConvert [,$pDelimiter] [,$pEnclose] [,$pNewEnclose])
; Parameter(s):     $pRawField	-	Raw csv string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pNewEnclose-	Use -1 for default single quote "'" char.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lRecords array
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose or
;									$pNewEnclose is >1.
;									$lConverted[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, if unable to convert $pConvert to field(s).
;									Check @extended to obtain @errors inherited from
;									_CSVRecordToFields. If an error occurs, then the
;									function returns whatever was stored in $lConverted
;									up until the error occurred.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertEnclose($pConvert, $pDelimiter = -1, $pEnclose = -1, $pNewEnclose = -1)
	Dim $lRecord[1] = [0], $lFields[1] = [0], $lConverted[1] = [0]
	Local $lField
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pNewEnclose = -1 Then $pNewEnclose = "'"
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pNewEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Or StringLen($pNewEnclose) > 1 Then
		SetError(1)
		Return $lConverted
	EndIf
	If IsArray($pConvert) Then
		For $i = 1 To UBound($pConvert) - 1 Step 1
			$lRecord = _CSVRecordToFields($pConvert[$i], $pDelimiter, $pEnclose)
			If @error Then
				SetError(1, @error)
				Return $lConverted
			EndIf
			ReDim $lConverted[UBound($lConverted) + 1]
			For $j = 1 To $lRecord[0] Step 1
				ReDim $lFields[UBound($lFields) + 1]
				; convert to string
				$lFields[UBound($lFields) - 1] = _CSVFieldToString($lRecord[$j], $pEnclose)
				; convert back to field with changed Enclose
				$lFields[UBound($lFields) - 1] = _CSVStringToField($lRecord[$j], $pDelimiter, $pNewEnclose)
				; field concatenation in record
				If $j = $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1]
				ElseIf $j < $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1] & $pDelimiter
				EndIf
			Next
		Next
		$lConverted[0] = UBound($lConverted) - 1
	Else
		; convert to string
		$lField = _CSVFieldToString($pConvert, $pEnclose)
		; convert back to field with changed Enclose
		$lField = _CSVStringToField($lField, $pDelimiter, $pNewEnclose)
		$lConverted = $lField
	EndIf
	Return $lConverted
EndFunc   ;==>_CSVConvertEnclose

;===========================================================================================
; Function Name: 	_CSVFieldsToRecord
; Description:		Converts an array to a string in csv format (with delimiters and
;					enclose chars), filling any empty .
; Syntax:           _CSVConvertEnclose($pFields ,$pStartIndex ,$pNumCols [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFields	-	Array with text or csv elements.
;					$pStartIndex-	Index in $pFields where to start the concatenation.
;									Default is 1. I use the AutoIt implicit convention of
;									keeping index 0 for the number of elements in the array,
;									therefore starting at 1 is not a bad idea.
;					$pNumCols	-	Use default -1 for number of elements in $pFields.
;									If $pNumCols exceeds the number of elements in $pFields
;									then the remaining cols in the record will be filled with
;									empty values. Propper csv formatting requires that the file's
;									amount of columns be set to the number of columns found in
;									the record with most columns. A badly formatted file will
;									contain a non uniform quantity of cols between records. So
;									$pNumCols should really be a constant among records in a file.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns a string of delimited fields in csv format.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord = '' is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, if $pFields is not an array.
;									$lRecord = '' is returned.
;								-	@error =3, if $pStartIndex or $pNumCols or $pMode are not
;									intergers.
;									$lRecord = '' is returned.
;								-	@error =4, if $pStartIndex or $pNumCols or $pMode have
;									wrong values.
;									$lRecord = '' is returned.
;								-	@error =5, if $pNumCols is less than the number of elements
;									in $pFields. $pNumCols should be at least equal to $pFields.
;									$lRecord = '' is returned.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFieldsToRecord($pFields, $pStartIndex = 1, $pNumCols = -1, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Local $lConcat, $lRecord = ''
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pNumCols = -1 Then $pNumCols = UBound($pFields) - 1
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecord
	EndIf
	If Not IsArray($pFields) Then
		SetError(2)
		Return $lRecord
	EndIf
	If Not IsInt($pStartIndex) Or Not IsInt($pNumCols) Or Not IsInt($pMode) Then
		SetError(3)
		Return $lRecord
	EndIf
	If $pStartIndex < 0 Or $pNumCols < 1 Or $pMode < 0 Or $pMode > 1 Then
		SetError(4)
		Return $lRecord
	EndIf
	If $pNumCols < UBound($pFields) - 1 Then
		SetError(5)
		Return $lRecord
	EndIf
	For $i = $pStartIndex To $pNumCols Step 1
		$lConcat = ''
		If $i <= UBound($pFields) - 1 Then
			If $pMode = 0 Then
				$lConcat = $pFields[$i]
			ElseIf $pMode = 1 Then
				$lConcat = _CSVStringToField($pFields[$i], $pDelimiter, $pEnclose)
			EndIf
		ElseIf $i > UBound($pFields) - 1 Then
			$lConcat = _CSVStringToField('', $pDelimiter, $pEnclose)
		EndIf
		If $i < $pNumCols Then
			$lRecord &= $lConcat & $pDelimiter
		ElseIf $i = $pNumCols Then
			$lRecord &= $lConcat
		EndIf
	Next
	Return $lRecord
EndFunc   ;==>_CSVFieldsToRecord

;===========================================================================================
; Function Name: 	_CSVFileAppendRecord
; Description:		Appends a string record returned by _CSVFieldsToRecord at the end of a csv file.
; Syntax:           _CSVConvertEnclose($pFields)
; Parameter(s):     $pFullPath	-	Path and filename of the csv file. If the file does not
;									exist, this function will attempt to create it.
;					$pRecord	-	string record returned by _CSVFieldsToRecord.
; Requirement(s):   				none
; Return Value(s):  On Success	-	Returns 1.
;					On Failure	-	@error =1, File doesn't exist, 0 is returned.
;								-	@error = 2 if the file could not be opened, 0 is returned.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileAppendRecord($pFullPath, $pRecord)
	Local $lFile
	If Not FileExists($pFullPath) Then
		SetError(1)
		Return 0
	EndIf
	$lFile = FileOpen($pFullPath, 1)
	If $lFile = -1 Then
		SetError(2)
		Return 0
	EndIf
	FileWriteLine($lFile, $pRecord)
	FileClose($lFile)
	Return 1
EndFunc   ;==>_CSVFileAppendRecord

;===========================================================================================
; Function Name: 	_CSVFileAppendColumn
; Description:		Appends a field at the end of each record in a csv file and returns a 1Dim
; 					array with all the records in the file. If the number of elements in $pColumn
;					is less than the number of records in the csv file, the remaining fields in the
;					new column will be filled with empty values. If the number of elements in
;					$pColumn exceeds the number of records in the csv file, the remaining fields
;					will be ignored. Try appending new records with _CSVFileAppendRecord instead.
; Syntax:           _CSVFileAppendColumn($pFields ,$pColumn  [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in the column you wish to append.
;									When passing the $pColumn array make sure the firts field
;									is $pColumn[1]. I use the AutoIt implicit convention of
;									keeping index 0 for the number of elements in the array,
;									therefore starting at 1 is not a bad idea.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) if fields in $pColumn are in raw csv format.
;									Use 1 if fields in $pColumn are in text format.
; Requirement(s):   				File.au3
; Return Value(s):  On Success	-	Returns a 1Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, $pColumn is not an array
;									$lRecords[0] = 0 is returned.
;								-	@error =4, an error occurred while reding records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =5, if csv file could not be opened in overwrite mode
;									$lRecords is returned with the new column appended.
;								-	@error =6, if the file could not be written to.
;									$lRecords is returned with the new column appended.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileAppendColumn($pFullPath, $pColumn, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Dim $lRecords[1] = [0]
	Local $lCSVFileHandle, $lCheckWrite
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return $lRecords
	EndIf
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		If $pMode = 0 Then
			If $i <= UBound($pColumn) - 1 Then
				$lRecords[$i] &= $pDelimiter & $pColumn[$i]
			Else
				$lRecords[$i] &= $pDelimiter
			EndIf
		ElseIf $pMode = 1 Then
			If $i <= UBound($pColumn) - 1 Then
				$lRecords[$i] &= $pDelimiter & _CSVStringToField($pColumn[$i], $pDelimiter, $pEnclose)
			Else
				$lRecords[$i] &= $pDelimiter
			EndIf
		EndIf
	Next
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		SetError(5)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			SetError(6)
			Return $lRecords
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileAppendColumn

;===========================================================================================
; Function Name: 	_CSVFileInsertRecord
; Description:		Inserts a record in a file and returns a 1 Dim array with all the records
; 					in the file.
; Syntax:           _CSVFileInsertRecord($pFullPath, $pRecord, $pRecordIndex [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pRecord	-	String of concatenated fields in csv format created
;									with _CSVFieldsToRecord.
;					$pRecordIndex-	Line number where you wish to insert the record.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns a 1 Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, an error occurred while reding records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =4, if $pRecordIndex is invalid
;									1Dim Array $lRecords with values prior to insertion.
;								-	@error =5, if the insertion failed.
;									0 is returned.
;								-	@error =6, if csv file could not be opened in overwrite mode
;									$lRecords is returned with the new column appended.
;								-	@error =7, if the file could not be written to.
;									$lRecords is returned with the new column appended.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileInsertRecord($pFullPath, $pRecord, $pRecordIndex, $pDelimiter = -1, $pEnclose = -1)
	Dim $lRecords[1] = [0]
	Local $lCSVFileHandle
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return $lRecords
	EndIf
	If $pRecordIndex < 1 Or $pRecordIndex > UBound($lRecords) - 1 Then
		SetError(4)
		Return $lRecords
	EndIf
	If Not _ArrayInsert($lRecords, $pRecordIndex, $pRecord) Then
		SetError(5)
		Return 0
	EndIf
	$lRecords[0] = UBound($lRecords) - 1
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		SetError(6)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			SetError(7)
			Return $lRecords
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileInsertRecord

;===========================================================================================
; Function Name: 	_CSVFileInsertColumn
; Description:		Inserts a column in a csv file and returns a 1 Dim array with all the records
; 					in the file.
; Syntax:           _CSVFileInsertColumn($pFullPath, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;					$pColumnIndex-	Position where you wish to insert the column.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns a 1 Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, $pColumn is not an array
;									$lRecords[0] = 0 is returned.
;								-	@error =4, an error occurred while retreiving records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =5, an error occurred while retreiving fields via
;									_CSVRecordToFields, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =6, if $pColumnIndex is invalid
;									0 is returned
;								-	@error =7, if the insertion failed.
;									0 is returned.
;								-	@error =8, if using $pMode=1 and _CSVStringToField failed.
;									_CSVStringToField errors can be retreived via @extended.
;									0 is returned.
;								-	@error =9, if csv file could not be opened in overwrite mode
;									$lRecords is returned with the new column appended.
;								-	@error =10, if the file could not be written to.
;									$lRecords is returned with the new column appended.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileInsertColumn($pFullPath, $pColumn, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Dim $lRecords[1] = [0], $lFields[1] = [0]
	Local $lCSVFileHandle, $lCheckWrite
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return $lRecords
	EndIf
	;extract record
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordToFields($lRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(5, @error)
			Return $lRecords
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(6)
			Return 0
		Else
			If $pMode = 1 Then
				$pColumn[$i] = _CSVStringToField($pColumn[$i], $pDelimiter, $pEnclose)
				If @error Then
					SetError(8)
					Return 0
				EndIf
			EndIf
			; insert a field at $pColumnIndex
			If Not _ArrayInsert($lFields, $pColumnIndex, $pColumn[$i]) Then
				SetError(7)
				Return 0
			EndIf
		EndIf
		; clear and rebuild the record
		$lRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	$lRecords[0] = UBound($lRecords) - 1
	; overwrite file
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		SetError(9)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			SetError(10)
			Return $lRecords
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileInsertColumn

;===========================================================================================
; Function Name: 	_CSVFileUpdateRecord
; Description:		Updates the field values in a csv file record. Returns a 1Dim array with
;					updated records.
; Syntax:           _CSVFileUpdateRecord($pFullPath, $pRecord, $pRecordIndex [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in column. Format according to $pMode.
;					$pColumnIndex-	Position where you wish to insert the column.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns a 1 Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, an error occurred while reding records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =4, if $pRecordIndex is invalid
;									1Dim Array $lRecords with values prior to insertion.
;								-	@error =5, if the update failed via _FileWriteToLine
;									_FileWriteToLine error stored in @extended.
;									0 is returned
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileUpdateRecord($pFullPath, $pRecord, $pRecordIndex, $pDelimiter = -1, $pEnclose = -1)
	Dim $lRecords[1] = [0]
	Local $lCSVFileHandle
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return $lRecords
	EndIf
	If $pRecordIndex < 1 Or $pRecordIndex > UBound($lRecords) - 1 Then
		SetError(4)
		Return $lRecords
	EndIf
	; update
	If Not _FileWriteToLine($pFullPath, $pRecordIndex, $pRecord, 1) Then
		SetError(5, @error)
		Return 0
	EndIf
	$lRecords [$pRecordIndex] = $pRecord
	Return $lRecords
EndFunc   ;==>_CSVFileUpdateRecord

;===========================================================================================
; Function Name: 	_CSVFileUpdateColumn
; Description:		Update a column in a csv file and returns a 1 Dim array with all the records
; 					in the file (including the update).
; Syntax:           _CSVFileUpdateColumn($pFullPath, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;					$pColumnIndex-	The column number you wish to update.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns a 1 Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, $pColumn is not an array
;									$lRecords[0] = 0 is returned.
;								-	@error =4, an error occurred while retreiving records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =5, an error occurred while retreiving fields via
;									_CSVRecordToFields, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =6, if $pColumnIndex is invalid
;									0 is returned
;								-	@error =7, if using $pMode=1 and _CSVStringToField failed.
;									_CSVStringToField errors can be retreived via @extended.
;									0 is returned.
;								-	@error =8, if csv file could not be opened in overwrite mode
;									$lRecords is returned with the new column appended.
;								-	@error =9, if the file could not be written to.
;									$lRecords is returned with the new column appended.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileUpdateColumn($pFullPath, $pColumn, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Dim $lRecords[1] = [0], $lFields[1] = [0]
	Local $lCSVFileHandle, $lCheckWrite
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return $lRecords
	EndIf
	;extract record
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordToFields($lRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(5, @error)
			Return $lRecords
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(6)
			Return 0
		Else
			If $pMode = 1 Then
				$pColumn[$i] = _CSVStringToField($pColumn[$i], $pDelimiter, $pEnclose)
				If @error Then
					SetError(7)
					Return 0
				EndIf
			EndIf
			; update a field at $pColumnIndex
			$lFields[$pColumnIndex] = $pColumn[$i]
		EndIf
		; clear and rebuild the record
		$lRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	; overwrite file
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		SetError(8)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			SetError(9)
			Return $lRecords
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileUpdateColumn

;===========================================================================================
; Function Name: 	_CSVFileDeleteRecord
; Description:		Delete a record in a file.
; Syntax:           _CSVFileUpdateColumn($pFullPath, $pRecordIndex)
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pRecordIndex-	Record number to delete
; Requirement(s):   				File.au3
; Return Value(s):  On Success	-	Returns 1
;					On Failure	-	@error = 1 if File cannot be opened or found.
;									0 is returned.
;								-	@error =2, if $pRecordIndex is greater to the number of records
;									0 is returned.
;								-	@error =3, an error occurred while writing an empty string via
;									_FileWriteToLine, the error code can be retreived with @extended.
;									0 is returned.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileDeleteRecord($pFullPath, $pRecordIndex)
	Local $lNumLines = _FileCountLines($pFullPath)
	If @error = 1 Then
		SetError(1)
		Return 0
	EndIf
	If $lNumLines < $pRecordIndex Then
		SetError(2)
		Return 0
	EndIf
	_FileWriteToLine($pFullPath, $pRecordIndex, '', 1)
	If @error > 0 Then
		SetError(3, @error)
		Return 0
	EndIf
	Return 1
EndFunc   ;==>_CSVFileDeleteRecord

;===========================================================================================
; Function Name: 	_CSVFileDeleteColumn
; Description:		Delete a column in a csv file and returns a 1 Dim array with all the records
; 					in the file (including the update).
; Syntax:           _CSVFileDeleteColumn($pFullPath, $pColumnIndex [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumnIndex-	The column number you wish to delete.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns a 1 Dim array with all the records in the file.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord[0] = 0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;									$lRecords[0] = 0 is returned.
;								-	@error =3, an error occurred while retreiving records via
;									_CSVReadRecords, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =4, an error occurred while retreiving fields via
;									_CSVRecordToFields, the error code can be retreived with @extended.
;									$lRecords[0] = 0 is returned.
;								-	@error =5, if $pColumnIndex is invalid
;									0 is returned
;								-	@error =6, if csv file could not be opened in overwrite mode
;									$lRecords is returned with the new column appended.
;								-	@error =7, if the file could not be written to.
;									$lRecords is returned with the new column appended.
; Warning:			Not tested with Delimiters other than the defaults.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileDeleteColumn($pFullPath, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1)
	Dim $lRecords[1] = [0], $lFields[1] = [0]
	Local $lCSVFileHandle, $lCheckWrite
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return $lRecords
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return $lRecords
	EndIf
	;extract record
	$lRecords = _CSVReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordToFields($lRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(4, @error)
			Return $lRecords
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(5)
			Return 0
		EndIf
		_ArrayDelete($lFields, $pColumnIndex)
		; clear and rebuild the record
		$lRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$lRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	; overwrite file
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		SetError(6)
		Return $lRecords
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			SetError(7)
			Return $lRecords
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileDeleteColumn