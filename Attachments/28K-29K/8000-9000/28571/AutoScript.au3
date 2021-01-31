
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <GuiListView.au3>
#include <Excel.au3>
#include <Array.au3>
#include <ButtonConstants.au3>

Global $hGui = GUICreate("AutoIT",893, 600,-1,-1), $oExcel
Local $treeview, $monitor, $listview
Local $svr1, $svr2,$svr4
Local $gs1, $gs2, $gs3, $gs4
Local $insert, $oExcel, $aArray

Global $sFilePath1 = "D:\Database\MySQL.xls"
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 600)

Global $sFilePath2 = "D:\Database\FileServer.xls"
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 600)

Global $sFilePath3 = "D:\Database\MailServer.xls"
GUICtrlSetColor(-1, 0x0000CC)
GUICtrlSetFont(-1, 11.5, 600)


$treeview = GUICtrlCreateTreeView(10, 35, 170, 520, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)

$monitor = GUICtrlCreateTreeViewItem("ViewTree", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)
$gs1=GUICtrlCreateTreeViewItem("AutoIT_1",$monitor)
    GUICtrlSetColor(-1, 0x0000CC)
$gs2=GUICtrlCreateTreeViewItem("AutoIT_2",$monitor)
    GUICtrlSetColor(-1, 0x0000C0)
$gs3=GUICtrlCreateTreeViewItem("AutoIT_3",$monitor)
    GUICtrlSetColor(-1, 0x0000C0)
$gs4 = GUICtrlCreateTreeViewItem("Others", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)


$svr1 = GUICtrlCreateTreeViewItem("MySQL", $gs1)
$svr2 = GUICtrlCreateTreeViewItem("FileServer", $gs1)
$svr3 = GUICtrlCreateTreeViewItem("MailServer", $gs1)


    GUICtrlSetState($monitor, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
    GUICtrlSetState($gs1, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
    GUICtrlSetState($gs2, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
    GUICtrlSetState($gs3, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))
    GUICtrlSetState($gs4, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))

    GUISetState()

     $listview = GUICtrlCreateListView("", 200, 35, 680, 520)
    _GUICtrlListView_SetExtendedListViewStyle($listview, BitOR($LVS_EX_FULLROWSELECT,$LVS_EX_GRIDLINES))
    _GUICtrlListView_AddColumn($listview, "Server", 200)
    _GUICtrlListView_AddColumn($listview, "Database", 150)
	_GUICtrlListView_AddColumn($listview, "Status", 100)


GUISetState()


While 1
      Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
                _ExcelBookClose($oExcel, 0)
                ExitLoop

            Case $svr1

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listView))
				$oExcel = _ExcelBookOpen($sFilePath1,0)
			    $aArray = _ExcelReadSheetToArray($oExcel)
				_GUICtrlListView_AddArray($listview, $aArray)


            Case $svr2

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listView))
				$oExcel = _ExcelBookOpen($sFilePath2,0)
			    $aArray = _ExcelReadSheetToArray($oExcel)
				_GUICtrlListView_AddArray($listview, $aArray)

			Case $svr3

				_GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($listView))
				$oExcel = _ExcelBookOpen($sFilePath3,0)
			    $aArray = _ExcelReadSheetToArray($oExcel)
				_GUICtrlListView_AddArray($listview, $aArray)

            EndSwitch

WEnd




