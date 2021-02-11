;NewGUI
#include <GUIConstantsEx.au3>
#include "GUIExtender.au3"
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>

;Global $win_1, $win_2, $win_3, $win_4

; Create GUI window
$win_1 = GUICreate("Check List Generator = powered by BlueLord", 365, 445,-1,-1,$WS_BORDER)

; Initialise UDF
_GUIExtender_Init($win_1)


$iQuickMenu_Section = _GUIExtender_Section_Start(0, 140)
;GUICtrlCreateLabel("iQuickMenu_Section.", 10, 60, 105, 20)

$print_selc_group = GUICtrlCreateGroup("Print Mode . . .", 10, 20, 140, 65);*
GUIStartGroup("Print Mode . . .")
$prt_full = GUICtrlCreateRadio("Complete Print", 20, 35, 100, 20)
GUICtrlSetTip(-1,"Print Complet '","Full Print Mode",1)
$prt_indv = GUICtrlCreateRadio("Individual Print", 20, 60, 100, 20)
GUICtrlSetTip(-1,"Print Individual","Individual Print Mode",1)
GUICtrlSetState($prt_full, $GUI_CHECKED)

$print_selc_group = GUICtrlCreateGroup("Print", 210, 20, 140, 65);*
GUIStartGroup("Print . . .")
$Print_Button = GUICtrlCreateButton("Print", 250, 35, 70, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", 252)
GUICtrlSetTip($Print_Button,"Print Your Selection","Print!",1)

_GUIExtender_Section_Action($iQuickMenu_Section + 1)
_GUIExtender_Section_End()

$iMMenu_Section = _GUIExtender_Section_Start(170, 50)
$g_section_but = _GUIExtender_Section_Action($iMMenu_Section + 1, "g", "g", 20, 135, 95, 20, 1)
$u_section_but = _GUIExtender_Section_Action($iMMenu_Section + 2, "u", "u", 120, 135, 95, 20, 1)
$a_section_but = _GUIExtender_Section_Action($iMMenu_Section + 3, "a", "a", 220, 135, 95, 20, 1)
_GUIExtender_Section_End()


$iGMenu_Section = _GUIExtender_Section_Start(260, 70)
$m_g_group = GUICtrlCreateGroup("G", 10, 205, 340, 70)
_GUIExtender_Section_End()


$iUMenu_Section = _GUIExtender_Section_Start(320, 70)
$m_u_group = GUICtrlCreateGroup("U", 10, 265, 340, 70)
_GUIExtender_Section_End()


$iAMenu_Section = _GUIExtender_Section_Start(380, 70)
$m_a_group = GUICtrlCreateGroup("A", 10, 325, 340, 70)
_GUIExtender_Section_End()


$iSettingMenu_Section = _GUIExtender_Section_Start(430, 30)

$setting2 = GUICtrlCreateGroup("Settings", 10, 380, 140, 60);*
$helpgroup = GUICtrlCreateGroup("_?_", 210, 380, 140, 60);*


GUIStartGroup("Settings")
$prt_set = GUICtrlCreateButton("", 20, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", 1007)
GUICtrlSetTip(-1,"Change Printer Settings","Printer Settings",1)
$full_set = GUICtrlCreateButton("", 60, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", -145)
GUICtrlSetTip(-1,"Settings","Settings",1)
$ini_set = GUICtrlCreateButton("", 100, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", -132);-132
GUICtrlSetTip(-1,"Delete","Delete",1)

GUIStartGroup("_?_")
$about_prg = GUICtrlCreateButton("", 220, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", -278) ;-28
GUICtrlSetTip(-1,"Info","About",1)
$help_prg = GUICtrlCreateButton("", 260, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", -155) ;-155
GUICtrlSetTip(-1,"Help","Help",1)
$exit_prg = GUICtrlCreateButton("", 300, 395, 40, 40, $BS_ICON)
GUICtrlSetImage(-1, "shell32.dll", -28);-278
GUICtrlSetTip(-1,"Close program","Exit",1)

_GUIExtender_Section_End()


GUICtrlCreateGroup("", -99, -99, 1, 1)

; Retract all extendable sections
_GUIExtender_Section_Extend(0, False)

GUISetState()



While 1

	$iMsg = GUIGetMsg()
	; Check for normal AutoIt controls



	Switch $iMsg
	Case  $GUI_EVENT_CLOSE, $exit_prg
			Exit

    Case  $Print_Button
       _DublePrintButton_Action($iMsg)
	Case   $prt_full
			If BitAND(GUICtrlRead($prt_full), $GUI_CHECKED) = $GUI_CHECKED Then
				_GUIExtender_Section_Extend(0, False)
				GUICtrlSetState($prt_indv, $GUI_UNCHECKED)
			Else
				_GUIExtender_Section_Extend($iMMenu_Section)
				GUICtrlSetState($prt_full, $GUI_UNCHECKED)
			EndIf
	Case  $prt_indv
			If BitAND(GUICtrlRead($prt_indv), $GUI_CHECKED) = $GUI_CHECKED Then
				_GUIExtender_Section_Extend($iMMenu_Section)
				GUICtrlSetState($prt_full, $GUI_UNCHECKED)
			Else
				_GUIExtender_Section_Extend($iMMenu_Section, False)
				GUICtrlSetState($prt_indv, $GUI_UNCHECKED)
			EndIf


	EndSwitch
	; Check for GUIExtender controls
	_GUIExtender_Action($iMsg)

	If _GUIExtender_Section_State($iMMenu_Section) = 0 And BitAND(GUICtrlRead($prt_indv), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($prt_indv, $GUI_CHECKED)
	ElseIf _GUIExtender_Section_State($iMMenu_Section) = 1 And BitAND(GUICtrlRead($prt_full), $GUI_CHECKED) <> $GUI_CHECKED Then
		GUICtrlSetState($prt_full, $GUI_UNCHECKED)
	EndIf

	If _GUIExtender_Section_State($iGMenu_Section) = 0 And BitAND(GUICtrlRead($g_section_but), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($g_section_but, $GUI_UNCHECKED)
	ElseIf _GUIExtender_Section_State($iGMenu_Section) = 1 And BitAND(GUICtrlRead($g_section_but), $GUI_CHECKED) <> $GUI_CHECKED Then
		GUICtrlSetState($g_section_but, $GUI_CHECKED)
	EndIf


	If _GUIExtender_Section_State($iUMenu_Section) = 0 And BitAND(GUICtrlRead($u_section_but), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($u_section_but, $GUI_UNCHECKED)
	ElseIf _GUIExtender_Section_State($iUMenu_Section) = 1 And BitAND(GUICtrlRead($u_section_but), $GUI_CHECKED) <> $GUI_CHECKED Then
		GUICtrlSetState($u_section_but, $GUI_CHECKED)
	EndIf


	If _GUIExtender_Section_State($iAMenu_Section) = 0 And BitAND(GUICtrlRead($a_section_but), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetState($a_section_but, $GUI_UNCHECKED)
	ElseIf _GUIExtender_Section_State($iAMenu_Section) = 1 And BitAND(GUICtrlRead($a_section_but), $GUI_CHECKED) <> $GUI_CHECKED Then
		GUICtrlSetState($a_section_but, $GUI_CHECKED)
	EndIf

WEnd



Func _DublePrintButton_Action($iMsg)

	If 		GUICtrlRead($prt_indv) = 1 Then
			MsgBox(0,"Individual Print Mode","OK - Individual Print")
		Else
			MsgBox(0,"Complete Print Mode","OK - Complete Print")
	EndIf

EndFunc
