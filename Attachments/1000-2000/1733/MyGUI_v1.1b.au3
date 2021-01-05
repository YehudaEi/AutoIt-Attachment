;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Name: Auto Fire
; Version: 1.1
; Author: D'UnKNoWnUsEr
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Purpose: Allow user to enter in a window name, delay, and command
;    to send to said window every X delayed seconds. I have a working
;    NON Gui version of this application and it works. The benifit of
;    making it GUI is flexability. Version 1.0 is hardcoded with 
;    the delay, windowname, and command.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;    
; Version Releases:
;     1.0 = all hard coded and zero flexability.
;     1.1 = Gui and not hardcoded. See bug list for further issues.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Buglist:
;     Version 1.0 = no "bugs"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;     Version 1.1 = Start/Stop doesn't work as intended. Once the values
;               are set the only way to change them is to close and reload
;               the program.
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;
; How it's "suposed" to work step by step w/ example
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;  1. User loads application
;  2. User enters info into 3 fields
;  3. User sets values and gets a visual conframation the values are saved.
;  4.a The program will not send commands to $name untill its is the activewindow
;  4.b User clicks on Start/Stop to activate program
;  5. User toggles to said program in $name
;  6. Application begins sending $command every $delay seconds untill 
;	PAUSE/Break (hotkey) or Start/Stop (app button) is pressed.
;  7. User changes values in windows. (step 1)
;  8. User saves values. (step 2)
;  9. BUG!!.. new command/timer not recognized.
;
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
; Includes
#include <GUIConstants.au3>
#include <string.au3>
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;Create GUI
$WinMain = GUICreate("GUI Stroke",370,400)
$name = ""
$command = ""
$delay = "5"
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;Globals
Global $Paused
Global $running = 0
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;File Menu
$filemenu = GuiCtrlCreateMenu ("File")
$exititem = GuiCtrlCreateMenuitem ("Exit",$filemenu)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;Help Menu
$helpmenu = GuiCtrlCreateMenu ("Help")
$aboutitem = GuiCtrlCreateMenuitem ("About",$helpmenu)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;Buttons
$okbutton = GuiCtrlCreateButton ("Set Values",15,330,70,20)
$cancelbutton = GuiCtrlCreateButton ("Exit",87,330,70,20)
$run = GuiCtrlCreateButton ("Start/Stop",180,330,70,20)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;Window info
$lbl_windowname = GuiCtrlCreateLabel("Window Name", 180, 10, 131, 21, 0x1000)
$tb_windowname = GuiCtrlCreateInput("", 10, 10, 131, 21)

;Delay Info
$lbl_delay = GuiCtrlCreateLabel("Delay (in milliseconds)", 180, 40, 131, 21, 0x1000)
$tb_delay = GuiCtrlCreateInput("", 10, 40, 131, 21)

;Command Info
$lbl_command = GuiCtrlCreateLabel("Command to send", 180, 70, 131, 21, 0x1000)
$tb_command = GuiCtrlCreateInput("", 10, 70, 131, 21)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;Conframation that values were set
$lbl_setWindowname = GuiCtrlCreateLabel(" -- Window Not set -- ", 10, 130, 131, 21, 0x1000)
$lbl_setDelay = GuiCtrlCreateLabel(" -- Delay Not set -- ", 10, 160, 131, 21, 0x1000)
$lbl_setCommand = GuiCtrlCreateLabel(" -- Command Not set -- ", 10, 190, 131, 21, 0x1000)
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


;Start GUI Loop Till exit
GuiSetState()
While 1
	$msg = GUIGetMsg()
	

	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $cancelbutton
			ExitLoop
		
		;Case $msg = $fileitem
			;$file = FileOpenDialog("Choose file...",@TempDir,"All (*.*)")
			;If @error <> 1 Then GuiCtrlCreateMenuItem ($file,$recentfilesmenu)

		Case $msg = $exititem
			ExitLoop
		
		Case $msg = $run
			;If $running = 0 Then
			;	runProgram()
			;Else
			;	ExitLoop
			;EndIf
			;TogglePause()
			runProgram()
		
		;Saves info and puts them in a lable for conframation
		Case $msg = $okbutton
			setName()
			setCommand()
			setDelay()

		Case $msg = $aboutitem
			Msgbox(0,"About","If you have this program... you know who made it.")
	EndSelect
WEnd

;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

;Functions

;Pause/break for alternative way to pause program
Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('GUI autofire is "Paused"',10,5)
    WEnd
    ToolTip("")
EndFunc

Func Terminate()
    Exit 0
EndFunc

Func setName()
	$name = GUICtrlRead($tb_windowname)
	GuiCtrlSetData($lbl_setWindowname, $name)
EndFunc

Func setCommand()
	$command = GUICtrlRead($tb_command)
	GuiCtrlSetData($lbl_setCommand, $command)
EndFunc

Func setDelay()
	$delay = GUICtrlRead($tb_delay)8
	GuiCtrlSetData($lbl_setDelay, $delay)
EndFunc


Func doSleep()
	sleep($delay)
EndFunc


;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;The meat of the program
Func runProgram()
	WinWaitActive ($lbl_setWindowname)

	While 1
	    send($command)
	    Sleep($delay)
	WEnd

EndFunc
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
;~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~



GUIDelete()

Exit
