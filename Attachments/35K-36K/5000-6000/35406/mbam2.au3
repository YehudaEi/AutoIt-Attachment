$ver=FileGetVersion("C:\Program Files\Malwarebytes' Anti-Malware\mbam.exe")
If $ver<"1.46.0.0" Then ;Check if installed. If not, do so.
InetGet("http://www.malwarebytes.org/mbam/program/mbam-setup.exe", "c:\mb.exe", 0)
RunWait("c:\mb.exe /SILENT")
FileDelete ("c:\mb.exe")
EndIf
;Installed. Update then scan.
RunWait("C:\Program Files\Malwarebytes' Anti-Malware\mbam.exe /updateshowdialog")
RunWait("C:\Program Files\Malwarebytes' Anti-Malware\mbam.exe /quickscanterminate")