#include <GUIConstants.au3>
#include <file.au3>
#include <GuiListView.au3>

GUICreate("listview items",220,250, 100,200,-1,$WS_EX_ACCEPTFILES)
		GUICtrlCreatePic("Datus_Iso_backdrop.jpg",0,0,100,200);show the main window
		GuiCtrlSetState(-1,$GUI_DISABLE)
GUISetBkColor (0x00E0FFFF)  ; will change background color
GUISetState()
$listview = GUICtrlCreateListView ("col1  |col2|col3  ",10,10,200,150);,$LVS_SORTDESCENDING)
$item1=GUICtrlCreateListViewItem("item2|col22|col23",$listview)
$item2=GUICtrlCreateListViewItem("item1|col12|col13",$listview)
$item3=GUICtrlCreateListViewItem("item3|col32|col33",$listview)
$AviListLocGUI2 = GuiCtrlGetHandle($listview)
_GUICtrlListView_SetBkImage  ($AviListLocGUI2,@WorkingDir & "\Datus_Iso_backdrop.jpg",1)
Do
  $msg = GUIGetMsg ()
     
   Select
      Case $msg = $listview
         MsgBox(0,"listview", "clicked="& GUICtrlGetState($listview),2)
   EndSelect
Until $msg = $GUI_EVENT_CLOSE