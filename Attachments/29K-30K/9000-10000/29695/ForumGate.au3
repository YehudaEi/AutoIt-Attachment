#include <string.au3>
$Temp = 3667563225088

$Temp1 = _BitAnd($Temp, 4294967295)
$Temp2 = _BitXOR($Temp, 1)
Msgbox(0,"Result", "BitAnd = " & $Temp1 & @LF & "BitXOR = " & $Temp2, 0)

;--------------------------------------------------------------------------------------------
; Function _BitAnd
; Simulate the BitAND function in AutoIt!
;--------------------------------------------------------------------------------------------
; Input		: 	Decimal number
;				Decimal Mask
; Output	: 	Decimal result
;--------------------------------------------------------------------------------------------
; Conversion Decimal to Binary for the first decimal number (Value)
; Conversion Decimal to Binary for the second decimal number (Mask)
; Reverse the Binary value
; Pad the shortest string with 0
; Gate And
; Convert the Binary result to decimal number
;--------------------------------------------------------------------------------------------
Func _BitAnd($arg1,$arg2)
	Local $bin = "", $bin2 = "", $result = ""

	$bin = _Dec2Bin($arg1)
	$bin2 = _Dec2Bin($arg2)
;-----------------------------------------------
; Reverse the Binary'3 String
; Before 	= 00000000000001011011001111010111
; After 	= 11101011110011011010000000000000
;-----------------------------------------------
	$bin  = _StringReverse($bin)
	$bin2 = _StringReverse($bin2)

;-----------------------------------------------
; Pad the shortest string with 0 based on the longest one
; EX: 	Before padding = 11111111111111111111111111111111
; 		After Padding  = 000000000011111111111111111111111111111111
;-----------------------------------------------
	If StringLen($bin) <> StringLen($bin2) Then
		If StringLen($bin) > StringLen($bin2) Then
			$add =""
			For $i = 1 To (StringLen($bin) - StringLen($bin2)) Step 1
				$add  &= 0
			Next
			$bin2 = $add & $bin2
		Else
			$add = ""
			For $i = 1 To (StringLen($bin2) - StringLen($bin)) Step 1
				$add  &= 0
			Next
			$bin = $add & $bin
		EndIf
	EndIf

;-----------------------------------------------
; AND Gate
;INPUT	OUTPUT
;A   B	A AND B
;0   0	   0
;0 	 1 	   0
;1 	 0	   0
;1 	 1 	   1
;-----------------------------------------------
	$split1 = StringSplit($bin,"")
	$split2 = StringSplit($bin2,"")
	For $i = 1 To StringLen($bin) Step 1
		; Pour la fonction AND si un ou l'autre est 0 le résultat est 0
		If $split1[$i] = 0  Or $split2[$i] = 0 Then
			$result &= 0
		; Si les deux sont à 1 alors le résultat est 1
		ElseIf $split1[$i] = $split2[$i] And $split1[$i] = 1 Then
			$result &= 1
		EndIf
	Next

;-----------------------------------------------
; Convert the Binary result to decimal number
;-----------------------------------------------
	$split = StringSplit($result, "")
	$x = $split[1]
	For $i = 1 To StringLen($result)-1 Step 1
		$x = $x * 2 + $split[$i+1]
	Next
	$result = $x
	Return $result
EndFunc

;--------------------------------------------------------------------------------------------
; Function _BitXOR
;Simulate the BitXOR function in AutoIt!
;--------------------------------------------------------------------------------------------
; Input		: 	Decimal number
;				Decimal Mask
; Output	: 	Decimal result
;--------------------------------------------------------------------------------------------
; Conversion Decimal to Binary for the first decimal number (Value)
; Conversion Decimal to Binary for the second decimal number (Mask)
; Reverse the Binary value
; Pad the shortest string with 0
; Gate XOR
; Convert the Binary result to decimal number
;--------------------------------------------------------------------------------------------
Func _BitXOR($arg1,$arg2)
	Local $bin = "", $bin2 = "", $result = ""

	$bin = _Dec2Bin($arg1)
	$bin2 = _Dec2Bin($arg2)
;-----------------------------------------------
; Reverse the Binary'3 String
; Before 	= 00000000000001011011001111010111
; After 	= 11101011110011011010000000000000
;-----------------------------------------------
	$bin  = _StringReverse($bin)
	$bin2 = _StringReverse($bin2)

;-----------------------------------------------
; Pad the shortest string with 0 based on the longest one
; EX: 	Before padding = 11111111111111111111111111111111
; 		After Padding  = 000000000011111111111111111111111111111111
;-----------------------------------------------
	If StringLen($bin) <> StringLen($bin2) Then
		If StringLen($bin) > StringLen($bin2) Then
			$add =""
			For $i = 1 To (StringLen($bin) - StringLen($bin2)) Step 1
				$add  &= 0
			Next
			$bin2 = $add & $bin2
		Else
			$add = ""
			For $i = 1 To (StringLen($bin2) - StringLen($bin)) Step 1
				$add  &= 0
			Next
			$bin = $add & $bin
		EndIf
	EndIf

;-----------------------------------------------
; Code de la fonction XOR
; Décortique les valeures binaires
; XOR Gate
;INPUT	OUTPUT
;A   B	A XOR B
;0   0	   0
;0 	 1 	   1
;1 	 0	   1
;1 	 1 	   0
;-----------------------------------------------
$split1 = StringSplit($bin,"")
$split2 = StringSplit($bin2,"")
For $i = 1 To StringLen($bin) Step 1
; Pour la fonction XOR si le chiffre est différent le résultat est 1
	If $split1[$i] <> $split2[$i] Then
		$result &= 1
	Else
		$result &= 0
    EndIf
Next

;-----------------------------------------------
; Convert the Binary result to decimal number
;-----------------------------------------------
	$split = StringSplit($result, "")
	$x = $split[1]
	For $i = 1 To StringLen($result)-1 Step 1
		$x = $x * 2 + $split[$i+1]
	Next
	$result = $x
	Return $result
EndFunc

;--------------------------------------------------------------------------------------------
; Function _Dec2Bin
; Decimal to binary conversion
;--------------------------------------------------------------------------------------------
; Input		: Decimal number
; Output	: Binary Number
;--------------------------------------------------------------------------------------------
; Convert by divisions
; Reverse the binary number
; Value Conversion (Decimal to Binary)
; Ex: Decimal = 3667563225088 to binary = 00000000000001011011001111010111 (inversed value)
;--------------------------------------------------------------------------------------------
Func _Dec2Bin($arg)
	Local $result = ""
	While($arg >= 1)
		$arg /= 2
		If StringIsDigit($arg) Then
			$result &= 0
		Else
			$split = StringSplit($arg, ".")
			$arg = $split[1]
			$result &= 1
		EndIf
	WEnd
	Return $result
EndFunc
