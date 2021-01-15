; PREG-based CSV file parser.
; Copyright 2007, Ed Fletcher

#include-once

;===============================================================================
;
; Description:      Reads a CSV file into a 2D array
; Parameter(s):     $sPath       - Path to the CSV file to read
;                   $cSeparator  - Separator character, default is comma (,)
; Requirement(s):   None
; Return Value(s):  On Success - 2D CSV array
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - File not found/openable
;                                               2 - File read error
;                                               3 - CSV format error
; Author(s):        Ed Fletcher
; Note(s):          Pattern based on work by Jeffrey E. F. Friedl in
;                   "Mastering Regular Expressions, 2nd Edition"
;===============================================================================
Func _CSVReadFile( $path, $separator=',' )

	;; open the file and read the entire CSV dataset into one string.

	Local $hFile = FileOpen( $path, 0 )
	If $hFile == -1 Then
		SetError( 1 )
		Return 0
	EndIf

	Local $sRawData = FileRead( $hFile )
	If @error > 0 Then
		FileClose( $hFile )
		SetError( 2 )
		Return 0
	EndIf

	FileClose( $hFile )


	;; parse the string into an array of matched fields

	Local $pattern = '(?m)'                      ; multi-line search mode
	$pattern &= '\G(?:^|[' & $separator & '])'   ; start of line or start of field
	$pattern &= '(?:'                            ; one of two options:
	$pattern &= '"'                              ;   a field starting with at double quote
	$pattern &= '([^"]*+(?:""[^"]*+)*+)'         ;   (quote-pairs and any non-quote chars)
	$pattern &= '"'                              ;   a double quote ending the field
	$pattern &= '(\r?\n?)'                       ;   (any sort of line ending here?)
	$pattern &= '|'                              ; or:
	$pattern &= '([^"' & $separator & '\r\n]*+)' ;   (a simple CSV field, no quotes or commas)
	$pattern &= '(\r?\n?)'                       ;   (any sort of line ending here?)
	$pattern &= ')'                              ; note that we should have 4 captures per CSV element

	Local $aRawData = StringRegExp( $sRawData, $pattern, 4 )
	If @error <> 0 Then
		Die( 'Error: ' & @error )
		SetError( 3 )
		Return 0
	EndIf

	$sRawData = ''  ; we're done with this, and it might be large

	; $aRawData is a 1D array containing every field in the CSV file.  Each element
	; in $aRawData is an array of 5 strings, like so:
	; 0 - all of the characters consumed while matching this field
	; 1 - field contents, if the field was double quoted
	; 2 - a line ending, if the field was double quoted and this is the end of the line
	; 3 - field contents, if the field was *not* double quoted
	; 4 - a line ending, if the field was *not* double quoted and this is the end of the line


	;; pass through the results once to determine the number of rows and the max number of columns

	Local $i, $aMatch
	Local $colCount = 0, $maxCols = 0
	Local $rowCount = 0

	For $i=0 To UBound($aRawData)-1
		$aMatch = $aRawData[$i]

		If $colCount == 0 Then
			$rowCount += 1			; we're looking at the first field on the current row
		EndIf

		$colCount += 1

		If $colCount > $maxCols Then
			$maxCols = $colCount	; longest row so far...
		EndIf

		If $aMatch[2] <> '' OR (UBound($aMatch) > 3 AND $aMatch[4] <> '') Then
			$colCount = 0			; row complete, we might start a new one
		EndIf
	Next

	;; we now know how large to make our 2D output array
	
	Local $aCsvData[$rowCount][$maxCols]


	;; finally, populate our output array

	Local $row = 0, $col = 0

	For $i=0 To UBound($aRawData)-1
		$aMatch = $aRawData[$i]

		If UBound($aMatch) > 3 AND $aMatch[3] <> '' Then
			; It was a simple field, no processing required
			$aCsvData[$row][$col] = $aMatch[3]
		Else
			; It was a quoted value, so take care of embedded double quotes
			$aCsvData[$row][$col] = StringReplace($aMatch[1], '""', '"')
		EndIf

		$col += 1

		; now look for a line ending that ends the current data row
		If $aMatch[2] <> '' OR (UBound($aMatch) > 3 AND $aMatch[4] <> '') Then
			$row += 1
			$col = 0
		EndIf
	Next

	Return $aCsvData
EndFunc

;===============================================================================
;
; Description:      Pulls a single column out of a 2D array
; Parameter(s):     $aCSV    - 2D array to work with
;                   $colNum  - Column index, 0-based
; Requirement(s):   None
; Return Value(s):  An array of columnar data
; Note(s):
;
;===============================================================================
Func _CSVGetColumn( $aCSV, $colNum )
	Local $aColumn[UBound($aCSV)]
	Local $i

	For $i=0 To UBound($aCSV)-1
		$aColumn[$i] = $aCSV[$i][$colNum]
	Next

	Return $aColumn
EndFunc

;===============================================================================
;
; Description:      Pulls a single row out of a 2D array
; Parameter(s):     $aCSV       - 2D array to work with
;                   $rowNum     - Row index, 0-based
; Requirement(s):   None
; Return Value(s):  An array of row data
; Note(s):
;
;===============================================================================
Func _CSVGetRow( $aCSV, $rowNum )
	Local $aRow[UBound($aCSV, 2)]
	Local $i

	For $i=0 To UBound($aCSV, 2)-1
		$aRow[$i] = $aCSV[$rowNum][$i]
	Next

	Return $aRow
EndFunc

;===============================================================================
;
; Description:      Test function for _CSVReadFile()
; Parameter(s):     $sPath   - Path to the file to read, default is 'test.csv'
; Requirement(s):   None
; Return Value(s):  None
; Note(s):			Dumps out array data via ConsoleWrite()
;
;===============================================================================
Func _CSVTest( $file = "test.csv" )
	Local $output = _CSVReadFile( $file )

	If @error <> 0 Then
		ConsoleWriteError( "Error " & @error & " reading file [" & $file & "]" & @CR )
		Exit
	EndIf

	Local $i, $j
	For $i=0 To UBound($output)-1
		For $j=0 To UBound($output, 2)-1
			ConsoleWrite('[' & $output[$i][$j] & ']')
		Next
		ConsoleWrite(@CR)
	Next
EndFunc

If @ScriptName == 'LibCsv2.au3' Then
	_CSVTest(@ScriptDir & "\..\temp\test.csv")
EndIf
