#include <GUIConstants.au3>
Dim $NewGUI = 0

Dim $avArray[8]
$avArray[0] = 7
$avArray[1] = "Brian"
$avArray[2] = "Jon"
$avArray[3] = "Larry"
$avArray[4] = "Christa"
$avArray[5] = "Rick"
$avArray[6] = "Jack"
$avArray[7] = "Gregory"

$MainGUI = GUICreate(" Map Editor", 205,200,-1,-1)
$Exit = GUICtrlCreateButton("Exit",10,90,55,20)
$New = GUICtrlCreateButton("New",75,90,55,20)
$DelCombo = GUICtrlCreateButton("Reload",140,90,55,20)
$Combo_3 = GuiCtrlCreateCombo(" ", 20, 20, 160, 20)
for $i = 1 to $avArray[0]
GUICtrlSetData($Combo_3, $avArray[$i])
next
GUISetState()

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = -3
            Exit
        Case $msg = $DelCombo
			GUICtrlDelete($Combo_3)
			$Combo_3 = GuiCtrlCreateCombo(" ", 20, 20, 160, 20)
			for $i = 1 to $avArray[0]
				GUICtrlSetData($Combo_3, $avArray[$i])
			next
			GUISetState()
		Case $msg = $Exit
            Exit
        Case $msg = $New
			$Form1 = GUICreate("New", 100, 100, -1,-1,-1,$WS_EX_TOPMOST,$MainGUI)
            $Button_4 = GUICtrlCreateButton("Cancel", 10, 40, 80, 20)
			GUISetState(@SW_SHOW)
			 While 1
                $msg = GuiGetMsg()
                Select
                Case $msg = -3  
                    ExitLoop
                Case $msg = $Button_4  
                    ExitLoop
                EndSelect
            WEnd
            GUIDelete($Form1)
    EndSelect
WEnd

