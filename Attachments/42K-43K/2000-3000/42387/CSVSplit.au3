#include-once

; #INDEX# =======================================================================================================================
; Title .........: CSVSplit
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: CSV related functions
; Notes .........: CSV format does not have a general standard format, however these functions allow some flexibility.
;                  The default behaviour of the functions applies to the most common formats used in practice.
; Author(s) .....: czardas
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ArrayToCSV
;_ArrayToSubItemCSV
;_CSVSplit
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __GetSubstitute
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToCSV
; Description ...: Converts a two dimensional array to CSV format
; Syntax.........: _ArrayToCSV ( $aArray [, $sDelim [, $sNewLine [, $bFinalBreak ]]] )
; Parameters ....: $aArray      - The array to convert
;                  $sDelim      - Optional - Delimiter set to comma by default (see comments)
;                  $sNewLine    - Optional - New Line set to @LF by default (see comments)
;                  $bFinalBreak - Set to true in accordance with common practice => CSV Line termination
; Return values .: Success  - Returns a string in CSV format
;                  Failure  - Sets @error to:
;                 |@error = 1 - First parameter is not a valid array
;                 |@error = 2 - Second parameter is not a valid string
;                 |@error = 3 - Third parameter is not a valid string
;                 |@error = 4 - 2nd and 3rd parameters must be different characters
; Author ........: czardas
; Comments ......; One dimensional arrays are returned as multiline text (without delimiters)
;                ; Some users may need to set the second parameter to semicolon to return the prefered CSV format
;                ; To convert to TSV use @TAB for the second parameter
;                ; Some users may wish to set the third parameter to @CRLF
; ===============================================================================================================================

Func _ArrayToCSV($aArray, $sDelim = Default, $sNewLine = Default, $bFinalBreak = True)
    If Not IsArray($aArray) Or Ubound($aArray, 0) > 2 Or Ubound($aArray) = 0 Then Return SetError(1, 0 ,"")
    If $sDelim = Default Then $sDelim = ","
    If $sDelim = "" Then Return SetError(2, 0 ,"")
    If $sNewLine = Default Then $sNewLine = @LF
    If $sNewLine = "" Then Return SetError(3, 0 ,"")
    If $sDelim = $sNewLine Then Return SetError(4, 0, "")

    Local $iRows = UBound($aArray), $sString = ""
    If Ubound($aArray, 0) = 2 Then ; Check if the array has two dimensions
        Local $iCols = UBound($aArray, 2)
        For $i = 0 To $iRows -1
            For $j = 0 To $iCols -1
                If StringRegExp($aArray[$i][$j], '["' & $sDelim & ']') Then
                    $aArray[$i][$j] = '"' & StringReplace($aArray[$i][$j], '"', '""') & '"'
                EndIf
                $sString &= $aArray[$i][$j] & $sDelim
            Next
            $sString = StringTrimRight($sString, StringLen($sDelim)) & $sNewLine
        Next
    Else ; The delimiter is not needed
        For $i = 0 To $iRows -1
            If StringRegExp($aArray[$i], '["' & $sDelim & ']') Then
                $aArray[$i] = '"' & StringReplace($aArray[$i], '"', '""') & '"'
            EndIf
            $sString &= $aArray[$i] & $sNewLine
        Next
    EndIf
    If Not $bFinalBreak Then $sString = StringTrimRight($sString, StringLen($sNewLine)) ; Delete any newline characters added to the end of the string
    Return $sString
EndFunc ;==> _ArrayToCSV

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToSubItemCSV
; Description ...: Converts an array to multiple CSV formated strings based on the content of the selected column
; Syntax.........: _ArrayToSubItemCSV($aCSV, $iCol [, $sDelim [, $bHeaders [, $iSortCol  ]]])
; Parameters ....: $aCSV     - The array to parse
;                  $iCol     - Array column used to search for unique content
;                  $sDelim   - Optional - Delimiter set to comma by default
;                  $bHeaders - Include csv column headers - Default = False
;                  $iSortCol - The column to sort on for each new CSV (sorts ascending)
; Return values .: Success   - Returns a two dimensional array - col 0 = subitem name, col 1 = CSV data
;                  Failure   - Returns an empty string and sets @error to:
;                 |@error = 1 - First parameter is not a 2D array
;                 |@error = 2 - Nothing to parse
;                 |@error = 3 - Invalid second parameter Column number
;                 |@error = 4 - Invalid fourth parameter Sort Column number
;                 |@error = 5 - Delimiter is an empty string
; Author ........: czardas
; Comments ......; @CRLF is used for line breaks in the returned array of CSV strings.
; ===============================================================================================================================

Func _ArrayToSubItemCSV($aCSV, $iCol, $sDelim = Default, $bHeaders = Default, $iSortCol = -1)
    If Not IsArray($aCSV) Or UBound($aCSV, 0) <> 2 Or UBound($aCSV) = 0 Then Return SetError(1, 0, "") ; Not a 2D array

    Local $iBound = UBound($aCSV), $iNumCols = UBound($aCSV, 2)
    If $iBound = 1 Then Return SetError(2, 0, "") ; Nothing to parse
    If IsInt($iCol) = 0 Or $iCol < 0 Or $iCol > $iNumCols -1 Then Return SetError(3, 0, "") ; $iCol is out of range
    If IsInt($iSortCol) = 0 Or $iSortCol < -1 Or $iSortCol > $iNumCols -1 Then Return SetError(4, 0, "") ; $iSortCol is out of range
    If $sDelim = Default Then $sDelim = ","
    If $sDelim = "" Then Return SetError(5, 0, "")
    If $bHeaders = Default Then $bHeaders = False

    Local $iStart = 0

    If $bHeaders Then
        If $iBound = 2 Then Return SetError(2, 0, "") ; Nothing to parse
        $iStart = 1
    EndIf
    _ArraySort($aCSV, 0, $iStart, 0, $iCol) ; Sort on the selected column

    Local $aSubItemCSV[$iBound][2], $iItems = 0, $aTempCSV[1][$iNumCols], $iTempIndex, $sTestItem = Not $aCSV[$iBound -1][$iCol]

    For $i = $iBound -1 To $iStart Step -1
        If $sTestItem <> $aCSV[$i][$iCol] Then ; Start a new csv instance
            If $iItems > 0 Then ; Write to main array
                ReDim $aTempCSV[$iTempIndex][$iNumCols]
                If $iSortCol <> -1 Then _ArraySort($aTempCSV, 0, $iStart, 0, $iSortCol)
                $aSubItemCSV[$iItems -1][0] = $sTestItem
                $aSubItemCSV[$iItems -1][1] = _ArrayToCSV($aTempCSV, $sDelim, @CRLF)
            EndIf

            ReDim $aTempCSV[$iBound][$iNumCols] ; Create new csv template
            $iTempIndex = 0
            $sTestItem = $aCSV[$i][$iCol]

            If $bHeaders Then
                For $j = 0 To $iNumCols -1
                    $aTempCSV[0][$j] = $aCSV[0][$j]
                Next
                $iTempIndex = 1
            EndIf
            $iItems += 1
        EndIf

        For $j = 0 To $iNumCols -1 ; Continue writing to csv
            $aTempCSV[$iTempIndex][$j] = $aCSV[$i][$j]
        Next
        $iTempIndex += 1
    Next
    ReDim $aTempCSV[$iTempIndex][$iNumCols]
    $aSubItemCSV[$iItems -1][0] = $sTestItem
    $aSubItemCSV[$iItems -1][1] = _ArrayToCSV($aTempCSV, $sDelim, @CRLF)

    ReDim $aSubItemCSV[$iItems][2]
    Return $aSubItemCSV
EndFunc ;==> _ArrayToSubItemCSV

; #FUNCTION# ====================================================================================================================
; Name...........: _CSVSplit
; Description ...: Converts a string in CSV format to a two dimensional array (see comments)
; Syntax.........: _ArrayToCSV ( $aArray [, $sDelim ] )
; Parameters ....: $aArray  - The array to convert
;                  $sDelim  - Optional - Delimiter set to comma by default (see 2nd comment)
; Return values .: Success  - Returns a two dimensional array or a one dimensional array (see 1st comment)
;                  Failure  - Sets @error to:
;                 |@error = 1 - First parameter is not a valid string
;                 |@error = 2 - Second parameter is not a valid string
;                 |@error = 3 - Could not find suitable delimiter replacements
; Author ........: czardas
; Comments ......; Returns a one dimensional array if the input string does not contain the delimiter string
;                ; Some CSV formats use semicolon as a delimiter instead of a comma
;                ; Set the second parameter to @TAB To convert to TSV
; ===============================================================================================================================

Func _CSVSplit($string, $sDelim = ",") ; Parses csv string input and returns a one or two dimensional array
    If Not IsString($string) Or $string = "" Then Return SetError(1, 0, 0) ; Invalid string
    If Not IsString($sDelim) Or $sDelim = "" Then Return SetError(2, 0, 0) ; Invalid string

    $string = StringRegExpReplace($string, "[\r\n]+\z", "") ; [Line Added] Remove training breaks
    Local $iOverride = 63743, $asDelim[3] ; $asDelim => replacements for comma, new line and double quote
    For $i = 0 To 2
        $asDelim[$i] = __GetSubstitute($string, $iOverride) ; Choose a suitable substitution character
        If @error Then Return SetError(3, 0, 0) ; String contains too many unsuitable characters
    Next
    $iOverride = 0

    Local $aArray = StringRegExp($string, '\A[^"]+|("+[^"]+)|"+\z', 3) ; Split string using double quotes delim - largest match
    $string = ""

    Local $iBound = UBound($aArray)
    For $i = 0 To $iBound -1
        $iOverride += StringInStr($aArray[$i], '"', 0, -1) ; Increment by the number of adjacent double quotes per element
        If Mod ($iOverride +2, 2) = 0 Then ; Acts as an on/off switch
            $aArray[$i] = StringReplace($aArray[$i], $sDelim, $asDelim[0]) ; Replace comma delimeters
            $aArray[$i] = StringRegExpReplace($aArray[$i], "(\r\n)|[\r\n]", $asDelim[1]) ; Replace new line delimeters
        EndIf
        $aArray[$i] = StringReplace($aArray[$i], '""', $asDelim[2]) ; Replace double quote pairs
        $aArray[$i] = StringReplace($aArray[$i], '"', '') ; Delete enclosing double quotes - not paired
        $aArray[$i] = StringReplace($aArray[$i], $asDelim[2], '"') ; Reintroduce double quote pairs as single characters
        $string &= $aArray[$i] ; Rebuild the string, which includes two different delimiters
    Next
    $iOverride = 0

    $aArray = StringSplit($string, $asDelim[1], 2) ; Split to get rows
    $iBound = UBound($aArray)
    Local $aCSV[$iBound][2], $aTemp
    For $i = 0 To $iBound -1
        $aTemp = StringSplit($aArray[$i], $asDelim[0]) ; Split to get row items
        If Not @error Then
            If $aTemp[0] > $iOverride Then
                $iOverride = $aTemp[0]
                ReDim $aCSV[$iBound][$iOverride] ; Add columns to accomodate more items
            EndIf
        EndIf
        For $j = 1 To $aTemp[0]
            If StringLen($aTemp[$j]) Then
                If Not StringRegExp($aTemp[$j], '[^"]') Then ; Field only contains double quotes
                    $aTemp[$j] = StringTrimLeft($aTemp[$j], 1) ; Delete enclosing double quote single char
                EndIf
                $aCSV[$i][$j -1] = $aTemp[$j] ; Populate each row
            EndIf
        Next
    Next

    If $iOverride > 1 Then
        Return $aCSV ; Multiple Columns
    Else
        For $i = 0 To $iBound -1
            If StringLen($aArray[$i]) And (Not StringRegExp($aArray[$i], '[^"]')) Then ; Only contains double quotes
                $aArray[$i] = StringTrimLeft($aArray[$i], 1) ; Delete enclosing double quote single char
            EndIf
        Next
        Return $aArray ; Single column
    EndIf
EndFunc ;==> _CSVSplit

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GetSubstitute
; Description ...: Searches for a character to be used for substitution, ie one not contained within the input string
; Syntax.........: __GetSubstitute($string, ByRef $iCountdown)
; Parameters ....: $string   - The string of characters to avoid
;                  $iCountdown - The first code point to begin checking
; Return values .: Success   - Returns a suitable substitution character not found within the first parameter
;                  Failure   - Sets @error to 1 => No substitution character available
; Author ........: czardas
; Comments ......; This function is connected to the function _CSVSplit and was not intended for general use
;                  $iCountdown is returned ByRef to avoid selecting the same character on subsequent calls to this function
;                  Initially $iCountown should be passed with a value = 63743
; ===============================================================================================================================

Func __GetSubstitute($string, ByRef $iCountdown)
    If $iCountdown < 57344 Then Return SetError(1, 0, "") ; Out of options
    Local $sTestChar
    For $i = $iCountdown To 57344 Step -1
        $sTestChar = ChrW($i)
        $iCountdown -= 1
        If Not StringInStr($string, $sTestChar) Then
            Return $sTestChar
        EndIf
    Next
    Return SetError(1, 0, "") ; Out of options
EndFunc ;==> __GetSubstitute