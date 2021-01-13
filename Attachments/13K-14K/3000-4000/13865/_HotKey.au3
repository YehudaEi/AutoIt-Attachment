#include-once

#cs
===============================================================================
AutoIt Version: 3.2.2.0
Language:       English
Description:    Functions that assist with hotkeys.
Author:				Rob Saunders (admin@therks.com)
Function list:
	_ChooseHotKey
	_HotKeyToString
	_StringToHotKey
===============================================================================
#ce

Global Const $___HOTKEY_S_MODKEYS_KEYS = '#^!+'
Global Const $___HOTKEY_A_MODKEYS_NAMES[5] = [ 4, 'Win+', 'Ctrl+', 'Alt+', 'Shift+' ]
Global Const $___HOTKEY_S_KEYLIST_KEYS = 'a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|1|2|3|4|5|6|7|8|9|0|`|-|=|\|[|]|;|''|,|.|/|' & _
	'{space}|{enter}|{esc}|{bs}|{del}|{up}|{down}|{left}|{right}|{home}|{end}|{ins}|{pgup}|{pgdn}|' & _
	'{f1}|{f2}|{f3}|{f4}|{f5}|{f6}|{f7}|{f8}|{f9}|{f10}|{f11}|{f12}|{tab}|{printscreen}|{numlock}|{capslock}|{scrolllock}|{pause}|' & _
	'{numpad0}|{numpad1}|{numpad2}|{numpad3}|{numpad4}|{numpad5}|{numpad6}|{numpad7}|{numpad8}|{numpad9}|' & _
	'{numpadmult}|{numpadadd}|{numpadsub}|{numpaddiv}|{numpaddot}|{numpadenter}|{appskey}|{sleep}|' & _
	'!|{browser_back}|{browser_forward}|{browser_refresh}|{browser_stop}|{browser_search}|{browser_favorites}|{browser_home}|' & _
	'{volume_mute}|{volume_down}|{volume_up}|{media_next}|{media_prev}|{media_stop}|{media_play_pause}|' & _
	'{launch_media}|{launch_mail}|{launch_app1}|{launch_app2}|{backspace}|{delete}|{escape}|{insert}'
Global Const $___HOTKEY_S_KEYLIST_NAMES = 'A|B|C|D|E|F|G|H|I|J|K|L|M|N|O|P|Q|R|S|T|U|V|W|X|Y|Z|1|2|3|4|5|6|7|8|9|0|`|-|=|\|[|]|;|''|,|.|/|' & _
	'Space|Enter|Escape|Backspace|Delete|Up|Down|Left|Right|Home|End|Insert|Page Up|Page Down|' & _
	'F1|F2|F3|F4|F5|F6|F7|F8|F9|F10|F11|F12|Tab|PrintScreen|NumLock|CapsLock|ScrollLock|Pause/Break|' & _
	'NumPad 0|NumPad 1|NumPad 2|NumPad 3|NumPad 4|NumPad 5|NumPad 6|NumPad 7|NumPad 8|NumPad 9|' & _
	'NumPad Multiply|NumPad Add|NumPad Subtract|NumPad Divide|NumPad Period|NumPad Enter|Windows Application key|Computer SLEEP key|' & _
	'[ Win2k/XP specific keys ]|Browser: Back|Browser: Forward|Browser: Refresh|Browser: Stop|Browser: Search|Browser: Favorites|Browser: Web/Home|' & _
	'Volume: Mute|Volume: Down|Volume: Up|Media: Next|Media: Previous|Media: Stop|Media: Play/pause|' & _
	'Launch: Media player|Launch: E-mail program|Launch: User App1|Launch: User App2|Backspace|Delete|Escape|Insert'

#cs
===============================================================================
Description:		_ChooseHotKey
Parameter(s):		$sDefaultKey	- Default key to be selected when dialog window appears (in valid HotKeySet format). Default blank (no preselected hotkey).
					$iReturnType	- Specifies return value. See return value comments below. Default False.
					$sTitle			- Title for dialog window. Default "Choose HotKey"
					$iLeft			- Left position of dialog window. Default keyword or -1 to center.
					$iTop			- Top position of dialog window. Default keyword or -1 to center.
					$iStyle			- Style to apply to dialog window. Default keyword or -1 sets to BitOR($WS_CAPTION, $WS_POPUP, $WS_SYSMENU).
					$iExStyle		- Extended style to apply to dialog window. Default keyword or -1 sets to $WS_EX_TOOLWINDOW.
					$hParent		- Handle to parent window for dialog window to be child of.
					$bAutoDisable	- Set to True to auto disable/re-enable/re-activate parent window when dialog window appears/closes (does not apply if invalid $hParent set).
Return Value:		If user hits OK and $iReturnType = 0:
						Returns valid HotKeySet format string (ex: "#z", "^+{enter}", "#^!+{numpadadd}", etc.)
					If user hits OK and $iReturnType = 1:
						Returns array with following info:
							$array[0] = Keyboard key selected. ("c" or "{space}" etc)
							$array[1] = 1 if Windows key checked or 0 if not
							$array[2] = 1 if Ctrl key checked or 0 if not
							$array[3] = 1 if Alt key checked or 0 if not
							$array[4] = 1 if Shift key checked or 0 if not
							$array[5] = Valid HotKeySet format string (same as returntype 1)
					* Note: If the chosen hotkey is available (not already in use), @extended is set to 1, otherwise 0.
					If user hits Cancel:
						Returns "" and sets @error to 1 and @extended to 0
User CallTip:		_ChooseHotKey( [ $sDefaultKey = '' [, $iReturnType = 0 [, $sTitle = 'Choose HotKey' [, $iLeft = Default [, $iTop = Default [, $iStyle = Default [, $iExStyle = Default [, $hParent = 0 [, $bAutoDisable = True ] ] ] ] ] ] ] ] ] ) Show a dialog for a user to choose a HotKey for a HotKeySet function. (required: <_HotKey.au3>)
===============================================================================
#ce

Func _ChooseHotKey($sDefaultKey = '', $iReturnType = 0, $sTitle = 'Choose HotKey', $iLeft = Default, $iTop = Default, $iStyle = Default, $iExStyle = Default, $hParent = 0, $bAutoDisable = True)
	Do
		Local Const $iDEFBUTTONSTYLE	= 0x00000001 ; $BS_DEFPUSHBUTTON
		Local Const $iLABELSTYLE		= 0x00000200 ; $SS_CENTERIMAGE
		Local Const $iCOMBOSTYLE		= 0x00200003 ; BitOr($CBS_DROPDOWNLIST, $WS_VSCROLL)
		
		Local $aGM, $vReturn = '', $iError = 0, $iExtended = 0
		Local $aKeyInfo[6] = [ $sDefaultKey, 0, 0, 0, 0 ]

		If $sDefaultKey <> '' Then
			For $i = 1 to 4
				$aKeyInfo[0] = StringReplace($aKeyInfo[0], StringMid($___HOTKEY_S_MODKEYS_KEYS, $i, 1), '')
				If @extended Then $aKeyInfo[$i] = 1
			Next
		EndIf

		If $iStyle = Default OR $iStyle = -1 Then
			$iStyle = 0x80C80000 ; BitOr($WS_CAPTION, $WS_POPUP, $WS_SYSMENU)
		EndIf
		
		If $iExStyle = Default OR $iExStyle = -1  Then
			$iExStyle = 0x00000080 ; $WS_EX_TOOLWINDOW
		EndIf
		
		If $bAutoDisable AND IsHWnd($hParent) Then
			WinSetState($hParent, '', @SW_DISABLE)
		EndIf
		
		Local $iGUIOnEventMode = Opt('GUIOnEventMode', 0)
		Local $iGUICoordMode = Opt('GUICoordMode', 1)
		Local $sGUIDataSeparatorChar = Opt('GUIDataSeparatorChar', '|')
		
		Local $gui_Hotkey = GUICreate($sTitle, 200, 103, $iLeft, $iTop, $iStyle, $iExStyle, $hParent)
		
		GUICtrlCreateLabel('Modifier keys:', 5, 0, 190, 20, $iLABELSTYLE)
		Local $aKeyControls[5]
		$aKeyControls[1] = GuiCtrlCreateCheckbox('&Win', 5, 20, 40, 20)
		$aKeyControls[2] = GuiCtrlCreateCheckbox('&Ctrl', 50, 20, 40, 20)
		$aKeyControls[3] = GuiCtrlCreateCheckbox('&Alt', 95, 20, 30, 20)
		$aKeyControls[4] = GuiCtrlCreateCheckbox('&Shift', 135, 20, 40, 20)
		
		For $i = 1 to 4
			If $aKeyInfo[$i] Then
				GUICtrlSetState($aKeyControls[$i], 1) ; $GUI_CHECKED
			EndIf
		Next
		
		GUICtrlCreateLabel('&Key:', 5, 45, 25, 20, $iLABELSTYLE)
		$aKeyControls[0] = GUICtrlCreateCombo('', 35, 45, 160, 200, $iCOMBOSTYLE)

		Local $iComboCutoff = StringInStr($___HOTKEY_S_KEYLIST_NAMES, '|', 0, 116) - 1
		GUICtrlSetData(-1, StringLeft($___HOTKEY_S_KEYLIST_NAMES, $iComboCutoff), 'Space')
		If $aKeyInfo[0] <> '' Then
			Local $sLookupKey = ___HotKeyInc_INTERNAL_LOOKUPKEY($aKeyInfo[0], True)
			If Not @error Then
				GUICtrlSetData(-1, $sLookupKey)
			EndIf
		EndIf
		
		Local $bt_OK = GUICtrlCreateButton('OK', 55, 75, 65, 23, $iDEFBUTTONSTYLE)
		Local $bt_Cancel = GUICtrlCreateButton('Cancel', 130, 75, 65, 23)
		GUISetState(@SW_SHOW, $gui_Hotkey)
		ControlFocus($gui_Hotkey, '', $aKeyControls[0])
		
		While 1
			$aGM = GUIGetMsg(1)
			If $aGM[1] = $gui_Hotkey Then
				Switch $aGM[0]
					Case $bt_OK
						$aKeyInfo[0] = GUICtrlRead($aKeyControls[0])
						For $i = 1 to 4
							If GUICtrlRead($aKeyControls[$i]) = 1 Then
								$vReturn &= StringMid($___HOTKEY_S_MODKEYS_KEYS, $i, 1)
								$aKeyInfo[$i] = 1
							EndIf
						Next
						$sLookupKey = ___HotKeyInc_INTERNAL_LOOKUPKEY($aKeyInfo[0])
						$vReturn &= $sLookupKey
						$aKeyInfo[0] = $sLookupKey
						
						$iExtended = HotKeySet($vReturn, '___HotKeyInc_INTERNAL_CHOOSEHOTKEY_DUMMY')
						If $iExtended Then
							HotKeySet($vReturn)
						EndIf
						
						If $iReturnType Then
							$aKeyInfo[5] = $vReturn
							$vReturn = $aKeyInfo
						EndIf
						$iError = 0
						ExitLoop
					Case $bt_Cancel, -3 ; $GUI_EVENT_CLOSE = -3
						$iError = 1
						ExitLoop
				EndSwitch
			EndIf
		WEND
		
		GUIDelete($gui_Hotkey)
	Until True
	
	Opt('GUIOnEventMode', $iGUIOnEventMode)
	Opt('GUICoordMode', $iGUICoordMode)
	Opt('GUIDataSeparatorChar', $sGUIDataSeparatorChar)
	If $bAutoDisable AND IsHWnd($hParent) Then
		WinSetState($hParent, '', @SW_ENABLE)
		WinActivate($hParent)
	EndIf
	
	Return SetError($iError, $iExtended, $vReturn)
EndFunc ;==>_ChooseHotKey

#cs
===============================================================================
Description:		_HotKeyToString
Parameter(s):		$sKeyIn	- Key combo in valid HotKeySet format (ie: ^!a).
Return Value:		Conversion of input hotkey to string representation.
User CallTip:		_HotKeyToString( $sKeyIn ) Convert hotkey to string. (required: <_HotKey.au3>)
Examples:			In: #^c
					Out: Win+Ctrl+C
					In: !{numpadmult}
					Out: Alt+NumPad Multiply
===============================================================================
#ce
Func _HotKeyToString($sKeyIn)
	Local $sKeyOut
	For $i = 1 to 4
		$sKeyIn = StringReplace($sKeyIn, StringMid($___HOTKEY_S_MODKEYS_KEYS, $i, 1), '')
		If @extended Then
			$sKeyOut &= $___HOTKEY_A_MODKEYS_NAMES[$i]
		EndIf
	Next
	$sKeyOut &= ___HotKeyInc_INTERNAL_LOOKUPKEY($sKeyIn, 1)
	If @error Then
		Return SetError(1, 0, '')
	EndIf
	Return $sKeyOut
EndFunc ;==>_HotKeyToString

#cs
===============================================================================
Description:		_StringToHotKey
Parameter(s):		$sKeyIn	- Key combo in string representation (ie: Ctrl+Alt+A).
Return Value:		Conversion of string representation to valid hotkey.
User CallTip:		_StringToHotKey( $sKeyIn ) Convert string to hotkey. (required: <_HotKey.au3>)
Examples:			In: Win+Ctrl+C
					Out: #^c
					In: Ctrl+Pause/Break
					Out: ^{pause}
Notes:				This function is not necessarily very useful because it relies on the input to coordinate with the 
					$___HOTKEY_S_KEYLIST_NAMES global variable (ie: some people might write their hotkeys like 
					"Control+Alt+Break", and this function relies on it looking like "Ctrl+Alt+Pause/Break").
					I provided it mainly for converting the return from _HotKeyToString back to a valid hotkey
					format if needed.
===============================================================================
#ce
Func _StringToHotKey($sKeyIn)
	Local $sKeyOut
	For $i = 1 To 4
		$sKeyIn = StringReplace($sKeyIn, $___HOTKEY_A_MODKEYS_NAMES[$i], '')
		If @extended Then
			$sKeyOut &= StringMid($___HOTKEY_S_MODKEYS_KEYS, $i, 1)
		EndIf
	Next
	$sKeyOut &= ___HotKeyInc_INTERNAL_LOOKUPKEY($sKeyIn)
	If @error Then
		Return SetError(1, 0, '')
	EndIf
	Return $sKeyOut
EndFunc ;==>_StringToHotKey

#cs
===============================================================================
Internally used functions, not useful for end-user.
===============================================================================
#ce

Func ___HotKeyInc_INTERNAL_LOOKUPKEY($sFind, $bLookForKey = False)
	Local $iFindPos, $sStringTo, $iPipeCount, $iPipeFrom, $iPipeTo, $sLookin, $sFindIn
	If $bLookForKey Then
		$sLookIn = $___HOTKEY_S_KEYLIST_KEYS
		$sFindIn = $___HOTKEY_S_KEYLIST_NAMES
	Else
		$sLookIn = $___HOTKEY_S_KEYLIST_NAMES
		$sFindIn = $___HOTKEY_S_KEYLIST_KEYS
	EndIf
	$iFindPos = StringInStr($sLookIn, $sFind)
	If Not $iFindPos Then
		SetError(1)
		Return ''
	EndIf
	$sStringTo = StringLeft($sLookIn, $iFindPos)
	
	StringReplace($sStringTo, '|', '')
	$iPipeCount = @extended
	$iPipeFrom = StringInStr($sFindIn, '|', 0, $iPipeCount) + 1
	$iPipeTo = StringInStr($sFindIn, '|', 0, $iPipeCount + 1)
	Return StringMid($sFindIn, $iPipeFrom, $iPipeTo - $iPipeFrom)
EndFunc ;==>___HotKeyInc_INTERNAL_LOOKUPKEY

Func ___HotKeyInc_INTERNAL_CHOOSEHOTKEY_DUMMY()
	Return ; Only used in _ChooseHotKey to find out if a hotkey is in use or not.
EndFunc ;==>___HotKeyInc_INTERNAL_CHOOSEHOTKEY_DUMMY

