#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include-once

Opt("MustDeclareVars", 1) ; 0=no, 1=require pre-declare
Opt("GUICoordMode", 1)    ; 0=relative, 1=absolute, 2=cell
Opt("GUIResizeMode", 1)   ; 0=no resizing, <1024 special resizing

#include <Array.au3>
#include <File.au3>

;------------
;The Tag is optional and can be used for debugging
Func IPAddress($IPAddress, $tag = "")
	Dim $Results[1] ;The array to hold the final results
	Local $Array = StringSplit($IPAddress, "+")

	If $Array[0] <> 2 Then
		Debug("No count value found. Testing and returning the value. " & @ScriptLineNumber)
		Local $T = TestIP($Array[1])
		If StringInStr($T, "ERROR0") = 0 Then
			_ArrayAdd($Results, "TestIP failed " & $Array[1] & " Return " & $T & "   " & $tag)
			Return $Results
		EndIf
		_ArrayAdd($Results, $Array[1])
		_ArrayDelete($Results, 0) ; This returns the count entry
		Return $Results
	EndIf

	Local $T = TestIP($Array[1])
	If StringInStr($T, "ERROR0") = 0 Then
		_ArrayAdd($Results, "TestIP failed " & $Array[1] & " Return " & $T & "   " & $tag)
		Return $Results
	EndIf
	
	Local $IPArray = StringSplit($Array[1], ".")
	Local $Count = $Array[2]
	Local $IPAddressHEX = Hex($IPArray[1], 2) & Hex($IPArray[2], 2) & Hex($IPArray[3], 2) & Hex($IPArray[4], 2)
	Local $IPAddressDEC = Dec($IPAddressHEX)
	
	For $X = 0 To $Count
		Local $tmp3 = Hex($IPAddressDEC)
		Local $IPout = Dec(StringMid($tmp3, 1, 2)) & "." & Dec(StringMid($tmp3, 3, 2)) & "." & Dec(StringMid($tmp3, 5, 2)) & "." & Dec(StringMid($tmp3, 7, 2))
		_ArrayAdd($Results, $IPout)
		$IPAddressDEC += 1
	Next
	_ArrayDelete($Results, 0) ; deletes a blank entry at the begining

	Return $Results
	
EndFunc   ;==>IPAddress

;------------
;The Tag is optional and can be used for debugging
Func TestIP($IPAddress, $tag = "")
	Local $IPArray = StringSplit($IPAddress, ".") ;This is the ipaddress octets split on .
	
	If $IPArray[0] <> 4 Then
		Return "ERROR1  Not enough octets. 4 Required, " & $IPArray[0] & " Found. " & $tag
	EndIf
	
	_ArrayDelete($IPArray, 0) ; This returns the count entry
	
	For $T In $IPArray  ;verify that the octet values are within range
		If $T < 0 Or $T > 255 Then
			Return "ERROR2 octet out of range (0 to 255). " & $T & "   " & $tag
		EndIf
	Next
	
	Return "ERROR0" ;good address
EndFunc   ;==>TestIP
;------------
;The Tag is optional and can be used for debugging
Func CheckIPClass($AddressToTest, $tag = "")
	Debug("CheckIPClass")
	Local $octets = StringSplit($AddressToTest, ".")
	Debug($octets[1])
	If $octets[1] = 127 Then
		Return 'Loopback  ' & $tag
	ElseIf $octets[1] >= 1 And $octets[1] <= 126 Then
		Return 'Class A  ' & $tag
	ElseIf $octets[1] >= 128 And $octets[1] <= 191 Then
		Return 'Class B  ' & $tag
	ElseIf $octets[1] >= 192 And $octets[1] <= 223 Then
		Return 'Class C  ' & $tag
	ElseIf $octets[1] >= 224 And $octets[1] <= 239 Then
		Return 'Class D  ' & $tag
	ElseIf $octets[1] >= 240 And $octets[1] <= 254 Then
		Return 'Class A  ' & $tag
	ElseIf $octets[1] = 255 And $octets[2] = 255 And $octets[3] = 255 And $octets[4] = 255 Then
		Return 'Broadcast  ' & $tag
	Else
		Return 'Undefined  ' & $tag
	EndIf
EndFunc   ;==>CheckIPClass
;------------
Func RemoveBlankLines($filename)
	Local $Array1[1]
	Local $Array2[1]

	_FileReadToArray($filename, $Array1)
	;	Debug($Array1[0])
	For $X = 1 To $Array1[0]
		Local $tmp = $Array1[$X]
		Local $D = StringLen($tmp)
		;		Debug($D & " " & $tmp)
		If StringLen(StringStripWS($tmp, 1)) <> 0 Then _ArrayAdd($Array2, $tmp)
	Next
	_ArrayDelete($Array2, 0)
	_FileWriteFromArray($filename, $Array2)
EndFunc   ;==>RemoveBlankLines
;------------
;This function will take in a numeric string verify it and format and return the result
;It will handle integer, decimal and floating point numbers
;Commas are removed from the input string before processing
;The Tag is optional and can be used for debugging
Func CheckNumericString($NumerToCheck, $tag = "")
	Debug($tag & "  CheckNumber  >>" & $NumerToCheck & "<<")
	$NumerToCheck = StringRegExpReplace($NumerToCheck, "[,]", "", 0)
	If StringIsDigit($NumerToCheck) = 1 Then Return $NumerToCheck
	If StringIsFloat($NumerToCheck) = 1 Then Return $NumerToCheck
	
	Local $Array = StringSplit($NumerToCheck, "eE")
	If $Array[0] <> 2 Then
		SetError(1)
		Return "ERROR 1: " & $NumerToCheck & "  " & $tag
	EndIf
	If (StringIsInt($Array[1]) = 0) And (StringIsFloat($Array[1]) = 0) Then
		SetError(2)
		Return "ERROR 2: " & $NumerToCheck & "  " & $tag
	EndIf
	If (StringIsInt($Array[2]) = 0) And (StringIsFloat($Array[2]) = 0) Then
		SetError(3)
		Return "ERROR 3: " & $NumerToCheck & "  " & $tag
	EndIf
	Local $result = $Array[1] * (10 ^ $Array[2])
	If StringInStr($result, "#") <> 0 Then
		SetError(4)
		Return "ERROR 4: " & $result & "  " & $tag
	EndIf
	Return $result
EndFunc   ;==>CheckNumericString
;------------
Func Debug($msg, $ShowMsgBox = -1, $timeout = 0)
	DllCall("kernel32.dll", "none", "OutputDebugString", "str", "DEBUG " & @ScriptName & "  " & $msg)
	ConsoleWrite("DEBUG " & @ScriptName & "  " & $msg & @CRLF)
	If $ShowMsgBox > -1 Then MsgBox($ShowMsgBox, "DEBUG " & @ScriptName , $msg, $timeout)
EndFunc   ;==>Debug
;------------