;
;the ini file for this program must have the same name and be in the same folder as the exe file

;Includes
#include <GUIConstants.au3>

;Variables Initialisation
$ProgIniFileNameAndPath = StringTrimRight(@ScriptFullPath, 3) & "ini"
$WasValidNumberEntered = "no"
$PrinterNameSeenByUser = " "
$InfFileLocation = " "
$PrinterPort = " "
$PrinterModelNumberInInfFile = " "
$NumberofPrintersToInstall = 1 ; this is changed later for multiple printer installations
$SpecificRoom = ""
$InstallationCyclesDone = 0 ; used to track how many printers have been done

; check INI exists
$CheckINIExists = FileExists($ProgIniFileNameAndPath)
If $CheckINIExists = 0 Then
	MsgBox(0, "INI Not Found", "Program INI file '" & $ProgIniFileNameAndPath & "' not found - cannot continue")
	Exit
EndIf
; read global section variables from INI file
$ScriptID = IniRead($ProgIniFileNameAndPath, "Global", "ScriptID", "Script ID Missing from INI File")
$PauseTimeSeconds = IniRead($ProgIniFileNameAndPath, "Global", "PauseTime", 50) ; time to wait for printer installation to continue
$PrinterDriverRepository = IniRead($ProgIniFileNameAndPath, "Global", "PrinterDriverRepository", "C:\windows\system32\inf")

; read room lists section from ini file
$RoomListsArray = IniReadSection($ProgIniFileNameAndPath, "RoomLists")
;create list for GUI control
$RoomListSelectionString = "Enter Room Manually"
For $Listcounter = 1 To $RoomListsArray[0][0]
	$RoomListSelectionString = $RoomListSelectionString & "|" & $Listcounter & ": " & $RoomListsArray[$Listcounter][0]
Next

;display room list to select GUI
$CurrentGUITitle = "Printer Installation Script"
GUICreate($CurrentGUITitle, 300, 140, (@DesktopWidth - 300) / 2, (@DesktopHeight - 250) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST)

$SelectRoomListComboID = GUICtrlCreateCombo("", 5, 35, 290, 250)
$SelectRoomListLabelID = GUICtrlCreateLabel("Please Select a Room List to Install", 65, 8, 310, 20)
$InstallButtonID = GUICtrlCreateButton("Install", 30, 80, 100, 30)
$QuitButtonID = GUICtrlCreateButton("Quit", 160, 80, 100, 30)
GUICtrlSetState($InstallButtonID, $GUI_DEFBUTTON)

;load data into file list window
GUICtrlSetData($SelectRoomListComboID, $RoomListSelectionString, "Enter Room Manually")

GUISetState()
While 1 ; process GUI events for room list selection
	$GUImsg = GUIGetMsg()
	Select
		Case $GUImsg = $GUI_EVENT_CLOSE
			Exit
		Case $GUImsg = $InstallButtonID
			$ComboData = GUICtrlRead($SelectRoomListComboID)
			ExitLoop
		Case $GUImsg = $QuitButtonID
			Exit
	EndSelect
WEnd

GUIDelete()

If $ComboData <> "Enter Room Manually" Then ; ie using a room listing
	;extract array number from combo data
	$RoomListArrayNumber = StringSplit($ComboData, ":")
	;extract the room list from the string retrieved from the ini file
	$RoomsToInstallArray = StringSplit($RoomListsArray[$RoomListArrayNumber[1]][1], ",")
	;set the number of rooms to be done
	$NumberofPrintersToInstall = $RoomsToInstallArray[0]
	;generate msgbox string to display printers retrieved
	$DisplayString = "The following rooms will be installed;" & @CRLF & @CRLF & StringReplace($RoomListsArray[$RoomListArrayNumber[1]][1], ',', @CRLF) & @CRLF & @CRLF & "This box will close automatically after 20 seconds"
	MsgBox(0, "Ready to Install", $DisplayString, 20)
	
Else ; ie using manual room selection
	$SpecificRoom = ManualRoomSelection() ; call manual room selection Function
	
EndIf

;start installation loop
While $InstallationCyclesDone < $NumberofPrintersToInstall
	
	$CurrentRoomInInstallList = $InstallationCyclesDone + 1
	;retrieve printer information from the INI file
	If $ComboData <> "Enter Room Manually" Then ; ie installing from room list in ini file
		$WasValidNumberEntered = RetrievePrinterParametersfromINIfile($RoomsToInstallArray[$CurrentRoomInInstallList]);attempt to run printer install using specification on command line
		If $WasValidNumberEntered = "no" Then ; means invalid room designation was given.  Request valid one...
			While $WasValidNumberEntered = "no"
				$RoomNumber = InputBox("Enter Room", "Enter the Room this machine is located in." & @CRLF & "(This information is used to determine which printer to install)", 17);prompt for Room number
				If @error = 1 Then
					MsgBox(0, "Exiting", "Quitting program now")
					Exit
				EndIf
				$WasValidNumberEntered = RetrievePrinterParametersfromINIfile($RoomNumber) ; calles the function containing the printer setup commands
			WEnd
		EndIf
	Else ; ie manual entry was selected
		$WasValidNumberEntered = RetrievePrinterParametersfromINIfile($SpecificRoom) ; calles the function containing the printer setup commands
		; test if valid entry given.  If not...
		While $WasValidNumberEntered = "no"
			$SpecificRoom = ManualRoomSelection()
			$WasValidNumberEntered = RetrievePrinterParametersfromINIfile($SpecificRoom) ; calles the function containing the printer setup commands
		WEnd
	EndIf
	;now we have the information to do the install, proceed...
	;show user something is happening
	SplashTextOn($ScriptID & " Running", "Proceeding to install printer " & $PrinterNameSeenByUser & "...", 300, 150, 100, 100)
	
	;run installation with given parameters
	$Commandline = 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /if /b "' & $PrinterNameSeenByUser & '" /f"' & $InfFileLocation & '" /r "' & $PrinterPort & '" /m "' & $PrinterModelNumberInInfFile & '"'
	Run($Commandline)
	
	;click OK on unsigned driver if required
	$UnsignedDriverAprove = WinWait("Hardware Installation", "has not passed Windows Logo testing", 10) ; if doesn't appear in 10 seconds, assume driver is signed
	If $UnsignedDriverAprove = 1 Then
		Sleep(500)
		WinActivate("Hardware Installation", "has not passed Windows Logo testing")
		Sleep(500)
		ControlClick("Hardware Installation", "has not passed Windows Logo testing", 5303)
		Sleep(500)
	EndIf
	
	;show countdown to delay time expiry
	$Countup = 0
	SplashTextOn($ScriptID & " of " & $PrinterNameSeenByUser & " Paused", "Allowing Installation " & $InstallationCyclesDone + 1 & " of " & $NumberofPrintersToInstall & " to Complete....continuing in " & $PauseTimeSeconds & " Seconds", 400, 150, 100, 100)
	While $Countup < $PauseTimeSeconds
		Sleep(1000)
		$Countup = $Countup + 1
		ControlSetText($ScriptID & " of " & $PrinterNameSeenByUser & " Paused", "", "Static1", "Allowing Installation " & $InstallationCyclesDone + 1 & " of " & $NumberofPrintersToInstall & " to Complete....continuing in  " & $PauseTimeSeconds - $Countup & " Seconds")
	WEnd
	SplashOff()
	
	$InstallationCyclesDone = $InstallationCyclesDone + 1 ; increment cycles counter
WEnd ; keep looping till all requested printers are installed

;audio notification of completion
Beep(4000, 500)
Beep(3000, 500)
Beep(2000, 500)
Beep(1000, 1000)

Exit

;FUNCTIONS

Func RetrievePrinterParametersfromINIfile($RoomNumber)
	$InfFileLocation = $PrinterDriverRepository & "\" & IniRead($ProgIniFileNameAndPath, $RoomNumber, "InfFileLocationInRepository", "*missing value*")
	$PrinterModelNumberInInfFile = IniRead($ProgIniFileNameAndPath, $RoomNumber, "PrinterModelNumberInInfFile", "*missing value*")
	$PrinterPort = IniRead($ProgIniFileNameAndPath, $RoomNumber, "PrinterPort", "*missing value*")
	$PrinterNameSeenByUser = IniRead($ProgIniFileNameAndPath, $RoomNumber, "PrinterNameSeenByUser", "*missing value*")
	;check for quit request
	If $PrinterModelNumberInInfFile = "quit" Then
		MsgBox(0, "Quitting", "No Printers Installed : Exiting")
		Exit
	EndIf
	;check for errors
	If $InfFileLocation = "*missing value*" Or $PrinterModelNumberInInfFile = "*missing value*" Or $PrinterPort = "*missing value*" Or $PrinterNameSeenByUser = "*missing value*" Then
		;read all section names from INI file
		$SupportedRoomsFromINIFile = IniReadSectionNames($ProgIniFileNameAndPath)
		;form supported room list
		$ListOfSupportedRooms = ""
		For $RoomCounter = 3 To $SupportedRoomsFromINIFile[0] ; ie all section names except the first 2 which are [RoomLists] and [global]
			$ListOfSupportedRooms = $ListOfSupportedRooms & ", " & $SupportedRoomsFromINIFile[$RoomCounter]
		Next
		;display supported room list
		MsgBox(0, "Unsupported Room Number", "Entered Room '" & $RoomNumber & "' is not supported, or there was a problem reading its section in the program INI file." & @CRLF & @CRLF & "Please check you have entered a supported room." & @CRLF & @CRLF & "Options are:" & $ListOfSupportedRooms & ".")
		;return error
		Return "no" ; room number was invalid or problem with ini file
	Else
		Return "yes" ; section in ini file found successfully
	EndIf
	
EndFunc   ;==>RetrievePrinterParametersfromINIfile

Func ManualRoomSelection()
	;get list of section names to permit manual selection
	;read all section names from INI file
	$SupportedRoomsFromINIFile = IniReadSectionNames($ProgIniFileNameAndPath)
	;form supported room list
	$ListOfSupportedRooms = $SupportedRoomsFromINIFile[4] ; skip the first 3 which are [RoomLists] and [global] and [quit]
	$ListOfSupportedRooms1stItem = $SupportedRoomsFromINIFile[4]
	For $RoomCounter = 5 To $SupportedRoomsFromINIFile[0] ; the rest of the list
		$ListOfSupportedRooms = $ListOfSupportedRooms & "|" & $SupportedRoomsFromINIFile[$RoomCounter]
	Next
	;display next Selection GUI
	
	$CurrentGUITitle = "Manual Room Selection"
	GUICreate($CurrentGUITitle, 300, 140, (@DesktopWidth - 300) / 2, ((@DesktopHeight - 250) / 2) + 50, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS, $WS_EX_TOPMOST)
	
	$SelectRoomComboID = GUICtrlCreateCombo("", 5, 35, 290, 250)
	$SelectRoomLabelID = GUICtrlCreateLabel("Please Select a Room to Install", 65, 8, 310, 20)
	$InstallButtonID = GUICtrlCreateButton("Install", 30, 80, 100, 30)
	$QuitButtonID = GUICtrlCreateButton("Quit", 160, 80, 100, 30)
	GUICtrlSetState($InstallButtonID, $GUI_DEFBUTTON)
	
	;load data into file list window
	GUICtrlSetData($SelectRoomComboID, $ListOfSupportedRooms, $ListOfSupportedRooms1stItem)
	
	GUISetState()
	While 1 ; process GUI events for room selection
		$GUImsg = GUIGetMsg()
		Select
			Case $GUImsg = $GUI_EVENT_CLOSE
				Exit
			Case $GUImsg = $InstallButtonID
				$ComboSelection = GUICtrlRead($SelectRoomComboID)
				ExitLoop
			Case $GUImsg = $QuitButtonID
				Exit
		EndSelect
	WEnd
	
	GUIDelete()
	
	Return $ComboSelection
EndFunc   ;==>ManualRoomSelection
