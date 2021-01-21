_activateScript("RunOnlyOnThisPc.exe", "test")

;===============================================================================
;
; Function Name:    _activateScript
; Description:     	Activates the script which is protected by _runOnlyOnThisPC
;
; Parameter(s):     $s_programName = name (script.exe)
;					$s_ActivationKey = key which starts the func
;
; Return Value(s): 	Non
;
; Note(s):			Basically useful to start(activate) the _runOnlyOnThisPC
;					protected script
;					Should be on own script.exe in the same folder!
;
; Author(s):        Thorsten Meger
;
;===============================================================================
Func _activateScript($s_programName, $s_ActivationKey)
	Run(@ScriptDir & "\" & $s_programName & " " & $s_ActivationKey)
	Local $cmdfile
	FileDelete(@TempDir & "\scratch.cmd")
	$cmdfile = ':loop' & @CRLF _
			 & 'del "' & @ScriptFullPath & '"' & @CRLF _
			 & 'if exist "' & @ScriptFullPath & '" goto loop' & @CRLF _
			 & 'del ' & @TempDir & '\scratch.cmd'
	FileWrite(@TempDir & "\scratch.cmd", $cmdfile)
	Run(@TempDir & "\scratch.cmd", @TempDir, @SW_HIDE)
EndFunc   ;==>_activateScript