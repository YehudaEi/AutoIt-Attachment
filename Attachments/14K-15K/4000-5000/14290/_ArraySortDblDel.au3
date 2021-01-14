;----------------------------------------------------------------------------------------------------------------------
; Function		_ArraySortDblDel(ByRef $ARRAY [, $CASESENS=0 [, $iDESCENDING=0 [, $iDIM=0[ , $iSORT=0]]]])
;
; Description	- Sorts an 1D/2D Array and delete double entries (2D -> combination by '[n][0]' and '[n][1]').
;				- By using string, you can choose case sensitivity.
;				- BaseIndex is 0; sorts the whole array.
;
; Parameter		$ARRAY:			Array to sort
;	optional	$CASESENS:		Case sensitivity off[0] or on[1] (default 0)
;	optional	$iDESCENDING:	Sort ascending[0]/descending[1] (default 0)
;	optional	$iDIM:			Occurences in the second dimension,	eg $A[100]=0 or $A[100][2]=2 (default 0)		
;	optional	$iSORT:			SortIndex by using 2 dimensions (default 0)
;
; Return		ByRef sorted Array without doubles
;
; Requirements	Only 2 occurences in the second dimension
;				#include <array.au3>
;
; Author		BugFix (bugfix@autoit.de)
;----------------------------------------------------------------------------------------------------------------------

Func _ArraySortDblDel(ByRef $ARRAY, $CASESENS=0, $iDESCENDING=0, $iDIM=0, $iSORT=0)
Local $arTmp1D[1], $arTmp2D[1][2], $dbl = 0
	$arTmp1D[0] = ""
	$arTmp2D[0][0] = ""
	If $iDIM = 0 Then $iDIM = 1
	_ArraySort($ARRAY,$iDESCENDING,0,0,$iDIM,$iSORT)
	Switch $iDIM
		Case 1 ; 1D
			For $i = 0 To UBound($ARRAY)-1
				$dbl = 0
				For $k = 0 To UBound($arTmp1D)-1
					Switch $CASESENS
						Case 0
							If $arTmp1D[$k] = $ARRAY[$i] Then $dbl = 1
						Case 1
							If $arTmp1D[$k] == $ARRAY[$i] Then $dbl = 1
					EndSwitch	
				Next
				If $dbl = 0 Then
					If $arTmp1D[0] = "" Then
						$arTmp1D[0] = $ARRAY[$i]
					Else
						_ArrayAdd($arTmp1D, $ARRAY[$i])
					EndIf
				Else
					$dbl = 0
				EndIf
			Next
			$ARRAY = $arTmp1D
		Case 2 ; 2D
			For $i = 0 To UBound($ARRAY)-1
				$dbl = 0
				For $k = 0 To UBound($arTmp2D)-1
					Switch $CASESENS
						Case 0
							If  ( $arTmp2D[$k][0] = $ARRAY[$i][0] ) And _
								( $arTmp2D[$k][1] = $ARRAY[$i][1] ) Then $dbl = 1
						Case 1		
							If  ( $arTmp2D[$k][0] == $ARRAY[$i][0] ) And _
								( $arTmp2D[$k][1] == $ARRAY[$i][1] ) Then $dbl = 1
					EndSwitch				
				Next
				If $dbl = 0 Then
					If $arTmp2D[0][0] = "" Then
						$arTmp2D[0][0] = $ARRAY[$i][0]
						$arTmp2D[0][1] = $ARRAY[$i][1]
					Else
						ReDim $arTmp2D[UBound($arTmp2D)+1][2]
						$arTmp2D[UBound($arTmp2D)-1][0] = $ARRAY[$i][0]
						$arTmp2D[UBound($arTmp2D)-1][1] = $ARRAY[$i][1]
					EndIf
				Else
					$dbl = 0
				EndIf
			Next
			$ARRAY = $arTmp2D
	EndSwitch
EndFunc ; ==>_ArraySortDblDel