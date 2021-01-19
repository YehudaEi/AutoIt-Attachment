#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author:         Brad Flight

 Script Function:
	This script automates the install of the eVault Director application

#ce ----------------------------------------------------------------------------

#include <file.au3>
Dim $Settings
If Not _FileReadToArray("settings.txt",$Settings) Then
   MsgBox(4096,"Error", " Error reading HotBox settings     error:" & @error)
   Exit
EndIf


; Script Start - Add your code below here
Run("InfoStageDirector-5-53-2227b.exe")
; WinWaitActive("Note", "still want to install")
; Send("!y")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "will install")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "Agreement")
Send("{SPACE}")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "QuickShip")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "following folder")
Send("!r")
WinWaitActive("Choose Folder", "installation folder")
Send("C:\InfoStage\Director")
Send("{ENTER}")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "following folder")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "working data")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("$Settings[0]")
Send("{TAB}")
Send("!n")
; WinWaitActive("Confirm New Directory", "You have entered")
Send("{ENTER}")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "primary storage")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("$Settings[1]")
Send("{TAB}")
Send("!n")
; WinWaitActive("Confirm New Directory", "You have entered")
Send("!y")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "Vault Database engine")
Send("{TAB}")
Send("{TAB}")
Send("{TAB}")
Send("C:\InfoStage\Director\VaultDatabase")
Send("{TAB}")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "notification")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "e-mail address")
Send("$Settings[2]")
Send("{TAB}")
Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "SMTP")
Send("$Settings[3]")
Send("{TAB}")
Send("!n")
MouseMove(751, 658, 0)
MouseClick("left")
MouseDown("left")
Sleep(10)
MouseUp("left")
; Send("!n")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "Please enter the license")
Send("{TAB}")
Send("{TAB}")
;Send("2KG86-QMG66-7Z94H-46233")
Send("$Settings[4]")
;Sleep(105000)
Send("{TAB}")
Send("!n")
Sleep(118000)
; WinWaitActive("EVault InfoStage Director - InstallSheild Wizard", "next 30 days")
MouseMove(640, 550, 0)
MouseDown("left")
Sleep(10)
MouseUp("left")
; Send("{ENTER}")
WinWaitActive("EVault InfoStage Director 5.53 Setup", "Setup has finished")
Send("{ENTER}")


