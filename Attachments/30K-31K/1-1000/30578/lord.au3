#RequireAdmin
HotKeySet("{end}","lod")
While 1
	Sleep(100)
WEnd
Func lod()
	ShellExecute("E:\ns-LotrBfMe2EP1_Maxi-poseden.mds")
	Sleep(5000)
	ShellExecute("D:\Games\The Lord of the Rings, The Rise of the Witch-king\lotrbfme2ep1.exe")
	MsgBox(0,"lord","lord executed")
EndFunc