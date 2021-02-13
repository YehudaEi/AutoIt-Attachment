AutoItSetOption ("ExpandEnvStrings", 1)
$runningexe="plink"
$logfilename="%userprofile%\logging.log"
#Include <Date.au3>
#include <Constants.au3>
$logfile = FileOpen($logfilename,1)
If $logfile = -1 Then
	MsgBox (16, "Error", "Can't open " & $logfilename & " for writing")
	Exit (1)
EndIf

; MAIN LOOP
for $i=1 to 2000
	check_command()
Next

Func _getDOSOutput($command)
	Local $text = ''
	$Pid = Run($command, '', @SW_HIDE, $STDIN_CHILD + $STDERR_CHILD + $STDOUT_CHILD)
 	While 1
		$text &= StdoutRead($Pid)
	    If @error Then ExitLoop
		Sleep(10)
	WEnd
    Return $text
EndFunc

Func logging($line)
	If FileWrite($logfile, _NowTime() & "  " & $line & @CRLF) = 0 Then
		MsgBox (16, "Error", "Can't log to " & $logfilename)
		Exit (1)
	EndIf
EndFunc

Func check_command()
	Local $results = _getDOSOutput($runningexe & " -V")
	logging("Results: " & $results)
	If $results = "" Then
		logging("Error: no results")
	EndIf
EndFunc