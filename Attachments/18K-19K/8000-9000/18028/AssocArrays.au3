#cs ----------------------------------------------------------------------------
	
	AutoIt Version: 3.2.9.14 (beta)
	Author:         David Nuttall
	
	Script Function:
	Associative Array functionality
	
#ce ----------------------------------------------------------------------------

#include-once
Const $gbAA_Debug = False

#cs
	Function:  AssocArrayCreate
	Purpose:  Create an associative array in a variable.
	Parameters:
	$aArray:  The variable to have an associative array create in it.
	$nSize:  The starting size of the new array
	$nGrowth:  The percentage of current size to grow the array when needed.  If 0, no growth happens.  30 = 30% growth each time.
	Return value:  True if the associative array could be created; False otherwise
	Notes:
#ce
Func AssocArrayCreate(ByRef $aArray, Const $nSize, Const $nGrowth = 50)
	If IsNumber($nSize) = 0 Then
		; Need a number here
		Return False
	ElseIf $nSize < 1 Then
		; Too small
		Return False
	Else
		Local $nHashSize = Ceiling($nSize * 1.25) + 1	; Hash table should start about 25% larger than expected number of elements
		
		While NotPrime($nHashSize) 	; Hash tables usually operate best when a prime number of elements are present
			$nHashSize += 1
		WEnd
		Local $aTmp[2][$nHashSize + 1]
		$aArray = $aTmp
		$aArray[0][0] = 0	; Active array size
	EndIf
	If IsNumber($nGrowth) = 0 Then
		; Need a number here
		Return False
	ElseIf $nGrowth < 0 Then
		; Too small
		$aArray[1][0] = 0
	Else
		$aArray[1][0] = $nGrowth / 100.0
	EndIf
	Return True
EndFunc   ;==>AssocArrayCreate

#cs
	Function:  AssocArrayAssign
	Purpose:  Assign a value to an element of an associative array.
	Parameters:
	$aArray:  The array containing an associative array
	$sKey:  The key value in the array
	$vValue:  The value to assign to the element of the associtive array
	Return value:  True if the value could be assigned; False otherwise
	Notes:  This uses a hash table with open addressing using linear probing.
	There is probably a faster way to resize a hash table than I use here.
	It grows the array if hash key collisions occur more than 3 times in a row or
	hash key collisions push the assignment off the end of the array.
#ce
Func AssocArrayAssign(ByRef $aArray, Const $sKey, Const $vValue)
	Local $nPos = HashPos($sKey, UBound($aArray, 2) - 1) + 1
	Local $nCollide = 0
	Global $gbAA_Resizing = False
	
	If $gbAA_Debug Then ConsoleWrite("AssocArrayAssign:  UBound = " & UBound($aArray, 2) & ", $nPos = " & $nPos & ", $sKey = " & $sKey & ", $vValue = " & $vValue & @CR)
	While $nPos < UBound($aArray, 2)
		Switch $aArray[0][$nPos]
			Case ""
				; Not found.  Fill it in
				$aArray[0][$nPos] = $sKey
				$aArray[1][$nPos] = $vValue
				$aArray[0][0] += 1
				If $gbAA_Debug Then ConsoleWrite("AssocArrayAssign:  Used = " & $aArray[0][0] & ", After collisions $nPos = " & $nPos & @CR)
				Return True
			Case $sKey
				; Found the correct key
				$aArray[1][$nPos] = $vValue
				If $gbAA_Debug Then ConsoleWrite("AssocArrayAssign:  Used = " & $aArray[0][0] & ", After collisions $nPos = " & $nPos & @CR)
				Return True
			Case Else
				; Key collision
				$nPos += 1
				$nCollide += 1
				If $nCollide > 3 Then ExitLoop
		EndSwitch
	WEnd
	; Not found, at end of array or too many collisions
	If $gbAA_Resizing Then
		; If already in a resize cycle, abort due to cascading resizes.
		MsgBox(48, "AssocArrayAssign", "Cascading resize caused by poor hash function.  Aborting.  Revise hash function and retry.")
		Exit
	Else
		$gbAA_Resizing = True
	EndIf
	
	; Grow the array, reassign the values and try again.
	Local $nHashSize = Ceiling(UBound($aArray, 2) * (1 + $aArray[1][0]))
	Local $I

	While NotPrime($nHashSize)
		$nHashSize += 1
	WEnd

	If $gbAA_Debug Then ConsoleWrite("AssocArrayAssign:  Used = " & $aArray[0][0] & ", After collisions $nPos = " & $nPos & ".  Resizing to " & $nHashSize & @CR)

	Local $aTmp[2][$nHashSize + 1]	; New size
	$aTmp[0][0] = 0	; Active array size
	$aTmp[1][0] = $aArray[1][0]	; Copy the growth rate
	
	AssocArrayAssign($aTmp, $sKey, $vValue) 	; Assign the value that got us here in the first place
	; Assign the old values
	For $I = 1 To UBound($aArray, 2) - 1
		If $aArray[0][$I] > "" Then
			AssocArrayAssign($aTmp, $aArray[0][$I], $aArray[1][$I])
		EndIf
	Next
	$aArray = $aTmp
	$gbAA_Resizing = False
	Return True
EndFunc   ;==>AssocArrayAssign

#cs
	Function:  AssocArrayGet
	Purpose:  Get the value of an element in an associative array.
	Parameters:
	$aArray:  The array containing an associative array
	$sKey:  The key value in the array
	Return value:  Value in the element if found.  Otherwise, sets @Error to 1
	Notes:  This uses a hash table, which is pretty fast.  It could be replaced with another fast search method.
#ce
Func AssocArrayGet(ByRef Const $aArray, Const $sKey)
	Local $nPos = HashPos($sKey, UBound($aArray, 2) - 1) + 1
	
	While $nPos < UBound($aArray, 2)
		Switch $aArray[0][$nPos]
			Case ""
				; Not found
				SetError(1)
				Return False
			Case $sKey
				; Got it
				Return $aArray[1][$nPos]
			Case Else
				$nPos += 1
		EndSwitch
	WEnd
	; Not found at end of array
	SetError(1)
	Return False
EndFunc   ;==>AssocArrayGet

#cs
	Function:  NotPrime
	Purpose:  Determine if a number is not prime.  Support function for hash table.
	Parameters:
	$nValue:  The value to test for prime.
	Return value:  True if number is not prime.  False if prime.  Sets @Error to 1 if not an integer.
	Notes:
#ce
Func NotPrime(Const $nValue)
	Local $nTest
	
	If StringIsInt($nValue) = 0 Then
		Return False
	ElseIf $nValue < 2 Then
		; Lowest prime is two.  Smaller numbers do not qualify.
		Return True
	EndIf
	For $nTest = 2 To Int(Sqrt($nValue))
		If Round(Mod($nValue, $nTest)) = 0 Then
			; Has a factor of $nTest.  Composite!
			Return True
		EndIf
	Next
	Return False	; Is Prime
EndFunc   ;==>NotPrime

#cs
	Function:  HashPos
	Purpose:  Give the position to look for the given key in the hash table.
	Parameters:
	$sKey:  The key value in the hash table
	$nSize:  The size of the hash table to work with.
	Return value:  The hash table position determined from the given key.
	Notes:  Based on Jenkins One at a time hash (see http://en.wikipedia.org/wiki/Hash_table,
	                                               )
#ce
Func HashPos(Const $sKey, Const $nSize)
	Local $nPos = 0, $I
	
	For $I = 1 To StringLen($sKey)
		$nPos += Asc(StringMid($sKey, $I, 1))
		$nPos += _UBitShift($nPos, -10)
		$nPos = BitXOR($nPos, _UBitShift($nPos, 6))
	Next
	$nPos += _UBitShift($nPos, -3)
	$nPos = BitXOR($nPos, _UBitShift($nPos, 11))
	$nPos += _UBitShift($nPos, -15)
	$nPos = Round(Mod(Abs($nPos), $nSize))
	Return $nPos
EndFunc   ;==>HashPos

#cs
	Function:  _UBitShift
	Purpose:  Perform an unsigned bit shift
	Parameters:
	$nValue:  The value to be shifted
	$nShift:  The number of bits to shift
	Return value:  The shifted value
	Notes:  Found on http://www.autoitscript.com/forum/index.php?showtopic=58982 and used without permission.  ;)
#ce
Func _UBitShift($nValue, $nShift)
	; Check for the sign bit.
	Local $bSignBit = False
	
	If BitAND($nValue, 0x80000000) Then
		; Sign bit found, unset it.
		$nValue = BitXOR($nValue, 0x80000000)
		$bSignBit = True
	EndIf
	; Do a signed shift with the sign bit unset.
	$nValue = BitShift($nValue, $nShift)
	; Check to see if the former sign bit needs set.
	If $nShift > 0 And $nShift < 32 And $bSignBit Then $nValue = BitOR($nValue, 2 ^ (31 - $nShift))
	Return $nValue
EndFunc   ;==>_UBitShift
; ====================================================================================================