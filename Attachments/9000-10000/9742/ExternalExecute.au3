;===============================================================================
;
; Description:      Executes External AU3 Script
; Parameter(s):     $v_filename - Location of external AU3 script
;                   $i_startline    - [optional] Line to start reading in the external script, default is 1 which is the first line
;                   $i_endline    - [optional] Line to terminate reading of external script, default is 0 which is end of file
; Requirement(s):   None
; Return Value(s):  On Success - 1
;                   On Failure - 0  and Set
;                                   @ERROR to:  1 - Invalid $v_filename
;                                               2 - Invalid $i_startline
;                                               3 - Invalid $i_endline
; Author(s):        The Kandie Man
; Note(s): This function allows a user to execute an external script from a compiled autoit executeable by using a function in the compiled executable.
;  The script pauses and the external script is run.  Once the external script finishes, the compiled script continues its execution.
;===============================================================================
#include <file.au3>
#include <array.au3>
Func _FileAU3Ex($v_filename, $i_startline = 1, $i_endline = 0)
	$v_tempexecutefile = @TempDir & "\execute.au3"
	If Not FileExists($v_filename) Then
		SetError(1)
		Return 0
	EndIf
	If $i_startline < 1 Then
		SetError(2)
		Return 0
	EndIf
	If $i_endline < $i_startline And $i_endline <> 0 Then
		SetError(3)
		Return 0
	EndIf
	If $i_startline = 0 And $i_endline = -1 Then
;~ 		RunWait(@ComSpec & ' /c "' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $v_filename & '"', "", @SW_HIDE)
		RunWait(@AutoItExe & ' /AutoIt3ExecuteScript "' & $v_filename & '"', "", @SW_HIDE)
	Else
		Dim $av_temparray
		_FileReadToArray($v_filename, $av_temparray)
		$i_numelements = UBound($av_temparray)
		If $i_numelements < $i_endline Then
			SetError(3)
			Return 0
		EndIf
		_FileWriteFromArray($v_tempexecutefile, $av_temparray, $i_startline, $i_endline)
;~ 		RunWait(@ComSpec & ' /c "' & @AutoItExe & '" /AutoIt3ExecuteScript "' & $v_tempexecutefile & '"', "", @SW_HIDE)
		RunWait(@AutoItExe & ' /AutoIt3ExecuteScript "' & $v_tempexecutefile & '"', @TempDir, @SW_HIDE)
		FileDelete($v_tempexecutefile)
		Dim $av_temparray = 0 ;free up memory
	EndIf
	Return 1
EndFunc   ;==>_FileAU3Ex
;===============================================================================
;
; Description:      Executes Function in External AU3 Script
; Parameter(s):     $v_filename - Location of external AU3 script
;                   $v_func    - The function to call without (), example "terminate", not "terminate()"
;                   $v_parameters    - [optional] The parameters that will by put inside the (), seprataed by commas.  The entire thing should be a string in quotes.
; Requirement(s):   None
; Return Value(s):  On Success - Return Value of Function called
;                   On Failure - "error"  and Set
;                                   @ERROR to:  1 - Invalid $v_filename
;                                               2 - Could not get what the function called returned
; Author(s):        The Kandie Man
; Note(s): Sorry for the weird return value on error, the reason for this is so that the return value doesn't conflict with the failure return value of the function called.
;  The script pauses and the external function is run.  Once the external function finishes, the compiled script continues its execution.
;IMPORTANT:  If you are using FileInstall and need the external files that are installed in order to run the function correctly, you must write a function with the various fileinstalls and call the function immidiately
;after the last #include.  If you have no includes, it must be the first line.
;This Function isn't idiot-proof.  Calling an external function that doesn't exist or with incorrect parameters will result in an autoit error
;===============================================================================
Func _FileAU3ExFunc($v_filename, $v_func, $v_parameters = "")
	$v_tempexecutefile = @TempDir & "\executefunc.au3"
	If Not FileExists($v_filename) Then
		SetError(1)
		Return 0
	EndIf
	Dim $av_temparray
	_FileReadToArray($v_filename, $av_temparray)
	Dim $i_counter = 1
	While 1
		_ArraySearch($av_temparray,"#include",$i_counter)
		If @error = 6 Then ExitLoop
		$i_counter += 1
	WEnd
	_ArrayInsert($av_temparray, $i_counter + 1, 'INIWrite("' & $v_tempexecutefile & '.ini", "Function", "Return",' & $v_func & "(" & $v_parameters & "))")
	_ArrayInsert($av_temparray, $i_counter + 2, "Exit")
	_FileWriteFromArray($v_tempexecutefile, $av_temparray, 1)
	RunWait(@AutoItExe & ' /AutoIt3ExecuteScript "' & $v_tempexecutefile & '"', @TempDir, @SW_HIDE)
	$v_return = IniRead($v_tempexecutefile & ".ini", "Function", "Return", "ERROR")
	FileDelete($v_tempexecutefile)
	FileDelete($v_tempexecutefile & '.ini')
	Dim $av_temparray = 0 ;clear memory
	If $v_return = "ERROR" Then
		SetError(2)
		Return "ERROR"
	EndIf
	Return $v_return
EndFunc   ;==>_FileAU3ExFunc
;===============================================================================
;
; Description:      Assosciates AU3 Files With a compiled version of itself so that
; Parameter(s):     None, you must devote an entire script to this function.  You may not place this function in an already coded script
; Requirement(s):   None
; Return Value(s):  On Success - Returns 1
;					On Failure - Returns 0 - Only does this if you attempt to execute this function in an uncompiled autoitscript
; Author(s):        The Kandie Man
; Note(s): This function is a stand alone function.  No other functions or code should be executed in the script apart from maybe a fileinstall or
; an #include.  This is a very specific and unique function.  When compiled and sent to a target user's machine, it will associate the .extau3 extension with
;itself and install itself on the target user's machine.  You may now rename a .a3x or .au3 script to a .extau3 extension and send it to the target user's machine
;where the script will be executed as if they have autoit installed on their system.
;===============================================================================
Func _FileAU3Associate()
	If @Compiled = 0 Then
		Return 0
	EndIf
	If @AutoItExe = @ProgramFilesDir & "\AutoItExternal\AutoItExt.exe" And $CmdLine[0] > 0 Then
		Run(@AutoItExe & ' /AutoIt3ExecuteScript "' & $CmdLine[1] & '"')
	ElseIf @AutoItExe = @ProgramFilesDir & "\AutoItExternal\AutoItExt.exe" And $CmdLine[0] = 0 Then
		If Not IsDeclared("msgboxanswer34632") Then Dim $msgboxanswer34632
		$msgboxanswer34632 = MsgBox(308, "Remove?", "This program runs .extau3 files.  Since you have executed this file directly no .extau3 file was specified." & @CRLF & @CRLF & "If you remove this program you will no longer be able to run .extau3 files!" & @CRLF & @CRLF & "Are you sure you want to remove this program from your computer?")
		Select
			Case $msgboxanswer34632 = 6 ;Yes
				Run(@ComSpec & " /c " & 'FTYPE ExternalAutoit=', "", @SW_HIDE)
				Run(@ComSpec & " /c " & 'ASSOC .extau3=', "", @SW_HIDE)
				$openhandle3425 = FileOpen(@TempDir & "\remove.bat", 2)
				FileWrite($openhandle3425, ":start" & @CRLF & 'del "' & @AutoItExe & '"' & @CRLF & 'IF EXIST "' & @AutoItExe & '" goto start' & @CRLF & 'RD "' & @ProgramFilesDir & '\AutoItExternal"')
				FileClose($openhandle3425)
				Run(@TempDir & "\remove.bat", "", @SW_HIDE)
			Case $msgboxanswer34632 = 7 ;No
		EndSelect
		Exit
	Else
		FileCopy(@AutoItExe, @ProgramFilesDir & "\AutoItExternal\AutoItExt.exe", 9)
		Run(@ComSpec & " /c " & 'FTYPE ExternalAutoit="' & @ProgramFilesDir & '\AutoItExternal\AutoItExt.exe" "%1"', "", @SW_HIDE)
		Run(@ComSpec & " /c " & 'ASSOC .extau3=ExternalAutoit', "", @SW_HIDE)
	EndIf
	Return 1
EndFunc   ;==>_FileAU3Associate