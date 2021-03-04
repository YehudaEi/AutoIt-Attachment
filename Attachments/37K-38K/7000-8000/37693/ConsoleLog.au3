#include<Constants.au3>
#include<WinAPI.au3>

Global Const $_CL_WeekDays = StringSplit("Sunday;Monday;Tuesday;Wednesday;Thursday;Friday;Saturday", ";")
Global Const $_CL_MonthNames = StringSplit("January;February;March;April;April;May;May;June;July;August;September;October;November;December", ";")

Global $_CL_Log_Mode = 2	; 0: Disabled, 1: Console only, 2: Both Console and File logging, 3: Log to file only
Global $_CL_Console_Closed = 0 ;When someone click the "x" thingy at top right corner of the console 0: Don't kill script, 1: Kill script
Global $_CL_Log_FileMode = 0 ; How the log file be named 0: Use script name, 1: Autogenerated log filename, String: Use as log filename (full-pathname)
Global $_CL_Log_FileExt = ".log"
Global $_CL_Log_File = 0
Global $_CL_Console_Allocated = 0;
Global $_CL_Console_HWND = 0;

Func Alert ($msg)
	MsgBox(0, "AutoIt", $msg)
EndFunc

Func _WinAPI_AllocConsole ()
  Local $aResult = DllCall ("Kernel32.dll", "int", "AllocConsole")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc

Func _WinAPI_FreeConsole ()
  Local $aResult = DllCall ("Kernel32.dll", "int", "FreeConsole")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc

Func _WinAPI_SetConsoleTitle($sText)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetConsoleTitleW", "wstr", $sText)
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc

Func _WinAPI_GetConsoleWindow()
	Local $aResult = DllCall("kernel32.dll", "handle", "GetConsoleWindow")
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc

Func _WinAPI_SetConsoleCtrlHandler($handle)
	Local $aResult = DllCall("kernel32.dll", "bool", "SetConsoleCtrlHandler", "ptr", DllCallbackGetPtr($handle), "bool", true) ;add: true remove: false
	If @error Then Return SetError(@error, @extended, False)
	Return $aResult[0]
EndFunc

Func _ConsoleLog_CtrlHandler($CtrlType)
	Dim $_CL_Console_Closed, $_CL_Console_Allocated

	If $_CL_Console_Closed = 1 Then
		OnAutoItExitUnRegister ( "_ConsoleLog_Exit" )
		$_CL_Console_Allocated = 0
		_ConsoleLog_Exit()
		Run( @ComSpec & " /c taskkill /F /PID " & @AutoItPID & " /T", @SystemDir, @SW_HIDE)
	Else
		; Theres no way to abort console closing event because this handler invoked
		; after the event fired.
		; The workaround is to trigger application not responding message, which
		; in essence serve the purpose.
	EndIf

  Return true
EndFunc

Func _ConsoleLog_CtrlHandler_register ()
	Local $handler = DllCallbackRegister("_ConsoleLog_CtrlHandler", "bool", "dword")
	If $handler > 0 Then _WinAPI_SetConsoleCtrlHandler( $handler )
EndFunc

Func _ConsoleLog_Exit()
	Dim $_CL_Log_Mode, $_CL_Log_File, $_CL_Console_Allocated

	If $_CL_Log_File > 0 AND ($_CL_Log_Mode = 2 OR $_CL_Log_Mode = 3) Then
		FileWriteLine($_CL_Log_File, "===============================================================================")
		FileWriteLine($_CL_Log_File, "Log stopped on " & $_CL_WeekDays[@WDAY-1] & ", " & @MDAY & " " & $_CL_MonthNames[@MON] & " " & @YEAR & ", " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC)
		FileClose($_CL_Log_File)
		$_CL_Log_File = 0
	EndIf
	If $_CL_Console_Allocated > 0 Then _WinAPI_FreeConsole()
EndFunc

Func _ConsoleLog_Start ()
	Dim $_CL_Log_Mode, $_CL_Log_File, $_CL_Console_Allocated, $_CL_Log_FileMode, $_CL_Log_FileExt, $_CL_Console_HWND

	OnAutoItExitRegister("_ConsoleLog_Exit")

	If $_CL_Log_Mode = 1 OR $_CL_Log_Mode = 2 Then
		If _WinAPI_AllocConsole() > 0 Then
			_ConsoleLog_CtrlHandler_register()
			$_CL_Console_Allocated = _WinAPI_GetStdHandle(1)
			_WinAPI_SetConsoleTitle( "AutoIt!" )
			$_CL_Console_HWND = _WinAPI_GetConsoleWindow()
		EndIf
	EndIf

	If $_CL_Log_Mode = 2 OR $_CL_Log_Mode = 3 Then
		Local $filename = StringSplit(@ScriptName, ".")
		Select
			Case IsString($_CL_Log_FileMode)
				$filename = $_CL_Log_FileMode
			Case $_CL_Log_FileMode = 0
				$filename = @ScriptDir & "\" & $filename[1] & $_CL_Log_FileExt
			Case $_CL_Log_FileMode = 1
				$filename = @ScriptDir & "\" & $filename[1] & "-" & @YEAR & @MON & @MDAY & "@" & @HOUR & @MIN & @SEC& $_CL_Log_FileExt
		EndSelect
		$_CL_Log_File =	FileOpen ($filename, 2)
		FileWriteLine($_CL_Log_File, "Log started on " & $_CL_WeekDays[@WDAY-1] & ", " & @MDAY & " " & $_CL_MonthNames[@MON] & " " & @YEAR & ", " & @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC)
		FileWriteLine($_CL_Log_File, "===============================================================================")
	EndIf

EndFunc

Func _Log ( $msg, $no_timestamp=False )
	Dim $_CL_Console_Allocated, $_CL_Log_File

	If $_CL_Console_Allocated > 0 Then _WinAPI_WriteConsole ($_CL_Console_Allocated, $msg & @CRLF)
	If $_CL_Log_File > 0 Then
		If $no_timestamp = True Then
			FileWriteLine($_CL_Log_File, $msg)
		Else
			FileWriteLine($_CL_Log_File, @HOUR & ":" & @MIN & ":" & @SEC & "." & @MSEC & @TAB & $msg)
		EndIf
	EndIf
EndFunc

Func _Log_Group ( $title )
	_WinAPI_SetConsoleTitle($title)
	_Log ("------------------- " & $title, True)
EndFunc

Func _Log_Hide ()
	Dim $_CL_Console_HWND
	
	If $_CL_Console_HWND > 0 Then _WinAPI_ShowWindow($_CL_Console_HWND, @SW_HIDE)
EndFunc

Func _Log_Show ()
	Dim $_CL_Console_HWND
	
	If $_CL_Console_HWND > 0 Then _WinAPI_ShowWindow($_CL_Console_HWND, @SW_SHOWNORMAL)
EndFunc

; Example
;
; _ConsoleLog_Start()
; _Log_Group("Initial Test")
; Sleep (2000)
; For $i = 1 To 9
	; _Log("Iteration: " & $i)
	; Sleep(Random(700, 1500))
; Next
; _Log_Group("Second Pass ...")
; _Log_Hide()
; _Log("Logging will continue, only console is not visible.")
; Sleep (2000)
; _Log_Show()
; _Log_Group("Last Phase")
; For $i = 1 To 9
	; _Log("Iteration: " & $i)
	; Sleep(Random(700, 1500))
; Next