#include "DeviceAPI.au3"

;debug(_DeviceAPI_GetClassArray())
;exit

;--------------------------------------------------------
; EXAMPLE 1 - Build list of all devices from all classes
;--------------------------------------------------------
;#cs
;Build list of ALL device classes
_DeviceAPI_GetAllDevices()

;Loop through all devices by index
While _DeviceAPI_EnumDevices()
	$string = "+"& _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DEVICEDESC) & @CRLF
	$string &= "Class Name: " & _DeviceAPI_GetClassName(_DeviceAPI_GetDeviceRegistryProperty($SPDRP_CLASSGUID)) & @CRLF
	$string &= "Class GUID: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_CLASSGUID) & @CRLF
	$string &= "Hardware ID: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_HARDWAREID) & @CRLF
	$string &= "Unique Instance ID: " & _DeviceAPI_GetDeviceId() & @CRLF
	$string &= "Manufacturer: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_MFG) & @CRLF
	$string &= "Driver: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DRIVER) & @CRLF
	$string &= "Friendly Name: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_FRIENDLYNAME) & @CRLF
	$string &= "Physical Device Object Name: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_PHYSICAL_DEVICE_OBJECT_NAME) & @CRLF
	$string &= "Upper Filters: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_UPPERFILTERS) & @CRLF
	$string &= "Lower Filters: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_LOWERFILTERS) & @CRLF
	$string &= "Enumerator: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_ENUMERATOR_NAME) & @CRLF
	$string &= @CRLF

	ConsoleWrite($string)
WEnd

_DeviceAPI_DestroyDeviceInfoList() ;Cleanup for good measure
;#ce

;----------------------------------------------------------------------------
; EXAMPLE 2 - Build list of all classes then loop through each device within
;----------------------------------------------------------------------------
#cs
_DeviceAPI_GetClasses()
While _DeviceAPI_EnumClasses()
	$str = ""
	$str &= "+"&_DeviceAPI_GetClassName($p_currentGUID) & @CRLF
	;$str &= ">$iEnumClassInfoCursor: " & $iEnumClassInfoCursor & @CRLF

	_DeviceAPI_GetClassDevices($p_currentGUID)
	While _DeviceAPI_EnumDevices()




		;$str &= ">$iEnumDeviceInfoCursor: " & $iEnumDeviceInfoCursor & @CRLF
		$str &= _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DEVICEDESC) & @CRLF
		$str &= "Class Name: " & _DeviceAPI_GetClassName(_DeviceAPI_GetDeviceRegistryProperty($SPDRP_CLASSGUID)) & @CRLF
		$str &= "Class GUID: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_CLASSGUID) & @CRLF
		$str &= "Hardware ID: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_HARDWAREID) & @CRLF
		$str &= "Unique Instance ID: " & _DeviceAPI_GetDeviceId() & @CRLF
		$str &= "Manufacturer: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_MFG) & @CRLF
		$str &= "Driver: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_DRIVER) & @CRLF
		$str &= "Friendly Name: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_FRIENDLYNAME) & @CRLF
		$str &= "Physical Device Object Name: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_PHYSICAL_DEVICE_OBJECT_NAME) & @CRLF
		$str &= "Upper Filters: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_UPPERFILTERS) & @CRLF
		$str &= "Lower Filters: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_LOWERFILTERS) & @CRLF
		$str &= "Enumerator: " & _DeviceAPI_GetDeviceRegistryProperty($SPDRP_ENUMERATOR_NAME) & @CRLF
		$str &= @CRLF

		;If NOT StringInStr(_DeviceAPI_GetDeviceRegistryProperty($SPDRP_HARDWAREID), "USB") Then
		;	$test = _DeviceAPI_DeleteDeviceInfo()
		;	ConsoleWrite("Delete " & $test & @CRLF)
		;EndIf
	WEnd
	ConsoleWrite($str)
WEnd

_DeviceAPI_DestroyDeviceInfoList() ;Cleanup for good measure
#ce


;----------------------------------------------------------------------------
; EXAMPLE 3 - Build array of all classes, build array of devices for each
;----------------------------------------------------------------------------
#cs
$aClasses = _DeviceAPI_GetClassArray()
For $X = 0 to Ubound($aClasses)-1
	$str = ""
	$str &= "+"& $aClasses[$X][2] & @CRLF ;Class description

	$aDevices = _DeviceAPI_GetDeviceArray($aClasses[$X][0])
	For $Y = 0 to Ubound($aDevices)-1
		$str &= $aDevices[$Y][0] & " : " & $aDevices[$Y][1] & @CRLF
	Next
	$str &= @CRLF
	ConsoleWrite($str)
Next
#ce
