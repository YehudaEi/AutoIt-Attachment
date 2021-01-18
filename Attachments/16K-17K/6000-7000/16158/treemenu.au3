#include <GUIConstants.au3>

Global Const $TVS_NOHSCROLL			= 0x8000
Global Const $TVS_INFOTIP			= 0x0800

Global Const $TVM_HITTEST			= $TV_FIRST + 17

Global Const $NM_CLICK				= -2
Global Const $NM_SETCURSOR			= -17

Global Const $WM_NOTIFY				= 0x004E
Global Const $WM_ACTIVATE			= 0x0006
Global Const $WM_NCACTIVATE			= 0x0086

GUIRegisterMsg($WM_NOTIFY, "WndProc")
GUIRegisterMsg($WM_ACTIVATE, "WndProc")

;*** Main-GUI ***
$hMainGUI		= GUICreate("My Tree Menu", 300, 200)

$nBtnMenu		= GUICtrlCreateButton("Show Menu", 10, 10, 100, 30)


;*** Tree-Menu-GUI ***
;Dim $hMenuGUI	= GUICreate("MenuGUI", 160, 160, -1, -1, BitOr($WS_POPUP, $WS_BORDER, $WS_CHILD), $WS_EX_TOOLWINDOW, $hMainGUI) ; Flat Menu
Dim $hMenuGUI	= GUICreate("MenuGUI", 160, 160, -1, -1, BitOr($WS_POPUP, $WS_DLGFRAME, $WS_CHILD), $WS_EX_TOOLWINDOW, $hMainGUI)

Dim $nMenuTV	= GUICtrlCreateTreeView(0, 0, 160, 160, _
		BitOr($TVS_NOHSCROLL, $TVS_NONEVENHEIGHT, $TVS_FULLROWSELECT, $TVS_INFOTIP, $TVS_HASBUTTONS, $TVS_LINESATROOT)) ;, $TVS_TRACKSELECT))
GUICtrlSetBkColor(-1, 0xC0D0E0)
GUICtrlSetFont(-1, 10, -1, -1, "Comic Sans MS")

;*** Main-Menu ***
$nItemProgs		= GUICtrlCreateTreeViewItem("Office", $nMenuTV)
GUICtrlSetImage(-1, "shell32.dll", -20)
$nItemPrefs		= GUICtrlCreateTreeViewItem("Preferences", $nMenuTV)
GUICtrlSetImage(-1, "shell32.dll", -22)
$nItemAbout		= GUICtrlCreateTreeViewItem("About", $nMenuTV)
GUICtrlSetImage(-1, "shell32.dll", -24)
$nItemExit		= GUICtrlCreateTreeViewItem("Exit", $nMenuTV)
GUICtrlSetImage(-1, "shell32.dll", -28)

;*** Programs-Menu ***
$nItemCalc		= GUICtrlCreateTreeViewItem("Calculator", $nItemProgs)
GUICtrlSetImage(-1, "calc.exe", 0)
$nItemPaint		= GUICtrlCreateTreeViewItem("Paint", $nItemProgs)
GUICtrlSetImage(-1, "mspaint.exe", 0)
$nItemNote		= GUICtrlCreateTreeViewItem("Notepad", $nItemProgs)
GUICtrlSetImage(-1, "notepad.exe", 0)
$nItemWord		= GUICtrlCreateTreeViewItem("Wordpad", $nItemProgs)
GUICtrlSetImage(-1, "write.exe", 0)

;*** Prefs-Menu ***
GUICtrlCreateTreeViewItem("General", $nItemPrefs)
GUICtrlSetImage(-1, "shell32.dll", -13)
GUICtrlCreateTreeViewItem("Color", $nItemPrefs)
GUICtrlSetImage(-1, "mspaint.exe", 0)

GUISetState(@SW_SHOW, $hMainGUI)


While 1
	$Msg = GUIGetMsg()
	
	Switch $Msg
		Case $GUI_EVENT_CLOSE
			ExitLoop
			
		Case $nBtnMenu
			$arPos = ControlGetPos($hMainGUI, "", $nBtnMenu)
			If IsArray($arPos) Then
				$stPT = DllStructCreate("int;int")
				DllStructSetData($stPT, 1, $arPos[0])
				DllStructSetData($stPT, 2, $arPos[1])
				
				ClientToScreen($hMainGUI, DllStructGetPtr($stPT))
				
				WinMove($hMenuGUI, "", DllStructGetData($stPT, 1) + 100, DllStructGetData($stPT, 2))
				GUISetState(@SW_SHOW, $hMenuGUI)
			EndIf
	EndSwitch
WEnd


Exit


Func WndProc($hWnd, $Msg, $wParam, $lParam)
	Switch $Msg
		Case $WM_ACTIVATE
			Local $nState = BitShift($wParam, 16)
    		Local $nActiv = BitAnd($wParam, 0x0000FFFF)
    		Local $hActWnd = $lParam
    		
	   		Switch $hActWnd
    			Case 0
    				GUISetState(@SW_HIDE, $hMenuGUI)
    				
    			Case $hMenuGUI
    				If $nActiv <> 0 Then
	    				GUISetState(@SW_HIDE, $hMenuGUI)
    				Else
    					DllCall("user32.dll", "int", "SendMessage", "hwnd", $hMainGUI, "int", $WM_NCACTIVATE, "int", 1, "int", 0)
    				EndIf
    		EndSwitch

    
		Case $WM_NOTIFY
			Local $stNMHDR = DllStructCreate("hwnd;uint;int", $lParam)
			Local $hWndFrom = DllStructGetData($stNMHDR, 1)
			Local $nIdFrom = DllStructGetData($stNMHDR, 2)
			Local $nCode = DllStructGetData($stNMHDR, 3)
			
			If $nIdFrom = $nMenuTV Then
				Local $stPT = DllStructCreate("int;int")
				GetCursorPos(DllStructGetPtr($stPT))
				ScreenToClient($hWnd, DllStructGetPtr($stPT))
					
				Local $stTVHI = DllStructCreate("int[2];uint;hwnd")
				DllStructSetData($stTVHI, 1, DllStructGetData($stPT, 1), 1)
				DllStructSetData($stTVHI, 1, DllStructGetData($stPT, 2), 2)
					
				GUICtrlSendMsg($nIdFrom, $TVM_HITTEST, 0, DllStructGetPtr($stTVHI))
				Local $hItem = DllStructGetData($stTVHI, 3)
						
				Switch $nCode
					Case $NM_CLICK
						If $hItem <> 0 Then
							GUICtrlSendMsg($nIdFrom, $TVM_EXPAND, $TVE_TOGGLE, $hItem)
							
							;*** Now our treeview menu items ***
							Switch $hItem
								Case GUICtrlGetHandle($nItemCalc)
									Run("calc.exe")
									
								Case GUICtrlGetHandle($nItemPaint)
									Run("mspaint.exe")
									
								Case GUICtrlGetHandle($nItemNote)
									Run("notepad.exe")
									
								Case GUICtrlGetHandle($nItemWord)
									Run("write.exe")
									
								Case GUICtrlGetHandle($nItemAbout)
									MsgBox(64, "About", "TreeView-Menu Demo by Holger Kotsch")
									
								Case GUICtrlGetHandle($nItemExit)
									Exit
							EndSwitch
							
							Return 1
						EndIf
					
					Case $NM_SETCURSOR
						If $hItem <> 0 Then
							GUICtrlSendMsg($nIdFrom, $TVM_SELECTITEM, $TVGN_CARET, $hItem)
						Else
							GUICtrlSendMsg($nIdFrom, $TVM_SELECTITEM, $TVGN_CARET, 0)
						EndIf
				EndSwitch
			EndIf
			
			Return
	EndSwitch
EndFunc


Func GetCursorPos($pPOINT)
	Local $nResult = DllCall("user32.dll", "int", "GetCursorPos", _
													"ptr", $pPOINT)
	Return $nResult[0]
EndFunc


Func ScreenToClient($hWnd, $pPOINT)
	Local $nResult = DllCall("user32.dll", "int", "ScreenToClient", _
													"hwnd", $hWnd, _
													"ptr", $pPOINT)
	Return $nResult[0]
EndFunc


Func ClientToScreen($hWnd, $pPOINT)
	Local $nResult = DllCall("user32.dll", "int", "ClientToScreen", _
													"hwnd", $hWnd, _
													"ptr", $pPOINT)
	Return $nResult[0]
EndFunc
