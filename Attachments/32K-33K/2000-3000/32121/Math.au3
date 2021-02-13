#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>

Global $ProblemGrid, $i, $compos, $Answer, $Msg, $StoreProblemGrid, $result, $StartingNumber, $Count, $SaveNumbers, $State, $Add, $Subtract, $Multiply, $Divide, $Powers, $SquareRoot, $NumberToStartWith, $AddAnswer, $StoreCurrentAnswer

Opt('MustDeclareVars', 1)

GUICreate("Math Functions", 400, 440)
$ProblemGrid = GuiCtrlCreateEdit(" ", 0,0, 400, 260)
GuiCtrlCreateLabel("Answer section", 150, 270)
$Answer = GuiCtrlCreateEdit(" ",0,290,400, 20)
$Add = GuiCtrlCreateButton("Add", 0, 315)
$Subtract = GuiCtrlCreateButton("Subtract", 160, 315)
$Multiply = GuiCtrlCreateButton("Multiply", 355, 315)
$Divide = GuiCtrlCreateButton("Divide", 0, 370)
$Powers = GuiCtrlCreateButton("Raise to Power", 140, 370)
$SquareRoot = GuiCtrlCreateButton("Square Root", 330, 370)
$AddAnswer = GuiCtrlCreateButton("Use previous answer", 130, 410)
GuiSetState(@SW_SHOW)

 Do
        $msg = GUIGetMsg()
		If $msg = $Add Then
			$state = 0
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$compos = StringSplit($StoreProblemGrid, "+")
			For $i = 1 To $compos[0]
			$result += $compos[$i]
		Next
		While $state = 0
		$state = 1
		GuiCtrlSetData($Answer, $result)
		ControlFocus("Math Functions", "", "Edit1")
		$result = 0
		WEnd

			EndIf
			
		If $msg = $Subtract Then
			$state = 0
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$compos = StringSplit($StoreProblemGrid, "-")
			$result = $compos[1]
			For $i = 2 To $compos[0]
			$result -= $compos[$i]
		Next
		While $state = 0
		$state = 1
		GuiCtrlSetData($Answer, $result)
		ControlFocus("Math Functions", "", "Edit1")
		$result = 0
	WEnd
	
EndIf

			If $msg = $Multiply Then
			$state = 0
			$result = 1
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$compos = StringSplit($StoreProblemGrid, "*")
			For $i = 1 To $compos[0]
			$result *= $compos[$i]
		Next
		While $state = 0
		$state = 1
		GuiCtrlSetData($Answer, $result)
		ControlFocus("Math Functions", "", "Edit1")
		$result = 0
	WEnd
	
EndIf
				If $msg = $Divide Then
			$state = 0
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$compos = StringSplit($StoreProblemGrid, "/")
			$result = $compos[1]
			For $i = 2 To $compos[0]
			$result /= $compos[$i]
		Next
		While $state = 0
		$state = 1
		GuiCtrlSetData($Answer, $result)
		ControlFocus("Math Functions", "", "Edit1")
		$result = 0
	WEnd
	
EndIf
		
		If $msg = $Powers Then
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$result = StringSplit($StoreProblemGrid, "^")
			$StartingNumber = $result[0]
			$Count = 0
			$State = 0
			Do
				$StartingNumber -= 1
			If $StartingNumber = 0 Then
				$SaveNumbers = $result[1]^$result[2]
				GuiCtrlSetData($Answer, $SaveNumbers)
				ControlFocus("Math Functions", "", "Edit1")
				$SaveNumbers = ""
				$state = 1
				EndIf
			Until $state = 1

			EndIf
			
			If $msg = $SquareRoot Then
			$StoreProblemGrid = ControlGetText("Math Functions", "", "Edit1")
			$SaveNumbers = Sqrt($StoreProblemGrid)
				GuiCtrlSetData($Answer, $SaveNumbers)
				ControlFocus("Math Functions", "", "Edit1")
			EndIf
		
		If $msg = $AddAnswer Then
			$StoreCurrentAnswer = ControlGetText("Math Functions", "", "Edit2")
			GuiCtrlSetData($ProblemGrid, $StoreCurrentAnswer)
			ControlFocus("Math Functions", "", "Edit1")
			EndIf
    Until $msg = $GUI_EVENT_CLOSE