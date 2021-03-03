#include <StdLib\Misc.au3>
#include <Imported\_ProcessGetChildren.au3>
; Constants
Const $HTTPD_BINARY_NAME = "httpd.exe"
Const $HTTPD_BINARY_LOCATION = @ProgramFilesDir & "\Zend" & "\Apache2\bin"
; Globals
_Singleton("LaunchApacheOnly")
Global $SUPERVISED_PID___GLOBAL = 0
OnAutoItExitRegister("OnAutoItExitV01")
LaunchApacheOnly_Main__DuplicatedFunc()

; -------------------
;        MAIN
; -------------------

Func LaunchApacheOnly_Main__DuplicatedFunc()

	Const $PROCESS_NAME = $HTTPD_BINARY_NAME
	Const $PROCESS_DIR = $HTTPD_BINARY_LOCATION
	Const $PROCESS_PATH = $PROCESS_DIR & "\" & $PROCESS_NAME
	Const $PROCESS_CMD = $PROCESS_PATH

	 ; Set tray icon (eg. Apache feather, etc.)
	If FileExists($PROCESS_PATH) Then TraySetIcon($PROCESS_PATH)

	; Exception: the process already exists
	If ProcessExists($PROCESS_NAME) Then Exit 1

	; Launch process
	$SUPERVISED_PID___GLOBAL = _
			Run($PROCESS_CMD, $PROCESS_DIR, @SW_HIDE)

	; Exit or wait
	If @error Then
		MsgBox(48, "Fatal Error", "Failed to run command @" & @ScriptName)
		Exit 2
	Else
		While 1
			Sleep(1000)
		WEnd
	EndIf

EndFunc   ;==>LaunchApacheOnly_Main__DuplicatedFunc

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
