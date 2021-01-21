#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.10.0
	Author:         "Nutster" David Nuttall
	
	Script Function:
	Sorting UDF's testing routine.
	
#ce ----------------------------------------------------------------------------

AutoItSetOption("MustDeclareVars", True)

#include "Sorts.au3"

Global $aFull[1000]
Global $I, $sMsg
; Not included:  "Bozo", "Stooge", "OptBozo" ; Poor Sorts (if used, keep the count low!)
Global $sSorts[11] = [ _
		"Bubble", "Cocktail", "Selection", "Gnome", "Insertion", "BinInsert", "Comb", "Shell", _ ; O(n²) sorts
		"Heap", "Merge", "Quick"]	; O(n log n) sorts
Global $timers[UBound($sSorts)]

;Generate the random number sequence
For $I = 0 To UBound($aFull) - 1
	$aFull[$I] = Random(0, 9999, True)
;~ 	$aFull[$I] = -Random(0, 9999, True) ; This is used to generate a list in reverse order
;~ 	$aFull[$I] = 17	; Test what happens when all elements are the same.
Next

; This tests what happens with a pre-sorted list
;~ _Sort_Heap($aFull)

$sMsg = "Original:  " & $aFull[0]
$aFull[0] = Abs($aFull[0])
For $I = 1 To UBound($aFull) - 1
	$aFull[$I] = Abs($aFull[$I])
	$sMsg &= ", " & $aFull[$I]
Next
;MsgBox(64, "Sort Test", $sMsg)

; Add a progress bar
ProgressOn("Sort Test", "Processing sorting functions", "", Default, Default, 16)

For $I = 0 To UBound($sSorts) - 1
	TestFunction($sSorts[$I], $I)
Next

ProgressOff()

$sMsg = "Relative Timings (ms) on " & UBound($aFull) & " elements:" & @CRLF
For $I = 0 To UBound($sSorts) - 1
	$sMsg &= $sSorts[$I] & " Sort: " & $timers[$I] & @CRLF
Next
MsgBox(64, "Sort Test", $sMsg)

Func TestFunction(Const $sName, Const $nIndex, Const $nFlags = 0)
	Local $aSorted = $aFull ; Linked for speed?
	Local $t1
	
	; Flags: (binary - OR them together)
	; 0 - Nothing special
	; 1 - Display results
	; 2 - Display failure
	
	$aSorted[0] = $aFull[0] ; Needed to cause the array to be copied, not linked. :(
	ProgressSet($nIndex / UBound($timers) * 100, $sName & " Sort")
	$t1 = TimerInit()
	If Execute("_Sort_" & $sName & "($aSorted)") Then
		$timers[$nIndex] = Round(TimerDiff($t1))
		$sMsg = $sName & " Sorted:  " & $aSorted[0]
		For $I = 1 To UBound($aSorted) - 1
			$sMsg &= ", " & $aSorted[$I]
			If $aSorted[$I - 1] > $aSorted[$I] Then
				$timers[$nIndex] = "OUT OF SEQUENCE!"
			EndIf
		Next
		$sMsg &= @CRLF & " Time taken (ms): " & $timers[$nIndex]
		If BitAND($nFlags, 1) Then
			MsgBox(64, "Sort Test", $sMsg)
		EndIf
	Else
		$timers[$nIndex] = "FAILED!"
		If BitAND($nFlags, 2) Then
			MsgBox(48, "Sort Test", $sName & " Sort failed!")
		EndIf
	EndIf
EndFunc   ;==>TestFunction

Func Iif(Const $bComparison, Const $vTrue, Const $vFalse)
	If $bComparison Then
		Return $vTrue
	Else
		Return $vFalse
	EndIf
EndFunc   ;==>Iif