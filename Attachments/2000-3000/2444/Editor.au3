#include <GuiConstants.au3>
#include <string.au3>
#include <array.au3>
;#include <crypt.au3>

Global $keys

_iniread()

#region --- GuiBuilder code Start ---

GUICreate("Commandline Editor", 628, 349, (@DesktopWidth - 628) / 2, (@DesktopHeight - 349) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$Edit_1 = GUICtrlCreateEdit("Edit1", 180, 0, 450, 330)
$List_2 = GUICtrlCreateList("List2", 0, 0, 180, 330, $LBS_NOINTEGRALHEIGHT)
$add = GUICtrlCreateButton("Add", 0, 330, 60, 20)
$rename = GUICtrlCreateButton("Rename", 60, 330, 60, 20)
$delete = GUICtrlCreateButton("Delete", 120, 330, 60, 20)
$run = GUICtrlCreateButton("Run", 430, 330, 60, 20)
$save = GUICtrlCreateButton("Save", 500, 330, 60, 20)
$close = GUICtrlCreateButton("Close", 570, 330, 60, 20)
GUICtrlSetData($Edit_1, "")
GUICtrlSetState($Edit_1, $GUI_DISABLE)
GUICtrlSetData($List_2, "")

LB_Update()

GUISetState()

Global $Prev_Selected = 0, $Selected, $buffer = 0, $index = 0, $Pindex = 0, $bufferHits = 0, $edit_enabled
While 1
    $msg = GUIGetMsg()
    
    If $index <> - 1 And Not $edit_enabled Then
        GUICtrlSetState($Edit_1, $GUI_ENABLE)
        $edit_enabled = 1
    EndIf
    
    Select
		Case $msg = $GUI_EVENT_CLOSE
			onExit()
            ExitLoop
        Case $msg = $List_2
            if $index <> -1 then GUICtrlSetData($Edit_1, $keys[$index][1])
            $Pindex = $index
        Case $msg = $Edit_1
            $keys[$Pindex][1] = $buffer
            $bufferHits = $bufferHits + 1
        Case $msg = $add
            _additem()
        Case $msg = $rename
            _renameitem()
		Case $msg = $delete
			_deleteitem()
		Case $msg = $run
			Exec($keys[GUICtrlSendMsg($List_2, 0x0188, 0, 0)+1][1])
		Case $msg = $save
			_iniwrite()
		Case $msg = $close
			onExit()
			ExitLoop
        Case Else
            $index = GUICtrlSendMsg($List_2, 0x0188, 0, 0)+1
			If GuiCtrlRead($Edit_1) <> $buffer then
                $buffer = GuiCtrlRead($Edit_1)
			Endif
            ;;;
    EndSelect
WEnd
Exit
#endregion --- GuiBuilder generated code End ---

#region --- Listbox Functions Begin ---
Func LB_Update()
	GUICtrlSetData($List_2, "")
	For $i = 1 To (UBound($keys) - 1)
		GUICtrlSendMsg($List_2, 0x0180, 0, $keys[$i][0])
	Next
EndFunc
#endregion --- Listbox Functions End ---
#region --- INI Functions Begin---
Func _iniread()
	$keys = IniReadSection("cmdcon.ini", "Commands")
	If @error Then _inisetup()
	for $i = 1 To (UBound($keys)-1)
		$keys[$i][1] = Stringreplace($keys[$i][1],"þ",@CRLF)
	Next
EndFunc

Func _iniwrite()
	for $i = 1 To (UBound($keys)-1)
		;IniWrite ( "cmdcon.ini", "Commands", $keys[$i][0], Encrypt($keys[$i][1]))
		IniWrite ( "cmdcon.ini", "Commands", $keys[$i][0], Stringreplace($keys[$i][1],@CRLF,"þ"));Decrypt($keys[$i][1]))
	Next
EndFunc

Func _inisetup()
	IniWrite ( "cmdcon.ini", "Commands", "Open CMD", "Run(@COMSPEC)")
	IniWrite ( "cmdcon.ini", "Commands", "Open CMD @ Dir", "Run(@COMSPEC & "" /k cd "" & ClipGet())")
	IniWrite ( "cmdcon.ini", "Commands", "MsgBox", "MsgBox(4096,""MsgBox Demo"",""This is a demo of a MsgBox"")")
	IniWrite ( "cmdcon.ini", "Commands", "Item 4", "Item 4þLine1þLine2þLine3þLine4þLine5þLine6þLine7")
	IniWrite ( "cmdcon.ini", "Commands", "Item 5", "Item 5þLine1þLine2þLine3þLine4þLine5þLine6þLine7")
	_iniread()
EndFunc
#endregion --- INI Functions End ---

#region --- Button Functions Begin ---
Func _additem()
	Local $newItem[2]
	$indexed = GUICtrlSendMsg($List_2, 0x0188, 0, 0)
	ReDim $keys[Ubound($keys)+1][2]
	$keys[Ubound($keys)-1][0] = InputBox("New Item", "New Item", "New Item")
	$keys[Ubound($keys)-1][1] = ""
    LB_Update()
EndFunc   ;==>_additem

Func _renameitem()
	Local $indexed, $newName
    $indexed = GUICtrlSendMsg($List_2, 0x0188, 0, 0)
    $newName = InputBox("Rename Item", "Rename Item", GUICtrlRecvMsg($List_2, 0x0189, $indexed, 1))
	$keys[$indexed+1][0] = $newName
	LB_Update()
EndFunc   ;==>_renameitem

Func _deleteitem()
	Local $indexed
	$indexed = GUICtrlSendMsg($List_2, 0x0188, 0, 0)
	_iniwrite()
	IniDelete("cmdcon.ini","Commands",$keys[$indexed+1][0])
	_iniread()
	LB_Update()
EndFunc

Func onExit()
	_iniwrite()
EndFunc
#endregion --- Button Functions End ---

#region --- Helper Functions Begin ---
Func Exec($string)
	Local $fd, $tmpfile
    $tmpfile = @TempDir & "\cmdcon.au3"
	
    $fd    = FileOpen($tmpfile,2)
    if $fd <> -1 Then
      FileWrite($fd,"#NoTrayIcon" & @CRLF & $string)
      FileClose($fd)
    Endif
	
	Run(@AutoItExe & ' "' & $tmpfile & '"')
EndFunc
#endregion --- Helper Functions End ---