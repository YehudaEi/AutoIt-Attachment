; =======================================================================
; Nom du script : 	AutoUpdateIt							- Officiel
; Auteur : 			Rob Saunders							- Officiel
; Modification :	Jean-Pierre Mesnage						- Officiel
; Option de ligne de commande :
;  	- AutoUpdateIt.au3 [/release | /beta | /alpha] [/silent]
;    	- /release   Téléchargement de la dernière mise à jour
;    	- /beta      Téléchargement de la dernière test
;		- /alpha	 Téléchargement de la dernière version Alpha (brouillon)
;    	- /silent    Installation automatisée silencieuse (Remise à zéro de tous les paramètres)
;
; Francisation : 	Xavier BRUSSELAERS								- Non-officiel - 07/2005
; License : 		License Globale Publique (GPL)					- Non-officiel - 07/2005
; Version : 		1.3.002.rc1 FR								- Non-officiel - 07/2005
; Plateforme : 		W2K / WXP										- Non-officiel - 07/2005
; 
; Historique :
;  - 1.3.002.rc1	- Intégration de la v1.34 & v1.35																			- Non-officiel - 08/2005
;					- Francisation des ajouts de la v1.34 & v1.35
;					- Modification de la GUI About
;  - 1.35			- Correction de quelques bugs																				- Officiel	   - 08/2005
;  - 1.34			- Affichage des versions Alpha si disponible																- Officiel 	   - 08/2005
;					- Ajout du paramètre des lignes de commande /alpha
;  - 1.3.001.beta1 	- Correction des différentes remarques																		- Non-officiel - 07/2005
;  - 1.3.202.alpha  - Infobulles																								- Non-officiel - 07/2005
;  					- Colorisation différentes																
; 					- Notification de la version dans la version publique									
; 					- Changement des clés d'accès															
; 					- Changement du format de date															
; 					- Changement du design
;  - 1.3.201.alpha  - Francisation non officielle de l'interface																- Non-officiel - 07/2005
;					- Remplacement du Sheme Numbering														
;  - 1.33 	- Dernière version officiel
; 			- Ajout Abandons / Rééssayer ; boite de dialogue lorsqu'il est impossible de recevoir le fichier de mise à jour		- Officiel	
;         	- Ajout d'une barre de progression pour les utilisateur ne disposant pas de Windows XP								
;
; Topics du forum : - http://www.autoitscript.com/forum/index.php?showtopic=7547&view=getnewpost								- Officiel
;
; =======================================================================


#NoTrayIcon
#Include <GUIConstants.au3>

; ========================================
; Predefine variables
; ========================================
Global Const $s_Title = 'AutoUpdateIt'
Global Const $s_Version = '1.3.002.rc1 (v1.35)'
Global Const $s_DatFile = 'http://www.autoitscript.com/autoit3/files/beta/update.dat'
Global Const $s_DatFile_Local = @TempDir & '\au3_update.dat'
Global Const $s_Au3UpReg = 'HKCU\Software\AutoIt v3\AutoUpdateIt'

Global $i_DownSize, $s_DownPath, $s_DownTemp, $s_DownFolder
Global $i_DatFileLoaded, $i_ValidAu3Path, $i_DnInitiated
Global $s_AutoUpdate, $i_SilentInstall

Dim $s_ReleaseVer, $s_ReleaseFile, $i_ReleaseSize, $i_ReleaseDate, $s_ReleasePage
Dim $s_BetaVer, $s_BetaFile, $i_BetaSize, $i_BetaDate, $s_BetaPage
Dim $s_AlphaVer, $s_AlphaFile, $i_AlphaSize, $i_AlphaDate, $s_AlphaPage

; ========================================
; Read registry settings
; ========================================
Global $s_DefDownDir = RegRead($s_Au3UpReg, 'DownloadDir')
If @error Then
	$s_DefDownDir = @DesktopDir
EndIf

Global $s_Au3Path = RegRead('HKLM\Software\AutoIt v3\AutoIt', 'InstallDir')
If Not @error And FileExists($s_Au3Path & '\AutoIt3.exe') Then
	$s_CurrVer = FileGetVersion($s_Au3Path & "\AutoIt3.exe")
	$s_CurrDate = _FriendlyDate(FileGetTime($s_Au3Path & "\AutoIt3.exe", 0, 1))
Else
	$s_Au3Path = 'Installation non trouvée'
	$s_CurrVer = 'Indisponible'
EndIf

; ========================================
; Check for command line parameters
; ========================================
If _StringInArray($CmdLine, '/release') Or _StringInArray($CmdLine, '/beta') Or _StringInArray($CmdLine, '/alpha') Then
	Opt('TrayIconHide', 0)
	_Status('Recherche des mises à jour')
	InetGet($s_DatFile, $s_DatFile_Local, 1)
	If @InetGetBytesRead = -1 Then
		_Status('Pas de connection au site', 'Veuillez regarder votre connection et rééssayer.')
		Sleep(4000)
		Exit
	EndIf
	_LoadUpdateData()
	
	If _StringInArray($CmdLine, '/release') And _CompareVersions($s_ReleaseVer, $s_CurrVer) Then
		$s_AutoUpdate = $s_ReleaseFile
		; Modification par Xavier Brusselaers
		$s_DownTemp = @TempDir & '\autoit-v' & $s_ReleaseVer & '.exe'
		; $s_DownTemp = @TempDir & '\autoit-v3-setup.exe'
		$i_DownSize = $i_ReleaseSize
	ElseIf _StringInArray($CmdLine, '/beta') And _CompareVersions($s_BetaVer, $s_CurrVer) Then
		$s_AutoUpdate = $s_BetaFile
		$s_DownTemp = @TempDir & '\autoit-v' & $s_BetaVer & '.exe'
		$i_DownSize = $i_BetaSize
	ElseIf _StringInArray($CmdLine, '/alpha') And _CompareVersions($s_AlphaVer, $s_CurrVer) Then
		$s_AutoUpdate = $s_AlphaFile
		$s_DownTemp = @TempDir & '\autoit-v' & $s_AlphaVer & '.exe'
		$i_DownSize = $i_AlphaSize
	EndIf

	If $s_AutoUpdate Then
		InetGet($s_AutoUpdate, $s_DownTemp, 1, 1)
		$s_DownSize = Round($i_ReleaseSize / 1024) & ' KB'
		While @InetGetActive
			_Status('Téléchargement mise à jour', '', @InetGetBytesRead, $i_DownSize)
		WEnd
		_Status('Téléchargement terminé !', 'Lancement installation')
		Sleep(1000)
		If _StringInArray($CmdLine, '/silent') Then
			_Start('"' & $s_DownTemp & '" /S')
		Else
			_Start('"' & $s_DownTemp & '"')
		EndIf
	Else
		_Status('Pas de nouvelles versions')
		Sleep(1000)
	EndIf
	Exit
EndIf

; ========================================
; GUI - Main Application
; ========================================
Opt("GuiResizeMode", $GUI_DOCKALL)
$gui_Main = GuiCreate($s_Title, 350, 310+20)

$me_Mn_Help = GuiCtrlCreateMenu('&Aide')
$me_Mn_VisitSite = GuiCtrlCreateMenuItem('&Visitez le site AutoIt v3', $me_Mn_Help)
$me_Mn_About = GuiCtrlCreateMenuItem('A &propos', $me_Mn_Help)	

GuiCtrlCreateGroup('Détails de votre installation', 5, 5, 340, 75, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
GuiCtrlCreateLabel('Version: ' & $s_CurrVer, 15, 25, 300, 15)
GuiCtrlCreateLabel('Date: ' & $s_CurrDate, 15, 40, 300, 15)
GuiCtrlCreateLabel('Répertoire installation: ' & $s_Au3Path, 15, 55, 300, 15)

$gr_Mn_Release = GuiCtrlCreateGroup('Dernière version stable', 5, 85, 165, 60, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
$lb_Mn_ReleaseVer = GuiCtrlCreateLabel('Version: Chargement...', 15, 105, 145, 15)
$lb_Mn_ReleaseDate = GuiCtrlCreateLabel('Date: Chargement...', 15, 120, 145, 15)

$gr_Mn_Beta = GuiCtrlCreateGroup('Dernière version test', 180, 85, 165, 60, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
$lb_Mn_BetaVer = GuiCtrlCreateLabel('Version: Chargement...', 190, 105, 145, 15)
$lb_Mn_BetaDate = GuiCtrlCreateLabel('Date: Chargement...', 190, 120, 145, 15)

$gr_Mn_Alpha = GuiCtrlCreateGroup('Dernière version Alpha', 180+175, 85, 165, 60)
$lb_Mn_AlphaVer = GuiCtrlCreateLabel('Version: Chargement...', 190+175, 105, 145, 15)
$lb_Mn_AlphaDate = GuiCtrlCreateLabel('Date: Chargement...', 190+175, 120, 145, 15)

GUIStartGroup() 
$ra_Mn_DoneNotify = GuiCtrlCreateRadio('&Informer lorsque le téléchargement est terminé', 5, 155, 340, 15, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, -1, "Verdana")
	GUICtrlSetTip(-1, "Un message vous informera lorsque le téléchargement sera terminé")
$ra_Mn_DoneRun = GuiCtrlCreateRadio('Lancer installation après téléchargement', 5, 175, 340, 15, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, -1, "Verdana")
	GUICtrlSetTip(-1, "Après téléchargement, l'installeur de mise à jour sera lancé automatiquement")

; Check default done option
If RegRead($s_Au3UpReg, 'DoneOption') = 'Run' Then
	GuiCtrlSetState($ra_Mn_DoneRun, $GUI_CHECKED)
Else
	GuiCtrlSetState($ra_Mn_DoneNotify, $GUI_CHECKED)
EndIf

	$bt_Mn_Close = GuiCtrlCreateButton('&Fermer', 5, 265, 340, 25, $BS_FLAT)
		GUICtrlSetFont(-1, 8, -1, "Tahoma")
		GUICtrlSetTip(-1, "Quitter l'application de mise à jour")

; ========================================
; Control Set - Download Buttons
; ========================================
	
$bt_Mn_ReleaseDl = GuiCtrlCreateButton('Télécharger version &stable', 5, 195, 165, 25, $BS_FLAT)
	GuiCtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
	GUICtrlSetTip(-1, "Télécharger la dernière version stable de AutoIt.")
$lb_Mn_ReleaseSize = GuiCtrlCreateLabel('Taille: Chargement...', 5, 225, 165, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 8, -1, -1, "Verdana")
$lb_Mn_ReleasePage = GuiCtrlCreateLabel('Page de téléchargement', 5, 240, 165, 15, $SS_CENTER)
	GuiCtrlSetState(-1, $GUI_DISABLE)
	GuiCtrlSetFont(-1, 8, 400, 4, "Verdana")
	GuiCtrlSetColor(-1, 0x0000ff)
	GuiCtrlSetCursor(-1, 0)

$bt_Mn_BetaDl = GuiCtrlCreateButton('Télécharger version &test', 180, 195, 165, 25, $BS_FLAT)
	GuiCtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
	GUICtrlSetTip(-1, "Télécharger la dernière version test de AutoIt. Certaines instabilités sont possible.")
$lb_Mn_BetaSize = GuiCtrlCreateLabel('Taille: Chargement...', 180, 225, 165, 15, $SS_CENTER)
	GUICtrlSetFont(-1, 8, -1, -1, "Verdana")
$lb_Mn_BetaPage = GuiCtrlCreateLabel('Page de téléchargement', 180, 240, 165, 15, $SS_CENTER)
	GuiCtrlSetState(-1, $GUI_DISABLE)
	GuiCtrlSetFont(-1, 8, 400, 4, "Verdana")
	GuiCtrlSetColor(-1, 0x0000ff)
	GuiCtrlSetCursor(-1, 0)

$bt_Mn_AlphaDl = GuiCtrlCreateButton('Télécharger version &Alpha', 180+175, 195, 165, 30)
	GuiCtrlSetState(-1, $GUI_DISABLE)
$lb_Mn_AlphaSize = GuiCtrlCreateLabel('Taille: Chargement...', 180+175, 230, 165, 15, $SS_CENTER)
$lb_Mn_AlphaPage = GuiCtrlCreateLabel('Page de téléchargement', 180+175, 245, 165, 15, $SS_CENTER)
	GuiCtrlSetState(-1, $GUI_DISABLE)
	GuiCtrlSetFont(-1, 8, 400, 4, "Verdana")
	GuiCtrlSetColor(-1, 0x0000ff)
	GuiCtrlSetCursor(-1, 0)

$a_DownButtons = StringSplit($bt_Mn_ReleaseDl & '.' &_
                             $lb_Mn_ReleaseSize & '.' &_
                             $lb_Mn_ReleasePage & '.' &_
                             $bt_Mn_BetaDl & '.' &_
                             $lb_Mn_BetaSize & '.' &_
                             $lb_Mn_BetaPage & '.' &_
                             $bt_Mn_AlphaDl & '.' &_
                             $lb_Mn_AlphaSize & '.' &_
                             $lb_Mn_AlphaPage, '.')

; ========================================
; Control Set - Download Display
; ========================================
$lb_Mn_DwnToTtl = GuiCtrlCreateLabel('Télécharger dans:', 5, 195, 290, 15, $SS_LEFTNOWORDWRAP)
$lb_Mn_DwnToTxt = GuiCtrlCreateLabel('', 5, 210, 290, 15, $SS_LEFTNOWORDWRAP)

$pg_Mn_Progress = GuiCtrlCreateProgress(5, 225, 340, 20)
$lb_Mn_Progress = GuiCtrlCreateLabel('', 5, 250, 290, 15)

$bt_Mn_OpenFile = GuiCtrlCreateButton('&Ouvrir', 105, 275, 75, 25, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
	GuiCtrlSetState(-1, $GUI_DISABLE)
$bt_Mn_OpenFolder = GuiCtrlCreateButton('&Répertoire', 185, 275, 75, 25, $BS_FLAT)
	GUICtrlSetFont(-1, 8, -1, "Tahoma")
	GuiCtrlSetState(-1, $GUI_DISABLE)

$a_DownDisplay = StringSplit($lb_Mn_DwnToTtl & '.' &_
                             $lb_Mn_DwnToTxt & '.' &_
                             $pg_Mn_Progress & '.' &_
                             $lb_Mn_Progress & '.' &_
                             $bt_Mn_OpenFile & '.' &_
                             $bt_Mn_OpenFolder, '.')

_GuiCtrlGroupSetState($a_DownDisplay, $GUI_HIDE)

; ========================================
; GUI - About
; ========================================
$gui_About = GuiCreate('A propos', 300, 140, -1, -1, $WS_POPUPWINDOW, $WS_EX_DLGMODALFRAME, $gui_Main)
GUICtrlCreateLabel($s_Title & ' v' & $s_Version & @LF & 'Utilitaire de mise à jour AutoIt v3' & @LF, 5, 5, 290, 25, $SS_CENTER)
	GUICtrlSetBkColor(-1, 0xff0000)
	GUICtrlSetFont(-1, 8, 600, -1, "Tahoma")
	GUICtrlSetColor(-1, 0xffffff)
GuiCtrlCreateLabel('Utilitaire de mise à jour AutoIt v3. Télécharge les mise à jour de AutoIt v3  ' &_
                   'et permet leur installation automatisée. ' & @LF & 'Ecrit par Rob Saunders.' & @LF & 'Traduction par Xavier Brusselaers', 5, 35, 290, 75)
	GUICtrlSetFont(-1, 8, -1, -1, "Verdana")
$lb_Ab_VisitSite = GuiCtrlCreateLabel('Visitez le site AutoIt v3', 5, 105, 145, 15)
	GuiCtrlSetFont(-1, 8, 400, 4, "Verdana")
	GuiCtrlSetColor(-1, 0x0000ff)
	GuiCtrlSetCursor(-1, 0)
	GuiCtrlSetTip(-1, 'http://www.autoitscript.com')

$lb_Ab_ContactAuthor = GuiCtrlCreateLabel('Contactez Rob Saunders', 5, 120, 145, 15)
	GuiCtrlSetFont(-1, 8, 400, 4, "Verdana")
	GuiCtrlSetColor(-1, 0x0000ff)
	GuiCtrlSetCursor(-1, 0)
	GuiCtrlSetTip(-1, 'rksaunders@gmail.com')

$bt_Ab_Close = GuiCtrlCreateButton('&Fermer', 220, 110, 75, 25, $BS_FLAT)
	GUICtrlSetTip(-1, "Quitter la fenêtre A propos")
	GUICtrlSetFont(-1, 8, -1, "Tahoma")

; ========================================
; Application start
; ========================================

; Show Main Window
GuiSetState(@SW_SHOW, $gui_Main)

; Download update data file
InetGet($s_DatFile, $s_DatFile_Local, 1, 1)

; Harness GUI Events
While 1
	$a_GMsg = GUIGetMsg(1)

	If Not @InetGetActive And Not $i_DatFileLoaded Then
		If @InetGetBytesRead = -1 Then
			$i_Res = MsgBox(5+16+8192, 'Erreur', 'Erreur de connection au serveur.' & @LF &_
			                                    'Vérifier les points suivants:' & @LF &_
			                                    ' - Vous avez accès à Internet' & @LF &_
			                                    ' - Vous pouvez accéder au site                            ' & @LF &_
			                                    ' - Votre firewall ne bloque pas cet utilitaire')
			If $i_Res = 4 Then
				InetGet($s_DatFile, $s_DatFile_Local, 1, 1)
			Else
				Exit
			EndIf
		Else
			_LoadUpdateData()
			If $s_AlphaVer <> '' Then
				 if _CompareVersions(StringTrimRight($s_AlphaVer,1), $s_BetaVer)>0 Then
					$pos=WinGetPos($s_Title)
					WinMove($s_Title,"",$pos[0],$pos[1],$pos[2]+175,$pos[3])
					GUICtrlSetPos($gr_Instal_Details, 5, 5, 340+175, 75)
	
					GUICtrlSetPos($bt_Mn_Close, 10, 275, 330+175, 25)
					GUICtrlSetPos($lb_Mn_DwnToTtl, 5, 195, 290+175, 15)
					GUICtrlSetPos($lb_Mn_DwnToTxt, 5, 210, 290+175, 15)
					GUICtrlSetPos($pg_Mn_Progress, 5, 225, 340+175, 20)
					GUICtrlSetPos($lb_Mn_Progress, 5, 250, 290+175, 15)
					GUICtrlSetPos($bt_Mn_OpenFile, 105+175, 275, 75, 25)
					GUICtrlSetPos($bt_Mn_OpenFolder, 185+175, 275, 75, 25)
				Else
					$s_AlphaVer=''
				EndIf
			EndIf

			$i_ReleaseSizeKB = Round($i_ReleaseSize / 1024)
			$i_BetaSizeKB = Round($i_BetaSize / 1024)
			$i_AlphaSizeKB = Round($i_AlphaSize / 1024)

			If _CompareVersions($s_ReleaseVer, $s_CurrVer) Then
				GuiCtrlSetData($gr_Mn_Release, 'Dernière version publique *New*')
				GuiCtrlSetColor($gr_Mn_Release, 0x00bd00) 
			EndIf
			GuiCtrlSetData($lb_Mn_ReleaseVer, 'Version: ' & $s_ReleaseVer)
			
			If _CompareVersions($s_BetaVer, $s_CurrVer) Then
				GuiCtrlSetData($gr_Mn_Beta, 'Dernière version test *New*')
				GuiCtrlSetColor($gr_Mn_Beta, 0xcc0000)
			EndIf
			GuiCtrlSetData($lb_Mn_BetaVer, 'Version: ' & $s_BetaVer)
			
			If _CompareVersions($s_AlphaVer, $s_CurrVer) Then
				GuiCtrlSetData($gr_Mn_Alpha, 'Dernière version Alpha *New*')
				GuiCtrlSetColor($gr_Mn_Alpha, 0xcc0000	)
			EndIf
			GuiCtrlSetData($lb_Mn_AlphaVer, 'Version: ' & $s_AlphaVer)

			GuiCtrlSetData($lb_Mn_ReleaseDate, 'Date: ' & _FriendlyDate($i_ReleaseDate))
			GuiCtrlSetData($lb_Mn_BetaDate, 'Date: ' & _FriendlyDate($i_BetaDate))
			GuiCtrlSetData($lb_Mn_AlphaDate, 'Date: ' & _FriendlyDate($i_AlphaDate))

			GuiCtrlSetData($lb_Mn_ReleaseSize, 'Taille: ' & $i_ReleaseSizeKB & ' KB')
			GuiCtrlSetData($lb_Mn_BetaSize, 'Taille: ' & $i_BetaSizeKB & ' KB')
			GuiCtrlSetData($lb_Mn_AlphaSize, 'Taille: ' & $i_AlphaSizeKB & ' KB')

			GuiCtrlSetTip($lb_Mn_ReleasePage, $s_ReleasePage)
			GuiCtrlSetTip($lb_Mn_BetaPage, $s_BetaPage)
			GuiCtrlSetTip($lb_Mn_AlphaPage, $s_AlphaPage)
			
			GuiCtrlSetState($bt_Mn_ReleaseDl, $GUI_ENABLE)
			GuiCtrlSetState($bt_Mn_BetaDl, $GUI_ENABLE)
			GuiCtrlSetState($bt_Mn_AlphaDl, $GUI_ENABLE)
			GuiCtrlSetState($lb_Mn_ReleasePage, $GUI_ENABLE)
			GuiCtrlSetState($lb_Mn_BetaPage, $GUI_ENABLE)
			GuiCtrlSetState($lb_Mn_AlphaPage, $GUI_ENABLE)

			$i_DatFileLoaded = 1
		EndIf
	EndIf

	If $i_DnInitiated Then
		If @InetGetActive Then
			$i_DnPercent = Int(@InetGetBytesRead / $i_DownSize * 100)

			$s_DnBytes = Round(@InetGetBytesRead / 1024) & ' KB'
			$s_DnSize = Round($i_DownSize / 1024) & ' KB'
				
			GuiCtrlSetData($pg_Mn_Progress, $i_DnPercent)
			GuiCtrlSetData($lb_Mn_Progress, 'Progression téléchargement: ' & $i_DnPercent & '% (' & $s_DnBytes & ' sur ' & $s_DnSize & ')')
		Else
			GuiCtrlSetData($pg_Mn_Progress, 100)
			If Not FileMove($s_DownTemp, $s_DownPath, 1) Then
				MsgBox(16+8192, 'Erreur', 'Erreur déplacement fichier.')
				GuiCtrlSetData($lb_Mn_Progress, 'Erreur')
			Else
				If GuiCtrlRead($ra_Mn_DoneRun) = $GUI_CHECKED Then
					_Start('"' & $s_DownPath & '"')
					Exit
				Else
					GuiCtrlSetData($lb_Mn_Progress, 'Téléchargement terminé !')

					GuiCtrlSetData($bt_Mn_Close, '&Fermer')
					GuiCtrlSetState($bt_Mn_OpenFile, $GUI_ENABLE)
					GuiCtrlSetState($bt_Mn_OpenFolder, $GUI_ENABLE)
					$i_Response = MsgBox(4+64+256+8192, $s_Title, 'Téléchargement terminé !' & @LF &_
					                                              'Désirez vous installer le téléchargement maintenant ?')
					If $i_Response = 6 Then
						_Start('"' & $s_DownPath & '"')
						Exit
					EndIf
				EndIf
			EndIf
			
			$i_DnInitiated = 0
		EndIf
	EndIf

	If $a_GMsg[1] = $gui_Main Then
		Select
			; Radio buttons
			Case $a_GMsg[0] = $ra_Mn_DoneRun
				RegWrite($s_Au3UpReg, 'DoneOption', 'REG_SZ', 'Run')

			Case $a_GMsg[0] = $ra_Mn_DoneNotify
				RegWrite($s_Au3UpReg, 'DoneOption', 'REG_SZ', 'Notify')
			
			; Download buttons
			Case $a_GMsg[0] = $bt_Mn_ReleaseDl
				$tmp = StringInStr($s_ReleaseFile, '/', 0, -1)
				$s_DefFileName = StringTrimLeft($s_ReleaseFile, $tmp)
				$i_DownSize = $i_ReleaseSize
				; Modification par Xavier Brusselaers
				_DownloadFile($s_ReleaseFile, 'autoit-v' & $s_ReleaseVer & '.exe')
				;_DownloadFile($s_ReleaseFile, 'autoit-v3-setup.exe')

			Case $a_GMsg[0] = $bt_Mn_BetaDl
				$tmp = StringInStr($s_BetaFile, '/', 0, -1)
				$s_DefFileName = StringTrimLeft($s_BetaFile, $tmp)
				$i_DownSize = $i_BetaSize
				_DownloadFile($s_BetaFile, 'autoit-v' & $s_BetaVer & '.exe')

			Case $a_GMsg[0] = $bt_Mn_AlphaDl
				$tmp = StringInStr($s_AlphaFile, '/', 0, -1)
				$s_DefFileName = StringTrimLeft($s_AlphaFile, $tmp)
				$i_DownSize = $i_AlphaSize
				_DownloadFile($s_AlphaFile, 'autoit-v' & $s_AlphaVer & '.exe')

			; Download page "hyperlinks"
			Case $a_GMsg[0] = $lb_Mn_ReleasePage
				_Start($s_ReleasePage)
			
			Case $a_GMsg[0] = $lb_Mn_BetaPage
				_Start($s_BetaPage)
				
			Case $a_GMsg[0] = $lb_Mn_AlphaPage
				_Start($s_AlphaPage)

			; Open buttons
			Case $a_GMsg[0] = $bt_Mn_OpenFile
				_Start('"' & $s_DownPath & '"')
				Exit

			Case $a_GMsg[0] = $bt_Mn_OpenFolder
				_Start('"' & EnvGet('windir') & '\explorer.exe" /select,"' & $s_DownPath & '"')
				Exit

			; Menu items
			Case $a_GMsg[0] = $me_Mn_VisitSite
				_Start('http://www.autoitscript.com')

			Case $a_GMsg[0] = $me_Mn_About
				GuiSetState(@SW_SHOW, $gui_About)

			; Close buttons
			Case $a_GMsg[0] = $bt_Mn_Close
				_CancelDownload()
				
			Case $a_GMsg[0] = $GUI_EVENT_CLOSE
				_CancelDownload(1)
		EndSelect
	ElseIf $a_GMsg[1] = $gui_About Then
		Select
			Case $a_GMsg[0] = $lb_Ab_VisitSite
				_Start('http://www.autoitscript.com')

			Case $a_GMsg[0] = $lb_Ab_ContactAuthor
				_Start('"mailto:rksaunders@gmail.com?Subject=AutoIt3 Update Utility"')
				
			Case $a_GMsg[0] = $GUI_EVENT_CLOSE Or $a_GMsg[0] = $bt_Ab_Close
				GuiSetState(@SW_HIDE, $gui_About)
		EndSelect
	EndIf
Wend

; ========================================
; Function Declarations
; ========================================

; App. specific functions

Func _DownloadFile($s_DownUrl, $s_DownName)
	$s_DownTemp = @TempDir & '\' & $s_DownName
	InetGet($s_DownUrl, $s_DownTemp, 1, 1)

	$s_DownPath = FileSaveDialog('Enregistrer sous:', $s_DefDownDir, 'Application (*.exe)', 16, $s_DownName)
	If Not @error Then
		If Not (StringRight($s_DownPath, 4) = '.exe') Then
			$s_DownPath = $s_DownPath & '.exe'
		EndIf

		$tmp = StringInStr($s_DownPath, '\', 0, -1)
		$s_DownFolder = StringLeft($s_DownPath, $tmp)
		RegWrite($s_Au3UpReg, 'DownloadDir', 'REG_SZ', $s_DownFolder)
		
		GuiCtrlSetData($lb_Mn_DwnToTxt, _ClipPath($s_DownPath, 55))
		GuiCtrlSetData($lb_Mn_Progress, 'Progression téléchargement: Calcul...')
		
		_GuiCtrlGroupSetState($a_DownButtons, $GUI_HIDE)
		_GuiCtrlGroupSetState($a_DownButtons, $GUI_DISABLE)
		_GuiCtrlGroupSetState($a_DownDisplay, $GUI_SHOW)
		If $s_AlphaVer <> '' Then
			GuiCtrlSetPos($bt_Mn_Close, 265+175, 275, 75, 25)
		Else
			GuiCtrlSetPos($bt_Mn_Close, 265, 275, 75, 25)
		Endif
			
		GuiCtrlSetData($bt_Mn_Close, 'A&nnuler')
		
		$i_DnInitiated = 1
	Else
		InetGet('abort')
		FileDelete($s_DownTemp)
	EndIf
EndFunc

Func _CancelDownload($i_Flag = 0)
	If $i_DnInitiated Then
		$i_Response = MsgBox(4+64+256+8192, $s_Title, 'Resumé non disponible.' & @LF &_
		                                              'Votre téléchargement sera perdu.' & @LF &_
		                                              'Continuer ?')
		If $i_Response = 6 Then
			$i_DnInitiated = 0
			InetGet('abort')
			FileDelete($s_DownTemp)
			If $i_Flag = 1 Then
				Exit
			EndIf
			
			_GuiCtrlGroupSetState($a_DownDisplay, $GUI_HIDE)

			GuiCtrlSetData($bt_Mn_Close, '&Fermer')
			If $s_AlphaVer <> '' Then
				GuiCtrlSetPos($bt_Mn_Close, 10, 275, 330+175, 25)
			Else
				GuiCtrlSetPos($bt_Mn_Close, 10, 275, 330, 25)
			Endif
			GuiCtrlSetData($pg_Mn_Progress, 0)

			_GuiCtrlGroupSetState($a_DownButtons, $GUI_SHOW)
			_GuiCtrlGroupSetState($a_DownButtons, $GUI_ENABLE)
		EndIf
	Else
		Exit
	EndIf
EndFunc

Func _LoadUpdateData()
	Global $s_ReleaseVer, $s_ReleaseFile, $s_ReleasePage, $i_ReleaseSize, $i_ReleaseDate
	Global $s_BetaVer, $s_BetaFile, $s_BetaPage, $i_BetaSize, $i_BetaDate
	Global $s_AlphaVer, $s_AlphaFile, $s_AlphaPage, $i_AlphaSize, $i_AlphaDate

	$s_ReleaseVer = IniRead($s_DatFile_Local, 'AutoIt', 'version', 'Erreur lecture fichier')
	$s_ReleaseFile = IniRead($s_DatFile_Local, 'AutoIt', 'setup', '')
	$s_ReleasePage = IniRead($s_DatFile_Local, 'AutoIt', 'index', 'http://www.autoitscript.com')
	$i_ReleaseSize = IniRead($s_DatFile_Local, 'AutoIt', 'filesize', 0)
	$i_ReleaseDate = IniRead($s_DatFile_Local, 'AutoIt', 'filetime', 0)

	$s_BetaVer = IniRead($s_DatFile_Local, 'AutoItBeta', 'version', 'Erreur lecture fichier')
	$s_BetaFile = IniRead($s_DatFile_Local, 'AutoItBeta', 'setup', '')
	$s_BetaPage = IniRead($s_DatFile_Local, 'AutoItBeta', 'index', 'http://www.autoitscript.com')
	$i_BetaSize = IniRead($s_DatFile_Local, 'AutoItBeta', 'filesize', 0)
	$i_BetaDate = IniRead($s_DatFile_Local, 'AutoItBeta', 'filetime', 0)
	
	$s_AlphaVer = IniRead($s_DatFile_Local, 'AutoItAlpha', 'version', '')
	$s_AlphaFile = IniRead($s_DatFile_Local, 'AutoItAlpha', 'setup', '')
	$s_AlphaPage = IniRead($s_DatFile_Local, 'AutoItAlpha', 'index', 'http://www.autoitscript.com')
	$i_AlphaSize = IniRead($s_DatFile_Local, 'AutoItAlpha', 'filesize', 0)
	$i_AlphaDate = IniRead($s_DatFile_Local, 'AutoItAlpha', 'filetime', 0)

	FileDelete($s_DatFile_Local)
EndFunc

; Utility functions

Func _Start($s_StartPath)
	If @OSType = 'WIN32_NT' Then
		$s_StartStr = @ComSpec & ' /c start "" '
	Else
		$s_StartStr = @ComSpec & ' /c start '
	EndIf
	Run($s_StartStr & $s_StartPath, '', @SW_HIDE)
EndFunc

Func _GuiCtrlGroupSetState(ByRef $a_GroupArray, $i_State)
	For $i = 1 to $a_GroupArray[0]
		GuiCtrlSetState($a_GroupArray[$i], $i_State)
	Next
EndFunc

Func _ClipPath($s_Path, $i_ClipLen)
	Local $i_Half, $s_Left, $s_Right

	If StringLen($s_Path) > $i_ClipLen Then
		$i_Half = Int($i_ClipLen / 2)
		$s_Left = StringLeft($s_Path, $i_Half)
		$s_Right = StringRight($s_Path, $i_Half)
		$s_Path = $s_Left & '...' & $s_Right
	EndIf
	
	Return $s_Path
EndFunc

Func _NumSuffix($i_Num)
	Local $s_Num
	If StringRight($i_Num, 1) = 1 Then
		$s_Num = Int($i_Num) & ''
	ElseIf StringRight($i_Num, 1) = 2 Then
		$s_Num = Int($i_Num) & ''
	ElseIf StringRight($i_Num, 1) = 3 Then
		$s_Num = Int($i_Num) & ''
	Else
		$s_Num = Int($i_Num) & ''
	EndIf
	
	Return $s_Num
EndFunc

Func _FriendlyDate($s_Date)
	Local $a_Months = StringSplit('Janvier,Février,Mars,Avril,Mai,Juin,Juillet,Aout,Septembre,Octobre,Novembre,Decembre', ',')
	Local $s_Year, $s_Month, $s_Day
	
	$s_Year = StringLeft($s_Date, 4)
	$s_Month = StringMid($s_Date, 5, 2)
	$s_Month = $a_Months[Int(StringMid($s_Date, 5, 2))]
	$s_Day = StringMid($s_Date, 7, 2)
	$s_Day = _NumSuffix(StringMid($s_Date, 7, 2))
	; Modification faite par Xavier Brusselaers
	Return $s_Day & " " & $s_Month & " " & $s_Year
	;Return $s_Month & ' ' & $s_Day & ', ' & $s_Year
EndFunc

Func _StringInArray($a_Array, $s_String)
	Local $i_ArrayLen = UBound($a_Array) - 1

	For $i = 0 To $i_ArrayLen
		If $a_Array[$i] = $s_String Then
			Return $i
		EndIf
	Next
	SetError(1)
	Return 0
EndFunc

Func _CompareVersions($s_Vers1, $s_Vers2, $i_ReturnFlag = 0)
	If $s_Vers1 = '' Then Return 0
	Local $i, $i_Vers1, $i_Vers2, $i_Top
	Local $a_Vers1 = StringSplit($s_Vers1, '.')
	Local $a_Vers2 = StringSplit($s_Vers2, '.')

	$i_Top = $a_Vers1[0]
	If $a_Vers1[0] < $a_Vers2[0] Then
		$i_Top = $a_Vers2[0]
	EndIf
	
	For $i = 1 To $i_Top
		$i_Vers1 = 0
		$i_Vers2 = 0
		If $i <= $a_Vers1[0] Then
			$i_Vers1 = Number($a_Vers1[$i])
		EndIf
		If $i <= $a_Vers2[0] Then
			$i_Vers2 = Number($a_Vers2[$i])
		EndIf
		
		If $i_Vers1 > $i_Vers2 Then
			$v_Return = 1
			ExitLoop
		ElseIf $i_Vers1 < $i_Vers2 Then
			$v_Return = 0
			ExitLoop
		Else
			$v_Return = -1
		EndIf
	Next

	If $i_ReturnFlag Then
		Select
			Case $v_Return = -1
				SetError(1)
				Return 0
			Case $v_Return = 1
				Return $s_Vers1
			Case $v_Return = 0
				Return $s_Vers2
		EndSelect
	ElseIf $v_Return = -1 Then
		SetError(1)
		Return 0
	Else
		Return $v_Return
	EndIf
EndFunc

Func _Status($s_MainText, $s_SubText = '', $i_BytesRead = -1, $i_DownSize = -1)
	Global $i_ProgOn
	Global $i_StatusPercent
	
	If @OSVersion = "WIN_XP" Or @OSVersion = "WIN_2000" Or @OSVersion = "WIN_2003" Then
		If $s_SubText <> '' Then 
			$s_SubText = @LF & $s_SubText
		EndIf
		
		If $i_BytesRead = -1 Then
			TrayTip($s_Title, $s_MainText & $s_SubText, 10, 16)
		Else
			$s_DownStatus = Round($i_BytesRead / 1024) & ' sur ' & Round($i_DownSize / 1024) & ' KB'
			TrayTip($s_Title, $s_MainText & $s_SubText & @LF & $s_DownStatus, 10, 16)
		EndIf
	Else
		If Not $i_ProgOn Then
			ProgressOn($s_Title, $s_MainText, $s_SubText, -1, -1, 2+16)
			$i_ProgOn = 1
		Else
			If $i_BytesRead = -1 Then
				ProgressSet($i_StatusPercent, $s_SubText, $s_MainText)
			Else
				$s_DownStatus = 'Téléchargement ' & Round($i_BytesRead / 1024) & ' sur ' & Round($i_DownSize / 1024) & ' KB'
				$i_StatusPercent = Round($i_BytesRead / $i_DownSize * 100)
				ProgressSet($i_StatusPercent, $s_DownStatus, $s_MainText)
			EndIf
		EndIf
	EndIf
EndFunc
