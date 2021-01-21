#include "ArrayEdt.au3"										; include ArrayEdt.au3

test_1D_Array()
Exit

Func test_1D_Array()
	Local $aData[112]										; create 1D array
	For $i = 0 to UBound($aData)-1
		$aData[$i] = $i & '. item'							; fill array with data
	Next
	If _ArrayEdt1D($aData,'Somedata','1D-Array') Then		; edit array, if true, user pressed Ok-button
		ConsoleWrite('User pressed Ok-button' & @LF)		; process changed $aData
		_ArrayEdt1D($aData)									; example of minimum required parameters for _ArrayEdt1D
	ElseIf @error Then										; if false, check for error
		ConsoleWrite('Error: ' & @error & @LF)				; handle error
	Else													; if no error, user pressed Cancel-button
		ConsoleWrite('Cancel, nothing was changed' & @LF)	; nothing changed in $aData
	EndIf
EndFunc
