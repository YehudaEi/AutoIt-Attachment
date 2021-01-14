#include <GUIConstants.au3>
; == GUI generated with Koda ==
$gui = GUICreate("My Command Line", 338, 192, 192, 125)
$txt = GUICtrlCreateEdit("", 0, 0, 337, 161, $ES_READONLY)
;~ GUICtrlSetData($txt, "> Welcome to my command line!" &@CRLF)
$cLine = GUICtrlCreateInput("clear", 0, 168, 257, 21)
$Execute = GUICtrlCreateButton("Execute", 264, 168, 74, 22, $BS_DEFPUSHBUTTON)
GUISetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $msg = $Execute
			$string = StringSplit(GuiCtrlRead($cLine),Chr(58))
			$cmd = $string[1]
			If UBound($string) > 2 Then
				$pline = $string[2]
			Else
				$pline = ""
			EndIf
			$params = StringSplit ($pline, Chr(59))
			Switch $cmd
				Case 'echo'
					_ConsoleWrite ($pline)
				Case 'clear'
					GUICtrlSetData($txt, "")
				Case 'popup'
					MsgBox (0, _Param('title'), _Param('text'))
			EndSwitch
			GUICtrlSetData ($cLine, "")
	EndSelect
WEnd


Func _ConsoleWrite($text)
	GUICtrlSetData($txt,$text & @crlf,GUICtrlRead($txt))
EndFunc
Func _TrimSpaces(ByRef $parameter)
	Local $string
	$string = StringSplit($parameter, "")
	If $string[1] = Chr(32) then
		$string = StringtrimLeft($parameter,1)
		Return $string
	Else
		Return $parameter
	EndIf
EndFunc
Func _Param($sVar, $iVarType=0) ; it's almost exactly the same as _Get from Web.au3!
	Local $varstring, $num, $vars, $var_array
	$varstring = $pline
	If Not StringInStr($varstring, $sVar&"=") Then Return ""
	$num = __StringFindOccurances($varstring, "=")
	Local $vars[$num+1]
	$vars = StringSplit ($varstring, ";")
	For $i=1 To $vars[0]
		If $iVarType Then
			If $vars[$i] = $sVar Then Return True
		Else
			$var_array = StringSplit ($vars[$i], "=")
			If $var_array[0] < 2 Then Return "error"
			If $var_array[1] = $sVar Then Return $var_array[2]
		EndIf
	Next
	If $iVarType Then Return False
	Return True
EndFunc
Func __StringFindOccurances($sStr1, $sStr2)
	For $i = 1 to StringLen($sStr1)
		If not StringInStr($sStr1, $sStr2, 1, $i) Then ExitLoop
	Next
	Return $i
EndFunc