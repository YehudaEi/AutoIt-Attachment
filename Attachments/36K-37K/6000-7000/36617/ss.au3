#include <Array.au3>
#include <WinAPI.au3>


Const $TH32CS_SNAPTHREAD = 4
Const $tagThread = "dword dwSize;dword cntUsage;dword th32ThreadID;" & _
                "dword th32OwnerProcessID;long tpBasePri;" & _
                "long tpDeltaPri;dword dwFlags"
 
 $iPID=ProcessExists("explorer.exe")
 $hWND = _WinAPI_OpenProcess(0x001F0FFF, True, $iPID, False)

$aThread = _EnumProcessThreads($iPID)
Dim $aThreadMoudle[UBound($aThread)]
For $i=0 To UBound($aThread)-1
	$hThread = _WinAPI_OpenThread(0x001F03FF,False,$aThread[$i],False)
	;MsgBox(0,"", _GetImageNameByThread($hWND,$hThread))
	;MsgBox(0,"",$hThread&@CRLF&$aThread[$i])
	;$aThreadMoudle[$i]=_GetThreadMoudle($hWND,$aThread[$i])
Next



_ArrayDisplay($aThread)
 
Func _GetImageNameByThread($hWND,$hThread, $fDebugPriv = False)
	Local $tClient_ID= DllStructCreate("ulong_ptr UniqueProcess;ulong_ptr UniqueThread;")
	Local $tTBI = DllStructCreate('long ExitStatus;ulong_ptr TebBaseAddress;'&DllStructGetPtr($tClient_ID)&' ClientId;long AffinityMask;long Priority;long BasePriority')
	; Attempt to open process with standard security priviliges
	Local $aResult = DllCall("ntdll.dll", "long", "ZwQueryInformationThread", "ptr", $hThread, "ulong", 9, "ptr", DllStructGetPtr($tTBI),"ulong",DllStructGetSize($tTBI),"ulong*",0)
	If @error Then 	Return SetError(@error, @extended, 0)
	If $aResult[3] Then	
		MsgBox(0,"","")
		Return $aResult[3]
	EndIf
	If Not $fDebugPriv Then Return 0
	; Enable debug privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then	Return SetError(@error, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iLastError = @extended
	Local $iRet = 0
	If Not @error Then
		; Attempt to open process with debug privileges
		$aResult = DllCall("ntdll.dll", "long", "ZwQueryInformationThread", "ptr", $hThread, "ulong", 9, "ptr", DllStructGetPtr($tTBI),"ulong",DllStructGetSize($tTBI),"ulong*",0)
		$iError = @error
		$iLastError = @extended
		$iRet = $aResult[3]
		; Disable debug privileged mode
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error
			$iLastError = @extended
		EndIf
	EndIf
	_WinAPI_CloseHandle($hToken)

	Return SetError($iError,  $iLastError, $iRet)


EndFunc
Func  _GetMappedFileName($hWND)
	
EndFunc

Func _WinAPI_OpenThread($iAccess, $fInherit, $iThreadID, $fDebugPriv = False)
	; Attempt to open process with standard security priviliges
	Local $aResult = DllCall("kernel32.dll", "handle", "OpenThread", "dword", $iAccess, "bool", $fInherit, "dword", $iThreadID)
	If @error Then Return SetError(@error, @extended, 0)
	If $aResult[0] Then	Return $aResult[0]
	If Not $fDebugPriv Then Return 0

	; Enable debug privileged mode
	Local $hToken = _Security__OpenThreadTokenEx(BitOR($TOKEN_ADJUST_PRIVILEGES, $TOKEN_QUERY))
	If @error Then Return SetError(@error, @extended, 0)
	_Security__SetPrivilege($hToken, "SeDebugPrivilege", True)
	Local $iError = @error
	Local $iLastError = @extended
	Local $iRet = 0
	If Not @error Then
		; Attempt to open process with debug privileges
		$aResult = DllCall("kernel32.dll", "handle", "OpenThread", "dword", $iAccess, "bool", $fInherit, "dword", $iThreadID)
		$iError = @error
		$iLastError = @extended
		If $aResult[0] Then $iRet = $aResult[0]
		; Disable debug privileged mode
		_Security__SetPrivilege($hToken, "SeDebugPrivilege", False)
		If @error Then
			$iError = @error
			$iLastError = @extended
		EndIf
	EndIf
	_WinAPI_CloseHandle($hToken)
	Return SetError($iError,  $iLastError, $iRet)
EndFunc   ;==>_WinAPI_OpenProcess

Func _EnumProcessThreads($iProcessId)
        Local $hSnapshot, $iThreadId, $iOwnerId, $tThread, $aResult[1]
 
        $iProcessId = ProcessExists($iProcessId)
        $tThread = _Thread32First($hSnapshot)
        $hSnapshot = _CreateToolhelp32Snapshot(0, $TH32CS_SNAPTHREAD)
 
        While True
                _Thread32Next($hSnapshot, $tThread)
                If @error Then ExitLoop
                $iThreadId = DllStructGetData($tThread, "th32ThreadID")
                $iOwnerId = DllStructGetData($tThread, "th32OwnerProcessID")
                If $iOwnerId = $iProcessId Then
                        $aResult[Ubound($aResult) - 1] = $iThreadId
                        Redim $aResult[Ubound($aResult) + 1]
                EndIf
        WEnd
        $tThread = 0
        _WinAPI_CloseHandle($hSnapshot)
        If Ubound($aResult) = 1 Then Return SetError(1, 0, 0)
        Redim $aResult[Ubound($aResult) - 1]
        Return SetError(0, Ubound($aResult), $aResult)
EndFunc ;==>_EnumProcessThreads()
 
 
Func _CreateToolhelp32Snapshot($iProcessId, $iFlag)
        Local $hSnapshot
 
        $iProcessId = ProcessExists($iProcessId)
        $hSnapshot = DllCall("Kernel32.Dll", "hWnd", "CreateToolhelp32Snapshot", _
                        "dword", $iFlag, "int", $iProcessId)
        Return $hSnapshot[0]
EndFunc ;==>_CreateToolhelp32Snapshot()
 
Func _Thread32First($hSnapshot)
        Local $tThread, $pThread, $iResult
 
        $tThread = DllStructCreate($tagThread)
        $pThread = DllStructGetPtr($tThread)
        DllStructSetData($tThread, 1, DllStructGetSize($tThread))
 
        $iResult = DllCall("Kernel32.Dll", "int", "Thread32First", _
                        "hWnd", $hSnapshot, _
                        "ptr", $pThread)
        Return SetError(Not $iResult[0], 0, $tThread)
EndFunc ;==>_Thread32First()
 
 
Func _Thread32Next($hSnapshot, ByRef $tThread)
        Local $iResult
 
        $iResult = DllCall("Kernel32.Dll", "int", "Thread32Next", _
                "hWnd", $hSnapshot, _
                "ptr", DllStructGetPtr($tThread))
        Return SetError(Not $iResult[0], 0, $iResult[0])
EndFunc ;==>_Thread32Next()