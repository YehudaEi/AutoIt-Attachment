#include-once
#RequireAdmin
; #INDEX# =======================================================================================================================
; Title .........: SystemRestore
; Description ...: Functions to manage the system retore. This includes create, enum and delete restore points.
; Author(s) .....: Fred (FredAI)
; Dll(s) ........: SrClient.dll
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _SR_CreateRestorePoint
; _SR_EnumRestorePoints
; _SR_RemoveRestorePoint
; _SR_RemoveAllRestorePoints
; _SR_Enable
; _SR_Disable
; _SR_Restore
; ===============================================================================================================================

; #MODIFIED/IMPLEMENTED# =====================================================================================================================
; WMIDateStringToDate
; ===============================================================================================================================

;Creating the WMI objects with global scope will prevent creating them more than once, to save resources...
Global $obj_SR, $obj_WMI
Global $SystemDrive = EnvGet('SystemDrive') & '\'

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_CreateRestorePoint
; Description ...: Creates a system restore point
; Syntax.........: _SR_CreateRestorePoint($strDescription)
; Parameters ....: $strDescription - The system restore point's description. Can have up to 256 characters.
; Return values .: 	Success - 1
;					Failure - 0 Sets @error to 1 if an error occurs when calling the dll function.
; Author ........: FredAI
; Modified.......:
; Remarks .......: The system restore takes a few seconds to update. According to MSDN, this function doesn't work in safe mode.
; Related .......: _SR_RemoveRestorePoint
; Link ..........:
; Example .......: _SR_CreateRestorePoint('My restore point')
; ===============================================================================================================================
Func _SR_CreateRestorePoint($strDescription)
	Local Const $MAX_DESC = 64
	Local Const $MAX_DESC_W = 256
	Local Const $BEGIN_SYSTEM_CHANGE = 100
	Local Const $MODIFY_SETTINGS = 12
	Local $_RESTOREPTINFO = DllStructCreate('DWORD dwEventType;DWORD dwRestorePtType;INT64 llSequenceNumber;WCHAR szDescription['&$MAX_DESC_W&']')
	DllStructSetData($_RESTOREPTINFO,'dwEventType',$BEGIN_SYSTEM_CHANGE)
	DllStructSetData($_RESTOREPTINFO,'dwRestorePtType',$MODIFY_SETTINGS)
	DllStructSetData($_RESTOREPTINFO,'llSequenceNumber',0)
	DllStructSetData($_RESTOREPTINFO,'szDescription',$strDescription)
	Local $pRestorePtSpec = DllStructGetPtr($_RESTOREPTINFO)

	Local $_SMGRSTATUS = DllStructCreate('UINT  nStatus;INT64 llSequenceNumber')
	Local $pSMgrStatus = DllStructGetPtr($_SMGRSTATUS)

	Local $aRet = DllCall('SrClient.dll','BOOL','SRSetRestorePointW','ptr',$pRestorePtSpec,'ptr',$pSMgrStatus)
	If @error Then Return 0
	Return $aRet[0]
EndFunc ;==> _SR_CreateRestorePoint

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_EnumRestorePoints
; Description ...: Enumerates all existing restore points.
; Syntax.........: _SR_EnumRestorePoints()
; Parameters ....: None
; Return values .: 	Success - An array with info on the restore points:
;							$Array[0][0] => Number of restore points.
;							$Array[n][1] => Restore point's sequence number.
;							$Array[n][2] => Restore point's description.
;							$Array[n][3] => Restore point's creation date.
;					Failure - An empty bi-dimensinal array where $Array[0][0] = 0.
; Author ........: FredAI
; Modified.......:
; Remarks .......:
; Related .......: _SR_RemoveAllRestorePoints()
; Link ..........:
; Example .......: $rPoints = _SR_EnumRestorePoints()
; ===============================================================================================================================
Func _SR_EnumRestorePoints()
	Local $aRet[1][3], $i = 0
	$aRet[0][0] = 0
	If Not IsObj($obj_WMI) Then $obj_WMI = ObjGet("winmgmts:root/default")
	If Not IsObj($obj_WMI) Then Return $aRet
	Local $RPSet = $obj_WMI.InstancesOf("SystemRestore")
	If Not IsObj($RPSet) Then Return $aRet
	For $RP In $RPSet
		$i += 1
		ReDim $aRet[$i+1][3]
		$aRet[$i][0] = $RP.SequenceNumber
		$aRet[$i][1] = $RP.Description
		$aRet[$i][2] = WMIDateStringToDate($RP.CreationTime)
	Next
	$aRet[0][0] = $i
	Return $aRet
EndFunc ;==> _SR_EnumRestorePoints

Func WMIDateStringToDate($dtmDate)
	Return (StringMid($dtmDate, 5, 2) & "/" & _
	StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
	& " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate,13, 2))
EndFunc ;==> WMIDateStringToDate

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_RemoveRestorePoint
; Description ...: Deletes a system restore point.
; Syntax.........: _SR_RemoveRestorePoint($rpSeqNumber)
; Parameters ....: $rpSeqNumber - The system restore point's sequence number. can be obtained with _SR_EnumRestorePoints
; Return values .: 	Success - 1
;					Failure - 0 and sets @error
; Author ........: FredAI
; Modified.......:
; Remarks .......: The system restore takes a few seconds to update. According to MSDN, this function doesn't work in safe mode.
; Related .......: _SR_RemoveAllRestorePoints
; Link ..........:
; Example .......: _SR_RemoveRestorePoint(20)
; ===============================================================================================================================
Func _SR_RemoveRestorePoint($rpSeqNumber)
	Local $aRet = DllCall('SrClient.dll','DWORD','SRRemoveRestorePoint','DWORD',$rpSeqNumber)
	If @error Then
		Return SetError(1,0,0)
	ElseIf $aRet[0] = 0 Then
		Return 1
	Else
		Return SetError(1,0,0)
	EndIf
EndFunc ;==> _SR_RemoveRestorePoint

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_RemoveAllRestorePoints
; Description ...: Deletes all existing system restore points.
; Syntax.........: _SR_RemoveAllRestorePoints()
; Parameters ....: None
; Return values .: 	Success - The number of deleted restore points.
;					Failure - Returns 0 if no restore points existed or an error occurred.
; Author ........: FredAI
; Modified.......:
; Remarks .......: The system restore takes a few seconds to update. According to MSDN, this function doesn't work in safe mode.
; Related .......: _SR_RemoveRestorePoint
; Link ..........:
; Example .......: $rpDeleted = _SR_RemoveAllRestorePoints()
; ===============================================================================================================================
Func _SR_RemoveAllRestorePoints()
	Local $aRP = _SR_EnumRestorePoints(), $ret = 0
	For $i = 1 To $aRP[0][0]
		$ret += _SR_RemoveRestorePoint($aRP[$i][0])
	Next
	Return $ret
EndFunc ;==> _SR_RemoveAllRestorePoints

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_Enable
; Description ...: Enables the system restore.
; Syntax.........: _SR_Enable($DriveL = $SystemDrive)
; Parameters ....: $DriveL: The letter of the hard drive to monitor. Defaults to the system drive (Usually C:). See remarks.
; Return values .: 	Success - 1.
;					Failure - 0
; Author ........: FredAI
; Modified.......:
; Remarks .......: Acording to MSDN, setting a blank string as the drive letter, will enable the system restore for all drives,
;					+but some tests revealed that, on Windows 7, only the system drive is enabled.
;					+This parameter must end with a backslash. e.g. C:\
; Related .......: _SR_Disable
; Link ..........:
; Example .......: $enabled = _SR_Enable()
; ===============================================================================================================================
Func _SR_Enable($DriveL = $SystemDrive)
	If Not IsObj($obj_SR) Then $obj_SR = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	If Not IsObj($obj_SR) Then Return 0
	If $obj_SR.Enable($DriveL) = 0 Then Return 1
	Return 0
EndFunc ;==> _SR_Enable

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_Disable
; Description ...: Disables the system restore.
; Syntax.........: _SR_Disable($DriveL = $SystemDrive)
; Parameters ....: $DriveL: The letter of the hard drive to disable monitoring. Defaults to the system drive (Usually C:). See remarks.
; Return values .: 	Success - 1.
;					Failure - 0
; Author ........: FredAI
; Modified.......:
; Remarks .......: Acording to MSDN, setting a blank string as the drive letter, will enable the system restore for all drives,
;					+but some tests revealed that, on Windows 7, only the system drive is enabled.
;					+This parameter must end with a backslash. e.g. C:\
; Related .......: _SR_Enable()
; Link ..........:
; Example .......: $disabled = _SR_Disable
; ===============================================================================================================================
Func _SR_Disable($DriveL = $SystemDrive)
	If Not IsObj($obj_SR) Then $obj_SR = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	If Not IsObj($obj_SR) Then Return 0
	If $obj_SR.Disable($DriveL) = 0 Then Return 1
	Return 0
EndFunc ;==> _SR_Disable

; #FUNCTION# ====================================================================================================================
; Name...........: _SR_Restore
; Description ...: Initiates a system restore. The caller must force a system reboot. The actual restoration occurs during the reboot.
; Syntax.........: _SR_Restore($rpSeqNumber)
; Parameters ....: $rpSeqNumber - The system restore point's sequence number. Can be obtained with _SR_EnumRestorePoints
; Return values .: 	Success - 1.
;					Failure - 0
; Author ........: FredAI
; Modified.......:
; Remarks .......: After calling this function, call Shutdown(2) to reboot.
; Related .......: _SR_EnumRestorePoints
; Link ..........:
; Example .......: If _SR_Restore(20) Then Shutdown(2)
; ===============================================================================================================================
Func _SR_Restore($rpSeqNumber)
	If Not IsObj($obj_SR) Then $obj_SR = ObjGet("winmgmts:{impersonationLevel=impersonate}!root/default:SystemRestore")
	If Not IsObj($obj_SR) Then Return 0
	If $obj_SR.Restore($rpSeqNumber) = 0 Then Return 1
	Return 0
EndFunc ;==> _SR_Restore

