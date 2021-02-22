; -----------------------------------------------------------------------
; Module .............: TidyWpr.au3
; Author .............: P. Szczepankiewicz ( pszczepa at gmail dot com )
;
; History:
;   JUL 8, 2011 - RELEASE CREATE SciTEConfig-v2011-07-08-153214
;
; -----------------------------------------------------------------------

#include <File.au3>

$PROGRAM_FILES_DIR = StringReplace(@ProgramFilesDir & " (x86)", "(x86) (x86)", "(x86)")
If Not FileExists($PROGRAM_FILES_DIR) Then $PROGRAM_FILES_DIR = @ProgramFilesDir

Const $DEFAULT_DIFF_TOOL = $PROGRAM_FILES_DIR & "\WinMerge\WinMergeU.exe"
Const $TIDY_BACKUP_STORE = @TempDir & "\TidyWpr.BackUp"

TidyWpr_Main()

Func TidyWpr_Main()

	If ($CmdLine[0] = 0) Or (Not FileExists($CmdLine[1])) Then
		$errMsg = "Missing or invalid parameter provided to '" & @ScriptName & "'."
		ConsoleWrite("!Error: " & $errMsg)
		MsgBox(48, "Fatal Error", $errMsg)
		Exit 1
	EndIf

	If StringRegExp(FileRead($CmdLine[1]), "(\A|\n|\r)#NoTidy") Then
		ConsoleWrite("'NoTidy' directive found in the file; this file should not be tidied." & @CRLF)
		Exit 0
	EndIf

	$NewCmdLineRaw = $CmdLineRaw
	$NewCmdLineRaw = StringReplace($CmdLineRaw, "TidyWpr.au3", "Tidy.exe", 1)

	; run the program
	StyleCop_HardPreFixTmp($CmdLine[1])
	$out = TidyWpr_RunAndFwdStdout($NewCmdLineRaw)
	$backfileOut = StyleCop_HardPostFixTmpSup($out)

	TidyWpr_HardPostFixV1($CmdLine[1])

	If Not StringCompare(FileRead($backfileOut), FileRead($CmdLine[1]), 1) Then

		ConsoleWrite("No changes." & @CRLF)
		FileDelete($backfileOut)

	Else

		If Not FileExists($TIDY_BACKUP_STORE) Then DirCreate($TIDY_BACKUP_STORE)
		$backfileMvd = $TIDY_BACKUP_STORE & "\" & StringReplace(StringReplace(FileGetShortName($backfileOut), "\", "--"), ":", "")
		If FileExists($backfileMvd) Then FileRecycle($backfileMvd)
		FileMove($backfileOut, $backfileMvd, 8)

		$diffTool = $DEFAULT_DIFF_TOOL
		If FileExists($diffTool) Then
			$commandLine = $diffTool & " " & FileGetShortName($backfileMvd) & " " & FileGetShortName($CmdLine[1])
			RunWait($commandLine)
		EndIf

	EndIf

	; delete empty backup directory
	Dim $szDrive, $szDir, $szFName, $szExt
	_PathSplit($backfileOut, $szDrive, $szDir, $szFName, $szExt)
	_FileListToArray($szDrive & $szDir)
	If @error And FileExists($szDrive & $szDir) Then DirRemove($szDrive & $szDir)

EndFunc   ;==>TidyWpr_Main

Func TidyWpr_RunAndFwdStdout($szCmd, $szWorkingDir = "", $flags = @SW_HIDE) ; << WARNING: CODE IN SYNC
	$szResult = ""
	$child_pid = Run($szCmd, $szWorkingDir, $flags, 0x2) ; 0x2 - $STDOUT_CHILD
	While 1
		$szResult_line = StdoutRead($child_pid)
		If @error Then ExitLoop
		$szResult &= $szResult_line
		ConsoleWrite($szResult_line)
	WEnd
	Return $szResult
EndFunc   ;==>TidyWpr_RunAndFwdStdout

Func StyleCop_HardPreFixTmp($entry)
	$entryContent = FileRead($entry)
	$refix = 0
	; remove EOL at the end of the file
	If StringRight($entryContent, StringLen(@CRLF)) = @CRLF Then
		$refix = 1
		$entryContent = StringTrimRight($entryContent, StringLen(@CRLF))
	EndIf
	; finally rewrite the file
	If $refix Then TidyWpr_FileRewrite($entry, $entryContent)
	Return $entryContent
EndFunc   ;==>StyleCop_HardPreFixTmp

Func StyleCop_HardPostFixTmpSup($out)
	$backfileOut = ""
	$matches = StringRegExp($out, 'Original copied to\:"([^"]+)"', 1)
	If Not @error Then
		$backfileOut = $matches[0]
		$ret = TidyWpr_HardPostFixV1($backfileOut)
	EndIf
	Return $backfileOut
EndFunc   ;==>StyleCop_HardPostFixTmpSup


#region CODE IN SYNC REF. 98631818-9F98-4cf1-AF1A-B83C236E739A (StyleCop <=> TidyWpr)

Func TidyWpr_FileRewrite($file, $content) ; << WARNING: CODE IN SYNC
	If Not FileDelete($file) Then
		MsgBox(48, "Fatal Error", "File cannot be rewritten.")
		Exit 2
	EndIf
	FileWrite($file, $content)
EndFunc   ;==>TidyWpr_FileRewrite

Func TidyWpr_HardPostFixV1($entry) ; << WARNING: CODE IN SYNC
	$entryContent = FileRead($entry)
	$refix = 0
	; remove trailing spaces on any non-last line
	$entryContent = StringRegExpReplace($entryContent, "\h+" & @CRLF, @CRLF)
	$refix += @extended
	; ensure EOL at the end of the file
	If StringRight($entryContent, StringLen(@CRLF)) <> @CRLF Then
		$refix = 1
		$entryContent &= @CRLF
	EndIf
	; finally rewrite the file
	If $refix Then TidyWpr_FileRewrite($entry, $entryContent)
	Return $entryContent
EndFunc   ;==>TidyWpr_HardPostFixV1

#endregion CODE IN SYNC REF. 98631818-9F98-4cf1-AF1A-B83C236E739A (StyleCop <=> TidyWpr)
