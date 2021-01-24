#include <GDIPlus.au3>
#include <GuiComboBox.au3>
#include <File.au3>
#include <Array.au3>
#include <WindowsConstants.au3>
#include <GuiConstantsEx.au3>
#include <ButtonConstants.au3>
#include <Array.au3>
#include <Winapi.au3>
#include<Misc.au3>
#include <Process.au3>
#include <StaticConstants.au3>
#include <GuiConstants.au3>
#include <ScreenCapture.au3>
#include <Constants.au3>

Global Const $AC_SRC_ALPHA = 1


; Load PNG file as GDI bitmap
_GDIPlus_Startup()
$pngSrc = @ScriptDir & "\LaunchySkin.png"
$hImage = _GDIPlus_ImageLoadFromFile($pngSrc)

; Extract image width and height from PNG
$width = _GDIPlus_ImageGetHeight($hImage)
$height = _GDIPlus_ImageGetHeight($hImage)

_ImageResize(@ScriptDir & "\LaunchySkin.png",@ScriptDir & "\LaunchySkin2.png",300, 70)
$hImage = _GDIPlus_ImageLoadFromFile(@ScriptDir & "\LaunchySkin2.png")
$width = _GDIPlus_ImageGetHeight($hImage)
$height = _GDIPlus_ImageGetHeight($hImage)

$GUI = GUICreate("", 100,100, 500, 500, $WS_POPUP, $WS_EX_LAYERED)
WinSetOnTop($GUI, "", 1)
SetBitmap($GUI, $hImage, 155)
GUISetState()
$controlGui = GUICreate("ControlGUI", $width, $height, 0, 0, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_MDICHILD), $GUI)
GUICtrlCreatePic(@ScriptDir & "\grey.gif", 0, 0, $width, $height)
GUICtrlSetState(-1, $GUI_DISABLE)

$a = _ProcessGetIcon(_ProcessGetName (WinGetProcess ("Speed Dial - Opera")))
        GUISetIcon($a)
        
$Icon = GUICtrlCreateIcon('', 0, 25, 30, 32, 32)
$Icon2 = GUICtrlCreateIcon('', 0, 60, 30, 32, 32)
SetIcon($Icon, 0x373737, $a, 0, 32, 32)
SetIcon($Icon2, 0x373737, $a, 0, 32, 32)
GUISetState()
While 1
    $msg = GUIGetMsg()
    Select
        Case $msg = $GUI_EVENT_CLOSE
            ExitLoop
    EndSelect
    sleep(200)
WEnd
GUIDelete($controlGui)
;fade out png background

; Release resources
_WinAPI_DeleteObject($hImage)
_GDIPlus_Shutdown()


; ====================================================================================================




func SetIcon($controlID, $iBackground, $sIcon, $iIndex, $iWidth, $iHeight)
    
    const $STM_SETIMAGE = 0x0172

    local $tIcon, $tID, $hDC, $hBackDC, $hBackSv, $hBitmap, $hImage, $hIcon, $hBkIcon

    $tIcon = DllStructCreate('hwnd')
    $tID = DllStructCreate('hwnd')
    $hIcon = DllCall('user32.dll', 'int', 'PrivateExtractIcons', 'str', $sIcon, 'int', $iIndex, 'int', $iWidth, 'int', $iHeight, 'ptr', DllStructGetPtr($tIcon), 'ptr', DllStructGetPtr($tID), 'int', 1, 'int', 0)
    if (@error) or ($hIcon[0] = 0) then
        return SetError(1, 0, 0)
    endif
    $hIcon = DllStructGetData($tIcon, 1)
    $tIcon = 0
    $tID = 0

    $hDC = _WinAPI_GetDC(0)
    $hBackDC = _WinAPI_CreateCompatibleDC($hDC)
    $hBitmap = _WinAPI_CreateSolidBitmap(0, $iBackground, $iWidth, $iHeight)
    $hBackSv = _WinAPI_SelectObject($hBackDC, $hBitmap)
   ; _WinAPI_DrawIconEx($hBackDC, 0, 0, $hIcon, 0, 0, 0, 0, $DI_NORMAL)
    
    _GDIPlus_Startup()
    
    $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
    $hBkIcon = DllCall($ghGDIPDll, 'int', 'GdipCreateHICONFromBitmap', 'hWnd', $hImage, 'int*', 0)
    _GDIPlus_ImageDispose($hImage)
    
    GUICtrlSendMsg($controlID, $STM_SETIMAGE, $IMAGE_ICON, $hBkIcon[2])
    _WinAPI_RedrawWindow(GUICtrlGetHandle($controlID))
    
    _GDIPlus_Shutdown()
    
    _WinAPI_SelectObject($hBackDC, $hBackSv)
    _WinAPI_DeleteDC($hBackDC)
    _WinAPI_ReleaseDC(0, $hDC)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteObject($hIcon)

    return SetError(0, 0, 1)
endfunc; SetIcon

Func SetBitmap($hGUI, $hImage, $iOpacity)
    Local $hScrDC, $hMemDC, $hBitmap, $hOld, $pSize, $tSize, $pSource, $tSource, $pBlend, $tBlend

    $hScrDC = _WinAPI_GetDC(0)
    $hMemDC = _WinAPI_CreateCompatibleDC($hScrDC)
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    $hOld = _WinAPI_SelectObject($hMemDC, $hBitmap)
    $tSize = DllStructCreate($tagSIZE)
    $pSize = DllStructGetPtr($tSize)
    DllStructSetData($tSize, "X", _GDIPlus_ImageGetWidth($hImage))
    DllStructSetData($tSize, "Y", _GDIPlus_ImageGetHeight($hImage))
    $tSource = DllStructCreate($tagPOINT)
    $pSource = DllStructGetPtr($tSource)
    $tBlend = DllStructCreate($tagBLENDFUNCTION)
    $pBlend = DllStructGetPtr($tBlend)
    DllStructSetData($tBlend, "Alpha", $iOpacity)
    DllStructSetData($tBlend, "Format", $AC_SRC_ALPHA)

    _WinAPI_UpdateLayeredWindow($hGUI, $hScrDC, 0, $pSize, $hMemDC, $pSource, 0, $pBlend, $ULW_ALPHA)
    _WinAPI_ReleaseDC(0, $hScrDC)
    _WinAPI_SelectObject($hMemDC, $hOld)
    _WinAPI_DeleteObject($hBitmap)
    _WinAPI_DeleteDC($hMemDC)
EndFunc   ;==>SetBitmap


Func _ProcessGetIcon($vProcess)
    Local $iPID = ProcessExists($vProcess)
    If Not $iPID Then Return SetError(1, 0, -1)
    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If Not IsArray($aProc) Or Not $aProc[0] Then Return SetError(2, 0, -1)
    Local $vStruct = DllStructCreate('int[1024]')
    Local $hPsapi_Dll = DllOpen('Psapi.dll')
    If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@SystemDir & '\Psapi.dll')
    If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@WindowsDir & '\Psapi.dll')
    If $hPsapi_Dll = -1 Then Return SetError(3, 0, '')
    DllCall($hPsapi_Dll, 'int', 'EnumProcessModules', _
    'hwnd', $aProc[0], _
    'ptr', DllStructGetPtr($vStruct), _
    'int', DllStructGetSize($vStruct), _
    'int_ptr', 0)
    Local $aRet = DllCall($hPsapi_Dll, 'int', 'GetModuleFileNameEx', _
    'hwnd', $aProc[0], _
    'int', DllStructGetData($vStruct, 1), _
    'str', '', _
    'int', 2048)
    DllClose($hPsapi_Dll)
    If Not IsArray($aRet) Or StringLen($aRet[3]) = 0 Then Return SetError(4, 0, '')
    Return $aRet[3]
EndFunc

Func _ImageResize($sInImage, $sOutImage, $newW, $newH)
    Local $oldImage, $GC, $newBmp, $newGC
    _GDIPlus_Startup()
   ; Load Image
    $oldImage = _GDIPlus_ImageLoadFromFile($sInImage)
   ;Create New image
    $GC = _GDIPlus_ImageGetGraphicsContext($oldImage)
    $newBmp = _GDIPlus_BitmapCreateFromGraphics($newW, $newH, $GC)
    $newGC = _GDIPlus_ImageGetGraphicsContext($newBmp)
   ;Draw
    _GDIPlus_GraphicsDrawImageRect($newGC, $oldImage, 0, 0, $newW, $newH)
    _GDIPlus_ImageSaveToFile($newBmp, $sOutImage)
   ;Clenaup
    _GDIPlus_GraphicsDispose($GC)
    _GDIPlus_GraphicsDispose($newGC)
    _GDIPlus_BitmapDispose($newBmp)
    _GDIPlus_ImageDispose($oldImage)
    _GDIPlus_Shutdown()
EndFunc  ;==>_ImageResize