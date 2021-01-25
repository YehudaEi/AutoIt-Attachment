;coded by UEZ 2009-01-22
#AutoIt3Wrapper_outfile=Mesmerizing Squares Screensaver.exe
#AutoIt3Wrapper_Res_Description=Mesmerizing Squares Screensaver
#AutoIt3Wrapper_Res_Fileversion=0.85.0.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_LegalCopyright=UEZ 01/2009
#AutoIt3Wrapper_Res_Field=Coded by|UEZ
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
#include <GDIPlus.au3>
#include <WindowsConstants.au3>
Opt('MustDeclareVars', 1)
If WinExists("ScrnSav:" & @ScriptFullPath) Then WinKill("ScrnSav:" & @ScriptFullPath)
AutoItWinSetTitle("ScrnSav:" & @ScriptFullPath)

Const $appname = "Mesmerizing Squares Screensaver"
Const $ver = "v0.85"
Const $build = "build 2009-02-22"
Const $Pi = 3.1415926535897932384626433832795
Global $hGUI, $hGraphic, $Bitmap, $GDI_Buffer, $Pen, $Pen_size, $brush, $Pixel_Widht
Global $i, $j, $k, $xcoord, $ycoord, $red, $green, $blue
Global $x1, $x2, $x3, $x4, $y1, $y2, $y3, $y4, $x, $y
Global $VirtualDesktopHeight, $VirtualDesktopWidth, $VirtualDesktopX, $VirtualDesktopY
Global $width, $height, $new, $last, $user32, $parent_PID, $child_PID
Global $CommandLine, $average_time, $c
Global $degree = 45
Global $pi_div_180 = 0.017453292519943295769236907684886 ;$Pi / 180
Global $pi_div_120 = 0.026179938779914943653855361527329 ;$Pi / 120

$width = @DesktopWidth
$height = @DesktopHeight

$VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 78);sm_virtualwidth
$VirtualDesktopWidth = $VirtualDesktopWidth[0]
$VirtualDesktopHeight = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 79);sm_virtualheight
$VirtualDesktopHeight = $VirtualDesktopHeight[0]
$VirtualDesktopX = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 76);sm_xvirtualscreen
$VirtualDesktopX = $VirtualDesktopX[0]
$VirtualDesktopY = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 77);sm_yvirtualscreen
$VirtualDesktopY = $VirtualDesktopY[0]


If $CmdLine[0] > 0 Then
	$CommandLine = StringLeft($CmdLine[1], 2)
Else
	$CommandLine = "/s"
EndIf


If $CommandLine = "/c" Then
	
	MsgBox(64, 	$appname & " " & $ver & " " & $build, "Nothing to configure yet, maybe later ;-)" & @CRLF & @CRLF & _
				"Coded in AutoIt by (c) UEZ  " & $build & @CRLF & @CRLF & _
				"Visit  http://www.autoitscript.com/forum  for more stuff :-)",  15)
	Exit
ElseIf $CommandLine = "/p" Then
	Preview_SS()
ElseIf $CommandLine = "/s" Then
	$average_time = 0
	$c = 0
	Start_SS()
EndIf
Exit

Func Preview_SS()
	$width = 152
	$height = 112
	$hGUI = GUICreate($appname, $width, $height, 0, 0, 0x80000000)
	$user32 = DllOpen("user32.dll") 
	DllCall($user32, "int", "SetParent", "hwnd", $hGUI, "hwnd", HWnd($CmdLine[2])) ;set preview window
	DllClose($user32)
	GUISetState(@SW_SHOW)
	Ini_GDI()
	$VirtualDesktopX = 0
	$VirtualDesktopY = 0
	$x = $width
	$y = $height
	$parent_PID = _ProcessGetParent(@AutoItPID)
	While 1
		If Not WinExists($hGUI) Then _Exit()
		$child_PID = _ProcessGetChildren($parent_PID)
		If $child_PID[0] > 1 Then _Exit() ;if another screensaver is selected in ComboBox close ss
		Draw(16)
		Sleep(30)
	WEnd
	_Exit()
EndFunc

Func Start_SS()
	$hGUI = GUICreate($appname, $VirtualDesktopWidth, $VirtualDesktopHeight, $VirtualDesktopX, $VirtualDesktopY, $WS_POPUP, BitOr($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
	$hGUI = WinGetHandle($hGUI)
	GUISetState()
	GUISetCursor(16, 1) ; hide mouse cursor
	$width = $VirtualDesktopWidth
	$height = $VirtualDesktopHeight
	$x = @DesktopWidth
	$y = @DesktopHeight
	Ini_GDI()
	$k = 0
	$i = 1
	While 1
		$new = _IdleTicks()
		If $new < $last Then
			ExitLoop
		EndIf
		$last = $new
		Draw(Round(@DesktopHeight / 40, 0)) ;the higher the y screen resolution is the less squares will be drawn to the screen
	WEnd
	_Exit()
EndFunc

Func Ini_GDI()
	_GDIPlus_Startup ()
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI) ;create graphic
	$Bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
	$GDI_Buffer = _GDIPlus_ImageGetGraphicsContext($Bitmap) ;create buffer
	$Pen_size = 2
	$Pen = _GDIPlus_PenCreate(0xFF000000, $Pen_size)
	$Brush = _GDIPlus_BrushCreateSolid(0xDF000000)
	_GDIPlus_GraphicsClear($GDI_Buffer)
	_GDIPlus_GraphicsSetSmoothingMode($GDI_Buffer, 2)
EndFunc	

Func Draw($density)
;~ 	Local $bench_start = TimerInit()
;~ 	_GDIPlus_GraphicsClear($GDI_Buffer) ;clear buffer
	_GDIPlus_GraphicsFillEllipse($GDI_Buffer, $x / 2 + Abs($VirtualDesktopX) - $k - $Pen_size,  $y / 2 + Abs($VirtualDesktopY) - $k - $Pen_size, 2 * $k + $Pen_size, 2 * $k + $Pen_size, $Brush) ;clear only area where the squares are drawn
	If $k <= 0.42857142857142857142857142857143 * $x  Then $k += 3 ;3 / 7 = 0,42857142857142857142857142857143
	For $j = 8 To $k Step $density + Sin($i * $pi_div_120) * 8
		$red = ((Sin(($j - $i) / 32) + 1) / 2) * 256 	;2^5 = 32
		$green = ((Sin(($j - $i) / 128) + 1) / 2) * 256 ;2^7 = 128
		$blue = ((Sin(($j - $i) / 512) + 1) / 2) * 256 	;2^9 = 512
		_GDIPlus_PenSetColor($Pen, "0xFF" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2)) ;Set the pen color
		$xcoord = $j
		$ycoord = $j
		Square($xcoord, $ycoord, $j * Sin($i / $k * 12.566370614359172953850573533118) * 0.66666666666666666666666666666667, $Pen) ;$Pi * 4 = 12,566370614359172953850573533118
	Next
	_GDIPlus_GraphicsDrawImageRect($hGraphic, $Bitmap, 0, 0, $width, $height) ;copy to bitmap
	$i += 1.5
;~ 	$c += 1
;~ 	Local $bench_end = TimerDiff($bench_start)
;~ 	$average_time += $bench_end
;~ 	If $c >= 1000 Then 
;~ 		$average_time /= $c
;~ 		ConsoleWrite(Round($average_time, 2) & @CRLF)
;~ 		_Exit()
;~ 	EndIf
	Sleep(20)
EndFunc

Func _Exit()
	_GDIPlus_PenDispose($Pen)
	_GDIPlus_BrushDispose($Brush)
	_GDIPlus_BitmapDispose($Bitmap)
	_GDIPlus_GraphicsDispose($GDI_Buffer)
	_GDIPlus_GraphicsDispose ($hGraphic)
	_GDIPlus_Shutdown ()
	Exit
EndFunc

Func Square($xx1, $yy1, $i, $Pen)
    $x1 = $xx1 * Cos(($i + $degree + 0) * $pi_div_180) + $x / 2 + Abs($VirtualDesktopX)
    $y1 = $yy1 * Sin(($i + $degree + 0) * $pi_div_180) + $y / 2 + Abs($VirtualDesktopY)
    $x2 = $xx1 * Cos(($i + $degree + 90) * $pi_div_180) + $x / 2 + Abs($VirtualDesktopX)
    $y2 = $yy1 * Sin(($i + $degree + 90) * $pi_div_180) + $y / 2 + Abs($VirtualDesktopY)
    $x3 = $xx1 * Cos(($i + $degree + 180) * $pi_div_180) + $x / 2 + Abs($VirtualDesktopX)
    $y3 = $yy1 * Sin(($i + $degree + 180) * $pi_div_180) + $y / 2 + Abs($VirtualDesktopY)
    $x4 = $xx1 * Cos(($i + $degree + 270) * $pi_div_180) + $x / 2 + Abs($VirtualDesktopX)
    $y4 = $yy1 * Sin(($i + $degree + 270) * $pi_div_180) + $y / 2 + Abs($VirtualDesktopY)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x1, $y1, $x2, $y2, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x2, $y2, $x3, $y3, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x3, $y3, $x4, $y4, $Pen)
    _GDIPlus_GraphicsDrawLine($GDI_Buffer, $x4, $y4, $x1, $y1, $Pen)
EndFunc

Func _IdleTicks() ; thanks to erifash for the routine
	Local $aTSB = DllCall("kernel32.dll", "long", "GetTickCount")
	Local $ticksSinceBoot = $aTSB[0]
	Local $struct = DllStructCreate("uint;dword")
	DllStructSetData($struct, 1, DllStructGetSize($struct))
	DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($struct))
	Local $ticksSinceIdle = DllStructGetData($struct, 2)
	Return ($ticksSinceBoot - $ticksSinceIdle)
EndFunc ;==>_IdleTicks

Func _ProcessGetParent($i_pid) ;get PID from parent process done by SmOke_N
    Local $TH32CS_SNAPPROCESS = 0x00000002
   
    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
   
    Local $tagPROCESSENTRY32 = _
        DllStructCreate ( _
							"dword dwsize;" & _
							"dword cntUsage;" & _
							"dword th32ProcessID;" & _
							"uint th32DefaultHeapID;" & _
							"dword th32ModuleID;" & _
							"dword cntThreads;" & _
							"dword th32ParentProcessID;" & _
							"long pcPriClassBase;" & _
							"dword dwFlags;" & _
							"char szExeFile[260]" _
									)
    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
   
    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
   
    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
   
    Local $a_pnext, $i_return = 0
    If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_pid Then
        $i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
        DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
        If $i_return Then Return $i_return
        Return $i_pid
    EndIf
   
    While @error = 0
        $a_pnext = DLLCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_pid Then
            $i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
            If $i_return Then ExitLoop
            $i_return = $i_pid
            ExitLoop
        EndIf
    WEnd
   
    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
    Return $i_return
EndFunc

Func _ProcessGetChildren($i_pid) ; First level children processes only done by SmOke_N
    Local Const $TH32CS_SNAPPROCESS = 0x00000002
   
    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_pid)
   
    Local $tagPROCESSENTRY32 = _
        DllStructCreate _
            ( _
                "dword dwsize;" & _
                "dword cntUsage;" & _
                "dword th32ProcessID;" & _
                "uint th32DefaultHeapID;" & _
                "dword th32ModuleID;" & _
                "dword cntThreads;" & _
                "dword th32ParentProcessID;" & _
                "long pcPriClassBase;" & _
                "dword dwFlags;" & _
                "char szExeFile[260]" _
            )
    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))
   
    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
   
    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_pid)
   
    Local $a_pnext, $a_children[11] = [10], $i_child_pid, $i_parent_pid, $i_add = 0
    $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
    If $i_child_pid <> $i_pid Then
        $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
        If $i_parent_pid = $i_pid Then
            $i_add += 1
            $a_children[$i_add] = $i_child_pid
        EndIf
    EndIf
   
    While 1
        $a_pnext = DLLCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
        $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")
        If $i_child_pid <> $i_pid Then
            $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
            If $i_parent_pid = $i_pid Then
                If $i_add = $a_children[0] Then
                    ReDim $a_children[$a_children[0] + 10]
                    $a_children[0] = $a_children[0] + 10
                EndIf
                $i_add += 1
                $a_children[$i_add] = $i_child_pid
            EndIf
        EndIf
    WEnd
   
    If $i_add <> 0 Then
        ReDim $a_children[$i_add + 1]
        $a_children[0] = $i_add
    EndIf
   
    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
    If $i_add Then Return $a_children
    Return SetError(3, 0, 0)
EndFunc
