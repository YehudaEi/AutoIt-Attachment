; Automatisation des sauvegardes BO vers fichier BIAR
;
; JM Le Borgne :
; 09/10/2006 : création
; 02/07/2007 : corrections pour BO XI R2 SP2
; 13/07/2007 : corrections pb fermeture anticipée

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

; Chemin d'accés Import Wizard -------- A personnaliser --------
$importwiz = "D:\Business Objects\BusinessObjects Enterprise 11.5\win32_x86\ImportWiz.exe"

FileWriteLine ($log, "Début de la procédure de sauvegarde - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)

; C'est parti !
Run ($importwiz)
While 1
; Message de bienvenue
  If WinExists ("Assistant d'importation", "Bienvenue dans l'Assistant d'importation") Then
      FileWriteLine ($log, "Fenêtre de Bienvenue apparue - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)
      ControlSend ("Assistant d'importation", "Bienvenue dans l'Assistant d'importation", "Button3", "{ENTER}")
   EndIf
  
; Source de données
   If WinExists ("Assistant d'importation", "S&ource") Then
	 ; MNom CMS  
     MouseClick ("left", 200, 201)
	 MouseClick ("left", 200, 201)
      Send ($Nom_CMS)
	
	; Login
	  MouseClick ("left", 200, 234)
	  MouseClick ("left", 200, 234)
      Send ($Login_CMS)
	 
    ; Mot de passe en clair : gargl ! Il faut encrypter le script en éxécutable !	 
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

; Sélection des objets à sauvegarder : tout !
   If WinExists ("Assistant d'importation", "L'Assistant d'importation permet de sélectionner") Then
      ControlSend ("Assistant d'importation", "L'Assistant d'importation permet de sélectionner", "Button19", "{ENTER}")
   EndIf

; Avertissement sur les groupes de serveurs
   If WinExists ("Assistant d'importation", "Vous avez choisi d'importer des groupes de serveurs") Then
      ControlSend ("Assistant d'importation", "Vous avez choisi d'importer des groupes de serveurs", "Button32", "{ENTER}")
   EndIf

; Sélection des utilisateurs et groupes : tout !
   If WinExists ("Assistant d'importation", "&Afficher les groupes de façon hiérarchique") Then
      ControlSend ("Assistant d'importation", "&Afficher les groupes de façon hiérarchique", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "&Afficher les groupes de façon hiérarchique", "Button35", "{ENTER}")
   EndIf

; Sélection des catégories : tout !
   If WinExists ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux catégories") Then
      ControlSend ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux catégories", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "I&mporter tous les objets qui appartiennent aux catégories", "Button51", "{ENTER}")
   EndIf

; Sélection des objets et dossiers : tout !
   If WinExists ("Assistant d'importation", "Importer toutes les &instances de chaque rapport") Then
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button6", "!i")
      ControlSend ("Assistant d'importation", "Importer toutes les &instances de chaque rapport", "Button54", "{ENTER}")
   EndIf

; Sélection des objets et dossiers, étape 2 : tout !
   If WinExists ("Assistant d'importation", "Assistant d'importation") Then
      ControlSend ("Assistant d'importation", "Assistant d'importation", "Button1", "{SPACE}")
      ControlSend ("Assistant d'importation", "Assistant d'importation", "Button66", "{ENTER}")
   EndIf

; Sélection des univers et connexions : tout !
   If WinExists ("Assistant d'importation", "Sélectionnez une option d'importation pour les objets d'univers") Then
      ControlSend ("Assistant d'importation", "Sélectionnez une option d'importation pour les objets d'univers", "Button1", "{+}")
      ControlSend ("Assistant d'importation", "Sélectionnez une option d'importation pour les objets d'univers", "Button61", "{ENTER}")
   EndIf

; Sélection des objets du référentiel : tout !
   If WinExists ("Assistant d'importation", "Sélectionnez une option d'importation pour les objets du référentiel") Then
      ControlSend ("Assistant d'importation", "Sélectionnez une option d'importation pour les objets du référentiel", "Button70", "{ENTER}")
; Rien ne permet d'identifier de façon unique la fenêtre ci-dessous : elle arrive après la précédente...
      If WinWait ("Assistant d'importation", "Assistant d'importation", 60) Then
         ControlSend ("Assistant d'importation", "Assistant d'importation", "Button70", "{ENTER}")
      EndIf
  EndIf
  
; Si le script en vient à vouloir fermer l'assitant, c'est bien sûr refusé...
   If WinExists ("", "&Oui") Then
		FileWriteLine ($log, "On veut fermer ! - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)
		Send ("{TAB}") ; Pour se positionner sur le bouton NON
		ControlSend ("", "&Oui", "Button2", "{ENTER}")
   EndIf

; Importation réelle
   If WinExists ("Assistant d'importation", "Prêt pour l'importation") Then
      Do
         Sleep (1000)
      Until ControlCommand ("Assistant d'importation", "Prêt pour l'importation", "Button74", "IsEnabled", "") <> 0
      ControlSend ("Assistant d'importation", "Prêt pour l'importation", "Button74", "{ENTER}")
   EndIf

   If WinExists ("Progression de l'importation", "Progression de l'importation :") Then
      Do
         Sleep (1000)
      Until ControlCommand ("Progression de l'importation", "Progression de l'importation :", "Button1", "IsEnabled", "") <> 0
      ControlSend ("Progression de l'importation", "Progression de l'importation :", "Button2", "{ENTER}")
		$retour = "Fin de la tâche correct"
      ExitLoop
   EndIf
; Le script s'arrête au bout de 7200 x 2 s, soit quatre heures
   $i = $i + 1
   Sleep (2000)
   if $i > 7200 Then
		ProcessClose ("importwiz.exe")
		$retour = "La tâche a duré plus de quatre heures : arrêt automatique."
		ExitLoop
	EndIf
Wend

FileWriteLine ($log, $retour)
FileWriteLine ($log, "Fin - " & @YEAR & "-" & @MON & "-" & @MDAY & " - " & @HOUR & ":" & @MIN)

FileClose ($log)
Exit ($retour)