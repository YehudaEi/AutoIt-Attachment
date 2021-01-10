Global $DDD_RAW_TARGET_PATH = 1
Global $DDD_REMOVE_DEFINITION = 2
Global $KEYBOARD_INDICATOR_PARAMETERS="ushort UnitId;ushort LedFlags;"
Global $IOCTL_KEYBOARD_SET_INDICATORS = 720904
Global $IOCTL_KEYBOARD_QUERY_INDICATORS = 720960

; Flags to _KeyboardSetLed
Global $KEYBOARD_LIT = 0
Global $KEYBOARD_UNLIT = 8
Global $KEYBOARD_SCROLL_LED = 1
Global $KEYBOARD_NUM_LED= 2
Global $KEYBOARD_CAPS_LED = 4

; #FUNCTION# ====================================================================================================================
; Name...........: _OpenKeyboard
; Description ...: Opens a handle to the keyboard
; Syntax.........: _OpenKeyboard()
; Parameters ....: None
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _CloseKeyboard
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _OpenKeyboard()
	Local $KeyboardHandle
	DllCall("Kernel32.dll","int","DefineDosDeviceW","dword",$DDD_RAW_TARGET_PATH,"wstr","Keybd","wstr","\Device\KeyboardClass0")
	$KeyboardHandle = DllCall("Kernel32.dll","hwnd","CreateFile","str","\\.\Keybd","dword",0x40000000,"dword",0,"dword",0,"dword",3,"dword",0,"dword",0)
	$KeyboardHandle=$KeyboardHandle[0]
	Return $KeyboardHandle
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _KeyboardSetLed
; Description ...: Lits/Unlits specified keyboard leds
; Syntax.........: _KeyboardSetLed($KeyboardHandle,$flags)
; Parameters ....: $KeyboardHandle - Handle to the keyboard previously opened with _OpenKeyboard
;                  $flags - A bitwise OR combination of the keyboard constants defined in the top of the script
; Return values .: The previous lit leds ( use BitAND() to figure out which ones)
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _OpenKeyboard
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _KeyboardSetLed($KeyboardHandle,$flags)
	Local $PreviousLedConfig
	$Kernel32=DllOpen("Kernel32.dll")
	
	$kip=DllStructCreate($KEYBOARD_INDICATOR_PARAMETERS)
	
	DllCall($Kernel32,"int","DeviceIoControl","hwnd",$KeyboardHandle,"dword",$IOCTL_KEYBOARD_QUERY_INDICATORS,"ptr",0,"dword",0, _ 
			"ptr",DllStructGetPtr($kip),"dword",DllStructGetSize($kip),"dword*",0,"ptr",0)
	$PreviousLedConfig=DllStructGetData($kip,"LedFlags")
	If BitAND($flags,$KEYBOARD_UNLIT) THen
		If Not BitAND(DllStructGetData($kip,"LedFlags"),$KEYBOARD_NUM_LED) And BitAND($flags,$KEYBOARD_NUM_LED) Then $flags=BitXor($flags,$KEYBOARD_NUM_LED)
		If Not BitAND(DllStructGetData($kip,"LedFlags"),$KEYBOARD_CAPS_LED) And BitAND($flags,$KEYBOARD_CAPS_LED) Then $flags=BitXor($flags,$KEYBOARD_CAPS_LED)
		If Not BitAND(DllStructGetData($kip,"LedFlags"),$KEYBOARD_SCROLL_LED) And BitAND($flags,$KEYBOARD_SCROLL_LED) Then $flags=BitXor($flags,$KEYBOARD_SCROLL_LED)
		$flags=BitXOR($flags,$KEYBOARD_UNLIT)
		DllStructSetData($kip,"LedFlags",BitXOR(DllStructGetData($kip,"LedFlags"),$flags))
	Else
		DllStructSetData($kip,"LedFlags",BitOR(DllStructGetData($kip,"LedFlags"),$flags))
	EndIf	
	DllCall($Kernel32,"int","DeviceIoControl","hwnd",$KeyboardHandle,"dword",$IOCTL_KEYBOARD_SET_INDICATORS,"ptr",DllStructGetPtr($kip),"dword",DllStructGetSize($kip), _ 
			"ptr",0,"dword",0,"dword*",0,"ptr",0)
	DllClose($Kernel32)
	Return $PreviousLedConfig
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _CloseKeyboard
; Description ...: Closes a handle to the keyboard
; Syntax.........: _CloseKeyboard()
; Parameters ....: None
; Return values .: None
; Author ........: Andreas Karlsson (monoceres)
; Modified.......:
; Remarks .......:
; Related .......: _OpenKeyboard
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _CloseKeyboard($KeyboardHandle)
	DllCall("Kernel32.dll","int","DefineDosDeviceW","dword",$DDD_REMOVE_DEFINITION,"wstr","Keybd","wstr","")
	DllCall("Kernel32.dll","int","CloseHandle","hwnd",$KeyboardHandle)	
EndFunc


	