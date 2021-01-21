; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1
; Author:         Mike Ratzlaff <mratzlaff@pelco.com>
;
; Script Function:
;	Functions for dealing with bit-flags
;
; ----------------------------------------------------------------------------

; Note: This file is a work in progress and is not released as complete

#include <Math.au3>

Global Const $gFlagMask = _FlagSetup()

;Returns an array of 32 2-based powers
Func _FlagSetup()
	Local $i, $sTemp = 1
	For $i = 1 to 32
		$sTemp = $sTemp & ',' & 2 ^ $i
	Next
	Return StringSplit($sTemp,',')
EndFunc

;Checks to sett if flag $FlagNum is set in $Flags
Func _FlagGet($Flags, $FlagNum)
	Return BitAND($Flags, $gFlagMask[$FlagNum]) <> 0
EndFunc

;Returns a string based on given flags
Func _FlagToString($Flags, $True = '1', $False = '0')
	Local $i, $sOut = ''
	For $i = 1 to 32
		If _FlagGet($Flags, $i) Then
			$sOut = $sOut & $True
		Else
			$sOut = $sOut & $False
		EndIf
	Next
	Return $sOut
EndFunc

;Returns an array based on given flags
Func _FlagToArray($Flags)
	Return StringSplit(_FlagToString($Flags),'')
EndFunc

;Sets flag $FlagNum in $Flags, returns new flags
;The $Set parameter can be used to make this function clear instead of set a flag
Func _FlagSet($Flags, $FlagNum, $Set = 1)
	If $Set Then
		Return BitOR($Flags, $gFlagMask[$FlagNum])
	Else
		Return BitAND($Flags, BitNOT($gFlagMask[$FlagNum]))
	EndIf
EndFunc

;Sets flag $FlagNum in $Flags
;The $Set parameter can be used to make this function clear instead of set a flag
Func _FlagSetInPlace(ByRef $Flags, $FlagNum, $Set = 1)
	If $Set Then
		$Flags = BitOR($Flags, $gFlagMask[$FlagNum])
	Else
		$Flags = BitAND($Flags, BitNOT($gFlagMask[$FlagNum]))
	EndIf
EndFunc

;Clears flag $FlagNum in $Flags, returns new flags
Func _FlagClear($Flags, $FlagNum)
	Return BitAND($Flags, BitNOT($gFlagMask[$FlagNum]))
EndFunc

;Clearss flag $FlagNum in $Flags
Func _FlagClearInPlace(ByRef $Flags, $FlagNum)
	$Flags = BitAND($Flags, BitNOT($gFlagMask[$FlagNum]))
EndFunc

;Returns a set of flags based on the given string.  Any characters from $ZeroChars are cleared flags, all others are set
Func _FlagFromString($String, $ZeroChars = '0 ')
	Local $i, $j, $top = _Min(32, StringLen($String)), $Flags = 0
	For $i = 1 to $Top
		If Not StringInStr($ZeroChars, StringMid($String, $i, 1)) Then $Flags = _FlagSet($Flags, $i)
	Next
	Return $Flags
EndFunc
