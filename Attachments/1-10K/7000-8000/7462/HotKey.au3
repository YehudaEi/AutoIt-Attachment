;HotKey.au3 - version 1.2
;This small script allows you to define (up to 64) Hot Keys for any file in your
; system in a simple INI file.
;You can fint example of the INI file here: 
;         http://www.autoitscript.com/forum/index.php?showtopic=22959
;The following combinations are not allowed:
;<CTRL>+<ALT>+X - reserved for exiting the program
;<CTRL>+<ALT>+H - reserved for printing out the current set HotKeys
;*******************************************************************************
#include <GuiConstants.au3>

;The following IF statement allows the compiled script to be started twice only
;if it's started with "/restart" parameter, otherwise there can be
;only one instance of it.
If Not $CMDLINE[0] Then
    If UBound(ProcessList(@ScriptName)) > 2 Then Exit
ElseIf $CMDLINE[1] <> "/restart" Then
    Exit
EndIf

Global $HK=CheckINI() ;Filling the array with the hotkeys from the INI file and checking for some errors

Opt("TrayMenuMode",1)
Opt("TrayOnEventMode",1)

$Settings_tray = TrayCreateItem("Settings")
TrayItemSetOnEvent($Settings_tray,"_Settings")

$Current_tray = TrayCreateItem("Current HotKeys (Ctrl+Alt+H)")
TrayItemSetOnEvent($Current_tray,"_HOT")

$Restart_tray = TrayCreateItem("Restart")
TrayItemSetOnEvent($Restart_tray,"_Restart")

$exit_tray = TrayCreateItem("Exit (Ctrl+Alt+X)")
TrayItemSetOnEvent($exit_tray,"_Exit")

TraySetState()

HotKeySet ( "^!x","_Exit")
HotKeySet ( "^!h","_HOT")

For $i=1 to $HK[0][0]
    HotKeySet ( "^"&$HK[$i][0],"StartEvent") ;setting the HotKeys
Next

While 1
	sleep (100)
WEnd

Func StartEvent() ;starting the event corresponding to the pressed HotKey
     $Pressed=StringTrimLeft(@HotKeyPressed,1)
     For $i=1 to $HK[0][0]
     	   If $Pressed=$HK[$i][0] Then
     	   	DllCall("shell32.dll","long","ShellExecute","hwnd",0,"string","","string",$HK[$i][1],"string","","string","","long",@SW_SHOWNORMAL)
     	   	exitloop
     	   EndIf
     Next
EndFunc

Func CheckINI() ;checking for errors in the INI file and returning an array
     $var = IniReadSection(@ScriptDir&"\HotKey.ini", "HOTKEYS")
     For $i=1 To $var[0][0]
     	   $var[$i][0]=StringLower($var[$i][0])
     Next
	If @error Then
	    MsgBox(16,"HotKey","Error! Probably missing INI file or [HOTKEYS] section in the INI file.")
	    exit
	ElseIf $var[0][0]>64 Then
	    MsgBox(16,"HotKey","You have defined more than 64 (max)hot keys!")
	    exit
	Else
	    For $i=1 to $var[0][0]
	    	  If StringLen($var[$i][0])>2 Then
	    	     MsgBox(16,"HotKey","Error! The KEY """&$var[$i][0]&""" in the INI file consists of more than 2 sybmols!")
	    	     exit
		  ElseIf $var[$i][0]="!x" Then
		     MsgBox(16,"HotKey","Error! The combination ""!x"" is for exiting the HotKey program!")
	    	     exit
	    	  ElseIf $var[$i][0]="!h" Then
		     MsgBox(16,"HotKey","Error! The combination ""!h"" is for viewing the current set HotKeys!")
	    	     exit
	    	  ElseIf $var[$i][0]="" Then
		     MsgBox(16,"HotKey","Error! Missing key for the value """&$var[$i][1]&""" in the INI file!")
		     exit
		  ElseIf $var[$i][1]="" Then
		     MsgBox(16,"HotKey","Error! The key """&$var[$i][0]&""" in the INI file has no value!")
		     exit
		  EndIf   
	    Next
 	    return($var)
	EndIf

EndFunc

Func _Settings() ;Calling Notepad to edit the INI file
     Run("notepad.exe "&@ScriptDir&"\HotKey.ini")
EndFunc

Func _HOT() ;printing out the current set HotKeys
     $Hkeys=""
     For $i=1 to $HK[0][0]
     	   $ALTreplace=StringReplace($HK[$i][0],"!","<ALT>+")
     	   $SHIFTreplace=StringReplace($ALTreplace,"+","<SHIFT>+")
     	   $Hkeys=$Hkeys&"<CTRL>+"&$SHIFTreplace&" = "&$HK[$i][1]&@CRLF
     Next
     MsgBox(64,"Current set HotKeys:",$Hkeys)
EndFunc

Func _Exit()
     exit
EndFunc

Func _Restart()
     If @Compiled Then
     	  Run(@ScriptFullPath& " /restart")
     	  exit
     Else
        MsgBox(64,"HotKey","The Restart works only when the script is a compiled executable.")
     EndIf
EndFunc