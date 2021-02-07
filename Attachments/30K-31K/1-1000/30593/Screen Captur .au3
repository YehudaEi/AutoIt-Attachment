#Include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <Constants.au3>

Global $HWND , $WinType , $hPen = _WinAPI_CreatePen($PS_SOLID,5,0xFF)
HotKeySet("{ESC}", "Terminate")
HotKeySet("{F1}", "WindowsCapture")


While 1
Auto_Select_Windows()
WEnd

Func Auto_Select_Windows()
While 1
Sleep(800)
_WinAPI_RedrawWindow(_WinAPI_GetWindow($HWND,4), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
Sleep(300)
$RArray = ChildWindowFromPoint()
If IsArray($RArray) Then
if Not IsChild($RArray[0],$RArray[1]) Then
$WinType = 1
WindowPen($RArray[0],$WinType)
$HWND = $RArray[0]
Else
$WinType = 2
WindowPen($RArray[0],$WinType)
$HWND = $RArray[0]
EndIf
EndIf
WEnd
EndFunc


Func WindowPen($HWND,$WinType)
Switch $WinType
Case  1
$hDC = _WinAPI_GetDC($HWND)
$obj_orig = _WinAPI_SelectObject($hDC, $hPen)
$RECT = _WinAPI_GetWindowRect($HWND)
$Left = DllStructGetData($RECT,1)
$Top = DllStructGetData($RECT,2)
$Right = DllStructGetData($RECT,3)
$Bottom = DllStructGetData($RECT,4)
$L = $Left
$T = $Top
$W =  $Right - $Left
$H = $Bottom - $Top
_WinAPI_DrawLine($hDC,0,0,$W,0)
_WinAPI_DrawLine($hDC,0,0,0,$H)
_WinAPI_SelectObject($hDC, $obj_orig)
Case 2
$iRight = _WinAPI_GetSystemMetrics(0)
$iBottom = _WinAPI_GetSystemMetrics(1)
$hDC = _WinAPI_GetDC(_WinAPI_GetWindow($HWND,4))
$obj_orig = _WinAPI_SelectObject($hDC, $hPen)
$RECT = _WinAPI_GetWindowRect($HWND)
$Left = DllStructGetData($RECT,1)
$Top = DllStructGetData($RECT,2)
$Right = DllStructGetData($RECT,3)
$Bottom = DllStructGetData($RECT,4)
If $iRight < $Right Then $Right = $iRight
If $iBottom < $Bottom Then $Bottom = $iBottom
If $Left < 0 Then $Left = 0
If $Top < 0 Then $Top = 0
_WinAPI_DrawLine($hDC,$Left,$Top,$Right,$Top)
_WinAPI_DrawLine($hDC,$Right,$Top,$Right,$Bottom)
_WinAPI_SelectObject($hDC, $obj_orig)
EndSwitch
EndFunc


Func ChildWindowFromPoint()
Local $RArray[2]
$pos = MouseGetPos()
$HWNDFP = DllCall("user32.dll","HWND","WindowFromPoint","int", $pos[0], "int",$pos[1])
if @error Then Return False
if $HWNDFP[0] = 0 Then Return False
$ChildHWND = DllCall("user32.dll","HWND","ChildWindowFromPoint","HWND",$HWNDFP[0],"int",$pos[0], "int",$pos[1])
$RArray[0] = $HWNDFP[0]
if @error Then Return $RArray
if $ChildHWND[0] = 0 Then Return $RArray
$RArray[1] = $ChildHWND[0]
Return $RArray
EndFunc


Func WindowsCapture()
$hBitmap = BitmapCreateFromHWND($HWND)
_GDIPlus_Startup ()
$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ($hBitmap)
_GDIPlus_ImageSaveToFile ($hBitmap,@ScriptDir & "\" & $HWND & ".png")
_GDIPlus_ImageSaveToFile ($hBitmap,@ScriptDir & "\" & $HWND & ".bmp")
_WinAPI_DeleteObject ($hBitmap)
_GDIPlus_ShutDown ()
EndFunc


Func BitmapCreateFromHWND($HWND)
_WinAPI_RedrawWindow(_WinAPI_GetWindow($HWND,4), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
Sleep(500)
Switch $WinType
Case 1
Local $Width = _WinAPI_GetWindowWidth($hWnd)
Local $Height =_WinAPI_GetWindowHeight($hWnd)
$DC = _WinAPI_GetDC($HWND)
$CompatibleDC = _WinAPI_CreateCompatibleDC($DC)
$hBitmap = _WinAPI_CreateCompatibleBitmap($DC,$Width, $Height)
_WinAPI_SelectObject($CompatibleDC, $hBitmap)
_WinAPI_BitBlt($CompatibleDC, 0, 0, $Width, $Height, $DC, 0, 0,$SRCCOPY)
Return $hBitmap
Case 2
$RECT = _WinAPI_GetWindowRect($HWND)
$Left = DllStructGetData($RECT,1)
$Top = DllStructGetData($RECT,2)
$Right = DllStructGetData($RECT,3)
$Bottom = DllStructGetData($RECT,4)
$iRight = _WinAPI_GetSystemMetrics(0)
$iBottom = _WinAPI_GetSystemMetrics(1)
if $Bottom > $iBottom Then $Bottom = $iBottom
If $Right > $iRight Then $Right = $iRight
if $Left < 0 Then $Left = 0
if $Top < 0 Then $Top = 0
$L = $Left
$T = $Top
$W =  $Right - $Left
$H = $Bottom - $Top
$Desktop = _WinAPI_GetDesktopWindow()
$DC = _WinAPI_GetDC($Desktop)
$CompatibleDC = _WinAPI_CreateCompatibleDC($DC)
$hBitmap = _WinAPI_CreateCompatibleBitmap($DC,$W,$H)
_WinAPI_SelectObject($CompatibleDC, $hBitmap)
_WinAPI_BitBlt($CompatibleDC,0,0,$W,$H,$DC,$L,$T,$SRCCOPY)
Return $hBitmap
EndSwitch
EndFunc

Func IsChild($hWndParen,$hWnd)
$BOOL = DllCall("user32.dll","int","IsChild","HWND",$hWndParen,"HWND",$hWnd)
if @error Then Return 0
Return $BOOL[0]
EndFunc

Func Terminate()
_WinAPI_RedrawWindow(_WinAPI_GetWindow($HWND,4), 0, 0, $RDW_INVALIDATE + $RDW_ALLCHILDREN)
    Exit 0
EndFunc
