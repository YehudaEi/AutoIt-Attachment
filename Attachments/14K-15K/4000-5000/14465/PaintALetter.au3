HotKeySet("^c", "color")
HotKeySet("^f", "find")
HotKeySet("^p", "paint")

$color = PixelGetColor(MouseGetPos(0), MouseGetPos(1))

#include <GuiConstants.au3>

GuiCreate("OCR Tester", 222, 170,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Label_1 = GuiCtrlCreateLabel("To find your letter just type in the letter to be found and press Control + F", 20, 10, 190, 30)
$Label_2 = GuiCtrlCreateLabel("To paint your letter just type in the letter to be painted and press Control + P", 20, 40, 190, 30)
$Input_3 = GuiCtrlCreateInput("", 120, 80, 80, 20)
$Label_4 = GuiCtrlCreateLabel("Letter to be tested:", 20, 83, 90, 20)
$Input_5 = GuiCtrlCreateInput("1", 120, 120, 80, 20)
$Label_6 = GuiCtrlCreateLabel("Check Point Every:", 20, 123, 100, 20)

GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;
	EndSelect
WEnd
Exit

Func color()
	$color = PixelGetColor(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func find()
	$found = 0
	For $i = 0 To 1024 Step +1
		For $j = 0 To 768 Step +1
			If PixelGetColor($j, $i) = $color Then
				$found = findComplete($j, $i)
			EndIf
			If $found Then
				ExitLoop
			EndIf
		Next
		If $found Then
			ExitLoop
		EndIf
	Next
EndFunc

Func findComplete($x, $y)
	$found = True
	$letter = FileOpen(@WorkingDir & "\Letters\" & GUICtrlRead($Input_3) & ".dat", 0)
	$l = FileReadLine($letter, 1) + 1
	For $i = 2 To $l Step +1
		If Mod($i, GUICtrlRead($Input_5)) = 0 Then
			$x2 = FileReadLine($letter, $i) + $x
			$i = $i + 1
			$y2 = FileReadLine($letter, $i) + $y
			If Not (PixelGetColor($x2, $y2) = $color) Then
				$found = False
				ExitLoop
			EndIf
		Else
			$i = $i + 1
		EndIf
	Next
	FileClose($letter)
	If $found Then
		MsgBox(1, "Character Found", "Your Character Was Found!")
		MouseMove($x, $y, 0)
		Return 1
	EndIf
	Return 0
EndFunc

Func paint()
	$letter = FileOpen(@WorkingDir & "\Letters\" & GUICtrlRead($Input_3) & ".dat", 0)
	$l = FileReadLine($letter, 1) + 1
	For $i = 2 To $l Step +1
		$x = FileReadLine($letter, $i) + 100
		$i = $i + 1
		$y = FileReadLine($letter, $i) + 100
		MouseClick("left", $x, $y, 1, 0)
	Next

	FileClose($letter)
EndFunc