; Demonstrates StdoutRead()
#include <Constants.au3>
#AutoIt3Wrapper_Change2CUI=y
If $CmdLine[0] <> 1 Then
	ConsoleWrite("no parameter" & @CRLF)
Else
	Local $foo = Run(@ComSpec & " /c " & $CmdLine[1], @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Local $line
	While 1
		$line = StdoutRead($foo)
		If @error Then ExitLoop
		if $line  <> '' then ConsoleWrite($line & @CRLF)
	WEnd

	While 1
		$line = StderrRead($foo)
		If @error Then ExitLoop
		ConsoleWrite($line & @CRLF)
	WEnd
	ConsoleWrite("Exiting..." & @CRLF)
EndIf

