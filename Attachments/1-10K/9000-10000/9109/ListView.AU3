#include <GUIConstants.au3>

GUICreate("listview items",460,350, 100,200,-1,$WS_EX_ACCEPTFILES)
GUISetBkColor (0x00E0FFFF)  ; will change background color

$listview = GuiCtrlCreateListView ("col1  ",10,10,200,150);,$LVS_SORTDESCENDING)

$item1=GuiCtrlCreateListViewItem("item1",$listview)
$item2=GuiCtrlCreateListViewItem("item2",$listview)
$item3=GuiCtrlCreateListViewItem("item3",$listview)
$item4=GuiCtrlCreateListViewItem("item4",$listview)
$item5=GuiCtrlCreateListViewItem("item5",$listview)
$item6=GuiCtrlCreateListViewItem("item6",$listview)
$item7=GuiCtrlCreateListViewItem("item7",$listview)
$item8=GuiCtrlCreateListViewItem("item8",$listview)
$item9=GuiCtrlCreateListViewItem("item9",$listview)

GuiCtrlSetState(-1,$GUI_DROPACCEPTED)   ; to allow drag and dropping

$listviewB = GuiCtrlCreateListView ("col2  ",10,180,200,150);,$LVS_SORTDESCENDING)
$itemB1=GuiCtrlCreateListViewItem("item2",$listviewB)
$itemB2=GuiCtrlCreateListViewItem("item1",$listviewB)
$itemB3=GuiCtrlCreateListViewItem("item3",$listviewB)

$listviewC = GuiCtrlCreateListView ("col3  ",220,10,200,150);,$LVS_SORTDESCENDING)
GuiSetState()

Do
  $msg = GuiGetMsg ()
     
   Select
      
      Case $msg = $listview
         MsgBox(0,"listview", "clicked="& GuiCtrlGetState($listview),2)
   EndSelect
Until $msg = $GUI_EVENT_CLOSE
