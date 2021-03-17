#include <GDIPlus.au3>
Dim $Numero = 0
dim $Block[2]
Global $d[9][1]
Func _Button($hImage1,$hImage2,$x,$y,$w,$h,$SDOs)

if $Numero > 0 Then
    ReDim $Block[$Numero+1]
ReDim $d[9][$Numero+1]
EndIf
$Block[$Numero] = False
$b = _GuiCtrlCreatePNG($hImage1,$x,$y, $SDOs)
$d[0][$Numero] = $x
$d[1][$Numero] = $y
$d[2][$Numero] = $w
$d[3][$Numero] = $h
$d[4][$Numero] = $b[0]
$d[5][$Numero] = $hImage2
$d[6][$Numero] = $hImage1
$d[7][$Numero] = $b[1]

$Numero = $Numero +1
Return $d
EndFunc
Dim $Mouse_DK[2]
dim $Timer

Func _MouseDR($HD_GUI)
$Mouse_GI = MouseGetPos()
$Gui_Pos = WinGetPos($HD_GUI)
$Mouse_DK[0] = $Mouse_GI[0]-$Gui_Pos[0]
$Mouse_DK[1] = $Mouse_GI[1]-$Gui_Pos[1]
Return $Mouse_DK
EndFunc
Dim $style = True
Func _BMove($H_GUI)
if $style = True Then
if GUIGetStyle($H_GUI) <> 0x80000000 Then GUISetStyle(0x80000000,-1,$H_GUI)
$style = False
EndIf
$Mouse_DO = _MouseDR($H_GUI)
for $i = 0 to $Numero-1
if $Mouse_DO[0] > $d[0][$i] AND $Mouse_DO[0] < $d[0][$i]+$d[2][$i] AND $Mouse_DO[1] > $d[1][$i] AND  $Mouse_DO[1] < $d[1][$i]+$d[3][$i] Then
if $Block[$i] = False then
;########################################################;########################################################

_SetGraphicToControl($d[4][$i],$d[5][$i])

$Block[$i] = True
EndIf ;########################################################

Else
if $Block[$i] = True then
;~ _SetBitmapToCtrl($d[4][$i],$d[6][$i])
_SetGraphicToControl($d[4][$i],$d[6][$i])

$Block[$i] = False
EndIf
EndIf
Next
EndFunc
Func _BSEL($D_Sel)
    Return $D_Sel[7][UBound($D_Sel,2)-1]
EndFunc
Func _GuiCtrlCreateButton($hImage1,$hImage2,$x,$y,$w,$h,$SDOs)
    Return _BSEL(_Button($hImage1,$hImage2,$x,$y,$w,$h,$SDOs))
EndFunc

Func _SetBitmapToCtrl($CtrlId, $hBitmap)
GUICtrlSendMsg($CtrlId, 0x0172, 0, $hBitmap)
GUICtrlSetState($CtrlId, 16)
EndFunc

Func _IMGL($Image)
dim $LoadIMG,$iW,$iH,$hImage,$CloneIMG
$LoadIMG = _GDIPlus_ImageLoadFromFile($Image)
$iW = _GDIPlus_ImageGetWidth($LoadIMG)
$iH = _GDIPlus_ImageGetHeight($LoadIMG)
$CloneIMG = _GDIPlus_BitmapCloneArea($LoadIMG, 0, 0, $iW, $iH, $GDIP_PXF32ARGB)
$hImage = _GDIPlus_BitmapCreateHBITMAPFromBitmap($LoadIMG)
_GDIPlus_BitmapDispose($LoadIMG)
_GDIPlus_ImageDispose($CloneIMG)
Return $hImage
	EndFunc
