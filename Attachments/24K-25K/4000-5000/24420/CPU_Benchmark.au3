#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <ProgressConstants.au3>
#Include <WinAPI.au3>
#include <GDIplus.au3>
#include <StaticConstants.au3>
#include <GuiCtrlSetOnHover_UDF.au3>
;~ #NoTrayIcon

Opt("TrayIconDebug", 1)

Global $terminate = False, $cpu_halt = false
Global Const $WM_ENTERSIZEMOVE = 0x0231
Global Const $WM_EXITSIZEMOVE = 0x0232
Global $more = false, $iii, $multi, $timer, $timer5
Global $processor_name, $Hover_Color = 0x007CB9, $prime_color = "0xC4E1FF"

$Form1 = GUICreate("CPU Benchmark", 370, 130, -1, -1, $WS_POPUP)
GUISetBkColor(0, $Form1)
GUISetFont(8, 800, -1, "Arial", $Form1)
Global $size = WinGetPos($Form1)
$label = GUICtrlCreateLabel("Progress:", 15, 12, 310, 15)
GUICtrlSetColor(-1, 0xC4E1FF)
GUICtrlSetCursor(-1, 9)
$mininize_string = GUICtrlCreateLabel("_", $size[2]-35, 10, 10, 12, $ES_CENTER)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$close_string = GUICtrlCreateLabel("x", $size[2]-20, 10, 10, 12, $ES_CENTER)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetCursor(-1, 0)
GUICtrlSetOnHover(-1, "Hover_Func_red", "Leave_Hover_Func")
$progress = GUICtrlCreateProgress(15, 30, 340, 17)
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
GUICtrlSetStyle($progress, BitOr($GUI_SS_DEFAULT_PROGRESS, $PBS_SMOOTH))
GUICtrlSetColor(-1, 0x005B88)
GUICtrlSetBkColor(-1, 0xC4E1FF)
$percentage_label = GUICtrlCreateLabel("0 %",  30, 50, 310, 17, $ES_CENTER)
GUICtrlSetColor(-1, 0xC4E1FF)
$label2 = GUICtrlCreateLabel("Start benchmark with optimization for:", 30, 75, 310, 17, $ES_CENTER)
GUICtrlSetColor(-1, 0xC4E1FF)
$single_core_button = GUICtrlCreateLabel("Single Core", 60, 100, 60, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$dual_core_button = GUICtrlCreateLabel("Dual/Quad Core", 230, 100, 80, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$stop_button = GUICtrlCreateLabel("Stop", 150, 100, 60, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetOnHover(-1, "Hover_Func_red", "Leave_Hover_Func")
GUICtrlSetState($stop_button, $GUI_HIDE)
$more_label = GUICtrlCreateLabel(ChrW(9660), 351, 108, 10, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
Dim $graph[10]
for $i = 1 to 9
	$graph[$i] = GUICtrlCreateGraphic($i-1, $i-1, $size[2]-(($i-1)*2), $size[3]-(($i-1)*2))
	Switch $i
		case 1
			GUICtrlSetColor($graph[$i], 0x000000)
		case 2
			GUICtrlSetColor($graph[$i], 0xC6ECFF)
		case 3
			GUICtrlSetColor($graph[$i], 0x8CDAFF)
		case 4
			GUICtrlSetColor($graph[$i], 0x79D3FF)
		case 5
			GUICtrlSetColor($graph[$i], 0x00A3F0)
		case 6
			GUICtrlSetColor($graph[$i], 0x007CB9)
		case 7
			GUICtrlSetColor($graph[$i], 0x005279)
		case 8
			GUICtrlSetColor($graph[$i], 0x00496C)
		case 9
			GUICtrlSetColor($graph[$i], 0x002537)
	EndSwitch
Next

;~ $graph2 = GUICtrlCreateGraphic(0, 0, 12, 15)
;~ GUICtrlSetColor(-1, 0x005279)
;~ GUICtrlSetState(-1, $GUI_HIDE)

;~ $form12 = GUICreate("wait", 160, 30, $size[2]/2-80, $size[3]/2-15, $WS_POPUP, $WS_EX_MDICHILD+$WS_EX_TOPMOST, $Form1)
;~ GUICtrlCreateLabel("Please wait...", 10, 3, 140, 20, $ES_CENTER)
;~ GUICtrlSetColor(-1, 0xFF0000)
;~ GUICtrlSetFont(-1, 17, 800, 2, "Arial")
;~ GUIsetBkColor(0, $form12)
;~ DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $form12, "int", 250, "long", 0x00080000);fade-in
;~ GUISetState(@SW_SHOWNOACTIVATE, $form12)
$processor_name = _get_proc_name()
;~ DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $form12, "int", 250, "long", 0x00090000);fade-out
;~ GUIDelete($form12)

DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $form1, "int", 250, "long", 0x00080000);fade-in
_WinAPI_RedrawWindow($form1)
GUISetState(@SW_SHOW, $Form1)

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
GUIRegisterMsg($WM_ENTERSIZEMOVE,"WM_ENTERSIZEMOVE")
GUIRegisterMsg($WM_EXITSIZEMOVE, "WM_EXITSIZEMOVE")

Global Const $width = 215
Global Const $height = 40
Global $text = "CPU Benchmark"

$form2 = GUICreate("title", $width, $height, $size[2]-$width-81, -$height+11, $WS_POPUP, $WS_EX_MDICHILD, $Form1)
$size2 = WinGetPos($form2)
dim $graph3[6]
for $i = 1 to 5
	$graph3[$i] = GUICtrlCreateGraphic($i-1, $i-1, $size2[2]-(($i-1)*2), $size2[3]-(($i-1)*2))
	Switch $i
		case 1
			GUICtrlSetColor($graph3[$i], 0x000000)
		case 2
			GUICtrlSetColor($graph3[$i], 0x8CDAFF)
		case 3
			GUICtrlSetColor($graph3[$i], 0x00A3F0)
		case 4
			GUICtrlSetColor($graph3[$i], 0x005279)
		case 5
			GUICtrlSetColor($graph3[$i], 0x002537)
	EndSwitch
Next
$fix_image = GUICtrlCreatePic("", 5, 5, 205, 30)
GUICtrlSetState($fix_image, $GUI_HIDE)
GUISetBkColor(0x000000, $form2)
DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $form2, "int", 250, "long", 0x00040008)
_WinAPI_RedrawWindow($form2)
GUISetState(@SW_SHOWNOACTIVATE, $form2)

_GDIPlus_Startup()
$graphics = _GDIPlus_GraphicsCreateFromHWND($form2)
$bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
$brush = _GDIPlus_BrushCreateSolid(0x1A000000)
$hBrush = _GDIPlus_BrushCreateSolid ("0xFF" & StringRight($prime_color, 6))
$font_size = 18
$hFormat = _GDIPlus_StringFormatCreate ()
$hFamily = _GDIPlus_FontFamilyCreate ("Arial")
$hFont = _GDIPlus_FontCreate ($hFamily, $font_size, 2)
$hFont2 = _GDIPlus_FontCreate ($hFamily, $font_size*(1.2), 2)

$letters = StringSplit($text, "")

_AntiAlias($backbuffer, 4)

_GDIPlus_GraphicsClear($backbuffer)
$width2 = 200
$height2 = 102
$form3 = GUICreate("result", $width2, $height2, $size[2]-$width2-3, $size[3]-2, $WS_POPUP, $WS_EX_MDICHILD, $Form1)
GUISetBkColor(0x000000, $form3)
$size3 = WinGetPos($form3)
$less_label = GUICtrlCreateLabel(chrw(9650), 185, 5, 10, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetFont(-1, 8, 800, -1, "Arial")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$copy_label = GUICtrlCreateLabel("copy results", 7+4, 5, 60, 13, $ES_CENTER)
GUICtrlSetCursor(-1, 0)
GUICtrlSetColor(-1, $prime_color)
GUICtrlSetFont(-1, 8, 800, -1, "Arial")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
;~ $compare_label = GUICtrlCreateLabel("compare results", 7+4+80, 4, 80, 13, $ES_CENTER)
;~ GUICtrlSetCursor(-1, 0)
;~ GUICtrlSetColor(-1, $prime_color)
;~ GUICtrlSetFont(-1, 8, 800, -1, "Arial")
GUICtrlSetOnHover(-1, "Hover_Func", "Leave_Hover_Func")
$edit_result = GUICtrlCreateEdit("", 5, 18, 190, 69+10, $ES_MULTILINE+$ES_WANTRETURN+$ES_AUTOVSCROLL+$ES_READONLY)
$edit_text = "Test:   " & @CRLF _
			& "Your time:   " & @CRLF _
			& Chrw(960) & " (pi) result:   " & @CRLF _
			& "Your CPU:   " & $processor_name[0] & @CRLF _
			& "CPU cores:   " & $processor_name[1]

GUICtrlSetData($edit_result, $edit_text)
GUICtrlSetBkColor(-1, 0)
GUICtrlSetColor(-1, 0xC4E1FF)
GUICtrlSetFont(-1, 8, 800, -1, "Arial")
dim $graph4[6]
for $i = 1 to 5
	$graph4[$i] = GUICtrlCreateGraphic($i-1, $i-1, $size3[2]-(($i-1)*2), $size3[3]-(($i-1)*2))
	Switch $i
		case 1
			GUICtrlSetColor($graph4[$i], 0x000000)
		case 2
			GUICtrlSetColor($graph4[$i], 0x8CDAFF)
		case 3
			GUICtrlSetColor($graph4[$i], 0x00A3F0)
		case 4
			GUICtrlSetColor($graph4[$i], 0x005279)
		case 5
			GUICtrlSetColor($graph4[$i], 0x002537)
	EndSwitch
Next
GUISetState(@SW_HIDE, $form3)
_expand_more(1, $form3, 1)
$more = True

;~ $width3 = 70
;~ $height3 = 120
;~ $form4 = GUICreate("cpu usage", $width3, $height3, $size[2]-2, $size[3]-$height3-3, $WS_POPUP, $WS_EX_MDICHILD, $Form1)
;~ GUISetBkColor(0x000000, $form4)
;~ $size4 = WinGetPos($form4)
;~ $label_usage = GUICtrlCreateLabel("CPU usage", 5, 5, $width3-10, 13, $ES_CENTER)
;~ GUICtrlSetColor(-1, $prime_color)
;~ GUICtrlSetFont(-1, 8, 800, -1, "Arial")

;~ $cpu_progress = GUICtrlCreateProgress(10, 20, $width3-20, $height3-38, $PBS_VERTICAL)
;~ DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", 0, "wstr", 0)
;~ GUICtrlSetStyle($cpu_progress, BitOr($PBS_SMOOTH, $PBS_VERTICAL))
;~ GUICtrlSetColor(-1, $prime_color)
;~ GUICtrlSetBkColor(-1, 0x000000)
;~ GUICtrlSetData(-1, 100)

;~ $cpu_usage = GUICtrlCreateLabel(GUICtrlRead($cpu_progress) & " %", 5+25, $height3-18, $width3-40, 13, $ES_RIGHT)
;~ ;GUICtrlSetBkColor(-1, 0xFF0000)
;~ GUICtrlSetColor(-1, $prime_color)
;~ GUICtrlSetFont(-1, 8, 800, -1, "Arial")


;~ ;ChrW(9668) & ChrW(9658)

;~ GUICtrlCreateLabel(chrw(9668), 5+2, $height3-18, 10, 13, $ES_CENTER)
;~ ;GUICtrlSetBkColor(-1, 0xFF0000)
;~ GUICtrlSetColor(-1, $prime_color)
;~ GUICtrlSetFont(-1, 8, 800, -1, "Arial")

;~ dim $graph5[6]
;~ for $i = 1 to 5
;~ 	$graph5[$i] = GUICtrlCreateGraphic($i-1, $i-1, $size4[2]-(($i-1)*2), $size4[3]-(($i-1)*2))
;~ 	Switch $i
;~ 		case 1
;~ 			GUICtrlSetColor($graph5[$i], 0x000000)
;~ 		case 2
;~ 			GUICtrlSetColor($graph5[$i], 0x8CDAFF)
;~ 		case 3
;~ 			GUICtrlSetColor($graph5[$i], 0x00A3F0)
;~ 		case 4
;~ 			GUICtrlSetColor($graph5[$i], 0x005279)
;~ 		case 5
;~ 			GUICtrlSetColor($graph5[$i], 0x002537)
;~ 	EndSwitch
;~ Next
;~ GUISetState(@SW_HIDE, $form4)
;~ _expand_more(1, $form4, 2)

Func Hover_Func($CtrlID)
	GUICtrlSetColor($CtrlID, $Hover_Color)
EndFunc

Func Hover_Func_red($CtrlID)
	GUICtrlSetColor($CtrlID, 0xFF0000)

EndFunc

Func Leave_Hover_Func($CtrlID)
	GUICtrlSetColor($CtrlID, $prime_color)
EndFunc

Func WM_ENTERSIZEMOVE($hWndGUI, $MsgID, $WParam, $LParam)
    WinSetTrans($form2,"",254)
	WinSetTrans($form3,"",254)
;~ 	WinSetTrans($form4,"",254)
	GUIRegisterMsg($WM_TIMER, "_gdi_plus_move")
    DllCall("User32.dll", "int", "SetTimer", "hwnd", $form2, "int", 50, "int", 50, "int", 0)
EndFunc

Func WM_EXITSIZEMOVE($hWndGUI, $MsgID, $WParam, $LParam)
    WinSetTrans($form2,"",255)
	WinSetTrans($form3,"",255)
;~ 	WinSetTrans($form4,"",255)
	GUIRegisterMsg($WM_TIMER, "")
    DllCall("user32.dll", "int", "KillTimer", "hwnd", $form2, "int*", 50)
EndFunc

func _kill_script()
	_GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
    _GDIPlus_StringFormatDispose ($hFormat)
    _GDIPlus_BrushDispose($brush)
    _GDIPlus_GraphicsDispose($backbuffer)
    _GDIPlus_BitmapDispose($bitmap)
    _GDIPlus_GraphicsDispose($graphics)
    _GDIPlus_Shutdown()
;~ 	_expand_more(0, $form4, 2)
	if $more = true then _expand_more(0, $form3, 1)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $form2, "int", 150, "long", 0x00050004)
	GUISetState(@SW_HIDE, $form2)
	DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $Form1, "int", 150, "long", 0x00090000)
	Exit
EndFunc

func _gdi_plus_move()
	if $iii = $letters[0] Then
		$iii = 1
	Else
		$iii += 1
	EndIf
	_GDIPlus_GraphicsFillRect($backbuffer, 0, 0, $width, $height, $brush)
	if $letters[$iii] = "a" OR $letters[$iii] = "r" then
		$multi = 15.5
	Elseif $letters[$iii] = "e" OR $letters[$iii] = "n" OR $letters[$iii] = "c" Then
		$multi = 15.3
	ElseIf $letters[$iii] = "m" then
		$multi = 14.9
	Else
		$multi = 15
	EndIf
	$tLayout = _GDIPlus_RectFCreate (1/$width+$iii*$multi-10, 1/$height+5, 0, 0)
	_GDIPlus_GraphicsDrawStringEx ($backbuffer, $letters[$iii], $hFont, $tLayout, $hFormat, $hBrush)
	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 1, 1, $width-10, $height-10)
EndFunc
	
Func _Cpu_Usage($init = 0)
;~ 	if $cpu_halt = false then
    Local $liOldIdleTime = 0
    Local $liOldSystemTime = 0
   
    $SYSTEM_BASIC_INFORMATION = DllStructCreate("int;uint;uint;uint;uint;uint;uint;ptr;ptr;uint;byte;byte;short")
    $status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", 0, _
            "ptr", DllStructGetPtr($SYSTEM_BASIC_INFORMATION), _
            "int", DllStructGetSize($SYSTEM_BASIC_INFORMATION), _
            "int", 0)
	ConsoleWrite("ispred -1" & @CRLF)
    If $status[0]Then Return -1
   ConsoleWrite("ispred while" & @CRLF)
    While 1
        $SYSTEM_PERFORMANCE_INFORMATION = DllStructCreate("int64;int[76]")
        $SYSTEM_TIME_INFORMATION = DllStructCreate("int64;int64;int64;uint;int")

        $status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", 3, _
                "ptr", DllStructGetPtr($SYSTEM_TIME_INFORMATION), _
                "int", DllStructGetSize($SYSTEM_TIME_INFORMATION), _
                "int", 0)
		ConsoleWrite("ispred -2" & @CRLF)
        If $status[0]Then Return -2
       
        $status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", 2, _
                "ptr", DllStructGetPtr($SYSTEM_PERFORMANCE_INFORMATION), _
                "int", DllStructGetSize($SYSTEM_PERFORMANCE_INFORMATION), _
                "int", 0)
		ConsoleWrite("ispred -3" & @CRLF)
        If $status[0]Then Return -3
      
        If $init = 1 Or $liOldIdleTime = 0 Then
            $liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
            $liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)
			ConsoleWrite("sleep" & @CRLF)
;~ 			$cpu_halt = true
			Sleep(50)
;~             $timer5 = TimerInit()
			if $init = 1 Then
				Return -99
;~ 				ExitLoop
			EndIf
        Else
			ConsoleWrite("konacno" & @CRLF)
;~ 			if TimerDiff($timer5) >= 1000 then
				$dbIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1) - $liOldIdleTime
				$dbSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2) - $liOldSystemTime
				$liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
				$liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)
			   
				$dbIdleTime = $dbIdleTime / $dbSystemTime
			   
				$dbIdleTime = 100.0 - $dbIdleTime * 100.0 / DllStructGetData($SYSTEM_BASIC_INFORMATION, 11) + 0.5
				Return $dbIdleTime
;~ 			EndIf
        EndIf
        $SYSTEM_PERFORMANCE_INFORMATION = 0
        $SYSTEM_TIME_INFORMATION = 0
		ConsoleWrite("ponovo while" & @CRLF)
    WEnd
;~ 	endif
EndFunc   ;==>CurrentCPU

While 1
;~ 	if TimerDiff($timer5) >= 1000 then $cpu_halt = false
;~ 	ConsoleWrite("opet ucitavam funkciju" & @CRLF)
;~ 	Local $usage = Round(_Cpu_Usage(0))
;~ 	if $cpu_halt = false then
;~ 		GUICtrlSetData($cpu_progress, $usage)
;~ 		GUICtrlSetData($cpu_usage, $usage & " %")
;~ 	EndIf
	if TimerDiff($timer) >= 50 then
		_gdi_plus_move()
		$timer = TimerInit()
	EndIf
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		case $single_core_button
			_start_benchmark(2)
		case $dual_core_button
			_start_benchmark(3)
		case $copy_label
				ClipPut(GUICtrlRead($edit_result))
		case $label, $graph[1] to $graph[9]
			dllcall("user32.dll","int","SendMessage","hWnd", $Form1,"int",0xA1,"int", 2,"int", 0)
	EndSwitch
	Sleep(10)
WEnd

Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Switch $iwParam
		case $stop_button
			$terminate = true
		case $mininize_string
			WinSetState($Form1, "", @SW_MINIMIZE)
		case $close_string
			_kill_script()
		case $more_label
			_expand_more(1, $form3, 1)
			$more = True
		case $less_label
			_expand_more(0, $form3, 1)
			$more = False
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc

func _expand_more($question, $gui_handle, $location)
	Local $animation_in, $animation_out
	if $location = 1 Then
		$animation_in = 0x00040004
		$animation_out = 0x00050008
	ElseIf $location = 2 Then
		$animation_in = 0x00040001
		$animation_out = 0x00050002
	EndIf
	if $question = 1 Then
		GUICtrlSetState($more_label, $GUI_HIDE)
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui_handle, "int", 150, "long", $animation_in)
		_WinAPI_RedrawWindow($gui_handle)
		GUISetState(@SW_SHOWNOACTIVATE, $gui_handle)
;~ 		if $gui_handle = $form3 then $more = true
	ElseIf $question = 0 Then
		DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $gui_handle, "int", 150, "long", $animation_out)
		GUISetState(@SW_HIDE, $gui_handle)
		GUICtrlSetState($more_label, $GUI_SHOW)
;~ 		if $gui_handle = $form3 then $more = false
	EndIf
EndFunc

func _ctg($number, $max_i, $i_blah)
	Local $first_time_1 = True
	Local $percentage = 0
	Local $i_new
	Local $previous_sign = 1
	Local $return_value = 0
	for $i = 3 to $max_i
		if $terminate = true then ExitLoop
		if StringIsDigit($i/2) = 0 Then
			$previous_sign *= (-1)
			$return_value += $previous_sign*($number^$i)/$i
			if $i_blah = 1 Then
				$i_new = int($i*100/(3700000))
				if $percentage <> $i_new Then
					$percentage = $i_new
					GUICtrlSetData($progress, $percentage)
					GUICtrlSetData($percentage_label, $percentage & " %")
				EndIf
			ElseIf $i_blah = 2 then
				$i_new = int(($i+2860000)*100/(3700000))
				if $percentage <> $i_new Then
					$percentage = $i_new
					GUICtrlSetData($progress, $percentage)
					GUICtrlSetData($percentage_label, $percentage & " %")
				EndIf
			EndIf
		EndIf
	Next
	Return $number + $return_value
EndFunc

func _GDIplus_working_on_benchmark()
	for $i = -80 to 35
		_GDIPlus_GraphicsFillRect($backbuffer, 0, 0, $width, $height, $brush)
		Local $tLayout = _GDIPlus_RectFCreate (1/$width+5+$i, 1/$height+5, 0, 0)
		_GDIPlus_GraphicsDrawStringEx ($backbuffer, "Testing CPU", $hFont, $tLayout, $hFormat, $hBrush)
		_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 1, 1, $width-10, $height-10)
;~ 		Sleep(1)
	Next
    Local $GC = _GDIPlus_ImageGetGraphicsContext($bitmap)
    Local $newBmp = _GDIPlus_BitmapCreateFromGraphics($width-10, $height-10, $GC)
    Local $newGC = _GDIPlus_ImageGetGraphicsContext($newBmp)
    _GDIPlus_GraphicsDrawImageRect($newGC, $bitmap, 0, 0, $width-10, $height-10)
    _GDIPlus_ImageSaveToFile($newBmp, @TempDir & "\snd_benchmark_temp_testing.bmp")
    _GDIPlus_GraphicsDispose($GC)
    _GDIPlus_GraphicsDispose($newGC)
    _GDIPlus_BitmapDispose($newBmp)
    _GDIPlus_ImageDispose(@TempDir & "\snd_benchmark_temp_testing.bmp")
	GUICtrlSetImage($fix_image, @TempDir & "\snd_benchmark_temp_testing.bmp")
	GUICtrlSetState($fix_image, $GUI_SHOW)
EndFunc

func _GDIPlus_done_with_benchmarking()
	for $i = 35 to 220
		_GDIPlus_GraphicsFillRect($backbuffer, 0, 0, $width, $height, $brush)
		Local $tLayout = _GDIPlus_RectFCreate (1/$width+5+$i, 1/$height+5, 0, 0)
		_GDIPlus_GraphicsDrawStringEx ($backbuffer, "Testing CPU", $hFont, $tLayout, $hFormat, $hBrush)
		_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 1, 1, $width-10, $height-10)
;~ 		Sleep(1)
	Next
	$iii = 0
	GUICtrlSetImage($fix_image, "")
	GUICtrlSetState($fix_image, $GUI_HIDE)
	FileDelete(@TempDir & "\snd_benchmark_temp_testing.bmp")
EndFunc

func _start_benchmark($cores)
	GUICtrlSetState($dual_core_button, $GUI_HIDE)
	GUICtrlSetState($single_core_button, $GUI_HIDE)
	GUICtrlSetState($stop_button, $GUI_SHOW)
	Local $percentage = 0
	Local $pi = 0
	Local $some_number = 0
	Local $i_new
	GUICtrlSetState($more_label, $GUI_HIDE)
	GUICtrlSetState($less_label, $GUI_HIDE)
	GUICtrlSetState($copy_label, $GUI_HIDE)
	_GDIplus_working_on_benchmark()
	GUICtrlSetData($label2, "CPU cooldown 3 sec...")
	Local $timer_cpu_cool_down = TimerInit()
	Local $timer_dif
	Local $timer_prev
	Do
		$timer_dif = Int(TimerDiff($timer_cpu_cool_down)/1000)
		if $timer_prev <> $timer_dif Then
			$timer_prev = $timer_dif
			GUICtrlSetData($label2, "CPU cooldown " & 3-$timer_dif & " sec...")
		EndIf
		if $terminate = true then ExitLoop
		Sleep(10)
	Until $timer_dif >= 3
	GUICtrlSetData($label2, "Please wait...")
	Local $timer = TimerInit()
;======================================
	If $cores = 1 Then ;single core optimization 1
;~ 		for $i = 0 to 3000000
;~ 			if $terminate = true then ExitLoop
;~ 			$pi += (1/(16^$i))*(4/(8*$i+1)-2/(8*$i+4)-1/(8*$i+5)-1/(8*$i+6))
;~ 			$i_new = Int($i/30000)
;~ 			if $percentage <> $i_new Then
;~ 				$percentage = $i_new
;~ 				GUICtrlSetData($progress, $percentage)
;~ 				GUICtrlSetData($percentage_label, $percentage & " %")
;~ 			EndIf
;~ 		Next
;======================================
	ElseIf $cores = 2 then ;single core optimization 2
		Local $a0 = 1, $a1
		Local $b0 = 1/Sqrt(2), $b1
		Local $t0 = 1/4, $t1
		Local $p0 = 1, $p1
		for $i = 1 to 3000000
			if $terminate = true then ExitLoop
			$a1 = ($a0 + $b0)/2
			$b1 = Sqrt($a0 * $b0)
			$t1 = $t0 - $p0 * ($a0 - $a1)^2
			$p1 = 2 * $p0
			$a0 = $a1
			$b0 = $b1
			$t0 = $t1
			$p0 = $p1
			$i_new = int($i/30000)
			if $percentage <> $i_new Then
				$percentage = $i_new
				GUICtrlSetData($progress, $percentage)
				GUICtrlSetData($percentage_label, $percentage & " %")
			EndIf
		Next
		$pi = (($a0 + $b0)^2)/(4 * $t0)
;======================================
;~ 		$some_number = 4*_ctg(1/5, 2860000, 1)-_ctg(1/239, 840000, 2)
;~ 		$pi = $some_number*4
;======================================
	ElseIf $cores = 3 then ;dual/quad core optimization 1
		for $i = 0 to 3000
			if $terminate = true then ExitLoop
			$some_number += (_factorial(6*$i)*(13591409+545140134*$i))/(_factorial(3*$i)*((_factorial($i))^3)*(-640320)^(3*$i))
			$i_new = int($i/30)
			if $percentage <> $i_new Then
				$percentage = $i_new
				GUICtrlSetData($progress, $percentage)
				GUICtrlSetData($percentage_label, $percentage & " %")
			EndIf
		Next
		$pi = (426880*Sqrt(10005))/$some_number
;======================================		
	ElseIf $cores = 4 then ;dual/quad core optimization 2
;~ 		for $i=0 to 4000
;~ 			if $terminate = true then ExitLoop
;~ 			$some_number += _factorial(4*$i)*(1103+26390*$i)/(_factorial($i)^4*396^(4*$i))
;~ 			$i_new = int($i/40)
;~ 			if $percentage <> $i_new Then
;~ 				$percentage = $i_new
;~ 				GUICtrlSetData($progress, $percentage)
;~ 				GUICtrlSetData($percentage_label, $percentage & " %")
;~ 			EndIf
;~ 		Next
;~ 		$some_number = 2*Sqrt(2)/9801*$some_number
;~ 		$pi = 1/$some_number
	Endif
;======================================
	GUICtrlSetData($progress, 0)
	GUICtrlSetData($percentage_label, "0 %")
	GUICtrlSetState($stop_button, $GUI_HIDE)
	GUICtrlSetState($dual_core_button, $GUI_SHOW)
	GUICtrlSetState($single_core_button, $GUI_SHOW)
	GUICtrlSetState($copy_label, $GUI_SHOW)
	GUICtrlSetData($label2, "Start benchmark with optimization for:")
;~ 	ConsoleWrite(winGetState($form3) & @CRLF)
	if $more = false then GUICtrlSetState($more_label, $GUI_SHOW)
	GUICtrlSetState($less_label, $GUI_SHOW)
	_GDIPlus_done_with_benchmarking()
	if $terminate = False then
		_display_results(Round((TimerDiff($timer)/1000), 4), $pi, $cores)
	Else
		$terminate = False
	EndIf
EndFunc

func _get_proc_name()
	Local $HKCU = "HKEY_CURRENT_USER"
	Local $HKLM = "HKEY_LOCAL_MACHINE"
	Local $aProcessorInfo[2]
;~ 	
	If @OSArch = "X64" Then ; Or @ProcessorArch depends on AutoIt version
		$HKCU &= "64"
		$HKLM &= "64"
	EndIf

	$aProcessorInfo[0] = StringStripWS(RegRead($HKLM & "\HARDWARE\DESCRIPTION\System\CentralProcessor\0", "ProcessorNameString"), 4)
	$aProcessorInfo[1] = EnvGet("NUMBER_OF_PROCESSORS") ;

;~ 	Local $cI_CompName = @ComputerName
;~ 	Local $colItems, $objWMIService, $objItem
;~ 	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
;~ 	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Processor", "WQL", 0x10 + 0x20)
;~ 	If IsObj($colItems) Then
;~ 		For $objItem In $colItems
;~ 			$aProcessorInfo[0] = StringStripWS($objItem.Name, 7)
;~ 			$aProcessorInfo[1] = $objItem.MaxClockSpeed & " MHz"
;~ 		Next
;~ 	EndIf
	Return $aProcessorInfo
EndFunc

func _display_results($time, $result, $test)
	Local $test_type = ""
	if $test = 2 then
		$test_type = "Single Core optimization"
	ElseIf $test = 3 Then
		$test_type = "Dual/Quad Core optimization"
	EndIf
	Local $display_text = "Test:   " & $test_type & @CRLF _
			& "Your time:   " & $time & " sec" & @CRLF _
			& Chrw(960) & " (pi) result:   " & $result & @CRLF _
			& "Your CPU:   " & $processor_name[0] & @CRLF _
			& "CPU cores:   " & $processor_name[1]
	GUICtrlSetData($edit_result, $display_text)
	if $more = False Then
		_expand_more(1, $form3, 1)
		$more = True
	EndIf
EndFunc

func _factorial($number)
	Local $return_value = Number($number)
	for $i = 1 to Number($number-1)
		$return_value *= $i
	Next
	if $return_value = 0 Then
		Return 1
	Else
		Return $return_value
	EndIf
EndFunc

Func _AntiAlias($hGraphics, $mode)
    Local $aResult
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetSmoothingMode", "hwnd", $hGraphics, "int", $mode)
    If @error Then Return SetError(@error, @extended, False)
    Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc ;==>_AntiAlias