#AutoIt3Wrapper_OutFile=GDI+ 3D Star Scrolling Screensaver.scr
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "%scriptdir%\%scriptfile%_Obfuscated.au3"
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Description=Simple Screensaver made by UEZ 2011
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Res_Field=Version|1.0.0
#AutoIt3Wrapper_Res_Field=Build|2012-02-10
#AutoIt3Wrapper_Res_Field=Coded by|UEZ
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Run_After=upx.exe --best --lzma "%out%"
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6

#include <EditConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <SliderConstants.au3>
#include <StaticConstants.au3>
#include <Timers.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

Opt("GUIOnEventMode", 1)
Opt("MustDeclareVars", 1)

_Singleton(@AutoItExe)

Global Const $app_name = "GDI+ 3D Star Scrolling Screensaver by UEZ 2011"
Global Const $ver = "v1.0 build 2012-02-10"
Global $hGUI, $iW, $iH, $GUI_H, $GUI_W, $GUI_X, $GUI_Y, $r, $show_FPS = 0
Global $maxStars = 150, $size = 1
Global $parent_pid, $aChildProcess
Global Const $hFullScreen = WinGetHandle("Program Manager")
Global Const $aFullScreen = WinGetPos($hFullScreen)
Global $main_screen_x = Abs($aFullScreen[0])
Global Const $ini_file = @ScriptDir & "\GDI+ 3D Star Scrolling Screensaver.ini"
If FileExists($ini_file) Then
	$show_FPS = Int(IniRead($ini_file, "Settings", "ShowFPS", 0))
	$maxStars = Int(IniRead($ini_file, "Settings", "MaxStars", 150))
EndIf

Global $cmdparam = "/s"
If $CmdLine[0] Then $cmdparam = StringLeft($CmdLine[1], 2)

Switch $cmdparam
	Case "/s"
		$iW = @DesktopWidth
		$iH = @DesktopHeight
		$GUI_X = $aFullScreen[0]
		$GUI_Y = $aFullScreen[1]
		$GUI_W = $aFullScreen[2]
		$GUI_H = $aFullScreen[3]
		$r = (($iW + $iH) / 2) / 0x300
		$hGUI = GUICreate($app_name, $GUI_W, $GUI_H, $GUI_X, $GUI_Y, $WS_POPUP, $WS_EX_TOPMOST)
	Case "/c"
		Opt("GUIOnEventMode", 0)
		Global Const $hGUI_Settings = GUICreate("Settings", 514, 108, -1, -1, -1, BitOR($WS_EX_TOOLWINDOW, $WS_EX_WINDOWEDGE))
		Global Const $Label = GUICtrlCreateLabel("Amount of stars:", 8, 18, 100, 20)
		GUICtrlSetFont(-1, 12, 400, 0, "Times New Roman")
		Global Const $Slider = GUICtrlCreateSlider(112, 8, 342, 45, BitOR($GUI_SS_DEFAULT_SLIDER, $TBS_BOTH, $TBS_TOOLTIPS))
		GUICtrlSetLimit(-1, 500, 10)
		GUICtrlSetData(-1, $maxStars)
		GUICtrlSetTip(-1, "Set amount of stars to be displayed")
		Global Const $Checkbox = GUICtrlCreateCheckbox("Enable FPS Counter", 8, 70, 130, 17)
		GUICtrlSetFont(-1, 11, 400, 0, "Times New Roman")
		If $show_FPS Then GUICtrlSetState($Checkbox, $GUI_CHECKED)
		Global Const $Input = GUICtrlCreateInput(GUICtrlRead($Slider), 456, 16, 41, 27, BitOR($GUI_SS_DEFAULT_INPUT, $ES_CENTER, $ES_NUMBER, $ES_READONLY))
		GUICtrlSetFont(-1, 12, 400, 0, "Times New Roman")
		Global Const $Button_OK = GUICtrlCreateButton("Apply", 424, 70, 75, 25)
		GUICtrlSetFont(-1, 12, 400, 0, "Times New Roman")
		Global Const $Button_Cancel = GUICtrlCreateButton("Cancel", 336, 70, 75, 25)
		GUICtrlSetFont(-1, 12, 400, 0, "Times New Roman")
		Global Const $Label_Ver = GUICtrlCreateLabel($app_name & @CRLF & $ver, 150, 70, 170, 20)
		GUICtrlSetFont(-1, 6, 400, 0, "Times New Roman")
		GUISetState(@SW_SHOW, $hGUI_Settings)
		Global $nMsg

		While 1
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE, $Button_Cancel
					GUIDelete($hGUI_Settings)
					Exit
				Case $Button_OK
					IniWrite($ini_file, "Settings", "ShowFPS", BitAND(GUICtrlRead($Checkbox), $GUI_CHECKED))
					IniWrite($ini_file, "Settings", "MaxStars", GUICtrlRead($Slider))
					GUIDelete($hGUI_Settings)
					Exit
				Case $Slider
					GUICtrlSetData($Input, GUICtrlRead($Slider))
			EndSwitch
		WEnd

	Case "/p"
		$iW = 152
		$iH = 112
		$GUI_X = 0
		$GUI_Y = 0
		$GUI_W = $iW
		$GUI_H = $iH
		$main_screen_x  = 0
		$r = (($iW + $iH) / 2) / 0x30
		$show_FPS = False
		$maxStars = 30
		$size = 1
		$hGUI = GUICreate("GDI+ 3D Star Scrolling  Screensaver by UEZ", $GUI_W, $GUI_H, $GUI_X, $GUI_Y, $WS_POPUP)
		_WinAPI_SetParent($hGUI, $CmdLine[2])
		$parent_pid = _WinAPI_GetParentProcess(@AutoItPID)
EndSwitch

_GDIPlus_Startup()

Global Const $iW2 = $iW / 2
Global Const $iH2 = $iH / 2

GUISetBkColor(0x000000, $hGUI)
GUISetState(@SW_SHOW, $hGUI)

Global Const $hBitmap = _WinAPI_CreateDIB($iW, $iH)
Global Const $hDC = _WinAPI_GetWindowDC($hGUI)
Global Const $hDC_backbuffer = _WinAPI_CreateCompatibleDC($hDC)
Global Const $DC_obj = _WinAPI_SelectObject($hDC_backbuffer, $hBitmap)
Global Const $hGraphic = _GDIPlus_GraphicsCreateFromHDC($hDC_backbuffer)

Global Const $hPen = _GDIPlus_PenCreate(0, $size)
Global Const $hBrush = _GDIPlus_BrushCreateSolid(0xE0000000)
Global Const $hBrush_Text = _GDIPlus_BrushCreateSolid(0xFFF0F0F0)
Global Const $hFormat = _GDIPlus_StringFormatCreate()
Global Const $hFamily = _GDIPlus_FontFamilyCreate("Arial")
Global Const $hFont = _GDIPlus_FontCreate($hFamily, 12)
Global Const $tLayout = _GDIPlus_RectFCreate($iW - 32, 0, 0, 0)

Global Const $speed = 50

Global $aStars[$maxStars][3], $j
For $j = 0 To $maxStars - 1
	NewStars($j)
Next

Global Const $om = MouseGetCursor()
Global $idle_o, $idle_n, $fps = 0, $newx, $newy, $c, $i
Global $fps2 = 0

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

OnAutoItExitRegister("_Exit")
AdlibRegister("FPS", 1000)

While Sleep(10)
	Draw_Stars()
WEnd

Func FPS()
	$fps = $fps2
	$fps2 = 0
EndFunc   ;==>FPS

Func Draw_Stars()
	If $cmdparam = "/s" Then
		GUISetCursor(16, 1, $hGUI)
		$idle_n = _Timer_GetIdleTime()
		If $idle_n < $idle_o Then _Exit()
		$idle_o = $idle_n
	Else
		If Not BitAND(WinGetState($hGUI), 2) Then _Exit()
		$aChildProcess = _WinAPI_EnumChildProcess($parent_pid)
		If $aChildProcess[0][0] > 1 Then _Exit()
	EndIf
	_GDIPlus_GraphicsFillRect($hGraphic, 0, 0, $iW, $iH, $hBrush)
	While $j < $maxStars
		$aStars[$j][0] += $aStars[$j][0] / $speed
		$aStars[$j][1] += $aStars[$j][1] / $speed
		$aStars[$j][2] += $r
		$newx = $aStars[$j][0] + $iW2
		$newy = $aStars[$j][1] + $iH2
		$c = Hex(Int(Min($aStars[$j][2], 0xFF)), 2)
		_GDIPlus_PenSetColor($hPen, "0xFF" & $c & $c & $c)
		_GDIPlus_GraphicsDrawRect($hGraphic, $newx, $newy, 1, 1, $hPen)
		If $newx < 0 Or $newx > $iW Or $newy < 0 Or $newy > $iH Then NewStars($j, $iW2 * Random(0.75, 1.25), $iH2 * Random(0.75, 1.25), $iW2 * Random(0.75, 1.25), $iH2 * Random(0.75, 1.25))
		If $newx < 0 Or $newx > $iW Or $newy < 0 Or $newy > $iH Then NewStars($j, $iW2 * _Random(0.75, 1.25, 0.95, 1.05), $iH2 * _Random(0.75, 1.25, 0.95, 1.05), $iW2 * _Random(0.75, 1.25, 0.95, 1.05), $iH2 * _Random(0.75, 1.25, 0.95, 1.05))
		$j += 1
	WEnd
	$j = 0
	If $show_FPS Then _GDIPlus_GraphicsDrawStringEx($hGraphic, $fps, $hFont, $tLayout, $hFormat, $hBrush_Text)
	_WinAPI_BitBlt($hDC, $main_screen_x, 0, $iW, $iH, $hDC_backbuffer, 0, 0, $SRCCOPY)
	$fps2 += 1
EndFunc   ;==>Draw_Stars

Func NewStars($i, $sx = 0, $sy = 0, $ex = $iW, $ey = $iH)
	$aStars[$i][0] = Random($sx, $ex, 1) - $iW2
	$aStars[$i][1] = Random($sy, $ey, 1) - $iH2
	$aStars[$i][2] = 0x00
EndFunc   ;==>NewStars

Func Min($a, $b)
	If $a < $b Then Return $a
	Return $b
EndFunc   ;==>Min

Func _Random($min, $max, $emin, $emax, $int = 0) ;exludes from emin to emax
	Local $r1 = Random($min, $emin, $int)
	Local $r2 = Random($emax, $max, $int)
	If Random(0, 1, 1) Then Return $r1
	Return $r2
EndFunc   ;==>_Random

Func _Exit()
	AdlibUnRegister("FPS")
	GUISetCursor($om, 1, $hGUI)
	_GDIPlus_FontDispose($hFont)
	_GDIPlus_FontFamilyDispose($hFamily)
	_GDIPlus_StringFormatDispose($hFormat)
	_GDIPlus_PenDispose($hPen)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BrushDispose($hBrush_Text)

	_GDIPlus_GraphicsDispose($hGraphic)
	_WinAPI_SelectObject($hDC, $DC_obj)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_ReleaseDC($hGUI, $hDC)

	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc   ;==>_Exit

#region WinAPIEx.au3 by Yashied
Func _WinAPI_GetParentProcess($PID = 0)
	If Not $PID Then
		$PID = _WinAPI_GetCurrentProcessID()
		If Not $PID Then Return SetError(1, 0, 0)
	EndIf

	Local $hSnapshot = DllCall('kernel32.dll', 'ptr', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If (@error) Or (Not $hSnapshot[0]) Then Return SetError(1, 0, 0)

	Local $tPROCESSENTRY32 = DllStructCreate('dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]')
	Local $pPROCESSENTRY32 = DllStructGetPtr($tPROCESSENTRY32)
	Local $Ret, $Result = 0

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	$Ret = DllCall('kernel32.dll', 'int', 'Process32FirstW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	While (Not @error) And ($Ret[0])
		If DllStructGetData($tPROCESSENTRY32, 'ProcessID') = $PID Then
			$Result = DllStructGetData($tPROCESSENTRY32, 'ParentProcessID')
			ExitLoop
		EndIf
		$Ret = DllCall('kernel32.dll', 'int', 'Process32NextW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	WEnd
	_WinAPI_CloseHandle($hSnapshot)
	If Not $Result Then Return SetError(1, 0, 0)
	Return $Result
EndFunc   ;==>_WinAPI_GetParentProcess

Func _WinAPI_EnumChildProcess($PID = 0)
	If Not $PID Then
		$PID = _WinAPI_GetCurrentProcessID()
		If Not $PID Then Return SetError(1, 0, 0)
	EndIf

	Local $hSnapshot = DllCall('kernel32.dll', 'ptr', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If (@error) Or (Not $hSnapshot[0]) Then Return SetError(1, 0, 0)

	Local $tPROCESSENTRY32 = DllStructCreate('dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]')
	Local $pPROCESSENTRY32 = DllStructGetPtr($tPROCESSENTRY32)
	Local $Ret, $Result[101][2] = [[0]]

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	$Ret = DllCall('kernel32.dll', 'int', 'Process32FirstW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	While (Not @error) And ($Ret[0])
		If DllStructGetData($tPROCESSENTRY32, 'ParentProcessID') = $PID Then
			$Result[0][0] += 1
			If $Result[0][0] > UBound($Result) - 1 Then
				ReDim $Result[$Result[0][0] + 100][2]
			EndIf
			$Result[$Result[0][0]][0] = DllStructGetData($tPROCESSENTRY32, 'ProcessID')
			$Result[$Result[0][0]][1] = DllStructGetData($tPROCESSENTRY32, 'ExeFile')
		EndIf
		$Ret = DllCall('kernel32.dll', 'int', 'Process32NextW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	WEnd
	_WinAPI_CloseHandle($hSnapshot)
	If $Result[0][0] Then
		ReDim $Result[$Result[0][0] + 1][2]
	Else
		Return SetError(1, 0, 0)
	EndIf
	Return $Result
EndFunc   ;==>_WinAPI_EnumChildProcess

Func _WinAPI_CreateDIB($iWidth, $iHeight, $iBitsPerPel = 32)
	Local $tBIHDR, $hBitmap, $pBits
	Local Const $BI_RGB = 0, $DIB_RGB_COLORS = 0
	Local Const $tagBITMAPINFOHEADER = 'dword biSize;long biWidth;long biHeight;ushort biPlanes;ushort biBitCount;dword biCompression;dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;dword biClrUsed;dword biClrImportant'
	$tBIHDR = DllStructCreate($tagBITMAPINFOHEADER)
	DllStructSetData($tBIHDR, 'biSize', DllStructGetSize($tBIHDR))
	DllStructSetData($tBIHDR, 'biWidth', $iWidth)
	DllStructSetData($tBIHDR, 'biHeight', $iHeight)
	DllStructSetData($tBIHDR, 'biPlanes', 1)
	DllStructSetData($tBIHDR, 'biBitCount', $iBitsPerPel)
	DllStructSetData($tBIHDR, 'biCompression', $BI_RGB)
	$hBitmap = _WinAPI_CreateDIBSection(0, $tBIHDR, $DIB_RGB_COLORS, $pBits)
	If @error Then Return SetError(1, 0, 0)
	Return $hBitmap
EndFunc   ;==>_WinAPI_CreateDIB

Func _WinAPI_CreateDIBSection($hDC, ByRef $tBITMAPINFO, $iUsage, ByRef $pBits, $hSection = 0, $iOffset = 0)
	$pBits = 0
	Local $Ret = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', $hDC, 'ptr', DllStructGetPtr($tBITMAPINFO), 'uint', $iUsage, 'ptr*', 0, 'ptr', $hSection, 'dword', $iOffset)
	If @error Or (Not $Ret[0]) Then Return SetError(1, 0, 0)
	$pBits = $Ret[4]
	Return $Ret[0]
EndFunc   ;==>_WinAPI_CreateDIBSection
#endregion