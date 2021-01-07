#NoTrayIcon
$mode = InputBox("Mode", "Enter 0 if you want to be quized on element symbols only." & @CRLF & @CRLF & "1 if you want to be quized over everything about the elements.", 0, " M"); 0=Symbols Only, 1=All, 234=Cheat :)
Global $msg, $idle
Dim $stats[2] = [0, 0]
$eName = StringSplit("Sulfur,Iron,Barium,Tin,Phosphorus,Neon,Lithium,Potassium,Hydrogen,Helium,Carbon,Nitrogen,Oxygen,Sodium,Aluminum,Silver,Chlorine,Calcium,Copper,Gold,Zinc,Lead,Magnesium,Nickle,Boron,Arsenic,Mercury,Fluorine", ",")
$eSymbol = StringSplit("S,Fe,Ba,Sn,P,Ne,Li,K,H,He,C,N,O,Na,Al,Ag,Cl,Ca,Cu,Au,Zn,Pb,Mg,Ni,B,As,Hg,F", ",")
$eAtomicNumber = StringSplit("16,26,56,50,15,10,3,19,1,2,6,7,8,11,13,47,17,20,29,79,30,82,12,28,5,33,80,9", ",")
$eAtomicMass = StringSplit("32,56,137,119,31,20,7,39,1,4,12,14,16,23,27,108,35,40,64,197,65,209,24,59,11,75,201,19", ",")
AdlibEnable("ChangeIdle", 500)
GUICreate("Element FlashCards", 275, 330, (@DesktopWidth - 275) / 2, (@DesktopHeight - 330) / 2, 0x10CF0000)
GUICtrlCreateLabel("What belongs where the ""??"" is?", 30, 240, 100, 30)
$Name = GUICtrlCreateLabel("Name", 100, 100, 70, 20, 1)
$Symbol = GUICtrlCreateLabel("Sy", 120, 60, 20, 20, 1)
$Number = GUICtrlCreateLabel("A#", 210, 10, 70, 20, 1)
$Mass = GUICtrlCreateLabel("M#", 120, 140, 30, 20, 1)
$Input = GUICtrlCreateInput("", 150, 230, 100, 20)
$IdlePic = GUICtrlCreateLabel("\", 10, 10, Default, Default)
$Submit = GUICtrlCreateButton("Submit", 170, 260, Default, Default, 1)

If $mode = 1 Then
	$Answer = ChangeLables(Random(1, 28, 1), Random(0, 3, 1))
ElseIf $mode = 234 Then
	$Answer = ChangeLables(Random(1, 28, 1), Random(0, 3, 1))
	GUICtrlSetData($Input, $Answer)
Else
	$Answer = ChangeLables(Random(1, 28, 1), 1)
EndIf

While True
    $msg = GUIGetMsg()
    Select
        Case $msg = 0
            ContinueLoop
        Case $msg = -3
			AdlibDisable()
			GUIDelete()
            ExitLoop
        Case $msg = $Submit
            If $Answer == GUICtrlRead($Input)Then
                $tooltip = "Correct!  It was """ & $Answer & """!"
                $stats[1] += 1
            Else
                $tooltip = "Sorry.  """ & $Answer & """ was answer."
            EndIf
            $stats[0] += 1
            $tooltip &= @CRLF & @CRLF & $stats[1] & "/" & $stats[0] & Grade(Round($stats[1] / $stats[0], 3)*100)
            ToolTip($tooltip, 10, 10)
			If $mode = 1 Then
				$Answer = ChangeLables(Random(1, 28, 1), Random(0, 3, 1))
			ElseIf $mode = 234 Then
				$Answer = ChangeLables(Random(1, 28, 1), Random(0, 3, 1))
				GUICtrlSetData($Input, $Answer)
			Else
				$Answer = ChangeLables(Random(1, 28, 1), 1)
			EndIf
    EndSelect
WEnd

Func ChangeIdle()
    Select
        Case $idle = 0
            GUICtrlSetData($IdlePic, "|")
            $idle = 1
        Case $idle = 1
            GUICtrlSetData($IdlePic, "/")
            $idle = 2
        Case $idle = 2
            GUICtrlSetData($IdlePic, "-")
            $idle = 3
        Case $idle = 3
            GUICtrlSetData($IdlePic, "\")
            $idle = 0
    EndSelect
EndFunc;==>ChangeIdle

Func ChangeLables($num, $quiz)
    $quiz = Quiz($num, $quiz)
    GUICtrlSetData($Name, $quiz[0])
    GUICtrlSetData($Symbol, $quiz[1])
    GUICtrlSetData($Number, $quiz[2])
    GUICtrlSetData($Mass, $quiz[3])
    GUICtrlSetData($Input, "")
    GUICtrlSetState($Input, 256)
    Return $quiz[4]
EndFunc;==>ChangeLables

Func Quiz($num, $quiz)
    Dim $return[5]
    $return[0] = $eName[$num]
    $return[1] = $eSymbol[$num]
    $return[2] = $eAtomicNumber[$num]
    $return[3] = $eAtomicMass[$num]
    $return[4] = $return[$quiz]
    $return[$quiz] = "??"
    Return $return
EndFunc;==>Quiz

Func Grade($percent)
	If $percent > 92 Then
		$grade = "A"
	ElseIf $percent > 82 Then
		$grade = "B"
	ElseIf $percent > 70 Then
		$grade = "C"
	ElseIf $percent > 60 Then
		$grade = "D"
	Else
		$grade = "F"
	EndIf
	Return " (" & $percent & "% " & $grade & ")"
EndFunc

ToolTip($stats[1] & "/" & $stats[0] & Grade(Round($stats[1] / $stats[0], 3)*100), (@DesktopWidth-40)/2, (@DesktopHeight-20)/2)
Sleep(15000)