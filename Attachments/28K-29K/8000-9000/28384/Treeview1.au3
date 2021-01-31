#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <StaticConstants.au3>
#include <GuiListView.au3>

Opt('MustDeclareVars', 1)

Example()

Func Example()
    Local $treeview, $contactlist, $isp, $listview
    Local  $svr1, $svr2,$svr3
	Local $cancelbutton
	Local $data1, $data2,$data3, $data4, $data5
	Local $msg,  $item[10]
	
    
    GUICreate("Design by Kenzo", 900, 450)

    $treeview = GUICtrlCreateTreeView(10, 10, 170, 400, BitOR($TVS_HASBUTTONS, $TVS_HASLINES, $TVS_LINESATROOT, $TVS_DISABLEDRAGDROP, $TVS_SHOWSELALWAYS), $WS_EX_CLIENTEDGE)
	
   
	$contactlist = GUICtrlCreateTreeViewItem("Contact List", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)
	
    $svr1 = GUICtrlCreateTreeViewItem("MySQL-Server", $contactlist)
    $svr2 = GUICtrlCreateTreeViewItem("Mail-Server", $contactlist)
    $svr3 = GUICtrlCreateTreeViewItem("AD", $contactlist)
	
	
	
	 $isp = GUICtrlCreateTreeViewItem("Database", $treeview)
    GUICtrlSetColor(-1, 0x0000C0)

    $data1 = GUICtrlCreateTreeViewItem("Data1", $isp)
	$data2 = GUICtrlCreateTreeViewItem("Data2", $isp)
	$data3 = GUICtrlCreateTreeViewItem("Data3", $isp)
	$data4 = GUICtrlCreateTreeViewItem("Data4", $isp)
	$data5 = GUICtrlCreateTreeViewItem("Data5", $isp)
	
	 
    $cancelbutton = GUICtrlCreateButton("Cancel", 50, 420, 70, 20)

    GUICtrlSetState($contactlist, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))    ; Expand the "General"-item and paint in bold
    GUICtrlSetState($isp, BitOR($GUI_EXPAND, $GUI_DEFBUTTON))    ; Expand the "Display"-item and paint in bold

    GUISetState()
	
	$listview = GUICtrlCreateListView("", 200, 10, 680, 400)
	;_GUICtrlListView_SetExtendedListViewStyle($listview, BitOR($LVS_EX_FULLROWSELECT,$LVS_EX_GRIDLINES))
	_GUICtrlListView_AddColumn($listview, "Fullname", 170)
	_GUICtrlListView_AddColumn($listview, "Role", 70)
	_GUICtrlListView_AddColumn($listview, "Major", 100)
	_GUICtrlListView_AddColumn($listview, "Cellphone", 150)
	_GUICtrlListView_AddColumn($listview, "Ext", 70)
	_GUICtrlListView_AddColumn($listview, "Email", 170)
	
	
	
    While 1
        $msg = GUIGetMsg()
        Select
            Case $msg = $cancelbutton Or $msg = $GUI_EVENT_CLOSE
                ExitLoop

           
						
							
		EndSelect
    WEnd

    Exit
EndFunc   

