#cs
	_GUICtrlListViewSetItemSelState($ListView1, Change_DISABLE....

	When a process is running,
	what can i do like the above,
	to disable any change on the listview
#ce
#include <ButtonConstants.au3>
#include <Constants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <ListViewConstants.au3>
#include <StaticConstants.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>

#region ### START Koda GUI section ### Form=C:\AutoIt NDB Kit\- 0 Exemplos\Form1.kxf
Global $Form1 = GUICreate("Form1", 223, 449, 192, 114)
Global $Label1 = GUICtrlCreateLabel("Label1", 11, 2, 200, 34, $SS_CENTER)
GUICtrlSetData($Label1, "click on the box down while a process is in progress.")

Global $Edit1 = GUICtrlCreateEdit("", 11, 48, 200, 80, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSetTip(-1, "Click on here when it's running a process")
GUICtrlSetData(-1, "")

Global $Run = GUICtrlCreateButton("run /c ping www.db.pt", 11, 130, 200, 25)
Global $Label2 = GUICtrlCreateLabel("Use the above to run a process and wait until finished", 11, 162, 200, 34, $SS_CENTER)

Global $ListView1 = GUICtrlCreateListView("Col1", 11, 204, 200, 89, BitOR($GUI_SS_DEFAULT_LISTVIEW, $LVS_AUTOARRANGE, $WS_HSCROLL, $WS_VSCROLL), BitOR($WS_EX_CLIENTEDGE, $LVS_EX_GRIDLINES, $LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT))
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 220)
_Add_LV1_Items()

Global $LVEnable = GUICtrlCreateButton("Enable Scroll", 11, 304, 75, 25)
Global $LVDisable = GUICtrlCreateButton("Disable Scroll", 136, 304, 75, 25)
Global $Stop = GUICtrlCreateButton("Stop", 72, 352, 75, 25)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

Global $Pid, $line

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg

		Case $GUI_EVENT_CLOSE
			#cs
				If ProcessExists($Pid[1][0]) Then _
				ProcessClose($Pid[1][0])
			#ce
			Exit

		Case -100 To 0
			ContinueLoop

		Case $Run
			GUICtrlSetState($ListView1, $GUI_DISABLE)
			_Run_()
			GUICtrlSetState($ListView1, $GUI_ENABLE)

		Case $LVEnable
			MsgBox(528416, "How to?", "How to enable 'Just the Scroll Bar', or prevent changes on the list view" & @CRLF & "When a process is running")

		Case $LVDisable
			MsgBox(528416, "How to?", "How to disable changes on listview items," & @CRLF & "and 'Just enable the Scroll Bar'," & @CRLF & "When a process is running")

	EndSwitch
WEnd

Func _Run_()

	$pid_CMD = Run(@ComSpec & " /c ping www.db.pt", @TempDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	Sleep(5)
	$Pid = _WinAPI_EnumChildProcess($pid_CMD)

	While $pid_CMD

		$msg = GUIGetMsg()
		Select
			Case $msg = $Stop
				$Check_Stopped = True
				GUICtrlSetData($Edit1, @CRLF & @CRLF & "Stopped ... ", True)
				If ProcessExists($Pid[1][0]) Then _
						ProcessClose($Pid[1][0])

			Case $msg = $GUI_EVENT_CLOSE
				If ProcessExists($Pid[1][0]) Then _
						ProcessClose($Pid[1][0])
				GUIDelete()
				Exit
		EndSelect

		$line = StdoutRead($pid_CMD)
		If @error Then ExitLoop
		;sleep(5)
		GUICtrlSetData($Edit1, $line, 1)
	WEnd

	While 1
		$line = StderrRead($Pid)
		If @error Then ExitLoop
		MsgBox(0, "STDERR read:", $line)
	WEnd

EndFunc   ;==>_Run_

Func _Add_LV1_Items()
	For $i = 0 To 10
		GUICtrlCreateListViewItem("Run cmd " & $i & "|", $ListView1)
	Next
	_GUICtrlListView_SetItemChecked($ListView1, 1, True)
EndFunc   ;==>_Add_LV1_Items

Func _WinAPI_EnumChildProcess($Pid = 0); good example from UEZ
	If Not $Pid Then
		$Pid = _WinAPI_GetCurrentProcessID()
		If Not $Pid Then Return SetError(1, 0, 0)
	EndIf

	Local $hSnapshot = DllCall('kernel32.dll', 'ptr', 'CreateToolhelp32Snapshot', 'dword', 0x00000002, 'dword', 0)
	If (@error) Or (Not $hSnapshot[0]) Then Return SetError(1, 0, 0)

	Local $tPROCESSENTRY32 = DllStructCreate('dword Size;dword Usage;dword ProcessID;ulong_ptr DefaultHeapID;dword ModuleID;dword Threads;dword ParentProcessID;long PriClassBase;dword Flags;wchar ExeFile[260]')
	Local $pPROCESSENTRY32 = DllStructGetPtr($tPROCESSENTRY32)
	Local $Ret, $Result[101][2] = [[0]]

	$hSnapshot = $hSnapshot[0]
	DllStructSetData($tPROCESSENTRY32, 'Size', DllStructGetSize($tPROCESSENTRY32))
	$Ret = DllCall('kernel32.dll', 'int', 'Process32FirstW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	While (Not @error) And ($Ret[0])
		If DllStructGetData($tPROCESSENTRY32, 'ParentProcessID') = $Pid Then
			$Result[0][0] += 1
			If $Result[0][0] > UBound($Result) - 1 Then
				ReDim $Result[$Result[0][0] + 100][2]
			EndIf
			$Result[$Result[0][0]][0] = DllStructGetData($tPROCESSENTRY32, 'ProcessID')
			$Result[$Result[0][0]][1] = DllStructGetData($tPROCESSENTRY32, 'ExeFile')
		EndIf
		$Ret = DllCall('kernel32.dll', 'int', 'Process32NextW', 'ptr', $hSnapshot, 'ptr', $pPROCESSENTRY32)
	WEnd
	_WinAPI_CloseHandle($hSnapshot)
	If $Result[0][0] Then
		ReDim $Result[$Result[0][0] + 1][2]
	Else
		Return SetError(1, 0, 0)
	EndIf
	Return $Result
EndFunc   ;==>_WinAPI_EnumChildProcess



