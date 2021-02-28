; PREG-based CSV file parser.
; Copyright 2007, Ed Fletcher

; Modifications by FichteFoll, (02-2012):
;   - added $cEnclose parameter for defining the enclosing character (default: ")
;   - have _CSVGetColumn and _CSVGetRow use Const ByRef for the first param to save ressources
;   - allow _CSVGetColumn and _CSVGetRow to use negative numbers as index (parsing backwards)
;     and add some error handling for invalid parameters
;   - fix use of "Die" as debug function since this is not defined
;   - modified _CSVTest to accept the same parameters as _CSVReadFile

; #AutoIt3Wrapper_AU3Check_Parameters=-d -w 3 -w 4 -w 5 -w 6
#include-once

;===============================================================================
;
; Description:      Reads a CSV file into a 2D array
; Parameter(s):     $sPath       - Path to the CSV file to read
;                   $cSeparator  - Separator character, default is comma (,)
;                   $cEnclose    - Character used in enclosings, default is "
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
Func _CSVReadFile( $path, $separator = ',', $enclose = '"' )

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
	$pattern &= $enclose                         ;   a field starting with at double quote
	$pattern &= StringFormat('([^%s]*+(?:%s%s[^%s]*+)*+)', $enclose, $enclose, $enclose, $enclose)
	;                                            ;   (quote-pairs and any non-quote chars)
	$pattern &= $enclose                         ;   a double quote ending the field
	$pattern &= '(\r?\n?)'                       ;   (any sort of line ending here?)
	$pattern &= '|'                              ; or:
	$pattern &= '([^"' & $separator & '\r\n]*+)' ;   (a simple CSV field, no quotes or commas)
	$pattern &= '(\r?\n?)'                       ;   (any sort of line ending here?)
	$pattern &= ')'                              ; note that we should have 4 captures per CSV element

	Local $aRawData = StringRegExp( $sRawData, $pattern, 4 )
	If @error <> 0 Then
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
; Parameter(s):     $aCSV      - 2D array to work with; Const ByRef
;                   $colNum    - Column index, 0-based;
;                                Negative numbers for backwards parsing are allowed
; Requirement(s):   None
; Return Value(s):  On Success - An array of columnar data
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Dimension mismatch; only 2D arrays!
;                                               2 - $colNum is invalid
;                                               3 - $colNum exceeds column count
; Note(s):
;
;===============================================================================
Func _CSVGetColumn( Const ByRef $aCSV, $colNum )
	; test array dimensions
	If UBound($aCSV, 0) <> 2 Then
		SetError( 1 )
		Return 0
	EndIf
	; test second parameter for validity
	$colNum = Int($colNum) ; cast strings
	If Not IsInt($colNum) Then
		SetError( 2 )
		Return 0
	EndIf
	Local $aBounds[2] = [UBound($aCSV, 1), UBound($aCSV, 2)]
	; test second parameter for validity (2)
	If $colNum < 0 Then $colNum = $aBounds[1] + $colNum
	If $colNum < 0 Or $colNum > ($aBounds[1] - 1) Then
		SetError( 3 )
		Return 0
	EndIf

	; start with defining the return array
	Local $aColumn[$aBounds[0]]
	Local $i

	For $i=0 To $aBounds[0]-1
		$aColumn[$i] = $aCSV[$i][$colNum]
	Next

	Return $aColumn
EndFunc

;===============================================================================
;
; Description:      Pulls a single row out of a 2D array
; Parameter(s):     $aCSV      - 2D array to work with; Const ByRef
;                   $rowNum    - Row index, 0-based;
;                                 Negative numbers for backwards parsing are allowed
; Requirement(s):   None
; Return Value(s):  On Success - An array of row data
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Dimension mismatch; only 2D arrays!
;                                               2 - $rowNum is invalid
;                                               3 - $rowNum exceeds column count
; Note(s):
;
;===============================================================================
Func _CSVGetRow( Const ByRef $aCSV, $rowNum )
	; test array dimensions
	If UBound($aCSV, 0) <> 2 Then
		SetError( 1 )
		Return 0
	EndIf
	; test second parameter for validity
	$colNum = Int($rowNum) ; cast strings
	If Not IsInt($rowNum) Then
		SetError( 2 )
		Return 0
	EndIf
	Local $aBounds[2] = [UBound($aCSV, 1), UBound($aCSV, 2)]
	; test second parameter for validity (2)
	If $rowNum < 0 Then $rowNum = $aBounds[0] + $rowNum
	If $rowNum < 0 Or $rowNum > ($aBounds[0] - 1) Then
		SetError( 3 )
		Return 0
	EndIf

	; start with defining the return array
	Local $aRow[$aBounds[1]]
	Local $i

	For $i=0 To $aBounds[1]-1
		$aRow[$i] = $aCSV[$rowNum][$i]
	Next

	Return $aRow
EndFunc

;===============================================================================
;
; Description:      Test function for _CSVReadFile()
; Parameter(s):     $sPath   - Path to the file to read, default is 'test.csv'
;                   $cSeparator  - Separator character, default is comma (,)
;                   $cEnclose    - Character used in enclosings, default is "
; Requirement(s):   None
; Return Value(s):  None
; Note(s):			Dumps out array data via ConsoleWrite()
;
;===============================================================================
Func _CSVTest( $file = "test.csv", $separator = ',', $enclose = '"' )
	Local $output = _CSVReadFile( $file, $separator, $enclose )

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

;~ If @ScriptName == 'LibCsv2_mod.au3' Then
;~ 	_CSVTest("ABRS.csv")
;~ EndIf
