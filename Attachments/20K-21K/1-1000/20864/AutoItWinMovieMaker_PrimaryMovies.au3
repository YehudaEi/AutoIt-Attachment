
; AutoIt GLOBAL OPTIONS set for this SCRIPT RUN
AutoItSetOption("CaretCoordMode", 1)        ;1=absolute, 0=relative, 2=client
AutoItSetOption("ColorMode", 0)             ;0=RRGGBB color, 1=BBGGRR color
AutoItSetOption("ExpandEnvStrings", 0)      ;0=don't expand, 1=do expand
AutoItSetOption("ExpandVarStrings", 0)      ;0=don't expand, 1=do expand
AutoItSetOption("FtpBinaryMode", 1)         ;1=binary, 0=ASCII
AutoItSetOption("MouseClickDelay", 10)      ;10 milliseconds
AutoItSetOption("MouseClickDownDelay", 10)  ;10 milliseconds
AutoItSetOption("MouseClickDragDelay", 250) ;250 milliseconds
AutoItSetOption("MouseCoordMode", 1)        ;1=absolute, 0=relative, 2=client
AutoItSetOption("MustDeclareVars", 1)       ;0=no, 1=require pre-declare
AutoItSetOption("PixelCoordMode", 1)        ;1=absolute, 0=relative, 2=client
AutoItSetOption("RunErrorsFatal", 1)        ;1=fatal, 0=silent set @error
AutoItSetOption("SendAttachMode", 0)        ;0=don't attach, 1=do attach
AutoItSetOption("SendCapslockMode", 1)      ;1=store and restore, 0=don't
AutoItSetOption("SendKeyDelay", 5)          ;5 milliseconds
AutoItSetOption("SendKeyDownDelay", 1)      ;1 millisecond
AutoItSetOption("TrayIconDebug", 1)         ;0=no info, 1=debug line info
AutoItSetOption("TrayIconHide", 0)          ;0=show, 1=hide tray icon
AutoItSetOption("WinWaitDelay", 250)        ;250 milliseconds
AutoItSetOption("WinDetectHiddenText", 1)   ;0=don't detect, 1=do detect
AutoItSetOption("WinSearchChildren", 1)     ;0=no, 1=search children also
AutoItSetOption("WinTextMatchMode", 1)      ;1=complete, 2=quick
AutoItSetOption("WinTitleMatchMode", 3)     ;1=start, 2=subStr, 3=exact, 4=advanced
AutoItSetOption("WinWaitDelay", 250)        ;250 milliseconds

Global $FuncRC
Global $MouseButton
Global $SleepTime
Global $WinNameNow

WindowsMovieMakerLoadAndInitialize()

LoadMovieProjectAndMakeMovieFile("01_TheDeathOfDeath", "TheDeathOfDeath")
LoadMovieProjectAndMakeMovieFile("02_MorePreciousThanGold", "MorePreciousThanGold")
LoadMovieProjectAndMakeMovieFile("03_GodsExistence_ScienceProves", "ScienceProves")
LoadMovieProjectAndMakeMovieFile("04_GodsExistence_EvolutionErupts", "EvolutionErupts")
LoadMovieProjectAndMakeMovieFile("05_GodsExistence_TheBigBangBreaks", "TheBigBangBreaks")
LoadMovieProjectAndMakeMovieFile("06_GodsExistence_GodsFingerprintsEverywhere", "GodsFingerprintsEverywhere")
LoadMovieProjectAndMakeMovieFile("07_GodsExistence_AtheistsNoLonger", "AtheistsNoLonger")
LoadMovieProjectAndMakeMovieFile("08_LovingCaringGod", "LovingCaringGod")
LoadMovieProjectAndMakeMovieFile("09_WhatAboutEvilPain", "WhatAboutEvilPain")
LoadMovieProjectAndMakeMovieFile("10_WhatsTheDealAboutSin", "WhatsTheDealAboutSin")
LoadMovieProjectAndMakeMovieFile("11_ICanOffendGod", "ICanOffendGod")
LoadMovieProjectAndMakeMovieFile("12_JesusKingLord", "JesusKingLord")
LoadMovieProjectAndMakeMovieFile("13_IMustStandBeforeGod", "IMustStandBeforeGod")
LoadMovieProjectAndMakeMovieFile("14_WhoCanHelpMe", "WhoCanHelpMe")

WindowsMovieMakerExitQuit()

Exit ; EXIT, quit the script

Func WindowsMovieMakerLoadAndInitialize()

	; INITIALIZE MOUSE BUTTON NAME
	$MouseButton = "left"

	; INITIALIZE the wait time
    $SleepTime = 500 ; 0.5 second

	; INITIAL WINDOWS NAME, but will change as different PROJECTS are LOADED
    $WinNameNow = "Untitled - Windows Movie Maker" ; LoadMovieProjectAndMakeMovieFile has to change it as it moves through the projects

	; LOAD WINDOWS MOVIE MAKER
	Run("C:\Program Files\Movie Maker\moviemk.exe") ; load Windows Movie Maker
	WinWaitActive($WinNameNow) ; wait until it is active and alive

	Return 0 ; SUCCESSFUL

EndFunc

Func LoadMovieProjectAndMakeMovieFile($exProjectName, $exMovieName)

    ; the KEY to all of this is sychronizing all of the AutoIt script commands to the actual Windows Movie Maker window status and situation
    ; which is done by constantly checking what the AutoIt script sees in the Windows Movie Maker windows and status boxes
    ; and when it sees the right thing, it proceeds, otherwise, it has to wait until the required sychronizing data is seen and is available for usage

    ; the synchronizing data is gathered manually by constantly looking at the Windows Movie Maker window and the AutoIt Windows Info program supplied by AutoIt
    ; and that was done with 2 different computers, side by side, one which is for actually writing the AutoIt script, and the other for running Windows Movie Maker with the AutoIt Windows Info program

    ; the AutoIt finished script makes movies for                              , and afterward, manually the movie files are FTP'ed to the web site

	Local $lclCtrlText
	Local $lclCtrlUndrMouse
	Local $lclDOSEraseCommand
	Local $lclFuncRC
	Local $lclMovieFileName
	Local $lclProjectNameFull

    ; ERASE PREVIOUS version of this MOVIE
	$lclMovieFileName = $exMovieName & ".wmv"
	$lclDOSEraseCommand = "del c:\UploadFTP\" & $lclMovieFileName & " /Q"
    RunWait(@ComSpec & " /c " & $lclDOSEraseCommand, "", @SW_HIDE) ; DOS COMMAND, erase previous movies
	
	$lclProjectNameFull = $exProjectName & ".MSWMM{enter}"

	; OPEN A PROJECT
	MouseMove(22, 33) ; MENU, FILE
	$lclFuncRC = 1
	While $lclFuncRC = 1
		$lclFuncRC = ControlFocus($WinNameNow, "", "WTL_CommandBar_WMT1")
		If $lclFuncRC = 1 Then
			$lclCtrlUndrMouse = ControlGetFocus($WinNameNow, "")
			If $lclCtrlUndrMouse <> "WTL_CommandBar_WMT1" Then
				Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
				$lclFuncRC = 0
			Else
				ExitLoop
			EndIf
		Else
			Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
		EndIf
	WEnd
	MouseMove(22, 33) ; MENU, FILE
	MouseClick($MouseButton, 22, 33) ; MENU, FILE
	MouseMove(100, 75) ; OPEN PROJECT
	MouseClick($MouseButton, 100, 75) ; OPEN PROJECT
	Send($lclProjectNameFull)
	MouseMove(22, 33) ; MENU, FILE
	; CHECKING PROJECT FILES
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText("Open Project", "")
		$lclFuncRC = StringInStr($lclCtrlText, "Checking project files", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	; VERIFY THE PROJECT IS LOADED AND READY
	$WinNameNow = $exProjectName & " - Windows Movie Maker"
	MouseMove(22, 33) ; MENU, FILE
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText($WinNameNow, "")
		$lclFuncRC = StringInStr($lclCtrlText, "Ready", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	; VERIFY THE MENU, FILE IS READY AND ACTIVE
	MouseMove(22, 33) ; MENU, FILE
	$lclFuncRC = 1
	While $lclFuncRC = 1
		$lclFuncRC = ControlFocus($WinNameNow, "", "WTL_CommandBar_WMT1")
		If $lclFuncRC = 1 Then
			$lclCtrlUndrMouse = ControlGetFocus($WinNameNow, "")
			If $lclCtrlUndrMouse <> "WTL_CommandBar_WMT1" Then
				Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
				$lclFuncRC = 0
			Else
				ExitLoop
			EndIf
		Else
			Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
		EndIf
	WEnd
	; OPEN THE MENU, FILE MENU
	MouseMove(22, 33) ; MENU, FILE
	MouseClick($MouseButton, 22, 33)
	; ADVANCE TO MAKE A MOVIE OPTION ON THE MENU, FILE MENU
	MouseMove(80, 150) ; MAKE MOVIE
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText($WinNameNow, "")
		$lclFuncRC = StringInStr($lclCtrlText, "Saves the project as a movie for others to watch.", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	MouseMove(80, 150) ; MAKE MOVIE
	MouseClick($MouseButton, 80, 150) ; MAKE MOVIE
	$lclFuncRC = 1
	While $lclFuncRC = 1
		$lclFuncRC = ControlFocus("Save Movie Wizard", "", "SysListView321")
		If $lclFuncRC = 1 Then
			$lclCtrlUndrMouse = ControlGetFocus("Save Movie Wizard", "")
			If $lclCtrlUndrMouse <> "SysListView321" Then
				Sleep($SleepTime) ; WAIT for specified seconds -- MAKE SURE the SAVE MOVIE WIZARD is available and active
				$lclFuncRC = 0
			Else
				ExitLoop
			EndIf
		Else
			Sleep($SleepTime) ; WAIT for specified seconds -- MAKE SURE the SAVE MOVIE WIZARD is available and active
		EndIf
	WEnd
	; SELECT MAKE A MOVIE OPTION ON THE MENU, FILE MENU
	MouseMove(400, 500) ; SAVE MOVIE WIZARD
	MouseClick($MouseButton, 400, 500) ; SAVE MOVIE WIZARD
	MouseMove(80, 140) ; SAVE MOVIE WIZARD
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText("Save Movie Wizard", "")
		$lclFuncRC = StringInStr($lclCtrlText, "Name and Save Page", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	; ADVANCE TO THE NAME OF MOVIE TO MAKE
	MouseMove(80, 140) ; SAVE MOVIE WIZARD
	; ENTER THE NAME OF THE MOVIE TO MAKE
	Send($exMovieName)
	MouseMove(400, 500) ; SAVE MOVIE WIZARD
	MouseClick($MouseButton, 400, 500) ; SAVE MOVIE WIZARD
	MouseMove(400, 500) ; SAVE MOVIE WIZARD
	; VERIFY THE NEXT SAVE MOVIE WIZARD SCREEN PANEL IS NOW SHOWING
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText("Save Movie Wizard", "")
		$lclFuncRC = StringInStr($lclCtrlText, "Best quality for playback on &my computer", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	; SELECT THAT, AND MAKE THE MOVIE
	MouseMove(400, 500) ; SAVE MOVIE WIZARD
	MouseClick($MouseButton, 400, 500) ; SAVE MOVIE WIZARD
	; VERIFY THE FINISH SCREEN PANEL IS NOW SHOWING
	MouseMove(400, 500) ; FINISH SAVE MOVIE WIZARD
	$lclFuncRC = 0
	While $lclFuncRC = 0
		$lclCtrlText = WinGetText("Save Movie Wizard", "")
		$lclFuncRC = StringInStr($lclCtrlText, "To close this wizard, click Finish", 0)
		If $lclFuncRC = 0 Then
			Sleep($SleepTime) ; WAIT for specified seconds -- NOT found
		Else
			ExitLoop
		EndIf
	WEnd
	; FINISH THE SAVE MOVIE WIZARD
	MouseMove(400, 500) ; FINISH SAVE MOVIE WIZARD
	MouseClick($MouseButton, 400, 500) ; FINISH SAVE MOVIE WIZARD

	Return 0 ; SUCCESSFUL

EndFunc

Func WindowsMovieMakerExitQuit()

	Local $lclCtrlText
	Local $lclCtrlUndrMouse
	Local $lclFuncRC
	Local $lclProjectNameFull

	; EXIT, quit
	MouseMove(22, 33) ; MENU, FILE
	$lclFuncRC = 1
	While $lclFuncRC = 1
		$lclFuncRC = ControlFocus($WinNameNow, "", "WTL_CommandBar_WMT1")
		If $lclFuncRC = 1 Then
			$lclCtrlUndrMouse = ControlGetFocus($WinNameNow, "")
			If $lclCtrlUndrMouse <> "WTL_CommandBar_WMT1" Then
				Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
				$lclFuncRC = 0
			Else
				ExitLoop
			EndIf
		Else
			Sleep($SleepTime) ; WAIT for specified seconds -- make sure the MENU, FILE is available and active
		EndIf
	WEnd
	MouseMove(22, 33) ; MENU, FILE
	MouseClick($MouseButton, 22, 33) ; MENU, FILE
	MouseMove(80, 360) ; EXIT, QUIT
	MouseClick($MouseButton, 80, 360) ; EXIT, QUIT

	Return 0 ; SUCCESSFUL

EndFunc
