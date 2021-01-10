Global Const $PC = "\\MachineName"

Global Const $HKCR = 0x80000000
Global Const $HKCU = 0x80000001
Global Const $HKLM = 0x80000002
Global Const $HKU  = 0x80000003
Global Const $HKCC = 0x80000005



; Setup Array to hold list of SID's
$UserArray = _GetSIDArray()

; Loop through each Array element (SID)
For $i = 1 to UBound($UserArray)-1
	
	$test = RegGetTimeStamp($HKU, $UserArray[$i] & "\Volatile Environment")
		If $test <> "Registry Key Open Error!" then 
			; Write the SID and the Username
			ConsoleWrite($UserArray[$i] & @CRLF)
			consolewrite(@TAB & $test & @CRLF)
		EndIf
Next




Func RegGetTimeStamp($iRegHive, $sRegKey)
    Local $sRes='', $aRet, $hReg = DllStructCreate("int")
    Local $FILETIME = DllStructCreate("dword;dword")
    Local $SYSTEMTIME1 = DllStructCreate("ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort")
    Local $SYSTEMTIME2 = DllStructCreate("ushort;ushort;ushort;ushort;ushort;ushort;ushort;ushort")
    Local $hAdvAPI=DllOpen('advapi32.dll'), $hKernel=DllOpen('kernel32.dll')
    If $hAdvAPI=-1 Or $hKernel=-1 Then Return SetError(1, $aRet[0], 'DLL Open Error!')
	
	Dim $hRemoteReg
	
	$connect = DllCall("advapi32.dll", "int", "RegConnectRegistryA", _
		"str", "\\L74810", _
        "int", $HKU, _
        "ptr", DllStructGetPtr($hRemoteReg))
		
	
	$aRet = DllCall("advapi32.dll", "int", "RegOpenKeyEx", _
        "int", $hRemoteReg, "str", $sRegKey, _
        "int", 0, "int", 0x20019, _
        "ptr", DllStructGetPtr($hReg))
    If $aRet[0] Then Return SetError(2, $aRet[0], 'Registry Key Open Error!')
    $aRet = DllCall("advapi32.dll", "int", "RegQueryInfoKey", _
        "int", DllStructGetData($hReg,1), _
        "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, "ptr", 0, _
        "ptr", DllStructGetPtr($FILETIME))
    If $aRet[0] Then Return SetError(3, $aRet[0], 'Registry Key Query Error!')
    $aRet = DllCall("advapi32.dll", "int", "RegCloseKey", _
        "int", DllStructGetData($hReg,1))
    If $aRet[0] Then Return SetError(4, $aRet[0], 'Registry Key Close Error!')
    $aRet = DllCall("kernel32.dll", "int", "FileTimeToSystemTime", _
        "ptr", DllStructGetPtr($FILETIME), _
        "ptr", DllStructGetPtr($SYSTEMTIME1))
    If $aRet[0]=0 Then Return SetError(5, 0, 'Time Convert Error!')
    $aRet = DllCall("kernel32.dll", "int", "SystemTimeToTzSpecificLocalTime", _
        "ptr", 0, _
        "ptr", DllStructGetPtr($SYSTEMTIME1), _
        "ptr", DllStructGetPtr($SYSTEMTIME2))
    If $aRet[0]=0 Then Return SetError(5, 0, 'Time Convert Error!')
 	 $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,4)) &'/'
	 $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,2)) &'/'
	 $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,1)) &' '
     $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,5)) &':'
     $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,6)) &':'
     $sRes &= StringFormat("%.2d",DllStructGetData($SYSTEMTIME2,7))
    Return $sRes
EndFunc






Func _GetSIDArray()

	; Set Loop to Start at 1
	$SIDLoop = 1
	
	; Add .DEFAULT as it is not picked up in ProfileList
	$SIDCSV = ".DEFAULT"

	While 1
		; Read the first User SID
		$SID = RegEnumKey($PC & "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList", $SIDLoop)

		; Exit loop when no more User SID 
		If @error then ExitLoop

		; Get Username For SID
		$Username = _GetSIDUsername($SID)
		
		; Ignore System Accounts
		If StringUpper($Username) <> "SYSTEMPROFILE" and StringUpper($Username) <> "LOCALSERVICE" and StringUpper($Username) <> "NETWORKSERVICE" Then
			$SIDCSV = $SIDCSV & "," & $SID
		EndIf
					
		; Increase loop to read next User SID
		$SIDLoop = $SIDLoop + 1
	WEnd

	$SIDArray = StringSplit($SIDCSV, ",")

	Return $SIDArray
EndFunc

Func _GetSIDUsername($inSID)

	; If .Default then use DEFAULT as it does not exist in ProfileList
	If $inSID = ".DEFAULT" Then
		$outUsername = "DEFAULT"
	Else
		; Get Username For SID
		$UserProfileDir = RegRead($PC & "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList\" & $inSID, "ProfileImagePath")
		$outUsername = StringRight($UserProfileDir, StringLen($UserProfileDir) - StringInStr($UserProfileDir, "\", 0 , -1))
	EndIf
	
	Return $outUsername
EndFunc