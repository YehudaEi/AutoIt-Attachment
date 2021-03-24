;-----------------------------------------------------
; Application Credits
;-----------------------------------------------------
; Product: Example Plugin Script
; Author: BlackDawn187
; Version: 1.1
;
; Developed: January 14, 2014
; Updated: February 7, 2014
;-----------------------------------------------------

;-----------------------------------------------------
; Change Log
;-----------------------------------------------------
; v1.0 - Published Plugin to hosting web server
; v1.1 - Added Compatability Support for Hub v1.2+
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
$Version = "1.1"
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
   $InstallCheck = IniRead("Config.Ini", "Plugins", "Example", "") 
   $PluginINICheck = IniRead("Plugins.ini", "Example", "Verification", "False")
   Sleep("1000")  
   If FileExists("Config.ini") = "1" And $PluginINICheck <> "" And $InstallCheck = "Installed" And WinExists("" & $Title & " v" & $GlobalVersion & " by " & $Author & " - [Online]") Then
	  Call("MessageBox")
	  ExitLoop
   ElseIf FileExists("Config.ini") = "1" And $PluginINICheck <> "" And $InstallCheck = "Installed" And WinExists("" & $Title & " v" & $GlobalVersion & " by " & $Author & " - [Offline]") Then
	  Call("MessageBox")
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

Func MessageBox()
   MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "This is an Example Plugin," & @CRLF & "" & @CRLF & "Which must be compiled to execute from the main application", 10)
EndFunc

Func Install()
MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "[Example]: Installing...", 10)
   IniWrite("Plugins.ini", "Example", "Verification", "True")
   IniWrite("Plugins.ini", "Example", "AutoRun", "False")
   IniWrite("Config.ini", "Plugins", "Example", "Installed")
MsgBox(0, "" & $Title & " v" & $GlobalVersion & " by " & $Author & "", "[Example]: Installation Complete!", 10)   
   Sleep("1000")   
Call("FirstRun")
EndFunc
