#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <GUIConstantsEx.au3>



Global $__xVideo_DLL


; Funktionen
Func _xVideo_Init($handle)
	Local $aRet = DllCall($__xVideo_DLL, "none", "xVideo_Init", "hwnd", $handle, "dword", 0) ;BOOL    xVideoDEF(xVideo_Init)(HWND handle,DWORD flags);
	If @error Then
		Return SetError(@error, 0, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_xVideo_Init

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_GetVersion
; Description ...: Retrieves the version of xVideo that is loaded.
; Syntax.........: _xVideo_GetVersion()
; Parameters ....:
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_GetVersion()
	Local $aRet = DllCall($__xVideo_DLL, "dword", "xVideo_GetVersion")
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_GetVersion


; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_Free
; Description ...: Frees all resources
; Syntax.........: _xVideo_Free()
; Parameters ....:
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_Free()
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_Free")
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_Free

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_StreamCreateFile
; Description ...: Creates a stream from an video file
; Syntax.........: __xVideo_StreamCreateFile($hStream, $pos, $flags)
; Parameters ....:
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_StreamCreateFile($hStream, $pos, $flags)
	Local $aRet = DllCall($__xVideo_DLL, "hwnd", "xVideo_StreamCreateFile", "str", $hStream, "dword", $pos, "hwnd", 0, "dword", $flags)
	If @error Then
		Return SetError(@error, 0, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_xVideo_StreamCreateFile

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_PlayStream
; Description ...: Play the stream from an video file
; Syntax.........: _xVideo_PlayStream($p)
; Parameters ....: the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_PlayStream($p)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_ChannelPlay", "dword", $p)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_PlayStream

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelSetWindow
; Description ...: Set the windows where the video plays
; Syntax.........: _xVideo_ChannelSetWindow($chan, $win)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
;				   -$win the handle to the gui
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelSetWindow($chan, $win)
	Local $aRet = DllCall($__xVideo_DLL, "none", "xVideo_ChannelSetWindow", "dword", $chan, "dword", 0, "hwnd", $win)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelSetWindow

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelAddWindow
; Description ...:  Add a windows where the video plays
; Syntax.........: _xVideo_ChannelAddWindow($chan, $win)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
;				   -$win the handle to the gui
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelAddWindow($chan, $win)
	Local $aRet = DllCall($__xVideo_DLL, "hwnd", "xVideo_ChannelAddWindow", "dword", $chan, "hwnd", $win)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelAddWindow

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelRemoveWindow
; Description ...: Remove a windows where the video plays
; Syntax.........: _xVideo_ChannelRemoveWindow($chan, $win)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
;				   -$win the handle to the gui
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelRemoveWindow($chan, $win)
	Local $aRet = DllCall($__xVideo_DLL, "hwnd", "xVideo_ChannelRemoveWindow", "dword", $chan, "hwnd", $win)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelRemoveWindow

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelResizeWindow
; Description ...: Resize the windows where the video plays
; Syntax.........: _xVideo_ChannelResizeWindow($chan, $left, $top, $right, $bottom)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
;				   -$left x
;				   -$top y
;			       -$right width
;				   -$bottom height
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelResizeWindow($chan, $left, $top, $right, $bottom)
	Local $aRet = DllCall($__xVideo_DLL, "none", "xVideo_ChannelResizeWindow", "dword", $chan, "dword", 0, "int", $left, "int", $top, "int", $right, "int", $bottom)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelResizeWindow

Func _xVideo_SetConfig($option, $value)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_SetConfig", "dword", $option, "dword", $value)
	If @error Then
		Return SetError(@error, 0, 0)
	EndIf
	Return $aRet[0]
EndFunc   ;==>_xVideo_SetConfig

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelPlay
; Description ...: Play the stream
; Syntax.........: _xVideo_ChannelPlay($chan)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelPlay($chan)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_ChannelPlay", "dword", $chan)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelPlay

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelStop
; Description ...: Stop the stream
; Syntax.........: _xVideo_ChannelStop($chan)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelStop($chan)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_ChannelStop", "dword", $chan)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelStop

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelPause
; Description ...: Paus the stream
; Syntax.........: _xVideo_ChannelPause($chan)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelPause($chan)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_ChannelPause", "dword", $chan)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelPause

Func _xVideo_StreamFree($chan)
	Local $aRet = DllCall($__xVideo_DLL, "ubyte", "xVideo_StreamFree", "dword", $chan)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_StreamFree

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelGetLength
; Description ...: Get the Length from stream
; Syntax.........: _xVideo_ChannelGetLength($chan, $mode)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelGetLength($chan, $mode)
	Local $aRet = DllCall($__xVideo_DLL, "double", "xVideo_ChannelGetLength", "dword", $chan, "dword", $mode)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelGetLength

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelSetPosition
; Description ...: Set stream psition
; Syntax.........: _xVideo_ChannelSetPosition($chan, $pos, $mode)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelSetPosition($chan, $pos, $mode)
	Local $aRet2 = DllCall($__xVideo_DLL, "ubyte", "xVideo_ChannelSetPosition", "dword", $chan, "double", $pos, "dword", $mode)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet2[0]
EndFunc   ;==>_xVideo_ChannelSetPosition

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelGetPosition
; Description ...: Get position in the stream
; Syntax.........: _xVideo_ChannelGetPosition($chan, $mode)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelGetPosition($chan, $mode)
	Local $aRet = DllCall($__xVideo_DLL, "double", "xVideo_ChannelGetPosition", "dword", $chan, "dword", $mode)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelGetPosition

; #FUNCTION# ====================================================================================================================
; Name...........: _xVideo_ChannelGetState
; Description ...: Get state of the stream
; Syntax.........: _xVideo_ChannelGetState($chan)
; Parameters ....: -$chan the handle from _xVideo_StreamCreateFile
; Return values .:  0 //channel is stopped
;					1 //channel is playing
;					2 //channel is paused
; Author ........: Blade_m2011
; ===============================================================================================================================
Func _xVideo_ChannelGetState($chan)
	Local $aRet = DllCall($__xVideo_DLL, "dword", "xVideo_ChannelGetState", "dword", $chan)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelGetState


Func _xVideo_StreamCreateDVD($hStream, $flags)
	Local $aRet = DllCall($__xVideo_DLL, "hwnd", "xVideo_StreamCreateDVD", "wstr", $hStream, "dword", $flags)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_StreamCreateDVD


Func _xVideo_ChannelSetFullscreen($chan, $full)
	Local $aRet = DllCall($__xVideo_DLL, "double", "xVideo_ChannelSetFullscreen", "dword", $chan, "ubyte", $full)
	If @error Then Return SetError(@error, 0, 0)
	Return $aRet[0]
EndFunc   ;==>_xVideo_ChannelSetFullscreen

;#cs
Func _xVideo_ChannelGetInfo($chan)
	$xVideo_INFO = 'double AvgTimePerFrame;int Height;int Width;int nChannels;dword freq;dword wBits;BOOL floatingpoint;'

	Local $aRet[17]
	Local $xVideo_ret_struct = DllStructCreate($xVideo_INFO)
	Local $aRet1 = DllCall($__xVideo_DLL, "none", "xVideo_ChannelGetInfo", "dword", $chan, "ptr", DllStructGetPtr($xVideo_ret_struct))
	If @error Then Return SetError(@error, 0, 0)

	$aRet[0] = DllStructGetData($xVideo_ret_struct, 1)
	$aRet[1] = DllStructGetData($xVideo_ret_struct, 2)
	$aRet[2] = DllStructGetData($xVideo_ret_struct, 3)
	$aRet[3] = DllStructGetData($xVideo_ret_struct, 4)
	$aRet[4] = DllStructGetData($xVideo_ret_struct, 5)
	$aRet[5] = DllStructGetData($xVideo_ret_struct, 6)
	$aRet[6] = DllStructGetData($xVideo_ret_struct, 7)
	Return $aRet
EndFunc   ;==>_xVideo_ChannelGetInfo
;#ce
Func _xVideo_UDF_Open()
	$__xVideo_DLL = DllOpen("xVideo.dll")
	If @error Then
		MsgBox(0, "1", "error")
		Return SetError(@error, 0, 0)
	EndIf
EndFunc   ;==>_xVideo_UDF_Open

Func _xVideo_UDF_Close()
	DllCall($__xVideo_DLL, "long", "xVideo_Free")
	DllClose($__xVideo_DLL)
EndFunc   ;==>_xVideo_UDF_Close