#include <Imported\_ProcessGetChildren.au3>
Global $SUPERVISED_PID___GLOBAL = 0
OnAutoItExitRegister("OnAutoItExitV01")
TraySetIcon("Shell32.dll", 300) ; fileserver icon

$sProcess = "tracd.exe"
$sCommand = "tracd.exe --port 8000 \\storage01\versions$\AutoTestingV2.Trac"

; exception: the process already exists
If ProcessExists($sProcess) Then Exit 1

$SUPERVISED_PID___GLOBAL = _
		Run($sCommand, "", @SW_HIDE)

While 1
	Sleep(1000)
WEnd


; -------------------
; SUPERVISED_PID_EXIT
; -------------------

Func OnAutoItExitV01()
	; was there an error?
	If @exitCode Then Return
	; close by clicking on exit of the systray?
	If @exitMethod = 2 Then
		; close the grand-children as well
		$list = _ProcessGetChildren($SUPERVISED_PID___GLOBAL)
		If IsArray($list) Then
			For $i = 1 To $list[0][0]
				If ProcessExists($list[$i][0]) Then
					ProcessClose($list[$i][0])
					ProcessWaitClose($list[$i][0])
				EndIf
			Next
		EndIf
		; close the main process
		If ProcessExists($SUPERVISED_PID___GLOBAL) Then ProcessClose($SUPERVISED_PID___GLOBAL)
	EndIf
EndFunc   ;==>OnAutoItExitV01
