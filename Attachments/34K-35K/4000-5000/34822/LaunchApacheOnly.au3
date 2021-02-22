#include <Imported\_ProcessGetChildren.au3>
Global $SUPERVISED_PID___GLOBAL = 0
OnAutoItExitRegister("OnAutoItExitV01")
LaunchApacheOnly_Main()

; -------------------
;        MAIN
; -------------------

Func LaunchApacheOnly_Main()

	Const $PROCESS_NAME = "apache.exe"
	Const $PROCESS_DIR = @ProgramFilesDir & "\EasyPHP3.1" & "\apache\bin"
	Const $PROCESS_PATH = $PROCESS_DIR & "\" & $PROCESS_NAME

	If FileExists($PROCESS_PATH) Then
		TraySetIcon($PROCESS_PATH) ; Set the Apache feather icon
	EndIf

	; Launch Apache
	If Not ProcessExists($PROCESS_NAME) Then
		If FileExists($PROCESS_PATH) Then
			$SUPERVISED_PID___GLOBAL = Run($PROCESS_PATH, $PROCESS_DIR, @SW_HIDE)
		EndIf
	EndIf

	While 1
		Sleep(1000)
	WEnd

EndFunc

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
