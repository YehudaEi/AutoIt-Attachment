#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Change2CUI=y
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
Global Const $VK_NUMLOCK = 0x90
Global Const $VK_SCROLL = 0x91
Global Const $VK_CAPITAL = 0x14

IF _GetNumLock()=1 Then send("{NUMLOCK}")
IF _GetScrollLock()=1 Then send("{SCROLLLOCK}")
IF _GetCaps()=1 Then send("{CAPSLOCK}")

Opt("WinTitleMatchMode", 4)
Local $HWND = WinGetHandle("classname=Progman")
Local $WM_SYSCommand = 274
Local $SC_MonitorPower = 61808
DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND, "int", $WM_SYSCommand, "int", $SC_MonitorPower, "int", 2)


Func _GetNumLock()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_NUMLOCK)
    Return $ret[0]
EndFunc
Func _GetScrollLock()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_SCROLL)
    Return $ret[0]
EndFunc
Func _GetCaps()
    Local $ret
    $ret = DllCall("user32.dll","long","GetKeyState","long",$VK_CAPITAL)
    Return $ret[0]
EndFunc