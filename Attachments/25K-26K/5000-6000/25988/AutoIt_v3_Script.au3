#include <GUIConstantsEx.au3>
#include <color.au3>


GUICreate("AGLONA Party 2009", 800, 520)
Opt("MustDeclareVars", 1)

Staff()
Func Staff()
	Local $CheckBox1, $CheckBox2, $CheckBox3, $CheckBox4, $CheckBox5, $CheckBox6, $msg

	GUICtrlCreateGroup("Tusovka", 45, 30, 210, 260)
	GUISetBkColor(0x00E0FFFF)
	$CheckBox1 = GUICtrlCreateCheckbox("Oleg", 70, 45, 100, 45)
	$CheckBox2 = GUICtrlCreateCheckbox("Romanich", 70, 75, 100, 45)
	$CheckBox3 = GUICtrlCreateCheckbox("Zenjka", 70, 105, 100, 45)
	$CheckBox4 = GUICtrlCreateCheckbox("Shurik", 70, 135, 100, 45)
	$CheckBox5 = GUICtrlCreateCheckbox("Petro", 70, 165, 100, 45)
	$CheckBox6 = GUICtrlCreateCheckbox("Pashka", 70, 195, 100, 45)
	GUICtrlSetColor(-1, 0xff0000)


EndFunc   ;==>Staff

Pitanie()
Func Pitanie()
	Local $msg
	GUICtrlCreateGroup("Rasschet produktov", 300, 30, 480, 260)

	GUISetState()

	While 1
		$msg = GUIGetMsg()
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop

	WEnd
EndFunc   ;==>Pitanie