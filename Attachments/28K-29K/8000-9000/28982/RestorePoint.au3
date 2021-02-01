#include-once

; #INDEX# =======================================================================================================================
; Title .........: RestorePoint
; AutoIt Version : 3.2.3++
; Language ......: English
; Description ...: Functions that assist with SystemRestore Use.
; Author(s) .....: Matthew McMullan (NerdFencer)
; Dll(s) ........: SrClient.dll, kernel32.dll
; ===============================================================================================================================

; #CONSTANTS# ===================================================================================================================
Global Const $RP_Type_APPLICATION_INSTALL = 0
Global Const $RP_Type_APPLICATION_UNINSTALL = 1
Global Const $RP_Type_DEVICE_DRIVER_INSTALL = 10
Global Const $RP_Type_MODIFY_SETTINGS = 12
Global Const $RP_Type_CANCELLED_OPERATION = 13
Global Const $RP_Event_BEGIN_SYSTEM_CHANGE = 100
Global Const $RP_Event_END_SYSTEM_CHANGE = 101
Global Const $RP_Event_BEGIN_NESTED_SYSTEM_CHANGE = 102
Global Const $RP_Event_END_NESTED_SYSTEM_CHANGE = 103
Global Const $RP_Last_Failure = 0
Global Const $RP_Last_Success = 1
Global Const $RP_Last_Interupt = 2
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_Restore_ConvertTimestamp
;_Restore_CreateRestorePoint
;_Restore_DeleteRestorePoint
;_Restore_DisableDrive
;_Restore_EnableDrive
;_Restore_EnumerateRestorePoint
;_Restore_EnumerateRestorePoints
;_Restore_GetDiskPercent
;_Restore_GetGlobalInterval
;_Restore_GetLastRestoreStatus
;_Restore_GetLifeInterval
;_Restore_GetSessionInterval
;_Restore_ParseTimestamp
;_Restore_Restore
;_Restore_SearchRestorePoints
;_Restore_SetDiskPercent
;_Restore_SetGlobalInterval
;_Restore_SetLifeInterval
;_Restore_SetSessionInterval
;_Restore_SvcSetStartMode
;_Restore_SvcStart
;_Restore_SvcStop
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_ConvertTimestamp
; Description ...: Converts a Timestamp to Local Time
; Syntax.........: _Restore_ConvertTimestamp($sStamp)
; Parameters ....: $sStamp      - The timestamp to convert
; Return values .: Success      - The converted Timestamp
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_ConvertTimestamp($sStamp)
	Local $tTimeZone = DllStructCreate("long Bias;wchar StdName[32];word StdDate[8];long StdBias;wchar DayName[32];word DayDate[8];long DayBias")
	Local $aResult = DllCall("kernel32.dll", "dword", "GetTimeZoneInformation", "ptr", DllStructGetPtr($tTimeZone))
	If @error Or $aResult[0] = -1 Then Return -1
	Local $offset = DllStructGetData($tTimeZone, "Bias")/60
	Local $hour = Number(StringMid($sStamp,7,2))+$offset
	Local $day = Number(StringMid($sStamp,5,2))
	If $hour>=24 Then
		$hour -= 24
		$day += 1
	ElseIf $hour<0 Then
		$hour += 24
		$day -= 1
	EndIf
	If $hour < 10 Then
		$hour = "0"&$hour
	EndIf
	If $day < 10 Then
		$day = "0"&$day
	EndIf
	Return StringLeft($sStamp,4)&$day&$hour&StringTrimLeft($sStamp,8)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_CreateRestorePoint
; Description ...: Creates a Restore Point
; Syntax.........: _Restore_CreateRestorePoint($sRestorePointName, $iRestorePointType = $RP_Type_APPLICATION_INSTALL, $iRestorePointEvent = $RP_Event_BEGIN_SYSTEM_CHANGE)
; Parameters ....: $sRestorePointName  - Name to Create the restore point with
;                  $iRestorePointType  - Type of Restore Point To Create
;                  |$RP_Type_APPLICATION_INSTALL   - Application is being Installed
;                  |$RP_Type_APPLICATION_UNINSTALL - Application is being Uninstalled
;                  |$RP_Type_DEVICE_DRIVER_INSTALL - A Driver is Being Installed or Updated
;                  |$RP_Type_MODIFY_SETTINGS       - A mojor change in system settings
;                  |$RP_Type_CANCELLED_OPERATION   - Deleted restore points are of this type
;                  $iRestorePointEvent - Event Type (almost always just leave this alone)
;                  |$RP_Event_BEGIN_SYSTEM_CHANGE  - Start of system Changes
;                  |$RP_Event_END_SYSTEM_CHANGE    - End of system changes
;                  |$RP_Event_BEGIN_NESTED_SYSTEM_CHANGE - Start of nested system changes
;                  |$RP_Event_END_NESTED_SYSTEM_CHANGE   - End of nested system changes
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......: 
; Remarks .......: 
; Related .......: 
; Link ..........: http://msdn.microsoft.com/en-us/library/aa378847%28VS.85%29.aspx
; Example .......: No
; ===============================================================================================================================
Func _Restore_CreateRestorePoint($sRestorePointName, $iRestorePointType = $RP_Type_APPLICATION_INSTALL, $iRestorePointEvent = $RP_Event_BEGIN_SYSTEM_CHANGE)
    Local $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	Local $iRet = $objSystemRestore.createrestorepoint($sRestorePointName, $iRestorePointType, $iRestorePointEvent)
    If Not $iRet = 0 Then SetError(1)
	Return $iRet
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_DeleteRestorePoint
; Description ...: Deletes a restore point
; Syntax.........: _Restore_DeleteRestorePoint($iPoint)
; Parameters ....: $iPoint      - The number of the restore point to create
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_DeleteRestorePoint($iPoint)
	Return DllCall("SrClient.dll","DWORD","SRRemoveRestorePoint","DWORD",$iPoint)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_DisableDrive
; Description ...: Disables a drive letter from being checked by sytem restore
; Syntax.........: _Restore_DisableDrive($sDrive = "C")
; Parameters ....: $sDrive      - The drive letter to disable
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_DisableDrive($sDrive = "C")
    Local $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
    Local $iRet = $objSystemRestore.disable($sDrive)
	If Not $iRet = 0 Then SetError(1)
	Return $iRet
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_EnableDrive
; Description ...: Enables a drive letter to be checked by system restore
; Syntax.........: _Restore_EnableDrive($sDrive = "C")
; Parameters ....: $sDrive      - The drive letter to enable
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_EnableDrive($sDrive = "C")
    Local $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
    Local $iRet = $objSystemRestore.enable($sDrive)
	If Not $iRet = 0 Then SetError(1)
	Return $iRet
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_EnumerateRestorePoint
; Description ...: Returns data about a specific restore point
; Syntax.........: _Restore_EnumerateRestorePoint($iPoint)
; Parameters ....: $iPoint      - The point to enumerate
; Return values .: Success      - An array with the following members
;                  |[0]         - Sequence Number
;                  |[1]         - Description
;                  |[2]         - Creation Time (UTC)
;                  |[3]         - Restore Point Type
;                  |[4]         - Event Type
;                  Failure      - -1
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_EnumerateRestorePoint($iPoint)
	Local $objRoot = ObjGet("winmgmts:root/default")
	Local $objPoints = $objRoot.InstancesOf ("SystemRestore")
	For $objPoint In $objPoints
		If $objPoint.SequenceNumber==$iPoint Then
			Local $aPoint[5] = [$objPoint.SequenceNumber, $objPoint.Description, $objPoint.CreationTime, $objPoint.RestorePointType, $objPoint.EventType]
			Return $aPoint
		EndIf
	Next
	Return SetError(1,0,-1)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_EnumerateRestorePoints
; Description ...: Gathers Data on all system restore points
; Syntax.........: _Restore_EnumerateRestorePoints()
; Parameters ....: 
; Return values .: Success      - An array with the following members
;                  |[n][0]      - Sequence Number
;                  |[n][1]      - Description
;                  |[n][2]      - Creation Time (UTC)
;                  |[n][3]      - Restore Point Type
;                  |[n][4]      - Event Type
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_EnumerateRestorePoints($bParseDate = False)
	Local $objRoot = ObjGet("winmgmts:root/default")
	Local $objPoints = $objRoot.InstancesOf ("SystemRestore")
	Local $aPoints[1][5]
	For $objPoint In $objPoints
		$aPoints[UBound($aPoints)-1][0] = $objPoint.SequenceNumber
		$aPoints[UBound($aPoints)-1][1] = $objPoint.Description
		If $bParseDate == False Then
			$aPoints[UBound($aPoints)-1][2] = $objPoint.CreationTime
		Else
			$aPoints[UBound($aPoints)-1][2] = _Restore_ParseTimestamp($objPoint.CreationTime)
		EndIf
		$aPoints[UBound($aPoints)-1][3] = $objPoint.RestorePointType
		$aPoints[UBound($aPoints)-1][4] = $objPoint.EventType
		ReDim $aPoints[UBound($aPoints)+1][5]
	Next
	ReDim $aPoints[UBound($aPoints)-1][5]
	Return $aPoints
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_GetDiskPercent
; Description ...: Gets the maximum percent of the hard drive that system restore can use
; Syntax.........: _Restore_GetDiskPercent()
; Parameters ....: 
; Return values .: Success      - The percent of the drive that can be used
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_GetDiskPercent()
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	Return $objRPConfig.DiskPercent
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_GetGlobalInterval
; Description ...: Gets the absolute time interval at which scheduled system checkpoints are created, in seconds.
; Syntax.........: _Restore_GetGlobalInterval()
; Parameters ....: 
; Return values .: Success      - The absolute time interval at which scheduled system checkpints are created, in seconds.
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_GetGlobalInterval()
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	Return $objRPConfig.RPGlobalInterval
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_GetLastRestoreStatus
; Description ...: Gets the final state of the last system restore
; Syntax.........: _Restore_GetLastRestoreStatus()
; Parameters ....: 
; Return values .: Success      - A value indecating the status
;                  |0           - Failure
;                  |1           - Success
;                  |2           - Interrupted
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_GetLastRestoreStatus()
	Local $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	Return $objSystemRestore.GetLastRestoreStatus()
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_GetLifeInterval
; Description ...: Gets the time interval for which restore points are preserved (before being deleted), in seconds.
; Syntax.........: _Restore_GetLifeInterval()
; Parameters ....: 
; Return values .: Success      - The time interval for which restore points are preserved, in seconds.
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_GetLifeInterval()
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	Return $objRPConfig.RPLifeInterval
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_GetSessionInterval
; Description ...: Gets the time interval at which scheduled system checkpoints are created during the session, in seconds.
; Syntax.........: _Restore_GetSessionInterval()
; Parameters ....: 
; Return values .: Success      - The time interval at which scheduled system checkpoints are created during the session.
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_GetSessionInterval()
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	Return $objRPConfig.RPLifeInterval
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_ParseTimestamp
; Description ...: Converts a Timestamp to Local Time
; Syntax.........: _Restore_ParseTimestamp($sTimeStamp, $bLocal = False)
; Parameters ....: $sTimeStamp  - The timestamp to parse
;                  |$bLocal     - True if it is recieving a timestamp that has been converted to local time
; Return values .: Success      - The parsed timestamp in an array
;                  |[0] - Year
;                  |[1] - Month
;                  |[2] - Day
;                  |[3] - Hour
;                  |[4] - Minute
;                  |[5] - Seccond
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_ParseTimestamp($sTimeStamp, $bLocal = False)
	Local $aTime[6]
	If $bLocal == False Then
		$sTimeStamp = _Restore_ConvertTimestamp($sTimeStamp)
	EndIf
	$aTime[0] = Number(StringLeft($sTimeStamp,4))
	$sTimeStamp = StringTrimLeft($sTimeStamp,4)
	For $iCount=1 To 5
		$aTime[$iCount] = Number(StringLeft($sTimeStamp,2))
		$sTimeStamp = StringTrimLeft($sTimeStamp,2)
	Next
	Return $aTime
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_Restore
; Description ...: Restores the system to a given restore point
; Syntax.........: _Restore_Restore($iPoint)
; Parameters ....: $iPoint      - The restore point to restore to
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_Restore($iPoint)
	Local $objSystemRestore = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	Return $objSystemRestore.Restore($iPoint)
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SearchRestorePoints
; Description ...: Finds restore points with a string in the description
; Syntax.........: _Restore_SearchRestorePoints($sString)
; Parameters ....: $sString     - String to search for
; Return values .: Success      - An array with the following members
;                  |[n][0]      - Sequence Number
;                  |[n][1]      - Description
;                  |[n][2]      - Creation Time (UTC)
;                  |[n][3]      - Restore Point Type
;                  |[n][4]      - Event Type
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SearchRestorePoints($sString)
	Local $objRoot = ObjGet("winmgmts:root/default")
	Local $objPoints = $objRoot.InstancesOf ("SystemRestore")
	Local $aPoints[1][5]
	For $objPoint In $objPoints
		If StringInStr($objPoint.Description,$sString) Then
			$aPoints[UBound($aPoints)-1][0] = $objPoint.SequenceNumber
			$aPoints[UBound($aPoints)-1][1] = $objPoint.Description
			$aPoints[UBound($aPoints)-1][2] = $objPoint.CreationTime
			$aPoints[UBound($aPoints)-1][3] = $objPoint.RestorePointType
			$aPoints[UBound($aPoints)-1][4] = $objPoint.EventType
			ReDim $aPoints[UBound($aPoints)+1][5]
		EndIf
	Next
	ReDim $aPoints[UBound($aPoints)-1][5]
	Return $aPoints
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SetDiskPercent
; Description ...: Sets the maximum amount of disk space on each drive that can be used by System Restore.
; Syntax.........: _Restore_SetDiskPercent($iPercent)
; Parameters ....: $iPercent    - The percent of the disk that can be used
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SetDiskPercent($iPercent)
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	$objRPConfig.DiskPercent = $iPercent
	Return $objRPConfig.Put_
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SetGlobalInterval
; Description ...: Sets the absolute time interval at which scheduled system checkpoints are created, in seconds.
; Syntax.........: _Restore_SetGlobalInterval($iInterval)
; Parameters ....: $iInterval   - The absolute time interval at which scheduled system checkpoints are created, in seconds.
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SetGlobalInterval($iInterval)
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	$objRPConfig.RPGlobalInterval = $iInterval
	Return $objRPConfig.Put_
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SetLifeInterval
; Description ...: Sets the time interval for which restore points are preserved (before being deleted), in seconds.
; Syntax.........: _Restore_SetLifeInterval($iInterval)
; Parameters ....: $iInterval   - The time interval for which restore points are preserved, in seconds.
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SetLifeInterval($iInterval)
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	$objRPConfig.RPLifeInterval = $iInterval
	Return $objRPConfig.Put_
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SetSessionInterval
; Description ...: Sets the time interval at which scheduled system checkpoints are created during the session, in seconds.
; Syntax.........: _Restore_SetSessionInterval($iInterval)
; Parameters ....: $iInterval   - The time interval at which scheduled system checkpoints are created during the session.
; Return values .: Success      - 
;                  Failure      - 
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SetSessionInterval($iInterval)
	Local $objRPConfig = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestoreConfig='SR'")
	$objRPConfig.RPSessionInterval = $iInterval
	Return $objRPConfig.Put_
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SvcSetStartMode
; Description ...: Sets the start mode of the system restore service
; Syntax.........: _Restore_SvcSetStartMode()
; Parameters ....: $sMode       - "Automatic", "Manual", or "Disabled"
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SvcSetStartMode($sMode)
	If Not($sMode=="Automatic" Or $sMode=="Manual" Or $sMode=="Disabled") Then
		Return False
	EndIf
	Local $objRoot = ObjGet("winmgmts:\\" & @ComputerName &"\root\cimv2")
	Local $objServices = $objRoot.ExecQuery("SELECT * FROM Win32_Service")
	For $objService In $objServices
		If $objService.Name = "srservice" Then
			Local $iOutput = $objService.ChangeStartMode($sMode)
			Return ($iOutput==0)
		EndIf
	Next
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SvcStart
; Description ...: Starts the System Restore Service
; Syntax.........: _Restore_SvcStart()
; Parameters ....: $bForce      - Forces the service to start even if it is disabled
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SvcStart($bForce = True)
	Local $objRoot = ObjGet("winmgmts:\\" & @ComputerName &"\root\cimv2")
	Local $objServices = $objRoot.ExecQuery("SELECT * FROM Win32_Service")
	For $objService In $objServices
		If $objService.Name = "srservice" Then
			Local $iOutput = $objService.StartService()
			If $iOutput==0 Or $iOutput==10 Then
				Return True
			EndIf
			If $iOutput == 14 And $bForce==True Then
				$objService.ChangeStartMode("Manual")
				$iOutput = $objService.StartService()
				If $iOutput==0 Or $iOutput==10 Then
					Return True
				EndIf
			EndIf
			Return False
		EndIf
	Next
	Return False
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _Restore_SvcStop
; Description ...: Stops the System Restore Service
; Syntax.........: _Restore_SvcStop()
; Parameters ....: 
; Return values .: Success      - True
;                  Failure      - False
; Author ........: Matthew McMullan (NerdFencer)
; Modified.......:
; Remarks .......: 
; Related .......:
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func _Restore_SvcStop()
	Local $objRoot = ObjGet("winmgmts:\\" & @ComputerName &"\root\cimv2")
	Local $objServices = $objRoot.ExecQuery("SELECT * FROM Win32_Service")
	For $objService In $objServices
		If $objService.Name = "srservice" Then
			Local $iOutput = $objService.StopService()
			If $iOutput==0 Or $iOutput==6 Then
				Return True
			EndIf
			Return False
		EndIf
	Next
	Return False
EndFunc
