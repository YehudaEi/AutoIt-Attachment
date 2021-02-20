#include <array.au3>
#include <windowsconstants.au3>
#include <GuiMenu.au3>
#include <A3LMenu.au3>

;~ --------------------------------------------------------------------------------------------------


	Opt("WinTitleMatchMode", 4); Option required to be able to match window by classname
;~ 	WinActivate("CLASS:MozillaWindowClass") ; FireFox version 4.0.1
;~ 	WinActivate("[CLASS:IEFrame]","") ; Internet explorer 8
	Sleep(1000)
	MouseClick("right")
	Sleep(1000)

    $hwnd = WinGetHandle("[class:#32768]");	
	ConsoleWrite("Winhandle = " & $hwnd)
	$hMenu = "0x" & Hex(_SendMessage($hwnd, $MN_GETHMENU, 0, 0))	
	ConsoleWrite("Menu handle = " &$hMenu & @CR)
	;$hMenu = _GUICtrlMenu_GetMenu($hwnd) ; kho hieu thiet, cai nay su dung ko duoc
	
	For $i = 0 To _GUICtrlMenu_GetItemCount($hMenu) - 1  Step 1
		ConsoleWrite(_UserCtrlMenu_GetItemText($hMenu,$i)& @CR)
;~ 		Local $tInfo = _UserCtrlMenu_GetItemInfo($hMenu,$i,True)
;~ 		ConsoleWrite("Open command ID: " & DllStructGetData($tInfo, "SubMenu")& @CR)
	Next
			
	Opt("WinTitleMatchMode", Default); Option required to be able to match window by classname
;~ --------------------------------------------------------------------------------------------------

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMenu_GetItemText
; Description ...: Retrieves the text of the specified menu item
; Syntax.........: _GUICtrlMenu_GetItemText($hMenu, $iItem[, $fByPos = True])
; Parameters ....: $hMenu       - Handle of the menu
;                  $iItem       - Identifier or position of the menu item
;                  $fByPos      - Menu identifier flag:
;                  | True - $iItem is a zero based item position
;                  |False - $iItem is a menu item identifier
; Return values .: Success      - Menu item text
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlMenu_SetItemText
; Link ..........: @@MsdnLink@@ GetMenuString
; Example .......: Yes
; ===============================================================================================================================
Func _UserCtrlMenu_GetItemText($hMenu, $iItem, $fByPos = True)
	Local $iByPos = 0

	If $fByPos Then $iByPos = $MF_BYPOSITION
	Local $aResult = DllCall("User32.dll", "int", "GetMenuStringW", "handle", $hMenu, "uint", $iItem, "wstr", 0, "int", 4096, "uint", $iByPos)
	For $i=0 to UBound($aResult) - 1 
		ConsoleWrite("a" & $i  & " = " & $aResult[$i] & " ")
	Next	
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $aResult[3])
EndFunc   ;==>_GUICtrlMenu_GetItemText

; Write a line of text to Notepad
Func Writeln($sText)
    ControlSend("[CLASS:Notepad]", "", "Edit1", $sText & @CR)
EndFunc   ;==>Writeln


; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlMenu_GetItemInfo
; Description ...: Retrieves information about a menu item
; Syntax.........: _GUICtrlMenu_GetItemInfo($hMenu, $iItem[, $fByPos = True])
; Parameters ....: $hMenu       - Handle of the menu
;                  $iItem       - Identifier or position of the menu item
;                  $fByPos      - Menu identifier flag:
;                  | True - $iItem is a zero based item position
;                  |False - $iItem is a menu item identifier
; Return values .: Success      - $tagMENUITEMINFO structure
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlMenu_SetItemInfo, $tagMENUITEMINFO
; Link ..........: @@MsdnLink@@ GetMenuItemInfo
; Example .......: Yes
; ===============================================================================================================================
Func _UserCtrlMenu_GetItemInfo($hMenu, $iItem, $fByPos = True)
	Local $tInfo = DllStructCreate($tagMENUITEMINFO)
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	DllStructSetData($tInfo, "Mask", $MIIM_DATAMASK)
	Local $aResult = DllCall("User32.dll", "bool", "GetMenuItemInfo", "handle", $hMenu, "uint", $iItem, "bool", $fByPos, "ptr", DllStructGetPtr($tInfo))
	If @error Then Return SetError(@error, @extended, 0)
	Return SetExtended($aResult[0], $tInfo)
EndFunc   ;==>_GUICtrlMenu_GetItemInfo