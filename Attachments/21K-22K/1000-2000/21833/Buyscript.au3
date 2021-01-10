#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>

Opt('MustDeclareVars', 1)

_Main()

Func _Main()
	Local $m4, $scout, $clarion, $bull, $kriegauto, $awp, $para, $tec, $mp5, $ump, $p90, $leone, $leoneauto
	Local $clock, $tactical, $compact, $deagle, $dual
	Local $he, $flash1, $flash2, $smoke
	
	
	
	GUICreate("IRC-Bot - Lynch, Killing-Eye & bloC", 450, 500)
	
	
	GuiCtrlCreateGroup("Primär Waffen", 9, 28, 130, 370)
	$m4 = GuiCtrlCreateRadio("M4A1 / AK", 12, 40, 80)
	$clarion = GuiCtrlCreateRadio("Clarion", 12, 60, 80)
	$scout = GuiCtrlCreateRadio("Scout", 12, 80, 80)
	$bull = GuiCtrlCreateRadio("Bullpup / Krieg", 12, 100, 80)
	$kriegauto = GuiCtrlCreateRadio("Krieg Auto", 12, 120, 80)
	$awp = GuiCtrlCreateRadio("Magnum", 12, 140, 80)
	$para = GuiCtrlCreateRadio("M249 Para", 12, 160, 80)
	$tec = GuiCtrlCreateRadio("Schmidt /Tec", 12, 180, 80)
	$mp5 = GuiCtrlCreateRadio("MP5", 12, 200, 80)
	$ump = GuiCtrlCreateRadio("UMP45", 12, 220, 80)
	$p90 = GuiCtrlCreateRadio("P90", 12, 240, 80)
	$leone = GuiCtrlCreateRadio("Leone 12", 12, 260, 80)
	$leoneauto = GuiCtrlCreateRadio("Leone Auto", 12, 280, 80)
	GUICtrlCreateGroup ("Primärwaffen",-99,-99,1,1)  ;close group
	
	
	GuiCtrlCreateGroup("Sekundär Waffen", 145, 28, 130, 370)
	$clock = GuiCtrlCreateRadio("Clock", 148, 40, 80)
	$tactical = GuiCtrlCreateRadio("Tactical", 148, 60, 80)
	$compact = GuiCtrlCreateRadio("Compact", 148, 80, 80)
	$deagle = GuiCtrlCreateRadio("Deagle", 148, 100, 80)
	$dual = GuiCtrlCreateRadio("Fifeseven / Dual", 148, 120, 80)
	GUICtrlCreateGroup ("Sekundär Waffen",-99,-99,1,1)  ;close group
	
	GuiCtrlCreateGroup("Equippment", 281, 28, 130, 370)
	$he = GuiCtrlCreateCheckbox("HE", 284, 40, 80)
	$flash1 = GuiCtrlCreateCheckbox("Flash1", 284, 60, 80)
	$flash2 = GuiCtrlCreateCheckbox("Flash2", 284, 80, 80)
	$flash2 = GuiCtrlCreateCheckbox("Flash2", 284, 80, 80)
	$smoke = GuiCtrlCreateCheckbox("Smoke", 284, 100, 80)
	
	GUICtrlCreateGroup ("Equippment",-99,-99,1,1)  ;close group
	
	GUISetState()
	; Run the GUI until the dialog is closed
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
				
			Case Else
		EndSwitch
	WEnd

	GUIDelete()
EndFunc   ;==>_Main
	
	