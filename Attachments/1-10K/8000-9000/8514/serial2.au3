; Serialcode formatteren
; (c) Alex van Herwijnen

#Include <GUIConstants.au3>
AdlibEnable("FormatSerial")
;~ #NoTrayIcon
$myGui = GUICreate("", 350, 50, -1, -1, $WS_POPUP)
GUISetBkColor(0x4E6FD6)
_GuiRoundCorners($myGui, 0, 0, 50, 50)

$input1 = GUICtrlCreateInput("", 25,15,300, -1, $ES_UPPERCASE)
GUICtrlSetLimit(-1, 29);
GUICtrlSetFont(-1, 10, 400, 0, "Lucida Console")
GUISetState(@SW_SHOW)

While 1
	$msg = GUIGetMsg()	
	Select
		Case $msg = $GUI_EVENT_CLOSE
			ExitLoop
	EndSelect
	Sleep(1)
WEnd

$enteredSerial = "";
Func FormatSerial()
	Global $input1, $enteredSerial
	$serial = StringUpper(GUICtrlRead($input1))
	If $enteredSerial <> $serial Then
		$enteredSerial = $serial
		$serial = StringUpper(GUICtrlRead($input1))
		$serial = StringReplace($serial, "--", "-")
		$serial = StringReplace($serial, " ", "")
		$serial2 = $serial
		If (StringLen($serial) = 6 OR StringLen($serial) = 12 OR StringLen($serial) = 18 OR StringLen($serial) = 24) AND StringRight($serial, 1) <> "-" Then
			$serial2 = StripTags(StringLower($serial2))
			$serial2 = StringReplace($serial, "-", "")
			$serial2 = StringLeft($serial, StringLen($serial) -1) & "-" & StringRight($serial, 1)
			GUICtrlSetData($input1, StringUpper($serial2))
		EndIf
		
		If StringLen($serial) = 29 OR StringLen(StringReplace($serial, "-", "")) = 25 Then
			FormatSerial2()
		EndIf
	EndIf
EndFunc


Func FormatSerial2()
	Global $input1
	$serial = StringUpper(StringLeft(GUICtrlRead($input1), 29))
	$serial = StringReplace($serial, "-", "")
	$serial = StringReplace($serial, " ", "")
	
	$serialPart1 = StringLeft($serial, 5)
	$serial = StringTrimLeft($serial, 5)
	
	$serialPart2 = StringLeft($serial, 5)
	$serial = StringTrimLeft($serial, 5)
	
	$serialPart3 = StringLeft($serial, 5)
	$serial = StringTrimLeft($serial, 5)
	
	$serialPart4 = StringLeft($serial, 5)
	$serial = StringTrimLeft($serial, 5)
	
	$serialPart5 = StringLeft($serial, 5)
	$serial = StringTrimLeft($serial, 5)
	
	$serial2 = $serialPart1 & "-" & $serialPart2 & "-" & $serialPart3 & "-" &$serialPart4 & "-" & $serialPart5
	$serial2 = StripTags(StringLower($serial2))
	GUICtrlSetData($input1, StringUpper($serial2))
EndFunc

Func StripTags($invoer)
	$denyString = "`~!@#$%^&*()_+=[]}{\';:|/.,?><áàäâëéèêîïíìöôóòúùûüÿý"
	
	For $i = 0 To StringLen($denyString) - 1
		$invoer = StringReplace($invoer, StringLeft($denyString, 1), "")
		$denyString = StringTrimLeft($denyString, 1)
	Next
	return $invoer
EndFunc

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3)
   Dim $pos, $ret, $ret2
   $pos = WinGetPos($h_win)
   $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3, "long", $i_y3)
   If $ret[0] Then
      $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
      If $ret2[0] Then
         Return 1
      Else
         Return 0
      EndIf
   Else
      Return 0
   EndIf
EndFunc  ;==>_GuiRoundCorners