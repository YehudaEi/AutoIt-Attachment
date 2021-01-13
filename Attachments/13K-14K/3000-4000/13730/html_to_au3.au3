#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.3.0 (beta)
	Author:         AutoItKing
	
	Script Function:
	This will take your HTML pages and convert them into AutoIt web pages.
	It puts echo (' ') around each line and also adds the necessary include and _StartWebApp().
	
#ce ----------------------------------------------------------------------------

#include <file.au3>

$file = FileOpenDialog("Choose File...","","HTML Pages (*.html;*.htm)")
If @error Then Exit @exitCode
$fileopen = FileOpen($file,0)
$saveto = FileSaveDialog("Save as...","","AutoIt Scripts (*.au3)")
If @error Then Exit @exitCode
If FileExists($saveto) Then
	$answer = MsgBox(301,"OverWrite?","That file already exists!!" & @CRLF & @CRLF & "Would you like to over write it?")
	If $answer = 6 Then
		If FileExists($saveto) Then FileDelete($saveto)
		FileOpen($saveto,2)
		FileWriteLine($saveto,"#Include <web.au3>")
		FileWriteLine($saveto,"_StartWebApp ()")
		For $i=1 To _FileCountLines($file)
			$line = FileReadLine($fileopen)
			$line2 = StringReplace($line,"'",'"')
			FileWriteLine($saveto,"echo ('" & $line2 & "')")
		Next
	ElseIf $answer = 7 Then
		_restart()
	ElseIf $answer = 2 Then
		Exit @exitCode
	EndIf
Else
	FileOpen($saveto,2)
	FileWriteLine($saveto,"#Include <web.au3>")
	FileWriteLine($saveto,"_StartWebApp ()")
	For $i=1 To _FileCountLines($file)
		$line = FileReadLine($fileopen)
		$line2 = StringReplace($line,"'",'"')
		FileWriteLine($saveto,"echo ('" & $line2 & "')")
	Next
EndIf

Func _restart()
	If @Compiled = 1 Then
		Run( FileGetShortName(@ScriptFullPath))
	Else
		Run( FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
	EndIf
	Exit
EndFunc