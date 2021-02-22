WinWait("AnyDVD Ripper")
WinSetTrans("AnyDVD","",0)
ControlClick("AnyDVD Ripper","","[CLASSNN:Button1]")
WinWait("AnyDVD Ripper","E:\Deception")
WinSetTrans("AnyDVD","",0)
ControlClick("AnyDVD Ripper","","[CLASSNN:Button1]")

$PID = ProcessExists("anydvdRip.exe") ; Will return the PID or 0 if the process isn't found.
If $PID Then ProcessClose($PID)
	
DirRemove("E:\Deception",1)

Exit
