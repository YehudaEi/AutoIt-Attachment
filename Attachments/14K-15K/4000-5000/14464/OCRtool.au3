;Optical Character Recognition Script Written By KageKhan

#include <GuiConstants.au3>

HotKeySet("^s", "Start")
HotKeySet("^e", "End")
HotKeySet("^c", "Color")
HotKeySet("^b", "Begin")

$start = MouseGetPos()
$end = MouseGetPos()
$color = PixelGetColor(MouseGetPos(0), MouseGetPos(1))

GuiCreate("OCR Scanner", 281, 203,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

$Label_1 = GuiCtrlCreateLabel("Letter to scan for:", 30, 15, 83, 30)
$Input_1 = GUICtrlCreateInput("", 120, 10, 130, 20)
$Label_2 = GuiCtrlCreateLabel("Press Control + S to set the top left pixel to start scanning at.", 30, 50, 230, 30)
$Label_3 = GuiCtrlCreateLabel("Press Control + E to set the bottom right pixel to end scanning at.", 30, 90, 230, 30)
$Label_4 = GuiCtrlCreateLabel("Press Control + C to set the color of the letter to be scanned.", 30, 130, 230, 30)
$Label_5 = GuiCtrlCreateLabel("Press Contrl + B to begin the scanning process", 30, 170, 230, 30)

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

Func Start()
	$start = MouseGetPos()
EndFunc

Func End()
	$end = MouseGetPos()
EndFunc

Func Color()
	$color = PixelGetColor(MouseGetPos(0), MouseGetPos(1))
EndFunc

Func Begin()
	$origin = PixelSearch($start[0], $start[1], $end[0], $end[1], $color) 
	$temp = FileOpen(@WorkingDir & "\Letters\temp.dat", 2)
	$counter = 0
	For $i = $start[1] To $end[1] Step +1
		For $j = $start[0] To $end[0] Step +1
			If PixelGetColor($j, $i) = $color Then
				$x = $j - $origin[0]
				$y = $i - $origin[1]
				FileWriteLine($temp, $x)
				FileWriteLine($temp, $y)
				$counter = $counter + 2
			EndIf
		Next
	Next
	FileClose($temp)
	$temp = FileOpen(@WorkingDir & "\Letters\temp.dat", 0)
	$letter = FileOpen(@WorkingDir & "\Letters\" & GUICtrlRead($Input_1) & ".dat", 2)
	FileWrite($letter, $counter)
	For $i = 0 To $counter Step +1
		FileWriteLine($letter, FileReadLine($temp, $i))
	Next
	FileClose($letter)
	FileClose($temp)
	FileDelete(@WorkingDir & "\Letters\temp.dat")
EndFunc