#NoTrayIcon
#region
#AutoIt3Wrapper_icon=Icon.ico
#AutoIt3Wrapper_compression=0
#AutoIt3Wrapper_useupx=n
#endregion
Opt("GUIResizeMode", 802)
Global Const $GUI_CHECKED = 1
Global Const $GUI_DISABLE = 128
Global Const $GUI_ENABLE = 64
Global Const $GUI_SHOW = 16
Global Const $GUI_HIDE = 32
Global $PARAMS[4]
For $I = 0 To 3
	$PARAMS[$I] = False
Next
If $CMDLINE[0] > 0 Then
	For $I = 1 To $CMDLINE[0]
		If StringInStr($CMDLINE[$I], "/About") Then
			$PARAMS[0] = True
		EndIf
		If StringInStr($CMDLINE[$I], "/Default") Then
			$PARAMS[1] = True
		EndIf
		If StringInStr($CMDLINE[$I], "/Advanced") Then
			$PARAMS[2] = True
		EndIf
		If StringInStr($CMDLINE[$I], "/drive:") Then
			$PARAMS[3] = StringTrimLeft($CMDLINE[$I], 7) & ":"
			$PARAMS[1] = True
		EndIf
	Next
EndIf
$COMMANDS = ""
#region
If $PARAMS[0] == False Then
	$GUI = GUICreate("Check Disk", 200, 200, -1, -1, -2067267584)
	$GUICONTEXT = GUICtrlCreateContextMenu()
	$GUIGO = GUICtrlCreateMenuItem("Run", $GUICONTEXT)
	GUICtrlSetTip(-1, "Execute the selected operation")
	$GUIADVANCED = GUICtrlCreateMenuItem("Advanced Settings", $GUICONTEXT)
	GUICtrlSetTip(-1, "Show Advanced Options")
	$GUIABOUT = GUICtrlCreateMenuItem("About", $GUICONTEXT)
	GUICtrlSetTip(-1, "Show Program Information")
	GUICtrlCreateMenuItem("", $GUICONTEXT)
	$GUIEXIT = GUICtrlCreateMenuItem("Exit", $GUICONTEXT)
	GUISetHelp("cmd.exe /K " & Chr(34) & "chkdsk /?" & Chr(34))
	$DRIVE = -1
	For $I = Asc("A") To Asc("Z")
		If FileExists(Chr($I) & ":") Then
			If $DRIVE > 0 Then
				GUICtrlSetData($DRIVE, Chr($I) & ":")
			Else
				$DRIVE = GUICtrlCreateCombo(Chr($I) & ":", 5, 5, 190)
				GUICtrlSetTip(-1, "Drive to Check")
				$LOCATION = GUICtrlCreateInput(Chr($I) & ":", 5, 5, 160)
				GUICtrlSetState(-1, $GUI_HIDE)
				$BROWSE = GUICtrlCreateIcon("shell32.dll", 5, 170, 7, 16, 16)
				GUICtrlSetState(-1, $GUI_HIDE)
			EndIf
		EndIf
	Next
	$FIX = GUICtrlCreateCheckbox("Fix Errors", 5, 35)
	GUICtrlSetTip(-1, "Fixes errors on the disk")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$SECTORS = GUICtrlCreateCheckbox("Fix Bad Sectors", 15, 55)
	GUICtrlSetTip(-1, "Locates bad sectors and recovers readable information")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$DISMOUNT = GUICtrlCreateCheckbox("Force Volume Dismount", 15, 75)
	GUICtrlSetTip(-1, "Forces volume dismount if necicary" & @CRLF & "NTFS only")
	$MESSAGE = GUICtrlCreateCheckbox("Display Messages", 5, 95)
	GUICtrlSetTip(-1, "NTFS:Displays Cleanup Messages if any" & @CRLF & "FAT/FAT32:Display all files and folders on disk")
	GUICtrlSetState(-1, $GUI_CHECKED)
	$INDEXES = GUICtrlCreateCheckbox("Incomplete Index check", 5, 115)
	GUICtrlSetTip(-1, "Performs less-vigorous check of index entries" & @CRLF & "NTFS only")
	$CYCLES = GUICtrlCreateCheckbox("Skip cycle checking", 5, 135)
	GUICtrlSetTip(-1, "Skips checking of cycles within the folder structure" & @CRLF & "NTFS only")
	$GO = GUICtrlCreateButton("Run", 100, 165, 95, 25, 1)
	GUICtrlSetTip(-1, "Execute the selected operation")
	$ADVANCED = GUICtrlCreateIcon("shell32.dll", 274, 2, 180, 16, 16)
	GUICtrlSetTip(-1, "Show Advanced Options")
	$ABOUT = GUICtrlCreateIcon("shell32.dll", 24, 20, 180, 16, 16)
	GUICtrlSetTip(-1, "Show Program Information")
	$LOGFILE = GUICtrlCreateCheckbox("Show Logfile Size", 5, 155)
	GUICtrlSetTip(-1, "Display the size of the logfile" & @CRLF & "NTFS only")
	GUICtrlSetState(-1, $GUI_HIDE)
	$RESIZE = GUICtrlCreateCheckbox("Resize Logfile", 15, 175)
	GUICtrlSetTip(-1, "Change the size of the logfile" & @CRLF & "NTFS only")
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$SIZE = GUICtrlCreateInput("1", 32, 200, 100)
	GUICtrlSetTip(-1, "New size for the logfile in KB" & @CRLF & "NTFS only")
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetLimit(-1, 100000, 0)
	$SIZEUPDOWN = GUICtrlCreateUpdown($SIZE)
	GUICtrlSetLimit(-1, 100000, 0)
	GUICtrlSetTip(-1, "New size for the logfile in KB" & @CRLF & "NTFS only")
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$SIZELABEL = GUICtrlCreateLabel("KB", 140, 204)
	GUICtrlSetState(-1, $GUI_HIDE)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$FILEFOLDER = GUICtrlCreateCheckbox("Check File or Folder", 5, 230)
	GUICtrlSetTip(-1, "Check a File or Folder instead of a Drive" & @CRLF & "FAT only")
	$FILE = GUICtrlCreateRadio("File", 32, 250)
	GUICtrlSetTip(-1, "Check a File instead of a Drive" & @CRLF & "FAT only")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$FOLDER = GUICtrlCreateRadio("Folder", 32, 270)
	GUICtrlSetTip(-1, "Check a Folder instead of a Drive" & @CRLF & "FAT only")
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetState(-1, $GUI_CHECKED)
	If $PARAMS[1] == False Then
		GUISetState()
	Else
		GO()
		Exit
	EndIf
Else
	$GUI = -1
EndIf
#endregion
#region
$ABOUTGUI = GUICreate("About", 250, 100, -1, -1, -2067267584)
GUISetIcon("shell32.dll", 24, $ABOUTGUI)
GUICtrlCreateIcon(@ScriptName, 0, 10, 10, 32, 32)
GUICtrlCreateLabel("Check Disk GUI", 50, 5, 190)
GUICtrlSetFont(-1, 11, 800)
GUICtrlCreateLabel("Version: 1.2", 60, 25)
GUICtrlCreateLabel("Written By: Matthew McMullan", 5, 50, 240)
GUICtrlSetFont(-1, 11, 800)
GUICtrlCreateLabel("Contact: NerdFencer@Gmail.com", 10, 70)
If $PARAMS[0] == True Then
	GUISetState()
EndIf
#endregion
If $PARAMS[2] == True Then
	MAINMSG($ADVANCED)
EndIf
While 1
	$MSG = GUIGetMsg(1)
	If $MSG[1] == $GUI Then
		MAINMSG($MSG[0])
	Else
		ABOUTMSG($MSG[0])
	EndIf
WEnd

Func COMMANDADD($CONTROL, $COMMAND)
	If GUICtrlRead($CONTROL) == $GUI_CHECKED Then
		$COMMANDS = $COMMANDS & $COMMAND
	EndIf
EndFunc


Func GO($STAYOPEN = True)
	Local $COMMAND = "cmd.exe /K "
	If $STAYOPEN == False Then
		$COMMAND = "cmd.exe "
	EndIf
	$COMMANDS = ""
	COMMANDADD($FIX, " /F")
	COMMANDADD($MESSAGE, " /V")
	If GUICtrlRead($FIX) == $GUI_CHECKED Then
		COMMANDADD($SECTORS, " /R")
		COMMANDADD($DISMOUNT, " /X")
	EndIf
	COMMANDADD($INDEXES, " /I")
	COMMANDADD($CYCLES, " /C")
	COMMANDADD($LOGFILE, " /L")
	If GUICtrlRead($RESIZE) == $GUI_CHECKED Then
		$COMMANDS = $COMMANDS & ":" & GUICtrlRead($SIZE)
	EndIf
	If $PARAMS[3] == False Then
		If GUICtrlRead($FILEFOLDER) == $GUI_CHECKED Then
			Run($COMMAND & Chr(34) & "chkdsk " & GUICtrlRead($LOCATION) & $COMMANDS & Chr(34))
		Else
			Run($COMMAND & Chr(34) & "chkdsk " & GUICtrlRead($DRIVE) & $COMMANDS & Chr(34))
		EndIf
	Else
		Run($COMMAND & Chr(34) & "chkdsk " & $PARAMS[3] & $COMMANDS & Chr(34))
	EndIf
EndFunc


Func ABOUTMSG($MSG)
	Switch $MSG
		Case - 3
			If $PARAMS[0] == False Then
				GUISetState(@SW_HIDE, $ABOUTGUI)
			Else
				Exit
			EndIf
	EndSwitch
EndFunc


Func MAINMSG($MSG)
	Switch $MSG
		Case - 3
			Exit
		Case $GUIEXIT
			Exit
		Case $FIX
			If GUICtrlRead($FIX) == $GUI_CHECKED Then
				GUICtrlSetState($SECTORS, $GUI_ENABLE)
				GUICtrlSetState($DISMOUNT, $GUI_ENABLE)
			Else
				GUICtrlSetState($SECTORS, $GUI_DISABLE)
				GUICtrlSetState($DISMOUNT, $GUI_DISABLE)
			EndIf
		Case $GO
			GO()
			Exit
		Case $GUIGO
			GO()
			Exit
		Case $GUIADVANCED
			MAINMSG($ADVANCED)
		Case $ADVANCED
			$TEMP = WinGetPos("Check Disk")
			If $TEMP[3] <= 250 Then
				WinMove("Check Disk", "", $TEMP[0], $TEMP[1], 206, 360)
				GUICtrlSetPos($ADVANCED, 2, 310)
				GUICtrlSetPos($ABOUT, 20, 310)
				GUICtrlSetPos($GO, 100, 295)
				GUICtrlSetState($LOGFILE, $GUI_SHOW)
				GUICtrlSetState($RESIZE, $GUI_SHOW)
				GUICtrlSetState($SIZE, $GUI_SHOW)
				GUICtrlSetState($SIZEUPDOWN, $GUI_SHOW)
				GUICtrlSetState($SIZELABEL, $GUI_SHOW)
				GUICtrlSetTip($ADVANCED, "Hide Advanced Options")
			Else
				WinMove("Check Disk", "", $TEMP[0], $TEMP[1], 206, 232)
				GUICtrlSetPos($ADVANCED, 2, 180)
				GUICtrlSetPos($ABOUT, 20, 180)
				GUICtrlSetPos($GO, 100, 165)
				GUICtrlSetState($LOGFILE, $GUI_HIDE)
				GUICtrlSetState($RESIZE, $GUI_HIDE)
				GUICtrlSetState($SIZE, $GUI_HIDE)
				GUICtrlSetState($SIZEUPDOWN, $GUI_HIDE)
				GUICtrlSetState($SIZELABEL, $GUI_HIDE)
				GUICtrlSetTip($ADVANCED, "Show Advanced Options")
			EndIf
		Case $LOGFILE
			If GUICtrlRead($LOGFILE) == $GUI_CHECKED Then
				GUICtrlSetState($RESIZE, $GUI_ENABLE)
				If GUICtrlRead($RESIZE) == $GUI_CHECKED Then
					GUICtrlSetState($SIZE, $GUI_ENABLE)
					GUICtrlSetState($SIZEUPDOWN, $GUI_ENABLE)
					GUICtrlSetState($SIZELABEL, $GUI_ENABLE)
				EndIf
			Else
				GUICtrlSetState($RESIZE, $GUI_DISABLE)
				GUICtrlSetState($SIZE, $GUI_DISABLE)
				GUICtrlSetState($SIZEUPDOWN, $GUI_DISABLE)
				GUICtrlSetState($SIZELABEL, $GUI_DISABLE)
			EndIf
		Case $RESIZE
			If GUICtrlRead($RESIZE) == $GUI_CHECKED Then
				GUICtrlSetState($SIZE, $GUI_ENABLE)
				GUICtrlSetState($SIZEUPDOWN, $GUI_ENABLE)
				GUICtrlSetState($SIZELABEL, $GUI_ENABLE)
			Else
				GUICtrlSetState($SIZE, $GUI_DISABLE)
				GUICtrlSetState($SIZEUPDOWN, $GUI_DISABLE)
				GUICtrlSetState($SIZELABEL, $GUI_DISABLE)
			EndIf
		Case $FILEFOLDER
			If GUICtrlRead($FILEFOLDER) == $GUI_CHECKED Then
				GUICtrlSetState($FILE, $GUI_ENABLE)
				GUICtrlSetState($FOLDER, $GUI_ENABLE)
				GUICtrlSetState($DRIVE, $GUI_HIDE)
				GUICtrlSetState($LOCATION, $GUI_SHOW)
				GUICtrlSetState($BROWSE, $GUI_SHOW)
			Else
				GUICtrlSetState($FILE, $GUI_DISABLE)
				GUICtrlSetState($FOLDER, $GUI_DISABLE)
				GUICtrlSetState($DRIVE, $GUI_SHOW)
				GUICtrlSetState($LOCATION, $GUI_HIDE)
				GUICtrlSetState($BROWSE, $GUI_HIDE)
			EndIf
		Case $BROWSE
			If BitAND(GUICtrlRead($FILE), $GUI_CHECKED) == $GUI_CHECKED Then
				$TEMP = FileOpenDialog("Browse", GUICtrlRead($LOCATION), "All (*.*)", 3)
				If Not (@error) Then
					GUICtrlSetData($LOCATION, $TEMP)
				EndIf
			Else
				$TEMP = FileSelectFolder("Browse", GUICtrlRead($DRIVE))
				If Not (@error) Then
					GUICtrlSetData($LOCATION & "\", $TEMP)
				EndIf
			EndIf
		Case $ABOUT
			GUISetState(@SW_SHOW, $ABOUTGUI)
		Case $GUIABOUT
			GUISetState(@SW_SHOW, $ABOUTGUI)
	EndSwitch
EndFunc