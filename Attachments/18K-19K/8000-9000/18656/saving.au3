#include <GUIConstants.au3>
Opt("GUIDataSeparatorChar",",")
#include <file.au3>

GUICreate("Saving") 

$radio1 = GUICtrlCreateRadio ("Radio 1", 16, 20, 120, 20)
$radio2 = GUICtrlCreateRadio ("Radio 2", 16, 40, 120, 20)
$Search_Grp = GUICtrlCreateGroup("Status", 10, 4, 140, 80)
;$Label1= GUICtrlCreateLabel("STATUS ",16,60, 120, 20)
$Text = GUICtrlCreateInput ( "  ", 16, 100, 160, 80)
$Note = GUICtrlCreateLabel ("Add Notes", 120,85,50,20)
$C_Branch = GUICtrlCreateCombo ("Select Branch", 16,190, 200,55)
	GUICtrlSetData($C_Branch , "RockTown,Central Ice,Mountaineer Peepz,Pacific Village,Summer Fields")
$C_Dept = GUICtrlCreateCombo ("Contact Person", 16,220, 140,25)
	GUICtrlSetData($C_Dept, "Acct Person,IT Person, Payroll Staff, Secretaty")
$ListView1 = GUICtrlCreateListView("Ribbon,Delivery,Branch,Transfer,Deliver To,Status,Notes", 10,250,380,100)
	;$Can= GUICtrlCreateListViewItem($ListView1,"RockTown,Acct Person,Deliver To,Status,2 boxes receiving")
$Btn_Save = GUICtrlCreateButton ("Save", 100,360, 90,20)

		;GUICtrlSetOnEvent( $Btn_Save, "Save")
GUISetState(@SW_SHOW)

While 1
    $msg = GUIGetMsg() 
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
			$msg = $GUI_CHECKED
         Case $msg = $radio1 And BitAND(GUICtrlRead($radio1), $GUI_CHECKED) = $GUI_CHECKED
             $Label1=GUICtrlCreateLabel("Pending",30,60, 100, 20)
 			Case $msg = $radio2 And BitAND(GUICtrlRead($radio2), $GUI_CHECKED) = $GUI_CHECKED
             $Label1 = GUICtrlCreateLabel("Completed",30,60, 100, 20)
    EndSelect
Wend


;~ Func Save()
;~ 	Dim $Add_Text, $Click, $Get_Idx = 0, $File, $Updated_Item
;~ 	GUISetState(@SW_DISABLE)
;~ 	
;~ 	$Add_Text = GUICtrlRead($Text)
;~ 	$Click = GuiCtrlRead($GUI_CHECKED)
	