#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include-once
#include <WinAPI.au3>

; #INDEX# =======================================================================================================================
; Title .........: DeviceAPI Alpha Preview 6
; AutoIt Version: 3.3.4.0
; Language:       English
; Description ...: Device management wrapper for setupapi.dll and cfgmgr32.dll, the basis of Devcon
; Author ........: Matthew Horn (weaponx)
; ===============================================================================================================================

Global $setupapi_dll = "setupapi.dll"
Global $cfgmgr32_dll = "cfgmgr32.dll"

; #CONSTANTS# ===================================================================================================================
Global Const $DIGCF_DEFAULT = 0x00000001 ;// only valid with DIGCF_DEVICEINTERFACE
Global Const $DIGCF_PRESENT = 0x00000002
Global Const $DIGCF_ALLCLASSES = 0x00000004
Global Const $DIGCF_PROFILE = 0x00000008
Global Const $DIGCF_DEVICEINTERFACE = 0x00000010

Global Const $SPDRP_DEVICEDESC = 0x00000000 ;// DeviceDesc R/W
Global Const $SPDRP_HARDWAREID = 0x00000001 ;// HardwareID R/W
Global Const $SPDRP_COMPATIBLEIDS = 0x00000002 ;// CompatibleIDs R/W
Global Const $SPDRP_UNUSED0 = 0x00000003 ;// unused
Global Const $SPDRP_SERVICE = 0x00000004 ;// Service R/W
Global Const $SPDRP_UNUSED1 = 0x00000005 ;// unused
Global Const $SPDRP_UNUSED2 = 0x00000006 ;// unused
Global Const $SPDRP_CLASS = 0x00000007 ;// Class R--tied to ClassGUID
Global Const $SPDRP_CLASSGUID = 0x00000008 ;// ClassGUID R/W
Global Const $SPDRP_DRIVER = 0x00000009 ;// Driver R/W
Global Const $SPDRP_CONFIGFLAGS = 0x0000000A ;// ConfigFlags R/W
Global Const $SPDRP_MFG = 0x0000000B ;// Mfg R/W
Global Const $SPDRP_FRIENDLYNAME = 0x0000000C ;// FriendlyName R/W
Global Const $SPDRP_LOCATION_INFORMATION = 0x0000000D ;// LocationInformation R/W
Global Const $SPDRP_PHYSICAL_DEVICE_OBJECT_NAME = 0x0000000E ;// PhysicalDeviceObjectName R
Global Const $SPDRP_CAPABILITIES = 0x0000000F ;// Capabilities R
Global Const $SPDRP_UI_NUMBER = 0x00000010 ;// UiNumber R
Global Const $SPDRP_UPPERFILTERS = 0x00000011 ;// UpperFilters R/W
Global Const $SPDRP_LOWERFILTERS = 0x00000012 ;// LowerFilters R/W
Global Const $SPDRP_BUSTYPEGUID = 0x00000013 ;// BusTypeGUID R
Global Const $SPDRP_LEGACYBUSTYPE = 0x00000014 ;// LegacyBusType R
Global Const $SPDRP_BUSNUMBER = 0x00000015 ;// BusNumber R
Global Const $SPDRP_ENUMERATOR_NAME = 0x00000016 ;// Enumerator Name R
Global Const $SPDRP_SECURITY = 0x00000017 ;// Security R/W, binary form
Global Const $SPDRP_SECURITY_SDS = 0x00000018 ;// Security W, SDS form
Global Const $SPDRP_DEVTYPE = 0x00000019 ;// Device Type R/W
Global Const $SPDRP_EXCLUSIVE = 0x0000001A ;// Device is exclusive-access R/W
Global Const $SPDRP_CHARACTERISTICS = 0x0000001B ;// Device Characteristics R/W
Global Const $SPDRP_ADDRESS = 0x0000001C ;// Device Address R
Global Const $SPDRP_UI_NUMBER_DESC_FORMAT = 0X0000001D ;// UiNumberDescFormat R/W
Global Const $SPDRP_DEVICE_POWER_DATA = 0x0000001E ;// Device Power Data R
Global Const $SPDRP_REMOVAL_POLICY = 0x0000001F ;// Removal Policy R
Global Const $SPDRP_REMOVAL_POLICY_HW_DEFAULT = 0x00000020 ;// Hardware Removal Policy R
Global Const $SPDRP_REMOVAL_POLICY_OVERRIDE = 0x00000021 ;// Removal Policy Override RW
Global Const $SPDRP_INSTALL_STATE = 0x00000022 ;// Device Install State R
Global Const $SPDRP_LOCATION_PATHS = 0x00000023 ;// Device Location Paths R
Global Const $SPDRP_MAXIMUM_PROPERTY = 0x00000024 ;// Upper bound on ordinals'

Global Const $DIBCI_NOINSTALLCLASS = 0x00000001
Global Const $DIBCI_NODISPLAYCLASS = 0x00000002

;Global Const $tagSP_DEVINFO_DATA = "DWORD cbSize; " & "int Data1;ushort Data2;ushort Data3;byte Data4[8];" & " DWORD DevInst; INT_PTR Reserved"

Global Const $tagSP_DEVINFO_DATA = "DWORD cbSize; " & $tagGUID & "; DWORD DevInst; INT_PTR Reserved"

Global Const $MAX_PATH = 256
Global Const $MAX_CLASS_NAME_LEN = 32

; #GLOBALS# ===================================================================================================================
Global $hDevInfo = ""

Global $aGUID = 0 ;Handle to GUID array structure
Global $paGUID = DllStructGetPtr($aGUID) ;Pointer to GUID array structure
Global $p_currentGUID = 0 ;Pointer to specific element in GUID array structure

;Create an SP_DEVINFO_DATA structure
Global $DEVINFO_DATA = _DeviceAPI_CreateDeviceDataStruct()
Global $pSP_DEVINFO_DATA = DllStructGetPtr($DEVINFO_DATA) ;Get pointer to previous structure

;Create SP_CLASSIMAGELIST_DATA structure
Global $SP_CLASSIMAGELIST_DATA = _DeviceAPI_CreateClassImageListStruct()
Global $pSP_CLASSIMAGELIST_DATA = DllStructGetPtr($SP_CLASSIMAGELIST_DATA) ;Get pointer to previous structure

Global $iEnumClassInfoCursor = 0
Global $iEnumDeviceInfoCursor = 0

;Populate Image List (cost ~32 ms)
;_DeviceAPI_CreateClassImageList()

; #CURRENT# =====================================================================================================================

; _DeviceAPI_Close
; _DeviceAPI_CreateClassImageList
; _DeviceAPI_CreateClassImageListStruct
; _DeviceAPI_CreateDeviceDataStruct
; _DeviceAPI_DestroyClassImageList
; _DeviceAPI_DestroyDeviceInfoList
; _DeviceAPI_EnumClasses
; _DeviceAPI_EnumDevices
; _DeviceAPI_GetClassArray
; _DeviceAPI_GetClassCount
; _DeviceAPI_GetClassDescription
; _DeviceAPI_GetClassDevices
; _DeviceAPI_GetClasses
; _DeviceAPI_GetClassImageIndex
; _DeviceAPI_GetClassImageList
; _DeviceAPI_GetClassName
; _DeviceAPI_GetDeviceArray
; _DeviceAPI_GetDeviceCount
; _DeviceAPI_GetDeviceId
; _DeviceAPI_GetDeviceRegistryProperty
; _DeviceAPI_Open

;==============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_Close
; Description ...: [OPTIONAL] Close handle to setupapi.dll and cfgmgr32.dll
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - True
;                  Failure      - False, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: _DeviceAPI_Open
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_Close()
	;Close handle to setupapi.dll
	DllClose($setupapi_dll)
	If @error Then Return SetError(@error, @extended, False)

	DllClose($cfgmgr32_dll)
	If @error Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_DeviceAPI_Close

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_CreateClassImageList
; Description ...: Populate SP_CLASSIMAGELIST_DATA
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: _DeviceAPI_CreateClassImageListStruct,_DeviceAPI_DestroyClassImageList
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792987.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_CreateClassImageList()

	Local $result = DllCall($setupapi_dll, "int", "SetupDiGetClassImageList", "ptr", $pSP_CLASSIMAGELIST_DATA)
	If @error Then
		Return SetError(@error, @extended, False)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 0, False)
		Else
			Return True
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_CreateClassImageList

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_CreateClassImageListStruct
; Description ...: ;Create an SP_CLASSIMAGELIST_DATA structure (for treeview)
; Syntax.........: _DeviceAPI_CreateClassImageListStruct()
; Parameters ....: -
; Return values .: Success      - Dll struct (NOT pointer)
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792998.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_CreateClassImageListStruct()
	Local $tSP_CLASSIMAGELIST_DATA = DllStructCreate("DWORD  cbSize;HWND  ImageList;DWORD  Reserved;")
	If @error Then Return SetError(@error, @extended, 0)
	DllStructSetData($tSP_CLASSIMAGELIST_DATA, "cbsize", DllStructGetSize($tSP_CLASSIMAGELIST_DATA))

	Return $tSP_CLASSIMAGELIST_DATA
EndFunc   ;==>_DeviceAPI_CreateClassImageListStruct

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_CreateDeviceDataStruct
; Description ...: Create an SP_DEVINFO_DATA structure
; Syntax.........: _DeviceAPI_CreateDeviceDataStruct()
; Parameters ....: -
; Return values .: Success      - SP_DEVINFO_DATA struct (NOT pointer)
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792997.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_CreateDeviceDataStruct()
	;Defines a device instance that is a member of a device information set.
	Local $hSP_DEVINFO_DATA = DllStructCreate($tagSP_DEVINFO_DATA)
	If @error Then Return SetError(@error, @extended, 0)

	;Store structure size, this will be verified internally by functions using it
	DllStructSetData($hSP_DEVINFO_DATA, "cbSize", DllStructGetSize($hSP_DEVINFO_DATA))

	Return $hSP_DEVINFO_DATA
EndFunc   ;==>_DeviceAPI_CreateDeviceDataStruct

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_DeleteDeviceInfo
; Description ...: -
; Syntax.........: _DeviceAPI_GetClassName($pGUID)
; Parameters ....: $pGUID - Pointer to GUID struct
; Return values .: Success      - String
;                  Failure      - NULL String, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792972.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_DeleteDeviceInfo()
	Local $result = DllCall($setupapi_dll, "int", "SetupDiDeleteDeviceInfo", "hwnd", $hDevInfo, "ptr", $pSP_DEVINFO_DATA)
	If @error Then Return SetError(@error, @extended, "")
	Return $result[0]
EndFunc   ;==>_DeviceAPI_DeleteDeviceInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_DestroyClassImageList
; Description ...: Destroy SP_CLASSIMAGELIST_DATA
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - True
;                  Failure      - False, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: _DeviceAPI_CreateClassImageList
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms791240.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_DestroyClassImageList()

	Local $result = DllCall($setupapi_dll, "int", "SetupDiDestroyClassImageList", "ptr", $pSP_CLASSIMAGELIST_DATA)
	If @error Then
		Return SetError(@error, @extended, False)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, False)
		Else
			Return True
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_DestroyClassImageList

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_DestroyDeviceInfoList
; Description ...: Destroy handle to a device info list
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - True
;                  Failure      - False, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: _DeviceAPI_CreateDeviceInfoList
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792991.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_DestroyDeviceInfoList()
	;Check global variable
	If $hDevInfo <> "" Then
		;Destroys a handle to a device information set that contains requested device information elements for a local machine
		Local $result = DllCall($setupapi_dll, "int", "SetupDiDestroyDeviceInfoList", "hwnd", $hDevInfo)
		If @error Then
			Return SetError(1, 0, False)
		Else
			;Check for WinAPI error
			$WinAPI_Error = _WinAPI_GetLastError()
			If $WinAPI_Error <> 0 Then
				Return SetError(2, 0, False)
			Else
				Return SetError(0, 0, $result[0]) ;Success
			EndIf
		EndIf
	Else
		Return SetError(0, 0, 1) ;Success
	EndIf
EndFunc   ;==>_DeviceAPI_DestroyDeviceInfoList

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_EnumClasses
; Description ...: -
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_EnumClasses()
	Local $sizeofGUID = 16 ;Number of bytes in GUID struct
	Local $num_elements = DllStructGetSize($aGUID) / $sizeofGUID

	If $iEnumClassInfoCursor > ($num_elements - 1) Then
		Return False
	EndIf

	;Update global pointer to current class GUID
	$p_currentGUID = $paGUID + ($sizeofGUID * $iEnumClassInfoCursor)

	$iEnumClassInfoCursor += 1
	Return True
EndFunc   ;==>_DeviceAPI_EnumClasses

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_EnumDevices
; Description ...: Populate SP_DEVINFO_DATA structure
; Syntax.........: _DeviceAPI_EnumDevices($hDevInfo, $iIndex, $pSP_DEVINFO_DATA)
; Parameters ....: $hDevInfo         - Handle to device information set (i.e. _DeviceAPI_GetClassDevices)
;                  $iIndex           - Integer index of element to retrieve
;                  $pSP_DEVINFO_DATA - Pointer to SP_DEVINFO_DATA struct
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792983.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_EnumDevices()
	;Returns a SP_DEVINFO_DATA structure that specifies a device information element in a device information set.
	Local $result = DllCall($setupapi_dll, "int", "SetupDiEnumDeviceInfo", "hwnd", $hDevInfo, "long", $iEnumDeviceInfoCursor, "ptr", $pSP_DEVINFO_DATA)
	If @error Then
		Return SetError(@error, @extended, False)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			$iEnumDeviceInfoCursor = 0 ;Reset cursor
			Return SetError(1, 1, False)
		Else
			$iEnumDeviceInfoCursor += 1
			Return $result[0]
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_EnumDevices

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetAllDevices
; Description ...: Returns a handle to a device information set that contains requested device information elements for a local machine
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - Handle to a device information set
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: Call _DeviceAPI_DestroyDeviceInfoList to destroy the handle returned by this function
; Related .......: _DeviceAPI_DestroyDeviceInfoList
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792959.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetAllDevices()

	;If no pointer is supplied, retrieve all devices
	Local $iFlags = BitOR($DIGCF_PRESENT, $DIGCF_ALLCLASSES, $DIGCF_PROFILE)

	Local $result = DllCall($setupapi_dll, "hwnd", "SetupDiGetClassDevs", "ptr", 0, "ptr", 0, "hwnd", 0, "dword", $iFlags)
	If @error Then
		Return SetError(@error, @extended, 0)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, 0)
		Else
			;Debug($result)
			;Return $result[0]
			$hDevInfo = $result[0] ;Update global variable
			$iEnumDeviceInfoCursor = 0 ;Reset device enumeration position
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetAllDevices

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassArray
; Description ...: Return 2 dimensional array of device class GUID's and descriptions
; Syntax.........: _DeviceAPI_ClassArray($iExclude = 0)
; Parameters ....: $iExclude - Integer
; Return values .: Success      - Array containing string representation of device class GUID's and class descriptions
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassArray()
	;Retrieve count of device classes
	Local $Class_Count = _DeviceAPI_GetClassCount()

	;Declare array which will be returned
	Local $aArray[$Class_Count][3]

	_DeviceAPI_GetClasses()
	$enum = 0
	While _DeviceAPI_EnumClasses()
		$aArray[$enum][0] = _WinAPI_StringFromGUID($p_currentGUID)
		$aArray[$enum][1] = _DeviceAPI_GetClassName($p_currentGUID) ;Short name
		$aArray[$enum][2] = _DeviceAPI_GetClassDescription($p_currentGUID) ;Long name
		$enum += 1
	WEnd
	_DeviceAPI_DestroyDeviceInfoList() ;Cleanup for good measure

	Return $aArray
EndFunc   ;==>_DeviceAPI_GetClassArray

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassCount
; Description ...: Retrieve count of device classes (not count of devices)
; Syntax.........: _DeviceAPI_GetClassCount()
; Parameters ....: -
; Return values .: Success      - Count of ALL device classes
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: WinAPI error given even upon success
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms791245.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassCount()
	;Retrieve count of device classes
	Local $result = DllCall($setupapi_dll, "int", "SetupDiBuildClassInfoList", "dword", 0, "ptr", 0, "dword", 0, "dword*", 0) ;Return class count
	If @error Then Return SetError(@error, @extended, 0)
	;Debug($result)
	Return $result[4]
EndFunc   ;==>_DeviceAPI_GetClassCount

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassDescription
; Description ...: Return text description of device class
; Syntax.........: _DeviceAPI_GetClassDescription($pGUID)
; Parameters ....: $pGUID - Pointer to GUID struct
; Return values .: Success      - Text description of device class
;                  Failure      - NULL String, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792960.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassDescription($pGUID)
	Local $result = DllCall($setupapi_dll, "int", "SetupDiGetClassDescription", "ptr", $pGUID, "str", "", "dword", $MAX_PATH, "ptr", 0)
	If @error Then
		Return SetError(@error, @extended, "")
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, "")
		Else
			Return $result[2]
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetClassDescription

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassDevices
; Description ...: Returns a handle to a device information set that contains requested device information elements for a local machine
; Syntax.........: _DeviceAPI_GetClassDevices($pGUID = 0)
; Parameters ....: $pGUID - Pointer to GUID struct
; Return values .: Success      - Handle to a device information set
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: Call _DeviceAPI_DestroyDeviceInfoList to destroy the handle returned by this function
; Related .......: _DeviceAPI_DestroyDeviceInfoList
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792959.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassDevices($pGUID = 0)

	;Accept GUID as a string
	If IsString($pGUID) Then
		Local $GUID = _WinAPI_GUIDFromString($pGUID)
		$pGUID = DllStructGetPtr($GUID)
	EndIf

	;If no pointer is supplied, retrieve all devices
	Local $iFlags = BitOR($DIGCF_PRESENT, $DIGCF_ALLCLASSES, $DIGCF_PROFILE)

	;If pointer is supplied, only retrieve devices applicable to guid
	If $pGUID <> 0 Then $iFlags = $DIGCF_PRESENT

	Local $result = DllCall($setupapi_dll, "hwnd", "SetupDiGetClassDevs", "ptr", $pGUID, "ptr", 0, "hwnd", 0, "dword", $iFlags)
	If @error Then
		Return SetError(@error, @extended, 0)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, 0)
		Else
			;Debug($result)
			;Return $result[0]
			$hDevInfo = $result[0] ;Update global variable
			$iEnumDeviceInfoCursor = 0 ;Reset device enumeration position
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetClassDevices

Func _DeviceAPI_GetClasses()
	;Retrieve count of device classes
	Local $Class_Count = _DeviceAPI_GetClassCount()

	Local $tagGUID_ARRAY = ""
	For $X = 1 To $Class_Count
		$tagGUID_ARRAY &= $tagGUID & ";"
	Next

	;Create structure containing array of pointers to GUID structures
	$aGUID = DllStructCreate($tagGUID_ARRAY)
	$paGUID = DllStructGetPtr($aGUID)

	;Populate structure with GUID's of all device classes
	Local $result = DllCall($setupapi_dll, "int", "SetupDiBuildClassInfoList", "dword", 0, "ptr", $paGUID, "dword", $Class_Count, "dword*", 0) ;Populate array with GUID's
	If @error Then
		SetError(@error, @extended, 0)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			ConsoleWrite("Error " & _WinAPI_GetLastError() & ": " & _WinAPI_GetLastErrorMessage())
			;Exit
			Return SetError(1, 1, 0)
		Else
			;Debug($result)
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetClasses

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassImageIndex
; Description ...: Get icon index from image list for given class
; Syntax.........: _DeviceAPI_GetClassImageIndex($pSP_CLASSIMAGELIST_DATA, $pGUID)
; Parameters ....: $pSP_CLASSIMAGELIST_DATA - Pointer to SP_CLASSIMAGELIST_DATA
;                  $pGUID                   - Pointer to GUID struct
; Return values .: Success      - Image index for given class
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792947.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassImageIndex($pGUID)

	;Accept GUID as a string
	If IsString($pGUID) Then
		Local $GUID = _WinAPI_GUIDFromString($pGUID)
		$pGUID = DllStructGetPtr($GUID)
	EndIf

	Local $result = DllCall($setupapi_dll, "int", "SetupDiGetClassImageIndex", "ptr", $pSP_CLASSIMAGELIST_DATA, "ptr", $pGUID, "int*", 0)
	If @error Then
		Return SetError(@error, @extended, 0)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, 0)
		Else
			Return $result[3]
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetClassImageIndex

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassImageList
; Description ...: Retrieve handle to class image list
; Syntax.........: -
; Parameters ....: -
;                  $pGUID                   - Pointer to GUID struct
; Return values .: Success      - Image index for given class
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassImageList()
	_DeviceAPI_CreateClassImageList()
	Return DllStructGetData($SP_CLASSIMAGELIST_DATA, "ImageList")
EndFunc   ;==>_DeviceAPI_GetClassImageList

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetClassName
; Description ...: Get class name from class GUID
; Syntax.........: _DeviceAPI_GetClassName($pGUID)
; Parameters ....: $pGUID - Pointer to GUID struct
; Return values .: Success      - String
;                  Failure      - NULL String, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792972.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetClassName($pGUID = 0)
	;Accept GUID as a string
	If IsString($pGUID) Then
		Local $GUID = _WinAPI_GUIDFromString($pGUID)
		$pGUID = DllStructGetPtr($GUID)
	EndIf

	#cs
		If $pGUID = 0 Then
		$pGUID = DllStructGetPtr($DEVINFO_DATA,2)
		If $pGUID = 0 Then
		$pGUID = $p_currentGUID
		EndIf
		EndIf
	#ce

	Local $result = DllCall($setupapi_dll, "int", "SetupDiClassNameFromGuid", "ptr", $pGUID, "str", "", "dword", $MAX_CLASS_NAME_LEN, "dword*", 0)
	If @error Then Return SetError(@error, @extended, "")
	Return $result[2]
EndFunc   ;==>_DeviceAPI_GetClassName

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetDeviceArray
; Description ...: Return array of device names for a given class
; Syntax.........: _DeviceAPI_GetDeviceArray($pGUID = 0)
; Parameters ....: $pGUID - Pointer to GUID struct
; Return values .: Success      - Array containing names of all devices in given class
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: If no class is given all devices will be retrieved
; Related .......: -
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
;Currently for debug only
Func _DeviceAPI_GetDeviceArray($pGUID = 0)

	;Create device info list
	_DeviceAPI_GetClassDevices($pGUID)

	;Count devices within class
	Local $Count = _DeviceAPI_GetDeviceCount()
	;ConsoleWrite("Count: " & $Count & @CRLF)

	If $Count = 0 Then Return SetError(1, 0, 0)

	Local $aArray[$Count][2]

	$Count = 0

	;Loop through all devices by index
	While _DeviceAPI_EnumDevices()

		$aArray[$Count][0] = _DeviceAPI_GetDeviceId()
		$aArray[$Count][1] = _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DEVICEDESC)

		$Count += 1
	WEnd

	Return $aArray
EndFunc   ;==>_DeviceAPI_GetDeviceArray

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetDeviceCount
; Description ...: Retrieve count of devices
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - Count of devices in current class
;                  Failure      - 0, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: WinAPI error given even upon success
; Related .......: -
; Link ..........; -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetDeviceCount()
	;Save device enumeration cursor position
	$backup = $iEnumDeviceInfoCursor

	;Start from beginning
	$iEnumDeviceInfoCursor = 0

	;Count devices within class
	Local $iCount = 0

	While _DeviceAPI_EnumDevices()
		$iCount += 1
	WEnd

	;Restore original cursor position
	$iEnumDeviceInfoCursor = $backup

	Return $iCount
EndFunc   ;==>_DeviceAPI_GetDeviceCount

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetDeviceId
; Description ...: Get class name from class GUID
; Syntax.........: -
; Parameters ....: -
; Return values .: Success      - String
;                  Failure      - NULL String, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792990.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetDeviceId()
	Local $result = DllCall($setupapi_dll, "int", "SetupDiGetDeviceInstanceId", "hwnd", $hDevInfo, "ptr", $pSP_DEVINFO_DATA, "str", "", "dword", 512, "dword", 0)
	If @error Then
		Return SetError(@error, @extended, "")
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			;ConsoleWrite("Error " & _WinAPI_GetLastError() & ": " & _WinAPI_GetLastErrorMessage())
			;Exit
			Return SetError(1, 1, 0)
		Else
			;Debug($result)
			Return $result[3]
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetDeviceId

Func _DeviceAPI_GetDeviceId2()
	;Retrieve device instance handle
	Local $DevInst = DllStructGetData($DEVINFO_DATA, "DevInst")
	Local $result = DllCall($cfgmgr32_dll, "int", "CM_Get_Device_ID", "int", $DevInst, "str", "", "ulong", 512, "ulong", 0)
	If @error Then Return SetError(@error, @extended, "")
	Return $result[2]
EndFunc   ;==>_DeviceAPI_GetDeviceId2

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_GetDeviceRegistryProperty
; Description ...: Retrieve device property from registry
; Syntax.........: _DeviceAPI_GetDeviceRegistryProperty($hDevInfo, $pSP_DEVINFO_DATA, $iProperty)
; Parameters ....: $hDevInfo                          - Handle to device information set (i.e. _DeviceAPI_GetClassDevices)
;                  $pSP_DEVINFO_DATA                  - Pointer to SP_DEVINFO_DATA struct
;                  $iProperty                         - Dword representation of desired property
;                  |$SPDRP_DEVICEDESC                 = 0x00000000  ;// DeviceDesc R/W
;                  |$SPDRP_HARDWAREID                 = 0x00000001  ;// HardwareID R/W
;                  |$SPDRP_COMPATIBLEIDS              = 0x00000002  ;// CompatibleIDs R/W
;                  |$SPDRP_UNUSED0                    = 0x00000003  ;// unused
;                  |$SPDRP_SERVICE                    = 0x00000004  ;// Service R/W
;                  |$SPDRP_UNUSED1                    = 0x00000005  ;// unused
;                  |$SPDRP_UNUSED2                    = 0x00000006  ;// unused
;                  |$SPDRP_CLASS                      = 0x00000007  ;// Class R--tied to ClassGUID
;                  |$SPDRP_CLASSGUID                  = 0x00000008  ;// ClassGUID R/W
;                  |$SPDRP_DRIVER                     = 0x00000009  ;// Driver R/W
;                  |$SPDRP_CONFIGFLAGS                = 0x0000000A  ;// ConfigFlags R/W
;                  |$SPDRP_MFG                        = 0x0000000B  ;// Mfg R/W
;                  |$SPDRP_FRIENDLYNAME               = 0x0000000C  ;// FriendlyName R/W
;                  |$SPDRP_LOCATION_INFORMATION       = 0x0000000D  ;// LocationInformation R/W
;                  |$SPDRP_PHYSICAL_DEVICE_OBJECT_NAME= 0x0000000E  ;// PhysicalDeviceObjectName R
;                  |$SPDRP_CAPABILITIES               = 0x0000000F  ;// Capabilities R
;                  |$SPDRP_UI_NUMBER                  = 0x00000010  ;// UiNumber R
;                  |$SPDRP_UPPERFILTERS               = 0x00000011  ;// UpperFilters R/W
;                  |$SPDRP_LOWERFILTERS               = 0x00000012  ;// LowerFilters R/W
;                  |$SPDRP_BUSTYPEGUID                = 0x00000013  ;// BusTypeGUID R
;                  |$SPDRP_LEGACYBUSTYPE              = 0x00000014  ;// LegacyBusType R
;                  |$SPDRP_BUSNUMBER                  = 0x00000015  ;// BusNumber R
;                  |$SPDRP_ENUMERATOR_NAME            = 0x00000016  ;// Enumerator Name R
;                  |$SPDRP_SECURITY                   = 0x00000017  ;// Security R/W, binary form
;                  |$SPDRP_SECURITY_SDS               = 0x00000018  ;// Security W, SDS form
;                  |$SPDRP_DEVTYPE                    = 0x00000019  ;// Device Type R/W
;                  |$SPDRP_EXCLUSIVE                  = 0x0000001A  ;// Device is exclusive-access R/W
;                  |$SPDRP_CHARACTERISTICS            = 0x0000001B  ;// Device Characteristics R/W
;                  |$SPDRP_ADDRESS                    = 0x0000001C  ;// Device Address R
;                  |$SPDRP_UI_NUMBER_DESC_FORMAT      = 0X0000001D  ;// UiNumberDescFormat R/W
;                  |$SPDRP_DEVICE_POWER_DATA          = 0x0000001E  ;// Device Power Data R
;                  |$SPDRP_REMOVAL_POLICY             = 0x0000001F  ;// Removal Policy R
;                  |$SPDRP_REMOVAL_POLICY_HW_DEFAULT  = 0x00000020  ;// Hardware Removal Policy R
;                  |$SPDRP_REMOVAL_POLICY_OVERRIDE    = 0x00000021  ;// Removal Policy Override RW
;                  |$SPDRP_INSTALL_STATE              = 0x00000022  ;// Device Install State R
;                  |$SPDRP_LOCATION_PATHS             = 0x00000023  ;// Device Location Paths R
;                  |$SPDRP_MAXIMUM_PROPERTY           = 0x00000024  ;// Upper bound on ordinals'
; Return values .: Success      - String containing requested property
;                  Failure      - Null string "", @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: -
; Related .......: -
; Link ..........; @@MsdnLink@@ - http://msdn.microsoft.com/en-us/library/ms792967.aspx
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_GetDeviceRegistryProperty($iProperty)

	;Retrieves a specified Plug and Play device property.
	Local $result = DllCall($setupapi_dll, "int", "SetupDiGetDeviceRegistryProperty", "dword", $hDevInfo, "ptr", $pSP_DEVINFO_DATA, "dword", $iProperty, "dword*", 0, "str", "", "dword", 512, "dword*", 0)
	If @error Then
		Return SetError(@error, @extended, False)
	Else
		;Check for WinAPI error
		$WinAPI_Error = _WinAPI_GetLastError()
		If $WinAPI_Error <> 0 Then
			Return SetError(1, 1, "")
		Else
			Return $result[5]
		EndIf
	EndIf
EndFunc   ;==>_DeviceAPI_GetDeviceRegistryProperty

; #FUNCTION# ====================================================================================================================
; Name...........: _DeviceAPI_Open
; Description ...: [OPTIONAL] Open handle to setupapi.dll
; Syntax.........: -
; Parameters ....: none
; Return values .: Success      - True
;                  Failure      - False, @ERROR set
; Author ........: Matthew Horn (weaponx)
; Modified.......: -
; Remarks .......: Call _DeviceAPI_Open() before calling any Device API functions.
; Related .......: _DeviceAPI_Close
; Link ..........; @@MsdnLink@@ -
; Example .......; Yes
; ===============================================================================================================================
Func _DeviceAPI_Open()
	;Retrieve handle to Setup API dll
	$setupapi_dll = DllOpen("setupapi.dll")
	;_WinAPI_Check("_DeviceAPI_Open (setupapi.dll not found)", @ERROR, False)
	If @error Then Return SetError(@error, @extended, False)

	$cfgmgr32_dll = DllOpen("cfgmgr32.dll")
	;_WinAPI_Check("_DeviceAPI_Open (cfgmgr32.dll not found)", @ERROR, False)
	If @error Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_DeviceAPI_Open



;Dump 1 or 2 dimensional array to console
Func Debug($aArray)

	Local $num_dimensions = UBound($aArray, 0)
	Local $num_rows = UBound($aArray)

	Switch $num_dimensions
		Case 1
			For $X = 0 To $num_rows - 1
				ConsoleWrite("[" & $X & "]: " & $aArray[$X] & @CRLF)
			Next

		Case 2
			Local $num_columns = UBound($aArray, 2)

			For $X = 0 To $num_rows - 1
				ConsoleWrite("[" & $X & "]: ")
				For $Y = 0 To $num_columns - 1
					ConsoleWrite($aArray[$X][$Y] & ", ")
				Next
				ConsoleWrite(@CRLF)
			Next
	EndSwitch

	For $X = 0 To UBound($aArray) - 1
	Next
	ConsoleWrite(@CRLF)
EndFunc   ;==>Debug

;Dump tDEVINFO_DATA structure contents
Func Debug_SP_DEVINFO_DATA($tDEVINFO_DATA)

	ConsoleWrite("SP_DEVINFO_DATA: " & @CRLF)
	ConsoleWrite("cbsize: " & DllStructGetData($tDEVINFO_DATA, "cbsize") & @CRLF)
	ConsoleWrite("DevInst: " & DllStructGetData($tDEVINFO_DATA, "DevInst") & @CRLF)
	ConsoleWrite("Reserved: " & DllStructGetData($tDEVINFO_DATA, "Reserved") & @CRLF)
	ConsoleWrite(@CRLF)

	ConsoleWrite("GUID:" & @CRLF)
	ConsoleWrite("Data1: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data1")) & @CRLF)
	ConsoleWrite("Data2: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data2")) & @CRLF)
	ConsoleWrite("Data3: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data3")) & @CRLF)
	ConsoleWrite("Data4[1]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 1)) & @CRLF)
	ConsoleWrite("Data4[2]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 2)) & @CRLF)
	ConsoleWrite("Data4[3]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 3)) & @CRLF)
	ConsoleWrite("Data4[4]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 4)) & @CRLF)
	ConsoleWrite("Data4[5]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 5)) & @CRLF)
	ConsoleWrite("Data4[6]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 6)) & @CRLF)
	ConsoleWrite("Data4[7]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 7)) & @CRLF)
	ConsoleWrite("Data4[8]: " & Hex(DllStructGetData($tDEVINFO_DATA, "Data4", 8)) & @CRLF)
	ConsoleWrite(@CRLF)
EndFunc   ;==>Debug_SP_DEVINFO_DATA