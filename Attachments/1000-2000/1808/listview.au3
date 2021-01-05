#include <GUIConstants.au3>
#include "ArrayLC.au3"
#include "ListViewUDFs.au3"

$LVM_DELETEITEM = 0x1008

Dim $filename = @ScriptDir & "\products.csv"
DIM $LV_Item[10000]

If $CmdLine[0] > 0 Then $filename = $CmdLine[1]

$GUI = GUICreate("Viewer for Search Results",1000, 700, -1, -1,$WS_THICKFRAME + $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
Global $listview = GUICtrlCreateListView ("Product|Description|ItemNr.|Type|Date",10,40,600,500)
Global $inp_lv_1 = GuiCtrlCreateInput("", 10, 10, 80, 20); Edit
Global $inp_lv_2 = GuiCtrlCreateInput("", 100, 10, 80, 20); Edit
Global $inp_lv_3 = GuiCtrlCreateInput("", 190, 10, 80, 20); Edit
Global $inp_lv_4 = GuiCtrlCreateInput("", 280, 10, 80, 20); Edit
Global $inp_lv_5 = GuiCtrlCreateInput("", 370, 10, 80, 20); Edit

$btn_edit = GuiCtrlCreateButton ("Edit",10,550,70,20)

$contextMenu = GuiCtrlCreateContextMenu($listview)
$infoitem = GUICtrlCreateMenuitem ("delete",$contextMenu)

$file = FileOpen($filename, 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open specified search results file...")
    Exit
EndIf
; Read in lines of text until the EOF is reached
While 1
    $line = FileReadLine($file)
    If @error = -1 Then ExitLoop
    GUICtrlCreateListViewItem(StringReplace($line,@TAB,"|"),$listview)
Wend
FileClose($file)


GUICtrlCreateContextMenu ()

GUISetState()

Dim $b_Descending[_GUICtrlGetListViewColsCount($listview)]

Do
    $msg = GUIGetMsg ()
    Select
    Case $msg = $infoItem
        $ItemCount = ControlListView("Viewer for Search Results", "", $listview, "GetItemCount")
        For $i = 0 To $ItemCount - 1
        	If ControlListView("Viewer for Search Results", "", $listview, "IsSelected", $i) Then
        		GuiCtrlSendMsg($listview, $LVM_DELETEITEM, $i, 0)
        		$i = $i - 1
        	EndIf
        Next
    Case $msg = $listview
        _SortListView($listview,$b_Descending,GuiCtrlGetState($listview))
    
    Case $msg = 80
    	$data =  StringSplit(GuiCtrlRead(GuiCtrlRead($listview)), "|")
	If UBound($data) >= 2 Then
	     MsgBox(0, "", $data[1] & " | " & $data[2]& " | " & $data[3]& " | " & $data[4]& " | " & $data[5]) 
        EndIf
    Case $msg = $btn_edit
    	$strSelFile = StringSplit(GUICtrlRead(GUICtrlRead($listview)),"|")
	If $strSelFile[0] > 1 Then
		GUICtrlSetData ($inp_lv_1, $strSelFile[1])
		GUICtrlSetData ($inp_lv_2, $strSelFile[2])
		GUICtrlSetData ($inp_lv_3, $strSelFile[3])
		GUICtrlSetData ($inp_lv_4, $strSelFile[4])
		GUICtrlSetData ($inp_lv_5, $strSelFile[5])
	Else
		MsgBox(2, "Fehler", "Bitte die Zeile markieren, die bearbeitet werden soll!")
	EndIf
    
    Case Else
    If $msg <> -11 AND $msg <> 0 Then
    	;MsgBox(0, "", $msg )
    EndIf
    EndSelect
Until $msg = $GUI_EVENT_CLOSE
