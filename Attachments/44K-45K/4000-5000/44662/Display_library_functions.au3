#include <Array.au3>
#Include <GuiListView.au3>
#cs
Description:
	This library is meant for all those people that working within a multi-monitor environment
	are looking for an integrated set of functins capable to change the setting of each monitor
	independently.  Of course the same results (sometimes even better ones) can be achieved when
	dealing with a single screen.
	Lots of people have dir/indirectly contributed to the code. I am happy to share the credit with all
	the community and hope that more people will add their knowledge to make this library even more complete

 Functions:
	_NumberAndNameMonitors  =  	provides basic information about all monitors, included the regkey
	_DisplayKeySettings		= 	generates a basic array with all the key info about each monitor
	_DisplayChangeSettings	=  	allows you to modify monitor res, position, rotation ... and many other options
	_MonitorAndDesktopInfo	=	Key to understand the size of both the desktop as well as the working area
	_DisplayChangeAcceleration	= To change hardware acceleration of each monitor independently
	_ReadGamma				= 	read the gamma setup of your desktop
	_WriteGamma				= 	modify the gamma setup of your desktop color by color
	_ToggleMonitor			= 	switch on off standby all your monitors at the same time
	_MultiMonitorScreenSaver=  	Any screensaver working on only one monitor at the time at your choice
	_SaveDesktopIcons		= 	Save the icons existing all around your desktops
	_RestoreDesktopIcons	=	Restore only those icons on the monitor of your choice

Author(s):        Hermano v1.0 20/12/2007
#ce
; <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< TESTING EXAMPLES
Dim $a[100][100], $c

;$a = _NumberAndNameMonitors()
;$a = _DisplayKeySettings($a, -2)
;_ArrayDisplay($a,"BEFORE")
;a[2][2]=0
;a[2][3]=1
;$a[2][4]=800
;$a[2][5]=600
;$a[2][8]=180
;$c = _DisplayChangeSettings(7,$a,2)
;$a = _MonitorAndDesktopInfo()
;_ArrayDisplay($a,"Monitor")
;_MultiMonitorScreenSaver (2,"ssstars.scr")
;_ToggleMonitor("standby")
;$a= _SaveDesktopIcons(0)
;_ArrayDisplay($a,"icon list")
;_RestoreDesktopIcons(2)
;<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<


;============================================================================================== _NumberAndNameMonitors
; Function Name:  	 _NumberAndNameMonitors ()
; Description:		 Provides the first key elements of a multimonitor system, included the Regedit Keys
; Parameter(s):		 None
; Return Value(s): 	 $NumberAndName [][]
;~ 									[0][0] total number of video devices
;;									[x][1] name of the device
;;									[x][2] name of the adapter
;;									[x][3] monitor flags (value is returned in Hex str -convert in DEC before use with Bitand)
;;									[x][4] registry key of the device
; Remarks:			the flag value [x][3] can be one of the following
;;									DISPLAY_DEVICE_ATTACHED_TO_DESKTOP 	0x00000001
;; 							      	DISPLAY_DEVICE_MULTI_DRIVER        	0x00000002
;;       							DISPLAY_DEVICE_PRIMARY_DEVICE      	0x00000004
;;       							DISPLAY_DEVICE_VGA             		0x00000010
;;		 							DISPLAY_MIRROR_DEVICE 				0X00000008
;;		 							DISPLAY_REMOVABLE					0X00000020
;
; Author(s):        Hermano
;===========================================================================================================================
Func _NumberAndNameMonitors()
	Local $dev = -1, $id = 0, $msg_ = "", $EnumDisplays, $StateFlag
	Dim $NumberAndName[2][6]
	Local $DISPLAY_DEVICE = DllStructCreate("int;char[32];char[128];int;char[128];char[128]")
	DllStructSetData($DISPLAY_DEVICE, 1, DllStructGetSize($DISPLAY_DEVICE))
	Dim $dll = "user32.dll"
	Do
		$dev += 1
		$EnumDisplays = DllCall($dll, "int", "EnumDisplayDevices", "ptr", 0, "int", $dev, "ptr", DllStructGetPtr($DISPLAY_DEVICE), "int", 1)
		If $EnumDisplays[0] <> 0 Then
			ReDim $NumberAndName[$dev + 2][6]
			$NumberAndName[$dev + 1][1] = DllStructGetData($DISPLAY_DEVICE, 2) 	;device Name
			$NumberAndName[$dev + 1][2] = DllStructGetData($DISPLAY_DEVICE, 3) 	;device or display description
			$NumberAndName[$dev + 1][3] = Hex(DllStructGetData($DISPLAY_DEVICE, 4)) 	;all flags (value in HEX)
			$NumberAndName[$dev + 1][4] = DllStructGetData($DISPLAY_DEVICE, 6) 	;registry key of the device
			$NumberAndName[$dev + 1][5] = DllStructGetData($DISPLAY_DEVICE, 5) 	;hardware interface name
		EndIf
	Until $EnumDisplays[0] = 0
	$NumberAndName[0][0] += $dev
	Return $NumberAndName
EndFunc   ;==>_NumberAndNameMonitors
;============================================================================================== _DisplayKeySettings
; Function Name:  	 _DisplayKeySettings($MonName,$Opt = -1)
; Description:		 all key information about each adapter needed to properly change the display setting
; Parameter(s):		 $MonName 	=  	return array from _NumberAndNameMonitors
;;					 $Opt		= -1  $ENUM_CURRENT_SETTINGS [default]
;;								= -2  $ENUM_REGISTRY_SETTINGS
; Return Value(s): 	 $KeySettings[][]
;;										$KeySettings[0][0] = 	Number of non virtual devices
;;										$KeySettings[x][0] = 	Flags
;;										$KeySettings[x][1] = 	Monitor Name
;;										$KeySettings[x][2] =	up left desktop position X
;;										$KeySettings[x][3] =	up left desktop position Y
;;										$KeySettings[x][4] =	Width (resolution)
;;										$KeySettings[x][5] =	Heigth (resolution)
;;										$KeySettings[x][6] =	Bpp color (resolution)
;;										$KeySettings[x][7] =	Screen Refresh(resolution)
;;										$KeySettings[x][8] =	Display Orientation
;;										$KeySettings[x][9] =	Display Fixed Output
; Remarks:
;
; Author(s):        Hermano
;===========================================================================================================================

Func _DisplayKeySettings($MonName, $Opt = -1)
	Local Const $DISPLAY_DEVICE_MIRRORING_DRIVER = 0x00000008
	Dim $KeySettings[1][10], $i, $Dn = 0, $res

	If Not IsArray($MonName) Then $MonName = _NumberAndNameMonitors()
	Local $DEVMODE = DllStructCreate("char[32];short[4];int[5];short[5];byte[32];short;int[6]")
	DllStructSetData($DEVMODE, 2, DllStructGetSize($DEVMODE), 3)

	For $i = 1 To $MonName[0][0]
		If ($MonName[$i][3] <> $DISPLAY_DEVICE_MIRRORING_DRIVER) Then
			$Dn += 1
			$res = DllCall("user32.dll", "int", "EnumDisplaySettings", "str", $MonName[$i][1], "int", $Opt, "ptr", DllStructGetPtr($DEVMODE))
			If $res[0] = 0 Then _
					$res = DllCall("user32.dll", "int", "EnumDisplaySettings", "str", $MonName[$i][1], "int", Mod($Opt, 2) - 1, "ptr", DllStructGetPtr($DEVMODE))

			ReDim $KeySettings[1 + $Dn][10]
			$KeySettings[$Dn][0] = $MonName[$i][3] 	;flags
			$KeySettings[$Dn][1] = $MonName[$i][1] 	;name
			$KeySettings[$Dn][2] = DllStructGetData($DEVMODE, 3, 2) 	;up left desktop position coord X
			$KeySettings[$Dn][3] = DllStructGetData($DEVMODE, 3, 3) 	;up left desktop position coord Y
			$KeySettings[$Dn][4] = DllStructGetData($DEVMODE, 7, 2) 	;Width (resolution)
			$KeySettings[$Dn][5] = DllStructGetData($DEVMODE, 7, 3) 	;Heigth (resolution)
			$KeySettings[$Dn][6] = DllStructGetData($DEVMODE, 7, 1) 	;Bpp color (resolution)
			$KeySettings[$Dn][7] = DllStructGetData($DEVMODE, 7, 5) 	;Screen Refresh(resolution)
			$KeySettings[$Dn][8] = DllStructGetData($DEVMODE, 3, 4) 	;Display Orientation
			$KeySettings[$Dn][9] = DllStructGetData($DEVMODE, 3, 5)  ;fixed output
		EndIf
	Next
	$KeySettings[0][0] = $Dn
	Return $KeySettings
EndFunc   ;==>_DisplayKeySettings
;============================================================================================== _DisplayChangeSettings
; Function Name:    _DisplayChangeSettings ($mode,$KeySettings = 0,$Index = 1)
; Description:    	Modify, rotate, activate and deactivate, move change res to each monitor
;					separately. Do it dynamically or permanently
; Parameter(s):      $mode  		= 1	"Change res Dynamically" temporary changes res, Bpp, refresh Freq
;~ 									= 2 "UpdateReg"	 write new res, pos and other value to regedit
;									= 3	"ChangePrimary"	 in conjunciton with 7 makes possible to change primary monitor
;~ 									= 4	"Pure Reset all screens " 	often used to reset unstable situations
;~									= 5	"Reset ONLY one screen"	 specify screen to be reset
;~ 									= 6	 "change monitor orientation"  0, 90, 180, 270 degrees when supported
;~ 									= 7  "enable disable extended screen" it also switches off the other monitor
;~ 									= 8  "change monitor position" in the virtual video space
;~ 									= 9  "assisted rotation" use irotate to manage most video driver
;~ 									= 99 "Send Hw Message" to all open windows
;~ 					$keysettings    = array with the Modified parameters
;~ 					$Index			= Which monitor listed in $keysettings to modify
; Return Value(s):  				$DISP_CHANGE_RESTART 			= 1
;	  								$DISP_CHANGE_SUCCESSFUL 		= 0
;									$DISP_CHANGE_FAILED          	=-1
;									$DISP_CHANGE_BADMODE         	=-2
;									$DISP_CHANGE_NOTUPDATED      	=-3;problem with registry
;									$DISP_CHANGE_BADPARAM        	=-5
; Remarks:							Not all video cards are the same, not all operating system updates react in the same
;									way to calls as in case 3 or 7 or 9. Testing is needed on a case by case
; Author(s):        Hermano
;===========================================================================================================================
Func _DisplayChangeSettings($mode, $KeySettings = 0, $Index = 1)

	Local Const $DM_BITSPERPEL = 0x00040000
	Local Const $DM_PELSWIDTH = 0x00080000
	Local Const $DM_PELSHEIGHT = 0x00100000
	Local Const $DM_DISPLAYFLAGS = 0x00200000
	Local Const $DM_DISPLAYFREQUENCY = 0x00400000
	Local Const $DM_DISPLAYORIENTATION = 0x00000080 ; XP ONLY
	Local Const $DM_POSITION = 0X00000020
	Local Const $DM_DISPLAYFIXEDOUTPUT = 0X20000000; XP ONLY
	Local Const $DM_ORIENTATION = 0x00000001 ;mainly used for Printers
	;--- input
	Local Const $CDS_PUREDYNAMIC = 0x00000000; graphic mode changed purely dynamically -used to restore
	Local Const $CDS_SET_PRIMARY = 0x00000010; primary screen
	Local Const $CDS_RESET = 0x40000000;force reset
	Local Const $CDS_NORESET = 0x10000000;save registry do not reset
	Local Const $CDS_GLOBAL = 0x00000008;global for all users
	Local Const $CDS_FULLSCREEN = 0x00000004;changes are of a temporary nature
	Local Const $CDS_TEST = 0x00000002; sytem test
	Local Const $CDS_UPDATEREGISTRY = 0x00000001; mode changed and stored in registry
	Local Const $CDS_FORCE = 0X8000000; force frequency changes
	;--- output
	Local Const $DISP_CHANGE_RESTART = 1
	Local Const $DISP_CHANGE_SUCCESSFUL = 0
	Local Const $DISP_CHANGE_FAILED = -1
	Local Const $DISP_CHANGE_BADMODE = -2
	Local Const $DISP_CHANGE_NOTUPDATED = -3;problem with registry
	Local Const $DISP_CHANGE_BADPARAM = -5
	;--- system
	Local Const $HWND_BROADCAST = 0xffff
	Local Const $WM_DISPLAYCHANGE = 0x007E
	;--- variables
	Dim $Opt = -1, $DisplayName = $KeySettings [$Index][1]
	Local $dll = "user32.dll", $Func0 = "ChangeDisplaySettingsEx", $Func1 = "ChangeDisplaySettings", $b
	; --- calling structure
	Local $DEVMODE = DllStructCreate("char[32];short[4];int[5];short[5];byte[32];short;int[6]")
	DllStructSetData($DEVMODE, 2, DllStructGetSize($DEVMODE), 3)

	DllStructSetData($DEVMODE, 7, $KeySettings[$Index][4], 2) 	;w
	DllStructSetData($DEVMODE, 7, $KeySettings[$Index][5], 3) 	;h
	DllStructSetData($DEVMODE, 7, $KeySettings[$Index][6], 1) 	;bpp
	DllStructSetData($DEVMODE, 7, $KeySettings[$Index][7], 5) 	;frep
	DllStructSetData($DEVMODE, 3, $KeySettings[$Index][2], 2) 	;x position of monitor
	DllStructSetData($DEVMODE, 3, $KeySettings[$Index][3], 3) 	;y position of monitor
	If $KeySettings[$Index][8] = 0 Then 	;Display orientation (0,90,180,270)
		DllStructSetData($DEVMODE, 3, 0, 4)
	ElseIf $KeySettings[$Index][8] = 90 Then
		DllStructSetData($DEVMODE, 3, 1, 4)
	ElseIf $KeySettings[$Index][8] = 180 Then
		DllStructSetData($DEVMODE, 3, 2, 4)
	ElseIf $KeySettings[$Index][8] = 270 Then
		DllStructSetData($DEVMODE, 3, 3, 4)
	EndIf

	; --- func main
	If Not IsArray($KeySettings) Then Return $DISP_CHANGE_BADPARAM

	Switch $mode
		Case 1	;"Change res Dynamically"
			DllStructSetData($DEVMODE, 3, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 1)
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_TEST, "int", 0)
			If $b[0] = $DISP_CHANGE_SUCCESSFUL Then _
					$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", BitOR($CDS_PUREDYNAMIC, $CDS_FORCE), "int", 0)

		Case 2 	;"UpdateReg"
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_UPDATEREGISTRY, "int", 0)

		Case 3	;"ChangePrimary"
			DllStructSetData($DEVMODE, 3, 0, 2) ;change x
			DllStructSetData($DEVMODE, 3, 0, 3) ;change y
			DllStructSetData($DEVMODE, 3, BitOR($DM_POSITION, $DM_PELSWIDTH, $DM_PELSHEIGHT), 1)
			;DllStructSetData($DEVMODE, 3, $DM_POSITION, 1)

			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, _
					"ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", BitOR($CDS_SET_PRIMARY, $CDS_NORESET, $CDS_UPDATEREGISTRY), "int", 0)
			DllCall($dll, "int", $Func1, "ptr", 0, "int", $CDS_UPDATEREGISTRY)

		Case 4	;"Pure Reset all screens "
			$b = DllCall($dll, "int", $Func1, "ptr", 0, "int", $CDS_RESET)

		Case 5	;"Reset ONLY one screen"
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", 0, "hwnd", 0, "int", $CDS_RESET, "int", 0)

		Case 6	; change monitor orientation 0, 90, 180, 270 degrees
			DllStructSetData($DEVMODE, 7, $KeySettings[$Index][5], 2)
			DllStructSetData($DEVMODE, 7, $KeySettings[$Index][4], 3)
			DllStructSetData($DEVMODE, 3, BitOR($DM_DISPLAYORIENTATION, $DM_PELSWIDTH, $DM_PELSHEIGHT), 1)
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_TEST, "int", 0)
			If $b[0] = $DISP_CHANGE_SUCCESSFUL Then
				$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", BitOR($CDS_UPDATEREGISTRY, $CDS_NORESET), "int", 0)
				DllCall($dll, "int", $Func1, "ptr", 0, "int", $CDS_UPDATEREGISTRY)
			EndIf

		Case 7  ;enable disable extended screen
			If Mod($KeySettings[$Index][0], 2) <> 0 Then 	;attach.desktop flag high
				DllStructSetData($DEVMODE, 3, BitOR($DM_POSITION, $DM_PELSWIDTH, $DM_PELSHEIGHT), 1) 	;disable
				DllStructSetData($DEVMODE, 7, 0, 2) ;w
				DllStructSetData($DEVMODE, 7, 0, 3) ;h
			Else
				DllStructSetData($DEVMODE, 3, $DM_POSITION, 1) 	;enable
			EndIf
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", BitOR($CDS_UPDATEREGISTRY, $CDS_NORESET), "int", 0)
			DllCall($dll, "int", $Func1, "ptr", 0, "int", $CDS_UPDATEREGISTRY)

			;EndIf
		Case 8  ; change monitor position
			DllStructSetData($DEVMODE, 3, $DM_POSITION, 1)
			$b = DllCall($dll, "int", $Func0, "str", $DisplayName, "ptr", DllStructGetPtr($DEVMODE), "hwnd", 0, "int", $CDS_PUREDYNAMIC, "int", 0)

		Case 9   ;assisted rotation
			;FileInstall("irotate.exe","c:\windows\system32")                 if the library is exported as compiled file
			$b = Run("Irotate.exe /" & String($Index) & ":rotate=" & String($KeySettings[$Index][8]) & " /exit", "", @SW_MINIMIZE)

		Case 99	;"Send Hw Message"
			DllCall($dll, "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, "int", _
					$KeySettings[$Index][6], "int", $KeySettings[$Index][4] * 2 ^ 16 + $KeySettings[$Index][5])

	EndSwitch
	If IsArray($b) Then Return $b[0]
	Return $b
EndFunc   ;==>_DisplayChangeSettings
; ============================================================================================== _MonitorAndDesktopInfo
; Function Name:    _MonitorAndDesktopInfo($KeySettings =0 ,$mode = 2)
; Description:  	All information about working area and/or absolute desktop size and/or default monitor
; Parameter(s):  	$mode  			= 3 	Working area size
;;									= 2 	Absolute Desktop Size  [default]
;;				  	$Keysettings 	= return array from _DisplayKeySettings
; Return Value(s):  $MonitorPos[][]
;;										$MonitorPos[0][0] = 	Number of non virtual monitors
;;										$MonitorPos[x][0] = 	Monitor hardware handle
;										$MonitorPos[x][1] = 	up left 	x
;;										$MonitorPos[x][2] = 	up left 	y
;;										$MonitorPos[x][3] = 	up right  	xx
;;										$MonitorPos[x][4] = 	down right  yy
;;										$MonitorPos[x][5] = 	flags  primary monitor
;;										$MonitorPos[x][6] = 	internal device name
; Remarks:
; Author(s):        Hermano
;===========================================================================================================================
Func _MonitorAndDesktopInfo($KeySettings = 0, $mode = 2)

	Dim $MonitorPos[1][7], $hm, $id = 0
	Local $MONITORINFO = DllStructCreate("int;int[4];int[4];int;char[32]")
	DllStructSetData($MONITORINFO, 1, DllStructGetSize($MONITORINFO))
	; --- load Defaults
	If $KeySettings = 0 Then $KeySettings = _DisplayKeySettings(_NumberAndNameMonitors(), -2)
	If ($mode <> 2) And ($mode <> 3) Then $mode = 2
	; --- core function
	For $i = 1 To $KeySettings[0][0]
		If Mod($KeySettings[$i][0], 2) <> 0 Then						; just to be sure it is a real monitor
	    $hm = DllCall("user32.dll", "hwnd", "MonitorFromPoint", "int", $KeySettings[$i][2], "int", $KeySettings[$i][3], "int", 0) ;handle to monitor that contains point
		If $hm[0] <> 0 Then DllCall("user32.dll", "int", "GetMonitorInfo", "hwnd", $hm[0], "ptr", DllStructGetPtr($MONITORINFO))
		If $hm[0] <> 0 Then
			$id += 1
			ReDim $MonitorPos[$id + 1][7]
			$MonitorPos[$id][0] = $hm[0] ; monitor handle
			$MonitorPos[$id][1] = DllStructGetData($MONITORINFO, $mode, 1);x
			$MonitorPos[$id][2] = DllStructGetData($MONITORINFO, $mode, 2);y
			$MonitorPos[$id][3] = DllStructGetData($MONITORINFO, $mode, 3);xx
			$MonitorPos[$id][4] = DllStructGetData($MONITORINFO, $mode, 4);yy
			$MonitorPos[$id][5] = DllStructGetData($MONITORINFO, 4) ; primary
			$MonitorPos[$id][6] = DllStructGetData($MONITORINFO, 5) ; devicename
		 EndIf
	  EndIf
	Next
	$MonitorPos[0][0] = $id
	Return $MonitorPos
EndFunc   ;==>_MonitorAndDesktopInfo
; =============================================================================================== _DisplayChangeAcceleration
; Description ..:	Change Acceleration of single monitor
; Parameters ...:	$MonName 	  KeySettings array
;					$Index		 	which display needs to be modified
;                   $Apply      - 0 Regedit modified but no screen reset
;~ 								- 1 [Default] Regedit Modified And screen reset
;                 	$Accell	    - Accelleration factor
;~ 									-1 Retrieve existivalue
;~ 									0..5 different levels from high To low
; Return values : Success - True [0..5] current acceleration level
;                 Failure
;~ 							-1 Wrong keysettings[][] index
;~ ;					    -2 Wrong keysettings[][] index
;							-3 Cannot change accel to virtual screen
;							-4 Acceleration level out of range
; Author(s):        Hermano
; ====================================================================================================
Func _DisplayChangeAcceleration($Index, $KeySettings = 0, $Apply = 1, $Accel = -1)
	Dim $RegKey, $c

	If $KeySettings = 0 Then $KeySettings = _DisplayKeySettings(_NumberAndNameMonitors(), -2) ; load defaults
	If $Index = -1 Then Return -1 	; need to specify which monitor
	If $Index > $KeySettings[0][0] Then Return -2 	; element out of range
	If BitAND(Dec($KeySettings[$Index][3]), 8) = 8 Then Return -3 	; This is a virtual screen
	If $Accel < -1 Or $Accel > 5 Then Return -4 	; Acceleration out of Range

	$RegKey = "HKEY_LOCAL_MACHINE\" & StringTrimLeft($KeySettings[$Index][4], StringInStr($KeySettings[$Index][4], '\', 0, 3))
	If RegRead($RegKey, "Device Description") <> $KeySettings[$Index][2] Then Return -5  ;wrong display regedit key
	$CurValue = RegRead($RegKey, "Acceleration.level")

	If $Accel = -1 Then 	;$Accel = -1 return existing value
		If $CurValue = "" Then
			Return 0
		Else
			Return $CurValue
		EndIf
	EndIf
	RegWrite($RegKey, "Acceleration.level", "REG_DWORD", $Accel)
	If $Accel = 0 Then RegDelete($RegKey, "Acceleration.level") 	; speical case full acceleration the key must be erased
	If $Apply = 1 Then $b = DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", 0, "int", 0)
	Return $Accel
EndFunc   ;==>_DisplayChangeAcceleration
;================================================================================================ _ReadGamma
;
; Function Name:    _ReadGamma
; Description:    	read the current gamma configuration and creates the proper
;					WORD structure
; Parameter(s):     $Video 			-DC to video device Defalut = 0
;
; Requirement(s):
; Return Value(s):  Structure to videogamma or int if error
; Author(s):        Hermano
;================================================================================================
Func _ReadGamma($Video = 0)
	Local $a, $Wn
	Local $GAMMA_DATA = DllStructCreate("ushort[256];ushort[256];ushort[256]")

	$a = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $Video)
	$b = DllCall("GDI32.dll", "int", "GetDeviceGammaRamp", "hwnd", $a[0], "ptr", DllStructGetPtr($GAMMA_DATA))
	DllCall("User32.dll", "int", "ReleaseDC", "hwnd", 0, "hwnd", $a[0])
	If $b[0] = 0 Then Return $b[0]
	Return $GAMMA_DATA
EndFunc   ;==>_ReadGamma
;================================================================================================ _WriteGamma
;
; Function Name:    _WriteGamma
; Description:    	Changes the subsystem byte in specified executeable
; Parameter(s):     $R,$G,$B RGB 	-value of gamma variation. 128 is deafault
;									0-128 darker 128-250 brighter
;					$Video 			-DC to video device
;					$FullStruct		-GammaData struct retreived by _ReadGamma
; Requirement(s):
; Return Value(s):  True on Success or sets @error to:
; Author(s):        Hermano
;===============================================================================================
Func _WriteGamma($R = 128, $G = 128, $b = 128, $Video = 0, $FullStruct = 0)
	Local $i, $a, $Wn, $Val
	Dim $M[3][256]
	Local $GAMMA_DATA = DllStructCreate("ushort[256];ushort[256];ushort[256]")

	If $FullStruct = 0 Then $FullStruct = _ReadGamma()
	$a = DllCall("User32.dll", "hwnd", "GetDC", "hwnd", $Video)
	For $i = 1 To 255
		$ValR = $i * ($R + 128)
		$ValG = $i * ($G + 128)
		$ValB = $i * ($b + 128)
		If ($ValR > 65535) Or ($ValG > 65535) Or ($ValB > 65535) Then $Val = 65535
		DllStructSetData($FullStruct, 1, $ValR, $i)
		DllStructSetData($FullStruct, 2, $ValG, $i)
		DllStructSetData($FullStruct, 3, $ValB, $i)
	Next
	$b = DllCall("GDI32.dll", "int", "SetDeviceGammaRamp", "hwnd", $a[0], "ptr", DllStructGetPtr($FullStruct))
	DllCall("User32.dll", "int", "ReleaseDC", "hwnd", 0, "hwnd", $a[0])
	Return $b[0]
EndFunc   ;==>_WriteGamma
;================================================================================================ _ToggleMonitor
;
; Function Name:    _ToggleMonitor
; Description:    	Switches all active screens on and off
; Parameter(s):     'ON' monitors on
;					'OFF' monitors off
;					'STANDBY' monitors standby
; Requirement(s):
; Return Value(s):  True on Success or sets @error to:
; Author(s):        Hermano
;==================================================================================================
Func _ToggleMonitor($OnOff)
	Local $hGUI
	Local Const $WM_SYSCOMMAND = 0x0112
	Local Const $SC_MONITORPOWER = 0xF170
	Local Const $HWND_TOPMOST = -1
	$hGUI = GUICreate("test")
	GUISetState(BitOR(@SW_SHOW, @SW_MINIMIZE))
	If StringUpper($OnOff) = 'OFF' Then
		$OnOff = 2
	ElseIf StringUpper($OnOff) = 'ON' Then
		$OnOff = -1
	ElseIf StringUpper($OnOff) = 'STANDBY' Then
		$OnOff = 1
	EndIf
	BlockInput(1)
	DllCall("user32.dll", "int", "SendMessage", "hwnd", $hGUI, "uint", $WM_SYSCOMMAND, "int", $SC_MONITORPOWER, "int", $OnOff)
	Sleep(1000)
	BlockInput(0)
	If @error Then
		MsgBox(0, "_ToggleMonitor", "_SendMessage Error: " & @error)
		Exit
	EndIf
	GUIDelete($hGUI)
EndFunc   ;==>_ToggleMonitor
;================================================================================================ _MultiMonitorScreenSaver
;; Function Name:   _MultiMonitorScreenSaver ($Index,$Screen_Saver ="",$KeySettings=0)
; Description:    	Allows you to activate a screen saver - FROM FILE - only on one monitor
; Parameter(s):      $Index 		= 0 screensaver on all monitors
;					 				= [1..x] 	monitors chosen
;					$Screen_Saver 	= Name of the .scr file
;					$KeySettings 	= KeySettings array coming from _DisplayKeySettings
; Return Value(s):  = -9 	no screensaver
;					= <0  	Screensaer file not found
; Author(s):        Hermano
;=============================================================================================

Func _MultiMonitorScreenSaver($Index, $Screen_Saver = "", $KeySettings = 0)
	Local $Monitor, $Pid, $test, $Hw

	If $Screen_Saver = "" Then Return -9
	If $KeySettings = 0 Then $KeySettings = _DisplayKeySettings(_NumberAndNameMonitors(), -2)
	$Monitor = _MonitorAndDesktopInfo($KeySettings, 2)

	DllCall("user32.dll", "int", "LockSetForegroundWindow", "uint", 1) ;lock focus to current window
	BlockInput(1)
	$Pid = Run($Screen_Saver & ' /s')
	Sleep(250)
	$Hw = _WinGetHandle($Pid)
	If $Hw < 0 Then Return $Hw
	WinMove($Hw, Default, $Monitor[$Index][1], $Monitor[$Index][2], $Monitor[$Index][3], $Monitor[$Index][4])
	;WinSetState($hw,"",@SW_DISABLE)
	;hide from tray
	DllCall("user32.dll", "int", "LockSetForegroundWindow", "uint", 0) ;unlock focus from current window
	BlockInput(0)
EndFunc   ;==>_MultiMonitorScreenSaver
; ================================================================================================ _SaveDesktopIcons
; Function Name:  _SaveDesktopIcons ($mode = 0)
; Description:    	Save Position and text of all icons on the desktop
; Parameter(s):     $mode 	= 0 default writes the ini file
;							= 1 just returns an array with all Icon Names
;
; Return Value(s):  file DeskIcons.ini in the scriptDirectory
;					$DeskNames[]
;									$DeskNames[0] Total Number of icons
;									$DeskNames[x] Name of each icon
; Author(s):        Hermano
; ==================================================================================================
Func _SaveDesktopIcons($mode = 0)
	Const $IniFile = @ScriptDir & "\" & "DeskIcons.ini"
	Local $Ctrl_h = ControlGetHandle("[CLASS:Progman]", "", "SysListView321")
	Local $NumIcons = _GUICtrlListView_GetItemCount ($Ctrl_h)
	Dim $Txt_Array [$NumIcons + 1]
	Local $i, $ii, $txt, $pos

	For $ii = 0 To $NumIcons - 1
		$txt = _GUICtrlListView_GetItemText ($Ctrl_h, $ii)
		$pos = _GUICtrlListView_GetItemPosition ($Ctrl_h, $ii)
		If $mode = 0 Then _
			IniWrite($IniFile, "DeskIcons", $txt, String($pos[0]) & "," & String($pos[1]))
		$Txt_Array [$ii + 1] = $txt
	Next
	$Txt_Array[0] = $NumIcons
	Beep(40,100)
	Return $Txt_Array
EndFunc   ;==>_SaveDesktopIcons
; ================================================================================================ _RestoreDesktopIcons
; Function Name:	_RestoreDesktopIcons($Index = -1 , $keySettings = 0)
; Description:    	Save Position and text of all icons on the desktop;
;~ Parameter(s):     $Index			=  x Identifies the monitor where we will restore the icons
;~ 									= -1 restores all existing icons position
;					$KeySettings 	= Array produced by _DisplayKeySettings()
;
; Return Value(s):  = -1 the Icons setting file does not exists
;~ 					= -2 the Monitor ($Index) does not exists
; Author(s):        Hermano
; ==================================================================================================

Func _RestoreDesktopIcons($Index = -1, $KeySettings = 0)
	Const $IniFile = @ScriptDir & "\" & "DeskIcons.ini"
	If FileOpen($IniFile, 0) = -1 Then Return -1 	; -1 The DeskIcons.ini file does not exist
	Local $Ctrl_h = ControlGetHandle("[CLASS:Progman]", "", "SysListView321")
	Local $NameList = _SaveDesktopIcons(1) 	 ;obtain a list of the currently EXISTING icons
	Local $x = 0, $x1 = 0, $y = 0, $y1 = 9999, $pos

	If $Index > 0 Then
		If $KeySettings = 0 Then $KeySettings = _DisplayKeySettings(_NumberAndNameMonitors(), -2)
		Local $Monitor = _MonitorAndDesktopInfo($KeySettings, 2)
		If $Index < $Monitor[0][0] + 1 Then 	;set boundaries
			$x = $Monitor[$Index][1]
			$y = $Monitor[$Index][2]
			$x1 = $Monitor[$Index][3]
			$y1 = $Monitor[$Index][4]
		Else
			Return -2
		EndIf
	EndIf

	For $i = 0 To ($NameList[0] - 1)
		$pos = StringSplit(IniRead($IniFile, "DeskIcons", $NameList[$i+1], ""), ",") 	;compare with SAVED icons
		If IsArray($pos) Then
			If $y1 <> 9999 Then
				If (Number($pos[1]) > $x And Number($pos[1]) < $x1) And Number($pos[2]) > $y And Number($pos[2]) < $y1 Then _
					_GUICtrlListView_SetItemPosition ($Ctrl_h, $i, Number($pos[1]), Number($pos[2])) ; update monitor icons
			Else
				_GUICtrlListView_SetItemPosition ($Ctrl_h, $i, Number($pos[1]), Number($pos[2])) ; update ALL icons
			EndIf
		EndIf
	Next
	ControlSend($Ctrl_h, Default, Default, "{F5}")
EndFunc   ;==>_RestoreDesktopIcons

;;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ support functions
;++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
;================================================================================================== _WinGetHandle
;
; Function Name:    _WinGetHandle
; Description:    	retrieves handle from PID
; Parameter(s):      PID
; Return Value(s):   -1 no such a window
;					-2 wrong input paramenter
;					Hwd window handle
; Author(s):        Hermano
;===============================================================================

Func _WinGetHandle($Pid)
	If IsNumber($Pid) = 0 Then Return -2

	Local $WinList = WinList()
	Local $i = 1, $WindowTitle = "", $WindowHandle = ""
	Opt("WinSearchChildren", 1)

	While $i <= $WinList[0][0] And $WindowHandle = ""
		If WinGetProcess($WinList[$i][0], "") = $Pid Then
			$WindowTitle = $WinList[$i][0]
			$WindowHandle = WinGetHandle($WindowTitle)
		Else
			$i = $i + 1
		EndIf
	WEnd
	If $WindowHandle = "" Then Return -1
	Return $WindowHandle
EndFunc   ;==>_WinGetHandle
;==================================================================================================== DEBUG FUNCTIONS _OO
;
; Function Name:    _oo
; Description:    	Debugging function. evoluted consolewrite
; Return Value(s):  console write of command line
; Author(s):        Hermano
;===============================================================================
Func _oo($Input, $Inp1 = 0, $Inp2 = 0, $Inp3 = 0, $Inp4 = 0, $Inp5 = 0, $Inp6 = 0, $Inp7 = 0, $Inp8 = 0, $Inp9 = 0, $Inp10 = 0)
	Dim $str, $i, $Output = "", $param
	$str = StringSplit($Input, ";") 	; "giovanni;e ; un ; cavolo",$l,$s,$s)
	For $i = 1 To $str[0] - 1
		$param = String(Eval("Inp" & String($i)))
		$Output = $Output & $str[$i] & $param
	Next
	ConsoleWrite($Output & @CR)
EndFunc   ;==>_oo