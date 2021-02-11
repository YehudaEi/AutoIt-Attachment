;Idea taken from http://js1k.com/demo/434
;Ported to AutoIt by UEZ Build 2010-09-04
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Suspended Cloth Simulation_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"
;~ #AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
;~ #include <Array.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode", 2)

HotKeySet("{F5}", "Init") ;restart
HotKeySet("{F6}", "Gravity") ;turn on/off gravity

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap
Local Const $iX = Int(@DesktopWidth * 0.66), $iY = Int($iX * 10 / 16)

; Initialize GDI+
_GDIPlus_Startup()

Local $GUI_title = "GDI+ Suspended Cloth Simulation by UEZ"
$hGUI = GUICreate($GUI_title &  " / FPS: 0", $iX, $iY)
GUISetState()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($iX, $iY, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
; Using antialiasing
_GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)


; Create a Brush / Pen object
Local $hBrush = _GDIPlus_BrushCreateSolid()
Local $hPen = _GDIPlus_PenCreate(0xFF000000, 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

Local Const $f = 10
Local Const $ff = $f ^ 2
Local $k[$f][$f][5] ;3D array: f,f,px,py,m,k,j
Local $l[$f ^ 2 + ($f - 1) ^ 2][4]
Local $r = 0.00125
Local $o = 1
Local $y = 0.05
Local $z = 0
Local Const $u = 0.08
Local Const $gg = $iX * 1.20 ;size x squares
Local Const $jj = $iY * 0.95 ;size y squares
Local $x, $h, $i, $fps

Init()

GUIRegisterMsg(0x0200, "Mouse")
AdlibRegister("FPS", 1000)

While Sleep(20)
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	Simulate()
	_GDIPlus_GraphicsDrawImageRect($hGraphics, $hBitmap, 0, 0, $iX, $iY)
	$fps += 1
WEnd

Func Simulate()
	Local $nx, $ny, $a, $s, $t, $dx, $dy, $de, $di
	Local $x1, $y1, $x2, $y2, $spm, $tpm, $spx, $spy, $tpx, $tpy
	Local $pm, $px, $py, $pk, $pj
	For $h = 0 To $f - 1
		For $i = 0 To $f -1
			$pm = $k[$h][$i][2]
			If $pm <> 0 Then
				$px = $k[$h][$i][0]
				$py = $k[$h][$i][1]
				$pk = $k[$h][$i][3]
				$pj = $k[$h][$i][4]
				$nx = $px * 2 - $pk
				$ny = $py * 2 - $pj + $r
				$k[$h][$i][3] = $px
				$k[$h][$i][4] = $py
				$k[$h][$i][0] = $nx
				$k[$h][$i][1] = $ny
			EndIf
		Next
	Next
	For $h = 0 To 1
		For $i = 0 To UBound($l) - 1
			$tpm = $k[$l[$i][2]][$l[$i][3]][2]
			$tpx = $k[$l[$i][2]][$l[$i][3]][0]
			$tpy = $k[$l[$i][2]][$l[$i][3]][1]
			$spm = $k[$l[$i][0]][$l[$i][1]][2]
			$spx = $k[$l[$i][0]][$l[$i][1]][0]
			$spy = $k[$l[$i][0]][$l[$i][1]][1]
			$dx = $tpx - $spx
			$dy = $tpy - $spy
			$de = $dx * $dx + $dy * $dy
			$di = ($de - 0.0064) / ((0.0064 + $de) * ($spm + $tpm))
			If $spm <> 0 Then
				$k[$l[$i][0]][$l[$i][1]][0] += $dx * $di
				$k[$l[$i][0]][$l[$i][1]][1] += $dy * $di
			EndIf
			If $tpm <> 0 Then
				$k[$l[$i][2]][$l[$i][3]][0] -= $dx * $di
				$k[$l[$i][2]][$l[$i][3]][1] -= $dy * $di
			EndIf
		Next
	Next
	For $i = 0 To UBound($l) - 1
		$spx = $k[$l[$i][0]][$l[$i][1]][0]
		$spy = $k[$l[$i][0]][$l[$i][1]][1]
		$tpx = $k[$l[$i][2]][$l[$i][3]][0]
		$tpy = $k[$l[$i][2]][$l[$i][3]][1]
		$x1 = $spx * $gg
		$y1 = $spy * $jj
		$x2 = $tpx * $gg
		$y2 = $tpy * $jj
		_GDIPlus_GraphicsDrawLine($hBackbuffer, $x1, $y1, $x2, $y2, $hPen)
	Next
EndFunc

Func Gravity() ;turn on/off gravity by pressing space bar
	If $r == 0 Then
		$r = 0.00125
		$o = 0
	Else
		$r = 0
		$o = 1
	EndIf
EndFunc

Func Init()
	$r = 0.00125
	$o = 1
	$y = 0.05
	$z = 0
	For $h = 0 To $f - 1
		$x = 0.05
		For $i = 0 To $f - 1
			$k[$h][$i][0] = $x * Random(0.975, 1.025)	;px
			$k[$h][$i][1] = $y * 0.95	;py
			$k[$h][$i][2] = 1			;m
			$k[$h][$i][3] = $x			;k
			$k[$h][$i][4] = $y			;j
			If $h > 0 Then
				$l[$z][0] = $h - 1
				$l[$z][1] = $i
				$l[$z][2] = $h
				$l[$z][3] = $i
				$z += 1
			EndIf
			If $i > 0 Then
				$l[$z][0] = $h
				$l[$z][1] = $i - 1
				$l[$z][2] = $h
				$l[$z][3] = $i
				$z += 1
			EndIf
			$x += $u
		Next
		$y += $u
	Next
	$k[0][0][2] = 0
	$k[0][$f - 1][2] = 0
EndFunc

Func Mouse($hWnd, $Msg, $wParam, $lParam)
	Local $mpos
	If WinActive($hGUI) And $wParam Then
		$mpos = MouseGetPos()
		$k[$f - 1][$f - 1][0] = $mpos[0] / $gg
		$k[$f - 1][$f - 1][1] = $mpos[1] / $jj
;~ 		$k[$f -1][$f - 1][2] = 1
;~ 		$k[$f -1][$f - 1][3] = $k[$f - 1][$f - 1][0]
;~ 		$k[$f -1][$f - 1][4] = $k[$f - 1][$f - 1][1]
	EndIf
	Return "GUI_RUNDEFMSG"
EndFunc

Func FPS()
	WinSetTitle($hGUI, "", $GUI_title & " / FPS: " & $fps)
	$fps = 0x00000000
EndFunc

Func _Exit()
	$k = 0
	$l = 0
	AdlibUnRegister("FPS")
	; Clean up
	_GDIPlus_BrushDispose($hPen)
	_GDIPlus_BrushDispose($hBrush)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	Exit
EndFunc