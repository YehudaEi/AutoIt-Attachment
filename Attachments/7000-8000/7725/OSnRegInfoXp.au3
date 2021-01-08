Dim $a[100]
For $i = 1 To 100
	$a[$i]=RegEnumKey ( "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones", $i )
	If @error <> 0 then ExitLoop
	$var = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\"&$a[$i],'Std')
	$var1 = RegRead ("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Time Zones\"&$a[$i],'Display')
	FileWriteLine(@ScriptDir & '\4321.txt', $var&','&$var1)
Next
FileWriteLine(@ScriptDir & '\4321.txt', "==========")
$a=0
Dim $a[100]
For $i = 1 To 100
	$a[$i]=RegEnumVal( "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\TimeZoneInformation", $i )
	If @error <> 0 then ExitLoop
	$var = RegRead ("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet002\Control\TimeZoneInformation",$a[$i])
	FileWriteLine(@ScriptDir & '\4321.txt', $a[$i]&','&$var)
Next
FileWriteLine(@ScriptDir & '\4321.txt', "==========")
FileWriteLine(@ScriptDir & '\4321.txt', '@OSLang: ' & @OSLang & @CRLF &'@OSType: ' & @OSType & @CRLF &'@OSVersion: ' _
			& @OSVersion & @CRLF &'@OSBuild: ' & @OSBuild & @CRLF &'@OSServicePack: ' & @OSServicePack & @CRLF &'@ProcessorArch: ' _
			& @ProcessorArch & @CRLF)
FileWriteLine(@ScriptDir & '\4321.txt', "==========")
$a=0
Dim $a[100]
For $i = 1 To 100
	$a[$i]=RegEnumVal( "HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\TimeZoneInformation", $i )
	If @error <> 0 then ExitLoop
	$var = RegRead ("HKEY_LOCAL_MACHINE\SYSTEM\ControlSet001\Control\TimeZoneInformation",$a[$i])
	FileWriteLine(@ScriptDir & '\4321.txt', $a[$i]&','&$var)
Next