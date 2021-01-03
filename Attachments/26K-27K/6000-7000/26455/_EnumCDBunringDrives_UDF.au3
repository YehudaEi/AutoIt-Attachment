#region Example 
#include <array.au3>
$val = _Enum_CDBurningDrives()
_ArrayDisplay($val)
#EndRegion


Func _Enum_CDBurningDrives()
	; Author: Rajesh V R
	;  v1.0 dated 01 june 2009 
	; Function will return all the Drives which seem to support Windows XP Inbuilt CD Burning 
	; if the disc is not seen, it could be a virtual / unsupported / erraneous drive <http://support.microsoft.com/default.aspx?scid=kb;en-us;316529>
	
	Local $retVal[1][2], $i = 1
	While 1
		$i += 1
		ReDim $retVal[$i][2]
		$retVal[$i-1][0] = RegEnumKey("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\CD Burning\Drives", $i - 1)
		If @error <> 0 Then ExitLoop
		
		ConsoleWrite("\\?\" & $retVal[$i-1][0] & "\" & @CRLF )
		$retVal[$i-1][1] =  _GetDriveByVolumeName_dll("\\?\" & $retVal[$i-1][0] & "\")
		
	WEnd
	If StringInStr($retVal[UBound($retVal) - 1][0], "No more data is available.") Then ReDim $retVal[UBound($retVal) - 1][2]
	$retVal[0][0] = UBound($retVal) - 1
	Return $retVal
EndFunc   ;==>_Enum_CDBurningDrives


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
	Return SetError(2, __WinAPI_GetLastError(), "")
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



