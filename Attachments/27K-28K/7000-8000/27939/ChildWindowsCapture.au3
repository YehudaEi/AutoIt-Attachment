#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>

Global $Child = "" ,$ChildArray  , $PTR_Chi
HotKeySet("{PRINTSCREEN}", "ChildWindowsCapture")
HotKeySet("{ESC}", "Terminate")


While 1
Sleep(20)
WEnd


Func ChildWindowsCapture()
DirCreate(@ScriptDir & "\Capture")
$WindowArray =  GetChildWindows(WinGetHandle(""))
$UBound = UBound($WindowArray) - 1
_GDIPlus_Startup ()
For $i = 0 To  $UBound Step 1
$hBitmap = BitmapCreateFromControlHWND($WindowArray[$i])
$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ($hBitmap)
_GDIPlus_ImageSaveToFile ($hBitmap, @ScriptDir & "\Capture\" & $i & ".jpg")
_WinAPI_DeleteObject ($hBitmap)
Next
_GDIPlus_ShutDown ()
EndFunc


Func  GetChildWindows($hWndParent)
If Not ($PTR_Chi) Then $PTR_Chi = RegisterEnumChildProc("CALLBACK_EnumChildProc")
EnumChildWindows($hWndParent , $PTR_Chi)
Return $ChildArray
EndFunc

Func  EnumChildWindows($hWndParent , $lpEnumFunc)
Local $lParam = 0
Global $Child = ""
Global $ChildArray = 0
Dim $ChildArray[1]
$BOOL = DllCall("user32.dll","int","EnumChildWindows","hwnd",$hWndParent,"ptr",$lpEnumFunc,"int",$lParam)
if Not @error Then Return SetError(@error,"",$BOOL[0])
Return SetError(@error,"",False)
EndFunc

Func RegisterEnumChildProc($lpEnumFunc)
$handle = DLLCallbackRegister ($lpEnumFunc, "int", "hwnd;int")
Return DllCallbackGetPtr($handle)
EndFunc


Func CALLBACK_EnumChildProc($hwnd,$lParam)
if Not StringInStr($Child,$hwnd) Then
$Child &= $hwnd & "|"
ReDim $ChildArray[UBound($ChildArray) + 1]
$ChildArray[UBound($ChildArray) - 1] = $hwnd
Return True
Else
Return False
EndIf
EndFunc


Func BitmapCreateFromControlHWND($HWND)
Local $Width = _WinAPI_GetWindowWidth($hWnd)
Local $Height =_WinAPI_GetWindowHeight($hWnd)
$DC = _WinAPI_GetDC($HWND)
$CompatibleDC = _WinAPI_CreateCompatibleDC($DC)
$hBitmap = _WinAPI_CreateCompatibleBitmap($DC,$Width, $Height)
_WinAPI_SelectObject($CompatibleDC, $hBitmap)
_WinAPI_BitBlt($CompatibleDC, 0, 0, $Width, $Height, $DC, 0, 0,$SRCCOPY)
Return $hBitmap
EndFunc

Func Terminate()
    Exit 0
EndFunc


