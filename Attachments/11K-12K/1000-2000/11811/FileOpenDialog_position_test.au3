
$Title= "Select file"
_Move($Title)
$file = FileOpenDialog($Title, @scriptdir, "(*.*)", 1,"")

Func _Move($Title)
        FileDelete(@TempDir & "\Dummy.txt")
        FileWrite(@TempDir & '\Dummy.txt','#NoTrayIcon' & @crlf & _
         'AutoItSetOption("RunErrorsFatal",0)' & @crlf & _
         'Opt("WinWaitDelay",0)' & @crlf & _
         'WinWait($cmdline[1],"")' & @crlf & _
         'WinMove($cmdline[1],"",@DesktopWidth/2-281,@DeskTopHeight/2-206)' & @crlf & _
         'FileDelete(@TempDir & "\Dummy.txt")')
         Run(@AutoItExe & ' /AutoIt3ExecuteScript ' & @TempDir & '\Dummy.txt "' & $Title & '"')
EndFunc
