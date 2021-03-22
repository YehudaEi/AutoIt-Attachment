#include-once

Global Const $dllShlwapi = DllOpen( "shlwapi.dll" )

Global Const $NULL = 0x0000
Global Const $S_FALSE = 0x00000001
Global Const $MAX_PATH = 260

Global $iIShellFolder = 0, $apIShellFolder[1], $aoIShellFolder[1]

; IShellFolder interface
Global Const $sIID_IShellFolder = "{000214E6-0000-0000-C000-000000000046}"
Global Const $tRIID_IShellFolder = CLSIDFromString( $sIID_IShellFolder )
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

Global Enum $SHGDN_NORMAL = 0x0000, _
						$SHGDN_INFOLDER = 0x0001, _
						$SHGDN_FOREDITING = 0x1000, _
						$SHGDN_FORADDRESSBAR = 0x4000, _
						$SHGDN_FORPARSING = 0x8000

; IShellMenuCallback interface
Global Const $sIID_IShellMenuCallback = "{4CA300A1-9B8D-11d1-8B22-00C04FD918D0}"
Global Const $dtag_IShellMenuCallback = "CallbackSM hresult(ptr;uint;wparam;lparam);"

; SMC_XXX messages and notifications
Global Const $SMC_INITMENU                = 0x00000001
Global Const $SMC_CREATE                  = 0x00000002
Global Const $SMC_EXITMENU                = 0x00000003
Global Const $SMC_GETINFO                 = 0x00000005
Global Const $SMC_GETSFINFO               = 0x00000006
Global Const $SMC_GETOBJECT               = 0x00000007
Global Const $SMC_GETSFOBJECT             = 0x00000008
Global Const $SMC_SFEXEC                  = 0x00000009
Global Const $SMC_SFSELECTITEM            = 0x0000000A
Global Const $SMC_REFRESH                 = 0x00000010
Global Const $SMC_DEMOTE                  = 0x00000011
Global Const $SMC_PROMOTE                 = 0x00000012
Global Const $SMC_DEFAULTICON             = 0x00000016
Global Const $SMC_NEWITEM                 = 0x00000017
Global Const $SMC_CHEVRONEXPAND           = 0x00000019
Global Const $SMC_DISPLAYCHEVRONTIP       = 0x0000002A
Global Const $SMC_SETSFOBJECT             = 0x0000002D
Global Const $SMC_SHCHANGENOTIFY          = 0x0000002E
Global Const $SMC_CHEVRONGETTIP           = 0x0000002F
Global Const $SMC_SFDDRESTRICTED          = 0x00000030
Global Const $SMC_SFEXEC_MIDDLE           = 0x00000031
Global Const $SMC_GETAUTOEXPANDSTATE      = 0x00000041
Global Const $SMC_AUTOEXPANDCHANGE        = 0x00000042
Global Const $SMC_GETCONTEXTMENUMODIFIER  = 0x00000043
Global Const $SMC_GETBKCONTEXTMENU        = 0x00000044
Global Const $SMC_OPEN                    = 0x00000045

; SMDATA struct
Global Const $tagSMDATA = _
	"dword  dwMask;" & _
	"dword  dwFlags;" & _
	"handle hmenu;" & _
	"hwnd   hwnd;" & _
	"uint   uId;" & _
	"uint   UIDParent;" & _
	"uint   uIdAncestor;" & _
	"ptr    punk;" & _
	"ptr    pidlFolder;" & _
	"ptr    pidlItem;" & _
	"ptr    psf;" & _
	"ptr    pvUserData"

Global Const $tagSTRRET = "uint uType;ptr data;"


; Custom object
Global $pIShellMenuCallback = ObjCreateInterfaceEx( "oIShellMenuCallback_", $dtag_IShellMenuCallback, True )

; --- Custom methods ---

Global $iIShellMenuCallback_Ref = 0

Func oIShellMenuCallback_QueryInterface( $pSelf, $pRIID, $pObj )
	;ConsoleWrite( "oIShellMenuCallback_QueryInterface" & @CRLF )
	Return $E_NOTIMPL
EndFunc

Func oIShellMenuCallback_AddRef( $pSelf )
	;ConsoleWrite( "oIShellMenuCallback_AddRef" & @CRLF )
	$iIShellMenuCallback_Ref += 1
	Return $iIShellMenuCallback_Ref
EndFunc

Func oIShellMenuCallback_Release( $pSelf )
	;ConsoleWrite( "oIShellMenuCallback_Release" & @CRLF )
	$iIShellMenuCallback_Ref -= 1
	Return $iIShellMenuCallback_Ref
EndFunc

Func oIShellMenuCallback_CallbackSM( $pSelf, $psmd, $uMsg, $wParam, $lParam )
	;ConsoleWrite( "oIShellMenuCallback_CallbackSM" & @CRLF )
	Local $pIShellFolder, $oIShellFolder
	Switch $uMsg
		Case $SMC_SFSELECTITEM
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
			Local $tSTRRET = DllStructCreate( $tagSTRRET ), $sName
			$oIShellFolder.GetDisplayNameOf( DllStructGetData( $tSMDATA, "pidlItem" ), $SHGDN_NORMAL, $tSTRRET )
			StrRetToBuf( DllStructGetPtr( $tSTRRET ), $NULL, $sName )
			; Full path
			ConsoleWrite( $sPath & "\" & $sName & @CRLF )
			Return $S_FALSE
		Case Else
			Return $S_FALSE
	EndSwitch
EndFunc

; --- ObjCreateInterfaceEx ---

; ObjCreateInterfaceEx creates custom object defined with "dtag" interface description string.
; Main purpose of this function is to create custom objects that serve as event handlers for other objects.
; Registered callback functions (defined methods) are left for AutoIt to free at its convenience on exit.
Func ObjCreateInterfaceEx( $sFunctionPrefix, $dtag_Interface, $fNoUnknown = False )
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
	Local $aRet = DllCall( $dllShell32, "int", "SHGetPathFromIDListW", "ptr", $pidl, "ptr", DllStructGetPtr( $stPath ) )
	If @error Then Return SetError(1, 0, 0)
	$sPath = DllStructGetData( $stPath, 1 )
	Return $aRet[0]
EndFunc

Func StrRetToBuf( $pSTRRET, $pidl, ByRef $sBuf, $iBuf = 512 )
	Local $aRet = DllCall( $dllShlwapi, "long", "StrRetToBufW", "ptr", $pSTRRET, "ptr", $pidl, "wstr", $sBuf, "uint", $iBuf )
	If @error Then Return SetError(1, 0, 0)
	$sBuf = $aRet[3]
	Return $aRet[0]
EndFunc
