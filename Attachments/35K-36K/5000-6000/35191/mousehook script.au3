#include <GUIConstants.au3>
#Include <WinAPI.au3>

Global Const $WM_MOUSEWHEEL = 0x020A
Global Const $WM_LBUTTONDBLCLK = 0x0203
Global Const $WM_LBUTTONDOWN = 0x0201
Global Const $WM_LBUTTONUP = 0x0202
Global Const $WM_RBUTTONDBLCLK = 0x0206
Global Const $WM_RBUTTONDOWN = 0x0204
Global Const $WM_RBUTTONUP = 0x0205
Global Const $WM_MBUTTONDBLCLK = 0x0209
Global Const $WM_MBUTTONDOWN = 0x0207
Global Const $WM_MBUTTONUP = 0x0208 
Global Const $MSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"

$hKey_Proc = DllCallbackRegister("_Mouse_Proc", "int", "int;ptr;ptr")
$hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
$hM_Hook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, "ptr", DllCallbackGetPtr($hKey_Proc), "hwnd", $hM_Module[0], "dword", 0)

While 1
If $GUI_EVENT_CLOSE = GUIGetMsg() Then Exit
WEnd

Func _Mouse_Proc($nCode, $wParam, $lParam)
    Local $info, $ptx, $pty, $mouseData, $flags, $time, $dwExtraInfo
    Local $xevent="Null", $xmouseData
    If $nCode < 0 Then 
        $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
                "int", $nCode, "ptr", $wParam, "ptr", $lParam)
        Return $ret[0]
    EndIf
    
    $info = DllStructCreate($MSLLHOOKSTRUCT, $lParam) 
    $ptx = DllStructGetData($info, 1)
    $pty = DllStructGetData($info, 2)
    $mouseData = DllStructGetData($info, 3)
    $flags = DllStructGetData($info, 4)
    $time = DllStructGetData($info, 5)
    $dwExtraInfo = DllStructGetData($info, 6)
	
    Select
        Case $wParam = $WM_LBUTTONDBLCLK
            $xevent = "Double Left Click"
        Case $wParam = $WM_LBUTTONDOWN
            $xevent = "Left Down"
        Case $wParam = $WM_LBUTTONUP
            $xevent = "Left Up"
        Case $wParam = $WM_RBUTTONDBLCLK
            $xevent = "Double Right Click"
        Case $wParam = $WM_RBUTTONDOWN
            $xevent = "Right Down"
        Case $wParam = $WM_RBUTTONUP
            $xevent = "Right Up"
        Case $wParam = $WM_MBUTTONDBLCLK
            $xevent = "Double Wheel Click"
        Case $wParam = $WM_MBUTTONDOWN
            $xevent = "Wheel Down"
        Case $wParam = $WM_MBUTTONUP
            $xevent = "Wheel Up"
		EndSelect
		
	if $xevent<>"Null" then
	IniWrite("MouseHook.txt","Mouse","Event",$xevent)
	endif

    $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
            "int", $nCode, "ptr", $wParam, "ptr", $lParam)
    Return $ret[0]
EndFunc

Func OnAutoItExit()
    DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
    $hM_Hook[0] = 0
    DllCallbackFree($hKey_Proc)
    $hKey_Proc = 0
EndFunc
