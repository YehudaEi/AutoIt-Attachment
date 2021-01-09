#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <GuiEdit.au3>

#Region Vars
Dim $Last, $Last2, $L[27]
#EndRegion

$Form1 = GUICreate("BB Color Code Generator", 448, 535, 234, 140)
$Group1 = GUICtrlCreateGroup("From", 6, 6, 134, 114)
$Input1 = GUICtrlCreateInput("0", 51, 23, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label1 = GUICtrlCreateLabel("Red:", 15, 26, 27, 17)
$Label2 = GUICtrlCreateLabel("Green:", 12, 60, 36, 17)
$Input2 = GUICtrlCreateInput("0", 51, 56, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label3 = GUICtrlCreateLabel("Blue:", 15, 93, 28, 17)
$Input3 = GUICtrlCreateInput("0", 51, 89, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label4 = GUICtrlCreateLabel("", 93, 84, 28, 27)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("To", 159, 6, 134, 114)
$Input4 = GUICtrlCreateInput("0", 204, 23, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label5 = GUICtrlCreateLabel("Red:", 168, 26, 27, 17)
$Label6 = GUICtrlCreateLabel("Green:", 165, 60, 36, 17)
$Input5 = GUICtrlCreateInput("0", 204, 56, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label7 = GUICtrlCreateLabel("Blue:", 168, 93, 28, 17)
$Input6 = GUICtrlCreateInput("0", 204, 89, 34, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label8 = GUICtrlCreateLabel("", 246, 84, 28, 27)
GUICtrlSetBkColor(-1, 0x000000)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label9 = GUICtrlCreateLabel("Simulated:", 9, 129, 53, 17)
$L[0] = GUICtrlCreateLabel("A", 84, 129, 11, 17)
$L[1] = GUICtrlCreateLabel("B", 92, 129, 11, 17)
$L[2] = GUICtrlCreateLabel("C", 98, 129, 11, 17)
$L[3] = GUICtrlCreateLabel("D", 106, 129, 12, 17)
$L[4] = GUICtrlCreateLabel("E", 115, 129, 11, 17)
$L[5] = GUICtrlCreateLabel("F", 123, 129, 10, 17)
$L[6] = GUICtrlCreateLabel("G", 129, 129, 12, 17)
$L[7] = GUICtrlCreateLabel("H", 138, 129, 12, 17)
$L[8] = GUICtrlCreateLabel("I", 147, 129, 7, 17)
$L[9] = GUICtrlCreateLabel("J", 150, 129, 9, 17)
$L[10] = GUICtrlCreateLabel("K", 156, 129, 11, 17)
$L[11] = GUICtrlCreateLabel("L", 162, 129, 10, 17)
$L[12] = GUICtrlCreateLabel("M", 168, 129, 13, 17)
$L[13] = GUICtrlCreateLabel("N", 177, 129, 12, 17)
$L[14] = GUICtrlCreateLabel("O", 186, 129, 12, 17)
$L[15] = GUICtrlCreateLabel("P", 195, 129, 11, 17)
$L[16] = GUICtrlCreateLabel("Q", 204, 129, 12, 17)
$L[17] = GUICtrlCreateLabel("R", 213, 129, 12, 17)
$L[18] = GUICtrlCreateLabel("S", 222, 129, 11, 17)
$L[19] = GUICtrlCreateLabel("T", 228, 129, 11, 17)
$L[20] = GUICtrlCreateLabel("U", 234, 129, 12, 17)
$L[21] = GUICtrlCreateLabel("V", 243, 129, 11, 17)
$L[22] = GUICtrlCreateLabel("W", 252, 129, 15, 17)
$L[23] = GUICtrlCreateLabel("X", 264, 129, 11, 17)
$L[24] = GUICtrlCreateLabel("Y", 273, 129, 11, 17)
$L[25] = GUICtrlCreateLabel("Z", 282, 129, 11, 17)
$Button1 = GUICtrlCreateButton("Sim", 297, 126, 45, 22, 0)
$Edit1 = GUICtrlCreateEdit("", 3, 174, 389, 161)
$Edit2 = GUICtrlCreateEdit("", 6, 369, 389, 161, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_HSCROLL,$WS_VSCROLL))
$Button2 = GUICtrlCreateButton("Generate", 12, 339, 75, 25, 0)
GUISetState(@SW_SHOW)


While 1
	$nMsg = GUIGetMsg()
	UpdateColor1()
	UpdateColor2()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			Sim()
		Case $Button2
			Generate()
	EndSwitch
WEnd

Func UpdateColor1()
	$GuiRead1 = GUICtrlRead($Input1)
	If $GuiRead1>255 Then
		GUICtrlSetData($Input1,255)
	EndIf
	$GuiRead2 = GUICtrlRead($Input2)
	If $GuiRead2>255 Then
		GUICtrlSetData($Input2,255)
	EndIf
	$GuiRead3 = GUICtrlRead($Input3)
	If $GuiRead3>255 Then
		GUICtrlSetData($Input3,255)
	EndIf
	
	If $Last <> $GuiRead1&$GuiRead2&$GuiRead3 Then
		$RGBColor = '0x' & StringTrimLeft(Hex($GuiRead1),6) & StringTrimLeft(Hex($GuiRead2),6)& StringTrimLeft(Hex($GuiRead3),6)
		$Last = $GuiRead1&$GuiRead2&$GuiRead3
		GUICtrlSetBkColor ($Label4,$RGBColor)
	EndIf
EndFunc

Func UpdateColor2()
	$GuiRead4 = GUICtrlRead($Input4)
	If $GuiRead4>255 Then
		GUICtrlSetData($Input4,255)
	EndIf
	$GuiRead5 = GUICtrlRead($Input5)
	If $GuiRead5>255 Then
		GUICtrlSetData($Input5,255)
	EndIf
	$GuiRead6 = GUICtrlRead($Input6)
	If $GuiRead6>255 Then
		GUICtrlSetData($Input6,255)
	EndIf
	
	If $Last2 <> $GuiRead4&$GuiRead5&$GuiRead6 Then
		$RGBColor = '0x' & StringTrimLeft(Hex($GuiRead4),6) & StringTrimLeft(Hex($GuiRead5),6)& StringTrimLeft(Hex($GuiRead6),6)
		$Last2 = $GuiRead4&$GuiRead5&$GuiRead6
		GUICtrlSetBkColor ($Label8,$RGBColor)
	EndIf
EndFunc

Func Sim()
	$GuiRead1 = GUICtrlRead($Input1) ;r
	$GuiRead2 = GUICtrlRead($Input2) ;g
	$GuiRead3 = GUICtrlRead($Input3) ;b
	
	$GuiRead4 = GUICtrlRead($Input4) ;r2
	$GuiRead5 = GUICtrlRead($Input5) ;g2
	$GuiRead6 = GUICtrlRead($Input6) ;b2
	
	$Range_Red = ($GuiRead4 - $GuiRead1)/26
	$Range_Green = ($GuiRead5 - $GuiRead2)/26
	$Range_Blue = ($GuiRead6 - $GuiRead3)/26
	
	$Base_Color = '0x' & StringTrimLeft(Hex($GuiRead1),6) & StringTrimLeft(Hex($GuiRead2),6)& StringTrimLeft(Hex($GuiRead3),6)
	
	For $i = 0 To 25
		$Color1 = '0x' & StringTrimLeft(Hex($GuiRead1+$Range_Red*$i),6) & StringTrimLeft(Hex($GuiRead2+$Range_Green*$i),6) & StringTrimLeft(Hex($GuiRead3+$Range_Blue*$i),6)
		GUICtrlSetColor($L[$i], $Color1)
	Next
	
EndFunc

Func Generate()
	$GuiRead7= GUICtrlRead($Edit1)
	$Split = StringSplit($GuiRead7,"")
	
	$GuiRead1 = GUICtrlRead($Input1) ;r
	$GuiRead2 = GUICtrlRead($Input2) ;g
	$GuiRead3 = GUICtrlRead($Input3) ;b
	
	$GuiRead4 = GUICtrlRead($Input4) ;r2
	$GuiRead5 = GUICtrlRead($Input5) ;g2
	$GuiRead6 = GUICtrlRead($Input6) ;b2
	
	$Range_Red = ($GuiRead4 - $GuiRead1)/$Split[0]
	$Range_Green = ($GuiRead5 - $GuiRead2)/$Split[0]
	$Range_Blue = ($GuiRead6 - $GuiRead3)/$Split[0]
	
	GUICtrlSetData ( $Edit2, "")
	_GUICtrlEdit_BeginUpdate($Edit2)
	For $i = 1 To $Split[0]
		$Color1 = StringTrimLeft(Hex($GuiRead1+$Range_Red*$i),6) & StringTrimLeft(Hex($GuiRead2+$Range_Green*$i),6) & StringTrimLeft(Hex($GuiRead3+$Range_Blue*$i),6)
		If $split[$i] = " " Then
			_GUICtrlEdit_InsertText($Edit2, " ")
			Else
			_GUICtrlEdit_InsertText($Edit2, "[COLOR=#"&$color1&"]"&$split[$i]&"[/COLOR]")
		EndIf
	Next
	_GUICtrlEdit_EndUpdate($Edit2)
EndFunc