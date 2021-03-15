; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayTo2DArray
; Description ...: Reads the specified file into an array.
; Syntax.........: _ArrayTo2DArray(ByRef $sArray,  $Delimiter = @TAB, $Chunk_Size = 1000)
; Parameters ....: $sArray - 1D Array containing delimited text per element (such as TAB or ;)
;                  $Delimiter     - What string to split on;
;                  $Chunk_Size    - How many elements to iterate through before releasing the cache;
;									Choose a size that is big enough but does not take performance hit,
;								    If you set it too high then it will run slow; (essentially a cache size)
; Return values .: Success - Returns a 2D array delimited by delimiter parameter
;                  Failure - Returns a ""
;                  @Error  - 0 = No error.
;                  |1 = $aArray is not an array
; Author ........: DJKMan
; Remarks .......: $aArray[0] will contain the number of records read into the array.
; 				   To use this function, you must already have a 1D array, each element containing delimiters such as TAB
; Link ..........:
; Example .......: Yes
; TODO ..........: Use Timer Diff to automatically calculate optimum chunk size
; ===============================================================================================================================
Func _ArrayTo2DArray(ByRef $aArray, $Delimiter = @TAB, $Chunk_Size = 1000)
	If Not IsArray($aArray) Then Return SetError(1, 0, 0)

	ConsoleWrite("_ArrayTo2DArray() - Creating 2D Array...");Announce to the world you are creating something awesome
	Local $aFinal[1][1]
	$UBOUND_MAX = UBound($aArray) - 1;Store counts of how many array row elements there are in $aArray

	If $Chunk_Size < 1 Then $Chunk_Size = 1000;If User specifies a 0 or negative chunk size then set default



	$Final_Loop = False
	$Current_Row = 0
	$Start_Index = 0
	$CHUNK_SIZE_COUNTER = 0

	If $UBOUND_MAX < $Chunk_Size Then
		;Chunk size is larger than Ubound (only one loop needed)
		$Final_Loop = True
	EndIf

	ReDim $aFinal[UBound($aArray)][1];Resize to length of 1D beforehand to keep from performance hits

	While 1;Keep looping until max bound is reached

		For $Current_Index_Z = $Start_Index To UBound($aArray) - 1;Loop until it reaches EOF
			$CHUNK_SIZE_COUNTER += 1
			If $CHUNK_SIZE_COUNTER > $Chunk_Size Or $Current_Row > $UBOUND_MAX Then ExitLoop;If $Current_Index_Z reaches chunk size boundary then quit loop

			ConsoleWrite($Current_Index_Z & @CRLF);Uncomment to show how quickly it parses through the array..if it begins to slow down then choose a smaller chunk size

			$aSplit = StringSplit($aArray[$Current_Index_Z], $Delimiter, 3);Split on the delimiter

			If UBound($aFinal, 2) < UBound($aSplit) Then ReDim $aFinal[UBound($aFinal)][UBound($aSplit)];If there are more columns in text then create extra columns in array

			For $Current_Index_Y = 0 To UBound($aSplit) - 1
				$aFinal[$Current_Row][$Current_Index_Y] = $aSplit[$Current_Index_Y];Add all columns to array
			Next

			$Current_Row += 1;Keep track of current row of $aFinal since initialized array is full of blanks/also keep track of total progress
		Next
		$Start_Index = $Current_Row;Reset Start Index for next chunk size
		$CHUNK_SIZE_COUNTER = 0;Reset Chunk size tracker


		If $Final_Loop == True Then ExitLoop;Last chunk size parsed, reached end of array, exit loop

		If $Current_Row + $Chunk_Size < $UBOUND_MAX Then
			;Continue looping through next large chunk
			ContinueLoop
			$Final_Loop = False
		Else
			;Loop through the remaining elements smaller than or equal to the chunk size specified
			$Count = -1
			$Final_Loop = True
		EndIf
	WEnd
	ConsoleWrite("DONE" & @CRLF)

	Return $aFinal;Return your beautiful 2D array
EndFunc   ;==>_ArrayTo2DArray