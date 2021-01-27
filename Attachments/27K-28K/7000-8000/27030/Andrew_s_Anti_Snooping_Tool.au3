#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=XIcon.ico
#AutoIt3Wrapper_outfile=Andrew's Anti Snooping Tool.exe
#AutoIt3Wrapper_Res_Description=Desktop Tool
#AutoIt3Wrapper_Res_Fileversion=5.6.0.48
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=y
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_AU3Check=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.12.1
	Author:         Andrew W
	
	Script Function:
	Hides windows with a few fun features.
	
#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
;Includes that we need for all of the functions
#include <Constants.au3>
#include <GUIConstants.au3>
#include <Misc.au3>
#include <Array.au3>
#include <_ChooseHotkey.au3>
#include <Process.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
;#Include <GuiList.au3>
;#Include <GuiTab.au3>
FileInstall("F:\aast\11-5-2008 AAST\Version 5\bsod1.jpg",@ScriptDir & "\bsod.jpg",1)
$dll = DllOpen("user32.dll")
Global $ProgramName = "Andrew's Anti Snooping Tool"
If _Singleton($ProgramName, 1) = 0 Then
	MsgBox(0, "Warning", "An occurence of " & $ProgramName & " is already running")
	Exit
EndIf
Opt("TrayMenuMode", 1)
Opt("WinWaitDelay", 0) ; Sets the winwaitdelay to 0 so the windows disappear immediately
Opt("OnExitFunc", "endscript")
Opt("WinTitleMatchMode", 2) ;sets the title match mode to match handles
Opt("MouseCoordMode",1)
Global $VersionNumber = "5.6.0.17"
AutoItWinSetTitle($ProgramName) ; sets the title so the program can't run two of itself
;sets and initiates the hotkeys
Global $ToggleOnHotKey = IniRead(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOn","^+q")
Global $ToggleOffHotKey = IniRead(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOff","^+w")
Global $ToggleOneHotKey = IniRead(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOne","^+a")
Global $ToggleGroupsHotKey=IniRead(@ScriptDir & "\Settings.ini","Hotkeys","ToggleGroups","^+z")
Global $ToggleStayToggleOnHotKey =IniRead(@ScriptDir & "\Settings.ini","Hotkeys","ToggleStayToggleOnHotkey","^+s")
HotKeySet($ToggleOnHotKey, "ToggleOn")
HotKeySet($ToggleOffHotKey, "ToggleOff")
HotKeySet($ToggleOneHotKey, "ToggleOne")
HotKeySet($ToggleGroupsHotKey, "ToggleGroups")
HotKeySet($ToggleStayToggleOnHotKey, "StayToggleOn")
;;;;;;;;;GLOBAL VARIABLES ;;;;;;;;;;;;
;variable to determine if the main function is currently running
Global $IsToggled = 0
Global $IsToggled2 = 0
Global $IsToggled3 = 0
Global $IsToggled4 = 0
Global $WindowListHidden[1]
Global $Settings[20][2] ; [x][0] is on/off, [x][1] is tray item
Global $Groups[1]
Global $Exceptions[1]
Global $GroupsListString
Global $GroupsHeight = 250
Global $exceptionHeight = 250
Global $ExceptionsListString
Global $FreezeObject = ""
Global $WindowList= WinList()
$PreviousWindowTemp = ""
;Loads the Previous Windows that are still hidden
$PreviousWindowTot = IniRead(@ScriptDir & "\Settings.ini", "HiddenWindows", "Total", 0)
If $PreviousWindowTot <> 0 Then
	;Changes total windows to one from the ini file
	$WindowListHidden[0] = $PreviousWindowTot
	For $x = $PreviousWindowTot To 1 Step -1
		$PreviousWindowTemp = IniRead(@ScriptDir & "\Settings.ini", "HiddenWindows", "Hidden Window" & $x, "")
		_ArrayAdd($WindowListHidden, HWnd($PreviousWindowTemp))
		IniDelete(@ScriptDir & "\Settings.ini", "HiddenWindows", "Hidden Window" & $x)
	Next
	IniWrite(@ScriptDir & "\Settings.ini", "HiddenWindows", "Total", 0)
EndIf

;Initiate the tray
$aboutitem = TrayCreateItem("About")
$helpitem = TrayCreateItem("Help")
$hotkeysitem = TrayCreateItem("Set Hotkeys")
TrayCreateItem("")
$exceptionsitem = TrayCreateItem("Exceptions")
$Groupsitem = TrayCreateItem("Groups")
TrayCreateItem("")
$optionsitem = TrayCreateMenu("Options")
$Settings[0][1] = TrayCreateItem("Stealth Mode", $optionsitem)
;$Settings[1][1] = TrayCreateItem("Password Protection", $optionsitem)
TrayCreateItem("", $optionsitem)
$Settings[2][1] = TrayCreateItem("Disable Sound", $optionsitem)
$Settings[3][1] = TrayCreateItem("Disable Music Only (XP Only)", $optionsitem)
;TrayCreateItem("", $optionsitem)
$Settings[4][1] = TrayCreateItem("Computer Crash", $optionsitem)
$Settings[5][1] = TrayCreateItem("Right Mouse Click On", $optionsitem)
;TrayCreateItem("", $optionsitem)
;$Settings[6][1] = TrayCreateItem("Disable Task Manager", $optionsitem)
;$Settings[7][1] = TrayCreateItem("Close Windows", $optionsitem)
$Settings[8][1] = TrayCreateItem("Game Mode", $optionsitem)
$Settings[9][1] = TrayCreateItem("Freeze", $optionsitem)
;$Settings[10][1] = TrayCreateItem("Stay Hidden (BETA) ", $optionsitem)
TrayCreateItem("")
$exititem = TrayCreateItem("Exit")
TraySetState()
TraySetToolTip($ProgramName)

;Loads the Previous Settings
$SettingsTemp = 0
For $x = 0 To 10
	$SettingsTemp = IniRead(@ScriptDir & "\Settings.ini", "Settings", "Setting " & $x, 0)
	$Settings[$x][0] = Number($SettingsTemp)
	Call("InitiateSettings", $x)
Next

$ExceptionsTemp = 0
$Exceptions[0] = IniRead(@ScriptDir & "\Settings.ini", "Exceptions", "Total", 0)
$exceptionHeight = 250 + ($Exceptions[0] * 20)
For $x = 1 To $Exceptions[0]
	$ExceptionsTemp = IniRead(@ScriptDir & "\Settings.ini", "Exceptions", "Exceptions " & $x, "")
	_ArrayAdd($Exceptions, String($ExceptionsTemp))
Next


$GroupsTemp = 0
$Groups[0] = IniRead(@ScriptDir & "\Settings.ini", "Groups", "Total", 0)
$GroupsHeight = 250 + ($Groups[0] * 20)
For $x = 1 To $Groups[0]
	$GroupsTemp = IniRead(@ScriptDir & "\Settings.ini", "Groups", "Groups " & $x, "")
	_ArrayAdd($Groups, String($GroupsTemp))
Next

;;;MAIN LOOP;;;;
While 1
	$msg = TrayGetMsg()
	Select
		Case $msg = 0
			Call("_ReduceMemory")
			if $Settings[5][0] = True Then
				Call("CheckRightClick")
			EndIf
			ContinueLoop
		Case $msg = $exititem
			ExitLoop
		Case $msg = $aboutitem
			Call("AboutProgram")
		Case $msg = $Settings[0][1] ;;STEALTH MODE
			Call("checkSettings", 0)
		Case $msg = $Settings[1][1];; PASSWORD PROTECTION
			Call("checkSettings", 1)
		Case $msg = $Settings[2][1];;DISABLE SOUND
			Call("checkSettings", 2)
		Case $msg = $Settings[3][1];; DISABLE MUSIC
			Call("checkSettings", 3)
		Case $msg = $Settings[4][1];;Computer Crash
			Call("checkSettings", 4)
		Case $msg = $Settings[5][1];; MOUSE CLICK ON
			Call("checkSettings", 5)
		Case $msg = $Settings[6][1];;DISABLE TASK MANAGER
			Call("checkSettings", 6)
		Case $msg = $Settings[8][1];;Game Mode
			Call("checkSettings", 8)
		Case $msg = $Settings[9][1];;Game Mode
			Call("checkSettings", 9)
		Case $msg = $Settings[10][1];;Stay On
			Call("checkSettings", 10)
		Case $msg = $exceptionsitem
			Call("ExceptionsCreate")
		Case $msg = $Groupsitem
			Call("GroupsCreate")
		Case $msg = $hotkeysitem
			Call("HotkeyChange")					
		Case $msg = $helpitem
			Call("Help")	
	EndSelect
WEnd
Exit


Func ToggleOn()
	;If it's not running then run
	If $IsToggled = 0 Or $IsToggled2 = 0 Or $IsToggled3 = 0 or $IsToggled4 =0 Then
		$IsToggled = 1
		Call("HotkeySetFuckUpInitiate",True)
		;Game Mode
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
		
		;Turns the progress bar on
		if $Settings[10][0] = False Then
			ProgressOn($ProgramName, "Activating.....", "0 percent")
		EndIf
		;gets the list of windows and puts it into $WindowList
		Global $WindowList = WinList()
		;loops through all the windows
		For $x = 1 To $WindowList[0][0]
			;updates the process bar with the % of items that we've gone through
			$percentage = Int($x / $WindowList[0][0] * 100)
			ProgressSet($percentage, $percentage & " percent")
			;determines if the window's title is not blank and the window is visible
			If $WindowList[$x][0] <> "" And BitAND(WinGetState($WindowList[$x][1]), 2) And $WindowList[$x][0] <> "Program Manager" And $WindowList[$x][0] <> "Windows Sidebar" And $WindowList[$x][0] <> "Windows Task Manager" And $WindowList[$x][0] <> "" Then
				If Call("CheckExceptions", $WindowList[$x][0]) = False Then
					_ArrayAdd($WindowListHidden, $WindowList[$x][1])
					$WindowListHidden[0] = $WindowListHidden[0] + 1					
					WinSetState($WindowList[$x][1], "", @SW_HIDE)
				EndIf
			EndIf
		Next
		if $Settings[10][0] = False Then
			ProgressSet(100, "100%", "Activation Complete")
			ProgressOff()
		EndIf
		
		if $Settings[9][0] = True Then
			Call("FreezeScreen",True)
		EndIf
		If $Settings[0][0] = True Then
			TraySetState(2)
		EndIf
		If $Settings[2][0] = True Then
			Send("{VOLUME_MUTE}")
		EndIf
		If $Settings[3][0] = True Then
			SoundSetWaveVolume(0)
		EndIf
		If $Settings[4][0] = True Then
			Call("computerCrash", True)
		EndIf
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
		Call("HotkeySetFuckUpInitiate",False)
		$IsToggled = 0
	EndIf
EndFunc   ;==>ToggleOn


;;Hides all windows except ones listed in the groups
Func ToggleGroups()
	;If it's not running then run
	If $IsToggled = 0 Or $IsToggled2 = 0 Or $IsToggled3 = 0 or $IsToggled4 =0 Then
		$IsToggled4 = 1
		Call("HotkeySetFuckUpInitiate",True)
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
		;Turns the progress bar on
		ProgressOn($ProgramName, "Activating.....", "0 percent")
		;gets the list of windows and puts it into $WindowList
		Global $WindowList = WinList()
		;loops through all the windows
		For $x = 1 To $WindowList[0][0]
			;updates the process bar with the % of items that we've gone through
			$percentage = Int($x / $WindowList[0][0] * 100)
			ProgressSet($percentage, $percentage & " percent")
			;determines if the window's title is not blank and the window is visible
			If $WindowList[$x][0] <> "" And BitAND(WinGetState($WindowList[$x][1]), 2) And $WindowList[$x][0] <> "Program Manager" And $WindowList[$x][0] <> "Windows Sidebar" And $WindowList[$x][0] <> "Windows Task Manager" And $WindowList[$x][0] <> "" Then
				If Call("CheckGroups", $WindowList[$x][0]) = True Then
					_ArrayAdd($WindowListHidden, $WindowList[$x][1])
					$WindowListHidden[0] = $WindowListHidden[0] + 1					
					WinSetState($WindowList[$x][1], "", @SW_HIDE)
				EndIf
			EndIf
		Next
		ProgressSet(100, "100%", "Activation Complete")
		ProgressOff()
		if $Settings[9][0] = True Then
			Call("FreezeScreen",True)
		EndIf
		If $Settings[0][0] = True Then
			TraySetState(2)
		EndIf
		If $Settings[2][0] = True Then
			Send("{VOLUME_MUTE}")
		EndIf
		If $Settings[3][0] = True Then
			SoundSetWaveVolume(0)
		EndIf
		If $Settings[4][0] = True Then
			Call("computerCrash", True)
		EndIf
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
	
		Call("HotkeySetFuckUpInitiate",False)
		$IsToggled4 = 0
	EndIf
EndFunc   ;==>ToggleOn


;;Hides the active window
Func ToggleOne()
	If $IsToggled = 0 Or $IsToggled2 = 0 Or $IsToggled3 = 0 or $IsToggled4 =0 Then
		$IsToggled3 =1
		Call("HotkeySetFuckUpInitiate",True)
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
		$WindowName = WinGetTitle("")
        Local $WindowHandle = WinGetHandle($WindowName)
		If $WindowHandle <> "" And BitAND(WinGetState($WindowHandle), 2) And $WindowHandle <> "Program Manager" And $WindowHandle <> "Windows Sidebar" And $WindowHandle <> "Windows Task Manager" Then
			If Call("CheckExceptions", $WindowHandle) = False Then
				_ArrayAdd($WindowListHidden, $WindowHandle)
				$WindowListHidden[0] = $WindowListHidden[0] + 1					
				WinSetState($WindowHandle, "", @SW_HIDE)
			EndIf
		EndIf
		if $Settings[9][0] = True Then
			Call("FreezeScreen",True)
		EndIf
		If $Settings[0][0] = True Then
			TraySetState(2)
		EndIf
		if $Settings[8][0] = True Then
			Send("{#}{TAB}")
			MouseClick("")
		EndIf
		If $Settings[2][0] = True Then
			Send("{VOLUME_MUTE}")
		EndIf
		If $Settings[3][0] = True Then
			SoundSetWaveVolume(0)
		EndIf
		$IsToggled3=0
		Call("HotkeySetFuckUpInitiate",False)
	EndIf
EndFunc

	


Func ToggleOff()
	;If it's not running then run
	If $IsToggled = 0 Or $IsToggled2 = 0 Or $IsToggled3 = 0 or $IsToggled4 =0 Then
		$IsToggled2 = 1
		Call("HotkeySetFuckUpInitiate",True)
			if $Settings[10][0] = True Then
				Call("checkSettings", 10)
			EndIf
		For $x = UBound($WindowListHidden, 1) - 1 To 1 Step -1
			;hides the window
			WinSetState($WindowListHidden[$x], "", @SW_SHOW)
			;deletes the window from the list
			_ArrayPop($WindowListHidden)
		Next
		$WindowListHidden[0] = 0
		If $Settings[0][0] = True Then
			TraySetState(1)
		EndIf
		If $Settings[2][0] = True Then
			Send("{VOLUME_MUTE}")
		EndIf
		If $Settings[3][0] = True Then
			SoundSetWaveVolume(100)
		EndIf
		if $Settings[9][0] = True Then
			Call("FreezeScreen",False)
		EndIf
		If $Settings[4][0] = True Then
			Call("computerCrash", False)
		EndIf
		Call("HotkeySetFuckUpInitiate",False)
		$IsToggled2 = 0
	EndIf
EndFunc   ;==>ToggleOff

;Function to execute when the program is closed
Func endscript()
	If $WindowListHidden[0] <> 0 Then
		IniWrite(@ScriptDir & "\Settings.ini", "HiddenWindows", "Total", $WindowListHidden[0])
		For $x = UBound($WindowListHidden, 1) - 1 To 1 Step -1
			IniWrite(@ScriptDir & "\Settings.ini", "HiddenWindows", "Hidden Window" & $x, $WindowListHidden[$x])
		Next
	EndIf
	FileDelete(@ScriptDir & "\bsod.jpg")
EndFunc   ;==>endscript

Func _ReduceMemory($i_PID = -1)
	If $i_PID <> -1 Then
		Local $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $i_PID)
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', $ai_Handle[0])
		DllCall('kernel32.dll', 'int', 'CloseHandle', 'int', $ai_Handle[0])
	Else
		Local $ai_Return = DllCall("psapi.dll", 'int', 'EmptyWorkingSet', 'long', -1)
	EndIf
	Return $ai_Return[0]
EndFunc   ;==>_ReduceMemory

Func AboutProgram()
	MsgBox(64, "About:" & $ProgramName, $ProgramName & @CRLF & "Version Number: " & $VersionNumber & @CRLF & @CRLF & "© 2005-2008 Andrew's Hangout.com. All rights reserved. " & $ProgramName & " and the " & $ProgramName & " logo are either impending registered trademarks or trademarks of Andrew's Hangout.com in the United States and/or other countries.")
EndFunc   ;==>AboutProgram

;Changes the setting to its opposite and saves the settings to the ini
Func checkSettings($settingNum)
	$Settings[$settingNum][0] = Not $Settings[$settingNum][0]
	If $Settings[$settingNum][0] = True Then
		TrayItemSetState($Settings[$settingNum][1], $TRAY_CHECKED)
		IniWrite(@ScriptDir & "\Settings.ini", "Settings", "Setting " & $settingNum, 1)
	Else
		TrayItemSetState($Settings[$settingNum][1], $TRAY_UNCHECKED)
		IniWrite(@ScriptDir & "\Settings.ini", "Settings", "Setting " & $settingNum, 0)
	EndIf
EndFunc   ;==>checkSettings

;Initiates the checks next to the options so the options that are turned on are checked when the program turns on
Func InitiateSettings($settingNum)
	If $Settings[$settingNum][0] = 1 Then
		TrayItemSetState($Settings[$settingNum][1], $TRAY_CHECKED)
		$Settings[$settingNum][0] = True
	Else
		TrayItemSetState($Settings[$settingNum][1], $TRAY_UNCHECKED)
		$Settings[$settingNum][0] = False
	EndIf
EndFunc   ;==>InitiateSettings


;;Creates the list of exceptions
Func ExceptionsCreate()
	$tempException = ""
	While $tempException <> -1
		$ExceptionsListString = ""
		For $x = 1 To UBound($Exceptions, 1) - 1 Step 1
			If $Exceptions[$x] <> "" Then
				$ExceptionsListString = $ExceptionsListString & @CRLF & $Exceptions[$x]
			EndIf
		Next
		$tempException = InputBox($ProgramName, "Please enter in the partial title of the window you want to keep displayed" & @CRLF & @CRLF & "When you are finished enter in -1 " & @CRLF & @CRLF & "Enter in -2 to delete your last addition" & @CRLF & @CRLF & "Items: " & @CRLF & $ExceptionsListString, "", "", 300, $exceptionHeight)
		If $tempException = -2 Then
			If $Exceptions[0] > 0 Then
				IniDelete(@ScriptDir & "\Settings.ini", "Exceptions", "Exceptions " & $Exceptions[0])
				_ArrayPop($Exceptions)
				$Exceptions[0] = $Exceptions[0] - 1
				$exceptionHeight = $exceptionHeight - 20
			Else
				ExitLoop
			EndIf
		ElseIf $tempException = -1 Or $tempException = "" Then
			ExitLoop
		Else
			_ArrayAdd($Exceptions, $tempException)
			$Exceptions[0] = $Exceptions[0] + 1
			IniWrite(@ScriptDir & "\Settings.ini", "Exceptions", "Exceptions " & $Exceptions[0], $tempException)
			$exceptionHeight = $exceptionHeight + 20
		EndIf
	WEnd
	IniWrite(@ScriptDir & "\Settings.ini", "Exceptions", "Total", $Exceptions[0])
EndFunc   ;==>ExceptionsCreate


;;Creates the list of groups
Func GroupsCreate()
	$tempGroup = ""
	While $tempGroup <> -1
		$GroupsListString = ""
		For $x = 1 To UBound($Groups, 1) - 1 Step 1
			If $Groups[$x] <> "" Then
				$GroupsListString = $GroupsListString & @CRLF & $Groups[$x]
			EndIf
		Next
		$tempGroup = InputBox($ProgramName, "Please enter in the partial title of the window you don't want to keep displayed" & @CRLF & @CRLF & "When you are finished enter in -1 " & @CRLF & @CRLF & "Enter in -2 to delete your last addition" & @CRLF & @CRLF & "Items: " & @CRLF & $GroupsListString, "", "", 300, $GroupsHeight)
		If $tempGroup = -2 Then
			If $Groups[0] > 0 Then
				IniDelete(@ScriptDir & "\Settings.ini", "Groups", "Groups " & $Groups[0])
				_ArrayPop($Groups)
				$Groups[0] = $Groups[0] - 1
				$GroupsHeight = $GroupsHeight - 20
			Else
				ExitLoop
			EndIf
		ElseIf $tempGroup = -1 Or $tempGroup = "" Then
			ExitLoop
		Else
			_ArrayAdd($Groups, $tempGroup)
			$Groups[0] = $Groups[0] + 1
			IniWrite(@ScriptDir & "\Settings.ini", "Groups", "Groups " & $Groups[0], $tempGroup)
			$GroupsHeight = $GroupsHeight + 20
		EndIf
	WEnd
	IniWrite(@ScriptDir & "\Settings.ini", "Groups", "Total", $Groups[0])
EndFunc   ;==>ExceptionsCreate

;;Checks to see if the title is one of the exceptions
Func CheckExceptions($title)
	For $y = 1 To $Exceptions[0]
		If StringInStr($title, $Exceptions[$y]) > 0 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckExceptions

;;Checks to see if the title is one of the items in the group
Func CheckGroups($title)
	ConsoleWrite($Groups[0])
	For $x = 1 To $Groups[0]
		ConsoleWrite($x)		
		If StringInStr($title, $Groups[$x]) > 0 Then
			Return True
		EndIf
	Next
	Return False
EndFunc   ;==>CheckExceptions

;;Empty Function
Func HotkeySetFuckUp()
EndFunc   ;==>HotkeySetFuckUp


;;;
Func computerCrash($status)
	if $status = true Then
		SplashImageOn("", @ScriptDir & "/bsod.jpg",@DesktopWidth,@DesktopHeight,-1,-1,1)
		MouseMove(@DesktopWidth+20,@DesktopHeight+20,0)
		_WinAPI_Beep(500, 6000)
	Else
		SplashOff()
	EndIf
	
EndFunc   ;==>computerCrash


;;;Hides all the windows then takes a screenshot and simulates computer freeze until Toggle Off is pressed
Func FreezeScreen($status)
	if $status = True Then
		$mousepos = MouseGetPos()
		MouseMove(@DesktopWidth+20,@DesktopHeight+20,0)
		$FreezeObject=_ScreenCapture_Capture(@ScriptDir & "/Freeze.jpg")
		SplashImageOn("", @ScriptDir & "/Freeze.jpg",@DesktopWidth,@DesktopHeight,-1,-1,1)
		MouseMove($mousepos[0],$mousepos[1],0)
	Else
		SplashOff()
		_WinAPI_DeleteObject($FreezeObject)
	EndIf
EndFunc


;;;disable hotkeys so if you press twice you don't interupt
Func HotkeySetFuckUpInitiate($status)	
	if $status = true Then
		HotKeySet($ToggleOnHotKey, "HotkeySetFuckUp")
		HotKeySet($ToggleOffHotKey, "HotkeySetFuckUp")
		HotKeySet($ToggleOneHotKey, "HotkeySetFuckUp")
		HotKeySet($ToggleGroupsHotKey, "HotkeySetFuckUp")
	Else
		HotKeySet($ToggleOnHotKey, "ToggleOn")
		HotKeySet($ToggleOffHotKey, "ToggleOff")
		HotKeySet($ToggleOneHotKey, "ToggleOne")
		HotKeySet($ToggleGroupsHotKey, "ToggleGroups")
	EndIf
EndFunc


;;;Right click on the X of a window to hide it
Func CheckRightClick()
	Opt("MouseCoordMode",0)
	$size = WinGetPos("[active]")
	ConsoleWrite($size[2] & " " & $size[3])
	ConsoleWrite(@CRLF)
	$mousepos = MouseGetPos()
	ConsoleWrite($mousepos[0] & " " & $mousepos[1])
	ConsoleWrite(@CRLF)
	If $mousepos[0] > $size[2]-55  And $mousepos[1] <25 Then	
		if _IsPressed("02", $dll) Then
			Call("ToggleOne")
		EndIf
	EndIf
	Opt("MouseCoordMode",1)
EndFunc


;;Keep Windows Hidden
Func StayToggleOn()
	$IsToggled2 = 1
	If $IsToggled = 0 Or $IsToggled2 = 0 Or $IsToggled3 = 0 or $IsToggled4 =0 Then
		while $IsToggled2 = 1
			Sleep(200)
			Global $WindowList = WinList()
			;loops through all the windows
			For $x = 1 To $WindowList[0][0]
				If $WindowList[$x][0] <> "" And BitAND(WinGetState($WindowList[$x][1]), 2) And $WindowList[$x][0] <> "Program Manager" And $WindowList[$x][0] <> "Windows Sidebar" And $WindowList[$x][0] <> "Windows Task Manager" And $WindowList[$x][0] <> "" Then
					If Call("CheckExceptions", $WindowList[$x][0]) = False and $IsToggled2=1 Then
						$IsToggled = 1
						Call("HotkeySetFuckUpInitiate",True)
						_ArrayAdd($WindowListHidden, $WindowList[$x][1])
						$WindowListHidden[0] = $WindowListHidden[0] + 1					
						WinSetState($WindowList[$x][1], "", @SW_HIDE)
						Call("HotkeySetFuckUpInitiate",False)
						$IsToggled = 0
					EndIf
				EndIf
				if $IsToggled2 = 0 Then
					ExitLoop
				EndIf				
			Next
		WEnd
	EndIf
EndFunc

;;Change Hotkeys
Func HotkeyChange()
	MsgBox(0,$ProgramName,"Select the desired hotkey for Toggle On")
	$ToggleOnHotKey = _ChooseHotkey($ToggleOnHotKey)
	MsgBox(0,$ProgramName,"Select the desired hotkey for Toggle Off")
	$ToggleOffHotKey = _ChooseHotkey($ToggleOffHotKey)
	MsgBox(0,$ProgramName,"Select the desired hotkey for Toggle Selected")
	$ToggleOneHotKey = _ChooseHotkey($ToggleOneHotKey)
	MsgBox(0,$ProgramName,"Select the desired hotkey for Toggle Groups")
	$ToggleGroupsHotKey = _ChooseHotkey($ToggleGroupsHotKey)
	MsgBox(0,$ProgramName,"Select the desired hotkey for Stay Toggle On")
	$ToggleStayToggleOnHotKey = _ChooseHotkey($ToggleStayToggleOnHotKey)
	IniWrite(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOn",$ToggleOnHotKey)
	IniWrite(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOff",$ToggleOffHotKey)
	IniWrite(@ScriptDir & "\Settings.ini","Hotkeys","ToggleOne",$ToggleOneHotKey)
	IniWrite(@ScriptDir & "\Settings.ini","Hotkeys","ToggleGroups",$ToggleGroupsHotKey)
	IniWrite(@ScriptDir & "\Settings.ini","Hotkeys","StayToggleOn",$ToggleStayToggleOnHotKey)
	HotKeySet($ToggleOnHotKey, "ToggleOn")
	HotKeySet($ToggleOffHotKey, "ToggleOff")
	HotKeySet($ToggleOneHotKey, "ToggleOne")
	HotKeySet($ToggleGroupsHotKey, "ToggleGroups")
	HotKeySet($ToggleStayToggleOnHotKey, "StayToggleOn")
	MsgBox(0,$ProgramName,"Hotkeys Changed")
EndFunc

Func Help()
	MsgBox(0,$ProgramName,"Program: " & $ProgramName & @CRLF & "Purpose: To maintain your privacy by instantly hiding windows. Additional features are used to support this underlying feature. " & @CRLF & @CRLF & "Features: " & @CRLF & "Set Hotkeys: Change the hotkeys for each function" & @CRLF & "Exceptions: Keeps listed windows from being hidden" & @CRLF & "Groups: Hides only the listed windows" & @CRLF & @CRLF & "Options:" & @CRLF & "Stealth Mode: Hides tray icon" & @CRLF & "Disable Sound: Mutes the sound" & @CRLF & "Disable Music: Disables wav sounds ( XP Only)" & @CRLF & "Computer Crash: Simulates a blue screen of death" & @CRLF & "Right Mouse Click On: Right clicking the X will hide the window" & @CRLF & "Game Mode: Minimizes full screen games" & @CRLF & "Freeze: Simulates a 'frozen' computer" & @CRLF & @CRLF & "Hotkeys:" & @CRLF & "Toggle On: " & _HotKeyToString($ToggleOnHotKey) & @CRLF & "Hide Active Window: " & _HotKeyToString($ToggleOneHotKey) & @CRLF & "Toggle Groups: " & _HotKeyToString($ToggleGroupsHotKey) & @CRLF & "Toggle Stay Hidden: " & _HotKeyToString($ToggleStayToggleOnHotKey) & @CRLF & "Toggle Off: " & _HotKeyToString($ToggleOffHotKey) & @CRLF & "")
EndFunc