; This file contains all the prob & math functions
; It is suggested to changes / optimisations
#include-once
Func _Calc_points($Card1, $Card2, $Flop, $CardsInFlop)
	; Number of cards = 5 by default. (2 in game, 3 in the flop)... ouhh i'm so clever !!!
	Local $PlayerScore = 0
	Local $ComparedCards[2 + $CardsInFlop][3]
	$ComparedCards[0][0] = $Card1[1]
	$ComparedCards[0][1] = $Card1[2]
	$ComparedCards[1][0] = $Card2[1]
	$ComparedCards[1][1] = $Card2[2]
	$FlopCards = StringSplit($Flop, ";")
	For $ii = 1 To $CardsInFlop
		Local $CurrentCard = StringSplit($FlopCards[$ii], ":")
		$ComparedCards[$ii + 1][0] = $CurrentCard[1]
		$ComparedCards[$ii + 1][1] = $CurrentCard[2]
	Next
	If $bDebugGame Then
		OUT("< All Cards >")
		For $ii = 0 To $CardsInFlop + 1
			OUT("Card N°" & ($ii + 1) & " =>> " & $ComparedCards[$ii][0] & " / " & $ComparedCards[$ii][1])
		Next
		OUT("</ All Cards >")
	EndIf
	; Sorts Them Before doing the comparisons
	$ComparedCards = _sort_cards($ComparedCards)
	If $bDebugGame Then
		OUT("< All Cards Sorted >")
		For $ii = 0 To $CardsInFlop + 1
			OUT("Card N°" & ($ii + 1) & " =>> " & $ComparedCards[$ii][0] & " / " & $ComparedCards[$ii][1])
		Next
		OUT("</ All Cards Sorted >")
	EndIf
	; Let's see the points :)
	; Get Pairs  / Brelan  / Poker / Full house
	For $ii = 0 To UBound($ComparedCards) - 2
		For $kk = ($ii + 1) To UBound($ComparedCards) - 1
			If $ComparedCards[$kk][0] = $ComparedCards[$ii][0] Then
				; find pairs :)
				For $jj = ($kk + 1) To UBound($ComparedCards) - 1
					If $ComparedCards[$jj][0] = $ComparedCards[$ii][0] Then
						OUT("+++ THREE OF A KIND of " & $ComparedCards[$kk][0] & "+++")
						$PlayerScore = 10000
						$PlayerScore += $ComparedCards[$kk][0]
						For $ll = ($jj + 1) To UBound($ComparedCards) - 1
							If $ComparedCards[$ll][0] = $ComparedCards[$ii][0] Then
								OUT("+++ POKER of " & $ComparedCards[$kk][0] & "+++")
								$PlayerScore = 100000000
								$PlayerScore += $ComparedCards[$kk][0]
								ExitLoop
							EndIf
						Next
						
						ExitLoop
					EndIf
				Next
				If $bDebugGame Then
					OUT("+++ PAIR of " & $ComparedCards[$kk][0] & "+++")
				EndIf
				$PlayerScore += 100
				$PlayerScore += $ComparedCards[$kk][0]
			EndIf
		Next
	Next
	;Get Color
	local $sColor = 0
	For $ii = 0 To UBound($ComparedCards) - 2
		if $ComparedCards[$ii][1] + 1 = $ComparedCards[$ii + 1][1] then 
			$sColor += 1
		Else
			ExitLoop
		EndIf	
	Next	
	if $sColor = 4 then 
		if $bDebugGame then OUT("+++ COLOR to " & $ComparedCards[UBound($ComparedCards)- 1][1] & " +++")
		$PlayerScore += 100000
	EndIf	
	; Get Straight if any
	local $Straight = 0
	For $ii = 0 To UBound($ComparedCards) - 2
		if $ComparedCards[$ii][0] + 1 = $ComparedCards[$ii + 1][0] then 
			$Straight += 1
		Else
			ExitLoop
		EndIf	
	Next	
	if $Straight = 4 then 
		if $bDebugGame then OUT("+++ STRAIGHT to " & $ComparedCards[UBound($ComparedCards)- 1][0] & " +++")
		$PlayerScore += 10000
	EndIf	
	if $sColor = 4 and $Straight = 4 then ; OMG quinte flush  !
		if $bDebugGame then OUT("+++ QUINTE FLUSH to " & $ComparedCards[UBound($ComparedCards)- 1][0] & " +++")
		$PlayerScore += 100000000
	EndIf	
	; No points, get the high card
	if $PlayerScore = 0 then 
		local $HighCard = 0
		for $ii = 0 to UBound($ComparedCards) - 1
			if $ComparedCards[$ii][0] > $HighCard then $HighCard = $ComparedCards[$ii][0]
		Next
		$PlayerScore = $HighCard
	EndIf	
	if $bDebugGame then OUT("|||| ----- Player Score is " & $PlayerScore & @crlf)
	return $PlayerScore
EndFunc   ;==>_Calc_points
Func _sort_cards($ArrayOfCards)
	Local $TempCard[UBound($ArrayOfCards)][2]
	$TempCard = $ArrayOfCards
	; Give a value to each card :)
	For $ii = 0 To UBound($TempCard) - 1
		Switch $TempCard[$ii][0]
			;Case "A"
			;	$TempCard[$ii][0] = 14
			Case 1 ; As
				$TempCard[$ii][0] = 14
			Case "Q"
				$TempCard[$ii][0] = 12
			Case "V"
				$TempCard[$ii][0] = 11
			Case "K"
				$TempCard[$ii][0] = 13	
			Case 10
				;Nothing
			case 2,3,4,5,6,7,8,9	
				$TempCard[$ii][0] = "0" & $TempCard[$ii][0]
		EndSwitch
	Next
	_ArraySort($TempCard)
	Return $TempCard
	; Inverse :)
	#cs
		for $ii = 0 to ubound($TempCard) - 1
		switch $TempCard[$ii][0]
		case "A"
		$TempCard[$ii][0] = 14
		case "K"
		$TempCard[$ii][0] = 13
		case "Q"
		$TempCard[$ii][0] = 12
		case "V"
		$TempCard[$ii][0] = 11
		case Else
		;Nothing
		EndSwitch
		Next
	#ce
EndFunc   ;==>_sort_cards