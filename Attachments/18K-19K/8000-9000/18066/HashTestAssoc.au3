; HashTestAssoc.au3

AutoItSetOption("MustDeclareVars", True)

;Comment out one of the 2 includes to test the other
;#include "AssocArray3.au3";martin
#include "AssocArrays.au3";Nutster

Global $iCount, $iSize, $iSize1 = Number(InputBox("Number of keys to read/write", "number"))
Global $nTmp
Global $sName
Global $avArray
; Declarations added
Global $dif, $dif1, $dif2, $dif3, $tt, $dict, $val, $timer2, $test, $sValue
;======================================================
Global $knames[5] = ["dog", "canary", "bicycle", "radiator", "improvisation"  ]
$dict = ObjCreate("Scripting.Dictionary")
$dict.Add('kip', 87)
$tt = TimerInit()
For $i = 1 To $iSize1 - 1
	$dict.Add($knames[Mod($i, 5)] & $i, 'Value' & $i)
Next
$dif = TimerDiff($tt)
ConsoleWrite("Dictionary:  time to write " & $iSize1 & " = " & $dif & ', ')
$tt = TimerInit()
For $i = 1 To $iSize1 - 1
	$val = $dict.Item($knames[Mod($i, 5)] & $i)
Next
$dif1 = TimerDiff($tt)
ConsoleWrite("time to read " & $iSize1 & " = " & $dif1 & @LF)
AssocArrayCreate($avArray, $iSize1)   ; Create the associative array with storage for $iSize1 elements.
AssocArrayAssign($avArray, "kip", 87) 	; Just to make things fair.
$tt = TimerInit()
For $i = 1 To $iSize1 - 1
	If AssocArrayAssign($avArray, $knames[Mod($i, 5)] & $i, "Value" & $i) = False Then ExitLoop
Next
$dif2 = TimerDiff($tt)
ConsoleWrite("Hash Table:  time to write " & $iSize1 & " = " & $dif2 & ', ')
;======================================================
$tt = TimerInit()
For $i = 1 To $iSize1 - 1
	$val = AssocArrayGet($avArray, $knames[Mod($i, 5)] & $i)
Next
$dif3 = TimerDiff($tt)
ConsoleWrite("time to read " & $iSize1 & " = " & $dif3 & @LF)
$timer2 = TimerInit()

While 1
	$test = StringStripWS(InputBox("Element to find", "number"), 8)
	If $test = '' Then ExitLoop
	$test = $knames[Mod($test, 5)] & $test
	$sValue = AssocArrayGet($avArray, $test)
	If @error Then
		MsgBox(0, $test, "Unfound")
	Else
		MsgBox(0, $test, $sValue)
	EndIf
WEnd
;======================================================