; Analog Clock
; Created April 2006
; By greenmachine
; Credit - Larry (region funcs), neogia (anti-flicker, erasing old lines), Valuater (tray, transparency)

#include <Array.au3>
#include "Coroutine.au3"
Opt("TrayIconDebug", 1)
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

Global $ver = "1.0.4"
Global $Labels[13], $Sec, $ClockActive = 1, $OnTop = 0, $WinTrans = 0, $WaitingForMin = 0
Global Const $PI = 3.1415926535897932384626433832795
Global $gdi_dll = DllOpen ("gdi32.dll"), $user32_dll = DllOpen ("user32.dll")
Global $LabW = 30, $LabH = 30, $Mid = 300, $Radius = $Mid, $SecRad = 210, $MinRad = 190, $HourRad = 170, $OldFontSize
Global $BackgroundPens[3], $BlackPens[4]
Global $MousePos, $WinPos, $PosDiff[2]
Global $AlarmTime[7] = ["Daily", "12", "00", "PM"]; when (daily, weekdays, weekends, one date), hour, min, part of day (AM or PM), mon, day, year
Global $AlarmStatus[3] = ["Off", "On", 0]; off, on, and currently selected
Global $AlarmSave[3] = ["No", "Yes", 0]
Global $INI = @ScriptDir & "\AnalogClock.ini"
Global $lineArr[66][5]

If FileExists ($INI) Then
    $AlarmSave[2] = 1
    $AlarmTime[0] = IniRead ($INI, "Alarm", "Dates", "Daily")
    If $AlarmTime[0] <> "Daily" And $AlarmTime[0] <> "Weekdays" And _ 
        $AlarmTime[0] <> "Weekends" And $AlarmTime[0] <> "One Date" Then $AlarmTime[0] = "Daily"
    $AlarmTime[1] = IniRead ($INI, "Alarm", "Hour", "12")
    If $AlarmTime[1] < 1 Or $AlarmTime[1] > 12 Then $AlarmTime[1] = "12"
    $AlarmTime[2] = IniRead ($INI, "Alarm", "Min", "00")
    If $AlarmTime[2] < 0 Or $AlarmTime[2] > 59 Then $AlarmTime[2] = "00"
    $AlarmTime[3] = IniRead ($INI, "Alarm", "AMPM", "PM")
    If StringUpper ($AlarmTime[3]) <> "AM" And StringUpper ($AlarmTime[3]) <> "PM" Then $AlarmTime[3] = "PM"
    If $AlarmTime[0] = "One Date" Then
        $AlarmTime[4] = IniRead ($INI, "Alarm", "Month", "")
        If Number ($AlarmTime[4]) < 1 Or Number ($AlarmTime[4]) > 12 Then $AlarmTime[4] = ""
        $AlarmTime[5] = IniRead ($INI, "Alarm", "Day", "")
        If Number ($AlarmTime[5]) < 1 Or Number ($AlarmTime[5]) > 31 Then $AlarmTime[5] = ""
        $AlarmTime[6] = IniRead ($INI, "Alarm", "Year", "")
        If Number ($AlarmTime[6]) < Number (@YEAR) Then $AlarmTime[6] = ""
    EndIf
EndIf    

$GUI_Clock = GUICreate ("Analog Clock", $Mid*2, $Mid*2, @DesktopWidth/2 - $Mid, @DesktopHeight/2 - $Mid, BitOR ($WS_POPUP, $WS_MINIMIZEBOX))
GUISetBkColor (0xFFFFFF)
GUISetFont ($Mid/15, 800)

$ContextMenu = GUICtrlCreateContextMenu ()
$MenuItemMoveClock = GUICtrlCreateMenuitem ("Move Clock", $ContextMenu, 0)
GUICtrlSetOnEvent ($MenuItemMoveClock, "MoveTheClock")

$MenuItemResizeClock = GUICtrlCreateMenuitem ("Resize Clock", $ContextMenu, 1)
GUICtrlSetOnEvent ($MenuItemResizeClock, "ResizeTheClock")

$MenuItemOnTop = GUICtrlCreateMenuitem ("Always On Top", $ContextMenu, 2)
GUICtrlSetOnEvent ($MenuItemOnTop, "ToggleOnTop")

GUICtrlCreateMenuitem ("", $ContextMenu, 3)

$MenuAlarm = GUICtrlCreateMenu ("Alarm", $ContextMenu, 4)
$MenuItemAlarmTime = GUICtrlCreateMenuitem ("Alarm Time", $MenuAlarm, 0)
If $AlarmTime[0] = "One Date" Then
    GUICtrlSetData ($MenuItemAlarmTime, $AlarmTime[1] & ":" & $AlarmTime[2] & " " & _ 
    $AlarmTime[3] & " on " & $AlarmTime[4] & "/" & $AlarmTime[5] & "/" & $AlarmTime[6])
Else
    GUICtrlSetData ($MenuItemAlarmTime, $AlarmTime[0] & " at " & $AlarmTime[1] & ":" & $AlarmTime[2] & " " & $AlarmTime[3])
EndIf
GUICtrlSetState ($MenuItemAlarmTime, $GUI_DISABLE)
$MenuItemAlarmStatus = GUICtrlCreateMenuitem ("Alarm is: " & $AlarmStatus[$AlarmStatus[2]], $MenuAlarm, 1)
GUICtrlSetOnEvent ($MenuItemAlarmStatus, "ToggleAlarm")
$MenuItemSaveAlarm = GUICtrlCreateMenuitem ("Save Alarm: " & $AlarmSave[$AlarmSave[2]], $MenuAlarm, 2)
GUICtrlSetOnEvent ($MenuItemSaveAlarm, "ToggleSave")
GUICtrlCreateMenuitem ("", $MenuAlarm, 3)
$MenuItemSetAlarm = GUICtrlCreateMenuitem ("Set Alarm", $MenuAlarm, 4)
GUICtrlSetOnEvent ($MenuItemSetAlarm, "SetAlarm")

GUICtrlCreateMenuitem ("", $ContextMenu, 5)

$MenuItemTransparency = GUICtrlCreateMenuitem ("Set Analog Clock Transparency", $ContextMenu, 6)
GUICtrlSetOnEvent ($MenuItemTransparency, "Set_Trans")

GUICtrlCreateMenuitem ("", $ContextMenu, 7)

$MenuItemAbout = GUICtrlCreateMenuitem ("About Analog Clock", $ContextMenu, 8)
GUICtrlSetOnEvent ($MenuItemAbout, "Set_About")

GUICtrlCreateMenuitem ("", $ContextMenu, 9)

$MenuItemExit = GUICtrlCreateMenuitem ("Exit Analog Clock", $ContextMenu, 10)
GUICtrlSetOnEvent ($MenuItemExit, "quitme")

$Labels[12] = GUICtrlCreateLabel (12, $Mid - 15, $Mid - Sin ($PI/2)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[1] = GUICtrlCreateLabel (1, $Mid - 21 + Cos ($PI/3)*($Radius - 10), $Mid - Sin ($PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[2] = GUICtrlCreateLabel (2, $Mid - 28 + Cos ($PI/6)*($Radius - 10), $Mid - 2 - Sin ($PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[3] = GUICtrlCreateLabel (3, $Mid - 30 + Cos (0)*($Radius - 10), $Mid - 13, $LabW, $LabH, $SS_CENTER)
$Labels[4] = GUICtrlCreateLabel (4, $Mid - 25 + Cos (-$PI/6)*($Radius - 10), $Mid - 20 - Sin (-$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[5] = GUICtrlCreateLabel (5, $Mid - 20 + Cos (-$PI/3)*($Radius - 10), $Mid - 28 - Sin (-$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[6] = GUICtrlCreateLabel (6, $Mid - 15, $Mid - 30 - Sin (3*$PI/2)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[7] = GUICtrlCreateLabel (7, $Mid - 8 + Cos (-2*$PI/3)*($Radius - 10), $Mid - 27 - Sin (-2*$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[8] = GUICtrlCreateLabel (8, $Mid - 2 + Cos (-5*$PI/6)*($Radius - 10), $Mid - 22 - Sin (-5*$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[9] = GUICtrlCreateLabel (9, $Mid + Cos ($PI)*($Radius - 10), $Mid - 13, $LabW, $LabH, $SS_CENTER)
$Labels[10] = GUICtrlCreateLabel (10, $Mid - 2 + Cos (5*$PI/6)*($Radius - 10), $Mid - 13 - Sin (5*$PI/6)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
$Labels[11] = GUICtrlCreateLabel (11, $Mid - 10 + Cos (2*$PI/3)*($Radius - 10), $Mid - Sin (2*$PI/3)*($Radius - 10), $LabW, $LabH, $SS_CENTER)
For $i = 1 To 12
    GUICtrlSetColor ($Labels[$i], 0xFF0000)
Next

$a = CreateRoundRectRgn(0,0,600,600,600,600)

SetWindowRgn($GUI_Clock, $a)

$TrayItemMove = TrayCreateItem ("Move Clock", -1, 0)
TrayItemSetOnEvent ($TrayItemMove, "MoveTheClock")

$TrayItemResize = TrayCreateItem ("Resize Clock", -1, 1)
TrayItemSetOnEvent ($TrayItemResize, "ResizeTheClock")

$TrayItemOnTop = TrayCreateItem ("Always On Top", -1, 2)
TrayItemSetOnEvent ($TrayItemOnTop, "ToggleOnTop")

TrayCreateItem ("", -1, 3)

$TrayMenuAlarm = TrayCreateMenu ("Alarm", -1, 4)
$TrayItemAlarmTime = TrayCreateItem ("Alarm Time", $TrayMenuAlarm, 0)
TrayItemSetState ($TrayItemAlarmTime, $TRAY_DISABLE)
If $AlarmTime[0] = "One Date" Then
    TrayItemSetText ($TrayItemAlarmTime, $AlarmTime[1] & ":" & $AlarmTime[2] & " " & _ 
    $AlarmTime[3] & " on " & $AlarmTime[4] & "/" & $AlarmTime[5] & "/" & $AlarmTime[6])
Else
    TrayItemSetText ($TrayItemAlarmTime, $AlarmTime[0] & " at " & $AlarmTime[1] & ":" & $AlarmTime[2] & " " & $AlarmTime[3])
EndIf
$TrayItemAlarmStatus = TrayCreateItem ("Alarm is: " & $AlarmStatus[$AlarmStatus[2]], $TrayMenuAlarm, 1)
TrayItemSetOnEvent ($TrayItemAlarmStatus, "ToggleAlarm")
$TrayItemSaveAlarm = TrayCreateItem ("Save Alarm: " & $AlarmSave[$AlarmSave[2]], $TrayMenuAlarm, 2)
TrayItemSetOnEvent ($TrayItemSaveAlarm, "ToggleSave")
TrayCreateItem ("", $TrayMenuAlarm, 3)
$TrayItemSetAlarm = TrayCreateItem ("Set Alarm", $TrayMenuAlarm, 4)
TrayItemSetOnEvent ($TrayItemSetAlarm, "SetAlarm")

TrayCreateItem ("", -1, 5)

$TrayItemTransparency = TrayCreateItem ("Set Analog Clock Transparency", -1, 6)
TrayItemSetOnEvent ($TrayItemTransparency, "Set_Trans")

TrayCreateItem ("", -1, 7)

$TrayItemAbout = TrayCreateItem ("About Analog Clock", -1, 8)
TrayItemSetOnEvent ($TrayItemAbout, "Set_About")

TrayCreateItem ("", -1, 9)

$TrayItemExit = TrayCreateItem ("Exit Analog Clock", -1, 10)
TrayItemSetOnEvent ($TrayItemExit, "quitme")

$curSecX = $Mid + Cos (TimeToRad("sec", @SEC))*$SecRad
$curSecY = $Mid - Sin (TimeToRad("sec", @SEC))*$SecRad
$curMinX = $Mid + Cos (TimeToRad("min", @MIN))*$MinRad
$curMinY = $Mid - Sin (TimeToRad("min", @MIN))*$MinRad
$curHourX = $Mid + Cos (TimeToRad("hour", @HOUR))*$HourRad
$curHourY = $Mid - Sin (TimeToRad("hour", @HOUR))*$HourRad
GUISetState ()
$Drawer = _CoCreate('Func Drawer($GUI)|#NoTrayIcon|$user32_dll = DllOpen("user32.dll")|    $gdi_dll = DllOpen("gdi32.dll")|    $GUIHDC = DllCall ($user32_dll,"int","GetDC","hwnd", $GUI)|	$GUIHDC = $GUIHDC[0]|    Dim $Pens[7]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00FFFFFF"); small background pen|    $Pens[0] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00FFFFFF"); medium background pen|    $Pens[1] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00FFFFFF"); large background pen|    $Pens[2] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x000000FF"); small red pen (second hand)|    $Pens[3] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00000000"); medium black pen|    $Pens[4] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00000000"); large black pen|    $Pens[5] = $Pen[0]|    $Pen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00000000"); small black pen|    $Pens[6] = $Pen[0]|    $lineArr = "start"|    While $lineArr <> "exit"|        If IsArray($lineArr) Then|            For $i = 0 To UBound($lineArr, 1) - 1|                DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC, "hwnd", $Pens[$lineArr[$i][0]])|                DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC, "int", $lineArr[$i][1], "int", $lineArr[$i][2], "ptr", 0)|                DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC, "int", $lineArr[$i][3], "int", $lineArr[$i][4])|            Next|            Sleep(50)|        EndIf|            $test = _CoYield(1);Peek to check for new/different lines|            If @extended == 1 Then|                $lineArr = $test|            EndIf|    WEnd|    DllCall ($user32_dll,"int","ReleaseDC","int",$GUIHDC,"hwnd",$GUI_Clock)|    DllClose($gdi_dll)|    DllClose($user32_dll)|EndFunc');<== End of _CoCreate() function for Drawer()
$DrawerPID = _CoStart($Drawer, '$GUI_Clock');$GUI is passed as a string on purpose
AllThatGoodStuff(1)

While 1
    CheckClockStuff()
    Sleep (10)
WEnd

Func AllThatGoodStuff($FirstRun = 0)
;~     $GUIHDC = DllCall ($user32_dll,"int","GetDC","hwnd", $GUI_Clock)
;~     If $FirstRun = 1 Then
;~         $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00FFFFFF"); small background pen
;~         $BackgroundPens[0] = $BkgrndPen[0]
;~         $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00FFFFFF"); medium background pen
;~         $BackgroundPens[1] = $BkgrndPen[0]
;~         $BkgrndPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00FFFFFF"); large background pen
;~         $BackgroundPens[2] = $BkgrndPen[0]
;~         $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x000000FF"); small red pen (second hand)
;~         $BlackPens[0] = $BlackPen[0]
;~         $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "2", "hwnd", "0x00000000"); medium black pen
;~         $BlackPens[1] = $BlackPen[0]
;~         $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "3", "hwnd", "0x00000000"); large black pen
;~         $BlackPens[2] = $BlackPen[0]
;~         $BlackPen = DllCall ($gdi_dll, "hwnd", "CreatePen", "int", "0", "int", "0", "hwnd", "0x00000000"); small black pen
;~         $BlackPens[3] = $BlackPen[0]
;~     EndIf
   ; erase old hands
    If $curHourX <> $Mid + Cos (TimeToRad("hour", @HOUR))*$HourRad Or $curHourY <> $Mid - Sin (TimeToRad("hour", @HOUR))*$HourRad Then
;~         DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BackgroundPens[2])
;~         DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~         DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $curHourX, "int", $curHourY)
		$lineArr[0][0] = 2
		$lineArr[0][1] = $Mid
		$lineArr[0][2] = $Mid
		$lineArr[0][3] = $curHourX
		$lineArr[0][4] = $curHourY
        $curHourX = $Mid + Cos (TimeToRad("hour", @HOUR))*$HourRad
        $curHourY = $Mid - Sin (TimeToRad("hour", @HOUR))*$HourRad
    EndIf
    If $curMinX <> $Mid + Cos (TimeToRad("min", @MIN))*$MinRad Or $curMinY <> $Mid - Sin (TimeToRad("min", @MIN))*$MinRad Then
;~         DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BackgroundPens[1])
;~         DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~         DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $curMinX, "int", $curMinY)
		$lineArr[1][0] = 1
		$lineArr[1][1] = $Mid
		$lineArr[1][2] = $Mid
		$lineArr[1][3] = $curMinX
		$lineArr[1][4] = $curMinY
        $curMinX = $Mid + Cos (TimeToRad("min", @MIN))*$MinRad
        $curMinY = $Mid - Sin (TimeToRad("min", @MIN))*$MinRad
    EndIf
;~     DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BackgroundPens[0])
;~     DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~     DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $curSecX, "int", $curSecY)
	$lineArr[2][0] = 0
	$lineArr[2][1] = $Mid
	$lineArr[2][2] = $Mid
	$lineArr[2][3] = $curSecX
	$lineArr[2][4] = $curSecY
   ; draw new hands
;~     DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[2])
;~     DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~     DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos (TimeToRad("hour", @HOUR))*$HourRad, "int", $Mid - Sin (TimeToRad("hour", @HOUR))*$HourRad)
	$lineArr[3][0] = 5
	$lineArr[3][1] = $Mid
	$lineArr[3][2] = $Mid
	$lineArr[3][3] = $Mid + Cos (TimeToRad("hour", @HOUR))*$HourRad
	$lineArr[3][4] = $Mid - Sin (TimeToRad("hour", @HOUR))*$HourRad
;~     DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[1])
;~     DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~     DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos (TimeToRad("min", @MIN))*$MinRad, "int", $Mid - Sin (TimeToRad("min", @MIN))*$MinRad)
	$lineArr[4][0] = 4
	$lineArr[4][1] = $Mid
	$lineArr[4][2] = $Mid
	$lineArr[4][3] = $Mid + Cos (TimeToRad("min", @MIN))*$MinRad
	$lineArr[4][4] = $Mid - Sin (TimeToRad("min", @MIN))*$MinRad
;~     DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[0])
;~     DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid, "int", $Mid, "ptr", 0)
;~     DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos (TimeToRad("sec", @SEC))*$SecRad, "int", $Mid - Sin (TimeToRad("sec", @SEC))*$SecRad)
	$lineArr[5][0] = 3
	$lineArr[5][1] = $Mid
	$lineArr[5][2] = $Mid
	$lineArr[5][3] = $Mid + Cos (TimeToRad("sec", @SEC))*$SecRad
	$lineArr[5][4] = $Mid - Sin (TimeToRad("sec", @SEC))*$SecRad
    If $FirstRun Then
;~         DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[3])
        $Tempcounter = 0
		$lineCounter = 0
        For $i = 0 To 2*$PI Step $PI/30
            If Mod ($Tempcounter, 5) = 0 Then
;~                 DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[2])
;~                 DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*47/60), "int", $Mid - Sin ($i)*($Radius*47/60), "ptr", 0)
;~                 DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*5/6), "int", $Mid - Sin ($i)*($Radius*5/6))
				$lineArr[$lineCounter+5][0] = 5
				$lineArr[$lineCounter+5][1] = $Mid + Cos ($i)*($Radius*47/60)
				$lineArr[$lineCounter+5][2] = $Mid - Sin ($i)*($Radius*47/60)
				$lineArr[$lineCounter+5][3] = $Mid + Cos ($i)*($Radius*5/6)
				$lineArr[$lineCounter+5][4] = $Mid - Sin ($i)*($Radius*5/6)
;~                 DllCall ($gdi_dll, "hwnd", "SelectObject", "hwnd", $GUIHDC[0], "hwnd", $BlackPens[3])
            Else
;~                 DllCall ($gdi_dll, "int", "MoveToEx", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*4/5), "int", $Mid - Sin ($i)*($Radius*4/5), "ptr", 0)
;~                 DllCall ($gdi_dll, "int", "LineTo", "hwnd", $GUIHDC[0], "int", $Mid + Cos ($i)*($Radius*5/6), "int", $Mid - Sin ($i)*($Radius*5/6))
				$lineArr[$lineCounter+5][0] = 6
				$lineArr[$lineCounter+5][1] = $Mid + Cos ($i)*($Radius*47/60)
				$lineArr[$lineCounter+5][2] = $Mid - Sin ($i)*($Radius*47/60)
				$lineArr[$lineCounter+5][3] = $Mid + Cos ($i)*($Radius*5/6)
				$lineArr[$lineCounter+5][4] = $Mid - Sin ($i)*($Radius*5/6)
            EndIf
			$lineCounter += 1
            $Tempcounter += 1
        Next
    EndIf
;~     DllCall ($user32_dll,"int","ReleaseDC","int",$GUIHDC[0],"hwnd",$GUI_Clock)
	_CoSend($DrawerPID, $lineArr)
    $curSecX = $Mid + Cos (TimeToRad("sec", @SEC))*$SecRad
    $curSecY = $Mid - Sin (TimeToRad("sec", @SEC))*$SecRad
    $Sec = @SEC
EndFunc

Func TimeToRad($TimeType, $TimeVal = @SEC)
    Local $Rads
    Switch $TimeType
        Case "sec"
         ; 0 secs = pi/2, 7-8 secs = pi/4, 15 secs = 0, 22-23 secs = -pi/4 = 7pi/4, 30 secs = 3pi/2, 37-38 secs = 5pi/4, 45 secs = pi
         ; 5 secs = pi/3, 10 secs = pi/6, 20 secs = -pi/6, 25 secs = -pi/3
            $Rads = $PI/2 - ($TimeVal * $PI/30)
        Case "min"
            $Rads = $PI/2 - ($TimeVal * $PI/30) - Int (@SEC / 10)*$PI/180
        Case "hour"
            $Rads = $PI/2 - ($TimeVal * $PI/6) - (@MIN / 12)*$PI/30
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

Func ResizeTheClock()
    Opt ("MouseCoordMode", 2)
    GUISetCursor (13, 1, $GUI_Clock)
    ToolTip ("Click and drag to resize the clock.  Release to set size.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Analog Clock")
        $PosDiff[0] = $WinPos[2] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed ("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Analog Clock", "", $WinPos[0], $WinPos[1], $MousePos[0] + $PosDiff[0], _
                $MousePos[0] + $PosDiff[0])
                $WinPos = WinGetPos ("Analog Clock")
                $a = CreateRoundRectRgn (0, 0, $WinPos[2], $WinPos[3], $WinPos[2], $WinPos[3])
                SetWindowRgn($GUI_Clock, $a)
                $Mid = $WinPos[2]/2
                $Radius = $Mid
                $SecRad = $Mid * (21/30)
                $MinRad = $Mid * (19/30)
                $HourRad = $Mid * (17/30)
                If $OldFontSize <> Int ($Mid/15) Then
                    For $i = 1 To 12
                        GUICtrlSetFont ($Labels[$i], Int ($Mid/15), 800)
                    Next
                    $OldFontSize = Int ($Mid/15)
                EndIf
                CheckClockStuff(2)
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckClockStuff()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
    Opt ("MouseCoordMode", 1)
EndFunc

Func MoveTheClock()
    GUISetCursor (9, 1, $GUI_Clock)
    ToolTip ("Click and drag to move the clock.  Release to set position.")
    While 1
        $MousePos = MouseGetPos ()
        $WinPos = WinGetPos ("Analog Clock")
        $PosDiff[0] = $WinPos[0] - $MousePos[0]
        $PosDiff[1] = $WinPos[1] - $MousePos[1]
        If _IsPressed ("01", $user32_dll) Then
            While _IsPressed ("01", $user32_dll)
                $MousePos = MouseGetPos ()
                WinMove ("Analog Clock", "", $MousePos[0] + $PosDiff[0], $MousePos[1] + $PosDiff[1])
                $WinPos = WinGetPos ("Analog Clock")
                If ($WinPos[0] < -10) Or ($WinPos[1] < -10) Or ($WinPos[0] + $WinPos[2] > @DesktopWidth + 10) Or _
                    ($WinPos[1] + $WinPos[3] > @DesktopHeight + 10) Then
                    CheckClockStuff(2)
                Else
                    CheckClockStuff()
                EndIf
                Sleep (10)
            WEnd
            ExitLoop
        EndIf
        CheckClockStuff()
        Sleep (10)
    WEnd
    ToolTip ("")
    GUISetCursor ()
    AllThatGoodStuff(2)
EndFunc

Func ToggleOnTop()
    $OnTop = Not $OnTop
    WinSetOnTop ("Analog Clock", "", $OnTop)
    If $OnTop Then
        GUICtrlSetState ($MenuItemOnTop, $GUI_CHECKED)
        TrayItemSetState ($TrayItemOnTop, $TRAY_CHECKED)
    Else
        GUICtrlSetState ($MenuItemOnTop, $GUI_UNCHECKED)
        TrayItemSetState ($TrayItemOnTop, $TRAY_UNCHECKED)
    EndIf
EndFunc

Func CheckClockStuff($special = 0)
    If Not WinActive ("Analog Clock") Then $ClockActive = 0
    If WinActive ("Analog Clock") And $ClockActive = 0 Then
        AllThatGoodStuff(2)
        $ClockActive = 1
    EndIf
    If $Sec <> @SEC Then
        AllThatGoodStuff($special)
    EndIf
    If $AlarmStatus[$AlarmStatus[2]] And $WaitingForMin = 0 Then
        If $AlarmTime[0] = "One Date" Then
            If @YEAR = $AlarmTime[6] And @MON = $AlarmTime[4] And @MDAY = $AlarmTime[5] And _ 
                @MIN = $AlarmTime[2] Then
                CheckTheHour()
            EndIf
        ElseIf $AlarmTime[0] = "Weekdays" Then
            If _DateToDayOfWeekSpecial (@YEAR, @MON, @MDAY) <= 4 And @MIN = $AlarmTime[2] Then
                CheckTheHour()
            EndIf
        ElseIf $AlarmTime[0] = "Weekends" Then
            If _DateToDayOfWeekSpecial (@YEAR, @MON, @MDAY) > 4 And @MIN = $AlarmTime[2] Then
                CheckTheHour()
            EndIf
        Else
            If @MIN = $AlarmTime[2] Then
                CheckTheHour()
            EndIf
        EndIf
    EndIf
    If $WaitingForMin = 1 And $AlarmTime[2] <> @MIN Then $WaitingForMin = 0
EndFunc

Func CheckTheHour()
    If $AlarmTime[3] = "AM" Then
        If Number ($AlarmTime[1]) = Number (@HOUR) Then
            IGuessItsAlarmTime()
        ElseIf $AlarmTime[1] = "12" And @HOUR = "00" Then
            IGuessItsAlarmTime()
        EndIf
    Else
        If Number ($AlarmTime[1]) = Number (@HOUR - 12) Then
            IGuessItsAlarmTime()
        ElseIf $AlarmTime[1] = "12" And @HOUR = "12" Then
            IGuessItsAlarmTime()
        EndIf
    EndIf
EndFunc

Func Set_About()
    Opt ("GUIOnEventMode", 0)
    $GUI_About = GUICreate ("About", 200, 100, Default, Default, $WS_CAPTION, $WS_EX_TOPMOST)
    GUICtrlCreateLabel ("Analog Clock, Version " & $ver & @CRLF & @CRLF & "By greenmachine", 60, 10)
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
        CheckClockStuff(2)
    WEnd
    Opt ("GUIOnEventMode", 1)
EndFunc

Func Set_Trans()
    Opt ("GUIOnEventMode", 0)
    $GUI_Trans = GUICreate ("Set Analog Clock Transparency", 300, 100)
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
        WinSetTrans ($GUI_Clock, "", (100 - GUICtrlRead ($GUI_Trans_Slider))*2.5)
        CheckClockStuff(2)
    WEnd
    Opt ("GUIOnEventMode", 1)
EndFunc

Func ToggleAlarm()
    $AlarmStatus[2] = Not $AlarmStatus[2]
    GUICtrlSetData ($MenuItemAlarmStatus, "Alarm is: " & $AlarmStatus[$AlarmStatus[2]])
    TrayItemSetText ($TrayItemAlarmStatus, "Alarm is: " & $AlarmStatus[$AlarmStatus[2]])
EndFunc

Func SetAlarm()
    Local $GUI_Alarm, $GUI_Alarm_AMPM, $GUI_Alarm_Cal, $GUI_Alarm_Dates[4], $GUI_Alarm_Hour
    Local $GUI_Alarm_Min, $GUI_Alarm_SetAlarm
    Opt ("GUIOnEventMode", 0)
    $GUI_Alarm = GUICreate ("Set Alarm", 310, 290)
    GUICtrlCreateGroup ("Alarm Time", 5, 5, 210, 45)
    GUICtrlCreateGroup ("Date", 5, 60, 210, 190)
    GUICtrlCreateGroup ("Options", 220, 5, 85, 140)
    $GUI_Alarm_Hour = GUICtrlCreateCombo ("", 10, 22, 48, 20)
    GUICtrlCreateLabel (":", 67, 22)
    GUICtrlSetFont (-1, 12, 700)
    $GUI_Alarm_Min = GUICtrlCreateCombo ("", 80, 22, 48, 20)
    $GUI_Alarm_AMPM = GUICtrlCreateCombo ("", 160, 22, 48, 20)
    GUICtrlSetData ($GUI_Alarm_Hour, "1|2|3|4|5|6|7|8|9|10|11|12", $AlarmTime[1])
    GUICtrlSetData ($GUI_Alarm_Min, "00|01|02|03|04|05|06|07|08|09|")
    For $i = 10 To 58
        GUICtrlSetData ($GUI_Alarm_Min, $i & "|")
    Next
    GUICtrlSetData ($GUI_Alarm_Min, "59", $AlarmTime[2])
    GUICtrlSetData ($GUI_Alarm_AMPM, "AM|PM", $AlarmTime[3])
    
    $GUI_Alarm_Cal = GUICtrlCreateMonthCal ("", 10, 77, 200, 165)
    
    $GUI_Alarm_Dates[0] = GUICtrlCreateRadio ("Daily", 230, 20)
    $GUI_Alarm_Dates[1] = GUICtrlCreateRadio ("Weekdays", 230, 45)
    $GUI_Alarm_Dates[2] = GUICtrlCreateRadio ("Weekends", 230, 70)
    $GUI_Alarm_Dates[3] = GUICtrlCreateRadio ("One Date", 230, 95)
    $GUI_Alarm_SaveAlarm = GUICtrlCreateCheckbox ("Save Alarm", 230, 120)
    For $i = 0 To 3
        $GUI_Alarm_RadioText = GUICtrlRead ($GUI_Alarm_Dates[$i], 1)
        If $AlarmTime[0] = $GUI_Alarm_RadioText[0] Then
            GUICtrlSetState ($GUI_Alarm_Dates[$i], $GUI_CHECKED)
            ExitLoop
        EndIf
    Next
    If BitAND (GUICtrlRead ($GUI_Alarm_Dates[3]), $GUI_CHECKED) <> $GUI_CHECKED Then
        GUICtrlSetState ($GUI_Alarm_Cal, $GUI_DISABLE)
    EndIf
    If $AlarmSave[2] Then GUICtrlSetState ($GUI_Alarm_SaveAlarm, $GUI_CHECKED)
    $GUI_Alarm_SetAlarm = GUICtrlCreateButton ("Set Alarm", 110, 255, 90, 30)
    GUISetState ()
    While 1
        $msg = GUIGetMsg ()
        Switch $msg
            Case $GUI_EVENT_CLOSE
                GUIDelete ($GUI_Alarm)
                ExitLoop
            Case $GUI_Alarm_Dates[3]
                GUICtrlSetState ($GUI_Alarm_Cal, $GUI_ENABLE)
            Case $GUI_Alarm_Dates[0], $GUI_Alarm_Dates[1], $GUI_Alarm_Dates[2]
                GUICtrlSetState ($GUI_Alarm_Cal, $GUI_DISABLE)
            Case $GUI_Alarm_SetAlarm
                For $i = 0 To 3
                    If BitAND (GUICtrlRead ($GUI_Alarm_Dates[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
                        $GUI_Alarm_RadioText = GUICtrlRead ($GUI_Alarm_Dates[$i], 1)
                        $AlarmTime[0] = $GUI_Alarm_RadioText[0]
                        $AlarmTime[1] = GUICtrlRead ($GUI_Alarm_Hour)
                        $AlarmTime[2] = GUICtrlRead ($GUI_Alarm_Min)
                        $AlarmTime[3] = GUICtrlRead ($GUI_Alarm_AMPM)
                        If $i = 3 Then
                            $GUI_Alarm_MonthCalDate = StringSplit (GUICtrlRead ($GUI_Alarm_Cal), "/")
                            $AlarmTime[4] = $GUI_Alarm_MonthCalDate[2]
                            $AlarmTime[5] = $GUI_Alarm_MonthCalDate[3]
                            $AlarmTime[6] = $GUI_Alarm_MonthCalDate[1]
                        EndIf
                        ExitLoop
                    EndIf
                Next
                $WaitingForMin = 0
                $AlarmStatus[2] = 0
                ToggleAlarm()
                If GUICtrlRead ($GUI_Alarm_SaveAlarm) = $GUI_CHECKED Then
                    $AlarmSave[2] = 0
                Else
                    $AlarmSave[2] = 1
                EndIf
                ToggleSave()
                GUIDelete ($GUI_Alarm)
                If $AlarmTime[0] = "One Date" Then
                    GUICtrlSetData ($MenuItemAlarmTime, $AlarmTime[1] & ":" & $AlarmTime[2] & " " & _ 
                    $AlarmTime[3] & " on " & $AlarmTime[4] & "/" & $AlarmTime[5] & "/" & $AlarmTime[6])
                Else
                    GUICtrlSetData ($MenuItemAlarmTime, $AlarmTime[0] & " at " & $AlarmTime[1] & ":" & $AlarmTime[2] & " " & $AlarmTime[3])
                EndIf
                ExitLoop
        EndSwitch
        CheckClockStuff(2)
    WEnd
    Opt ("GUIOnEventMode", 1)
EndFunc

Func IGuessItsAlarmTime()
    $WaitingForMin = 1
    For $i = 1 To 10
        Beep (400, 500)
        $Timer = TimerInit()
        AllThatGoodStuff(2)
        If TimerDiff ($Timer) < 250 Then
            Sleep (300 - TimerDiff ($Timer))
        EndIf
    Next
EndFunc

Func ToggleSave()
    $AlarmSave[2] = Not $AlarmSave[2]
    GUICtrlSetData ($MenuItemSaveAlarm, "Save Alarm: " & $AlarmSave[$AlarmSave[2]])
    TrayItemSetText ($TrayItemSaveAlarm, "Save Alarm: " & $AlarmSave[$AlarmSave[2]])
    If $AlarmSave[2] Then
        IniWrite ($INI, "Alarm", "Dates", $AlarmTime[0])
        IniWrite ($INI, "Alarm", "Hour", $AlarmTime[1])
        IniWrite ($INI, "Alarm", "Min", $AlarmTime[2])
        IniWrite ($INI, "Alarm", "AMPM", $AlarmTime[3])
        IniWrite ($INI, "Alarm", "Month", $AlarmTime[4])
        IniWrite ($INI, "Alarm", "Day", $AlarmTime[5])
        IniWrite ($INI, "Alarm", "Year", $AlarmTime[6])
    Else
        If FileExists ($INI) Then FileDelete ($INI)
    EndIf
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
	_CoCleanup()
    Exit
EndFunc

Func OnAutoItExit()
    DllClose ($gdi_dll)
    DllClose ($user32_dll)
EndFunc
