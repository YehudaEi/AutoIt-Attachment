; Includes
#include <GUIConstants.au3>
#include <GUIStatusBar.au3>
#include <GUIListView.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <GuiEdit.au3>
#include <File.au3>
#include <Array.au3>

; Options for the program
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "Minimize")

; Retrieve all drive types and Memory Stats
Global $_AllD = DriveGetDrive("ALL"), $MemStats = MemGetStats()
; Location of the config file
Global $Config_File = @ScriptDir & '\config.ini'
; Global settings because they don't work otherwise
Global $Warnings = True, $RAM_Update = True
; Make an array with tips
Global $Tips[5]
$Tips[0] = "More RAM will speed up the drive data processing!"
$Tips[1] = "Dual Core processors are good for speeding this program up!"
$Tips[2] = "Please visit james-brooks.net for more programs!"
$Tips[3] = "Thanks to all the AutoIt Community for helping with this project"
$Tips[4] = "More drives will slow down the process without a high quality PC"
; Allow the creation of the data from the 1-Dimensional array ~ Martin
Global $Data[$_AllD[0]]
; Set the variables for the CPU usage
Global $IDLETIME, $KERNELTIME, $USERTIME
Global $StartIdle, $StartKernel, $StartUser
Global $EndIdle, $EndKernel, $EndUser
Global $CPU_Timer, $CPU_Update = False, $CPU_Value
; Set the parts for the status bar
Local $Parts[2] = [175, 150]
; Allow multi control creation of controls ~ Nahuel
Dim $Labels[$_AllD[0] + 1]
Dim $Progress[$_AllD[0] + 1]
; Dll Structures
$IDLETIME   = DllStructCreate("dword;dword")
$KERNELTIME = DllStructCreate("dword;dword")
$USERTIME   = DllStructCreate("dword;dword")

; Read the configuration file for warnings
$Warnings_Read = IniRead($Config_File, "Warnings", "Console", "")
If $Warnings_Read = "On" Then
	$Warnings = True
ElseIf $Warnings_Read = "Off" Then
	$Warnings = False
ElseIf Not FileExists($Config_File) Then
	$Warnings = False
EndIf

; Read the configuration file for RAM Update
$RAM_Read = IniRead($Config_File, "Updates", "RAM", "")
If $RAM_Read = "On" Then
	$RAM_Update = True
	AdlibEnable("RAMUpdate", 1000)
ElseIf $RAM_Read = "Off" Then
	$RAM_Update = False
	AdlibDisable()
ElseIf Not FileExists($Config_File) Then
	$RAM_Update = False
EndIf

#region GUI
; Create the GUI and the controls inside it
$GUI = GUICreate("Disk Manager - James Brooks", 520, 400 + $_AllD[0] * 6)

; Create the menu
#region Menu
$M_File = GUICtrlCreateMenu("File")
$M_Export = GUICtrlCreateMenuItem("Export Data", $M_File)
$M_Import = GUICtrlCreateMenuItem("Import Data", $M_File)
GUICtrlCreateMenuItem("", $M_File)
$M_Copy = GUICtrlCreateMenuItem("Copy Data to Clipboard", $M_File)
GUICtrlCreateMenuItem("", $M_File)
$M_Exit = GUICtrlCreateMenuItem("Exit", $M_File)
$M_Options = GUICtrlCreateMenu("Options")
$M_Colours = GUICtrlCreateMenu("Colour Scheme", $M_Options)
$M_Colours_Sea = GUICtrlCreateMenuItem("Sea", $M_Colours)
$M_Colours_Mystic = GUICtrlCreateMenuItem("Mystic", $M_Colours)
$M_Colours_HinSun = GUICtrlCreateMenuItem("Hindered Sun", $M_Colours)
$M_Colours_Grass = GUICtrlCreateMenuItem("Grass", $M_Colours)
$M_Colours_Simple = GUICtrlCreateMenuItem("Simple", $M_Colours)
$M_Progress = GUICtrlCreateMenu("Progress Styles", $M_Options)
$M_Progress_Solid = GUICtrlCreateMenuItem("Solid", $M_Progress)
$M_Progress_Block = GUICtrlCreateMenuItem("Block", $M_Progress)
$M_Help = GUICtrlCreateMenu("Help")
$M_Tips = GUICtrlCreateMenuItem("Tips", $M_Help)
$M_Update = GUICtrlCreateMenuItem("Update", $M_Help)
GUICtrlCreateMenuItem("", $M_Help)
$M_BugReport = GUICtrlCreateMenuItem("Report Bug", $M_Help)
$M_About = GUICtrlCreateMenuItem("About", $M_Help)
$M_HelpTopic = GUICtrlCreateMenuItem("Help Me", $M_Help)
#endregion Menu

;$RAM = GUICtrlCreateLabel(Int($MemStats[1] / 1024) & "MB RAM", 10, 270)
;$Free_RAM = GUICtrlCreateLabel(Int($MemStats[2] / 1024) & "MB FREE RAM", 10, 287)
;$Time_Taken = GUICtrlCreateLabel("", 10, 314, 100)

; Create the Statusbar
$StatusBar = _GUICtrlStatusBar_Create($GUI)
_GUICtrlStatusBar_SetParts($StatusBar, $Parts)
_GUICtrlStatusBar_SetText($StatusBar, "Loading Drive Data...")

; Create the listview to display the drives ~ Saunders Edited by Me
$DriveList = _GUICtrlListView_Create($GUI, "Drive|Label|Type|Status|File System|Serial Number|Free Space|Used Space|Total Space", 10, 10, 500, 120)

; Create a group to hold the progress bars
For $i = 1 To $_AllD[0]
    $Labels[$i] = GUICtrlCreateLabel(StringUpper($_AllD[$i]), 20, ($i * 15) + 140, 121, 17)
    $Progress[$i] = GUICtrlCreateProgress(40, ($i * 15) + 140, 121, 17, 1)
    DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle(-1), "wstr", " ", "wstr", " ")
    If Not FileExists($Config_File) Then
        GUICtrlSetColor($Progress[$i], 0x94FF00)
        GUICtrlSetBkColor($Progress[$i], 0xFFFFFF)
        GUICtrlSetStyle($Progress[$i], 1)
    ElseIf FileExists($Config_File) Then
        GUICtrlSetColor($Progress[$i], IniRead($Config_File, "Scheme", "Front", ""))
        GUICtrlSetBkColor($Progress[$i], IniRead($Config_File, "Scheme", "Back", ""))
        GUICtrlSetStyle($Progress[$i], IniRead($Config_File, "Scheme", "Progress", ""))
    EndIf
Next

$i-=1
$RAM = GUICtrlCreateLabel(Int($MemStats[1] / 1024) & "MB RAM", 20, (($i*15)+20+140), 125, 16)
$Free_RAM = GUICtrlCreateLabel(Int($MemStats[2] / 1024) & "MB FREE RAM", 20, (($i*15)+37+140), 125, 16)
;$CPU_Usage = GUICtrlCreateLabel(Int($CPU_Value), 20, (($i*15)+57+140), 125)

; Create a group for the console
GUICtrlCreateGroup("Console", 180, 140, 330, 220)
$ConsoleBox = GUICtrlCreateEdit("Welcome to Disk Manager by James Brooks" & @CRLF & "Commands:" & @CRLF & _
		@TAB & "warn [-t = Show -f = Hide]" & @CRLF & @TAB & "clear" & @CRLF & @TAB & "export" & _
		@CRLF & @TAB & "help" & @CRLF & @TAB & "devices [-s = Show -d = Delete]" & @CRLF & @TAB & _
		"ram [-u = RAM Update on" & @CRLF & @TAB & @TAB & "-o = RAM Update off]" & @CRLF, 190, 160, 310, 170, $WS_VSCROLL)
GUICtrlSetFont(-1, 8.5, 400, Default, "Courier New")
GUICtrlSetColor(-1, IniRead($Config_File, "Scheme", "Console", ""))
DllCall("UxTheme.dll", "int", "SetWindowTheme", "hwnd", GUICtrlGetHandle($ConsoleBox), "wstr", "", "wstr", "")
$Console = GUICtrlCreateInput("", 190, 340, 310, 17)
GUICtrlSetFont(-1, 8.5, 400, Default, "Courier New")
GUICtrlCreateGroup("", -99, -99, 1, 1)

; Insert data into the listview made above
_Drives()

; We have to show the GUI
GUISetState(@SW_SHOW)
#endregion Menu

While 1
	$iMsg = GUIGetMsg()
	Select
		Case $iMsg = $GUI_EVENT_CLOSE
			Exit
			; If you press X then close the window
		Case $iMsg = $GUI_EVENT_MINIMIZE
			GUISetState(@SW_HIDE)
			TraySetState(1)
			; Minimize the GUI to the tray
		Case $iMsg = $M_Export
			_ExportData()
			; Export the data NOT WORKING YET
		Case $iMsg = $Console
			$Com = StringLower(GUICtrlRead($Console))
			If $Com = "warn -t" Then
				$Warnings = True
				IniWrite($Config_File, "Warnings", "Console", "On")
				_GUICtrlEdit_AppendText($ConsoleBox, "Warnings on" & @CRLF)
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "warn -f" Then
				$Warnings = False
				IniWrite($Config_File, "Warnings", "Console", "Off")
				_GUICtrlEdit_AppendText($ConsoleBox, "Warnings off" & @CRLF)
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "clear" Then
				GUICtrlSetData($ConsoleBox, "")
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "help" Then
				_GUICtrlEdit_AppendText($ConsoleBox, "Commands:" & @CRLF)
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "about" Then
				_GUICtrlEdit_AppendText($ConsoleBox, "Disk Manager by James Brooks" & @CRLF & "Thanks to the AutoIt " & _
						"Community for helping me with this project. Special thanks to, Nahuel, Saunders, Gary Frost, Valuater, " & _
						"Martin, Emiel Wieldraaijer, Kip and Covaks for their help, support and contribution to it!" & @CRLF)
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "export" Then
				_ExportData()
				GUICtrlSetData($Console, "")
			EndIf
			If $Com = "devices -s" Then
				_Drives()
				GUICtrlSetData($Console, "")
				_GUICtrlEdit_AppendText($ConsoleBox, "Retrieved devices" & @CRLF)
			EndIf
			If $Com = "devices -d" Then
				_GUICtrlListView_DeleteAllItems($DriveList)
				GUICtrlSetData($Console, "")
				_GUICtrlEdit_AppendText($ConsoleBox, "Deleted device list" & @CRLF)
			EndIf
			If $Com = "ram -u" Then
				IniWrite($Config_File, "Updates", "RAM", "On")
				GUICtrlSetData($Console, "")
				_GUICtrlEdit_AppendText($ConsoleBox, "RAM update is on" & @CRLF)
				AdlibEnable("RAMUpdate", 10000)
			EndIf
			If $Com = "ram -o" Then
				IniWrite($Config_File, "Updates", "RAM", "Off")
				GUICtrlSetData($Console, "")
				_GUICtrlEdit_AppendText($ConsoleBox, "RAM update is off" & @CRLF)
				AdlibDisable()
			EndIf
			If $Com = "clip" Then
				GUICtrlSetData($Console, "")
				_CopyToClipBoard()
			EndIf
			; Read through the console
		Case $iMsg = $M_About
			About()
			; Display the about box
		Case $iMsg = $M_BugReport
			BugReport()
		Case $iMsg = $M_Import
			Import()
		Case $iMsg = $M_Colours_Simple
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Back", "0x8BD1E0")
				IniWrite($Config_File, "Scheme", "Front", "0xC1C1C1")
				IniWrite($Config_File, "Scheme", "Console", "0x000000")
				_GUICtrlStatusBar_SetText($StatusBar, "Config file was created!")
				For $z = 1 To $_AllD[0]
					GUICtrlSetColor($Progress[$z], IniRead($Config_File, "Scheme", "Front", ""))
					GUICtrlSetBkColor($Progress[$z], IniRead($Config_File, "Scheme", "Back", ""))
					GUICtrlSetColor($ConsoleBox, IniRead($Config_File, "Scheme", "Console", ""))
				Next
			EndIf
			; Set the colour scheme to a simple blue and grey
		Case $iMsg = $M_Colours_Mystic
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Back", "0x6F6F6F")
				IniWrite($Config_File, "Scheme", "Front", "0xCC3300")
				IniWrite($Config_File, "Scheme", "Console", "0xCC3300")
				_GUICtrlStatusBar_SetText($StatusBar, "Config file was created!")
				For $z = 1 To $_AllD[0]
					GUICtrlSetColor($Progress[$z], IniRead($Config_File, "Scheme", "Front", ""))
					GUICtrlSetBkColor($Progress[$z], IniRead($Config_File, "Scheme", "Back", ""))
					GUICtrlSetColor($ConsoleBox, IniRead($Config_File, "Scheme", "Console", ""))
				Next
			EndIf
			; Set the colour scheme to Grey and Red
		Case $iMsg = $M_Colours_Sea
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Back", "0x96B6E5")
				IniWrite($Config_File, "Scheme", "Front", "0xC4E596")
				IniWrite($Config_File, "Scheme", "Console", "0x508238")
				_GUICtrlStatusBar_SetText($StatusBar, "Config file was created!")
				For $z = 1 To $_AllD[0]
					GUICtrlSetColor($Progress[$z], IniRead($Config_File, "Scheme", "Front", ""))
					GUICtrlSetBkColor($Progress[$z], IniRead($Config_File, "Scheme", "Back", ""))
					GUICtrlSetColor($ConsoleBox, IniRead($Config_File, "Scheme", "Console", ""))
				Next
			EndIf
			; Set the colour scheme to Blue and Green
		Case $iMsg = $M_Colours_HinSun
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Back", "0xCC3300")
				IniWrite($Config_File, "Scheme", "Front", "0xE8A03A")
				IniWrite($Config_File, "Scheme", "Console", "0xCC3300")
				_GUICtrlStatusBar_SetText($StatusBar, "Config file was created!")
				For $z = 1 To $_AllD[0]
					GUICtrlSetColor($Progress[$z], IniRead($Config_File, "Scheme", "Front", ""))
					GUICtrlSetBkColor($Progress[$z], IniRead($Config_File, "Scheme", "Back", ""))
					GUICtrlSetColor($ConsoleBox, IniRead($Config_File, "Scheme", "Console", ""))
				Next
			EndIf
		Case $iMsg = $M_Colours_Grass
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Back", "0x89d464")
				IniWrite($Config_File, "Scheme", "Front", "0xC5D464")
				IniWrite($Config_File, "Scheme", "Console", "0x508238")
				_GUICtrlStatusBar_SetText($StatusBar, "Config file was created!")
				For $z = 1 To $_AllD[0]
					GUICtrlSetColor($Progress[$z], IniRead($Config_File, "Scheme", "Front", ""))
					GUICtrlSetBkColor($Progress[$z], IniRead($Config_File, "Scheme", "Back", ""))
					GUICtrlSetColor($ConsoleBox, IniRead($Config_File, "Scheme", "Console", ""))
				Next
			EndIf
		Case $iMsg = $M_Progress_Block
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Progress", "0")
				_GUICtrlStatusBar_SetText($StatusBar, "Setting progress style!")
				For $z = 1 To $_AllD[0]
					$FreeP = Int(DriveSpaceFree($_AllD[$z]) / 1024)
					GUICtrlSetStyle($Progress[$z], IniRead($Config_File, "Scheme", "Progress", "0"))
					GUICtrlSetData($Progress[$z], $FreeP)
					_GUICtrlStatusBar_SetText($StatusBar, "Progress style set!")
				Next
			EndIf
		Case $iMsg = $M_Progress_Solid
			If Not FileExists($Config_File) Then
				_FileCreate($Config_File)
			Else
				IniWrite($Config_File, "Scheme", "Progress", "1")
				_GUICtrlStatusBar_SetText($StatusBar, "Setting progress style!")
				For $z = 1 To $_AllD[0]
					$FreeP = Int(DriveSpaceFree($_AllD[$z]) / 1024)
					GUICtrlSetStyle($Progress[$z], IniRead($Config_File, "Scheme", "Progress", "1"))
					GUICtrlSetData($Progress[$z], $FreeP)
					_GUICtrlStatusBar_SetText($StatusBar, "Progress style set!")
				Next
			EndIf
		Case $iMsg = $M_Tips
			Tips()
	EndSelect
WEnd

Func _Drives()
	Local $Timeout = 1000 * 60; Max length of time
	$Drive_Timer = TimerInit()
	TrayTip("Disk Manager", "Loading device data", 1000 * 60, 1)
	For $a = 1 To $_AllD[0]
		If TimerDiff($Drive_Timer) >= $Timeout Then
			MsgBox(16, "Disk Manager", "There was a timeout trying to read your device data")
			Exit
		Else
			$Total = DriveSpaceTotal($_AllD[$a])
			$Free = Round(DriveSpaceFree($_AllD[$a]))
			$Used = Round($Total - $Free)
			$Letter = StringUpper($_AllD[$a])
			$Label = DriveGetLabel($_AllD[$a])
			If $Label = '' Then $Label = "[None]"
			$Type = DriveGetType($_AllD[$a])
			If $Type = 'UNKNOWN' Then $Type = "[Unknown]"
			$Status = DriveStatus($_AllD[$a])
			$FSys = DriveGetFileSystem($_AllD[$a])
			If $FSys = '' Then $FSys = "[None]"
			$Serial = DriveGetSerial($_AllD[$a])
			If $Serial = '' Then $Serial = "[None]"
			
			$sItem = $Letter & "|" & $Label & "|" & $Type & "|" & $Status & "|" & $FSys & "|" & $Serial & "|" & $Free & "|" & _
					$Used & "|" & $Total
			$iItem = _GUICtrlListView_InsertItem($DriveList, "", -1, 1)
			_GUICtrlListView_SetItemText($DriveList, $iItem, $sItem, -1)
			GUICtrlSetData($Progress[$a], $Free / 1024); not precise ~ Valuater edited my Me
			$Data[$a - 1] = StringSplit($sItem, "|")
		EndIf
	Next
	TrayTip("Disk Manager", "Drive data was loaded!", 10, 1)
	If @error Then
		If $Warnings = True Then _GUICtrlEdit_AppendText($ConsoleBox, "There was an error reading disk data!" & @CRLF)
	EndIf
	; Retrieve all device data
EndFunc   ;==>_Drives

Func _CopyToClipBoard()
	For $m = 0 To UBound($Data) - 1
		$ad = ''
		$tempArray2 = $Data[$m]
		For $v = 1 To UBound($tempArray2) - 1
			$ad &= $tempArray2[$v]
			If $v < UBound($tempArray2) - 1 Then $ad &= '|';or ',' etc
		Next
		ClipPut($ad & @CRLF)
	Next
	; Copies all data to the clipboard for further analysis
EndFunc   ;==>_CopyToClipBoard

Func Minimize()
	TraySetState(2)
	GUISetState(@SW_SHOW)
	TraySetToolTip("Disk Manager")
	; Minimize function
EndFunc   ;==>Minimize

Func About()
	$About = GUICreate("About Disk Manager", 305, 125)
	GUICtrlCreateLabel("Disk Manager by James Brooks" & @CRLF & @CRLF & "Thanks to the AutoIt " & _
			"Community for helping me with this" & @CRLF & "project. Special thanks to, Nahuel, Saunders, " & _
			@CRLF & "Gary Frost, Valuater, Martin," & @CRLF & "Emiel Wieldraaijer and Kip for their help, support and contribution" & _
			"to it!", 10, 10)
	$Link = GUICtrlCreateLabel("Please visit my site for more programs!", 10, 100, 280)
	GUICtrlSetColor(-1, 0x0000FF)
	GUICtrlSetFont(-1, Default, Default, 4)
	GUICtrlSetCursor(-1, 2)
	
	GUISetState(@SW_SHOW, $About)
	
	While WinActive($About)
		$aMsg = GUIGetMsg()
		Switch $aMsg
			Case $GUI_EVENT_CLOSE
				GUIDelete($About)
			Case $Link
				ShellExecute("                           ")
		EndSwitch
	WEnd
	; About window
EndFunc   ;==>About

Func BugReport()
	MsgBox(0, "Disk Manager", "Bug reporting is only installed in the Compiled Version!")
EndFunc   ;==>BugReport

Func Help()
	; ShellExecute("                                                   ")
	; Pages not setup yet!
EndFunc   ;==>Help

Func Import()
	$File = FileOpenDialog("Disk Manager", @ScriptDir, "DMan Files (*.DMA)", 1 + 2)
	If $Warnings = True Then
		If @error Then
			MsgBox(4096, "", "No File chosen")
			_GUICtrlStatusBar_SetText($StatusBar, "Error importing external deivce data" & @CRLF)
		Else
			;_GUICtrlListView_DeleteAllItems($DriveList)
			MsgBox(0, "Disk Manager", "Import soon")
		EndIf
	ElseIf $Warnings = False Then
		;
	EndIf
EndFunc   ;==>Import

Func _ExportData()
	MsgBox(0, "Disk Manager", "When saving a file please remember to add the extension .DMA to the end!", 10)
	$Export_File = FileSaveDialog("Disk Manager", @ScriptDir, "Disk Manager Export Files (*.DMA)")
	$io_file = FileOpen($Export_File, 2)
	FileWrite($io_file, "// Export data for computer: " & @ComputerName & @CRLF)
	FileWrite($io_file, "// Exported on: " & @MDAY & "/" & @MON & "/" & @YEAR & @CRLF)
	FileWrite($io_file, "// Exported by: " & @UserName & @CRLF)
	FileWrite($io_file, "// Exported using Disk Manager by James Brooks Copyright 2007!" & @CRLF & @CRLF)
	For $n = 0 To UBound($Data) - 1
		$sd = ''
		$tempArray = $Data[$n]
		For $p = 1 To UBound($tempArray) - 1
			$sd &= $tempArray[$p]
			If $p < UBound($tempArray) - 1 Then $sd &= '|';or ',' etc
		Next
		FileWrite($io_file, $sd & @CRLF)
	Next
	FileClose($io_file)
	
	If $Warnings = True Then
		If @error Then
			_GUICtrlEdit_AppendText($ConsoleBox, "Error exporting data!" & @CRLF)
			_GUICtrlStatusBar_SetText($StatusBar, "Error exporting data")
		Else
			_GUICtrlStatusBar_SetText($StatusBar, "Data was exported!")
			_GUICtrlEdit_AppendText($ConsoleBox, "Data was exported!" & @CRLF)
		EndIf
	ElseIf $Warnings = False Then
		; No Warnings
	EndIf
	; Export the data into a specified file ~ Martin edited by Me
EndFunc   ;==>_ExportData

Func RamUpdate()
	GUICtrlSetData($RAM, Int($MemStats[1] / 1024) & "MB RAM")
	GUICtrlSetData($Free_RAM, Int($MemStats[2] / 1024) & "MB FREE RAM")
	If $Warnings = True Then
		If @error Then
			_GUICtrlEdit_AppendText($ConsoleBox, "RAM update encountered an error!" & @CRLF)
		Else
			_GUICtrlEdit_AppendText($ConsoleBox, "RAM update completed successfully!" & @CRLF)
		EndIf
	ElseIf $Warnings = False Then
		; No warnings
	EndIf
EndFunc   ;==>RamUpdate

Func Tips()
	$Random_Tip = Random(0, UBound($Tips) - 1, 1)
	$Result_Tip = $Tips[$Random_Tip]
	TrayTip("Disk Manager", $Result_Tip, 5, 1)
EndFunc   ;==>Tips