#include<array.au3>
#include<string.au3>
Dim $T_CHILD[1]
Global $T_GUI=0,$debug=1,$TASK_READ_CHILD="",$z=1,$gui,$butt
Opt("TrayIconDebug" , 1)
Opt("OnExitFunc" , "onExit")


;; child!
If $cmdline[0] <> 0 Then
	AdlibEnable("_task_child_command" ,2)
	For $i=1 To $cmdline[0]
		Switch $cmdline[$i]
			Case "do"
				Local $func=$cmdline[$i+1]
				Local $params[100]
				Local $numparams=1
				$params[0]="CallArgArray"
				$i+=2
				While $cmdline[$i]<> "done" And $i<=$cmdline[0]
					$params[$numparams]=$cmdline[$i]
					$numparams+=1
					$i+=1
				WEnd
				If $numparams<>1 Then
					ReDim $params[$numparams]
					Call($func,$params)
				Else
					Call($func)
				EndIf
			Case "assign"
				Local $varname=$cmdline[$i+1],$value=$cmdline[$i+2],$flag=$cmdline[$i+3]
				Assign($varname, $value , $flag)
		EndSwitch
	Next
	Exit
EndIf

AdlibEnable("_loop_children",2); manage my kids

Func _task_add($T_FUNC_ARRAY) ;; spawn kid with func array
	Local $bootstrap = ""
	For $i=1 To $T_FUNC_ARRAY[0]
		$bootstrap&="do "&$T_FUNC_ARRAY[$i]&" done "
	Next
	Local $return = _spawn_child($bootstrap)
	Return $return
EndFunc

Func _spawn_child($CH_BOOT);;spawn a kid with this bootstrap
	$return=Run(@AutoItExe &' "'& @ScriptFullPath & '" '& $CH_BOOT,"",@SW_HIDE , 9)	
	_ArrayAdd($T_CHILD , $return)
	debug($return & " started")
	Return $return
EndFunc

Func _task_stop($T_PID);; gracefully stop a kid
	StdinWrite($T_PID," exit ")
EndFunc

Func _task_destroy($T_PID);; kill a kid
	ProcessClose($T_PID)
	debug($T_PID&" closed")
	_ArrayDelete($T_CHILD,_ArraySearch($T_CHILD,$T_PID))
EndFunc

Func _task_child_read();;child read from parent
	Local $buff=""
	While True
		$buff&=ConsoleRead()
		If @error Or $buff="" Or StringInStr($buff , " t_done ") Then Return $buff
		Sleep(1)
	WEnd
	$buff=StringReplace($buff , " t_done " , "")
	Return $buff
EndFunc

Func _task_child_command();;listen to your father! :P
	$msg=_task_child_read()
	If $msg="" Then Return
	$split=StringSplit($msg , " ")
	For $i=1 To $split[0]
		Switch $split[$i]
			Case "do"
				Local $func=$split[$i+1]
				Local $params[4]
				Local $numparams=1
				$params[0]="CallArgArray"
				$i+=2
				While $split[$i]<> "done" And $i<=$split[0]
					$params[$numparams]=$split[$i]
					$numparams+=1
					$i+=1
				WEnd
				If $numparams<>1 Then
					ReDim $params[$numparams]
					Call($func,$params)
				Else
					Call($func)
				EndIf
			Case "assign"
				Local $varname=$split[$i+1],$value=$split[$i+2],$flag=$split[$i+3]
				Assign($varname, $value , $flag)
			Case "exit"
				onExit()
		EndSwitch
	Next
EndFunc

Func _loop_children();parent watch kids
	For $i=1 To UBound($T_CHILD)-1 Step +1
		If UBound($T_CHILD)<=$i Then Return
		$msg=""
		While True
			;ConsoleWrite(@CRLF & $i&":"&UBound($T_CHILD) & @CRLF)
			$msg&=StdoutRead($T_CHILD[$i])
			If @error<>0 Or $msg="" Or StringInStr($msg , " t_done ") Then 
				ExitLoop
			EndIf
		WEnd
		$exit=0
		If $msg<>"" Then
			$msg=StringReplace($msg , " t_done " , "")
			$exit=StringSplit($msg , " ")
			For $z=1 To $exit[0]
				If $exit[$z]="exit" Then
					$exit=1
				EndIf
			Next
			Call($TASK_READ_CHILD,$i,$msg)
			If $exit=1 Then
				debug($T_CHILD[$i]&" ended")
				_ArrayDelete($T_CHILD , $i)
				$i-=1
			EndIf
		EndIf
	Next
	For $i=1 To UBound($T_CHILD)-1
		If UBound($T_CHILD)<=$i Then Return
		If Not ProcessExists($T_CHILD[$i]) Then
			debug($T_CHILD[$i] & " lost(error)")
			_ArrayDelete($T_CHILD , $i)
			$i-=1
		EndIf
	Next
EndFunc

Func debug($data); a little help
	If $debug=0 Then Return
	ConsoleWrite($data & @CRLF)
EndFunc

Func _TASK_PARENT_POLL_CHILD($data);;data sent by kids to the parent func (^^,)
	$TASK_READ_CHILD=$data
EndFunc

Func _task_send_to_parent($data);;kid yell at parent lol :))
	ConsoleWrite($data & " t_done ")
EndFunc

Func OnExit();tell dad that we're bailing
	_task_send_to_parent("exit")
	Exit
EndFunc

Func _parent_send_child($CHILD , $MESSAGE); parent say to kid
	StdinWrite($CHILD , $MESSAGE & " t_done ")
EndFunc
