#include <ScreenCapture.au3>
#include <GDIPlus.au3>
#include <Webcam.au3>
#include <Misc.au3>
#NoTrayIcon
Global $triggered
Global $triggerlog
Global $triggernum = 0
Global $triggernumstr
Global $triggernumlen = 3
Global $triggerregion[1][3]
Global $regioncount = 0
Global $end
Global $winloc
Global $customfile
Global $msg
_GDIPlus_Startup()

$gui= GUICreate('Spycam - No Active Regions', 320, 240, -1, -1)
$mnu = GuiCtrlCreateMenu("&Main")
    $set = GUICtrlCreateMenuItem("&Set Region(s)",$mnu)
	$clear = GUICtrlCreateMenuItem("&Clear Region(s)",$mnu)
	$exit = GUICtrlCreateMenuItem("E&xit",$mnu)
$mnutrigger = GuiCtrlCreateMenu("&Trigger")
    $beep = GUICtrlCreateMenuItem("&Beep",$mnutrigger)
		GUICtrlSetState(-1,$GUI_CHECKED)
	$screenshot = GUICtrlCreateMenuItem("Sc&reenshot",$mnutrigger)
	$capture = GUICtrlCreateMenuItem("Ca&pture",$mnutrigger)
	$custom = GUICtrlCreateMenuItem("Cust&om",$mnutrigger)
	GUICtrlCreateMenuItem("",$mnutrigger)
	$delay = GUICtrlCreateMenuItem("&Delay",$mnutrigger)
$webcam = _WebcamOpen($gui, 0, 0, 320, 240)

WinSetOnTop("Spycam - No Active Regions","",1)
GUISetState()

$winloc = WinGetPos("Spycam")
$timer = TimerInit()
$triggertimer = TimerInit()

While 1
	$msg = GUIGetMsg()
	If $end Then _Exit()
	If GUICtrlRead($delay) = 65 Then _Delay(10)
	If TimerDiff($timer) > 60000 Then
		_UpdateRegionColors()
		$timer = TimerInit()
	EndIf
	If $triggerregion[0][0] <> 0 Then
		For $i = 0 to $regioncount
			_DrawRegionCross($triggerregion[$i][0],$triggerregion[$i][1])
			$search = PixelSearch($triggerregion[$i][0]-5,$triggerregion[$i][1]-5,$triggerregion[$i][0]+5,$triggerregion[$i][1]+5,$triggerregion[$i][2],50)
			If @error Then $triggered = 1
			_CheckWinPos()
			If $triggered = 1 Then
				If TimerDiff($triggertimer) > 3000 Then
					_Trigger()
					$triggertimer = TimerInit()
				ElseIf TimerDiff($triggertimer) < 1000 Then
					_UpdateRegionColors()
					$triggered = 0
				EndIf
			EndIf
		Next
	EndIf	
	_CheckMsg()
	_CheckWinPos()
WEnd

_Exit()

Func _Beep()
	For $i = 1 to 10
		Beep(Round(Random(1000,7000)),80)
	Next
EndFunc

Func _Capture($num,$destfldr)
	$recordtime = TimerInit()
	_WebcamRecordStart($destfldr & "Spycam" & $num & ".avi",$webcam)
	_WebcamRecordStop($webcam)
EndFunc

Func _CheckMSG()
	If $msg = $set Then _SetRegion()
	If $msg = $clear Then 
		If $triggerregion[0][0] <> 0 Then
			ReDim $triggerregion[1][7]
			$triggerregion[0][0] = 0
			$regioncount = 0
			WinSetTitle(WinGetTitle("Spycam"),"","Spycam - No Active Regions")
		EndIf
	EndIf
	If $msg = $delay Then GuiCtrlSetState($delay,$GUI_CHECKED)
	If $msg = $beep Then _ToggleGuiCtrl("$beep")
	If $msg = $screenshot Then _ToggleGuiCtrl("$screenshot")
	If $msg = $capture Then _ToggleGuiCtrl("$capture")
	If $msg = $custom Then
		If GUICtrlRead($custom) <> 65 Then
			$customfile = FileOpenDialog("Select File to Execute on Trigger Event.",@ScriptDir,"All Files (*.*)")
			If FileExists($customfile) Then 
				GUICtrlSetState($custom,$GUI_CHECKED)
			EndIf
		Else
			GUICtrlSetState($custom,$GUI_UNCHECKED)
		EndIf
	EndIf
    If $msg = -3 Or $msg = $exit Then _SetExit()
EndFunc

Func _CheckWinPos()
	$winpos = WinGetPos("Spycam")
	If $winpos[0] <> $winloc[0] or $winpos[1] <> $winloc[1] Then
		_UpdateRegionColors()
		If $triggerregion[0][0] <> 0 Then
			For $i = 0 to $regioncount
				$triggerregion[$i][0] += ($winpos[0]-$winloc[0])
				$triggerregion[$i][1] += ($winpos[1]-$winloc[1])
			Next
		EndIf
		$winloc = WinGetPos("Spycam")
		$triggered = 0
		$triggertimer = TimerInit()
	EndIf
EndFunc

Func _Delay($y)
	For $x = $y to 1 Step -1
		$delaytime = TimerInit()
		Do
			_DrawRegionCross()
			ToolTip("Tracking in " & $x & " seconds.",$winloc[0]+100,$winloc[1]+70)
		Until TimerDiff($delaytime) > 999
	Next
	ToolTip("")
	GuiCtrlSetState($delay,$GUI_UNCHECKED)
	$delaytime = 0
EndFunc

Func _DrawRegionCross($x=0,$y=0)
    If $end Then _Exit()
	$winx = $winloc[0] + 3
	$winy = $winloc[1] + 48
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND(WinGetHandle("Spycam"))
	$hPen = _GDIPlus_PenCreate(0xFFFF0000)
	If $x <> 0 and $y <> 0 Then
		_GDIPlus_GraphicsDrawLine ($hGraphic, $x - $winx - 5, $y - $winY, $x - $winx + 5, $y - $winY, $hPen)
		_GDIPlus_GraphicsDrawLine ($hGraphic, $x - $winx, $y - $winY - 5, $x - $winx, $y - $winY + 5, $hPen)
	Else
		For $i = 0 to $regioncount
			_GDIPlus_GraphicsDrawLine ($hGraphic, $triggerregion[$i][0] - $winx - 5, $triggerregion[$i][1] - $winY, $triggerregion[$i][0] - $winx + 5, $triggerregion[$i][1] - $winY, $hPen)
			_GDIPlus_GraphicsDrawLine ($hGraphic, $triggerregion[$i][0] - $winx, $triggerregion[$i][1] - $winY - 5, $triggerregion[$i][0] - $winx, $triggerregion[$i][1] - $winY + 5, $hPen)
		Next
	EndIf
	_GDIPlus_PenDispose ($hPen)
    _GDIPlus_GraphicsDispose ($hGraphic)
EndFunc

Func _Exit()
	WinSetOnTop("Spycam","",0)
	_GDIPlus_Shutdown ()
    _WebcamClose($webcam)
	If $triggerlog Then msgbox(0,"Trigger Event Log - Last 15",$triggerlog)    
    Exit
EndFunc

Func _ScreenShot($num,$destfldr)
	_ScreenCapture_CaptureWnd($destfldr & "Spycam" & $num & ".jpg",$gui)
EndFunc

Func _SetExit()
    $end = True
EndFunc

Func _SetRegion()
    If $triggerregion[0][0] <> 0 Then
		$regioncount += 1
		ReDim $triggerregion[$regioncount+2][7]
	EndIf
	ToolTip("Highlight a region in the window.",$winloc[0]+80,$winloc[1]+20)
	$box = _RegionToBox(_GetMouseRegion())
	$triggerregion[$regioncount][0] = $box[0][0]+($box[1][0]/2)
    $triggerregion[$regioncount][1] = $box[0][1]+($box[1][1]/2)
	$triggerregion[$regioncount][2] = PixelGetColor($triggerregion[$regioncount][0]-1,$triggerregion[$regioncount][1]+1)
	If $regioncount > 0 Then 
		WinSetTitle(WinGetTitle("Spycam"),"","Spycam - " & $regioncount+1 & " active regions.")
	Else
		WinSetTitle(WinGetTitle("Spycam"),"","Spycam - " & $regioncount+1 & " active region.")
	EndIf
EndFunc

Func _ToggleGuiCtrl($var)
	If Execute("GUICtrlRead(" & $var & ")") = 65 Then
		Execute("GUICtrlSetState(" & $var & ",$GUI_UNCHECKED)")
	Else
		Execute("GUICtrlSetState(" & $var & ",$GUI_CHECKED)")
		If $var = "$custom" Then
			$customfile = FileOpenDialog("Select File to Execute on Trigger Event.",@ScriptDir,"All Files (*.*)")
			If Not FileExists($customfile) Then Execute("GUICtrlSetState(" & $var & ",$GUI_UNCHECKED)")
		EndIf
	EndIf
EndFunc

Func _Trigger()
	If $triggered = 0 Then Return 0

	$triggernum += 1
	$triggernumstr = $triggernum
	Do 
		$triggernumstr = "0" & $triggernumstr
	Until StringLen($triggernumstr) = $triggernumlen
	$event = "Trigger Event " & $triggernum & " @" & @Hour & ":" & @MIN & ":" & @SEC & @CRLF
	$triggerlog &= $event
	If StringInstr($triggerlog,@CRLF,0,16) Then $triggerlog = StringTrimLeft($triggerlog,StringInstr($triggerlog,@CRLF))
	$destfldr = @ScriptDir & "\" & @MON & @MDAY & @YEAR & "\"
	If Not FileExists($destfldr) Then DirCreate($destfldr)
	FileWriteLine($destfldr & "Spycam.log",$event)
	
	$triggered = 0
	If GUICtrlRead($custom) = 65 Then Run(@Comspec & " /c " & $customfile,"",@SW_HIDE)
	If GUICtrlRead($screenshot) = 65 Then _ScreenShot($triggernumstr,$destfldr)
	If GUICtrlRead($capture) = 65 Then _Capture($triggernumstr,$destfldr)
	If GUICtrlRead($beep) = 65 Then _Beep()
EndFunc

Func _UpdateRegionColors()
	For $i = 0 to $regioncount
		$triggerregion[$i][2] = PixelGetColor($triggerregion[$i][0]-1,$triggerregion[$i][1]+1)
	Next
EndFunc

#Region MouseRegion Functions
Func _StartDrag($dll)
    Do
        _DrawRegionCross()
		sleep(10)
    Until _IsPressed(1,$dll)
    Return MouseGetPos()
EndFunc

Func _FinishDrag($dll,$start,$flags=3)
    While _IsPressed(1,$dll)
        _DrawRegionCross()
		$current = MouseGetPos()
        If BitOR($flags,1) = $flags Then _ShowRegionStats($start,$current)
        If BitOR($flags,2) = $flags Then _ShowRegionHighlight($start,$current)
    WEnd
    ToolTip("")
    Return MouseGetPos()
EndFunc

Func _GetMouseRegion()
    $dll = DllOpen("user32.dll")
    $start = _StartDrag($dll)
    $finish = _FinishDrag($dll,$start)
    DllClose($dll)
    Dim $box[3][2]
    For $i = 0 to 2
        For $x = 0 to 1
            If $i = 0 Then
                $box[$i][$x] = $start[$x]
            ElseIf $i = 1 Then
                $box[$i][$x] = $finish[$x]
            Else
                $box[$i][$x] = $finish[$x] - $start[$x]
            EndIf
        Next
    Next
    Return $box
EndFunc

Func _RegionToBox($region)
    If Not IsArray($region) Then Return 0
    Dim $box[2][2]
    If $region[2][0] < 0 Then
        $box[0][0] = $region[1][0]
    Else
        $box[0][0] = $region[0][0]
    EndIf
    If $region[2][1] < 0 Then
        $box[0][1] = $region[1][1]
    Else
        $box[0][1] = $region[0][1]
    EndIf
    $box[1][0] = Abs($region[2][0])
    $box[1][1] = Abs($region[2][1])
    Return $box
EndFunc

Func _ShowRegionStats($start,$current)
    If $start[0] > $current[0] And $start[1] <> $current[1] Then
        ToolTip("X:" & $start[0] & @TAB & "X:" & $current[0] & @CRLF & "Y:" & $start[1] & @TAB & "Y:" & $current[1] & @CRLF & @CRLF & "Width = " & Abs($current[0]-$start[0]) & @CRLF & "Height = " & Abs($current[1]-$start[1]),$current[0]-74,$current[1]-70)
    ElseIf $start[0] < $current[0] And $start[1] <> $current[1] Then
        ToolTip("X:" & $start[0] & @TAB & "X:" & $current[0] & @CRLF & "Y:" & $start[1] & @TAB & "Y:" & $current[1] & @CRLF & @CRLF & "Width = " & Abs($current[0]-$start[0]) & @CRLF & "Height = " & Abs($current[1]-$start[1]),$current[0],$current[1])
    EndIf
EndFunc

Func _ShowRegionHighlight($start,$current)
    $hd = DllCall("user32.dll", "int", "GetDC", "hwnd", 0)
    $pen = DllCall("gdi32.dll", "int", "CreatePen", "int", 0, "int", 1, "int", 0x0000ff)
    DllCall("gdi32.dll", "int", "SelectObject", "int", $hd[0], "int", $pen[0])
    
    DllCall("GDI32.dll", "int", "MoveToEx", "hwnd", $hd[0], "int",$start[0], "int", $start[1], "int", 0)
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $start[0], "int", $current[1])
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $current[0], "int", $start[1])
    
    DllCall("GDI32.dll", "int", "MoveToEx", "hwnd", $hd[0], "int",$current[0], "int", $start[1], "int", 0)
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $current[0], "int", $current[1])
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $start[0], "int", $start[1])
    
    DllCall("GDI32.dll", "int", "MoveToEx", "hwnd", $hd[0], "int",$current[0], "int", $current[1], "int", 0)
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $start[0], "int", $current[1])
    
    DllCall("GDI32.dll", "int", "MoveToEx", "hwnd", $hd[0], "int",$start[0], "int", $start[1], "int", 0)
    DllCall("GDI32.dll", "int", "LineTo", "hwnd", $hd[0], "int", $current[0], "int", $start[1])

    DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $hd[0])

    sleep(50)
EndFunc
#EndRegion