#comments-start
Script's data:
	Name:		CheckBin
	Version:	0.01
	Date:		15 may 2.011
Script's author
	Name:		Detefon
	e-mail:		herbivoro@ig.com.br

This script check if $Inside is contained in $Binary.
17 = 1 + 16
_CheckBin(17,15)	= 0
_CheckBin(17,1)		= 1
_CheckBin(17,3)		= 0
_CheckBin(17,16)	= 1


#comments-end
#include <Array.au3>
ConsoleWrite(_CheckBin(17,15))

Func _CheckBin($Binary,$Inside)
	Dim $BinTable[1]
	Local $BinOriginal, $BinTable
	If $Binary <0 or $Inside<0 Then Return 0
	If $Inside > $Binary Then Return 0

	$BinRest=1
	$BinExp = 0
	$BinarioString=""

While $Binary >0.5
	$BinRest = _Rest($Binary,2)
	$Binary = int($Binary/2)
	$BinString = $BinarioString & $BinRest
	ReDim $BinTable[$BinExp+1]
	
	IF $BinRest = 1 Then
		$BinOriginal = $BinOriginal + 2^($BinExp)
		$BinTable[$BinExp] = 2^($BinExp)
	Endif

	$BinExp = $BinExp + 1
WEnd

_ArraySearch($BinTable, $Inside, 0, 0, 0, 0,0)
	If @error Then
		Return 0
	Else
		Return 1
	EndIf
EndFunc		; _CheckBin()

Func _Rest($Dividend,$Divider)
	Return (($Dividend / $Divider)-int(($Dividend / $Divider)))*2
EndFunc		; _Rest()