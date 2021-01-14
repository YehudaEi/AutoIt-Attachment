
#include <GUIConstants.au3>
Global $hide_state = 0, $btn_state = 0, $pass = 0
Global $Button_[15], $Label_[15], $config_[8]

If Not FileExists(@ScriptDir & "\toolbar.ini") Then Create_ini()
$Label_name = IniReadSection(@ScriptDir & "\toolbar.ini", "Label")
$Launch_name = IniReadSection(@ScriptDir & "\toolbar.ini", "Launch")

$hwnd= GUICreate("Sliding Launcher", 603, 85+85, -588, -1, -1,  BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW, $WS_EX_ACCEPTFILES))
$config_[1] = GUICtrlCreateLabel("Label Name", 15, 32, 60, 20)
$config_[2] = GUICtrlCreateInput("", 75, 30, 80, 20)
$config_[3] = GUICtrlCreateLabel("Program to Launch", 175, 32, 100, 20)
$config_[4] = GUICtrlCreateInput("", 270, 30, 255, 20)
GUICtrlSetState( -1, $GUI_DROPACCEPTED )
$config_[5] = GUICtrlCreateButton("Cancel", 530, 5, 50, 20)
$config_[6] = GUICtrlCreateButton("Browse", 530, 30, 50, 20)
$config_[7] = GUICtrlCreateButton("Accept", 530, 55, 50, 20)
For $x = 1 To 7
    GUICtrlSetState($config_[$x], $GUI_HIDE)
Next
;$author = GUICtrlCreateLabel(" By...   Simucal  &&  Valuater", 120, 25, 400, 40)
;GUICtrlSetFont(-1, 20, 700)
$Show = GUICtrlCreateButton(">", 585, 8, 17, 155, BitOR($BS_CENTER, $BS_FLAT))
GUISetState(@SW_HIDE, $hwnd)

$hwnd2 = GUICreate("Sliding Launcher", 603, 85+85, 3, -1, -1, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
$Button_[1] = GUICtrlCreateButton("", 20, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[1][1])
$Label_[1] = GUICtrlCreateLabel($Label_name[1][1], 20, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[2] = GUICtrlCreateButton("", 100, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[2][1])
$Label_[2] = GUICtrlCreateLabel($Label_name[2][1], 100, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[3] = GUICtrlCreateButton("", 180, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[3][1])
$Label_[3] = GUICtrlCreateLabel($Label_name[3][1], 180, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[4] = GUICtrlCreateButton("", 260, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[4][1])
$Label_[4] = GUICtrlCreateLabel($Label_name[4][1], 260, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[5] = GUICtrlCreateButton("", 340, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[5][1])
$Label_[5] = GUICtrlCreateLabel($Label_name[5][1], 340, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[6] = GUICtrlCreateButton("", 420, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[6][1])
$Label_[6] = GUICtrlCreateLabel($Label_name[6][1], 420, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[7] = GUICtrlCreateButton("", 500, 35, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[7][1])
$Label_[7] = GUICtrlCreateLabel($Label_name[7][1], 500, 8, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[8] = GUICtrlCreateButton("", 20, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[8][1])
$Label_[8] = GUICtrlCreateLabel($Label_name[8][1], 20, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[9] = GUICtrlCreateButton("", 100, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[9][1])
$Label_[9] = GUICtrlCreateLabel($Label_name[9][1], 100, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[10] = GUICtrlCreateButton("", 180, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[10][1])
$Label_[10] = GUICtrlCreateLabel($Label_name[10][1], 180, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[11] = GUICtrlCreateButton("", 260, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[11][1])
$Label_[11] = GUICtrlCreateLabel($Label_name[11][1], 260, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[12] = GUICtrlCreateButton("", 340, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[12][1])
$Label_[12] = GUICtrlCreateLabel($Label_name[12][1], 340, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[13] = GUICtrlCreateButton("", 420, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[13][1])
$Label_[13] = GUICtrlCreateLabel($Label_name[13][1], 420, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Button_[14] = GUICtrlCreateButton("", 500, 120, 73, 41, $BS_ICON)
GUICtrlSetImage(-1, $Launch_name[14][1])
$Label_[14] = GUICtrlCreateLabel($Label_name[14][1], 500, 93, 73, 17, $SS_CENTER + $SS_SUNKEN)
$Hide = GUICtrlCreateButton("<", 585, 8, 17, 155, BitOR($BS_CENTER, $BS_FLAT, $BS_MULTILINE))
$Edit = GUICtrlCreateButton("[]", 0, 8, 15, 155, BitOR($BS_CENTER, $BS_FLAT, $BS_MULTILINE))
GUICtrlSetTip(-1, "Config")
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00040001);slide in from left
GUISetState()

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)
$config_tray = TrayCreateItem("Configure...")
TrayItemSetOnEvent(-1, "Set_config")
TrayCreateItem("")
$exit_tray = TrayCreateItem("Exit  Sliding Launcher")
TrayItemSetOnEvent(-1, "Set_Exit")
TraySetState()

While 1
    $msg1 = GUIGetMsg()
    If $msg1 = $GUI_EVENT_CLOSE Then Exit
    If $msg1 = $Hide Then
        If $pass = 1 Then
            WinSetTitle($hwnd2, "", "Sliding Launcher")
            $pass = 0
        Else
            Slide_out()
        EndIf
    EndIf
    If $msg1 = $Show Then Slide_in()
    If $msg1 = $Edit Then $pass = 1
    $a_pos = WinGetPos($hwnd2)
    $a_pos2 = WinGetPos($hwnd)
    If $a_pos[0] <> 0 And $hide_state = 0 Then
        WinMove($hwnd2, "", 3, $a_pos[1])
        WinMove($hwnd, "", -588, $a_pos[1])
    EndIf
    If $a_pos2[0] <> - 588 And $hide_state = 1 Then
        WinMove($hwnd, "", -588, $a_pos2[1])
        WinMove($hwnd2, "", 3, $a_pos2[1])
    EndIf
    If $pass = 1 Then WinSetTitle($hwnd2, "", "Config Mode - Please Press the Button to Configure...  Press  ""<""  to Cancel")
    If $hide_state = 0 Then
        $a_mpos = GUIGetCursorInfo($hwnd2)
        If IsArray($a_mpos) = 1 Then
            For $b = 1 To 14
                If $a_mpos[4] = $Button_[$b] And $b>=1 And $b<=7 Then
                    If $b = 1 Then $left = 15
                    If $b > 1 Then $left = (($b - 1) * 80) + 15
                    GUICtrlSetPos($Button_[$b], $left, 30, 83, 46)
                    GUICtrlSetColor($Label_[$b], 0xff0000)
                    GUICtrlSetCursor($Button_[$b], 0)
                    While $a_mpos[4] = $Button_[$b]
                        $msg = GUIGetMsg()
                        If $msg = $Button_[$b] Then
                            If $pass = 0 Then
                                Function($b)
                                ExitLoop
                            Else
                                Set_ini($b)
                                ExitLoop
                            EndIf
                        EndIf
                        $a_mpos = GUIGetCursorInfo($hwnd2)
                        If IsArray($a_mpos) <> 1 Then ExitLoop
                    WEnd
                    $left = $left + 5
                    GUICtrlSetPos($Button_[$b], $left, 35, 73, 41)
                    GUICtrlSetColor($Label_[$b], 0x000000)
                EndIf
				If $a_mpos[4] = $Button_[$b] And $b>=8 and $b<=14 Then
                    If $b = 7 Then $left = 15
                    If $b > 7 Then $left = (($b - 8) * 80) + 15
                    GUICtrlSetPos($Button_[$b], $left, 120, 83, 46)
                    GUICtrlSetColor($Label_[$b], 0xff0000)
                    GUICtrlSetCursor($Button_[$b], 0)
                    While $a_mpos[4] = $Button_[$b]
                        $msg = GUIGetMsg()
                        If $msg = $Button_[$b] Then
                            If $pass = 0 Then
                                Function($b)
                                ExitLoop
                            Else
                                Set_ini($b)
                                ExitLoop
                            EndIf
                        EndIf
                        $a_mpos = GUIGetCursorInfo($hwnd2)
                        If IsArray($a_mpos) <> 1 Then ExitLoop
                    WEnd
                    $left = $left + 5
                    GUICtrlSetPos($Button_[$b], $left, 120, 73, 41)
                    GUICtrlSetColor($Label_[$b], 0x000000)
                EndIf
            Next
        EndIf
    EndIf
WEnd

Func Slide_in()
    $hide_state = 0
    GUISetState(@SW_HIDE, $hwnd)
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00040001);slide in from left
    WinActivate($hwnd2)
    WinWaitActive($hwnd2)
EndFunc  ;==>Slide_in

Func Slide_out()
    $hide_state = 1
    DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $hwnd2, "int", 100, "long", 0x00050002);slide out to left
    GUISetState(@SW_SHOW, $hwnd)
    WinActivate($hwnd)
    WinWaitActive($hwnd)
EndFunc  ;==>Slide_out

Func Create_ini()
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 1, @ProgramFilesDir & "\Internet Explorer\iexplore.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 2, @SystemDir & "\osk.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 3, @ProgramFilesDir & "\Windows Media Player\wmplayer.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 4, @SystemDir & "\notepad.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 5, @SystemDir & "\calc.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 6, @SystemDir & "\mstsc.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 7, @SystemDir & "\cleanmgr.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 1, "IE Explorer")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 2, "Keyboard")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 3, "Media Player")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 4, "Notepad")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 5, "Calculator")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 6, "Net Service")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 7, "Clean Mngr")
	IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 1, @ProgramFilesDir & "\Internet Explorer\iexplore.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 2, @SystemDir & "\osk.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 3, @ProgramFilesDir & "\Windows Media Player\wmplayer.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 4, @SystemDir & "\notepad.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 5, @SystemDir & "\calc.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 6, @SystemDir & "\mstsc.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", 7, @SystemDir & "\cleanmgr.exe")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 1, "IE Explorer")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 2, "Keyboard")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 3, "Media Player")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 4, "Notepad")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 5, "Calculator")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 6, "Net Service")
    IniWrite(@ScriptDir & "\toolbar.ini", "Label", 7, "Clean Mngr")
EndFunc  ;==>Create_ini

Func Set_ini(ByRef $b)
    Slide_out()
    ;GUICtrlSetState($author, $GUI_HIDE)
    GUICtrlSetState($Show, $GUI_HIDE)
    For $x = 1 To 7
        GUICtrlSetState($config_[$x], $GUI_SHOW)
    Next
    Sleep(50)
    ;WinSetTrans($hwnd, "", 0)
    WinMove($hwnd, "", 3, $a_pos[1])
    GUICtrlSetData($config_[2], $Label_name[$b][1])
    GUICtrlSetData($config_[4], $Launch_name[$b][1])
    GUICtrlSetState($config_[4], $GUI_DROPACCEPTED )
    ;For $x = 1 To 255 Step 3
       ; WinSetTrans($hwnd, "", $x)
        ;Sleep(1)
    ;Next
    While 3
        $a_pos = WinGetPos($hwnd)
        WinMove($hwnd, "", 3, $a_pos[1])
        WinMove($hwnd2, "", 3, $a_pos[1])
        $msg3 = GUIGetMsg()
        
        If $msg3 = $GUI_EVENT_CLOSE Then Exit
        If $msg3 = $config_[5] Then ExitLoop
        If $msg3 = $config_[6] Then
            $Find = FileOpenDialog("Please Select a Program to Launch", @ProgramFilesDir, "exe (*.exe)", 1 + 2)
            If Not @error = 1 Then GUICtrlSetData($config_[4], $Find)
        EndIf
        If $msg3 = $config_[7] Then
            $temp_info = GUICtrlRead($config_[4])
            If FileExists($temp_info) Then
                If StringInStr($temp_info, ".lnk") Then
                    $details = FileGetShortcut($temp_info)
                    $temp_info = $details[0]
                EndIf
                If StringInStr($temp_info, ".exe") Then
                    IniWrite(@ScriptDir & "\toolbar.ini", "Launch", $b, $temp_info)
                    IniWrite(@ScriptDir & "\toolbar.ini", "Label", $b, (GUICtrlRead($config_[2])))
                    $Label_name = IniReadSection(@ScriptDir & "\toolbar.ini", "Label")
                    $Launch_name = IniReadSection(@ScriptDir & "\toolbar.ini", "Launch")
                    For $x = 1 To 14
                        GUICtrlSetData($Label_[$x], $Label_name[$x][1])
                        GUICtrlSetImage($Button_[$x], $Launch_name[$x][1])
                    Next
                    ExitLoop
                Else
                    MsgBox(262208, "Sorry!", "The ""exe"" file could not be verified   ", 4)
                EndIf
            Else
                MsgBox(262208, "Sorry!", "The file location could not be verified   ", 4)
            EndIf
        EndIf
    WEnd
    For $x = 1 To 7
        GUICtrlSetState($config_[$x], $GUI_HIDE)
    Next
    ;GUICtrlSetState($author, $GUI_SHOW)
    ;Sleep(300)
    ;For $x = 255 To 1 Step - 3
        ;WinSetTrans($hwnd, "", $x)
        ;Sleep(1)
    ;Next
    
    WinMove($hwnd, "", -588, $a_pos[1])
    GUICtrlSetState($Show, $GUI_SHOW)
    ;WinSetTrans($hwnd, "", 255)
    Slide_in()
EndFunc  ;==>Set_ini

Func Function(ByRef $b)
    Slide_out()
    If FileExists($Launch_name[$b][1]) Then
        $LFile = FileGetShortName($Launch_name[$b][1])
        Run($LFile)
    Else
        MsgBox(262208, "Sorry!", "The file location could not be verified   ", 4)
    EndIf
EndFunc  ;==>Function

Func Set_Exit()
    Exit
EndFunc  ;==>Set_Exit

Func Set_Config()
    $a_pos = WinGetPos($hwnd)
    If $a_pos[0] = 3 Then Return
    Slide_in()
    $pass = 1
EndFunc  ;==>Set_Exit

