#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <GuiEdit.au3>
#include <GuiComboBox.au3>
#include <Constants.au3>
#include <file.au3>

#NoTrayIcon

$BUILD="Versie 1.7b - 20-04-2013" ;----------------------------------------------------------------------------------------------------Versie nummer
WinSetState("[CLASS:ConsoleWindowClass]", "", @SW_HIDE) ;-------------------------------------------------------------------------------Wordt gebruikt om de command-prompt te verbergen

;=====================================START SPLASHSCREEN==============================================================

IF NOT FileExists(@ScriptDir & "\Graphics\Splashscreen\splashscreen.jpg") Then MsgBox(4096, "Waarschuwing!", "Splash screen niet gevonden, meld dit bij preload@levix.nl") ;---Waarde voor afvanging of het splashscreen.jpg bestaat of niet.

SplashImageOn("", @ScriptDir & "\Graphics\Splashscreen\splashscreen.jpg", 640, 480, -1, -1, 1) ;----------------------------------------Starten van het Splashscreen logo
Sleep(4500) ;---------------------------------------------------------------------------------------------------------------------------Zorgt ervoor dat het Splashscreen logo 4,5 seconden blijft staan.
SplashOff() ;---------------------------------------------------------------------------------------------------------------------------Einde van het Splashscreen logo

;=====================================END SPLASHSCREEN================================================================
;=====================================START CREATING GUI==============================================================

$GUI = GUICreate("Mark Wingens", 532, 499, -1, -1, $WS_POPUPWINDOW) ;-----------------------------------------$WS_POPUPWINDOW zorgt ervoor dat er geen randen zijn en geen titelbalk. Om te sluiten druk op: Esc
   GUISetBkColor(0xF0F0F0) ;----------------------------------------------------------------------------------Zorgt voor de juiste achtergrond kleur.
   GUISetIcon("", -134);--------------------------------------------------------------------------------------Zorgt ervoor, mocht er toch een titelbalk zijn dat er geen icoon in zichtbaar is.
   GUISetFont(9, 400, 0, "") ;--------------------------------------------------------------------------------Zorgt dat overal in dit script hetzelfde lettertype gebruikt wordt, tenzij anders vermeld.

$START = GUICtrlCreateButton("START", 227, 448, 75, 25)
	  GUICtrlSetTip($START, "Klik hier om de installatie te starten")

$OS = GUICtrlCreateLabel("Besturingssysteem:", 48, 16, 112, 17)
$OSLIST = GUICtrlCreateCombo("", 48, 40, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));---------------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
   GUICtrlSetTip($OSLIST, "Kies hier het juiste besturingssysteem")
	  $STANDARD = GUICtrlSetData($OSLIST, "Windows 8", "") ; ----Waarde van het OS pulldown menu
	  $PRO = GUICtrlSetData($OSLIST, "Windows 8 Pro", "") ; -----Waarde van het OS pulldown menu

	  $VERSION = "8" ;-------------------------------------------Waarde voor het install.cmd script
	  $VERSIONPRO = "8-Pro" ;------------------------------------Waarde voor het install.cmd script

$MANUTITLE = GUICtrlCreateLabel("Fabrikant:", 280, 16, 83, 17)
$MANULIST = GUICtrlCreateCombo("", 280, 40, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));------------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  GUICtrlSetTip($MANULIST, "Kies hier de fabrikant")
	  $LEVIX = GUICtrlSetData($MANULIST, "Levix - Zelfbouw", "") ; ---------Waarde voor het Fabrikant pulldown menu
	  $OEM = GUICtrlSetData($MANULIST, "OEM - Activatie") ; ----------------Waarde voor het Fabrikant pulldown menu
	  $MANULINE = GUICtrlSetData($MANULIST, "---------------------------------------------------")
	  $ACER = GUICtrlSetData($MANULIST, "Acer - Notebook", "") ; -----------Waarde voor het Fabrikant pulldown menu
	  $ASUS = GUICtrlSetData($MANULIST, "Asus - Notebook", "") ; -----------Waarde voor het Fabrikant pulldown menu
	  $TOSHIBA = GUICtrlSetData($MANULIST, "Toshiba - Notebook", "") ; -----Waarde voor het Fabrikant pulldown menu

$LICENCETITLE = GUICtrlCreateLabel("Licentie sleutel:", 48, 67, 100, 17)
$LICENCEINPUT = GUICtrlCreateInput("", 48, 88, 201, 21, $ES_UPPERCASE)
	GUICtrlSetLimit($LICENCEINPUT, 29, 29)
	GUICtrlSetFont($LICENCEINPUT, 11, "", "", "Consolas", "")

$OFFICETITLE = GUICtrlCreateLabel("Microsoft Office:", 48, 120, 95, 17)
$OFFICELIST = GUICtrlCreateCombo("", 48, 144, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	  GUICtrlSetTip($OFFICELIST, "Kies hier de de juiste Office versie")
	  $GEEN = GUICtrlSetData($OFFICELIST, "Geen Microsoft Office") ; -----------------------------------Waarde voor het Office pulldown menu
	  $GEEN = GUICtrlSetData($OFFICELIST, "---------------------------------------------------") ; -----Waarde voor het Office pulldown menu
	  $2007 = GUICtrlSetData($OFFICELIST, "Office 2007 - Home and Student", "") ; ----------------------Waarde voor het Office pulldown menu
	  $2010 = GUICtrlSetData($OFFICELIST, "Office 2010", "") ; -----------------------------------------Waarde voor het Office pulldown menu
	  $2013 = GUICtrlSetData($OFFICELIST, "Office 2013", "") ; -----------------------------------------Waarde voor het Office pulldown menu

$AVTITLE = GUICtrlCreateLabel("Anti-virus:", 280, 120, 58, 17)
$AVLIST = GUICtrlCreateCombo("", 280, 144, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	  $NOAV = GUICtrlSetData($AVLIST, "Geen Anti-virus")
	  $NOAVLINE = GUICtrlSetData($AVLIST, "---------------------------------------------------") ; -----Waarde voor het Anti-Virus pulldown menu
	  $NORTONAV = GUICtrlSetData($AVLIST, "Norton - Anti-virus 2013")
	  $NORTONIS = GUICtrlSetData($AVLIST, "Norton - Internet Security 2013")
	  $NORTON360 = GUICtrlSetData($AVLIST, "Norton - 360 2013")

$PARTITIONTITLE = GUICtrlCreateLabel("Partitie-indeling:", 48, 184, 97, 17)
$PARTITIONLIST = GUICtrlCreateCombo("", 48, 208, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ;------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
   GUICtrlSetTip($PARTITIONLIST, "Kies hier de partitie indeling")
	  $WIPE = GUICtrlSetData($PARTITIONLIST, "Wipe" &  "       l  één partitie", "") ;------------------Waarde van het Partitie Indeling pulldown menu
	  $CUSTOM = GUICtrlSetData($PARTITIONLIST, "Custom" &  "  l  aangepaste partitie", "") ;------------Waarde van het Partitie Indeling pulldown menu
   $PARTITION = 1 ;-------------------------------------------------------------------------------------Waarde voor het afvangen van het activeren: Pulldown menu Partitie Groote

$PARTITIONSIZETITLE = GUICtrlCreateLabel("Partitie-grootte:", 280, 184, 90, 17)
$PARTITIONSIZELIST = GUICtrlCreateCombo("", 280, 208, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL)) ;-$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
   GUICtrlSetTip($PARTITIONSIZELIST, "Kies hier het formaat voor de boot partitie")
	  $HDDSIZE = GUICtrlSetData($PARTITIONSIZELIST, "40 GB|80 GB|100 GB|120 GB|160 GB|200 GB|250 GB|300 GB|350 GB|400 GB|450 GB|500 GB|750 GB|1000 GB|1500 GB", "") ;Waarde van het Partitie-grootte pulldown menu
  GUICtrlSetState( $PARTITIONSIZELIST, $GUI_DISABLE)

$RECOVERYCHECKBOX = GUICtrlCreateCheckbox("Herstelpartitie", 157, 240, 89, 17)
   GUICtrlSetState($RECOVERYCHECKBOX, $GUI_CHECKED)
   GUICtrlSetTip($RECOVERYCHECKBOX, "Vink uit om geen recovery image te maken")

$BIOS = GUICtrlCreateCheckbox("Bios", 280, 240, 41, 17)
   GUICtrlSetTip($BIOS, "Vink aan voor moederborden die EFI boot niet ondersteunen")

$X86 = GUICtrlCreateCheckbox("32-Bit", 333, 240, 49, 17)
	GUICtrlSetTip($X86, "Vink aan voor de 32-Bit Windows 8 installatie")

$LOGGER = GUICtrlCreateLabel("Logboek:", 48, 240, 57, 17)
$LOGBOX = GUICtrlCreateEdit($BUILD, 48, 264, 433, 161, $ES_READONLY + $ES_AUTOVSCROLL + $ES_MULTILINE) ;$ES_READONLY + $ES_AUTOSCROLL + $ES_MULTILINE is voor het logboek read only en auto scroll te maken)
$LINE = "------------------------------------------------------------------------------------"
Logb($LINE)


$HELP = GUICtrlCreateButton("?", 8, 464, 27, 25)
   GUICtrlSetTip($HELP, "Klik hier voor hulp of druk op F1")

$HULP = GUICtrlCreateCombo("Hulp", 40, 464, 113, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
$DISKPARTHULP = GUICtrlSetData($HULP, "Command Prompt|Diskpart|Change Log")


HotKeySet("{ESC}",	"TERMINATE") ;---------------------------------------------------HotKey voor het afsluiten van het script
HotKeySet("{F1}", "HELP") ;----------------------------------------------------------Hotkey voor het help scherm

GUISetState(@SW_SHOW)

;=====================================END CREATING GUI================================================================
;=====================================START IDLE LOOP=================================================================
While 1
	$Msg = GUIGetMsg()
	Select
		 Case $msg = $START
			START()
		 Case $msg = $HELP
			HELP()
		 Case $msg = $hulp
			$var = GUICtrlRead($hulp)
			If StringInStr($var, "Command Prompt") Then
				Run("cmd.exe")
				_GUICtrlComboBox_SetCurSel($hulp, "Hulp")
			EndIf
			If StringInStr($var, "Diskpart") Then
				Run("diskpart.exe")
				_GUICtrlComboBox_SetCurSel($hulp, "Hulp")
			EndIf
			If StringInStr($var, "Change Log") Then
				CHANGELOG()
				_GUICtrlComboBox_SetCurSel($hulp, "Hulp")
			EndIf
		 Case $msg = $GUI_EVENT_CLOSE
			Exit

	EndSelect

		 If GUICtrlRead($PARTITIONLIST) = "Custom" &  "  l  aangepaste partitie" And $PARTITION = 1 Then
				  GUICtrlSetState($PARTITIONSIZELIST, $GUI_ENABLE)
				  $PARTITION = 0
		 ElseIf GUICtrlRead($PARTITIONLIST) <> "Custom" &  "  l  aangepaste partitie" And $PARTITION = 0 Then
				  GUICtrlSetState($PARTITIONSIZELIST, $GUI_DISABLE)
				  $PARTITION = 1
		 EndIf

		 If GUICtrlRead($MANULIST) = "Levix - Zelfbouw" Then
			 GUICtrlSetState($LICENCEINPUT, $GUI_ENABLE)
			 Sleep(50)
		 ElseIf GUICtrlRead($MANULIST) <> "Levix - Zelfbouw" Then
			 GUICtrlSetState($LICENCEINPUT, $GUI_DISABLE)
			 Sleep(50)
		 EndIf

WEnd