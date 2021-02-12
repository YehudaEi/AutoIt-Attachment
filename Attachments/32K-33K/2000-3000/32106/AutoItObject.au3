; #INDEX# =======================================================================================================================
; Title .........: AutoItObject
; AutoIt Version : 3.3
; Language ......: English (language independent)
; Description ...: Brings Objects to AutoIt.
; Author(s) .....: monoceres, trancexx, Kip, Prog@ndy
; Copyright .....: Copyright (C) The AutoItObject-Team. All rights reserved.
; License .......: Artistic License 2.0, see Artistic.txt
;
; This file is part of AutoItObject.
;
; AutoItObject is free software; you can redistribute it and/or modify
; it under the terms of the Artistic License as published by Larry Wall,
; either version 2.0, or (at your option) any later version.
;
; This program is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
; See the Artistic License for more details.
;
; You should have received a copy of the Artistic License with this Kit,
; in the file named "Artistic.txt".  If not, you can get a copy from
; <                                                  > OR
; <http://www.opensource.org/licenses/artistic-license-2.0.php>
;
; ------------------------ AutoItObject CREDITS: ------------------------
; Copyright (C) by:
; The AutoItObject-Team:
; 	Andreas Karlsson (monoceres)
; 	Dragana R. (trancexx)
; 	Dave Bakker (Kip)
; 	Andreas Bosch (progandy, Prog@ndy)
;
; ===============================================================================================================================
#include-once
#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6


; #CURRENT# =====================================================================================================================
;_AutoItObject_VariantRead
;_AutoItObject_VariantSet
;_AutoItObject_VariantCopy
;_AutoItObject_VariantClear
;_AutoItObject_VariantFree
;_AutoItObject_Startup
;_AutoItObject_Shutdown
;_AutoItObject_WrapperCreate
;_AutoItObject_WrapperAddMethod
;_AutoItObject_Class
;_AutoItObject_Create
;_AutoItObject_AddMethod
;_AutoItObject_AddProperty
;_AutoItObject_AddDestructor
;_AutoItObject_AddEnum
;_AutoItObject_RemoveMember
;_AutoItObject_IUnknownAddRef
;_AutoItObject_CLSIDFromString
;_AutoItObject_CoCreateInstance
;_AutoItObject_PtrToIDispatch
;_AutoItObject_IDispatchToPtr
;_AutoItObject_VariantCopy
;_AutoItObject_VariantClear

; ===============================================================================================================================

; #INTERNAL_NO_DOC# =============================================================================================================
;__Au3Obj_OleUninitialize()
;__Au3Obj_IUnknown_AddRef
;__Au3Obj_GetMethods
;__Au3Obj_VariantInit
;__Au3Obj_SafeArrayCreate
;__Au3Obj_SafeArrayDestroy
;__Au3Obj_SafeArrayAccessData
;__Au3Obj_SafeArrayUnaccessData
;__Au3Obj_SafeArrayGetUBound
;__Au3Obj_SafeArrayGetLBound
;__Au3Obj_SafeArrayGetDim
;__Au3Obj_CreateSafeArrayVariant
;__Au3Obj_ReadSafeArrayVariant
;__Au3Obj_CoTaskMemAlloc
;__Au3Obj_CoTaskMemFree
;__Au3Obj_CoTaskMemRealloc
;__Au3Obj_GlobalAlloc
;__Au3Obj_GlobalFree
;__Au3Obj_SysAllocString
;__Au3Obj_SysCopyString
;__Au3Obj_SysReAllocString
;__Au3Obj_SysFreeString
;__Au3Obj_SysStringLen
;__Au3Obj_SysReadString
;__Au3Obj_PtrStringLen
;__Au3Obj_PtrStringRead
;__Au3Obj_FunctionProxy
;__Au3Obj_WrapFunctionProxy
;__Au3Obj_EnumFunctionProxy
;__Au3Obj_Object_Create
;__Au3Obj_Object_AddMethod
;__Au3Obj_Object_AddProperty
;__Au3Obj_Object_AddDestructor
;__Au3Obj_Object_AddEnum
;__Au3Obj_Object_RemoveMember
;__Au3Obj_ObjStructGetElements
;__Au3Obj_ObjStructMethod
;__Au3Obj_ObjStructDestructor
;__Au3Obj_PointerCall
;__Au3Obj_Mem_DllOpen
;__Au3Obj_Mem_FixReloc
;__Au3Obj_Mem_FixImports
;__Au3Obj_Mem_LoadLibraryEx
;__Au3Obj_Mem_FreeLibrary
;__Au3Obj_Mem_GetAddress
;__Au3Obj_Mem_VirtualProtect
;__Au3Obj_Mem_BinDll
;__Au3Obj_Mem_BinDll_X64
; ===============================================================================================================================

;--------------------------------------------------------------------------------------------------------------------------------------
#region Variable definitions

Global Const $gh_AU3Obj_kernel32dll = DllOpen("kernel32.dll")
Global Const $gh_AU3Obj_oleautdll = DllOpen("oleaut32.dll")
Global Const $gh_AU3Obj_ole32dll = DllOpen("ole32.dll")

Global Const $__Au3Obj_X64 = @AutoItX64

Global Const $__Au3Obj_VT_EMPTY = 0
Global Const $__Au3Obj_VT_NULL = 1
Global Const $__Au3Obj_VT_I2 = 2
Global Const $__Au3Obj_VT_I4 = 3
Global Const $__Au3Obj_VT_R4 = 4
Global Const $__Au3Obj_VT_R8 = 5
Global Const $__Au3Obj_VT_CY = 6
Global Const $__Au3Obj_VT_DATE = 7
Global Const $__Au3Obj_VT_BSTR = 8
Global Const $__Au3Obj_VT_DISPATCH = 9
Global Const $__Au3Obj_VT_ERROR = 10
Global Const $__Au3Obj_VT_BOOL = 11
Global Const $__Au3Obj_VT_VARIANT = 12
Global Const $__Au3Obj_VT_UNKNOWN = 13
Global Const $__Au3Obj_VT_DECIMAL = 14
Global Const $__Au3Obj_VT_I1 = 16
Global Const $__Au3Obj_VT_UI1 = 17
Global Const $__Au3Obj_VT_UI2 = 18
Global Const $__Au3Obj_VT_UI4 = 19
Global Const $__Au3Obj_VT_I8 = 20
Global Const $__Au3Obj_VT_UI8 = 21
Global Const $__Au3Obj_VT_INT = 22
Global Const $__Au3Obj_VT_UINT = 23
Global Const $__Au3Obj_VT_VOID = 24
Global Const $__Au3Obj_VT_HRESULT = 25
Global Const $__Au3Obj_VT_PTR = 26
Global Const $__Au3Obj_VT_SAFEARRAY = 27
Global Const $__Au3Obj_VT_CARRAY = 28
Global Const $__Au3Obj_VT_USERDEFINED = 29
Global Const $__Au3Obj_VT_LPSTR = 30
Global Const $__Au3Obj_VT_LPWSTR = 31
Global Const $__Au3Obj_VT_RECORD = 36
Global Const $__Au3Obj_VT_INT_PTR = 37
Global Const $__Au3Obj_VT_UINT_PTR = 38
Global Const $__Au3Obj_VT_FILETIME = 64
Global Const $__Au3Obj_VT_BLOB = 65
Global Const $__Au3Obj_VT_STREAM = 66
Global Const $__Au3Obj_VT_STORAGE = 67
Global Const $__Au3Obj_VT_STREAMED_OBJECT = 68
Global Const $__Au3Obj_VT_STORED_OBJECT = 69
Global Const $__Au3Obj_VT_BLOB_OBJECT = 70
Global Const $__Au3Obj_VT_CF = 71
Global Const $__Au3Obj_VT_CLSID = 72
Global Const $__Au3Obj_VT_VERSIONED_STREAM = 73
Global Const $__Au3Obj_VT_BSTR_BLOB = 0xfff
Global Const $__Au3Obj_VT_VECTOR = 0x1000
Global Const $__Au3Obj_VT_ARRAY = 0x2000
Global Const $__Au3Obj_VT_BYREF = 0x4000
Global Const $__Au3Obj_VT_RESERVED = 0x8000
Global Const $__Au3Obj_VT_ILLEGAL = 0xffff
Global Const $__Au3Obj_VT_ILLEGALMASKED = 0xfff
Global Const $__Au3Obj_VT_TYPEMASK = 0xfff

Global Const $__Au3Obj_tagVARIANT = "word vt;word r1;word r2;word r3;ptr data; ptr"

Global Const $__Au3Obj_tagVARIANT_SIZE = DllStructGetSize(DllStructCreate($__Au3Obj_tagVARIANT, 1))
Global Const $__Au3Obj_tagPTR_SIZE = DllStructGetSize(DllStructCreate('ptr', 1))
Global Const $__Au3Obj_tagSAFEARRAYBOUND = "ulong cElements; long lLbound;"

Global $ghAutoItObjectDLL = -1, $giAutoItObjectDLLRef = 0

#endregion Variable definitions
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Misc

DllCall($gh_AU3Obj_ole32dll, 'long', 'OleInitialize', 'ptr', 0)

Opt("OnExitFunc", "__Au3Obj_OleUninitialize")
Func __Au3Obj_OleUninitialize()
	; Author: Prog@ndy
	DllCall($gh_AU3Obj_ole32dll, 'long', 'OleUninitialize')
	_AutoItObject_Shutdown(True)
EndFunc   ;==>__Au3Obj_OleUninitialize

Func __Au3Obj_IUnknown_AddRef($hObj)
	; Author: trancexx
	; modified: prog@ndy
	Local $pObj = $hObj
	If IsObj($hObj) Then $pObj = _AutoItObject_IDispatchToPtr($hObj)
	; Adjusted VARIANT structure
	Local $tVAR_DWORD = DllStructCreate("word VarType; word Reserved1; word Reserved2; word Reserved3; dword Data; ptr Record;") ; static is faster ;)
	DllStructSetData($tVAR_DWORD, "VarType", $__Au3Obj_VT_UINT)
	; Actual call
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "DispCallFunc", _
			"ptr", $pObj, _
			"dword", $__Au3Obj_tagPTR_SIZE, _ ; offset (4 for x86, 8 for x64)
			"dword", 4, _ ; CC_STDCALL
			"dword", $__Au3Obj_VT_UINT, _;$__Au3Obj_VT_UINT, _
			"dword", 0, _ ; number of function parameters
			"ptr", 0, _ ; parameters related
			"ptr", 0, _ ; parameters related
			"ptr", DllStructGetPtr($tVAR_DWORD))
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	; Collect returned
	Return DllStructGetData($tVAR_DWORD, "Data")
EndFunc   ;==>__Au3Obj_IUnknown_AddRef

Func __Au3Obj_GetMethods($tagInterface)
	Local $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(\w+)\h*(\((.*?)\))\h*(;|;*\z)", "$1\|$2;$4" & @LF), ";" & @LF, @LF)
	If $sMethods = $tagInterface Then $sMethods = StringReplace(StringRegExpReplace($tagInterface, "\h*(\w+)\h*(;|;*\z)", "$1\|" & @LF), ";" & @LF, @LF)
	Return StringTrimRight($sMethods, 1)
EndFunc   ;==>__Au3Obj_GetMethods

Func __Au3Obj_ObjStructGetElements($sTag, ByRef $sAlign)
	Local $sAlignment = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;.*", "$1")
	If $sAlignment <> $sTag Then
		$sAlign = $sAlignment
		$sTag = StringRegExpReplace($sTag, "\h*(align\h+\d+)\h*;", "")
	EndIf
	; Return StringRegExp($sTag, "\h*\w+\h*(\w+)\h*", 3) ; DO NOT REMOVE THIS LINE
	Return StringTrimRight(StringRegExpReplace($sTag, "\h*\w+\h*(\w+)\h*(\[\d+\])*\h*(;|;*\z)\h*", "$1;"), 1)
EndFunc   ;==>__Au3Obj_ObjStructGetElements

#endregion Misc
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Variant

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantRead
; Description ...: Reads he value of a VARIANT
; Syntax.........: _AutoItObject_VariantRead($pVariant)
; Parameters ....: $pVariant    - Pointer to VARaINT-structure
; Return values .: Success      - value of the VARIANT
;                  Failure      - 0
; Author ........: monoceres, Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_VariantRead($pVariant)
	; Author: monoceres, Prog@ndy
	Local $var = DllStructCreate($__Au3Obj_tagVARIANT, $pVariant), $data
	; Translate the vt id to a autoit dllcall type
	Local $VT = DllStructGetData($var, "vt"), $type
	Switch $VT
		Case $__Au3Obj_VT_I1, $__Au3Obj_VT_UI1
			$type = "byte"
		Case $__Au3Obj_VT_I2
			$type = "short"
		Case $__Au3Obj_VT_I4
			$type = "int"
		Case $__Au3Obj_VT_I8
			$type = "int64"
		Case $__Au3Obj_VT_R4
			$type = "float"
		Case $__Au3Obj_VT_R8
			$type = "double"
		Case $__Au3Obj_VT_UI2
			$type = 'word'
		Case $__Au3Obj_VT_UI4
			$type = 'uint'
		Case $__Au3Obj_VT_UI8
			$type = 'uint64'
		Case $__Au3Obj_VT_BSTR
			Return __Au3Obj_SysReadString(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_BOOL
			$type = 'short'
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			Local $pSafeArray = DllStructGetData($var, "data")
			Local $bound, $pData, $lbound
			If 0 = __Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound) Then
				__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
				$bound += 1 - $lbound
				If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
					Local $tData = DllStructCreate("byte[" & $bound & "]", $pData)
					$data = DllStructGetData($tData, 1)
					__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				EndIf
			EndIf
			Return $data
		Case BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
			Return __Au3Obj_ReadSafeArrayVariant(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_DISPATCH
			Return _AutoItObject_PtrToIDispatch(DllStructGetData($var, "data"))
		Case $__Au3Obj_VT_PTR
			Return DllStructGetData($var, "data")
		Case $__Au3Obj_VT_ERROR
			Return Default
		Case Else
			_AutoItObject_VariantClear($pVariant)
			Return SetError(1, 0, '')
	EndSwitch

	$data = DllStructCreate($type, DllStructGetPtr($var, "data"))

	Switch $VT
		Case $__Au3Obj_VT_BOOL
			Return DllStructGetData($data, 1) <> 0
	EndSwitch
	Return DllStructGetData($data, 1)

EndFunc   ;==>_AutoItObject_VariantRead

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantSet
; Description ...: sets the valkue of a varaint or creates a new one.
; Syntax.........: _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
; Parameters ....: $pVar        - Pointer to the VARIANT to modify (0 if you want to create it new)
;                  $vVal        - Value of the VARIANT
;                  $iSpecialType - [optional] Modify the automatic type. NOT FOR GENERAL USE!
; Return values .: Success      - Pointer to the VARIANT
;                  Failure      - 0
; Author ........: monoceres, Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_VariantSet($pVar, $vVal, $iSpecialType = 0)
	; Author: monoceres, Prog@ndy
	If Not $pVar Then
		$pVar = __Au3Obj_CoTaskMemAlloc($__Au3Obj_tagVARIANT_SIZE)
		__Au3Obj_VariantInit($pVar)
	Else
		_AutoItObject_VariantClear($pVar)
	EndIf
	Local $tVar = DllStructCreate($__Au3Obj_tagVARIANT, $pVar)
	Local $iType = $__Au3Obj_VT_EMPTY, $vDataType = ''

	Switch VarGetType($vVal)
		Case "Int32"
			$iType = $__Au3Obj_VT_I4
			$vDataType = 'int'
		Case "Int64"
			$iType = $__Au3Obj_VT_I8
			$vDataType = 'int64'
		Case "String", 'Text'
			$iType = $__Au3Obj_VT_BSTR
			$vDataType = 'ptr'
			$vVal = __Au3Obj_SysAllocString($vVal)
		Case "Double"
			$vDataType = 'double'
			$iType = $__Au3Obj_VT_R8
		Case "Float"
			$vDataType = 'float'
			$iType = $__Au3Obj_VT_R4
		Case "Bool"
			$vDataType = 'short'
			$iType = $__Au3Obj_VT_BOOL
			If $vVal Then
				$vVal = 0xffff
			Else
				$vVal = 0
			EndIf
		Case 'Ptr'
			If $__Au3Obj_X64 Then
				$iType = $__Au3Obj_VT_UI8
			Else
				$iType = $__Au3Obj_VT_UI4
			EndIf
			$vDataType = 'ptr'
		Case 'Object'
			$vVal = _AutoItObject_IDispatchToPtr($vVal)
			;__Au3Obj_IUnknown_AddRef($vVal)
			DllCall($ghAutoItObjectDLL, "int", "IUnknownAddRef", "ptr", $vVal)
			$vDataType = 'ptr'
			$iType = $__Au3Obj_VT_DISPATCH
		Case "Binary"
			; ARRAY OF BYTES !
			Local $tSafeArrayBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tSafeArrayBound, 1, BinaryLen($vVal))
			Local $pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_UI1, 1, DllStructGetPtr($tSafeArrayBound))
			Local $pData
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				Local $tData = DllStructCreate("byte[" & BinaryLen($vVal) & "]", $pData)
				DllStructSetData($tData, 1, $vVal)
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
				$vVal = $pSafeArray
				$vDataType = 'ptr'
				$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_UI1)
			EndIf
		Case "Array"
			$vDataType = 'ptr'
			$vVal = __Au3Obj_CreateSafeArrayVariant($vVal)
			$iType = BitOR($__Au3Obj_VT_ARRAY, $__Au3Obj_VT_VARIANT)
		Case Else ;"Keyword" ; all keywords and unknown Vartypes will be handled as "default"
			$iType = $__Au3Obj_VT_ERROR
			$vDataType = 'int'
	EndSwitch
	If $vDataType Then
		DllStructSetData(DllStructCreate($vDataType, DllStructGetPtr($tVar, 'data')), 1, $vVal)

		If @NumParams = 3 Then $iType = $iSpecialType
		DllStructSetData($tVar, 'vt', $iType)
	EndIf
	Return $pVar
EndFunc   ;==>_AutoItObject_VariantSet

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantCopy
; Description ...: Copies a VARIANT to another
; Syntax.........: _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
; Parameters ....: $pvargDest   - Destionation variant
;                  $pvargSrc    - Source variant
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ VariantCopy
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_VariantCopy($pvargDest, $pvargSrc)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantCopy", "ptr", $pvargDest, 'ptr', $pvargSrc)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantCopy

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantClear
; Description ...: Clears the value of a variant
; Syntax.........: _AutoItObject_VariantClear($pvarg)
; Parameters ....: $pvarg       - the VARIANT to clear
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ VariantClear
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_VariantClear($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantClear

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_VariantFree
; Description ...: Frees a variant created by _AutoItObject_VariantSet
; Syntax.........: _AutoItObject_VariantFree($pvarg)
; Parameters ....: $pvarg       - the VARIANT to free
; Return values .: Success      - 0
;                  Failure      - nonzero
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_VariantFree($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantClear", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	If $aCall[0] = 0 Then __Au3Obj_CoTaskMemFree($pvarg)
	Return $aCall[0]
EndFunc   ;==>_AutoItObject_VariantFree


Func __Au3Obj_VariantInit($pvarg)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "long", "VariantInit", "ptr", $pvarg)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_VariantInit
#endregion Variant
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region SafeArray
Func __Au3Obj_SafeArrayCreate($vType, $cDims, $rgsabound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SafeArrayCreate", "dword", $vType, "uint", $cDims, 'ptr', $rgsabound)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayCreate

Func __Au3Obj_SafeArrayDestroy($pSafeArray)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayDestroy", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayDestroy

Func __Au3Obj_SafeArrayAccessData($pSafeArray, ByRef $pArrayData)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayAccessData", "ptr", $pSafeArray, 'ptr*', 0)
	If @error Then Return SetError(1, 0, 1)
	$pArrayData = $aCall[2]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayAccessData

Func __Au3Obj_SafeArrayUnaccessData($pSafeArray)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayUnaccessData", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 1)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayUnaccessData

Func __Au3Obj_SafeArrayGetUBound($pSafeArray, $iDim, ByRef $iBound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetUBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetUBound

Func __Au3Obj_SafeArrayGetLBound($pSafeArray, $iDim, ByRef $iBound)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SafeArrayGetLBound", "ptr", $pSafeArray, 'uint', $iDim, 'long*', 0)
	If @error Then Return SetError(1, 0, 1)
	$iBound = $aCall[3]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetLBound

Func __Au3Obj_SafeArrayGetDim($pSafeArray)
	Local $aResult = DllCall($gh_AU3Obj_oleautdll, "uint", "SafeArrayGetDim", "ptr", $pSafeArray)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_SafeArrayGetDim

Func __Au3Obj_CreateSafeArrayVariant(ByRef Const $aArray)
	; Author: Prog@ndy
	Local $iDim = UBound($aArray, 0), $pData, $pSafeArray, $bound, $subBound, $tBound
	Switch $iDim
		Case 1
			$bound = UBound($aArray) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 1, $bound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 1, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					__Au3Obj_VariantInit($pData + $i * $__Au3Obj_tagVARIANT_SIZE)
					_AutoItObject_VariantSet($pData + $i * $__Au3Obj_tagVARIANT_SIZE, $aArray[$i])
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case 2
			$bound = UBound($aArray, 1) - 1
			$subBound = UBound($aArray, 2) - 1
			$tBound = DllStructCreate($__Au3Obj_tagSAFEARRAYBOUND & $__Au3Obj_tagSAFEARRAYBOUND)
			DllStructSetData($tBound, 3, $bound + 1)
			DllStructSetData($tBound, 1, $subBound + 1)
			$pSafeArray = __Au3Obj_SafeArrayCreate($__Au3Obj_VT_VARIANT, 2, DllStructGetPtr($tBound))
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						__Au3Obj_VariantInit($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_tagVARIANT_SIZE)
						_AutoItObject_VariantSet($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_tagVARIANT_SIZE, $aArray[$i][$j])
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $pSafeArray
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_CreateSafeArrayVariant

Func __Au3Obj_ReadSafeArrayVariant($pSafeArray)
	; Author: Prog@ndy
	Local $iDim = __Au3Obj_SafeArrayGetDim($pSafeArray), $pData, $lbound, $bound, $subBound
	Switch $iDim
		Case 1
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $bound)
			$bound -= $lbound
			Local $array[$bound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					$array[$i] = _AutoItObject_VariantRead($pData + $i * $__Au3Obj_tagVARIANT_SIZE)
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case 2
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 2, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 2, $bound)
			$bound -= $lbound
			__Au3Obj_SafeArrayGetLBound($pSafeArray, 1, $lbound)
			__Au3Obj_SafeArrayGetUBound($pSafeArray, 1, $subBound)
			$subBound -= $lbound
			Local $array[$bound + 1][$subBound + 1]
			If 0 = __Au3Obj_SafeArrayAccessData($pSafeArray, $pData) Then
				For $i = 0 To $bound
					For $j = 0 To $subBound
						$array[$i][$j] = _AutoItObject_VariantRead($pData + ($j + $i * ($subBound + 1)) * $__Au3Obj_tagVARIANT_SIZE)
					Next
				Next
				__Au3Obj_SafeArrayUnaccessData($pSafeArray)
			EndIf
			Return $array
		Case Else
			Return 0
	EndSwitch
EndFunc   ;==>__Au3Obj_ReadSafeArrayVariant

#endregion SafeArray
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Memory

Func __Au3Obj_CoTaskMemAlloc($iSize)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemAlloc", "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemAlloc

Func __Au3Obj_CoTaskMemFree($pCoMem)
	; Author: Prog@ndy
	DllCall($gh_AU3Obj_ole32dll, "none", "CoTaskMemFree", "ptr", $pCoMem)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_CoTaskMemFree

Func __Au3Obj_CoTaskMemRealloc($pCoMem, $iSize)
	; Author: Prog@ndy
	Local $aCall = DllCall($gh_AU3Obj_ole32dll, "ptr", "CoTaskMemRealloc", 'ptr', $pCoMem, "uint_ptr", $iSize)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_CoTaskMemRealloc

Func __Au3Obj_GlobalAlloc($iSize, $iFlag)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalAlloc", "dword", $iFlag, "dword_ptr", $iSize)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_GlobalAlloc

Func __Au3Obj_GlobalFree($pPointer)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GlobalFree", "ptr", $pPointer)
	If @error Or $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_GlobalFree

#endregion Memory
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region SysString

Func __Au3Obj_SysAllocString($str)
	; Author: monoceres
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocString", "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysAllocString
Func __Au3Obj_SysCopyString($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "ptr", "SysAllocStringLen", "ptr", $pBSTR, "uint", __Au3Obj_SysStringLen($pBSTR))
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysCopyString

Func __Au3Obj_SysReAllocString(ByRef $pBSTR, $str)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "int", "SysReAllocString", 'ptr*', $pBSTR, "wstr", $str)
	If @error Then Return SetError(1, 0, 0)
	$pBSTR = $aCall[1]
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysReAllocString

Func __Au3Obj_SysFreeString($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	DllCall($gh_AU3Obj_oleautdll, "none", "SysFreeString", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
EndFunc   ;==>__Au3Obj_SysFreeString

Func __Au3Obj_SysStringLen($pBSTR)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, 0)
	Local $aCall = DllCall($gh_AU3Obj_oleautdll, "uint", "SysStringLen", "ptr", $pBSTR)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_SysStringLen

Func __Au3Obj_SysReadString($pBSTR, $iLen = -1)
	; Author: Prog@ndy
	If Not $pBSTR Then Return SetError(2, 0, '')
	If $iLen < 1 Then $iLen = __Au3Obj_SysStringLen($pBSTR)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pBSTR), 1)
EndFunc   ;==>__Au3Obj_SysReadString

Func __Au3Obj_PtrStringLen($pStr)
	; Author: Prog@ndy
	Local $aResult = DllCall($gh_AU3Obj_kernel32dll, 'int', 'lstrlenW', 'ptr', $pStr)
	If @error Then Return SetError(1, 0, 0)
	Return $aResult[0]
EndFunc   ;==>__Au3Obj_PtrStringLen

Func __Au3Obj_PtrStringRead($pStr, $iLen = -1)
	; Author: Prog@ndy
	If $iLen < 1 Then $iLen = __Au3Obj_PtrStringLen($pStr)
	If $iLen < 1 Then Return SetError(1, 0, '')
	Return DllStructGetData(DllStructCreate("wchar[" & $iLen & "]", $pStr), 1)
EndFunc   ;==>__Au3Obj_PtrStringRead

#endregion SysString
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Proxy Functions

Func __Au3Obj_FunctionProxy($FuncName, $oSelf) ; allows binary code to call autoit functions
	Local $arg = $oSelf.__params__ ; fetch params, first two entries are empty.
	$arg[0] = "CallArgArray" ; first entry for CallArgArray
	$arg[1] = $oSelf ; Second entry for object
	Local $ret = Call($FuncName, $arg) ; Call
	If @error = 0xDEAD And @extended = 0xBEEF Then Return 0
	$oSelf.__error__ = @error ; set error
	$oSelf.__result__ = $ret ; set result
	Return 1
EndFunc   ;==>__Au3Obj_FunctionProxy

Func __Au3Obj_WrapFunctionProxy($FuncPtr, $pObject, $sVarTypes, $oSelf, $ArgCount, $pVarResult)
	#forceref $pVarResult
	; Author: Prog@ndy
	Local $aArgs
	If $sVarTypes Then
		$sVarTypes = StringSplit($sVarTypes, ";", 2)
		If (UBound($sVarTypes) - 1) <> $ArgCount Then Return False
		$aArgs = $oSelf.__params__
		$aArgs[0] = "CallArgArray"
		$aArgs[1] = $sVarTypes[0]
		$aArgs[2] = $FuncPtr
		$aArgs[3] = 'ptr'
		$aArgs[4] = $pObject
		If $ArgCount Then
			; Fetch all arguments
			$ArgCount -= 1
			For $i = 0 To $ArgCount
				; Save the values backwards (that's how COM does it)
				$aArgs[5 + ($ArgCount - $i) * 2] = $sVarTypes[$i + 1]
			Next
		EndIf
	Else ; paramtypes have to given as parameters, return type is first param
		If Mod($ArgCount, 2) <> 1 Then Return False
		$aArgs = $oSelf.__params__
		$aArgs[0] = "CallArgArray"
		$aArgs[1] = $aArgs[4]
		$aArgs[2] = $FuncPtr
		$aArgs[3] = 'ptr'
		$aArgs[4] = $pObject
	EndIf
	Local $ret = Call("__Au3Obj_PointerCall", $aArgs)
	For $i = 0 To UBound($ret) - 1
		If IsPtr($ret[$i]) Then $ret[$i] = Number($ret[$i])
	Next
	$oSelf.__result__ = $ret
	Return True
EndFunc   ;==>__Au3Obj_WrapFunctionProxy

Func __Au3Obj_EnumFunctionProxy($iAction, $FuncName, $oSelf, $pVarCurrent, $pVarResult)
	Local $Current, $ret
	Switch $iAction
		Case 0 ; Next
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			$oSelf.__bridge__(Number($pVarResult)) = $ret
			Return 1
		Case 1 ;Skip
			Return False
		Case 2 ; Reset
			$Current = $oSelf.__bridge__(Number($pVarCurrent))
			$ret = Execute($FuncName & "($oSelf, $Current)")
			If @error Or Not $ret Then Return False
			$oSelf.__bridge__(Number($pVarCurrent)) = $Current
			Return True
	EndSwitch
EndFunc   ;==>__Au3Obj_EnumFunctionProxy

#endregion Proxy Functions
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Call Pointer

Func __Au3Obj_PointerCall($sRetType, $pAddress, $sType1 = "", $vParam1 = 0, $sType2 = "", $vParam2 = 0, $sType3 = "", $vParam3 = 0, $sType4 = "", $vParam4 = 0, $sType5 = "", $vParam5 = 0, $sType6 = "", $vParam6 = 0, $sType7 = "", $vParam7 = 0, $sType8 = "", $vParam8 = 0, $sType9 = "", $vParam9 = 0, $sType10 = "", $vParam10 = 0, $sType11 = "", $vParam11 = 0, $sType12 = "", $vParam12 = 0, $sType13 = "", $vParam13 = 0, $sType14 = "", $vParam14 = 0, $sType15 = "", $vParam15 = 0, $sType16 = "", $vParam16 = 0, $sType17 = "", $vParam17 = 0, $sType18 = "", $vParam18 = 0, $sType19 = "", $vParam19 = 0, $sType20 = "", $vParam20 = 0)
	; Author: Ward, Prog@ndy, trancexx
	Local  $pHook, $hPseudo, $tPtr, $sFuncName = "MemoryCallEntry"
	If $pAddress Then
		If Not $pHook Then
			Local $sDll = "AutoItObject.dll"
			If $__Au3Obj_X64 Then $sDll = "AutoItObject_X64.dll"
			$hPseudo = DllOpen($sDll)
			If $hPseudo = -1 Then
				$sDll = "kernel32.dll"
				$sFuncName = "GlobalFix"
				$hPseudo = DllOpen($sDll)
			EndIf
			Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetModuleHandleW", "wstr", $sDll)
			If @error Or Not $aCall[0] Then Return SetError(7, @error, 0) ; Couldn't get dll handle
			Local $hModuleHandle = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "ptr", $hModuleHandle, "str", $sFuncName)
			If @error Then Return SetError(8, @error, 0) ; Wanted function not found
			$pHook = $aCall[0]
			$aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pHook, "dword", 7 + 5 * $__Au3Obj_X64, "dword", 64, "dword*", 0)
			If @error Or Not $aCall[0] Then Return SetError(9, @error, 0) ; Unable to set MEM_EXECUTE_READWRITE
			If $__Au3Obj_X64 Then
				DllStructSetData(DllStructCreate("word", $pHook), 1, 0xB848)
				DllStructSetData(DllStructCreate("word", $pHook + 10), 1, 0xE0FF)
			Else
				DllStructSetData(DllStructCreate("byte", $pHook), 1, 0xB8)
				DllStructSetData(DllStructCreate("word", $pHook + 5), 1, 0xE0FF)
			EndIf
			$tPtr = DllStructCreate("ptr", $pHook + 1 + $__Au3Obj_X64)
		EndIf
		DllStructSetData($tPtr, 1, $pAddress)
		Local $aRet
		Switch @NumParams
			Case 2
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName)
			Case 4
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1)
			Case 6
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2)
			Case 8
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3)
			Case 10
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4)
			Case 12
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5)
			Case 14
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6)
			Case 16
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7)
			Case 18
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8)
			Case 20
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9)
			Case 22
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10)
			Case 24
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11)
			Case 26
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12)
			Case 28
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13)
			Case 30
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14)
			Case 32
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15)
			Case 34
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16)
			Case 36
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17)
			Case 38
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18)
			Case 40
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19)
			Case 42
				$aRet = DllCall($hPseudo, $sRetType, $sFuncName, $sType1, $vParam1, $sType2, $vParam2, $sType3, $vParam3, $sType4, $vParam4, $sType5, $vParam5, $sType6, $vParam6, $sType7, $vParam7, $sType8, $vParam8, $sType9, $vParam9, $sType10, $vParam10, $sType11, $vParam11, $sType12, $vParam12, $sType13, $vParam13, $sType14, $vParam14, $sType15, $vParam15, $sType16, $vParam16, $sType17, $vParam17, $sType18, $vParam18, $sType19, $vParam19, $sType20, $vParam20)
			Case Else
				If Mod(@NumParams, 2) Then Return SetError(4, 0, 0) ; Bad number of parameters
				Return SetError(5, 0, 0) ; Max number of parameters exceeded
		EndSwitch
		Return SetError(@error, @extended, $aRet) ; All went well. Error description and return values like with DllCall()
	EndIf
	Return SetError(6, 0, 0) ; Null address specified
EndFunc   ;==>__Au3Obj_PointerCall

#endregion Call Pointer
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Embedded DLL

Func __Au3Obj_Mem_DllOpen($bBinaryImage = 0, $sSubrogor = "cmd.exe")
	If Not $bBinaryImage Then
		If $__Au3Obj_X64 Then
			$bBinaryImage = __Au3Obj_Mem_BinDll_X64()
		Else
			$bBinaryImage = __Au3Obj_Mem_BinDll()
		EndIf
	EndIf
	; Make structure out of binary data that was passed
	Local $tBinary = DllStructCreate("byte[" & BinaryLen($bBinaryImage) & "]")
	DllStructSetData($tBinary, 1, $bBinaryImage) ; fill the structure
	; Get pointer to it
	Local $pPointer = DllStructGetPtr($tBinary)
	; Start processing passed binary data. 'Reading' PE format follows.
	Local $tIMAGE_DOS_HEADER = DllStructCreate("char Magic[2];" & _
			"word BytesOnLastPage;" & _
			"word Pages;" & _
			"word Relocations;" & _
			"word SizeofHeader;" & _
			"word MinimumExtra;" & _
			"word MaximumExtra;" & _
			"word SS;" & _
			"word SP;" & _
			"word Checksum;" & _
			"word IP;" & _
			"word CS;" & _
			"word Relocation;" & _
			"word Overlay;" & _
			"char Reserved[8];" & _
			"word OEMIdentifier;" & _
			"word OEMInformation;" & _
			"char Reserved2[20];" & _
			"dword AddressOfNewExeHeader", _
			$pPointer)
	; Move pointer
	$pPointer += DllStructGetData($tIMAGE_DOS_HEADER, "AddressOfNewExeHeader") ; move to PE file header
	$pPointer += 4 ; size of skipped $tIMAGE_NT_SIGNATURE structure
	; In place of IMAGE_FILE_HEADER structure
	Local $tIMAGE_FILE_HEADER = DllStructCreate("word Machine;" & _
			"word NumberOfSections;" & _
			"dword TimeDateStamp;" & _
			"dword PointerToSymbolTable;" & _
			"dword NumberOfSymbols;" & _
			"word SizeOfOptionalHeader;" & _
			"word Characteristics", _
			$pPointer)
	; Get number of sections
	Local $iNumberOfSections = DllStructGetData($tIMAGE_FILE_HEADER, "NumberOfSections")
	; Move pointer
	$pPointer += 20 ; size of $tIMAGE_FILE_HEADER structure
	; Determine the type
	Local $tMagic = DllStructCreate("word Magic;", $pPointer)
	Local $iMagic = DllStructGetData($tMagic, 1)
	Local $tIMAGE_OPTIONAL_HEADER
	If $iMagic = 267 Then ; x86 version
		If $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"dword BaseOfData;" & _
				"dword ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"dword SizeOfStackReserve;" & _
				"dword SizeOfStackCommit;" & _
				"dword SizeOfHeapReserve;" & _
				"dword SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		; Move pointer
		$pPointer += 96 ; size of $tIMAGE_OPTIONAL_HEADER
	ElseIf $iMagic = 523 Then ; x64 version
		If Not $__Au3Obj_X64 Then Return SetError(1, 0, -1) ; incompatible versions
		$tIMAGE_OPTIONAL_HEADER = DllStructCreate("word Magic;" & _
				"byte MajorLinkerVersion;" & _
				"byte MinorLinkerVersion;" & _
				"dword SizeOfCode;" & _
				"dword SizeOfInitializedData;" & _
				"dword SizeOfUninitializedData;" & _
				"dword AddressOfEntryPoint;" & _
				"dword BaseOfCode;" & _
				"uint64 ImageBase;" & _
				"dword SectionAlignment;" & _
				"dword FileAlignment;" & _
				"word MajorOperatingSystemVersion;" & _
				"word MinorOperatingSystemVersion;" & _
				"word MajorImageVersion;" & _
				"word MinorImageVersion;" & _
				"word MajorSubsystemVersion;" & _
				"word MinorSubsystemVersion;" & _
				"dword Win32VersionValue;" & _
				"dword SizeOfImage;" & _
				"dword SizeOfHeaders;" & _
				"dword CheckSum;" & _
				"word Subsystem;" & _
				"word DllCharacteristics;" & _
				"uint64 SizeOfStackReserve;" & _
				"uint64 SizeOfStackCommit;" & _
				"uint64 SizeOfHeapReserve;" & _
				"uint64 SizeOfHeapCommit;" & _
				"dword LoaderFlags;" & _
				"dword NumberOfRvaAndSizes", _
				$pPointer)
		; Move pointer
		$pPointer += 112 ; size of $tIMAGE_OPTIONAL_HEADER
	Else
		Return SetError(1, 0, -1) ; incompatible versions
	EndIf
	; Extract data
	Local $iEntryPoint = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "AddressOfEntryPoint") ; if loaded binary image would start executing at this address
	Local $pOptionalHeaderImageBase = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "ImageBase") ; address of the first byte of the image when it's loaded in memory
	$pPointer += 8 ; skipping IMAGE_DIRECTORY_ENTRY_EXPORT
	; Import Directory
	Local $tIMAGE_DIRECTORY_ENTRY_IMPORT = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddressImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "VirtualAddress")
	Local $iSizeImport = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_IMPORT, "Size")
	$pPointer += 8 ; size of $tIMAGE_DIRECTORY_ENTRY_IMPORT
	$pPointer += 24 ; skipping IMAGE_DIRECTORY_ENTRY_RESOURCE, IMAGE_DIRECTORY_ENTRY_EXCEPTION, IMAGE_DIRECTORY_ENTRY_SECURITY
	; Base Relocation Directory
	Local $tIMAGE_DIRECTORY_ENTRY_BASERELOC = DllStructCreate("dword VirtualAddress; dword Size", $pPointer)
	; Collect data
	Local $pAddressNewBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "VirtualAddress")
	Local $iSizeBaseReloc = DllStructGetData($tIMAGE_DIRECTORY_ENTRY_BASERELOC, "Size")
	$pPointer += 8 ; size of IMAGE_DIRECTORY_ENTRY_BASERELOC
	$pPointer += 40 ; skipping IMAGE_DIRECTORY_ENTRY_DEBUG, IMAGE_DIRECTORY_ENTRY_COPYRIGHT, IMAGE_DIRECTORY_ENTRY_GLOBALPTR, IMAGE_DIRECTORY_ENTRY_TLS, IMAGE_DIRECTORY_ENTRY_LOAD_CONFIG
	$pPointer += 40 ; five more generally unused data directories
	; Load the victim
	Local $pBaseAddress = __Au3Obj_Mem_LoadLibraryEx($sSubrogor, 1) ; "lighter" loading, DONT_RESOLVE_DLL_REFERENCES
	If @error Then
		Return SetError(2, 0, -1) ; Couldn't load subrogor
	EndIf
	Local $pHeadersNew = DllStructGetPtr($tIMAGE_DOS_HEADER) ; starting address of binary image headers
	Local $iOptionalHeaderSizeOfHeaders = DllStructGetData($tIMAGE_OPTIONAL_HEADER, "SizeOfHeaders") ; the size of the MS-DOS stub, the PE header, and the section headers
	; Set proper memory protection for writting headers (PAGE_READWRITE)
	If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress, $iOptionalHeaderSizeOfHeaders, 4) Then Return SetError(3, 0, -1) ; Couldn't set proper protection for headers
	; Write NEW headers
	DllStructSetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pBaseAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iOptionalHeaderSizeOfHeaders & "]", $pHeadersNew), 1))
	; Dealing with sections. Will write them.
	Local $tIMAGE_SECTION_HEADER
	Local $iSizeOfRawData, $pPointerToRawData
	Local $iVirtualSize, $iVirtualAddress
	Local $tImpRaw, $tRelocRaw
	For $i = 1 To $iNumberOfSections
		$tIMAGE_SECTION_HEADER = DllStructCreate("char Name[8];" & _
				"dword UnionOfVirtualSizeAndPhysicalAddress;" & _
				"dword VirtualAddress;" & _
				"dword SizeOfRawData;" & _
				"dword PointerToRawData;" & _
				"dword PointerToRelocations;" & _
				"dword PointerToLinenumbers;" & _
				"word NumberOfRelocations;" & _
				"word NumberOfLinenumbers;" & _
				"dword Characteristics", _
				$pPointer)
		; Collect data
		$iSizeOfRawData = DllStructGetData($tIMAGE_SECTION_HEADER, "SizeOfRawData")
		$pPointerToRawData = $pHeadersNew + DllStructGetData($tIMAGE_SECTION_HEADER, "PointerToRawData")
		$iVirtualAddress = DllStructGetData($tIMAGE_SECTION_HEADER, "VirtualAddress")
		$iVirtualSize = DllStructGetData($tIMAGE_SECTION_HEADER, "UnionOfVirtualSizeAndPhysicalAddress")
		If $iVirtualSize And $iVirtualSize < $iSizeOfRawData Then $iSizeOfRawData = $iVirtualSize
		; Set MEM_EXECUTE_READWRITE for sections (PAGE_EXECUTE_READWRITE for all for simplicity)
		If Not __Au3Obj_Mem_VirtualProtect($pBaseAddress + $iVirtualAddress, $iVirtualSize, 64) Then
			$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
			ContinueLoop
		EndIf
		; Clean the space
		DllStructSetData(DllStructCreate("byte[" & $iVirtualSize & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iVirtualSize & "]"), 1))
		; If there is data to write, write it
		If $iSizeOfRawData Then
			DllStructSetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pBaseAddress + $iVirtualAddress), 1, DllStructGetData(DllStructCreate("byte[" & $iSizeOfRawData & "]", $pPointerToRawData), 1))
		EndIf
		; Relocations
		If $iVirtualAddress <= $pAddressNewBaseReloc And $iVirtualAddress + $iSizeOfRawData > $pAddressNewBaseReloc Then
			$tRelocRaw = DllStructCreate("byte[" & $iSizeBaseReloc & "]", $pPointerToRawData + ($pAddressNewBaseReloc - $iVirtualAddress))
		EndIf
		; Imports
		If $iVirtualAddress <= $pAddressImport And $iVirtualAddress + $iSizeOfRawData > $pAddressImport Then
			$tImpRaw = DllStructCreate("byte[" & $iSizeImport & "]", $pPointerToRawData + ($pAddressImport - $iVirtualAddress))
			__Au3Obj_Mem_FixImports($tImpRaw, $pBaseAddress) ; fix imports in place
		EndIf
		; Move pointer
		$pPointer += 40 ; size of $tIMAGE_SECTION_HEADER structure
	Next
	; Fix relocations
	If $pAddressNewBaseReloc And $iSizeBaseReloc Then __Au3Obj_Mem_FixReloc($tRelocRaw, $pBaseAddress, $pOptionalHeaderImageBase, $iMagic = 523)
	; Entry point address
	Local $pEntryFunc = $pBaseAddress + $iEntryPoint
	; DllMain simulation
	__Au3Obj_PointerCall("bool", $pEntryFunc, "ptr", $pBaseAddress, "dword", 1, "ptr", 0) ; DLL_PROCESS_ATTACH
	; Get pseudo-handle
	Local $hPseudo = DllOpen($sSubrogor)
	__Au3Obj_Mem_FreeLibrary($pBaseAddress) ; decrement reference count
	Return $hPseudo
EndFunc   ;==>__Au3Obj_Mem_DllOpen

Func __Au3Obj_Mem_FixReloc($tData, $pAddressNew, $pAddressOld, $fImageX64)
	Local $iDelta = $pAddressNew - $pAddressOld ; dislocation value
	Local $iSize = DllStructGetSize($tData) ; size of data
	Local $pData = DllStructGetPtr($tData) ; addres of the data structure
	Local $tIMAGE_BASE_RELOCATION, $iRelativeMove
	Local $iVirtualAddress, $iSizeofBlock, $iNumberOfEntries
	Local $tEnries, $iData, $tAddress
	Local $iFlag = 3 + 7 * $fImageX64 ; IMAGE_REL_BASED_HIGHLOW = 3 or IMAGE_REL_BASED_DIR64 = 10
	While $iRelativeMove < $iSize ; for all data available
		$tIMAGE_BASE_RELOCATION = DllStructCreate("dword VirtualAddress; dword SizeOfBlock", $pData + $iRelativeMove)
		$iVirtualAddress = DllStructGetData($tIMAGE_BASE_RELOCATION, "VirtualAddress")
		$iSizeofBlock = DllStructGetData($tIMAGE_BASE_RELOCATION, "SizeOfBlock")
		$iNumberOfEntries = ($iSizeofBlock - 8) / 2
		$tEnries = DllStructCreate("word[" & $iNumberOfEntries & "]", DllStructGetPtr($tIMAGE_BASE_RELOCATION) + 8)
		; Go through all entries
		For $i = 1 To $iNumberOfEntries
			$iData = DllStructGetData($tEnries, 1, $i)
			If BitShift($iData, 12) = $iFlag Then ; check type
				$tAddress = DllStructCreate("ptr", $pAddressNew + $iVirtualAddress + BitAND($iData, 0xFFF)) ; the rest of $iData is offset
				DllStructSetData($tAddress, 1, DllStructGetData($tAddress, 1) + $iDelta) ; this is what's this all about
			EndIf
		Next
		$iRelativeMove += $iSizeofBlock
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixReloc

Func __Au3Obj_Mem_FixImports($tData, $hInstance)
	Local $pImportDirectory = DllStructGetPtr($tData)
	Local $hModule, $tFuncName, $sFuncName, $pFuncAddress
	Local $tIMAGE_IMPORT_MODULE_DIRECTORY, $tModuleName
	Local $tBufferOffset2, $iBufferOffset2
	Local $iInitialOffset, $iInitialOffset2, $iOffset
	While 1
		$tIMAGE_IMPORT_MODULE_DIRECTORY = DllStructCreate("dword RVAOriginalFirstThunk;" & _
				"dword TimeDateStamp;" & _
				"dword ForwarderChain;" & _
				"dword RVAModuleName;" & _
				"dword RVAFirstThunk", _
				$pImportDirectory)
		If Not DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk") Then ExitLoop ; the end
		$tModuleName = DllStructCreate("char Name[64]", $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAModuleName"))
		$hModule = __Au3Obj_Mem_LoadLibraryEx(DllStructGetData($tModuleName, "Name")) ; load the module, full load
		$iInitialOffset = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAFirstThunk")
		$iInitialOffset2 = $hInstance + DllStructGetData($tIMAGE_IMPORT_MODULE_DIRECTORY, "RVAOriginalFirstThunk")
		If $iInitialOffset2 < $iInitialOffset Then $iInitialOffset2 = $iInitialOffset
		$iOffset = 0 ; back to 0
		While 1
			$tBufferOffset2 = DllStructCreate("ptr", $iInitialOffset2 + $iOffset)
			$iBufferOffset2 = DllStructGetData($tBufferOffset2, 1) ; value at that address
			If Not $iBufferOffset2 Then ExitLoop ; zero value is the end
			If Number(BinaryMid($iBufferOffset2, $__Au3Obj_tagPTR_SIZE, 1)) Then ; MSB is set for imports by ordinal, otherwise not
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, BitAND($iBufferOffset2, 0xFFFFFF)) ; the rest is ordinal value
			Else
				$tFuncName = DllStructCreate("word Ordinal; char Name[64]", $hInstance + $iBufferOffset2)
				$sFuncName = DllStructGetData($tFuncName, "Name")
				$pFuncAddress = __Au3Obj_Mem_GetAddress($hModule, $sFuncName)
			EndIf
			DllStructSetData(DllStructCreate("ptr", $iInitialOffset + $iOffset), 1, $pFuncAddress) ; and this is what's this all about
			$iOffset += $__Au3Obj_tagPTR_SIZE ; size of $tBufferOffset2
		WEnd
		$pImportDirectory += 20 ; size of $tIMAGE_IMPORT_MODULE_DIRECTORY
	WEnd
	Return 1 ; all OK!
EndFunc   ;==>__Au3Obj_Mem_FixImports

Func __Au3Obj_Mem_LoadLibraryEx($sModule, $iFlag = 0)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "handle", "LoadLibraryExW", "wstr", $sModule, "handle", 0, "dword", $iFlag)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_LoadLibraryEx

Func __Au3Obj_Mem_FreeLibrary($hModule)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "FreeLibrary", "handle", $hModule)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_FreeLibrary

Func __Au3Obj_Mem_GetAddress($hModule, $vFuncName)
	Local $sType = "str"
	If IsNumber($vFuncName) Then $sType = "int" ; if ordinal value passed
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "ptr", "GetProcAddress", "handle", $hModule, $sType, $vFuncName)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return $aCall[0]
EndFunc   ;==>__Au3Obj_Mem_GetAddress

Func __Au3Obj_Mem_VirtualProtect($pAddress, $iSize, $iProtection)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "bool", "VirtualProtect", "ptr", $pAddress, "dword_ptr", $iSize, "dword", $iProtection, "dword*", 0)
	If @error Or Not $aCall[0] Then Return SetError(1, 0, 0)
	Return 1
EndFunc   ;==>__Au3Obj_Mem_VirtualProtect

Func __Au3Obj_Mem_BinDll()
	Local $bBinary = "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000D80000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A24000000000000007D90769639F118C539F118C539F118C51E3763C53CF118C539F119C523F118C5308992C533F118C530898AC538F118C530898CC538F118C5308989C538F118C55269636839F118C500000000000000000000000000000000504500004C01050084D9D94B0000000000000000E00002210B01090000160000000E000000000000A122000000100000003000000000001000100000000200000500000000000000050000000000000000700000000400000000000002004005000010000010000000001000001000000000000010000000E032000082010000C03100003C0000000050000080030000000000000000000000000000000000000060000008010000603000001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000540000000000000000000000000000000000000000000000000000002E74657874000000A8150000001000000016000000040000000000000000000000000000200000602E72646174610000" & _
			"BB0400000030000000060000001A0000000000000000000000000000400000402E646174610000000C000000004000000000000000000000000000000000000000000000400000C02E7273726300000080030000005000000004000000200000000000000000000000000000400000402E72656C6F6300007001000000600000000200000024000000000000000000000000000040000042000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"832600836618008D460850FF153C3000108BC6C38B0685C0740750E858150000598B4424048D5002668B0840406685C975F62BC2D1F833C96A02405AF7E20F90C1F7D90BC851E8191500008B5424085989060FB70A426689084240406685C975F1C204008B442404FF40048B4004C20400568B742408FF4E048B460475268D461850C7067C300010FF15443000108B46088B0850FF51088366080056E8D71400005933C05EC20400558BEC83EC2033C0568B750C33C95766894DF466894DF666894DE466894DE66A04598D7DF033D28945F0C645F8C08845F98845FA8845FB8845FC8845FD8845FEC645FF46F3A7C745E004040200C645E8C08845E98845EA8845EB8845EC8845ED8845EEC645EF46741B8B750C6A04598D7DE033D2F3A7740C8B4D108901B802400080EB108B45088B4D1089018B0850FF510433C05F5EC9C20C00FF74240C8B4424088D481851FF7008FF700C6A00FF15004000108B4C2410890133C985C00F94C18BC1C210008B4424046A008D481851FF7008FF70146A01FF1500400010F7D81BC040C208008B4424046A008D481851FF7008FF70106A02FF1500400010F7D81BC040C20400538BD8568B353C3000105733FFC70354310010897B04897B08897B0C897B10897B148D432850897B18897B1C897B20897B24FFD68D433850FFD68D434850FFD68D435850FFD66A20E869130000593BC7740B"
	$bBinary &= "8BF0E8F9FDFFFF8BF0EB0233F66898300010897E18C7461C02000000E8F3FDFFFF56E8350A00005F5E8BC35BC3558BEC5151538BD833C0894304894308C7035431001089430C894310894314568B353C30001089431889431C8943208943248D432850FFD68D433850FFD68D434850FFD68D435850FFD68365F800837F1000765F6A20E8DC1200005985C0740C8BF0E86CFDFFFF8945FCEB078365FC008B45FC8B4F0C8B55F88B34918B4E188948188D4E085183C00850FF15403000108B4E1C8B45FC89481CFF368BF0E845FDFFFF56E887090000FF45F88B45F83B471072A18B471885C0740EFF77208BF3FF771C50E8DF0900005E8BC35BC9C35333DB56C70754310010395F1076158B470C8B349885F67405E869000000433B5F1072EBFF770CE8511200008B354430001083670C008367100083671400598D472850FFD68D474850FFD68D473850FFD68B47185E5B85C0740750E81D120000598B471C85C0740750E80F120000598B472085C0740750E80112000059FF770CE8F811000059C38B0685C0740750E8EA110000598D460850FF154430001056E8D9110000598BC6C3558BEC5151578B7D08FF4F048B47040F85BA000000833D04400010000F849F000000568D772856FF15443000108365FC008D45F8506A016A0CC745F802000000FF1534300010FF4708FF4704894730B80C2000006689068B77104E744B" & _
			"538B470C8B1CB08B03B9B0300010668B11663B10751E6685D27415668B5102663B5002750F83C10483C0046685D275DE33C0EB051BC083D8FF85C0750A57FF7310FF15044000104E75B75B8B3544300010FF4F048D474850FFD68D472850FFD6FF4F085EE892FEFFFF57E8091100005933C05FC9C20400558BEC568B7510FF3668B4300010E8BE100000595985C075108B451CC700FCFFFFFF33C05E5DC21800FF3668C8300010E89C100000595985C0750B8B451CC7007CFCFFFFEBDCFF3668E0300010E87F100000595985C0750B8B451CC7007BFCFFFFEBBFFF3668F8300010E862100000595985C0750B8B451CC7007AFCFFFFEBA2FF36680C310010E845100000595985C0750B8B451CC70079FCFFFFEB85FF366824310010E828100000595985C0750E8B451CC70078FCFFFFE965FFFFFFFF366840310010E808100000595985C0750E8B451CC70077FCFFFFE945FFFFFFFF368B7508E8B20C00008B4D1C890183F8FF0F852DFFFFFFB806000280E925FFFFFF558BEC8B55188B450C83EC14538BCA83E10156570F85C2000000F6C2020F85B9000000F6C20C0F84010200003D7CFCFFFF756D8B751C837E08020F859A0600008B460433DB8338FD0F94C333C085DB0F95C08BF88B06C1E70403C70FB70883F915741983F914741483F91A741B83F913741683F9037411E9920000006A136A005050FF152C3000108B36" & _
			"33C085DB0F94C0C1E00403C650FF743E08E98C0000003D7AFCFFFF75188B4508837808000F842606000083C0388B4D1CFF3150EB6D3D79FCFFFF0F85630100008B4508837808000F840306000083C048EBDB3D7CFCFFFF75568B751C837E08010F85EA0500008B060FB70883F915741E83F914741983F91A742083F913741B83F9037416B805000280E9C70500006A136A005050FF152C3000108B06FF7008FF7520FF154030001033C0E9A60500003D7BFCFFFF75138B4508837808000F848D05000083C02850EBD63D7AFCFFFF75088B450883C038EBEE3D78FCFFFF75128B4508837808000F846405000083C058EBD53D77FCFFFF752B8B7D08837F08000F844B0500008B752056FF15443000106A0858668906FF7724FF1548300010894608EB8583F8FC757B8B7D08837F18000F841B0500008B5D2053FF15443000106A0D586A28668903E8180E00008BF05985F674408B471C8B5F208945088B47188366040089451CC7067C300010897E088B0757FF50048B451C89460C8B45088946108D461850895E14FF153C3000108B5D20EB0233F68973088B0656FF5004E905FFFFFF33DB3BC30F8CA30400008B75088B7E10473BC70F8D940400008B7E0C8B3C87663BCB0F852D020000F6C2020F8524020000F6C20C0F8473040000395F1C7409395E080F84650400008B4718480F8446010000480F85540400008B751C8B"
	$bBinary &= "460883F8027573B80C200000663947080F8510010000FF7710FF153030001083F8010F85FE0000008B460433C98338FD8B060F94C133DB6A0385C90F95C3894D2059C1E30403C3663B08740B516A005050FF152C3000108B3633C03945200F94C0C1E00403C6508D44330850FF7710FF1520300010E91F02000083F8030F85A3000000B80C200000663947080F8594000000FF7710FF153030001083F8020F85820000008B46048B0E33DB8338FD6A030F94C38BC3F7D81BC083E002C1E00403C159663B08740B516A005050FF152C3000108B066A0383C01059663B08740B516A005050FF152C3000108B3633C085DB0F95C0C1E0048B4430088945F833C085DB0F95C040C1E0048B443008F7DB1BDB83E3FE4343C1E30403DE8945FC538D45F8E945FFFFFF837E08010F8508020000FF3683C70857E967FDFFFFFF46088B078B1D443000108946248D462850FFD38D464850FFD38B451C8B40088365F00089450883C0028945EC8D45EC506A016A0CFF15343000108D4DF451508945FCFF153830001085C0754B8B4D0885C97E3B8BC1C1E004C7450820000000894518894D0C8B451C8B008B4D188D4408F08B4D08508B45F403C150FF154030001083450810836D1810FF4D0C75D7FF75FCFF154C3000108B45FC894630B80C200000668946286A0358668946588B4660C7466001000000E9160200008B4718480F844901" & _
			"0000480F8547020000837F1C027509395E080F84380200008B751C8B460883F8010F8580000000B80C200000663947080F85FD000000FF7710FF153030001083F8010F85EB0000008B066A0359663B08740A51535050FF152C3000108B368D46088338FF75268B752056FF15443000106A035866890683C608566A01FF7710FF1524300010FF06E91CFCFFFFFF752050FF7710FF1528300010F7D81BC02509000280E9AE01000083F8020F8583000000B80C200000663947087578FF7710FF153030001083F802756A8B068B1D2C3000106A0359663B087407516A005050FFD38B066A0383C01059663B087407516A005050FFD38B368B46088945F88B76188975FC83FEFF75248B752056FF15443000106A035866890683C60833C0837DF802560F95C04050E951FFFFFF8D45F8E959FFFFFF395E08740AB80E000280E91301000083C70857E954FBFFFF395F1C7409395E080F84F7000000FF46088B078B1D443000108946248D462850FFD38D464850FFD38B451C8B40088365F00089450883C0028945EC8D45EC506A016A0CFF15343000108D4DF451508945FCFF153830001085C0754B8B4D0885C97E3B8BC1C1E004C7450820000000894518894D0C8B451C8B008B4D188D4408F08B4D08508B45F403C851FF154030001083450810836D1810FF4D0C75D7FF75FCFF154C3000108B45FC894630B80C20000066894628" & _
			"6A0358668946588B46608366600056FF771089451CFF15044000108D7E4857FF75208945088B451C894660FF15403000108D462850FFD357FFD3FF4E088B4508F7D81BC025FDFFFD7F0503000280EB05B8030002805F5E5BC9C2240056578B7C240CFF378BF3E8A505000083F8FF74568B0FBEB0300010668B16663B11751E6685D27415668B5602663B5102750F83C60483C1046685D275DE33C9EB051BC983D9FF85C974208BF88B430CC1E7028B340785F67405E8C8F6FFFF8B430C8B4C240C890C07EB09578D730CE8720500005F5EC20400558BEC8B461885C0740750E894080000598B4508576A028D50025F668B0803C76685C975F62BC2D1F833C9408BD7F7E20F90C1F7D90BC851E8530800008B5508598946180FB70A66890803D703C76685C975F18B461C85C0740750E844080000598B450C8D5002668B0803C76685C975F62BC2D1F833C9408BD7F7E20F90C1F7D90BC851E8070800008B550C5989461C0FB70A66890803D703C76685C975F18B462085C0740750E8F8070000598B45108D5002668B0803C76685C975F62BC2D1F833C9408BD7F7E20F90C1F7D90BC851E8BB0700008B5510598946200FB70A66890803D703C76685C975F15F5DC20C008B460485C0740750E8A7070000598B4424048D5002668B0840406685C975F62BC2D1F833C96A02405AF7E20F90C1F7D90BC851E8680700008B542408"
	$bBinary &= "598946040FB70A426689084240406685C975F1C20400558BEC83EC1033C053894704894708C707803100108D5F0C568B353C30001089038943048943088D472050FFD68D473050FFD68B45088B550C8365F800836508008947188BC28955F48D4802668B3040406685F675F62BC1D1F833F68945F08975FC8D04720FB7086683F97C750E33C96689088D4472028945F8EB5A6683F90A74056685C9754F33C96A0C668908E8BB06000033F6593BC6740B834808FF89308970048BF0FF75F4E851F1FFFFFF75F8E8F9FEFFFF8B4508894608568BF3E8680300008B450C8B4DFCFF45088B550C8D4448028945F48B75FC468975FC3B75F076805E8BC75BC9C208008B0685C0740750E86C060000598B460485C0740750E85E0600005956E857060000598BC6C3578B7C2408FF4F048B47047507E80600000033C05FC204005333DBC70780310010395F107617568B470C8B349885F67405E8A5FFFFFF433B5F1072EB5EFF770CE80E06000083670C0083671000836714008B4718598B0850FF5108FF770CE8F005000057E8EA05000059598BC75BC3B802400080C20C00B801400080C20800B801400080C21000558BEC568B7510FF366870310010E889050000595985C075108B451CC700DCFCFFFF33C05E5DC21800FF3668E0300010E867050000595985C0750B8B451CC7007BFCFFFFEBDCFF36680C310010E84A0500005959" & _
			"85C0750B8B451CC70079FCFFFFEBBFFF368B7508E8F70100008B4D1C890183F8FF75ABB806000280EBA6558BEC8B55188B450C83EC18538BCA83E10156577529F6C2027524F6C20C74693D79FCFFFF75628B4508837808000F84A60100008B4D1CFF3183C03050EB423DDCFCFFFF75208B752056FF15443000106A13586689068B45088B401889460833C0E9790100003D7BFCFFFF751C8B4508837808000F846001000083C02050FF7520FF1540300010EBD685C00F8C490100008B75083B46100F8D3D0100008B7E0C8B1C87895DF46685C97509F6C2020F84260100008B46188B008B3D443000108945F08D462050FFD78D463050FFD78B451C8B48088B43048365EC008D5002894D18895508668B1040406685D275F62B45086A00D1F8580F95C040410FAFC88945088D45E8506A0183C1036A0C894DE8FF15343000108D4DFC515089450CFF153830001085C075603945187E528B45088B5D18C1E0048945F833C0837D08020F94C08D440004C1E0048945088B4518C1E3048945188B451C8B008B4D088D4418F0508B45FC03C851FF15403000108B45F801450883EB10FF4D1875D98B5DF4FF750CFF154C3000108B450CFF7520FF46088946288D4620B90C2000006689088B4DF08945088B451CFF70088B430856FF7304FF7618FF3481FF15084000108D5E3053FF7520FF1540300010FF7508FF4E08FFD753FFD7E9" & _
			"85FEFFFFB8030002805F5E5BC9C224005733FF397E10761E8B460C8B04B88B00FF74240850E862030000595985C0740D473B7E1072E283C8FF5FC204008BC7EBF88B46048D48013B4E0876465733C96A048D4400025AF7E20F90C1F7D90BC851E8FF0200008BF833C059394604760E8B0E8B0C81890C87403B460472F2FF36E8F40200008B4604598D4C0002893E894E085F8B0E8B542404891481FF4604C2040033C040C20C006A68E8B60200005985C07405E9F6EEFFFF33C0C36A68E8A20200005985C0740D578B7C2408E85CEFFFFF5FEB0233C0C204008B442404A3044000108B442408A300400010C208005356576A20E86C0200005985C0740B8BF0E8FCECFFFF8BF0EB0233F68B44241CFF742414C746180100000089461CE8F3ECFFFF8D7E0866833F00740757FF15443000106A0858FF742418668907FF15483000108B5C241056894610E80EF9FFFF5F5E5BC21000558BEC56578B7D08FF750C8BF7E8AAFEFFFF83F8FF89450C7E2A538BD88B470CC1E3028B340385F67405E8FFEFFFFFFF4F108B471039450C73098B7F0C8B048789041F5B5F5E5DC2080056FF7424148B74240CFF742414FF742414E820F9FFFF5EC21000558BEC53566A20E8A00100005985C0740B8BF0E830ECFFFF8BF0EB0233F6837D1400C7461802000000740DFF75148D460850FF15403000108B4510FF750C89461CE816ECFFFF8B5D"
	$bBinary &= "0856E855F8FFFF5E5B5DC210008B442404A308400010C20400566A40E8430100008BF033C0593BF07432894604894608C7068031001089460C8946108946148B442408578B3D3C3000108946188D462050FFD78D463050FFD78BC65F5EC204006A40E8FD0000005985C0741357FF74240C8BF8FF74240CE89AF9FFFF5FEB0233C0C20800558BEC56576A0CE8D400000033FF593BC7740B834808FF89388978048BF8FF750C8BF7E868EBFFFF8B4514FF7510894708E80AF9FFFFFF378B7508E84CFDFFFF83F8FF750B5783C60CE86FFDFFFFEB21538BD88BC68B400CC1E3028B340385F67405E815FAFFFF8B45088B400C893C035B5F5E5DC21000558BEC817D08ADDE00007530817D0CEFBE00007527566AF5FF150C3000106A008BF08D4508506A22689C31001056FF150030001056FF15083000105E5DC208008B4424048B0850FF5104C204006AFFFF74240C6AFFFF7424106A006800080000FF15043000104848C3FF7424046A00FF151030001050FF1518300010C3FF7424046A00FF151030001050FF1514300010C36AFFFF74240C6AFFFF7424106A016800080000FF15043000104848C300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"503200005C3200006E32000082320000C6320000BA320000AE320000000000001A00008013000080190000800C000080110000800F00008017000080080000800A000080090000800200008018000080000000000000000000000000000000000000000084D9D94B00000000020000005700000064340000641E0000A81000106410001071100010421100106E1100108E1100109C1F00105F005F00640065006600610075006C0074005F005F0000007E0000005F004E006500770045006E0075006D00000000005F005F006200720069006400670065005F005F00000000005F005F0070006100720061006D0073005F005F00000000005F005F006500720072006F0072005F005F0000005F005F0072006500730075006C0074005F005F00000000005F005F00700072006F007000630061006C006C005F005F00000000005F005F006E0061006D0065005F005F0000000000941F001064100010A31300109C1F0010A41F001077140010761500105F005F007000740072005F005F000000941F001064100010251F00109C1F0010A41F0010AC1F00102A2000104C6F6C2E20596F7520666F756E6420746865206561737465722D6567672E200D0A000000FC310000000000000000000092320000003000001C3200000000000000000000A032000020300000000000000000000000000000000000000000000050320000" & _
			"5C3200006E32000082320000C6320000BA320000AE320000000000001A00008013000080190000800C000080110000800F00008017000080080000800A000080090000800200008018000080000000008D04577269746546696C65005500436F6D70617265537472696E675700004101466C75736846696C654275666665727300003B0247657453746448616E646C6500004B45524E454C33322E646C6C00004F4C4541555433322E646C6C00009D0248656170416C6C6F6300A10248656170467265650000230247657450726F6365737348656170000000000000000000000000000083D9D94B000000008A330000010000000D0000000D000000083300003C330000703300009E230000EE220000B8230000BB220000A722000019240000602400003B250000D92200000D240000FB24000054230000842400009B330000A3330000AD330000B9330000CB330000DE330000F233000008340000173400002234000034340000443400005134000000000100020003000400050006000700080009000A000B000C004175746F49744F626A6563742E646C6C00416464456E756D004164644D6574686F640041646450726F706572747900436C6F6E654175746F49744F626A656374004372656174654175746F49744F626A65637400437265617465577261707065724F626A65637400437265617465577261707065724F"
	$bBinary &= "626A65637445780049556E6B6E6F776E41646452656600496E697469616C697A6500496E697469616C697A6557726170706572004D656D6F727943616C6C456E7472790052656D6F76654D656D62657200577261707065724164644D6574686F640000005253445346BEC1591B85574299A3279E3DB68FA201000000633A5C55736572735C7472616E636578785C4465736B746F705C4175746F49744F626A656374325C7472756E6B5C4175746F49744F626A6563742E7064620000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"000000000000000000000000000001001000000018000080000000000000000000000000000001000100000030000080000000000000000000000000000001000904000048000000605000002003000000000000000000000000000000000000200334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE0000010001000100000000000100010000000000000000000000000004000000020000000000000000000000000000007E020000010053007400720069006E006700460069006C00650049006E0066006F0000005A0200000100300034003000390030003400420030000000300008000100460069006C006500560065007200730069006F006E000000000031002E0031002E0030002E0030000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0031002E0030002E00300000007A0029000100460069006C0065004400650073006300720069007000740069006F006E0000000000500072006F007600690064006500730020006F0062006A006500630074002000660075006E006300740069006F006E0061006C00690074007900200066006F00720020004100750074006F0049007400000000003A000D000100500072006F0064007500630074004E0061006D006500000000004100750074006F00" & _
			"490074004F0062006A00650063007400000000005E001D0001004C006500670061006C0043006F0070007900720069006700680074000000280043002900200062007900200054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000004A00110001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000004100750074006F00490074004F0062006A006500630074002E0064006C006C00000000007A002300010054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000006D006F006E006F00630065007200650073002C0020007400720061006E0063006500780078002C0020004B00690070002C002000500072006F00670041006E006400790000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000904B0040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	$bBinary &= "00100000940000000D3084308A3058318231A231B431BD310E323F324F32B932013329339533BA33CC33E5330A3443344D348134A334C034DD34FA3417353735FA359636A4360B371A373B3768378A371B38533871389738CE38E638423972398039B939CF393B3A583A6C3A813A953AC03ACD3A0D3B603B903B9E3BD73BED3B173C2D3C733C273E313E423FB63FD83FF53F000000200000400000007630AD30E5303B3149319331AD31E331F031DE32E7322D333D33EC33123432344634153524352B3532355D356C35733580358735A135000000300000340000007C308030843088308C3090309430543158315C316031643168316C318031843188318C3190319431983100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	Return Binary($bBinary)
EndFunc   ;==>__Au3Obj_Mem_BinDll

Func __Au3Obj_Mem_BinDll_X64()
	Local $bBinary = "0x4D5A90000300000004000000FFFF0000B800000000000000400000000000000000000000000000000000000000000000000000000000000000000000E00000000E1FBA0E00B409CD21B8014CCD21546869732070726F6772616D2063616E6E6F742062652072756E20696E20444F53206D6F64652E0D0D0A2400000000000000C9CCEE978DAD80C48DAD80C48DAD80C4AA6BFBC488AD80C48DAD81C497AD80C493FF0AC487AD80C493FF12C48CAD80C484D514C48CAD80C493FF11C48CAD80C4526963688DAD80C4000000000000000000000000000000000000000000000000504500006486060068D9D94B0000000000000000F00022200B020900001E0000001200000000000068280000001000000000008001000000001000000002000005000200000000000500020000000000008000000004000000000000020040010000100000000000001000000000000000001000000000000010000000000000000000001000000090350000860100001C3400003C0000000060000080030000005000008C01000000000000000000000070000034000000B03000001C0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000300000A80000000000000000000000000000000000000000000000000000002E74657874000000EF1C000000100000001E000000040000" & _
			"000000000000000000000000200000602E7264617461000016070000003000000008000000220000000000000000000000000000400000402E6461746100000018000000004000000000000000000000000000000000000000000000400000C02E706461746100008C0100000050000000020000002A0000000000000000000000000000400000402E72737263000000800300000060000000040000002C0000000000000000000000000000400000402E72656C6F63000066000000007000000002000000300000000000000000000000000000400000420000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"48895C240848896C24104889742418574883EC20488BF1488B0933ED488BDA483BCD7405E8A31C00004983C8FF33C0488BFB498BC866F2AF418D400348F7D148F7E1490F40C0488BC8E85A1C00004889060FB70B4883C3026689084883C002663BCD75ED488B5C2430488B6C2438488B7424404883C4205FC3CCCCCC40534883EC20834108FF488BD9752F488D053E2000004889014883C130FF15E91F0000488B4B10488B01FF50104883631000488BCBE8161C000033C0EB038B41084883C4205BC3CC488BC44883EC484C8B124533DB4C8BC9488D48D8C640E0C0C640E746448958D866448958DC66448958DE448858E1448858E2448858E3448858E4448858E5448858E6C740E80404020066448958EC66448958EEC640F0C0448858F1448858F2448858F3448858F4448858F5448858F6C640F7464C3B11750F4C8B52084C3B51087505418BC3EB051BC083D8FF413BC37430488B0A488D442430483B08750F488B4A08483B48087505418BC3EB051BC083D8FF413BC3740A4D8918B802400080EB0E4D8908498B01498BC9FF500833C04883C448C340534883EC30488B51184C894424204C8B4110498BD94C8D493033C9FF15462E000033C93BC189030F94C18BC14883C4305BC3CC40534883EC304C8B4110488B512833DB4C8D49308D4B0148895C2420FF15122E00003BC30F94C38BC34883C4305BC3CC40534883"
	$bBinary &= "EC304C8B4110488B512033DB4C8D49308D4B0248895C2420FF15E22D00003BC30F94C38BC34883C4305BC3CC48895C24084889742410574883EC2033F6488D05941F0000488BF948890189710889710C4889711089711889711C488971204889712848897130488971384883C140FF15041E0000488D4F58FF15FA1D0000488D4F70FF15F01D0000488D8F88000000FF15E31D00008D4E28E80B1A0000488BD8483BC67412488D4808488930897020FF15C31D0000EB03488BDE488D15471E0000488BCB897320C7432402000000E82DFDFFFF488BD3488BCFE8560D0000488B5C2430488B742438488BC74883C4205FC3CCCCCC488BC4488958084889681048897018488978204154415541564883EC204533F6488D05BD1E0000488BF9488901448971084489710C4C897110448971184489711C4C8971204C8971284C8971304C8971384883C140488BEAFF15261D0000488D4F58FF151C1D0000488D4F70FF15121D0000488D8F88000000FF15051D0000458BEE4439751876724D8BE6B928000000E81F190000488BF0493BC67413488D48084C893044897020FF15D61C0000EB03498BF6488B4510488D4E08498B1C048B4320488D5308894620FF15BD1C0000448B5B2444895E24488B13488BCEE82AFCFFFF488BD6488BCFE8530C000041FFC54983C408443B6D187291488B5520493BD674104C8B4D304C8B452848" & _
			"8BCFE8250D0000488B5C2440488B6C2448488B742450488BC7488B7C24584883C420415E415D415CC3CCCCCCFF41088B4108C3CC48895C241048896C241856574154415541564883EC204183CEFF488BD9440171080F85BB00000048833DA52B0000000F849C0000004883C140FF15151C00008364245400B90C0000004C8D4424508D51F5C744245002000000FF15D51B0000448B6318FF430CFF430848894348B80C2000004183EC01668943404963EC743648C1E503488B4310488D355E1C0000B9020000004C8B0428498B3866F3A7750D498B4810488BD3FF15282B00004883ED084503E675CE44017308488D4B70FF15911B0000488D4B40FF15871B00004401730CBA01000000488BCBE81E00000033C0EB038B4108488B5C2458488B6C24604883C420415E415D415C5F5EC348895C240848896C24104889742418574883EC20488D058D1C000033F6488BD9488901397118763A33FF488B4310488B2C074885ED7420488B4D004885C97405E857170000488D4D08FF15091B0000488BCDE845170000FFC64883C7083B731872C8488B4B10E83117000048836310008363180083631C00488D4B40FF15D61A0000488D4B70FF15CC1A0000488D4B58FF15C21A0000488B4B204885C97405E8F8160000488B4B284885C97405E8EA160000488B4B304885C97405E8DC160000488B4B10E8D3160000488BCBE8CB1600" & _
			"00488B6C2438488B742440488BC3488B5C24304883C4205FC3CCCCCCB802400080C3CCCC48895C2408574883EC20498B10488BF9488D0DED1A0000498BD8E83916000085C07518488B442458C700FCFFFFFF33C0488B5C24304883C4205FC3488B13488D0DD71A0000E80E16000085C0750D488B442458C7007CFCFFFFEBD3488B13488D0DCF1A0000E8EE15000085C0750D488B442458C7007BFCFFFFEBB3488B13488D0DC71A0000E8CE15000085C0750D488B442458C7007AFCFFFFEB93488B13488D0DBF1A0000E8AE15000085C07510488B442458C70079FCFFFFE970FFFFFF488B13488D0DB41A0000E88B15000085C07510488B442458C70078FCFFFFE94DFFFFFF488B13488D0DB11A0000E86815000085C07510488B442458C70077FCFFFFE92AFFFFFF488B13488BCFE889080000488B4C2458890183F8FF0F850FFFFFFFB806000280E907FFFFFFCCCCCC48895C240848896C241048897424185741544155415641574883EC40440FB784249000000041B9080000004C8BE1458D71F9450FB7D0458D69FA664523D60F85ED0000004584C50F85E400000041F6C00475094584C10F846502000081FA7CFCFFFF0F8585000000488B9C249800000044396B100F85CF070000488B430833ED8338FD488BC58BF5400F94C63BF50F95C04C8D2440488B034A8D0CE00FB70183F813741B8D7D033BC7741483F81A7421"
	$bBinary &= "83F815741C83F8147417E9AF00000041B9150000004533C0488BD1FF1537180000488B0B3BF5400F94C5488D446D00488D14C14A8B4CE108E9AC00000081FA7AFCFFFF751F33ED39690C0F84490700004883C158488B942498000000488B12E98500000081FA79FCFFFF0F85A101000033ED39690C0F841E0700004883C170EBD381FA7CFCFFFF756D488B9C2498000000443973100F85FE060000488B0B0FB70183F8137422BF030000003BC7741983F81A742683F815742183F814741CB805000280E9D606000041B9150000004533C0488BD1FF157E170000488B13488B5208488B8C24A0000000FF159117000033C0E9A806000081FA7BFCFFFF751133ED39690C0F8490060000488D5140EBD281FA7AFCFFFF7506488D5158EBC481FA78FCFFFF751433ED39690C0F8469060000488D9188000000EBA881FA77FCFFFF753833ED39690C0F844D060000488B9C24A0000000488BCBFF152B170000448D4D086644890B498B4C2438FF152017000048894308E976FFFFFF83FAFC0F858F00000033ED483969200F840B0600004C8BB424A0000000498BCEFF15E9160000448D5D0D8D4D486645891EE8F91200004C8BE8483BC57444498B742430498B7C2428498B5C2420488D050317000041896D084D89651049894500498B1424498BCCFF5208498D4D3049895D1849897D2049897528FF157F160000EB034C8BED4D89" & _
			"6E08498B4500498BCDFF5008E9DEFEFFFF33ED3BD50F8C7E0500008B41184103C63BD00F8D70050000498B4424108BCA488B34C866443BD50F85910200004584C50F858802000041F6C00475094584C10F8443050000396E24740B41396C240C0F84330500008B4E20412BCE0F8489010000413BCE0F851E050000488B9C249800000044396B100F8585000000B80C200000663946080F8549010000488B4E10FF15BA150000413BC60F8536010000488B4308448BE5BF030000008338FD488BC5410F94C4443BE50F95C04C8D2C40488B034A8D0CE8663B39740F448BCF4533C0488BD1FF156E150000488B0B488BC5443BE50F94C04A8D54E908488D04404C8D04C1488B4E10FF1533150000E97F020000BF03000000397B100F85C5000000B80C200000663946080F85B6000000488B4E10FF1527150000413BC50F85A3000000488B4308448BE58338FD410F94C4418BC4F7D8488B03481BC94923CD488D0C49488D0CC8663B39740F448BCF4533C0488BD1FF15DE140000488B0B4883C118663B39740F448BCF4533C0488BD1FF15C3140000488B13443BE5488BC50F95C0488D04408B4CC208418BC4F7D8894C2420481BC948F7D94903CE41F7DC488D04498B4CC208481BC048F7D0894C24244923C5488D04404C8D04C2488D542420E91EFFFFFF443973100F8559020000488B13488D4E08E9EEFCFFFF450174240C" & _
			"488B06498D5C2440488BCB4989442438FF1572140000498D4C2470FF15671400004C8BBC24980000004C8D442428458B6F10B90C000000418BD6418D4502896C242C89442428FF151C140000488D542430488BC84C8BF0FF15131400003BC5754D443BED7E3F418D4DFFBB30000000498BED4863D1488D3C5248C1E703498B07488B4C2430488D14074803CBFF15EE1300004883EF184883C3184883ED0175DD498D5C2440498BCEFF15EA130000B80C200000668903418B9C249000000041C784249000000001000000E9650200008B4E20412BCE0F8480010000413BCE0F85B502000044396E24750B41396C240C0F84A4020000488B9C2498000000443973100F859A000000B80C200000663946080F852D010000488B4E10FF1540130000413BC60F851A010000488B0BBF03000000663B39740F448BCF4533C0488BD1FF1513130000488B134883C208833AFF752E488B9C24A0000000488BCBFF1526130000418BD666893B488B4E104C8D4308FF15D212000044017308E970FBFFFF4C8B8424A0000000488B4E10FF15BF1200002BE8F7DD1BC02509000280E9FD01000044396B100F8598000000B80C200000663946080F8589000000488B4E10FF159C120000413BC5757A488B0BBF03000000663B39740F448BCF4533C0488BD1FF1573120000488B0B4883C118663B39740F448BCF4533C0488BD1FF1558120000"
	$bBinary &= "488B0B8B4108894424208B41208944242483F8FF7523488B9C24A0000000488BCBFF156112000044396C2420400F95C5418D142EE92CFFFFFF488D542420E93CFFFFFF396B10740AB80E000280E94C010000488D5608E986FAFFFF396E24740B41396C240C0F842E010000450174240C488B06498D5C2440488BCB4989442438FF1502120000498D4C2470FF15F71100004C8BBC24980000004C8D442428458B6F10B90C000000418BD6418D4502896C242C89442428FF15AC110000488D542430488BC84C8BF0FF15A31100003BC5754B443BED7E3D418D4DFFBB300000004863D1488D3C5248C1E703498B07488D1407488B442430488D0C03FF15801100004883EF184883C3184983ED0175DC498D5C2440498BCEFF157C110000B80C200000668903418B9C24900000004189AC24900000004D89742448BF03000000498BD4664189BC2488000000488B4E10FF15B4200000488B8C24A0000000498D5424708BF841899C2490000000FF150F110000498D4C2440FF150C110000498D4C2470FF150111000041FF4C240CF7DF1BC0F7D02503000280EB05B8030002804C8D5C2440498B5B30498B6B38498B7340498BE3415F415E415D415C5FC348895C240848896C24104889742418574883EC3033DB488BEA488BF1395918763B488BFB488B4610834C2428FF4183C9FF488B0C07418D510248896C24204C8B01B90008" & _
			"0000FF150010000083F8027423FFC34883C7083B5E1872C883C8FF488B5C2440488B6C2448488B7424504883C4305FC38BC3EBE748895C240848896C24104889742418574883EC20488BEA488B12488BD9E866FFFFFF4983C8FF413BC0744E488B7D00488D35B6100000418D480366F3A7743A8BF0488B4310488B3CF033C0483BF8741F4839077408488B0FE83B0C0000488D4F08FF15ED0F0000488BCFE8290C0000488B431048892CF0EB698B4B188D41013B431C76538D4C0902B80800000048F7E1490F40C0488BC8E8D80B0000488BF033C0394318761A488BF8488B4B10FFC0488B140F488914374883C7083B431872E9488B4B10E8CF0B00008B4B18488973108D44090289431C488B431048892CC8FF4318488B5C2430488B6C2438488B7424404883C4205FC3CC48895C240848896C241048897424185741544155415641574883EC20488BF1488B49204533F6498BD94D8BE0488BEA493BCE7405E8670B000033C04983CFFF488BFD448D6802498BCF66F2AF498BC548F7D148F7E1490F40C7488BC8E81B0B0000488946200FB74D004903ED6689084903C566413BCE75ED488B4E28493BCE7405E81A0B000033C0498BCF498BFC66F2AF498BC548F7D148F7E1490F40C7488BC8E8D60A000048894628410FB70C244D03E56689084903C566413BCE75EC488B4E30493BCE7405E8D40A000033C0498BCF488BFB" & _
			"66F2AF498BC548F7D148F7E1490F40C7488BC8E8900A0000488946300FB70B4903DD6689084903C566413BCE75EE488B5C2450488B6C2458488B7424604883C420415F415E415D415C5FC3CC48895C240848896C24104889742418574883EC20488BF1488B490833ED488BDA483BCD7405E8560A00004983C8FF33C0488BFB498BC866F2AF418D400348F7D148F7E1490F40C0488BC8E80D0A0000488946080FB70B4883C3026689084883C002663BCD75ED488B5C2430488B6C2438488B7424404883C4205FC3CC48895C241848894C240855565741544155415641574883EC2033DB488D05360F0000488BE9488901488D411089590889590C4883C1284D8BE8488BFA488944246848891889580889580CFF15600D0000488D4D40FF15560D000048897D204883C9FF33C0498BFD4C8BF366F2AF448BFB8D730148F7D1498BDD498BED448BE133C966833B7C750C8BC666890B4D8D744500EB6566833B0A740566390B755A66890BB918000000E835090000488BF833C0483BF8740D834F10FF48890748894708EB03488BF8488BD5488BCFE868ECFFFF498BD6488BCFE8A9FEFFFF488B4C2468488BD744897F10E81C0400008BC641FFC733C9498D6C4500FFC64883C3024983EC010F8579FFFFFF488B442460488B5C24704883C420415F415E415D415C5F5E5DC3CCCC48895C240848896C24104889742418574883EC20"
	$bBinary &= "834108FF488BD90F8583000000488D050C0E000033FF488901397918763D33ED488B4310488B34284885F67423488B0E4885C97405E892080000488B4E084885C97405E884080000488BCEE87C080000FFC74883C5083B7B1872C5488B4B10E86808000048836310008363180083631C00488B4B20488B01FF5010488B4B10E848080000488BCBE84008000033C0EB038B4108488B5C2430488B6C2438488B7424404883C4205FC3B801400080C3CCCC48895C2408574883EC20498B10488BF9488D0D490D0000498BD8E8AD07000085C07518488B442458C700DCFCFFFF33C0488B5C24304883C4205FC3488B13488D0D630C0000E88207000085C0750D488B442458C7007BFCFFFFEBD3488B13488D0D730C0000E86207000085C0750D488B442458C70079FCFFFFEBB3488B13488BCFE886FAFFFF488B4C2458890183F8FF759CB806000280EB97CCCCCC48895C240848896C241048897424185741544155415641574883EC500FB7BC24A0000000BD04000000488BD9448D7DFD440FB7C7664523C7753540F6C702752F4084FD750640F6C708747D81FA79FCFFFF757533F639710C0F8403020000488B9424A80000004883C140488B12EB5181FADCFCFFFF752A488BBC24B0000000488BCFFF15B40A000041BB150000006644891F488B43204889470833C0E9C501000081FA7BFCFFFF751F33F639710C0F84AD010000" & _
			"488D5128488B8C24B0000000FF156E0A0000EBD233F63BD60F8C8F0100003B51180F8D86010000488B43108BCA4C8B24C866443BC6750A40F6C7020F846C010000488B4320488D4B28488B004889442440FF15310A0000488D4B40FF15270A0000498B7C24084C8BB424A8000000458B6E1033C04883C9FF8974243466F2AF8BFE48F7D1418D45014C8D442430493BCFB90C000000418BD7400F95C74103FF89BC24A00000000FAFC783C00389442430FF15B2090000488D542438488BC84C8BF8FF15A90900003BC67574443BEE7E6683FF02B806000000480F44E848638424A00000004C8D3440418D45FF488D7C6D004863C8498BED4C8BAC24A8000000488D344948C1E70349C1E60348C1E603498B4500488D1406488B442438488D0C07FF155A0900004883EE184903FE4883ED0175DC4D8BF5498BCFFF1559090000FF430C488BBC24B0000000488B53204C897B30B80C20000048897C242866894328418B4610418B4C24104D8B44240889442420488B442440488B0CC84C8BCBFF158C180000488D5340488BCFFF15EF080000FF4B0C488D4B28FF15EA080000488D4B40FF15E0080000E939FEFFFFB8030002804C8D5C2450498B5B30498B6B38498B7340498BE3415F415E415D415C5FC348895C24084889742410574883EC20488BD98B4908488BF28D41013B430C765C448D44090248C7C1FFFFFFFFB8080000" & _
			"0049F7E0480F40C1488BC8E8980400004533C9488BF844394B08761B4D8BC1488B0B41FFC1498B1408498914004983C008443B4B0872E8488B0BE88D0400008B4B0848893B8D44090289430C488B03488934C8FF4308488B5C2430488B7424384883C4205FC3CCCCB801000000C3CCCC4883EC28B9A0000000E82A040000488BC833C0483BC87405E89FE9FFFF4883C428C3CCCC40534883EC20488BD9B9A0000000E801040000488BC833C0483BC87408488BD3E83BEAFFFF4883C4205BC3CC48890D4117000048891532170000C3CC48895C240848896C2410488974241857415441554883EC204C8BE1B928000000418BF9498BE8488BF2E8AA0300004533ED488BD8493BC57413488D48084C892844896820FF155E070000EB03498BDD488BD6488BCBC7432001000000897B24E8CCE6FFFF6644396B08740A488D4B08FF1543070000B808000000488BCD66894308FF1539070000488BD3498BCC48894310488B5C2440488B6C2448488B7424504883C420415D415C5FE9B6F6FFFFCCCC48895C240848896C24104889742418574883EC20488BD9E820F6FFFF83F8FF8BF07E43488B5310488B3CF24885FF741F488B0F4885C97405E80F030000488D4F08FF15C1060000488BCFE8FD020000FF4B183B7318730F488B53108B4318488B0CC248890CF2488B5C2430488B6C2438488B7424404883C4205FC3CCE92BF7FF"
	$bBinary &= "FFCCCCCC488BC44889580848896810488970184889782041544883EC204C8BE1B928000000498BF9418BF0488BEAE875020000488BD84885C074144883200083602000488D4808FF152B060000EB0233DBC74320020000004885FF740D488D4B08488BD7FF1516060000488BD5488BCB897324E888E5FFFF488BD3498BCC488B5C2430488B6C2438488B742440488B7C24484883C420415CE997F5FFFFCCCCCC48890D69150000C348895C2408574883EC20488BF9B958000000E8E901000033C9488BD8483BC17434894B08894B0C488D054A07000048890348894B10894B18894B1C488D4B2848897B20FF1587050000488D4B40FF157D050000EB03488BD9488BC3488B5C24304883C4205FC3CCCC48895C2408574883EC20488BF9B958000000488BDAE87E010000488BC833C0483BC8740B4C8BC3488BD7E889F7FFFF488B5C24304883C4205FC3CCCC488BC44889580848896810488970184889782041544883EC20488BF1B918000000418BF9498BE84C8BE2E82D010000488BD84885C0740F488320004883600800834810FFEB0233DB498BD4488BCBE861E4FFFF488BD5488BCB897B10E89FF6FFFF488B13488BCEE804F4FFFF83F8FF750E488D4E10488BD3E807FCFFFFEB3A8BE8488B4610488B3CE84885FF7423488B0F4885C97405E8E5000000488B4F084885C97405E8D7000000488BCFE8CF000000488B46" & _
			"1048891CE8488B5C2430488B6C2438488B742440488B7C24484883C420415CC381F9ADDE0000754A534883EC3081FAEFBE00007538B9F5FFFFFFFF15D80300004883642420004C8D4C2440488D1506060000488BC841B822000000488BD8FF159C030000488BCBFF15A30300004883C4305BC3CC488B0148FF6008CC4883EC384183C9FF4C8BC1B90008000044894C2428488954242033D2FF156A03000083E8024883C438C3CCCC40534883EC20488BD9FF15690300004C8BC3488BC833D24883C4205B48FF2565030000CC40534883EC20488BD9FF15450300004C8BC3488BC833D24883C4205B48FF2539030000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"00350000000000000C350000000000001E35000000000000323500000000000076350000000000006A350000000000005E3500000000000000000000000000001A00000000000080130000000000008019000000000000800C0000000000008011000000000000800F00000000000080170000000000008008000000000000800A00000000000080090000000000008002000000000000801800000000000080000000000000000000000000000000000000000068D9D94B00000000020000005B0000007C3200007C24000000000000C4100080010000002C140080010000007C100080010000009811008001000000CC11008001000000FC11008001000000A8240080010000005F005F00640065006600610075006C0074005F005F0000007E000000000000005F004E006500770045006E0075006D0000000000000000005F005F006200720069006400670065005F005F00000000005F005F0070006100720061006D0073005F005F00000000005F005F006500720072006F0072005F005F000000000000005F005F0072006500730075006C0074005F005F00000000005F005F00700072006F007000630061006C006C005F005F0000000000000000005F005F006E0061006D0065005F005F0000000000000000001C160080010000002C140080010000003414008001000000A824008001000000A824008001000000"
	$bBinary &= "241600800100000050170080010000005F005F007000740072005F005F0000001C160080010000002C14008001000000EC23008001000000A824008001000000A824008001000000B0240080010000004C250080010000004C6F6C2E20596F7520666F756E6420746865206561737465722D6567672E200D0A00000052534453C3FB1BF8ADF0FE40A329A5C95CC5E3A901000000633A5C55736572735C7472616E636578785C4465736B746F705C4175746F49744F626A656374325C7472756E6B5C4175746F49744F626A6563745F5836342E70646200000104010004620000010D02000D520930010F06000F6407000F3406000F320B70011C0C001C640C001C540B001C340A001C3218F016E014D012C010700106020006520230011C0C001C6412001C5411001C3410001C9218F016E014D012C010700114080014640A00145409001434080014521070011C0C001C6410001C540F001C340E001C7218F016E014D012C01070010A04000A3406000A320670010602000632023001190A0019340E00193215F013E011D00FC00D700C600B50011408001464080014540700143406001432107001160A0016540C0016340B00163212E010D00EC00C700B60011D0C001D740B001D640A001D5409001D3408001D3219E017D015C0010701000782000001190A0019740900196408001954070019340600193215C001180A00" & _
			"18640A001854090018340800183214D012C01070010401000442000058340000000000000000000042350000003000009834000000000000000000005035000040300000000000000000000000000000000000000000000000350000000000000C350000000000001E35000000000000323500000000000076350000000000006A350000000000005E3500000000000000000000000000001A00000000000080130000000000008019000000000000800C0000000000008011000000000000800F00000000000080170000000000008008000000000000800A0000000000008009000000000000800200000000000080180000000000008000000000000000009104577269746546696C65005500436F6D70617265537472696E675700004201466C75736846696C654275666665727300003B0247657453746448616E646C6500004B45524E454C33322E646C6C00004F4C4541555433322E646C6C00009D0248656170416C6C6F6300A10248656170467265650000230247657450726F6365737348656170000000000000000000000000000067D9D94B000000003A360000010000000D0000000D000000B8350000EC35000020360000FC290000D0280000042A00009428000070280000A82A0000102B0000742C0000C0280000A02A0000202C0000802900004C2B00004F36000057360000613600006D3600007F360000" & _
			"92360000A6360000BC360000CB360000D6360000E8360000F83600000537000000000100020003000400050006000700080009000A000B000C004175746F49744F626A6563745F5836342E646C6C00416464456E756D004164644D6574686F640041646450726F706572747900436C6F6E654175746F49744F626A656374004372656174654175746F49744F626A65637400437265617465577261707065724F626A65637400437265617465577261707065724F626A65637445780049556E6B6E6F776E41646452656600496E697469616C697A6500496E697469616C697A6557726170706572004D656D6F727943616C6C456E7472790052656D6F76654D656D62657200577261707065724164644D6574686F6400000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	$bBinary &= "0010000079100000943300007C100000C310000074330000C410000098110000DC33000098110000CB11000014330000CC110000FB11000014330000FC1100002B120000143300002C120000F1120000E8320000F412000029140000C03300003414000030150000A8330000301500001916000094330000241600004D1700006833000050170000BC1F00004C330000BC1F00003420000038330000342000002B210000943300002C2100004B220000F83200004C220000C722000094330000C8220000EA2300007C330000EC230000A824000094330000B024000049250000683300004C250000D02700001C330000D027000066280000E832000070280000922800001434000094280000BF28000074330000D02800007E290000FC33000080290000FB29000094330000042A00009D2A0000E4330000A82A00000E2B000068330000102B00004A2B0000683300004C2B0000202C0000E4330000202C0000732C0000E03200007C2C0000A62C0000D8320000A82C0000CB2C000074330000CC2C0000EF2C0000743300000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000" & _
			"000000000000000000000000000001001000000018000080000000000000000000000000000001000100000030000080000000000000000000000000000001000904000048000000606000002003000000000000000000000000000000000000200334000000560053005F00560045005200530049004F004E005F0049004E0046004F0000000000BD04EFFE0000010001000100000000000100010000000000000000000000000004000000020000000000000000000000000000007E020000010053007400720069006E006700460069006C00650049006E0066006F0000005A0200000100300034003000390030003400420030000000300008000100460069006C006500560065007200730069006F006E000000000031002E0031002E0030002E0030000000340008000100500072006F006400750063007400560065007200730069006F006E00000031002E0031002E0030002E00300000007A0029000100460069006C0065004400650073006300720069007000740069006F006E0000000000500072006F007600690064006500730020006F0062006A006500630074002000660075006E006300740069006F006E0061006C00690074007900200066006F00720020004100750074006F0049007400000000003A000D000100500072006F0064007500630074004E0061006D006500000000004100750074006F00" & _
			"490074004F0062006A00650063007400000000005E001D0001004C006500670061006C0043006F0070007900720069006700680074000000280043002900200062007900200054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000004A00110001004F0072006900670069006E0061006C00460069006C0065006E0061006D00650000004100750074006F00490074004F0062006A006500630074002E0064006C006C00000000007A002300010054006800650020004100750074006F00490074004F0062006A006500630074002D005400650061006D00000000006D006F006E006F00630065007200650073002C0020007400720061006E0063006500780078002C0020004B00690070002C002000500072006F00670041006E006400790000000000440000000100560061007200460069006C00650049006E0066006F00000000002400040000005400720061006E0073006C006100740069006F006E00000000000904B0040000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	$bBinary &= "0030000034000000D0A0D8A0E0A0E8A0F0A0F8A000A1D8A1E0A1E8A1F0A1F8A100A208A220A228A230A238A240A248A250A2000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"
	Return Binary($bBinary)
EndFunc   ;==>__Au3Obj_Mem_BinDll_X64

#endregion Embedded DLL
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region COM Wrapper

Func __Au3Obj_Object_Create($oSelf, $oParent = 0)
	#forceref $oSelf
	Local $oObject = _AutoItObject_Create($oParent)
	$oSelf.Object = $oObject
	Return $oObject
EndFunc   ;==>__Au3Obj_Object_Create

Func __Au3Obj_Object_AddMethod($oSelf, $sName, $sAutoItFunc, $fPrivate = False)
	Local $oObject = $oSelf.Object
	_AutoItObject_AddMethod($oObject, $sName, $sAutoItFunc, $fPrivate)
EndFunc   ;==>__Au3Obj_Object_AddMethod

Func __Au3Obj_Object_AddProperty($oSelf, $sProperty, $iFlags = 0, $vData = "")
	Local $oObject = $oSelf.Object
	_AutoItObject_AddProperty($oObject, $sProperty, $iFlags, $vData)
EndFunc   ;==>__Au3Obj_Object_AddProperty

Func __Au3Obj_Object_AddDestructor($oSelf, $sAutoItFunc)
	Local $oObject = $oSelf.Object
	_AutoItObject_AddDestructor($oObject, $sAutoItFunc)
EndFunc   ;==>__Au3Obj_Object_AddDestructor

Func __Au3Obj_Object_AddEnum($oSelf, $sNextFunc, $sResetFunc, $sSkipFunc = '')
	Local $oObject = $oSelf.Object
	_AutoItObject_AddEnum($oObject, $sNextFunc, $sResetFunc, $sSkipFunc)
EndFunc   ;==>__Au3Obj_Object_AddEnum

Func __Au3Obj_Object_RemoveMember($oSelf, $sMember)
	Local $oObject = $oSelf.Object
	_AutoItObject_RemoveMember($oObject, $sMember)
EndFunc   ;==>__Au3Obj_Object_RemoveMember

#endregion COM Wrapper
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region DllStructCreate Wrapper

Func __Au3Obj_ObjStructMethod($oSelf, $vParam1 = 0, $vParam2 = 0)
	Local $sMethod = $oSelf.__name__
	Local $tStructure = DllStructCreate($oSelf.__tag__, $oSelf())
	Local $vOut
	Switch @NumParams
		Case 1
			$vOut = DllStructGetData($tStructure, $sMethod)
		Case 2
			If $oSelf.__propcall__ Then
				$vOut = DllStructSetData($tStructure, $sMethod, $vParam1)
			Else
				$vOut = DllStructGetData($tStructure, $sMethod, $vParam1)
			EndIf
		Case 3
			$vOut = DllStructSetData($tStructure, $sMethod, $vParam2, $vParam1)
	EndSwitch
	If IsPtr($vOut) Then $vOut = Number($vOut)
	Return $vOut
EndFunc   ;==>__Au3Obj_ObjStructMethod

Func __Au3Obj_ObjStructDestructor($oSelf)
	If $oSelf.__new__ Then __Au3Obj_GlobalFree($oSelf())
EndFunc   ;==>__Au3Obj_ObjStructDestructor

#endregion DllStructCreate Wrapper
;--------------------------------------------------------------------------------------------------------------------------------------


;--------------------------------------------------------------------------------------------------------------------------------------
#region Public UDFs

Global Enum $ELTYPE_NOTHING, $ELTYPE_METHOD, $ELTYPE_PROPERTY
Global Enum $ELSCOPE_PUBLIC, $ELSCOPE_READONLY, $ELSCOPE_PRIVATE

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Startup
; Description ...: Initializes AutoItObject
; Syntax.........: _AutoItObject_Startup( [$fLoadDLL = False [, $sDll = "AutoitObject.dll"]] )
; Parameters ....: $fLoadDLL    - [optional] specifies whether an external DLL-file should be used (default: False)
;                  $sDLL        - [optional] the path to the external DLL (default: AutoitObject.dll or AutoitObject_X64.dll)
; Return values .: Success      - True
;                  Failure      - False
; Author ........: trancexx, Prog@ndy
; Modified.......:
; Remarks .......: automatically switches between 32bit and 64bit mode if no special DLL is specified
; Related .......: _AutoItObject_Shutdown
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_Startup($fLoadDLL = False, $sDll = "AutoitObject.dll")
	Local $__Au3Obj_FunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_FunctionProxy", "int", "wstr;idispatch"))
	Local $__Au3Obj_EnumFunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_EnumFunctionProxy", "int", "dword;wstr;idispatch;ptr;ptr"))
	Local $__Au3Obj_WrapFunctionProxy = DllCallbackGetPtr(DllCallbackRegister("__Au3Obj_WrapFunctionProxy", "int", "ptr;ptr;wstr;idispatch;dword;ptr"))
	If $ghAutoItObjectDLL = -1 Then
		If $fLoadDLL Then
			If $__Au3Obj_X64 And @NumParams = 1 Then $sDll = "AutoItObject_X64.dll"
			$ghAutoItObjectDLL = DllOpen($sDll)
		Else
			$ghAutoItObjectDLL = __Au3Obj_Mem_DllOpen()
		EndIf
		If $ghAutoItObjectDLL = -1 Then Return SetError(1, 0, False)
	EndIf
	If $giAutoItObjectDLLRef <= 0 Then
		$giAutoItObjectDLLRef = 0
		DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", $__Au3Obj_FunctionProxy, "ptr", $__Au3Obj_EnumFunctionProxy)
		If @error Then
			DllClose($ghAutoItObjectDLL)
			$ghAutoItObjectDLL = -1
			Return SetError(2, 0, False)
		EndIf
		DllCall($ghAutoItObjectDLL, "ptr", "InitializeWrapper", "ptr", $__Au3Obj_WrapFunctionProxy)
		If @error Then
			DllClose($ghAutoItObjectDLL)
			$ghAutoItObjectDLL = -1
			Return SetError(3, 0, False)
		EndIf
	EndIf
	$giAutoItObjectDLLRef += 1
	Return True
EndFunc   ;==>_AutoItObject_Startup

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Shutdown
; Description ...: frees the AutoItObject DLL
; Syntax.........: _AutoItObject_Shutdown()
; Parameters ....: $fFinal    - [optional] Force shutdown of the library? (Default: False)
; Return values .: Remaining reference count (one for each call to _AutoItObject_Startup)
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_Shutdown($fFinal = False)
	; Author: Prog@ndy
	If $giAutoItObjectDLLRef <= 0 Then Return 0
	$giAutoItObjectDLLRef -= 1
	If $fFinal Then $giAutoItObjectDLLRef = 0
	If $giAutoItObjectDLLRef = 0 Then DllCall($ghAutoItObjectDLL, "ptr", "Initialize", "ptr", 0, "ptr", 0)
	Return $giAutoItObjectDLLRef
EndFunc   ;==>_AutoItObject_Shutdown

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_WrapperCreate
; Description ...: Creates an IDispatch-Object for COM-Interfaces normally not supportting it.
; Syntax.........: _AutoItObject_WrapperCreate($pUnknown, ByRef $tagInterface)
; Parameters ....: $pUnknown     - Pointer to an IUnknown-Interface not supporting IDispatch
;                  $tagInterface - String defining the methods of the Interface, see Remarks for details
; Return values .: Success      - Dispatch-Object
;                  Failure      - 0, @error set to 1
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: $tagInterface can be a string in the following format:
;                  "FunctionName ReturnType(ParamType1;ParamType2);FunctionName2 ..."
;                  -FunctionName is the name of the function you want to call later
;                  -ReturnType is the return type (like DLLCall)
;                  -ParamType is the type of the parameter (like DLLCall) [do not include the THIS-param]
;+
;                  alternative Format:
;                  "FunctionName;FunctionName2;..."
;                  This results in an other format for calling the functions later. You must specify the datatypes in the call then
;                  $oObject.function("returntype", "firstparamtype", $firstparam, "2ndtype", $2ndparam, ...)
;+
;                  The reuturn value of a call is always an array (except an error occured, then it is 0):
;                  $array[0] - containts the return value
;                  $array[1] - containts the pointer to the original object
;                  $array[n] - containts the n-1 parameter
; Related .......: _AutoItObject_WrapperAddMethod
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_WrapperCreate($pUnknown, ByRef $tagInterface)
	Local $sMethods = __Au3Obj_GetMethods($tagInterface)
	Local $aResult
	If $sMethods Then
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObjectEx", 'ptr', $pUnknown, 'wstr', $sMethods)
	Else
		$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateWrapperObject", 'ptr', $pUnknown)
	EndIf
	If @error Then Return SetError(1, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_WrapperCreate

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_WrapperAddMethod
; Description ...: Adds additional methods to the Wrapper-Object, e.g if you want alternative parameter types
; Syntax.........: _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
; Parameters ....: $oWrapper     - The Object you want to modify
;                  $sReturnType  - the return type of the function
;                  $sName        - The name of the function
;                  $sParamTypes  - the parameter types
;                  $ivTableIndex - Index of the function in the object's vTable
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_WrapperCreate
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_WrapperAddMethod(ByRef $oWrapper, $sReturnType, $sName, $sParamTypes, $ivtableIndex)
	; Author: Prog@ndy
	If Not IsObj($oWrapper) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "WrapperAddMethod", 'idispatch', $oWrapper, 'wstr', $sName, "wstr", StringRegExpReplace($sReturnType & ';' & $sParamTypes, "\s|(;+\Z)", ''), 'dword', $ivtableIndex)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_WrapperAddMethod

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Class
; Description ...: AutoItObject COM wrapper function
; Syntax.........: _AutoItObject_Class()
; Parameters ....:
; Return values .: Success      - object AutoItObject with defined;
;                  |methods:
;                  |	Create([$oParent = 0]) - creates object
;                  |	AddMethod($sName, $sAutoItFunc [, $fPrivate = False]) - adds new method
;                  |	AddProperty($sName, $iFlags = $ELSCOPE_PUBLIC, $vData = 0) - adds new property
;                  |	AddDestructor($sAutoItFunc) - adds destructor
;                  |	AddEnum($sNextFunc, $sResetFunc [, $sSkipFunc = '']) - adds enum
;                  |	RemoveMember($sMember) - removes member
;                  |properties:
;                  |	Object - readonly property representing the last created object
; Author ........: trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_Class()
	Local $oObj = _AutoItObject_Create()
	_AutoItObject_AddMethod($oObj, "Create", "__Au3Obj_Object_Create")
	_AutoItObject_AddMethod($oObj, "AddMethod", "__Au3Obj_Object_AddMethod")
	_AutoItObject_AddMethod($oObj, "AddProperty", "__Au3Obj_Object_AddProperty")
	_AutoItObject_AddMethod($oObj, "AddDestructor", "__Au3Obj_Object_AddDestructor")
	_AutoItObject_AddMethod($oObj, "AddEnum", "__Au3Obj_Object_AddEnum")
	_AutoItObject_AddMethod($oObj, "RemoveMember", "__Au3Obj_Object_RemoveMember")
	_AutoItObject_AddProperty($oObj, "Object", $ELSCOPE_READONLY)
	Return $oObj
EndFunc   ;==>_AutoItObject_Class

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_Create
; Description ...: Creates an AutoIt-object
; Syntax.........: _AutoItObject_Create( [$oParent = 0] )
; Parameters ....: $oParent     - [optional] an AutoItObject whose methods & properties are copied. (default: 0)
; Return values .: Success      - AutoIt-Object
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_Create($oParent = 0)
	; Author: Prog@ndy
	Local $aResult
	Switch IsObj($oParent)
		Case True
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CloneAutoItObject", 'idispatch', $oParent)
		Case Else
			$aResult = DllCall($ghAutoItObjectDLL, "idispatch", "CreateAutoItObject")
	EndSwitch
	If @error Then Return SetError(1, @error, 0)
	Return $aResult[0]
EndFunc   ;==>_AutoItObject_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddMethod
; Description ...: Adds a method to an AutoIt-object
; Syntax.........: _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc [, $fPrivate = False])
; Parameters ....: $oObject     - the object to modify
;                  $sName       - the name of the method to add
;                  $sAutoItFunc - the AutoIt-function wich represents this method.
;                  $fPrivate    - [optional] Specifies whether the function can only be called from within the object. (default: False)
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: The first parameter of the AutoIt-function is always a reference to the object. ($oSelf)
;                  This parameter will automatically be added and must not be given in the call.
;                  The function called '__default__' is accesible without a name using brackets ($return = $oObject())
; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_AddMethod(ByRef $oObject, $sName, $sAutoItFunc, $fPrivate = False)
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $iFlags = 0
	If $fPrivate Then $iFlags = $ELSCOPE_PRIVATE
	DllCall($ghAutoItObjectDLL, "none", "AddMethod", "idispatch", $oObject, "wstr", $sName, "wstr", $sAutoItFunc, 'dword', $iFlags)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddMethod


; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddProperty
; Description ...: Adds a property to an AutoIt-object
; Syntax.........: _AutoItObject_AddProperty(ByRef $oObject, $sName, $iFlags = $ELSCOPE_PUBLIC, $vData = 0)
; Parameters ....: $oObject     - the object to modify
;                  $sName       - the name of the property to add
;                  $iFlags      - Specifies the access to the property. This parameter can be one of the following values:
;                  |$ELSCOPE_PUBLIC   - The Property has public access.
;                  |$ELSCOPE_READONLY - The property is read-only and can only be changed from within the object.
;                  |$ELSCOPE_PRIVATE  - The property is private and can only be accessed from within the object.
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......: The property called '__default__' is accesible without a name using brackets ($value = $oObject())
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddEnum, _AutoItObject_RemoveMember
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_AddProperty(ByRef $oObject, $sName, $iFlags = $ELSCOPE_PUBLIC, $vData = 0)
	; Author: Prog@ndy
	Local $tStruct = DllStructCreate($__Au3Obj_tagVARIANT)
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	Local $pData = 0
	If @NumParams = 4 Then
		$pData = DllStructGetPtr($tStruct)
		__Au3Obj_VariantInit($pData)
		$oObject.__bridge__(Number($pData)) = $vData
	EndIf
	DllCall($ghAutoItObjectDLL, "none", "AddProperty", "idispatch", $oObject, "wstr", $sName, 'dword', $iFlags, 'ptr', $pData)
	Local $error = @error
	If $pData Then _AutoItObject_VariantClear($pData)
	If $error Then Return SetError(1, $error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddProperty

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddDestructor
; Description ...: Adds a destructor to an AutoIt-object
; Syntax.........: _AutoItObject_AddDestructor(ByRef $oObject,$sAutoItFunc)
; Parameters ....: $oObject     - the object to modify
;                  $sAutoItFunc - the AutoIt-function wich represents this destructor.
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: monoceres (Andreas Karlsson)
; Modified.......:
; Remarks .......: Adding a method that will be called on object destruction. Can be called multiple times.
; Related .......: _AutoItObject_AddProperty, _AutoItObject_AddEnum, _AutoItObject_RemoveMember, _AutoItObject_AddMethod
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_AddDestructor(ByRef $oObject, $sAutoItFunc)
	Return _AutoItObject_AddMethod($oObject, "~", $sAutoItFunc, True)
EndFunc   ;==>_AutoItObject_AddDestructor

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_AddEnum
; Description ...: Adds an Enum to an AutoIt-object
; Syntax.........: _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc [, $sSkipFunc = ''])
; Parameters ....: $oObject     - the object to modify
;                  $sNextFunc   - The function to be called to get the next entry
;                  $sResetFunc  - The function to be called to reset the enum
;                  $sSkipFunc   - [optional] The function to be called to skip elements (not supported by AutoIt)
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_RemoveMember
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_AddEnum(ByRef $oObject, $sNextFunc, $sResetFunc, $sSkipFunc = '')
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "AddEnum", "idispatch", $oObject, "wstr", $sNextFunc, "wstr", $sResetFunc, "wstr", $sSkipFunc)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_AddEnum

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_RemoveMember
; Description ...: Removes a property or a function from an AutoIt-object
; Syntax.........: _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
; Parameters ....: $oObject     - the object to modify
;                  $sMember     - the name of the member to remove
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......: _AutoItObject_AddMethod, _AutoItObject_AddProperty, _AutoItObject_AddEnum
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_RemoveMember(ByRef $oObject, $sMember)
	; Author: Prog@ndy
	If Not IsObj($oObject) Then Return SetError(2, 0, 0)
	If $sMember = '__default__' Then Return SetError(3, 0, 0)
	DllCall($ghAutoItObjectDLL, "none", "RemoveMember", "idispatch", $oObject, "wstr", $sMember)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_RemoveMember

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_IUnknownAddRef
; Description ...: Increments the refrence count of an IUnknown-Object
; Syntax.........: _AutoItObject_IUnknownAddRef(ByRef $pUnknown)
; Parameters ....: $pUnknown    - IUnkown-pointer
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_IUnknownAddRef(Const $pUnknown)
	; Author: Prog@ndy
	DllCall($ghAutoItObjectDLL, "none", "IUnknownAddRef", "ptr", $pUnknown)
	If @error Then Return SetError(1, @error, 0)
	Return True
EndFunc   ;==>_AutoItObject_IUnknownAddRef

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_CLSIDFromString
; Description ...: Converts a string to a CLSID-Struct (GUID-Struct)
; Syntax.........: _AutoItObject_CLSIDFromString($sString, ByRef $tCLSID)
; Parameters ....: $sString     - The string to convert
; Return values .: Success      - DLLStruct in format $tagGUID
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ CLSIDFromString
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_CLSIDFromString($sString)
	Local $tCLSID = DllStructCreate("dword;word;word;byte[8]")
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CLSIDFromString', 'wstr', $sString, 'ptr', DllStructGetPtr($tCLSID))
	If @error Then Return SetError(1, @error, 0)
	If $aResult[0] <> 0 Then Return SetError(2, $aResult[0], 0)
	Return $tCLSID
EndFunc   ;==>_AutoItObject_CLSIDFromString

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_CoCreateInstance
; Description ...: Creates a single uninitialized object of the class associated with a specified CLSID.
; Syntax.........: _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
; Parameters ....: $rclsid       - [in] The CLSID associated with the data and code that will be used to create the object.
;                  $pUnkOuter    - [in] If NULL, indicates that the object is not being created as part of an aggregate.
;                  +If non-NULL, pointer to the aggregate object's IUnknown interface (the controlling IUnknown).
;                  $dwClsContext - [in] Context in which the code that manages the newly created object will run.
;                  +The values are taken from the enumeration CLSCTX.
;                  $riid         - [in] A reference to the identifier of the interface to be used to communicate with the object.
;                  $ppv          - [out] Address of pointer variable that receives the interface pointer requested in riid.
;                  +Upon successful return, *ppv contains the requested interface pointer. Upon failure, *ppv contains NULL.
; Return values .: Success      - True
;                  Failure      - 0
; Author ........: Prog@ndy
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ CoCreateInstance
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_CoCreateInstance($rclsid, $pUnkOuter, $dwClsContext, $riid, ByRef $ppv)
	$ppv = 0
	Local $aResult = DllCall($gh_AU3Obj_ole32dll, 'long', 'CoCreateInstance', 'ptr', $rclsid, 'ptr', $pUnkOuter, 'dword', $dwClsContext, 'ptr', $riid, 'ptr*', 0)
	If @error Then Return SetError(1, @error, 0)
	$ppv = $aResult[5]
	Return SetError($aResult[0], 0, $aResult[0] = 0)
EndFunc   ;==>_AutoItObject_CoCreateInstance

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_PtrToIDispatch
; Description ...: Converts IDispatch pointer to AutoIt's object type
; Syntax.........: _AutoItObject_PtrToIDispatch($pIDispatch)
; Parameters ....: $pIDispatch  - IDispatch pointer
; Return values .: Success      - object type
;                  Failure      - 0
; Author ........: monoceres, trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ RtlMoveMemory
; Example .......;
; ===============================================================================================================================
Func _AutoItObject_PtrToIDispatch($pIDispatch)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "none", "RtlMoveMemory", "idispatch*", 0, "ptr*", $pIDispatch, "dword", $__Au3Obj_tagPTR_SIZE)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[1]
EndFunc   ;==>_AutoItObject_PtrToIDispatch

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_IDispatchToPtr
; Description ...: Returns pointer to AutoIt's object type
; Syntax.........: _AutoItObject_IDispatchToPtr(ByRef $oIDispatch)
; Parameters ....: $oIDispatch  - Object
; Return values .: Success      - Pointer to object
;                  Failure      - 0
; Author ........: monoceres, trancexx
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........; @@MsdnLink@@ RtlMoveMemory
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_IDispatchToPtr(ByRef $oIDispatch)
	Local $aCall = DllCall($gh_AU3Obj_kernel32dll, "none", "RtlMoveMemory", "ptr*", 0, "idispatch*", $oIDispatch, "dword", $__Au3Obj_tagPTR_SIZE)
	If @error Then Return SetError(1, 0, 0)
	Return $aCall[1]
EndFunc   ;==>_AutoItObject_IDispatchToPtr

; #FUNCTION# ====================================================================================================================
; Name...........: _AutoItObject_DllStructCreate
; Description ...: Object wrapper for DllStructCreate and related functions
; Syntax.........: _AutoItObject_DllStructCreate($sTag [, $vParam = 0])
; Parameters ....: $sTag     - A string representing the structure to create (same as with DllStructCreate)
;                  $vParam   - [optional] If this parameter is DLLStruct type then it will be copied to newly allocated space and maintained during lifetime of the object.
;                  + If this parameter is not suplied needed memory allocation is done but content is initialized to zero.
;                  + In all other cases function will not allocate memory but use parameter supplied as the pointer (same as DllStructCreate)
; Return values .: Success      - Object-structure
;                  Failure      - 0
;                  @error is set to error value of DllStructCreate() function.
; Author ........: trancexx
; Modified.......:
; Remarks .......: AutoIt can't handle pointers properly when passed to or returned from object methods. Use Number() function on pointers before using them with this function.
;                  Every element of structure must be named. Values are accessed through their names.
;                  Created object exposes:
;                  |- set of dynamic methods in names of elements of the structure
;                  |- readonly properties:
;                  |	__tag__ - a string representing the object-structure
;                  |	__size__ - the size of the struct in bytes
;                  |	__alignment__ - alignment string (e.g. "align 2")
;                  |	__count__ - number of elements of structure
;                  |	__elements__ - string made of element names separated by semicolon (";")
; Related .......:
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _AutoItObject_DllStructCreate($sTag, $vParam = 0)
	Local $oObj = _AutoItObject_Create()
	Local $fNew = False
	Local $tSubStructure = DllStructCreate($sTag)
	If @error Then Return SetError(@error, 0, 0)
	Local $iSize = DllStructGetSize($tSubStructure)
	Local $pPointer = $vParam
	Select
		Case @NumParams = 1
			$pPointer = __Au3Obj_GlobalAlloc($iSize, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
		Case IsDllStruct($vParam)
			$pPointer = __Au3Obj_GlobalAlloc($iSize, 64) ; GPTR
			If @error Then Return SetError(3, 0, 0)
			$fNew = True
			DllStructSetData(DllStructCreate("byte[" & $iSize & "]", $pPointer), 1, DllStructGetData(DllStructCreate("byte[" & $iSize & "]", DllStructGetPtr($vParam)), 1))
		Case @NumParams = 2 And $vParam = 0
			Return SetError(3, 0, 0)
	EndSelect
	Local $sAlignment
	Local $sNamesString = __Au3Obj_ObjStructGetElements($sTag, $sAlignment)
	Local $aElements = StringSplit($sNamesString, ";", 2)
	For $i = 0 To UBound($aElements) - 1
		_AutoItObject_AddMethod($oObj, $aElements[$i], "__Au3Obj_ObjStructMethod")
	Next
	_AutoItObject_AddProperty($oObj, "__tag__", $ELSCOPE_READONLY, $sTag)
	_AutoItObject_AddProperty($oObj, "__size__", $ELSCOPE_READONLY, $iSize)
	_AutoItObject_AddProperty($oObj, "__alignment__", $ELSCOPE_READONLY, $sAlignment)
	_AutoItObject_AddProperty($oObj, "__count__", $ELSCOPE_READONLY, UBound($aElements))
	_AutoItObject_AddProperty($oObj, "__elements__", $ELSCOPE_READONLY, $sNamesString)
	_AutoItObject_AddProperty($oObj, "__new__", $ELSCOPE_PRIVATE, $fNew)
	_AutoItObject_AddProperty($oObj, "__default__", $ELSCOPE_READONLY, Number($pPointer))
	_AutoItObject_AddDestructor($oObj, "__Au3Obj_ObjStructDestructor")
	Return $oObj
EndFunc   ;==>_AutoItObject_DllStructCreate

#endregion Public UDFs
;--------------------------------------------------------------------------------------------------------------------------------------