#region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Lark AutoEvent.exe
#AutoIt3Wrapper_Res_requestedExecutionLevel=asInvoker
#endregion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>

#include <_GUISetOnEvent.au3>
#include <GUIScrollbars_Ex.au3>


Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)

TrayCreateItem("Automatically Minimize GUI When Starting Events")
TrayItemSetOnEvent(-1, "trayAutoMinimizeGUIOnEvent")

TrayCreateItem("Keep GUI On Top of Other Windows")
TrayItemSetState(-1, $TRAY_CHECKED)
TrayItemSetOnEvent(-1, "trayKeepGUIOnTop")

TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "trayExit")

Global $boolMinimizeGUIWhenStartingEvents = False; in case the user wants this
Global $boolKeepGUIOnTop = True


Global $hForm = GUICreate("Lark AutoEvent", 580, 550, Default, Default, Default, $WS_EX_TOPMOST)


; this array stores the control positioning data: [$i][0] = left, [$i][1] = top
; this is used when deleting an event because you have to reposition the controls
Global Const $avControlPositions[24][2] = [[10, 60],[110, 60],[215, 60],[300, 60],[370, 60],[10, 85],[90, 85],[190, 85],[200, 85],[240, 85], _
		[250, 85],[290, 85],[350, 85],[375, 85],[430, 85],[445, 85],[500, 85],[10, 115],[120, 115],[155, 115], _
		[250, 115],[275, 115],[310, 115],[380, 115]]

Global $hAddNewEventButton = GUICtrlCreateButton("Add New Event", 10, 10, 100, 25); to add a new event
_GUICtrlSetOnEvent($hAddNewEventButton, "addEvent", False, Default, "button")

Global $hStartButton = GUICtrlCreateButton("Start!", 150, 10, 50, 25); to start the events
_GUICtrlSetOnEvent($hStartButton, "runThroughEvents", False, Default, "button")

Global $hLoopLabel = GUICtrlCreateLabel("Loop", 230, 10, 30)
Global $hLoopInput = GUICtrlCreateInput("", 260, 10, 40, 22); this is the number of times the user wants all of the events to repeatedly run
Global $hTimesLabel = GUICtrlCreateLabel("times (if left blank, the events will loop until stopped).", 305, 10, 150, 50)

$hSaveButton = GUICtrlCreateButton("Save To File", 480, 8, 80, 15)
_GUICtrlSetOnEvent($hSaveButton, "saveToFile", False, Default, "button")

$hLoadButton = GUICtrlCreateButton("Load From File", 480, 29, 80, 15)
_GUICtrlSetOnEvent($hLoadButton, "loadFromFile", False, Default, "button")

Global $iNumberOfEvents = 1; used to add/remove events


Global $avControls[1][24]

$avControls[0][0] = GUICtrlCreateCombo("Left Click", 10, 60, 100); for the user to select what type of event to run
GUICtrlSetData(-1, "Right Click|Middle Click|Mouse Move|Run|Type|WinWait|WinWaitActive|WinWaitNotActive|WinActivate|WinWaitClose|WinClose|WinFlash|Turn Off Computer")
_GUICtrlSetOnEvent($avControls[0][0], "comboChange", True, $avControls[0][0], $EN_CHANGE)

$avControls[0][1] = GUICtrlCreateInput("", 110, 60, 100, 22); an input where the user specifys the data for Run(), WinWait(), etc.
GUICtrlSetState(-1, $GUI_HIDE); this is not used for the left click so hide this
$avControls[0][2] = GUICtrlCreateLabel("Number of clicks:", 215, 60)
$avControls[0][3] = GUICtrlCreateInput("1", 300, 60, 50, 22); the user specifys the number of clicks, for a click event
$avControls[0][4] = GUICtrlCreateCheckbox("Use human-like mouse movement", 370, 60, 180, 22); in case the user wants to look like a human
$avControls[0][5] = GUICtrlCreateLabel("Event 1", 10, 85, 80); to tell the user which event this is
GUICtrlSetFont(-1, 10, 600); to make it stand out
$avControls[0][6] = GUICtrlCreateButton("Delete Event", 90, 85, 80, 19); if the user wants to remove this event
GUICtrlSetFont(-1, 8.5, 400, 2); to make it stand out
_GUICtrlSetOnEvent($avControls[0][6], "removeEvent", True, $avControls[0][6], "button")

$avControls[0][7] = GUICtrlCreateLabel("x:", 190, 85)
$avControls[0][8] = GUICtrlCreateInput("", 200, 85, 30, 22); to store the x coordinate
$avControls[0][9] = GUICtrlCreateLabel("y:", 240, 85)
$avControls[0][10] = GUICtrlCreateInput("", 250, 85, 30, 22); to store the y coordinate
$avControls[0][11] = GUICtrlCreateButton("Find...", 290, 85, 40, 22)
_GUICtrlSetOnEvent($avControls[0][11], "displayMouseCoordinates", True, $avControls[0][11], "button")

$avControls[0][12] = GUICtrlCreateLabel("Wait", 350, 85)
$avControls[0][13] = GUICtrlCreateInput("1000", 375, 85, 50, 22); the minimum number of milliseconds to wait before running the event
$avControls[0][14] = GUICtrlCreateLabel("to", 430, 85)
$avControls[0][15] = GUICtrlCreateInput("1200", 445, 85, 50, 22); the maximum number of milliseconds to wait before running the event
$avControls[0][16] = GUICtrlCreateLabel("milliseconds.", 500, 85)
$avControls[0][17] = GUICtrlCreateLabel("Randomize position by", 10, 115, 110)
$avControls[0][18] = GUICtrlCreateInput("0", 120, 115, 30, 22); on a mouse click event, the x and y coordinates are randomized by this value
$avControls[0][19] = GUICtrlCreateLabel("pixels.", 155, 115, 40)
$avControls[0][20] = GUICtrlCreateLabel("Run", 250, 115, 20)
$avControls[0][21] = GUICtrlCreateInput("1", 275, 115, 30, 22); incase you want to run this event more than once. here you input how many times to run the event
$avControls[0][22] = GUICtrlCreateLabel("time(s).", 310, 115)
$avControls[0][23] = GUICtrlCreateLabel("", 380, 115, 200, 25); this label is updated while its event is running to update the amount of milliseconds left
; until the event is run

GUISetState()
Do
Until GUIGetMsg() = -3



Func trayKeepGUIOnTop()
	If $boolKeepGUIOnTop Then; if its true then set it to false and get rid of the style of the GUI
		$boolKeepGUIOnTop = False
		WinSetOnTop("Lark Autoclicker", "", 0)
	Else
		$boolKeepGUIOnTop = True; its false so set it to true
		WinSetOnTop("Lark Autoclicker", "", 1)
	EndIf
EndFunc

Func trayAutoMinimizeGUIOnEvent()
	$boolMinimizeGUIWhenStartingEvents = Not $boolMinimizeGUIWhenStartingEvents; switch varaible from true to false and vice versa
EndFunc

Func trayExit(); for the tray item "Exit"
	Exit
EndFunc






Func saveToFile()
	GUISetState(@SW_MINIMIZE); so that the gui is not in the way of the FileSaveDialog()
	Local $sLocation = FileSaveDialog("Save Events To File", @WorkingDir, "Lark AutoEvent File (*.lae)", 16, "", $hForm); let the user select the file to save to
	If @error Then Return
	GUISetState(@SW_RESTORE)

	If Not (StringRight($sLocation, 4) == ".lae") Then $sLocation &= ".lae"; the string was missing the .lae extention which would cause a problem with loadFromFile()

	FileOpen($sLocation, 2); create the file and/or erase its previous contents

	Local $avData[10][2]; this will be the array where the data from the controls will be stored that will be written to ini section

	; add in the keys of the ini
	$avData[0][0] = "sEventType"
	$avData[1][0] = "sInputData"
	$avData[2][0] = "iNumberOfClicks"
	$avData[3][0] = "iUseHumanLikeMouseMovementsState"
	$avData[4][0] = "iX"
	$avData[5][0] = "iY"
	$avData[6][0] = "iWaitMin"
	$avData[7][0] = "iWaitMax"
	$avData[8][0] = "iRandomPos"
	$avData[9][0] = "iTimesToRun"

	; add in the data and save it to the file
	For $i = 0 To $iNumberOfEvents - 1
		$avData[0][1] = GUICtrlRead($avControls[$i][0])
		$avData[1][1] = GUICtrlRead($avControls[$i][1])
		$avData[2][1] = GUICtrlRead($avControls[$i][3])
		$avData[3][1] = GUICtrlRead($avControls[$i][4])
		$avData[4][1] = GUICtrlRead($avControls[$i][8])
		$avData[5][1] = GUICtrlRead($avControls[$i][10])
		$avData[6][1] = GUICtrlRead($avControls[$i][13])
		$avData[7][1] = GUICtrlRead($avControls[$i][15])
		$avData[8][1] = GUICtrlRead($avControls[$i][18])
		$avData[9][1] = GUICtrlRead($avControls[$i][21])

		IniWriteSection($sLocation, "section" & ($i + 1), $avData, 0)
	Next
EndFunc   ;==>saveToFile

Func loadFromFile()
	GUISetState(@SW_MINIMIZE); so that the gui is not in the way of the FileOpenDialog()
	Local $sLocation = FileOpenDialog("Load Events From File", @WorkingDir, "Lark AutoEvent File (*.lae)", 1, "", $hForm); let the user select which file to open
	If @error Then Return
	GUISetState(@SW_RESTORE)

	Local $avEvents = IniReadSectionNames($sLocation); read the section names (to find the number of sections)
	Local $sData; faster declaring it here instead of in the loop

	While $iNumberOfEvents
		removeEvent(0, True)
	WEnd

	For $i = 1 To UBound($avEvents) - 1
		Local $iIndex = $iNumberOfEvents

		ReDim $avControls[$iIndex + 1][24]

		;create all the controls, and if applicable, load data from the ini to put in the control

		$sData = IniRead($sLocation, $avEvents[$i], "sEventType", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][0] = GUICtrlCreateCombo("Left Click", 10, 60 + ($iIndex * 150), 100); for the user to select what type of event to run
		GUICtrlSetData(-1, "Right Click|Middle Click|Mouse Move|Run|Type|WinWait|WinWaitActive|WinWaitNotActive|WinActivate|WinWaitClose|WinClose|WinFlash", $sData)
		_GUICtrlSetOnEvent($avControls[$iIndex][0], "comboChange", True, $avControls[$iIndex][0], $EN_CHANGE)

		$sData = IniRead($sLocation, $avEvents[$i], "sInputData", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][1] = GUICtrlCreateInput($sData, 110, 60 + ($iIndex * 150), 100, 22); an input where the user specifys the data for Run(), WinWait(), etc.
		$avControls[$iIndex][2] = GUICtrlCreateLabel("Number of clicks:", 215, 60 + ($iIndex * 150))
		$sData = IniRead($sLocation, $avEvents[$i], "iNumberOfClicks", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][3] = GUICtrlCreateInput($sData, 300, 60 + ($iIndex * 150), 50, 22); the user specifys the number of clicks, for a click event
		$sData = IniRead($sLocation, $avEvents[$i], "iUseHumanLikeMouseMovementsState", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][4] = GUICtrlCreateCheckbox("Use human-like mouse movement", 370, 60 + ($iIndex * 150), 180, 22); in case the user wants to look like a human
		GUICtrlSetState(-1, Number($sData)); set the state- namely $GUI_CHECKED
		$avControls[$iIndex][5] = GUICtrlCreateLabel("Event " & $iIndex + 1, 10, 85 + ($iIndex * 150), 80); to tell the user which event this is
		GUICtrlSetFont(-1, 10, 600); to make it stand out
		$avControls[$iIndex][6] = GUICtrlCreateButton("Delete Event", 90, 85 + ($iIndex * 150), 80, 19); if the user wants to remove this event
		GUICtrlSetFont(-1, 8.5, 400, 2); to make it stand out
		_GUICtrlSetOnEvent($avControls[$iIndex][6], "removeEvent", True, $avControls[$iIndex][6], "button")

		$avControls[$iIndex][7] = GUICtrlCreateLabel("x:", 190, 85 + ($iIndex * 150))
		$sData = IniRead($sLocation, $avEvents[$i], "iX", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][8] = GUICtrlCreateInput($sData, 200, 85 + ($iIndex * 150), 30, 22); to store the x coordinate
		$avControls[$iIndex][9] = GUICtrlCreateLabel("y:", 240, 85 + ($iIndex * 150))
		$sData = IniRead($sLocation, $avEvents[$i], "iY", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][10] = GUICtrlCreateInput($sData, 250, 85 + ($iIndex * 150), 30, 22); to store the y coordinate
		$avControls[$iIndex][11] = GUICtrlCreateButton("Find...", 290, 85 + ($iIndex * 150), 40, 22)
		_GUICtrlSetOnEvent($avControls[$iIndex][11], "displayMouseCoordinates", True, $avControls[$iIndex][11], "button")

		$avControls[$iIndex][12] = GUICtrlCreateLabel("Wait", 350, 85 + ($iIndex * 150))
		$sData = IniRead($sLocation, $avEvents[$i], "iWaitMin", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][13] = GUICtrlCreateInput($sData, 375, 85 + ($iIndex * 150), 50, 22); the minimum number of milliseconds to wait before running the event
		$avControls[$iIndex][14] = GUICtrlCreateLabel("to", 430, 85 + ($iIndex * 150))
		$sData = IniRead($sLocation, $avEvents[$i], "iWaitMax", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][15] = GUICtrlCreateInput($sData, 445, 85 + ($iIndex * 150), 50, 22); the maximum number of milliseconds to wait before running the event
		$avControls[$iIndex][16] = GUICtrlCreateLabel("milliseconds.", 500, 85 + ($iIndex * 150))
		$avControls[$iIndex][17] = GUICtrlCreateLabel("Randomize position by", 10, 115 + ($iIndex * 150), 110)
		$sData = IniRead($sLocation, $avEvents[$i], "iRandomPos", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][18] = GUICtrlCreateInput($sData, 120, 115 + ($iIndex * 150), 30, 22); on a mouse click event, the x and y coordinates are randomized by this value
		$avControls[$iIndex][19] = GUICtrlCreateLabel("pixels.", 155, 115 + ($iIndex * 150), 40)
		$avControls[$iIndex][20] = GUICtrlCreateLabel("Run", 250, 115 + ($iIndex * 150), 20)
		$sData = IniRead($sLocation, $avEvents[$i], "iTimesToRun", "a FaTaL ErRoR hAs OcCuReD")
		$avControls[$iIndex][21] = GUICtrlCreateInput($sData, 275, 115 + ($iIndex * 150), 30, 22); incase you want to run this event more than once. here you input how many times to run the event
		$avControls[$iIndex][22] = GUICtrlCreateLabel("time(s).", 310, 115 + ($iIndex * 150))
		$avControls[$iIndex][23] = GUICtrlCreateLabel("", 380, 115 + ($iIndex * 150), 200, 25)


		$iNumberOfEvents += 1

		If $iNumberOfEvents >= 4 Then; less controls so resize the scrollbars
			_GUIScrollbars_Generate($hForm, 0, ($iNumberOfEvents * 150))
		Else; less then 4 events so need for scroolbars; remove them
			_GUIScrollbars_Generate($hForm, 0, 0)
		EndIf

		comboChange($avControls[$iIndex][0]); to hide/show the events depending on the event
	Next
EndFunc   ;==>loadFromFile

Func windowEvent($iIndex, $sEvent)
	Local $sTextData = GUICtrlRead($avControls[$iIndex][1]); get the data we will be working with

	Local $iRunCount = 1
	If GUICtrlGetState(-1) = $GUI_SHOW Then $iRunCount = Int(Number(GUICtrlRead($avControls[$iIndex][21]))); save the number of times to perform this action
																										   ; but only if that is valid for this event


	Local $iKeepRunning; this variable will store the return value of pause() which will indicate whether the user pressed the stop button while pausing

	For $i = 1 To $iRunCount
		$iMinWait = Number(GUICtrlRead($avControls[$iIndex][13])); recalculate this on every loop for randomness in the times
		$iMaxWait = Number(GUICtrlRead($avControls[$iIndex][15]))

		If $iMinWait > $iMaxWait Then; error catching, the min cannot be greater than the max in Random(min, max)
			$iKeepRunning = pause(Random($iMaxWait, $iMinWait), $iIndex); wait the specified time
		ElseIf $iMinWait = $iMaxWait Then; error catching, the min cannot equal the max in Random(min, max)
			$iKeepRunning = pause($iMinWait, $iIndex)
		Else
			$iKeepRunning = pause(Random($iMinWait, $iMaxWait), $iIndex)
		EndIf

		If Not $iKeepRunning Then Return 0; if the user pressed the stop button while pausing then do not run the event

		Switch $sEvent
			Case "Run"
				ShellExecute($sTextData)

			Case "Type"
				Send($sTextData)

			Case "WinWait"
				While Not WinExists($sTextData); when using WinWait, there is nothing to check for these gui events so i do this
					Sleep(10)
					Switch GUIGetMsg();
						Case -3
							Exit

						Case $hStartButton
							Return 0

					EndSwitch
				WEnd

			Case "WinWaitActive"
				While Not WinActive($sTextData)
					Sleep(10)
					Switch GUIGetMsg()
						Case -3
							Exit

						Case $hStartButton
							Return 0

					EndSwitch
				WEnd

			Case "WinWaitNotActive"
				While WinActive($sTextData)
					Sleep(10)
					Switch GUIGetMsg()
						Case -3
							Exit

						Case $hStartButton
							Return 0

					EndSwitch
				WEnd

			Case "WinActivate"
				WinActivate($sTextData)

			Case "WinWaitClose"
				While WinExists($sTextData)
					Sleep(10)
					Switch GUIGetMsg()
						Case -3
							Exit

						Case $hStartButton
							Return 0

					EndSwitch
				WEnd

			Case "WinClose"
				WinClose($sTextData)

			Case "WinFlash"
				WinFlash($sTextData)

			Case "Turn Off Computer"
				Shutdown(13); force a shutdown and powerdown

		EndSwitch
	Next
	Return 1
EndFunc   ;==>windowEvent

Func mouseEvent($iIndex, $sEvent)
	Local $iNumberOfClicks, $boolUseHumanMouseMovement, $iX, $iY, $iMinWait, $iMaxWait, $iRandomPixels, $iRunCount; declare all these variables here

	$iNumberOfClicks = Int(Number(GUICtrlRead($avControls[$iIndex][3]))); save the number of clicks to perform
	$boolUseHumanMouseMovement = GUICtrlRead($avControls[$iIndex][4])
	If BitAND($boolUseHumanMouseMovement, $GUI_CHECKED) = $GUI_CHECKED Then; find out if the "use human-like mouse movement" checkbox is checked
		$boolUseHumanMouseMovement = True
	Else
		$boolUseHumanMouseMovement = False
	EndIf

	$iX = Int(Number(GUICtrlRead($avControls[$iIndex][8]))); save the x coordinate
	$iY = Int(Number(GUICtrlRead($avControls[$iIndex][10]))); save the y coordinate

	$iRandomPixels = Abs(Int(Number(GUICtrlRead($avControls[$iIndex][18]))))

	If $iRandomPixels Then
		$iX += Int((Random($iRandomPixels * - 1, $iRandomPixels) * .705)); randomize the pixel
		$iY += Int((Random($iRandomPixels * - 1, $iRandomPixels) * .705))
		; while experimenting with the equation for finding the distance between two points, I found that to reach the furthest distance from
		;one point to another based on randomizing the position by a set distance, you add the set randomized max distance to both the x and y
		;coordinates and multiply them by .705
	EndIf


	$iRunCount = Int(Number(GUICtrlRead($avControls[$iIndex][21]))); save the number of times to perform this action

	For $iLow = 1 To $iRunCount
		$iMinWait = Number(GUICtrlRead($avControls[$iIndex][13])); recalculate this on every loop for randomness in the times
		$iMaxWait = Number(GUICtrlRead($avControls[$iIndex][15]))

		If $iMinWait > $iMaxWait Then; error catching, the min cannot be greater than the max in Random(min, max)
			$iKeepRunning = pause(Random($iMaxWait, $iMinWait), $iIndex); wait the specified time
		ElseIf $iMinWait = $iMaxWait Then; error catching, the min cannot equal the max in Random(min, max)
			$iKeepRunning = pause($iMinWait, $iIndex)
		Else
			$iKeepRunning = pause(Random($iMinWait, $iMaxWait), $iIndex)
		EndIf

		If Not $iKeepRunning Then Return 0; if the user pressed the stop button while pausing then do not run the event

		If $sEvent == "move" Then; incase this is for moving the mouse and not clicking
			If $boolUseHumanMouseMovement Then
				moveMouse($iX, $iY); if specified then simulate a human mousemove
			Else
				MouseMove($iX, $iY); otherwise just move normally (or is it un-normally?)
			EndIf
		Else
			If $boolUseHumanMouseMovement Then
				moveMouse($iX, $iY); if specified then simulate a human mousemove
				MouseClick($sEvent, $iX, $iY, $iNumberOfClicks); and then click
			Else
				MouseClick($sEvent, $iX, $iY, $iNumberOfClicks); otherwise just move normally (or is it un-normally?)
			EndIf
		EndIf
	Next
	Return 1
EndFunc   ;==>mouseEvent

Func runThroughEvents()
	If $boolMinimizeGUIWhenStartingEvents Then GUISetState(@SW_MINIMIZE); if the option was set

	Local $iReturnCode; to keep track of what the event functions return in case
	GUICtrlSetData($hStartButton, "Stop")

	Local $iAmountToLoop = GUICtrlRead($hLoopInput); this is the number of times that the user specified to loop the events
	If Not ($iAmountToLoop == "") Then $iAmountToLoop = Int(Number($iAmountToLoop))

	While 1; loop until stopped
		Switch GUIGetMsg();
			Case -3
				Exit

			Case $hStartButton
				GUICtrlSetData($hStartButton, "Start"); reset the data in this control
				If $boolMinimizeGUIWhenStartingEvents Then GUISetState(@SW_RESTORE); if the option was set
				Return; and we're done here

		EndSwitch

		For $i = 0 To $iNumberOfEvents - 1

			GUICtrlSetColor($avControls[$i][5], 0x00EE00); set the color so the user knows what the current event is

			Switch GUICtrlRead($avControls[$i][0])
				Case "Left Click"
					$iReturnCode = mouseEvent($i, "left")

				Case "Right Click"
					$iReturnCode = mouseEvent($i, "right")

				Case "Middle Click"
					$iReturnCode = mouseEvent($i, "middle")

				Case "Mouse Move"
					$iReturnCode = mouseEvent($i, "move")

				Case Else
					$iReturnCode = windowEvent($i, GUICtrlRead($avControls[$i][0]))

			EndSwitch
			GUICtrlSetColor($avControls[$i][5], 0x000000); change the color back to normal
		Next

		If Not $iReturnCode Then; during the event the user pressed the 'stop' button
			GUICtrlSetData($hStartButton, "Start"); reset the data in this control
			If $boolMinimizeGUIWhenStartingEvents Then GUISetState(@SW_RESTORE); if the option was set
			Return; and we're done here
		EndIf

		If Not ($iAmountToLoop == "") Then; if there is a set amount of times to loop
			$iAmountToLoop -= 1; just finished one loop so decrement this because there is one less loop to go through
			If $iAmountToLoop < 0 Then; finished all the loops so return
				GUICtrlSetData($hStartButton, "Start"); reset the data in this control
				If $boolMinimizeGUIWhenStartingEvents Then GUISetState(@SW_RESTORE); if the option was set
				Return
			EndIf
		EndIf
	WEnd
EndFunc   ;==>runThroughEvents

Func pause($iWait, $iIndex); pause for the specified amount of time
	Local $hStart = TimerInit()

	GUICtrlSetData($avControls[$iIndex][23], "In " & Round(	$iWait) & "milliseconds"); set the amount of time left until the event

	While TimerDiff($hStart) < $iWait
		Switch GUIGetMsg()
			Case -3
				Exit

			Case $hStartButton
				GUICtrlSetData($avControls[$iIndex][23], "")
				Return 0; if the user pressed the stop button then no point making the user wait any longer

		EndSwitch
		Sleep(20); if this isn't here the program will pretty much crash

		If Mod(TimerDiff($hStart), 580) >= 500 Then; so that the label is not updated too much/too fast; with this it will only be updated every 500 milliseconds or so
			GUICtrlSetData($avControls[$iIndex][23], "In " & Round(($iWait - TimerDiff($hStart))) & "milliseconds"); set the amount of time left until the event
		EndIf
	WEnd
	GUICtrlSetData($avControls[$iIndex][23], ""); reset the data in this control
	Return 1
EndFunc   ;==>pause

Func removeEvent($hControl, $boolPassingInIndex = False); remove an event
	If $boolPassingInIndex Then; in loadFromFile() the index is passed in
		$iIndex = $hControl
	Else
		$iIndex = findEventIndex($hControl)
	EndIf

	For $i = 0 To UBound($avControls, 2) - 1
		GUICtrlDelete($avControls[$iIndex][$i]); loop through and delete the controls
	Next

	For $i = $iIndex To UBound($avControls) - 2; loop through each event
		For $iLow = 0 To UBound($avControls, 2) - 1; and loop through event control
			$avControls[$i][$iLow] = $avControls[$i + 1][$iLow]; move each index down

			GUICtrlSetPos($avControls[$i][$iLow], $avControlPositions[$iLow][0], $avControlPositions[$iLow][1] + ($i * 150))
			; (for the above line) move up the position of the event controls so that it is in the position of the event above it
		Next
		GUICtrlSetData($avControls[$i][5], "Event " & $i + 1);  change this label so that it displays the right event number
	Next

	If UBound($avControls) > 1 Then; to avoid errors; we can't resize an array to have 0 indexes
		ReDim $avControls[$iNumberOfEvents - 1][24]
	EndIf
	$iNumberOfEvents -= 1

	If $iNumberOfEvents >= 4 Then; less controls so resize the scrollbars
		_GUIScrollbars_Generate($hForm, 0, ($iNumberOfEvents * 150))
	Else; less then 4 events so need for scroolbars; remove them
		_GUIScrollbars_Generate($hForm, 0, 0)
	EndIf
EndFunc   ;==>removeEvent

Func addEvent(); create a new event
	Local $iIndex = $iNumberOfEvents

	ReDim $avControls[$iIndex + 1][24]

	$avControls[$iIndex][0] = GUICtrlCreateCombo("Left Click", 10, 60 + ($iIndex * 150), 100); for the user to select what type of event to run
	GUICtrlSetData(-1, "Right Click|Middle Click|Mouse Move|Run|Type|WinWait|WinWaitActive|WinWaitNotActive|WinActivate|WinWaitClose|WinClose|WinFlash")
	_GUICtrlSetOnEvent($avControls[$iIndex][0], "comboChange", True, $avControls[$iIndex][0], $EN_CHANGE)

	$avControls[$iIndex][1] = GUICtrlCreateInput("", 110, 60 + ($iIndex * 150), 100, 22); an input where the user specifys the data for Run(), WinWait(), etc.
	GUICtrlSetState(-1, $GUI_HIDE); this is not used for the left click so hide this
	$avControls[$iIndex][2] = GUICtrlCreateLabel("Number of clicks:", 215, 60 + ($iIndex * 150))
	$avControls[$iIndex][3] = GUICtrlCreateInput("1", 300, 60 + ($iIndex * 150), 50, 22); the user specifys the number of clicks, for a click event
	$avControls[$iIndex][4] = GUICtrlCreateCheckbox("Use human-like mouse movement", 370, 60 + ($iIndex * 150), 180, 22); in case the user wants to look like a human
	$avControls[$iIndex][5] = GUICtrlCreateLabel("Event " & $iIndex + 1, 10, 85 + ($iIndex * 150), 80); to tell the user which event this is
	GUICtrlSetFont(-1, 10, 600); to make it stand out
	$avControls[$iIndex][6] = GUICtrlCreateButton("Delete Event", 90, 85 + ($iIndex * 150), 80, 19); if the user wants to remove this event
	GUICtrlSetFont(-1, 8.5, 400, 2); to make it stand out
	_GUICtrlSetOnEvent($avControls[$iIndex][6], "removeEvent", True, $avControls[$iIndex][6], "button")

	$avControls[$iIndex][7] = GUICtrlCreateLabel("x:", 190, 85 + ($iIndex * 150))
	$avControls[$iIndex][8] = GUICtrlCreateInput("", 200, 85 + ($iIndex * 150), 30, 22); to store the x coordinate
	$avControls[$iIndex][9] = GUICtrlCreateLabel("y:", 240, 85 + ($iIndex * 150))
	$avControls[$iIndex][10] = GUICtrlCreateInput("", 250, 85 + ($iIndex * 150), 30, 22); to store the y coordinate
	$avControls[$iIndex][11] = GUICtrlCreateButton("Find...", 290, 85 + ($iIndex * 150), 40, 22)
	_GUICtrlSetOnEvent($avControls[$iIndex][11], "displayMouseCoordinates", True, $avControls[$iIndex][11], "button")

	$avControls[$iIndex][12] = GUICtrlCreateLabel("Wait", 350, 85 + ($iIndex * 150))
	$avControls[$iIndex][13] = GUICtrlCreateInput("1000", 375, 85 + ($iIndex * 150), 50, 22); the minimum number of milliseconds to wait before running the event
	$avControls[$iIndex][14] = GUICtrlCreateLabel("to", 430, 85 + ($iIndex * 150))
	$avControls[$iIndex][15] = GUICtrlCreateInput("1200", 445, 85 + ($iIndex * 150), 50, 22); the maximum number of milliseconds to wait before running the event
	$avControls[$iIndex][16] = GUICtrlCreateLabel("milliseconds.", 500, 85 + ($iIndex * 150))
	$avControls[$iIndex][17] = GUICtrlCreateLabel("Randomize position by", 10, 115 + ($iIndex * 150), 110)
	$avControls[$iIndex][18] = GUICtrlCreateInput("0", 120, 115 + ($iIndex * 150), 30, 22); on a mouse click event, the x and y coordinates are randomized by this value
	$avControls[$iIndex][19] = GUICtrlCreateLabel("pixels.", 155, 115 + ($iIndex * 150), 40)
	$avControls[$iIndex][20] = GUICtrlCreateLabel("Run", 250, 115 + ($iIndex * 150), 20)
	$avControls[$iIndex][21] = GUICtrlCreateInput("1", 275, 115 + ($iIndex * 150), 30, 22); incase you want to run this event more than once. here you input how many times to run the event
	$avControls[$iIndex][22] = GUICtrlCreateLabel("time(s).", 310, 115 + ($iIndex * 150))
	$avControls[$iIndex][23] = GUICtrlCreateLabel("", 380, 115 + ($iIndex * 150), 200, 25)


	$iNumberOfEvents += 1

	If $iNumberOfEvents >= 4 Then; less controls so resize the scrollbars
		_GUIScrollbars_Generate($hForm, 0, ($iNumberOfEvents * 150))
	Else; less then 4 events so need for scroolbars; remove them
		_GUIScrollbars_Generate($hForm, 0, 0)
	EndIf
EndFunc   ;==>addEvent

Func displayMouseCoordinates($hControl); to display the mouse coordinates for the user
	GUICtrlSetData($hControl, "Stop"); so the user knows to click the button again to stop displaying the mouse coordinates
	Local $iX = MouseGetPos(0); save the current coordinates so we can know when it changes
	Local $iY = MouseGetPos(1)
	ToolTip("Current X Position: " & $iX & @CRLF & "Current Y Position: " & $iY, Default, Default, Default, Default, 4); display the mouse coordinates
	While 1; loop until the button is pressed, in which case the data in the control will no longer read "Stop"
		Switch GUIGetMsg()
			Case -3; the user closed the gui
				Exit; so exit

			Case $hControl; the user clicked the button again to stop
				ToolTip(""); turn off the tooltip
				GUICtrlSetData($hControl, "Find..."); reset the data in this control
				Return; and we are done here

		EndSwitch

		If ($iX <> MouseGetPos(0)) Or ($iY <> MouseGetPos(1)) Then; if they changed the mouse position then update the tooltip
			$iX = MouseGetPos(0)
			$iY = MouseGetPos(1)
			ToolTip("Current X Position: " & $iX & @CRLF & "Current Y Position: " & $iY, Default, Default, Default, Default, 4);  update the mouse coordinates
		EndIf
		Sleep(10); i know its bad practice to do this but the program will crash if this isn't here
	WEnd
EndFunc   ;==>displayMouseCoordinates

Func comboChange($hControl); the hides/shows the controls for an event when the data in the event's combo changes
	Local $iIndex = findEventIndex($hControl)
	Switch GUICtrlRead($hControl)
		Case "Left Click", "Right Click", "Middle Click"
			For $i = 0 To UBound($avControls, 2) - 1; loop through and hide / show particular controls for this event
				Switch $i
					Case 1; input not used for this event
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_HIDE)

					Case Else
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_SHOW)

				EndSwitch
			Next

		Case "Mouse Move"
			For $i = 0 To UBound($avControls, 2) - 1
				Switch $i
					Case 1, 2, 3, 23; index 1: an input      index 2 and 3: the "Number of Clicks:" [input]   		index 23: updated while running events to show
									;																		the remaining milliseconds left before the event will be run.
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_HIDE)

					Case Else
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_SHOW)

				EndSwitch
			Next

		Case "WinWait", "WinWaitActive", "WinWaitNotActive", "WinWaitClose", "Turn Off Computer"; show only the main data input and the "wait x to y milliseconds"
			For $i = 0 To UBound($avControls, 2) - 1
				Switch $i
					Case 0, 1, 5, 6, 12, 13, 14, 15, 16, 23
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_SHOW)

					Case Else
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_HIDE); all the rest are not used here

				EndSwitch
			Next



		Case "Run", "WinActivate", "WinClose", "WinFlash", "Type"; show only the main data input, "wait x to y milliseconds", and the "run x times"
			For $i = 0 To UBound($avControls, 2) - 1
				Switch $i
					Case 0, 1, 5, 6, 12, 13, 14, 15, 16, 20, 21, 22, 23
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_SHOW)

					Case Else
						GUICtrlSetState($avControls[$iIndex][$i], $GUI_HIDE)

				EndSwitch
			Next
	EndSwitch
EndFunc   ;==>comboChange

Func findEventIndex($hControl); if there is a control in $avControls this find what 1st dimention index it is in
	For $i = 0 To UBound($avControls) - 1
		For $iLow = 0 To UBound($avControls, 2) - 1
			If $avControls[$i][$iLow] = $hControl Then Return $i
		Next
	Next
	Return $hControl
EndFunc   ;==>findEventIndex






#region Human-like mouse moving functions

; i didn't actually write this mousemove function. I just found it on the autoit forums as a smooth mousemove to replace the regular one.
; i did edit it a little so that it looks more like a human mousemove
Func moveMouse($x2, $y2)
	$x1 = MouseGetPos(0);
	$y1 = MouseGetPos(1);
	$xC = $x2 - $x1
	$yC = $y2 - $y1
	Local $tC = Sqrt($xC ^ 2 + $yC ^ 2)
	Local $cP = 125
	If $tC < 400 Then $cP = ($tC * .25)
	If $tC < 200 Then $cP = ($tC * .16)

	$xv = Random($cP * - 1, $cP);	originally at Random(-100, 100)			125
	$yv = Random($cP * - 1, $cP);	originally at Random(-100, 100)			125
	$sm = Random(1, 2);			originally at Random(1.5, 2.5)
	$m = Random(80, 140);
	For $i = 0 To $m
		$ci = __calci($i / $m, $sm);
		$co = __calof($i / $m, $sm);
		$cx = Int($x1 + (($x2 - $x1) * $ci) + ($xv * $co));
		$cy = Int($y1 + (($y2 - $y1) * $ci) + ($yv * $co));
		MouseMove($cx, $cy, Random(1.34, 1.45));
	Next
EndFunc   ;==>moveMouse
Func __calci1($i, $sm)
	Return $i ^ $sm;
EndFunc   ;==>__calci1
Func __calci2($i, $sm)
	Return 1 - ((1 - $i) ^ $sm);
EndFunc   ;==>__calci2
Func __calci($i, $sm)
	If ($i < 0.5) Then
		Return __calci1($i * 2, $sm) / 2;
	Else
		Return (__calci2(($i - 0.5) * 2, $sm) / 2) + 0.5;
	EndIf
EndFunc   ;==>__calci
Func __calof($i, $sm)
	If ($i < 0.5) Then
		Return __calci($i * 2, $sm);
	Else
		Return __calci((1 - $i) * 2, $sm);
	EndIf
EndFunc   ;==>__calof

#endregion