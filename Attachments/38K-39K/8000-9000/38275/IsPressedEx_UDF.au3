#include-once
#include <Misc.au3>
;

#CS --------------------------------------------------------------------------------------------------------
	Title:			IsPressedEx UDF
	Filename:		IsPressedEx_UDF.au3
	Description:	Extended _IsPressedEx function based on original _IsPressed() function.
	Author:			MrCreatoR, initial idea/concept by FireFox
	Version:		1.0 (mod).
	Last Update:	29.01.09
	Requirements:	AutoIt v3.2.10.0 +, Developed/Tested on WindowsXP Familly Service Pack 2, 3
	Notes:          _IsPressedEx function works without the need to specify User32.dll, the same as original _IsPressed function.
	;					So... "If calling this function repeatidly, should open 'user32.dll' and pass in handle.
	;					       Make sure to close at end of script".
#CE ---------------------------------------------------------------------------------------------------------


; #FUNCTION# ===================================================================
; Name:           	_IsPressedEx
; Description:      Extended _IsPressed function to check if key has been pressed.
;
; Parameter(s):     $nHexStrKey - Hex or String key to check.
;                       [*] This parameter supports a strings as used in HotKeySet() function.
;                       [*] To make an "OR" checking operation, use "|" delimiter between the keys/classes.
;                       [*] To make an "AND" checking operation, use "+" delimiter between the keys/classes.
;                       [*] And also have it's own CLASS list support:
;                                                  [:ALLKEYS:]     - All possible keys (any key) - @Extended = 1
;                                                  [:ALPHA:]       - Standard Alpha keys - @Extended = 2
;                                                  [:ALLNUM:]      - Standard Numeric keys or Numpad keys - @Extended = 3-4
;                                                  [:NUMPAD:]      - Numpad keys - @Extended = 5
;                                                  [:NUMERIC:]     - Standard Numeric keys - @Extended = 6
;                                                  [:ALLFUNC:]     - F1 -> F24 - @Extended = 7
;                                                  [:FUNC:]        - F1 -> F12 - @Extended = 8
;                                                  [:FUNCSPEC:]    - F13 -> F24 - @Extended = 9
;                                                  [:ARROW:]       - Up, Down, Left, Right - @Extended = 10
;                                                  [:ALLMOUSE:]    - All mouse buttons+Wheel scroll+Mouse Move - @Extended = 11-14
;                                                  [:MOUSEMOVE:]   - Mouse move - @Extended = 15
;                                                  [:WHEELDOWN:]   - Wheel button held down (pressed) - @Extended = 16
;                                                  [:WHEELSCROLL:] - Wheel scroll - @Extended = 17
;                                                  [:SPECIAL:]     - BACKSPACE, TAB, ENTER etc. - @Extended = 18-22
;
;                   $vDLL       - [Optional] Handle to dll or Default/-1 to user32.dll.
;
;                   $iWait      - [Optional] Wait untill the pressed key is released,
;                                  in this case the return will include time the key has been held down (pressed).
;                                   (default is 0, no wait).
;                        	      [NOTE]: $iWait will fail on "+" operation and few mouse events (Wheel scroll and Mouse movement).
;
;                   $iTFormat   - [Optional] Time format to use when $iWait parameter is <> 0:
;                                                                    -1 - Return floating number of milliseconds (default).
;                                                                    1  - Return string with time format.
;
; Requirement(s):   AutoIt v3.2.10.0 +.
;
; Return Value(s):  On Success  - Depending on $iWait/$nHexStrKey parameters,
;                                  if it's 0, then return 1, otherwise check the parameter description.
;                                  @extended is set in accordance with passed class or string/hex keys:
;                                                @extended < 0 indicating on "+" operation,
;                                                 -N => Here 'N' is the occurence number where the "AND" keys was found
;                                                  (in the "OR" list, i.e: "{F1}|CTRL+P", here @extended = -2 if CTRL+P is pressed).
;                                                @extended = 1 to 21, means the classes is used
;                                                 (the extended code will include the value of checked class
;                                                  in the same order as it's appearing in the $nHexStrKey parameter's description).
;                                                @extended = 30 means that the key is non CLASS key, but one of the string/hex keys.
;
;                   On Failure  - Returns 0.
;
; Author(s):        MrCreatoR
;                   [Based on _IsPressed UDFs library by Firefox: http://www.autoitscript.com/forum/index.php?showtopic=86296].
;
; Note(s):          See examples to get idea of properly usage.
;===============================================================================
Func _IsPressedEx($nHexStrKey, $vDLL = -1, $iWait = 0, $iTFormat = -1)
	If $vDLL = -1 Or (IsKeyword($vDLL) And $vDLL = Default) Then $vDLL = 'User32.dll'
	
	Local $iKeysPressed, $iRet = -1
	Local $aSplit_Keys = StringSplit($nHexStrKey, "|")
	
	For $i = 1 To $aSplit_Keys[0] ;"OR" pressed check proc
		If $aSplit_Keys[$i] = "" Then ContinueLoop
		
		If StringInStr($aSplit_Keys[$i], "+") Then ;"AND" Pressed check proc
			$iRet = -1
			
			Local $aSplit_And_Keys = StringSplit($aSplit_Keys[$i], "+")
			
			For $j = 1 To $aSplit_And_Keys[0]
				If Not _IsPressedEx($aSplit_And_Keys[$j], $vDLL) Then
					$iRet = 0
					ExitLoop
				EndIf
			Next
			
			If $iRet = -1 Then $iRet = 1
			If $iRet = 1 Or $aSplit_Keys[0] = 1 Then Return SetExtended(BitNOT($i-1), $iRet)
			
			ContinueLoop
		EndIf
		
		Select
			Case $aSplit_Keys[$i] = "[:ALLKEYS:]"			;All possible keys (any key)
				$iKeysPressed = __KeysPressedCheck_Proc(1, 221, -1, $iWait, $iTFormat, $vDLL)
				
				If $iKeysPressed <> -1 Then Return SetExtended(1, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:ALPHA:]"				;Standard Alpha keys
				$iKeysPressed = __KeysPressedCheck_Proc(58, 90, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(2, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:ALLNUM:]" 			;Standard Numeric keys or Numpad keys
				$iKeysPressed = __KeysPressedCheck_Proc(48, 57, -1, $iWait, $iTFormat, $vDLL) ;Standard Numeric
				If $iKeysPressed <> -1 Then Return SetExtended(3, $iKeysPressed)
				
				$iKeysPressed = __KeysPressedCheck_Proc(96, 105, -1, $iWait, $iTFormat, $vDLL) ;Numpad keys
				If $iKeysPressed <> -1 Then Return SetExtended(4, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:NUMPAD:]"			;Numpad keys
				$iKeysPressed = __KeysPressedCheck_Proc(96, 105, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(5, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:NUMERIC:]"			;Standard numeric keys
				$iKeysPressed = __KeysPressedCheck_Proc(48, 57, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(6, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:ALLFUNC:]" 			;F1 - F24
				$iKeysPressed = __KeysPressedCheck_Proc(112, 135, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(7, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:FUNC:]" 				;F1 - F12
				$iKeysPressed = __KeysPressedCheck_Proc(112, 123, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(8, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:FUNCSPEC:]" 			;F13 - F24
				$iKeysPressed = __KeysPressedCheck_Proc(124, 135, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(9, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:ARROW:]" 			;Up, Down, Left, Right
				$iKeysPressed = __KeysPressedCheck_Proc(37, 40, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(10, $iKeysPressed)
			Case $aSplit_Keys[$i] = "[:ALLMOUSE:]" 			;All mouse buttons + Wheel scroll + Mouse Move
				$iKeysPressed = __KeysPressedCheck_Proc(1, 6, -1, $iWait, $iTFormat, $vDLL) ;All standard mouse buttons
				If $iKeysPressed <> -1 Then Return SetExtended(11, $iKeysPressed)
				
				If __IsMouseEvent(1) Then Return SetExtended(12, 1) ;Mouse Move
				If __IsMouseEvent(2) Then Return SetExtended(13, 1) ;Wheel button pressed
				If __IsMouseEvent(3) Then Return SetExtended(14, 1) ;Wheel scroll
			Case $aSplit_Keys[$i] = "[:MOUSEMOVE:]"			;Mouse move
				If __IsMouseEvent(1) Then Return SetExtended(15, 1)
			Case $aSplit_Keys[$i] = "[:WHEELDOWN:]"			;Wheel button held down (pressed)
				If __IsMouseEvent(2) Then Return SetExtended(16, 1)
			Case $aSplit_Keys[$i] = "[:WHEELSCROLL:]"		;Wheel scroll
				If __IsMouseEvent(3) Then Return SetExtended(17, 1)
			Case $aSplit_Keys[$i] = "[:SPECIAL:]"			;BACKSPACE, TAB, ENTER etc.
				$iKeysPressed = __KeysPressedCheck_Proc(8, 36, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(18, $iKeysPressed)
				
				$iKeysPressed = __KeysPressedCheck_Proc(41, 46, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(19, $iKeysPressed)
				
				$iKeysPressed = __KeysPressedCheck_Proc(91, 92, -1, $iWait, $iTFormat, $vDLL) ;LWin & RWin keys
				If $iKeysPressed <> -1 Then Return SetExtended(20, $iKeysPressed)
				
				;Multiply, Add, Separater, Substract, Decimal, Divide keys
				$iKeysPressed = __KeysPressedCheck_Proc(106, 111, -1, $iWait, $iTFormat, $vDLL) 
				If $iKeysPressed <> -1 Then Return SetExtended(21, $iKeysPressed)
				
				$iKeysPressed = __KeysPressedCheck_Proc(136, 221, -1, $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(22, $iKeysPressed)
			Case $iRet <> 1									;Other (seperate/group) keys
				$iKeysPressed = __KeysPressedCheck_Proc(1, 1, $aSplit_Keys[$i], $iWait, $iTFormat, $vDLL)
				If $iKeysPressed <> -1 Then Return SetExtended(30, $iKeysPressed)
		EndSelect
	Next
	
	If $iRet = -1 Then $iRet = 0
	Return $iRet
EndFunc

#Region HELPER FUNCTIONS
; #HELPER FUNCTION# ===================================================================
; Name:			    _IsPressed_GetTime
; Description:      Returns pressed time of specified key (the time the key has been held down)
; Parameter(s):     $sHexKey    - Hexadecimal/string key.
;
;					$iFormat    - format of the return time.
;															-1 - Return milliseconds (default).
;														 	 1 - Return full time format.
;
;                   $vDLL       - Handle to dll or default to user32.dll.
;
; Requirement(s):	Misc.au3 (for original _IsPressed function)
; Return Value(s):  On Success - Returns the time the key has been held down (pressed)
;                   On Failure - Returns 0
; Author(s):        FireFox, Mod. by MrCreatoR
; Note(s):			All other keys than other functions
;===============================================================================
Func __IsPressed_GetTime($sHexKey, $iFormat = -1, $vDLL = 'User32.dll')
	If _IsPressed($sHexKey, $vDLL) Then
		Local $iTimerInit = TimerInit()
		
		While _IsPressed($sHexKey, $vDLL)
			Sleep(10)
		WEnd
		
		Local $iDiffKey = TimerDiff($iTimerInit)
		
		If $iFormat <= 0 Or (IsKeyword($iFormat) And $iFormat = Default) Then Return $iDiffKey
		If $iFormat >= 1 Then Return __SecondsToTime(Round($iDiffKey / 1000))
	EndIf
	
	Return 0
EndFunc   ;==>_IsPressed_GetTime

; #HELPER FUNCTION# ===================================================================
; Name:           	__IsMouseEvent
; Description:      Returns wheel mouse button scrolled up or down.
;
; Parameter(s):     $iEvent - The event to check, theese are currently supported events:
;                                                                   1 - Mouse Move event.
;                                                                   2 - Mouse Wheel button held down (pressed).
;                                                                   3 - Mouse Wheel button scrolled.
;
; Requirement(s):   __MouseEvent_Callback.
;
; Return Value(s):  On Success - Returns 1.
;                   On Failure - Returns 0. @Error will be set to 1 if the event is not supported.
;
; Author(s):        MrCreatoR
; Note(s):          This function includes a sleep of 100 ms, and uses callbacks.
;===============================================================================
Func __IsMouseEvent($iEvent)
	Local Const $WH_MOUSE_LL 					= 14
	
	Local Const $MOUSE_MOVE_EVENT				= 512
	Local Const $MOUSE_PRIMARYDOWN_EVENT		= 513
	Local Const $MOUSE_PRIMARYUP_EVENT			= 514
	Local Const $MOUSE_SECONDARYDOWN_EVENT		= 516
	Local Const $MOUSE_SECONDARYUP_EVENT		= 517
	Local Const $MOUSE_WHEELDOWN_EVENT			= 519
	Local Const $MOUSE_WHEELUP_EVENT			= 520
	Local Const $MOUSE_WHEELSCROLL_EVENT		= 522
	Local Const $MOUSE_EXTRABUTTONDOWN_EVENT	= 523
	Local Const $MOUSE_EXTRABUTTONUP_EVENT		= 524
	
	Local $hCallback_KeyHook = DllCallbackRegister("__MouseEvent_Callback", "int", "int;ptr;ptr")
	Local $hM_Module = DllCall("Kernel32.dll", "hwnd", "GetModuleHandle", "ptr", 0)
	
	Local $hM_Hook = DllCall("User32.dll", "hwnd", "SetWindowsHookEx", "int", $WH_MOUSE_LL, _
		"ptr", DllCallbackGetPtr($hCallback_KeyHook), "hwnd", $hM_Module[0], "dword", 0)
	
	Sleep(10) ;Wait some moments until the variable is set by callback function
	
	If IsPtr($hCallback_KeyHook) Then
		DllCallbackFree($hCallback_KeyHook)
		$hCallback_KeyHook = 0
	EndIf
	
	If IsArray($hM_Hook) And $hM_Hook[0] > 0 Then
		DllCall("user32.dll", "int", "UnhookWindowsHookEx", "hwnd", $hM_Hook[0])
		$hM_Hook[0] = 0
	EndIf
	
	If Not IsDeclared("iIs__Mouse__Event") Then Return 0
	
	Local $iReturn = Eval("iIs__Mouse__Event")
	Assign("iIs__Mouse__Event", 0)
	
	Switch $iEvent
		Case 1 ;Mose Move
			Return ($iReturn = $MOUSE_MOVE_EVENT)
		Case 2 ;Mouse Wheel Button held down (pressed)
			Return ($iReturn = $MOUSE_WHEELDOWN_EVENT)
		Case 3 ;Mouse Wheel Button Scroll
			Return ($iReturn = $MOUSE_WHEELSCROLL_EVENT)
	EndSwitch
	
	Return SetError(1, 0, 0)
EndFunc   ;==>__IsMouseEvent

;Callback function for __IsMouseEvent
Func __MouseEvent_Callback($nCode, $wParam, $lParam)
	Local $iEvent = BitAND($wParam, 0xFFFF)
	
	If Not Eval("iIs__Mouse__Event") Then Assign("iIs__Mouse__Event", $iEvent, 2)
	
	Return 0
EndFunc   ;==>__MouseEvent_Callback

; #HELPER FUNCTION# ===================================================================
; Name: 			__KeysPressedCheck_Proc
; Description:      Check if specified keys are pressed
;
; Parameter(s):     $iStart   - Start key to check.
;                   $iFinish  - End key to check.
;                   $sHexKey  - [Opt] Key to check for.
;                   $iWait    - [Opt] If this param is > 0, then __IsPressed_GetTime is returned (check this function description).
;                   $iTFormat - [Opt] Format of the return time (if $iWait used).
;                   $vDLL     - [Opt] Handle to dll or default to user32.dll.
;
; Requirement(s):	None
;
; Return Value(s):  On Success - Returns 1 or time string (depending on $iWait parameter).
;                   On Failure - Returns -1.
;
; Author(s):        Valuater, mod. by MrCreatoR
; Note(s):			
;===============================================================================
Func __KeysPressedCheck_Proc($iStart, $iFinish, $iHexKey = -1, $iWait = 0, $iTFormat = -1, $vDLL = 'User32.dll')
	Local $iKey, $ia_R, $nHex_Key, $aDelim_Keys
	
	If $iHexKey <> -1 Then
		$iHexKey = __KeyStr_To_vkCode($iHexKey)
		If @error Then $iHexKey = __KeyGetType($iHexKey, 1)
	EndIf
	
	For $iKey = $iStart To $iFinish
		If $iHexKey <> -1 Then
			$nHex_Key = $iHexKey
		Else
			$nHex_Key = Hex($iKey, 2)
			If $iKey > 127 And $iKey < 136 Then $nHex_Key &= "H" ;F17 - F24 keys have the lenght of 3 chars, "H" is added.
		EndIf
		
		If StringInStr($nHex_Key, "|") Then
			$aDelim_Keys = StringSplit($nHex_Key, "|")
			
			For $jKey = 1 To $aDelim_Keys[0]
				$ia_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $aDelim_Keys[$jKey])
				
				If Not @error And BitAND($ia_R[0], 0x8000) = 0x8000 Then
					If $iWait Then Return __IsPressed_GetTime($aDelim_Keys[$jKey], $iTFormat, $vDLL)
					Return 1
				EndIf
			Next
		Else
			$ia_R = DllCall($vDLL, "int", "GetAsyncKeyState", "int", '0x' & $nHex_Key)
			
			If Not @error And BitAND($ia_R[0], 0x8000) = 0x8000 Then
				If $iWait Then Return __IsPressed_GetTime($nHex_Key, $iTFormat, $vDLL)
				Return 1
			EndIf
		EndIf
	Next
	
	Return -1
EndFunc   ;==>__KeysPressedCheck_Proc

; #HELPER FUNCTION# ===================================================================
; Name:           	__KeyGetType
; Description:      Returns Hexadecimal or Aplha key for specified key
;
; Parameter(s):     $iKeyIn   - Key to check (compare).
;					$iRetType - [Opt] Return type:
;                                                  0 Return Alpha.
;                                                  1 Return Hexadecimal.
;
; Requirement(s):   None.
;
; Return Value(s):  On Success - Returns Key type.
;                   On Failure - Returns $iKeyIn.
;
; Author(s):        Valuater, FireFox, MrCreatoR
; Note(s):          Thanks Valuater... 8)
;===============================================================================
Func __KeyGetType($iKeyIn, $iRetType = 0)
	If $iKeyIn = "" Then Return -1
	
	Local $s_String = "|01{LMouse}|02{RMouse}|04{MMouse}|05{X1Mouse}|06{X2Mouse}|08{BACKSPACE}|09{TAB}|0C{CLEAR}|" & _
			"0D{ENTER}|10{SHIFT}|11{CTRL}|12{ALT}|13{PAUSE}|14{CAPSLOCK}|1B{ESC}|20{SPACE}|21{PGUP}|22{PGDN}|" & _
			"23{END}|24{HOME}|25{LEFT}|26{UP}|27{RIGHT}|28{DOWN}|29{SELECT}|2A{PRINT}|2B{EXECUTE}|2C{PRINTSCREEN}|2D{INS}|" & _
			"2E{DEL}|30{0}|31{1}|32{2}|33{3}|34{4}|35{5}|36{6}|37{7}|38{8}|39{9}|41{A}|42{B}|43{C}|44{D}|45{E}|46{F}|47{G}|" & _
			"48{H}|49{I}|4A{J}|4B{K}|4C{L}|4D{M}|4E{N}|4F{O}|50{P}|51{Q}|52{R}|53{S}|54{T}|55{U}|56{V}|57{W}|58{X}|59{Y}|5A{Z}|" & _
			"5B{LWindows}|5C{RWindows}|60{Numpad0}|61{Numpad1}|62{Numpad2}|63{Numpad3}|64{Numpad4}|65{Numpad5}|" & _
			"66{Numpad6}|67{Numpad7}|68{Numpad8}|69{Numpad9}|" & _
			"6A{Multiply}|6B{Add}|6C{Separator}|6D{Subtract}|6E{Decimal}|6F{Divide}|" & _
			"70{F1}|71{F2}|72{F3}|73{F4}|74{F5}|75{F6}|76{F7}|77{F8}|78{F9}|" & _
			"79{F10}|7A{F11}|7B{F12}|7C{F13}|7D{F14}|7E{F15}|7F{F16}|80H{F17}|81H{F18}|82H{F19}|83H{F20}|84H{F21}|85H{F22}|" & _
			"86H{F23}|87H{F24}|90{NUMLOCK}|91{SCROLLLOCK}|A0{LSHIFT}|A1{RSHIFT}|A2{LCTRL}|A3{RCTRL}|" & _
			"A4{LMENU}|A5{RMENU}|BA{;}|BB{=}|BC{,}|BD{-}|BE{.}|BF{/}|C0{`}|DB{[}|DC{\}|DD{]}|"
	
	If $iRetType = 1 Then 	;Return Hex
		$s_String = StringRegExpReplace($s_String, "(?i).*\|(.*?)\{" & $iKeyIn & "\}\|.*", "\1")
	Else 				;Return string
		$s_String = StringRegExpReplace($s_String, "(?i).*\|" & $iKeyIn & "\{(.*?)\}\|.*", "\1")
	EndIf
	
	If @extended > 0 Then Return $s_String
	
	Return $iKeyIn
EndFunc   ;==>__KeyGetType

; #HELPER FUNCTION# ===================================================================
; Name:      		__KeyStr_To_vkCode
; Description:      Return hex-code for passed string (in format of HotKeySet() function).
;
; Parameter(s):     $sKeyStr - String in format of HotKeySet() function.
;
; Requirement(s):   None.
;
; Return Value(s):  On Success - Returns "_IsPressed compatible" hex-code.
;                   On Failure - Returns 0 and set @error to 1.
;
; Author(s):       	MrCreatoR
; Note(s):          
;===============================================================================
Func __KeyStr_To_vkCode($sKeyStr)
	Local $sRet_Keys = "", $aDelim_Keys[1]
	
	Local $aKeys = StringSplit("{LMouse}|{RMouse}|{}|(MMouse}|{}|{}|{}|{BACKSPACE}|{TAB}|{}|{}|{}|{ENTER}|{}|{}|{SHIFT}|{CTRL}|{ALT}|{PAUSE}|{CAPSLOCK}|{}|{}|{}|{}|{}|{}|{ESC}|{}|{}|{}|{]|{SPACE}|{PGUP}|{PGDN}|{END}|{HOME}|{LEFT}|{UP}|{RIGHT}|{DOWN}|{SELECT}|{PRINTSCREEN}|{}|{PRINTSCREEN}|{INSERT}|{DEL}|{}|0|1|2|3|4|5|6|7|8|9|{}|{}|{}|{}|{}|{}|{}|a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|{LWIN}|{RWIN}|{APPSKEY}|{}|{SLEEP}|{Numpad0}|{Numpad1}|{Numpad2}|{Numpad3}|{Numpad4}|{Numpad5}|{Numpad6}|{Numpad7}|{Numpad8}|{Numpad9}|{NUMPADMULT}|{NUMPADADD}|{}|{NUMPADSUB}|{NUMPADDOT}|{NUMPADDIV}|{F1}|{F2}|{F3}|{F4}|{F5}|{F6}|{F7}|{F8}|{F9}|{F10}|{F11}|{F12}|{F13}|{F14}|{F15}|{F16}|{F17}|{F18}|{F19}|{F20}|{F21}|{F22}|{F23}|{F24}|{}|{}|{}|{}|{}|{}|{}|{}|{NUMLOCK}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{SHIFT}|{SHIFT}|{CTRL}|{CTRL}|{ALT}|{ALT}|{BROWSER_BACK}|{BROWSER_FORWARD}|{BROWSER_REFRESH}|{BROWSER_STOP}|{BROWSER_SEARCH}|{BROWSER_FAVORITES}|{BROWSER_HOME}|{VOLUME_MUTE}|{VOLUME_DOWN}|{VOLUME_UP}|{MEDIA_NEXT}|{MEDIA_PREV}|{MEDIA_STOP}|{MEDIA_PLAY_PAUSE}|{LAUNCH_MAIL}|{LAUNCH_MEDIA}|{LAUNCH_APP1}|{LAUNCH_APP2}|{}|{}|;|{+}|,|{-}|.|/|`|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|{}|[|\|]|'", "|")
	
	If StringRegExp($sKeyStr, "\A\[|\]\z") Then
		$sKeyStr = StringRegExpReplace($sKeyStr, "\A\[|\]\z", "")
		$sKeyStr = StringRegExpReplace($sKeyStr, "(.)", "\1|")
		$sKeyStr = StringRegExpReplace($sKeyStr, "\|+$", "")
		
		$aDelim_Keys = StringSplit($sKeyStr, "")
	EndIf
	
	For $i = 1 To $aKeys[0]
		If $aDelim_Keys[0] > 1 Then
			For $j = 1 To $aDelim_Keys[0]
				If $aKeys[$i] = $aDelim_Keys[$j] Then $sRet_Keys &= Hex($i, 2) & "|"
			Next
		Else
			If $aKeys[$i] = $sKeyStr Then Return Hex($i, 2)
		EndIf
	Next
	
	If $sRet_Keys = "" Then Return SetError(1, 0, $sKeyStr)
	Return StringRegExpReplace($sRet_Keys, "\|+$", "")
EndFunc   ;==>__KeyStr_To_vkCode

; #HELPER FUNCTION# ===================================================================
; Name:      		__SecondsToTime
; Description:      Return time string format from seconds.
;
; Parameter(s):     $iTicks - Number that include amount of seconds to transform to time format.
;					$sDelim - [Optional] Delimeter for the return time format (default is ":").
;
; Requirement(s):   None.
;
; Return Value(s):  On Success - Returns formatted string time.
;                   On Failure - Returns 0 and set @error to 1.
;
; Author(s):       	MrCreatoR
; Note(s):          
;===============================================================================
Func __SecondsToTime($iTicks, $sDelim=":")
	If Number($iTicks) >= 0 Then
		Local $iHours = Int($iTicks / 3600)
		$iTicks = Mod($iTicks, 3600)
		Local $iMins = Int($iTicks / 60)
		Local $iSecs = Round(Mod($iTicks, 60))
		
		If StringLen($iHours) = 1 Then $iHours = "0" & $iHours
		If StringLen($iMins) = 1 Then $iMins = "0" & $iMins
		If StringLen($iSecs) = 1 Then $iSecs = "0" & $iSecs
		
		Return $iHours & $sDelim & $iMins & $sDelim & $iSecs
	EndIf
	
	Return SetError(1, 0, 0)
EndFunc   ;==>__SecondsToTime
#EndRegion HELPER FUNCTIONS
;