#include<embedswfxmlchart.au3>
#include <guiconstants.au3>

$GUI = GUICreate("SWF Chart Example 2 - 3D graphs", 600, 600, -1, -1)
GUISetBkColor (0x000000)
GUISetState(@SW_SHOW)


;EXAMPLE 1: Generate from file
$chart1 = _CreateSWFChart(@ScriptDir &'\Gallery_Stacked_3D_Column_2.xml', 0,0,600,300)

;EXAMPLE 2: Generate from file
$chart2 = _CreateSWFChart(@ScriptDir &'\Gallery_3D_Pie_1.xml', 0,300,600,300)


; MAIN LOOP
While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            ExitLoop
    EndSwitch
    Sleep(10)
WEnd