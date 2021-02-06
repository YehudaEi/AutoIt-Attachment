#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <AntiAlias.au3>
;CONVENTIONNEL
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

Opt('MustDeclareVars', 1)


Global $GUI, $nombre, $start, $style, $graphics, $backbuffer, $bitmap, $nMsg
Global $axe_x_1, $axe_y_1, $axe_x_2, $axe_y_2, $releve_axe_y, $valeurs_axe_y
Global $GUI_GRAPH

_GUI()
_LANCER()
_Main()

Func _GUI()

; Initialisation du GDI+ et du GUI Virtuel
$GUI_GRAPH = GUICreate("GUI Graph", 280, 150)

GUISetState(@SW_SHOW)

EndFunc

Func _MAIN()
	
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd
EndFunc

Func _LANCER()

; =======================================================================================

_GDIPlus_Startup ()

;Création de la matrice graphique
$graphics = _GDIPlus_GraphicsCreateFromHWND($GUI_GRAPH)

;Conversion de la matrice sous forme de Bitmap (Toujours en mémoire)
$bitmap = _GDIPlus_BitmapCreateFromGraphics(280, 150, $graphics)

;Création du buffer de création des lignes de graph
$backbuffer = _GDIPlus_ImageGetGraphicsContext($bitmap)
_AntiAlias($backbuffer, 2)

; ==================== Realisation du graphique ====================

;Initialisation des variables
$axe_x_1 = 20
$axe_y_1 = 0
$releve_axe_y = 0

;Parametre de création
$style = _GDIPlus_PenCreate ()

;Création du repère (Start X/Y ; End X/Y)
_GDIPlus_GraphicsDrawLine ($backbuffer, 20, 20, 20, 130, $style)
_GDIPlus_GraphicsDrawLine ($backbuffer, 20, 130, 270, 130, $style)

;Chargement des valeurs
$valeurs_axe_y = IniReadSection ("data_graph.ini", "Relevés")
If @error Then MsgBox(64, "Erreur de chargement des données du graphique !", "Attention, les données du graphique n'ont pas été correctement chargées!")

;MAJ Positions sur -Y
Do
	_PLACEMENT()
Until $releve_axe_y = 24

; ========================== Finalisation ===========================

; !!!!!!! SAUVEGARDE EN FICHIER IMAGE !!!!!!!
_GDIPlus_ImageSaveToFile ($bitmap, @MyDocumentsDir & "\TEST_GRAPH.bmp")

;Affichage de l'image chargé en variable sur GUI de base (Position X/Y) = OK
_GDIPlus_GraphicsDrawImageRect($graphics,$bitmap,0,0,280,150)

;Nettoyage de la variable = OK
_GDIPlus_BitmapDispose($bitmap)

; Arrêt de la librairie GDI+
_GDIPlus_ShutDown ()

; =======================================================================================
EndFunc

Func _PLACEMENT()
	;Calcul X/Y Depart
	If $releve_axe_y = 0 Then
		$releve_axe_y += 1
		$axe_x_1 += 10
		$axe_y_1 = 130 - $valeurs_axe_y[""& $releve_axe_y &""][1]
	Else
		$releve_axe_y += 1
		$axe_x_1 = $axe_x_2
		$axe_y_1 = $axe_y_2
	EndIf

	;Calcul X/Y Final
	$axe_x_2 = $axe_x_1 + 10
	$axe_y_2 = 130 - $valeurs_axe_y[""& $releve_axe_y &""][1]

	;Création du repère (Start X/Y ; End X/Y)
	_GDIPlus_GraphicsDrawLine ($backbuffer, $axe_x_1, $axe_y_1, $axe_x_2, $axe_y_2, $style)

EndFunc