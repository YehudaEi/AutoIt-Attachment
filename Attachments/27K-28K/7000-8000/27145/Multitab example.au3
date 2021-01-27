
Opt("MustDeclareVars", 1)
Global $aRadio[11] = [10],$Radio,$Gui,$Tab1, $Tab2

$Gui = GUICreate("Title", 200, 200)
Local $go = GUICtrlCreateButton("Go", 0, 150, 200, 50, 0x0F00)
Local $tab = GUICtrlCreateTab(0, 0, 200, 150)

$Tab1 = GUICtrlCreateTabItem("One")
$Tab2 = GUICtrlCreateTabItem("Two")
GUICtrlCreateTabItem("")
GUISwitch($Gui,$tab1)
$aRadio[01] = GUICtrlCreateRadio("01", 9, 33, 180, 20)
$aRadio[02] = GUICtrlCreateRadio("02", 9, 53, 180, 20)
$aRadio[03] = GUICtrlCreateRadio("03", 9, 73, 180, 20)
$aRadio[04] = GUICtrlCreateRadio("04", 9, 93, 180, 20)
$aRadio[05] = GUICtrlCreateRadio("05", 9, 113, 180, 20)

GUISwitch($Gui,$tab2)
$aRadio[06] = GUICtrlCreateRadio("06", 9, 33, 180, 20)
$aRadio[07] = GUICtrlCreateRadio("07", 9, 53, 180, 20)
$aRadio[08] = GUICtrlCreateRadio("08", 9, 73, 180, 20)
$aRadio[09] = GUICtrlCreateRadio("09", 9, 93, 180, 20)
$aRadio[10] = GUICtrlCreateRadio("10", 9, 113, 180, 20)
$Radio = 0

GUISetState(@SW_SHOW)

While 1
    Local $msg = GUIGetMsg()
    Select
        Case $msg = -3
            Exit
        Case $msg = $go
            Go()
        Case $msg >=$aRadio[1] and $msg <= $aRadio[10]
            GUICtrlSetState($Radio, 4)
            GUICtrlSetState($msg, 5);$GUI_CHECKED)
            $Radio = $msg
    EndSelect
    
WEnd

Func Go()
    For $i = 1 To 10
        If GUICtrlRead($aRadio[$i]) = 1 Then MsgBox(0,"",ControlGetText("Title", "", $aRadio[$i]))
    Next
EndFunc