; Dynamic Menus 0.4Beta
; Created by xwinterx at roadrunner dot com
; Created on: 10-22-07
; Revised on: 10-23-07


#include-once

Opt("WinSearchChildren", 1)

Dim $___ArrayMenu[1]
Dim $___ArrayMenuType[1]
Dim $___ArrayMenuChild[1]
Global $__LastID = ""
Global $__LastType = ""
Global $MenuActiveColor = 0x989898
Global $MenuInactiveColor = 0xd4d0c7
Global $MenuItemActiveColor = 0x072669
Global $MenuItemInactiveColor = 0xd4d0c7
Global $MenuColorTextDefault = 0x000000
Global $MenuColorTextHighlight = 0xFFFFFF
Global $__TargetChild = ""
Global $ChildStatus = 0
Global $___hWIN
Global $___MenuDecoration = 0
Global $___MainGUI
Global $___i

Global $___MenuSearchID



; =========================================================================================================================
; Function: 	CreateDynamicMenuBar($DMB_x, $DMB_y, $DMB_width, $DMB_height, $DMB_Opt, $DBM_hWin)
;
; Description:	Creates a "dummy" menubar for the appearance of a full-width menu bar
;
; Requirements: - Must be created prior to creating Dynamic Menus
;
; Parameters:	$DMB_x			- X Coordinate for Creation
;				$DMB_y			- Y Coordinate for Creation
;				$DMB_width		- Menu bar width
;				$DMB_height		- Menu bar height
;				$DM_Opt			- Option for adding an etched bottom border
;									0 = no etched bottom border
;									1 = etched bottom border
;									2 = etched top border
;									3 = etched top and bottom border
;				$DBM_hWin		- Window handle of the main window GUI
;
; Usage: 		$Menu_File = GuiCtrlCreateDynamicMenu("File", 10, 30, 40, 15, 200, 100, $My_GUI)
; =========================================================================================================================
Func CreateDynamicMenuBar($DMB_x, $DMB_y, $DMB_width, $DMB_height, $DMB_Opt, $DBM_hWin)
	
	If $DMB_Opt = 0 Then
		$___hWIN = GUICreate("", $DMB_width, $DMB_height, $DMB_x, $DMB_y, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOOLWINDOW, $DBM_hWin)
		GUISetBkColor($MenuInactiveColor)
		GUISetState(@SW_ENABLE,$___hWIN)
		GUISetState(@SW_SHOW, $___hWIN)
		$___MenuDecoration = 0
	ElseIf $DMB_Opt = 1 Then
		$___hWIN = GUICreate("", $DMB_width, $DMB_height + 2, $DMB_x, $DMB_y, BitOR($WS_CHILD, $WS_TABSTOP), $WS_EX_TOOLWINDOW, $DBM_hWin)
		GUICtrlCreateLabel("", 0, $DMB_height, $DMB_width, 2, $SS_ETCHEDFRAME)
		GUISetBkColor($MenuInactiveColor)
		GUISetState(@SW_ENABLE,$___hWIN)
		GUISetState(@SW_SHOW, $___hWIN)
		$___MenuDecoration = 1
	EndIf
	
	$___MainGUI = $DBM_hWin
	
EndFunc ;=> CreateDynamicMenuBar($DMB_x, $DMB_y, $DMB_width, $DMB_height, $DMB_Opt, $DBM_hWin)

; =========================================================================================================================
; Function: 	GuiCtrlCreateDynamicMenu($DM_Label, $DM_x, $DM_y, $DM_width, $DM_height, $DM_gui_width, $DM_gui_height)
;
; Description:	Creates a dynamic parent menu to be placed anywhere on your GUI
;
; Requirements: - Your Parent Window must use the variable  -  $___hWIN
;				- All Dynamic Parent Menus MUST be created prior to creating Dynamic Menuitems
;
; Parameters:	$DM_Label		- Menu Window
;				$DM_x			- X Coordinate for Creation
;				$DM_y			- Y Coordinate for Creation
;				$DM_width		- Menu width, menu label is centered
;				$DM_height		- Menu height, incase you want to make bigger top-level menus
;				$DM_gui_width	- Width of the actual expanded menu
;				$DM_gui_height	- Height of the actual expanded menu
;
; Usage: 		$Menu_File = GuiCtrlCreateDynamicMenu("File", 10, 30, 40, 15, 200, 100)
;
;				Case $msg = $Menu_File[0]	<- for checking click on dynamic menu
; =========================================================================================================================
Func GuiCtrlCreateDynamicMenu($DM_Label, $DM_x, $DM_y, $DM_width, $DM_height, $DM_gui_width, $DM_gui_height)
	Dim $TempDM[5]
	
	;$TempDM[0] = GUICtrlCreateLabel($DM_Label, $DM_x, $DM_y, $DM_width, $DM_height, $SS_CENTER)
	$TempDM[0] = GUICtrlCreateLabel($DM_Label, $DM_x, 0, $DM_width, $DM_height, $SS_CENTER)
	GUICtrlSetBkColor(-1,$MenuInactiveColor)
	
	If $___MenuDecoration = 0 Then
		$TempDM[1] = GUICreate($TempDM[0], $DM_gui_width, $DM_gui_height, $DM_x, $DM_y + $DM_height, BitOR($WS_CHILD, $WS_TABSTOP, $WS_DLGFRAME), $WS_EX_TOOLWINDOW, $___MainGUI)
	ElseIf $___MenuDecoration = 1 Then
		$TempDM[1] = GUICreate($TempDM[0], $DM_gui_width, $DM_gui_height, $DM_x, $DM_y + $DM_height + 2, BitOR($WS_CHILD, $WS_TABSTOP, $WS_DLGFRAME), $WS_EX_TOOLWINDOW, $___MainGUI)
	EndIf
	
	MenuAddHover($TempDM[0], $TempDM[1], "menu")
	GUISetBkColor($MenuItemInactiveColor)
	GUISetState(@SW_HIDE, $TempDM[1])
	;GUISetState(@SW_DISABLE, $TempDM[1])
	GUISetState(@SW_SHOW, $___hWIN)
	$TempDM[2] = 0
	$TempDM[3] = $DM_x
	$TempDM[4] = $DM_y + $DM_height
	Return $TempDM
EndFunc ;=> GuiCtrlCreateDynamicMenu($DM_Label, $DM_x, $DM_y, $DM_width, $DM_height, $DM_gui_width, $DM_gui_height)

; =========================================================================================================================
; Function: 	GuiCtrlCreateDynamicMenuItem($DMI_Label, $DMI_target, $DMI_order)
;
; Description:	Creates a menu item in your dynamic parent menu
;
; Requirements: Must be created AFTER all dynamic parent menus
;
; Parameters:	$DMI_Label		- Menu Label
;				$DMI_target		- Dynamic Menu Parent
;				$DMI_order		- Sort order in menu with 0 being the first menuitem in the list
;
; Usage: 		$Menu_File_Open = GuiCtrlCreateDynamicMenuItem("Open...", $Menu_File, 0)
; =========================================================================================================================
Func GuiCtrlCreateDynamicMenuItem($DMI_Label, $DMI_target, $DMI_order)
	; Enable and Show Child "Menu" Window for Menu Item creation
	GUISetState(@SW_ENABLE, $DMI_target[1])
	GUISetState(@SW_SHOW, $DMI_target[1])
	; Get width of Menu for auto-sizing the menu for highlight
	Local $TempWidth = WinGetPos($DMI_target[1])
	; Checks for empty label for separator creation
	If $DMI_Label = "" Then
		Local $TempDMI = GUICtrlCreateGraphic(0, ($DMI_order * 14) + 6, $TempWidth[2], 2, $SS_ETCHEDFRAME)
		;MenuAddHover($TempDMI, "separator")
	Else
		Local $TempDMI = GUICtrlCreateLabel("     " & $DMI_Label, 0, $DMI_order * 14, $TempWidth[2], 14)
		GUICtrlSetBkColor(-1,$MenuItemInactiveColor)
		MenuAddHover($TempDMI,"none", "menuitem")
	EndIf
	GUISetState(@SW_HIDE, $DMI_target[1])
	
	
	Return $TempDMI
EndFunc ;=> GuiCtrlCreateDynamicMenuItem($DMI_Label, $DMI_target, $DMI_order)

; Turns the menus on. enter tim in milliseconds.
Func EnableMenuHover($__time)
	AdlibEnable("MenuHoverOn", $__time)
EndFunc

; Turns the menus off.
Func DisableMenuHover()
	AdlibDisable()
EndFunc

; Turns Adlib On. Redundant to EnableMenuHover() but I made it for other purposes
Func MenuHoverOn()
	MenuCheckParentHover()
EndFunc

; Adds Menu and Type to array lists.
Func MenuAddHover($___MenuID, $___MenuChild, $___MenuType)
	_ArrayAdd($___ArrayMenu, $___MenuID)
	_ArrayAdd($___ArrayMenuType, $___MenuType)
	_ArrayAdd($___ArrayMenuChild, $___MenuChild)
EndFunc

; Checks for mouse hovering over PARENT menus
Func MenuCheckParentHover()
	
	Local $___CtrlFound = 0
	Local $___TipState = 0
	Local $___MenuPos = 0
	
	GUISetState(@SW_SHOW, $___hWIN)
		
	$___MenuSearchID = GUIGetCursorInfo($___hWIN)	

	If IsArray($___MenuSearchID) Then
		For $___i = 1 to (UBound($___ArrayMenu)-1)
			If $___MenuSearchID[4] = $___ArrayMenu[$___i] Then 
				$___CtrlFound = 1
				$___MenuPos = $___i
			EndIf
		Next
		
		Select
			Case $___CtrlFound = 1 And $___TipState = 0
				MenuHoverGo($___MenuPos)
				$___CtrlFound = 0
				$___TipState = 1
			Case $___CtrlFound = 0 And $___TipState = 1
				If $ChildStatus = 1 Then
					MenuCheckChildHover()
					$___CtrlFound = 0
					$___TipState = 0
				Else
					MenuParentHoverStop($___MenuPos)
					$___CtrlFound = 0
					$___TipState = 0
				EndIf
			Case Else
				If $ChildStatus = 1 Then
					MenuCheckChildHover()
					$___CtrlFound = 0
					$___TipState = 0
				Else
					MenuParentHoverStop($___MenuPos)
					$___CtrlFound = 0
					$___TipState = 0
				EndIf
		EndSelect
	EndIf

	
EndFunc

; highlights menu if hovering over it
Func MenuHoverGo($___MenuLoc)
	If $___ArrayMenuType[$___MenuLoc] = "menu" Then
		If $__LastID <> "" and $__LastID <> $___ArrayMenu[$___MenuLoc] Then
			MenuParentHoverStop($___MenuLoc)
		EndIf
		If $ChildStatus = 0 Then
			GUICtrlSetBkColor($___ArrayMenu[$___MenuLoc],$MenuActiveColor)
		EndIf
		$__LastID = $___ArrayMenu[$___MenuLoc]
		$__LastType = "menu"
	ElseIf $___ArrayMenuType[$___MenuLoc] = "menuitem" Then
		If $__LastID <> "" and $__LastID <> $___ArrayMenu[$___MenuLoc] Then
			MenuHoverStop()
		EndIf
		GUICtrlSetBkColor($___ArrayMenu[$___MenuLoc],$MenuItemActiveColor)
		GUICtrlSetColor($___ArrayMenu[$___MenuLoc], $MenuColorTextHighlight)
		$__LastID = $___ArrayMenu[$___MenuLoc]
		$__LastType = "menuitem"
	Else
		$__LastID = ""
		$__LastType = ""
	EndIf
EndFunc	;=> MenuHoverGo($___MenuLoc)


; removes highlight
Func MenuParentHoverStop($___MenuLoc)
	For $___i = 1 to (UBound($___ArrayMenu)-1)
		If $___ArrayMenu[$___i] = $__LastID Then
			If $ChildStatus = 1 Then
				GUISetState(@SW_HIDE, $___ArrayMenuChild[$___i])
				GUICtrlSetBkColor($___ArrayMenu[$___i], $MenuInactiveColor)
				GUISetState(@SW_SHOW, $___ArrayMenuChild[$___MenuLoc])
				GUICtrlSetBkColor($___ArrayMenu[$___MenuLoc], $MenuActiveColor)
				$__TargetChild = $___ArrayMenuChild[$___MenuLoc]
			Else
				GUICtrlSetBkColor($___ArrayMenu[$___i], $MenuInactiveColor)
			EndIf
		EndIf
	Next
EndFunc	;=> MenuParentHoverStop()

; Opens/Closes Child Menus when Parent Menu is clicked
Func ToggleMenu($____MID)
	
	If $ChildStatus = 1 Then
		GUISetState(@SW_HIDE, $____MID[1])
		GUISetState(@SW_SHOW, $___hWIN)
		$ChildStatus = 0
	Else
		GUISetState(@SW_SHOW, $____MID[1])
		$ChildStatus = 1
		$__TargetChild = $____MID[1]
	EndIf
EndFunc

; Checks for mouse hovering over CHILD menus
Func MenuCheckChildHover()
	
	Local $___CtrlFound = 0
	Local $___TipState = 0
	Local $___MenuPos = 0
	
	GUISetState(@SW_SHOW, $__TargetChild)
	WinActivate($__TargetChild)
	
	$___MenuSearchID = GUIGetCursorInfo($__TargetChild)
	
	If IsArray($___MenuSearchID) Then
		For $___i = 1 to (UBound($___ArrayMenu)-1)
			If $___MenuSearchID[4] = $___ArrayMenu[$___i] Then 
				$___CtrlFound = 1
				$___MenuPos = $___i
			EndIf
		Next
		
		Select
			Case $___CtrlFound = 1 And $___TipState = 0
				MenuHoverGo($___MenuPos)
				$___CtrlFound = 0
				$___TipState = 1
			Case $___CtrlFound = 0 And $___TipState = 1
				MenuHoverStop()
				$___CtrlFound = 0
				$___TipState = 0
			Case Else
				MenuHoverStop()
				$___CtrlFound = 0
				$___TipState = 0
		EndSelect
	EndIf
EndFunc

; removes highlights to child menus
Func MenuHoverStop()
		GUICtrlSetBkColor($__LastID, $MenuItemInactiveColor)
		GUICtrlSetColor($__LastID, $MenuColorTextDefault)
EndFunc

; Sets Active/Inactive Hover Colors for Dynamic Menu parents
Func SetDynamicMenuColors($__active, $__inactive)
	$MenuActiveColor = $__active
	$MenuInactiveColor = $__inactive
EndFunc

; Sets Active/Inactive Hover Colors for Dynamic Menu Items
Func SetDynamicMenuItemColors($__active, $__inactive)
	$MenuItemActiveColor = $__active
	$MenuItemInactiveColor = $__inactive
EndFunc

; Sets Active/Inactive Text Colors for Dynamic Menu Items
Func SetDynamicMenuItemTextColor($__active, $__inactive)
	$MenuColorTextDefault = $__active
	$MenuColorTextHighlight = $__inactive
EndFunc

; So you dont have to #include<Array.au3>
Func _ArrayAdd(ByRef $avArray, $sValue)
	If IsArray($avArray) Then
		ReDim $avArray[UBound($avArray) + 1]
		$avArray[UBound($avArray) - 1] = $sValue
		SetError(0)
		Return 1
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc   ;==>_ArrayAdd