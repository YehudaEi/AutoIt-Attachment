#NoTrayIcon
MsgBox(4096,"Set win on top","OK")
While 1
	Select
	Case WinExists("Browse for Folder") 	
		WinSetOnTop("Browse for Folder", "", 1)
		ExitLoop
	Case WinExists("Select dll file to test..") 
		WinSetOnTop("Select dll file to test..", "", 1)
		ExitLoop
	EndSelect
	Sleep(50)
WEnd
