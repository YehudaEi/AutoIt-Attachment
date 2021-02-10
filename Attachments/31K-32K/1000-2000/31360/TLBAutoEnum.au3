#include-once
; ------------------------------------------------------------------------------
;
; Version:        1.0.0
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; License:        GNU/GPL, s. LICENSE.txt
; Description:    Definitions for TLBAutoEnum
; $Revision: $
; $Date: $
;
; ------------------------------------------------------------------------------
#include "TLIDirect.au3"
Global $_TLBAutoEnum_imported = 0

#Region ###TLBAutoEnum global functions###
;===============================================================================
; Function Name:   _TLBAutoEnum_ImportFile
; Description:     Imports specified enums into script's global scope from type
;                  library file.
; 
; Parameter(s):    $path - Path to type library file.
;                  $enumName - Name of the enum type to import or "*" meaning all
;                  enums from the library. Default is "*".
; 
; Return Value(s): Number of successfully inported enums. In case of failure @error
;                  is set to non-0 value and 0 is returned.
; 
; Author(s):       doudou
;===============================================================================
Func _TLBAutoEnum_ImportFile($path, $enumName = "*")
    Local $objTLib = _ITypeLib_Load($path)
    If @error Then Return SetError(@error, @extended, 0)
    If IsObj($objTLib) Then Return _TLBAutoEnum_Import($objTLib, $enumName)
    Return SetError(1, 0, 0)
EndFunc
;===============================================================================
; Function Name:   _TLBAutoEnum_ImportReg
; Description:     Imports specified enums into script's global scope from type
;                  library identified by its registration parameters.
; 
; Parameter(s):    guid - The GUID of the library being loaded. Can be binary or
;                  string value.
;                  $enumName - Name of the enum type to import or "*" meaning all
;                  enums from the library. Default is "*".
;                  $wVerMajor - Major version number of the library being loaded.
;                  $wVerMinor - Minor version number of the library being loaded.
;                  $lcid - National language code of the library being loaded.
; 
; Return Value(s): Number of successfully inported enums. In case of failure @error
;                  is set to non-0 value and 0 is returned.
; 
; Author(s):       doudou
;===============================================================================
Func _TLBAutoEnum_ImportReg(Const ByRef $guid, $enumName = "*", $wVerMajor = 1, $wVerMinor = 0, $lcid = $LOCALE_SYSTEM_DEFAULT)
    Local $objTLib = _ITypeLib_LoadReg($guid, $wVerMajor, $wVerMinor, $lcid)
    If @error Then Return SetError(@error, @extended, 0)
    If IsObj($objTLib) Then Return _TLBAutoEnum_Import($objTLib, $enumName)
    Return SetError(1, 0, 0)
EndFunc
;===============================================================================
; Function Name:   _TLBAutoEnum_ImportRelated
; Description:     Imports specified enums into script's global scope from type
;                  library related (i.e. containing it) to a COM object.
; 
; Parameter(s):    $someObj - Any object returned by ObjCreate() or ObjGet().
;                  $enumName - Name of the enum type to import or "*" meaning all
;                  enums from the library. Default is "*".
; 
; Return Value(s): Number of successfully inported enums. In case of failure @error
;                  is set to non-0 value and 0 is returned.
; 
; Author(s):       doudou
;===============================================================================
Func _TLBAutoEnum_ImportRelated(ByRef $someObj, $enumName = "*")
    If IsObj($someObj) Then
        Local $objDisp = _IDispatch_Wrap($someObj)
        If @error Then Return SetError(@error, @extended, 0)
        If IsObj($objDisp) Then
            Local $objTInfo = _IDispatch_GetTypeInfo($objDisp)
            If @error Then Return SetError(@error, @extended, 0)
            If IsObj($objTInfo) Then
                Local $objTInfo_index = -1
                Local $objTLib = _ITypeInfo_GetContainingTypeLib($objTInfo, $objTInfo_index)
                If @error Then Return SetError(@error, @extended, 0)
                If IsObj($objTLib) Then Return _TLBAutoEnum_Import($objTLib, $enumName)
            EndIf
        EndIf
    EndIf
    Return SetError(1, 0, 0)   
EndFunc
;===============================================================================
; Function Name:   _TLBAutoEnum_Import
; Description:     Imports specified enums into script's global scope from given
;                  type library object.
; 
; Parameter(s):    $objITypeLibInfo - Previously loaded type library.
;                  $enumName - Name of the enum type to import or "*" meaning all
;                  enums from the library. Default is "*".
; 
; Return Value(s): Number of successfully inported enums. In case of failure @error
;                  is set to non-0 value and 0 is returned.
; 
; Author(s):       doudou
;===============================================================================
Func _TLBAutoEnum_Import(ByRef $objITypeLibInfo, $enumName = "*")
    Local $result = 0
    If "*" = $enumName Then
        Local $count = _ITypeLib_GetTypeInfoCount($objITypeLibInfo)
        Local $base = _TLBAutoEnumHelper_PrepareImports($count)
        For $i = 0 To $count - 1
            Local $objTInfo = _ITypeLib_GetTypeInfo($objITypeLibInfo, $i)
            If IsObj($objTInfo) Then
                $objTInfo = _TLBAutoEnumHelper_ResolveAlias($objTInfo)
                Local $tiAttr = _ITypeInfo_GetTypeAttr($objTInfo)
                If IsDllStruct($tiAttr) Then
                    If $TKIND_ENUM = DllStructGetData($tiAttr, "typekind") Then
                        Local $docInfo[4] = [1, 0, 0, 0]
                        If _ITypeLib_GetDocumentation($objITypeLibInfo, $i, $docInfo) Then $enumName = $docInfo[$TDOC_NAME]
                        Local $obj = TLBAutoEnum_New($objTInfo, $enumName, $tiAttr)
                        If IsObj($obj) Then
                            $_TLBAutoEnum_imported[$base + $result] = $enumName
                            $result += 1
                            Assign($enumName, $obj, 2)
                        EndIf
                        $obj = 0
                    EndIf
                    $objTInfo.ReleaseTypeAttr(Number(DllStructGetPtr($tiAttr)))
                EndIf
            EndIf
        Next
        If 0 < $result And $base + $result <> UBound($_TLBAutoEnum_imported) Then Redim $_TLBAutoEnum_imported[$base + $result]
    Else
        Local $obj = TLBAutoEnum_NewByName($objITypeLibInfo, $enumName)
        If IsObj($obj) Then
            Local $base = _TLBAutoEnumHelper_PrepareImports(1)
            $_TLBAutoEnum_imported[$base] = $enumName
            $result = 1
            Assign($enumName, $obj, 2)
        EndIf
        $obj = 0
    EndIf
    If 0 = $result Then Return SetError(1, 0, 0)
    Return $result
EndFunc
;===============================================================================
; Function Name:   _TLBAutoEnum_CleanupImports
; Description:     Removes auto enum object from global scope, all previously
;                  imported enums are inaccessible after the call.
; 
; Author(s):       doudou
;===============================================================================
Func _TLBAutoEnum_CleanupImports()
    For $i = 0 To UBound($_TLBAutoEnum_imported) - 1
        If 0 < StringLen($_TLBAutoEnum_imported[$i]) And IsDeclared($_TLBAutoEnum_imported[$i]) Then Assign($_TLBAutoEnum_imported[$i], 0, 4)
    Next
    $_TLBAutoEnum_imported = 0
EndFunc
#EndRegion ;TLBAutoEnum global functions

#Region ###TLBAutoEnum construction/destruction###
Func TLBAutoEnum_NewByName(ByRef $objITypeLibInfo, $enumName)
    Local $result = 0
    
    For $i = 0 To _ITypeLib_GetTypeInfoCount($objITypeLibInfo) - 1
        Local $objTInfo = _ITypeLib_GetTypeInfo($objITypeLibInfo, $i)
        If IsObj($objTInfo) Then
            Local $docInfo[4] = [1, 0, 0, 0]
            If _ITypeLib_GetDocumentation($objITypeLibInfo, $i, $docInfo) And $docInfo[$TDOC_NAME] = $enumName Then
                $objTInfo = _TLBAutoEnumHelper_ResolveAlias($objTInfo)
                Local $tiAttr = _ITypeInfo_GetTypeAttr($objTInfo)
                If IsDllStruct($tiAttr) Then
                    If $TKIND_ENUM = DllStructGetData($tiAttr, "typekind") Then $result = TLBAutoEnum_New($objTInfo, $enumName, $tiAttr)
                    $objTInfo.ReleaseTypeAttr(Number(DllStructGetPtr($tiAttr)))
                    If IsObj($result) Then ExitLoop
                EndIf
            EndIf
        EndIf
    Next
    Return $result
EndFunc

Func TLBAutoEnum_New(ByRef $objEnumInfo, $enumName = Default, $tiAttr = Default)
    Local $result = _AutoItObject_Create()
    If 3 > @NumParams Then $tiAttr = _ITypeInfo_GetTypeAttr($objEnumInfo)
    If $TKIND_ENUM =  DllStructGetData($tiAttr, "typekind") Then
        If IsKeyword($enumName) Then
            Local $docInfo[4] = [1, 0, 0, 0]
            If _ITypeInfo_GetDocumentation($objEnumInfo, -1, $docInfo) Then $enumName = $docInfo[0]
        EndIf
        For $j = 0 To DllStructGetData($tiAttr, "cVars") - 1
            Local $tiVarDesc = _ITypeInfo_GetGetVarDesc($objEnumInfo, $j)
            If IsDllStruct($tiVarDesc) Then
                Local $membInfo[4] = [1, 0, 0, 0]
                If _ITypeInfo_GetDocumentation($objEnumInfo, DllStructGetData($tiVarDesc, "MemID"), $membInfo) Then
                    ;ConsoleWrite("[DBG] Reading " & $enumName & "." & $membInfo[$TDOC_NAME] & @lf)
                    Local $val = 0
                    Local $p = DllStructGetData($tiVarDesc, "lpVarValue")
                    If $p Then $val = _AutoItObject_VariantRead($p)
                    If IsPtr($val) Then $val = Number($val)
                    _AutoItObject_AddProperty($result, $membInfo[$TDOC_NAME], $ELSCOPE_READONLY, $val)
                EndIf
                $objEnumInfo.ReleaseVarDesc(Number(DllStructGetPtr($tiVarDesc)))
            EndIf
        Next
    EndIf
    If 3 > @NumParams Then $objEnumInfo.ReleaseTypeAttr(Number(DllStructGetPtr($tiAttr)))
    _AutoItObject_AddProperty($result, "_EnumName", $ELSCOPE_READONLY, $enumName)
    _AutoItObject_AddDestructor($result, "TLBAutoEnum_Release")
    Return $result
EndFunc

Func TLBAutoEnum_Release($oSelf)
;     ConsoleWrite("[DBG] TLBAutoEnum_Release" & @LF)
EndFunc
#EndRegion ;TLBAutoEnum construction/destruction 

#Region ###TLBAutoEnum helper functions###
Func _TLBAutoEnumHelper_ResolveAlias(ByRef $objTInfo)
    Local $result = $objTInfo
    Local $tiAttr = _ITypeInfo_GetTypeAttr($objTInfo)
    If IsDllStruct($tiAttr) Then
        If $TKIND_ALIAS = DllStructGetData($tiAttr, "typekind") Then
            Local $p = DllStructGetPtr($tiAttr, "lpItemDesc")
            If $p Then
                Local $tElemDesc = DllStructCreate($tagELEMDESC, $p)
                $result = _ITypeInfo_GetRefTypeInfo($objTInfo, DllStructGetData($tElemDesc, "lpItemDesc"))
            EndIf
        EndIf
        $objTInfo.ReleaseTypeAttr(Number(DllStructGetPtr($tiAttr)))
    EndIf
    Return $result
EndFunc

Func _TLBAutoEnumHelper_PrepareImports($newDim)
    Local $result = UBound($_TLBAutoEnum_imported)
    If 0 < Int($newDim) Then
        If IsArray($_TLBAutoEnum_imported) Then
            ReDim $_TLBAutoEnum_imported[$result + $newDim]
        Else
            Dim $_TLBAutoEnum_imported[$newDim]
        EndIf
    EndIf
    Return $result
EndFunc
#EndRegion ;TLBAutoEnum helper functions
