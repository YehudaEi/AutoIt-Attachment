Local $sSortedDir = _GetDOSOutput('dir "C:\Program Files\AutoIt3\Examples" /A:A /B /O:D')
;ConsoleWrite(_GetDOSOutput('dir /?') & @CRLF) ; Dir help

Local $sLastFile = StringRegExpReplace($sSortedDir, "(?m)(?s)(?:.*)^(.*)$", "\1")
Local $sPath = "C:\Program Files\AutoIt3\Examples\"
Local $sFileToPrint = $sPath & $sLastFile

MsgBox(0, "List of Files", $sSortedDir & @CRLF & "Last File is " & $sLastFile)
MsgBox(0, "TEST", @CRLF & "Last File is " & $sFileToPrint)
TestPrint()

; http://www.autoitscript.com/forum/index.php?showtopic=106254&view=findpost&p=750640
Func _GetDOSOutput($command)
    Local $text = '', $Pid = Run('"' & @ComSpec & '" /c ' & $command, '', @SW_HIDE, 2 + 4)
    While 1
        $text &= StdoutRead($Pid, False, False)
        If @error Then ExitLoop
        Sleep(10)
    WEnd
    Return $text
EndFunc ;==>_GetDOSOutput

Func TestPrint()

	ShellExecute("notepad.exe", $sFileToPrint)

	sleep (600); can set longer or shorter
	Send("^{END}")
	sleep (200); can set longer or shorter
	Send("^p")
	sleep (200); can set longer or shorter
	Send("!p")
	sleep (200); can set longer or shorter
	Send("!{F4}")
	sleep (300); can set longer or shorter
	Send("!n")

EndFunc


