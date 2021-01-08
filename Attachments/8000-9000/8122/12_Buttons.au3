; *******************************************************
; Example - Create Twelve ownerdrawn/colored buttons
; *******************************************************
#include <GUIConstants.au3>
#include "GuiButton.au3"

Opt("MustDeclareVars", 1)

Global $nButton1, $nButton2, $nButton3, $nButton4, $nButton5, $nButton6, $nButton7, $nButton8, $nButton9, $nButton10, $nButton11, $nButton12

_Main()

Func _Main()
	Local $GUIMsg

	$hGUI = GUICreate("My Ownerdrawn Created Button", 700, 350)

	$nButton1 = _GuiCtrlCreateButton("Button One", 50, 50, 80, 30, 0xffff00, 0xff0000)
	$nButton2 = _GuiCtrlCreateButton("Button Two", 150, 50, 80, 30, 0x000000, 0x00ff00)
	$nButton3 = _GuiCtrlCreateButton("Button Three", 250, 50, 80, 30, 0xffffff, 0x0000ff)

	$nButton4 = _GuiCtrlCreateButton("Button  Four", 350, 50, 80, 30, 0xffff00, 0xff0000)
	$nButton5 = _GuiCtrlCreateButton("Button Five", 450, 50, 80, 30, 0x000000, 0x00ff00)
	$nButton6 = _GuiCtrlCreateButton("Button Six", 550, 50, 80, 30, 0xffffff, 0x0000ff)

	$nButton7 = _GuiCtrlCreateButton("Button Seven", 50, 100, 80, 30, 0xffff00, 0xff0000)
	$nButton8 = _GuiCtrlCreateButton("Button Eight", 150, 100, 80, 30, 0x000000, 0x00ff00)
	$nButton9 = _GuiCtrlCreateButton("Button Nine", 250, 100, 80, 30, 0xffffff, 0x0000ff)

	$nButton10 = _GuiCtrlCreateButton("Button Ten", 350, 100, 80, 30, 0xffff00, 0xff0000)
	$nButton11 = _GuiCtrlCreateButton("Button Eleven", 450, 100, 80, 30, 0x000000, 0x00ff00)
	$nButton12 = _GuiCtrlCreateButton("Button Twelve", 550, 100, 80, 30, 0xffffff, 0x0000ff)

	GUIRegisterMsg($WM_COMMAND, "MY_WM_COMMAND")
	; WM_DRAWITEM has to registered before showing GUI otherwise the initial drawing isn't done
	GUIRegisterMsg($WM_DRAWITEM, "MY_WM_DRAWITEM")

	GUISetState()

	While 1
		$GUIMsg = GUIGetMsg()

		Switch $GUIMsg
			Case $GUI_EVENT_CLOSE
				ExitLoop
		EndSwitch
	WEnd

	Exit
EndFunc   ;==>_Main

Func Button_Click(ByRef $ctrl_id)
	Switch $ctrl_id
		Case $nButton1
			MsgBox(0, "Button 1", "Button One")
		Case $nButton2
			MsgBox(0, "Button 2", "Button Two")
		Case $nButton3
			MsgBox(0, "Button 3", "Button Three")

		Case $nButton4
			MsgBox(0, "Button 4", "Button Four")
		Case $nButton5
			MsgBox(0, "Button 5", "Button Five")
		Case $nButton6
			MsgBox(0, "Button 6", "Button Six")

		Case $nButton7
			MsgBox(0, "Button 7", "Button Seven")
		Case $nButton8
			MsgBox(0, "Button 8", "Button Eight")
		Case $nButton9
			MsgBox(0, "Button 9", "Button Nine")

		Case $nButton10
			MsgBox(0, "Button 10", "Button Ten")
		Case $nButton11
			MsgBox(0, "Button 11", "Button Eleven")
		Case $nButton12
			MsgBox(0, "Button 12", "Button Twelve")
	EndSwitch
EndFunc   ;==>Button_Click

