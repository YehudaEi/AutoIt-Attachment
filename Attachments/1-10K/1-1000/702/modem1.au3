;Creates Modem.txt file
$file = FileOpen("Modem.txt", 1)

; Check if file opened for writing OK
If $file = -1 Then
   MsgBox(0, "Error", "Please contact Local IT.")
   Exit
EndIf

FileWriteLine($file, "User none")
FileWriteLine($file, "cd dl")
FileWriteLine($file, "lcd c:\Options")
FileWriteLine($file, "binary")
FileWriteLine($file, "mput user.ini")
FileWriteLine($file, "quit")
FileClose($file)

Global $user
Global $passwd1
Global $passwd2

$MAC_addr = _GetMAC()
MsgBox(64, "Test", "MAC address: " & $MAC_addr)

Func _GetMAC()
  Local $IniFile
  $IniFile = @TempDir & "\SysInfo.ini"
  If NOT FileExists(@TempDir & "\SysInfo.bat") Then
     Local $OpenBatch
     $OpenBatch = FileOpen(@TempDir & "\SysInfo.bat", 2)
        FileWriteLine($OpenBatch, '@ECHO OFF')
        FileWriteLine($OpenBatch, 'SET INIFILE=%TEMP%\SysInfo.ini')
        FileWriteLine($OpenBatch, 'ECHO [SystemInfo]> %INIFILE%')
        FileWriteLine($OpenBatch, 'FOR /F "tokens=1,2 delims=:" %%I IN (''IPCONFIG /ALL ^| FIND /I "physical"'') DO SET MAC=%%J')
        FileWriteLine($OpenBatch, 'SET MAC=%MAC:~1,-1%')
        FileWriteLine($OpenBatch, 'ECHO MacAddr=%MAC%>> %INIFILE%')
     FileClose($OpenBatch)
  EndIf
  RunWait(@TempDir & "\SysInfo.bat", @SystemDir, @SW_HIDE)
  Return INIRead($IniFile, "SystemInfo", "MacAddr", "")
EndFunc

$user = User()
Do
   $passwd1 = Pass(1)
   $passwd2 = Pass(2)
   
   If NOT ($passwd1 == $passwd2) Then
      MsgBox(4096, "Wrong Password", "The passwords you typed do not match.")
   EndIf
Until $passwd1 == $passwd2

MsgBox(4096, "Test", $user)
Connect($user, $passwd1)
      
Func User()
   Local $val
   $val = InputBox("", "Enter your username.", "", "")
   If @error Then
      EXIT
   Else
      Return $val
   EndIf
EndFunc

Func Pass($num)
   Local $msg
   Local $passw
   If $num = 1 Then
      $msg = "Password" & "|" & "Enter your password."
   Else
      $msg = "Confirm Password" & "|" &  "Enter your password again."
   EndIf
   $msg = StringSplit($msg, "|")
   $passw = InputBox($msg[1], $msg[2], "", "*")
   If @error Then
      EXIT
   Else
      Return $passw
   EndIf
EndFunc

Func Connect($username, $password)
  IniWrite("user.ini", "env.ini", 'set var="PPPoE_userid" value', '"' & $username & '"')
  IniWrite("user.ini", "env.ini", 'set var="PPPoE_passwrd" value', '"' & $password & '"')
  IniWrite("user.ini", "env.ini", 'set var="HOST_NAME" value', '"' & @ComputerName & '"')
  IniWrite("user.ini", "env.ini", 'set var="HOST_MAC_ADDR" value', '"' & $MAC_addr & '"')
  RunWait(@COMSPEC & " /c c:\windows\system32\ftp.exe -n -i -s:c:\Options\Modem.txt 192.168.0.254")
EndFunc

Func Connect_myversion($username, $password)
   ;How I would do it
   IniWrite("user.ini", "env.ini", "PPPoE_userid", $username)
;   IniWrite("user.ini", "env.ini", "PPPoE_passwrd", $passwdord)
   RunWait(@COMSPEC & " /c c:\windOWS\system32\ftp.exe -n -i -s:c:\Options\Modem.txt 192.168.0.254")
EndFunc

;FileDelete($file)


