;;;;;;;;;;;;;FIND_BY_MAC;;;;;;;;;;;;;
;PERMET DE RECUPERER l'ADRESSE IP et l'adresse mac de tout périphérique en réseau local.
;Ping sur une plage d'adresse défini dans le fichier configuration.ini
;et récupération des information de filtrage via un bout de l'adresse mac ou l'adresse mac entière
;le filtrage par adresse ip n'est pas encore activé... et je ne sais pas si il le sera.
;fell free to improve it ;)


;Auteur: Antoine DUBOIS
;email: ant.dubois@gmail.com
;Logiciel Open Source
;toute modification doit comporter le nom de l'auteur original
;revente non autorisé
;tout travaux dérivés doit être redistribué sous même license


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;INCLUDE;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
#include <Process.au3>



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;VARIABLE;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Local $PID[10] = ["","","","","","","","","",""]
$liste_mac = @ScriptDir&"\liste_mac.txt"
$temp      = @ScriptDir&"\temp.txt"


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;LECTURE DU FICHIER DE CONFIGURATION;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

$config_file = FileOpen(@scriptdir&"\configuration.ini",0)
if $config_file == -1 Then
	MsgBox(0,"Erreur","impossible d'ouvrir le fichier"&chr(10)&$config_file)
EndIf

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;LECTURE DES PARAMETRES;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
While 1 == 1	
	;Récuperation des infos contenu dans le fichier configuration .ini
	$config_line = FileReadLine($config_file)
	If @error == -1 Then
		ExitLoop
	EndIf
	$config_array = StringSplit($config_line,":")
	if $config_array[1] == "start" Then
		$ip_start = $config_array[2]
	ElseIf $config_array[1] == "stop" Then
		$ip_stop = $config_array[2]
	ElseIf $config_array[1] == "ip_filter" Then
		$ip_filter = $config_array[2]
		if $ip_filter == "" Then
			$ip_filter = "."
		EndIf
	ElseIf $config_array[1] == "mac_filter" Then
		$mac_filter = $config_array[2]
		if $mac_filter == "" Then
			$mac_filter = "-"
		EndIf
	EndIf
WEnd

;;$ip_start_array[4] contient le dernier numero de l'ip de départ, nous allons l'incrémenté jusqu'à ce qu'il soit égale à $ip_stop_array[4] 
$ip_start_array = StringSplit($ip_start,".")
$ip_stop_array  = StringSplit($ip_stop,".")
$ip             = $ip_start_array[1]&"."&$ip_start_array[2]&"."&$ip_start_array[3]&"."

$PID[0]   = Run("ping -n 2 "&$ip&$ip_start_array[4])
$PID[1]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+1)
$PID[2]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+2)
$PID[3]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+3)
$PID[4]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+4)
$PID[5]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+5)
$PID[6]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+6)
$PID[7]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+7)
$PID[8]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+8)
$PID[9]   = Run("ping -n 2 "&$ip&$ip_start_array[4]+9)

$ip_start_array[4] = $ip_start_array[4] + 9

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;BOUCLE PINGUANT LE PLAGE D'ADRESSE;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

While $ip_start_array[4] <= $ip_stop_array[4]
	For $i = 0 To 9 Step 1
		If ProcessExists($PID[$i]) == 0 and $ip_start_array[4] <= $ip_stop_array[4] Then
			$PID[$i] = Run("ping -n 2 "&$ip&$ip_start_array[4])
			$ip_start_array[4] = $ip_start_array[4] + 1
		EndIf
	Next
WEnd
MsgBox(0,"","si toute les fenetre ping sont fermèes cliquez OK, sinon patientez",15)
$arp_cmd = 'arp -a >> "'&$temp&'"'
_RunDOS($arp_cmd)

;fichier temp.txt contient le resultat de la commande arp -a qui affiche le contenue du cache de résolution d'adresse mac Local
$temp_file = FileOpen($temp,0)

$liste_mac_file = FileOpen($liste_mac,2)
if $liste_mac_file == -1 Then
	MsgBox(0,"Erreur","impossible d'ouvrir le fichier"&chr(10)&$liste_mac_file)
EndIf


;;Parcours du fichier temp.txt, si une ligne contient un bout du filtre mac, alors il est traiter pour être présenter
;sous la forme XXX.XXX.XXX.XXX;XX-XX-XX-XX-XX-XX
While 1
	$line = FileReadLine($temp_file)
	If @error == -1 Then
		ExitLoop
	EndIf
	
	If StringInStr($line,$mac_filter) Then
;;;TRAITEMENT DE LA LIGNE POUR ENLEVER LES ESPACES ET NE PRENDRE QUE L'IP et L'ADRESSE MAC		
		$line = StringStripWS($line,4)
		$line = StringTrimLeft ($line,1)
		$line_array = StringSplit($line," ")
		$line = $line_array[1]&";"&$line_array[2]
		FileWriteLine($liste_mac_file,$line)
	EndIf
WEnd
FileClose($temp_file)
FileClose($liste_mac_file)

_RunDOS("del /F "&$temp)
