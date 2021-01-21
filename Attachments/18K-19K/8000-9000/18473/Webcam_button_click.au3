#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Christer Helland
 Script Version: 1.0 Stable
 Script Function: Webcam monitoring button presser
	

#ce ----------------------------------------------------------------------------

;  The beginning of the script starts with a 20 second wait time to let things settle after a startup upon which it begins the start() function.

Sleep (20000)
$foldercheck = 0
start()

; Once start() is complete it will perform the button click and send the keypresses to lock the server.

FileWriteLine ("C:\scriptlog\scriptlog.txt", "Moving mouse to coordinates.")
Sleep (10000)
MouseMove (334, 418)

; Writing it to the log for debugging purposes.

FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Mouse moved, clicking button next.")

MouseClick ( "left" )

; Also writing to log for debugging purposes

FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Button clicked, motion recording should now be set.")

; Now to send the lock keys to lock the server.
FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Sending lock keys")
Sleep ( 1000 )
Send ("#l")
FileWriteLine ( "C:\scriptlog\scriptlog.txt", "All functions completed, lock keys sendt, closing logfile.")
FileClose ("C:\scriptlog\scriptlog.txt")

Exit
; ______________________ FUNCTIONS ______________________________________

; This is just for renaming the start function to the first step in the entire startup check.

Func start()
logdircheck()
EndFunc

; Function logdircheck() checks that a log dir and a logfile has been created before beginning mouseclick action.

Func logdircheck()
If FileExists("C:\scriptlog\") Then 
	logfilecheck() 
Else 
	DirCreate("C:\scriptlog\")
	$foldercheck = 1
		logdircheck()
EndIf
EndFunc

; Function logfilecheck() checks that the logfile is created and is also told if the logdir was not created previously.

Func logfilecheck() 
	If Not FileExists ( "C:\scriptlog\scriptlog.txt" ) And $foldercheck = 1 Then 
		FileOpen ( "C:\scriptlog\scriptlog.txt", 2) 
		FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Directory created and logfile created, moving on with start()")
		startcheck()
	ElseIf FileExists ( "C:\scriptlog\scriptlog.txt" ) And $foldercheck = 0 Then 
		FileOpen ( "C:\scriptlog\scriptlog.txt", 2) 
		FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Log file and log directory already created, continue to start() ")
		startcheck()
	ElseIf Not FileExists ( "C:\scriptlog\scriptlog.txt" ) And $foldercheck = 0 Then 
		FileOpen ( "C:\scriptlog\scriptlog.txt", 2) 
		FileWriteLine ( "C:\scriptlog\scriptlog.txt", "Directory exists but logfile is not created, creating it now and re-checking")
		FileClose ( "C:\scriptlog\scriptlog.txt" )
		logfilecheck()
		EndIf
	EndFunc

; Function startcheck() begins the start up check script by checking for the IPView SE window and/or waiting for it, before moving on to the mouse click.

Func startcheck()
if WinExists( "IPView SE" ) Then 
	FileWriteLine ( "C:\scriptlog\scriptlog.txt", "IPView SE started, proceeding to click button.") 
Else 
	FileWriteLine ( "C:\scriptlog\scriptlog.txt", "IPView not SE started, proceeding to wait for it to start. ") 
	waitwindow()
EndIf	
EndFunc

; Function waitwindow() waits for window to become active

Func waitwindow()
	If WinWait ("IPView SE", "", 100000) = 1 Then 
		startcheck() 
	Else 
		FileWriteLine ( "C:\scriptlog\scriptlog.txt", "The IPView SE program has not started within 10 minutes or has failed to be detected. Writing out log file.")
		FileClose ( "C:\scriptlog\scriptlog.txt" )
		Exit
EndIf
EndFunc