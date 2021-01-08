; FILENAME: IOChatter.au3
; PURPOSE: Demonstrate usage of stdin and stdout communication between 
;          Parent and child process in AutoIt
; 
#include <GuiConstants.au3>
#include <constants.au3>

dim $a3x = "IOChatter.a3x"
Dim $gChildPid
Dim $gParent = 0
Dim $data
Dim $GUI_Handle = GuiCreate("IO chat Base", 426, 251,(@DesktopWidth-426)/2, _
													(@DesktopHeight-251)/2)

Dim $input1 = GuiCtrlCreateInput("Message from", 10, 10, 350, 20)
Dim $edit1 = GuiCtrlCreateEdit("Started: " & @HOUR & ":" & @Min & ":" & @SEC , 10, 40, 350, 180)
Dim $label1 = GUICtrlCreateLabel("INIT: ", 10,222, 350, 28)
Dim $buttonSend = GuiCtrlCreateButton("Send", 370, 10, 50, 30)
DIm $checkRunIntern = GUICtrlCreateCheckbox("Script", 370, 45, 50, 30)
GUICtrlSetTip($checkRunIntern, "If checked the childe will be started with:" & _
				@CRLF & "    @AutoitExe /AutoIt3ExecuteScript " & $a3x)
Dim $buttonRunChild = GuiCtrlCreateButton("Run Child", 370, 80, 50, 30)


GuiSetState()
While 1
	$msg = GuiGetMsg()
	Switch $msg
		case $GUI_EVENT_CLOSE
			ExitLoop
		case $buttonSend
			buttonSend_Event()
		case $buttonRunChild
			buttonRunChild_Event()
		Case Else
			;Read IO
			$data = ReadIO($gChildPid)
			if $data <> "" Then 
				GUICtrlSetData($edit1, (GUICtrlRead($edit1) & @CRLF &  $data))
			Endif
			sleep(50)
	EndSwitch
WEnd
Exit 
; =============================================================================
Func buttonRunChild_Event()
	$gParent = 1
	if GUICtrlRead($checkRunIntern) = $GUI_CHECKED Then 
		if FileExists(@AutoItExe) AND FileExists(@ScriptDir &  "\" & $a3x) Then 
			LogMsg("cmd run( " & @AutoItExe & " /AutoIt3ExecuteScript " & _
					@ScriptDir &  "\" & $a3x & ")")
			$gChildPid = run(@AutoItExe & " /AutoIt3ExecuteScript " & @ScriptDir &  _
					"\" & $a3x, '', _
					@SW_SHOW,  $STDOUT_CHILD + $STDIN_CHILD);$STDERR_CHILD +
		Else
			; Give error message, this is not suposed to happen
			msgbox(16, "ERROR:", "could not locate: " & @CRLF & @AutoItExe & _
				" OR " & @CRLF & _
				@ScriptDir &  "\" & $a3x & @CRLF & @CRLF & _
				"Did jo remember to compile the " &  $a3x & " file??")
		Endif
	Else
		If @Compiled Then 
			LogMsg("Running: " & @AutoItExe)
			$gChildPid = run(@AutoItExe,"",@SW_SHOW,  $STDOUT_CHILD + $STDIN_CHILD) 
			; $STDERR_CHILD nit handeled
		Else 
			$gChildPid = run(@AutoItExe & " " & @ScriptFullPath,"",@SW_SHOW,  $STDOUT_CHILD + $STDIN_CHILD) 
		endif 
	EndIf
EndFunc

Func buttonSend_Event()
	WriteIO($gChildPid, GUICtrlRead($input1))
EndFunc 
; =============================================================================
; Read from the IO stream between the processes
; =============================================================================
Func ReadIO($childPid)
	Local $bytes 
	Local $data	= ""
	; Determine if we are a master or a child
	If $childPid <> 0 Then 
		; Peek to see how many bytes to read
		$bytes = StdoutRead($childPid,'',true )
		LogMsg(" NOTE: StdoutRead returned $bytes:=" & $bytes )					
		if $bytes > 0 then 
			; Read bytes in the stream
			$data = StdoutRead($childPid, $bytes)
		Endif
	Else
		; Peek to see how many bytes to read
		$bytes = ConsoleRead( '', true)
		LogMsg(" NOTE: ConsoleRead returned $bytes:=" & $bytes )					
		if $bytes > 0 then 
			$data = ConsoleRead($bytes)
		Endif
		; Expect @error = -1 ; EOF or not set.
	EndIf
	If @error <> 0 then LogMsg(	" ERROR: Read: @error:=" & @error &  _
							"@ScriptLineNumber:=" & @ScriptLineNumber)		
	Return $data
EndFunc
; =============================================================================
; Write to the IO stream between the processes
; =============================================================================
Func WriteIO($childPid = 0, $data = "")
	Local $bytes
	if $data <> "" Then 
		If $childPid <> 0 Then 
			; Peek to see how many bytes to read
			StdinWrite($childPid, $data)
		Else
			ConsoleWrite($data)
		EndIf	
		If @error <> 0 then 
			LogMsg(" ERROR: Write: @error:=" & @error &  _
					"@ScriptLineNumber:=" & @ScriptLineNumber)
		Else
			LogMsg(" WARNING: Nothing to write")
		Endif
	EndIf
EndFunc 
Func LogMsg($msg)
		GUICtrlSetData($label1, @MIN & ":" & @SEC & $msg )
EndFunc 