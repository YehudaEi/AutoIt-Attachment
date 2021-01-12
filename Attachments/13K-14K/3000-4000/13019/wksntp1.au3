#comments-start
Set OS clock to syncronize with NTP server.
#comments-end

#NoTrayIcon
Opt("RunErrorsFatal",0)
Opt("MustDeclareVars",1)

Global $NTPServer = "ntp-server.mysite.mydomain";Host name or IP address
Global $WebPath = "                                       ";URL to time - see index.php
;Global $pass = "MyAdministratorPassword"

;Admin?
#comments-start
If IsAdmin() = 0 Then
 Local $temp = @TempDir
 FileCopy(@ScriptFullPath,$temp,1)
 RunAsSet("Administrator",@ComputerName,$pass)
 RunWait($temp & "\" & @ScriptName,$temp,@SW_HIDE)
 FileDelete($temp & "\" & @ScriptName)
 Exit(0)
EndIf
#comments-end

;Win2k?
If @OSVersion = "WIN_2000" Then
 RunWait(@ComSpec & " /c " & @SystemDir & '\net.exe time /SETSNTP:' & $NTPServer, "",@SW_HIDE)
EndIf

;WinXP?
If @OSVersion = "WIN_XP" Then
 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers","","REG_SZ","0")
 RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers","0","REG_SZ",$NTPServer)
 RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers","1");Not required
 RegDelete("HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\DateTime\Servers","2");Not required
 RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters","Type","REG_SZ","NTP")
 RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time\Parameters","NtpServer","REG_SZ",$NTPServer & ",0x1")
EndIf

RegWrite("HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\W32Time","Start","REG_DWORD",2)

;set time
;if the client and the server are too different, the client will declare the server's time
;as unreasonable and disregard it.
InetGet($WebPath,@TempDir & "\time.txt",1,0)
RunWait(@ComSpec & " /c " & 'time < "' & @TempDir & '\time.txt"',"",@SW_HIDE)
FileDelete(@TempDir & "\time.txt")

RunWait(@ComSpec & " /c " & @SystemDir & '\net.exe stop w32time',"",@SW_HIDE)
RunWait(@ComSpec & " /c " & @SystemDir & '\net.exe start w32time',"",@SW_HIDE)

If @OSVersion = "WIN_XP" Then
 RunWait(@ComSpec & " /c " & @SystemDir & "\w32tm.exe /resync","",@SW_HIDE)
EndIf

Exit(0)