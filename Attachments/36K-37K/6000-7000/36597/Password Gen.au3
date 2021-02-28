#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#NoTrayIcon

Main()

Func Main()

	GUICreate("Password Gen - ReaperX", 278, 120)
	GUICtrlCreateLabel("Password:", 10, 20)
	$Pass = GUICtrlCreateInput("", 65, 19, 200, 18, BitOr($GUI_SS_DEFAULT_INPUT, $ES_READONLY))
	$Nums = GUICtrlCreateRadio("Numbers", 65, 40)
	$NumsAndLetts = GUICtrlCreateRadio("Numbers And Letters", 140, 40)
	GUICtrlSetState($Nums, $GUI_CHECKED)
	$GenButton = GUICtrlCreateButton("Generate", 100, 80, 80, 30)
	$CopyButton = GUICtrlCreateButton("Copy", 180, 80, 80, 30)
	GUICtrlCreateGroup("Char Limit", 0, 60, 80, 60)
	$CharLimit = GUICtrlCreateInput("20", 20, 80, 40, 20, $ES_READONLY)
	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 50, 5)
	GUICtrlSetLimit($CharLimit, 2, 0)
	GUICtrlCreateLabel("Max: 50", 20, 102, 40, 10)
	GUICtrlSetFont(-1, 7)

	GUISetState()

	While 1
		$Msg = GUIGetMsg()
		Switch $Msg
			Case -3
				Exit
			Case $GenButton
				If GUICtrlRead($CharLimit) > 50 Then GUICtrlSetData($CharLimit, 50)
				If BitOR(GUICtrlRead($Nums), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetData($Pass, "")
					$iCharLimit = GUICtrlRead($CharLimit)
					For $i = 1 To $iCharLimit
						$Int = Int(Random(0, 10))
						GUICtrlSetData($Pass, GUICtrlRead($Pass) & $Int)
					Next
					If StringLen(GUICtrlRead($Pass)) > $iCharLimit Then
						$Trim = StringTrimRight(GUICtrlRead($Pass), StringLen(GUICtrlRead($Pass)) - $iCharLimit)
						GUICtrlSetData($Pass, $Trim)
					EndIf
				EndIf
				If BitOR(GUICtrlRead($NumsAndLetts), $GUI_CHECKED) = $GUI_CHECKED Then
					GUICtrlSetData($Pass, "")
					$iCharLimit = GUICtrlRead($CharLimit)
					For $i = 1 To $iCharLimit
							$LetterInt = Int(Random(1, 28))
							$Int = Int(Random(1, 10))
							If $LetterInt = 1 Then $Char = "A"
							If $LetterInt = 2 Then $Char = "B"
							If $LetterInt = 3 Then $Char = "C"
							If $LetterInt = 4 Then $Char = "D"
							If $LetterInt = 5 Then $Char = "E"
							If $LetterInt = 6 Then $Char = "D"
							If $LetterInt = 7 Then $Char = "E"
							If $LetterInt = 8 Then $Char = "F"
							If $LetterInt = 9 Then $Char = "G"
							If $LetterInt = 10 Then $Char = "H"
							If $LetterInt = 11 Then $Char = "I"
							If $LetterInt = 12 Then $Char = "J"
							If $LetterInt = 13 Then $Char = "K"
							If $LetterInt = 14 Then $Char = "L"
							If $LetterInt = 15 Then $Char = "M"
							If $LetterInt = 16 Then $Char = "N"
							If $LetterInt = 17 Then $Char = "O"
							If $LetterInt = 18 Then $Char = "P"
							If $LetterInt = 19 Then $Char = "Q"
							If $LetterInt = 20 Then $Char = "R"
							If $LetterInt = 21 Then $Char = "S"
							If $LetterInt = 22 Then $Char = "T"
							If $LetterInt = 23 Then $Char = "U"
							If $LetterInt = 24 Then $Char = "V"
							If $LetterInt = 25 Then $Char = "W"
							If $LetterInt = 26 Then $Char = "X"
							If $LetterInt = 27 Then $Char = "Y"
							If $LetterInt = 28 Then $Char = "Z"
						GUICtrlSetData($Pass, GUICtrlRead($Pass) & $Char & $Int)
					Next
					If StringLen(GUICtrlRead($Pass)) > $iCharLimit Then
						$Trim = StringTrimRight(GUICtrlRead($Pass), StringLen(GUICtrlRead($Pass)) - $iCharLimit)
						GUICtrlSetData($Pass, $Trim)
					EndIf
				EndIf
			Case $CopyButton
				If StringLen(GUICtrlRead($Pass)) > 0 Then
				ClipPut(GUICtrlRead($Pass))
				MsgBox(0, "Password Gen", "Password Copied to Clipboard!")
				EndIf
		EndSwitch
	WEnd
EndFunc   ;==>Main


