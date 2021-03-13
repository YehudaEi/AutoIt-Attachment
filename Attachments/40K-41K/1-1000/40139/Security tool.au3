; #########################################################################
; ########## Téléchargements de programmes d'analyse de sécurité ##########
; #########################################################################
; - Stinger
; - Spybot - Search & Destroy
; - Dr.Web CureIt!
; - Malwarebytes
; - AdwCleaner
; - Gmer
; #########################################################################

#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <EditConstants.au3>
#include <ProgressConstants.au3>
#include <Array.au3>
#include <Inet.au3>

Opt("GUICloseOnESC", 1)
Opt("TrayAutoPause", 0)

$Fenetre_principale = GUICreate("Outils de sécurité", 300, 280)

$Tailles_fenetre = WinGetPos("Outils de sécurité")
$Label_enregistrement = GUICtrlCreateLabel("Dossier d'enregistrement : ", 10, 12, 150)
GUICtrlSetFont($Label_enregistrement, 8.5, 600, 4)
GUICtrlSetColor($Label_enregistrement, 0x007399)
$Boutton_selection_dossier = GUICtrlCreateButton("Sélectionner", 165, 8, 87, 25)
$Label_selection_dossier = GUICtrlCreateInput("", 10, 40, 280, 21)
$Executer = GUICtrlCreateButton("Executer", $Tailles_fenetre[2]/3 - 75, $Tailles_fenetre[3] - 69, 100)
$Ouvrir_dossier = GUICtrlCreateButton("Ouvrir le dossier", $Tailles_fenetre[2] - $Tailles_fenetre[2]/3 - 35, $Tailles_fenetre[3] - 69, 100)
GUICtrlSetState($Executer, $GUI_DISABLE)
GUICtrlSetState($Ouvrir_dossier, $GUI_DISABLE)

Local $Array[6][3], $Progression[UBound($Array, 1)], $Label[UBound($Array, 1)], $Download[UBound($Array, 1)], $Taille_fichier[UBound($Array, 1)], $Progression_visuelle, $Pourcentage_visuel, $Lien, $Taille_intermediaire = 0, $Action = 0
$Array[0][1] = "Stinger"
$Array[1][1] = "Spybot"
$Array[2][1] = "Dr.Web CureIt!"
$Array[3][1] = "Malwarebytes"
$Array[4][1] = "AdwCleaner"
$Array[5][1] = "Gmer"

$Array[0][2] = "http://downloadcenter.mcafee.com/products/mcafee-avert/stinger/stinger32.exe"
$Array[1][2] = ""
$Array[2][2] = "http://download.geo.drweb.com/pub/drweb/cureit/drweb-cureit.exe"
$Array[3][2] = "http://data-cdn.mbamupdates.com/v0/program/data/mbam-setup-" & _INetGetSource("http://data-cdn.mbamupdates.com/v0/program/mbam.check.program") & ".exe"
$Array[4][2] = "http://general-changelog-team.fr/fr/downloads/finish/20-outils-de-xplode/2-adwcleaner"
$Array[5][2] = "http://www2.gmer.net/gmer.exe"

$Top = 70
For $i = 0 To UBound($Array, 1) - 1
	$Array[$i][0] = GUICtrlCreateCheckbox($Array[$i][1], 10, $Top, 120)
	GUICtrlSetFont($Array, 8.5, 400, 4)
	$Progression[$i] = GUICtrlCreateProgress(130, $Top, 128)
	$Label[$i] = GUICtrlCreateLabel("", 263, $Top, 37, 21, $SS_CENTERIMAGE)
	$Top += 25
;~     ConsoleWrite('ID controle : ' & $array[$i][0] & '  Programme : ' & $array[$i][1] & @CRLF)
Next

GUISetState()
While 1
	$Action = GUIGetMsg()
	Switch $Action
		Case $GUI_EVENT_CLOSE
			ExitLoop
		Case $Boutton_selection_dossier
				$Selection_dossier = FileSelectFolder("Veuillez sélectionner l'emplacement des téléchargements :", @HomeDrive & "\")
				If @error <> 1 Then
					If StringRight($Selection_dossier, 1) <> "\" Then
						$Emplacement_des_telechargements = $Selection_dossier & "\__Programmes de sécurité__\"
					Else
						$Emplacement_des_telechargements = $Selection_dossier & "__Programmes de sécurité__\"
					EndIf
					GUICtrlSetData($Label_selection_dossier, $Emplacement_des_telechargements)
					GUICtrlSetState($Executer, $GUI_ENABLE)
				EndIf
		Case $Executer
			DirCreate($Emplacement_des_telechargements)
			GUICtrlSetState($Ouvrir_dossier, $GUI_ENABLE)
			For $i = 0 To UBound($Array, 1) - 1
				If $Action <> $Executer Then ContinueLoop
				If GUICtrlRead($Array[$i][0]) = $GUI_CHECKED Then
					ConsoleWrite('ID controle : ' & $array[$i][0] & '  Programme : ' & $array[$i][1] & '  Lien : ' & $array[$i][2] & @CRLF)
					$Nom_fonction = StringRegExpReplace($array[$i][1], "[^a-zA-Z]", "")
					If $array[$i][2] = "" Then
						Call($Nom_fonction)
						$Taille_fichier[$i] = InetGetSize($Lien)
						$Download[$i] = InetGet($Lien, $Emplacement_des_telechargements & $Nom_fonction & ".exe", 3, 1)
					Else
						$Taille_fichier[$i] = InetGetSize($array[$i][2])
						$Download[$i] = InetGet($array[$i][2], $Emplacement_des_telechargements & $Nom_fonction & ".exe", 3, 1)
					EndIf
				EndIf
			Next
		Case $Ouvrir_dossier
			ShellExecute($Emplacement_des_telechargements)
	EndSwitch
	For $i = 0 To UBound($Array, 1) - 1
		If $Download[$i] = 0 Then ContinueLoop
		Sleep(200)
		$Taille_intermediaire = InetGetInfo($Download[$i], 0)
		$Pourcentage = 100 * $Taille_intermediaire / $Taille_fichier[$i]
		GUICtrlSetData($Progression[$i], $Pourcentage)
		GUICtrlSetData($Label[$i], Round($Pourcentage, 0) & " %")
		If InetGetInfo($Download[$i], 2) Then $Download[$i] = 0
	Next
WEnd

Func Spybot()
	InetGet("http://www.safer-networking.org/updates/spybotsd.ini", @TempDir & "\spybotsd.ini", 0)
	If @error = 0 Then
		Local $Version = StringReplace(IniRead(@TempDir & "\spybotsd.ini", "-General", "Version", "NotFound"), ".", "")
		$Lien = "http://www.spybotupdates.com/files/spybotsd" & $Version & ".exe"
	EndIf
EndFunc