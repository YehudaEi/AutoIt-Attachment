#include <WindowsConstants.au3>
#include <WinAPI.au3>

Opt("WinTitleMatchMode", 2)
Global $nFrames = 60
Global $nFPS = 30
If $nFrames < $nFPS Then $nFrames = $nFPS
Global $aBitmaps[$nFrames][4]
For $i = 0 To $nFrames - 1
    $aBitmaps[$i][2] = _WinAPI_CreateCompatibleDC(0)
    $tBMI = DllStructCreate($tagBITMAPINFO)
    DllStructSetData($tBMI, 1, DllStructGetSize($tBMI) - 4)
    DllStructSetData($tBMI, 2, 400)
    DllStructSetData($tBMI, 3, 400)
    DllStructSetData($tBMI, 4, 1)
    DllStructSetData($tBMI, 5, 32)
    $aDIB = DllCall('gdi32.dll', 'ptr', 'CreateDIBSection', 'hwnd', 0, 'ptr', DllStructGetPtr($tBMI), 'uint', 0, 'ptr*', 0, 'ptr', 0, 'uint', 0)
    $aBitmaps[$i][1] = $aDIB[0]
    $aBitmaps[$i][0] = $aDIB[4]
    _WinAPI_SelectObject($aBitmaps[$i][2], $aBitmaps[$i][1])
    $aBitmaps[$i][3] = DllStructCreate("dword[160000]", $aBitmaps[$i][0])
Next
Global $fPi = 4 * ATan(1)
$hGUI = GUICreate("Animated Landscape")
$hDC = _WinAPI_GetDC($hGUI)
GUISetState()
For $iFrame = 1 To $nFrames
    $SunX = -14 + ((39 / ($nFrames - 1)) * ($iFrame - 1))
    $SunY = -(27 / 380) * $SunX ^ 2 + (297 / 380) * $SunX + (945 / 38)
    $fAmbientLight = ($SunY / 27)
    $iFrameTimer = TimerInit()
    $iSunRedSaturation = Int(0.111 * $iFrame ^ 2 - 6.667 * $iFrame + 100)
    For $fy = 0 To 400
        $y = -15 + $fy * 0.125
        For $fx = 0 To 400
            $x = -20 + $fx * 0.125
            $fDirectionalLight = Int((Abs($SunX - ($x + 6)) / 39) * 60)
            $iColorARGB = RGB(2 * $iSunRedSaturation, 200 - $iSunRedSaturation, 200 - $iSunRedSaturation)
            If $y > Sin($x) And $y > Cos($x) And $y < Tan($x) And $y < Sin($fPi * $x) + 7 And $x < 9 Then
                $iColorARGB = RGB(2 * $iSunRedSaturation, 0, 0)
            ElseIf ((Mod(Abs($x) - $fPi / 2, 2 * $fPi) - $fPi) ^ 2 + ($y - 8.5 + $x ^ 2 / 250) ^ 2) < 5 And $x < 8 Then
                $iColorARGB = RGB(2 * $iSunRedSaturation, 87 + Int(87 * $fAmbientLight) - $fDirectionalLight, 0)
            ElseIf ((Mod(Abs($x) + $fPi / 2, 2 * $fPi) - $fPi) ^ 2 + ($y - 7.5 + $x ^ 2 / 280) ^ 2) < 5 And $x < 11 Then
                $iColorARGB = RGB(2 * $iSunRedSaturation, 41 + Int(41 * $fAmbientLight) - $fDirectionalLight, 0)
            ElseIf $y <= ATan(10 - $x) Then
                $iColorARGB = RGB(2 * $iSunRedSaturation, 87 + Int(87 * ($fAmbientLight)) - $fDirectionalLight, 0)
            ElseIf $y < ($iFrame / 75) * Sin($x * 2) ^ 2 + 0.5 And $y < $x - 9 Then
                $iColorARGB = RGB(2 * $iSunRedSaturation, 0, 87 + Int(87 * $fAmbientLight) - $fDirectionalLight)
            ElseIf Abs(30 - ($x - $SunX) ^ 2 - ($y - $SunY) ^ 2) = 30 - ($x - $SunX) ^ 2 - ($y - $SunY) ^ 2 Then
                $iColorARGB = RGB(0xFF, 0xFF - 2 * $iSunRedSaturation, 0);0x00FFFF00
            EndIf
            DllStructSetData($aBitmaps[$iFrame - 1][3], 1, $iColorARGB, $fy * 400 + $fx + 1)
        Next
    Next
    WinSetTitle("Animated Landscape", "", "Animated Landscape Frame " & $iFrame & "/" & $nFrames & " (" & Round((TimerDiff($iFrameTimer) / 1000) * ($nFrames - $iFrame)) & "s remaining)")
    _WinAPI_BitBlt($hDC, 0, 0, 400, 400, $aBitmaps[$iFrame - 1][2], 0, 0, $srccopy)
Next
AdlibRegister("DrawScene", 1000 / $nFPS)
$iFrame = 0
$iAnimator = 1

While GUIGetMsg() <> -3
WEnd

Func RGB($R, $G, $B)
    If $R <= 0 Then $R = 0
    If $G <= 0 Then $G = 0
    If $B <= 0 Then $B = 0
    Return '0x00' & Hex($R, 2) & Hex($G, 2) & Hex($B, 2)
EndFunc                                                          ;==>RGB

Func DrawScene()
    $iFrame += $iAnimator
    If $iFrame = $nFrames - 1 Or $iFrame = 0 Then $iAnimator *= -1
    _WinAPI_BitBlt($hDC, 0, 0, 400, 400, $aBitmaps[$iFrame][2], 0, 0, $srccopy)
EndFunc                                                          ;==>DrawScene