;~ ----------------------------------------------------------------------------
;~
;~ 	Script name:     ServiceMenu.exe
;~
;~  AutoIt Version:  3.2.12.1
;~
;~  Author:          Dave Snyder 06/2008
;~
;~
;~  Script Function: This script is an example of how to run an AutoIT script
;~                   as a service natively, with the ability to add, delete,
;~                   start, and stop the created service. 
;~
;~  Service Menu v1.0 - Run AutoIT script as service, with tray menu
;~
;~
;~
;~ ----------------------------------------------------------------------------
;~ Globals and includes
;~ Opt("OnExitFunc", "ExitScript");~ broken
Opt("TrayOnEventMode",1) ; Enables event driven scripting
Opt("TrayMenuMode",1)	; Default tray menu items (Script Paused/Exit) will not be shown.
Opt("TrayAutoPause",0)	; Script will not be paused when clicking the tray icon.

#NoTrayIcon
#RequireAdmin

#include <Process.au3>
#Include <String.au3>
#include <Misc.au3>
#include <GUIListBox.au3>
#include <GUIListView.au3>
#include <array.au3>
#include <INet.au3>
#include <Constants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <file.au3>
#include "_Au3Services.au3"


;~ The test variable!
Global $n_Evidence

;~ App Globals
Global $s_LocalComputer = "."
Global $s_ScriptObject = StringTrimRight(@ScriptName, 4)
Global $s_ServiceDesc = $s_ScriptObject & " Service Daemon"
Global $s_InstallFolder = @ScriptDir & "\"
Global $s_ScriptName = $s_ScriptObject & ".exe"
Global $s_AppPath = $s_InstallFolder & $s_ScriptName
Global $s_StrictAppPath = Chr(34) & $s_AppPath & Chr(34)
Global $s_LogfilePath = $s_InstallFolder & $s_ScriptObject & ".log"

;~ Run only one instance
if _Singleton($s_ScriptObject,1) = 0 Then
	TraySetState(1)
;~	Msgbox(0x41040, $s_ScriptObject, $s_ScriptObject & " is already running!")
	Exit
EndIf

;~ Service installed? If yes then run service code
If Not @Compiled Then
	MsgBox(0x41040, $s_ScriptObject, "Error. Service Daemon not compiled!",5)
	WinMain()
Else
	If _Service_Exists($s_ScriptObject) Then
		_Service_init($s_ScriptObject)
	Else
		WinMain()
	EndIf
EndIf
Exit

;~ Service mode Main routine.
Func Main()
	TrayMenu()
		While 1;~ check to see if we run differently
			WorkFunc()
		WEnd
	Exit
EndFunc

;~ Application mode Main routine.
Func WinMain()
	TrayMenu()
		While 1
			WorkFunc()
		WEnd
	Exit
EndFunc

;~ Set up System tray menu
Func TrayMenu()
	TraySetIcon("Shell32.dll",18)
	TraySetClick(16)
	$TestMenuItem1 = TrayCreateItem("Show Counter")
	TrayItemSetState($TestMenuItem1, $TRAY_DEFAULT)
	TrayItemSetOnEvent($TestMenuItem1, "TestFunction1")
	$ShowItem = TrayCreateItem("View Log File")
	TrayItemSetOnEvent($ShowItem,"ShowLog")
	$ClearItem = TrayCreateItem("Clear Log File")
	TrayItemSetOnEvent($ClearItem,"ClearLog")
	$ServiceSettingsMenu =TrayCreateMenu("Service Control")
	$AddServiceItem = TrayCreateItem("Add Service", $ServiceSettingsMenu)
	TrayItemSetOnEvent($AddServiceItem, "InstallService")
	$RemoveServiceItem = TrayCreateItem("Remove Service", $ServiceSettingsMenu)
	TrayItemSetOnEvent($RemoveServiceItem, "RemoveService")
	$ViewServiceItem = TrayCreateItem("View Services...", $ServiceSettingsMenu)
	TrayItemSetOnEvent($ViewServiceItem, "ViewServiceItem")
	TrayCreateItem("")
	$AboutItem = TrayCreateItem("About...")
	TrayItemSetOnEvent($AboutItem, "ShowInfo")
	TrayCreateItem("")
	$ExitItem = TrayCreateItem("Exit")
	TrayItemSetOnEvent($ExitItem, "ExitScript")
	TraySetState(1)
EndFunc

;~ The thing this app actully does
Func WorkFunc()
		;~ Main App code Goes here; THIS code tests the service functionality
		For  $i = 3600 to 1 Step -1
			sleep (1000)
			$n_Evidence = "Count down: "& $i & @crlf
			consolewrite($n_Evidence)
			_FileWriteLog(@ScriptDir & "\" & $s_ScriptObject & ".log",$n_Evidence)
		Next
		FileClose(@ScriptDir & "\" & $s_ScriptObject & ".log")
EndFunc

;~ Service Functions
;~ Install the script as a service in 'Services.msc'
Func InstallService()
 	If Not @Compiled Then
 		MsgBox(0x41040, $s_ScriptObject, "Error. Service Daemon not compiled!",5)
 	Else
		ConsoleWrite("Installing service, please wait" & @CRLF)
		_Service_Create($s_ScriptObject, $s_ServiceDesc, BitOR($SERVICE_INTERACTIVE_PROCESS,$SERVICE_WIN32_OWN_PROCESS), $SERVICE_AUTO_START,$SERVICE_ERROR_NORMAL, $s_StrictAppPath)
		If @error Then
			ConsoleWrite("Problem installing service, Error number is " & @error & @CRLF & " message  : " & _WinAPI_GetLastErrorMessage())
			Msgbox(0x41040, $s_ScriptObject,"Problem installing service, Error number is " & @error & @CRLF & " message  : " & _WinAPI_GetLastErrorMessage())
		Else
			ConsoleWrite("Installation of service successful")
			Msgbox(0x41040, $s_ScriptObject, $s_ScriptObject & " service installation complete. Reboot the PC for changes to take effect!")
		EndIf
		Exit
	EndIf
EndFunc

;~ Remove the script from 'Services.msc'
Func RemoveService()
 	If Not @Compiled Then
 		MsgBox(0x41040, $s_ScriptObject, "Error. Service Daemon not compiled!",5)
	EndIf
		_Service_Stop($s_ScriptObject)
		_Service_Delete($s_ScriptObject)
		if not @error then ConsoleWrite("Service removed successfully" & @crlf)
		Msgbox(0x41040, $s_ScriptObject, $s_ScriptObject & "service removal complete.")
		Exit
EndFunc

;~ Application functions
Func TestFunction1() ;~ Show the counter progress
	Msgbox(0x41040,$s_ScriptObject,$s_ScriptObject & " counter: " & $n_Evidence,5)
EndFunc

Func ViewServiceItem() ;~ call up 'services.msc'
    ShellExecute("services.msc")
EndFunc

;~ About me!
Func ShowInfo()
	Msgbox(0x41040,$s_ScriptObject,$s_ScriptObject & " 0.2 for Windows 2000, XP or 2003. ©2008 Dave Snyder")
EndFunc

;~ Show the logfile
Func ShowLog()
	ShellExecute($s_LogfilePath, "", @ScriptDir & "\", "open")
EndFunc

;~ Erase the log file
Func ClearLog()
	$choice = MsgBox(0x41021, $s_ScriptObject, "Are you sure you want to clear the log file?")
	If $choice = 1 Then
		_FileCreate ($s_LogfilePath)
		_FileWriteLog($s_LogfilePath,"Log file erased.")
		FileClose($s_LogfilePath)
		If @error > 0 Then
			MsgBox(0x41010, $s_ScriptObject, "Error creating logfile!")
			Return
		Else
			MsgBox(0x41040,$s_ScriptObject, "Log file has been erased.")
		EndIf
	EndIf
EndFunc

;~ Bye now
Func ExitScript()
	$exit = _Service_QueryStatus($s_ScriptObject)
	If $exit[1] = $SERVICE_RUNNING Then
		MsgBox(0x41040, $s_ScriptObject,  "Running in service mode. Use the 'Stop Service' menu item instead.",5)
		Return
	EndIf		
	Exit
EndFunc
