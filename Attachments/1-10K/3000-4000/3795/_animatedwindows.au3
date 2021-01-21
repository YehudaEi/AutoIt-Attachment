; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Raindancer <Raindancer@nobrain.ch>
;
; Script Function:
;	Animate your Windows and GUI
; 	Version : 1.0 BETA
;
; ----------------------------------------------------------------------------

;CONSTANTS
$AW_FADE_IN = 0x00080000;fade-in
$AW_FADE_OUT = 0x00090000;fade-out
$AW_SLIDE_IN_LEFT = 0x00040001;slide in from left
$AW_SLIDE_OUT_LEFT = 0x00050002;slide out to left
$AW_SLIDE_IN_RIGHT = 0x00040002;slide in from right
$AW_SLIDE_OUT_RIGHT = 0x00050001;slide out to right
$AW_SLIDE_IN_TOP = 0x00040004;slide-in from top
$AW_SLIDE_OUT_TOP = 0x00050008;slide-out to top
$AW_SLIDE_IN_BOTTOM = 0x00040008;slide-in from bottom
$AW_SLIDE_OUT_BOTTOM = 0x00050004;slide-out to bottom
$AW_DIAG_SLIDE_IN_TOPLEFT = 0x00040005;diag slide-in from Top-left
$AW_DIAG_SLIDE_OUT_TOPLEFT = 0x0005000a;diag slide-out to Top-left
$AW_DIAG_SLIDE_IN_TOPRIGHT = 0x00040006;diag slide-in from Top-Right
$AW_DIAG_SLIDE_OUT_TOPRIGHT = 0x00050009;diag slide-out to Top-Right
$AW_DIAG_SLIDE_IN_BOTTOMLEFT = 0x00040009;diag slide-in from Bottom-left
$AW_DIAG_SLIDE_OUT_BOTTOMLEFT = 0x00050006;diag slide-out to Bottom-left
$AW_DIAG_SLIDE_IN_BOTTOMRIGHT = 0x0004000a;diag slide-in from Bottom-right
$AW_DIAG_SLIDE_OUT_BOTTOMRIGHT = 0x00050005;diag slide-out to Bottom-right
$AW_EXPLODE = 0x00040010;explode
$AW_IMPLODE = 0x00050010;implode

Func _GUIAnimateWindow($gui, $mode, $duration=1000)
      DllCall ( "user32.dll", "int", "AnimateWindow", "hwnd", $gui, "int", $duration, "long", $mode )
EndFunc

#cs DEMO - For lazy guys like me - to copy paste

#Include <_animatedwindows.au3>

$hwnd = GUICreate ( "AnimateWindow - Demo", 300, 300 )
_GUIAnimateWindow($hwnd, $AW_FADE_IN)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_FADE_OUT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_IN_LEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_OUT_LEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_IN_RIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_OUT_RIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_IN_TOP)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_OUT_TOP)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_IN_BOTTOM)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_SLIDE_OUT_BOTTOM)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_IN_TOPLEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_OUT_TOPLEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_IN_TOPRIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_OUT_TOPRIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_IN_BOTTOMLEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_OUT_BOTTOMLEFT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_IN_BOTTOMRIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_DIAG_SLIDE_OUT_BOTTOMRIGHT)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_EXPLODE)
Sleep(1500)
_GUIAnimateWindow($hwnd, $AW_IMPLODE)
#ce
