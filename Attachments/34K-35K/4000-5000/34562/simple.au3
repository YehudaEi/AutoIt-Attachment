#Include <ScreenCapture.au3>
#Include <WinAPI.au3>

Dim $A[50000]
Global $control

HotKeySet("{ESC}","capture2")

$control = 0
$n = 0
while $control <> 2
    $A[$n] = _ScreenCapture_Capture("",300,121,396,241)
    $n = $n + 1
WEnd
$n = $n - 1

MsgBox(0,"number of pictures taken",$n)

$t = 0
while $t <= 49999
    if $t <= $n Then
        $argument = StringReplace ("c:\location\pictureW.bmp","W",$t+1)
        _ScreenCapture_SaveImage($argument,$A[$t],True)
    Else
        _WinAPI_DeleteObject($A[$t])
    EndIf
    $t = $t + 1
WEnd

Func capture2()
    $control = 2
EndFunc