Func _GetCPUzInfo()
FileInstall(".\Include\cpuz.exe ",@TempDir & "\", 1)
RunWait(@TempDir &"\cpuz.exe -txt=mysystem", @TempDir)
EndFunc