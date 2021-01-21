#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         myName
 
 SpeedFan 4.33

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here

Opt("TrayIconDebug", 1)
Opt("SendKeyDelay", 200)
; Executable file name
$EXECUTABLE = "installspeedfan433.exe"
; Installation folder
$INSTALLLOCATION = @ProgramFilesDir & "\SpeedFan"

If FileExists($INSTALLLOCATION & "\speedfan.exe") Then
	MsgBox(0x40010, @ScriptName, "Please uninstall previous version of SpeedFan before using this script", 4)
	Exit
EndIf

; Run the installer
Run($EXECUTABLE)

; Please, read carefully:
WinWaitActive("SpeedFan Setup: License Agreement", "Please, read carefully:")
ControlClick("SpeedFan Setup: License Agreement", "", "Button2")

; License Agreement
WinWaitActive("SpeedFan Setup: Installation Options", "Components")
ControlClick("SpeedFan Setup: Installation Options", "", "Button2")

; Install directory
WinWaitActive("SpeedFan Setup: Installation Folder", "Install directory")
ControlSetText("SpeedFan Setup", "", "Edit1", "")
Sleep(1000)
ControlSetText("SpeedFan Setup", "", "Edit1", $INSTALLLOCATION)
ControlClick("SpeedFan Setup: Installation Folder", "", "Button2")

; Completed
WinWaitActive("SpeedFan Setup: Completed", "Completed")
ControlClick("SpeedFan Setup: Completed", "", "Button2")