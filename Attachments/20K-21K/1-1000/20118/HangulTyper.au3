#include <GUIConstants.au3>

GUICreate("Hangul Typer",150,150)
$lblChar1 = GUICtrlCreateLabel("",5,10,20,20)
$lblChar2 = GUICtrlCreateLabel("",25,10,20,20)
$lblChar3 = GUICtrlCreateLabel("",45,10,20,20)
$lblChar4 = GUICtrlCreateLabel("",65,0,20,20)
GUICtrlSetFont(-1,16)
$lblChar5 = GUICtrlCreateLabel("",95,10,20,20)
$lblChar6 = GUICtrlCreateLabel("",115,10,20,20)
$lblChar7 = GUICtrlCreateLabel("",135,10,20,20)
$iptChar = GUICtrlCreateInput("",55,35,40,20,$ES_CENTER)
$lblCS = GUICtrlCreateLabel("Consonant Sets",5,70,140,25,$ES_CENTER)
$cbxCS1 = GUICtrlCreateCheckbox("1",5,85)
GUICtrlSetState(-1,$GUI_CHECKED)
$cbxCS2 = GUICtrlCreateCheckbox("2",40,85)
$cbxCS3 = GUICtrlCreateCheckbox("3",75,85)
$cbxCS4 = GUICtrlCreateCheckbox("4",115,85)
$lvlVS = GUICtrlCreateLabel("Vowel Sets",5,110,140,25,$ES_CENTER)
$cbxVS1 = GUICtrlCreateCheckbox("1",5,125)
$cbxVS2 = GUICtrlCreateCheckbox("2",40,125)
$cbxVS3 = GUICtrlCreateCheckbox("3",75,125)
$cbxVS4 = GUICtrlCreateCheckbox("4",115,125)
GUISetState()

#region Hangul Array
Dim $Hang[33]
$Hang[0] = "げ"
$Hang[1] = "じ"
$Hang[2] = "ぇ"
$Hang[3] = "ぁ"
$Hang[4] = "さ"
$Hang[5] = "こ"
$Hang[6] = "す"
$Hang[7] = "え"
$Hang[8] = "あ"
$Hang[9] = "ざ"
$Hang[10] = "そ"
$Hang[11] = "ず"
$Hang[12] = "ぜ"
$Hang[13] = "せ"
$Hang[14] = "け"
$Hang[15] = "い"
$Hang[16] = "し"
$Hang[17] = "ぉ"
$Hang[18] = "ぞ"
$Hang[19] = "で"
$Hang[20] = "っ"
$Hang[21] = "た"
$Hang[22] = "び"
$Hang[23] = "に"
$Hang[24] = "づ"
$Hang[25] = "ち"
$Hang[26] = "だ"
$Hang[27] = "つ"
$Hang[28] = "ぢ"
$Hang[29] = "て"
$Hang[30] = "ぬ"
$Hang[31] = "ば"
$Hang[32] = "ぱ"
#endregion
#endregion

New()
New()
New()
New()
New()
New()
New()
$Old = ""

Do
	$msg = GUIGetMsg()
	
	If Full() Then
		If Check() Then 
			New()
		Else
			Clear()
		EndIf
	EndIf
Until $msg == $GUI_EVENT_CLOSE

Func New()
	GUICtrlSetData($lblChar1,GUICtrlRead($lblChar2))
	GUICtrlSetData($lblChar2,GUICtrlRead($lblChar3))
	GUICtrlSetData($lblChar3,GUICtrlRead($lblChar4))
	GUICtrlSetData($lblChar4,GUICtrlRead($lblChar5))
	GUICtrlSetData($lblChar5,GUICtrlRead($lblChar6))
	GUICtrlSetData($lblChar6,GUICtrlRead($lblChar7))
	GUICtrlSetData($lblChar7,$Hang[Item()])
EndFunc

Func Item()
	Do
		$pass = True
		$r = Random(0,32,1)
		If $Hang[$r] == GUICtrlRead($lblChar6) Then $pass = False
		If $r >= 00 And $r <= 04 And GUICtrlRead($cbxCS1) == $GUI_UNCHECKED Then $pass = False
		If $r >= 05 And $r <= 09 And GUICtrlRead($cbxCS2) == $GUI_UNCHECKED Then $pass = False
		If $r >= 10 And $r <= 13 And GUICtrlRead($cbxCS3) == $GUI_UNCHECKED Then $pass = False
		If $r >= 14 And $r <= 18 And GUICtrlRead($cbxCS4) == $GUI_UNCHECKED Then $pass = False
		If $r >= 19 And $r <= 22 And GUICtrlRead($cbxVS1) == $GUI_UNCHECKED Then $pass = False
		If $r >= 23 And $r <= 25 And GUICtrlRead($cbxVS2) == $GUI_UNCHECKED Then $pass = False
		If $r >= 26 And $r <= 29 And GUICtrlRead($cbxVS3) == $GUI_UNCHECKED Then $pass = False
		If $r >= 30 And $r <= 32 And GUICtrlRead($cbxVS4) == $GUI_UNCHECKED Then $pass = False
	Until $pass
	Return $r
EndFunc

Func Check()
	Return (GUICtrlRead($lblChar4) == GUICtrlRead($iptChar))
EndFunc

Func Full()
	Return (GUICtrlRead($iptChar) <> "")
EndFunc

Func Clear()
	Send("{SPACE}")
	GUICtrlSetData($iptChar,"")
EndFunc