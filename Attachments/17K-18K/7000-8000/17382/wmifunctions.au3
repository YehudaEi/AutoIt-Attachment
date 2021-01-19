#include-once
#include <Array.au3>

;*********************************************************************************************
; AutoIT WMI FUNCTIONS Beta By: Jim Parsons (SIMPLE_XP) 10/31/2007
;									
; Functionality: 
;	 > Expose WMI functions for easy manipulation
;	 
;**********************************************************************************************


Global Const $WBEM_CIMTYPE_STRING = 8
Global Const $WBEM_CIMTYPE_UNIT32 = 19


;_ADD_ROOT_NAMESPACE.......: Create a new namespace under the "Root" namespace.
;_DELETE_NAMESPACE.........: Delete a namespace under the "Root" namespace.
;_CREATE_NAMESPACE_CLASS...: Create a Class in a namespace; populate the key and additional properties


#region ;FUNCTIONS

;**********************************************************************************************************************
; CREATE NAMESPACE CLASS FUNCTION
;	 >  Use: _CREATE_NAMESPACE_CLASS( $ComputerName, $NameSpace, $ClassToCreate, $KeyProperty, $PropertyList )
;    > $PropertyList and $KeyProperty must contain the proper values and delimiters.
;   	[Property,xType|Property,xType|Property,xType]
;	    where xType = False for String, True for else. "|" = Main delimiter and "," = the property/Type delimiter
;	Returns: 0 if no errors, failures return failure on invalid array data only
;**********************************************************************************************************************
Func _CREATE_NAMESPACE_CLASS($PASSED_COMPUTER_S, $PASSED_NAMESPACE_S, $PASSED_CLASS, $PASSED_KEY_PROP, $PASSED_PROPERTIES)
	Dim	$OBJ_WMI, $OBJ_CLASS, $x, $WBEM_CIMTYPE
	$OBJ_WMI = ObjGet("winmgmts:\\" & $PASSED_COMPUTER_S & "\root\" & $PASSED_NAMESPACE_S)
	$OBJ_CLASS = $OBJ_WMI.Get()
	$OBJ_CLASS.Path_.Class = $PASSED_CLASS
	$KEY_PROP_ARRAY = 0
	$KEY_PROP_ARRAY = StringSplit($PASSED_KEY_PROP, ",")
	If IsArray($KEY_PROP_ARRAY) Then
		$WBEM_KEY_CIMTYPE = $KEY_PROP_ARRAY[2]
		If $WBEM_KEY_CIMTYPE = True Then 
			$WBEM_KEY_CIMTYPE = $WBEM_CIMTYPE_UNIT32
		Else
			$WBEM_KEY_CIMTYPE = $WBEM_CIMTYPE_STRING
		EndIf
		$OBJ_CLASS.Properties_.add($KEY_PROP_ARRAY[1], $WBEM_KEY_CIMTYPE)
		$OBJ_CLASS.Properties_($KEY_PROP_ARRAY[1]).Qualifiers_.add("key", True)	
	Else
		Return "ERROR-INVALID KEY PROPERTY ARGUMENT [Non Array Value passed]"
	EndIf
	$PROPERTY_ARRAY = 0
	$PROPERTY_ARRAY = StringSplit($PASSED_PROPERTIES, "|")
	If IsArray($PROPERTY_ARRAY) Then
		For $x = 1 to $PROPERTY_ARRAY[0] 
			$PROP_WBEM_ARRAY = 0
			$PROP_WBEM_ARRAY = StringSplit($PROPERTY_ARRAY[$x], ",")
			If IsArray($PROP_WBEM_ARRAY) Then
				$WBEM_VALUE = $PROP_WBEM_ARRAY[2]
				If $WBEM_VALUE = True Then 
					$WBEM_CIMTYPE = $WBEM_CIMTYPE_UNIT32
				Else
					$WBEM_CIMTYPE = $WBEM_CIMTYPE_STRING
				EndIf
				$OBJ_CLASS.Properties_.add($PROP_WBEM_ARRAY[1], $WBEM_CIMTYPE)
			EndIf
		Next
	Else
		Return "ERROR-INVALID PROPERTY ARGUMENT [Non Array Value passed]"
	EndIf
	$OBJ_CLASS.Put_
	Return @error
EndFunc
;*************************************************************************************************
; DELETE NAMESPACE FUNCTION
;	 >  Use: _DELETE_NAMESPACE( $ComputerName, $NameSpace )
;*************************************************************************************************
Func _DELETE_NAMESPACE($PASSED_COMPUTER, $PASSED_R_NAMESPACE)
	If $PASSED_R_NAMESPACE = "" Then
		Return "ERROR-INVALID Namespace [Blank value]"
	Else
		Dim $OBJ_WMI_REMOVE, $OBJ_ITEM_REMOVE
		$OBJ_WMI_REMOVE = ObjGet("winmgmts:\\" & $PASSED_COMPUTER & "\root")
		$OBJ_ITEM_REMOVE = $OBJ_WMI_REMOVE.Get("__Namespace.Name='" & $PASSED_R_NAMESPACE & "'")
		$OBJ_ITEM_REMOVE.Delete_
		Return @error
	EndIf
EndFunc
;*************************************************************************************************
; ADD ROOT NAMESPACE FUNCTION
;	 >  Use: _ADD_NAMESPACE( $ComputerName, $NameSpace )
;*************************************************************************************************
Func _ADD_ROOT_NAMESPACE($PASSED_LOCAL_COMPUTER, $PASSED_NAMESPACE)
	Dim $OBJ_WMI_SERVICE, $OBJ_ITEM, $OBJ_NAME_SPACE
	$OBJ_WMI_SERVICE = ObjGet("winmgmts:\\" & $PASSED_LOCAL_COMPUTER & "\root")
	$OBJ_ITEM = $OBJ_WMI_SERVICE.Get("__Namespace")
	$OBJ_NAME_SPACE = $OBJ_ITEM.SpawnInstance_
	$OBJ_NAME_SPACE.Name = $PASSED_NAMESPACE
	$OBJ_NAME_SPACE.Put_
	Return @error
EndFunc
#endregion ;FUNCTIONS