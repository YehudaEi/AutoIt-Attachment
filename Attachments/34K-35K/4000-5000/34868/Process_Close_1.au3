;1test
$pid = Run('notepad.exe');, @TempDir, @SW_SHOW)
MsgBox(528448, "ProcessClose", "Run('notepad.exe')" & @CRLF _
		 & @CRLF & "Press Ok, to close process with $PID:" & @CRLF & $pid);, 10)
ProcessClose($pid)

;2test
$pid = Run(@ComSpec & ' /c notepad.exe');, @TempDir, @SW_SHOW)
MsgBox(528448, "ProcessClose", "Run(@ComSpec & ' /c notepad.exe')" & @CRLF _
		 & @CRLF & "Press Ok, to close process with $PID:" & @CRLF & $pid);, 10)
ProcessClose($pid)
