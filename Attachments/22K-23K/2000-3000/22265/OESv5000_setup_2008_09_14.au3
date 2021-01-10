#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=OES.ico
#AutoIt3Wrapper_Outfile=OESv5000.exe
#AutoIt3Wrapper_Res_Description=Outlook & OExpress Saver
#AutoIt3Wrapper_Res_Fileversion=5.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=(C) 2008 by Ritzelrocker04
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=AutoIt Version|3.2.12.1
#AutoIt3Wrapper_Res_Field=Compiled by|Ritzelrocker04
#AutoIt3Wrapper_Res_Field=Original Name|Outlook & OExpress Saver
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Thx to Crazy-A, Peethebee, Xenobiologist, BugFix, Progandy & Oscar

#Region ### Include Section ###
#include <AVIConstants.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#EndRegion ### Include Section ###

#Region ### Optionen Section ###
Opt('GUIOnEventMode', 1) ;i 1 Schaltet den OnEvent-Mode ein
Opt('MustDeclareVars', 1) ;i Variablen müssen vor der Benutzung deklariert werden
Opt('TrayAutoPause', 0) ;i das Script nicht pausieren, wenn auf das Tray-Icon geklickt wird
Opt('GUICloseOnESC', 0) ;i das drücken der ESC-Taste führt nicht zum beenden des Programms
#EndRegion ### Optionen Section ###

#Region ### Variablen Section ###
;i directories & files
Global $ini = @ScriptDir & "\OESsys\oes.ini" ;i Path & Name Inifile
Global $OESmedia = @ScriptDir & "\OESsys\oes_rc.dll" ;! Path & Name zur Ressource-DLL - erstellt mit AutoIT-Bordmitteln ;)
Global $info = @ScriptDir & '\OESsys\OES_Info.chm'
Global $ndDing = @WindowsDir & "\Media\ding.wav" ;i M$sound
Global $languages, $actual_lang, $actual_lang_name, $new_lang
Global $lang_dir = @ScriptDir & "\lang"

Global $7zip
Global $version = "5.0.00"
Global $title = "Outlook & Outlook Express Saver"
;i array
Global $aFormat[3] = ['Copy', 'Zip', '7zip'], $aFormatGB[3]
Global $aDateien[3] = ['Microsoft Outlook', 'Outlook Express', 'Address Book'], $aDateienGB[3]
Global $ziel, $ident, $dest, $src

;! Guicontrols vor der Func _ini_read_lang()
Global $GUI, $fileMenu, $startItem, $exitItem, $OptMenu, $langItem, $helpMenu, $helpItem, $aboutItem, _
		$gbSources, $tbDest, $bnDest, $lbLocation, $gbFormat, $ckbRest, $bnStart, $bnCancel, $tatusLine

_ini_read_lang()
#EndRegion ### Variablen Section ###

#Region ### Check Section ###
;i ist 7zip auf dem PC schon installiert ?
If FileExists(RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip", "Path") & "\7z.exe") Then
	;i dann verwende das installierte 7zip !
	$7zip = RegRead("HKEY_LOCAL_MACHINE\SOFTWARE\7-Zip", "Path") & "\7z.exe"
Else
	;i ist kein 7zip installiert, verwende dieses 7zip.
	$7zip = @ScriptDir & "\OESsys\7za.exe"
	If Not FileExists($7zip) Then Exit MsgBox(16, 'Error ' & $title, $7zip & @CRLF & @CRLF & 'File Not Found ! ')
	;! Beenden & Nachricht an User, wenn 7zip nicht existiert
EndIf
#EndRegion ### Check Section ###

#Region ### START OES GUI section ###
$GUI = GUICreate($title, 350, 200)
WinSetOnTop($title, '', 1) ;i 1 = den Wert für "Immer im Vordergrund" setzen
GUISetOnEvent($GUI_EVENT_CLOSE, '_quit')

;i Menüleiste - Datei
$fileMenu = GUICtrlCreateMenu($languages[1][1])
$startItem = GUICtrlCreateMenuItem($languages[2][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_start')
GUICtrlCreateMenuItem("", $fileMenu, -1)
$exitItem = GUICtrlCreateMenuItem($languages[3][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_quit')

;i Menüleiste - Optionen
$OptMenu = GUICtrlCreateMenu($languages[4][1])
$langItem = GUICtrlCreateMenuItem($languages[5][1], $OptMenu)
GUICtrlSetOnEvent(-1, '_lang')

;i Menüleiste - Hilfe
$helpMenu = GUICtrlCreateMenu("?")
$helpItem = GUICtrlCreateMenuItem($languages[6][1], $helpMenu)
GUICtrlSetOnEvent(-1, '_info')
$aboutItem = GUICtrlCreateMenuItem($languages[7][1], $helpMenu)
GUICtrlSetOnEvent(-1, '_about')

#Region Group Quelle
$gbSources = GUICtrlCreateGroup($languages[8][1], 5, 2, 340, 38) ;i create group Quelle
GUICtrlSetColor(-1, 0x0040F0) ; blau
For $i = 0 To 2
	$aDateienGB[$i] = GUICtrlCreateRadio($aDateien[$i], 20 + $i * 110, 17, 102, 17) ;i erstellt 3 Optionsfelder (Radio button)
	GUICtrlSetState($aDateienGB[1], $GUI_CHECKED)
	GUICtrlSetTip(-1, $languages[14][1])
Next
GUICtrlCreateGroup("", -99, -99, 1, 1) ;i close group Quelle
#EndRegion Group Quelle

$tbDest = GUICtrlCreateInput(IniRead($ini, "Destination", "Path", "C:\$Backup$"), 90, 61, 255, 17, $ES_READONLY)
;! $ES_READONLY - Eingaben nur über $bnDest möglich
GUICtrlSetBkColor(-1, 0xFFFFFF) ;i weiss
$bnDest = GUICtrlCreateButton("...", 5, 61, 75, 17, 0)
GUICtrlSetOnEvent(-1, '_dest')
GUICtrlSetTip(-1, $languages[16][1])
$lbLocation = GUICtrlCreateLabel($languages[9][1], 13, 44, 70, 17)
GUICtrlSetColor(-1, 0x0040F0) ;i blau

#Region Group Format
$gbFormat = GUICtrlCreateGroup($languages[10][1], 5, 87, 340, 38) ;i create group $gbFormat
GUICtrlSetColor(-1, 0x0040F0) ;i blau
For $i = 0 To 2
	$aFormatGB[$i] = GUICtrlCreateRadio($aFormat[$i], 52 + $i * 100, 102, 45, 17) ;i erstellt 3 Optionsfelder (Radio button)
	GUICtrlSetState($aFormatGB[1], $GUI_CHECKED)
	GUICtrlSetTip(-1, $languages[18][1])
Next
GUICtrlCreateGroup("", -99, -99, 1, 1) ;i close group $gbFormat
#EndRegion Group Format

DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
$ckbRest = GUICtrlCreateCheckbox("Restore", 10, 132, 60, 17)
GUICtrlSetTip(-1, $languages[20][1])
GUICtrlSetOnEvent(-1, '_restore')
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 7)
$bnStart = GUICtrlCreateButton($languages[11][1], 185, 134, 75, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_start')
GUICtrlSetTip(-1, $languages[21][1])
$bnCancel = GUICtrlCreateButton($languages[12][1], 265, 134, 75, 22, 0)
GUICtrlSetOnEvent(-1, '_quit')
GUICtrlSetTip(-1, $languages[22][1])
GUICtrlCreateLabel("RR04 for AutoIT.de", 5, 150, 100, 17)
GUICtrlSetFont(-1, 8, 400, 0, "Arial")
GUICtrlSetColor(-1, 0x808080)
$tatusLine = GUICtrlCreateLabel("", 0, 164, 350, 17, BitOR($SS_SUNKEN, $SS_CENTER))
GUICtrlSetData($tatusLine, 'Version ' & $version & @TAB & @MDAY & ' - ' & @MON & ' - ' & @YEAR)

GUISetState(@SW_SHOW, $GUI)
#EndRegion ### START OES GUI section ###

#Region ### Language GUI section ###
Global $aFlag[3] = ['151', '150', '152'], $aFlagAvi[3]

Global $langGUI = GUICreate($title, 330, 250, -1, -1, $WS_SYSMENU, -1, $GUI)
GUISetBkColor(0xFFFFFF);i Hintergrundfarbe des Fensters
WinSetOnTop($title, '', 1) ;i den Wert für "Immer im Vordergrund" setzen
GUISetOnEvent($GUI_EVENT_CLOSE, '_closeLang')
GUICtrlCreateGroup("", 5, 0, 315, 185) ;i create group

For $m = 0 To 2
	$aFlagAvi[$m] = GUICtrlCreateAvi($OESmedia, $aFlag[$m], 25 + $m * 100, 40, 70, 50, $ACS_AUTOPLAY) ;i erstellt 3 AVI´s
Next

GUICtrlCreateLabel("Please choose your language:", 10, 120, 305, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0040F0) ;i blau
Global $gui_combo_lang = GUICtrlCreateCombo("", 65, 140, 200, 17)
_read_lang()

GUICtrlCreateGroup("", -99, -99, 1, 1) ;i close group
GUICtrlCreateButton("OK", 124, 190, 76, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_closeLang')
#EndRegion ### Language GUI section ###

#Region ### AboutGUI section ###
Global $aAbout[7] = ['Product Name :', 'Outlook and Outlook Express Saver', 'Version : ', _
		$version & @TAB & 'Build 2008 - 09 - 11', 'Copyright (C) 2008 by Ritzelrocker04', 'Thx an das www.AutoIT.de - Team', _
		'Special thanks to Crazy-A and Oscar'], $aAboutLB[7]

Global $aboutGUI = GUICreate($title, 330, 250, -1, -1, $WS_SYSMENU, -1, $GUI)
WinSetOnTop($title, '', 1) ;i den Wert für "Immer im Vordergrund" setzen
GUISetOnEvent($GUI_EVENT_CLOSE, '_closeAbout')
GUICtrlCreateGroup("", 5, 0, 315, 185) ;i create group
GUICtrlCreateAvi($OESmedia, 160, 25, 40, 40, 44, $ACS_AUTOPLAY)
GUICtrlCreateIcon($OESmedia, -1, 28, 120, 32, 32)
For $i = 0 To 6
	$aAboutLB[$i] = GUICtrlCreateLabel($aAbout[$i], 100, 16 + $i * 24, 200, 17) ;i erstellt 7 Label
Next
GUICtrlCreateGroup("", -99, -99, 1, 1) ;i close group
GUICtrlCreateButton("OK", 124, 190, 76, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_closeAbout')
#EndRegion ### AboutGUI section ###

#Region ### AniGUI section ###
Global $aniGUI = GUICreate($title, 300, 100, -1, -1, $WS_SYSMENU, -1, $GUI)
Global $Avi = GUICtrlCreateAvi("shell32.dll", 167, 14, 10) ;i soll die XP-Animation abspielen
GUICtrlSetState($Avi, 1)
#EndRegion ### AniGUI section ###

While 1
	Sleep(900)
WEnd

Func _start()
	$ziel = GUICtrlRead($tbDest) ;i auslesen der Nutzereingaben
	IniWrite($ini, 'Destination', 'Path', $ziel) ;i    ini write	the $ziel

	For $i = 0 To 2
		If BitAND(GUICtrlRead($aDateienGB[$i]), $GUI_CHECKED) = $GUI_CHECKED Then
			Switch $i
				Case 0
					$src = @UserProfileDir & '\Lokale Einstellungen\Anwendungsdaten\Microsoft\Outlook\'
					;! Quelle für FileExists, DirCopy, 7zip & Identities einfügen
					If Not FileExists($src) Then Exit MsgBox(16, 'Error ' & $title, 'Die Datei "' & $src & '" konnte nicht gefunden werden ! ')
					;! Beenden & Nachricht an User, wenn bezeichnete Datei oder Verzeichnis nicht existiert
					$dest = $ziel & "\$Outlook$\Outlook" ;i Destination
					
				Case 1
					$ident = RegRead("HKEY_CURRENT_USER\Identities", "Default User ID") ;i die Identities auslesen
					$src = @UserProfileDir & '\Lokale Einstellungen\Anwendungsdaten\Identities\' & $ident & '\Microsoft\Outlook Express\'
					;! Quelle für FileExists, DirCopy, 7zip & Identities einfügen
					If Not FileExists($src) Then Exit MsgBox(16, 'Error ' & $title, 'Die Datei "' & $src & '" konnte nicht gefunden werden ! ')
					;! Beenden & Nachricht an User, wenn bezeichnete Datei oder Verzeichnis nicht existiert
					$dest = $ziel & "\$OutlookExpress$\OutlookExpress" ;i Destination
					
				Case 2
					$src = @UserProfileDir & '\Anwendungsdaten\Microsoft\Address Book\'
					;! Quelle für FileExists, DirCopy, 7zip & Identities einfügen
					If Not FileExists($src) Then Exit MsgBox(16, 'Error ' & $title, 'Die Datei "' & $src & '" konnte nicht gefunden werden ! ')
					;! Beenden & Nachricht an User, wenn bezeichnete Datei oder Verzeichnis nicht existiert
					$dest = $ziel & "\$AddressBook$\AddressBook" ;i Destination
			EndSwitch
		EndIf
	Next
	
	For $j = 0 To 2
		If BitAND(GUICtrlRead($aFormatGB[$j]), $GUI_CHECKED) = $GUI_CHECKED Then ;i Radiobutton prüfen ; wenn ein, dann...
			Switch $j
				Case 0
					If BitAND(GUICtrlRead($ckbRest), $GUI_CHECKED) = $GUI_CHECKED Then
						_recopy()
					Else
						If FileExists($dest) Then ;! prüfen, ob bezeichnete Datei oder Verzeichnis existiert
							FileDelete($dest) ;! löscht eine bezeichnete oder mehr Dateien
						EndIf
						_copy()
					EndIf
					
				Case 1
					$dest &= '.zip ' ;i Packformat "*.zip"
					
					If BitAND(GUICtrlRead($ckbRest), $GUI_CHECKED) = $GUI_CHECKED Then
						_unzip()
					Else
						$7zip &= " a -tzip " ;i Packformat "*.zip"
						_zip()
					EndIf
					
				Case 2
					$dest &= '.7z ' ;i Packformat "*.7z"
					
					If BitAND(GUICtrlRead($ckbRest), $GUI_CHECKED) = $GUI_CHECKED Then
						_unzip()
					Else
						$7zip &= " a -t7z " ;i Packformat "*.7z"
						_zip()
					EndIf
			EndSwitch
		EndIf
	Next

	;SoundSetWaveVolume(50) ;i Lautstärke 50% optional
	SoundPlay($ndDing, 1) ;i M$Sound abspielen
	MsgBox(262144 + 64, $title, $languages[27][1] & @CRLF & @CRLF & @MDAY & "-" & @MON & "-" & @YEAR & " - " & @HOUR & ":" & @MIN & " " & $languages[28][1])
	;! Erfolgsmeldung ausgeben
	_quit() ;i Programm autom. beenden
EndFunc   ;==>_start

Func _quit()
	Exit
EndFunc   ;==>_quit

Func _dest()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	
	Local $path = FileSelectFolder($languages[26][1], "::{00000000-1080-F9E5-6311-4162E05A6BEE}", 1)
	If Not @error Then
		GUICtrlSetData($tbDest, $path)
	EndIf
EndFunc   ;==>_dest

Func _copy()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	GUISetState(@SW_SHOW, $aniGUI) ;i aniGUI anzeigen
	FileCopy($src, $dest & "\*.*", 1 + 8)
	;i ausführen der eigentlichen Sicherung
	GUISetState(@SW_HIDE, $aniGUI) ;i aniGUI verstecken
EndFunc   ;==>_copy

Func _recopy()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	GUISetState(@SW_SHOW, $aniGUI) ;i aniGUI anzeigen
	FileCopy($dest & "\*.*", $src, 1 + 8)
	;i ausführen der eigentlichen Rücksicherung
	GUISetState(@SW_HIDE, $aniGUI) ;i aniGUI verstecken
EndFunc   ;==>_recopy

Func _zip()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	GUISetState(@SW_SHOW, $aniGUI) ;i aniGUI anzeigen
	If FileExists($dest) Then ;! prüfen, ob bezeichnete Datei oder Verzeichnis existiert
		FileDelete($dest) ;! löscht eine bezeichnete oder mehr Dateien
	EndIf
	RunWait(@ComSpec & ' /c ' & $7zip & $dest & '"' & $src & '*.*"', @ScriptDir, @SW_HIDE)
	;i Aufruf von 7z zum packen
	GUISetState(@SW_HIDE, $aniGUI) ;i aniGUI verstecken
EndFunc   ;==>_zip

Func _unzip()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	GUISetState(@SW_SHOW, $aniGUI) ;i aniGUI anzeigen
	RunWait(@ComSpec & ' /c ' & $7zip & ' x -aoa -o' & '"' & $src & '"' & ' ' & $dest, @ScriptDir, @SW_HIDE)
	;i Aufruf von 7z zum entpacken
	GUISetState(@SW_HIDE, $aniGUI) ;i aniGUI verstecken
EndFunc   ;==>_unzip

Func _restore()
	If BitAND(GUICtrlRead($ckbRest), $GUI_CHECKED) = $GUI_CHECKED Then
		GUICtrlSetData($startItem, "Restore")
		GUICtrlSetData($bnStart, "Restore")
		GUICtrlSetColor($ckbRest, 0xFF0000) ;i rot
		GUICtrlSetTip($ckbRest, $languages[23][1], 'Restore', 2, 3) ;i mit Icon, als Ballon-Tip, zentriert, nach unten
		MsgBox(262144 + 64, "Restore Modus", $languages[24][1] & @CRLF & $languages[25][1] & @CRLF & "" & @CRLF & 'Copyright: (C) 2008 by Ritzelrocker04 (www.AutoIT.de) ')
	Else
		GUICtrlSetData($startItem, $languages[2][1])
		GUICtrlSetData($bnStart, $languages[11][1])
		GUICtrlSetColor($ckbRest, 0x000000) ;i schwarz
		GUICtrlSetTip($ckbRest, $languages[20][1])
	EndIf
EndFunc   ;==>_restore

Func _about()
	GUISetState(@SW_SHOW, $aboutGUI) ;i aboutGUI anzeigen
EndFunc   ;==>_about

Func _closeAbout()
	GUISetState(@SW_HIDE, $aboutGUI) ;i aboutGUI verstecken
EndFunc   ;==>_closeAbout

Func _info() ;by Oscar
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	Local $rc
	ShellExecute($info)
	$rc = WinWait('OES_Info', '', 3)
	If $rc = 0 Then Return MsgBox(0, $title, 'Die Hilfedatei konnte nicht geöffnet werden!')
	ControlMove('OES_Info', '', '[CLASS:HH Child; INSTANCE:2]', 0, 40, 280)
	ControlMove('OES_Info', '', '[CLASS:HH Child; INSTANCE:1]', 284, 40)
	ControlTreeView('OES_Info', '', '[CLASS:SysTreeView32; INSTANCE:1]', 'Expand', '#0')
EndFunc   ;==>_info

Func _lang()
	GUISetState(@SW_SHOW, $langGUI) ;i $langGUI anzeigen
EndFunc   ;==>_lang

Func _closeLang()
	_gui_config()
	_ini_read_lang()
	GUISetState(@SW_HIDE, $langGUI) ;i $langGUI verstecken
EndFunc   ;==>_closeLang

Func _read_lang()
	Local $aFList = '', $sFiles, $hXls = FileFindFirstFile($lang_dir & '\*.lng')
	
	While 1
		$sFiles = FileFindNextFile($hXls)
		If @error = 1 Or $sFiles = "" Then
			FileClose($hXls)
			ExitLoop
		EndIf
		If StringRight($sFiles, 4) = ".lng" Then
			$aFList = $aFList & "|" & StringTrimRight($sFiles, 4)
		EndIf
		If FileExists($actual_lang) = 1 Then
			GUICtrlSetData($gui_combo_lang, $aFList, StringTrimRight($actual_lang_name, 4))
		ElseIf FileExists($actual_lang) = 0 Then
			GUICtrlSetData($gui_combo_lang, $aFList, "Deutsch")
		EndIf
	WEnd
EndFunc   ;==>_read_lang

Func _gui_config()
	$new_lang = GUICtrlRead($gui_combo_lang) & ".lng"
	If $new_lang = "" Or FileExists($lang_dir & "\" & $new_lang) = 0 Then
		$new_lang = "Deutsch.lng"
	EndIf
	IniWrite($ini, "language", "current", $new_lang)
EndFunc   ;==>_gui_config

Func _ini_read_lang()
	;read_options
	$actual_lang_name = IniRead($ini, "language", "current", "Deutsch.lng")
	$actual_lang = $lang_dir & "\" & $actual_lang_name
	;ini_read_lang
	
	$languages = IniReadSection($actual_lang, "default_values")
	If @error Then MsgBox(4096, "", "Error occurred, probably no lng file.")
	
	Global $Label[23] = ['', $fileMenu, $startItem, $exitItem, $OptMenu, $langItem, $helpItem, $aboutItem, $gbSources, _
			$lbLocation, $gbFormat, $bnStart, $bnCancel, $aDateienGB[0], $aDateienGB[1], $aDateienGB[2], $bnDest, _
			$aFormatGB[0], $aFormatGB[1], $aFormatGB[2], $ckbRest, $bnStart, $bnCancel]
	
	For $i = 1 To 12
		GUICtrlSetData($Label[$i], $languages[$i][1])
	Next
	For $i = 13 To 22
		GUICtrlSetTip($Label[$i], $languages[$i][1])
	Next
EndFunc   ;==>_ini_read_lang

; Ende