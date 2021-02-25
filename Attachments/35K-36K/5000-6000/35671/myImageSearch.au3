#include-once
#include <ScreenCapture.au3>

; #INDEX# =======================================================================================================================
; Title .........: myImageSearch
; AutoIt Version: 3.3.6.1
; Script Version: 1.0  (31.10.2011)
; Language:       English, Polski.
; Description:    Search image.
; ===============================================================================================================================


; #CURRENT# =====================================================================================================================
; myImageSearch_Desktop
; myImageSearch_Picture
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: myImageSearch_Desktop
; Description ...: Znajdz obrazek na pulpicie.
; Syntax.........: myImageSearch_Desktop($Image, $x = 0, $y = 0, $iIW = @DesktopWidth, $iIH = @DesktopHeight, $TransColorRGB = '', $OnlyFirst = True)
; Parameters ....: $Image - znajdz obrazek: adres do szuaknego obrazka, lub bitmapa (format .bmp 24-bit)
;                  $x - lewe koordynaty [Default is 0 (pierwszy pixel).]
;                  $y - gorne koordynaty. [Default is 0 (pierwszy pixel).]
;                  $iIW - prawe koordynaty. [Default is @DesktopWidth.]
;                  $iIH - dolne koordynaty. [Default is @DesktopHeight.]
;                  $TransColorRGB - Kolor przezroczystosci / Ignorowany kolor. Musi byc string i format RGB. a.g: "0xFFFFFF".[Default is "".]
;                  $OnlyFirst - [Default is True.]
;                               |True = Success: Zwraca tablice 2-elementowa z koordynatami.
;                                		$array[0] =  x koordynaty
;                                		$array[1] =  y koordynaty
;                               |False = Success: Zwraca 2D tablice z koordynatami.
;                                		$array[0][0] =  1st x coordinate
;                                		$array[0][1] =  1st y coordinate
;                                		$array[1][0] =  2nd x coordinate
;                                		$array[1][1] =  2nd y coordinate
;                                		$array[3][0] =  3rd x coordinate
;                                		$array[3][1] =  3rd y coordinate
;                                		$array[n][0] =  nth x coordinate
;                                		$array[n][1] =  nth y coordinate
;
;                                UWAGA: Jesli uzyjesz "False" to max obszar przeszukiwania moze wynosic 800x600 pixeli, lub ekwiwalent max 480.000 pixeli!!!
;                                       Nie wiecej.
;
; Return values . : On Success - Zwrot tablica 2-elementowa z koordynatami lub 2D tablica z koordynatami.
;					On Failure - @Error = 1 - Sciezka do pliku jest bledna, lub bitmapa/obrazek jest bledna.
;								 @Error = 2 - Obrazka nie znaleziono (na pulpicie).
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: myImageSearch_Desktop
; Description ...: Image search in desktop.
; Syntax.........: myImageSearch_Desktop($Image, $x = 0, $y = 0, $iIW = @DesktopWidth, $iIH = @DesktopHeight, $TransColorRGB = '', $OnlyFirst = True)
; Parameters ....: $Image - search image: string adress for file, or bitmat (format .bmp 24-bit)
;                  $x - left coordinate. [Default is 0 (first pixel).]
;                  $y - top coordinate. [Default is 0 (first pixel).]
;                  $iIW - right coordinate. [Default is @DesktopWidth.]
;                  $iIH - bottom coordinate. [Default is @DesktopHeight.]
;                  $TransColorRGB - Color transparancy / Ignore color. Must be string and format RGB. a.g: "0xFFFFFF".[Default is "".]
;                  $OnlyFirst - [Default is True.]
;                               |True = Success: Returns a two-element array coordinates.
;                                		$array[0] =  x coordinate
;                                		$array[1] =  y coordinate
;                               |False = Success: Returns a 2D array coordinates.
;                                		$array[0][0] =  1st x coordinate
;                                		$array[0][1] =  1st y coordinate
;                                		$array[1][0] =  2nd x coordinate
;                                		$array[1][1] =  2nd y coordinate
;                                		$array[3][0] =  3rd x coordinate
;                                		$array[3][1] =  3rd y coordinate
;                                		$array[n][0] =  nth x coordinate
;                                		$array[n][1] =  nth y coordinate
;
;                                ATTENTION: If u use "False" max area for search must be 800x600 pixels, or equivalent maximal 480.000 pixels!!!
;                                           No more.
;
; Return values . : On Success - Returns two-element array coordinates, or 2D array coordinates.
;					On Failure - @Error = 1 - Path not found or invalid image/bitmap.
;								 @Error = 2 - Image not exist (in desktop).
; ===============================================================================================================================


Func myImageSearch_Desktop($Image, $x = 0, $y = 0, $iIW = @DesktopWidth, $iIH = @DesktopHeight, $TransColorRGB = '', $OnlyFirst = True)
	Local $hBMP, $hImage1, $aReturn, $error, $i
	_GDIPlus_Startup()
	$hBMP = _ScreenCapture_Capture("", $x, $y, $iIW + $x, $iIH + $y, False)
	$hImage1 = _GDIPlus_BitmapCreateFromHBITMAP($hBMP)
	$aReturn = myImageSearch_Picture($hImage1, $Image, 0, 0, $iIW, $iIH, $TransColorRGB, $OnlyFirst)
	$error = @error
	_GDIPlus_ImageDispose($hImage1)
	_WinAPI_DeleteObject($hBMP)
	_GDIPlus_Shutdown()

	Switch $error
		Case 0
			If $OnlyFirst Then
				$aReturn[0] += $x
				$aReturn[1] += $y
			Else
				For $i = 0 To UBound($aReturn, 1) - 1
					$aReturn[$i][0] += $x
					$aReturn[$i][1] += $y
				Next
			EndIf
			Return $aReturn
		Case 2
			Return SetError(1, 1, '')
		Case Else
			Return SetError(2, 2, '')
	EndSwitch

EndFunc   ;==>myImageSearch_Desktop


; #FUNCTION# ====================================================================================================================
; Name...........: myImageSearch_Picture
; Description ...: Znajdz obrazek na obrazku.
; Syntax.........: myImageSearch_Picture($hImage1, $hImage2, $x = 0, $y = 0, $iIW = 0, $iIH = 0, $TransColorRGB = '', $OnlyFirst = True)
; Parameters ....: $hImage1 - bazowy obrazek: adres do szuaknego obrazka, lub bitmapa (format .bmp 24-bit)
;                  $hImage2 - znajdz obrazek: adres do szuaknego obrazka, lub bitmapa (format .bmp 24-bit)
;                  $x - lewe koordynaty [Default is 0 (pierwszy pixel).]
;                  $y - gorne koordynaty. [Default is 0 (pierwszy pixel).]
;                  $iIW - prawe koordynaty. [Default is 0 (0 to ostani pixel (caly obrazek).]
;                  $iIH - dolne koordynaty. [Default is 0 (0 to ostani pixel (caly obrazek).]
;                  $TransColorRGB - Kolor przezroczystosci / Ignorowany kolor. Musi byc string i format RGB. a.g: "0xFFFFFF".[Default is "".]
;                  $OnlyFirst - [Default is True.]
;                               |True = Success: Zwraca tablice 2-elementowa z koordynatami.
;                                		$array[0] =  x koordynaty
;                                		$array[1] =  y koordynaty
;                               |False = Success: Zwraca 2D tablice z koordynatami.
;                                		$array[0][0] =  1st x coordinate
;                                		$array[0][1] =  1st y coordinate
;                                		$array[1][0] =  2nd x coordinate
;                                		$array[1][1] =  2nd y coordinate
;                                		$array[3][0] =  3rd x coordinate
;                                		$array[3][1] =  3rd y coordinate
;                                		$array[n][0] =  nth x coordinate
;                                		$array[n][1] =  nth y coordinate
;
;                                UWAGA: Jesli uzyjesz "False" to max obszar przeszukiwania moze wynosic 800x600 pixeli, lub ekwiwalent max 480.000 pixeli!!!
;                                       Nie wiecej.
;
; Return values . : On Success - Zwrot tablica 2-elementowa z koordynatami lub 2D tablica z koordynatami.
;					On Failure - @Error = 1 - 1 sciezka do pliku jest bledna, lub bitmapa/obrazek jest bledna.
;	        					 @Error = 2 - 2 sciezka do pliku jest bledna, lub bitmapa/obrazek jest bledna.
;                                @Error = 3 - Obrazka nie znaleziono (na obrazku).
; ===============================================================================================================================


; #FUNCTION# ====================================================================================================================
; Name...........: myImageSearch_Picture
; Description ...: Image search in picture.
; Syntax.........: myImageSearch_Picture($hImage1, $hImage2, $x = 0, $y = 0, $iIW = 0, $iIH = 0, $TransColorRGB = '', $OnlyFirst = True)
; Parameters ....: $hImage1 - base image: string adress for file, or bitmat (format .bmp 24-bit)
;                  $hImage2 - search image: string adress for file, or bitmat (format .bmp 24-bit)
;                  $x - left coordinate. [Default is 0 (first pixel).]
;                  $y - top coordinate. [Default is 0 (first pixel).]
;                  $iIW - right coordinate. [Default is 0 (0 is last pixel (full imege).]
;                  $iIH - bottom coordinate. [Default is 0 (0 is last pixel (full imege).]
;                  $TransColorRGB - Color transparancy / Ignore color. Must be string and format RGB. a.g: "0xFFFFFF".[Default is "".]
;                  $OnlyFirst - [Default is True.]
;                               |True = Success: Returns a two-element array coordinates.
;                                		$array[0] =  x coordinate
;                                		$array[1] =  y coordinate
;                               |False = Success: Returns a 2D array coordinates.
;                                		$array[0][0] =  1st x coordinate
;                                		$array[0][1] =  1st y coordinate
;                                		$array[1][0] =  2nd x coordinate
;                                		$array[1][1] =  2nd y coordinate
;                                		$array[3][0] =  3rd x coordinate
;                                		$array[3][1] =  3rd y coordinate
;                                		$array[n][0] =  nth x coordinate
;                                		$array[n][1] =  nth y coordinate
;
;                                ATTENTION: If u use "False" max area for search must be 800x600 pixels, or equivalent maximal 480.000 pixels!!!
;                                           No more.
;
; Return values . : On Success - Returns two-element array coordinates, or 2D array coordinates.
;					On Failure - @Error = 1 - 1st path not found or invalid image/bitmap.
;                  				 @Error = 2 - 2nd path not found or invalid image/bitmap.
;								 @Error = 3 - Image not exist (in picture).
; ===============================================================================================================================


Func myImageSearch_Picture($hImage1, $hImage2, $x = 0, $y = 0, $iIW = 0, $iIH = 0, $TransColorRGB = '', $OnlyFirst = True)
	Local $testiIW, $testiIH
	Local $hBitmap1, $Reslt, $width, $height, $stride, $format, $Scan0
	Local $iIW_2, $iIH_2, $hBitmap2, $Reslt2, $width2, $height2, $stride2, $format2, $Scan02
	Local $sREResult1, $sREResult2, $sREResult3

	_GDIPlus_Startup()

	If IsString($hImage1) Then
		$hImage1 = _GDIPlus_ImageLoadFromFile($hImage1)
	EndIf

	$testiIW = _GDIPlus_ImageGetWidth($hImage1)
	$testiIH = _GDIPlus_ImageGetHeight($hImage1)

	If $hImage2 = "" Or $testiIW = 0 Or $testiIH = 0 Then
		Return SetError(1, 1, '')
	EndIf

	If $iIW = 0 Or $testiIW < $iIW Then $iIW = $testiIW
	If $iIH = 0 Or $testiIH < $iIH Then $iIH = $testiIH

	$hBitmap1 = _GDIPlus_BitmapCloneArea($hImage1, 0, 0, $iIW, $iIH, $GDIP_PXF32ARGB)
	$Reslt = _GDIPlus_BitmapLockBits($hBitmap1, $x, $y, $iIW - $x, $iIH - $y, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)
	$width = DllStructGetData($Reslt, "width")
	$height = DllStructGetData($Reslt, "height")
	$stride = DllStructGetData($Reslt, "stride")
	$format = DllStructGetData($Reslt, "format")
	$Scan0 = DllStructGetData($Reslt, "Scan0")
	$sREResult1 = DllStructCreate("byte[" & $height * $width * 4 & "]", $Scan0); Create DLL structure for all pixels
	$sREResult1 = DllStructGetData($sREResult1, 1)
	_GDIPlus_BitmapUnlockBits($hBitmap1, $Reslt); releases the locked region
	_GDIPlus_ImageDispose($hImage1)
	_GDIPlus_ImageDispose($hBitmap1)

	If IsString($hImage2) Then
		$hImage2 = _GDIPlus_ImageLoadFromFile($hImage2)
	EndIf

	$iIW_2 = _GDIPlus_ImageGetWidth($hImage2)
	$iIH_2 = _GDIPlus_ImageGetHeight($hImage2)

	If $hImage2 = "" Or $iIW_2 = 0 Or $iIH_2 = 0 Then
		Return SetError(2, 2, '')
	EndIf

	$hBitmap2 = _GDIPlus_BitmapCloneArea($hImage2, 0, 0, $iIW_2, $iIH_2, $GDIP_PXF32ARGB)
	$Reslt2 = _GDIPlus_BitmapLockBits($hBitmap2, 0, 0, $iIW_2, $iIH_2, BitOR($GDIP_ILMREAD, $GDIP_ILMWRITE), $GDIP_PXF32ARGB)
	$width2 = DllStructGetData($Reslt2, "width")
	$height2 = DllStructGetData($Reslt2, "height")
	$stride2 = DllStructGetData($Reslt2, "stride")
	$format2 = DllStructGetData($Reslt2, "format")
	$Scan02 = DllStructGetData($Reslt2, "Scan0")
	$sREResult2 = DllStructCreate("byte[" & $height2 * $width2 * 4 & "]", $Scan02); Create DLL structure for all pixels
	$sREResult2 = DllStructGetData($sREResult2, 1)
	_GDIPlus_BitmapUnlockBits($hBitmap2, $Reslt2); releases the locked region
	_GDIPlus_ImageDispose($hImage2)
	_GDIPlus_ImageDispose($hBitmap2)

	_GDIPlus_Shutdown()

	$sREResult1 = StringTrimLeft($sREResult1, 2)
	$sREResult2 = StringTrimLeft($sREResult2, 2)

	If IsString($TransColorRGB) Then ; ignore color
		$TransColorRGB = StringRegExpReplace($TransColorRGB, "0x(.{2})(.{2})(.{2})", "\3\2\1FF")
		If $TransColorRGB Then
			$sREResult2 = StringRegExpReplace($sREResult2, "(.{8})", "\1 ")
			$sREResult2 = StringReplace($sREResult2, $TransColorRGB, "........")
			$sREResult2 = StringReplace($sREResult2, " ", "")
		EndIf
	EndIf
	;ConsoleWrite($sREResult2 & @CRLF)

	$sREResult2 = StringRegExpReplace($sREResult2, "(.{" & $iIW_2 * 8 & "})", "\\Q\1\\E.\{" & ($iIW - $iIW_2) * 8 & "\}")
	$sREResult2 = StringTrimRight($sREResult2, StringLen(($iIW - $iIW_2) * 8) + 3)
	;ConsoleWrite($sREResult2 & @CRLF)

	If $TransColorRGB Then
		$sREResult2 = StringReplace($sREResult2, "........", "\E........\Q")
		$sREResult2 = StringReplace($sREResult2, "\Q\E", "")
		$sREResult2 = StringRegExpReplace($sREResult2, "([.}{\w]*)([\\].*[E])([.}{\w]*)", "\2") ; obcina kropki
	EndIf
	;ConsoleWrite($sREResult2 & @CRLF)

	If $OnlyFirst Then
		$sREResult2 = '(?i)(.*?)' & $sREResult2 & ".*"
		;ConsoleWrite($sREResult2 & @CRLF)

		$sREResult3 = StringRegExpReplace($sREResult1, $sREResult2, "\1") ; test pathern ("first")

		If Not @extended Then Return SetError(3, 3, '') ; extendet zero to nie znaleziono nic

		$sREResult3 = StringLen($sREResult3) / 8
		Local $pozycja_Y = Int($sREResult3 / $iIW) + $y
		Local $pozycja_X = Int($sREResult3 - $pozycja_Y * $iIW) + ($y * $iIW)
		Local $aReturn[2] = [$pozycja_X, $pozycja_Y]

	Else

		$sREResult2 = '(?i)(.*?)(' & $sREResult2 & ".*?)" ; wersja dla wielu winikow
		;ConsoleWrite($sREResult2 & @CRLF)

		$sREResult3 = StringRegExp($sREResult1, $sREResult2, 3) ; test pathern ("mulit")

		If @error Or Not IsArray($sREResult3) Then Return SetError(3, 3, '')

		Local $ile = UBound($sREResult3)
		Local $i
		Local $aReturn[$ile / 2][2]
		Local $sREResult4 = 0
		Local $pozycja_Y
		Local $pozycja_X

		For $i = 0 To $ile - 1 Step 2
			$sREResult4 += StringLen($sREResult3[$i]) / 8
			If $i > 0 Then $sREResult4 += StringLen($sREResult3[$i + 1]) / 8

			$pozycja_Y = Int($sREResult4 / $iIW) + $y
			$pozycja_X = Int($sREResult4 - $pozycja_Y * $iIW) + ($y * $iIW)
			$aReturn[$i / 2][0] = $pozycja_X
			$aReturn[$i / 2][1] = $pozycja_Y
		Next

	EndIf
	Return $aReturn
EndFunc   ;==>myImageSearch_Picture
