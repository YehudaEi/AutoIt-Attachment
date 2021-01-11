#region\ - Glabal Variables
; Constants
Global Const $IDOK = 1
; GUIConstantsEx
Global Const $GUI_EVENT_CLOSE = -3
; WindowsConstants
Global Const $WS_HSCROLL = 0x00100000
Global Const $WS_VSCROLL = 0x00200000
; EditConstants
Global Const $ES_AUTOVSCROLL = 64
Global Const $ES_AUTOHSCROLL = 128
Global Const $ES_READONLY = 2048
Global Const $ES_WANTRETURN = 4096
; GUIDefaultConstants
Global Const $GUI_SS_DEFAULT_EDIT = BitOR($ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_AUTOVSCROLL, $ES_AUTOHSCROLL)
; Script variables
Global Const $KEY_AU3 = 'HKLM\SOFTWARE\Classes\AutoIt3Script\Shell\RunSTDOut'
Global Const $KEY_A3X = 'HKLM\SOFTWARE\Classes\AutoIt3XScript\Shell\RunSTDOut'
Global $stdout_data
#endregion

#region - CmdlineSwitch
If $CMDLINE[0] Then
	For $i = 1 To $CMDLINE[0]
		Switch $CMDLINE[$i]
			Case '/?'
				MsgBox(0x40000, StringTrimRight(@ScriptName, 4) & ' Help', _
						'Switches are:' & @LF _
						 & @LF & '/extract' _
						 & @LF & @TAB & 'Extract files to current directory' _
						 & @LF & '/register' _
						 & @LF & @TAB & 'Add entries into the registry' _
						 & @LF & '/unregister' _
						 & @LF & @TAB & 'Remove entries from the registry')
				Exit
			Case '/extract'
				FileInstall('AutoIt3StdOut.au3', @ScriptDir & '\')
				Exit
			Case '/register'
				RegWrite($KEY_AU3, '', 'Reg_sz', 'Run STDOut')
				RegWrite($KEY_AU3 & '\Command', '', 'Reg_sz', '"' & @ScriptFullPath & '" /AutoIt3ExecuteScript "%1" %*')
				RegWrite($KEY_A3X, '', 'Reg_sz', 'Run STDOut')
				RegWrite($KEY_A3X & '\Command', '', 'Reg_sz', '"' & @ScriptFullPath & '" /AutoIt3ExecuteScript "%1" %*')
				Exit
			Case '/unregister'
				RegDelete($KEY_AU3)
				RegDelete($KEY_A3X)
				Exit
			Case Else
				If FileExists($CMDLINE[$i]) Then
					$file_parameter = $CMDLINE[$i]
					ExitLoop
				Else
					MsgBox(0x40000, 'Incorrect switch used', _
						'Command used:' & @LF & $CMDLINERAW & @LF & _
						@LF & 'Use /? for the switches available.')
					Exit
				EndIf
		EndSwitch
	Next
Else
	If RegRead($KEY_AU3, '') Then
		If MsgBox(0x40021, @ScriptName, 'Do you want to remove ' & @ScriptName & ' to the registry?') = $IDOK Then
			RegDelete($KEY_AU3)
			RegDelete($KEY_A3X)
		EndIf
	Else
		If MsgBox(0x40021, @ScriptName, 'Do you want to add ' & @ScriptName & ' to the registry?') = $IDOK Then
			RegWrite($KEY_AU3, '', 'Reg_sz', 'Run STDOut')
			RegWrite($KEY_AU3 & '\Command', '', 'Reg_sz', '"' & @ScriptFullPath & '" /AutoIt3ExecuteScript "%1" %*')
			RegWrite($KEY_A3X, '', 'Reg_sz', 'Run STDOut')
			RegWrite($KEY_A3X & '\Command', '', 'Reg_sz', '"' & @ScriptFullPath & '" /AutoIt3ExecuteScript "%1" %*')
		EndIf
	EndIf
	Exit
EndIf
#endregion

#region - Gui Create
GUICreate(FileGetShortName(@ScriptFullPath), 600, 300)
$edit = GUICtrlCreateEdit('', 0, 0, 600, 300, BitOR($GUI_SS_DEFAULT_EDIT, $ES_READONLY))
GUICtrlSetColor(Default, 0xFFFFFF)
GUICtrlSetBkColor(Default, 0x000000)
GUISetState(@SW_HIDE)
#endregion

#region - Run STDOut process
$pid = Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & $file_parameter & '"', '', @SW_SHOW, 2)
GUICtrlSetData($edit, '>' & $file_parameter & @CRLF)
$hProcess = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'int', 0x400, 'int', 0, 'int', $pid)
While 1
	$stdout_data &= StdOutRead($pid)
	If @error Then ExitLoop
WEnd
GUICtrlSetData($edit, GUICtrlRead($edit) & $stdout_data)
ProcessWaitClose($pid)
If IsArray($hProcess) Then
	Global $vPlaceholder
	$hProcess = DllCall('kernel32.dll', 'ptr', 'GetExitCodeProcess', 'ptr', $hProcess[0], 'int_ptr', $vPlaceholder)
	GUICtrlSetData($edit, GUICtrlRead($edit) & '>Exit code: ' & $hProcess[2] & @CRLF)
EndIf
DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $hProcess)
GUISetState(@SW_SHOW)
#endregion

While GUIGetMsg() <> $GUI_EVENT_CLOSE
WEnd
