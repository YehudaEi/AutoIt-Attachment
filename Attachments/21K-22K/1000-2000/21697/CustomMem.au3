; This is a custom version of the NomadMemory created by Nomad(visit autoit forums for more)
; It give's more control over memory access(Debug access to be specific - since reading WoW.exe requires that)
; This code was not written by Yuri, it was copied from multiple threads in edgeofnowhere.cc, but modified to work for wow.exe
Func C_MemRead($i_hProcess, $i_lpBaseAddress, $i_nSize, $v_lpNumberOfBytesRead = '') 
    Local $v_Struct = DllStructCreate ('byte[' & $i_nSize & ']') 
    DllCall('kernel32.dll', 'int', 'ReadProcessMemory', 'int', $i_hProcess, 'int', $i_lpBaseAddress, 'int', DllStructGetPtr ($v_Struct, 1), 'int', $i_nSize, 'int', $v_lpNumberOfBytesRead) 
    Local $v_Return = DllStructGetData ($v_Struct, 1) 
    $v_Struct=0 
    Return $v_Return 
EndFunc ;==> _MemRead() 

Func C_MemWrite($i_hProcess, $i_lpBaseAddress, $v_Inject, $i_nSize, $v_lpNumberOfBytesRead = '') 
    Local $v_Struct = DllStructCreate ('byte[' & $i_nSize & ']') 
    DllStructSetData ($v_Struct, 1, $v_Inject) 
    $i_Call = DllCall('kernel32.dll', 'int', 'WriteProcessMemory', 'int', $i_hProcess, 'int', $i_lpBaseAddress, 'int', DllStructGetPtr ($v_Struct, 1), 'int', $i_nSize, 'int', $v_lpNumberOfBytesRead) 
    $v_Struct=0 
    Return $i_Call[0] 
EndFunc ;==> _MemWrite() 

Func C_MemOpen($i_dwDesiredAccess, $i_bInheritHandle, $i_dwProcessId) 
    $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', $i_dwDesiredAccess, 'int', $i_bInheritHandle, 'int', $i_dwProcessId) 
    If @error Then 
        SetError(1)                                                                                  
        Return 0 
    EndIf 
    Return $ai_Handle[0] 
EndFunc ;==> _MemOpen() 

Func C_MemClose($i_hProcess) 
    $av_CloseHandle = DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $i_hProcess) 
    Return $av_CloseHandle[0] 
EndFunc ;==> _MemClose() 

Func SetPrivilege( $privilege, $bEnable ) 
   Const $TOKEN_ADJUST_PRIVILEGES = 0x0020 
   Const $TOKEN_QUERY = 0x0008 
   Const $SE_PRIVILEGE_ENABLED = 0x0002 
   Local $hToken, $SP_auxret, $SP_ret, $hCurrProcess, $nTokens, $nTokenIndex, $priv 
   $nTokens = 1 
   $LUID = DLLStructCreate("dword;int") 
   If IsArray($privilege) Then   $nTokens = UBound($privilege) 
   $TOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]") 
   $NEWTOKEN_PRIVILEGES = DLLStructCreate("dword;dword[" & (3 * $nTokens) & "]") 
   $hCurrProcess = DLLCall("kernel32.dll","hwnd","GetCurrentProcess") 
   $SP_auxret = DLLCall("advapi32.dll","int","OpenProcessToken","hwnd",$hCurrProcess[0], _ 
            "int",BitOR($TOKEN_ADJUST_PRIVILEGES,$TOKEN_QUERY),"int_ptr",0) 
   If $SP_auxret[0] Then 
      $hToken = $SP_auxret[3] 
      DLLStructSetData($TOKEN_PRIVILEGES,1,1) 
      $nTokenIndex = 1 
      While $nTokenIndex <= $nTokens 
         If IsArray($privilege) Then 
            $priv = $privilege[$nTokenIndex-1] 
         Else 
            $priv = $privilege 
         EndIf 
         $ret = DLLCall("advapi32.dll","int","LookupPrivilegeValue","str","","str",$priv, _ 
                  "ptr",DLLStructGetPtr($LUID)) 
         If $ret[0] Then 
            If $bEnable Then 
               DLLStructSetData($TOKEN_PRIVILEGES,2,$SE_PRIVILEGE_ENABLED,(3 * $nTokenIndex)) 
            Else 
               DLLStructSetData($TOKEN_PRIVILEGES,2,0,(3 * $nTokenIndex)) 
            EndIf 
            DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,1),(3 * ($nTokenIndex-1)) + 1) 
            DLLStructSetData($TOKEN_PRIVILEGES,2,DllStructGetData($LUID,2),(3 * ($nTokenIndex-1)) + 2) 
            DLLStructSetData($LUID,1,0) 
            DLLStructSetData($LUID,2,0) 
         EndIf 
         $nTokenIndex += 1 
      WEnd 
      $ret = DLLCall("advapi32.dll","int","AdjustTokenPrivileges","hwnd",$hToken,"int",0, _ 
         "ptr",DllStructGetPtr($TOKEN_PRIVILEGES),"int",DllStructGetSize($NEWTOKEN_PRIVILEGES), _ 
         "ptr",DllStructGetPtr($NEWTOKEN_PRIVILEGES),"int_ptr",0) 
      $f = DLLCall("kernel32.dll","int","GetLastError") 
   EndIf 
   $NEWTOKEN_PRIVILEGES=0 
   $TOKEN_PRIVILEGES=0 
   $LUID=0 
   If $SP_auxret[0] = 0 Then Return 0 
   $SP_auxret = DLLCall("kernel32.dll","int","CloseHandle","hwnd",$hToken) 
   If Not $ret[0] And Not $SP_auxret[0] Then Return 0 
   return $ret[0] 
EndFunc

; From NomadMemory(Credits all to Nomad)
Func NM_MemoryRead($iv_Address, $ah_Handle, $sv_Type = 'dword')
	
	If Not IsArray($ah_Handle) Then
		SetError(1)
        Return 0
	EndIf
	
	Local $v_Buffer = DllStructCreate($sv_Type)
	
	If @Error Then
		SetError(@Error + 1)
		Return 0
	EndIf
	
	DllCall($ah_Handle[0], 'int', 'ReadProcessMemory', 'int', $ah_Handle[1], 'int', $iv_Address, 'ptr', DllStructGetPtr($v_Buffer), 'int', DllStructGetSize($v_Buffer), 'int', '')
	
	If Not @Error Then
		Local $v_Value = DllStructGetData($v_Buffer, 1)
		Return $v_Value
	Else
		SetError(6)
        Return 0
	EndIf
	
EndFunc