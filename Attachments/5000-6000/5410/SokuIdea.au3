;Sudoku Solver in AutoIt3
#include <GUIConstants.au3>
GUICreate("Sudoku Solver",600,600)
Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")
GUISetState(@SW_SHOW)

Dim $buttons[9][9][9]

for $i = 0 to 8
for $j = 0 to 8
for $k = 0 to 8
    $top = (((20*$j)+5)+(200*mod($k,3)))
    $left = (((20*$i)+5)+(200*Int($k/3)))
    $buttons[$i][$j][$k] = GUICtrlCreateButton("",$top,$left,20,20, $BS_RIGHT )
	$hiddenData = $i & "," & $j  & "," & $k & "|" & "   "
	GuiCtrlSetData($buttons[$i][$j][$k], $hiddenData & "?")
    GuiCtrlSetOnEvent($buttons[$i][$j][$k],"SetNumber")
next
next
next

While 1
Sleep(1000)
Wend



Func SetNumber()
	;Use the special @Gui_CtrlId to determine what button was clicked.
    $ClickedButtonData = GuiCtrlREad(@GUI_CtrlId)
	
	$coordTriplet = StringLeft($clickedButtonData, StringInStr($clickedButtonData,"|") - 1)
	$coords = StringSplit($coordTriplet, ",")
	$x = $coords[1]
	$y = $coords[2]
	$z = $coords[3]

	; Replace the "?" with "X" when button is clicked
	GuiCtrlSetData(@GUI_CtrlId, StringReplace($clickedButtonData, "?", "X") )
	
	;The info you want
	MsgBox(0, "ID=" & @Gui_CtrlId, $x & "," & $y & "," & $z)
EndFunc

Func Quit()
	Exit
EndFunc