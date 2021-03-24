;~ Author:				Ian Maxwell (llewxam @ AutoIt forum)
;~ Created:				Feb 10 2014
;~ AutoIt version:		3.3.10.2
;~ Purpose:				Automate creating UPC bitmaps
;~ Use:					upc_bmp.exe {12-digit UPC code}
;~ Result:				Scannable UPC code small enough to fit on return address labels; on invalid UPC code the
;~ 						image will still be created but will contain what the check bit should be

#include <GDIPlus.au3>

If $CmdLine[0] Then
	If StringLen($CmdLine[1]) <> 12 Then Exit
	$GetCode = $CmdLine[1]
Else
	Exit
EndIf
;~ comment the above section and uncomment either of the below to test without compiling or running in command prompt
;~ $GetCode=862626001563 ;this code is not valid, just here to demonstrate a bad code
;~ $GetCode=212456765437 ;this code is valid

_GDIPlus_Startup()
Local Const $iWidth = 190, $iHeight = 16
Local $hBitmap = _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight)
Local $hBmpCtxt = _GDIPlus_ImageGetGraphicsContext($hBitmap)
_GDIPlus_GraphicsSetSmoothingMode($hBmpCtxt, 0)
_GDIPlus_GraphicsClear($hBmpCtxt, 0xFFFFFFFF)

_Verify($GetCode)
_Draw($GetCode)

Func _Draw($aUPC)
	$Break = StringSplit($aUPC, "", 2)

	For $a = 0 To 15 ;start
		_GDIPlus_BitmapSetPixel($hBitmap, 0, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 5, $a, 0x000000)
	Next
	For $a = 0 To 15 ;middle
		_GDIPlus_BitmapSetPixel($hBitmap, 92, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 93, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 96, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 97, $a, 0x000000)
	Next
	For $a = 0 To 15 ;end
		_GDIPlus_BitmapSetPixel($hBitmap, 184, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 185, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 188, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, 189, $a, 0x000000)
	Next

	For $a = 0 To 5
		If $Break[$a] == 0 Then _Zero(($a * 14) + 6)
		If $Break[$a] == 1 Then _One(($a * 14) + 6)
		If $Break[$a] == 2 Then _Two(($a * 14) + 6)
		If $Break[$a] == 3 Then _Three(($a * 14) + 6)
		If $Break[$a] == 4 Then _Four(($a * 14) + 6)
		If $Break[$a] == 5 Then _Five(($a * 14) + 6)
		If $Break[$a] == 6 Then _Six(($a * 14) + 6)
		If $Break[$a] == 7 Then _Seven(($a * 14) + 6)
		If $Break[$a] == 8 Then _Eight(($a * 14) + 6)
		If $Break[$a] == 9 Then _Nine(($a * 14) + 6)
	Next

	For $a = 6 To 11
		If $Break[$a] == 0 Then _Zeroi(($a * 14) + 16)
		If $Break[$a] == 1 Then _Onei(($a * 14) + 16)
		If $Break[$a] == 2 Then _Twoi(($a * 14) + 16)
		If $Break[$a] == 3 Then _Threei(($a * 14) + 16)
		If $Break[$a] == 4 Then _Fouri(($a * 14) + 16)
		If $Break[$a] == 5 Then _Fivei(($a * 14) + 16)
		If $Break[$a] == 6 Then _Sixi(($a * 14) + 16)
		If $Break[$a] == 7 Then _Seveni(($a * 14) + 16)
		If $Break[$a] == 8 Then _Eighti(($a * 14) + 16)
		If $Break[$a] == 9 Then _Ninei(($a * 14) + 16)
	Next

	Local $sFile = @ScriptDir & "\" & $aUPC & ".bmp"
	_GDIPlus_ImageSaveToFile($hBitmap, $sFile)
	_GDIPlus_GraphicsDispose($hBmpCtxt)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()
EndFunc   ;==>_Draw
Exit


Func _Zero($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Zero

Func _One($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_One

Func _Two($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Two

Func _Three($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Three

Func _Four($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Four

Func _Five($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Five

Func _Six($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Six

Func _Seven($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Seven

Func _Eight($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Eight

Func _Nine($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 12, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 13, $a, 0x000000)
	Next
EndFunc   ;==>_Nine

Func _Zeroi($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
	Next
EndFunc   ;==>_Zeroi

Func _Onei($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
	Next
EndFunc   ;==>_Onei

Func _Twoi($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
	Next
EndFunc   ;==>_Twoi

Func _Threei($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
	Next
EndFunc   ;==>_Threei

Func _Fouri($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
	Next
EndFunc   ;==>_Fouri

Func _Fivei($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 10, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 11, $a, 0x000000)
	Next
EndFunc   ;==>_Fivei

Func _Sixi($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
	Next
EndFunc   ;==>_Sixi

Func _Seveni($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
	Next
EndFunc   ;==>_Seveni

Func _Eighti($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 6, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 7, $a, 0x000000)
	Next
EndFunc   ;==>_Eighti

Func _Ninei($aHor)
	For $a = 0 To 9
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 1, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 2, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 3, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 4, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 5, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 8, $a, 0x000000)
		_GDIPlus_BitmapSetPixel($hBitmap, $aHor + 9, $a, 0x000000)
	Next
EndFunc   ;==>_Ninei

Func _Verify($aUPC)
	$UPCArray = StringSplit($aUPC, "", 2)
	$odd = ($UPCArray[0] + $UPCArray[2] + $UPCArray[4] + $UPCArray[6] + $UPCArray[8] + $UPCArray[10]) * 3
	$total = $odd + $UPCArray[1] + $UPCArray[3] + $UPCArray[5] + $UPCArray[7] + $UPCArray[9]
	$Mod = Mod($total, 10)
	If $Mod == 0 Then
		$CheckBit = 0
	Else
		$CheckBit = 10 - $Mod
	EndIf

	If $UPCArray[11] <> $CheckBit Then
		_GDIPlus_GraphicsDrawString($hBmpCtxt, $aUPC & " check bit should be " & $CheckBit, 0, 0, "Comic Sans MS", 7.5)
		Local $sFile = @ScriptDir & "\" & $aUPC & ".bmp"
		_GDIPlus_ImageSaveToFile($hBitmap, $sFile)
		_GDIPlus_GraphicsDispose($hBmpCtxt)
		_GDIPlus_BitmapDispose($hBitmap)
		_GDIPlus_Shutdown()
		Exit
	EndIf
EndFunc   ;==>_Verify
