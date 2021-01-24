#include-once

; #INDEX# =======================================================================================================================
; Title .........: Mouse
; AutoIt Version : 3.1.1++
; Language ......: English
; Author ........: NerdFencer
; Description ...: Functions that assist with Mouse Control.
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global Const $MouseLeft     = '0x01'
Global Const $MouseRight    = '0x02'
Global Const $MouseMiddle   = '0x04'
Global Const $MouseX1       = '0x05'
Global Const $MouseX2       = '0x06'

;==============================================================================================================================
; #CURRENT# =====================================================================================================================
;_MouseButtonSwap
;_MouseShowCursor
;_MouseGetPos
;_MouseSetPos
;_MouseGetDoubleClickTime
;_MouseSetDoubleClickTime
;_MouseGetCapture
;_MouseReleaseCapture
;_MouseSetCapture
;_MouseGetButton
;_MouseSetTrap
;_MouseReleaseTrap
;_MouseGetTrap
;==============================================================================================================================
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseSetPos
; Description ...: Sets the mouse position
; Syntax.........: _MouseSetPos($vX=""[,$vY=""])
; Parameters ....: $vX          - X position (use blank string to default to current)
;                  $vY          - Y position
; Return values .: Success      - >0
;                  Failure      - 0
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseSetPos($vX="",$vY="")
	If Not IsInt($vX) Then $vX=MouseGetPos(0)
	If Not IsInt($vY) Then $vY=MouseGetPos(1)
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll","byte","SetCursorPos","int",$vX,"int",$vY)
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseGetPos
; Description ...: Gets the mouse position
; Syntax.........: _MouseGetPos()
; Return values .: Success      - array with current x being [0] and y being [1]
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseGetPos()
	Local $PointStruct = DllStructCreate("long x;long y")
	DllCall(@WindowsDir&"\system32\user32.dll","byte","GetCursorPos","ptr",DllStructGetPtr($PointStruct))
	Local $aiRetVal[2] = [DllStructGetData($PointStruct,"x"),DllStructGetData($PointStruct,"y")]
	Return $aiRetVal
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseButtonSwap
; Description ...: Sets the mouse buttons to either swapped or not
; Syntax.........: _MouseButtonSwap($fOn)
; Parameters ....: $fOn         - True-Swapped False-Normal
; Return values .: Success      - >0:Was reversed Before  0:Was not reversed before
;                  Failure      - -1
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseButtonSwap($fOn)
	If Not($fOn==True) And Not($fOn==False) Then Return SetError(1,0,-1)
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll","byte","SwapMouseButton","byte",$fOn)
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseShowCursor
; Description ...: Determines if the cursor is displayed while over the GUI window or not or not
; Syntax.........: _MouseShowCursor($fOn)
; Parameters ....: $fOn         - True-Show False-Hide
; Return values .: Success      - >0:Was shown Before  0:Was not shown before -1:No mouse installed
;                  Failure      - -2
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseShowCursor($fOn)
	If Not($fOn==True) And Not($fOn==False) Then Return SetError(1,0,-2)
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll","int","ShowCursor","byte",$fOn)
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseGetDoubleClickTime
; Description ...: Gets the double click time
; Syntax.........: _MouseGetDoubleClickTime()
; Return values .: Success      - the current double-click time in milliseconds
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseGetDoubleClickTime()
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", 'uint', 'GetDoubleClickTime')
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseSetDoubleClickTime
; Description ...: Sets the double click time
; Syntax.........: _MouseGetDoubleClickTime()
; Return values .: Success      - >0:Was reversed Before
;                  Failure      - <=0
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseSetDoubleClickTime($iInterval)
	If Not IsInt($iInterval) Then Return -1
	Return DllCall(@WindowsDir&"\system32\user32.dll","byte","SetDoubleClickTime","uint",$iInterval)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseGetCapture
; Description ...: retrieves a handle to the window (if any) that has captured the mouse
; Syntax.........: _MouseGetCapture()
; Return values .: Success      - The winhandel
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseGetCapture()
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", 'hwnd', 'GetCapture')
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseReleaseCapture
; Description ...: releases the mouse capture from a window
; Syntax.........: _MouseReleaseCapture()
; Return values .: Success      - non-zero
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseReleaseCapture()
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", 'byte', 'ReleaseCapture')
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseSetCapture
; Description ...: sets the mouse capture to the specified window
; Syntax.........: _MouseSetCapture()
; Return values .: Success      - previous handle of window
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseSetCapture($vHWND)
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", 'hwnd', 'SetCapture','hwnd',HWnd($vHWND))
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseGetButton
; Description ...: Check if key has been pressed
; Syntax.........: _MouseGetButton($sButton)
; Parameters ....: $sHexKey     - Button to get the state of ($MouseLeft, $MouseRight, $MouseMiddle, $MouseX1, $MouseX2)
; Return values .: Pressed      - 1
;                  Not pressed  - 0
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseGetButton($sButton)
	Local $aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", "int", "GetAsyncKeyState", "int", $sButton)
	Return (Not @error And BitAND($aiRetVal[0], 0x8000) = 0x8000)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseReleaseTrap
; Description ...: frees the cursor
; Syntax.........: _MouseReleaseTrap()
; Return values .: Success      - non-zero
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseReleaseTrap()
	$aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", "int", "ClipCursor", "int", 0)
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseSetTrap
; Description ...: frees the cursor
; Syntax.........: _MouseSetTrap([$vLeft = ""[, $vTop = ""[, $vRight = ""[, $vBottom = ""]]]])
; Return values .: Success      - non-zero
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseSetTrap($vLeft = "", $vTop = "", $vRight = "", $vBottom = "")
	If Not IsInt($vLeft) Then $vLeft = 0
	If Not IsInt($vTop) Then $vTop = 0
	If Not IsInt($vRight) Then $vRight = @DesktopWidth
	If Not IsInt($vBottom) Then $vBottom = @DesktopHeight
	Local $RectStruct = DllStructCreate("int Left;int Top;int Right;int Bottom")
	DllStructSetData($RectStruct, "Left", $vLeft)
	DllStructSetData($RectStruct, "Top", $vTop)
	DllStructSetData($RectStruct, "Right", $vRight)
	DllStructSetData($RectStruct, "Bottom", $vBottom)
	$aiRetVal = DllCall(@WindowsDir&"\system32\user32.dll", "int", "ClipCursor", "ptr", DllStructGetPtr($RectStruct))
	Return $aiRetVal[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _MouseGetTrap
; Description ...: frees the cursor
; Syntax.........: _MouseGetTrap()
; Return values .: Success      - array containing left, top, right, and bottom coords
; Author ........: NerdFencer
; ===============================================================================================================================
Func _MouseGetTrap()
	Local $RectStruct = DllStructCreate("int Left;int Top;int Right;int Bottom")
	DllCall(@WindowsDir&"\system32\user32.dll", "int", "GetClipCursor", "ptr", DllStructGetPtr($RectStruct))
	Local $aiRetVal[4]=[DllStructGetData($RectStruct, "Left"),DllStructGetData($RectStruct, "Top"),DllStructGetData($RectStruct, "Right"),DllStructGetData($RectStruct, "Bottom")]
	Return $aiRetVal
EndFunc
