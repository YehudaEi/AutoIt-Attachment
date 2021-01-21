#include-once
#include <StructureConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: Cursor
; Description ...: This module contains various Cursor API calls that have been translated to AutoIt functions.
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not working/documented/implimented at this time
; ===============================================================================================================================
; ===============================================================================================================================

; ===============================================================================================================================
; #CURRENT# =====================================================================================================================
;_Cursor_Destroy
;_Cursor_Get
;_Cursor_GetInfo
;_Cursor_GetPos
;_Cursor_GetPhysicalPos
;_Cursor_LoadFromFile
;_Cursor_Set
;_Cursor_SetPos
;_Cursor_SetPhysicalPos
;_Cursor_Show
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Name...........: _Cursor_Copy
; Description ...: Copies the specified cursor.
; Syntax.........: _Cursor_Copy($hCursor)
; Parameters ....: $hCursor - Handle to the cursor to be copied
; Return values .: Success      - Handle to the duplicate cursor
;                  Failure      - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Enables an application to obtain the handle to a cursor shape owned by another module.
;                  Then if the other module is freed, the application is still able to use the cursor shape.
;+
;                  Before closing, an application must call the _Cursor_Destroy function to free any system resources associated with the cursor.
;+
;                  Do not use the _Cursor_Copy function for animated cursors.
; Related .......:
; Link ..........; @@MsdnLink@@ CopyCursor
; Example .......;
; ===============================================================================================================================
Func _Cursor_Copy($hCursor)
	Local $iResult = DllCall("user32.dll", "hwnd", "CopyCursor", "hwnd", $hCursor)
	If IsArray($iResult) Then Return SetError(IsHWnd($iResult[0]) <> True, 0, $iResult[0])
	Return SetError(-1, 0, 0)
EndFunc   ;==>_Cursor_Copy

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_Destroy
; Description ...: Destroys a cursor and frees any memory the cursor occupied
; Syntax.........: _Cursor_Destroy($hCursor)
; Parameters ....: $hCursor - Handle to the cursor to be copied
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ DestroyCursor
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_Destroy($hCursor)
	Local $iResult = DllCall("user32.dll", "int", "DestroyCursor", "hwnd", $hCursor)
	If @error Then Return SetError(-1, 0, False)
	Return $iResult[0] <> 0
EndFunc   ;==>_Cursor_Destroy

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_Get
; Description ...: Retrieves a handle to the current cursor
; Syntax.........: _Cursor_Get()
; Parameters ....:
; Return values .: Success      - Handle to the current cursor
;                  Failure      - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ GetCursor
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_Get()
	Local $iResult = DllCall("user32.dll", "hwnd", "GetCursor")
	If @error Then Return SetError(-1, -1, 0)
	Return $iResult[0]
EndFunc   ;==>_Cursor_Get

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_GetInfo
; Description ...: Retrieves information about the global cursor
; Syntax.........: _Cursor_GetInfo($hCursor)
; Parameters ....: $hCursor - Handle to the cursor
; Return values .: Success      - Structure $tagCURSORINFO
;                  Failure      - @error set to -1
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ GetCursorInfo
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_GetInfo($hCursor)
	Local $tCURSORINFO = DllStructCreate($tagCURSORINFO)
	DllStructSetData($tCURSORINFO, "Size", DllStructGetSize($tCURSORINFO))
	DllStructSetData($tCURSORINFO, "hCursor", $hCursor)

	DllCall("user32.dll", "int", "GetCursorInfo", "ptr", DllStructGetPtr($tCURSORINFO))
	If @error Then Return SetError(-1, 0, $tCURSORINFO)
	Return $tCURSORINFO
EndFunc   ;==>_Cursor_GetInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_GetPos
; Description ...: Retrieves the cursor's position, in screen coordinates
; Syntax.........: _Cursor_GetPos()
; Parameters ....:
; Return values .: Success      - Array in the following format:
;                  |[0] - X position of the cursor
;                  |[1] - Y position of the cursor
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ GetCursorPos
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_GetPos()
	Local $aPos[2], $tPoint = DllStructCreate($tagPOINT)
	DllCall("user32.dll", "int", "GetCursorPos", "ptr", DllStructGetPtr($tPoint))
	If @error Then Return SetError(-1, 0, $aPos)
	$aPos[0] = DllStructGetData($tPoint, "X")
	$aPos[1] = DllStructGetData($tPoint, "Y")
	Return $aPos
EndFunc   ;==>_Cursor_GetPos

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_GetPhysicalPos
; Description ...: Retrieves the position of the cursor in physical coordinates
; Syntax.........: _Cursor_GetPhysicalPos()
; Parameters ....:
; Return values .: Success      - Array in the following format:
;                  |[0] - X position of the cursor
;                  |[1] - Y position of the cursor
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Minimum OS: Windows Vista
; Related .......:
; Link ..........; @@MsdnLink@@ GetPhysicalCursorPos
; Example .......;
; ===============================================================================================================================
Func _Cursor_GetPhysicalPos()
	Local $aPos[2], $tPoint = DllStructCreate($tagPOINT)
	DllCall("user32.dll", "int", "GetPhysicalCursorPos", "ptr", DllStructGetPtr($tPoint))
	If @error Then Return SetError(-1, 0, $aPos)
	$aPos[0] = DllStructGetData($tPoint, "X")
	$aPos[1] = DllStructGetData($tPoint, "Y")
	Return $aPos
EndFunc   ;==>_Cursor_GetPhysicalPos

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_LoadFromFile
; Description ...: Creates a cursor based on data contained in a file
; Syntax.........: _Cursor_LoadFromFile($sCursorFile)
; Parameters ....: $sCursorFile - File to retrieve cursor from
; Return values .: Success      - Handle to the cursor
;                  Failure      - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: The data in the file must be in either .CUR or .ANI format
; Related .......:
; Link ..........; @@MsdnLink@@ LoadCursorFromFile
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_LoadFromFile($sCursorFile)
	Local $iResult = DllCall("user32.dll", "hwnd", "LoadCursorFromFile", "str", $sCursorFile)
	If @error Then Return SetError(-1, -1, 0)
	Return $iResult[0]
EndFunc   ;==>_Cursor_LoadFromFile

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_Set
; Description ...: Sets the cursor shape
; Syntax.........: _Cursor_Set($hCursor)
; Parameters ....: $hCursor - Handle to the cursor
; Return values .: Success - Handle to the previous cursor, if there was one
;                  Failure - 0
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ SetCursor
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_Set($hCursor)
	Local $iResult = DllCall("user32.dll", "hwnd", "SetCursor", "hwnd", $hCursor)
	If @error Then Return SetError(-1, 0, 0)
	Return $iResult[0]
EndFunc   ;==>_Cursor_Set

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_SetPos
; Description ...: Moves the cursor to the specified screen coordinates
; Syntax.........: _Cursor_SetPos($iX, $iY)
; Parameters ....: $iX      - Specifies the new x-coordinate of the cursor, in screen coordinates
;                  $iY      - Specifies the new y-coordinate of the cursor, in screen coordinates
; Return values .: Success - True
;                  Failure - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ SetCursorPos
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_SetPos($iX, $iY)
	Local $iResult = DllCall("user32.dll", "int", "SetCursorPos", "int", $iX, "int", $iY)
	If @error Then Return SetError(-1, 0, False)
	Return $iResult[0] <> 0
EndFunc   ;==>_Cursor_SetPos

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_SetPhysicalPos
; Description ...: Sets the position of the cursor in physical coordinates
; Syntax.........: _Cursor_SetPhysicalPos($iX, $iY)
; Parameters ....: $iX      - Specifies the new x-coordinate of the cursor, in physical coordinates
;                  $iY      - Specifies the new y-coordinate of the cursor, in physical coordinates
; Return values .: Success - True
;                  Failure - False
; Author ........: Gary Frost
; Modified.......:
; Remarks .......: Minimum OS: Windows Vista
; Related .......:
; Link ..........; @@MsdnLink@@ SetPhysicalCursorPos
; Example .......;
; ===============================================================================================================================
Func _Cursor_SetPhysicalPos($iX, $iY)
	Local $iResult = DllCall("user32.dll", "int", "SetPhysicalCursorPos", "int", $iX, "int", $iY)
	If @error Then Return SetError(-1, 0, False)
	Return $iResult[0] <> 0
EndFunc   ;==>_Cursor_SetPhysicalPos

; #FUNCTION# ====================================================================================================================
; Name...........: _Cursor_Show
; Description ...: Displays or hides the cursor
; Syntax.........: _Cursor_Show($fShow)
; Parameters ....: $fShow       - If True, the curor is shown, otherwise it is hidden
; Return values .: Success      - The new display counter
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......: This function sets an internal display counter that determines whether the cursor  should  be  displayed.  The
;                  cursor is displayed only if the display count is greater than or equal to 0.  If a  mouse  is  installed,  the
;                  initial display count is 0. If no mouse is installed, the display count is -1.
; Related .......:
; Link ..........; @@MsdnLink@@ ShowCursor
; Example .......; Yes
; ===============================================================================================================================
Func _Cursor_Show($fShow = True)
	Local $aResult

	$aResult = DllCall("User32.dll", "int", "ShowCursor", "int", $fShow)
	Return $aResult[0]
EndFunc   ;==>_Cursor_Show