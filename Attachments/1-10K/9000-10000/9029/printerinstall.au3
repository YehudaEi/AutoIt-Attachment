;
;the ini file for this program must have the same name and be in the same folder as the exe file

;Includes
#include <GUIConstants.au3>

;Variables Initialisation
$ProgIniFileNameAndPath = StringTrimRight(@ScriptFullPath, 3) & "ini"
$ProgSubApplicationfilename = StringTrimRight(@ScriptName, 4) & "subapp.exe"
$ScriptID = "Printer Install V6.1"
$WasValidNumberEntered = "no"
$PrinterNameSeenByUser = " "
$InfFileLocation = " "
$PrinterPort = " "
$PrinterModelNumberInInfFile = " "
$NumberofPrintersToInstall = 1 ; this is changed later for multiple printer installations
$InstallingFromList = "" ; this is set later
$PrinterToSetAsDefault = "" ; this is set later
$SpecificRoom = ""
$InstallationCyclesDone = 0 ; used to track how many printers have been done
$Headerlinecheck = "OK" ; global def

; check INI exists
$CheckINIExists = FileExists($ProgIniFileNameAndPath)
If $CheckINIExists = 0 Then
	MsgBox(0, "INI Not Found", "Program INI file '" & $ProgIniFileNameAndPath & "' not found - cannot continue")
	Exit
EndIf
; read global section variables from INI file
$PauseTimeSeconds = IniRead($ProgIniFileNameAndPath, "Global", "PauseTime", 50) ; time to wait for printer installation to continue
$PrinterDriverRepository = IniRead($ProgIniFileNameAndPath, "Global", "PrinterDriverRepository", "C:\windows\system32\inf")

; read room lists section from ini file
$RoomListsArray = IniReadSection($ProgIniFileNameAndPath, "RoomLists")
;read all section names (room names) from INI file
$SupportedRoomsFromINIFile = IniReadSectionNames($ProgIniFileNameAndPath)

;call function to check room lists are valid
VerifyIniFile()

;create main selection list for GUI control
;room lists header
$RoomListSelectionString = "                 <--  Room Lists  -->"
;add room lists
$RoomListSelectionStringDefault = "RL1: " & $RoomListsArray[1][0]
For $Listcounter = 1 To $RoomListsArray[0][0]
	$RoomListSelectionString = $RoomListSelectionString & "|" & "RL" & $Listcounter & ": " & $RoomListsArray[$Listcounter][0]
Next
;individual rooms header
$RoomListSelectionString = $RoomListSelectionString & "|             <--  Individual Rooms  -->"
;add individual rooms
For $Counter = 4 To $SupportedRoomsFromINIFile[0]
	$RoomListSelectionString = $RoomListSelectionString & "|" & "IR" & $Counter - 3 & ": " & $SupportedRoomsFromINIFile[$Counter]
Next

;display room list to select GUI
$CurrentGUITitle = $ScriptID
GUICreate($CurrentGUITitle, 600, 400, (@DesktopWidth - 600) / 2, (@DesktopHeight - 400) / 2, $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)

$SelectRoomListListID = GUICtrlCreateList("", 15, 35, 250, 290, BitOR($WS_VSCROLL, $WS_BORDER))
$SelectRoomListLableID = GUICtrlCreateLabel("Select a List or Individual Room to Install", 40, 8, 230, 20)

$SelectDefaultPrinterListID = GUICtrlCreateList("Dummy Data", 335, 35, 250, 290, BitOR($WS_VSCROLL, $WS_BORDER))
$SelectDefaultPrinterLableID = GUICtrlCreateLabel("Select a Printer to Set as Default", 375, 8, 200, 20)

$PrintTestPageCheckboxID = GUICtrlCreateCheckbox("Print Test Page on default printer when done", 350, 315, 300, 20)

$EditINIButtonID = GUICtrlCreateButton("Edit INI File", 30, 355, 100, 30)
$DetailsButtonID = GUICtrlCreateButton("Default Details", 170, 355, 100, 30)
$QuitButtonID = GUICtrlCreateButton("Quit", 320, 355, 100, 30)
$InstallButtonID = GUICtrlCreateButton("Install", 470, 355, 100, 30)
GUICtrlSetState($InstallButtonID, $GUI_DEFBUTTON)

;load data into file list window
GUICtrlSetData($SelectRoomListListID, $RoomListSelectionString, $RoomListSelectionStringDefault)
;set data for default list selection window
SetDefaultPrinterListContents($RoomListSelectionStringDefault)

GUISetState()
While 1 ; process GUI events
	$GUImsg = GUIGetMsg()
	Select
		Case $GUImsg = $GUI_EVENT_CLOSE
			Exit
		Case $GUImsg = $QuitButtonID
			Exit
		Case $GUImsg = $EditINIButtonID
			Run('Notepad.exe "' & $ProgIniFileNameAndPath & '"')
			Exit
		Case $GUImsg = $SelectRoomListListID
			$Headerlinecheck = SetDefaultPrinterListContents(GUICtrlRead($SelectRoomListListID))
			If $Headerlinecheck = "repeat" Then ; call the function again to set the default window correctly if the header row was selected
				SetDefaultPrinterListContents(GUICtrlRead($SelectRoomListListID))
			EndIf
		Case $GUImsg = $SelectDefaultPrinterListID
			If GUICtrlRead($SelectDefaultPrinterListID) = "Make No Changes to Existing Defaults" Then
				GUICtrlSetState($PrintTestPageCheckboxID, $GUI_UNCHECKED)
				GUICtrlSetState($PrintTestPageCheckboxID, $GUI_DISABLE)
			Else
				GUICtrlSetState($PrintTestPageCheckboxID, $GUI_ENABLE)
				GUICtrlSetState($PrintTestPageCheckboxID, $GUI_CHECKED)
			EndIf
		Case $GUImsg = $InstallButtonID
			$RawInstallListBoxData = GUICtrlRead($SelectRoomListListID)
			$RawDefaultPrinterListBoxData = GUICtrlRead($SelectDefaultPrinterListID)
			If $RawDefaultPrinterListBoxData <> "Make No Changes to Existing Defaults" Then ; ie default setting requested
				$DefaultPrinterRawDataArray = StringSplit($RawDefaultPrinterListBoxData, "-")
				$PrinterToSetAsDefault = RetrieveDefaultPrinterNamefromINIfile(StringTrimRight($DefaultPrinterRawDataArray[1], 1))
			EndIf
			If GUICtrlRead($PrintTestPageCheckboxID) = $GUI_CHECKED Then
				$PrintTestPage = 'yes'
			Else
				$PrintTestPage = 'no'
			EndIf
			ExitLoop
		Case $GUImsg = $DetailsButtonID
			$RawDefaultPrinterListBoxData = GUICtrlRead($SelectDefaultPrinterListID)
			If $RawDefaultPrinterListBoxData = "Make No Changes to Existing Defaults" Then 
				MsgBox (0,"Nothing Selected","There is no Default Printer Selected")
			Else
				$DefaultPrinterRawDataArray = StringSplit($RawDefaultPrinterListBoxData, "-")
				$PrinterKeyName = StringTrimRight($DefaultPrinterRawDataArray[1], 1)
				RetrievePrinterParametersfromINIfile($PrinterKeyName)
				$StringTodisplay = "Details for Default Printer '" & $PrinterKeyName  & "'"& @CRLF & @CRLF & "INF File Location -> " & $InfFileLocation & @CRLF & "Model Number in INF File -> " & $PrinterModelNumberInInfFile & @CRLF & "Port -> " & $PrinterPort & @CRLF & "Name seen by Users -> " & $PrinterNameSeenByUser
				MsgBox (8192,"Default Printer Details",$StringTodisplay)
			EndIf
		EndSelect
WEnd

GUIDelete()

If $InstallingFromList = "yes" Then ; ie using a room listing
	;extract array number from list box raw data
	$RoomListKeyNameArray = StringSplit($RawInstallListBoxData, ":")
	$RoomListArrayNumber = StringTrimLeft($RoomListKeyNameArray[1], 2)
	;extract the room list from the string retrieved from the ini file
	$RoomsToInstallArray = StringSplit($RoomListsArray[$RoomListArrayNumber][1], ",")
Else
	;ie doing individual room
	;extract room number from list box raw data
	$RoomListKeyNameArray = StringSplit($RawInstallListBoxData, ":")
	$SpecificRoom = $RoomListKeyNameArray[2]
EndIf

;run subapplication to watch for unsigned drivers
$SubAppPID = Run(@ScriptDir & "\" & $ProgSubApplicationfilename)

;start installation loop
While $InstallationCyclesDone < $NumberofPrintersToInstall
	
	$CurrentRoomInInstallList = $InstallationCyclesDone + 1
	;retrieve printer information from the INI file
	If $InstallingFromList = "yes" Then ; ie installing from room list in ini file
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
	SplashTextOn($ScriptID & " Running", "Proceeding to install printer " & $PrinterNameSeenByUser & "...", 450, 100, 150, 50)
	
	;run installation with given parameters
	$Commandline = 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /if /b "' & $PrinterNameSeenByUser & '" /f"' & $InfFileLocation & '" /r "' & $PrinterPort & '" /m "' & $PrinterModelNumberInInfFile & '"'
	RunWait($Commandline)
	
	If $InstallingFromList = "yes" Then ; ie doing automated installation
		;show countdown to delay time expiry
		$Countup = 0
		SplashTextOn($ScriptID & " of " & $PrinterNameSeenByUser & " Paused", "Allowing Installation " & $InstallationCyclesDone + 1 & " of " & $NumberofPrintersToInstall & " to Complete....continuing in " & $PauseTimeSeconds & " Seconds", 450, 100, 150, 50)
		While $Countup < $PauseTimeSeconds
			Sleep(1000)
			$Countup = $Countup + 1
			ControlSetText($ScriptID & " of " & $PrinterNameSeenByUser & " Paused", "", "Static1", "Allowing Installation " & $InstallationCyclesDone + 1 & " of " & $NumberofPrintersToInstall & " to Complete....continuing in  " & $PauseTimeSeconds - $Countup & " Seconds")
		WEnd
		SplashOff()
	Else ; ie doing single installation
		SplashOff()
	EndIf
	
	$InstallationCyclesDone = $InstallationCyclesDone + 1 ; increment cycles counter
WEnd ; keep looping till all requested printers are installed

;Kill SubApp process
ProcessClose($SubAppPID)

;run default printer setting if required
If $PrinterToSetAsDefault <> "" Then
	SplashTextOn($ScriptID & " Running", "Setting '" & $PrinterToSetAsDefault & "' as Default Printer...", 450, 100, 150, 50)
	;run setting commands
	$Commandline = 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /y /n "' & $PrinterToSetAsDefault & '"'
	RunWait($Commandline)
EndIf

;send test page if requested
If $PrintTestPage = "yes" Then
	SplashTextOn($ScriptID & " Running", "Sending Test Page to '" & $PrinterToSetAsDefault & "'...", 450, 100, 150, 50)
	Sleep(2000)
	$Commandline = 'RUNDLL32 PRINTUI.DLL,PrintUIEntry /k /n "' & $PrinterToSetAsDefault & '"'
	Run($Commandline)
EndIf

SplashOff()

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

Func RetrieveDefaultPrinterNamefromINIfile($RoomNumber)
	$PrinterNameToSetAsDefault = IniRead($ProgIniFileNameAndPath, $RoomNumber, "PrinterNameSeenByUser", "*missing value*")
	;check for valid read
	If $PrinterModelNumberInInfFile = "*missing value*" Then
		MsgBox(0, "Quitting", "Problem with INI file : cannot retrieve printer name for default printer : Exiting")
		Exit
	EndIf
	Return $PrinterNameToSetAsDefault
EndFunc   ;==>RetrieveDefaultPrinterNamefromINIfile

Func ManualRoomSelection()
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

Func VerifyIniFile()
	;the purpose of this function is to check that the room lists contain only supported rooms
	SplashTextOn("Verification", "Verifying INI File....", 450, 100, 150, 50)
	
	;test for illegal starts on room lists
	For $Roomlist = 1 To $RoomListsArray[0][0] ; ie for each roomlist in the section
		If StringLeft($RoomListsArray[$Roomlist][0], 2) = "RL" Then
			SplashOff()
			MsgBox(0, "Illegal Room List Name", "Room List Name '" & $RoomListsArray[$Roomlist][0] & "' is illegal as it startes with the characters 'RL'." & @CRLF & @CRLF & "Installation cannot proceed until this is fixed.  The INI file will now be opened.  Rename this room list and try again")
			Run('Notepad.exe "' & $ProgIniFileNameAndPath & '"')
			Exit
		EndIf
		If StringLeft($RoomListsArray[$Roomlist][0], 2) = "IR" Then
			SplashOff()
			MsgBox(0, "Illegal Room List Name", "Room List Name '" & $RoomListsArray[$Roomlist][0] & "' is illegal as it startes with the characters 'IR'." & @CRLF & @CRLF & "Installation cannot proceed until this is fixed.  The INI file will now be opened.  Rename this room list and try again")
			Run('Notepad.exe "' & $ProgIniFileNameAndPath & '"')
			Exit
		EndIf
	Next
	
	;test for illegal starts on room names
	For $SupportedRooms = 1 To $SupportedRoomsFromINIFile [0] ; ie for each room in the ini file
		If StringLeft($SupportedRoomsFromINIFile [$SupportedRooms], 2) = "RL" Then
			SplashOff()
			MsgBox(0, "Illegal Room Name", "Room Name '" & $SupportedRoomsFromINIFile [$SupportedRooms] & "' is illegal as it startes with the characters 'RL'." & @CRLF & @CRLF & "Installation cannot proceed until this is fixed.  The INI file will now be opened.  Rename this room and try again")
			Run('Notepad.exe "' & $ProgIniFileNameAndPath & '"')
			Exit
		EndIf
		If StringLeft($SupportedRoomsFromINIFile [$SupportedRooms], 2) = "IR" Then
			SplashOff()
			MsgBox(0, "Illegal Room Name", "Room Name '" & $SupportedRoomsFromINIFile [$SupportedRooms] & "' is illegal as it startes with the characters 'IR'." & @CRLF & @CRLF & "Installation cannot proceed until this is fixed.  The INI file will now be opened.  Rename this room and try again")
			Run('Notepad.exe "' & $ProgIniFileNameAndPath & '"')
			Exit
		EndIf
	Next
	
	; test for rooms in lists which don't have a corresponding secrion
	$IniFileErrorListingString = ""
	$IniFileErrorCounter = 0
	
	For $Roomlist = 1 To $RoomListsArray[0][0] ; ie for each roomlist in the section
		$RoomsInThisListArray = StringSplit($RoomListsArray[$Roomlist][1], ",")
		;check each room against supported list
		For $RoomCounter2 = 1 To $RoomsInThisListArray[0]
			;cycle through supported list
			$MatchFound = 0 ; set match flag
			;testing....
			For $SupportedRooms = 1 To $SupportedRoomsFromINIFile [0]
				If $RoomsInThisListArray[$RoomCounter2] = $SupportedRoomsFromINIFile[$SupportedRooms] Then
					$MatchFound = 1
					ExitLoop
				EndIf
			Next
			If $MatchFound = 0 Then ; room unsupported
				;add details to ini file error listing
				$IniFileErrorCounter = $IniFileErrorCounter + 1
				If $IniFileErrorCounter = 1 Then ; ie initial entry
					$IniFileErrorListingString = "Errors Found in INI File Room Lists!" & @CRLF & @CRLF & "Room List '" & $RoomListsArray[$Roomlist][0] & "' contains unsupported room '" & $RoomsInThisListArray[$RoomCounter2] & "'"
				Else
					$IniFileErrorListingString = $IniFileErrorListingString & @CRLF & "Room List '" & $RoomListsArray[$Roomlist][0] & "' contains unsupported room '" & $RoomsInThisListArray[$RoomCounter2] & "'"
				EndIf
			EndIf
		Next
	Next
	SplashOff()
	If $IniFileErrorListingString <> "" Then ; ie errors were found - display result
		$Continue = MsgBox(1, "INI File Error", $IniFileErrorListingString & @CRLF & @CRLF & "Continue Anyway?")
		If $Continue = 2 Then
			MsgBox(0, "Please Fix INI File", "To correct this error, please ensure that all room designations in the room lists have a corresponding section in the INI file.")
			Exit ; ie quit selected
		EndIf
		$ListOfSupportedRooms = ""
		For $RoomCounter = 3 To $SupportedRoomsFromINIFile[0] ; ie all section names except the first 2 which are [RoomLists] and [global]
			$ListOfSupportedRooms = $ListOfSupportedRooms & ", " & $SupportedRoomsFromINIFile[$RoomCounter]
		Next
		;display supported room list with warning
		MsgBox(0, "Warning", "If you select one of the room lists containing unsupported rooms, the script will stop and request a corrected room number when that room is reached during installation." & @CRLF & @CRLF & "The Supported Rooms are:" & $ListOfSupportedRooms & ".")
		
	EndIf
	
EndFunc   ;==>VerifyIniFile

Func SetDefaultPrinterListContents($SelectListBoxCurrentData)
	If StringLeft($SelectListBoxCurrentData, 2) = "  " Then ; reset to default if user tries to select header lines
		GUICtrlSetData($SelectRoomListListID, $RoomListSelectionStringDefault)
		Return "repeat"
	EndIf
	;case of individual printer installation
	If StringLeft($SelectListBoxCurrentData, 2) = "IR" Then
		$InstallingFromList = "no"
		$NumberofPrintersToInstall = 1
		$PrinterSectionNameArray = StringSplit($SelectListBoxCurrentData, ":")
		$PrinterSectionName = StringTrimLeft ($PrinterSectionNameArray[2],1)
		$SelectDefaultPrinterListBoxData = "|Make No Changes to Existing Defaults|" & $PrinterSectionName & " --> " & IniRead($ProgIniFileNameAndPath, $PrinterSectionName, "PrinterNameSeenByUser", "*missing value*")
		$SelectDefaultPrinterListBoxDataDefault = $PrinterSectionName & " --> " & IniRead($ProgIniFileNameAndPath, $PrinterSectionName, "PrinterNameSeenByUser", "*missing value*")
		GUICtrlSetData($SelectDefaultPrinterListID, $SelectDefaultPrinterListBoxData, $SelectDefaultPrinterListBoxDataDefault)
	EndIf
	;case of multiple printer installations
	If StringLeft($SelectListBoxCurrentData, 2) = "RL" Then
		$InstallingFromList = "yes"
		$ListKeyNameArray = StringSplit($SelectListBoxCurrentData, ":")
		$ListKeyName = $ListKeyNameArray[2]
		$RoomsInThisListArray = StringSplit(IniRead($ProgIniFileNameAndPath, "RoomLists", $ListKeyName, "*Missing Value*"), ",")
		$NumberofPrintersToInstall = $RoomsInThisListArray[0]
		$SelectDefaultPrinterListBoxData = "|Make No Changes to Existing Defaults"
		$SelectDefaultPrinterListBoxDataDefault = $RoomsInThisListArray[1] & " --> " & IniRead($ProgIniFileNameAndPath, $RoomsInThisListArray[1], "PrinterNameSeenByUser", "*missing value*")
		For $Counter = 1 To $RoomsInThisListArray[0]
			$SelectDefaultPrinterListBoxData = $SelectDefaultPrinterListBoxData & "|" & $RoomsInThisListArray[$Counter] & " --> " & IniRead($ProgIniFileNameAndPath, $RoomsInThisListArray[$Counter], "PrinterNameSeenByUser", "*missing value*")
		Next
		GUICtrlSetData($SelectDefaultPrinterListID, $SelectDefaultPrinterListBoxData, $SelectDefaultPrinterListBoxDataDefault)
	EndIf
	GUICtrlSetState($PrintTestPageCheckboxID, $GUI_ENABLE)
	GUICtrlSetState($PrintTestPageCheckboxID, $GUI_CHECKED)
EndFunc   ;==>SetDefaultPrinterListContents


