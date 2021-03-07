#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <WinAPI.au3>
#include <GuiComboBox.au3>

Global $hComboMenu

_Main()

Func _Main()
	Local $hForm, $iEdit

	$hForm = GUICreate("ComboBox like a Context  Menu!", 400, 300)
	GUICtrlCreateButton("Button", 150, 250, 100, 25)

	GUISetState()

	; Register message handlers
	GUIRegisterMsg($WM_CONTEXTMENU, "WM_CONTEXTMENU")
	GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")

	GUISetState(@SW_SHOW)
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				Exit
		EndSwitch
	WEnd
EndFunc   ;==>_Main

; Handle WM_COMMAND messages
Func WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	Local $hWndFrom, $iIDFrom, $iCode

	$iCode = _WinAPI_HiWord($iwParam)
	Switch $iCode
		#cs
			Case $CBN_CLOSEUP ; Sent when the list box of a combo box has been closed
			; no return value
			Case $CBN_SELCHANGE ; Sent when the user changes the current selection in the list box of a combo box
			; no return value
		#ce
		Case $CBN_SELENDCANCEL ; Sent when the user selects an item, but then selects another control or closes the dialog box
			_GUICtrlComboBox_Destroy($hComboMenu)
			; no return value
		Case $CBN_SELENDOK ; Sent when the user selects a list item, or selects an item and then closes the list
			Local $iChoice = _GUICtrlComboBox_GetCurSel($hComboMenu)

			Switch $iChoice
				Case 0
					FileOpenDialog("Select to open image files...", @WindowsDir & "\", "Images (*.jpg;*.bmp)", 1 + 4, "", $hComboMenu)
				Case 1
					FileSaveDialog("Choose a name.", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}", "Scripts (*.aut;*.au3)", 2, "", $hComboMenu)
				Case 3
					Exit
			EndSwitch
			_GUICtrlComboBox_Destroy($hComboMenu)
			; no return value
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_COMMAND

; Handle WM_CONTEXTMENU messages
;lParam
;    The low-order word specifies the horizontal position of the cursor, in screen coordinates, at the time of the mouse click.
;    The high-order word specifies the vertical position of the cursor, in screen coordinates, at the time of the mouse click.
Func WM_CONTEXTMENU($hWnd, $iMsg, $iwParam, $ilParam)
	Local $iLeft = _WinAPI_LoWord($ilParam), $iTop = _WinAPI_HiWord($ilParam)

	ScreenToClient($hWnd, $iLeft, $iTop)
	;ConsoleWrite($iLeft & " x " & $iTop & @CRLF)

	$hComboMenu = GUICtrlCreateCombo("", $iLeft, $iTop, 100, 25, $CBS_DROPDOWNLIST)
	$hComboMenu = GUICtrlGetHandle($hComboMenu)
	_GUICtrlComboBox_AddString($hComboMenu, "Open file")
	_GUICtrlComboBox_AddString($hComboMenu, "Save As...")
	_GUICtrlComboBox_AddString($hComboMenu, "Close and save")
	_GUICtrlComboBox_AddString($hComboMenu, "Exit")
	_GUICtrlComboBox_SetCurSel($hComboMenu, 0)
	_GUICtrlComboBox_ShowDropDown($hComboMenu, True)
	GUICtrlSetState(_WinAPI_GetDlgCtrlID($hComboMenu), $GUI_ONTOP)

	Return 1
EndFunc   ;==>WM_CONTEXTMENU

; Converts the screen coordinates of a specified point on the screen to client-area coordinates.
Func ScreenToClient($hWndForm, ByRef $x, ByRef $y)
	Local $stPoint = DllStructCreate("int;int")

	DllStructSetData($stPoint, 1, $x)
	DllStructSetData($stPoint, 2, $y)

	DllCall("user32.dll", "int", "ScreenToClient", "hwnd", $hWndForm, "ptr", DllStructGetPtr($stPoint))

	$x = DllStructGetData($stPoint, 1)
	$y = DllStructGetData($stPoint, 2)
EndFunc   ;==>ClientToScreen