#include<GUIConstants.au3>

$Size = 40

Dim $array[20] [12]

GuiCreate('Icon Select',801,555)
$IconButton = GUICtrlCreateButton("", 616, 496, 81, 41,$BS_ICON)
$Label = GUICtrlCreateLabel ("",  9, 492, 591, 21 ,BitOR($SS_SUNKEN,$WS_BORDER)) 
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
$Label1 = GUICtrlCreateLabel ("", 8, 520, 591, 21 ,BitOR($SS_SUNKEN,$WS_BORDER))
GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")

For $y = 0 to 11
	For $x = 0 To 19
		$Icon =	($y*20)+$x
		If $Icon > 233 then $Icon = 50
		$array[$x][$y] = GuiCtrlCreateButton($Icon ,($x*$Size) ,($y*$Size) ,$Size ,$Size,$BS_ICON)
		GUICtrlSetImage ($array[$x][$y], "shell32.dll", $Icon)
	Next
Next

GuiSetState(@SW_SHOW)

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case Else
		;;;;;;;
	EndSelect

For $y = 0 to 11
	For $x = 0 To 19
		$Icon =	($y*20)+$x
		If $Icon > 233 then ExitLoop
	Select
		Case $msg = $array[$x][$y]
		GUICtrlSetImage ($IconButton, "shell32.dll", $Icon)
		GUICtrlCreateIcon ("shell32.dll",$Icon, 730, 496,$size,$size)

		GUICtrlSetData ($Label,  ' GUICtrlSetImage ($ButtonName, "shell32.dll"'&"," &$Icon &")")
		GUICtrlSetData ($Label1, ' GUICtrlCreateIcon ("shell32.dll"'&"," &$Icon &",$x" &",$y" &",$Size" &",$Size"&")")
	;	MsgBox (64,"Icon!","You have selected Icon: " &$Icon)
	EndSelect

	Next
Next

Wend
Exit
