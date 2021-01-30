; ===================================================================
; JSON UDF's
; v0.3
;
; By: BAM5
; Last Updated: 10/07/2009
; Tested with AutoIt Version 3.3.0.0
; Extra requirements: Nothing!
;
; A set of functions that allow you to encode and decode JSON Strings
;
; Thanks to wraithdu for setting me up with some SRE. It really made
; the script a lot less messy.
;
; Comments:
;			Unfortunately I have no idea how to encode or even detect
;		multi-dimensional arrays. I wish multi-dimensional arrays in
;		Autoit were more like javascript where $array[0] would point
;		to another array so accessing the array in the array would be
;		coded like this $array[0][0]. But that's more OOP which AIT
;		hasn't really gotten into.
;
;			In order to access arrays in other arrays you must first
;		point a variable to the embeded array. Example:
;
;				Dim $EmbededArray[1]=["Look I work!"]
;				Dim $ArrayWithArrayInside[2]=[$EmbededArray, "extra"]
;				$array = $ArrayWithArrayInside[0]
;				MsgBox(0, "Hooray!", $array[0])
;
;			With the way Javascript works it would be:
;
;				Dim $EmbededArray[1]=["Look I work!"]
;				Dim $ArrayWithArrayInside[2]=[$EmbededArray, "extra"]
;				MsgBox(0, "Hooray!", $ArrayWithArrayInside[0][0])
;
;			Which is why JSON is more sensible in Javascript and other
;		languages.
;
; Main functions:
; _toJSONString - Encodes a object to a JSON String
; _fromJSONString - Creates a object from a JSON String
; ===================================================================

#include <Array.au3>
#include-once

; ===================================================================
; _ToJSONString($obj)
;
; Goes through an object you give it- being an array or string or
; other- and turns it into a JSON String which you can send to
; servers or save to a text file to recall information later.
;
; Parameters:
;	$obj - IN - Object to be turnd into a JSON String
; Returns:
;	JSON String or false on failure
; Errors:
;	@error = 1 - Unknown type of variable inputed
; ===================================================================
Func _ToJSONString($obj)
	If IsArray($obj) Then
		$returnString = "["
		For $object In $obj
			$returnString &= _ToJSONString($object) & ","
		Next
		$returnString = StringLeft($returnString, StringLen($returnString) - 1)
		$returnString &= "]"
	ElseIf IsFloat($obj) Or IsInt($obj) Or IsBinary($obj) Then
		$returnString = String($obj)
	ElseIf IsBool($obj) Then
		If $obj Then
			$returnString = "true"
		Else
			$returnString = "false"
		EndIf
	ElseIf IsString($obj) Then
		$returnString = '"' & StringReplace(StringReplace(String($obj), '"', '\"'), ',', '\,') & '"'
	Else
		SetError(1)
		Return (False)
	EndIf
	Return ($returnString)
EndFunc   ;==>_toJSONString

; ===================================================================
; _FromJSONString($str)
;
; Takes a JSON String and decodes it into program objects such as
; arrays and numbers and strings and bools.
;
; Parameters:
;	$str - IN - The JSON String to decode into objects
; Returns:
;	A object decoded from a JSON String or False on error
; Errors
;	@error = 1 - Syntax error in the JSON String or unknown variable
;	Also, if there is an error in decoding part of the string such as
;		a variable or a array, this function will replace the variable
;		or array with a string explaining the error.
; ===================================================================
Func _FromJSONString($str)
	If StringLeft($str, 1) = '"' And StringRight($str, 1) = '"' And Not (StringRight($str, 2) = '\"') Then
		$obj = StringReplace(StringReplace(_StringRemoveFirstLastChar($str, '"'), '\"', '"'), '\,', ',')
	ElseIf $str = "true" Then
		$obj = True
	ElseIf $str = "false" Then
		$obj = False
	ElseIf StringLeft($str, 2) = "0x" Then
		$obj = Binary($str)
	ElseIf StringIsInt($str) Then
		$obj = Int($str)
	ElseIf StringIsFloat($str) Then
		$obj = Number($str)
	ElseIf StringLeft($str, 1) = '[' And StringRight($str, 1) = ']' Then
		$str = StringTrimLeft($str, 1)
		$str = StringTrimRight($str, 1)
		$ufelems = StringRegExp($str, "(\[.*?\]|.*?[^\\])(?:,|\z)", 3)
		Dim $obj[1]
		For $elem In $ufelems
			$insObj = _FromJSONString($elem)
			If $insObj = False And @error = 1 Then $insObj = 'Error in syntax of piece of JSONString: "' & $elem & '"'
			_ArrayAdd($obj, $insObj)
		Next
		_ArrayDelete($obj, 0)
	Else
		SetError(1)
		Return (False)
	EndIf
	Return ($obj)
EndFunc   ;==>_fromJSONString


; ===================================================================
; _StringRemoveFirstLastChar($str, $char[, $firstCount=1[, $lastCount=1]])
;
; Removes characters matching $char from the beginning and end of a string
;
; Parameters:
;	$str - IN - String to search search modify and return
;	$char - IN - Character to find and delete in $str
;	$firstCount - OPTIONAL IN - How many to delete from the beginning
;	$lastCount - OPTIONAL IN - How many to delete from the end
; Returns:
;	Modified string
; Remarks:
;	Could probably be easily turned into a replace function
;					(But I'm too lazy :P )
; ===================================================================
Func _StringRemoveFirstLastChar($str, $char, $firstCount = 1, $lastCount = 1)
	$returnString = ""
	$splited = StringSplit($str, '"', 2)
	$count = 1
	$lastCount = UBound($splited) - $lastCount
	For $split In $splited
		$returnString &= $split
		If $count > $firstCount And $count < $lastCount Then $returnString &= '"'
		$count += 1
	Next
	Return ($returnString)
EndFunc   ;==>_StringRemoveFirstLastChar
