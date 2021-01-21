#include <file.au3>
#include <math.au3>
#include <GuiConstants.au3>
$timer = 1
$tick = 1
While $timer = 1
	
	
	HotKeySet("{enter}", "click")
	If Not FileExists("c:\temp\money.ini") Then
		IniWrite("C:\Temp\money.ini", "name", "money", "500")
	EndIf
	$l1 = ""
	$l2 = ""
	$l3 = ""
	$l4 = ""
	$l5 = ""
	$t = "c:\5lw.txt"
	$lines = _FileCountLines($t)
	$rnd = Random(1, $lines, 1)
	$lr = FileReadLine($t, $rnd)
	;msgbox(0, "read", "I picked " & $lr)
	If Not IsDeclared('WS_CLIPSIBLINGS') Then Global $WS_CLIPSIBLINGS = 0x04000000
	
	
	GUICreate("My Game", @DesktopWidth, @DesktopHeight, 1, 1, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	$l1 = GUICtrlCreateInput("", 170, 30, 89, 93)
	GUICtrlSetFont($l1, 50)
	$l2 = GUICtrlCreateInput("", 270, 30, 89, 93)
	GUICtrlSetFont($l2, 50)
	$l3 = GUICtrlCreateInput("", 370, 30, 89, 93)
	GUICtrlSetFont($l3, 50)
	$l4 = GUICtrlCreateInput("", 470, 30, 89, 93)
	GUICtrlSetFont($l4, 50)
	$l5 = GUICtrlCreateInput("", 570, 30, 89, 93)
	GUICtrlSetFont($l5, 50)
	$Button_6 = GUICtrlCreateButton("Submit", 200, 350, 120, 40)
	$Button_7 = GUICtrlCreateButton("Quit", 420, 350, 120, 40)
	$monlabel = GUICtrlCreateLabel("", 620, 300, 120, 25)
	$money = IniRead("c:\temp\money.ini", "name", "money", "500")
	GUICtrlSetData($monlabel, "money: " & $money)
	$guess = GUICtrlCreateInput("", 260, 270, 230, 50)
	GUICtrlSetFont($guess, 20)
	GUISetState()
	
	While $tick = 1
		
		$msg = GUIGetMsg()
		$w1 = StringMid($lr, 1, 1)
		GUICtrlSetData($l1, $w1)
		If $msg = $Button_6 Then
			
			$w1 = StringMid($lr, 1, 1)
			$w2 = StringMid($lr, 2, 1)
			$w3 = StringMid($lr, 3, 1)
			$w4 = StringMid($lr, 4, 1)
			$w5 = StringMid($lr, 5, 1)
			$guess2 = GUICtrlRead($guess)
			$g1 = StringMid($guess2, 1, 1)
			$g2 = StringMid($guess2, 2, 1)
			$g3 = StringMid($guess2, 3, 1)
			$g4 = StringMid($guess2, 4, 1)
			$g5 = StringMid($guess2, 5, 1)
			GUICtrlSetData($guess, "")
			If $w1 = $g1 Then
				
				GUICtrlSetData($l1, $w1)
			EndIf
			If $w2 = $g2 Then
				
				GUICtrlSetData($l2, $w2)
			EndIf
			If $w3 = $g3 Then
				
				GUICtrlSetData($l3, $w3)
			EndIf
			If $w4 = $g4 Then
				
				GUICtrlSetData($l4, $w4)
			EndIf
			If $w5 = $g5 Then
				
				GUICtrlSetData($l5, $w5)
			EndIf
		EndIf
		$f1 = GUICtrlRead($l1)
		$f2 = GUICtrlRead($l2)
		$f3 = GUICtrlRead($l3)
		$f4 = GUICtrlRead($l4)
		$f5 = GUICtrlRead($l5)
		If $f1 <> "" And $f2 <> "" And $f3 <> "" And $f4 <> "" And $f5 <> "" Then
			MsgBox(0, "you got it!", "you got it!")
			;$l1 = ""
			;$l2 = ""
			;$l3 = ""
			;$l4 = ""
			;$l5 = ""
			$tick = 2
		EndIf
		If $msg = $Button_7 Then
			Exit
		EndIf
		
		Select
			Case $msg = $GUI_EVENT_CLOSE
				ExitLoop
			Case Else
				
				;;;
		EndSelect
	WEnd
WEnd


Func click()
	ControlClick("My Game", "", $Button_6)
EndFunc   ;==>click


