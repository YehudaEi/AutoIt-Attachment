; PopG_Run.au3 - Andy Swarbrick 2005-6 - Extends functionality for running external programs.
#region		Doc:
#region		Doc: Notes
; Extends functionality for running external programs.
;
; RunErrorsFatal needed to avoid Au3 collapse!
#endregion	Doc: Notes
#region		Doc: Requirements
; Requires Au3 build 3.1.1.109 or better.
; Also uses include libraries array and constants.
#endregion	Doc: Requirements
#region		Doc: FunctionList
; _RunWaitOutErr						Runs a (dos) command until completion, returning output & error lines into two arrays
; _RunWaitSys							Does a RunWait for a command in the system folder
; _RunWaitSysOutErr						Does a RunWaitOutErr in Sys folder
#endregion	Doc: FunctionList
#region		Doc: History
; 20-Feb-06 Als Updated	_RunWaitOutErr	Debugged further proceessing to ensure line breaks are processed properly.
; 19-Feb-06 Als _RunWaitOutErr updated to separate out data collection from parsing into arrays.
; 13-Feb-06 Als Commented out RegExpReplace on request of two Au3 users.
#endregion	Doc: History
#endregion	Doc:
#region		Init:
#region		Init: includes
	#include-once
	#include <array.au3>
	#include <Constants.au3>
#endregion	Init: Includes
#region		Init: Autoit options
;~ 	Opt ('RunErrorsFatal',	False)
#endregion	Init: Autoit options
#endregion	Init:
#region		Run:
#region		Run: Test Harness
#endregion	Run: Test Harness
#region		Run: Functions
; _RunWaitSysOutErr						Does a RunWaitOutErr in Sys folder
;
; Notes:
; We recommend you familiarise yourself with the functions Run and RunWait before using this function.
;
; Parameters:
; $Cmd					The command to be executed. The program must exist in @SystemDir.
; $Dir					Working directory to be used for execution.
; $Flag					The show flag for the executed program.
; $OutArr				An array returned which contains the (dos) console standard output.
; $ErrArr				An array returned which contains the (dos) console error output.
;
; Result:
; Returns true if the call is successful.
Func _RunWaitSysOutErr($Cmd,$Dir,$Flag,ByRef $OutArr,ByRef $ErrArr)
	_RunWaitOutErr(@ComSpec&' /c '&@SystemDir&'\'&$Cmd,$Dir,$Flag,$OutArr,$ErrArr)
	If @error Then Return False
	Return True
EndFunc ; _InetConnected
; _RunWaitSys							Does a RunWait for a command in the system folder
;
; Parameters:
; $Cmd					The command to be executed. The program must exist in @SystemDir.
; $Dir					Working directory to be used for execution.
; $Flag					The show flag for the executed program.
Func _RunWaitSys($Cmd,$Dir='',$Flag=0)
	RunWait(@ComSpec&' /c '&@SystemDir&'\'&$Cmd,$Dir,$Flag)
	If @error Then Return False
	Return True
EndFunc ; _RunWaitSys
; _RunWaitOutErr						Runs a (dos) command until completion, returning output & error lines into two arrays
;
; Notes:
; 1. RunErrorsFatal needed to avoid Au3 collapse!
;
; Parameters:
; $Cmd					The command to be executed. The program must exist in @SystemDir.
; $Dir					Working directory to be used for execution.
; $Flag					The show flag for the executed program.
; $OutArr				An array returned which contains the (dos) console standard output.
; $ErrArr				An array returned which contains the (dos) console error output.
;
; Results:
; Returns either false/0 on failure, or on success a string representation of $OutArr.
; On failure @error is also set.
; @error=1		Implies the run command failed to execute
; @error=2		Implies OutArr is not an array
; @error=3		Implies ErrArr is not an array
;
; History:
; 20-Feb-06 Als Updated	_RunWaitOutErr	Debugged further proceessing to ensure line breaks are processed properly.
Func _RunWaitOutErr($Cmd,$Dir,$Flag,ByRef $OutArr,ByRef $ErrArr)
	Local $Pid,$OutText,$OutTextAll,$ErrText,$ErrTextAll,$OutCod,$ErrCod,$TmpVal
	If Not IsArray($OutArr) Then 
		SetError(2,0)
		Return False
	EndIf
	If Not IsArray($ErrArr) Then 
		SetError(3,0)
		Return False
	EndIf
	Dim $TmpArr
	ReDim $OutArr[1],$ErrArr[1]
	$OutArr[0]=0
	$ErrArr[0]=0
	$Pid=Run($Cmd,$Dir,$Flag,$STDERR_CHILD+$STDOUT_CHILD)
	If @error=1 Then
		SetError(1,0)
		Return False
	EndIf
	Do
		$OutText=StdoutRead($Pid)
		$OutCod=@error
		If $OutCod<>-1 Then $OutTextAll=$OutTextAll&$OutText
		;
		$ErrText=StderrRead($Pid)
		$ErrCod=@error
		If $ErrCod<>-1 Then $ErrTextAll=$ErrTextAll&$ErrText
	Until $ErrCod=-1 And $OutCod=-1
	;
	If StringRight($OutTextAll,2)==@CRLF Then $OutTextAll=StringLeft($OutTextAll,StringLen($OutTextAll)-2)
	If StringRight($ErrTextAll,2)==@CRLF Then $ErrTextAll=StringLeft($ErrTextAll,StringLen($ErrTextAll)-2)
	;
	$OutArr=StringSplit($OutTextAll,@CRLF,True)
	$ErrArr=StringSplit($ErrTextAll,@CRLF,True)
	SetError(0,0)
	Return $OutTextAll
EndFunc ; _RunWaitOutErr
#endregion	Run: Functions
#endregion	Run:
