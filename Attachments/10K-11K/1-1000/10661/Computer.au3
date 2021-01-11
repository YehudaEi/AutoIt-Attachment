#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.1.1.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func _ComputerTurn()
	Dim $int = 0
	Dim $int1 = 0
	Dim $int2 = 0
	
	$gBoard = _ValidateBoard( $gBoard )
	Dim $Result = WhoCanMove( $gBoard )
	
	If $Result = 2 Then
		$pTurn = 1
		$gBoard = _ValidateBoard( $gBoard )
		Return
	EndIf
	
	For $iTemp1 = 0 To 7
		For $iTemp2 = 0 To 7
			If $gBoard[$iTemp1][$iTemp2][2] = 2 Then
				$int += 1
			EndIf
			
		Next
	Next
	
	If $int = 0 Then
		;No Available moves
	Else
		$int1 = Random( 1, $int, 1 )
		For $iTemp1 = 0 To 7
			For $iTemp2 = 0 To 7
				If $gBoard[$iTemp1][$iTemp2][2] = 2 Then
					$int2 += 1
				EndIf
				If $int1 = $int2 Then
					_ValidateChoice( $iTemp1, $iTemp2, 2 )
					_UpdateCount()
					$pTurn = 1
				EndIf
			Next
		Next
	EndIf
	
EndFunc
