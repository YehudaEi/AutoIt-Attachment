#Include <GUIConstants.au3>
#Include <Array.au3>
#Include <Date.au3>

#NoTrayIcon

; Ini file's settings
$ini = "Dorevo.ini"
$user_section = "UserDefinedCommands"
$pref_section = "Preferences"

; Get hotkey
$hk_hide = IniRead($ini, $pref_section, "HkHide", "^+l")
$hk_show = IniRead($ini, $pref_section, "HkShow", "^+k")
$hk_setdefpos = IniRead($ini, $pref_section, "HkSetDefPos", "^+j")

; Hotkey to show & hide application
HotKeySet($hk_hide, "HideApp")
HotKeySet($hk_show, "ShowApp")

; Redefine window match mode
Opt("WinTitleMatchMode", 2)
Opt("WinTextMatchMode", 1)

; Default values for main gui
$title = "Dorevo"
$width = 200
$height = 40
$left = IniRead($ini, $pref_section, "Left", (@DesktopWidth - $width) / 2)
$top = IniRead($ini, $pref_section, "Top", (@DesktopHeight - $height) / 2)

; Default values for console
$console_height = 20
$console_width  = $width
$newwidth = $width
$newheight  = $height

; Initialize some needed values 
$lastcontent = ""
$suggestion_showed = 0
$auto_clear = IniRead($ini, $pref_section, "AutoClearConsole", 1)

; Default commands
Dim $def_command[10]
$def_command[1] = "uptime"
$def_command[2] = "sysinfo"
$def_command[3] = "memstats"
$def_command[4] = "defpos"
$def_command[5] = "exit"
$def_command[6] = "wizard"

Dim $add_ok, $add_cancel, $add_label, $add_name, $suggestion_label
Dim $madd_file, $madd_folder, $madd_removeitem, $madd_label, $madd_cancel, $madd_save, $madd_list, $madd_count, $madd_name, $madd_label2
Dim $madd_item[1], $madd_array[1]


; Create gui & console
$gui = GuiCreate($title, $width, $height, $left, $top, $WS_CLIPSIBLINGS + $WS_SYSMENU, $WS_EX_ACCEPTFILES + $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
$console = GuiCtrlCreateInput("", 0, 0, $console_width, $console_height, $ES_AUTOHSCROLL + $GUI_FOCUS)
GUICtrlSetState ($console, $GUI_ACCEPTFILES)

; Show gui
GuiSetState(@SW_SHOW)
While 1
	; Get Console's content. Show suggestions if available
	$content = GuiCtrlRead($console)
	If $content <> $lastcontent Then
		$lastcontent = $content
		If $content <> "" Then
			ShowSuggestions()
		Else
			$suggestion_showed = 0
			WinScrollBack()
			GuiCtrlDelete($suggestion_label)
		EndIf
	EndIf
	; Get window's focus. Enable hotkey triggering if needed
	$focus = ControlGetFocus($title)
	If $focus = "Edit1" Then
		EnableApp()	
	Else
		DisableApp()	
	EndIf
	; Continuously get message from GUI
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $add_ok ; Add a new shortcut
		AddCommand()
	Case $msg = $add_cancel ; Cancel adding a new shortcut	
		CancelAddCommand()
	Case $msg = $madd_cancel ; Cancel adding a new shortcut manually	
		CancelAddCommandManually()
	Case $msg = $madd_file ; Add a file manually
		AddFile()
	Case $msg = $madd_folder ; Add a folder manually
		AddFolder()
	Case $msg = $madd_save ; Process
		ProcessAddCommandManually()
		GuiAddCommand()
	EndSelect
WEnd
Exit

; Enable hotkey triggering
Func EnableApp()
	HotKeySet("{Enter}", "RunSimul")
	HotKeySet("{Esc}", "ClearConsole")
	HotKeySet("^{Enter}", "GuiAddCommand")
	HotKeySet("{Right}", "AutoComplete")
EndFunc

; Disable hotkey triggering
Func DisableApp()
	HotKeySet("{Enter}")
	HotKeySet("{Esc}")
	HotKeySet("^{Enter}")
	HotKeySet("{Right}")
EndFunc

; Show application
Func ShowApp()
	GuiSetState(@SW_SHOW)
	EnableApp()
EndFunc

; Hide application
Func HideApp()
	GuiSetState(@SW_HIDE)
	DisableApp()
EndFunc

; AutoComplete activated when pressing Right arrow
Func AutoComplete()
	$temp = GuiCtrlRead($suggestion_label)
	If $temp <> "" Then
		GuiCtrlSetData($console, $temp)
	EndIf
EndFunc

; Show possible shortcut name suggestions
Func ShowSuggestions()
	Dim $suggestion[1]
	$array = IniReadSection($ini, $user_section)
	If Not @Error Then
		For $i = 1 To $array[0][0] 
			If StringInStr($array[$i][0], $content) = 1Then
				ReDim $suggestion[UBound($suggestion) + 1]
				$suggestion[UBound($suggestion) - 1] = $array[$i][0]
			EndIf
		Next
		For $i = 1 To UBound($def_command) - 1 
			If StringInStr($def_command[$i], $content) = 1Then
				ReDim $suggestion[UBound($suggestion) + 1]
				$suggestion[UBound($suggestion) - 1] = $def_command[$i]
			EndIf
		Next
		_ArraySort($suggestion, 0, 1)
		If ($suggestion_showed = 0) And (UBound($suggestion) > 1) Then 
			WinScroll(0, 35)
			$suggestion_label = GuiCtrlCreateLabel($suggestion[1], 5, $console_height + 10)
		ElseIf UBound($suggestion) = 1 Then
			$suggestion_showed = 0
			WinScrollBack()
			GuiCtrlDelete($suggestion_label)
		ElseIf UBound($suggestion) > 1 Then
			GuiCtrlSetData($suggestion_label, $suggestion[1])
		EndIf
	EndIf
EndFunc

; Scroll down the window
Func WinScroll($right, $down)
	$inc = 0
	While $inc < $right
		$inc = $inc + 1
		WinMove($title, "", $left, $top, $width + $inc, $height)
	WEnd
	$newwidth = $width + $right
	$inc = 0
	While $inc < $down
		$inc = $inc + 1
		WinMove($title, "", $left, $top, $newwidth, $height + $inc)
	WEnd
	$newheight = $height + $down
EndFunc

; Scroll the window back to original position
Func WinScrollBack()
	$inc = 0
	While $inc < $newheight - $height + 1
		$inc = $inc + 1
		WinMove($title, "", $left, $top, $newwidth, $newheight - $inc)
	WEnd
	$newheight = $height
	$inc = 0
	While $inc < $newwidth - $width + 1
		$inc = $inc + 1
		WinMove($title, "", $left, $top, $newwidth - $inc, $height)
	WEnd
	$newwidth = $width
EndFunc

; Show a message using Scroll method
Func WinShowMsg($info, $right = 0, $down = 35, $delay = 2000)
	WinScroll($right, $down)
	$finish_label = GuiCtrlCreateLabel($info, 5, $console_height + 10)		
	Sleep($delay)
	WinScrollBack()
	GuiCtrlDelete($finish_label)
EndFunc

; Check if the user entered a pre-defined command or not
Func GetUserCommand(ByRef $command)
	$temp = IniRead($ini, $user_section, $command, "404 Not Found")
	If $temp = "404 Not Found" Then
		Return $command
	Else
		Return $temp
	EndIf
EndFunc

; Check if a file is executable or not
Func IsExecutable($file)
	If (StringInStr($file, ".exe") <> 0)_
	Or (StringInStr($file, ".bat") <> 0)_
	Or (StringInStr($file, ".com") <> 0)_
	Or (StringInStr($file, ".pif") <> 0)Then
		Return 1
	Else 
		Return 0
	EndIf
EndFunc

; Process a default command
Func ProcessDefaultCommand($command)
	Select
	Case $command = "uptime"
		ShowUptime()
	Case $command = "sysinfo"
		ShowSysInfo()
	Case $command = "memstats"
		ShowMemStats()
	Case $command = "defpos"
		GuiSetDefPos()
	Case $command = "exit"
		Exit	
	Case $command = "wizard"
		GuiAddCommandManually()	
	Case Else
		WinShowMsg("File or folder doesn't exists.")
	EndSelect
EndFunc

; Start a file or folder
Func RunSimul()
	WinScrollBack()
	$command = GuiCtrlRead($console)
	$command = StringSplit(GetUserCommand($command), '|')
	For $i = 1 To UBound($command) - 1 
		; If the command represents a group or file
		If ($command[$i] <> "") And (GuiCtrlGetState($console) <> 144) Then  ; 144 -> disable
			If FileExists($command[$i]) Then
				If StringInStr($command[$i], ".lnk") Then
					$details = FileGetShortcut($command[$i])
					$command[$i] = $details[0]
				EndIf
				If (StringInStr($command[$i], " ") <> 0) And (DirGetSize($command[$i]) = -1) Then
					$command[$i] = '"' & $command[$i] & '"'
				EndIf
				If DirGetSize($command[$i]) = -1 Then ; If it's a file
					Run(@ComSpec & " /c " & $command[$i], "", @SW_HIDE)
				ElseIf StringInStr($command[$i], " ") = 0 Then
					Run(@ComSpec & " /c Start " & $command[$i], "", @SW_HIDE)
				EndIf
			ElseIf FileExists(@SystemDir & "\" & $command[$i] & ".exe") Or FileExists(@WindowsDir & "\" & $command[$i] & ".exe") Then ; If it's a folder
				Run($command[$i]) 
			Else 
				ProcessDefaultCommand($command[$i])
			EndIf
		EndIf		
	Next
	If $auto_clear = 1 Then 
		ClearConsole()
	EndIf
EndFunc

; Clear the console
Func ClearConsole()
	GuiCtrlSetData($console, "")
EndFunc

; Display Add Command dialog
Func GuiAddCommand()
	WinScrollBack()
	$command = GuiCtrlRead($console)
	$command = StringSplit($command, '|')
	$ok = 0
	For $i = 1 To UBound($command) - 1 
		If $command[$i] <> "" Then
			If (FileExists($command[$i])) Or (FileExists(@SystemDir & "\" & $command[$i] & ".exe")) Then
				$ok = 1
			EndIf
		EndIf
	Next
	If $ok Then
		GuiCtrlSetState($console, $GUI_DISABLE)
		WinScroll(140, 35)
		$add_label = GuiCtrlCreateLabel("Shortcut name: ", 5, $console_height + 10)
		$add_name = GuiCtrlCreateInput("", 80, $console_height + 5, 140, $console_height, $ES_AUTOHSCROLL)
		GuiCtrlSetState($add_name, $GUI_FOCUS)
		$add_ok = GuiCtrlCreateButton("Add", 225, $console_height + 3, 50)
		$add_cancel = GuiCtrlCreateButton("Cancel", 280, $console_height + 3, 50)
	Else
		WinShowMsg("File or folder doesn't exist.")
		If $auto_clear = 1 Then 
			ClearConsole()
		EndIf
	EndIf
EndFunc

; Check if a command exists or not
Func NotExists($command)
	$temp = IniRead($ini, $user_section, $command, "404 Not Found")
	If $temp = "404 Not Found" Then
		Return 1
	Else 
		Return 0
	EndIf	
EndFunc

; Add an user command
Func AddCommand()
	$command = GuiCtrlRead($console)
	If StringInStr($command, ".lnk") Then
		$details = FileGetShortcut($command)
		$command = $details[0]
	EndIf
	$shortcut_name = GuiCtrlRead($add_name)
	If ($shortcut_name <> "") And (NotExists($shortcut_name)) Then
		GuiCtrlSetState($console, $GUI_ENABLE + $GUI_ACCEPTFILES)
		If $auto_clear = 1 Then 
			ClearConsole()
		EndIf
		WinScrollBack()
		GuiCtrlDelete($add_name)
		GuiCtrlDelete($add_label)
		GuiCtrlDelete($add_ok)
		GuiCtrlDelete($add_cancel)
		If StringInStr($shortcut_name, " ") = 0 Then
			IniWrite($ini, $user_section, $shortcut_name, $command)
			WinShowMsg("Shortcut added.")
		Else
			$shortcut_name = StringReplace($shortcut_name, " ", "_")	
			IniWrite($ini, $user_section, $shortcut_name, $command)
			WinShowMsg("Shortcut added. Space(s) changed to underscore(s).", 70)
		EndIf
	EndIf
EndFunc

; Cancel adding a new command
Func CancelAddCommand()
	GuiCtrlSetState($console, $GUI_ENABLE + $GUI_ACCEPTFILES)
	WinScrollBack()
	GuiCtrlDelete($add_name)
	GuiCtrlDelete($add_label)
	GuiCtrlDelete($add_ok)
	GuiCtrlDelete($add_cancel)
EndFunc

; Show Windows uptime
Func ShowUptime()
	$h = 0
	$m = 0
	$s = 0
	$time = FileGetTime("C:\pagefile.sys", 0, 0)
	$start = _TimeToTicks($time[3], $time[4], $time[5])
	$finish = _TimeToTicks(@Hour, @Min, @Sec)
	$diff = $finish - $start
	_TicksToTime($diff, $h, $m, $s)
	WinShowMsg("Windows has been running for " & $h & " hour(s), " & Correct($m) & " minute(s) and " & Correct($s) & " second(s).", 155, 35, 3000)
EndFunc

; Correct uptime display
Func Correct(ByRef $value)
	If $value < 10 Then
		$value = String($value)
		$value = "0" & $value
	EndIf
	Return $value
EndFunc

; Show system's information
Func ShowSysInfo()
	$info = "Operating System: Windows "
	$temp = StringReplace(@OSVersion, "WIN_", "")
	$info = $info & $temp & " build " & @OSBUILD & " " & @OSServicePack & @CRLF
	$info = $info & "Desktop resolution: " & @DesktopWidth & "x" & @DesktopHeight & @CRLF
	$info = $info & "Desktop refresh rate: " & @DesktopRefresh & " Hertz" & @CRLF
	$info = $info & "Computer network name: " & @ComputerName & @CRLF
	$info = $info & "Current logged on user: " & @UserName 
	WinScroll(200, 90)
	$finish_label = GuiCtrlCreateLabel($info, 5, $console_height + 10, 300, 100)		
	Sleep(4000)
	GuiCtrlDelete($finish_label)
	WinScrollBack()
EndFunc

; Show memory's statistics
Func ShowMemStats()
	$mem = MemGetStats()
	$info = "Total physical RAM: " & $mem[1] & " KB" & @CRLF
	$info = $info & "Total pagefile: " & $mem[3] & " KB"  & @CRLF
	$info = $info & "Total virtual memory: " & $mem[5] & " KB"  & @CRLF
	$info = $info & "Available physical RAM: " & $mem[2] & " KB" & @CRLF
	$info = $info & "Available pagefile: " & $mem[4] & " KB"  & @CRLF
	$info = $info & "Available virtual memory: " & $mem[6] & " KB"  & @CRLF
	$info = $info & "Memory in use: " & $mem[0] & "%"  
	WinScroll(70, 115)
	$finish_label = GuiCtrlCreateLabel($info, 5, $console_height + 10, 200, 120)		
	Sleep(5000)
	GuiCtrlDelete($finish_label)
	WinScrollBack()
EndFunc

; Set default position after pressing hotkey
Func SetDefPos()
	$current_pos = MouseGetPos()	
	IniWrite($ini, $pref_section, "Left", $current_pos[0])
	IniWrite($ini, $pref_section, "Top", $current_pos[1])
	WinShowMsg("Default position set. Please restart " & $title & ".", 20)
	HotKeySet($hk_setdefpos)
EndFunc

; Show instructions to set default position
Func GuiSetDefPos()
	MouseMove($left, $top)
	WinShowMsg("Move your mouse to the new position, then press Ctrl + Shift + J.", 120)
	HotKeySet($hk_setdefpos, "SetDefPos")	
EndFunc

; Display Add Command Manually dialog
Func GuiAddCommandManually()
	WinScrollBack()
	GuiCtrlSetState($console, $GUI_DISABLE)
	WinScroll(117, 205)
	$madd_count = 0
	$madd_label = GuiCtrlCreateLabel("Available tasks: ", 5, $console_height + 10)
	$madd_file = GuiCtrlCreateButton("Add file", 85, $console_height + 3, 70)
	$madd_folder = GuiCtrlCreateButton("Add folder", 160, $console_height + 3, 70)
	$madd_removeitem = GuiCtrlCreateButton("Remove item", 235, $console_height + 3, 70)
	$madd_list = GuiCtrlCreateListView("Items", 5, $console_height + 32, 300, 110, $GUI_ACCEPTFILES + $LVS_SHOWSELALWAYS + $LVS_SINGLESEL)
	GuiCtrlSetState($madd_file, $GUI_FOCUS)
	$madd_cancel = GuiCtrlCreateButton("Cancel", 235, $console_height + 173, 70)
	$madd_save = GuiCtrlCreateButton("Save", 160, $console_height + 173, 70)
	$madd_label2 = GuiCtrlCreateLabel("Shortcut name: ", 5, $console_height + 149)
	$madd_name = GuiCtrlCreateInput("", 80, $console_height + 147, 225, $console_height, $ES_AUTOHSCROLL)
EndFunc

; Cancel adding a new command
Func CancelAddCommandManually()
	GuiCtrlSetState($console, $GUI_ENABLE + $GUI_ACCEPTFILES)
	WinScrollBack()
	GuiCtrlDelete($madd_label)
	GuiCtrlDelete($madd_file)
	GuiCtrlDelete($madd_folder)
	GuiCtrlDelete($madd_removeitem)
	GuiCtrlDelete($madd_cancel)
	GuiCtrlDelete($madd_save)
	GuiCtrlDelete($madd_list)
	GuiCtrlDelete($madd_name)
	GuiCtrlDelete($madd_label2)
EndFunc

; Add a file manually
Func AddFile()
	$file = FileSaveDialog("Select a file to add", "", "All (*.*)", 1)
	If (Not @Error) And (FileExists($file)) Then
		$madd_count = $madd_count + 1
		ReDim $madd_item[UBound($madd_item) + 1], $madd_array[UBound($madd_array) + 1]
		$madd_item[$madd_count] = GuiCtrlCreateListViewItem($file,$madd_list)
		$madd_array[$madd_count] = $file
	EndIf
EndFunc

; Add a folder manually
Func AddFolder()
	$folder = FileSelectFolder("Select a folder to add", "")
	If (Not @Error) And (StringInStr($folder, " ") = 0) Then
		$madd_count = $madd_count + 1
		ReDim $madd_item[UBound($madd_item) + 1], $madd_array[UBound($madd_array) + 1]
		$madd_item[$madd_count] = GuiCtrlCreateListViewItem($folder,$madd_list)
		$madd_array[$madd_count] = $folder
	EndIf
EndFunc

; Process AddCommandManually
Func ProcessAddCommandManually()
	$shortcut = GuiCtrlRead($madd_name)
	If $madd_count = 1 Then
		If ($shortcut <> "") And (NotExists($shortcut)) Then
			GuiCtrlSetState($console, $GUI_ENABLE + $GUI_ACCEPTFILES)
			WinScrollBack()
			If StringInStr($shortcut, " ") = 0 Then
				IniWrite($ini, $user_section, $shortcut, $madd_array[1])
				WinShowMsg("Shortcut added.")
			Else
				$shortcut = StringReplace($shortcut, " ", "_")	
				IniWrite($ini, $user_section, $shortcut, $madd_array[1])
				WinShowMsg("Shortcut added. Space(s) changed to underscore(s).", 70)
			EndIf
		EndIf	
	Else	
	EndIf
	GuiCtrlDelete($madd_label)
	GuiCtrlDelete($madd_file)
	GuiCtrlDelete($madd_folder)
	GuiCtrlDelete($madd_removeitem)
	GuiCtrlDelete($madd_cancel)
	GuiCtrlDelete($madd_save)
	GuiCtrlDelete($madd_list)
	GuiCtrlDelete($madd_name)
	GuiCtrlDelete($madd_label2)
EndFunc