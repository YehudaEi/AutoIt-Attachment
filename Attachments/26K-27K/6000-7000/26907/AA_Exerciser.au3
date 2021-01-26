#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.3.0.0
	Author:         David Nuttall
	
	Script Function:
	Test application for Associative array system
	
#ce ----------------------------------------------------------------------------

AutoItSetOption("MustDeclareVars", 1)

#include "AssocArrays.au3"

Global $iCount, $iSize
Global $nTmp
Global $sName
Global $avArray, $avNoGrow, $asKeys

AssocArrayCreate($avArray, 10) ; Create the associative array with storage for 10 elements.
AssocArrayCreate($avNoGrow, 20, 0) ; Create an associative array For 20 elements, that should Not grow.

MsgBox(0, "AssocArray Test", "The hash table has " & UBound($avArray, 2) - 1 & " locations.")

AssocArrayAssign($avArray, "Test1", 10000)
AssocArrayAssign($avArray, "Test2", 7e3)
AssocArrayAssign($avArray, "Test3", 1.5e2)

; I am using 20 elements here to force a growth cycle.  Actual arrays should be sized to the expected number of elements.
For $iCount = 1 To 20
	; Generate random key names
	$sName = ""
	For $iSize = 1 To Random(1, 10, True)
		$sName &= Chr(Random(65, 90, True))
	Next
	$nTmp = Random(1, 1000, True)
	ConsoleWrite("Assigning " & $nTmp & " to element '" & $sName & "'" & @CR)
	; If I can not assign, drop out.
	If Not AssocArrayAssign($avArray, $sName, $nTmp) Then ExitLoop
	If Not AssocArrayAssign($avNoGrow, $sName, $nTmp) Then ExitLoop
Next

$nTmp = AssocArrayGet($avArray, "Test2")
If @error = 0 Then
	MsgBox(64, "AssocArray Test", "The element 'Test2' has value " & $nTmp)
Else
	MsgBox(48, "AssocArray Test", "The element 'Test2' is not found!")
EndIf
$nTmp = AssocArrayGet($avArray, "Test3")
If @error = 0 Then
	MsgBox(64, "AssocArray Test", "The element 'Test3' has value " & $nTmp)
Else
	MsgBox(48, "AssocArray Test", "The element 'Test3' is not found!")
EndIf
$nTmp = AssocArrayGet($avArray, "Test1")
If @error = 0 Then
	MsgBox(64, "AssocArray Test", "The element 'Test1' has value " & $nTmp)
Else
	MsgBox(48, "AssocArray Test", "The element 'Test1' is not found!")
EndIf
$nTmp = AssocArrayGet($avArray, "Test4") ; Not assigned, even by random keys.  Should not be found.
If @error = 0 Then
	MsgBox(64, "AssocArray Test", "The element 'Test4' has value " & $nTmp)
Else
	MsgBox(48, "AssocArray Test", "The element 'Test4' is not found!")
EndIf

; Should be reading AssocArray... functions, not reading the array directly.
MsgBox(64, "AssocArray Test", "The hash table has " & UBound($avArray, 2) - 1 & " locations.  " & $avArray[0][0] & " elements are used.")

$asKeys = AssocArrayKeys($avArray)

$sName = ""
For $iCount = 0 To UBound($asKeys) - 1
	$sName &= "[" & $asKeys[$iCount] & "] = " & AssocArrayGet($avArray, $asKeys[$iCount]) & @CR
Next
MsgBox(64, "AssocArray Test", $sName)

; Test AssocArrayDelete.
If AssocArrayDelete($avArray, "Test3") Then
	MsgBox(64, "AssocArray Test", "The element 'Test3' was deleted.")
Else
	MsgBox(48, "AssocArray Test", "The element 'Test3' could not be deleted.")
	Exit
EndIf
$nTmp = AssocArrayGet($avArray, "Test3") ; Removed.  Should not be found
If @error = 0 Then
	MsgBox(64, "AssocArray Test", "The element 'Test3' has value " & $nTmp)
Else
	MsgBox(48, "AssocArray Test", "The element 'Test3' is not found!")
EndIf
; Test AssocArrayExists
If AssocArrayExists($avArray, "Test2") Then
	MsgBox(64, "AssocArray Test", "The element 'Test2' exists.")
Else
	MsgBox(48, "AssocArray Test", "The element 'Test2' is not found!")
EndIf
If AssocArrayExists($avArray, "Test4") Then
	MsgBox(64, "AssocArray Test", "The element 'Test4' exists.")
Else
	MsgBox(48, "AssocArray Test", "The element 'Test4' is not found!")
EndIf

Const $sFilename = @ScriptDir & "\AssocArrayTest.txt"

AssocArraySave($avArray, $sFilename)

; Wipe out the old associative array.
$avArray = ""

Switch AssocArrayLoad($avArray, $sFilename)
	Case True
		MsgBox(64, "AssocArray Test", "Reloaded array.  The hash table has " & UBound($avArray, 2) - 1 & " locations.  " & $avArray[0][0] & " elements are used.")
		$sName = ""
		For $iCount = 1 To UBound($avArray, 2) - 1
			If $avArray[0][$iCount] > "" Then
				$sName &= "[" & $avArray[0][$iCount] & "] = " & $avArray[1][$iCount] & @CR
			EndIf
		Next
		MsgBox(64, "AssocArray Test", $sName)
	Case False
		MsgBox(48, "AssocArray Test", "@Error = " & @error)
EndSwitch

If FileRecycle($sFilename) Then
	; File was recycled.  Good!
ElseIf FileDelete($sFilename) Then ; Could not recycle, so let's try deleting.  Probably the partition has no recycle bin.
	; File was deleted.  Okay.
Else
	; Could not delete.  Probably read-only (How?)
	MsgBox(48, "AssocArray Test", "Could not recycle nor delete '" & $sFilename & "'.  Please manually delete.")
EndIf