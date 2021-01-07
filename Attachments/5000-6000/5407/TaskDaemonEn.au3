#cs
  AutoIt Version: 3.1.1.91 (beta)
  Platform:       Win2000
  Version:        0.2.0
  Author:         Robie Zhou (robiezhou@gmail.com)

  Script Function:
    Daemon one or more tasks
#ce

#include <GUIConstants.au3>
#include <GuiListView.au3>
#include <Array.au3>
#include <file.au3>

Global $header  = "TaskDaemon "
Global $version = "V0.2.0"

opt('RunErrorsFatal', 0)

Main()
Exit

Func Main()
    Local $width = 387, $height = 240
    Local $filename = "", $filepath = "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
    Local $hRunAs, $hFile, $hSel, $hPath, $iMsg, $hStart, $hStop, $hCreate
    Local $sTmpFile
    Local $pgid = -1, $pidArray[1], $a_indices, $i
    Local $fileopened = 0, $fp
    
    ; Creating GUI and controls
    $hRunAs = GUICreate($header & $version, $width, $height, -1, -1, -1, $WS_EX_ACCEPTFILES)
    GUICtrlCreateLabel("FILE", 12, 16)
    $hFile = GUICtrlCreateInput($filename, 42, 15, 300, 16, $ES_READONLY)
    GUICtrlSetCursor($hFile, 2)
    GUICtrlSetState($hFile, $GUI_ACCEPTFILES)
    GUICtrlSetTip($hFile, "The program you want to run...")
    $hSel = GUICtrlCreateButton("...", 350, 15, 25, 16);, $BS_FLAT)
    GUICtrlSetTip($hSel, "Browse...")
    GUICtrlCreateLabel("PATH", 12, 41)
    $hPath = GUICtrlCreateInput("", 42, 40, 333, 16)
    ; Buttons
    $hStart  = GUICtrlCreateButton("RUN", 90, 65, 50, 18, $BS_FLAT)
    $hCreate = GUICtrlCreateButton("Create Program's Daemon", 185, 65, 150, 18, $BS_FLAT)
    ; ListView
    $hListView = GUICtrlCreateListView("PID|Task Name|FILE|PATH", 12, 95, 363, 105, $LVS_EDITLABELS)
    GUICtrlSendMsg(-1, $LVM_SETEXTENDEDLISTVIEWSTYLE, $LVS_EX_GRIDLINES, $LVS_EX_GRIDLINES)
    ; Buttons
    $hStop   = GUICtrlCreateButton("Stop Daemon", 70, 210, 90, 18, $BS_FLAT)
    $hCreateMul = GUICtrlCreateButton("Create Programs' Daemon", 185, 210, 150, 18, $BS_FLAT)
    GuiSetState()
    
    If FileExists(@ScriptDir & "\Res\Aut2Exe.exe") = 0 OR _ 
       FileExists(@ScriptDir & "\Res\AutoItSC.bin") = 0 OR _
       FileExists(@ScriptDir & "\Res\daemon.ico") = 0 OR _
       FileExists(@ScriptDir & "\Res\upx.exe") = 0 Then
        GUICtrlSetState($hCreate, $GUI_DISABLE)
        GUICtrlSetState($hCreateMul, $GUI_DISABLE)
    EndIf
    
    While 1
        DaemonTasks($hListView, $pidArray)
        #cs
        If $pgid <> -1 Then 
            If ProcessExists($pgid) = 0 Then
                $pgid = Run($filename, $filepath)
            EndIf
        EndIf
        #ce
            
        $iMsg = GUIGetMsg()
        Select
            Case $iMsg = $hSel
                $sTmpFile = FileOpenDialog("Select Program", $filePath, "Executables (*.com;*.exe)")
                If @error Then ContinueLoop
                GUICtrlSetData($hFile, $sTmpFile)
                $filepath = GetPath($sTmpFile)
                GUICtrlSetData($hPath, $filepath)
            
            ; RUN
            Case $iMsg = $hStart
                $filename = GUICtrlRead($hFile)
                $filepath = GUICtrlRead($hPath)
                If $filename = "" Then
                    MsgBox(16, $header, "Please select the program you want to run", 3)
                    ContinueLoop
                EndIf
                GUICtrlSetState($hStart, $GUI_DISABLE)
                $pgid = Run($filename, $filepath)
                If @error = 1 Then
                    MsgBox(16, $header, "Failed to run the program", 3)
                Else
                    $viewcont = $pgid & "|" & GetMainName($filename) & "|" & $filename & "|" & $filepath
                    GUICtrlCreateListViewItem($viewcont, $hListView)
                    _ArrayAdd($pidArray, $viewcont)
                    ;GUICtrlSetData($hFile, "")
                    ;GUICtrlSetData($hPath, "")
                EndIf
                GUICtrlSetState($hStart, $GUI_ENABLE)

            ; Create Program's Daemon
            Case $iMsg = $hCreate
                $filename = GUICtrlRead($hFile)
                $filepath = GUICtrlRead($hPath)
                If $filename = "" Then
                    MsgBox(16, $header, "Please select a program", 3)
                    ContinueLoop
                EndIf
                GUICtrlSetState($hCreate, $GUI_DISABLE)
                $ret = CreateDaemon($filename, $filepath)
                If $ret = "" Then
                    MsgBox(16, $header, "Failed to create the daemon program...:(", 3)
                Else
                    MsgBox(0, $header, "Created the daemon program " & $ret, 3)
                EndIf
                GUICtrlSetState($hCreate, $GUI_ENABLE)

            ; Stop Daemon
            Case $iMsg = $hStop
                $a_indices = _GUICtrlListViewGetSelectedIndices($hListView, 1)
                If (IsArray($a_indices)) Then
                    For $i = $a_indices[0] To 1 Step -1
                        ;MsgBox(0, "Selected", $a_indices[$i])
                        $ret = _GUICtrlListViewGetItemText($hListView, $a_indices[$i])
                        If ($ret <> $LV_ERR) Then
                            ;MsgBox(0, "Selected Item", $ret)
                            $pos = _ArraySearch($pidArray, $ret)
                            If $pos <> "" Then
                                ;_GUICtrlListViewDeleteItem($hListView, $a_indices[$i])
                                _ArrayDelete($pidArray, $pos)
                            EndIf
                        Else
                            MsgBox(16, $header, "Please select the task(s) you want to stop daemon", 3)
                        EndIf
                    Next
                    _GUICtrlListViewDeleteItemsSelected($hListView)
                Else
                    MsgBox(16, $header, "Please select the task(s) you want to stop daemon", 3)
                EndIf
 
            ; 创建多任务的守护程序
            Case $iMsg = $hCreateMul
                GUICtrlSetState($hCreate, $GUI_DISABLE)
                $fileopened = 0
                $a_indices = _GUICtrlListViewGetSelectedIndices($hListView, 1)
                If (IsArray($a_indices)) Then
                    For $i = $a_indices[0] To 1 Step -1
                        $ret = _GUICtrlListViewGetItemText($hListView, $a_indices[$i])
                        If ($ret <> $LV_ERR) Then
                            If $fileopened = 0 Then
                                $fp = FileOpen(@ScriptDir & "\~TaskDaemon.tmp", 2)
                                If $fp = -1 Then
                                    MsgBox(16, $header, "Failed to create temp file...:(", 3)
                                    ContinueLoop
                                EndIf
                                $fileopened = 1
                                FileWriteLine($fp, $ret)
                            Else
                                FileWriteLine($fp, $ret)
                            EndIf
                        Else
                            MsgBox(16, $header, "Please select one or more tasks", 3)
                            ContinueLoop
                        EndIf
                    Next
                    FileClose($fp)
                    $ret = CreateMultiDaemon(@ScriptDir & "\~TaskDaemon.tmp")
                    If $ret = "" Then
                        MsgBox(16, $header, "Failed to create programs' daemon...:(", 3)
                    Else
                        MsgBox(0, $header, "Created the daemon program " & $ret, 3)
                    EndIf
                Else
                    MsgBox(16, $header, "Please select one or more tasks", 3)
                EndIf
                GUICtrlSetState($hCreate, $GUI_ENABLE)

            Case $iMsg = $GUI_EVENT_CLOSE
                GUIDelete($hRunAs)
                Exit
        EndSelect
    Wend
EndFunc

Func DaemonTasks($ctrlid, ByRef $array)
    Local $items = UBound($array)
    Local $i, $pid, $item, $pos, $cont
    Local $filename, $filepath
    
    For $i = 0 To $items - 1
        $item = $array[$i]
        $pos = StringInStr($item, "|", 1, 1)
        If $pos > 1 Then
            $pid = StringLeft($item, $pos - 1)
            If ProcessExists($pid) = 0 Then
                ; Get new filename and path
                $pos = StringInStr($item, "|", 1, -1)
                $filepath = StringRight($item, StringLen($item) - $pos)
                $item = StringLeft($item, $pos - 1)
                $pos = StringInStr($item, "|", 1, -1)
                $filename = StringRight($item, StringLen($item) - $pos)
                
                ; Run again
                $pid = Run($filename, $filepath)
                
                ; Update view and array
                $cont = $pid & "|" & GetMainName($filename) & "|" & $filename & "|" & $filepath
                GUICtrlCreateListViewItem($cont, $ctrlid)
                ;_ArrayDisplay( $array, "1." & $i )
                _GUICtrlListViewDeleteItem($ctrlid, $i - 1)
                _ArrayDelete($array, $i)
                ;_ArrayDisplay( $array, "2." & $i )
                _ArrayAdd($array, $cont)
                ;_ArrayDisplay( $array, "3." & $i )
                Return
            EndIf
        EndIf
    Next
EndFunc

Func GetPath($filename)
	Dim $pos = 0
	Dim $res = $filename
	
	$pos = StringInStr($filename, "\", 0, -1)
    If $pos > 1 Then
        $res = StringLeft($filename, $pos)
    EndIf
	
	Return $res
EndFunc

Func CreateDaemon($filename, $filepath)
    Local $pbody = "#NoTrayIcon" & @CRLF _
                 & "" & @CRLF _
                 & "Dim $pid " & @CRLF _
                 & "" & @CRLF _
                 & "While 1" & @CRLF _
                 & '    $pid = Run("' & $filename & '", "' & $filepath & '")' & @CRLF _
                 & "    ProcessWaitClose($pid)" & @CRLF _
                 & "WEnd" & @CRLF
    Local $au3name, $exename
    Local $fp
    
    ; Write au3 file
    FileChangeDir(@ScriptDir)
    $au3name = GetMainName($filename)
    $exename = $au3name & "Daemon.exe"
    $au3name = $au3name & ".au3"
    $fp = FileOpen($au3name, 2)
    If $fp = -1 Then
        Return ""
    EndIf
    FileWrite($fp, $pbody)
    FileClose($fp)
    
    ; Convert to exe file
    RunWait(@ScriptDir & "\Res\Aut2Exe.exe /in " & $au3name & " /out " & $exename & " /icon " & @ScriptDir & "\Res\daemon.ico" & " /pass " & $au3name & "q1w2e3")
    FileDelete($au3name)
    
    Return $exename
EndFunc

Func GetMainName($filename)
	Dim $pos = 0
	Dim $res = $filename
	
	$pos = StringInStr($filename, "\", 0, -1)
    If $pos > 1 Then
        $res = StringRight($filename, StringLen($filename) - $pos)
    EndIf
    $pos = StringInStr($res, ".", 0, -1)
    If $pos > 1 Then
        $res = StringLeft($res, $pos - 1)
    EndIf
	
	Return $res
EndFunc

Func CreateMultiDaemon($tmpfile)
    Local $pbody = ""
    Local $au3name = "TDaemon.au3", $exename = "TDaemon.exe"
    Local $fp, $filename, $filepath, $pid
    Local $tArray, $x, $item, $pos
    
    If _FileReadToArray($tmpfile, $tArray) = 0 Then
        Return ""
    EndIf
    
    ; Write au3 file
    FileDelete($tmpfile)
    FileChangeDir(@ScriptDir)
    $fp = FileOpen($au3name, 2)
    If $fp = -1 Then
        Return ""
    EndIf
    FileWriteLine($fp, "#NoTrayIcon")
    FileWriteLine($fp, "")
    FileWriteLine($fp, "Dim $pid[" & $tArray[0] & "], $filename[" & $tArray[0] & "], $filepath[" & $tArray[0] & "]")
    FileWriteLine($fp, "Dim $i")
    FileWriteLine($fp, "")
    FileWriteLine($fp, "opt('RunErrorsFatal', 0)")
    FileWriteLine($fp, "")
    For $x = 1 to $tArray[0]
        $item = $tArray[$x]
        $pos = StringInStr($item, "|", 1, -1)
        If $pos < 1 Then
            ContinueLoop
        EndIf
        $filepath = StringRight($item, StringLen($item) - $pos)
        $item = StringLeft($item, $pos - 1)
        $pos = StringInStr($item, "|", 1, -1)
        $filename = StringRight($item, StringLen($item) - $pos)
        ; Write au3 file
        FileWriteLine($fp, '$filename[' & ($x - 1) & '] = "' & $filename & '"')
        FileWriteLine($fp, '$filepath[' & ($x - 1) & '] = "' & $filepath & '"')
        FileWriteLine($fp, "$pid[" & ($x - 1) & "] = Run($filename[" & ($x - 1) & "], $filepath[" & ($x - 1) & "])")
    Next
    FileWriteLine($fp, "")
    FileWriteLine($fp, "While 1")
    FileWriteLine($fp, "    For $i = 0 To " & ($tArray[0] - 1))
    FileWriteLine($fp, "        If ProcessExists($pid[$i]) = 0 Then")
    FileWriteLine($fp, "            $pid[$i] = Run($filename[$i], $filepath[$i])")
    FileWriteLine($fp, "        EndIf")
    FileWriteLine($fp, "    Next")
    FileWriteLine($fp, "    Sleep(1000)")
    FileWriteLine($fp, "WEnd")
    FileClose($fp)
    
    ; Convert to exe file
    RunWait(@ScriptDir & "\Res\Aut2Exe.exe /in " & $au3name & " /out " & $exename & " /icon " & @ScriptDir & "\Res\daemon.ico" & " /pass " & $au3name & "q1w2e3")
    FileDelete($au3name)
    
    Return $exename
EndFunc
