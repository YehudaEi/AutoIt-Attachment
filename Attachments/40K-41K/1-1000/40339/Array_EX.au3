
#region Functions
#include-once

; #INDEX# =======================================================================================================================
; Title .........: Array Functions Not in General Distribution
; AutoIt Version : 3.3.8.1
; Language ......: English
; Description ...: Collection of array functions that do not exist or can be enhanced (suffixed with "ex")
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ArrayDeleteColumn_Function
;_ArrayFindAll_Function
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDeleteColumn
; Description ...: Deletes Any Column of a 2 Dimensional Array
; Syntax.........: _ArrayDeleteColumn(Byref $avSourceArray,$Col = 1)
; Parameters ....: $avSourceArray   - [Byref] A 2 dimensional array of any number of columns.
;                  $iCol            - Integer number of the column that you want to delete.
; Return values .: Success          - @error is set to 0 and an array minus the column to delete is returned.
;                  Failure          - @error is set to one of the following:
;									 1 - Parameter 1 is not a 2 dimensional array
;                                   |2 - Parameter 2 is not a number
;                                   |3 - Column to delete does not exist in the source array.
; Author ........: kylomas
; Modified.......: 05/03/2013
; Remarks .......: Version 1.0.0
; Example .......: Yes
; ===============================================================================================================================

Func _ArrayDeleteColumn(ByRef $avSourceArray, $iCol = 1)

	; flush the parms

	If $iCol = -1 Or $iCol = Default Then $iCol = 1

	If UBound($avSourceArray, 0) <> 2 Then Return SetError(1)
	If Not IsNumber($iCol) And Not StringIsDigit($iCol) Then Return SetError(2)
	If $iCol > UBound($avSourceArray, 2) Or $iCol < 1 Then Return SetError(3)

	; define receiving array with 2ND dimension - 1

	Local $aRet[UBound($avSourceArray, 1)][UBound($avSourceArray, 2) - 1]

	; populate receiving array

	For $1 = 0 To UBound($aRet, 1) - 1
		For $2 = 0 To UBound($aRet, 2) - 1
			If $2 >= $iCol Then
				$aRet[$1][$2] = $avSourceArray[$1][$2 + 1]
			Else
				$aRet[$1][$2] = $avSourceArray[$1][$2]
			EndIf
		Next
	Next
	Return SetError(0, 0, $aRet)

EndFunc   ;==>_ArrayDeleteColumn

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayFindAllex
; Description ...: Searches each element in an array for a value based on supplied parameters.
; Syntax.........: _ArrayFindAll(Byref $avSourceArray,$sSearchString,$iSearchType=1,$iCaseSense=0)
; Parameters ....: $avSourceArray   - [Byref] A 1 dimensional array.
;                  $sSearchString   - The string to search for.
;				   $iSearchType     - 0 = match if element contains the search string
;									| 1 = match if element is equal to the search string (default)
;									| 2 = match if element starts with the search string
;									| 3 = match if element ends with search string
;					$iCaseSense		- 0 = match is not case sensitive (default)
;									| 1 = match is case sensitive
;					$sSrchArgSepStr - A string of user supplied characters used to seperate multiple search arguments (Default is -1)
; Return values .: Success          - @error is set to 0.  Return a 2D array of
;									|     [n][0] - The element number that the string was found in
;									|     [n][1] - The search string
;									|     [n][2] - The value found at that element
;                  Failure          - @error is set to one of the following:
;									 	1 - Parameter 1 is not an array
;                                   |	2 - Search type is invalid
;                                   |	3 - Case sense is invalid
;                                   |	4 - Source array is more than 2 dimensions
;                                   |	5 - Search string not found
; Author ........: kylomas
; Modified.......: 05/03/2013
; Remarks .......: Version 1.0.0
; Example .......: Yes
; ===============================================================================================================================

Func _ArrayFindAllex(ByRef $avSourceArray, $sSearchString, $iSearchType = 1, $iCaseSense = 0, $sSrchArgSepString = -1)

	; set parm defaults

	If $iSearchType = Default Or $iSearchType = -1 Then $iSearchType = 1
	If $iCaseSense = Default Or $iCaseSense = -1 Then $iCaseSense = 0
	If $iCaseSense = Default Or $iCaseSense = -1 Then $iCaseSense = 0
	If $sSrchArgSepString = Default Then $sSrchArgSepChar = -1

	; check parameters

	If Not IsArray($avSourceArray) Then Return SetError(1)
	If $iSearchType < 0 Or $iSearchType > 3 Then Return SetError(2)
	If $iCaseSense <> 0 And $iCaseSense <> 1 Then Return SetError(3)

	; check for multiple search arguments

	If $sSrchArgSepString <> -1 Then

		If StringInStr($sSearchString, $sSrchArgSepString) > 0 Then
			$aSearchString = StringSplit($sSearchString, $sSrchArgSepString, 3)
		EndIf
	Else
		Local $aSearchString[1]
		$aSearchString[0] = $sSearchString

	EndIf

	; setup work vars

	Local $sTmp, $iElementNumber = 0, $sSaveSearchString = ''
	If UBound($avSourceArray, 0) = 2 Then Local $aTmp[UBound($avSourceArray, 1) * UBound($avSourceArray, 2) + 80][3]
	If UBound($avSourceArray, 0) = 1 Then Local $aTmp[UBound($avSourceArray, 1) + 80][3]

	For $i = 0 To UBound($aSearchString) - 1

		; save original search argument, escape reserved characters and construct pattern based on parms

		$sSaveSearchString = $aSearchString[$i]

		$aSearchString[$i] = StringRegExpReplace($aSearchString[$i], '[\^\.\*\?\$\[\]\(\)\\\|]', '\\$0')

		; construct search argument

		Switch $iSearchType
			Case 0
				If $iCaseSense = 0 Then $aSearchString[$i] = '(?is)' & $aSearchString[$i]
				If $iCaseSense = 1 Then $aSearchString[$i] = '(?s)' & $aSearchString[$i]
			Case 1
				If $iCaseSense = 0 Then $aSearchString[$i] = '(?i)^' & $aSearchString[$i] & '$'
				If $iCaseSense = 1 Then $aSearchString[$i] = '^' & $aSearchString[$i] & '$'
			Case 2
				If $iCaseSense = 0 Then $aSearchString[$i] = '(?is)^' & $aSearchString[$i]
				If $iCaseSense = 1 Then $aSearchString[$i] = '(?s)^' & $aSearchString[$i]
			Case 3
				If $iCaseSense = 0 Then $aSearchString[$i] = '(?is)' & $aSearchString[$i] & '$'
				If $iCaseSense = 1 Then $aSearchString[$i] = '(?s)' & $aSearchString[$i] & '$'
		EndSwitch

		; main loop

		Switch UBound($avSourceArray, 0)
			Case 1
				For $1 = 0 To UBound($avSourceArray, 1) - 1
					If StringRegExp($avSourceArray[$1], $aSearchString[$i]) = 1 Then
						$aTmp[$iElementNumber][0] = $1
						$aTmp[$iElementNumber][1] = $sSaveSearchString
						$aTmp[$iElementNumber][2] = $avSourceArray[$1]
						$iElementNumber += 1
					EndIf
				Next
			Case 2
				For $1 = 0 To UBound($avSourceArray, 1) - 1
					For $2 = 0 To UBound($avSourceArray, 2) - 1
						If StringRegExp($avSourceArray[$1][$2], $aSearchString[$i]) = 1 Then
							$aTmp[$iElementNumber][0] = 'ROW ' & $1 & ' - ' & 'COL ' & $2
							$aTmp[$iElementNumber][1] = $sSaveSearchString
							$aTmp[$iElementNumber][2] = $avSourceArray[$1][$2]
							$iElementNumber += 1
						EndIf
					Next
				Next
			Case Else
				Return SetError(4)
		EndSwitch

	Next

	; find # of hits

	Local $iRowCount = 0
	For $1 = 0 To UBound($aTmp) - 1
		If StringLen($aTmp[$1][0]) > 0 Then ContinueLoop
		$iRowCount = $1
		ExitLoop
	Next

	; if string not found @error = 5

	If $iRowCount = 0 Then Return SetError(5)

	; shrink result array and return results

	ReDim $aTmp[$iRowCount][3]
	Return SetError(0, 0, $aTmp)

EndFunc   ;==>_ArrayFindAllex
#endregion Functions