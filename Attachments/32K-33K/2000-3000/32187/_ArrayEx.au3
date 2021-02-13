; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayToStringEx
; Description ...: Creates a string from an array regardless of dimension count
; Syntax.........: _ArrayToStringEx(Const ByRef $aSource[, $sDelim = "|"])
; Parameters ....: $aSource - Array to convert
;                  $sDelim  - [Optional] Delimiter for converted string. Make sure this is something unique. Can not be a comma, number, of fully numeric string.
; Return values .: Success - String which combined selected elements separated by the delimiter string, and the dimension sisez in the first element, seperated by a comma.
;                  Failure - "", sets @error:
;                  |1 - $aSource is not an array
;                  |2 - $aDelim is invalid
;                  |3 - Return string exceeds autoit maximum length
; Author ........: Tvern
; Related .......: _StringToArrayEx
; ===============================================================================================================================
Func _ArrayToStringEx(Const ByRef $aSource, $sDelim = "|")
	If Not IsArray($aSource) Then Return SetError(1,0,"")
	If $sDelim = Default Or Not $sDelim Then $sDelim = "|"
	If $sDelim = "," Or IsNumber($sDelim) Or StringIsDigit($sDelim) Then Return SetError(2,0,"")

	;create an array to hold the dimension count and sizes
	Local $aDimSize[UBound($aSource, 0)+1]
	$aDimSize[0] = UBound($aSource, 0)

	;create an array to hold the dimension indices of the item currently being worked on
	Local $aCurrentDim[$aDimSize[0]+1]
	;store current dimension depth here.
	$aCurrentDim[0] = 0

	;Add dimension sizes to the string
	Local $sReturnString
	For $i = 1 To $aDimSize[0]
		$aDimSize[$i] = UBound($aSource, $i)
		$sReturnString &= $aDimSize[$i] & ","
	Next
	$sReturnString = StringTrimRight($sReturnString, 1)

	;Add array contents to the string and return the string
	$sReturnString &= __AtS_Rec($aSource, $aDimSize, $aCurrentDim, $sDelim)
	If @error Then Return SetError(@error,@extended,"")
	Return $sReturnString
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _StringToArrayEx
; Description ...: Creates an array from a delimiter seperated string. Dimension sizes have to be stored comma seperated, before the first seperator. Any dimension count is valid.
; Syntax.........: _StringToArrayEx($sSource[, $sDelim = "|"])
; Parameters ....: $sSource - String to convert
;                  $sDelim  - [Optional] Delimiter used in the string. Can not be a comma, number, of fully numeric string.
; Return values .: Success - Array with dimensions and content specified in the string
;                  Failure - "", sets @error:
;                  |1 - $sSource is not a string
;                  |2 - $aDelim is invalid
;                  |3 - $sSource does specify dimensions
;                  |4 - Dimension count is too high (>64)
;                  |5 - Dimension count is to low (0), or not numeric
;                  |6 - The amount of indices is higher than the amount of values
;                  |7 - The amount of indices is lower than the amount of values
; Author ........: Tvern
; Related .......: _ArrayToStringEx
; ===============================================================================================================================
Func _StringToArrayEx($sSource, $sDelim = "|")
	If Not IsString($sSource) Then Return SetError(1,0,"")
	If $sDelim = Default Or Not $sDelim Then $sDelim = "|"
	If $sDelim = "," Or IsNumber($sDelim) Or StringIsDigit($sDelim) Then Return SetError(2,0,"")

	;Get the position of the delimiter between dimension sizes and array contents.
	Local $iPos = StringInStr($sSource, $sDelim)
	If Not $iPos Then Return SetError(3,0,"")

	;Split the dimension sizes from the array contents and strore in an array.
	Local $aDimSize = StringSplit(StringLeft($sSource, $iPos - 1), ",")
	Local $n = 1 ;used as a quick check if index count seems right.
	If $aDimSize[0] > 64 Then Return SetError(4,0,"")
	For $i = 1 To $aDimSize[0]
		If Not Number($aDimSize[$i]) Then Return SetError(5,0,"")
		$n *= Number($aDimSize[$i])
	Next

	;Split the array contents from the dimension sizes and strore in an array.
	Local $aSource = StringSplit(StringTrimLeft($sSource, $iPos + StringLen($sDelim)-1), $sDelim, 1)
	If $n < $aSource[0] Then Return SetError(6,0,"")
	If $n > $aSource[0] Then Return SetError(7,0,"")
	;Well use the first element to keep track of what value is copied next.
	$aSource[0] = 1

	;Create an array that keeps track of the index of $aReturn to write the next value to.
	Local $aCurrentDim[$aDimSize[0] + 1]

	;Create an array with the correct number- and size of dimensions to store the data
	;Sadly I don't think Assign, or Execute and be used for this, even with a helper function, so I came up with this little switch statement.
	;Lets hope the technical limit of 64 array dimensions doesn't get upped soon.
	Switch $aDimSize[0]
		Case 1
			Local $aReturn[$aDimSize[1]]
		Case 2
			Local $aReturn[$aDimSize[1]][$aDimSize[2]]
		Case 3
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]]
		Case 4
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]]
		Case 5
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]]
		Case 6
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]]
		Case 7
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]]
		Case 8
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]]
		Case 9
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]]
		Case 10
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]]
		Case 11
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]]
		Case 12
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]]
		Case 13
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]]
		Case 14
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]]
		Case 15
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]]
		Case 16
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]]
		Case 17
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]]
		Case 18
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]]
		Case 19
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]]
		Case 20
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]]
		Case 21
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]]
		Case 22
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]]
		Case 23
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]]
		Case 24
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]]
		Case 25
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]]
		Case 26
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]]
		Case 27
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]]
		Case 28
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]]
		Case 29
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]]
		Case 30
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]]
		Case 31
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]]
		Case 32
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]]
		Case 33
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]]
		Case 34
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]]
		Case 35
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]]
		Case 36
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]]
		Case 37
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]]
		Case 38
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]]
		Case 39
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]]
		Case 40
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]]
		Case 41
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]]
		Case 42
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]]
		Case 43
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]]
		Case 44
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]]
		Case 45
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]]
		Case 46
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]]
		Case 47
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]]
		Case 48
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]]
		Case 49
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]]
		Case 50
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]]
		Case 51
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]]
		Case 52
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]]
		Case 53
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]]
		Case 54
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]]
		Case 55
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]]
		Case 56
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]]
		Case 57
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]]
		Case 58
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]]
		Case 59
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]]
		Case 60
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]][$aDimSize[60]]
		Case 61
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]][$aDimSize[60]][$aDimSize[61]]
		Case 62
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]][$aDimSize[60]][$aDimSize[61]][$aDimSize[62]]
		Case 63
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]][$aDimSize[60]][$aDimSize[61]][$aDimSize[62]][$aDimSize[63]]
		Case 64
			Local $aReturn[$aDimSize[1]][$aDimSize[2]][$aDimSize[3]][$aDimSize[4]][$aDimSize[5]][$aDimSize[6]][$aDimSize[7]][$aDimSize[8]][$aDimSize[9]][$aDimSize[10]][$aDimSize[11]][$aDimSize[12]][$aDimSize[13]][$aDimSize[14]][$aDimSize[15]][$aDimSize[16]][$aDimSize[17]][$aDimSize[18]][$aDimSize[19]][$aDimSize[20]][$aDimSize[21]][$aDimSize[22]][$aDimSize[23]][$aDimSize[24]][$aDimSize[25]][$aDimSize[26]][$aDimSize[27]][$aDimSize[28]][$aDimSize[29]][$aDimSize[30]][$aDimSize[31]][$aDimSize[32]][$aDimSize[33]][$aDimSize[34]][$aDimSize[35]][$aDimSize[36]][$aDimSize[37]][$aDimSize[38]][$aDimSize[39]][$aDimSize[40]][$aDimSize[41]][$aDimSize[42]][$aDimSize[43]][$aDimSize[44]][$aDimSize[45]][$aDimSize[46]][$aDimSize[47]][$aDimSize[48]][$aDimSize[49]][$aDimSize[50]][$aDimSize[51]][$aDimSize[52]][$aDimSize[53]][$aDimSize[54]][$aDimSize[55]][$aDimSize[56]][$aDimSize[57]][$aDimSize[58]][$aDimSize[59]][$aDimSize[60]][$aDimSize[61]][$aDimSize[62]][$aDimSize[63]][$aDimSize[64]]
	EndSwitch

	;We have all the data about the array, and a way to store progress, so we call the recursive function.
	__StA_Rec($aSource, $aReturn, $aDimSize, $aCurrentDim)
	;I don't see any way the recursive function could encounter an error at this point, so no errorchecking for now.

	;Return the now restored array
	Return $aReturn
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __AtS_Rec ( __ArrayToString_Recursive )
; Description ...: Handles the recursive dimension iteration for _ArrayToStringEx
; Syntax.........: __AtS_Rec(Const ByRef $aSource,Const ByRef $aDimSize, ByRef $aCurrentDim,Const ByRef $sDelim)
; Parameters ....: $aSource - The array to convert into a string
;                  $aDimSize - The array that holds the count and size of dimensions in $aSource ;Used to avoid using Ubound allot. (untested, but expected to be more efficient)
;                  $aCurrentDim - The array that holds the current dimension depth, as well as the index currently worked on.
;                  $sDelim - String result separator
; Return values .: Success - (Top level recursion) - Delimiter and Value of one array index
;                  Success - (End of recursion) - Delimiter split string of array contents
;                  Failure - "", sets @error:
;                  |1 - Resulting string exceeds AutoIt maximum stringlength
; Author ........: Tvern
; Remarks .......: This function is used internally.
; Related .......: _ArrayToStringEx
; ===============================================================================================================================
Func __AtS_Rec(Const ByRef $aSource,Const ByRef $aDimSize, ByRef $aCurrentDim,Const ByRef $sDelim)
	Local $sReturnString
	If $aCurrentDim[0] < $aDimSize[0] Then
		;move down one dimension level (more subscripts)
		$aCurrentDim[0] += 1
		;loop through each index in this dimension.
		For $i = 0 To $aDimSize[$aCurrentDim[0]] - 1
			$aCurrentDim[$aCurrentDim[0]] = $i
			$sTemp = __AtS_Rec($aSource, $aDimSize, $aCurrentDim, $sDelim)
			;combined strings might exceed maximum length.
			If StringLen($sReturnString) + StringLen($sTemp) > 2147483647 Then Return SetError(3,0,"")
			$sReturnString &= $sTemp
		Next
		;move up one dimension level (less subscripts)
		$aCurrentDim[0] -= 1
	Else
		Local $sIndex = "$aSource"
		For $i = 1 To $aDimSize[0]
			$sIndex &= "[" & $aCurrentDim[$i] & "]"
		Next
		$sReturnString &= $sDelim & Execute($sIndex)
	EndIf
	Return $sReturnString
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __StA_Rec ( __StringToArray_Recursive )
; Description ...: Handles the recursive dimension iteration for _StringToArrayEx
; Syntax.........: __StA_Rec(ByRef $aSource, ByRef $aReturn,Const ByRef $aDimSize, ByRef $aCurrentDim)
; Parameters ....: $aSource - The 1D array to convert into a nD array
;                  $aReturn - The array to hold the result, previously declared with the correct number and size of dimensions.
;                  $aDimSize - The array that holds the count and size of dimensions in $aReturn ;Used to avoid using Ubound allot. (untested, but expected to be more efficient)
;                  $aCurrentDim - The array that holds the current dimension depth, as well as the index currently worked on.
; Return values .: Success - (Top level recursion) - Writes a value to one index in $aReturn
;                  Success - (End of recursion) - Returns $aReturn with all indecies filled with data from $aSource
; Author ........: Tvern
; Remarks .......: This function is used internally.
; Related .......: _ArrayToStringEx
; ===============================================================================================================================
Func __StA_Rec(ByRef $aSource, ByRef $aReturn,Const ByRef $aDimSize, ByRef $aCurrentDim)
	;Check if we reached the right amount of subscripts (dimension depth) to start copying data.
	If $aCurrentDim[0] < $aDimSize[0] Then
		;the last dimension isn't reached yet.
		;move down one dimension level (more subscripts)
		$aCurrentDim[0] += 1
		;loop through each index in this dimension.
		For $i = 0 To $aDimSize[$aCurrentDim[0]] - 1
			;store the current index at the right posistion in the progress array.
			$aCurrentDim[$aCurrentDim[0]] = $i
			;move to the next sub-dimension.
			__StA_Rec($aSource, $aReturn, $aDimSize, $aCurrentDim)
		Next
		;move up one dimension level (less subscripts)
		$aCurrentDim[0] -= 1
	Else
		;the last dimension is reached. Time to copy the value of the current index.
		;I with I could have used Assign, or Execute.
		Local $sIndex = "$aReturn"
		For $i = 1 To $aDimSize[0]
			$sIndex &= "[" & $aCurrentDim[$i] & "]"
		Next
		Execute("__AssignEx(" & $sIndex & ", $aSource[$aSource[0]])")
		;Set the progress to write the next value in $aSource next.
		$aSource[0] += 1
	EndIf
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __AssignEx
; Description ...: Allows assigning a value to an array index using Execute
; Syntax.........: __AssignEx(ByRef $Index, $Value)
; Parameters ....: $sIndex - A string reference to the target variable, that may be an array element. Like: "$aTarget[2][3]"
;                  $sValue - A string reference to the source variable, that may be an array element.
; Return values .: Success - $Value will be assigned to $Index
;                  Failure - Execute will return an error.
; Author ........: Tvern
; Remarks .......: This function is used internally.
; Related .......: __StA_Rec, _ArrayToStringEx
; Example .......: Execute("__AssignEx($aTarget[2][3], $aSource[3][1])")
; Remarks .......: I am aware the description is a lot bigger than the function!
; ===============================================================================================================================
Func __AssignEx(ByRef $Index, $Value)
    $Index = $Value
EndFunc