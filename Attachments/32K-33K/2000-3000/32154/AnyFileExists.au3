$path = 'C:\Newly_created_123\directory_456'

DirCreate($path)
If @error Then
	MsgBox(16, Default, 'Error creating directory', 12)
	Exit
EndIf
OnAutoItExitRegister('OnExit')
MsgBox(64, Default, $path & @CRLF & "shouldn't contain any files.", 4)

Test_FileExists()
Test_FFFF()

Func Test_FileExists()
	If FileExists($path) Then MsgBox(64, 'Test_FileExists', $path & @CRLF & 'EXISTS.', 6) ; TRUE
	If FileExists($path & '\*.mp3') Then
		MsgBox(64, 'Test_FileExists', $path & '\*.mp3' & @CRLF & 'exists.', 6)
	Else
		MsgBox(64, 'Test_FileExists', $path & '\*.mp3' & @CRLF & "DOESN'T EXIST.", 6) ; TRUE
	EndIf
	If FileExists($path & '\*.*') Then MsgBox(48, 'Test_FileExists', $path & '\*.*' & @CRLF & 'exists (but directory is empty!).', 9) ; FALSE - IMO it should be TRUE!
EndFunc   ;==>Test_FileExists


Func Test_FFFF()
	$checkFiles = AnyFileExists($path, '*.*')
	If $checkFiles = 0 Then
		MsgBox(64, 'Test_FFFF', $path & '\*.*' & @CRLF & "DOESN'T EXIST.", 9) ; TRUE
	Else
		MsgBox(64, 'Test_FFFF', $path & '\*.*' & @CRLF & 'exists.', 6)
	EndIf
EndFunc   ;==>Test_FFFF

Func AnyFileExists($sPath, $sFilter)
	FileChangeDir($sPath)
	Local $ff1f = FileFindFirstFile($sFilter)
	FileChangeDir(@ScriptDir)
	FileClose($ff1f)
	If $ff1f = -1 Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc   ;==>AnyFileExists

Func OnExit()
	FileChangeDir('C:\')
	If FileExists(StringLeft($path, StringInStr($path, '\', 0, -1) -1)) Then DirRemove(StringLeft($path, StringInStr($path, '\', 0, -1) -1), 1)
EndFunc   ;==>OnExit
