;============================================================================================================================================
; Essai de simulation graphique type excel avec AUtoit
; Script Autotit for creating graph like Excel (R)
;
; PinkFloyd (c) 2005  - Version 1.0 RC1 15-12-2005
;
; the_pinkfloyd (alt) hotmail.com
;
;avant utilisation vous pouvez changer le nombre de graphique ligne 20 et les coordonneesdu graphique lignes 26 à 29
;before use, you can change the number of graph line 20 and the coordonate/dimension of the graph form line 26 to 29
;
;============================================================================================================================================

#include <GUIConstants.au3>

;########################################### Declaration variable

;indique le nombre de graphique à utilisé --- exemple 3  -> graphique de 0 à 2
;change the number of number of graph     --- exemple 3  -> graph from 0 to 2
$nombre_global_graphique = 20

;creation d'un tableau pour les ID des progress barres
Dim $progress[$nombre_global_graphique]
Dim $etiquette_progress[$nombre_global_graphique]

;initialisation des valeurs globales
$initial_x = 45 	; coordonnee X du graphique 0 (la premiere barre, la plus a gauche)
$initial_y = 380	; coordonnee Y du graphique 0 (la premiere barre, la plus a gauche)
$largeur_max_graphique = 544 ;544 = largeur en pixel max du graphique global
$hauteur_max_graphique = 340 ;340 = hauteur en pixel max du graphique global

$largeur_graphique = int($largeur_max_graphique/$nombre_global_graphique) ; largeur de chaque graphique
$coefficient_pourcentage_hauteur = $hauteur_max_graphique / 100 ; hauteur en pixel max du graphique

;########################################### Fin Declaration variable



;########################################### Interface graphique

$Form1 = GUICreate("Excel Demo", 811, 450, 210, 292)
GUICtrlSetColor($Form1, 0xFFFFFF)

$combo_liste_graphique = GUICtrlCreateCombo("", 640, 48, 145, 180)
GUICtrlSetTip($combo_liste_graphique, "choisir le graphique a creer / modifier")

$liste_graphique = ""
For $boucle = 0 to $nombre_global_graphique-1
	$liste_graphique = $liste_graphique & "|" & $boucle
Next
GUICtrlSetData($combo_liste_graphique,$liste_graphique,"0")

$input_valeur = GUICtrlCreateInput("input_valeur", 640, 336, 145, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetLimit($input_valeur, 3)
GUICtrlSetData($input_valeur,int(random(0,100)))
GUICtrlSetTip($input_valeur, "Entrez la valeur du graphique >0 et <100")

$button_creer_modifier = GUICtrlCreateButton("Créer/Modifier", 672, 384, 75, 25)

$input_commentaire = GUICtrlCreateInput("input_commentaire", 640, 264, 145, 21, -1, $WS_EX_CLIENTEDGE)
GUICtrlSetData($input_commentaire,"<aucun commentaire>")
GUICtrlSetTip($input_commentaire, "Rajouter un commentaire sur le gaphique")

$group_controle 		= GUICtrlCreateGroup("Controle", 624, 15, 177, 400)
$groupe_excel_graphique = GUICtrlCreateGroup("Excel Graphique 1",  8, 15, 600, 400)


;Creation des etiquettes verticales
$espace_etiquette = Int(($initial_y - 35) / 10) ; 10 espace d'etiquettes de 0 a 100 qui commence a x=35
For $boucle = 0 to 10
  	GUICtrlCreateLabel($boucle*10 & " -", 16, ($initial_y-8) - ( $boucle*$espace_etiquette), 43, 17) ; intial_y - 8 car il y a 8 pixel entre le debut de la progress barre et le grapique
Next

;Creation des etiquettes horizontales
$espace_etiquette = Int(($largeur_max_graphique - $initial_x) / $largeur_graphique) ;
For $boucle = 0 to $nombre_global_graphique-1
  	GUICtrlCreateLabel($boucle, (25 + $largeur_graphique) + $boucle*$largeur_graphique, 390 , 20, 17) ; intial_y - 8 car il y a 8 pixel entre le debut de la progress barre et le grapique
Next


GUICtrlCreateGroup("", -99, -99, 1, 1)
GUISetState(@SW_SHOW)

;########################################### Fin Interface graphique

While 1
	$msg = GuiGetMsg()
	Select
	Case $msg = $GUI_EVENT_CLOSE
		ExitLoop
	Case $msg = $button_creer_modifier
		$numero_graphique = GUICtrlRead($combo_liste_graphique)
		$hauteur_graphique = GUICtrlRead($input_valeur)
		$commentaire = GUICtrlRead($input_commentaire)
		GUICtrlSetData($input_valeur,int(random(0,100)))
 		GUICtrlSetData($combo_liste_graphique,$liste_graphique,int(random(0,$nombre_global_graphique)))
		graphique($numero_graphique,$hauteur_graphique,$commentaire)
	EndSelect
WEnd
Exit





Func graphique ($numero_graphique,$hauteur_graphique,$commentaire)
	
	;on verifie les informations données a la fonction ($numero_graphique)
 	If ($numero_graphique > $nombre_global_graphique - 1) OR  ($numero_graphique < 0) Then
		;MsgBox features: Title=Yes, Text=Yes, Buttons=OK, Icon=Critical, Modality=Task Modal, Miscellaneous=Top-most attribute
 		MsgBox(270352,"ERREUR !","Vous essayez d'accéder à un graphique non existant." & @CRLF & @CRLF & "Graphique demandé : " & $numero_graphique & @CRLF & "Plage de graphique disponible : 0 à " & $nombre_global_graphique - 1)
		Exit
	EndIf
	
	;on verifie les informations données a la fonction ($hauteur_graphique)
	If $hauteur_graphique > 100 Then
		$hauteur_graphique = 100
	ElseIf $hauteur_graphique < 0 Then
		$hauteur_graphique = 0
	EndIf
	
	;calcul des coordonnées du graphique
	$hauteur_graphique = $hauteur_graphique*$coefficient_pourcentage_hauteur
	if $hauteur_graphique <= 1 Then
		$hauteur_graphique = 1
	EndIf
	$coordonnee_x = $initial_x + $numero_graphique*$largeur_graphique
	
	;calcul de la couleur a appliquer en fonction du pourcentage de la barre
	$pourcentage_hauteur = int( ($hauteur_graphique   * 100) / 340 )
	$pourcentage_couleur = int( ($pourcentage_hauteur * 255) / 100 )
	$couleur_rouge = $pourcentage_couleur
	$couleur_vert = 255 - $pourcentage_couleur
	$couleur_bleu = 0
	
	;on supprime le graphique pour le refaire si deja existant
	IF $progress[$numero_graphique] <> "" Then
		GUICtrlDelete($progress[$numero_graphique])
		GUICtrlDelete($etiquette_progress[$numero_graphique])
	EndIf
	
	;creation du graphique demandé
	$progress[$numero_graphique] = GUICtrlCreateProgress($coordonnee_x, $initial_y - $hauteur_graphique, $largeur_graphique, $hauteur_graphique,$PBS_SMOOTH)
	
	
	;propriete du graphique
	GUICtrlSetData($progress[$numero_graphique],100) ; on remplis la barre a 100%
	GUICtrlSetColor($progress[$numero_graphique], "0x" & hex($couleur_rouge,2) & hex($couleur_vert,2) & hex($couleur_bleu,2)) ;changement de sa couleur en fonction de la taille
	
	
	;Creation de l'etiquette de la valeur du graphique
	$etiquette_progress[$numero_graphique] = GUICtrlCreateLabel($pourcentage_hauteur,$coordonnee_x + 5,($initial_y - $hauteur_graphique)-16,20,16)

	if $commentaire = "<aucun commentaire>" OR $commentaire = "" Then
		GUICtrlSetTip($progress[$numero_graphique], $pourcentage_hauteur & "%")	;on affiche en tooltip la valeur de la barre en %
 	Else 
		GUICtrlSetTip($progress[$numero_graphique], $pourcentage_hauteur & "%" & @CRLF & $commentaire)	;on affiche en tooltip la valeur de la barre en %
	EndIf
	
EndFunc