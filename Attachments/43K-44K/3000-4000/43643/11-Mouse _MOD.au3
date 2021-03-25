#include "S3d.au3"
#include <GUIConstantsEx.au3>
#include <Misc.au3>

Global $sTitle = "Test", $iWidth = 576,$iHeight =576
Global $hGUI = GUICreate($sTitle, $iWidth, $iHeight)
GUICtrlCreateInput("", -100, -100, 10, 10)
GUISetState()
_GDIPlus_Startup()

Global $hGraphics = _GDIPlus_GraphicsCreateFromHWND($hGUI)
Global $hBitmap = _GDIPlus_BitmapCreateFromGraphics($iWidth, $iHeight, $hGraphics)
Global $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)

Global $hPen = _GDIPlus_PenCreate(0xFF0080FF, 2)
_S3d_SelectPen($hPen)

_S3d_SelectGraphic($hGraphic, $iWidth, $iHeight, 2)

Global $hUserDll = DllOpen("user32.dll")
Global $anCamPos[3] = [18, 18, 31], $anAngle[2] = [0, -1.57];11,18,38,0,-1.4
Global $anAddCamPos[3] = [1, 1, 1]
Global $anAddAngle[2] = [0.1, 0.1]
Global $iFPS = 0, $hTimer = TimerInit()

$hBrush = _GDIPlus_BrushCreateSolid(0xCCBB99DD)
$hFormat = _GDIPlus_StringFormatCreate()
$hFamily = _GDIPlus_FontFamilyCreate("Arial")
$hFont = _GDIPlus_FontCreate($hFamily, 12, 2)
$tLayout = _GDIPlus_RectFCreate(0, 0, 0, 0)
Dim $Depth[8][3]
$Depth[0][0]=1
$Depth[2][0]=2
$Depth[2][1]=0xFF4D4DFF
$Depth[2][2]=4
$Depth[3][0]=4
$Depth[3][1]=0xCC00FF7F
$Depth[3][2]=3
$Depth[4][0]=8
$Depth[4][1]=0x99D9D919
$Depth[4][2]=3
$Depth[5][0]=16
$Depth[5][1]=0xFFFF7F00
$Depth[5][2]=2
$Depth[6][0]=32
$Depth[6][1]=0x33FF0000
$Depth[6][2]=1

  ;DrawGrid(1,0x33FF0000,1)
  ;DrawGrid(2,0xFFFF7F00,2)
  ;DrawGrid(4,0x99D9D919,3)
  ;DrawGrid(8,0xCC00FF7F,4)
  ;DrawGrid(16,0xFF4D4DFF,4)
;AdlibRegister("_Cycl", 120000)

; Loop until user exits
Do
  _Draw()
  Sleep(1)
Until GUIGetMsg() = $GUI_EVENT_CLOSE

; Clean up resources
AdlibUnRegister()

DllClose($hUserDll)
_GDIPlus_PenDispose($hPen)

_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_BitmapDispose($hBitmap)
_GDIPlus_GraphicsDispose($hGraphics)
_GDIPlus_Shutdown()

Func _Cycl()
  $Depth[0][0]+=1
  If $Depth[0][0]=8 Then $Depth[0][0]=1
EndFunc

Func _Draw()
    If WinGetHandle("[active]") = $hGUI Then
        If _IsPressed("57", $hUserDll) Then ;W
            $anCamPos[0] += $anAddCamPos[0] * Cos($anAngle[1]) * Cos($anAngle[0])
            $anCamPos[1] += $anAddCamPos[1] * Cos($anAngle[1]) * Sin($anAngle[0])
            $anCamPos[2] += $anAddCamPos[2] * Sin($anAngle[1])
        ElseIf _IsPressed("53", $hUserDll) Then ;S
            $anCamPos[0] -= $anAddCamPos[0] * Cos($anAngle[1]) * Cos($anAngle[0])
            $anCamPos[1] -= $anAddCamPos[1] * Cos($anAngle[1]) * Sin($anAngle[0])
            $anCamPos[2] -= $anAddCamPos[2] * Sin($anAngle[1])
        EndIf
        If _IsPressed("41", $hUserDll) Then ;A
            $anCamPos[0] += $anAddCamPos[0] * -Sin($anAngle[0])
            $anCamPos[1] += $anAddCamPos[1] * Cos($anAngle[0])
        ElseIf _IsPressed("44", $hUserDll) Then ;D
            $anCamPos[0] -= $anAddCamPos[0] * -Sin($anAngle[0])
            $anCamPos[1] -= $anAddCamPos[1] * Cos($anAngle[0])
        EndIf
        If _IsPressed("31", $hUserDll) Then $Depth[0][0]=1;A
        If _IsPressed("32", $hUserDll) Then $Depth[0][0]=2;A
        If _IsPressed("33", $hUserDll) Then $Depth[0][0]=3;A
        If _IsPressed("34", $hUserDll) Then $Depth[0][0]=4;A
        If _IsPressed("35", $hUserDll) Then $Depth[0][0]=5;A
        If _IsPressed("36", $hUserDll) Then $Depth[0][0]=6;A
        If _IsPressed("37", $hUserDll) Then $Depth[0][0]=7;A
        If _IsPressed("10", $hUserDll) Then ;SHIFT
            $anCamPos[2] += $anAddCamPos[2]
        ElseIf _IsPressed("11", $hUserDll) Then ;CTRL
            $anCamPos[2] -= $anAddCamPos[2]
        EndIf
        If _IsPressed("28", $hUserDll) Then ;DOWN
            $anAngle[1] += $anAddAngle[1]
            ;If $anAngle[1] > 1.6 Then
            ;    $anAngle[1] = 1.6
            ;EndIf
        ElseIf _IsPressed("26", $hUserDll) Then ;UP
            $anAngle[1] -= $anAddAngle[1]
            ;If $anAngle[1] < -1.6 Then
            ;    $anAngle[1] = -1.6
            ;EndIf
        EndIf
        If _IsPressed("27", $hUserDll) Then ;RIGHT
            $anAngle[0] -= $anAddAngle[0]
            If $anAngle[0] < 0 Then
                $anAngle[0] = 6.28
            EndIf
        ElseIf _IsPressed("25", $hUserDll) Then ;LEFT
            $anAngle[0] += $anAddAngle[0]
            If $anAngle[0] > 6.28 Then
                $anAngle[0] = 0
            EndIf
        EndIf
    EndIf
    _S3d_Clear(0xFF000000)
    _S3d_SetCameraEx($anCamPos[0], $anCamPos[1], $anCamPos[2], $anAngle[0], $anAngle[1])
    If $Depth[0][0]=1 Then
      DrawGrid2D(32,0x77FF0000,1)
      DrawGrid2D(16,0xFFFF7F00,2)
      DrawGrid2D(8,0x99D9D919,3)
      DrawGrid2D(4,0xCC00FF7F,4)
      DrawGrid2D(2,0xFF4D4DFF,4)
    ElseIf $Depth[0][0]=7 Then
      DrawGrid3D(64,0x77FF0000,1)
      DrawGrid3D(32,0xFFFF7F00,2)
      DrawGrid3D(16,0x99D9D919,3)
      DrawGrid3D(8,0xCC00FF7F,4)
      DrawGrid3D(4,0xFF4D4DFF,4)
    Else
      DrawGrid3D($Depth[$Depth[0][0]][0],$Depth[$Depth[0][0]][1],$Depth[$Depth[0][0]][2])
    EndIf
    ;DrawGrid2D(16,0x77FF0000,1)
    ;_S3d_GridRoom(0, 0, 0, 16, 16, 2)

  ;DrawGrid(1,0x33FF0000,1)
  ;DrawGrid(2,0xFFFF7F00,2)
  ;DrawGrid(4,0x99D9D919,3)
  ;DrawGrid(8,0xCC00FF7F,4)
  ;DrawGrid(16,0xFF4D4DFF,4)
    Local $sString = "Camera: "
    For $i = 0 To 2
        $sString &= $anCamPos[$i] & ", "
    Next
    $sString = StringTrimRight($sString, 2) & @CRLF & "Angle: "
    For $i = 0 To 1
        $sString &= $anAngle[$i] & ", "
    Next
    $sString = StringTrimRight($sString, 2)
    $aInfo = _GDIPlus_GraphicsMeasureString($hGraphic, $sString, $hFont, $tLayout, $hFormat)
    _GDIPlus_GraphicsDrawStringEx($hGraphic, $sString, $hFont, $aInfo[0], $hFormat, $hBrush)
    _GDIPlus_GraphicsDrawImage($hGraphics, $hBitmap, 0, 0)
    $iFPS += 1
    If TimerDiff($hTimer) >= 1000 Then
        WinSetTitle($hGUI, "", $sTitle & " | " & $iFPS & " FPS")
        $iFPS = 0
        $hTimer = TimerInit()
    EndIf
EndFunc   ;==>_Draw


Func DrawGrid2D($GdiOverlayGridScale=2,$GdiOverlayGridColor=0xAA00FF00,$GdiOverlayGridDensity=4)
    _S3d_SelectPen(_GDIPlus_PenCreate($GdiOverlayGridColor,$GdiOverlayGridDensity,2))
    Local $GridBase=0, $GridRes=$GdiOverlayGridScale*9, $GridMax=9*4
    For $x = $GridBase To $GridMax Step $GridMax/$GdiOverlayGridScale
      _S3d_Line($GridBase,$x,0,$GridMax,$x,0)
    Next
    For $y = $GridBase To $GridMax Step $GridMax/$GdiOverlayGridScale
      _S3d_Line($y,$GridBase,0,$y,$GridMax,0)
    Next
  EndFunc

Func DrawGrid3D($GdiOverlayGridScale=2,$GdiOverlayGridColor=0xAA00FF00,$GdiOverlayGridDensity=4)
    _S3d_SelectPen(_GDIPlus_PenCreate($GdiOverlayGridColor,$GdiOverlayGridDensity,2))
    Local $GridBase=0, $GridRes=$GdiOverlayGridScale*9, $GridMax=9*4, $GridDepth=10
    For $z = $GridBase To $GridMax Step $GridMax/$GdiOverlayGridScale
      For $x = $GridBase To $GridMax Step $GridMax/$GdiOverlayGridScale
        For $y = $GridBase To $GridMax Step $GridMax/$GdiOverlayGridScale
            _S3d_Line($GridBase,$y,$GridBase,$GridMax,$y,$GridBase)
            _S3d_Line($x,$GridBase,$GridBase,$x,$GridMax,$GridBase)
            _S3d_Line($x,$y,$z,$x,$y,$GridBase)
            _S3d_Line($GridBase,$y,$z,$GridMax,$y,$z)
            _S3d_Line($x,$GridBase,$z,$x,$GridMax,$z)
        Next
      Next
    Next
  EndFunc

