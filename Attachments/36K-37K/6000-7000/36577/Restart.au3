#Region Header

#cs

    Title:          Restart script UDF Library for AutoIt3
    Filename:       Restart.au3
    Description:    Accurate restarting the script (AU3 or EXE)
    Author:         Yashied
    Version:        1.0
    Requirements:   AutoIt v3.3 +, Developed/Tested on WindowsXP Pro Service Pack 2
    Uses:           None
    Notes:          The library uses OnAutoItStart() function

    Available functions:

    _ScriptRestart

    Example:

        #NoTrayIcon

        #Include <Misc.au3>
        #Include <Restart.au3>

        _Singleton('MyProgram')

        If MsgBox(36, 'Restarting...', 'Press OK to restart this script.') = 6 Then
            _ScriptRestart()
        EndIf

#ce

#Include-once

#OnAutoItStartRegister "OnAutoItStart"

#EndRegion Header

#Region Local Variables and Constants

Global $__Restart = False

#EndRegion Local Variables and Constants

#Region Public Functions

; #FUNCTION# ====================================================================================================================
; Name...........: _ScriptRestart
; Description....: Initiates a restart of the current script.
; Syntax.........: _ScriptRestart ( [$fExit] )
;                  $fExit  - Specifies whether terminates the current script, valid values:
;                  |TRUE   - Terminates script. (Default)
;                  |FALSE  - Does not terminates script.
; Return values..: Success - 1 ($fExit = TRUE)
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........:
; Related .......:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _ScriptRestart($fExit = 1)

	Local $Pid

	If Not $__Restart Then
		If @compiled Then
			$Pid = Run(@ScriptFullPath & ' ' & $CmdLineRaw, @ScriptDir, Default, 1)
		Else
			$Pid = Run(@AutoItExe & ' "' & @ScriptFullPath & '" ' & $CmdLineRaw, @ScriptDir, Default, 1)
		EndIf
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		StdinWrite($Pid, @AutoItPID)
;		If @error Then
;
;		EndIf
	EndIf
	$__Restart = 1
	If $fExit Then
		Sleep(50)
		Exit
	EndIf
	Return 1
EndFunc   ;==>_ScriptRestart

#EndRegion Public Functions

#Region OnAutoItStart

Func OnAutoItStart()
	Sleep(50)

	Local $Pid = ConsoleRead(1)

	If @extended Then
		While ProcessExists($Pid)
			Sleep(100)
		WEnd
	EndIf
EndFunc   ;==>OnAutoItStart

#EndRegion OnAutoItStart
