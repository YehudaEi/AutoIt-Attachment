#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=commandprompt.exe
#AutoIt3Wrapper_Run_Tidy=y
#Tidy_Parameters=/rel
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
$StartScript = TimerInit()
$title = "Command Prompt_"
If WinExists($title) Then Exit
$t = FileGetTime(@ScriptFullPath)
$lastupdated = $t[1] & "/" & $t[2] & "/" & $t[0] & " @ " & $t[3] & ":" & $t[4] & ":" & $t[5]
#Region Header
#comments-start
	Title:			User Created Version of Command Prompt
	Filename:		Commandprompt.au3
	Description:	Command Prompt
	Author:			Bill Reithmeyer
	Version:		00.00.02
	Last Update:	07.19.08
	Requirements:	AutoIt v3.2 +, Developed/Tested on WindowsXP Pro Service Pack 2
#comments-end
#EndRegion Header
#include <EditConstants.au3>
#include <Misc.au3>
#include <Sound.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <GuiEdit.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <File.au3>
#Region ### SOURSES ###
If Not (IsDeclared("$cI_CompName")) Then
	Global $cI_CompName = @ComputerName
EndIf
Global $cI_VersionInfo = "00.03.08"
Global $cI_aName = 0, _
		$cI_aDesc = 4
Global $wbemFlagReturnImmediately = 0x10, _	;DO NOT CHANGE
		$wbemFlagForwardOnly = 0x20 ;DO NOT CHANGE
Global $ERR_NO_INFO = "Array contains no information", _
		$ERR_NOT_OBJ = "$colItems isnt an object"
Global $a_font, $1, $2, $3, $4, $free4, $used3
Dim $OSs, $NetworkCards, $Processors, $Battery
$settings = @ScriptDir & "\settings.ini"
$log = @ScriptDir & "\log.ini"
$cursor = @ScriptDir & "cursor.bmp"
$size = 8
$weight = IniRead($settings, "Font Settings", "Weight", 400)
$attr = IniRead($settings, "Font Settings", "Attr", 0)
$font = IniRead($settings, "Font Settings", "Font", "Lucida Console")
$color = IniRead($settings, "Font Settings", "Color", "0xC0C0C0")
$bcolor = IniRead($settings, "Font Settings", "BGColor", "0x000000")
$mem = MemGetStats()
$phy = Round($mem[1] / 1024, 0)
$aphy = Round($mem[2] / 1024, 0)
$pgfl = Round($mem[3] / 1024, 0)
$apgf = Round($mem[4] / 1024, 0)
$1 = _change($phy)
$2 = _change($aphy)
$3 = _change($pgfl)
$4 = _change($apgf)
$crlf = @CRLF & @CRLF
_ComputerGetOSs($OSs)
_ComputerGetNetworkCards($NetworkCards)
If @IPAddress1 = "127.0.0.1" Then
	$ip = "Disconnected"
Else
	$ip = @IPAddress1
EndIf
$DIR = @UserProfileDir & ">"
$A = $DIR
$A2 = "Usage: shutdown [/r | /s | /b | /l | /h ]" & $crlf & _
		@TAB & "  No args" & @TAB & "Display help. This is the same as typing /?." & @CRLF & _
		@TAB & "  /?" & @TAB & @TAB & "Display help. This is the same as not typing any options." & @CRLF & _
		@TAB & "  /r" & @TAB & @TAB & "Shutdown and restart the computer." & @CRLF & _
		@TAB & "  /s" & @TAB & @TAB & "Shutdown the computer." & @CRLF & _
		@TAB & "  /b" & @TAB & @TAB & "Standby." & @CRLF & _
		@TAB & "  /l" & @TAB & @TAB & "Log off." & @CRLF & _
		@TAB & "  /h" & @TAB & @TAB & "Hibernate the local computer." & $crlf
$A3 = "Type LIST to see list of runnable programs." & @CRLF & _
		"run>"
$A4 = "MSPAINT" & @TAB & @TAB & "Microsoft Paint" & @CRLF & _
		"NOTEPAD" & @TAB & @TAB & "Open notepad" & @CRLF & _
		"CALC" & @TAB & @TAB & "Microsoft Calculator" & @CRLF & _
		"IE" & @TAB & @TAB & "Internet Explorer" & $crlf & "run>"
$A5 = "Sets the default console foreground colors." & $crlf & _
		"COLOR [attr]" & @TAB & @TAB & "" & @CRLF & _
		"  attr        Specifies color attribute of console output" & $crlf & _
		"Color attributes are specified by TWO hex digits -- the first" & @CRLF & _
		"corresponds to the foreground.; the second the background  Each digit" & @CRLF & _
		"can be any of the following values:" & $crlf & _
		@TAB & "0 = Black" & @TAB & @TAB & "8 = Gray" & @CRLF & _
		@TAB & "1 = Blue" & @TAB & @TAB & "9 = Light Blue" & @CRLF & _
		@TAB & "2 = Green" & @TAB & @TAB & "A = Light Green" & @CRLF & _
		@TAB & "3 = Aqua" & @TAB & @TAB & "B = Light Aqua" & @CRLF & _
		@TAB & "4 = Red" & @TAB & @TAB & @TAB & "C = Light Red" & @CRLF & _
		@TAB & "5 = Purple" & @TAB & @TAB & "D = Light Purple" & @CRLF & _
		@TAB & "6 = Yellow" & @TAB & @TAB & "E = Light Yellow" & @CRLF & _
		@TAB & "7 = White" & @TAB & @TAB & "F = Bright White" & $crlf & _
		"Example: 'COLOR 94' produces light blue on red" & _
		$crlf & $DIR
$A6 = @CRLF & "BEEP" & @TAB & @TAB & "Beeps at 4 random frequencies ." & @CRLF & _
		"CD" & @TAB & @TAB & "Displays the name of or changes the current directory." & @CRLF & _
		"CLEAR" & @TAB & @TAB & "Clears command window." & @CRLF & _
		"CLOSETRAY" & @TAB & "Closes all if more CD Trays (does not work on laptops)." & @CRLF & _
		"COLOR" & @TAB & @TAB & "Sets the default console foreground colors." & @CRLF & _
		"DATE" & @TAB & @TAB & "Displays current date.  mm/dd/yyyy" & @CRLF & _
		"DIR" & @TAB & @TAB & "Displays a list of files and subdirectories in a directory." & @CRLF & _
		"EXIT" & @TAB & @TAB & "Exit out this program." & @CRLF & _
		"HELP" & @TAB & @TAB & "Brings up a common list of commands." & @CRLF & _
		"IP" & @TAB & @TAB & "Prints out ip address" & @CRLF & _
		"KBSC" & @TAB & @TAB & "Displays keyboard shortcuts." & @CRLF & _
		"LOGOFF" & @TAB & @TAB & "Logoff." & @CRLF & _
		"LOG" & @TAB & @TAB & "Opens a log created from all activities by time." & @CRLF & _
		"LOG/C" & @TAB & @TAB & "Deletes log." & @CRLF & _
		"LOG/S" & @TAB & @TAB & "Shows log within this window." & @CRLF & _
		"LOG/W" & @TAB & @TAB & "Sets and writes log." & @CRLF & _
		"MAXIMIZE" & @TAB & "Maximize window, use RESTORE to restore window." & @CRLF & _
		"OPENTRAY" & @TAB & "Opens all if more CD Trays." & @CRLF & _
		"RESTORE" & @TAB & @TAB & "Restores when window is maximized." & @CRLF & _
		"RUN" & @TAB & @TAB & "Brings up run command." & @CRLF & _
		"SHUTDOWN" & @TAB & "Brings up shutdown options." & @CRLF & _
		"SYSTEMINFO" & @TAB & "Displays machine specific properties and configuration." & @CRLF & _
		"TASKLIST" & @TAB & "Displays all currently running tasks." & @CRLF & _
		"TD" & @TAB & @TAB & "Displays time and date." & @CRLF & _
		"TIME" & @TAB & @TAB & "Displays current time.  hh:mm:ss" & @CRLF & _
		"VOL" & @TAB & @TAB & "Displays a disk volume label, serial number and disk space." & @CRLF & _
		@CRLF & $DIR
$A7 = "Usage: log[/c | /w ]" & $crlf & _
		@TAB & "  No args" & @TAB & @TAB & "Display the log file." & @CRLF & _
		@TAB & "  /s" & @TAB & @TAB & @TAB & "Shows the log file in this window." & @CRLF & _
		@TAB & "  /c" & @TAB & @TAB & @TAB & "Deletes the log file." & @CRLF & _
		@TAB & "  /w" & @TAB & @TAB & @TAB & "Writes the log file whats shown on the screen." & @CRLF
$A8 = "Keyboard shortcuts" & $crlf & _
		@TAB & "  ESC" & @TAB & @TAB & "Exits." & @CRLF & _
		@TAB & "  CTRL +" & @TAB & "Increase font size." & @CRLF & _
		@TAB & "  CTRL -" & @TAB & "Decrease font size." & @CRLF & _
		@TAB & "  CTRL 0" & @TAB & "Resets to default font size, color, face, attributes." & @CRLF & _
		@TAB & "  CTRL F" & @TAB & "Shows font menu." & @CRLF & _
		@TAB & "  F1" & @TAB & @TAB & "Displays a list of all commands." & @CRLF & _
		@TAB & "  F2" & @TAB & @TAB & "System Information." & @CRLF & _
		@TAB & "  F3" & @TAB & @TAB & "Sets the default console foreground colors." & @CRLF & _
		@TAB & "  F4" & @TAB & @TAB & "Brings up shutdown options." & @CRLF & _
		@TAB & "  F7" & @TAB & @TAB & "Network Information." & @CRLF & _
		@TAB & "  F8" & @TAB & @TAB & "Displays when program was last updated." & @CRLF & _
		$crlf
$Fsize = DirGetSize(@MyDocumentsDir, 1)
$A9 = @CRLF & "Host Name . . . . . . . . . . . . . . . . . :" & "  " & @ComputerName & @CRLF & _
		"OS Name . . . . . . . . . . . . . . . . . . :" & "  " & $OSs[1][0] & @CRLF & _
		"OS Type . . . . . . . . . . . . . . . . . . :" & "  " & $OSs[1][37] & @CRLF & _
		"OS Build Number . . . . . . . . . . . . . . :" & "  " & $OSs[1][2] & @CRLF & _
		"OS Language . . . . . . . . . . . . . . . . :" & "  " & _Language() & @CRLF & _
		"Manufacturer  . . . . . . . . . . . . . . . :" & "  " & $OSs[1][28] & @CRLF & _
		"Service Pack  . . . . . . . . . . . . . . . :" & "  " & _servicepack() & " " & @CRLF & _
		"IP Address  . . . . . . . . . . . . . . . . :" & "  " & $ip & " " & @CRLF & _
		"Current Time Zone . . . . . . . . . . . . . :" & "  " & $OSs[1][11] & @CRLF & _
		"Desktop Height  . . . . . . . . . . . . . . :" & "  " & @DesktopHeight & " px" & @CRLF & _
		"Desktop Width . . . . . . . . . . . . . . . :" & "  " & @DesktopWidth & " px" & @CRLF & _
		"Desktop Depth . . . . . . . . . . . . . . . :" & "  " & @DesktopDepth & " bits/px" & @CRLF & _
		"Refresh Rate  . . . . . . . . . . . . . . . :" & "  " & @DesktopRefresh & " hz" & @CRLF & _
		"Temp Directory  . . . . . . . . . . . . . . :" & "  " & @TempDir & @CRLF & _
		"Document Directory  . . . . . . . . . . . . :" & "  " & @MyDocumentsDir & " -with " & $Fsize[1] & " files" & @CRLF & _
		"Windows Directory . . . . . . . . . . . . . :" & "  " & @WindowsDir & @CRLF & _
		"System Directory  . . . . . . . . . . . . . :" & "  " & @SystemDir & @CRLF & _
		"Memory Load (Percentage of memory in use) . :" & "  " & $mem[0] & " %" & @CRLF & _
		"Total Physical Memory . . . . . . . . . . . :" & "  " & $1 & " MB" & @CRLF & _
		"Available Physical Memory . . . . . . . . . :" & "  " & $2 & " MB" & @CRLF & _
		"Page File Total . . . . . . . . . . . . . . :" & "  " & $3 & " MB" & @CRLF & _
		"Page File Availabilty . . . . . . . . . . . :" & "  " & $4 & " MB" & @CRLF & _
		"Version . . . . . . . . . . . . . . . . . . :" & "  " & $OSs[1][58] & @CRLF & _
		"Logon Domain  . . . . . . . . . . . . . . . :" & "  " & @LogonDomain & $crlf & $DIR
$networkInfo = "Name  . . . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][0] & @CRLF & _
		"Adapter Type  . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][1] & @CRLF & _
		"Adapter Type ID . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][2] & @CRLF & _
		"Auto Sense  . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][3] & @CRLF & _
		"Description . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][4] & @CRLF & _
		"Availability  . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][5] & @CRLF & _
		"Config Manager Error Code . . . . . . . . . :" & "  " & $NetworkCards[1][6] & @CRLF & _
		"Config Manager User Config  . . . . . . . . :" & "  " & $NetworkCards[1][7] & @CRLF & _
		"Creation Class Name . . . . . . . . . . . . :" & "  " & $NetworkCards[1][8] & @CRLF & _
		"Device ID . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][9] & @CRLF & _
		"Error Cleared . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][10] & @CRLF & _
		"Error Description . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][11] & @CRLF & _
		"Index . . . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][12] & @CRLF & _
		"Installed . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][13] & @CRLF & _
		"Last Error Code . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][14] & @CRLF & _
		"MAC Address . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][15] & @CRLF & _
		"Manufacturer  . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][16] & @CRLF & _
		"Max Number Controlled . . . . . . . . . . . :" & "  " & $NetworkCards[1][17] & @CRLF & _
		"Max Speed . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][18] & @CRLF & _
		"Net Connection ID . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][19] & @CRLF & _
		"Net Connection Status . . . . . . . . . . . :" & "  " & $NetworkCards[1][20] & @CRLF & _
		"Network Addresses . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][21] & @CRLF & _
		"Permanent Address . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][22] & @CRLF & _
		"PNP Device ID . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][23] & @CRLF & _
		"Power Management Capabilities . . . . . . . :" & "  " & $NetworkCards[1][24] & @CRLF & _
		"Power Management Supported  . . . . . . . . :" & "  " & $NetworkCards[1][25] & @CRLF & _
		"Product Name  . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][26] & @CRLF & _
		"Service Name  . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][27] & @CRLF & _
		"Speed . . . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][28] & @CRLF & _
		"Status  . . . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][29] & @CRLF & _
		"Status Info . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][30] & @CRLF & _
		"System Creation Class Name  . . . . . . . . :" & "  " & $NetworkCards[1][31] & @CRLF & _
		"System Name . . . . . . . . . . . . . . . . :" & "  " & $NetworkCards[1][32] & @CRLF & _
		"Time Of Last Reset  . . . . . . . . . . . . :" & "  " & $NetworkCards[1][33] & $crlf & $DIR
#EndRegion ### SOURSES ###
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("Command Prompt_", 517, 752, 4, 4, BitOR($WS_SYSMENU, $WS_CAPTION, $WS_GROUP, $WS_CLIPSIBLINGS))
GUISetFont($size, $weight, $attr, $font)
GUISetIcon("cmd.exe")
GUISetBkColor($bcolor)
$pos = WinGetPos("Command Prompt_")
$Input1 = GUICtrlCreateEdit("", 0, 0, $pos[2] - 5, $pos[3] - 25, BitOR($ES_AUTOVSCROLL, $ES_WANTRETURN, $WS_VSCROLL), 0)
GUICtrlSetData(-1, $A)
GUICtrlSetColor(-1, $color)
GUICtrlSetBkColor(-1, $bcolor)
GUISetState(@SW_SHOW)
$textnew = _GUICtrlEdit_GetTextLen($Input1)
Send("{end}")
#EndRegion ### START Koda GUI section ### Form=
While 1
	_GuiSnap($title, 50, 4)
	If Not FileExists($settings) Then
		$read = GUICtrlRead($Input1)
		$sleep = 250
		$sData = "Size=9" & @LF & "Weight=400" & @LF & "Attr=0" & @LF & "Font=Lucida Console" & @LF & "Color=0xC0C0C0" & @LF & "BGColor=0x000000"
		GUICtrlSetData($Input1, $read & @CRLF & "No settings for font found. creating fontsettings.ini ..")
		Sleep(2000)
		GUICtrlSetData($Input1, $read & @CRLF & "Size=9")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "Weight=400")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "Attr=0")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "Font=Lucida Console")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "Color=0xC0C0C0")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "BGColor=0x000000")
		Sleep($sleep)
		GUICtrlSetData($Input1, $read & @CRLF & "Writing Commands")
		IniWriteSection($settings, "Font Settings", $sData)
		Sleep($sleep)
		GUICtrlSetData($Input1, $DIR)
	EndIf
	If Not FileExists($log) Then
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & @CRLF & "No log found. creating log.ini ..")
		Sleep(2000)
		GUICtrlSetData($Input1, $read & @CRLF & "Log started at " & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "/" & @MDAY & "/" & @YEAR)
		FileWrite($log, @HOUR & ":" & @MIN & ":" & @SEC & " " & _day() & " " & _month() & " " & @MDAY & "," & @YEAR & $crlf)
		Sleep(3000)
		GUICtrlSetData($Input1, $DIR)
	EndIf
	If WinActive($title) Then
		HotKeySet("{BACKSPACE}", "_Backspace")
		HotKeySet("{UP}", "_UP")
		HotKeySet("{DOWN}", "_DOWN")
		HotKeySet("{RIGHT}", "_RIGHT")
		HotKeySet("{LEFT}", "_LEFT")
		HotKeySet("{ENTER}", "_CommandSend")
		HotKeySet("^0", "_reset")
		HotKeySet("^f", "_font")
		HotKeySet("{F1}", "_help")
		HotKeySet("{F2}", "_systeminfo")
		HotKeySet("{F3}", "_color")
		HotKeySet("{F4}", "_shutdown")
		HotKeySet("{F7}", "_Networkinfo")
		HotKeySet("{F8}", "_lastupdated")
	Else
		HotKeySet("{BACKSPACE}")
		HotKeySet("{UP}")
		HotKeySet("{DOWN}")
		HotKeySet("{RIGHT}")
		HotKeySet("{LEFT}")
		HotKeySet("{ENTER}")
		HotKeySet("^0")
		HotKeySet("^f")
		HotKeySet("{F1}")
		HotKeySet("{F2}")
		HotKeySet("{F3}")
		HotKeySet("{F4}")
		HotKeySet("{F7}")
		HotKeySet("{F8}")
	EndIf
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			$EndScript = TimerDiff($StartScript)
			$htime = Round($EndScript / 1000, 0)
			If $htime > 60 Then
				$time = (Round($htime / 60, 1)) & " minutes"
			Else
				$time = $htime & " seconds"
			EndIf
			FileWrite($log, "---" & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "/" & @MDAY & "/" & @YEAR & "---" & $crlf & $A & $crlf & "Time: " & $time & $crlf)
			_save($size, $weight, $attr, $font, $color, $bcolor)
			Exit
	EndSwitch
	
WEnd
#Region ### Functions
Func _UP()
	Send("{END}")
EndFunc   ;==>_UP
Func _DOWN()
	Send("{END}")
EndFunc   ;==>_DOWN
Func _RIGHT()
	Send("{END}")
EndFunc   ;==>_RIGHT
Func _LEFT()
	Send("{END}")
EndFunc   ;==>_LEFT
Func _Backspace()
	$read = GUICtrlRead($Input1)
	If $read = $A Then
	Else
		GUICtrlSetData($Input1, StringTrimRight($read, 1))
		Send("{end}")
	EndIf
	
	
EndFunc   ;==>_Backspace
Func _CommandSend()
	$htitle = GUICtrlRead($Input1)
	$RUN = StringTrimLeft($htitle, $textnew + 7)
	$Tleft = StringTrimLeft($htitle, $textnew + 6)
	$HELPL = StringTrimLeft($htitle, $textnew + 5)
	$Vleft = StringTrimLeft($htitle, $textnew + 4)
	$Dleft = StringTrimLeft($htitle, $textnew + 3)
	$read = GUICtrlRead($Input1)
	If $read = $A & "Logoff" Then
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
		GUIDelete($Form1)
		Shutdown(0)
	ElseIf $read = $A & "opentray" Then
		GUICtrlSetData($Input1, $read & @CRLF & "opening all CD trays ..")
		Send("{end}")
		$var = DriveGetDrive("CDROM")
		If Not @error Then
			For $i = 1 To $var[0]
				GUICtrlSetData($Input1, $read & @CRLF & $var[$i])
				CDTray($var[$i], "open")
			Next
		EndIf
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "closetray" Then
		GUICtrlSetData($Input1, $read & @CRLF & "closing all CD trays ..")
		Send("{end}")
		$var = DriveGetDrive("CDROM")
		If Not @error Then
			For $i = 1 To $var[0]
				CDTray($var[$i], "close")
			Next
		EndIf
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "tasklist" Then
		$list = ProcessList()
		GUICtrlSetData($Input1, $read & $crlf & _
				"Image Name" & @TAB & @TAB & @TAB & "   PID" & @CRLF & _
				"=============================" & @TAB & "======")
		$read = GUICtrlRead($Input1)
		For $i = 1 To $list[0][0]
			If StringLen($list[$i][0]) < 8 Then
				$TAB = @TAB & @TAB & @TAB & @TAB
			ElseIf StringLen($list[$i][0]) < 16 Then
				$TAB = @TAB & @TAB & @TAB
			ElseIf StringLen($list[$i][0]) < 24 Then
				$TAB = @TAB & @TAB
			ElseIf StringLen($list[$i][0]) < 32 Then
				$TAB = @TAB
			ElseIf StringLen($list[$i][0]) < 40 Then
				$TAB = @TAB
			EndIf
			If StringLen($list[$i][1]) < 2 Then
				$space = "     "
			ElseIf StringLen($list[$i][1]) < 3 Then
				$space = "    "
			ElseIf StringLen($list[$i][1]) < 4 Then
				$space = "   "
			ElseIf StringLen($list[$i][1]) < 5 Then
				$space = "  "
			ElseIf StringLen($list[$i][1]) < 5 Then
				$space = " "
			EndIf
			GUICtrlSetData($Input1, $read & @CRLF & $list[$i][0] & $TAB & $space & $list[$i][1])
			$read = GUICtrlRead($Input1)
		Next
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "shutdown" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A2 & $crlf & $DIR)
	ElseIf $read = $A & "shutdown/?" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A2 & $crlf & $DIR)
	ElseIf $read = $A & "shutdown/r" Then
		Shutdown(2);==>_ restart
	ElseIf $read = $A & "shutdown/s" Then
		Shutdown(5);==>_ shutdown
	ElseIf $read = $A & "shutdown/b" Then
		Shutdown(32);==>_ standby
	ElseIf $read = $A & "shutdown/l" Then
		Shutdown(0);==>_ log off
	ElseIf $read = $A & "shutdown/h" Then
		Shutdown(64);==>_ hibernate
	ElseIf $read = $A & "shutdown /r" Then
		Shutdown(2);==>_ restart
	ElseIf $read = $A & "shutdown /s" Then
		Shutdown(5);==>_ shutdown
	ElseIf $read = $A & "shutdown /b" Then
		Shutdown(32);==>_ standby
	ElseIf $read = $A & "shutdown /l" Then
		Shutdown(0);==>_ log off
	ElseIf $read = $A & "shutdown /h" Then
		Shutdown(64);==>_ hibernate
	ElseIf $read = $A & "cd" Then
		GUICtrlSetData($Input1, $read & @CRLF & StringTrimRight($DIR, 1) & $crlf & $DIR)
	ElseIf $read = $A & "cd run " & $RUN Then
		$FileList = _FileListToArray(StringTrimRight($DIR, 1), '*', 1)
		$msg = "The system cannot find the path specified." & $crlf
		For $d = 1 To $FileList[0]
			If $RUN = $FileList[$d] Then
				$msg = ""
				ShellExecute(StringTrimRight($DIR, 1) & "\" & $RUN)
			EndIf
		Next
		GUICtrlSetData($Input1, $read & @CRLF & $msg & $DIR)
	ElseIf $read = $A & "cd " & $Dleft Then
		$FileListD = _FileListToArray(StringTrimRight($DIR, 1), '*', 2)
		$msg = "The system cannot find the path specified." & $crlf
		For $d = 1 To $FileListD[0]
			If $Dleft = $FileListD[$d] Then
				If $DIR = "C:\>" Then
					$DIR = StringTrimRight($DIR, 2) & "\" & $Dleft & ">"
				Else
					$DIR = StringTrimRight($DIR, 1) & "\" & $Dleft & ">"
				EndIf
				$msg = ""
			EndIf
		Next
		If $Dleft = ".." Then
			$H = StringSplit($DIR, "\")
			$DIR = StringTrimRight($DIR, StringLen($H[$H[0]]) + 1) & ">"
			If $H[0] = 2 Then
				$DIR = "C:\>"
			EndIf
			$msg = ""
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & $msg & $DIR)
	ElseIf $read = $A & "cd/" Then
		$DIR = "C:\>"
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "cd.." Then
		$H = StringSplit($DIR, "\")
		$DIR = StringTrimRight($DIR, StringLen($H[$H[0]]) + 1) & ">"
		If $H[0] = 2 Then
			$DIR = "C:\>"
		EndIf
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "dir" Then
		$hH = StringSplit($DIR, "\")
		$hDIR = FileGetTime(StringTrimRight($DIR, StringLen($hH[$hH[0]]) + 1))
		$hC = FileGetTime("C:")
		GUICtrlSetData($Input1, $read & $crlf & " Directory of " & StringTrimRight($DIR, 1) & $crlf & $hC[1] & "/" & $hC[2] & "/" & $hC[0] & " " & _ChangeTime($hC[3], $hC[4]) & @TAB & "<DIR>" & @TAB & @TAB & "/" & @CRLF & $hDIR[1] & "/" & $hDIR[2] & "/" & $hDIR[0] & " " & _ChangeTime($hDIR[3], $hDIR[4]) & @TAB & "<DIR>" & @TAB & @TAB & ".." & @CRLF)
		$read = GUICtrlRead($Input1)
		$FileListD = _FileListToArray(StringTrimRight($DIR, 1), '*', 2)
		For $d = 1 To $FileListD[0]
			$r = FileGetTime(StringTrimRight($DIR, 1) & "/" & $FileListD[$d])
			GUICtrlSetData($Input1, $read & $r[1] & "/" & $r[2] & "/" & $r[0] & " " & _ChangeTime($r[3], $r[4]) & @TAB & "<DIR>" & @TAB & @TAB & $FileListD[$d] & @CRLF)
			$read = GUICtrlRead($Input1)
		Next
		Send("{END}")
		$FileList = _FileListToArray(StringTrimRight($DIR, 1), "*", 1)
		For $d = 1 To $FileList[0]
			$filesize = FileGetSize(StringTrimRight($DIR, 1) & "/" & $FileList[$d])
			If StringLen($filesize) = 1 Then
				$space = @TAB & "     "
			ElseIf StringLen($filesize) = 2 Then
				$space = @TAB & "    "
			ElseIf StringLen($filesize) = 3 Then
				$space = @TAB & "   "
			ElseIf StringLen($filesize) = 4 Then
				$space = @TAB & " "
			ElseIf StringLen($filesize) = 5 Then
				$space = @TAB & ""
			ElseIf StringLen($filesize) = 6 Then
				$space = "       "
			ElseIf StringLen($filesize) = 7 Then
				$space = "     "
			ElseIf StringLen($filesize) = 8 Then
				$space = "   "
			EndIf
			$f = FileGetTime(StringTrimRight($DIR, 1) & "/" & $FileList[$d])
			GUICtrlSetData($Input1, $read & $f[1] & "/" & $f[2] & "/" & $f[0] & " " & _ChangeTime($f[3], $f[4]) & @TAB & $space & _change($filesize) & @TAB & $FileList[$d] & @CRLF);
			$read = GUICtrlRead($Input1)
		Next
		GUICtrlSetData($Input1, $read & @TAB & @TAB & $FileList[0] & " File(s)" & @CRLF & @TAB & @TAB & $FileListD[0] & " Dirs(s)")
		Send("{END}")
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "kbsc" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A8 & $DIR)
	ElseIf $read = $A & "help " & $HELPL Then
		_HelpHelp($HELPL)
	ElseIf $read = $A & "help" Then
		GUICtrlSetData($Input1, $read & $A6)
	ElseIf $read = $A & "?" Then
		GUICtrlSetData($Input1, $read & $A6)
	ElseIf $read = $A & "help/all" Then
		GUICtrlSetData($Input1, $read & $A6)
	ElseIf $read = $A & "help/" Then
		GUICtrlSetData($Input1, $read & $A6)
		;0 = Black  0x000000     8 = Gray          0x808080
		;1 = Blue   0x0000ff     9 = Light Blue    0x5555FF
		;2 = Green  0x00ff00     A = Light Green   0x55ff55
		;3 = Aqua   0x008080     B = Light Aqua    0x55ffff
		;4 = Red    0xff0000     C = Light Red     0xFF8080
		;5 = Purple 0x400040     D = Light Purple  0x8000FF
		;6 = Yellow 0xffff00     E = Light Yellow  0xFFFF80
		;7 = White  0xDBDBDB     F = Bright White  0xffffff
	ElseIf $read = $A & "color/all" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A5)
	ElseIf $read = $A & "color/" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A5)
	ElseIf $read = $A & "color" Then
		_Guictrlsetcolor(7, 0)
	ElseIf $read = $A & "color/t" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A5)
		#Region Color
	ElseIf $read = $A & "color 0" Then
		_Guictrlsetcolor(0)
	ElseIf $read = $A & "color 1" Then
		_Guictrlsetcolor(1)
	ElseIf $read = $A & "color 2" Then
		_Guictrlsetcolor(2)
	ElseIf $read = $A & "color 3" Then
		_Guictrlsetcolor(3)
	ElseIf $read = $A & "color 4" Then
		_Guictrlsetcolor(4)
	ElseIf $read = $A & "color 5" Then
		_Guictrlsetcolor(5)
	ElseIf $read = $A & "color 6" Then
		_Guictrlsetcolor(6)
	ElseIf $read = $A & "color 7" Then
		_Guictrlsetcolor(7)
	ElseIf $read = $A & "color 8" Then
		_Guictrlsetcolor(8)
	ElseIf $read = $A & "color 9" Then
		_Guictrlsetcolor(9)
	ElseIf $read = $A & "color a" Then
		_Guictrlsetcolor(10)
	ElseIf $read = $A & "color b" Then
		_Guictrlsetcolor(11)
	ElseIf $read = $A & "color c" Then
		_Guictrlsetcolor(12)
	ElseIf $read = $A & "color d" Then
		_Guictrlsetcolor(13)
	ElseIf $read = $A & "color e" Then
		_Guictrlsetcolor(14)
	ElseIf $read = $A & "color f" Then
		_Guictrlsetcolor(15)
		
	ElseIf $read = $A & "color 10" Then
		_Guictrlsetcolor(1, 0)
	ElseIf $read = $A & "color 12" Then
		_Guictrlsetcolor(1, 2)
	ElseIf $read = $A & "color 13" Then
		_Guictrlsetcolor(1, 3)
	ElseIf $read = $A & "color 14" Then
		_Guictrlsetcolor(1, 4)
	ElseIf $read = $A & "color 15" Then
		_Guictrlsetcolor(1, 5)
	ElseIf $read = $A & "color 16" Then
		_Guictrlsetcolor(1, 6)
	ElseIf $read = $A & "color 17" Then
		_Guictrlsetcolor(1, 7)
	ElseIf $read = $A & "color 18" Then
		_Guictrlsetcolor(1, 8)
	ElseIf $read = $A & "color 19" Then
		_Guictrlsetcolor(1, 9)
	ElseIf $read = $A & "color 1a" Then
		_Guictrlsetcolor(1, 10)
	ElseIf $read = $A & "color 1b" Then
		_Guictrlsetcolor(1, 11)
	ElseIf $read = $A & "color 1c" Then
		_Guictrlsetcolor(1, 12)
	ElseIf $read = $A & "color 1d" Then
		_Guictrlsetcolor(1, 13)
	ElseIf $read = $A & "color 1e" Then
		_Guictrlsetcolor(1, 14)
	ElseIf $read = $A & "color 1f" Then
		_Guictrlsetcolor(1, 15)
		
		
	ElseIf $read = $A & "color 20" Then
		_Guictrlsetcolor(2, 0)
	ElseIf $read = $A & "color 21" Then
		_Guictrlsetcolor(2, 1)
	ElseIf $read = $A & "color 23" Then
		_Guictrlsetcolor(2, 3)
	ElseIf $read = $A & "color 24" Then
		_Guictrlsetcolor(2, 4)
	ElseIf $read = $A & "color 25" Then
		_Guictrlsetcolor(2, 5)
	ElseIf $read = $A & "color 26" Then
		_Guictrlsetcolor(2, 6)
	ElseIf $read = $A & "color 27" Then
		_Guictrlsetcolor(2, 7)
	ElseIf $read = $A & "color 28" Then
		_Guictrlsetcolor(2, 8)
	ElseIf $read = $A & "color 29" Then
		_Guictrlsetcolor(2, 9)
	ElseIf $read = $A & "color 2a" Then
		_Guictrlsetcolor(2, 10)
	ElseIf $read = $A & "color 2b" Then
		_Guictrlsetcolor(2, 11)
	ElseIf $read = $A & "color 2c" Then
		_Guictrlsetcolor(2, 12)
	ElseIf $read = $A & "color 2d" Then
		_Guictrlsetcolor(2, 13)
	ElseIf $read = $A & "color 2e" Then
		_Guictrlsetcolor(2, 14)
	ElseIf $read = $A & "color 2f" Then
		_Guictrlsetcolor(2, 15)
		
	ElseIf $read = $A & "color 30" Then
		_Guictrlsetcolor(3, 0)
	ElseIf $read = $A & "color 31" Then
		_Guictrlsetcolor(3, 1)
	ElseIf $read = $A & "color 32" Then
		_Guictrlsetcolor(3, 2)
	ElseIf $read = $A & "color 34" Then
		_Guictrlsetcolor(3, 4)
	ElseIf $read = $A & "color 35" Then
		_Guictrlsetcolor(3, 5)
	ElseIf $read = $A & "color 36" Then
		_Guictrlsetcolor(3, 6)
	ElseIf $read = $A & "color 37" Then
		_Guictrlsetcolor(3, 7)
	ElseIf $read = $A & "color 38" Then
		_Guictrlsetcolor(3, 8)
	ElseIf $read = $A & "color 39" Then
		_Guictrlsetcolor(3, 9)
	ElseIf $read = $A & "color 3a" Then
		_Guictrlsetcolor(3, 10)
	ElseIf $read = $A & "color 3b" Then
		_Guictrlsetcolor(3, 11)
	ElseIf $read = $A & "color 3c" Then
		_Guictrlsetcolor(3, 12)
	ElseIf $read = $A & "color 3d" Then
		_Guictrlsetcolor(3, 13)
	ElseIf $read = $A & "color 3e" Then
		_Guictrlsetcolor(3, 14)
	ElseIf $read = $A & "color 3f" Then
		_Guictrlsetcolor(3, 15)
		
	ElseIf $read = $A & "color 40" Then
		_Guictrlsetcolor(4, 0)
	ElseIf $read = $A & "color 41" Then
		_Guictrlsetcolor(4, 1)
	ElseIf $read = $A & "color 42" Then
		_Guictrlsetcolor(4, 2)
	ElseIf $read = $A & "color 43" Then
		_Guictrlsetcolor(4, 3)
	ElseIf $read = $A & "color 45" Then
		_Guictrlsetcolor(4, 5)
	ElseIf $read = $A & "color 46" Then
		_Guictrlsetcolor(4, 6)
	ElseIf $read = $A & "color 47" Then
		_Guictrlsetcolor(4, 7)
	ElseIf $read = $A & "color 48" Then
		_Guictrlsetcolor(4, 8)
	ElseIf $read = $A & "color 49" Then
		_Guictrlsetcolor(4, 9)
	ElseIf $read = $A & "color 4a" Then
		_Guictrlsetcolor(4, 10)
	ElseIf $read = $A & "color 4b" Then
		_Guictrlsetcolor(4, 11)
	ElseIf $read = $A & "color 4c" Then
		_Guictrlsetcolor(4, 12)
	ElseIf $read = $A & "color 4d" Then
		_Guictrlsetcolor(4, 13)
	ElseIf $read = $A & "color 4e" Then
		_Guictrlsetcolor(4, 14)
	ElseIf $read = $A & "color 4f" Then
		_Guictrlsetcolor(4, 15)
		
	ElseIf $read = $A & "color 50" Then
		_Guictrlsetcolor(5, 0)
	ElseIf $read = $A & "color 51" Then
		_Guictrlsetcolor(5, 1)
	ElseIf $read = $A & "color 52" Then
		_Guictrlsetcolor(5, 2)
	ElseIf $read = $A & "color 53" Then
		_Guictrlsetcolor(5, 3)
	ElseIf $read = $A & "color 54" Then
		_Guictrlsetcolor(5, 4)
	ElseIf $read = $A & "color 56" Then
		_Guictrlsetcolor(5, 6)
	ElseIf $read = $A & "color 57" Then
		_Guictrlsetcolor(5, 7)
	ElseIf $read = $A & "color 58" Then
		_Guictrlsetcolor(5, 8)
	ElseIf $read = $A & "color 59" Then
		_Guictrlsetcolor(5, 9)
	ElseIf $read = $A & "color 5a" Then
		_Guictrlsetcolor(5, 10)
	ElseIf $read = $A & "color 5b" Then
		_Guictrlsetcolor(5, 11)
	ElseIf $read = $A & "color 5c" Then
		_Guictrlsetcolor(5, 12)
	ElseIf $read = $A & "color 5d" Then
		_Guictrlsetcolor(5, 13)
	ElseIf $read = $A & "color 5e" Then
		_Guictrlsetcolor(5, 14)
	ElseIf $read = $A & "color 5f" Then
		_Guictrlsetcolor(5, 15)
		
	ElseIf $read = $A & "color 60" Then
		_Guictrlsetcolor(6, 0)
	ElseIf $read = $A & "color 61" Then
		_Guictrlsetcolor(6, 1)
	ElseIf $read = $A & "color 62" Then
		_Guictrlsetcolor(6, 2)
	ElseIf $read = $A & "color 63" Then
		_Guictrlsetcolor(6, 3)
	ElseIf $read = $A & "color 64" Then
		_Guictrlsetcolor(6, 4)
	ElseIf $read = $A & "color 65" Then
		_Guictrlsetcolor(6, 5)
	ElseIf $read = $A & "color 67" Then
		_Guictrlsetcolor(6, 7)
	ElseIf $read = $A & "color 68" Then
		_Guictrlsetcolor(6, 8)
	ElseIf $read = $A & "color 69" Then
		_Guictrlsetcolor(6, 9)
	ElseIf $read = $A & "color 6a" Then
		_Guictrlsetcolor(6, 10)
	ElseIf $read = $A & "color 6b" Then
		_Guictrlsetcolor(6, 11)
	ElseIf $read = $A & "color 6c" Then
		_Guictrlsetcolor(6, 12)
	ElseIf $read = $A & "color 6d" Then
		_Guictrlsetcolor(6, 13)
	ElseIf $read = $A & "color 6e" Then
		_Guictrlsetcolor(6, 14)
	ElseIf $read = $A & "color 6f" Then
		_Guictrlsetcolor(6, 15)
		
	ElseIf $read = $A & "color 70" Then
		_Guictrlsetcolor(7, 0)
	ElseIf $read = $A & "color 71" Then
		_Guictrlsetcolor(7, 1)
	ElseIf $read = $A & "color 72" Then
		_Guictrlsetcolor(7, 2)
	ElseIf $read = $A & "color 73" Then
		_Guictrlsetcolor(7, 3)
	ElseIf $read = $A & "color 74" Then
		_Guictrlsetcolor(7, 4)
	ElseIf $read = $A & "color 75" Then
		_Guictrlsetcolor(7, 5)
	ElseIf $read = $A & "color 76" Then
		_Guictrlsetcolor(7, 6)
	ElseIf $read = $A & "color 78" Then
		_Guictrlsetcolor(7, 8)
	ElseIf $read = $A & "color 79" Then
		_Guictrlsetcolor(7, 9)
	ElseIf $read = $A & "color 7a" Then
		_Guictrlsetcolor(7, 10)
	ElseIf $read = $A & "color 7b" Then
		_Guictrlsetcolor(7, 11)
	ElseIf $read = $A & "color 7c" Then
		_Guictrlsetcolor(7, 12)
	ElseIf $read = $A & "color 7d" Then
		_Guictrlsetcolor(7, 13)
	ElseIf $read = $A & "color 7e" Then
		_Guictrlsetcolor(7, 14)
	ElseIf $read = $A & "color 7f" Then
		_Guictrlsetcolor(7, 15)
		
	ElseIf $read = $A & "color 80" Then
		_Guictrlsetcolor(8, 0)
	ElseIf $read = $A & "color 81" Then
		_Guictrlsetcolor(8, 1)
	ElseIf $read = $A & "color 82" Then
		_Guictrlsetcolor(8, 2)
	ElseIf $read = $A & "color 83" Then
		_Guictrlsetcolor(8, 3)
	ElseIf $read = $A & "color 84" Then
		_Guictrlsetcolor(8, 4)
	ElseIf $read = $A & "color 85" Then
		_Guictrlsetcolor(8, 5)
	ElseIf $read = $A & "color 86" Then
		_Guictrlsetcolor(8, 6)
	ElseIf $read = $A & "color 87" Then
		_Guictrlsetcolor(8, 7)
	ElseIf $read = $A & "color 89" Then
		_Guictrlsetcolor(8, 9)
	ElseIf $read = $A & "color 8a" Then
		_Guictrlsetcolor(8, 10)
	ElseIf $read = $A & "color 8b" Then
		_Guictrlsetcolor(8, 11)
	ElseIf $read = $A & "color 8c" Then
		_Guictrlsetcolor(8, 12)
	ElseIf $read = $A & "color 8d" Then
		_Guictrlsetcolor(8, 13)
	ElseIf $read = $A & "color 8e" Then
		_Guictrlsetcolor(8, 14)
	ElseIf $read = $A & "color 8f" Then
		_Guictrlsetcolor(8, 15)
		
	ElseIf $read = $A & "color 90" Then
		_Guictrlsetcolor(9, 0)
	ElseIf $read = $A & "color 91" Then
		_Guictrlsetcolor(9, 1)
	ElseIf $read = $A & "color 92" Then
		_Guictrlsetcolor(9, 2)
	ElseIf $read = $A & "color 93" Then
		_Guictrlsetcolor(9, 3)
	ElseIf $read = $A & "color 94" Then
		_Guictrlsetcolor(9, 4)
	ElseIf $read = $A & "color 95" Then
		_Guictrlsetcolor(9, 5)
	ElseIf $read = $A & "color 96" Then
		_Guictrlsetcolor(9, 6)
	ElseIf $read = $A & "color 97" Then
		_Guictrlsetcolor(9, 7)
	ElseIf $read = $A & "color 98" Then
		_Guictrlsetcolor(9, 8)
	ElseIf $read = $A & "color 9a" Then
		_Guictrlsetcolor(9, 10)
	ElseIf $read = $A & "color 9b" Then
		_Guictrlsetcolor(9, 11)
	ElseIf $read = $A & "color 9c" Then
		_Guictrlsetcolor(9, 12)
	ElseIf $read = $A & "color 9d" Then
		_Guictrlsetcolor(9, 13)
	ElseIf $read = $A & "color 9e" Then
		_Guictrlsetcolor(9, 14)
	ElseIf $read = $A & "color 9f" Then
		_Guictrlsetcolor(9, 15)
		
	ElseIf $read = $A & "color a0" Then
		_Guictrlsetcolor(10, 0)
	ElseIf $read = $A & "color a1" Then
		_Guictrlsetcolor(10, 1)
	ElseIf $read = $A & "color a2" Then
		_Guictrlsetcolor(10, 2)
	ElseIf $read = $A & "color a3" Then
		_Guictrlsetcolor(10, 3)
	ElseIf $read = $A & "color a4" Then
		_Guictrlsetcolor(10, 4)
	ElseIf $read = $A & "color a5" Then
		_Guictrlsetcolor(10, 5)
	ElseIf $read = $A & "color a6" Then
		_Guictrlsetcolor(10, 6)
	ElseIf $read = $A & "color a7" Then
		_Guictrlsetcolor(10, 7)
	ElseIf $read = $A & "color a8" Then
		_Guictrlsetcolor(10, 8)
	ElseIf $read = $A & "color a9" Then
		_Guictrlsetcolor(10, 9)
	ElseIf $read = $A & "color ab" Then
		_Guictrlsetcolor(10, 11)
	ElseIf $read = $A & "color ac" Then
		_Guictrlsetcolor(10, 12)
	ElseIf $read = $A & "color ad" Then
		_Guictrlsetcolor(10, 13)
	ElseIf $read = $A & "color ae" Then
		_Guictrlsetcolor(10, 14)
	ElseIf $read = $A & "color af" Then
		_Guictrlsetcolor(10, 15)
		
	ElseIf $read = $A & "color b0" Then
		_Guictrlsetcolor(11, 0)
	ElseIf $read = $A & "color b1" Then
		_Guictrlsetcolor(11, 1)
	ElseIf $read = $A & "color b2" Then
		_Guictrlsetcolor(11, 2)
	ElseIf $read = $A & "color b3" Then
		_Guictrlsetcolor(11, 3)
	ElseIf $read = $A & "color b4" Then
		_Guictrlsetcolor(11, 4)
	ElseIf $read = $A & "color b5" Then
		_Guictrlsetcolor(11, 5)
	ElseIf $read = $A & "color b6" Then
		_Guictrlsetcolor(11, 6)
	ElseIf $read = $A & "color b7" Then
		_Guictrlsetcolor(11, 7)
	ElseIf $read = $A & "color b8" Then
		_Guictrlsetcolor(11, 8)
	ElseIf $read = $A & "color b9" Then
		_Guictrlsetcolor(11, 9)
	ElseIf $read = $A & "color ba" Then
		_Guictrlsetcolor(11, 10)
	ElseIf $read = $A & "color bc" Then
		_Guictrlsetcolor(11, 12)
	ElseIf $read = $A & "color bd" Then
		_Guictrlsetcolor(11, 13)
	ElseIf $read = $A & "color be" Then
		_Guictrlsetcolor(11, 14)
	ElseIf $read = $A & "color bf" Then
		_Guictrlsetcolor(11, 15)
		
	ElseIf $read = $A & "color c0" Then
		_Guictrlsetcolor(12, 0)
	ElseIf $read = $A & "color c1" Then
		_Guictrlsetcolor(12, 1)
	ElseIf $read = $A & "color c2" Then
		_Guictrlsetcolor(12, 2)
	ElseIf $read = $A & "color c3" Then
		_Guictrlsetcolor(12, 3)
	ElseIf $read = $A & "color c4" Then
		_Guictrlsetcolor(12, 4)
	ElseIf $read = $A & "color c5" Then
		_Guictrlsetcolor(12, 5)
	ElseIf $read = $A & "color c6" Then
		_Guictrlsetcolor(12, 6)
	ElseIf $read = $A & "color c7" Then
		_Guictrlsetcolor(12, 7)
	ElseIf $read = $A & "color c8" Then
		_Guictrlsetcolor(12, 8)
	ElseIf $read = $A & "color c9" Then
		_Guictrlsetcolor(12, 9)
	ElseIf $read = $A & "color ca" Then
		_Guictrlsetcolor(12, 10)
	ElseIf $read = $A & "color cb" Then
		_Guictrlsetcolor(12, 11)
	ElseIf $read = $A & "color cd" Then
		_Guictrlsetcolor(12, 13)
	ElseIf $read = $A & "color ce" Then
		_Guictrlsetcolor(12, 14)
	ElseIf $read = $A & "color cf" Then
		_Guictrlsetcolor(12, 15)
		
	ElseIf $read = $A & "color d0" Then
		_Guictrlsetcolor(13, 0)
	ElseIf $read = $A & "color d1" Then
		_Guictrlsetcolor(13, 1)
	ElseIf $read = $A & "color d2" Then
		_Guictrlsetcolor(13, 2)
	ElseIf $read = $A & "color d3" Then
		_Guictrlsetcolor(13, 3)
	ElseIf $read = $A & "color d4" Then
		_Guictrlsetcolor(13, 4)
	ElseIf $read = $A & "color d5" Then
		_Guictrlsetcolor(13, 5)
	ElseIf $read = $A & "color d6" Then
		_Guictrlsetcolor(13, 6)
	ElseIf $read = $A & "color d7" Then
		_Guictrlsetcolor(13, 7)
	ElseIf $read = $A & "color d8" Then
		_Guictrlsetcolor(13, 8)
	ElseIf $read = $A & "color d9" Then
		_Guictrlsetcolor(13, 9)
	ElseIf $read = $A & "color da" Then
		_Guictrlsetcolor(13, 10)
	ElseIf $read = $A & "color dc" Then
		_Guictrlsetcolor(13, 11)
	ElseIf $read = $A & "color dc" Then
		_Guictrlsetcolor(13, 12)
	ElseIf $read = $A & "color de" Then
		_Guictrlsetcolor(13, 14)
	ElseIf $read = $A & "color df" Then
		_Guictrlsetcolor(13, 15)
		
	ElseIf $read = $A & "color e0" Then
		_Guictrlsetcolor(14, 0)
	ElseIf $read = $A & "color e1" Then
		_Guictrlsetcolor(14, 1)
	ElseIf $read = $A & "color e2" Then
		_Guictrlsetcolor(14, 2)
	ElseIf $read = $A & "color e3" Then
		_Guictrlsetcolor(14, 3)
	ElseIf $read = $A & "color e4" Then
		_Guictrlsetcolor(14, 4)
	ElseIf $read = $A & "color e5" Then
		_Guictrlsetcolor(14, 5)
	ElseIf $read = $A & "color e6" Then
		_Guictrlsetcolor(14, 6)
	ElseIf $read = $A & "color e7" Then
		_Guictrlsetcolor(14, 7)
	ElseIf $read = $A & "color e8" Then
		_Guictrlsetcolor(14, 8)
	ElseIf $read = $A & "color e9" Then
		_Guictrlsetcolor(14, 9)
	ElseIf $read = $A & "color ea" Then
		_Guictrlsetcolor(14, 10)
	ElseIf $read = $A & "color ec" Then
		_Guictrlsetcolor(14, 11)
	ElseIf $read = $A & "color ec" Then
		_Guictrlsetcolor(14, 12)
	ElseIf $read = $A & "color ed" Then
		_Guictrlsetcolor(14, 13)
	ElseIf $read = $A & "color ef" Then
		_Guictrlsetcolor(14, 15)
		
	ElseIf $read = $A & "color f0" Then
		_Guictrlsetcolor(15, 0)
	ElseIf $read = $A & "color f1" Then
		_Guictrlsetcolor(15, 1)
	ElseIf $read = $A & "color f2" Then
		_Guictrlsetcolor(15, 2)
	ElseIf $read = $A & "color f3" Then
		_Guictrlsetcolor(15, 3)
	ElseIf $read = $A & "color f4" Then
		_Guictrlsetcolor(15, 4)
	ElseIf $read = $A & "color f5" Then
		_Guictrlsetcolor(15, 5)
	ElseIf $read = $A & "color f6" Then
		_Guictrlsetcolor(15, 6)
	ElseIf $read = $A & "color f7" Then
		_Guictrlsetcolor(15, 7)
	ElseIf $read = $A & "color f8" Then
		_Guictrlsetcolor(15, 8)
	ElseIf $read = $A & "color f9" Then
		_Guictrlsetcolor(15, 9)
	ElseIf $read = $A & "color fa" Then
		_Guictrlsetcolor(15, 10)
	ElseIf $read = $A & "color fc" Then
		_Guictrlsetcolor(15, 11)
	ElseIf $read = $A & "color fc" Then
		_Guictrlsetcolor(15, 12)
	ElseIf $read = $A & "color fd" Then
		_Guictrlsetcolor(15, 14)
	ElseIf $read = $A & "color fe" Then
		_Guictrlsetcolor(15, 14)
		#EndRegion Color
	ElseIf $read = $A & "run" Then
		GUICtrlSetData($Input1, $A3)
	ElseIf $read = $A & "vol " & $Vleft Then
		$var = DriveGetDrive("all")
		$m = "The system cannot find the drive specified." & $crlf
		$vol = "" & $DIR
		For $i = 1 To $var[0]
			If $Vleft = $var[$i] Then
				$lab = DriveGetLabel($Vleft)
				$ser = DriveGetSerial($Vleft)
				$tot = Round(DriveSpaceTotal($Vleft), 0)
				$free = Round(DriveSpaceFree($Vleft), 0)
				$used = $tot - $free
				$used3 = _change($used)
				$free4 = _change($free)
				$vol = "  Volume in Drive " & $Vleft & " is " & $lab & @CRLF & _
						"  Volume Serial Number is " & $ser & @CRLF & _
						"  Space used . . . . . . . :  " & $used3 & " MB" & @CRLF & _
						"  Space free . . . . . . . :  " & $free4 & " MB" & @CRLF & _
						$crlf & $DIR
				$m = ""
			EndIf
		Next
		GUICtrlSetData($Input1, $read & @CRLF & $m & $vol)
	ElseIf $read = $A & "clear" Then
		GUICtrlSetData($Input1, $DIR)
	ElseIf $read = $A & "log/c" Then
		If WinExists("log") Then
			Send("{end}")
			GUICtrlSetData($Input1, $read & @CRLF & "closing window ..")
			Sleep(1500)
			WinClose("log")
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & "clearing ..")
		Send("{end}")
		Sleep(1000)
		FileDelete($log)
		FileWrite($log, "")
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & @CRLF & "cleared" & $crlf & $DIR)
		ShellExecute($log)
	ElseIf $read = $A & "log/w" Then
		If WinExists("log") Then
			Send("{end}")
			GUICtrlSetData($Input1, $read & @CRLF & "can not write when window is opened ..")
			Send("{end}")
			Sleep(2000)
			GUICtrlSetData($Input1, $read & @CRLF & "closing window ..")
			Sleep(1500)
			WinClose("log")
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & "writing ..")
		Send("{end}")
		Sleep(1000)
		$A = GUICtrlRead($Input1)
		FileWrite($log, "---" & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "/" & @MDAY & "/" & @YEAR & "---" & $crlf & $A & $crlf)
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & @CRLF & "saved" & @CRLF & "opening .." & $crlf & $DIR)
		ShellExecute($log)
	ElseIf $read = $A & "log/" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A7 & $crlf & $DIR)
	ElseIf $read = $A & "log/s" Then
		GUICtrlSetData($Input1, FileRead($log) & $crlf & "Press enter to continue ..")
	ElseIf $read = $A & "log/?" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A7 & $crlf & $DIR)
	ElseIf $read = $A & "log" Then
		If WinExists("log") Then
			Send("{end}")
			GUICtrlSetData($Input1, $read & @CRLF & "window exists ..")
			Send("{end}")
			Sleep(1000)
			GUICtrlSetData($Input1, $read & @CRLF & "closing window ..")
			Sleep(150)
			WinClose("log")
			Sleep(1500)
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & "opening log.ini ..")
		Send("{end}")
		Sleep(1000)
		ShellExecute($log)
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "settings" Then
		If WinExists("settings") Then
			Send("{end}")
			GUICtrlSetData($Input1, $read & @CRLF & "window exists ..")
			Send("{end}")
			Sleep(1000)
			GUICtrlSetData($Input1, $read & @CRLF & "closing window ..")
			Sleep(150)
			WinClose("settings")
			Sleep(1500)
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & "opening settings.ini ..")
		Send("{end}")
		Sleep(1000)
		ShellExecute($settings)
		$read = GUICtrlRead($Input1)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "+" Then
		$size = $size + 1
		GUICtrlSetFont($Input1, $size)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "-" Then
		$size = $size - 1
		GUICtrlSetFont($Input1, $size)
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
	ElseIf $read = $A & "exit" Then
		$EndScript = TimerDiff($StartScript)
		$htime = Round($EndScript / 1000, 0)
		If $htime > 60 Then
			$time = (Round($htime / 60, 1)) & " minutes"
		ElseIf $htime > 360 Then
			$time = (Round($htime / 60, 1)) & "hours"
		Else
			$time = $htime & " seconds"
		EndIf
		FileWrite($log, "---" & @HOUR & ":" & @MIN & ":" & @SEC & " " & @MON & "/" & @MDAY & "/" & @YEAR & "---" & $crlf & $A & $crlf & "Time: " & $time & $crlf)
		_save($size, $weight, $attr, $font, $color, $bcolor)
		Exit
	ElseIf $read = $A & "time/r" Then
		$EndScript = TimerDiff($StartScript)
		$htime = Round($EndScript / 1000, 0)
		If $htime > 60 Then
			$time = (Round($htime / 60, 1)) & " minutes"
		ElseIf $htime > 360 Then
			$time = (Round($htime / 60, 1)) & "hours"
		Else
			$time = $htime & " seconds"
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & "The current time running is: " & $time & $crlf & $DIR)
		
	ElseIf $read = $A & "ip" Then
		If @IPAddress1 = "127.0.0.1" Then
			$ip = "   Media State . . . . . . . . . . . : Disconnected"
		Else
			$ip = "   IP Address  . . . . . . . . . . . : " & @IPAddress1
		EndIf
		GUICtrlSetData($Input1, $read & $crlf & $ip & $crlf & $DIR)
	ElseIf $read = $A & "time" Then
		GUICtrlSetData($Input1, $read & @CRLF & "The current time is: " & @HOUR & ":" & @MIN & ":" & @SEC & $crlf & $DIR)
	ElseIf $read = $A & "time/?" Then
		GUICtrlSetData($Input1, $read & @CRLF & "Displays or sets the system time." & $crlf & _
				"TIME [/T]" & $crlf & $DIR)
	ElseIf $read = $A & "time /t" Then
		If @HOUR > 12 Then
			$HOUR = @HOUR - 12
			$AMPM = "PM"
		EndIf
		If @HOUR < 13 Then
			$HOUR = @HOUR
			$AMPM = "AM"
		EndIf
		If @HOUR = 00 Then
			$HOUR = 12
			$AMPM = "AM"
		EndIf
		If @HOUR = 12 Then
			$HOUR = 12
			$AMPM = "PM"
		EndIf
		GUICtrlSetData($Input1, $read & @CRLF & $HOUR & ":" & @MIN & " " & $AMPM & $crlf & $DIR)
	ElseIf $read = $A & "date" Then
		GUICtrlSetData($Input1, $read & @CRLF & "The current date is: " & _day() & " " & _month() & " " & @MDAY & ", " & @YEAR & $crlf & $DIR)
	ElseIf $read = $A & "date/t" Then
		GUICtrlSetData($Input1, $read & @CRLF & _day() & " " & _month() & " " & @MDAY & ", " & @YEAR & $crlf & $DIR)
	ElseIf $read = $A & "mute" Then
		Send("{VOLUME_MUTE}")
		GUICtrlSetData($Input1, $read & @CRLF & "Type MUTE again to unmute" & $crlf & $DIR)
	ElseIf $read = $A & "allcommands" Then
		GUICtrlSetData($Input1, $read & $A6)
	ElseIf $read = $A & "allcmds" Then
		GUICtrlSetData($Input1, $read & $A6)
	ElseIf $read = $A & "maximize" Then
		GUISetState(@SW_MAXIMIZE)
		_GuiSnap($title, 50, -8)
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "restore" Then
		GUISetState(@SW_RESTORE)
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "td" Then
		GUICtrlSetData($Input1, $read & @CRLF & "The current time and date is: " & @HOUR & ":" & @MIN & ":" & @SEC & " " & _day() & " " & _month() & " " & @MDAY & ", " & @YEAR & $crlf & $DIR)
	ElseIf $read = $A & "beep" Then
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
		$beeprandom = Random(37, 32767)
		Beep($beeprandom, 250)
		$beeprandom = Random(537, 2767)
		Beep($beeprandom, 250)
		$beeprandom = Random(1537, 2767)
		Beep($beeprandom, 250)
		$beeprandom = Random(2437, 3267)
		Beep($beeprandom, 250)
	ElseIf $read = $A & "lastupdated" Then
		GUICtrlSetData($Input1, $read & @CRLF & $lastupdated & $crlf & $DIR)
	ElseIf $read = $A & "beep high" Then
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
		$beeprandom = Random(1037, 1767)
		Beep($beeprandom, 550)
	ElseIf $read = $A & "beep low" Then
		GUICtrlSetData($Input1, $read & $crlf & $DIR)
		$beeprandom = Random(37, 67)
		Beep($beeprandom, 550)
	ElseIf $read = $A3 & "list" Then
		GUICtrlSetData($Input1, $read & @CRLF & $A4)
		$A3 = GUICtrlRead($Input1)
	ElseIf $read = $A3 & "notepad" Then
		Run("notepad.exe")
		GUICtrlSetData($Input1, $A3)
		$A3 = GUICtrlRead($Input1)
	ElseIf $read = $A3 & "mspaint" Then
		Run("mspaint.exe")
		GUICtrlSetData($Input1, $A3)
	ElseIf $read = $A3 & "calc" Then
		Run("calc.exe")
		GUICtrlSetData($Input1, $A3)
	ElseIf $read = $A3 & "custom" Then
		Send("#r")
		GUICtrlSetData($Input1, $A3)
	ElseIf $read = $A3 & "ie" Then
		Run("C:\Program Files\Internet Explorer\iexplore.exe")
		GUICtrlSetData($Input1, $A3)
	ElseIf $read = $A3 & "quit" Then
		GUICtrlSetData($Input1, $DIR)
		$A3 = "Type LIST to see list of runnable programs" & @CRLF & "run>"
	ElseIf $read = $A & "systeminfo" Then
		GUICtrlSetData($Input1, $read & @CRLF & "Loading system information ..")
		Send("{end}")
		Sleep(Random(2000, 6000, 1))
		GUICtrlSetData($Input1, $read & @CRLF & $A9)
	ElseIf $read = $A & "networkinfo" Then
		GUICtrlSetData($Input1, $read & @CRLF & "Loading network information ..")
		Send("{end}")
		Sleep(Random(2000, 6000, 1))
		GUICtrlSetData($Input1, $read & @CRLF & $networkInfo)
	ElseIf $read = $A & "" Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & " " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "  " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "   " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "    " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "     " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "      " Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	ElseIf $read = $A & "title " & $Tleft Then
		GUICtrlSetData($Input1, $read & @CRLF & $DIR)
		WinSetTitle($title, "", $Tleft)
		$title = $Tleft
	ElseIf $read = $A & "title" Then
		GUICtrlSetData($Input1, $read & @CRLF & "Sets the window title for the command prompt window." & $crlf & _
				"TITLE [string]" & $crlf & _
				"string       Specifies the title for the command prompt window." & $crlf & $DIR)
		
	Else
		$B = GUICtrlRead($Input1)
		$left = StringTrimLeft($B, $textnew)
		GUICtrlSetData($Input1, $read & @CRLF & "'" & $left & "'" & " is not recognized as an internal or external command," & @CRLF & "operable program or batch file." & @CRLF & $DIR)
	EndIf
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_CommandSend
Func _Guictrlsetcolor($hcolor, $bgcolor = "")
	;0 = Black  0x000000     8 = Gray          0x808080
	;1 = Blue   0x0000ff     9 = Light Blue    0x55ffff
	;2 = Green  0x00ff00     A = Light Green   0x55ff55
	;3 = Aqua   0x008080     B = Light Aqua    0x55ffff
	;4 = Red    0xff0000     C = Light Red     0xFF8080
	;5 = Purple 0x400040     D = Light Purple  0x8000FF
	;6 = Yellow 0xffff00     E = Light Yellow  0xFFFF80
	;7 = White  0xDBDBDB     F = Bright White  0xffffff
	Local $read = GUICtrlRead($Input1)
	Switch $hcolor
		Case 0;black
			$hcolor = "0x000000"
		Case 1;blue
			$hcolor = "0x0000ff"
		Case 2;green
			$hcolor = "0x00ff00"
		Case 3;aqua
			$hcolor = "0x00B7EF"
		Case 4;red
			$hcolor = "0xff0000"
		Case 5;purple
			$hcolor = "0x400040"
		Case 6;yellow
			$hcolor = "0xFFF200"
		Case 7;white
			$hcolor = "0xDBDBDB"
		Case 8;gray
			$hcolor = "0x808080"
		Case 9;light blue
			$hcolor = "0x00B7EF"
		Case 10;light green
			$hcolor = "0x55ff55"
		Case 11;light aqua
			$hcolor = "0x99D9EA"
		Case 12;light red
			$hcolor = "0xFF8080"
		Case 13;light purple
			$hcolor = "0x8000FF"
		Case 14;light yellow
			$hcolor = "0xFFF9BD"
		Case 15;bright white
			$hcolor = "0xffffff"
	EndSwitch
	Switch $bgcolor
		Case 0;black
			$bgcolor = "0x000000"
		Case 1;blue
			$bgcolor = "0x0000ff"
		Case 2;green
			$bgcolor = "0x00ff00"
		Case 3;aqua
			$bgcolor = "0x00B7EF"
		Case 4;red
			$bgcolor = "0xff0000"
		Case 5;purple
			$bgcolor = "0x400040"
		Case 6;yellow
			$bgcolor = "0xFFF200"
		Case 7;white
			$bgcolor = "0xDBDBDB"
		Case 8;gray
			$bgcolor = "0x808080"
		Case 9;light blue
			$bgcolor = "0x00B7EF"
		Case 10;light green
			$bgcolor = "0x55ff55"
		Case 11;light aqua
			$bgcolor = "0x99D9EA"
		Case 12;light red
			$bgcolor = "0xFF8080"
		Case 13;light purple
			$bgcolor = "0x8000FF"
		Case 14;light yellow
			$bgcolor = "0xFFF9BD"
		Case 15;bright white
			$bgcolor = "0xffffff"
	EndSwitch
	
	If $bgcolor = "" Then
		GUICtrlSetBkColor($Input1, $color)
	Else
		$bgcolor = $bgcolor
		GUICtrlSetBkColor($Input1, $bgcolor)
	EndIf
	If $hcolor = 0 And $bgcolor = 0 Then
		
		GUICtrlSetBkColor($Input1, "0xFFFFFF")
		GUICtrlSetColor($Input1, $hcolor)
	EndIf
	GUICtrlSetColor($Input1, $hcolor)
	GUICtrlSetData($Input1, $read & @CRLF & $DIR)
	$color = $hcolor
	$bcolor = $bgcolor
	_save()
EndFunc   ;==>_Guictrlsetcolor
Func _change($hfirst)
	If $hfirst > 1000000 Then
		$hsecond = StringTrimRight($hfirst, 6) & "," & StringMid($hfirst, 1, 3) & "," & StringTrimLeft($hfirst, 4) ; Puts a comma after the second number ex: 45,387
	ElseIf $hfirst > 100000 Then
		$hsecond = StringTrimRight($hfirst, 3) & "," & StringTrimLeft($hfirst, 3) ; Puts a comma after the second number ex: 45,387
	ElseIf $hfirst > 10000 Then
		$hsecond = StringTrimRight($hfirst, 3) & "," & StringTrimLeft($hfirst, 2) ; Puts a comma after the second number ex: 45,387
	ElseIf $hfirst > 1000 Then
		$hsecond = StringTrimRight($hfirst, 3) & "," & StringTrimLeft($hfirst, 1) ; Puts a comma after the second number ex:  5,227
	Else
		$hsecond = $hfirst
	EndIf
	Return $hsecond
EndFunc   ;==>_change
Func _servicepack()
	If @OSServicePack = "" Then
		Return "None"
	Else
		Return @OSServicePack
	EndIf
EndFunc   ;==>_servicepack
Func _Language()
	Select
		Case StringInStr("0413,0813", @OSLang)
			Return "Dutch"
		Case StringInStr("0409,0809,0c09,1009,1409,1809,1c09,2009, 2409,2809,2c09,3009,3409", @OSLang)
			Return "English"
		Case StringInStr("040c,080c,0c0c,100c,140c,180c", @OSLang)
			Return "French"
		Case StringInStr("0407,0807,0c07,1007,1407", @OSLang)
			Return "German"
		Case StringInStr("0410,0810", @OSLang)
			Return "Italian"
		Case StringInStr("0414,0814", @OSLang)
			Return "Norwegian"
		Case StringInStr("0415", @OSLang)
			Return "Polish"
		Case StringInStr("0416,0816", @OSLang)
			Return "Portuguese"
		Case StringInStr("040a,080a,0c0a,100a,140a,180a,1c0a,200a, 240a,280a,2c0a,300a,340a,380a,3c0a,400a, 440a,480a,4c0a,500a", @OSLang)
			Return "Spanish"
		Case StringInStr("041d,081d", @OSLang)
			Return "Swedish"
		Case Else
			Return "Other (can't determine with @OSLang directly)"
	EndSelect
EndFunc   ;==>_Language
Func _month()
	Select
		Case StringInStr("01", @MON)
			Return "January"
		Case StringInStr("02", @MON)
			Return "Feburary"
		Case StringInStr("03", @MON)
			Return "March"
		Case StringInStr("04", @MON)
			Return "April"
		Case StringInStr("05", @MON)
			Return "May"
		Case StringInStr("06", @MON)
			Return "June"
		Case StringInStr("07", @MON)
			Return "July"
		Case StringInStr("08", @MON)
			Return "August"
		Case StringInStr("09", @MON)
			Return "September"
		Case StringInStr("10", @MON)
			Return "October"
		Case StringInStr("11", @MON)
			Return "November"
		Case StringInStr("12", @MON)
			Return "December"
	EndSelect
EndFunc   ;==>_month
Func _lastupdated()
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & @CRLF & $lastupdated & $crlf & $DIR)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_lastupdated
Func _day()
	Select
		Case StringInStr("1", @WDAY)
			Return "Sunday"
		Case StringInStr("2", @WDAY)
			Return "Monday"
		Case StringInStr("3", @WDAY)
			Return "Tuesday"
		Case StringInStr("4", @WDAY)
			Return "Wednesday"
		Case StringInStr("5", @WDAY)
			Return "Thursday"
		Case StringInStr("6", @WDAY)
			Return "Friday"
		Case StringInStr("7", @WDAY)
			Return "Saturday"
	EndSelect
EndFunc   ;==>_day
Func _reset()
	$size = 9
	$weight = 400
	$attr = 0
	$font = "Lucida Console"
	$color = "0xC0C0C0"
	GUICtrlSetFont($Input1, $size, $weight, $attr, $font)
	GUICtrlSetColor($Input1, $color)
	GUICtrlSetBkColor($Input1, "0x000000")
	_save()
EndFunc   ;==>_reset
Func _font()
	$read = GUICtrlRead($Input1)
	GUISetState(@SW_MINIMIZE)
	$a_font = _ChooseFont($font, $size, "", $weight)
	If (@error) Then
		GUISetState(@SW_MAXIMIZE)
		_reset()
		GUICtrlSetData($Input1, $read & @CRLF & "error-" & @error & " nothing set" & $crlf & $DIR)
	Else
		GUISetState(@SW_RESTORE)
		$Italic = BitAND($a_font[1], 2)
		$Underline = BitAND($a_font[1], 4)
		$Strikethru = BitAND($a_font[1], 8)
		GUICtrlSetFont($Input1, $a_font[3], $a_font[4], $a_font[1], $a_font[2])
		$size = $a_font[3]
		$weight = $a_font[4]
		$attr = $a_font[1]
		$font = $a_font[2]
	EndIf
	_save($size, $weight, $attr, $font)
EndFunc   ;==>_font
Func _help()
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & $A6)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_help
Func _systeminfo()
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & @CRLF & "Loading system information ..")
	Send("{end}")
	Sleep(Random(2000, 6000, 1))
	GUICtrlSetData($Input1, $read & @CRLF & $A9)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_systeminfo
Func _Networkinfo()
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & @CRLF & "Loading network information ..")
	Send("{end}")
	Sleep(Random(2000, 6000, 1))
	GUICtrlSetData($Input1, $read & @CRLF & $networkInfo)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_Networkinfo
Func _color()
	
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & @CRLF & $A5)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_color
Func _shutdown()
	$read = GUICtrlRead($Input1)
	GUICtrlSetData($Input1, $read & @CRLF & $A2 & $crlf & $DIR)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
	Send("{end}")
EndFunc   ;==>_shutdown
Func _save($size = 8, $weight = 400, $attr = 0, $font = "Lucida Console", $color = "0xC0C0C0", $bcolor = "0x000000")
	$sData = "Size=" & $size & @LF & "Weight=" & $weight & @LF & "Attr=" & $attr & @LF & "Font=" & $font & @LF & "Color=" & $color & @LF & "BGColor=" & $bcolor
	IniWriteSection($settings, "Font Settings", $sData)
EndFunc   ;==>_save
Func _ChangeTime($hHour, $mMin)
	If $hHour > 12 Then
		$HOUR = $hHour - 12
		$AMPM = "PM"
		If $HOUR < 10 Then
			$HOUR = "0" & $HOUR
		EndIf
	ElseIf $hHour < 13 Then
		$HOUR = $hHour
		$AMPM = "AM"
	ElseIf $hHour = 0 Then
		$HOUR = 12
		$AMPM = "AM"
	ElseIf $hHour = 12 Then
		$HOUR = 12
		$AMPM = "PM"
	EndIf
	Return $HOUR & ":" & $mMin & " " & $AMPM
EndFunc   ;==>_ChangeTime
Func _GuiSnap($aTitle, $hDistance, $sX)
	Local $wSize
	If $aTitle = "" Then
		SetError(1)
	Else
		$wSize = WinGetPos($aTitle)
		If $wSize[0] < $hDistance And $wSize[1] < $hDistance Then
			WinMove($aTitle, '', $sX, $sX)
		ElseIf $wSize[0] < $hDistance Then
			WinMove($aTitle, '', $sX, $wSize[1])
		ElseIf $wSize[1] < $hDistance Then
			WinMove($aTitle, '', $wSize[0], $sX)
		EndIf
		If $wSize[0] > @DesktopWidth - $hDistance - $wSize[2] And $wSize[1] < $hDistance Then
			WinMove($aTitle, '', @DesktopWidth - $sX - $wSize[2], $sX)
		ElseIf $wSize[0] > @DesktopWidth - $hDistance - $wSize[2] Then
			WinMove($aTitle, '', @DesktopWidth - $sX - $wSize[2], $wSize[1])
		EndIf
	EndIf
EndFunc   ;==>_GuiSnap
Func _HelpHelp($HelpText)
	Local $Text
	$read = GUICtrlRead($Input1)
	If $HelpText = "beep" Then
		
	ElseIf $HelpText = "cd" Then
		$Text = "Displays the name of or changes the current directory." & $crlf & _
				"CD [run] [file name]" & @CRLF & _
				"CD [..]" & $crlf & _
				"  ..   Specifies that you want to change to the parent directory." & $crlf & _
				"Type CD without parameters to display the current drive and directory." & $crlf
	ElseIf $HelpText = "clear" Then
		$Text = "Clears the window and starts over." & $crlf
	ElseIf $HelpText = "color" Then
		$Text = $A5
	ElseIf $HelpText = "date" Then
		$Text = "Displays or sets the date." & $crlf & _
				"DATE [/T]" & $crlf & _
				"Type DATE without parameters to display the current date setting." & $crlf & _
				"If Command Extensions are enabled the DATE command supports" & @CRLF & _
				"the /T switch which tells the command to just output the" & @CRLF & _
				"current date, without prompting for a new date." & $crlf
	ElseIf $HelpText = "dir" Then
		$Text = "Displays a list of files and subdirectories in a directory." & $crlf
	ElseIf $HelpText = "exit" Then
		$Text = "Quits the" & $title & "program." & $crlf & _
				"EXIT" & $crlf
	ElseIf $HelpText = "help" Then
		$Text = "Provides help information for Windows commands." & $crlf & _
				"HELP [command]" & $crlf & _
				"	command - displays help information on that command." & $crlf
	ElseIf $HelpText = "ip" Then
		$Text = "The default is to display only the IP address." & $crlf
	ElseIf $HelpText = "kbsc" Then
		$Text = $A8
	ElseIf $HelpText = "logoff" Then
		$Text = "Terminates a session."
	ElseIf $HelpText = "log" Then
		$Text = @CRLF & $A7 & @CRLF
	ElseIf $HelpText = "shutdown" Then
		$Text = $A2 & $crlf
	ElseIf $HelpText = "systeminfo" Then
		$Text = "This tool displays operating system configuration information for" & @CRLF & _
				"a local or remote machine, including service pack levels." & $crlf
	ElseIf $HelpText = "tasklist" Then
		$Text = "This tool displays a list of currently running processes on" & @CRLF & _
				"either a local or remote machine." & $crlf
	ElseIf $HelpText = "time" Then
		$Text = "Displays or sets the system time." & $crlf & _
				"TIME [/T | time]" & $crlf & _
				"Type TIME with no parameters to display the current time setting." & $crlf & _
				"If Command Extensions are enabled the TIME command supports" & @CRLF & _
				"the /T switch which tells the command to just output the" & @CRLF & _
				"current time, without prompting for a new time." & $crlf
	ElseIf $HelpText = "vol" Then
		$Text = "Displays the disk volume label And serial number, If they exist." & $crlf & _
				"VOL[drive:]" & $crlf
	Else
		$Text = 'This command is not supported by the help utility.  Try ' & '"' & $HelpText & ' /?".' & $crlf
	EndIf
	GUICtrlSetData($Input1, $read & @CRLF & $Text & $DIR)
	$A = GUICtrlRead($Input1)
	$textnew = _GUICtrlEdit_GetTextLen($Input1)
EndFunc   ;==>_HelpHelp
Func _ComputerGetOSs(ByRef $aOSInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aOSInfo[1][60], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_CompName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_OperatingSystem", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aOSInfo[UBound($aOSInfo) + 1][60]
			$aOSInfo[$i][0] = $objItem.Name
			$aOSInfo[$i][1] = $objItem.BootDevice
			$aOSInfo[$i][2] = $objItem.BuildNumber
			$aOSInfo[$i][3] = $objItem.BuildType
			$aOSInfo[$i][4] = $objItem.Description
			$aOSInfo[$i][5] = $objItem.CodeSet
			$aOSInfo[$i][6] = $objItem.CountryCode
			$aOSInfo[$i][7] = $objItem.CreationClassName
			$aOSInfo[$i][8] = $objItem.CSCreationClassName
			$aOSInfo[$i][9] = $objItem.CSDVersion
			$aOSInfo[$i][10] = $objItem.CSName
			$aOSInfo[$i][11] = $objItem.CurrentTimeZone
			$aOSInfo[$i][12] = $objItem.DataExecutionPrevention_32BitApplications
			$aOSInfo[$i][13] = $objItem.DataExecutionPrevention_Available
			$aOSInfo[$i][14] = $objItem.DataExecutionPrevention_Drivers
			$aOSInfo[$i][15] = $objItem.DataExecutionPrevention_SupportPolicy
			$aOSInfo[$i][16] = $objItem.Debug
			$aOSInfo[$i][17] = $objItem.Distributed
			$aOSInfo[$i][18] = $objItem.EncryptionLevel
			$aOSInfo[$i][19] = $objItem.ForegroundApplicationBoost
			$aOSInfo[$i][20] = $objItem.FreePhysicalMemory
			$aOSInfo[$i][21] = $objItem.FreeSpaceInPagingFiles
			$aOSInfo[$i][22] = $objItem.FreeVirtualMemory
			$aOSInfo[$i][23] = __StringToDate($objItem.InstallDate)
			$aOSInfo[$i][24] = $objItem.LargeSystemCache
			$aOSInfo[$i][25] = __StringToDate($objItem.LastBootUpTime)
			$aOSInfo[$i][26] = __StringToDate($objItem.LocalDateTime)
			$aOSInfo[$i][27] = $objItem.Locale
			$aOSInfo[$i][28] = $objItem.Manufacturer
			$aOSInfo[$i][29] = $objItem.MaxNumberOfProcesses
			$aOSInfo[$i][30] = $objItem.MaxProcessMemorySize
			$aOSInfo[$i][31] = $objItem.NumberOfLicensedUsers
			$aOSInfo[$i][32] = $objItem.NumberOfProcesses
			$aOSInfo[$i][33] = $objItem.NumberOfUsers
			$aOSInfo[$i][34] = $objItem.Organization
			$aOSInfo[$i][35] = $objItem.OSLanguage
			$aOSInfo[$i][36] = $objItem.OSProductSuite
			$aOSInfo[$i][37] = $objItem.OSType
			$aOSInfo[$i][38] = $objItem.OtherTypeDescription
			$aOSInfo[$i][39] = $objItem.PlusProductID
			$aOSInfo[$i][40] = $objItem.PlusVersionNumber
			$aOSInfo[$i][41] = $objItem.Primary
			$aOSInfo[$i][42] = $objItem.ProductType
			$aOSInfo[$i][43] = $objItem.QuantumLength
			$aOSInfo[$i][44] = $objItem.QuantumType
			$aOSInfo[$i][45] = $objItem.RegisteredUser
			$aOSInfo[$i][46] = $objItem.SerialNumber
			$aOSInfo[$i][47] = $objItem.ServicePackMajorVersion
			$aOSInfo[$i][48] = $objItem.ServicePackMinorVersion
			$aOSInfo[$i][49] = $objItem.SizeStoredInPagingFiles
			$aOSInfo[$i][50] = $objItem.Status
			$aOSInfo[$i][51] = $objItem.SuiteMask
			$aOSInfo[$i][52] = $objItem.SystemDevice
			$aOSInfo[$i][53] = $objItem.SystemDirectory
			$aOSInfo[$i][54] = $objItem.SystemDrive
			$aOSInfo[$i][55] = $objItem.TotalSwapSpaceSize
			$aOSInfo[$i][56] = $objItem.TotalVirtualMemorySize
			$aOSInfo[$i][57] = $objItem.TotalVisibleMemorySize
			$aOSInfo[$i][58] = $objItem.Version
			$aOSInfo[$i][59] = $objItem.WindowsDirectory
			$i += 1
		Next
		$aOSInfo[0][0] = UBound($aOSInfo) - 1
		If $aOSInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetOSs
Func _ComputerGetNetworkCards(ByRef $aNetworkInfo)
	Local $colItems, $objWMIService, $objItem
	Dim $aNetworkInfo[1][34], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_CompName & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_NetworkAdapter", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			ReDim $aNetworkInfo[UBound($aNetworkInfo) + 1][34]
			$aNetworkInfo[$i][0] = $objItem.Name
			$aNetworkInfo[$i][1] = $objItem.AdapterType
			$aNetworkInfo[$i][2] = $objItem.AdapterTypeId
			$aNetworkInfo[$i][3] = $objItem.AutoSense
			$aNetworkInfo[$i][4] = $objItem.Description
			$aNetworkInfo[$i][5] = $objItem.Availability
			$aNetworkInfo[$i][6] = $objItem.ConfigManagerErrorCode
			$aNetworkInfo[$i][7] = $objItem.ConfigManagerUserConfig
			$aNetworkInfo[$i][8] = $objItem.CreationClassName
			$aNetworkInfo[$i][9] = $objItem.DeviceID
			$aNetworkInfo[$i][10] = $objItem.ErrorCleared
			$aNetworkInfo[$i][11] = $objItem.ErrorDescription
			$aNetworkInfo[$i][12] = $objItem.Index
			$aNetworkInfo[$i][13] = $objItem.Installed
			$aNetworkInfo[$i][14] = $objItem.LastErrorCode
			$aNetworkInfo[$i][15] = $objItem.MACAddress
			$aNetworkInfo[$i][16] = $objItem.Manufacturer
			$aNetworkInfo[$i][17] = $objItem.MaxNumberControlled
			$aNetworkInfo[$i][18] = $objItem.MaxSpeed
			$aNetworkInfo[$i][19] = $objItem.NetConnectionID
			$aNetworkInfo[$i][20] = $objItem.NetConnectionStatus
			$aNetworkInfo[$i][21] = $objItem.NetworkAddresses(0)
			$aNetworkInfo[$i][22] = $objItem.PermanentAddress
			$aNetworkInfo[$i][23] = $objItem.PNPDeviceID
			$aNetworkInfo[$i][24] = $objItem.PowerManagementCapabilities(0)
			$aNetworkInfo[$i][25] = $objItem.PowerManagementSupported
			$aNetworkInfo[$i][26] = $objItem.ProductName
			$aNetworkInfo[$i][27] = $objItem.ServiceName
			$aNetworkInfo[$i][28] = $objItem.Speed
			$aNetworkInfo[$i][29] = $objItem.Status
			$aNetworkInfo[$i][30] = $objItem.StatusInfo
			$aNetworkInfo[$i][31] = $objItem.SystemCreationClassName
			$aNetworkInfo[$i][32] = $objItem.SystemName
			$aNetworkInfo[$i][33] = __StringToDate($objItem.TimeOfLastReset)
			$i += 1
		Next
		$aNetworkInfo[0][0] = UBound($aNetworkInfo) - 1
		If $aNetworkInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc   ;==>_ComputerGetNetworkCards
Func __StringToDate($dtmDate)
	Return (StringMid($dtmDate, 5, 2) & "/" & _
			StringMid($dtmDate, 7, 2) & "/" & StringLeft($dtmDate, 4) _
			 & " " & StringMid($dtmDate, 9, 2) & ":" & StringMid($dtmDate, 11, 2) & ":" & StringMid($dtmDate, 13, 2))
EndFunc   ;==>__StringToDate