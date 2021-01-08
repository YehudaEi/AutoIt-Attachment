; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         Onoitsu2 <onoitsu2@yahoo.com>
;
; Script Function:
;	Automatically logon to NetZero (only if password is stored),
;	Hide the NetZero bar, and close the browser window that loads
;	with my.netzero.com
;	AND
;	If NetZero is running it will immediatly disconnect
;
;	Works on all NetZero install locations, as it reads the registry for
;	INSTALLDIR, then runs it, also can be used to see if NetZero is installed
;	at all.
;
; ----------------------------------------------------------------------------

Opt("WinTitleMatchMode",4)
If ProcessExists("exec.exe") Then
$iMsgBoxAnswer = MsgBox(266244,"Sign Off NetZero?","Sign Off NetZero??")
Select
   Case $iMsgBoxAnswer = 6 ;Yes
	$pos = MouseGetPos()
	ProcessClose("exec.exe")
	Sleep(5000)
	ProcessClose("exec.exe")
	Sleep(1000)
	MouseMove(700,755,0)
	MouseMove(@DesktopWidth,755,10)
	Sleep(500)
	MouseMove($pos[0],$pos[1],0)
   Case $iMsgBoxAnswer = 7 ;No
	Exit
EndSelect
Else
	$regloc = RegRead("HKLM\Software\NetZero, Inc.\NetZero","INSTALLDIR")
	If $regloc = "" AND NOT (@error = 0) Then
		MsgBox(266244,"NetZero Not Installed","Unable to Locate the Registry Entry for NetZero"&@CRLF&"This can mean that it is not installed, or installation has been corrupted."&@CRLF&"NetZero Auto Logon will not exit...")
		Exit 1
	EndIf
	Run($regloc&"\exec.exe")
	WinWait("Login to NetZero","",60)
	WinActivate("Login To NetZero")
	Sleep(1000)
	Send("{enter}")
	WinWait("NZTV","",60)
	If NOT WinWaitClose("NZTV","",60) Then
		WinActivate("NZTV")
		Send("{tab}{enter}")
		MsgBox(0,"An Error Occurred During Connection!","An Error Occurred During Connection!"&@CRLF&"Auto Logon App Shutting Down...")
		Exit
	EndIf
;~ 	WinSetState("NetZero","",@SW_MINIMIZE)
	WinWaitActive("NetZero","",60)
	WinSetState("NetZero","",@SW_HIDE)
	WinWait("http://my.netzero.net","",60)
	WinClose("http://my.netzero.net","")
	Exit
EndIf
