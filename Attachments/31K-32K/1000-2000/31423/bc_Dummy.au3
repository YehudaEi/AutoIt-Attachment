; Battle Checkers AI Module Instructions ===========================================================================================
; This script receives the player number and current board state from the parent program, BattleCheckers.exe.
; The incoming data from the parent is converted into a global array representing the current play field to be used by the user-written
; Move_Piece() function.  The Move_Piece() function needs to return a string indicating the players next move.
; This module needs to be compiled with "bc_" as the first part of the filename.
;
; Input data used by Move_Piece():
;
; $player ; either 1 or 2, indicates which player this script is playing.
;
; $aGrid[10][10] ; current state of playfield in row/column format.  The usuable portions of the array are rows 1 through 9, and
; columns 1 through 8.  Elements in the array will contain the following values:
;	-1 = invalid square. Either a "border" square (column/row 0 or 9), or a light-colored (unusable) square on the playfield.
;	 0 = empty square. A usable square that is unoccupied by any player peice.
;	 1 = A square occupied by a normal piece belonging to player 1.
;	 2 = A square occupied by a normal piece belonging to player 2.
;	 3 = A square occupied by a kinged piece belonging to player 1.
;	 4 = A square occupied by a kinged piece belonging to player 2.
;
; Output data from Move_Piece():
;
; $Move ; The next move for this player.  It should be the parameter of a Return() statement from the Move_Piece() function.
; The $Move variable should be a four-byte string in the following format:
; Byte 1 =  starting row
; Byte 2 =  starting column
; Byte 3 =  ending row
; Byte 4 =  ending column
; $Move = "3243" ; would move the piece form row 3, column 2 to row 4, column 3.
; Multiple jumps can be concatenated using a "}" as a delimiter.
; $Move = "3254|5436" would request a double-jump.
;

;===================================================================================================================================

#NoTrayIcon
#include <Array.au3>
;#include <Misc.au3>
#include <WindowsConstants.au3>

;==== These variables are required =================================================================================================
Global $hParent = HWnd($CmdLine[1])
Global $player = $CmdLine[2]
Global $aGrid[10][10], $move

;---- User-defined variables -------------------------------------------------------------------------------------------------------
Global $opponent = 1 + ($player = 1), $dir = $player - 2 + ($player = 2) ; direction to move my normal pieces: p1 = -1 (up), p2 = 1 (down)

;===================================================================================================================================
; The function and loop below are required
Initialize()
While 1
	Sleep(10)
WEnd
;===================================================================================================================================

;===================================================================================================================================
; This function is all yours...
Func Move_Piece()
	$move = ""
	Find_Jumps()
	If Not $move Then Find_Move()
	Return $move
EndFunc

Func Find_Jumps() ; look for single or multiple jumps
	Local $aMoves
	For $y = 1 to 8
		For $x = 1 to 8
			$move &= Find_Jump($y, $x, $aGrid)
		Next
	Next
	If $move = "" Then Return
	$aMoves = StringSplit(StringTrimRight($move, 1), "|")
	Find_Best_Jump($aMoves)
	If $aMoves[0] = 1 Then
		$move = $aMoves[1]
	Else
		$move = $aMoves[Random(1, $aMoves[0], 1)]
	EndIf
EndFunc

Func Find_Jump($y, $x, $aTempGrid)
	Local $str
	If $aTempGrid[$y][$x] = $player Or $aTempGrid[$y][$x] = $player + 2 Then ; my piece - normal piece or king
		If ($aTempGrid[$y + $dir][$x - 1] = $opponent Or $aTempGrid[$y + $dir][$x - 1] = $opponent + 2) _ ; adjacent opponent - left
		And $aTempGrid[$y + $dir + $dir][$x - 2] = "0" Then
			$str &= $y & $x & $y + $dir + $dir & $x - 2 & "|"
		EndIf
		If ($aTempGrid[$y + $dir][$x + 1] = $opponent Or $aTempGrid[$y + $dir][$x + 1] = $opponent + 2) _ ; adjacent opponent - right
		And $aTempGrid[$y + $dir + $dir][$x + 2] = "0" Then
			$str &= $y & $x & $y + $dir + $dir & $x + 2 & "|"
		EndIf
	EndIf
	If $aTempGrid[$y][$x] = $player + 2 Then ; my piece - king
		If ($aTempGrid[$y - $dir][$x - 1] = $opponent Or $aTempGrid[$y - $dir][$x - 1] = $opponent + 2) _ ; adjacent opponent - left
		And $aTempGrid[$y - $dir - $dir][$x - 2] = "0" Then
			$str &= $y & $x & $y - $dir - $dir & $x - 2 & "|"
		EndIf
		If ($aTempGrid[$y - $dir][$x + 1] = $opponent Or $aTempGrid[$y - $dir][$x + 1] = $opponent + 2) _ ; adjacent opponent - right
		And $aTempGrid[$y - $dir - $dir][$x + 2] = "0" Then
			$str &= $y & $x & $y - $dir - $dir & $x + 2 & "|"
		EndIf
	EndIf
	Return $str
EndFunc

Func Find_Best_Jump(ByRef $aMoves)
	Local $aTempGrid = $aGrid, $aJumps[$aMoves[0] + 1], $idx = 1
	For $x = 1 to $aMoves[0]
		$aGrid = $aTempGrid
		$str = $aMoves[$x]
		While $str
			$aJumps[$x] += 1
			$z = StringSplit(StringRight($str, 4), "")
			$aGrid[$z[3]][$z[4]] = $aGrid[$z[1]][$z[2]]
			$aGrid[$z[1]][$z[2]] = "0"
			$aGrid[($z[1] + $z[3]) / 2][($z[2] + $z[4]) / 2] = 0 ; clear jumped piece (temporarily)
			$str = StringLeft(Find_Jump($z[3], $z[4], $aGrid), 4) ; lazy - am skipping multiple branches
			If $str Then $aMoves[$x] &= "|" & $str
		WEnd
	Next
	$aGrid = $aTempGrid
	For $x = 1 to $aMoves[0] ; pack array
		If $aJumps[$x] = _ArrayMax($aJumps, 1, 1) Then
			$idx += 1
		Else
			$aMoves[0] -= 1
			For $y = $idx to $aMoves[0]
				$aMoves[$y] = $aMoves[$y + 1]
			Next
		EndIf
	Next
	ReDim $aMoves[$aMoves[0] + 1]
EndFunc

Func Find_Move()
	Local $aMoves
	For $y = 1 to 8
		For $x = 1 to 8
			If $aGrid[$y][$x] = $player Or $aGrid[$y][$x] = $player + 2 Then ; my piece - normal piece or king
				If $aGrid[$y + $dir][$x - 1] = "0" Then $move &= $y & $x & $y + $dir & $x - 1 & "|"
				If $aGrid[$y + $dir][$x + 1] = "0" Then	$move &= $y & $x & $y + $dir & $x + 1 & "|"
			EndIf
			If $aGrid[$y][$x] = $player + 2 Then ; my piece - king
				If $aGrid[$y - $dir][$x - 1] = "0" Then $move &= $y & $x & $y - $dir & $x - 1 & "|"
				If $aGrid[$y - $dir][$x + 1] = "0" Then	$move &= $y & $x & $y - $dir & $x + 1 & "|"
			EndIf
		Next
	Next
	$aMoves = StringSplit(StringTrimRight($move, 1), "|")
	Find_Best_Move($aMoves)
	If $aMoves[0] = 1 Then
		$move = $aMoves[1]
	Else
		$move = $aMoves[Random(1, $aMoves[0], 1)]
	EndIf
EndFunc

Func Find_Best_Move(ByRef $aMoves) ; doesn't account for enemy kings
	Local $safe_move, $z, $array[$aMoves[0] + 1] = [$aMoves[0]], $idx = 1
	For $x = 1 to $aMoves[0]
		$z = StringSplit($aMoves[$x], "")
		$array[$x] = 0
		If $aGrid[$z[3] + $z[3] - $z[1]][$z[4] + $z[4] - $z[2]] <> $opponent Then ; square in same dir not opponent
			If $aGrid[$z[3] + $z[3] - $z[1]][$z[2]] <> $opponent Or $aGrid[$z[1]][$z[4] + $z[4] - $z[2]] <> "0" Then ; other diagonal
				$safe_move = 1
				$array[$x] = 1
			EndIf
		EndIf
	Next
	If $safe_move Then ; pack array
		For $x = 1 To $array[0]
			If $array[$x] Then
				$idx += 1
			Else
				$aMoves[0] -= 1
				For $y = $idx to $aMoves[0]
					$aMoves[$y] = $aMoves[$y + 1]
				Next
			EndIf
		Next
		ReDim $aMoves[$aMoves[0] + 1]
	EndIf
EndFunc

;===================================================================================================================================
; The functions below are required
Func Initialize()
;	If _Singleton (@ScriptName, 1) = 0 Then ProcessClose(@ScriptName) ; prevent duplicate processes
	$hGUI = GUICreate(@ScriptName, 0, 0, -200, -200)
	GUISetState(@SW_HIDE) ; will display an empty dialog box
	GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA")
	WM_COPYDATA_SendData($hParent, $hGUI)
EndFunc

Func Load_Array($string)
	Local $z = 0
	For $x = 1 to 8
		For $y = 1 to 8
			$aGrid[$x][$y] = -1
			If Mod($x + $y, 2) Then
				$z += 1
				$aGrid[$x][$y] = StringMid($string, $z, 1) ; dark square
			EndIf
		Next
		$aGrid[$x][0] = -1
		$aGrid[$x][9] = -1
	Next
	For $x = 0 to 9
		$aGrid[0][$x] = -1
		$aGrid[9][$x] = -1
	Next
EndFunc

Func WM_COPYDATA($hWnd, $MsgID, $wParam, $lParam) ; triggers the user Move() function then sends it's response to parent
    Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
    Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
	Load_Array(DllStructGetData($tMsg, 1)) ; split received string into array
	WM_COPYDATA_SendData($hParent, Move_Piece()) ; send result of move() to parent process
    Return
EndFunc

Func WM_COPYDATA_SendData($hWnd, $sData)
    Local $tCOPYDATA = DllStructCreate("dword;dword;ptr")
    Local $tMsg = DllStructCreate("char[" & StringLen($sData) + 1 & "]")
    DllStructSetData($tMsg, 1, $sData)
    DllStructSetData($tCOPYDATA, 2, StringLen($sData) + 1)
    DllStructSetData($tCOPYDATA, 3, DllStructGetPtr($tMsg))
    $Ret = DllCall("user32.dll", "lparam", "SendMessage", "hwnd", $hWnd, "int", $WM_COPYDATA, "wparam", 0, "lparam", DllStructGetPtr($tCOPYDATA))
    Return
EndFunc
