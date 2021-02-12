Func _tagTOKEN_PRIVILEGES($iPrivilegeCount)
    If Not ( IsInt($iPrivilegeCount) And $iPrivilegeCount > 0 ) Then Return SetError(-1, 0, "")
    Local $tagTOKEN_PRIVILEGES = "dword PrivilegeCount;"
    For $i = 0 To $iPrivilegeCount - 1
        $tagTOKEN_PRIVILEGES &= "dword LowPart" & $i & ";long HighPart" & $i & ";dword Attributes" & $i & ";"
    Next
    Return StringTrimRight($tagTOKEN_PRIVILEGES, 1)
EndFunc




Func SetTimeZoneInformation($iBias, $sStdName, $tStdDate, $iStdBias, $sDayName, $tDayDate, $iDayBias)
	_DebugOut("SetTimeZoneInformation")
	Local $tStdName = _WinAPI_MultiByteToWideChar($sStdName)
	Local $tDayName = _WinAPI_MultiByteToWideChar($sDayName)
	Local $tZoneInfo = DllStructCreate($tagTIME_ZONE_INFORMATION)
	DllStructSetData($tZoneInfo, "Bias", $iBias)
	DllStructSetData($tZoneInfo, "StdName", DllStructGetData($tStdName, 1))
	_MemMoveMemory(DllStructGetPtr($tStdDate), DllStructGetPtr($tZoneInfo, "StdDate"), DllStructGetSize($tStdDate))
	DllStructSetData($tZoneInfo, "StdBias", $iStdBias)
	DllStructSetData($tZoneInfo, "DayName", DllStructGetData($tDayName, 1))
	_MemMoveMemory(DllStructGetPtr($tDayDate), DllStructGetPtr($tZoneInfo, "DayDate"), DllStructGetSize($tDayDate))
	DllStructSetData($tZoneInfo, "DayBias", $iDayBias)

	Local $aResult = DllCall("kernel32.dll", "handle", "GetCurrentProcess")
	If @error Then 
		_DebugOut("error 1")
		Return SetError(@error, @extended, False)
	EndIf
	Local $proc = $aResult[0]

	Local $aResult2 = DllCall("advapi32.dll", "int", "OpenProcessToken", "handle", $proc, "dword", BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY), "ptr*", 0)
	If @error Then 
		_DebugOut("error 2")
		Return SetError(@error, @extended, False)
	ENdIf
	Local $hToken = $aResult2[3]

	Local $res = SetPrivilege($hToken, "SeTimeZonePrivilege", True)
	$res = BitAnd($res, SetPrivilege($hToken, "SeSystemTimePrivilege", True))

	Local $iError = @error
	Local $iLastError = @extended
	Local $iRet = False
	If Not @error Then
		; Set time zone information
		Local $aResult = DllCall("kernel32.dll", "bool", "SetTimeZoneInformation", "ptr", DllStructGetPtr($tZoneInfo))
		If @error Then
			$iError = @error
			$iLastError = @extended
			_DebugOut("error 3 " & $iLastError)
		ElseIf $aResult[0] Then
			$iLastError = 0
			$iRet = True
		Else
			$iError = 1
			$iLastError = _WinAPI_GetLastError()
			_DebugOut("error 4 " & $iLastError)
		EndIf

		; Disable system time privileged mode
		SetPrivilege($hToken, "SeSystemTimePrivilege", False)
		SetPrivilege($hToken, "SeTimeZonePrivilege", False)
		If @error Then 
			$iError = 2
			_DebugOut("error 6 " & $iLastError)	
		EndIf			
	Else
			_DebugOut("error 5 " & $iLastError)	
	EndIf
	
	_WinAPI_CloseHandle($hToken)

	_DebugOut("Errors: " & $iError & ", " & $iLastError & ", " & $iRet)
	Return SetError($iError,  $iLastError, $iRet)
EndFunc   ;==>_Date_Time_SetTimeZoneInformation




Func SetPrivilege($hToken, $sPrivilege, $fEnable)
	_DebugOut("SetPrivilege")

    Local $pRequired, $tRequired, $iLUID, $iAttributes, $iCurrState, $pCurrState, $tCurrState, $iPrevState, $pPrevState, $tPrevState

    $iLUID = _Security__LookupPrivilegeValue("", $sPrivilege)
    If $iLUID = 0 Then Return SetError(-1, 0, False)

    $tCurrState = DllStructCreate( _tagTOKEN_PRIVILEGES(1) )
    $pCurrState = DllStructGetPtr($tCurrState)
    $iCurrState = DllStructGetSize($tCurrState)
    $tPrevState = DllStructCreate( _tagTOKEN_PRIVILEGES(1) )
    $pPrevState = DllStructGetPtr($tPrevState)
    $iPrevState = DllStructGetSize($tPrevState)
    $tRequired = DllStructCreate("int Data")
    $pRequired = DllStructGetPtr($tRequired)
    ; Get current privilege setting
    DllStructSetData($tCurrState, "PrivilegeCount", 1)
    DllStructSetData($tCurrState, "LowPart0", $iLUID)
    If Not _Security__AdjustTokenPrivileges($hToken, False, $pCurrState, $iCurrState, $pPrevState, $pRequired) Then
        Return SetError(-2, @error, False)
    EndIf
    ; Set privilege based on prior setting
    DllStructSetData($tPrevState, "PrivilegeCount", 1)
    DllStructSetData($tPrevState, "LowPart0", $iLUID)
    $iAttributes = DllStructGetData($tPrevState, "Attributes0")
    If $fEnable Then
        $iAttributes = BitOR($iAttributes, $SE_PRIVILEGE_ENABLED)
    Else
        $iAttributes = BitAND($iAttributes, BitNOT($SE_PRIVILEGE_ENABLED))
    EndIf
    DllStructSetData($tPrevState, "Attributes0", $iAttributes)
    If Not _Security__AdjustTokenPrivileges($hToken, False, $pPrevState, $iPrevState, $pCurrState, $pRequired) Then
        Return SetError(-3, @error, False)
    EndIf
    Return SetError(0, 0, True)
EndFunc   ;==>_Security__SetPrivilege



