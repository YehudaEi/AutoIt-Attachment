#include <Array.au3>
#include <String.au3>
#AutoIt3Wrapper_run_debug_mode = N

Global $header = " 1  2  3  4  5  6  7  8  9  A  B  C  D  E  F "
Global $Wins[1]
Global $hFile
Global $isSolved = False

Func CreateNewBoard( $EmptyPeg = 13 )
	Dim $Board = StringSplit( "1|2|3|4|5|6|7|8|9|10|11|12|13|14|15", "|" )
	For $i = 1 to $Board[0]
		If $i = $EmptyPeg Then
			$Board[$i] = False
		Else
			$Board[$i] = True
		EndIf
	Next
	$isSolved = False 
	Return $Board
EndFunc

Func GetJumps( $Board )
	Local $PotentialMoves[1]
	For $i = 1 to $Board[0]
		If $Board[$i] then
			Switch ($i)
				Case 1
					If $Board[2] AND NOT $Board[4] then _ArrayAdd( $PotentialMoves, '1|2|4' )
					If $Board[3] AND NOT $Board[6] then _ArrayAdd( $PotentialMoves, '1|3|6' )
				Case 2
					If $Board[4] AND NOT $Board[7] then _ArrayAdd( $PotentialMoves, '2|4|7' )
					If $Board[5] AND NOT $Board[9] then _ArrayAdd( $PotentialMoves, '2|5|9' )
				Case 3
					If $Board[5] AND NOT $Board[8] then _ArrayAdd( $PotentialMoves, '3|5|8' )
					If $Board[6] AND NOT $Board[10] then _ArrayAdd( $PotentialMoves, '3|6|10' )
				Case 4
					If $Board[2] AND NOT $Board[1] then _ArrayAdd( $PotentialMoves, '4|2|1' )
					If $Board[7] AND NOT $Board[11] then _ArrayAdd( $PotentialMoves, '4|7|11' )
					If $Board[8] AND NOT $Board[13] then _ArrayAdd( $PotentialMoves, '4|8|13' )
					If $Board[5] AND NOT $Board[6] then _ArrayAdd( $PotentialMoves, '4|5|6' )
				Case 5
					If $Board[8] AND NOT $Board[12] then _ArrayAdd( $PotentialMoves, '5|8|12' )
					If $Board[9] AND NOT $Board[14] then _ArrayAdd( $PotentialMoves, '5|9|14' )
				Case 6
					If $Board[3] AND NOT $Board[1] then _ArrayAdd( $PotentialMoves, '6|3|1' )
					If $Board[9] AND NOT $Board[13] then _ArrayAdd( $PotentialMoves, '6|9|13' )
					If $Board[10] AND NOT $Board[15] then _ArrayAdd( $PotentialMoves, '6|10|15' )
					If $Board[5] AND NOT $Board[4] then _ArrayAdd( $PotentialMoves, '6|5|4' )
				Case 7
					If $Board[4] AND NOT $Board[2] then _ArrayAdd( $PotentialMoves, '7|4|2' )
					If $Board[8] AND NOT $Board[9] then _ArrayAdd( $PotentialMoves, '7|8|9' )
				Case 8
					If $Board[5] AND NOT $Board[3] then _ArrayAdd( $PotentialMoves, '8|5|3' )
					If $Board[9] AND NOT $Board[10] then _ArrayAdd( $PotentialMoves, '8|9|10' )
				Case 9
					If $Board[5] AND NOT $Board[2] then _ArrayAdd( $PotentialMoves, '9|5|2' )
					If $Board[8] AND NOT $Board[7] then _ArrayAdd( $PotentialMoves, '9|8|7' )
				Case 10
					If $Board[6] AND NOT $Board[3] then _ArrayAdd( $PotentialMoves, '10|6|3' )
					If $Board[9] AND NOT $Board[8] then _ArrayAdd( $PotentialMoves, '10|9|8' )
				Case 11
					If $Board[7] AND NOT $Board[4] then _ArrayAdd( $PotentialMoves, '11|7|4' )
					If $Board[12] AND NOT $Board[13] then _ArrayAdd( $PotentialMoves, '11|12|13' )
				Case 12
					If $Board[8] AND NOT $Board[5] then _ArrayAdd( $PotentialMoves, '12|8|5' )
					If $Board[13] AND NOT $Board[14] then _ArrayAdd( $PotentialMoves, '12|13|14' )
				Case 13
					If $Board[8] AND NOT $Board[4] then _ArrayAdd( $PotentialMoves, '13|8|4' )
					If $Board[9] AND NOT $Board[6] then _ArrayAdd( $PotentialMoves, '13|9|6' )
					If $Board[12] AND NOT $Board[11] then _ArrayAdd( $PotentialMoves, '13|12|11' )
					If $Board[14] AND NOT $Board[15] then _ArrayAdd( $PotentialMoves, '13|14|15' )
				Case 14
					If $Board[9] AND NOT $Board[5] then _ArrayAdd( $PotentialMoves, '14|9|5' )
					If $Board[13] AND NOT $Board[12] then _ArrayAdd( $PotentialMoves, '14|13|12' )
				Case 15
					If $Board[10] AND NOT $Board[6] then _ArrayAdd( $PotentialMoves, '15|10|6' )
					If $Board[14] AND NOT $Board[13] then _ArrayAdd( $PotentialMoves, '15|14|13' )
			EndSwitch
		EndIf
	Next
	$PotentialMoves[0] = UBound( $PotentialMoves ) - 1
	Return $PotentialMoves
EndFunc


Func GetBoardState( ByRef $board, $empty = 0, $jumped = 0, $destination = 0 )
	local $return = ""
	For $i = 1 to $board[0]
		If $i = $empty Then
			$return &= "(~)"
		ElseIf $i = $jumped Then
			$return &= "(O)"								
		ElseIf $i = $destination Then
			$return &= "(@)"		
		ElseIf $board[$i] then 				
			$return &= "(X)"
		Else
			$return &= "( )"
		EndIf 
	Next
	Return $return
EndFunc


Func MakeMove( $board, $jumps )
	$pegs = StringSplit( $jumps, "|" )
	; Empty Start Peg
	$board[ $pegs[1] ] = False
	; Empty Jumped Position
	$board[ $pegs[2] ] = False
	; Fill Destination Peg
	$board[ $pegs[3] ] = True
	Return $board
EndFunc


Func PlayGame( $myGameBoard, $moves = "" )	
	$AvailableJumps = GetJumps( $myGameBoard )
	If $AvailableJumps[0] > 0 then
		For $x = 1 to $AvailableJumps[0]
			If $isSolved = False then 
				$newGameBoard = MakeMove( $myGameBoard, $AvailableJumps[$x] )			
				PlayGame( $newGameBoard, $moves & "," & $AvailableJumps[$x] )
			EndIf 
		Next	
	Else	
		Local $remaining = 0
		For $j = 1 to $myGameBoard[0]
			If $myGameBoard[$j] = True then $remaining += 1
		Next
		If $remaining = 1 then 
			ShowWinningCombo( StringMid( $moves, 2 ))
			$isSolved = True 
			$moves = 0						
		EndIf 
	EndIf	
EndFunc


Func ShowWinningCombo( $combo )
	$aCombo = StringSplit( $combo, "," )
	For $i = 1 to $aCombo[0]
		$aMoves = StringSplit( $aCombo[$i], "|" )
		$msg = StringFormat( "Move peg %s over peg %s into hole %s", Hex( $aMoves[1], 1 ) , Hex( $aMoves[2], 1 ), Hex( $aMoves[3], 1 ))
		Debug( $msg )
	Next
EndFunc


Func Debug( $msg = "" )
	ConsoleWrite( $msg & @CRLF)
	FileWriteLine( $hFile, $msg )
EndFunc


$hFile = FileOpen( @ScriptDir & "\IQTest.csv", 2 )
For $X = 1 to 15
	Debug( $header )
	$GameBoard = CreateNewBoard( $x )
	Debug( GetBoardState( $GameBoard ) )
	PlayGame( $GameBoard )
	Debug( ) 
Next 
FileClose( $hFile )