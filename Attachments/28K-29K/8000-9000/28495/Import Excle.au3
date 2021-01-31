#include <Excel.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>

Global $hGui = GUICreate("AutoIT",893, 600,-1,-1)
Global $hLabel = GUICtrlCreateLabel("", 55, 10, 80, 20)
Local $treeview, $monitor, $backup, $listview
Local $gs1, $gs2, $gs3, $g2
Local $insert, $excel


GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 600)


$treeview = GUICtrlCreateTreeView(10, 35, 170, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
$monitor = GUICtrlCreateTreeViewItem("Monitor System", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)
$gs1=GUICtrlCreateTreeViewItem("GS1",$monitor)
	GUICtrlSetColor(-1, 0x0000CC)
$gs2=GUICtrlCreateTreeViewItem("GS2",$monitor)
	GUICtrlSetColor(-1, 0x0000C0)
$gs3=GUICtrlCreateTreeViewItem("GS3",$monitor)
	GUICtrlSetColor(-1, 0x0000C0)
$g2=GUICtrlCreateTreeViewItem("G2",$monitor)
	GUICtrlSetColor(-1, 0x0000C0)
$backup = GUICtrlCreateTreeViewItem("BackupDB", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)


$insert = GUICtrlCreateTreeViewItem("Insert Excel", $gs1)



	GUICtrlSetState($monitor, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
    GUICtrlSetState($backup, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
	GUICtrlSetState($gs1, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
	GUICtrlSetState($gs2, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
	GUICtrlSetState($gs3, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
	GUICtrlSetState($g2, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))

	GUISetState()

	 $listview = GUICtrlCreateListView("", 200, 40, 680, 515)
	_GUICtrlListView_SetExtendedListViewStyle($listview, BitOR($LVS_EX_FULLROWSELECT,$LVS_EX_GRIDLINES))
	_GUICtrlListView_AddColumn($listview, "Name", 200)
	_GUICtrlListView_AddColumn($listview, "Log", 100)
	_GUICtrlListView_AddColumn($listview, "Quota", 100)
	_GUICtrlListView_AddColumn($listview, "Date", 110)
	_GUICtrlListView_AddColumn($listview, "Status", 170)


GUISetState()


While 1
	  Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE
                ExitLoop

			Case $insert




			EndSwitch

WEnd
