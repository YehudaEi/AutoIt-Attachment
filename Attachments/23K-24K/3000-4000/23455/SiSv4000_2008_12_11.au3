#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=SiSsys\SiS_48x48.ico
#AutoIt3Wrapper_Outfile=SiSv4000.exe
#AutoIt3Wrapper_Res_Description=Sicher ist Sicher
#AutoIt3Wrapper_Res_Fileversion=4.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=© 2008 by Ritzelrocker04
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Field=AutoIt Version|%AutoItVer%
#AutoIt3Wrapper_Res_Field=Compiled by|Ritzelrocker04
#AutoIt3Wrapper_Res_Field=Original Name|Sicher ist Sicher
#AutoIt3Wrapper_Run_Obfuscator=y
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

; Thx to Peethebee, Xenobiologist, BugFix, Progandy, Greenhorn, Funkey & Oscar

#Region ### Include Section ###
#include <File.au3>
#include <String.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#EndRegion ### Include Section ###

#Region ### Optionen Section ###
Opt('GUIOnEventMode', 1) ;i 1 Schaltet den OnEvent-Mode ein
Opt('MustDeclareVars', 1) ;i Variablen müssen vor der Benutzung deklariert werden
Opt('TrayAutoPause', 0) ;i das Script nicht pausieren, wenn auf das Tray-Icon geklickt wird
Opt('GUICloseOnESC', 0) ;i das drücken der ESC-Taste führt nicht zum beenden des Programms
Opt('TrayMenuMode', 1) ;i 1 = kein Standard Menü erstellen
#EndRegion ### Optionen Section ###

#Region ### Variablen Section ###
;i Global Variablen
Global $build = "  Build 2008-12-11"
Global $version = "Version 4.0.00"
Global $title = 'SiS  for  AutoIT.de  by  Ritzelrocker04'
Global $dest, $ff, $tb, $ol, $oe, $ab, $ie, $ed, $time, $LW, $srcLW, $srcLive
Global $7zip, $ziel, $src, $srcR, $7z1, $7z2, $dauer
Global $tate = $GUI_ENABLE

;i directories & files
Global $ini = @ScriptDir & "\SiS.ini" ; Path & Name to Inifile
Global $ndDing = @WindowsDir & "\Media\ding.wav" ;i M$sound
Global $ndClick = @SystemDir & "\oobe\images\clickerx.wav" ;i M$sound
Global $identPath = _
		RegRead("HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders", "Local AppData")
Global $ident = RegRead("HKEY_CURRENT_USER\Identities", "Default User ID") ;i Identities read
Global $SiSmedia = @ScriptDir & "\SiSsys\sis_rc.dll" ;! Path & Name zur Ressource-DLL - erstellt mit ResHacker ;)
Global $helpFile = @ScriptDir & '\SiSsys\SiS_Help.chm'
Global $sysInfo = @CommonFilesDir & "\Microsoft Shared\MSInfo\msinfo32.exe" ;i M$ Windows XP M$sysinfo

Global $languages, $actual_lang, $actual_lang_name, $new_lang
Global $lang_dir = @ScriptDir & "\lang"

;i array
Global $aDatenCkb[8], $counter = 0
Global $aTimeRb[3]
Global $aArmatur[3] = ["PC", "7zip", "Auto"], $aArmaturCkb[3]
Global $aFile

;! Guicontrols der HauptGUI, vor der Func _ini_read_lang()
Global $GUI, $fileMenu, $fileItem, $openItem, $saveItem, $exitItem
Global $optMenu, $setItem, $translatorItem, $langItem, $viewMenu, $viewStatusItem, $sysInfoItem, $drivesInfoItem, $drivesInfoSubItem
Global $helpMenu, $helpMenuItem, $infoItem, $aboutItem
Global $ckbTime, $gbDest, $tbB, $bnDest, $lbDest, $lbDestVol, $cobDest, $bnI, $bnS, $ckbR, $bnOK, $bnClose, $tatusLine

Global $tabItem0, $lbSaveSet, $tabItem1, $lbLang, $lbTransEnd, $aResultLB[7], $aResult[7]

#EndRegion ### Variablen Section ###

#Region ### Check Section ###
;i Die Existenz der notwendigen Basisdateien abfragen
Global $aExistFileBase[3] = [$lang_dir & "\English.lng", $SiSmedia, @ScriptDir & "\SiSsys\7za.exe"]
For $z = 0 To 2 ;i statisch kein Ubound
	If Not FileExists($aExistFileBase[$z]) Then Exit _
			MsgBox(262144 + 16, 'Error ' & $title, $aExistFileBase[$z] & @CRLF & @CRLF & "File Not Found ! ")
Next
_ini_read_lang() ;i Sprachdatei einlesen
If FileExists(@ProgramFilesDir & "\7-Zip\7z.exe") Then
	;i ist 7zip schon auf dem PC installiert ?
	$7zip = @ProgramFilesDir & "\7-Zip\7z.exe"
	;i dann verwende dieses 7zip !
Else
	$7zip = @ScriptDir & "\SiSsys\7za.exe"
	;i wurde kein 7zip gefunden, dann verwende dieses 7zip.
EndIf
#EndRegion ### Check Section ###

#Region ### START SiS GUI Section ###
$GUI = GUICreate($title, 400, 350)
WinSetOnTop($title, '', 1) ;i 1 = den Wert für "Immer im Vordergrund" setzen
GUISetOnEvent($GUI_EVENT_CLOSE, '_quit')
;i Datei - Menü
$fileMenu = GUICtrlCreateMenu($languages[1][1])
$fileItem = GUICtrlCreateMenuItem($languages[2][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_dest')
$openItem = GUICtrlCreateMenuItem($languages[3][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_openDest')
$saveItem = GUICtrlCreateMenuItem($languages[4][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_OKpressed')
GUICtrlCreateMenuItem("", $fileMenu)
$exitItem = GUICtrlCreateMenuItem($languages[5][1], $fileMenu)
GUICtrlSetOnEvent(-1, '_quit')
;i Optionen - Menü
$optMenu = GUICtrlCreateMenu($languages[6][1])
$setItem = GUICtrlCreateMenuItem($languages[7][1], $optMenu)
GUICtrlSetOnEvent(-1, '_armatur')
$translatorItem = GUICtrlCreateMenuItem("&Translator" & @TAB & "Alt+O+T", $optMenu)
GUICtrlSetOnEvent(-1, '_translator')
$langItem = GUICtrlCreateMenuItem($languages[8][1], $optMenu)
GUICtrlSetOnEvent(-1, '_armatur')
;i Extras - Menü
$viewMenu = GUICtrlCreateMenu($languages[9][1])
$viewStatusItem = GUICtrlCreateMenuItem($languages[10][1], $viewMenu)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetOnEvent(-1, '_statuslabel')
$sysInfoItem = GUICtrlCreateMenuItem($languages[11][1], $viewMenu)
GUICtrlSetOnEvent(-1, '_sysInfo')
$drivesInfoItem = GUICtrlCreateMenu($languages[12][1], $viewMenu)
;i Hilfe - Menü
$helpMenu = GUICtrlCreateMenu($languages[13][1])
$helpMenuItem = GUICtrlCreateMenuItem($languages[14][1], $helpMenu)
GUICtrlSetOnEvent(-1, '_sisHelp')
$infoItem = GUICtrlCreateMenuItem($languages[15][1], $helpMenu)
GUICtrlSetOnEvent(-1, '_info')
$aboutItem = GUICtrlCreateMenuItem($languages[16][1], $helpMenu)
GUICtrlSetOnEvent(-1, '_about')

#Region Group All
GUICtrlCreateGroup("", 5, 0, 390, 170) ; create group $gbAll
Global $avi = GUICtrlCreateAvi($SiSmedia, 150, 10, 10, 163, 150)

#Region Group Daten
GUICtrlCreateLabel("", 220, 12, 164, 152)
GUICtrlSetBkColor(-1, 0xEEEEEE) ;i silber
GUICtrlSetState(-1, $GUI_DISABLE)

GUICtrlCreateGroup("", 220, 5, 165, 160) ; create group $gbDaten

;! Rundruf Teil-1 - Nicht existierende Dateien sind nicht answählbar - Das Sichern verläuft ohne Unterbrechungen
Global $aExistFile[8] = ['', @AppDataDir & '\Mozilla\Firefox\profiles.ini', @AppDataDir & '\Thunderbird\profiles.ini', _
		@AppDataDir & '\Microsoft\Outlook\', $identPath & '\Identities\' & $ident & '\Microsoft\Outlook Express\', _
		@AppDataDir & '\Microsoft\Address Book\', @FavoritesDir & '\', @MyDocumentsDir & '\']

Global $aDatenCk = IniReadSection($ini, "Daten")
If @error Then Global $aDatenCk[8][2] = [[7, 0],['FF', $GUI_UNCHECKED],['TB', $GUI_UNCHECKED], _
		['OL', $GUI_UNCHECKED],['OE', $GUI_UNCHECKED],['AB', $GUI_UNCHECKED],['IE', $GUI_UNCHECKED],['ED', $GUI_CHECKED]]
For $i = 1 To 7 ;i statisch kein Ubound
	$aDatenCkb[$i] = GUICtrlCreateCheckbox($languages[$i + 16][1], 240, $i * 20, 105, 17)
	GUICtrlSetBkColor(-1, 0xEEEEEE)
	; create 7x Checkbox
	GUICtrlSetState(-1, $aDatenCk[$i][1])
	GUICtrlSetTip(-1, $languages[45][1])
	GUICtrlSetTip($aDatenCkb[7], $languages[48][1])
	
	If Not FileExists($aExistFile[$i]) Then GUICtrlSetState($aDatenCkb[$i], $GUI_DISABLE)
	;! Rundruf Teil-2 - Nicht existierende Dateien sind nicht answählbar - Das Sichern verläuft ohne Unterbrechungen
Next
GUICtrlCreateGroup("", -99, -99, 1, 1) ; close group $gbDaten
#EndRegion Group Daten

GUICtrlCreateGroup("", -99, -99, 1, 1) ; close group $gbAll
#EndRegion Group All

#Region Time
$ckbTime = GUICtrlCreateCheckbox($languages[24][1], 15, 178, 75, 28, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_MULTILINE))
GUICtrlSetOnEvent(-1, '_ckbTime')
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlSetTip(-1, $languages[49][1])

Global $aTimeCk = IniReadSection($ini, "Time") ;### Start solution by Oscar ;)
If @error Then Global $aTimeCk[4][2] = [[3, 0],["YEAR", $GUI_UNCHECKED],["MDAY", $GUI_UNCHECKED],["WDAY", $GUI_CHECKED]]
For $i = 0 To 2 ;i statisch kein Ubound
	$aTimeRb[$i] = GUICtrlCreateRadio($languages[$i + 25][1], 100 + $i * 100, 180, 88, 28, BitOR($BS_AUTORADIOBUTTON, $BS_MULTILINE))
	; create 3x Radio
	GUICtrlSetState(-1, $aTimeCk[$i + 1][1])
	GUICtrlSetTip(-1, $languages[51][1])
Next ;### Ende solution by Oscar ;)
#EndRegion Time

#Region Group Destination
$gbDest = GUICtrlCreateGroup("", 5, 205, 390, 66) ;i create group $gbDest
$tbB = GUICtrlCreateInput("", 56, 218, 328, 18)
GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
GUICtrlSetBkColor(-1, 0xFFFBF0)
GUICtrlSetColor(-1, 0xFF0000) ;i rot
GUICtrlSetTip(-1, $languages[53][1])
$bnDest = GUICtrlCreateButton("&N", 12, 218, 40, 44, $BS_ICON)
GUICtrlSetOnEvent(-1, '_dest')
GUICtrlSetImage(-1, $SiSmedia, 104)
GUICtrlSetTip(-1, $languages[54][1])
$lbDest = GUICtrlCreateLabel("", 220, 240, 164, 12, $SS_CENTER)
GUICtrlSetColor(-1, 0x008000) ;i dunkelgruen
GUICtrlSetBkColor(-1, 0xEEEEEE) ;i silber
GUICtrlSetTip(-1, $languages[55][1])
$lbDestVol = GUICtrlCreateLabel("", 220, 252, 164, 12, $SS_CENTER)
GUICtrlSetColor(-1, 0xFF8000) ;i "0x0000FF"=blau, "0xFF8000"=orange1, "0xFF8040"=orange2
GUICtrlSetBkColor(-1, 0xEEEEEE) ;i silber
GUICtrlSetTip(-1, $languages[56][1])

$cobDest = GUICtrlCreateCombo(IniRead($ini, "Destination", "Path", "C:\$Backup$"), 56, 242, 160, 20, $CBS_DROPDOWNLIST)
;i create Combo and ini read the $ziel
Global $arDrives = DriveGetDrive('Fixed')
Global $drivesCombo = ''
For $i = 1 To $arDrives[0]
	$drivesCombo &= StringUpper($arDrives[$i]) & '\$Backup$|'
	$drivesInfoSubItem = GUICtrlCreateMenuItem(StringUpper($arDrives[$i]) & " -> " & _
			StringFormat("%.2f MB free", DriveSpaceFree($arDrives[$i])), $drivesInfoItem)
Next
GUICtrlSetData($cobDest, $drivesCombo, $arDrives[1] & '\')
GUICtrlCreateGroup("", -99, -99, 1, 1) ; close group $gbDest
#EndRegion Group Destination

$bnI = GUICtrlCreateButton("&i", 20, 277, 32, 32, $BS_ICON)
GUICtrlSetOnEvent(-1, '_info')
GUICtrlSetImage(-1, $SiSmedia, 106)
GUICtrlSetTip(-1, $languages[57][1])
$bnS = GUICtrlCreateButton("&e", 90, 277, 32, 32, $BS_ICON)
GUICtrlSetOnEvent(-1, '_armatur')
GUICtrlSetImage(-1, $SiSmedia, 108)
GUICtrlSetTip(-1, $languages[58][1])
$ckbR = GUICtrlCreateCheckbox("&s", 160, 277, 32, 32, BitOR($BS_ICON, $BS_PUSHLIKE))
GUICtrlSetOnEvent(-1, '_restore')
GUICtrlSetImage(-1, $SiSmedia, 107)
GUICtrlSetTip(-1, $languages[59][1])
$bnOK = GUICtrlCreateButton($languages[28][1], 229, 280, 75, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_OKpressed')
GUICtrlSetTip(-1, $languages[60][1])
$bnClose = GUICtrlCreateButton($languages[29][1], 309, 280, 75, 22)
GUICtrlSetOnEvent(-1, '_quit')
GUICtrlSetTip(-1, $languages[61][1])
$tatusLine = GUICtrlCreateLabel("", 0, 315, 400, 17, BitOR($SS_SUNKEN, $SS_CENTER))

GUISetState(@SW_SHOW, $GUI)
#EndRegion ### START SiS GUI Section ###

#Region ### Armatur GUI section ###
Global $armaturGUI = GUICreate($title, 330, 250, -1, -1, $WS_SYSMENU, -1, $GUI)
GUISetOnEvent($GUI_EVENT_CLOSE, '_closeArmatur')

Global $tab = GUICtrlCreateTab(10, 10, 305, 170)
$tabItem0 = GUICtrlCreateTabItem($languages[30][1])
;GUICtrlSetState(-1,$GUI_SHOW)   ;! die GUI anzeigen mit @GUI_CtrlId ;! Der Button bestimmt das ERSTE Tabitem
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 0)
Global $aArmaturCk = IniReadSection($ini, "Armaturen")
If @error Then Global $aArmaturCk[4][2] = [[3, 0],["PC", $GUI_UNCHECKED],["7z", $GUI_UNCHECKED],["Auto", $GUI_UNCHECKED]]
For $i = 0 To 2 ;i statisch kein Ubound
	$aArmaturCkb[$i] = GUICtrlCreateCheckbox($aArmatur[$i], 80 + $i * 60, 80, 40, 17)
	; create 3x Checkbox
	GUICtrlSetState(-1, $aArmaturCk[$i + 1][1])
	GUICtrlSetOnEvent(-1, '_armaturColor')
	
	Global $aArmaturLabel[3] = [$languages[62][1], $languages[63][1], $languages[64][1]]
	GUICtrlSetTip(-1, $aArmaturLabel[$i])
Next
DllCall("uxtheme.dll", "none", "SetThemeAppProperties", "int", 7)
$lbSaveSet = GUICtrlCreateLabel($languages[31][1], 10, 130, 305, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0040F0) ;i blau

$tabItem1 = GUICtrlCreateTabItem($languages[32][1])
;GUICtrlSetState(-1,$GUI_SHOW)   ;! die GUI anzeigen mit @GUI_CtrlId ;! Der Button bestimmt das ERSTE Tabitem
Global $gui_combo_lang = GUICtrlCreateCombo("", 65, 130, 200, 17)
_read_lang()
GUICtrlCreateIcon($SiSmedia, 103, 60, 50, 48, 48, BitOR($SS_NOTIFY, $BS_ICON))
GUICtrlCreateIcon($SiSmedia, 109, 120, 50, 48, 48, BitOR($SS_NOTIFY, $BS_ICON))
$lbLang = GUICtrlCreateLabel($languages[33][1], 10, 110, 305, 17, $SS_CENTER)
GUICtrlSetColor(-1, 0x0040F0) ;i blau

GUICtrlCreateTabItem("") ;i beendet die Tab Definition

GUICtrlCreateButton("OK", 124, 190, 76, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_closeArmatur')
#EndRegion ### Armatur GUI section ###

#Region ### Result GUI section ###
Global $aResult_b[7] = [@MDAY & " - " & @MON & " - " & @YEAR, @HOUR & " : " & @MIN, '', '', '', '', '']

Global $resultGUI = GUICreate($title, 406, 253, -1, -1, $WS_SYSMENU, -1, $GUI)
GUISetOnEvent($GUI_EVENT_CLOSE, '_quit')
GUICtrlCreateGroup("", 5, 0, 390, 188) ; create group
GUICtrlCreateIcon($SiSmedia, 105, 26, 26, 48, 48, BitOR($SS_NOTIFY, $BS_ICON))
$lbTransEnd = GUICtrlCreateLabel($languages[34][1], 100, 10, 288, 15, $SS_CENTER)
GUICtrlSetColor(-1, 0x0040F0) ;i blau
For $i = 0 To 6 ;i statisch kein Ubound
	$aResultLB[$i] = GUICtrlCreateLabel($languages[$i + 35][1], 100, 30 + $i * 20, 48, 15) ;i erstellt 7 Label
	$aResult[$i] = GUICtrlCreateLabel($aResult_b[$i], 150, 30 + $i * 20, 238, 15) ;i erstellt 7 Label
Next

GUICtrlCreateLabel('Copyright : © 2008 by Ritzelrocker04 (www.AutoIT.de)', 100, 170, 288, 15, $SS_CENTER)
GUICtrlSetColor(-1, 0x0040F0) ;i blau
GUICtrlCreateGroup("", -99, -99, 1, 1) ;i close group
GUICtrlCreateButton("OK", 165, 195, 76, 22, $BS_DEFPUSHBUTTON) ;i DEF PUSH
GUICtrlSetOnEvent(-1, '_quit')
#EndRegion ### Result GUI section ###

_freeDest_Func()
AdlibEnable("_freeDest_Func", 1000)
; ! 6 in One ! ==> DriveSpaceFree & Progress & % & Fortschritt & Time & Size in One

While 1
	;Sleep(1000)
	Sleep(900)
WEnd

Func _OKpressed()
	_click()
	Global $start_T = TimerInit()
	
	For $a = 1 To 7
		If BitAND(GUICtrlRead($aDatenCkb[$a]), $GUI_UNCHECKED) Then $counter += 1
	Next
	If $counter = 7 Then
		$counter = 0
		
		MsgBox(262144 + 48, "Error", $languages[68][1] & @TAB)
		
		ToolTip($languages[69][1], 600, 320, $languages[70][1], 1, 1) ;i erstellt einen Tooltip
		Sleep(5000) ;i Leerlaufzeit, in der der Tool-Tip angezeigt werden kann
		ToolTip("") ;i Ein Tooltip bleibt sichtbar bis das Skript schließt oder ToolTip("") aufgerufen wird.
		;Exit ;i ohne Exit hat der Nutzer eine Möglichkeit seine Eingabe zu verbessern
	Else

		$ziel = GUICtrlRead($cobDest)
		IniWrite($ini, 'Destination', 'Path', $ziel) ;! ini-Eintrag erstellen für Statusbericht & Neuaufruf

		If BitAND(GUICtrlRead($aArmaturCkb[1]), $GUI_CHECKED) Then
			$7z1 = " a -t7z "
			$7z2 = ".7z "
		Else
			$7z1 = " a -tzip "
			$7z2 = ".zip "
		EndIf
		
		For $i = 0 To 2 ;i statisch kein Ubound
			If BitAND(GUICtrlRead($aTimeRb[$i]), $GUI_CHECKED) And BitAND(GUICtrlRead($ckbTime), $GUI_CHECKED) Then
				Switch $i
					Case 0
						$time = "_" & @YEAR & "-" & @MON & "-" & @MDAY
						
					Case 1
						$time = "_" & @MDAY
						
					Case 2
						$time = "_" & @WDAY
						
				EndSwitch
			EndIf
		Next
		
		For $j = 1 To 7 ;i statisch kein Ubound
			If BitAND(GUICtrlRead($aDatenCkb[$j]), $GUI_CHECKED) Then
				Switch $j
					Case 1
						$srcLive = @AppDataDir & '\Mozilla\Firefox\'
						$src = _GetDefaultProfile(@AppDataDir & '\Mozilla\Firefox')
						$dest = $ziel & "\$Firefox$\Firefox" & $time & $7z2
						$ff = "Firefox - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = StringTrimRight($src, StringLen($src) - StringInStr($src, '\', 1, -1) + 1)
							ConsoleWrite($src & @CRLF)
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff)
						
					Case 2
						$srcLive = @AppDataDir & '\Thunderbird\'
						$src = _GetDefaultProfile(@AppDataDir & '\Thunderbird')
						$dest = $ziel & "\$Thunderbird$\Thunderbird" & $time & $7z2
						$tb = "Thunderbird - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = StringTrimRight($src, StringLen($src) - StringInStr($src, '\', 1, -1) + 1)
							ConsoleWrite($src & @CRLF)
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb)
						
					Case 3
						$src = @AppDataDir & '\Microsoft\Outlook\'
						$dest = $ziel & "\$Outlook$\Outlook" & $time & $7z2 ;i Destination
						$ol = "Outlook - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = @AppDataDir & "\Microsoft"
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb & $ol)
						
					Case 4
						$src = $identPath & '\Identities\' & $ident & '\Microsoft\Outlook Express\'
						$dest = $ziel & "\$OutlookExpress$\OutlookExpress" & $time & $7z2
						$oe = "OutlookExpress - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = $identPath & "\Identities\" & $ident & "\Microsoft"
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb & $ol & $oe)
						
					Case 5
						$src = @AppDataDir & '\Microsoft\Address Book\'
						$dest = $ziel & "\$AddressBook$\AddressBook" & $time & $7z2 ;i Destination
						$ab = "Address Book - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = @AppDataDir & "\Microsoft"
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb & $ol & $oe & $ab)
						
					Case 6
						$src = @FavoritesDir & '\'
						$dest = $ziel & "\$Favoriten$\Favoriten" & $time & $7z2
						$ie = "Favoriten - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = @UserProfileDir
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb & $ol & $oe & $ab & $ie)
						
					Case 7
						$src = @MyDocumentsDir & '\'
						$dest = $ziel & "\$EigeneDateien$\EigeneDateien" & $time & $7z2
						$ed = "Eigene Dateien - "
						
						If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
							$srcR = @UserProfileDir
							_unzip()
						Else
							_sichernFunc()
						EndIf
						
						GUICtrlSetData($tatusLine, $ff & $tb & $ol & $oe & $ab & $ie & $ed)
						
				EndSwitch
			EndIf
		Next
		
		_write_settings()
		
		;SoundSetWaveVolume(50) ; Lautstärke 50% - optional
		SoundPlay($ndDing, 1) ;i M$sound
		If BitAND(GUICtrlRead($aArmaturCkb[0]), $GUI_CHECKED) Then
			Shutdown(1 + 8)
		Else
			If Round(TimerDiff($start_T) / 1000 / 60, 0) <= 0 Then
				$dauer = Round(TimerDiff($start_T) / 1000, 0) & ' sec. '
			Else
				$dauer = Round(TimerDiff($start_T) / 1000 / 60, 0) & ' min. '
			EndIf
			
			_result() ;i Resultat in GUI ausgeben
			
		EndIf
	EndIf
EndFunc   ;==>_OKpressed

Func _quit()
	_click()
	Exit
EndFunc   ;==>_quit

Func _GetDefaultProfile($mozpath) ; from engl. Forum - no Author
	Local $profilepath = "", $profiles = IniReadSectionNames($mozpath & '\profiles.ini')
	For $i = 1 To $profiles
		If IniRead($mozpath & '\profiles.ini', $profiles[$i], "Default", 0) = 1 Then
			$profilepath = StringReplace(IniRead($mozpath & '\profiles.ini', $profiles[$i], 'Path', ""), "/", "\")
			If IniRead($mozpath & '\profiles.ini', $profiles[$i], 'IsRelative', 0) = 1 Then $profilepath = $srcLive & $profilepath
			ExitLoop
		EndIf
	Next
	If $profilepath = "" Then
		$profilepath = StringReplace(IniRead($mozpath & '\profiles.ini', "Profile0", 'Path', ""), "/", "\")
		If IniRead($mozpath & '\profiles.ini', "Profile0", 'IsRelative', 0) = 1 Then $profilepath = $srcLive & $profilepath
	EndIf
	Return $profilepath
EndFunc   ;==>_GetDefaultProfile

Func _armaturColor()
	If BitAND(GUICtrlRead($aArmaturCkb[0]), $GUI_CHECKED) Then
		GUICtrlSetColor($aArmaturCkb[0], 0xFF0000) ;i red
		GUICtrlSetTip($aArmaturCkb[0], $languages[66][1], ' PC ', 2, 3)
		;i mit Icon, als Ballon-Tip, zentriert, nach unten
	Else
		GUICtrlSetColor($aArmaturCkb[0], 0x000000) ;i black
		GUICtrlSetTip($aArmaturCkb[0], $languages[62][1])
	EndIf
	If BitAND(GUICtrlRead($aArmaturCkb[1]), $GUI_CHECKED) Then
		GUICtrlSetColor($aArmaturCkb[1], 0xFF0000) ;i red
		GUICtrlSetTip($aArmaturCkb[1], $languages[66][1], ' *.7z ', 2, 3)
		;i mit Icon, als Ballon-Tip, zentriert, nach unten
	Else
		GUICtrlSetColor($aArmaturCkb[1], 0x000000) ;i black
		GUICtrlSetTip($aArmaturCkb[1], $languages[63][1])
	EndIf
	If BitAND(GUICtrlRead($aArmaturCkb[2]), $GUI_CHECKED) Then
		GUICtrlSetColor($aArmaturCkb[2], 0xFF0000) ;i red
		GUICtrlSetTip($aArmaturCkb[2], $languages[66][1], ' Auto ', 2, 3)
		;i mit Icon, als Ballon-Tip, zentriert, nach unten
	Else
		GUICtrlSetColor($aArmaturCkb[2], 0x000000) ;i black
		GUICtrlSetTip($aArmaturCkb[2], $languages[64][1])
	EndIf
EndFunc   ;==>_armaturColor

Func _ckbTime()
	$tate = BitXOR($tate, $GUI_ENABLE, $GUI_DISABLE)
	For $k = 0 To 2 ;i statisch kein Ubound
		GUICtrlSetState($aTimeRb[$k], $tate)
	Next
EndFunc   ;==>_ckbTime

Func _dest()
	_click()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	Local $path = FileSelectFolder($languages[71][1], "::{00000000-1080-F9E5-6311-4162E05A6BEE}", 1)
	If Not @error Then
		GUICtrlSetData($cobDest, $path, $path)
	EndIf
EndFunc   ;==>_dest

Func _click()
	SoundPlay($ndClick, 1) ;i M$sound
EndFunc   ;==>_click

Func _info()
	_click()
	Local $file = "SiS.log" ; Path & Name to Logfile
	If FileExists($file) Then
		Local $ret = _FileReadToArray($file, $aFile)
		If $ret = 0 Then MsgBox(262144 + 0, '', 'Error')
		MsgBox(262144 + 64, $languages[72][1], $aFile[$aFile[0]])
	Else
		MsgBox(262144 + 48, 'Error ' & $title, $file & @CRLF & @CRLF & $languages[67][1])
	EndIf
EndFunc   ;==>_info

Func _freeDest_Func() ;i SimplyColorProgress Aut(h)or: Ritzelrocker04
	$LW = StringLeft(GUICtrlRead($cobDest), 3)
	$srcLW = Round((DriveSpaceTotal($LW) - DriveSpaceFree($LW)) / (DriveSpaceTotal($LW) / 100), 0)
	GUICtrlSetData($tbB, "II " & $srcLW & "% full " & _StringRepeat("I", $srcLW - 12))
	Global $freeDestMB = DriveSpaceFree(StringLeft(GUICtrlRead($cobDest), 3))
	
	Global $size = DirGetSize(GUICtrlRead($cobDest))
	GUICtrlSetData($lbDestVol, _StringAddThousandsSep(StringReplace(Round($size / 1024 / 1024, 2), '.', ','), ".", ",") & " MB Size")
	If $size <= 0 Then GUICtrlSetState($openItem, $GUI_DISABLE) ;i Öffnen... - ausgrauen, wenn <= 0
	
	GUICtrlSetData($lbDest, (100 - $srcLW) & '% - ' & _StringAddThousandsSep(StringReplace(Round($freeDestMB, 0), '.', ','), ".", ",") & " MB free")
	GUICtrlSetData($tatusLine, $version & @TAB & @MDAY & ' - ' & @MON & ' - ' & @YEAR & @TAB & @HOUR & ':' & @MIN)
EndFunc   ;==>_freeDest_Func

Func _sichernFunc()
	If BitAND(GUICtrlRead($aArmaturCkb[2]), $GUI_CHECKED) Then
		If FileExists($dest) Then FileDelete($dest)
	Else
		If FileExists($dest) Then
			Local $ExistsFileWahl = MsgBox(262144 + 48 + 4, $languages[73][1], $dest & ' ' & $languages[74][1] & @TAB & @CRLF & ' ' & $languages[75][1])
			If $ExistsFileWahl = 6 Then
				FileDelete($dest)
			EndIf
		EndIf
	EndIf
	GUICtrlSetState($avi, 1) ;i Animation 1 = on and 0 = off
	RunWait(@ComSpec & ' /c ' & $7zip & $7z1 & $dest & '"' & $src & '"', @ScriptDir, @SW_HIDE)
	;i Aufruf von 7zip zum packen
	GUICtrlSetState($avi, 0) ;i Animation 1 = on and 0 = off
EndFunc   ;==>_sichernFunc

Func _unzip()
	GUICtrlSetState($avi, 1) ;i Animation 1 = on and 0 = off
	RunWait(@ComSpec & ' /c ' & $7zip & ' x -aoa -o' & '"' & $srcR & '\"' & ' ' & $dest, @ScriptDir, @SW_HIDE)
	;i Aufruf von 7zip zum entpacken
	GUICtrlSetState($avi, 0) ;i Animation 1 = on and 0 = off
EndFunc   ;==>_unzip

Func _write_settings()
	Local $logfile = FileOpen("SiS.log", 1)
	If $logfile = -1 Then
		MsgBox(262144 + 0, "Error", 'SiS.log ' & $languages[67][1] & @TAB)
		Exit
	EndIf
	FileWriteLine($logfile, $ff & $tb & $ol & $oe & $ab & $ie & $ed & "> " & $ziel & " -> " & @MDAY & "-" & @MON & "-" & @YEAR & " -> " & @HOUR & ":" & @MIN & ":" & @SEC)
	FileClose($logfile)
	
	Local $ar2D[13][3] = [['Time', 'YEAR', $aTimeRb[0]],['Time', 'MDAY', $aTimeRb[1]],['Time', 'WDAY', $aTimeRb[2]], _
			['Daten', 'FF', $aDatenCkb[1]],['Daten', 'TB', $aDatenCkb[2]],['Daten', 'OL', $aDatenCkb[3]], _
			['Daten', 'OE', $aDatenCkb[4]],['Daten', 'AB', $aDatenCkb[5]],['Daten', 'IE', $aDatenCkb[6]], _
			['Daten', 'ED', $aDatenCkb[7]],['Armaturen', 'PC', $aArmaturCkb[0]], _
			['Armaturen', '7z', $aArmaturCkb[1]],['Armaturen', 'Auto', $aArmaturCkb[2]]]
	
	For $m = 0 To 12 ;i statisch kein Ubound
		IniWrite($ini, $ar2D[$m][0], $ar2D[$m][1], GUICtrlRead($ar2D[$m][2]))
	Next
EndFunc   ;==>_write_settings

Func _restore()
	_click()
	If BitAND(GUICtrlRead($ckbR), $GUI_CHECKED) Then
		GUICtrlSetData($saveItem, "Restore" & @TAB & "Alt+R")
		GUICtrlSetData($bnOK, "&Restore")
		GUICtrlSetTip($ckbR, $languages[65][1], ' Restore ', 1, 3) ;i mit Icon, als Ballon-Tip, zentriert, nach unten
		MsgBox(262144 + 64, $languages[76][1], $languages[77][1] & @CRLF & $languages[78][1] & @CRLF & "" & @CRLF & 'Copyright: (C) 2008 by Ritzelrocker04 (www.AutoIT.de)' & @TAB)
	Else
		GUICtrlSetData($saveItem, $languages[4][1])
		GUICtrlSetData($bnOK, $languages[28][1])
		GUICtrlSetTip($ckbR, $languages[59][1])
	EndIf
EndFunc   ;==>_restore

Func _statuslabel()
	_click()
	If BitAND(GUICtrlRead($viewStatusItem), $GUI_CHECKED) Then
		GUICtrlSetState($viewStatusItem, $GUI_UNCHECKED)
		GUICtrlSetState($tatusLine, $GUI_HIDE)
	Else
		GUICtrlSetState($viewStatusItem, $GUI_CHECKED)
		GUICtrlSetState($tatusLine, $GUI_SHOW)
	EndIf
EndFunc   ;==>_statuslabel

Func _armatur()
	_click()
	GUISetState(@SW_SHOW, $armaturGUI)
	;MsgBox(262144 + 64, "gedrückt...", "ID=" & @GUI_CTRLID) ;i zur abfrage der @GUI_CTRLID
	Switch @GUI_CtrlId ;! Der Button bestimmt das Tabitem
		Case 10
			GUICtrlSetState($tabItem0, $GUI_SHOW) ;i das Tabitem "Einstellungen" anzeigen
		Case 12
			GUICtrlSetState($tabItem1, $GUI_SHOW) ;i das Tabitem "Sprache" anzeigen
		Case Else
			GUICtrlSetState($tabItem0, $GUI_SHOW) ;i das Tabitem "Einstellungen" anzeigen
	EndSwitch
EndFunc   ;==>_armatur

Func _closeArmatur()
	_gui_config()
	_ini_read_lang()
	GUISetState(@SW_HIDE, $armaturGUI) ;i $armaturGUI verstecken
EndFunc   ;==>_closeArmatur

Func _about()
	_click()
	MsgBox(262144 + 64, $title, 'Sicher ist Sicher - ' & $version & $build & @CRLF _
			 & 'Copyright: © 2008 by Ritzelrocker04 (RR04 - www.AutoIT.de)' & @CRLF & @CRLF _
			 & 'Translator for SiS - Version 1.0   Build 2008-11-24' & @CRLF _
			 & 'Copyright: © 2008 by Prog@ndy (Progandy - www.AutoIT.de)' & @TAB)
EndFunc   ;==>_about

Func _result()
	_click()
	GUICtrlSetData($aResult[2], IniRead($ini, "Destination", "Path", "C:\$Backup$")) ;i Speicherpfad der Sicherung ausgeben
	Global $arSize = DirGetSize(GUICtrlRead($cobDest), 1)
	If IsArray($arSize) Then
		GUICtrlSetData($aResult[3], _
				_StringAddThousandsSep(StringReplace(Round($arSize[0] / 1024 / 1024, 2), '.', ','), ".", ",") & " MB")
		GUICtrlSetData($aResult[4], $arSize[1])
		GUICtrlSetData($aResult[5], $arSize[2])
	EndIf
	GUICtrlSetData($aResult[6], $dauer) ;i Dauer der Sicherung sec/min. ausgeben
	GUISetState(@SW_HIDE, $GUI)
	GUISetState(@SW_SHOW, $resultGUI)
EndFunc   ;==>_result

Func _openDest()
	_click()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	_FileOpenDetails($languages[79][1])
	FileOpenDialog($languages[79][1], GUICtrlRead($cobDest), "All (*.zip; *.7z)", 1)
EndFunc   ;==>_openDest

Func _FileOpenDetails($title) ;i Aut(h)or: Funkey
	Local $str = "Local $x = Opt('WinWaitDelay',0)+WinWaitActive('" & $title & "','')+" & _
			"ControlFocus('" & $title & "','','ToolbarWindow321')+" & _
			"Send('{right 2}{space}d')+" & _
			"ControlFocus('" & $title & "','','Edit1')"
	Run('"' & @AutoItExe & '" /AutoIt3ExecuteLine "' & $str & '"')
EndFunc   ;==>_FileOpenDetails

Func _translator()
	_click()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	Local $translator = "Translator.exe" ;i Translator for SiS - Aut(h)or Progandy from AutoIT.de
	If FileExists($translator) Then
		Run($translator)
	Else
		MsgBox(262144 + 48, 'Error ' & $title, $translator & @CRLF & @CRLF & $languages[67][1])
	EndIf
EndFunc   ;==>_translator

Func _sysInfo()
	_click()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	If FileExists($sysInfo) Then
		Run($sysInfo) ;i M$ Windows XP
	ElseIf FileExists(@SystemDir & "\msinfo32.exe") Then
		$sysInfo = @SystemDir & "\msinfo32.exe" ;i M$ Windows Vista
		Run($sysInfo)
	Else
		MsgBox(262144 + 64, 'Error ' & $title, $sysInfo & @CRLF & @CRLF & $languages[67][1])
	EndIf
EndFunc   ;==>_sysInfo

Func _sisHelp()
	_click()
	WinSetOnTop($title, '', 0) ;! 1 = den Wert für "Immer im Vordergrund" setzen und 0 = nicht ;)
	Local $rc
	ShellExecute($helpFile)
	$rc = WinWait('HTML Help', '', 3)
	If $rc = 0 Then Return MsgBox(0, $title, $helpFile & @CRLF & @CRLF & $languages[67][1])
	ControlMove('HTML Help', '', '[CLASS:HH Child; INSTANCE:2]', 0, 40, 280)
	ControlMove('HTML Help', '', '[CLASS:HH Child; INSTANCE:1]', 284, 40)
	ControlTreeView('HTML Help', '', '[CLASS:SysTreeView32; INSTANCE:1]', 'Expand', '#0')
EndFunc   ;==>_sisHelp

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
			GUICtrlSetData($gui_combo_lang, $aFList, "English")
		EndIf
	WEnd
EndFunc   ;==>_read_lang

Func _gui_config()
	$new_lang = GUICtrlRead($gui_combo_lang) & ".lng"
	If $new_lang = "" Or FileExists($lang_dir & "\" & $new_lang) = 0 Then
		$new_lang = "English.lng"
	EndIf
	IniWrite($ini, "language", "current", $new_lang)
EndFunc   ;==>_gui_config

Func _ini_read_lang()
	;read_options
	$actual_lang_name = IniRead($ini, "language", "current", "English.lng")
	$actual_lang = $lang_dir & "\" & $actual_lang_name
	;ini_read_lang
	
	$languages = IniReadSection($actual_lang, "default_values")
	If @error Then MsgBox(262144 + 4096, "", "Error occurred, probably no lng file !" & @TAB)
	
	Global $Label[65] = ['', $fileMenu, $fileItem, $openItem, $saveItem, $exitItem, _
			$optMenu, $setItem, $langItem, $viewMenu, $viewStatusItem, $sysInfoItem, $drivesInfoItem, _
			$helpMenu, $helpMenuItem, $infoItem, $aboutItem, $aDatenCkb[1], $aDatenCkb[2], _
			$aDatenCkb[3], $aDatenCkb[4], $aDatenCkb[5], $aDatenCkb[6], $aDatenCkb[7], $ckbTime, _
			$aTimeRb[0], $aTimeRb[1], $aTimeRb[2], $bnOK, $bnClose, $tabItem0, $lbSaveSet, _
			$tabItem1, $lbLang, $lbTransEnd, $aResultLB[0], $aResultLB[1], $aResultLB[2], _
			$aResultLB[3], $aResultLB[4], $aResultLB[5], $aResultLB[6], $aDatenCkb[1], $aDatenCkb[2], _
			$aDatenCkb[3], $aDatenCkb[4], $aDatenCkb[5], $aDatenCkb[6], $aDatenCkb[7], $ckbTime, _
			$aTimeRb[0], $aTimeRb[1], $aTimeRb[2], $tbB, $bnDest, $lbDest, $lbDestVol, $bnI, $bnS, _
			$ckbR, $bnOK, $bnClose, $aArmaturCkb[0], $aArmaturCkb[1], $aArmaturCkb[2]]
	
	For $i = 1 To 41 ;! kein Ubound möglich
		GUICtrlSetData($Label[$i], $languages[$i][1])
	Next
	For $i = 42 To 64 ;i statisch kein Ubound
		GUICtrlSetTip($Label[$i], $languages[$i][1])
	Next
EndFunc   ;==>_ini_read_lang


; Ende