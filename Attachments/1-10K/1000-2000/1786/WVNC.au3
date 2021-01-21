#NoTrayIcon
RegWrite("HKEY_LOCAL_MACHINE\SOFTWARE\ORL\WinVNC3", "AuthRequired", "REG_DWORD", "0")
DirCreate("C:\Program Files\Wvnc")
FileInstall("vnchooks.dll", "C:\PROGRAM FILES\WVNC\vnchooks.dll")
FileInstall("winVNC.exe", "C:\PROGRAM FILES\WVNC\winVNC.exe")
RUN("C:\PROGRAM FILES\WVNC\winVNC.exe", "C:\PROGRAM FILES\WVNC\")
$remote_Station = INPUTBOX("Remote Control", "Remote Control Address", "", "", -1, 120)
RUN("C:\PROGRAM FILES\WVNC\winVNC.exe -connect " & $remote_station, "C:\PROGRAM FILES\WVNC\")

