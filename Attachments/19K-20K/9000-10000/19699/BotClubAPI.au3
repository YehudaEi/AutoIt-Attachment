;BotClub API
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;Global Section
;Set by the State Processor
Global $AgressorPOS[4]				;Position off the button clockwise, button is 0 	(Preflop Only)
Global $AgressorSeat[4]				;Seat number of the last raisor preflop (1-10)		(Preflop Only)
Global $ActiveSeats[11]				;Array entry contains a "1" when a player is still in the hand (1-10)
Global $HandRank[4]					;Preflop Hand Rank as referenced by the Hand Rank Table
Global $tRaiseCycle[4]				;Number of times you raised preflop in the last 6 hands @ particular table
Global $winCycle[4]					;Number of times you won in the last 6 hands @ particular table
Global $curTablePFR[4]				;Current table specific PFR%
Global $curTableVPIP[4]				;Current table specific VPIP%
Global $MyPosition[4]				;Preflop deal position is kept here
Global $NumPlayers[4]				;Number of players still in the hand including yourself
Global $RaisorName[4]				;If there is a raise preflop, the name of the last raisor is recorded (Preflop Only)
Global $LastAction[4]				;You last action is stored here
Global $nBetsPreflop[4]				;biggest preflop bet divided by the BB  ;stored until next hand
Global $nBetsFlop[4]				;biggest flop bet divided by the BB     ;stored until next hand
Global $nBetsTurn[4]				;biggest turn bet divided by the BB     ;stored until next hand
Global $nBetsRiver[4]				;biggest river bet divided by the BB 	;stored until next hand
Global $Winrate[4]					;As provided by PokerStove
Global $Equity[4]					;As provided by PokerStove
Global $Lossrate[4]					;100-Winrate-(Tierate*2)
Global $PlayerIDs[4][11]			;State processor retrieved them from the DB, and covers seats (1-10)
;Defined by user
Global $SlowPlayedPreflop[4]		;YES or NO variable
Global $SlowPlayedFlop[4]			;YES or NO variable
Global $SlowPlayedTurn[4]			;YES or NO variable
Global $OpponentRanges[4][11]		;Is populated by the user defined _GetRanges function
Global $BuyIn						;GUI defined value for the profit and loss feature
Global $CalcDelay					;Time allocated to the MonteCarlo simulation in milliseconds
Global $BB, $SB						;GUI defined value
Global $targetPFR					;GUI defined value
Global $deviationPFR				;ini defined value
Global $targetVPIP					;GUI defined value
Global $deviationVPIP				;ini defined value

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;Local Section - These values are set by the State Processor
Local $tn 				;Refers to the table number (0-4)
Local $Opponents		;Number of Opponents
Local $MySeat			;(1-10)
Local $Position  		;ClockWise off the button, button is Zero
Local $HoleCards		;Hole cards	
Local $BoardCards		;Board cards	
Local $IsFirstIn		;YES or NO variable
Local $nBets			;Biggests bet so far divided by the BB
Local $Pot				;Size of current pot
Local $Cost				;What it takes to call
Local $ButtonPosition	;(1-10)
Local $CheckBtn			;0 for NO, 1 for YES
Local $hand				;Hand Value as referenced by the Hand Value Table
Local $IsAPair			;YES or NO variable
Local $BustHand			;YES or NO variable; All hands with Hand Value greater than 6185
Local $nSuitedBoard		;Number of suited cards on the board if number >= 3, else it is 0
Local $Suited			;YES or NO variable refering to your Hole Cards
Local $OpenEnded		;YES or NO variable
Local $Flushing			;YES or NUT or NO variable


#region-Function_Reference
;Misc Section
Func _GetNSuited($BoardCards)
	;Returns number of suited cards if above 3, else returns 0
EndFunc

Func _WinrateVsSteal($tn, $HoleCards, $OppRange, $OppRange2="")
	;Returns winrate % vs. a steal attempt
	;You can call this function from the SB or the BB
EndFunc

Func _7CardCalculator($HoleCards, $BoardCards)
	;Called on river
	;Returns value according to Hand Value Table
EndFunc

Func _6CardCalculator($HoleCards, $BoardCards)
	;Called on the turn
	;Returns value according to Hand Value Table
EndFunc

Func _5CardCalculator($hand)
	;called on the flop, or to evaluate board only on river
	;Returns value according to Hand Value Table
EndFunc

Func _IsAPair($HoleCards, $BoardCards)
	;Return YES or NO
EndFunc

Func _ReduceEquity($tn, $amount)
	;Reduces the Global Equity variable by a desired amount
	$Equity[$tn] -= $amount
EndFunc

Func _ReduceWinrate($tn, $amount)
	;Reduces the Global Equity variable by a desired amount
	$Winrate[$tn] -= $amount
EndFunc

Func _SlowPlayedFlop($tn)
	;Sets a "YES" flag on the $SlowPlayedFlop variable
	;The flag is reset automatically by the state processor at the start of a new hand
	$SlowPlayedFlop[$tn] = "YES"
EndFunc

Func _SlowPlayedPreFlop($tn)
	;Sets a "YES" flag on the $SlowPlayedPreflop variable
	;The flag is reset automatically by the state processor at the start of a new hand
	$SlowPlayedPreflop[$tn] = "YES"
EndFunc

Func _SlowPlayedTurn($tn)
	;Sets a "YES" flag on the $SlowPlayedTurn variable
	;The flag is reset automatically by the state processor at the start of a new hand
	$SlowPlayedTurn[$tn] = "YES"
EndFunc
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;

;Scraper Section
Func _GetStackScrape($Seat, $tn)
	;Retrieves stack amount for a specified seat
EndFunc


Func _GetOpponentSeat($tn) 
	;Returns opponent seat, should be called only when 1 opponent left
EndFunc

Func _IsFirstIn($tn, $Seat, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $ChkBtn)
	;Returns YES or NO
EndFunc


Func _GetPosition($tn, $Seat, $ButtonPosition, $NumberOfPlayers)
	;This is used to determine preflop position of a seat
	;Goes clockwise of the button, button is returned as 0
EndFunc

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
;Tracker Section
Func _GetAgressorSeatPA($tn, $PlayerName)
	;Returns the Seat # of the agressor
EndFunc


Func _GetPlayerIcon($tn, $Seat)
	;Returns player icon number
EndFunc


Func _curTableVPIP($tn, $Seat, $tName)
	;Return VPIP for tablename
EndFunc


Func _GetAttemptedSteal($tn, $Seat) 
	;Retuns Att. To Steal Blinds %
EndFunc


Func _PFR($tn, $Seat, $Default=15) 
	;Returns opponents PFR
EndFunc

Func _PositionalPFR($tn, $Seat, $Position, $Default=10)
	;Returns opponents PFR
EndFunc

Func _VPIP($tn, $Seat, $Default=30)
	;Returns opponents VPIP
EndFunc


Func _PositionalVPIP($tn, $Seat, $Position, $Default=20) 
	;Returns opponents Positional VPIP
EndFunc


Func _FlopAF($tn, $Seat, $Default=2)  
	;Returns the Flop AF for particular seat
EndFunc


Func _TurnAF($tn, $Seat, $Default=2) 
	;Returns the Turn AF for particular seat
EndFunc


Func _RiverAF($tn, $Seat, $Default=1.8) 
	;Returns the River AF for particular seat
EndFunc


Func _FlopCBet($tn, $Seat, $Default=90)
	;Returns opponents Flop Cbet %
EndFunc


Func _TurnCBet($tn, $Seat, $Default=75)
	;Returns opponents Turn Cbet %
EndFunc


Func _GetShowdownStrengthTurn($tn, $Seat, $nBets, $BB)
	;Supports Limit Holdem only
	;Returns the average showdown strength as per trackers hand ranking scheme based on above parameters on the Turn
EndFunc


Func _GetShowdownStrengthRiver($tn, $Seat, $nBets, $BB)
	;Supports Limit Holdem only
	;Returns the average showdown strength as per trackers hand ranking scheme based on above parameters on the River
EndFunc
#endregion