#include <GUIConstants.au3>
$Size = 400 ; Multiple of 50
$Grid = 50 ; Grid size (in px)
$SinglePlayer = 1
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
$e = 1
$f = 1
Global $P1 = 0
Global $P2 = 0
Global $P3 = 0
$Player = 1
$Pause = 0
$hwnd = GUICreate("Reversi!", $Size + 300, $Size)
$CPlayer = GUICtrlCreateLabel ( "Player 1", $Size + 5, 5, 290, 32, $SS_CENTER )
GUICtrlSetColor ( -1, 0xFF0000 )
GUICtrlSetFont ( -1, 20 )
$P1S = GUICtrlCreateLabel ( "Player 1: 2", $Size + 5, 42, 60, 18 )
GUICtrlSetColor ( -1, 0xFF0000 )
$P2S = GUICtrlCreateLabel ( "Player 2: 2", $Size + 300 - 60, 42, 60, 18 )
GUICtrlSetColor ( -1, 0x0000FF )
$ChatBox = GUICtrlCreateEdit("-Welcome to Reversi by Xenogis.", $Size + 5, $Size - $Size / 3, 290, $Size / 3 - 5, $WS_VSCROLL)
GUICtrlSetBkColor(-1, 0xffffff)
GUICtrlSetState(-1, $GUI_DISABLE)
$Message = GUICtrlCreateInput("", $Size + 5, $Size - $Size / 3 - 25, 220, 20)
$Send = GUICtrlCreateButton("Send", $Size + 230, $Size - $Size / 3 - 25, 65, 20)
GUICtrlCreateLabel("", $Size + 5, $Size - $Size / 3 - 35, 290, 2, $SS_ETCHEDFRAME)
GUICtrlCreateLabel("", 0, 0, $Size, $Size)
GUICtrlSetBkColor(-1, 0xffffff)
For $n = 1 To $Size / $Grid ; <------- grid
	GUICtrlCreateLabel("", 0, $n * $Grid, $Size, 1)
	GUICtrlSetBkColor(-1, 0xcccccc)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateLabel("", $n * $Grid, 0, 1, $Size)
	GUICtrlSetBkColor(-1, 0xcccccc)
	GUICtrlSetState(-1, $GUI_DISABLE)
Next
Dim $Circles[$Size / 50 + 1][$Size / 50 + 1]
Dim $Owners[$Size / 50 + 1][$Size / 50 + 1]
For $n = 0 To $Size / 50 ; <------ Create all the circles
	For $x = 0 To $Size / 50
		$Circles[$n][$x] = GUICtrlCreateLabel("n", $Size - $n * 50 + 1, $Size - $x * 50, 50, 50)
		GUICtrlSetFont(-1, 37, -1, -1, 'Webdings')
		GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
		ControlHide($hwnd, '', $Circles[$n][$x])
		$Owners[$n][$x] = 3
	Next
Next
ControlShow($hwnd, '', $Circles[$Size / 50 / 2 + 1][$Size / 50 / 2 + 1])
GUICtrlSetColor($Circles[$Size / 50 / 2 + 1][$Size / 50 / 2 + 1], 0xff0000)
$Owners[$Size / 50 / 2 + 1][$Size / 50 / 2 + 1] = 1

ControlShow($hwnd, '', $Circles[$Size / 50 / 2 + 1][$Size / 50 / 2])
GUICtrlSetColor($Circles[$Size / 50 / 2 + 1][$Size / 50 / 2], 0x0000ff)
$Owners[$Size / 50 / 2 + 1][$Size / 50 / 2] = 0

ControlShow($hwnd, '', $Circles[$Size / 50 / 2][$Size / 50 / 2 + 1])
GUICtrlSetColor($Circles[$Size / 50 / 2][$Size / 50 / 2 + 1], 0x0000ff)
$Owners[$Size / 50 / 2][$Size / 50 / 2 + 1] = 0

ControlShow($hwnd, '', $Circles[$Size / 50 / 2][$Size / 50 / 2])
GUICtrlSetColor($Circles[$Size / 50 / 2][$Size / 50 / 2], 0xff0000)
$Owners[$Size / 50 / 2][$Size / 50 / 2] = 1
GUISetState()
$Exit = 0
AdlibEnable ( "BackgroundFunctions", 1 )
While 1
	$msg = GUIGetMsg(1)
	If $msg[0] = -3 Then Exit
	If $msg[0] = $GUI_EVENT_PRIMARYUP Then
		$mx = $msg[3]
		$my = $msg[4]
		For $x = 0 To $Size / 50 - 1
			For $y = 0 To $Size / 50 - 1
				If $mx >= $x * 50 And $mx <= $x * 50 + 50 And $my >= $y * 50 And $my <= $y * 50 + 50 Then
					$GoodMove = Move($x, $y, $Player)
					If $Player = 1 And $SinglePlayer And $GoodMove = 1 Then
						Player ( 2 )
						$Player = 0
					ElseIf $SinglePlayer And $GoodMove = 1 Then
						Player ( 1 )
						$Player = 1
					EndIf
					If $GoodMove = 0 Then GUICtrlSetData ( $ChatBox, @CRLF & "Bad move.", 1 )
					$Exit = 1
					ExitLoop
				EndIf
				If $Exit = 1 Then ExitLoop
			Next
		Next
	EndIf
	$Exit = 0
	Sleep(1)
WEnd

Func Circle($x, $y, $Player)
	;$x = $Size/50-$x
	;$y = $Size/50-$y
	ControlShow($hwnd, '', $Circles[$x][$y])
	If $Player = 1 Then GUICtrlSetColor($Circles[$x][$y], 0xff0000)
	If $Player = 0 Then GUICtrlSetColor($Circles[$x][$y], 0x0000ff)
	$Owners[$x][$y] = $Player
EndFunc

Func Move($x, $y, $Player)
	$x = $Size / 50 - $x
	$y = $Size / 50 - $y
	$legal = 0
	$left = 0
	$right = 0
	$down = 0
	$up = 0
	$downright = 0
	$downleft = 0
	$upright = 0
	$upleft = 0
	$success = 0
	If Not ( $Owners[$x][$y] = 3 ) Then Return 0
	If $x < $Size / 50 Then
		If ControlCommand($hwnd, '', $Circles[$x + 1][$y], "IsVisible", "") And Not ($Owners[$x + 1][$y] = $Player) Then
			$legal = 1
			$left = 1
		EndIf
	EndIf
	If $y < $Size / 50 Then
		If ControlCommand($hwnd, '', $Circles[$x][$y + 1], "IsVisible", "") And Not ($Owners[$x][$y + 1] = $Player) Then
			$legal = 1
			$up = 1
		EndIf
	EndIf
	If $x < $Size / 50 And $y < $Size / 50 Then
		If ControlCommand($hwnd, '', $Circles[$x + 1][$y + 1], "IsVisible", "") And Not ($Owners[$x + 1][$y + 1] = $Player) Then
			$legal = 1
			$upleft = 1
		EndIf
	EndIf
	If $x > 0 And $y < $Size / 50 Then
		If ControlCommand($hwnd, '', $Circles[$x - 1][$y + 1], "IsVisible", "") And Not ($Owners[$x - 1][$y + 1] = $Player) Then
			$legal = 1
			$upright = 1
		EndIf
	EndIf
	If $x > 0 Then
		If ControlCommand($hwnd, '', $Circles[$x - 1][$y], "IsVisible", "") And Not ($Owners[$x - 1][$y] = $Player) Then
			$legal = 1
			$right = 1
		EndIf
	EndIf
	If $x > 0 Then
		If ControlCommand($hwnd, '', $Circles[$x][$y - 1], "IsVisible", "") And Not ($Owners[$x][$y - 1] = $Player) Then
			$legal = 1
			$down = 1
		EndIf
	EndIf
	If $x > 0 And $y > 0 Then
		If ControlCommand($hwnd, '', $Circles[$x - 1][$y - 1], "IsVisible", "") And Not ($Owners[$x - 1][$y - 1] = $Player) Then
			$legal = 1
			$downright = 1
		EndIf
	EndIf
	If $x < $Size / 50 And $y > 0 Then
		If ControlCommand($hwnd, '', $Circles[$x + 1][$y - 1], "IsVisible", "") And Not ($Owners[$x + 1][$y - 1] = $Player) Then
			$legal = 1
			$downleft = 1
		EndIf
	EndIf
	If $legal = 0 Then Return 0
	$ex = $x
	$ey = $y
	$badmove = 1
	If $left Then
		For $c = $x + 1 To $Size / 50
			If $Owners[$c][$y] = $Player Then
				$ex = $c
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
		Next
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $x + 1 To $ex
				Circle($c, $y, $Player)
			Next
		EndIf
	EndIf
	If $right Then
		$badmove = 1
		For $c = $x - 1 To 0 Step - 1
			If $Owners[$c][$y] = $Player Then
				$ex = $c
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
		Next
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $x - 1 To $ex Step - 1
				Circle($c, $y, $Player)
			Next
		EndIf
	EndIf
	If $down Then
		$badmove = 1
		For $c = $y - 1 To 0 Step - 1
			If $Owners[$x][$c] = $Player Then
				$ey = $c
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
		Next
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y - 1 To $ey Step - 1
				Circle($x, $c, $Player)
			Next
		EndIf
	EndIf
	If $up Then
		$badmove = 1
		For $c = $y + 1 To $Size / 50
			If $Owners[$x][$c] = $Player Then
				$ey = $c
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
		Next
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y + 1 To $ey
				Circle($x, $c, $Player)
			Next
		EndIf
	EndIf
	If $upleft Then
		$d = $x + 1
		$badmove = 1
		For $c = $y + 1 To $Size / 50
			If $Owners[$d][$c] = $Player Then
				$ey = $c
				$ex = $d
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
			$d += 1
			If $d > $Size / 50 Then ExitLoop
		Next
		$d = $x + 1
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y + 1 To $ey
				Circle($d, $c, $Player)
				$d += 1
				If $d > $ex Then ExitLoop
			Next
		EndIf
	EndIf
	If $downright Then
		$d = $x - 1
		$badmove = 1
		For $c = $y - 1 To 0 Step - 1
			If $Owners[$d][$c] = $Player Then
				$ey = $c
				$ex = $d
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
			$d -= 1
			If $d < 0 Then ExitLoop
		Next
		$d = $x - 1
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y - 1 To $ey Step - 1
				Circle($d, $c, $Player)
				$d -= 1
				If $d < $ex Then ExitLoop
			Next
		EndIf
	EndIf
	If $downleft Then
		$d = $x + 1
		$badmove = 1
		For $c = $y - 1 To 0 Step - 1
			If $Owners[$d][$c] = $Player Then
				$ey = $c
				$ex = $d
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
			$d += 1
			If $d > $Size / 50 Then ExitLoop
		Next
		$d = $x + 1
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y - 1 To $ey Step - 1
				Circle($d, $c, $Player)
				$d += 1
				If $d > $ex Then ExitLoop
			Next
		EndIf
	EndIf
	If $upright Then
		$d = $x - 1
		$badmove = 1
		For $c = $y + 1 To $Size / 50
			If $Owners[$d][$c] = $Player Then
				$ey = $c
				$ex = $d
				$badmove = 0
				$success = 1
				ExitLoop
			EndIf
			$d -= 1
			If $d < 0 Then ExitLoop
		Next
		$d = $x - 1
		If Not $badmove Then
			Circle($x, $y, $Player)
			For $c = $y + 1 To $ey
				Circle($d, $c, $Player)
				$d -= 1
				If $d < $ex Then ExitLoop
			Next
		EndIf
	EndIf
	If $success = 1 Then Return 1
	If $badmove = 1 Then Return 0
EndFunc
	
Func BackgroundFunctions ( )
	If $Owners[$e][$f] = 0 Then $P2 += 1
	If $Owners[$e][$f] = 1 Then $P1 += 1
	If $Owners[$e][$f] = 3 Then $P3 += 1
	$e += 1
	If $e > $Size/50 Then
		$e = 1
		$f += 1
	EndIf
	If $f > $Size/50 Then
		$f = 1
		GUICtrlSetData ( $P1S, "Player 1: " & $P1 )
		GUICtrlSetData ( $P2S, "Player 2: " & $P2 )
		If $P2 = 0 Then Win ( 1 )
		If $P1 = 0 Then Win ( 2 )
		If $P3 = 0 Then
			If $P1 > $P2 Then Win ( 1 )
			If $P2 > $P1 Then Win ( 2 )
		EndIf
		$P1 = 0
		$P2 = 0
	EndIf
EndFunc

Func Player ( $P )
	If $P = 1 Then
		GUICtrlSetColor ( $CPlayer, 0xff0000 )
		GUICtrlSetData ( $CPlayer, "Player 1" )
	ElseIf $P = 2 Then
		GUICtrlSetColor ( $CPlayer, 0x0000ff )
		GUICtrlSetData ( $CPlayer, "Player 2" )
	EndIf
EndFunc

Func Win ( $P )
	If $Pause = 0 Then MsgBox ( 0, "Reversi", "Player " & $P & " wins!" )
	$Pause = 1
EndFunc