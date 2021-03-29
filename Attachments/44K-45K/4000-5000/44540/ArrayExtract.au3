#include <Array.au3>

Local $aArray[4][4]
For $i = 0 To 3
	For $j = 0 To 3
		$aArray[$i][$j] = $i & $j
	Next
Next

Local $aArray2[4]
For $i = 0 To 3
		$aArray2[$i] = $i
Next

;2d Array

_ArrayDisplay($aArray, "Original")

Local $aExtract = ArrayExtract($aArray, 0, 3, 1, 1)
_ArrayDisplay($aExtract, "Row 0-3 column 1")

Local $aExtract = ArrayExtract($aArray, 0, 3, 0, 2)
_ArrayDisplay($aExtract, "Row 0-3 column 0")

Local $aExtract = ArrayExtract($aArray, 1, 1, 1, 3)
_ArrayDisplay($aExtract, "Row 1 column 1 - 3")

Local $aExtract = ArrayExtract($aArray, 0, 0, 1, 3)
_ArrayDisplay($aExtract, "Row 0 column 1 - 3")

; 1d Array2

Local $aExtract = ArrayExtract($aArray2, 0, 3, 0, 0)
_ArrayDisplay($aExtract, "Row 0-3 column 1")

Local $aExtract = ArrayExtract($aArray2, 1, 3, 0, 0)
_ArrayDisplay($aExtract, "Row 0-3 column 0")

Local $aExtract = ArrayExtract($aArray2, 1, 3)
_ArrayDisplay($aExtract, "Row 1 column 1 - 3")

Local $aExtract = ArrayExtract($aArray2, 0, 3)
_ArrayDisplay($aExtract, "Row 0 column 1 - 3")



Func ArrayExtract( ByRef $aArray,$iRstart, $iRend, $iCstart = 0, $iCend = 0)
	If Not IsArray($aArray) Then
		ConsoleWrite(-'Err 1 : Object is not an array' & @CRLF )
		SetError(-1)
		Return -1
	EndIf
	Local $iRows 		= Ubound($aArray,1) - 1
	Local $iColumns	= Ubound($aArray,2) - 1
	If $iColumns = -1 then
		$iColumns = 0
	EndIf
	If $iRstart > $iRows  OR  $iRstart < 0 Then
		ConsoleWrite('Err 2 : Requested Start Row out of bounds. (Total Rows: ' & $iRows & ' Requested Start Row: ' & $iRstart & ' )' & @CRLF )
		SetError(-2)
		Return -1
	EndIf
	If $iRend > $iRows Or $iRend < $iRstart Then
		ConsoleWrite('Err 3 : Requested End Row out of bounds. (Total Rows: ' & $iRows & ' Requested End Row: ' & $iRend & ' )' & @CRLF )
		SetError(-3)
		Return -1
	EndIf
	If $iCstart > $iColumns OR $iCstart < 0 Then
		ConsoleWrite('Err 4 : Requested Start Row out of bounds. (Total Columns: ' & $iColumns & ' Requested Start Column: ' & $iCstart & ' )' & @CRLF )
		SetError(-4)
		Return -1
	EndIf
	If $iCend > $iColumns OR $iCend < $iCstart Then
		ConsoleWrite('Err 5 : Requested End Row out of bounds. (Total Columns: ' & $iColumns & ' Requested End Column: ' & $iCend & ' )' & @CRLF )
		SetError(-5)
		Return -1
	EndIf
	Select
		Case $iColumns > 1 ; Requesting data from more than 1 Column in a 2D array
			ConsoleWrite('-2d' & @CRLF )
			Local $aResult[$iRend - $iRstart + 1][$iCend - $iCstart + 1]
			For $i = $iRstart to $iRend
				For $ii = $iCstart to $iCend
					$aResult[$i - $iRstart][$ii - $iCstart] = $aArray[$i][$ii]
				Next
			Next
		Case $iColumns = 1 ; Requesting data from 1 Column in a 2D array
			ConsoleWrite('-1d' & @CRLF )
			Local $aResult[$iRend - $iRstart + 1]
			For $i = $iRstart to $iRend
				$aResult[$i - $iRstart] = $aArray[$i][$iCstart]
			Next
		Case $iColumns = 0 ; Requesting Data from a 1D array
			ConsoleWrite('-1d from 2d' & @CRLF )
			Local $aResult[$iRend - $iRstart + 1]
			For $i = $iRstart to $iRend
				$aResult[$i - $iRstart] = $aArray[$i]
			Next
		Case Else
			ConsoleWrite('-Err 6 : Unknown Error' & @CRLF )
			SetError(-6)
			Return -1
	EndSelect
	Return $aResult
EndFunc














