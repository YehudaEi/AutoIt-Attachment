#include <GUIConstants.au3>

$Form1 = GUICreate("Flip", 625, 106, -1, -1, BitOR($WS_SYSMENU,$WS_CAPTION,$WS_POPUPWINDOW,$WS_BORDER,$WS_CLIPSIBLINGS))
$Input1 = GUICtrlCreateInput("", 8, 16, 609, 21)
$Input2 = GUICtrlCreateInput("", 8, 72, 609, 21)
$Button1 = GUICtrlCreateButton("Flip", 280, 40, 81, 25, 0)
GUISetState(@SW_SHOW)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			flip()
	EndSwitch
WEnd

func flip() 
	$result = flipString(StringLower(GUICtrlRead($Input1)))
	GUICtrlSetData($Input2, $result)
EndFunc

func flipString($aString) 
	$last = StringLen($aString) 
	$result = ""
	for $i = $last to 1 Step -1
		$result = $result & flipChar(StringMid($aString,$i,1))
	Next
	return $result
EndFunc

func flipChar($c) 
	Switch $c
		Case 'a'
			Return ChrW(592)
		Case 'b'
			Return 'q'
		Case 'c'
			Return ChrW(596)
		Case 'd'
			Return 'p'
		Case 'e'
			Return ChrW(477)
		Case 'f'
			Return ChrW(607)
		Case 'g'
			Return 'b'
		Case 'h'
			Return ChrW(613)
		Case 'i'
			Return ChrW(305)
		Case 'j'
			Return ChrW(1592) ;hmm strange char 
		Case 'k'
			Return ChrW(670)
		Case 'l'
			Return '1'
		Case 'm'
			Return ChrW(623)
		Case 'n'
			Return 'u'
		Case 'o'
			Return 'o'
		Case 'p'
			Return 'd'
		Case 'q'
			Return 'b'
		Case 'r'
			Return ChrW(633)
		Case 's'
			Return 's'
		Case 't'
			Return ChrW(647)
		Case 'u'
			Return 'n'
		Case 'v'
			Return ChrW(652)
		Case 'w'
			Return ChrW(653)
		Case 'x'
			Return 'x'
		Case 'y'
			Return ChrW(654)
		Case 'z'
			Return 'z'
		Case '['
			Return ']'
		Case ']'
			Return '['
		Case '('
			Return ')'
		Case ')'
			Return '('
		Case '{'
			Return '}'
		Case '}'
			Return '{'
		Case '?'
			Return ChrW(191)
		Case '!'
			Return ChrW(161)
		Case "'"
			Return ','
		Case ','
			Return "'"
		Case '.'
			Return ChrW(176)
	EndSwitch
	
	return $c
	
EndFunc