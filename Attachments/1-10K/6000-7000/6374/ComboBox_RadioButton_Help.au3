#include <GuiConstants.au3>

GUICreate("ComboBox RadioButton Help", 275, 120,)
;here is your combo box
$Combo_1 = GUICtrlCreateCombo("", 50, 10, 150, 21)
GUICtrlSetData($Combo_1, 'Google')
$Button1 = GUICtrlCreateButton('GO', 75, 35, 100, 17)
;here is your radio buttons
$Radio1 = GuiCtrlCreateRadio("Firefox", 50, 75, 180)
GuiCtrlSetState(-1, $GUI_CHECKED)
$Radio2 = GuiCtrlCreateRadio("Internet Explorer", 50, 95, 180)
GUISetState()

While 1
     $MainMsg = GUIGetMsg()
     Select
         Case $MainMsg = $GUI_EVENT_CLOSE
             Exit
         Case $MainMsg = $Button1 ; use if()and()then to combine the 2.
             If GUICtrlRead($Radio1) = 1 and GUICtrlRead($Combo_1) = 'Google' Then Run('"C:\Program Files\Mozilla Firefox\firefox.exe" www.google.com')
             If GUICtrlRead($Radio2) = 1 and GUICtrlRead($Combo_1) = 'Google' Then Run('"C:\Program Files\Internet Explorer\IExplore.exe" www.google.com')

    EndSelect	 
WEnd