#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

_Main()

Func _Main()
    Local $button1
    Local $output, $die, $msg, $results1, $results2, $results3, $results4, $results5, $results6
    GUICreate("random item stats", 700, 180, -1, -1)

    $button1 = GUICtrlCreateButton("Generate", 150, 90, 50, 30)
    $output1 = GUICtrlCreateInput("", 60, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	$output2 = GUICtrlCreateInput("", 130, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	$output3 = GUICtrlCreateInput("", 200, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	$output4 = GUICtrlCreateInput("", 270, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	$output5 = GUICtrlCreateInput("", 340, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
	$output6 = GUICtrlCreateInput("", 410, 60, 60, 20, BitOR($ES_CENTER, $ES_READONLY))
    $die = GUICtrlCreateLabel("", 905, 120, 70, 20, $SS_SUNKEN)
    GUICtrlSetFont($output, 8, 800, "", "Comic Sans MS")

    GUISetState()

    ; Run the GUI until the dialog is closed
    While 1
		$msg = GUIGetMsg()
		Select
			Case $msg = $button1
				$results1 = Random(1, 10, 1)
				GUICtrlSetData($output1, $results1)
				GUICtrlSetData($die, "2 Sided Die")
				$results2 = Random(1, 3, 1)
				GUICtrlSetData($output2, $results2)
				GUICtrlSetData($die, "3 Sided Die")
				$results3 = Random(1, 4, 1)
				GUICtrlSetData($output3, $results3)
				GUICtrlSetData($die, "4 Sided Die")
				$results4 = Random(1, 6, 1)
				GUICtrlSetData($output4, $results4)
				GUICtrlSetData($die, "6 Sided Die")
				$results5 = Random(1, 8, 1)
				GUICtrlSetData($output5, $results5)
				GUICtrlSetData($die, "8 Sided Die")
				$results6 = Random(1, 10, 1)
				GUICtrlSetData($output6, $results6)
				GUICtrlSetData($die, "10 Sided Die")

		EndSelect
		If $msg = $GUI_EVENT_CLOSE Then ExitLoop
	WEnd
EndFunc   ;==>_Main