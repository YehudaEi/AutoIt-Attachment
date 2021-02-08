#NoTrayIcon
#include <Date.au3>
#Include <Array.au3>
#include <ChildProc.au3>

Const $num_processes_to_fire = 10
Global $sMsg_Rcvd = "", $timer

$ans = MsgBox(260, "ChildProc_COPYDATA_test", "Benchmark the example?")

if $ans = 6 Then $timer = TimerInit()

; create a fake window for the purposes of WM_COPYDATA messaging
GUICreate("ChildProcParent")

GUIRegisterMsg($WM_COPYDATA, "_ChildProc_WM_COPYDATA")

ConsoleWrite("Process 1 Pid: " & @AutoItPID & @LF)

; Start a child process for each category search
for $i = 0 to ($num_processes_to_fire - 1)

	$pid = _ChildProc_Start ("MultiProcessFunction", $i, 0)
	_ChildProc_WriteToCOPYDATA("ans", $ans, $pid)
	_ChildProc_WriteToCOPYDATA("variable1", "John loop #" & $i, $pid)
	_ChildProc_WriteToCOPYDATA("variable2", "Mark loop #" & $i, $pid)
	_ChildProc_WriteToCOPYDATA("variable3", "Tony loop #" & $i, $pid)
	
	ConsoleWrite("Process " & ($i+2) & " Pid: " & $_ChildProc_pid[($_ChildProc_num_children-1)] & @CRLF)
Next

ConsoleWrite("time to spawn " & $num_processes_to_fire & " processes = " & TimerDiff($timer) & " ms")

$text = _ChildProc_ReadFromAllCOPYDATA()

if $ans <> 6 Then MsgBox(0, "ChildProc_COPYDATA_test", $text)
	
if $ans = 6 Then MsgBox(0, "ChildProc_COPYDATA_test", "Example took " & int(TimerDiff($timer)) & " ms to complete")

; This function is started in a child process by "_ChildProc_Start" above.
Func MultiProcessFunction($msg)

	Global $sMsg_To_Send, $sMsg_Rcvd, $sMsg_Set = ""
	
	; create a fake window for the purposes of WM_COPYDATA messaging
	GUICreate("ChildProc" & @AutoItPID)

	GUIRegisterMsg($WM_COPYDATA, "_ChildProc_WM_COPYDATA")

	; get data from the parent
	$ans = _ChildProc_ReadFromCOPYDATA("ans")
	$variable1 = _ChildProc_ReadFromCOPYDATA("variable1")
	$variable2 = _ChildProc_ReadFromCOPYDATA("variable2")
	$variable3 = _ChildProc_ReadFromCOPYDATA("variable3")
	
	if int($ans) <> 6 then
		
		MsgBox(0, "ChildProc_COPYDATA_test - Child Process #" & $msg & " (PID: " & @AutoItPID & ")", "variable1 = " & $variable1 & @CRLF & _
																									 "variable2 = " & $variable2 & @CRLF & _
																									 "variable3 = " & $variable3 & @CRLF)
	EndIf
	
	; wait until parent is ready to receive output
	_ChildProc_ReadFromCOPYDATA("parent ready")

	; send the output
	_ChildProc_WriteToCOPYDATA("output", "Process finished with PID " & @AutoItPID & @CRLF)

	GUIDelete()

EndFunc

