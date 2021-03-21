
#include-once
#include <GuiMenu.au3>
#include "APIConstants.au3"
#include "WinAPIEx.au3"


HotKeySet( "{ESC}" , "_exit" )
Func _exit()
	Exit
EndFunc


ShowFavsProgsMenu( "C:\" )


While 1
	Sleep( 1000 )
WEnd


Func ShowFavsProgsMenu( $targetFolder , $xCoord  = "" , $yCoord  = "" )



	; 0 - PREPARE - ( define constants and vTables )
	#region PREPARE


	; Dynamic Link Libraries
	Global Const $dllOle32    = DllOpen( "ole32.dll" )
	Global Const $dllShell32  = DllOpen( "shell32.dll" )
	Global Const $dllUser32   = DllOpen( "user32.dll" )

	; Initialize COM
	DllCall($dllOle32, "long", "OleInitialize", "ptr", 0)


	; --- Global variables ---

	Global $hFavsProgsMenu , $oIMenuBand, $pIMenuBand = 0x0000, $S_OK = 0


	; Favorites/Programs menu messages
	Global $hFavsProgsMenuMsg = 0x0000, $tFavsProgsMenuMsg
	Global $hFavsProgsMenuMsgHook, $idFavsProgsMenuMsgUnHook = 0

	Global Const $NULL = 0x0000

	; Flag used with CoCreateInstance
	Global Const $CLSCTX_INPROC_SERVER = 0x1

	; Flags >IShellMenu
	Global Const $SMINIT_DEFAULT            = 0x00000000  ; No Options
	Global Const $SMINIT_RESTRICT_DRAGDROP  = 0x00000002  ; Don't allow Drag and Drop
	Global Const $SMINIT_TOPLEVEL           = 0x00000004  ; This is the top band.
	Global Const $SMINIT_CACHED             = 0x00000010
	Global Const $SMINIT_VERTICAL           = 0x10000000  ; This is a vertical menu
	Global Const $SMINIT_HORIZONTAL         = 0x20000000  ; This is a horizontal menu (does not inherit)
	Global Const $ANCESTORDEFAULT           = 0xFFFFFFFF  ; dword(-1);
	Global Const $SMSET_TOP                 = 0x10000000  ; Bias this namespace to the top of the menu
	Global Const $SMSET_BOTTOM              = 0x20000000  ; Bias this namespace to the bottom of the menu
	Global Const $SMSET_DONTOWN             = 0x00000001  ; The Menuband doesn't own the non-ref counted object
	Global Const $SMSET_USEBKICONEXTRACTION = 0x00000008

	; dwFlags > IMenuPopup::Popup method
	Global Enum _
		$MPPF_SETFOCUS						= 0x1, _		; The menu should have focus when it appears.
		$MPPF_INITIALSELECT				    = 0x2, _		; The first item in the menu should be selected.
		$MPPF_NOANIMATE						= 0x4, _		; Do not animate this show.
		$MPPF_KEYBOARD						= 0x10, _		; The menu is activated by the keyboard.
		$MPPF_REPOSITION					= 0x20, _		; Reposition the displayed bar.
		$MPPF_FORCEZORDER					= 0x40, _		; The menu bar should ignore submenu positions.
		$MPPF_FINALSELECT					= 0x80, _		; The last item in the menu should be selected.
		$MPPF_TOP							= 0x20000000, _	; Display the pop-up menu above the point specified in ppt.
		$MPPF_LEFT							= 0x40000000, _	; Display the pop-up menu to the left of the point specified in ppt.
		$MPPF_RIGHT							= 0x60000000, _	; Display the pop-up menu to the right of the point specified in ppt.
		$MPPF_BOTTOM						= 0x80000000, _	; Display the pop-up menu below the point specified in ppt.
		$MPPF_POS_MASK						= 0xE0000000, _	; Mask for position values MPPF_TOP, MPPF_LEFT, and MPPF_RIGHT.
		$MPPF_ALIGN_LEFT					= 0x2000000, _	; Default alignment.
		$MPPF_ALIGN_RIGHT					= 0x4000000		; The pop-up menu should be aligned to the right of the excluded rectangle specified by prcExclude.

	Global $tagMSG = "hwnd hwnd;uint message;wparam wParam;lparam lParam;dword time;int X;int Y"

	; CLSID_MenuBand
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sCLSID_MenuBand = "{5B4DAE26-B807-11D0-9815-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuBand, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tCLSID_MenuBand = $tCLSID

	; CLSID_MenuDeskBar
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sCLSID_MenuDeskBar = "{ECD4FC4F-521C-11D0-B792-00A0C90312E1}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuDeskBar, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tCLSID_MenuDeskBar = $tCLSID

	; CLSID_MenuBandSite
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sCLSID_MenuBandSite = "{E13EF4E4-D2F2-11D0-9816-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sCLSID_MenuBandSite, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tCLSID_MenuBandSite = $tCLSID

	; IShellMenu Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IShellMenu = "{EE1F7637-E138-11d1-8379-00C04FD918D0}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IShellMenu, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IShellMenu = $tCLSID
	Global Const $dtag_IShellMenu = _
		"Initialize hresult(ptr;uint;uint;dword);" & _
		"GetMenuInfo hresult(ptr*;uint*;uint*;dword*);" & _
		"SetShellFolder hresult(ptr;ptr;handle;dword);" & _
		"GetShellFolder hresult(ptr*;ptr*;struct*;ptr*);" & _
		"Setmenu hresult(handle;hwnd;dword);" & _
		"GetMenu hresult(handle*;hwnd*;dword*);" & _
		"InvalidateItem hresult(ptr;dword);" & _
		"GetState hresult(ptr);" & _
		"SetMenuToolbar hresult(ptr*;dword);"

	; IShellFolder Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IShellFolder = "{000214E6-0000-0000-C000-000000000046}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IShellFolder, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IShellFolder = $tCLSID
	Global Const $dtag_IShellFolder = _
		"ParseDisplayName hresult(hwnd;ptr;wstr;dword*;ptr*;dword*);" & _
		"EnumObjects hresult(hwnd;dword;ptr*);" & _
		"BindToObject hresult(ptr;ptr;struct*;ptr*);" & _
		"BindToStorage hresult(ptr;ptr;ptr;ptr*);" & _
		"CompareIDs hresult(lparam;ptr;ptr);" & _
		"CreateViewObject hresult(hwnd;struct*;ptr*);" & _
		"GetAttributesOf hresult(uint;struct*;ulong*);" & _
		"GetUIObjectOf hresult(hwnd;uint;struct*;struct*;uint*;ptr*);" & _
		"GetDisplayNameOf hresult(ptr;uint;struct*);" & _
		"SetNameOf hresult(hwnd;ptr;wstr;dword;ptr*);"

	; IMenuPopup Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IMenuPopup = "{D1E7AFEB-6A2E-11d0-8C78-00C04FD918B4}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IMenuPopup, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IMenuPopup = $tCLSID
	Global Const $dtag_IMenuPopup = _
		"GetWindow hresult(hwnd);" & _								; HWND* phwnd
		"ContextSensitiveHelp hresult(bool);" & _			; BOOL fEnterMode
		"SetClient hresult(ptr);" & _									; IUnknown* punkClient
		"GetClient hresult(ptr*);" & _								; IUnknown** ppunkClient
		"OnPosRectChangeDB hresult(struct*);" & _			; LPRECT prc
		"Popup hresult(struct*;struct*;dword);" & _		; POINTL* ppt, RECTL* prcExclude, MP_POPUPFLAGS dwFlags
		"OnSelect hresult(dword);" & _								; DWORD dwSelectType
		"SetSubMenu hresult(ptr;bool);"								; IMenuPopup* pmp, BOOL fSet

	; IDeskBar Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IDeskBar = "{EB0FE173-1A3A-11D0-89B3-00A0C90A90AC}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IDeskBar, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IDeskBar = $tCLSID
	Global Const $dtag_IDeskBar = _
		"SetClient hresult(ptr);" & _									; IUnknown* punkClient
		"GetClient hresult(ptr*);" & _								; IUnknown** ppunkClient
		"OnPosRectChangeDB hresult(struct*);"					; LPRECT prc

	; IDeskBand Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IDeskBand = "{EB0FE172-1A3A-11D0-89B3-00A0C90A90AC}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IDeskBand, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IDeskBand = $tCLSID
	Global Const $dtag_IDeskBand = _
		"GetBandInfo hresult(dword;dword;struct*);"		; DWORD dwBandID, DWORD dwViewMode, DESKBANDINFO* pdbi

	; IUnknown Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IUnknown, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IUnknown = $tCLSID
	Global Const $dtag_IUnknown = _
		"QueryInterface hresult(struct*;ptr*);" & _	; REFIID iid, void** ppvObject		; Returns pointers to supported interfaces.
		"AddRef ulong();" & _												; void														; Increments reference count.
		"Release ulong();"													; void														; Decrements reference count.

	; IBandSite Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IBandSite = "{4CF504B0-DE96-11D0-8B3F-00A0C911E8E5}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IBandSite, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IBandSite = $tCLSID
	Global Const $dtag_IBandSite = _
		"AddBand hresult(ptr);" & _														; IUnknown* punk
		"EnumBands hresult(uint;dword*);" & _									; UINT uBand, DWORD* pdwBandID
		"QueryBand hresult(dword;ptr*;dword*;wstr;int);" & _	; DWORD dwBandID, IDeskBand** ppstb, DWORD* pdwState, LPWSTR pszName, int cchName
		"SetBandState hresult(dword;dword;dword);" & _				; DWORD dwBandID, DWORD dwMask, DWORD dwState
		"RemoveBand hresult(dword);" & _											; DWORD dwBandID
		"GetBandObject hresult(dword;struct*;ptr*);" & _			; DWORD dwBandID, REFIID riid, VOID** ppv
		"SetBandSiteInfo hresult(ptr);" & _										; BANDSITEINFO* pbsinfo
		"GetBandSiteInfo hresult(ptr*);"											; BANDSITEINFO* pbsinfo

	; IMenuBand Interface
	$tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Global Const $sIID_IMenuBand = "{568804CD-CBD7-11d0-9816-00C04FD91972}"
	DllCall( $dllOle32 , "long", "CLSIDFromString", "wstr", $sIID_IMenuBand, "ptr", DllStructGetPtr($tCLSID))
	Global Const $tRIID_IMenuBand = $tCLSID
	Global Const $dtag_IMenuBand = _
		"IsMenuMessage hresult(struct*);" & _								; MSG* pmsg
		"TranslateMenuMessage hresult(struct*;lresult*);"		; MSG* pmsg, LRESULT* plRet


	#endregion  PREPARE



	; 1 - CREATE  - (IShellMenu)
	Local $oIShellMenu, $pIShellMenu
	$aRet = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBand), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IShellMenu), "ptr*", 0 )
	$pIShellMenu = $aRet[5]




	$oIShellMenu = ObjCreateInterface( $pIShellMenu, $sIID_IShellMenu, $dtag_IShellMenu )

	$pIShellMenuCallback = $NULL   ;( TODO !!!!  = Events abfangen, die das Menü feuert )
	$oIShellMenu.Initialize( $NULL, -1, $ANCESTORDEFAULT, BitOR( $SMINIT_TOPLEVEL, $SMINIT_VERTICAL ) )

	$r = DllCall( $dllShell32, "uint", "SHILCreateFromPath", "wstr", $targetFolder, "ptr*", 0, "dword*", 0 ) ; set Folder
	$oIShellMenu.SetShellFolder( $NULL, $r[2], $NULL, BitOR( $SMSET_BOTTOM, $SMSET_USEBKICONEXTRACTION ) )



	; 2 - APPEND  -   ( ...to exsiting menu = optional )
	$hWnd   = GUICreate("")
	$hMenu  = _GUICtrlMenu_CreatePopup()
    _GUICtrlMenu_InsertMenuItem( $hMenu , 0 , "&Open" , 55 )
	_GUICtrlMenu_AddMenuItem(  $hMenu  , ""  )
	_GUICtrlMenu_AddMenuItem(  $hMenu  , ""  )
	$oIShellMenu.SetMenu( $hMenu, $hWnd, $SMSET_TOP )



	; 3 - HIRARCHY  -   (   IMenuPopup  >>  IDeskBar  >> IDeskBand  >>  IShellMenu )
	Local $pIMenuPopup, $pIDeskBar, $pIDeskBand
	$oIShellMenu.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup )
	$oIMenuPopup = ObjCreateInterface( $pIMenuPopup, $sIID_IMenuPopup, $dtag_IMenuPopup )
	$oIMenuPopup.QueryInterface( $tRIID_IDeskBar, $pIDeskBar )
	$oIDeskBar = ObjCreateInterface( $pIDeskBar, $sIID_IDeskBar, $dtag_IDeskBar )
	$oIDeskBar.QueryInterface( $tRIID_IDeskBand, $pIDeskBand )
	Local $oIUnknown, $pIUnknown, $oIMenuPopup, $pIMenuPopup
	$aRet = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuDeskBar), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IUnknown), "ptr*", 0 )
	$pIUnknown = $aRet[5]






	$oIUnknown = ObjCreateInterface( $pIUnknown, $sIID_IUnknown, $dtag_IUnknown )
	$oIUnknown.QueryInterface( $tRIID_IMenuPopup, $pIMenuPopup )
	$oIMenuPopup = ObjCreateInterface( $pIMenuPopup, $sIID_IMenuPopup, $dtag_IMenuPopup )
	Local $oIBandSite, $pIBandSite
	$aRet = DllCall( $dllOle32, "long_ptr", "CoCreateInstance", "ptr", DllStructGetPtr($tCLSID_MenuBandSite), "ptr", $NULL, "dword", $CLSCTX_INPROC_SERVER, "ptr", DllStructGetPtr($tRIID_IBandSite), "ptr*", 0 )
	$pIBandSite = $aRet[5]



	$oIBandSite = ObjCreateInterface( $pIBandSite, $sIID_IBandSite, $dtag_IBandSite )
	$oIMenuPopup.SetClient( $pIBandSite )  	 ; IDeskBar   >>  IBandSite
	$oIBandSite.AddBand( $pIDeskBand )       ; IBandSite  >>  IDeskBand





	; X - SHOW    -  ( position )
	if $xCoord  = "" Then
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




	; X - MESSAGE HOOK  - ( messages to expand the submenus and other user interaction )
	Local $oIDeskBand
	$oIDeskBand = ObjCreateInterface( $pIDeskBand, $sIID_IDeskBand, $dtag_IDeskBand )
	$oIDeskBand.QueryInterface( $tRIID_IMenuBand, $pIMenuBand )
	$oIMenuBand = ObjCreateInterface( $pIMenuBand, $sIID_IMenuBand, $dtag_IMenuBand )
	If $idFavsProgsMenuMsgUnHook = 0 Then $idFavsProgsMenuMsgUnHook = GUICtrlCreateDummy()
	$hFavsProgsMenuMsg = DllCallbackRegister( "FavsProgsMenuMsg", "long", "int;wparam;lparam" )
	$hFavsProgsMenuMsgHook = _WinAPI_SetWindowsHookEx( $WH_MSGFILTER, DllCallbackGetPtr( $hFavsProgsMenuMsg ), 0, _WinAPI_GetCurrentThreadId() )


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


