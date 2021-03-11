#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>

#include <WinAPI.au3>
#include <Math.au3>
#include <Misc.au3>
#include <Array.au3>

Dim $aStack[1] = [2] ;$aStack[0] is never used
Global $Graph[1][9]

Global Const $pi = 3.1415926535897932384626433832795
#cs
	known bugs/errors:
	You cannot enter 0 on the stack. (AutoIt limitation because (0 = ''))
	trig functions seem to be wrong
#ce

#cs
	buttons to implement (in order of importance):
	=
	symbols
	constants
	''
	eval
	()
	units
#ce

Opt("GUIOnEventMode", 1)

$Form1_1 = GUICreate("Form1", 490, 621, 795, 146)
$ListView1 = GUICtrlCreateListView("", 8, 8, 473, 217)
_GUICtrlListView_AddColumn($ListView1, 'type')
_GUICtrlListView_AddColumn($ListView1, 'value', 400)
$Button1 = GUICtrlCreateButton("1", 8, 528, 33, 33)
$Button2 = GUICtrlCreateButton("2", 48, 528, 33, 33)
$Button3 = GUICtrlCreateButton("3", 88, 528, 33, 33)
$Button4 = GUICtrlCreateButton("4", 8, 488, 33, 33)
$Button5 = GUICtrlCreateButton("5", 48, 488, 33, 33)
$Button6 = GUICtrlCreateButton("6", 88, 488, 33, 33)
$Button7 = GUICtrlCreateButton("7", 8, 448, 33, 33)
$Button8 = GUICtrlCreateButton("8", 48, 448, 33, 33)
$Button9 = GUICtrlCreateButton("9", 88, 448, 33, 33)
$Button10 = GUICtrlCreateButton("0", 8, 568, 73, 33)
$Button11 = GUICtrlCreateButton(".", 88, 568, 33, 33)
$Button12 = GUICtrlCreateButton("Enter", 128, 528, 33, 73, $BS_DEFPUSHBUTTON)
$Button13 = GUICtrlCreateButton("+", 128, 408, 33, 33)
$Button14 = GUICtrlCreateButton("-", 88, 408, 33, 33)
$Button15 = GUICtrlCreateButton("*", 48, 408, 33, 33)
$Button16 = GUICtrlCreateButton("/", 8, 408, 33, 33)
$Button17 = GUICtrlCreateButton("Drop", 128, 448, 33, 33)
$Input1 = GUICtrlCreateInput("", 8, 232, 473, 21)
$Button18 = GUICtrlCreateButton("Bksp", 128, 488, 33, 33)
$Group1 = GUICtrlCreateGroup("Std", 0, 392, 169, 217)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Trig", 176, 392, 129, 137)
$Button19 = GUICtrlCreateButton("Sin", 184, 408, 33, 33)
$Button20 = GUICtrlCreateButton("Cos", 224, 408, 33, 33)
$Button21 = GUICtrlCreateButton("Tan", 264, 408, 33, 33)
$Button22 = GUICtrlCreateButton("Cot", 264, 488, 33, 33)
$Button23 = GUICtrlCreateButton("Sec", 224, 488, 33, 33)
$Button24 = GUICtrlCreateButton("Csc", 184, 488, 33, 33)
$Button25 = GUICtrlCreateButton("ASin", 184, 448, 33, 33)
$Button26 = GUICtrlCreateButton("ACos", 224, 448, 33, 33)
$Button27 = GUICtrlCreateButton("ATan", 264, 448, 33, 33)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Button28 = GUICtrlCreateButton("1/x", 184, 536, 33, 33)
$Button29 = GUICtrlCreateButton("x^y", 264, 536, 33, 33)
$Button30 = GUICtrlCreateButton("x^2", 224, 536, 33, 33)
$Button31 = GUICtrlCreateButton("Sqrt", 184, 576, 33, 33)
$Button32 = GUICtrlCreateButton("yvx", 224, 576, 33, 33)
$Button33 = GUICtrlCreateButton("n!", 264, 576, 33, 33)
$Button34 = GUICtrlCreateButton("Log", 312, 408, 33, 33)
$Button35 = GUICtrlCreateButton("e^x", 352, 448, 33, 33)
$Button36 = GUICtrlCreateButton("10^x", 312, 448, 33, 33)
$Button37 = GUICtrlCreateButton("LN", 352, 408, 33, 33)
$Button38 = GUICtrlCreateButton("Mod", 312, 528, 33, 33)
$Button39 = GUICtrlCreateButton("Abs", 352, 528, 33, 33)
$Button40 = GUICtrlCreateButton("±", 312, 568, 33, 33)
$Button42 = GUICtrlCreateButton("PI", 312, 488, 33, 33)
$Button43 = GUICtrlCreateButton("e", 352, 488, 33, 33)
;~ $Button44 = GUICtrlCreateButton('Graph', 352, 568, 33, 33)
$Radio1 = GUICtrlCreateRadio("Degrees", 16, 264, 65, 17)
$Radio2 = GUICtrlCreateRadio("Radians", 16, 288, 65, 25)
;~ $Radio3 = GUICtrlCreateRadio("Grads", 16, 320, 65, 25)
GUICtrlSetState($Radio1, $GUI_CHECKED)
GUICtrlSetState($Input1, $GUI_FOCUS)
GUISetOnEvent($GUI_EVENT_CLOSE, 'GUI_CLOSE')

GUICtrlSetOnEvent($Button12, '_PushStack')
GUICtrlSetOnEvent($Button17, '_DropStack')

GUICtrlSetOnEvent($Button1, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button2, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button3, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button4, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button5, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button6, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button7, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button8, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button8, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button9, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button10, '_OnEvent_SendNum')
GUICtrlSetOnEvent($Button11, '_OnEvent_SendNum')

GUICtrlSetOnEvent($Button13, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button14, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button15, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button16, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button19, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button20, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button21, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button22, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button23, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button24, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button25, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button26, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button27, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button28, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button29, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button30, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button31, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button32, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button33, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button34, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button35, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button36, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button37, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button38, '_OnEvent_OperatorStack')
GUICtrlSetOnEvent($Button39, '_OnEvent_OperatorStack')
;~ GUICtrlSetOnEvent($Button44, '_Graph')

GUIRegisterMsg($WM_ACTIVATEAPP, '_WM_ActivateApp')
GUIRegisterMsg($WM_COMMAND, '_WM_ValidateInput')

GUISetState(@SW_SHOW, $Form1_1)

While Sleep(50)

WEnd

Func GUI_CLOSE()
	Exit
EndFunc   ;==>GUI_CLOSE

Func _WM_ActivateApp($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	If $wParam Then
		;set the following hotkeys: enter, plus, minus, multiply, divide
		HotKeySet('{enter}', '_PushStack')
		HotKeySet('+', '_OperatorStack')
	Else
		HotKeySet('{enter}')
		HotKeySet('+')
	EndIf
EndFunc   ;==>_WM_ActivateApp

Func _WM_ValidateInput($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	Local $uMsg = _WinAPI_HiWord($wParam)
	Local $iControl = _WinAPI_LoWord($wParam)
	If $uMsg = $EN_UPDATE And $iControl = $Input1 Then
		Local $sText = GUICtrlRead($Input1)
		If StringRight($sText, 1) = '+' Then
			_OperatorStack($Button13)
		ElseIf StringRight($sText, 1) = '-' And StringLen($sText) <> 1 Then ;allow items to begin with a minus sign
			_OperatorStack($Button14)
		ElseIf StringRight($sText, 1) = '*' Then
			_OperatorStack($Button15)
		ElseIf StringRight($sText, 1) = '/' Then
			_OperatorStack($Button16)
		ElseIf StringRight($sText, 1) = '^' Then
			_OperatorStack($Button29)
		ElseIf StringRight($sText, 1) = '!' Then
			_OperatorStack($Button33)
		ElseIf StringRight($sText, 1) = '%' Then
			_OperatorStack($Button38)
		EndIf
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_ValidateInput

Func _PushStack() ;push items onto the stack
	;first parse the input control
	Local $iInput = Number(GUICtrlRead($Input1))
	If $iInput = '' Then Return ConsoleWrite('!> Error: empty or invalid input' & @CRLF)
	_ArrayAdd($aStack, $iInput)
;~ 	_ArrayDisplay($aStack)
	;clean the input
	GUICtrlSetData($Input1, '')
	;refresh the list
	_ListViewRefresh()
	GUICtrlSetState($Input1, $GUI_FOCUS)
EndFunc   ;==>_PushStack

Func _DropStack()
	;drop the selected item or the bottom item from the stack
	Local Static $hList = GUICtrlGetHandle($ListView1)
	Local $aRet = _GUICtrlListView_GetSelectedIndices($hList, True)
	Local $iStackIndex
	Local $iListIndex
	If $aRet[0] Then
		;something is selected, drop that item
		$iListIndex = $aRet[1]
	Else
		;nothing is selected, drop last item
		$iListIndex = _GUICtrlListView_GetItemCount($hList) - 1
	EndIf
	;the stack index to be dropped will always be one more than the list index
	$iStackIndex = 1 + $iListIndex
	_ArrayDelete($aStack, $iStackIndex)
	_GUICtrlListView_DeleteItem($hList, $iListIndex)
	_ListViewRefresh()
	GUICtrlSetState($Input1, $GUI_FOCUS)
EndFunc   ;==>_DropStack

Func _ListViewRefresh()
	Local Static $hList = GUICtrlGetHandle($ListView1)
	Local $iRet = _GUICtrlListView_DeleteAllItems($hList)
	If @error Or $iRet = False Then
		ConsoleWrite('!> Could not delete all items. Return code: ' & $iRet & ' @error: ' & @error & @CRLF)
	EndIf
	For $i = 1 To UBound($aStack) - 1
		_GUICtrlListView_SetItemText($hList, _GUICtrlListView_InsertItem($hList, VarGetType($aStack[$i]), -1), $aStack[$i], 1)
	Next
EndFunc   ;==>_ListViewRefresh

Func _OnEvent_OperatorStack()
	_OperatorStack(@GUI_CtrlId)
EndFunc   ;==>_OnEvent_OperatorStack

Func _OnEvent_SendNum()
	Local $sText = ControlGetText('', '', @GUI_CtrlId)
	Local $sInput = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $sInput & $sText)
	GUICtrlSetState($Input1, $GUI_FOCUS)
	Send('{end}')
EndFunc   ;==>_OnEvent_SendNum

Func _OperatorStack($GUI_CtrlId = 0)
	Switch GUICtrlRead($Input1)
		;add, mult, div, pow, fact, mod
		Case '+', '/', '*', '^', '!', '%'
			GUICtrlSetData($Input1, '')
		Case Else
			_PushStack() ;if the input has something in it, use that first
	EndSwitch
	Local $iLast = _ArrayPop($aStack)
	If $aStack = '' Then
		ConsoleWrite('!> Error: not enough arguments on stack' & @CRLF)
		;redeclare the stack, otherwise the _Array* functions fail miserably
		Global $aStack[1] = [1]
	Else
		Switch $GUI_CtrlId
			Case $Button13 ;addition
				;add the last two items on the stack
				$aStack[UBound($aStack) - 1] += $iLast
			Case $Button14 ;subtraction
				$aStack[UBound($aStack) - 1] -= $iLast
			Case $Button15 ;multiplication
				$aStack[UBound($aStack) - 1] *= $iLast
			Case $Button16 ;division
				$aStack[UBound($aStack) - 1] /= $iLast
			Case $Button29 ;power
				$aStack[UBound($aStack) - 1] = $aStack[UBound($aStack) - 1] ^ $iLast
			Case $Button30 ;x^2
				_ArrayAdd($aStack, $iLast ^ 2)
			Case $Button33 ;factorial
				_ArrayAdd($aStack, _Factorial($iLast))
			Case $Button38 ;mod
				$aStack[UBound($aStack) - 1] = Mod($aStack[UBound($aStack) - 1], $iLast)
			Case $Button32 ;root
				$aStack[UBound($aStack) - 1] = _Root($aStack[UBound($aStack) - 1], $iLast)
			Case $Button31 ;sqrt
				_ArrayAdd($aStack, Sqrt($iLast))
			Case $Button28 ;inverse
				_ArrayAdd($aStack, 1 / $iLast)
			Case $Button39 ;abs
				_ArrayAdd($aStack, Abs($iLast))
				#region trig functions
			Case $Button19 ;sin
				_ArrayAdd($aStack, Sin(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button20 ;cos
				_ArrayAdd($aStack, Sin(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button21 ;tan
				_ArrayAdd($aStack, Sin(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button25 ;asin
				_ArrayAdd($aStack, ASin(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button26 ;acos
				_ArrayAdd($aStack, ACos(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button27 ;atan
				_ArrayAdd($aStack, ATan(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button22 ;cot
				_ArrayAdd($aStack, 1 / Tan(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button23 ;sec
				_ArrayAdd($aStack, 1 / Cos(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
			Case $Button24 ;csc
				_ArrayAdd($aStack, 1 / Sin(_Iif(BitAND(GUICtrlRead($Radio1), $GUI_CHECKED) = $GUI_CHECKED, _Radian($iLast), $iLast)))
				#endregion trig functions
			Case $Button34 ;log
				_ArrayAdd($aStack, _CommonLog($iLast))
			Case $Button37 ;LN
				_ArrayAdd($aStack, Log($iLast))
			Case $Button36 ;10^x
				_ArrayAdd($aStack, 10 ^ $iLast)
			Case $Button35 ;e^x
				_ArrayAdd($aStack, Exp($iLast))
		EndSwitch
	EndIf
	_ListViewRefresh()
	GUICtrlSetState($Input1, $GUI_FOCUS)
EndFunc   ;==>_OperatorStack

Func _CommonLog($x)
	Return Log($x) / Log(10)
EndFunc   ;==>_CommonLog

Func _Root($x, $y)
	Return $x ^ (1 / $y)
EndFunc   ;==>_Root

Func _Factorial($n)
	If $n <= 0 Then Return 0
	If $n = 1 Then Return 1
	Local $iRet = 1
	For $i = 1 To $n
		$iRet *= $i
	Next
	Return $iRet
EndFunc   ;==>_Factorial
