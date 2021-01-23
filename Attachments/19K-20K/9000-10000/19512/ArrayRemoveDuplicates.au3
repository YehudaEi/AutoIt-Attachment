;==================================================================
; Function Name:  _ArrayRemoveDuplicates()
;
; Description    :  Removes Duplicates from an Array
; Parameter(s)   :  $avArray
;                   $iBase
;                   $iCaseSense
;                   $sDelimter
; Requirement(s) :  None
; Return Value(s):  On Success - Returns 1 and the cleaned up Array is set
;                   On Failure - Returns an -1 and sets @Error
;                        @Error=1 $avArray is not an array
;                        @Error=2 $iBase is different from 1 or 2
;                        @Error=3 $iCaseSense is different from 0 or 1
; Author         :  uteotw, but ALL the credits go to nitro322 and SmOke_N, see link below
; Note(s)        :  None
; Link           ;  http://www.autoitscript.com/forum/index.php?showtopic=7821
; Example        ;  Yes
;==================================================================
Func _ArrayRemoveDuplicates(ByRef $avArray, $iBase = 0, $iCaseSense = 0, $sDelimter = "")
	Local $sHold
	
	If Not IsArray($avArray) Then
		SetError(1)
		Return -1
	EndIf
	If Not ($iBase = 0 Or $iBase = 1) Then
		SetError(2)
		Return -1
	EndIf
	If $iBase = 1 AND $avArray[0] = 0 Then
		SetError(0)
		Return 0
	EndIf
	If Not ($iCaseSense = 0 Or $iCaseSense = 1) Then
		SetError(3)
		Return -1
	EndIf
	If $sDelimter = "" Then
		$sDelimter = Chr(01) & Chr(01)
	EndIf
 
	If $iBase = 0 Then
		For $i = $iBase To UBound($avArray) - 1
			If Not StringInStr($sDelimter & $sHold, $sDelimter & $avArray[$i] & $sDelimter, $iCaseSense) Then
				$sHold &= $avArray[$i] & $sDelimter
			EndIf
		Next
		$avNewArray = StringSplit(StringTrimRight($sHold, StringLen($sDelimter)), $sDelimter, 1)
		ReDim $avArray[$avNewArray[0]]
		For $i = 1 to $avNewArray[0]
			$avArray[$i-1] = $avNewArray[$i]
		Next
	ElseIf $iBase = 1 Then
		For $i= $iBase To UBound($avArray) - 1
			If Not StringInStr($sDelimter & $sHold, $sDelimter & $avArray[$i] & $sDelimter, $iCaseSense) Then
				$sHold &= $avArray[$i] & $sDelimter
			EndIf
		Next
		$avArray = StringSplit(StringTrimRight($sHold, StringLen($sDelimter)), $sDelimter, 1)
	EndIf

    Return 1
EndFunc