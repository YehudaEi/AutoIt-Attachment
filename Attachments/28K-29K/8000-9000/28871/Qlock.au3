
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ComboConstants.au3>
;
Global Const $Text_en = "ITLISASTIMEACQUARTERDCTWENTYFIVEXHALFBTENFTOPASTERUNINE" & _
						"ONESIXTHREEFOURFIVETWOEIGHTELEVENSEVENTWELVETENSEOCLOCK"
						
Global Const $Text_ned = "HETKISAVIJFTIENBTZVOOROVERMEKWARTVOORSPWOVERHALFTHG……NS" & _
						 "TWEEPVCDRIEVIERVIJFZESZEVENONEGENACHTTIENELFTWAALFBFUUR"
						
Global $Char_Text[111]
Global $Char_Text_Remain[5], $Color_Chooser[6]
Global $Text_en_Split = StringSplit($Text_en, "")
Global $Text_ned_Split = StringSplit($Text_ned, "")
Global $Lang_en, $Lang_ned, $QclockTwoForm

Global $Hour_Min = @HOUR & @MIN

Global $Text_Min_Highlight[12][2] = _
	[["00", "1|2|4|5|105|106|107|108|109|110"], _
	["05", "1|2|4|5|29|30|31|32|45|46|47|48"], _
	["10", "1|2|4|5|39|40|41|45|46|47|48"], _
	["15", "1|2|4|5|12|14|15|16|17|18|19|20|45|46|47|48"], _
	["20", "1|2|4|5|23|24|25|26|27|28|45|46|47|48"], _
	["25", "1|2|4|5|23|24|25|26|27|28|29|30|31|32|45|46|47|48"], _
	["30", "1|2|4|5|34|35|36|37|45|46|47|48"], _
	["35", "1|2|4|5|23|24|25|26|27|28|29|30|31|32|43|44"], _
	["40", "1|2|4|5|23|24|25|26|27|28|43|44"], _
	["45", "1|2|4|5|12|14|15|16|17|18|19|20|43|44"], _
	["50", "1|2|4|5|39|40|41|43|44"], _
	["55", "1|2|4|5|29|30|31|32|43|44"]]
	
	Global $Text_Min_Highlight_ned[12][2] = _
	[["00", "1|2|3|5|6|108|109|110"], _
	["05", "1|2|3|5|6|8|9|10|11|41|42|43|44"], _
	["10", "1|2|3|5|6|12|13|14|15|41|42|43|44"], _
	["15", "1|2|3|5|6|29|30|31|32|33|41|42|43|44"], _
	["20", "1|2|3|5|6|12|13|14|15|45|46|47|48|34|35|36|37"], _
	["25", "1|2|3|5|6|8|9|10|11|45|46|47|48|34|35|36|37"], _
	["30", "1|2|3|5|6|45|46|47|48"], _
	["35", "1|2|3|5|6|8|9|10|11|41|42|43|44|45|46|47|48"], _
	["40", "1|2|3|5|6|12|13|14|15|41|42|43|44|45|46|47|48"], _
	["45", "1|2|3|5|6|29|30|31|32|33|34|35|36|37"], _
	["50", "1|2|3|5|6|12|13|14|15|34|35|36|37"], _
	["55", "1|2|3|5|6|8|9|10|11|34|35|36|37"]]

Global $Text_Hour_Highlight[12][2] =  _
	[["01", "56|57|58"], _
	["02", "75|76|77"], _
	["03", "62|63|64|65|66"], _
	["04", "67|68|69|70"], _
	["05", "71|72|73|74"], _
	["06", "59|60|61"], _
	["07", "89|90|91|92|93"], _
	["08", "78|79|80|81|82"], _
	["09", "52|53|54|55"], _
	["10", "100|101|102"], _
	["11", "83|84|85|86|87|88"], _
	["12", "94|95|96|97|98|99"]]
	
	Global $Text_Hour_Highlight_ned[12][2] =  _
	[["01", "52|53|54"], _
	["02", "56|57|58|59"], _
	["03", "63|64|65|66"], _
	["04", "67|68|69|70"], _
	["05", "71|72|73|74"], _
	["06", "59|60|61"], _
	["07", "78|79|80|81|82"], _
	["08", "89|90|91|92"], _
	["09", "84|85|86|87|88"], _
	["10", "93|94|95|96"], _
	["11", "97|98|99"], _
	["12", "100|101|102|103|104|105"]]
	
Global $Color_Themes[5][3] = _
	[["Black Ice Tea", 0x000000, 0x303030], _
	["Cherry Cake", 0xDC0817, 0xB80713], _
	["Vanilla Sugar", 0xC4C3C1, 0xA2A1A0], _
	["Frozen Blackberry", 0x503082, 0x6A4F93], _
	["Lime Juice", 0xA8AF0A, 0x8C9107]]

$Selected_Theme = IniRead(@TempDir & "/QLOCKTWOSettings.ini", "Theme", "Selected", 0)
Global $Text_Color_Dark = $Color_Themes[$Selected_Theme][2]
Global $Text_Color_Lit  = 0xFFFFFF
Global $Form_BK_Color   = $Color_Themes[$Selected_Theme][1]
Global $Combo_Add

$Lang = IniRead(@TempDir & "/QLOCKTWOSettings.ini", "Lang", "Selected", "en")

Func _GUICreate()
#Region ### START Koda GUI section ### Form=
$size = 40
$QclockTwoForm = GUICreate("QLOCK TWO", (13*$size), (12*$size), -1, -1)
GUISetBkColor($Form_BK_Color)
$k = 1
For $i = 1 To 10
	For $j = 1 To 11
		If $Lang = "en" Then
			If $k = 105 Then
				$Char_Text[$k] = GUICtrlCreateLabel("O'", $size * $j, $size * $i, 20, 20, $SS_CENTER)
				GUICtrlSetColor(-1, $Text_Color_Dark)
			Else
				$Char_Text[$k] = GUICtrlCreateLabel($Text_en_Split[$k], $size * $j, $size * $i, 20, 20, $SS_CENTER)
				GUICtrlSetColor(-1, $Text_Color_Dark)
			EndIf
		ElseIf $Lang = "ned" Then
			$Char_Text[$k] = GUICtrlCreateLabel($Text_ned_Split[$k], $size * $j, $size * $i, 20, 20, $SS_CENTER)
			GUICtrlSetColor(-1, $Text_Color_Dark)
		EndIf
		$k += 1
	Next
Next

$Char_Text_Remain[1] = GUICtrlCreateLabel(Chr(149), 0.5 * $Size, 0.5 * $Size, 0.5 * $Size, 1 * $Size, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Dark)
$Char_Text_Remain[2] = GUICtrlCreateLabel(Chr(149), 12 * $Size, 0.5 * $Size, 0.5 * $Size, 1 * $Size, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Dark)
$Char_Text_Remain[3] = GUICtrlCreateLabel(Chr(149), 12 * $Size, 11 * $Size, 0.5 * $Size, 1 * $Size, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Dark)
$Char_Text_Remain[4] = GUICtrlCreateLabel(Chr(149), 0.5 * $Size, 11 * $Size, 0.5 * $Size, 1 * $Size, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Dark)

$r = 1
For $w = 4 To 8
	$Color_Chooser[$r] = GUICtrlCreateLabel($r, $size * $w, $size * 11, 20, 20, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Lit)
	GUICtrlSetCursor(-1, 0)
	GUICtrlSetTip(-1, $Color_Themes[$r-1][0])
	$r += 1
Next

$Lang_en = GUICtrlCreateLabel("En", $size * 3, $size * 11, 20, 20, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Lit)
	GUICtrlSetCursor(-1, 0)
$Lang_ned = GUICtrlCreateLabel("Ned", $size * 9, $size * 11, 20, 20, $SS_CENTER)
	GUICtrlSetColor(-1, $Text_Color_Lit)
	GUICtrlSetCursor(-1, 0)

GUISetState(@SW_SHOW)
_CalibrateTime()
#EndRegion ### END Koda GUI section ###
EndFunc
_GuiCreate()
;
While 1
	If $Hour_Min <> @HOUR & @MIN Then
		_CalibrateTime()
		$Hour_Min = @HOUR & @MIN
	EndIf

	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Color_Chooser[1]
			_Change_Color(1)
		Case $Color_Chooser[2]
			_Change_Color(2)
		Case $Color_Chooser[3]
			_Change_Color(3)
		Case $Color_Chooser[4]
			_Change_Color(4)
		Case $Color_Chooser[5]
			_Change_Color(5)
		Case $Lang_en
			_Change_Lang("en")
		Case $Lang_ned
			_Change_Lang("ned")
	EndSwitch
WEnd
;
Func _CalibrateTime()
	$Get_Min = @MIN
	$Get_Hour = _Hour_Correct(@HOUR)

	If $Lang = "en" Then
		For $g = 0 To 11
			If _GetMinNumber($Get_Min) = $Text_Min_Highlight[$g][0] Then
				_Set_Remainder_Min(@MIN)
				$Text_Num_Split = StringSplit($Text_Min_Highlight[$g][1], "|")
				$Text_Hr_Split = StringSplit($Text_Hour_Highlight[$Get_Hour][1], "|")
				For $h = 1 To 110
					GUICtrlSetColor($Char_Text[$h], $Text_Color_Dark)
					For $l = 1 To $Text_Num_Split[0]
						If $Text_Num_Split[$l] = $h Then
							GUICtrlSetColor($Char_Text[$Text_Num_Split[$l]], $Text_Color_Lit)
						EndIf
					Next
					For $m = 1 To $Text_Hr_Split[0]
						If $Text_Hr_Split[$m] = $h Then
							GUICtrlSetColor($Char_Text[$Text_Hr_Split[$m]], $Text_Color_Lit)
						EndIf
					Next
				Next
				Return
			EndIf
		Next
	ElseIf $Lang = "ned" Then
		For $g = 0 To 11
			If _GetMinNumber($Get_Min) = $Text_Min_Highlight_ned[$g][0] Then
				_Set_Remainder_Min(@MIN)
				$Text_Num_Split = StringSplit($Text_Min_Highlight_ned[$g][1], "|")
				$Text_Hr_Split = StringSplit($Text_Hour_Highlight_ned[$Get_Hour][1], "|")
				For $h = 1 To 110
					GUICtrlSetColor($Char_Text[$h], $Text_Color_Dark)
					For $l = 1 To $Text_Num_Split[0]
						If $Text_Num_Split[$l] = $h Then
							GUICtrlSetColor($Char_Text[$Text_Num_Split[$l]], $Text_Color_Lit)
						EndIf
					Next
					For $m = 1 To $Text_Hr_Split[0]
						If $Text_Hr_Split[$m] = $h Then
							GUICtrlSetColor($Char_Text[$Text_Hr_Split[$m]], $Text_Color_Lit)
						EndIf
					Next
				Next
				Return
			EndIf
		Next
	EndIf
EndFunc
;
Func _Change_Color($colorNumb)
	GUISetBkColor($Color_Themes[$colorNumb-1][1])
	$Text_Color_Dark = $Color_Themes[$colorNumb-1][2]
	_CalibrateTime()
	IniWrite(@TempDir & "/QLOCKTWOSettings.ini", "Theme", "Selected", $ColorNumb-1)
EndFunc
;
Func _Change_Lang($LangNumb)
	$Lang = $LangNumb
	GUIDelete($QclockTwoForm)
	_GuiCreate()
	IniWrite(@TempDir & "/QLOCKTWOSettings.ini", "Lang", "Selected", $LangNumb)
EndFunc
;
Func _GetMinNumber($s_Number)
	Switch $s_Number
		Case 0 To 4
			Return "00"
		Case 5 To 9
			Return "05"
		Case 10 To 14
			Return "10"
		Case 15 To 19
			Return "15"
		Case 20 To 24
			Return "20"
		Case 25 To 29
			Return "25"
		Case 30 To 34
			Return "30"
		Case 35 To 39
			Return "35"
		Case 40 To 44
			Return "40"
		Case 45 To 49
			Return "45"
		Case 50 To 54
			Return "50"
		Case 55 To 59
			Return "55"
	EndSwitch
EndFunc
;
Func _Hour_Correct($s_Hour)
	Switch $s_Hour
		Case 13 to 23
			$Hour = ($s_Hour - 13)
		Case 00
			$Hour = 11
		Case Else
			$Hour = $s_Hour -1
	EndSwitch

	If $Lang = "en" Then
		If @MIN > 34 Then
			$Hour += 1
			If $Hour > 11 Then $Hour = 00
		EndIf
	ElseIf $Lang = "ned" Then
		If @MIN > 19 Then
			$Hour += 1
			If $Hour > 11 Then $Hour = 00
		EndIf
	EndIf

	Return $Hour
EndFunc
;
Func _Set_Remainder_Min($q_Min)
	Local $e_Count

	$w_Min = StringRight($q_Min, 1)
	Switch $w_Min
		Case 1, 6
			$e_Count = 1
		Case 2, 7
			$e_Count = 2
		Case 3, 8
			$e_Count = 3
		Case 4, 9
			$e_Count = 4
	EndSwitch

	For $t = 1 To 4
		GUICtrlSetColor($Char_Text_Remain[$t], $Text_Color_Dark)
	Next
	For $t = 1 To $e_Count
		GUICtrlSetColor($Char_Text_Remain[$t], $Text_Color_Lit)
	Next

EndFunc
