#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <Array.au3>
Opt('MustDeclareVars', 1)
Local $hBitmap, $hImage, $sImageType, $iX, $iY, $iXc, $iYc, $iMemo, $iPixelColor, $count, $File, $color1, $oForm, $color, $dc, $setpixel, $realesedc
Local $hGraphic, $hBitmap, $hBackbuffer, $save, $hPen, $hWind
Local $midY, $midX
$File = FileOpen(@ScriptDir & "\coords.txt", 2)

_Main()

Func _Main()
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & '\PicA.jpg')
	$sImageType = _GDIPlus_EncodersGetCLSID("JPG")
	$iX = _GDIPlus_ImageGetWidth($hImage)
	$iY = _GDIPlus_ImageGetHeight($hImage)
	Local $aCoords[$iX][$iY]
	$oForm = GUICreate("GDI+", ($iX), ($iY))
	GUISetBkColor(0xFFFFFF)
	GUISetState()
	$hWind = WinGetHandle($oForm)
	$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hWind)
	$hBitmap = _GDIPlus_BitmapCreateFromGraphics($iX, $iY, $hGraphic)
	$hBackbuffer = _GDIPlus_ImageGetGraphicsContext($hBitmap)
	_GDIPlus_GraphicsClear($hBackbuffer, 0xFFFFFFFF)
	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			$iPixelColor = Hex(_GDIPlus_GetPixel($hImage, $iXc, $iYc), 6)
			If Dec($iPixelColor) < Dec('882829') Then
				;$count = $count + 1
				FileWrite($File, $iXc & "," & $iYc & @CRLF)
				$aCoords[$iXc][$iYc] = 999999
				SetPixel($oForm, $iXc, $iYc, $color)
				$hPen = _GDIPlus_PenCreate(0xFF000000);
				_GDIPlus_GraphicsDrawLine($hBackbuffer, $iXc, $iYc, $iXc + 1, $iYc + 1, $hPen)
				_GDIPlus_GraphicsDrawLine($hGraphic, $iXc, $iYc, $iXc + 1, $iYc + 1, $hPen)
			Else
				$aCoords[$iXc][$iYc] = 0
			EndIf
		Next
	Next
	;$save = _GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & '\Image1.jpg')
	Do
	Until GUIGetMsg() = $GUI_EVENT_CLOSE
	FileClose($File)
	_GDIPlus_Shutdown()



;~ 	For $iXc = 0 To $iX - 1
;~ 		For $iYc = 0 To $iY - 1
;~ 			If $aCoords[$iXc][$iYc] = 999999 Then
;~ 				For $iYc2 = $iYc To $iY - 1
;~ 					If $aCoords[$iXc][$iYc2] = 0 Then
;~ 						$midY = ($iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1))
;~
;~ 						For $iXc2 = $iXc To $iX - 1
;~ 							If $aCoords[$iXc2][$iYc] = 0 Then
;~ 								$midX = ($iXc + Ceiling(Round(($iXc2 - $iXc) / 2) - 1))
;~ 								$aCoords[$midX][$midY] = 777777
;~ 								$iXc = $iXc2
;~ 								ExitLoop
;~ 							EndIf
;~ 						Next
;~ 						$iYc = $iYc2
;~ 						ExitLoop
;~ 					EndIf
;~ 				Next
;~ 			EndIf
;~ 		Next
;~ 	Next



	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 999999 Then
				For $iYc2 = $iYc To $iY - 1
					If $aCoords[$iXc][$iYc2] = 0 Then
						$aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1)] = 777777 ; eher rechts ausgerichtet
						$iYc = $iYc2
						ExitLoop
					EndIf
				Next
			EndIf
		Next
	Next


	For $iYc = 0 To $iY - 1
		For $iXc = 0 To $iX - 1
			If $aCoords[$iXc][$iYc] = 999999 Then
				For $iXc2 = $iXc To $iX - 1
					If $aCoords[$iXc2][$iYc] = 0 Then
						$aCoords[$iXc + Ceiling(Round(($iXc2 - $iXc) / 2) - 1)][$iYc] = 777777 ; eher rechts ausgerichtet
						$iXc = $iXc2
						ExitLoop
					EndIf
				Next
			EndIf
		Next
	Next


	; jede "zeile" durchgehen
;~ 	For $iXc = 0 To $iX - 1
;~ 		For $iYc = 0 To $iY - 1
;~ 			; wenn schwarz "beginnt"
;~ 			If $aCoords[$iXc][$iYc] = 999999 Then
;~ 				; gehe von dort aus ($iXc) weiter nach rechts, höchstens bis zum Ende des bildes.
;~ 				For $iYc2 = $iYc To $iY - 1
;~ 					; Wenn jetzt wieder eine weißer pixel kommt, ist die schwarze linie vorbei.
;~ 					If $aCoords[$iXc][$iYc2] = 0 Then
;~ 						; Jetzt nur noch den Mittelpunkt der Linie ermitteln (Linie ist $iXc2 [rechter endpunkt] - $iXc [linker startpunkt] lang)
;~ 						; Davon nehmen wir die Hälfte und addieren das auf den startpunkt der linie.
;~ 						; bsp: Linie geht von 5 bis 14. Linie ist also 9 px lang (=14-5). Jede hälfte ist dann 4,5 px lang.
;~ 						; Die Mitte liegt dann bei 9,5 (=5+4,5). Wobei wir natürlich runden müssen.
;~ 						; $aCoords[$iYc][$iXc + Floor(($iXc2 - $iXc - 1) / 2)] = 777777 ; eher links ausgerichtet
;~ 						$aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1)] = 777777 ; eher rechts ausgerichtet
;~ 						$iYc = $iYc2
;~ 						ExitLoop
;~ 					EndIf
;~ 				Next
;~ 			EndIf
;~ 		Next
;~ 	Next

	_ArrayDisplay($aCoords, Default, Default, 1)

EndFunc   ;==>_Main

; Gibt eine Zeile im Memo-Fenster aus
Func MemoWrite($sMessage = '')
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
; _GDIPlus_GetPixel
Func _GDIPlus_GetPixel($hBitmap, $X, $Y)
	Local $result = DllCall($ghGDIPDLL, "int", "GdipBitmapGetPixel", "ptr", $hBitmap, "int", $X, "int", $Y, "dword*", 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetError($result[0], 1, $result[4])
EndFunc   ;==>_GDIPlus_GetPixel
;SetPixel
Func SetPixel($oForm, $X, $Y, $color)
	$dc = DllCall("user32.dll", "int", "GetDC", "hwnd", $oForm)
	$setpixel = DllCall("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $X, "long", $Y, "long", $color)
	$realesedc = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $dc[0])
EndFunc   ;==>SetPixel
