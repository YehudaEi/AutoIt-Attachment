#include <GDIPlus.au3>
#include <File.au3>
#include <Array.au3>


; Declare array
Dim $Images[1]

; Gets all JPG files in the current directory (@ScriptDir).
Local $search = FileFindFirstFile("*.jpg")

; Check if the search was successful
If $search = -1 Then
    MsgBox(0, "Error", "No JPG files could be found.")
    Exit
EndIf

; Resize array
While 1
    If IsArray($Images) Then
        Local $Bound = UBound($Images)
        ReDim $Images[$Bound+1]
    EndIf
    $Images[$Bound] = FileFindNextFile($search)
    If @error Then ExitLoop
WEnd

; Close the search handle
FileClose($search)

; Create directory "resized" if not there yet
If NOT FileExists(@ScriptDir & "\pictures\") Then
    DirCreate(@ScriptDir & "\pictures\")
EndIf

; Loop for JPGs - gets dimension of JPG and calls resize function to resize to 50% width and 50% height
For $i = 1 to Ubound($Images)-1
    If $Images[$i] <> "" AND FileExists(@ScriptDir & "\" & $Images[$i]) Then
        Local $ImagePath = @ScriptDir & "\" & $Images[$i]
        _GDIPlus_Startup()
        Local $hImage = _GDIPlus_ImageLoadFromFile($ImagePath)
        Local $ImageWidth = _GDIPlus_ImageGetWidth($hImage)
        Local $ImageHeight = _GDIPlus_ImageGetHeight($hImage)
        _GDIPlus_ImageDispose($hImage)
        _GDIPlus_Shutdown()
        ;MsgBox(0,"DEBUG", $ImageWidth & " x " & $ImageHeight)
		if $ImageWidth>$ImageHeight then
			Local $NewImageWidth = 500
			Local $NewImageHeight = 500/$ImageWidth*$ImageHeight
		Else
			Local $NewImageHeight = 500
			Local $NewImageWidth = 500/$ImageHeight*$ImageWidth
		EndIf
        ;MsgBox(0,"DEBUG: " & $i,$Images[$i])
        _ImageResize(@ScriptDir & "\" & $Images[$i], @ScriptDir & "\resized\" & $Images[$i], $NewImageWidth, $NewImageHeight)
    EndIf
Next

; Resize function
Func _ImageResize($sInImage, $sOutImage, $iW, $iH)
    Local $hWnd, $hDC, $hBMP, $hImage1, $hImage2, $hGraphic, $CLSID, $i = 0

    ;OutFile path, to use later on.
    Local $sOP = StringLeft($sOutImage, StringInStr($sOutImage, "\", 0, -1))

    ;OutFile name, to use later on.
    Local $sOF = StringMid($sOutImage, StringInStr($sOutImage, "\", 0, -1) + 1)

    ;OutFile extension , to use for the encoder later on.
    Local $Ext = StringUpper(StringMid($sOutImage, StringInStr($sOutImage, ".", 0, -1) + 1))

    ; Win api to create blank bitmap at the width and height to put your resized image on.
    $hWnd = _WinAPI_GetDesktopWindow()
    $hDC = _WinAPI_GetDC($hWnd)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDC, $iW, $iH)
    _WinAPI_ReleaseDC($hWnd, $hDC)

    ;Start GDIPlus
    _GDIPlus_Startup()

    ;Get the handle of blank bitmap you created above as an image
    $hImage1 = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)

    ;Load the image you want to resize.
    $hImage2 = _GDIPlus_ImageLoadFromFile($sInImage)

    ;Get the graphic context of the blank bitmap
    $hGraphic = _GDIPlus_ImageGetGraphicsContext ($hImage1)

    ;Draw the loaded image onto the blank bitmap at the size you want
    _GDIPLus_GraphicsDrawImageRect($hGraphic, $hImage2, 0, 0, $iW, $iH)

    ;Get the encoder of to save the resized image in the format you want.
    $CLSID = _GDIPlus_EncodersGetCLSID($Ext)

    ;Generate a number for out file that doesn't already exist, so you don't overwrite an existing image.
    Do
        $i += 1
    Until (Not FileExists($sOutImage))

    ;Prefix the number to the begining of the output filename
    $sOutImage = $sOP &  $sOF

    ;Save the new resized image.
    _GDIPlus_ImageSaveToFileEx($hImage1, $sOutImage, $CLSID)

    ;Clean up and shutdown GDIPlus.
    _GDIPlus_ImageDispose($hImage1)
    _GDIPlus_ImageDispose($hImage2)
    _GDIPlus_GraphicsDispose ($hGraphic)
    _WinAPI_DeleteObject($hBMP)
    _GDIPlus_Shutdown()
EndFunc
