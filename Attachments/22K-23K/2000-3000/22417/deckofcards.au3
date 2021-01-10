;Put this in the beggining area of the script.
Global $deck
$deck = _NewDeck()

;Paste these functions at the bottom of your code.
Func _InitializeDeck($faces=0,$suits=0,$decks=1)
    If Not IsArray($faces) Then Dim $faces[13]=[1,2,3,4,5,6,7,8,9,10,11,12,13]
    If Not IsArray($suits) Then Dim $suits[4]=[0,1,2,3]
    Dim $deck[4]
    Dim $suit = 0
    Dim $card = 0
    For $i = 1 to $decks
        For $x = 0 To UBound($faces)-1
            ReDim $deck[$card+4]
            Do
                $deck[$card] = $suits[$suit] & $faces[$x]
                $card += 1
                $suit +=1
            Until $suit >= 4
            $suit = 0
        Next
    Next
    Return $deck
EndFunc

Func _DrawCards(ByRef $deck,$count)
    If Ubound($deck) <= $count Then $deck = _NewDeck()
    _ArrayReverse($deck)
    Dim $cards[$count]
    For $i = 0 to $count-1
        $cards[$i] = $deck[UBound($deck)-1]
        _ArrayPop($deck)
    Next
    _ArrayReverse($deck)
    Return $cards
EndFunc

Func _ShuffleDeck($deck)   
    SRandom(Random(0,10))
    For $x = 0 To 50
        _ArraySwap($deck[Random($x,51,1)],$deck[$x])
    Next
    For $x = 51 To 1 Step -1
        _ArraySwap($deck[Random(0,$x,1)],$deck[$x])
    Next
    Return $deck
EndFunc

Func _CutDeck($deck,$count=0)
    If $count <= 0 Or $count >= UBound($deck)-1 Then $count = Random(13,39,1)
    For $i = 1 to $count
        _ArrayPush($deck,$deck[UBound($deck)-1],1)
    Next
    Return $deck
EndFunc

Func _NewDeck()
    Dim $faces[13]=[12,13,14,15,16,17,18,19,20,21,22,23,24]
    Dim $suits[4]=[1,2,3,4]
    Return _CutDeck(_ShuffleDeck(_InitializeDeck($faces,$suits)))
EndFunc

;Replace this function
Func _NewCard()
    Local $Mycard = _DrawCards($deck,1)
    Return $Mycard[0]
EndFunc