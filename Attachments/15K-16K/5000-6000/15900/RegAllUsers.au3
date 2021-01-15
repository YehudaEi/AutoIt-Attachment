#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         Sean Hart

 Script Function:
	UDFs to write or delete registry keys from all user profiles on the system.
	
	Uses RegLoadHive functions provided by Larry

#ce ----------------------------------------------------------------------------


; === RegWriteAllUsers ===
; Writes "current user" registry data to every user profile on the system.
; Requires RegLoadHive and RegUnLoadHive functions.
;
; Inputs:	$key	- see RegWrite function for details (no HKU\HKCU\HKLM required)
;			$value	- see RegWrite function for details
;			$type	- see RegWrite function for details
;			$data	- see RegWrite function for details
;
; Returns:	nothing
Func RegWriteAllUsers($key, $value, $type, $data)
	Dim $i, $curkey, $ExpandEnvStrings, $profiledir, $curdir, $search
	
	; init variables
	$i = 1
	$error = 0
	$ExpandEnvStrings = Opt("ExpandEnvStrings",1)
	$profiledir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList", "ProfilesDirectory")
	
	; change directory to profile directory
	$curdir = @WorkingDir
	FileChangeDir($profiledir)
	
	; replace HKU / HKCU / HKLM in key if require
	Select
	Case StringLeft($key, 4) = "HKU\"
		$key = StringRight($key, StringLen($key) - 4)
	Case StringLeft($key, 5) = "HKCU\"
		$key = StringRight($key, StringLen($key) - 5)
	Case StringLeft($key, 5) = "HKLM\"
		$key = StringRight($key, StringLen($key) - 5)
	Case StringLeft($key, 11) = "HKEY_USERS\"
		$key = StringRight($key, StringLen($key) - 11)
	Case StringLeft($key, 18) = "HKEY_CURRENT_USER\"
		$key = StringRight($key, StringLen($key) - 18)
	Case StringLeft($key, 19) = "HKEY_LOCAL_MACHINE\"
		$key = StringRight($key, StringLen($key) - 19)
	EndSelect
	
	; Go through all directories where ntuser.dat is accessible
	$search = FileFindFirstFile("*.*")
	$dir = FileFindNextFile($search)
	While @error = 0
		; Process directories
		If StringInStr(FileGetAttrib($profiledir & "\" & $dir), "D") Then
			; Check for ntuser.dat
			If FileExists($profiledir & "\" & $dir & "\ntuser.dat") Then
				; Try and load hive
				If RegLoadHive("TempUser", $profiledir & "\" & $dir & "\ntuser.dat") Then
					; Apply new registry data
					RegWrite("HKEY_USERS\TempUser\" & $key, $value, $type, $data)
					
					; Unload hive
					RegUnloadHive("TempUser")
				EndIf
			EndIf
		EndIf
		$dir = FileFindNextFile($search)
	WEnd
	
	; Start by going through all currently logged on user keys (exclude system accounts and classes)
	$curkey = RegEnumKey("HKEY_USERS", $i)
	While @error = 0
		If (StringLen($curkey) > 8) And (Not StringInStr($curkey, "_Classes")) Then
			RegWrite("HKEY_USERS\" & $curkey & "\" & $key, $value, $type, $data)
		EndIf
		$i = $i + 1
		$curkey = RegEnumKey("HKEY_USERS", $i)
	WEnd
	
	; Put settings back and change back to previous directory
	Opt("ExpandEnvStrings",$ExpandEnvStrings)
	FileChangeDir($curdir)
	
EndFunc
; === END RegWriteAllUsers ===


; === RegDeleteAllUsers ===
; Deletes "current user" registry data from every user profile on the system.
; Requires RegLoadHive and RegUnLoadHive functions.
;
; Inputs:	$key	- see RegDelete function for details (no HKU\HKCU\HKLM required)
;			$value	- (optional) see RegDelete function for details
;
; Returns:	nothing
Func RegDeleteAllUsers($key, $value = "ÿ")
	Dim $i, $curkey, $ExpandEnvStrings, $profiledir, $curdir, $search
	
	; init variables
	$i = 1
	$error = 0
	$ExpandEnvStrings = Opt("ExpandEnvStrings",1)
	$profiledir = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\ProfileList", "ProfilesDirectory")
	
	; change directory to profile directory
	$curdir = @WorkingDir
	FileChangeDir($profiledir)
	
	; replace HKU / HKCU / HKLM in key if require
	Select
	Case StringLeft($key, 4) = "HKU\"
		$key = StringRight($key, StringLen($key) - 4)
	Case StringLeft($key, 5) = "HKCU\"
		$key = StringRight($key, StringLen($key) - 5)
	Case StringLeft($key, 5) = "HKLM\"
		$key = StringRight($key, StringLen($key) - 5)
	Case StringLeft($key, 11) = "HKEY_USERS\"
		$key = StringRight($key, StringLen($key) - 11)
	Case StringLeft($key, 18) = "HKEY_CURRENT_USER\"
		$key = StringRight($key, StringLen($key) - 18)
	Case StringLeft($key, 19) = "HKEY_LOCAL_MACHINE\"
		$key = StringRight($key, StringLen($key) - 19)
	EndSelect

	; Go through all directories where ntuser.dat is accessible
	$search = FileFindFirstFile("*.*")
	$dir = FileFindNextFile($search)
	While @error = 0
		; Process directories
		If StringInStr(FileGetAttrib($profiledir & "\" & $dir), "D") Then
			; Check for ntuser.dat
			If FileExists($profiledir & "\" & $dir & "\ntuser.dat") Then
				; Try and load hive
				If RegLoadHive("TempUser", $profiledir & "\" & $dir & "\ntuser.dat") Then
					; Delete registry data
					If $value = "ÿ" Then
						RegDelete("HKEY_USERS\TempUser\" & $key)
					Else
						RegDelete("HKEY_USERS\TempUser\" & $key, $value)
					EndIf
					
					; Unload hive
					RegUnloadHive("TempUser")
				EndIf
			EndIf
		EndIf
		$dir = FileFindNextFile($search)
	WEnd
	
	; Start by going through all currently logged on user keys (exclude system accounts and classes)
	$curkey = RegEnumKey("HKEY_USERS", $i)
	While @error = 0
		If (StringLen($curkey) > 8) And (Not StringInStr($curkey, "_Classes")) Then
			; Delete registry data
			If $value = "ÿ" Then
				RegDelete("HKEY_USERS\" & $curkey & "\" & $key)
			Else
				RegDelete("HKEY_USERS\" & $curkey & "\" & $key, $value)
			EndIf
		EndIf
		$i = $i + 1
		$curkey = RegEnumKey("HKEY_USERS", $i)
	WEnd
	
EndFunc
; === END RegDeleteAllUsers ===


; === RegLoadHive ===
; Loads a ntuser.dat file as a registry hive
; Requires SetPrivilege function.
;
; Inputs:	$hiveName		- name for the hive
;			$NTUSER_datFile	- full path to ntuser.dat file to load
;			$RLH_key		- (optional) root for hive (defaults to HKU)
;
; Returns:	1 - Successful
;			0 - Error (sets @error)
Func RegLoadHive($hiveName, $NTUSER_datFile, $RLH_key = "HKU")
    If Not (@OSTYPE=="WIN32_NT") Then
        SetError(-1)
        Return 0
    EndIf
    Const $HKEY_LOCAL_MACHINE = 0x80000002
    Const $HKEY_USERS = 0x80000003
    Const $SE_RESTORE_NAME = "SeRestorePrivilege"
    Const $SE_BACKUP_NAME = "SeBackupPrivilege"
    Local $RLH_ret
    Local $aPriv[2]
    If $RLH_key = "HKLM" Then
        $RLH_key = $HKEY_LOCAL_MACHINE
    ElseIf $RLH_key = "HKU" Then
        $RLH_key = $HKEY_USERS
    Else
        SetError(-2)
        Return 0
    EndIf
    $aPriv[0] = $SE_RESTORE_NAME
    $aPriv[1] = $SE_BACKUP_NAME
    SetPrivilege($aPriv,1)
    $RLH_ret = DllCall("Advapi32.dll","int","RegLoadKey","int",$RLH_key,"str",$hiveName,"str",$NTUSER_datFile)
    SetError($RLH_ret[0])
    Return Not $RLH_ret[0]
EndFunc
; === END RegLoadHive ===


; === RegUnloadHive ===
; Unloads a registry hive
; Requires SetPrivilege function.
;
; Inputs:	$hiveName		- name for the hive
;			$RLH_key		- (optional) root for hive (defaults to HKU)
;
; Returns:	1 - Successful
;			0 - Error (sets @error)
Func RegUnloadHive($hiveName, $RUH_key = "HKU")
    If Not (@OSTYPE=="WIN32_NT") Then
        SetError(-1)
        Return 0
    EndIf
    Const $HKEY_LOCAL_MACHINE = 0x80000002
    Const $HKEY_USERS = 0x80000003
    Local $RUH_ret
    If $RUH_key = "HKLM" Then
        $RUH_key = $HKEY_LOCAL_MACHINE
    ElseIf $RUH_key = "HKU" Then
        $RUH_key = $HKEY_USERS
    Else
        SetError(-2)
        Return 0
    EndIf
    $RUH_ret = DllCall("Advapi32.dll","int","RegUnLoadKey","int",$RUH_key,"Str",$hiveName)
    Return Not $RUH_ret[0]
EndFunc
; === RegUnloadHive ===


; === SetPrivilege ===
; Special function for use with registry hive functions
Func SetPrivilege( $privilege, $bEnable )
    Const $TOKEN_ADJUST_PRIVILEGES = 0x0020
    Const $TOKEN_QUERY = 0x0008
    Const $SE_PRIVILEGE_ENABLED = 0x0002
    Local $hToken, $SP_auxret, $SP_ret, $hCurrProcess, $nTokens, $nTokenIndex, $priv
    $nTokens = 1
    $LUID = DLLStructCreate("dword;int")
    If IsArray($privilege) Then    $nTokens = UBound($privilege)
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
    $NEWTOKEN_PRIVILEGES = 0
    $TOKEN_PRIVILEGES = 0
    $LUID = 0
    If $SP_auxret[0] = 0 Then Return 0
    $SP_auxret = DLLCall("kernel32.dll","int","CloseHandle","hwnd",$hToken)
    If Not $ret[0] And Not $SP_auxret[0] Then Return 0
    return $ret[0]
EndFunc
; === SetPrivilege ===
