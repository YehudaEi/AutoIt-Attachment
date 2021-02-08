#NoTrayIcon
#include <Date.au3>
#Include <Array.au3>
#include <ChildProc.au3>

Const $num_processes_to_fire = 10
Global $timer

$ans = MsgBox(260, "ChildProc_COPYDATA_test", "Benchmark the example?")

if $ans = 6 Then $timer = TimerInit()

ConsoleWrite("Process 1 Pid: " & @AutoItPID & @LF)

; Start a child process for each category search
for $i = 0 to ($num_processes_to_fire - 1)

	_ChildProc_WriteToEnvVar ($i & "ans", $ans)
	_ChildProc_WriteToEnvVar ($i & "variable1", "John loop #" & $i)
	_ChildProc_WriteToEnvVar ($i & "variable2", "Mark loop #" & $i)
	_ChildProc_WriteToEnvVar ($i & "variable3", "Tony loop #" & $i)
	_ChildProc_Start ("MultiProcessFunction", $i, 0)
	ConsoleWrite("Process " & ($i+2) & " Pid: " & $_ChildProc_pid[($_ChildProc_num_children-1)] & @CRLF)
Next

ConsoleWrite("time to spawn " & $num_processes_to_fire & " processes = " & TimerDiff($timer) & " ms")

; Wait until all above processes have completed
While _ChildProc_GetChildCount() > 0

	Sleep(250)
WEnd

if $ans <> 6 Then MsgBox(0, "ChildProc_EnvVar_File_test", "All child processes finished!")

; Collate / merge the output from all child processes
$text = _ChildProc_ReadFromAllFiles()

if $ans <> 6 Then MsgBox(0, "ChildProc_EnvVar_File_test", $text)
	
if $ans = 6 Then MsgBox(0, "ChildProc_EnvVar_File_test", "Example took " & int(TimerDiff($timer)) & " ms to complete")

; This function is started in a child process by "_ChildProc_Start" above.
Func MultiProcessFunction($msg)

	$ans = _ChildProc_ReadFromEnvVar ($msg & "ans")
	$variable1 = _ChildProc_ReadFromEnvVar ($msg & "variable1")
	$variable2 = _ChildProc_ReadFromEnvVar ($msg & "variable2")
	$variable3 = _ChildProc_ReadFromEnvVar ($msg & "variable3")

	if int($ans) <> 6 then
		
		MsgBox(0, "ChildProc_EnvVar_File_test - Child Process #" & $msg & " (PID: " & @AutoItPID & ")", "variable1 = " & $variable1 & @CRLF & _
																										"variable2 = " & $variable2 & @CRLF & _
																										"variable3 = " & $variable3 & @CRLF)
	EndIf

	_ChildProc_WriteToFile("", "Process finished with PID " & @AutoItPID & @CRLF)
EndFunc
