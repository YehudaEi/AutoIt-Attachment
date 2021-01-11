#NoTrayIcon
#include <GUIConstants.au3>
#include <Misc.au3>
#include <Color.au3>

Global Const $INI = (@ScriptDir & "\Colors.ini")
Global $Color1 = IniRead($INI, "Colors", "1", "0xFF0000")
Global $Color2 = IniRead($INI, "Colors", "2", "0x00FF00")
Global $Color3 = IniRead($INI, "Colors", "3", "0xFF0000")
Global $Color4 = IniRead($INI, "Colors", "4", "0x00FF00")
Global $Color5 = IniRead($INI, "Colors", "5", "0x0000FF")

$Dummy = GUICreate("Magic Colors", 1, 1, @DesktopWidth, @DesktopHeight)
$Window = GUICreate("Magic Colors by CoePSX", 200, 460, -1, -1, BitOr($WS_CAPTION, $WS_SYSMENU), $WS_EX_TOOLWINDOW, $Dummy)
GUICtrlCreateGroup("Category", 10, 10, 180, 75)
$ForumRadio = GUICtrlCreateRadio("Forum Post", 15, 25, 70, 15)
$OrkutRadio = GUICtrlCreateRadio("Orkut Scrap", 100, 25, 85, 15)
$MSNRadio = GUICtrlCreateRadio("MSN Text", 15, 45, 70, 15)
$MSNRadio2 = GUICtrlCreateRadio("MSN Back", 100, 45, 75, 15)
$HTMLRadio = GUICtrlCreateRadio("HTML Text", 15, 65, 75, 15)
$HTMLRadio2 = GUICtrlCreateRadio("HTML Back", 100, 65, 80, 15)
GUICtrlSetState($ForumRadio, $GUI_CHECKED)

;2 colors gradient
GUICtrlCreateGroup("Colors", 10, 90, 180, 55)
GUICtrlCreateLabel("", 15, 105, 150, 15, BitOr($SS_CENTER, $WS_BORDER))
GUICtrlSetState(-1, $GUI_DISABLE)
$ColorButton1 = GUICtrlCreateLabel("1", 16, 106, 15, 13, $SS_CENTER)
Dim $ColorExample[60]
For $i = 0 To 59
	$ColorExample[$i] = GUICtrlCreateLabel("", 30+$i*2, 106, 2, 13)
Next
$ColorButton2 = GUICtrlCreateLabel("2", 149, 106, 15, 13, $SS_CENTER)
GUICtrlSetCursor($ColorButton1, 0)
GUICtrlSetCursor($ColorButton2, 0)
$2ColorsRadio = GUICtrlCreateRadio("", 170, 105, 15, 15)
GUICtrlSetState($2ColorsRadio, $GUI_CHECKED)

;3 colors gradient
GUICtrlCreateLabel("", 15, 125, 150, 15, BitOr($SS_CENTER, $WS_BORDER))
GUICtrlSetState(-1, $GUI_DISABLE)
$ColorButton3 = GUICtrlCreateLabel("1", 16, 126, 15, 13, $SS_CENTER)
Dim $ColorExample2[26]
For $i = 0 To 25
	$ColorExample2[$i] = GUICtrlCreateLabel("", 31+$i*2, 126, 2, 13)
Next
$ColorButton4 = GUICtrlCreateLabel("2", 83, 126, 15, 13, $SS_CENTER)
Dim $ColorExample3[26]
For $i = 0 To 25
	$ColorExample3[$i] = GUICtrlCreateLabel("", 98+$i*2, 126, 2, 13)
Next
$ColorButton5 = GUICtrlCreateLabel("3", 149, 126, 15, 13, $SS_CENTER)
GUICtrlSetCursor($ColorButton3, 0)
GUICtrlSetCursor($ColorButton4, 0)
$3ColorsRadio = GUICtrlCreateRadio("", 170, 125, 15, 15)

GUICtrlCreateGroup("Settings", 10, 150, 180, 35)
$BoldCheck = GUICtrlCreateCheckbox("Bold", 15, 165, 50, 15)
$ItalicCheck = GUICtrlCreateCheckbox("Italic", 68, 165, 45, 15)
$UnderlinedCheck = GUICtrlCreateCheckbox("Underlined", 115, 165, 70, 15)

GUICtrlCreateGroup("Initial Text", 10, 190, 180, 100)
$TextBox = GUICtrlCreateInput("", 15, 205, 170, 80, BitOR($WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetFont($TextBox, 8)

GUICtrlCreateGroup("Final Text", 10, 295, 180, 100)
$FinalBox = GUICtrlCreateInput("", 15, 310, 170, 80, BitOR($WS_VSCROLL, $ES_MULTILINE))
GUICtrlSetFont($FinalBox, 8)

$OK = GUICtrlCreateButton("Color it!", 10, 400, 180, 25)
$Copy = GUICtrlCreateButton("Copy", 10, 425, 60, 25)
$About = GUICtrlCreateButton("About", 70, 425, 60, 25)
$Exit = GUICtrlCreateButton("Exit", 130, 425, 60, 25)

UpdateExample()
UpdateExample2()
GUISetState(@SW_SHOW, $Dummy)
GUISetState(@SW_SHOW, $Window)

While 1
	If WinActive($Dummy, "") Then WinActivate($Window, "")
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Exit
			Exit
		Case $ColorButton1
			$Color1 = _ChooseColor(2, $Color1, 2)
			If Not @error Then UpdateExample()
		Case $ColorButton2
			$Color2 = _ChooseColor(2, $Color2, 2)
			If Not @error Then UpdateExample()
		Case $ColorButton3
			$Color3 = _ChooseColor(2, $Color3, 2)
			If Not @error Then UpdateExample2()
		Case $ColorButton4
			$Color4 = _ChooseColor(2, $Color4, 2)
			If Not @error Then UpdateExample2()
		Case $ColorButton5
			$Color5 = _ChooseColor(2, $Color5, 2)
			If Not @error Then UpdateExample2()
		Case $About
			MsgBox(64, "Magic Colors", "-= Magic Colors =-" & @CRLF & @CRLF & "2006 - CoePSX")
		Case $Copy
			ClipPut(GUICtrlRead($FinalBox))
		Case $OK
			$PreTags = ""
			$PosTags = ""
			If GUICtrlRead($OrkutRadio) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeOrkut(GUICtrlRead($TextBox)))
			ElseIf GUICtrlRead($MSNRadio) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeMSN(GUICtrlRead($TextBox)))
			ElseIf GUICtrlRead($MSNRadio2) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeMSN2(GUICtrlRead($TextBox)))
			ElseIf GUICtrlRead($ForumRadio) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeForum(GUICtrlRead($TextBox)))
			ElseIf GUICtrlRead($HTMLRadio) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeHTML(GUICtrlRead($TextBox)))
			ElseIf GUICtrlRead($HTMLRadio2) = 1 Then
				GUICtrlSetData($FinalBox, ColorizeHTML2(GUICtrlRead($TextBox)))
			EndIf
	EndSwitch
WEnd
Exit

Func ColorizeMSN($Message)
	Local $Array = StringSplit($Message, "")
	Local $Final = ""
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "·#"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "·&"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "·@"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($2ColorsRadio) = 1 Then
		Local $Color = ColorGradient($Color1, $Color2, $Array[0]+1)
	Else
		Local $Color = TripleColorGradient($Color3, $Color4, $Color5, $Array[0]+1)
	EndIf
	For $i = 1 To $Array[0]
		If $Array[$i] <> " " And $Array[$i] <> @CR And $Array[$i] <> @LF Then
			$iRed1 = _ColorGetRed($Color[$i])
			$iGreen1 = _ColorGetGreen($Color[$i])
			$iBlue1 = _ColorGetBlue($Color[$i])
			While StringLen($iRed1) < 3 
				$iRed1 = 0 & $iRed1
			WEnd
			While StringLen($iGreen1) < 3
				$iGreen1 = 0 & $iGreen1
			WEnd
			While StringLen($iBlue1) < 3
				$iBlue1 = 0 & $iBlue1
			WEnd
			$Final &= "·$(" & $iRed1 & "," & $iGreen1 & "," & $iBlue1 & ")" & $Array[$i]
		Else
			$Final &= $Array[$i]
		EndIf
	Next
	Return $PreTags & $Final & $PosTags
EndFunc
Func ColorizeMSN2($Message)
	Local $Array = StringSplit($Message, "")
	Local $Final = ""
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "·#"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "·&"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "·@"
		$PosTags &= "·0"
	EndIf
	If GUICtrlRead($2ColorsRadio) = 1 Then
		Local $Color = ColorGradient($Color1, $Color2, $Array[0]+1)
	Else
		Local $Color = TripleColorGradient($Color3, $Color4, $Color5, $Array[0]+1)
	EndIf
	For $i = 1 To $Array[0]
		$iRed1 = _ColorGetRed($Color[$i])
		$iGreen1 = _ColorGetGreen($Color[$i])
		$iBlue1 = _ColorGetBlue($Color[$i])
		While StringLen($iRed1) < 3 
			$iRed1 = 0 & $iRed1
		WEnd
		While StringLen($iGreen1) < 3
			$iGreen1 = 0 & $iGreen1
		WEnd
		While StringLen($iBlue1) < 3
			$iBlue1 = 0 & $iBlue1
		WEnd
		$Final &= "·$,(" & $iRed1 & "," & $iGreen1 & "," & $iBlue1 & ")" & $Array[$i]
	Next
	Return $PreTags & $Final & $PosTags
EndFunc
Func ColorizeForum($Message)
	Local $Array = StringSplit($Message, "")
	Local $Final = ""
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "[b]"
		$PosTags &= "[/b]"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "[i]"
		$PosTags &= "[/i]"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "[u]"
		$PosTags &= "[/u]"
	EndIf
	If GUICtrlRead($2ColorsRadio) = 1 Then
		Local $Color = ColorGradient($Color1, $Color2, $Array[0]+1)
	Else
		Local $Color = TripleColorGradient($Color3, $Color4, $Color5, $Array[0]+1)
	EndIf
	For $i = 1 To $Array[0]
		If $Array[$i] <> " " And $Array[$i] <> @CR And $Array[$i] <> @LF Then
			$Final &= "[color=#" & Hex($Color[$i], 6) & "]" & $Array[$i] & "[/color]"
		Else
			$Final &= $Array[$i]
		EndIf
	Next
	Return $PreTags & $Final & $PosTags
EndFunc
Func ColorizeOrkut($Message)
	Dim $Color[18]
	$Color[0] = "aqua"
	$Color[1] = "blue"
	$Color[2] = "navy"
	$Color[3] = "purple"
	$Color[4] = "violet"
	$Color[5] = "pink"
	$Color[6] = "yellow"
	$Color[7] = "gold"
	$Color[8] = "orange"
	$Color[9] = "red"
	$Color[10] = "orange"
	$Color[11] = "pink"
	$Color[12] = "silver"
	$Color[13] = "gray"
	$Color[14] = "maroon"
	$Color[15] = "green"
	$Color[16] = "teal"
	$Color[17] = "lime"
	$Array = StringSplit($Message, "")
	$Final = ""
	$NowColor = ""
	$iColorInt = 0
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "[b]"
		$PosTags &= "[/b]"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "[i]"
		$PosTags &= "[/i]"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "[u]"
		$PosTags &= "[/u]"
	EndIf
	For $i = 1 To $Array[0]
		If $Array[$i] <> " " And $Array[$i] <> @CR And $Array[$i] <> @LF Then
			$NowColor = $Color[Mod($iColorInt, 18)]
			$Final &= "[" & $NowColor & "]" & $Array[$i]
			$iColorInt += 1
		Else
			$Final &= $Array[$i]
		EndIf
	Next
	$Final &= "[/" & $NowColor & "]"
	Return $PreTags & $Final & $PosTags
EndFunc
Func ColorizeHTML($Message)
	Local $Array = StringSplit($Message, "")
	Local $Final = ""
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "<b>"
		$PosTags &= "</b>"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "<i>"
		$PosTags &= "</i>"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "<u>"
		$PosTags &= "</u>"
	EndIf
	If GUICtrlRead($2ColorsRadio) = 1 Then
		Local $Color = ColorGradient($Color1, $Color2, $Array[0]+1)
	Else
		Local $Color = TripleColorGradient($Color3, $Color4, $Color5, $Array[0]+1)
	EndIf
	For $i = 1 To $Array[0]
		If $Array[$i] <> " " And $Array[$i] <> @CR And $Array[$i] <> @LF Then
			$Final &= "<font style=""color:#" & Hex($Color[$i], 6) & """>" & $Array[$i]
		Else
			$Final &= $Array[$i]
		EndIf
	Next
	$Final &= "</font>"
	Return $PreTags & $Final & $PosTags
EndFunc	
Func ColorizeHTML2($Message)
	Local $Array = StringSplit($Message, "")
	Local $Final = ""
	Local $PreTags = ""
	Local $PreTags = ""
	If GUICtrlRead($BoldCheck) = 1 Then
		$PreTags &= "<b>"
		$PosTags &= "</b>"
	EndIf
	If GUICtrlRead($ItalicCheck) = 1 Then
		$PreTags &= "<i>"
		$PosTags &= "</i>"
	EndIf
	If GUICtrlRead($UnderlinedCheck) = 1 Then
		$PreTags &= "<u>"
		$PosTags &= "</u>"
	EndIf
	If GUICtrlRead($2ColorsRadio) = 1 Then
		Local $Color = ColorGradient($Color1, $Color2, $Array[0]+1)
	Else
		Local $Color = TripleColorGradient($Color3, $Color4, $Color5, $Array[0]+1)
	EndIf
	For $i = 1 To $Array[0]
		If $Array[$i] <> " " Then
			$Final &= "<font style=""background:#" & Hex($Color[$i], 6) & """>" & $Array[$i]
		Else
			$Final &= "<font style=""background:#" & Hex($Color[$i], 6) & """>&nbsp;"
		EndIf
	Next
	$Final &= "</font>"
	Return $PreTags & $Final & $PosTags
EndFunc	
Func UpdateExample()
	Local $Color = ColorGradient($Color1, $Color2, 60)
	GUICtrlSetBkColor($ColorButton1, $Color1)
	For $i = 0 To 59
		GUICtrlSetBkColor($ColorExample[$i], $Color[$i])
	Next
	GUICtrlSetBkColor($ColorButton2, $Color2)
	IniWrite($INI, "Colors", "1", $Color1)
	IniWrite($INI, "Colors", "2", $Color2)
EndFunc
Func UpdateExample2()
	Local $Color = ColorGradient($Color3, $Color4, 26)
	GUICtrlSetBkColor($ColorButton3, $Color3)
	For $i = 0 To 25
		GUICtrlSetBkColor($ColorExample2[$i], $Color[$i])
	Next
	GUICtrlSetBkColor($ColorButton4, $Color4)
	$Color = ColorGradient($Color4, $Color5, 26)
	For $i = 0 To 25
		GUICtrlSetBkColor($ColorExample3[$i], $Color[$i])
	Next
	GUICtrlSetBkColor($ColorButton5, $Color5)
	IniWrite($INI, "Colors", "3", $Color3)
	IniWrite($INI, "Colors", "4", $Color4)
	IniWrite($INI, "Colors", "5", $Color5)
EndFunc
Func TripleColorGradient($hFirstColor, $hSecondColor, $hThirdColor, $iReturnSize)
	Local $aColorArray = ColorGradient($hFirstColor, $hSecondColor, ($iReturnSize/2)+1)
	Local $aGradient = ColorGradient($hSecondColor, $hThirdColor, ($iReturnSize/2)+1)
	For $i = 0 To $iReturnSize/2
		ReDim $aColorArray[UBound($aColorArray)+1]
		$aColorArray[UBound($aColorArray)-2] = $aGradient[$i]
	Next
	Return $aColorArray
EndFunc
Func ColorGradient($hInitialColor, $hFinalColor, $iReturnSize)
	$hInitialColor = Hex($hInitialColor, 6)
	$hFinalColor = Hex($hFinalColor, 6)
	
	Local $iRed1 = Dec (StringLeft($hInitialColor, 2))
	Local $iGreen1 = Dec (StringMid($hInitialColor, 3, 2))
	Local $iBlue1 = Dec (StringMid($hInitialColor, 5, 2))
	
	Local $iRed2 = Dec (StringLeft($hFinalColor, 2))
	Local $iGreen2 = Dec (StringMid($hFinalColor, 3, 2))
	Local $iBlue2 = Dec (StringMid($hFinalColor, 5, 2))
	
	Local $iPlusRed = ($iRed2-$iRed1)/($iReturnSize-1)
	Local $iPlusBlue = ($iBlue2-$iBlue1)/($iReturnSize-1)
	Local $iPlusGreen = ($iGreen2-$iGreen1)/($iReturnSize-1)
	
	Dim $iColorArray[$iReturnSize+1]
	For $i = 0 To $iReturnSize
		$iNowRed = Floor($iRed1 + ($iPlusRed*$i))
		$iNowBlue = Floor($iBlue1 + ($iPlusBlue*$i))
		$iNowGreen = Floor($iGreen1 + ($iPlusGreen*$i))
		$iColorArray[$i] = Dec (Hex($iNowRed, 2) & Hex($iNowGreen, 2) & Hex($iNowBlue, 2))
	Next
	Return ($iColorArray)
EndFunc
Func RandomColor($hMinColor = 0x000000, $hMaxColor = 0xFFFFFF)
	$hMinColor = Hex($hMinColor, 6)
	$hMaxColor = Hex($hMaxColor, 6)
	
	Local $iRed1 = Dec (StringLeft($hMinColor, 2))
	Local $iGreen1 = Dec (StringMid($hMinColor, 3, 2))
	Local $iBlue1 = Dec (StringMid($hMinColor, 5, 2))
	
	Local $iRed2 = Dec (StringLeft($hMaxColor, 2))
	Local $iGreen2 = Dec (StringMid($hMaxColor, 3, 2))
	Local $iBlue2 = Dec (StringMid($hMaxColor, 5, 2))
	
	Local $iRndRed = Random($iRed1, $iRed2, 1)
	Local $iRndGreen = Random($iGreen1, $iGreen2, 1)
	Local $iRndBlue = Random($iBlue1, $iBlue2, 1)
	
	Return Dec (Hex($iRndRed, 2) & Hex($iRndGreen, 2) & Hex($iRndBlue, 2))
EndFunc