#cs
AutoIt Version: 3.1.1.113
Author:         gamerman2360
Script Function:
	Hides individual windows.
#ce

#region ChangeTheseVars
;$pass = 'pass'; Comment out if no pass, not case sensitive

; **$HotKey moved to the OnAutoItStart function
#endregion

#Region Compiler directives section
#Compiler_Prompt=n
;** AUTOIT3 settings
#Compiler_AUTOIT3=c:\Program file\AutoIt3\beta\AutoIt3.exe
;** AUT2EXE settings
#Compiler_AUT2EXE=
#Compiler_Icon=
#Compiler_OutFile= 
#Compiler_Compression=1
#Compiler_Allow_Decompile=n
#Compiler_PassPhrase=
;** Target program Resource info
#Compiler_Res_Comment=This program is liable to completely mess up in its current stage.
#Compiler_Res_Description=Hides individual windows.
#Compiler_Res_Fileversion=0.8.2
#Compiler_Res_LegalCopyright=gamerman2360
; free form resource fields ... max 15
;#Compiler_Res_Field=Name|Value  ;Free format fieldname|fieldvalue
; AU3CHECK settings
#Compiler_Run_AU3Check=y
#Compiler_AU3Check_Dat=C:\Program Files\AutoIt3\SciTe\Defs\unstable\Au3Check\au3check.dat
; RUN BEFORE AND AFTER definitions
; The following directives can contain:
;   %in% , %out%, %icon% which will be replaced by the fullpath\filename.
;   %scriptdir% same as @ScriptDir and %scriptfile% = filename without extension.
#Compiler_Run_Before=           ;process to run before compilation - you can have multiple records that will be processed in sequence
#Compiler_Run_After=            ;process to run After compilation - you can have multiple records that will be processed in sequence
#EndRegion

Func OnAutoItStart()
	Opt("ExpandVarStrings", 1)
	Global $HotKey = "{F9}";, $splashImg = ""; (BMP, GIF, or JPG)
	If Not @Compiled Or $CmdLine[0] Then
		Global $helpmsg = "Once you have selected to use the hotkey," & @CRLF & _
				"you can press the '$HotKey$' key to hide any" & @CRLF & _
				"window.  Then you can come back to this" & @CRLF & _
				"window to show them again."
	EndIf
	#region Cmd Handler
	; Note: #NoTrayIcon is already used in the tray setup area,
	;  it will be in affect even now because it is one of those
	;  things autoit executes before the script is run.
	For $i = 1 To $CmdLine[0]
		Switch $CmdLine[$i]
		Case "/ToolTip", "/ReadMe", "/?"
			If $CmdLine[$i] == "/ToolTip" Then; Displays the message in a tooltip, then exits
				If $CmdLine[0] > $i Then; If the next parameter is a number, use it as sleep time(ms)
					If $CmdLine[$i + 1] == Number($CmdLine[$i + 1]) Then $sleep = Number($CmdLine[$i + 1])
				EndIf
				If Not IsDeclared("sleep") Then $sleep = 15000
				ToolTip($helpmsg, 10, 10)
				Sleep($sleep)
				Exit
			ElseIf $CmdLine[$i] == "/ReadMe" Or $CmdLine[$i] == "/?" Then; Just something fun to add
				Run("notepad.exe"); Writes the message to an untitled notepad, then exits
				WinWaitActive("Untitled - Notepad")
				BlockInput(1)
				$sendhelpmsg = StringReplace($helpmsg, "{", "{{}"); So it dosn't end up sending the hotkey
				$sendhelpmsg = StringReplace($sendhelpmsg, @CRLF, "{ENTER}")
				ControlSend("Untitled - Notepad", "", "Edit1", $sendhelpmsg)
				BlockInput(0)
				ControlSetText("Untitled - Notepad", "", "Edit1", $helpmsg); Make sure it sent corectly
				;ControlDisable("Untitled - Notepad", "", "Edit1"); Nvm, makes it hard to read
				Exit
			EndIf
		Case "/NoTrayIcon"
			Global $NoTrayIcon
		EndSwitch
	Next
	#endregion
	If IsDeclared("splashImg") Then
		SplashImageOn("Splash Screen", $splashImg, 300, 255, Default, Default, 1)
		Sleep(4000)
		SplashOff()
	EndIf
	ProcessSetPriority(@AutoItPID, 0)
	AdlibEnable("AdlibFunc", 60000); Refreashes list every minuite
	#cs No need for hotkeys yet
	#region HotKeySetup
	For $i = 2 To 11
		HotKeySet("{F" & $i & "}", "HotKeyFunc")
	Next
	#endregion
	#ce
EndFunc

#region Tray Setup
#NoTrayIcon
If Not IsDeclared("NoTrayIcon") Then
	Opt("TrayMenuMode", 1)
	Opt("TrayOnEventMode", 1)
	$TIexit = TrayCreateItem("&Exit")
	TrayItemSetOnEvent(-1, "TrayMenuFunc")
	TraySetOnEvent(-13, "TRAY_EVENT_PRIMARYDOUBLE")
	TraySetIcon("C:\WINDOWS\system32\shell32.dll", 34); The desktop icon
	TraySetClick(8); Right click
	TraySetState()
EndIf
TraySetToolTip("0 hidden windows.")
#endregion

#region GUI Setup, needs Opt-'ExpandVarStrings' to equal 1
Opt("GUICloseOnESC", 0)
$GUItitle = "Hidden Windows"; The next three vars are used more than once
$GUIwidth = 622
$GUIheight = 441
GUICreate($GUItitle, $GUIwidth, $GUIheight, (@DesktopWidth-$GUIwidth)/2, (@DesktopHeight-$GUIheight)/2)
$GUIhandle = WinGetHandle($GUItitle)
$GUIwidth += 6; For some reason windows finds height and width differently
$GUIheight += 32; I guess it has something to do with the window boarders
$List = GUICtrlCreateListView("", 8, 8, 609, 383, 23); LVS_LIST + LVS_SINGLESEL + LVS_SHOWSELALWAYS + LVS_SORTASCENDING
$Show = GUICtrlCreateButton("Show", 16, 400, 57, 33, 1); BS_DEFPUSHBUTTON
GUICtrlSetTip(-1, "Shows a window.")
$Refreash = GUICtrlCreateButton("Refreash", 78, 400, 57, 33)
GUICtrlSetTip(-1, "Checks the window names and perges closed windows.  Uses 'sort.exe'.")
$HotKeySet = GUICtrlCreateCheckbox("Set Hotkey", 536, 400, 73, 25)
GUICtrlSetTip(-1, "Sets the key $HotKeyName$ to hide windows.  Uses RegisterHotKey in 'user32.dll'.")
GUISetBkColor(Default)
If @Compiled Then; Dosn't work when not compiled, can't run the script more than once
	GUISetHelp("""" & @ScriptFullPath & """ /ToolTip")
	;GUISetHelp("""" & @ScriptFullPath & """ /ReadMe"); More of an autoitly way to display a help statement
Else
	$sleeptime = 15000
	GUISetHelp(@AutoItExe & ' /AutoIt3ExecuteLine "$help = Opt(''TrayIconHide'', 1) & ToolTip(''' & $helpmsg & ''', 10, 10) & Sleep(15000)"')
EndIf
#endregion

#region Main Loop
Opt("WinTitleMatchMode", 3)
Global $hiddenwindows = 0
#cs $hiddenwindows notes
$hiddenwindows[$i][0] = ($i window's handle)
$hiddenwindows[$i][1] = ($i window's ListView Item)
GUICtrlRead($hiddenwindows[$i][1]) = ($i window's title)
The following expresses if $hiddenwindows has any windows
	IsArray($hiddenwindows); Probably the best way
	Not IsNumber($hiddenwindows)
	$hiddenwindows <> 0
Basiclly when there are no windows left it should be replaced with a number 0
For some reason when you try to evaluate an array, it comes to false...
#ce
While True
	Switch GuiGetMsg()
	Case 0, -4 To -13; All non-control events, except GUI_EVENT_CLOSE
		If ConsoleRead(Default, True) Then
			$consoleread = StringSplit(ConsoleRead(), @CRLF, 1)
			For $i In $consoleread
				If $i == $consoleread[0] Then ContinueLoop; Skip 0
				If $i == "" Then ContinueLoop
				Hide($i)
			Next
		EndIf
		ContinueLoop
	Case -3; GUI_EVENT_CLOSE
		GUISetState(@SW_HIDE); Exit using the tray icon instead
	Case $HotKeySet
		If GUICtrlRead($HotKeySet) == 1 Then
			HotKeySet($HotKey, "Hide")
		Else
			HotKeySet($HotKey)
		EndIf
	Case $Show; Show the selected window
		If Not IsArray($hiddenwindows) Then ContinueLoop; Nothing is there
		$selected = GUICtrlRead($List)
		If $selected == 0 Then ContinueCase
		For $i = 0 To UBound($hiddenwindows)-1; Searches $hiddenwindows to see which window is selected
			If $hiddenwindows[$i][1] == $selected Then
				WinSetState($hiddenwindows[$i][0], "", @SW_SHOW)
				Sleep(330); Act like it's activation was part of the flash
				WinActivate($GUIhandle)
				WinFlash($hiddenwindows[$i][0], "", 3)
				GUICtrlDelete($selected)
				$hiddenwindows = _DeleteX2D($hiddenwindows, $i)
				ExitLoop
			EndIf
		Next
		TraySetToolTip(UBound($hiddenwindows) & " hidden windows.")
		ContinueCase
	Case $Refreash; Gets name changes
		If Not IsArray($hiddenwindows) Then ContinueLoop
		For $i = 0 To UBound($hiddenwindows) - 1
			If WinGetTitle($hiddenwindows[$i][1]) <> GUICtrlRead($hiddenwindows[$i][1]) Then
				$changedtitle = WinGetTitle($hiddenwindows[$i][1])
				If $changedtitle == 0 Then; Bad window
					_DeleteX($hiddenwindows, $i)
					ContinueLoop
				EndIf
				GUICtrlSetData($hiddenwindows[$i][1], $changedtitle)
			EndIf
		Next
	EndSwitch
WEnd
#endregion

Func Hide($console)
	If Not IsDeclared("console") Then $console = ""; HotKey or Counsole input?
	$handle = WinGetHandle($console); If Hotkey, get active window
	$title = WinGetTitle($handle)
	If $handle == $GUIhandle Then Return GUISetState(@SW_HIDE); If it is my GUI just hide it
	If $hiddenwindows == 0 Then
		Dim $hiddenwindows[1][2]
		$hiddenwindows[0][0] = $handle
		$hiddenwindows[0][1] = GUICtrlCreateListViewItem($title, $List)
	Else
		ReDim $hiddenwindows[UBound($hiddenwindows) + 1][2]
		$hiddenwindows[UBound($hiddenwindows)-1][0] = $handle
		$hiddenwindows[UBound($hiddenwindows)-1][1] = GUICtrlCreateListViewItem($title, $List)
	EndIf
	WinSetState($handle, "", @SW_HIDE)
	TraySetToolTip(UBound($hiddenwindows) & " hidden windows.")
EndFunc

Func _DeleteX2D($array, $Xelement2skip); Deletes a row from a 2D array; 0-based
	If UBound($array) <= 1 Then Return 0
	Dim $newarray[UBound($array) - 1][UBound($array, 2)]
	For $x = 0 To UBound($array) - 1
		For $y = 0 To UBound($array, 2) - 1
			If $x == $Xelement2skip Then
				ContinueLoop
			ElseIf $x > $Xelement2skip Then
				$currentx = $x - 1
			Else
				$currentx = $x
			EndIf
			$newarray[$currentx][$y] = $array[$x][$y]
		Next
	Next
	Return $newarray
EndFunc

Func AdlibFunc(); AdlibEnable on line 96
	If BitAND(WinGetState($GUIhandle), 2) Then
		ControlClick($GUIhandle, "", $Refreash); Update the list
	EndIf
EndFunc

Func HotKeyFunc()
	If WinActive($GUIhandle) Then
		Switch @HotKeyPressed
		Case "{F2}"
			;;;
		EndSwitch
	Else
		HotKeySet(@HotKeyPressed)
		Send(@HotKeyPressed)
		HotKeySet(@HotKeyPressed, "HotKeyFunc")
	EndIf
EndFunc

Func TRAY_EVENT_PRIMARYDOUBLE()
	If IsDeclared("pass") Then
		$input = InputBox("Open Menu", "Please type in the password.", "", " M")
		If Not $input == $pass Then Return MsgBox(0, "Nope", "Sorry, guess again...")
	EndIf
	WinMove($GUIhandle, "", (@DesktopWidth-$GUIwidth)/2,(@DesktopHeight-$GUIheight)/2, $GUIwidth, $GUIheight)
	GUISetState()
	WinActivate($GUIhandle)
EndFunc

Func TrayMenuFunc()
	Switch @TRAY_ID
	Case $TIexit
		If IsDeclared("pass") Then
			$input = InputBox("Open Menu", "Please type in the password.", "", " M")
			If Not $input == $pass Then Return MsgBox(0, "Nope", "Sorry, guess again...")
		EndIf
		Exit
	EndSwitch
EndFunc

Func OnAutoItExit()
	If @ExitMethod = 3 Or @ExitMethod = 4 Then Return; If the system is loging off or shuting down, skip it
	If Not IsDeclared("hiddenwindows") Then Return
	For $i = 0 To UBound($hiddenwindows) - 1
		WinSetState($hiddenwindows[$i][0], "", @SW_SHOW)
	Next
EndFunc