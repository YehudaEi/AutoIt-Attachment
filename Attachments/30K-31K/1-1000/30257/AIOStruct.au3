#include-once
#include <AutoItObject.au3>
; ------------------------------------------------------------------------------
;
; Version:        1.1.2
; AutoIt Version: 3.3.4.0
; Language:       English
; Author:         doudou
; Description:    DllStruct wrapper for AutoItObject.
; Requirements:   AutoItObject
; $Revision: 1.4 $
; $Date: 2010/04/08 19:49:16 $
;
; ------------------------------------------------------------------------------

#Region ###Helper functions###
;===============================================================================
; Function Name:   _AIOStruct_ToDllStruct
; Description:     Converts wrapper object to DllStruct.
;
; Parameter(s):    $objStruct - wrapper object
;
; Return Value(s): DllStruct as defined in the object and all data set
;                  accordingly to its properties.
;
; Author(s):       doudou
;===============================================================================
Func _AIOStruct_ToDllStruct(ByRef $objStruct)
    Local $result = DllStructCreate($objStruct.StructTag)
    $objStruct.GetStruct(Number(DllStructGetPtr($result)))
    Return SetError(@error, @extended, $result)
EndFunc
;===============================================================================
; Function Name:   _AIOStruct_CheckDataTypeRef
; Description:     Converts data to AIO compatible type.
;
; Parameter(s):    $data - data to convert
;
; Return Value(s): If a conversion was required - converted data, otherwise data unchanged.
;
; Author(s):       doudou
;===============================================================================
Func _AIOStruct_CheckDataTypeRef(ByRef $data)
    If IsPtr($data) Then Return Number($data)
    Return $data
EndFunc
;===============================================================================
; Function Name:   _AIOStruct_CheckDataType
; Description:     Wrapper for _AIOStruct_CheckDataTypeRef() for verifying simple
;                  values without declaring a variable.
;
; Parameter(s):    $data - data to convert
;
; Return Value(s): If a conversion was required - converted data, otherwise data unchanged.
;
; Author(s):       doudou
;===============================================================================
Func _AIOStruct_CheckDataType($data)
    Return _AIOStruct_CheckDataTypeRef($data)
EndFunc
#EndRegion ;Helper functions

#Region ###AIOStruct construction/destruction###
;===============================================================================
; Function Name:   AIOStruct_New
; Description:     Constructs new wrapper object.
;
; Parameter(s):    $tagStruct - a string representing the structure (s. DllStructCreate).
;                  $pointer - if supplied the wrapper will copy the data
;                             from the struct pointed by it.
;
; Return Value(s): The constructed wrapper. The wrapper will have following public
;                  properties:
;                    StructSize - (readonly) size of the struct (s. DllStructGetSize)
;                    StructAlignment - (readonly) struct alingment (s. DllStructCreate)
;                    StructTag - (readonly) string used to construct this object
;                    ElementCount - (readonly) number of struct elements
;                    <Element0> ... <ElementN> - writeable properties representing struct
;                    elements as defined by StructTag, <ElementN> is either the name
;                    of the corr. element or a constructed key for unnamed elements.
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_New(Const ByRef $tagStruct, $pointer = 0)
    Local $result = _AutoItObject_Create()
    Local $t
    If 0 = $pointer Then
        $t = DllStructCreate($tagStruct)
    Else
        $t = DllStructCreate($tagStruct, $pointer)
    EndIf
    
    Local $parts = StringSplit($tagStruct, ";")
    Local $align = 8
    Local $start = 0
    Local $props[$parts[0]]
    Local $subscr[$parts[0]]
    For $i = 1 To $parts[0]
        Local $part = StringStripWS($parts[$i], 3)
        If 1 = $i And ("align" = $part Or "align " = StringLeft($part, 6)) Then
            Local $matches = StringRegExp($part, "align\s+(\d+)", 1)
            If 0 = @error Then $align = $matches[0]
            $start = 1
            Redim $props[UBound($props) - 1]
            Redim $subscr[UBound($props)]
        Else
            Local $matches = StringRegExp($part, "(\w+)\s+(\w+)(\s*\[(\d+)\])?", 1)
            If 0 = @error Then
                $props[$i - $start - 1] = $matches[1]
                If 3 < UBound($matches) And Not ("char" = $matches[0] Or "wchar" = $matches[0] Or "byte" = $matches[0]) Then $subscr[$i - $start - 1] = $matches[3]
            Else
                $matches = StringRegExp($part, "(\w+)\s*\[(\d+)\]", 1)
                If 0 = @error Then
                    $props[$i - $start - 1] = "__ind__" & $matches[0] & ($i - $start)
                    If Not ("char" = $matches[0] Or "wchar" = $matches[0] Or "byte" = $matches[0]) Then $subscr[$i - $start - 1] = $matches[1]
                Else
                    $props[$i - $start - 1] = "__ind__" & $part & ($i - $start)
                EndIf
            EndIf
        EndIf
    Next
    For $i = 0 To UBound($props) - 1
        Local $data = DllStructGetData($t, $i + 1)
        If $subscr[$i] Then
            Dim $data[$subscr[$i]]
            For $s = 0 To $subscr[$i] - 1
                $data[$s] = _AIOStruct_CheckDataType(DllStructGetData($t, $i + 1, $s + 1))
            Next
        Else
            $data = _AIOStruct_CheckDataTypeRef($data)
        EndIf
        _AutoItObject_AddProperty($result, $props[$i], $ELSCOPE_PUBLIC, $data)
    Next
    _AutoItObject_AddProperty($result, "StructSize", $ELSCOPE_READONLY, DllStructGetSize($t))
    _AutoItObject_AddProperty($result, "StructAlignment", $ELSCOPE_READONLY, $align)
    _AutoItObject_AddProperty($result, "StructTag", $ELSCOPE_READONLY, $tagStruct)
    _AutoItObject_AddProperty($result, "ElementCount", $ELSCOPE_READONLY, UBound($props))
    _AutoItObject_AddProperty($result, "_StructElements", $ELSCOPE_PRIVATE, $props)
    _AutoItObject_AddProperty($result, "_StructSubscripts", $ELSCOPE_PRIVATE, $subscr)
    _AutoItObject_AddMethod($result, "GetElementName", "AIOStruct_GetElementName")
    _AutoItObject_AddMethod($result, "GetData", "AIOStruct_GetData")
    _AutoItObject_AddMethod($result, "SetData", "AIOStruct_SetData")
    _AutoItObject_AddMethod($result, "GetStruct", "AIOStruct_GetStruct")
    _AutoItObject_AddMethod($result, "ReadStruct", "AIOStruct_ReadStruct")
    _AutoItObject_AddDestructor($result, "AIOStruct_Release")
    Return $result
EndFunc
;===============================================================================
; Function Name:   AIOStruct.Release
; Description:     Destructs the wrapper object (internal use).
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_Release($oSelf)
    $oSelf._StructElements = 0
    $oSelf.StructTag = 0
EndFunc
#EndRegion ;AIOStruct construction/destruction

#Region ###AIOStruct public methods###
;===============================================================================
; Function Name:   AIOStruct.GetElementName
; Description:     Retrieves name of a sturct element at the specified index.
;
; Parameter(s):    $index - element index (must be >= 0 and < AIOStruct.ElementCount).
;
; Return Value(s): Element name.
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_GetElementName($oSelf, $index)
    Local $membArr = $oSelf._StructElements
    Return $membArr[$index]
EndFunc
;===============================================================================
; Function Name:   AIOStruct.SetData
; Description:     Sets data in the specified element. Useful if the element name
;                  is unknown or an array position of the element is modifed. 
;
; Parameter(s):    $element - element name or element index (must be >= 0
;                             and < AIOStruct.ElementCount).
;                  $value - data to set (shouldn't be an array, pointers must be
;                           converted to number)
;                  $index - (optional) for elements that are an array this specifies
;                           the 0-based index to set.
;
; Return Value(s): None.
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_SetData($oSelf, $element, $value, $index = Default)
    Local $data = Default
    If IsInt($element) Then
        Local $membArr = $oSelf._StructElements
        $element = $membArr[$element]
    EndIf
    $data = Execute("$oSelf." & $element)
    If @error Then Return SetError(@error, @extended, 0)
    If IsInt($index) Then
        If Not IsArray($data) Then
            Dim $data[$index + 1]
        ElseIf $index >= UBound($data) Then
            ReDim $data[$index + 1]
        EndIf
        $data[$index] = _AIOStruct_CheckDataTypeRef($value)
    Else
        $data = _AIOStruct_CheckDataTypeRef($value)
    EndIf
    _AutoItObject_AddProperty($oSelf, $element, $ELSCOPE_PUBLIC, $data)
EndFunc
;===============================================================================
; Function Name:   AIOStruct.GetData
; Description:     Retrieves data from the specified element. Useful if the element name
;                  is unknown or an array position of the element is to read. 
;
; Parameter(s):    $element - element name or element index (must be >= 0
;                             and < AIOStruct.ElementCount).
;                  $index - (optional) for elements that are an array this specifies
;                           the 0-based index to read.
;
; Return Value(s): Element data.
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_GetData($oSelf, $element, $index = Default)
    Local $result = Default
    Local $err = 0
    If IsInt($element) Then
        Local $membArr = $oSelf._StructElements
        $element = $membArr[$element]
    EndIf
    $result = Execute("$oSelf." & $element)
    $err = @error
    If IsInt($index) Then
        If IsArray($result) And UBound($result) > $index Then
            $result = $result[$index]
        Else
            $err = 1
        EndIf
    EndIf
    Return SetError($err, @extended, $result)
EndFunc
;===============================================================================
; Function Name:   AIOStruct.GetStruct
; Description:     Writes data saved in the object properties back to a DllStruct. 
;
; Parameter(s):    $pointer - pointer to the memory allocated for the struct
;                             (must be converted to number).
;
; Return Value(s): The struct pointer.
;
; See Also:        _AIOStruct_ToDllStruct
; Author(s):       doudou
;===============================================================================
Func AIOStruct_GetStruct($oSelf, $pointer)
    Local $result = DllStructCreate($oSelf.StructTag, $pointer)
    For $i = 0 To $oSelf.ElementCount - 1
        Local $data = $oSelf.GetData($i)
        If IsArray($data) Then
            For $a = 0 To UBound($data) - 1
                DllStructSetData($result, $i + 1, $data[$a], $a + 1)
            Next
        Else
            DllStructSetData($result, $i + 1, $data)
        EndIf
        If @error Then Return SetError(@error, @extended, $pointer)
    Next
    Return SetError(@error, @extended, $pointer)
EndFunc
;===============================================================================
; Function Name:   AIOStruct.ReadStruct
; Description:     Reads data from a DllStruct into object properties. 
;
; Parameter(s):    $pointer - pointer to the struct (must be converted to number).
;
; Return Value(s): Number of elements successfully read.
;
; Author(s):       doudou
;===============================================================================
Func AIOStruct_ReadStruct($oSelf, $pointer)
    Local $t = DllStructCreate($oSelf.StructTag, $pointer)
    If @error Then Return SetError(@error, @extended, 0)
    Local $subscr = $oSelf._StructSubscripts
    Local $membArr = $oSelf._StructElements
    For $i = 0 To $oSelf.ElementCount - 1
        Local $data
        If $subscr[$i] Then
            Dim $data[$subscr[$i]]
            For $s = 0 To $subscr[$i] - 1
                $data[$s] = DllStructGetData($t, $i + 1, $s + 1)
                If @error Then Return SetError(@error, @extended, $i)
                $data[$s] = _AIOStruct_CheckDataType($data[$s])
            Next
        Else
            $data = DllStructGetData($t, $i + 1)
            If @error Then Return SetError(@error, @extended, $i)
            $data = _AIOStruct_CheckDataTypeRef($data)
        EndIf
        _AutoItObject_AddProperty($oSelf, $membArr[$i], $ELSCOPE_PUBLIC, $data)
    Next
    Return $oSelf.ElementCount
EndFunc
#EndRegion ;AIOStruct public methods
