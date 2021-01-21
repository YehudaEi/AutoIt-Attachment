; <AUT2EXE VERSION: 3.0.102.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Documents and Settings\kris\Desktop\smily face.au3>
; ----------------------------------------------------------------------------

;AutoItSetOption("MustDeclareVars", 1)
;AutoItSetOption("MouseCoordMode", 0)
;AutoItSetOption("PixelCoordMode", 0)
;AutoItSetOption("RunErrorsFatal", 0)
;AutoItSetOption("TrayIconDebug", 1)
;AutoItSetOption("WinTitleMatchMode", 4)


;@DesktopHeight
;@DesktopWidth
$DH = @DesktopHeight
$dw = @DesktopWidth
$SettingsFile = @SCRIPTDIR & '\Settings.ini'
Opt("MouseCoordMode", 0)
Run("mspaint.exe")
$X3 = IniRead ( "Settings.ini", 'speed', 'stops', "" )
$x2 = $x3 * 400
sleep($x2)
WinActivate("untitled - paint", "")
$x1 = $dh - 50
$y1 = IniRead ( "Settings.ini", 'speed', 'drawspeed', "" )
$y2 = IniRead ( "Settings.ini", 'speed', 'crashspeed', "" )

;$Y3 = $dw * .128125
;$X3 = $dw * .181875
$Y4 = $dw * .128125
$X4 = $dw * .181875
$Y5 = $dw * .656875
$X5 = $dw * .81625
$Y6 = $dw * .710
$X6 = $dw * .02625
$Y7 = $dw * .1925
$X7 = $dw * .3456
$Y8 = $dw * .3525
$X8 = $dw * .45625
$Y9 = $dw * .1925
$X9 = $dw * .5325
$Y10 = $dw * .3525
$X10 = $dw * .635625
$X11 = $dw * .44625
$Y11 = $dw * .360625
$X12 = $dw * .53125
$Y12 = $dw * .440625
$X13 = $dw * .36875
$Y13 = $dw * .51875
$X14 = $dw * .65875
$Y14 = $dw * .59875
sleep($x2)
mouseclick("1", 15, 239, $y2, );select circle tool
sleep($x2)
send("^l", 0)
sleep($x2)
send("^t", 0)
sleep($x2)
send("!f", 0)
sleep($x2)
Send("{LEFT}{x}")
sleep($x2)
send("^e", 0)
sleep($x2)
send("!p", 0)
sleep($x2)
send("{tab 5}")
sleep($x2)
$send = @DesktopWidth
sleep($x2)
send($send)
sleep($x2)
send("{tab}")
sleep($x2)
$send = @Desktopheight
sleep($x2)
send($send)
sleep($x2)
send("{enter}")
sleep($x2)
$DW = @DesktopWidth
sleep($x2)
send("^t", 0)
sleep($x2)

sleep(100)
send("!v", 0)
sleep(100)
send("s", 0)

mouseclick("1", 29, 313, "1", 0);select fill style
sleep($x2)
send("^t", 0)
sleep($x2)
MouseClickDrag("1", $x4, $y4, $x5, $y5, $y1);face
sleep($x2)
send("^l", 0)
sleep($x2)
mouseclick("1", 43, $x1, "1", 0);color select "white"
sleep($x2)
send("^l", 0)
sleep($x2)
MouseClickDrag("1", $x7, $y7, $x8, $y8, $y1);left eye
sleep($x2)
MouseClickDrag("1", $x9, $y9, $x10, $y10, $y1);right eye
sleep($x2)
MouseClickDrag("1", $x11, $y11, $x12, $y12, $y1);nose
sleep($x2)
MouseClickDrag("1", $x13, $y13, $x14, $y14, $y1);mouth
send("^t", 0)
sleep($x2)
send("^l", 0)
sleep($x2)
send("!v", 0)
send("s", 0)
send("^f", 0)

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Documents and Settings\kris\Desktop\smily face.au3>
; ----------------------------------------------------------------------------

