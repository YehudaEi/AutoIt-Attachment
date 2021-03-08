#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=y
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****
MsgBox(0, "", _File_Is_X64("C:\Windows\system32\calc.exe"))
MsgBox(0, "", _File_Is_X64("C:\Windows\SysWOW64\wscript.exe"))
MsgBox(0, "", _File_Is_X64("C:\Windows\System32\shell32.dll"))
MsgBox(0, "", _File_Is_X64("C:\Windows\SysWOW64\shell32.dll"))

Func _File_Is_X64($file)
	Local $handle = FileOpen($file, 16)
	If $handle = -1 Then Return SetError(-2, -2, "Invalid")
	If BinaryToString(FileRead($handle, 2)) = 'MZ' Then
		FileSetPos($handle, 60, 0)
		FileSetPos($handle, Int(FileRead($handle, 4)) + 4, 0)
		Local $in = FileRead($handle, 2)
		FileClose($handle)
		If $in = "0x6486" Then Return "AMD64"
		If $in = "0x4c01" Then Return "i386"
		If $in = "0x0002" Then Return "IA64"
	EndIf
	Return "Unknown"
EndFunc   ;==>_File_Is_X64