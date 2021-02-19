#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <misc.au3>
#NoTrayIcon

_Singleton(@ScriptName, 0)

If FileExists ( "Total Control! Settings.cfg" ) Then
	$RainmeterExe = IniRead ("Total Control! Settings.cfg", "RainmeterPath", "Executable", "-1")
	$SettingsFile = IniRead ("Total Control! Settings.cfg", "SettingsPath", "File", "-1")
	If $RainmeterExe == "-1" Then
		IniWrite ("Total Control! Settings.cfg", "RainmeterPath", "Executable", "Location Of Rainmeter Executable")
	EndIf
	If $SettingsFile == "-1" Then 
		IniWrite ("Total Control! Settings.cfg", "SettingsPath", "File", "Location Of Total Control Settings.inc")
	EndIf
	If $RainmeterExe OR $SettingsFile == "-1" Then _GUISettingsConfigurator()
Else
	IniWrite ("Total Control! Settings.cfg", "RainmeterPath", "Executable", "Location Of Rainmeter Executable")
	IniWrite ("Total Control! Settings.cfg", "SettingsPath", "File", "Location Of Total Control Settings.inc")
	$RainmeterExe = IniRead ("Total Control! Settings.cfg", "RainmeterPath", "Executable", "")
	$SettingsFile = IniRead ("Total Control! Settings.cfg", "SettingsPath", "File", "")
	_GUISettingsConfigurator()
EndIf

Func _GUISettingsConfigurator()
	GuiCreate("Please Locate The Following On Your System",401,128,-1,-1,$WS_BORDER,$WS_EX_ACCEPTFILES)
	$RainmeterExeLabel=GUICtrlCreateLabel("Rainmeter Executable", 15, 12)
	$RainmeterExeInput=GUICtrlCreateInput("Location Of Rainmeter Executable", 125, 10, 210, 20)
	GUICtrlSetData ($RainmeterExeInput, $RainmeterExe)
	GUICTRLSetState ( $RainmeterExeInput, $GUI_DROPACCEPTED)
	$RainmeterExeBrowse=GUICtrlCreateButton("Browse",340,8)
	$SettingsFileLabel=GUICtrlCreateLabel( "Total Control! Settings", 15, 42)   
	$SettingsFileInput=GUICtrlCreateInput("Location Of Total Control Settings.inc", 125, 40, 210, 20)
	$SettingsFileBrowse=GUICtrlCreateButton("Browse",340,38)
	GUICTRLSetState ( $SettingsFileInput, $GUI_DROPACCEPTED)
	$ConfigurationSaveAndExit=GuiCtrlCreateButton("Save All Changes And Exit",71,69)
	$ConfigurationExitWithoutSaving=GuiCtrlCreateButton("Exit Without Saving",216,69)
	GUISetState()
	
	While 1
		$msg=GuiGetMsg()
		If $msg=-3 Then Exit
		If $msg=$RainmeterExeBrowse Then	
			$RainmeterExeBrowseInput = FileOpenDialog("Location Of Rainmeter Executable", "::{7be9d83c-a729-4d97-b5a7-1b7313c39e0a}", "All (*.*)", "3", "Rainmeter.exe")
			GUICtrlSetData($RainmeterExeInput, $RainmeterExeBrowseInput, "0")
		EndIf
		If $msg=$SettingsFileBrowse Then
			$SettingsFileBrowseInput = FileOpenDialog ("Location Of Total Control Settings.inc", "::{450D8FBA-AD25-11D0-98A8-0800361B1103}","inc (*.inc)", "3", "Settings")
			GUICtrlSetData($SettingsFileInput, $SettingsFileBrowseInput, "0")
		EndIf
		If $msg=$ConfigurationSaveAndExit Then
		Msgbox(0,"",GUICTRLRead($RainmeterExeInput))
		IniWrite ("Total Control! Settings.cfg", "RainmeterPath", "Executable", GUICTRLRead($RainmeterExeInput))
		;IniWrite ("Total Control! Settings.cfg", "SettingsPath", "File", GUICtrlRead($SettingsFileInput))
		;Exit
		EndIf
		If $msg=$ConfigurationExitWithoutSaving Then
			$ExitDialog = MsgBox(36, "Are You Sure?", "Are you sure you want to exit?")
			If $ExitDialog = 6 then Exit
		EndIf
	Wend
EndFunc