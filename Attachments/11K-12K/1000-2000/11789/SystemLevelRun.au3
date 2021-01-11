; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author: DaUberBird
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here
$filename =InputBox("System Run As", "Enter the name of the .exe you want to run.")
$workindir =InputBox("System Run As", "Enter the name of the working directory it is in." & @LF & "(Leave blank if in system32 or in current directory)")
If $workindir = "" Then
	_SystemServicesRun($filename)
Else
	_SystemServicesRun($filename, $workindir)
EndIf

;Runs a program at system level by creating a service and running it.
;When using don't put in a whole file path
;Examples:
;Running a command prompt at system level: _SystemServicesRun("cmd")
;Running C:\Documents and Settings\Username\Desktop\myexe.exe: _SystemServicesRun("myexe.exe", "C:\Documents and Settings\Username\Desktop)
Func _SystemServicesRun($name, $workingdir = @ScriptDir)
	$systemfile = 0
	;Checks if file is in the working dir with no \
	If FileExists($workingdir & "\" & $name) = 1 Then
		$filepath = $workingdir & "\" & $name
		$shortcutpath = @SystemDir & "\tmpshortcut.lnk"
		FileCreateShortcut($filepath, $shortcutpath)
		$name = "tmpshortcut.lnk"
		$systemfile = 0
	Else
		;Checks if file is in the working dir with a \
		If FileExists($workingdir & $name) = 1 Then
			$filename = $workindir & $name
			$shortcutpath = @SystemDir & "\tmpshortcut.lnk"
			FileCreateShortcut($filepath, $shortcutpath)
			$name = "tmpshortcut.lnk"
			$systemfile = 0
		Else
			;If it is not in the dir w/ a "\" or w/out a "\" then it assumes it is in the system32 folder
			$systemfile = 1
		EndIf
	EndIf
	;creates a service called runsyslevel that runs the program
	$first = Run('sc.exe create runsyslevel' & $name & ' binpath= "cmd /C start ' & $name & '" type= own type= interact', "", @SW_HIDE)
	ProcessWaitClose($first)
	;runs the service
	$second = Run("sc.exe start runsyslevel" & $name, "", @SW_HIDE)
	ProcessWaitClose($second)
	;deletes the service
	$third = Run("sc.exe delete runsyslevel" & $name, "", @SW_HIDE)
	If $systemfile = 0 Then
		;If a shortcut was created, delete it
		FileDelete($shortcutpath)
	EndIf
EndFunc
