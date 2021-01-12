#include-once
#include <File.au3>
#include <Array.au3>
#Include <String.au3>
#include <Misc.au3>

;~ FUNCTION LIST
;============================================================================================================
; _CSVFileReadRecords		Retreives the contents of a csv file to a 1 Dim Array, where each element
; _CSVFileAppendRecord		Appends a string record returned by _CSVFieldsToRecord at the end of a csv file.
; _CSVFileAppendColumn		Appends a field at the end of each record in a csv file and returns a 1Dim
; 							array with all the records in the file. If the number of elements in $pColumn
; 							is less than the number of records in the csv file, the remaining fields in the
; 							new column will be filled with empty values. If the number of elements in
; 							$pColumn exceeds the number of records in the csv file, the remaining fields
; 							will be ignored. Try appending new records with _CSVFileAppendRecord instead.
;
; _CSVFileInsertRecord		Inserts a record in a file and returns a 1 Dim array with all the records
; 							in the file.
;
; _CSVFileInsertColumn		Inserts a column in a csv file and returns a 1 Dim array with all the records
; 							in the file. The column can either be raw csv or text according to $pMode.
;
; _CSVFileUpdateRecord		Updates the field values in a csv file record. Returns a 1Dim array with
; 							updated records.
;
; _CSVFileUpdateColumn		Update a column in a csv file and returns a 1 Dim array with all the records
; 							in the file (including the update). Column contents can be text or csv format
; 							according to $pMode.
;
; _CSVFileDeleteRecord		Delete a record in a file.
;
; _CSVFileDeleteColumn		Delete a column in a csv file and returns a 1 Dim array with all the records
; 							in the file (including the update).
;
; _CSVRecordsGetColumn		Retreives the column of a csv file to a 1 Dim Array.
;
; _CSVRecordGetFields		Converts a given Record (single csv line) to a 1 Dim Fields array.
; 							Fields are filled in raw csv format.
;
; _CSVRecordsGetFieldValue	Returns the string in a field from a given column and row.
;
; _CSVRecordsAppendFields	Creates a record from a fields array and appends it at the end of a records array.
; 							$pRecords Array is modified by ref.
;
; _CSVRecordsInsertFields	Creates a record from a fields array and inserts it at the end of a records array.
; 							$pRecords Array is modified by ref.
;
; _CSVRecordsUpdateFields	Creates a record from a fields array and inserts it at the end of a records array.
; 							$pRecords Array is modified by ref.
;
; _CSVColumnAppend			Appends a field at the end of each record in a csv records array If the
;		 					number of elements in $pColumn is less than the number of records in the
; 							csv array, the remaining fields in the new column will be filled with
; 							empty values. If the number of elements in $pColumn exceeds the number
; 							of records in the csv array, the remaining fields will be ignored.
;
; _CSVColumnInsert			Inserts a column in a csv arrayThe column can either be raw csv or text
; 							according to $pMode.
;
; _CSVColumnUpdate			Update a column in a csv array. Column contents can be text or csv format
; 							according to $pMode.
;
; _CSVColumnDelete			Delete a column in a csv records array.
;
; _CSVFieldsToRecord		Converts an array to a string in csv format (with delimiters and
; 							enclose chars), filling any empty fields.
;
; _CSVConvertStringToField	Converts a text string to csv format to store in a single field.
;
; _CSVConvertFieldToString	Converts the content of a single csv field to a text string.
;
; _CSVConvertDelimiter		Converts the delimiter char of a record array or single record, single or
; 							or field passed by reference.
;
; _CSVConvertEnclose		Converts the enclose char of a record array or single record, single or
; 							or field passed by reference.
;
; _CSVSearch				Search for $pSearchStr in $pRecords, where $pRecords is either a single
;		 					record (string) or multiple records (array), returning a 2Dim array
; 							containing the search results.
;
; _CSVConvertLineBreak		Encodes or Decodes the line break (either @CR or @LF, therefore, also converts
;	 						the combined @CRLF) in a single field (string) or multiple fields (array).
; 							$pMode = 0 will encode line breaks (@CR, @LF and @CRLF) from a field(s)
; 							using the chars passed in $pConvertCR and $pConvertLF, whereas $pMode = 1
; 							will decode chars passed in $pConvertCR and $pConvertLF back to breaks
; 							(@CR, @LF and @CRLF) in the field(s).
;
; Author:			IVAN PEREZ
;============================================================================================================

; CSV File Management functions
; On success, the contents of the csv file or modified file are returned as an array.
#region CSV File Management
;===========================================================================================
; Function Name: 	_CSVFileReadRecords
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
;								-	@error = 2 if open or read error, returns 0
;								-	@error = 3 if no records found, returns 0
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileReadRecords($pFullPath)
	Dim $lRecords[1] = [0]
	Local $lCVSFileHandle
	If Not FileExists($pFullPath) Then
		SetError(1)
		Return 0
	EndIf
	; open file in read mode
	$lCVSFileHandle = FileOpen($pFullPath, 0)
	If $lCVSFileHandle = -1 Then ; FileOpen error
		FileClose($lCVSFileHandle)
		SetError(2)
		$lRecords[0] = 0
		Return 0
	EndIf
	; extract redords
	While 1
		$lCurrentLine = FileReadLine($lCVSFileHandle)
		If @error = -1 Then ; end of file reached thus exit the loop
			ExitLoop
		ElseIf @error = 1 Then ; Reading error, file open errors subsumed in FileOpen() above.
			FileClose($lCVSFileHandle)
			SetError(3)
			$lRecords[0] = 0
			Return 0
		EndIf
		ReDim $lRecords[UBound($lRecords) + 1]
		$lRecords[UBound($lRecords) - 1] = $lCurrentLine
	WEnd
	FileClose($lCVSFileHandle)
	; set the record count
	$lRecords[0] = UBound($lRecords) - 1
	Return $lRecords
EndFunc   ;==>_CSVFileReadRecords

;===========================================================================================
; Function Name: 	_CSVFileAppendRecord
; Description:		Appends a string record returned by _CSVFieldsToRecord at the end of a csv file.
; Syntax:           _CSVConvertEnclose($pFields)
; Parameter(s):     $pFullPath	-	Path and filename of the csv file. If the file does not
;									exist, this function will attempt to create it.
;					$pRecord	-	string record returned by _CSVFieldsToRecord.
; Requirement(s):   				none
; Return Value(s):  On Success	-	Appends a record at the end of a csv file.
;									Returns 1Dim array with new file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error =1, File doesn't exist, 0 is returned.
;								-	@error = 2 if the file could not be opened, 0 is returned.
;								-	@error = 3 if the file modified contents could not be
;									retreived.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileAppendRecord($pFullPath, $pRecord)
	Local $lFile
	Dim $lRecords[1] = [0]
	If Not FileExists($pFullPath) Then
		SetError(1)
		Return 0
	EndIf
	; open in append mode
	$lFile = FileOpen($pFullPath, 1)
	If $lFile = -1 Then
		SetError(2)
		FileClose($lFile)
		Return 0
	EndIf
	FileWriteLine($lFile, $pRecord)
	FileClose($lFile)
	; retreive contents of modified file
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(3, @extended)
		Return 0
	EndIf
	Return $lRecords
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
; Return Value(s):  On Success	-	Appends a column at the end of a csv file.
; 								-	Returns 1Dim array with modified file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, $pColumn is not an array
;								-	@error =4, an error occurred while reding records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =5, if csv file could not be opened in overwrite mode
;								-	@error =6, if the file could not be written to.
;								-	@error =7, if column append failed via _CSVColumnAppend.
;									@extended should contain the error passed.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return 0
	EndIf
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf
	If Not _CSVColumnAppend($lRecords, $pColumn, $pDelimiter, $pEnclose, $pMode) Then
		SetError(7, @error)
		Return 0
	EndIf
	; open file in overwrite mode
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		FileClose($lCSVFileHandle)
		SetError(5)
		Return 0
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			FileClose($lCSVFileHandle)
			SetError(6)
			Return 0
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
; Return Value(s):  On Success	-	Inserts a record in a csv file at line number $pRecordIndex.
; 								-	Returns 1Dim array with modified file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, an error occurred while reding records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =4, if $pRecordIndex is invalid
;								-	@error =5, if the insertion failed.
;								-	@error =6, if csv file could not be opened in overwrite mode
;								-	@error =7, if the file could not be written to.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	If $pRecordIndex < 1 Or $pRecordIndex > UBound($lRecords) - 1 Then
		SetError(4)
		Return 0
	EndIf
	If Not _ArrayInsert($lRecords, $pRecordIndex, $pRecord) Then
		SetError(5)
		Return 0
	EndIf
	$lRecords[0] = UBound($lRecords) - 1
	; open file in overwrite mode
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		FileClose($lCSVFileHandle)
		SetError(6)
		Return 0
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			FileClose($lCSVFileHandle)
			SetError(7)
			Return 0
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileInsertRecord

;===========================================================================================
; Function Name: 	_CSVFileInsertColumn
; Description:		Inserts a column in a csv file and returns a 1 Dim array with all the records
; 					in the file. The column can either be raw csv or text according to $pMode.
; Syntax:           _CSVFileInsertColumn($pFullPath, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;									I use the AutoIt implicit convention of keeping index 0 for
;									the number of elements in the array, therefore starting
;									at 1 is not a bad idea.
;					$pColumnIndex-	Position where you wish to insert the column.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Inserts a column in a csv file at column number $pColumnIndex.
; 								-	Returns 1Dim array with modified file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, $pColumn is not an array
;								-	@error =4, an error occurred while retreiving records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =5, an error occurred while inserting the column via
;									_CSVColumnInsert, the error code can be retreived with @extended.
;								-	@error =6, if csv file could not be opened in overwrite mode
;								-	@error =7, if the file could not be written to.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return 0
	EndIf
	;extract record
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf
	If Not _CSVColumnInsert($lRecords, $pColumn, $pColumnIndex, $pDelimiter, $pEnclose, $pMode) Then
		SetError(5, @error)
		Return 0
	EndIf
	$lRecords[0] = UBound($lRecords) - 1
	; open file in overwrite mode
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		FileClose($lCSVFileHandle)
		SetError(6)
		Return 0
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			FileClose($lCSVFileHandle)
			SetError(7)
			Return 0
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
;					$pRecord	-	String record containing text. if '' then line is deleted.
;					$pRecordIndex-	Int line number to update.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Updates a record in a csv file.
; 								-	Returns 1Dim array with modified file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, an error occurred while reding records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =4, if $pRecordIndex is invalid
;								-	@error =5, if the update failed via _FileWriteToLine
;									_FileWriteToLine error stored in @extended.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	If $pRecordIndex < 1 Or $pRecordIndex > UBound($lRecords) - 1 Then
		SetError(4)
		Return 0
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
; 					in the file (including the update). Column contents can be text or csv format
; 					according to $pMode.
; Syntax:           _CSVFileUpdateColumn($pFullPath, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;									I use the AutoIt implicit convention of keeping index 0 for
;									the number of elements in the array, therefore starting
;									at 1 is not a bad idea.
;					$pColumnIndex-	The column number you wish to update.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Updates a column in a csv file.
;								-	Returns a 1 Dim array with all the records in the file.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, $pColumn is not an array
;								-	@error =4, an error occurred while retreiving records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =5, an error occurred while updating the column via
;									_CSVColumnUpdate, the error code can be retreived with @extended.
;								-	@error =6, if $pColumnIndex is invalid
;								-	@error =7, if using $pMode=1 and _CSVConvertStringToField failed.
;									_CSVConvertStringToField errors can be retreived via @extended.
;								-	@error =6, if csv file could not be opened in overwrite mode
;								-	@error =7, if the file could not be written to.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	If Not IsArray($pColumn) Then
		SetError(3)
		Return 0
	EndIf
	;extract record
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf
	If Not _CSVColumnUpdate($lRecords, $pColumn, $pColumnIndex, $pDelimiter, $pEnclose, $pMode) Then
		SetError(5, @error)
		Return 0
	EndIf
	; open file in overwrite mode
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		FileClose($lCSVFileHandle)
		SetError(6)
		Return 0
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			FileClose($lCSVFileHandle)
			SetError(7)
			Return 0
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
; Return Value(s):  On Success	-	Deletes a line from a csv file.
; 								-	Returns 1Dim array with modified file contents.
;									$lRecords[0] contains the number of records.
;					On Failure	-	@error = 1 if File cannot be opened or found.
;									0 is returned.
;								-	@error =2, if $pRecordIndex is greater to the number of records
;									0 is returned.
;								-	@error =3, an error occurred while writing an empty string via
;									_FileWriteToLine, the error code can be retreived with @extended.
;									0 is returned.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVFileDeleteRecord($pFullPath, $pRecordIndex)
	Local $lNumLines = _FileCountLines($pFullPath)
	Dim $lRecords[1] = [0]
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
	; retreive contents of modified file
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(3, @extended)
		Return 0
	EndIf
	Return $lRecords
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
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Deletes a column in a csv file.
;								-	Returns a 1 Dim array with all the records in the file.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, File doesn't exist
;								-	@error =3, an error occurred while retreiving records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =4, an error occurred while deleting the column via
;									_CSVColumnDelete, the error code can be retreived with @extended.
;								-	@error =5, if csv file could not be opened in overwrite mode
;								-	@error =6, if the file could not be written to.
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
		Return 0
	EndIf
	If Not FileExists($pFullPath) Then
		SetError(2)
		Return 0
	EndIf
	;extract record
	$lRecords = _CSVFileReadRecords($pFullPath)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	If Not _CSVColumnDelete($lRecords, $pColumnIndex, $pDelimiter, $pEnclose) Then
		SetError(4, @error)
		Return 0
	EndIf
	; open file in overwrite mode
	$lCSVFileHandle = FileOpen($pFullPath, 2)
	If $lCSVFileHandle = -1 Then
		FileClose($lCSVFileHandle)
		SetError(5)
		Return 0
	EndIf
	For $i = 1 To UBound($lRecords) - 1 Step 1
		$lCheckWrite = FileWriteLine($lCSVFileHandle, $lRecords[$i])
		If $lCheckWrite = 0 Then
			FileClose($lCSVFileHandle)
			SetError(6)
			Return 0
		EndIf
	Next
	FileClose($lCSVFileHandle)
	Return $lRecords
EndFunc   ;==>_CSVFileDeleteColumn
#endregion
; CSV Records Management functions
; On success, the contents of the csv records array are either returned as an array or
; the array passed is modified by reference for append, insert and update operations.
#region CSV Records Management
;===========================================================================================
; Function Name: 	_CSVRecordsGetColumn
; Description:		Retreives the column of a csv file to a 1 Dim Array.
; Syntax:           _CSVRecordsGetColumn($pFullPath, $pColumnNumber  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pFullPath	-	Path and filename of the csv file.
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lColumn array in raw csv format
;					On Failure	-	0 is returned and errors set as follow:
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error = 2 if $pRecords is not an array.
;								-	@error = 3 if $pRecords has the wrong format.
;								-	@error = 4 if $pRecords contains a single element. Typically
;									because $pRecords contains no records.
;								-	@error = 5 if $pColumnNumber exceeds the amount of columns
;									in $pRecords. The number of columns in each record in $pRecords
;									should be set to the number of columns found in the record with
;									most columns.
;									This means that records with empty columns should have been
;									filled with empty values, so @error = 5 either occurred because
;									the file was badly formatted or because the column parameter
;									is too high.
;								-	@error = 6 if an error occurred while converting one or more
;									records to fields by means of _CSVRecordGetFields. The error
;									in _CSVRecordGetFields can be tracked using @extended. This
;									error passing enables tracking in a consistent fashion.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordsGetColumn($pRecords, $pColumnNumber, $pDelimiter = -1, $pEnclose = -1)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Dim $lColumn[1] = [0]
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pRecords) Then
		SetError(2)
		Return 0
	EndIf
	If Not IsInt($pRecords[0]) Then
		SetError(3)
		Return 0
	ElseIf $pRecords[0] < 1 Then
		SetError(4)
		Return 0
	EndIf
	ReDim $lColumn[UBound($pRecords) ]
	Dim $lCurrentRecord
	For $i = 1 To UBound($pRecords) - 1 Step 1
		$lCurrentRecord = _CSVRecordGetFields($pRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(6, @error)
			Return 0
		EndIf
		If $pColumnNumber <= $lCurrentRecord[0] Then
			$lColumn[$i] = $lCurrentRecord[$pColumnNumber]
		Else
			SetError(5)
			Return 0
		EndIf
	Next
	$lColumn[0] = UBound($lColumn) - 1
	Return $lColumn
EndFunc   ;==>_CSVRecordsGetColumn

;===========================================================================================
; Function Name: 	_CSVRecordGetFields
; Description:		Converts a given Record (single csv line) to a 1 Dim Fields array.
;					Fields are filled in raw csv format.
; Syntax:           _CSVRecordGetFields($pRecord  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRecord	-	Raw record (single csv line).
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 Dim $lFields array
;					On Failure	-	0 is returned.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char (length>1), such as @crlf.
;								-	@error = 2 if the passed record could not be converted
;									to an array.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordGetFields($pRecord, $pDelimiter = -1, $pEnclose = -1)
	Local $lRecordLen = StringLen($pRecord), $lConsecutiveEnclose = ''
	Dim $lFields[1] = [0], $lRecordStrToArray[1] = [$lRecordLen]
	Local $lIsNewField = True, $lIsEnclosed = False, $lEndEnclose = False
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1) ; wrong delimiter or enclose length
		Return 0
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
			Return 0 ; conversion failure
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
EndFunc   ;==>_CSVRecordGetFields

;===========================================================================================
; Function Name: 	_CSVRecordsGetFieldValue
; Description:		Returns the string in a field from a given column and row.
; Syntax:           _CSVRecordsGetFieldValue(pFullPath, $pColumnNumber, $pRowNumber  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRecords	-	Records array in csv format maybe read with _CSVFileReadRecords
; 									or properly constructed with other functions.
;					$pColumnNumber-	The Column number you wish to retreive.
;					$pRowNumber	-	The row number you wish to retreive.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returs a String containing the field contents in csv format
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur with composite chars such as @crlf.
;								-	@error = 2 if $pColumnNumber exceeds columns in file
;								-	@error = 3 if $pRowNumber exceeds rows in file
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordsGetFieldValue($pRecords, $pColumnNumber, $pRowNumber, $pDelimiter = -1, $pEnclose = -1)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	Local $lField = -1
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	Dim $lColumn
	$lColumn = _CSVRecordsGetColumn($pRecords, $pColumnNumber, $pDelimiter, $pEnclose)
	If @error = 1 Then
		SetError(2)
		Return 0
	Else
		If $pRowNumber <= $lColumn[0] Then
			$lField = $lColumn[$pRowNumber]
		Else
			SetError(3)
			Return 0
		EndIf
	EndIf
	Return $lField
EndFunc   ;==>_CSVRecordsGetFieldValue

;===========================================================================================
; Function Name: 	_CSVRecordsAppendFields
; Description:		Creates a record from a fields array and appends it at the end of a records array.
;					$pRecords Array is modified by ref.
; Syntax:           _CSVRecordsAppendFields($pRecords, $pFields , $pStartIndex ,$pNumCols [,$pDelimiter] [,$pEnclose] [,$pMode] [,$pFlag])
; Parameter(s):     $pRecords	-	Records array in csv format maybe read with _CSVFileReadRecords
; 									or properly constructed with other functions.
; 					$pFields	-	Array with text or csv elements. $pFields concatenation
;									starts at element $pFields[1]. I keep the convention of
;									$pFields[0] for the number of elements in the array.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
;					$pFlag		-	Use 0 (default) for no update record count in $pRecords[0]
;								-	Use 1 to update record count in $pRecords[0]
; Requirement(s):   None
; Return Value(s):  On Success	-	Returs 1
; 								-	$pRecords Array is modified by ref.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error = 2 if $pRecords or $pFields are not an arrays.
;								-	@error = 3 if an error occurred while converting the
;									fields array to a record via _CSVFieldsToRecord. Error
;									can be retreived with @extended.
; Date:				15/01/07
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordsAppendFields(ByRef $pRecords, $pFields, $pDelimiter = -1, $pEnclose = -1, $pMode = 0, $pFlag = 0)
	Local $lAppendRecord
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pRecords) Or Not IsArray($pFields) Then
		SetError(2)
		Return 0
	EndIf
	$lAppendRecord = _CSVFieldsToRecord($pFields, -1, -1, $pDelimiter, $pEnclose, $pMode)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	ReDim $pRecords[UBound($pRecords) + 1]
	$pRecords[UBound($pRecords) - 1] = $lAppendRecord
	If $pFlag = 1 Then $pRecords[0] = $pRecords[UBound($pRecords) - 1]
	Return 1
EndFunc   ;==>_CSVRecordsAppendFields

;===========================================================================================
; Function Name: 	_CSVRecordsInsertFields
; Description:		Creates a record from a fields array and inserts it at the end of a records array.
;					$pRecords Array is modified by ref.
; Syntax:           _CSVRecordsInsertFields($pRecords, $pFields ,$pInsertIndex [,$pDelimiter] [,$pEnclose] [,$pMode] [,$pFlag])
; Parameter(s):     $pRecords	-	Records array in csv format maybe read with _CSVFileReadRecords
; 									or properly constructed with other functions.
; 					$pFields	-	Array with text or csv elements. $pFields concatenation
;									starts at element $pFields[1]. I keep the convention of
;									$pFields[0] for the number of elements in the array.
;					$pInsertIndex-	Position where you wish to insert the record.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
;					$pFlag		-	Use 0 (default) for no update record count in $pRecords[0]
;								-	Use 1 to update record count in $pRecords[0]
; Requirement(s):   None
; Return Value(s):  On Success	-	Returs 1
; 								-	$pRecords Array is modified by ref.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error = 2 if $pRecords or $pFields are not an arrays.
;								-	@error = 3 if an error occurred while converting the
;									fields array to a record via _CSVFieldsToRecord. Error
;									can be retreived with @extended.
;								-	@error = 4 array insert failed.
; Date:				16/01/07
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordsInsertFields(ByRef $pRecords, $pFields, $pInsertIndex, $pNumCols = -1, $pDelimiter = -1, $pEnclose = -1, $pMode = 0, $pFlag = 0)
	Local $lInsertRecord
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pRecords) Or Not IsArray($pFields) Then
		SetError(2)
		Return 0
	EndIf
	$lInsertRecord = _CSVFieldsToRecord($pFields, -1, -1, $pDelimiter, $pEnclose, $pMode)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	If Not _ArrayInsert($pRecords, $pInsertIndex, $lInsertRecord) Then
		SetError(4)
		Return 0
	EndIf
	If $pFlag = 1 Then $pRecords[0] = $pRecords[UBound($pRecords) - 1]
	Return 1
EndFunc   ;==>_CSVRecordsInsertFields

;===========================================================================================
; Function Name: 	_CSVRecordsUpdateFields
; Description:		Creates a record from a fields array and inserts it at the end of a records array.
;					$pRecords Array is modified by ref.
; Syntax:           _CSVRecordsUpdateFields($pRecords, $pFields ,$pUpdateIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pRecords	-	Records array in csv format maybe read with _CSVFileReadRecords
; 									or properly constructed with other functions.
; 					$pFields	-	Array with text or csv elements. $pFields concatenation
;									starts at element $pFields[1]. I keep the convention of
;									$pFields[0] for the number of elements in the array.
;					$pUpdateIndex-	Position of record you wish to update.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returs 1
; 								-	$pRecords Array is modified by ref.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error = 2 if $pRecords or $pFields are not an arrays.
;								-	@error = 3 if an error occurred while converting the
;									fields array to a record via _CSVFieldsToRecord. Error
;									can be retreived with @extended.
;								-	@error = 4 if $pUpdateIndex is greater than the number
;								-	of elements in $pRecords.
; Date:				16/01/07
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVRecordsUpdateFields(ByRef $pRecords, $pFields, $pUpdateIndex, $pNumCols = -1, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Local $lUpdateRecord
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pRecords) Or Not IsArray($pFields) Then
		SetError(2)
		Return 0
	EndIf
	$lUpdateRecord = _CSVFieldsToRecord($pFields, -1, -1, $pDelimiter, $pEnclose, $pMode)
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf
	If $pUpdateIndex> (UBound($pRecords) - 1) Then
		SetError(4)
		Return 0
	EndIf
	$pRecords[$pUpdateIndex] = $lUpdateRecord
	Return 1
EndFunc   ;==>_CSVRecordsUpdateFields
#endregion CSV Records Management
; CSV Column Management functions
; On success, the contents of the modified csv records array are modified by ref.
#region CSV Column Management
;===========================================================================================
; Function Name: 	_CSVColumnAppend
; Description:		Appends a field at the end of each record in a csv records array If the
; 					number of elements in $pColumn is less than the number of records in the
;					csv array, the remaining fields in the new column will be filled with
;					empty values. If the number of elements in $pColumn exceeds the number
;					of records in the csv array, the remaining fields will be ignored.
; Syntax:           _CSVColumnAppend($pRecords, $pColumn  [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pRecords	-	Records array where you wish to append the column.
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
; Return Value(s):  On Success	-	Returns 1
; 								-	Appends a column at the end of a csv records array.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
;								-	@error =2, $pColumn or $pRecords are not of array type
;								-	@error =3, if $pMode = 1 and string conversion failed
;									@extended should contain the conversion error.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVColumnAppend(ByRef $pRecords, $pColumn, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pColumn) Or Not IsArray($pRecords) Then
		SetError(2)
		Return 0
	EndIf
	For $i = 1 To UBound($pRecords) - 1 Step 1
		If $pMode = 0 Then
			If $i <= UBound($pColumn) - 1 Then
				$pRecords[$i] &= $pDelimiter & $pColumn[$i]
			Else
				$pRecords[$i] &= $pDelimiter
			EndIf
		ElseIf $pMode = 1 Then
			If $i <= UBound($pColumn) - 1 Then
				If _CSVConvertStringToField($pColumn[$i], $pDelimiter, $pEnclose) Then
					$pRecords[$i] &= $pDelimiter & $pColumn[$i]
				Else
					SetError(3, @error)
					Return 0
				EndIf
			Else
				$pRecords[$i] &= $pDelimiter
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>_CSVColumnAppend

;===========================================================================================
; Function Name: 	_CSVColumnInsert
; Description:		Inserts a column in a csv arrayThe column can either be raw csv or text
;					according to $pMode.
; Syntax:           _CSVColumnInsert($pRecords, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pRecords	-	Records array where you wish to insert the column.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;									I use the AutoIt implicit convention of keeping index 0 for
;									the number of elements in the array, therefore starting
;									at 1 is not a bad idea.
;					$pColumnIndex-	Position where you wish to insert the column.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns 1.
; 								-	Inserts a column in a csv array at column number $pColumnIndex.
;									Array is modified by reference.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, $pColumn or $pRecords are not of array type
;								-	@error =3, an error occurred while retreiving fields via
;									_CSVRecordGetFields, the error code can be retreived with @extended.
;								-	@error =4, if $pColumnIndex is invalid
;								-	@error =5, if using $pMode=1 and _CSVConvertStringToField failed.
;									_CSVConvertStringToField errors can be retreived via @extended.
;								-	@error =6, if the insertion failed.
; Date:				27/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVColumnInsert(ByRef $pRecords, $pColumn, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Dim $lFields[1] = [0]
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pColumn) Or Not IsArray($pRecords) Then
		SetError(2)
		Return 0
	EndIf
	For $i = 1 To UBound($pRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordGetFields($pRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(3, @error)
			Return 0
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(4)
			Return 0
		Else
			If $pMode = 1 Then
				If Not _CSVConvertStringToField($pColumn[$i], $pDelimiter, $pEnclose) Then
					SetError(5, @error)
					Return 0
				EndIf
			EndIf
			; insert a field at $pColumnIndex
			If Not _ArrayInsert($lFields, $pColumnIndex, $pColumn[$i]) Then
				SetError(6)
				Return 0
			EndIf
		EndIf
		; clear and rebuild the record
		$pRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	Return 1
EndFunc   ;==>_CSVColumnInsert

;===========================================================================================
; Function Name: 	_CSVColumnUpdate
; Description:		Update a column in a csv array. Column contents can be text or csv format
; 					according to $pMode.
; Syntax:           _CSVColumnUpdate($pFullPath, $pColumn, $pColumnIndex [,$pDelimiter] [,$pEnclose] [,$pMode])
; Parameter(s):     $pRecords	-	Records array where you wish to update the column.
;					$pColumn	-	Array of fields in column. Format (raw csv or text) according to $pMode.
;									I use the AutoIt implicit convention of keeping index 0 for
;									the number of elements in the array, therefore starting
;									at 1 is not a bad idea.
;					$pColumnIndex-	The column number you wish to update.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pMode		-	Use 0 (default) for raw csv concatenation.
;									Use 1 for text converversion to csv prior to concatenation.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns 1.
;								-	Updates a column in a csv array by reference.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, $pColumn or $pRecords are not of array type
;								-	@error =3, an error occurred while retreiving fields via
;									_CSVRecordGetFields, the error code can be retreived with @extended.
;								-	@error =4, if $pColumnIndex is invalid
;								-	@error =5, if using $pMode=1 and _CSVConvertStringToField failed.
;									_CSVConvertStringToField errors can be retreived via @extended.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVColumnUpdate(ByRef $pRecords, $pColumn, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1, $pMode = 0)
	Dim $lFields[1] = [0]
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pColumn) Or Not IsArray($pRecords) Then
		SetError(2)
		Return 0
	EndIf
	For $i = 1 To UBound($pRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordGetFields($pRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(3, @error)
			Return 0
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(4)
			Return 0
		Else
			If $pMode = 1 Then
				If Not _CSVConvertStringToField($pColumn[$i], $pDelimiter, $pEnclose) Then
					SetError(5)
					Return 0
				EndIf
			EndIf
			; update a field at $pColumnIndex
			$lFields[$pColumnIndex] = $pColumn[$i]
		EndIf
		; clear and rebuild the record
		$pRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	Return 1
EndFunc   ;==>_CSVColumnUpdate

;===========================================================================================
; Function Name: 	_CSVColumnDelete
; Description:		Delete a column in a csv records array.
; Syntax:           _CSVColumnDelete($pRecords, $pColumnIndex [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRecords	-	Records array where you wish to delete the column.
;					$pColumnIndex-	The column number you wish to delete.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   				File.au3, Array.au3
; Return Value(s):  On Success	-	Returns 1
; 								-	Deletes a column in a csv records array.
;									$lRecords[0] contains the number of records.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf.
;								-	@error =2, $pRecords are not of array type
;								-	@error =3, an error occurred while retreiving fields via
;									_CSVRecordGetFields, the error code can be retreived with @extended.
;								-	@error =4, if $pColumnIndex is invalid
;								-	@error =3, an error occurred while retreiving records via
;									_CSVFileReadRecords, the error code can be retreived with @extended.
;								-	@error =6, if csv file could not be opened in overwrite mode
;								-	@error =7, if the file could not be written to.
; Date:				28/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVColumnDelete(ByRef $pRecords, $pColumnIndex, $pDelimiter = -1, $pEnclose = -1)
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsArray($pRecords) Then
		SetError(2)
		Return 0
	EndIf
	For $i = 1 To UBound($pRecords) - 1 Step 1
		;extract fields
		$lFields = _CSVRecordGetFields($pRecords[$i], $pDelimiter, $pEnclose)
		If @error Then
			SetError(3, @error)
			Return 0
		EndIf
		
		If $pColumnIndex > UBound($lFields) - 1 Then
			SetError(4)
			Return 0
		EndIf
		_ArrayDelete($lFields, $pColumnIndex)
		; clear and rebuild the record
		$pRecords[$i] = ''
		For $j = 1 To UBound($lFields) - 1 Step 1
			If $j < UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j] & $pDelimiter
			ElseIf $j = UBound($lFields) - 1 Then
				$pRecords[$i] &= $lFields[$j]
			EndIf
		Next
	Next
	Return 1
EndFunc   ;==>_CSVColumnDelete
#endregion CSV Column Management
; CSV Fields Management functions
; On success, the contents of the modified csv fields array are returned as a string.
#region CSV Fields Management
;===========================================================================================
; Function Name: 	_CSVFieldsToRecord
; Description:		Converts an array to a string in csv format (with delimiters and
;					enclose chars), filling any empty fields.
; Syntax:           _CSVFieldsToRecord($pFields ,$pStartIndex ,$pNumCols [,$pDelimiter] [,$pEnclose] [,$pMode])
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
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
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
;								-	@error =6, if with $pMode=1 string to field conversion failed.
;									_CSVConvertStringToField errors can be catched with @extended.
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
		Return 0
	EndIf
	If Not IsArray($pFields) Then
		SetError(2)
		Return 0
	EndIf
	If Not IsInt($pStartIndex) Or Not IsInt($pNumCols) Or Not IsInt($pMode) Then
		SetError(3)
		Return 0
	EndIf
	If $pStartIndex < 0 Or $pNumCols < 1 Or $pMode < 0 Or $pMode > 1 Then
		SetError(4)
		Return 0
	EndIf
	If $pNumCols < UBound($pFields) - 1 Then
		SetError(5)
		Return 0
	EndIf
	For $i = $pStartIndex To $pNumCols Step 1
		$lConcat = ''
		If $i <= UBound($pFields) - 1 Then
			If $pMode = 0 Then
				$lConcat = $pFields[$i]
			ElseIf $pMode = 1 Then
				If _CSVConvertStringToField($pFields[$i], $pDelimiter, $pEnclose) Then
					$lConcat = $pFields[$i]
				Else
					SetError(6, @extended)
					Return 0
				EndIf
			EndIf
		ElseIf $i > UBound($pFields) - 1 Then
			$lConcat = '';_CSVConvertStringToField('', $pDelimiter, $pEnclose)
		EndIf
		If $i < $pNumCols Then
			$lRecord &= $lConcat & $pDelimiter
		ElseIf $i = $pNumCols Then
			$lRecord &= $lConcat
		EndIf
	Next
	Return $lRecord
EndFunc   ;==>_CSVFieldsToRecord
#endregion CSV Fields Management
; CSV Conversion functions operate ByRef.
; On success, the str or array you pass will be modified by the functions.
#region CSV Conversion Management
;===========================================================================================
; Function Name: 	_CSVConvertStringToField
; Description:		Converts a text string to csv format to store in a single field.
; Syntax:           _CSVConvertStringToField($pStr  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pStr		-	Text string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	1 is returned and $pStr contains the conversion
;					On Failure	-	Returns 0.
;					On Failure	-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									This can occur if one of the parameters passed is a composite
;									char, such as @crlf.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertStringToField(ByRef $pStr, $pDelimiter = -1, $pEnclose = -1)
	Local $lField, $lStr = ''
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not StringInStr($pStr, $pDelimiter) And Not StringInStr($pStr, $pEnclose) Then
		$lField = $pStr ; no delimiter in field
	Else
		$lStr = StringReplace($pStr, $pEnclose, $pEnclose & $pEnclose)
		If @extended = 0 Then
			$lField = $pEnclose & $pStr & $pEnclose ; delimiter in field and escaped enclose
		ElseIf @extended > 0 Then
			$lField = $pEnclose & $lStr & $pEnclose ; delimiter in field and escaped enclose
		EndIf
	EndIf
	$pStr = $lField
	Return 1
EndFunc   ;==>_CSVConvertStringToField

;===========================================================================================
; Function Name: 	_CSVConvertFieldToString
; Description:		Converts the content of a single csv field to a text string.
; Syntax:           _CSVConvertFieldToString($pRawField  [,$pDelimiter] [,$pEnclose])
; Parameter(s):     $pRawField	-	Converted Text string.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns 1
; 								-	Modifies converts $pRawField to string ByRef.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pEnclose is >1.
;									This can occur if $pEnclose is a composite char, such
;									as @crlf.
;								-	@error = 2 if $pRawField is not a string.
; Date:				20/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertFieldToString(ByRef $pRawField, $pEnclose = -1)
	Local $lStr = $pRawField ; copy so $pRawField is not affected before operations performed successfully
	If $pEnclose = -1 Then $pEnclose = '"'
	If StringLen($pEnclose) = 0 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If Not IsString($pRawField) Then
		SetError(2)
		Return 0
	EndIf
	; strip StartEnclose and EndEnclose
	If StringLeft($lStr, 1) = $pEnclose And StringRight($lStr, 1) = $pEnclose Then
		$lStr = StringRight($lStr, StringLen($lStr) - 1)
		$lStr = StringLeft($lStr, StringLen($lStr) - 1)
		$lStr = StringReplace($lStr, $pEnclose & $pEnclose, $pEnclose, 0)
	EndIf
	$pRawField = $lStr
	Return 1
EndFunc   ;==>_CSVConvertFieldToString

;===========================================================================================
; Function Name: 	_CSVConvertDelimiter
; Description:		Converts the delimiter char of a record array or single record, single or
; 					or field passed by reference.
; Syntax:           _CSVConvertDelimiter($pConvert [,$pDelimiter] [,$pEnclose] [,$pNewDelimiter])
; Parameter(s):     $pConvert	-	String or array containing multiple records (array) or
; 									single record(str), column (array) or field (str) passed.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pNewDelimiter-	Use -1 for default Opt('GUIDataSeparatorChar') char.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns 1
; 								-	Delimiter chars of $pConvert are converted by reference.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose or
;									$pNewDelimiter is >1.
;									$lConverted[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, if unable to convert $pConvert to field(s).
;									Check @extended to obtain @errors inherited from
;									_CSVRecordGetFields. If an error occurs, then the
;									function returns whatever was stored in $lConverted
;									up until the error occurred.
;								-	@error =3, if field(s) could not be converted to text.
;									Check @extended to obtain @errors inherited from
;									_CSVConvertFieldToString.
;								-	@error =4, if text to field conversion failed.
;									Check @extended to obtain @errors inherited from
;									_CSVConvertStringToField.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertDelimiter(ByRef $pConvert, $pDelimiter = -1, $pEnclose = -1, $pNewDelimiter = -1)
	Dim $lRecord[1] = [0], $lFields[1] = [0], $lConverted[1] = [0]
	Local $lField
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pNewDelimiter = -1 Then $pNewDelimiter = Opt('GUIDataSeparatorChar')
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pNewDelimiter) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Or StringLen($pNewDelimiter) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If IsArray($pConvert) Then
		For $i = 1 To UBound($pConvert) - 1 Step 1
			$lRecord = _CSVRecordGetFields($pConvert[$i], $pDelimiter, $pEnclose)
			If @error Then
				SetError(2, @error)
				Return 0
			EndIf
			ReDim $lConverted[UBound($lConverted) + 1]
			For $j = 1 To $lRecord[0] Step 1
				ReDim $lFields[UBound($lFields) + 1]
				If $lRecord[$j] = '' Then
					$lConverted[UBound($lConverted) - 1] &= $pNewDelimiter
					ContinueLoop
				EndIf
				; convert to string
				If _CSVConvertFieldToString($lRecord[$j], $pEnclose) Then
					$lFields[UBound($lFields) - 1] = $lRecord[$j] ; _CSVConvertFieldToString($lRecord[$j], $pEnclose)
				Else
					SetError(3, @error)
					Return 0
				EndIf
				; convert back to field with changed delimiter
				If Not _CSVConvertStringToField($lFields[UBound($lFields) - 1], $pNewDelimiter, $pEnclose) Then
					SetError(4, @error)
					Return 0
				EndIf
				; new delimited
				; field concatenation in record
				If $j = UBound($lRecord) - 1 Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1]
				Else ; If $j < UBound($lRecord) - 1 Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1] & $pNewDelimiter
				EndIf
			Next
		Next
		$lConverted[0] = UBound($lConverted) - 1
		$pConvert = $lConverted
	Else
		; convert to string
		$lConverted = $pConvert ; Copy $pConvert to $lConverted so no assignment until success. $lConverted type juggled
		If Not _CSVConvertFieldToString($lConverted, $pEnclose) Then
			SetError(3, @error)
			Return 0
		EndIf
		; convert back to field with changed delimiter
		If Not _CSVConvertStringToField($lConverted, $pNewDelimiter, $pEnclose) Then
			SetError(4, @error)
			Return 0
		EndIf
		; assignment only if no errors so $pConvert not converted until success
		$pConvert = $lConverted
	EndIf
	Return 1
EndFunc   ;==>_CSVConvertDelimiter

;===========================================================================================
; Function Name: 	_CSVConvertEnclose
; Description:		Converts the enclose char of a record array or single record, single or
; 					or field passed by reference.
; Syntax:           _CSVConvertEnclose($pConvert [,$pDelimiter] [,$pEnclose] [,$pNewEnclose])
; Parameter(s):     $pConvert	-	String or array containing multiple records (array) or
; 									single record(str), column (array) or field (str) passed.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pNewEnclose-	Use -1 for default single quote "'" char.
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns 1
; 								-	Enclose chars of $pConvert are converted by reference.
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pEnclose or
;									$pNewEnclose is >1.
;									$lConverted[0]=0 is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error =2, if unable to convert $pConvert to field(s).
;									Check @extended to obtain @errors inherited from
;									_CSVRecordGetFields. If an error occurs, then the
;									function returns whatever was stored in $lConverted
;									up until the error occurred.
;								-	@error =3, if field(s) could not be converted to text.
;									Check @extended to obtain @errors inherited from
;									_CSVConvertFieldToString
;								-	@error =4, if text to field conversion failed.
;									Check @extended to obtain @errors inherited from
;									_CSVConvertStringToField.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertEnclose(ByRef $pConvert, $pDelimiter = -1, $pEnclose = -1, $pNewEnclose = -1)
	Dim $lRecord[1] = [0], $lFields[1] = [0], $lConverted[1] = [0]
	Local $lField
	If $pDelimiter = -1 Then $pDelimiter = ','
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pNewEnclose = -1 Then $pNewEnclose = "'"
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pNewEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Or StringLen($pNewEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If IsArray($pConvert) Then
		For $i = 1 To UBound($pConvert) - 1 Step 1
			$lRecord = _CSVRecordGetFields($pConvert[$i], $pDelimiter, $pEnclose)
			If @error Then
				SetError(1, @error)
				Return 0
			EndIf
			ReDim $lConverted[UBound($lConverted) + 1]
			For $j = 1 To $lRecord[0] Step 1
				ReDim $lFields[UBound($lFields) + 1]
				If $lRecord[$j] = '' Then
					$lConverted[UBound($lConverted) - 1] &= $pDelimiter
					ContinueLoop
				EndIf
				; convert to string
				If _CSVConvertFieldToString($lRecord[$j], $pEnclose) Then
					$lFields[UBound($lFields) - 1] = $lRecord[$j]
				Else
					SetError(3, @error)
					Return 0
				EndIf
				; convert back to field with changed Enclose
				If Not _CSVConvertStringToField($lFields[UBound($lFields) - 1], $pDelimiter, $pNewEnclose) Then
					SetError(4, @error)
					Return 0
				EndIf
				; field concatenation in record
				If $j = $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1]
				Else ; If $j < $lRecord[0] Then
					$lConverted[UBound($lConverted) - 1] &= $lFields[UBound($lFields) - 1] & $pDelimiter
				EndIf
			Next
		Next
		$lConverted[0] = UBound($lConverted) - 1
		$pConvert = $lConverted
	Else
		; convert to string
		$lConverted = $pConvert ; Copy $pConvert to $lConverted so no assignment until success. $lConverted type juggled
		If Not _CSVConvertFieldToString($lConverted, $pEnclose) Then
			SetError(3, @error)
			Return 0
		EndIf
		; convert back to field with changed Enclose
		If Not _CSVConvertStringToField($lConverted, $pDelimiter, $pNewEnclose) Then
			SetError(4, @error)
			Return 0
		EndIf
		; assignment only if no errors so $pConvert not converted until success
		$pConvert = $lConverted
	EndIf
	Return 1
EndFunc   ;==>_CSVConvertEnclose
#endregion CSV Conversion Management
; CSV Misc functions.
; Multiple operation can be conducted, such as search, convert line breaks back and forth.
#region CSV Misc Management
;===========================================================================================
; Function Name: 	_CSVSearch
; Description:		Search for $pSearchStr in $pRecords, where $pRecords is either a single
; 					record (string) or multiple records (array), returning a 2Dim array
; 					containing the search results.
; Syntax:           _CSVSearch($pRecords, $pSearchStr, [,$pDelimiter] [,$pEnclose] [,$pCaseSense] [$pMode = 0] )
; Parameter(s):     $pRecords	-	Single record (string) or multiple records (array).
;					$pSearchStr	-	String to search for.
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pCaseSense	-	Use 0 for case insensitive search.
;									Use 1 for case sensitive search
;					$pMode		-	Use 0 (default) for raw csv search
;									Use 1 for text search.
; Requirement(s):   				none
; Return Value(s):  On Success	-	Returns a 2 Dim array with values as follow:
;									$lResult[0][0] = number of matched items
;									$lResult[0][0] = 0 if no matches found
;									$lResult[$i][0] = record number of found item
;									$lResult[$i][1] = column number of found item
;									$lResult[$i][2] = record where item was found
;									$lResult[$i][3] = field where item was found
;					On Failure	-	return 0
;								-	@error = 1 if the length of $pDelimiter or $pEnclose is >1.
;									lRecord = '' is returned. This can occur if one of the
;									parameters passed is a composite char, such as @crlf.
;								-	@error = 2 if field extraction failed via _CSVRecordGetFields.
;									Error can be retreived via @extended.
;								-	@error = 3 if field to string conversion failed via
;									_CSVConvertFieldToString under $pMode = 1.
;									Error can be retreived via @extended.
; Date:				16/01/07
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVSearch($pRecords, $pSearchStr, $pDelimiter = -1, $pEnclose = -1, $pCaseSense = 0, $pMode = 0)
	Dim $lRecords[1] = [0], $lFields[1] = [0]
	Dim $lResult[1][4]
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pDelimiter = -1 Then $pDelimiter = ','
	If StringLen($pDelimiter) = 0 Or StringLen($pEnclose) = 0 Or StringLen($pDelimiter) > 1 Or StringLen($pEnclose) > 1 Then
		SetError(1)
		Return 0
	EndIf
	If IsArray($pRecords) Then ; case array
		For $i = 1 To UBound($pRecords) - 1 Step 1
			$lFields = _CSVRecordGetFields($pRecords[$i], $pDelimiter, $pEnclose)
			If @error Then
				SetError(2, @error)
				Return 0
			EndIf
			For $j = 1 To UBound($lFields) - 1 Step 1
				If $pMode = 1 Then
					If Not _CSVConvertFieldToString($lFields[$j], $pEnclose) Then
						SetError(3, @extended)
						Return 0
					EndIf
				EndIf
				If StringInStr($lFields[$j], $pSearchStr, $pCaseSense) Then
					ReDim $lResult[UBound($lResult) + 1][4]
					$lResult[UBound($lResult) - 1][0] = $i ; record num
					$lResult[UBound($lResult) - 1][1] = $j ; col num
					$lResult[UBound($lResult) - 1][2] = $pRecords[$i] ; record
					$lResult[UBound($lResult) - 1][3] = $lFields[$j] ; field
				EndIf
			Next
		Next
	ElseIf IsString($pRecords) Then ; case string
		$lFields = _CSVRecordGetFields($pRecords, $pDelimiter, $pEnclose)
		If @error Then
			SetError(2, @error)
			Return 0
		EndIf
		For $i = 1 To UBound($lFields) - 1 Step 1
			If $pMode = 1 Then
				If Not _CSVConvertFieldToString($lFields[$i], $pEnclose) Then
					SetError(3, @extended)
					Return 0
				EndIf
			EndIf
			If StringInStr($lFields[$i], $pSearchStr, $pCaseSense) Then
				ReDim $lResult[UBound($lResult) + 1][4]
				$lResult[UBound($lResult) - 1][0] = 1 ; record num
				$lResult[UBound($lResult) - 1][1] = $i ; col num
				$lResult[UBound($lResult) - 1][2] = $pRecords ; record
				$lResult[UBound($lResult) - 1][3] = $lFields[$i] ; field
			EndIf
		Next
	EndIf
	$lResult[0][0] = UBound($lResult) - 1
	Return $lResult
EndFunc   ;==>_CSVSearch

;===========================================================================================
; Function Name: 	_CSVConvertLineBreak
; Description:		Encodes or Decodes the line break (either @CR or @LF, therefore, also converts
;					the combined @CRLF) in a single field (string) or multiple fields (array).
;					$pMode = 0 will encode line breaks (@CR, @LF and @CRLF) from a field(s)
;					using the chars passed in $pConvertCR and $pConvertLF, whereas $pMode = 1
;					will decode chars passed in $pConvertCR and $pConvertLF back to breaks
;					(@CR, @LF and @CRLF) in the field(s).
; Syntax:           _CSVConvertLineBreak($pConvert [,$pDelimiter] [,$pEnclose] [,$pNewDelimiter])
; Parameter(s):     $pFields	-	Fields array or single field string.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pConvertCR	-	Use -1 for default @CR encoding char =^.
;					$pConvertLF	-	Use -1 for default @CR encoding char =~.
;					$pMode		-	Use 0 (default) to encode a text field with breaks
;									Use 1 to decode a csv field with breaks back to text
; Requirement(s):   None
; Return Value(s):  On Success	-	Returns 1
; 									Array or value passed in $pFields is modified ByRef
;					On Failure	-	Returns 0.
;								-	@error = 1 if the length of $pDelimiter or $pConvertCR or
;									$pConvertLF is <>1.
;									This can occur if one of the parameters passed is a
;									composite char, such as @crlf, or if you pass a string
;									longer than 1 char in length.
;								-	@error =2, if break encoding failed.
;								-	@error =3, if break decoding failed.
; Date:				26/12/06
; Author:			IVAN PEREZ
;===========================================================================================
Func _CSVConvertLineBreak(ByRef $pFields, $pEnclose = -1, $pConvertCR = -1, $pConvertLF = -1, $pMode = 0)
	If $pEnclose = -1 Then $pEnclose = '"'
	If $pConvertCR = -1 Then $pConvertCR = '^' ; uncommon chars will increase execution speed
	If $pConvertLF = -1 Then $pConvertLF = '~' ; uncommon chars will increase execution speed
	Dim $lLinesCR, $lLinesLF
	Local $lLineCR, $lLineLF, $lLine
	Local $nOffset = 1, $lEvalCr, $lEvalLf
	Dim $lEscapedChars[1]
	If StringLen($pEnclose) <> 1 Or StringLen($pConvertCR) <> 1 Or StringLen($pConvertLF) <> 1 Then
		SetError(1)
		Return 0
	EndIf
	If IsArray($pFields) Then ; fields array
		For $i = 1 To UBound($pFields) - 1 Step 1
			If $pMode = 0 Then ; encode breaks
				If StringInStr($pFields[$i], @CR) And StringInStr($pFields[$i], $pConvertCR) Then
;~ 					MsgBox(0, 'encode cr', '')
					$lLinesCR = _CSVRecordGetFields($pFields[$i], @CR, $pEnclose) ; split to array
					If @error Then
						SetError(2)
						Return 0
					EndIf
					For $j = 1 To $lLinesCR[0] Step 1
						_CSVConvertStringToField($lLinesCR[$j], $pConvertCR, $pEnclose)
					Next
					$lLine = _CSVFieldsToRecord($lLinesCR, 1, -1, $pConvertCR, $pEnclose)
					If @error Then
						SetError(2)
						Return 0
					EndIf
				ElseIf StringInStr($pFields[$i], @CR) And Not StringInStr($pFields[$i], $pConvertCR) Then
					$lLine = StringReplace($pFields[$i], @CR, $pConvertCR)
				Else
					$lLine = $pFields[$i]
				EndIf
				
				If StringInStr($pFields[$i], @LF) And StringInStr($pFields[$i], $pConvertLF) Then
;~ 					MsgBox(0, 'encode lf', '')
					$lLinesLF = _CSVRecordGetFields($lLine, @LF, $pEnclose) ; split to array
					If @error Then
						SetError(2)
						Return 0
					EndIf
					For $j = 1 To $lLinesLF[0] Step 1
						_CSVConvertStringToField($lLinesLF[$j], $pConvertLF, $pEnclose)
						If @error Then
							SetError(2)
							Return 0
						EndIf
					Next
					$lLine = _CSVFieldsToRecord($lLinesLF, 1, -1, $pConvertLF, $pEnclose)
					If @error Then
						SetError(2)
						Return 0
					EndIf
				ElseIf StringInStr($pFields[$i], @LF) And Not StringInStr($pFields[$i], $pConvertLF) Then
					$lLine = StringReplace($lLine, @LF, $pConvertLF)
				EndIf
				
				$pFields[$i] = $lLine
				
			ElseIf $pMode = 1 Then ; decode breaks
				Local $lDecodeCR = 0, $lDecodeLF = 0, $lIsEnclosed = 0, $lConsecutiveEnclose = 0, $lIsEscapedEnclosed = 0, $lCheckEscapedEnclosure = ''
				; check enclosure
				For $j = 1 To StringLen($pFields[$i]) Step 1
					If StringMid($pFields[$i], $j, 1) == $pEnclose Then
						$lConsecutiveEnclose += 1
					Else
						ExitLoop
					EndIf
				Next
				; check escaped enclosure
				If Mod($lConsecutiveEnclose, 2) <> 0 Then
					$lIsEnclosed = 1
					For $j = ($lConsecutiveEnclose + 1) To StringLen($pFields[$i]) Step 1
						$lCheckEscapedEnclosure = StringMid($pFields[$i], $j, 3)
						If $lCheckEscapedEnclosure = $pEnclose & $pConvertCR & $pEnclose Or $lCheckEscapedEnclosure = $pEnclose & $pConvertLF & $pEnclose Then
							$lIsEscapedEnclosed = 1
							ExitLoop
						EndIf
					Next
				EndIf
;~ 				ConsoleWrite(@CRLF & 'ENCLOSURE:' & @CRLF & '$lIsEnclosed=' & $lIsEnclosed & @CRLF & '$lIsEscapedEnclosed=' & $lIsEscapedEnclosed & @CRLF)
				$lLine = $pFields[$i]
				Switch $lIsEnclosed
					Case 0 ; not enclosed
;~ 						MsgBox(0, '', 'not enclosed')
						Select ; faster if straight stringreplace
							Case StringInStr($pFields[$i], $pConvertLF) And StringInStr($pFields[$i], $pConvertCR)
;~ 								MsgBox(0, 'decode crlf', 'not enclosed')
								$lDecodeCR = 1
								$lDecodeLF = 1
							Case StringInStr($pFields[$i], $pConvertCR) ;And Not StringInStr($pFields[$i], $pConvertCR))
;~ 								MsgBox(0, 'decode cr', 'not enclosed')
								$lDecodeCR = 1
							Case StringInStr($pFields[$i], $pConvertLF) ;And StringInStr($pFields[$i], $pConvertCR))
;~ 								MsgBox(0, 'decode lf', 'not enclosed')
								$lDecodeLF = 1
						EndSelect
					Case 1 ; enclosed
						If $lIsEscapedEnclosed Then
							$nOffset = 1
							While 1 ; evaluate cr and lf
								$lEscapedChars = StringRegExp($pFields[$i], '.' & $pEnclose & '+', 1, $nOffset)
								If @error = 0 Then
									$nOffset = @extended
								Else
									ExitLoop
								EndIf
								For $j = 0 To UBound($lEscapedChars) - 1
									If Not StringInStr($lEscapedChars[$j], $pEnclose) Then ContinueLoop
									If StringInStr($lEscapedChars[$j], $pConvertCR) Then
										$lEvalCr = StringReplace($lEscapedChars[$j], $pConvertLF, '')
										$lEvalCr = StringSplit($lEscapedChars[$j], $pConvertCR)
										If IsArray($lEvalCr) Then
											If Mod(StringLen($lEvalCr[UBound($lEvalCr) - 1]), 2) <> 0 Then $lDecodeCR = 1
										EndIf
									EndIf
									If StringInStr($lEscapedChars[$j], $pConvertLF) Then
										$lEvalLf = StringReplace($lEscapedChars[$j], $pConvertCR, '')
										$lEvalLf = StringSplit($lEscapedChars[$j], $pConvertLF)
										If IsArray($lEvalLf) Then
											If Mod(StringLen($lEvalLf[UBound($lEvalLf) - 1]), 2) <> 0 Then $lDecodeLF = 1
										EndIf
									EndIf
								Next
							WEnd
						ElseIf Not $lIsEscapedEnclosed Then ; case no escaped enclose
;~ 							MsgBox(0, 'case no escaped enclose', '')
							Select ; faster if straight stringreplace
								Case StringInStr($pFields[$i], $pConvertLF) And StringInStr($pFields[$i], $pConvertCR)
;~ 									MsgBox(0, 'decode crlf', 'not enclosed')
									$lDecodeCR = 1
									$lDecodeLF = 1
								Case StringInStr($pFields[$i], $pConvertCR) ;And Not StringInStr($pFields[$i], $pConvertCR))
;~ 									MsgBox(0, 'decode cr', 'not enclosed')
									$lDecodeCR = 1
								Case StringInStr($pFields[$i], $pConvertLF) ;And StringInStr($pFields[$i], $pConvertCR))
;~ 									MsgBox(0, 'decode lf', 'not enclosed')
									$lDecodeLF = 1
							EndSelect
						EndIf
				EndSwitch
;~ 				ConsoleWrite(@CRLF & 'CONVERSION CRITERIA' & @CRLF & '$pConvertLF=' & $lDecodeLF & @CRLF & '$pConvertCR=' & $lDecodeCR)
				
				If $lDecodeLF Then
;~ 					MsgBox(0, 'decode lf', '')
					$lLinesLF = _CSVRecordGetFields($pFields[$i], $pConvertLF, $pEnclose) ; split to array
					If @error Then
						SetError(3)
						Return 0
					EndIf
					For $j = 1 To $lLinesLF[0] Step 1
						_CSVConvertFieldToString($lLinesLF[$j], $pEnclose)
						If @error Then
							SetError(3)
							Return 0
						EndIf
					Next
					$lLine = _CSVFieldsToRecord($lLinesLF, 1, -1, @LF, $pEnclose)
					If @error Then
						SetError(3)
						Return 0
					EndIf
				Else
					$lLine = $pFields[$i]
				EndIf
				
				If $lDecodeCR Then
;~ 					MsgBox(0, 'decode cr', '')
					$lLinesCR = _CSVRecordGetFields($lLine, $pConvertCR, $pEnclose) ; split to array
					If @error Then
						SetError(3)
						Return 0
					EndIf
					For $j = 1 To $lLinesCR[0] Step 1
						_CSVConvertFieldToString($lLinesCR[$j], $pEnclose)
						If @error Then
							SetError(3)
							Return 0
						EndIf
					Next
					$lLine = _CSVFieldsToRecord($lLinesCR, 1, -1, @CR, $pEnclose)
					If @error Then
						SetError(3)
						Return 0
					EndIf
				EndIf
				_CSVConvertFieldToString($lLine, $pEnclose)
				If @error Then
					SetError(3)
					Return 0
				EndIf
				$pFields[$i] = $lLine
				
			EndIf
		Next
	ElseIf IsString($pFields) Then ; field string
		If $pMode = 0 Then ; encode breaks
			If StringInStr($pFields, @CR) And StringInStr($pFields, $pConvertCR) Then
;~ 				MsgBox(0, 'encode cr', '')
				$lLinesCR = _CSVRecordGetFields($pFields, @CR, $pEnclose) ; split to array
				If @error Then
					SetError(2)
					Return 0
				EndIf
				For $i = 1 To $lLinesCR[0] Step 1
					_CSVConvertStringToField($lLinesCR[$i], $pConvertCR, $pEnclose)
					If @error Then
						SetError(2)
						Return 0
					EndIf
				Next
				$lLine = _CSVFieldsToRecord($lLinesCR, 1, -1, $pConvertCR, $pEnclose)
				If @error Then
					SetError(2)
					Return 0
				EndIf
			ElseIf StringInStr($pFields, @CR) And Not StringInStr($pFields, $pConvertCR) Then
				$lLine = StringReplace($pFields, @CR, $pConvertCR)
			Else
				$lLine = $pFields
			EndIf
			
			If StringInStr($pFields, @LF) And StringInStr($pFields, $pConvertLF) Then
;~ 				MsgBox(0, 'encode lf', '')
				$lLinesLF = _CSVRecordGetFields($lLine, @LF, $pEnclose) ; split to array
				If @error Then
					SetError(2)
					Return 0
				EndIf
				For $i = 1 To $lLinesLF[0] Step 1
					_CSVConvertStringToField($lLinesLF[$i], $pConvertLF, $pEnclose)
					If @error Then
						SetError(2)
						Return 0
					EndIf
				Next
				$lLine = _CSVFieldsToRecord($lLinesLF, 1, -1, $pConvertLF, $pEnclose)
				If @error Then
					SetError(2)
					Return 0
				EndIf
			ElseIf StringInStr($pFields, @LF) And Not StringInStr($pFields, $pConvertLF) Then
				$lLine = StringReplace($lLine, @LF, $pConvertLF)
			EndIf
			
			$pFields = $lLine
			
		ElseIf $pMode = 1 Then ; decode breaks
			Local $lDecodeCR = 0, $lDecodeLF = 0, $lIsEnclosed = 0, $lConsecutiveEnclose = 0, $lIsEscapedEnclosed = 0, $lCheckEscapedEnclosure = ''
			; check enclosure
			For $i = 1 To StringLen($pFields) Step 1
				If StringMid($pFields, $i, 1) == $pEnclose Then
					$lConsecutiveEnclose += 1
				Else
					ExitLoop
				EndIf
			Next
			; check escaped enclosure
			If Mod($lConsecutiveEnclose, 2) <> 0 Then
				$lIsEnclosed = 1
				For $i = ($lConsecutiveEnclose + 1) To StringLen($pFields) Step 1
					$lCheckEscapedEnclosure = StringMid($pFields, $i, 3)
					If $lCheckEscapedEnclosure = $pEnclose & $pConvertCR & $pEnclose Or $lCheckEscapedEnclosure = $pEnclose & $pConvertLF & $pEnclose Then
						$lIsEscapedEnclosed = 1
						ExitLoop
					EndIf
				Next
			EndIf
;~ 			ConsoleWrite(@CRLF & 'ENCLOSURE:' & @CRLF & '$lIsEnclosed=' & $lIsEnclosed & @CRLF & '$lIsEscapedEnclosed=' & $lIsEscapedEnclosed & @CRLF)
			$lLine = $pFields
			Switch $lIsEnclosed
				Case 0 ; not enclosed
;~ 					MsgBox(0, '', 'not enclosed')
					Select ; faster if straight stringreplace
						Case StringInStr($pFields, $pConvertLF) And StringInStr($pFields, $pConvertCR)
;~ 							MsgBox(0, 'decode crlf', 'not enclosed')
							$lDecodeCR = 1
							$lDecodeLF = 1
						Case StringInStr($pFields, $pConvertCR) ;And Not StringInStr($pFields, $pConvertCR))
;~ 							MsgBox(0, 'decode cr', 'not enclosed')
							$lDecodeCR = 1
						Case StringInStr($pFields, $pConvertLF) ;And StringInStr($pFields, $pConvertCR))
;~ 							MsgBox(0, 'decode lf', 'not enclosed')
							$lDecodeLF = 1
					EndSelect
				Case 1 ; enclosed
					If $lIsEscapedEnclosed Then
						$nOffset = 1
						While 1 ; evaluate cr and lf
							$lEscapedChars = StringRegExp($pFields, '.' & $pEnclose & '+', 1, $nOffset)
							If @error = 0 Then
								$nOffset = @extended
							Else
								ExitLoop
							EndIf
							For $i = 0 To UBound($lEscapedChars) - 1
								If Not StringInStr($lEscapedChars[$i], $pEnclose) Then ContinueLoop
								If StringInStr($lEscapedChars[$i], $pConvertCR) Then
									$lEvalCr = StringReplace($lEscapedChars[$i], $pConvertLF, '')
									$lEvalCr = StringSplit($lEscapedChars[$i], $pConvertCR)
									If IsArray($lEvalCr) Then
										If Mod(StringLen($lEvalCr[UBound($lEvalCr) - 1]), 2) <> 0 Then $lDecodeCR = 1
									EndIf
								EndIf
								If StringInStr($lEscapedChars[$i], $pConvertLF) Then
									$lEvalLf = StringReplace($lEscapedChars[$i], $pConvertCR, '')
									$lEvalLf = StringSplit($lEscapedChars[$i], $pConvertLF)
									If IsArray($lEvalLf) Then
										If Mod(StringLen($lEvalLf[UBound($lEvalLf) - 1]), 2) <> 0 Then $lDecodeLF = 1
									EndIf
								EndIf
							Next
						WEnd
					ElseIf Not $lIsEscapedEnclosed Then ; case no escaped enclose
;~ 						MsgBox(0, 'case no escaped enclose', '')
						Select ; faster if straight stringreplace
							Case StringInStr($pFields, $pConvertLF) And StringInStr($pFields, $pConvertCR)
;~ 								MsgBox(0, 'decode crlf', 'not enclosed')
								$lDecodeCR = 1
								$lDecodeLF = 1
							Case StringInStr($pFields, $pConvertCR) ;And Not StringInStr($pFields, $pConvertCR))
;~ 								MsgBox(0, 'decode cr', 'not enclosed')
								$lDecodeCR = 1
							Case StringInStr($pFields, $pConvertLF) ;And StringInStr($pFields, $pConvertCR))
;~ 								MsgBox(0, 'decode lf', 'not enclosed')
								$lDecodeLF = 1
						EndSelect
					EndIf
			EndSwitch
;~ 			ConsoleWrite(@CRLF & 'CONVERSION CRITERIA' & @CRLF & '$pConvertLF=' & $lDecodeLF & @CRLF & '$pConvertCR=' & $lDecodeCR)
			
			If $lDecodeLF Then
;~ 				MsgBox(0, 'decode lf', '')
				$lLinesLF = _CSVRecordGetFields($pFields, $pConvertLF, $pEnclose) ; split to array
				If @error Then
					SetError(3)
					Return 0
				EndIf
				For $i = 1 To $lLinesLF[0] Step 1
					_CSVConvertFieldToString($lLinesLF[$i], $pEnclose)
					If @error Then
						SetError(3)
						Return 0
					EndIf
				Next
				$lLine = _CSVFieldsToRecord($lLinesLF, 1, -1, @LF, $pEnclose)
				If @error Then
					SetError(3)
					Return 0
				EndIf
			Else
				$lLine = $pFields
			EndIf
			
			If $lDecodeCR Then
;~ 				MsgBox(0, 'decode cr', '')
				$lLinesCR = _CSVRecordGetFields($lLine, $pConvertCR, $pEnclose) ; split to array
				If @error Then
					SetError(3)
					Return 0
				EndIf
				For $i = 1 To $lLinesCR[0] Step 1
					_CSVConvertFieldToString($lLinesCR[$i], $pEnclose)
					If @error Then
						SetError(3)
						Return 0
					EndIf
				Next
				$lLine = _CSVFieldsToRecord($lLinesCR, 1, -1, @CR, $pEnclose)
				If @error Then
					SetError(3)
					Return 0
				EndIf
			EndIf
			_CSVConvertFieldToString($lLine, $pEnclose)
			If @error Then
				SetError(3)
				Return 0
			EndIf
			$pFields = $lLine
			
		EndIf
	EndIf
	Return 1
EndFunc   ;==>_CSVConvertLineBreak
#endregion CSV Misc Management

;<FIX!!! IS REDUNDANT? use _CSVFieldsToRecord instead!> ===========================================================================================
; Function Name: 	_CSVConvertRecordToString
; Description:		Converts a given Record (single csv line) to a string delimited by passed
;					$pGUIDelimiter. I believe this function is redundant and may remove it
;					from the lib.
; Syntax:           _CSVRecordToString($pRecord  [,$pDelimiter] [,$pEnclose] [,$pGUIDelimiter])
; Parameter(s):     $pRecord	-	Raw record (csv line).
;					$pDelimiter	-	Use -1 for default field separator char ','.
;					$pEnclose	-	Use -1 for default quote char '"'.
;					$pGUIDelimiter	-	Use -1 for default GUIDataSeparatorChar.
; Requirement(s):   String representation of record delimited by $pGUIDelimiter
; Return Value(s):  On Success	-	Returns 1 and $pRecord string is $pGUIDelimiter delimited
;					On Failure	-	Returns 0.
;								-	@error = 1 if record string could not be converted to
;									fields array. Conversion error can be checked with
;									@extended.
;								-	@error = 2 if fields could not be converted to text
;									delimited by $pGUIDelimiter.
;									Conversion error can be checked with @extended.
; Date:				29/12/06
; Author:			IVAN PEREZ
;===========================================================================================
;~ Func _CSVRecordConvertToString(ByRef $pRecord, $pDelimiter = -1, $pEnclose = -1, $pGUIDelimiter = -1)
;~ 	If $pEnclose = -1 Then $pEnclose = '"'
;~ 	If $pDelimiter = -1 Then $pDelimiter = ','
;~ 	If $pGUIDelimiter = -1 Then $pGUIDelimiter = Opt('GUIDataSeparatorChar')
;~ 	Dim $lFields
;~ 	Local $lRecord = ''
;~ 	; Populate the text list
;~ 	$lFields = _CSVRecordGetFields($pRecord, $pDelimiter, $pEnclose)
;~ 	If @error Then
;~ 		SetError(1, @error)
;~ 		Return 0
;~ 	EndIf
;~ 	For $i = 1 To UBound($lFields) - 1 Step 1
;~ 		If $i < UBound($lFields) - 1 Then
;~ 			If _CSVConvertFieldToString($lFields[$i], $pEnclose) Then
;~ 				$lRecord &= $lFields[$i] & $pGUIDelimiter
;~ 			Else
;~ 				SetError(2, @error)
;~ 				Return 0
;~ 			EndIf
;~ 		EndIf
;~ 		If $i = UBound($lFields) - 1 Then
;~ 			If _CSVConvertFieldToString($lFields[$i], $pEnclose) Then
;~ 				$lRecord &= $lFields[$i]
;~ 			Else
;~ 				SetError(2, @error)
;~ 				Return 0
;~ 			EndIf
;~ 		EndIf
;~ 	Next
;~ 	$pRecord = $lRecord
;~ 	Return 1
;~ EndFunc   ;==>_CSVRecordConvertToString