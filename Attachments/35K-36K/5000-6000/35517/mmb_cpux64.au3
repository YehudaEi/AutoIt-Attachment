Func _GetCPUzInfo()
FileInstall(".\Include\cpuz64.exe ",@TempDir & "\", 1)
RunWait(@TempDir &"\cpuz64.exe -txt=mysystem", @TempDir)
EndFunc