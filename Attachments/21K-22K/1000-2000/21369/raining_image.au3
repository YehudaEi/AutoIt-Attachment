; Author: Andreas Karlsson (monoceres)
; License: Feel free to whatever you want with this source as long as you in some way give credit back to me.
; Note: Don't use this source for anything important, it's extremely messy and have some problems.


#include <GDIPlus.au3>
#include <WinAPI.au3>
$filename=FileOpenDialog("Image to rain","","Files (*.jpg;*.jpeg;*.gif;*.png;*.bmp)")
If $filename="" Then Exit
$size=InputBox("Size of GUI","Please select the size of the GUI (bigger size=longer processing time)","300x300")
If $size="" Or Not StringInStr($size,"x") Then Exit
$sizea=StringSplit($size,"x")

Global Const $width = $sizea[1], $height = $sizea[2]
Global $pixel[$width * $height][2 + 1 + 2]
; 0 = Color
; 1 = X goal ( and pos )
; 2 = Y pos
; 3 = Y speed
; 4 = Y Goal

Opt("GuiOnEventMode", 1)
$hwnd = GUICreate("Rainy Image", $width, $height)

GUISetOnEvent(-3, "close")
GUISetState()


_GDIPlus_Startup()
$image = _GDIPlus_ImageLoadFromFile($filename)
$imagegraphics = _GDIPlus_ImageGetGraphicsContext($image)
$graphics = _GDIPlus_GraphicsCreateFromHWND($hwnd)
$backgroundbitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
$background = _GDIPlus_ImageGetGraphicsContext($backgroundbitmap)
$backbufferbitmap = _GDIPlus_BitmapCreateFromGraphics($width, $height, $graphics)
$backbuffer = _GDIPlus_ImageGetGraphicsContext($backbufferbitmap)
_GDIPlus_GraphicsDrawImageRect($graphics, $image, 0, 0, $width, $height)

SplashTextOn("Info","Loading pixel data into memory, this could take a while...",200,75,-1,-1,1)
; Fill upp pixel array
Local $inc = 0
$dc = _GDIPlus_GraphicsGetDC($graphics)
$dll = DllOpen("Gdi32.dll")
For $i = 0 To $width - 1
	For $j = 0 To $height - 1
		$temp = DllCall($dll, "int", "GetPixel", "ptr", $dc, "int", $i, "int", $j)
		$pixel[$inc][0] = $temp[0]
		$pixel[$inc][1] = $i
		$pixel[$inc][2] = 0
		$pixel[$inc][3] = Random(3, 8)
		$pixel[$inc][4] = $j
		$inc += 1
	Next
Next
Local $temp[6]
SplashOff()

_GDIPlus_GraphicsReleaseDC($graphics, $dc)
_GDIPlus_GraphicsClear($graphics)


SplashTextOn("Info","Randomizing pixel data, this could also take a while...",200,75,-1,-1,1)

For $a = 0 To $width * $height * 4
	$r = Random(0, $inc-1, 1)
	$s = Random(0, $inc-1, 1)
	For $i = 0 To 4
		$temp[$i] = $pixel[$s][$i]
		$pixel[$s][$i] = $pixel[$r][$i]
		$pixel[$r][$i] = $temp[$i]
	Next
Next
SplashOff()


Local $tarray[444][6]

For $i = 0 To UBound($tarray) - 1
	For $j = 0 To UBound($pixel, 2) - 1
		$tarray[$i][$j] = $pixel[$i][$j]
	Next
Next
$position = UBound($tarray)



Do
;~ 	Sleep(20) ; No sleep, sorry guys, need the POWER!
	_GDIPlus_GraphicsClear($backbuffer, 0xFF000000)
	_GDIPlus_GraphicsDrawImageRect($backbuffer, $backgroundbitmap, 0, 0, $width, $height)
	
	$dc = _GDIPlus_GraphicsGetDC($backbuffer)
	
	For $i = 0 To UBound($tarray) - 1
		
		If $tarray[$i][2] >= $tarray[$i][4] Then
			$dc2 = _GDIPlus_GraphicsGetDC($background)
			DllCall($dll, "int", "SetPixel", "ptr", $dc2, "int", $tarray[$i][1], "int", $tarray[$i][4], "dword", $tarray[$i][0])
			If $position<=Ubound($pixel)-1 Then
			For $w = 0 To 4
				$tarray[$i][$w] = $pixel[$position][$w]
			Next


			$position += 1
			EndIf
			

			_GDIPlus_GraphicsReleaseDC($background, $dc2)
		ElseIf $tarray[$i][2] < $tarray[$i][4] Then
			$tarray[$i][2] += $tarray[$i][3]
			DllCall($dll, "int", "SetPixel", "ptr", $dc, "int", $tarray[$i][1], "int", $tarray[$i][2], "dword", $tarray[$i][0])
		Else

		EndIf

	Next
	_GDIPlus_GraphicsReleaseDC($backbuffer, $dc)
	
	
	_GDIPlus_GraphicsDrawImageRect($graphics, $backbufferbitmap, 0, 0, $width, $height)

Until False


Func close()
	_GDIPlus_GraphicsDispose($background)
	_WinAPI_DeleteObject($backbufferbitmap)
	_GDIPlus_GraphicsDispose($imagegraphics)
	_GDIPlus_ImageDispose($image)
	_GDIPlus_GraphicsDispose($backbuffer)
	_WinAPI_DeleteObject($backbufferbitmap)
	_GDIPlus_GraphicsDispose($graphics)
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>close




