#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=security_center.ico
#AutoIt3Wrapper_Outfile=Windows 7 Security Center Service Repair.exe
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=thatguy2223
#AutoIt3Wrapper_Res_Description=Windows 7 Security Center Service Repair
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_Language=1033
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

If @OSArch = "X64" Then
If @OSVersion = "WIN_7" Then
$1 = MsgBox(1,"Info x64","This will restore the Windows 7 Security Center service. Restart is required.")
If $1 = 2 Then
Exit
Endif
one()
Else
MsgBox(0,"Error","Windows 7 Only")
Exit
Endif
Endif

If @OSArch = "X86" Then
If @OSVersion = "WIN_7" Then
$1 = MsgBox(1,"Info x86","This will restore the Windows 7 Security Center service. Restart is required.")
If $1 = 2 Then
Exit
Endif
two()
Else
MsgBox(0,"Error","Windows 7 Only")
Exit
Endif
Endif


Func one()
;Windows 7 Security Center service 32-bit
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DisplayName',"REG_SZ",'@%SystemRoot%\System32\wscsvc.dll,-200')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ErrorControl',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ImagePath',"REG_EXPAND_SZ",'%SystemRoot%\System32\svchost.exe -k LocalServiceNetworkRestricted')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Start',"REG_DWORD",0x00000002)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Type',"REG_DWORD",0x00000020)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Description',"REG_SZ",'@%SystemRoot%\System32\wscsvc.dll,-201')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DependOnService',"REG_MULTI_SZ",'RpcSs'&@LF&'WinMgmt')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ObjectName',"REG_SZ",'NT AUTHORITY\LocalService')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ServiceSidType',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','RequiredPrivileges',"REG_MULTI_SZ",'SeChangeNotifyPrivilege'&@LF&'SeImpersonatePrivilege')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DelayedAutoStart',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','FailureActions',"REG_BINARY","805101000000000000000000030000001400000001000000c0d4010001000000e09304000000000000000000")
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Parameters','ServiceDllUnloadOnStop',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Parameters','ServiceDll',"REG_EXPAND_SZ",'%SystemRoot%\System32\wscsvc.dll')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Security','Security',"REG_BINARY","01001480c8000000d4000000140000003000000002001c000100000002801400ff010f00010100000000000100000000020098000600000000001400fd01020001010000000000051200000000001800ff010f0001020000000000052000000020020000000014009d010200010100000000000504000000000014008d010200010100000000000506000000000014000001000001010000000000050b000000000028001500000001060000000000055000000049599d779156e555dcf4e20ea78bebca7b421356010100000000000512000000010100000000000512000000")
MsgBox(0,"Restore completed","Please restart your computer for the changes to take affect.")
EndFunc

Func two()
;Windows 7 Security Center service 64-bit
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DisplayName',"REG_SZ",'@%SystemRoot%\System32\wscsvc.dll,-200')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ErrorControl',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ImagePath',"REG_EXPAND_SZ",'%SystemRoot%\System32\svchost.exe -k LocalServiceNetworkRestricted')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Start',"REG_DWORD",0x00000002)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Type',"REG_DWORD",0x00000020)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','Description',"REG_SZ",'@%SystemRoot%\System32\wscsvc.dll,-201')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DependOnService',"REG_MULTI_SZ",'RpcSs'&@LF&'WinMgmt')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ObjectName',"REG_SZ",'NT AUTHORITY\LocalService')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','ServiceSidType',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','RequiredPrivileges',"REG_MULTI_SZ",'SeChangeNotifyPrivilege'&@LF&'SeImpersonatePrivilege')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','DelayedAutoStart',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc','FailureActions',"REG_BINARY","805101000000000000000000030000001400000001000000c0d4010001000000e09304000000000000000000")
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Parameters','ServiceDllUnloadOnStop',"REG_DWORD",0x00000001)
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Parameters','ServiceDll',"REG_EXPAND_SZ",'%SystemRoot%\System32\wscsvc.dll')
RegWrite('HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\wscsvc\Security','Security',"REG_BINARY","01001480c8000000d4000000140000003000000002001c000100000002801400ff010f00010100000000000100000000020098000600000000001400fd01020001010000000000051200000000001800ff010f0001020000000000052000000020020000000014009d010200010100000000000504000000000014008d010200010100000000000506000000000014000001000001010000000000050b000000000028001500000001060000000000055000000049599d779156e555dcf4e20ea78bebca7b421356010100000000000512000000010100000000000512000000")
MsgBox(0,"Restore completed","Please restart your computer for the changes to take affect.")
EndFunc