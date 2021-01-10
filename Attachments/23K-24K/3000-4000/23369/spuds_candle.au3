#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#Include <WinAPI.au3>

Global Const $MSLLHOOKSTRUCT = $tagPOINT & ";dword mouseData;dword flags;dword time;ulong_ptr dwExtraInfo"
Global Const $WM_MOUSEWHEEL = 0x020A ;wheel up/down
Global $diameter = 200

$VirtualDesktopWidth = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 78);sm_virtualwidth
$VirtualDesktopWidth = $VirtualDesktopWidth[0]
$VirtualDesktopHeight = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 79);sm_virtualheight
$VirtualDesktopHeight = $VirtualDesktopHeight[0]
$VirtualDesktopX = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 76);sm_xvirtualscreen
$VirtualDesktopX = $VirtualDesktopX[0]
$VirtualDesktopY = DLLCall("user32.dll", "int", "GetSystemMetrics", "int", 77);sm_yvirtualscreen
$VirtualDesktopY = $VirtualDesktopY[0]

$hKey_Proc = DllCallbackRegister("_Mouse_Proc", "int", "int;ptr;ptr")
$hM_Module = DllCall("kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
$hM_Hook = DllCall("user32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, "ptr", DllCallbackGetPtr($hKey_Proc), "hwnd", $hM_Module[0], "dword", 0)

Global $hGUI = GUICreate("Test", $VirtualDesktopWidth, $VirtualDesktopHeight, $VirtualDesktopX, $VirtualDesktopY, $WS_POPUP, BitOr($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
HotKeySet("{ESC}", "Quit")
GUISetBkColor (0x000000)
GUISetState(@SW_SHOW)

While 1
    $radius = $diameter / 2
    $pos = MouseGetPos()
    _GuiHole($hGUI , Abs($VirtualDesktopX) + $pos[0] - $radius,  Abs($VirtualDesktopY) + $pos[1] - $radius, $diameter)
    Sleep(10)
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd

Func Quit() ; exit program
    Exit
EndFunc

Func _GuiHole($h_win, $i_x, $i_y, $i_size) ;modified code by ProgAndy
   Dim $pos, $outer_rgn, $inner_rgn, $wh, $combined_rgn, $ret
   $pos = WinGetPos($h_win)
    $outer_rgn = DllCall("gdi32.dll", "hwnd", "CreateRectRgn", "long", 0, "long", 0, "long", $pos[2], "long", $pos[3])
    If IsArray($outer_rgn) Then
        $inner_rgn = DllCall("gdi32.dll", "hwnd", "CreateEllipticRgn", "long", $i_x, "long", $i_y, "long", $i_x + $i_size, "long", $i_y + $i_size)
        If IsArray($inner_rgn) Then
                DllCall("gdi32.dll", "long", "CombineRgn", "hwnd", $outer_rgn[0], "hwnd", $outer_rgn[0], "hwnd", $inner_rgn[0], "int", 4)
                $ret = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "hwnd", $outer_rgn[0], "int", 1)
;~                 DllCall("gdi32.dll", "long", "DeleteObject", "hwnd", $inner_rgn[0])
                If $ret[0] Then
                    Return 1
                Else
                    Return 0
                EndIf
        Else
            Return 0
        EndIf
    Else
        Return 0
    EndIf
EndFunc ;==>_GuiHole

Func _Mouse_Proc($nCode, $wParam, $lParam) ;function called for mouse events..
    ;define local vars
    Local $info, $ptx, $pty, $mouseData, $flags, $time, $dwExtraInfo
    Local $xevent = "Unknown", $xmouseData = ""
   
    If $nCode < 0 Then ;recommended, see http://msdn.microsoft.com/en-us/library/ms644986(VS.85).aspx
        $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
                "int", $nCode, "ptr", $wParam, "ptr", $lParam) ;recommended
        Return $ret[0]
    EndIf
   
    $info = DllStructCreate($MSLLHOOKSTRUCT, $lParam) ;used to get all data in the struct ($lParam is the ptr)
    $ptx = DllStructGetData($info, 1) ;see notes below..
    $pty = DllStructGetData($info, 2)
    $mouseData = DllStructGetData($info, 3)
    $flags = DllStructGetData($info, 4)
    $time = DllStructGetData($info, 5)
    $dwExtraInfo = DllStructGetData($info, 6)

    ;Find which event happened
    Select
        Case $wParam = $WM_MOUSEWHEEL
            If _WinAPI_HiWord($mouseData) > 0 Then
                $xmouseData = "Wheel Forward"
				ConsoleWrite($diameter & @CRLF)
				If $diameter < $VirtualDesktopWidth Then $diameter += 40
            Else
                $xmouseData = "Wheel Backward"
				ConsoleWrite($diameter & @CRLF)
				If $diameter > 0 Then $diameter -= 40
            EndIf
    EndSelect
   
    ;This is recommended instead of Return 0
    $ret = DllCall("user32.dll", "long", "CallNextHookEx", "hwnd", $hM_Hook[0], _
            "int", $nCode, "ptr", $wParam, "ptr", $lParam)
    Return $ret[0]
EndFunc   ;==>_Mouse_Proc

Func OnAutoItExit()
    DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
    $hM_Hook[0] = 0
    DllCallbackFree($hKey_Proc)
    $hKey_Proc = 0
EndFunc   ;==>OnAutoItExit