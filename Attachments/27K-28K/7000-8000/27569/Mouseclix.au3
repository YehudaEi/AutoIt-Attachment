#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Misc.au3>
#include <Color.au3>

$Form1 = GUICreate("Mouseclix - by Info", 330, 94, 500, 300, -1, BitOR($WS_EX_TOOLWINDOW,$WS_EX_TOPMOST,$WS_EX_WINDOWEDGE))
$Button1 = GUICtrlCreateButton("Activate", 257, 0, 73, 25, BitOR($BS_DEFPUSHBUTTON,$WS_GROUP))
$Edit1 = GUICtrlCreateEdit("", 0, 0, 237, 74, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetBkColor(-1,0xffffff)
$Checkbox1 = GUICtrlCreateCheckbox("Play Sound", 258, 26, 74, 17)
GUICtrlSetState(-1,$GUI_CHECKED)
$Checkbox2 = GUICtrlCreateCheckbox("Return Hex", 258, 42, 74, 17)
GUICtrlSetState(-1,$GUI_CHECKED)
$Slider = GUICtrlCreateSlider(254,58,80,20)
GUICtrlSetData(-1,50)
$Edit2 = GUICtrlCreateEdit("",238,0,19,74,BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_WANTRETURN,$ES_READONLY), 0)
$ColorLabel = GUICtrlCreateLabel("",2,77,68,14)
$RedLabel = GUICtrlCreateLabel("",70,77,19,14)
$BlueLabel = GUICtrlCreateLabel("",90,77,19,14)
$GreenLabel = GUICtrlCreateLabel("",110,77,19,14)
GUICtrlSetBkColor($Edit2,0x000000)
GUICtrlSetBkColor($RedLabel,0xFF0000)
GUICtrlSetBkColor($BlueLabel,0x0000FF)
GUICtrlSetBkColor($GreenLabel,0x00FF00)
GUICtrlSetState($RedLabel,$GUI_HIDE)
GUICtrlSetState($GreenLabel,$GUI_HIDE)
GUICtrlSetState($BlueLabel,$GUI_HIDE)
GUICtrlSetColor($RedLabel,0xffffff)
GUICtrlSetColor($GreenLabel,0xffffff)
GUICtrlSetColor($BlueLabel,0xffffff)
GUISetState(@SW_SHOW)

While 1
	If _IsPressed(74) Then
		If GUICtrlRead($Button1) = "Deactivate" Then
			Sleep(100)
			$pos = MouseGetPos() ;get mouse coords
			$pixelgetcolor = PixelGetColor($pos[0],$pos[1]) ;get pixel color (returns a Dec number by default. see _HexOrDec Function
			GUICtrlSetData($Edit1,@HOUR&":"&@MIN&":"&@SEC&": x:"&$pos[0]&", y:"&$pos[1]&". pixel: "&_HexOrDec()&_EmptyCheck()&GUICtrlRead($Edit1)) ;the big guictrlsetdata >_<
			If GUICtrlRead($Checkbox1) = $GUI_CHECKED Then SoundPlay(@WindowsDir&"/Media/tada.wav") ;play sound if Checkbox1 is checked
			SoundSetWaveVolume(GUICtrlRead($Slider)) ;set volume by the slider's value
			GUICtrlSetBkColor($Edit2,"0x"&hex($pixelgetcolor))
			GUICtrlSetData($ColorLabel,_HexOrDec()&":")
			_RGB()
		EndIf
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $Button1
			If GUICtrlRead($Button1) = "Activate" Then
				GUICtrlSetData($Button1, "Deactivate")
			Else
				GUICtrlSetData($Button1, "Activate")
			EndIf
	EndSwitch
WEnd

Func _EmptyCheck()
	If GUICtrlRead($Edit1) = "" Then
		Return ""
	Else
		Return @CRLF
	EndIf
EndFunc

Func _HexOrDec()
	If GUICtrlRead($Checkbox2) = $GUI_CHECKED Then
		Return StringReplace("0x"&Hex($pixelgetcolor),"0x00","0x")
	Else
		Return $pixelgetcolor
	EndIf
EndFunc

Func _RGB()
	GUICtrlSetState($RedLabel,$GUI_SHOW)
	GUICtrlSetState($GreenLabel,$GUI_SHOW)
	GUICtrlSetState($BlueLabel,$GUI_SHOW)
	GUICtrlSetData($RedLabel,_ColorGetRed($pixelgetcolor))
	GUICtrlSetData($GreenLabel,_ColorGetGreen($pixelgetcolor))
	GUICtrlSetData($BlueLabel,_ColorGetBlue($pixelgetcolor))
EndFunc