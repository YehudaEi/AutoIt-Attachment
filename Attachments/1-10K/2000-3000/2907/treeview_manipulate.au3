Global $TV_FIRST        = 0x1100
Global $TVM_GETITEM        = $TV_FIRST + 12
Global $TVM_GETNEXTITEM    = $TV_FIRST + 10
Global $TVGN_CARET        = 0x0009
;Global $TVGN_PARENT        = 0x0003
Global $TVIF_TEXT        =       0x0001
;Global $TVGN_ROOT = 0

Run("treeview_app.exe") ;.au3
WinWaitActive("App with treeview")

$hTree = ControlGetHandle("App with treeview", "", "SysTreeView321")
;$hItem = GUICtrlSendMsg($nTree,$TVM_GETNEXTITEM,$TVGN_CARET,0)
$result = dllcall("user32.dll","int","SendMessage","hWnd",$hTree,"int",$TVM_GETNEXTITEM,"int",$TVGN_CARET,"int",0)
;Msgbox(0,"hItem",$result[0]) ; it's OK

$sItemText = TreeViewGetItemText($result[0]) ; it's not OK
Msgbox(0,"Item text",$sItemText)

Exit

Func TreeViewGetItemText($hItem)
    $szText            = ""
    $TEXT_struct    = DllStructCreate("char[260]"); create a text 'area' for receiving the text
    $TVITEM_struct    = DllStructCreate("uint;int;uint;uint;ptr;int;int;int;int;int")
    
    DllStructSetData($TVITEM_struct,1,$TVIF_TEXT)
    DllStructSetData($TVITEM_struct,2,$hItem)
    DllStructSetData($TVITEM_struct,5,DllStructGetPtr($TEXT_struct))
    DllStructSetData($TVITEM_struct,6,260)
    
    DllCall("user32.dll","int","SendMessage","hwnd",$hTree,"int",$TVM_GETITEM,"int",0,"ptr",DllStructGetPtr($TVITEM_struct))
    $szText = DllStructGetData($TEXT_struct,1)
    DllStructDelete($TEXT_struct)
    DllStructDelete($TVITEM_struct)

    Return $szText
EndFunc
