; ----------------------------------------------------------------------------
; Policy Lister 1.07
; Author:         Louis Horvath <celeri@videotron.ca>
;
; Script Function:
;	Liste toutes les politiques présentement en fonction sur ce système
;   Quelques infos viennent d'ici:                                    
;
; Crédits: 		Fenêtre de crédits, MsCreatoR
;				_ComputerGetServices, Jarvis Stubblefield (support "at" vortexrevolutions "dot" com)
;  				ainsi que GEOSoft pour ses conseils et son fichier "Languauge.au3"
;
; Historique:
; 1.00 - Version initiale
; 1.01 - Création d'une liste de sections du registre pour les politiques système
;      - Vient de ce site: http://www.microsoft.com/technet/prodtechnol/windows2000serv/reskit/gp/gpref.mspx?mfr=true
;      - Programme devra lire (pour l'instant) depuis un fichier externe les sections.
; 1.02 - Un peu d'aide du forum, la lecture des valeurs registre c'est bin bizarre ;)
; 	   - Ça sent le roussi ... même avec les valeurs internes ça marche pô...
; 1.03 - Un peu de ménage, peut-être ...
;      - Trouver une virage de manière de faire fonctionner ...
; 1.04 - Tout baigne, reste à ficeler le paquet
;      - Revision de l'écriture de certaines sections ...
; 1.05 - Rajout des sections "Run"
; 1.06 - Affiche le résultat dans un listbox
;      - Ajout d'une ligne de commande:
;        - NoGui (pas de fenêtre après l'exécution du programme)
;        - NoLog (pas de journal après l'exécution du programme) NON FONCTIONNEL POUR L'INSTANT
;        - App (trier par appartenance à une branche) NON FONCTIONNEL POUR L'INSTANT
;        - /? (aide sur la ligne de commande)
;      - /NoGui et /NoLog s'anullent lorsqu'ensemble.
; 1.07 - Officiellement anglais/français. 
;      - Fichier réponse en mémoire plutôt que sur disque
;      - Rajout de "copier au presse-papier", "Envoi par email" et "Crédits" à l'interface.
;      - Rajout des crédits système
; 	   - Grisé l'option de courrier électronque tant qu'une solution satisfaisante n'est pas trouvée
;      - NoINI (pas de lecture des sections dans les fichiers .INI)
;      - Lecture des sections dans les fichiers .INI

; Projets:
; - Trier par appartenance
; - Changer fonctionnement - appeler fonction avec paramètres au lieu de faire for/next. Plus de code mais bien moins 
;   compliqué à gerer!!!
; - Hybride, prioriser fichier de données externe s'il existe --> PolList.ini?
; - Chercher comment marche CWS pour pouvoir l'identifier avec ce programme
; - BHO pour Firefox & al?
; - Capable de lire dans un Windows donné?
; - TROUVER D'OU VIENNENT LES VALEURS BIZARRRES DANS WIN.INI et SYSTEM.INI !!!

; ==== VARIABLES COMPILATEUR =================================================
#Compiler_Prompt=y
#Compiler_Icon=G:\Documents de Celeri\AutoIT3\Icones\Logo_DrLouis.ico
#Compiler_Compression=4
#compiler_allow_decompile=n
#Compiler_Res_Comment=                         drlouis@videotron.ca
#Compiler_Res_Description=Policy Lister
#Compiler_Res_Fileversion=1.0.7
#Compiler_Res_LegalCopyright=©2007 Louis Horvath

; ----------------------------------------------------------------------------
#NoTrayIcon ; Pas d'icone sur la barre de tâches
AutoItSetOption("GUICloseOnESC", 1)

; Constantes Windows
Global Const $WS_VSCROLL			= 0x00200000
Global Const $WS_BORDER				= 0x00800000
Global Const $GUI_EVENT_CLOSE		= -3
Global Const $GUI_DISABLE           = 128
Global Const $SS_ETCHEDFRAME		= 18

; Variables globales
Global $Ver = "Policy Lister 1.0.7"
Global $Rapport = "System_Policies.txt"
Global $Code_ERREUR = "" ; Code d'erreur final, à rendre en sortie
Global $Code_ERREUR_CLEF = "" ; Clef ou l'erreur s'est produite (si applicable)
Global $Date = @MDAY & "/" & @MON & "/" & @YEAR & " " & @HOUR & ":" & @MIN
Global $NoGui = 0 ; Interface graphique par défaut, change sur ligne de commande --> /NoGui
Global $NoLog = 0 ; Rapport créé dans le même répertoire que ce programme --> /NoLog
Global $NoServ = 0 ; Pas de services --> /NoServ
Global $NoBHO = 0 ; Pas de browser helper --> /NoBHO
Global $NoPol = 0 ; Pas de policies --> /NoPol
Global $NoRun = 0 ; Pas de run --> /NoRun
Global $NoINI = 0 ; Pas de fichiers .INI --> /NoINI
Global $Appartenance ; Trie par appartenance à un fichier plutôt que par ordre de présence dans le registre (défaut) --> /App
Global $Lang = _Langue()
If $Lang < 1 or $Lang > 2 Then $Lang = 2 ; Anglais si autre chose que français ou anglais.
;~ $lang =2 ; Debogue - Forcer l'anglais
Global $Rap = ""
Global $IE_BHO = "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Objects\"
Global $CLSID = "HKEY_CLASSES_ROOT\CLSID\"

; Clefs registre "POLicies"
Global $Reg_SECPOL[131] ; Toutes les branches à osculter
$Reg_SECPOL[001] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies"
$Reg_SECPOL[002] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
$Reg_SECPOL[003] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Comdlg32"
$Reg_SECPOL[004] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Reg_SECPOL[005] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
$Reg_SECPOL[006] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Network"
$Reg_SECPOL[007] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum"
$Reg_SECPOL[008] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$Reg_SECPOL[009] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Uninstall"
$Reg_SECPOL[010] = "HKCU\Software\Policies\Microsoft\Control Panel\Desktop"
$Reg_SECPOL[011] = "HKCU\Software\Policies\Microsoft\Control Panel\International\Calendars\TwoDigitYearMax"
$Reg_SECPOL[012] = "HKCU\Software\Policies\Microsoft\Internet Explorer\Control Panel"
$Reg_SECPOL[013] = "HKCU\Software\Policies\Microsoft\Internet Explorer\Infodelivery\Restrictions"
$Reg_SECPOL[014] = "HKCU\Software\Policies\Microsoft\Internet Explorer\Restrictions"
$Reg_SECPOL[015] = "HKCU\Software\Policies\Microsoft\Messenger\Client"
$Reg_SECPOL[016] = "HKCU\Software\Policies\Microsoft\MMC"
$Reg_SECPOL[017] = "HKCU\Software\Policies\Microsoft\MMC\{011BE22D-E453-11D1-945A-00C04FB984F9}"
$Reg_SECPOL[018] = "HKCU\Software\Policies\Microsoft\MMC\{03f1f940-a0f2-11d0-bb77-00aa00a1eab7}"
$Reg_SECPOL[019] = "HKCU\Software\Policies\Microsoft\MMC\{0F3621F1-23C6-11D1-AD97-00AA00B88E5A}"
$Reg_SECPOL[020] = "HKCU\Software\Policies\Microsoft\MMC\{0F6B957D-509E-11D1-A7CC-0000F87571E3}"
$Reg_SECPOL[021] = "HKCU\Software\Policies\Microsoft\MMC\{0F6B957E-509E-11D1-A7CC-0000F87571E3}"
$Reg_SECPOL[022] = "HKCU\Software\Policies\Microsoft\MMC\{1AA7F839-C7F5-11D0-A376-00C04FC9DA04}"
$Reg_SECPOL[023] = "HKCU\Software\Policies\Microsoft\MMC\{1AA7F83C-C7F5-11D0-A376-00C04FC9DA04}"
$Reg_SECPOL[024] = "HKCU\Software\Policies\Microsoft\MMC\{243E20B0-48ED-11D2-97DA-00A024D77700}"
$Reg_SECPOL[025] = "HKCU\Software\Policies\Microsoft\MMC\{2E19B602-48EB-11d2-83CA-00104BCA42CF}"
$Reg_SECPOL[026] = "HKCU\Software\Policies\Microsoft\MMC\{3060E8CE-7020-11D2-842D-00C04FA372D4}"
$Reg_SECPOL[027] = "HKCU\Software\Policies\Microsoft\MMC\{34AB8E82-C27E-11D1-A6C0-00C04FB94F17}"
$Reg_SECPOL[028] = "HKCU\Software\Policies\Microsoft\MMC\{394C052E-B830-11D0-9A86-00C04FD8DBF7}"
$Reg_SECPOL[029] = "HKCU\Software\Policies\Microsoft\MMC\{3CB6973D-3E6F-11D0-95DB-00A024D77700}"
$Reg_SECPOL[030] = "HKCU\Software\Policies\Microsoft\MMC\{3F276EB4-70EE-11D1-8A0F-00C04FB93753}"
$Reg_SECPOL[031] = "HKCU\Software\Policies\Microsoft\MMC\{40B6664F-4972-11D1-A7CA-0000F87571E3}"
$Reg_SECPOL[032] = "HKCU\Software\Policies\Microsoft\MMC\{40B66650-4972-11D1-A7CA-0000F87571E3}"
$Reg_SECPOL[033] = "HKCU\Software\Policies\Microsoft\MMC\{43668E21-2636-11D1-A1CE-0080C88593A5}"
$Reg_SECPOL[034] = "HKCU\Software\Policies\Microsoft\MMC\{45ac8c63-23e2-11d1-a696-00c04fd58bc3}"
$Reg_SECPOL[035] = "HKCU\Software\Policies\Microsoft\MMC\{53D6AB1D-2488-11D1-A28C-00C04FB94F17}"
$Reg_SECPOL[036] = "HKCU\Software\Policies\Microsoft\MMC\{58221C65-EA27-11CF-ADCF-00AA00A80033}"
$Reg_SECPOL[037] = "HKCU\Software\Policies\Microsoft\MMC\{58221C66-EA27-11CF-ADCF-00AA00A80033}"
$Reg_SECPOL[038] = "HKCU\Software\Policies\Microsoft\MMC\{58221C67-EA27-11CF-ADCF-00AA00A80033}"
$Reg_SECPOL[039] = "HKCU\Software\Policies\Microsoft\MMC\{5880CD5C-8EC0-11d1-9570-0060B0576642}"
$Reg_SECPOL[040] = "HKCU\Software\Policies\Microsoft\MMC\{5ADF5BF6-E452-11D1-945A-00C04FB984F9}"
$Reg_SECPOL[041] = "HKCU\Software\Policies\Microsoft\MMC\{5C659257-E236-11D2-8899-00104B2AFB46}"
$Reg_SECPOL[042] = "HKCU\Software\Policies\Microsoft\MMC\{5D6179C8-17EC-11D1-9AA9-00C04FD8FE93}"
$Reg_SECPOL[043] = "HKCU\Software\Policies\Microsoft\MMC\{677A2D94-28D9-11D1-A95B-008048918FB1}"
$Reg_SECPOL[044] = "HKCU\Software\Policies\Microsoft\MMC\{6E8E0081-19CD-11D1-AD91-00AA00B8E05A}"
$Reg_SECPOL[045] = "HKCU\Software\Policies\Microsoft\MMC\{74246bfc-4c96-11d0-abef-0020af6b0b7a}"
$Reg_SECPOL[046] = "HKCU\Software\Policies\Microsoft\MMC\{7478EF61-8C46-11d1-8D99-00A0C913CAD4}"
$Reg_SECPOL[047] = "HKCU\Software\Policies\Microsoft\MMC\{753EDB4D-2E1B-11D1-9064-00A0C90AB504}"
$Reg_SECPOL[048] = "HKCU\Software\Policies\Microsoft\MMC\{7AF60DD3-4979-11D1-8A6C-00C04FC33566}"
$Reg_SECPOL[049] = "HKCU\Software\Policies\Microsoft\MMC\{803E14A0-B4FB-11D0-A0D0-00A0C90F574B}"
$Reg_SECPOL[050] = "HKCU\Software\Policies\Microsoft\MMC\{88E729D6-BDC1-11D1-BD2A-00C04FB9603F}"
$Reg_SECPOL[051] = "HKCU\Software\Policies\Microsoft\MMC\{8EAD3A12-B2C1-11d0-83AA-00A0C92C9D5D}"
$Reg_SECPOL[052] = "HKCU\Software\Policies\Microsoft\MMC\{8F8F8DC0-5713-11D1-9551-0060B0576642}"
$Reg_SECPOL[053] = "HKCU\Software\Policies\Microsoft\MMC\{8FC0B734-A0E1-11D1-A7D3-0000F87571E3}"
$Reg_SECPOL[054] = "HKCU\Software\Policies\Microsoft\MMC\{90087284-d6d6-11d0-8353-00a0c90640bf}"
$Reg_SECPOL[055] = "HKCU\Software\Policies\Microsoft\MMC\{90810500-38F1-11D1-9345-00C04FC9DA04}"
$Reg_SECPOL[056] = "HKCU\Software\Policies\Microsoft\MMC\{90810502-38F1-11D1-9345-00C04FC9DA04}"
$Reg_SECPOL[057] = "HKCU\Software\Policies\Microsoft\MMC\{90810504-38F1-11D1-9345-00C04FC9DA04}"
$Reg_SECPOL[058] = "HKCU\Software\Policies\Microsoft\MMC\{942A8E4F-A261-11D1-A760-00C04FB9603F}"
$Reg_SECPOL[059] = "HKCU\Software\Policies\Microsoft\MMC\{95AD72F0-44CE-11D0-AE29-00AA004B9986}"
$Reg_SECPOL[060] = "HKCU\Software\Policies\Microsoft\MMC\{975797FC-4E2A-11D0-B702-00C04FD8DBF7}"
$Reg_SECPOL[061] = "HKCU\Software\Policies\Microsoft\MMC\{9EC88934-C774-11d1-87F4-00C04FC2C17B}"
$Reg_SECPOL[062] = "HKCU\Software\Policies\Microsoft\MMC\{A841B6C2-7577-11D0-BB1F-00A0C922E79C}"
$Reg_SECPOL[063] = "HKCU\Software\Policies\Microsoft\MMC\{B1AFF7D0-0C49-11D1-BB12-00C04FC9A3A3}"
$Reg_SECPOL[064] = "HKCU\Software\Policies\Microsoft\MMC\{B52C1E50-1DD2-11D1-BC43-00C04FC31FD3}"
$Reg_SECPOL[065] = "HKCU\Software\Policies\Microsoft\MMC\{B91B6008-32D2-11D2-9888-00A0C925F917}"
$Reg_SECPOL[066] = "HKCU\Software\Policies\Microsoft\MMC\{BACF5C8A-A3C7-11D1-A760-00C04FB9603F}"
$Reg_SECPOL[067] = "HKCU\Software\Policies\Microsoft\MMC\{BD95BA60-2E26-AAD1-AD99-00AA00B8E05A}"
$Reg_SECPOL[068] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE4500-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[069] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE4502-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[070] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE4504-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[071] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE4506-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[072] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE4508-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[073] = "HKCU\Software\Policies\Microsoft\MMC\{C2FE450B-D6C2-11D0-A37B-00C04FC9DA04}"
$Reg_SECPOL[074] = "HKCU\Software\Policies\Microsoft\MMC\{C9BC92DF-5B9A-11D1-8F00-00C04FC2C17B}"
$Reg_SECPOL[075] = "HKCU\Software\Policies\Microsoft\MMC\{D70A2BEA-A63E-11D1-A7D4-0000F87571E3}"
$Reg_SECPOL[076] = "HKCU\Software\Policies\Microsoft\MMC\{D967F824-9968-11D0-B936-00C04FD8D5B0}"
$Reg_SECPOL[077] = "HKCU\Software\Policies\Microsoft\MMC\{DAB1A262-4FD7-11D1-842C-00C04FB6C218}"
$Reg_SECPOL[078] = "HKCU\Software\Policies\Microsoft\MMC\{DEA8AFA0-CC85-11d0-9CE2-0080C7221EBD}"
$Reg_SECPOL[079] = "HKCU\Software\Policies\Microsoft\MMC\{E26D02A0-4C1F-11D1-9AA1-00C04FC3357A}"
$Reg_SECPOL[080] = "HKCU\Software\Policies\Microsoft\MMC\{E355E538-1C2E-11D0-8C37-00C04FD8FE93}"
$Reg_SECPOL[081] = "HKCU\Software\Policies\Microsoft\MMC\{EBC53A38-A23F-11D0-B09B-00C04FD8DCA6}"
$Reg_SECPOL[082] = "HKCU\Software\Policies\Microsoft\MMC\{FC715823-C5FB-11D1-9EEF-00A0C90347FF}"
$Reg_SECPOL[083] = "HKCU\Software\Policies\Microsoft\MMC\{FD57D297-4FD9-11D1-854E-00C04FC31FD3}"
$Reg_SECPOL[084] = "HKCU\Software\Policies\Microsoft\Windows NT\Driver Signing"
$Reg_SECPOL[085] = "HKCU\Software\Policies\Microsoft\Windows NT\Printers\Wizard"
$Reg_SECPOL[086] = "HKCU\Software\Policies\Microsoft\Windows\App Management"
$Reg_SECPOL[087] = "HKCU\Software\Policies\Microsoft\Windows\Control Panel\Desktop"
$Reg_SECPOL[088] = "HKCU\Software\Policies\Microsoft\Windows\CurrentVersion\Identities"
$Reg_SECPOL[089] = "HKCU\Software\Policies\Microsoft\Windows\Directory UI"
$Reg_SECPOL[090] = "HKCU\Software\Policies\Microsoft\Windows\Group Policy Editor"
$Reg_SECPOL[091] = "HKCU\Software\Policies\Microsoft\Windows\Installer"
$Reg_SECPOL[092] = "HKCU\Software\Policies\Microsoft\Windows\NetCache"
$Reg_SECPOL[093] = "HKCU\Software\Policies\Microsoft\Windows\NetCache\AssignedOfflineFolders"
$Reg_SECPOL[094] = "HKCU\Software\Policies\Microsoft\Windows\NetCache\CustomGoOfflineActions"
$Reg_SECPOL[095] = "HKCU\Software\Policies\Microsoft\Windows\Network Connections"
$Reg_SECPOL[096] = "HKCU\Software\Policies\Microsoft\Windows\Scripts\Logon"
$Reg_SECPOL[097] = "HKCU\Software\Policies\Microsoft\Windows\System"
$Reg_SECPOL[098] = "HKCU\Software\Policies\Microsoft\Windows\Task Scheduler5.0"
$Reg_SECPOL[099] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies"
$Reg_SECPOL[100] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\ActiveDesktop"
$Reg_SECPOL[101] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explore\Run"
$Reg_SECPOL[102] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer"
$Reg_SECPOL[103] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer\Run"
$Reg_SECPOL[104] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\NonEnum"
$Reg_SECPOL[105] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\Ratings"
$Reg_SECPOL[106] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System"
$Reg_SECPOL[107] = "HKLM\Software\Policies\Microsoft\System\DNSclient"
$Reg_SECPOL[108] = "HKLM\Software\Policies\Microsoft\Windows NT\DiskQuota"
$Reg_SECPOL[109] = "HKLM\Software\Policies\Microsoft\Windows NT\Printers"
$Reg_SECPOL[110] = "HKLM\Software\Policies\Microsoft\Windows NT\Printers\Wizard"
$Reg_SECPOL[111] = "HKLM\Software\Policies\Microsoft\Windows NT\Windows File Protection"
$Reg_SECPOL[112] = "HKLM\Software\Policies\Microsoft\Windows\App Management"
$Reg_SECPOL[113] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{25537BA6-77A8-11D2-9B6C-0000F8080861}"
$Reg_SECPOL[114] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{35378EAC-683F-11D2-A89A-00C04FBBCFA2}"
$Reg_SECPOL[115] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{3610eda5-77ef-11d2-8dc5-00c04fa31a66}"
$Reg_SECPOL[116] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{42B5FAAE-6536-11d2-AE5A-0000F87571E3}"
$Reg_SECPOL[117] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{827D319E-6EAC-11D2-A4EA-00C04F79F83A}"
$Reg_SECPOL[118] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{A2E30F80-D7DE-11d2-BBDE-00C04F86AE3B}"
$Reg_SECPOL[119] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{B1BE8D72-6EAC-11D2-A4EA-00C04F79F83A}"
$Reg_SECPOL[120] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{c6dc5466-785a-11d2-84d0-00c04fb169f7}"
$Reg_SECPOL[121] = "HKLM\Software\Policies\Microsoft\Windows\Group Policy\{e437bc1c-aa7d-11d2-a382-00c04f991e27}"
$Reg_SECPOL[122] = "HKLM\Software\Policies\Microsoft\Windows\Installer"
$Reg_SECPOL[123] = "HKLM\Software\Policies\Microsoft\Windows\NetCache"
$Reg_SECPOL[124] = "HKLM\Software\Policies\Microsoft\Windows\NetCache\AssignedOfflineFolders"
$Reg_SECPOL[125] = "HKLM\Software\Policies\Microsoft\Windows\NetCache\CustomGoOfflineActions"
$Reg_SECPOL[126] = "HKLM\Software\Policies\Microsoft\Windows\Network Connections"
$Reg_SECPOL[127] = "HKLM\Software\Policies\Microsoft\Windows\Scripts\Logon"
$Reg_SECPOL[128] = "HKLM\Software\Policies\Microsoft\Windows\System"
$Reg_SECPOL[129] = "HKLM\Software\Policies\Microsoft\Windows\Task Scheduler5.0"
$Reg_SECPOL[130] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\system\Shell"

; Clefs registre "RUN"
Global $Reg_SECRUN[52] ; Toutes les branches à osculter
$Reg_SECRUN[001] = "HKCR\batfile\shell\open\command"
$Reg_SECRUN[002] = "HKCR\comfile\shell\open\command"
$Reg_SECRUN[003] = "HKCR\exefile\shell\open\command"
$Reg_SECRUN[004] = "HKCR\htafile\Shell\Open\Command"
$Reg_SECRUN[005] = "HKCR\piffile\shell\open\command"
$Reg_SECRUN[006] = "HKCU\Software\Microsoft\Command Processor"
$Reg_SECRUN[007] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
$Reg_SECRUN[008] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
$Reg_SECRUN[009] = "HKCU\Software\Microsoft\Windows\CurrentVersion\Run"
$Reg_SECRUN[010] = "HKCU\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$Reg_SECRUN[011] = "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServices"
$Reg_SECRUN[012] = "HKCU\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
$Reg_SECRUN[013] = "HKCU\Software\Mirabilis\ICQ\Agent\Apps\test"
$Reg_SECRUN[014] = "HKLM\Software\CLASSES\batfile\shell\open\command"
$Reg_SECRUN[015] = "HKLM\Software\CLASSES\comfile\shell\open\command"
$Reg_SECRUN[016] = "HKLM\Software\CLASSES\exefile\shell\open\command"
$Reg_SECRUN[017] = "HKLM\Software\CLASSES\htafile\Shell\Open\Command"
$Reg_SECRUN[018] = "HKLM\Software\CLASSES\piffile\shell\open\command"
$Reg_SECRUN[019] = "HKLM\Software\Microsoft\Active Setup\Installed Components"
$Reg_SECRUN[020] = "HKLM\Software\Microsoft\Active Setup\Installed Components"
$Reg_SECRUN[021] = "HKLM\Software\Microsoft\Command Processor"
$Reg_SECRUN[022] = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Windows"
$Reg_SECRUN[023] = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Appinit_Dlls"
$Reg_SECRUN[024] = "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon\Notify\debugg"
$Reg_SECRUN[025] = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\Shell"
$Reg_SECRUN[026] = "HKLM\Software\Microsoft\Windows NT\CurrentVersion\Winlogon\UserInit"
$Reg_SECRUN[027] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Browser Helper Object"
$Reg_SECRUN[028] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\ShellExecuteHooks"
$Reg_SECRUN[029] = "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\SharedTaskScheduler"
$Reg_SECRUN[030] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
$Reg_SECRUN[031] = "HKLM\Software\Microsoft\Windows\Currentversion\explorer\Usershell"
$Reg_SECRUN[032] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Run"
$Reg_SECRUN[033] = "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$Reg_SECRUN[034] = "HKLM\Software\Microsoft\Windows\CurrentVersion\RunOnceEx"
$Reg_SECRUN[035] = "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServices"
$Reg_SECRUN[036] = "HKLM\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"
$Reg_SECRUN[037] = "HKLM\Software\Microsoft\Windows\CurrentVersion\shell Extension\Approved"
$Reg_SECRUN[038] = "HKLM\Software\Microsoft\Windows\CurrentVersion\ShellServiceObjectDelayLoad"
$Reg_SECRUN[039] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Windows\Load"
$Reg_SECRUN[040] = "HKLM\Software\Microsoft\Windows\CurrentVersion\Windows\Run"
$Reg_SECRUN[041] = "HKLM\System\CurrentControlSet\Control\MPRServices"
$Reg_SECRUN[042] = "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager"
$Reg_SECRUN[043] = "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\BootExecute"
$Reg_SECRUN[044] = "HKU\.DEFAULT\Software\Microsoft\Command Processor"
$Reg_SECRUN[045] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
$Reg_SECRUN[046] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Explorer\User Shell Folders"
$Reg_SECRUN[047] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\Run"
$Reg_SECRUN[048] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunOnce"
$Reg_SECRUN[049] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunOnceEx"
$Reg_SECRUN[050] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunServices"
$Reg_SECRUN[051] = "HKU\.DEFAULT\Software\Microsoft\Windows\CurrentVersion\RunServicesOnce"

; Cas spéciaux

; Clefs génériques

; Messages
Global $Mess[151][3][3] ; [# du message][langue][flag/titre/message]
; MsgBox (0-99)
Array_ADD(1, 1, 48,"Erreur 100","Impossible de créer le fichier journal!¤Assurez-vous qu'il n'est pas présentement en consultation¤et que l'endroit d'où est parti ce programme n'est pas en lecture seule.")
Array_ADD(2, 1, 48,"Erreur 101","Impossible de fermer le fichier journal!¤Assurez-vous qu'il n'est pas présentement en consultation¤et que l'endroit d'où est parti ce programme n'est pas en lecture seule.")
Array_ADD(3, 1, 48,"Erreur 102","Certaines valeurs du registre de cette machine sont inaccessibles.¤Impossible d'accéder à la clef¤¥")
Array_ADD(4, 1, 64,"Ligne de commande","Ligne de commande £¤¤/?            Aide¤/NoGui    Pas d'interface graphique¤/NoLog   Pas de fichier journal¤/App       Trier par appartenance")
Array_ADD(5, 1, 21,"Erreur","Vous avez annulé la sauvegarde du rapport.¤¤Cliquez sur 'Recommencer' pour essayer ¤de sauver à nouveau ou sur 'Annuler' pour¤abandonner cette opération.")
Array_ADD(6, 1, 52,"Attention!","Un fichier portant le même nom existe déjà.¤Désirez-vous l'écraser?")
Array_ADD(7, 1, 308,"Erreur","Impossible d'écrire ou d'écraser le fichier.¤Voulez-vous réessayer?")
Array_ADD(1, 2, 48,"Error 100","Cannot create logfile!¤Please make sure the file is not in use¤and that this program is not run from a read-only media (CD-ROM).")
Array_ADD(2, 2, 48,"Error 101","Cannot close logfile!¤Please make sure the file is not in use¤and that this program is not run from a read-only media (CD-ROM).")
Array_ADD(3, 2, 48,"Error 102","Parts of your registry are unaccessible.¤Cannot access key ¤¥")
Array_ADD(4, 2, 64,"Command line help","Command line £¤¤/?            Help¤/NoGui    No graphical user interface¤/NoLog   No logfile¤/App       Sort by program")
Array_ADD(5, 2, 21,"Error","You have cancelled the save.¤¤¤Click on 'Retry' to save again ¤or on 'Cancel' to¤abandon this operation.")
Array_ADD(6, 2, 52, "Warning!","A file with the same name exists!¤Do you want to overwrite it?")
Array_ADD(7, 2, 308,"Error","Cannot create or overwrite the file¤Do you want to retry?")

; Save/Load dialog (100-124)
Array_ADD(100,1,18,"Enregisrer le rapport","Fichier texte (*.txt)")
Array_ADD(100,2,18,"Save the logfile","Text file (*.txt)")

; Gui elements (125-148)
Array_ADD(125,1,0,$Ver)
Array_ADD(126,1,0,"Enregistrer ...")
Array_ADD(127,1,0,"Quitter")
Array_ADD(128,1,0,"Copier au presse-papier")
Array_ADD(129,1,0,"Crédits")
Array_ADD(130,1,0,"Envoi par E-mail")
Array_ADD(131,1,0,"À propos de")
Array_ADD(132,1,0," Louis Horvath. Tous droits réservés.")
Array_ADD(133,1,0,"Page web du programme")
Array_ADD(134,1,0,"Courrier électronique")
Array_ADD(135,1,0,"Programmé avec AutoIT3!")
Array_ADD(136,1,0,"Version programme: ")
Array_ADD(125,2,0,$Ver)
Array_ADD(126,2,0,"Save as ...")
Array_ADD(127,2,0,"Exit")
Array_ADD(128,2,0,"Copy to clipboard")
Array_ADD(129,2,0,"Credits")
Array_ADD(130,2,0,"Send by E-Mail")
Array_ADD(131,2,0,"About Info")
Array_ADD(132,2,0," Louis Horvath. All rights reserved.")
Array_ADD(133,2,0,"Application Web Page")
Array_ADD(134,2,0,"Email")
Array_ADD(135,2,0,"Made with AutoIT3!")
Array_ADD(136,2,0,"Program version: ")

; Date elements (149-150)
Array_ADD(149,1,0," sur ")
Array_ADD(150,1,0," en date du ")
Array_ADD(149,2,0," on ")
Array_ADD(150,2,0," for date ")

; Credits variable
$A_CLabel = "Copyright © " & @YEAR & $Mess[132][$Lang][1] ; Copyright Label #132
$A_URL1 = "http://www.autoitscript.com/forum/index.php?act=findpost&pid=371281"
$A_URL2 = "mailto:drlouis@videotron.ca"
$A_URL3 = "http://www.autoitscript.com"
$A_LinkColor = 0x0000FF
$A_BkColor = 0xFFFFFF

; ==== SECTION INITIALE ======================================================
Ligne_COMMANDE() ; Traiter la ligne de commande

Boucle_PRINCIPALE() ; Voilà où tout se passe

If $Code_ERREUR = 102 Then ; Un accroc durant la lecture du registre.
	Erreur($Code_ERREUR)
EndIf

Erreur($Code_ERREUR) ; Afficher le message correspondant.

Affiche_RAP() ; Afficher le rapport

Exit ($Code_ERREUR) ; Quitter et renvoyer le code d'erreur (si nécessaire)

; ==== FONCTIONS =============================================================
Func Boucle_PRINCIPALE() ; Lire toutes les branches
	Local $i, $j, $k, $Reg, $Err
	
	If Not $NoPol Then ; ==== POLICIES ====
		Exporte_TEXTE("[" & "==== " & $Ver & $Mess[149][$Lang][1] & @ComputerName & $Mess[150][$Lang][1] & $Date & " ====" & "]") ; Entête
		Exporte_TEXTE(" ____ Window Policies ____________________")
		Exporte_TEXTE("") ; Ligne extra
		
		For $i = 1 To UBound($Reg_SECPOL) -1
			$Reg = RegEnumVal($Reg_SECPOL[$i], 1) ; Existe-t-il quelque chose dans cette branche?
			$Err = @error
			If $Err = 0 Then ; Oui il y a des valeurs!
				Exporte_TEXTE("[" & $Reg_SECPOL[$i] & "]") ; Entête
				Lire_REGISTRE($Reg_SECPOL[$i]) ; Passer le flambeau. Variable = nom de la branche ou se trouve les clefs
			Else
				If $Err = 2 Then ; Quelque chose de grave est arrivé.
					$Code_ERREUR = 102 ; Impossible d'accéder au registre - Grave
					$Code_ERREUR_CLEF = $Reg_SECPOL[$i]
				EndIf
			EndIf
		Next
	EndIf
	
	If Not $NoRun Then ; ==== RUN ====
		Exporte_TEXTE("")
		Exporte_TEXTE(" ____ Windows RUN ____________________")
		Exporte_TEXTE("") ; Ligne extra
		
		For $i = 1 To UBound($Reg_SECRUN) -1
			$Reg = RegEnumVal($Reg_SECRUN[$i], 1) ; Existe-t-il quelque chose dans cette branche?
			$Err = @error
			If $Err = 0 Then ; Oui il y a des valeurs!
				Exporte_TEXTE("[" & $Reg_SECRUN[$i] & "]") ; Entête
				Lire_REGISTRE($Reg_SECRUN[$i]) ; Passer le flambeau. Variable = nom de la branche ou se trouve les clefs
			Else
				If $Err = 2 Then ; Quelque chose de grave est arrivé.
					$Code_ERREUR = 102 ; Impossible d'accéder au registre - Grave
					$Code_ERREUR_CLEF = $Reg_SECRUN[$i]
				EndIf
			EndIf
		Next
	EndIf
	
	If Not $NoINI Then ; ==== .INIs ====
		Exporte_TEXTE("")
		Exporte_TEXTE(" ____ Windows .INI ___________________")
		Exporte_TEXTE("") ; Ligne extra
		
		$i = _LireINI("CONFIG.SYS",@HomeDrive)
		If $i <> "" Then Exporte_TEXTE($i)
		
		$i = _LireINI("AUTOEXEC.BAT",@HomeDrive)
		If $i <> "" Then Exporte_TEXTE($i)
		
		$i = _LireINI("SYSTEM.INI",@WindowsDir,"boot")
		If $i <> "" Then Exporte_TEXTE($i)
		
		$i = _LireINI("WIN.INI",@WindowsDir,"windows")
		If $i <> "" Then Exporte_TEXTE($i)
		
		$i = _LireINI("WININIT.INI",@WindowsDir)
		If $i <> "" Then Exporte_TEXTE($i)
	EndIf

	If Not $NoBHO Then ; ==== BHOs ====
		Exporte_TEXTE("")
		Exporte_TEXTE(" ____ Browser Helper Objects (BHOs) __")
		Exporte_TEXTE("") ; Ligne extra
		
		For $i = 1 To 50 ; Jamais plus que 50 BHO?
			$j = RegEnumKey($IE_BHO,$i) ; Get those CSLID values
			$err = @error 
			If $err <> 0 Then ExitLoop ; End of the road
			$k = RegRead($CLSID&$j,"") ; Name of BHO is in default value
			
			Exporte_TEXTE($j & " = " & $k)
		Next
	EndIf
	
	If Not $NoServ Then ; ==== SERVICES ====
		Exporte_TEXTE("")
		Exporte_TEXTE(" ____ System services ________________")
		Exporte_TEXTE("") ; Ligne extra
		
		_ComputerGetServices($i)
		$j = @error
		; Detect WMI not installed or broken
		For $k = 1 To $i[0][0]
			Exporte_TEXTE($i[$k][0] & " (" & $i[$k][17] & ") " & " = " & $i[$k][7])
		Next
	EndIf
	
EndFunc   ;==>Boucle_PRINCIPALE

Func Lire_REGISTRE($i); Lire toutes les clefs et leur valeur
	Local $j, $Reg_KEY, $Reg_VAL, $Err
	For $j = 1 To 255
		$Reg_KEY = RegEnumVal($i, $j)
		$Err = @error
		If $Err = 0 Then
			$Reg_VAL = RegRead($i, $Reg_KEY)
			Exporte_TEXTE($i, $Reg_KEY, $Reg_VAL)
		Else
			Exporte_TEXTE("") ; Ligne extra
			ExitLoop
		EndIf
	Next
EndFunc   ;==>Lire_REGISTRE

Func Exporte_TEXTE($i, $j = "", $k = "", $l = ""); Écrire le journal
	If $j = "" And $k = "" Then ; Entête de section
		$Rap &= $i & "|"
	Else
		If IsInt($k) Then $k = "0x" & Hex($k) & " (" & $k & ")" ; Convertir les nombres en hexadécimal
		If $k = "" Then $k = '""' ; Montrer les valeurs vides
		$Rap &= $j & " = " & $k & "|"
	EndIf
EndFunc   ;==>Exporte_TEXTE

Func Erreur($i); Afficher message significatif en cas d'erreur
	Switch $i
		Case 100 ; Impossible de créer le fichier journal #1
			MsgBox($Mess[1][$Lang][0], $Mess[1][$Lang][1], $Mess[1][$Lang][2])
		Case 101 ; Impossible de fermer le fichier journal #2
			MsgBox($Mess[2][$Lang][0], $Mess[2][$Lang][1], $Mess[2][$Lang][2])
		Case 102 ; Impossible d'accéder au registre #3
			MsgBox($Mess[3][$Lang][0], $Mess[3][$Lang][1], $Mess[3][$Lang][2])
	EndSwitch
EndFunc   ;==>Erreur

Func Affiche_RAP()
	Local $Form1, $Edit1, $Button1, $Button2, $Zap, $i, $j, $File, $nMsg
	
	If $NoGui Then
		Sauve_LISTE()
		Return
	EndIf
		
	$Form1 = GUICreate($Mess[125][$Lang][1], 632, 457, 193, 115) ; Rapport #125
	$Edit1 = GUICtrlCreateList("", 8, 8, 617, 409,BitOR($WS_VSCROLL, $WS_BORDER))
	$Button1 = GUICtrlCreateButton($Mess[126][$Lang][1], 7, 424, 113, 25, 0) ; Enregistrer sous ... #126
	$Button2 = GUICtrlCreateButton($Mess[127][$Lang][1], 391, 425, 113, 25, 0) ; Quitter ... #127
	$Button3 = GUICtrlCreateButton($Mess[129][$Lang][1], 512, 424, 115, 25, 0) ; "Crédits" ... #129
	$Button4 = GUICtrlCreateButton($Mess[128][$Lang][1], 128, 424, 137, 25, 0) ; "Copier au presse-papiers" ... #128
	$Button5 = GUICtrlCreateButton($Mess[130][$Lang][1], 272, 424, 113, 25, 0) ; "Envoi par E-Mail" ... #130
	
	GUISetState(@SW_SHOW)
	
	GUICtrlSetState($Button5,$GUI_DISABLE)
	
	GUICtrlSetData($Edit1,$Rap) ; Montrer le rapport ! (eh oui, aussi simple que ça)
	
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE ; Quitter via "X"
				Exit
			Case $Button2 ; Quitter via le bouton "Quitter"
				Exit
			Case $Button1 ; Sauver le document sur le disque
				Sauve_LISTE()
				Exit
			Case $Button4 ; COpier au presse-papier
				ClipPut(_Convertir($Rap))
				Exit
			Case $Button3 ; Les crédits
				$hWnd = WinGetHandle(WinGetTitle(""))
				_About($Mess[131][$Lang][1],$Ver,$A_CLabel,"v1.07",$Mess[133][$Lang][1],$A_URL1,$Mess[134][$Lang][1],$A_URL2,$Mess[135][$Lang][1],$A_URL3, @AutoItExe, $A_LinkColor, $A_BkColor, -1, -1, -1, -1, $hWnd)
			Case $Button5 ; Envoyer par courrier électronique (désactivé pour l'instant)
				; Email()
				Exit
		EndSwitch
	WEnd
EndFunc

Func Ligne_COMMANDE() ; Traite et execute la ligne de commande
	Local $i, $Param = 0, $Help
	If $CmdLine[0] > 0 Then ; S'il y a une ligne de commande, la traiter
		For $i = 1 To UBound($CmdLine) - 1 ; Et lire et assigner les variables conformément
			Switch $CmdLine[$i]
				Case "/NoGui", "-NoGui", "/nogui", "-nogui", "/NOGUI", "-NOGUI" ; Pas de rapport à l'écran
					$NoGui = 1
				Case "/App", "-App", "/app", "-app", "/APP", "-APP" ; Trier par appartenance (NON FONCTIONNEL)
					$Appartenance = 1
				Case "/NoLog", "-NoLog", "/nolog", "-nolog", "/NOLOG", "-NOLOG" ; Pas de rapport au disque
					$NoLog = 1
				Case "/?", "-?", "?", "/Help", "-Help", "/help", "-help", "/HELP", "-HELP" ; Aide sur la ligne de commande
					$Help = 1
				Case "/NoServ", "-NoServ", "/noserv", "-noserv", "/NOSERV", "-NOSERV" ; Pas de services
					$NoServ = 1
				Case "/NoBho", "-NoBho", "/nobho", "-nobho", "/NOBHO", "-NOBHO" ; Pas de Browser Helper Objects
					$NoBho = 1
				Case "/NoRun", "-NoRun", "/norun", "-norun", "/NORUN", "-NORUN" ; Pas de Run
					$NoRun = 1
				Case "/NoPol", "-NoPol", "/nopol", "-nopol", "/NOPOL", "-NOPOL" ; Pas de Policies
					$NoPol = 1
				Case "/NoINI", "-NoINI", "/noini", "-noini", "/NOINI", "-NOINI" ; Pas de lecture des fichiers .INI
					$NoINI = 1
			EndSwitch
		Next
	EndIf
	
	If $NoGui And $NoLog Then Exit ; Pas les deux fonctions en même temps!
	
	If $Help Then ; Aide ligne de commande #4
		MsgBox($Mess[4][$Lang][0], $Mess[4][$Lang][1], $Mess[4][$Lang][2])
		Exit
	EndIf
	
EndFunc   ;==>Ligne_COMMANDE

Func Sauve_LISTE() ; Permet d'enregister la liste sous un nom donné.
	Local $iMsgBoxAnswer, $Sav, $err, $Open, $Write
	
	$Rap = _Convertir($Rap) ; Remplacer les "|" par des changements de ligne!
	
	If $NoGui Then ; Pas d'affichage
		$Open = FileOpen(@ScriptDir & "\" & $Rapport,2) ; Ouvrir le fichier pour l'écriture ...
		$Write = FileWrite($Open,$Rap) ; Ha! Écrire une ligne? Non, tout le bataclan!
		Return
	EndIf
		
	While 1 ; Boucle sélection de fichier
		$Sav = FileSaveDialog($Mess[100][$Lang][1],@ScriptDir,$Mess[100][$Lang][2],$Mess[100][$Lang][0],$Rapport)
		$Err = @error
		If $Err Or $Sav = "" Then ; Annuler la sauvegarde du rapport #5
			$iMsgBoxAnswer = MsgBox($Mess[5][$Lang][0], $Mess[5][$Lang][1], $Mess[5][$Lang][2])
			If $iMsgBoxAnswer = 4 Then ;Retry
				ContinueLoop
			Else
				Return
			EndIf
		Else 
			ExitLoop
		EndIf
	WEnd
	
	While 1 ; Boucle écriture
		$Open = FileOpen($Sav,2) ; Ouvrir le fichier pour l'écriture ...
		$Write = FileWrite($Open,$Rap) ; Ha! Écrire une ligne? Non, tout le bataclan!
		If $Open = -1 Or $Write = 0 Then ; Ça n'a pas marché... Impossible d'écrire #7
			$iMsgBoxAnswer = MsgBox($Mess[7][$Lang][0], $Mess[7][$Lang][1], $Mess[7][$Lang][2])
			If $iMsgBoxAnswer = 7 Then
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	WEnd
EndFunc

Func _Langue()
	Select
		Case StringRight(@OSLANG, 2) = "13"
			Return 5 ; Danois
		Case StringRight(@OSLANG, 2) = "09"
			Return 2 ; Anglais
		Case StringRight(@OSLANG, 2) = "0c"
			Return 1 ; Français
		Case StringRight(@OSLANG, 2) = "07"
			Return 3 ; Allemand
		Case StringRight(@OSLANG, 2) = "10"
			Return 6 ; Italien
		Case StringRight(@OSLANG, 2) = "14"
			Return 7 ; Norvégien
		Case StringRight(@OSLANG, 2) = "15"
			Return 8 ; Polonais
		Case StringRight(@OSLANG, 2) = "16"
			Return 9 ; Portuguais
		Case StringRight(@OSLANG, 2) = "0a"
			Return 4 ; Espagnol
		Case StringRight(@OSLANG, 2) = "1d"
			Return 10 ; Suédois
		Case Else
			Return 0 ; Inconnu
    EndSelect
EndFunc

Func Array_ADD($i, $j, $k = 0, $l = "", $m = "", $n = "")
	; $i = # du message
	; $j = Langue
	; $k = Flag 
	; $l = Titre
	; $m = Texte
	; $n = Special
	; Remplacer £ par nom du programme et version --> Alt 0163
	; Remplacer ¤ par @CR --> Alt 0164
	; Remplacer ¥ par message spécial --> Alt 0165
	$m = StringReplace($m, "¤", @CR) ; Restaurer les changements de ligne
	$m = StringReplace($m, "¥", $n) ; Insérer valeur spéciale
	$m = StringReplace($m, "£", $Ver) ; Insérer version
	$Mess[$i][$j][0] = $k
	$Mess[$i][$j][1] = $l
	$Mess[$i][$j][2] = $m
EndFunc

;===============================================================================
; Description:      Returns the services information in an array.
; Parameter(s):     $aServicesInfo - By Reference - Services Information array.
;					$sState - OPTIONAL - Accepted values 'All' or 'Stopped' or
;										'Running'
; Requirement(s):   None
; Return Value(s):  On Success - Returns array of Services Information.
;						$aServicesInfo[0][0]   = Number of Services
;						$aServicesInfo[$i][0]  = Name ($i starts at 1)
;						$aServicesInfo[$i][1]  = Accept Pause
;						$aServicesInfo[$i][2]  = Accept Stop
;						$aServicesInfo[$i][3]  = Check Point
;						$aServicesInfo[$i][4]  = Description
;						$aServicesInfo[$i][5]  = Creation Class Name
;						$aServicesInfo[$i][6]  = Desktop Interact
;						$aServicesInfo[$i][7]  = Display Name
;						$aServicesInfo[$i][8]  = Error Control
;						$aServicesInfo[$i][9]  = Exit Code
;						$aServicesInfo[$i][10] = Path Name
;						$aServicesInfo[$i][11] = Process ID
;						$aServicesInfo[$i][12] = Service Specific Exit Code
;						$aServicesInfo[$i][13] = Service Type
;						$aServicesInfo[$i][14] = Started
;						$aServicesInfo[$i][15] = Start Mode
;						$aServicesInfo[$i][16] = Start Name
;						$aServicesInfo[$i][17] = State
;						$aServicesInfo[$i][18] = Status
;						$aServicesInfo[$i][19] = System Creation Class Name
;						$aServicesInfo[$i][20] = System Name
;						$aServicesInfo[$i][21] = Tag ID
;						$aServicesInfo[$i][22] = Wait Hint
;
;                   On Failure - @error = 1 and Returns 0
;								@extended = 1 - Array contains no information
;											2 - $colItems isnt an object
; Author(s):        Jarvis Stubblefield (support "at" vortexrevolutions "dot" com)
; Note(s):
;===============================================================================
Func _ComputerGetServices(ByRef $aServicesInfo, $sState = "All")
	Local $cI_Compname = @ComputerName, $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	Local $colItems, $objWMIService, $objItem
	Dim $aServicesInfo[1][23], $i = 1
	
	$objWMIService = ObjGet("winmgmts:\\" & $cI_Compname & "\root\CIMV2")
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_Service", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	
	If IsObj($colItems) Then
		For $objItem In $colItems
			If $sState <> "All" Then
				If $sState = "Stopped" AND $objItem.State <> "Stopped" Then ContinueLoop
				If $sState = "Running" AND $objItem.State <> "Running" Then ContinueLoop
			EndIf
			ReDim $aServicesInfo[UBound($aServicesInfo) + 1][23]
			$aServicesInfo[$i][0]  = $objItem.Name
			$aServicesInfo[$i][7]  = $objItem.DisplayName
			$aServicesInfo[$i][17] = $objItem.State
			$i += 1
		Next
		$aServicesInfo[0][0] = UBound($aServicesInfo) - 1
		If $aServicesInfo[0][0] < 1 Then
			SetError(1, 1, 0)
		EndIf
	Else
		SetError(1, 2, 0)
	EndIf
EndFunc ;_ComputerGetServices

Func _Convertir($i)
	; Passer de "|" à @CRLF
	Return StringReplace($i, "|", @CRLF)
EndFunc

Func _About($Title, $MainLabel, $CopyRLabel, $VerLabel, $NameURL1, $URL1, $NameURL2, $URL2, $NameURL3, $URL3, $IconFile="", $LinkColor=0x0000FF, $BkColor=0xFFFFFF, $Left=-1, $Top=-1, $Style=-1, $ExStyle=-1, $Parent=0)
    Local $OldEventOpt = Opt("GUIOnEventMode", 0)
    Local $OldRunErrOpt = Opt("RunErrorsFatal", 0)
    Local $GUI, $LinkTop=120, $Msg
    Local $CurIsOnCtrlArr[1]
    
    Local $LinkVisitedColor[4] = [3, $LinkColor, $LinkColor, $LinkColor]
    Local $LinkLabel[4]
    
    WinSetState($Parent, "", @SW_DISABLE)
    
    If $ExStyle = -1 Then $ExStyle = ""
    $GUI = GUICreate($Title, 320, 240, $Left, $Top, $Style, 0x00000080+$ExStyle, $Parent)
    GUISetBkColor($BkColor)

    GUICtrlCreateLabel($MainLabel, 40, 20, 280, 25, 1)
    GUICtrlSetFont(-1, 16)

    GUICtrlCreateIcon($IconFile, 0, 10, 20)

    GUICtrlCreateGraphic(5, 75, 310, 3, $SS_ETCHEDFRAME)
    
    For $i = 1 To 3
        $LinkLabel[$i] = GUICtrlCreateLabel(Eval("NameURL" & $i), 150, $LinkTop, 145, 15, 1)
        GUICtrlSetCursor(-1, 0)
        GUICtrlSetColor(-1, $LinkColor)
        GUICtrlSetFont(-1, 9, 400, 0)
        $LinkTop += 30
    Next

    GUICtrlCreateLabel($Mess[136][$Lang][1] & @LF & $VerLabel, 10, 130, 150, 35, 1)
    GUICtrlSetFont(-1, 10, 600, 0, "Tahoma")
    
    GUICtrlCreateLabel($CopyRLabel, 0, 220, 320, -1, 1)

    GUISetState(@SW_SHOW, $GUI)

    While 1
        $Msg = GUIGetMsg()
        If $Msg = -3 Then ExitLoop
        For $i = 1 To 3
            If $Msg = $LinkLabel[$i] Then
                $LinkVisitedColor[$i] = 0xAC00A9
                GUICtrlSetColor($LinkLabel[$i], $LinkVisitedColor[$i])
                ShellExecute(Eval("URL" & $i))
            EndIf
        Next
        If WinActive($GUI) Then
            For $i = 1 To 3
                ControlHover($GUI, $LinkLabel[$i], $i, $CurIsOnCtrlArr, 0xFF0000, $LinkVisitedColor[$i])
            Next
        EndIf
    WEnd
    WinSetState($Parent, "", @SW_ENABLE)
    GUIDelete($GUI)
    Opt("GUIOnEventMode", $OldEventOpt)
    Opt("RunErrorsFatal", $OldRunErrOpt)
EndFunc

Func ControlHover($hWnd, $CtrlID, $CtrlNum, ByRef $CurIsOnCtrlArr, $HoverColor=0xFF0000, $LinkColor=0x0000FF)
    Local $CursorCtrl = GUIGetCursorInfo($hWnd)
    ReDim $CurIsOnCtrlArr[UBound($CurIsOnCtrlArr)+1]
    If $CursorCtrl[4] = $CtrlID And $CurIsOnCtrlArr[$CtrlNum] = 1 Then
        GUICtrlSetFont($CtrlID, 9, 400, 6)
        GUICtrlSetColor($CtrlID, $HoverColor)
        $CurIsOnCtrlArr[$CtrlNum] = 0
    ElseIf $CursorCtrl[4] <> $CtrlID And $CurIsOnCtrlArr[$CtrlNum] = 0 Then
        GUICtrlSetFont($CtrlID, 9, 400, 0)
        GUICtrlSetColor($CtrlID, $LinkColor)
        $CurIsOnCtrlArr[$CtrlNum] = 1
    EndIf
EndFunc

Func _LireINI($i, $j, $k = "")
	; $i = Filename, $j = Folder, $k = Section name)
	Local $Param = "", $f, $file = $j & "\" & $i
	If FileExists($file) Or FileGetSize($file) > 0 Then
		If $k = "" Then
			$f = FileOpen($file,0)
			$Param &= "[" & $file & "]" & "|"
			For $l = 1 to 999
				$m = FileReadLine($f,$l)
				If @error = -1 Then ExitLoop ; End-Of-File
				If $m = "" Then ContinueLoop
				$Param &= $m & "|"
			Next
			$Param &= "|"
			FileClose($f)
		Else
			$f = IniReadSection($file, $k)
			If @error <> 1 Then 
				$Param &= "[" & $file & "]" & "|"
				For $l = 1 To $f[0][0]
					If $f[$l][0] <> "" Then 
						$Param &= $f[$l][0] & " = " & $f[$l][1] & "|"
					EndIf
				Next
			EndIf
		EndIf
	Return $Param
	EndIf
EndFunc