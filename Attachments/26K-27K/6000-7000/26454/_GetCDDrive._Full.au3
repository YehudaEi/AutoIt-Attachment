; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.3.0 (Latest tested version)
; Original Author:  Rick
; Modified version: Rajesh V R 
; Script Function:
;	To find Drive letter of CD-RW Drive,   (For Win95 upwards)
;
;	Result = "CD-RW Drive letter" or "" for no CD-RW drive
;
; ----------------------------------------------------------------------------

MsgBox(0, "My CDRW Drive is:", _CDR())

Func _CDR()
	$Drive = ""
	If @OSTYPE = "WIN32_NT" Then
		$VolReg = RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CD Burning", "CD Recorder Drive")
		If Not @error Then
			$Drive = _GetDriveByVolumeName_dll($VolReg)
			If $Drive = "" Then ; dllcall failed try registry
				$Drive = _GetDriveByVolumeName_Reg($VolReg)
			EndIf
		EndIf
	Else
		; for win9x
		$Regl = "HKEY_LOCAL_MACHINE\Enum\SCSI\"
		$All = DriveGetDrive("All")
		For $i = 1 To $All[0]
			$var = RegEnumKey($Regl, $i)
			If @error <> 0 Then ExitLoop
			$CDLine = $Regl & $var & "\" & RegEnumKey($Regl & $var, 1)
			If RegRead($CDLine, "Class") = "CDROM" And StringInStr(StringReplace($var, "ROM", ""), "-R") > 0 Then $Drive = RegRead($CDLine, "CurrentDriveLetterAssignment") & ":"
		Next

	EndIf
	Return $Drive
EndFunc   ;==>_CDR


Func _GetDriveByVolumeName_dll($VolumeName, $Types = "ALL")
	; Author ProgAndy
	; http://www.autoitscript.com/forum/index.php?s=&showtopic=76279&view=findpost&p=552973
	; possible bug in vista SP1 if there are multiple mountpoints : http://support.microsoft.com/kb/959573
	Local $i, $ret, $drives, $Buff = ""
	For $i = 0 To 100
		$Buff &= " "
	Next
	$drives = DriveGetDrive($Types)
	If @error Then Return SetError(@error, @extended, 0)
	For $i = 1 To $drives[0]
		$drives[$i] = StringUpper($drives[$i])
		$ret = DllCall("Kernel32.dll", "long", "GetVolumeNameForVolumeMountPoint", "str", $drives[$i] & "\", "str", $Buff, "dword", 100)
		If Not @error And $ret[0] <> 0 Then
			If StringStripWS($ret[2], 3) = $VolumeName Then Return $drives[$i]
		EndIf
	Next
	Return SetError(__WinAPI_GetLastError(), "Possible DLL Error", "")
EndFunc   ;==>_GetDriveByVolumeName_dll


; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_GetLastError
; Description ...: Returns the calling thread's lasterror code value
; Syntax.........: _WinAPI_GetLastError()
; Parameters ....:
; Return values .: Success      - Last error code
; Author ........: Paul Campbell (PaulIA)
; Modified.......:
; Remarks .......:
; Related .......: _WinAPI_GetLastErrorMessage
; Link ..........; @@MsdnLink@@ GetLastError
; Example .......;
; ===============================================================================================================================
Func __WinAPI_GetLastError()
	Local $aResult
	$aResult = DllCall("Kernel32.dll", "int", "GetLastError")
	If @error Then Return SetError(@error, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__WinAPI_GetLastError


Func _GetDriveByVolumeName_Reg($VolReg)
	$MD = "HKEY_LOCAL_MACHINE\SYSTEM\MountedDevices"
	$Volume = "\?" & StringMid($VolReg, 3, StringLen($VolReg) - 3)
	$VolReg = RegRead($MD, $Volume)
	For $i = 1 To 50
		$var = RegEnumVal($MD, $i)
		If @error <> 0 Then ExitLoop
		If RegRead($MD, $var) = $VolReg And StringLeft($var, 4) = "\Dos" Then $Drive = StringRight($var, 2)
	Next
	Return $Drive
EndFunc   ;==>_GetDriveByVolumeName_Reg