; ==================================================
; SysInfoLogViewer2.au3
; Description: Views a SysInfoLog
; Released: May 22, 2012 - Version: 2.00 by ripdad
; ==================================================
; Modified:
; May 24, 2012 - v2.01 - improvements for HD_SMART_DATA in the html area.
; May 26, 2012 - v2.02 - added Loaded Misc screen.
; June 01, 2012 - v2.03 - some optimizing.
; June 07, 2012 - v2.04 - version change.
; October 02, 2012 - v2.05 - minor changes in code.
; October 03, 2012 - v2.06 - version change.
; October 04, 2012 - v2.07 - Updated GUI with newer code.
; November 05, 2012 - v2.08 - version change.
;
;December 14, 2012 - v2.09
; * Moved QuickFixEngineering to it's own window.
; * Rewrote IsFlagged(), _FlagThisEntry() and _RemoveThisFlag() -- Should work better now.
; * Updated a few functions.
;
Opt('TrayAutoPause', 0)
Opt('MustDeclareVars', 1)
;
Local Const $sTitle = 'SysInfoLog Viewer v2.09'
;
Local $sFile = FileOpenDialog('Select File', @ScriptDir, 'SysInfoLog File (*.log)', 1)
If @error Or Not $sFile Then
    Exit
EndIf
;
If Not StringInStr(FileReadLine($sFile, 2), 'SysInfoLog v2.09') Then
    MsgBox(8240, $sTitle, 'Invalid Log Version:' & @CRLF & $sFile & @TAB)
    Exit
EndIf
;
Local $aSIL = SysInfoLog_ReadToArray($sFile)
Local $error = @error
If $error Or Not IsArray($aSIL) Then
    MsgBox(8256, $sTitle, 'SysInfoLog_ReadToArray --> Error: ' & $error & @TAB, 10)
    Exit
EndIf
;
Local Const $GUI_SHOW = 16, $GUI_HIDE = 32, $GUI_ENABLE = 64, $GUI_DISABLE = 128, $GUI_FOCUS = 256
;
Local $MyFlagsINI = @ScriptDir & '\MyFlags.ini'
Local $NoFlags, $MyFlags = FileExists($MyFlagsINI)
Local $idText = 'System Information'
Local $CurrentScreen, $init = 0
;
Local $pc = StringTrimLeft(FileReadLine($sFile, 3), 12)
Local $dt = StringTrimLeft(FileReadLine($sFile, 4), 12)
Local $str = $sTitle & ' - ' & $pc & '\' & $dt & '      (Right-Click for Menu)'
;
;[GUI]
Local $ID_GUI = GUICreate($str, 600, 400, -1, -1, 0x00CF0000)
Local $ID_LBL = GUICtrlCreateLabel('Loading...', 10, 10, 200, 25)
GUICtrlSetFont($ID_LBL, 12)
Local $ID_FLAG, $ID_LV
Local $aCM[32] = [31]
GUISetOnEvent(-3, '_AllExit')
GUISetOnEvent(-5, 'SIL_AutoSizeGUI')
GUISetOnEvent(-6, 'SIL_AutoSizeGUI')
GUISetOnEvent(-12, 'SIL_AutoSizeGUI')
Opt('GUIOnEventMode', 1)
GUISetState(@SW_SHOW, $ID_GUI)
;[/GUI]
;
_LvScreen()
$init = 1
;
GUIRegisterMsg(0x0024, '_WM_GETMINMAXINFO')
;
While Sleep(60000)
WEnd
;
Func _LvScreen()
    If $init Then $idText = GUICtrlRead(@GUI_CtrlId, 1)
    ;
    Local $aItems = SysInfoLog_ReadSection($aSIL, $idText)
    If @error Or Not IsArray($aItems) Then
        MsgBox(8256, $sTitle, $idText & @CRLF & @CRLF & 'No Entries Found' & @TAB & @TAB)
        Return
    EndIf
    ;
    Local $a, $flag, $ID_Item, $icon, $sItem, $type
    GUICtrlSetState($ID_LBL, $GUI_SHOW)
    ;
    Switch $idText
        Case 'Common Startups'
            SIL_CreateListView($ID_LV, $idText & '|Source|Company Name|Version|File Description|Created')
            $NoFlags = 0
            ;
            For $i = 1 To $aItems[0][0]

				timeToLoad($i, $aItems[0][0], $ID_LBL)

                $sItem = $aItems[$i][0]
                If Not StringExists($sItem) Then
                    ContinueLoop
                EndIf
                $type = $aItems[$i][1]
                $icon = $aItems[$i][2]
                $flag = $aItems[$i][3]
                ;
                ;
                ;[Empty Entry Filter] - If you don't want this filter, then comment or remove it.
                If StringRegExp($type, '(1|3)') Then
                    If ($i = $aItems[0][0]) Then ExitLoop
                    If Not StringRegExp($aItems[$i + 1][1], '(2|4)') Then
                        ContinueLoop
                    EndIf
                EndIf;[/Empty Entry Filter]
                ;
                ;
                If StringInStr($sItem, '-->') Then
                    $a = StringSplit($sItem, '-->', 1)
                    $sItem = StringReplace($a[2], '|', '|' & $a[1] & '|', 1)
                EndIf
                $ID_Item = GUICtrlCreateListViewItem($sItem, $ID_LV)
                ;
                If $type = 1 Then
                    GUICtrlSetImage($ID_Item, 'regedit.exe', 100)
                    ContinueLoop
                ElseIf $type = 3 Then
                    GUICtrlSetImage($ID_Item, 'explorer.exe', 252)
                    ContinueLoop
                ElseIf $type = 2 Then
                    If $icon = 0 Then
                    ElseIf ($icon = 1) Or ($icon = 2) Then
                        GUICtrlSetImage($ID_Item, 'regedit.exe', 205)
                    Else
                        GUICtrlSetImage($ID_Item, 'regedit.exe', 206)
                    EndIf
                ElseIf $type = 4 Then
                    GUICtrlSetImage($ID_Item, 'shell32.dll', 3)
                EndIf
                ;
                If $flag = 1 Then; Internal Flags
                    GUICtrlSetBkColor($ID_Item, 0xFF8080)
                    ContinueLoop
                EndIf
                ;
                $flag = IsFlagged($sItem); User Flags
                If $flag Then
                    $sItem = StringLeft($sItem, StringInStr($sItem, '|', 0, 1) - 1) & $flag
                    GUICtrlSetData($ID_Item, $sItem)
                    GUICtrlSetBkColor($ID_Item, 0xFF8080)
                Else
                    GUICtrlSetBkColor($ID_Item, 0xFFD0D0)
                EndIf
            Next
            ;
            LV_SetColumnWidth($ID_LV, '420|90|125|90|130|70')
            GUICtrlSetState($ID_FLAG, $GUI_ENABLE)
            ;
        Case 'System Information', 'NTLog_Errors', 'NTLog_Warnings', 'NTLog_ChkDsk', 'Hosts File', 'QuickFixEngineering'
            If $idText = 'QuickFixEngineering' Then
                SIL_CreateListView($ID_LV, $idText & '|Date Installed')
                LV_SetColumnWidth($ID_LV, '200|600')
            ElseIf $idText = 'System Information' Then
                SIL_CreateListView($ID_LV, $idText & '| ')
                LV_SetColumnWidth($ID_LV, '250|600')
            Else
                SIL_CreateListView($ID_LV, $idText)
                LV_SetColumnWidth($ID_LV, '850')
            EndIf
            $NoFlags = 1
            ;
            For $i = 1 To $aItems[0][0]

				timeToLoad($i, $aItems[0][0], $ID_LBL)

                $ID_Item = GUICtrlCreateListViewItem($aItems[$i][0], $ID_LV)
                If StringInStr($aItems[$i][0], '<--', 0, 1, 1, 4) Then GUICtrlSetBkColor($ID_Item, 0xDFDFDF)
            Next
            ;
            GUICtrlSetState($ID_FLAG, $GUI_DISABLE)
            ;
        Case 'Registry Settings'
            SIL_CreateListView($ID_LV, $idText)
            $NoFlags = 0
            ;
            For $i = 1 To $aItems[0][0]

				timeToLoad($i, $aItems[0][0], $ID_LBL)

                $sItem = $aItems[$i][0]
                If Not StringExists($sItem) Then ContinueLoop
                $ID_Item = GUICtrlCreateListViewItem($sItem, $ID_LV)
                ;
                If $aItems[$i][1] = 1 Then
                    GUICtrlSetImage($ID_Item, 'regedit.exe', 100)
                    GUICtrlSetBkColor($ID_Item, 0xDFDFDF)
                Else
                    $icon = $aItems[$i][2]
                    If $icon = 0 Then
                        ; do nothing
                    ElseIf StringRegExp($icon, '(1|2)') Then
                        GUICtrlSetImage($ID_Item, 'regedit.exe', 205)
                    Else
                        GUICtrlSetImage($ID_Item, 'regedit.exe', 206)
                    EndIf
                    ;
                    $flag = IsFlagged($sItem)
                    If $flag Then
                        GUICtrlSetData($ID_Item, $sItem & $flag)
                        GUICtrlSetBkColor($ID_Item, 0xFF8080)
                    EndIf
                EndIf
            Next
            ;
            LV_SetColumnWidth($ID_LV, '800')
            GUICtrlSetState($ID_FLAG, $GUI_ENABLE)
            ;
        Case 'Running Programs', 'Running Services', 'Loaded Drivers', 'Loaded Dlls', 'Loaded Misc'
            If StringMatch($idText, 'Running Services|Loaded Drivers') Then
                SIL_CreateListView($ID_LV, $idText & '|Display Name|Company Name|Version|File Description|Created')
                LV_SetColumnWidth($ID_LV, '300|150|110|100|200|90')
            Else
                SIL_CreateListView($ID_LV, $idText & '|Company Name|Version|File Description|Created')
                LV_SetColumnWidth($ID_LV, '300|140|110|180|80')
            EndIf
            $NoFlags = 0
            ;
            For $i = 1 To $aItems[0][0]

				timeToLoad($i, $aItems[0][0], $ID_LBL)

                $sItem = $aItems[$i][0]
                If Not StringExists($sItem) Then
                    $i -= 1
                    ExitLoop
                EndIf
                $ID_Item = GUICtrlCreateListViewItem($sItem, $ID_LV)
                ;
                $flag = IsFlagged($sItem)
                If $flag Then
                    $sItem = StringLeft($sItem, StringInStr($sItem, '|', 0, 1) - 1) & $flag
                    GUICtrlSetData($ID_Item, $sItem)
                    GUICtrlSetBkColor($ID_Item, 0xFF8080)
                EndIf
                If ($idText <> 'Loaded Dlls') Then
                    GUICtrlSetImage($ID_Item, 'shell32.dll', 3)
                EndIf
            Next
            ;
            GUICtrlSetData($ID_LV, $idText & ': ' & $i)
            GUICtrlSetState($ID_FLAG, $GUI_ENABLE)
            ;
        Case 'HD_SMART_DATA'
            SIL_CreateListView($ID_LV, 'Attribute|Nom/Flag|Status|Value/%|Worst/%|Raw/Value|Cycles|VSD1|VSD2|VSD3|VSD4|VSD5|Threshold|SumCounts|DriveInfo / AttributeName')
            $NoFlags = 1
            ;
            For $i = 1 To $aItems[0][0]

				timeToLoad($i, $aItems[0][0], $ID_LBL)

                If StringInStr($aItems[$i][0], '*') Then
                    $ID_Item = GUICtrlCreateListViewItem('||||||||||||||' & $aItems[$i][0], $ID_LV)
                    If $aItems[$i][0] Then
                        If StringInStr($aItems[$i][0], 'PredictFailure=True') Then
                            GUICtrlSetBkColor($ID_Item, 0xFF8080); red-ish
                        Else
                            GUICtrlSetBkColor($ID_Item, 0xDFDFDF); gray-ish
                        EndIf
                    EndIf
                ElseIf StringIsDigit(StringLeft($aItems[$i][0], 1)) Then
                    $ID_Item = GUICtrlCreateListViewItem($aItems[$i][0], $ID_LV)
                ElseIf StringInStr($aItems[$i][0], 'Object Error') Then
                    $ID_Item = GUICtrlCreateListViewItem($aItems[$i][0], $ID_LV)
                EndIf
            Next
            ;
            LV_SetColumnWidth($ID_LV, '-2|-2|-2|-2|-2|-2|-2|-2|-2|-2|-2|-2|-2|-2|-1')
            GUICtrlSetState($ID_FLAG, $GUI_DISABLE)
            ;
        Case Else
            ;
    EndSwitch
    ;
    $aItems = ''
    $CurrentScreen = $idText
    GUICtrlSetState($ID_LBL, $GUI_HIDE)
    GUICtrlSetState($ID_LV, $GUI_SHOW)
    GUICtrlSetState($ID_LV, $GUI_FOCUS)
EndFunc
;
Func LV_SetColumnWidth(ByRef $IDLV, $sWidth)
    Local $a = StringSplit($sWidth, '|')
    For $i = 1 To $a[0]
        GUICtrlSendMsg($IDLV, 0x101E, $i - 1, Number($a[$i]))
    Next
EndFunc
;
Func SIL_AutoSizeGUI()
    Local $a = WinGetClientSize($sTitle)
    If IsArray($a) Then
        ControlMove($ID_GUI, '', $ID_LV, 5, 0, $a[0] - 10, $a[1] - 20)
    EndIf
EndFunc
;
Func SIL_CreateListView(ByRef $IDLV, $sHeader)
    GUICtrlSetState($IDLV, $GUI_HIDE)
    GUICtrlDelete($IDLV)
    $IDLV = ''
    $IDLV = GUICtrlCreateListView($sHeader, 0, 1000, 0, 0)
    GUICtrlSetState($IDLV, $GUI_HIDE)
    GUICtrlSendMsg($IDLV, 0x1036, 0, 0x14230); trancexx - egg?
    SIL_CreateContextMenu()
    SIL_AutoSizeGUI()
EndFunc
;
Func SIL_CreateContextMenu()
    For $i = $aCM[0] To 1 Step -1
        If $aCM[$i] Then
            GUICtrlSetOnEvent($aCM[$i], '')
            GUICtrlDelete($aCM[$i])
            $aCM[$i] = ''
        EndIf
    Next
    $aCM[1] = GUICtrlCreateContextMenu($ID_LV)
    $aCM[2] = GUICtrlCreateMenuItem('Copy to Clipboard', $aCM[1])
    $aCM[3] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[4] = GUICtrlCreateMenuItem('System Information', $aCM[1])
    $aCM[5] = GUICtrlCreateMenuItem('Common Startups', $aCM[1])
    $aCM[6] = GUICtrlCreateMenuItem('Registry Settings', $aCM[1])
    $aCM[7] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[8] = GUICtrlCreateMenuItem('Running Programs', $aCM[1])
    $aCM[9] = GUICtrlCreateMenuItem('Running Services', $aCM[1])
    $aCM[10] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[11] = GUICtrlCreateMenuItem('Loaded Drivers', $aCM[1])
    $aCM[12] = GUICtrlCreateMenuItem('Loaded Dlls', $aCM[1])
    $aCM[13] = GUICtrlCreateMenuItem('Loaded Misc', $aCM[1])
    $aCM[14] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[15] = GUICtrlCreateMenuItem('NTLog_Errors', $aCM[1])
    $aCM[16] = GUICtrlCreateMenuItem('NTLog_Warnings', $aCM[1])
    $aCM[17] = GUICtrlCreateMenuItem('NTLog_ChkDsk', $aCM[1])
    $aCM[18] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[19] = GUICtrlCreateMenuItem('Hosts File', $aCM[1])
    $aCM[20] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[21] = GUICtrlCreateMenuItem('HD_SMART_DATA', $aCM[1])
    $aCM[22] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[23] = GUICtrlCreateMenuItem('QuickFixEngineering', $aCM[1])
    $aCM[24] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[25] = GUICtrlCreateMenu('Export to HTML', $aCM[1])
    $aCM[26] = GUICtrlCreateMenuItem('Export Screen', $aCM[25])
    $aCM[27] = GUICtrlCreateMenuItem('Export All', $aCM[25])
    $aCM[28] = GUICtrlCreateMenuItem('', $aCM[1])
    $aCM[29] = GUICtrlCreateMenu('Flag', $aCM[1])
    $aCM[30] = GUICtrlCreateMenuItem('Flag This Entry', $aCM[29])
    $aCM[31] = GUICtrlCreateMenuItem('Remove This Flag', $aCM[29])
    GUICtrlSetOnEvent($aCM[2], '_Copy2Clip')
    GUICtrlSetOnEvent($aCM[4], '_LvScreen')
    GUICtrlSetOnEvent($aCM[5], '_LvScreen')
    GUICtrlSetOnEvent($aCM[6], '_LvScreen')
    GUICtrlSetOnEvent($aCM[8], '_LvScreen')
    GUICtrlSetOnEvent($aCM[9], '_LvScreen')
    GUICtrlSetOnEvent($aCM[11], '_LvScreen')
    GUICtrlSetOnEvent($aCM[12], '_LvScreen')
    GUICtrlSetOnEvent($aCM[13], '_LvScreen')
    GUICtrlSetOnEvent($aCM[15], '_LvScreen')
    GUICtrlSetOnEvent($aCM[16], '_LvScreen')
    GUICtrlSetOnEvent($aCM[17], '_LvScreen')
    GUICtrlSetOnEvent($aCM[19], '_LvScreen')
    GUICtrlSetOnEvent($aCM[21], '_LvScreen')
    GUICtrlSetOnEvent($aCM[23], '_LvScreen')
    GUICtrlSetOnEvent($aCM[26], '_Export2HTML')
    GUICtrlSetOnEvent($aCM[27], '_Export2HTML')
    GUICtrlSetOnEvent($aCM[30], '_FlagThisEntry')
    GUICtrlSetOnEvent($aCM[31], '_RemoveThisFlag')
    $ID_FLAG = $aCM[29]
EndFunc
;
Func _Copy2Clip()
    Local $s = StringTrimRight(GUICtrlRead(GUICtrlRead($ID_LV)), 1)
    If StringRegExp($s, '[\w]') Then
        ClipPut($s)
    Else
        ClipPut('')
    EndIf
EndFunc
;
Func _AllExit()
    GUIRegisterMsg(0x0024, '')
    Opt('GUIOnEventMode', 0)
    GUIDelete($ID_GUI)
    $aSIL = ''
    Exit
EndFunc
;
Func _WM_GETMINMAXINFO($hwnd, $msg, $wParam, $lParam)
    Local $tagMaxinfo = DllStructCreate('int;int;int;int;int;int;int;int;int;int', $lParam)
    DllStructSetData($tagMaxinfo, 7, 600); min-width
    DllStructSetData($tagMaxinfo, 8, 400); min-height
    Return 'GUI_RUNDEFMSG'
EndFunc
;
Func IsFlagged($sItem)
    If $NoFlags Or Not $MyFlags Then Return ''
    $sItem = StringStripWS(StringRegExpReplace($sItem, '(\|).*', ''), 3)
    $sItem = StringReplace($sItem, '=', '*')
    Return IniRead($MyFlagsINI, 'Flagged', $sItem, '')
EndFunc
;
Func _FlagThisEntry()
    If $NoFlags Then Return
    Local $id = GUICtrlRead($ID_LV)
    Local $sItem = GUICtrlRead($id)
    If Not StringInStr($sItem, '|') Then Return
    If StringInStr($sItem, 'HKEY', 0, 1, 1, 4) Then Return
    If StringInStr($sItem, '<--[') Then Return
    ;
    $sItem = StringStripWS(StringRegExpReplace($sItem, '(\|).*', ''), 3)
    If StringMatch($sItem, '(Default) = (value not set)') Then Return
    ;
    Local $comment = InputBox($sTitle, @CRLF & '  Enter Flag Comment', Default, Default, Default, 150)
    If @error Then Return
    If Not StringExists($comment) Then $comment = 'No Comment'
    ;
    If IniWrite($MyFlagsINI, 'Flagged', StringReplace($sItem, '=', '*'), '<--[' & $comment & ']') Then
        GUICtrlSetData($id, $sItem & '<--[' & $comment & ']')
        GUICtrlSetBkColor($id, 0xFF8080)
        Send('{Down}')
        $MyFlags = 1
    EndIf
EndFunc
;
Func _RemoveThisFlag()
    If $NoFlags Or Not $MyFlags Then Return
    Local $sItem = GUICtrlRead(GUICtrlRead($ID_LV))
    If Not StringInStr($sItem, '<--[') Then Return
    ;
    $sItem = StringStripWS(StringRegExpReplace($sItem, '(\|).*', ''), 3)
    $sItem = StringReplace($sItem, '=', '*')
    $sItem = StringReplace($sItem, '<--[', '=<--[')
    Local $a = StringSplit($sItem, '=')
    If ($a[0] <> 2) Then Return
    ;
    If StringMatch(IniRead($MyFlagsINI, 'Flagged', $a[1], 0), $a[2]) Then
        If IniDelete($MyFlagsINI, 'Flagged', $a[1]) Then
            $init = 0
            $idText = $CurrentScreen
            _LvScreen()
            $init = 1
        EndIf
    EndIf
EndFunc
;
;==============================================================
; #Function...: StringExists($s, $n)
; Description.: Test if a string, else whitespace.
; Version.....; 0.1 (simple version)
; Syntax......: $s = Input String.
;.............: $n = Number of characters to test.
; Remarks.....: Returns positive number if string, else 0.
;==============================================================
Func StringExists($s, $n = 30)
    Return StringLen(StringStripWS(StringLeft($s, $n), 8))
EndFunc
;
;===============================================================
;....#Function: StringMatch($s, $c, $m, $d)
;..Description: Compares with single or multiple strings.
;......Version; 0.3
;.............:
;.......Syntax: $s = Input string
;.............: $c = Compare string
;.............: $m = Function mode
;.............: $d = Delimiter
;.............:
;........Modes: 0 - Returns position number if matched, else 0.
;.............: 1 - Normal Statement
;.............: 2 - NOT Statement
;.............: 3 - Multiple StringInStr
;===============================================================
Func StringMatch($s, $c, $m = 0, $d = '|')
    $s = StringLower($s)
    $c = StringLower($c)
    Local $a = StringSplit($c, $d, 1)
    Local $n = 0
    ;
    Switch $m
        Case 0, 1, 2
            For $i = 1 To $a[0]
                If ($s == $a[$i]) Then
                    $n = $i
                    ExitLoop
                EndIf
            Next
            Switch $m
                Case 0
                    If $n Then Return $n; <- position number
                Case 1
                    If Not $n Then Return 1
                Case 2
                    If $n Then Return 1
            EndSwitch
        Case 3
            For $i = 1 To $a[0]
                If StringInStr($s, $a[$i]) Then
                    Return $i; <- position/offset number
                EndIf
            Next
        Case Else
            Return -1; <- invalid mode
    EndSwitch
EndFunc
;
Func SysInfoLog_ReadSection(ByRef $aSIL, $section)
    $section = '[' & $section & ']'
    Local $c = 0, $End = $aSIL[0][0] - 1
    Local $array[$aSIL[0][0] + 1][4]
    ;
    For $i = 1 To $aSIL[0][0]
        If ($aSIL[$i][0] <> $section) Then
            ContinueLoop
        EndIf
        $i += 1
        For $j = $i To $End
            If StringLeft($aSIL[$j][0], 1) = '[' Then
                ExitLoop 2
            EndIf
            $c += 1
            $array[$c][0] = $aSIL[$j][0]
            $array[$c][1] = $aSIL[$j][1]
            $array[$c][2] = $aSIL[$j][2]
            $array[$c][3] = $aSIL[$j][3]
        Next
        ExitLoop
    Next
    If ($c = 0) Then Return SetError(-1)
    ReDim $array[$c + 1][4]
    $array[0][0] = $c
    Return $array
EndFunc
;
Func SysInfoLog_ReadToArray($LogFile)
    If Not FileExists($LogFile) Then Return SetError(-1, 0, 0)
    Local $fo = FileOpen($LogFile)
    If $fo = -1 Then Return SetError(-2, 0, 0)
    Local $s, $fr = StringStripCR(FileRead($fo))
    FileClose($fo)
    Local $a = StringSplit($fr, @LF)
    If $a[0] < 20 Then Return SetError(-3, 0, 0)
    Local $array[$a[0] + 1][4] = [[0, 'Type', 'Icon', 'Flag']]
    ;
    For $i = 1 To $a[0]
        $s = $a[$i]
        If StringInStr(StringRight($s, 4), '^', 0, 1, 1, 1) Then
            $array[$i][0] = StringLeft($s, StringInStr($s, '^', 0, -1) - 1)
            $array[$i][1] = StringLeft(StringRight($s, 3), 1)
            $array[$i][2] = StringLeft(StringRight($s, 2), 1)
            $array[$i][3] = StringRight($s, 1)
        Else
            $array[$i][0] = $s
        EndIf
    Next
    ReDim $array[$i + 1][4]
    $array[0][0] = $i
    Return $array
EndFunc
;
Func _Export2HTML()
    $idText = GUICtrlRead(@GUI_CtrlId, 1)
    Local $aSections, $fo, $rtn, $sHTML, $string, $style
    If $idText = 'Export All' Then
        $sHTML = StringReplace($sFile, '.log', '.html')
    Else
        $sHTML = @ScriptDir & '\Export_' & $CurrentScreen & '.html'
    EndIf
    $fo = FileOpen($sHTML, 2)
    If $fo = -1 Then Return
    ;
    $style = '<style type="text/css">' & @CRLF
    $style &= '   body{background:#FFFFFF;margin:4px;padding:0;}' & @CRLF
    $style &= '   table{width:1000px;border-width:0;border-spacing:0;border-collapse:collapse;padding:0;}' & @CRLF
    $style &= '   td{border-width:1px;border-spacing:0;border-collapse:collapse;padding:1px;border-style:solid;' & @CRLF
    $style &= '   border-color:#909090;font-family:arial;font-size:12px;font-weight:normal;color:#000000;text-decoration:none;}' & @CRLF
    $style &= '</style>' & @CRLF & @CRLF
    ;
    $string = '<html><head><title>' & StringTrimLeft($aSIL[2][0], 2) & ' - ' & StringTrimLeft($aSIL[3][0], 2) & ' - '
    $string &= StringTrimLeft($aSIL[4][0], 2) & '</title>' & @CRLF & @CRLF & $style & '</head><body>' & @CRLF & @CRLF
    FileWrite($fo, $string)
    ;
    Switch $idText
        Case 'Export Screen'
            $rtn = SysInfoLog_Export2HTML($aSIL, $CurrentScreen)
            FileWrite($fo, $rtn & '</body></html>' & @CRLF)
        Case 'Export All'
            $aSections = StringSplit('System Information|HD_SMART_DATA|Common Startups|Running Programs|Running Services|Loaded Drivers|Loaded Dlls|Loaded Misc|Registry Settings|NTLog_Errors|NTLog_Warnings|NTLog_ChkDsk|Hosts File|QuickFixEngineering', '|')
            For $i = 1 To $aSections[0]
                $rtn = SysInfoLog_Export2HTML($aSIL, $aSections[$i])
                FileWrite($fo, $rtn)
            Next
            FileWrite($fo, '</body></html>' & @CRLF)
    EndSwitch
    ;
    FileClose($fo)
    MsgBox(8256, $sTitle, 'Export Finished' & @TAB)
EndFunc
;
Func SysInfoLog_Export2HTML(ByRef $aSIL, $section)
    Local $aItems = SysInfoLog_ReadSection($aSIL, $section)
    If @error Or Not IsArray($aItems) Then Return SetError(-1)
    Local $a, $n, $s
    ;
    Switch $section
        Case 'Running Services', 'Loaded Drivers'
            $s = '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td width="500"><font size="4">' & $section & '</font></td><td width="200">Display Name</td><td width="200">Company Name</td><td width="100">Version</td><td width="200">File Description</td><td width="100">Created</td></tr>' & @CRLF
            For $i = 1 To $aItems[0][0]

                If ($aItems[$i][0] = '') Then ContinueLoop
                If StringInStr($aItems[$i][0], '|') Then
                    $a = StringSplit($aItems[$i][0], '|')
                    If $a[0] <> 6 Then Return ''
                    For $j = 1 To $a[0]
                        If ($a[$j] = '') Then $a[$j] = '&nbsp;'
                    Next
                    $s &= '   <tr><td width="500">' & $a[1] & '</td><td width="200">' & $a[2] & '</td><td width="200">' & $a[3] & '</td><td width="100">' & $a[4] & '</td><td width="200">' & $a[5] & '</td><td width="100">' & $a[6] & '</td></tr>' & @CRLF
                Else
                    If StringInStr($aItems[$i][0], 'HKEY') Then
                        If StringInStr($aItems[$i + 1][0], 'HKEY') Then ContinueLoop
                    Else
                        If Not StringInStr($aItems[$i][0], '.') And Not ($aItems[$i][0] = $aItems[0][0]) Then
                            If Not StringInStr($aItems[$i + 1][0], '.') Then ContinueLoop
                        EndIf
                    EndIf
                    $s &= '   <tr bgcolor="#CCCCCC"><td width="500">' & $aItems[$i][0] & '</td><td width="200">&nbsp;</td><td width="200">&nbsp;</td><td width="100">&nbsp;</td><td width="200">&nbsp;</td><td width="100">&nbsp;</td></tr>' & @CRLF
                EndIf
            Next
        Case 'Common Startups', 'Running Programs', 'Loaded Dlls', 'Loaded Misc'
            $s = '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td width="500"><font size="4">' & $section & '</font></td><td width="200">Company Name</td><td width="100">Version</td><td width="200">File Description</td><td width="100">Created</td></tr>' & @CRLF
            For $i = 1 To $aItems[0][0]
                If ($aItems[$i][0] = '') Then ContinueLoop
                If StringInStr($aItems[$i][0], '|') Then
                    $a = StringSplit($aItems[$i][0], '|')
                    For $j = 1 To $a[0]
                        If ($a[$j] = '') Then $a[$j] = '&nbsp;'
                    Next
                    $s &= '   <tr><td width="500">' & $a[1] & '</td><td width="200">' & $a[2] & '</td><td width="100">' & $a[3] & '</td><td width="200">' & $a[4] & '</td><td width="100">' & $a[5] & '</td></tr>' & @CRLF
                Else
                    If StringInStr($aItems[$i][0], 'HKEY') Then
                        If StringInStr($aItems[$i + 1][0], 'HKEY') Then ContinueLoop
                    Else
                        If Not StringInStr($aItems[$i][0], '.') And Not ($aItems[$i][0] = $aItems[0][0]) Then
                            If Not StringInStr($aItems[$i + 1][0], '.') Then ContinueLoop
                        EndIf
                    EndIf
                    $s &= '   <tr bgcolor="#CCCCCC"><td width="500">' & $aItems[$i][0] & '</td><td width="200">&nbsp;</td><td width="100">&nbsp;</td><td width="200">&nbsp;</td><td width="100">&nbsp;</td></tr>' & @CRLF
                EndIf
            Next
        Case 'System Information', 'QuickFixEngineering'
            $s = '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td width="200"><font size="4">' & $section & '</font></td><td width="800" align="center">' & StringTrimLeft($aSIL[3][0], 2) & ' -- ' & StringTrimLeft($aSIL[4][0], 2) & '</td></tr>' & @CRLF
            For $i = 1 To $aItems[0][0]
                If StringInStr($aItems[$i][0], '|') Then
                    $a = StringSplit($aItems[$i][0], '|')
                    If ($a[1] = '') Then $a[1] = '&nbsp;'
                    If ($a[2] = '') Then $a[2] = '&nbsp;'
                    $s &= '   <tr><td>' & $a[1] & '</td><td>' & $a[2] & '</td></tr>' & @CRLF
                ElseIf $aItems[$i][0] Then
                    If StringInStr($aItems[$i][0], '<--') Then
                        $s &= '   <tr bgcolor="#CCCCCC"><td>' & StringReplace($aItems[$i][0], '<--', '') & '</td><td>&nbsp;</td></tr>' & @CRLF
                    Else
                        $s &= '   <tr><td>' & $aItems[$i][0] & '</td><td>&nbsp;</td></tr>' & @CRLF
                    EndIf
                Else
                    $s &= '   <tr><td>&nbsp;</td><td>&nbsp;</td></tr>' & @CRLF
                EndIf
            Next
        Case 'Registry Settings'
            $s = '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td><font size="4">' & $section & '</font></td></tr>' & @CRLF
            For $i = 1 To $aItems[0][0]
                If StringLeft($aItems[$i][0], 4) = 'HKEY' Then
                    $s &= '   <tr><td bgcolor="#CCCCCC">' & $aItems[$i][0] & '</td></tr>' & @CRLF
                ElseIf $aItems[$i][0] Then
                    $s &= '   <tr><td>' & $aItems[$i][0] & '</td></tr>' & @CRLF
                EndIf
            Next
        Case 'HD_SMART_DATA'
            For $i = 1 To $aItems[0][0]
                If StringInStr($aItems[$i][0], '*') Then
                    $s &= '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td><b>HD_SMART_DATA</b></td><td>' & StringReplace($aItems[$i][0], '*', '</td><td>') & '</td></tr>' & @CRLF & '</table>' & @CRLF
                    $n = 1
                ElseIf StringInStr($aItems[$i][0], '|') Then
                    If $n Then
                        $s &= '<table>' & @CRLF & '   <tr bgcolor="#CCCCCC">'
                        $n = 0
                    Else
                        $s &= '   <tr>'
                    EndIf
                    $a = StringSplit($aItems[$i][0], '|')
                    For $j = 1 To $a[0]
                        $s &= '<td>' & $a[$j] & '</td>'
                    Next
                    $s &= '</tr>' & @CRLF
                ElseIf $aItems[$i - 1][0] Then
                    $s &= '</table>' & @CRLF
                EndIf
            Next
            $s &= '<br>' & @CRLF
            Return $s
        Case Else
            $s = '<table>' & @CRLF & '   <tr bgcolor="#C0FFC0"><td><font size="4">' & $section & '</font></td></tr>' & @CRLF
            For $i = 1 To $aItems[0][0]
                If StringInStr($aItems[$i][0], '<--') Then
                    $s &= '   <tr><td bgcolor="#CCCCCC">' & StringReplace($aItems[$i][0], '<--', '') & '</td></tr>' & @CRLF
                ElseIf $aItems[$i][0] Then
                    $s &= '   <tr><td>' & $aItems[$i][0] & '</td></tr>' & @CRLF
                EndIf
            Next
    EndSwitch
    $s &= '</table>' & @CRLF & '<br>' & @CRLF
    Return $s
EndFunc
;
Func timeToLoad($forValue, $max, $id)
	Local $Value, $data = 'Loading...'

	$Value = Floor($forValue * 100 / $max) ; value for the progress bar
	if $Value < 100 then $data = $data & ' ' & $Value & ' %'

	GUICtrlSetData($id, $data)

EndFunc   ;==>tempsLoading
