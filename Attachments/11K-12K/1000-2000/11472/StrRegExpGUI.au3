#include <GuiConstants.au3>
Opt("RunErrorsFatal", 0)
$IE_version = StringLeft(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Internet Explorer", "Version"), 1)
If $IE_version <> "5" And $IE_version <> "6" and $IE_version <> "7" Then $IE_version = "5"
Dim $initialDir = @ScriptDir
Global $s_Pattern = "(.*)"
Global $green = 0xAAFFD5
Global $grey = 0xD4D0C8
Global $red = 0xFF8888
Global $black = 0x000000
Global $Rtn0
Global $Rtn4
$Rtn4 = False
Readini()
GUICreate("StringRegExp Original Design GUI -by w0uter, modified Steve8tch", 550, 596, (@DesktopWidth - 550) / 2, (@DesktopHeight - 570) / 2)
GUICtrlCreateGroup("The pattern   -  $ptn", 10, 210, 530, 60)
GUICtrlCreateGroup("Output", 140, 280, 400, 280)
GUICtrlCreateGroup("       Return Flag", 10, 280, 120, 120)
GUICtrlCreateGroup("           Offset", 10, 410, 120, 50)
GUICtrlCreateGroup("@Error     @Extended", 10, 470, 120, 50)
$h_Radio_0 = GUICtrlCreateRadio("0", 60, 300, 50, 18)
If $IE_version <> "5" Then
	GUICtrlSetTip($h_Radio_0, "Returns 1 (matched) or 0 (no match)", "Return Parmeter = 0", 1, 1)
Else
	GUICtrlSetTip($h_Radio_0, "Returns 1 (matched) or 0 (no match)")
EndIf
$h_Radio_1 = GUICtrlCreateRadio("1", 60, 318, 50, 18)
If $IE_version <> "5" Then
	GUICtrlSetTip($h_Radio_1, "Return array of matches.", "Return Parmeter = 1", 1, 1)
Else
	GUICtrlSetTip($h_Radio_1, "Return array of matches.")
EndIf
$h_Radio_2 = GUICtrlCreateRadio("2", 60, 336, 50, 18)
If $IE_version <> "5" Then
	GUICtrlSetTip($h_Radio_2, "Return array of matches including the full match (Perl / PHP style)..", "Offset (Optional)", 1, 1)
Else
	GUICtrlSetTip($h_Radio_2, "Return array of matches including the full match (Perl / PHP style).")
EndIf
$h_Radio_3 = GUICtrlCreateRadio("3", 60, 354, 50, 18)
If $IE_version <> "5" Then
	GUICtrlSetTip($h_Radio_3, "Return array of global matches.", "Return Parmeter = 3", 1, 1)
Else
	GUICtrlSetTip($h_Radio_3, "Return array of global matches.")
EndIf
$h_Radio_4 = GUICtrlCreateRadio("4", 60, 372, 50, 18)
If $IE_version <> "5" Then
	GUICtrlSetTip($h_Radio_4, "Return an array of arrays containing global matches including the full match (Perl / PHP style).", "Return Parmeter = 4", 1, 1)
Else
	GUICtrlSetTip($h_Radio_4, "Return an array of arrays containing global matches including the full match (Perl / PHP style).")
EndIf
GUICtrlSetState($h_Radio_1, $GUI_CHECKED)

$h_tab = GUICtrlCreateTab(10, 10, 530, 190)
$h_tabitem1 = GUICtrlCreateTabItem("Copy and Paste the text to check - $str")
$h_In1 = GUICtrlCreateEdit("", 20, 40, 510, 150, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
GUICtrlSetBkColor($h_In1, 0x00FFFF)
$h_tabitem2 = GUICtrlCreateTabItem("Load text from File")
$h_Brwse = GUICtrlCreateButton("Browse for file", 20, 40, 100, 20)
$h_fileIn = GUICtrlCreateEdit("", 130, 40, 400, 20, BitOR($ES_WANTRETURN, $WS_HSCROLL, $ES_AUTOHSCROLL))
$h_In2 = GUICtrlCreateEdit("", 20, 70, 510, 120, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
GUICtrlSetBkColor($h_In2, 0x00FFFF)
GUICtrlCreateTabItem("");
$h_Out = GUICtrlCreateEdit("", 150, 296, 380, 262, BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL))
GUICtrlSetBkColor($h_Out, 0x00FFFF)
$h_Pattern = GUICtrlCreateCombo("", 70, 230, 430, 30)
GUICtrlSetFont($h_Pattern, 14)
GUICtrlSetData($h_Pattern, $s_Pattern, "(.*)")
$h_Pattern_add = GUICtrlCreateButton("Add", 504, 225, 30, 18)
$h_Pattern_del = GUICtrlCreateButton("Del", 504, 245, 30, 18)
$h_test = GUICtrlCreateButton("Test", 20, 235, 40, 20,$BS_DEFPUSHBUTTON )
$offset = GUICtrlCreateInput("1", 40, 430, 60, 20)
If $IE_version <> "5" Then
	GUICtrlSetTip($offset, "[optional] The string position to start the match (starts at 1) The default is 1.", "Return Parmeter = 2", 1, 1)
Else
	GUICtrlSetTip($offset, "[optional] The string position to start the match (starts at 1) The default is 1.")
EndIf
$h_Err = GUICtrlCreateInput("", 20, 490, 40, 20, $ES_READONLY)
$h_Ext = GUICtrlCreateInput("", 70, 490, 50, 20, $ES_READONLY)
$h_Help = GUICtrlCreateButton("HELP", 75, 530, 55, 30)
$h_Exit = GUICtrlCreateButton("EXIT", 10, 530, 55, 30)
$h_time = GUICtrlCreateLabel("", 3, 573, 142, 20, $SS_SUNKEN)
$h_status = GUICtrlCreateLabel("", 150, 573, 395, 20, $SS_SUNKEN)
$v_Reg_Old = 0
Global $h_In = $h_In1
GUISetState()
While 1
	$msg = GUIGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $h_test
			_Valid()
		Case $msg = $h_Exit
			Exit
		Case $msg = $h_Brwse
			$filepath = FileOpenDialog("Select text file to test", $initialDir, "Text files (*.*)", 1)
			$initialDir = StringTrimRight($filepath, StringInStr($filepath, "\", "-1"))
			GUICtrlSetData($h_status,"Loading file..")
			GUICtrlSetBkColor($h_status,$green)
			GUICtrlSetData($h_fileIn, $filepath)
			$str2 = FileRead($filepath)
			GUICtrlSetData($h_status,"File loaded... updating display")
			GUICtrlSetData($h_In2, $str2)
			GUICtrlSetData($h_status,"")
			GUICtrlSetBkColor($h_status,$grey)
		Case $msg = $h_tab
			If GUICtrlRead($h_tab) = 0 Then
				$h_In = $h_In1
			Else
				$h_In = $h_In2
			EndIf
		Case $msg = $h_Pattern_add
			Pattern_Add()
			
		Case $msg = $h_Pattern_del
			Pattern_del()
			
		Case $msg = $h_Help
			$helppath = StringLeft(@AutoItExe, StringInStr(@AutoItExe, "\", 0, -1))
			Run($helppath & "Autoit3Help.exe StringRegExp")
			If @error = 1 Then MsgBox(0, "error", "Cannot fing help file - sorry")
		Case Else
			;;
	EndSelect
WEnd

Func _Valid()
	GUICtrlSetData($h_Out, "")
	GUICtrlSetData($h_status,"Performing test..")
	GUICtrlSetBkColor($h_status,$green)
	;set up timer
	$h_timer = TimerInit()
	$v_Reg = StringRegExp(GUICtrlRead($h_In), GUICtrlRead($h_Pattern), _Rtn(), _Offset())
	Dim $v_EE[2] = [@error, @extended]
	$time = TimerDiff($h_timer)
	GUICtrlSetData($h_time, $time & "  ms")
	GUICtrlSetData($h_Err, $v_EE[0])
	GUICtrlSetData($h_Ext, $v_EE[1])
	Select
		Case $v_EE[0] = 0
			GUICtrlSetData($h_status,"Valid pattern - updating display.   Please wait....")
			GUICtrlSetBkColor($h_status,$green)
		Case $v_EE[0] = 1
			GUICtrlSetData($h_status,"Array is invalid. No matches")
			GUICtrlSetBkColor($h_status,$red)
		Case $v_EE[0] = 2
			GUICtrlSetData($h_status,"Bad pattern, (array is invalid). @Extended = offset of error in pattern.")
			GUICtrlSetBkColor($h_status,$red)
	EndSelect
	If $v_EE[0] = 0 Then		
		$h_output = ""
		$x = UBound($v_Reg)
		If $Rtn4 Then
			$y = UBound($v_Reg[0])
			$x *= $y
		EndIf
		$s_lgth = StringLen(String($x))
		If $Rtn4 Then
			$counter = 0
			If UBound($v_Reg) Then
				For $i = 0 To UBound($v_Reg) - 1
					$v_Reg_Rtn4 = $v_Reg[$i]
					For $j = 0 To UBound($v_Reg_Rtn4) - 1
						$h_output &= StringFormat("%0" & $s_lgth & "i", $counter) & ' => ' & $v_Reg_Rtn4[$j] & @CRLF
						$counter += 1
					Next
					$h_output &= @CRLF
				Next
				GUICtrlSetData($h_Out, $h_output)
				GUICtrlSetData($h_status,"Complete")
			EndIf
		Elseif $Rtn0 Then
			$h_output &= StringFormat("%0" & $s_lgth & "i", "0") & ' => ' & $v_Reg & @CRLF
			GUICtrlSetData($h_Out, $h_output)
			GUICtrlSetData($h_status,"Complete")
		Else
			If UBound($v_Reg) Then
				For $i = 0 To UBound($v_Reg) - 1
					$h_output &= StringFormat("%0" & $s_lgth & "i", $i) & ' => ' & $v_Reg[$i] & @CRLF
				Next
				GUICtrlSetData($h_Out, $h_output)
				GUICtrlSetData($h_status,"Complete")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>_Valid
Func _Rtn()
	$Rtn4 = False
	$Rtn0 = False
	Switch $GUI_CHECKED
		Case GUICtrlRead($h_Radio_0)
			$Rtn0 = True
			Return 0
		Case GUICtrlRead($h_Radio_1)
			Return 1
		Case GUICtrlRead($h_Radio_2)
			Return 2
		Case GUICtrlRead($h_Radio_3)
			Return 3
		Case GUICtrlRead($h_Radio_4)
			$Rtn4 = True
			Return 4
	EndSwitch
EndFunc   ;==>_Rtn
Func _Offset()
	Local $x
	$x = Int(GUICtrlRead($offset))
	If @error Then 
		Return 1
	Else
		Return $x
	EndIf
EndFunc   ;==>_Offset
Func Readini()
	If FileExists(@ScriptDir & "\StringRegExpGUIPattern.ini") = 0 Then
		$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 1)
		FileWriteLine($h_x, "[do not delete the file - Patterns are listed below]")
		FileWriteLine($h_x, "(.*)##~##")
		FileClose($h_x)
	Else
		$s_Pattern = FileRead(@ScriptDir & "\StringRegExpGUIPattern.ini")
		$s_Pattern = StringTrimLeft($s_Pattern, StringInStr($s_Pattern, @CRLF) + 1)
		$s_Pattern = StringReplace($s_Pattern, "##~##" & @CRLF, "|")
	EndIf
EndFunc   ;==>Readini
Func Pattern_del()
	$s_ini = FileRead(@ScriptDir & "\StringRegExpGUIPattern.ini")
	$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 2)
	If GUICtrlRead($h_Pattern) = "" Then
		$s_ini = StringReplace($s_ini, "##~##" & @CRLF & "##~##", "##~##")
		$s_ini = StringReplace($s_ini, @CRLF & @CRLF, @CRLF)
	Else
		$s_ini = StringReplace($s_ini, GUICtrlRead($h_Pattern) & "##~##", "")
		$s_ini = StringReplace($s_ini, @CRLF & @CRLF, @CRLF)
	EndIf
	FileWrite($h_x, $s_ini)
	FileClose($h_x)
	Readini()
	GUICtrlSetData($h_Pattern, "|" & $s_Pattern, "(.*)")
EndFunc   ;==>Pattern_del
Func Pattern_Add()
	$h_x = FileOpen(@ScriptDir & "\StringRegExpGUIPattern.ini", 1)
	FileWriteLine($h_x, GUICtrlRead($h_Pattern) & "##~##")
	FileClose($h_x)
	Readini()
	GUICtrlSetData($h_Pattern, "|" & $s_Pattern, GUICtrlRead($h_Pattern))
EndFunc   ;==>Pattern_Add
