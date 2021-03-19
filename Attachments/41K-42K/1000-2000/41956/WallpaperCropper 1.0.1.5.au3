#NoTrayIcon

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=C:\Scissors.ico
#AutoIt3Wrapper_Outfile=WallpaperCropper.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseX64=N
#AutoIt3Wrapper_Res_Description=Easily Crop a picture to a wanted dimension for set to wallpaper.
#AutoIt3Wrapper_Res_Fileversion=1.0.1.5
#AutoIt3Wrapper_Res_LegalCopyright=wakillon 2013
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compile date|%longdate% %time%
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;~ All Buttons made online with chimply.com the easy buttons Generator !
#include <GDIPlus.au3>

Opt ( 'GUICloseOnESC', 0 )
Opt ( 'GuiOnEventMode', 1 )
Opt ( 'TrayMenuMode', 1 )
Opt ( 'MustDeclareVars', 1 )
If Not _Singleton ( @ScriptName, 1 ) Then Exit
OnAutoItExitRegister ( '_OnAutoItExit' )

Global Const $GUI_DISABLE = 128
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $RDW_UPDATENOW = 0x0100
Global Const $RDW_VALIDATE = 0x0008

#Region ------ Global Variables ------------------------------
Global $hGui, $idLabel1, $hLabel1, $idLabel2, $idLabel3, $idLabel4, $idLabel5, $idLabel6, $hLabel6, $idLabel7
Global $idButtonSave, $idButtonExit, $idComboDesiredSize, $idComboFormat, $idEditSize, $idEditZoom, $idButtonSetAsWallpaper, $idButtonHelp, $idButtonOpen
Global $hGraphic1, $hImage1,  $hGraphic2, $hPen1, $hPen2, $hPen
Global $sVersion = _ScriptGetVersion ()
Global $sSoftTitle = 'WallpaperCropper  v' & $sVersion
Global $iPicX, $iPicY, $iPicWidth, $iPicHeight, $aPos, $iXDown, $iYDown, $tRect, $iZoom='', $iZoomMax, $j, $iCursorSet, $sString, $iWheel
Global $sTempDir = @TempDir & '\WallpaperCropper', $sCursorPath1 = $sTempDir & '\107.cur', $sCursorPath2 = $sTempDir & '\zoom-in.cur', $sDragFile, $sDragFileOld, $iDelete=0
Global $hUser32DLL = DllOpen ( 'user32.dll' )
Global $sRegTitleKey = 'WallpaperCropper'
Global $sRegKeySettings = 'HKCU' & StringReplace ( StringReplace ( StringReplace ( @OSArch, 'x64', '64' ), 'IA64', '64' ), 'x86', '' ) & '\Software\' & $sRegTitleKey & '\Settings'
Global $sWallpaperDir = @WindowsDir & '\web\wallpaper', $sBmpFile
Global $iTransFlag, $Flash
Global $iGuiWidth = @DesktopWidth/2 , $iGuiHeight = @DesktopHeight/2
Global $hBmpBuffer1, $hGfxBuffer1, $hBmpBuffer2, $hGfxBuffer2
Global $aPosBak, $iAdlib, $aCur, $iCurOld

If $iGuiWidth < 650 Then
    $iGuiWidth = 650
    $iGuiHeight = $iGuiWidth * @DesktopHeight/@DesktopWidth
EndIf

Global $iViewerWidth, $iViewerWidthOld, $iViewerHeight, $iOPicWidth, $iOPicHeight
Global $tStruct = DllStructCreate ( $tagPOINT ), $aMousePos
#EndRegion --- Global Variables ------------------------------

_GDIPlus_StartUp ()
_FileInstall ()
_Gui ()
_TrayMenuSet ()
If RegRead ( $sRegKeySettings, '' ) = '' And _IsLaptopPC () Then _
    MsgBox ( 262144+48, 'Mouse wheel needed !', @CRLF & 'Attention, LapTop User :' & @CRLF & @CRLF & _
    'For Zoom/UnZoom picture with WallpaperCropper' & @TAB & @CRLF & 'you need to plug a Mouse to your PC !' & @TAB & @CRLF & @CRLF )

#Region ------ Main Loop ------------------------------
While 1
    If $sDragFile Then
        $aMousePos = MouseGetPos ()
        If Not @error Then
            DllStructSetData ( $tStruct, 1, $aMousePos[0] )
            DllStructSetData ( $tStruct, 2, $aMousePos[1] )
            If _WinAPI_GetAncestor ( _WinAPI_WindowFromPoint ( $tStruct ), 2 ) = $hGui Then
                $aPos = GUIGetCursorInfo ( $hGui )
                If Not @error Then
                    If $aPos[4] = $idLabel1 Or $aPos[4] = $idButtonSetAsWallpaper Or $aPos[4] = $idButtonSave Or $aPos[4] = $idButtonExit Then
                        GUIRegisterMsg ( $WM_LBUTTONDOWN, '' )
                        If Not $iCursorSet  Then
                            If $aPos[4] = $idLabel1 Then
                                _CursorSet ( $sCursorPath2, 32512 ) ; $OCR_NORMAL
                                _CursorSet ( $sCursorPath2, 32513 ) ; $OCR_IBEAM
                                $iCursorSet = 1
                            EndIf
                            ControlFocus ( $hGui, '', $idButtonSave ) ; avoid combos scroll when Mouse cursor is over Picture.
                        Else
                            If $aPos[4] <> $idLabel1 Then
                                GUIRegisterMsg ( $WM_LBUTTONDOWN, '_WM_LBUTTONDOWN' )
                                If $iCursorSet Then _CursorRemove ()
                            EndIf
                        EndIf
                    Else
                        GUIRegisterMsg ( $WM_LBUTTONDOWN, '_WM_LBUTTONDOWN' )
                        If $iCursorSet Then _CursorRemove ()
                    EndIf
                Else
                    If $iCursorSet Then _CursorRemove ()
                EndIf
            Else
                If $iCursorSet Then _CursorRemove ()
            EndIf
        EndIf
    EndIf
    $aCur = GUIGetCursorInfo ( $hGui )
    If Not @error Then
        Switch $aCur[4]
            Case $idButtonHelp To $idButtonExit ; $idButtonSave
                If $aCur[4] <> $iCurOld Then
                    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $aCur[4], -1 )
                    $iCurOld = $aCur[4]
                EndIf
            Case Else
                $iCurOld = 0
        EndSwitch
    EndIf
    Sleep ( 100 )
WEnd
#EndRegion --- Main Loop ------------------------------

Func _ArrayAdd ( ByRef $avArray, $vValue )
    If Not IsArray ( $avArray ) Then Return SetError ( 1, 0, -1 )
    If UBound ( $avArray, 0 ) <> 1 Then Return SetError ( 2, 0, -1 )
    Local $iUBound = UBound ( $avArray )
    ReDim $avArray[$iUBound + 1]
    $avArray[$iUBound] = $vValue
    Return $iUBound
EndFunc ;==> _ArrayAdd ()

Func _Base64Decode ( $input_string ) ; by trancexx
    Local $struct = DllStructCreate ( 'int' )
    Local $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', 0, 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
    If @error Or Not $a_Call[0] Then Return SetError ( 1, 0, '' )
    Local $a = DllStructCreate ( 'byte[' & DllStructGetData ( $struct, 1) & ']' )
    $a_Call = DllCall ( 'Crypt32.dll', 'int', 'CryptStringToBinary', 'str', $input_string, 'int', 0, 'int', 1, 'ptr', DllStructGetPtr ( $a ), 'ptr', DllStructGetPtr ( $struct, 1 ), 'ptr', 0, 'ptr', 0 )
    If @error Or Not $a_Call[0] Then Return SetError ( 2, 0, '' )
    Return DllStructGetData ( $a, 1 )
EndFunc ;==> _Base64Decode ()

Func _CursorRemove ()
    DllCall ( $hUser32DLL, 'int', 'SystemParametersInfo', 'int', 0x0057, 'int', 0, 'int', 0, 'int', 0 ) ; $SPI_SetCursors
    $iCursorSet = 0
EndFunc ;==> _CursorRemove ()

Func _CursorSet ( $sCursorFilePath, $iCursorType )
    Local $aNewCur, $aRet
    $aNewCur = DllCall ( $hUser32DLL, 'int', 'LoadCursorFromFile', 'str', $sCursorFilePath )
    If Not @error Then
        $aRet = DllCall ( $hUser32DLL, 'int', 'SetSystemCursor', 'int', $aNewCur[0], 'int', $iCursorType )
        If Not @error Then DllCall ( $hUser32DLL, 'int', 'DestroyCursor', 'int', $aNewCur[0] )
    EndIf
EndFunc ;==> _CursorSet ()

Func _Exit ()
    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $idButtonExit, 1 )
    Exit
EndFunc ;==> _Exit ()

Func _FileGetExtByFullPath ( $sFullPath )
    Local $aFileName = StringSplit ( $sFullPath, '.' )
    If Not @error Then Return $aFileName[$aFileName[0]]
    Return SetError ( 1 )
EndFunc ;==> _FileGetExtByFullPath ()

Func _FileGetFullNameByFullPath ( $sFullPath )
    Local $aFileName = StringSplit ( $sFullPath, '\' )
    If Not @error Then Return $aFileName[$aFileName[0]]
EndFunc ;==> _FileGetFullNameByFullPath ()

Func _FileGetType ( $sFilePath )
    If Not FileExists ( $sFilePath ) Then Return SetError ( -1 )
    If FileGetSize ( $sFilePath ) = 0 Then Return SetError ( 2, 0, 0 )
    Local $sExt = StringUpper ( _FileGetExtByFullPath ( $sFilePath ) )
    Local $hFile, $Binary
    $hFile = FileOpen ( $sFilePath, 16 )
    If $hFile = -1 Then Return SetError ( 3, 0, 0 )
    $Binary = FileRead ( $hFile )
    FileClose ( $hFile )
    Local $sString =  StringTrimLeft ( $Binary, 2 )
    Local $sStringLeft = StringReplace ( StringTrimLeft ( StringLeft ( $Binary, 14 ), 2 ), '00', '' )
    Local $sStringLeft12 = StringLeft ( $sStringLeft, 12 )
    Local $sStringLeft8 = StringLeft ( $sStringLeft, 8 )
    Local $sStringLeft6 = StringLeft ( $sStringLeft, 6 )
    Local $sStringLeft4 = StringLeft ( $sStringLeft, 4 )
    Local $aOut[2]
    Select
        Case $sStringLeft12 = '474946383961'
            $aOut[0] = 'GIF 89A Bitmap'
            $aOut[1] = 'GIF'
        Case $sStringLeft12 = '474946383761'
            $aOut[0] = 'GIF 87A Bitmap'
            $aOut[1] = 'GIF'
        Case $sStringLeft8 = 'FFD8FFE0'
            $aOut[0] = 'JPEG/JFIF graphics file'
            $aOut[1] = 'JPG'
        Case $sStringLeft8 = 'FFD8FFE1'
            $aOut[0] = 'Standard JPEG/Exif'
            $aOut[1] = 'JPG'
        Case $sStringLeft8 = 'FFD8FFE2'
            $aOut[0] = 'Canon EOS 1D JPEG file'
            $aOut[1] = 'JPG'
        Case $sStringLeft8 = 'FFD8FFE3'
            $aOut[0] = 'Samsung D500 JPEG file'
            $aOut[1] = 'JPG'
        Case $sStringLeft8 = 'FFD8FFE8'
            $aOut[0] = 'Still Picture Interchange File Format (SPIFF)'
            $aOut[1] = 'JPG'
        Case $sStringLeft8 = 'FFD8FFDB'
            $aOut[0] = 'Samsung D807 JPEG file'
            $aOut[1] = 'JPG'
        Case $sStringLeft4 = 'FFD8'
            $aOut[0] = 'JPEG file'
            $aOut[1] = 'JPG'
        Case $sStringLeft4 = '424D'
            $aOut[0] = 'Windows Bitmap BMP'
            $aOut[1] = 'BMP'
        Case $sStringLeft8 = '89504E47'
            $aOut[0] = 'Portable Network Graphics  PNG'
            $aOut[1] = 'PNG'
        Case $sStringLeft6 = '492049'
            $aOut[0] = 'Tagged Image File Format file'
            $aOut[1] = 'TIFF'
        Case $sStringLeft8 = '49492A00'
            $aOut[0] = 'Tagged Image File Format file little endian'
            $aOut[1] = 'TIFF'
        Case $sStringLeft6 = '4D4D2A'
            $aOut[0] = 'Tagged Image File Format file big endian'
            $aOut[1] = 'TIFF'
        Case $sStringLeft6 = '4D4D2B'
            $aOut[0] = 'BigTIFF files'
            $aOut[1] = 'TIFF'
    EndSelect
    If $aOut[1] = 'GIF' Then
        StringReplace ( $sString, '0021F904', '0021F904' )
        If @extended > 1 Then $aOut[0] = 'Animated ' & $aOut[0]
    EndIf
    Return $aOut
EndFunc ;==> _FileGetType ()

Func _FileInstall ()
    If Not FileExists ( $sWallpaperDir & '\' & $sRegTitleKey ) Then DirCreate ( $sWallpaperDir & '\' & $sRegTitleKey )
    If Not FileExists ( $sTempDir ) Then DirCreate ( $sTempDir )
    If Not FileExists ( 'C:\Scissors.ico' ) Then Scissorsico ( 'Scissors.ico', 'C:\' )
    If Not FileExists ( $sCursorPath1 ) Then Cursor4Arrows ( '107.cur', $sTempDir )
    If Not FileExists ( $sCursorPath2 ) Then CursorZoom ( 'zoom-in.cur', $sTempDir )
    If Not FileExists ( $sTempDir & '\fizz17.wav' ) Then Fizz17Wav ( 'fizz17.wav', $sTempDir )
    If Not FileExists ( $sTempDir & '\image_474248.gif' ) Then Image_474248Gif  ( 'image_474248.gif', $sTempDir )
    If Not FileExists ( $sTempDir & '\image_474252.gif' ) Then Image_474252Gif  ( 'image_474252.gif', $sTempDir )
    If Not FileExists ( $sTempDir & '\image_474254.gif' ) Then Image_474254Gif  ( 'image_474254.gif', $sTempDir )
    If Not FileExists ( $sTempDir & '\image_475186.gif' ) Then Image_475186Gif  ( 'image_475186.gif', $sTempDir )
    If Not FileExists ( $sTempDir & '\image_475187.gif' ) Then Image_475187Gif  ( 'image_475187.gif', $sTempDir )
EndFunc ;==> _FileInstall ()

Func _FlashColor ()
    $Flash = Not $Flash
    If $Flash Then
        $hPen = $hPen1
    Else
        $hPen = $hPen2
    EndIf
    _WinAPI_RedrawWindow ( $hGUI, $tRect )
EndFunc ;==> _FlashColor ()

Func _GDIPlus_ImageGetTransParency ( $hImage )
    Local $aPixelFormat = _GDIPlus_ImageGetPixelFormat ( $hImage )
    If @error Then Return SetError ( @error, @extended, -1 )
    If StringInStr ( $aPixelFormat[1], 'ARGB' ) Then Return 1
EndFunc ;==> _GDIPlus_ImageGetTransParency ()

Func _Gui ()
    Local $X = RegRead ( $sRegKeySettings, 'X' )
    Local $Y = RegRead ( $sRegKeySettings, 'Y' )
    If Not $X Then $X = -1
    If Not $Y Then $Y = -1
    $hGui = GUICreate ( $sSoftTitle & ' by wakillon', $iGuiWidth+220, $iGuiHeight, $X, $Y, -1, 0x00000010 )
    GUISetOnEvent ( -13, '_GuiGetDroppedFilePath' ) ; $GUI_EVENT_DROPPED
    GUISetOnEvent ( -7, '_PicDrag' ) ; $GUI_EVENT_PRIMARYDOWN
    GUISetIcon ( 'C:\Scissors.ico', '', $hGui )
    $idLabel1 = GUICtrlCreateLabel ( @CRLF & @CRLF & $sSoftTitle & ' by wakillon' & @CRLF & @CRLF & _
        "Drag'n drop a Picture here" & @CRLF & @CRLF & _
        '(drag it for position it and use mouse wheel for Zoom / Unzoom it)', 1, 1, $iGuiWidth, $iGuiHeight, 0x01 )
    GUICtrlSetBkColor ( -1, 0x000000 )
    GUICtrlSetColor ( -1, 0xFFFFFF )
    GUICtrlSetFont ( -1, 18, 400 )
    GUICtrlSetState ( -1, $GUI_DISABLE + 8 ) ; $GUI_DROPACCEPTED
    $hLabel1 = GUICtrlGetHandle ( -1 )
;~  ; Rect used to send Paint msg for avoid flickering.
    $tRect = _WinAPI_GetClientRect ( 0 )
    DllStructSetData ( $tRect, 'Left', $iGuiWidth+100 )
    DllStructSetData ( $tRect, 'Right', $iGuiWidth+200 )
    DllStructSetData ( $tRect, 'Top', 0 )
    DllStructSetData ( $tRect, 'Bottom', 5 )
    $idLabel4 = GUICtrlCreateLabel ( 'Zoom x ', $iGuiWidth +20, 20, 100, 20 )
    GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    $idEditZoom = GUICtrlCreateEdit ( '', $iGuiWidth +120, 18, 85, 20, 2048 ) ; $ES_READONLY
    GUICtrlSetColor ( -1, 0x000000 )
    GUICtrlSetFont ( -1, 9, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    $idLabel2 = GUICtrlCreateLabel ( 'Original Size :', $iGuiWidth +20, 50, 100, 23 )
    GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    $idEditSize = GUICtrlCreateEdit ( '', $iGuiWidth +120, 48, 85, 20, 2048 ) ; $ES_READONLY
    GUICtrlSetColor ( -1, 0x000000 )
    GUICtrlSetFont ( -1, 9, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    $idLabel3 = GUICtrlCreateLabel ( 'Cropped Size', $iGuiWidth +20, 80, 97, 23 )
    GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    Local $sSize = RegRead ( $sRegKeySettings, 'CroppedSize' )
    If @error Then $sSize = @DesktopWidth & ' x ' & @DesktopHeight ; Set Default Value
    Local $sSizes = '800 x 480|800 x 600|854 x 480|1024 x 576|1024 x 600|1024 x 768|1024 x 800|1120 x 832|1152 x 720|1152 x 768|1152 x 864|1152 x 900|1280 x 720|1280 x 768|' & _
        '1280 x 800|1280 x 854|1280 x 960|1280 x 1024|1360 x 768|1366 x 768|1366 x 900|1400 x 1050|1440 x 900|1440 x 960|1440 x 1024|1400 x 1050|1440 x 1080|1600 x 900|' & _
        '1600 x 1024|1600 x 1200|1680 x 945|1680 x 1050|1792 x 1344|1800 x 1440|1856 x 1392|1920 x 1080|1920 x 1200|1920 x 1400|1920 x 1440|2048 x 1152|2048 x 1280|2048 x 1536|' & _
        '2304 x 1440|2304 x 1728|2560 x 1440|2560 x 1600|2560 x 1700|2560 x 1920|2560 x 2048|2880 x 1800|2800 x 2100|3200 x 1800|3200 x 2048|3200 x 2400|' & _
        '3840 x 2160|3840 x 2400|4096 x 2304|4096 x 3072|5120 x 3200|5120 x 4096|6400 x 4096|6400 x 4800|7680 x 4320|7680 x 4800|8192 x 4608'
    $idComboDesiredSize = GUICtrlCreateCombo ( $sSize, $iGuiWidth +120, 78, 85, 20, BitOR ( 0x2, 0x0003, BitOR ( 0x2, 0x40, 0x00200000 ) ) ) ; $CBS_SIMPLE, $CBS_DROPDOWNLIST, $GUI_SS_DEFAULT_COMBO
    GUICtrlSetData ( -1, _GuiComboSetDefaultDatas ( $sSizes, $sSize ) )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    GUICtrlSetState ( -1, $GUI_DISABLE )
    $idLabel5 = GUICtrlCreateLabel ( 'Save Format :', $iGuiWidth +20, 110, 97, 20 )
    GUICtrlSetColor ( -1, 0xFF0000 )
    GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    Local $sFormat = RegRead ( $sRegKeySettings, 'Formats' )
    If @error Then $sFormat = 'JPG' ; Set Default Value
    $idComboFormat = GUICtrlCreateCombo ( $sFormat, $iGuiWidth +120, 108, 85, 20, BitOR ( 0x2, 0x0003, BitOR ( 0x2, 0x40, 0x00200000 ) ) ) ; $CBS_SIMPLE, $CBS_DROPDOWNLIST, $GUI_SS_DEFAULT_COMBO
    Local $sFormats = 'JPG|PNG|BMP'
    GUICtrlSetData ( -1, _GuiComboSetDefaultDatas ( $sFormats, $sFormat ) )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    GUICtrlSetState ( -1, $GUI_DISABLE )
    $idLabel7 = GUICtrlCreateLabel ( '', $iGuiWidth +10, 145, 200, 30, 0x01 )
    GUICtrlSetColor ( -1, 0x000000 )
    GUICtrlSetFont ( -1, 7, 600 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    $idLabel6 = GUICtrlCreateLabel ( '', $iGuiWidth +10, 180, 200, 200 )
    GUICtrlSetBkColor ( -1, 0xF4F4F4 )
    GUICtrlSetResizing ( -1, 0x0020 + 768 ) ; $GUI_DOCKTOP + $GUI_DOCKSIZE
    GUICtrlSetState ( -1, $GUI_DISABLE )
    $hLabel6 = GUICtrlGetHandle ( -1 )
;~  #f4f4f4 background color used when creating buttons
    $idButtonHelp = GUICtrlCreatePic ( $sTempDir & '\image_475186.gif', $iGuiWidth +20, $iGuiHeight-120, 80, 25 )
;~     GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetOnEvent ( -1, '_Help' )
    GUICtrlSetTip ( -1, 'Get Help', $sSoftTitle, 1, 1 )
    GUICtrlSetResizing ( -1, 0x0040 + 768 ) ; $GUI_DOCKBOTTOM + $GUI_DOCKSIZE
    $idButtonOpen = GUICtrlCreatePic ( $sTempDir & '\image_475187.gif', $iGuiWidth +120, $iGuiHeight-120, 80, 25 )
;~     GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetOnEvent ( -1, '_Open' )
    GUICtrlSetTip ( -1, 'Open WallpaperCropper Directory of Pictures already set as Desktop Wallpaper', $sSoftTitle, 1, 1 )
    GUICtrlSetResizing ( -1, 0x0040 + 768 ) ; $GUI_DOCKBOTTOM + $GUI_DOCKSIZE
    $idButtonSetAsWallpaper = GUICtrlCreatePic ( $sTempDir & '\image_474248.gif', $iGuiWidth +20, $iGuiHeight-80, 180, 25 )
;~     GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetOnEvent ( -1, '_PicSetAsWallpaper' )
    GUICtrlSetTip ( -1, 'Set Cropped Picture as Desktop Wallpaper (' & @DesktopWidth & ' x ' & @DesktopHeight & ')', $sSoftTitle, 1, 1 )
    GUICtrlSetResizing ( -1, 0x0040 + 768 ) ; $GUI_DOCKBOTTOM + $GUI_DOCKSIZE
    $idButtonSave = GUICtrlCreatePic ( $sTempDir & '\image_474252.gif', $iGuiWidth +20, $iGuiHeight-40, 80, 25 )
;~     GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetOnEvent ( -1, '_PicSaveToCroppedSize' )
    GUICtrlSetTip ( -1, 'Save Cropped Picture on your Desktop.', $sSoftTitle, 1, 1 )
    GUICtrlSetResizing ( -1, 0x0040+ 768 ) ; $GUI_DOCKBOTTOM + $GUI_DOCKSIZE
    $idButtonExit = GUICtrlCreatePic ( $sTempDir & '\image_474254.gif', $iGuiWidth +120, $iGuiHeight-40, 80, 25 )
;~     GUICtrlSetFont ( -1, 11, 800 )
    GUICtrlSetOnEvent ( -1, '_Exit' )
    GUICtrlSetTip ( -1, 'Bye Bye !', $sSoftTitle, 1, 1 )
    GUICtrlSetResizing ( -1, 0x0040+ 768 ) ; $GUI_DOCKBOTTOM + $GUI_DOCKSIZE
    $hPen1 = _GDIPlus_PenCreate ( 0xFFFF0000, 1 ) ; red ARGB
    $hPen2 = _GDIPlus_PenCreate ( 0xFFFFFFFF, 1 ) ; white ARGB
    $hPen = $hPen2
    GUIRegisterMsg ( 0x000F, '_WM_PAINT' ) ; $WM_PAINT
    GUIRegisterMsg ( 0x020A, '_WM_MOUSEWHEEL' ) ; $WM_MOUSEWHEEL
    GUIRegisterMsg ( 0x0111, '_WM_COMMAND' ) ; $WM_COMMAND
    GUIRegisterMsg ( 0x0112, '_WM_SYSCOMMAND' ) ; $WM_SYSCOMMAND
    GUIRegisterMsg ( 0x0003, '_WM_MOVE' ) ; $WM_MOVE
    GUIRegisterMsg ( $WM_LBUTTONDOWN, '_WM_LBUTTONDOWN' )
    GUIRegisterMsg ( 0x0006, '_WM_ACTIVATE' ) ; $WM_ACTIVATE
    GUISetState ()
EndFunc ;==> _Gui ()

Func _GuiComboSetDefaultDatas ( $sString, $sDefaultValue )
    $sString = StringReplace ( StringReplace ( $sString, $sDefaultValue, '' ), '||', '|' )
    If StringLeft ( $sString, 1 ) = '|' Then $sString = StringTrimLeft ( $sString, 1 )
    If StringRight ( $sString, 1 ) = '|' Then $sString = StringTrimRight ( $sString, 1 )
    Return $sString
EndFunc ;==> _GuiComboSetDefaultDatas ()

Func _GuiCtrlPicButton_RestorePos ( )
    If IsArray ( $aPosBak ) Then
        GUICtrlSetPos ( $aPosBak[4], $aPosBak[0], $aPosBak[1], $aPosBak[2], $aPosBak[3] )
        $aPosBak = 0
    EndIf
    $iAdlib = 0
    AdlibUnRegister ( '_GuiCtrlPicButton_RestorePos' )
EndFunc ;==> _GuiCtrlPicButton_RestorePos ( )

Func _GuiCtrlPicButton_SimulateAction ( $iCtrlId, $iFlag=1 ) ; $iFlag : 1 for Simulate Press, -1 for Simulate Over.
    Local $aPos = ControlGetPos ( $hGui, '', $iCtrlId )
    If Not @error Then
        GUICtrlSetPos ( $iCtrlId, $aPos[0]+$iFlag, $aPos[1]+$iFlag, $aPos[2]-2*$iFlag, $aPos[3]-2*$iFlag )
        $aPosBak = $aPos
        _ArrayAdd ( $aPosBak, $iCtrlId )
        AdlibRegister ( '_GuiCtrlPicButton_RestorePos', 175+$iFlag*75 ) ; 250 / 100
        $iAdlib = 1
    EndIf
    $aPos = 0
EndFunc ;==> _GuiCtrlPicButton_SimulateAction ( )

Func _GuiGetDroppedFilePath ()
    $sDragFile = @GUI_DRAGFILE
    Local $aType = _FileGetType ( $sDragFile )
    If UBound ( $aType ) = 0 Then Return _TrayTip ( $sSoftTitle, 'This Filetype is not Supported !', 2 )
    If Not _IsFileSupported ( $aType ) Then Return
    AdlibUnRegister ( '_FlashColor' )
    Local $hImageHV = _GDIPlus_ImageLoadFromFile ( $sDragFile )
    Local $iPicWidthHV = _GDIPlus_ImageGetWidth ( $hImageHV )
    Local $iPicHeightHV = _GDIPlus_ImageGetHeight ( $hImageHV )
    _GDIPlus_ImageDispose ( $hImageHV )
    If $iPicHeightHV > $iPicWidthHV Then
        If $iCursorSet Then _CursorRemove ()
        $iDelete = 0
        MsgBox ( 262144+8192+16, $sSoftTitle, 'Error' & @CRLF & @CRLF & 'The height of this picture is bigger than his width !', 5 )
        Return
    EndIf
    ControlSetText ( $hGui, '', $idLabel1, '' )
    If $hImage1 Or $hGraphic1 Then
        If $hGfxBuffer1 Then _GDIPlus_GraphicsDispose ( $hGfxBuffer1 )
        If $hBmpBuffer1 Then _GDIPlus_BitmapDispose ( $hBmpBuffer1 )
        If $hGfxBuffer2 Then _GDIPlus_GraphicsDispose ( $hGfxBuffer2 )
        If $hBmpBuffer2 Then _GDIPlus_BitmapDispose ( $hBmpBuffer2 )
        _GDIPlus_GraphicsDispose ( $hGraphic2 )
        _GDIPlus_GraphicsDispose ( $hGraphic1 )
        _GDIPlus_ImageDispose ( $hImage1 )
        $iXDown = 0
        $iYDown = 0
        If $sDragFileOld And $iDelete Then FileDelete ( $sDragFileOld )
    EndIf
    GUICtrlSetState ( $idComboDesiredSize, 64 ) ; $GUI_ENABLE
    GUICtrlSetState ( $idComboFormat, 64 ) ; $GUI_ENABLE
    $iPicX = 0
    $iPicY = 0
    $hImage1 = _GDIPlus_ImageLoadFromFile ( $sDragFile )
    $iTransFlag = 0
    If _GDIPlus_ImageGetTransParency ( $hImage1 ) Then $iTransFlag = 1
    $iPicWidth = _GDIPlus_ImageGetWidth ( $hImage1 )
    $iOPicWidth = $iPicWidth
    $iPicHeight = _GDIPlus_ImageGetHeight ( $hImage1 )
    $iOPicHeight = $iPicHeight
    $iDelete = 0
    If Not _IsPressed ( '10' ) Then  ; Left Shift key.
        Local $iNewWidth, $iNewHeight
        If $iPicWidth > $iPicHeight Then
            $iNewWidth = $iGuiWidth/2 * $iPicWidth/$iPicHeight
            $iNewHeight = $iGuiWidth/2
        ElseIf $iPicHeight > $iPicWidth Then
            $iNewWidth = $iGuiWidth/2
            $iNewHeight = $iGuiWidth/2 * $iPicHeight/$iPicWidth
        ElseIf $iPicHeight = $iPicWidth Then
            $iNewWidth = $iGuiWidth/2
            $iNewHeight = $iGuiWidth/2
        EndIf
        Local $hGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hImage1 )
        Local $hNewBmp = _GDIPlus_BitmapCreateFromGraphics ( $iNewWidth, $iNewHeight, $hGraphic3 )
        Local $hNewGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hNewBmp )
        _GDIPlus_GraphicsDrawImageRect ( $hNewGraphic3, $hImage1, 0, 0, $iNewWidth, $iNewHeight )
        $sDragFile = @TempDir & '\' & _FileGetFullNameByFullPath ( $sDragFile )
        _GDIPlus_ImageSaveToFile ( $hNewBmp, $sDragFile )
        _GDIPlus_GraphicsDispose ( $hGraphic3 )
        _GDIPlus_GraphicsDispose ( $hNewGraphic3 )
        _GDIPlus_BitmapDispose ( $hNewBmp )
        _GDIPlus_ImageDispose ( $hImage1 )
        $hImage1 = _GDIPlus_ImageLoadFromFile ( $sDragFile )
        $iPicWidth = _GDIPlus_ImageGetWidth ( $hImage1 )
        $iPicHeight = _GDIPlus_ImageGetHeight ( $hImage1 )
        $iDelete = 1
    Else
        $iDelete = 0
    EndIf
    $hGraphic1 = _GDIPlus_GraphicsCreateFromHWND ( $hLabel1 )
    $hGraphic2 = _GDIPlus_GraphicsCreateFromHWND ( $hLabel6 )
    DllCall ( $ghGDIPDll, 'uint', 'GdipSetInterpolationMode', 'handle', $hGraphic1, 'int', 5 )
    Local $aWinClientSize = WinGetClientSize ( $hGui )
    $iViewerWidth = $aWinClientSize[0]-220
    If Not $iViewerWidthOld Then
        Local $aWinPos = WinGetPos ( $hGui )
        $iViewerWidthOld = $aWinPos[2] -220
    EndIf
    $iViewerHeight = $aWinClientSize[1]
    $hBmpBuffer1 = _GDIPlus_BitmapCreateFromGraphics ( $iViewerWidth, $iViewerHeight, $hGraphic1 )
    $hGfxBuffer1 = _GDIPlus_ImageGetGraphicsContext ( $hBmpBuffer1 )
    _GDIPlus_GraphicsSetSmoothingMode ( $hGfxBuffer1, 2 )
    $hBmpBuffer2 = _GDIPlus_BitmapCreateFromGraphics ( 200, 200, $hGraphic2 )
    $hGfxBuffer2 = _GDIPlus_ImageGetGraphicsContext ( $hBmpBuffer2 )
    If $iPicWidth/$iPicHeight <= $iViewerWidth/$iViewerHeight Then
        If $iPicWidth >= $iPicHeight Then
            $iZoomMax = $iPicWidth / $iViewerWidth
        ElseIf $iPicHeight > $iPicWidth Then
            $iZoomMax = $iPicHeight / $iViewerHeight
        EndIf
    ElseIf $iPicWidth/$iPicHeight > $iViewerWidth/$iViewerHeight Then
        If $iPicWidth >= $iPicHeight Then
            $iZoomMax = $iPicHeight / $iViewerHeight
        ElseIf $iPicHeight > $iPicWidth Then
            $iZoomMax = $iPicWidth / $iViewerWidth
        EndIf
    EndIf
    $iZoom = $iZoomMax
    _WinAPI_InvalidateRect ( $hGui )
    WinActivate ( $hGUI )
    ControlSetText ( $hGui, '', $idEditSize, $iOPicWidth & ' x ' & $iOPicHeight )
    ControlSetText ( $hGui, '', $idLabel7, _FileGetFullNameByFullPath ( @GUI_DRAGFILE ) )
    If $iZoom Then ControlSetText ( $hGui, '', $idEditZoom, StringFormat ( '%.2f',1/$iZoom ) )
    $sDragFileOld = $sDragFile
    AdlibRegister ( '_FlashColor', 1200 )
EndFunc ;==> _GuiGetDroppedFilePath ()

Func _Help ()
    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $idButtonHelp, 1 )
    Local $sText = 'Help : ' & @CRLF & @CRLF & _
        'Set your Windows desktop background wallpaper without stretching or distorting it.' & @CRLF & @CRLF & _
        'Does your desktop background picture look stretched ?' & @CRLF & _
        'Do you find it time-consuming to crop pictures to the right proportions for your desktop ?' & @CRLF & @CRLF & _
        'WallpaperCropper is the solution.' & @CRLF & @CRLF & _
        "Drag'n drop a Picture for load it." & @CRLF & _
        'Drag it for position it and use mouse wheel for zoom - unzoom it.(TouchPad users need to plug a Mouse )' & @CRLF & _
        'Select dimensions and format you want for save your wallpaper.' & @CRLF & _
        'Pictures with transparency are supported.' & @CRLF & _
        'By default Pictures are saved on your desktop.' & @CRLF & @CRLF & _
        'Crop and set any picture easily to your desktop dimensions in some few clicks.' & @CRLF & _
        "Don't waste time loading big, slow photo-editing software to manually crop it or resize it." & @CRLF & _
        "Don't stay stuck with the choices Windows gives you !" & @CRLF & @CRLF & _
        'Tips :' & @CRLF & @CRLF & _
        'Hold Left Ctrl key for move the photo more slowly.' & @CRLF & _
        'Hold Left Shift key for move the photo more quickly.' & @CRLF & _
        'Hold Left Shift key for Zoom/UnZoom more quickly.' & @CRLF & _
        "Hold Left Shift key when drag'n drop photo for work with the original picture quality. (Moves and Zoom are more slow)" & @CRLF & @CRLF & _
        'Thanks to use ' & $sRegTitleKey & ' !' & @CRLF & @CRLF & _
        'wakillon.'
    MsgBox ( 262144+8192+64, $sSoftTitle & ' by wakillon from autoitscript.com', @CRLF & @CRLF & $sText & @CRLF & @CRLF )
EndFunc ;==> _Help ()

Func _IsFileSupported ( $aType )
    Switch $aType[1]
        Case 'PNG', 'GIF', 'BMP', 'JPG', 'TIFF'
            If Not StringInStr ( $aType[0], 'animated' ) Then Return 1
    EndSwitch
    If Not $aType[0] Then $aType[0] = 'This Filetype'
    _TrayTip ( $sSoftTitle, $aType[0] & ' is not Supported !', 2 )
EndFunc ;==> _IsFileSupported ()

Func _IsLaptopPC ( $sComputer='.' )
    Local $objWMIService = ObjGet ( 'winmgmts://' & $sComputer & '/root/cimv2' )
    Local $colItems = $objWMIService.ExecQuery ( 'Select * from Win32_Battery' )
    For $objItem in $colItems
        If $objItem <> '' Then Return True
    Next
    Return False
EndFunc ;==> _IsLaptopPC ()

Func _IsMinimized ( $hWnd )
    If BitAnd ( WinGetState ( $hWnd ), 16 ) Then Return 1
EndFunc ;==> _IsMinimized ()

Func _IsPressed ( $sHexKey )
    Local $aRet = DllCall ( $hUser32DLL, 'short', 'GetAsyncKeyState', 'int', '0x' & $sHexKey )
    If @error Then Return SetError ( @error, @extended, False )
    Return BitAND ( $aRet[0], 0x8000 ) <> 0
EndFunc ;==> _IsPressed ()

Func _IsVisible ( $hWnd )
    If BitAnd ( WinGetState ( $hWnd ), 2 ) Then Return 1
EndFunc ;==> _IsVisible ()

Func _LzmaDec ( $Source ) ; by Ward
    Local $__LZMADLL = @TempDir & '\LZMA.DLL'
    If Not FileExists ( $__LZMADLL ) Then Lzmadll ( 'LZMA.DLL', @TempDir )
    If @error Then Return SetError ( 1, 0, $Source )
    If BinaryLen ( $Source ) < 9 Then Return SetError ( 2, 0, $Source )
    Local $Src = DllStructCreate ( 'byte[' & BinaryLen ( $Source ) & ']' ), $Ret
    DllStructSetData ( $Src, 1, $Source )
    $Ret = DllCall ( $__LZMADLL, 'uint:cdecl', 'LzmaDecGetSize', 'ptr', DllStructGetPtr ( $Src ) )
    If @Error Then Return SetError ( 3, 0, $Source )
    Local $DestSize = $Ret[0]
    If $DestSize = 0 Then Return SetError ( 4, 0, $Source )
    Local $Dest = DllStructCreate ( 'byte[' & $DestSize & ']' )
    $Ret = DllCall ( $__LZMADLL, 'int:cdecl', 'LzmaDec', 'ptr', DllStructGetPtr ( $Dest ), 'uint*', $DestSize, 'ptr', DllStructGetPtr ( $Src ), 'uint', BinaryLen ( $Source ) )
    If Not @Error Then
        Return SetExtended ( $Ret[0], DllStructGetData ( $Dest, 1 ) )
    Else
        Return SetError ( 5, 0, $Source )
    EndIf
EndFunc ;==> _LzmaDec ()

Func _Minimize ()
    If _IsVisible ( $hGui ) Then
        GUISetState ( @SW_HIDE, $hGui )
    Else
        GUISetState ( @SW_SHOW, $hGui )
    EndIf
EndFunc ;==> _Minimize ()

Func _OnAutoItExit ()
    AdlibUnRegister ( '_FlashColor' )
    GUISetState ( 32, $hGui ) ; $GUI_HIDE
    _GDIPlus_PenDispose ( $hPen1 )
    _GDIPlus_PenDispose ( $hPen2 )
    _GDIPlus_GraphicsDispose ( $hGfxBuffer1 )
    _GDIPlus_BitmapDispose ( $hBmpBuffer1 )
    _GDIPlus_GraphicsDispose ( $hGfxBuffer2 )
    _GDIPlus_BitmapDispose ( $hBmpBuffer2 )
    _GDIPlus_GraphicsDispose ( $hGraphic2 )
    _GDIPlus_GraphicsDispose ( $hGraphic1 )
    _GDIPlus_ImageDispose ( $hImage1 )
    _GDIPlus_ShutDown ()
    DllClose ( $hUser32DLL )
    If $iDelete Then FileDelete ( $sDragFile )
EndFunc ;==> _OnAutoItExit ()

Func _Open ()
    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $idButtonOpen, 1 )
    Run ( 'explorer.exe ' & $sWallpaperDir & '\' & $sRegTitleKey ) ; @WindowsDir & '\web\wallpaper\WallpaperCropper
EndFunc ;==> _Open ()

Func _PicDrag ()
    If Not $sDragFile Then Return
    _CursorSet ( $sCursorPath1, 32512 ) ; $OCR_NORMAL
    _CursorSet ( $sCursorPath1, 32513 ) ; $OCR_IBEAM
    $iCursorSet = 1
    Local $aPos[5], $aPosOld[2]
    Do
        $aPos = GUIGetCursorInfo ( $hGui )
        If Not @error Then
            If $aPos[4] <> $idLabel1 Then ExitLoop
            If $aPos[0] <> $aPosOld[0] Or $aPos[1] <> $aPosOld[1] Then
                If $aPos[0] > $aPosOld[0] Then $iXDown = -1
                If $aPos[0] < $aPosOld[0] Then $iXDown = 1
                If $aPos[0] = $aPosOld[0] Then $iXDown = 0
                If $aPos[1] > $aPosOld[1] Then $iYDown = -1
                If $aPos[1] < $aPosOld[1] Then $iYDown = 1
                If $aPos[1] = $aPosOld[1] Then $iYDown = 0
                If ( $iXDown <> 0 Or $iYDown <> 0 ) Then
                    If $aPosOld[0] And $aPosOld[1] Then _WinAPI_RedrawWindow ( $hGUI, $tRect )
                    $aPosOld[0] = $aPos[0]
                    $aPosOld[1] = $aPos[1]
                EndIf
            Else
                $iXDown = 0
                $iYDown = 0
            EndIf
            Sleep ( 30 )
        Else
            ExitLoop
        EndIf
    Until Not _IsPressed ( '01' )
    $iXDown = 0
    $iYDown = 0
    _CursorRemove ()
    _WinAPI_RedrawWindow ( $hGUI, $tRect )
EndFunc ;==> _PicDrag ()

Func _PicGeneratePath ( $sDir, $sExt )
    Local $sSuffix, $sTempPath
    Do
        $sTempPath = $sDir & '\' & @YEAR & '-' & @MON & '-' & @MDAY & '-' & @HOUR & @MIN & @SEC & $sSuffix & '.' & $sExt
        $sSuffix += 1
    Until Not FileExists ( $sTempPath )
    Return $sTempPath
EndFunc ;==> _PicGeneratePath ()

Func _PicSaveToCroppedSize ()
    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $idButtonSave, 1 )
    If $sDragFile = '' Then Return MsgBox ( 262144+4096+16, 'Error', 'There is no Photo to Save !', 4 )
    SoundPlay ( $sTempDir & '\fizz17.wav' )
    Local $sOutputpath = _PicGeneratePath ( @DesktopDir, GUICtrlRead ( $idComboFormat ) )
    $sOutputpath = _StringInsertBetweenNameAndExt ( $sOutputpath, '-' & StringLower ( StringStripWS ( GUICtrlRead ( $idComboDesiredSize ), 8 ) ) )
    If $iZoom < 0.1 Then $iZoom = 0.1
    If $iZoom > $iZoomMax Then $iZoom = $iZoomMax
    $iPicX += $iXDown*( $iPicWidth/$j )
    $iPicY += $iYDown*( $iPicHeight/$j )
    If $iPicX >= $iPicWidth - $iViewerWidth*$iZoom Then $iPicX = $iPicWidth - $iViewerWidth*$iZoom
    If $iPicY >= $iPicHeight - $iViewerHeight*$iZoom Then $iPicY = $iPicHeight - $iViewerHeight*$iZoom
    If $iPicX < 0 Then $iPicX = 0
    If $iPicY < 0 Then $iPicY = 0
    Local $sComboRead = GUICtrlRead ( $idComboDesiredSize )
    Local $aComboRead = StringSplit ( $sComboRead, ' x ', 1+2 )
    Local $iNewWidth = $aComboRead[0]
    Local $iNewHeight = $aComboRead[1]
    Local $iFormat = $GDIP_PXF32RGB                     ; 0x00022009 ; 32 bpp; 8 bits for each RGB. No alpha.
    If $iTransFlag = 1 Then $iFormat = $GDIP_PXF32ARGB ; 0x0026200A ; 32 bpp; 8 bits for each RGB and alpha
    Local $hClone = _GDIPlus_BitmapCloneArea ( $hImage1, $iPicX, $iPicY, $iViewerWidth*$iZoom, $iViewerHeight*$iZoom, $iFormat )
    Local $hGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hClone )
    Local $hNewBmp = _GDIPlus_BitmapCreateFromGraphics ( $iNewWidth, $iNewHeight, $hGraphic3 )
    Local $hNewGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hNewBmp )
    _GDIPlus_GraphicsDrawImageRect ( $hNewGraphic3, $hClone, 0, 0, $iNewWidth, $iNewHeight )
    ; save desired format file on desktop.
    _GDIPlus_ImageSaveToFile ( $hNewBmp, $sOutputpath )
;~  Local $aPixelFormat = _GDIPlus_ImageGetPixelFormat ( $hClone )
    _GDIPlus_GraphicsDispose ( $hNewGraphic3 )
    _GDIPlus_BitmapDispose ( $hNewBmp )
    _GDIPlus_GraphicsDispose ( $hGraphic3 )
    _GDIPlus_GraphicsDispose ( $hClone )
    If FileExists ( $sOutputpath ) Then
        _TrayTip ( $sSoftTitle, _FileGetFullNameByFullPath ( $sOutputpath ) & ' was saved on your desktop !', 1 )
    Else
        _TrayTip ( $sSoftTitle, 'Sorry an error occured !', 2 )
    EndIf
EndFunc ;==> _PicSaveToCroppedSize ()

Func _PicSetAsWallpaper ()
    If Not $iAdlib Then _GuiCtrlPicButton_SimulateAction ( $idButtonSetAsWallpaper, 1 )
	SoundPlay ( $sTempDir & '\fizz17.wav' )
    If $sDragFile = '' Then Return MsgBox ( 262144+8192+16, 'Error', 'There is no Photo to Set as Wallpaper !', 4 )
    If GUICtrlRead ( $idComboDesiredSize ) <> @DesktopWidth & ' x ' & @DesktopHeight Then Return MsgBox ( 262144+8192+16, 'Error', 'The Selected size do not correspond to your desktop dimensions !', 4 )
    Local $sBmpFile = _PicGeneratePath ( $sWallpaperDir & '\' & $sRegTitleKey, 'bmp' )
    $sBmpFile = _StringInsertBetweenNameAndExt ( $sBmpFile, '-' & @DesktopWidth & 'x' & @DesktopHeight )
    If $iZoom < 0.1 Then $iZoom = 0.1
    If $iZoom > $iZoomMax Then $iZoom = $iZoomMax
    $iPicX += $iXDown*( $iPicWidth/$j )
    $iPicY += $iYDown*( $iPicHeight/$j )
    If $iPicX >= $iPicWidth - $iViewerWidth*$iZoom Then $iPicX = $iPicWidth - $iViewerWidth*$iZoom
    If $iPicY >= $iPicHeight - $iViewerHeight*$iZoom Then $iPicY = $iPicHeight - $iViewerHeight*$iZoom
    If $iPicX < 0 Then $iPicX = 0
    If $iPicY < 0 Then $iPicY = 0
    Local $iFormat = $GDIP_PXF32RGB                     ; 0x00022009 ; 32 bpp; 8 bits for each RGB. No alpha.
    If $iTransFlag = 1 Then $iFormat = $GDIP_PXF32ARGB ; 0x0026200A ; 32 bpp; 8 bits for each RGB and alpha
    Local $hClone = _GDIPlus_BitmapCloneArea ( $hImage1, $iPicX, $iPicY, $iViewerWidth*$iZoom, $iViewerHeight*$iZoom, $iFormat )
    Local $hGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hClone )
    Local $hNewBmp = _GDIPlus_BitmapCreateFromGraphics ( @DesktopWidth, @DesktopHeight, $hGraphic3 )
    Local $hNewGraphic3 = _GDIPlus_ImageGetGraphicsContext ( $hNewBmp )
    _GDIPlus_GraphicsDrawImageRect ( $hNewGraphic3, $hClone, 0, 0, @DesktopWidth, @DesktopHeight )
    ; save a bmp copy for be able to set pic as desktop wallpaper.
    _GDIPlus_ImageSaveToFile ( $hNewBmp, $sBmpFile )
    WinMinimizeAll ()
    SplashImageOn ( 'Please Wait while Wallpaper is Set !', $sBmpFile, 500, 500*@DesktopHeight/@DesktopWidth )
    Local $SPI_SETDESKWALLPAPER = 20, $SPIF_UPDATEINIFILE = 1, $SPIF_SENDCHANGE = 2
    Local $sRegKeyDesktop= 'HKCU\Control Panel\Desktop'
    RegWrite ( $sRegKeyDesktop, 'TileWallPaper', 'REG_SZ', 0 )
    RegWrite ( $sRegKeyDesktop, 'WallpaperStyle', 'REG_SZ', 0 )
    RegWrite ( $sRegKeyDesktop, 'Wallpaper', 'REG_SZ', $sBmpFile )
    DllCall ( $hUser32DLL, 'int', 'SystemParametersInfo', 'int', $SPI_SETDESKWALLPAPER, 'int', 0, 'str', $sBmpFile, 'int', BitOR ( $SPIF_UPDATEINIFILE, $SPIF_SENDCHANGE ) )
    If Not @error And FileExists ( $sBmpFile ) Then
        _TrayTip ( $sSoftTitle, $sBmpFile & ' was set as desktop wallpaper !', 1 )
    Else
        _TrayTip ( $sSoftTitle, 'Sorry an error occured !', 2 )
    EndIf
    SplashOff ()
    _GDIPlus_GraphicsDispose ( $hNewGraphic3 )
    _GDIPlus_BitmapDispose ( $hNewBmp )
    _GDIPlus_GraphicsDispose ( $hGraphic3 )
    _GDIPlus_GraphicsDispose ( $hClone )
EndFunc ;==> _PicSetAsWallpaper ()

Func _ScriptGetVersion ()
    Local $sFileVersion
    If @Compiled Then
        $sFileVersion = FileGetVersion ( @ScriptFullPath, 'FileVersion' )
    Else
        $sFileVersion = _StringBetween ( FileRead ( @ScriptFullPath ), '#AutoIt3Wrapper_Res_Fileversion=', @CR )
        If Not @error Then
            $sFileVersion = $sFileVersion[0]
        Else
            $sFileVersion = '0.0.0.0'
        EndIf
    EndIf
    Return $sFileVersion
EndFunc ;==> _ScriptGetVersion ()

Func _Singleton ( $sOccurenceName, $iFlag = 0 )
    Local Const $ERROR_ALREADY_EXISTS = 183
    Local Const $SECURITY_DESCRIPTOR_REVISION = 1
    Local $tSecurityAttributes = 0
    If BitAND ( $iFlag, 2 ) Then
        Local $tSecurityDescriptor = DllStructCreate ( 'byte;byte;word;ptr[4]' )
        Local $aRet = DllCall ( 'advapi32.dll', 'bool', 'InitializeSecurityDescriptor', 'struct*', $tSecurityDescriptor, 'dword', $SECURITY_DESCRIPTOR_REVISION )
        If @error Then Return SetError ( @error, @extended, 0 )
        If $aRet[0] Then
            $aRet = DllCall ( 'advapi32.dll', 'bool', 'SetSecurityDescriptorDacl', 'struct*', $tSecurityDescriptor, 'bool', 1, 'ptr', 0, 'bool', 0 )
            If @error Then Return SetError ( @error, @extended, 0 )
            If $aRet[0] Then
                $tSecurityAttributes = DllStructCreate ( $tagSECURITY_ATTRIBUTES )
                DllStructSetData ( $tSecurityAttributes, 1, DllStructGetSize ( $tSecurityAttributes ) )
                DllStructSetData ( $tSecurityAttributes, 2, DllStructGetPtr ( $tSecurityDescriptor ) )
                DllStructSetData ( $tSecurityAttributes, 3, 0)
            EndIf
        EndIf
    EndIf
    Local $handle = DllCall ( 'kernel32.dll', 'handle', 'CreateMutexW', 'struct*', $tSecurityAttributes, 'bool', 1, 'wstr', $sOccurenceName )
    If @error Then Return SetError ( @error, @extended, 0 )
    Local $lastError = DllCall ( 'kernel32.dll', 'dword', 'GetLastError' )
    If @error Then Return SetError ( @error, @extended, 0 )
    If $lastError[0] = $ERROR_ALREADY_EXISTS Then
        If BitAND ( $iFlag, 1 ) Then
            Return SetError ( $lastError[0], $lastError[0], 0 )
        Else
            Exit -1
        EndIf
    EndIf
    Return $handle[0]
EndFunc ;==> _Singleton ()

Func _StringBetween ( $s_String, $s_Start, $s_End, $v_Case = -1 )
    Local $s_case = ''
    If $v_Case = Default Or $v_Case = -1 Then $s_case = '(?i)'
    Local $s_pattern_escape = '(\.|\||\*|\?|\+|\(|\)|\{|\}|\[|\]|\^|\$|\\)'
    $s_Start = StringRegExpReplace ( $s_Start, $s_pattern_escape, '\\$1' )
    $s_End = StringRegExpReplace ( $s_End, $s_pattern_escape, '\\$1' )
    If $s_Start = '' Then $s_Start = '\A'
    If $s_End = '' Then $s_End = '\z'
    Local $a_ret = StringRegExp ( $s_String, '(?s)' & $s_case & $s_Start & '(.*?)' & $s_End, 3 )
    If @error Then Return SetError ( 1, 0, 0 )
    Return $a_ret
EndFunc ;==> _StringBetween ()

Func _StringInsertBetweenNameAndExt ( $sFullPath, $sString )
    Local $aSplitFileName = StringSplit ( $sFullPath, '.' ), $sInsertedName=''
    If Not @error Then
        Local $iUBound = UBound ( $aSplitFileName ) -1
        For $i = 1 To $iUBound -1
            $sInsertedName = $sInsertedName & $aSplitFileName[$i]
        Next
        Return $sInsertedName & $sString & '.' & $aSplitFileName[$iUBound]
    Else
        Return $sFullPath
    EndIf
EndFunc ;==> _StringInsertBetweenNameAndExt ( )

Func _TrayMenuSet ()
    TraySetIcon ( 'C:\Scissors.ico' )
    TraySetClick ( 16 )
    TraySetState ( 4 )
    TraySetToolTip ( $sSoftTitle )
EndFunc ;==> _TrayMenuSet ()

Func _TrayTip ( $sTitle, $sTexte= '...', $iIco=0, $iDuration=4000 )
    TrayTip ( $sTitle, $sTexte, 10, $iIco )
    AdlibRegister ( '_TrayTipClose', $iDuration )
EndFunc ;==> _TrayTip ()

Func _TrayTipClose ()
    TrayTip ( '', '', 1 )
    AdlibUnRegister ( '_TrayTipClose' )
EndFunc ;==> _TrayTipClose ()

Func _WM_ACTIVATE ( $hWnd, $iMsg, $wParam, $lParam )
    _WinAPI_RedrawWindow ( $hGUI, $tRect )
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_ACTIVATE ()

Func _WM_COMMAND ( $hWnd, $iMsg, $wParam, $lParam )
    Switch $hWnd
        Case $hGui
            Local $iIdFrom = BitAND ( $wParam, 0xFFFF ), $sComboRead, $aComboRead
            Switch $iIdFrom
                Case $idComboDesiredSize
                    Local $nNotifyCode = BitShift ( $wParam, 0x10 )
                    Switch $nNotifyCode
                        Case 1 ; $CBN_SELCHANGE
                            $sComboRead = GUICtrlRead ( $idComboDesiredSize )
                            $aComboRead = StringSplit ( $sComboRead, ' x ', 1+2 )
                            If Not @error And $iAdlib = 0 Then
                                WinMove ( $hWnd, '', Default, Default, $iGuiWidth+220 + ( ( $iViewerWidthOld - $iViewerWidth )*( $iViewerWidthOld <> $iViewerWidth ) ), Int ( $iGuiWidth * ( $aComboRead[1] / $aComboRead[0] ) ) )
                                Local $aWinClientSize = WinGetClientSize ( $hWnd )
                                $iViewerWidth = $aWinClientSize[0]-220
                                $iViewerHeight = $aWinClientSize[1]
                                If $iPicWidth/$iPicHeight <= $iViewerWidth/$iViewerHeight Then
                                    If $iPicWidth >= $iPicHeight Then
                                        $iZoomMax = $iPicWidth / $iViewerWidth
                                    ElseIf $iPicHeight > $iPicWidth Then
                                        $iZoomMax = $iPicHeight / $iViewerHeight
                                    EndIf
                                ElseIf $iPicWidth/$iPicHeight > $iViewerWidth/$iViewerHeight Then
                                    If $iPicWidth >= $iPicHeight Then
                                        $iZoomMax = $iPicHeight / $iViewerHeight
                                    ElseIf $iPicHeight > $iPicWidth Then
                                        $iZoomMax = $iPicWidth / $iViewerWidth
                                    EndIf
                                EndIf
                                If $hGraphic1 Then
                                    _GDIPlus_GraphicsDispose ( $hGfxBuffer1 )
                                    _GDIPlus_BitmapDispose ( $hBmpBuffer1 )
                                    _GDIPlus_GraphicsDispose ( $hGfxBuffer2 )
                                    _GDIPlus_BitmapDispose ( $hBmpBuffer2 )
                                    _GDIPlus_GraphicsDispose ( $hGraphic2 )
                                    _GDIPlus_GraphicsDispose ( $hGraphic1 )
                                EndIf
                                $hGraphic2 = _GDIPlus_GraphicsCreateFromHWND ( $hLabel6 )
                                $hGraphic1 = _GDIPlus_GraphicsCreateFromHWND ( $hLabel1 )
                                DllCall ( $ghGDIPDll, 'uint', 'GdipSetInterpolationMode', 'handle', $hGraphic1, 'int', 5 )
                                $hBmpBuffer1 = _GDIPlus_BitmapCreateFromGraphics ( $iViewerWidth, $iViewerHeight, $hGraphic1 )
                                $hGfxBuffer1 = _GDIPlus_ImageGetGraphicsContext ( $hBmpBuffer1 )
                                _GDIPlus_GraphicsSetSmoothingMode ( $hGfxBuffer1, 2 )
                                $hBmpBuffer2 = _GDIPlus_BitmapCreateFromGraphics ( 200, 200, $hGraphic2 )
                                $hGfxBuffer2 = _GDIPlus_ImageGetGraphicsContext ( $hBmpBuffer2 )
                            EndIf
                            RegWrite ( $sRegKeySettings, 'CroppedSize', 'REG_SZ', $sComboRead )
                    EndSwitch
                Case $idComboFormat
                    Local $nNotifyCode = BitShift ( $wParam, 0x10 )
                    Switch $nNotifyCode
                        Case 1 ; $CBN_SELCHANGE
                            RegWrite ( $sRegKeySettings, 'Formats', 'REG_SZ', GUICtrlRead ( $idComboFormat ) )
                    EndSwitch
            EndSwitch
    EndSwitch
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_COMMAND ()

Func _WM_LBUTTONDOWN ( $hWnd, $iMsg, $wParam, $lParam )
    Switch $hWnd
        Case $hGUI
            Local $aCursorInfos = GUIGetCursorInfo ( $hWnd )
            If Not @error And $aCursorInfos[4] <> $idLabel1 Then _SendMessage ( $hWnd, 0x00A1, 2, $lParam ) ; $WM_NCLBUTTONDOWN, $HTCAPTION
    EndSwitch
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_LBUTTONDOWN ()

Func _WM_MOUSEWHEEL ( $hWnd, $iMsg, $wParam, $lParam )
    If Not $sDragFile Then Return
    Local $aCursorInfos = GUIGetCursorInfo ( $hGui )
    If Not @error Then
        If $aCursorInfos[4] <> $idLabel1 Then Return
        Local $j = 0.01
        $iWheel = 1
        If _IsPressed ( '10' ) Then $j = 0.03 ; Left Shift key.
        If BitShift ( $wParam, 16 ) > 0 Then
            $iZoom += $j
        Else
            $iZoom -= $j
        EndIf
        If $iZoom < 0.1 Then $iZoom = 0.1
        If $iZoom > $iZoomMax Then $iZoom = $iZoomMax
        If $iZoom Then ControlSetText ( $hGui, '', $idEditZoom, StringFormat ( '%.2f',1/$iZoom ) )
        _WinAPI_RedrawWindow ( $hGUI, $tRect )
    EndIf
    $iXDown = 0
    $iYDown = 0
    $iWheel = 0
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_MOUSEWHEEL ()

Func _WM_MOVE ( $hWnd, $iMsg, $wParam, $lParam )
    Switch $hWnd
        Case $hGUI
            If Not _IsMinimized ( $hWnd ) Then
                Local $aWinPos = WinGetPos ( $hWnd )
                If Not @error Then
                    RegWrite ( $sRegKeySettings, 'X', 'REG_SZ', $aWinPos[0] )
                    RegWrite ( $sRegKeySettings, 'Y', 'REG_SZ', $aWinPos[1] )
                EndIf
            EndIf
    EndSwitch
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_MOVE ()

Func _WM_PAINT ( $hWnd, $iMsg, $wParam, $lParam )
    Local $aWinClientSize = WinGetClientSize ( $hGui )
    $iViewerWidth = $aWinClientSize[0]-220
    $iViewerHeight = $aWinClientSize[1]
    If $iZoom >= 1 Then
        $j = 50
    Else
        $j = 100
    EndIf
    If _IsPressed ( '11' ) Then ; 11 Left Ctrl key, little speed for more precision.
        $j *= 2
    ElseIf _IsPressed ( '10' ) Then ; 10 Left SHIFT key, fast speed for high dimension or high zoom.
        $j /= 2
    EndIf
    _WinAPI_RedrawWindow ( $hGUI, 0, 0, $RDW_UPDATENOW )
    If $hGraphic1 <> '' Then
        If $iZoom < 0.1 Then $iZoom = 0.1 ; x10
        If $iZoom > $iZoomMax Then $iZoom = $iZoomMax
        $iPicX += $iXDown*( $iPicWidth/$j )
        $iPicY += $iYDown*( $iPicHeight/$j )
        If $iPicX >= $iPicWidth - $iViewerWidth*$iZoom Then $iPicX = $iPicWidth - $iViewerWidth*$iZoom
        If $iPicY >= $iPicHeight - $iViewerHeight*$iZoom Then $iPicY = $iPicHeight - $iViewerHeight*$iZoom
        If $iPicX < 0 Then $iPicX = 0
        If $iPicY < 0 Then $iPicY = 0
        If $iWheel = 0 Then
            Local $iX = $iPicX * ( 200 / $iPicWidth )
            Local $iY = $iPicY * ( 200 / $iPicWidth )
            Local $iWidth =  ( $iViewerWidth*$iZoom * ( 200 / $iPicWidth ) )
            Do
                $iWidth -=0.2
            Until $iX + $iWidth < 200
            Local $iHeight = ( $iViewerHeight*$iZoom * ( 200 / $iPicWidth ) )
            Do
                $iHeight -=0.2
            Until $iY + $iHeight < 200 * $iPicHeight/$iPicWidth  ;-1
            If $iTransFlag = 1 Then ; if pic with transparency then clear graphics
                _GDIPlus_GraphicsClear ( $hGfxBuffer1, 0xFFFFFFFF ) ; $GDIP_WHITE
                _GDIPlus_GraphicsClear ( $hGfxBuffer2, 0xFFFFFFFF )
            EndIf
            ; draw viewer
            _GDIPlus_GraphicsDrawImageRectRect ( $hGfxBuffer1, $hImage1, $iPicX, $iPicY, $iViewerWidth*$iZoom, $iViewerHeight*$iZoom, 0, 0, $iViewerWidth, $iViewerHeight )
            _GDIPlus_GraphicsDrawImage ( $hGraphic1, $hBmpBuffer1, 0, 0 )
            ; draw Thumb
            _GDIPlus_GraphicsDrawImageRectRect ( $hGfxBuffer2, $hImage1, 0, 0, $iPicWidth, $iPicHeight, 0, 0, 200, 200 * $iPicHeight/$iPicWidth )
            ; draw red rectangle
            _GDIPlus_GraphicsDrawRect ( $hGfxBuffer2, $iX, $iY, $iWidth, $iHeight, $hPen )
            _GDIPlus_GraphicsDrawImage ( $hGraphic2, $hBmpBuffer2, 0, 0 )
            If $iZoom Then ControlSetText ( $hGui, '', $idEditZoom, StringFormat ( '%.2f',1/$iZoom ) )
        EndIf
    EndIf
    _WinAPI_RedrawWindow ( $hGUI, 0, 0, $RDW_VALIDATE )
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_PAINT ()

Func _WM_SYSCOMMAND ( $hWnd, $iMsg, $wParam, $lParam )
    Local Const $SC_MINIMIZE = 0xF020
    Local Const $SC_CLOSE = 0xF060
    Switch $hWnd
        Case $hGUI
            Switch $wParam
                Case $SC_CLOSE
                    _Exit ()
                Case $SC_MINIMIZE
            EndSwitch
    EndSwitch
    Return 'GUI_RUNDEFMSG'
EndFunc ;==> _WM_SYSCOMMAND ()

Func Fizz17Wav ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "RuBQlfQnLxqbGvFPWvnNtXiiEkXWG9RdzG4o7LxhKFJ82NAmOr0n62Zo0OT/5JNh19tS2gPlyvx2L/26etXLOtauDcCFg0+UGSQd8I51VEKgIq8UzHlG+XXwcczanR3V6gg1iseKOOsee/EsDOmXEYLUFw37weR9+Yo7mV6yvWd09c4JevSRk+R33FdwGuSJiTAWEX1c3FZYP7uxk4sboilt4EwIwIMA0u8TZTX8vkY+aO9heE5oT4BpppRdPYOPNIzWbKsOaznXBCPNujgfUne0JHYnxhvi04ZiBpu47QCPDl9lSVZEW323ANWYPaZBXxYyvUtfi2+31e9Am8fslIzJAAjC6mXyyOqqCcEmL7Ugwi0SuIOXV13R/1CsH3pry0PBlnt84ys6io6hZJxm2Ck/VWpQd1Jn1Q+74a05g0f5+f/wH+iv/6IRKXiec2p3d/i7YnFcNasG3zI1l/gmM7FTgsC0NQIZ8Ye/OHtV8F6JEhZhE3BQ7PEGrWx4XpFFHh72e+9vjCYWmKXe04R96Ok2gDW5m4KmyVnI9tQegSrrgeUFUm5DXuFynCoOA485DvIPEaKVVTI5O6aqHI86ovAZ/ijCkj8J8wCjESdnvX5C38EJEpFyFAPLX9ISQ0nI1kmdLqS48aUJ4mC4s4pjfBG6qzcxDQzP+XGSTJWxzRhVOqN4AYNyDqe0ubfL0O0Dz29D24mMz8blXH1GeCswGYRIR7jvMbWdr3boQkgS+sq3OQ1u0tIu8qY650g0d+d2ZyLl6nbASDO5lklSEIPmCbqPtINRqUhxZVk0M0Gt0Zqz9OSTRa+bvfurA4FAfXk3595+Vo+SzgfcsF51MAdqu3ax8A7sRUdSTylbSYii3VG2E/avY2AS0eVr1/fAE6nAyBuSJn2b+sF6dl3O0Fym8b2+rTQVwqMtLPA/roin6ljRU+kBISB0yDEpskWr6GSSc9owTYD6tAr7Pxr947kNbrQ1t7fS5BhFJNoolCuui6nFXPSdlr3DqAMD2C52oBa6lQ4T5DTXyULws+AVM61f3N5nVk0+o0QaUTlUx93C0bLO9TlFwSloIbfMqc5DHrIVbHLgtMxFktXa3LknBwzpqkwxJR2T//yM4AlfJ5lSVRw1PLgMRtVm3fAFDBKC9ACJGX57pzL4msY1Zx0ynblqWNtf0h7VHjx71LTlNdEKrWS1+pbrmN/BPxk+na68wqszGH2Y90yuScCfg+JNce6vatJXkpzLSmjXrMKnTlwGuVS+W7BUVTZAJKr0PjR+XYlaUOR1RdBmTodc+z00oysaqqj+nwGaiOcqt3LNdJM4NQONQCofopl5vTTgGZ78Bg2EauSGLezA1L3Um2+NokJVQIt19irw0/fDuQWFP8LE/ZWD/2pInK4Z4rGxrtnzvPmKzxX4KsNiYKdGC9OpPQQzZMXVZl1iclOwVyPvfAPxR6Gn9O2AV9qwYTpTmG5rZIVScTWpB3PSuRZloTnC6Cvoa+fr0oE8LFYPmgYrL/CvLSshTwEdLHmQoxYEu+IXQheexKhHbI94LgEoZPq+mjfBEsYSBscwNSP0ULz7SfBjXT/q61jWSwSu6J54RbMBepGZibyZuuKeI5jdxGSXFw3Adg9jIH47wFbSbucaWfz5nQz6876lByqMDMgP1RM+TrmJMWZR6QKL+gSlyQCMSs4h5qxLjnu/t8pJe6O8XrB3FSlpn5qSETCpufOy7jYQcvBph2grvuRAGRTSkJkADJ+3rmNsUenmAL2uP78EkkV27wK22uonmCfLzAl1NDap4NbOLuxt1Lja1FF+DB3IN72E+2jiCis4bq3/af4bAterNeR09OkFfIOXHjPIQU9BZ3A32AL9VpnvkCA41OGBJNb1zMFQJHhhQu/X82ZXnXRHjlt146bCESWxHHGLHf6yccjDKMS5HSo7CL9n44b4XELWVvo0c5GfsQnRBvya5lZPPTnhxwsnfjklCYVgx2EqupS0WEXyvvuz93+8DJYSHjbPq8yzuDlqXqmIDHFi6Se+Yxs/yP1CUlAZoK0dx2835hJWMZX0mOVdv+nMq5V1y5bz1Iq7ib7AtA3CmjiDcD0doUl9mrXj8PGHaFiVSHZ+qqc2CXkn2oG18psMAEpM0QW8WPLAoz364cTtqftD+ZAjHy72fe9jVIjbOQ/UVzJYvjeFTiOEcm/C9ZSgKAL4Jdr/08m/oTOvmTu4/Nt4FgYA0Q087hFdbZDWleUcdBd+liFf/+Y1Hld1oBj/AF/RqOicGNP1zAjx8/EdA1BtVRiWAFliOIg4uw+hdsX5afgWeR/UrRsrDQl6MjyVwb+I4L3tpQCdb+gVlrpMcWSiN+vxBFkW8C5rPG1Di1aPNrS1+Z15RPLm+jdnGHp63D+jV5+/tndkaz4VuVO58EP6qMRbnh4VQqFTmKHo/3uSHTs/XyeR7CjICYUsz/L6id6S6a6Zoiadg0GbUPnttWbZXOBJ8SBMFZ7/bUN+lZ7NtIEw6dw2/0pRnhb0z86ytSpxZ4ZcimP4vdEAXiE9HhUL7knh3fh0jQM+f2QWJxXi/5lLcx1Nh0hOuz2F7plLTEsFW04gYDx8zZd9gC2zHwAGsJ274fxD5yMdkxIGsEQkNMlNMzEz+v/O9UIgTAYNzqfzXdhDyLX8jHPgWp+1lXVNcDvkiphw0YI2FDvi9AhbOQUMEuKvkxK/o5HBd3MPu1823jb9BcQ/uJq9YZmtuv/H/R9sXdNtLDIEsQnNxbAYcwmPEMAw40G82zAErVqOMHgNZrgQHL9t/vQ5qwYTfJRiVDBCiUDlz3n4w3U57DFk14xsa2NXOYDY+O0ExY8QLXk2GS/ma8HGk0oj4F4osuaweJLfNjiYsaLdNWpkLglxPLYbDJhmZ14amzOL5EbUBDD5PG9WTOTyy0pYG3QY0yYvlQoRLeupNiFLeWFQ9tloF9jK9V7rs1yjX2pNR0dQHhEZiXr2hsL07dETV0qBGC4NBe/nzQ9OfTe9UveFSMwiOSxxw8pJmEcvOTV4Z1+qM4hYSgW1tzUHGGRFuh9Yl4SHDGrmPIrGho7rkPvOq+BXE4WgItQI5xvqwnHCq+osIJkeTJ6ujw8f81aRt4sDXbX9qcBeno/Hk8c/4uyjIWZhLbGn7qXlEY3lhR4Hb8pvl9qzm1/H37OpFFpyMQsh6ANH9xgg5r82MEht3MrIMlPSUXFR4yFReONamBa19rioerNXvO6eJskEmHV7UU4N1T83A5x29hFAzqdjcwXGbvNBb5LsEW8kT6Fq0wM8Z7P44FXBPLQlQu9kDR4yiw6KZYNJscszJAAa4Hm94flmrNIAgnx3qobVzSNuKad+zlrMVPxWl8KKdyZClhyh/FPIL6tRbDMyAbGVR+fhxFKTgRhKW4EG7UH0luAA9wcVEFoqeKDeJtm7a7qPU6RzPoutafEKLugs526e8wUwrH2TOoQFv/hwDsxEXG4r6K/qZLnuDbOFJT0z+zDki5kfzVyyFnbTqgW5P3C0Ttzmj116SIjyZuPayfaan450ztS5lrEQ/rknj9MuZlFhDZ6tb1STAbjAqCJ1ixBeGTREigzEWmld67sCUxWMTKuPeTSieCOOGDq7k8RjDJV6vcOSSaXv3uNcRZ7eODC6s1yEen3vFsThcGpBLR1j8XWqKjHNFMUeeLsWhz7zZPc2Aams/Pd1/d39HG185NbIbjlcqkSKdsy0HDErQzW+3jBz00nNfCaJxRYc2SFefLJS6BendYLN4pFFi4BCjxHR+SWTrKZtSB/BjRHCxtOUkT/CH/7+t0Lu2vHKK+ZEUAVAFcP9NIToTxThMej6O8+4nYhcwf/HiHlE1fr4YZZE8ogMppUHBmj39kqwIb8HNTcZUONCiYoeG1K76ksrA6RG33uylz+olKGuyK4zoBmB1W00CmPqJLfaUiwc+F657xazlRbvKzHnUw46DZJuWFdjUK434eqG3n/nYG70kgLxEgAu+AVCdAtBsgV4DxqCnzSS2R6v5R/f"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "lIyP0efkaeU5o12r97Wj7CZylPkNfkGkMD9c1LYHXlUNqUHjEJZ+6UMvVgWo1WF5K21/b8psRKnyC9lThEZ4L3C7jjS4RdQbUN7hOqCu9xUX3Vf/65/U7/D5+LsDQHPl0RLnFGugEmFtiICVUikgqpyzlgHhTX3gBBkDtTruWBAtFzlvmrcbah2kByQceYI8WZQG9iG3c2l560LTgrHEFxsQ9zZAgnQc+mAWyU1lvh+8+p6+Z3O7+BEIwkit0cjajHU0a+XArP4iZVvJbJSs2a0mCi8pcmaHbcXiXgQjiHN6K8AXMdO+eUX6guB0wqwt3t7fWHZRNaiI4RiKdi1PjX2i9ak4DkHZx+EOC6fQhsq6P6YMGqFNXFHOs9YI4/AGo7kkaSiwk5PigquEezAaGAPcECmRGb5blfko5vUGjqJzcSrEia5wjfhT14Ykd927ZJKNuC4/wnogKOYut5k5FfRyOv9pyQ2JOEeTG1S436j+8ByzGBlU6UxmTY8XIWjSkiATdwRY57Yb/KVj+xCEPYw1TCKiC/03zl+AJ0ABlhae8f/OQb87tZFPn6gy1Crk8u2GjNt6a2O/cnl1/CO6ZVHtpVwNknbc8O87T9Uwc6oey9pvdUzkCVllZGBKVLAAq+SDqpQC0rkfry4VFbtn8I2BPcakIG45Wyg4t78fJXF49inBrf1wd8S4AXRkEMIbtoausEaCM5C5i5JburNOLE8KFtxSVDIqJ2/MdMiuKSRPUxGGzBnetjXStfSISvHQvstJoTLLvxRf1SgCkpiyOftJXa5+w+o3BiQuCus5T/UAM210k31CWqhms4oaLP2qjDOfhLMpV8EXlkSl35QV8uy4+5PsXQr9qV4tAX7CYTJkFhXPSHM8JJxwP/OvL96anZoTfO1m3gI/6TGFMSernnDRDeeJEnY2ozTL/EmCi/j7oC6m+MRvHhi4HXc1VmEW7u3nJDBAwF1TF4aR/YOtuzqHep2bRtIVwmFEf4kk15V3JXwUwJf1Yz59EiStW8xoKvx0jRTtJEaVgefhdIoHd/O+QpR8AA/oS4XpHkrgESaLLPEiNl/cLLV4fFl/IHooMFBphx0ABu9IJxc1gdVhgbiEQw9P/TskgX4A42bP3yxm1cp3tlL5H9U/DpSp1wfGiZdnukCSAxJS63XRxyHoMnm7toU9R0+hXECtlZo+bPU0jGtCN34gyaeVlSe9DQpYiY4WRofmGhiP2Ai0Eg3sZFZCJ/bSEjwNtRpqoep4+o3X9W9sG11fSsTvtK2NZ7GKXmCGvhYsz+qf/2m6FvcmQPQ8NqPtqqDblc9ohq4Ezzscyxvdea0i2Ew6TtAcbk5lendzZVos+PNdY4MnLPRLuLZg56QKYg8WC7mzY1Ee3g+I8jJXt9OS8XidDB1+nFGSEf4xpouoBy8qGMvLehfqTK5MbvAlOJ41DG5l22QDFVst3rgI9bHAh+twi5tp5zelH7KZQvvhu1nmIZS0z0DsHCe2jDbYvJy/7uls2LyQue+w4jydxv+8fzb8oz40vmKEumc4rbTD25MkBL8S3fvEOZyVxPkuOf7Ph4E5f0usJgDHuKwzRg/uoMP2DGhYefwYWxBmqOucIZcm5XtkY1pNNDevCGxKk/yFCVUq98w6U+UA2qvTOmukIq9dNaXtUcjtcNB7/icaDc5yvYasS3E5B9styT0Vgu1p/SBI1baetqatIqY4FQzWgcp8O8WuTu5XEXHRMaLkRDr13ty8pekWTuVNUurwGCFIJe5SAPsCHd4E2UmswExkvFRjHcDx+xF+9RuoHveLElivam+FS9rwzAodq9nsh6kGR9au6MBhZneIokmiX9oJZCURun66f+Vxdx0GtRHxChF1wqT8axtKid+kktPoK90XN0jElKOgjC/iqbMQaEoCQxMcjVlHlE64ImnvAMuz0uuXpBkEpku2T0oQIO8H9DSYf7rZdx1cC0Vr8CIxfPsfvUmL1OYA+nOhqt40oGPq1/Ae0m7nKVQCLJ+yhyD1mrfej7TIe+9OmdO36ePx2pjEEMHnsH74H+A6sJ1kRLPVuXZHsWhnt1aqGKc+RP6VUKCmJJtEbdpM9SAYXX1Uh98h+8O/Oy6t/59YwmqC4tmauqyxgq7S45nrPjdgnqWFTBGhO2I4KVFmh0Btlj6j75qH4yDfKpmo3b/8OREc8o9VoL9NsIPOUqB88ZFAdw/y2MsA2UYZ3i8ZiwLfqPwe8C11rE+CCpJe1abN2Gpy/Lqun1acbqfmlQ3sn/SynhzrCc727YU2n5G0T2mjHGEPXOa+DGj2pTENN4AXGDywl1PnDf09TyxA8TiQCn5cDZqBuhyt+YCHhTZ+Sax19pTgXQE8lXokWTY8ufW9v9vpFWkLX/fD2R+mXSrbgztbhoEnEiNYtaUjseTKWM4VS5EF88vfcxsSPgMekwjtuLxLhUUOwAn8xshGGOkFaf0fkCLxxbAx5m9HyFF6P05wcasdesT5trfzECp6IfjE2hDuHjSnXnynuMbQ1Cf3BadTZbovF3AY9lGfKFCk4D6e3aJTfd3SJ5e53jyFeF5UsraRSK2q/aP7mFExsGn51PPbi5riWk7jhJBRtWT6cmZDyGjFYSCv2W9Ey7eGicxB6RMLXNu9z7ahxrml5yti0QaNNLBBtEDbRQNu58p9Wle3leRKZMt5QKyZMK5E6tBQtSOY5N38aB+M+rEh1hRuS3tUKItB4jDQD76xewV2vdG+XPNia4B5nsoJasEAX7/Tj57tBoPhaMw4YgXkxWr4YyahrmlW3tVDurAzdhrd68NbjZLMI5oh10EItxMqIBfAa9VcxGVvY2Y80uYDFv8PIR/Rfh7Ts3me8NVN+RhwxjeeVccaKCDDO5ohkbT3Efd7kOI2QoV4Mt7VLNn1JPjFcCirl+kXF48uj9wUIs5itVIJvu0idDYNNguCj9kgmS33lv0nw6yIO4JEgos6u7cUn1T8+YK0dT7GTIGrK5yKhKFfifjr6EzrgoKfzn3IxQ9zJbZLnfE+JB24V/l4InxMarfKcREtRVlBRx6PMgfPylx3vFAqImSzEImdHomTltOJkCARRzTl+YeCgaRhotphlfSMNp8aw1rHQiQbN5Lzi6a9+pEGcqMH3NlXxLeH9kBT8zt06xLfb/Z7A6GTmg2s8AUQWjT9diWbuPfkT8tvWsG6ku5ACeHg0SQm4umyU3BhRGO4n0goUfJ9WnK6trp5hpLkQ62yhZRQhLsy/58uVjOJqXEydyXzEUCGFKW0AhQ9EJfZZLkvATHeaXztxZ1Q41TBb5vE94JrFizCOcndJRoCFHKAL8eMOKcVnL6Ktwf2kDrb03AZn3bVOi+DvJrvJYEN4PnBUpF0IBsPaWwfb+puO6AALB7WTLleDOVFZ2Z1eJdcJBa0uVKNgS6zPFAdbT6mCAYt4OOkuchGXSsGkZxWBe3jR8RfB53FbCDJ+wgE3ifIWVpvP7BHNDKZ8uWxQllpbUhZmUCbmytsAG7rOjJlDrcrX074nUWlNuBrRdD9t1MaySaXcXu7hjbDx9UzQkewbUu1sSW+gXBaPsfPv9qcWK99qHwwmw7VDu8JV8Omz1GOLraqHEkpyeZ3UcOjTkx+3siPDfH/dkiMLyudnYnxaLwiPU85fIY18yciuuXyeNnWknWd2RHyZRSurZLu8OZ0p8BaA/ygIPwDzrwwiyOl+lAISFEhIVHVGlLXwc60PHXD9E4gaZ+SrsVW5E7N7NsfkgYp303VG2UN/GT3ydUBktc6ovO1nFKztvYFiloipXNYq0S9EjU2RfFP9dLQ7kMHG/ZUaBCUxtCn0T4Zkj817EuRMD4Kk3z1S4vTS1W1yVH2mza3ry7Bz0kfikBGQBTwvfP2XDqU/lVq/nG9MVGgC4KzejWsL+QmRuAFU8wHd+FcZ+471tm/5barh9NrfslqotEQpkQfIM8LmqC2JkRnyOG//6cJVZCzGRlNOY4UlmEowojRHL5Z/2hLVNBayk0+OrPi/Rmi"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "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"
    $sFileBin &= "7Q+MgKBfhKpkBbZQ9IwZQSynQQDhLoW0mPnZGoAmjtN7ZjNZylqkkGw7MeruIQzCZwVhxhWDb8iNyxX4QouA6qBQcAtzPaifbLq/eubdLP6u/akrY+jF0QaZssgRjaKSoIS4uzaYW7RJFX5HfzL2CvjMGQ9e/LqR77luPxN9xtQrsg9M9qt0xoybNWXGqgNv1JkNuhjhIon7TxScpimXnHcYED6zKx6oBjI0vWhSLqTnQEi7Rs4UdhpK64rG4uh0SoZwPazsf6Y2deLtwZh54Kx498qNe58ZJxKtWT4kd80RUK+Bwc7dLw84x7o6dcmpwjL56vBGilUFQY95xJELdZ6xJG+ixbJX+1wq41svRZprjCrng+hrNH/9lB2ZCrlv2JCg3Tm8k87Matcj+kUy3MR3XVqwVP1gPSovp1nrlJuXzQr0SYdT1mbCO/VGpdWCguKdpA4c+kmu+UwCYk+7WbQmqh0syl5vqJ0Old3JHzU4qmvImifWYEd3jAyqbwrmxTqW2b57qSOcSW7Imc9TjWfKWNP93yiPES8sR+3Xq6dw/9uF19PP2yekEXOpsQqnP4sXRcT5dsjVYl/BvCBPPEfChF98WEBssQMdwhjdKTm8oO7JBsFaXqb/XQs0hCbMw6NfY6xdSc2F8PutYNlE3WkZIBg4DULT2OOUwaDhXlcdvSXAmAqU67DmINDFm8+wx1r/6SU7tq2NKirLG8JnjuxvtHva+9Qudkrqo6m8dsDDHbdO/EotHS313EXCqwnSMbeJvm4SLwP4AW8Vs78cC/LNJrmhrrj826tAWK5MfvX6wlaAy5CcNEhk/rA9yLjOwMqPTR3d/++39TnMdKXWu7lBpayeRmVFr/DVPy2WSip5rKCK4MHMuRTbtIn8VBFSQ9wApu7CnmpPwBuSwyW4ZyiQpHU8LLFYbsYdHgZjhopCveDzHp/3cpHKD2mUvOxZY+zWQMv533Ys7tVPgBr6uCVk3otLRrEC+NhrdLaVd+CrGhD6zAIa8wGdyqq2NIvbp8S9cCxLNL0MI7bL2K+FfzQVPICMq8BmYrWXHHYYwhGNXykgYV4dryJxh6XmAHMlbXvGvuVoa9XCQZ5w59lKUsI5bKZg+BXCIDWus9AqknRDREBRyUOJOHYkB8PDvg2wbwKsCrCvOVa/HsoHjBrQ24Dl/Sr8sgFWW+hU3YEl9DiwEnArG4Czsb+4f2C/SHj8Q0KyXFM+st5EgWr9ABcRVnwlh8d0BM7pQu5pVS6oOH5CXC2pgx0w4qnd/31grX5I+GaKhg0R4oYlzyIuonJVj0SJCzYAwQhV/jlYZN6ThTVFmDbg9Q4D1mTNnmrncxQFGapHfH5OYjYqsQNCfvX8AmnOjiCJj97T5s6nEEDH4ADCVK6g01FrNkZlI1lsbGiuEWa5DOPPZU5XWMvhaYhx/IWIHXnWG49rTYl0ifDbniR3S8O/QaL9SZRdWTY/h1E5u7zhyfB6IxtM1DawiE7uXZFeRWUJlnltpXMAClSW3mzZqBi6mDOeresauWkTBVQZE1KjNocJMCV/94+4ylBUihebGmzejpISg/2U08ALnL4CqIVQESLU+IojbecIwKec+WpIkGEXVaCDzd7Hf8yVqFGXPYhV2lOn/V1rKqRcvPNrzdNMecrcqZBNlr+QSjtHU3eNjW6+1qaldYvKzrtGuAGso14uWzZ+U7nSy/ZtO+j2ADDBLU3dPwm+qlXRDW4bCm+SEe4JOV6nbVASoEszpQD3svefOr2a9dVy6ZetX5qbuk3pPC5YCwDgWCrSAU9/Zr+7Lz189dQm/meiL8zDCICqY5V70L2tYAtX3hIxnfZnn6SMAHbZWEY5X9g1tH6Rilw+UT8giqVbyDMgcHM3AA=="
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    $sFileBin = Binary ( _LZMADec ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Fizz17Wav ()

Func Cursor4Arrows ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = 'XQAAAAS+EAAAiwAAYAZ/4g/xFaFh7UtP79fe5q7p/CWlP1pUIaquoC7d2W0n9bpJBHJdn0+IVxgTR1mnZdsAY4fflarWH79V/odDYbmaeiGs2A75IOX9zd8lbxnMHeXRHYZJiOVJ/tQK5fZxr6yr4Tk+6K3cOnc6XzOQMWXgrNB4spsjhh+j5Xa1yljg6gf0jCcn0zGPO7izQ9CO/vLqfPeGnM8keTTFPxty7I6NNVLFgDqNxRVmVVNDVdm4BxvaJw3unim8TONgZ07Om4rC9FisJvNpAmNNi8hr/376iOuNXEw+WqlKcMH0xCwmDbzROof9jDUf+JSRCCwAcxnRZ8AP7f/GGugaCO6/YhUpEYxsHGmrH9oqaMf7YuIGETGunmF5eyARsw+GEPd2dr6eAbgGXPolDBKNlb4TiE/IGFmJAHf+UOWamfURvXFUVXtuJRBrDVphU9GbxQ8z4M0zOMlWymz61+809O7DabkkQ+zmeuh8rhZtn6ykt6JFzgFYb5YFVWPf8EfOKfK2yrPsDR0qocVTXKXLa11QZloQFKJFRvvjNW+V7xTGuBtVQfs8CQarpVCdcWHrdsIgHAs2TXQqaT66kLi3qtaMaes='
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    $sFileBin = Binary ( _LZMADec ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Cursor4Arrows ()

Func CursorZoom ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = 'XQAAAAS+EAAAiwAAYAZ/4g/xFaFinDsRRDv/qj7blH1iV3p77Kpzqd6srfGo2oJ3G6pl4hxlkE7perti9stcV8C7iz2aWnxpF8Amr7gjMmwBNQT/GxNtZLQuplx1LEHtpWJ8cApwaQVTbhvlqjBe5NH32fvI8pdnqCzwCUDN3qiNPnP4rJOhoyvQLUU5PkrcIr0R8LLsg6gw2HvZ3h1lq7HoPffhoyfGgKMpReI53i+lc/CLABMeUDI/6rNPSucubB6PEj+P0DRgxabjnYwSDPrXhRPfA4TYea0zK3kP5XGGy6upwXSx+3SOhMI9l+ZRD7ayP8K9jPJT67HBIwJymLu9P53J6Ml/MLVV5H+9PqYe8c7otehWUyVOCDbGUI0ENRu5MJ+oWoKGfP3tyKHKuBlwpe2MS14zwDjl+lXHUGl3lqzoPaacECHQzKUTYt8K2ga8iD60X8QRoGIglNRk7AZZzCrgVQX6+AI2tSmydC7r6Meutf5vxN4rwBKT16HmDmNIML1+tugblIIfNT1Wv3pKuBF87B2Lj5+bsIzrpu3d84cEtkzqFWQKqHtRnRFZdH9z7iTBpbHrI74xgQE+xNIjTIWrKg0gkwsp34iBtD3mGTq2MUtb0mZwzpWhgv2y7QNcQ3unRp/UWiQUclB5QuRr0ZqO+vvdAA5gdpphhueQmoyEXq06rRygHPhTwIKfP+ei9NmJhT6CETwsyewH7CtqA1ckqPy0hkdS/6wqAhKQX9cU236Cv+XG4YQzp1qhKgXXUUeLZyo1IIFB13m4K3nak+8Pf7LDJuGnBFWzA2I61YPAa9CUyY1hKEj5lu4fsBN2WK0MM2Ig5MjHbtBx1r7p4ZzXCQbUTCRHz6ArfxMoIPNmM2GQIFke+gAYuU2VKbgAlEdhs2tym5S8JDlR16mcvGNW6a5jqzVCTqNyZLWly1mTB2YG3j40gmRsN2Pgfv/8HjmgaZHKV19eFOm1+pJh/6JXV39QCmWl7NoTKx6wCJuT4s9FTvTpcim/T6dQ2dqUh1J+DaNCwRGAngq4cPTjrzwxgaOsZ2PoJEdhXTg0tA9eib9feg4hi1P3PDv1T5mjpPZiG8/oaSl5kvhfPMylyi+xOe0pn5APdcVG4qQx+So4ntPTPkXPF+ek6r8KS2WIFnxlbkOqrIR8ZWkHEMwyKFONXw8lKmbpyCBUJDR1UNLwAU3NIQVN2YnbNiJX6ml1Vt9mIc1L1OPTXepYu03/2v/Ot9AqmC9VFQ3YmsZ4bu5ElYIokiG8/GthVTna4hAHrKwVitbPHX6C2Q0o5lklYwrPp5HcPFNg6T5gNGAUeV5Jfs82g/obMUe/iofrrScTralYWPUBsFEUuRePsmanQcyT/g=='
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    $sFileBin = Binary ( _LZMADec ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> CursorZoom ()

Func Image_474248Gif ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = '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'
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Image_474248Gif ()

Func Image_474252Gif ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = 'R0lGODlhUAAZAPYAAA0MEZubm/7+/kE/tDY0p01NaPDw8ExKv1ZUyU1NXE1Nbk5NdExMV2Ff0x8eNxgYGSspmxYUh01MfSIgkk5Ng09Ojk5NlgoKDQsJfvT09E1Lmz4+WxcWYSQjS6qqsDs6gp2dn/z8/SEfitXU2Hh3qEVEn1FQjCAfWDg2nL28z/f3+QgGe7W1uNjY2/v7/IKCpQ8PFOrq6+jo6LKytOPj5be3u4aFpSwqmyknmsXF1Pn5+rS0tj08aGxrtHFwrLq6w4uLpvLy8uHh46Ois9fX2pSUpKysstHR1d7e4RsaIkZGWCMiRE9Oek9PdU1MkX19oBUTZFFQiP39/evr7KSks9ra3EtKnZaWok1MgO7u8cnJ0x4dNBsZiIqJqbu7yYB/osDA0kJBqREQZ83M1B8djg4MgB0bi6GhsMLC1Pn5+7y8zCEfjE1Ma62tsrCws8vL08TD1BcXGDIwouTk5lFPw5CQpnx7oUlInZ6epAwMEVBPhxMRhU9PX42Mqc/P1L6+0SH+GiJDcmVhdGVkIHdpdGggQ2hpbXBseS5jb20iACH5BAkAAAAALAAAAABQABkAAAf/gBmCQS01IAGIiYqLjI2Oj5CRIDsjBoKXMW4sQioCnp+goaKjpKWmpzo0LB4xmB4jUhkFSRcPtre4ubq7vL2+u3FxfDICLR4yGUFuIwJAF0kbDNLT1NXW19jZ2tkbtC/FHgYtLFJdMBsJ6err7O3u7/Dx8ukbME8CLCObfhdKBf8AAwocSLCgwYMIAyq5oIXGDhAqlCxRQLGixYsYrwgJoUINE4wgQ4oceXHJBh2HBFwosKCly5cwYQ4JNYVJzJs4c+p8yeaCAEQqJQgdSrSo0SwCmpj8IaCIhCEypKhIYUJCiqZCcwiwIeEFEo5wqhodS9Yn0AsU0qpdy7ati6QL/yiYIKGgTqg3WL554aEnjYsOJgQQ2dAkhBAsbRMrNhtAZYXHkCNLnnzGk4oxKV58AGMAS4cNAkJsqJDBBQ8SAn50UCPAxwYnbwQwmUy7NmOVH5xY2M27t2/fUXxQ8fI2hQUSVP7Q8NTBwtUeHgSQ4IFGlA8Kv7P7dvKBsY0LK8JjiGBGBIQbKFCUsKKhvfv2XWzc+fBBggAdWlM8CSygg4ZvRlThwgabCRBFBwgi+MF771lRQno3iGBGBBiEt8IFNiDiDAYcduihh2VEEAEZa5yng3Tq2SAADW+x8UEfzLGXAVJodFBCZSR8gEIPX5RwAwQ4iMBFBHuU8eGRHF4ABP8iV1wg4pNQRillBF+IYoJWniAlABQiRieACWJEgEIII4hQQhpIcDnlmlFecAUiIFwwwZx01mnnnRP4MEYI+EUhxgdHhAAHD0UMsQAZE/QQ2glczNnDCBylcAIUeFZ65wWHBODBBRB06umnoIbaqQgclMqBeTiYGuQJJUJAKgc4ePpqqbGKaiuoF3iAyAwX3EDAr8AGK+ywxBZr7LHIDivHBTMEAEING5wwwLTUVmvttdhmq+223F57wgaG7FADFReEccC56Kar7rrstuvuu/CmG8YFeNQwQwtGHPEEDCUg4O+/AAcs8MAEF2zwwf6WAAMJR7QxQhBG/FAFEDCcoEFjAxhnrPHGHHfs8ccgf0zHCXm8UMUP4WQQgwc50ICEHRts4cDMNNds880456zzzjhv0QEJRMyhxTGYtDHDCFMYoPTSTDft9NNQRy311FO0MAPRlyRDBAuZRuL112CDPUkllwQCADs='
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Image_474252Gif ()

Func Image_474254Gif ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = 'R0lGODlhUAAZAPYAAA8PEf7+/pubm05Nj0E/tDY0qUxKv01MZ/Dw8FZUyU1NWk1NWGFf00xMbRgYGR4eNisqm05NdxYUh05Nh01MeiAekUxLmQoKDAsJffT09CQkQRQTViopYkVElqGhobW1uDEvl9jY2gcFekA/VyIgiTw7k6mpqXd2mS8vXurq6jY0lbKytKurq9XV17S0tiYkbxYVTeHh4kA+k0VFV4qKndPT1FVVcB0cMJ+fn+jo6Pr6+vLy8kpJnBgWiDg3Xc7O0hAPE4yMmvz8/OPj5P39/VZVaU1Mkerq67y8vREQFa+vr/n5+ZWVncHBwRAOgZubo9PT1YaGmsnJy7m5u66urn59mBcXGB4cjoSDmk5Ni9fX2ff39/Hx8dra201MdqysrKamp19d0oKBmRAPY8bGx3JwqxgYHmtqvI+PnEZEuaWlpVBOw3t7mg0NEN7e3+Xl5SEgQpKSm+7u7rCwstDQ07e3uUtLWUxMaS0rmhUThn9/mH19mUxMa+Li4vb29vj4+CH+GiJDcmVhdGVkIHdpdGggQ2hpbXBseS5jb20iACH5BAkAAAAALAAAAABQABkAAAf/gBmCOyF1HgKIiYqLjI2Oj5CRHi4tXIKXKUofMVsBnp+goaKjpKWmp0tDHywpmCYtRBlFZhcOtre4ubq7vL2+u1ZWRTkBISw5GTtKLQFBFzcjdgvT1NXW19jZ2tvZIzcXWMUsCCEfRDRAIwrr7O3u7/Dx8vP06yNAVQEfLZt0FzMHAgocSLCgwYMIEyocOOOClCEuPGyZoaGBxYsYM2q8OErMRouePoocaVHDiCWHAly4E6Gly5cwY7ocZWOGzAieNOAMcLPnTT4XAiBSSaGo0aNIkx7NqaFpUxoBYlA4EUDHCQp7bGigkFOp168Ugg69MKGs2bNo057NmRZKgBMf/wLE2erJi45PWdTq3StWgMoBgAMLHkxYsCgugMsQ+aEjBgofA3JGDtA0S+HLl/uqlNEBs2fDoeSgAAzGkw0URiZzUP25dQcZfaNcEEEbg4QrJCCAUMGZh4XfwIP/9sSheHEUv+eY7jA8AAcLxIVLB96hhAoQJK5IwEBbxIUoiJxhGE++fHknEnqQyI1HhYoSJXJ2mO/bwpkAP/z0MdJcQwdPcMB3HQgQQEBCDz3k4YR5DI53QRCIMHGBBBRWaOGFGFo4yhMSuOUFGgHQQKEnMEggRAAlZqjiihcwgQgOF1Qg44w01mgjjRvqgR8MIOgghAwVkFiBCX8IAcGNSCZ5Af8OiJhwQYFQRinllFNuYOWVG7xAwgZjFGillxsU+MKXVJZZ5gUmILLCBSAU4OabcMYp55x01mnnnXKCcMEKAuAwxQgvECDooIQWauihiCaq6KKGvuADEji4MIUaFxBgwKWYZqrpppx26umnoGaaxgUeILFCCF/UUEUSPCTg6quwxirrrLTWauutrvKQxAk1UFHDDl800QU6z4XBwLHIJqvsssw26+yzza7BQRtYdNGECQhkkAIYZAzhBhs+3PDAuOSWa+656Kar7rro3oDCCVq8IcUxmFCxQgtHIKDvvvz26++/AAcs8MBHhLACvZcko8UHh0Ti8MMQRzxJDdkKEggAOw=='
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Image_474254Gif ()

Func Image_475186Gif ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = "R0lGODlhUAAZAPYAABMTFP7+/pubm05OZ/Dw8EE/tDg2q0xKv1ZUyU1NXE1Nb05Nl2Ff001NWE5Ndh8eOBgYGispnU5NfBYUh05NhSAekE1MjwoKDQsJfvT09CoqVRgXXUZFlSMhi1taidfX2ywsQwkHdicmVkdHXbS0taCgorOztNXV2ra2t4qJoD48mbu7vPn5+urq6hEQYi8vTaurqzIwn8HBw6ysrvLy8oSDni8vRy0rnff3+ejo6Pz8/Xx8lCYlPampqQ0MahwcKxwbW6+vs9/f4nh3l8XFySwsUfHx8Ts5mBAQE+Li5R4cjp+fn/39/RsZiFBPmDU0cxQTXmxrssjIzeTk5nRzntHR1REREyIhWEtKlIeHn9PT1+Hh5EJAtKKiqQ0Lf9vb3u7u75qamhkXhxgYGNTU2Ovr7PPz8/f396ioqJaWo9nZ3BoZHDAwSpWVpKGhpIGBnOrq61FPxI2NpA0NEaSkqDY0nsvL0J6entzc4M/P0xQShU1Nc05NgktLWUxMbR8eNiH+GiJDcmVhdGVkIHdpdGggQ2hpbXBseS5jb20iACH5BAkAAAAALAAAAABQABkAAAf/gBmCNB8oJQKIiYqLjI2Oj5CRJSQnRoKXLUEkW2cBnp+goaKjpKWmpyxJKDAtmGgnTGYDaxcQtre4ubq7vL2+u2NjAzkBHzA5GTRBJwEpFz82fQ3T1NXW19jZ2tvZNj8XNcUwBB8kTClIIwnr7O3u7/Dx8vP06yNIOwEoJyhbeRcjBggcSLCgwYMIEypcSHDEBSlJSJQ4MwKEgosYM2rc6Cljx40YP4IcSVKjDRssDgUA6KCly5cwY3ri4XJmzJoBaN7cyROmnwsBEK2UQLSo0aNIJXgCUXSphBpCdOAg4oGoUzBgapiB8yap169AhV6gQLas2bNoKSwtu5RKgBMv/zzoEMJHbQAQdgl4YuIhrV+/YQWstEC4sOHDiC2Q0mAiAJUXFuwE8KA4gIbKaYqkCbCCQuLPiQOvVMFhgenTqFOnXkxElAcOnjQs8FTkiZMAOJ6o3r2bA4fAWS6EGI5hgpIOHW4cIY2F92zLGqLHljE5unXYlp8XWXAbh2znCzgcqXOjg5IJGIaHuJAFkTMM8OPLl+9lgpjjEW7E8HSFNHYRXQQwRGlRyOHBcxpg4UkbKgQoAxAxxBABck2IoYcX82UI3wUpIBLGBROEKOKIJJY4gSc+iIjiETpo0YEKLAgBxYkBpOiJEZ/s4YKJPJp4QRiILHFBBUQWaeSRSFbgif8LRS5ZQRRaSBWECFAoGQCTnnhgxBQeuNBEkmAmecESiPRwQQRopqnmmmyiucEGar6JZgdvbgBEmnJ6sgGde7bpp58X9ICICRfcYMChiCaq6KKMNsqoJ0A4KimjMVxgggBLrPCCCAV06umnoIYq6qiissDCFaSmKqoIbKxwBwkr0HEBFwfUauutuOaq6666iiACr8DmysUFbqxgwgczVLGDFRwg4Oyz0EYr7bTUVmvttc5yYMUQVcxABg0zyPAFOrIxYO656Kar7rrstutuu3FoMEcNX8jQAwEZtIAGEUngscMLPzwg8MAEF2zwwQgnrPDBf7wwxAdTSHEMJjOYcEImGQRkrPHGHHfs8ccghyxyGWqYMPElyRRySCQst+zyy5OQga8ggQAAOw=="
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Image_475186Gif ()

Func Image_475187Gif ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = "R0lGODlhUAAZAPYAABAQEv7+/pubm05OavDw8EE/szY0qFdVykxKv01NXUxMbk1NdWFfzkxMWB8eOBgYGSspnSAekU5NfU1Mj05NgxYUh01MlgoKDQwKfU1MmfT09LOzuCkpVRcVYqGhoScnXVhYgYqJokJBrdfX2ElJWKurrPf3+DUzofLy8wgGeSgnS+rq7JaWpEZFjRMSZOjo6vn5+hsaYCMhlNXV1ykpWHh3nBAQE+Pj5sLCyRUUhfr6+nt6nNLS1vz8/RgWiICAnS8tnaioqllZjhAOaISDo7OzvyEfkeDg4+Xl6e7u8GpptUVFZN7e4hAOgEVEfk9PZR8djXV0nv39/dTU2Lu7xMTEyxsbJXBvp7q6w0JCcNDQ1FJRoK+vsSclmaSkpUdHXyQjX0hHj62tr8bGzU5NgKamp05NkhcXGB4dNdra3cjIzwoIfJqam0ZFh+vr7dnZ2iIiP05NquTk6EZFhJKSpiAfX1ZVlcnJz01LsERDdQ0NEFFRbMzM0BkZHdzc4J2dnSH+GiJDcmVhdGVkIHdpdGggQ2hpbXBseS5jb20iACH5BAkAAAAALAAAAABQABkAAAf/gBqCKCMbHgKIiYqLjI2Oj5CRHhszBIKXK1wbRyYBnp+goaKjpKWmpzA3GyUrmEEzUih7fRcPtre4ubq7vL2+u2dnTy8BIyUvGihcMwEhF1YkDdLT1NXW19jZ2tkkVhc/xSUEhVIhNiQJ6err7O3u7/Dx8ukkNjsBlJtaF18D/v8AAwocSLCgwYMAv1y4o8qDCRJwFEicSLFiRRZIeiBhYbGjx48gO6ogAeNQgAtLFqhcybIlyyKhyricSbOmTZdLLgRAdFKCz59AgwIlEuDFExVPkASI4jNJEiIaVhD5SYRJDxNVhPj0VOOGjilahYoVqpPnBQpo06pdq1ZLABAq/5xQuFclDwVPSTxJEULhSoAZNED0OELmboC8nsYUZst4bVkBJydInky5MmUdAeJODmDiwwRPLDiwCEBlDswoNCbwefs5wA4OIALA8Gy5duXHJ1uEscC7t+/fvDFzMNNbNgcLnjhkycB5CQ5RV9okd2ImOfDrvsO0eOwshfc1OaDIgADkRIsWGdKrz8DjrXpwajgwD0AjwxbONJ6D4MCfv/QA8s0X4HrptXDCCUDIAEUOa3iXwgUhIOIMBhRWaKGFTeTgg3hKBCCHHScoQQwIH4gAWgYw4UCDFwHUgF4NIWxhYgB1HOhJB10Y4YMPOTRx4Y8UQogIGxdUYOSRSCaZ5P9ooNAxRBMVeILCJ1kMcUIPPBghAgxMuJCDJ0MYCaaSZCp5ARuIeHBBBGy26eabcO5whA5+1OBCB2x6AgIKNwjhgg8RKMHDVUV84EIEnhyKaACKwumomxccIkAQF0Bg6aWYZqopBEbE0EEMRlx6owyfjmepDJ5+2oWlHXRwaaubxorpBUEgssEFQBig66689urrrwZ4EgOwxBZrrK5AXLCBAB5gQQIYBUQr7bTUVmttATrAAO213HbrbQEfqEDFHxtg4cUFIiCg7rrstuvuuwh88AG89NZrLwIiRErFBsbw8IMNIhwg8MAEF2zwwQgnrPDCAotgQxQ8iDEFCiXgkIZkOR/EwcDGHHfs8ccghyzyyCLj8YEeP6SBQxCWrFDGGDcw8RoaDtRs880456zzzjz3rDMaKtQwAhJqHIOJGJS4QcDSTDft9NNQRy311FS78cYqyFySTCGSRuL112CDPckUlggSCAA7"
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Image_475187Gif ()

Func Lzmadll ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = '0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000D00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000A343B8DAE722D689E722D689E722D689643ED889E622D689883DD289E522D689E722D789F422D689693DC289E622D689E722D689EF22D689693DC589E322D68952696368E722D6890000000000000000504500004C010300448DAF4B0000000000000000E0000E210B01050C00600000001000000080000090E100000090000000F000000000001000100000000200000400000000000000040000000000000000000100001000000000000002000000000010000010000000001000001000000000000010000000C8F000007000000000F00000C800000000000000000000000000000000000000000000000000000038F100000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000555058300000000000800000001000000000000000040000000000000000000000000000800000E0555058310000000000600000009000000054000000040000000000000000000000000000400000E055505832000000000010000000F000000002000000580000000000000000000000000000400000C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000332E303300555058210D090208106E62B27EE4412138C300008351000000A4000026030030FFFF77FFC800010053B28CB9060088C82C01516A0859D0E8730230D0E2F85988FFFFFFFF840DFFFEFFFFE2E68B5D088B4D0C8A451085DB7413E3118A1330C20FB6D23284FFFFFFDB15001DFF43E2EF5BC9C20C005589E5FF750CE80300974283C4045DC3FDEDC8650F48C81062536A058F45F8DDFEFFBF4E0C833B0A73088323006A0758EB5A832B0AC745F01D004BDBDB6DB306F45B8D0D50503C1C6A0009F8EDCBB275080802181410538B4536DB7FFFEEC00A505647FC8945FC83030A9C45148943052D6A6BDB76F70953E82A92884309722C15FC9876FD9C6C65145DECF0836D14DD6EFFBF344D108B550C8B0239410573058B04890269EC509EEDB6BB03F45045055108145069105273FF67E77E6D670CC424837DF4027505B659F2CC7D5D5FC9E553817BAEFE777BDBCA381F8B8DEB0F686B016EFFFDFFC2CD3C31C05B02435243204572726F720D0A00CCAE61738F0055B80192435D4090008CBDBB734EE1C7000515C74024000604C9C9D69D2CD9FF06201CC9C9C9C91814100C0FDFDEC908283E7C908D7426A4567F2F2C6CAF55311ACA0F88EE7B1A8B423DF6EEFF0485C0752583FB050F8F8C118D4C1B0E96D3E089B2BD5FBB1A8DB43514BC27062B08E7F97CB73815010A0CFE0010963FCB9FE7721485F6CB4A1885C9A9ED32F67D5A1C6F8E2B207867746DFBB79B240ED1F9178D41107502D1F86B241B1582B59B2C2B5B5EAD7636E81EBABF96060F95C048250CFE150493E977EB885D54022CCF90096FB8021880B50905754B433FDE601FDAC76D3DEB900FBB426B7763EF3E01FE8DB65FDBAD95C3899F536BFF72F66E906F9F83E0E08D484089C217D76E98ED631404F3F089DE100AE57BDB585710730B4DBBC22097C10B420803376F1BDF7F23A4E583EC3C8975F8B9248B4B8985EEDFF87DFC8D7DC860C8F3A5890424E88AECF125CC2EB7CC18F88B89ECB86FB7FB6EEF55BA664357BFDB563F53BB110D0BFFEDC606024601019089D989F84349A9C1C2DBFF6FBAEB0690881C32404239C872F743B2157EE109F962C7DC5F51E98DBF4F8E18BDF1B799897310895DF48B460F1F39D87BBBD02EF589C30A5F5C241A44240495DBE51D6F0CA0BF60295E08015E1A1F6B7C97B98B2DAA764F575052351ECE7D1CBB4848A73A5CC1F76F6FBF210881C280C33C05102C0489142481C718BD0877AF8B39575125B9312A894C2492452E772BC80B04587425B9BBBF93B000528248191B870897C9EDEFB680CF8FF042C1E3058D343B0190A37DB7B74EB583AC25288D930589CCDBB22C4BB789410508080C0CCBB22CCB101014141818BFB6B92D1C2F8C27411C3E088D8E17027BDDE401CD8605413BDBE9B75AFFAD1D'
    $sFileBin &= 'F00B0F8E67760C03427BF709F08D9F640981C60C2906AF77EBBBDB74DAB8801883EE80891C4DEB80EC7B6BFD4808FF4DF079E0972F97640538C8C8F7B7812C918784010B3088C8C8C8C8348C3890C8C8C8C83C944098C8C8C8C8449C48A0C8C8C8C84CA450A8C8C8C8C854AC58B0C8C8C8C85CB460B8C8C8C8C864BC68C0C8C8C8C86CC470C8C8C8C8C874CC78D0C8C8C8C87CD480D8C3C8C8C884DC88E09C384EC7F8C8050C2B2DB9E42144EF4663605CCF31F02B2C1919D9CA48060BF44CF81C19191950FC54002C323232F258045C0839323232600C643819C8C8C8F3F8963CFC40979F91E7009744048AA0BCB8009D8E3F743AD3E68B91A825ED1C913608B2BA54291CB373226958AF5F102CD353026480C35A05649E4E03A45F5665892A7D84745F0301FB179636687056DC14531486454A81F40B5F50BD91DA3B5F08476E86058C2C43255F5DB7C329765B80E4BEE4F25832B29DDAEF640B8830323232328C34903832323232943C9840323232329C44A04832323232A44CA85032323232AC54B05832323232B45CB86032323232BC64C06832323232C46CC87032323232CC74D07832323232D47CD88033323232DC84E0884C96CCD65587875874A719416A416E5E56C791CE7824D5896B8B9AD191EE34D28B6589710B5091919191F854FC58232323CF002C5C0460089F232323640CF8963819798E8C3CFC3C009740D3E91919044417675C891348A56A5E89F65FC2C4480C9F4C048D4874749F6EB81B83189038895DA8B8A54D8FC142B71BF90822C991C483FAFD347FB6040BBD75C883FEB145BC3D6BF9CCCD062587A30A40989FFE7DC9F483009EB5DC89BB040845D083F857B6F8DD33868F251101BC76060D2FE1B62630BE6B8993984ABA6FB85FBF04398B9427B39C05FECC000FDB75BFB7941D83A4BC43D4850AEC36740F50BAC4ED65D8017E4C04037FC6C289E776044E6FBB7145E056E0BC9CCD456B3F16C70EF80989435F2FB80FD43A16BF7811BF0B8B7AEBB472F421CC0E2F8B5020ADA391ED395B0D060C007D767DC606011314C6406A5018CEC9168C7D062C30E8B2782F384F8F5D856EB150FD93758E70308E521BD9B674795D8C759011FC3C8E75A3F18B53B329C68DF587FE7783FF1239F07407C7433009C2D2017328D1B2ADBE932011532C04183B05BAD896EF6110D970058E5AE1BBFEA6FE76308B48DFB97EFF568BB52942C05F6E4B1483C20183D176B56CED00C1E6610E8989A0C4106F15728F4B2FFAF48845F76DBBDBDCEB09182A0C21004DF7741817876D77FF55F788104039431C7B7441C622FF4CFF36EC1B2CFFA509D075CC6550236B93FD89F0C1E8186788536A1D1078C789D86B0C7CEBB6FF89D7365A0BF3C20C4C8086F051ABFF1723890B74458B034E89F1D1E8960DBFF0AD94F255F0D3E8E401F7D821D00F43FDAEC085080C0C812BEE0077CEC165F083EDAC2BA725035CDC3E755F61241B246F0C2DF091E9C60D89C613213835BCFD37FF0FB71A89F9C1E90B89660FAFCB382B2BB4DD2C5F08CA29D8CF05775D4B18FFB781F96C66891876328916508FFB7EF7AD4EF8D811560C2B89FA29C329CA8DD13103DBD025A1E119890E36D3E163BFE9A96690FFC75689D60194B765386081CBA93F5789DA36DDDA6D5607FAC1EAB11456AC01DBB7B6D0150FE70E00FB5FE376DC9B188C210F573B56BEC1634BB9A13C4A084231C9BA851768EF4B1FDE63C9EB0356B4B7F6DF413D3C77F64A79EC619C83C31060D82DD76D80C85307326A76C853B7B3C5B64FD15198C97FC6536887BD5652489FC89D5B68EF6D3E144608A65DA325438742DBFA31C2C1418B483D0812D2AC75A7D488A66F86D79EC55F5C31FFB6070AD6150AAF049F441FECC89FE90CDBEE21F26501D0FF30596D50EECE5400CE70033C90EF330A07FBC8F7D021C676BD5A2E02381763081F6DD26008F0C6035185C655EC746F9460578B064FEC4FC118F8666B106E06D3EB83E30169326E1722722809D82E75D9560EDC72584F1C0C45313CECBB12B82910753955E85F7D34ED7FB624CF5F1C89FE83E601D1EF60AD8DB91BB23424635BFF38BA8009ECDC09F0423B7CD6CA1D8EC3482F2F31B45684FF80C231F6E0C6E309C3EB2856F80BBBC22BADD1EA230457F7DB81E30B1B5B701AD931C6F8521C19AF6DFF8101DE89D383FB01BF5BC85B7FE4DA77807AC4081DB347032FD88585D2511D2ACADB4BC3F6F183E153EE777801FFF7A4CFAD50480873E4A62E69214BEE4B75D4D96F081D6D81025B6166176A0405ED0DB6BF000444500406425D7F76F31B986B4DDB90B90B00238C1484155C1630CAED5F1F025AB660D881FAD1D2EA5FA34BF34D3FBC2055800415F686AD90CF944DDFEC8D0413B6BD6DEEFF17C1E00689CE8D8438044B14E811C281F26F8E8DEDC008D24604F7C1818B0C6DCE6CB7910E57021EE4151286C2B6DD96242101C819E0139673FA49E2A588894DDC5F3B75EC0F8307228D706BC80867CAB1B1F0F18D443B0407CCCEE4B88BD1DB4BDC0C04B246460776CE040F773D03EC1CCE76A3163F736514B5B5D26C46F83BDFA83A01E6DCC122F1414DE03F80418F3DFC3D0F76CC33318D9F11903AF0BA08E49BB9262D3577DCF0E862973072D63F480C0964C3BDCE848F08095F2081522B021FA8E524C12E18F8D639F32360731B26B75FEF536FDA436A8311DC1F72EC1BD813020DEB0D90004FC9391E18286AC32C4B7734F8D8DE589A106B4548A3DD602A6438967756C756C3B70D4C3A8911F5897CCFC1E2F13BDD0B29541A041D031B100CFBDD5DC06BA77416'
    $sFileBin &= '228B8493CF488907A44B5837157A915501156CA10D7080286ACFB6972DE7026B8D4797446E941A5DC2DE0F82EB8C903C27100803EFB03D472E938131CB21D8366913CE7F96E87928198703AED887EA28AF6EBAE930C111617504C97F0190342FB7A00141548E4018FF51140242C06816FF3F1568AF1D365726AA2A4D77F7F62B53628398068C839C10444443714325227439C67419B45B28B6FE85940D942039BBC64A6C3A7C15741ABB76F81896101E61322D41DB5DB864103D48FF5C13983A8B9367B5E950E9407FC423772A6EB1E1B6092B0639D7B773B224040733DCB6975C0F75A9CF471273A2041262C2EF0774EFEB94BA33EBCF1FAB52A9B94ECA53D051DBA506C74D6D016FE9041284BE4FEDCF538C948B9C0E06818483095B78181835C6CF0F0CCD420B060541892E7CD79CDB26039C0675465594485BAE0E4A6D3E0CAAF5EACEEFF47C574635CB559C860D5C17DB5C9606408B4CA4C8EED00CAC46003048447607DB0A93013374344C4E5C3D45E440949E292561761B9ED3814E74004DBE37ECEB96336A7F8C170B4BF274CBDF9FCB51814AFC9F37C73E931BE3C396E3A54307CB348DF40D469D487803F2F0EE15C16118BD54330C1A304E136D205F4B5210EA8D023BE4045B0EE08430A0CBE17EFCE078144F9E880B178F36B6E1991E01F0D7059015E4216A6078D31453568D0C7F58B2D310C8DD79829C18A00DF3BD1BA60E9082B4512F18BBBB2957267BE7840E741581C17005B3DD04EFC273034431140610BD91BA5B184F7F89E3EC74321FB58D56BC3B8B7A1897EBEC08DEDD8E1B395A142E85656A8B86B83E5782D73AB1020A6B5F05D096C5235856EF6FA8016E9480FCB2E5C6418B82D8ED4EA5730B0939AD980BB8BF5716E0B1A7BC051418B995B0309F018AF49F0FA193752F092EEBBAAF8DB09FDF17B8A80FB7014D98F488E08B574B3DC976BBD84F38FBA1D7ADE84B79F6097CB7AE5998D68F1517E1B0A417B4D714CD9F4DB79C362A1C2C7021D68678F83BEB29161370E8D8A397214CF0B0DA0CBC9457DE14E30BCE1A87D9975BAD579CFDF5A060891287A0604F0DF01604D283BF57003D8901B700B3DE446EC21CD4F06DBA9D46137C1406B83F5E977D8D3D5C717A7E10FA1A9A5DC3184FBA8D032F0D9C04DD811C790FF02B5CE118BF1F2B83720F8F8D802B538D193538BDBEAFD00A56030F68A7CB0B18FAC8F0C283632F849E4C04B95D1B14F1FCDFF9BE8C0D7F236C08815F585381EC5ADE0E8634F48DB585DCFD90EDAA6BDC97941EBEA6D05995D481AD16D8128D780CE2B0CAE0A946C77EF9D3E28B8D120456580B68F3FD5A0C32050AD54CD92973075B5A7B0C70FA949DE81D947B3BBC85B2AA8D862ACD4C1D0368DF16A9A6D8B870B71910E4DD4BB98FFDBD90B589898DE00D83D8B7458BF8C504955F8B10DCE183D88B3507BA8067674BEF24C5951CE6933E42B35FFDB1890F39D077C3BA0EDDF80E1195B664DBEB2440E04CDA83BDFB3DDB3AC66D416F398E3E77DA7F71F86F6D8B134E8F4183F90376F4B91802A76121FF1F0E1FAD366BDF8DDE03792DE49750E8A9BFADA28081C3A381CC26C75FC15929DA0F891F10EC70D261C786F05E81C47392761F1D31189F40C783E58DCFF712EAB39C01FA2000ED346C8EF858F0BC8D43208C8E8C89B3834FEAF1EC8D75C81B018CB4850AFC90EED96B49A22A039C0D0EC7CF35F70EEC8667EB0718BD275B9404CA400F6F2830BCE8CA54049314CB70D3D94F3CEE2FC37408441BA44541CA5514AC1F513055F34FFC5DD989B92D3159D70427040F18BDC61A1A03C7E49E238EC12349F019B0DF7B08C3600FF4108910F483C5E0D016D4FEECE00EB27B0BD701006D6C60750FD2A17940161C3C8B383C89D70A9D75571C0CDECACEC1902D6FF84DBC8223DC60C85C69365BEDDD88321C0F4B04A5942964B073AE3BFFE13F490DFC3E51008008EB55B0511BB07089D78B96F486743B02FC4163C48BF8227E861A6663F1F2464A1628158E580674F13DF9CFDF60EB0A1C15074FC045E876F5457B059669A4ACE845A89DEC06CF1309C1019E00505608C08E6DD02E1508AC3C184C787787527B8D55C41476271A14BC8984402BC49DA0135337C05960836B055732B659C09C3A86341CA1200CA1D51BA1189E12E85C4B876DD8740896D420C0BEBF57720E6D573E9CFF8E31FF3D7B2DD7B0280179A389BD305CB7EA2236845A0B7FCC7C07DA5F8215786DDB499CDF0D9806719C08949C4F6C23BC72986A45C0F44BE12E76A0BAE724A0010F8673B1F614ED84095B0721081463DB61AA0C0F986CBE763BD2F66DC90E94E258FFBD40FF98444BDDCDB08885AB0590E78EFE5803F8E6DA29F1128D7AFF3A42FF5418ABDC91820426DC69E0F67EB4639E613995397BEF08D076A399AC879F766F1CBCDCFE5FA221907C93FC763F8B4493F0403BBF75354BD02059CFEBA83B146FEB6F17F476218D42FEAF02D52BF18DADC530836D4D9C760BAF352845F7658339C874D45002FDE2D4FE3BA7FF7F0F97C285D07411B903D72EDB120F74945A8BD067D2EFCEF50F831A6A0C83C0020E93C2F5ECEDE6DA81A0313EC085D085FB011E66920119037FDCD9FE42063FD40F96C08AA0DE85087F96C209D0A801730ED3098686A5183BFBA48B1C63ACCB1AB66F972521C72CA401750A05C035F12D0A1286F8C25458688B1926E333AF3F8CDA25D9721A2B030F4689D9B0479A312ED6D865BB645645A8C0A603292CC9810C00441E3D723B5AE0DC01F26BF36CEFC2F8980F95AF0C1451058C192FE3F8A0E0F290573AECED8BE429D0'
    $sFileBin &= '890A01688317E2F1C1425EBEBD001A83C4A1ED81BEEB7FC4D7827A42BA8D910F0CBE06A474638B2E015F6A165DC54DB029D82A84066E54821BAE052C1136C77346EBB2F9DDB2C8BC72C0BC4D0899033719D9DC5D0B1396D4050BB8BCFF0DA0BB05002065D2CD39DA770E0F82B6FC86335B07D2C807AE62313296A9858DA87F4011ADB5ED227B1DD67A980DC1EFDCD7AD94D6C04A0E8C0B18204C8B8EA312AE47394117FAB254B91D55849B28031C490B50EA739C501C1F6CC02CC46847D029CF6CFE7D81E0F88246550F9590914B68968696930119398686BEB42108957C8D7583EA11A1B3B02A14B7959AD04A75D50A838DF82F0845289FB8694402AB9C06E61B697BB1B39681171C10A4C532F06A6D07860A35EBB44C4610D50410FB2E165CB1D7445B38C02D0B152016FFED00295898DDB6D71A0D46B5048F101B66AD16AE748D1E3D14A143A5C30EDE455FD562DFE00D86919191CD950B3C4038BCB1709D3CBF1A891474F1483F3A212B3D8686EDFA38D20C261426B8AABA108E6F66435F1D67E347013843B0DBCE35D571FB1390DE4FA039097356686FB6201B42027517FF0D3113DF5003CA55B5E2043A38041AC77AD6DB74E9DB9039BDB1231B0839C7C746CB6D0A284879187D0A28E4C3E11F3A9B8E5874277C03523CA0D2250F9C9214427AE3D6AC1C21BD99FFD2843605FF5C4C0BB38021FA0255E55B92E91A74CD49039670259C107D9E83D8B11FF8A10E46968C2A0D22FDAFBEF5FFC0B92E29C1C1E91FF7D983E1C4C106D3E8F16D45365784B44828E002274E2C54BC694E450EBD5ABB111EBA071BF16052AB9D3E07111E0783D3DCC797048EC48D7C15E70D1C84CAB88B9EF2DC60A97C8C80BDDE00808386821C803BFFC12DD52D31B87837483B74E44212C2E90F5F84BE4BBC466F9517ED05A4BD70B7068DD89E5D08855433FFA235EC15FF385D7225734CBDC8476DEF8D064FEDC68BBD519530DEAEF1F63E5C1539C30FF7AD3B85A1C36F43380642955C4186264FD5BD0BB15CFAD88B83560960E2FDBBA083BD2B01888D5B264B0ABC25762338C14A5A0E6848EC76D011567416E47711B4193C1C285B454B2D360BAEAD92AC763F4821C30F7E3FDA13A0279D74999E944DBDDA041B70BE0588D98C66DB019F7841FFB9B229D922A83D186EADD3E8ED0C520259F81FB8E04FE7D0C1E109E86001DC9AEC82D9B4FF062A15043B528DF795B2E62A85A457BDEF76813BC8E8203C8D3C03BBAB1F5E8783519EE8BDE53FBECCE616720FC5D865BED40A6B609710B368048455E442BCD8684305275E2C85B37D068C01CA878D6711BA9FBB642B388D5A84FD166F959DFC6EFB182D8B5495C821700939CA7306898DC80D5EE17905B887B10C1C38BCA25A900F0C3546048DCF838260D25D21F6DD83E70F28C001633DA9CD9675070B09690D04F386BFC9EE18BB44235CE8198C0B216E74B155CFEC61F84AA8FC7C10735B4A046F194E9CD2E5308A57E30433A3908412F278AC2596274A14E1F9E5BF5DB88D5B0DE52991B60740BF2B60C0F5780C00F288185FE295F21452DB0901DA833B1B83E7C606AAB8FE05089D401DE0EF341A517FFFB8A418B985474C98B41C7FF536E277950C01FF798D095F6B850B5721FA975EAF4F8D6171B2505AD8DB37C50A75636931D8564C2021754679B23AB3C04947048B9D8343B5412E3D10657BFCCF3BF5732A5DE04907B0B93842B61B431A98BDF61415873116BA0BFCD14C5F1374E589A01812395C8D74919A4BE8833989C06526BB214348755C2324F2D9FA06069910E6C6B8ABF13B0DF249258512A5B2756AD81780A3F80AAE49FDC176563B4D872CF6DE187D8C3B39FB0F9237FD7533048D17FB4239D1BC6C0786517BB487E9A6F26747EA6B8CCB970E0D0239D82A0D586D22C6C20C5AAB9D54908E888B37ECFD5A52AF8C0991D34588833CA94997946613D9DB39783C478B99C9285226ED1656A6BF9C19295A63FBE52823B0F28D531EDFB991C38A159114BEACD70791BDF4B6CF1F2DDBE3B744272016C5F80F0D1C9A74D5BA49D944484D87C282FCBE511C4A1D076211082C69D7051A385B57E4AC89C3CCC608B8BC0A96EF307048C19285785B9F1E58FA0DC704404BD63055F19ECB05068B6A2807B370A1BEFAC8DC01F03A9031D8CD3DE326A37D115EED06ABC598A182339A46E12D0974BDC2C801D1F40B85CD966860760397C59D2CBC6A7BBA4703951A4CDF023F7EA1BD5C8E1FEBDF850F02BD7EEC6BF3108B0C391C8272E87FB79A9DEE25148DACED8F04E7DB5E73A8185D6348188DC8C06E7BBABFD8850C301BADF9606B7804694433037787F72CCDD67BFEF5487FAB950C6C36B0F0C1E7072C17504C1D8D44F08162273C8B38B98D88B658E1FB4339B80576B60789487536B381AB41180608E16E36FBC9411CBECAC4740643B08E950EB02C6C502E1C75EC88BDC72877859CFE290580C8021193A36C1864C9D0CB6F5EB4397223D19D632F3C4B881BA94B1616A084E76C9C60DF57173A4B5953181761DE4366FB36C10C4A09970F0B102940613BB1F4837B14031006114F38931522D41D3F101F3C762EFDF56CF6128B059E3CBD8A4839D06C7E939A1BD662BE027B0C80D9D95AA90AB334CE96ECBDCA344D7752B8C55A946270A470690EBCD162FCB68F20F4EDE0D8771B5FFE6F06DF18971C894495D84276F383FAEA225DAB039D11200D761E9A22D685B5F61C31435996AD35073E0520DC24BF5E9665E028E42C8B1B1A9D2C1F8B3378252CBE2F4D848D50ACD7360D691421F9B50735A0858BEF1B29D09F96A4F79A9FD58D34'
    $sFileBin &= 'FF1AD6741DC13286C4ACEE40B6D89E6601D33984782860F0E2417776792E62C48373EB6C2E8C70175F01C1832006D2960132566C2C511B6A3644CEC313321A01852897BDA7C77E16F77F3C308B143987CCE78E19B1BF9F057628890D596AB5C6B3455B43891C09D99BACE18CFB1CD68BE8DC2C6561B60A2C8FE78B91B6D2D35138722491614BD93956241E2052ECC8581C8D1B911A940C8F1462F498FF8EBB677661160AC431409485409DE14E4640E6A38040295293363E2D466F5BAFB320356906B8641AED94D446790F6D0C48025A7290810FFD33DF96E954680EF2E244D893789B63E3E0A91C966C649CF07B934E0A04060C232E2D7428158295816E973376860E30E11B2F77D9C0344B484DB32D090A26D8D3D84A77E9884B86ACC560E07CC41BC4C6528BFE578039C7642C19784D3516801268847787AC4894C038954F950E2CC4864D85D0440B8636F1DFF63024142A7DD84129F8083B8D072956F850762A07697322A2FB676C3600F2384701751442120F94EA07EB221A13043A74EC4A9E2A94966D903DB12FADA4EDAE7738BA094121D9BD100D3219318E8BF80BBCB273C676FB57102A7E1EC7469B102B240254D0468D31F85C100139BA73D39BE0A17623DC7F890852E71CA3C2E9C83704BAC0301DC5B319C52F72E9B08B0F750362945231D231F0748D352E16AC295B0CFD5B1681C809CC90D2E68F8F7DEF2B0C53868911C7421C0079A0B2049D8D9901BDAA5493AC40957404DAA99B2D57AF853035E4E948A7850C47852786757B4213FCFEFC4EAC251B99843880EF7188153B8D3B8F86164C6D3D748D82DACA18007D1706017E07EA6305AB0C682DF02225050BC4E8318363D02F1476521CE707852041399C45B482137143650A73219951E258474F9D5CE78D526F5BD802DE6E7C93F8722BB4E6803CE17D0E3E890C82AB119DDC624E068F41748255F917952458BD1610D3131F91690C16185AE4D66CC9628988F0FA3B28418D42C248CE9549D2E1B516CF2F77E9E0597F036BF1636FE04DB4393BEB1D902B10CDB138EC02E93031E0FE0C6CAC592CE22D278B39600EF9D84F8B5C9F04DC5612182A8C7DA1F0D832BC33B2C2D876B688DD9CB888EB7A8B375F07186B67712AD177E3F871CA1859EAAC406176221E275E9B57293DB1566A34982C2D5A9F7083507A8D913D8F99852CF0CABF98CC3C9374750AA4346887AF85738D63791B3A55B0EA1B72FF040D9E4D17E447DCFE867EC1B63A7B74CB0689188633D0EAC09C9611911BC98FA6C26625D8010C9E071F082CAB54434D9C62D65481A648D4A378F15A8D28761F910BAD6F59ECC250ADDA685850DB8EC562370FC373594BD4F675AB271163443AC2443B7B0706B076420FFF4F3716597826D021BAD4198B2C5B6F05A4149DC6D16C6B7674CB14E8488DF408C3D86B775B18F63B5DB44AF0F9B831A1F6B35C7C9FC18271E1B94EDB17A3FE238C11C6AD4929F907040283C0C317670996068CD5AD487485CC64841B8B352C842105C8AF129D0B91CBB2852AE2DA945667C0C8A5EA1D9C96D9AE8D82859387C4188D14888E615DECC6B6C01521C833E01B8EDFB1E05C39AB2B8D1BD3FB7EF86D8F07886D34A85CE009BA8109AE913290B60C1F9E0517AFEB2F5AC8BD593B76F66BBC21A801C7D0AAA4664160D7D040DAC99444FF8CCF94819434F123F94ECE130287E7ACD7B6CE2B93F469A48B4305086690EF83422C046215C9A10EBC09BC92CF6BCA40040ACC50D0DBBC401688D5CF38F8FD92C06C08C98DCF904A6F9078016B7308F534D240D901108C425D9E6003A73695694790FA3CE4095C38697D14FF96D1389F473B7DBEDFE0F41285B0401F74E5E5B2CD6AF5D6F2F9FD80A77B011BFB130684C1C61366290877DBA408167BCC924CFE7CFE0A6CF508CC0C9EF1206AD6DC8A9F04FF09E2AC17635B133938FC5A1620D620946A54172DD19DD6F726431FB1710C9D2D95CE5A9A4F3358A525EACDA01EA1967BDF36830B077506F805F86A8E142830569CC2F9BB9E4B2F587307CC95F8468375C2D93E082ABD0A1976D8BB341F29FF422A1B244BC3B2B1509D2A551939E9F5668D74556B8490F14A469F9E7DCCE8F8C88725B495803508C604A7AFF37DA5F43985B0F00D48C3849186C22C269CF2D4C8D98B2ABDD9EED03B102906FF1A1E4DA7D8D2C3ECFDB9C307E9D4226D17F0BD11E1C1644A3A5B1FE8C7E8690C1E31883509D581F4260DC9FEC7D3398BB59069B98EC13699A4BFAA4221CABEF470CD5656BC0854BD9034E121BC01DFF5E37081188426CFBE9D948E21238D36F8CC03CE70408692843972DB13F1DA530BF0BC959524BD5284E3C8DCCBD27B4B4E10F78AAFD1844E115A02CAA5D0A78FB4CB5A10897AC833791A10A3876641FCFD6526956403481C7D01AE7E84FC394318730B0D904B7AD8D656F36A3472386F0718798C8B95D06BA0822CF36287D1330B2F439A4C200601614B020842BB07A76C30363F01ACBE271C607E2741F77E8657EE9B504389061188D7B1E032F7FA89FA11645B067182AA9864309B215A07B346501280C749538C9AD9EF8511FE5A241E0311396C7610334F96630731D2B4B8B80DDD19F166A44B83E90428C8C12B598D71E4F68B9514957295C4805FC06ADCD93D562996B5C6A547CCC17830CD31AA407B8AEC8CA3DCDB59818C0C0F83F71582C60C1B056345701A55D6B53D6DDCECDE88438C111009C59775D48C8FDC3B8238EC49386120442DDA235D76D4908CB0E1E886CC30BFA7E0EE64E8F0BED4DD3181A698A44A9F8D55C053948A5946AF75012BCC809161D4A1'
    $sFileBin &= '6291ADB4AE3C34A2AAFF0B189E763C24EBBD894DC06710805640452D901DA080148FCF40ADE254A620F55126E285E46843D10CC15D54F18D86021CB9887607EC2C89D92E34EE584842BFE811CF0F66C7B59FDF93EE0004098C2776E3B8048A009D00F1BAF69BF96C2C45B80C8C5E440794EE4CE5CE5E5C1C0B750B7697DA946BB3C535478A86986EB1E0FF74C1D3E239D37311C36604581D8076DB46431072F5202C0B2C9DC3B866174240A03F09E1BEDB76F44AEA80C3E6DADF80477EB37B6B0C2B7176ED16AB9E1DBAE1117C380A5A39992C2AF00F625590EADD989C252C29541829222750C2792002DF5C04A689D1498928872814598C98CDA4401308D05B5E4F1802BA8227475DF4428F5FC4837F93C9745A8B87DA908DD5C61B81B71E8F7C574858C4630BE9BC6887147412F7DEA760FC132C2413C70A2EB88238DAD3E37AB38AD64335BC23E8B343357809068CEB968751BCACDF31C9612C896037417F9000BD83E50274835C26AC1A77091F5DD0B7D339C277F25510040953F0201C46D1AB2B7805871742D2AE2B5E812C08CF43790A36008DEC0137F85B406B41496F571CB00B2605466385D2DDCE3A585F7405C24E1EBE9883078FF6F8CA2616BA84100DA8C50D2FFE7E6F38932D0C39BEA051849B5D4D08BB61A870A25013CC832D22025E0EE3E07BED411C450821A145113D1B65194D0C599685BD2E80CFC9537464482D010F08D24444C86ABC820BAA89D09E22EE0D7B85901C541FC61488BD151174D9051C951CB663377141BB899D8B56CA8E50880DB011B8F9340F97FFD04498651981483B45F072772A042C10817FEBEAA0FB895F8D5E205E10B9149E0972B3F30D2AD591DB4DAA8A978F7C7249227E6DC763035E185A337EB8DC968CBC65DB3F4C2173E609DB40CC8BE8A39EECCDCBBBB90DD41329C8FC5C75817E55F620269EB281906D78E56D9CFB7FDEFE841A06B4E1824C01432C2FBA204323BF2E2F88ADB5E6203F0E2B11059B905D9714085D9F415CB934B56F837203F011102B5522446C36B3350C0F14C390689388937F451482BB15E90BDAEE1C8B105778FF280CA0C143EC8D833B2341AFAB72837AD0754DA04AA70C1E7EC7F80D24EA81EFAC501C162D6283E603766E8803C7DA205AA7912C06D00238B24F109C8058BC059A09C74611CA109D2DA1562DB905B0ACC9A189D8067659444DB66F24C2B5AD234820EDB834815A368F4E357E4D12D893755929925B729715BF2CFD9DD8301CA88560444A141C446FEB1AAFE90214E447DDA1EA68FD00876607F47C5AA222A787B6756E2A5A311C3D2A46797BF0F8C99F3001564D1C8DF1B59845D27C1B01B534D69BFF8C4F1D69C26D8677AFB9302B29D88901DAAEE00132F4AC270BE4B8F154C71B46A902437A6DA045E573EDEB88BF8DC181F881D1D0437595140F888428E82F7703ADD9E00F7EF3E37765C71E0ECA5E868F451C903B20C3893FCE2581C4A559157B506E671551BCB314AB5CB5F8EE50DA31755F9E0A9E5585FF74D66105012BD1CE2CA2695A200C10F13F8A500CCA7FFF17EC211577808ABB0A19446C8DCD4848D440EF0381E151CE02F0F1EB8DE2085647538B9A3283390F7C542F5168C701FF82E28BE00D8DD4B298C1806604C00282013D7C7A1ABE83BA0B2807101B069EAF88D1AB9032D16E62ECA50A27B11E7EE5FD47DFC0F9E60CD5D0E8884417019BD86042E17EEB8396ACDBA3F038A9EF3070524A703696F475104F61E870B271EB7C118B065BF4F0666DA7EA85C3082825BECA572A9D0610D10C416A5F93893D8D4315D104B05043C2BF06A24CC8D22906F43099463AA4BF38D72CEC20D8CE30F83C1C81C68AE70C4F57742A65AC5503F055BC5E0B260AB4E76401CD3008FCC57DB191545F3AA10892E6F3ECC24146DC75BE1CA49B6C6F20D9D618DD14839C6CE710420C084749AA76B56C403348361FAA2E44971040488F483D0675A3EE8777788B3A4B245F1B61F8873F43388B73145422C8B6D6C1F639D0726310308E17065B7B5503BAD0F83229F834D5BA9BA1343B18EB031329377794A35A47787E48EB20FDB6B51955DA42C82C3B4DEC73054BD4D8A00B69F82C848888DA97E804314169FF75E089719FAC0B41707CEB993F688B702406AA89788730EC94201CB80DDF523078216DFBA05E92855E0A7B29185191B5A5D8B6597DDA8E76E3161CD916DABB915DB4301C9FB836F00AED585788B08B4934F1BB6E893AD0A880044D1BF6DB76AF3C9724494017D83640441AA120D4F5D48B4AAFD0554F36B46CDD194917CC044C8B0ADB5608D81CC86E3D2813C4772B7000A0D07DAC4F49AAEDC25996791C80A8CFC476CBB575348FED21F30AE4B726477D5F818B374639A40FDB856FFFB7107714C165A8083CACC1E7081A014152AC54FB26E00945A8E40B0FAFC2390AED553DB1FEE904C7424C5BD52B144A4946D095BA7DF481C66C0E22035F900B8A6D6BADBDEFA474414292249E5574DEDAB6F675C021DABC59B80FBC518D44330C259A5B070D089183CD54DB098F19C4998C42BF4D82028992837DE0060FD7F68D858BBDFDBB75EBD38388B5C6C7AC7875BD00A5EA5B72044A01C910856AB675585C68A4D3D1B2ED64B04ECE7506E475CEEDD7DD1E72B4290429C734894F29C24C047AD66E358D4C7A4E76B11F7189AE0D6CBDC0721A426D6BBBEE6B0C555BE0FFEC49B85E015A087629A1604439BBE219D55A1508178586D30261E603925DE5C0B0BDB9059A897B1C51B0141C85F6044373181447FCAD5158004953E8120B354C868E34F3395C1A18BC6DDBB2202CD01A3C0E'
    $sFileBin &= '400B44720348558372FED872D443F5E348BC407224C37F7AB606779A7A183BF90B7E4297A5705167D2A52E3D122DB17510A90A4BF0A74822046BE90B0468F51DA1150C111AE61D5A5C1668C030E690E02F56964A701765918031687784606CEEFE0458C90C3BBF029ADE1648813FA705D6D1863D3160DE8E115619503900CA05111786F1B259E3041CCB1304657A006C63022B7966636123BA1F8242B049367ED35101CBB0395DB0734F42B09241AE9271B1B073AF5DE0713D3601294E1E0471331B5BDE98CCB03386D38AC1B747C40CF80376058653CD5AE4E4CB711DB2A1746299600D5A5A6203037330015C1BD3D239C281BEF95B620311B003205D70E082064DC307C114E2A7047301F695C9CFA604195D4A0343895D9B90964CA7AF724A1900B9AC5D9573401420AF00D90561E329E4720583EE40F303EF04D0E263A899F27A56F9ADA2148CCE0283FA0DD468C73AC6DAB89401F8E4D31D03DCADB5813644055E17627F807DD30BEB1DD16594AA5A01DB497493B10F8451D9587713AD4591C03244B3EA06D4E182A43AA75833CCB7BEFB8D5C1B016509D64975AF69D48D5E01960C38D8F4DC73C913D4725B9BD8F6D8F25DDCC9119A8B3B5ED94FB408CD1319C0D7C9540962FD6740DAD5ADBE71B002A4B83975E8F5F204F0128D582BF81239C3766E57CB5599CED729C1070DBE09032B7D45BC01C1018B2DA8356DF2191E3B0D3075B7AD18AAFBCE7EC0019FB82CABAD2D0B1A2133C67FE212F0466F1688022975F5B675CDED3F52AC247258DC6689E2652A07B75F73065C5B54838EB0C9B95746140D42F817D1E59C2A55A0EB244C6D02FF61C9AB03F7D621759CEF85DBB6D0A219690DA0479C5C9CF82D362CA06E21DE2601C88D1C424C254C5865136E6A99B0DB83814E6613EB14DD22B295F7913E0B558332BD521EFCEF16EE2A299862F53E2C5B024DBCBECC0EF04E430517CBC1315511456E954DBA5858E0BB57168ADBAE013D29D654C1EEF1168632D2196054E0B86A74948706DFC05D25C0A1A1A34C0FE800DD88CB47DB6162410B1707890D1AC7B230CBFE0B7F1331094709320025129FE2252263F7C34BA68DE0615C724D11E05102212307C00CAB0008456CAE1C8CC8554286C140D8554D2690D70148071183D5B05264CAE07372CDB0407938DCCC750275D80E0BFD64577E30E8680AED4CCE608F4F37B210D0BBA7F9E83355B7F081C1D5A92B6402D9FD15582CB4499FB0A66402E4C83BC8D839DA46D48AD86F655397617D66C8ABE017A043E95D916E3B912555D0EBBFBAE2C6269703A611410D1646801C2DD5446ABCF8D8B841D03DDBC14BE7FA453A94B96E2475BADBB23B7165AC70541B4E6D6C23E3154F99411B71850C64874E370378272E794EB8BEB01DAD0A7C919A1C221001889421D782EF3635A432217D0CC648FB6690CA55FA87426BBE2990D1EF297DA8ABB7B619F7541FF6697001218DDE82055A0D83CB15C1E60421070B0E12FE44F30E0029F7398993460FA12F96031953E4B90E49383708EA83431530023900724BE300ECC0C0D47682484A2D01D8A9737D4691524B8C909372FF711AA306E635F98FCA6D820362357159CFE30E6109735D8704E64BE4C076079F2256C61E02D3E432A67F05B9CBC877163628015390413403EC921C081A570F90317BEA694148F643F0430A890F1819CF6F3430B14075506D70A2207540894D004B081079436D22684B74531B8259B050DC0057D53C4B2C3982C6AE418821CA088D3C74061C40658B9A4B0C388142B42BAB7BEC6118695939F028EAF05A41B0CFA06500F009C78678361EA14662C139C74410C6804BD002E76C81C22D157061DA04FEC2A7DE0C8A1FBF4B04637DC00560037F0BBF43249E60096E9C4DC49903BD14B441800D1848DA2B17B8E50702D8DC837DE46B4BD0D4E1533EEB109F82C60A168E4405775424DC9A87FD9DF1C553771EBEE5045D5FE61E491CBFB872BB8D6785168554F7348648767B0B4BA8B79F0AE06C5717CA213C770F19556D731244A31A048A22C10E2A607F95C43404D34B425F565160840FF07357FB8C58804663013D3758E12E32D85CC62FD860653A7902E3DCDCC84E080F0B7721A1738ADE70C8C836598FCCDCE1B0DD115B5C020412D0674C051E260CCF4F3B970F63B0C3734243F51D089B039003612548C2C68781DD4172BEEBF0CC88C2109586B9034F5E896A941EE8AD48BDDA443527958410BB6D6BEDCCE0870D7E82253F234A5E209C40D113033B84DF1BBA848CEBB4295D3AA695B9665D5C4E3A58369423C2598AAF996B90FDA201712C5D587589D63E4B374B39C205404B28D2C056D1688DA516AA66569A70D0182208C7BDA5DE363A189008D4C1F7D2210F6A0CCEE8817DD41FB9C0D8049B30517E2B3121DA09933D2AC8D5D9486195E022793902A0C3E5D8C4EBDB6177EB9725E198CD885966523CBC91FDE266957725FF8C160F4C642DC4F965729835D78E2A4DE826EC55DD908CECB950E05C070F3DA0216B462839EE3A3C3CD76A12A1625C3CEF61AFE9CF5BDCB2594B02A88B0C33613AB3D6A21CC8C8A901089C4C1E48CF765A07795B75D919B05FF37676ED8229B21793BDEBE943A293CE41C6991F7779E3D08C9AC40CB9B6DA420E19DFFBB588D3FB47D8901D5D0075A9295CEFC2F782440CED8601EB87372A4C5F588283EA407101A600D70F42E18A8ED1D248588E3A88D9745094DED683C80270A0E8499A010B68414B8D60980D9D0B83FDFAB141C6603D5077197A8BAD381B4DD2C186BBAFCCA8E12C45F734D0FEC39266DBC1AD5A0E96FB5DE5'
    $sFileBin &= 'A164AFE02D135D057B57A0DD5ED1EED2621F4821F0418B37B750FAC9B940639000FB24824FC36D4D5E24EFEDFD48B52F85C9C7404CD4068C88CFC84800587415AA55AAB32524505D2C82605B46070D8F8782070425742605B8082259BB3002BE289154B289E251705EECB6CF562253255FFD609C81E0B9F15FE23C8A1B1A2976759D1C817E5588CE66492001A03A824F7C7690CB484CD99C2BE256C696F00A6702912D24E0725058773C0FF1835017F675E5108844165C1405F702F08946587D5AC0E7D94A103B9F5676D3FBF76E2F59807A5C6B855A14840883C65C3C5E60E97656010346024F18A01009C2B04164EB0B030808344191118E45E6414C4441BB5FB46A1A7A7531F6D739507A1325FA24722C89C19BD60B8B7920667BAC236241601885F60A26BBD3354155DDEBBE758B595A823680508C5BA6106B100F14A0DC49ED9D6854F786970536070E4AA7882DE0D08C4F9F516EEE02252E9072F5378644014E4ECE4640063C383477B02ACEA25052425877CAF048C08A467DF0132B091C408DAF11FD36E806501409DA5AECAA0FB1DA21599E478956FBFD286705D4E3495C3F2E01B209E0823B7D20CF4118677033DC62069D1029CE63817A869F638BC32544CC25412005957B17800950C7069440E2102A4E16F6316C5BA18DFD13BB87C0933BB00434A0DFB72A9C0158C04BE10346872F340537EF43473688D383FB13DC26EA7DB1C0297A75E0C9C1B9CAC5136B7F5D8C84EB00BE59588D715C886116073BDB462F71C534C3756EB98D6A1F5570B9F703C452DBEE36A37FA412013E01D4295A1AADC7F769976158C3512D34AD3AB4D7CEFD04C8A0EC8FA8A37E1E83909CF2E05BB72DD557CCA56ACD0283857B748B90B9B584702B0202F7F1C35C430DFDCA6C317C857A9042D8756CFC5424968CDD7889A1EB8A6C02AE7DB3114504990D14B009373828DC623B4D272A83C05CDE90280CAFFDBCB6B5179E761C01580130458E033D7BA6574A6F966D6046000329E2750F6D816233FF38180D12839B196A0255C90B2E0A9F11B163D85FD089D34772D4DD178539F87206688D1C3EFECE51A5ADCB8DAAD70A8E6010B80C83612267EA0815525F6C946060A3B58D36011E843EEC26E06F0FB7AD582429F301D6FEB8DFE9DC29DF36320CCF015D4B084A9B7676E80149753F32ED53406BEEFF04977525298DB7B17A430624492839D6867CA559A75DAB9F9CB64CC3260B2805B0E80A8B602001AF0A930057EF5D773D736350B4D2FF52F90C4014A65AD8815B0F2F8B432D39B0142B140F118C248AFFC40720217CD6641CF690001793D1EBA396776372816FB804990456925B9FE25753DD8692D942029A4ACBF7EA9E01C10C03AC080418BD89A5289D0FEC6F894E0CD0D8FEEE422E1A80FBE0775B6608D3F62CD48003B4063C01DE622B2AC088089688C8C0B6AD7DD70D1DD100C828C306E2062695E2063079012889C2FA25778374C0EA7663460888D0C05CB4759BA1D02873C10E04FE848623D8ECB986BA1FACD305B1AF18D9A91E4244F18B328C786D347101F1794B2BB0E548C37F2984053973547427897C111CA01D613B3C2478365617891C95023EA41F107402E5C89545D056D0DF28334270F28D5DE8443F1C49089ABE57AC790A3BD743221EA16D656C22E14C7454E3AE068AD934B76CCEA3EE05F40C33E8B1322414BF386F02BB8CA0D8681475B50612C5F4FF2AD064CEDF7976E27F637FC119B4270A5E28741989FA1B64BB66708F4C252B04201D29899191672BA1D8DCE011869D91E4F4614C201CA49334B8EB667E9F72EF7B7C81ECB862B914AF9F8886446772C23EAD0CC58B589989925BAC42F1D91306763501189CED04F0288DAC0F88219F8D01BF1CFD18891485A4A0E665DC104FB38876B23D08894DF621010FD645A0223C893E1D304940D720100C210896F58E059B8D853AF2BEE904B45569BB24833A03749625FBBAC49CCB02A38EBF33F73A5AD8898F8CBBD6EBCDC09DBBB090008B2DB70333C0B58DE24D7F683CFF152310117B6427107CC31F8B4CFD89C8D09A8CD4055AFD8BB57651520301341A1C508901ECC93AD87B682C0DC35F6AFF5021275D617614C30F765F06508C2DBB7C2E8C04C38F13CCD63DD09A13F9068212446DC25F77183B07203C5EC3A99A860E2C6B09CF8FA9D84D446B149629C050519FC9205B371C1A049F02045BBEBB2D5E4C186A015119FC0C4DDB7D832DBF0091693408C32F37394A2E005CEFB6646C6C08518120EC4C2FC20A996C1F2425C5DC48481F0FEF590239CC73E8284F64ECBF770C1F33508B0251507900BFF796AD2FEFD3EF6A1CD9F91C20016A4CAF4BC0C647558BEC0E6816808FF4877704977064A1C15064892587EC085349140BF1565789651BFC7C141EB9B39F2C1096D58D7FB652332C0D5F5E5B8BE5D6C55E2C18A633220F8041B29425AFCF8D9841C74C5406C2D088250706DC3061108D316F5DB27FA338B429A60C5DB4AF8A30112B844DC13650F4FE29C83FA42985152CDB500802040CCFBAADE3B28F38D96089680659B6BF6E0D343F53043F0329D1093053DB680B5043FCD050FF169B8B7845F874395D11348463130AD7F819AF391FE6DAD66D6DF8D71E330C2E4215077E89AD1EC1083B434476B4CF8423D566D5E242EBF10F278813312F14A2EED5DA53406439827AD07BDBC92F374330720A408C16B19DEC6C034766EF4A30F23C29476F0B370A3D3B4244EE04E16BB397FF1F1BDC0D15C119DC0E392173065F5D002D017E306BACCF9E6C119E6DC7468606202C2023B70344B01B48044C1C817827'
    $sFileBin &= '5406CFDAB94049C04015FFFEFF02B076E2644AF7D281E22083B8ED31C24979EB96A58017339E6C43D300CE2F524227D51FEFE2203990202008B42F5C790374B8F6F084C06C915DED6D3C198B2C01E86780E61C908F1DBC8F1CC9D38186D0186337C452817F78F9D1E9128023C3036D0F2F98146F454194EDADF0C58D8C087A08DE5D68AD8838A38C01F21B53448D34C2AF231ABD4CD70D41733CC82DD68AF8488D7701B63FBDE04BC5915CF9026D74328D576C835CBD2B47B80206EEF7E5E40408D1EA81CA3781FA83E9EEFE96010B515328423D7607814904A149F3EC030B00010418A5D61C819E097C7BB12D50A97B8FFD603860B811B4A1B904735006020140ABD8BAD764AB02F5048E9A3A2755F1DCC1019AEA71F291C716F11EC1B73D8D0CB5B583E0BB01DDC8A639DA96008A205B28E696B8595B363B825314019A6B2493246F099BCA05D6C96DCDA6D90F3D8817773C741C5BE81D0C878622AF10016EAF237C89247FC6FE00B1EC97C5D06D6C31C95B82BBC2EF5FFA740723616E51BA37D929E6CF098E4CC212302E8C8AFF0C212816C045AD9904E8AD36E5BF4FF3F75BC239DA04DD78A9A7D38B790E414444B7412C4DF2CD0BE2094DB66123A102201D1C22DA96C00C8E10F91E78C29D61605E8B56E3667A48C5A31F014B60E132963A731AB120DFC730D4854854D14077F348D17698C62309681CF06B89CE38AD18394304DAB9229E30AC5A1ED76F8CC409D1C8EF1F100389762F855339F275731D2F4FB7CDFD049139D8770E9508421F72EF6E2979A870BFD80DEBF096FF18DA58DAD1D483786D7440466DBF5DCE2D465E042B394644742F0C183D723CB407145FF84F9F96D5599A8EFB14568F2650CC166172FE818EB5451BC2EBBCFF58588B5660F0B316167C647A4BE681E300FC5E562FD9F74620706CB46B8C25D483EC5070C02CEBB19F01682C22AF08E170D8000D5E3C8205A276D45F494E29F9828490DE535CEAAC4DE68387280C29DD5E60098FCB0F8D1487181476CC06BBD64118930C8B3A33248F5D468A4C2475B70E023803F70D76C675AD18135F452502221EB5B7FF06423B55F075EE393073898904536EB476A839073B0141FFA339FA8F26F083C204397310EE0B16D07361FF20C14F900986359F55450DE843D9724F808256FCE9B76DD18D58049EA08D98D07B0673247FE30D1AD375DFF3837DFD746E3B5D2073FB5670A66945CBBA0C1C8D3CC2D8EE9A6BB04D201B090757E429D91C758BD8A8E8E076034B77A65E2217B60C329BC73238C16DEBA8DB7465037349C775634F6CE5DCAEDC4DECE2077F04676DC8B9932DB80C6D759224D4B20D12CC07C728D114D6B5F7600F6131B27D02366CAAF6338B07B9FB726C2B0874C20BAD1D3A79883D0A74453785A5CAF62C73512E2C4B432CE0D6B9ED1683C67C06042889127449F175BB86405DA40C02351A44BFBFDD73CEBFB740474475BB5675EB9E6D10764A72B59F5D35751AC2042DF6233584C856DFD6D0A18F47620113FDAF513C2B064F4D101E4C90E35923AC7A506A51C150378A131B06638CBADC614F0629F1C78E8556C57E6A607365598E051CCB55C8546EC25741C3E1965DD809746E3BCE0E4B1B3B7BB619578845DADD9A80DB7A3806746C04733F0DB70005646B4FA64139C25D808D7D7604756A91A83DAC666975960F7BD03262C276377A02D7ED8043C05B75E8E416C7ED3D0E3BE473EE8FC66B787BA51CED751D4187AFDC49D837AC0BAA01AB02441B7691916D74E4A01C5D44743CB6A2A6846FC29640D6E2522BFDD304407AA33D8BD6E04204693E5770AC4B07F2153F387715FE61C027E80177168C74EC4E5775036A674F206427D78136031314C0D52A62D40CA9085B966E1BD9BF2420152C061C18C91F60691814CB4724895C49D107B83526F023BB7BD73D723CFF27C341FF0729C321C1FB02B74280966547470F704BE8E6DEA2C315EBE81F68854C60CF02A917BBB551025302CCD8CDA290DB6087D6CAE51000201376E7DF02141F1A63FF4C4B4610E6E0E34F40E80F86E5E83E0EC18BC834DB07C4578673103F0C71E1FF74CA4702D44D206A90C6EC310CF1776FFD56282104202B1C8A8B8C82B7B1B716B9B9A02DE4899C0F76BCDF05561C828B4E18BBF87176122E754B1CAB66C26638E7848E586A6A1EEF5C5D890C839A0F261A45F58AEFF21CC920CBC98B46467C4670885FB863135DE8E81176CBF3F5467D062229FBF5C846599646461DF44C72115AD4668BC5102D1F040B64BD70DA059468674F3B51D16F4DC3681C0F173BA9750743EBDC73BB421975F1FFCAC5AF4812DE26F7B4891A1008E30E774EBB6C72F2C5B0BE100CB7F740B8E846DF94E4B67158736673BC13B4AC0A5A16EC8B234BB29910CDD2B0045FBF7D4703B1B69A23F5011708E075282C978512C2415C97D813978D23947FC25DD8A551E208D8721B9731B7F2D7DC23A34FD32CDC584244AE89CED00557C2DB87CB57349AC675F0172BB49AC811B1ED21CF04448C06118ADBCB38A9225DE436500582DF8CB22531F63D0FA99ABA6239576BB581741BCF43ECA539C076168B9CFA015DE8A2184596D1BFA29DA0417725E72259784368A2037FCF820B4BFCE52EEE041E5CB0F862854E4EC67A212414100C0F001F742EE07447B55C1B0975251320432CB6601882EDE365786FE7607A84393629CA79AA07314696C835F0C4EC080DAF44480E09ADBE9A388C6F3C7929836E7705BB03CE4D8397C8EACBB1C1AABA1E3DAC57C8C475E4C067062CE7A4AAC775221903560990C71BD12717C66B95CFF8DC0907C50C7C'
    $sFileBin &= '9087E45AA9C46D4863B2046DC3DD12E0C3FAB04CFAF0EBB56FC8858C115F3CCB32944C059333170F915C9D7567FF931C87860E2A57D1E4AEDEC864343836971F39E99531AB857F3CC33D989047C9577B891C13198F1109B22FDA4D8E17932C4C552B35A3E102C9716CA43835C983900B3C7BAC0A89B32B8F7C132F6A16FA9696178B5F20E64800AEB5152C7BAC5485AF12EDC483317034F32EA38473C88B1C0E25B420B807050D9E096104B20807FFD283EDCC1C3BEB0AC64E74750ECBC1363101CC76EBC342010A086CE62261B3A3D8032CC7118975978B0CAA133C4E75900FDF63C860239F0E89AD3CDF6181B6A302E79C2797D050E002645CD957654B70BC67B3839223EC248090AF2CA29D01B9B1EC96949066E97E0252872C0C75B0530FAE0254795BBCAAE75794B26A8121912D27F081C9F5D100B96C4CC9ECCC362C1617CD0D5E04B285A40FDF2C3AB31C72D103E8C21138DA062498C2EE2822671B904F9B55F0CAEEECC39148129D9B21D8B42B532436F28386ED3A6BEF32B68C93F8550C932A1512E40A84581F05E8C09B900B3F380D6D8EB0203FFF0CEB7FB26C9B0A5FDF7728E81040BD9535CD4CC80FE7DF7021C9B6EBDAE220D50421F8101BBBE8B481E29406D59499D3916847E614811F3934906C129FBEDD17B44042B017D123FF724BC4A58A287F1027798DD81D66BD851575EA6116064D58E3D41FA45E99CBBF4C9FD252276D8F438915743BF2D56F60A60E3491CF918F0B98A77B8E8C1F1205B04047326088EED80DB04093BF45B850E5701A311600BE6B59059BADD9080880060C50757E506D2868077AE02F811097823E292F8B52482E741839566805A60421788023C79C19805F1275107D44478E95E00F76C07F30411503827F5FC9C9D9907B1006141881CEC9C91C2024DFA8C8570B5E10FB150DEAD96E4B495E1809EA9C6C6F0422060C08F2CDE24FBF69AC8D461CF80A1459BECD0D8C1D383015CC24C5D99E3D6A7C3397545A2CE622552F8D8D65F89F2D1D62EED70E5AFF781946202669010CC0CE3D6C48501D80907F9616006E27E07EDC5E489D74E5B6AAA5F4041D6DCF7425800F13562CA35D20C161CB0C7E6BD5CCB0A27EBB5D433B9174298D7E24EF9E2D3B1B3C898B332875E52A21C5D957040FD9649BB0FF46EC04E32DB04DBCC19A841DBFB614DBCE353E46108214B854094DB667DD28067D8269DC4D18C9205CF20A1C20388C482B6B718CC48C557136778AC786BC08604F168E0375349510689C0764B9ECD8BC7C7483C24E2821E9C106CF968CEBC2AFE06A5950BF71A22BC0CB9058F94E11C23F96B9A7930F4330BE0CFC217BD65D9C24178284AC2CBAC318E1C743286F437D7CBAD3409601D90E18C41C0EB03968B56F1220DEA2C569CE16EC9EF5A10DD876391C24188563D367B3C01472B823109D119427685C730308D98FE02672859BFF8480D88932466F180474B07C1C7585F875A3F1EB2EB489CF6280569789433BC641C72B9A8037F72B3C905138B475CD1140C70A7F4E930D56BC799775D0A3664F0CCDD1B33C4D5D40CA319EF80F9420BF0133148789DF8E4161BB131786EC43905C142161B0618D0CECBEFB5FDE480EE404485D6CEE1FC45826418B04874D680514D09682202B52EBDA12DD570783C74089091E4367B294141CB6588FCF6CD902B94971D8316400E410B58F5F35240F3C95080552C4224CC481C257AF6EC63A13A2164010DC83C25C0931762B75055810E45F10CCEA80B71436AF5E41C0A00C36C283805BC17A08B4858D3CDB3DA8E50C85D66FB078459AA321D19AB2598C86E8F547E239ECA4C548F4DC0D0A7E4CDDB013353AC37B11A029B0DE7705DD291A299A18516399C3C65A1742140DF0106C089E8C84734C65F402AE8020C8A5622AEE3A1B8E8C093DFFDF44CD229A70994E746B512D8F5EA4058AF814A96FFFF6E707C1E70F7701CFC707F7DFB6686B0C3248DB4F138D5B0181C06B00E0FBFE1FF5BB06135F6D2D2514386C138D728D18790869285C904713C251B46BBB019B1BDC068A1DFF9074011F586DA95CF4EE1EA3CDF70CDA746C65887C4F5E58B1E801B144299A588D076FD6BDA05C40505D92766E16BD60C9653E894316800F39108A424811C085A4EFB0238C595BBF93F06C40BE04285B830187871B9B8370C48B0A2ED085124B0BE00D7983FC425D24000A1A0300177AE5EF8993088D5002173881045246C36C1B04F47F40538029DF1D4060300238CAB786B5F619F1A9C301C0291F11B45534E23FC20539CB5EAB6A773E61AF7D67407432FC3D867C39BEBD6FA108ECAAA9964AC6D88BBE14D1A2D771D6964A93ABF8ADC0BB48FB8B8E1C014F4AC018F1770397895EDEE66E85221A73031F4E203F2C59EBA8F3D4161585B6A02F1AE6F9E4F7FF4E76F3DC6ED90018EB2090150E0102DC6BC39C684AA25D19A219B8DB7C0986280D34454D485E24F3016FFB07201124264ED4AAB3353E7C4C481708DCB3456CE1F947721055F0BD08B61F8B2B0C90B7406C0A42BCE26CD29FA2B2D55699EDC1BD01E0BA919A92862A13C240C361667ACCBC100F824A1AA22148803B3C8B9E30AB4F106DED843EF84946F03D8A98DBEEDC399D28E987ADCB44A02755AA964E8133B709205465FEEBAC05235C9C0A8164B64EBAA54AEB9E808A90BEC2E157C418B901F8F2FB555C88303B2872FBFD028F5A3063618B10575D9D1D888B4C41914A18D9B316DB9575DE772081D08C3F2F407504606F16BEEE377DF402470F3E3083E33FC1E31098A2D70ED201C3648A9C6AB1A29ADDB641BF87775E2B86A243C2492F'
    $sFileBin &= '580F59685991B747EBA89366C266861F5A00753D2161492989D36DC097553322D8029F292037A8083F2F8D63EA5B26487F7B408D5F2C17A66A3B3C474405288FE021874004B6ECEB2A81461385FAFC32881598C5522CEA46E1DD96ACD6AC17892908F7CF01EB8750E973488D8726E0B02D8BEC7E568F0F472B580F1F5116B19533FAAC5783C32C78822212AFAB1920E90ADF09C1BB8C9F833086205601227B80328A0987876F6F3BB4ACE7080CB74390A2DAA159674E1B08921D10F2EB943FAA428F3D8825881CC9172EA20D8C8F0E4143C133456B6F5F430E966478FE368DFC4BC01B087FC1188700EF5BAC7889A45720BA05CFA20D16782440026F3F0086D736846920D3566DD98A32366D20C603825CC48311460B442457E157FFF7050F0E7C6904C9E6706B3859577422ADBA078F30151C5E9D90BEBCC50061F86CFE857437B56C20279397441C8A3FD8007774D6A6E347398FB9F2DD7014A2A7BB40505C8DE0C5BE6450554F36008784046F2F1D8EC1E16190198BB3004E01C4C0172D3B24F192FA06088E6FFCECCE02B680792096402313502A0596E0138DC041D8B951EDD4458D89AC830E08195946961C0C481004D946B6671406101814081C0365641918202C67503029809E03DA63E12FC52C7EB3EF842209C40FE3F1501D5A7E28682039D3C1546BF081A74859C1E3A08A3FC42692F1ED793C43746696260A5A363F0EFBF44D14825C30817B10FEBF243ED110F70C345308316958C15BFC770A59661C839871A45B913CEF8F0E8260296F06125BA968587F405A6F31D8B35A4B917C159057865506BFBBB51B811CB9254932502F8DB65F7D308B5818C75024360E96DC101D9746048A8625388B0C83D0880D6E8E833BD872175DFD12B07BCA6E29DA380416EFF8132A352429EF3F17A92E531A904823232480993928254F6CCFB972148F89988948B354B76D11789140891E20561E550A5C9890234A80213EA9FC149925083D3B294C4388BC063C990EDCCDD5FB39FEBC720DAE50182AD3DB29F9AC0E7449AFF5F625CC5482B52455D1216A80CCFA37102102BA43105A2BF096EAAA6A6AC710022B0451E0005810F3FDCF41D797D01848C79B38440E0274199DDBDC8B3BFC693E086C4172A15850899003B899728D2CFA08EB84EF4A1A86165D518B57EF292A01B0F025F18B31FF4F6FC17B296A6F25320189173B178B010FCDED169A7F040309C3040C095E7829700771E5FF47C6F0FF07A126A400BF0C3F6D0168DB02574401132AB889566E4C44101147D6754F1B0FD58D398D42CD478E0F660DAB60414A84E46A84A17E8B1D1B45A22A1F94E2C6B7FD9873291D2A29C65BC1FE8FF031F2B987B9AE3453043734D0C24B081DC2CFB549FB172BB8064B0907EE0275E795102CEB74EBA29F5DA5B67DC9D733EB1BFF4B5C43498B5AA02EB4FFFB1B01CA114EA44B4B44649F3B5975E0027A81B537272F2A75D5C0215E412F175F58962D259F705D463791A569038856050F47579C0AC056105E08055D17C45B8D13FF4610D4062C8B7E03BAC53C82CB404BBC742F3B460C0AD4842E315658B4C85CF71658B6294C04342E7A76487175D18D34BEEBC427CD944DFF8F554657273D014D0B880AD1055641051C9310A502D98A469BAD21F2B68801B20C99AD0CC8612F25CF02982EAD0A12C95A9FCC95EE3855B3DCFE9080C71555D100B8069220FD5DA266FBD091F0060CE06B74342068D0AE0B98942097DB881DDCCE4954AB87B0C70508210CB0C07283250AA3B86C5D3FD0291495E0D00BB23BC49B2286901B591238F694E04C93D04F3965B625DF4028E0445064EC56F1FFFF88A050054C64646464480C0804766C2C7640CC000B3405380000005B5104031162A62007322403C80A00082403C8400B00ADB24032093FD334CD950B010203042FB0254D0506330203419EB3ED0405060207000A0040A0BB99FF056AF103F7540564290811A00A1905FEFF97675CA00152656C6561736553656D6170686F7265DBF67F5B4C0F7665437269746963616C1763076FEBA6E4B76E15456E746572443D742C00DAB62B47144C5474F66DBB3DF20D57611E460853696E672DDAB737F74F626A2514436C6F7548616E64126D6BDBE60C776146457664413D96EC8B95530A9C730B236E6E976CA727496E7675697AF634DBC880DE694866296BDBB6B95F336C6E630770274AB1FFE76C661E345F6578636570745F6888EEAEDDDC72332A606D6F711A6265672D673CD6BA6876642518637079B28F6FDBFFFF0757076DF09A17F03505F0F902F06901F0D402050B7204196DEDFFFF35F0B90261BBF00705D1F0D302ECF0B101C2181C193DFDFFFFB61F6228FE03F0B31C3522453982204733730528F08B170709FDF6DFDD011B070C05F0340D65F03F06070A0D0D090D070F4BFF63BF0210050D0D06000C06F00C0A040050453D4CCDFF43FE010300448DAF4BE0000E210B01050C0098081B699A27801110B0100B6E166C19020433070CC0CEDC92D01E341007CB66E9D906A0B3D66E8CB15040B21C24C0F01706B26EA7581E2EF9787436B0C176077C979098C40267DBF87220602E726424611B0E7317D27DFB06279C40022763939B636510B32A01FCA2CDED376527421B34B2103EC1B7000000700400240000FF00000000000000000000000000807C2408010F85B901000060BE009000108DBE0080FFFF57EB109090909090908A064688074701DB75078B1E83EEFC11DB72EDB80100000001DB75078B1E83EEFC11DB11C001DB73EF75098B1E83EEFC11DB73E431C983E803720DC1E0088A'
    $sFileBin &= '064683F0FF747489C501DB75078B1E83EEFC11DB11C901DB75078B1E83EEFC11DB11C975204101DB75078B1E83EEFC11DB11C901DB73EF75098B1E83EEFC11DB73E483C10281FD00F3FFFF83D1018D142F83FDFC760F8A02428807474975F7E963FFFFFF908B0283C204890783C70483E90477F101CFE94CFFFFFF5E89F7B9D40100008A07472CE83C0177F7803F0375F28B078A5F0466C1E808C1C01086C429F880EBE801F0890783C70588D8E2D98DBE00C000008B0709C0743C8B5F048D843000E0000001F35083C708FF963CE00000958A074708C074DC89F95748F2AE55FF9640E0000009C07407890383C304EBE16131C0C20C0083C7048D5EFC31C08A074709C074223CEF771101C38B0386C4C1C01086C401F08903EBE2240FC1E010668B0783C702EBE28BAE44E000008DBE00F0FFFFBB0010000050546A045357FFD58D87EF01000080207F8060287F585054505357FFD558618D4424806A0039C475FA83EC80E9272EFFFF00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000005CF000003CF0000000000000000000000000000069F0000054F00000000000000000000000000000000000000000000074F0000082F0000092F00000A2F00000B0F0000000000000BEF00000000000004B45524E454C33322E444C4C006D73766372742E646C6C0000004C6F61644C69627261727941000047657450726F634164647265737300005669727475616C50726F7465637400005669727475616C416C6C6F6300005669727475616C46726565000000667265650000000000000000448DAF4B000000000EF10000010000000300000003000000F0F00000FCF0000008F10000E2100000411100006B10000017F100001FF100002EF100000000010002006C7A6D612E646C6C004C7A6D61446563004C7A6D6144656347657453697A65004C7A6D61456E6300000000E000000C0000009D3100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000'
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 1, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 2, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Lzmadll ()

Func Scissorsico ( $sFileName, $sOutputDirPath, $iOverWrite=0 )
    Local $sFileBin = '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'
    $sFileBin &= '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'
    $sFileBin &= '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'
    $sFileBin = Binary ( _Base64Decode ( $sFileBin ) )
    $sFileBin = Binary ( _LZMADec ( $sFileBin ) )
    If Not FileExists ( $sOutputDirPath ) Then DirCreate ( $sOutputDirPath )
    If StringRight ( $sOutputDirPath, 1 ) <> '\' Then $sOutputDirPath &= '\'
    Local $sFilePath = $sOutputDirPath & $sFileName
    If FileExists ( $sFilePath ) Then
        If $iOverWrite = 1 Then
            If Not Filedelete ( $sFilePath ) Then Return SetError ( 2, 0, $sFileBin )
        Else
            Return SetError ( 0, 0, $sFileBin )
        EndIf
    EndIf
    Local $hFile = FileOpen ( $sFilePath, 16+2 )
    If $hFile = -1 Then Return SetError ( 3, 0, $sFileBin )
    FileWrite ( $hFile, $sFileBin )
    FileClose ( $hFile )
    Return SetError ( 0, 0, $sFileBin )
EndFunc ;==> Scissorsico ()