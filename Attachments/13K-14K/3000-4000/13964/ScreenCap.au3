Opt("GUIOnEventMode", 1)
Opt("GUICloseOnESC", 0)
Opt("TrayAutoPause", 0)
Opt("TrayOnEventMode",1)
Opt("TrayMenuMode",1)
#include "Misc.au3"
#include <GUIConstants.au3>

;Ensure just one occurance is launched at a time
_Singleton("ScreenCap")

;Ensure they have the .dll file on their system
FileInstall("captdll.dll", @ScriptDir & "\captdll.dll", 0)

Dim $hotkeyRange, $HotKeyAll, $HotKeyActive, $sFolder, $inptFileName, $radioJPG, $radioBMP
Dim $inptQuality, $lblQuality, $chkClip, $SaveFile, $hRegionGUI, $hStartGUI, $StartPOS, $hArea

$sTempFile = @TempDir & "\~RegionGrab.jpg"


;Retrieve the settings from the registry
$sHotKey1 = RegRead("HKCU\Software\ScreenCap", "HotKeyRegion")
$sHotKey2 =	RegRead("HKCU\Software\ScreenCap", "HotKeyAll")
$sHotKey3 =	RegRead("HKCU\Software\ScreenCap", "HotKeyActive")
$SaveDir = RegRead("HKCU\Software\ScreenCap", "SaveTo")
$SaveName = RegRead("HKCU\Software\ScreenCap", "SaveAs")
$iQuality = RegRead("HKCU\Software\ScreenCap", "Quality")
$iClipboard = RegRead("HKCU\Software\ScreenCap", "Clipboard")
;If missing key items, launch the Setup screen
if $SaveDir = "" or $SaveName = "" Then _StartingPrompt()

;Set any hotkeys that have been specified
if $sHotKey1 <> "" Then HotKeySet("{" & $sHotKey1 & "}", "_Region")
if $sHotKey2 <> "" Then HotKeySet("{" & $sHotKey2 & "}", "_All")
if $sHotKey3 <> "" Then HotKeySet("{" & $sHotKey3 & "}", "_Active")

;Setup the custom Trayitem
TraySetClick(16)
$trayAbout = TrayCreateItem("About ScreenCap")
TrayItemSetOnEvent(-1, "_HelpAbout")
$traySetup = TrayCreateItem("Setup (Restart Required)")
TrayItemSetOnEvent(-1, "_StartingPrompt")
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "_CloseMe")
TraySetState()

;Release unused Memory
_ReduceMemory()

;Wait until a hotkey is selected
While 1
	sleep(10)
WEnd


;===========================================================
; Reduce memory usage
; Author wOuter ( mostly )
;===========================================================
Func _ReduceMemory($i_PID = -1)
    If $i_PID <> -1 Then
        Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
        DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
    Else
        Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
    EndIf
    Return $ai_Return[0]
EndFunc;==> _ReduceMemory()



;===================================================================================
;===================================================================================
;	Functions used for the Screen Captures
;===================================================================================
;===================================================================================

Func _All()
;Identify the file name to save as
	if $iQuality = -1 Then
		$sImageExt = ".bmp"
	Else
		$sImageExt = ".jpg"
	EndIf
	for $i = 1 to 254
		$SaveFile = $SaveDir & "\" & $SaveName & $i & $sImageExt
		if Not FileExists($SaveFile) Then ExitLoop
	Next
;Perform the Full Screen Capture
	DllCall("captdll.dll", "int:cdecl", "CaptureScreen", "str", $SaveFile, "int", $iQuality)
;Send to clipboard if requested
	if $iClipboard = 1 Then 
		;;;
	EndIf
;Finished box
	MsgBox(0, "Finished", "Screen capture saved as " & $SaveFile)
;Release unused Memory
	_ReduceMemory()
EndFunc

;===========================================================
;	Performs a Screen Capture of only the active Window
;===========================================================
Func _Active()
;Identify the file name to save as
	if $iQuality = -1 Then
		$sImageExt = ".bmp"
	Else
		$sImageExt = ".jpg"
	EndIf
	for $i = 1 to 254
		$SaveFile = $SaveDir & "\" & $SaveName & $i & $sImageExt
		if Not FileExists($SaveFile) Then ExitLoop
	Next
;Identify the Active Window
	$sActiveWin = WinGetTitle("")
;Get the Coords & Size of the Active Window
	$aWinPos = WinGetPos($sActiveWin, "")
;Perform a capture of the Active Window
	DllCall("captdll.dll", "int:cdecl", "CaptureRegion", "str", $SaveFile, "int", $aWinPos[0], "int", $aWinPos[1], "int", $aWinPos[2], "int", $aWinPos[3], "int", $iQuality)
;Finished box
	MsgBox(0, "Finished", "Active Window capture saved as " & $SaveFile)
;Release unused Memory
	_ReduceMemory()
EndFunc


;===========================================================
;	Setup for the Region Capture
;		Performs a Screen Cap of the entire Desktop then
;		displays that in a full screen GUI
;		The end user may then select the portion of that
;		screen that they want
;===========================================================
Func _Region()
HotKeySet("{" & $sHotKey1 & "}")
;Identify the file name to save as
	if $iQuality = -1 Then
		$sImageExt = ".bmp"
	Else
		$sImageExt = ".jpg"
	EndIf
	for $i = 1 to 254
		$SaveFile = $SaveDir & "\" & $SaveName & $i & $sImageExt
		if Not FileExists($SaveFile) Then ExitLoop
	Next
;Create the full screen capture	
	DllCall("captdll.dll", "int:cdecl", "CaptureScreen", "str", $sTempFile, "int", -1)
;Create the GUI to display that Full Screen Capture
	$hRegionGUI = GUICreate("", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP); ,$WS_EX_TOPMOST)
	GUICtrlCreatePic($sTempFile, 0, 0, @DesktopWidth, @DesktopHeight)
	GUISetOnEvent($GUI_EVENT_PRIMARYDOWN, "_StartPOS")
	GUISetOnEvent($GUI_EVENT_PRIMARYUP, "_EndPOS")
	GUISetState(@SW_SHOW)
;Set the Cursor as a Cross
	GUISetCursor(3, 1, $hRegionGUI)
	While 1
; Wait until the user clicks down to create the group box
		if $hArea <> "" Then
		GUICtrlSetState($hArea, $GUI_SHOW)
		;Get the interim location of the mouse
			$intermPOS = MouseGetPos()
		;Identify the Width of the selected area
			if $intermPOS[0] > $StartPOS[0] Then
				$iWidth = $intermPOS[0] - $StartPOS[0]
				$iX = $StartPOS[0]
			Else
				$iWidth = $StartPOS[0] - $intermPOS[0]
				$iX = $intermPOS[0]
			EndIf
		;Identify the Height of the selected area
			if $intermPOS[1] > $StartPOS[1] Then
				$iHeight = $intermPOS[1] - $StartPOS[1]
				$iY = $StartPOS[1]
			Else
				$iHeight = $StartPOS[1] - $intermPOS[1]
				$iY = $intermPOS[1]
			EndIf
		;Resize the group control to show where you will be performing the screencap
			GUICtrlSetPos($hArea, $iX-1, $iY-1, $iWidth+2, $iHeight+2)
		EndIf
	sleep(100)
	WEnd
EndFunc


;===========================================================
;	Tracks the starting Coords for the Region Capture
;===========================================================
Func _StartPOS()
;The Coords where the user performed a MouseDown
	$StartPOS = MouseGetPos()
	$hArea = GUICtrlCreateLabel("", 0, 0, 1, 1, $SS_GRAYFRAME)
	GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
	GUICtrlSetState($hArea, $GUI_HIDE)
EndFunc


;===========================================================
;	Detects the end Coords required for the Region Capture
;		Also, processess the Region Capture
;===========================================================
Func _EndPOS()
;The Coords where the user performed a MouseUp
	$EndPOS = MouseGetPos()
;Identify the Width of the selected area
	if $EndPOS[0] > $StartPOS[0] Then
		$iWidth = $EndPOS[0] - $StartPOS[0]
		$iX = $StartPOS[0]
	Else
		$iWidth = $StartPOS[0] - $EndPOS[0]
		$iX = $EndPOS[0]
	EndIf
;Identify the Height of the selected area
	if $EndPOS[1] > $StartPOS[1] Then
		$iHeight = $EndPOS[1] - $StartPOS[1]
		$iY = $StartPOS[1]
	Else
		$iHeight = $StartPOS[1] - $EndPOS[1]
		$iY = $EndPOS[1]
	EndIf
;If the area is too small then ignore this and let them try again
	if $iHeight + $iWidth <= 5 Then Return 0
;Perform the Region capture of the identified location
	DllCall("captdll.dll", "int:cdecl", "CaptureRegion", "str", $SaveFile, "int", $iX, "int", $iY, "int", $iWidth, "int", $iHeight, "int", $iQuality)
;Delete the Full Screen capture temp file
	FileDelete($sTempFile)
;Delete the Screen Capture GUI
	GUIDelete($hRegionGUI)
;Finished box
	MsgBox(0, "Finished", "Region capture saved as " & $SaveFile)
	HotKeySet("{" & $sHotKey1 & "}", "_Region")
;Release unused Memory
	_ReduceMemory()
;~ 	Return 1
EndFunc


;===========================================================
;	Function to close out of the application
;===========================================================
Func _CloseMe()
	Exit
EndFunc




;===================================================================================
;===================================================================================
;	Functions used for the Setup and About screens
;===================================================================================
;===================================================================================

;===============================================================================
; Function Name:    _HelpAbout()
; Description:      Standard Gui interface to dislpay the Help, About screen for a program
; Return Value(s):  None
; Author(s):        Michael Olson <MikeOsdx>
;===============================================================================
Func _HelpAbout()

EndFunc   ;==>_About

;===========================================================
;	Create the GUI that allows the end user to specify
;		certain settings required by the application
;===========================================================
Func _StartingPrompt()
;Create the GUI window
	$hStartGUI = GUICreate("ScreenCap Settings", 614, 237, 193, 115, $WS_CAPTION)
;Setup the GUI Controls with any data currently saved in the registry
	GUICtrlCreateLabel("Required Settings", 8, 8, 88, 17)
	GUICtrlCreateGroup("Set HotKeys (Blank to disable)", 8, 40, 265, 130)
	GUICtrlCreateLabel("Capture an Area Specified by Mouse", 24, 64, 177, 17)
	$hotkeyRange = GUICtrlCreateCombo("", 208, 61, 49, 25)
	GUICtrlSetData(-1, "|F6|F7|F8|F9|F10|F11|F12", $sHotKey1)
	GUICtrlCreateLabel("Capture the entire Desktop", 24, 99, 131, 17)
	$HotKeyAll = GUICtrlCreateCombo("", 208, 96, 49, 25)
	GUICtrlSetData(-1, "|F6|F7|F8|F9|F10|F11|F12", $sHotKey2)
	GUICtrlCreateLabel("Capture Active Window", 24, 134, 116, 17)
	$HotKeyActive = GUICtrlCreateCombo("", 208, 131, 49, 25)
	GUICtrlSetData(-1, "|F6|F7|F8|F9|F10|F11|F12", $sHotKey3)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlCreateLabel("Specify the Folder to save your Screen Captures to", 296, 48, 244, 17)
	if $SaveDir <> "" Then
		$sCapDir = $SaveDir
	Else
		$sCapDir = @TempDir
	EndIf
	$sFolder = GUICtrlCreateInput($sCapDir, 296, 72, 161, 21)
	$btnFolderOpen = GUICtrlCreateButton("...", 464, 72, 25, 21)
	GUICtrlSetOnEvent(-1, "_SelectFolder")
	if $SaveName <> "" Then
		$sCapName = $SaveName
	Else
		$sCapName = "ScreenCap_"
	EndIf
	GUICtrlCreateLabel("Specify the name for your Screen Captures", 296, 112, 206, 17)
	$inptFileName = GUICtrlCreateInput($sCapName, 296, 136, 161, 21)
	GUICtrlCreateLabel("This file name will be automatically incremented from 1 to 254", 296, 160, 291, 17)
	$chkClip = GUICtrlCreateCheckbox("Send to Clipboard also", 460, 136, 140, 21)
	if $iClipboard = 1 Then
		GUICtrlSetState($chkClip, $GUI_CHECKED)
	Else
		GUICtrlSetState($chkClip, $GUI_UNCHECKED)
	EndIf
	$lblQuality = GUICtrlCreateLabel("JPG Quality:", 296, 193, 80, 17)
	if $iQuality = "" Then $iQuality = 100
	$inptQuality = GUICtrlCreateInput($iQuality, 380, 190, 40, 20)
	GUICtrlCreateUpdown(-1)
	GUICtrlSetLimit(-1, 100, 10)
	$radioBMP = GUICtrlCreateRadio("Save as .BMP", 440, 175, 100, 17)
	GUICtrlSetOnEvent(-1, "_SetBMP")
	$radioJPG = GUICtrlCreateRadio("Save as .JPG", 440, 195, 100, 17)
	GUICtrlSetOnEvent(-1, "_SetJPG")
	$btnOK = GUICtrlCreateButton("Save and Exit", 90, 190, 105, 25, 0)
	GUICtrlSetOnEvent(-1, "_SaveSettings")
	if $iQuality = -1 Then
		GUICtrlSetState($inptQuality, $GUI_DISABLE)
		GUICtrlSetState($lblQuality, $GUI_DISABLE)
		GUICtrlSetState($radioJPG, $GUI_UNCHECKED)
		GUICtrlSetState($radioBMP, $GUI_CHECKED)
	Else
		GUICtrlSetState($radioBMP, $GUI_UNCHECKED)
		GUICtrlSetState($radioJPG, $GUI_CHECKED)
	EndIf
	GUISetState(@SW_SHOW)
	While 1
		sleep(10)
	WEnd
EndFunc

Func _SetBMP()
	GUICtrlSetState($inptQuality, $GUI_DISABLE)
	GUICtrlSetState($lblQuality, $GUI_DISABLE)
EndFunc

Func _SetJPG()
	GUICtrlSetState($inptQuality, $GUI_ENABLE)
	GUICtrlSetState($lblQuality, $GUI_ENABLE)
	GUICtrlSetData($inptQuality, 10)
EndFunc

;===========================================================
;	Button to select the folder location to save the
;		screen captures to
;===========================================================
Func _SelectFolder()
	$sFolderSelect = FileSelectFolder("Location for Screen Captures", "", 3)
	if $sFolderSelect <> "" Then
		GUICtrlSetData($sFolder, $sFolderSelect)
	EndIf
EndFunc


;===========================================================
;	Verify & Save Setup information into the Registry
;===========================================================
Func _SaveSettings()
;Retrieve all the necessary information
	$sKey1 = GUICtrlRead($hotkeyRange)
	$sKey2 = GUICtrlRead($HotKeyAll)
	$sKey3 = GUICtrlRead($HotKeyActive)
	$sSaveTo = GUICtrlRead($sFolder)
	$sSaveAs = GUICtrlRead($inptFileName)
	if BitAND(GUICtrlRead($radioJPG), $GUI_CHECKED) = $GUI_CHECKED Then
		$sQuality = GUICtrlRead($inptQuality)
	Else
		$sQuality = -1
	EndIf
	if BitAND(GUICtrlRead($chkClip), $GUI_CHECKED) = $GUI_CHECKED Then
		$iClipboard = 1
	Else
		$iClipboard = 0
	EndIf
	
;Verify the data is set properly
	If $sKey1 & $sKey2 & $sKey3 = "" Then
		MsgBox(0, "Error", "You must enable at least one Screen Capture function")
		Return 0
	EndIf
	if $sKey1 > "" Then
		if $sKey1 = $sKey2 or $sKey1 = $sKey3 Then
			MsgBox(0, "Error", "You must specify seperate HotKeys for each function")
			Return 0
		EndIf
	EndIf
	if $sKey2 > "" Then
		if $sKey2 = $sKey1 or $sKey2 = $sKey3 Then
			MsgBox(0, "Error", "You must specify seperate HotKeys for each function")
			Return 0
		EndIf
	EndIf
	if $sKey3 > "" Then
		if $sKey3 = $sKey1 or $sKey3 = $sKey2 Then
			MsgBox(0, "Error", "You must specify seperate HotKeys for each function")
			Return 0
		EndIf
	EndIf
			
;Save valid information into the Registry
	RegWrite("HKCU\Software\ScreenCap", "HotKeyRegion", "REG_SZ", $sKey1)
	RegWrite("HKCU\Software\ScreenCap", "HotKeyAll", "REG_SZ", $sKey2)
	RegWrite("HKCU\Software\ScreenCap", "HotKeyActive", "REG_SZ", $sKey3)
	RegWrite("HKCU\Software\ScreenCap", "SaveTo", "REG_SZ", $sSaveTo)
	RegWrite("HKCU\Software\ScreenCap", "SaveAs", "REG_SZ", $sSaveAs)
	RegWrite("HKCU\Software\ScreenCap", "Quality", "REG_SZ", $sQuality)
	RegWrite("HKCU\Software\ScreenCap", "Clipboard", "REG_SZ", $iClipboard)
	if @error Then
		MsgBox(0, "Error", "Unable to save settings")
		Exit
	Else
		MsgBox(0, "Saved", "Settings have been saved.  Please re-launch ScreenCap.")
		Exit
	EndIf
EndFunc