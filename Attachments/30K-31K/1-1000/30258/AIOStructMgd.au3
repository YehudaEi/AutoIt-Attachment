#include-once
#include <Memory.au3>
#include <AIOStruct.au3>
; ------------------------------------------------------------------------------
;
; Version:        1.1.2
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; Description:    DllStruct wrapper for AutoItObject with managed struct memory.
; Requirements:   Memory, AutoItObject, AIOStruct
; $Revision: 1.5 $
; $Date: 2010/04/09 15:37:29 $
;
; ------------------------------------------------------------------------------
#Region ###AIOStructMgd construction/destruction###
;===============================================================================
; Function Name:   AIOStructMgd_New
; Description:     Constructs new managed wrapper object. Additional memory is
;                  allocated dynamically.
;                  Remark: if AIOStructMgd is used as base type in other AutoItObject,
;                  the _StructPtr member of the derrived instance should be always
;                  overridden and set to 0 in its constructor since _AutoItObject_Create($parent)
;                  creates a copy of $parent and memory pointed by shared _StructPtr
;                  can be incidentially freed.
;
; Parameter(s):    $tagStruct - a string representing the structure (s. DllStructCreate).
;                  $pointer - if supplied the wrapper will copy the data
;                             from the struct pointed by it (the memory can be
;                             safely freeed afterwards).
;
; Return Value(s): The constructed wrapper. The wrapper inherits all public properties
;                  and methods from AIOStruct, additional methods are described separately.
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd_New(Const ByRef $tagStruct, $pointer = 0)
    Local $parent = AIOStruct_New($tagStruct, $pointer)
    Local $result = _AutoItObject_Create($parent)
    _AutoItObject_AddProperty($result, "_StructPtr", $ELSCOPE_PRIVATE, 0)
    _AutoItObject_AddMethod($result, "GetPtr", "AIOStructMgd_GetPtr")
    _AutoItObject_AddMethod($result, "UpdateStruct", "AIOStructMgd_UpdateStruct")
    _AutoItObject_AddMethod($result, "_MemAlloc", "AIOStructMgd__MemAlloc", True)
    _AutoItObject_AddMethod($result, "_MemFree", "AIOStructMgd__MemFree", True)
    _AutoItObject_AddDestructor($result, "AIOStructMgd_Release")
    Return $result
EndFunc
;===============================================================================
; Function Name:   AIOStructMgd.Release
; Description:     Destructs the wrapper object and frees allocated memory (internal use).
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd_Release($oSelf)
    If Not $oSelf._MemFree() Then SetError(@error, @extended)
EndFunc
#EndRegion ;AIOStructMgd construction/destruction

#Region ###AIOStructMgd public methods###
;===============================================================================
; Function Name:   AIOStructMgd.GetPtr
; Description:     Retrieves pointer to the DllStruct initialized with data from
;                  object properties, equivalent to DllStructGetPtr().
;
; Parameter(s):    $element - (optional) element name or element index (1-based)
;                  who's pointer is required.
;
; Return Value(s): The struct pointer or 0 if operation fails.
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd_GetPtr($oSelf, $element = -1)
    If $oSelf._MemAlloc() Then
        Local $result = $oSelf.GetStruct($oSelf._StructPtr)
        If -1 = $element Then
            Return $result
        Else
            Local $t = DllStructCreate($oSelf.StructTag, $result)
            If 0 = @error Then $result = DllStructGetPtr($t, $element)
            Return SetError(@error, @extended, Number($result))
        EndIf
    EndIf
    Return SetError(1, 0, $oSelf._StructPtr)
EndFunc
;===============================================================================
; Function Name:   AIOStructMgd.UpdateStruct
; Description:     Reads data from the internal DllStruct pointer into object properties.
;                  Must be called every time the pointer returned by AIOStructMgd.GetPtr()
;                  is used somewhere to modify the struct.
;
; Return Value(s): Number of elements successfully updated.
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd_UpdateStruct($oSelf)
    If $oSelf._StructPtr Then Return $oSelf.ReadStruct($oSelf._StructPtr)
    Return 0
EndFunc
#EndRegion ;AIOStructMgd public methods

#Region ###AIOStructMgd private methods###
;===============================================================================
; Function Name:   AIOStructMgd._MemAlloc
; Description:     Allocates memory for the DllStruct when needed (internal use).
;                  If memory allocation fails @error is set to non-0 value and the object
;                  is unmanaged, i.e. $objStruct.GetPtr() will always return 0.
;
; Return Value(s): Memory pointer or 0 if operation fails.
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd__MemAlloc($oSelf)
    If $oSelf._StructPtr Then Return $oSelf._StructPtr
    Local $mgdPtr = _MemVirtualAlloc(0, $oSelf.StructSize, $MEM_COMMIT, $PAGE_READWRITE)
    If 0 = $mgdPtr Then
        SetError(@error, @extended)
    Else
        $oSelf._StructPtr = Number($mgdPtr)
    EndIf
    Return $oSelf._StructPtr
EndFunc
;===============================================================================
; Function Name:   AIOStructMgd._MemFree
; Description:     Frees previously allocated memory (internal use).
;
; Return Value(s): True or False if operation fails.
;
; Author(s):       doudou
;===============================================================================
Func AIOStructMgd__MemFree($oSelf)
    If $oSelf._StructPtr Then
        If Not _MemVirtualFree($oSelf._StructPtr, 0, $MEM_RELEASE) Then Return SetError(@error, @extended, False)
    EndIf
    $oSelf._StructPtr = 0
    Return True
EndFunc
#EndRegion ;AIOStructMgd private methods
