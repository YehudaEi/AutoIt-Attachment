#include <GUIConstantsEx.au3> ;$GUI_EVENT_CLOSE
#include <Array.au3> ;_ArrayAdd

#include "_WinSplit.au3"


Global $Form, $ButtonSV, $ButtonSH, $ButtonRGUI
Global $sForms[1] = [0]

_CreateGui()

Local $sForm

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $ButtonSV
			$sForm = _WinSplit($Form,$WS_HALF,$WS_VERTICAL)
			_ArrayAdd($sForms,$sForm)
			$sForms[0]+=1
		Case $ButtonSH
			$sForm = _WinSplit($Form,$WS_HALF,$WS_HORIZONTAL)
			_ArrayAdd($sForms,$sForm)
			$sForms[0]+=1
		Case $ButtonRGUI
			For $i = 1 To $sForms[0]
				GUIDelete($sForms[$i])
			Next
			GUIDelete($Form)
			_CreateGui()
	EndSwitch
WEnd

Func _CreateGui()
	$Form = GUICreate("_WinSplit Example", 615, 437)
	$ButtonSV = GUICtrlCreateButton("Split Vertical", 24, 16, 75, 25)
	$ButtonSH = GUICtrlCreateButton("Split Horizontal", 488, 16, 75, 25)
	$ButtonRGUI = GUICtrlCreateButton("Reset GUI", 32, 384, 75, 25)
	GUICtrlCreateButton("Button", 488, 392, 75, 25)
	GUICtrlCreateLabel("Label", 24, 56, 36, 17)
	GUICtrlCreateRadio("Radio", 424, 96, 113, 17)
	GUICtrlCreateEdit("EditBox", 32, 288, 121, 89)
	GUICtrlCreateCombo("Combo", 392, 352, 145, 25)
	ReDim $sForms[1]
	$sForms[0] = 0
	Return GUISetState(@SW_SHOW,$Form)
EndFunc