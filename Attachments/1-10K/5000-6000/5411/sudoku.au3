;Sudoku Solver in AutoIt3 v1.0
#include <GUIConstants.au3>
GUICreate("Sudoku Solver",800,600)
GUISetState(@SW_SHOW)

;the buttons to press
Dim $buttons[9][9][9]
;the actual puzzle view
Dim $displays[9][9]

;initialize the array of buttons
for $i = 0 to 8
for $j = 0 to 8
for $k = 0 to 8
	$left = (((20*$k)+5)+(200*mod($i,3)))
	$top = (((20*$j)+5)+(200*Int($i/3)))
	$buttons[$i][$j][$k] = GUICtrlCreateButton("",$left,$top,20,20)
next
next
next

;initialize the array of input fields which holds the puzzle view
for $i = 0 to 8
for $j = 0 to 8
	$top = 405 + 20*$i
	$left = 605 + 20*$j
	$displays[$i][$j] = GUICtrlCreateInput("",$left,$top,20,20)
next
next

;game loop
While 1
   $msg = GUIGetMsg(1)
   Select
      Case $msg[0] = $GUI_EVENT_CLOSE
         ExitLoop
      Case Else
         If $msg[0] > 0 Then
            $normalize = $msg[0] - 3	;for some reason, box(0,0,0) had ctrlID set to 3...simple subtract fix
            $nZ = Mod($normalize,9)
            $nY = Int((Mod($normalize,81))/9)
            $nX = Int($normalize/81)
            ;MsgBox(0,"debug","box id# = " & $normalize & Chr(13) & "Box coords = (" & $nx & "," & $ny & "," & $nz & ")")
            
            ;fill in the row, column, 3rd dimension
            for $ctr = 0 to 8
            	GUICtrlSetData($buttons[$ctr][$ny][$nz], "x")
            	GUICtrlSetData($buttons[$nx][$ctr][$nz], "x")
            	GUICtrlSetData($buttons[$nx][$ny][$ctr], "x")
            next
            
            ;fill in the 3x3 box the button is in
            $bY = Int($ny/3)*3
            $bZ = Int($nz/3)*3
            for $bCtrY = 0 to 2
            for $bCtrZ = 0 to 2
            	GUICtrlSetData($buttons[$nx][$bY+$bCtrY][$bZ+$bCtrZ], "x")
            next
            next
            
            ;set the clicked button text to the right number value
            GUICtrlSetData($buttons[$nx][$ny][$nz], ($nx + 1))
            
            ;and set the puzzle view box
            GUICtrlSetData($displays[$ny][$nz], ($nx + 1))
         EndIf
   EndSelect
WEnd