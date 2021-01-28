;coded by UEZ 2009
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/sf /sv /om /cs=0 /cn=0
#AutoIt3Wrapper_Res_SaveSource=n
#AutoIt3Wrapper_Run_After=upx.exe --best "%out%"
;~ #AutoIt3Wrapper_run_after=upx.exe --ultra-brute "%out%" ;very slow
#AutoIt3Wrapper_run_after=del "Plasma Variante_Obfuscated.au3"

#include <GuiConstantsEx.au3>
#include <GDIPlus.au3>
#include <GuiButton.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)

Global $hGUI, $hGraphic, $Bitmap, $GDI_Buffer, $Brush
Global $starting_point, $i, $j, $k, $red, $green, $blue
Global Const $width = @DesktopWidth / 3
Global Const $height = @DesktopHeight / 3.5
Global $side_length = 110

$hGUI = GUICreate("GDI+: Plasma Variant Beta by UEZ 2009", $width, $height)
Global $button = _GUICtrlButton_Create($hGUI, "Update", 10, $height - 60, 90, 50)
Global $square_x = 40
Global $square_y = 40
Global $r = 0
Global $c = 0.75
Global $rdm = 0.075
GUICtrlCreateLabel("Square x size:", 4, 12)
GUICtrlCreateLabel("Square y size:", 4, 32)
GUICtrlCreateLabel("Color value:", 4, 52)
Global $input_x = GUICtrlCreateInput("" & $square_x, 72, 10, $side_length - 77, -1, $SS_CENTER)
GUICtrlSetTip(-1, "The lower the value the more CPU is used!")
Global $input_y = GUICtrlCreateInput("" & $square_y, 72, 30, $side_length - 77, -1, $SS_CENTER)
GUICtrlSetTip(-1, "The lower the value the more CPU is used!")
Global $input_c = GUICtrlCreateInput("" & $c, 72, 50, $side_length - 77, -1, $SS_CENTER)
GUISetState(@SW_SHOW)

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

_GDIPlus_Startup ()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI) ;create graphic
$Bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $hGraphic) ;create bitmap
$GDI_Buffer = _GDIPlus_ImageGetGraphicsContext($Bitmap) ;create buffer
$Brush = _GDIPlus_BrushCreateSolid(0)
_GDIPlus_GraphicsClear($GDI_Buffer) ;clear buffer

Global $update = False

Do
    $r -= -$c * Sin(Random(-$rdm, $rdm)) / Cos(Random(-$rdm, $rdm) * $r)
    For $i = -$square_y To $height Step $square_y + Random(-$square_y * 0.5, $square_y * 0.75)
        For $j = -$square_x To $width Step $square_x + Random(-$square_x * 0.5, $square_x * 0.75)
            If $update Then ExitLoop
            $red = ((-Sin(3 * ($j - $square_y) * 0.001953125) - $r + 1) * 0.5) * 256
            $green = $red * ((-Cos(2 * ($i - $square_y) * 0.001953125) - $r + 1) * 0.5) * 256
            $blue *= ((Sin(2 * ($j - $square_y) * 0.001953125) + $r + 1) * 0.5) * 256
            _GDIPlus_BrushSetSolidColor($Brush, "0xf" & Hex($red, 2) & Hex($green, 2) & Hex($blue, 2))
            _GDIPlus_GraphicsFillRect($GDI_Buffer, $j, $i, $square_x, $square_y, $Brush)
        Next
        If $update Then ExitLoop
    Next
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $Bitmap, $side_length, 0, $width, $height) ;copy to bitmap
    If $update Then
        $update = False
        If GUICtrlRead($input_x) > 0 Then $square_x = GUICtrlRead($input_x)
        If GUICtrlRead($input_y) > 0 Then $square_y = GUICtrlRead($input_y)
		$c = GUICtrlRead($input_c)
    EndIf
    Sleep(1)
Until GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
_GDIPlus_BrushDispose($Brush)
_GDIPlus_GraphicsDispose($GDI_Buffer)
_GDIPlus_BitmapDispose($Bitmap)
_GDIPlus_GraphicsDispose ($hGraphic)
_GDIPlus_Shutdown ()

Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
    Local $aResult
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor

; React on a button click
Func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
    #forceref $hWnd, $Msg
    Local $nNotifyCode = BitShift($wParam, 16)
    Local $nID = BitAND($wParam, 0x0000FFFF)
    Local $hCtrl = $lParam
    Switch $hCtrl
        Case $button
            Switch $nNotifyCode
                Case $BN_CLICKED
                    $update = True
            EndSwitch
            Return 0 ; Only workout clicking on the button
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND
