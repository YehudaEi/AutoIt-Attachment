#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=..\..\Sonstiges\Design\icons\icon pack 2\2.0\Steam.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <File.au3>

Func loadsettings()
	Local $settingsfile = FileOpen(@ScriptDir & "\settings.txt")
	Global $loaded_port = FileReadLine($settingsfile, 1)
	Global $loaded_maxplayers= FileReadLine($settingsfile, 2)
	Global $loaded_map = FileReadLine($settingsfile, 3)
	Global $loaded_direction = FileReadLine($settingsfile, 4)
	FileClose($settingsfile)
EndFunc

Func savesettings($port, $maxplayers, $map, $direction)
	Local $settingsfile = FileOpen(@ScriptDir & "\settings.txt", 2)
	FileWriteLine(@ScriptDir & $settingsfile, $port)
	FileWriteLine(@ScriptDir & $settingsfile, $maxplayers)
	FileWriteLine(@ScriptDir & $settingsfile, $map)
	FileWriteLine(@ScriptDir & $settingsfile, $direction)
	FileClose($settingsfile)
EndFunc

If FileExists(@ScriptDir & "\settings.txt") Then
	loadsettings()
Else
	Global $loaded_port = "27015"
	Global $loaded_maxplayers= "24"
	Global $loaded_map = "plr_hightower"
	If FileExists("C:\Program Files (x86)") Then
		Global $loaded_direction = "C:\Program Files (x86)\HLServer"
	Else
		Global $loaded_direction = "C:\Program Files\HLServer"
	EndIf
EndIf

#Region ### START Koda GUI section ### Form=
$Main_Window = GUICreate("TF2 Server", 238, 318, 944, 356)
$Label1 = GUICtrlCreateLabel("Max Players", 12, 8, 78, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$input_maxplayers = GUICtrlCreateInput($loaded_maxplayers, 32, 32, 41, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$start = GUICtrlCreateButton("STARTEN", 8, 96, 219, 41)
GUICtrlSetFont(-1, 15, 400, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0x008000)
$update = GUICtrlCreateButton("UPDATE", 8, 224, 219, 25)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xA6CAF0)
$stop = GUICtrlCreateButton("STOPPEN", 8, 144, 217, 33)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xFF0000)
$input_map = GUICtrlCreateInput($loaded_map, 40, 64, 185, 21)
$Label2 = GUICtrlCreateLabel("Map", 8, 72, 31, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$Label3 = GUICtrlCreateLabel("Port", 152, 8, 28, 20)
GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
$input_port = GUICtrlCreateInput($loaded_port, 128, 32, 81, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_NUMBER))
$input_direction = GUICtrlCreateInput($loaded_direction, 8, 264, 217, 21)
$savesettings = GUICtrlCreateButton("Einstellungen speichern", 32, 288, 169, 25)
$restart = GUICtrlCreateButton("NEU STARTEN", 8, 184, 217, 33)
GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
GUICtrlSetColor(-1, 0x000000)
GUICtrlSetBkColor(-1, 0xFFFF00)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

Func startserver($port, $maxplayers, $map, $direction)
	ShellExecute("srcds.exe", "-console -game tf -port " & $port & " +maxplayers " & $maxplayers & " +map " & $map, $direction & "\orangebox")
EndFunc

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			If ProcessExists("srcds.exe") Then
				MsgBox(0, "Hinweis", "Der Server läuft weiter!")
				Exit
			Else
				Exit
			EndIf
		Case $update
			Run("update.bat")
			MsgBox(0, "Update erfolgreich!", "Update wurde ausgeführt")
		Case $stop
			If ProcessExists("srcds.exe") Then
				ProcessClose("srcds.exe")
				MsgBox(0, "Server gestoppt", "Der Server wurde erfolgreich gestoppt!")
			Else
				MsgBox(0, "Fehler", "Der Server konnte nicht gestoppt werden, da er nicht läuft.")
			EndIf
		Case $restart
			If ProcessExists("srcds.exe") Then
				ProcessClose("srcds.exe")
				Global $port = GUICtrlRead($input_port)
				Global $maxplayers = GUICtrlRead($input_maxplayers)
				Global $map = GUICtrlRead($input_map)
				Global $direction = GUICtrlRead($input_direction)
				startserver($port, $maxplayers, $map, $direction)
				MsgBox(0, "Server wird neu gestartet", "Der Server wurde erfolgreich gestoppt und wird nun erneut gestartet!")
			Else
				MsgBox(0, "Fehler", "Der Server konnte nicht neu gestartet werden, da er nicht läuft.")
			EndIf
		Case $start
			Global $port = GUICtrlRead($input_port)
			Global $maxplayers = GUICtrlRead($input_maxplayers)
			Global $map = GUICtrlRead($input_map)
			Global $direction = GUICtrlRead($input_direction)
			startserver($port, $maxplayers, $map, $direction)
		Case $savesettings
			Global $port = GUICtrlRead($input_port)
			Global $maxplayers = GUICtrlRead($input_maxplayers)
			Global $map = GUICtrlRead($input_map)
			Global $direction = GUICtrlRead($input_direction)
			If FileExists(@ScriptDir & "\settings.txt") Then
				FileDelete(@ScriptDir & "\settings.txt")
				_FileCreate(@ScriptDir & "\settings.txt")
				savesettings($port, $maxplayers, $map, $direction)
				MsgBox(0, "Einstellungen überschrieben", "Die aktuellen Einstellungen wurden gespeichert" & @CRLF & "und werden bei einem Neustart geladen.")
			Else
				_FileCreate(@ScriptDir & "\settings.txt")
				savesettings($port, $maxplayers, $map, $direction)
				MsgBox(0, "Einstellungen gespeichert", "Die aktuellen Einstellungen wurden gespeichert" & @CRLF & "und werden bei einem Neustart geladen.")
			EndIf

	EndSwitch
WEnd

