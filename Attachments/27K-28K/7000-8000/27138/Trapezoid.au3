#include <GDIplus.au3>

Global Const $width = 382
Global Const $height = 452
Global $graphics, $bitmap, $backbuffer, $hPenBlack, $hPenRed

$GUI = GUICreate("GDI+", $width, $height)
GUISetState()
Draw($GUI)


While WinExists($GUI)
	While WinActive($GUI)
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case - 3
				close()
			Case Else
				ReDraw($graphics, $backbuffer, 176, 381, 136)
		EndSwitch
		Sleep(10)
	WEnd
	Sleep(200)
WEnd

Func Draw($hWnd)
	_GDIPlus_Startup()
	$graphics = _GDIPlus_GraphicsCreateFromHWND($hWnd)
	$bitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
	$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
	ReDraw($graphics, $backbuffer, 176, 381, 136)
EndFunc   ;==>Draw

Func ReDraw($hBuffer, $hGraphics, $Left, $Bottom, $Length)
	Local $Points[5][2]

	_GDIPlus_GraphicsClear($backbuffer, 0x00F7F7F7)

	;Points[$x][0] = $Left ;Points[$x][1] = $Bottom
;~ 	$Points[0][0] = 4
;~ 	$Points[1][0] = $Left
;~ 	$Points[1][1] = $Bottom
;~ 	$Points[2][0] = $Left + 5
;~ 	$Points[2][1] = $Bottom - 5
;~ 	$Points[3][0] = $Points[1][0] + $Length
;~ 	$Points[3][1] = $Bottom
;~ 	$Points[4][0] = $Points[3][0] - 5
;~ 	$Points[4][1] = $Bottom - 5

;~ 	$Points[0][0] = 4
;~ 	$Points[1][0] = 20
;~ 	$Points[1][1] = 60
;~ 	$Points[2][0] = 25
;~ 	$Points[2][1] = 55
;~ 	$Points[3][0] = 150
;~ 	$Points[3][1] = 60
;~ 	$Points[4][0] = 145
;~ 	$Points[4][1] = 55
;~ 	For $x = 1 To 4
;~ 		ConsoleWrite("Points" & $x & "0:  " & $Points[$x][0] & @CRLF)
;~ 		ConsoleWrite("Points" & $x & "1:  " & $Points[$x][1] & @CRLF)
;~ 	Next
;~ 	Exit

	$Poly = _GDIPlus_GraphicsDrawPolygon($hGraphics, $Points)
;~ 	ConsoleWrite($Poly & @CRLF)

	_GDIPlus_GraphicsDrawImageRect($graphics, $bitmap, 0, 0, $width, $height)

EndFunc   ;==>DrawTriangle

Func close()
	_GDIPlus_GraphicsDispose($backbuffer)
	_GDIPlus_BitmapDispose($bitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>close
