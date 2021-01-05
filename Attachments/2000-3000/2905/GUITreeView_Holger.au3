; http://www.autoitscript.com/forum/index.php?showtopic=12615

; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1.48
; Author:         Holger Kotsch
;
; Script Function:
;    Gets the treeview-structure-text (i.e.path) for the current selected
;    treeview item
;
; ----------------------------------------------------------------------------

#include <GUIConstants.au3>
Opt("GUIDataSeparatorChar","\")


;---------------------------------------------------------------
; Some additional constants
;---------------------------------------------------------------

Global $TV_FIRST        = 0x1100
Global $TVM_GETITEM        = $TV_FIRST + 12
Global $TVM_GETNEXTITEM    = $TV_FIRST + 10
Global $TVGN_CARET        = 0x0009
Global $TVGN_PARENT        = 0x0003
Global $TVIF_TEXT        =       0x0001


;---------------------------------------------------------------
; Main sample program
;---------------------------------------------------------------

$szDataSep    = Opt("GUIDataSeparatorChar")

$hGUI        = GUICreate("TreeTest")

$nTree        = GUICtrlCreateTreeView(10,10,150,150)
$hTree        = ControlGetHandle($hGUI,"",$nTree); Later important for getting item information
$nItem1        = GUICtrlCreateTreeViewItem("Item1",$nTree)
$nItem2        = GUICtrlCreateTreeViewItem("Item2",$nTree)
$nSubItem1    = GUICtrlCreateTreeViewItem("SubItem1",$nItem1)
$nSubItem2    = GUICtrlCreateTreeViewItem("SubItem2",$nItem1)
$nSubItem3    = GUICtrlCreateTreeViewItem("SubItem3",$nSubItem1)

$nButton    = GUICtrlCreateButton("Path?",70,170,70,20)

GUISetState()

While 1
    $nMsg = GUIGetMsg()
    Select
        Case $nMsg = $GUI_EVENT_CLOSE
            ExitLoop
        Case $nMsg = $nButton
            Msgbox(0,"Path",_GUICtrlTreeViewItemGetTree())
    EndSelect
WEnd

Exit



;---------------------------------------------------------------
; Get all items text beginning by the current selected item
;---------------------------------------------------------------

Func _GUICtrlTreeViewItemGetTree()
    $szPath = ""
    $hItem = GUICtrlSendMsg($nTree,$TVM_GETNEXTITEM,$TVGN_CARET,0)
    If $hItem > 0 Then
        $szPath = TreeViewGetItemText($hItem)
        Do; Get now the parent item handle if there is one
            $hParent = GUICtrlSendMsg($nTree,$TVM_GETNEXTITEM,$TVGN_PARENT,$hItem)
            If $hParent > 0 Then $szPath = TreeViewGetItemText($hParent) & $szDataSep & $szPath 
            $hItem = $hParent
        Until $hItem <= 0
    EndIf
    Return $szPath
EndFunc


;---------------------------------------------------------------
; Retrieve the item text by sending a right item handle
;---------------------------------------------------------------

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