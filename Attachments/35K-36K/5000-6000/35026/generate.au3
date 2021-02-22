#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=C:\Users\Matt\Pictures\Icons\Elements\leaf.ico
#AutoIt3Wrapper_outfile=C:\Users\Matt\Desktop\Generator.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <GDIPlus.au3>

reloadoptions(0) ;Load the options GUI


#Region ### START Koda GUI section ### Form=C:\Users\Matt\Pictures\Gimp\GUI\Form1.kxf
$Form1 = GUICreate("Generate Level", 1102, 502, 194, 139, BitOR($WS_MINIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_SYSMENU,$WS_CAPTION,$WS_POPUP,$WS_POPUPWINDOW,$WS_GROUP,$WS_BORDER,$WS_CLIPSIBLINGS))
GUISetBkColor(0x000000)
$btngenerate = GUICtrlCreateButton("Generate!", 464, 472, 179, 25, $WS_GROUP)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM+$GUI_DOCKHCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
$statuslbl = GUICtrlCreateLabel("Generating 0/0", 648, 472, 172, 17)
GUICtrlSetResizing(-1, $GUI_DOCKBOTTOM+$GUI_DOCKHCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetColor(-1, 0x00FF00)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###




_GDIPlus_Startup()

$hwnd = _GDIPlus_GraphicsCreateFromHWND($Form1)

While 1

$nMsg = GUIGetMsg()
Switch $nMsg
	Case $GUI_EVENT_CLOSE
		Exit
	Case $btngenerate
		If GUICtrlRead($checkrandom) = $GUI_CHECKED then randomgenops()
		Generateland()
	Case $btndefault
		reloadoptions(1)
EndSwitch


WEnd



Func Generateland()
	_GDIPlus_GraphicsClear($hwnd)
	$hwnd = _GDIPlus_GraphicsCreateFromHWND($Form1)

	$linewidth = GUICtrlRead($inlinesize)
	$greenpen = _GDIPlus_PenCreate(0xFF00FF00,$linewidth)
	$greypen = _GDIPlus_PenCreate(0xFF2B2B2B,$linewidth)
	$brownpen = _GDIPlus_PenCreate(0xFF733D1A,$linewidth)

	$winsize = WinGetPos("Generate Level")


	;YAY! lets do some math...

	$y = Round(($winsize[3]-50)/2,0) ;offset for bottom, get middle
	$yoff = Round(($winsize[3]-60)/4,0) ; get the quarters
	$y = Random($y-$yoff,$y+$yoff,1) ;use the 2 interquarters
	$x = Round($linewidth/2,0)
	$bottom = $winsize[3]-80
	$bottomlimit = GUICtrlRead($inhmin)
	$counter = 1

Do
	GUICtrlSetData($statuslbl,"Generating "&$counter&"/"&Round($winsize[2]/$linewidth,0))
	$ran = Random(GUICtrlRead($inmainran1),GUICtrlRead($inmainran2),1)
	$toolow = 0
	$tooh = 0
	If $toolow = 1 and $y <= $winsize[3]-$yoff Then $toolow = 0  ;this is to bring level back to normal elevation
	If $tooh = 1 and $y >= $yoff Then $tooh = 0  ;this is to bring level back to normal elevation

	;Generate Flat
	If $ran >= GUICtrlRead($ingenflat1) And $ran <= GUICtrlRead($ingenflat2) Then
		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0),$greenpen)
		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0)+GUICtrlRead($indirtlayer),$brownpen)

	EndIf
	;Generate Elevate Up
	If $ran >= GUICtrlRead($ingenelup1) And $ran <= GUICtrlRead($ingenelup2) Then


		If $y - GUICtrlRead($insteph) <= GUICtrlRead($inhmax) Then $tooh = 1;Lets not go too far up yea?
		;its too high make it have little chance of going back up until a certain elevation is met
		;this gives it a smaller chance to go back up until its low enough
		If $tooh = 1 And Random(GUICtrlRead($intoohupchance1),GUICtrlRead($intoohupchance2),1) = GUICtrlRead($intoohupchance1) Then $y = $y - GUICtrlRead($insteph)
		If $tooh = 0 Then $y = $y - GUICtrlRead($insteph)


		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0),$greenpen)
		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0)+GUICtrlRead($indirtlayer),$brownpen)

	EndIf
	If $ran >= GUICtrlRead($ingeneldn1) And $ran <= GUICtrlRead($ingeneldn2) Then

		If $y + GUICtrlRead($insteph) >= $bottom - $bottomlimit Then $toolow = 1;Lets not go too far down yea?
		;its too low make it have little chance of going down until a certain hight is met
		;this gives it a smaller chance to go back down until its high enough
		If $toolow = 1 And Random(GUICtrlRead($intoolowdnchance1),GUICtrlRead($intoolowdnchance1),1) = GUICtrlRead($intoolowdnchance1) Then $y = $y + GUICtrlRead($insteph)
		If $toolow = 0 Then $y = $y + GUICtrlRead($insteph)

		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0),$greenpen)
		_GDIPlus_GraphicsDrawLine($hwnd,$x,$bottom,$x,$y + Round($linewidth/2,0)+GUICtrlRead($indirtlayer),$brownpen)


	EndIf

	$counter = $counter + 1
	$x = $x + $linewidth
Until $x >= $winsize[2]
	GUICtrlSetData($statuslbl,"Generated!")
EndFunc


Func randomgenops()
	$ran = Random(2,5,1)
	GUICtrlSetData($ingenelup2,$ran)
	GUICtrlSetData($ingenflat1,$ran+1)
	$ran = Random($ran+2,$ran+6,1)
	GUICtrlSetData($ingenflat2,$ran)
	GUICtrlSetData($ingeneldn1,$ran+1)

	Random(7,11,1)
EndFunc

Func reloadoptions($x)
	If $x = 1 Then GUIDelete($Form2)

#Region ### START Koda GUI section ### Form=
Global $Form2 = GUICreate("Options", 391, 417, 100, 80)
Global $inmainran1 = GUICtrlCreateInput("1", 80, 8, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label1 = GUICtrlCreateLabel("Main Random", 8, 8, 70, 17)
$Label2 = GUICtrlCreateLabel("--", 120, 8, 10, 17)
Global $inmainran2 = GUICtrlCreateInput("11", 128, 8, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $ingenflat1 = GUICtrlCreateInput("4", 80, 40, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label3 = GUICtrlCreateLabel("Gen Flat", 32, 40, 44, 17)
$Label4 = GUICtrlCreateLabel("--", 120, 40, 10, 17)
Global $ingenflat2 = GUICtrlCreateInput("8", 128, 40, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $ingenelup1 = GUICtrlCreateInput("1", 80, 64, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label5 = GUICtrlCreateLabel("Gen Elev. Up", 8, 64, 68, 17)
$Label6 = GUICtrlCreateLabel("--", 120, 64, 10, 17)
Global $ingenelup2 = GUICtrlCreateInput("3", 128, 64, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $ingeneldn1 = GUICtrlCreateInput("9", 80, 88, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label7 = GUICtrlCreateLabel("Gen Elev. Dn", 8, 88, 68, 17)
$Label8 = GUICtrlCreateLabel("--", 120, 88, 10, 17)
Global $ingeneldn2 = GUICtrlCreateInput("11", 128, 88, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $ingenhill1 = GUICtrlCreateInput("X", 80, 112, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label9 = GUICtrlCreateLabel("Gen Hill", 32, 112, 41, 17)
$Label10 = GUICtrlCreateLabel("--", 120, 112, 10, 17)
Global $ingenhill2 = GUICtrlCreateInput("X", 128, 112, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $ingendip1 = GUICtrlCreateInput("X", 80, 136, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label11 = GUICtrlCreateLabel("Gen Dip", 32, 136, 43, 17)
$Label12 = GUICtrlCreateLabel("--", 120, 136, 10, 17)
Global $ingendip2 = GUICtrlCreateInput("X", 128, 136, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label13 = GUICtrlCreateLabel("Height Min.", 16, 184, 59, 17)
Global $inhmin = GUICtrlCreateInput("10", 80, 184, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetTip(-1, "This is pixels from bottom of drawing area")
$Label14 = GUICtrlCreateLabel("Line Size", 24, 232, 47, 17)
Global $inlinesize = GUICtrlCreateInput("4", 80, 232, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $inhillstop = GUICtrlCreateInput("X", 288, 40, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label15 = GUICtrlCreateLabel("Hill Stop Chance", 200, 40, 84, 17)
Global $inrand1 = GUICtrlCreateInput("1", 288, 16, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label16 = GUICtrlCreateLabel("Random", 240, 16, 46, 17)
$Label17 = GUICtrlCreateLabel("--", 328, 16, 10, 17)
Global $inrand2 = GUICtrlCreateInput("9", 336, 16, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $indipstop = GUICtrlCreateInput("X", 288, 64, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label18 = GUICtrlCreateLabel("Dip Stop Chance", 200, 64, 84, 17)
Global $maxhillh = GUICtrlCreateInput("X", 288, 104, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label19 = GUICtrlCreateLabel("Max Hill Height", 208, 104, 76, 17)
Global $maxhillw = GUICtrlCreateInput("X", 288, 128, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label20 = GUICtrlCreateLabel("Max Hill Width", 208, 128, 76, 17)
Global $maxdiph = GUICtrlCreateInput("X", 288, 152, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label21 = GUICtrlCreateLabel("Max Dip Height", 208, 152, 76, 17)
Global $maxdipw = GUICtrlCreateInput("X", 288, 176, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label22 = GUICtrlCreateLabel("Max Dip Width", 208, 176, 76, 17)
$Label23 = GUICtrlCreateLabel("Step Size", 24, 256, 49, 17)
Global $insteph = GUICtrlCreateInput("4", 80, 256, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $indirtlayer = GUICtrlCreateInput("4", 240, 216, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label24 = GUICtrlCreateLabel("Dirt Offset", 188, 216, 49, 17)
Global $inrocklayer1 = GUICtrlCreateInput("X", 240, 240, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label26 = GUICtrlCreateLabel("Rock Layer", 176, 240, 62, 17)
$Label27 = GUICtrlCreateLabel("--", 280, 240, 10, 17)
Global $inrocklayer2 = GUICtrlCreateInput("X", 288, 240, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $intoolowdnchance1 = GUICtrlCreateInput("1", 160, 296, 25, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label25 = GUICtrlCreateLabel("Elev. Dn chance if toolow =1", 8, 298, 148, 17)
$Label28 = GUICtrlCreateLabel("of", 192, 298, 13, 17)
Global $intoolowdnchance2 = GUICtrlCreateInput("5", 208, 296, 25, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
Global $intoohupchance1 = GUICtrlCreateInput("1", 160, 320, 25, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label29 = GUICtrlCreateLabel("Elev. Up chance if tooh =1", 8, 322, 147, 17)
$Label30 = GUICtrlCreateLabel("of", 192, 322, 13, 17)
Global $intoohupchance2 = GUICtrlCreateInput("5", 208, 320, 25, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
$Label31 = GUICtrlCreateLabel("Height Max", 16, 208, 58, 17)
Global $inhmax = GUICtrlCreateInput("20", 80, 208, 41, 21, BitOR($ES_AUTOHSCROLL,$ES_NUMBER))
GUICtrlSetTip(-1, "This is pixels from the top of the drawing area")
Global $checkrandom = GUICtrlCreateCheckbox("Randomize Gen. #", 32, 160, 113, 17)
Global $btndefault = GUICtrlCreateButton("Default Values", 280, 312, 99, 25, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

EndFunc

