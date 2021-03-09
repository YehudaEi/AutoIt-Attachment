; Identicon.au3 demo.
AutoItSetOption('MustDeclareVars', 1) ; Best practice.
#include <GUIConstantsEx.au3> ; Uses $GUI_EVENT_CLOSE, for demo only.
#include <Crypt.au3> ; Uses _Crypt_HashData, for demo only.
#include <WinAPI.au3> ; Uses _WinAPI_DeleteObject, for demo only.
#include <Identicon.au3>

Global Const $IMAGE_BITMAP = 0 ; Needed for GUICtrlSendMsg.
Global Const $STM_SETIMAGE = 0x0172 ; Needed for GUICtrlSendMsg.

Global $sScript = FileRead(@ScriptFullPath)
Global $bHash, $hPic, $hIdenticon, $sIcon, $hGUI

$hGUI = GUICreate('Identicon demo', 256, 448)

; Create a temporary BMP from a timestamp to use as icon for the GUI.
$bHash = _Crypt_HashData(@YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC, $CALG_MD5)
$sIcon = _Identicon($bHash, -1, BitOR($IDENTICON_BMP, $IDENTICON_TRANSPARENT), @ScriptDir)
GUISetIcon($sIcon)

; 3x3 standard identicon.
$hPic = GUICtrlCreatePic('', 0, 0, 64, 64)
GUICtrlSetTip($hPic, 'Standard identicon.')
$hIdenticon = _Identicon('5BE6954DEFC0D2D4B3CE88965C280D16')
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 standard identicon.
$hPic = GUICtrlCreatePic('', 64, 0, 64, 64)
GUICtrlSetTip($hPic, 'Standard identicon.')
$bHash = _Crypt_HashData(@IPAddress1 & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 standard identicon.
$hPic = GUICtrlCreatePic('', 128, 0, 64, 64)
GUICtrlSetTip($hPic, 'Standard 4x4 identicon')
$hIdenticon = _Identicon('5BE6954DEFC0D2D4B3CE88965C280D16', 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 standard identicon.
$hPic = GUICtrlCreatePic('', 192, 0, 64, 64)
GUICtrlSetTip($hPic, 'Standard 4x4 identicon')
$bHash = _Crypt_HashData(@UserName & @YEAR & @MON & @MDAY & @HOUR & @MIN & @SEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; Two identical 3x3 identicons.
$hPic = GUICtrlCreatePic('', 0, 64, 64, 64)
GUICtrlSetTip($hPic, '3X3 identicon for this file.')
$bHash = _Crypt_HashData($sScript, $CALG_MD5)
$hIdenticon = _Identicon($bHash)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

$hPic = GUICtrlCreatePic('', 64, 64, 64, 64)
GUICtrlSetTip($hPic, '3X3 identicon for this file, for comparison.')
$hIdenticon = _Identicon($bHash)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; Two identical 4x4 identicons.
$hPic = GUICtrlCreatePic('', 128, 64, 64, 64)
GUICtrlSetTip($hPic, '4x4 identicon for this file.')
$bHash = _Crypt_HashData($sScript, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

$hPic = GUICtrlCreatePic('', 192, 64, 64, 64)
GUICtrlSetTip($hPic, '4x4 identicon for this file, for comparison.')
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; Two different 3x3 identicons from hash strings with 2 bytes of difference.
$hPic = GUICtrlCreatePic('', 0, 128, 64, 64)
GUICtrlSetTip($hPic, 'identicon from hash A, compare to B.')
$hIdenticon = _Identicon('3C97A5B93A71B12680EBB23D67D5E693')
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

$hPic = GUICtrlCreatePic('', 64, 128, 64, 64)
GUICtrlSetTip($hPic, 'identicon from hash B, compare to A.')
$hIdenticon = _Identicon('3C97A5B93AA0B12680EBB2B767D5E693')
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; Two different 4x4 identicons from hash strings with 2 bytes of difference.
$hPic = GUICtrlCreatePic('', 128, 128, 64, 64)
GUICtrlSetTip($hPic, '4x4 identicon from hash A, compare to B.')
$hIdenticon = _Identicon('E5DAAA90C369ADFD156862D6DF632DED', 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

$hPic = GUICtrlCreatePic('', 192, 128, 64, 64)
GUICtrlSetTip($hPic, '4x4 identicon from hash B, compare to A.')
$hIdenticon = _Identicon('E5DAAA90C369ADFDA06862D6DF362DED', 64, $IDENTICON_4X4)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 identicon with rotation.
$hPic = GUICtrlCreatePic('', 0, 192, 64, 64)
GUICtrlSetTip($hPic, '3x3 identicon with rotation.')
$bHash = _Crypt_HashData(Random() & @AutoItPID & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_ROTATE)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 identicon with rotation and border.
$hPic = GUICtrlCreatePic('', 64, 192, 64, 64)
GUICtrlSetTip($hPic, '3x3 identicon with rotation and a 1 pixel border.')
$bHash = _Crypt_HashData(Random() & @WorkingDir & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_ROTATE, $IDENTICON_BORDER))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 Space Invader identicon with rotation.
$hPic = GUICtrlCreatePic('', 128, 192, 64, 64)
GUICtrlSetTip($hPic, '4x4 Space Invader identicon with rotation.')
$bHash = _Crypt_HashData(Random() & @UserProfileDir & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_SPACE_INVADER, $IDENTICON_ROTATE))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 checkerboard identicon with rotation and border.
$hPic = GUICtrlCreatePic('', 192, 192, 64, 64)
GUICtrlSetTip($hPic, '4x4 checkerboard identicon with rotation and a 1 pixel border.')
$bHash = _Crypt_HashData(Random() & @UserName & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_CHECKERBOARD, $IDENTICON_ROTATE, $IDENTICON_BORDER))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 checkerboard identicon.
$hPic = GUICtrlCreatePic('', 0, 256, 64, 64)
GUICtrlSetTip($hPic, '3x3 checkerboard identicon.')
$bHash = _Crypt_HashData(Random() & @IPAddress1 & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_CHECKERBOARD)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 Space Invader identicon.
$hPic = GUICtrlCreatePic('', 64, 256, 64, 64)
GUICtrlSetTip($hPic, '3x3 Space Invader identicon.')
$bHash = _Crypt_HashData(Random() & @AutoItExe & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_SPACE_INVADER)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 checkerboard identicon.
$hPic = GUICtrlCreatePic('', 128, 256, 64, 64)
GUICtrlSetTip($hPic, '4x4 checkerboard identicon.')
$bHash = _Crypt_HashData(Random() & @IPAddress1 & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4x4, $IDENTICON_CHECKERBOARD))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 Space Invader identicon.
$hPic = GUICtrlCreatePic('', 192, 256, 64, 64)
GUICtrlSetTip($hPic, '4x4 Space Invader identicon.')
$bHash = _Crypt_HashData(Random() & @AutoItExe & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4x4, $IDENTICON_SPACE_INVADER))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 checkerboard identicon with transparency.
$hPic = GUICtrlCreatePic('', 0, 320, 64, 64)
GUICtrlSetTip($hPic, '3x3 checkerboard identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @SystemDir & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_CHECKERBOARD, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 Space Invader identicon with transparency.
$hPic = GUICtrlCreatePic('', 64, 320, 64, 64)
GUICtrlSetTip($hPic, '3x3 Space Invader identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @ScriptName & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_SPACE_INVADER, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 checkerboard identicon with transparency.
$hPic = GUICtrlCreatePic('', 128, 320, 64, 64)
GUICtrlSetTip($hPic, '4x4 checkerboard identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @WindowsDir & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_CHECKERBOARD, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 Space Invader identicon with transparency.
$hPic = GUICtrlCreatePic('', 192, 320, 64, 64)
GUICtrlSetTip($hPic, '4x4 Space Invader identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @ScriptFullPath & @MSEC, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_SPACE_INVADER, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 SHA1 identicon.
$hPic = GUICtrlCreatePic('', 0, 384, 64, 64)
GUICtrlSetTip($hPic, '3x3 SHA1 identicon.')
$bHash = _Crypt_HashData(Random() & @SystemDir & @MSEC, $CALG_SHA1)
$hIdenticon = _Identicon($bHash)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 3x3 SHA1 Space Invader identicon.
$hPic = GUICtrlCreatePic('', 64, 384, 64, 64)
GUICtrlSetTip($hPic, '3x3 SHA1 Space Invader identicon.')
$bHash = _Crypt_HashData(Random() & @ScriptName & @MSEC, $CALG_SHA1)
$hIdenticon = _Identicon($bHash, 64, $IDENTICON_SPACE_INVADER)
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 SHA1 checkerboard identicon with transparency.
$hPic = GUICtrlCreatePic('', 128, 384, 64, 64)
GUICtrlSetTip($hPic, '4x4 SHA1 checkerboard identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @WindowsDir & @MSEC, $CALG_SHA1)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_CHECKERBOARD, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

; 4x4 SHA1 Space Invader identicon with transparency.
$hPic = GUICtrlCreatePic('', 192, 384, 64, 64)
GUICtrlSetTip($hPic, '4x4 SHA1 Space Invader identicon with transparency.')
$bHash = _Crypt_HashData(Random() & @ScriptFullPath & @MSEC, $CALG_SHA1)
$hIdenticon = _Identicon($bHash, 64, BitOR($IDENTICON_4X4, $IDENTICON_SPACE_INVADER, $IDENTICON_TRANSPARENT))
_WinAPI_DeleteObject(GUICtrlSendMsg($hPic, $STM_SETIMAGE, $IMAGE_BITMAP, _GDIPlus_BitmapCreateHBITMAPFromBitmap($hIdenticon)))

GUISetState(@SW_SHOW)
While True
    If $GUI_EVENT_CLOSE = GUIGetMsg() Then
        GUIDelete($hGUI)
        _WinAPI_DeleteObject($hIdenticon)
        ExitLoop
    EndIf
WEnd

; Create a 128x128 pixel transparent png identicon and open it with ShellExecuteWait.
$bHash = _Crypt_HashData($sScript, $CALG_MD5)
$hIdenticon = _Identicon($bHash, 128, $IDENTICON_TRANSPARENT, @ScriptDir)
ShellExecuteWait($hIdenticon)

; Clean up the image files.
Sleep(500) ; Wait for any image handles to be released.
FileDelete($hIdenticon)
FileDelete($sIcon)

Exit