#include "ArrayEdt.au3"												; include ArrayEdt.au3

test_2D_Array()
Exit

Func test_2D_Array()
	Local $aColName[12] = ['zero','one','two','three','four','five', _		; create array of column names
						   'six','seven','eight','nine','ten','eleven']
	Local $aData[128][12]													; create 2D array
	For $i = 0 to UBound($aData)-1
		For $j = 0 to UBound($aData,2)-1
			$aData[$i][$j] = $i &' - '& $j							; fill array with data
		Next
	Next
	If _ArrayEdt2D($aData,$aColName,'Demo title',400,500) Then		; edit array, if true, user pressed Ok-button
		ConsoleWrite('User pressed Ok-button' & @LF)				; process changed $aData
		Local $aColName[12]											; empty array, correct length, will be filled with 'Column x'
		_ArrayEdt2D($aData,$aColName)								; example of minimum required parameters for _ArrayEdt2D
	ElseIf @error Then												; if false, check for error
		ConsoleWrite('Error: ' & @error & @LF)						; handle error
	Else															; if no error, user pressed Cancel-button
		ConsoleWrite('Cancel, nothing was changed' & @LF)			; nothing changed in $aData, nor $aColName
	EndIf
EndFunc
