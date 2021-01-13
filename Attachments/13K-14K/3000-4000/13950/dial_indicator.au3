; Dial Indicator:an ugly hack of Analog Clock which was
; Created April 2006
; By greenmachine
; Credit - Larry (region funcs), neogia (anti-flicker, erasing old lines), Valuater (tray, transparency)
#region - Constants and funcs from includes
Global Const $GUI_EVENT_CLOSE        = -3
Global Const $GUI_CHECKED            = 1
Global Const $GUI_UNCHECKED            = 4
Global Const $GUI_ENABLE            = 64
Global Const $GUI_DISABLE            = 128
Global Const $GUI_FOCUS                = 256
Global Const $WS_POPUP                = 0x80000000
Global Const $WS_MINIMIZEBOX        = 0x00020000
Global Const $WS_CAPTION            = 0x00C00000
Global Const $WS_EX_TOPMOST            = 0x00000008
Global Const $SS_CENTER                = 1

Func _IsPressed($s_hexKey, $v_dll = 'user32.dll')
    Local $a_R = DllCall($v_dll, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
    If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
    Return 0
EndFunc  ;==>_IsPressed

Global Const $TRAY_CHECKED                = 1
Global Const $TRAY_UNCHECKED            = 4
Global Const $TRAY_ENABLE                = 64
Global Const $TRAY_DISABLE                = 128
#endregion

Opt ("GUIOnEventMode", 1)
Opt ("TrayMenuMode", 1)
Opt ("TrayOnEventMode", 1)







#comments-start
On Error Resume Next
strComputer = "."
Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set colItems = objWMIService.ExecQuery("Select * from Win32_PerfFormattedData_PerfOS_Memory",,48)
For Each objItem in colItems
    Wscript.Echo "AvailableBytes: " & objItem.AvailableBytes
Next

#comments-end
$wbemFlagReturnImmediately = 0x10
$wbemFlagForwardOnly = 0x20
$colItems = ""
$strComputer = "localhost"
$objWMIService = ObjGet("winmgmts:\\" & $strComputer & "\root\CIMV2")



Global $ver = "0.0.1"
Global $Labels[13], $redline, $DialActive = 1, $OnTop = 0, $WinTrans = 0, $WaitingForMin = 0
Global Const $PI = 3.1415926535897932384626433832795
Global $gdi_dll = DllOpen ("gdi32.dll"), $user32_dll = DllOpen ("user32.dll")
Global $LabW = 40, $LabH = 30, $Mid = 300, $Radius = $Mid, $redlineRad = 210, $BlacklineRad = 190, $boldBlacklineRad = 170, $OldFontSize
Global $BackgroundPens[3], $BlackPens[4]
Global $MousePos, $WinPos, $PosDiff[2]
Global $INI = @ScriptDir & "\DialIndicator.ini"

$colItems = $objWMIService.ExecQuery("SELECT AvailableBytes FROM Win32_PerfFormattedData_PerfOS_Memory", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
;$availmem = $objWMIService.ExecQuery("SELECT AvailableBytes FROM Win32_PerfFormattedData_PerfOS_Memory")
;$colItems = $objWMIService.ExecQuery("SELECT LoadPercentage FROM Win32_Processor", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
     If IsObj($colItems) Then
		 For $objItem In $colItems
 MsgBox(4096,"this",$objItem.AvailableBytes)

;$i = 0
 ;       For $objItem In $colItems
  ;          if $i = 0 Then
   ;             MsgBox(4096,"this",$objItem.AvailableBytes)
    ;            ;GUICtrlSetData ($label_core1,$objItem.LoadPercentage & "%")
     ;       ElseIf $i = 1 Then
      ;          MsgBox(4096,"this",$objItem.LoadPercentage)
                ;GUICtrlSetData ($label_core2,$objItem.LoadPercentage & "%")
       ;     ElseIf $i = 2 Then
         ;       MsgBox(4096,"this",$objItem.LoadPercentage)
        ;        ;GUICtrlSetData ($label_core3,$objItem.LoadPercentage & "%")
          ;  ElseIf $i = 3 Then
           ;     MsgBox(4096,"this",$objItem.LoadPercentage)
                ;GUICtrlSetData ($label_core4,$objItem.LoadPercentage & "%")
      ;      EndIf
       ;     $i += 1
        Next
	Else
        MsgBox(0, "WMI Output", "No WMI Objects Found for class: " & "Win32_Processor")
    EndIf

$GUI_Indicator = GUICreate ("Dial Indicator", $Mid*2, $Mid*2, @DesktopWidth/2 - $Mid, @DesktopHeight/2 - $Mid, BitOR ($WS_POPUP, $WS_MINIMIZEBOX))
GUISetBkColor (0xFFFFFF)
GUISetFont ($Mid/15, 800)

$ContextMenu = GUICtrlCreateContextMenu ()
$MenuItemMoveIndicator = GUICtrlCreateMenuitem ("Move Indicator", $ContextMenu, 0)
GUICtrlSetOnEvent ($MenuItemMoveIndicator, "MoveTheIndicator")

$MenuItemResizeIndicator = GUICtrlCreateMenuitem ("Resize Indicator", $ContextMenu, 1)
GUICtrlSetOnEvent ($MenuItemResizeIndicator, "ResizeTheIndicator")

$MenuItemOnTop = GUICtrlCreateMenuitem ("Always On Top", $ContextMenu, 2)
GUICtrlSetOnEvent ($MenuItemOnTop, "ToggleOnTop")

GUICtrlCreateMenuitem ("", $ContextMenu, 3)

$MenuItemTransparency = GUICtrlCreateMenuitem ("Set Dial Indicator Transparency", $ContextMenu, 6)
GUICtrlSetOnEvent ($MenuItemTransparency, "Set_Trans")

GUICtrlCreateMenuitem ("", $ContextMenu, 5)

$MenuItemAbout = GUICtrlCreateMenuitem ("About Dial Indicator", $ContextMenu, 8)
GUICtrlSetOnEvent ($MenuItemAbout, "Set_About")

GUICtrlCreateMenuitem ("", $ContextMenu, 7)

$MenuItemExit = GUICtrlCreateMenuitem ("Exit Dial Indicator", $ContextMenu, 10)
GUICtrlSetOnEvent ($MenuItemExit, "quitme")

$Labels[6] = GUICtrlCreateLabel (50, $Mid - 15, $Mid - Sin ($PI/2)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[1] = GUICtrlCreateLabel (60, $Mid - 21 + Cos ($PI/3)*($Radius - 10), $Mid - Sin ($PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[2] = GUICtrlCreateLabel (70, $Mid - 28 + Cos ($PI/6)*($Radius - 10), $Mid - 2 - Sin ($PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[3] = GUICtrlCreateLabel (80, $Mid - 30 + Cos (0)*($Radius - 10), $Mid - 13, $LabW, $LabH, $SS_CENTER)
$Labels[4] = GUICtrlCreateLabel (90, $Mid - 25 + Cos (-$PI/6)*($Radius - 10), $Mid - 20 - Sin (-$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[5] = GUICtrlCreateLabel (100, $Mid - 20 + Cos (-$PI/3)*($Radius - 10), $Mid - 28 - Sin (-$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[6] = GUICtrlCreateLabel (50, $Mid - 15, $Mid - Sin ($PI/2)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[7] = GUICtrlCreateLabel (0, $Mid - 8 + Cos (-2*$PI/3)*($Radius - 10), $Mid - 27 - Sin (-2*$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[8] = GUICtrlCreateLabel (10, $Mid - 2 + Cos (-5*$PI/6)*($Radius - 10), $Mid - 22 - Sin (-5*$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[9] = GUICtrlCreateLabel (20, $Mid + Cos ($PI)*($Radius - 10), $Mid - 13, $LabW, $LabH, $SS_CENTER)
$Labels[10] = GUICtrlCreateLabel (30, $Mid - 2 + Cos (5*$PI/6)*($Radius - 10), $Mid - 13 - Sin (5*$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[11] = GUICtrlCreateLabel (40, $Mid - 10 + Cos (2*$PI/3)*($Radius - 10), $Mid - Sin (2*$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
For $i = 1 To 11
    GUICtrlSetColor ($Labels[$i], 0xFF0000)
Next

$a = CreateRoundRectRgn(0,0,600,600,600,600)

SetWindowRgn($GUI_Indicator, $a)

$TrayItemMove = TrayCreateItem ("Move Indicator", -1, 0)
TrayItemSetOnEvent ($TrayItemMove, "MoveTheIndicator")

$TrayItemResize = TrayCreateItem ("Resize Indicator", -1, 1)
TrayItemSetOnEvent ($TrayItemResize, "ResizeTheIndicator")

$TrayItemOnTop = TrayCreateItem ("Always On Top", -1, 2)
TrayItemSetOnEvent ($TrayItemOnTop, "ToggleOnTop")

TrayCreateItem ("", -1, 3)

$TrayItemTransparency = TrayCreateItem ("Set Dial Indicator Transparency", -1, 6)
TrayItemSetOnEvent ($TrayItemTransparency, "Set_Trans")

TrayCreateItem ("", -1, 5)

$TrayItemAbout = TrayCreateItem ("About Dial Indicator", -1, 8)
TrayItemSetOnEvent ($TrayItemAbout, "Set_About")

TrayCreateItem ("", -1, 7)

$TrayItemExit = TrayCreateItem ("Exit Dial Indicator", -1, 10)
TrayItemSetOnEvent ($TrayItemExit, "quitme")

$curSecX = $Mid + Cos (TimeToRad("sec", $objItem.AvailableBytes))*$redlineRad
$curSecY = $Mid - Sin (TimeToRad("sec", $objItem.AvailableBytes))*$redlineRad

GUISetState ()
AllThatGoodStuff(1)

While 1
    CheckIndicatorStatus()
    Sleep (10)
WEnd

Func AllThatGoodStuff($FirstRun = 0)
    $GUIHDC = DllCall ($user32_dll,"int","GetDC","hwnd", $GUI_Indicator)
    If $FirstRun = 1 Then
        $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00FFFFFF"); small background pen
        $BackgroundPens[0] = $BkgrndPen[0]
        $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00FFFFFF"); medium background pen
        $BackgroundPens[1] = $BkgrndPen[0]
        $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00FFFFFF"); large background pen
        $BackgroundPens[2] = $BkgrndPen[0]
        $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x000000FF"); small red pen (second hand)
        $BlackPens[0] = $BlackPen[0]
;these       
;	   $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00000000"); medium black pen
 ;       $BlackPens[1] = $BlackPen[0]
  ;      $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00000000"); large black pen
   ;     $BlackPens[2] = $BlackPen[0]
    ;    $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00000000"); small black pen
     ;   $BlackPens[3] = $BlackPen[0]
    EndIf
   ; erase old hands
 
    DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BackgroundPens[0])
    DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
    DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $curSecX, "int", $curSecY)
   ; draw new hands
   
    DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[0])
    DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
    DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos (TimeToRad("sec", ($objItem.AvailableBytes/10000000/2)))*$redlineRad, "int", $Mid - Sin (TimeToRad("sec", ($objItem.AvailableBytes/10000000/2)))*$redlineRad)
   
	If $FirstRun Then
        DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[3])
        $Tempcounter = 0
        For $i = 0 To 2*$PI Step $PI/30
            If Mod ($Tempcounter, 5) = 0 Then
                DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[2])
                DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*47/60), "int", $Mid - Sin ($i)*($Radius*47/60), "ptr", 0)
                DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*5/6), "int", $Mid - Sin ($i)*($Radius*5/6))
                DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[3])
            Else
                DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*4/5), "int", $Mid - Sin ($i)*($Radius*4/5), "ptr", 0)
                DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*5/6), "int", $Mid - Sin ($i)*($Radius*5/6))
            EndIf
            $Tempcounter += 1
        Next
    EndIf
    DllCall ($user32_dll,"int","ReleaseDC","int",$GUIHDC[0],"hwnd",$GUI_Indicator)
    $curSecX = $Mid + Cos (TimeToRad("sec", ($objItem.AvailableBytes/10000000/2)))*$redlineRad
    $curSecY = $Mid - Sin (TimeToRad("sec", ($objItem.AvailableBytes/10000000/2)))*$redlineRad
    $redline = @SEC
EndFunc

Func TimeToRad($TimeType, $TimeVal = @SEC)
    Local $Rads
    Switch $TimeType
        Case "sec"
           $Rads = $PI/2 - ($TimeVal * $PI/30)
    EndSwitch
    Return $Rads
EndFunc

Func SetWindowRgn($h_win, $rgn)
    DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $rgn, "int", 1)
EndFunc

Func CreateRoundRectRgn($l, $t, $w, $h, $e1, $e2)
    $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $l, "long", $t, "long", $l + $w, "long", $t + $h, "long", $e1, "long", $e2)
    Return $ret[0]
EndFunc

Func ResizeTheIndicator()
    Opt ("MouseCoordMode", 2)
    GUISetCursor (13, 1, $GUI_Indicator)
    ToolTip ("Click and drag to resize the Indicator.  Release to set size.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Dial Indicator")
        $PosDiff[0] = $WinPos[2] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed ("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Dial Indicator", "", $WinPos[0], $WinPos[1], $MousePos[0] + $PosDiff[0], _
                $MousePos[0] + $PosDiff[0])
                $WinPos = WinGetPos ("Dial Indicator")
                $a = CreateRoundRectRgn (0, 0, $WinPos[2], $WinPos[3], $WinPos[2], $WinPos[3])
                SetWindowRgn($GUI_Indicator, $a)
                $Mid = $WinPos[2]/2
                $Radius = $Mid
                $redlineRad = $Mid * (21/30)
                $BlacklineRad = $Mid * (19/30)
                $boldBlacklineRad = $Mid * (17/30)
                If $OldFontSize <> Int ($Mid/15) Then
                    For $i = 1 To 12
                        GUICtrlSetFont ($Labels[$i], Int ($Mid/15), 800)
                    Next
                    $OldFontSize = Int ($Mid/15)
                EndIf
                CheckIndicatorStatus(2)
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckIndicatorStatus()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
    Opt ("MouseCoordMode", 1)
EndFunc

Func MoveTheIndicator()
    GUISetCursor (9, 1, $GUI_Indicator)
    ToolTip ("Click and drag to move the Indicator.  Release to set position.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Dial Indicator")
        $PosDiff[0] = $WinPos[0] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed ("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Dial Indicator", "", $MousePos[0] + $PosDiff[0], $MousePos[1] + $PosDiff[1])
                $WinPos = WinGetPos ("Dial Indicator")
                If ($WinPos[0] < -10) Or ($WinPos[1] < -10) Or ($WinPos[0] + $WinPos[2] > @DesktopWidth + 10) Or _
                    ($WinPos[1] + $WinPos[3] > @DesktopHeight + 10) Then
                    CheckIndicatorStatus(2)
                Else
                    CheckIndicatorStatus()
                EndIf
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckIndicatorStatus()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
EndFunc

Func ToggleOnTop()
    $OnTop = Not $OnTop
    WinSetOnTop ("Dial Indicator", "", $OnTop)
    If $OnTop Then
        GUICtrlSetState ($MenuItemOnTop, $GUI_CHECKED)
        TrayItemSetState ($TrayItemOnTop, $TRAY_CHECKED)
    Else
        GUICtrlSetState ($MenuItemOnTop, $GUI_UNCHECKED)
        TrayItemSetState ($TrayItemOnTop, $TRAY_UNCHECKED)
    EndIf
EndFunc

Func CheckIndicatorStatus($special = 0)
    If Not WinActive ("Dial Indicator") Then $DialActive = 0
    If WinActive ("Dial Indicator") And $DialActive = 0 Then
        AllThatGoodStuff(2)
        $DialActive = 1
    EndIf
    If $redline <> @SEC Then
        AllThatGoodStuff($special)
    EndIf
EndFunc

Func Set_About()
    Opt ("GUIOnEventMode", 0)
    $GUI_About = GUICreate ("About", 200, 100, Default, Default, $WS_CAPTION, $WS_EX_TOPMOST)
    GUICtrlCreateLabel ("Dial Indicator, Version " & $ver, 60, 10)
    GUICtrlCreateIcon ("shell32.dll", 221, 10, 10)
    $GUI_About_OK = GUICtrlCreateButton ("OK", 63, 67, 75, 23)
    GUICtrlSetState ($GUI_About_OK, $GUI_FOCUS)
    GUISetState ()
    While 1
        $msg = GUIGetMsg ()
        Switch $msg
            Case $GUI_EVENT_CLOSE, $GUI_About_OK
                GUIDelete ($GUI_About)
                ExitLoop
        EndSwitch
        CheckIndicatorStatus(2)
    WEnd
    Opt ("GUIOnEventMode", 1)
EndFunc

Func Set_Trans()
    Opt ("GUIOnEventMode", 0)
    $GUI_Trans = GUICreate ("Set Dial Indicator Transparency", 300, 100)
    $GUI_Trans_Slider = GUICtrlCreateSlider (10, 10, 290, 35)
    GUICtrlSetLimit ($GUI_Trans_Slider, 100, 0)
    GUICtrlSetData ($GUI_Trans_Slider, $WinTrans)
    $GUI_Trans_OK = GUICtrlCreateButton ("OK", 100, 60, 100, 25)
    GUISetState ()
    While 1
        $msg = GUIGetMsg ()
        Switch $msg
            Case $GUI_EVENT_CLOSE, $GUI_Trans_OK
                $WinTrans = GUICtrlRead ($GUI_Trans_Slider)
                GUIDelete ($GUI_Trans)
                ExitLoop
        EndSwitch
        WinSetTrans ($GUI_Indicator, "", (100 - GUICtrlRead ($GUI_Trans_Slider))*2.5)
        CheckIndicatorStatus(2)
    WEnd
    Opt ("GUIOnEventMode", 1)
EndFunc

Func _DateToDayOfWeekSpecial($iYear, $iMonth, $iDay)
    Local $i_aFactor, $i_yFactor, $i_mFactor, $i_dFactor
    $i_aFactor = Int((14 - $iMonth) / 12)
    $i_yFactor = $iYear - $i_aFactor
    $i_mFactor = $iMonth + (12 * $i_aFactor) - 2
    $i_dFactor = Mod($iDay + $i_yFactor + Int($i_yFactor / 4) - Int($i_yFactor / 100) + Int($i_yFactor / 400) + Int((31 * $i_mFactor) / 12), 7)
    If $i_dFactor >= 1 Then Return $i_dFactor - 1
    Return 6
EndFunc; _DateToDayOfWeekISO all-in-one

Func quitme()
    Exit
EndFunc

Func OnAutoItExit()
    DllClose ($gdi_dll)
    DllClose ($user32_dll)
EndFunc