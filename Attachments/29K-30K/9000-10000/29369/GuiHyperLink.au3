#include-once
#include <GuiConstants.au3>

Global Const $DebugIt = 1

#comments-start
;Global Const $WM_SETFONT = 0x30
Global Const $LOGPIXELSX = 88

; font weight
Global Const $FW_DONTCARE = 0
Global Const $FW_THIN = 100
Global Const $FW_EXTRALIGHT = 200
Global Const $FW_ULTRALIGHT = 200
Global Const $FW_LIGHT = 300
Global Const $FW_NORMAL = 400
Global Const $FW_REGULAR = 400
Global Const $FW_MEDIUM = 500
Global Const $FW_SEMIBOLD = 600
Global Const $FW_DEMIBOLD = 600
Global Const $FW_BOLD = 700
Global Const $FW_EXTRABOLD = 800
Global Const $FW_ULTRABOLD = 800
Global Const $FW_HEAVY = 900
Global Const $FW_BLACK = 900

;~ lfItalic
;~ Specifies an italic font if set to TRUE.
;~ lfUnderline
;~ Specifies an underlined font if set to TRUE.
;~ lfStrikeOut
;~ Specifies a strikeout font if set to TRUE.


Global Const $PROOF_QUALITY = 2
#comments-end

;~ typedef struct tagLITEM {
;~     UINT mask;
;~     int iLink;
;~     UINT state;
;~     UINT stateMask;
;~     WCHAR szID[MAX_LINKID_TEXT];
;~     WCHAR szUrl[L_MAX_URL_LENGTH];
;~ } LITEM, *PLITEM;

;~ Members

;~ 	mask
;~ 		Combination of one or more of the following flags, describing the information to set or retrieve.
;~ 			LIF_ITEMINDEX
;~ 				Retrieve the numeric item index. Items are always accessed by index, therefore you must always set this flag and assign a value to iLink. To obtain the item ID you must set both LIF_ITEMINDEX and LIF_ITEMID.
;~ 			LIF_STATE
;~ 				Use stateMask to get or set the state of the link.
;~ 			LIF_ITEMID
;~ 				Specify the item by the ID value given in szID.
;~ 			LIF_URL
;~ 				Set or get the URL for this item.
;~ 	iLink
;~ 		Value of type int that contains the item index. This numeric index is used to access a SysLink control link.
;~ 	state
;~ 		Combination of one or more of the following flags, describing the state of the item.
;~ 			LIS_ENABLED
;~ 				The link can respond to user input. This is the default unless the entire control was created with WS_DISABLED. In this case, all links are disabled.
;~ 			LIS_FOCUSED
;~ 				The link has the keyboard focus. Pressing ENTER sends a NM_CLICK notification.
;~ 			LIS_VISITED
;~ 				The link has been visited by the user. Changing the URL to one that has not been visited causes this flag to be cleared.
;~ 	stateMask
;~ 		Combination of flags describing which state item to get or set. Allowable items are identical to those allowed in state.
;~ 	szID
;~ 		WCHAR string that contains the ID name. The maximum number of characters in the array is MAX_LINKID_TEXT. The ID name cannot be used to access a SysLink control link. You use the item index to access the item.
;~ 	szUrl
;~ 		WCHAR string that contains the URL represented by the link. The maximum number of characters in the array is L_MAX_URL_LENGTH.

Global $hl_hwnd[1][1]
Global Const $ICC_LINK_CLASS = 0x8000
Global Const $LIF_ITEMINDEX = 0x1
Global Const $LIF_STATE = 0x2
Global Const $LIF_URL = 0x8
Global Const $LIF_ITEMID = 0x4
Global Const $LIS_ENABLED = 0x2
Global Const $LIS_FOCUSED = 0x1
Global Const $LIS_VISITED = 0x4
Global Const $MAX_LINKID_TEXT = 48
Global Const $L_MAX_URL_LENGTH = (2048 + 32 + StringLen("://"))
Global Const $WC_LINK = "SysLink"

Global Const $COINIT_MULTITHREADED = 0x0
Global Const $COINIT_APARTMENTTHREADED = 0x2
Global Const $COINIT_DISABLE_OLE1DDE = 0x4
Global Const $COINIT_SPEED_OVER_MEMORY = 0x8

Global Const $S_OK = 0x0
Global Const $S_FALSE = 0x1
Global Const $OLE_E_WRONGCOMPOBJ = 0x8004000E
Global Const $RPC_E_CHANGED_MODE = 0x80010106

;Global Const $WM_USER = 0x400

Global Const $LM_SETITEM = ($WM_USER + 0x302)
Global Const $LM_GETIDEALHEIGHT = ($WM_USER + 0x301)
Global Const $LM_GETITEM = ($WM_USER + 0x303)
Global Const $LM_HITTEST = ($WM_USER + 0x300)

Global Const $NMHDR = "int;int;int"
Global $LITEM = "int;int;int;int;char[" & $MAX_LINKID_TEXT & "];char[" & $L_MAX_URL_LENGTH & "]"
Global $NMLINK = $NMHDR & ";" & $LITEM

Global Enum $mask = 1, $iLink, $state, $stateMask, $szID, $szUrl

Func _GuiCtrlHyperLinkCreate($h_Gui, $s_text, $s_link, $s_LinkOn, $x = 10, $y = 10, $width = 120, $height = 20, $v_styles = -1, $v_exstyles = -1, _
		$FontName = "Arial", $FontSize = 10, $FontWeight = 400, $FontItalic = 0, $FontUnderline = 0, $FontStrikeThru = 0)
	Local $hyper_link, $hl, $l_hwnd, $style, $num_links = 0, $l
	Local $UDF_link_num = 0
	If Not IsHWnd($h_Gui) Then $h_Gui = HWnd($h_Gui)
	$style = BitOR($WS_CHILD, $WS_VISIBLE)
	If $v_styles <> - 1 Then $style = BitOR($style, $v_styles)
	If $v_exstyles = -1 Then $v_exstyles = 0
	Local $stICCE = DllStructCreate('dword;dword')
	DllStructSetData($stICCE, 1, DllStructGetSize($stICCE))
	DllStructSetData($stICCE, 2, $ICC_LINK_CLASS)
	DllCall('comctl32.dll', 'int', 'InitCommonControlsEx', 'ptr', DllStructGetPtr($stICCE))

	DllCall('ole32.dll', 'long', 'CoInitializeEx', 'int', 0, 'long', $COINIT_DISABLE_OLE1DDE)
	If IsArray($s_LinkOn) And IsArray($s_link) Then
		For $l = 0 To UBound($s_LinkOn) - 1
			$s_text = StringReplace($s_text, $s_LinkOn[$l], '<A HREF="' & $s_link[$l] & '">' & $s_LinkOn[$l] & '</A>')
			$num_links += @extended
		Next
		$hyper_link = $s_text
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then	_DebugPrint ("# of Links: " & $num_links)
		;----------------------------------------------------------------------------------------------
	ElseIf Not IsArray($s_LinkOn) And Not IsArray($s_link) Then
		$hyper_link = StringReplace($s_text, $s_LinkOn, '<A HREF="' & $s_link & '">' & $s_LinkOn & '</A>')
		$num_links = @extended
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then	_DebugPrint ("# of Links: " & $num_links)
		;----------------------------------------------------------------------------------------------
	Else
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then	_DebugPrint ("links and link on sizes don't match")
		;----------------------------------------------------------------------------------------------
		Return SetError(4, 4, -1)
	EndIf

	$l_hwnd = DllCall("user32.dll", "long", "CreateWindowEx", "long", $v_exstyles, _
			"str", $WC_LINK, "str", $hyper_link, _
			"long", $style, "long", $x, "long", $y, "long", $width, "long", $height, _
			"hwnd", $h_Gui, "long", 0, "hwnd", 0, "long", 0)
	If Not @error Then
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then	_DebugPrint ("$l_hwnd " & @TAB & ":" & $l_hwnd[0])
		;----------------------------------------------------------------------------------------------
		If IsArray($s_LinkOn) Then
			For $y = 0 To UBound($s_link) - 1
				$hl = _GuiCtrlHyperLinkSetLink($l_hwnd[0], $s_link[$y], Default, $UDF_link_num)
				;----------------------------------------------------------------------------------------------
				If $DebugIt Then	_DebugPrint ("$hl[0]: " & $hl[0])
				;----------------------------------------------------------------------------------------------
				$UDF_link_num += 1
			Next
		Else

			For $x = 0 To $num_links - 1
				$hl = _GuiCtrlHyperLinkSetLink($l_hwnd[0], $s_link, Default, $UDF_link_num)
				;----------------------------------------------------------------------------------------------
				If $DebugIt Then	_DebugPrint ("$hl[0]: " & $hl[0])
				;----------------------------------------------------------------------------------------------
				$UDF_link_num += 1
			Next
		EndIf

		If $hl[0] Then
			_GuiCtrlHyperLinkSetFont($l_hwnd[0], $FontName, $FontSize, $FontWeight, $FontItalic, $FontUnderline, $FontStrikeThru)
			ReDim $hl_hwnd[UBound($hl_hwnd) + 1][1]
			$hl_hwnd[0][0] += 1
			$hl_hwnd[$hl_hwnd[0][0]][0] = $l_hwnd[0]
			Return $l_hwnd[0]
		Else
			;----------------------------------------------------------------------------------------------
			If $DebugIt Then	_DebugPrint ("Error: $LM_SETITEM: " & @error)
			;----------------------------------------------------------------------------------------------
			ReDim $hl_hwnd[UBound($hl_hwnd) + 1][1]
			$hl_hwnd[0][0] += 1
			$hl_hwnd[$hl_hwnd[0][0]][0] = $l_hwnd[0]
			Return SetError(2, 2, $l_hwnd[0])
		EndIf
	Else
		;----------------------------------------------------------------------------------------------
		If $DebugIt Then	_DebugPrint ("Error: CreateWindowEx: " & @error)
		;----------------------------------------------------------------------------------------------
		Return SetError(1, 1, -1)
	EndIf

	Return 0
EndFunc   ;==>_GuiCtrlHyperLinkCreate

Func _GuiCtrlHyperLinkSetFont($h_hwnd, $FontName = "Arial", $FontSize = 10, $FontWeight = 400, $FontItalic = 0, $FontUnderline = 0, $FontStrikeThru = 0)
	Local $ret = DllCall("gdi32.dll", "long", "GetDeviceCaps", "long", 0, "long", $LOGPIXELSX)
	If ($ret[0] == -1) Then Return SetError(3, 3, 5)
	GUISetState(@SW_LOCK)
	Local $lfHeight = Round(($FontSize * $ret[2]) / 72, 0)
	Local $font = DllStructCreate("int;int;int;int;int;byte;byte;byte;byte;byte;byte;byte;byte;char[32]")
	DllStructSetData($font, 1, $lfHeight + 1)
	DllStructSetData($font, 5, $FontWeight)
	DllStructSetData($font, 6, $FontItalic)
	DllStructSetData($font, 7, $FontUnderline)
	DllStructSetData($font, 8, $FontStrikeThru)
	DllStructSetData($font, 12, $PROOF_QUALITY)
	DllStructSetData($font, 14, $FontName)
	$ret = DllCall("gdi32.dll", "long", "CreateFontIndirect", "long", DllStructGetPtr($font))

	DllCall("user32.dll", "int", "SendMessage", "hwnd", $h_hwnd, "int", $WM_SETFONT, "long", $ret[0], "int", True)
	GUISetState(@SW_UNLOCK)
EndFunc   ;==>_GuiCtrlHyperLinkSetFont

Func _GuiCtrlHyperLinkSetLink($l_hwnd, $s_link, $v_state = -1, $UDF_link_num = 0)
	Local $hl, $s_szID, $link, $v_mask
	If $v_state = -1 Then
		$v_mask = BitOR($LIF_URL, $LIF_ITEMINDEX, $LIF_ITEMID)
	Else
		$v_mask = BitOR($LIF_URL, $LIF_ITEMINDEX, $LIF_STATE, $LIF_ITEMID)
	EndIf
	$s_szID = StringFormat("%-" & $MAX_LINKID_TEXT & "s", "UDF Maniac HyperLink " & $UDF_link_num + 1)
	$link = DllStructCreate($LITEM)
	DllStructSetData($link, $mask, $v_mask)
	DllStructSetData($link, $iLink, $UDF_link_num)
	If $v_state <> - 1 Then
		DllStructSetData($link, $state, $v_state)
		DllStructSetData($link, $stateMask, $v_state)
	EndIf
	DllStructSetData($link, $szID, $s_szID)
	DllStructSetData($link, $szUrl, $s_link)
	$hl = DllCall("user32.dll", "int", "SendMessage", "hwnd", $l_hwnd, "int", $LM_SETITEM, "int", 0, "ptr", DllStructGetPtr($link))
	If $DebugIt Then
		_DebugPrint ("$hl[0]: " & $hl[0])
		_DebugPrint ( _
				"LM_SETITEM" & @LF & _
				"mask " & @TAB & ":" & DllStructGetData($link, $mask) & @LF & _
				"iLink " & @TAB & ":" & DllStructGetData($link, $iLink) & @LF & _
				"state " & @TAB & ":" & DllStructGetData($link, $state) & @LF & _
				"stateMask " & @TAB & ":" & DllStructGetData($link, $stateMask) & @LF & _
				"szID " & @TAB & ":" & DllStructGetData($link, $szID) & @LF & _
				"szUrl " & @TAB & ":" & DllStructGetData($link, $szUrl))
	EndIf
	Return $hl
EndFunc   ;==>_GuiCtrlHyperLinkSetLink

Func _GuiCtrlHyperLinkGetLinkInfo($l_hwnd, $UDF_link_num = 0)
	Local $hl, $s_szID, $link
	$s_szID = StringFormat("%-" & $MAX_LINKID_TEXT & "s", "UDF Maniac HyperLink " & $UDF_link_num + 1)
	$link = DllStructCreate($LITEM)
	DllStructSetData($link, $mask, BitOR($LIF_URL, $LIF_ITEMINDEX, $LIF_STATE, $LIF_ITEMID))
	DllStructSetData($link, $iLink, $UDF_link_num)
	DllStructSetData($link, $stateMask, BitOR($LIS_ENABLED, $LIS_FOCUSED, $LIS_VISITED))
	$hl = DllCall("user32.dll", "int", "SendMessage", "hwnd", $l_hwnd, "int", $LM_GETITEM, "int", 0, "ptr", DllStructGetPtr($link))
	If Not $hl[0] Then Return SetError(1, 1, 0)
	Return StringSplit(DllStructGetData($link, $state) & "|" & DllStructGetData($link, $szID) & "|" & DllStructGetData($link, $szUrl), "|")
EndFunc   ;==>_GuiCtrlHyperLinkGetLinkInfo
