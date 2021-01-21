$TVM_GETNEXTITEM = 0x110A
$TVGN_ROOT = 0

$tree = ControlGetHandle("App with treeview", "", "SysTreeView321")
If @error Then
	msgbox(0,"Error", "App with treeview not found!")
	Exit
EndIf

$result = dllcall("user32.dll","int","SendMessage","hWnd",$tree,"int",$TVM_GETNEXTITEM,"int",$TVGN_ROOT,"ptr","")
If @error Then
	_GetLastErrorMessage("After DLLCall (get root)")
else
	$item = $result[0]
	msgbox(0,"Root item pointer", $item)
endif

$text = TreeViewGetItemText($tree, $item)
If @error Then
	_GetLastErrorMessage("After DLLCall (get text)")
else
	MsgBox(0, 'Root item text', $text)
endif

Exit

Func TreeViewGetItemText($hwnd, $hitem)
	Local $str = ""
	Local $foo = DllCall("win32_1.dll", "long", "TreeViewGetItemText", "hwnd", $hwnd, "long", $hitem, "str", $str)
	If @error Then
		SetError(1)
		Return ""
	Else
		Return $foo[3]
	Endif
Endfunc

;===============================================
;    _GetLastErrorMessage($DisplayMsgBox="")
;    Format the last windows error as a string and return it
;    if $DisplayMsgBox <> "" Then it will display a message box w/ the error
;    Return        Window's error as a string
;===============================================
Func _GetLastErrorMessage($DisplayMsgBox="")
    Local $ret,$s
    Local $p    = DllStructCreate("char[4096]")
    Local Const $FORMAT_MESSAGE_FROM_SYSTEM        = 0x00001000

    If @error Then Return ""

    $ret    = DllCall("Kernel32.dll","int","GetLastError")

    $ret    = DllCall("kernel32.dll","int","FormatMessage",_
                        "int",$FORMAT_MESSAGE_FROM_SYSTEM,_
                        "ptr",0,_
                        "int",$ret[0],_
                        "int",0,_
                        "ptr",DllStructGetPtr($p),_
                        "int",4096,_
                        "ptr",0)
    $s    = DllStructGetData($p,1)
    DllStructDelete($p)
    If $DisplayMsgBox <> "" Then MsgBox(0,"_GetLastErrorMessage",$DisplayMsgBox & @CRLF & $s)
    return $s
EndFunc