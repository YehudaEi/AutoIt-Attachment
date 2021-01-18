; Automatisation des sauvegardes BO vers fichier BIAR
;
; JM Le Borgne :
; 09/10/2006 : cr�ation
; 02/07/2007 : corrections pour BO XI R2 SP2
; 13/07/2007 : corrections pb fermeture anticip�e

Opt ("TrayIconDebug", 1)
Opt ("MouseCoordMode", 0)

$i = 1

; Fichier BIAR de sauvegarde -------- A personnaliser --------
$FichierBIAR = "D:\BIAR\" & @YEAR & "-" & @MON & "-" & @MDAY & ".biar"

;Login CMS -------- A personnaliser --------
$Nom_CMS = "sauge"
$Login_CMS = "administrator"
$Pass_CMS = "webi"

; Fichier de log -------- A personnaliser --------
$log = FileOpen ("D:\BIAR\BIAR.log", 1)

If $log = -1 Then
    Exit (-1)
EndIf

; Chemin d'acc�s Import Wizard -------- A personnaliser --------
$importwiz = "D:\Business Objects\BusinessObjects Enterprise 11.5\win32_x86\ImportWiz.exe"

FileWriteLine ($log, "D�but de la proc�dure de sauvegarde - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)

; C'est parti !
Run ($importwiz)
While 1
; Message de bienvenue
  If WinExists ("Assistant d'importation", "Bienvenue dans l'Assistant d'importation") Then
      FileWriteLine ($log, "Fen�tre de Bienvenue apparue - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)
      ControlSend ("Assistant d'importation", "Bienvenue dans l'Assistant d'importation", "Button3", "{ENTER}")
   EndIf
  
; Source de donn�es
   If WinExists ("Assistant d'importation", "S&ource") Then
	 ; MNom CMS  
     MouseClick ("left", 200, 201)
	 MouseClick ("left", 200, 201)
      Send ($Nom_CMS)
	
	; Login
	  MouseClick ("left", 200, 234)
	  MouseClick ("left", 200, 234)
      Send ($Login_CMS)
	 
    ; Mot de passe en clair : gargl ! Il faut encrypter le script en �x�cutable !	 
	  MouseClick ("left", 200, 270)
      Send ($Pass_CMS)
	  
      ControlSend ("Assistant d'importation", "S&ource", "Button4", "{ENTER}")
   EndIf

; Destination de la sauvegarde : un fichier BIAR
   If WinExists ("Assistant d'importation", "&Destination") Then
      ControlSend ("Assistant d'importation", "&Destination", "ComboBox1", "{RIGHT}")
      ControlSend ("Assistant d'importation", "&Destination", "Edit4", $FichierBIAR)
      ControlSend ("Assistant d'importation", "&Destination", "Button10", "{ENTER}")
   EndIf

; S�lection des objets � sauvegarder : tout !
   If WinExists ("Assistant d'importation", "L'Assistant d'importation permet de s�lectionner") Then
      ControlSend ("Assistant d'importation", "L'Assistant d'importation permet de s�lectionner", "Button19", "{ENTER}")
   EndIf

; Avertissement sur les groupes de serveurs
   If WinExists ("Assistant d'importation", "Vous avez choisi d'importer des groupes de serveurs") Then
      ControlSend ("Assistant d'importation", "Vous avez choisi d'importer des groupes de serveurs", "Button32", "{ENTER}")
   EndIf

; S�lection des utilisateurs et groupes : tout !
   If WinExists ("Assistant d'importation", "&Afficher les groupes de fa�on hi�rarchique") Then
      ControlSend ("Assistant d'importation", "&Afficher les groupes de fa�on hi�rarchique", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "&Afficher les groupes de fa�on hi�rarchique", "Button35", "{ENTER}")
   EndIf

; S�lection des cat�gories : tout !
   If WinExists ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux cat�gories") Then
      ControlSend ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux cat�gories", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux cat�gories", "Button51", "{ENTER}")
   EndIf

; S�lection des objets et dossiers : tout !
   If WinExists ("Assistant d'importation", "Importer toutes les &instances de chaque rapport") Then
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button6", "!i")
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button54", "{ENTER}")
   EndIf

; S�lection des objets et dossiers, �tape 2 : tout !
   If WinExists ("Assistant d'importation", "Assistant d'importation") Then
      ControlSend ("Assistant d'importation", "Assistant d'importation", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "Assistant d'importation", "Button66", "{ENTER}")
   EndIf

; S�lection des univers et connexions : tout !
   If WinExists ("Assistant d'importation", "S�lectionnez une option d'importation pour les objets d'univers") Then
      ControlSend ("Assistant d'importation", "S�lectionnez une option d'importation pour les objets d'univers", "Button1", "{+}")
      ControlSend ("Assistant d'importation", "S�lectionnez une option d'importation pour les objets d'univers", "Button61", "{ENTER}")
   EndIf

; S�lection des objets du r�f�rentiel : tout !
   If WinExists ("Assistant d'importation", "S�lectionnez une option d'importation pour les objets du r�f�rentiel") Then
      ControlSend ("Assistant d'importation", "S�lectionnez une option d'importation pour les objets du r�f�rentiel", "Button70", "{ENTER}")
; Rien ne permet d'identifier de fa�on unique la fen�tre ci-dessous : elle arrive apr�s la pr�c�dente...
      If WinWait ("Assistant d'importation", "Assistant d'importation", 60) Then
         ControlSend ("Assistant d'importation", "Assistant d'importation", "Button70", "{ENTER}")
      EndIf
  EndIf
  
; Si le script en vient � vouloir fermer l'assitant, c'est bien s�r refus�...
   If WinExists ("", "&Oui") Then
		FileWriteLine ($log, "On veut fermer ! - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)
		Send ("{TAB}") ; Pour se positionner sur le bouton NON
		ControlSend ("", "&Oui", "Button2", "{ENTER}")
   EndIf

; Importation r�elle
   If WinExists ("Assistant d'importation", "Pr�t pour l'importation") Then
      Do
         Sleep (1000)
      Until ControlCommand ("Assistant d'importation", "Pr�t pour l'importation", "Button74", "IsEnabled", "") <> 0
      ControlSend ("Assistant d'importation", "Pr�t pour l'importation", "Button74", "{ENTER}")
   EndIf

   If WinExists ("Progression de l'importation", "Progression de l'importation :") Then
      Do
         Sleep (1000)
      Until ControlCommand ("Progression de l'importation", "Progression de l'importation :", "Button1", "IsEnabled", "") <> 0
      ControlSend ("Progression de l'importation", "Progression de l'importation :", "Button2", "{ENTER}")
		$retour = "Fin de la t�che correct"
      ExitLoop
   EndIf
; Le script s'arr�te au bout de 7200 x 2 s, soit quatre heures
   $i = $i + 1
   Sleep (2000)
   if $i > 7200 Then
		ProcessClose ("importwiz.exe")
		$retour = "La t�che a dur� plus de quatre heures : arr�t automatique."
		ExitLoop
	EndIf
Wend

FileWriteLine ($log, $retour)
FileWriteLine ($log, "Fin - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)

FileClose ($log)
Exit ($retour)