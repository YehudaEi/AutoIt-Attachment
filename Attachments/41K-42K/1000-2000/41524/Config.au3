#include <Date.au3>

Global $profilFile = "settings.ini"
Global $route = @ScriptDir & "\Jours"
Global $folder = DirCreate($route)
Global $day = _DateDayOfWeek(@WDAY) & ".txt"
Global $path = $route & "\" & $day


If Not FileExists($profilFile) Then
	writeConfigs()
EndIf

Func writeConfigs($profilFile = "settings.ini", $creation = 0)

	IniWriteSection($profilFile, "Kelly", "")
	IniWriteSection($profilFile, "Leandro", "")
	IniWriteSection($profilFile, "Lorenco", "")
	IniWriteSection($profilFile, "Adrien", "")
	IniWriteSection($profilFile, "Ben", "")
	IniWriteSection($profilFile, "Marwan", "")
	IniWriteSection($profilFile, "Tony", "")
	IniWriteSection($profilFile, "Roko", "")
	IniWriteSection($profilFile, "Fotis", "")
	IniWriteSection($profilFile, "Adrea", "")

EndFunc