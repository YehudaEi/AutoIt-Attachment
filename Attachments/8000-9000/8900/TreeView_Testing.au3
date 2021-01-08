; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Todd Weast
;
; Script Function:
;	TreeView DLL Testing Script
;
; ----------------------------------------------------------------------------


$g_socdll = @ScriptDir & "\AutoItTreeViewExtension.dll"

$title = "App with treeview"

Local $tree = GetActiveControl($title)
Local $root = TreeViewGetRoot($tree)

ConsoleWrite("Tree/Root is " & $tree & " " & $root & @LF)

DumpTreeView($tree, $root)

$intItem = 0
$intItem = GetTreeViewItemByName($tree, "Item 21", 0)
$strItem = GetTreeViewNameByItem($tree, $intItem)
ConsoleWrite("Item 21 is " & $intItem & " " & $strItem & @LF)
$intItem = GetTreeViewItemByName($tree, "Item 22", 0)
$strItem = GetTreeViewNameByItem($tree, $intItem)
ConsoleWrite("Item 22 is " & $intItem & " " & $strItem & @LF)

SelectTreeViewItemByName($tree, "Item 4")
;$intItem = GetTreeViewItemByName($tree, "Item 3", 0)
;$strItem = GetTreeViewNameByItem($tree, $intItem)
;SelectTreeViewItem($tree, $intItem)
;ConsoleWrite("Select Item is " & $intItem & " " & $strItem & @LF)

exit(0)

; Test OK
Func DumpTreeView($tree, $node)
	While $node
            Local $str = GetTreeViewNameByItem($tree, $node)
            ConsoleWrite("node is " & $str & @LF);
            
            ExpandTreeViewItem($tree, $node)
     
            Local $child = TreeViewNextChild($tree, $node)
            if $child <> 0 Then DumpTreeView($tree, $child)
            
            $node = TreeViewNextSibling($tree, $node)
     WEnd
Endfunc


; Test OK
Func SelectTreeViewItemByName($tree, $str)
	local $intItem = GetTreeViewItemByName($tree, $str, 0)
	SelectTreeViewItem($tree, $intItem)
Endfunc


; return the hwnd for the active control in the given window
; Test OK
Func GetActiveControl($title)
   WinActivate($title)
   return ControlGetHandle($title, "", ControlGetFocus($title))
Endfunc

; Test Fail
Func CopyTreeViewToClipboard($parent_hwnd, $hwnd)
       Local $foo = DllCall($g_socdll, "int", "CopyTreeViewToClipboard", "hwnd", $parent_hwnd, "hwnd", $hwnd)
    If @error Then
        MsgBox(0, "Debug", "Error with DllCall(CopyTreeViewToClipboard)")
    Endif
    Return $foo[0]
Endfunc

; Test OK
Func GetTreeViewItemByName($hwnd, $str, $hitem=0)
   Local $foo = DllCall($g_socdll, "long", "GetTreeViewItemByName", "hwnd", $hwnd, "long", $hitem, "str", $str)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(GetTreeViewItemByName)")
   Endif
   Return $foo[0]
Endfunc

; Test OK
Func SelectTreeViewItem($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "SelectTreeViewItem", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(SelectTreeViewItem)")
   Endif
   Return $foo[0]
Endfunc

; Untested
Func EnsureVisibleTreeViewItem($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "EnsureVisibleTreeViewItem", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(EnsureVisibleTreeViewItem)")
   Endif
   Return $foo[0]
Endfunc

; Test OK
Func ExpandTreeViewItem($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "ExpandTreeViewItem", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(ExpandTreeViewItem)")
   Endif
   Return $foo[0]
Endfunc

; Untested
Func CollapseTreeViewItem($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "CollapseTreeViewItem", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(CollapseTreeViewItem)")
   Endif
   Return $foo[0]
Endfunc

; Untested
Func GetSelectedTreeViewItem($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "GetSelectedTreeViewItem", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(GetSelectedTreeViewItem)")
   Endif
   Return $foo[0]
Endfunc

; Test OK
Func GetTreeViewNameByItem($hwnd, $hitem)
     Local $str = ""
   Local $foo = DllCall($g_socdll, "long", "GetTreeViewNameByItem", "hwnd", $hwnd, "long", $hitem, "str", $str)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(GetTreeViewNameByItem)")
   Endif
   Return $foo[3]
Endfunc

; Test OK
Func TreeViewGetRoot($hwnd)
   Local $foo = DllCall($g_socdll, "long", "TreeViewGetRoot", "hwnd", $hwnd)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(TreeViewGetRoot)")
   Endif
   Return $foo[0]
Endfunc

; Test OK
Func TreeViewNextChild($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "TreeViewNextChild", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(TreeViewNextChild)")
   Endif
   Return $foo[0]
Endfunc

; Test OK
Func TreeViewNextSibling($hwnd, $hitem)
   Local $foo = DllCall($g_socdll, "long", "TreeViewNextSibling", "hwnd", $hwnd, "long", $hitem)
   If @error Then
      MsgBox(0, "Debug", "Error with DllCall(TreeViewNextSibling)")
   Endif
   Return $foo[0]
Endfunc

