#include-once
#include <Fasm.au3>
#include <GDIP.au3>

Global Const $tagGDIPCONVOLUTIONMATRIX = _
	"int TopLeft;int TopMid;int TopRight;int MidLeft;int Pixel;" & _
	"int MidRight;int BottomLeft;int BottomMid;int BottomRight;" & _
	"int Factor;int Offset;"

Global Enum $Lossy, $HorzOnly, $VertOnly, $HorzVert, $AllDirections

Global $__CM_Fasm, $__CM_pConv

#region Public Functions

Func _Image_EdgeDetection($hImage, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(1, 1, 1, 0, 0, 0, -1, -1, -1, 1, 127)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_Emboss($hImage, $iDir = $HorzVert, $iCount = 1)
	Local $hImgRet, $tCM

	Switch $iDir
		Case $Lossy
			$tCM = _ConvolutionMatrix_Create(1, -2, 1, -2, 4, -2, -2, 1, -2, 1, 127)

		Case $HorzOnly
			$tCM = _ConvolutionMatrix_Create(0, 0, 0, -1, 2, -1, 0, 0, 0, 1, 127)

		Case $VertOnly
			$tCM = _ConvolutionMatrix_Create(0, -1, 0, 0, 0, 0, 0, 1, 0, 1, 127)

		Case $HorzVert
			$tCM = _ConvolutionMatrix_Create(0, -1, 0, -1, 4, -1, 0, -1, 0, 1, 127)

		Case $AllDirections
			$tCM = _ConvolutionMatrix_Create(-1, -1, -1, -1, 8, -1, -1, -1, -1, 1, 127)

		Case Else
			$tCM = _ConvolutionMatrix_Create(0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0)
	EndSwitch

	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_GaussianBlur($hImage, $iWeight = 4, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(1, 2, 1, 2, $iWeight, 2, 1, 2, 1, $iWeight+12, 0)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_Laplacian($hImage, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(1, 0, 1, 0, -4, 0, 1, 0, 1, 1, 0)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_MeanRemoval($hImage, $iWeight = 9, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(-1, -1, -1, -1, $iWeight, -1, -1, -1, -1, $iWeight-8, 0)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_Sharpen($hImage, $iWeight = 11, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(0, -2, 0, -2, $iWeight, -2, 0, -2, 0, $iWeight-8, 0)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

Func _Image_Smooth($hImage, $iWeight = 1, $iCount = 1)
	Local $hImgRet, $tCM

	$tCM = _ConvolutionMatrix_Create(1, 1, 1, 1, $iWeight, 1, 1, 1, 1, $iWeight+8, 0)
	$hImgRet = _ImageConvolution($hImage, $tCM, $iCount)
	If @error Then Return SetError(@error, 0, 0)
	Return $hImgRet
EndFunc

#endregion Public Functions
; splitter
#region Internal Functions

Func _ConvolutionMatrix_Create($tl, $tm, $tr, $ml, $p, $mr, $bl, $bm, $br, $f, $o)
	Local $tConvMatrix, $iI, $aFields[12] = [0, $tl, $tm, $tr, $ml, $p, $mr, $bl, $bm, $br, $f, $o]

	$tConvMatrix = DllStructCreate($tagGDIPCONVOLUTIONMATRIX)
	For $iI = 1 To UBound($aFields)-1
		DllStructSetData($tConvMatrix, $iI, $aFields[$iI])
	Next

	Return $tConvMatrix
EndFunc

Func _ImageConvolution($hImage, ByRef $tCM, $iCount = 1)
	Local $hClone, $pCM

	If $__CM_pConv = 0 Then
		__CompileConvolution($__CM_Fasm)
		If @error Then Return SetError(@error, 0, 0)
		$__CM_pConv = FasmGetFuncPtr($__CM_Fasm)
	EndIf

	If $iCount < 1 Then $iCount = 1
	$hClone = _GDIPlus_ImageClone($hImage)
	If Not $hClone Then Return SetError(3, 0, 0)

	$pCM = DllStructGetPtr($tCM)

	For $i = 1 To $iCount
		$Ret = MemoryFuncCall("bool", $__CM_pConv, "ptr", $hClone, "ptr", $pCM)
		If Not $Ret[0] Then ExitLoop
	Next

	If $Ret[0] Then
		Return SetError(0, 0, $hClone)
	Else
		_GDIPlus_ImageDispose($hClone)
		Return SetError(4, 0, 0)
	EndIf
EndFunc

Func _WinAPI_GetProcAddress($hModule, $sProcedure)
	Local $aResult = DllCall("kernel32.dll", "ptr", "GetProcAddress", "handle", $hModule, "str", $sProcedure)

	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc

Func __CompileConvolution(ByRef $FasmObj)
	Local $hGDIP = _WinAPI_GetModuleHandle("gdiplus.dll")

	If $hGDIP = 0 Then
		_GDIPlus_Startup()
		$hGDIP = _WinAPI_GetModuleHandle("gdiplus.dll")
		If $hGDIP = 0 Then Return SetError(1, 0, False)
	EndIf

	Local $pBitmapLockBits = _WinAPI_GetProcAddress($hGDIP, "GdipBitmapLockBits"), _
	  $pBitmapUnlockBits = _WinAPI_GetProcAddress($hGDIP, "GdipBitmapUnlockBits"), _
	  $pCloneImage = _WinAPI_GetProcAddress($hGDIP, "GdipCloneImage"), _
	  $pDisposeImage = _WinAPI_GetProcAddress($hGDIP, "GdipDisposeImage"), _
	  $pGetImageHeight = _WinAPI_GetProcAddress($hGDIP, "GdipGetImageHeight"), _
	  $pGetImageWidth = _WinAPI_GetProcAddress($hGDIP, "GdipGetImageWidth")

	Local $sSource = ""
	$FasmObj = FasmInit()

	$sSource &= "  use32                         " & @LF
	$sSource &= "  org " & FasmGetBasePtr($FasmObj)& @LF
	$sSource &= "  push ebp                      " & @LF
	$sSource &= "  mov ebp, esp                  " & @LF
	$sSource &= "  mov eax, [ebp + 8]            " & @LF
	$sSource &= "  mov [hImg], eax               " & @LF
	$sSource &= "  cmp dword [ebp + 0ch], 0      " & @LF
	$sSource &= "  je short CM_FAIL              " & @LF
	$sSource &= "  mov eax, [ebp + 0ch]          " & @LF
	$sSource &= "  cmp dword [eax + 24h], 0      " & @LF
	$sSource &= "  jnz short START               " & @LF

	$sSource &= "CM_FAIL:                        " & @LF
	$sSource &= "  xor eax,eax                   " & @LF
	$sSource &= "  jmp END_FUNC                  " & @LF

	$sSource &= "START:                          " & @LF
	$sSource &= "  mov esi, eax                  " & @LF
	$sSource &= "  lea edi, [cm]                 " & @LF
	$sSource &= "  mov ecx, 0bh                  " & @LF
	$sSource &= "  rep  movsd                    " & @LF
	$sSource &= "  lea eax, [hSrc]               " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hImg]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pCloneImage           & @LF
	$sSource &= "  lea eax, [width]              " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hImg]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pGetImageWidth        & @LF
	$sSource &= "  lea eax, [height]             " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hImg]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pGetImageHeight       & @LF
	$sSource &= "  lea eax, [widthSrc]           " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hSrc]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pGetImageWidth        & @LF
	$sSource &= "  lea eax, [heightSrc]          " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hSrc]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pGetImageHeight       & @LF

	$sSource &= "  mov [imageRect.X], 0          " & @LF
	$sSource &= "  mov [imageRect.Y], 0          " & @LF
	$sSource &= "  mov eax, [width]              " & @LF
	$sSource &= "  mov [imageRect.Width], eax    " & @LF
	$sSource &= "  mov eax, [height]             " & @LF
	$sSource &= "  mov [imageRect.Height], eax   " & @LF
	$sSource &= "  lea eax, [bmData]             " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  push 21808h                   " & @LF
	$sSource &= "  push 3                        " & @LF
	$sSource &= "  lea ecx, [imageRect]          " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  mov edx, [hImg]               " & @LF
	$sSource &= "  push edx                      " & @LF
	$sSource &= "  call " & $pBitmapLockBits       & @LF

	$sSource &= "  mov [imageRect.X], 0          " & @LF
	$sSource &= "  mov [imageRect.Y], 0          " & @LF
	$sSource &= "  mov eax, [widthSrc]           " & @LF
	$sSource &= "  mov [imageRect.Width], eax    " & @LF
	$sSource &= "  mov eax, [heightSrc]          " & @LF
	$sSource &= "  mov [imageRect.Height], eax   " & @LF
	$sSource &= "  lea eax, [bmSrc]              " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  push 21808h                   " & @LF
	$sSource &= "  push 3                        " & @LF
	$sSource &= "  lea ecx, [imageRect]          " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  mov edx, [hSrc]               " & @LF
	$sSource &= "  push edx                      " & @LF
	$sSource &= "  call " & $pBitmapLockBits       & @LF

	$sSource &= "  mov eax, [bmData.Stride]      " & @LF
	$sSource &= "  mov [stride], eax             " & @LF
	$sSource &= "  shl eax, 1                    " & @LF
	$sSource &= "  mov [stride2], eax            " & @LF
	$sSource &= "  mov eax, [bmData.Scan0]       " & @LF
	$sSource &= "  mov [p], eax                  " & @LF
	$sSource &= "  mov eax, [bmSrc.Scan0]        " & @LF
	$sSource &= "  mov [pSrc], eax               " & @LF
	$sSource &= "  mov eax, [stride]             " & @LF
	$sSource &= "  add eax, 6                    " & @LF
	$sSource &= "  mov ecx, [width]              " & @LF
	$sSource &= "  imul ebx, ecx, 3              " & @LF
	$sSource &= "  sub eax, ebx                  " & @LF
	$sSource &= "  mov [nOffset], eax            " & @LF
	$sSource &= "  sub ecx, 2                    " & @LF
	$sSource &= "  mov [nWidth], ecx             " & @LF
	$sSource &= "  mov eax, [height]             " & @LF
	$sSource &= "  sub eax, 2                    " & @LF
	$sSource &= "  mov [nHeight], eax            " & @LF
	$sSource &= "  mov ecx, [pSrc]               " & @LF
	$sSource &= "  mov edx, [stride]             " & @LF
	$sSource &= "  mov edi, [stride2]            " & @LF
	$sSource &= "  mov esi, [p]                  " & @LF

	$sSource &= "  mov [y], 0                    " & @LF
	$sSource &= "  jmp short @f                  " & @LF
	; {
	$sSource &= "LOOP_Y:                         " & @LF
	$sSource &= "  inc [y]                       " & @LF
	$sSource &= "@@:                             " & @LF
	$sSource &= "  mov eax, [y]                  " & @LF
	$sSource &= "  cmp eax, [nHeight]            " & @LF
	$sSource &= "  jge END_Y                     " & @LF

	$sSource &= "  mov [x], 0                    " & @LF
	$sSource &= "  jmp short @f                  " & @LF
	; {
	$sSource &= "LOOP_X:                         " & @LF
	$sSource &= "  inc [x]                       " & @LF
	$sSource &= "@@:                             " & @LF
	$sSource &= "  mov eax, [x]                  " & @LF
	$sSource &= "  cmp eax, [nWidth]             " & @LF
	$sSource &= "  jge END_X                     " & @LF

	; nPixel = ( ( ( (pSrc[2] * cm->TopLeft) +
	$sSource &= "  movzx eax, byte [ecx + 2]     " & @LF
	$sSource &= "  imul eax, [cm.TopLeft]        " & @LF
	; (pSrc[5] * cm->TopMid) +
	$sSource &= "  movzx ebx, byte [ecx + 5]     " & @LF
	$sSource &= "  imul ebx, [cm.TopMid]         " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[8] * cm->TopRight) +
	$sSource &= "  movzx ebx, byte [ecx + 8]     " & @LF
	$sSource &= "  imul ebx, [cm.TopRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[2 + stride] * cm->MidLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edx+2]   " & @LF
	$sSource &= "  imul ebx, [cm.MidLeft]        " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[5 + stride] * cm->Pixel) +
	$sSource &= "  movzx ebx, byte [ecx+edx+5]   " & @LF
	$sSource &= "  imul ebx, [cm.Pixel]          " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[8 + stride] * cm->MidRight) +
	$sSource &= "  movzx ebx, byte [ecx+edx+8]   " & @LF
	$sSource &= "  imul ebx, [cm.MidRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[2 + stride2] * cm->BottomLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edi+2]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomLeft]     " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[5 + stride2] * cm->BottomMid) +
	$sSource &= "  movzx ebx, byte [ecx+edi+5]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomMid]      " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[8 + stride2] * cm->BottomRight) )
	$sSource &= "  movzx ebx, byte [ecx+edi+8]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomRight]    " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; / cm->Factor) + cm->Offset);
	$sSource &= "  push edx                      " & @LF
	$sSource &= "  cdq                           " & @LF
	$sSource &= "  idiv [cm.Factor]              " & @LF
	$sSource &= "  pop edx                       " & @LF
	$sSource &= "  add eax, [cm.Offset]          " & @LF
	; if (nPixel < 0) nPixel = 0;
	$sSource &= "  jns short ELSEIF_255a         " & @LF
	$sSource &= "  mov al, 0                     " & @LF
	$sSource &= "  jmp short @f                  " & @LF
	; else if (nPixel > 255) nPixel = 255;
	$sSource &= "ELSEIF_255a:                    " & @LF
	$sSource &= "  cmp eax, 0ffh                 " & @LF
	$sSource &= "  jle short @f                  " & @LF
	$sSource &= "  mov al, 0ffh                  " & @LF
	; p[5 + stride] = (BYTE)nPixel;
	$sSource &= "@@:                             " & @LF
	$sSource &= "  mov [esi+edx+5], al           " & @LF

	; nPixel  = ( ( ( (pSrc[1] * cm->TopLeft) +
	$sSource &= "  movzx eax, byte [ecx + 1]     " & @LF
	$sSource &= "  imul eax, [cm.TopLeft]        " & @LF
	; (pSrc[4] * cm->TopMid) +
	$sSource &= "  movzx ebx, byte [ecx + 4]     " & @LF
	$sSource &= "  imul ebx, [cm.TopMid]         " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[7] * cm->TopRight) +
	$sSource &= "  movzx ebx, byte [ecx + 7]     " & @LF
	$sSource &= "  imul ebx, [cm.TopRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[1 + stride] * cm->MidLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edx+1]   " & @LF
	$sSource &= "  imul ebx, [cm.MidLeft]        " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[4 + stride] * cm->Pixel) +
	$sSource &= "  movzx ebx, byte [ecx+edx+4]   " & @LF
	$sSource &= "  imul ebx, [cm.Pixel]          " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[7 + stride] * cm->MidRight) +
	$sSource &= "  movzx ebx, byte [ecx+edx+7]   " & @LF
	$sSource &= "  imul ebx, [cm.MidRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[1 + stride2] * cm->BottomLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edi+1]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomLeft]     " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[4 + stride2] * cm->BottomMid) +
	$sSource &= "  movzx ebx, byte [ecx+edi+4]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomMid]      " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[7 + stride2] * cm->BottomRight))
	$sSource &= "  movzx ebx, byte [ecx+edi+7]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomRight]    " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; / cm->Factor) + cm->Offset);
	$sSource &= "  push edx                      " & @LF
	$sSource &= "  cdq                           " & @LF
	$sSource &= "  idiv [cm.Factor]              " & @LF
	$sSource &= "  pop edx                       " & @LF
	$sSource &= "  add eax, [cm.Offset]          " & @LF
	; if (nPixel < 0) nPixel = 0;
	$sSource &= "  jns short ELSEIF_255b         " & @LF
	$sSource &= "  mov al, 0                     " & @LF
	$sSource &= "  jmp short @f                  " & @LF
	; else if (nPixel > 255) nPixel = 255;
	$sSource &= "ELSEIF_255b:                    " & @LF
	$sSource &= "  cmp eax, 0ffh                 " & @LF
	$sSource &= "  jle short @f                  " & @LF
	$sSource &= "  mov al, 0ffh                  " & @LF
	; p[4 + stride] = (BYTE)nPixel;
	$sSource &= "@@:                             " & @LF
	$sSource &= "  mov [esi+edx+4], al           " & @LF

	; nPixel  = ( ( ( (pSrc[0] * cm->TopLeft) +
	$sSource &= "  movzx eax, byte [ecx]         " & @LF
	$sSource &= "  imul eax, [cm.TopLeft]        " & @LF
	; (pSrc[3] * cm->TopMid) +
	$sSource &= "  movzx ebx, byte [ecx + 3]     " & @LF
	$sSource &= "  imul ebx, [cm.TopMid]         " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[6] * cm->TopMid) +
	$sSource &= "  movzx ebx, byte [ecx + 6]     " & @LF
	$sSource &= "  imul ebx, [cm.TopRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[stride] * cm->MidLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edx]     " & @LF
	$sSource &= "  imul ebx, [cm.MidLeft]        " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[3 + stride] * cm->Pixel) +
	$sSource &= "  movzx ebx, byte [ecx+edx+3]   " & @LF
	$sSource &= "  imul ebx, [cm.Pixel]          " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[6 + stride] * cm->MidRight) +
	$sSource &= "  movzx ebx, byte [ecx+edx+6]   " & @LF
	$sSource &= "  imul ebx, [cm.MidRight]       " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[stride2] * cm->BottomLeft) +
	$sSource &= "  movzx ebx, byte [ecx+edi]     " & @LF
	$sSource &= "  imul ebx, [cm.BottomLeft]     " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[3 + stride2] * cm->BottomMid) +
	$sSource &= "  movzx ebx, byte [ecx+edi+3]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomMid]      " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; (pSrc[6 + stride2] * cm->BottomRight))
	$sSource &= "  movzx ebx, byte [ecx+edi+6]   " & @LF
	$sSource &= "  imul ebx, [cm.BottomRight]    " & @LF
	$sSource &= "  add eax, ebx                  " & @LF
	; / cm->Factor) + cm->Offset);
	$sSource &= "  push edx                      " & @LF
	$sSource &= "  cdq                           " & @LF
	$sSource &= "  idiv [cm.Factor]              " & @LF
	$sSource &= "  pop edx                       " & @LF
	$sSource &= "  add eax, [cm.Offset]          " & @LF
	; if (nPixel < 0) nPixel = 0;
	$sSource &= "  jns short ELSEIF_255c         " & @LF
	$sSource &= "  mov al, 0                     " & @LF
	$sSource &= "  jmp short @f                  " & @LF
	; else if (nPixel > 255) nPixel = 255;
	$sSource &= "ELSEIF_255c:                    " & @LF
	$sSource &= "  cmp eax, 0ffh                 " & @LF
	$sSource &= "  jle short @f                  " & @LF
	$sSource &= "  mov al, 0ffh                  " & @LF
	; p[3 + stride] = (BYTE)nPixel;
	$sSource &= "@@:                             " & @LF
	$sSource &= "  mov [esi+edx+3], al           " & @LF

	; p += 3;
	; pSrc += 3;
	$sSource &= "  add esi, 3                    " & @LF
	$sSource &= "  add ecx, 3                    " & @LF
	$sSource &= "  jmp LOOP_X                    " & @LF
	; }
	; p += nOffset;
	; pSrc += nOffset;
	$sSource &= "END_X:                          " & @LF
	$sSource &= "  mov eax, [nOffset]            " & @LF
	$sSource &= "  add esi, eax                  " & @LF
	$sSource &= "  add ecx, eax                  " & @LF
	$sSource &= "  jmp LOOP_Y                    " & @LF
	; }
	$sSource &= "END_Y:                          " & @LF
	$sSource &= "  lea eax, [bmSrc]              " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hSrc]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pBitmapUnlockBits     & @LF
	$sSource &= "  lea eax, [bmData]             " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  mov ecx, [hImg]               " & @LF
	$sSource &= "  push ecx                      " & @LF
	$sSource &= "  call " & $pBitmapUnlockBits     & @LF
	$sSource &= "  mov eax, [hSrc]               " & @LF
	$sSource &= "  push eax                      " & @LF
	$sSource &= "  call " & $pDisposeImage         & @LF
	$sSource &= "  mov eax, 1                    " & @LF
	$sSource &= "END_FUNC:                       " & @LF
	$sSource &= "  pop ebp                       " & @LF
	$sSource &= "  ret 8                         " & @LF

	; BitmapData
	$sSource &= "  struc BitmapData w,h,s,pf,s0,r" & @LF
	$sSource &= "  {                             " & @LF
	$sSource &= "    .Width dd w ?               " & @LF
	$sSource &= "    .Height dd h ?              " & @LF
	$sSource &= "    .Stride dd s ?              " & @LF
	$sSource &= "    .PixelFormat dd pf ?        " & @LF
	$sSource &= "    .Scan0 dd s0 ?              " & @LF
	$sSource &= "    .Reserved dd r ?            " & @LF
	$sSource &= "  }                             " & @LF

	; $tagGDIPRECT
	$sSource &= "  struc rect x,y,w,h            " & @LF
	$sSource &= "  {                             " & @LF
	$sSource &= "    .X dd x ?                   " & @LF
	$sSource &= "    .Y dd y ?                   " & @LF
	$sSource &= "    .Width dd w ?               " & @LF
	$sSource &= "    .Height dd h ?              " & @LF
	$sSource &= "  }                             " & @LF

	; $tagGDIPCONVOLUTIONMATRIX
	$sSource &= "  struc ConvMatrix \            " & @LF
	$sSource &= "    tl,tm,tr,ml,p, \            " & @LF
	$sSource &= "    mr,bl,bm,br,f,o             " & @LF
	$sSource &= " {                              " & @LF
	$sSource &= "    .TopLeft dd tl ?            " & @LF
	$sSource &= "    .TopMid dd tm ?             " & @LF
	$sSource &= "    .TopRight dd tr ?           " & @LF
	$sSource &= "    .MidLeft dd ml ?            " & @LF
	$sSource &= "    .Pixel dd p ?               " & @LF
	$sSource &= "    .MidRight dd mr ?           " & @LF
	$sSource &= "    .BottomLeft dd bl ?         " & @LF
	$sSource &= "    .BottomMid dd bm ?          " & @LF
	$sSource &= "    .BottomRight dd br ?        " & @LF
	$sSource &= "    .Factor dd f ?              " & @LF
	$sSource &= "    .Offset dd o ?              " & @LF
	$sSource &= "  }                             " & @LF

	; Variables
	$sSource &= "  hImg dd ?                     " & @LF
	$sSource &= "  hSrc dd ?                     " & @LF
	$sSource &= "  width dd ?                    " & @LF
	$sSource &= "  height dd ?                   " & @LF
	$sSource &= "  widthSrc dd ?                 " & @LF
	$sSource &= "  heightSrc dd ?                " & @LF
	$sSource &= "  stride dd ?                   " & @LF
	$sSource &= "  stride2 dd ?                  " & @LF
	$sSource &= "  p dd ?                        " & @LF
	$sSource &= "  pSrc dd ?                     " & @LF
	$sSource &= "  nOffset dd ?                  " & @LF
	$sSource &= "  nWidth dd ?                   " & @LF
	$sSource &= "  nHeight dd ?                  " & @LF
	$sSource &= "  imageRect rect                " & @LF
	$sSource &= "  x dd ?                        " & @LF
	$sSource &= "  y dd ?                        " & @LF
	$sSource &= "  cm ConvMatrix                 " & @LF
	$sSource &= "  bmData BitmapData             " & @LF
	$sSource &= "  bmSrc BitmapData              "

	FasmSetSource($FasmObj, $sSource)

	If Not FasmCompile($FasmObj) Then
		FasmExit($FasmObj)
		$FasmObj = 0
		Return SetError(2, 0, False)
	Else
		OnAutoItExitRegister("__DisposeConvolution")
		Return SetError(0, 0, True)
	EndIf
EndFunc

Func __DisposeConvolution()
	If $__CM_Fasm Then FasmExit($__CM_Fasm)
EndFunc

#endregion Internal Functions and Predefined Matrices