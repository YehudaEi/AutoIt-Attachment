#include <WindowsConstants.au3>
#include <GUIConstants.au3>
#include <Constants.au3>
#include <GuiEdit.au3>
#include <GuiComboBox.au3>
#include <GUIConstantsEx.au3>
#include <file.au3>

#NoTrayIcon

WinSetState("[CLASS:ConsoleWindowClass]", "", @SW_HIDE) ;-----------------------------------------------------Wordt gebruikt om de command-prompt te verbergen
;=====================================START CREATING GUI==============================================================
$GUI = GUICreate("", 476, 562, -1, -1, $WS_POPUPWINDOW) ;-----------------------------------------------------$WS_POPUPWINDOW zorgt ervoor dat er geen randen zijn en geen titelbalk. Om te sluiten druk op: Esc
	GUISetBkColor(0xF0F0F0) ;---------------------------------------------------------------------------------Zorgt voor de juiste achtergrond kleur.
	GUISetIcon("", -134);-------------------------------------------------------------------------------------Zorgt ervoor, mocht er toch een titelbalk zijn dat er geen icoon in zichtbaar is.
	GUISetFont(9, 400, 0, "") ;-------------------------------------------------------------------------------Zorgt dat overal in dit script hetzelfde lettertype gebruikt wordt, tenzij anders vermeld.

$OS = GUICtrlCreateLabel("Besturingssysteem:", 24, 16, 115, 17)
$OSLIST = GUICtrlCreateCombo("", 24, 40, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));---------------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	GUICtrlSetTip($OSLIST, "Kies hier het juiste besturingssysteem")
		GUICtrlSetData($OSLIST, "Windows Vista") ;------------------------------------------------------------Waarde van het OS pulldown menu
		GUICtrlSetData($OSLIST, "Windows 7") ; ---------------------------------------------------------------Waarde van het OS pulldown menu
		GUICtrlSetData($OSLIST, "Windows 8.1", ""); ----------------------------------------------------------Waarde van het OS pulldown menu

$VERSION = GUICtrlCreateLabel("Windows versie:", 248, 16, 115, 17)
$VERSIONLIST = GUICtrlCreateCombo("", 248, 40, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));---------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	GUICtrlSetTip($VERSIONLIST, "Kies hier de versie van Windows die geïnstalleerd moet worden")
	GUICtrlSetState($VERSIONLIST, $GUI_DISABLE)

$MANUFACTURER = GUICtrlCreateLabel("Activatie en Software:", 24, 72, 115, 17)
$MANULIST = GUICtrlCreateCombo("", 24, 96, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));------------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	GUICtrlSetTip($MANULIST, "Kies hier de fabrikant")
	GUICtrlSetData($MANULIST, "Levix - Zelfbouw")
	GUICtrlSetState($MANULIST, $GUI_DISABLE)

$LICENCE = GUICtrlCreateLabel("Licentie sleutel:", 248, 72, 115, 17)
$LICENCEINPUT = GUICtrlCreateInput("", 248, 96, 201, 21, $ES_UPPERCASE)
	GUICtrlSetTip($LICENCEINPUT, "Vul hier de licentie sleutel in")
	GUICtrlSetLimit($LICENCEINPUT,29,29) ;--------------------------------------------------------------------Zorgt ervoor dat er minimaal en maximaal 29 characters ingevuld kunnen worden in het veld.
	GUICtrlSetFont($LICENCEINPUT, 8.5,"","","Consolas","") ;--------------------------------------------------Zorgt ervoor dat het lettertype veranderd in Consolas (de standaard van kladblok) en dat deze op lettergrote: 8.5 wordt weer gegeven.
		Global $LastInput = "" ;------------------------------------------------------------------------------Waarde nodig voor het stukje script die zorgt voor de - tekens tussen de licentie sleutel.
		Local $Temp, $LenPart = 5 ;---------------------------------------------------------------------------Waarde die ervoor zorgt dat het - na elke 5 characters wordt geplaatst.

$HOSTNAMELABEL = GUICtrlCreateLabel("Computernaam:", 24, 128, 115, 17)
$DEBITINPUT = GUICtrlCreateInput("", 24, 152, 73, 21, $ES_NUMBER)
	GUICtrlSetTip($DEBITINPUT, "Vul hier het debiteurnummer in")
$HOSTNAMEINPUT = GUICtrlCreateInput("", 104, 152, 121, 21)
	GUICtrlSetTip($HOSTNAMEINPUT, "Vul hier de achternaam van de klant in")
		GUICtrlSetState($DEBITINPUT, $GUI_DISABLE)
		GUICtrlSetState($HOSTNAMEINPUT, $GUI_DISABLE)

$USERLABEL = GUICtrlCreateLabel("Gebruikersnaam:", 248, 128, 115, 17)
$USERINPUT = GUICtrlCreateInput("", 248, 152, 201, 21)
	GUICtrlSetTip($USERINPUT, "Vul hier de Windows gebruikersnaam in")
		GUICtrlSetState($USERINPUT, $GUI_DISABLE)

$OFFICE = GUICtrlCreateLabel("Microsoft Office:", 24, 184, 115, 17)
$OFFICELIST = GUICtrlCreateCombo("", 24, 208, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));---------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	  GUICtrlSetTip($OFFICELIST, "Kies hier de de juiste Office versie")
		GUICtrlSetState($OFFICELIST, $GUI_DISABLE)

$PARTITION = GUICtrlCreateLabel("Partitie indeling:", 24, 248, 115, 17)
$PARTITIONLIST = GUICtrlCreateCombo("", 24, 272, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));-------------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	GUICtrlSetTip($PARTITIONLIST, "Kies hier de partitie indeling")
	$WIPE = GUICtrlSetData($PARTITIONLIST, "Wipe" &  "       l  één partitie", "") ;--------------------------Waarde van het Partitie Indeling pulldown menu
	$CUSTOM = GUICtrlSetData($PARTITIONLIST, "Custom" &  "  l  aangepaste partitie", "") ;--------------------Waarde van het Partitie Indeling pulldown menu
	$PARTITION = 1 ;------------------------------------------------------------------------------------------Waarde voor het afvangen van het activeren: Pulldown menu Partitie Groote
		GUICtrlSetState($PARTITIONLIST, $GUI_DISABLE)

$PARTITIONSIZE = GUICtrlCreateLabel("Partitie groote:", 248, 248, 115, 17)
$PARTITIONSIZELIST = GUICtrlCreateCombo("", 248, 272, 201, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL));---------$CBS_DROPDOWNLIST & $WS_VSCROLL maken de dropdown list als een dropdown menu
	GUICtrlSetTip($PARTITIONSIZELIST, "Kies hier het formaat voor de boot partitie")
	$HDDSIZE = GUICtrlSetData($PARTITIONSIZELIST, "60 GB|80 GB|100 GB|120 GB|160 GB|200 GB|250 GB|300 GB|350 GB|400 GB|450 GB|500 GB|750 GB|1000 GB|1500 GB", "") ;---Waarden van het Partitie-grootte pulldown menu
		GUICtrlSetState( $PARTITIONSIZELIST, $GUI_DISABLE)


$AMD64 = GUICtrlCreateCheckbox("64-Bit", 24, 304, 55, 17)
$X86 = GUICtrlCreateCheckbox("32-Bit", 24, 328, 55, 17)
$MAV = GUICtrlCreateCheckbox("Managed Anti-Virus", 96, 304, 129, 17)
$BIOS = GUICtrlCreateCheckbox("Bios", 96, 328, 97, 17)
$RECOVERY = GUICtrlCreateCheckbox("Herstel Partitie", 248, 304, 121, 17)
$BUSINESS = GUICtrlCreateCheckbox("Zakelijk", 248, 328, 97, 17)
$REBOOTHALT = GUICtrlCreateCheckbox("Niet herstarten", 352, 488, 105, 17)
$NODRIVER = GUICtrlCreateCheckbox("Geen drivers", 352, 512, 97, 17)
	GUICtrlSetTip($BIOS, "Deze optie wordt gebruikt op NON-UEFI moederborden")
	GUICtrlSetTip($REBOOTHALT, "Deze optie wordt gebruikt om aan het eind van de Preload niet te herstarten")
	GUICtrlSetState($AMD64, $GUI_DISABLE)
	GUICtrlSetState($X86, $GUI_DISABLE)
	GUICtrlSetState($BIOS, $GUI_DISABLE)
	GUICtrlSetState($RECOVERY, $GUI_DISABLE)
	GUICtrlSetState($BUSINESS, $GUI_DISABLE)
	GUICtrlSetState($MAV, $GUI_DISABLE)

$LOGGER = GUICtrlCreateEdit("", 24, 360, 425, 121, $ES_READONLY + $ES_AUTOVSCROLL + $ES_MULTILINE) ;----------$ES_READONLY + $ES_AUTOSCROLL + $ES_MULTILINE is voor het logboek read only en auto scroll te maken)
	$VAR  = FileOpen("P:\Changelog\version.txt", 0)
		While 1
			$x	= FileReadLine($VAR)
				If @error = -1 Then ExitLoop
			_GUICtrlEdit_AppendText($LOGGER, @CRLF & $x)
		Wend
	FileClose($var)
$LINE = "----------------------------------------------------------------------------------"
Logb($LINE)

$START = GUICtrlCreateButton("START", 210, 504, 75, 25)
	 GUICtrlSetTip($START, "Klik hier om de installatie te starten")
		GUICtrlSetState($START, $GUI_DISABLE)

$HULP = GUICtrlCreateCombo("Hulp", 24, 488, 120, 25, BitOR($CBS_DROPDOWNLIST, $WS_VSCROLL))
	$DISKPARTHULP = GUICtrlSetData($HULP, "Command Prompt|Diskpart|Change Log")

$COPYRIGHT = GUICtrlCreateLabel("Copyright © , 2013", 16, 536, 125, 17)
	GUICtrlSetState($COPYRIGHT, $GUI_DISABLE)
$CREDITS = GUICtrlCreateLabel("Created by: Mark Wingens", 328, 537, 170, 17)
	GUICtrlSetState($CREDITS, $GUI_DISABLE)

HotKeySet("{BACKSPACE}","_BackSpace") ;----------------------------------------------------------------------Hotkey voor het licentie input veld, zodat het min teken wordt verwijderd
HotKeySet("{ESC}",	"TERMINATE") ;---------------------------------------------------------------------------HotKey voor het afsluiten van het script

GUISetState(@SW_SHOW)
;=====================================END CREATING GUI================================================================
ControlFocus("", "", $OSLIST)
;=====================================START IDLE LOOP=================================================================
While 1
	$Msg = GUIGetMsg()
	Select
		Case $msg = $START
			ERRORCATCH()
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

	Case $msg = $OSLIST
		GUICtrlSetState($VERSIONLIST, $GUI_ENABLE)
		$VAR = GUICtrlRead($OSLIST)

	If $VAR = "Windows Vista" Then
		GUICtrlSetData($VERSIONLIST, "")
		$VISTAHB = GUICtrlSetData($VERSIONLIST, "Home Basic", "")
		$VISTAHP = GUICtrlSetData($VERSIONLIST, "Home Premium", "")
		$VISTABU = GUICtrlSetData($VERSIONLIST, "Business", "")
		$VISTAUL = GUICtrlSetData($VERSIONLIST, "Ultimate", "")
		GUICtrlSetState($X86, $GUI_CHECKED)
		GUICtrlSetState($X86, $GUI_ENABLE)
		GUICtrlSetState($AMD64, $GUI_UNCHECKED)
		GUICtrlSetState($AMD64, $GUI_DISABLE)
		GUICtrlSetState($BIOS, $GUI_DISABLE)
		GUICtrlSetState($BIOS, $GUI_UNCHECKED)
		GUICtrlSetState($RECOVERY, $GUI_UNCHECKED)
		GUICtrlSetState($RECOVERY, $GUI_DISABLE)
		GUICtrlSetState($BUSINESS, $GUI_DISABLE)
	EndIf

	If $VAR = "Windows 7" Then
		GUICtrlSetData($VERSIONLIST, "")
		$WIN7ST = GUICtrlSetData($VERSIONLIST, "Starter", "")
		$WIN7HP = GUICtrlSetData($VERSIONLIST, "Home Premium", "")
		$WIN7PR = GUICtrlSetData($VERSIONLIST, "Professional", "")
		$WIN7UL = GUICtrlSetData($VERSIONLIST, "Ultimate", "")
		GUICtrlSetState($X86, $GUI_UNCHECKED)
		GUICtrlSetState($X86, $GUI_ENABLE)
		GUICtrlSetState($AMD64, $GUI_CHECKED)
		GUICtrlSetState($AMD64, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_UNCHECKED)
		GUICtrlSetState($RECOVERY, $GUI_UNCHECKED)
		GUICtrlSetState($RECOVERY, $GUI_DISABLE)
		GUICtrlSetState($BUSINESS, $GUI_ENABLE)
	EndIf

	If $VAR = "Windows 8.1" Then
		GUICtrlSetData($VERSIONLIST, "")
		$W8 = GUICtrlSetData($VERSIONLIST, "Home")
		$W8PRO = GUICtrlSetData($VERSIONLIST, "Professional")
		$W8ENT = GUICtrlSetData($VERSIONLIST, "Enterprise")
		GUICtrlSetState($X86, $GUI_DISABLE)
		GUICtrlSetState($X86, $GUI_UNCHECKED)
		GUICtrlSetState($AMD64, $GUI_CHECKED)
		GUICtrlSetState($AMD64, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_UNCHECKED)
		GUICtrlSetState($RECOVERY, $GUI_ENABLE)
		GUICtrlSetState($RECOVERY, $GUI_CHECKED)
		GUICtrlSetState($BUSINESS, $GUI_ENABLE)
	EndIf

	Case $msg = $VERSIONLIST

		GUICtrlSetState($MANULIST, $GUI_ENABLE)

	If GUICtrlRead($OSLIST) = "Windows 7" And GUICtrlRead($VERSIONLIST) = "Starter" Then
		GUICtrlSetState($X86, $GUI_ENABLE)
		GUICtrlSetState($X86, $GUI_CHECKED)
		GUICtrlSetState($AMD64, $GUI_UNCHECKED)
		GUICtrlSetState($AMD64, $GUI_DISABLE)
		GUICtrlSetState($BIOS, $GUI_CHECKED)
		GUICtrlSetState($BIOS, $GUI_DISABLE)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 7" And GUICtrlRead($VERSIONLIST) <> "Starter" Then
		GUICtrlSetState($X86, $GUI_DISABLE)
		GUICtrlSetState($X86, $GUI_UNCHECKED)
		GUICtrlSetState($AMD64, $GUI_CHECKED)
		GUICtrlSetState($AMD64, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_ENABLE)
		GUICtrlSetState($BIOS, $GUI_UNCHECKED)
	EndIf

	If GUICtrlRead($OSLIST) = "Windows 7" And GUICtrlRead($VERSIONLIST) = "Professional" Then
		Sleep(50)
		GUICtrlSetState($BUSINESS, $GUI_CHECKED)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 7" And GUICtrlRead($VERSIONLIST) <> "Professional" Then
		Sleep(50)
		GUICtrlSetState($BUSINESS, $GUI_UNCHECKED)
	EndIf

	If GUICtrlRead($OSLIST) = "Windows 8.1" and GUICtrlRead($VERSIONLIST) = "Professional" Then
		Sleep(50)
		GUICtrlSetState($RECOVERY, $GUI_UNCHECKED)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 8.1" and GUICtrlRead($VERSIONLIST) <> "Professional" Then
		Sleep(50)
		GUICtrlSetState($RECOVERY, $GUI_CHECKED)
	EndIf

		Sleep(50)
		$READOS = GUICtrlRead($OSLIST)
		$READVERSION = GUICtrlRead($VERSIONLIST)

	If $READOS <> "Windows 8.1" Then

			If $READOS = "Windows Vista" Then
				$OS = "VISTA"
			EndIf
			If $READOS = "Windows 7" Then
				$OS = "WIN7"
			EndIf

		$READX86 = GUICtrlRead($X86)
		$READAMD64 = GUICtrlRead($AMD64)

		$VAR = $READOS & " " & $READVERSION

		$sect = ""
			If StringInStr($var, "Home Editie")		    Then $sect = "HomeEdition"
			If StringInStr($var, "Media Center")        Then $sect = "MediaCenter"
			If StringInStr($var, "Home Basic") 			Then $sect = "HomeBasic"
			If StringInStr($var, "Home Premium")		Then $sect = "HomePremium"
			If StringInStr($var, "Business")			Then $sect = "Business"
			If StringInStr($var, "Starter")				Then $sect = "Starter"
			If StringInStr($var, "Professional")		Then $sect = "Professional"
			If StringInStr($var, "Ultimate")			Then $sect = "Ultimate"

		$var = IniReadSection("P:\Certificate\" & $OS & "\keys.ini", $sect)
			If @error <> 1 Then
				GUICtrlSetData($MANULIST, "")
				GUICtrlSetData($MANULIST, "Levix - Zelfbouw")
				GUICtrlSetData($MANULIST, "---------------------------------------------------")

				For $x = 1 To $var[0][0]
						; Netbook Software X86
					If $READX86 == $GUI_CHECKED And $sect = "Starter" Then
						If StringInStr($var[$x][0], "#!") Then
							$var1 = StringTrimRight($var[$x][0], 2)
							MsgBox(4096, "1", $var1)
							GUICtrlSetData($MANULIST, $var1 & " Activatie")
							GUICtrlSetData($MANULIST, $var1 & " Activatie + Netbook Software")
						EndIf
					EndIf
						; Notebook en Netbook Software
					If StringInStr($var[$x][0], "#@") Then
							$var1 = StringTrimRight($var[$x][0], 2)
							GUICtrlSetData($MANULIST, $var1 & " Activatie")
							If $READX86 = $GUI_CHECKED Then	GUICtrlSetData($MANULIST, $var1 & " Activatie + Netbook Software")
							GUICtrlSetData($MANULIST, $var1 & " Activatie + Notebook Software")
						; Notebook Software
					ElseIf StringInStr($var[$x][0], "##") Then
							$var1 = StringTrimRight($var[$x][0], 2)
							GUICtrlSetData($MANULIST, $var1 & " Activatie")
							GUICtrlSetData($MANULIST, $var1 & " Activatie + Notebook Software")
						EndIf
						; Activatie
					If StringInStr($var[$x][0], "#@") Or StringInStr($var[$x][0], "##") Or StringInStr($var[$x][0], "#!") Then
						Else
							GUICtrlSetData($MANULIST, $var[$x][0] & " Activatie")
						EndIf

					Next
					GUICtrlSetState($MANULIST, $GUI_ENABLE)
				Else
					GUICtrlSetData($MANULIST, "")
					GUICtrlSetData($MANULIST, "Levix - Zelfbouw")
				EndIf
	EndIf
	If $READOS = "Windows 8.1" Then
		GUICtrlSetState($RECOVERY, $GUI_ENABLE)
		GUICtrlSetState($RECOVERY, $GUI_CHECKED)
	EndIf
	If $READOS = "Windows 8.1" And $READVERSION <> "Enterprise" Then
		GUICtrlSetData($MANULIST, "")
		GUICtrlSetData($MANULIST, "Levix - Zelfbouw")
		GUICtrlSetData($MANULIST, "---------------------------------------------------")
		GUICtrlSetData($MANULIST, "OEM - activatie")
		GUICtrlSetData($MANULIST, "Acer - Notebook")
		GUICtrlSetData($MANULIST, "Asus - Notebook")
		GUICtrlSetData($MANULIST, "Toshiba - Notebook")
	EndIf

	If $READOS = "Windows 8.1" And $READVERSION = "Enterprise" Then
		GUICtrlSetData($MANULIST, "")
		GUICtrlSetData($MANULIST, "Levix - Intern")
	EndIf

		Case $msg = $MANULIST
			GUICtrlSetState($DEBITINPUT, $GUI_ENABLE)
			GUICtrlSetState($HOSTNAMEINPUT, $GUI_ENABLE)
			GUICtrlSetState($USERINPUT, $GUI_ENABLE)
			GUICtrlSetState($OFFICELIST, $GUI_ENABLE)
				$VAR = GUICtrlRead($OSLIST)
				If $VAR = "Windows Vista" Then
					GUICtrlSetData($OFFICELIST, "")
					GUICtrlSetData($OFFICELIST, "Geen Microsoft Office")
					GUICtrlSetData($OFFICELIST, "---------------------------------------------------")
					GUICtrlSetData($OFFICELIST, "Office 2007 - Home and Student", "")
					GUICtrlSetData($OFFICELIST, "Office 2010", "")
				EndIf
				If $VAR = "Windows 7" Then
					GUICtrlSetData($OFFICELIST, "")
					GUICtrlSetData($OFFICELIST, "Geen Microsoft Office")
					GUICtrlSetData($OFFICELIST, "---------------------------------------------------")
					GUICtrlSetData($OFFICELIST, "Office 2007 - Home and Student", "")
					GUICtrlSetData($OFFICELIST, "Office 2010", "")
					GUICtrlSetData($OFFICELIST, "Office 2013", "")
				EndIf
				If $VAR = "Windows 8.1" Then
					GUICtrlSetData($OFFICELIST, "")
					GUICtrlSetData($OFFICELIST, "Geen Microsoft Office")
					GUICtrlSetData($OFFICELIST, "---------------------------------------------------")
					GUICtrlSetData($OFFICELIST, "Office 2007 - Home and Student", "")
					GUICtrlSetData($OFFICELIST, "Office 2010", "")
					GUICtrlSetData($OFFICELIST, "Office 2013", "")
				EndIf

		Case $msg = $OFFICELIST
			GUICtrlSetState($PARTITIONLIST, $GUI_ENABLE)

		Case $msg = $PARTITIONLIST
			If GUICtrlRead($PARTITIONLIST) = "Wipe" &  "       l  één partitie" Then
				GUICtrlSetState($START, $GUI_ENABLE)
			EndIf

		Case $msg = $PARTITIONSIZELIST
			If GUICtrlRead($PARTITIONSIZELIST) <> " " Then
				GUICtrlSetState($START, $GUI_ENABLE)
			EndIf

		Case $msg = $BIOS
			If GUICtrlRead($OSLIST) = "Windows 8.1" Then
				If GUICtrlRead($BIOS) = $GUI_CHECKED Then
					GUICtrlSetState($RECOVERY, $GUI_UNCHECKED)
					GUICtrlSetState($RECOVERY, $GUI_DISABLE)
				EndIf
				If GUICtrlRead($BIOS) = $GUI_UNCHECKED Then
					GUICtrlSetState($RECOVERY, $GUI_ENABLE)
					GUICtrlSetState($RECOVERY, $GUI_CHECKED)
				EndIf
			EndIf

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

		If $LastInput <> GUICtrlRead($LICENCEINPUT) Then
			$LastInput = GUICtrlRead($LICENCEINPUT)
		If StringLen($LastInput) = $LenPart Then
			$LastInput &= "-"
		Else
			$Temp = StringSplit($LastInput,"-")
			If $Temp[$Temp[0]] <> "" And StringLen($Temp[$Temp[0]]) >= $LenPart And StringLen(GUICtrlRead($LICENCEINPUT)) < 29 Then
				$LastInput &= "-"
			EndIf
		EndIf
			GUICtrlSetData($LICENCEINPUT,$LastInput)
		EndIf
		If GUICtrlRead($PARTITIONLIST) <> "Wipe" &  "       l  één partitie" And GUICtrlRead($PARTITIONSIZELIST) = "" Then
			GUICtrlSetState($START, $GUI_DISABLE)
		EndIf
WEnd
;=====================================END IDLE LOOP===================================================================
;=====================================START ERRORCATCH================================================================
Func ERRORCATCH()

$GO = 1 ;------------------------------------------------------------------------Waarde voor de fout afvanging, als er iets fout gaat wordt $G0 = 0 , zodra er weer op $START gedrukt wordt dan, wordt $GO = 1

	If GUICtrlRead($MANULIST) = "Levix - Zelfbouw" Then
		If StringLen(GUICtrlRead($LICENCEINPUT)) <> 29 Then
			MsgBox(4096, "Let op!", "Licentie sleutel is te kort.")
			$GO = 0
		EndIf
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Starter" and GUICtrlRead($X86) = $GUI_UNCHECKED Then
		GUICtrlSetState($X86, $GUI_CHECKED)
	EndIf
	If GUICtrlRead($MANULIST) = "---------------------------------------------------" Then
		MsgBox(4096, "Let op!", "Kies de juiste Activatie & Software")
		$GO = 0
	EndIf
	If GUICtrlRead($OFFICELIST) = "---------------------------------------------------" Then
		MsgBox(4096, "Let op!", "Kies de juiste Microsoft Office optie")
		$GO = 0
	EndIf
	If GUICtrlRead($X86) = $GUI_UNCHECKED And GUICtrlRead($AMD64) = $GUI_UNCHECKED Then
		MsgBox(4096, "Let op!", "Maak een keuze uit 32-bit of 64-bit.")
		$GO = 0
	EndIf
	If GUICtrlRead($X86) = $GUI_CHECKED And GUICtrlRead($AMD64) = $GUI_CHECKED Then
		MsgBox(4096, "Let op!", "Maak een keuze uit 32-bit of 64-bit, niet voor allebei.")
		$GO = 0
	EndIf

		If GUICtrlRead($MAV) = $GUI_CHECKED Then
			If GUICtrlRead($DEBITINPUT) = "" Then
				MsgBox(4096, "Let op!", "Controleer: Computernaam")
				$GO = 0
			EndIf
			If GUICtrlRead($HOSTNAMEINPUT) = "" Then
				MsgBox(4096, "Let op!", "Controleer: Computernaam")
				$GO = 0
			EndIf
		EndIf

	$VAR1 = GUICtrlRead($DEBITINPUT)
	$VAR2 = GUICtrlRead($HOSTNAMEINPUT)

	If $VAR1 <> "" And $VAR2 <> "" Then
		$HOSTNAME = $VAR1 & "-" & $VAR2
			$LEN = StringLen($HOSTNAME)
				If $LEN > 15 Then
					MsgBox(4096, "Let op!", "Computernaam is te lang! Maximaal 14 tekens.")
					$GO = 0
				EndIf
	EndIf
				; Geen A:/B:/P:
				 Dim $aArray[23]

					$aArray[0]="C:"
					$aArray[1]="D:"
					$aArray[2]="E:"
					$aArray[3]="F:"
					$aArray[4]="G:"
					$aArray[5]="H:"
					$aArray[6]="I:"
					$aArray[7]="J:"
					$aArray[8]="K:"
					$aArray[9]="L:"
					$aArray[10]="M:"
					$aArray[11]="N:"
					$aArray[12]="O:"
					$aArray[14]="Q:"
					$aArray[15]="R:"
					$aArray[16]="S:"
					$aArray[17]="T:"
					$aArray[18]="U:"
					$aArray[19]="V:"
					$aArray[20]="W:"
					$aArray[13]="X:"
					$aArray[21]="Y:"
					$aArray[22]="Z:"

			For $letter In $aArray
				If DriveGetLabel($letter) = "WINPE" Then
					MsgBox(4096, "USB-Stick", "Verwijder Preload stick uit systeem!")
					   $GO = 0
				EndIf
			Next

If $GO = 1 Then START()

EndFunc
;=====================================END ERRORCATCH==================================================================
;=====================================START FUNCTION START============================================================
Func START()

GUICtrlSetState($OSLIST, $GUI_DISABLE)
GUICtrlSetState($VERSIONLIST, $GUI_DISABLE)
GUICtrlSetState($LICENCEINPUT, $GUI_DISABLE)
GUICtrlSetState($MANULIST, $GUI_DISABLE)
GUICtrlSetState($DEBITINPUT, $GUI_DISABLE)
GUICtrlSetState($HOSTNAMEINPUT, $GUI_DISABLE)
GUICtrlSetState($USERINPUT, $GUI_DISABLE)
GUICtrlSetState($OFFICELIST, $GUI_DISABLE)
GUICtrlSetState($PARTITIONLIST, $GUI_DISABLE)
GUICtrlSetState($PARTITIONSIZELIST, $GUI_DISABLE)
GUICtrlSetState($AMD64, $GUI_DISABLE)
GUICtrlSetState($X86, $GUI_DISABLE)
GUICtrlSetState($MAV, $GUI_DISABLE)
GUICtrlSetState($RECOVERY, $GUI_DISABLE)
GUICtrlSetState($BUSINESS, $GUI_DISABLE)
GUICtrlSetState($BIOS, $GUI_DISABLE)
GUICtrlSetState($HULP, $GUI_DISABLE)
GUICtrlSetState($REBOOTHALT, $GUI_DISABLE)
GUICtrlSetState($NODRIVER, $GUI_DISABLE)
GUICtrlSetState($START, $GUI_DISABLE)
	GUICtrlSetData($START, "GESTART")

		$READOS = GUICtrlRead($OSLIST)
		$READVERSION = GUICtrlRead($VERSIONLIST)

	If GUICtrlRead($X86) = $GUI_CHECKED Then
		$VAR = "32-Bit"
	EndIf
	If GUICtrlRead($AMD64) = $GUI_CHECKED Then
		$VAR = "64-Bit"
	EndIf

FileOpen("X:\Preload.log", 2)
   logb($LINE)
   Logb("Installatie gestart: " & $READOS & " " & $READVERSION & " " & $VAR)
   $VAR = GUICtrlRead($MANULIST)
   Logb("Activatie type: " & $VAR)
   If GUICtrlRead($BUSINESS) = $GUI_CHECKED Then
	   logb("Installatie type: Zakelijk")
   EndIf
   If GUICtrlRead($BUSINESS) = $GUI_UNCHECKED Then
	   logb("Installatie type: Particulier")
   EndIf
   Logb("Installatie gestart op: " & @MDAY & "/" & @MON & "/" & @YEAR & "  |  " & @HOUR & ":" & @MIN & ":" & @SEC)
   	$VAR1 = GUICtrlRead($DEBITINPUT)
	$VAR2 = GUICtrlRead($HOSTNAMEINPUT)
	$VAR3 = GUICtrlRead($USERINPUT)

	If $VAR1 <> "" And $VAR2 <> "" Then
		$HOSTNAME = $VAR1 & "-" & $VAR2
		Logb("Computernaam: " & $HOSTNAME)
	EndIf
	If $VAR3 <> "" Then
		Logb("Gebruikersnaam: " & $VAR3)
	EndIf
	logb($LINE)
;=====================================START DISKPART==================================================================
Logb("   - Partities aanmaken")

	$READOS 		= GUICtrlRead($OSLIST)
	$READPARTITION 	= GUICtrlRead($PARTITIONLIST)
	$READSIZE 		= GUICtrlRead($PARTITIONSIZELIST)
	$BIOSREAD 		= GUICtrlRead($BIOS)

Logb("     * Gekozen indeling: " & $READPARTITION)
	If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
		Logb("     * Capaciteit C: " & $READSIZE)
	EndIf

;=====================================START WINDOWS VISTA=============================================================
If $READOS = "Windows Vista" Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\Bios\VISTA\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\Bios\VISTA\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
  RunWait(@ComSpec & " /c " & " P:\Scripts\Preload\Diskpart\diskpart.cmd " & "X:\diskpart.txt" & "" & "> X:\diskpartlog.txt", "", @SW_HIDE) ;----------------Zorgt ervoor dat de diskpart batchfile verborgen wordt uitgevoerd.
EndIf
;=====================================END WINDOWS VISTA===============================================================
;=====================================START WINDOWS 7=================================================================
If $READOS = "Windows 7" Then

If $BIOSREAD = $GUI_UNCHECKED Then
	If GUICtrlRead($RECOVERY) = $GUI_UNCHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\non Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\non Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
	If GUICtrlRead($RECOVERY) = $GUI_CHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
EndIf
If $BIOSREAD = $GUI_CHECKED Then
	If GUICtrlRead($RECOVERY) = $GUI_UNCHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\non Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\non Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
	If GUICtrlRead($RECOVERY) = $GUI_CHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
EndIf
  RunWait(@ComSpec & " /c " & " P:\Scripts\Preload\Diskpart\diskpart.cmd " & "X:\diskpart.txt" & "" & "> X:\diskpartlog.txt", "", @SW_HIDE) ;----------------Zorgt ervoor dat de diskpart batchfile verborgen wordt uitgevoerd.
EndIf
;=====================================END WINDOWS 7===================================================================
;=====================================START WINDOWS 8.1===============================================================
If $READOS = "Windows 8.1" Then

If $BIOSREAD = $GUI_UNCHECKED Then
	If GUICtrlRead($RECOVERY) = $GUI_UNCHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\non Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\non Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
	If GUICtrlRead($RECOVERY) = $GUI_CHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\EFI\Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
EndIf
If $BIOSREAD = $GUI_CHECKED Then
	If GUICtrlRead($RECOVERY) = $GUI_UNCHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\non Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\non Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
	If GUICtrlRead($RECOVERY) = $GUI_CHECKED Then
			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\Recovery\wipe.txt", "X:\Windows\System32")
			   FileMove("X:\Windows\System32\wipe.txt", "X:\diskpart.txt")
				 If Not FileExists("X:\diskpart.txt") Then
					 MsgBox(4096, "Let op!", "Diskpart.txt niet kunnen kopieren")
				  EndIf
			 EndIf

			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				$var	= 	GUICtrlRead($READSIZE)
				$PARTSIZE =	StringTrimRight($READSIZE, 3)
			   FileCopy("P:\Scripts\Preload\Diskpart\BIOS\Recovery\custom.txt", "X:\Windows\system32")
			   FileMove("X:\Windows\System32\custom.txt", "X:\diskpart.txt")
				  Local $FIND = "REPLACE"
				  Local $REPLACE = "CREATE PARTITION PRIMARY SIZE=" & $PARTSIZE & "000"
				  Local $FILENAME = "X:\diskpart.txt"
				  Local $RUN = _ReplaceStringInFile($FILENAME, $FIND, $REPLACE)
				  If $RUN = -1 Then
					 MsgBox(4096, "Waarschuwing", "Diskpart.txt niet kunnen aanpassen, waarschijnlijk diskpart.txt niet aanwezig")
				  EndIf
			EndIf
	EndIf
EndIf
   RunWait(@ComSpec & " /c " & " P:\Scripts\Preload\Diskpart\diskpart.cmd " & "X:\diskpart.txt" & "" & "> X:\diskpartlog.txt", "", @SW_HIDE) ;----------------Zorgt ervoor dat de diskpart batchfile verborgen wordt uitgevoerd.
EndIf
;=====================================END WINDOWS 8.1=================================================================
;=====================================END DISKPART====================================================================
;=====================================START INSTALLING IMAGE==========================================================
Logb("   - Uitpakken image")

$READVERSION = GUICtrlRead($VERSIONLIST)

If $READOS = "Windows Vista" Then
	If GUICtrlRead($X86) = $GUI_CHECKED Then
		$IMAGE = "P:\Image\WINVISTA.WIM"
		$ARCH = "32-Bit"
		If $READVERSION = "Home Basic" Then
			$IMAGELABEL = "BASIC"
		EndIf
		If $READVERSION = "Home Premium" Then
			$IMAGELABEL = "PREMIUM"
	    EndIf
	    If $READVERSION = "Business" Then
			$IMAGELABEL = "BUSINESS"
		EndIf
		If $READVERSION = "Ultimate" Then
			$IMAGELABEL = "ULTIMATE"
		EndIf
	EndIf
		RunWait("P:\installvistaw7.cmd " & $IMAGE & " " & $IMAGELABEL)
EndIf
If $READOS = "Windows 7" Then
	If GUICtrlRead($X86) = $GUI_CHECKED Then
		$IMAGE = "P:\Image\WIN7-X86.WIM"
		$ARCH = "32-Bit"
		$IMAGELABEL = "1"
		If $READVERSION = "Home Premium" Then
		   $READVERSION = "HomePremium"
		 EndIf
	EndIf
If GUICtrlRead($AMD64) = $GUI_CHECKED Then
		$IMAGE = "P:\Image\WIN7-X64.WIM"
		$ARCH = "64-Bit	"
		$IMAGELABEL = "AMD64"
		 If $READVERSION = "Home Premium" Then
		   $READVERSION = "HomePremium"
		 EndIf
	EndIf
	If $BIOSREAD = $GUI_CHECKED Then
		RunWait("P:\installvistaw7.cmd " & $IMAGE & " " & $IMAGELABEL)
	EndIf
	If $BIOSREAD = $GUI_UNCHECKED Then
		RunWait("P:\installw8.cmd " & $IMAGE & " " & $IMAGELABEL)
	EndIf
EndIf

If $READOS = "Windows 8.1" And $READVERSION <> "Enterprise" Then
	If GUICtrlRead($X86) = $GUI_CHECKED Then
		$IMAGE = "P:\Image\WIN81-X86.WIM"
		$ARCH = "32-Bit"
		$IMAGELABEL = "X86"
	EndIf
	If GUICtrlRead($AMD64) = $GUI_CHECKED Then
		$IMAGE = "P:\Image\WIN81-X64.WIM"
		$ARCH = "64-Bit"
		If GUICtrlRead($VERSIONLIST) = "Home" Then
			$IMAGELABEL = "AMD64"
		EndIf
		If GUICtrlRead($VERSIONLIST) = "Professional" Then
			$IMAGELABEL = "AMD64PRO"
		EndIf
	EndIf
		RunWait("P:\installw8.cmd " & $IMAGE & " " & $IMAGELABEL)
EndIf

If $READOS = "Windows 8.1" And $READVERSION = "Enterprise" Then
	$IMAGE = "P:\Image\WIN81ENT.WIM"
	$IMAGELABEL = "AMD64PRO"
	RunWait("P:\installw8.cmd " & $IMAGE & " " & $IMAGELABEL)
EndIf
;=====================================END INSTALLING IMAGE============================================================
;=====================================START CONVERT IMAGE=============================================================
$VAR = GUICtrlRead($VERSIONLIST)

If $READOS = "Windows 7" And GUICtrlRead($X86) = $GUI_CHECKED Then
	If $VAR <> "Starter" Then
		$VAR = GUICtrlRead($VERSIONLIST)
			If $VAR = "Home Premium" Then
				$VAR = "HomePremium"
			EndIf
		logb("   - Converteren image naar Windows 7 " & $VAR)
		RunWait("dism.exe /image:L:\ /Set-Edition:" & $VAR, "", @SW_HIDE)
	EndIf
EndIf

If $READOS = "Windows 7" And GUICtrlRead($AMD64) = $GUI_CHECKED Then
	If $VAR <> "Home Premium" Then
		$VAR = GUICtrlRead($VERSIONLIST)
		logb("   - Converteren image naar Windows 7 " & $VAR)
		RunWait("dism.exe /image:L:\ /Set-Edition:" & $VAR, "", @SW_HIDE)
	EndIf
EndIf

;-------Windows 8.1 heeft geen convert image daar zit de Pro image in de basic image toegevoegd, meer info zie batchfile: scripts\winpe\capture wim file.cmd
;=====================================END CONVERT IMAGE===============================================================
;=====================================START COPY XML==================================================================
$X86READ = GUICtrlRead($X86)
$READMANU = GUICtrlRead($MANULIST)
$unxml = "L:\Windows\Panther\unattend.xml"

logb("   - Kopieren van het Windows antwoordbestand")

If $READOS = "Windows Vista" Then
	If $X86READ = $GUI_CHECKED Then
		If FileExists("P:\Scripts\Preload\XML\VISTA\unattend-86.xml") Then
			FileCopy("P:\Scripts\Preload\XML\VISTA\unattend-86.xml", "L:\Windows\Panther\unattend.xml", 9)
		EndIf
	EndIf

	If GUICtrlRead($VERSIONLIST) = "Home Basic" Then
		$serial = "RCG7P-TX42D-HM8FM-TCFCW-3V4VD"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Home Premium" Then
		$serial = "X9HTF-MKJQQ-XK376-TJ7T4-76PKF"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Business" Then
		$serial = "4D2XH-PRBMM-8Q22B-K8BM3-MRW4W"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Ultimate" Then
		$serial = "VMCB9-FDRV6-6CDQM-RV23K-RP8F7"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
EndIf
If $READOS = "Windows 7" Then
	If $X86READ = $GUI_UNCHECKED Then
		If GUICtrlRead($BUSINESS) = $GUI_CHECKED Then
			FileCopy("P:\Scripts\Preload\XML\W7\unattend-64-zakelijk.xml", "L:\Windows\Panther\unattend.xml")
		EndIf
		If GUICtrlRead($BUSINESS) = $GUI_UNCHECKED Then
			FileCopy("P:\Scripts\Preload\XML\W7\unattend-64.xml", "L:\Windows\Panther\unattend.xml", 9)
		EndIf
	EndIf

	If $X86READ = $GUI_CHECKED Then
		If FileExists("P:\Scripts\Preload\XML\W7\unattend-86.xml") Then
			FileCopy("P:\Scripts\Preload\XML\W7\unattend-86.xml", "L:\Windows\Panther\unattend.xml", 9)
		EndIf
	EndIf

	If GUICtrlRead($VERSIONLIST) = "Starter" Then
		$serial = "4BBYK-RWRBY-2HXW2-D7GVB-2M96H"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Home Premium" Then
		$serial = "VMRMG-M2T2H-J94Y8-YWFHP-GYQ9J"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Professional" Then
		$serial = "MVPTQ-RXGD9-PRWFG-JGJVW-VBQDK"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
	If GUICtrlRead($VERSIONLIST) = "Ultimate" Then
		$serial = "2THDF-8MVG4-B8JK7-X8Y47-T8PXF"
			_ReplaceStringInFile($unxml, "SERIAL",		$serial)
	EndIf
EndIf

If $READOS = "Windows 8.1" Then
	If $X86READ = $GUI_UNCHECKED Then

		If GUICtrlRead($BUSINESS) = $GUI_CHECKED Then
			FileCopy("P:\Scripts\Preload\XML\W81\unattend-64-zakelijk.xml", "L:\Windows\Panther\unattend.xml")
		EndIf
		If GUICtrlRead($BUSINESS) = $GUI_UNCHECKED Then
			FileCopy("P:\Scripts\Preload\XML\W81\unattend-64.xml", "L:\Windows\Panther\unattend.xml", 9)
		EndIf
	EndIf

	If $X86READ = $GUI_CHECKED Then
		If FileExists("P:\Scripts\Preload\XML\W81\unattend-86.xml") Then
			FileCopy("P:\Scripts\Preload\XML\W81\unattend-86.xml", "L:\Windows\Panther\unattend.xml", 9)
		EndIf
	EndIf

		If GUICtrlRead($VERSIONLIST) = "Home" And $READMANU = "Levix - Zelfbouw" Then
				$serial = "334NH-RXG76-64THK-C7CKG-D3VPT"
					_ReplaceStringInFile($unxml, "SERIAL",		$serial)
				Else
				$serial = "DQQ2P-YNF4V-CMQHJ-RPXK8-QC736"
					_ReplaceStringInFile($unxml, "SERIAL",		$serial)
		EndIf

		If GUICtrlRead($VERSIONLIST) = "Professional" And $READMANU = "Levix - Zelfbouw" Then
				$serial = "XHQ8N-C3MCJ-RQXB6-WCHYG-C9WKB"
					_ReplaceStringInFile($unxml, "SERIAL",		$serial)
				Else
				$serial = "DR38Q-GTNFD-WR3TR-VBXBV-QPBRC"
					_ReplaceStringInFile($unxml, "SERIAL",		$serial)
		EndIf

		If GUICtrlRead($VERSIONLIST) = "Enterprise" Then
				$serial = "XHQ8N-C3MCJ-RQXB6-WCHYG-C9WKB"
					_ReplaceStringInFile($unxml, "SERIAL",		$serial)
		EndIf
EndIf

	$VAR1 = GUICtrlRead($DEBITINPUT)
	$VAR2 = GUICtrlRead($HOSTNAMEINPUT)
	$VAR3 = GUICtrlRead($USERINPUT)

If $VAR1 <> "" And $VAR2 <> "" Then
	$HOSTNAME = "<ComputerName>" & $VAR1 & "-" & $VAR2 & "</ComputerName>"
			_ReplaceStringInFile($unxml, "<ComputerName>*</ComputerName>", $HOSTNAME)
EndIf
If $VAR3 <> "" Then
	$USER = "<DisplayName>" & $VAR3 & "</DisplayName>"
	_ReplaceStringInFile($unxml, "<DisplayName>USER</DisplayName>", $USER)
	$USER = "<Name>" & $VAR3 & "</Name>"
	_ReplaceStringInFile($unxml, "<Name>USER</Name>", $USER)
EndIf
If $VAR3 = "" Then
	$USER = "<DisplayName>Beheerder</DisplayName>"
	_ReplaceStringInFile($unxml, "<DisplayName>USER</DisplayName>", $USER)
	$USER = "<Name>Beheerder</Name>"
	_ReplaceStringInFile($unxml, "<Name>USER</Name>", $USER)
EndIf
;=====================================END COPY XML====================================================================
;=====================================START CERTIFICATE===============================================================
If GUICtrlRead($OSLIST) = "Windows 7" And GUICtrlRead($MANULIST) <> "Levix - Zelfbouw" Then

logb("   - OEM Certificaat kopieren")

	DirCreate("L:\Windows\OEM")

	If GUICtrlRead($OSLIST) = "Windows Vista" Then
		$OS = "VISTA"
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 7" Then
		$OS = "WIN7"
	EndIf

	$OS1 = GUICtrlRead($MANULIST)
	$OS2 = GUICtrlRead($VERSIONLIST)

	Dim $aArray
		_FileReadToArray("P:\Certificate\oem.ini", $aArray)

		For $var = 1 To $aArray[0]
			If StringInStr($OS1, $aArray[$var]) Then
				$oem = $aArray[$var]
			If StringInStr($oem, "##") Or StringInStr($oem, "#!") Or StringInStr($oem, "#@") Then $oem = StringTrimRight($oem, 2)
			;logb("   - OEM fabrikant: " & $oem)
			DirCopy("P:\Certificate\" & $OS & "\"& $oem, "L:\Windows\OEM", 1)
			FileCopy("P:\Certificate\oem-install.vbs", "L:\Windows\OEM", 9)

	$XML = ""
		If StringInStr($OS2, "Home Edition") 			Then $XML = "HomeEdition" ; XP
		If StringInStr($OS2, "Media Center Edition")	Then $XML = "MediaCenter" ; XP
		If StringInStr($OS2, "Starter") 	 			Then $XML = "Starter"     ; 7
		If StringInStr($OS2, "Professional")			Then $XML = "Professional"; 7 & XP
		If StringInStr($OS2, "Home Premium") 			Then $XML = "HomePremium" ; Vista & 7
		If StringInStr($OS2, "Ultimate")	 			Then $XML = "Ultimate"    ; Vista & 7
		If StringInStr($OS2, "Business")	 			Then $XML = "Business"    ; Vista
		If StringInStr($OS2, "Home Basic")	 			Then $XML = "HomeBasic"   ; Vista

		$var	= IniRead("P:\Certificate\" & $OS & "\keys.ini", $XML, $oem, "")
			If $var = "" Then $var	= IniRead("P:\Certificate\" & $OS & "\keys.ini", $XML, $oem & "##", "")
			If $var = "" Then $var	= IniRead("P:\Certificate\" & $OS & "\keys.ini", $XML, $oem & "#@", "")
			If $var = "" Then $var	= IniRead("P:\Certificate\" & $OS & "\keys.ini", $XML, $oem & "#!", "")
		$file	= FileOpen("L:\Windows\OEM\install.cmd", 1)
			FileWrite($file, "PUSHD %systemroot%\OEM" & @CRLF)
			FileWrite($file, "cscript /nologo oem-install.vbs oem-cert.xrm-ms " & $var & @CRLF)
			FileClose($file)
		ExitLoop
		EndIf
		Next

EndIf
;=====================================END CERTIFICATE=================================================================
;=====================================START COPY DRIVERS & SOFTWARE===================================================
$GODRIVER = 1

If GUICtrlRead($NODRIVER) = $GUI_CHECKED Then
	$GODRIVER = 0
EndIf

IF NOT FileExists("L:\Install") Then
	DirCreate("L:\Install")
	DirCreate("L:\Install\Software")
EndIf
;--------------------------------------------------------------------------------------------
If $GODRIVER = 1 Then
Logb("   - Drivers kopieren (Even geduld a.u.b.  Dit kan een paar minuten duren)")

	DirCreate("L:\Install\Drivers")
	DirCreate("L:\Install\Zipped")
	DirCreate("L:\Install\Zipped\bin")

	FileCopy("P:\Drivers\Install\dpinst.exe", "L:\Install\Drivers", 1)
	FileCopy("P:\Drivers\Install\dpinst.xml", "L:\Install\Drivers", 1)
	FileCopy("P:\Drivers\Install\unpack.cmd", "L:\Install\Zipped", 1)
	DirCopy("P:\Drivers\Install\bin", "L:\Install\Zipped\bin", 1)

If GUICtrlRead($X86) = $GUI_CHECKED Then
	If GUICtrlRead($OSLIST) = "Windows Vista" Then
		DirCopy("P:\Drivers\VISTA\X86", "L:\Install\Zipped", 1)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 7" Then
		DirCopy("P:\Drivers\W7\X86", "L:\Install\Zipped", 1)
	EndIf
EndIf

If GUICtrlRead($AMD64) = $GUI_CHECKED Then
	If GUICtrlRead($OSLIST) = "Windows 7" Then
		DirCopy("P:\Drivers\W7\AMD64", "L:\Install\Zipped", 1)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 8.1" Then
		DirCopy("P:\Drivers\W8\AMD64", "L:\Install\Zipped", 1)
	EndIf
EndIf

EndIf
;--------------------------------------------------------------------------------------------
Logb("   - Java, Adobe Flash Player & Adobe Reader kopieren")
	If GUICtrlRead($OSLIST) = "Windows Vista" Then
		FileCopy("P:\Software\W7\Ninite.exe", "L:\Install\Software", 1)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 7" Then
		FileCopy("P:\Software\W7\Ninite.exe", "L:\Install\Software", 1)
	EndIf
	If GUICtrlRead($OSLIST) = "Windows 8.1" Then
		FileCopy("P:\Software\W8\Ninite.exe", "L:\Install\Software", 1)
	EndIf
;--------------------------------------------------------------------------------------------
If GUICtrlRead($OSLIST) = "Windows 7" Then
	If $READMANU = "Asus Activatie + Notebook Software" Then
		Logb("   - ASUS notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
			DirCreate("L:\Install\Software\ASUS")
			DirCopy("P:\Software\W7\ASUS", "L:\Install\Software\ASUS", 1)
	EndIf

	If $READMANU = "MSI Activatie + Notebook Software" Then
		Logb("   - MSI notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
			DirCreate("L:\Install\Software\MSI")
			DirCopy("P:\Software\W7\MSI", "L:\Install\Software\MSI", 1)
	EndIf

	If $READMANU = "Samsung Activatie + Notebook Software" Then
		Logb("   - Samsung notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
			DirCreate("L:\Install\Software\SAMSUNG")
			DirCopy("P:\Software\W7\SAMSUNG", "L:\Install\Software\SAMSUNG", 1)
	EndIf

	If $READMANU = "Toshiba Activatie + Notebook Software" Then
		Logb("   - Toshiba notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
			DirCreate("L:\Install\Software\TOSHIBA")
			DirCopy("P:\Software\W7\TOSHIBA", "L:\Install\Software\TOSHIBA", 1)
	EndIf
EndIf

If GUICtrlRead($OSLIST) = "Windows 8.1" Then
	If $READMANU = "Acer - Notebook" Then
		Logb("   - Acer notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
				DirCreate("L:\Install\Software\Acer")
				DirCopy("P:\Software\W8\Acer", "L:\Install\Software\Acer", 1)
	EndIf

	If $READMANU = "Asus - Notebook" Then
		Logb("   - Asus notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
			If Not FileExists("L:\Install\Software\Asus") Then
				DirCreate("L:\Install\Software\Asus")
				DirCopy("P:\Software\W8\Asus", "L:\Install\Software\Asus", 1)
			EndIf
	EndIf

	If $READMANU = "Toshiba - Notebook" Then
		Logb("   - Toshiba notebook software kopieren")
			If Not FileExists("L:\Install\Software") Then
				DirCreate("L:\Install\Software")
			EndIf
				DirCreate("L:\Install\Software\Toshiba")
				DirCopy("P:\Software\W8\Toshiba", "L:\Install\Software\Toshiba", 1)
	EndIf
EndIf

$READOFFICE = GUICtrlRead($OFFICELIST)

	If $READOFFICE = "Office 2007 - Home and Student" Then
	  Logb("   - Microsoft Office 2007 installatie bestanden kopieren")
	  DirCreate("L:\Install\Software\Office")
	  DirCopy("P:\Software\Office\2007", "L:\Install\Software\Office", 1)
	EndIf

	If $READOFFICE = "Office 2010" Then
	  Logb("   - Microsoft Office 2010 installatie bestanden kopieren")
	  DirCreate("L:\Install\Software\Office")
	  DirCopy("P:\Software\Office\2010", "L:\Install\Software\Office", 1)
	EndIf

	If $READOFFICE ="Office 2013" Then
     Logb("   - Microsoft Office 2013 installatie bestanden kopieren")
     DirCreate("L:\Install\Software\Office")
     DirCopy("P:\Software\Office\2013\DVD", "L:\Install\Software\Office", 1)
	EndIf

Logb("   - Levix Software Installatie kopieren")

	DirCreate("L:\Install\Software\Levix")
	DirCreate("L:\Windows\Web\Wallpaper\Levix")
	DirCreate("L:\Windows\System32\LevixOEM")

	If GUICtrlRead($OSLIST) = "Windows 7" Then
		If FileExists("P:\Graphics\WelcomeScreen\backgroundDefault.jpg") Then
			DirCreate("L:\Install\WelcomeScreen")
			DirCreate("L:\Install\WelcomeScreen\Info")
			DirCreate("L:\Install\WelcomeScreen\Info\backgrounds")
			FileCopy("P:\Graphics\WelcomeScreen\backgroundDefault.jpg", "L:\Install\WelcomeScreen\Info\backgrounds", 1)
		EndIf
		If GUICtrlRead($BUSINESS) = $GUI_CHECKED Then
			FileCopy("P:\Software\Zakelijk\Zakelijk.txt", "L:\Install\Software", 1)
		EndIf
	EndIf

	If $READMANU = "Levix - Zelfbouw" Then
		$LICENCEREAD = GUICtrlRead($LICENCEINPUT)
			IniWrite("L:\Install\Software\Levix\licentie.ini","LICENTIE","SLEUTEL", $LICENCEREAD)
	EndIf

	If $READMANU = "Levix - Intern" Then
				$LICENCEREAD = "VQMHX-MJNTW-QK62K-973B7-G6MDQ"
			IniWrite("L:\Install\Software\Levix\licentie.ini","LICENTIE","SLEUTEL", $LICENCEREAD)
	EndIf

	If $READOS = "Windows Vista" Then
		FileCopy("P:\Graphics\Vista-Theme\Levix.Theme", "L:\Windows\Web\Wallpaper\Levix", 1)
	EndIf

	FileCopy("P:\Software\Levix\Levix.exe", "L:\Install\Software\Levix", 1) ;------------------------------------------------------------------------------Dit is de Levix installatie binnen Windows.
	FileCopy("P:\Software\Levix\desktop.scf", "L:\Install\Software\Levix", 1) ;----------------------------------------------------------------------------Wordt gebruikt door Levix installatie binnen Windows eerst show desktop te doen.
	FileCopy("P:\Graphics\Logo\oemlogo.bmp", "L:\Windows\System32\LevixOEM", 1) ;--------------------------------------------------------------------------Dit is het levix logo dat bij systeem eigenschappen wordt weergegeven.
	FileCopy("P:\Graphics\Wallpaper\Levix.jpg", "L:\Windows\Web\Wallpaper\Levix", 1) ;---------------------------------------------------------------------Dit is de Levix achtegrond. Deze wordt standaard ingesteld.

	If GUICtrlRead($RECOVERY) = $GUI_CHECKED Then
	logb("   - Windows herstel bestanden kopieren")

	If GUICtrlRead($OSLIST) = "Windows 7" Then
		DirCreate("R:\Recovery\WindowsRE")
		DirCreate("R:\Herstel-Bestanden")
			If FileExists("L:\Windows\System32\Recovery\winre.wim") Then
				FileCopy("L:\Windows\System32\Recovery\winre.wim", "R:\Recovery\WindowsRE\winre.wim", 1)
			Else
				MsgBox(4096, "Let op!", "Herstel image niet gevonden")
			EndIf
			If FileExists("R:\Recovery\WindowsRE\winre.wim") Then
				RunWait("reagentc /setreimage /path R:\Recovery\WindowsRE /target L:\Windows")
			EndIf
	EndIf

	If GUICtrlRead($OSLIST) = "Windows 8.1" Then
				DirCreate("T:\Recovery")
				DirCreate("T:\Recovery\WindowsRE")
				DirCreate("R:\Herstel-Bestanden")
					If FileExists("L:\Windows\System32\Recovery\winre.wim") Then
						FileCopy("L:\Windows\System32\Recovery\winre.wim", "T:\Recovery\WindowsRE\winre.wim", 1)
					Else
						MsgBox(4096, "Let op!", "Herstel image niet gevonden")
					EndIf
					If FileExists("T:\Recovery\WindowsRE\winre.wim") Then
						RunWait("reagentc /setreimage /path T:\Recovery\WindowsRE /target L:\Windows")
					EndIf
	EndIf
	Logb("   - Windows herstel-image maken")
			If GUICtrlRead($OSLIST) = "Windows 7" Then
				FileCopy("P:\Software\Levix\W7\recovery-instellen.cmd", "L:\Install\Software\Levix\recovery-instellen.cmd", 1)
			EndIf
			If GUICtrlRead($OSLIST) = "Windows 8.1" Then
				FileCopy("P:\Software\Levix\W81\recovery-instellen.cmd", "L:\Install\Software\Levix\recovery-instellen.cmd", 1)
			EndIf

			If $READPARTITION = "Wipe" &  "       l  één partitie" Then
				FileCopy("P:\Scripts\Preload\Diskpart\Recovery\EFI\wipe.txt", "L:\Install\Software\Levix\diskpart.txt", 1)
			EndIf
			If $READPARTITION = "Custom" &  "  l  aangepaste partitie" Then
				FileCopy("P:\Scripts\Preload\Diskpart\Recovery\EFI\custom.txt", "L:\Install\Software\Levix\diskpart.txt", 1)
			EndIf
	RunWait("P:\recovery.cmd")
	EndIf
;=====================================END COPY DRIVERS & SOFTWARE=====================================================
Logb($LINE)

If GUICtrlRead($REBOOTHALT) = $GUI_CHECKED Then
Logb("Installatie voltooid op: " & @MDAY & "/" & @MON & "/" & @YEAR & "  |  " & @HOUR & ":" & @MIN & ":" & @SEC)
	FileCopy("X:\Preload.log", "L:\Windows\System32\LevixOEM", 1)
	MsgBox(4096, "Klaar", "Preload is klaar, klik op OK voor uitschakelen")
	Shutdown(1) ;----------------------------Shutdown en de 1 staat voor uitschakelen
EndIf
If GUICtrlRead($REBOOTHALT) = $GUI_UNCHECKED Then
Logb("Installatie voltooid, het systeem gaat over 5 seconden herstarten.")
Logb("Installatie voltooid op: " & @MDAY & "/" & @MON & "/" & @YEAR & "  |  " & @HOUR & ":" & @MIN & ":" & @SEC)
	FileCopy("X:\Preload.log", "L:\Windows\System32\LevixOEM", 1)
	Sleep(5000) ;----------------------------Wachten voor 5 seconden
	Shutdown(2) ;----------------------------Shutdown en de 2 staat voor herstarten
EndIf

EndFunc
;=====================================END FUNCTION START==============================================================
;=====================================START LOGBOEK FUNCTION==========================================================
Func logb($LOGTEXT)
  _GUICtrlEdit_AppendText($LOGGER, @CRLF & $LOGTEXT) ;------------------------------Je vind regelmatig in het script een regel die begint met Logb("...") , deze functie zorgt ervoor dat die regel in het Edit veld wordt toegevoegd.
  FileWriteLine("X:\Preload.log", $LOGTEXT & @CRLF)
EndFunc
;=====================================END LOGBOEK FUNCTION============================================================
;=====================================START CHANGELOG FUNCTION========================================================
Func CHANGELOG()

If FileExists("X:\log.txt") Then
	FileDelete("X:\log.txt")
EndIf

FileCopy("P:\Changelog\log.txt", "X:\log.txt")
Run("notepad.exe X:\log.txt")

EndFunc
;=====================================END CHANGELOG FUNCTION==========================================================
;=====================================START BACKSPACE FUNCTION========================================================
Func _BackSpace()
	If Not WinActive($gui) Then Return 0
	If StringRight($LastInput,1) = "-" Then
		Return GUICtrlSetData($LICENCEINPUT,StringLeft($LastInput,StringLen($LastInput)-2))
	Else
		Return GUICtrlSetData($LICENCEINPUT,StringLeft($LastInput,StringLen($LastInput)-1))
	EndIf
EndFunc
;=====================================END BACKSPACE FUNCTION==========================================================
;=====================================START TERMINATE FUNCTION========================================================
Func TERMINATE()
WinSetState("[CLASS:ConsoleWindowClass]", "", @SW_SHOW)
EXIT
EndFunc
;=====================================END TERMINATE FUNCTION==========================================================