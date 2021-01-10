#include-once

; #INDEX# =======================================================================================================================
; Title .........: Extended Array
; AutoIt Version : 3.2.10++ (not tested)
; Language ......: (Bad) English :=)
; Description ...: This module contains some functions to manipulating arrays.
; ===============================================================================================================================

; #NO_DOC_FUNCTION# =============================================================================================================
; Not documented - function(s) no longer needed, will be worked out of the file at a later date
; ===============================================================================================================================
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_ArrayCall
;_ArrayDiff
;_ArraySum
;_ArraySortWith
;_ArraySplice
;_ArraySlice
;_ArrayRand
;_ArrayShuffle
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
;__Array_Value_Exists
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayCall
; Description ...: Excutes a function of all items in a 1d and 2d array.
; Syntax.........: _ArrayCall(ByRef $avArray, $sFunction)
; Parameters ....: $avArray    - Array to use
;                  $sFunction  - Function to call
; Return values .: Success - 1 , sets @extend
;								| 1 - Used Call 
;								| 2 - Used Execute
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - $sFunction is not a string
;								| 3 - Call / Excute failed , $sFunction dont exist or parameters were incorect
;								| 4 - $avArray has more then 2 dimensions			
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......: _ArraySortWith , Call , Execute 
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
func _ArrayCall ( ByRef $avArray, $sFunction )
 	if not IsArray ( $avArray ) Then return SetError ( 1, 0, 0 		 
	if not isstring ( $sFunction ) Then return SetError ( 2, 0, 0)
		
	
	
	Local $key = "", $methode = 1, $avTmp
		
	dim $avTmp[ubound ($avArray)]
	
	switch ubound ( $avArray, 0 )
		
	case 1
		
		for $i = 0 to ubound ( $avArray ) -1
			
			$avTmp[$i] = Call (  $sFunction  , $avArray[$i] )
			if @error then 
				
				$methode = 2
				$avTmp[$i] = Execute ($sFunction  & "( $avArray[$i] )")
				if @error then return SetError (3 , @error, 0)
			EndIf	
				
		Next

	case 2
		
		redim $avTmp[UBound ($avArray )][UBound ($avArray,2)]
		
		for $i = 0 to UBound ( $avArray ) -1
			
				for $s = 0 to UBound ( $avArray , 2) -1
			
					$avTmp[$i][$s] = Call (  $sFunction , $avArray[$i][$s] )
			
					if @error then 
				
						$methode = 2
						$avTmp[$i][$s] = Execute ($sFunction  & "( $avArray[$i][$s] )")
						if @error then return SetError (3 , @error, 0)
					EndIf
				Next	
		Next
			
	case Else
			
		return SetError ( 4, 0 , 0  )
	
	EndSwitch
	
	
	$avArray = $avTmp ;we dont want to damge the wohle array if this function fails
return SetExtended ( $methode , 1)
EndFunc ;==>_ArrayCall

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayDiff
; Description ...: Returns an array with values, wich dont exist in $avArray2
; Syntax.........: _ArrayDiff(ByRef $avArray, ByRef $avArray2)
; Parameters ....: $avArray  - Array to check
;                  $avArray2 - Array to use
; Return values .: Success - Array with unqiue values
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - $avArray2 is not an array
;								| 3 - No unqiue value exist
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArrayDiff ( ByRef $avArray, ByRef $avArray2 )
	if not IsArray ( $avArray ) then return seterror ( 1 , 0 , 0 )
	if not IsArray ( $avArray2 ) then return seterror ( 2 , 0 , 0 )
	
	Local $iUbound = UBound ( $avArray ), $x = 0, $avTmp
	
	dim $avTmp[$iUbound]
	
	for $i = 0 to $iUbound -1
		
		if not __Array_Value_Exists ( $avArray2 , $avArray[$i] ) Then
			$avTmp[$x] = $avArray[$i]
			$x += 1
		EndIf
	Next
	if $x = 0 then Return SetError ( 3 ,0, 0)

	redim $avTmp[$x]
	
	return $avTmp		
EndFunc ;==>_ArrayDiff

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySum
; Description ...: Returns all numeric values added
; Syntax.........: _ArrayDiff(ByRef $avArray, [$iNumbersAsString])
; Parameters ....: $avArray 		 - Array to use
;                  $iNumbersAsString - [optional] Add numerical strings too
; Return values .: Success - the result , could be 0 so check for @error
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - No Numbers found
;								| 3 - $avArray has more then 1 Dimension
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......: IsInt, IsFloat, StringIsFloat, StringIsInt, Number
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArraySum ( ByReF $avArray , $iNumbersAsString = 0 )

	;check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 3, 0, 0)
	
	Local $iUbound = ubound ( $avArray ) -1, $fSum = 0, $iNumber = 0
	
	
	for $i=0 to $iUbound
		$vTmp = $avArray[$i]
		
		;normal check if is integer or float
		if isint ( $vTmp ) or IsFloat ( $vTmp ) Then
			$iNumber = 1 ; means a number was found, so no error code 2
			$fSum += $vTmp ;add them 
		else 
			;if use Numbers as datatype "string" and is number vTmp
			if  $iNumbersAsString and  ( StringIsFloat ( $vTmp ) or StringIsInt ( $vTmp ) ) and isstring ( $vTmp ) Then
				$iNumber = 1
				$fSum += Number ($vTmp) ; convert in a Number
			EndIf	
		
		EndIf
		
	Next	
	
	;no numbers in array
	if $iNumber = 0 then return SetError ( 2 , 0 , 0)
return $fSum
EndFunc	;==>_ArraySum		
	
; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySortWith
; Description ...: Sorts an array with a defined Function
; Syntax.........: _ArraysSortWith(ByRef $avArray, $sFunction, [$avParameter = 0[, $sFirstValueAlias = "$mFirstValue"[, $sSecondValueAlias = "$mSecondValue"]]])
; Parameters ....: $avArray 		 - Array wich will be sorted
;                  $sFunction 		 - Function to use ( must return somthing like -1, 0, +1; like StringCompare)
;				   $avParameter		 - [optional] Array to use if Paramters must be specifed ( They value with the value of $sFirstValueAlias 
;										will be replaced with the first value for sorting; with $sSecondValueAlias its the same)
;				   $sFirstValueAlias - [optional] A key with this value in $avParameter will be replaced with the first value to compare
;				   $sSecondValueAlias- [optional] The second value to compare
;					
; Return values .: Success - 1, sets @extended to
;								| 1 - Used Call
;								| 2 - Used Excute
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - Call and Execute failed
;								| 3 - The return of $sFunction was incorrect
;								| 4 - $sFirstValueAlias or $sSecondValueAlias dont exist in the $avParameter array
;								| 5 - $avArray has more then 1 dimesion
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......: _ArrayCall, _ArraySort, Call, Execute, StringCompare
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArraySortWith ( ByRef $avArray , $sFunction, $avParameter = 0, $sFirstValueAlias = "$mFirstValue", $sSecondValueAlias = "$mSecondValue")
	;check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 5, 0, 0)

	Local $iUbound = ubound ( $avArray ) - 1, $c = 0 , $methode = 1, $iFirstValuePos = -1 , $iSecondValuePos = -1 , $sArgString = "", $iUseArgArray = 0, $avArgArray
	
	;check if parameter
	if isarray ( $avParameter ) Then
		
		for $i= 0 to ubound ( $avParameter ) -1
			
			if $avParameter[$i] == $sFirstValueAlias then 
				$iFirstValuePos = $i + 1
			EndIf
			
			if $avParameter[$i] == $sSecondValueAlias then 
				$iSecondValuePos = $i + 1
			EndIf
		$sArgString &=  "$avArgArray[" & $i +1 & "], "
		Next
			$sArgString = StringTrimRight ($sArgString, 2)
	
		if  $iFirstValuePos == -1 or $iSecondValuePos == -1  then return SetError ( 4 , 0, 0)
		
		dim $avArgArray[1]
		$avArgArray[0] = "CallArgArray"
		redim $avArgArray[1 + UBound ( $avParameter )]
		for $i = 0 to ubound ($avParameter) -1
			$avArgArray[$i+1] = $avParameter[$i]
		Next
		
		$iUseArgArray = 1
	EndIf
				
		
	for $i = 1 to $iUbound 
		
		$vTmp = $avArray[$i

			for $j = $i -1 to 0 step -1
				$vCur = $avArray[$j]
				
				
				if $iUseArgArray Then
					
					$avArgArray[$iFirstValuePos] = $vTmp
					$avArgArray[$iSecondValuePos] = $vCur
					
					$c = call ( $sFunction, $avArgArray )
					
					if @error then 
						
						$methode = 2
						$c = Execute ( $sFunction & "(" & $sArgString & ")" )
						if @error then 
							return SetError ( 2 , 0 ,0 )
						EndIf
					EndIf
				Else		
				;try to use call 
				$c = call ( $sFunction , $vTmp , $vCur)
				
					if @error Then 
					; mhm dont work maybe its an built-in AutoIt function or plug-in function (see Call Function Reference) so try with Execute
						$methode = 2
						$c = Execute ( $sFunction & '( "' & $vTmp & '", "' & $vCur & '")' ) 
							if @error then 
								return SetError ( 2 , 0 , 0 ) ;the function really dont exist or dont have enough paramters
							EndIf
					EndIf
				EndIf
				
				if not isint ( $c ) Then return SetError ( 3 , 0 , 0) ; check if is int and not something else ( the function must return 0 , +1, -1 usw, like StringCompare () )
				
				if $c >= 0 then ExitLoop
				$avArray[$j + 1] = $vCur
			Next
		
	$avArray[$j + 1] = $vTmp
	Next				
		

return SetExtended ( $methode , 1 )
EndFunc ;==>_ArraySortWith

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySplice
; Description ...: Delets a Defined Range of an array
; Syntax.........: _ArraySplice(ByRef $avArray, $iStart[, $iEnd=-1])
; Parameters ....: $avArray 	- Array to edit
;                  $iStart 		- Where to start deleting
;				   $iEnd		- [optional] Where to end deliting (default: at end of array)
;					
; Return values .: Success - New array size
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - The array would be the same like before
;								| 3 - $iStart is greater than $iEnd
;								| 4 - $avArray has more then 1 dimension
;
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......: _ArraySlice
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArraySplice (ByRef $avArray , $iStart, $iEnd=-1)
	;check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 4, 0, 0)	
	
	Local $iUbound = UBound ( $avArray ) -1, $s = 0
	
	;bound checking
	if $iStart > $iUbound or $iStart < 0 then $iStart = 0
	if $iEnd + 1 > $iUbound or $iEnd < 0  then $iEnd = $iUbound

	;seterror because there wont be any change in the array
	if $iStart == 0 and $iEnd == $iUbound then Return SetError (2, 0, 0)
	
	;logic mistake of user ^^
	if $iStart > $iEnd then Return SetError (3, 0, 0)
	
	$s = $iStart
	for $i = $iEnd +1 to $iUbound 
		
		$avArray[$s] = $avArray[$i]
		$s += 1
	Next
	
	redim $avArray[$iUbound - ( $iEnd - $iStart )]

Return  $iUbound - ( $iEnd - $iStart ) ; return new array size

EndFunc ;==>_ArraySlice

; #FUNCTION# ====================================================================================================================
; Name...........: _ArraySlice
; Description ...: Returns a specified range of an array 
; Syntax.........: _ArraySlice(ByRef $avArray, $iStart[, $iEnd=-1])
; Parameters ....: $avArray 	- Array to use
;                  $iStart 		- Where to start
;				   $iEnd		- [optional] Where to end (default: at end of array)
;					
; Return values .: Success - The Array
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - $iStart is greater then $iEnd
;								| 3 - $Start is the same like $iEnd ( idiot: use $avArray[$iStart] or $avArray[$iEnd] )
;								| 4 - $avArray has more then 1 dimension
;
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......: _ArraySplice
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArraySlice ( ByRef $avArray , $iStart, $iEnd=-1)
	;check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 4, 0, 0)
	
	Local $iUbound = UBound ( $avArray ) -1, $iCount = $iUbound, $x = 0, $avTemp
	
	;creat $avTemp
	Dim $avTemp[$iUbound] 
	;bounds checking
	if $iStart > $iUbound or $iStart < 0 then $iStart = 0
	if $iEnd > $iUbound or $iEnd < 0  then $iEnd = $iUbound
	
	;mhm i love this very clever users
	if $iStart > $iEnd then Return SetError ( 2,0,0 )
	if $iStart == $iEnd then Return SetError ( 3, 0,0 )
	
	;easy :)
	if $iStart == 0 and $iEnd = $iUbound then Return $avArray
	
	$iCount = $iEnd - $iStart
		
		
		for $i = $iStart to $iEnd
			$avTemp[$x] = $avArray[$i]
			$x += 1
		Next
	
	redim $avTemp[$iCount+1]
	
 return $avTemp ; return slice and dont change avArray for this use _ArraySplice
EndFunc ;==>_ArraySlice

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayRand
; Description ...: Returns random keys of an array
; Syntax.........: _ArrayRand(ByRef $avArray[, $iNum=1])
; Parameters ....: $avArray 	- Array to use
;                  $iNum		- Number of random keys if 1 then only a int key will return and not an array
;					
; Return values .: Success - An array with random keys or a integer key.
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - $avArray has more then 1 dimension
;
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArrayRand ( ByRef $avArray , $iNum = 1)
	;check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 2, 0, 0)
	
	Local $iUbound = UBound ( $avArray ), $avNumbers
	
	; check if iNum is not negative and not more then array size
	if $iNum < 1 then $iNum = 1
	if $iNum > $iUbound  then $iNum = $iUbound 
		
	if $iNum == 1 Then
		return random ( 0 , $iUbound , 1 ) ;easy only return a radnom key bewtwen 0 and the max array size ( ubound ( $avArray) -1 )
	Else
		Dim $avNumbers[$iNum] ; creat array to hold the random numbers
		for $i=1 to $iNum 
			do 
				$iNumber = Random ( 0 , $iUbound-1 , 1 ) ;select random index number
			Until __Array_Value_Exists ( $avNumbers , $iNumber ) == 0 ;check if not allready in $avNumbers
			$avNumbers[$i-1] = $iNumber ; add to array -1, because whe started with $i = 1
		Next
		return $avNumbers ;return array with the random numbers
	EndIf
EndFunc ;==>_ArrayRand

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayShuffle
; Description ...: Shuffle an Array
; Syntax.........: _ArrayShuffle(ByRef $avArray)
; Parameters ....: $avArray 	- Array to use
;                				
; Return values .: Success - 1
;                  Failure - 0, sets @error to 
;								| 1 - $avArray is not an array
;								| 2 - $avArray has more then 1 dimension
;
; Author ........: Tom Schuster <Tom---Schuster at web dot de>
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........;
; Example .......; No
; ===============================================================================================================================
func _ArrayShuffle ( ByRef $avArray )
	; check if array
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	if ubound ( $avArray , 0) <> 1 then Return SetError ( 2, 0, 0)
	
	Local $iUbound = UBound ( $avArray ), $avTmp
	
	;creat tmp array with double size of $avArray
	dim $avTmp[$iUbound*2] 
	
	$iUboundTemp = UBound (  $avTmp   )
	
	for $i = 0 to $iUbound -1
		Do
			$iNumber = Random ( 0 , $iUboundTemp-1, 1 ) ; creat random key 
		Until stringleft ( $avTmp[$iNumber], 1 ) <> chr ( 1 ) ; if $avTmp[$iNumber] is empty (unassigned) Then
		$avTmp[$iNumber] = chr ( 1 ) & $avArray[$i] ;add $avArray[$i] with ascii character 1 , because the $avArray[$i] could be empty
	Next
	
	$x = 0
	
	for $i=0 to $iUbound * 2 - 1
		
		if StringLeft ( $avTmp[$i], 1 )  == chr ( 1 ) Then ; check if not empty
			$avArray[$x] = StringTrimLeft ($avTmp[$i], 1) ;remove leading chr (1)  
			$x += 1	;increment $avArray index to use
		EndIf
		
	Next
	
Return 1
EndFunc ;==>_ArrayShuffle

; #INTERNAL_USE_ONLY#============================================================================================================
; Name...........: __Array_Value_Exists
;================================================================================================================================
func __Array_Value_Exists ( ByRef $avArray , $vValue )
	If Not IsArray($avArray) Then Return SetError(1, 0, 0)
	
	Local $iUbound = UBound ( $avArray ) -1, $iMatchs = 0
	
	for $i=0 to $iUbound
		if $avArray[$i] == $vValue then 
			$iMatchs += 1
		EndIf
	Next
	
	return $iMatchs
EndFunc ;==>__Array_Value_Exists