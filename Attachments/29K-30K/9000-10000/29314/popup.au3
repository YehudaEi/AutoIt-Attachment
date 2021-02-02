#include <WindowsConstants.au3>
#Include <WinAPI.au3>
Opt("TrayIconHide", 1) ;0=show, 1=hide tray icon 
; Create Toast window
Global $hGUI = GUICreate("", 200, 100, @DesktopWidth - 800, @DesktopHeight - 600, $WS_POPUPWINDOW, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
Global $hLabel = GUICtrlCreateLabel("You have an incoming TTY! Click this box to acknowledge you recieved this.", 1, 15, 198, 198)
; Gary Frost's WinAnimate function
; 0x00040001 ; slide in from left
; 0x00050002 ; slide out to left
; 0x00040002 ; slide in from right
; 0x00050001 ; slide out to right
; 0x00040004 ; slide-in from top
; 0x00050008 ; slide-out to top
; 0x00040008 ; slide-in from bottom
; 0x00050004 ; slide-out to bottom
; Slide in Toast - but keep focus on current window
_WinAnimate($hGUI, 0x00050004)
$hCurrWnd = _WinAPI_GetForegroundWindow()
GUISetState(@SW_SHOW, $hGUI)
WinActivate($hCurrWnd, "")

; Wait for click from Toast
While 1

    Local $aMsg = GUIGetMsg(1)

    If $aMsg[1] = $hGUI And $aMsg[0] = $hLabel Then ExitLoop

WEnd

; Slide out window
_WinAnimate($hGUI, 0x00050001)

Exit

; --------------

; Gary Frost's WinAnimate function

Func _WinAnimate($h_gui, $i_mode, $i_duration = 1000)

    If @OSVersion = "WIN_XP" OR @OSVersion = "WIN_2000" Or @OSVersion = "WIN_VISTA" Then

        DllCall("user32.dll", "int", "AnimateWindow", "hwnd", $h_gui, "int", $i_duration, "long", $i_mode)

        Local $ai_gle = DllCall('kernel32.dll', 'int', 'GetLastError')
        If $ai_gle[0] <> 0 Then
            Return SetError(1, 0, 0)
        EndIf
        Return 1

    Else

        Return SetError(2, 0, 0)

    EndIf
EndFunc;==> _WinAnimate()
 