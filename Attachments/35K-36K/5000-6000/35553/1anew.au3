#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>
#include <WinAPI.au3>
#include <File.au3>
#include <Array.au3>
Opt('MustDeclareVars', 1)
Local $hBitmap, $hImage, $sImageType, $iX, $iY, $iXc, $iYc, $iMemo, $iPixelColor, $count, $File, $color1, $oForm, $color, $dc, $setpixel, $realesedc
Local $hGraphic, $hBitmap, $hBackbuffer, $save, $hPen, $hWind, $cPix, $line, $split, $split0, $split12, $split17, $split1, $split2, $split3, $fRand
Local $midY[1]
Local $midX[1]
Local $found[1]
$File = FileOpen(@ScriptDir & "\coords.txt", 2)
$fRand = FileOpen(@ScriptDir & "\cRand.txt", 2)

_Main()

Func _Main()
	_GDIPlus_Startup()
	$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & '\Picaa.jpg')
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
			If Dec($iPixelColor) < Dec('999999') Then
				;$count = $count + 1
				;FileWrite($File, $iXc & "," & $iYc & @CRLF)
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
	;FileClose($File)
	_GDIPlus_Shutdown()

	_ArrayDisplay($aCoords, Default, Default, 1)



	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 999999 Then
				If $aCoords[$iXc - 1][$iYc] = 0 Or $aCoords[$iXc + 1][$iYc] = 0 Or $aCoords[$iXc][$iYc - 1] = 0 Or $aCoords[$iXc][$iYc + 1] = 0 Then
					$aCoords[$iXc][$iYc] = 777777
					FileWrite($fRand, $iXc & "," & $iYc & @CRLF)
				EndIf
			EndIf
		Next
	Next
	FileClose($fRand)

	_ArrayDisplay($aCoords, Default, Default, 1)

	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 777777 And $count = 0 Then
				$split17 = StringSplit($aCoords[$iXc][$iYc], ',', 1)
				$count = $count + 1
				For $iYc2 = $iYc To $iY
					If $aCoords[$iXc][$iYc2] = 0 Then
						$split0 = StringSplit($aCoords[$iXc][$iYc2], ',', 1)
						$split1 = StringSplit($aCoords[$iXc][$iYc + 1], ',', 1)
						$split2 = StringSplit($aCoords[$iXc][$iYc2 - 1], ',', 1)
						$split3 = StringSplit($aCoords[$iXc][$iYc2 - 2], ',', 1)
						If $split17[1] <> $split2[1] Then
							$aCoords[$iXc][$iYc] = 0
							$aCoords[$iXc][$iYc + 1] = 777777
							$aCoords[$iXc][$iYc2 - 1] = 0
							If $split3[1] = $split17[1] Then
								$aCoords[$iXc][$iYc2 - 2] = 777777
								$iYc = $iYc2
								ExitLoop
							EndIf
						EndIf
					EndIf
				Next
			EndIf
			$count = 0
		Next
	Next
	For $iYc = 0 To $iY - 1
		For $iXc = 0 To $iX - 1
			If $aCoords[$iXc][$iYc] = 999999 Then
				;
				If $aCoords[$iXc][$iYc] = 777777 And $count = 0 Then
					$count = $count + 1
					$split17 = StringSplit($aCoords[$iXc][$iYc], ',', 1)

					For $iXc2 = $iXc To $iX
						If $aCoords[$iXc2][$iYc] = 0 Then
							$split0 = StringSplit($aCoords[$iXc2][$iYc], ',', 1)
							$split1 = StringSplit($aCoords[$iXc + 1][$iYc], ',', 1)
							$split2 = StringSplit($aCoords[$iXc2 - 1][$iYc], ',', 1)
							$split3 = StringSplit($aCoords[$iXc2 - 2][$iYc], ',', 1)
							If $split17[1] <> $split2[1] Then
								$aCoords[$iXc][$iYc] = 0
								$aCoords[$iXc + 1][$iYc] = 777777
								$aCoords[$iXc2 - 1][$iYc] = 0
								If $split3[1] = $split17[1] Then
									$aCoords[$iXc2 - 2][$iYc] = 777777
									$iXc = $iXc2
									ExitLoop
								EndIf
								$iXc = $iXc2
								ExitLoop
							EndIf
						EndIf
					Next
				EndIf
			EndIf
			$count = 0
		Next
	Next


	_ArrayDisplay($aCoords, Default, Default, 1)

	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 777777 Then
				For $iYc2 = $iYc To $iY - 1
					If $aCoords[$iXc][$iYc2] = 0 Then
						If $aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1)] = 777777 Then
							$aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1)] = 777777
							$iYc = $iYc2
							ExitLoop
						Else
							$aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2) - 1)] = 111111 ; eher rechts ausgerichtet
							$iYc = $iYc2
							ExitLoop
						EndIf
					EndIf
				Next
			EndIf
		Next
	Next
	For $iYc = 0 To $iY - 1
		For $iXc = 0 To $iX - 1
			If $aCoords[$iXc][$iYc] = 777777 Then
				For $iXc2 = $iXc To $iX - 1
					If $aCoords[$iXc2][$iYc] = 0 Then
						If $aCoords[($iXc - 1) + Ceiling(Round(($iXc2 - $iXc) / 2))][$iYc] = 777777 Then
							$aCoords[($iXc - 1) + Ceiling(Round(($iXc2 - $iXc) / 2))][$iYc] = 777777
							$iXc = $iXc2
							ExitLoop
						Else
							$aCoords[($iXc - 1) + Ceiling(Round(($iXc2 - $iXc) / 2))][$iYc] = 222222 ; eher rechts ausgerichtet
							$iXc = $iXc2
							ExitLoop
						EndIf
					EndIf
				Next

			EndIf
		Next
	Next

	_ArrayDisplay($aCoords, Default, Default, 1)

	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 777777 Or $aCoords[$iXc][$iYc] = 999999 Then
				$aCoords[$iXc][$iYc] = 0
			Else
				;$aCoords[$iXc][$iYc] = 888888
			EndIf
		Next
	Next

	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 111111 Then

				For $iYc2 = $iYc To $iY - 1
					If $aCoords[$iXc][$iYc2] = 0 Then
						$aCoords[$iXc][$iYc + Ceiling(Round(($iYc2 - $iYc) / 2))] = 111111
						$iYc = $iYc2
						ExitLoop
					ElseIf $aCoords[$iXc][$iYc2] = 111111 Then
						$aCoords[$iXc][$iYc2] = 0
					EndIf
				Next
			EndIf
		Next
	Next
	For $iYc = 0 To $iY - 1
		For $iXc = 0 To $iX - 1
			If $aCoords[$iXc][$iYc] = 111111 Then
				For $iXc2 = $iXc To $iX - 1
					If $aCoords[$iXc2][$iYc] = 0 Then
						$aCoords[$iXc + Ceiling(Round(($iXc2 - $iXc) / 2))][$iYc] = 111111
						$iXc = $iXc2
						ExitLoop
					ElseIf $aCoords[$iXc2][$iYc] = 111111 Then
						$aCoords[$iXc2][$iYc] = 0
					EndIf
				Next
			EndIf
		Next
	Next
	_ArrayDisplay($aCoords, Default, Default, 1)
	For $iXc = 0 To $iX - 1
		For $iYc = 0 To $iY - 1
			If $aCoords[$iXc][$iYc] = 111111 Then
				FileWrite($File, $iXc & "," & $iYc & @CRLF)
			EndIf
		Next
	Next


	Dim $aRec
	If Not _FileReadToArray(@ScriptDir & "\cRand.txt", $aRec) Then
		MsgBox(4096, "Fehler", "Fehler beim Einlesen der Datei in das Array!" & @CRLF & "Fehlercode: " & @error)
		Exit
	EndIf
	For $x = 1 To $aRec[0]
		$split = StringSplit($aRec[$x], ',', 1)
		$aCoords[$split[1]][$split[2]] = 999999
		;MsgBox(0, 'Datensatz ' & $x & ':', $aRec[$x])
	Next


_ArrayDisplay($aCoords, Default, Default, 1)
	FileClose($File)
EndFunc   ;==>_Main





; Gibt eine Zeile im Memo-Fenster aus
Func MemoWrite($sMessage = '')
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
EndFunc   ;==>MemoWrite
; _GDIPlus_GetPixel
Func _GDIPlus_GetPixel($hBitmap, $x, $Y)
	Local $result = DllCall($ghGDIPDLL, "int", "GdipBitmapGetPixel", "ptr", $hBitmap, "int", $x, "int", $Y, "dword*", 0)
	If @error Then Return SetError(1, 0, 0)
	Return SetError($result[0], 1, $result[4])
EndFunc   ;==>_GDIPlus_GetPixel
;SetPixel
Func SetPixel($oForm, $x, $Y, $color)
	$dc = DllCall("user32.dll", "int", "GetDC", "hwnd", $oForm)
	$setpixel = DllCall("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $x, "long", $Y, "long", $color)
	$realesedc = DllCall("user32.dll", "int", "ReleaseDC", "hwnd", 0, "int", $dc[0])
EndFunc   ;==>SetPixel
