#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiRichEdit.au3>
#include <SendMessage.au3>

Global Const $NULL = 0x0000
Global Const $EM_GETOLEINTERFACE = 1084

; STGM Constants
Global Const $STGM_READ = 0x00000000							; Access
Global Const $STGM_WRITE = 0x00000001
Global Const $STGM_READWRITE = 0x00000002
Global Const $STGM_SHARE_DENY_NONE = 0x00000040		; Sharing
Global Const $STGM_SHARE_DENY_READ = 0x00000030
Global Const $STGM_SHARE_DENY_WRITE = 0x00000020
Global Const $STGM_SHARE_EXCLUSIVE = 0x00000010
Global Const $STGM_PRIORITY = 0x00040000
Global Const $STGM_CREATE = 0x00001000						; Creation
Global Const $STGM_CONVERT = 0x00020000
Global Const $STGM_FAILIFTHERE = 0x00000000
Global Const $STGM_DIRECT = 0x00000000						; Transactioning
Global Const $STGM_TRANSACTED = 0x00010000
Global Const $STGM_NOSCRATCH = 0x00100000					; Transactioning Performance
Global Const $STGM_NOSNAPSHOT = 0x00200000
Global Const $STGM_SIMPLE = 0x08000000						; Direct SWMR and Simple
Global Const $STGM_DIRECT_SWMR = 0x00400000
Global Const $STGM_DELETEONRELEASE = 0x04000000		; Delete On Release

; FORMATETC structure
Global Const $tagFORMATETC = "uint cfFormat;ptr ptd;uint dvaspect;long lindex;dword tymed"

; DVASPECT enumeration values
Global Enum _
	$DVASPECT_CONTENT    = 1, _
	$DVASPECT_THUMBNAIL  = 2, _
	$DVASPECT_ICON       = 4, _
	$DVASPECT_DOCPRINT   = 8

; TYMED enumeration values
Global Enum _
	$TYMED_HGLOBAL      =  1, _
	$TYMED_FILE         =  2, _
	$TYMED_ISTREAM      =  4, _
	$TYMED_ISTORAGE     =  8, _
	$TYMED_GDI          = 16, _
	$TYMED_MFPICT       = 32, _
	$TYMED_ENHMF        = 64, _
	$TYMED_NULL         =  0

; OLERENDER enumeration constants 
Global Enum _
	$OLERENDER_NONE   = 0, _
	$OLERENDER_DRAW   = 1, _
	$OLERENDER_FORMAT = 2, _
	$OLERENDER_ASIS   = 3

; CLSID structure
Global Const $tagCLSID = "dword Data1;word Data2;word Data3;byte Data4[8]"

; REOBJECT (RichEdit) structure
Global Const $tagREOBJECT = "dword cbStruct;long cp;" & $tagCLSID & ";ptr pIOleObject;ptr pIStorage;ptr pIOleClientSite;" & _
														"long x;long y;dword dvaspect;dword dwFlags;dword dwUser"
; cp & dwFlags constants
Global Const $REO_NULL = 0x0
Global Const $REO_BELOWBASELINE = 0x2				; Object sits below the baseline of the surrounding text; the default is to sit on the baseline.
Global Const $REO_BLANK = 0x10							; Object is new. This value gives the object an opportunity to save nothing and be deleted from the control automatically.
;Global Const $REO_DONTUSEPALETTE = 				; Object is rendered before the creation and realization of a half-tone palette. Applies to 32-bit platforms only.
Global Const $REO_DYNAMICSIZE = 0x8					; Object always determines its extents and may change despite the modify flag being turned off.
Global Const $REO_GETMETAFILE = 0x400000		; The rich edit control retrieved the metafile from the object to correctly determine the object's extents. This flag can be read but not set.
Global Const $REO_HILITED = 0x1000000				; Object is currently highlighted to indicate selection. Occurs when focus is in the control and REO_SELECTED is set. This flag can be read but not set.
Global Const $REO_INPLACEACTIVE = 0x2000000	; Object is currently inplace active. This flag can be read but not set.
Global Const $REO_INVERTEDSELECT = 0x4			; Object is to be drawn entirely inverted when selected; the default is to be drawn with a border.
Global Const $REO_LINK = 0x80000000					; Object is a link. This flag can be read but not set.
Global Const $REO_LINKAVAILABLE = 0x800000	; Object is a link and is believed to be available. This flag can be read but not set.
Global Const $REO_OPEN = 0x4000000					; Object is currently open in its server. This flag can be read but not set.
Global Const $REO_RESIZABLE = 0x1						; Object may be resized.
Global Const $REO_SELECTED = 0x8000000			; Object is currently selected in the rich edit control. This flag can be read but not set.
Global Const $REO_STATIC = 0x40000000				; Object is a static object. This flag can be read but not set.
Global Const $REO_CP_SELECTION = 0xFFFFFFFF	; The selection is replaced with the specified object
Global Const $REO_READWRITEMASK = 0x3F
Global Const $REO_DONTNEEDPALETTE = 0x20
Global Const $REO_IOB_SELECTION = 0xFFFFFFFF

; INULL Interface
Global Const $sIID_INULL = "{00000000-0000-0000-0000-000000000000}"
Global Const $tRIID_INULL = CLSIDFromString( $sIID_INULL )

; IUnknown Interface
Global Const $sIID_IUnknown = "{00000000-0000-0000-C000-000000000046}"
Global Const $tRIID_IUnknown = CLSIDFromString( $sIID_IUnknown )
Global Const $dtagIUnknown = _
	"QueryInterface hresult(struct*;ptr*);" & _	; Returns pointers to supported interfaces.
	"AddRef ulong();" & _												; Increments reference count.
	"Release ulong();"													; Decrements reference count.

; IRichEditOle Interface
Global Const $sIID_IRichEditOle = "{00020d00-0000-0000-c000-000000000046}"
Global Const $tRIID_IRichEditOle = CLSIDFromString( $sIID_IRichEditOle )
Global Const $dtagIRichEditOle = _
	"GetClientSite hresult(ptr*);" & _									; Retrieves an IOleClientSite interface to use when creating a new object. 
	"GetObjectCount long();" & _												; Returns the number of objects contained in a rich edit control. 
	"GetLinkCount long();" & _													; Returns the number of objects in a rich edit control that are links. 
	"GetObject hresult(long;struct*;dword);" & _				; Returns information from a REOBJECT structure about an object in a rich edit control. 
	"InsertObject hresult(struct*);" & _								; Inserts an object into a rich edit control. 
	"ConvertObject hresult(long;struct*;ptr);" & _			; Converts an object to a new type. 
	"ActivateAs hresult(struct*;struct*);" & _					; Unloads objects of the old class, telling OLE to treat those objects as objects of the new class, and reloading the objects. 
	"SetHostNames hresult(wstr;wstr);" & _							; Sets the "host names" to be given to objects as they are inserted to a rich edit control. 
	"SetLinkAvailable hresult(long;int);" & _						; Sets the value of the link available bit in the object's flags. 
	"SetDvaspect hresult(long;dword);" & _							; Sets the aspect that a rich edit control uses to draw an object. 
	"HandsOffStorage hresult(long);" & _								; Tells a rich edit control to release its reference to the storage interface associated with the specified object. 
	"SaveCompleted hresult(long;ptr);" & _							; Tells a rich edit control that the most recent save operation has been completed, and that it should hold on to a different storage for the object. 
	"InPlaceDeactivate hresult();" & _									; Tells a rich edit control to deactivate the currently active in-place object, if any. 
	"ContextSensitiveHelp hresult(int);" & _						; Tells a rich edit control to transition into or out of context-sensitive help mode. 
	"GetClipboardData hresult(struct*;dword;ptr*);" & _	; Retrieves a clipboard object for a range in an edit control. 
	"ImportDataObject hresult(ptr;int;handle);"					; Imports a clipboard object into a rich edit control, replacing the current selection. 

; IOleObject Interface
Global Const $sIID_IOleObject = "{00000112-0000-0000-C000-000000000046}"
Global Const $tRIID_IOleObject = CLSIDFromString( $sIID_IOleObject )
Global Const $dtagIOleObject = _
	"SetClientSite hresult(ptr*);" & _											; Informs object of its client site in container.
	"GetClientSite hresult(ptr*);" & _											; Retrieves object's client site.
	"SetHostNames hresult(wstr;wstr);" & _									; Communicates names of container application and container document.
	"Close hresult(dword);" & _															; Moves object from running to loaded state.
	"SetMoniker hresult(dword;ptr*);" & _										; Informs object of its moniker.
	"GetMoniker hresult(dword;dword;ptr*);" & _							; Retrieves object's moniker.
	"InitFromData hresult(ptr*;int;dword);" & _							; Initializes embedded object from selected data.
	"GetClipboardData hresult(dword;ptr*);" & _							; Retrieves a data transfer object from the Clipboard.
	"DoVerb hresult(long;struct*;ptr*;long;hwnd;ptr);" & _	; Invokes object to perform one of its enumerated actions ("verbs").
	"EnumVerbs hresult(ptr*);" & _													; Enumerates actions ("verbs") for an object.
	"Update hresult();" & _																	; Updates an object.
	"IsUpToDate hresult();" & _															; Checks if object is up to date.
	"GetUserClassID hresult(struct*);" & _									; Returns an object's class identifier.
	"GetUserType hresult(dword;ptr*);" & _									; Retrieves object's user-type name.
	"SetExtent hresult(dword;ptr*);" & _										; Sets extent of object's display area.
	"GetExtent hresult();" & _															; Retrieves extent of object's display area.
	"Advise hresult(ptr*;dword*);" & _											; Establishes advisory connection with object.
	"Unadvise hresult(dword);" & _													; Destroys advisory connection with object.
	"EnumAdvise hresult(ptr*);" & _													; Enumerates object's advisory connections.
	"GetMiscStatus hresult(dword;dword*);" & _							; Retrieves status of object.
	"SetColorScheme hresult(struct*);"											; Recommends color scheme to object application.

Opt( "MustDeclareVars", 1 )

MainScript()

Func MainScript()

	Local $hGui, $hRichEdit, $idButton

	$hGui = GUICreate( "ObjCreateInterface Example", 500, 380 )

	$hRichEdit = _GUICtrlRichEdit_Create( $hGui, "", 10,10,480,300, _
		BitOR( $ES_MULTILINE, $WS_VSCROLL, $ES_AUTOVSCROLL ) )

	$idButton = GUICtrlCreateButton("InsertObject", 10,320,200,50 )
	GUICtrlSetFont(-1,18,600)

	GUISetState()

	InsertObject( $hRichEdit, @ScriptDir & "\Image.bmp" )

	While True
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				_GUICtrlRichEdit_Destroy( $hRichEdit )
				Exit
			Case $idButton
				Local $var = FileOpenDialog( "", @MyDocumentsDir & "\","All (*.*)", 1 + 4 )
				if Not @error Then InsertObject( $hRichEdit, $var )
		EndSwitch
	WEnd

EndFunc

Func InsertObject( $hRichEdit, $pszFileName )

	; 1. Get the IRichEditOle interface
	Local $pIRichEditOle = _SendMessage( $hRichEdit, $EM_GETOLEINTERFACE, 0, 0, 4, "wparam", "ptr*" )
	Local $IRichEditOle = ObjCreateInterface( $pIRichEditOle, $sIID_IRichEditOle, $dtagIRichEditOle )

	; 2. Create structured storage
	Local $pILockBytes, $pIStorage
	CreateILockBytesOnHGlobal( $NULL, True, $pILockBytes )
	StgCreateDocfileOnILockBytes( $pILockBytes, BitOR($STGM_SHARE_EXCLUSIVE,$STGM_CREATE,$STGM_READWRITE), $pIStorage )

	; 3. Set up the data format
	Local $tFORMATETC = DllStructCreate( $tagFORMATETC )
	DllStructSetData( $tFORMATETC, "cfFormat", 0 )
	DllStructSetData( $tFORMATETC, "ptd", $NULL )
	DllStructSetData( $tFORMATETC, "dvaspect", $DVASPECT_CONTENT )
	DllStructSetData( $tFORMATETC, "lindex", -1 )
	DllStructSetData( $tFORMATETC, "tymed", $TYMED_NULL )

	; 4. Get a pointer to the display site
	Local $pIOleClientSite
	$IRichEditOle.GetClientSite( $pIOleClientSite )

	; 5. Create the object and retrieve its IUnknown interface
	Local $pIUnknown, $IUnknown
	OleCreateFromFile( $pszFileName, $tRIID_IUnknown, $OLERENDER_DRAW, $tFORMATETC, $pIOleClientSite, $pIStorage, $pIUnknown )
	$IUnknown = ObjCreateInterface( $pIUnknown, $sIID_IUnknown, $dtagIUnknown )

	; 6. Get the IOleObject interface to the object
	Local $pIOleObject, $IOleObject
	$IUnknown.QueryInterface( $tRIID_IOleObject, $pIOleObject )
	$IOleObject = ObjCreateInterface( $pIOleObject, $sIID_IOleObject, $dtagIOleObject )

	; 7. To ensure that references are counted correctly, notify the object that it is contained
	OleSetContainedObject( $pIOleObject, True )

	; 8. Set up RichEdit object info
	Local $tREOBJECT = DllStructCreate( $tagREOBJECT ), $clsid = $tRIID_INULL
	DllStructSetData( $tREOBJECT, "cbStruct", DllStructGetSize( $tREOBJECT ) )		; Structure size
	DllStructSetData( $tREOBJECT, "cp", $REO_CP_SELECTION )												; The selection is replaced with the specified object
	$IOleObject.GetUserClassID( $clsid )
	DllStructSetData( $tREOBJECT, "Data1", DllStructGetData( $clsid, "Data1" ) )	; The REOBJECT structure contains a CLSID structure,
	DllStructSetData( $tREOBJECT, "Data2", DllStructGetData( $clsid, "Data2" ) )	; a class identifier of the object
	DllStructSetData( $tREOBJECT, "Data3", DllStructGetData( $clsid, "Data3" ) )
	DllStructSetData( $tREOBJECT, "Data4", DllStructGetData( $clsid, "Data4" ) )
	DllStructSetData( $tREOBJECT, "pIOleObject", $pIOleObject )
	DllStructSetData( $tREOBJECT, "pIStorage", $pIStorage )
	DllStructSetData( $tREOBJECT, "pIOleClientSite", $pIOleClientSite )
	DllStructSetData( $tREOBJECT, "x", 0 )																				; (x,y) = (0,0) on insertion indicates that
	DllStructSetData( $tREOBJECT, "y", 0 )																				; an object is free to determine its size.
	DllStructSetData( $tREOBJECT, "dvaspect", $DVASPECT_CONTENT )									; Provides a representation of an object so it can be displayed as an embedded object inside of a container
	DllStructSetData( $tREOBJECT, "dwFlags", BitOR($REO_RESIZABLE,$REO_BELOWBASELINE) )
	DllStructSetData( $tREOBJECT, "dwUser", 0 )

	; 9. Move the caret to the end of the text and add a carriage return
	_SendMessage( $hRichEdit, $EM_SETSEL, 0, -1 )
	Local $aRet = _SendMessage( $hRichEdit, $EM_GETSEL, 0, 0, -1, "dword*", "dword*" )
	Local $dwStart = $aRet[3], $dwEnd = $aRet[4]
	_SendMessage( $hRichEdit, $EM_SETSEL, $dwEnd+1, $dwEnd+1 )
	_SendMessage( $hRichEdit, $EM_REPLACESEL, TRUE, @CRLF, 0, "bool", "wstr" )

	; 10. Insert the object
	$IRichEditOle.InsertObject( $tREOBJECT )

EndFunc
	
; Copied from AutoItObject.au3 by
; the AutoItObject team / Prog@ndy.
Func CLSIDFromString($sString)
	Local $tCLSID = DllStructCreate($tagCLSID)
	Local $aRet = DllCall("Ole32.dll", "long", "CLSIDFromString", "wstr", $sString, "ptr", DllStructGetPtr($tCLSID))
	If @error Then Return SetError(1, @error, 0)
	If $aRet[0] <> 0 Then Return SetError(2, $aRet[0], 0)
	Return $tCLSID
EndFunc

Func CreateILockBytesOnHGlobal( $hGlobal, $fDeleteOnRelease, ByRef $pILockBytes )
	Local $aRet = DllCall( "Ole32.dll", "long", "CreateILockBytesOnHGlobal", "ptr", $hGlobal, "bool", $fDeleteOnRelease, "ptr*", 0 )
	If @error Then Return SetError(1, 0, 0)
	$pILockBytes = $aRet[3]
	Return $aRet[0]
EndFunc

Func StgCreateDocfileOnILockBytes( $pILockBytes, $grfMode, ByRef $pIStorage )
	Local $aRet = DllCall( "Ole32.dll", "long", "StgCreateDocfileOnILockBytes", "ptr", $pILockBytes, "dword", $grfMode, "dword", 0, "ptr*", 0 )
	If @error Then Return SetError(1, 0, 0)
	$pIStorage = $aRet[4]
	Return $aRet[0]
EndFunc

Func OleCreateFromFile( $lpszFileName, $tRIID, $renderopt, $tFORMATETC, $pClientSite, $pStorage, ByRef $ppvObj )
	Local $aRet = DllCall( "Ole32.dll", "long", "OleCreateFromFile", "ptr", DllStructGetPtr( $tRIID_INULL ), "wstr", $lpszFileName, _
												 "ptr", DllStructGetPtr( $tRIID_IUnknown ), "dword", $renderopt, "ptr", DllStructGetPtr( $tFORMATETC ), _
												 "ptr", $pClientSite, "ptr", $pStorage, "ptr*", 0 )
	If @error Then Return SetError(1, 0, 0)
	$ppvObj = $aRet[8]
	Return $aRet[0]
EndFunc

Func OleSetContainedObject( $pIUnknown, $fContained )
	Local $aRet = DllCall( "Ole32.dll", "long", "OleSetContainedObject", "ptr", $pIUnknown, "bool", $fContained )
	If @error Then Return SetError(1, 0, 0)
	Return $aRet[0]
EndFunc
