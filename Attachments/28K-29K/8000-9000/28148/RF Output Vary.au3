; ***********************************************  Author : Vishwas K S ***********************************************************
; ***********************************************  Group  : CSG-1 *****************************************************************
; ***********************************************  Testing Team *******************************************************************


#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include <WinAPI.au3>
#include <File.au3>
#include <Array.au3>
#include <guiconstantsex.au3>
#include <gdiplus.au3>
#include <Variables.au3>
#include <Misc.au3>

FileInstall ( "Var.exe", @ScriptDir & "\" ,1)
FileInstall ( "Wave.jpg", @ScriptDir & "\" ,1)
;To ensure only single instance of application is opened
_Singleton("RF Attenuation Tool")



Global $iMemo


	;Creating a file and checking if the file is already open or not
	$file = FileOpen("./Log.txt", 2)
	; Check if file opened for writing OK
	If $file = -1 Then
	MsgBox(0, "Error", "Unable to open file.")
	Exit
EndIf

	;Ensures all the variables are declared before using
	Opt('MustDeclareVars',1)
	;Recognises the events like button press through out the script
	Opt("GUIOnEventMode",1)
	Opt("GUIResizeMode",1)

	;Use the break/pause key to pause the script
	HotKeySet("{PAUSE}", "TogglePause")

	;Use the Esc key to stop the script
	HotKeySet("{ESC}", "Terminate")

	;If user wants to launch the application newly the below line can be uncommented
	;Run("C:\Program Files\DekTec\StreamXpress\StreamXpress.exe")

	;Activates the alreay opened Dektec application
	WinActivate("DekTec StreamXpress - Transport-Stream Player")

	;Moves the application to screen co-ordinates to 0,0
	WinMove("DekTec StreamXpress - Transport-Stream Player", "", 0, 0)
	Sleep(1000)

	; Now quit by pressing Alt-f and then x (File menu -> Exit)
	Send("{Alt}{s}")
	Sleep(1000)

	;Accesses the Sub option under Settings menu
	Send("r")
	Sleep(1000)

	;Select the RF output option from menu
	Send("{ENTER}")
	;WinActivate("RF Output Level")
	WinMove("RF Output Level", "", 0, 0)
	Sleep(1000)

	;Sets the RF output level to 3.0 as default
	ControlSetText ( "RF Output Level", " ", "Edit1", "-3.0")
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;calling the UI function
;creates a memo where the logs can be written with the help of memowrite function
 UI()

   Func UI()

   	Local $hGUI

   	; Create GUI
	;$hGUI = GUICreate("RF Log", 500, 500)
	$iMemo = GUICtrlCreateEdit("", 2, 2, 496, 496, $WS_VSCROLL)
   	GUICtrlSetFont($iMemo, 9, 200, 0, "Courier New")
   	GUISetState()
EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	$destination = "./Wave.jpg"

	SplashImageOn("Please Ensure Streamer Xpress Application Is Launched", $destination,350,150)
	Sleep(5000)
	SplashOff()

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	Local $msg

	;Creates the GUI with preferred size
    GUICreate("RF Attenuation Tool", 450, 450)
	;Moves the application to the below specified co-ordinates area on your screen
	WinMove("RF Attenuation Tool", "", 677, -1)
	;Sets the GUI state to active
	GUISetState(@SW_SHOW)

	;variables for creating menus
	Local $filemenu,$filesubmenu,$Helpsubmenu,$Help
	;File menu creation
	$filemenu = GUICtrlCreateMenu("File")
	;File submenu creation
	$filesubmenu = GUICtrlCreateMenuItem("Exit", $filemenu)
	;Captures if Exit option is selected from menu
	GUICtrlSetOnEvent($filesubmenu, "_exitPressed")
	;Help menu creation
	$Help = GUICtrlCreateMenu("Help")
	;Help submenu creation
	$Helpsubmenu = GUICtrlCreateMenuItem("About", $Help)
	;Captures if About option is selected from menu
	GUICtrlSetOnEvent($Helpsubmenu, "_help")
	;Sets the window active
	GUISetState ()


	;GUISetState()
	;setting the required font
	Local $font = "Monotype Corsiva"
	;Setting the font for the Title
	GUISetFont(25, 400, 4, $font)
	GUICtrlCreateLabel("RF Attenuator ", 150, -10)

	$font = "Comic Sans MS"
    GUISetFont(10, 500, 0, $font)

	;Drawing a rectangle for the help text
	$a[1] = GUICtrlCreateGraphic(10, 260, 380, 110)

	;Setting background color to transperent
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetColor(-1, 0)

	;Adding the required labels on to the UI
	GUICtrlCreateLabel("RF value initially set is: ", 20, 40)
	GUICtrlCreateLabel("RF value after sequentially incrementing is : ", 20, 70)
	GUICtrlCreateLabel("RF value after sequentially decrementing is : ", 20, 130)
	GUICtrlCreateLabel("RF value after random change is : ", 20, 180)

	;Text field for user to enter the delay
	GUICtrlCreateLabel("Enter the delay value for RF sequential increment : ", 20, 90)
	GUICtrlCreateInput($delayseqinc, 350, 90, 50, 20)

	;Allows only 4 number to be entered
	GUICtrlSetLimit (-1,4)

	;Text field for user to enter the delay
	GUICtrlCreateLabel("Enter the delay value for RF sequential decrement : ", 20, 150)
	$focus = GUICtrlCreateInput($delayseqdec, 350, 150, 50, 20)

	;Allows only 4 number to be entered
	GUICtrlSetLimit (-1,4)

	;Text field for user to enter the delay
	GUICtrlCreateLabel("Enter the delay value for RF random change : ", 20, 200)
	$focusrand = GUICtrlCreateInput($delayrand, 350, 200, 50, 20)

	;Allows only 4 number to be entered
	GUICtrlSetLimit (-1,4)

	;creating a label for prinitng dBm text for initial RF value
	GUICtrlCreateLabel("dBm", 390, 40,50,15)

	;creating a label for prinitng dBm text for sequential RF Value increment
	GUICtrlCreateLabel("dBm", 390, 70,50,15)

	;creating a label for prinitng dBm text for sequential RF Value decrement
	GUICtrlCreateLabel("dBm", 390, 130,50,15)

	;creating a label for prinitng dBm text for random RF values
	GUICtrlCreateLabel("dBm", 390, 180,50,15)


 Func _help()
     	Local $Msgfonts,$OKButton,$helpopupUI,$close
		;Creates the UI for the help menu
		$helpopupUI = GUICreate("About", 270, 130)
		;Moves the UI to the specifed co-ordinates
		WinMove("About", "", 599, 113)
		;Creating ok button in UI
		$OKButton = GUICtrlCreateButton("OK", 80, 100, 80)
		;Assigning the event for ok button press
	    GUICtrlSetOnEvent($OKButton, "_Helpclose")
		$Msgfonts = "Comic Sans MS"
		GUISetFont(9, 600, 0, $Msgfonts)
		;Text display in the about box
		GUICtrlCreateLabel("Version   :   1.0  ", 10, 10)
		GUICtrlSetColor(-1, 0x7A55D8)
		GUICtrlCreateLabel("Author    :   Vishwas K S  ", 10, 30)
		GUICtrlSetColor(-1, 0x7A55D8)
		GUICtrlCreateLabel("Company  :   LG Soft India Pvt Ltd  ", 10, 50)
		GUICtrlSetColor(-1, 0x7A55D8)
		GUICtrlCreateLabel("Email ID :   vishwas@lge.com  ", 10, 70)
		GUICtrlSetColor(-1, 0x7A55D8)
		GUISetState()
		sleep(1000)
		;GUICtrlSetState(-1, $GUI_DISABLE)
		;Waits for the about popup to close if not timeout happens
		WinClose("About")
EndFunc

;Closes the Help UI on pressing ok button
Func _Helpclose()
	GUIDelete()
EndFunc

;Exits the application if the exit option is selected from menu
Func _exitPressed()
    Exit 0
EndFunc

;Calling the set font function
fontsize()

Func fontsize()
	    ;Setting the font size for hotkey/Button messages shown in the application
	    Local $Msgfont
		$Msgfont = "Monotype Corsiva"
		GUISetFont(13, 650, 2+4, $Msgfont)
		GUICtrlCreateLabel("Application Controls :", 20, 232)
EndFunc

Helptext()

Func Helptext()
		;Setting the font message for the hotkeys
		Local $Msgfonts,$Buttonmsg = String(50)
		$Msgfonts = "Comic Sans MS"
		GUISetFont(8, 500, 0, $Msgfonts)

		GUICtrlCreateLabel("Press Start button to start the Application", 20, 268)
		GUICtrlCreateLabel("Press Break key to pause the Application", 20, 287)
		GUICtrlCreateLabel("Press Break key on the keyboard to Resume", 20, 305)
		GUICtrlCreateLabel("Press Esc key on the keyboard to close the Application", 20, 325)
		GUICtrlCreateLabel("Press Lock button to lock this Application from being moved / dragged", 20, 343)

		GUISetFont(8.5, 400, 0, $Msgfonts)

		;Creating the Pause button
		;$pauseButton = GUICtrlCreateButton("Pause",120,380,80,30)
		;On key press control jumps to TogglePause function
		;GUICtrlSetOnEvent(-1, "TogglePause")

		;Creating the Exit button
		;$closeButton = GUICtrlCreateButton("Exit",220,380,80,30)
		;On key press control jumps to Terminate function
		;GUICtrlSetOnEvent(-1, "Terminate")

		;Creating the Start button
		$startButton = GUICtrlCreateButton("Start",80,380,130,30)
		;setting the focus on the start button
		GUICtrlSetState(-1, $GUI_FOCUS)
		;On key press control jumps to start function
		$startpress = GUICtrlSetOnEvent($startButton, "start")
	EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;pausing the script playback
Func TogglePause()

    $Paused = NOT $Paused
    While $Paused
		;Disabling the Pause Button
		GUICtrlSetState($pauseButton, $GUI_DISABLE)
        sleep(100)
		ToolTip('"Application is in Pause state - Press Break key on keyboard to Resume"',684,9)
	WEnd
		ToolTip("Application is in Unpause state",684,9)
		;Enabling the Pause Button
		;GUICtrlSetState($pauseButton, $GUI_ENABLE)
EndFunc
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

Func Terminate()
	ToolTip('Application is stopped',684,9)
	sleep(3000)
    Exit 0
EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

;start the execution
 Func start()
		if $startpress = 1 Then
		  ChangeRF()
		  ;Delay is inserted in order to ensure delay is seen between jumping to next function
		  Sleep(2000)
   		  RFSeqincr()
		  ;Delay is inserted in order to ensure delay is seen between jumping to next function
		  Sleep(2000)
		  RFSeqdecr()
		  ;Delay is inserted in order to ensure delay is seen between jumping to next function
		  Sleep(2000)
   		  Rand()
   	    EndIf
EndFunc
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;ChangeRF()

;calling the change RF function which changes the RF value sequentially and Randomly as well

Func ChangeRF()
	;Disabling the Lock button after the start button is clicked
	GUICtrlSetState($lockbutton, $GUI_DISABLE)
	;Disabling the Start button after the start button is clicked
	GUICtrlSetState($startButton, $GUI_DISABLE)
	;Disabling the File menu after the start button is clicked
	GUICtrlSetState($filemenu, $GUI_DISABLE)
	;Disabling the Help menu after the start button is clicked
	GUICtrlSetState($Help, $GUI_DISABLE)
	sleep(500)
	;Setting the font for the RF values being printed on the application
	$fontRF = "Comic Sans MS"
    GUISetFont(10, 600, 0, $fontRF)

 	Local $rfinitial = String(50)
	Local $msg
 	MouseClick("",137,66,1,1)

	;Activating the Streamer Xpress screen
	WinWaitActive("[TITLE:RF Output Level; CLASS:Edit1; INSTANCE:1]", "")
	;Fetching and printing the  initial value of RF Output value from the Stream Xpress app

	$rfinitial=WinGetText("[active]")
  	WinActivate("RF Attenuation Tool")

	;Writing the initial rf value to the label
	GUICtrlCreateLabel($rfinitial, 350, 40,35,15)

	;Printing the current Date and Time with initial RF output value
 	MemoWrite("RF value initially is : " & $rfinitial & "" & @CRLF & "Date and Time is: " & _Now() & @CRLF )
	MemoWrite("*****************************************************")
	Sleep(1000)
EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
;Locking the application from being moved by the user

	;Creating the Lock button
	Local $Lockfont

	;$Lockfont = "Comic Sans MS"
	GUISetFont(8.5, 400, 0, $Lockfont)

	$lockbutton = GUICtrlCreateButton("Lock ",220,380,130,30)
	;On key press control jumps to detectkeypress function
	$keypress = GUICtrlSetOnEvent($lockbutton, "detectkeypress")

	;Locking the screen using this variable
	Const $SC_MOVE = 0xF010

	;Control enters this function only if the user has pressed the Lock button
Func detectkeypress()
	if $keypress = 1 Then
	;Registry command for locking the screen
	GUIRegisterMsg($WM_SYSCOMMAND, "WM_SYSCOMMAND")
	;Disables the lock button after pressing once
	GUICtrlSetState($lockbutton, $GUI_DISABLE)
	EndIf
EndFunc

	;Function for locking the application screen
Func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
    If BitAND($wParam, 0x0000FFF0) = $SC_MOVE Then Return False
    Return $GUI_RUNDEFMSG
EndFunc
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	;Sequential Execution of RF output value

	;calling the sequential increasing function
	;RFSeqincr()

Func RFSeqincr()

	;Stores the delay value entered by the user
	Local $getuserdelayincr = String(50)

	;Variable which holds the flag value of stringisdigit
	Local $chk

	;Accepts the user entered delay value in this variable
	Local $newvalue

	WinActivate("RF Attenuation Tool")
	;Delay is provided in order to ensure enough time is provided to user to enter the delay he/she needs
	sleep(2000)

	;If user does not enter any value then the delay value taken is 4000
	if $delayseqinc = 0 Then
	   $delayseqinc = 4000
		;message box to ensure users input has been accepted
		MsgBox(64, "Delay value for sequential decrement is", $delayseqinc, 5)
	EndIf

	;Get the delay value entered by the user
	$getuserdelayincr = ControlGetText("RF Attenuation Tool",$newvalue,"Edit1")

	;Checking the user delay iput if it is of type int it returns 1 to $chk it not returns 0
	$chk = StringIsDigit($getuserdelayincr)

	;Checking if $chk returned 1 or 0
	if $chk == 1 Then
		MsgBox(64, "Delay value after sequential increment is", $getuserdelayincr, 5)
	Elseif $chk == 0 Then
		MsgBox(16,"","Please enter numeric value else delay will be set to default value(4sec)",10)
		;Clearing the text field
		ControlSetText("RF Attenuation Tool","","Edit1","")
		;Initializing the sequential increment function again
		ControlSetText("RF Attenuation Tool","","Edit1",$delayseqinc)
		;After wrong entry sufficient time is given to user to re-enter the delay value
		sleep(4000)
		;Initializing the sequential increment function again
		RFSeqincr()
		sleep(500)
	EndIf

	;Iteration to increment the RF Output value to -38.0
	for $i = 3 to 73 Step 1

	Sleep($getuserdelayincr)

	;Moves the cursor for increasing the RF output level
	MouseMove(181,70,1)
	MouseClick("",181,70,1,30)
	;Fetching and printing the RF Output value from the Stream Xpress RF Output screen
	$seqrfinc=WinGetText("[active]")

	;Setting the font for the RF attenuation values
	GUISetFont(10, 600, 0, $fontRF)

	;Wrting the rf values to the label
	GUICtrlCreateLabel($seqrfinc, 350, 70,39,15)

	;Delay to ensure the repaint of the RF value on the UI is happening fine
	Sleep(100)

	;Printing the current Date and Time with RF output value
	MemoWrite("RF value is " & $seqrfinc & "" & @CRLF & "Date and Time after increasing the RF value is: " & _Now() & @CRLF )
	MemoWrite("*****************************************************")
	Next
	MemoWrite(" ")

EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
	;Sequential Execution of RF output value

	;calling the sequential decreasing function
	;RFSeqdecr()

Func RFSeqdecr()

	Local $j

	;Variable which holds the flag value of stringisdigit
	Local $chk1

	;Stores the delay value entered by the user
	Local $getuserdelaydecr = String(50)

	;user entered delay value is stored in this variable
	Local $newvalue1

	WinActivate("RF Attenuation Tool")

	;sets the focus on the sequential decreasing delay textbox
	GUICtrlSetState($focus, $GUI_FOCUS)
	sleep(5000)

	;If user does not enter any value then the delay value taken is 4000
	if $delayseqdec = 0 Then
	   $delayseqdec = 4000
		;message box to ensure users input has been accepted
		MsgBox(64, "Delay value for sequential decrement is", $delayseqdec, 5)
	EndIf

	;Get the delay value entered by the user
    $getuserdelaydecr = ControlGetText("RF Attenuation Tool",$newvalue1,"Edit2")

	;Checking the user delay iput if it is of type int it returns 1 to $chk1 it not returns 0
	$chk1 = StringIsDigit($getuserdelaydecr)


	;Checking if $chk returned 1 or 0
	if $chk1 = 1 Then
		MsgBox(64, "Delay value after sequential decrement is", $getuserdelaydecr, 5)
	Elseif $chk1 = 0 Then
		MsgBox(16,"","Please enter numeric value if not delay will be set to default value(4sec)",10)
		;Clearing the text field
		ControlSetText("RF Attenuation Tool","","Edit2","")
		;If user enters wrong value the the value defined for variable $delayseqdec will be taken as default
		ControlSetText("RF Attenuation Tool","","Edit2",$delayseqdec)
		;After wrong entry sufficient time is given to user to re-enter the delay value
		sleep(4000)
		;Initializing the sequential decrement function again
		RFSeqdecr()
		sleep(500)
	EndIf

	;Iteration to increment the RF Output value to -38.0
	for $j = 73 to 4 Step -1

	Sleep($getuserdelaydecr)

	;Moves the cursor for decreasing the RF output level
    MouseMove(181,60,1)
    MouseClick("",181,60,1,30)
    ;Fetching and printing the RF Output value from the Stream Xpress RF Output screen
    $seqrfdec=WinGetText("[active]")
	Sleep(500)

	;Setting the font for the RF attenuation values
	GUISetFont(10, 600, 0, $fontRF)

	;Writing the rf values to the label
	GUICtrlCreateLabel($seqrfdec, 350, 130,39,15)

	;Delay to ensure the repaint of the RF value on the UI is happening fine
	Sleep(500)

	;Printing the current Date and Time with RF output value
	MemoWrite("RF value is " & $seqrfdec & "" & @CRLF & "Date and Time after decreasing the RF value is: " & _Now() & @CRLF )
	MemoWrite("*****************************************************")
    Next
    MemoWrite("Decrementing Completed")
	MemoWrite("*****************************************************")
EndFunc

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	;Random Execution of RF output value

	;changing the RF value randomly
	;Rand()

Func Rand()

	;Declaring the local variables
	Local $click

	;Variable which holds the flag value of stringisdigit
	Local $chk2

	;Array which hold the random values
	Local $randval[80]

	;Stores the delay value entered by the user
	Local $getuserdelayrand  = String(50)

	;user entered delay value is stored in this variable
	Local $newvalue2


	WinActivate("RF Attenuation Tool")
	;sets the focus on the random delay textbox
	GUICtrlSetState($focusrand, $GUI_FOCUS)
	sleep(3000)

	;If user does not enter any value then the delay value taken is 4000
	if $delayrand = 0 Then
	   $delayrand = 4000
		;message box to ensure users input has been accepted
		MsgBox(64, "Delay value for random change is", $delayrand, 5)
	EndIf

    ;Get the delay value entered by the user
    $getuserdelayrand = ControlGetText("RF Attenuation Tool",$newvalue2,"Edit3")

	;Checking the user delay iput if it is of type int it returns 1 to $chk1 it not returns 0
	$chk2 = StringIsDigit($getuserdelayrand)


	;Checking if $chk returned 1 or 0
	if $chk2 = 1 Then
		MsgBox(64, "Delay value for random change is", $getuserdelayrand, 5)
	Elseif $chk2 = 0 Then
		MsgBox(16,"","Please enter numeric value if not delay will be set to default value(4sec)",10)
		;Clearing the text field
		ControlSetText("RF Attenuation Tool","","Edit3","")
		;If user enters wrong value the the value defined for variable $delayrand will be taken as default
		ControlSetText("RF Attenuation Tool","","Edit3",$delayrand)
		;After wrong entry sufficient time is given to user to re-enter the delay value
		sleep(4000)
		;Initializing the Random function again
		Rand()
		sleep(5000)
	EndIf

	;Storing the RF values in Array and then passing it to random function

	$randval[0] = "-3.0"
	$randval[1] = "-3.5"
	$randval[2] = "-4.0"
	$randval[3] = "-4.5"
	$randval[4] = "-5.0"
	$randval[5] = "-5.5"
	$randval[6] = "-6.0"
	$randval[7] = "-6.5"
	$randval[8] = "-7.0"
	$randval[9] = "-7.5"
	$randval[10] = "-8.0"
	$randval[11] = "-8.5"
	$randval[12] = "-9.0"
	$randval[13] = "-9.5"
	$randval[14] = "-10.0"
	$randval[15] = "-10.5"
	$randval[16] = "-11.0"
	$randval[17] = "-11.5"
	$randval[18] = "-12.0"
	$randval[19] = "-12.5"
	$randval[20] = "-13.0"
	$randval[21] = "-13.5"
	$randval[22] = "-14.0"
	$randval[23] = "-14.5"
	$randval[24] = "-15.0"
	$randval[25] = "-15.5"
	$randval[26] = "-16.0"
	$randval[27] = "-16.5"
	$randval[28] = "-17.0"
	$randval[29] = "-17.5"
	$randval[30] = "-18.0"
	$randval[31] = "-18.5"
	$randval[32] = "-19.0"
	$randval[33] = "-19.5"
	$randval[34] = "-20.0"
	$randval[35] = "-20.5"
	$randval[36] = "-21.0"
	$randval[37] = "-21.5"
	$randval[38] = "-22.0"
	$randval[39] = "-22.5"
	$randval[40] = "-23.0"
	$randval[41] = "-23.5"
	$randval[42] = "-24.0"
	$randval[43] = "-24.5"
	$randval[44] = "-25.0"
	$randval[45] = "-25.5"
	$randval[46] = "-26.0"
	$randval[47] = "-26.5"
	$randval[48] = "-27.0"
	$randval[49] = "-27.5"
	$randval[50] = "-28.0"
	$randval[51] = "-28.5"
	$randval[52] = "-29.0"
	$randval[53] = "-29.5"
	$randval[54] = "-30.0"
	$randval[55] = "-30.5"
	$randval[56] = "-31.0"
	$randval[57] = "-31.5"
	$randval[58] = "-32.0"
	$randval[59] = "-32.5"
	$randval[60] = "-33.0"
	$randval[61] = "-33.5"
	$randval[62] = "-34.0"
	$randval[63] = "-34.5"
	$randval[64] = "-35.0"
	$randval[65] = "-35.5"
	$randval[66] = "-36.0"
	$randval[67] = "-36.5"
	$randval[68] = "-37.0"
	$randval[69] = "-37.5"
	$randval[70] = "-38.0"

while(1)

	;Randomizes the RF values
	$click = Random(0,70,1)

	;This message box is inserted to check if the random values obtained are correct(Verification)
	;MsgBox(0,"",$randval[$click],1)

	WinActivate("RF Output Level")

	;Writing the random value onto the Stream Xpress
	ControlSetText ( "RF Output Level", " ", "Edit1", $randval[$click])
	Sleep(1000)


	;Fetching and printing the RF Output value from the Stream Xpress RF Output screen
	$rfrand=WinGetText("[active]")
	Sleep(500)

	;Setting the font for the RF attenuation values
	GUISetFont(10, 600, 0, $fontRF)

	;Wrting the random values to the label
	GUICtrlCreateLabel($rfrand, 350, 180,39,15)


	Sleep(500)
	WinActivate("RF Output Level")

	;Printing the current Date and Time with RF output value
	MemoWrite("RF value is " & $rfrand & "" & @CRLF & "Date and Time after randomly changing the RF is: " & _Now() & @CRLF )
	MemoWrite("*****************************************************")

WEnd ; Ending while loop

EndFunc
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
Do
Until GUIGetMsg() = $GUI_EVENT_CLOSE

;Writing the output on to a memo file
Func MemoWrite($sMessage)
	sleep(200)
	;Writing every line to log file
	FileWriteLine($file, $sMessage)
	GUICtrlSetData($iMemo, $sMessage & @CRLF, 1)
	;Sleep(10000)
	GUISetState()

	;Closing the app as well as the log file
	If(GUIGetMsg() = $GUI_EVENT_CLOSE) Then
	;Closing the Log file
	FileClose($file)
	Exit
	EndIf

EndFunc   ;==>MemoWrite


;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

