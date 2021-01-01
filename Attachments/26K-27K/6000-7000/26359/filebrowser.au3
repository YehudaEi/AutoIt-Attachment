#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#include <ListViewconstants.au3>
#include <GuiListView.au3>
#include <GUITreeView.au3>
#include <File.au3>
#include <Array.au3>

Global $arrFileIcons[1]=["shell32.dll"], $sortdir=0

$title = "FileBrowser"
$gui = GUICreate("", 720, 348, -1, -1, $WS_SIZEBOX, $WS_EX_CLIENTEDGE)
        GUICtrlCreateGroup($title, 8, 0, 705, 320, $WS_CLIPSIBLINGS)
            GUICtrlSetFont(-1, 12, 800, 0, "Monotype Corsiva")
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
        $treeview = GUICtrlCreateTreeView(16, 20, 189, 290, BitOR($TVS_HASBUTTONS,$TVS_HASLINES,$TVS_LINESATROOT,$TVS_SHOWSELALWAYS,$WS_GROUP,$WS_TABSTOP,$WS_BORDER))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM+$GUI_DOCKWIDTH)
        $listview = GUICtrlCreateListView("Name|Type|Size|Modified", 212, 20, 493, 290, BitOR($LVS_REPORT,$LVS_SHOWSELALWAYS,$WS_BORDER))
            GUICtrlSetResizing(-1, $GUI_DOCKLEFT+$GUI_DOCKRIGHT+$GUI_DOCKTOP+$GUI_DOCKBOTTOM)
            _ColumnResize($listview)

$tImage = _GUIImageList_Create(16, 16, 5, 2)  ;Treeview Icon Image List
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 3) ;Folder
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 4) ;Folder Open
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 181) ;Cdr
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 8) ;Fixed
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 7) ;Removable
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 9) ;Network 
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 11) ;CDRom
    _GUIImageList_AddIcon($tImage, @SystemDir & "\shell32.dll", 109) ;No Symbol for Burner

_GUICtrlTreeView_SetNormalImageList($treeview, $tImage)

$drives = DriveGetDrive("FIXED")
If @error  Then Exit
For $x = 1 To $drives[0]
    $icon=0
    If DriveGetType($drives[$x]) = "Fixed" Then $icon=3
    If DriveGetType($drives[$x]) = "Removable" Then $icon=4
    If DriveGetType($drives[$x]) = "Network" Then $icon=5
    If DriveGetType($drives[$x]) = "CDROM" Then $icon=6
    If $icon=0 Then
        $new = _GUICtrlTreeView_AddChild($treeview,"",$drives[$x],0,1)
    Else
        $new = _GUICtrlTreeView_AddChild($treeview,"",$drives[$x],$icon,$icon)
    EndIf
Next

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")  ;Last steps before GUI Display

GUISetState()

Do
Until GUIGetMsg() = -3


Func _ColumnResize(ByRef $hWnd,$type=0) ;Resize Listview Column routine
    $winpos=WinGetPos($gui)
    _GUICtrlListView_SetColumnWidth($hWnd, 0, $winpos[2]*.2375)
    _GUICtrlListView_SetColumnWidth($hWnd, 1, $winpos[2]*.1575)
    _GUICtrlListView_SetColumnWidth($hWnd, 2, $winpos[2]*.1)
    _GUICtrlListView_SetColumnWidth($hWnd, 3, $winpos[2]*.16)
EndFunc;==> _ColumnResize()

Func _FileGetIcon(ByRef $szIconFile, ByRef $nIcon, $szFile) ;Get Icon for Files - Special Thanks to MrCreator - http://www.autoitscript.com/forum/index.ph...st&p=421467
    Dim $szRegDefault = "", $szDefIcon = ""
    $szExt = StringMid($szFile, StringInStr($szFile, '.', 0, -1))
    If $szExt = '.lnk' Then
        $details = FileGetShortcut($szIconFile)
        $szIconFile = $details[0]
        $szExt = StringMid($details[0], StringInStr($details[0], '.', 0, -1))
    EndIf
    $szRegDefault = RegRead("HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\FileExts\" & $szExt, "ProgID")
    If $szRegDefault = "" Then $szRegDefault = RegRead("HKCR\" & $szExt, "")
    If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
    If $szDefIcon = "" Then $szRegDefault = RegRead("HKCR\" & $szRegDefault & "\CurVer", "")
    If $szRegDefault <> "" Then $szDefIcon = RegRead("HKCR\" & $szRegDefault & "\DefaultIcon", "")
    If $szDefIcon = "" Then
        $szIconFile = "shell32.dll"
    ElseIf $szDefIcon <> "%1" Then
        $arSplit = StringSplit($szDefIcon, ",")
        If IsArray($arSplit) Then
            $szIconFile = $arSplit[1]
            If $arSplit[0] > 1 Then $nIcon = $arSplit[2]
        Else
            Return 0
        EndIf
    EndIf
    Return 1
EndFunc;==> _FileGetIcon()

Func _FillFolder(ByRef $hWnd) ;Fill Folder in TreeView
    $item = _GUICtrlTreeView_GetSelection($hWnd)
    If _GUICtrlTreeView_GetChildCount($hWnd,$item) <= 0 Then
        _GUICtrlTreeView_BeginUpdate($treeview)
        $txt = _TreePath($hWnd,$item)
        _SearchFolder($txt,$item)
        _GUICtrlTreeView_EndUpdate($treeview)
    EndIf
EndFunc;==> _FillFolder()

Func _FolderFunc($folders,$folder,$parent,$level) ;Add Folder to Source TreeView
    If $parent = 0x00000000 Then Return
    For $i = 1 To UBound($folders)-1
        $parentitem = _GUICtrlTreeView_AddChild($treeview,$parent,$folders[$i],0,1)
        _SearchFolder($folder & "\" & $folders[$i],$parentitem,$level+1)
    Next
EndFunc;==> _FolderFunc()

Func _FriendlyDate($date) ;Convert Date for Readability
    If Not IsArray($date) Then Return ""
    Local $datetime=""
    For $i = 0 To 5
        $datetime &= $date[$i]
        If $i < 2 Then $datetime &= "-"
        If $i = 2 Then $datetime &= " "
        If $i > 2 And $i < 5 Then $datetime &= ":"
    Next
    Return $datetime
Endfunc;==> _FriendlyDate()

Func _GetSelectedItems($hWnd,$list,$tree) ;Get list of Selected Items in Source ListView
    $items = _GUICtrlListView_GetSelectedIndices($list,True)
    For $i = 1 To $items[0]
        $items[$i] = _TreePath($tree,_GUICtrlTreeView_GetSelection($tree)) & "\" & _GUICtrlListView_GetItemText(ControlGetHandle($hWnd,"",$list),$items[$i],0)
    Next
    Return $items
EndFunc;==> _GetSelectedItems()

Func _ReduceMemory($i_PID = -1) ;Reduces Memory Usage -- Special thanks to w0uter and jftuga
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()

Func _SearchFolder($folder,$parent,$level=0) ;Recursive Folder Search for Source Treeview/Listview
    If $level >= 1 Then Return
    $folders = _FileListToArray($folder,"*",2)
    _FolderFunc($folders,$folder,$parent,$level)
EndFunc;==> _SearchFolder()

Func _ShowFolder(ByRef $tree,ByRef $list,ByRef $hWnd,$sort=0) ;Show folder in Source Folder
    Dim $arrCurrentFolder[1][4]
    $item = _GUICtrlTreeView_GetSelection($tree)
    If $item = 0x000000 Then Return 0
    _GUICtrlListView_BeginUpdate($list)
    _GUICtrlListView_DeleteAllItems(GUICtrlGetHandle($list))
    $path = _TreePath($tree,$item)
    For $type = 1 To 2
        Local $Sch
        If $type = 1 Then $Sch = _FileListToArray($path, "*", 2)
        If $type = 2 Then $Sch = _FileListToArray($path, "*", 1)
        If UBound($Sch) > 0 Then
            For $i = 1 To $Sch[0]
                ReDim $arrCurrentFolder[UBound($arrCurrentFolder)+1][4]
                If $type = 1 Then
                    $filefolder = "Folder"
                    $size = " "
                Else
                    $filefolder = StringUpper(StringRight($Sch[$i],StringLen($Sch[$i])-StringInstr($Sch[$i],".",0,-1))) & " File"
                    $size = FileGetSize($path & "\" & $Sch[$i])
                EndIf
                $arrCurrentFolder[UBound($arrCurrentFolder)-1][0]=$Sch[$i]
                $arrCurrentFolder[UBound($arrCurrentFolder)-1][1]=$filefolder
                $arrCurrentFolder[UBound($arrCurrentFolder)-1][2]=$size
                $arrCurrentFolder[UBound($arrCurrentFolder)-1][3]=_FriendlyDate(FileGetTime($path & "\" & $Sch[$i]))
            Next
            If $type = 1 And $sort <> 3 Then
                _ArraySort($arrCurrentFolder,$sortdir,0,0,0)
            Else
                _ArraySort($arrCurrentFolder,$sortdir,0,0,$sort)
            EndIf
            If $type = 1 Then
                For $x = 0 To UBound($arrCurrentFolder)-1
                    If $arrCurrentFolder[$x][0] Then
                        $idx = GUICtrlCreateListViewItem($arrCurrentFolder[$x][0] & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3],$list)
                        GuiCtrlSetImage(-1, $arrFileIcons[0], -4)
                    EndIf
                Next
                $arrCurrentFolder=0
                Dim $arrCurrentFolder[1][4]
            EndIf
            If $type = 2 Then
                For $x = 0 To UBound($arrCurrentFolder)-1
                    If $arrCurrentFolder[$x][0] Then
                        $idx = GUICtrlCreateListViewItem($arrCurrentFolder[$x][0] & "|" & $arrCurrentFolder[$x][1] & "|" & $arrCurrentFolder[$x][2] & "|" & $arrCurrentFolder[$x][3],$list)
                        If StringRight($arrCurrentFolder[$x][0], 4) = ".exe" Then
                            $found = _ArraySearch($arrFileIcons,$arrCurrentFolder[$x][0],0,0,0,1)
                            If $found <> -1 Then
                                GuiCtrlSetImage(-1, $arrFileIcons[$found], 0)
                            Else
                                If GuiCtrlSetImage(-1, $path & "\" & $arrCurrentFolder[$x][0], 0) = 0 Then
                                    GuiCtrlSetImage(-1, $arrFileIcons[0], -3)
                                Else   
                                    ReDim $arrFileIcons[UBound($arrFileIcons)+1]
                                    $arrFileIcons[UBound($arrFileIcons)-1]=$path & "\" & $arrCurrentFolder[$x][0]
                                    GuiCtrlSetImage(-1, $arrFileIcons[UBound($arrFileIcons)-1], 0)
                                EndIf
                            EndIf   
                        ElseIf StringRight($arrCurrentFolder[$x][0], 3) = "htm" Or StringRight($arrCurrentFolder[$x][0], 3) = "html" Then
                            GuiCtrlSetImage(-1, $arrFileIcons[0], -221)
                        Else   
                            $strExtension=StringTrimLeft($arrCurrentFolder[$x][0],StringInstr($arrCurrentFolder[$x][0],".",0,-1)-1)
                            If Not StringInstr($strExtension,".lnk",0,0,0,1) Then
                                $found = _ArraySearch($arrFileIcons,$arrCurrentFolder[$x][0],0,0,0,1)
                            Else
                                $found = _ArraySearch($arrFileIcons,$strExtension,0,0,0,1)
                            EndIf
                            If $found <> -1 Then
                                $icon = StringTrimLeft($arrFileIcons[$found],StringInstr($arrFileIcons[$found],"|",0,-2))
                                $icon = StringLeft($icon,StringInstr($icon,"|")-1)
                                $nIcon = StringRight($arrFileIcons[$found],StringLen($arrFileIcons[$found])-StringInstr($arrFileIcons[$found],"|",0,-1))
                                GuiCtrlSetImage(-1, $icon, $nIcon)
                            Else
                                Local $szIconFile = $path & "\" & $arrCurrentFolder[$x][0], $nIcon = 0
                                _FileGetIcon($szIconFile, $nIcon, $arrCurrentFolder[$x][0])
                                If $nIcon <> 0 Then $nIcon = - $nIcon
                                ReDim $arrFileIcons[UBound($arrFileIcons)+1]
                                $arrFileIcons[UBound($arrFileIcons)-1]=$path & "\" & $arrCurrentFolder[$x][0] & "|" & StringReplace($szIconFile,Chr(34),"") & "|" & StringReplace($nIcon,Chr(34),"")
                                GuiCtrlSetImage(-1, $szIconFile , $nIcon)
                            EndIf
                        EndIf
                    EndIf
                Next
            EndIf
        EndIf
    Next
    $Sch=0
    $nIcon=0
    $szIconFile=0
    $arrCurrentFolder=0
    _GUICtrlListView_EndUpdate($list)
    _ReduceMemory()
EndFunc;==> _ShowFolder()

Func _TreePath($hWnd,$item)  ;Determine full path of selected item in TreeView
    $txt = _GUICtrlTreeView_GetText($hWnd,$item)
    Do
        $parent = _GUICtrlTreeView_GetParentHandle($hWnd,$item)
        If $parent <> 0 Then
            $txt = _GUICtrlTreeView_GetText($hWnd,$parent) & "\" & $txt
            $item = $parent
        EndIf
    Until $parent = 0
    Return $txt
EndFunc;==> _TreePath()

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam) ;Notify func
    Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR
    $srctree = ControlGetHandle($hwnd,"",$treeview)
    $srclist = ControlGetHandle($hwnd,"",$listview)
    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
    $iCode = DllStructGetData($tNMHDR, "Code")
    If $iCode = -12 Or $iCode = -17 Then Return False
    Switch $hWndFrom
        Case $srclist
            $item = _GetSelectedItems($gui,$listview,$treeview)
            Switch $iCode
                Case $NM_DBLCLK
                    If $item[0]<>0 Then
                        $filefolder = _GUICtrlListView_GetSelectedIndices($listview,True)
                        If _GUICtrlListView_GetItemText($listview,$filefolder[1],1) = "Folder" Then               
                            $idx = _GUICtrlTreeView_GetSelection($treeview)
                            $item = StringTrimLeft($item[1],stringInstr($item[1],"\",0,-1))
                            $found = _GUICtrlTreeView_FindItem($treeview,$item,False,$idx)
                            _GUICtrlTreeView_SelectItem($treeview,$found)
                            _FillFolder($treeview)
                            _ShowFolder($treeview,$listview,$gui)
                        Else
                            Run(@Comspec & " /c " & chr(34) & $item[1] & chr(34),"",@SW_HIDE)
                            sleep(1500)
                        EndIf
                    EndIf
                    Return TRUE
            EndSwitch
        Case $srctree
            Switch $iCode
                Case $NM_RCLICK
                    Local $tPOINT = _WinAPI_GetMousePos(True, $srctree)
                    Local $iX = DllStructGetData($tPOINT, "X")
                    Local $iY = DllStructGetData($tPOINT, "Y")
                   
                    Local $hItem = _GUICtrlTreeView_HitTestItem($srctree, $iX, $iY)
                    If $hItem <> 0 Then _GUICtrlTreeView_SelectItem($srctree, $hItem, $TVGN_CARET)
               
                Case -451
                    _FillFolder($treeview)
                    _ShowFolder($treeview,$listview,$gui)
                    Return TRUE

            EndSwitch

        Case Else
            Switch $iCode
                Case $NM_CLICK  ; The user has clicked the left mouse button within the control
                    ;If $srcGUImove Then
                        _SendMessage($gui, $WM_SYSCOMMAND, 0xF012, 2,1)
                    ;    $srcGUImove = False
                    ;EndIf
                    ;If $destGUImove Then
                    ;    _SendMessage($dest[0], $WM_SYSCOMMAND, 0xF012, 2,1)
                    ;    $destGUImove = False
                    ;EndIf
            EndSwitch
    EndSwitch
EndFunc;==> WM_NOTIFY