#include-once

#cs
Global Const $tagSAFEARRAY = _
	"ushort cDims;"      & _ ; The number of dimensions.
	"ushort fFeatures;"  & _ ; Flags, see below.
	"ulong  cbElements;" & _ ; The size of an array element.
	"ulong  cLocks;"     & _ ; The number of times the array has been locked without a corresponding unlock.
	"ptr    pvData;"     & _ ; The data.
	"ulong  cElements;"  & _ ; The number of elements in the dimension.
	"long   lLbound"         ; The lower bound of the dimension.

; fFeatures flags
Global Const $FADF_AUTO        = 0x0001 ; An array that is allocated on the stack.
Global Const $FADF_STATIC      = 0x0002 ; An array that is statically allocated.
Global Const $FADF_EMBEDDED    = 0x0004 ; An array that is embedded in a structure.
Global Const $FADF_FIXEDSIZE   = 0x0010 ; An array that may not be resized or reallocated.
Global Const $FADF_RECORD      = 0x0020 ; An array that contains records. When set, there will be a pointer to the IRecordInfo interface at negative offset 4 in the array descriptor.
Global Const $FADF_HAVEIID     = 0x0040 ; An array that has an IID identifying interface. When set, there will be a GUID at negative offset 16 in the safe array descriptor. Flag is set only when FADF_DISPATCH or FADF_UNKNOWN is also set.
Global Const $FADF_HAVEVARTYPE = 0x0080 ; An array that has a variant type. The variant type can be retrieved with SafeArrayGetVartype.
Global Const $FADF_BSTR        = 0x0100 ; An array of BSTRs.
Global Const $FADF_UNKNOWN     = 0x0200 ; An array of IUnknown*.
Global Const $FADF_DISPATCH    = 0x0400 ; An array of IDispatch*.
Global Const $FADF_VARIANT     = 0x0800 ; An array of VARIANTs.
Global Const $FADF_RESERVED    = 0xF008 ; Bits reserved for future use.
#ce



Func SafeArrayCreateVector( $sType, $iRows )
	Local Const $tagSAFEARRAY = "ushort cDims; ushort fFeatures; ulong cbElements; ulong cLocks; ptr pvData; ulong cElements; long lLbound"
	Local Const $FADF_HAVEIID = 0x0040, $FADF_HAVEVARTYPE = 0x0080, $FADF_BSTR = 0x0100, $FADF_UNKNOWN = 0x0200
	Local Const $VT_INT = 22, $VT_INT_PTR = 37

	Local $iVarType, $iFeatures
	Switch $sType
		Case "int"
			$iVarType = $VT_INT
		Case "ptr" ; IUIAutomationCondition interface pointer
			$iVarType = $VT_INT_PTR
			$iFeatures = $FADF_UNKNOWN
			; $FADF_UNKNOWN must be included in fFeatures in the SafeArray structure.
			; Otherwise an E_INVALIDARG error will occur when the condition is created.
			If @OSVersion <> "WIN_XP" Then $iFeatures = BitOR( $iFeatures, $FADF_HAVEIID )
			; On Windows later than XP $FADF_HAVEIID is used instead of $FADF_HAVEVARTYPE.
		Case "str" ; BSTR (binary string)
			$iVarType = $VT_INT_PTR
			$iFeatures = $FADF_BSTR
		Case Else
			Return SetError(1, 0, 0)
	EndSwitch

	Local $aRet = DllCall( "oleaut32.dll", "ptr", "SafeArrayCreateVector", "int", $iVarType, "long", 0, "ulong", $iRows )
	If @error Then Return SetError(2, 0, 0)
	Local $pSafeArray = $aRet[0]

	Switch $sType
		Case "ptr"
			Local $tSAFEARRAY = DllStructCreate( $tagSAFEARRAY, $pSafeArray )
			Local $fFeatures = DllStructGetData( $tSAFEARRAY, "fFeatures" )
			$fFeatures = BitOR( $fFeatures, $iFeatures )
			If @OSVersion <> "WIN_XP" Then $fFeatures = BitXOR( $fFeatures, $FADF_HAVEVARTYPE )
			; On Windows later than XP $FADF_HAVEIID is used instead of $FADF_HAVEVARTYPE.
			DllStructSetData( $tSAFEARRAY, "fFeatures", $fFeatures )
		Case "str"
			Local $tSAFEARRAY = DllStructCreate( $tagSAFEARRAY, $pSafeArray )
			Local $fFeatures = DllStructGetData( $tSAFEARRAY, "fFeatures" )
			$fFeatures = BitOR( $fFeatures, $iFeatures )
			DllStructSetData( $tSAFEARRAY, "fFeatures", $fFeatures )
	EndSwitch

	Return $pSafeArray
EndFunc

Func SafeArrayGetElement( $pSafeArray, $iIndex, ByRef $vValue )
	Local Const $tagSAFEARRAY = "ushort cDims; ushort fFeatures; ulong cbElements; ulong cLocks; ptr pvData; ulong cElements; long lLbound"
	Local Const $FADF_BSTR = 0x0100, $FADF_UNKNOWN = 0x0200

	Local $fFeatures = DllStructGetData( DllStructCreate( $tagSAFEARRAY, $pSafeArray ), "fFeatures" )

	Local $sType
	Select
		Case BitAND( $fFeatures, $FADF_BSTR ) OR BitAND( $fFeatures, $FADF_UNKNOWN )
			$sType = "ptr*"
		Case Else
			$sType = "int*"
	EndSelect

	Local $aRet = DllCall( "oleaut32.dll", "int", "SafeArrayGetElement", "ptr", $pSafeArray, "long*", $iIndex, $sType, 0 )
	If @error Then Return SetError(1, 0, 1)
	$vValue = $aRet[3]

	If BitAND( $fFeatures, $FADF_BSTR ) Then
		$vValue = SysReadString( $vValue )
		If @error Then Return SetError(2, 0, 1)
	EndIf

	Return $aRet[0]
EndFunc

Func SafeArrayPutElement( $pSafeArray, $iIndex, $vValue )
	Local Const $tagSAFEARRAY = "ushort cDims; ushort fFeatures; ulong cbElements; ulong cLocks; ptr pvData; ulong cElements; long lLbound"
	Local Const $FADF_BSTR = 0x0100, $FADF_UNKNOWN = 0x0200

	Local $tSAFEARRAY = DllStructCreate( $tagSAFEARRAY, $pSafeArray )
	Local $fFeatures = DllStructGetData( $tSAFEARRAY, "fFeatures" )

	Local $sType
	Select
		Case BitAND( $fFeatures, $FADF_BSTR )
			$sType = "ptr*"
			DllStructSetData( $tSAFEARRAY, "fFeatures", $fFeatures - $FADF_BSTR )
			; This is a workaround. String is not inserted if $fFeatures includes $FADF_BSTR.
			$vValue = SysAllocString( $vValue )
			If @error Then Return SetError(1, 0, 1)
		Case BitAND( $fFeatures, $FADF_UNKNOWN )
			$sType = "ptr*"
			DllStructSetData( $tSAFEARRAY, "fFeatures", $fFeatures - $FADF_UNKNOWN )
			; This is a workaround. The DllCall crashes if $fFeatures includes $FADF_UNKNOWN.
		Case Else
			$sType = "int*"
	EndSelect

	Local $aRet = DllCall( "oleaut32.dll", "int", "SafeArrayPutElement", "ptr", $pSafeArray, "long*", $iIndex, $sType, $vValue )
	If @error Then Return SetError(2, 0, 1)

	Select
		Case BitAND( $fFeatures, $FADF_BSTR ) OR BitAND( $fFeatures, $FADF_UNKNOWN )
			DllStructSetData( $tSAFEARRAY, "fFeatures", $fFeatures )
			; This will undo the workaround.
	EndSelect

	Return $aRet[0]
EndFunc

Func SafeArrayGetUBound( $pSafeArray, ByRef $iUBound )
	Local $aRet = DllCall( "oleaut32.dll", "int", "SafeArrayGetUBound", "ptr", $pSafeArray, "uint", 1, "long*", 0 )
	If @error Then Return SetError(1, 0, 1)
	$iUBound = $aRet[3]
	Return $aRet[0]
EndFunc

Func SafeArrayDestroy( $pSafeArray )
	Local $aRet = DllCall( "oleaut32.dll", "int", "SafeArrayDestroy", "ptr", $pSafeArray )
	If @error Then Return SetError(1, 0, 1)
	Return $aRet[0]
EndFunc



; BSTR functions
; Copied and slightly modified from AutoItObject.au3 by the AutoItObject-Team

Func SysAllocString( $str )
	Local $aRet = DllCall( "oleaut32.dll", "ptr", "SysAllocString", "wstr", $str )
	If @error Then Return SetError(1, 0, 0)
	Return $aRet[0]
EndFunc

Func SysFreeString( $pBSTR )
	If Not $pBSTR Then Return SetError(1, 0, 0)
	DllCall( "oleaut32.dll", "none", "SysFreeString", "ptr", $pBSTR )
	If @error Then Return SetError(2, 0, 0)
EndFunc

Func SysReadString( $pBSTR, $iLen = -1 )
	If Not $pBSTR Then Return SetError(1, 0, "")
	If $iLen < 1 Then $iLen = SysStringLen( $pBSTR )
	If $iLen < 1 Then Return SetError(2, 0, "")
	Return DllStructGetData( DllStructCreate( "wchar[" & $iLen & "]", $pBSTR ), 1 )
EndFunc

Func SysStringLen( $pBSTR )
	If Not $pBSTR Then Return SetError(1, 0, 0)
	Local $aRet = DllCall( "oleaut32.dll", "uint", "SysStringLen", "ptr", $pBSTR )
	If @error Then Return SetError(2, 0, 0)
	Return $aRet[0]
EndFunc
