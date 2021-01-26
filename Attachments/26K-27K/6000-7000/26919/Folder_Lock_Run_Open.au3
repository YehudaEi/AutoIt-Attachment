;#========================#
;#==Folder Lock Run+Open==#
;#=====with settings======#
;#========================#
;#=========By Tim=========#
;#=====(ShurikenJutsu)====#
;#====for AutoItForums====#
;#========================#


;Variable is declared
Global $passowrd

;Setting the $iniexists variable for use in line 8
$iniexists = FileExists("settings.ini")
;Reading the Password value from the settings file
$inival = IniRead("settings.ini", "SETTINGS", "Password", "")

If $iniexists = 0 Then ;This checks if the .ini file exists - i.e. is not open/inaccessible or deleted so script works
	;Displays a message box alerting the user.
	MsgBox(0, "Error", "No settings file or settings file not found.")
	;Exits the script.
	Exit
EndIf

If $inival = "" Then ;This checks if the ini value for Password is blank
	;If it is blank then it runs the Startup() function
	Startup()
EndIf

If $inival <> "" Then ;This checks if there is a password saved in the .ini file
	;If a password is saved then the hotkey is enabled
	$i = 1
EndIf

While $i = 1 ;This means that HotKeySet is only enabled when $i = 1 - i.e. in Startup() and if there is a settings file
	HotKeySet("{INSERT}", "FLRun")
WEnd

Func Startup() ;This is the function run when used for the first time - i.e. there is no settings file
	;User enters password
	$password = InputBox("Enter Password", "Enter password for locker", "", "*", 250, 120)
	;Password is written to .ini file under SETTINGS
	IniWrite("settings.ini", "SETTINGS", "Password", $password)
	;Script alerts the user of the hotkey
	MsgBox(0, "Warning", "INSERT is the hot key.")
	;This enables the hotkey
	$i = 1
EndFunc   ;==>Startup

Func FLRun() ;This is the main function of the script

	;Reads the password from the .ini file
	$passwordini = IniRead("settings.ini", "SETTINGS", "Password", "")

	;Runs Folder Lock - NB. Must be installed in this directory!
	Run("C:/Program Files/Folder Lock 6/Folder Lock 6.exe")

	;Waits until the dialog comes up - NB. relies on window name as "Dialog"
	WinWaitActive("Dialog")
	;Waits 5 seconds whilst the countdown completes
	Sleep(5000)
	;Gets the position of the window
	$posarray1 = WinGetPos("Dialog")
	;Uses the position of the window to click the "Later" button - NB. it is relative
	MouseClick("Left", $posarray1[0] + 298, $posarray1[1] + 267)

	;Waits until Folder Lock is active and in focus
	WinWaitActive("Folder Lock 6.2.4")
	;Gets position of window
	$posarray2 = WinGetPos("Folder Lock 6.2.4")
	;Searches for colour of password input in window boundaries from previous WinGetPos
	$posget1 = PixelSearch($posarray2[0], $posarray2[1], $posarray2[0] + $posarray2[2], $posarray2[1] + $posarray2[3], "0x82D03E")

	;Clicks into the password entry box using PixelSearch result array
	MouseClick("Left", $posget1[0], $posget1[1] + 13)
	;Sends the text read from the settings file
	Send($passwordini, 1)
	;Clicks the OK button, relative to input box position
	MouseClick("Left", $posget1[0] + 182, $posget1[1] + 13)

EndFunc   ;==>FLRun
