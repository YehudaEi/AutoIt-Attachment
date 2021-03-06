#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=serverwatcher.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;==============================================================
;SERVER WATCHER WRITTEN BY GSPINO 3/24/2005
;==============================================================
;SET OPTIONS AND DECLARE VARIABLES
AutoItSetOption("TrayIconHide", 0)
HotKeySet("^{F2}", "ExitFunc") ; HOT KEY TO EXIT PROGRAM [CTRL- F2]
$HostFile = "Servers.txt"
;==============================================================
$var1 = InputBox("Server Watcher", " Enter Ping Timeout Value in Milliseconds" & @CRLF & "(4000 default without input)" & @CRLF & @CRLF & "NOTE: Ctrl-F2 Hotkey to exit program")
If @error = 1 Then
	MsgBox(0, "User Cancelled", "User cancelled, Exiting Program", 3)
	Exit
EndIf
;==============================================================
;OPEN HOSTS FILE, SERVERS.TXT
While 1
	$file = FileOpen($HostFile, 0)
	;IF SERVERS.TXT FILE IS MISSING FROM PROGRAM DIRECTORY, DISPLAY MESSAGE AND EXIT
	If $file = -1 Then
		MsgBox(16, "Server Watcher", " Sorry can't proceed. " & @CRLF & " The File : ' Servers.txt ' is missing in the application directory ")
		Exit
	EndIf
	;SEQUENTIALLY READ EACH SERVER NAME AND USE IN ROUTINE
	While 1
		$Host = FileReadLine($file)
		If @error = -1 Then ExitLoop
		;PING THE SERVER
		$task1 = Ping($Host, $var1)
		If Not $task1 Then
			TrayTip("Offline", $Host & "  is Off-Line! ", 5, 2)
			Sleep(3000)
		EndIf
	WEnd
	FileClose($file)
	Sleep(30)
WEnd
;==============================================================
Func ExitFunc()
	$Answer = MsgBox(4, "Server Watcher", " End the Server Watcher Program? ")
	If $Answer <> 7 Then Exit
EndFunc   ;==>ExitFunc
;==============================================================