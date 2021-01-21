#include <GUIConstants.au3>
#Include <GuiListView.au3>
#Include <Date.au3>


GUICreate("listview items",220,250, 100,200,-1,$WS_EX_ACCEPTFILES)
GUISetBkColor (0x00E0FFFF) ; will change background color
$lable = GUICtrlCreateLabel ( "",-1,200, 200)
$lable1 = GUICtrlCreateLabel ( "",-1,220, 200)

$listview = GuiCtrlCreateListView ("col1  |col2|col3  ",10,10,200,150);,$LVS_SORTDESCENDING)
$button = GuiCtrlCreateButton ("Value?",75,170,70,20)

GuiCtrlSetState(-1,$GUI_DROPACCEPTED)  ; to allow drag and dropping
GuiSetState()

For $aa = 0 To 2599 
        GUICtrlCreateListViewItem("item" & Mod($aa, 100) + 1, $listview)
Next

Dim $B_DESCENDING[_GUICtrlListViewGetSubItemsCount ($listview) ]

Do
  $msg = GuiGetMsg ()
     
   Select
      Case $msg = $button
        _GUICtrlListViewSort($listview,$B_Descending, 0)
        _deleteduplicate()
      Case $msg = $listview
         MsgBox(0,"listview", "clicked="& GuiCtrlGetState($listview),2)
   EndSelect
Until $msg = $GUI_EVENT_CLOSE
Func _deleteduplicate()
    $time1 = _NowTime(3)
    $count = _GUICtrlListViewGetItemCount($listview)
    GUICtrlSetData($lable1, $count)
    For $x =$count - 1 To 0 step -1
        GUICtrlSetData($lable, "X is " & $x & " New count " & $count)        
        $Itemtxt1 = _GUICtrlListViewGetItemText($listview, $x, 0);,"listview items")
        do
if $x>0 then
            $Itemtxt2 = _GUICtrlListViewGetItemText($listview, $x- 1 , 0);,"listview items")
            If StringUpper($Itemtxt1) = StringUpper($Itemtxt2) Then
                _GUICtrlListViewDeleteItem($listview, $x- 1)
                $count -= 1
                $x -= 1
                GUICtrlSetData($lable, "X is " & $x & " New count " & $count)
            EndIf
           EndIf
            until  StringUpper($Itemtxt1)<>StringUpper($Itemtxt2) or $x = 0
    Next
    MsgBox(0, "time", "First time " & $time1 & " Second time " & _NowTime(3))  
EndFunc   
