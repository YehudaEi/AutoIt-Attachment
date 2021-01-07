
#include <GuiConstants.au3>

GuiCreate("Clipboard Tool - By Str!ke", 431, 115,-1, -1 , BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))

;; Func
func ask()
		If Not IsDeclared("iMsgBoxAnswer") Then Dim $iMsgBoxAnswer
	$iMsgBoxAnswer = MsgBox(52,"Clipboard Tool","There Still Some Text In Clipboard Continue?" & @CRLF & "Your Text:" & @CRLF & $cg)
	Select
		Case $iMsgBoxAnswer = 6 

		Case $iMsgBoxAnswer = 7 
		EndSelect
EndFunc		

;; Input
$in1 = GuiCtrlCreateInput("Input1", 10, 30, 330, 60)

;; Button
$b1 = GuiCtrlCreateButton("Put In", 350, 30, 80, 60)

;; Labels
$Label1 = GUICtrlCreateLabel( "Clipboard Tool", 350, 10, 70, 20)

;; Menu
$m1 = guictrlcreatemenu( "File")
$m2 = guictrlcreatemenu( "About")
$sm1 = GUICtrlCreateMenuitem("Exit", $m1)
$sm2 = GUICtrlCreateMenuitem("Help", $m2)
$sm3 = GUICtrlCreateMenuitem("Version", $m2)
$sm4 = GUICtrlCreateMenuitem("Clear Clipboard", $m1)
$sm5 = GUICtrlCreateMenuitem("Credits", $m2)
;; Other
$cg = ClipGet()

;; While
GuiSetState()
While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $sm1
		Exit
	Case $msg = $sm2
	    MsgBox(0,"Help","Just Put In And CLick The Button" & @CRLF)
	Case $msg = $sm3
		MsgBox(0,"Clipboard Tool v1.0","Clipboard Version 1.0" & @CRLF & "© M8 Entetainment" & @CRLF & "By Str!ke")	
	Case $msg = $b1
		ask()	
		clipput(GUICtrlRead($in1))	
	Case $msg = $sm4
		ClipPut("")
	Case $msg = $sm5
		MsgBox(0,"Credits","Credits:" & @CRLF & "Jaenster - Helping Me Alot" & @CRLF & "Autoit Crew - Making Such A Good Lang")
	Case Else

	EndSelect
WEnd

Exit
