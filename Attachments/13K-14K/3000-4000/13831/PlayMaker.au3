#Include <GUIConstants.au3>

HotKeySet("{DEL}", "DeletePlayer")
Global $Player1[12], $Player2[12], $MaxLineArray1[100], $MaxLineArray2[500], $MaxLineArray3[500], $MaxLineArray4[500]
Local $1 = 0, $2 = 0, $LastClick = "", $LineArray = 0, $LastYPos = 0, $click = ""
$GUI = GUICreate("Football PlayMaker", 500, 480)
$Back = GuiCtrlCreateGraphic(0, 0)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0x00D800)
GUICtrlSetGraphic(-1, $GUI_GR_RECT, 0, 0, 500, 400)
GUICtrlSetState(-1, $GUI_DISABLE)
GUICtrlCreateLabel("______________________________________________________________________________________", 0, 200, 500, 20)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$AddPlayer1 = GUICtrlCreateButton("Add Player-Team1", 10, 440, 100)
$AddPlayer2 = GUICtrlCreateButton("Add Player-Team2", 10, 410, 100)
$DrawFootsteps    = GUICtrlCreateButton("Draw FootSteps", 160, 410, 100)
$ClearFootsteps   = GUICtrlCreateButton("Clear All FootSteps", 160, 440, 100)
$AllTeamMates = GUICtrlCreateButton("Add All Players", 310, 410, 100)
$DeleteAll    = GUICtrlCreateButton("Delete All Players", 310, 440, 100)
GuiSetState()

While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $DeleteAll
			DeleteAllPlayers()
		Case $msg = $AllTeamMates
			AllTeamMates()
		Case $msg = $AddPlayer2
			_Team1Add()
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $AddPlayer1
			_Team2Add()
		Case $msg = $DrawFootsteps
			_DrawFootsteps()
		Case $msg = $ClearFootsteps
			ClearFootsteps()
	EndSelect
	If $1 <> 0 Then
		For $i = 0 To $1-1
			Select
				Case $msg = $Player1[$i]
					$LastClick = $Player1[$i]
					$click = "1"
					Do
						Sleep(10)
						$cursor = GUIGetCursorInfo()
						If $cursor[1] < 232 Then $cursor[1] = 232
						If $cursor[1] > 385 Then $cursor[1] = 385
						If $cursor[0] < 15 Then $cursor[0] = 15
						If $cursor[0] > 485 Then $cursor[0] = 485
						GUICtrlSetPos($Player1[$i], $cursor[0]-10, $cursor[1]-10)
					Until $cursor[2] = 0
			EndSelect
		Next
	EndIf
	If $2 <> 0 Then
		For $c = 0 To $2-1
			Select
				Case $msg = $Player2[$c]
					$LastClick = $Player2[$c]
					$click = "2"
					Do
						Sleep(10)
						$cursor = GUIGetCursorInfo()
						If $cursor[1] < 15 Then $cursor[1] = 15
						If $cursor[1] > 192 Then $cursor[1] = 192
						If $cursor[0] < 15 Then $cursor[0] = 15
						If $cursor[0] > 485 Then $cursor[0] = 485
						GUICtrlSetPos($Player2[$c], $cursor[0]-10, $cursor[1]-10)
					Until $cursor[2] = 0
			EndSelect
		Next
	EndIf
	Sleep(10)
WEnd

Func _Team2Add()
	If $1 > 11 Then
		MsgBox(0,"","Too many players on Team 2")
	Else
		$Player1[$1] = GuiCtrlCreateGraphic(225,250,21,21)
		GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0x0000ff)
		GUICtrlSetGraphic(-1, $GUI_GR_PIE, 10, 10, 10, 90, 360)
		GUICtrlSetState(-1, $GUI_SHOW)
		$1 = $1+1
	EndIf
EndFunc

Func _Team1Add()
	If $2 > 11 Then
		MsgBox(0,"","Too many players on Team 1")
	Else
		$Player2[$2] = GuiCtrlCreateGraphic(225,150,21,21)
		GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xff0000)
		GUICtrlSetGraphic(-1, $GUI_GR_PIE, 10, 10, 10, 270, 360)
		GUICtrlSetState(-1, $GUI_SHOW)
		$2 = $2+1
	EndIf
EndFunc

Func DeletePlayer()
	Local $opt = Opt("WinTitleMatchMode", 4)
    If WinGetHandle("active") = $GUI Then
        If @HotKeyPressed = "{DEL}" Then
			If $click <> "" Then
				If $click = "1" Then $1 = $1-1
				If $click = "2" Then $2 = $2-1
				GUICtrlDelete($LastClick)
			EndIf
        EndIf
    Else
        HotKeySet(@HotKeyPressed)
        Send(@HotKeyPressed)
        HotKeySet(@HotKeyPressed, "DeletePlayer")
    EndIf
    Opt("WinTitleMatchMode", $opt)
EndFunc

Func _DrawFootsteps()
	Local $x = 1
	GUICtrlSetState($AllTeamMates, $GUI_DISABLE)
	GUICtrlSetState($ClearFootsteps, $GUI_DISABLE)
	GUICtrlSetState($AddPlayer1, $GUI_DISABLE)
	GUICtrlSetState($AddPlayer2, $GUI_DISABLE)
	GUICtrlSetData($DrawFootsteps, "End Footsteps")
	While $x = 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $GUI_EVENT_CLOSE
				Exit
			Case $msg = $DrawFootsteps
				$x = 0
		EndSelect
		$cursor2 = GUIGetCursorInfo()
		If $cursor2[1] < 385 Then
			If $cursor2[2] = 1 AND $LastYPos <> $cursor2[1] Then
				$LineArray = $LineArray + 1
				$LastYPos = $cursor2[1]
				$MaxLineArray1[$LineArray] = GUICtrlCreateGraphic($cursor2[0], $cursor2[1], 4, 4)
				GUICtrlSetGraphic(-1, $GUI_GR_DOT, 1, 1)
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x050205)
				GUICtrlSetState(-1, $GUI_SHOW)
				$MaxLineArray2[$LineArray] = GUICtrlCreateGraphic($cursor2[0]+4, $cursor2[1], 4, 4)
				GUICtrlSetGraphic(-1, $GUI_GR_DOT, 1, 1)
				GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x050205)
				GUICtrlSetState(-1, $GUI_SHOW)
				Sleep(100)
			EndIf
		EndIf
		Sleep(10)
	WEnd
	GUICtrlSetState($AllTeamMates, $GUI_ENABLE)
	GUICtrlSetState($AddPlayer1, $GUI_ENABLE)
	GUICtrlSetState($AddPlayer2, $GUI_ENABLE)
	GUICtrlSetState($ClearFootsteps, $GUI_ENABLE)
	GUICtrlSetData($DrawFootsteps, "Draw Footsteps")
EndFunc

Func ClearFootsteps()
	For $i = 0 To $LineArray
		GUICtrlDelete($MaxLineArray1[$i])
		GUICtrlDelete($MaxLineArray2[$i])
		GUICtrlDelete($MaxLineArray3[$i])
	Next
	$LineArray = 0
EndFunc

Func AllTeamMates()
	Local $End = 1, $xP = 0
	If $1 > 0 OR $2 > 0 Then
		$cMsgbox = MsgBox(4, "","Are you sure you want to delete all current" & @CRLF & "players and set them to default positions ?")
		If $cMsgbox = 7 Then $End = 0
	EndIf
	If $End = 1 Then
		$1 = 0
		$2 = 0
		For $b = 0 To 11
			$xP = $xP + 36
			$Player1[$1] = GuiCtrlCreateGraphic($xP,222,21,21)
			GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0, 0x0000ff)
			GUICtrlSetGraphic(-1, $GUI_GR_PIE, 10, 10, 10, 90, 360)
			GUICtrlSetState(-1, $GUI_SHOW)
			$1 = $1 + 1
			$Player2[$2] = GuiCtrlCreateGraphic($xP,182,21,21)
			GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xff0000)
			GUICtrlSetGraphic(-1, $GUI_GR_PIE, 10, 10, 10, 270, 360)
			GUICtrlSetState(-1, $GUI_SHOW)
			$2 = $2 + 1
		Next
	EndIf
EndFunc

Func DeleteAllPlayers()
	For $i = 0 To $1-1
		GUICtrlDelete($Player1[$i])
	Next
	For $i = 0 To $2-1
		GUICtrlDelete($Player2[$i])
	Next
	$1 = 0
	$2 = 0
EndFunc