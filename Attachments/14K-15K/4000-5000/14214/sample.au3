#include-once
#include <GUIConstants.au3>
#include <GuiTab.au3>

$s_GUI = GUICreate("Sample",244,128,-1,-1,-1,$WS_EX_TOPMOST)

$s_TABS = GUICtrlCreateTab(2,2,241,125)
$tab1 = GUICtrlCreateTabItem("    test1  ")
$tab2 = GUICtrlCreateTabItem("  test2  ") ;/ Second tab for programs /;
$tab3 = GUICtrlCreateTabItem(" test3  ") ;/ Second tab for programs /;
GUISetState() ;/ makes Launchpad visible /;


$last = 0
While 1
$xy = _GUICtrlTabGetCurFocus($s_TABS)
	If $xy = 0 Then
		If $last = 1 Or $last = 2 Then
			$last = 0
			RESIZE(250,160)
		EndIf
	ElseIf $xy = 1 Then
		If $last = 0 Or $last = 2 Then
			$last = 1
			RESIZE(410,340)
		EndIf
	ElseIf $xy = 2 Then
		If $last = 0 Or $last = 1 Then
			$last = 2
			RESIZE(270,500)
		EndIf
	EndIf
sleep(10)
$winsize= WinGetPos($s_GUI)
WEnd

Func RESIZE($X, $Y)
	$xD = 0 
	$yD = 0 
	$winsize= WinGetPos($s_GUI)
	If $X > $winsize[2] Then $xD = 20
	If $X < $winsize[2] And $X >= 1 Then $xD = -20
	If $Y > $winsize[3] Then	$yD = 20
	If $Y < $winsize[3] And $Y >= 1 Then $yD = -20
	$xdone = False
	$ydone = False
	Do
		If $xD = 0 Then $xdone = True
		If $xdone = False Then
			$winsize[2] += $xD
			WinMove($s_GUI,"",default,default,$winsize[2],$winsize[3])
			GUICtrlSetPos($s_TABS,3,3,$winsize[2]-10,$winsize[3]-35)
			If $winsize[2] = $X Then $xdone = True
		EndIf
	Until $xdone = True		
	Do
		If $yD = 0 Then $ydone = True	
		If $ydone = False Then
			$winsize[3] += $yD
			WinMove($s_GUI,"",default,default,$winsize[2],$winsize[3])
			GUICtrlSetPos($s_TABS,3,3,$winsize[2]-10,$winsize[3]-35)
			If $winsize[3] = $Y Then $ydone = True
			EndIf
	Until $ydone = True
EndFunc