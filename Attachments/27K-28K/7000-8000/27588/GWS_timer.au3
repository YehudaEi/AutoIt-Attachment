#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <misc.au3>

;Opt('MustDeclareVars', 1)

	Local $progressbar1, $progressbar2, $progressbar3, $progressbar4 ,$progressbar5 ,$progressbar6,$progressbar7,$progressbar8 ,$wait, $s, $t1, $t2, $t3, $t4, $t5, $t6, $t7, $t8, $msg, $dll
	$dll = DllOpen("user32.dll")

	GUICreate("Skill timer", 320, 280, -1,-1)

	GUICtrlCreateLabel("Skill 1", 10, 15, 70, 20)
	$progressbar1 = GUICtrlCreateProgress(60, 10, 200, 20, $PBS_SMOOTH)
	$t1 = guictrlcreatelabel("60", 270, 15, 40, 20)
	$e1 = guictrlcreatebutton("e", 295, 10, 20, 20)

	GUICtrlCreateLabel("Skill 2", 10, 45, 70, 20)
	$progressbar2 = GUICtrlCreateProgress(60, 40, 200, 20, $PBS_SMOOTH)
	$t2 = guictrlcreatelabel("60", 270, 45, 40, 20)
	$e2 = guictrlcreatebutton("e", 295, 40, 20, 20)

	GUICtrlCreateLabel("Skill 3", 10, 75, 70, 20)
	$progressbar3 = GUICtrlCreateProgress(60, 70, 200, 20, $PBS_SMOOTH)
	$t3 = guictrlcreatelabel("60", 270, 75, 40, 20)
	$e3 = guictrlcreatebutton("e", 295, 70, 20, 20)

	GUICtrlCreateLabel("Skill 4", 10, 105, 70, 20)
	$progressbar4 = GUICtrlCreateProgress(60, 100, 200, 20, $PBS_SMOOTH)
	$t4 = guictrlcreatelabel("60", 270, 105, 40, 20)
	$e4 = guictrlcreatebutton("e", 295, 100, 20, 20)

	GUICtrlCreateLabel("Skill 5", 10, 135, 70, 20)
	$progressbar5 = GUICtrlCreateProgress(60, 130, 200, 20, $PBS_SMOOTH)
	$t5 = guictrlcreatelabel("60", 270, 135, 40, 20)
	$e5 = guictrlcreatebutton("e", 295, 130, 20, 20)

	GUICtrlCreateLabel("Skill 6", 10, 165, 70, 20)
	$progressbar6 = GUICtrlCreateProgress(60, 160, 200, 20, $PBS_SMOOTH)
	$t6 = guictrlcreatelabel("60", 270, 165, 40, 20)
	$e6 = guictrlcreatebutton("e", 295, 160, 20, 20)

	GUICtrlCreateLabel("Skill 7", 10, 195, 70, 20)
	$progressbar7 = GUICtrlCreateProgress(60, 190, 200, 20, $PBS_SMOOTH)
	$t7 = guictrlcreatelabel("60", 270, 195, 40, 20)
	$e7 = guictrlcreatebutton("e", 295, 190, 20, 20)

	GUICtrlCreateLabel("Skill 8", 10, 225, 70, 20)
	$progressbar8 = GUICtrlCreateProgress(60, 220, 200, 20, $PBS_SMOOTH)
	$t8 = guictrlcreatelabel("60", 270, 225, 40, 20)
	$e8 = guictrlcreatebutton("e", 295, 220, 20, 20)

	GUISetState()

	$wait = 800
	$s = 0
	guictrlsetdata($progressbar1, guictrlread($t1))
	guictrlsetdata($progressbar2, guictrlread($t2))
	guictrlsetdata($progressbar3, guictrlread($t3))
	guictrlsetdata($progressbar4, guictrlread($t4))
	guictrlsetdata($progressbar5, guictrlread($t5))
	guictrlsetdata($progressbar6, guictrlread($t6))
	guictrlsetdata($progressbar7, guictrlread($t7))
	guictrlsetdata($progressbar8, guictrlread($t8))

	while 1

	$msg = GUIGetMsg()
	switch $msg
		case $msg = _IsPressed(31, $DLL)
			For $i = $s To guictrlread($t1)
					$s = 0
					GUICtrlSetData($progressbar1, (guictrlread($t1) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar1, guictrlread($t1))

		case $msg = _IsPressed(32, $DLL)
			For $i = $s To guictrlread($t2)
					$s = 0
					GUICtrlSetData($progressbar2, (guictrlread($t2) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar2, guictrlread($t2))
		case $msg = _IsPressed(33, $DLL)
			For $i = $s To guictrlread($t3)
					$s = 0
					GUICtrlSetData($progressbar3, (guictrlread($t3) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar3, guictrlread($t3))
		case $msg = _IsPressed(34, $DLL)
			For $i = $s To guictrlread($t4)
					$s = 0
					GUICtrlSetData($progressbar4, (guictrlread($t4) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar4, guictrlread($t4))
		case $msg = _IsPressed(35, $DLL)
			For $i = $s To guictrlread($t5)
					$s = 0
					GUICtrlSetData($progressbar5, (guictrlread($t5) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar5, guictrlread($t5))
		case $msg = _IsPressed(36, $DLL)
			For $i = $s To guictrlread($t6)
					$s = 0
					GUICtrlSetData($progressbar6, (guictrlread($t6) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar6, guictrlread($t6))
		case $msg = _IsPressed(37, $DLL)
			For $i = $s To guictrlread($t7)
					$s = 0
					GUICtrlSetData($progressbar7, (guictrlread($t7) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar7, guictrlread($t7))
		case $msg = _IsPressed(38, $DLL)
			For $i = $s To guictrlread($t8)
					$s = 0
					GUICtrlSetData($progressbar8, (guictrlread($t8) - $i))
					Sleep($wait)
			Next
			guictrlsetdata($progressbar8, guictrlread($t8))

		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
	WEnd
