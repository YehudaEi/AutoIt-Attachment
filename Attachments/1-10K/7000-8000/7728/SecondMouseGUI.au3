#region Directions:
;<--           Adjust size to minimum distance to read instructions           --->;
;;;;  Please, if you find this script useful, I accept L$ donations of any
;;;;    ammount.
;
;;;;     WARNING:  If you received this script from anyone other than
;;;;      me (Heuvadoches Naumova) or my vendors, then it's possible
;;;;      it was tampered without my knowledge or consent.  I am not responsible
;;;;      for any damage to your system, account, or anything else.
;;;;      WINDOWS ONLY!
;;;;<rant>
;;;;  FIRST THINGS FIRST: NOT A KEY LOGGER!!!  HACKING SUXXORZ!!!
;;;;  1.  Key loggers are not generally released as source code.
;;;;  2.  An efficient keylogger in AuotIt is best accomplished by using an
;;;;      explicit DLLCall() function to the Windows Kernel.
;;;;      This code does not have any explicit DLL calls!
;;;;  I RELEASE CODE THAT WORKS ON MY SYSTEM.  If you follow the directions,
;;;;  it should also work correctly on yours.  I test this extensively
;;;;  before releasing it.
;;;;  Heuvadoches Naumova
;;;;</rant>
;;;;
;;;;  NOTES:
;;;;  At this time: Second Life WINDOW MUST BE OPEN FIRST!!!!!
;;;;  Running in a window isn't required, but it helps.
;;;;  You must also log completely into second life before running
;;;;  this.  Not only does this help prevent a keylogger from getting your
;;;;  information, it makes it a hell of a lot easier on me to code.
;;;;
;;;; INSTRUCTIONS:   (Leik, OMFG...RTFM!!1!!1)
;;;; First, download and install AutoIt v3 from
;;;;       http://www.autoitscript.com/autoit3/downloads.php
;
;;;; Second, download SciTE for AutoIt.  Install it as well.
;;;;       http://www.autoitscript.com/autoit3/scite/downloads.php
;;;;(install notes:  Edit script should be selected for default)
;
;;;; Next, Copy and paste this ENTIRE script into Scite.
;;;;;  Ctrl-A (select all) Ctrl-C (copy) Ctrl-V (paste)
;
;;;; Then, SAVE THE FILE as <somename>.au3 (the name isn't important
;;;;             but the extention .AU3 is.)
;;;; Finally, Hit F5 while in SciTE
;;;;  Happy AFK camping!
#endregion
#region TO DO, Version History, Bug list
;;;; TO DO LIST:
;;;; 1.  Activate button to fire up notepad to edit current witty text file.
;;;; 2.  Add a button to add current custom text line to current witty text file.
;;;; 3.  Add Options GUI
;;;; 3a. Add a text entry box for time adjustments on the min/max on Options GUI
;;;; 4.  Create an installation program.
;;;; 5.  Add TCP/IP updating possiblities through my home webserver.
;;;; VERSION HISTORY
;;;; ************************************************************
;;;; ************************************************************
;;;;  0.1.4.1 -  Shut off some of the /1 /0 prompts.  Changed the quit key to the
;;;;                    close bracket.  It is modifiable for those who like escape.
;;;; ************************************************************
;;;; ************************************************************
;;;; 0.1.4    - Worked out the bug in the Options GUI where the min/max would
;;;;            not calculate properly.7
;;;; 0.1.3  - Fixed another sleeper error.  The file handler for the witty text
;;;;              would fail if a non-existant path/file was manually inserted.
;;;;              Now reverts to the default if the user's file is not found.
;;;;            + Added comment ability to the Witty Text files.
;;;;            + Minor cosmetic change on frmEditText.
;;;; 0.1.2     - "Sleeper" error in text parsing fixed.  No longer sends control, alt,
;;;;                shift or windows keystrokes in front of random (or any other) text.
;;;;            + Remembers last position closed at and will attempt to open there.
;;;;            + Work continues on the edit text GUI.  Button placed for a future Options GUI
;;;;            + Not released.  Planning on releasing a beta of this 11/06
;;;; 0.1.1     + Minor tweaking, some comsmetic changes, small idiotic bug fixed.
;;;;           + Added an escapable sleep timer. - Released to AutoIt forums.
;;;; 0.1.0     + began building the GUI interface, converted main program to a function. - NOT RELEASED
;;;; 0.0.3     + added text to random channels - Released
;;;; 0.0.2     + added random movements and start/stop notifications - Released
;;;; 0.0.1     + initial development, not much more than a mouse mover/clicker - Released
;;;; KNOWN BUGS
;;;;     + all (GUI ONLY) versions prior to 0.1.3 will contain a file handling error where it is
;;;;        possible to manually input a non-existant folder/file.  Added code to force
;;;;        the file handler to fall back to the default.txt in this situation only.
;;;;
;;;;     + all (GUI & NON-GUI) versions prior to 0.1.2 will contain a text parsing error where it's possible
;;;;         for the script to randomly (probably 1 : 1,000,000,000 odds) quit the user from
;;;;         the viewer due to the way AutoIt handles the sending of text strings.  Special
;;;;         characters simulate the use of the "CTRL", "ALT", "SHIFT", or "WINDOWS" keys.
;;;;         (the carat (^), exclaimation point (!), plus (+), and hash (#) respectively).
;;;;         If the ^ and the Q or q is sent then the viewer will quit back to the desktop.
;;;;         Random, but extremely rare.  More common was the appearance of the chat window, the build menu,
;;;;         and other menus within the Second Life viewer.  The workarounds are: Disable the
;;;;         sending of text by commenting out the appropriate lines, restrict the random
;;;;         number generation from CHR(65) to CHR(90), or modify the statement to send only the
;;;;         text string as raw characters (implemented as of 0.1.2).
#endregion
#region Header
#include <GUIConstants.au3>
#include <date.au3>
#include <file.au3>
opt("MustDeclareVars", 1)
opt("MouseCoordMode", 0)
opt("WinTitleMatchMode", 4)
opt("SendKeyDelay", 2)
opt("SendKeyDownDelay", 7)
HotKeySet("]", "MyExit") ; ] will stop this program
HotKeySet("^{pause}", "_Pause") ; ctrl + pause will halt the program momentarialy.
#endregion
#region Build GUI
#region Global Variable and GUI Variable Declaration
; Main GUI variables
Global $script = "Second Mouse v0.1.4"
Global $frmMainGUI, $txtMinWait, $txtMaxWait, $mnuFile, $mFileSave, $mFileEdit, $mFileExit, $mnuOpts, _
		$mHelpDevMode, $mnuHelp, $mHelpAbout, $btnEditText, $btnEditOpts, $primary, $secondary
Global $rbtnSideTop, $rbtnSideLeft, $rbtnSideRight, $rbtnSideBottom, $lstStatusMsg, _
		$btnStart, $btnExit, $btnTemp, $rbtnGroup01, $rbtnGroup02, $rbtnGroup03, $funcEReturn, $funcOReturn
Global $guiMSG, $Exit = 0, $guiWidth = 300, $guiHeight = 350, $guiTemp, $imgFiles = 0, $running = 0, _
		$paused, $iniFile = @ScriptDir & "\SMOptions.ini", $yes = 6, $no = 7, $frmPositionX, $frmPositionY
Global $txtDefault = @ScriptDir & "\default.txt", $imgLocation = @ScriptDir & "\images\"
Global $rbtnZoneOn[3]
Global $rbtnClickZone[5]
Global $imgClickZone[5]
Global $lblClickZone[5]
Global $rbtnSendText[4]
Global $lblSendText[4]
#endregion
; opening functions
MouseButtons()
ScriptVer($script)
; Configuration Options:  Check for INI.  If not, create it.
If Not FileExists($iniFile) Then CreateFile("ini")
; Configuration Options:  Check for default.txt  If not, create it.
If Not FileExists($txtDefault) Then CreateFile("txt")
; Build Main GUI
$frmPositionX = IniRead($iniFile, "MAIN", "PositionX", @DesktopWidth - $guiWidth - 10)
$frmPositionY = IniRead($iniFile, "MAIN", "PositionY", 0)
$frmMainGUI = GUICreate($script, $guiWidth, $guiHeight, $frmPositionX, $frmPositionY)
$mnuFile = GUICtrlCreateMenu("&File")
$mnuHelp = GUICtrlCreateMenu("&Help")
$mFileEdit = GUICtrlCreateMenuItem("&Edit Options", $mnuFile)
$mFileExit = GUICtrlCreateMenuItem("E&xit", $mnuFile)
$mHelpAbout = GUICtrlCreateMenuItem("&About", $mnuHelp)
; developer mode menu item.  Comment the SetState for production release
$mHelpDevMode = GUICtrlCreateMenuItem("&Developer Mode", $mnuHelp, 1, 1)
;;;; GUICtrlSetState($mHelpDevMode, $GUI_CHECKED)
; Text Control Group
$rbtnGroup01 = GUICtrlCreateGroup("Send Text", $guiWidth - $guiWidth + 10, $guiHeight - $guiHeight + 10, 136, 90, $BS_CENTER)
$guiTemp = ControlGetPos($frmMainGUI, "", $rbtnGroup01)
$rbtnSendText[1] = GUICtrlCreateRadio("Text Off", $guiTemp[0] + 10, $guiTemp[1] + 20, 80, -1)
$rbtnSendText[2] = GUICtrlCreateRadio("Text On:Public", $guiTemp[0] + 10, $guiTemp[1] + 40, 100, -1)
$rbtnSendText[3] = GUICtrlCreateRadio("Text On:Private", $guiTemp[0] + 10, $guiTemp[1] + 60, 100, -1)
GUICtrlSetState($rbtnSendText[IniRead($iniFile, "MAIN", "TextControl", 1) ], $GUI_CHECKED)
$lblSendText[1] = GUICtrlCreateLabel("Text Off:  The program will not send text to the Second Life client", _
		$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 52)
$lblSendText[2] = GUICtrlCreateLabel("Text On:  The program will send text to the Second Life client on the public channel.", _
		$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 52)
$lblSendText[3] = GUICtrlCreateLabel("Text Private:  The program will send text to the Second Life client to random private channels", _
		$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 52)
For $x = 1 To 3
	GUICtrlSetState($lblSendText[$x], $GUI_HIDE)
	If GUICtrlRead($rbtnSendText[$x]) = $GUI_CHECKED Then GUICtrlSetState($lblSendText[$x], $GUI_SHOW)
Next
; On/Off control Group
$guiTemp = ControlGetPos($frmMainGUI, "", $rbtnGroup01)
$rbtnGroup03 = GUICtrlCreateGroup("Click Control", $guiTemp[0], $guiTemp[1] + $guiTemp[3] + 10, 136, 48, $BS_CENTER)
$rbtnZoneOn[1] = GUICtrlCreateRadio("On", $guiTemp[0] + 20, $guiTemp[1] + $guiTemp[3] + 30, 40, 20)
$rbtnZoneOn[2] = GUICtrlCreateRadio("Off", $guiTemp[0] + 65, $guiTemp[1] + $guiTemp[3] + 30, 40, 20)
GUICtrlSetState($rbtnZoneOn[IniRead($iniFile, "MAIN", "ClickControl", 1) ], $GUI_CHECKED)
; Click Zone control Group
$rbtnGroup02 = GUICtrlCreateGroup("Monitor Click Zone", $guiTemp[0], $guiTemp[1] + $guiTemp[3] + 50, 136, 110, $BS_CENTER)
$guiTemp = ControlGetPos($frmMainGUI, "", $rbtnGroup02)
$rbtnClickZone[4] = GUICtrlCreateRadio("Left Side", $guiTemp[0] + 10, $guiTemp[1] + 20, 80, -1)
$rbtnClickZone[1] = GUICtrlCreateRadio("Top Side", $guiTemp[0] + 10, $guiTemp[1] + 40, 80, -1)
$rbtnClickZone[2] = GUICtrlCreateRadio("Right Side", $guiTemp[0] + 10, $guiTemp[1] + 60, 80, -1)
$rbtnClickZone[3] = GUICtrlCreateRadio("Bottom Side", $guiTemp[0] + 10, $guiTemp[1] + 80, 80, -1)
GUICtrlSetState($rbtnClickZone[IniRead($iniFile, "MAIN", "ClickSide", 4) ], $GUI_CHECKED)
; buttons
$guiTemp = ControlGetPos($frmMainGUI, "", $lblSendText[1])
$btnEditText = GUICtrlCreateButton("E&dit Text", $guiTemp[0], $guiTemp[1] + $guiTemp[3] + 10, 50, 20)
$btnEditOpts = GUICtrlCreateButton("&Options", $guiTemp[0], $guiTemp[1] + $guiTemp[3] + 35, 50, 20)
$btnTemp = GUICtrlCreateButton("KEYSTONE", 10, $guiHeight - 60, 80, 30)
$guiTemp = ControlGetPos($frmMainGUI, "", $btnTemp)
GUICtrlSetState($btnTemp, BitOR($GUI_HIDE, $GUI_DISABLE))
$btnStart = GUICtrlCreateButton("Start &Camp", ($guiWidth / 2) - ($guiTemp[2]), $guiTemp[1], $guiTemp[2], $guiTemp[3], BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
$guiTemp = ControlGetPos($frmMainGUI, "", $btnStart)
$btnExit = GUICtrlCreateButton("E&xit", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1], $guiTemp[2], $guiTemp[3])
; image/label creation
If FileExists($imgLocation & "clicktop.gif") And FileExists($imgLocation & "clickright.gif") _
		And FileExists($imgLocation & "clickbottom.gif") And FileExists($imgLocation & "clickleft.gif") Then
	; if the images are found, use them.
	$imgFiles = 1
	$guiTemp = ControlGetPos($frmMainGUI, "", $rbtnGroup02)
	$imgClickZone[1] = GUICtrlCreatePic($imgLocation & "clicktop.gif", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$imgClickZone[2] = GUICtrlCreatePic($imgLocation & "clickright.gif", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$imgClickZone[3] = GUICtrlCreatePic($imgLocation & "clickbottom.gif", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$imgClickZone[4] = GUICtrlCreatePic($imgLocation & "clickleft.gif", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	For $x = 1 To 4
		GUICtrlSetState($imgClickZone[$x], $GUI_HIDE)
		If GUICtrlRead($rbtnClickZone[$x]) = $GUI_CHECKED Then GUICtrlSetState($imgClickZone[$x], $GUI_SHOW)
	Next
Else
	; otherwise, use text labels
	$guiTemp = ControlGetPos($frmMainGUI, "", $rbtnGroup02)
	$lblClickZone[1] = GUICtrlCreateLabel("The script will send a single left click in the top area of the monitor, 30 pixels from the edge, avoiding a 30x30 pixel square at the corners.", _
			$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$lblClickZone[2] = GUICtrlCreateLabel("The script will send a single left click in the right area of the monitor, 30 pixels from the edge, avoiding a 30x30 pixel square at the corners.", _
			$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$lblClickZone[3] = GUICtrlCreateLabel("The script will send a single left click in the bottom area of the monitor, 30 pixels from the edge, avoiding a 30x30 pixel square at the corners." & @LF & "NOT RECOMMENDED", _
			$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	$lblClickZone[4] = GUICtrlCreateLabel("The script will send a single left click in the left area of the monitor, 30 pixels from the edge, avoiding a 30x30 pixel square at the corners.", _
			$guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1] + 12, 136, 96)
	For $x = 1 To 4
		GUICtrlSetState($lblClickZone[$x], $GUI_HIDE)
		If GUICtrlRead($rbtnClickZone[$x]) = $GUI_CHECKED Then GUICtrlSetState($lblClickZone[$x], $GUI_SHOW)
	Next
EndIf
; miscelleny.  Check for some states before enabling/disabling buttons or fields.
If BitAND(GUICtrlRead($rbtnSendText[1]), $GUI_CHECKED) = $GUI_CHECKED Then GUICtrlSetState($btnEditText, $GUI_DISABLE)
If BitAND(GUICtrlRead($rbtnZoneOn[2]), $GUI_CHECKED) = $GUI_CHECKED Then
	GUICtrlSetState($rbtnGroup02, $GUI_DISABLE)
	For $loop = 1 To 4
		GUICtrlSetState($rbtnClickZone[$loop], $GUI_DISABLE)
		GUICtrlSetState($lblClickZone[$loop], $GUI_DISABLE)
		GUICtrlSetState($imgClickZone[$loop], $GUI_HIDE)
	Next
EndIf
; Garbage cleanup, release memory used by temporary variables.
$guiTemp = ""
; Finally: show the GUI
GUISetState(@SW_SHOW, $frmMainGUI)
#endregion
#region Primary GUI Data Loop
While $Exit = 0
	Sleep(10)
	$guiMSG = GUIGetMsg()
	Select
		; on/off button clicked
		Case $guiMSG = $rbtnZoneOn[1] Or $guiMSG = $rbtnZoneOn[2]
			If GUICtrlRead($rbtnZoneOn[2]) = $GUI_CHECKED Then
				IniWrite($iniFile, "MAIN", "ClickControl", 2) ; on(1)/off(2)
				GUICtrlSetState($rbtnGroup02, $GUI_DISABLE)
				For $loop = 1 To 4
					GUICtrlSetState($rbtnClickZone[$loop], $GUI_DISABLE)
					GUICtrlSetState($lblClickZone[$loop], $GUI_DISABLE)
					GUICtrlSetState($imgClickZone[$loop], $GUI_HIDE)
				Next
			Else
				GUICtrlSetState($rbtnGroup02, $GUI_ENABLE)
				IniWrite($iniFile, "MAIN", "ClickControl", 1) ; on(1)/off(2)
				For $loop = 1 To 4
					GUICtrlSetState($rbtnClickZone[$loop], $GUI_ENABLE)
					GUICtrlSetState($lblClickZone[$loop], $GUI_ENABLE)
					If GUICtrlRead($rbtnClickZone[$loop]) = $GUI_CHECKED Then GUICtrlSetState($imgClickZone[$loop], $GUI_SHOW)
				Next
			EndIf
			; text control button clicked
		Case $guiMSG = $rbtnSendText[1] Or $guiMSG = $rbtnSendText[2] Or $guiMSG = $rbtnSendText[3]
			For $zloop = 1 To 3
				If GUICtrlRead($rbtnSendText[$zloop]) = $GUI_CHECKED Then
					ClickZone(1, $zloop, $imgFiles)
					IniWrite($iniFile, "MAIN", "TextControl", $zloop) ; off(1)/public(2)/private(3)
				EndIf
				If $zloop = 1 And GUICtrlRead($rbtnSendText[$zloop]) = $GUI_CHECKED Then GUICtrlSetState($btnEditText, $GUI_DISABLE)
				If $zloop > 1 And GUICtrlRead($rbtnSendText[$zloop]) = $GUI_CHECKED Then GUICtrlSetState($btnEditText, $GUI_ENABLE)
			Next
			; clickside button clicked
		Case $guiMSG = $rbtnClickZone[1] Or $guiMSG = $rbtnClickZone[2] Or $guiMSG = $rbtnClickZone[3] Or $guiMSG = $rbtnClickZone[4]
			For $zloop = 1 To 4
				If GUICtrlRead($rbtnClickZone[$zloop]) = $GUI_CHECKED Then
					ClickZone(2, $zloop, $imgFiles)
					IniWrite($iniFile, "MAIN", "ClickSide", $zloop) ; top(1)/right(2)/bottom(3)/left(4)
				EndIf
			Next
		Case $guiMSG = $btnEditText
			$funcEReturn = 0
			$funcOReturn = 0
			$funcEReturn = GUIEditText()
			$Exit = $Exit - 1
		Case $guiMSG = $btnEditOpts Or $guiMSG = $mFileEdit
			$funcEReturn = 0
			$funcOReturn = 0
			$funcOReturn = GUIEditOpts()
			$Exit = $Exit - 1
		Case $guiMSG = $btnStart
			SecondMouse()
			$Exit = $Exit - 1
		Case $guiMSG = $mHelpDevMode
			If BitAND(GUICtrlRead($mHelpDevMode), $GUI_CHECKED) = $GUI_CHECKED Then
				GUICtrlSetState($mHelpDevMode, $GUI_UNCHECKED)
				MsgBox(0, "", "Developer Mode disengaged.")
			Else
				$guiTemp = MsgBox(0x24, "Developer Mode", "Configuration and default.txt will be deleted upon exit" & _
						@LF & @LF & "Are you sure you want to do this?")
				If $guiTemp = $yes Then
					GUICtrlSetState($mHelpDevMode, $GUI_CHECKED)
				EndIf
			EndIf
		Case $guiMSG = $mHelpAbout
			MsgBox(0, "About " & $script, $script & " design and code by Heuvadoches Naumova." & @LF & @LF & _
					"Beta tested by: Underflow Quasimodo" & @LF & @LF & "Special Thanks to: Underflow Quasimodo for valuable suggestions.")
		Case $guiMSG = $GUI_EVENT_CLOSE Or $guiMSG = $mFileExit Or $guiMSG = $btnExit
			MyExit()
	EndSelect
	If $funcEReturn = 1 Then ControlClick($frmMainGUI, "", $btnEditOpts, $primary, 1)
	If $funcOReturn = 1 Then ControlClick($frmMainGUI, "", $btnEditText, $primary, 1)
WEnd
#endregion
$guiTemp = WinGetPos($frmMainGUI)
IniWrite($iniFile, "MAIN", "PositionX", $guiTemp[0])
IniWrite($iniFile, "MAIN", "PositionY", $guiTemp[1])
If BitAND(GUICtrlRead($mHelpDevMode), $GUI_CHECKED) = $GUI_CHECKED Then
	If FileExists($iniFile) Then
		FileDelete($iniFile)
		ConsoleWrite("INI Deleted.          ")
		If FileExists($txtDefault) Then
			FileDelete($txtDefault)
			ConsoleWrite("TXT Deleted.")
		EndIf
		ConsoleWrite(@LF)
	EndIf
EndIf
GUIDelete($frmMainGUI)
Exit
#region Function List
Func GUIEditOpts()
	; option buttons: Radio for window/fullscreen, text for min/max times ( min >= 5.000 <= max <= 25.000 )
	; button for manual checking for new versions.
	Local $frmEditOpts, $guiOptsMsg, $btnOptsUpdate, $btnOptsOK, $btnOptsCancel, $btnOptsTemp, $txtOptsMin, $txtOptsMax, _
			$rbtnOptsGroup, $iUpdate, $iUpdateErr, $iResponse, $fileUpdateEXE = @TempDir & "\SMUpdate.EXE", $lblOptsUpdate, _
			$lblOptsUpdateText, $lblLastUpdate = IniRead($iniFile, "OPTIONS", "LastUpdate", "2001/01/01"), $position
	Local $lblOptsMin = IniRead($iniFile, "OPTIONS", "MinTime", "10.00"), $lblOptsMax = IniRead($iniFile, "OPTIONS", "MaxTime", "25.00"), $lblTime
	Local $rbtnOptsWindow[2]
	Local $lblOptsWindow[2]
	$position = WinGetPos($frmMainGUI)
	$frmEditOpts = GUICreate("Options", $position[2], $position[3], $position[0], $position[1], -1, -1, $frmMainGUI)
	$rbtnOptsGroup = GUICtrlCreateGroup("", 10, 10, $position[2] - 20, $position[3] - 125)
	$guiTemp = ControlGetPos($frmEditOpts, "", $rbtnOptsGroup)
	$rbtnOptsWindow[0] = GUICtrlCreateRadio("SecondLife is FULLSCREEN", $guiTemp[0] + 10, $guiTemp[1] + 20, 160, 20)
	$rbtnOptsWindow[1] = GUICtrlCreateRadio("SecondLife is WINDOWED", $guiTemp[0] + 10, $guiTemp[1] + 40, 160, 20)
	GUICtrlSetState($rbtnOptsWindow[IniRead($iniFile, "OPTIONS", "Windowed", 0) ], $GUI_CHECKED)
	$txtOptsMin = GUICtrlCreateInput(IniRead($iniFile, "OPTIONS", "MinTime", 10.00), $guiTemp[0] + 10, $guiTemp[1] + 120, 48, 20)
	$lblOptsMin = GUICtrlCreateLabel("Minimum time", $guiTemp[0] + 63, $guiTemp[1] + 120, 80, 20)
	$txtOptsMax = GUICtrlCreateInput(IniRead($iniFile, "OPTIONS", "MaxTime", 25.00), $guiTemp[0] + 10, $guiTemp[1] + 145, 48, 20)
	$lblOptsMax = GUICtrlCreateLabel("Maximum time", $guiTemp[0] + 63, $guiTemp[1] + 145, 80, 20)
	$guiTemp = ControlGetPos($frmEditOpts, "", $lblOptsMin)
	$lblTime = GUICtrlCreateLabel("The values to the left represent the min and max time in minutes between iterations of moving the mouse and/or sending text.", _
			$guiTemp[0] + $guiTemp[2] + 5, $guiTemp[1] - 15, $position[2] - ($guiTemp[0] + $guiTemp[2] + 5) - 20, 80)
	$guiTemp = ControlGetPos($frmEditOpts, "", $rbtnOptsGroup)
	$btnOptsUpdate = GUICtrlCreateButton("Update", $guiTemp[0] + 10, $guiTemp[3] - 20, 48, 20)
	$guiTemp = ControlGetPos($frmEditOpts, "", $btnOptsUpdate)
	$lblOptsUpdate = GUICtrlCreateLabel("Update has not yet succeeded", $guiTemp[0] + $guiTemp[2] + 5, _
			$guiTemp[1], $position[2] - ($guiTemp[0] + $guiTemp[2] + 5) - 20, 20)
	If Not $lblLastUpdate = "2001/01/01" Then
		$lblOptsUpdateText = _DateDiff("D", $lblLastUpdate, _NowCalcDate())
		GUICtrlSetData($lblOptsUpdate, "Last update: " & $lblOptsUpdateText & " days ago.")
	EndIf
	; main buttons
	$btnOptsTemp = GUICtrlCreateButton("KEYSTONE", 10, $guiHeight - 60, 80, 30)
	GUICtrlSetState($btnOptsTemp, BitOR($GUI_HIDE, $GUI_DISABLE))
	$guiTemp = ControlGetPos($frmEditOpts, "", $btnOptsTemp)
	$btnOptsOK = GUICtrlCreateButton("&OK", ($guiWidth / 2) - $guiTemp[2], $guiTemp[1], $guiTemp[2], $guiTemp[3], BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
	GUICtrlSetTip($btnOptsOK, "Save options and return to main menu")
	$guiTemp = ControlGetPos($frmEditOpts, "", $btnOptsOK)
	$btnOptsCancel = GUICtrlCreateButton("&Cancel", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1], $guiTemp[2], $guiTemp[3])
	GUISetState(@SW_SHOW, $frmEditOpts)
	If BitAND(WinGetState($frmMainGUI), 2) Then GUISetState(@SW_HIDE, $frmMainGUI)
	#region Primary Options Data Loop
	While $Exit = 0
		Sleep(10)
		$guiOptsMsg = GUIGetMsg()
		Select
			Case $guiOptsMsg = $btnOptsUpdate ; user clicked the update button
				; update is currently causing problems.
				$iUpdate = GetUpdate()
				$iUpdateErr = @error
				Select
					Case $iUpdate = 0 And $iUpdateErr = 0 ; no update
						MsgBox(0, $script, "Second Mouse is current")
					Case $iUpdate = 0 and ($iUpdateErr = 1 Or $iUpdateErr = 2 Or $iUpdateErr = 3) ; unable to get file, unable open file, unable to get update
						MsgBox(0x30, $script, "Update Error Code: UEC-" & $iUpdateErr & @LF & "Unable to update at this time.")
					Case $iUpdate = 1 And $iUpdateErr = 0 ; update successful
						IniWrite($iniFile, "OPTIONS", "LastUpdate", _NowCalcDate())
						$iResponse = MsgBox(0x24, "Ready!", "Run update now?")
						If $iResponse = $yes Then ; run update and quit main program
							Run($fileUpdateEXE)
							WinWait("SecondMouse Updater")
							Exit
						EndIf
					Case Else
						MsgBox(0, "Major Error", "Someone threw a spanner in the gearbox." & @LF _
								 & "The update didn't fail, but it didn't succeed either.")
				EndSelect
			Case $guiOptsMsg = $btnOptsOK
				Local $min = StringFormat("%.2f", GUICtrlRead($txtOptsMin))
				Local $max = StringFormat("%.2f", GUICtrlRead($txtOptsMax))
				Select
					Case $min < 5 or (100 * $max) < (100 * $min) ; goofy kludge to get it to work.
						; do error trap for bad min/max values.
						MsgBox(0, "Error", "Invalid value(s) for Minimum." & @LF & "Please set values between 5.00 and 25.00 and less than the Maximum." & @LF & "Thank you")
					Case $max > 25
						; do error trap for bad min/max values.
						MsgBox(0, "Error", "Invalid value(s) for Maximum." & @LF & "Please set values between 5.00 and 25.00 and greater than or equal to the Minimum." & @LF & "Thank you")
					Case Else
						If BitAND(GUICtrlRead($rbtnOptsWindow[0]), $GUI_CHECKED) = $GUI_CHECKED Then
							IniWrite($iniFile, "OPTIONS", "Windowed", "0")
						Else
							IniWrite($iniFile, "OPTIONS", "Windowed", "1")
						EndIf
						$guiTemp = StringFormat("%.2f", GUICtrlRead($txtOptsMin))
						IniWrite($iniFile, "OPTIONS", "MinTime", $guiTemp)
						$guiTemp = StringFormat("%.2f", GUICtrlRead($txtOptsMax))
						IniWrite($iniFile, "OPTIONS", "MaxTime", $guiTemp)
						MyExit()
				EndSelect
			Case $guiOptsMsg = $btnOptsCancel Or $guiOptsMsg = $GUI_EVENT_CLOSE
				MyExit()
		EndSelect
	WEnd
	#endregion
	#region Edit Options Garbage Cleanup
	$position = WinGetPos($frmEditOpts)
	GUISetState(@SW_SHOW, $frmMainGUI)
	GUIDelete($frmEditOpts)
	WinMove($frmMainGUI, "", $position[0], $position[1])
	#endregion
EndFunc   ;==>GUIEditOpts


Func GUIEditText()
	#region Build Edit Text GUI
	; Edit Text GUI Variables
	Local $frmEditText, $txtInputString, $btnEditOK, $btnEditCancel, $temp, $file, $btnEditTemp, $guiEditMsg, $position, _
			$rbtnEditGroup, $txtWittyLocation, $btnWittyBrowse, $txtCustomText, $value, $text, $min = 10, $max = 15, $btnWittyEdit
	Local $rbtnEditText[4]
	$position = WinGetPos($frmMainGUI)
	$frmEditText = GUICreate("Edit Text", $position[2], $position[3], $position[0], $position[1], -1, -1, $frmMainGUI)
	; Text Option Group
	$rbtnEditGroup = GUICtrlCreateGroup("Text Control", 10, 10, $position[2] - 20, $position[3] - 125)
	$guiTemp = ControlGetPos($frmEditText, "", $rbtnEditGroup)
	$rbtnEditText[1] = GUICtrlCreateRadio("Random Text", $guiTemp[0] + 10, $guiTemp[1] + 20, 96, 20)
	$rbtnEditText[2] = GUICtrlCreateRadio("Witty Text", $guiTemp[0] + 10, $guiTemp[1] + 40, 96, 20)
	$txtWittyLocation = GUICtrlCreateInput(IniRead($iniFile, "TEXTOPTIONS", "File", $txtDefault), $guiTemp[0] + 10, $guiTemp[1] + 60, $guiTemp[2] - 20, 20)
	$btnWittyBrowse = GUICtrlCreateButton("Browse", $guiTemp[2] - 101, $guiTemp[1] + 35, 48, 20)
	$btnWittyEdit = GUICtrlCreateButton("Edit File", $guiTemp[2] - 48, $guiTemp[1] + 35, 48, 20)
	$rbtnEditText[3] = GUICtrlCreateRadio("Custom Text", $guiTemp[0] + 10, $guiTemp[1] + 80, 96, 20)
	$txtCustomText = GUICtrlCreateInput(IniRead($iniFile, "TEXTOPTIONS", "Text", "AFK!"), $guiTemp[0] + 10, $guiTemp[1] + 100, 180, 20)
	GUICtrlSetState($txtWittyLocation, $GUI_DISABLE)
	GUICtrlSetState($txtCustomText, $GUI_DISABLE)
	GUICtrlSetState($btnWittyBrowse, $GUI_DISABLE)
	GUICtrlSetState($rbtnEditText[IniRead($iniFile, "TEXTOPTIONS", "Option", 1) ], $GUI_CHECKED)
	; main buttons
	$btnEditTemp = GUICtrlCreateButton("KEYSTONE", 10, $guiHeight - 60, 80, 30)
	GUICtrlSetState($btnEditTemp, BitOR($GUI_HIDE, $GUI_DISABLE))
	$guiTemp = ControlGetPos($frmEditText, "", $btnEditTemp)
	$btnEditOK = GUICtrlCreateButton("&OK", ($guiWidth / 2) - $guiTemp[2], $guiTemp[1], $guiTemp[2], $guiTemp[3])
	GUICtrlSetTip($btnEditOK, "Save options and return to main menu")
	$guiTemp = ControlGetPos($frmEditText, "", $btnEditOK)
	$btnEditCancel = GUICtrlCreateButton("&Cancel", $guiTemp[0] + $guiTemp[2] + 10, $guiTemp[1], $guiTemp[2], $guiTemp[3], BitOR($GUI_SS_DEFAULT_BUTTON, $BS_DEFPUSHBUTTON))
	For $loop = 1 To 3
		$guiTemp = BitAND(GUICtrlRead($rbtnEditText[$loop]), $GUI_CHECKED)
		Select
			Case $guiTemp = $GUI_CHECKED And $loop = 1 ; random
				GUICtrlSetState($txtWittyLocation, $GUI_DISABLE)
				GUICtrlSetState($btnWittyBrowse, $GUI_DISABLE)
				GUICtrlSetState($btnWittyEdit, $GUI_DISABLE)
				GUICtrlSetState($txtCustomText, $GUI_DISABLE)
			Case $guiTemp = $GUI_CHECKED And $loop = 2 ; witty
				GUICtrlSetState($txtWittyLocation, $GUI_ENABLE)
				GUICtrlSetState($btnWittyBrowse, $GUI_ENABLE)
				GUICtrlSetState($btnWittyEdit, $GUI_ENABLE)
				GUICtrlSetState($txtCustomText, $GUI_DISABLE)
			Case $guiTemp = $GUI_CHECKED And $loop = 3 ; custom
				GUICtrlSetState($txtWittyLocation, $GUI_DISABLE)
				GUICtrlSetState($btnWittyBrowse, $GUI_DISABLE)
				GUICtrlSetState($btnWittyEdit, $GUI_DISABLE)
				GUICtrlSetState($txtCustomText, $GUI_ENABLE)
		EndSelect
	Next
	
	GUISetState(@SW_SHOW, $frmEditText)
	If BitAND(WinGetState($frmMainGUI), 2) Then GUISetState(@SW_HIDE, $frmMainGUI)
	#endregion
	#region Edit Text Primary Data Loop
	While $Exit = 0
		Sleep(10)
		$guiEditMsg = GUIGetMsg()
		Select
			Case $guiEditMsg = $rbtnEditText[1] Or $guiEditMsg = $rbtnEditText[2] Or $guiEditMsg = $rbtnEditText[3]
				For $loop = 1 To 3
					$guiTemp = BitAND(GUICtrlRead($rbtnEditText[$loop]), $GUI_CHECKED)
					Select
						Case $guiTemp = $GUI_CHECKED And $loop = 1 ; random
							GUICtrlSetState($txtWittyLocation, $GUI_DISABLE)
							GUICtrlSetState($btnWittyBrowse, $GUI_DISABLE)
							GUICtrlSetState($btnWittyEdit, $GUI_DISABLE)
							GUICtrlSetState($txtCustomText, $GUI_DISABLE)
						Case $guiTemp = $GUI_CHECKED And $loop = 2 ; witty
							GUICtrlSetState($txtWittyLocation, $GUI_ENABLE)
							GUICtrlSetState($btnWittyBrowse, $GUI_ENABLE)
							GUICtrlSetState($btnWittyEdit, $GUI_ENABLE)
							GUICtrlSetState($txtCustomText, $GUI_DISABLE)
						Case $guiTemp = $GUI_CHECKED And $loop = 3 ; custom
							GUICtrlSetState($txtWittyLocation, $GUI_DISABLE)
							GUICtrlSetState($btnWittyBrowse, $GUI_DISABLE)
							GUICtrlSetState($btnWittyEdit, $GUI_DISABLE)
							GUICtrlSetState($txtCustomText, $GUI_ENABLE)
					EndSelect
				Next
			Case $guiEditMsg = $btnWittyBrowse
				$file = FileOpenDialog("Load Text File", @ScriptDir & "\", "Text files (*.txt)", 8, "default.txt")
				GUICtrlSetData($txtWittyLocation, $file, "")
			Case $guiEditMsg = $btnWittyEdit
				Run('notepad.exe "' & GUICtrlRead($txtWittyLocation) & '"')
			Case $guiEditMsg = $btnEditOK
				For $count = 1 To 3
					If GUICtrlRead($rbtnEditText[$count]) = $GUI_CHECKED Then
						$value = $count
						$file = GUICtrlRead($txtWittyLocation)
						$text = GUICtrlRead($txtCustomText)
					EndIf
				Next
				IniWrite($iniFile, "TEXTOPTIONS", "Option", $value)
				IniWrite($iniFile, "TEXTOPTIONS", "File", $file)
				IniWrite($iniFile, "TEXTOPTIONS", "Text", $text)
				MyExit()
			Case $guiEditMsg = $btnEditCancel Or $guiEditMsg = $GUI_EVENT_CLOSE
				MyExit()
		EndSelect
	WEnd
	#endregion
	#region Edit Text Garbage Cleanup
	$position = WinGetPos($frmEditText)
	GUISetState(@SW_SHOW, $frmMainGUI)
	GUIDelete($frmEditText)
	WinMove($frmMainGUI, "", $position[0], $position[1])
	#endregion
EndFunc   ;==>GUIEditText


Func SecondMouse()
	#region Default functions, hot keys and variables.
	GUISetState(@SW_HIDE, $frmMainGUI)
	; regular variables
	Local $window = "classname=Second Life", $x, $y, $z, $loop, $primary, $paused, _
			$timecounter = 0, $min = 10, $max = 15, $channel = -1, $text = " AFK!", _
			$TextOpts = 0, $txtDirWitty, $txtCustom = IniRead($iniFile, "TEXTOPTIONS", "Text", "AFK!"), $eof, $fileHandle
	Local $textType = IniRead($iniFile, "TEXTOPTIONS", "Option", -1)
	Select
		Case GUICtrlRead($rbtnSendText[1]) = $GUI_CHECKED ; off
			$TextOpts = 1
			$channel = -1
		Case GUICtrlRead($rbtnSendText[2]) = $GUI_CHECKED ; public
			$TextOpts = 2
			$channel = 0
		Case GUICtrlRead($rbtnSendText[3]) = $GUI_CHECKED ; private
			$TextOpts = 3
			$channel = Random(10000, 90000000, 1)
	EndSelect
	Select
		Case $textType = 1 Or $textType = -1 ; random
		Case $textType = 2 ; witty
			$txtDirWitty = IniRead($iniFile, "TEXTOPTIONS", "File", $txtDefault)
		Case $textType = 3 ; custom
			$txtCustom = IniRead($iniFile, "TEXTOPTIONS", "Text", "AFK!")
	EndSelect
	#endregion
	#region SecondMouse Primary Data Loop
	; user clicked "Start Camp"
	If WinExists($window) Then
		WinActivate($window)
		WinWaitActive($window)
		Sleep(5000)
;~         Send("/0 " & $script & " Activated.{enter}")
		$running = 1
		While $Exit = 0
			WinActivate($window)
			WinWaitActive($window)
			Sleep(250)
			For $loop = 1 To Random(7, 18, 1)
				If Not $Exit = 0 Then
					$running = 0
					ExitLoop
				EndIf
				$x = Random(30, @DesktopWidth - 30, 1)
				$y = Random(30, @DesktopHeight - 30, 1)
				$z = Random(1, 15, 1)
				MouseMove($x, $y, $z)
			Next
			ConsoleWrite($loop & @LF)
			Select
				Case BitAND(GUICtrlRead($rbtnClickZone[1]), $GUI_CHECKED) = $GUI_CHECKED ; top
					$x = Random(60, @DesktopWidth - 60, 1)
					$y = Random(30, 60, 1)
					$z = Random(1, 10, 1)
				Case BitAND(GUICtrlRead($rbtnClickZone[2]), $GUI_CHECKED) = $GUI_CHECKED ; right
					$x = Random(@DesktopWidth - 60, @DesktopWidth - 30, 1)
					$y = Random(60, @DesktopHeight - 60, 1)
					$z = Random(1, 10, 1)
				Case BitAND(GUICtrlRead($rbtnClickZone[3]), $GUI_CHECKED) = $GUI_CHECKED ; bottom
					$x = Random(60, @DesktopWidth - 60, 1)
					$y = Random(@DesktopHeight - 60, @DesktopHeight - 30, 1)
					$z = Random(1, 10, 1)
				Case BitAND(GUICtrlRead($rbtnClickZone[4]), $GUI_CHECKED) = $GUI_CHECKED ; left
					$x = Random(30, 60, 1)
					$y = Random(60, @DesktopHeight - 60, 1)
					$z = Random(1, 10, 1)
			EndSelect
			HotKeySet("{]}")
			BlockInput(1)
			If GUICtrlRead($rbtnZoneOn[1]) = $GUI_CHECKED Then MouseClick($primary, $x, $y, 1, $z)
			Sleep(125)
			; set text for next iteration.
			If Not $TextOpts = 1 Then
				Select
					Case $textType = 1 ; random
						$text = " "
						For $x = 1 To Random(4, 10, 1)
							$text = $text & Chr(Random(33, 126, 1))
						Next
					Case $textType = 2 ; witty
						$fileHandle = FileOpen($txtDirWitty, 0)
						If $fileHandle = -1 Then
							BlockInput(0)
							MsgBox(0x30, "File Error", "The Witty Text file you have specified does not exist." & @LF & _
									"Switching to the default Witty Text file.", 5)
							BlockInput(1)
							$txtDirWitty = $txtDefault
							$fileHandle = FileOpen($txtDirWitty, 0)
							IniWrite($iniFile, "TEXTOPTIONS", "File", $txtDefault)
						EndIf
						$eof = _FileCountLines($txtDirWitty)
						Do
							$text = " " & FileReadLine($fileHandle, Random(1, $eof))
						Until Not StringInStr($text, "//") > 0
						FileClose($fileHandle)
					Case $textType = 3 ; custom
						$text = " " & $txtCustom
				EndSelect
			EndIf
			; If text is public or private, send the text.
			If Not $TextOpts = 1 Then ; if send text is not off
				If Not $Exit = 0 Then
					$running = 0
					ExitLoop
				EndIf
				ControlSend($window, "", "", "{esc 5}/" & $channel, 0)
				If Not $TextOpts = 3 Then ControlSend($window, "", "", "{backspace 10}", 0) ; allows for custom emotes and gestures in custom text.
				ControlSend($window, "", "", $text, 1)
				ControlSend($window, "", "", "{enter}", 0)
			EndIf
			BlockInput(0)
			HotKeySet("{]}", "MyExit")
			; If the text is private, change the channel.
			If $TextOpts = 3 Then
				$channel = Random(10000, 99999999, 1)
				ConsoleWrite('@@ Debug(472) : channel changed to: ' & $channel & @LF) ;### Debug Console
			EndIf
			If Not $TextOpts = 1 Then ConsoleWrite('@@ Debug(547/552/568) : text changed to: ' & $text & @LF) ;### Debug Console
			; Sleep for somewhere between $min and $max MINUTES.  Sleeping loop is escapable.
			For $loop = 1 to (600 * Random($min, $max, 1))
				Sleep(100)
				If Not $Exit = 0 Then
					$running = 0
					ExitLoop
				EndIf
			Next
		WEnd
	Else
		MsgBox(0x30, "Critical Error", "Second Life window must exist and be logged in!")
		MyExit()
	EndIf
	#endregion
	GUISetState(@SW_SHOW, $frmMainGUI)
EndFunc   ;==>SecondMouse


Func MouseButtons()
	;Determine if user has swapped right and left mouse buttons
	Local $k = RegRead("HKEY_CURRENT_USER\Control Panel\Mouse", "SwapMouseButtons")
	; It's okay to NOT check the success of the RegRead operation
	If $k = 1 Then
		Global $primary = "right"
		Global $secondary = "left"
	Else ;normal (also case if could not read registry key)
		Global $primary = "left"
		Global $secondary = "right"
	EndIf
EndFunc   ;==>MouseButtons


Func ScriptVer($s_szVer)
	If WinExists($s_szVer) Then
		MsgBox(0, $s_szVer, "Script is already running." & @LF & "Script will now exit.")
		Exit ; It's already running
	EndIf
	AutoItWinSetTitle($s_szVer)
EndFunc   ;==>ScriptVer


Func MyExit()
	Local $window = "classname=Second Life"
	Send("{numlock on}")
	If WinExists($window) And $running = 1 Then
		WinActivate($window)
		WinWaitActive($window)
		;        Send("/0 Script deactivated{enter}")
		$running = 0
	EndIf
	BlockInput(0)
	$Exit = $Exit + 1
EndFunc   ;==>MyExit


Func _Pause()
	$paused = Not $paused
	Send("/0 Script paused{enter}")
	While $paused
		Sleep(500)
		ToolTip('Script is "Paused"', 1, 1)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause


Func ClickZone($iGroup, $iNum, $iImages)
	Select
		Case $iGroup = 1
			For $count = 1 To 3
				GUICtrlSetState($lblSendText[$count], $GUI_HIDE)
			Next
			GUICtrlSetState($lblSendText[$iNum], $GUI_SHOW)
		Case $iGroup = 2
			If $iImages = 1 Then
				; swap the images
				For $count = 1 To 4
					GUICtrlSetState($imgClickZone[$count], $GUI_HIDE)
				Next
				GUICtrlSetState($imgClickZone[$iNum], $GUI_SHOW)
			Else
				; if images don't exist, swap the labels.
				For $count = 1 To 4
					GUICtrlSetState($lblClickZone[$count], $GUI_HIDE)
				Next
				GUICtrlSetState($lblClickZone[$iNum], $GUI_SHOW)
			EndIf
	EndSelect
EndFunc   ;==>ClickZone


Func CreateFile($s_opt)
	Local $file, $fileHandle
	Select
		Case $s_opt = "ini"
			IniWrite($iniFile, "MAIN", "TextControl", 1) ; off(1)/public(2)/private(3)
			IniWrite($iniFile, "MAIN", "ClickControl", 1) ; on(1)/off(2)
			IniWrite($iniFile, "MAIN", "ClickSide", 4) ; top(1)/right(2)/bottom(3)/left(4)
			IniWrite($iniFile, "MAIN", "PositionX", @DesktopWidth - $guiWidth - 10)
			IniWrite($iniFile, "MAIN", "PositionY", 0)
			IniWrite($iniFile, "OPTIONS", "LastUpdate", "2001/01/01")
			IniWrite($iniFile, "OPTIONS", "Windowed", 0)
			IniWrite($iniFile, "OPTIONS", "MinTime", 10)
			IniWrite($iniFile, "OPTIONS", "MaxTime", 25)
			IniWrite($iniFile, "TEXTOPTIONS", "Option", 1) ; random(1)/witty(2)/custom(3)
			IniWrite($iniFile, "TEXTOPTIONS", "File", $txtDefault) ; default witty text location
			IniWrite($iniFile, "TEXTOPTIONS", "Text", "AFK!") ; default custom text
		Case $s_opt = "txt"
			$file = IniRead($iniFile, "TEXTOPTIONS", "File", $txtDefault)
			$fileHandle = FileOpen($file, 2)
			FileWriteLine($fileHandle, "// COMMENTS ARE ANY LINE WITH A DOUBLE SLASH ANYWHERE IN THE TEXT!!")
			FileWriteLine($fileHandle, "// THIS MEANS THAT IF THE PARSER FINDS A DOUBLE SLASH IT WILL SKIP THE ENTIRE LINE")
			FileWriteLine($fileHandle, "// PHRASES MUST BE ON A SINGLE LINE")
			FileWriteLine($fileHandle, "Script created by Heuvadoches Naumova.  Please donate to hir if you find SecondMouse useful.")
			FileWriteLine($fileHandle, "Edison was deaf in one ear and had partial hearing loss in the other, yet he invented the phonograph.")
			FileWriteLine($fileHandle, "Hi there!  I'm camping!  You can too, IM Heuvadoches Naumova for info!")
			FileWriteLine($fileHandle, "Rocking the campers of SecondLife.  One chair at a time.  " & $script)
			FileWriteLine($fileHandle, "I haven't edited my default.txt file yet!")
			FileWriteLine($fileHandle, "I am the camping god(ess).  All hail me!")
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Cloud')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Barret')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Tifa')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Aeris')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Red XIII')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Yuffie')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Vincent')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Cait Sith')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Rufus')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - Sephiroth')
			FileWriteLine($fileHandle, 'Famous Final Fantasy VII Quotes:  "..." - The Turks')
			FileClose($fileHandle)
	EndSelect
EndFunc   ;==>CreateFile


Func GetUpdate()
	Local $url = "http://dragonpen.dyndns.org/files/SMversion.txt", $fileTextUpdate = @TempDir & "\SMVersion.txt", _
			$fileUpdateEXE = @TempDir & "\SMUpdate.EXE", $fileHandle, $netGetFile, $line
	$netGetFile = InetGet($url, $fileTextUpdate, 1, 0)
	If $netGetFile = 0 Then ; unable to get the file
		SetError(1)
		Return 0
	EndIf
	$fileHandle = FileOpen($fileTextUpdate, 0)
	If $fileHandle = -1 Then ; unable to open file
		SetError(2)
		Return 0
	EndIf
	$line = FileReadLine($fileHandle, 1)
	If $line = $script Then ; no update
		FileClose($fileHandle)
		SetError(0)
		Return 0
	EndIf
	FileClose($fileHandle)
	$netGetFile = InetGet($url, $fileUpdateEXE, 1, 0)
	If $netGetFile = 0 Then ; unable to get update
		SetError(3)
		Return 0
	EndIf
	SetError(0)
	Return 1
EndFunc   ;==>GetUpdate
#endregion
#region GNU Public License
#cs
#ce
#endregion