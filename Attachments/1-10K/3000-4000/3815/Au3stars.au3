#include <GUIConstants.au3>
Opt("ColorMode", 1)
$gSpeed      = IniRead("starfield.ini", "Main", "Speed", 50)
$gNumStars   = IniRead("starfield.ini", "Main", "NumStars", 32)
$gStarSize   = IniRead("starfield.ini", "Main", "StarSize", 2)
$gStarBias   = IniRead("starfield.ini", "Main", "StarBias", 4)
$gStarColor  = IniRead("starfield.ini", "Main", "StarColor", 0xFFFFFF)
$gFieldColor = IniRead("starfield.ini", "Main", "FieldColor", 0)
$gRandColor  = IniRead("starfield.ini", "Main", "RandomColor", 1)

If StringInStr($CmdLineRaw, "/S") Then
    SaverWindow(@DesktopWidth, @DesktopHeight, 0, 0)
ElseIf StringInStr($CmdLineRaw, "/P") Then
    Exit
Else
    ConfigWindow()
Endif

Func SaverWindow($nWidth, $nHeight, $nLeft, $nTop, $hParent = 0)
    MouseMove($nWidth + 1, $nHeight + 1, 0)
    $mPos = MouseGetPos() 
    $hGUI = GUICreate("", $nWidth, $nHeight, $nLeft, $nTop, $WS_POPUPWINDOW, $WS_EX_TOPMOST, $hParent)
    GUISetBkColor($gFieldColor)
    Local $stars[$gNumStars][4]
    For $i = 0 To $gNumStars - 1
        $stars[$i][0] = Int(Random($nLeft, $nWidth))
        $stars[$i][1] = Int(Random($nTop, $nHeight))
        $stars[$i][2] = Int(Random(1, $gStarBias))
        $stars[$i][3] = GUICtrlCreateLabel(" ", $stars[$i][0], $stars[$i][1], $gStarSize, $gStarSize) 
        If $gRandColor = 1 Then
            GUICtrlSetBkColor(-1, Int(Random(0, 0xFFFFFF)))
        Else
            GUICtrlSetBkColor(-1, $gStarColor)
        Endif
    Next

    GUISetState()
    
    While 1
        $msg = GuiGetMsg()
        $mcPos = MouseGetPos()
        If $mPos[0] <> $mcPos[0] or $mPos[1] <> $mcPos[1] or $msg = $GUI_EVENT_CLOSE Then
            GUIDelete($hGUI)
            Return
        EndIf
        For $i = 0 To $gNumStars - 1
            $stars[$i][0] += $stars[$i][2]
            If $stars[$i][0] > $nWidth Then $stars[$i][0] -= $nWidth
            GUICtrlSetPos($stars[$i][3], $stars[$i][0], $stars[$i][1])
        Next
        Sleep(50 - $gSpeed)
    WEnd
EndFunc

Func ConfigWindow()
    $hConfigGUI = GuiCreate("Stars Saver Config", 358, 148, 302,218 ,BitOR($WS_OVERLAPPEDWINDOW, $WS_CLIPSIBLINGS))
    $hOk      = GuiCtrlCreateButton("OK", 274, 84, 80, 24)
    $hPreview = GuiCtrlCreateButton("Preview", 140, 118, 80, 25)
    $hCancel  = GuiCtrlCreateButton("Cancel", 274, 118, 80, 25)
    GuiCtrlCreateGroup("Stars", 3, 0, 129, 145)
    GuiCtrlCreateGroup("Color", 136, 0, 220, 80)
    GuiCtrlCreateLabel("Star count", 8, 24, 49, 13)
    GuiCtrlCreateLabel("Speed", 8, 56, 31, 13)
    GuiCtrlCreateLabel("Bias", 8, 88, 20, 13)
    GuiCtrlCreateLabel("Star size", 8, 120, 40, 13)
    $SpinEditInput1=GuiCtrlCreateInput($gNumStars, 64, 16, 49, 22)
    $up = GUICtrlCreateUpdown(-1)
    GUICtrlSetLimit(-1, 256, 1)
    $SpinEditInput2=GuiCtrlCreateInput($gSpeed, 64, 48, 49, 22)
    GUICtrlCreateUpdown(-1)
    GUICtrlSetLimit(-1, 50, 1)
    $SpinEditInput3=GuiCtrlCreateInput($gStarBias, 64, 80, 49, 22)
    GUICtrlCreateUpdown(-1)
    GUICtrlSetLimit(-1, 32, 2)
    $SpinEditInput4=GuiCtrlCreateInput($gStarSize, 64, 112, 49, 22)
    GUICtrlCreateUpdown(-1)
    GUICtrlSetLimit(-1, 3, 1)
    GUICtrlCreateLabel("Stars color", 148, 20)
    $hStarsColorLbl = GUICtrlCreateLabel(" ", 208, 16, 40, 20)
    GUICtrlSetBkColor(-1, $gStarColor)
    $hStarsColorBtn = GUICtrlCreateButton("...", 254, 16, 30, 20)
    $hRndCheck = GUICtrlCreateCheckbox("Random", 290, 15)
    GUICtrlSetState(-1, $gRandColor)
    
    GUICtrlCreateLabel("Field color", 148, 50)
    $hFieldColorLbl = GUICtrlCreateLabel(" ", 208, 46, 40, 20)
    GUICtrlSetBkColor(-1, $gFieldColor)
    $hFieldColorBtn = GUICtrlCreateButton("...", 254, 46, 30, 20)

    If $gRandColor = 1 Then
        GUICtrlSetBkColor($hStarsColorLbl, 0xCCCCCC)
        GUICtrlSetState($hStarsColorBtn, $GUI_DISABLE)
    Endif

    GuiSetState()
    While 1
        $msg = GuiGetMsg()
        Select
            Case $msg = $hOk or $msg = $hPreview
                $gNumStars = GUICtrlRead($SpinEditInput1)
                $gSpeed    = GUICtrlRead($SpinEditInput2)
                $gStarBias = GUICtrlRead($SpinEditInput3)
                $gStarSize = GUICtrlRead($SpinEditInput4)
                If $msg = $hPreview Then
                    SaverWindow(640, 480, -1, -1, $hConfigGUI)
                Else
                    IniWrite("starfield.ini", "Main", "Speed", $gSpeed)
                    IniWrite("starfield.ini", "Main", "NumStars", $gNumStars)
                    IniWrite("starfield.ini", "Main", "StarSize", $gStarSize)
                    IniWrite("starfield.ini", "Main", "StarBias", $gStarBias)
                    IniWrite("starfield.ini", "Main", "StarColor", $gStarColor)
                    IniWrite("starfield.ini", "Main", "FieldColor", $gFieldColor)
                    IniWrite("starfield.ini", "Main", "RandomColor", $gRandColor)
                    Exit
                Endif
            Case $msg = $hStarsColorBtn
                 ChooseColor($hConfigGUI, $gStarColor)
                 GUICtrlSetBkColor($hStarsColorLbl, $gStarColor)
            Case $msg = $hFieldColorBtn
                 ChooseColor($hConfigGUI, $gFieldColor)
                 GUICtrlSetBkColor($hFieldColorLbl, $gFieldColor)
            Case $msg = $hRndCheck
                $gRandColor = GUICtrlRead($hRndCheck)
                If BitAnd($gRandColor, 1) Then
                    GUICtrlSetBkColor($hStarsColorLbl, 0xCCCCCC)
                    GUICtrlSetState($hStarsColorBtn, $GUI_DISABLE)
                Else
                    GUICtrlSetBkColor($hStarsColorLbl, $gStarColor)
                    GUICtrlSetState($hStarsColorBtn, $GUI_ENABLE)
                Endif
            Case $msg = $GUI_EVENT_CLOSE or $msg = $hCancel
                ExitLoop
        EndSelect
    WEnd
EndFunc

Func ChooseColor($hWnd, ByRef $nColor)
    $cp = DllStructCreate("dword[16]")
    $p = DllStructCreate("dword;dword;dword;dword;dword;dword;dword;dword;dword")
    DllStructSetData($p, 1, DllStructGetSize($p))
    DllStructSetData($p, 2, $hWnd)
    DllStructSetData($p, 4, $nColor)
    DllStructSetData($p, 5, DllStructGetPtr($cp))
    DllStructSetData($p, 6, 2 + 1)
    $ret = DllCall("comdlg32.dll", "long", "ChooseColorA", "ptr", DllStructGetPtr($p))
    If IsArray($ret) and $ret[0] <> 0 Then $nColor = DllStructGetData($p, 4)
    DllStructDelete($p)
    DllStructDelete($cp)
EndFunc