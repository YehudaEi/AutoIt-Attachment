#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Au3Check_Stop_OnWarning=y
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/sfc
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
Dim $Button[30], $MenuItem[5]
Global $GUI, $Input, $Solved = False, $Answer, $A, $B, $C, $D, $E, $Scientific = False, $Pi = 3.1415926535897932, $FileExit
Global $HelpContents
Opt("TrayIconDebug", 1)

Create_GUI()

While 1
	Switch GUIGetMsg()
		Case - 3, $FileExit
			Close()
		Case $HelpContents
			Help()
		Case $Button[2] ;==> )
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(')')
		Case $Button[1] ;==> (
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput('(')
		Case $Button[22]
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			Local $aNumbers = StringSplit(GUICtrlRead($Input), '-+\*^')
			If Not StringInStr($aNumbers[$aNumbers[0]], '.') Then SetInput('.')
		Case $Button[10] ;==> ^-1
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, 'Ans')
			EndIf
			SetInput('^-1')
		Case $Button[5] ;==> Pi
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput($Pi)
		Case $Button[15] ;==> ^
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput('^')
		Case $Button[20] ;==> ^2
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput('^2')
		Case $Button[21] ;==> 0
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(0)
		Case $Button[16] ;==> 1
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(1)
		Case $Button[17] ;==> 2
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(2)
		Case $Button[18] ;==> 3
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(3)
		Case $Button[11] ;==> 4
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(4)
		Case $Button[12] ;==> 5
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(5)
		Case $Button[13] ;==> 6
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(6)
		Case $Button[6] ;==> 7
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(7)
		Case $Button[7] ;==> 8
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(8)
		Case $Button[8] ;==> 9
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			SetInput(9)
		Case $Button[23] ;==> =
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, '')
			EndIf
			Calculate()
		Case $Button[24] ;==> +
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, 'Ans')
			EndIf
			SetInput('+')
		Case $Button[19] ;==> -
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, 'Ans')
			EndIf
			SetInput('-')
		Case $Button[14] ;==> *
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, 'Ans')
			EndIf
			SetInput('*')
		Case $Button[9] ;==> /
			If $Solved = True Then
				$Solved = False
				GUICtrlSetData($Input, 'Ans')
			EndIf
			SetInput('/')
		Case $MenuItem[0]
			$A = ''
			GUICtrlSetTip($Button[25], '')
		Case $MenuItem[1]
			$B = ''
			GUICtrlSetTip($Button[26], '')
		Case $MenuItem[2]
			$C = ''
			GUICtrlSetTip($Button[27], '')
		Case $MenuItem[3]
			$D = ''
			GUICtrlSetTip($Button[28], '')
		Case $MenuItem[4]
			$E = ''
			GUICtrlSetTip($Button[29], '')
		Case $Button[0]
			$A = ''
			$B = ''
			$C = ''
			$D = ''
			$E = ''
			For $x = 25 To 29
				GUICtrlSetTip($Button[$x], '')
			Next
		Case $Button[25] ;==> A
			If $Solved = True Then
				$Solved = False
				SetVariable('A')
			ElseIf $A = '' Then
				Error_Handler(4)
			Else
				SetInput('A')
			EndIf
		Case $Button[26] ;==> B
			If $Solved = True Then
				$Solved = False
				SetVariable('B')
			ElseIf $B = '' Then
				Error_Handler(5)
			Else
				SetInput('B')
			EndIf
		Case $Button[27] ;==> C
			If $Solved = True Then
				$Solved = False
				SetVariable('C')
			ElseIf $C = '' Then
				Error_Handler(6)
			Else
				SetInput('C')
			EndIf
		Case $Button[28] ;==> D
			If $Solved = True Then
				$Solved = False
				SetVariable('D')
			ElseIf $D = '' Then
				Error_Handler(7)
			Else
				SetInput('D')
			EndIf
		Case $Button[29] ;==> E
			If $Solved = True Then
				$Solved = False
				SetVariable('E')
			ElseIf $E = '' Then
				Error_Handler(8)
			Else
				SetInput('E')
			EndIf
		Case $Button[3] ; Clear
			GUICtrlSetData($Input, '')
		Case $Button[4] ; Backspace
			If $Solved = True Then
				GUICtrlSetData($Input, '')
			Else
				GUICtrlSetData($Input, StringTrimRight(GUICtrlRead($Input), 1))
			EndIf
	EndSwitch
WEnd

Func Calculate()
	Local $InputText = GUICtrlRead($Input)
	If Check_Error($InputText) <> 0 Then
		Error_Handler(@error)
		GUICtrlSetData($Input, '')
		Return
	EndIf
	If StringInStr($InputText, 'Ans') Then
		$InputText2 = StringReplace($InputText, 'Ans', $Answer)
	Else
		$InputText2 = $InputText
	EndIf
	If StringInStr($InputText2, 'A') Then $InputText2 = StringReplace($InputText2, 'A', $A)
	If StringInStr($InputText2, 'B') Then $InputText2 = StringReplace($InputText2, 'B', $B)
	If StringInStr($InputText2, 'C') Then $InputText2 = StringReplace($InputText2, 'C', $C)
	If StringInStr($InputText2, 'D') Then $InputText2 = StringReplace($InputText2, 'D', $D)
	If StringInStr($InputText2, 'E') Then $InputText2 = StringReplace($InputText2, 'E', $E)
	$Answer = Execute($InputText2)
	GUICtrlSetData($Input, $InputText & @CRLF & $Answer)
	$Solved = True
EndFunc   ;==>Calculate

Func Check_Error($Text)
	Local $SplitString = StringSplit($Text, "")
	Local $RegExp2 = StringRegExp($Text, '^[\(\+\-\.0-9A-E]?', 1)
	Local $RegExp3 = StringRegExp($Text, '[\)\.0-9A-E]?', 1, StringLen($Text))
	If $Text <> '' Then
		If UBound(StringRegExp($Text, '\(', 3)) <> UBound(StringRegExp($Text, '\)', 3)) Then
			SetError(1)
			Return -1
		ElseIf $RegExp2[0] = '' Then
			SetError(2)
			Return -1
		ElseIf $RegExp3[0] = '' Then
			SetError(3)
			Return -1
		EndIf
	EndIf
	Return 0
EndFunc   ;==>Check_Error

Func Close()
	GUISetState(@SW_DISABLE, $GUI)
	$Exit = GUICreate("Exit?", 250, 125, -1, -1, $WS_MINIMIZEBOX, -1, $GUI)
	$Button1 = GUICtrlCreateButton("&Yes", 43, 60, 75, 25, 0)
	$Button2 = GUICtrlCreateButton("&No", 124, 60, 75, 25, 0)
	$Icon1 = GUICtrlCreateIcon(@SystemDir & "\user32.dll", -3, 11, 11, 32, 32)
	$Label1 = GUICtrlCreateLabel("Are you sure you want to exit?", 62, 20, 164, 19)
	GUICtrlSetFont(-1, 9, 400, 0, "Arial")
	GUISetState(@SW_SHOW, $Exit)
	While 1
		Switch GUIGetMsg()
			Case $Button1
				Exit
			Case $Button2
				GUISetState(@SW_ENABLE, $GUI)
				GUIDelete($Exit)
				WinActivate($GUI)
				Return
		EndSwitch
	WEnd
EndFunc   ;==>Close

Func Create_GUI()
	Local $Left = 15, $Row = 0, $Context[5]
	Local $ButtonText[30] = ['ClrVar', '(', ')', 'Clear', 'Back', 'Pi', '7', '8', '9', '/', 'x^-1', '4', '5', '6', '*', 'x^y', '1', '2', '3', _
			'-', 'x^2', '0', '.', '=', '+', 'A', 'B', 'C', 'D', 'E']
	$GUI = GUICreate("", 225, 275)
	$Input = GUICtrlCreateInput("", 15, 15, 195, 40, $ES_MULTILINE + $ES_RIGHT + $ES_READONLY + $ES_AUTOHSCROLL)
	For $x = 0 To 29
		$Button[$x] = GUICtrlCreateButton($ButtonText[$x], $Left, $Row * 30 + 65, 35, 25)
		$Left += 40
		If $Left > 175 Then
			$Row += 1
			$Left = 15
		EndIf
	Next
	$Context[0] = GUICtrlCreateContextMenu($Button[20])
	$MenuItem[0] = GUICtrlCreateMenuItem("Clear Variable", $Context[0])
	$Context[1] = GUICtrlCreateContextMenu($Button[21])
	$MenuItem[1] = GUICtrlCreateMenuItem("Clear Variable", $Context[1])
	$Context[2] = GUICtrlCreateContextMenu($Button[22])
	$MenuItem[2] = GUICtrlCreateMenuItem("Clear Variable", $Context[2])
	$Context[3] = GUICtrlCreateContextMenu($Button[23])
	$MenuItem[3] = GUICtrlCreateMenuItem("Clear Variable", $Context[3])
	$Context[4] = GUICtrlCreateContextMenu($Button[24])
	$MenuItem[4] = GUICtrlCreateMenuItem("Clear Variable", $Context[4])

	$File = GUICtrlCreateMenu("&File")
	$FileExit = GUICtrlCreateMenuItem("&Exit", $File)
	$Help = GUICtrlCreateMenu("&Help")
	$HelpContents = GUICtrlCreateMenuItem("&Contents", $Help)
	GUISetState()
EndFunc   ;==>Create_GUI

Func Error_Handler($Type)
	Switch $Type
		Case 1
			MsgBox(48, 'ERROR', 'Unbalanced parenthesis')
		Case 2
			MsgBox(48, 'ERROR', "Can't begin expression with an operator.")
		Case 3
			MsgBox(48, 'ERROR', "Can't end expression with an operator.")
		Case 4
			MsgBox(48, 'ERROR', 'There is no value assigned to variable A.')
		Case 5
			MsgBox(48, 'ERROR', 'There is no value assigned to variable B.')
		Case 6
			MsgBox(48, 'ERROR', 'There is no value assigned to variable C.')
		Case 7
			MsgBox(48, 'ERROR', 'There is no value assigned to variable D.')
		Case 8
			MsgBox(48, 'ERROR', 'There is no value assigned to variable E.')
	EndSwitch
EndFunc   ;==>Error_Handler

Func Help()
EndFunc   ;==>Help

Func SetInput($Text)
	GUICtrlSetData($Input, GUICtrlRead($Input) & $Text)
EndFunc   ;==>SetInput

Func SetVariable($Variable)
	Switch $Variable
		Case 'A'
			$A = $Answer
			GUICtrlSetTip($Button[25], $Answer)
		Case 'B'
			$B = $Answer
			GUICtrlSetTip($Button[26], $Answer)
		Case 'C'
			$C = $Answer
			GUICtrlSetTip($Button[27], $Answer)
		Case 'D'
			$D = $Answer
			GUICtrlSetTip($Button[28], $Answer)
		Case 'E'
			$E = $Answer
			GUICtrlSetTip($Button[29], $Answer)
	EndSwitch
	GUICtrlSetData($Input, '')
EndFunc   ;==>SetVariable