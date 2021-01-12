; ====================================================================================================
; Description ..: Flashes the specified window. It does not change the active state of the window.
; Parameters ...: $sWindow - String that specifies the handle of the Window to flash
;                   it can be a title or an handle
;                 $sFlash   - Value Meaning 
;					$FLASHW_ALL
;					3 _ Flash both the window caption and taskbar button. This is equivalent to setting the FLASHW_CAPTION | FLASHW_TRAY flags. 
;					$FLASHW_CAPTION
;					1 _ Flash the window caption. 
;					$FLASHW_STOP
;					0 _ Stop flashing. The system restores the window to its original state. 
;					$FLASHW_TIMER
;					4 _ Flash continuously, until the FLASHW_STOP flag is set. 
;					$FLASHW_TIMERNOFG
;					12 _ Flash continuously until the window comes to the foreground. 
;					$FLASHW_TRAY
;					2 _ Flash the taskbar button. 
;					;default is $FLASHW_TIMERNOFG + $FLASHW_ALL
; Return values : The return value specifies the window's state before the call to the FlashWindowEx function. 
;                 If the window caption was drawn as active before the call, the return value is nonzero. Otherwise, the return value is zero.
;                   
; Author .......: Yoan Roblet (Arcker)
; Notes ........: More information on http://msdn2.microsoft.com/en-us/library/ms679347.aspx
; ====================================================================================================
Global Const $FLASHW_ALL = 3 ;Flash both the window caption and taskbar button. This is equivalent to setting the FLASHW_CAPTION | FLASHW_TRAY flags.
Global Const $FLASHW_CAPTION = 1 ;Flash the window caption.
Global Const $FLASHW_STOP = 0 ;Stop flashing. The system restores the window to its original state.
Global Const $FLASHW_TIMER = 4;Flash continuously, until the FLASHW_STOP flag is set.
Global Const $FLASHW_TIMERNOFG = 12 ;Flash continuously until the window comes to the foreground.
Global Const $FLASHW_TRAY = 2
$FLASHINFO = DllStructCreate("uint;" _ ; cbSize;  ; size of the structure
		 & "hwnd;" _ ;hwnd;  ;handle of the Window to Flash
		 & "dword;" _ ;dwFlags;  The flash status
		 & "uint;" _ ;uCount;  The number of times to flash the window
		 & "dword" _ ;dwTimeout; The rate at which the window is to be flashed, in milliseconds. If dwTimeout is zero, the function uses the default cursor blink rate.
		) ;FLASHWINFO,  *PFLASHWINFO;

Func _FlashWindow($sWindow,$sFlash=15,$uCount=0,$dwTimeout=0)
	If IsHWnd($sWindow) Then
		$hwnd = $sWindow
	Else
		$hwnd = WinGetHandle($sWindow)
	EndIf
	DllStructSetData($FLASHINFO, 1, DllStructGetSize($FLASHINFO))
	DllStructSetData($FLASHINFO, 2, $hwnd)
	DllStructSetData($FLASHINFO, 3, $FLASHW_ALL + $FLASHW_TIMERNOFG)
	DllStructSetData($FLASHINFO, 4, $uCount)
	DllStructSetData($FLASHINFO, 5, $dwTimeout)
$return = DllCall("user32.dll", "int", "FlashWindowEx", "ptr", DllStructGetPtr($FLASHINFO))
return $return
EndFunc   ;==>_FlashWindow