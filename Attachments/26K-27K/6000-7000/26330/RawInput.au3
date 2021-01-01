#include-once

#Region VARIABLES
; #VARIABLES# ================================================================================================================
If Not IsDeclared('WM_INPUT') Then Global Const $WM_INPUT = 0x00FF

; ===============================================================================================================================
; $tagRAWINPUTHEADER Constants
; ===============================================================================================================================
Global Const $RIM_TYPEMOUSE = 0
Global Const $RIM_TYPEKEYBOARD = 0x01
Global Const $RIM_TYPEHID = 0x02

; ===============================================================================================================================
; $WM_INPUT Constants
; ===============================================================================================================================
Global Const $RIM_INPUT =  0
Global Const $RIM_INPUTSINK = 1

; ===============================================================================================================================
; $tagRAWMOUSE Constants
; ===============================================================================================================================
Global Const $MOUSE_MOVE_RELATIVE = 0
Global Const $MOUSE_MOVE_ABSOLUTE = 0x01
Global Const $MOUSE_VIRTUAL_DESKTOP = 0x02
Global Const $MOUSE_ATTRIBUTES_CHANGED = 0x04

Global Const $RI_MOUSE_LEFT_BUTTON_DOWN  = 0x01
Global Const $RI_MOUSE_LEFT_BUTTON_UP = 0x0002
Global Const $RI_MOUSE_RIGHT_BUTTON_DOWN = 0x0004
Global Const $RI_MOUSE_RIGHT_BUTTON_UP = 0x0008
Global Const $RI_MOUSE_MIDDLE_BUTTON_DOWN = 0x0010
Global Const $RI_MOUSE_MIDDLE_BUTTON_UP = 0x0020
Global Const $RI_MOUSE_BUTTON_1_DOWN = $RI_MOUSE_LEFT_BUTTON_DOWN
Global Const $RI_MOUSE_BUTTON_1_UP = $RI_MOUSE_LEFT_BUTTON_UP
Global Const $RI_MOUSE_BUTTON_2_DOWN = $RI_MOUSE_RIGHT_BUTTON_DOWN
Global Const $RI_MOUSE_BUTTON_2_UP = $RI_MOUSE_RIGHT_BUTTON_UP
Global Const $RI_MOUSE_BUTTON_3_DOWN = $RI_MOUSE_MIDDLE_BUTTON_DOWN
Global Const $RI_MOUSE_BUTTON_3_UP = $RI_MOUSE_MIDDLE_BUTTON_UP
Global Const $RI_MOUSE_BUTTON_4_DOWN = 0x0040
Global Const $RI_MOUSE_BUTTON_4_UP = 0x0080
Global Const $RI_MOUSE_BUTTON_5_DOWN = 0x0100
Global Const $RI_MOUSE_BUTTON_5_UP = 0x0200
Global Const $RI_MOUSE_WHEEL = 0x0400

; ===============================================================================================================================
; $tagRAWKEYBOARD Constants
; ===============================================================================================================================
Global Const $RI_KEY_MAKE = 0
Global Const $RI_KEY_BREAK = 0x01
Global Const $RI_KEY_E0 = 0x02
Global Const $RI_KEY_E1 = 0x04
Global Const $RI_KEY_TERMSRV_SET_LED = 0x08
Global Const $RI_KEY_TERMSRV_SHADOW = 0x10
Global Const $KEYBOARD_OVERRUN_MAKE_CODE = 0xFF

; ===============================================================================================================================
; _GetRawInputData  Constants
; ===============================================================================================================================
Global Const $RID_INPUT = 0x10000003
Global Const $RID_HEADER = 0x10000005

; ===============================================================================================================================
; _GetRawInputDeviceInfo Constants
; ===============================================================================================================================
Global Const $RIDI_PREPARSEDDATA = 0x20000005
Global Const $RIDI_DEVICENAME = 0x20000007  ; The return valus is the character length, not the byte size
Global Const $RIDI_DEVICEINFO = 0x2000000B

; ===============================================================================================================================
; $tagRAWINPUTDEVICE Constants
; ===============================================================================================================================
Global Const $RIDEV_REMOVE = 0x00000001
Global Const $RIDEV_EXCLUDE = 0x00000010
Global Const $RIDEV_PAGEONLY = 0x00000020
Global Const $RIDEV_NOLEGACY = 0x00000030
Global Const $RIDEV_INPUTSINK = 0x00000100
Global Const $RIDEV_CAPTUREMOUSE = 0x00000200  	; Effective when mouse nolegacy is specified, otherwise it would be an error
Global Const $RIDEV_NOHOTKEYS = 0x00000200  	; Effective for keyboard.
Global Const $RIDEV_APPKEYS = 0x00000400  		; Effective for keyboard.
Global Const $RIDEV_EXMODEMASK = 0x000000F0
Global Const $RIDEV_EXINPUTSINK = 0x00001000
Global Const $RIDEV_DEVNOTIFY = 0x00002000

; ===============================================================================================================================
; Error Constants
; ===============================================================================================================================
Global Const $__ERROR_MORE_DATA = 4294967295
Global Const $__ERROR_INSUFFICIENT_BUFFER = 0x007A
Global Const $__UINT_ERROR = 4294967295

#EndRegion VARIABLES

#Region STRUCTURES
; #STRUCTURES# ================================================================================================================

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUTHEADER
; Description ...: Contains the header information that is part of the raw input data.
; Fields ........: dwType	- Type of raw input. It can be one of the following values.
;				   |$RIM_TYPEMOUSE		- Raw input comes from the mouse.
;				   |$RIM_TYPEKEYBOARD	- Raw input comes from the keyboard.
;				   |$RIM_TYPEHID		- Raw input comes from some device that is not a keyboard or a mouse.
;                  dwSize	- Size, in bytes, of the entire input packet of data. This includes $tagRAWINPUT_* plus possible 
;                  +extra input reports in the RAWHID variable length array. 
;                  hDevice	- Handle to the device generating the raw input data.
;                  wParam	- Value passed in the wParam parameter of the $WM_INPUT message. 
; Author ........:
; Remarks .......: To get more information on the device, use hDevice in a call to _GetRawInputDeviceInfo.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645571%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWINPUTHEADER = _
    'dword dwType;' & _
    'dword dwSize;' & _
    'hwnd hDevice;' & _
    'uint_ptr wParam;'

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWMOUSE
; Description ...: Contains information about the state of the mouse.
; Fields ........: usFlags		 - Mouse state. This member can be any reasonable combination of the following.
;				   |$MOUSE_MOVE_RELATIVE		- Mouse movement data is relative to the last mouse position.
;				   |$MOUSE_MOVE_ABSOLUTE		- Mouse movement data is based on absolute position.
;				   |$MOUSE_VIRTUAL_DESKTOP		- Mouse coordinates are mapped to the virtual desktop (for a multiple monitor system).
;				   |$MOUSE_ATTRIBUTES_CHANGED	- Mouse attributes changed; application needs to query the mouse attributes.
;                  usButtonFlags - Transition state of the mouse buttons. This member can be one or more of the following values.
;                  |$RI_MOUSE_LEFT_BUTTON_DOWN	 - Left button changed to down.
;                  |$RI_MOUSE_LEFT_BUTTON_UP	 - Left button changed to up.
;                  |$RI_MOUSE_RIGHT_BUTTON_DOWN	 - Right button changed to down.
;                  |$RI_MOUSE_RIGHT_BUTTON_UP	 - Right button changed to up.
;                  |$RI_MOUSE_MIDDLE_BUTTON_DOWN - Middle button changed to down.
;                  |$RI_MOUSE_MIDDLE_BUTTON_UP	 - Middle button changed to up.
;                  |$RI_MOUSE_BUTTON_1_DOWN		 - $RI_MOUSE_LEFT_BUTTON_DOWN
;                  |$RI_MOUSE_BUTTON_1_UP	   	 - $RI_MOUSE_LEFT_BUTTON_UP
;                  |$RI_MOUSE_BUTTON_2_DOWN		 - $RI_MOUSE_RIGHT_BUTTON_DOWN
;                  |$RI_MOUSE_BUTTON_2_UP		 - $RI_MOUSE_RIGHT_BUTTON_UP
;                  |$RI_MOUSE_BUTTON_3_DOWN		 - $RI_MOUSE_MIDDLE_BUTTON_DOWN
;                  |$RI_MOUSE_BUTTON_3_UP		 - $RI_MOUSE_MIDDLE_BUTTON_UP
;                  |$RI_MOUSE_BUTTON_4_DOWN		 - XBUTTON1 changed to down.
;                  |$RI_MOUSE_BUTTON_4_UP		 - XBUTTON1 changed to up.
;                  |$RI_MOUSE_BUTTON_5_DOWN		 - XBUTTON2 changed to down.
;                  |$RI_MOUSE_BUTTON_5_UP		 - XBUTTON2 changed to up.
;                  |$RI_MOUSE_WHEEL				 - Raw input comes from a mouse wheel. The wheel delta is stored in usButtonData.
;                  usButtonData	 	  - If usButtonFlags is $RI_MOUSE_WHEEL, this member is a signed value that specifies the wheel
;                  +delta. 
;                  ulRawButtons	 	  - Raw state of the mouse buttons. 
;                  lLastX		 	  - Motion in the X direction. This is signed relative motion or absolute motion, depending on 
;                  +the value of usFlags. 
;                  lLastY		 	  - Motion in the Y direction. This is signed relative motion or absolute motion, depending on 
;                  +the value of usFlags. 
;                  ulExtraInformation - Device-specific additional information for the event.
; Author ........:
; Remarks .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645578%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWMOUSE = _
	'ushort usFlags;' & _
	'ushort usButtonFlags;' & _
	'ushort usButtonData;' & _
	'ulong ulRawButtons;' & _
	'long lLastX;' & _
	'long lLastY;' & _
	'ulong ulExtraInformation'

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWKEYBOARD
; Description ...: Contains information about the state of the keyboard.
; Fields ........: MakeCode 		- Scan code from the key depression. The scan code for keyboard overrun is 
;                  +$KEYBOARD_OVERRUN_MAKE_CODE. 
;				   Flags			- Flags for scan code information. It can be one or more of the following.
;				   |$RI_KEY_MAKE
;				   |$RI_KEY_BREAK
;				   |$RI_KEY_E0
;                  |$RI_KEY_E1
;                  |$RI_KEY_TERMSRV_SET_LED
;                  |$RI_KEY_TERMSRV_SHADOW
;                  Reserved			- Reserved; must be zero. 
;                  VKey				- Microsoft Windows message compatible virtual-key code.
;                  Message			- Corresponding window message, for example $WM_KEYDOWN, $WM_SYSKEYDOWN, and so forth. 
;                  ExtraInformation	- Device-specific additional information for the event. 
; Author ........:
; Remarks .......:
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645575%28VS.85%29.aspx
;                  http://msdn.microsoft.com/en-us/library/ms645540%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWKEYBOARD = _
    'ushort MakeCode;' & _
    'ushort Flags;' & _
    'ushort Reserved;' & _
    'ushort VKey;' & _
    'uint Message;' & _
    'ulong ExtraInformation;'

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWHID
; Description ...: Describes the format of the raw input from a Human Interface Device (HID). 
; Fields ........: dwSizeHid 	- Size, in bytes, of each HID input in bRawData.
;				   dwCount		- Number of HID inputs in bRawData.
;                  bRawData		- Raw input data as an array of bytes. 
; Author ........:
; Remarks .......: Each WM_INPUT can indicate several inputs, but all of the inputs come from the same HID.
;                  +The size of the bRawData array is dwSizeHid * dwCount.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645549%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWHID = _
    'dword dwSizeHid;' & _
    'dword dwCount;' & _
    'ubyte bRawData;'

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUT_MOUSE
; Description ...: Contains the raw input from a device (mouse).
; Fields ........: See above ($tagRAWINPUTHEADER + $tagRAWMOUSE)
; Author ........:
; Remarks .......: The handle to this structure is passed in the lParam parameter of $WM_INPUT.
;                  +To get detailed information -- such as the header and the content of the raw input -- call _GetRawInputData.
;                  +To read the $tagRAWINPUT_* in the message loop as a buffered read, call _GetRawInputBuffer.
;                  +To get device specific information, call _GetRawInputDeviceInfo with the hDevice from $tagRAWINPUTHEADER.
;                  +Raw input is available only when the application calls _RegisterRawInputDevices with valid device specifications.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645562%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWINPUT_MOUSE = _
	$tagRAWINPUTHEADER & _
	$tagRAWMOUSE

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUT_KEYBOARD
; Description ...: Contains the raw input from a device (keyboard).
; Fields ........: See above ($tagRAWINPUTHEADER + $tagRAWKEYBOARD)
; Author ........:
; Remarks .......: Ditto.
; Link ..........: Ditto.
; ===============================================================================================================================
Global Const $tagRAWINPUT_KEYBOARD = _
	$tagRAWINPUTHEADER & _
	$tagRAWKEYBOARD & _
	'dword;ushort;' ; dwpad;uspad;

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUT_KEYBOARD
; Description ...: Contains the raw input from a device (HID).
; Fields ........: See above ($tagRAWINPUTHEADER + $tagRAWHID)
; Author ........:
; Remarks .......: Ditto.
; Link ..........: Ditto.
; ===============================================================================================================================
Global Const $tagRAWINPUT_HID = _
	$tagRAWINPUTHEADER & _
	$tagRAWHID & _
	'dword;dword;dword;' ; dwpad;dwpad;dwpad;

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRID_DEVICE_INFO_MOUSE
; Description ...: Defines the raw input data coming from the specified mouse.
; Fields ........: dwId					- ID for the mouse device.
;                  dwNumberOfButtons	- Number of buttons for the mouse.
;                  dwSampleRate			- Number of data points per second. This information may not be applicable for every 
;                  +mouse device.
;                  fHasHorizontalWheel	- TRUE if the mouse has a wheel for horizontal scrolling; otherwise, FALSE.
;                  +Note, This field is only supported under Windows Vista and later versions.
; Author ........:
; Remarks .......: For the mouse, the Usage Page is 1 and the Usage is 2.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645589%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRID_DEVICE_INFO_MOUSE = _
    'dword dwId;' & _
    'dword dwNumberOfButtons;' & _
    'dword dwSampleRate;' & _
    'int fHasHorizontalWheel;' & _
	'dword;dword' ; dwpad;dwpad

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRID_DEVICE_INFO_KEYBOARD
; Description ...: Defines the raw input data coming from the specified keyboard.
; Fields ........: dwType					- Type of the keyboard.
;                  dwSubType				- Subtype of the keyboard.
;                  dwKeyboardMode			- Scan code mode.
;                  dwNumberOfFunctionKeys	- Number of function keys on the keyboard.
;                  dwNumberOfIndicators		- Number of LED indicators on the keyboard.
;                  dwNumberOfKeysTotal		- Total number of keys on the keyboard. 
; Author ........:
; Remarks .......: For the keyboard, the Usage Page is 1 and the Usage is 6. 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645587%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRID_DEVICE_INFO_KEYBOARD = _
    'dword dwType;' & _
    'dword dwSubType;' & _
    'dword dwKeyboardMode;' & _
    'dword dwNumberOfFunctionKeys;' & _
    'dword dwNumberOfIndicators;' & _
    'dword dwNumberOfKeysTotal;'

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRID_DEVICE_INFO_HID
; Description ...: Defines the raw input data coming from the specified Human Interface Device (HID).
; Fields ........: dwVendorId		- Vendor ID for the HID.
;                  dwProductId		- Product ID for the HID.
;                  dwVersionNumber	- Version number for the HID. 
;                  usUsagePage		- Top-level collection Usage Page for the device.
;                  usUsage			- Top-level collection Usage for the device. 
; Author ........:
; Remarks .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645584%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRID_DEVICE_INFO_HID = _
    'dword dwVendorId;' & _
    'dword dwProductId;' & _
    'dword dwVersionNumber;' & _
    'ushort usUsagePage;' & _
    'ushort usUsage;' & _
	'dword;dword' ; dwpad;dwpad

; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRIDDEVICEINFO_MOUSE
; Description ...: Defines the raw input data coming from any device (mouse).
; Fields ........: cbSize	- Size, in bytes, of the $tagRIDDEVICEINFO_MOUSE structure. 
;                  dwType	- Type of raw input data. This member can be one of the following values. 
;                  |$RIM_TYPEMOUSE	- Data comes from a mouse.
; Author ........:
; Remarks .......: See data fields of the $tagRID_DEVICE_INFO_MOUSE structure for more information.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645581%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRIDDEVICEINFO_MOUSE = _ 
	'dword cbSize;' & _
	'dword dwType;' & _
	$tagRID_DEVICE_INFO_MOUSE
  
; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRIDDEVICEINFO_KEYBOARD
; Description ...: Defines the raw input data coming from any device (keyboard).
; Fields ........: cbSize	- Size, in bytes, of the $tagRIDDEVICEINFO_KEYBOARD structure. 
;                  dwType	- Type of raw input data. This member can be one of the following values. 
;                  |$RIM_TYPEKEYBOARD	- Data comes from a keyboard.
; Author ........:
; Remarks .......: See data fields of the $tagRID_DEVICE_INFO_KEYBOARD structure for more information.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645581%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRIDDEVICEINFO_KEYBOARD  = _
	'dword cbSize;' & _
	'dword dwType;' & _
	$tagRID_DEVICE_INFO_KEYBOARD
	
; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRIDDEVICEINFO_HID
; Description ...: Defines the raw input data coming from any device (HID).
; Fields ........: cbSize	- Size, in bytes, of the $tagRIDDEVICEINFO_HID structure. 
;                  dwType	- Type of raw input data. This member can be one of the following values. 
;                  |$RIM_TYPEHID	- Data comes from an HID that is not a keyboard or a mouse.
; Author ........:
; Remarks .......: See data fields of the $tagRID_DEVICE_INFO_HID structure for more information.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645581%28VS.85%29.aspx
; ===============================================================================================================================	
Global Const $tagRIDDEVICEINFO_HID = _
	'dword cbSize;' & _
	'dword dwType;' & _
	$tagRID_DEVICE_INFO_HID
	
; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUTDEVICE
; Description ...: Defines information for the raw input devices. 
; Fields ........: usUsagePage	- Top level collection Usage page for the raw input device. 
;                  usUsage		- Top level collection Usage for the raw input device.
;                  dwFlags		- Mode flag that specifies how to interpret the information provided by usUsagePage and usUsage. 
;                  +It can be zero (the default) or one of the following values. By default, the operating system sends raw input 
;                  +from devices with the specified top level collection (TLC) to the registered application as long as it has the
;                  +window focus.
;                  |$RIDEV_REMOVE		- If set, this removes the top level collection from the inclusion list. This tells the 
;                  +operating system to stop reading from a device which matches the top level collection.
;                  |$RIDEV_EXCLUDE		- If set, this specifies the top level collections to exclude when reading a complete usage
;                  +page. This flag only affects a TLC whose usage page is already specified with $RIDEV_PAGEONLY.
;                  |$RIDEV_PAGEONLY		- If set, this specifies all devices whose top level collection is from the specified 
;                  +usUsagePage. Note that usUsage must be zero. To exclude a particular top level collection, use $RIDEV_EXCLUDE.
;                  |$RIDEV_NOLEGACY		- If set, this prevents any devices specified by usUsagePage or usUsage from generating 
;                  +legacy messages. This is only for the mouse and keyboard. See Remarks.
;                  |$RIDEV_INPUTSINK	- If set, this enables the caller to receive the input even when the caller is not in the
;                  +foreground. Note that hwndTarget must be specified.
;                  |$RIDEV_CAPTUREMOUSE - If set, the mouse button click does not activate the other window
;                  |$RIDEV_NOHOTKEYS	- If set, the application-defined keyboard device hotkeys are not handled. However, 
;                  +the system hotkeys; for example, ALT+TAB and CTRL+ALT+DEL, are still handled. By default, all keyboard hotkeys 
;                  +are handled. $RIDEV_NOHOTKEYS can be specified even if $RIDEV_NOLEGACY is not specified and hwndTarget is NULL.
;                  |$RIDEV_APPKEYS		- Microsoft Windows XP Service Pack 1 (SP1): If set, the application command keys are 
;                  +handled. $RIDEV_APPKEYS can be specified only if RIDEV_NOLEGACY is specified for a keyboard device.
;                  hwndTarget	- Handle to the target window. If NULL it follows the keyboard focus.
; Author ........:
; Remarks .......: If $RIDEV_NOLEGACY is set for a mouse or a keyboard, the system does not generate any legacy message for that 
;                  +device for the application. For example, if the mouse TLC is set with $RIDEV_NOLEGACY, $WM_LBUTTONDOWN and 
;                  +related legacy mouse messages are not generated. Likewise, if the keyboard TLC is set with $RIDEV_NOLEGACY, 
;                  +$WM_KEYDOWN and related legacy keyboard messages are not generated.
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645565%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWINPUTDEVICE = _
    'ushort usUsagePage;' & _
    'ushort usUsage;' & _
    'dword dwFlags;' & _
    'hwnd hwndTarget;'
  
; #STRUCTURE# ===================================================================================================================
; Name...........: $tagRAWINPUTDEVICELIST
; Description ...: Contains information about a raw input device.
; Fields ........: hDevice	- Handle to the raw input device. 
;                  dwType	- Type of device. This can be one of the following values.
;                  |$RIM_TYPEMOUSE		- The device is a mouse.
;                  |$RIM_TYPEKEYBOARD	- The device is a keyboard.
;                  |$RIM_TYPEHID		- The device is an Human Interface Device (HID) that is not a keyboard and not a mouse.
; Author ........:
; Remarks .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645568%28VS.85%29.aspx
; ===============================================================================================================================
Global Const $tagRAWINPUTDEVICELIST = _
    'hwnd hDevice;' & _
    'dword dwType;'

#EndRegion STRUCTURES


#Region FUNCTIONS
; #FUNCTIONS# ================================================================================================================

; ===============================================================================================================================
; #CURRENT# =====================================================================================================================
;_DefRawInputProc
;_GetRawInputBuffer
;_GetRawInputData
;_GetRawInputDeviceInfo
;_GetRawInputDeviceList
;_GetRegisteredRawInputDevices
;_RegisterRawInputDevices
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name ..........: _DefRawInputProc
; Description ...: Calls the default raw input procedure to provide default processing for any raw input messages that an 
;                  +application does not process. This function ensures that every message is processed. DefRawInputProc is
;                  +called with the same parameters received by the window procedure
; Syntax ........: _DefRawInputProc($paRawInput, $iInputs, $iSizeHeader[, $hDll = 'user32.dll'])
; Parameters ....: $paRawInput  - Pointer to an array of $tagRAWINPUT_* structures. 
;                  $iInputs		- Number of $tagRAWINPUT_* structures pointed to by paRawInput. 
;                  $iSizeHeader	- Size, in bytes, of the $tagRAWINPUTHEADER structure. 
; Return values .: Success      - 0
;                  Failure      - Error value
; Author ........: 
; Modified ......:
; Remarks .......:
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645594%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _DefRawInputProc($paRawInput, $iInputs, $iSizeHeader, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'lresult', 'DefRawInputProc', 'ptr', $paRawInput, 'int', $iInputs, 'uint', $iSizeHeader)
	
	If @error Or $aRet[0] <> 0 Then Return SetError(1, 0, $aRet[0])
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRawInputBuffer
; Description ...: Does a buffered read of the raw input data.
; Syntax ........: _GetRawInputBuffer($pData, ByRef $iSize, $iSizeHeader[, $hDll = 'user32.dll'])
; Parameters ....: $pData  - Pointer to a buffer of $tagRAWINPUT_* structures that contain the raw input data. If NULL, the minimum
;                  +required buffer, in bytes, is returned in $iSize.  
;                  $iSize		- A variable that specifies the size, in bytes, of a $tagRAWINPUT_* structure.  
;                  $iSizeHeader	- Size, in bytes, of the $tagRAWINPUTHEADER structure. 
; Return values .: Success	- If pData is NULL and the function is successful, the return value is zero. If pData is not NULL and 
;                  +the function is successful, the return value is the number of $tagRAWINPUT_* structures written to pData.
;				   Failure	- Sets @error to 1 and returns $__UINT_ERROR. Call _WinAPI_GetLastError for the error code.
; Author ........: 
; Modified ......:
; Remarks .......:
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645595%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _GetRawInputBuffer($pData, ByRef $iSize, $iSizeHeader, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'uint', 'GetRawInputBuffer', 'ptr', $pData, 'uint*', $iSize, 'uint', $iSizeHeader)
	
	If @error Then Return SetError(1, 0, $aRet[0])
	$iSize = $aRet[2]
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRawInputData
; Description ...: Gets the raw input from the specified device.
; Syntax ........: _GetRawInputData($hRawInput, $iCommand, $pData, ByRef $iSize, $iSizeHeader[, $hDll = 'user32.dll'])
; Parameters ....: $hRawInput  - Handle to the $tagRAWINPUT_* structure. This comes from the lParam in $WM_INPUT.
;                  $iCommand	- Command flag. This parameter can be one of the following values.
;                  |$RID_INPUT 		- Get the raw data from the $tagRAWINPUT_* structure.
;                  |$RID_HEADER 	- Get the header information from the $tagRAWINPUT_* structure.
;                  $pData		- Pointer to the data that comes from the $tagRAWINPUT_* structure. This depends on the value
;                  +of $iCommand. If pData is NULL, the required size of the buffer is returned in $iSize. 
;                  $iSize		- A variable that specifies the size, in bytes, of the data in pData.  
;                  $iSizeHeader	- Size, in bytes, of the $tagRAWINPUTHEADER structure.
; Return values .: Success	- If pData is NULL and the function is successful, the return value is zero. If pData is not NULL and 
;                  +the function is successful, the return value is the number of bytes copied into pData.
;				   Failure	  Sets error to 1 and returns $__UINT_ERROR.
; Author ........: 
; Modified ......:
; Remarks .......: GetRawInputData gets the raw input one $tagRAWINPUT_* structure at a time. In contrast, _GetRawInputBuffer 
;				   +gets an array of $tagRAWINPUT_* structures.
; Related .......: _GetRawInputBuffer
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645596%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _GetRawInputData($hRawInput, $iCommand, $pData, ByRef $iSize, $iSizeHeader, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'uint', 'GetRawInputData', 'hwnd', $hRawInput, 'uint', $iCommand, 'ptr', $pData, 'uint*', $iSize, 'uint', $iSizeHeader)
	
	If @error Or $aRet[0] = $__UINT_ERROR Then Return SetError(1, 0, $aRet[0])
	$iSize = $aRet[4]
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRawInputDeviceInfo
; Description ...: Gets information about the raw input device.
; Syntax ........: _GetRawInputDeviceInfo($hDevice, $iCommand, $pData, ByRef $iSize[, $hDll = 'user32.dll'])
; Parameters ....: $hDevice  	- Handle to the raw input device. This comes from the lParam of the $WM_INPUT message, from 
;                  +hDevice member of $tagRAWINPUTHEADER, or from _GetRawInputDeviceList. It can also be NULL if an application 
;                  +inserts input data, for example, by using SendInput.
;                  $iCommand	- Specifies what data will be returned in pData. It can be one of the following values. 
;                  |$RIDI_PREPARSEDDATA 	- pData points to the previously parsed data.
;                  |$RIDI_DEVICENAME 		- pData points to a string that contains the device name.For this $iCommand only, 
;                  +the value in $iSize is the character count (not the byte count).
;                  |$RIDI_DEVICEINFO		- pData points to an $tagRIDDEVICEINFO_* structure.
;                  $pData		- Pointer to a buffer that contains the information specified by $iCommand. If $iCommand is 
;                  +$RIDI_DEVICEINFO, set cbSize member of $tagRIDDEVICEINFO_* to DllStructGetSize($tagRIDDEVICEINFO_*) before calling 
;                  +_GetRawInputDeviceInfo.
;                  $iSize		- A variable that contains the size, in bytes, of the data in pData
; Return values .: Success	- If successful, this function returns a non-negative number indicating the number of bytes copied to 
;                  +pData. If pData is not large enough for the data, the function returns $__ERROR_MORE_DATA. If pData is NULL, 
;                  +the function returns a value of zero. In both of these cases, $iSize is set to the minimum size required for 
;                  +the pData buffer.
;				   Failure	- Sets @error to 1 and returns 0. Call _WinAPI_GetLastError to identify any other errors.
; Author ........: 
; Modified ......:
; Remarks .......:
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645597%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _GetRawInputDeviceInfo($hDevice, $iCommand, $pData, ByRef $iSize, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'uint', 'GetRawInputDeviceInfoW', 'hwnd', $hDevice, 'uint', $iCommand, 'ptr', $pData, 'uint*', $iSize)
	
	If @error Then Return SetError(1, 0, 0)
	$iSize = $aRet[4]
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRawInputDeviceList
; Description ...: Enumerates the raw input devices attached to the system.
; Syntax ........:  _GetRawInputDeviceList($pRawInputDeviceList, ByRef $iNumDevices, $iSize[, $hDll = 'user32.dll'])
; Parameters ....: $pRawInputDeviceList  - Pointer to buffer that holds an array of $tagRAWINPUTDEVICELIST structures for the
;                  +devices attached to the system. If NULL, the number of devices are returned in $iNumDevices. 
;                  $iNumDevices			 - If pRawInputDeviceList is NULL, the function populates this variable with the number of
;                  +devices attached to the system; otherwise, this variable specifies the number of $tagRAWINPUTDEVICELIST 
;                  +structures that can be contained in the buffer to which $pRawInputDeviceList points. If this value is less
;                  +than the number of devices attached to the system, the function returns the actual number of devices in this 
;                  +variable and fails with $__ERROR_INSUFFICIENT_BUFFER 
;                  $iSize				- Size of a $tagRAWINPUTDEVICELIST structure
; Return values .: Success	- Returns the number of devices stored in the buffer pointed to by $pRawInputDeviceList.
;				   Failure	- Sets @error to 1 and returns $__UINT_ERROR. _WinAPI_GetLastError returns the error indication.
; Author ........: 
; Modified ......:
; Remarks .......: The devices returned from this function are the mouse, the keyboard, and other Human Interface Device (HID) 
;                  +devices. To get more detailed information about the attached devices, call _GetRawInputDeviceInfo using the 
;                  +hDevice from $tagRAWINPUTDEVICELIST.
; Related .......: _GetRawInputDeviceInfo
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645598%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _GetRawInputDeviceList($pRawInputDeviceList, ByRef $iNumDevices, $iSize, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'uint', 'GetRawInputDeviceList', 'ptr', $pRawInputDeviceList, 'uint*', $iNumDevices, 'uint', $iSize)
	If @error Then Return SetError(1, 0, $aRet[0])
	$iNumDevices = $aRet[2]
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _GetRegisteredRawInputDevices
; Description ...: Gets the information about the raw input devices for the current application.
; Syntax ........:  _GetRegisteredRawInputDevices($pRawInputDevices, ByRef $iNumDevices, $iSize[, $hDll = 'user32.dll'])
; Parameters ....: $pRawInputDevices  	- Pointer to an array of $tagRAWINPUTDEVICE structures for the application.
;                  $iNumDevices			- Number of $tagRAWINPUTDEVICE structures in $pRawInputDevices. 
;                  $iSize				- Size, in bytes, of a $tagRAWINPUTDEVICE structure
; Return values .: Success	- Returns a non-negative number that is the number of $tagRAWINPUTDEVICE structures written to the 
;                  +buffer. If the pRawInputDevices buffer is too small or NULL, the function sets the last error as 
;                  +$__ERROR_INSUFFICIENT_BUFFER, returns $__ERROR_MORE_DATA, and sets $iNumDevices to the required number of devices.
;				   Failure	- Sets @error to 1. For more details, call _WinAPI_GetLastError.
; Author ........: 
; Modified ......:
; Remarks .......: To receive raw input from a device, an application must register it by using _RegisterRawInputDevices.
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645598%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _GetRegisteredRawInputDevices($pRawInputDevices, ByRef $iNumDevices, $iSize, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'uint', 'GetRegisteredRawInputDevices', 'ptr', $pRawInputDevices, 'uint*', $iNumDevices, 'uint', $iSize)
	
	If @error Then SetError(1, 0, 0)
	$iNumDevices = $aRet[2]
	Return $aRet[0]
EndFunc

; #FUNCTION# ====================================================================================================================
; Name ..........: _RegisterRawInputDevices
; Description ...: Registers the devices that supply the raw input data.
; Syntax ........:  _RegisterRawInputDevices($pRawInputDevices, $iNumDevices, $iSize[, $hDll = 'user32.dll'])
; Parameters ....: $pRawInputDevices  	- Pointer to an array of $tagRAWINPUTDEVICE structures that represent the devices that 
;                  +supply the raw input.
;                  $iNumDevices			- Number of $tagRAWINPUTDEVICE structures pointed to by $pRawInputDevices.
;                  $iSize				- Size, in bytes, of a $tagRAWINPUTDEVICE structure.
; Return values .: Success	- TRUE
;				   Failure	- Sets @error to 1. Call _WinAPI_GetLastError for more information.
; Author ........: 
; Modified ......:
; Remarks .......: To receive $WM_INPUT messages, an application must first register the raw input devices using 
;                  +_RegisterRawInputDevices. By default, an application does not receive raw input. If a $tagRAWINPUTDEVICE 
;                  +structure has the $RIDEV_REMOVE flag set and the hwndTarget parameter is not set to NULL, then parameter 
;                  +validation will fail. 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/ms645600%28VS.85%29.aspx
; Example .......:
; ===============================================================================================================================
Func _RegisterRawInputDevices($pRawInputDevices, $iNumDevices, $iSize, $hDll = 'user32.dll')
	Local $aRet
	
	$aRet = DllCall($hDll, 'int', 'RegisterRawInputDevices', 'ptr', $pRawInputDevices, 'uint', $iNumDevices, 'uint', $iSize)
	
	If @error Or $aRet[0] = 0 Then SetError(1, 0, 0)
	Return $aRet[0]
EndFunc

#EndRegion FUNCTIONS