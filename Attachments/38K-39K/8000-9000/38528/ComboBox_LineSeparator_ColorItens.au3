#include <GUIComboBox.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <FontConstants.au3>
#include <BorderConstants.au3>
#include <WinAPI.au3>


Global Const $ODT_MENU = 1
Global Const $ODT_LISTBOX = 2
Global Const $ODT_COMBOBOX = 3
Global Const $ODT_BUTTON = 4
Global Const $ODT_STATIC = 5
Global Const $ODT_HEADER = 100
Global Const $ODT_TAB = 101
Global Const $ODT_LISTVIEW = 102
Global Const $ODA_DRAWENTIRE = 1
Global Const $ODA_SELECT = 2
Global Const $ODA_FOCUS = 4
Global Const $ODS_SELECTED = 1
Global Const $ODS_GRAYED = 2
Global Const $ODS_DISABLED = 4
Global Const $ODS_CHECKED = 8
Global Const $ODS_FOCUS = 16
Global Const $ODS_DEFAULT = 32
Global Const $ODS_HOTLIGHT = 64
Global Const $ODS_INACTIVE = 128
Global Const $ODS_NOACCEL = 256
Global Const $ODS_NOFOCUSRECT = 512
Global Const $ODS_COMBOBOXEDIT = 4096
Global Const $clrWindowText = _WinAPI_GetSysColor($COLOR_WINDOWTEXT)
Global Const $clrHighlightText = _WinAPI_GetSysColor($COLOR_HIGHLIGHTTEXT)
Global Const $clrHighlight = _WinAPI_GetSysColor($COLOR_HIGHLIGHT)
Global Const $clrWindow = _WinAPI_GetSysColor($COLOR_WINDOW)
Global Const $tagDRAWITEMSTRUCT = _
		'uint CtlType;' & _
		'uint CtlID;' & _
		'uint itemID;' & _
		'uint itemAction;' & _
		'uint itemState;' & _
		'hwnd hwndItem;' & _
		'hwnd hDC;' & _
		$tagRECT & _
		';ulong_ptr itemData;'
Global Const $tagMEASUREITEMSTRUCT = _
		'uint CtlType;' & _
		'uint CtlID;' & _
		'uint itemID;' & _
		'uint itemWidth;' & _
		'uint itemHeight;' & _
		'ulong_ptr itemData;'

Global $iItemWidth, $iItemHeight

Global $hGUI
Global $ComboBox
Global $hBrushNorm = _WinAPI_CreateSolidBrush($clrWindow)
Global $hBrushSel = _WinAPI_CreateSolidBrush($clrHighlight)

GUIRegisterMsg($WM_MEASUREITEM, '_WM_MEASUREITEM')
GUIRegisterMsg($WM_DRAWITEM, '_WM_DRAWITEM')
;GUIRegisterMsg($WM_COMMAND, '_WM_COMMAND')

$hGUI = GUICreate('Test', 220, 300)
$ComboBox = GUICtrlCreateCombo('', 10, 10, 200, 300, BitOR($WS_CHILD, $CBS_OWNERDRAWVARIABLE, $CBS_HASSTRINGS, $CBS_DROPDOWNLIST))
GUICtrlSetData($ComboBox, "Medabi-|V!c†o®|joelson0007|Belini-|JScript|Jonatas-|AutoIt v3|www.autoitbrasil.com|www.autoitscript.com", "Medabi-")
GUISetState()

Do

Until GUIGetMsg() = $GUI_EVENT_CLOSE

_WinAPI_DeleteObject($hBrushSel)
_WinAPI_DeleteObject($hBrushNorm)
GUIDelete()

Func _WM_MEASUREITEM($hWnd, $iMsg, $iwParam, $ilParam)

	Local $stMeasureItem = DllStructCreate($tagMEASUREITEMSTRUCT, $ilParam)

	If DllStructGetData($stMeasureItem, 1) = $ODT_COMBOBOX Then
		Local $iCtlType, $iCtlID, $iItemID
		Local $ComboBoxBox
		Local $tSize
		Local $sText
		$iCtlType = DllStructGetData($stMeasureItem, 'CtlType')
		$iCtlID = DllStructGetData($stMeasureItem, 'CtlID')
		$iItemID = DllStructGetData($stMeasureItem, 'itemID')
		$iItemWidth = DllStructGetData($stMeasureItem, 'itemWidth')
		$iItemHeight = DllStructSetData($stMeasureItem, "itemHeight", DllStructGetData($stMeasureItem, 'itemHeight') + 4)
		;$iItemHeight = DllStructGetData($stMeasureItem, 'itemHeight')
		$ComboBoxBox = GUICtrlGetHandle($iCtlID)
	EndIf

	$stMeasureItem = 0

	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_MEASUREITEM

Func _WM_DRAWITEM($hWnd, $iMsg, $iwParam, $ilParam)
	Local $tDIS = DllStructCreate($tagDRAWITEMSTRUCT, $ilParam)
	Local $iCtlType, $iCtlID, $iItemID, $iItemAction, $iItemState
	Local $clrForeground, $clrBackground
	Local $hWndItem, $hDC, $hOldPen, $hOldBrush
	Local $tRect
	Local $sText
	Local $iLeft, $iTop, $iRight, $iBottom
	$iCtlType = DllStructGetData($tDIS, 'CtlType')
	$iCtlID = DllStructGetData($tDIS, 'CtlID')
	$iItemID = DllStructGetData($tDIS, 'itemID')
	$iItemAction = DllStructGetData($tDIS, 'itemAction')
	$iItemState = DllStructGetData($tDIS, 'itemState')
	$hWndItem = DllStructGetData($tDIS, 'hwndItem')
	$hDC = DllStructGetData($tDIS, 'hDC')
	$tRect = DllStructCreate($tagRECT)

	If $iCtlType = $ODT_COMBOBOX And $iCtlID = $ComboBox Then
		Switch $iItemAction
			Case $ODA_SELECT, $ODA_FOCUS, $ODA_DRAWENTIRE
				For $i = 1 To 4
					DllStructSetData($tRect, $i, DllStructGetData($tDIS, $i + 7))
				Next

				_GUICtrlComboBox_GetLBText($hWndItem, $iItemID, $sText)

				Local $iTop = DllStructGetData($tRect, 2), $iBottom = DllStructGetData($tRect, 4)

				DllStructSetData($tRect, 2, $iTop + 2)
				DllStructSetData($tRect, 4, $iBottom - 1)
				If BitAND($iItemState, $ODS_SELECTED) Then
					$clrForeground = _WinAPI_SetTextColor($hDC, $clrHighlightText)
					$clrBackground = _WinAPI_SetBkColor($hDC, $clrHighlight)
					_WinAPI_FillRect($hDC, DllStructGetPtr($tRect), $hBrushSel)
				Else
					Switch $sText
						Case "Medabi-"
							_WinAPI_SetTextColor($hDC, 0xFFFF00)
						Case "V!c†o®"
							_WinAPI_SetTextColor($hDC, 0x0000FF)
						Case "joelson0007"
							_WinAPI_SetTextColor($hDC, 0xFF0000)
						Case "JScript"
							_WinAPI_SetTextColor($hDC, 0xFFB5C5)
						Case "www.autoitbrasil.com", "www.autoitscript.com"
							_WinAPI_SetTextColor($hDC, 0x0000FF)
						Case Else
							$clrForeground = _WinAPI_SetTextColor($hDC, $clrWindowText)
					EndSwitch
					$clrBackground = _WinAPI_SetBkColor($hDC, $clrWindow)
					_WinAPI_FillRect($hDC, DllStructGetPtr($tRect), $hBrushNorm)
				EndIf
				DllStructSetData($tRect, 2, $iTop)
				DllStructSetData($tRect, 4, $iBottom)

				If $sText <> "" Then
					If StringInStr($sText, "-", 0, -1) Then
						; Draw a "line" for a separator item
						If Not BitAND($iItemState, $ODS_COMBOBOXEDIT) Then
							DllStructSetData($tRect, 2, $iTop + ($iItemHeight))
							_WinAPI_DrawEdge($hDC, DllStructGetPtr($tRect), $EDGE_ETCHED, $BF_TOP)
						EndIf
						$sText = StringTrimRight($sText, 1)
					EndIf
					DllStructSetData($tRect, 2, $iTop + 4)
					_WinAPI_DrawText($hDC, $sText, $tRect, $DT_LEFT)
					Switch $sText
						Case "Medabi-"
							_WinAPI_SetTextColor($hDC, 0xFFFF00)
						Case "V!c†o®"
							_WinAPI_SetTextColor($hDC, 0x0000FF)
						Case "joelson0007"
							_WinAPI_SetTextColor($hDC, 0xFF0000)
						Case "JScript"
							_WinAPI_SetTextColor($hDC, 0xFFB5C5)
						Case "www.autoitbrasil.com", "www.autoitscript.com"
							_WinAPI_SetTextColor($hDC, 0x0000FF)
						Case Else
							$clrForeground = _WinAPI_SetTextColor($hDC, $clrWindowText)
					EndSwitch
					;_WinAPI_SetTextColor($hDC, $clrForeground)
					_WinAPI_SetBkColor($hDC, $clrBackground)
				EndIf
				_WinAPI_SetBkMode($hDC, $TRANSPARENT)

			Case $ODS_COMBOBOXEDIT
				Exit
		EndSwitch
	EndIf

	$tRect = 0

	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_DRAWITEM

Func _WM_COMMAND($hWnd, $iMsg, $iwParam, $ilParam)
	#forceref $hWnd, $iMsg
	Local $hWndFrom, $iIDFrom, $iCode, $hWndCombo
	If Not IsHWnd($ComboBox) Then $hWndCombo = GUICtrlGetHandle($ComboBox)
	$hWndFrom = $ilParam
	$iIDFrom = BitAND($iwParam, 0xFFFF) ; Low Word
	$iCode = BitShift($iwParam, 16) ; Hi Word

	Switch $hWndFrom
		Case $ComboBox, $hWndCombo
			Switch $iCode
				Case $CBN_CLOSEUP ; Sent when the list box of a combo box has been closed
					_DebugPrint("$CBN_CLOSEUP" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_DBLCLK ; Sent when the user double-clicks a string in the list box of a combo box
					_DebugPrint("$CBN_DBLCLK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_DROPDOWN ; Sent when the list box of a combo box is about to be made visible
					_DebugPrint("$CBN_DROPDOWN" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_EDITUPDATE ; Sent when the edit control portion of a combo box is about to display altered text
					_DebugPrint("$CBN_EDITUPDATE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_ERRSPACE ; Sent when a combo box cannot allocate enough memory to meet a specific request
					_DebugPrint("$CBN_ERRSPACE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_KILLFOCUS ; Sent when a combo box loses the keyboard focus
					_DebugPrint("$CBN_KILLFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_SELCHANGE ; Sent when the user changes the current selection in the list box of a combo box
					_DebugPrint("$CBN_SELCHANGE" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; Select Item
					;_GUICtrlComboBox_SetCurSel($ComboBox, _GUICtrlComboBox_GetCurSel($ComboBox))

					; no return value
				Case $CBN_SELENDCANCEL ; Sent when the user selects an item, but then selects another control or closes the dialog box
					_DebugPrint("$CBN_SELENDCANCEL" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_SELENDOK ; Sent when the user selects a list item, or selects an item and then closes the list
					_DebugPrint("$CBN_SELENDOK" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
				Case $CBN_SETFOCUS ; Sent when a combo box receives the keyboard focus
					_DebugPrint("$CBN_SETFOCUS" & @LF & "--> hWndFrom:" & @TAB & $hWndFrom & @LF & _
							"-->IDFrom:" & @TAB & $iIDFrom & @LF & _
							"-->Code:" & @TAB & $iCode)
					; no return value
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND

Func _DebugPrint($s_text, $line = @ScriptLineNumber)
	ConsoleWrite( _
			"!===========================================================" & @LF & _
			"+======================================================" & @LF & _
			"-->Line(" & StringFormat("%04d", $line) & "):" & @TAB & $s_text & @LF & _
			"+======================================================" & @LF)
EndFunc   ;==>_DebugPrint