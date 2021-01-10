#include"functions.au3"
#include <GUIConstants.au3>
; == GUI generated with Koda ==
$i=1
$e=0
Dim $ascout,$hexout
$Form1 = GUICreate("Read hex and asc", 164, 292, 192, 125)
$Group1 = GUICtrlCreateGroup("ASC code", 16, 104, 129, 81)
$Input2 = GUICtrlCreateInput("", 48, 128, 57, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetLimit($Input2, 3)
$Button2 = GUICtrlCreateButton("Convert to HEX", 40, 160, 81, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("HEX code", 16, 192, 129, 65)
$Input3 = GUICtrlCreateInput("", 48, 208, 57, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetLimit($Input3, 2)
$Button3 = GUICtrlCreateButton("Convert to ASC", 40, 232, 81, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group3 = GUICtrlCreateGroup("TEXT code", 16, 32, 129, 65)
$Input1 = GUICtrlCreateInput("A", 48, 48, 57, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetLimit($Input1, 1)
$Button1 = GUICtrlCreateButton("Convert TEXT", 40, 72, 81, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)



While 1
	$msg = GuiGetMsg()
	Select
		Case $msg = $GUI_EVENT_CLOSE
			MsgBox(0,"Thank You","Thank you for intrest in this program by kcdclan")
		ExitLoop
	Case $msg = $Button1
		$text=GUICtrlRead ($Input1 )
		$asc=Asc($text)
		$hex=_ASC2HEX($asc)
		GUICtrlSetData($Input2,$asc)
		GUICtrlSetData($Input3,$hex)
	Case $msg = $Button2
		$text=GUICtrlRead ($Input2 )
		$hex=_ASC2HEX($text)
		GUICtrlSetData($Input1,"")
		GUICtrlSetData($Input3,$hex)
	Case $msg = $Button3
			$text=GUICtrlRead ($Input3 )
			$asc=_HEX2ASC($text)
		GUICtrlSetData($Input1,"")
		GUICtrlSetData($Input2,$asc)
	Case Else
		;;;;;;;
	EndSelect
WEnd
Exit

