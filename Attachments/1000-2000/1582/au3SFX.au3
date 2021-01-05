; ----------------------------------------------------------------------------
; AutoIt Version: 3.1.0
; Author: Ahmed Bayomy
; ----------------------------------------------------------------------------
if not FileExists("7za.exe") then  FileCopy(@ProgramFilesDir & "\7-zip\7za.exe",@ScriptDir & "\7za.exe")
if not FileExists("7z.sfx") then  FileCopy(@ProgramFilesDir & "\7-zip\7z.sfx",@ScriptDir & "\7z.sfx")
if not FileExists("7zs.sfx") then  FileCopy(@ProgramFilesDir & "\7-zip\7zs.sfx",@ScriptDir & "\7zs.sfx")
	
if $CmdLine[0] =0 then 
	MsgBox(0,"Help","Parameters : " & @CRLF & " Folder name to creat 7z file " & @CRLF & " /SFX to creat .EXE  " & @CRLF & " Filename to make .exe with autorun this file")
	Exit
EndIf

dim $Command,$File
$7zFile='"' & $CmdLine[1] & '.7z"' 
$Command="7za.exe a -t7z -mx9 " & $7zFile & ' "' & $CmdLine[1] & '\*" -r -y'
RunWait($Command,"",@SW_HIDE )
if $CmdLine[0] >1  then 
	if $CmdLine[2]="/SFX" Then
		RunWait(@ComSpec & " /c " & "Copy /b " & @ScriptDir & "\7z.sfx + " & $7zFile & ' "' & $CmdLine[1] & '.exe"',"",@SW_HIDE) 
		FileDelete($7zFile)
	Else
;~ 		-----------------------------
		dim $7TXT
		$7TXT=FileOpen(@ScriptDir & "\7z.txt",2)
		FileWrite($7TXT,";!@Install@!UTF-8!" & @CRLF)
		FileWrite($7TXT,"RunProgram=" & '"' & $CmdLine[2] & '"' & @CRLF)
		FileWrite($7TXT,";!@InstallEnd@!" & @CRLF)
		RunWait(@ComSpec & " /C " & 'Copy /b "' & @ScriptDir & '\7zs.sfx" + "' & @ScriptDir & '\7z.txt" + ' & $7zFile & ' "' & $CmdLine[1] & '.exe"');,"",@SW_HIDE) 
	EndIf
EndIf


