; Play Party Poker

; Pre-initialization: set name of table
Global Const $TABLE_NAME = 'Play money'

; Initialize buttons
Local Const $FOLD_BUTTON = 'Afxwnd42s20'
Local Const $CALL_BUTTON = 'Afxwnd42s22'
Local Const $CHECK_BUTTON = 'Afxwnd42s22'
Local Const $BET_BUTTON = 'Afxwnd42s24'
Local Const $RAISE_BUTTON = 'Afxwnd42s24'

; Set coordinate mode to relative to window
Opt('PixelCoordMode', 0)

; Wait for the window of table to exist
WinWait($TABLE_NAME)

; Main loop
While WinExists($TABLE_NAME)

	Sleep(300)

	If ControlCommand($TABLE_NAME, '', $FOLD_BUTTON, 'IsVisible') Then
		Sleep(Random(1500, 2500))
		Local $Action = GetAction()
		If $Action = 1 Then
			; Fold/Check
			; If we can check for free, then do that instead of folding
			If StringInStr(ControlGetText($TABLE_NAME, '', $CHECK_BUTTON), 'Check') Then
				ControlClick($TABLE_NAME, '', $CHECK_BUTTON);
			Else
				ControlClick($TABLE_NAME, '', $FOLD_BUTTON);
			EndIf
		ElseIf $Action = 2 Then
			; Check/Call
			; Sleep(Random(0, 2000))
			ControlClick($TABLE_NAME, '', $CALL_BUTTON)
		ElseIf $Action = 3 Then
			; Call/Bet
			; If we can call then call otherwise bet
			If StringInStr(ControlGetText($TABLE_NAME, '', $CALL_BUTTON), 'Call') Then
				ControlClick($TABLE_NAME, '', $CALL_BUTTON)
			Else
				ControlClick($TABLE_NAME, '', $BET_BUTTON)
			EndIf
		ElseIf $Action = 4 Then
			; Bet/Raise
			; Sleep(Random(0, 2000));
			ControlClick($TABLE_NAME, '', $RAISE_BUTTON);
		EndIf
	EndIf
WEnd

; Poker Inspector Actions
Func GetAction()

	Local $Ret = 1
	WinActivate('Connected to ' & $TABLE_NAME)

	; Red/fold
	If PixelGetColor(338, 63) = 0x0000FF Then $Ret = 1
	; Yellow
	If PixelGetColor(338, 72) = 0x00FFFF Then $Ret = 2
	; Blue
	If PixelGetColor(338, 85) = 0xFFFE9C Then $Ret = 3
	; Green
	If PixelGetColor(338, 96) = 0x00FF00 Then $Ret = 4

	WinActivate($TABLE_NAME)
	Return $Ret

EndFunc ; ==> GetAction

; Checks how many empty
Func OccupiedSeats()
	Local $Count = 0
	Local $SeatOpenColor = 0x318AAD
	; Seat 1
	If PixelGetColor(517, 96) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 2
	If PixelGetColor(665, 133) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 3
	If PixelGetColor(735, 251) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 4
	If PixelGetColor(660, 378) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 5
	If PixelGetColor(493, 413) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 6
	If PixelGetColor(262, 413) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 7
	If PixelGetColor(108, 378) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 8
	If PixelGetColor(53, 247) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 9
	If PixelGetColor(126, 133) = $SeatOpenColor Then $Count = $Count + 1
	; Seat 10
	If PixelGetColor(264, 96) = $SeatOpenColor Then $Count = $Count + 1
	Return $Count
EndFunc ; ==> OccupiedSeats