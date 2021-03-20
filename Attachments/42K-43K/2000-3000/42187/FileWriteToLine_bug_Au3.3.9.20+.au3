#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Comment=                
#AutoIt3Wrapper_Res_Description=Example file showing beta bug since AutoIt3.3.9.20.
#AutoIt3Wrapper_Res_Field=Release date|18.10.2013
#AutoIt3Wrapper_Res_LegalCopyright=monter.FM
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <File.au3>
Global $msg, $flg, $sec
$title = 'AutoIt3 - version ' & @AutoItVersion
FileChangeDir(@ScriptDir)
If StringReplace(@AutoItVersion, '.', '') > 33919 Then
	VerBug()
Else
	VerOK()
EndIf

FileInfo()

MsgBox($flg, $title, $msg, $sec)
If $flg = 48 Then Run('notepad.exe ' & @ScriptName)

Func VerBug()
	$msg = 'This version has just damaged this file.' & @CRLF & 'Fortunately I made the *.bak copy :)' & @CRLF & 'Look at this damaged script now.'
	$flg = 48
	$sec = 6
	FileCopy(@ScriptName, @ScriptName & '.bak')
EndFunc   ;==>VerBug

Func VerOK()
	$msg = "This version works fine and shouldn't damage this file."
	$flg = 64
	$sec = 3
EndFunc   ;==>VerOK

Func FileInfo()
	Opt('TrayIconDebug', 1)
	$strRes = '#AutoIt3Wrapper_'
	For $ln = 1 To 10
		$srchRes = StringInStr(FileReadLine(@ScriptFullPath, $ln), $strRes)
		If $srchRes > 0 Then
			$lr = $ln
			ExitLoop
		EndIf
	Next
	$strRes = '#AutoIt3Wrapper_Res_Field=Release date|'
	For $ln = $lr To $lr + 16
		$srchRes = StringInStr(FileReadLine(@ScriptFullPath, $ln), $strRes)
		If $srchRes > 0 Then
			$lnRes = $ln
			ExitLoop
		EndIf
	Next
	$rd = FileGetTime(@ScriptFullPath, 0, 0)
	_FileWriteToLine(@ScriptFullPath, $lnRes, '#AutoIt3Wrapper_Res_Field=Release date|' & $rd[2] & '.' & $rd[1] & '.' & $rd[0], 1)
	Global $dateRlse = $rd[2] & '.' & $rd[1] & '.' & $rd[0]
	FileSetTime(@ScriptFullPath, $rd[0] & $rd[1] & $rd[2] & $rd[3] & $rd[4] & $rd[5], 0)
EndFunc   ;==>FileInfo
