#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.0
 Author:         Dstroyr

 Script Function:
    UltraVNC Automated Install Script.

#ce ----------------------------------------------------------------------------

; Script Start

; Run the VNC installer
Run("UltraVNC_1.0.9.6.2_x64_Setup.exe")


; Welcome Screen
WinWaitActive("Setup - UltraVNC")
Send("!n")

; License Agreement
WinWaitActive("Setup - UltraVNC")
Send("!a")
Send("!n")

; Install Info
WinWaitActive("Setup - UltraVNC")
Send("!n")

; Install Location
WinWaitActive("Setup - UltraVNC")
Send("!n")

; Components to install
WinWaitActive("Setup - UltraVNC")
ControlCommand('[CLASS:TNewComboBox]','','controlID',"SelectString", 'UltraVNC Server Only   "silent"')
Send("!n")

; Start Menu Creation
WinWaitActive("Setup - UltraVNC")
Send("!n")

; Icons & Services Etcetera
WinWaitActive("Setup - UltraVNC")
Send("!r")
Send("!s")
Send("!d")
Send("!n")

; Start Install
WinWaitActive("Setup - UltraVNC")
Send("!i")

; Release Information
WinWaitActive("Setup - UltraVNC")
Send("!n")

; Wizard Completion
WinWaitActive("Setup - UltraVNC")
Send("!f")

; Run the UltraVNC Server Config Editor
Run("C:\Program Files\UltraVNC\uvnc_settings.exe")

; Configure
WinWaitActive("UltraVnc settings")
Send("{LShift}+{Tab}")
Send("{Right}")
Send("password")
Send("{Tab}")
Send("password")
Send("{ENTER}")

Exit

