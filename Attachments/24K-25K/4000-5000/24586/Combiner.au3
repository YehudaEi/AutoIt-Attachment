#include <GDIPlus.au3>
#include <color.au3>
Global $Progress
Global $TotalIterations
_GDIPlus_Startup()
MsgBox(64, "Introduction", "This program will combine 3 images into one image, each image seperated into its own channel" & @CRLF & _
		"The first image you choose will be the template for the output image (format & size)")

Local $images[3]
For $i = 0 To 2
	$fname = FileOpenDialog("First image", "", "All images (*.jpg;*.png;*.gif;*.bmp;)")
	If $fname = "" Then close()
	$images[$i] = _GDIPlus_ImageLoadFromFile($fname)
Next

Opt("GUIOnEventMode", 1)

$hwnd = GUICreate("Working...", 300, 50)
$progressbar = GUICtrlCreateProgress(10, 5, 280, 40)
GUISetOnEvent(-3, "close")
GUISetState()
AdlibEnable("update", 50)

CombineBitmaps($images[0], $images[1], $images[2])
$fname = FileSaveDialog("Process complete!", "", "PNG image(*.png;)|JPEG image(*.jpg;*.jpeg;)|Uncompressed Bitmap(*.bmp;)",16)
If $fname = "" Then close()
_GDIPlus_ImageSaveToFile($images[0], $fname)
close()

Func update()
	GUICtrlSetData($progressbar, ($Progress / $TotalIterations) * 100)
EndFunc   ;==>update



Func close()
	For $i = 0 To 2
		If $images[$i] <> 0 Then _GDIPlus_ImageDispose($images[$i])
	Next
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>close

Func CombineBitmaps($bm1, $bm2, $bm3)
	$w = _GDIPlus_ImageGetWidth($bm1)
	$h = _GDIPlus_ImageGetHeight($bm1)
	Local $aData[$w][$h]
	$TotalIterations = ($w * $h) * 4
	
	For $i = 0 To 2 Step 1
		
		$bm = Eval("bm" & $i + 1)
		
		$w = _GDIPlus_ImageGetWidth($bm)
		$h = _GDIPlus_ImageGetHeight($bm)
		
		
		$BitmapData = _GDIPlus_BitmapLockBits($bm, 0, 0, $w, $h, $GDIP_ILMREAD, $GDIP_PXF32RGB)
		$Stride = DllStructGetData($BitmapData, "Stride")
		$Scan0 = DllStructGetData($BitmapData, "Scan0")
		For $row = 0 To $h - 1
			For $col = 0 To $w - 1
				$Progress += 1
				$pixel = DllStructCreate("dword", $Scan0 + $row * $Stride + $col * 4)
				$temp = "0x" & Hex((DllStructGetData($pixel, 1)))
				$average = Hex((_ColorGetRed($temp) + _ColorGetGreen($temp) + _ColorGetBlue($temp)) / 3, 2)
				Switch $i
					Case 0
						$aData[$col][$row] = BitXOR($aData[$col][$row], "0x" & $average & "0000")
					Case 1
						$aData[$col][$row] = BitXOR($aData[$col][$row], "0x00" & $average & "00")
					Case 2
						$aData[$col][$row] = BitXOR($aData[$col][$row], "0x0000" & $average)
				EndSwitch
				
				
			Next
		Next
		_GDIPlus_BitmapUnlockBits($bm, $BitmapData)
	Next

	
	
	$BitmapData = _GDIPlus_BitmapLockBits($bm1, 0, 0, $w, $h, $GDIP_ILMWRITE, $GDIP_PXF32RGB)
	$Stride = DllStructGetData($BitmapData, "Stride")
	$Scan0 = DllStructGetData($BitmapData, "Scan0")

	For $row = 0 To $h - 1
		For $col = 0 To $w - 1
			$Progress += 1
			$pixel = DllStructCreate("dword", $Scan0 + $row * $Stride + $col * 4)
			DllStructSetData($pixel, 1, $aData[$col][$row])
		Next
	Next
	_GDIPlus_BitmapUnlockBits($bm1, $BitmapData)
	
EndFunc   ;==>CombineBitmaps