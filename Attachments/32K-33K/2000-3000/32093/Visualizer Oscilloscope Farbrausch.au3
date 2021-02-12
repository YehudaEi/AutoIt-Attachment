;Coded by UEZ 2010 Build 2010-09-08
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Run_After=del /f /q "Visualizer Oscilloscope Farbrausch_Obfuscated.au3"
#AutoIt3Wrapper_Run_After=upx.exe --ultra-brute "%out%"

#include "Bass.au3"
#include "BassExt.au3"
#include <Color.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>

Opt("MustDeclareVars", 1)
Opt("GUIOnEventMode", 1)

Local $hGUI, $hGraphics, $hBackbuffer, $hBitmap, $hBuffer, $hContext, $timer
Local $hFormat, $hFamily, $hFont, $tLayout, $hBrush_Font, $font_size
Local Const $W = 800, $H = 600
Local Const $W2 = $W / 2, $H2 = $H / 2
Local Const $W6 = $W / 6, $H6 = $H / 6

Local $sFile = FileOpenDialog("Select an audio file", "", "Audio (*.mp3;*.wav)", 1)
If @error Then Exit
Local $mTitle = StringRegExpReplace($sFile, ".+\\(.*)\..*", "$1")

Local $hStream
Sound_Init($sFile)

Local $GUI_title = "GDI+ Visualizer: Oscilloscope Farbrausch by UEZ 2010"
$hGUI = GUICreate($GUI_title, $W, $H)
GUISetBkColor(0x000000, $hGUI)
GUISetState()

; Initialize GDI+
_GDIPlus_Startup()

$hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hBitmap = _GDIPlus_BitmapCreateFromGraphics($W, $H, $hGraphics)
$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
; Using antialiasing
;~ _GDIPlus_GraphicsSetSmoothingMode($hBackbuffer, 2)

; Create a Brush and a Pen object
Local $hPen1 = _GDIPlus_PenCreate(0, 4)
Local $hPen2 = _GDIPlus_PenCreate(0, 2)

GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$hBuffer = _GDIPlus_BitmapCreateFromGraphics($W, $H, $hGraphics)
$hContext = _GDIPlus_ImageGetGraphicsContext($hBuffer)

$hFormat = _GDIPlus_StringFormatCreate ()
$hFamily = _GDIPlus_FontFamilyCreate ("Comic Sans MS")
$font_size = 16
$hFont = _GDIPlus_FontCreate ($hFamily, $font_size, 0)
Local $tLayout = DllStructCreate($tagGDIPRECTF)
DllStructSetData($tLayout, "X", 0)
DllStructSetData($tLayout, "Y", 0)
DllStructSetData($tLayout, "Width", $W)
DllStructSetData($tLayout, "Height", $font_size * 2)
$hBrush_Font = _GDIPlus_BrushCreateSolid(0xF7FFFFFF)

Local $current_pos, $song_length = _BASS_ChannelGetLength($hStream, $BASS_POS_BYTE)
_BASS_ChannelPlay($hStream, 1)

WinSetTitle($hGUI, "", $GUI_title & " / Played: 0.00% / FPS: 0")
AdlibRegister("FPS", 1000)
$timer = TimerInit()

Local $i, $nAngle, $level, $low, $high, $fps, $s, $s2, $s3, $t, $c
Local $aWave, $volume
Local $color1[3]
Local $color2 = $color1
Local $dist1 = $H2 - 40
Local $dist2 = $H2 + 40
Local $speed = 1


Local $hMatrix = _GDIPlus_MatrixCreate()

$timer = TimerInit()

While Sleep(25)
	_GDIPlus_GraphicsDrawImage($hBackbuffer, $hBuffer, 0, 0)

;~ 	$volume = _BASS_GetVolume() * 100

	$level = _BASS_ChannelGetLevel($hStream)
	$high = BitShift($level, 16)
	$low = BitAND($level, 0x0000FFFF)

;~ 	ConsoleWrite($volume & @CRLF)
	$nAngle = Cos($i / 16) / 4

	_GDIPlus_MatrixTranslate($hMatrix, $W2, $H2)
	_GDIPlus_MatrixRotate($hMatrix, $nAngle, 0)
	_GDIPlus_MatrixTranslate($hMatrix, -$W2, -$H2)
	_GDIPlus_GraphicsSetTransform($hBackbuffer, $hMatrix)

	$current_pos = _BASS_ChannelGetPosition($hStream, $BASS_POS_BYTE)

	If $current_pos >= $song_length + 1000 Then _BASS_ChannelPlay($hStream, 1)

	$aWave = _BASS_EXT_ChannelGetWaveformEx($hStream, 512, 	0, $dist1, $W, $H6 + $volume, _
															0, $dist2, $W, $H6 + $volume)

	$color1[0] = Hex(0xF0 * Sin($high) * 4, 2)
	$color1[1] = Hex(0xF0 * -Cos($high) * 4, 2)
	$color1[2] = Hex(0xF0 * Cos($high) * 4, 2)
	_GDIPlus_PenSetColor($hPen1, "0xA0" & Hex(_ColorSetRGB($color1), 6))

	$color2[0] = Hex(Cos($low) * 1024, 2)
	$color2[1] = Hex(Cos($low) * 1024, 2)
	$color2[2] = Hex(Cos($low) * 1024, 2)
	_GDIPlus_PenSetColor($hPen2, "0xA0" & Hex(_ColorSetRGB($color2), 6))

	DllCall($ghGDIPDll, "int", "GdipDrawCurve", "handle", $hBackbuffer, "handle", $hPen1, "ptr", $aWave[0], "int", $aWave[2])
	DllCall($ghGDIPDll, "int", "GdipDrawCurve", "handle", $hBackbuffer, "handle", $hPen2, "ptr", $aWave[1], "int", $aWave[2])

;~ 	_GDIPlus_BrushSetSolidColor($hBrush_Font, "0x10" & Hex(_ColorSetRGB($color1), 6))
;~ 	DllCall($ghGDIPDll, "uint", "GdipFillPolygon", "handle", $hBackbuffer, "handle", $hBrush_Font, "ptr", $aWave[0], "int", $aWave[2], "int", 0)
;~ 	_GDIPlus_BrushSetSolidColor($hBrush_Font, "0xF0" & Hex(_ColorSetRGB($color2), 6))
;~ 	DllCall($ghGDIPDll, "uint", "GdipFillPolygon", "handle", $hBackbuffer, "handle", $hBrush_Font, "ptr", $aWave[1], "int", $aWave[2], "int", 0)


	If TimerDiff($timer) > Random(15000, 25000, 1) Then
		DllStructSetData($tLayout, "X", Random($W2 / 8, $W2, 1))
		DllStructSetData($tLayout, "Y",  Random($H * 0.45, $H * 0.55, 1))
		_GDIPlus_BrushSetSolidColor($hBrush_Font, 0xF7FFFFFF)
		If Mod($i, 4) Then
			_GDIPlus_GraphicsDrawStringEx($hBackbuffer, $mTitle, $hFont, $tLayout, $hFormat, $hBrush_Font)
		Else
			_GDIPlus_GraphicsDrawStringEx($hBackbuffer, "Coded by UEZ 2010 d-|•b", $hFont, $tLayout, $hFormat, $hBrush_Font)
		EndIf
		$timer = TimerInit()
	EndIf

	_GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
	_GDIPlus_GraphicsDrawImageRect($hContext, $hBitmap, -$speed, -$speed, $W + 2 * $speed, $H + 2 * $speed)

;~ 	ConsoleWrite($volume & @CRLF)
	$speed += Sin($i / 8) * 1.5
	$i += 1
	$fps += 1
WEnd


Func Sound_Init($sFile)
	_BASS_Startup(@ScriptDir & "\Bass.dll")
	If @error Then Exit MsgBox(16, "ERROR!", "Bass.DLL was not found!", 20)
	_BASS_EXT_Startup(@ScriptDir & "\BassExt.dll")
	If @error Then Exit MsgBox(16, "ERROR!", "BassExt.DLL was not found!", 20)
	_BASS_Init(0, -1, 44100, 0, "")
	$hStream = _BASS_StreamCreateFile(False, $sFile, 0, 0, $BASS_SAMPLE_FLOAT)
EndFunc

Func Sound_Exit()
	_BASS_Stop()
	_BASS_StreamFree($hStream)
	_BASS_Free()
EndFunc

Func FPS()
	WinSetTitle($hGUI, "", $GUI_title & " / Played: " &  StringFormat("%.2f", 100 * $current_pos / $song_length)  & "% / FPS: " & $fps)
	$fps = 0
EndFunc

Func _Exit()
	Sound_Exit()
	AdlibUnRegister("FPS")
	; Clean up
;~ 	_GDIPlus_ImageAttributesDispose($hIA)
	_GDIPlus_MatrixDispose($hMatrix)
    _GDIPlus_FontDispose ($hFont)
    _GDIPlus_FontFamilyDispose ($hFamily)
    _GDIPlus_StringFormatDispose ($hFormat)
	_GDIPlus_BrushDispose($hBrush_Font)
	_GDIPlus_PenDispose($hPen1)
	_GDIPlus_PenDispose($hPen2)
	_GDIPlus_BitmapDispose($hBuffer)
	_GDIPlus_GraphicsDispose($hContext)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_GraphicsDispose($hBackbuffer)
	_GDIPlus_GraphicsDispose($hGraphics)

	; Uninitialize GDI+
	_GDIPlus_Shutdown()
	GUIDelete($hGUI)
	Exit
EndFunc