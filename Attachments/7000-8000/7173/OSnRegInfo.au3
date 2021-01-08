Dim $a[100]
For $i = 1 To 100
	$a[$i]=RegEnumKey ( "HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Time Zones", $i )
	If @error <> 0 then ExitLoop
	$var = RegRead ("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Time Zones\"&$a[$i],'Std')
	$var1 = RegRead ("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Time Zones\"&$a[$i],'Display')
	FileWriteLine(@ScriptDir & '\1234.txt', $var&','&$var1)
Next
FileWriteLine(@ScriptDir & '\1234.txt', "==========")
FileWriteLine(@ScriptDir & '\1234.txt', RegRead ("HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Time Zones",""))
FileWriteLine(@ScriptDir & '\1234.txt', "==========")
FileWriteLine(@ScriptDir & '\1234.txt', '@OSLang: ' & @OSLang & @CRLF &'@OSType: ' & @OSType & @CRLF &'@OSVersion: ' _
			& @OSVersion & @CRLF &'@OSBuild: ' & @OSBuild & @CRLF &'@OSServicePack: ' & @OSServicePack & @CRLF &'@ProcessorArch: ' _
			& @ProcessorArch & @CRLF)
FileWriteLine(@ScriptDir & '\1234.txt', "==========")
$a=0
Dim $a[100]
For $i = 1 To 100
	$a[$i]=RegEnumVal( "HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation", $i )
	If @error <> 0 then ExitLoop
	$var = RegRead ("HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\TimeZoneInformation",$a[$i])
	FileWriteLine(@ScriptDir & '\1234.txt', $a[$i]&','&$var)
Next