#include-once
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>

; #INDEX# =======================================================================================================================
; Title .........: GUI Panel UDF
; AutoIt Version : 3.3.8.0
; Description ...: Creates and manages child wnds as panel ctrls.
; Author(s) .....: FireFox (aka d3mon, d3monCorp)
; Dll ...........: None
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__hBackgroundPic = 0
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_Create
; Description ...: Creates a panel wnd on the specified parent wnd
; Syntax.........: _GUICtrlPanel_Create($hPanelParentWnd, $sDisplayPosType = "Coords", $iPanelLeft = 0, $iPanelTop = 0, $iPanelWidth = 200, $iPanelHeight = 200, $iPanelStyle = 0, $iDisplayState = @SW_SHOWNA, $vBackground = Default)
; Parameters ....: $hPanelParentWnd	- Parent window handle to create the panel wnd
;				   $sDisplayPosType (optional) - Coords: Sets the panel position according to the given coords (next parameters)
;									  TopCenter, Centered, BottomCenter, TopRight, CenterRight, BottomRight, CenterLeft, Centered, CenterRight, BottomLeft, BottomCenter, BottomRight
;				   $iPanelLeft		(optional) - Panel left pos
;				   $iPanelTop		(optional) - Panel top pos
;				   $iPanelWidth		(optional) - Panel width
;				   $iPanelHeight	(optional) - Panel height
;				   $iPanelStyle		(optional) - Additional style of the panel to the $WS_CHILD one
;				   $iDisplayState	(optional) - Display of the panel (default = show no active)
;				   $vBackground		(optional) - Background color/picture
; Return values .: Success	- Panel wnd handle
;                  Failure	- -1: Get parent wnd size error
;							  -2: Create panel wnd error
;							  -3: Get parent wnd size
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPanel_Delete
; ===============================================================================================================================
Func _GUICtrlPanel_Create($hPanelParentWnd, $sDisplayPosType = "Coords", $iPanelLeft = 0, $iPanelTop = 0, $iPanelWidth = 200, $iPanelHeight = 200, $iPanelStyle = 0, $iDisplayState = @SW_SHOWNOACTIVATE, $vBackground = Default)
	If $sDisplayPosType <> "Coords" Then
		Local $aPanelParentWndClientSize = WinGetClientSize($hPanelParentWnd)
		If IsArray($aPanelParentWndClientSize) = 0 Then Return -1

		Switch $sDisplayPosType
			Case "TopCenter", "Centered", "BottomCenter"
				;horz centered
				$iPanelLeft = Round($aPanelParentWndClientSize[0] / 2 - $iPanelWidth / 2)
			Case "TopRight", "CenterRight", "BottomRight"
				;right
				$iPanelLeft = $aPanelParentWndClientSize[0] - $iPanelWidth
		EndSwitch

		Switch $sDisplayPosType
			Case "CenterLeft", "Centered", "CenterRight"
				;vert centered
				$iPanelTop = Round($aPanelParentWndClientSize[1] / 2 - $iPanelHeight / 2)
			Case "BottomLeft", "BottomCenter", "BottomRight"
				;bottom
				$iPanelTop = $aPanelParentWndClientSize[1] - $iPanelHeight
		EndSwitch
	EndIf

	Local $hGUI = GUICreate("Panel", $iPanelWidth, $iPanelHeight, $iPanelLeft, $iPanelTop, BitOR($WS_CHILD, $iPanelStyle), Default, $hPanelParentWnd)
	If $hGUI = 0 Then Return -2

	If $vBackground <> Default Then
		If IsString($vBackground) = 1 Then
			$__hBackgroundPic = GUICtrlCreatePic($vBackground, 0, 0, $iPanelWidth, $iPanelHeight)
			GUICtrlSetState($__hBackgroundPic, $GUI_DISABLE)
		ElseIf IsInt($vBackground) = 1 Then
			GUISetBkColor($vBackground, $hGUI)
		EndIf
	EndIf

	GUISetState($iDisplayState, $hGUI)

	Return $hGUI
EndFunc   ;==>_GUICtrlPanel_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_Delete
; Description ...: Deletes the specified panel wnd
; Syntax.........: _Delete($hPanelWnd)
; Parameters ....: $hPanelWnd	- Window handle of the panel
; Return values .: Success	- 1
;                  Failure	- 0
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPanel_Create
; ===============================================================================================================================
Func _GUICtrlPanel_Delete($hPanelWnd)
	Return GUIDelete($hPanelWnd)
EndFunc   ;==>_GUICtrlPanel_Delete

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_SetState
; Description ...: Sets the state of the specified panel wnd
; Syntax.........: _GUICtrlPanel_SetState($hPanelWnd, $iPanelState = @SW_SHOW)
; Parameters ....: $hPanelWnd	- Window handle of the panel
;				   $iPanelState	- (optional) Display state which can be GUI / Wnd Macro constants
; Return values .: Success	- 1
;                  Failure	- 0
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPanel_GetState
; ===============================================================================================================================
Func _GUICtrlPanel_SetState($hPanelWnd, $iPanelState = @SW_SHOW)
	Switch $iPanelState
		Case $GUI_SHOW
			$iPanelState = @SW_SHOW
		Case $GUI_HIDE
			$iPanelState = @SW_HIDE
		Case $GUI_ENABLE
			$iPanelState = @SW_ENABLE
		Case $GUI_DISABLE
			$iPanelState = @SW_DISABLE
	EndSwitch

	Return WinSetState($hPanelWnd, "", $iPanelState)
EndFunc   ;==>_GUICtrlPanel_SetState

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_GetState
; Description ...: Gets the state of the specified panel wnd
; Syntax.........: _GUICtrlPanel_GetState($hPanelWnd)
; Parameters ....: $hPanelWnd	- Window handle of the panel
; Return values .: Success	- Panel wnd state
;                  Failure	- 0
; Author ........: FireFox
; Modified.......:
; Remarks .......: Display state returned as wnd macro
; Related .......: _GUICtrlPanel_SetState
; ===============================================================================================================================
Func _GUICtrlPanel_GetState($hPanelWnd)
	Return WinGetState($hPanelWnd)
EndFunc   ;==>_GUICtrlPanel_GetState

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_SetPos
; Description ...: Sets the position of the specified panel wnd
; Syntax.........: _GUICtrlPanel_SetPos($hPanelWnd, $sDisplayPosType = "Coords", $iPanelLeft = Default, $iPanelTop = Default, $iPanelWidth = Default, $iPanelHeight = Default)
; Parameters ....: $hPanelWnd		- Window handle of the panel
;				   $sDisplayPosType	(optional) - Display positon type which can take the following values : Coords, TopLeft, TopCenter, TopRight, CenterLeft, Centered, CenterRight, BottomLeft, BottomCenter, BottomRight
;				   $iPanelLeft		(optional) - Panel left pos
;				   $iPanelTop		(optional) - Panel top pos
;				   $iPanelWidth		(optional) - Panel width
;				   $iPanelHeight	(optional) - Panel height
; Return values .: Success	- 1
;                  Failure	- 0: Move panel error
;				   |-1: Get panel wnd size error
;				   |-2: Get panel parent wnd size error
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPanel_GetPos
; ===============================================================================================================================
Func _GUICtrlPanel_SetPos($hPanelWnd, $sDisplayPosType = "Coords", $iPanelLeft = Default, $iPanelTop = Default, $iPanelWidth = Default, $iPanelHeight = Default)
	Local $aPanelWndSize = _GUICtrlPanel_GetSize($hPanelWnd)
	If IsArray($aPanelWndSize) = 0 Then Return -1

	If $sDisplayPosType <> "Coords" Then
		$iPanelLeft = 0
		$iPanelTop = 0

		Local $aPanelParentWndSize = WinGetClientSize(__WinAPI_GetParent($hPanelWnd))
		If Not IsArray($aPanelParentWndSize) Then Return -2

		Switch $sDisplayPosType
			Case "TopCenter", "Centered", "BottomCenter"
				;horz centered
				$iPanelLeft = Round($aPanelParentWndSize[0] / 2 - $aPanelWndSize[0] / 2)
			Case "TopRight", "CenterRight", "BottomRight"
				;right
				$iPanelLeft = Round($aPanelParentWndSize[0] - $aPanelWndSize[0])
		EndSwitch

		Switch $sDisplayPosType
			Case "CenterLeft", "Centered", "CenterRight"
				;vert centered
				$iPanelTop = Round($aPanelParentWndSize[1] / 2 - $aPanelWndSize[1] / 2)
			Case "BottomLeft", "BottomCenter", "BottomRight"
				;bottom
				$iPanelTop = Round($aPanelParentWndSize[1] - $aPanelWndSize[1])
		EndSwitch
	Else
		If $iPanelWidth = Default Or $iPanelHeight = Default Then
			If $iPanelWidth = Default Then
				$iPanelWidth = $aPanelWndSize[0]
			EndIf
			If $iPanelHeight = Default Then
				$iPanelHeight = $aPanelWndSize[1]
			EndIf
		EndIf

		If $iPanelLeft = Default Or $iPanelTop = Default Then
			Local $aPanelWndPos = _GUICtrlPanel_GetPos($hPanelWnd)
			If Not IsArray($aPanelWndPos) Then Return -3

			If $iPanelLeft = Default Then
				$iPanelLeft = $aPanelWndPos[0]
			EndIf
			If $iPanelTop = Default Then
				$iPanelTop = $aPanelWndPos[1]
			EndIf
		EndIf
	EndIf

	Local $iMoveReturn = WinMove($hPanelWnd, "", $iPanelLeft, $iPanelTop, $iPanelWidth, $iPanelHeight)
	If $iMoveReturn > 0 Then
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_GUICtrlPanel_SetPos

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_GetPos
; Description ...: Gets the position of the specified panel wnd
; Syntax.........: _GUICtrlPanel_GetPos($hPanelWnd)
; Parameters ....: $hPanelWnd	- Window handle of the panel
; Return values .: Success	- Array containing the panel position
;                  Failure	- -1: Get parent wnd pos error
;				   |-2: Get panel wnd pos error
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPanel_SetPos
; ===============================================================================================================================
Func _GUICtrlPanel_GetPos($hPanelWnd)
	Local $aPanelScreenPos = 0, $hCoordsPanelWnd = 0, $aReturnPos[2], $iSwitchedGUI = _GetCurrentGUI()

	$aPanelScreenPos = WinGetPos($hPanelWnd)

	$hCoordsPanelWnd = _GUICtrlPanel_Create(__WinAPI_GetParent($hPanelWnd), "Coords", 0, 0, 200, 200, 0, @SW_HIDE)

	Local $aPanelCoordsScreenPos = WinGetPos($hCoordsPanelWnd)

	_GUICtrlPanel_Delete($hCoordsPanelWnd)

	GUISwitch($iSwitchedGUI)

	If IsArray($aPanelCoordsScreenPos) = 0 Then Return -1
	If IsArray($aPanelScreenPos) = 0 Then Return -2

	$aReturnPos[0] = $aPanelScreenPos[0] - $aPanelCoordsScreenPos[0]
	$aReturnPos[1] = $aPanelScreenPos[1] - $aPanelCoordsScreenPos[1]

	Return $aReturnPos
EndFunc   ;==>_GUICtrlPanel_GetPos

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_GetSize
; Description ...: Gets the size of the specified panel wnd
; Syntax.........: _GUICtrlPanel_GetSize($hPanelWnd)
; Parameters ....: $hPanelWnd	- Window handle of the panel
; Return values .: Success	- Array containing the panel size
;				   Failure	- See WinGetClientSize
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......:
; ===============================================================================================================================
Func _GUICtrlPanel_GetSize($hPanelWnd)
	Return WinGetClientSize($hPanelWnd)
EndFunc   ;==>_GUICtrlPanel_GetSize

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPanel_SetBackground
; Description ...: Sets the background color/image of the specified panel wnd
; Syntax.........: _GUICtrlPanel_SetBackground($hPanelWnd, $vBackground)
; Parameters ....: $hPanelWnd	- Window handle of the panel
;				   $vBackground - Background color/picture
; Return values .: Success	- 1
;                  Failure	- 0: Deletebkpic / Setbkcolor error
;				   |-1: Wrong background var type
;				   |-2: Get panel wnd size error
; Author ........: FireFox
; Modified.......:
; Remarks .......:
; Related .......:
; ===============================================================================================================================
Func _GUICtrlPanel_SetBackground($hPanelWnd, $vBackground)
	Local $iSwitchedGUI = _GetCurrentGUI(), $iReturnValue = -1

	GUISwitch($hPanelWnd)

	If IsString($vBackground) = 1 Then
		If $vBackground = "" And $__hBackgroundPic <> 0 Then
			$iReturnValue = GUICtrlDelete($__hBackgroundPic)
			$__hBackgroundPic = 0
		Else
			Local $aGUICtrlPanelSetBackground = _GUICtrlPanel_GetSize($hPanelWnd)
			If IsArray($aGUICtrlPanelSetBackground) Then
				$__hBackgroundPic = GUICtrlCreatePic($vBackground, 0, 0, $aGUICtrlPanelSetBackground[0], $aGUICtrlPanelSetBackground[1])
				GUICtrlSetState($__hBackgroundPic, $GUI_DISABLE)

				If $__hBackgroundPic > 0 Then
					$iReturnValue = 1
				Else
					$iReturnValue = 0
				EndIf
			Else
				$iReturnValue = -2
			EndIf
		EndIf
	ElseIf IsInt($vBackground) Then
		$iReturnValue = GUISetBkColor($vBackground, $hPanelWnd)
	EndIf

	GUISwitch($iSwitchedGUI)

	Return $iReturnValue
EndFunc   ;==>_SetBackground

Func _GetCurrentGUI() ; By Yashied.
	Local $iLabel = GUICtrlCreateLabel("", 0, -100)
	Local $hHandle = __WinAPI_GetParent(GUICtrlGetHandle($iLabel))
	If @error Then
		Return SetError(@error, 0 * GUICtrlDelete($iLabel), 0)
	EndIf
	GUICtrlDelete($iLabel)
	Return $hHandle
EndFunc   ;==>_GetCurrentGUI

; #FUNCTION# ====================================================================================================================
; Name...........: __WinAPI_GetParent
; Description ...: Retrieves the handle of the specified child window's parent window
; Syntax.........: __WinAPI_GetParent($hWnd)
; Parameters ....: $hWnd        - Window handle of child window
; Return values .: Success      - The handle of the parent window
;                  Failure      - 0
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........: @@MsdnLink@@ GetParent
; Example .......:
; ===============================================================================================================================
Func __WinAPI_GetParent($hWnd)
	Local $aResult = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hWnd)
	If @error Then Return SetError(@error, @extended, 0)
	Return $aResult[0]
EndFunc   ;==>__WinAPI_GetParent
