#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.0.1
 Author:         Donald Nelson  donnie@nelsagen.com

 Script Function:
	Main Validation Functions.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Func _ValidateBoard( $gBoard )
	Dim $tmpBoard[8][8][3]
	Dim $iRow
	Dim $iCol
	Dim $tOther
	Dim $tOwner
	
	For $iRow = 0 to 7
		For $iCol = 0 to 7
			If $gBoard[$iRow][$iCol][0] = 0 Then
				;Square is able to be choosen
				$tmpBoard[$iRow][$iCol][0] = 0
				;Check Top Left
				If ($iRow - 1) < 0 Or ($iCol - 1) < 0 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow-1][$iCol-1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow-1][$iCol-1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, -1, -1, $tOwner, $tOther )
						
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Top Middle
				If ($iRow - 1) < 0 Or ($iCol) < 0 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow-1][$iCol][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow-1][$iCol][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, -1, 0, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
							
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Top Right
				If ($iRow - 1) < 0 Or ($iCol + 1) > 7 Then
					;Out of bounds ... Skip
				Else
					;_logit( ($iRow-1) & "x" & ($iCol+1) & " is in bounds")
					If $gBoard[$iRow-1][$iCol+1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow-1][$iCol+1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, -1, 1, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Middle Left
				If ($iRow) < 0 Or ($iCol - 1) < 0 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow][$iCol-1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow][$iCol-1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, 0, -1, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Middle Right
				If ($iRow) < 0 Or ($iCol + 1) > 7 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow][$iCol+1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow][$iCol+1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, 0, 1, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Bottom left
				If ($iRow + 1) > 7 Or ($iCol - 1) < 0 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow+1][$iCol-1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow+1][$iCol-1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, 1, -1, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Bottom Middle
				If ($iRow + 1) > 7 Or ($iCol) < 0 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow+1][$iCol][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow+1][$iCol][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, 1, 0, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
				;Check Bottom Right
				If ($iRow + 1) > 7 Or ($iCol + 1) > 7 Then
					;Out of bounds ... Skip
				Else
					If $gBoard[$iRow+1][$iCol+1][0] <> 0 Then
						;Someone owns the spot
						$tOwner = $gBoard[$iRow+1][$iCol+1][0]
						$tOther = _OtherPlayer( $tOwner )
						$_Result = _LineCheck( $gBoard, $iRow, $iCol, 1, 1, $tOwner, $tOther )
						If $_Result = -1 Then
							;No play
						ElseIf $_Result = 1 Then
							;There is a play.
							If $tOther = 1 Then
								$tmpBoard[$iRow][$iCol][1] = 1
							ElseIf $tOther = 2 Then
								$tmpBoard[$iRow][$iCol][2] = 2
							EndIf
						EndIf
					Else
						;Do nothing because this square is not owned by anyone
					EndIf
				EndIf
				$tOther = 0
				$tOwner = 0
				
			Else
				$tmpBoard[$iRow][$iCol][0] = $gBoard[$iRow][$iCol][0]
			EndIf
		Next
	Next
	
	Return $tmpBoard
EndFunc

Func _LineCheck( $gBoard, $iRow, $iCol, $iTemp1, $iTemp2, $tPlayer, $tOther )
	For $x = 2 To 7
		If ($iRow + ($iTemp1 * $x)) < 0 Or ($iRow + ($iTemp1 * $x)) > 7 Or ($iCol + ($iTemp2 * $x)) < 0 Or ($iCol + ($iTemp2 * $x)) > 7 Then
			;Out of Bounds ... no play
			Return -1
		Else
			If $gBoard[$iRow + ($iTemp1 * $x)][$iCol + ($iTemp2 * $x)][0] = $tPlayer Then
				;continue because its the same color
			ElseIf $gBoard[$iRow + ($iTemp1 * $x)][$iCol + ($iTemp2 * $x)][0] = $tOther Then
				;Success ... this is a possible move
				Return 1
			ElseIf $gBoard[$iRow + ($iTemp1 * $x)][$iCol + ($iTemp2 * $x)][0] = 0 Then
				;There is no possible move here
				Return -1
			EndIf
		EndIf
	Next
EndFunc

Func _OtherPlayer( $iTemp )
	;Return the oposite player number
	If $iTemp = 1 Then
		Return 2
	ElseIf $iTemp = 2 Then
		Return 1
	EndIf
EndFunc

Func WhoCanMove( $gBoard )
	$gBlackCanMove = False
	$gWhiteCanMove = False
	
	For $x = 0 To 7
		For $y = 0 To 7
			If $gBoard[$x][$y][1] = 1 Then
				$gWhiteCanMove = True
			EndIf
			If $gBoard[$x][$y][2] = 2 Then
				$gBlackCanMove = True
			EndIf
		Next
	Next
	
	
	If $gBlackCanMove = False And $gWhiteCanMove = False Then
		;If no one can move, game over
		_GameOver()
	ElseIf $gBlackCanMove = False Then
		;Black cannot move
		Return 2
	ElseIf $gWhiteCanMove = False Then
		;White cannot move
		Return 1
	EndIf
	
EndFunc

Func _GameOver()
	$bActive = False
	$bGameOver = True
	TCPSend( $gConnectedSocket, "0" & $enumGameOver & "The game Is Over" )
	_UpdateTxtRead( "The Game Is Over", 0 )
	TCPShutdown()
EndFunc

Func _ValidateChoice( $intTemp1, $intTemp2, $turn )
	
	Dim $around = 0
	Dim $DirToCheck[10]
		
	;Make sure that the Tile has not already been choosen
	If $gBoard[$intTemp1][$intTemp2][0] = 1 Or $gBoard[$intTemp1][$intTemp2][0] = 2 Then
		Return -1
	EndIf
	
	;Make Sure that there is another Tile around the chosen tile that is the other players colors.
	Dim $bPossible = False
	For $iTemp1 = -1 to 1
		For $iTemp2 = -1 to 1
			
			;Check to make sure that we are not outside of the array for the Rows
			If ( $intTemp1 + $iTemp1 ) < 0  Or ( $intTemp1 + $iTemp1 ) > 7 Then
				;We cannot look outside of the array
			Else
				
				;Check to make sure that we are not outside of the array for the Columns
				If ( $intTemp2 + $iTemp2 ) < 0 Or ( $intTemp2 + $iTemp2 ) > 7 Then
					;We Cannot look outside of the array
				Else
					If $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp2][0] = _OtherPlayer($Turn) Then
						$bPossible = True
						$DirToCheck[$around] = 1
					EndIf	
				EndIf
			EndIf
			
			;increment our integer
			$around = $around + 1
		Next
	Next
	
	If $bPossible = False Then
		Return -2
	EndIf
	
	;We have squares next to the chosen square that are of a different color ... proceed
	Dim $Success = False
	Dim $Continue = False
	Dim $Fail = False
	
	For $temp1 = 0 to 8
	Select
		Case $DirToCheck[$temp1] = 1 and $temp1 = 0
			For $iTemp1 = -2 To -8 Step -1
				If ($intTemp1 + $iTemp1) < 0 Or ($intTemp2 + $iTemp1) < 0 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = $turn
							For $int1 = -1 To $iTemp1 Step -1
								$gBoard[$intTemp1 + $int1][$intTemp2 + $int1][0] = $turn
								_SetColor( ($intTemp1 + $int1), ($intTemp2 + $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
			
		Case $DirToCheck[$temp1] = 1 and $temp1 = 1
			For $iTemp1 = 2 To 8
				If ($intTemp1 - $iTemp1) < 0 Or ($intTemp2) < 0 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 - $iTemp1][$intTemp2][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 - $iTemp1][$intTemp2][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 - $iTemp1][$intTemp2][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1 - $int1][$intTemp2][0] = $turn
								_SetColor( ($intTemp1 - $int1), ($intTemp2), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 2
			For $iTemp1 = 2 To 8
				If ($intTemp1 - $iTemp1) < 0 Or ($intTemp2 + $iTemp1) > 7 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 - $iTemp1][$intTemp2 + $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 - $iTemp1][$intTemp2 + $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 - $iTemp1][$intTemp2 + $iTemp1][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1 - $int1][$intTemp2 + $int1][0] = $turn
								_SetColor( ($intTemp1 - $int1), ($intTemp2 + $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 3
			For $iTemp1 = 2 To 8
				If ($intTemp1) < 0 Or ($intTemp2 - $iTemp1) < 0 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1][$intTemp2 - $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1][$intTemp2 - $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1][$intTemp2 - $iTemp1][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1][$intTemp2 - $int1][0] = $turn
								_SetColor( ($intTemp1), ($intTemp2 - $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 4
			;This will never happen because this is where the click occured
		Case $DirToCheck[$temp1] = 1 and $temp1 = 5
			For $iTemp1 = 2 To 8
				If ($intTemp1) > 7 Or ($intTemp2 + $iTemp1) > 7 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1][$intTemp2 + $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1][$intTemp2 + $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1][$intTemp2 + $iTemp1][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1][$intTemp2 + $int1][0] = $turn
								_SetColor( ($intTemp1), ($intTemp2 + $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 6
			For $iTemp1 = 2 To 8
				If ($intTemp1 + $iTemp1) > 7 Or ($intTemp2 - $iTemp1) < 0 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 - $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 + $iTemp1][$intTemp2 - $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 - $iTemp1][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1 + $int1][$intTemp2 - $int1][0] = $turn
								_SetColor( ($intTemp1 + $int1), ($intTemp2 - $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 7
			For $iTemp1 = 2 To 8
				If ($intTemp1 + $iTemp1) > 7 Or ($intTemp2) > 7 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 + $iTemp1][$intTemp2][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1 + $int1][$intTemp2][0] = $turn
								_SetColor( ($intTemp1 + $int1), ($intTemp2), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next
		Case $DirToCheck[$temp1] = 1 and $temp1 = 8
			For $iTemp1 = 2 To 8
				If ($intTemp1 + $iTemp1) > 7 Or ($intTemp2 + $iTemp1) > 7 Then
					;Do nothing as it is outside of the array
					$Fail = True
				Else
					Select
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = 0
							$Fail = True
						case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = _OtherPlayer($Turn)
							$Continue = True
						Case $gBoard[$intTemp1 + $iTemp1][$intTemp2 + $iTemp1][0] = $turn
							For $int1 = 1 To $iTemp1
								$gBoard[$intTemp1 + $int1][$intTemp2 + $int1][0] = $turn
								_SetColor( ($intTemp1 + $int1), ($intTemp2 + $int1), $turn )
							Next
							_SetColor( $intTemp1, $intTemp2, $turn )
							$Success = True
					EndSelect
				EndIf
			Next			
	EndSelect
	Next

	If $Success = False Then
		Return -2
	Else
		$gBoard = _ValidateBoard( $gBoard )
		_sendboard( $gBoard )
		Return 1
	EndIf
EndFunc