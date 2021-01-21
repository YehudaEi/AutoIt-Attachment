Global $dict
Global $p1score = "", $p2score = "", $p3score = "", $p4score = "", $p5score = "", $exit = 0, $letters = "", $dict, $words, $nPlayers = 2, $nComp = 1, $nHuman = 1, $human3, $human4, $human5, $comp3, $comp4, $comp5, $nTurn = 2, $scores[3], $scontrol = -1
Global $turns[6], $type[6]
#include <GuiConstants.au3>
#include <Array.au3>
Opt("TrayIconDebug", 1)
$turns[1] = "Human 1"
$turns[2] = "Computer 1"
$type[1] = 0
$type[2] = 1
$scores[1] = ""
$scores[2] = ""


GuiCreate("Choose Players", 229, 229 - 80)

$addHuman = GuiCtrlCreateButton("Add Human", 40, 50, 140, 20)
$addcomp = GuiCtrlCreateButton("Add Computer", 40, 80, 140, 20)
$lbl1= GuiCtrlCreateLabel("There " & _Iif($nHuman > 1, "are", "is") & " currently " & $nHuman & " human player" & _Iif($nHuman > 1, "s", "") & " and " & $nComp & " computer player" & _Iif($nComp > 1, "s", "") & ".", 10, 10, 210, 50)
$btnGo = GuiCtrlCreateButton("Start Game", 10, 110, 210, 30)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $addHuman
		addHuman()
	Case $msg = $addcomp
		addComp()
	Case $msg = $btnGo
		setTurns()
		GUIDelete()
		ExitLoop
	Case $msg = $GUI_EVENT_CLOSE
		Exit
	EndSelect
WEnd
$nPlayOld = $nPlayers
$nCompOld = $nComp
$nHumanOld = $nHuman
$turnsold = $turns
$typeold = $type
$scoresold = $scores

$gui = GuiCreate("GHOST", 461, 180)

GuiCtrlCreateGroup("Word", 10, 70, 440, 70)
$word = GuiCtrlCreateLabel("", 30, 100, 400, 20)
$p1g = GuiCtrlCreateGroup("Human 1", 10, 10, 80, 50)
$p2g = GuiCtrlCreateGroup("Computer 1", 100, 10, 80, 50)
If $human3 Then
GuiCtrlCreateGroup("Human " & $human3, 190, 10, 80, 50)
ElseIf $comp3 Then
GuiCtrlCreateGroup("Computer " & $comp3, 190, 10, 80, 50)
EndIf
If $human4 Then
GuiCtrlCreateGroup("Human " & $human4, 280, 10, 80, 50)
ElseIf $comp4 Then
GuiCtrlCreateGroup("Computer " & $comp4, 280, 10, 80, 50)
EndIf
If $human5 Then
GuiCtrlCreateGroup("Human " & $human5, 370, 10, 80, 50)
ElseIf $comp5 Then
GuiCtrlCreateGroup("Computer " & $comp5, 370, 10, 80, 50)
EndIf
$p1 = GuiCtrlCreateLabel("", 20, 30, 60, 20)
$p2 = GuiCtrlCreateLabel("", 110, 30, 60, 20)
$p3 = GuiCtrlCreateLabel("", 200, 30, 60, 20)
$p4 = GuiCtrlCreateLabel("", 290, 30, 60, 20)
$p5 = GuiCtrlCreateLabel("", 380, 30, 60, 20)
$lblMsg = GuiCtrlCreateLabel("", 10, 150, 180, 60)
$lblTurn = GuiCtrlCreateLabel("", 200, 150, 140, 60)
$input = GuiCtrlCreateInput("", 350, 150, 30, 20, $WS_DISABLED)
$submit = GuiCtrlCreateButton("Add", 390, 150, 60, 20, $WS_DISABLED)
GUICtrlSetLimit($input, 1)
GUICtrlSetState($submit, $GUI_DEFBUTTON)
GUICtrlSetStyle($input, $ES_LOWERCASE)

GuiSetState()
	GUICtrlSetData($lblMsg, "Opening dictionary file...")
	$file = FileOpen("dictionary.txt", 0)
	$read = FileRead($file, FileGetSize("dictionary.txt"))
	$dict = StringSplit($read, @CrLf, 1)
    FileClose($file)
	GUICtrlSetData($lblMsg, "")
While 1
	For $i = 1 to UBound($scores) - 1
		$j = $i + $scontrol
		Do
			$j = $j + 1
		Until Eval("p" & $i) <> "GHOST"
		GUICtrlSetData(Eval("p" & $j), $scores[$i])
	Next
	$letters = Chr(Random(97, 122, 1))
	$words = getWords($dict, $letters)
	$exit = 0
	$nTurn = 2
	While not $exit
    advanceTurn()
	GUICtrlSetData($lblTurn,$turns[$nTurn] & "'s turn.")
	GUICtrlSetData($word,$letters)
	If not $type[$nTurn] Then
	GUICtrlSetData($lblMsg, "Input a letter:")
	$letters = $letters & inputLetter()
	GUICtrlSetData($word,$letters)
	If StringLen($letters) > 3 Then
		If findWord2($dict, $letters) Then
			loser($nTurn)
			$exit = 1
			ContinueLoop
		EndIf
	EndIf
	Else
	$words = getWords($words, $letters)
	If $words[0] = 1 Then
			_challenge($nTurn - 1)
			$exit = 1
			ContinueLoop
	EndIf
	$letters = _FindOneIncrease($words, $letters)
	GUICtrlSetData($word,$letters)
	If StringLen($letters) > 3 Then
		If findWord2($dict, $letters) Then
			loser($nTurn)
			$exit = 1
			ContinueLoop
		EndIf
	EndIf
	EndIf
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		winnercomp()
		GUIDelete()
		ExitLoop
	EndSelect
WEnd
WEnd

Func winnercomp()
	Exit
EndFunc

Func _challenge($num)
	GUICtrlSetData($lblMsg, $turns[$num]& " can't spell a word from " & '"' & $letters & '".')
	If $num = 0 Then $num = $nPlayers
	If $num = $nPlayers + 1 Then $num = 1
	If $scores[$num] = "GHOS" Then
		$scores[$num] = "GHOST"
		elim($num)
	EndIf
	If $scores[$num] = "GHO" Then $scores[$num] = "GHOS"
	If $scores[$num] = "GH" Then $scores[$num] = "GHO"
	If $scores[$num] = "G" Then $scores[$num] = "GH"
	If $scores[$num] = "" Then $scores[$num] = "G"
EndFunc

Func loser($num)
	GUICtrlSetData($word,$letters)
	GUICtrlSetData($lblMsg, $turns[$num] & " spelled " & $letters & ".")
	If $num = 0 Then $num = $nPlayers
	If $num = $nPlayers + 1 Then $num = 1
	If $scores[$num] = "GHOS" Then
		$scores[$num] = "GHOST"
		elim($num)
	EndIf
	If $scores[$num] = "GHO" Then $scores[$num] = "GHOS"
	If $scores[$num] = "GH" Then $scores[$num] = "GHO"
	If $scores[$num] = "G" Then $scores[$num] = "GH"
	If $scores[$num] = "" Then $scores[$num] = "G"
EndFunc

Func getWords(ByRef $arIn, $szIn, $wordLen = 0)
	Local $current = "", $inLen = StringLen($szIn)
	If $wordLen = 0 Then $wordLen = $inLen
	For $i = 1 to $arIn[0]
		If not StringLen($arIn[$i]) < $inLen and StringLeft($arIn[$i], $inLen) = $szIn and StringLen($arIn[$i]) >= $wordLen Then $current = $current & $arIn[$i] & ","
		Next
	$current = StringSplit($current, ",")
	Return $current
EndFunc

Func selectLetter($letter)
	$file = FileOpen($letter & ".txt", 0)
	$read = FileRead($file, FileGetSize($letter & ".txt"))
	$dict = StringSplit($read, @CrLf, 1)
    FileClose($file)
EndFunc

Func findWord(ByRef $arIn, $szIn)
	If otherword($arin, $szin) = 1 then Return 0
	For $i = 1 to $arIn[0]
		If $arIn[$i] = $szIn Then Return 1
	Next	
	Return 0
EndFunc

Func findWord2(ByRef $arIn, $szIn)
	For $i = 1 to $arIn[0]
		If $arIn[$i] = $szIn Then Return 1
	Next	
	Return 0
EndFunc

Func inputLetter()
	GUICtrlSetState($input, $GUI_ENABLE)
GUICtrlSetState($input, $GUI_FOCUS)
	Do
		$msg = GUIGetMsg()
	$inLetter = GUICtrlRead($input)
	If StringLen($inletter) > 0 Then
		If GUICtrlGetState($submit) = 144 Then GUICtrlSetState($submit, $GUI_ENABLE)
	Else
		If GUICtrlGetState($submit) = 80 Then GUICtrlSetState($submit, $GUI_DISABLE)
	EndIf
	If $msg = $GUI_EVENT_CLOSE Then
		winnercomp()
		Exit
	EndIf
	Until $msg = $submit
	$inLetter = GUICtrlRead($input)
	GUICtrlSetData($input, "")
	GUICtrlSetState($input, $GUI_DISABLE)
	GUICtrlSetState($submit, $GUI_DISABLE)
	return $inLetter
EndFunc

Func winmsg($num)
		GUICtrlSetData($lblMsg, $turns[$num] & " wins!")
		sleep(500)
EndFunc

Func _Iif($f_Test, $v_TrueVal, $v_FalseVal)
   If $f_Test Then
      Return $v_TrueVal
   Else
      Return $v_FalseVal
   EndIf
EndFunc

func addComp()
	$nPlayers = $nPlayers + 1
	$nComp = $nComp + 1
    Assign("comp" & $nPlayers, $nComp)
	$turns[$nPlayers] = "Computer " & $nComp
	$type[$nPlayers] = 1
	ReDim $scores[$nPlayers + 1]
	$scores[$nPlayers] = ""
	GUICtrlSetData($lbl1, "There " & _Iif($nHuman > 1 or $nComp > 1, "are", "is") & " currently " & $nHuman & " human player" & _Iif($nHuman > 1, "s", "") & " and " & $nComp & " computer player" & _Iif($nComp > 1, "s", "") & ".")
	If $nPlayers = 5 Then
		GUICtrlSetState($addComp, $GUI_DISABLE)
		GUICtrlSetState($addHuman, $GUI_DISABLE)
	EndIf
EndFunc

func addHuman()
	$nPlayers = $nPlayers + 1
	$nHuman = $nHuman + 1
    Assign("human" & $nPlayers, $nHuman)
	$turns[$nPlayers] = "Human " & $nHuman
	$type[$nPlayers] = 0
	ReDim $scores[$nPlayers + 1]
	$scores[$nPlayers] = ""
	GUICtrlSetData($lbl1, "There " & _Iif($nHuman > 1, "are", "is") & " currently " & $nHuman & " human player" & _Iif($nHuman > 1, "s", "") & " and " & $nComp & " computer player" & _Iif($nComp > 1, "s", "") & ".")
	If $nPlayers = 5 Then
		GUICtrlSetState($addComp, $GUI_DISABLE)
		GUICtrlSetState($addHuman, $GUI_DISABLE)
	EndIf
EndFunc

Func setTurns()
	$turns[0] = $nplayers
EndFunc

func advanceTurn()
	If $nTurn = $nPlayers Then
		$nTurn = 1
	Else
		$nTurn = $nTurn + 1
	EndIf
EndFunc

func elim($player)
	GUICtrlSetData($lblMsg, $turns[$player] & " has been eliminated!")
	for $i = $player to $nplayers - 1
		$scores[$i] = $scores[$i + 1]
	next
	_ArrayDelete($turns, $player)
	_ArrayDelete($type, $player)
	_ArrayDelete($scores, $player)
	$scontrol = $scontrol + 1
	$nPlayers = $nPlayers - 1
	If $nPlayers = 1 Then winner($turns[1])
EndFunc

Func winner($name)
	GUICtrlSetData($lblMsg, $name & " wins!")
	sleep(500)
	$nTurn = 2
	$p1score = ""
	$p2score = ""
	$p3score = ""
	$p4score = ""
	$p5score = ""
	$nPlayers = $nPlayOld
	$ncomp = $nCompOld
	$nHuman = $nHumanOld
	$turns = $turnsold
	$type = $typeold
EndFunc	

Func getOneWord(ByRef $arIn, $szIn, $char)
	$inLen = StringLen($szIn)
	if longWord($arIn, $szIn) Then
		$arIn = getWords($arIn, $szIn, $inLen + 1)
	EndIf
	$rand = $arIn[Random(1, $arIn[0], 1)]
	$retWord = StringMid($rand, $char, 1)
	Return $retWord
EndFunc
		
Func longWord(ByRef $arIn, $szIn)
	For $word in $arIn
		If StringLen($word) > StringLen($szIn) Then Return 1
	Next
	Return 0
EndFunc

Func _FindOneIncrease(ByRef $arIn, $szIn)
	Local $inLen = StringLen($szIn), $sRet = ""
	Do
		$sRet = StringLeft($arIn[Random(1, $arIn[0], 1)], $inLen + 1)
	Until StringLen($sRet) >= $inLen and not findWord($arIn, $sRet)
	Return $sRet
EndFunc

Func _IsEven($iNum)
	If Mod($iNum, 2) = 0 Then Return 1
	Return 0
EndFunc

Func otherWord(byref $arin, $szin)
	For $oWord In $arIn
		If StringLen($oWord) >= StringLen($szIn) Then
			If StringLeft($oWord, StringLen($szIn)) <> $szIn Then Return 0
		EndIf
	Next
	Return 1
EndFunc