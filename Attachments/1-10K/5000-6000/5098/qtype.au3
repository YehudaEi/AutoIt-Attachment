#include <..\include\GUIConstants.au3>
;----------------------------------------------------------------------------------------------
; hotkey: restore application window
$hotkeyRestoreApplication="!^q"
; hotkey: toggle debug info
$hotkeyToggleDebug="!^d"
; hotkey: reread shortcuts
$hotkeyReReadShortcuts="!^r"
; hotkey: config dialog
$hotkeyOpenConfig="!^c"
;----------------------------------------------------------------------------------------------
$appTitle = "QType"
$minStringLength = 2
$path_links1 = @StartMenuCommonDir
;$path_links1 = ""
$path_links2 = @StartMenuDir
;$path_links2 = ""
;----------------------------------------------------------------------------------------------
AutoItSetOption("GUICloseOnESC",0)
AutoItSetOption("ExpandEnvStrings",1)
AutoItSetOption("TrayAutoPause", 0)
AutoItSetOption("TrayMenuMode", 1)

$mask_links = ".lnk"
$input_old = ""
$input_new = ""
$DEBUG = 0
$SaveConfig = 0
$AppIni = @ScriptDir & "\" & Stringleft(@ScriptName,StringLen(@ScriptName)-4) & ".ini"
Dim $lnkArray[1][2]

; display tooltip
Func ToolTipTimed($aText,$aDelay)
	ToolTip($aText)
	Sleep($aDelay)
	ToolTip("")
EndFunc

; configure hotkeys
Func setHotkeys()
	HotKeySet($hotkeyRestoreApplication,"popupApplication")
	HotKeySet($hotkeyToggleDebug,"toggleDebug")
	HotKeySet($hotkeyReReadShortcuts,"readShortcuts")
	HotKeySet($hotkeyOpenConfig,"openConfig")
EndFunc

; put window on top
Func toggleDebug()
	$DEBUG = not $DEBUG
	If $DEBUG Then 
		ToolTipTimed("Debug mode ON",500)
	Else
		ToolTipTimed("Debug mode OFF",500)
	EndIf
EndFunc	

; put window on top
Func popupApplication()
	TraySetState(2)
    GUISetState(@SW_SHOW)
	WinSetState($appTitle,"",@SW_RESTORE)
	WinActivate($appTitle)
	ControlFocus($appTitle,"",$Input_1)
EndFunc	

; add links to lnk array
Func handleFile($aDir,$aFile)
	if StringRight($aFile,4) = $mask_links Then
		if FileExists($adir & "\" & $aFile) Then
			$lnkArray[0][0] = $lnkArray[0][0] + 1
			if $lnkArray[0][0] >= UBound($lnkArray,1) Then ReDim $lnkArray[$lnkArray[0][0]+100][2]
			$lnkArray[$lnkArray[0][0]][0] = $adir & "\" & $aFile
			$lnkArray[$lnkArray[0][0]][1] = StringLeft($aFile,StringLen($aFile)-4)
		EndIf
	EndIf
EndFunc

; recurse dirs
func handleDir($aDir)
Local $search, $file, $attrib

	; scan directories
	FileChangeDir($aDir)
	$search = FileFindFirstFile("*.*")
	If $search = -1 Then 
		FileClose($search)
		Return
	EndIf	
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		If StringLeft($file,1) = "." Then ContinueLoop
		$attrib = FileGetAttrib($aDir & "\" & $file)
		If (StringInStr($attrib, "D")) Then handleDir($aDir & "\" & $file)
	WEnd
	FileClose($search)

	; scan files
	FileChangeDir($aDir)
	$search = FileFindFirstFile("*.*")
	If $search = -1 Then 
		FileClose($search)
		Return
	EndIf	
	While 1
		$file = FileFindNextFile($search)
		If @error Then ExitLoop
		$attrib = FileGetAttrib($aDir & "\" & $file)
		If (Not StringInStr($attrib, "D")) Then handleFile($aDir,$file)
	WEnd
	FileClose($search)
	
EndFunc

; update dropdown
Func updateList()
	Local $lnkList = ""
	$inp = GUICtrlRead($Input_1)
	if StringLen($inp) < $minStringLength Then
		$lnkList = ""
	Else
		For $i = 1 to $lnkArray[0][0]
			$lnk = $lnkArray[$i][1]
			if StringInStr($lnk,$inp,0) > 0 And $lnk <> "" And $inp <> "" Then
				$lnkList = $lnkList & "|" & $lnk
			EndIf
		Next
	EndIf
;	MsgBox(0,"List of matching links",$lnkList)
	if $lnkList <> "" Then
		GUICtrlSetData($Combo_2,$lnkList)
		ControlCommand($appTitle,"",$Combo_2,"ShowDropDown", "")
	Else
		ControlCommand($appTitle,"",$Combo_2,"HideDropDown", "")
		GUICtrlSetData($Combo_2,"")
	EndIf
EndFunc

; check if input changed
Func checkInput()
	$input_new = GUICtrlRead($Input_1)
	if ($input_new <> $input_old) Then updateList()
	$input_old = $input_new
EndFunc

; start prog via link
Func startLink($aLink)
	Local $details[10]
	If $aLink = "" Then Return
	For $i = 1 to $lnkArray[0][0]
		$lnk = $lnkArray[$i][1]
		if String($lnk) = $aLink Then
			$details = FileGetShortcut($lnkArray[$i][0])
			if $details <> 1 Then
				if $DEBUG Then
					if MsgBox(1,"Shortcut details:","Program: " & FileGetShortName($details[0]) & @LF & "Arguments: " & $details[2] & @LF & "Path: " & $details[1] & @LF & "Status: " & $details[6] & @LF & "lnkArray: " & $lnkArray[$i][0]) = 2 Then ExitLoop
				EndIf
				if Not FileExists($details[1]) Then $details[1] = ""
				Run(@ComSpec & ' /c start ' & FileGetShortName($details[0]) & ' ' & $details[2],$details[1],@SW_HIDE)
			Else
				if $DEBUG Then 
					if MsgBox(1,"Bad shortcut -> ShellExecute","Link: " & FileGetShortName($lnkArray[$i][0]) & @LF & "lnkArray: " & $lnkArray[$i][0]) = 2 Then ExitLoop
				EndIf
				DllCall("shell32.dll","long","ShellExecute","hwnd",0,"string","","string",FileGetShortName($lnkArray[$i][0]),"string","","string","c:\","int",@SW_SHOWNORMAL)
			EndIf
			WinActivate(-1)
			Return
		EndIf
	Next
EndFunc

; start prog via name
Func startProg($aProg)
	If $aProg = "" Then Return
	$toRun = @Comspec & ' /c start ' & $aProg
	if $DEBUG Then
		if MsgBox(1,"Launch program","Program: " & $toRun & @LF & "Path: c:\") = 2 Then	Return
	EndIf
	if $aProg = "cmd" Then
		Run($toRun,"c:\")
	Else
		Run($toRun,"c:\",@SW_HIDE)
	EndIf
	WinActivate(-1)
EndFunc

; read in shortcuts from disk
Func readShortcuts()
	ReDim $lnkArray[1][1]
	ReDim $lnkArray[500][2]
	$lnkArray[0][0] = 0

	Local $start = TimerInit()
	ToolTip("Reading shortcuts from " & $path_links1)
	handleDir($path_links1)
	ToolTip("Reading shortcuts from " & $path_links2)
	handleDir($path_links2)
	ToolTip("Sorting list of " & $lnkArray[0][0] & " shortcuts" & " ...")
;	_ArraySort($lnkArray,0,1,0,2,1)		; 45 sec
;	_ArraySort2(0,1,0,2,1)				; 18 sec
	_ArraySort2(0,1,$lnkArray[0][0],2,1)				; 10 sec
	ToolTip("")
	if $DEBUG Then MsgBox(0,"Load time for " & $lnkArray[0][0] & " shortcuts","Load time: " & StringFormat('%.2f',TimerDiff($start)) & " milliseconds")

	WinSetTitle($appTitle,"",$appTitle & " - " & $lnkArray[0][0] & " shortcuts")
	ControlFocus($appTitle,"",$Input_1)
EndFunc

; sort array
Func _ArraySort2($i_Decending = 0, $i_Base = 0, $i_UBound = 0, $i_Dim = 1, $i_SortIndex = 0)
	Local $A_Size, $Gap, $Count, $Temp, $C_Dim
	Local $IsChanged = 0

	; set to ubound when not specified
	If $i_UBound < 1 Then $i_UBound = UBound($lnkArray) - 1
	
	$A_Size = $i_UBound
	If $A_Size = 1 Then
		$Gap = 1
	Else
		$Gap = Int($A_Size / 2)
	EndIf

	While $Gap <> 0
		$IsChanged = 0
		ToolTip("Sort progress: " & StringFormat("%.2f",int($i_UBound/$Gap)/$i_UBound *100) & " %")
		For $Count = $i_Base To ($A_Size - $Gap)
			If $lnkArray[$Count][$i_SortIndex] > $lnkArray[$Count + $Gap][$i_SortIndex] Then
				For $C_Dim = 0 To $i_Dim - 1
					$Temp = $lnkArray[$Count][$C_Dim]
					$lnkArray[$Count][$C_Dim] = $lnkArray[$Count + $Gap][$C_Dim]
					$lnkArray[$Count + $Gap][$C_Dim] = $Temp
					$IsChanged = 1
				Next
			EndIf
		Next
		If $IsChanged = 0 Then
			$Gap = Int($Gap / 2)
		EndIf
	WEnd

EndFunc

; save settings to ini file
Func saveIni()
	IniWrite($AppIni,"Config","$minStringLength",$minStringLength)
	IniWrite($AppIni,"Config","$hotkeyRestoreApplication",$hotkeyRestoreApplication)
	IniWrite($AppIni,"Config","$hotkeyReReadShortcuts",$hotkeyReReadShortcuts)
	IniWrite($AppIni,"Config","$hotkeyToggleDebug",$hotkeyToggleDebug)
	IniWrite($AppIni,"Config","$hotkeyOpenConfig",$hotkeyOpenConfig)
EndFunc

; load settings from ini file
Func loadIni()
	If Not FileExists($AppIni) Then Return
	$minStringLength = IniRead($AppIni,"Config","$minStringLength",$minStringLength)
	$hotkeyRestoreApplication = IniRead($AppIni,"Config","$hotkeyRestoreApplication",$hotkeyRestoreApplication)
	$hotkeyReReadShortcuts = IniRead($AppIni,"Config","$hotkeyReReadShortcuts",$hotkeyReReadShortcuts)
	$hotkeyToggleDebug = IniRead($AppIni,"Config","$hotkeyToggleDebug",$hotkeyToggleDebug)
	$hotkeyOpenConfig = IniRead($AppIni,"Config","$hotkeyOpenConfig",$hotkeyOpenConfig)
EndFunc



; config dialog
Func openConfig()
	AutoItSetOption("GUICloseOnESC",1)
	$cfg = GuiCreate($appTitle & " - Configuration", 240, 250,(@DesktopWidth-240)/2, (@DesktopHeight-250)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	
	GUICtrlCreateGroup("Search threshold",10,5,220,40)
	GUICtrlCreateLabel("Minimum chars",20,20)
	$cfgInput_1 = GuiCtrlCreateInput($minStringLength, 120, 20, 100, 20)
	GUICtrlSetStyle(-1,BitOR($BS_LEFT,$BS_CENTER))
	GUICtrlSetTip(-1,"Enter the minimum count of typed in chars to activate the filter function.")
	
	GUICtrlCreateGroup("Hotkey Setup",10,45,220,140)
	GUICtrlCreateLabel("Popup window",20,60)
	GUICtrlSetStyle(-1,BitOR($BS_LEFT,$BS_CENTER))
	$cfgInput_2 = GuiCtrlCreateInput($hotkeyRestoreApplication, 120, 60, 100, 20)
	GUICtrlSetTip(-1,"Hotkey to restore the application window to the desktop.")
	GUICtrlCreateLabel("Rescan shortcuts",20,80)
	GUICtrlSetStyle(-1,BitOR($BS_LEFT,$BS_CENTER))
	$cfgInput_3 = GuiCtrlCreateInput($hotkeyReReadShortcuts, 120, 80, 100, 20)
	GUICtrlSetTip(-1,"Hotkey to reread all shortcuts from the windows startmenu.")
	GUICtrlCreateLabel("Debug mode",20,100)
	GUICtrlSetStyle(-1,BitOR($BS_LEFT,$BS_CENTER))
	$cfgInput_4 = GuiCtrlCreateInput($hotkeyToggleDebug, 120, 100, 100, 20)
	GUICtrlSetTip(-1,"Hotkey to switch debug mode on/off.")
	GUICtrlCreateLabel("Config window",20,120)
	GUICtrlSetStyle(-1,BitOR($BS_LEFT,$BS_CENTER))
	$cfgInput_5 = GuiCtrlCreateInput($hotkeyOpenConfig, 120, 120, 100, 20)
	GUICtrlSetTip(-1,"Hotkey to open this configuration dialog.")
	GUICtrlCreateLabel("Hotkey modifyer",20,150)
	GUICtrlCreateLabel("  '!' = Alt, '^' = Ctrl," & @CR & "  '+' = Shift, '#' = Winkey",100,150,200,30)
	
	$cfgCheck_1 = GUICtrlCreateCheckbox ("Save config settings to ini file", 20, 195)
	GUICtrlSetTip(-1,"Check this box to save the current settings to an ini file.")
	if $SaveConfig Then GUICtrlSetState($cfgCheck_1,1)
	
	$cfgButton_1 = GUICtrlCreateButton("&Ok",55, 220, 60, 20)
	$cfgButton_2 = GUICtrlCreateButton("&Cancel", 125, 220, 60, 20)
	GuiSetState()

	While 1
		$cfgMsg = GuiGetMsg()
		Select
			Case $cfgMsg = $GUI_EVENT_CLOSE
				$cfgMsg = 0
				ExitLoop
			Case $cfgMsg = $cfgButton_1
				if GUICtrlRead($cfgInput_1) <> "" Then $minStringLength = Int(GUICtrlRead($cfgInput_1))
				if GUICtrlRead($cfgInput_2) <> "" Then
					HotKeySet($hotkeyRestoreApplication)
					$hotkeyRestoreApplication = GUICtrlRead($cfgInput_2)
				EndIf	
				if GUICtrlRead($cfgInput_3) <> "" Then
					HotKeySet($hotkeyReReadShortcuts)
					$hotkeyReReadShortcuts = GUICtrlRead($cfgInput_3)
				EndIf
				if GUICtrlRead($cfgInput_4) <> "" Then
					HotKeySet($hotkeyToggleDebug)
					$hotkeyToggleDebug = GUICtrlRead($cfgInput_4)
				EndIf
				if GUICtrlRead($cfgInput_5) <> "" Then
					HotKeySet($hotkeyOpenConfig)
					$hotkeyOpenConfig = GUICtrlRead($cfgInput_5)
				EndIf
				$SaveConfig = 0
				if GUICtrlRead($cfgCheck_1) = $GUI_CHECKED Then	$SaveConfig = 1
				setHotkeys()
				ExitLoop
			Case $cfgMsg = $cfgButton_2
				ExitLoop
			Case Else
				;;;
		EndSelect
	WEnd

if $SaveConfig Then saveIni()
GUIDelete($cfg)
AutoItSetOption("GUICloseOnESC",0)
EndFunc

; create main GUI
func createGUI()
	GuiCreate($appTitle, 200, 50,(@DesktopWidth-200)/2, (@DesktopHeight-50)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
	;GuiCreate($appTitle, 200, 50,(@DesktopWidth-230)/2, (@DesktopHeight-109)/2 , $WS_EX_DLGMODALFRAME )
	;GuiCreate($appTitle, 200, 60,(@DesktopWidth-230)/2, (@DesktopHeight-109)/2 , BitOr($WS_POPUP,$WS_BORDER,$WS_CLIPSIBLINGS))
	Global $Input_1 = GuiCtrlCreateInput("", 5, 5, 170, 20)
	GUICtrlSetTip(-1,"Type in part of a shortcut name to activate the filter function")
	GUICtrlSetBkColor(-1,0xffffde)
	Global $Combo_2 = GuiCtrlCreateCombo("", 5, 25, 190, 21,$CBS_DROPDOWNLIST)
	GUICtrlSetTip(-1,"Select a shortcut name from the filtered list.")
	GUICtrlSetBkColor(-1,0xffffde)
	Global $Button_1 = GUICtrlCreateButton("", 177, 5, 16, 18)
	GUICtrlSetTip(-1,"Click this button to launch the shortcut.")
	TraySetClick(8)
	TraySetState(2)
	GuiSetState()

	Global $trayRestore  = TrayCreateItem("Restore window")
	Global $trayReRead  = TrayCreateItem("Rescan shortcuts")
	Global $trayConfig  = TrayCreateItem("Configuration")
	TrayCreateItem("")
	Global $trayAbout  = TrayCreateItem("About")
	TrayCreateItem("")
	Global $trayExit   = TrayCreateItem("Exit")

	Global $About = $AppTitle & " - Quick type shortcut launcher" & @CR & @CR
	$About = $About & "Purpose:" & @CR
	$About = $About & "Launch any program located in the startmenu, by typing part" & @CR
	$About = $About & "of its name." & @CR & @CR
	$About = $About & "Description:" & @CR
	$About = $About & $AppTitle & " scans your windows startmenu for shortcuts at startup." & @CR
	$About = $About & "If sorting is done, you can type any string fragment of an knowen" & @CR
	$About = $About & "shortcut name into the upper input field. Type more then " & $minStringLength & @CR
	$About = $About & "characters to see a list of matching shortcuts." & @CR
	$About = $About & "Now press the [TAB] key to select the correct program to start." & @CR
	$About = $About & "Press [TAB] again, then [ENTER] to launch the selected application.        " & @CR & @CR & @CR
EndFunc


; create main GUI
createGUI()
; load settings
loadIni()
; configure hotkeys
setHotkeys()
; init list of shortcuts
readShortcuts()

While 1
	checkInput()
	$mainMsg = GuiGetMsg()
	$trayMsg = TrayGetMsg()
	Select
		Case $trayMsg = $trayRestore
			popupApplication()
		Case $trayMsg = $trayReRead
            readShortcuts()
		Case $trayMsg = $trayConfig
            openConfig()
        Case $trayMsg = $trayAbout
            Msgbox(64,$AppTitle & " - About",$About)
		Case $trayMsg = $trayExit
            ExitLoop
		Case $mainMsg = $GUI_EVENT_MINIMIZE
			TraySetState(9)
            GUISetState(@SW_HIDE)
		Case $mainMsg = $GUI_EVENT_CLOSE
			ExitLoop
		Case $mainMsg = $Button_1
			if GUICtrlRead($Combo_2) <> "" Then
				startLink(GUICtrlRead($Combo_2))
			ElseIf GUICtrlRead($Input_1) <> "" Then
				startProg(GUICtrlRead($Input_1))
			EndIf
		Case Else
			;;;
	EndSelect
WEnd

; delete ini file if not to be saved
If Not $SaveConfig Then
	If FileExists($AppIni) Then FileDelete($AppIni)
EndIf
	
GUIDelete()	
Exit
