#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_type=a3x
#AutoIt3Wrapper_Outfile=WindowsSpotlightFocusGUI.a3x
;~ #AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_After=del WindowsSpotlightFocusGUI_Obfuscated.au3
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/om /cn=0 /cs=0 /sf=1 /sv=1
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPI.au3>
#include <WinAPIGdi.au3>
#include <WinAPISys.au3>
;#include <_MouseFunctions.au3> ; (Functions embedded)
; ===============================================================================================================================
; <WindowsSpotlightFocusGUI.au3>
;
; Spotlight/Focus GUI: Choose from 2 different styles of GUI 'focus':
;	1. 'Spotlight' GUI: Everything but a circular (or rounded-rect) 'hole' is dimmed, creating a spotlight effect on
;      the screen where the mouse is focused. (created using a GUI 2x the size of the screen with a 'hole' Region)
;   2. 'Focus' GUI: Everything except the Active Window is dimmed. This is like a dynamically sized version of
;      a 'Rect' Spotlight GUI which resizes/moves itself to the current Active window.
;
;  Note the Spotlight GUI doesn't take into account keyboard focus, which would actually round out this script!
;
; To DO:
; - Make spotlight also follow keyboard focus when appropriate (when typing)
;
; To lock/unlock Spotlight GUI:
;  - Ctrl+Shift+DOWN hotkey  (Ctrl+Alt+Down won't work for some reason)
; To lock/unlock Focus GUI (to a specific window):
;  - Ctrl+Shift+SPACE hotkey
;
; To Exit:
;  - Use Tray menu or Ctrl+Alt+Q hotkey code
;
; Tweakables:
; 	- STYLE / COLOR / TRANSPARENCY Settings
;     $nSpotlightStyle: 0 = Circle Spotlight, 1 = Rounded-Rect, 2 = Wide-Rect
;	  $nSpotlightDiameter: the size of the circular spotlight 'hole' surrounding the mouse (mouse is centered in this area)
;     $nSpotlightSqDiameter: Rounded-rect width/height
;     $nSpotlightRectWidth/Height: Wide-Rect width/height
;	  $nShadeColor:   color of the 'shade' GUI. Seems anything grayscale works well (RGB: 0x000000, 0x111111, 0xFFFFFF)
;	  $n{..}Transparency: level of transparency. From 0-255, with 0 = invisible and  255 = solid (BAD!)
;     $nRoundRectCornerWidth:  Rounded-Rect corners' circle width/height
;
; NTFS ADS Info:
;  "Alternate Data Streams Viewer" by trancexx
;   @ http://www.autoitscript.com/forum/topic/149659-alternate-data-streams-viewer/
;  "Save INI data to exe. (while open)" by nullschritt
;   @ http://www.autoitscript.com/forum/topic/155669-save-ini-data-to-exe-while-open/
;
; See also:
;  <WindowsDimlightShadedFocusGUI.au3>  ; Basically the reverse of this - a dimmed circle GUI follows the mouse,
;                                       ; creating a reverse-spotlight effect (or a dim-light affect if u will)
; Author: Ascend4nt
; ===============================================================================================================================

; Singleton code:
Global Const $sSINGLETON_STRING = "Spotlight[0bc53fe0-59c2-11e2-bcfd-0800200c9a66]"
If WinExists($sSINGLETON_STRING) Then Exit
AutoItWinSetTitle($sSINGLETON_STRING)

; ====================================================================================================
; STYLE / COLOR / TRANSPARENCY Settings
; ====================================================================================================
Global Const $nSpotlightStyle = 1			; 0 = Circle, 1 = Rounded Rect, 2 = Wide Rect
Global Const $nSpotlightDiameter = 500
Global Const $nSpotlightSqDiameter = 450
Global Const $nSpotlightRectWidth = 800, $nSpotlightRectHeight = 320
Global Const $nShadeColor = 0
Global Const $nSpotlightTransparency = 110, $nFocusTransparency = 110
Global Const $nRoundRectCornerWidth = 16
Global Const $nSpotlightXHairState = 0   ; 0 = No Spotlight-XHair, 1 = Full, 2 = Horizontal ( - ), 3 = Vertical ( | )
Global Const $nSpotlightXHairDiameter = 4	; This is divided by 2 and the Spotlight X-Hair will be offset by this from center (use even #'s)
Global Const $nSpotlightXHairYOffset = 0 	; 8-10 is nice for hovering under most lines of text
; Global Const $nSpotlightXHairXOffset = 0 ; ?? offseting X seems a bit odd and not very useful

; ====================================================================================================
; GLOBAL VARIABLES
; ====================================================================================================

Global $g_bHKPressed = False

Global $g_aINISettings = 0

Global $g_bFocusOn = 0, $g_bSpotlightOn = 1
Global $g_nSpotlightStyle = $nSpotlightStyle ; 0 = Circle, 1 = Rounded Rect, 2 = Wide Rect
Global $g_nMouseCursorState = 1		 ; -1 = Default Cursors, 0 = Hidden Cursors, 1 = CrossHair Cursor
Global $g_aCursorStateSelect[3]		 ; Cursor State Tray ID's
Global $g_nSpotlightXHairState = $nSpotlightXHairState	; 0 = No Spotlight-XHair, 1 = Full, 2 = Horizontal ( - ), 3 = Vertical ( | )
Global $g_aSpotlightXHairSelect[4]	 ; Spotlight-XHair State Tray ID's

Global $g_hSpotlightGUI = 0, $g_hFocusGUI = 0, $g_nTransitions = 0, $g_nActiveGUICount = 0, $g_hLastActiveWin = 0
Global $g_aSpotLockDown[4] = [0, 0, 0, 0]	; Spotlight Lockdown: toggle, Center-X, Center-Y location, Tray ID #
Global $g_ctFocusLock = 0, $g_hFocusLockDown = -1

Global $g_iResolutionChangeMsg = 0

; This array will be updated with resolution changes, as well as some GUI rebuilds
Global $g_aVScrRect[4] = [0, 0, @DesktopWidth, @DesktopHeight]

Global $g_hGDI32DLL = DllOpen("gdi32.dll"), $g_hUSER32DLL = DllOpen("user32.dll")


; Global Vars quick-exit test
If ($g_hGDI32DLL = -1 Or $g_hUSER32DLL = -1) Then Exit


; ###############################################
#Region MOUSE_FUNCTIONS_PARTIAL_UDF_DATA

; Mouse-Replace Cursor handles (associative with Cursor ID's). See 'Standard Cursor IDs' in _MouseFunctions UDF
Global $MCF_aSysCursors[16][2] = [ _
		[32512, 0],[32513, 0],[32514, 0],[32515, 0],[32516, 0],[32640, 0],[32641, 0],[32647, 0],[32648, 0],[32649, 0],[32650, 0], _
		[32642, 0],[32643, 0],[32644, 0],[32645, 0],[32646, 0]] ; Sizing cursors

Global $MCF_bCursorsReplaced = False

#EndRegion MOUSE_FUNCTIONS_PARTIAL_UDF_DATA
; ###############################################

; /**************************************************************************************************/
#Region MAIN_CODE
_WinMain()

Func _WinMain()
	; Initialize Global Width/Height vars
	_VirtualScreenSizeUpdate()

	;AutoItWinSetTitle("WindowSpotlightFocusGUI("&@AutoItPID&")")	; would cancel out or Singleton test
	; Move the invisible window off-screen (mostly).  This was mainly because in tests, the AutoIt invisible window
	; would *actually* beomme the ACTIVE window. (Mainly when the tray icon is clicked and loses focus in some way)
	WinMove(AutoItWinGetTitle(), "", $g_aVScrRect[0]+$g_aVScrRect[2]-1, $g_aVScrRect[1]+$g_aVScrRect[3]-1)


	Opt("TrayAutoPause", 0)
	Opt("TrayOnEventMode", 1)
	Opt("TrayMenuMode", 1) ;+2) ; We want toggled and radio button automatic behavior
	Opt("GUIOnEventMode", 1)

	; Logic check (before reading INI)
	If $g_nMouseCursorState And $g_nSpotlightXHairState Then $g_nMouseCursorState = 0

	; Restore INI data (and save on program exit) if this script is compiled
	; (and the folder is writable) - uses NTFS ADS (Alternate Data Streams)
	If @Compiled Then
		_INI_UpdateDataFromExeINI()
		OnAutoItExitRegister("_INI_SaveDataToExeINI")
	EndIf

	; #--------- TRAY MENU SETUP --------------#
	;TraySetClick(9)	; 9 is Default (left or right mouse-click)
	TrayCreateItem("Rounded-Rect Spotlight", -1, -1, 1)
	TrayItemSetOnEvent(-1, "_RoundRectSpotlight_TEvt")
	If $g_nSpotlightStyle = 1 Then TrayItemSetState(-1, 1)
	TrayCreateItem("Wide-Rect Spotlight", -1, -1, 1)
	TrayItemSetOnEvent(-1, "_WideRectSpotlight_TEvt")
	If $g_nSpotlightStyle = 2 Then TrayItemSetState(-1, 1)
	TrayCreateItem("Circle Spotlight", -1, -1, 1)
	TrayItemSetOnEvent(-1, "_CircleSpotlight_TEvt")
	If $g_nSpotlightStyle = 0 Then TrayItemSetState(-1, 1)
	TrayCreateItem("")
	$g_aSpotlightXHairSelect[0] = TrayCreateItem("Spotlight Crosshair - NONE", -1, -1, 1)
	$g_aSpotlightXHairSelect[1] = TrayCreateItem("Spotlight Crosshair - FULL (+)", -1, -1, 1)
	$g_aSpotlightXHairSelect[2] = TrayCreateItem("Spotlight Crosshair - Horizontal (-)", -1, -1, 1)
	$g_aSpotlightXHairSelect[3] = TrayCreateItem("Spotlight Crosshair - Vertical ( | )", -1, -1, 1)
	TrayItemSetState($g_aSpotlightXHairSelect[$g_nSpotlightXHairState], 1)
	For $i = 0 To 3
		TrayItemSetOnEvent($g_aSpotlightXHairSelect[$i], "_SpotlightXHairSelect_TEvt")
	Next
	TrayCreateItem("")
	$g_aSpotLockDown[3] = TrayCreateItem("Lock Spotlight Position (CTRL+SHIFT+DOWN)")
	TrayItemSetOnEvent(-1, "_LockUnlockSpotlight")
	If $g_aSpotLockDown[0] Then TrayItemSetState(-1, 1)
	$g_ctFocusLock = TrayCreateItem("Lock Focus GUI to Window (CTRL+SHIFT+SPACE)")
	TrayItemSetOnEvent(-1, "_LockUnlockFocus")
	; Saving Focus Lockdown windows between runs is iffy, as we obviously can't save the HWND
	; We CAN save Classname, Title (not wise as titles change), and Window Styles (also can change),
	; but as there can be more than 1 window of a given Class, and Titles & Windows Styles can change
	; it really doesn't make much sense
	;If IsHWnd($g_hFocusLockDown) Then TrayItemSetState(-1, 1)
	TrayCreateItem("")
	$g_aCursorStateSelect[0] = TrayCreateItem("Mouse Cursor - Defaults", -1, -1, 1)
	$g_aCursorStateSelect[1] = TrayCreateItem("Mouse Cursor - Hidden", -1, -1, 1)
	$g_aCursorStateSelect[2] = TrayCreateItem("Mouse Cursor - CrossHair", -1, -1, 1)
	TrayItemSetState($g_aCursorStateSelect[$g_nMouseCursorState + 1], 1)
	For $i = 0 To 2
		TrayItemSetOnEvent($g_aCursorStateSelect[$i], "_MouseCursorSelect_TEvt")
	Next
	TrayItemSetOnEvent(-1, "_MouseCursorSelect_TEvt")
	TrayCreateItem("")
	TrayCreateItem("Toggle Spotlight")
	TrayItemSetOnEvent(-1, "_ToggleSpotlight_TEvt")
	If $g_bSpotlightOn Then TrayItemSetState(-1, 1)
	TrayCreateItem("Toggle Window-Focus")
	TrayItemSetOnEvent(-1, "_ToggleFocus_TEvt")
	If $g_bFocusOn Then TrayItemSetState(-1, 1)
	TrayCreateItem("")
	TrayCreateItem("Exit")
	TrayItemSetOnEvent(-1, "_Exit_TEvt")
	TraySetState()
	TraySetToolTip("Windows Spotlight GUI (click for options)")
	; #----------------- X ---------------------#


	; CTRL-ALT-Q Exit Hotkey
	HotKeySet("!^q", "_HotKeyPressed")
	; CTRL-SHIFT-DOWN Lock/Release Spotlight Hotkey
	HotKeySet("+^{DOWN}", "_LockUnlockSpotlight")
	; CTRL-SHIFT-SPACE Lock/Release Focus-Window Hotkey
	HotKeySet("+^{SPACE}", "_LockUnlockFocus")

	; ----------------------------------------------------------------------------------------------------|
	; Register Display-Mode changes to our function.
	;	NOTE that a GUI (*any* GUI) MUST be created or else the WM_DISPLAYCHANGE message won't be received
	;	UPDATE: Can't do it this way - we need to know exactly how many GUI's area active
	;   (hence a global count and the _GUICountChange() function.
	; ----------------------------------------------------------------------------------------------------|
	;GUIRegisterMsg(0x007E, "_ResolutionChanged") ;	WM_DISPLAYCHANGE 0x007E

	; Update GUI Count and register Rez-Chg message if any active
	_GUICountChange()

	; Cursor State
;~ 	If $g_nMouseCursorState < 0 Then
		; Normal Cursors
	;Else
	If $g_nMouseCursorState = 0 Then
		_MouseHideAllCursors()
	Else
		_MouseReplaceAllCursors(True)
	EndIf

		; Setup mouse cursor restore function on exit (regarldess of setting):
		OnAutoItExitRegister("_MouseRestoreAllCursors")

	; Not necessary, but can free some memory by flushing data to disk
	DllCall("psapi.dll", "bool", "EmptyWorkingSet", "handle", -1)


	Local $iRezChg = 0, $hTopMostWnd = 0

	; Main loop
	While 1
		If $g_bHKPressed Then ExitLoop

		; Exit on 'ESC' keypress (BitAND() test for down-state)
		;If BitAND(_WinAPI_GetAsyncKeyState(0x1B), 0x8000) Then ExitLoop

		; Reset RezChg Message to be sent
		$iRezChg = 0

		; Rez change?  Update metrics if necessary amount of Rez-Change Messages received (1 per GUI)
		If $g_iResolutionChangeMsg And $g_iResolutionChangeMsg = $g_nActiveGUICount Then
			ConsoleWrite("Main Loop WM_DISPLAYCHANGE detected, $g_iResolutionChangeMsg = " & $g_iResolutionChangeMsg & @LF)
			_VirtualScreenSizeUpdate()
			$g_iResolutionChangeMsg = 0
			$iRezChg = 1
		EndIf

	; Mouse/Keyboard-Cursor Spotlight GUI Active?
		; *Note: Call this FIRST as it gets the current Mouse position*
		If $g_bSpotlightOn Then
			_SpotlightGUIUpdate($iRezChg)
		EndIf

	; Window-Focus GUI active?
		If $g_bFocusOn Then
			_FocusGUIUpdate($iRezChg)
		EndIf

		; Check the topmost status and reset our GUI's if necessary
		; This was taken out of main Update loops, as there can be a bit of flashing when moving windows
		$hTopMostWnd = _WinAPI_GetTopWindow(0)
		If $g_hSpotlightGUI <> $hTopMostWnd And $g_hFocusGUI <> $hTopMostWnd Then
			;ConsoleWrite("WinOnTop hWnd = " & $hTopMostWnd & ", Title = " & WinGetTitle($hTopMostWnd) & @LF)
			If $g_bSpotlightOn Then WinSetOnTop($g_hSpotlightGUI, "", 1)
			If $g_bFocusOn Then WinSetOnTop($g_hFocusGUI, "", 1)
		EndIf

		Sleep(20)
	WEnd

	; Unregister Display Mode change function
	;GUIRegisterMsg(0x007E, "") ;	WM_DISPLAYCHANGE 0x007E

	; And restore all system cursors back to normal (called automatically via OnAutoItExitRegister)
	;_MouseRestoreAllCursors()
EndFunc
#EndRegion MAIN_CODE
; /**************************************************************************************************/

; ###############################################
#Region MISC_FUNCTIONS
; _GUICountChange() -> adjust counts and set/unset DisplayChange Messages
Func _GUICountChange()
	Local $iTotalActiveGUIs = 0
	; Maximum 2 GUI's
	If $g_bFocusOn Then $iTotalActiveGUIs += 1
	If $g_bSpotlightOn Then $iTotalActiveGUIs += 1

	If $iTotalActiveGUIs = 0 Then
		; Was there previously GUI's active?
		If $g_nActiveGUICount Then
			; UnRegister Rez-Chg message
			GUIRegisterMsg(0x007E, "") ;	WM_DISPLAYCHANGE 0x007E
			ConsoleWrite("0 GUI's active, WM_DISPLAYCHANGE unregistered" & @LF)
		EndIf
	Else
		; Were no GUI's active previously?
		If $g_nActiveGUICount = 0 Then
			; Register Rez-Chg message
			GUIRegisterMsg(0x007E, "_ResolutionChanged") ;	WM_DISPLAYCHANGE 0x007E
			ConsoleWrite($iTotalActiveGUIs & " GUI's active, WM_DISPLAYCHANGE registered" & @LF)
		EndIf
		WinSetTrans($g_hFocusGUI, "", $g_bSpotlightOn ? ($nFocusTransparency / 2) : $nFocusTransparency)
		WinSetTrans($g_hSpotlightGUI, "", $g_bFocusOn ? ($nSpotlightTransparency / 2) : $nSpotlightTransparency)
	EndIf
	; Update global count now that we've compared states
	$g_nActiveGUICount = $iTotalActiveGUIs
EndFunc
Func _VirtualScreenSizeUpdate()
	; Set up VScreen Coords: 0, 1 = Upper Left X, Y (CAN be negative!!!), 2, 3 = Virtual Width, Height
	; SM_XVIRTUALSCREEN = 76, SM_YVIRTUALSCREEN = 77, SM_CXVIRTUALSCREEN = 78, SM_CYVIRTUALSCREEN = 79
	Dim $g_aVScrRect[4] = [_WinAPI_GetSystemMetrics(76), _WinAPI_GetSystemMetrics(77), _WinAPI_GetSystemMetrics(78), _WinAPI_GetSystemMetrics(79)]
	If $g_aVScrRect[2] = 0 Then $g_aVScrRect[2] = @DesktopWidth
	If $g_aVScrRect[3] = 0 Then $g_aVScrRect[3] = @DesktopHeight

	ConsoleWrite("VirtualScreen X: " & $g_aVScrRect[0] & ", Y: " & $g_aVScrRect[1] & ", Width = " & $g_aVScrRect[2] & ", Height = " & $g_aVScrRect[3] & @LF)
	; Alternative Way to get Virtual Screen Width/Height: CreateDC with 'DISPLAY', GetDeviceCape(8) [HORZRES] and (10) [VERTRES], DeleteDC()
EndFunc
#EndRegion MISC_FUNCTIONS
; ###############################################


; ###############################################
#Region HOTKEY_FUNCTIONS
Func _HotKeyPressed()	; CTRL-ALT-Q Key Pressed:
	$g_bHKPressed = True
EndFunc   ;==>_HotKeyPressed
Func _LockUnlockSpotlight()
	; Off? Turn Lockdown on then
	If Not $g_aSpotLockDown[0] Then
		Local $aMousePos = MouseGetPos()
		$g_aSpotLockDown[1] = $aMousePos[0]
		$g_aSpotLockDown[2] = $aMousePos[1]
		TrayItemSetState($g_aSpotLockDown[3], 1)
	Else
		TrayItemSetState($g_aSpotLockDown[3], 4)
	EndIf

	$g_aSpotLockDown[0] = Not $g_aSpotLockDown[0]
	;ConsoleWrite("Lock/Unlock Spotlight Hotkey Pressed (or Menu item selected)" & @LF)
EndFunc
Func _LockUnlockFocus()
	; Off? Turn Lockdown on then
	If $g_hFocusLockDown <= 0 Then
		; Set the active window even when Focus window isn't on
		If Not $g_bFocusOn Then $g_hLastActiveWin = WinGetHandle("[ACTIVE]")
		$g_hFocusLockDown = $g_hLastActiveWin
		TrayItemSetState($g_ctFocusLock, 1)
	Else
		$g_hFocusLockDown = -1
		;$g_hLastActiveWin = -1
		TrayItemSetState($g_ctFocusLock, 4)
	EndIf
	;ConsoleWrite("Lock/Unlock Focus GUI Hotkey pressed" & @LF)
EndFunc
#EndRegion HOTKEY_FUNCTIONS
; ###############################################



; ###############################################
#Region WINDOWS_MESSAGE_HANDLER_FUNCTIONS

; ====================================================================================================
; Func _ResolutionChanged($hWnd,$iMsg,$wParam,$lParam)
;
; Note this registers multiple-monitor settings changes too, but will only report on the primary monitor's resolution
;	This is why we would need to call _WinAPI_GetSystemMetrics() to get the Virtual width/height
; ====================================================================================================

Func _ResolutionChanged($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam, $lParam
	; Apparently under certain circumstances, we can receive more messages than GUI's!!
	If $g_iResolutionChangeMsg < $g_nActiveGUICount Then $g_iResolutionChangeMsg += 1
;~ 	ConsoleWrite("_ResolutionChanged msg recieved, $g_iResolutionChangeMsg = " & $g_iResolutionChangeMsg & @LF)
	Return 'GUI_RUNDEFMSG' ; From <GUIConstantsEx.au3> Global Const $GUI_RUNDEFMSG = 'GUI_RUNDEFMSG'
EndFunc   ;==>_ResolutionChanged

#EndRegion WINDOWS_MESSAGE_HANDLER_FUNCTIONS
; ###############################################



; ###############################################
#Region TRAY_EVENT_HANDLER_FUNCS
Func _RoundRectSpotlight_TEvt()
	If $g_nSpotlightStyle <> 1 Then
		$g_nSpotlightStyle = 1
		If $g_bSpotlightOn Then _SpotlightGUIUpdate(1)
	EndIf
EndFunc
Func _WideRectSpotlight_TEvt()
	If $g_nSpotlightStyle <> 2 Then
		$g_nSpotlightStyle = 2
		If $g_bSpotlightOn Then _SpotlightGUIUpdate(1)
	EndIf
EndFunc
Func _CircleSpotlight_TEvt()
	If $g_nSpotlightStyle Then
		$g_nSpotlightStyle = 0
		If $g_bSpotlightOn Then _SpotlightGUIUpdate(1)
	EndIf
EndFunc
Func _MouseCursorSelect_TEvt()
	Switch @TRAY_ID
		Case $g_aCursorStateSelect[0]
			$g_nMouseCursorState = -1
			_MouseRestoreAllCursors()
		Case $g_aCursorStateSelect[1]
			$g_nMouseCursorState = 0
			_MouseHideAllCursors()
		Case $g_aCursorStateSelect[2]
			$g_nMouseCursorState = 1
			_MouseReplaceAllCursors(True)
	EndSwitch
	; This will remain in effect regardless of Mouse Cursor state (harmless):
	;OnAutoItExitRegister("_MouseRestoreAllCursors")
EndFunc
Func _SpotlightXHairSelect_TEvt()
	Local $nPrevState = $g_nSpotlightXHairState
	Switch @TRAY_ID
		Case $g_aSpotlightXHairSelect[0]	; NO X-Hair Spotlight
			$g_nSpotlightXHairState = 0
		Case $g_aSpotlightXHairSelect[1]	; FULL X-Hair Spotlight
			$g_nSpotlightXHairState = 1
		Case $g_aSpotlightXHairSelect[2]	; Horizontal X-Hair Spotlight
			$g_nSpotlightXHairState = 2
		Case $g_aSpotlightXHairSelect[3]	; Vertical X-Hair Spotlight
			$g_nSpotlightXHairState = 3
	EndSwitch
	If $nPrevState <> $g_nSpotlightXHairState And $g_bSpotlightOn Then
		GUIDelete($g_hSpotlightGUI)
		; Force re-initialization
		$g_hSpotlightGUI = 0
		; For the sake of sanity, adjust mouse cursors based on FULL/No X-Hair toggles
		; If SpotlightXHairState is now disabled, and all Mouse Cursors are currently hidden, reenable at least the crosshair cursor
		If $g_nSpotlightXHairState = 0 And $g_nMouseCursorState = 0 Then
			ConsoleWrite("X-HAIR - MOUSE SANITY: Spotlight XHair Turned OFF, Mouse Cursors Hidden! ACTION: Enabling Crosshair cursors" & @LF)
			$g_nMouseCursorState = 1
			_MouseReplaceAllCursors(True)
			TrayItemSetState($g_aCursorStateSelect[0], 4)
			TrayItemSetState($g_aCursorStateSelect[1], 4)
			TrayItemSetState($g_aCursorStateSelect[2], 1)
		; If SpotlightXHairState is now fully enabled, and Mouse Cursors are currently the Crosshair cursor, choose to hide all cursors
		ElseIf $g_nSpotlightXHairState = 1 And $g_nMouseCursorState = 1 Then
		ConsoleWrite("X-HAIR - MOUSE SANITY: Spotlight XHair Turned FULLY ON, Mouse Cursors CrossHair is Active! ACTION: Disabling Crosshair cursors.. too presumptive?" & @LF)
			$g_nMouseCursorState = 0
			_MouseHideAllCursors()
			TrayItemSetState($g_aCursorStateSelect[1], 1)
			TrayItemSetState($g_aCursorStateSelect[0], 4)
			TrayItemSetState($g_aCursorStateSelect[2], 4)
		EndIf
		_SpotlightGUIUpdate()
	EndIf
EndFunc
Func _ToggleSpotlight_TEvt()
	If $g_bSpotlightOn Then
		GUIDelete($g_hSpotlightGUI)
		; Force re-initialization next time
		$g_hSpotlightGUI = 0
		; For the sake of sanity, adjust mouse cursors based on FULL/No X-Hair toggles
		; If SpotlightXHairState was on, but now the GUI is disabled, and if all Mouse Cursors are currently hidden, reenable at least the crosshair cursor
		If $g_nSpotlightXHairState And $g_nMouseCursorState = 0 Then
			ConsoleWrite("X-HAIR - MOUSE SANITY: Spotlight GUI being turned OFF, Mouse Cursors Hidden! ACTION: Enabling Crosshair cursors" & @LF)
			$g_nMouseCursorState = 1
			_MouseReplaceAllCursors(True)
			TrayItemSetState($g_aCursorStateSelect[0], 4)
			TrayItemSetState($g_aCursorStateSelect[1], 4)
			TrayItemSetState($g_aCursorStateSelect[2], 1)
		EndIf
	Else
		_SpotlightGUIUpdate()
	EndIf
	$g_bSpotlightOn = Not $g_bSpotlightOn
	; Update GUI Counts, and Rez-Chg handler if necessary
	_GUICountChange()
EndFunc
Func _ToggleFocus_TEvt()
	If $g_bFocusOn Then
		GUIDelete($g_hFocusGUI)
		; Force re-initialization next time
		$g_hFocusGUI = 0
		; Prevent sticky situations where transitions are confused with GUI re-init's
		$g_nTransitions = 0
	Else
		_FocusGUIUpdate()
	EndIf
	$g_bFocusOn = Not $g_bFocusOn
	; Update GUI Counts, and Rez-Chg handler if necessary
	_GUICountChange()
EndFunc
Func _Exit_TEvt()
	Exit
EndFunc
#EndRegion TRAY_EVENT_HANDLER_FUNCS
; ###############################################



; ###############################################
#Region INI_IN_EXE_FUNCS
; =================================================================================================================
; Func _INI_SaveDataToExeINI()
;
; Writes settings to NTFS ADS Stream INI file (NTFS file systems only)
; NOTE: Write access to folder is required (I think this type of write is the same as regular file access)
;
; Author: Ascend4nt, based nullschritt's 'Save INI data to exe' functions
; =================================================================================================================
Func _INI_SaveDataToExeINI()
	;If 1 Then
	If @Compiled Then
		Local $sNTFS_ADS_File = @ScriptFullPath&':'&"INI_DATA"
		;IniWrite($sNTFS_ADS_File, "Settings", "SpotlightStyle", $g_nSpotlightStyle)

		; Build array (Number casts for True->1 and False->0 conversions)
		Local $aINISettingsOut[6][2] = [ [5, 0], _
			["FocusOn", Number($g_bFocusOn)], ["SpotlightOn", Number($g_bSpotlightOn)], ["SpotlightStyle", Number($g_nSpotlightStyle)], _
			["MouseCursorsState", Number($g_nMouseCursorState)], ["SpotlightXHairState", Number($g_nSpotlightXHairState)] ]

		; Prevent unnecessary write by comparing IN settings vs OUT settings:
		Local $bSame = False

		; Both arrays, both equal element counts?
		If IsArray($g_aINISettings) And $g_aINISettings[0][0] = $aINISettingsOut[0][0] Then
			Local $iMatches = 0
			For $i = 1 To $aINISettingsOut[0][0]
				If $g_aINISettings[$i][0] = $aINISettingsOut[$i][0] And _
					$g_aINISettings[$i][1] = $aINISettingsOut[$i][1] Then $iMatches += 1
			Next
			If $iMatches = $aINISettingsOut[0][0] Then $bSame = True
		EndIf

		If Not $bSame Then
			;ConsoleWrite("Determined settings have changed! Writing INI data.." & @CRLF)
			IniWriteSection($sNTFS_ADS_File, "Settings", $aINISettingsOut)
		EndIf

	EndIf
EndFunc

; =================================================================================================================
; Func _INI_UpdateDataFromExeINI()
;
; Reads settings from NTFS ADS Stream INI file (NTFS file systems only)
;
; Author: Ascend4nt, based nullschritt's 'Save INI data to exe' functions
; =================================================================================================================
Func _INI_UpdateDataFromExeINI()
	;If 1 Then
	If @Compiled Then
		Local $sNTFS_ADS_File = @ScriptFullPath&':'&"INI_DATA"
		If FileExists($sNTFS_ADS_File) Then
			;$g_nSpotlightStyle = IniRead($sNTFS_ADS_File, "Settings", "SpotlightStyle", 1)
			$g_aINISettings = IniReadSection($sNTFS_ADS_File, "Settings")
			If @error Or $g_aINISettings[0][0] < 5 Then
				$g_aINISettings = 0
				Return
			Else
				;ConsoleWrite("FocusOn Key = " & $g_aINISettings[1][0] & ", value = " & $g_aINISettings[1][1] & @LF)
				$g_bFocusOn = Number($g_aINISettings[1][1])
				;ConsoleWrite("Spotlight Key = " & $g_aINISettings[2][0] & ", value = " & $g_aINISettings[2][1] & @LF)
				$g_bSpotlightOn = Number($g_aINISettings[2][1])
				$g_nSpotlightStyle = Abs(Number($g_aINISettings[3][1]))	; 0 = Circle, 1 = Rounded Rect, 2 = Wide Rect
				; Sanity Check
				If $g_nSpotlightStyle > 2 Then $g_nSpotlightStyle = 2

				$g_nMouseCursorState = Number($g_aINISettings[4][1])
				; Sanity Check
				If $g_nMouseCursorState < 0 Then
					$g_nMouseCursorState = -1
				ElseIf $g_nMouseCursorState > 0 Then
					$g_nMouseCursorState = 1
				EndIf
				$g_nSpotlightXHairState = Abs(Number($g_aINISettings[5][1]))
				; Sanity Check
				If $g_nSpotlightXHairState > 3 Then $g_nSpotlightXHairState = 0
			EndIf
		EndIf
	EndIf
EndFunc
#Region INI_IN_EXE_FUNCS
; ###############################################



; ###############################################
#Region SPOTLIGHT_FUNCTIONS

; =================================================================================================================
; Func _SpotlightGUIUpdate($bForceRecreate = False)
;
; Author: Ascend4nt
; =================================================================================================================
Func _SpotlightGUIUpdate($bForceRecreate = False)
	If Not $g_bSpotlightOn Then Return

	; Keep all data local
	Local Static $aLastMousePos = 0, $aMousePos = 0

	; Need this Global so we can delete the GUI outside of function
	;Local Static $hSpotlightGUI = 0

	If $g_aSpotLockDown[0] Then
		$aMousePos[0] = $g_aSpotLockDown[1]
		$aMousePos[1] = $g_aSpotLockDown[2]
	Else
		$aMousePos = MouseGetPos()
	EndIf

	; Initializing? Or Force-Recreate Flag set (possibly Resolution Change)?
	If $g_hSpotlightGUI = 0 Or $bForceRecreate Then
		ConsoleWrite("Recreating GUI, $g_hSpotlightGUI = " & $g_hSpotlightGUI & ", $bForceRecreate = " & $bForceRecreate & @LF)
		;$aMousePos = MouseGetPos()
		$aLastMousePos = $aMousePos
		; Extra precaution for corner cases where GUI's might activate after a Display Change while no WM_DISPLAYCHANGE handler was in effect
		_VirtualScreenSizeUpdate()
		_SpotlightGUIRecreate($aMousePos)

		; If we rebuilt the GUI, no need to check for changes in position
	Else

		; Movement?
		If $aMousePos[0] <> $aLastMousePos[0] Or $aMousePos[1] <> $aLastMousePos[1] Then
			;ConsoleWrite("<>")
			WinMove($g_hSpotlightGUI, "", $aMousePos[0] - $g_aVScrRect[2] + 1, $aMousePos[1] - $g_aVScrRect[3] + 1)
			; (Topmost check in main loop as there can be flashing with other GUI's fighting for topmost status)
			;WinSetOnTop($g_hSpotlightGUI, "", 1)
			$aLastMousePos = $aMousePos
#cs
;~ 		Else
			; Otherwise lets check the topmost status and adjust if necessary
			; (Logic moved to main loop as there can be flashing with other GUI's fighting for topmost status)
;~ 			Local $hWnd = _WinAPI_GetTopWindow(0)
;~ 			If $g_hSpotlightGUI <> $hWnd Then
;~ 				;ConsoleWrite("WinOnTop hWnd = " & $hWnd & ", Title = " & WinGetTitle($hWnd) & @LF)
;~ 				WinSetOnTop($g_hSpotlightGUI, "", 1)
;~ 			EndIf
#ce
		EndIf
	EndIf

EndFunc

; =================================================================================================================
;  Func _SpotlightGUIRecreate($aMousePos)
;
; Author: Ascend4nt
; =================================================================================================================

Func _SpotlightGUIRecreate($aMousePos)

	If $g_hSpotlightGUI Then GUIDelete($g_hSpotlightGUI)

	Local $iWidth, $iHeight
	; Spotlight Style 0 = Circle, 1 = Round-REct, 2 = Wide-Rect.  [Hmm.. Wide Circle?]
	If $g_nSpotlightStyle Then
		If $g_nSpotlightStyle = 1 Then
			$iWidth = $nSpotlightSqDiameter
			$iHeight = $nSpotlightSqDiameter
		Else
			$iWidth = $nSpotlightRectWidth
			$iHeight = $nSpotlightRectHeight
		EndIf
	Else
		$iWidth = $nSpotlightDiameter
		$iHeight = $iWidth
	EndIf
	; If even width/height, add 1 so that boxes align to mouse cursor
	; ( width of 2 would result in 1 pixel on mouse position, 1 off. otherwise an odd # would mean 2 outside, 1 on)
	$iWidth += BitXOR(BitAND($iWidth, 1), 1)
	$iHeight += BitXOR(BitAND($iHeight, 1), 1)

	$g_hSpotlightGUI = _GUIShapeCreateHolePunchGUI($aMousePos[0] - $g_aVScrRect[2] + 1, $aMousePos[1] - $g_aVScrRect[3] + 1, _
			$g_aVScrRect[2] * 2 +1, $iWidth, $g_aVScrRect[3] * 2 +1, $nShadeColor, $iHeight)

	WinSetTrans($g_hSpotlightGUI, "", $g_bFocusOn ? ($nSpotlightTransparency / 2) : $nSpotlightTransparency)

	;xx nvm Careful: We don't want to compete with a Focus-Window GUI
	;xx If Not $g_bFocusOn Then
	WinSetOnTop($g_hSpotlightGUI, "", 1)
	;GUISetState(@SW_SHOWNOACTIVATE, $g_hSpotlightGUI)
	WinSetState($g_hSpotlightGUI, "", @SW_SHOWNOACTIVATE)
	Return
EndFunc   ;==>_SpotlightGUIRecreate


; =================================================================================================================
; Func _GUIShapeCreateHolePunchGUI($iX, $iY, $iBoxSzX, $iHoleXDiameter, $iBoxSzY = Default, $iBkColor = Default,
;                                  $iHoleYDiameter = Default)
;
; Author: Ascend4nt
; =================================================================================================================

Func _GUIShapeCreateHolePunchGUI($iX, $iY, $iBoxSzX, $iHoleXDiameter, $iBoxSzY = Default, $iBkColor = Default, $iHoleYDiameter = Default)
	Local $hGUI, $hRectRgn = 0, $hEllipseHollowRgn = 0, $hXLineRgn = 0, $iErrFlag = 0
	If $iBoxSzY = Default Then $iBoxSzY = $iBoxSzX
	If $iHoleYDiameter = Default Then $iHoleYDiameter = $iHoleXDiameter

	If $iHoleXDiameter < 0 Or $iHoleXDiameter > $iBoxSzX Then $iHoleXDiameter = 0
	If $iHoleYDiameter < 0 Or $iHoleYDiameter > $iBoxSzY Then $iHoleYDiameter = 0

	; Styles: Basic: WS_POPUP (0x80000000), Extended: WS_EX_NOACTIVATE 0x08000000.
	;  $WS_EX_TOOLWINDOW (0x80) + $WS_EX_TRANSPARENT (click-through)
	$hGUI = GUICreate("", $iBoxSzX, $iBoxSzY, $iX, $iY, 0x80000000, 0x08000080 + 0x20)
	If @error Then Return SetError(1, @error, 0)

	Do
		If $iHoleXDiameter Or $iHoleYDiameter Then
			Local $iHoleXRadius = Int($iHoleXDiameter / 2), $iHoleYRadius = Int($iHoleYDiameter / 2)
			Local $iBoxHalfX = Int($iBoxSzX / 2), $iBoxHalfY = Int($iBoxSzY / 2)

			$iErrFlag = 10
			; Basic region (full extent of GUI) - needed for combining with Hollow region below
			$hRectRgn = _WinAPI_CreateRectRgn(0, 0, $iBoxSzX, $iBoxSzY)
			If $hRectRgn = 0 Then ExitLoop

		; Ellipse_Region Start
			; Spotlight Style of 0 = Circle
			If $g_nSpotlightStyle = 0 Then
				; Create the Hollow interior region
				$hEllipseHollowRgn = _WinAPI_CreateEllipticRgn( _
					_WinAPI_CreateRect($iBoxHalfX - $iHoleXRadius, $iBoxHalfY - $iHoleYRadius, $iBoxHalfX + $iHoleXRadius, $iBoxHalfY + $iHoleYRadius))

			; Spotlight Style non-zero is RoundRect. Could do more.. perhaps a Complex Region is best in the end
			Else
				; MSDN: "Regions created by the Create<shape>Rgn methods (such as CreateRectRgn and CreatePolygonRgn)
				;        only include the interior of the shape; the shape's outline is excluded from the region"
				; In practice: The uppermost and leftmost lines are not included, so 1 must be subtracted from both params to include the full rectangle
				$hEllipseHollowRgn = _WinAPI_CreateRoundRectRgn($iBoxHalfX - $iHoleXRadius - 1, $iBoxHalfY - $iHoleYRadius - 1, _
					$iBoxHalfX + $iHoleXRadius, $iBoxHalfY + $iHoleYRadius, $nRoundRectCornerWidth, $nRoundRectCornerWidth)
			EndIf

			$iErrFlag += 1
			If $hEllipseHollowRgn = 0 Then ExitLoop
		; Ellipse_Region END

		; CrossHairs_Region Start
		If $g_nSpotlightXHairState Then
			Local $iArrSt = 0, $iArrEnd = 3
			Local $iXHairHollowRadius = Int($nSpotlightXHairDiameter / 2)
            Local $aXHairSides[4][4] = [ _                                                                             ; Upper side of X-Hair  (  |  )
                [$iBoxHalfX - 1, $iBoxHalfY - $iHoleYRadius, $iBoxHalfX + 1, $iBoxHalfY - $iXHairHollowRadius], _      ;                       (  o  )
                [$iBoxHalfX - 1, $iBoxHalfY + $iXHairHollowRadius, $iBoxHalfX + 1, $iBoxHalfY + $iHoleYRadius - 1], _  ; Bottom side of X-Hair (  |  )
                [$iBoxHalfX - $iHoleXRadius, $iBoxHalfY - 1 + $nSpotlightXHairYOffset, _
                 $iBoxHalfX - $iXHairHollowRadius, $iBoxHalfY + 1 + $nSpotlightXHairYOffset], _      ; Left side of X-Hair   (--o  )
                [$iBoxHalfX + $iXHairHollowRadius, $iBoxHalfY - 1 + $nSpotlightXHairYOffset, _
                 $iBoxHalfX + $iHoleXRadius - 1, $iBoxHalfY + 1 + $nSpotlightXHairYOffset] ]         ; Right side of X-Hair  (  o--)

			; One-dimensional XHairs.. (1 = FULL, 2 = Horizontal, 3 = Vertical)
			If $g_nSpotlightXHairState = 2 Then
				$iArrSt = 2	  ; $iArrEnd = 3
			ElseIf $g_nSpotlightXHairState = 3 Then
				$iArrEnd = 1 ; $iArrSt = 0
			EndIf

			For $i = $iArrSt To $iArrEnd
				; MSDN: "Regions created by the Create<shape>Rgn methods (such as CreateRectRgn and CreatePolygonRgn)
				;        only include the interior of the shape; the shape's outline is excluded from the region"
				; In practice: The uppermost and leftmost lines are not included, so 1 must be subtracted from both params to include the full rectangle
				$hXLineRgn = _WinAPI_CreateRectRgn($aXHairSides[$i][0] - 1, $aXHairSides[$i][1] - 1, $aXHairSides[$i][2], $aXHairSides[$i][3])
				$iErrFlag += 1
				If $hXLineRgn = 0 Then ExitLoop
				;ConsoleWrite("XHair Region #"&$i&" X1: " & $aXHairSides[$i][0] & ", Y1: " & $aXHairSides[$i][1] & ", X2: " & $aXHairSides[$i][2] & ", Y2: " & $aXHairSides[$i][3] & @LF)

				$iErrFlag += 1
				; With the Ellipse Region, we can use either RGN_XOR or RGN_DIFF as we are 'removing' parts of the circle
				;  (RGN_AND = 1, RGN_OR = 2, RGN_XOR = 3, RGN_DIFF = 4, RGN_COPY = 5)
				If Not _WinAPI_CombineRgn($hEllipseHollowRgn, $hEllipseHollowRgn, $hXLineRgn, 4) Then ExitLoop 2	; Exit out of For..Next AND Do..Until loop
				; CombineRgn() Returns: 0 = ERROR, 1 = NULLREGION, 2 = SIMPLEREGION, 3 = COMPLEXREGION

				; Don't need this Region after combined with the $hEllipseHollowRgn
				_WinAPI_DeleteObject($hXLineRgn)
				$hXLineRgn = 0	; Primarily debug, as DeleteObject prior to function return (on error) will ignore both
			Next
		EndIf
		; CrossHairs_Region END

			$iErrFlag = 20
			; Combine, put resulting region in $hRectRgn. RGN_DIFF = 4
			If Not _WinAPI_CombineRgn($hRectRgn, $hRectRgn, $hEllipseHollowRgn, 4) Then ExitLoop

			; Don't need this anymore (already combined with the Region injected into the GUI)
			_WinAPI_DeleteObject($hEllipseHollowRgn)
			$hEllipseHollowRgn = 0	; Primarily debug, as DeleteObject prior to function return (on error) will ignore both

			$iErrFlag += 1
			; Set the region into the GUI. (GUI will then own it so there's no need to delete it)
			If Not _WinAPI_SetWindowRgn($hGUI, $hRectRgn, True) Then ExitLoop
		EndIf

		If $iBkColor <> Default Then GUISetBkColor($iBkColor)
		Return $hGUI

		; If we wer to drop through, we'd need a clear ErrFlag count:
		;$iErrFlag = 0
	Until 1

	; Cleanup
	GUIDelete($hGUI)
	_WinAPI_DeleteObject($hRectRgn)
	_WinAPI_DeleteObject($hXLineRgn)
	_WinAPI_DeleteObject($hEllipseHollowRgn)

	Return SetError($iErrFlag, 0, 0)
EndFunc   ;==>_GUIShapeCreateHolePunchGUI

#EndRegion SPOTLIGHT_FUNCTIONS
; ###############################################





; ###############################################
#Region FOCUS_GUI_FUNCTIONS
; =================================================================================================================
; Func _FocusGUIUpdate($iRezChgForce = 0)
;
; Author: Ascend4nt
; =================================================================================================================

Func _FocusGUIUpdate($iRezChgForce = 0)
	If Not $g_bFocusOn Then Return

	Local Const $TRANSITION_MAX = 100

	; Keep as much data local as possible (turning out to be tricky now!)
	Local Static $aLastWinPos = 0
	; Need this Global so that Lockdown can be used
	; Local Static $hLastActiveWin = 0
	; Need this Global so it can be reset when GUI is deleted:
	;Local Static $nTransitions = 0
	; Need this Global so we can delete it outside of this function
	;Local Static $hFocusGUI = 0
	Local $aActiveWinPos = 0, $hActiveWin = 0

	Local $hTempGUIHandle = 0
; Max-Transitions Exceeded?  We don't want to continually eat up Windows RAM with Window Regions,
;  so now and then we must purge the GUI and create a new one. This creates a temporary darkening effect now and then.
; (There's no known workaround for the Region bug - previous ones should be freed with each 'SetWindowRgn', but they aren't)
	If $g_nTransitions > $TRANSITION_MAX Then
		$g_nTransitions = $TRANSITION_MAX	; safety measure (issue with recreation & $nTransitions colliding)
		$hTempGUIHandle = $g_hFocusGUI
		$g_hFocusGUI = 0
	EndIf

	; Initializing?
	If $g_hFocusGUI = 0 Then
		; Extra precaution for corner cases where GUI's might activate after a Display Change while no WM_DISPLAYCHANGE handler was in effect
		_VirtualScreenSizeUpdate()
		; ----------------------------------------------------------------------------------------------------|
		; Focus Window: Set off-screen 1st so when it finally is moved on-screen, it gives a nicer effect,
		;  as if lights are being shut off 1 by 1.
		; ----------------------------------------------------------------------------------------------------|
		$g_hFocusGUI = GUICreate("", $g_aVScrRect[2], $g_aVScrRect[3], $g_aVScrRect[0] + $g_aVScrRect[2]-1, $g_aVScrRect[1] + $g_aVScrRect[3]-1, 0x80000000,0x08000080 + 0x20)
		WinSetTrans($g_hFocusGUI, "", $g_bSpotlightOn ? ($nFocusTransparency / 2): $nFocusTransparency)
		WinSetOnTop($g_hFocusGUI, "", 1)
		GUISetBkColor(0)

		$g_hLastActiveWin = WinGetHandle("[ACTIVE]")
		$hActiveWin = $g_hLastActiveWin
		$aActiveWinPos = WinGetPos($hActiveWin)
		$aLastWinPos = $aActiveWinPos

		; Move focus-window's 'hole' to/with active window
		_GuiHole($g_hFocusGUI, $aActiveWinPos[0] - $g_aVScrRect[0], $aActiveWinPos[1] - $g_aVScrRect[1], $aActiveWinPos[2], $aActiveWinPos[3])
		; Now move and show it (this move AFTER the gui 'hole' has been set causes less disruption)
		WinMove($g_hFocusGUI, "", $g_aVScrRect[0], $g_aVScrRect[1])
		WinSetState($g_hFocusGUI, "", @SW_SHOWNOACTIVATE)

		If $g_nTransitions = $TRANSITION_MAX Then
			ConsoleWrite("Transition count exceeded, recreating GUI.." & @LF)
			GUIDelete($hTempGUIHandle)
		EndIf
		; Reset in both cases
		$g_nTransitions = 0
		; Don't fall-through
		Return
	EndIf

	; Adjust if screen resized
	;If $g_iResolutionChangeMsg Or $iRezChgForce Then
	If $iRezChgForce Then
		ConsoleWrite("Resolution changed, resizing window"&@LF)
		WinMove($g_hFocusGUI, "", $g_aVScrRect[0], $g_aVScrRect[1], $g_aVScrRect[2], $g_aVScrRect[3])
		;WinMove($g_hFocusGUI, "", Default, Default, $g_aVScrRect[0] + $g_aVScrRect[2], $g_aVScrRect[1] + $g_aVScrRect[3])
		; Force _GuiHole call (down below)
		$g_hLastActiveWin = -1
		;$g_iResolutionChangeMsg = 0	; old behavior
	EndIf

	; Active Window changing? (Lockdown skips this test, unless the Window no longer exists)
	If $g_hFocusLockDown <= 0 Or Not WinExists($g_hFocusLockDown) Then
		$hActiveWin = WinGetHandle("[ACTIVE]")
	Else
		$hActiveWin = $g_hFocusLockDown
	EndIf
	$aActiveWinPos = WinGetPos($hActiveWin)

	; Workaround for certain scenarios where position isn't able to be retrieved
	If @error Then
		$aActiveWinPos = $aLastWinPos
		$hActiveWin = $g_hLastActiveWin
		; Different active window, or different size/position?
	ElseIf ($hActiveWin <> $g_hLastActiveWin) Or ($aActiveWinPos[0] <> $aLastWinPos[0] Or $aActiveWinPos[1] <> $aLastWinPos[1] Or _
		$aActiveWinPos[2] <> $aLastWinPos[2] Or $aActiveWinPos[3] <> $aLastWinPos[3]) Then
		;ConsoleWrite("New active window or position: Win:"&WinGetTitle($hActiveWin)&@CRLF)
		$g_nTransitions += 1
		;_GuiHole($g_hFocusGUI, $aActiveWinPos[0], $aActiveWinPos[1], $aActiveWinPos[2], $aActiveWinPos[3])
		_GuiHole($g_hFocusGUI, $aActiveWinPos[0] - $g_aVScrRect[0], $aActiveWinPos[1] - $g_aVScrRect[1], $aActiveWinPos[2], $aActiveWinPos[3])
		; Reset as Topmost GUI (Logic taken to main loop; otherwise causes flashing when competing for topmost GUI)
		;WinSetOnTop($g_hFocusGUI, "", 1)
		$g_hLastActiveWin = $hActiveWin
		$aLastWinPos = $aActiveWinPos
	EndIf

EndFunc

; ===============================================================================================================================
; Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh)
;
; Places an empty 'see-through' region inside a GUI, hence 'gui hole'
;
; Author: KaFu, Ascend4nt (error handling, cleanup, API call fixes)
; ===============================================================================================================================

Func _GuiHole($h_win, $i_x, $i_y, $i_sizew, $i_sizeh)
    Local $pos, $set_rgn, $inner_rgn
    $pos = WinGetPos($h_win)
	If @error Then Return SetError(1,@error,0)
    $set_rgn = DllCall($g_hGDI32DLL, "handle", "CreateRectRgn", "long", 0, "long", 0, "long", $pos[2], "long", $pos[3])
	If @error Then Return SetError(2,@error,0)
    $inner_rgn = DllCall($g_hGDI32DLL, "handle", "CreateRectRgn", "long", $i_x, "long", $i_y, "long", $i_x + $i_sizew, "long", $i_y + $i_sizeh)
	If @error Then
		DllCall($g_hGDI32DLL, "bool", "DeleteObject", "handle", $set_rgn[0])
		Return SetError(2, @error, 0)
	EndIf
	; Unnecessary:
;~ 	$combined_rgn = DllCall($g_hGDI32DLL, "handle", "CreateRectRgn", "long", 0, "long", 0, "long", 0, "long", 0)

	; $RGN_DIFF = 4
	DllCall($g_hGDI32DLL, "long", "CombineRgn", "handle", $set_rgn[0], "handle", $set_rgn[0], "handle", $inner_rgn[0], "int", 4)

	; Inner Region no longer required once combined with another region
	DllCall($g_hGDI32DLL, "bool", "DeleteObject", "handle", $inner_rgn[0])

	; After Set, a Region should not be deleted (so we don't touch $set_rgn after)
	DllCall($g_hUSER32DLL, "long", "SetWindowRgn", "hwnd", $h_win, "handle", $set_rgn[0], "bool", 1)

	Return 1
EndFunc   ;==>_GuiHole

#EndRegion FOCUS_GUI_FUNCTIONS
; ###############################################




; ###############################################
#Region MOUSE_FUNCTIONS_PARTIAL_UDF

; ====================================================================================================
; Func _MouseReplaceAllCursors($bDontReplaceResizeCursors = False)
;
; Replaces all cursors with a crosshair cursor (or X style cursor).
;
;
; AND mask	XOR mask	Display
; --------|-----------|---------
;	0		0			Black
;	0		1			White
;	1		0			Screen
;	1		1			Reverse screen
; --------|-----------|---------
;
; Author: Ascend4nt
; ====================================================================================================

Func _MouseReplaceAllCursors($bDontReplaceResizeCursors = False, $bUseXHairCross = True)
	If $MCF_bCursorsReplaced = 1 Then Return True
	; Had a different type of Cursor Replacement? Restore first!
	If $MCF_bCursorsReplaced Then _MouseRestoreAllCursors()

	Local $i, $iErrCount = 0, $hCrossHair, $hTempCopy, $stCursor, $aRet
	Local $iCursorsToReplace = UBound($MCF_aSysCursors) - 1

	If $bDontReplaceResizeCursors Then
		$iCursorsToReplace -= 5
	EndIf

	; Lets make a 32x32 cursor [1bpp] (32/8=4*32=128)
	$stCursor = DllStructCreate("ubyte[128];ubyte[128]")

	; 32x32 cursor - each bit corresponds to a pixel (4 pixels per hex #)
	DllStructSetData($stCursor, 1, "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")

	If $bUseXHairCross Then
		; each bit corresponds to a pixel (4 pixels per hex #) (the rest we'll leave zeroed)
		DllStructSetData($stCursor, 2, "0x" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"FEFE0000" & _	; Line 8 = horizonal line; center bit cleared (same bit set for other rows)
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"01000000" & _
			"00000000")
		; Center pixel (7,7 for 15x15 [or 16x16 officially])
		$hCrossHair = DllCall($g_hUSER32DLL, "handle", "CreateCursor", "handle", 0, "int", 7, "int", 7, "int", 32, "int", 32, _
				"ptr", DllStructGetPtr($stCursor, 1), "ptr", DllStructGetPtr($stCursor, 2))

	Else ; $bXHairDiagonal
		DllStructSetData($stCursor, 2, "0x" & _
			"00000000" & _ ; "01000400" & ..	; to make 15x15
			"00000000" & _ ; "00800800" & ..	; to make 13x13
			"00401000" & _	; 11x11
			"00202000" & _
			"00104000" & _
			"00088000" & _
			"00050000" & _
			"00000000" & _	; Line 8 = center point; center bit cleared
			"00050000" & _
			"00088000" & _
			"00104000" & _
			"00202000" & _
			"00401000" & _
			"00000000" & _ ; "00800800" & ..
			"00000000" & _ ; "01000400" & ..
			"00000000")
		$hCrossHair = DllCall($g_hUSER32DLL, "handle", "CreateCursor", "handle", 0, "int", 14, "int", 7, "int", 32, "int", 32, _
				"ptr", DllStructGetPtr($stCursor, 1), "ptr", DllStructGetPtr($stCursor, 2))
	EndIf

	If @error Then Return SetError(2, @error, False)
	If Not $hCrossHair[0] Then Return SetError(3, 0, 0)
	$hCrossHair = $hCrossHair[0]
;~ 	ConsoleWrite("cursor:"&$hCrossHair&@CRLF)

	; Make copy, one for each cursor to be replaced [don't ask me why I can't reuse one - it just doesn't work]
	; (REQUIRED for SetSystemCursor calls)	; (*CopyCursor is a macro for CopyIcon)
	For $i = 0 To $iCursorsToReplace
		$hTempCopy = DllCall($g_hUSER32DLL, "handle", "CopyIcon", "handle", $hCrossHair)

		If @error Or Not $hTempCopy[0] Then
			$iErrCount += 1
			ContinueLoop
		EndIf

		$MCF_aSysCursors[$i][1] = $hTempCopy[0]
		; Replace with copy of crosshair
		$aRet = DllCall($g_hUSER32DLL, "bool", "SetSystemCursor", "handle", $hTempCopy[0], "dword", $MCF_aSysCursors[$i][0])
		If @error Or Not $aRet[0] Then
			$iErrCount += 1
;~ 			ConsoleWrite("@error="&@error&" for SetSystemCursor"&@CRLF)
		EndIf
;~ 		ConsoleWrite("Return for #"&$i&":"&$aRet[0]&", ID:"&$MCF_aSysCursors[$i][0]&" Handle:"&$MCF_aSysCursors[$i][1]&" Msg:"&_WinAPI_GetLastErrorMessage())
	Next
	; Destroy cursor created (and copied)
	DllCall($g_hUSER32DLL, "bool", "DestroyCursor", "handle", $hCrossHair)

	If $iErrCount = 16 Then Return SetError(4, -1, False)
;~ 	ConsoleWrite("Total Errors:"&$iErrCount&" for _MouseReplaceAllCursors"&@CRLF)
	$MCF_bCursorsReplaced = 1
EndFunc   ;==>_MouseReplaceAllCursors


; ====================================================================================================
; Func _MouseHideAllCursors($bDontReplaceResizeCursors = False)
;
; Hides all cursors.
;
; Author: Ascend4nt
; ====================================================================================================

Func _MouseHideAllCursors($bDontReplaceResizeCursors = False)
	If $MCF_bCursorsReplaced = -1 Then Return True
	; Had a different type of Cursor Replacement? Restore first!
	If $MCF_bCursorsReplaced Then _MouseRestoreAllCursors()
	Local $i, $iErrCount = 0, $hTempCopy, $aRet, $stCursor, $hCursor

	Local $iCursorsToReplace = UBound($MCF_aSysCursors) - 1

	If $bDontReplaceResizeCursors Then
		$iCursorsToReplace -= 5
	EndIf

	$stCursor = DllStructCreate("ubyte[128];ubyte[128]")

	; Create an invisible cursor ->  32x32  (8x8 works but gives artifacts when manipulating items with mouse)
	DllStructSetData($stCursor, 1, "0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF")
	DllStructSetData($stCursor, 2, 0)

	$hCursor = DllCall($g_hUSER32DLL, "handle", "CreateCursor", "handle", 0, "int", 0, "int", 0, "int", 32, "int", 32, "ptr", DllStructGetPtr($stCursor, 1), "ptr", DllStructGetPtr($stCursor, 2))
	If @error Then Return SetError(2, @error, False)
	;ConsoleWrite("hCursor result:" & $hCursor[0] & @CRLF)
	If Not $hCursor[0] Then Return SetError(3, 0, 0)
	;ConsoleWrite("hCursor result:" & $hCursor[0] & @CRLF)
	$hCursor = $hCursor[0]
;~ 	ConsoleWrite("cursor:"&$hCursor&@CRLF)

	; Make copy, one for each icon to be replaced [don't ask me why I can't reuse one - it just doesn't work]
	; (REQUIRED for SetSystemCursor calls)  (*CopyCursor is a macro for CopyIcon)
	For $i = 0 To $iCursorsToReplace
		$hTempCopy = DllCall($g_hUSER32DLL, "handle", "CopyIcon", "handle", $hCursor)

		If @error Or Not $hTempCopy[0] Then
			$iErrCount += 1
			ContinueLoop
		EndIf

		$MCF_aSysCursors[$i][1] = $hTempCopy[0]
		; Replace with copy of 'invisible cursor'
		$aRet = DllCall($g_hUSER32DLL, "bool", "SetSystemCursor", "handle", $hTempCopy[0], "dword", $MCF_aSysCursors[$i][0])
		If @error Or Not $aRet[0] Then $iErrCount += 1
;~ 		If Not @error Then ConsoleWrite("Return for #"&$i&":"&$aRet[0]&", ID:"&$MCF_aSysCursors[$i][0]&" Handle:"&$MCF_aSysCursors[$i][1]&" Msg:"&_WinAPI_GetLastErrorMessage())
	Next
	; Destroy cursor created (and copied)
	DllCall($g_hUSER32DLL, "bool", "DestroyCursor", "handle", $hCursor)

	If $iErrCount = 16 Then Return SetError(2, -1, False)
;~ 	ConsoleWrite("Total Errors:"&$iErrCount&" for _MouseHideAllCursors"&@CRLF)
	$MCF_bCursorsReplaced = -1
EndFunc   ;==>_MouseHideAllCursors

; ====================================================================================================
; Func _MouseRestoreAllCursors()
;
; Restores all the current default system cursors.
;
; Author: Ascend4nt
; ====================================================================================================

Func _MouseRestoreAllCursors()
	If Not $MCF_bCursorsReplaced Then Return True
	Local $i, $iErrCount = 0, $aRet
	;	SPI_SETCURSORS  0x0057		; Restores system default cursors
	$aRet = DllCall($g_hUSER32DLL, "bool", "SystemParametersInfoW", "dword", 0x57, "dword", 0, "ptr", 0, "dword", 0)
	For $i = 0 To UBound($MCF_aSysCursors) - 1
		; Destroy copy
		$aRet = DllCall($g_hUSER32DLL, "bool", "DestroyCursor", "handle", $MCF_aSysCursors[$i][1])
		If @error Or Not $aRet[0] Then
			$iErrCount += 1
			ContinueLoop
		EndIf
		$MCF_aSysCursors[$i][1] = 0
	Next
	If $iErrCount = 16 Then Return SetError(4, -1, False)
;~ 	ConsoleWrite("Total Errors:"&$iErrCount&" for _MouseRestoreAllCursors"&@CRLF)
	$MCF_bCursorsReplaced = 0
EndFunc   ;==>_MouseRestoreAllCursors

#EndRegion MOUSE_FUNCTIONS_PARTIAL_UDF
; ###############################################
