#include <MenuConstants.au3>
#include <GuiMenu.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include "GUICtrlSetOnHover_UDF.au3"

Global Const $WS_EX_COMPOSITED = 0x02000000
Global $IsMenuOpen = ""

$GUI = GUICreate("Gecko Web Browser", 700, 50, -1, -1, -1, $WS_EX_COMPOSITED)
GUIRegisterMsg($WM_INITMENUPOPUP, "WM_INITMENUPOPUP")
GUIRegisterMsg($WM_UNINITMENUPOPUP, "WM_UNINITMENUPOPUP")

$FileMenu = CreateMenu("File", 0, 0, 32, 20)
$ContextFileMenu = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("New Window", $ContextFileMenu)
GUICtrlCreateMenuItem("Close Window", $ContextFileMenu)
GUICtrlCreateMenuItem("", $ContextFileMenu)
GUICtrlCreateMenuItem("Save Page As", $ContextFileMenu) ; save source to .htm
GUICtrlCreateMenuItem("Print", $ContextFileMenu)
GUICtrlCreateMenuItem("", $ContextFileMenu)
$FileExitItem = GUICtrlCreateMenuItem("Exit", $ContextFileMenu)

$EditMenu = CreateMenu("Edit", 32, 0, 34, 20)
$ContextEditMenu = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("Cut", $ContextEditMenu)
GUICtrlCreateMenuItem("Copy", $ContextEditMenu)
GUICtrlCreateMenuItem("Paste", $ContextEditMenu)
GUICtrlCreateMenuItem("Delete", $ContextEditMenu)
GUICtrlCreateMenuItem("", $ContextEditMenu)
GUICtrlCreateMenuItem("Find", $ContextEditMenu)
GUICtrlCreateMenuItem("Find Again", $ContextEditMenu)

$ViewMenu = CreateMenu("View", 66, 0, 39, 20)
$ContextViewMenu = GUICtrlCreateContextMenu(GUICtrlCreateDummy())
GUICtrlCreateMenuItem("Stop", $ContextViewMenu)
GUICtrlCreateMenuItem("Reload", $ContextViewMenu)
GUICtrlCreateMenuItem("", $ContextViewMenu)
GUICtrlCreateMenuItem("Page Source", $ContextViewMenu)

GUISetState(@SW_SHOW, $GUI)

While 1
	$Msg = GUIGetMsg()

	Switch $Msg
		Case -3
			Exit
	EndSwitch
WEnd

Func WM_INITMENUPOPUP($hWnd, $Msg, $wParam, $lParam)
	$IsMenuOpen = $wParam ;handle to menu item that was just opened
EndFunc   ;==>WM_INITMENUPOPUP

Func WM_UNINITMENUPOPUP($hWnd, $Msg, $wParam, $lParam)
	$IsMenuOpen = ""
EndFunc   ;==>WM_UNINITMENUPOPUP

Func _Menu_SetColor($hMenuid, $hColor)
	Local $Hmenu = GUICtrlGetHandle($hMenuid)
	Local $Hbrush = DllCall("gdi32.dll", "hwnd", "CreateSolidBrush", "int", $hColor)
	$Hbrush = $Hbrush[0]
	Local $Stmenuinfo = DllStructCreate("dword;dword;dword;uint;dword;dword;ptr")
	DllStructSetData($Stmenuinfo, 1, DllStructGetSize($Stmenuinfo))
	DllStructSetData($Stmenuinfo, 2, BitOR($MIM_APPLYTOSUBMENUS, $MIM_BACKGROUND, $MIM_STYLE))
	DllStructSetData($Stmenuinfo, 3, $MNS_AUTODISMISS)
	DllStructSetData($Stmenuinfo, 5, $Hbrush)
	DllCall("user32.dll", "int", "SetMenuInfo", "hwnd", $Hmenu, "ptr", DllStructGetPtr($Stmenuinfo))
	$Stmenuinfo = 0
EndFunc   ;==>_Menu_SetColor

#Region Show Menu (from the help file)
Func ShowMenu($hWnd, $CtrlID, $nContextID)
	Local $arPos, $x, $y
	Local $Hmenu = GUICtrlGetHandle($nContextID)

	$arPos = ControlGetPos($hWnd, "", $CtrlID)

	$x = $arPos[0]
	$y = $arPos[1] + $arPos[3]

	ClientToScreen($hWnd, $x, $y)
	_GUICtrlMenu_TrackPopupMenu($Hmenu, $hWnd, $x, $y)
EndFunc   ;==>ShowMenu

Func ClientToScreen($hWnd, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ClientToScreen", "hwnd", $hWnd, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)

	$stPoint = 0
EndFunc   ;==>ClientToScreen
#EndRegion Show Menu (from the help file)

#Region Hover
Func OnMenuHover($iCtrlID)
	Switch $iCtrlID
		Case $FileMenu
			If $IsMenuOpen <> GUICtrlGetHandle($ContextFileMenu) And $IsMenuOpen <> "" Then
;~ 				DllCall("user32.dll", "int", "EndMenu")
;~ 				Send("{ESC}")
				ShowMenu($GUI, $FileMenu, $ContextFileMenu)
			EndIf
		Case $EditMenu
			If $IsMenuOpen <> GUICtrlGetHandle($ContextEditMenu) And $IsMenuOpen <> "" Then
;~ 				DllCall("user32.dll", "int", "EndMenu")
;~ 				Send("{ESC}")
				ShowMenu($GUI, $FileMenu, $ContextEditMenu)
			EndIf
		Case $ViewMenu
			If $IsMenuOpen <> GUICtrlGetHandle($ContextEditMenu) And $IsMenuOpen <> "" Then
;~ 				DllCall("user32.dll", "int", "EndMenu")
;~ 				Send("{ESC}")
				ShowMenu($GUI, $FileMenu, $ContextEditMenu)
			EndIf
	EndSwitch
EndFunc   ;==>OnMenuHover

Func OffMenuHover($iCtrlID)
	Switch $iCtrlID
		Case $FileMenu
		Case $EditMenu
		Case $ViewMenu
	EndSwitch
EndFunc   ;==>OffMenuHover

Func OnMenuClick($iCtrlID)
	Switch $iCtrlID
		Case $FileMenu
			ShowMenu($GUI, $FileMenu, $ContextFileMenu)
		Case $EditMenu
			ShowMenu($GUI, $EditMenu, $ContextEditMenu)
		Case $ViewMenu
			ShowMenu($GUI, $ViewMenu, $ContextViewMenu)
	EndSwitch
EndFunc   ;==>OnMenuClick
#EndRegion Hover

Func CreateMenu($sText, $iX, $iY, $iWidth, $iHeight) ;create pictures in place of menu items
	Local $Pic
;~ 	If Not (FileExists($IconDirectory & "\Menu\" & $sText & ".bmp") Or FileExists($IconDirectory & "\Menu\" & $sText & "Over.bmp")) Then
;~ 		CreateMenuImages($sText, $IconDirectory & "\Menu", $DefaultOver, $DefaultBack)
;~ 	EndIf
;~ 	$Pic = GUICtrlCreatePic($IconDirectory & "\Menu\" & $sText & ".bmp", $iX, $iY, $iWidth, $iHeight)
	$Pic = GUICtrlCreateLabel($sText, $iX, $iY, $iWidth, $iHeight)
	_GUICtrl_SetOnHover($Pic, "OnMenuHover", "OffMenuHover", "OnMenuClick")
	Return $Pic
EndFunc   ;==>CreateMenu
