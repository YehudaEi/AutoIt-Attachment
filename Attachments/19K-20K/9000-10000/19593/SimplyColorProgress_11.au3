; Author : Ritzelrocker04 ==> SimplyColorProgress_1.1
#include<EditConstants.au3>
#include<GUIConstantsEx.au3>
#include<StaticConstants.au3>
#include<String.au3>

$LW = StringLeft(@ScriptDir, 3)
$srcLW = Round((DriveSpaceTotal($LW) - DriveSpaceFree($LW)) / (DriveSpaceTotal($LW) / 100), 0)

#Region ### START SimplyColorProgress GUI section ###
$GUI = GUICreate("SimplyColorProgress by Ritzelrocker04", 400, 300)
$lb = GUICtrlCreateLabel("Festplatte " & $LW, 50, 20, 100, 17)
$implyColorProgressF = GUICtrlCreateInput("II " & 100 - $srcLW & " % frei " & _StringRepeat("I", 100 - $srcLW - 13), 45, 40, 310, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xFFFBF0)
GUICtrlSetColor(-1, 0x008000); dunkelgruen
$implyColorProgressB = GUICtrlCreateInput("II " & $srcLW & " % belegt " & _StringRepeat("I", $srcLW - 15), 45, 80, 310, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xFFFBF0)
GUICtrlSetColor(-1, 0xFF0000) ; rot
$lbB1 = GUICtrlCreateLabel("II " & $srcLW & " % " & _StringRepeat("I", $srcLW - 8), 45, 120, 310, 17)
GUICtrlSetColor(-1, 0xFF0000) ; rot
$lbF1 = GUICtrlCreateLabel("II " & 100 - $srcLW & " % " & _StringRepeat("I", 100 - $srcLW - 8), 45, 145, 310, 17)
GUICtrlSetColor(-1, 0x008000); dunkelgruen
$lbB2 = GUICtrlCreateLabel(_StringRepeat("I", $srcLW), 45, 180, 155, 20, $SS_RIGHT)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0xFF0000) ; rot
$lbF2 = GUICtrlCreateLabel(_StringRepeat("I", 100 - $srcLW), 200, 180, 155, 20)
GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x008000); dunkelgruen
$implyColorProgressB = GUICtrlCreateInput(_StringRepeat("I", $srcLW / 2 - 7) & " " & $srcLW & "% belegt " & _StringRepeat("I", $srcLW / 2 - 7), 45, 220, 310, 17, BitOR($ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetBkColor(-1, 0xFFFBF0)
GUICtrlSetColor(-1, 0xFF0000) ; rot
$ButtonOk = GUICtrlCreateButton("&OK", 122, 265, 75, 22, 0)
$ButtonCancel = GUICtrlCreateButton("&Cancel", 203, 265, 75, 22, 0)

GUISetState(@SW_SHOW)
#EndRegion ### START SimplyColorProgress GUI section ###

While 1
	$msg = GUIGetMsg()
	
	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $ButtonCancel
			ExitLoop

		Case $msg = $ButtonOk
			MsgBox(0, "Info über", "SimplyColorProgress by Ritzelrocker04", 5)
			ExitLoop
	EndSelect
WEnd
