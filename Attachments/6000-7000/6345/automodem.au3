; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         HVDII 
;
; Script Function:
;	Automated Dialup Modem Testing Program.
;
; Script Overview:
; This script will allow you test automatically dialup connections
; to specified dialup numbers automatically while logging the information
; real-time as well as in log files for later review and email notifications
;
; Script Example:
; Your an ISP and you want to test your dialup numbers that you have 
; associated with your Dialup Service.
;
; Each T1 into your Dialup Router has an specified phone number
;
; Launch the automotem.exe (the script) and setup the following information:
; 1.Configuration, Phone Book Settings: Setup your dialup entries
; 2.Configuration, Dialup Settings: Select your dialup numbers you want to test
;									and the duration in min.
; 3.Configuration, FTP Settings: Setup your FTP Server IP, Username, Password
;								 and file you want to upload. This is used to
;							     keep traffic flowing so you dont idle-timeout.
; 4.Configuration, Notification Settings: Setup your SMTP Server, Email To
;										  information and Subject.
; 5.Click the Dial Button and the Job Starts.
; 6.You are able to review real-time the job state in the text box
; 7.You are able to review the Job Status via the Job Status Bar
;
; IF USED:
;
; 8.The Job will complete and log the information in a log file and email the 
;   report to the specified email address upon completion.
; 9.The disconnect button will disconnect that particular connection that is active
; 10.The cancel button will cancel the entire job and email the report.
; ----------------------------------------------------------------------------

; future to do list
; add log
; add status bar / progress bar
; add F1 help function to launch help file

; still left to accomplish:
; 1. create all of my menu gui's
; 2. create menu functions
; 3. create a logging mechanism and real-time display script
; 4. testing....



; Script Start - Add your code below here




#include <GUIConstants.au3>
#include <phonebooksettings.au3>
#include <file.au3>

;creating gui window
GUICreate("Automatic Dialup Modem Testing...",400,400)

;creating gui window icon
GUISetIcon ("modem.ico")

;Create an edit box with no text in it
;This edit box will be used to as a real-time display for the log file
$Edit_1 = GUICtrlCreateEdit("", 10, 20, 380, 270)

;creating status variable for job status indicator
;this will be used for displaying the job progress
Global $jobstatus = "Ready"
Global $status


;creating jobstatusgroup
;this is the box around the jobstatus progress bar
$jobstatusgroup = GUICtrlCreateGroup ("Job Status", 10, 330, 380, 40)

;creating status bar
;this will be used for displaying the job progress
$jobstatuslabel = GUICtrlCreateLabel ($jobstatus,20,345,360,16,BitOr($SS_SIMPLE,$SS_SUNKEN))
GUICtrlSetState(-1,$GUI_CHECKED)

;creating the menu
;just that, creating the menus
$configmenu = GUICtrlCreateMenu ("&Configuration") 
$viewmenu = GUICtrlCreateMenu ("&View") 
$helpmenu = GUICtrlCreateMenu ("Help")


;creating the sub-menu for configuration menu
;phone book settings will launch a script to create and log dialup entries
;dialup settings will display the phone book entries and allow you to choose which
;entries you want to use for the job as well the connection duration
;ftp settings allows you to setup your ftp server, username, password and file to upload
;notification settings is where you will setup your email settings for job logs
$phoneentry = GUICtrlCreateMenuitem ("Phone Book Settings ",$configmenu)
$dailsetitem = GUICtrlCreateMenuitem ("Dialup Settings",$configmenu)
$ftpsetitem = GUICtrlCreateMenuitem ("FTP Settings",$configmenu)
$notsetitem = GUICtrlCreateMenuitem ("Notification Settings",$configmenu)
$exititem = GUICtrlCreateMenuitem ("Exit",$configmenu)

;creating the sub-menu for view menu
;allows you to open up saved log files
$logsitem = GUICtrlCreateMenuitem ("Log Files",$viewmenu)

;creating the sub-menu for help menu
;setup / configuration just launches a help file
;technical support just displays support information
;updates displays links to any upgrades
;about displays the program ver, etc...
$setupcfgitem = GUICtrlCreateMenuitem ("Setup / Configuration [ F1 ]",$helpmenu)
$techsupitem = GUICtrlCreateMenuitem ("Technical Support",$helpmenu)
$updatesitem = GUICtrlCreateMenuitem ("Updates",$helpmenu)
$aboutitem = GUICtrlCreateMenuitem ("About",$helpmenu)

;creating buttons for main screen
;just that creating buttons
$dialbutton = GUICtrlCreateButton ("Dial",160,305,70,20) ;325
$disconnectbutton = GUICtrlCreateButton ("Disconnect",240,305,70,20)
$cancelbutton = GUICtrlCreateButton ("Cancel",320,305,70,20)


GUISetState ()
While 1
	$msg = GUIGetMsg()
	
	Select
	
	;displays technical support msgbox if clicked
	Case $msg = $techsupitem
		MsgBox(0, "Technical Support", "No Technical Support" & @CRLF & "Available." & @CRLF & "The END!")
	
	;displays updates msgbox if clicked
	Case $msg = $updatesitem
		MsgBox(0, "Updates", "GO HERE" & @CRLF & "HTTP://" & @CRLF & "ANYWHERE")
	
	;displays about us msgbox if clicked
	Case $msg = $aboutitem
		MsgBox(0, "About", "Information about this program" & @CRLF & "version 0.5" & @CRLF & "Powered By: US")
	
	
	;Check if user clicked on the "Dial" button
	;Used in testing phase to make sure the function is working properly
	;Long term, when you click the test button, it will launch the dial script
	;that will in turn dial your connection, start an ftp session and upload
	;a file, then disconnect and go to the next connection and start the process over
	;again while logging this information the information in a log file.
	Case $msg = $dialbutton
        RunWait( @SystemDir & '\rasdial $connection $username $password', "", @SW_HIDE)
		
		
	;Check if user clicked on the "DISCONNECT" button
     	Case $msg = $disconnectbutton
		RunWait( @SystemDir & "\rasdial.exe /disconnect", "", @SW_HIDE) 

	EndSelect

	If $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton Or $msg = $exititem Then ExitLoop
WEnd
GUIDelete()

Exit

