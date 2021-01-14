#include <GuiConstants.au3>
#include <Array.au3>
#include <File.au3>
Opt("TrayMenuMode",1)
Opt('TrayOnEventMode',1)

Global $numbers1, $numbers2, $simbol, $usersays, $usersay, $Result, $score, $name

$scoreborad = TrayCreateItem("Score borad")
TrayItemSetOnEvent($scoreborad,"Showscoreborad")
$trayexit = TrayCreateItem("Exit")
TrayItemSetOnEvent($trayexit,"_Exit")

;Start guis
GuiCreate("math wizz", 268, 90,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Input_1 = GuiCtrlCreateInput("", 90, 20, 160, 20)
$Label_2 = GuiCtrlCreateLabel("Name", 20, 20, 60, 20)
$Button_3 = GuiCtrlCreateButton("start", 90, 60, 90, 20)
GUISetBkColor( 0xB0B0D0 )
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			Exit
		Case $msg = $Button_3
			$name = GUICtrlRead($Input_1)
			ExitLoop
			GUIDelete("math wizz")
	EndSelect
WEnd


GuiCreate("Math wizz" & " " & $name , 312, 118,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
$Makethemath = GuiCtrlCreateButton("Make the math", 210, 20, 90, 20)
$Checkthemath = GuiCtrlCreateButton("Check the math", 210, 40, 90, 20)
$Exit = GuiCtrlCreateButton("Exit", 210, 60, 90, 20)
$seescore = GUICtrlCreateLabel($score, 250, 90, 90, 20)
$nubers1 = GuiCtrlCreateLabel($numbers1, 30, 30, 60, 20)
$simbal = GuiCtrlCreateLabel($simbol, 90, 30, 30, 20)
$mubers2 = GuiCtrlCreateLabel($numbers2, 140, 30, 50, 20)
$usersay = GuiCtrlCreateInput($usersays, 30, 60, 90, 20)
$Group_8 = GuiCtrlCreateGroup("The math", 10, 10, 200, 100)
$Label_9 = GuiCtrlCreateLabel($Result, 140, 60, 60, 20)
GUISetBkColor( 0xB0B0D0 )

GuiSetState()
; end of gui

$score = "0"
GUICtrlSetData($seescore, $score)
Func checkthemath()
	;geting the numbers
	$n1 = GUICtrlRead($nubers1)
	$sb = GUICtrlRead($simbal)
	$n2 = GUICtrlRead($mubers2)
	;doing some math
	$Res = $n1 & $sb & $n2
	$Result = Execute($Res)
	GUICtrlSetData($Label_9 ,$Result)
	$final = GUICtrlRead($Label_9)
	$us = GUICtrlRead($usersay)
	; are we right?
	if $final = $us Then
		SoundPlay(@WindowsDir & "\media\tada.wav",1)
		ToolTip("thats right")
		$score += "1"
		GUICtrlSetData($seescore, $score)
		doingthemath()
	Else
		SoundPlay(@WindowsDir & "\media\chord.wav",1)
		ToolTip("Wrong")
		$score -= "1"
		GUICtrlSetData($seescore, $score)
	EndIf
EndFunc

Func doingthemath()
	; to make the math
	GUICtrlSetData($usersay , "")
	GUICtrlSetData($Label_9 , "")
	$simbol = Random ( 1, 3, 1)
	if $simbol = 1 Then
		$simbol = "+"
		$numbers1 = Random( -9999, 9999,1)
		$numbers2 = Random( -9999, 9999,1)
	ElseIf $simbol = 2 Then
		$simbol = "-"
		$numbers1 = Random( -9999, 9999,1)
		$numbers2 = Random( -9999, 9999,1)
	ElseIf $simbol = "3" Then
		$simbol = "*"
		$numbers1 = Random( -100, 100,1)
		$numbers2 = Random( -100, 100,1)
	EndIf
	; to set the math
	GUICtrlSetData($nubers1, $numbers1)
	GUICtrlSetData($simbal, $simbol)
	GUICtrlSetData($mubers2, $numbers2)
EndFunc

Func Showscoreborad()

	Dim $line
	;to count the file lines
	$howmenylines = _FileCountLines ("Scores.txt")
	;to make the arrays
	If Not _FileReadToArray("Scores.txt",$line) Then
		MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
		Exit
	EndIf
	; to sart the arrays
	_ArraySort ($line ,1 ,0, $howmenylines)
	;to show thw arrays
	_ArrayDisplay($line, "Score Borad")
EndFunc

Func _Exit()
	FileWriteLine("Scores.txt",$score & " " & "was " & $name &  " score" )
	Exit
EndFunc

While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			_Exit()
		Case $msg = $Makethemath
			doingthemath()
		Case $msg = $Checkthemath
			checkthemath()
		Case $msg = $Exit
			_Exit()
	EndSelect
WEnd