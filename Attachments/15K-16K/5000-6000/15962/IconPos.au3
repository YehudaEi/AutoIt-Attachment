#include <A3LListView.au3>
#include <GUIConstants.au3>
#Include <GuiListView.au3>
#include <File.au3>

$guiwindow = GUICreate("Window Selection", 350, 150)
$font = "Arial Bold"

$LoadB = GUICtrlCreateButton(" Load ", 5, 123)
$SaveB = GUICtrlCreateButton(" Save ", 45, 123)
GUICtrlSetFont(-1, 8.5, 400, -1, $font)
$refreshbutton = GUICtrlCreateButton("Refresh", 100, 123, 60, 25)
GUICtrlSetFont(-1, 8.5, 400, -1, $font)
$nListview = GUICtrlCreateListView(" Title|State ", 0, 0, 350, 120)
GUICtrlSendMsg($nListview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
GUICtrlSendMsg($nListview, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_FULLROWSELECT, $LVS_EX_FULLROWSELECT)

RefreshWidth()
Func RefreshWidth()
    _GUICtrlListViewSetColumnWidth($nListview,1,$LVSCW_AUTOSIZE_USEHEADER)
    _GUICtrlListViewSetColumnWidth($nListview,1,_GUICtrlListViewGetColumnWidth ($nListview,1)-2)
EndFunc

ListWindows()
LoadInis() ; only that one visible in ListView

While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_Event_Close
            GUIDelete($guiwindow)
            Exit
        Case $msg = $LoadB
            Restore()
            ContinueLoop
        Case $msg = $SaveB
            Save()
            ListWindows()
            LoadInis()
            ContinueLoop
        Case $msg = $refreshbutton
            ListWindows()
            LoadInis()
    EndSelect
WEnd

Exit



Func ListWindows()
    GUISetState(@SW_SHOW)
    _GUICtrlListViewDeleteAllItems($nListview)
    $aWindows = WinList("[CLASS:CabinetWClass]")         ; To remove visible windows take out 'IsVisible' function.
    For $i = 1 To $aWindows[0][0]

;~   MsgBox(0, 0, "You choose: " & ControlGetText ($aWindows[$i][0], "", "SysListView321"))
        If $aWindows[$i][0] <> "" And ControlGetText ($aWindows[$i][0], "", "SysListView321") = "FolderView" Then
            GUICtrlCreateListViewItem($aWindows[$i][0], $nListview)
        EndIf
    Next
    GUICtrlCreateListViewItem("Program Manager(Desktop)", $nListview)
    _GUICtrlListViewSetColumnWidth($nListview, 0, $LVSCW_AUTOSIZE)
   
EndFunc   ;==>ListWindows


Func LoadInis()
   
    $FileList =_FileListToArray(@ScriptDir & "\WindowsPos","*.ini")
    If @error <> 0 Then
        If @error = 1 Then DirCreate ( @ScriptDir & "\WindowsPos" )
        Return -1
    EndIf

    For $i = 0 To _GUICtrlListViewGetItemCount ($nListview)-1
        $name = _GUICtrlListViewGetItemText ( $nListview, $i ,0)
        If @error <> 0 Then Return False
        $Load = LoadIni($name,$i)
        If $Load Then
            _GUICtrlListViewSetItemText ( $nListview, $i, 1, $Load )
        EndIf
    Next

    RefreshWidth()
EndFunc



Func LoadIni($name,$listnr)

    Dim $PosList[1][3]

    If Not FileExists(@ScriptDir & "\WindowsPos\"&$name&".ini") Then Return False ; keine Ini gefunden
    $IniSec = IniReadSection (@ScriptDir & "\WindowsPos\"&$name&".ini","Positions by Name")
    If @error=1 Then
        Return "Error in ini" ; ini gefunden aber fehlerhaft
    EndIf

    Return "Positions found"

EndFunc

Func Restore()
    $winname = _GUICtrlListViewGetItemText ( $nListview, -1 ,0)	
	If $winname = "Program Manager(Desktop)" Then
        $handle = ControlGetHandle("Program Manager", "", "SysListView321")
    Else
        $handle = ControlGetHandle($winname, "", "SysListView321")
    EndIf
    _ListView_BeginUpdate ($handle)

    For $i = 0 To _ListView_GetItemCount ($handle)
        $name = _ListView_GetItemText ($handle, $i)
        $x = IniRead(@ScriptDir & "\WindowsPos\"&$winname&".ini", "Positions by Name", $name & "x", "Unknown")
        $y = IniRead(@ScriptDir & "\WindowsPos\"&$winname&".ini", "Positions by Name", $name & "y", "Unknown")
		
        If $x <> "Unknown" Then
            _ListView_SetItemPosition32 ($handle, $i, $x, $y)
			ConsoleWrite($name &@tab &$handle &@tab& $i &@tab&  $x &@tab&  $y& @crlf)
        EndIf
    Next
    _ListView_EndUpdate ($handle)
EndFunc   ;==>Restore


Func Save()
    $winname = _GUICtrlListViewGetItemText ( $nListview, -1 ,0)

	If $winname = "Program Manager(Desktop)" Then
        $handle = ControlGetHandle("Program Manager", "", "SysListView321")
    Else
        $handle = ControlGetHandle($winname, "", "SysListView321")
    EndIf
	
    If @error = 1 Then MsgBox(0,0," Error(ControlGetHandle) : cant get handle")
    $t= MsgBox(4,   "Confirm","Window Name: "&$winname&@CRLF& _
                "Icon Count: "&_ListView_GetItemCount ($handle)&@CRLF& _
                "Name of first Icon: "&_ListView_GetItemText($handle, 0)&@CRLF&@CRLF& _
                "     Do you really want to save?")
    If $t <> 6 Then Return
    _GUICtrlListViewSetItemText ( $nListview, _GUICtrlListViewGetCurSel ($nListview), 1, "saving..." )
    FileDelete(@ScriptDir & "\WindowsPos\"&$winname&".ini")
    For $i = 0 To _ListView_GetItemCount ($handle)
        $pos = _ListView_GetItemPosition ($handle, $i)
        $name = _ListView_GetItemText ($handle, $i)
        If $pos[0] = True Then
            IniWrite(@ScriptDir & "\WindowsPos\"&$winname&".ini", "Positions by Name", $name & "x", $pos[0])
            IniWrite(@ScriptDir & "\WindowsPos\"&$winname&".ini", "Positions by Name", $name & "y", $pos[1])
        EndIf
    Next
    _GUICtrlListViewSetItemText ( $nListview, _GUICtrlListViewGetCurSel ($nListview), 1, "done" )
    RefreshWidth()
    Sleep(1500)
EndFunc   ;==>Save