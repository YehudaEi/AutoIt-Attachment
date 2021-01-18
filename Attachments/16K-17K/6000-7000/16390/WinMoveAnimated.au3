#include-once
;
; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.0
; Language:       English
; Description:    Function to move and replace windows with animated effects.
; Library Version: 1.0
; Author(s):       antiufo, http://antiufo.altervista.org/
; ------------------------------------------------------------------------------




;===============================================================================
;
; Description:      Moves a window gradually changing the position and the transparency.
; Parameter(s):     $hWindow: Handle or title of the window to move
;                            $width: New width of the window or empty string to keep the same
;                            $height: New height of the window or empty string to keep the same
;                            $trans: (optional) New transparency level of window or empty string to keep the same
;                            $left: (optional) New x position of the window or empty string to keep the same
;                            $top: (optional) New y position of the window or empty string to keep the same
;                            $duration: (optional) Duration in ms of the animation
;                            $fps: (optional) Frames per second
; Requirement(s):   _WinMoveAnimatedRaw()
; Return Value(s):  None
; Author(s):        antiufo, http://antiufo.altervista.org/
;
;===============================================================================

Func _WinMoveAnimated($hWindow, $width='', $height='', $trans='', $left='', $top='', $duration = -1, $fps = -1)
	Local $data[5]
	$srcSize = WinGetPos($hWindow)
	
	If $width == '' Then $width = $srcSize[2]
	If $height == '' Then $height = $srcSize[3]
	
	If $left<0 Then $left = @DesktopWidth + $left - $width
	If $top<0 Then $top = @DesktopHeight + $top - $height
	
	If $left == '' Then $left = $srcSize[0] + ($srcSize[2] - $width) / 2
	If $top == '' Then $top = $srcSize[1] + ($srcSize[3] - $height) / 2

	If $trans == '' Then $trans = _WinGetTrans($hWindow)
	_WinMoveAnimatedRaw($hWindow, $hWindow, $width, $height, $trans, $left, $top, $duration, $fps)
EndFunc




;===============================================================================
;
; Description:      Gradually transforms a window into an other changing the position and the transparency.
; Parameter(s):     $hSource: Handle or title of the window to transform
;                            $hTarget: Handle or title of the new window
;                            $duration: (optional) Duration in ms of the animation
;                            $fps: (optional) Frames per second
; Requirement(s):   _WinMoveAnimatedRaw()
; Return Value(s):  None
; Author(s):        antiufo, http://antiufo.altervista.org/
;
;===============================================================================


Func _WinTransformAnimated($hSource, $hTarget, $duration = -1, $fps = -1)
	Local $destSize = WinGetPos($hTarget)
	_WinMoveAnimatedRaw($hSource, $hTarget, $destSize[2], $destSize[3], _WinGetTrans($hTarget), $destSize[0], $destSize[1], $duration, $fps)
EndFunc






;===============================================================================
;
; Description:      Moves a window gradually changing the position and the transparency.
; Parameter(s):     $hWindow: Handle or title of the window to move
;                            $width: New width of the window or empty string to keep the same
;                            $height: New height of the window or empty string to keep the same
;                            $trans: (optional) New transparency level of window or empty string to keep the same
;                            $left: (optional) New x position of the window or empty string to keep the same
;                            $top: (optional) New y position of the window or empty string to keep the same
;                            $duration: (optional) Duration in ms of the animation
;                            $fps: (optional) Frames per second
; Requirement(s):   _WinMoveAnimatedRaw()
; Return Value(s):  None
; Author(s):        antiufo, http://antiufo.altervista.org/
;
;===============================================================================


Func _WinMoveAnimatedRaw($hSource, $hTarget, $width, $height, $destTrans, $left, $top, $duration = -1, $fps = -1)
	If $duration = -1 Then $duration = 200
	If $fps = -1 Then $fps = 100
	Local $interval = 1000 / $fps
	Local $frames = $duration * $fps / 1000
	
	Local $srcSize, $destSize, $srcTrans
	$srcSize = WinGetPos($hSource)
	$srcTrans = _WinGetTrans($hSource)



	$bUseTrans = ($srcTrans <> 255) Or ($destTrans <> 255)
	Local $i
	
	Local $AnimationGUI = GUICreate('', $srcSize[2], $srcSize[3], $srcSize[0], $srcSize[1], 0, 0, $hSource)
	If $bUseTrans Then WinSetTrans($AnimationGUI, '', $srcTrans)
	GUISetState(@SW_SHOW, $AnimationGUI)
	GUISetState(@SW_HIDE, $hSource)
	GUISetState(@SW_DISABLE, $hSource)
	
	$progress = 0
	$deprogress = 1
	$oldtrans = $srcTrans
	$trans = $oldtrans

	
	For $i = 1 To $frames
		Sleep($interval)
		$progress = $i / $frames
		$deprogress = 1 - $progress
		WinMove($AnimationGUI, '', _
				$progress * $left + $deprogress * $srcSize[0], _
				$progress * $top + $deprogress * $srcSize[1], _
				$progress * $width + $deprogress * $srcSize[2], _
				$progress * $height + $deprogress * $srcSize[3])
		If $bUseTrans Then
			$trans = Int($progress * $destTrans + $deprogress * $srcTrans)
			If $trans = $oldtrans Then ContinueLoop
			$oldtrans = $trans
			WinSetTrans($AnimationGUI, '', $trans)
		EndIf
	Next
	
	WinMove($hTarget, '', $left, $top, $width, $height)
	If $bUseTrans Then WinSetTrans($hTarget, '', $destTrans)
	GUIDelete($AnimationGUI)
	GUISetState(@SW_SHOW, $hTarget)
	
EndFunc   ;==>_WinMoveAnimated



;===============================================================================
;
; Description:      Retrieves the transparency of a window .
; Requirement(s):   None
; Return Value(s):  Transparency (0 To 255)
;
;===============================================================================


Func _WinGetTrans($sTitle, $sText = "")
	Local $hWnd = WinGetHandle($sTitle, $sText)
	If Not $hWnd Then Return -1
	Local $aRet = DllCall("user32.dll", "int", "GetLayeredWindowAttributes", "hwnd", $hWnd, "ptr", 0, "int_ptr", 0, "ptr", 0)
	If @error Or Not $aRet[0] Then Return 255
	Return $aRet[3]
EndFunc   ;==>_WinGetTrans

