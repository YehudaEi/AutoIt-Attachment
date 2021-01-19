While 1
	If WinExists("Microsoft Internet Explorer", "Session timeout - Please login") = 1 Then Call("SessionTimeout")
	If WinExists("WebVision Login -") = 1 Then Call("CloseIE")
	If WinExists("MajorCompany Application -") = 0 Then Call("StartIE")
	WinSetState("MajorCompany Application -", "", @SW_MAXIMIZE)
	WinActivate("MajorCompany Application -")
	Call("Time")
WEnd

Func StartIE()
	Run("C:\Program Files\Internet Explorer\Iexplore.exe http://localhost/webvision/autologin.aspx?name=Test-1&pass=")
	Sleep(8000)
EndFunc

Func Time()
	MouseClick("left", 70, 210)
	MouseClick("left", 70, 355)
	Sleep(3000)
	If WinExists("Microsoft Internet Explorer", "Session timeout - Please login") = 0 Then
	MouseClick("left", 483, 310)
	Send("{BS}{BS}{BS}{BS}{BS}08")
	MouseClick("left", 540, 310)
	WinWait("Microsoft Internet Explorer", "Request timeout", 35)
	If WinExists("Microsoft Internet Explorer", "Request timeout") = 1 Then RunWait(@ComSpec & " /c " & "C:\Navi\nas.cmd")
	If WinExists("Microsoft Internet Explorer", "Request timeout") = 0 Then Call("Remlog")
	If WinExists("Microsoft Internet Explorer", "Request timeout") = 1 Then ControlSend("Microsoft Internet Explorer", "Request timeout", "Button1", "{ENTER}")
	Sleep(5000)
	EndIf
EndFunc

Func Remlog()
	If FileExists("C:\Navi\naslog.txt") Then RunWait(@ComSpec & " /c " & "del /q C:\Navi\naslog.txt")
	If FileExists("C:\Navi\iislog.txt") Then RunWait(@ComSpec & " /c " & "del /q C:\Navi\iislog.txt")
	If FileExists("C:\Navi\iislog1.txt") Then RunWait(@ComSpec & " /c " & "del /q C:\Navi\iislog1.txt")
EndFunc

Func CloseIE()
	ProcessClose("iexplore.exe")
	ProcessClose("iexplore.exe")
EndFunc

Func SessionTimeout()
	ControlSend("Microsoft Internet Explorer", "Session timeout - Please login", "Button1", "{ENTER}")
	Sleep(2000)
	ProcessClose("iexplore.exe")
	ProcessClose("iexplore.exe")
EndFunc