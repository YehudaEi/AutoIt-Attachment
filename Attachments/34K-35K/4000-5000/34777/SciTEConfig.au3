; =====================================================================================
; Module ..........: SciTEConfig.au3 v3.01
; Original Author .: Patryk Szczepankiewicz ( pszczepa at gmail dot com )
;
; Description:
;   "TidyWpr.au3" will be copied into the "\AutoIt3\SciTE\Tidy" directory
;   + files "SciTEGlobal.properties" and "au3.properties" will be updated.
;
; Usage:
;   - Keep the files SciTEConfig.au3 and TidyWpr.au3 together (ie. in the same directory).
;   - Just run SciTEConfig.au3.
;
; History:
;   JUL 8, 2011 - Release create SciTEConfig-v2011-07-08-153214
;   JUL 11, 2011 - Updated configuration to version 3
;   JUL 22, 2011 - Update for x64 systems (Win 7 and Win Server 2008)
;
; =====================================================================================

$PROGRAM_FILES_DIR = StringReplace(@ProgramFilesDir & " (x86)", "(x86) (x86)", "(x86)")
If Not FileExists($PROGRAM_FILES_DIR) Then $PROGRAM_FILES_DIR = @ProgramFilesDir

Const $SCITE_CONFIG_FILE = $PROGRAM_FILES_DIR & "\AutoIt3\SciTE\SciTEGlobal.properties"
Const $AU3_CONFIG_FILE = $PROGRAM_FILES_DIR & "\AutoIt3\SciTE\Properties\au3.properties"


SciTEConfig_Main()


; =====================================================================================
; Function ........: SciTEConfig_Main v1.00
; Description .....: Main function
; History .........: JUL 10, 2011 - Released by pszczepa
; =====================================================================================

Func SciTEConfig_Main()

	;
	; Edit the appropriate configuration files
	;
	UpdateSciTEConfigFile($SCITE_CONFIG_FILE, "UpdateSciTEGlobalPropsFile")
	UpdateSciTEConfigFile($AU3_CONFIG_FILE, "UpdateAu3PropsFile")

	;
	; Copy the Tidy-wrapper script
	;
	If Not FileExists($PROGRAM_FILES_DIR & "\AutoIt3\SciTE\Tidy\TidyWpr.au3") Or FileDeleteDlg($PROGRAM_FILES_DIR & "\AutoIt3\SciTE\Tidy\TidyWpr.au3") Then
		FileCopy(StringReplace(@ScriptFullPath, @ScriptName, "TidyWpr.au3"), $PROGRAM_FILES_DIR & "\AutoIt3\SciTE\Tidy\TidyWpr.au3")
	EndIf

EndFunc   ;==>SciTEConfig_Main


; =====================================================================================
; Function ........: UpdateSciTEGlobalPropsFile v1.00
; Description .....: Callback that changes the content of the
;                    "AutoIt3\SciTE\SciTEGlobal.properties" file
; Remarks .........: Behaviour "strip.trailing.spaces=1" is OK => NOP
; Usage ...........: Use in conjuction with UpdateSciTEConfigFile
; History .........: JUL 10, 2011 - Released by pszczepa
; =====================================================================================

Func UpdateSciTEGlobalPropsFile($fileContentIo)

	;
	; "Find in Files" configuration -- VERSION 1
	;   Changed:
	;     - changed path to 'findstr.exe' executable
	;     - prefixed $(find.what) with the adequate /c option
	;
	$WRONG_CONF_LINE = 'find.command=findstr /n /s /I "$(find.what)" "$(find.files)"'
	$RIGHT_CONF_LINE = 'find.command=C:\WINDOWS\System32\findstr.exe /n /s /i /c:"$(find.what)" "$(find.files)"'
	$fileContentIo = StringReplace($fileContentIo, $WRONG_CONF_LINE, $RIGHT_CONF_LINE)

	;
	; "Find in Files" configuration -- VERSION 2
	;   Changed:
	;     - added /p option so that we do not search binary files
	;
	$WRONG_CONF_LINE = 'find.command=C:\WINDOWS\System32\findstr.exe /n /s /i /c:"$(find.what)" "$(find.files)"'
	$RIGHT_CONF_LINE = 'find.command=C:\WINDOWS\System32\findstr.exe /n /s /i /p /c:"$(find.what)" "$(find.files)"'
	$fileContentIo = StringReplace($fileContentIo, $WRONG_CONF_LINE, $RIGHT_CONF_LINE)

	;
	; "Find in Files" configuration -- VERSION 3
	;   Changed:
	;     - no quotes around $(find.files)
	;          should allow to search through multiple different files.
	;         eg. C:\WINDOWS\System32\findstr.exe /n /s /i /p /c:"test" *au3 *bat *inc
	;     - removed useless /p option
	;
	$WRONG_CONF_LINE = 'find.command=C:\WINDOWS\System32\findstr.exe /n /s /i /p /c:"$(find.what)" "$(find.files)"'
	$RIGHT_CONF_LINE = 'find.command=C:\WINDOWS\System32\findstr.exe /n /s /i /p /c:"$(find.what)" $(find.files)'
	$fileContentIo = StringReplace($fileContentIo, $WRONG_CONF_LINE, $RIGHT_CONF_LINE)

	;
	; Change user defined key commands
	;
	$fileContentIo = StringReplace($fileContentIo, "KeypadPlus|IDM_EXPAND|\", "Ctrl+KeypadPlus|IDM_EXPAND|\")
	$fileContentIo = StringReplace($fileContentIo, "KeypadMinus|IDM_BLOCK_COMMENT|\", "Ctrl+KeypadMinus|IDM_BLOCK_COMMENT|\")

	;
	; Return the new/updated content
	;
	Return $fileContentIo

EndFunc   ;==>UpdateSciTEGlobalPropsFile


; =====================================================================================
; Function ........: UpdateAu3PropsFile v1.00
; Description .....: Callback that changes the content of the
;                    "\AutoIt3\SciTE\Properties\au3.properties" file
; Usage ...........: Use in conjuction with UpdateSciTEConfigFile
; History .........: JUL 10, 2011 - Released by pszczepa
; =====================================================================================

Func UpdateAu3PropsFile($fileContentIo)

	;
	; Replace configuration file in order to call the "Tidy" wrapper script
	;
	$WRONG_CONF_LINE = 'command.9.$(au3)="$(SciteDefaultHome)\tidy\tidy.exe" "$(FilePath)"'
	$RIGHT_CONF_LINE = 'command.9.$(au3)="$(SciteDefaultHome)\..\AutoIt3.exe" "$(SciteDefaultHome)\tidy\TidyWpr.au3" "$(FilePath)"'
	$fileContentIo = StringReplace($fileContentIo, $WRONG_CONF_LINE, $RIGHT_CONF_LINE)

	;
	; Return the new/updated content
	;
	Return $fileContentIo

EndFunc   ;==>UpdateAu3PropsFile


; =====================================================================================
; Function ........: UpdateSciTEConfigFile v1.00
; Description .....: Function that manages a configuration file, opens it,
;                    changes its content using the appropriate callback
; History .........: JUL 10, 2011 - Released by pszczepa
; =====================================================================================

Func UpdateSciTEConfigFile(Const $SCITE_CONFIG_FILE, Const $CALLBACK)
	ConsoleWrite("UpdateSciTEConfigFile('" & $CALLBACK & "', '(...)')..." & @CRLF)
	$fileContentOld = FileRead($SCITE_CONFIG_FILE)
	$fileContentNew = Call($CALLBACK, $fileContentOld)
	If $fileContentNew <> $fileContentOld Then
		If FileDeleteDlg($SCITE_CONFIG_FILE) Then
			ConsoleWrite(" -> FileWrite('" & $SCITE_CONFIG_FILE & "', '(...)')..." & @CRLF)
			FileWrite($SCITE_CONFIG_FILE, $fileContentNew)
		EndIf
	EndIf
EndFunc   ;==>UpdateSciTEConfigFile


; =====================================================================================
; Function ........: FileDeleteDlg v1.00
; Description .....: Thiny helper that screams for help if the file cannot be written
; History .........: JUL 10, 2011 - Released by pszczepa
; =====================================================================================

Func FileDeleteDlg($filePath)
	$ret = FileDelete($filePath)
	If Not $ret Then
		MsgBox(48, "Error", "File '" & $filePath & "' cannot be deleted.")
	EndIf
	Return $ret
EndFunc   ;==>FileDeleteDlg
