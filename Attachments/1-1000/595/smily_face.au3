; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Platform:       Win9x / NT
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; Set up our defaults
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
;AutoItSetOption("WinTitleMatchMode", 4)


; ----------------------------------------------------------------------------
; Script Start
; ---------------------------------------------------------------------------- 

;@DesktopHeight
;@DesktopWidth
$DW = @DesktopWidth
$DH = @DesktopHeight

$SettingsFile = @SCRIPTDIR & '\Settings.ini' 
$Sleep = IniRead ( "Settings.ini", 'Sleep', 'Sleep', "" ) 
Opt("MouseCoordMode", 0)
Run("mspaint.exe") 
Sleep ( $Sleep )
WinActivate("untitled - paint", "")
$x1 = $dw * .0131
$y1 = $dw * .151


$X2 = $dw * .02125
$X3 = $dw * .181875
$X4 = $dw * .181875
$X5 = $dw * .81625
$X6 = $dw * .02625
$X7 = $dw * .3456
$X8 = $dw * .45625
$X9 = $dw * .5325
$X10 = $dw * .635625
$X11 = $dw * .44625
$X12 = $dw * .53125
$X13 = $dw * .36875
$X14 = $dw * .65875

$Y2 = $dw * .199375
$Y3 = $dw * .128125
$Y4 = $dw * .128125
$Y5 = $dw * .656875
$Y6 = $dw * .710
$Y7 = $dw * .1925
$Y8 = $dw * .3525
$Y9 = $dw * .1925
$Y10 = $dw * .3525
$Y11 = $dw * .360625
$Y12 = $dw * .440625
$Y13 = $dw * .51875
$Y14 = $dw * .59875

MouseClick("1", $x1, $y1, 1, 0) 
send("!f", 0)
Send("{LEFT}{x}")
send("^e", 0)
send("!p", 0)
send("{tab 5}")
$send = @DesktopWidth
send($send)
send("{tab}")
$send = @Desktopheight 
send($send)
send("{enter}")
;sleep(100)
MouseClick("1", $x2, $y2, "1", 0)
;Sleep(100)
Mousemove($x3, $y3, 0)
;Sleep(100)
MouseClickDrag("1", $x4, $y4, $x5, $y5, 0)
;Sleep(100)
mouseclick("1", $x6, $y6, "1", 0)
;Sleep(100)
MouseClickDrag("1", $x7, $y7, $x8, $y8, 0)
;Sleep(100)
MouseClickDrag("1", $x9, $y9, $x10, $y10, 0)
;Sleep(100)
MouseClickDrag("1", $x11, $y11, $x12, $y12, 0)
;Sleep(100)
MouseClickDrag("1", $x13, $y13, $x14, $y14, 0)




