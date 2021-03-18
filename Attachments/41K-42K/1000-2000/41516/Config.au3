#include <Date.au3>
Global $profilFile = "settings.ini"
Global $route = @ScriptDir & "\Jours"
Global $folder = DirCreate($route)
Global $day = _DateDayOfWeek(@WDAY) & ".txt"
Global $path = $route & "\" & $day
If Not FileExists($profilFile) Then
	writeConfigs()
EndIf

loadConfigs()



Func writeConfigs($profilFile = "settings.ini", $creation = 0)

	IniWrite($profilFile, "Kelly", "Heures", "")
	IniWrite($profilFile, "Kelly", "Jours", "")
	IniWrite($profilFile, "Babis", "Heures", "")
	IniWrite($profilFile, "Babis", "Jours", "")
	IniWrite($profilFile, "Lorenco", "Heures", "")
	IniWrite($profilFile, "Lorenco", "Jours", "")
	IniWrite($profilFile, "Adrien", "Heures", "")
	IniWrite($profilFile, "Adrien", "Jours", "")
	IniWrite($profilFile, "Ben", "Heures", "")
	IniWrite($profilFile, "Ben", "Jours", "")
	IniWrite($profilFile, "Marwan", "Heures", "")
	IniWrite($profilFile, "Marwan", "Jours", "")
	IniWrite($profilFile, "Tony", "Heures", "")
	IniWrite($profilFile, "Tony", "Jours", "")
	IniWrite($profilFile, "Roko", "Heures", "")
	IniWrite($profilFile, "Roko", "Jours", "")
	IniWrite($profilFile, "Fotis", "Heures", "")
	IniWrite($profilFile, "Fotis", "Jours", "")
	IniWrite($profilFile, "Adrea", "Heures", "")
	IniWrite($profilFile, "Adrea", "Jours", "")
EndFunc


Func writeConfig($profilFile = $path, $creation = 0)

	IniWrite($profilFile, "Kelly", "Heures", "")
	IniWrite($profilFile, "Kelly", "Jours", "")
	IniWrite($profilFile, "Babis", "Heures", "")
	IniWrite($profilFile, "Babis", "Jours", "")
	IniWrite($profilFile, "Lorenco", "Heures", "")
	IniWrite($profilFile, "Lorenco", "Jours", "")
	IniWrite($profilFile, "Adrien", "Heures", "")
	IniWrite($profilFile, "Adrien", "Jours", "")
	IniWrite($profilFile, "Ben", "Heures", "")
	IniWrite($profilFile, "Ben", "Jours", "")
	IniWrite($profilFile, "Marwan", "Heures", "")
	IniWrite($profilFile, "Marwan", "Jours", "")
	IniWrite($profilFile, "Tony", "Heures", "")
	IniWrite($profilFile, "Tony", "Jours", "")
	IniWrite($profilFile, "Roko", "Heures", "")
	IniWrite($profilFile, "Roko", "Jours", "")
	IniWrite($profilFile, "Fotis", "Heures", "")
	IniWrite($profilFile, "Fotis", "Jours", "")
	IniWrite($profilFile, "Adrea", "Heures", "")
	IniWrite($profilFile, "Adrea", "Jours", "")
EndFunc

Func loadConfigs($profilFile = "settings.ini", $creation = 0)

	$kellyh = IniRead($profilFile, "Kelly", "Heures", "")
	$kellyj = IniRead($profilFile, "Kelly", "Jours", "")
	$babish = IniRead($profilFile, "Babis", "Heures", "")
	$babisj = IniRead($profilFile, "Babis", "Jours", "")
	$lorencoh = IniRead($profilFile, "Lorenco", "Heures", "")
	$lorencoj = IniRead($profilFile, "Lorenco", "Jours", "")
	$adrienh = IniRead($profilFile, "Adrien", "Heures", "")
	$adrienj = IniRead($profilFile, "Adrien", "Jours", "")
	$benh = IniRead($profilFile, "Ben", "Heures", "")
	$benj = IniRead($profilFile, "Ben", "Jours", "")
	$marwanh = IniRead($profilFile, "Marwan", "Heures", "")
	$marwanj = IniRead($profilFile, "Marwan", "Jours", "")
	$tonyh = IniRead($profilFile, "Tony", "Heures", "")
	$tonyj = IniRead($profilFile, "Tony", "Jours", "")
	$rokoh = IniRead($profilFile, "Roko", "Heures", "")
	$rokoj = IniRead($profilFile, "Roko", "Jours", "")
	$fotish = IniRead($profilFile, "Fotis", "Heures", "")
	$fotisj = IniRead($profilFile, "Fotis", "Jours", "")
	$adreah = IniRead($profilFile, "Adrea", "Heures", "")
	$adreaj = IniRead($profilFile, "Adrea", "Jours", "")
EndFunc