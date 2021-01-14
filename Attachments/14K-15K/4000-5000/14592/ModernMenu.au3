#include-once
#include<color.au3>

;********************************************************************
; CommCtrl.h - constants
;********************************************************************

Global Const $ILC_MASK				= 0x0001
Global Const $ILC_COLOR32			= 0x0020

Global Const $ILD_TRANSPARENT		= 0x0001
Global Const $ILD_BLEND				= 0x0004


;********************************************************************
; WinGDI.h - constants
;********************************************************************

Global Const $SRCCOPY				= 0x00CC0020


;********************************************************************
; WinUser.h- - constants
;********************************************************************

Global Const $WM_DRAWITEM			= 0x002B
Global Const $WM_MEASUREITEM		= 0x002C

Global Const $MF_BYCOMMAND			= 0x00000000
Global Const $MF_OWNERDRAW			= 0x00000100
Global Const $MF_SEPARATOR			= 0x00000800

Global Const $SM_CXSMICON			= 49
Global Const $SM_CXMENUCHECK		= 71

Global Const $ODT_MENU				= 1

Global Const $ODS_SELECTED			= 0x0001
Global Const $ODS_GRAYED			= 0x0002
Global Const $ODS_DISABLED			= 0x0004
Global Const $ODS_CHECKED			= 0x0008

Global Const $DT_VCENTER			= 0x00000004
Global Const $DT_SINGLELINE			= 0x00000020
Global Const $DT_NOCLIP				= 0x00000100

Global Const $COLOR_MENUTEXT		= 7
Global Const $COLOR_GRAYTEXT		= 17
;Global Const $CLR_NONE				= 0xFFFFFFFF

Global Const $BF_TOP				= 0x0002

Global Const $EDGE_ETCHED			= 0x0006

Global Const $DFC_MENU				= 2

Global Const $DFCS_MENUCHECK		= 0x0001
Global Const $DFCS_MENUBULLET		= 0x0002


;********************************************************************
; Main Creation Part
;********************************************************************

; Set default color values if not given
Global $nMenuBkClr					= 0xFFFFFF
Global $nMenuIconBkClr				= 0xCACACA
Global $nMenuSelectBkClr			= 0xE5A2A0
Global $nMenuSelectRectClr			= 0x854240
Global $nMenuSelectTextClr			= 0x000000
Global $nMenuTextClr				= 0x000000
Global $nMenuIconGradBkClr			= 0xEFEFEF

; Store here the ID/Text/IconIndex/ParentMenu
Global $arMenuItems[1000][5]
$arMenuItems[0][0] = 0

; Create a usable font for using in ownerdrawn menus
Global $hMenuFont		= CreateMenuFont('MS Sans Serif')

; Create an image list for saving/drawing our menu icons
Global $hMenuImageList	= ImageList_Create(16, 16, BitOr($ILC_MASK, $ILC_COLOR32), 0, 1)

GUIRegisterMsg($WM_DRAWITEM, 'My_WM_Drawitem')
GUIRegisterMsg($WM_MEASUREITEM, 'My_WM_MeasureItem')



; Cleanup
Func OnAutoItExit()
	ImageList_Destroy($hMenuImageList)
	DeleteObject($hMenuFont)
	$arMenuItems = 0
EndFunc


;********************************************************************
; Define the colors for the menu/selection bar
;********************************************************************

Func _SetMenuBkColor($nColor)
	$nMenuBkClr				= $nColor
EndFunc

Func _SetMenuIconBkColor($nColor)
	$nMenuIconBkClr			= $nColor
EndFunc

Func _SetMenuSelectBkColor($nColor)
	$nMenuSelectBkClr		= $nColor
EndFunc

Func _SetMenuSelectRectColor($nColor)
	$nMenuSelectRectClr		= $nColor
EndFunc

Func _SetMenuSelectTextColor($nColor)
	$nMenuSelectTextClr		= $nColor
EndFunc

Func _SetMenuTextColor($nColor)
	$nMenuTextClr			= $nColor
EndFunc

Func _SetMenuIconGradBkColor($nColor)
	$nMenuIconGradBkClr		= $nColor
EndFunc

;********************************************************************
; Out WM_MEASURE procedure
;********************************************************************

Func My_WM_MeasureItem($hWnd, $Msg, $wParam, $lParam)
	$nResult = FALSE
	
	Local $stMeasureItem = DllStructCreate('uint;uint;uint;uint;uint;dword', $lParam)
	
	If DllStructGetData($stMeasureItem, 1) = $ODT_MENU Then
	
		$nIconSize		= 0
		$nCheckX		= 0
		$nSpace			= 2
		
		GetMenuInfos($nIconSize, $nCheckX)
		
		If $nIconSize < $nCheckX Then $nIconSize = $nCheckX
		
		
		; Reassign the current menu font to the menuitem
		$hDC		= GetDC($hWnd)
		$hFont		= SelectObject($hDC, $hMenuFont)
	
		$nMenuItemID= DllStructGetData($stMeasureItem, 3)
		$hMenu		= GetMenuHandle($nMenuItemID)
		
		$sText		= GetMenuText($nMenuItemID)
		
		Local $stText = DllStructCreate('char[260]')
		DllStructSetData($stText, 1, $sText)
		

		Local $stSize = DllStructCreate('int;int')
		
		$nMaxTextWidth = GetMenuMaxTextWidth($hDC, $hMenu)

		$nHeight	= 2 * $nSpace + $nIconSize
		$nWidth		= 0
	
		; Set a default separator height
		If $sText = '' Then
			$nHeight = 4
		Else
			$nWidth	= 6 * $nSpace + 2 * $nIconSize + $nMaxTextWidth
			
			; Maybe this differs - have no emulator here at the moment
			If @OSVersion <> 'WIN_98' And @OSVersion <> 'WIN_ME' Then 
				$nWidth = $nWidth - $nCheckX + 1
			EndIf
		EndIf

		DllStructSetData($stMeasureItem, 4, $nWidth)	; ItemWidth
		DllStructSetData($stMeasureItem, 5, $nHeight)	; ItemHeight

		SelectObject($hDC, $hFont)
		$stMenuLogFont = 0
		
		ReleaseDC($hWnd, $hDC)
		$nResult = TRUE
	EndIf

	$stMeasureItem	= 0

	Return $nResult
EndFunc


;********************************************************************
; Our WM_DRAWITEM procedure
;********************************************************************

Func My_WM_Drawitem($hWnd, $Msg, $wParam, $lParam)
	$nResult = FALSE
	
	Local $stDrawItem = DllStructCreate('uint;uint;uint;uint;uint;dword;dword;int[4];dword', $lParam)
	
	If DllStructGetData($stDrawItem, 1) = $ODT_MENU Then
		$nMenuItemID	= DllStructGetData($stDrawItem, 3)
		$nState			= DllStructGetData($stDrawItem, 5)
		$hDC			= DllStructGetData($stDrawItem, 7)
		
		$bChecked		= BitAnd($nState, $ODS_CHECKED)
		$bGrayed		= BitAnd($nState, $ODS_GRAYED)
		$bSelected		= BitAnd($nState, $ODS_SELECTED)
		$bIsRadio		= GetMenuIsRadio($nMenuItemID)
		
		Dim $arItemRect[4]
		$arItemRect[0]	= DllStructGetData($stDrawItem, 8, 1)
		$arItemRect[1]	= DllStructGetData($stDrawItem, 8, 2)
		$arItemRect[2]	= DllStructGetData($stDrawItem, 8, 3)
		$arItemRect[3]	= DllStructGetData($stDrawItem, 8, 4)

		Local $stItemRect = DllStructCreate('int;int;int;int')
		DllStructSetData($stItemRect, 1, $arItemRect[0])
		DllStructSetData($stItemRect, 2, $arItemRect[1])
		DllStructSetData($stItemRect, 3, $arItemRect[2])
		DllStructSetData($stItemRect, 4, $arItemRect[3])
		
		; Set default menu values if info function fails
		$nIconSize		= 16
		$nCheckX		= 16
		$nSpace			= 2

		GetMenuInfos($nIconSize, $nCheckX)
		
		; Select our at beginning selfcreated menu font into the item device context
		$hFont			= SelectObject($hDC, $hMenuFont)
		
		$hBorderBrush = 0
		; Only show a menu bar when the item is enabled
		If $bSelected And Not $bGrayed Then
			; $hBrush		= GetSysColorBrush($COLOR_HIGHLIGHT)
			; $nClrSel		= GetSysColor($COLOR_HIGHLIGHT)
			; Are the default commands to get the system highlight background color
			;
			$hBorderBrush	= CreateSolidBrush($nMenuSelectRectClr)
			$hBrush			= CreateSolidBrush($nMenuSelectBkClr) ; BGR color value
			$nClrSel		= $nMenuSelectBkClr
		Else
			$hBrush		= CreateSolidBrush($nMenuBkClr)
			$nClrSel	= $nMenuBkClr
		EndIf
		
		If $bSelected And Not $bGrayed Then
			; $nClrTxt	= SetTextColor($hDC, GetSysColor($COLOR_HIGHLIGHTTEXT))
			; Is the default command to get the system highlight text color
			; 
			; If you want to use a selfdefined item selection text color then just do i.e.:
			; $nClrTxt	= SetTextColor($hDC, 0x00FFFF) ; BGR color value - in this case 'yellow'
			;
			$nClrTxt	= SetTextColor($hDC, $nMenuSelectTextClr);
			;
			; Or change the color different from the MenuItemID
			;If $nMenuItemID = $nExitItem Then SetTextColor($hDC, 0x4466FF)
			;
		ElseIf $bGrayed Then
			$nClrTxt	= SetTextColor($hDC, GetSysColor($COLOR_GRAYTEXT))
		Else
			$nClrTxt	= SetTextColor($hDC, $nMenuTextClr)
		EndIf
	
		
		$nClrBk		= SetBkColor($hDC, $nClrSel)
		$hOldBrush	= SelectObject($hDC, $hBrush)
		
		FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
		SelectObject($hDC, $hOldBrush)
		DeleteObject($hBrush)
		
		; Create a small gray edge
		If Not $bSelected Or $bGrayed Then
			$nTempLeft	= DllStructGetData($stItemRect, 1)
			$nTempTop	= DllStructGetData($stItemRect, 2)
			$nTempRight	= DllStructGetData($stItemRect, 3)
			
			; Reassign the item rect
			DllStructSetData($stItemRect, 1, $arItemRect[0])
			DllStructSetData($stItemRect, 2, $arItemRect[1])
			DllStructSetData($stItemRect, 3, $arItemRect[0] + 2 * $nSpace + $nIconSize + 1)
			
			Local $nX=$arItemRect[0], $nY=$arItemRect[1], $nWidth=2*$nSpace+$nIconSize+1, $nHeight=$arItemRect[3]
			Local $color1R = _ColorGetRed($nMenuIconBkClr)
			Local $color1G = _ColorGetGreen($nMenuIconBkClr)
			Local $color1B = _ColorGetBlue($nMenuIconBkClr)
			Local $nStepR = (_ColorGetRed($nMenuIconGradBkClr) - $color1R) / $nWidth
			Local $nStepG = (_ColorGetGreen($nMenuIconGradBkClr) - $color1G) / $nWidth
			Local $nStepB = (_ColorGetBlue($nMenuIconGradBkClr) - $color1B) / $nWidth
			For $i = $arItemRect[0] to $arItemRect[0]+2*$nSpace+$nIconsize+1 
				$sColor = "0x" & StringFormat("%02X%02X%02X", $color1R+$nStepR*$i, $color1G+$nStepG*$i, $color1B+$nStepB*$i)
				$hBrush	= CreateSolidBrush($sColor)
				$hOldBrush = SelectObject($hDC, $hBrush);
				DllStructSetData($stItemRect, 1, $i-1)
				DllStructSetData($stItemRect, 2, $arItemRect[1])
				DllStructSetData($stItemRect, 3, $i)
				FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBrush)
			Next
		EndIf
		
		If $bChecked Then
			DllStructSetData($stItemRect, 1, $arItemRect[0] + 1)
			DllStructSetData($stItemRect, 2, $arItemRect[1] + 1)
			DllStructSetData($stItemRect, 3, $arItemRect[0] + $nIconSize + $nSpace + 1)
			DllStructSetData($stItemRect, 4, $arItemRect[1] + $nIconSize + $nSpace + 1)

			If $bSelected Then
				$hBrush		= CreateSolidBrush($nMenuSelectBkClr)
			Else
				$hBrush		= CreateSolidBrush($nMenuBkClr)
			EndIf
			
			$hOldBrush	= SelectObject($hDC, $hBrush)
			FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
			SelectObject($hDC, $hOldBrush)
			DeleteObject($hBrush)
			
			$hBrush	= CreateSolidBrush($nMenuSelectRectClr)					
			$hOldBrush	= SelectObject($hDC, $hBrush)
			FrameRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
			SelectObject($hDC, $hOldBrush)
			DeleteObject($hBrush)
			
			; Create a checkmark/bullet for the checked/radio items
			$hDCBitmap	= CreateCompatibleDC($hDC)
			$hbmpCheck	= CreateBitmap($nIconSize, $nIconSize, 1, 1, 0)
			$hbmpOld	= SelectObject($hDCBitmap, $hbmpCheck)
		
			$x = DllStructGetData($stItemRect, 1) + ($nIconSize + $nSpace - $nCheckX) / 2
			$y = DllStructGetData($stItemRect, 2) + ($nIconSize + $nSpace - $nCheckX) / 2 - $nSpace
			
			DllStructSetData($stItemRect, 1, 0)
			DllStructSetData($stItemRect, 2, 0)
			DllStructSetData($stItemRect, 3, $nIconSize)
			DllStructSetData($stItemRect, 4, $nIconSize)
			
			$nCtrlStyle = $DFCS_MENUCHECK
			
			If $bIsRadio Then $nCtrlStyle = $DFCS_MENUBULLET
			
			DrawFrameControl($hDCBitmap, DllStructGetPtr($stItemRect), $DFC_MENU, $nCtrlStyle)
			
			BitBlt($hDC, $x, $y + 1, $nCheckX, $nCheckX, $hDCBitmap, 0, 0, $SRCCOPY)
			
			$hOldBitBrush		= SelectObject($hDCBitmap, $hBrush)
			FillRect($hDCBitmap, DllStructGetPtr($stItemRect), $hBrush)
			
			SelectObject($hDCBitmap, $hbmpOld)
			DeleteObject($hbmpCheck)
			DeleteDC($hDCBitmap)
		EndIf
		
		
		; Reassign the item rect
		DllStructSetData($stItemRect, 1, $arItemRect[0])
		DllStructSetData($stItemRect, 2, $arItemRect[1])
		DllStructSetData($stItemRect, 3, $arItemRect[2])
		DllStructSetData($stItemRect, 4, $arItemRect[3])
			
		If $bSelected And Not $bGrayed Then
			$hOldBrush	= SelectObject($hDC, $hBorderBrush)
			FrameRect($hDC, DllStructGetPtr($stItemRect), $hBorderBrush)
			SelectObject($hDC, $hOldBrush)
			DeleteObject($hBorderBrush)		
		EndIf
		
		$sText = GetMenuText($nMenuItemID)
		
		Local $stText = DllStructCreate('char[' & (StringLen($sText) + 1) & ']')
		DllStructSetData($stText, 1, $sText)
	
		$nSaveLeft = DllStructGetData($stItemRect, 1)
		
		$nLeft	= $nSaveLeft
		$nLeft += $nSpace		; Left border
		$nLeft += $nSpace		; Space after gray border
		$nLeft += $nIconSize	; Icon width
		$nLeft += $nSpace + 2	; Right after the icon
		
		DllStructSetData($stItemRect, 1, $nLeft)
		
		$nFlags = BitOr($DT_NOCLIP, $DT_SINGLELINE, $DT_VCENTER)
		
		DrawText($hDC, _
				DllStructGetPtr($stText), _
				StringLen($sText), _
				DllStructGetPtr($stItemRect), _
				$nFlags)
										
		$nIconIndex = GetMenuIconIndex($nMenuItemID)
		

		If Not $bChecked Then
			If $bGrayed Then
				; An easy way to draw something that looks deactivated
				ImageList_DrawEx($hMenuImageList, _
								$nIconIndex, _
								$hDC, _
								$nSpace, _
								DllStructGetData($stItemRect, 2) + 2, _
								0, _
								0, _
								$CLR_NONE, _
								$CLR_NONE, _
								BitOr($ILD_BLEND, $ILD_TRANSPARENT))
			Else
				; Draw the icon 'normal'
				ImageList_Draw($hMenuImageList, _
							$nIconIndex, _
							$hDC, _
							$nSpace, _
							DllStructGetData($stItemRect, 2) + 2, _
							$ILD_TRANSPARENT)
			EndIf
		EndIf
		
		DllStructSetData($stItemRect, 1, $nSaveLeft)
		
		; Draw a 'line' for a separator item
		If StringLen($sText) = 0 Then
			DllStructSetData($stItemRect, 1, DllStructGetData($stItemRect, 1) + 4 * $nSpace + $nIconSize)
			DllStructSetData($stItemRect, 2, DllStructGetData($stItemRect, 2) + 1)
			DllStructSetData($stItemRect, 4, DllStructGetData($stItemRect, 1) + 2)
			DrawEdge($hDC, DllStructGetPtr($stItemRect), $EDGE_ETCHED, $BF_TOP)
		EndIf
		
		$stText		= 0
		$stRect		= 0
		$stItemRect	= 0
		
		SelectObject($hDC, $hFont)
		$stMenuLogFont = 0
		
		SetTextColor($hDC, $nClrTxt)
		SetBkColor($hDC, $nClrBk)
	
		$nResult = TRUE
	EndIf
	
	$stDrawItem	= 0
	
	Return $nResult	
EndFunc


;********************************************************************
; Create a menu item and set its style to OwnerDrawn
;********************************************************************

Func _GUICtrlCreateODMenuItem($sMenuItemText, $nParentMenuID, $sIconFile = '', $nIconID = 0, $bRadio = 0)
	Local $MenuItemID = GUICtrlCreateMenuItem($sMenuItemText, $nParentMenuID, -1, $bRadio)
	
	$arMenuItems[0][0] += 1
	
	$hMenu = GUICtrlGetHandle($nParentMenuID)
	
	$arMenuItems[$arMenuItems[0][0]][0] = $MenuItemID
	$arMenuItems[$arMenuItems[0][0]][1] = $sMenuItemText
	$arMenuItems[$arMenuItems[0][0]][2] = AddMenuIcon($sIconFile, $nIconID)
	$arMenuItems[$arMenuItems[0][0]][3] = $hMenu
	$arMenuItems[$arMenuItems[0][0]][4] = $bRadio
	
	SetOwnerDrawn($hMenu, $MenuItemID, $sMenuItemText)
	
	Return $MenuItemID
EndFunc


;********************************************************************
; Create a menu and set its style to OwnerDrawn
;********************************************************************

Func _GUICtrlCreateODMenu($sMenuText, $nParentMenuID, $sIconFile = '', $nIconID = 0)
	Local $MenuID = GUICtrlCreateMenu($sMenuText, $nParentMenuID)
	
	$arMenuItems[0][0] += 1
	
	$hMenu = GUICtrlGetHandle($nParentMenuID)
	
	$arMenuItems[$arMenuItems[0][0]][0] = $MenuID
	$arMenuItems[$arMenuItems[0][0]][1] = $sMenuText
	$arMenuItems[$arMenuItems[0][0]][2] = AddMenuIcon($sIconFile, $nIconID)
	$arMenuItems[$arMenuItems[0][0]][3] = $hMenu
	$arMenuItems[$arMenuItems[0][0]][4] = 0
	
	SetOwnerDrawn($hMenu, $MenuID, $sMenuText)
	
	Return $MenuID
EndFunc


;********************************************************************
; Add an icon to our menu image list
;********************************************************************

Func AddMenuIcon($sIconFile, $nIconID)
	Local $stIcon = DllStructCreate('int')
	
	$nCount = ExtractIconEx($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)
	
	$nIndex = -1
	
	If $nCount > 0 Then
		$hIcon	= DllStructGetData($stIcon, 1)
		$nIndex	= ImageList_AddIcon($hMenuImageList, $hIcon)
		DestroyIcon($hIcon)
	EndIf
	
	$stIcon = 0
	
	Return $nIndex
EndFunc


;********************************************************************
; Get the parent menu handle for a menu item
;********************************************************************

Func GetMenuHandle($nMenuItemID)
	$hMenu = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$hMenu = $arMenuItems[$i][3]
			ExitLoop
		EndIf
	Next
	
	Return $hMenu
EndFunc


;********************************************************************
; Get the index of a menu item in our store
;********************************************************************

Func GetMenuIndex($hMenu, $nMenuItemID)
	$nIndex = -1
	
	$nCount = GetMenuItemCount($hMenu)
	
	For $nPos = 0 To $nCount[0] - 1
		$nID = GetMenuItemID($hMenu, $nPos)
		If $nID = $nMenuItemID Then
			$nIndex = $nPos
			ExitLoop
		EndIf
	Next
	
	Return $nIndex
EndFunc


;********************************************************************
; Get the menu item text
;********************************************************************

Func GetMenuText($nMenuItemID)
	$sText = ''
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$sText = $arMenuItems[$i][1]
			ExitLoop
		EndIf
	Next
	
	Return $sText			
EndFunc


;********************************************************************
; Get the maximum text width in a menu
;********************************************************************

Func GetMenuMaxTextWidth($hDC, $hMenu)
	Local $nMaxWidth	= 0
	Local $nWidth		= 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][3] = $hMenu Then
			Local $stSize = DllStructCreate('int;int')
			Local $stText = DllStructCreate('char[260]')
			
			DllStructSetData($stText, 1, $arMenuItems[$i][1])
			
			GetTextExtentPoint32($hDC, _
								DllStructGetPtr($stText), _
								StringLen($arMenuItems[$i][1]), _
								DllStructGetPtr($stSize))
			
			$nWidth = DllStructGetData($stSize, 1)
			
			$stText	= 0
			$stSize	= 0
			
			If $nWidth > $nMaxWidth Then $nMaxWidth = $nWidth
		EndIf
	Next
	
	Return $nMaxWidth
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************

Func GetMenuIsRadio($nMenuItemID)
	$bRadio = 0
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$bRadio = $arMenuItems[$i][4]
			ExitLoop
		EndIf
	Next
	
	Return $bRadio			
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************

Func GetMenuIconIndex($nMenuItemID)
	$nIconIndex = -1
	
	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$nIconIndex = $arMenuItems[$i][2]
			ExitLoop
		EndIf
	Next
	
	Return $nIconIndex			
EndFunc


;********************************************************************
; Get some system menu constants
;********************************************************************

Func GetMenuInfos(ByRef $nS, ByRef $nX)
	$nS	= GetSystemMetrics($SM_CXSMICON)
	$nX	= GetSystemMetrics($SM_CXMENUCHECK)
EndFunc


;********************************************************************
; Convert a normal menu item to an ownerdrawn menu item
;********************************************************************

Func SetOwnerDrawn($hMenu, $MenuItemID, $sText)
	$stItemData = DllStructcreate('int')
	DllStructSetData($stItemData, 1, $MenuItemID)
	
	$nFlags = BitOr($MF_BYCOMMAND, $MF_OWNERDRAW)
	
	If StringLen($sText) = 0 Then $nFlags = BitOr($nFlags, $MF_SEPARATOR)
	
	ModifyMenu($hMenu, _
			$MenuItemID, _
			$nFlags, _
			$MenuItemID, _
			DllStructGetPtr($stItemData))
EndFunc


;********************************************************************
; Create our special menu font
;********************************************************************

Func CreateMenuFont($sFontName, $nHeight = 8, $nWidth = 400)
	Local $stFontName = DllStructCreate('char[260]')
	DllStructSetData($stFontName, 1, $sFontName)
	
	$hDC		= GetDC(0) ; Get the Desktops DC
	$nPixel		= GetDeviceCaps($hDC, 90)
	$nHeight	= 0 - MulDiv($nHeight, $nPixel, 72)
		
	ReleaseDC(0, $hDC)
	
	$hFont = CreateFont($nHeight, _
						0, _
						0, _
						0, _
						$nWidth, _
						0, _
						0, _
						0, _
						0, _
						0, _
						0, _
						0, _
						0, _
						DllStructGetPtr($stFontName))

	$stFontName = 0
	
	Return $hFont
EndFunc


;********************************************************************
; CommCtrl.h - functions
;********************************************************************

Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall('comctl32.dll', 'hwnd', 'ImageList_Create', _
														'int', $nImageWidth, _
														'int', $nImageHeight, _
														'int', $nFlags, _
														'int', $nInitial, _
														'int', $nGrow)
	Return $hImageList[0]
EndFunc


Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall('comctl32.dll', 'int', 'ImageList_AddIcon', _
													'hwnd', $hIml, _
													'hwnd', $hIcon)
	Return $nIndex[0]
EndFunc


Func ImageList_Destroy($hIml)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_Destroy', _
													'hwnd', $hIml)
	Return $bResult[0]
EndFunc


Func ImageList_Draw($hIml, $nIndex, $hDC, $nX, $nY, $nStyle)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_Draw', _
													'hwnd', $hIml, _
													'int', $nIndex, _
													'hwnd', $hDC, _
													'int', $nX, _
													'int', $nY, _
													'int', $nStyle)
	Return $bResult[0]
EndFunc


Func ImageList_DrawEx($hIml, $nIndex, $hDC, $nX, $nY, $nDx, $nDy, $nBkClr, $nFgClr, $nStyle)
	Local $bResult = DllCall('comctl32.dll', 'int', 'ImageList_DrawEx', _
													'hwnd', $hIml, _
													'int', $nIndex, _
													'hwnd', $hDC, _
													'int', $nX, _
													'int', $nY, _
													'int', $nDx, _
													'int', $nDy, _
													'int', $nBkClr, _
													'int', $nFgClr, _
													'int', $nStyle)
	Return $bResult[0]
EndFunc


;********************************************************************
; ShellApi.h - functions
;********************************************************************

Func ExtractIconEx($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall('shell32.dll', 'int', 'ExtractIconEx', _
												'str', $sIconFile, _
												'int', $nIconID, _
												'ptr', $ptrIconLarge, _
												'ptr', $ptrIconSmall, _
												'int', $nIcons)
	Return $nCount[0]
EndFunc


;********************************************************************
; WinBase.h - functions
;********************************************************************

Func MulDiv($nInt1, $nInt2, $nInt3)
	$nResult = DllCall('kernel32.dll', 'int', 'MulDiv', _
											'int', $nInt1, _
											'int', $nInt2, _
											'int', $nInt3)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinGDI.h - functions
;********************************************************************

Func SelectObject($hDC, $hObj)
	Local $hOldObj = DllCall('gdi32.dll', 'int', 'SelectObject', _
												'hwnd', $hDC, _
												'hwnd', $hObj)
	Return $hOldObj[0]
EndFunc


Func DeleteObject($hObj)
	Local $bResult = DllCall('gdi32.dll', 'int', 'DeleteObject', _
												'hwnd', $hObj)
	Return $bResult[0]
EndFunc


Func CreateFont($nHeight, $nWidth, $nEscape, $nOrientn, $fnWeight, $bItalic, $bUnderline, $bStrikeout, $nCharset, $nOutputPrec, $nClipPrec, $nQuality, $nPitch, $ptrFontName)
	Local $hFont = DllCall('gdi32.dll', 'hwnd', 'CreateFont', _
												'int', $nHeight, _
												'int', $nWidth, _
												'int', $nEscape, _
												'int', $nOrientn, _
												'int', $fnWeight, _
												'long', $bItalic, _
												'long', $bUnderline, _
												'long', $bStrikeout, _
												'long', $nCharset, _
												'long', $nOutputPrec, _
												'long', $nClipPrec, _
												'long', $nQuality, _
												'long', $nPitch, _
												'ptr', $ptrFontName)
	Return $hFont[0]
EndFunc


Func GetTextExtentPoint32($hDC, $ptrText, $nTextLength, $ptrSize)
	Local $bResult = DllCall('gdi32.dll', 'int', 'GetTextExtentPoint32', _
												'hwnd' ,$hDC, _
												'ptr', $ptrText, _
												'int', $nTextLength, _
												'ptr', $ptrSize)
	Return $bResult[0]
EndFunc


Func SetBkColor($hDC, $nColor)
	Local $nOldColor = DllCall('gdi32.dll', 'int', 'SetBkColor', _
												'hwnd', $hDC, _
												'int', $nColor)
	Return $nOldColor[0]
EndFunc


Func SetTextColor($hDC, $nColor)
	Local $nOldColor = DllCall('gdi32.dll', 'int', 'SetTextColor', _
												'hwnd', $hDC, _
												'int', $nColor)
	Return $nOldColor[0]
EndFunc


Func CreateSolidBrush($nColor)
	Local $hBrush = DllCall('gdi32.dll', 'int', 'CreateSolidBrush', _
												'int', $nColor)
	Return $hBrush[0]
EndFunc


Func GetDeviceCaps($hDC, $nIndex)
	Local $nResult = DllCall('gdi32.dll', 'int', 'GetDeviceCaps', _
												'hwnd', $hDC, _
												'int', $nIndex)
	Return $nResult[0]
EndFunc


Func CreateCompatibleDC($hDC)
	Local $hCompDC = DllCall('gdi32.dll', 'hwnd', 'CreateCompatibleDC', _
												'hwnd', $hDC)
	Return $hCompDC[0]
EndFunc


Func DeleteDC($hDC)
	Local $bResult = DllCall('gdi32.dll', 'int', 'DeleteDC', _
												'hwnd', $hDC)
	Return $bResult[0]
EndFunc


Func CreateBitmap($nWidth, $nHeight, $nCPlanes, $nCBitsPerPixel, $ptrCData)
	Local $hBitmap = DllCall('gdi32.dll', 'hwnd', 'CreateBitmap', _
												'int', $nWidth, _
												'int', $nHeight, _
												'int', $nCPlanes, _
												'int', $nCBitsPerPixel, _
												'ptr', $ptrCData)
	Return $hBitmap[0]
EndFunc


Func BitBlt($hDCDest, $nXDest, $nYDest, $nWidth, $nHeight, $hDCSrc, $nXSrc, $nYSrc, $nOpCode)
	Local $bResult = DllCall('gdi32.dll', 'int', 'BitBlt', _
												'hwnd', $hDCDest, _
												'int', $nXDest, _
												'int', $nYDest, _
												'int', $nWidth, _
												'int', $nHeight, _
												'hwnd', $hDCSrc, _
												'int', $nXSrc, _
												'int', $nYSrc, _
												'long', $nOpCode)
	Return $bResult[0]
EndFunc


;********************************************************************
; WinUser.h - functions
;********************************************************************

Func GetDC($hWnd)
	Local $hDC = DllCall('user32.dll', 'int', 'GetDC', _
											'hwnd', $hWnd)
	Return $hDC[0]
EndFunc


Func ReleaseDC($hWnd, $hDC)
	Local $bResult = DllCall('user32.dll', 'int', 'ReleaseDC', _
												'hwnd', $hWnd, _
												'hwnd', $hDC)
	Return $bResult[0]
EndFunc


Func GetSysColor($nIndex)
	Local $nColor = DllCall('user32.dll', 'int', 'GetSysColor', _
												'int', $nIndex)
	Return $nColor[0]
EndFunc


Func GetSysColorBrush($nIndex)
	Local $hBrush = DllCall('user32.dll', 'hwnd', 'GetSysColorBrush', _
												'int', $nIndex)
	Return $hBrush[0]
EndFunc


Func DestroyIcon($hIcon)
	Local $bResult = DllCall('user32.dll', 'int', 'DestroyIcon', _
												'hwnd', $hIcon)
	Return $bResult[0]
EndFunc


Func GetSystemMetrics($nIndex)
	Local $nResult = DllCall('user32.dll', 'int', 'GetSystemMetrics', _
												'int', $nIndex)
	Return $nResult[0]
EndFunc


Func DrawText($hDC, $ptrText, $nLenText, $ptrRect, $nFlags)
	Local $nHeight = DllCall('user32.dll', 'int', 'DrawText', _
												'hwnd', $hDC, _
												'ptr', $ptrText, _
												'int', $nLenText, _
												'ptr', $ptrRect, _
												'int', $nFlags)
	Return $nHeight[0]
EndFunc


Func GetMenuItemCount($hMenu)
	Local $nCount = DllCall('user32.dll', 'int', 'GetMenuItemCount', _
												'hwnd', $hMenu)
	Return $nCount[0]
EndFunc


Func GetMenuItemID($hMenu, $nPos)
	Local $nID = DllCall('user32.dll', 'int', 'GetMenuItemID', _
											'hwnd', $hMenu, _
											'int', $nPos)
	Return $nID[0]
EndFunc

											
Func ModifyMenu($hMenu, $nID, $nFlags, $nNewID, $ptrItemData)
	Local $bResult = DllCall('user32.dll', 'int', 'ModifyMenu', _
												'hwnd', $hMenu, _
												'int', $nID, _
												'int', $nFlags, _
												'int', $nNewID, _
												'ptr', $ptrItemData)
	Return $bResult[0]
EndFunc


Func FillRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall('user32.dll', 'int', 'FillRect', _
												'hwnd', $hDC, _
												'ptr', $ptrRect, _
												'hwnd', $hBrush)
	Return $bResult[0]
EndFunc


Func DrawEdge($hDC, $ptrRect, $nEdgeType, $nBorderFlag)
	Local $bResult = DllCall('user32.dll', 'int', 'DrawEdge', _
												'hwnd', $hDC, _
												'ptr', $ptrRect, _
												'int', $nEdgeType, _
												'int', $nBorderFlag)
	Return $bResult[0]
EndFunc


Func FrameRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall('user32.dll', 'int', 'FrameRect', _
												'hwnd', $hDC, _
												'ptr', $ptrRect, _
												'hwnd', $hBrush)
	Return $bResult[0]
EndFunc


Func DrawFrameControl($hDC, $ptrRect, $nType, $nState)
	Local $bResult = DllCall('user32.dll', 'int', 'DrawFrameControl', _
												'hwnd', $hDC, _
												'ptr', $ptrRect, _
												'int', $nType, _
												'int', $nState)
	Return $bResult[0]
EndFunc
