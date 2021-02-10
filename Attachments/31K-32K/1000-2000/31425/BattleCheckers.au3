#include <Array.au3>
#include <File.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

If _Singleton (@ScriptName, 1) = 0 Then ProcessClose(@ScriptName); prevent duplicate processes

Global $GUI_Main, $hPName[2], $hFont
Global $Grid[10][10]
Global $Grid_Label[8][8] ; row,column
Global $PName[2], $Label_PName[2], $Label_Pieces[2], $PWins[2] = [0, 0], $Label_Wins[2]
Global $Speed, $Radio_Speed[3][3] = [[0, " SLOW", 500],[0, " FAST", 250],[0, " MAX", 0]] ; ctrlid, title, delay
Global $Match_Mode, $Match, $Radio_Match[3][2] = [[0, 10],[0, 25],[0, 50]] ; ctrlid, games
Global $Check_Show_Moves, $Show_Moves = 1, $Label_Player[2][3] = [[0, Chr(69), ""],[0, "",Chr(70)]] ; ctrlid, mask_p0, mask_p1 for "turn arrow"
Global $Piece_Char[5] = ["", Chr(108), Chr(108), Chr(174), Chr(174)]
Global $PColor[4] = [0x000000, 0xFFFFFF, 0x000000, 0xFFFFFF], $Current_Player = 0, $Jump_Completed
Global $Game_over, $games_played, $move, $moves_found, $new_king, $jump_made, $Temp_Label[9] ; temp labels: selected, moves * 4, jumps * 4

;GUI_Main()
GUI_Main()
Setup()

While 1
	Reset_Board()
	If $games_played = $Radio_Match[$Match][1] Then Setup()
	While 1
		$msg = GUIGetMsg()
		If $msg = -3 Then ExitLoop(2)
		Preturn_Update()
		If $Game_over Then
			If $hPName[0] And $hPName[1] Then ; no human players
				Beep(800,100)
				$games_played += 1
			Else
				MsgBox(1,"","Game over. " & $PName[Not $Current_Player] & " wins!")
			EndIf
			$PWins[Not $Current_Player] += 1
			ExitLoop
		EndIf
		If $PName[$Current_Player] = "Human" Then
			Manual_Play($Grid)
			Switch_Player()
		Else
			Call_Child($Current_Player)
;			MsgBox(1,"move returned",$move)
			Sleep($Radio_Speed[$Speed][2])
			$moves = StringSplit($move, "|")
			For $x = 1 to $moves[0]
				If Valid_Move($moves[$x]) Then
					$move = StringSplit($moves[$x], "", 2)
					If $Show_Moves Then
						Show_Temp_Pieces($move[0],$move[1])
						Sleep($Radio_Speed[$Speed][2] * 2)
						Clear_Temp_Pieces()
					EndIf
					Execute_Move($moves[$x])
				EndIf
			Next
			Switch_Player()
		EndIf
	WEnd
	Switch_Player()
WEnd
Exit_Script()

Func Switch_Player()
	$Current_Player = Number(Not $Current_Player)
	GUICtrlSetData($Label_Player[0][0], $Label_Player[$Current_Player][1])
	GUICtrlSetData($Label_Player[1][0], $Label_Player[$Current_Player][2])
EndFunc

Func Preturn_Update()
	Local $pieces[2] = [0, 0]
	$new_king = 0
	$Game_over = 1
	$jump_made = 0
	For $x = 1 to 8
		For $y = 1 to 8
			If Mod($x + $y, 2) Then ; dark square
				Switch Grid_State($x, $y)
					Case "P"
						$pieces[$Current_Player] += 1
						If Show_Temp_Pieces($x, $y, 0, 0) Then $Game_over = 0
					Case "O"
						$pieces[Not $Current_Player] += 1
				EndSwitch
			EndIf
		Next
	Next
	For $x = 0 to 1
		GUICtrlSetData($Label_Pieces[$x], "PIECES REMAINING: " & $pieces[$x])
	Next
EndFunc

;===================================================================================================================================
Func GUI_Main()
	$GUI_Main = GUICreate("", 500, 640, Default, Default)
	GUICtrlCreateLabel("B A T T L E   C H E C K E R S ", 50,4,400,32, $SS_CENTER)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 18, 600, Default, "Comic Sans MS")
	GUICtrlCreateLabel("v0.0", 466, 19, 20, 12)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 8, 400, Default, "Comic Sans MS")
	GUISetBkColor(0xA0A0A0) ;Grey background
	GUICtrlCreateGraphic(10, 40, 480, 480, $SS_BLACKFRAME)
	GUICtrlSetBkColor(-1, 0xFFFFE0)
	GUICtrlSetState(-1, $GUI_DISABLE)

	$Label_PName[0] = GUICtrlCreateLabel("", 30, 530, 160, 28, $SS_CENTER)
;	$Label_PName[0] = GUICtrlCreateLabel($PName[0], 30, 530, 160, 28, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[0])
	GUICtrlSetFont(-1, 16, 600, Default, "Comic Sans MS")
	$Label_Player[0][0] = GUICtrlCreateLabel($Label_Player[0][1], 190, 527, 30, 40, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[0])
	GUICtrlSetFont(-1, 28, 600, Default, "Wingdings")

	$Label_Player[1][0] = GUICtrlCreateLabel("", 280, 527, 30, 40, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 28, 600, Default, "Wingdings")
	$Label_PName[1] = GUICtrlCreateLabel($PName[1], 315, 530, 160, 28, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 16, 600, Default, "Comic Sans MS")

	$Label_Pieces[0] = GUICtrlCreateLabel("PIECES REMAINING: 12", 25, 570, 180, 16)
	GUICtrlSetColor(-1, $PColor[0])
	GUICtrlSetFont(-1, 9, 600, Default, "Comic Sans MS")
	$Label_Pieces[1] = GUICtrlCreateLabel("PIECES REMAINING: 12", 315, 570, 180, 16)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 9, 600, Default, "Comic Sans MS")

	$Label_Wins[0] = GUICtrlCreateLabel("GAMES WON: 0", 45, 585, 180, 20)
	GUICtrlSetColor(-1, $PColor[0])
	GUICtrlSetFont(-1, 12, 400, Default, "Comic Sans MS")
	$Label_Wins[1] = GUICtrlCreateLabel("GAMES WON: 0", 335, 585, 180, 20)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 12, 400, Default, "Comic Sans MS")

	For $x = 0 To 7
		For $y = 0 to 7
			If Mod($x + $y, 2) Then
				GUICtrlCreateGraphic($y * 60 + 10, $x * 60 + 40, 60, 60)
				GUICtrlSetBkColor(-1, 0x7FAC7F)
				GUICtrlSetState(-1, $GUI_DISABLE)
			EndIf
        Next
    Next
	GUISetState(@SW_SHOW)
	GUIRegisterMsg($WM_COPYDATA, "WM_COPYDATA")
EndFunc

Func Setup()
	Local $aAI_List = _FileListToArray(@ScriptDir, "bc_*.exe", 1)
	If Not IsArray($aAI_List) Then Local $aAI_List[1]
	$aAI_List[0] = "...Human...." ; manual play
	For $x = 0 to UBound($aAI_List) - 1
		$aAI_List[$x] = StringMid($aAI_List[$x], 4, StringLen($aAI_List[$x]) - 7)
	Next
	$GUI_Setup = GUICreate("Battle Checkers Setup", 320, 250, Default, Default, $WS_POPUPWINDOW)
	GUISetBkColor(0xA0A0A0) ;Grey background
	GUICtrlCreateLabel("B A T T L E   C H E C K E R S   S E T U P ", 5, 4, 320, 20, $SS_CENTER)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 10, 600, Default, "Comic Sans MS")
	GUICtrlCreateLabel("P l a y e r   1", 5, 44, 150, 20, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[0])
	GUICtrlSetFont(-1, 10, 600, Default, "Comic Sans MS")
	GUICtrlCreateLabel("P l a y e r   2", 165, 44, 150, 20, $SS_CENTER)
	GUICtrlSetColor(-1, $PColor[1])
	GUICtrlSetFont(-1, 10, 600, Default, "Comic Sans MS")
	$AI_List = _ArrayToString($aAI_List)
	$hFont = _WinAPI_CreateFont(16, 0); 12 pixels = 7.5 point? 15pix = 9pt?

	$Combo_1 = _GUICtrlComboBox_Create($GUI_Setup, $AI_List, 15, 70, 130, 16, $CBS_DROPDOWNLIST)
	_WinAPI_SetFont($Combo_1, $hFont)
	_GUICtrlComboBox_SetItemHeight($Combo_1, 16)
	_GUICtrlComboBox_SetCurSel($Combo_1, 0) ; select first item
	$Combo_2 = _GUICtrlComboBox_Create($GUI_Setup, $AI_List, 175, 70, 130, 16, $CBS_DROPDOWNLIST)
	_WinAPI_SetFont($Combo_2, $hFont)
	_GUICtrlComboBox_SetItemHeight($Combo_2, 16)
	_GUICtrlComboBox_SetCurSel($Combo_2, 0) ; select first item

	GUICtrlCreateLabel("A N I M A T I O N   S P E E D ", 5, 105, 320, 20, $SS_CENTER)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 8, 600, Default, "Comic Sans MS")
	GUIStartGroup()
	For $x = 0 to 2
		$Radio_Speed[$x][0] = GUICtrlCreateRadio($Radio_Speed[$x][1], 70 + $x * 70, 120)
	Next
	GUICtrlSetState($Radio_Speed[$Speed][0], $GUI_CHECKED)
	GUICtrlCreateLabel("SHOW AVAILABLE MOVES", 75, 150, 160, 20)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 8, 600, Default, "Comic Sans MS")
	$Check_Show_Moves = GUICtrlCreateCheckbox("", 240, 149, 12, 16)
	If $Show_Moves Then GUICtrlSetState(-1, $GUI_CHECKED)
	GUICtrlCreateLabel("M A T C H   L E N G T H", 5, 175, 320, 20, $SS_CENTER)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetFont(-1, 8, 600, Default, "Comic Sans MS")
	GUIStartGroup()
	For $x = 0 to 2
		$Radio_Match[$x][0] = GUICtrlCreateRadio($Radio_Match[$x][1] & " games", 40 + $x * 80, 190)
	Next
	GUICtrlSetState($Radio_Match[$Match][0], $GUI_CHECKED)
	$Button_Play = GUICtrlCreateButton("P L A Y", 120, 220, 80, 26, $SS_CENTER)
	GUICtrlSetColor(-1, 0xC02050)
	GUICtrlSetBkColor(-1, 0xD0D0D0)
	GUICtrlSetFont(-1, 10, 600, Default, "Comic Sans MS")
	GUISetState(@SW_SHOW)
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case -3
				Exit_Script()
			Case $Button_Play
				$PName[0] = $aAI_List[_GUICtrlComboBox_GetCurSel($Combo_1)]
				If $PName[0] <> "Human" Then Initialize_Child(0)
				$PName[1] = $aAI_List[_GUICtrlComboBox_GetCurSel($Combo_2)]
				If $PName[1] <> "Human" Then Initialize_Child(1)
				For $x = 0 to 2
					If GUICtrlRead($Radio_Speed[$x][0]) = $GUI_CHECKED Then $Speed = $x
					If GUICtrlRead($Radio_Match[$x][0]) = $GUI_CHECKED Then $Match = $x
				Next
				$Show_Moves = GUICtrlRead($Check_Show_Moves) = $GUI_CHECKED
				GUIDelete($GUI_Setup)
				Return
		EndSwitch
	WEnd
EndFunc

;===================================================================================================================================
Func Reset_Board()
	For $x = 1 to 8
		For $y = 1 to 8
			GUICtrlDelete($Grid_Label[$x - 1][$y - 1])
			$Grid_Label[$x - 1][$y - 1] = GUICtrlCreateLabel("", $y * 60 - 50, $x  * 60 - 18, 0, 0, BitOR($SS_CENTER, $SS_CENTERIMAGE))
			GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
			GUICtrlSetFont(-1, 60, "", "", "Wingdings")
			$Grid[$x][$y] = -1
			If Mod($x + $y, 2) Then
				Switch $x
					Case 1, 2, 3
						$Grid[$x][$y] = "2"
					Case 4, 5
						$Grid[$x][$y] = "0"
					Case 6, 7, 8
						$Grid[$x][$y] = "1"
				EndSwitch
			Else
				GUICtrlSetState(-1, $GUI_DISABLE) ; light square (invalid)
			EndIf
			If $Grid[$x][$y] > 0 Then ; any piece
				GUICtrlSetData($Grid_Label[$x - 1][$y - 1], $Piece_Char[$Grid[$x][$y]]) ; normal or king
				GUICtrlSetColor($Grid_Label[$x - 1][$y - 1], $PColor[$Grid[$x][$y] - 1])
			Else
				GUICtrlSetData($Grid_Label[$x - 1][$y - 1], "")
			EndIf
		Next
		$Grid[$x][0] = -1
		$Grid[$x][9] = -1
	Next
	For $x = 0 to 9
		$Grid[0][$x] = -1
		$Grid[9][$x] = -1
	Next
	For $x = 0 to 1
		GUICtrlSetData($Label_PName[$x] & " " & $x + 1, $PName[$x])
		GUICtrlSetData($Label_Wins[$x], "GAMES WON: " & $PWins[$x])
	Next
EndFunc

;==================================================================================================================
Func Valid_Move($move)
	Local $moves = StringSplit($move, "|")
	$move = StringSplit($moves[1], "") ; loop for multiple moves

	If Grid_State($move[1], $move[2]) = "O" Then Return ; moving opponents piece
	If $Grid[$move[3]][$move[4]] <> 0 Then Return ; destination not vacant
	If $move[1] = $move[3] Or $move[2] = $move[4] Then Return ; move not diagonal
	$xx = ($move[1] - $move[3]) / Abs($move[1] - $move[3]) ; direction of move: -1 = up, 1 = down
	If $Grid[$move[1]][$move[2]] < 3 And ($xx > 0) =  $Current_Player Then Return ; not king - moving in wrong direction
	$xx = Abs($move[1] - $move[3])
	$yy = Abs($move[2] - $move[4])
	If $xx = 2 And $yy = 2 Then ; moving 2 squares
		If Grid_State(($move[1] + $move[3]) / 2, ($move[2] + $move[4]) / 2) = "O" Then
			Return 2 ; valid jump
		Else
			Return; not jump of opponent
		EndIf
	EndIf
	If $jump_made Or $xx <> 1 Or $yy <> 1 Then Return; jump completed or not moving 1 square
	Return 1 ; valid move
EndFunc

Func Execute_Move($move)
	$move = StringSplit($move, "")
	$y = $Grid[$move[1]][$move[2]]
	$Grid[$move[1]][$move[2]] = 0 ; clear starting square
	GUICtrlSetData($Grid_Label[$move[1] - 1][$move[2] - 1], "")
	If $move[3] = 1 Or $move[3] = 8 And $y < 3 Then ; king me!
		$y += 2
		$new_king = 1
	EndIf
	$Grid[$move[3]][$move[4]] = $y
	GUICtrlSetData($Grid_Label[$move[3] - 1][$move[4] - 1], $Piece_Char[$Grid[$move[3]][$move[4]]]) ; normal or king
	GUICtrlSetColor($Grid_Label[$move[3] - 1][$move[4] - 1], $PColor[$y - 1])
	If Abs($move[1] - $move[3]) = 2 And Abs($move[2] - $move[4]) = 2 Then ; remove jumped piece
		$jump_made = 1
		$xx = ($move[1] + $move[3]) / 2
		$yy = ($move[2] + $move[4]) / 2
		$Grid[$xx][$yy] = 0
		GUICtrlSetData($Grid_Label[$xx - 1][$yy - 1], "")
	EndIf
	Sleep($Radio_Speed[$Speed][2] / 5)
;	_ArrayDisplay($Grid)
EndFunc

Func Show_Temp_Pieces($xx, $yy, $jumps_only = 0, $draw = 1)
	Local $king = ($Grid[$xx][$yy] > 2), $z
	$moves_found = 0
	If $draw Then Clear_Temp_Pieces()
	If $draw Then Draw_Temp_Piece($xx, $yy, 0, 165, 37, 0x556B2F, $GUI_BKCOLOR_TRANSPARENT)
	For $x = -1 To 1 Step 2
		For $y = -1 To 1 Step 2
			$z += 1
			If $king Or ($x > 0 And $Current_Player) Or ($x < 0 And Not $Current_Player) Then
				Switch Grid_State($xx + $x, $yy + $y)
					Case "E" ; empty
						If Not $jumps_only Then
							If $draw Then Draw_Temp_Piece($xx + $x, $yy + $y, $z, 165, 46, 0x808080, $GUI_BKCOLOR_TRANSPARENT)
							$moves_found = 1
						EndIf
					Case "O" ; opponent
						If Grid_State($xx + $x + $x, $yy + $y + $y) = "E" Then ; jump possible
							If $draw Then Draw_Temp_Piece($xx + $x, $yy + $y, $z + 4, 78, 30, $PColor[$Current_Player], $GUI_BKCOLOR_TRANSPARENT)
							If $draw Then Draw_Temp_Piece($xx + $x + $x, $yy + $y + $y, $z, 165, 46, 0x808080, $GUI_BKCOLOR_TRANSPARENT)
							$moves_found = 1
						EndIf
				EndSwitch
			EndIf
		Next
	Next
	Return $moves_found
EndFunc

Func Draw_Temp_Piece($x, $y, $z, $char, $size, $color, $bkcolor)
	$Temp_Label[$z] = GUICtrlCreateLabel("", $y * 60 - 50, $x  * 60 - 19, 0, 0, BitOR($SS_CENTER, $SS_CENTERIMAGE))
	GUICtrlSetBkColor(-1, $bkcolor)
	GUICtrlSetColor(-1, $color)
	GUICtrlSetFont(-1, $size, "", "", "Wingdings")
	GUICtrlSetData(-1, Chr($char))
EndFunc

Func Clear_Temp_Pieces()
	For $x = 0 to 8
		GUICtrlDelete($Temp_Label[$x])
	Next
EndFunc

Func Grid_State($x, $y)
	Switch $Grid[$x][$y]
		Case -1
			Return "X" ; invalid
		Case 0
			Return "E" ; empty
		Case 1, 3
			If $Current_Player Then	Return "O" ; opponent
			Return "P" ; player
		Case 2, 4
			If $Current_Player Then	Return "P" ; player
			Return "O" ; opponent
	EndSwitch
EndFunc

;===================================================================================================================================
Func Manual_Play($array)
	Local $move, $state
	While 1
		$msg = GUIGetMsg()
		Switch $msg
			Case $Grid_Label[0][0] To $Grid_Label[7][7]
				$row = Int(($msg - $Grid_Label[0][0]) / 8) + 1
				$col = Mod($msg - $Grid_Label[0][0], 8) + 1
				$state = Grid_State($row, $col)
				If $state = "O" Then ContinueLoop ; selected opponents piece
				If $state = "E" And $move = "" Then	ContinueLoop ; selected empty square before piece
				If $state = "P" Then
					If $jump_made Then ContinueLoop
					$move = $row & $col
					Show_Temp_Pieces($row, $col)
					ContinueLoop
				Else ; $tate = "E" - empty square
					$x = Valid_Move($move & $row & $col)
					If Not $x Then ContinueLoop ; invalid move
					Execute_Move($move & $row & $col)
					If $x = 1 Or $new_king Then ExitLoop ; not a jump, or new king - end turn
					Show_Temp_Pieces($row, $col, $jump_made)
					If Not $moves_found Then ExitLoop ; no additional jumps available - end turn
					$move = $row & $col
				EndIf
			Case -3
				Exit_Script()
		EndSwitch
	WEnd
	Clear_Temp_Pieces()
EndFunc

;===================================================================================================================================
Func Initialize_Child($player)
	$move = ""
	ShellExecute("bc_" & $PName[$player] & ".exe", $GUI_Main & " " & $player + 1) ; start child process - send parent handle and player #
	While Not $move ; wait for child process to return it's handle
		Sleep(50)
	WEnd
	$hPName[$player] = HWnd($move)
EndFunc

Func Call_Child($player)
	Local $string
	For $x = 1 to 8
		For $y = 1 to 8
			If Mod($x + $y, 2) Then $string &= $Grid[$x][$y] ; dark space
		Next
	Next
	$move = ""
	WM_COPYDATA_SendData($hPName[$player], $string) ; send grid array
	While Not $move ; wait for reply
		Sleep(50)
	WEnd
EndFunc

Func WM_COPYDATA($hWnd, $MsgID, $wParam, $lParam)
    Local $tCOPYDATA = DllStructCreate("dword;dword;ptr", $lParam)
    Local $tMsg = DllStructCreate("char[" & DllStructGetData($tCOPYDATA, 2) & "]", DllStructGetData($tCOPYDATA, 3))
    $move = DllStructGetData($tMsg, 1) ; move received from child process
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

Func Exit_Script()
	_WinAPI_DeleteObject($hFont)
	While ProcessExists("bc_" & $PName[0] & ".exe") ; kill current child and any dupes from aborted tests
			ProcessClose("bc_" & $PName[0] & ".exe")
	WEnd
	While ProcessExists("bc_" & $PName[1] & ".exe")
			ProcessClose("bc_" & $PName[1] & ".exe")
	WEnd
	Exit
EndFunc
