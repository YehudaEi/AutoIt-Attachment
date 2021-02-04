; Description ...: Set G19 keyboard backlight to Colour  of Pixel under Mouse Cursor
; Requirement(s) : Autoit v3.3.0.0 or higher
; Author ........: micha / Mikesch

#include <GDIPlus.au3>
#include <Color.au3>
#include <ScreenCapture.au3>
#include <Misc.au3>

If _Singleton("G19_Mouse_Colour_set", 1) = 0 Then Exit

Opt("MouseCoordMode", 0)
Opt("SendKeyDelay", 0)
Opt("SendKeyDowndelay", 0)
Opt("WinTitleMatchMode", 2)
Opt("PixelCoordMode", 1)
opt("WinWaitDelay",5)

;get mouse position and Colour of coordinates
Opt("MouseCoordMode", 1)
$aPos = MouseGetPos()
$vCOL = PixelGetColor($aPos[0], $aPos[1])
$sScreen_Average = Hex($vCOL, 6)
Opt("MouseCoordMode", 0)

Dim $aiInput[3]

$aiInput[0] = Dec(StringLeft($sScreen_Average, 2))
$aiInput[1] = Dec(StringMid($sScreen_Average, 3, 2))
$aiInput[2] = Dec(StringMid($sScreen_Average, 5, 2))

;We got an Array with RGB values now,
;let's boost that green a little bit
;Quoting White--Hawk: The formula is basically colour% = colour% - (green% / calibration_ratio)

;get the ratios from config.ini

$redDiv = IniRead(@ScriptDir & "\config.ini", "Ratio", "Red", "5.6355")
If $redDiv = 0 Then $redDiv = 1 ; mustn't be zero in formula below
$blueDiv = IniRead(@ScriptDir & "\config.ini", "Ratio", "Blue", "6.171")
If $blueDiv = 0 Then $blueDiv = 1 ; mustn't be zero in formula below

If $aiInput[1] > 0 Then

	$aiInput[0] = Floor($aiInput[0] - (($aiInput[0] / 100) * ($aiInput[1] / $redDiv)))
	$aiInput[2] = Floor($aiInput[2] - (($aiInput[2] / 100) * ($aiInput[1] / $blueDiv)))

EndIf

;MsgBox(0, "RGB", $aiInput[0] & " " & $aiInput[1] & " " & $aiInput[2])

;converting to HSL

$valHSL = _ColorConvertRGBtoHSL($aiInput)

;	We could now leave out the conversion, but let's keep the option
; e.g., you could prevent the backlighting from being set to 0 by setting minimum luminance
;see below

; boost saturation a bit, to enable, just remove #cs and #ce
#cs
	If ($valHSL[1] * 1.2) < 240 Then
	$valHSL[1] = $valHSL[1] * 1.3
	ElseIf ($valHSL[1] * 1.1) < 240 Then
	$valHSL[1] = $valHSL[1] * 1.15
	Else
	EndIf
#ce

;make colours brighter, set minimum luminance
;Minimum brightness; uncomment next two lines if you want it

$minLum = IniRead(@ScriptDir & "\config.ini", "Brightness", "MinLum", "0")
;make colours brighter, set minimum luminance (from ini-file)
If $valHSL[2] < $minLum Then $valHSL[2] = $minLum
;Convert it back to RGB before applying it

$valRGBOut = _ColorConvertHSLtoRGB($valHSL)

; used INT() instead of Round()

$vRed = Round($valRGBOut[0], 0)
$vGreen = Round($valRGBOut[1], 0)
$vBlue = Round($valRGBOut[2], 0)

;MsgBox(0, "RGB", $vRed & " " & $vGreen & " " & $vBlue)
;Launch Slider controls

If Not ProcessExists("LGDCore.exe") Then
	$iCorePid = Run(@ProgramFilesDir & "\Logitech\GamePanel Software\G-series Software\LGDCore.exe")
Else
	$iCorePid = ProcessExists("LGDCore.exe")
EndIf

WinActivate("Logitech G-series Key Profiler")

ControlClick("Logitech G-series Key Profiler", "", "Button19")
;Sleep(30)
$hWnd2 = winWait("[CLASS:#32768]")

WinSetTrans($hWnd2,"", 0)
ControlSend($hWnd2, "", "","{UP}")
sleep(5)
ControlSend($hWnd2,"", "","{ENTER}")
Sleep(30)

	$tWindow = WinGetTitle("[ACTIVE]")
	$hWnd = WinGetHandle($tWindow, "")
	WinSetTrans($hWnd,"", 0)

;get current settings
Sleep(100)

$delay = IniRead(@ScriptDir & "\config.ini", "Speed", "Loops", "0")
$redVal = ControlGetText($hWnd, "", "Static2")

WinActivate($hWnd)
WinSetOnTop($hWnd, "", 1)

If $redVal > $vRed Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar321", "{LEFT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static2") = $vRed

ElseIf $redVal < $vRed Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar321", "{RIGHT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static2") = $vRed

Else
EndIf

Sleep(50)

$greenVal = ControlGetText($hWnd, "", "Static4")
If $greenVal > $vGreen Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar322", "{LEFT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static4") = $vGreen

ElseIf $greenVal < $vGreen Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar322", "{RIGHT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static4") = $vGreen

Else
EndIf

Sleep(50)

$blueVal = ControlGetText($hWnd, "", "Static6")
If $blueVal > $vBlue Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar323", "{LEFT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static6") = $vBlue

ElseIf $blueVal < $vBlue Then
	Do
		ControlSend($hWnd, "", "msctls_trackbar323", "{RIGHT}")
		Sleep($delay)
	Until ControlGetText($hWnd, "", "Static6") = $vBlue

Else
EndIf

$pause = IniRead(@ScriptDir & "\config.ini", "Pause", "ExitWait", "0")
WinActivate($hWnd)
Sleep($pause)
ControlClick($hWnd, "", "Button1")
Opt("MouseCoordMode", 1)
MouseMove($aPos[0], $aPos[1], 0)

If WinExists($hWnd) Then WinClose($hWnd)
