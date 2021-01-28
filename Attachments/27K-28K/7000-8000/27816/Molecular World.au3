;coded by UEZ 2009
#include <GUIConstantsEx.au3>
#include <GDIplus.au3>
#include <WindowsConstants.au3>
#include <Array.au3>

HotKeySet("{F5}", "Initialize")

Global Const $width = @DesktopWidth / 3
Global Const $height = @DesktopHeight / 3

Opt("GUIOnEventMode", 1)
Global $hwnd = GUICreate("GDI+: Molecular World by UEZ'09 (Press F5 to Refresh) - Alpha Version!", $width, $height, -1, -1, Default, BitOR($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetOnEvent($GUI_EVENT_CLOSE, "close")
GUISetState()

_GDIPlus_Startup()
Global $graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
Global $bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
Global $backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_GDIPlus_GraphicsClear($backbuffer)
_GDIPlus_GraphicsSetSmoothingMode($backbuffer, 4)

Global $pen_size = 1
Global $pen_color = 0x7F7F7F7F
Global $pen = _GDIPlus_PenCreate($pen_color, $pen_size)
;~ _GDIPlus_PenSetColor($pen, $pen_color)
Global $brush_color
Global $brush = _GDIPlus_BrushCreateSolid()
_GDIPlus_BrushSetSolidColor($brush, $brush_color)

Global $pixel_distance_threshold = 40
Global $pixel_min_distance = 15
Global $max_dots = 15
Global $max_speed = 10
Global $iWidth = 6
Global $iHeight = 6
Global $mx, $my, $d, $n_x, $n_y, $pd, $dot_count
Dim $coordinates[$max_dots][7 + 3 * $max_dots]
Dim $brush[$max_dots]

Initialize()

Do
    _GDIPlus_GraphicsClear($backbuffer, 0xFF000000)
    Draw_Dots()
    Calculate_New_Position()
    _GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)
    Sleep(5)
Until False

Func Initialize()
    For $k = 0 To $max_dots - 1
        $r = Random(64, 255, 1)
        $g = Random(64, 255, 1)
        $b = Random(64, 255, 1)
        $brush_color = "0xAF" & Hex($r, 2) & Hex($g, 2) & Hex($b, 2)
        $brush[$k] = _GDIPlus_BrushCreateSolid($brush_color)
        New_Coordinates($k)
    Next
EndFunc   ;==>Initialize

Func Draw_Dots()
    Local $i, $temp_x, $temp_y
    For $i = 0 To $max_dots - 1
        Find_Neighbour($coordinates[$i][0], $coordinates[$i][1], $i)
        $pd = Pixel_Distance($coordinates[$i][0], $coordinates[$i][1], $n_x, $n_y)
        If $pd <= $pixel_distance_threshold + $iWidth / 2 And $pd >= $pixel_min_distance + $iWidth / 2 Then
            Draw_Lines($i)
            $k = 0
;~             _GDIPlus_BrushSetSolidColor($brush[$i], "0xFF" & Hex(Random(10, 255, 1), 2) & Hex(Random(10, 255, 1), 2) & Hex(Random(10, 255, 1), 2))
            While $coordinates[$i][7 + $k] <> 0
                If $coordinates[$i][5] = 0 Then $coordinates[$i][5] = Random(-10, 10)
                $coordinates[$i][5] += ($coordinates[$coordinates[$i][7 + $k]][5])
                If $coordinates[$i][6] = 0 Then $coordinates[$i][5] = Random(-10, 10)
                $coordinates[$i][6] += ($coordinates[$coordinates[$i][7 + $k]][6])
;~                 $coordinates[$coordinates[$i][7 + $k]][5] *= -$coordinates[$i][5] * 20
;~                 $coordinates[$coordinates[$i][7 + $k]][6] *= -$coordinates[$i][6] * 20
                $k += 3
            WEnd
            $coordinates[$i][5] *= 0.9
            $coordinates[$i][6] *= 0.9
            $coordinates[$dot_count][5] += $coordinates[$i][6] * 0.025
            $coordinates[$dot_count][6] += $coordinates[$i][5] * 0.025

        ElseIf $pd <= $pixel_min_distance + $iWidth / 2 And $pd > $iWidth / 2 + 1 Then
            Draw_Lines($i)
            $coordinates[$dot_count][5] += Sin($coordinates[$i][5]) * 0.010
            $coordinates[$dot_count][6] += Cos($coordinates[$i][6]) * 0.010
            $coordinates[$i][5] += Sin($coordinates[$dot_count][5]) * - 0.010
            $coordinates[$i][6] += Cos($coordinates[$dot_count][6]) * - 0.010
        ElseIf $pd <= $iWidth Then
            $temp_x = $coordinates[$i][5]
            $temp_y = $coordinates[$i][6]
            $coordinates[$i][5] = (-$coordinates[$i][5] + $coordinates[$dot_count][5]) / 2
            $coordinates[$i][6] = (-$coordinates[$i][6] + $coordinates[$dot_count][6]) / 2
            $coordinates[$dot_count][5] = (-$coordinates[$dot_count][5] + $temp_x) / 2
            $coordinates[$dot_count][6] = (-$coordinates[$dot_count][6] + $temp_y) / 2
        EndIf
        _GDIPlus_GraphicsFillEllipse($backbuffer, $coordinates[$i][0], $coordinates[$i][1], $iWidth, $iHeight, $brush[$i])
    Next
EndFunc   ;==>Draw_Dots

Func Draw_Lines($i)
    Local $j = 0, $z
    _GDIPlus_GraphicsDrawLine($backbuffer, $coordinates[$i][0] + $iWidth / 2, $coordinates[$i][1] + $iWidth / 2, $n_x + $iWidth / 2, $n_y + $iWidth / 2, $pen)
    While $coordinates[$i][7 + $j] <> 0 ;draw also neighbour dots
        _GDIPlus_GraphicsDrawLine($backbuffer, $coordinates[$i][0] + $iWidth / 2, $coordinates[$i][1] + $iWidth / 2, $coordinates[$i][8 + $j] + $iWidth / 2, $coordinates[$i][9 + $j] + $iWidth / 2, $pen)
        $j += 3
    WEnd
    For $z = 0 To $j ;delete coordinates of neighbours
        $coordinates[$i][7 + $z] = 0
    Next
EndFunc   ;==>Draw_Lines

Func New_Coordinates($k)
    $coordinates[$k][0] = Random($width / 20, $width - $width / 20, 1);start x position
    $coordinates[$k][1] = Random($height / 20, $height - $height / 20, 1) ;start y position
    $coordinates[$k][2] = Random(2, $max_speed, 1) ;speed of pixel
    $coordinates[$k][3] = Random(0, $width, 1) ;new destination x
    $coordinates[$k][4] = Random(0, $height, 1);new destination y
    $coordinates[$k][5] = Random(-7, 7)
    $coordinates[$k][6] = Random(-7, 7)
    If $coordinates[$k][0] < $coordinates[$k][3] And $coordinates[$k][1] < $coordinates[$k][4] Then
        $coordinates[$k][1] -= (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $coordinates[$k][5]
        $coordinates[$k][0] -= $coordinates[$k][2]
    ElseIf $coordinates[$k][0] > $coordinates[$k][3] And $coordinates[$k][1] < $coordinates[$k][4] Then
        $coordinates[$k][1] += (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $coordinates[$k][5]
        $coordinates[$k][0] += $coordinates[$k][2]
    ElseIf $coordinates[$k][0] > $coordinates[$k][3] And $coordinates[$k][1] > $coordinates[$k][4] Then
        $coordinates[$k][1] += (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $coordinates[$k][5]
        $coordinates[$k][0] += $coordinates[$k][2]
    ElseIf $coordinates[$k][0] < $coordinates[$k][3] And $coordinates[$k][1] > $coordinates[$k][4] Then
        $coordinates[$k][1] -= (($coordinates[$k][0] + $coordinates[$k][2]) - $coordinates[$k][0]) * $coordinates[$k][5]
        $coordinates[$k][0] -= $coordinates[$k][2]
    EndIf
EndFunc   ;==>New_Coordinates

Func Calculate_New_Position()
    Local $k
    For $k = 0 To $max_dots - 1
        $coordinates[$k][0] += $coordinates[$k][5]
        $coordinates[$k][1] += $coordinates[$k][6]
        If $coordinates[$k][0] <= 0 Then ;border collision x left
            $coordinates[$k][0] = 1
            $coordinates[$k][5] *= -1
        ElseIf $coordinates[$k][0] >= $width - $iWidth Then ;border collision x right
            $coordinates[$k][0] = $width - ($iWidth + 1)
            $coordinates[$k][5] *= -1
        EndIf
        If $coordinates[$k][1] <= 0 Then ;border collision y top
            $coordinates[$k][1] = 1
            $coordinates[$k][6] *= -1
        ElseIf $coordinates[$k][1] >= $height - $iHeight Then ;border collision y bottom
            $coordinates[$k][1] = $height - ($iHeight + 1)
            $coordinates[$k][6] *= -1
        EndIf
    Next
EndFunc   ;==>Calculate_New_Position


Func Find_Neighbour($x, $y, $i)
    Local $a, $nb
    $nb = 0
    $n_x = 0
    $n_y = 0
    $d = 99999999
    For $a = 0 To $max_dots - 1
        If $x <> $coordinates[$a][0] And $y <> $coordinates[$a][1] Then
            $current_dist = Pixel_Distance($x, $y, $coordinates[$a][0], $coordinates[$a][1])
            If $current_dist < $d Then
                $n_x = $coordinates[$a][0]
                $n_y = $coordinates[$a][1]
                $d = $current_dist
                $dot_count = $a
            EndIf
            If $current_dist <= $pixel_distance_threshold Then ;save also neighbours to array
                $coordinates[$i][7 + $nb] = $a
                $coordinates[$i][8 + $nb] = $coordinates[$a][0]
                $coordinates[$i][9 + $nb] = $coordinates[$a][1]
                $nb += 3
            EndIf
        EndIf
    Next
EndFunc   ;==>Find_Neighbour


Func Pixel_Distance($x1, $y1, $x2, $y2)
    Local $a, $b, $c
    If $x2 = $x1 And $y2 = $y1 Then
        Return 0
    Else
        $a = $y2 - $y1
        $b = $x2 - $x1
        $c = Sqrt($a ^ 2 + $b ^ 2)
        Return Round($c, 0)
    EndIf
EndFunc   ;==>Pixel_Distance

Func close()
    _GDIPlus_PenDispose($pen)
    _GDIPlus_BrushDispose($brush)
    _GDIPlus_BitmapDispose($bitmap)
    _GDIPlus_GraphicsDispose($graphics)
    _GDIPlus_GraphicsDispose($backbuffer)
    _GDIPlus_Shutdown()
    Exit
EndFunc   ;==>close

Func _GDIPlus_BrushSetSolidColor($hBrush, $iARGB = 0xFF000000)
    Local $aResult
    $aResult = DllCall($ghGDIPDll, "int", "GdipSetSolidFillColor", "hwnd", $hBrush, "int", $iARGB)
    If @error Then Return SetError(@error, @extended, 0)
    Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_GDIPlus_BrushSetSolidColor
