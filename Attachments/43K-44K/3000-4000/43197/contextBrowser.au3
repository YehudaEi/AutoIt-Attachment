#include <WinAPIShPath.au3>



#region TODO

;~ SYSTEM:
;~ ======

;~ Bookmarks ( synchronisiert )
;~ DROPBOX
;~ SKYDRIVE
;~ SYS32
;~ LAUNCH
;~ PAPIERKORB
;~ PROGRAMME


;~ DATEN:
;~ ======

;~ D:
;~ UDB
;~ ES.Allg
;~ ES.Technik
;~ ES.Coding
;~ ES.Programme
;~ Reflektionen
;~ Texte
;~ FMS.BILDUNG.EIGENES WISSEN
;~ Visualisierungsspeicher
;~ PROGRAMME
;~ SKS
;~ BKS
;~ FMS
;~ PMS
;~ MUSIK
;~ SPRACHEN



	; RECENT:

;~ 		Recent Places				{22877a6d-37a1-461a-91b0-dbda5aaebc99}  ; folders only

		; recent Programs:
;~ 		http://www.aldeid.com/wiki/Windows-userassist-keys

	    ; bestimmte Programme von der  MRU-Liste ausschließen:  'HKEY_CLASSES_ROOT\ Applications' > 'New | String Value'. > 'NoStartPage'


;~ 		HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths   ; was wurde in die adressleiste eingetippt?

;~ 		HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU  ; was wurde via win+r ausgeführt?


;~ 		@AppDataDir & "\Roaming\Microsoft\Windows\Recent"

;~ 		@AppDataDir & "\Local\Microsoft\Windows\History


	; paste the folder or file über der das menü geöffnet wurde, bzw die zu diesem zeitpunkt selektiert waren

	; "add to favourites"- / "add to recent" / "add to temporary favourites"    hotkey für ordner und dateien die nicht aufgerufen werden

	; Events des Menüs abfangen >   siehe marke 12345

	; Steuerung durch hotkeys wie im Kebro.big  ( gleiche technologie, möglichst wenige tastendrücke )

	; Mehrere "Übergeordnete Ordner" gleich mit ins Menü aufnehmen

	; einfaches "pasting" des clipboards in aktuellen ordner ( vielleicht sogar ohne das entsprechende submenü erst auszufahren )

	; abbruch-key um nicht nur ein submenü sondern den ganzen kEbro zu verlassen

	; ( evlt ) nur Verzeichnisse einblenden

	; als Modul ausführen, dass kein shellexecute ausführt, sondern nur den pfad zurückgibt

	; irgendwie zwischen dem aufrufen des submenüs eines ordners und dem aufrufen oder <pathcopy> des ordners unterscheiden

		; zb durch Manipulatoren gedrückt halten

	; cachen > öffnungszeit auf 0 reduzieren ( verstecken statt sc )

	; paste-and-leave-modus > dient nur zum Verschieben von dateien, menü schließt danach

	; silent paste ( dateien ohne lästigen copy-dlg verschieben )

	; Kontrolle per Tastatur und Visualisierung der Hotstrings

	; alles in einer UDF vereinen ( auch das handling der window messages )

	; Favouriten

		; Filecache

		; PMS

		; BibliothekeN


#endregion TODO


; ABHÄNGIGKEITEN ELIMINIEREN
#include-once
#include <GuiMenu.au3>
#include "APIConstants.au3"
#include "WinAPIEx.au3"


HotKeySet( "{ESC}" , "_exit" )
Func _exit()
	Exit
EndFunc


$tic = TimerInit()

$favDir =  @TempDir & "\KebroFabvourites"
DirRemove( $favDir )  ; die Lösung mit dem Löschen ist nur temporär > es sollen ja auch mal icons vergeben werden
DirCreate( $favDir )

DirCreate( $favDir & "\Recent Files" )
DirCreate( $favDir & "\Recent Programs" )
DirCreate( $favDir & "\Recent Folders" )

DirCreate( $favDir & "\Favourite Folders" )
DirCreate( $favDir & "\Favourite Files" )

DirCreate( $favDir & "\Context Folders" )
DirCreate( $favDir & "\Context Files" )

DirCreate( $favDir & "\Temp Favourite Folders" )
DirCreate( $favDir & "\Temp Favourite Files" )

ConsoleWrite( @CRLF & @CRLF & Round( TimerDiff( $tic ) ) & " ms" & @CRLF & @CRLF  )

;~ 		Recent Places				{22877a6d-37a1-461a-91b0-dbda5aaebc99}  ; folders only


;~ ShellExecute( "explorer" , "shell:::{7be9d83c-a729-4d97-b5a7-1b7313c39e0a}" )

ShowFavsProgsMenu( "C:\" )
;~ ShowFavsProgsMenu( @DesktopDir & "\ControlPanel" )


;~ "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}" ; Systemsteuerung 1
;~ {26EE0668-A00A-44D7-9371-BEB064C98683}   ; Systemsteuerung 2

;; Frage: wie kann ich auch virtuelle Folder ( wie die systemsteuerung als menü umsetzen )  >> Unterfrage wo bekomme ich die PIDL her?
;~ http://stackoverflow.com/questions/14325953/why-would-the-pidl-for-the-control-panel-be-different


	; 2. versuch  >>  control panel CLSID, "::{26EE0668-A00A-44D7-9371-BEB064C98683}"  >> convert it to a PIDL with SHParseDisplayName().

	; _WinAPI_ShellGetKnownFolderIDList

While 1
	Sleep( 1000 )
WEnd


;~ _GUICtrlMenu_MapAccelerator



Func ShowFavsProgsMenu( $targetFolder , $xCoord  = "" , $yCoord  = "" , $pasteAndLeaveMode = 0 , $nFavouritesToShow = 1 )

	; $nFavouritesToShow = 0   >   keine Favouriten zeigen



	; 0 - PREPARE - ( define constants and vTables )
	#region PREPARE
	Global $NULL  = 0x0000, $S_FALSE = 0x00000001, $MAX_PATH = 260, $iIShellFolder = 0, $apIShellFolder[1], $aoIShellFolder[1]
	Global $hFavsProgsMenu , $oIMenuBand, $pIMenuBand = 0x0000, $hFavsProgsMenuMsg = 0x0000, $tFavsProgsMenuMsg, $hFavsProgsMenuMsgHook, $idFavsProgsMenuMsgUnHook = 0
	Global Const $dllOle32    = DllOpen( "ole32.dll"   )
	DllCall( $dllOle32 , "long", "OleInitialize", "ptr", 0)
	Global $tagMSG = "hwnd hwnd;uint message;wparam wParam;lparam lParam;dword time;int X;int Y"
	$IID_IShellMenuCallback =  "{4CA300A1-9B8D-11d1-8B22-00C04FD918D0}"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")  	; CLSID_MenuBand
	Global Const $tCLSID_MenuBand = $tCLSID
	Global Const $sCLSID_MenuBand = "{5B4DAE26-B807-11D0-9815-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuBand, "ptr", DllStructGetPtr($tCLSID))
	$tCLSID = DllStructCreate("dword;word;word;byte[8]") 	; CLSID_MenuDeskBar
	Global Const $sCLSID_MenuDeskBar = "{ECD4FC4F-521C-11D0-B792-00A0C90312E1}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuDeskBar, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tCLSID_MenuDeskBar = $tCLSID
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; CLSID_MenuBandSite
	Global Const $sCLSID_MenuBandSite = "{E13EF4E4-D2F2-11D0-9816-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuBandSite, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tCLSID_MenuBandSite = $tCLSID
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; IShellMenu
	Global Const $sIID_IShellMenu = "{EE1F7637-E138-11d1-8379-00C04FD918D0}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IShellMenu, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IShellMenu = $tCLSID
	Global Const $dtag_IShellMenu = "Initialize hresult(ptr;uint;uint;dword);GetMenuInfo hresult(ptr*;uint*;uint*;dword*);SetShellFolder hresult(ptr;ptr;handle;dword);GetShellFolder hresult(ptr*;ptr*;struct*;ptr*);" & _
	"Setmenu hresult(handle;hwnd;dword);GetMenu hresult(handle*;hwnd*;dword*);InvalidateItem hresult(ptr;dword);GetState hresult(ptr);SetMenuToolbar hresult(ptr*;dword);"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]") 	; IShellFolder
	Global Const $sIID_IShellFolder = "{000214E6-0000-0000-C000-000000000046}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IShellFolder, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IShellFolder = $tCLSID
	Global Const $dtag_IShellFolder = "ParseDisplayName hresult(hwnd;ptr;wstr;dword*;ptr*;dword*);EnumObjects hresult(hwnd;dword;ptr*);BindToObject hresult(ptr;ptr;struct*;ptr*);BindToStorage hresult(ptr;ptr;ptr;ptr*);" & _
	"CompareIDs hresult(lparam;ptr;ptr);CreateViewObject hresult(hwnd;struct*;ptr*);GetAttributesOf hresult(uint;struct*;ulong*);GetUIObjectOf hresult(hwnd;uint;struct*;struct*;uint*;ptr*);GetDisplayNameOf hresult(ptr;uint;struct*);SetNameOf hresult(hwnd;ptr;wstr;dword;ptr*);"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]") 	; IMenuPopup
	Global Const $sIID_IMenuPopup = "{D1E7AFEB-6A2E-11d0-8C78-00C04FD918B4}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IMenuPopup, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IMenuPopup = $tCLSID
	Global Const $dtag_IMenuPopup = 	"GetWindow hresult(hwnd);ContextSensitiveHelp hresult(bool);SetClient hresult(ptr);GetClient hresult(ptr*);OnPosRectChangeDB hresult(struct*);Popup hresult(struct*;struct*;dword);OnSelect hresult(dword);SetSubMenu hresult(ptr;bool);"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; IDeskBar
	Global Const $sIID_IDeskBar = "{EB0FE173-1A3A-11D0-89B3-00A0C90A90AC}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IDeskBar, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IDeskBar = $tCLSID
	Global Const $dtag_IDeskBar = "SetClient hresult(ptr);GetClient hresult(ptr*);OnPosRectChangeDB hresult(struct*);"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; IDeskBand
	Global Const $sIID_IDeskBand = "{EB0FE172-1A3A-11D0-89B3-00A0C90A90AC}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IDeskBand, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IDeskBand = $tCLSID
	Global Const $dtag_IDeskBand ="GetBandInfo hresult(dword;dword;struct*);"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; IUnknown
	Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IUnknown, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IUnknown = $tCLSID
	Global Const $dtag_IUnknown = "QueryInterface hresult(struct*;ptr*);AddRef ulong();Release ulong();"
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")	; IBandSite
	Global Const $sIID_IBandSite = "{4CF504B0-DE96-11D0-8B3F-00A0C911E8E5}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IBandSite, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IBandSite = $tCLSID
	Global Const $dtag_IBandSite = 	"AddBand hresult(ptr);EnumBands hresult(uint;dword*);QueryBand hresult(dword;ptr*;dword*;wstr;int);SetBandState hresult(dword;dword;dword);RemoveBand hresult(dword);GetBandObject hresult(dword;struct*;ptr*);SetBandSiteInfo hresult(ptr);GetBandSiteInfo hresult(ptr*);"											; BANDSITEINFO* pbsinfo
	$tCLSID = DllStructCreate("dword;word;word;byte[8]") 	; IMenuBand
	Global Const $sIID_IMenuBand = "{568804CD-CBD7-11d0-9816-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IMenuBand, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IMenuBand = $tCLSID
	Global Const $dtag_IMenuBand = "IsMenuMessage hresult(struct*);TranslateMenuMessage hresult(struct*;lresult*);"
    #endregion PREPARE



	; 1 - CREATE MAIN FOLDER - (IShellMenu)
	Local $oMainFolderMenu, $pIShellMenu , $CLSCTX_INPROC_SERVER = 0x1
	$pIShellMenu = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBand), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IShellMenu), "ptr*", 0 )
	$oMainFolderMenu = ObjCreateInterface( $pIShellMenu[5] , $sIID_IShellMenu, $dtag_IShellMenu )
	;~ 	$SMINIT_RESTRICT_DRAGDROP  = 0x00000002  ; Don't allow Drag and Drop  |	$SMINIT_TOPLEVEL = 0x00000004  ; This is the top band. | $SMSET_DONTOWN   = 0x00000001  ; The Menuband doesn't own the non-ref counted object
	Local $SMINIT_VERTICAL = 0x10000000, $ANCESTORDEFAULT  = 0xFFFFFFFF, $SMSET_USEBKICONEXTRACTION = 0x00000008 , $SMSET_TOP = 0x10000000 ,$SMINIT_TOPLEVEL  = 0x00000004  ,$SMSET_BOTTOM  = 0x20000000  ; Bias this namespace to the bottom of the menu
	$oMainFolderMenu.Initialize(  ObjCreateInterfaceEx( "oIShellMenuCallback_", "CallbackSM hresult(ptr;uint;wparam;lparam);", True ) , -1, $ANCESTORDEFAULT, BitOR( $SMINIT_TOPLEVEL, $SMINIT_VERTICAL ) ) ; Callback installieren



;~ 	$targetFolderPIDL = DllCall( "shell32.dll" , "uint", "SHILCreateFromPath", "wstr",   $targetFolder  , "ptr*", 0, "dword*", 0 )[ 2 ] ; set Folder




;~ 	$controlPanelGUID = "{5399E694-6CE5-4D6C-8FCE-1D8870FDCBA0}"
	$controlPanelGUID = "{26EE0668-A00A-44D7-9371-BEB064C98683}\1"
	$targetFolderPIDL =  _WinAPI_ShellGetSpecialFolderLocation( $controlPanelGUID )
	$oMainFolderMenu.SetShellFolder( $NULL , $targetFolderPIDL , $NULL , BitOR( $SMSET_BOTTOM, $SMSET_USEBKICONEXTRACTION ) )



;~ 	ShellExecute( "explorer" , "shell:::" & $controlPanelGUID )

;~ [\All Control Panel Items] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\0
;~ [\Appearance and Personalization] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\1
;~ [\Hardware and Sound] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\2
;~ [\Network and Internet] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\3
;~ [\System and Security] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\5
;~ [\Clock, Language, and Region] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\6
;~ [\Ease of Access] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\7
;~ [\Programs] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\8
;~ [\User Accounts and Family Safety] = ::{26EE0668-A00A-44D7-9371-BEB064C98683}\9




	; 2 - HIRARCHY  MAIN FOLDER -   (   IMenuPopup  >>  IDeskBar  >> IDeskBand  >>  IShellMenu )
    Local $pIMenuPopup, $pIDeskBar, $pIDeskBand
	$oMainFolderMenu.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup )
	$oIMenuPopup = ObjCreateInterface( $pIMenuPopup, $sIID_IMenuPopup, $dtag_IMenuPopup )
	$oIMenuPopup.QueryInterface( $tRIID_IDeskBar, $pIDeskBar )
	$oIDeskBar   = ObjCreateInterface( $pIDeskBar, $sIID_IDeskBar, $dtag_IDeskBar )
	$oIDeskBar.QueryInterface( $tRIID_IDeskBand, $pIDeskBand )
	$pIUnknown   = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuDeskBar), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IUnknown), "ptr*", 0 )
	$oIUnknown   = ObjCreateInterface( $pIUnknown[5] , $sIID_IUnknown, $dtag_IUnknown )
	$oIUnknown.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup )
	$oIMenuPopup = ObjCreateInterface( $pIMenuPopup, $sIID_IMenuPopup, $dtag_IMenuPopup )
	$pIBandSite  = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBandSite), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IBandSite), "ptr*", 0 )
	$oIBandSite  = ObjCreateInterface( $pIBandSite[5] , $sIID_IBandSite, $dtag_IBandSite )
	$oIMenuPopup.SetClient( $pIBandSite[5] ) ;                IBandSite  >>  IMenuPopup
	$oIBandSite.AddBand( $pIDeskBand )       ; IDeskBand  >>  IBandSite




	; 3 - CREATE APPENDIX - (IShellMenu)
	Local $oAppendixMenu, $pIShellMenu2 , $CLSCTX_INPROC_SERVER = 0x1
	$pIShellMenu2  = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBand), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IShellMenu), "ptr*", 0 )
	$oAppendixMenu = ObjCreateInterface( $pIShellMenu2[5] , $sIID_IShellMenu, $dtag_IShellMenu )
	;~ 	$SMINIT_RESTRICT_DRAGDROP  = 0x00000002  ; Don't allow Drag and Drop  |	$SMINIT_TOPLEVEL = 0x00000004  ; This is the top band. | $SMSET_DONTOWN   = 0x00000001  ; The Menuband doesn't own the non-ref counted object
	Local $SMINIT_VERTICAL = 0x10000000, $ANCESTORDEFAULT  = 0xFFFFFFFF, $SMSET_USEBKICONEXTRACTION = 0x00000008 , $SMSET_TOP = 0x10000000 ,$SMINIT_TOPLEVEL  = 0x00000004  ,$SMSET_BOTTOM  = 0x20000000  ; Bias this namespace to the bottom of the menu
	$oAppendixMenu.Initialize(  ObjCreateInterfaceEx( "oIShellMenuCallback2_", "CallbackSM hresult(ptr;uint;wparam;lparam);", True ) , -1, $ANCESTORDEFAULT, BitOR( $SMINIT_TOPLEVEL, $SMINIT_VERTICAL ) ) ; Callback installieren
	$r = DllCall( "shell32.dll" , "uint", "SHILCreateFromPath", "wstr",     "C:\windows\"    , "ptr*", 0, "dword*", 0 ) ; set Folder
	$oAppendixMenu.SetShellFolder( $NULL , $r[2] , $NULL , BitOR( $SMSET_BOTTOM, $SMSET_USEBKICONEXTRACTION ) )



	; 4 - HIRARCHY  APPENDIX -   (   IMenuPopup  >>  IDeskBar  >> IDeskBand  >>  IShellMenu )
    Local $pIMenuPopup2, $pIDeskBar2, $pIDeskBand2
	$oAppendixMenu.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup2 )
	$oIMenuPopup2 = ObjCreateInterface( $pIMenuPopup2, $sIID_IMenuPopup, $dtag_IMenuPopup )
	$oIMenuPopup2.QueryInterface( $tRIID_IDeskBar, $pIDeskBar2 )
	$oIDeskBar2 = ObjCreateInterface( $pIDeskBar2, $sIID_IDeskBar, $dtag_IDeskBar )
	$oIDeskBar2.QueryInterface( $tRIID_IDeskBand, $pIDeskBand2 )
	$pIUnknown2 = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuDeskBar), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IUnknown), "ptr*", 0 )
	$oIUnknown2 = ObjCreateInterface( $pIUnknown2[5] , $sIID_IUnknown, $dtag_IUnknown )
	$oIUnknown2.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup2 )
	$oIMenuPopup2 = ObjCreateInterface( $pIMenuPopup2, $sIID_IMenuPopup, $dtag_IMenuPopup )
	$pIBandSite2 = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBandSite), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IBandSite), "ptr*", 0 )
	$oIBandSite2 = ObjCreateInterface( $pIBandSite2[5] , $sIID_IBandSite, $dtag_IBandSite )
	$oIMenuPopup2.SetClient( $pIBandSite2[5] ) ; IBandSite  >>  IMenuPopup
	$oIBandSite2.AddBand( $pIDeskBand2 )       ; IDeskBand  >>  IBandSite



	; 2 - APPEND  -   ( ...to exsiting menu = optional )
	$hWnd   = GUICreate( "" )
	$hMenu  = _GUICtrlMenu_CreatePopup()
    _GUICtrlMenu_InsertMenuItem( $hMenu , 0 , "&custom command 2" , 55 )
    _GUICtrlMenu_InsertMenuItem( $hMenu , 0 , "&custom command 1" , 55 )
 	_GUICtrlMenu_AddMenuItem(  $hMenu  , ""  ) ; Separator
	_GUICtrlMenu_AddMenuItem(  $hMenu  , ""  )
	$oMainFolderMenu.SetMenu( $hMenu, $hWnd, $SMSET_TOP )
;~ 	$oAppendixMenu.SetMenu(   $hMenu, $hWnd, $SMSET_TOP )


	; 4 - SHOW    -  ( position )
	; Flags > IMenuPopup::Popup method
	Global Enum _
		$MPPF_SETFOCUS			= 0x1, _		; The menu should have focus when it appears.
		$MPPF_INITIALSELECT	    = 0x2, _		; The first item in the menu should be selected.
		$MPPF_NOANIMATE			= 0x4, _		; Do not animate this show.
		$MPPF_KEYBOARD			= 0x10, _		; The menu is activated by the keyboard.
		$MPPF_REPOSITION		= 0x20, _		; Reposition the displayed bar.
		$MPPF_FORCEZORDER		= 0x40, _		; The menu bar should ignore submenu positions.
		$MPPF_FINALSELECT		= 0x80, _		; The last item in the menu should be selected.
		$MPPF_TOP				= 0x20000000, _	; Display the pop-up menu above the point specified in ppt.
		$MPPF_LEFT				= 0x40000000, _	; Display the pop-up menu to the left of the point specified in ppt.
		$MPPF_RIGHT				= 0x60000000, _	; Display the pop-up menu to the right of the point specified in ppt.
		$MPPF_BOTTOM			= 0x80000000, _	; Display the pop-up menu below the point specified in ppt.
		$MPPF_POS_MASK			= 0xE0000000, _	; Mask for position values MPPF_TOP, MPPF_LEFT, and MPPF_RIGHT.
		$MPPF_ALIGN_LEFT		= 0x2000000, _	; Default alignment.
		$MPPF_ALIGN_RIGHT		= 0x4000000		; The pop-up menu should be aligned to the right of the excluded rectangle specified by prcExclude.

	if $xCoord  = "" Then    ; falls keine Position gegeben > am Mauszeiger erstellen
		$xCoord = MouseGetPos( 0 )
		$yCoord = MouseGetPos( 1 )
	EndIf
	Local $tPOINT = DllStructCreate( $tagPOINT )
	DllStructSetData( $tPOINT, "X", $xCoord )
	DllStructSetData( $tPOINT, "Y", $yCoord )
	Local $tRECT = DllStructCreate( $tagRECT )
	DllStructSetData( $tRECT, "Left", $xCoord )
	DllStructSetData( $tRECT, "Top", $yCoord+1 )
	DllStructSetData( $tRECT, "Right", $xCoord )
	DllStructSetData( $tRECT, "Bottom", $yCoord+1 )
	$oIMenuPopup.Popup( $tPOINT, $tRECT, $MPPF_ALIGN_RIGHT )
;~ 	$oIMenuPopup2.Popup( $tPOINT, $tRECT, $MPPF_ALIGN_RIGHT )
;~ 	$oIMenuPopup2.SetSubMenu( $oIMenuPopup , 1 )



	; 5 - MESSAGE HOOK  - ( messages to expand the submenus and other user interaction )
	Local $oIDeskBand
	$oIDeskBand = ObjCreateInterface( $pIDeskBand, $sIID_IDeskBand, $dtag_IDeskBand )
	$oIDeskBand.QueryInterface( $tRIID_IMenuBand, $pIMenuBand )
	$oIMenuBand = ObjCreateInterface( $pIMenuBand, $sIID_IMenuBand, $dtag_IMenuBand )
	If $idFavsProgsMenuMsgUnHook = 0 Then $idFavsProgsMenuMsgUnHook = GUICtrlCreateDummy()
	$hFavsProgsMenuMsg = DllCallbackRegister( "FavsProgsMenuMsg", "long", "int;wparam;lparam" )
	$hFavsProgsMenuMsgHook = _WinAPI_SetWindowsHookEx( $WH_MSGFILTER, DllCallbackGetPtr( $hFavsProgsMenuMsg ), 0, _WinAPI_GetCurrentThreadId() )




;;;;;;;;;;;;;;;;;;;;;;; EXPERIMENTE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;~     $iIndex = _GUICtrlMenu_FindItem( $hMenu , "DOKUMENTE")
;~     MsgBox(4096, "Information", "Index for Help Menu: " & $iIndex)

;~ 	ConsoleWrite(     _GUICtrlMenu_GetItemText( $hMenu , 0)     )

;~ 	Sleep( 1000 )

;~ 	$hToolbar = ControlGetHandle(  WinGetHandle( "[CLASS:BaseBar" ) , "" , "[CLASS:ToolbarWindow32; INSTANCE:1]" )
;~ 	ConsoleWrite( "Handle: " & $hToolbar   )


;~ 	$oMainFolderMenu.GetShellFolder( $NULL, $r[2], $NULL, BitOR( $SMSET_BOTTOM, $SMSET_USEBKICONEXTRACTION ) )


;~ 	local $hPopupWin
;~ 	$oIMenuPopup.GetWindow( $hPopupWin )
;~ 	ConsoleWrite( @CRLF & "Handle: " & $hPopupWin  &  @CRLF )

;~ 	local $LPSMDATA
;~ 	$oMainFolderMenu.GetState( $hMenu, $hWnd, $SMSET_TOP )


;~ 	$oMainFolderMenu.GetShellFolder( $hMenu, $hWnd, $SMSET_TOP )

;~ GetShellFolder(
;~   [out]  DWORD *pdwFlags,
;~   [out]  PCIDLIST_ABSOLUTE *pidlFolder,
;~   [in]   REFIID riid,
;~   [out]  void **ppv
;~ );


	; IShellMenu = _
;~ 	"Initialize hresult(ptr;uint;uint;dword);" & _
;~ 	"GetMenuInfo hresult(ptr*;uint*;uint*;dword*);" & _
;~ 	"SetShellFolder hresult(ptr;ptr;handle;dword);" & _
;~ 	"GetShellFolder hresult(ptr*;ptr*;struct*;ptr*);" & _
;~ 	"Setmenu hresult(handle;hwnd;dword);" & _
;~ 	"GetMenu hresult(handle*;hwnd*;dword*);" & _
;~ 	"InvalidateItem hresult(ptr;dword);" & _
;~ 	"GetState hresult(ptr);" & _
;~ 	"SetMenuToolbar hresult(ptr*;dword);"

	; IMenuPopup
;~ 	"GetWindow hresult(hwnd);" & _								; HWND* phwnd
;~ 	"ContextSensitiveHelp hresult(bool);" & _			; BOOL fEnterMode
;~ 	"SetClient hresult(ptr);" & _									; IUnknown* punkClient
;~ 	"GetClient hresult(ptr*);" & _								; IUnknown** ppunkClient
;~ 	"OnPosRectChangeDB hresult(struct*);" & _			; LPRECT prc
;~ 	"Popup hresult(struct*;struct*;dword);" & _		; POINTL* ppt, RECTL* prcExclude, MP_POPUPFLAGS dwFlags
;~ 	"OnSelect hresult(dword);" & _								; DWORD dwSelectType
;~ 	"SetSubMenu hresult(ptr;bool);"								; IMenuPopup* pmp, BOOL fSet



;;;;;;;;;;;;;;;;;;;;;;; EXPERIMENTE ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


	Return 0


EndFunc



Func FavsProgsMenuMsg( $nCode, $wParam, $lParam )

;~ 	If $nCode <=  0 Then Return
;~ 	ConsoleWrite( $nCode & @CRLF )

	If $pIMenuBand Then  ; Falls das Menü noch existiert > Windowmessages auswerten

		$tFavsProgsMenuMsg = DllStructCreate( $tagMSG, $lParam )
		$msg = DllStructGetData( $tFavsProgsMenuMsg, "message" )
		if $msg = $WM_NULL OR $msg = $WM_PAINT OR $msg = $WM_TIMER  OR $msg = 0x0118 OR ( $msg > $WM_MOUSEFIRST AND $msg < $WM_XBUTTONDBLCLK ) Then  Return False	; 0x0118 ~ WM_SYSTIMER

		; TRANSLATE MESSAGE ( menü auffordern, die Nachricht auszuwerten )
		$i = $oIMenuBand.IsMenuMessage( $tFavsProgsMenuMsg )
		If $i >= 0 Then
			$tLRESULT = DllStructCreate( "lresult" )
			If $oIMenuBand.TranslateMenuMessage( $tFavsProgsMenuMsg, $tLRESULT ) = $S_OK Then Return True
		ElseIf $i = $E_FAIL Then
			; The menu has exited the menu mode and can be destroyed
			$pIMenuBand = $NULL
			Return False
		EndIf
		Return False


	Else; Falls das Menü nicht mehr existiert

		If $hFavsProgsMenuMsg <> $NULL Then

		_GUICtrlMenu_DestroyMenu( $hFavsProgsMenu )
		_WinAPI_UnhookWindowsHookEx( $hFavsProgsMenuMsgHook )
;~ 		DllCallbackFree( $hFavsProgsMenuMsg )  ; Aufhänger, grund unbekannt

		EndIf

		Return False

	EndIf


EndFunc





	Func ObjCreateInterfaceEx( $sFunctionPrefix, $dtag_Interface, $fNoUnknown = False )
	; ObjCreateInterfaceEx creates custom object defined with "dtag" interface description string.
	; Main purpose of this function is to create custom objects that serve as event handlers for other objects.
	; Registered callback functions (defined methods) are left for AutoIt to free at its convenience on exit.

		; Original is _AutoItObject_ObjectFromDtag in AutoItObject.au3 by the AutoItObject-Team
		; (http://www.autoitscript.com/forum/index.php?showtopic=110379, v1.2.8.3 in post 302)
		; Modified by Ward (http://www.autoitscript.com/forum/index.php?showtopic=138372)

		If $fNoUnknown Then $dtag_Interface = "QueryInterface hresult(ptr;ptr*);AddRef ulong();Release ulong();" & $dtag_Interface ; Inherits from IUnknown
		Local $sMethods = StringTrimRight(StringReplace(StringRegExpReplace($dtag_Interface, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF), 1)
		If $sMethods = $dtag_Interface Then $sMethods = StringTrimRight(StringReplace(StringRegExpReplace($dtag_Interface, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF), 1)
		$sMethods = StringReplace(StringReplace(StringReplace(StringReplace($sMethods, "object", "idispatch", 0, 1), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr")

		Local $aMethods = StringSplit($sMethods, @LF, 3)
		Local $iUbound = UBound($aMethods)
		Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams, $hCallback

		Local $PtrSize = DllStructGetSize(DllStructCreate("ptr", 1))
		Local $AllocSize = $PtrSize * ($iUbound + 1)
		Local $AllocPtr = _WinAPI_CoTaskMemAlloc( $AllocSize )
		If @error Or $AllocPtr = 0 Then Return SetError(1, 0, 0)

		Local $tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]", $AllocPtr)
		If @error Then Return SetError(1, 0, 0)
		For $i = 0 To $iUbound - 1
			$aSplit = StringSplit($aMethods[$i], "|", 2)
			If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
			$sNamePart = $aSplit[0]
			$sTagPart = $aSplit[1]
			$sMethod = $sFunctionPrefix & $sNamePart
			$aTagPart = StringSplit($sTagPart, ";", 2)
			$sRet = $aTagPart[0]
			$sParams = StringReplace($sTagPart, $sRet, "", 1)
			$sParams = "ptr" & $sParams
			$hCallback = Eval(":Callback:" & $sMethod)
			If Not $hCallback Then
				$hCallback = DllCallbackRegister($sMethod, $sRet, $sParams)
				Assign(":Callback:" & $sMethod, $hCallback, 2)
			EndIf
			DllStructSetData($tInterface, 1, DllCallbackGetPtr($hCallback), $i + 2)
		Next
		DllStructSetData($tInterface, 1, $AllocPtr + $PtrSize) ; Interface method pointers are actually pointer size away
		Return $AllocPtr
	EndFunc



	Func SHGetPathFromIDList( $pidl, ByRef $sPath )
		Local $stPath = DllStructCreate( "wchar[" & $MAX_PATH & "]" )
		Local $aRet = DllCall( "shell32.dll", "int", "SHGetPathFromIDListW", "ptr", $pidl, "ptr", DllStructGetPtr( $stPath ) )
		If @error Then Return SetError(1, 0, 0)
		$sPath = DllStructGetData( $stPath, 1 )
		Return $aRet[0]
	EndFunc



	Func StrRetToBuf( $pSTRRET, $pidl, ByRef $sBuf, $iBuf = 512 )
		Local $aRet = DllCall( "shlwapi.dll", "long", "StrRetToBufW", "ptr", $pSTRRET, "ptr", $pidl, "wstr", $sBuf, "uint", $iBuf )
		If @error Then Return SetError(1, 0, 0)
		$sBuf = $aRet[3]
		Return $aRet[0]
	EndFunc





#region CALLBACK


	Func oIShellMenuCallback_CallbackSM( $pSelf, $psmd, $uMsg, $wParam, $lParam )

		;ConsoleWrite( "oIShellMenuCallback_CallbackSM" & @CRLF )
		Local $pIShellFolder, $oIShellFolder


		; SMC_XXX messages and notifications
		;~ 	$SMC_INITMENU                = 0x00000001
		;~ 	$SMC_CREATE                  = 0x00000002
		;~ 	$SMC_EXITMENU                = 0x00000003
		;~ 	$SMC_GETINFO                 = 0x00000005
		;~ 	$SMC_GETSFINFO               = 0x00000006
		;~ 	$SMC_GETOBJECT               = 0x00000007
		;~ 	$SMC_GETSFOBJECT             = 0x00000008
		;~ 	$SMC_SFEXEC                  = 0x00000009
			$SMC_SFSELECTITEM            = 0x0000000A
		;~ 	$SMC_REFRESH                 = 0x00000010
		;~ 	$SMC_DEMOTE                  = 0x00000011
		;~ 	$SMC_PROMOTE                 = 0x00000012
		;~ 	$SMC_DEFAULTICON             = 0x00000016
		;~ 	$SMC_NEWITEM                 = 0x00000017
		;~ 	$SMC_CHEVRONEXPAND           = 0x00000019
		;~ 	$SMC_DISPLAYCHEVRONTIP       = 0x0000002A
		;~ 	$SMC_SETSFOBJECT             = 0x0000002D
		;~ 	$SMC_SHCHANGENOTIFY          = 0x0000002E
		;~ 	$SMC_CHEVRONGETTIP           = 0x0000002F
		;~ 	$SMC_SFDDRESTRICTED          = 0x00000030
		;~ 	$SMC_SFEXEC_MIDDLE           = 0x00000031
		;~ 	$SMC_GETAUTOEXPANDSTATE      = 0x00000041
		;~ 	$SMC_AUTOEXPANDCHANGE        = 0x00000042
		;~ 	$SMC_GETCONTEXTMENUMODIFIER  = 0x00000043
		;~ 	$SMC_GETBKCONTEXTMENU        = 0x00000044
		;~ 	$SMC_OPEN                    = 0x00000045


			$SHGDN_NORMAL 	     = 0x0000
		;~ 	$SHGDN_INFOLDER      = 0x0001
		;~  $SHGDN_FOREDITING    = 0x1000
		;~ 	$SHGDN_FORADDRESSBAR = 0x4000
		;~ 	$SHGDN_FORPARSING    = 0x8000

		Switch $uMsg

				Case $SMC_SFSELECTITEM  ;SESESESESESESESESESESESESESESESESESE   SELECTED  SESESESESESESESESESESESESESESESESESESESESESE

					$tagSMDATA = "dword dwMask;dword dwFlags;handle hmenu;hwnd hwnd;uint uId;uint UIDParent;uint uIdAncestor;ptr punk;ptr pidlFolder;ptr pidlItem;ptr psf;ptr pvUserData" 	; SMDATA struct
					Local $tSMDATA = DllStructCreate( $tagSMDATA, $psmd )
					; New IShellFolder interface?
					$pIShellFolder = DllStructGetData( $tSMDATA, "psf" )
					For $i = 0 To $iIShellFolder - 1
						If $pIShellFolder = $apIShellFolder[$i] Then ExitLoop
					Next
					If $i < $iIShellFolder Then
						$oIShellFolder = $aoIShellFolder[$i]
					Else
						If Mod( $iIShellFolder, 10 ) = 0 Then
							ReDim $apIShellFolder[$iIShellFolder+10]
							ReDim $aoIShellFolder[$iIShellFolder+10]
						EndIf
						$apIShellFolder[$iIShellFolder] = $pIShellFolder
						$oIShellFolder = ObjCreateInterface( $pIShellFolder, $sIID_IShellFolder, $dtag_IShellFolder )
						$aoIShellFolder[$iIShellFolder] = $oIShellFolder
						$iIShellFolder += 1
					EndIf
					; Parent folder
					Local $pParentFolder = DllStructGetData( $tSMDATA, "pidlFolder" ), $sPath
					SHGetPathFromIDList( $pParentFolder, $sPath )
					; Current file or folder

					Local $tSTRRET = DllStructCreate( "uint uType;ptr data;" ), $sName
					$oIShellFolder.GetDisplayNameOf( DllStructGetData( $tSMDATA, "pidlItem" ), $SHGDN_NORMAL, $tSTRRET )
					StrRetToBuf( DllStructGetPtr( $tSTRRET ), $NULL, $sName )

					; Full path

					$fullPath = StringReplace(  $sPath & "\" & $sName , "\\" , "\"  )
					ConsoleWrite( $fullPath & @CRLF )

					Return $S_FALSE

			Case Else

				Return $S_FALSE
		EndSwitch

	EndFunc


	Func oIShellMenuCallback_QueryInterface( $pSelf, $pRIID, $pObj )
		Return $E_NOTIMPL
	EndFunc

	Func oIShellMenuCallback_AddRef( $pSelf )  ; neues Untermenü erstellen
		ConsoleWrite( "oIShellMenuCallback_AddRef" & @CRLF )
	    $iIShellMenuCallback_Ref = 0
		$iIShellMenuCallback_Ref += 1
		Return $iIShellMenuCallback_Ref
	EndFunc

	Func oIShellMenuCallback_Release( $pSelf )
		ConsoleWrite( "oIShellMenuCallback_Release" & @CRLF )
	    $iIShellMenuCallback_Ref = 0
		$iIShellMenuCallback_Ref -= 1
		Return $iIShellMenuCallback_Ref
	EndFunc


#endregion CALLBACK




#region CALLBACK


	Func oIShellMenuCallback2_CallbackSM( $pSelf, $psmd, $uMsg, $wParam, $lParam )

		;ConsoleWrite( "oIShellMenuCallback_CallbackSM" & @CRLF )
		Local $pIShellFolder, $oIShellFolder


		; SMC_XXX messages and notifications
		;~ 	$SMC_INITMENU                = 0x00000001
		;~ 	$SMC_CREATE                  = 0x00000002
		;~ 	$SMC_EXITMENU                = 0x00000003
		;~ 	$SMC_GETINFO                 = 0x00000005
		;~ 	$SMC_GETSFINFO               = 0x00000006
		;~ 	$SMC_GETOBJECT               = 0x00000007
		;~ 	$SMC_GETSFOBJECT             = 0x00000008
		;~ 	$SMC_SFEXEC                  = 0x00000009
			$SMC_SFSELECTITEM            = 0x0000000A
		;~ 	$SMC_REFRESH                 = 0x00000010
		;~ 	$SMC_DEMOTE                  = 0x00000011
		;~ 	$SMC_PROMOTE                 = 0x00000012
		;~ 	$SMC_DEFAULTICON             = 0x00000016
		;~ 	$SMC_NEWITEM                 = 0x00000017
		;~ 	$SMC_CHEVRONEXPAND           = 0x00000019
		;~ 	$SMC_DISPLAYCHEVRONTIP       = 0x0000002A
		;~ 	$SMC_SETSFOBJECT             = 0x0000002D
		;~ 	$SMC_SHCHANGENOTIFY          = 0x0000002E
		;~ 	$SMC_CHEVRONGETTIP           = 0x0000002F
		;~ 	$SMC_SFDDRESTRICTED          = 0x00000030
		;~ 	$SMC_SFEXEC_MIDDLE           = 0x00000031
		;~ 	$SMC_GETAUTOEXPANDSTATE      = 0x00000041
		;~ 	$SMC_AUTOEXPANDCHANGE        = 0x00000042
		;~ 	$SMC_GETCONTEXTMENUMODIFIER  = 0x00000043
		;~ 	$SMC_GETBKCONTEXTMENU        = 0x00000044
		;~ 	$SMC_OPEN                    = 0x00000045


			$SHGDN_NORMAL 	     = 0x0000
		;~ 	$SHGDN_INFOLDER      = 0x0001
		;~  $SHGDN_FOREDITING    = 0x1000
		;~ 	$SHGDN_FORADDRESSBAR = 0x4000
		;~ 	$SHGDN_FORPARSING    = 0x8000

		Switch $uMsg

				Case $SMC_SFSELECTITEM  ;SESESESESESESESESESESESESESESESESESE   SELECTED  SESESESESESESESESESESESESESESESESESESESESESE

					$tagSMDATA = "dword dwMask;dword dwFlags;handle hmenu;hwnd hwnd;uint uId;uint UIDParent;uint uIdAncestor;ptr punk;ptr pidlFolder;ptr pidlItem;ptr psf;ptr pvUserData" 	; SMDATA struct
					Local $tSMDATA = DllStructCreate( $tagSMDATA, $psmd )
					; New IShellFolder interface?
					$pIShellFolder = DllStructGetData( $tSMDATA, "psf" )
					For $i = 0 To $iIShellFolder - 1
						If $pIShellFolder = $apIShellFolder[$i] Then ExitLoop
					Next
					If $i < $iIShellFolder Then
						$oIShellFolder = $aoIShellFolder[$i]
					Else
						If Mod( $iIShellFolder, 10 ) = 0 Then
							ReDim $apIShellFolder[$iIShellFolder+10]
							ReDim $aoIShellFolder[$iIShellFolder+10]
						EndIf
						$apIShellFolder[$iIShellFolder] = $pIShellFolder
						$oIShellFolder = ObjCreateInterface( $pIShellFolder, $sIID_IShellFolder, $dtag_IShellFolder )
						$aoIShellFolder[$iIShellFolder] = $oIShellFolder
						$iIShellFolder += 1
					EndIf
					; Parent folder
					Local $pParentFolder = DllStructGetData( $tSMDATA, "pidlFolder" ), $sPath
					SHGetPathFromIDList( $pParentFolder, $sPath )
					; Current file or folder

					Local $tSTRRET = DllStructCreate( "uint uType;ptr data;" ), $sName
					$oIShellFolder.GetDisplayNameOf( DllStructGetData( $tSMDATA, "pidlItem" ), $SHGDN_NORMAL, $tSTRRET )
					StrRetToBuf( DllStructGetPtr( $tSTRRET ), $NULL, $sName )

					; Full path

					$fullPath = StringReplace(  $sPath & "\" & $sName , "\\" , "\"  )
					ConsoleWrite( $fullPath & @CRLF )

					Return $S_FALSE

			Case Else

				Return $S_FALSE
		EndSwitch

	EndFunc


	Func oIShellMenuCallback2_QueryInterface( $pSelf, $pRIID, $pObj )
		Return $E_NOTIMPL
	EndFunc

	Func oIShellMenuCallback2_AddRef( $pSelf )  ; neues Untermenü erstellen
		ConsoleWrite( "oIShellMenuCallback2_AddRef" & @CRLF )
	    $iIShellMenuCallback_Ref = 0
		$iIShellMenuCallback_Ref += 1
		Return $iIShellMenuCallback_Ref
	EndFunc

	Func oIShellMenuCallback2_Release( $pSelf )
		ConsoleWrite( "oIShellMenuCallback2_Release" & @CRLF )
	    $iIShellMenuCallback_Ref = 0
		$iIShellMenuCallback_Ref -= 1
		Return $iIShellMenuCallback_Ref
	EndFunc


#endregion CALLBACK