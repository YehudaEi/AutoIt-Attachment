;-----------------------------------------------------
; Application Credits
;-----------------------------------------------------
; Product: Remote Command Console
; Author: BlackDawn187
; Version: 1.2
;
; Developed: February 18, 2014
;-----------------------------------------------------

;-----------------------------------------------------
; Change Log
;-----------------------------------------------------
; v1.1 - Published Plugin to hosting web server
; v1.2 - Implemented a feature to show or, hide the GUI
;-----------------------------------------------------

;-----------------------------------------------------
; Application Includes & Misc Elements
;-----------------------------------------------------
#NoTrayIcon
AutoItSetOption("WinTitleMatchMode", 2)
;-----------------------------------------------------
; AutoIt Specific Includes
;-----------------------------------------------------
#include <File.au3>
#include <Array.au3>
#include <Misc.au3>
;-----------------------------------------------------

;-----------------------------------------------------
; Global Application Variables
;-----------------------------------------------------
$GlobalVersion = IniRead("Config.ini", "Global Settings", "Global Version", "")
$GlobalDebug = "False" ;Set to false to disable debuging information or, true to enable.
$GUIState = IniRead("Config.ini", "Global Settings", "GUI State", "On") 
$Version = "1.2"
$Address = IniRead("Config.ini", "Global Settings", "Address", "")
$Title = IniRead("Config.ini", "Global Settings", "Title", "")
$Author = IniRead("Config.ini", "Global Settings", "Author", "")
;-----------------------------------------------------

;-----------------------------------------------------
; Initiate Program
;-----------------------------------------------------
Call("FirstRun")
;-----------------------------------------------------

;-----------------------------------------------------
; Functions List
;-----------------------------------------------------
Func FirstRun()
While 1
   $InstallCheck = IniRead("Config.Ini", "Plugins", "RCC", "") 
   $PluginINICheck = IniRead("Plugins.ini", "RCC", "Verification", "False")
   Sleep("1000")  
   If FileExists("Config.ini") = "1" And $PluginINICheck <> "" And $InstallCheck = "Installed" And WinExists("" & $Title & " v" & $GlobalVersion & " by " & $Author & " - [Online]") Then
	  Call("AdminCheck")
	  ExitLoop
   ElseIf FileExists("Config.ini") = "1" And $PluginINICheck <> "" And $InstallCheck = "Installed" And WinExists("" & $Title & " v" & $GlobalVersion & " by " & $Author & " - [Offline]") Then
	  Call("AdminCheck")
	  ExitLoop
   ElseIf FileExists("Config.ini") = "1" And $InstallCheck = "" Then
	  Call("Install")
	  ExitLoop
   ElseIf FileExists("Config.ini") = "1" And $InstallCheck = "Installed" And $PluginINICheck <> "False" Then
	  MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "Launch Failed: Main Application is not currently running", 10)
	  Exit
   ElseIf FileExists("Config.ini") = "1" And $InstallCheck = "Installed" And $PluginINICheck = "False" Then
	  MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "Install Failed: Configuration File Missing", 10)
	  Exit
   ElseIf FileExists("Config.ini") = "0" And $InstallCheck = "" Then
	  MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "Install Failed: Configuration File Missing", 10)
	  Exit
   ElseIf FileExists("Config.ini") = "0" And $InstallCheck = "Installed" Then
	  MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "Install Failed: Configuration File Missing", 10)
	  Exit
   Else
	  MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "Installation Successful: This plugin can now be launched via the main application", 10)
	  ExitLoop
   EndIf
WEnd
EndFunc

Func AdminCheck()
;-----------------------------------------------------
; Request Admin Privileges
;-----------------------------------------------------
#RequireAdmin
$Admin = IsAdmin()
If $Admin = 1 Then
   Call ("RCC")   
ElseIf $Admin = 0 Then
   MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "This application requires Administrative Privleges to function properly," & @CRLF & "Please restart or, reload the application to proceed.")
   Exit
EndIf
EndFunc

Func RCC()
   While 1
   $ParentDir = StringLeft("" & @ScriptDir & "", StringInStr("" & @ScriptDir & "", "\", 0, -1) -1)
   $RCC_GUI_State = IniRead("" & $ParentDir & "\Config.ini", "Global Settings", "GUI State", "")
   FileDelete("" & @ScriptDir & "\RCC\Command.dat")
   If $RCC_GUI_State = "On" Then
	  $LocalAddress = IniRead("" & @ScriptDir & "\Config.ini", "Global Settings", "Address", "")
	  InetGet("" & $LocalAddress & "rcc.php", "" & @ScriptDir & "\RCC\Command.dat", 1, 0)
	  $OldCommand = IniRead("Plugins.ini", "RCC", "Old Command", "")
	  $NewCommand = FileRead("" & @ScriptDir & "\RCC\Command.dat")
	  If $NewCommand = $OldCommand Then
		 Sleep("100")
	  ElseIf $NewCommand <> $OldCommand And @error = "" Then
		 BlockInput(1)
		 WinActivate("" & $Title & " v" & $GlobalVersion & " by " & $Author & "")
		 WinWaitActive("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", 10000)
		 ControlSetText("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", "[ID:11]", "")
		 ControlSetText("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", "[ID:11]", $NewCommand)
		 Sleep("1000")
		 Send("{Enter}")
		 BlockInput(0)
		 IniWrite("Plugins.ini", "RCC", "Old Command", $NewCommand)
	  EndIf
	  Sleep("30000")
   ElseIf $RCC_GUI_State = "Off" Then
	  $LocalAddress = IniRead("" & @ScriptDir & "\Config.ini", "Global Settings", "Address", "")
	  InetGet("" & $LocalAddress & "rcc.php", "" & @ScriptDir & "\RCC\Command.dat", 1, 0)
	  $OldCommand = IniRead("Plugins.ini", "RCC", "Old Command", "")
	  $NewCommand = FileRead("" & @ScriptDir & "\RCC\Command.dat")
	  If $NewCommand = $OldCommand Then
		 Sleep("100")
	  ElseIf $NewCommand <> $OldCommand And @error = "" Then
		 BlockInput(1)
		 Send("^!S")
		 WinActivate("" & $Title & " v" & $GlobalVersion & " by " & $Author & "")
		 WinWaitActive("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", 10000)
		 ControlSetText("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", "[ID:11]", "")
		 ControlSetText("" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "", "[ID:11]", $NewCommand)
		 Sleep("1000")
		 Send("{Enter}")
		 Send("^!H")
		 BlockInput(0)
		 IniWrite("Plugins.ini", "RCC", "Old Command", $NewCommand)
	  EndIf
	  Sleep("30000")
   EndIf
   WEnd
EndFunc

Func Install()
MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "[Remote Command Console]: Installing...", 10)
   DirCreate("RCC")
   IniWrite("Plugins.ini", "RCC", "Verification", "True")
   IniWrite("Plugins.ini", "RCC", "AutoRun", "False")
   IniWrite("Config.ini", "Plugins", "RCC", "Installed")
MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "[Remote Command Console]: Installation Complete!", 10)   
   Sleep("1000") 
EndFunc
