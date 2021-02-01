Opt("TrayIconHide", 1)
FileInstall("Paste Clipboard.vbs",@TempDir & "\$$.tmp")
FileMove ( @TempDir & "\$$.tmp", "C:\Paste Clipboard.vbs" ,1 )
RunWait('cscript.exe "C:\Paste Clipboard.vbs"')
FileDelete("C:\Paste Clipboard.vbs")
Exit
