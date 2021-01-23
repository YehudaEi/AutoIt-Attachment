#include <BotClubAPI.au3>
#include <File.au3>

;===============================================================================
;
; Function Name:  		_PreflopAction
; Description:     		Makes an action decision preflop
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s):     	($tn, $Opponents, $MySeat, $NumberOfPlayers, $Position, $ButtonPosition, $HoleCards, $IsFirstIn, $nBets, $Pot, $Cost, $hRank, $BB, $CheckBtn, $Suited, $BBSteal="", $SBSteal="")
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause, or a function call
; Return Values FL: 	Check, Call, Fold, Raise, Bet
; Return Values NL:  	Check, Call, Fold, Raise:amount, Bet:amount (Acceptable Amounts => any number, word pot, word half, or word allin)
; Author(s):        	You
;
;===============================================================================
Func _PreFlopAction($tn, $Opponents, $MySeat, $NumberOfPlayers, $Position, $ButtonPosition, $HoleCards, $IsFirstIn, $nBets, $Pot, $Cost, $hRank, $BB, $Table, $CheckBtn, $Suited, $IsStealAttempt, $IsStealTime)
	$random = Random(1, 20, 1)
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;		
		;Button Position
		If $Position = "0" Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop Button position")
		If $Position = "0" And $IsStealTime = "YES" Then Return "Raise"
		If $Position = "0" And $hRank < 100  And $IsFirstIn = "YES" And $random > 6 Then Return "Call"	
		If $Position = "0" And $IsFirstIn = "YES" AND $hRank < 364 And $random > 7 Then Return "Raise"
		If $Position = "0" And $IsFirstIn = "YES" AND $hRank < 364 And $random < 8 Then Return "Call"
		If $Position = "0" And $IsFirstIn = "YES" AND $hRank < 868 And $random > 7 Then Return "Raise"
		If $Position = "0" And $IsFirstIn = "YES" AND $hRank < 868 And $random < 8 Then Return "Call"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;	
		If $Position = "0" And $Opponents = 5 And $nBets <= 3 And $hRank < 432 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "0" And $Opponents = 5 And $nBets <= 3 And $hRank < 432 And $tRaiseCycle[$tn] >= 2 Then Return "Call"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;		 
		If $Position = "0" And $Opponents = 4 And $hRank < 300 And $nBets <= 2 Then Return "Raise"
		If $Position = "0" And $Opponents = 4 And $nBets = 1 And $IsFirstIn = "NO" AND $hRank < 541 AND $Suited = "YES" And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "0" And $Opponents = 4 And $nBets = 1 And $IsFirstIn = "NO" AND $hRank < 541 AND $Suited = "YES" And $tRaiseCycle[$tn] >= 2 Then Return "Call"
		If $Position = "0" And $Opponents = 4 And $nBets = 2 And $hRank < 517 And $random > 13 Then Return "Raise"
		If $Position = "0" And $Opponents = 4 And $nBets = 2 And $hRank < 517 And $random < 14 Then Return "Call"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "0" And $Opponents = 3 And $hRank < 300 And $nBets <= 2 Then Return "Raise"
		If $Position = "0" And $Opponents = 3 And $nBets = 1 And $IsFirstIn = "NO" AND $hRank < 541 And $Suited = "YES" And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "0" And $Opponents = 3 And $nBets = 1 And $IsFirstIn = "NO" AND $hRank < 541 And $Suited = "YES" And $tRaiseCycle[$tn] >= 2 Then Return "Call"
		If $Position = "0" And $Opponents = 3 And $nBets = 2 And $hRank < 600 And $random > 13 Then Return "Raise"
		If $Position = "0" And $Opponents = 3 And $nBets = 2 And $hRank < 600 And $random < 14 Then Return "Call"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;			
		If $Position = "0" And $hRank < 300 And $nBets > 2 Then Return "Call"
		If $Position = "0" And $hRank < 180 Then Return "Raise"			
		If $Position = "0" And $CheckBtn = 1 Then Return "Check"
		If $Position = "0" And $LastAction[$tn] = "Raise" And $Suited = "YES" Then Return "Call"
		If $Position = "0" And $LastAction[$tn] = "Raise" And $hRank > 300 Then Return "Fold" 	
		If $Position = "0" Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
		;SB Position
		If $Position = "1" Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop SB Position.")
		If $Position = "1" And $IsStealAttempt <> "0" And $Opponents = 2 And _WinrateVsSteal($tn, $HoleCards, Round(_GetAttemptedSteal($tn, $IsStealAttempt), 0)&"%", "random") > 33 Then Return "Raise"
		If $Position = "1" And $hRank < 100  And $IsFirstIn = "YES" Then Return "Call"			
		If $Position = "1" And $IsFirstIn = "YES" AND $hRank <= 488 Then Return "Raise"		
		If $Position = "1" And $IsFirstIn = "YES" AND $hRank <= 868 And $random > 7 Then Return "Raise"
		If $Position = "1" And $IsFirstIn = "YES" AND $hRank <= 1316 And $random > 10  Then Return "Raise"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "1" And $Opponents = 2 And $nBets = 1 AND $hRank <= 288 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 2 And $nBets = 1 AND $hRank <= 288 And $tRaiseCycle[$tn] > 2 Then Return "Call"
		If $Position = "1" And $Opponents = 2 And $nBets = 1 AND $hRank <= 868 Then Return "Call"
		If $Position = "1" And $Opponents = 2 And $nBets > 1 AND $hRank <= 160 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 2 And $nBets > 1 AND $hRank <= 160 And $tRaiseCycle[$tn] > 2 Then Return "Call"
		If $Position = "1" And $Opponents = 2 And $nBets = 2 AND $hRank <= 400 Then Return "Call"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "1" And $Opponents = 3 And $nBets = 1 AND $hRank <= 140 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 3 And $nBets = 1 AND $hRank <= 140 And $tRaiseCycle[$tn] > 2 Then Return "Call"
		If $Position = "1" And $Opponents = 3 And $nBets = 1 AND $hRank <= 656 Then Return "Call"
		If $Position = "1" And $Opponents = 3 And $nBets > 1 AND $hRank <= 140 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 3 And $nBets = 2 AND $hRank <= 450 Then Return "Call"
		If $Position = "1" And $Opponents = 3 And $nBets > 2 AND $hRank <= 196 And $tRaiseCycle[$tn] > 2 Then Return "Call"				
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;	
		If $Position = "1" And $Opponents = 4 And $nBets = 1 AND $hRank <= 376 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 4 And $nBets = 1 AND $hRank <= 1292 Then Return "Call"
		If $Position = "1" And $Opponents = 4 And $nBets = 2 AND $hRank <= 376 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
		If $Position = "1" And $Opponents = 4 And $nBets = 2 AND $hRank <= 416 And $tRaiseCycle[$tn] > 2 Then Return "Call"
		If $Position = "1" And $Opponents = 4 And $nBets >=3 AND $hRank <= 196 And $tRaiseCycle[$tn] < 2 Then Return "Raise"
			;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "1" And  $Opponents = 1 And $Cost <= $BB And $hRank <= 1316 Then Return "Raise"
		If $Position = "1" And  $hRank < 300 Then Return "Call"
		If $Position = "1" And  $CheckBtn = 1 Then Return "Check"
		If $Position = "1" And  $LastAction[$tn] = "Raise" And $Suited = "YES" Then Return "Call"
		If $Position = "1" And  $LastAction[$tn] = "Raise" And $hRank > 260 Then Return "Fold"			
		If $Position = "1" Then Return "Fold"			
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	 ;BB Position
		If $Position = "2" Then	_FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position.")
		If $Position = "2" And $nBets = 2 And $IsStealAttempt <> "0" And $Opponents = 1 And $hRank < Round((_GetAttemptedSteal($tn, $IsStealAttempt)*26.52*.7),0) Then Return "Raise"
		If $Position = "2" And $nBets = 2 And $IsStealAttempt <> "0" And $Opponents = 2 And $nBets < 3 AND $hRank < 356 Then Return "Raise"
		If $Position = "2" And $nBets = 2 And $IsStealAttempt <> "0" And $Opponents = 2 And $nBets = 3 AND $hRank < 180 Then Return "Raise"
		If $Position = "2" And $nBets = 2 And $IsStealAttempt <> "0" And $Opponents = 2 And $nBets = 3 AND $hRank < 356 Then Return "Call"
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "2" And $Opponents = 5 Then	_FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position & 5 Opponents, hRank = "&$hRank)
		If $Position = "2" And $Opponents = 5 And  $CheckBtn = 1 And $hRank <= 332 Then Return "Raise"
		If $Position = "2" And $Opponents = 5 And  $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB And $hRank > 1236 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB And $hRank <= 332 Then Return "Raise"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB And $hRank <= 1236 Then Return "Call"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB*2 And $hRank > 480 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB*2 And $hRank <= 332 Then Return "Raise"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB*2 And $hRank <= 480 Then Return "Call"			
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB*3 And $hRank > 236 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 5 And  $Cost <= $BB*3 Then Return "Call"
		If $Position = "2" And $Opponents = 5 And  $LastAction[$tn] = "Raise" Then Return "Call"
		If $Position = "2" And $Opponents = 5 And  $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $Opponents = 5 Then Return "Fold"					
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "2" And $Opponents = 4 Then	_FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position & 4 Opponents, hRank = "&$hRank)
		If $Position = "2" And $Opponents = 4 And  $CheckBtn = 1 And $hRank <= 416 Then Return "Raise"			
		If $Position = "2" And $Opponents = 4 And  $nBets = 2 And $hRank > 1012 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 4 And  $nBets = 2 And $hRank <= 416 Then Return "Raise"
		If $Position = "2" And $Opponents = 4 And  $nBets = 2 And $hRank <= 1012 Then Return "Call"
		If $Position = "2" And $Opponents = 4 And  $nBets = 3 And $hRank > 844 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 4 And  $nBets = 3 And $hRank <= 416 Then Return "Raise"
		If $Position = "2" And $Opponents = 4 And  $nBets = 3 And $hRank <= 844 Then Return "Call"
		If $Position = "2" And $Opponents = 4 And  $nBets = 4 And $hRank > 304 And $CheckBtn = 0 Then Return "Fold"
		If $Position = "2" And $Opponents = 4 And  $nBets = 4 And $hRank <= 304 And $CheckBtn = 0 Then Return "Call"
		If $Position = "2" And $Opponents = 4 And  $LastAction[$tn] = "Raise" Then Return "Call" 
		If $Position = "2" And $Opponents = 4 And  $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $Opponents = 4 Then Return "Fold"				
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "2" And $Opponents = 3 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position & 3 Opponents, hRank = "&$hRank)
		If $Position = "2" And $Opponents = 3 And  $nBets = 1 And $hRank <= 540 And $random > 14 Then Return "Raise"
		If $Position = "2" And $Opponents = 3 And  $nBets = 1 And $hRank <= 540 And $random < 15 Then Return "Check"
		If $Position = "2" And $Opponents = 3 And  $nBets = 2 And $hRank <= 540 And $random > 14 Then Return "Raise"
		If $Position = "2" And $Opponents = 3 And  $nBets = 2 And $hRank <= 540 And $random < 15 Then Return "Call"
		If $Position = "2" And $Opponents = 3 And  $nBets = 3 And $hRank <= 540 And $random > 14 Then Return "Raise"
		If $Position = "2" And $Opponents = 3 And  $nBets = 3 And $hRank <= 540 And $random < 15 Then Return "Call"
		If $Position = "2" And $Opponents = 3 And  $nBets = 4 And $hRank <= 444 Then Return "Call"
		If $Position = "2" And $Opponents = 3 And  $LastAction[$tn] = "Raise" Then Return "Call"
		If $Position = "2" And $Opponents = 3 And  $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $Opponents = 3 Then Return "Fold"					
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "2" And $Opponents = 2 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position & 2 Opponents, hRank = "&$hRank)
		If $Position = "2" And $Opponents = 2 And  $nBets = 1 And $hRank <= 764 And $random > 14 Then Return "Raise"
		If $Position = "2" And $Opponents = 2 And  $nBets = 1 And $hRank <= 764 And $random < 15 Then Return "Call"
		If $Position = "2" And $Opponents = 2 And  $nBets = 2 And $hRank <= 256 Then Return "Raise"
		If $Position = "2" And $Opponents = 2 And  $nBets = 2 And $hRank <= 764 And $random > 15 Then Return "Raise"
		If $Position = "2" And $Opponents = 2 And  $nBets = 2 And $hRank <= 764 And $random < 16 Then Return "Call"
		If $Position = "2" And $Opponents = 2 And  $nBets >= 3 And $hRank <= 256 Then Return "Raise"
		If $Position = "2" And $Opponents = 2 And  $LastAction[$tn] = "Raise" Then Return "Call"
		If $Position = "2" And $Opponents = 2 And  $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $Opponents = 2 Then Return "Fold"								
		;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~;
		If $Position = "2" And $Opponents = 1 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop BB Position & 1 Opponent, hRank = "&$hRank)	
		If $Position = "2" And $Opponents = 1 And $nBets = 1 And $CheckBtn = 1 Then Return "Check"			
		If $Position = "2" And $Opponents = 1 And $nBets = 2 And _GetPosition($tn, _GetOpponentSeat($tn), $ButtonPosition, $Opponents) = 3 And $hRank > _PositionalVPIP($tn, _GetOpponentSeat($tn), _GetPosition($tn, _GetOpponentSeat($tn), $ButtonPosition, $Opponents))*26.52*.6 Then Return "Fold"
		If $Position = "2" And $Opponents = 1 And $nBets = 2 And $hRank <= Round(_PositionalVPIP($tn, _GetOpponentSeat($tn), _GetPosition($tn, _GetOpponentSeat($tn), $ButtonPosition, $Opponents))*26.52,0) Then Return "Call"
		If $Position = "2" And $CheckBtn = 1 Then Return "Check"
		If $Position = "2" And $hRank <= 128 And $Opponents < 3 Then Return "Call"
		If $Position = "2" And $hRank <= 128 And $Opponents > 2 Then Return "Raise"
		If $Position = "2" And ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $hRank <= 266 Then Return "Call"
		If $Position = "2" And ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $Suited = "YES" Then Return "Call"  
		If $Position = "2" Then Return "Fold"			
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	 ;Late a.k.a CO
		If ($Position/$NumberOfPlayers) >= 0.75 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop Late Position.")
		If ($Position/$NumberOfPlayers) >= 0.75 And  $IsStealTime = "YES" Then Return "Raise"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $hRank < 100  And $IsFirstIn = "YES" And $Random > 6 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $IsFirstIn = "YES" AND $hRank > 566 Then Return "Fold"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $IsFirstIn = "YES" AND $hRank <= 566 And $random > 10 Then Return "Raise"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $IsFirstIn = "YES" AND $hRank <= 566 And $random < 11 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $hRank < 466 And $nBets < 2 And $random > 15 Then Return "Raise"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $hRank < 466 And $nBets < 2 And $random < 16 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $hRank < 60 And $nBets >= 2 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  $hRank < 280 And $nBets >= 2 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $hRank <= 266 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $Suited = "YES" Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.75 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $random > 10 Then Return "Call" 
		If ($Position/$NumberOfPlayers) >= 0.75 And  $CheckBtn = 1 Then Return "Check"
		If ($Position/$NumberOfPlayers) >= 0.75 Then Return "Fold"		
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	 ;Middle (a.k.a. First in when 5Max)
		If ($Position/$NumberOfPlayers) >= 0.5 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop Middle Position.")
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 160  And $IsFirstIn = "YES" And $random > 12 Then Return "Raise"
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 180  And $nBets >= 2 Then Return "Raise"	
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 60   And $random > 10 Then Return "Call"	
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 416  And $IsFirstIn = "YES" And $random > 5 Then Return "Raise"
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 416  And $IsFirstIn = "YES" And $random > 5 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 416  And $nBets = 1 Then Return "Call"				
		If ($Position/$NumberOfPlayers) >= 0.5 And  $hRank < 280  And $nBets >= 2 Then Return "Call"	
		If ($Position/$NumberOfPlayers) >= 0.5 And  $CheckBtn = 1 Then Return "Check"
		If ($Position/$NumberOfPlayers) >= 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $hRank <= 200 Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $Suited = "YES" Then Return "Call"
		If ($Position/$NumberOfPlayers) >= 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $random > 10 Then Return "Call" 
		If ($Position/$NumberOfPlayers) >= 0.5 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;
	 ;Early (a.k.a. First in when 6 Max)	 
		If ($Position/$NumberOfPlayers) < 0.5 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Preflop Early Position.")
		If ($Position/$NumberOfPlayers) < 0.5 And  $hRank < 60   And $IsFirstIn = "YES" And $Random > 6  Then Return "Call"
		If ($Position/$NumberOfPlayers) < 0.5 And  $hRank < 160  And $IsFirstIn = "YES" And $random > 3  Then Return "Raise"
		If ($Position/$NumberOfPlayers) < 0.5 And  $hRank < 416  And $IsFirstIn = "YES" And $random > 5  Then Return "Raise"	
		If ($Position/$NumberOfPlayers) < 0.5 And  $hRank < 700  And $IsFirstIn = "YES" And $random > 10 Then Return "Raise"
		If ($Position/$NumberOfPlayers) < 0.5 And  $hRank < 700  And $IsFirstIn = "YES" And $random > 7 And $Suited = "YES" Then Return "Raise"
		If ($Position/$NumberOfPlayers) < 0.5 And  $CheckBtn = 1 Then Return "Check"
		If ($Position/$NumberOfPlayers) < 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $hRank <= 332 Then Return "Call"
		If ($Position/$NumberOfPlayers) < 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $Suited = "YES" Then Return "Call"
		If ($Position/$NumberOfPlayers) < 0.5 And  ($LastAction[$tn] = "Raise" Or $LastAction[$tn] = "Call") And $random > 10 Then Return "Call" 
		If ($Position/$NumberOfPlayers) < 0.5 Then Return "Fold"
	  ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If 1 Then Return "Fold"
EndFunc  ;<===PreFlopAction

;===============================================================================
;
; Function Name:  		_FlopAction
; Description:     		Makes an action decision on the flop
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $Position, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Opponents, $hRank, $ButtonPosition, $Cost, $CheckBtn, $hand, $IsAPair, $Suited, $OpenEnded, $Flushing, $OppPosition="11", $OppSeat="")
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause, or a function call
; Return Values FL: 	Check, Call, Fold, Raise, Bet
; Return Values NL:  	Check, Call, Fold, Raise:amount, Bet:amount (Acceptable Amounts => any number, word pot, word half, or word allin)
; Author(s):        	You
;
;===============================================================================
Func _FlopAction($tn, $Position, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Opponents, $hRank, $ButtonPosition, $Cost, $CheckBtn, $hand, $IsAPair, $Suited, $OpenEnded, $Flushing, $OppPosition="11", $OppSeat="")
	$random = Random(1, 20, 1)
	If $Opponents = 1 And $AgressorPOS[$tn] = $OppPosition And _FlopCBet($tn, $OppSeat) > 75 And $random > 13 Then Return "Raise"
	If $hand < 2204 And $CheckBtn = 0 And $random > 10 Then _SlowPlayedFlop($tn)
	If $hand < 2204 And $CheckBtn = 0 And $random > 10 Then Return "Call"		
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;		
	If $Opponents = 1 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Flop Action - 1 Opponent. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 1 And ($OpenEnded = "YES" Or $Flushing = "YES") And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 1 And $Flushing = "NUT" And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 1 And $hand > 6185 And $CheckBtn = 0 And $LastAction[$tn] <> "Raise" And StringInStr($BoardCards, "A") Then Return "Fold"
	If $Opponents = 1 And $Position = 2 And $IsAPair = "YES" And $nBetsPreflop[$tn] < 3 And $Equity[$tn] >= 55 And $nBets < 3 Then Return "Raise"
	If $Opponents = 1 And $Position = 2 And $hand > 6185 And $CheckBtn = 0 And $LastAction[$tn] <> "Raise" And StringInStr($BoardCards, "A") Then Return "Fold"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $IsAPair = "YES" And $nBets < 2 Then Return "Raise"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $IsAPair = "YES" And $nBets < 3 And $Equity[$tn] >= 50 Then Return "Raise"
	If $Opponents = 1 And $CheckBtn = 1 And $LastAction[$tn] = "Raise" And $hRank < 100 Then Return "Raise"
	If $Opponents = 1 And $CheckBtn = 1 And $LastAction[$tn] = "Raise" And $random > 8 Then Return "Raise"
	If $Opponents = 1 And $hand < 6186 And $nBets < 3 And $random > 10 Then Return "Raise"
	If $Opponents = 1 And $hand < 6186 And $nBets < 3 And $random < 11 And $CheckBtn = 0 Then Return "Call"			
	If $Opponents = 1 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 1 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 22 Then Return "Call"
	If $Opponents = 1 And $Equity[$tn] >= 50 Then Return "Call"
	If $Opponents = 1 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents = 2 Then  _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Flop Action - 2 Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 2 And $Equity[$tn] >= 92 And $Position = 1 And $CheckBtn = 1 And $random > 7 Then	Return "Check"
	If $Opponents = 2 And $Equity[$tn] >= 92 And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 2 And $OpenEnded = "YES" Or $Flushing = "NUT" Or $Flushing = "YES" Then Return "Raise"				
	If $Opponents = 2 And $IsAPair = "YES" And $nBets < 3 Then Return "Raise"
	If $Opponents = 2 And $Equity[$tn] > 33 And $CheckBtn = 1 And $random > 8 And $nBets < 3 Then Return "Raise"
	If $Opponents = 2 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $random > 8 Then Return "Raise"			
	If $Opponents = 2 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $hand < 6186 And $hRank < 900 And $random > 8 Then Return "Raise"
	If $Opponents = 2 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 2 And $hand > 6185 And $CheckBtn = 0 And $LastAction[$tn] <> "Raise" And StringInStr($BoardCards, "A") Then Return "Fold"
	If $Opponents = 2 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 22 Then Return "Call"
	If $Opponents = 2 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents = 3 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Flop Action - 3 Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 3 And $Equity[$tn] >= 92 And $Position = 1 And $CheckBtn = 1 And $random > 7 Then	Return "Check"
	If $Opponents = 3 And $Equity[$tn] >= 92 And $CheckBtn = 0 Then Return "Call"			
	If $Opponents = 3 And $IsAPair = "YES" And $nBets < 2 Then Return "Raise"
	If $Opponents = 3 And $OpenEnded = "YES" Or $Flushing = "NUT" Or $Flushing = "YES" Then Return "Raise"
	If $Opponents = 3 And $Equity[$tn] > 30 And $CheckBtn = 1 And $random > 8 And $nBets < 3 Then Return "Raise"		
	If $Opponents = 3 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $random > 13 Then Return "Raise"
	If $Opponents = 3 And $hand < 3326 And $nBets < 3 And $random > 6 Then Return "Raise"
	If $Opponents = 3 And $hand < 3326 And $nBets < 3 And $random < 7 Then Return "Call"				
	If $Opponents = 3 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 3 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 22 Then Return "Call"
	If $Opponents = 3 And $Equity[$tn] >= 25 Then Return "Call"
	If $Opponents = 3 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents >= 4 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Flop Action - 4+ Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents >= 4 And $OpenEnded = "YES" Or $Flushing = "NUT" Or $Flushing = "YES" Then Return "Raise"				
	If $Opponents >= 4 And $IsAPair = "YES" And $hRank < 500 And $nBets < 2 Then Return "Raise"
	If $Opponents >= 4 And $hand < 3326 And $nBets < 3 And $random > 6 Then Return "Raise"
	If $Opponents >= 4 And $hand < 3326 And $nBets < 3 And $random < 7 Then Return "Call"						
	If $Opponents >= 4 And $CheckBtn = 1 Then Return "Check"
	If $Opponents >= 4 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 22 Then Return "Call"
	If $Opponents >= 4 And $Equity[$tn] >= 25 Then Return "Call"
	If $Opponents >= 4 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If 1 Then Return "Fold"
EndFunc  ;<===_FlopAction

;===============================================================================
;
; Function Name:  		_TurnAction
; Description:     		Makes an action decision on the flop
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $Position, $Opponents, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Cost, $BB, $hRank, $ButtonPosition, $CheckBtn, $hand, $IsAPair, $BustHand, $nSuitedBoard, $Suited, $OpenEnded, $Flushing, $OppPosition="11", $OppSeat="", $OppIcon="")
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause, or a function call
; Return Values FL: 	Check, Call, Fold, Raise, Bet
; Return Values NL:  	Check, Call, Fold, Raise:amount, Bet:amount (Acceptable Amounts => any number, word pot, word half, or word allin)
; Author(s):        	You
;
;===============================================================================
Func _TurnAction($tn, $Position, $Opponents, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Cost, $BB, $hRank, $ButtonPosition, $CheckBtn, $hand, $IsAPair, $BustHand, $nSuitedBoard, $Suited, $OpenEnded, $Flushing, $OppPosition="11", $OppSeat="", $OppIcon="")	
	_FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Turn Action")
	$random = Random(1, 20, 1)
	If $Opponents = 1 And $Position > $OppPosition And $AgressorPOS[$tn] = $OppPosition And $nBets <= 1 And $Pot/$BB <= 8 And $OppIcon <> 1 And $OppIcon <> 2 And _TurnAF($tn, $OppSeat) > 1.4 And _TurnCBet($tn, $OppSeat) > 70 Then Return "Raise"	
	If $SlowPlayedFlop[$tn] = "YES" And $CheckBtn = 1 And $Position = 1 Then Return "Check"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;		
	If $Opponents = 1 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Turn Action - 1 Opponent. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $IsAPair = "YES" Then Return "Raise"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $hand < 6186 Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 1 And $Equity[$tn] >= "92" And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 1 And $hand < 4400 And $Equity[$tn] >= 60 And $CheckBtn = 1 Then Return "Raise"
	If $Opponents = 1 And $hand < 2204 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 1 And $Position = 2 And $Pot < $BB*8 And $IsAPair = "YES" And $CheckBtn = 1 Then Return "Bet"
	If $Opponents = 1 And $LastAction[$tn] = "Check" And $CheckBtn = 1 And $random > 10 Then Return "Raise"
	If $Opponents = 1 And $OpenEnded = "YES" And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 1 And $Flushing = "NUT"  And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 1 And $Flushing = "YES"  And $Suited = "YES" And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 1 And $BustHand = "YES" And $Equity[$tn] < 44 And $CheckBtn = 0 Then Return "Fold"
	If $Opponents = 1 And $Position = 1 And $nBetsFlop[$tn] = 1 And $random < 5 And $nBets < 2 Then Return "Raise"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $IsAPair = "YES" Then Return "Raise"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $nBetsFlop[$tn] < 3 And $random > 6 Then Return "Raise"
	If $Opponents = 1 And ($Position/($Opponents+1)) = 1 And $CheckBtn = 1 And $random > 10 Then Return "Raise"
	If $Opponents = 1 And $Position = 1 And $CheckBtn = 1 And $LastAction[$tn] = "Check" And $random > 10 Then Return "Raise"
	If $Opponents = 1 And $Position = 1 And $CheckBtn = 1 And $nBetsFlop[$tn] = 1 And $random > 10 Then Return "Raise"
	If $Opponents = 1 And $Equity[$tn] >= "76" And $nBets < 2 Then Return "Raise"
	If $Opponents = 1 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 1 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 27 Then Return "Call"
	If $Opponents = 1 And $Equity[$tn] >= 40 And $nBets = 1 Then Return "Call"
	If $Opponents = 1 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	If $Opponents = 2 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Turn Action - 2 Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 2 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $IsAPair = "YES" Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 2 And $Equity[$tn] >= "92" And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 2 And $hand < 4400 And $Equity[$tn] >= 60 And $CheckBtn = 1 Then Return "Raise"
	If $Opponents = 2 And $hand < 2204 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 2 And $Position = 3 And $Pot < $BB*8 And $IsAPair = "YES" And $CheckBtn = 1 Then Return "Bet"		
	If $Opponents = 2 And $OpenEnded = "YES" And $nSuitedBoard < 3 Then Return "Raise"
	If $Opponents = 2 And $Flushing = "NUT" Then Return "Raise"
	If $Opponents = 2 And $Flushing = "YES" And $Suited = "YES" And $CheckBtn = 0 Then Return "Call"
	If $Opponents = 2 And $Flushing = "YES" And $Suited = "YES" And $CheckBtn = 1 Then Return "Raise"	
	If $Opponents = 2 And $BustHand = "YES" And $Equity[$tn] < 36 And $CheckBtn = 0 Then Return "Fold"		
	If $Opponents = 2 And $LastAction[$tn] = "Check" And $CheckBtn = 1 And $random > 7 Then Return "Raise"
	If $Opponents = 2 And $Position/($Opponents+1) > 0.5 And $Equity[$tn] >= "40"  And $nBets < 3 Then Return "Raise"
	If $Opponents = 2 And $Position/($Opponents+1) <= 0.5 And $Equity[$tn] >= "40" And $random > 10 And $nBets < 3 Then Return "Raise"			
	If $Opponents = 2 And $LastAction[$tn] = "Raise" And $CheckBtn = 1 And $random > 10 Then Return "Raise"
	If $Opponents = 2 And ($Position/($Opponents+1)) = 1 And $CheckBtn = 1 And $random > 10 Then Return "Raise"	
	If $Opponents = 2 And $nBets = 3 Then _ReduceEquity($tn, 8)
	If $Opponents = 2 And $nBets = 4 Then _ReduceEquity($tn, 13)
	If $Opponents = 2 And $Equity[$tn] >= "44" And $nBets < 3 Then Return "Raise"
	If $Opponents = 2 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 2 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 25 Then Return "Call"
	If $Opponents = 2 And $Equity[$tn] >= 35 And $nBets = 1 Then Return "Call"
	If $Opponents = 2 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	If $Opponents = 3 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Turn Action - 3 Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 3 And $hand < 1610 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 3 And $OpenEnded = "YES" And $nSuitedBoard < 3 Then Return "Raise"
	If $Opponents = 3 And $Flushing = "NUT" Then Return "Raise"
	If $Opponents = 3 And $Flushing = "YES" And $Suited = "YES" Then Return "Raise"
	If $Opponents = 3 And $BustHand = "YES" And $Equity[$tn] < 32 And $CheckBtn = 0 Then Return "Fold"					
	If $Opponents = 3 And $Equity[$tn] >= "35" And $random > 5 And $CheckBtn = 1 Or $nBets < 3 Then Return "Raise"
	If $Opponents = 3 And $LastAction[$tn] = "Check" And $CheckBtn = 1 And $random > 7 And $hand < 4300 Then Return "Raise"
	If $Opponents = 3 And $Position/($Opponents+1) > 0.5 And $Equity[$tn] >= "49" And $nBets < 3 Then Return "Raise"
	If $Opponents = 3 And $Position/($Opponents+1) <= 0.5 And $Equity[$tn] >= "49" And $random > 10 And $nBets < 3 Then Return "Raise"
	If $Opponents = 3 And $Position/($Opponents+1) <= 0.5 And $Equity[$tn] >= "49" And $random < 11 And $CheckBtn = 1 Then Return "Check"		
	If $Opponents = 3 And $nBets = 3 Then _ReduceEquity($tn, 12)
	If $Opponents = 3 And $nBets = 4 Then _ReduceEquity($tn, 17)
	If $Opponents = 3 And $Equity[$tn] >= "49"  And $nBets < 3 Then Return "Raise"
	If $Opponents = 3 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 3 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 25 Then Return "Call"
	If $Opponents = 3 And $Equity[$tn] >= 35 And $nBets = 1 Then Return "Call"
	If $Opponents = 3 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	If $Opponents = 4 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "Turn Action - 4+ Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 4 And $hand < 1610 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 4 And $OpenEnded = "YES" And $nSuitedBoard < 3 Then Return "Raise"
	If $Opponents = 4 And $Flushing = "NUT" Then Return "Raise"
	If $Opponents = 4 And $Flushing = "YES" And $Suited = "YES" Then Return "Raise"		
	If $Opponents = 4 And $nBets = 3 Then _ReduceEquity($tn, 12)
	If $Opponents = 4 And $nBets = 4 Then _ReduceEquity($tn, 17)
	If $Opponents = 4 And $Equity[$tn] >= "34"  And $nBets = 1 Then Return "Raise"
	If $Opponents = 4 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 4 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 25 Then Return "Call"
	If $Opponents = 4 And $Equity[$tn] >= 30 And $nBets = 1 Then Return "Call"
	If $Opponents = 4 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;	
	If $CheckBtn = 1 Then Return "Check"
	If ($Cost/$Pot)*100 < $Equity[$tn] Then Return "Call"
	If $Equity[$tn] < (($Cost/$Pot)*100) Then Return "Fold"
	If 1 Then Return "Fold"
EndFunc  ;<===_TurnAction

;===============================================================================
;
; Function Name:  		_RiverAction
; Description:     		Makes an action decision on the flop
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $Position, $Opponents, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Cost, $BB, $hRank, $ButtonPosition, $CheckBtn, $hand, $nSuitedBoard, $BustHand, $Suited)
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause, or a function call
; Return Values FL: 	Check, Call, Fold, Raise, Bet
; Return Values NL:  	Check, Call, Fold, Raise:amount, Bet:amount (Acceptable Amounts => any number, word pot, word half, or word allin)
; Author(s):        	You
;
;===============================================================================
Func _RiverAction($tn, $Position, $Opponents, $HoleCards, $BoardCards, $IsFirstIn, $nBets, $Pot, $Cost, $BB, $hRank, $ButtonPosition, $CheckBtn, $hand, $nSuitedBoard, $BustHand, $Suited)
	$random = Random(1, 20, 1)
	If $Opponents < 3 And $Position/($Opponents+1) = 1 And $Pot/$BB <= 12 And $CheckBtn = 1 And StringInStr($HoleCards, "A") And $Equity[$tn] >= 25 And $random < 10 Then Return "Raise"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;		
	If $Opponents = 1 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "River Action - 1 Opponent. $Equity = "&$Equity[$tn]&"%")			
	If $Opponents = 1 And $hand < 1600 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 1 And $Equity[$tn] = 100 Then Return "Raise"
	If $Opponents = 1 And $Equity[$tn] >= "93" Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 1 And $CheckBtn = 1 And $hand > 3325 And ($nBetsTurn[$tn] > 3 Or $nBetsFlop[$tn] > 3 Or $nBetsPreflop[$tn] > 3) Then Return "Check"
	If $Opponents = 1 And $nBetsTurn[$tn] > 3 And $CheckBtn = 0 And _GetShowdownStrengthTurn($tn, _GetOpponentSeat($tn), 4, $BB) > 4 And $hand > 2467 And $Equity[$tn] < 68 And $nBets > 1 Then Return "Fold"
	If $Opponents = 1 And $nBetsTurn[$tn] > 3 And $CheckBtn = 0 And _GetShowdownStrengthTurn($tn, _GetOpponentSeat($tn), 4, $BB) > 3 And $hand > 3325 And $Equity[$tn] < 68 And $nBets > 1 Then Return "Fold"						
	If $Opponents = 1 And $nBetsTurn[$tn] < 1 And $Equity[$tn] >= 59 And $CheckBtn = 1 And $Position = 2 Then Return "Bet"
	If $Opponents = 1 And $LastAction[$tn] = "Raise" And $nBetsTurn[$tn] < 3 And $CheckBtn = 1 Then Return "Bet"
	If $Opponents = 1 And $BustHand = "YES" And $Equity[$tn] >= 63 Then Return "Call"
	If $Opponents = 1 And $BustHand = "YES" And $CheckBtn = 0 And $Equity[$tn] >= 50 And $nBetsTurn[$tn] < 2 Then Return "Call"			
	If $Opponents = 1 And $nBets > 2 Then _ReduceEquity($tn, 25)
	If $Opponents = 1 And $Position = 1 And $CheckBtn = 1 And $nBetsTurn[$tn] > 2 And $Equity[$tn] <= 70 Then Return "Check"
	If $Opponents = 1 And $Equity[$tn] >= "70" And $nBets < 2 Then Return "Raise"
	If $Opponents = 1 And $Equity[$tn] >= "49" And $CheckBtn = 1 And $Position/($Opponents+1) = 1 Then Return "Raise"
	If $Opponents = 1 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 1 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 60 Then Return "Call"
	If $Opponents = 1 And ($Cost/$Pot)*100 < $Equity[$tn] And $BustHand = "NO" And $Equity[$tn] >= 30 And $Pot < $BB*25 Then Return "Call"
	If $Opponents = 1 And $Equity[$tn] >= 40 And $nBets = 1 Then Return "Call"
	If $Opponents = 1 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents = 2 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "River Action - 2 Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 2 And $Equity[$tn] = 100 Then Return "Raise"
	If $Opponents = 2 And $hand < 1610 And $Equity[$tn] >= 70 And $CheckBtn = 0 Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 2 And ($nBetsTurn[$tn] > 3 Or $nBetsFlop[$tn] > 3 Or $nBetsPreflop[$tn] > 3) And $CheckBtn = 1 And $hand > 3325 Then Return "Check"		
	If $Opponents = 2 And $BustHand = "YES" And $CheckBtn = 0 Then Return "Fold"
	If $Opponents = 2 And $Equity[$tn] >= "92" Then Return "Raise"
	If $Opponents = 2 And $nBets = 3 Then _ReduceEquity($tn, 20)
	If $Opponents = 2 And $Position/($Opponents+1) < 1 And $nBetsTurn[$tn] > 2 And $CheckBtn = 1 And $Equity[$tn] <= 80 Then Return "Check"
	If $Opponents = 2 And $Equity[$tn] >= "70" And $nBets < 2 Then Return "Raise"
	If $Opponents = 2 And $Equity[$tn] >= "49" And $CheckBtn = 1 And $Position/($Opponents+1) = 1 Then Return "Raise"
	If $Opponents = 2 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 2 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 67 Then Return "Call"
	If $Opponents = 2 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 30 And $BustHand = "NO" And $Pot < $BB*26 Then Return "Call"
	If $Opponents = 2 And $Equity[$tn] >= 35 And $nBets = 1 Then Return "Call"
	If $Opponents = 2 Then Return "Fold"	
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents = 3 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "River Action - 3 Opponents. $Equity = "&$Equity[$tn]&"%")			
	If $Opponents = 3 And $hand < 1610 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 3 And ($nBetsTurn[$tn] > 2 Or $nBetsFlop[$tn] > 2 Or $nBetsPreflop[$tn] > 2) And $CheckBtn = 1 And $hand > 3325 Then Return "Check"		
	If $Opponents = 3 And $Equity[$tn] >= "90" Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 3 And $BustHand = "YES" And $CheckBtn = 0 Then Return "Fold"
	If $Opponents = 3 And $nBets = 3 Then _ReduceEquity($tn, 20)
	If $Opponents = 3 And $Position = 1 And $Equity[$tn] >= "68" And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 3 And $Position/($Opponents+1) < 1  And $nBetsTurn[$tn] > 2 Then Return "Check"
	If $Opponents = 3 And $Equity[$tn] >= "68" And $nBets < 2 Then Return "Raise"
	If $Opponents = 3 And $Equity[$tn] >= "49" And $CheckBtn = 1 And $Position/($Opponents+1) > 0.74 Then Return "Raise"
	If $Opponents = 3 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 3 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 30 Then Return "Call"
	If $Opponents = 3 And $Equity[$tn] >= 35 And $nBets = 1 Then Return "Call"
	If $Opponents = 3 Then Return "Fold"	
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If $Opponents = 4 Then _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "River Action - 4+ Opponents. $Equity = "&$Equity[$tn]&"%")
	If $Opponents = 4 And $hand < 1610 And $Equity[$tn] >= 80 And $CheckBtn = 0 Then Return "Raise"
	If $Opponents = 4 And $BustHand = "YES" And $CheckBtn = 0 Then Return "Fold"
	If $Opponents = 4 And $Equity[$tn] >= "95" Then Return "Raise"
	If $Lossrate[$tn] < 2 Then Return "Raise"
	If $Opponents = 4 And $nBets = 3 Then _ReduceEquity($tn, 20)
	If $Opponents = 4 And $Position/($Opponents+1) <= 0.4 And $Equity[$tn] >= "68" And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 4 And $Equity[$tn] >= "70" And $nBets < 2 Then Return "Raise"
	If $Opponents = 4 And $Equity[$tn] >= "49" And $CheckBtn = 1 Then Return "Raise"
	If $Opponents = 4 And $CheckBtn = 1 Then Return "Check"
	If $Opponents = 4 And ($Cost/$Pot)*100 < $Equity[$tn] And $Equity[$tn] >= 30 Then Return "Call"
	If $Opponents = 4 And $Equity[$tn] >= 35 And $nBets = 1 Then Return "Call"
	If $Opponents = 4 Then Return "Fold"
	 ;<<<<<<<<<<<<<>>>>>>>>>>>><<<<<<<<<<<<<>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<>>>>>>>>>>>>>;			
	If 1 Then Return "Fold"
EndFunc  ;<===_RiverAction

;===============================================================================
;
; Function Name:  		_GetRanges
; Description:     		Formula for determining opponent ranges, you can define the $OpponentRanges array variable though this fuction
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $nBets, $ButtonPosition, $NumberOfPlayers, $Seat)
; Requirement(s):   	Define the $OpponentRanges array variable 
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements
; Author(s):        	You
;
;===============================================================================
Func _GetRanges($tn, $nBets, $ButtonPosition, $NumberOfPlayers, $Seat)
	If $nBets = 1 Then $OpponentRanges[$tn][$Seat] = "35"
	If $nBets = 2 Then $OpponentRanges[$tn][$Seat] = Round((_PositionalVPIP($tn, $Seat, _GetPosition($tn, $Seat, $ButtonPosition, $NumberOfPlayers))*.71), 0)
	If $nBets = 3 Then $OpponentRanges[$tn][$Seat] = Round((_PositionalVPIP($tn, $Seat, _GetPosition($tn, $Seat, $ButtonPosition, $NumberOfPlayers))*.65), 0)
	If $nBets = 4 Then $OpponentRanges[$tn][$Seat] = Round((_PositionalVPIP($tn, $Seat, _GetPosition($tn, $Seat, $ButtonPosition, $NumberOfPlayers))/2), 0)
EndFunc  ;<===_GetRanges

;===============================================================================
;
; Function Name:  		_IsTimeToSteal
; Description:     		Define what you consider a good time to steal the blinds
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $Position, $IsFirstIn, $NumberOfPlayers, $hRank, $ButtonPosition, $BBSteal, $SBSteal)
; Requirement(s):   	A Return Value 
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause
; Return Values:		YES or NO
; Author(s):        	You
;
;===============================================================================
Func _IsTimeToSteal($tn, $Position, $IsFirstIn, $NumberOfPlayers, $hRank, $ButtonPosition, $BBSteal, $SBSteal)
	$random = Random (1,20,1)
	If $Position > 1 And ($Position/$NumberOfPlayers) < 0.75 Then Return "NO"
	If $IsFirstIn = "NO" Then Return "NO"
	If $IsFirstIn = "YES" And $Position = "1" And $hRank <= 1468 And $random > 10 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.419") Then Return "YES"
	If $IsFirstIn = "YES" And $Position = "1" And $hRank <= 1468 And $random < 11 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.420") Then Return "NO"
	If $IsFirstIn = "YES" And ($BBSteal + $SBSteal)/2 > 80 And $tRaiseCycle[$tn] < 2 And $hRank <= 1468 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.421") Then Return "YES"
	If $IsFirstIn = "YES" And ($BBSteal + $SBSteal)/2 > 70 And $hRank <= 868 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.422") Then Return "YES"
	If $IsFirstIn = "YES" And ($BBSteal + $SBSteal)/2 > 60 And $hRank <= 632 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.423") Then Return "YES"
	If $IsFirstIn = "YES" And ($BBSteal + $SBSteal)/2 > 40 And $hRank <= 552 And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsTimeToSteal wants to steal.424") Then Return "YES"	
	If 1 Then Return "NO"
EndFunc  ;<===_IsTimeToSteal

;===============================================================================
;
; Function Name:  		_IsBustHandRiver
; Description:     		Define what you consider a bust hand on the river
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($HoleCards, $BoardCards, $hand, $BoardValue)
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause
; Return Values:		YES or NO
; Author(s):        	You
;
;===============================================================================
Func _IsBustHandRiver($HoleCards, $BoardCards, $hand, $BoardValue)
	If $hand = $BoardValue And $BoardValue > 166 And $BoardValue <> 1600 And $BoardValue <> 1601 And $BoardValue <> 1602 And $BoardValue <> 1603 And $BoardValue <> 1604 And $BoardValue <> 1605 And $BoardValue <> 1606 And $BoardValue <> 1607 And $BoardValue <> 1608 And $BoardValue <> 1609 Then Return "YES"
	If $hand > 6185 Then Return "YES"
	If $hand > 3325 And $hand < 6186 And $BoardValue > 3325 And $BoardValue < 6186 Then Return "YES"
	If 1 Then Return "NO"
EndFunc  ;<===_IsBustHandRiver
	
;===============================================================================
;
; Function Name:  		_IsBustHandTurn
; Description:     		Define what you consider a bust hand on the turn
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($HoleCards, $BoardCards, $hand)
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause
; Return Values:		YES or NO
; Author(s):        	You
;
;===============================================================================
Func _IsBustHandTurn($HoleCards, $BoardCards, $hand)
	If $hand > 6185 Then Return "YES"
	If $hand > 3325 And _IsAPair($HoleCards, $BoardCards) = "NO" Then Return "YES"
	If 1 Then Return "NO"
EndFunc  ;<===_IsBustHandTurn

;===============================================================================
;
; Function Name:  		_IsStealAttempt
; Description:     		Define what you consider a steal attempt
; Parameter(s):     	Passed in by the state processor, refer to API for more info
; Parameter(s): 		($tn, $ButtonPosition, $NumberOfPlayers, $street, $Opponents, $Pot)
; Requirement(s):   	A Return Value
; Requirement(s):   	You cannot define new variables, and are required to use 1 line conditional statements, that have to end with a Return clause
; Return Values:		Seat # of the thief
; Author(s):        	You
;
;===============================================================================
Func _IsStealAttempt($tn, $BBSeat, $NumberOfPlayers, $street, $Opponents, $Pot, $CheckBtn)
	If $ActiveSeats[1] = 1 And $AgressorSeat[$tn] = 1 And _IsFirstIn($tn, 1, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 1") Then Return 1
	If $ActiveSeats[2] = 1 And $AgressorSeat[$tn] = 2 And _IsFirstIn($tn, 2, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 2") Then Return 2
	If $ActiveSeats[3] = 1 And $AgressorSeat[$tn] = 3 And _IsFirstIn($tn, 3, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 3") Then Return 3
	If $ActiveSeats[4] = 1 And $AgressorSeat[$tn] = 4 And _IsFirstIn($tn, 4, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 4") Then Return 4
	If $ActiveSeats[5] = 1 And $AgressorSeat[$tn] = 5 And _IsFirstIn($tn, 5, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 5") Then Return 5
	If $ActiveSeats[6] = 1 And $AgressorSeat[$tn] = 6 And _IsFirstIn($tn, 6, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 6") Then Return 6
	If $ActiveSeats[7] = 1 And $AgressorSeat[$tn] = 7 And _IsFirstIn($tn, 7, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 7") Then Return 7
	If $ActiveSeats[8] = 1 And $AgressorSeat[$tn] = 8 And _IsFirstIn($tn, 8, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 8") Then Return 8
	If $ActiveSeats[9] = 1 And $AgressorSeat[$tn] = 9 And _IsFirstIn($tn, 9, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 9") Then Return 9
	If $ActiveSeats[10]= 1 And $AgressorSeat[$tn]= 10 And _IsFirstIn($tn,10, $BBSeat, $NumberOfPlayers, $Street, $Opponents, $Pot, $CheckBtn) = "YES" And ($AgressorPOS[$tn]="1" Or $AgressorPOS[$tn]="0" Or $AgressorPOS[$tn]/$NumberOfPlayers > 0.75) And _FileWriteLog(@DesktopDir & "\PokerAcademy.log", "_IsStealAttempt detected a steal from Seat 10") Then Return 10
	If 1 Then Return 0
EndFunc  ;<===_IsStealAttempt

