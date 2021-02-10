#Region Header

#cs

    Title:          Management of Battery UDF Library for AutoIt3
    Filename:       Battery.au3
    Description:    Retrieves a various information and current status of the battery(s).
    Author:         Yashied
    Version:        0.1
    Requirements:   AutoIt v3.3.4.x, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           WinAPI.au3
    Note:           None

	Available functions:

    _Battery_GetDevicePath
    _Battery_GetTag
    _Battery_QueryInfo
    _Battery_QueryStatus

    Example1:

        #Include <Battery.au3>

        Opt('MustDeclareVars', 1)

        Global $aData, $iTag, $sDevicePath = _Battery_GetDevicePath()

        $iTag = _Battery_GetTag($sDevicePath)
        If $iTag Then
	        $aData = _Battery_QueryInfo($sDevicePath, $iTag)
	        If IsArray($aData) Then
		        ConsoleWrite('Battery name:          ' & $aData[0 ] & @CR)
		        ConsoleWrite('Manufacture name:      ' & $aData[1 ] & @CR)
		        ConsoleWrite('Manufacture date:      ' & $aData[2 ] & @CR)
		        ConsoleWrite('Serial number:         ' & $aData[3 ] & @CR)
		        ConsoleWrite('Unique ID:             ' & $aData[4 ] & @CR)
		        ConsoleWrite('Temperature:           ' & $aData[5 ] & @CR)
		        ConsoleWrite('Estimated time:        ' & $aData[6 ] & @CR)
		        ConsoleWrite('Capabilities:          ' & $aData[7 ] & @CR)
		        ConsoleWrite('Technology:            ' & $aData[8 ] & @CR)
		        ConsoleWrite('Chemistry:             ' & $aData[9 ] & @CR)
		        ConsoleWrite('Designed capacity:     ' & $aData[10] & @CR)
		        ConsoleWrite('Full charged capacity: ' & $aData[11] & @CR)
		        ConsoleWrite('Default alert1:        ' & $aData[12] & @CR)
		        ConsoleWrite('Default alert2:        ' & $aData[13] & @CR)
		        ConsoleWrite('Critical bias:         ' & $aData[14] & @CR)
		        ConsoleWrite('Cycle count:           ' & $aData[15] & @CR)
	        Else
                Switch @error
                    Case 1
                        ConsoleWrite('Unable to open the battery device.' & @CR)
                    Case 2
                        ConsoleWrite('The specified tag does not match that of the current battery tag.' & @CR)
                EndSwitch
	        EndIf
        Else
	        ConsoleWrite('Battery not found.' & @CR)
        EndIf

    Example2:

        #Include <Battery.au3>

        Opt('MustDeclareVars', 1)

        Global $aData, $iTag, $sDevicePath = _Battery_GetDevicePath()

        $iTag = _Battery_GetTag($sDevicePath)
        If $iTag Then
            $aData = _Battery_QueryStatus($sDevicePath, $iTag)
            If IsArray($aData) Then
                ConsoleWrite('Power state: ' & $aData[0] & @CR)
                ConsoleWrite('Capacity:    ' & $aData[1] & @CR)
                ConsoleWrite('Voltage:     ' & $aData[2] & @CR)
                ConsoleWrite('Rate:        ' & $aData[3] & @CR)
            Else
                Switch @error
                    Case 1
                        ConsoleWrite('Unable to open the battery device.' & @CR)
                    Case 2
                        ConsoleWrite('The specified tag does not match that of the current battery tag.' & @CR)
                EndSwitch
            EndIf
        Else
            ConsoleWrite('Battery not found.' & @CR)
        EndIf

#ce

#Include-once

#Include <WinAPI.au3>

#EndRegion Header

#Region Global Variables and Constants

Global Const $GUID_DEVCLASS_BATTERY = '{72631E54-78A4-11D0-BCF7-00AA00B7B32A}'

Global Const $DIGCF_ALLCLASSES = 0x04
Global Const $DIGCF_DEVICEINTERFACE = 0x10
Global Const $DIGCF_DEFAULT = 0x01
Global Const $DIGCF_PRESENT = 0x02
Global Const $DIGCF_PROFILE = 0x08

Global Const $IOCTL_BATTERY_QUERY_INFORMATION  = 0x00294044
Global Const $IOCTL_BATTERY_QUERY_STATUS = 0x0029404C
Global Const $IOCTL_BATTERY_QUERY_TAG = 0x00294040

Global Const $BatteryInformation = 0
Global Const $BatteryGranularityInformation = 1
Global Const $BatteryTemperature = 2
Global Const $BatteryEstimatedTime = 3
Global Const $BatteryDeviceName = 4
Global Const $BatteryManufactureDate = 5
Global Const $BatteryManufactureName = 6
Global Const $BatteryUniqueID = 7
Global Const $BatterySerialNumber = 8

Global Const $BATTERY_CAPACITY_RELATIVE = 0x40000000
Global Const $BATTERY_IS_SHORT_TERM = 0x20000000
Global Const $BATTERY_SET_CHARGE_SUPPORTED = 0x00000001
Global Const $BATTERY_SET_DISCHARGE_SUPPORTED = 0x00000002
Global Const $BATTERY_SYSTEM_BATTERY = 0x80000000

Global Const $BATTERY_CHARGING = 0x00000004
Global Const $BATTERY_CRITICAL = 0x00000008
Global Const $BATTERY_DISCHARGING = 0x00000002
Global Const $BATTERY_POWER_ON_LINE = 0x00000001

Global Const $BATTERY_UNKNOWN_CAPACITY = -1
Global Const $BATTERY_UNKNOWN_VOLTAGE = -1
Global Const $BATTERY_UNKNOWN_RATE = 0x80000000

Global Const $tagSP_DEVINFO_DATA = 'dword Size;' & $tagGUID & ';dword DevInst;ulong_ptr Reserved'
Global Const $tagSP_DEVICE_INTERFACE_DATA = 'dword Size;' & $tagGUID & ';dword Flag;ulong_ptr Reserved'
Global Const $tagSP_DEVICE_INTERFACE_DETAIL_DATA = 'dword Size;wchar DevicePath[1024]'

Global Const $tagBATTERY_INFORMATION = 'ulong Capabilities;byte Technology;byte Reserved[3];char Chemistry[4];ulong DesignedCapacity;ulong FullChargedCapacity;ulong DefaultAlert1;ulong DefaultAlert2;ulong CriticalBias;ulong CycleCount'
Global Const $tagBATTERY_MANUFACTURE_DATE = 'byte Day;byte Month;ushort Year'
Global Const $tagBATTERY_QUERY_INFORMATION = 'ulong BatteryTag;ulong InformationLevel;long AtRate'
Global Const $tagBATTERY_REPORTING_SCALE = 'ulong Granularity;ulong Capacity'
Global Const $tagBATTERY_STATUS = 'ulong PowerState;ulong Capacity;ulong Voltage;long Rate'
Global Const $tagBATTERY_WAIT_STATUS = 'ulong BatteryTag;ulong Timeout;ulong PowerState;ulong LowCapacity;ulong HighCapacity'

#EndRegion Global Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _Battery_GetDevicePath
; Description....: Retrieves a battery device interface path.
; Syntax.........: _Battery_GetDevicePath ( [$iBattery] )
; Parameters.....: $iBattery - Zero based battery number to retrieve a path. If the battery alone, this parameter must be set to 0.
; Return values..: Success   - The interface path.
;                  Failure   - Empty string and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: The string returned by this function need when calling other functions from this library.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Battery_GetDevicePath($iBattery = 0)

	Local $tGUID = _WinAPI_GUIDFromString($GUID_DEVCLASS_BATTERY)

	If Not IsDllStruct($tGUID) Then
		Return SetError(3, 0, '')
	EndIf

	Local $tSPDID = DllStructCreate($tagSP_DEVICE_INTERFACE_DATA)
	Local $pSPDID = DllStructGetPtr($tSPDID)
	Local $tSPDIDD = DllStructCreate($tagSP_DEVICE_INTERFACE_DETAIL_DATA)
	Local $pGUID = DllStructGetPtr($tGUID)
	Local $hData, $Ret, $Res = 0

	$Ret = DllCall('setupapi.dll', 'ptr', 'SetupDiGetClassDevsW', 'ptr', $pGUID, 'ptr', 0, 'ptr', 0, 'dword', BitOR($DIGCF_DEVICEINTERFACE, $DIGCF_PRESENT))
	If (@error) Or (Not $Ret[0]) Then
		Return SetError(3, 0, '')
	EndIf
	$hData = $Ret[0]
	DllStructSetData($tSPDID, 'Size', DllStructGetSize($tSPDID))
	If @AutoItX64 Then
		DllStructSetData($tSPDIDD, 'Size', 8)
	Else
		DllStructSetData($tSPDIDD, 'Size', 6)
	EndIf
	Do
		$Ret = Dllcall('setupapi.dll', 'int', 'SetupDiEnumDeviceInterfaces', 'ptr', $hData, 'ptr', 0, 'ptr', $pGUID, 'dword', $iBattery, 'ptr', $pSPDID)
		If (@error) Or (Not $Ret[0]) Then
			ExitLoop
		EndIf
		$Ret = DllCall('setupapi.dll', 'int', 'SetupDiGetDeviceInterfaceDetailW', 'ptr', $hData, 'ptr', $pSPDID, 'ptr', DllStructGetPtr($tSPDIDD), 'dword', DllStructGetSize($tSPDIDD), 'ptr', 0, 'ptr', 0)
		If (@error) Or (Not $Ret[0]) Then
			ExitLoop
		EndIf
		$Res = 1
	Until 1
	Dllcall('setupapi.dll', 'int', 'SetupDiDestroyDeviceInfoList', 'ptr', $hData)
	If $Res Then
		Return SetError(0, 0, DllStructGetData($tSPDIDD, 'DevicePath'))
	Else
		Return SetError(3, 0, '')
	EndIf
EndFunc   ;==>_Battery_GetDevicePath

; #FUNCTION# ====================================================================================================================
; Name...........: _Battery_GetTag
; Description....: Retrieves the battery's current tag.
; Syntax.........: _Battery_GetTag ( $sDevicePath )
; Parameters.....: $sDevicePath - The battery device interface path returned by _Battery_GetDevicePath() function.
; Return values..: Success      - The current battery tag.
;                  Failure      - 0 and sets the @error flag to the following values:
;
;                                 1 - Unable to open the battery device or interface path is invalid.
;                                 3 - Any other error.
;
; Author.........: Yashied
; Modified.......:
; Remarks........: The value returned by this function need when calling _Battery_QueryInfo() or _Battery_QueryStatus() function.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Battery_GetTag($sDevicePath)

	Local $hBattery = _WinAPI_CreateFile($sDevicePath, 3, 2, 2)

	If Not $hBattery Then
		Return SetError(1, 0, 0)
	EndIf

	Local $Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_TAG, 'ulong*', -1, 'dword', 4, 'ulong*', 0, 'dword', 4, 'dword*', 0, 'ptr', 0)

	If (@error) Or (Not $Ret[0]) Then
		$Ret = 0
	EndIf
	_WinAPI_CloseHandle($hBattery)
	If IsArray($Ret) Then
		Return SetError(0, 0, $Ret[5])
	Else
		Return SetError(3, 0, 0)
	EndIf
EndFunc   ;==>_Battery_GetTag

; #FUNCTION# ====================================================================================================================
; Name...........: _Battery_QueryInfo
; Description....: Retrieves a variety of information for the battery.
; Syntax.........: _Battery_QueryInfo ( $sDevicePath, $iTag )
; Parameters.....: $sDevicePath - The battery device interface path returned by _Battery_GetDevicePath() function.
;                  $iTag        - The battery tag.
; Return values..: Success      - The array containing the following information:
;
;                                 [0 ] - The battery's name.
;                                 [1 ] - The name of the manufacturer of the battery.
;                                 [2 ] - The date of manufacture of a battery.
;                                 [3 ] - The battery's serial number.
;                                 [4 ] - The string that uniquely identifies the battery.
;                                 [5 ] - The battery's current temperature, in 10ths of a degree Kelvin.
;                                 [6 ] - The estimated battery run time, in seconds.
;                                 [7 ] - The battery capabilities. This member can be one or more of the $BATTERY_* constants.
;                                 [8 ] - The battery technology (0 - Nonrechargeable; 1 - Rechargeable).
;                                 [9 ] - An abbreviated character string that indicates the battery's chemistry.
;                                 [10] - The theoretical capacity of the battery when new, in mWh.
;                                 [11] - The battery's current fully charged capacity in mWh (or relative).
;                                 [12] - The manufacturer's suggested capacity, in mWh, at which a low battery alert should occur.
;                                 [13] - The manufacturer's suggested capacity, in mWh, at which a warning battery alert should occur.
;                                 [14] - A bias from zero, in mWh, which is applied to battery reporting.
;                                 [15] - The number of charge/discharge cycles the battery has experienced.
;
;                                 Some information about batteries is optional or may be meaningless for some batteries.
;                                 In this case, the corresponding parameter is empty string.
;
;                                 (See MSDN for more information)
;
;                  Failure      - 0 and sets the @error flag to the following values:
;
;                                 1 - Unable to open the battery device or interface path is invalid.
;                                 2 - The specified tag ($iTag) does not match that of the current battery tag.
;                                 3 - Any other error.
;
; Author.........: Yashied
; Modified.......:
; Remarks........: If this function fails with @error = 2, you must retrieve a new tag by calling the _Battery_GetTag() function.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Battery_QueryInfo($sDevicePath, $iTag)

	Local $hBattery = _WinAPI_CreateFile($sDevicePath, 3, 2, 2)

	If Not $hBattery Then
		Return SetError(1, 0, 0)
	EndIf

	Local $tBQI = DllStructCreate($tagBATTERY_QUERY_INFORMATION)
	Local $tBI  = DllStructCreate($tagBATTERY_INFORMATION)
	Local $tBMD = DllStructCreate($tagBATTERY_MANUFACTURE_DATE)
	Local $tData = DllStructCreate('wchar[1024]')
	Local $aData[16], $Ret, $Error = 0

	DllStructSetData($tBQI, 'BatteryTag', $iTag)
	DllStructSetData($tBQI, 'AtRate', 0)

	For $i = 0 To 15
		$aData[$i] = ''
	Next

	Do
		DllStructSetData($tBQI, 'InformationLevel', $BatteryDeviceName)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[0] = DllStructGetData($tData, 1)
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryManufactureName)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[1] = DllStructGetData($tData, 1)
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryManufactureDate)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tBMD), 'dword', DllStructGetSize($tBMD), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[2] = StringFormat('%02d/%02d/%04d', DllStructGetData($tBMD, 'Month'), DllStructGetData($tBMD, 'Day'), DllStructGetData($tBMD, 'Year'))
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatterySerialNumber)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[3] = DllStructGetData($tData, 1)
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryUniqueID)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[4] = DllStructGetData($tData, 1)
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryTemperature)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ulong*', 0, 'dword', 4, 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[5] = $Ret[5]
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryEstimatedTime)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ulong*', 0, 'dword', 4, 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				$aData[6] = $Ret[5]
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
		If $Error Then
			ExitLoop
		Endif
		DllStructSetData($tBQI, 'InformationLevel', $BatteryInformation)
		$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_INFORMATION, 'ptr', DllStructGetPtr($tBQI), 'dword', DllStructGetSize($tBQI), 'ptr', DllStructGetPtr($tBI), 'dword', DllStructGetSize($tBI), 'dword*', 0, 'ptr', 0)
		If @error Then
			$Error = 3
		ELse
			If $Ret[0] Then
				For $i = 7 To 15
					$aData[$i] = DllStructGetData($tBI, $i - 6 + ($i > 8))
				Next
			Else
				If _WinAPI_GetLastError() = 2 Then
					$Error = 2
				EndIf
			EndIf
		EndIf
	Until 1
	_WinAPI_CloseHandle($hBattery)
	If $Error Then
		$aData = 0
	EndIf
	Return SetError($Error, 0, $aData)
EndFunc   ;==>_Battery_QueryInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _Battery_QueryStatus
; Description....: Retrieves the current status of the battery.
; Syntax.........: _Battery_QueryStatus ( $sDevicePath, $iTag )
; Parameters.....: $sDevicePath - The battery device interface path returned by _Battery_GetDevicePath() function.
;                  $iTag        - The battery tag.
; Return values..: Success      - The array containing the following information:
;
;                                 [0] - The battery state. This member can be zero, one, or more of the $BATTERY_* constants.
;                                 [1] - The current battery capacity, in mWh (or relative).
;                                 [2] - The current battery voltage across the battery terminals, in millivolts (mv).
;                                 [3] - The current rate of battery charge or discharge.
;
;                                 (See MSDN for more information)
;
;                  Failure      - 0 and sets the @error flag to the following values:
;
;                                 1 - Unable to open the battery device or interface path is invalid.
;                                 2 - The specified tag ($iTag) does not match that of the current battery tag.
;                                 3 - Any other error.
;
; Author.........: Yashied
; Modified.......:
; Remarks........: If this function fails with @error = 2, you must retrieve a new tag by calling the _Battery_GetTag() function.
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _Battery_QueryStatus($sDevicePath, $iTag)

	Local $hBattery = _WinAPI_CreateFile($sDevicePath, 3, 2, 2)

	If Not $hBattery Then
		Return SetError(1, 0, 0)
	EndIf

	Local $tBWS = DllStructCreate($tagBATTERY_WAIT_STATUS)
	Local $tBS  = DllStructCreate($tagBATTERY_STATUS)
	Local $aData[4], $Ret, $Error = 0

	DllStructSetData($tBWS, 'BatteryTag', $iTag)
	DllStructSetData($tBWS, 'Timeout', -1)
	For $i = 3 To 5
		DllStructSetData($tBWS, $i, 0)
	Next
	$Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hBattery, 'dword', $IOCTL_BATTERY_QUERY_STATUS, 'ptr', DllStructGetPtr($tBWS), 'dword', DllStructGetSize($tBWS), 'ptr', DllStructGetPtr($tBS), 'dword', DllStructGetSize($tBS), 'dword*', 0, 'ptr', 0)
	If @error Then
		$Error = 3
	Else
		If $Ret[0] Then
			For $i = 0 To 3
				$aData[$i] = DllStructGetData($tBS, $i + 1)
			Next
		Else
			If _WinAPI_GetLastError() = 2 Then
				$Error = 2
			Else
				$Error = 3
			EndIf
		EndIf
	EndIf
	_WinAPI_CloseHandle($hBattery)
	If $Error Then
		$aData = 0
	EndIf
	Return SetError($Error, 0, $aData)
EndFunc   ;==>_Battery_QueryStatus

#EndRegion Public Functions
