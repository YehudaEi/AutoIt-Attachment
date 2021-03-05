#Region - TimeStamp
; 2012-07-11 22:09:01   v 0.7
#EndRegion - TimeStamp
#include-once
#Include <GUIConstantsEx.au3>
#Include <Constants.au3>
#include <StaticConstants.au3>
#Include <StructureConstants.au3>
#Include <WindowsConstants.au3>
#Include <WinAPI.au3>

; ======================================================================================================
;	FUNCTIONS
;
;	_GUICtrlOwnContext_Startup			Initialize Functions
;	_GUICtrlOwnContext_Shutdown			Close Ressources, automatically on AutoIt Exit
;	_GUICtrlOwnContext_Create			Create (Context)Menu
;	_GUICtrlOwnContext_AddItem			Create Menu-Item (Default-Item, Checkbox-Item, Radio-Item, Shape)
;	_GUICtrlOwnContext_AddImage			Create Menu-Item with Image (icon, jpg/gif/bmp, colored squares)
;	_GUICtrlOwnContext_ShowFlag			Condition to show Menu (True/False)
;	_GUICtrlOwnContext_SetHoverColor	Sets custom hover color
; ======================================================================================================

OnAutoItExitRegister('_GUICtrlOwnContext_Shutdown')

Global Const $__HC_ACTION = 0
Global $__hGUI_MNUEX, $__hWIN_PROC, $__hHOOK_PROC
Global $__hSTUB__MouseProc, $__hMOD, $__hHOOK
Global $__aHWND_MNU[1][8]                        ; [[hWnd-ParentCtrl, hWnd-Menu, fCondition, Item-Array, Shape-counter, Margin, Width, HoverColor]]  --- Item-Array: [[counter], [fIsRadio], [ID1, iType], [ID2, iType], [..IDn]]
Global $__iMNU_DEF_HOVERCOLOR  = 0xEFFFFF;0xADD8E6
Global $__iMNU_DEF_WIDTH       = 200
Global $__iMNU_DEF_HEIGHT      =  23
Global $__iMNU_DEF_MARGIN      =  10
Global $__iMNU_DEF_LABELSHIFT  =   4
Global $__iMNU_DEF_SHAPEHEIGHT =   3
Global $__hCURRENT_ACTIVE_MNU  =   0

;===============================================================================
; Function Name....: _GUICtrlOwnContext_Startup
; Description......: Initialize functions
; Parameter(s).....: $_hGUI   GUI Handle
; Return Value(s)..: Nothing
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_Startup($_hGUI)
	$__hGUI_MNUEX = $_hGUI
	; == initialize Callback Function to analyze $WM_NOTIFY
	$__hWIN_PROC = DllCallbackRegister('__WinProc', 'ptr', 'hwnd;uint;wparam;lparam')
	$__hHOOK_PROC = _WinAPI_SetWindowLong($__hGUI_MNUEX, $GWL_WNDPROC, DllCallbackGetPtr($__hWIN_PROC))
	; == initialize Callback Function to analyze MOUSE-Message
	$__hSTUB__MouseProc = DllCallbackRegister("__MouseProc", "long", "int;wparam;lparam")
	$__hMOD = _WinAPI_GetModuleHandle(0)
	$__hHOOK = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, DllCallbackGetPtr($__hSTUB__MouseProc), $__hMOD)
EndFunc  ;==>_GUICtrlOwnContext_Startup

;===============================================================================
; Function Name....: _GUICtrlOwnContext_Shutdown
; Description......: Close ressources, automatically on AutoIt exit
; Requirement(s)...: _GUICtrlOwnContext_Startup() must be called before
; Return Value(s)..: Nothing
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_Shutdown()
	_WinAPI_SetWindowLong($__hGUI_MNUEX, $GWL_WNDPROC, $__hHOOK_PROC)
    _WinAPI_UnhookWindowsHookEx($__hHOOK)
    DllCallbackFree($__hSTUB__MouseProc)
EndFunc  ;==>_GUICtrlOwnContext_Shutdown

;===============================================================================
; Function Name....: _GUICtrlOwnContext_Create
; Description......: Create (Context)Menu
; Parameter(s).....: $_hParentCtrl		hWnd or ID of control, for which the menu is to be effective
; .................: $_iWidth			Menu width (-1 = 200 px, Default)
; .................: $_iMarginLeft		Left margin (-1 = 10 px, Default)
; .................: $_iHoverColor		Item hover color, (-1=$__iMNU_DEF_HOVERCOLOR)
; Requirement(s)...: _GUICtrlOwnContext_Startup() must be called before
; Return Value(s)..: Menu Handle
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_Create($_hParentCtrl, $_iWidth=-1, $_iMarginLeft=-1, $_iHoverColor=-1)
	If Not IsHWnd($_hParentCtrl) Then $_hParentCtrl = GUICtrlGetHandle($_hParentCtrl)
	If IsKeyword($_iMarginLeft) Or $_iMarginLeft = -1 Then $_iMarginLeft = $__iMNU_DEF_MARGIN
	If IsKeyword($_iWidth) Or $_iWidth = -1 Then $_iWidth = $__iMNU_DEF_WIDTH
	Local $hMenu = GUICreate('', $_iWidth, $__iMNU_DEF_HEIGHT, -1, -1, BitOR($WS_BORDER,$WS_POPUP), $WS_EX_MDICHILD, $__hGUI_MNUEX)
	If $__aHWND_MNU[UBound($__aHWND_MNU)-1][0] <> '' Then ReDim $__aHWND_MNU[UBound($__aHWND_MNU)+1][8]
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][0] = $_hParentCtrl
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][1] = $hMenu
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][2] = True
	Local $aItem[2][3] = [[0],[False]]
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][3] = $aItem
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][4] = 0
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][5] = $_iMarginLeft
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][6] = $__iMNU_DEF_WIDTH
	If $_iWidth <> $__iMNU_DEF_WIDTH Then $__aHWND_MNU[UBound($__aHWND_MNU)-1][6] = $_iWidth
	$__aHWND_MNU[UBound($__aHWND_MNU)-1][7] = $__iMNU_DEF_HOVERCOLOR
	If $_iHoverColor <> -1 Then $__aHWND_MNU[UBound($__aHWND_MNU)-1][7] = $_iHoverColor
	Return $hMenu
EndFunc  ;==>_GUICtrlOwnContext_Create

;===============================================================================
; Function Name....: _GUICtrlOwnContext_AddItem
; Description......: Create Menu-Item (Default-Item, Checkbox-Item, Radio-Item, Shape)
; Parameter(s).....: $_hMnu			Menu Handle
; .................: $_sText		Item-Text, if empty string (Default) ==> create shape
; .................: $_iType		1=Label (Default), 2=Checkbox, 3=Radio
; .................: $_iMarginLeft	Left margin, only if different from value, that used with _GUICtrlOwnContext_Create
; Requirement(s)...: with _GUICtrlOwnContext_Create menu created
; Return Value(s)..: Success		Item-ID
; .................: Failure		-1, @error=1	on specified handle does not exist
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_AddItem($_hMnu, $_sText='', $_iType=1, $_iMarginLeft=-1)
	Local $iIndexArray = __GetIndexFromMnuArray($_hMnu)
	If @error Then Return SetError(1,0,-1)
	Local $aItem = $__aHWND_MNU[$iIndexArray][3]
	Local $iCountShape = $__aHWND_MNU[$iIndexArray][4]
	Local $iCountEntry = $aItem[0][0] -$iCountShape
	If IsKeyword($_iMarginLeft) Or $_iMarginLeft = -1 Then $_iMarginLeft = $__aHWND_MNU[$iIndexArray][5]
	Local $iWidth = $__aHWND_MNU[$iIndexArray][6]
	Local $iHeight = $__iMNU_DEF_HEIGHT
	If $_sText = '' Then $_iType = 4
	If $_iType = 4 Then $iHeight = $__iMNU_DEF_SHAPEHEIGHT

	Local $iID, $iTop_BackLabel = ($iCountEntry*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT)
	GUICtrlCreateLabel('', 0, $iTop_BackLabel, $iWidth, $iHeight)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetState(-1, $GUI_DISABLE)
	If $_iType = 4 Then $iCountShape += 1

	ReDim $aItem[UBound($aItem)+1][3]
	$aItem[0][0] += 1
	WinMove($_hMnu, '', 10, 10, $iWidth, ($aItem[0][0]-$iCountShape)*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT)
	Local $iItemTop = ($__iMNU_DEF_LABELSHIFT+ $iCountEntry*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT)
	Switch $_iType
		Case 1  ; Standard Label
			$iID = GUICtrlCreateLabel($_sText, $_iMarginLeft, $iItemTop, $iWidth-$_iMarginLeft-2, 17)
		Case 2  ; Checkbox
			$iID = GUICtrlCreateCheckbox($_sText, $_iMarginLeft, $iItemTop-1, $iWidth-$_iMarginLeft-2, 17)
		Case 3  ; Radio
			$iID = GUICtrlCreateRadio($_sText, $_iMarginLeft, $iItemTop-1, $iWidth-$_iMarginLeft-2, 17)
			$aItem[1][0] = True
		Case 4  ; Shape
			$iID = GUICtrlCreateLabel('', 4, ($iCountEntry*$__iMNU_DEF_HEIGHT + ($iCountShape-1)*$__iMNU_DEF_SHAPEHEIGHT), $iWidth-8, 1, $SS_GRAYFRAME)
	EndSwitch
	GUICtrlSetResizing($iID, $GUI_DOCKALL)

	$aItem[$aItem[0][0]+1][0] = $iID
	$aItem[$aItem[0][0]+1][1] = $_iType
	$__aHWND_MNU[$iIndexArray][3] = $aItem
	$__aHWND_MNU[$iIndexArray][4] = $iCountShape
	Return $iID
EndFunc  ;==>_GUICtrlOwnContext_AddItem

;===============================================================================
; Function Name....: _GUICtrlOwnContext_AddImage
; Description......: Create Menu-Item with Image (icon, jpg/gif/bmp, colored squares)
; Parameter(s).....: $_hMnu			Menu Handle
; .................: $_sText		Item-Text
; .................: $_sPathImage	Path image file
; .................: $_sIconName	Name or number of icon inside icon file with multiple icons, -1 (Default)
; .................: $_iType		1=Picture(bmp,jpg,gif), 2=Icon, 3=colored squares
; .................: $_iMarginLeft	Left margin, only if different from value, that used with _GUICtrlOwnContext_Create
; .................: $_iColor		Color for squares
; Requirement(s)...: with _GUICtrlOwnContext_Create menu created
; Return Value(s)..: Success		Item-ID
; .................: Failure		-1, @error=1	on specified handle does not exist
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_AddImage($_hMnu, $_sText, $_sPathImage='', $_sIconName=-1, $_iType=1, $_iMarginLeft=-1, $_iColor=0xFFFFFF)
	Local $iIndexArray = __GetIndexFromMnuArray($_hMnu)
	If @error Then Return SetError(1,0,-1)
	Local $aItem = $__aHWND_MNU[$iIndexArray][3]
	Local $iCountShape = $__aHWND_MNU[$iIndexArray][4]
	Local $iCountEntry = $aItem[0][0] -$iCountShape
	If IsKeyword($_iMarginLeft) Or $_iMarginLeft = -1 Then $_iMarginLeft = $__aHWND_MNU[$iIndexArray][5]
	Local $iWidth = $__aHWND_MNU[$iIndexArray][6]

	Local $iID, $iTop_BackLabel = ($iCountEntry*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT)
	GUICtrlCreateLabel('', 0, $iTop_BackLabel, $iWidth, $__iMNU_DEF_HEIGHT)
	GUICtrlSetResizing(-1, $GUI_DOCKALL)
	GUICtrlSetState(-1, $GUI_DISABLE)

	ReDim $aItem[UBound($aItem)+1][3]
	$aItem[0][0] += 1
	WinMove($_hMnu, '', 10, 10, $iWidth, ($aItem[0][0]-$iCountShape)*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT)
	Local $iItemTop = ($__iMNU_DEF_LABELSHIFT+ $iCountEntry*$__iMNU_DEF_HEIGHT + $iCountShape*$__iMNU_DEF_SHAPEHEIGHT), $iIDPic
	If $_iMarginLeft < 2 Then $_iMarginLeft = 2
	Switch $_iType
		Case 1
			Local $iStyle = $SS_NOTIFY
			If StringRight($_sPathImage, 3) = 'bmp' Then $iStyle = BitOR($iStyle,$SS_BITMAP)
			$iIDPic = GUICtrlCreatePic($_sPathImage, $_iMarginLeft -2, $iItemTop-1, 16, 16, $iStyle)
			$iID = GUICtrlCreateLabel($_sText, $_iMarginLeft +16 , $iItemTop, $iWidth-$_iMarginLeft-18, 17)
		Case 2
			$iIDPic = GUICtrlCreateIcon($_sPathImage, $_sIconName, $_iMarginLeft -2, $iItemTop-1, 16, 16, BitOR($SS_NOTIFY,$SS_ICON))
			$iID = GUICtrlCreateLabel($_sText, $_iMarginLeft +16 , $iItemTop, $iWidth-$_iMarginLeft-18, 17)
		Case 3
			$iIDPic = GUICtrlCreateLabel('', $_iMarginLeft -2, $iItemTop-1, 16, 16)
			GUICtrlSetBkColor(-1, $_iColor)
			$iID = GUICtrlCreateLabel($_sText, $_iMarginLeft +16 , $iItemTop, $iWidth-$_iMarginLeft-18, 17)
	EndSwitch
	GUICtrlSetResizing($iIDPic, $GUI_DOCKALL)
	GUICtrlSetResizing($iID, $GUI_DOCKALL)

	$aItem[$aItem[0][0]+1][0] = $iID
	$aItem[$aItem[0][0]+1][1] = 1
	$__aHWND_MNU[$iIndexArray][3] = $aItem
	Return $iID
EndFunc  ;==>_GUICtrlOwnContext_AddImage

;===============================================================================
; Function Name....: _GUICtrlOwnContext_ShowFlag
; Description......: Condition to show Menu (True/False)
; .................: If the condition is TRUE, the menu will displayed.
; Parameter(s).....: $_hMnu			Menu Handle
; .................: $_fFlag		Boolean expression (eg a test function to return True / False)
; Requirement(s)...: with _GUICtrlOwnContext_Create menu created
; Return Value(s)..: Nothing
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_ShowFlag($_hMnu, $_fFlag=False)
	For $i = 0 To UBound($__aHWND_MNU) -1
		If $__aHWND_MNU[$i][1] = $_hMnu Then
			$__aHWND_MNU[$i][2] = $_fFlag
			Return
		EndIf
	Next
EndFunc  ;==>_GUICtrlOwnContext_ShowFlag

;===============================================================================
; Function Name....: _GUICtrlOwnContext_SetHoverColor
; Description......: Sets custom hover color
; Parameter(s).....: $_hMnu		Menu Handle
; .................: $_iColor	custom RGB color
; Requirement(s)...: with _GUICtrlOwnContext_Create menu created
; Return Value(s)..:
; Author(s)........: BugFix ( bugfix@autoit.de )
;===============================================================================
Func _GUICtrlOwnContext_SetHoverColor($_hMnu, $_iColor=$__iMNU_DEF_HOVERCOLOR)
	Local $iIndexArray = __GetIndexFromMnuArray($_hMnu)
	If @error Then Return SetError(1,0,$iIndexArray)
	$__aHWND_MNU[$iIndexArray][7] = $_iColor
	Return '0x' & Hex($_iColor,6)
EndFunc  ;==>_GUICtrlOwnContext_SetHoverColor

#region - internal functions
;===============================================================================
; Function Name....: __IsHover
; Description......: Checks if the mouse is over an entry. Change background color, if so.
;===============================================================================
Func __IsHover()
	Local Static $iID_LastOver = 0
	If $__hCURRENT_ACTIVE_MNU = 0 Then Return
	Local $aCursor = GUIGetCursorInfo()
	If Not IsArray($aCursor) Then Return
	Local $iID = $aCursor[4]
	Local $iIndexArray = __GetIndexFromMnuArray($__hCURRENT_ACTIVE_MNU)
	Local $aItem = $__aHWND_MNU[$iIndexArray][3]
	Local $iWidth = $__aHWND_MNU[$iIndexArray][6]
	Local $aMPos[2] = [$aCursor[0],$aCursor[1]]
	Local $iHoverColor = $__aHWND_MNU[$iIndexArray][7]
	For $i = 2 To $aItem[0][0] +1
		If __MouseOverCtrl($__hCURRENT_ACTIVE_MNU, $aItem[$i][0], $aMPos) And _
			$iID_LastOver <> $aItem[$i][0] And _
			ControlGetText($__hCURRENT_ACTIVE_MNU, '', $aItem[$i][0]) <> '' And _
			BitAND(GUICtrlGetState($aItem[$i][0]), $GUI_ENABLE) Then
			If $iID_LastOver <> 0 Then GUICtrlSetBkColor($iID_LastOver, $GUI_BKCOLOR_TRANSPARENT)
			$iID_LastOver = $aItem[$i][0]
			GUICtrlSetBkColor($aItem[$i][0], $iHoverColor)
			ExitLoop
		EndIf
	Next
EndFunc  ;==>__IsHover

;===============================================================================
; Function Name....: __GetIndexFromMnuArray
; Description......: Search index from menu array for given menu handle
;===============================================================================
Func __GetIndexFromMnuArray($_hMnu)
	For $i = 0 To UBound($__aHWND_MNU) -1
		If $__aHWND_MNU[$i][1] = $_hMnu Then
			Return $i
		EndIf
	Next
	Return SetError(1,0,-1)
EndFunc  ;==>__GetIndexFromMnuArray

;===============================================================================
; Function Name....: __WinProc
; Description......: Callback windows procedure
;===============================================================================
Func __WinProc($hWnd, $Msg, $wParam, $lParam)
	Switch $Msg
		Case $WM_NOTIFY
			Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $iOldOpt, $aMPos

			$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
			$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
			$iCode = DllStructGetData($tNMHDR, "Code")

			$iOldOpt = Opt('MouseCoordMode', 1)
			$aMPos = MouseGetPos()
			Opt('MouseCoordMode', $iOldOpt)

			; == Menu is shown, clicked outside menu, but inside assigned control ==> Menu hide
			If $__hCURRENT_ACTIVE_MNU <> 0 And $iCode = $NM_CLICK Then
				Local $tPoint = DllStructCreate('int;int')
				DllStructSetData($tPoint, 1, $aMPos[0])
				DllStructSetData($tPoint, 2, $aMPos[1])
				Local $tRectContext = _WinAPI_GetWindowRect($__hCURRENT_ACTIVE_MNU)
				If Not _WinAPI_PtInRect($tRectContext, $tPoint) Then
					GUISetState(@SW_HIDE, $__hCURRENT_ACTIVE_MNU)
					AdlibUnRegister('__IsHover')
					$__hCURRENT_ACTIVE_MNU = 0
					Return _WinAPI_CallWindowProc($__hHOOK_PROC, $hWnd, $Msg, $wParam, $lParam)
				EndIf
			EndIf

			; == Menu show
			Switch $iCode
				Case $NM_RCLICK
					For $i = 0 To UBound($__aHWND_MNU) -1
						If $hWndFrom = $__aHWND_MNU[$i][0] Then
							If $__aHWND_MNU[$i][2] Then                        ; == Condition True?
								$__hCURRENT_ACTIVE_MNU = $__aHWND_MNU[$i][1]
								Local $aWin = WinGetPos($__hGUI_MNUEX)
								Local $aWinMnu = WinGetPos($__hCURRENT_ACTIVE_MNU)
		   						Local $iX = $aMPos[0], $iY = $aMPos[1]
								If $iX +$aWinMnu[2] > @DesktopWidth Then $iX -= $aWinMnu[2]
								If $iY +$aWinMnu[3] > @DesktopHeight Then $iY -= $aWinMnu[3]
								WinMove($__hCURRENT_ACTIVE_MNU, '', $iX, $iY)
								AdlibRegister('__IsHover', 10)
								GUISetState(@SW_SHOW, $__hCURRENT_ACTIVE_MNU)
							EndIf
							ExitLoop
						EndIf
					Next
			EndSwitch
		Case Else
			Return _WinAPI_CallWindowProc($__hHOOK_PROC, $hWnd, $Msg, $wParam, $lParam)
	EndSwitch
EndFunc   ;==>__WinProc

;===============================================================================
; Function Name....: __MouseProc
; Description......: Callback mouse procedure
;===============================================================================
Func __MouseProc($nCode, $wParam, $lParam)
	If $nCode < 0  Or $__hCURRENT_ACTIVE_MNU = 0 Then
		Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
	EndIf
	Local $iCtrl = 0, $iType, $aItem
	Local $iOldOpt = Opt('MouseCoordMode', 2)
	Local $aMPos = MouseGetPos()
	Opt('MouseCoordMode', $iOldOpt)
	For $i = 0 To UBound($__aHWND_MNU) -1
		If $__aHWND_MNU[$i][1] = $__hCURRENT_ACTIVE_MNU Then
			$aItem = $__aHWND_MNU[$i][3]
			For $j = 2 To $aItem[0][0] +1
				If __MouseOverCtrl($__hCURRENT_ACTIVE_MNU, $aItem[$j][0], $aMPos) Then
					$iCtrl = $aItem[$j][0]
					$iType = $aItem[$j][1]
					ExitLoop(2)
				EndIf
			Next
		EndIf
	Next

	If $nCode = $__HC_ACTION Then
		Switch $wParam
			Case $WM_RBUTTONDOWN
				If $iCtrl <> 0 Then
					Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
				Else
					__MenuHide()
					Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
				EndIf
			Case $WM_LBUTTONDOWN
				If $iCtrl <> 0 Then
					; ctrl is disabled ==> do nothing
					If BitAND(GUICtrlGetState($iCtrl), $GUI_DISABLE) Then Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
					; set state for checkbox/radios
					If $iType = 2 Then
						GUICtrlSetState($iCtrl, BitXOR(BitOR($GUI_CHECKED, $GUI_UNCHECKED), BitAND(GUICtrlRead($iCtrl),$GUI_CHECKED)))
					ElseIf $iType = 3 Then
						GUICtrlSetState($iCtrl, BitXOR(BitOR($GUI_CHECKED, $GUI_UNCHECKED), BitAND(GUICtrlRead($iCtrl),$GUI_CHECKED)))
						For $j = 2 To $aItem[0][0] +1
							If $aItem[$j][1] <> 3 Or $aItem[$j][0] = $iCtrl Then ContinueLoop
							GUICtrlSetState($aItem[$j][0], $GUI_UNCHECKED)
						Next
					EndIf
				Else
					__MenuHide()
					Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
				EndIf
				_WinAPI_PostMessage($__hGUI_MNUEX, $WM_COMMAND, $iCtrl, 0)
				__MenuHide()
				Return -1
		EndSwitch
	EndIf
	Return _WinAPI_CallNextHookEx($__hHOOK, $nCode, $wParam, $lParam)
EndFunc  ;==>__MouseProc

;===============================================================================
; Function Name....: __MenuHide
; Description......: Hides menu and stops hover check
;===============================================================================
Func __MenuHide()
	AdlibUnRegister('__IsHover')
	GUISetState(@SW_HIDE, $__hCURRENT_ACTIVE_MNU)
	GUISetState(@SW_SHOW, $__hGUI_MNUEX)
	$__hCURRENT_ACTIVE_MNU = 0
EndFunc  ;==>__MenuHide

;===============================================================================
; Function Name....: __MouseOverCtrl
; Description......: Checks if mouse is over an given control
;===============================================================================
Func __MouseOverCtrl($_hGUI, $_iID, $_aMPos)
	Local $posC = ControlGetPos($_hGUI, '', $_iID)
	If @error Then Return False
	If ($_aMPos[0] >= $posC[0] And $_aMPos[0] <= $posC[0]+$posC[2]) And _
	   ($_aMPos[1] >= $posC[1] And $_aMPos[1] <= $posC[1]+$posC[3]) Then
	   Return True
	Else
	   Return False
	EndIf
EndFunc  ;==>__MouseOverCtrl

#endregion
