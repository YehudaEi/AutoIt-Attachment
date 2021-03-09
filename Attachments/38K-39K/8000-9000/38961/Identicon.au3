#include-once

; #INDEX# ======================================================================
; Title .........: Identicon.au3
; Version .......: 0.8
; AutoIt Version : 3.3.7.20++
; Language ......: English
; Author(s) .....: dany
; Link ..........: http://www.autoitscript.com/forum/topic/145741-identicon-udf-for-visual-representations-of-hashes/
; Description ...: AutoIt UDF for creating identicons from any kind of message digest (hash).
; Dll ...........: GDIPlus.dll
; Remarks .......: * Based on Don Park's original code: https://github.com/donpark/identicon
;                    And Bong Cosca's code: http://sourceforge.net/projects/identicons/
;                  * Adapted to handle hashes longer than MD5.
;                  * Added checkerboard and Space Invader patterns.
;                  * Copypasted a few functions from GDIP.au3 by Authenticity: http://www.autoitscript.com/forum/topic/106021-gdipau3/
;                  TODO:
;                  * In the checkerboard pattern there is a bias for diamond shapes.
;                  * Improve image saving, BMP, GIF and JPG suck, much artifacts
;                    and dithering. Also transparency doesn't work with GIF (and
;                    BMP?) due to the wrong Bitmap format.
;                  * Add some more unique sprite shapes and preferably cap the shape
;                    arrays at powers of two as BitAND is faster than a modulus
;                    operation. There are 16 outer shapes and 8 center shapes.
;                  CHANGELOG:
;                  Version 0.8:
;                  * Initial public release.
; Example .......: Identicon-Demo.au3
; ==============================================================================

; #TODO# =======================================================================
; * In the checkerboard pattern there is a bias for diamond shapes.
; * Improve image saving, BMP, GIF and JPG suck, much artifacts and dithering.
;   Also transparency doesn't work with GIF (and BMP?) due to the wrong Bitmap
;   format.
; * Add some more unique sprite shapes and preferably cap the shape arrays at
;   powers of two as BitAND is faster than a modulus operation. Currently there
;   are 16 outer shapes and 8 center shapes.
; ==============================================================================

; #CURRENT# ====================================================================
;_Identicon_Startup
;_Identicon_Shutdown
;_Identicon
; ==============================================================================

; #INTERNAL_USE_ONLY# ==========================================================
;__Identicon_GetVectors
;__Identicon_ColorGetContrastTreshold
;__Identicon_ColorGetComplementary
;__Identicon_Rotate
;__Identicon_Resize
;__Identicon_RenderOuterSprite
;__Identicon_RenderCenterSprite
;__Identicon_Render3x3
;__Identicon_Render4x4
;_GDIPlus_BitmapCreateFromScan0
;_GDIPlus_ImageRotateFlip
;_GDIPlus_GraphicsSetInterpolationMode
;_GDIPlus_GraphicsSetPixelOffsetMode
; ==============================================================================

#include <GDIPlus.au3>

; #CONSTANTS# ==================================================================
; Int: @error return codes.
Global Enum $E_IDENTICON_OK = 0, _
        $E_IDENTICON_GDIPLUS_NOT_LOADED, _
        $E_IDENTICON_NOT_A_HASH, $E_IDENTICON_HASH_INVALID, _
        $E_IDENTICON_SAVEDIR_NOT_ACCESSIBLE, $E_IDENTICON_SAVEDIR_INVALID, _
        $E_IDENTICON_GDIPLUS_FAILURE, $E_IDENTICON_SAVE_FAILURE

Global Const $IDENTICON_VERSION = '0.8' ;  String: Version number.

; Hex: Identicon types, these can be BitOR-ed together.
; Default: 0x0105 = BitOR($IDENTICON_3X3, $IDENTICON_STANDARD, $IDENTICON_PNG)
Global Const $IDENTICON_3X3 = 0x0001 ; 3x3 grid layout (default).
Global Const $IDENTICON_4X4 = 0x0002 ; 4x4 grid layout.
Global Const $IDENTICON_STANDARD = 0x0004 ; Standard rotative symmetry (default).
Global Const $IDENTICON_CHECKERBOARD = 0x0008 ; Checkerboard pattern.
Global Const $IDENTICON_SPACE_INVADER = 0x0010 ; Horizontal/vertical mirror symmetry.
Global Const $IDENTICON_TRANSPARENT = 0x0020 ; Background transparency.
Global Const $IDENTICON_ROTATE = 0x0040 ; Rotate final Identicon.
Global Const $IDENTICON_BORDER = 0x0080 ; Draw a 1px black border around the final Identicon.
Global Const $IDENTICON_PNG = 0x0100 ; Save as PNG (default).
Global Const $IDENTICON_JPG = 0x0200 ; Save as JPG.
Global Const $IDENTICON_BMP = 0x0400 ; Save as BMP.
Global Const $IDENTICON_GIF = 0x0800 ; Save as GIF.
; ==============================================================================

; #VARIABLES# ==================================================================
Global $Identicon_gfRunning = False

; On XP and above these algorithms are also available for _Crypt_*, so uncomment
; or copy somewhere else into your script if you want to use them. SHA224 isn't
; available afaik.
;Global Const $CALG_SHA256 = 0x0000800c
;Global Const $CALG_SHA384 = 0x0000800d
;Global Const $CALG_SHA512 = 0x0000800e
; ==============================================================================

; #FUNCTION# ===================================================================
; Name ..........: _Identicon_Startup
; Description ...: Loads GDI+ library.
; Syntax ........: _Identicon_Startup()
; Parameters ....: None.
; Return values .: Success - Int: Returns 1.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 - $E_IDENTICON_GDIPLUS_NOT_LOADED - Couldn't load GDIPlus.dll.
; Author ........: dany
; Modified ......:
; Remarks .......: Registers _Identicon_Shutdown as callback when AutoIt exits.
; Related .......: _Identicon, _Identicon_Shutdown
; ==============================================================================
Func _Identicon_Startup()
    If $Identicon_gfRunning Then Return 1
    _GDIPlus_Startup()
    If @error Then Return SetError($E_IDENTICON_GDIPLUS_NOT_LOADED, 0, 0)
    OnAutoItExitRegister('_Identicon_Shutdown')
    $Identicon_gfRunning = True
    Return 1
EndFunc   ;==>_Identicon_Startup

; #FUNCTION# ===================================================================
; Name ..........: _Identicon_Shutdown
; Description ...: Closes GDI+ library.
; Syntax ........: _Identicon_Shutdown()
; Parameters ....: None.
; Return values .: None.
; Author ........: dany
; Modified ......:
; Remarks .......: Registered on AutoIt exit by _Identicon_Startup. Unregisters itself when called.
; Related .......: _Identicon_Startup
; ==============================================================================
Func _Identicon_Shutdown()
    OnAutoItExitUnRegister('_Identicon_Shutdown')
    _GDIPlus_Shutdown()
    $Identicon_gfRunning = False
EndFunc   ;==>_Identicon_Shutdown

; #FUNCTION# ===================================================================
; Name ..........: _Identicon
; Description ...: Creates a visual representation from the given hash value.
; Syntax ........: _Identicon($vHash, [, $iSize [, $iType [, $sSaveDir]]])
; Parameters ....: $vHash  - Mixed: A String or Binary hash value.
;                  $iSize  - Int: Image width/weight in pixels.
;                  $iType  - Int: Identicon type, any one of $IDENTICON_* BitOR-ed together.
;                  $sSaveDir - String: A path to a directory to save the identicon.
; Return values .: Success - Mixed: If no SaveDir is given a Bitmap handle is returned. If a SaveDir is given the full path to the image file is returned.
;                  Failure - Int: Returns 0 and sets @error:
;                  |1 - $E_IDENTICON_GDIPLUS_NOT_LOADED - Couldn't load GDIPlus.dll.
;                  |2 - $E_IDENTICON_NOT_A_HASH - Variant is not a Binary or Hex string.
;                  |3 - $E_IDENTICON_HASH_INVALID - Hex string is shorter than 32 (MD5) or odd number of digits.
;                  |4 - $E_IDENTICON_SAVEDIR_NOT_ACCESSIBLE - Path isn't accessible or writable.
;                  |5 - $E_IDENTICON_SAVEDIR_INVALID - Path isn't a directory.
;                  |6 - $E_IDENTICON_GDIPLUS_FAILURE - One of the GDI functions failed.
;                  |7 - $E_IDENTICON_SAVE_FAILURE - Failed to save the image to file.
; Author ........: dany
; Modified ......:
; Remarks .......: Image is saved with a filename formatted as YYYYmmdd-HHiiss-hashvalue.png.
; Related .......:
; ==============================================================================
Func _Identicon($vHash, $iSize = 64, $iType = -1, $sSaveDir = 0)
    Local $hIdenticonBitmap, $hGraphic, $aVectors, $fTransparent
    If IsBinary($vHash) Then $vHash = Hex($vHash)
    If Not IsInt($iSize) Or 0 > $iSize Then $iSize = 64
    If Not IsInt($iType) Or 0 > $iType Then $iType = 0x0105
    If Not StringIsXDigit($vHash) Then Return SetError($E_IDENTICON_NOT_A_HASH, 0, 0)
    $aVectors = StringLen($vHash) ; Recycle
    If 32 > $aVectors Or 1 = BitAND($aVectors, 1) Then Return SetError($E_IDENTICON_HASH_INVALID, 0, 0)
    If IsString($sSaveDir) Then
        $sSaveDir = StringReplace($sSaveDir, '/', '\')
        If '\' = StringRight($sSaveDir, 1) Then $sSaveDir = StringTrimRight($sSaveDir, 1)
        If Not FileExists($sSaveDir) Then
            If Not DirCreate($sSaveDir) Then Return SetError($E_IDENTICON_SAVEDIR_NOT_ACCESSIBLE, 0, 0)
        EndIf
        If Not StringInStr(FileGetAttrib($sSaveDir), 'D', 2) Then Return SetError($E_IDENTICON_SAVEDIR_INVALID, 0, 0)
    EndIf
    If Not _Identicon_Startup() Then Return SetError($E_IDENTICON_GDIPLUS_NOT_LOADED, 0, 0)
    $aVectors = __Identicon_GetVectors($vHash)
    $aVectors[0] = $iType
    $fTransparent = ($IDENTICON_TRANSPARENT = BitAND($iType, $IDENTICON_TRANSPARENT))
    If $IDENTICON_4X4 = BitAND($iType, $IDENTICON_4X4) Then
        $hIdenticonBitmap = __Identicon_Render4x4($aVectors)
    Else
        $hIdenticonBitmap = __Identicon_Render3x3($aVectors)
    EndIf
    If 0 = $hIdenticonBitmap Then Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
    If $IDENTICON_ROTATE = BitAND($iType, $IDENTICON_ROTATE) Then
        $hIdenticonBitmap = __Identicon_Rotate($hIdenticonBitmap, $aVectors[7], $fTransparent)
    EndIf
    $hIdenticonBitmap = __Identicon_Resize($hIdenticonBitmap, $iSize, $fTransparent)
    If $IDENTICON_BORDER = BitAND($iType, $IDENTICON_BORDER) Then
        $hGraphic = _GDIPlus_ImageGetGraphicsContext($hIdenticonBitmap)
        _GDIPlus_GraphicsDrawRect($hGraphic, 0, 0, $iSize - 1, $iSize - 1) ; Use standard 1 pixel black pen.
        _GDIPlus_GraphicsDispose($hGraphic)
    EndIf
    If IsString($sSaveDir) Then
        $sSaveDir &= '\' & @YEAR & @MON & @MDAY & '-' & @HOUR & @MIN & @SEC & '-' & $vHash
        If $IDENTICON_JPG = BitAND($iType, $IDENTICON_JPG) Then
            $sSaveDir &= '.jpg'
        ElseIf $IDENTICON_BMP = BitAND($iType, $IDENTICON_BMP) Then
            $sSaveDir &= '.bmp'
        ElseIf $IDENTICON_GIF = BitAND($iType, $IDENTICON_GIF) Then
            $sSaveDir &= '.gif'
        Else
            $sSaveDir &= '.png'
        EndIf
        _GDIPlus_ImageSaveToFile($hIdenticonBitmap, $sSaveDir)
        _GDIPlus_BitmapDispose($hIdenticonBitmap)
        If Not FileExists($sSaveDir) Then Return SetError($E_IDENTICON_SAVE_FAILURE, 0, 0)
        Return $sSaveDir
    EndIf
    Return $hIdenticonBitmap
EndFunc   ;==>_Identicon

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_GetVectors
; Description ...: Extract all vectors from hash value proportionally to its length.
; Syntax ........: __Identicon_GetVectors($sHash)
; Parameters ....: $sHash  - String: Hash value.
; Return values .: Array: All necessary vectors.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_GetVectors($sHash)
    Local $iSize, $iRatio, $aBytes, $aVectors[10]
    $iSize = StringLen($sHash)
    $iRatio = Floor($iSize / 32)
    If 40 = $iSize Then ; Offsets for SHA1.
        Local $aOffset[9][2] = [[1, 2], [3, 5], [8, 5], [13, 2], [15, 5], [20, 2], [22, 3], [25, 8], [33, 8]] ; StringMid offsets.
    Else
        Local $aOffset[9][2] = [[1, 2], [3, 4], [7, 4], [11, 2], [13, 4], [17, 2], [19, 2], [21, 6], [27, 6]] ; StringMid offsets.
        For $i = 0 To 8
            $aOffset[$i][1] = $aOffset[$i][1] * $iRatio
            If $i < 8 Then $aOffset[$i + 1][0] = $aOffset[$i][0] + $aOffset[$i][1]
        Next
    EndIf
    ; Get identicon vectors.
    $aVectors[1] = BitAND(Dec(StringMid($sHash, $aOffset[0][0], $aOffset[0][1])), 7) ; Center sprite shape.
    $aVectors[2] = BitAND(Dec(StringMid($sHash, $aOffset[1][0], $aOffset[1][1])), 1) ; Center sprite background flag.
    $aVectors[3] = BitAND(Dec(StringMid($sHash, $aOffset[2][0], $aOffset[2][1])), 15) ; Corner sprite shape.
    $aVectors[4] = BitAND(Dec(StringMid($sHash, $aOffset[3][0], $aOffset[3][1])), 3) ; Corner sprite rotation.
    $aVectors[5] = BitAND(Dec(StringMid($sHash, $aOffset[4][0], $aOffset[4][1])), 15) ; Side sprite shape.
    $aVectors[6] = BitAND(Dec(StringMid($sHash, $aOffset[5][0], $aOffset[5][1])), 3) ; Side sprite rotation.
    $aVectors[7] = BitAND(Dec(StringMid($sHash, $aOffset[6][0], $aOffset[6][1])), 255) ; Final angle of rotation.
    $aVectors[8] = StringMid($sHash, $aOffset[7][0], $aOffset[7][1]) ; Corner sprite foreground color, ARGB.
    $aVectors[9] = StringMid($sHash, $aOffset[8][0], $aOffset[8][1]) ; Side sprite foreground color, ARGB.
    ; Calculate color values.
    If 32 = $iSize Then ; Original code.
        $aVectors[8] = Dec('FF' & $aVectors[8])
        $aVectors[9] = Dec('FF' & $aVectors[9])
    Else ; Compute color for longer hashes.
        For $i = 8 To 9
            $iRatio = 0 ; Recycle.
            $aBytes = StringRegExp($aVectors[$i], '[[:xdigit:]]{2}', 3) ; Split into equal parts.
            For $ii = 0 To UBound($aBytes) - 1
                $iRatio += BitShift(Dec($aBytes[$ii]), -(Mod($ii, 3) * 8))
            Next
            $aVectors[$i] = BitOR(BitAND($iRatio, 0x00FFFFFF), 0xFF000000) ; Set alpha channel to FF (no transparency).
        Next
    EndIf
    ; Make sure there's enough contrast.
    If Not __Identicon_ColorGetContrastTreshold($aVectors[8], $aVectors[9]) Then
        $aVectors[9] = __Identicon_ColorGetComplementary($aVectors[8])
    EndIf
    Return $aVectors
EndFunc   ;==>__Identicon_GetVectors

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_ColorGetContrastTreshold
; Description ...: Get contrast threshold by calculating the luminosity contrast ratio and compare to a threshold value.
; Syntax ........: __Identicon_ColorGetContrastTreshold($iARGB1, $iARGB2)
; Parameters ....: $iARGB1 - Int: First Hex color value to evaluate.
;                  $iARGB2 - Int: Second Hex color value to evaluate.
; Return values .: Boolean: True if the two have enough contrast, False if not.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; Link ..........: http://www.w3.org/TR/2006/WD-WCAG20-20060427/appendixA.html#luminosity-contrastdef
; ==============================================================================
Func __Identicon_ColorGetContrastTreshold($iARGB1, $iARGB2)
    ; Bitmask the alpha part away.
    $iARGB1 = BitAND($iARGB1, 0x00FFFFFF)
    $iARGB2 = BitAND($iARGB2, 0x00FFFFFF)
    Local $iLum1 = 0.05, $iLum2 = 0.05
    $iLum1 += 0.2126 * ((BitAND(BitShift($iARGB1, 16), 0xFF) / 255) ^ 2.2) ; Red component.
    $iLum1 += 0.7152 * ((BitAND(BitShift($iARGB1, 8), 0xFF) / 255) ^ 2.2) ; Green component.
    $iLum1 += 0.0722 * ((BitAND($iARGB1, 0xFF) / 255) ^ 2.2) ; Blue component.
    $iLum2 += 0.2126 * ((BitAND(BitShift($iARGB2, 16), 0xFF) / 255) ^ 2.2) ; Red component.
    $iLum2 += 0.7152 * ((BitAND(BitShift($iARGB2, 8), 0xFF) / 255) ^ 2.2) ; Green component.
    $iLum2 += 0.0722 * ((BitAND($iARGB2, 0xFF) / 255) ^ 2.2) ; Blue component.
    If $iLum1 > $iLum2 Then
        Return 5.0 < ($iLum1 / $iLum2)
    Else
        Return 5.0 < ($iLum2 / $iLum1)
    EndIf
EndFunc   ;==>__Identicon_ColorGetContrastTreshold

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_ColorGetComplementary
; Description ...: Get complementary by inversion.
; Syntax ........: __Identicon_ColorGetComplementary($iARGB)
; Parameters ....: $iARGB  - Int: ARGB color value.
; Return values .: Int: Complementary of $iARGB.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
;                  +This won't work for all colors and doesn't create true complementaries as it's based
;                  +on RYB model (subtractive combination) and not RGB model (additive combination). To
;                  +compensate the green part gets half subtraction to keep enough yellow in the color.
; Related .......:
; ==============================================================================
Func __Identicon_ColorGetComplementary($iARGB)
    Return BitXOR($iARGB, 0x00FF80FF)
EndFunc   ;==>__Identicon_ColorGetComplementary

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_Rotate
; Description ...: Rotate an image.
; Syntax ........: __Identicon_Rotate($hBitmap, $iAngle [, $fTransparent])
; Parameters ....: $hBitmap - Handle: A Bitmap object.
;                  $iAngle - Int: Rotation angle.
;                  $fTransparent - Bool: Background transparency flag.
; Return values .: Handle: Rotated Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_Rotate($hBitmap, $iAngle, $fTransparent = True)
    Local $iSize, $iOffset, $hGraphic, $hRotatedGraphic, $hRotatedBitmap, $hMatrix = _GDIPlus_MatrixCreate()
    $iSize = _GDIPlus_ImageGetWidth($hBitmap)
    $iOffset = Int($iSize / 2)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    $hRotatedBitmap = _GDIPlus_BitmapCreateFromGraphics($iSize, $iSize, $hGraphic)
    $hRotatedGraphic = _GDIPlus_ImageGetGraphicsContext($hRotatedBitmap)
    _GDIPlus_GraphicsSetPixelOffsetMode($hGraphic, 4) ; Top-left of pixel is at 0, 0.
    _GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
    _GDIPlus_GraphicsSetPixelOffsetMode($hRotatedGraphic, 4) ; Top-left of pixel is at 0, 0.
    _GDIPlus_GraphicsSetInterpolationMode($hRotatedGraphic, 7) ; High quality rotation.
    _GDIPlus_GraphicsSetSmoothingMode($hRotatedGraphic, 2)
    If Not $fTransparent Then
        _GDIPlus_GraphicsClear($hRotatedGraphic, 0xFFFFFFFF)
    EndIf
    _GDIPlus_MatrixTranslate($hMatrix, $iOffset, $iOffset)
    _GDIPlus_MatrixRotate($hMatrix, $iAngle)
    _GDIPlus_GraphicsSetTransform($hRotatedGraphic, $hMatrix)
    _GDIPlus_GraphicsDrawImageRect($hRotatedGraphic, $hBitmap, -$iOffset, -$iOffset, $iSize, $iSize)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hRotatedBitmap, 0, 0, $iSize, $iSize)
    _GDIPlus_MatrixDispose($hMatrix)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_GraphicsDispose($hRotatedGraphic)
    _GDIPlus_BitmapDispose($hBitmap)
    Return $hRotatedBitmap
EndFunc   ;==>__Identicon_Rotate

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_Resize
; Description ...: Resize an image.
; Syntax ........: __Identicon_Resize($hBitmap, $iSize)
; Parameters ....: $hBitmap - Handle: A Bitmap object.
;                  $iSize  - Int: New size in pixels.
;                  $fTransparent - Bool: Background transparency flag.
; Return values .: Handle: Resized Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_Resize($hBitmap, $iSize, $fTransparent = True)
    Local $hGraphic, $hResized = _GDIPlus_BitmapCreateFromScan0($iSize, $iSize)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hResized)
    _GDIPlus_GraphicsSetPixelOffsetMode($hGraphic, 4) ; Top-left of pixel is at 0, 0.
    If Not $fTransparent Then
        _GDIPlus_GraphicsClear($hGraphic, 0xFFFFFFFF)
    EndIf
    _GDIPlus_GraphicsSetInterpolationMode($hGraphic, 7) ; High quality resizing.
    _GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
    _GDIPlus_GraphicsDrawImageRect($hGraphic, $hBitmap, 0, 0, $iSize, $iSize)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_BitmapDispose($hBitmap)
    Return $hResized
EndFunc   ;==>__Identicon_Resize

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_RenderOuterSprite
; Description ...: Renders edge and corner sprites for the identicon.
; Syntax ........: __Identicon_RenderOuterSprite($iShape, $iRotation, $iARGB)
; Parameters ....: $iShape - Int: The shape of the sprite.
;                  $iRotation - Int: Number of 90 degree steps to rotate.
;                  $iARGB  - Int: Foreground color value.
; Return values .: Handle: Handle to a Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_RenderOuterSprite($iShape, $iRotation, $iARGB)
    Local $hBrush, $hBitmap, $hGraphic
    Switch $iShape
        Case 0 ; Triangle.
            Local $aPoints[4][2] = [[3, 0], [0, 0], [128, 64], [64, 128]]
        Case 1 ; Parallelogram.
            Local $aPoints[5][2] = [[4, 0], [0, 0], [64, 0], [128, 128], [64, 128]]
        Case 2 ; Mouse ears.
            Local $aPoints[6][2] = [[5, 0], [64, 0], [128, 0], [128, 128], [64, 128], [128, 64]]
        Case 3 ; Ribbon.
            Local $aPoints[6][2] = [[5, 0], [0, 64], [64, 0], [128, 64], [64, 128], [64, 64]]
        Case 4 ; Sails.
            Local $aPoints[6][2] = [[5, 0], [0, 64], [128, 0], [128, 128], [0, 128], [128, 64]]
        Case 5 ; Fins.
            Local $aPoints[6][2] = [[5, 0], [128, 0], [128, 128], [64, 128], [128, 64], [64, 64]]
        Case 6 ; Beak.
            Local $aPoints[7][2] = [[6, 0], [0, 0], [128, 0], [128, 64], [0, 0], [64, 128], [0, 128]]
        Case 7 ; Chevron.
            Local $aPoints[7][2] = [[6, 0], [0, 0], [64, 0], [128, 64], [64, 128], [0, 128], [64, 64]]
        Case 8 ; Fish.
            Local $aPoints[8][2] = [[7, 0], [64, 0], [64, 64], [128, 64], [128, 128], [64, 128], [64, 64], [0, 64]]
        Case 9 ; Kite.
            Local $aPoints[8][2] = [[7, 0], [0, 0], [128, 0], [64, 64], [128, 64], [64, 128], [64, 64], [0, 128]]
        Case 10 ; Trough.
            Local $aPoints[8][2] = [[7, 0], [0, 64], [64, 128], [128, 64], [64, 0], [128, 0], [128, 128], [0, 128]]
        Case 11 ; Rays.
            Local $aPoints[8][2] = [[7, 0], [64, 0], [128, 0], [128, 128], [64, 128], [128, 96], [64, 64], [128, 32]]
        Case 12 ; Double rhombus.
            Local $aPoints[9][2] = [[8, 0], [0, 64], [64, 0], [64, 64], [128, 0], [128, 64], [64, 128], [64, 64], [0, 128]]
        Case 13 ; Crown.
            Local $aPoints[10][2] = [[9, 0], [0, 0], [128, 0], [128, 128], [0, 128], [128, 64], [64, 32], [64, 96], [0, 64], [64, 32]]
        Case 14 ; Radioactive.
            Local $aPoints[10][2] = [[9, 0], [0, 64], [64, 64], [64, 0], [128, 0], [64, 64], [128, 64], [64, 128], [64, 64], [0, 128]]
        Case Else ; Tiles.
            Local $aPoints[10][2] = [[9, 0], [0, 0], [128, 0], [64, 64], [64, 0], [0, 64], [128, 64], [64, 128], [64, 64], [0, 128]]
    EndSwitch
    $hBitmap = _GDIPlus_BitmapCreateFromScan0(128, 128)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetPixelOffsetMode($hGraphic, 4) ; Top-left of pixel is at 0, 0.
    ;_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
    $hBrush = _GDIPlus_BrushCreateSolid($iARGB)
    _GDIPlus_GraphicsFillPolygon($hGraphic, $aPoints, $hBrush)
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hGraphic)
    If $iRotation Then $hBitmap = __Identicon_Rotate($hBitmap, $iRotation * 90)
    Return $hBitmap
EndFunc   ;==>__Identicon_RenderOuterSprite

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_RenderCenterSprite
; Description ...: Renders the center sprite for the identicon.
; Syntax ........: __Identicon_RenderCenterSprite($iShape, $iUseBG, $iARBGForeGround, $iARBGBackGround)
; Parameters ....: $iShape - Int: The shape of the sprite.
;                  $iUseBG - Int: Flag whether or not to use the background color.
;                  $iARBGForeGround - Int: Foreground color value.
;                  $iARBGBackGround - Int: Background color value.
; Return values .: Handle: Handle to a Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_RenderCenterSprite($iShape, $iUseBG, $iARBGForeGround, $iARBGBackGround)
    Local $hBrush, $hBitmap, $hGraphic
    Switch $iShape
        Case 1 ; Fill.
            Local $aPoints[5][2] = [[4, 0], [0, 0], [128, 0], [128, 128], [0, 128]]
        Case 2 ; Diamond.
            Local $aPoints[5][2] = [[4, 0], [64, 0], [128, 64], [64, 128], [0, 64]]
        Case 3 ; Inverse diamond.
            Local $aPoints[10][2] = [[9, 0], [0, 0], [128, 0], [128, 128], [0, 128], [0, 64], [64, 128], [128, 64], [64, 0], [0, 64]]
        Case 4 ; Cross.
            Local $aPoints[13][2] = [[12, 0], [32, 0], [96, 0], [64, 64], [128, 32], [128, 96], [64, 64], [96, 128], [32, 128], [64, 64], [0, 96], [0, 32], [64, 64]]
        Case 5 ; Morning star.
            Local $aPoints[9][2] = [[8, 0], [0, 0], [64, 32], [128, 0], [96, 64], [128, 128], [64, 96], [0, 128], [32, 64]]
        Case 6 ; Small square.
            Local $aPoints[5][2] = [[4, 0], [43, 43], [85, 43], [85, 85], [43, 85]]
        Case 7 ; Checkerboard.
            Local $aPoints[21][2] = [[20, 0], [0, 0], [43, 0], [43, 43], [85, 43], [85, 0], [128, 0], [128, 43], [85, 43], [85, 85], [128, 85], [128, 128], [85, 128], [85, 85], [43, 85], [43, 128], [0, 128], [0, 85], [43, 85], [43, 43], [0, 43]]
        Case Else ; Nothing.
            Local $aPoints = False
    EndSwitch
    $hBitmap = _GDIPlus_BitmapCreateFromScan0(128, 128)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hBitmap)
    _GDIPlus_GraphicsSetPixelOffsetMode($hGraphic, 4) ; Top-left of pixel is at 0, 0.
    ;_GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
    $hBrush = _GDIPlus_BrushCreateSolid($iARBGBackGround)
    If $iUseBG And __Identicon_ColorGetContrastTreshold($iARBGForeGround, $iARBGBackGround) Then
        _GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 128, 128, $hBrush)
    EndIf
    If IsArray($aPoints) Then
        _GDIPlus_BrushSetSolidColor($hBrush, $iARBGForeGround)
        _GDIPlus_GraphicsFillPolygon($hGraphic, $aPoints, $hBrush)
    EndIf
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_GraphicsDispose($hGraphic)
    Return $hBitmap
EndFunc   ;==>__Identicon_RenderCenterSprite

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_Render3x3
; Description ...: Renders a 3x3 Identicon.
; Syntax ........: __Identicon_Render3x3($aVectors)
; Parameters ....: $aVectors - Array: Vector array.
; Return values .: Handle: Handle to a Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_Render3x3($aVectors)
    ; 1| 2| 3
    ; 4| 5| 6
    ; 7| 8| 9
    Local $hSprite, $hBrush, $hIdenticonGraphic
    Local $hIdenticonBitmap = _GDIPlus_BitmapCreateFromScan0(384, 384)
    If 0 = $hIdenticonBitmap Then Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
    $hIdenticonGraphic = _GDIPlus_ImageGetGraphicsContext($hIdenticonBitmap)
    _GDIPlus_GraphicsSetPixelOffsetMode($hIdenticonGraphic, 4) ; Top-left of pixel is at 0, 0.
    ;_GDIPlus_GraphicsSetSmoothingMode($hIdenticonGraphic, 2)
    If $IDENTICON_TRANSPARENT <> BitAND($aVectors[0], $IDENTICON_TRANSPARENT) Then
        $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF) ; White.
        _GDIPlus_GraphicsFillRect($hIdenticonGraphic, 0, 0, 384, 384, $hBrush)
        _GDIPlus_BrushDispose($hBrush)
    EndIf
    If $IDENTICON_CHECKERBOARD = BitAND($aVectors[0], $IDENTICON_CHECKERBOARD) Then
        If 2 > $aVectors[1] Then $aVectors[1] += 2 ; TODO: Creates bias for diamond shapes.
        ; Black side.
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 4
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 6
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 8
        _GDIPlus_BitmapDispose($hSprite)
        ; Red side.
        $aVectors[1] = BitAND($aVectors[1] + $aVectors[3] + $aVectors[4], 7)
        $aVectors[2] = BitAND($aVectors[2] + $aVectors[5] + $aVectors[6], 1)
        If 2 > $aVectors[1] Then $aVectors[1] += 2 ; TODO: Creates bias for diamond shapes.
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[9], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 0, 128, 128) ; 3
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128) ; 5
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 7
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 9
        _GDIPlus_BitmapDispose($hSprite)
    ElseIf $IDENTICON_SPACE_INVADER = BitAND($aVectors[0], $IDENTICON_SPACE_INVADER) Then
        ; Corner sprites.
        $hSprite = __Identicon_RenderOuterSprite($aVectors[3], $aVectors[4], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 7
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 9
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 0, 128, 128) ; 3
        ; Side sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderOuterSprite($aVectors[5], $aVectors[6], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 8
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 4
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 6
        ; Center sprite.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128)
        _GDIPlus_BitmapDispose($hSprite)
    Else ; Standard Identicon.
        ; Corner sprites.
        $hSprite = __Identicon_RenderOuterSprite($aVectors[3], $aVectors[4], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 0, 128, 128) ; 3
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 9
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 7
        ; Side sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderOuterSprite($aVectors[5], $aVectors[6], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 6
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 8
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 4
        ; Center sprite.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128)
        _GDIPlus_BitmapDispose($hSprite)
    EndIf
    _GDIPlus_GraphicsDispose($hIdenticonGraphic)
    Return $hIdenticonBitmap
EndFunc   ;==>__Identicon_Render3x3

; #INTERNAL_USE_ONLY# ==========================================================
; Name ..........: __Identicon_Render4x4
; Description ...: Renders a 4x4 Identicon.
; Syntax ........: __Identicon_Render4x4($aVectors)
; Parameters ....: $aVectors - Array: Vector array.
; Return values .: Handle: Handle to a Bitmap object.
; Author ........: dany
; Modified ......:
; Remarks .......: For Internal Use Only.
; Related .......:
; ==============================================================================
Func __Identicon_Render4x4($aVectors)
    ; 1| 2| 3| 4
    ; 5| 6| 7| 8
    ; 9|10|11|12
    ;13|14|15|16
    Local $hSprite, $hSpriteFlip, $hBrush, $hIdenticonGraphic
    Local $hIdenticonBitmap = _GDIPlus_BitmapCreateFromScan0(512, 512)
    If 0 = $hIdenticonBitmap Then Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
    $hIdenticonGraphic = _GDIPlus_ImageGetGraphicsContext($hIdenticonBitmap)
    _GDIPlus_GraphicsSetPixelOffsetMode($hIdenticonGraphic, 4) ; Top-left of pixel is at 0, 0.
    ;_GDIPlus_GraphicsSetSmoothingMode($hIdenticonGraphic, 2)
    If $IDENTICON_TRANSPARENT <> BitAND($aVectors[0], $IDENTICON_TRANSPARENT) Then
        $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF) ; White.
        _GDIPlus_GraphicsFillRect($hIdenticonGraphic, 0, 0, 512, 512, $hBrush)
        _GDIPlus_BrushDispose($hBrush)
    EndIf
    If 2 > $aVectors[1] Then $aVectors[1] += 2 ; TODO: Creates bias for diamond shapes.
    If $IDENTICON_CHECKERBOARD = BitAND($aVectors[0], $IDENTICON_CHECKERBOARD) Then
        ; Black side.
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 0, 128, 128) ; 4
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 5
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 7
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 10
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 256, 128, 128) ; 12
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 384, 128, 128) ; 13
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 384, 128, 128) ; 15
        _GDIPlus_BitmapDispose($hSprite)
        ; Red side.
        $aVectors[1] = BitAND($aVectors[1] + $aVectors[3] + $aVectors[4], 7)
        $aVectors[2] = BitAND($aVectors[2] + $aVectors[5] + $aVectors[6], 1)
        If 2 > $aVectors[1] Then $aVectors[1] += 2 ; TODO: Creates bias for diamond shapes.
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[9], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 0, 128, 128) ; 3
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128) ; 6
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 128, 128, 128) ; 8
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 9
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 11
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 384, 128, 128) ; 14
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 384, 128, 128) ; 16
        _GDIPlus_BitmapDispose($hSprite)
    ElseIf $IDENTICON_SPACE_INVADER = BitAND($aVectors[0], $IDENTICON_SPACE_INVADER) Then
        ; Corner sprites.
        $hSprite = __Identicon_RenderOuterSprite($aVectors[3], $aVectors[4], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 384, 128, 128) ; 13
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 384, 128, 128) ; 16
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 0, 128, 128) ; 4
        ; Side sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderOuterSprite($aVectors[5], $aVectors[6], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 384, 128, 128) ; 14
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 0, 128, 128) ; 3
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 384, 128, 128) ; 15
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 5
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 9
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 128, 128, 128) ; 8
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 256, 128, 128) ; 12
        ; Center sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128) ; 6
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 7
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 10
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 11
        _GDIPlus_BitmapDispose($hSprite)
    Else ; Standard Identicon.
        ; Corner sprites.
        $hSprite = __Identicon_RenderOuterSprite($aVectors[3], $aVectors[4], $aVectors[8])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 0, 128, 128) ; 1
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 0, 128, 128) ; 4
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 384, 128, 128) ; 16
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 384, 128, 128) ; 13
        ; Side sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderOuterSprite($aVectors[5], $aVectors[6], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 0, 128, 128) ; 2
        $hSpriteFlip = _GDIPlus_BitmapCloneArea($hSprite, 0, 0, 128, 128, $GDIP_PXF64ARGB)
        _GDIPlus_ImageRotateFlip($hSpriteFlip, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSpriteFlip, 256, 0, 128, 128) ; 3
        _GDIPlus_ImageRotateFlip($hSpriteFlip, 6) ; Flip horizontal.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSpriteFlip, 256, 384, 128, 128) ; 15
        _GDIPlus_ImageRotateFlip($hSpriteFlip, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSpriteFlip, 128, 384, 128, 128) ; 14
        _GDIPlus_BitmapDispose($hSpriteFlip)
        $hSprite = __Identicon_Rotate($hSprite, 90)
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 128, 128, 128) ; 8
        _GDIPlus_ImageRotateFlip($hSprite, 6) ; Flip horizontal.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 384, 256, 128, 128) ; 12
        _GDIPlus_ImageRotateFlip($hSprite, 4) ; Flip vertical.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 256, 128, 128) ; 9
        _GDIPlus_ImageRotateFlip($hSprite, 6) ; Flip horizontal.
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 0, 128, 128, 128) ; 5
        ; Center sprites.
        _GDIPlus_BitmapDispose($hSprite)
        $hSprite = __Identicon_RenderCenterSprite($aVectors[1], $aVectors[2], $aVectors[8], $aVectors[9])
        If 0 = $hSprite Then
            _GDIPlus_GraphicsDispose($hIdenticonGraphic)
            _GDIPlus_BitmapDispose($hIdenticonBitmap)
            Return SetError($E_IDENTICON_GDIPLUS_FAILURE, 0, 0)
        EndIf
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 128, 128, 128) ; 6
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 128, 128, 128) ; 7
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 128, 256, 128, 128) ; 10
        _GDIPlus_GraphicsDrawImageRect($hIdenticonGraphic, $hSprite, 256, 256, 128, 128) ; 11
        _GDIPlus_BitmapDispose($hSprite)
    EndIf
    _GDIPlus_GraphicsDispose($hIdenticonGraphic)
    Return $hIdenticonBitmap
EndFunc   ;==>__Identicon_Render4x4

; #GDIP_FUNCTIONS# =============================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GDIPlus_BitmapCreateFromScan0
; Description ...: Creates a Bitmap object based on an array of bytes along with size and format information
; Syntax.........: _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight[, $iStride = 0[, $iPixelFormat = 0x0026200A[, $pScan0 = 0]]])
; Parameters ....: $iWidth 		- The bitmap width, in pixels
;                  $iHeight 	- The bitmap height, in pixels
;                  $iStride 	- Integer that specifies the byte offset between the beginning of one scan line and the next. This
;                  +is usually (but not necessarily) the number of bytes in the pixel format (for example, 2 for 16 bits per pixel)
;                  +multiplied by the width of the bitmap. The value passed to this parameter must be a multiple of four
;                  $iPixelFormat - Specifies the format of the pixel data. Can be one of the following:
;                  |$GDIP_PXF01INDEXED   - 1 bpp, indexed
;                  |$GDIP_PXF04INDEXED   - 4 bpp, indexed
;                  |$GDIP_PXF08INDEXED   - 8 bpp, indexed
;                  |$GDIP_PXF16GRAYSCALE - 16 bpp, grayscale
;                  |$GDIP_PXF16RGB555    - 16 bpp; 5 bits for each RGB
;                  |$GDIP_PXF16RGB565    - 16 bpp; 5 bits red, 6 bits green, and 5 bits blue
;                  |$GDIP_PXF16ARGB1555  - 16 bpp; 1 bit for alpha and 5 bits for each RGB component
;                  |$GDIP_PXF24RGB       - 24 bpp; 8 bits for each RGB
;                  |$GDIP_PXF32RGB       - 32 bpp; 8 bits for each RGB. No alpha.
;                  |$GDIP_PXF32ARGB      - 32 bpp; 8 bits for each RGB and alpha
;                  |$GDIP_PXF32PARGB     - 32 bpp; 8 bits for each RGB and alpha, pre-mulitiplied
;                  $pScan0		- Pointer to an array of bytes that contains the pixel data. The caller is responsible for
;                  +allocating and freeing the block of memory pointed to by this parameter.
; Return values .: Success      - Returns a handle to a new Bitmap object
;                  Failure      - 0 and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
; Author ........: Authenticity
; Remarks .......: After you are done with the object, call _GDIPlus_ImageDispose to release the object resources
; Related .......: _GDIPlus_ImageDispose
; Link ..........; @@MsdnLink@@ GdipCreateBitmapFromScan0
; Example .......; Yes
; ===============================================================================================================================
Func _GDIPlus_BitmapCreateFromScan0($iWidth, $iHeight, $iStride = 0, $iPixelFormat = 0x0026200A, $pScan0 = 0)
	Local $aResult = DllCall($ghGDIPDll, 'uint', 'GdipCreateBitmapFromScan0', 'int', $iWidth, 'int', $iHeight, 'int', $iStride, 'int', $iPixelFormat, 'ptr', $pScan0, 'int*', 0)
	If @error Then Return SetError(@error, @extended, 0)
	;$GDIP_STATUS = $aResult[0]
	Return $aResult[6]
EndFunc   ;==>_GDIPlus_BitmapCreateFromScan0

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: _GDIPlus_ImageRotateFlip
; Description ...: Rotates and flips an image
; Syntax.........: _GDIPlus_ImageRotateFlip($hImage, $iRotateFlipType)
; Parameters ....: $hImage  		- Pointer to an Image object
;                  $iRotateFlipType - Type of rotation and flip:
;                  |0 - No rotation and no flipping (A 180-degree rotation, a horizontal flip and then a vertical flip)
;                  |1 - A 90-degree rotation without flipping (A 270-degree rotation, a horizontal flip and then a vertical flip)
;                  |2 - A 180-degree rotation without flipping (No rotation, a horizontal flip folow by a vertical flip)
;                  |3 - A 270-degree rotation without flipping (A 90-degree rotation, a horizontal flip and then a vertical flip)
;                  |4 - No rotation and a horizontal flip (A 180-degree rotation followed by a vertical flip)
;                  |5 - A 90-degree rotation followed by a horizontal flip (A 270-degree rotation followed by a vertical flip)
;                  |6 - A 180-degree rotation followed by a horizontal flip (No rotation and a vertical flip)
;                  |7 - A 270-degree rotation followed by a horizontal flip (A 90-degree rotation followed by a vertical flip)
; Return values .: Success      - True
;                  Failure      - False and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
; Author ........: Authenticity
; Remarks .......: None
; Related .......: None
; Link ..........; @@MsdnLink@@ GdipImageRotateFlip
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_ImageRotateFlip($hImage, $iRotateFlipType)
	Local $aResult = DllCall($ghGDIPDll, 'uint', 'GdipImageRotateFlip', 'hwnd', $hImage, 'int', $iRotateFlipType)
	If @error Then Return SetError(@error, @extended, False)
	;$GDIP_STATUS = $aResult[0]
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_ImageRotateFlip

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsSetInterpolationMode
; Description ...: Sets the interpolation mode of a Graphics object
; Syntax.........: _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
; Parameters ....: $hGraphics 		   - Pointer to a Graphics object
;                  $iInterpolationMode - Interpolation mode:
;                  |0 - Default interpolation mode
;                  |1 - Low-quality mode
;                  |2 - High-quality mode
;                  |3 - Bilinear interpolation. No prefiltering is done
;                  |4 - Bicubic interpolation. No prefiltering is done
;                  |5 - Nearest-neighbor interpolation
;                  |6 - High-quality, bilinear interpolation. Prefiltering is performed to ensure high-quality shrinking
;                  |7 - High-quality, bicubic interpolation. Prefiltering is performed to ensure high-quality shrinking
; Return values .: Success      - True
;                  Failure      - False and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
; Author ........: Authenticity
; Remarks .......: The interpolation mode determines the algorithm that is used when images are scaled or rotated
; Related .......: _GDIPlus_GraphicsGetInterpolationMode
; Link ..........; @@MsdnLink@@ GdipSetInterpolationMode
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetInterpolationMode($hGraphics, $iInterpolationMode)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipSetInterpolationMode", "hwnd", $hGraphics, "int", $iInterpolationMode)
	If @error Then Return SetError(@error, @extended, False)
	;$GDIP_STATUS = $aResult[0]
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetInterpolationMode

; #FUNCTION# ====================================================================================================================
; Name...........: _GDIPlus_GraphicsSetPixelOffsetMode
; Description ...: Sets the pixel offset mode of a Graphics object
; Syntax.........: _GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, $iPixelOffsetMode)
; Parameters ....: $hGraphics 		 - Pointer to a Graphics object
;                  $iPixelOffsetMode - Pixel offset mode:
;                  |0,1,3 - Pixel centers have integer coordinates
;                  |2,4	  - Pixel centers have coordinates that are half way between integer values (i.e. 0.5, 20, 105.5, etc...)
; Return values .: Success      - True
;                  Failure      - False and either:
;                  |@error and @extended are set if DllCall failed
;                  |$GDIP_STATUS contains a non zero value specifying the error code
; Author ........: Authenticity
; Remarks .......: None
; Related .......: _GDIPlus_GraphicsGetPixelOffsetMode
; Link ..........; @@MsdnLink@@ GdipSetPixelOffsetMode
; Example .......; No
; ===============================================================================================================================
Func _GDIPlus_GraphicsSetPixelOffsetMode($hGraphics, $iPixelOffsetMode)
	Local $aResult = DllCall($ghGDIPDll, "uint", "GdipSetPixelOffsetMode", "hwnd", $hGraphics, "int", $iPixelOffsetMode)
	If @error Then Return SetError(@error, @extended, False)
	;$GDIP_STATUS = $aResult[0]
	Return $aResult[0] = 0
EndFunc   ;==>_GDIPlus_GraphicsSetPixelOffsetMode
