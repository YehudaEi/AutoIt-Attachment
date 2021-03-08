#include-once
#include "WinAPI.au3"	; used by mark_Rect
#include <Misc.au3>	; used by mark_Rect
#include <WindowsConstants.au3>	; used by mark_Rect

#cs
;Uncommenting this code will give a short demo of the functions
; Generate a pattern from a screen area selected with the mouse
$pattern = patternFindGenerate()
; Search within a larger screen area (again mouse selected) for the original pattern
local $xStart=0, $yStart=0, $xEnd=0, $yEnd=0
Mark_Rect($xStart, $yStart, $xEnd, $yEnd)
$result = PatternFind($xStart, $yStart, $xEnd, $yEnd, $pattern)
; Result will be 0,0 if pattern is not found
ConsoleWrite (@CRLF & "Result: " & $result[0] & "," & $result[1] & @CRLF)
#ce

Func patternFindGenerate($xStart = 0, $yStart = 0, $xEnd = 0, $yEnd = 0)
	If $xStart = 0 Then Mark_Rect($xStart, $yStart, $xEnd, $yEnd)

	$width = $xEnd - $xStart + 1
	$height = $yEnd - $yStart + 1

	If $height < $width Then
		$smallDimen = $height
	Else
		$smallDimen = $width
	EndIf

	$stepSize = Int(($smallDimen + 1) / 2)
	$shortChecksum = PixelChecksum($xStart, $yStart, $xStart + $width, $yStart + $height, $stepSize)
	$fullChecksum = PixelChecksum($xStart, $yStart, $xStart + $width, $yStart + $height)

	$pattern = $width & "," & $height & "," & $shortChecksum & "," & $fullChecksum

	Return $pattern
EndFunc   ;==>patternMatchGet


Func PatternFind($xStart, $yStart, $xEnd, $yEnd, $pattern)
	;$pattern = "$width,$height,$shortChecksum,$fullChecksum"
	Dim $result[3]
	$comma1Loc = StringInStr($pattern, ",", 0, 1)
	$comma2Loc = StringInStr($pattern, ",", 0, 2)
	$comma3Loc = StringInStr($pattern, ",", 0, 3)
	$width = int(StringLeft($pattern, $comma1Loc - 1))
	$height = int(StringMid($pattern, $comma1Loc + 1, $comma2Loc - $comma1Loc - 1))
	$shortChecksum = int(StringMid($pattern, $comma2Loc + 1, $comma3Loc - $comma2Loc - 1))
	$fullChecksum = int(StringMid($pattern, $comma3Loc + 1))

	If $height < $width Then
		$smallDimen = $height
	Else
		$smallDimen = $width
	EndIf


	; Search for a match
	$stepSize = Int(($smallDimen + 1) / 2)
	For $xIter = $xStart To $xEnd+1 - $width
		For $yIter = $yStart To $yEnd+1 - $height
			If $shortChecksum = PixelChecksum($xIter, $yIter, $xIter + $width, $yIter + $height, $stepSize) Then
				If $fullChecksum = PixelChecksum($xIter, $yIter, $xIter + $width, $yIter + $height) Then
					$result[0] = $xIter
					$result[1] = $yIter
					Return $result
				EndIf
			EndIf
		Next
	Next

	; No match found
	$result[0] = 0
	$result[1] = 0
	Return $result
EndFunc   ;==>PatternMatch

Func Mark_Rect(ByRef $iX1, ByRef $iY1, ByRef $iX2, ByRef $iY2)
;#include "WinAPI.au3"	; used by mark_Rect
;#include <Misc.au3>	; used by mark_Rect
;#include <WindowsConstants.au3>	; used by mark_Rect
	; function from Melba23 (http://www.autoitscript.com/forum/topic/135728-how-to-i-draw-one-rectangle-on-screen/)

	Local $aMouse_Pos, $hMask, $hMaster_Mask, $iTemp
	Local $UserDLL = DllOpen("user32.dll")

	; Create transparent GUI with Cross cursor
	$hCross_GUI = GUICreate("Test", @DesktopWidth, @DesktopHeight - 20, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
	WinSetTrans($hCross_GUI, "", 8)
	GUISetState(@SW_SHOW, $hCross_GUI)
	GUISetCursor(3, 1, $hCross_GUI)

	Global $hRectangle_GUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	GUISetBkColor(0x000000)

	; Wait until mouse button pressed
	While Not _IsPressed("01", $UserDLL)
		Sleep(10)
	WEnd

	; Get first mouse position
	$aMouse_Pos = MouseGetPos()
	$iX1 = $aMouse_Pos[0]
	$iY1 = $aMouse_Pos[1]

	; Draw rectangle while mouse button pressed
	While _IsPressed("01", $UserDLL)

		$aMouse_Pos = MouseGetPos()

		$hMaster_Mask = _WinAPI_CreateRectRgn(0, 0, 0, 0)
		$hMask = _WinAPI_CreateRectRgn($iX1, $aMouse_Pos[1], $aMouse_Pos[0], $aMouse_Pos[1] + 1) ; Bottom of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1, $iY1, $iX1 + 1, $aMouse_Pos[1]) ; Left of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($iX1 + 1, $iY1 + 1, $aMouse_Pos[0], $iY1) ; Top of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		$hMask = _WinAPI_CreateRectRgn($aMouse_Pos[0], $iY1, $aMouse_Pos[0] + 1, $aMouse_Pos[1]) ; Right of rectangle
		_WinAPI_CombineRgn($hMaster_Mask, $hMask, $hMaster_Mask, 2)
		_WinAPI_DeleteObject($hMask)
		; Set overall region
		_WinAPI_SetWindowRgn($hRectangle_GUI, $hMaster_Mask)

		If WinGetState($hRectangle_GUI) < 15 Then GUISetState()
		Sleep(10)

	WEnd

	; Get second mouse position
	$iX2 = $aMouse_Pos[0]
	$iY2 = $aMouse_Pos[1]

	; Set in correct order if required
	If $iX2 < $iX1 Then
		$iTemp = $iX1
		$iX1 = $iX2
		$iX2 = $iTemp
	EndIf
	If $iY2 < $iY1 Then
		$iTemp = $iY1
		$iY1 = $iY2
		$iY2 = $iTemp
	EndIf

	GUIDelete($hRectangle_GUI)
	GUIDelete($hCross_GUI)
	DllClose($UserDLL)

EndFunc   ;==>Mark_Rect