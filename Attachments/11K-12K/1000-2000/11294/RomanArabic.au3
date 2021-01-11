#include <GUIConstants.au3>
Dim $c, $c1, $hn=1, $num
Opt("GUIOnEventMode", 1)
$F1 = GUICreate('Roman Arabic # Converter', 260, 75, (@DesktopWidth-260)/2, (@DesktopHeight-275)/2)
$e01 = GUICtrlCreateInput("", 10, 11, 240, 25, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetFont($e01,16,800)
$b01 = GUICtrlCreateButton("2Clpbd", 10, 42, 40, 25)
$b02 = GUICtrlCreateButton("Clear", 60, 42, 30, 25)
$b03 = GUICtrlCreateButton("Convert", 160, 42, 90, 25)
$b04 = GUICtrlCreateButton("Rnd", 100, 42, 30, 25)
GUISetOnEvent($GUI_EVENT_CLOSE, "CornerX")
GUICtrlSetOnEvent ( $b01,'toclpbd')
GUICtrlSetOnEvent ( $b02,'clr')
GUICtrlSetOnEvent ( $b03,'r2aNa2r')
GUICtrlSetOnEvent ( $b04,'rndno')
GUISetState()
WinSetOnTop('Roman Arabic # Converter', '', 1)
While 1
	Sleep(500)
WEnd
Func toclpbd()
  ClipPut ( GUICtrlRead($e01) )
EndFunc
Func clr()
  GUICtrlSetData($e01,'')
EndFunc
Func rndno()
  GUICtrlSetData($e01,int(Random(0,5000))) ;for sake of testing set it to 5000 only
EndFunc
Func CornerX()
  Exit
EndFunc
Func r2aNa2r()
	Dim $a, $af=0, $rnum
	Dim $rarry [3][4] = [['','I','V','X'],['','X','L','C'],['','C','D','M']]
	If GUICtrlRead($e01)= "" Then Return
	If StringRegExp(GUICtrlRead($e01),'[^:alnum:]') Then
		$a = StringRegExpReplace(GUICtrlRead($e01),'[^:alnum:]','')
	Else
		$a = GUICtrlRead($e01)
	EndIf	
	If StringIsDigit($a) And StringMid($a,1,1)<>0 Then
		For $b = StringLen($a) To 1 Step -1
			$b1 = StringLen($a)-$b
			If $b1 < 3 Then
				Switch StringMid($a,$b,1)
					Case 0
						$rnum = $rarry [$b1][0]&$rnum
					Case 1 To 3
						For $b2 = 1 To StringMid($a,$b,1)
							$rnum = $rarry [$b1][1]&$rnum
						Next
					Case 4
						$rnum = $rarry [$b1][1]&$rarry [$b1][2]&$rnum
					Case 5
						$rnum = $rarry [$b1][2]&$rnum
					Case 6 To 8
						For $b2 = 1 To StringMid($a,$b,1)-5
							$rnum = $rarry [$b1][1]&$rnum
						Next
						$rnum = $rarry [$b1][2]&$rnum
					Case 9
						$rnum = $rarry [$b1][1]&$rarry [$b1][3]&$rnum
				EndSwitch
			Else
				For $b3 = 1 To StringTrimRight($a,3)
					$rnum = 'M' & $rnum
				Next	
				ExitLoop
			EndIf	
		Next
		$num = $rnum
	ElseIf StringIsAlpha($a) And Not StringRegExp($a,'[^MCDLXVImcdlxvi]')=1 Then
		For $b = StringLen($a) To 1 Step -1
			Select
				Case StringMid($a,$b,1) = 'M'
					$af = addormin(7,1000)
				Case StringMid($a,$b,1) = 'D'
					$af = addormin(6,500)
				Case StringMid($a,$b,1) = 'C'
					$af = addormin(5,100)
				Case StringMid($a,$b,1) = 'L'
					$af = addormin(4,50)
				Case StringMid($a,$b,1) = 'X'
					$af = addormin(3,10)
				Case StringMid($a,$b,1) = 'V'
					$af = addormin(2,5)
				Case StringMid($a,$b,1) = 'I'
					$af = addormin(1,1)
			EndSelect
			If $af = 1 Then ExitLoop
		Next	
	Else
		MsgBox(0,'Error','This is not a valid Roman or Arabic number.',3)
	EndIf
	If $af <> 1 Then GUICtrlSetData($e01,$num)
	GUICtrlSetState($e01,$GUI_FOCUS)
	$hn = 1
	$num = 0
	$af = 0
EndFunc
Func addormin($c,$c1)
	If $c >= $hn Then 
		$num += $c1
	ElseIf $hn - $c = 1 And $c <> 6 And $c <> 4 And $c <> 2 Then 
		$num -= $c1	
	ElseIf $hn - $c = 2 And $c = 5 Then
		$num -= $c1	
	ElseIf $hn - $c = 2 And $c = 3 Then
		$num -= $c1	
	ElseIf $hn - $c = 2 And $c = 1 Then
		$num -= $c1	
	Else
		MsgBox(0,'Error','This is not a valid Roman number.',3)
		$hn = 1
		Return 1
	EndIf
	$hn = $c
EndFunc