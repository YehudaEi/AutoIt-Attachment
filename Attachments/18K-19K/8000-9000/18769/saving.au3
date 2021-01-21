#include <GUIConstants.au3>
#include <file.au3>
#include <Array.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <Date.au3>

Opt("GUIDataSeparatorChar",",")
Opt("GUICloseOnESC", 1)         
Opt("GUIOnEventMode", 1)

Dim $Items_Array
Local $Result = 1, $CurSel = 0, $Selected = 1, $String, $msg = 1

Global Const $WM_NOTIFY = 0x004e
Global $ItemSelected   = False
Global Const $LVN_ITEMCHANGED = 0xFFFFFF9B
Global $ListView1

$Counter3 = _FileCountLines("ribbon.csv")
	
GUICreate("Saving") 

$radio1 = GUICtrlCreateRadio ("Pending", 16, 20, 120, 20)
$radio2 = GUICtrlCreateRadio ("Completed", 16, 40, 120, 20)
$Show_List = GUICtrlCreateButton ("ShowList",180,30,120,25)
	$Search_Grp = GUICtrlCreateGroup("Status", 10, 4, 140, 80)
$Text = GUICtrlCreateInput ( "  ", 16, 100, 300, 80)
$Note = GUICtrlCreateLabel ("Add Notes", 260,80,90,20)
$C_Branch = GUICtrlCreateCombo ("Select Branch", 16,190, 200,55)
	GUICtrlSetData($C_Branch , "RockTown,Central Ice,Mountaineer Peepz,Pacific Village,Summer Fields")
$C_Dept = GUICtrlCreateCombo ("Contact Person", 16,220, 140,25)
	GUICtrlSetData($C_Dept, "Acct Person,IT Person, Payroll Staff, Secretaty")
$ListView1 = GUICtrlCreateListView("Ribbon Delivery,Branch Transfer,Deliver To,Status,Notes", 10,250,380,100)
	$Btn_Save = GUICtrlCreateButton ("Save", 120,360, 80,20)
		GUICtrlSetOnEvent( $Btn_Save, "Save")
$Btn_Exit = GUICtrlCreateButton ("Exit", 210,360, 80,20)
		GUICtrlSetOnEvent( $Btn_Exit, "Wclose")
	
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

;~ Func Save()- I NEED TO PUT AN ERROR MESSAGE THAT ALL ENTRIES ARE REQUIRED TO FILL IN BEFORE SAVING.. 
; I NEED TO USE A CONDITIONAL SCRIPT THAT ITEMS CAN ONLY BE SAVED IF STATUS, NOTES, BRANCH & CONTACT PERSON ARE ALL FILLED IN
Func Save()
	$Get_Notes = GUICtrlRead($Text)
		$Get_Branch = GUICtrlRead($C_Branch)
		$Get_Radio = GUICtrlRead($GUI_CHECKED)
	FileOpen ("ribbon.csv",2)
	FileClose ("ribbon.csv")
	_FileWriteFromArray("ribbon.csv", $Items_Array)
	;conditional statement here...
	MsgBox(0,"Save","all required field should be filled in first before saving",3)
EndFunc		

Func Wclose()
	Exit
EndFunc
	