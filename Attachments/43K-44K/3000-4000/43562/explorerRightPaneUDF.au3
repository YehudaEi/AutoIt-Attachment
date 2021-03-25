#include "WinAPIEx.au3"
global $hHook, $oIShellView, $hGui
HotKeySet("{ESC}", "_Exit")
Func _Exit()
	_WinAPI_UnhookWindowsHookEx( $hHook )
	$oIShellView = 0
    Exit
EndFunc



explorerRightPane()



While Sleep(  1000 )
WEnd



Func explorerRightPane( $path = @ScriptDir , $x = 100 , $y = 100 , $width = 500 , $height = 500)

	Global $hExplorer, $pIShellBrowser, $pICommDlgBrowser = 0, $pIServiceProvider = 0, $oIDesktopFolder, $oIHomeFolder, $oIShellFolder, $oIShellView

	; CONSTANTS
	global $sIID_IServiceProvider = "{6D5140C1-7436-11CE-8034-00AA006009FA}"
	$dtag_IServiceProvider = "QueryService hresult(ptr;ptr;ptr*);"
	$tagMSG = "hwnd hwnd;uint message;wparam wParam;lparam lParam;dword time;int X;int Y"
	global $sIID_ICommDlgBrowser = "{000214F1-0000-0000-C000-000000000046}"
	$dtag_ICommDlgBrowser = "OnDefaultCommand hresult(ptr);OnStateChange hresult(ptr;ulong);IncludeObject hresult(ptr;ptr);"
	$dtag_IOleWindow = "GetWindow hresult(hwnd*);ContextSensitiveHelp hresult(int);"
	$sIID_IShellFolder = "{000214E6-0000-0000-C000-000000000046}"
	$tRIID_IShellFolder = _WinAPI_GUIDFromString( $sIID_IShellFolder )
	$dtag_IShellFolder = "ParseDisplayName hresult(hwnd;ptr;wstr;ulong*;ptr*;ulong*);EnumObjects hresult(hwnd;dword;ptr*);BindToObject hresult(ptr;ptr;clsid;ptr*);BindToStorage hresult(ptr;ptr;clsid;ptr*);" & _
	"CompareIDs hresult(lparam;ptr;ptr);CreateViewObject hresult(hwnd;clsid;ptr*);GetAttributesOf hresult(uint;struct*;ulong*);GetUIObjectOf hresult(hwnd;uint;struct*;clsid;uint*;ptr*);GetDisplayNameOf hresult(ptr;dword;struct*);SetNameOf hresult(hwnd;ptr;wstr;dword;ptr*);"
	$sIID_IShellBrowser = "{000214E2-0000-0000-C000-000000000046}"
	$dtag_IShellBrowser = $dtag_IOleWindow &"InsertMenusSB hresult(handle;ptr);SetMenuSB hresult(handle;handle;hwnd);RemoveMenusSB hresult(handle);SetStatusTextSB hresult(ptr);EnableModelessSB hresult(int);" & _
	"TranslateAcceleratorSB hresult(ptr;word);BrowseObject hresult(ptr;uint);GetViewStateStream hresult(dword;ptr*);GetControlWindow hresult(uint;hwnd);SendControlMsg hresult(uint;uint;wparam;lparam;lresult);" & _
	"QueryActiveShellView hresult(ptr*);OnViewWindowActive hresult(ptr);SetToolbarItems hresult(ptr;uint;uint);"
	$sIID_IShellView = "{000214E3-0000-0000-C000-000000000046}"
	$tRIID_IShellView = _WinAPI_GUIDFromString( $sIID_IShellView )
	$dtag_IShellView = $dtag_IOleWindow & "TranslateAccelerator hresult(ptr);EnableModeless hresult(int);UIActivate hresult(uint);Refresh hresult();CreateViewWindow hresult(ptr;ptr;ptr;ptr;hwnd*);DestroyViewWindow hresult();" & _
	"GetCurrentInfo hresult(ptr*);AddPropertySheetPages hresult(dword;ptr;lparam);SaveViewState hresult();SelectItem hresult(ptr;uint);GetItemObject hresult(uint;struct*;ptr*);"
	$tagFOLDERSETTINGS = "uint ViewMode;uint fFlags"
	DllCall("ole32.dll", "long", "OleInitialize", "ptr", 0)


	; GUI ( Wrapper )
	$hGui       = GUICreate( "" , $width, $height, $x, $y) ;  $WS_POPUP = 0x80000000
	GUISetState( @SW_SHOW, $hGui )
	Local $hMessageFilter ; , $hHook 	; Catch window messages
	$hMessageFilter = DllCallbackRegister( "boxCallbacks", "long", "int;wparam;lparam" )
	$hHook = _WinAPI_SetWindowsHookEx( $WH_GETMESSAGE , DllCallbackGetPtr( $hMessageFilter ) , 0 , _WinAPI_GetCurrentThreadId() )


	; START DIR + SIZE
	Local $pDesktopFolder
	$aRet = DllCall( "shell32.dll", "uint", "SHGetDesktopFolder", "ptr*", 0 )
	$pDesktopFolder = $aRet[1]
	$oIDesktopFolder = ObjCreateInterface( $pDesktopFolder, $sIID_IShellFolder, $dtag_IShellFolder )
	; $oIDesktopFolder is used in oIShellBrowser_BrowseObject because the PIDLs are absolute
	; PIDLs. This means that they are relative to the Desktop (and not the parent folder).
	Local $pParentFolder, $pidlRel, $pFolder
	Local $aRet = DllCall( "shell32.dll", "ptr", "ILCreateFromPathW", "wstr", $path )
	$pPidlHome =  $aRet[0]
	Local $aRet = DllCall( "shell32.dll", "long", "SHBindToParent", "ptr", $pPidlHome, "ptr", DllStructGetPtr( $tRIID_IShellFolder ), "ptr*", 0, "ptr*", 0 )
	$pParentFolder = $aRet[3]
	$pidlRel = $aRet[4]
	$oIShellFolder = ObjCreateInterface( $pParentFolder, $sIID_IShellFolder, $dtag_IShellFolder ) ; Parent folder
	$oIShellFolder.BindToObject( $pidlRel, 0x00000000 , $tRIID_IShellFolder, $pFolder )  ;  $NULL    = 0x00000000
	$oIShellFolder = ObjCreateInterface( $pFolder, $sIID_IShellFolder, $dtag_IShellFolder )       ; @ScriptDir
	Local $aPos  = WinGetClientSize( $hGui )
	Local $tRECT = DllStructCreate( $tagRECT )
	DllStructSetData( $tRECT , "Left"   , 0 )
	DllStructSetData( $tRECT , "Top"    , 0 )
	DllStructSetData( $tRECT , "Right"  , $aPos[0] )
	DllStructSetData( $tRECT , "Bottom" , $aPos[1] )



	; RIGHT PANE
	Local $pShellView
	$oIShellFolder.CreateViewObject( $hGui, $tRIID_IShellView, $pShellView )
	$oIShellView     = ObjCreateInterface( $pShellView, $sIID_IShellView, $dtag_IShellView )

	;;;;;;;;;;;;;;;;  ObjCreateInterfaceEx  ;;;;;;;;;;;;;;;
	$dtag_IShellBrowser = "QueryInterface hresult(ptr;ptr*);AddRef ulong();Release ulong();" & $dtag_IShellBrowser ; Inherits from IUnknown
	Local $sMethods = StringTrimRight(StringReplace(StringRegExpReplace($dtag_IShellBrowser, "\h*(\w+)\h*(\w+\*?)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF), 1)
	If $sMethods = $dtag_IShellBrowser Then $sMethods = StringTrimRight(StringReplace(StringRegExpReplace($dtag_IShellBrowser, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF), 1)
	$sMethods = StringReplace(StringReplace(StringReplace(StringReplace($sMethods, "object", "idispatch", 0, 1), "variant*", "ptr"), "hresult", "long"), "bstr", "ptr")
	Local $aMethods = StringSplit($sMethods, @LF, 3)
	Local $iUbound = UBound($aMethods)
	Local $sMethod, $aSplit, $sNamePart, $aTagPart, $sTagPart, $sRet, $sParams, $hCallback
	Local $PtrSize = DllStructGetSize(DllStructCreate("ptr", 1))
	Local $AllocSize = $PtrSize * ($iUbound + 1)
	Local $Ret = DllCall('ole32.dll', 'ptr', 'CoTaskMemAlloc', 'uint_ptr', $AllocSize)
	$AllocPtr =  $Ret[0]
	If @error Or $AllocPtr = 0 Then Return SetError(1, 0, 0)
	Local $tInterface = DllStructCreate("ptr[" & $iUbound + 1 & "]", $AllocPtr)
	If @error Then Return SetError(1, 0, 0)
	For $i = 0 To $iUbound - 1
		$aSplit = StringSplit($aMethods[$i], "|", 2)
		If UBound($aSplit) <> 2 Then ReDim $aSplit[2]
		$sNamePart = $aSplit[0]
		$sTagPart = $aSplit[1]
		$sMethod = "oIShellBrowser_" & $sNamePart
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
	$pIShellBrowser =  $AllocPtr
    ;;;;;;;;;;;;;;;;  ObjCreateInterfaceEx  ;;;;;;;;;;;;;;;




	$tFOLDERSETTINGS = DllStructCreate( $tagFOLDERSETTINGS )
	DllStructSetData( $tFOLDERSETTINGS, "ViewMode", 1            )
	DllStructSetData( $tFOLDERSETTINGS, "fFlags"  , 0x00800000   ) ;$FWF_NOCOLUMNHEADER  = 0x00800000 > sorgt auch für frei verschiebbare Elemente
	$r = $oIShellView.CreateViewWindow( 0x00000000 , DllStructGetPtr( $tFOLDERSETTINGS ), $pIShellBrowser, DllStructGetPtr( $tRECT ), $hExplorer )    ;  $NULL    = 0x00000000
	ConsoleWrite( $r )
	$oIShellView.UIActivate( 1 )  ; $SVUIA_ACTIVATE_NOFOCUS = 1


EndFunc




;;;;;;;;;;;;;;;;;;;; CALLBACKS FÜR "IShellBrowser" ( funktioniert nicht ohne, machen aber nichts ) ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Func oIShellBrowser_GetWindow( $pSelf, $hExplorer )
	DllStructSetData( DllStructCreate( "hwnd", $hExplorer ) , 1 , $hGui ) ; belege den DLL-Struct mit dem zugehörigen windowhandle ( $hExplorer ist der Pointer der auf dass DLL struct zeigen muss )
EndFunc
Func oIShellBrowser_QueryInterface( $pSelf, $pRIID, $pObj )
	Return 0x80004002  ;  $E_NOINTERFACE = 0x80004002
EndFunc
Func oIShellBrowser_AddRef( $pSelf )
EndFunc
Func oIShellBrowser_Release( $pSelf )
EndFunc
Func oIShellBrowser_ContextSensitiveHelp( $pSelf, $fEnterMode )
EndFunc
Func oIShellBrowser_InsertMenusSB( $pSelf, $hmenuShared, $lpMenuWidths )
EndFunc
Func oIShellBrowser_SetMenuSB( $pSelf, $hmenuShared, $holemenuRes, $hwndActiveObject )
EndFunc
Func oIShellBrowser_RemoveMenusSB( $pSelf, $hmenuShared )
EndFunc
Func oIShellBrowser_SetStatusTextSB( $pSelf, $lpszStatusText )
EndFunc
Func oIShellBrowser_EnableModelessSB( $pSelf, $fEnable )
EndFunc
Func oIShellBrowser_TranslateAcceleratorSB( $pSelf, $lpmsg, $wID )
EndFunc
Func oIShellBrowser_BrowseObject( $pSelf, $pidl, $wFlags )
EndFunc
Func oIShellBrowser_GetViewStateStream( $pSelf, $grfMode, $ppStrm )
EndFunc
Func oIShellBrowser_GetControlWindow( $pSelf, $id, $lphwnd )
EndFunc
Func oIShellBrowser_SendControlMsg( $pSelf, $id, $uMsg, $wParam, $lParam, $pret )
EndFunc
Func oIShellBrowser_QueryActiveShellView( $pSelf, $ppshv )
EndFunc
Func oIShellBrowser_OnViewWindowActive( $pSelf, $ppshv )
EndFunc
Func oIShellBrowser_SetToolbarItems( $pSelf, $lpButtons, $nButtons, $uFlags )
EndFunc
