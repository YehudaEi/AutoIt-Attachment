;coded by UEZ 2009-01-12
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/SO
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
Opt('MustDeclareVars', 1)

Global $hGUI, $hGraphic, $Bitmap, $GDI_Buffer, $Brush
Global $starting_point, $i, $j, $k, $red, $green, $blue, $r

Global Const $Pi = 3.1415926535897932384626
Global Const $width = 450
Global Const $height = 250


$hGUI = GUICreate("GDI+: Plasma by UEZ 2009", $width, $height)
GUISetState(@SW_SHOW)


_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI) ;create graphic
$Bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
$GDI_Buffer = _GDIPlus_ImageGetGraphicsContext($Bitmap) ;create buffer
$Brush = _GDIPlus_BrushCreateSolid(0)
;~ _GDIPlus_GraphicsSetSmoothingMode($GDI_Buffer, 1)
_GDIPlus_GraphicsClear($GDI_Buffer) ;clear buffer

$r = 0
Global $square_x = 8
Global $square_y = 16
Do
    $r += ATan(-0.007)
    For $i = 1 To $height Step $square_y
        For $j = 1 To $width Step $square_x
            $red = ((-Sin(3 * ($j - $square_y) * 0.001953125) - $r + 1) * 0.5) * 256
            $green = $red * ((-Cos(2 * ($i - $square_y) * 0.001953125) - $r + 1) * 0.5) * 256
            $blue = $blue * ((Sin(2 * ($j - $square_y) * 0.001953125) + $r + 1) * 0.5) * 256
            _GDIPlus_BrushSetSolidColor($Brush, "0x0f" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
            _GDIPlus_GraphicsFillRect($GDI_Buffer, $j, $i, $square_x, $square_y, $Brush)
;~ 			_GDIPlus_GraphicsFillEllipse($GDI_Buffer, $j, $i, $square_x, $square_y, $Brush)
        Next
    Next
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $Bitmap, 0, 0, $width, $height) ;copy to bitmap
;~     Sleep(1)
Until GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
_GDIPlus_BrushDispose($Brush)
_GDIPlus_GraphicsDispose($GDI_Buffer)
_GDIPlus_BitmapDispose($Bitmap)
_GDIPlus_GraphicsDispose ($hGraphic)
_GDIPlus_Shutdown ()


; #FUNCTION# ====================================================================
; Name...........: _GDIPlus_BrushSetSolidColor
; Description ...: Set the color of a Solid Brush object
; Syntax.........: _GDIPlus_BrushSetSolidColor($hBrush, [$iARGB = 0xFF000000])
; Parameters ....: $hBrush      - Handle to a Brush object
;                  $iARGB       - Alpha, Red, Green and Blue components of brush
; Return values .: Success      - True
;                  Failure      - False
; Author ........:
; Modified.......: smashly
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ GdipSetSolidFillColor
; Example .......; Yes
; ================================================================================
Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
    Local $aResult

    $aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
;~     If @error Then Return SetError(@error, @extended, 0)
;~     Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor