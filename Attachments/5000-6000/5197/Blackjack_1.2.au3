;Stand auto loose fix
;House cant win fix
;Cannot bet nothing must be a value
;If Blackjack then MsgBox "yay"
;extended win loose labels
;help and rules menu
#include <Guiconstants.au3>
FileInstall("sep1.bmp", @TempDir & "\sep1.bmp")
Dim $title = "BlackJack", $gamestart = 0, $new = 0, $botmovea = 0, $bank = @TempDir & "\Bank.ini", $deck = @TempDir & "\Deck.ini"
$gui = GUICreate($title, 380, 350, (@DesktopWidth - 380) / 2, (@DesktopHeight - 265) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
$filemenu = GUICtrlCreateMenu( "File")
$newbank = GUICtrlCreateMenuItem("New Bank", $filemenu, 0)
$newgame = GUICtrlCreateMenuItem("New Game", $filemenu, 1)
$checkbank = GUICtrlCreateMenuItem("Check Bank", $filemenu, 2)
$exit = GUICtrlCreateMenuItem("Exit", $filemenu, 4)
$optmenu = GUICtrlCreateMenu( "Options")
$helpmenu = GUICtrlCreateMenu( "Help")
$deletebank = GUICtrlCreateMenuItem("Delete Bank", $optmenu, 0)
$deletedeck = GUICtrlCreateMenuItem("Delete Decks", $optmenu, 1)
$playername = GUICtrlCreateLabel("Player", 10, 10, 60, 20, $ss_sunken + $SS_CENTER)
$housename = GUICtrlCreateLabel("House", 220, 10, 60, 20, $ss_sunken + $SS_CENTER)
$playertotal = GUICtrlCreateLabel("Card Total", 75, 10, 85, 20, $ss_sunken + $SS_CENTER)
$housetotal = GUICtrlCreateLabel("Card Total", 285, 10, 85, 20, $ss_sunken + $SS_CENTER)
$playerinfo = GUICtrlCreateLabel("", 10, 40, 150, 45, $ss_sunken + $SS_CENTER)
$playerbank = GUICtrlCreateLabel("Bank Amount", 10, 90, 150, 20, $ss_sunken + $SS_CENTER)
$houseinfo = GUICtrlCreateLabel("", 220, 40, 150, 70, $ss_sunken + $SS_CENTER)
$sep1 = GUICtrlCreatePic(@TempDir & "\sep1.bmp", 172.5, 10, 35, 100)
$history = GUICtrlCreateLabel("History", 10, 180, 360, 140, $ss_sunken)
$newgame2 = GUICtrlCreateButton("New Game", 10, 120, 70, 50)
$bet = GUICtrlCreateButton("Bet", 90, 120, 60, 20)
$split = GUICtrlCreateButton("Split", 170, 120, 60, 20)
$doubledown = GUICtrlCreateButton("D. D.", 250, 120, 60, 20)
$hit = GUICtrlCreateButton("Hit", 90, 150, 60, 20)
$stand = GUICtrlCreateButton("Stand", 170, 150, 60, 20)
$fold = GUICtrlCreateButton("Fold", 250, 150, 60, 20)
$start = GUICtrlCreateButton("Start", 320, 120, 50, 50)
GUICtrlSetState($doubledown, $GUI_DISABLE)
GUICtrlSetState($split, $GUI_DISABLE)
GUICtrlSetState($bet, $GUI_DISABLE)
GUICtrlSetState($start, $GUI_DISABLE)
GUICtrlSetState($hit, $GUI_DISABLE)
GUICtrlSetState($fold, $GUI_DISABLE)
GUICtrlSetState($bet, $GUI_DISABLE)
GUICtrlSetState($stand, $GUI_DISABLE)
GUISetState()
While 1
	$msg = GUIGetMsg()
	If $msg = $GUI_EVENT_CLOSE Or $msg = $exit Then
		ExitLoop
	ElseIf $msg = $newbank Then
		$cbwin = GUICreate("Create Bank", 160, 160, (@DesktopWidth - 160) / 2, (@DesktopHeight - 160) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS, 0, $gui)
		$refnum = GUICtrlCreateInput("", 10, 40, 140, 20)
		$name = GUICtrlCreateInput("", 10, 100, 140, 20)
		$ok = GUICtrlCreateButton("OK", 10, 130, 65, 20)
		$cancel = GUICtrlCreateButton("Cancel", 85, 130, 65, 20)
		$label1 = GUICtrlCreateLabel("Reference Password", 10, 10, 140, 20, $ss_sunken + $SS_CENTER, $SS_CENTER)
		$label2 = GUICtrlCreateLabel("Name", 45, 70, 70, 20, $ss_sunken + $SS_CENTER, $SS_CENTER)
		GUISetState()
		While 1
			$msg = GUIGetMsg()
			If $msg = $GUI_EVENT_CLOSE Or $msg = $cancel Then
				GUIDelete($cbwin)
				ExitLoop
				WinActivate($title)
			ElseIf $msg = $ok Then
				$refnum2 = GUICtrlRead($refnum)
				$name2 = GUICtrlRead($name)
				If $refnum2 = "" Or $name2 = "" Then
					MsgBox(48, "Error!", "Please complete all of the fields!")
				Else
					BankCreate($refnum2, $name2, 1000)
					GUIDelete($cbwin)
					ExitLoop
					WinActivate($title)
				EndIf
			EndIf
		WEnd
	ElseIf $msg = $newgame Or $new = 1 Then
		$new = 0
		$refnum = InputBox( "Reference setup..", "Please input your reference password to deal with the bank....", "", "*")
		If @error = 1 Then
			; Do Nothing
		Else
			If $refnum = "" Then
				MsgBox(48, "Error", "No reference number set. Please either input your reference or create a bank to get one.")
			ElseIf $refnum <> "" Then
				$info = BankCheck($refnum)
				If $info[0] = -1 Then
					MsgBox(48, "Error", "Invalid reference number! Please create a bank account first!")
				Else
					$gamestart = 1
				EndIf
			EndIf
		EndIf
	ElseIf $msg = $checkbank Then
		$refnum = InputBox("Check bank..", "What is the reference password of the bank to be checked?", "", "*")
		If @error = 1 Then
			; Do Nothing
		Else
			$bankcheck = BankCheck($refnum)
			If $bankcheck[0] = -1 Then
				MsgBox(48, "Error!", "No such bank!")
			ElseIf $bankcheck[0] >= 0 Or $bankcheck[0] <= -2 And $bankcheck[0] <> - 1 Then
				MsgBox(0, "Bank Checked", "The name on this bank is " & $bankcheck[1] & " and the amount left in this bank is " & $bankcheck[0] & ". The reference password was " & $bankcheck[2] & ".")
			EndIf
		EndIf
	ElseIf $msg = $deletebank Then
		$refnum = InputBox("Delete bank..", "What is the reference password of the bank to be deleted?", "", "*")
		If @error = 1 Then
			; Do Nothing
		Else
			$bankcheck = BankCheck($refnum)
			If $bankcheck[0] = -1 Then
				MsgBox(48, "Error!", "No such bank!")
			ElseIf $bankcheck[0] >= 0 Then
				$bankcheck2 = MsgBox(3, "Confirmation..", "The name on this bank is " & $bankcheck[1] & " and the amount left in this bank is " & $bankcheck[0] & ". Is this information is correct and would you like to delete?")
				If $bankcheck2 = 6 Then
					BankDelete($bankcheck[2])
					$bankcheck = BankCheck($refnum)
					If $bankcheck[0] = -1 Then
						MsgBox(0, "Finished!", "This bank was deleted!")
					EndIf
				ElseIf $bankcheck2 = 7 Or $bankcheck2 = 2 Then
					; Do Nothing
				EndIf
			EndIf
		EndIf
	ElseIf $msg = $deletedeck Then
		$deckdelete = MsgBox(4, "Delete Decks...", "Do you wish to delete all the decks?")
		If $deckdelete = 7 Then
			; Do Nothing
		ElseIf $deckdelete = 6 Then
			DeckDelete()
			MsgBox(0, "Finished!", "Decks deleted!")
		EndIf
	ElseIf $msg = $newgame2 Then
		$new = 1
	ElseIf $gamestart = 1 Then
		GUICtrlSetData($history, "")
		GUICtrlSetData($history, "Loading bank...." & @LF)
		$info = BankCheck($info[2])
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Bank loaded!" & @LF)
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Creating deck...." & @LF)
		DeckCreate($info[2])
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Deck created!" & @LF)
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Loading label info....." & @LF)
		GUICtrlSetData($playerbank, "")
		GUICtrlSetData($playerbank, $info[0] & " credits")
		GUICtrlSetData($playername, "")
		GUICtrlSetData($playername, $info[1])
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Loaded!" & @LF)
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & "Waiting for start!" & @LF)
		GUICtrlSetState($start, $GUI_ENABLE)
		$gamestart = 2
	ElseIf $gamestart = 2 And $msg = $start Then
		GUICtrlSetState($start, $GUI_DISABLE)
		GUICtrlSetState($bet, $GUI_ENABLE)
	ElseIf $gamestart = 2 And $msg = $bet Then
		$betamount = InputBox( "Bet", "How much would you like to bet?")
		If @error = 1 Then
			; Do Nothing
		Else
			$total1a = 0
			$total1b = 0
			$total2a = 0
			$total2b = 0
			GUICtrlSetData($playertotal, "")
			GUICtrlSetData($housetotal, "")
			GUICtrlSetData($history, $info[1] & " bets " & $betamount & @LF)
			GUICtrlSetData($history, "")
			GUICtrlSetData($history, $info[1] & " bets " & $betamount & @LF)
			$carda = CardDraw($info[2])
			If $carda = 0 Then
				SplashTextOn("", "Rebuilding deck....... (ran out of cards)", "300", "20", "-1", "-1", 1, "", "", "")
				DeckCreate($info[2])
				$carda = CardDraw($info[2])
				SplashOff()
			EndIf
			$total1a = CardNum($carda)
			$total1a = CardAce($total1a, $gui, 0)
			$carda = CardInterpret($carda)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " draws a " & $carda & @LF)
			GUICtrlSetData($playerinfo, "")
			GUICtrlSetData($playerinfo, $carda)
			$cardb = CardDraw($info[2])
			If $cardb = 0 Then
				SplashTextOn("", "Rebuilding deck....... (ran out of cards)", "300", "20", "-1", "-1", 1, "", "", "")
				DeckCreate($info[2])
				$cardb = CardDraw($info[2])
				SplashOff()
			EndIf
			$total1b = CardNum($cardb)
			$total1b = CardAce($total1b, $gui, 1)
			$cardb = CardInterpret($cardb)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House draws a " & $cardb & @LF)
			GUICtrlSetData($houseinfo, "")
			GUICtrlSetData($houseinfo, $cardb)
			$history2 = GUICtrlRead($history)
			$carda = CardDraw($info[2])
			If $carda = 0 Then
				SplashTextOn("", "Rebuilding deck....... (ran out of cards)", "300", "20", "-1", "-1", 1, "", "", "")
				DeckCreate($info[2])
				$carda = CardDraw($info[2])
				SplashOff()
			EndIf
			$total2a = CardNum($carda)
			$total2a = CardAce($total2a, $gui, 0)
			$carda = CardInterpret($carda)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " draws a " & $carda & @LF)
			$history2 = GUICtrlRead($playerinfo)
			GUICtrlSetData($playerinfo, $history2 & @LF & $carda)
			$cardb = CardDraw($info[2])
			If $cardb = 0 Then
				SplashTextOn("", "Rebuilding deck....... (ran out of cards)", "300", "20", "-1", "-1", 1, "", "", "")
				DeckCreate($info[2])
				$cardb = CardDraw($info[2])
				SplashOff()
			EndIf
			$total2b = CardNum($cardb)
			$total2b = CardAce($total2b, $gui, 1)
			$cardb = CardInterpret($cardb)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House draws a " & $cardb & @LF)
			$history2 = GUICtrlRead($houseinfo)
			GUICtrlSetData($houseinfo, $history2 & @LF & $cardb)
			$total1 = $total1a + $total2a
			$total2 = $total1b + $total2b
			GUICtrlSetData($playertotal, "Card total = " & $total1)
			GUICtrlSetData($housetotal, "Card total = " & $total2)
			GUICtrlSetState($hit, $GUI_ENABLE)
			GUICtrlSetState($fold, $GUI_ENABLE)
			GUICtrlSetState($stand, $GUI_ENABLE)
			GUICtrlSetState($bet, $GUI_DISABLE)
			If $total1 > 21 Then
				$history2 = GUICtrlRead($history)
				GUICtrlSetData($history, $history2 & $info[1] & " busts!" & @LF)
				$history2 = GUICtrlRead($history)
				GUICtrlSetData($history, $history2 & $info[1] & " loses $" & $betamount & @LF)
				BankSub($info[2], $betamount)
				GUICtrlSetData($playerinfo, "")
				GUICtrlSetData($playerinfo, "Busts!" & @LF & "Loses!")
				GUICtrlSetState($hit, $GUI_DISABLE)
				GUICtrlSetState($fold, $GUI_DISABLE)
				GUICtrlSetState($stand, $GUI_DISABLE)
				GUICtrlSetState($bet, $GUI_ENABLE)
				$info = BankCheck($info[2])
				GUICtrlSetData($playerbank, "")
				GUICtrlSetData($playerbank, $info[0] & " credits")
				GUICtrlSetData($houseinfo, "")
				GUICtrlSetData($houseinfo, "House Wins!")
				GUICtrlSetState($hit, $GUI_DISABLE)
				GUICtrlSetState($fold, $GUI_DISABLE)
				GUICtrlSetState($stand, $GUI_DISABLE)
			ElseIf $total2 > 21 Then
				$history2 = GUICtrlRead($history)
				GUICtrlSetData($history, $history2 & $info[1] & " wins! $" & $betamount & @LF)
				BankAdd($info[2], $betamount)
				GUICtrlSetData($playerinfo, "")
				GUICtrlSetData($playerinfo, "Wins !")
				GUICtrlSetState($hit, $GUI_DISABLE)
				GUICtrlSetState($fold, $GUI_DISABLE)
				GUICtrlSetState($stand, $GUI_DISABLE)
				GUICtrlSetState($bet, $GUI_ENABLE)
				$info = BankCheck($info[2])
				GUICtrlSetData($playerbank, "")
				GUICtrlSetData($playerbank, $info[0] & " credits")
				GUICtrlSetData($houseinfo, "")
				GUICtrlSetData($houseinfo, "House busts!" & @LF)
				$history2 = GUICtrlRead($houseinfo)
				GUICtrlSetData($houseinfo, $houseinfo & "Loses!")
				GUICtrlSetState($hit, $GUI_DISABLE)
				GUICtrlSetState($fold, $GUI_DISABLE)
				GUICtrlSetState($stand, $GUI_DISABLE)
			Else
				If TwentyOneTest($total1) = 1 Then
					If TwentyOneTest($total1) = 1 And TwentyOneTest($total2) <> 1 Then
						MsgBox(0, "BLACKJACK!", "BLACKJACK YOU WIN!!!")
						$history2 = GUICtrlRead($history)
						GUICtrlSetData($history, $history2 & $info[1] & " wins! $" & $betamount & @LF)
						BankAdd($info[2], $betamount)
						GUICtrlSetData($playerinfo, "")
						GUICtrlSetData($playerinfo, "Wins !")
						GUICtrlSetState($hit, $GUI_DISABLE)
						GUICtrlSetState($fold, $GUI_DISABLE)
						GUICtrlSetState($stand, $GUI_DISABLE)
						GUICtrlSetState($bet, $GUI_ENABLE)
						$info = BankCheck($info[2])
						GUICtrlSetData($playerbank, "")
						GUICtrlSetData($playerbank, $info[0] & " credits")
						GUICtrlSetData($houseinfo, "")
						GUICtrlSetData($houseinfo, "House loses!")
						GUICtrlSetState($hit, $GUI_DISABLE)
						GUICtrlSetState($fold, $GUI_DISABLE)
						GUICtrlSetState($stand, $GUI_DISABLE)
					EndIf
				Else
					GUICtrlSetState($hit, $GUI_ENABLE)
					GUICtrlSetState($fold, $GUI_ENABLE)
					GUICtrlSetState($stand, $GUI_ENABLE)
				EndIf
				If TwentyOneTest($total2) = 1 Then
					If TwentyOneTest($total2) = 1 Then
						MsgBox(0, "BLACKJACK!", "Blackjack, you loose.")
						$history2 = GUICtrlRead($history)
						GUICtrlSetData($history, $history2 & $info[1] & " loses $" & $betamount & @LF)
						BankSub($info[2], $betamount)
						GUICtrlSetData($playerinfo, "")
						GUICtrlSetData($playerinfo, "Loses !")
						GUICtrlSetState($hit, $GUI_DISABLE)
						GUICtrlSetState($fold, $GUI_DISABLE)
						GUICtrlSetState($stand, $GUI_DISABLE)
						GUICtrlSetState($bet, $GUI_ENABLE)
						$info = BankCheck($info[2])
						GUICtrlSetData($playerbank, "")
						GUICtrlSetData($playerbank, $info[0] & " credits")
						GUICtrlSetData($houseinfo, "")
						GUICtrlSetData($houseinfo, "House Wins!")
						GUICtrlSetState($hit, $GUI_DISABLE)
						GUICtrlSetState($fold, $GUI_DISABLE)
						GUICtrlSetState($stand, $GUI_DISABLE)
					Else
						GUICtrlSetState($hit, $GUI_ENABLE)
						GUICtrlSetState($fold, $GUI_ENABLE)
						GUICtrlSetState($stand, $GUI_ENABLE)
					EndIf
				EndIf
			EndIf
		EndIf
	ElseIf $gamestart = 2 And $msg = $hit Then
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & $info[1] & " hits." & @LF)
		$carda = CardDraw($info[2])
		If $carda = 0 Then
			SplashTextOn("", "Rebuilding deck....... (ran out of cards)", "300", "20", "-1", "-1", 1, "", "", "")
			DeckCreate($info[2])
			$carda = CardDraw($info[2])
			SplashOff()
		EndIf
		$total2a = CardNum($carda)
		$total2a = CardAce($total2a, $gui, 0)
		$carda = CardInterpret($carda)
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & $info[1] & " draws a " & $carda & @LF)
		$history2 = GUICtrlRead($playerinfo)
		GUICtrlSetData($playerinfo, $history2 & @LF & $carda)
		$total1 = $total1 + $total2a
		GUICtrlSetData($playertotal, "Card Total = " & $total1)
		If $total1 > 21 Then
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " loses! $" & $betamount & @LF)
			BankSub($info[2], $betamount)
			GUICtrlSetData($playerinfo, "")
			GUICtrlSetData($playerinfo, "Busts!" & @LF & "Loses ")
			GUICtrlSetState($hit, $GUI_DISABLE)
			GUICtrlSetState($fold, $GUI_DISABLE)
			GUICtrlSetState($stand, $GUI_DISABLE)
			GUICtrlSetState($bet, $GUI_ENABLE)
			$info = BankCheck($info[2])
			GUICtrlSetData($playerbank, "")
			GUICtrlSetData($playerbank, $info[0] & " credits")
			GUICtrlSetData($houseinfo, "Wins!" & @LF)
			$history2 = GUICtrlRead($houseinfo)
			GUICtrlSetData($houseinfo, $history2 & "House Wins!")
			$playerstand = 0
			$botstand = 0
			$check = 0
		Else
			$playerstand = 0
			$botmovea = 1
		EndIf
	ElseIf $gamestart = 2 And $msg = $stand Then
		$playerstand = 1
		$botmovea = 1
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & $info[1] & " stands." & @LF)
		$history2 = GUICtrlRead($playerinfo)
		GUICtrlSetData($playerinfo, "Stands")
		GUICtrlSetState($hit, $GUI_DISABLE)
		GUICtrlSetState($fold, $GUI_DISABLE)
		GUICtrlSetState($stand, $GUI_DISABLE)
	ElseIf $gamestart = 2 And $msg = $fold Then
		GUICtrlSetData($playerinfo, "Folds")
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & $info[1] & " folds!" & @LF)
		$history2 = GUICtrlRead($history)
		GUICtrlSetData($history, $history2 & $info[1] & " loses! $" & $betamount & @LF)
		BankSub($info[2], $betamount)
		GUICtrlSetData($playerinfo, "")
		GUICtrlSetData($playerinfo, "Loses !")
		GUICtrlSetState($hit, $GUI_DISABLE)
		GUICtrlSetState($fold, $GUI_DISABLE)
		GUICtrlSetState($stand, $GUI_DISABLE)
		GUICtrlSetState($bet, $GUI_ENABLE)
		$info = BankCheck($info[2])
		GUICtrlSetData($playerbank, "")
		GUICtrlSetData($playerbank, $info[0] & " credits")
		GUICtrlSetData($houseinfo, "")
		GUICtrlSetData($houseinfo, "House wins!")
	ElseIf $gamestart = 2 And $botmovea = 1 Then
		$botmove = BotMove($total2)
		If $botmove = 0 Then
			GUICtrlSetData($houseinfo, "Stands")
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House stands." & @LF)
			$botstand = 1
			$check = 1
		ElseIf $botmove = 1 Then
			$cardb = CardDraw($info[2])
			$total2b = CardNum($cardb)
			$total2b = CardAce($total2b, $gui, 1)
			$cardb = CardInterpret($cardb)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House hits." & @LF)
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House draws a " & $cardb & @LF)
			$history2 = GUICtrlRead($houseinfo)
			GUICtrlSetData($houseinfo, $history2 & @LF & $cardb)
			$total2 = $total2 + $total2b
			GUICtrlSetData($housetotal, "Card Total = " & $total2)
			$check = 1
			$botstand = 0
		ElseIf $botmove = -1 Then
			GUICtrlSetData($houseinfo, "Folds")
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & "House folds!" & @LF)
			$betamount = $betamount
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " wins! $" & $betamount & @LF)
			BankAdd($info[2], $betamount)
			GUICtrlSetData($playerinfo, "")
			GUICtrlSetData($playerinfo, "Wins !")
			GUICtrlSetState($hit, $GUI_DISABLE)
			GUICtrlSetState($fold, $GUI_DISABLE)
			GUICtrlSetState($stand, $GUI_DISABLE)
			GUICtrlSetState($bet, $GUI_ENABLE)
			$info = BankCheck($info[2])
			GUICtrlSetData($playerbank, "")
			GUICtrlSetData($playerbank, $info[0] & " credits")
			GUICtrlSetData($houseinfo, "")
			GUICtrlSetData($houseinfo, "House loses!")
			$total2 = $total2 + $total2b
		EndIf
		If $total2 > 21 Then
			$total2 = -1
			$botstand = 1
		ElseIf $total2 = 21 Then
			MsgBox(0, "BLACKJACK!", "Blackjack, you loose.")
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " loses $" & $betamount & @LF)
			BankSub($info[2], $betamount)
			GUICtrlSetData($playerinfo, "")
			GUICtrlSetData($playerinfo, "Loses !")
			GUICtrlSetState($hit, $GUI_DISABLE)
			GUICtrlSetState($fold, $GUI_DISABLE)
			GUICtrlSetState($stand, $GUI_DISABLE)
			GUICtrlSetState($bet, $GUI_ENABLE)
			$info = BankCheck($info[2])
			GUICtrlSetData($playerbank, "")
			GUICtrlSetData($playerbank, $info[0] & " credits")
			GUICtrlSetData($houseinfo, "")
			GUICtrlSetData($houseinfo, "House Wins!")
			$botstand = 0
			$check = 0
			$playerstand = 0
		EndIf
		If $total2 = -1 Then
			$history2 = GUICtrlRead($history)
			GUICtrlSetData($history, $history2 & $info[1] & " wins! $" & $betamount & @LF)
			BankAdd($info[2], $betamount)
			GUICtrlSetData($playerinfo, "")
			GUICtrlSetData($playerinfo, "Wins !")
			GUICtrlSetState($hit, $GUI_DISABLE)
			GUICtrlSetState($fold, $GUI_DISABLE)
			GUICtrlSetState($stand, $GUI_DISABLE)
			GUICtrlSetState($bet, $GUI_ENABLE)
			$info = BankCheck($info[2])
			GUICtrlSetData($playerbank, "")
			GUICtrlSetData($playerbank, $info[0] & " credits")
			GUICtrlSetData($houseinfo, "Busts!" & @LF)
			$history2 = GUICtrlRead($houseinfo)
			GUICtrlSetData($houseinfo, $history2 & "House loses!")
			$playerstand = 0
			$botstand = 0
			$check = 0
		ElseIf $total1 < 21 Then
			$check = 1
		EndIf
		If $check = 1 Then
			If $playerstand = 1 And $botstand = 1 Then
				If $total1 > $total2 Then
					$history2 = GUICtrlRead($history)
					GUICtrlSetData($history, $history2 & $info[1] & " wins! $" & $betamount & @LF)
					BankAdd($info[2], $betamount)
					GUICtrlSetData($playerinfo, "")
					GUICtrlSetData($playerinfo, "Wins !")
					GUICtrlSetState($hit, $GUI_DISABLE)
					GUICtrlSetState($fold, $GUI_DISABLE)
					GUICtrlSetState($stand, $GUI_DISABLE)
					GUICtrlSetState($bet, $GUI_ENABLE)
					$info = BankCheck($info[2])
					GUICtrlSetData($playerbank, "")
					GUICtrlSetData($playerbank, $info[0] & " credits")
					GUICtrlSetData($houseinfo, "")
					GUICtrlSetData($houseinfo, "House loses!")
					$playerstand = 0
					$botstand = 0
					$check = 0
				ElseIf $total2 > $total1 Then
					$history2 = GUICtrlRead($history)
					GUICtrlSetData($history, $history2 & $info[1] & " loses $" & $betamount & @LF)
					BankSub($info[2], $betamount)
					GUICtrlSetData($playerinfo, "")
					GUICtrlSetData($playerinfo, "Loses !")
					GUICtrlSetState($hit, $GUI_DISABLE)
					GUICtrlSetState($fold, $GUI_DISABLE)
					GUICtrlSetState($stand, $GUI_DISABLE)
					GUICtrlSetState($bet, $GUI_ENABLE)
					$info = BankCheck($info[2])
					GUICtrlSetData($playerbank, "")
					GUICtrlSetData($playerbank, $info[0] & " credits")
					GUICtrlSetData($houseinfo, "")
					GUICtrlSetData($houseinfo, "House Wins!")
					$playerstand = 0
					$botstand = 0
					$check = 0
				ElseIf $total1 = $total2 Then
					GUICtrlSetState($hit, $GUI_DISABLE)
					GUICtrlSetState($fold, $GUI_DISABLE)
					GUICtrlSetState($stand, $GUI_DISABLE)
					GUICtrlSetState($bet, $GUI_ENABLE)
					$info = BankCheck($info[2])
					GUICtrlSetData($playerbank, "")
					GUICtrlSetData($playerbank, $info[0] & " credits")
					$history2 = GUICtrlRead($history)
					GUICtrlSetData($playerinfo, "Draw!")
					GUICtrlSetData($houseinfo, "Draw!")
					GUICtrlSetData($history, $history2 & "Draw!" & @LF)
					$playerstand = 0
					$botstand = 0
					$check = 0
				EndIf
			EndIf
		EndIf
		If $playerstand = 1 Then
			$botmovea = 1
		Else
			$botmovea = 0
		EndIf
	EndIf
WEnd
Exit
Func DeckCreate($refnum)
	IniWrite($deck, "Deck" & $refnum, "CS", "52")
	$i = 52
	While $i <> 0
		IniWrite($deck, "Deck" & $refnum, $i, "0")
		$i = $i - 1
	WEnd
	While IniRead($deck, "Deck" & $refnum, "CS", -1) <> 0
		$a = Random(1, 13, 1)
		$b = Random(1, 4, 1)
		$card = $a & ":" & $b
		$cardcheck = CardCheck($card, $refnum)
		If $cardcheck = 1 Then
			$spot = IniRead($deck, "Deck" & $refnum, "CS", -1)
			If $spot = -1 Then
				Error(0)
			Else
				IniWrite($deck, "Deck" & $refnum, "CS", ($spot - 1))
				IniWrite($deck, "Deck" & $refnum, $spot, $card)
			EndIf
		ElseIf $cardcheck = 0 Then
			Sleep(1)
		EndIf
	WEnd
	IniWrite($deck, "Deck" & $refnum, "CS", "52")
EndFunc   ;==>DeckCreate
Func DeckDelete()
	FileDelete($deck)
EndFunc   ;==>DeckDelete
Func CardCheck($card, $refnum)
	$i = 52
	While 1
		$check = IniRead($deck, "Deck" & $refnum, $i, -1)
		If $check = -1 Then
			Error(0)
		ElseIf $check = $card Then
			Return 0
			ExitLoop
		ElseIf $check = 0 Then
			Return 1
			ExitLoop
		ElseIf $check <> $card And $check <> 0 And $check <> - 1 Then
			$i = $i - 1
		EndIf
	WEnd
EndFunc   ;==>CardCheck
Func CardDraw($refnum)
	$cardspot = IniRead($deck, "Deck" & $refnum, "CS", -1)
	If $cardspot = -1 Then
		Error(1)
	ElseIf $cardspot = 0 Then
		Return 0
	Else
		IniWrite($deck, "Deck" & $refnum, "CS", ($cardspot - 1))
		$drawcard = IniRead($deck, "Deck" & $refnum, $cardspot, -1)
		IniWrite($deck, "Deck" & $refnum, $cardspot, "0")
		If $drawcard = -1 Then
			Error(1)
		Else
			Return $drawcard
			IniWrite("Deck.ini", "Deck" & $refnum, $cardspot, "0")
		EndIf
	EndIf
EndFunc   ;==>CardDraw
Func CardInterpret($card)
	$card = StringSplit($card, ":")
	$card[1] = StringReplace($card[1], "4", "Four")
	$card[1] = StringReplace($card[1], "5", "Five")
	$card[1] = StringReplace($card[1], "6", "Six")
	$card[1] = StringReplace($card[1], "7", "Seven")
	$card[1] = StringReplace($card[1], "8", "Eight")
	$card[1] = StringReplace($card[1], "9", "Nine")
	$card[1] = StringReplace($card[1], "10", "Ten")
	$card[1] = StringReplace($card[1], "11", "Jack")
	$card[1] = StringReplace($card[1], "12", "Queen")
	$card[1] = StringReplace($card[1], "13", "King")
	$card[1] = StringReplace($card[1], "3", "Three")
	$card[1] = StringReplace($card[1], "2", "Deuce")
	$card[1] = StringReplace($card[1], "1", "Ace")
	$card[2] = StringReplace($card[2], "1", " of Hearts")
	$card[2] = StringReplace($card[2], "2", " of Diamonds")
	$card[2] = StringReplace($card[2], "3", " of Spades")
	$card[2] = StringReplace($card[2], "4", " of Clubs")
	$card = $card[1] & $card[2]
	Return $card
EndFunc   ;==>CardInterpret
Func CardNum($card)
	$card = StringSplit($card, ":")
	If $card[1] = "13" Or $card[1] = "12" Or $card[1] = "11" Or $card[1] = "10" Then
		$newcard = 10
	ElseIf $card[1] = "1" Then
		$newcard = 1
	ElseIf $card[1] = "2" Then
		$newcard = 2
	ElseIf $card[1] = "3" Then
		$newcard = 3
	ElseIf $card[1] = "4" Then
		$newcard = 4
	ElseIf $card[1] = "5" Then
		$newcard = 5
	ElseIf $card[1] = "6" Then
		$newcard = 6
	ElseIf $card[1] = "7" Then
		$newcard = 7
	ElseIf $card[1] = "8" Then
		$newcard = 8
	ElseIf $card[1] = "9" Then
		$newcard = 9
	EndIf
	Return $newcard
EndFunc   ;==>CardNum
Func CardAce($card, $gui, $bot)
	If $bot = 1 Then
		If $card = 1 Then
			$total = Random(1, 2, 1)
			If $total = 1 Then
				$total = 11
			ElseIf $total = 2 Then
				$total = 1
			EndIf
		Else
			$total = $card
		EndIf
		Return $total
	ElseIf $bot = 0 Then
		If $card = 1 Then
			$acewin = GUICreate("Ace", 137, 102, (@DesktopWidth - 137) / 2, (@DesktopHeight - 102) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS, 0, $gui)
			$label = GUICtrlCreateLabel("A ace has been drawn, would you like it to be worth 11 or 1?", 10, 10, 120, 30, $ss_sunken + $SS_CENTER)
			$1 = GUICtrlCreateCheckbox("One", 10, 50, 50, 20)
			$11 = GUICtrlCreateCheckbox("Eleven", 10, 80, 50, 20)
			$ok = GUICtrlCreateButton("Ok", 80, 60, 50, 30)
			GUISetState()
			While 1
				$msg = GUIGetMsg()
				If $msg = $ok Then
					If GUICtrlRead($1) = $GUI_CHECKED And GUICtrlRead($11) <> $GUI_CHECKED Then
						$total = 1
						GUIDelete($acewin)
						GUISetState($gui, @SW_SHOW)
						Return $total
						ExitLoop
					ElseIf GUICtrlRead($11) = $GUI_CHECKED And GUICtrlRead($1) <> $GUI_CHECKED Then
						$total = 11
						GUIDelete($acewin)
						GUISetState($gui, @SW_SHOW)
						Return $total
						ExitLoop
					Else
						MsgBox(0, "Error", "Either both are selected or none, please choose one.")
					EndIf
				EndIf
			WEnd
		Else
			$total = $card
			Return $total
		EndIf
	EndIf
EndFunc   ;==>CardAce
Func TwentyOneTest($total)
	If $total = 21 Then
		Return 1
	Else
		Return $total
	EndIf
EndFunc   ;==>TwentyOneTest
Func BankCreate($refnum, $name, $amount)
	$premade = IniRead($bank, "Bank" & $refnum, "Name", -1)
	If $premade = -1 Then
		IniWrite($bank, "Bank" & $refnum, "Name", $name)
		IniWrite($bank, "Bank" & $refnum, "Amount", $amount)
		MsgBox(0, "Bank Created!", "Your bank has been created, your starting amount is 1000 and your reference password is " & $refnum)
	Else
		$prename = InputBox( "PreExisting!", "This bank reference is already pre-existing. Please input the name to overwrite.")
		If $prename = $premade Then
			IniWrite($bank, "Bank" & $refnum, "Name", $name)
			IniWrite($bank, "Bank" & $refnum, "Amount", $amount)
			MsgBox(0, "Bank Created!", "Your bank has been created, your starting amount is 1000 and your reference password is " & $refnum)
		Else
			MsgBox(0, "Failure!", "That name given was false. Please generate a new reference number to continue.")
		EndIf
	EndIf
EndFunc   ;==>BankCreate
Func BankDelete($refnum)
	$delete = IniDelete($bank, "Bank" & $refnum)
	If $delete = 0 Then
		Error(3)
	EndIf
	$filesize = FileGetSize($bank)
	If $filesize = 0 Then
		FileDelete($bank)
	EndIf
EndFunc   ;==>BankDelete
Func BankAdd($refnum, $amount)
	$a = IniRead($bank, "Bank" & $refnum, "Amount", -1)
	If $a = -1 Then
		Error(3)
	ElseIf $a > 0 Then
		$a = $a + $amount
		IniWrite($bank, "Bank" & $refnum, "Amount", $a)
	ElseIf $a <= -2 Or $a = 0 Then
		$bankcheck = BankCheck($refnum)
		If $bankcheck = 0 Then
			Error(3)
		ElseIf $bankcheck > 0 Then
			Error(0)
		EndIf
	EndIf
EndFunc   ;==>BankAdd
Func BankSub($refnum, $amount)
	$a = IniRead($bank, "Bank" & $refnum, "Amount", -1)
	If $a = -1 Then
		Error(3)
	ElseIf $a > 0 Then
		$a = $a - $amount
		IniWrite($bank, "Bank" & $refnum, "Amount", $a)
		$bankcheck = BankCheck($refnum)
		If $bankcheck = 0 Then
			Error(4)
		EndIf
	ElseIf $a <= -2 Or $a = 0 Then
		$bankcheck = BankCheck($refnum)
		If $bankcheck = 0 Then
			Error(3)
		ElseIf $bankcheck > 0 Then
			Error(0)
		EndIf
	EndIf
EndFunc   ;==>BankSub
Func BankCheck($refnum)
	$a = IniRead($bank, "Bank" & $refnum, "Amount", -1)
	$b = IniRead($bank, "Bank" & $refnum, "Name", -1)
	If $a = -1 Then
		Dim $info[1]
		$info[0] = -1
		Return $info
	ElseIf $a >= 1 Then
		Dim $info[3]
		$info[0] = $a
		$info[1] = $b
		$info[2] = $refnum
		Return $info
	ElseIf $a = 0 Then
		Error(4)
	EndIf
EndFunc   ;==>BankCheck
Func BotMove($cardtotal)
	If $cardtotal >= 16 Then
		Return 0
	ElseIf $cardtotal < 16 Then
		Return 1
	ElseIf Random(1, 5, 1) = Random(1, 5, 1) Then
		Return -1
	EndIf
EndFunc   ;==>BotMove
Func Error($errornum)
	If $errornum = 0 Then
		MsgBox(0, "Error 0", "Internal error, consult source.")
	ElseIf $errornum = 1 Then
		MsgBox(0, "Error 1", "Invalid Deck Reference Number.  Internal Card Error")
	ElseIf $errornum = 2 Then
		MsgBox(0, "Error 2", "Deck Corrupt. Clear deck files and restart.")
	ElseIf $errornum = 3 Then
		MsgBox(0, "Error 3", "No such bankroll.")
	ElseIf $errornum = 4 Then
		MsgBox(0, "Error 4", "Bankroll depleted.")
	EndIf
EndFunc   ;==>Error