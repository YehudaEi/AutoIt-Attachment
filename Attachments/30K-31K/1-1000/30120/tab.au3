#include <GuiConstantsEx.au3>
#include <GuiTab.au3>
#include <GuiComboBoxEx.au3>

$gui = GUICreate("Tab", 400, 200)

$tab = GUICtrlCreateTab(10, 10, 380, 180)

$t1 = GUICtrlCreateTabItem("t1")
$c1 = _GUICtrlComboBoxEx_Create($gui, "", 20, 40, 300, 300)
$b1 = GUICtrlCreateButton("button", 20, 80, 60, 22)

$t2 = GUICtrlCreateTabItem("t2")
$e1 = GUICtrlCreateEdit("", 20, 40, 300, 120, 0, 0)

GUICtrlCreateTabItem("")

GUISetState()

while(true)
   switch GUIGetMsg()
     Case $GUI_EVENT_CLOSE
          exit
   endswitch
wend
