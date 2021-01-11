
; Tools Gui

#NoTrayIcon
#include <GUIConstants.au3>

#region - GUI Create
; Gui create with List Control to choose a script
If $CMDLINE[0] = 1 And (StringRight($CMDLINE[1], 3) = 'au3' Or StringRight($CMDLINE[1], 3) = 'a3x') Then
	; Tool window style as a application addon
	$handle_gui = GUICreate('/AutoIt3 Execute Script Gui', 300, 387, Default, Default, Default, $WS_EX_TOOLWINDOW)
	$list_scripts = GUICtrlCreateList($CMDLINE[1], 10, 50, 280, 140)
	If StringLen($CMDLINE[1]) > 55 Then GUICtrlSetTip(Default, $CMDLINE[1])
Else
	; Standard window style as standalone application	
	$handle_gui = GUICreate('/AutoIt3 Execute Script Gui', 300, 387)	
	$file_split = _ScriptSearchPath_Relative(@ScriptDir)
	If Not @error = 1 Then
		$list_scripts = GUICtrlCreateList($file_split[1], 10, 50, 280, 140)
		For $i = 2 To $file_split[0]
			GUICtrlSetData($list_scripts, $file_split[$i])
		Next
	ElseIf Not @error Then
		ConsoleWrite(IsArray($list_scripts) & @LF)
		$list_scripts = GUICtrlCreateList($file_split[1], 10, 50, 280, 140)
	Else
		$list_scripts = GUICtrlCreateList(StringTrimRight('', 4), 10, 50, 280, 140)
		MsgBox(0x40030, @ScriptName, 'Failed to find any scripts')
	EndIf
EndIf
; Button to Browse in anothor directory
$button_browse = GUICtrlCreateButton('&Browse another directory for scripts', 10, 7, 280, 23)
; Label to inform of selecting a script
GUICtrlCreateLabel('Select a script to execute :', 10, 35, 280, 20)
GUICtrlSetColor(Default, 0xFFFFFF)
; Commandline parameter
GUICtrlCreateLabel('Add a command line parameter :', 10, 180, 280, 20)
GUICtrlSetColor(Default, 0xFFFFFF)
$input_parameter = GUICtrlCreateInput('', 10, 200, 280, 20)
; Label to inform user of StdOut for Edit Control
GUICtrlCreateLabel('STDOut display :', 10, 226, 280, 20)
GUICtrlSetColor(Default, 0xFFFFFF)
; Edit Control for receiving StdOut
$edit_stdout = GUICtrlCreateEdit('>' & @WorkingDir, 10, 244, 280, 100, BitOR( $ES_WANTRETURN, $WS_VSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetBkColor(Default, 0x000000)
GUICtrlSetColor(Default, 0xFFFFFF)
; Checkbox for StdOut option
$checkbox_stdoutread = GUICtrlCreateCheckbox('STDOut ON', 10, 355, 90, 23, BitOR($BS_PUSHLIKE, $BS_AUTOCHECKBOX))
GUICtrlSetState(Default, $GUI_CHECKED)
; Buttons for Run Script and Exit
$button_run = GUICtrlCreateButton('&Execute Script', 105, 355, 90, 23)
$button_exit = GUICtrlCreateButton('E&xit', 200, 355, 90, 23)
GUISetBkColor(0x0D0F88)
GUICtrlSetState($list_scripts, $GUI_FOCUS)
GUISetState()
#endregion
	
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE, $button_exit
			Exit
		Case -100 To 0
			ContinueLoop
		Case $button_browse
			$dir_browse = FileSelectFolder('Select a new &directory to scan', @HomeDrive)
			If Not @error Then
				GUICtrlSetData($edit_stdout, '>' & $dir_browse)
				GUICtrlDelete($list_scripts)
				$file_split = ''
				$file_split = _ScriptSearchPath_Relative($dir_browse)
				If Not @error = 1 Then
					$list_scripts = GUICtrlCreateList($file_split[1], 10, 50, 280, 140)
					For $i = 2 To $file_split[0]
						GUICtrlSetData($list_scripts, $file_split[$i])
					Next
				ElseIf Not @error Then
					ConsoleWrite(IsArray($list_scripts) & @LF)
					$list_scripts = GUICtrlCreateList($file_split[1], 10, 50, 280, 140)
				Else
					$list_scripts = GUICtrlCreateList(StringTrimRight('', 4), 10, 50, 280, 140)
					MsgBox(0x40030, @ScriptName, 'Failed to find any scripts')
				EndIf
			EndIf
		Case $button_run
			GUICtrlSetState($button_run, $GUI_DISABLE)
			GUICtrlSetData($edit_stdout, '>' & @WorkingDir)
			If GUICtrlRead($checkbox_stdoutread) = $GUI_CHECKED Then
				; Run script with StdOut
				$file_selected = @AutoItExe & ' /AutoIt3ExecuteScript "' & GUICtrlRead($list_scripts) & '" ' & GUICtrlRead($input_parameter)
				$data_stdout = _RunStdOutReadGetExitcode($file_selected)
				$exitcode = @extended
				If $data_stdout Then
					$data_stdout &= @CRLF
				Else
					$data_stdout = ''
				EndIf
				GUICtrlSetData($edit_stdout, GUICtrlRead($edit_stdout) & @CRLF & $data_stdout & '>Exit code: ' & $exitcode)
				If $exitcode Then GUICtrlSetColor(Default, 0xBB0000)
			Else
				; Run script and return PID	
				$pid = Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & GUICtrlRead($list_scripts) & '" ' & GUICtrlRead($input_parameter), '', @SW_SHOW, 2)
				GUICtrlSetData($edit_stdout, GUICtrlRead($edit_stdout) & @CRLF & '>Process id: ' & $pid)
			EndIf
			GUICtrlSetState($button_run, $GUI_ENABLE)
			WinActivate($handle_gui)
		Case $checkbox_stdoutread
			If GUICtrlRead($checkbox_stdoutread) = $GUI_CHECKED Then
				GUICtrlSetState($edit_stdout, $GUI_ENABLE)
				GUICtrlSetData($checkbox_stdoutread, 'STDOut ON')
			Else
				GUICtrlSetState($edit_stdout, $GUI_DISABLE)
				GUICtrlSetData($checkbox_stdoutread, 'STDOut OFF')
			EndIf
	EndSwitch
WEnd

Exit

Func _RunStdOutReadGetExitcode($sFilename, $sWorkingdir = '', $iFlag = @SW_SHOW, $iStandard_IO_Flag = 2)
	Local $iError, $hProcess, $iPid, $sStdout, $vPlaceholder
	; Run process and return StdOut/PID
	$iPid = Run($sFilename, $sWorkingdir, $iFlag, $iStandard_IO_Flag)
	; Return the process handle of a PID
	$hProcess = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $iPid)
	If @error Then $iError = 1
	While 1
		$sStdout &= StdOutRead($iPid)
		If @error Then ExitLoop
		If $sStdout Then
			$sStdout = StringStripWS($sStdout, 3)
			ConsoleWrite($sStdout & @CRLF)
		EndIf
	WEnd
	ProcessWaitClose($iPid)
	; Return Exitcode of a PID
	If IsArray($hProcess) Then
		$hProcess = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $hProcess[0], 'int_ptr', $vPlaceholder)
		If @error Then $iError += 2
	Else
		$iError += 2
	EndIf
	; Close the process handle of a PID
	DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $hProcess)
	If @error Then $iError += 4
	If Not IsArray($hProcess) Then Return SetError($iError, 0, $sStdout)
	Return SetError($iError, $hProcess[2], $sStdout)
EndFunc

Func _ScriptSearchPath_Relative($dir_parameter)
	; Find all Au3 script in a chosen directory
	Local $file_found, $file_split, $file_total, $handle_search
	Local $dir_workingdir = @WorkingDir
	If StringRight($dir_parameter, 1) <> '\' Then
		$dir_parameter = $dir_parameter & '\'
	EndIf
	If FileChangeDir($dir_parameter) Then
		$handle_search = FileFindFirstFile('*.a*')
		If $handle_search <> -1 Then
			While 1
				$file_found = FileFindNextFile($handle_search)
				If @error Then ExitLoop
				If StringRight($file_found, 3) <> 'au3' And _
					StringRight($file_found, 3) <> 'a3x'Then
					ContinueLoop
				EndIf
				If $file_found = @ScriptName Then ContinueLoop
				$file_total &= $file_found & '|'
			WEnd
			FileClose($handle_search)
			If StringRight($file_total, 1) = '|' Then
				$file_total = StringTrimRight($file_total, 1)
			EndIf
			$file_split = StringSplit($file_total, '|')
			If Not @error Then
				Return $file_split
			Else
				Return SetError(1, 0, $file_split)
			EndIf
		EndIf
		FileChangeDir($dir_workingdir)
	EndIf
	Return SetError(2, 0, '')
EndFunc
