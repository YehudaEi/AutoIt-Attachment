; #INDEX# =======================================================================================================================
; Title .........: Modal
; AutoIt Version : 3.3.6.1
; Language ......: English
; Description ...: General modal type operations
; Notes .........: Library includes number base conversion and modal spinning operations on strings, arrays and bit loops.
; Author(s) .....: czardas , Manadar , MvGulik
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _ArrayModalSpin
; _StringModalSpin
; _ArrayModalSelect
; _StringModalSelect
; _bitModalSpin
; _DecToNumBase
; _NumBaseToDec
; _NumBaseToNumBase
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; __DecToNumBase
; __ValidateNumBase
; ===============================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayModalSpin
; Description ...: Rotates a one dimensional array as if it were a continuous modal loop.
; Syntax.........: _ArrayModalSpin(ByRef $av_Array, $iShift)
; Parameters ....: $av_Array - Original array
;                  $iShift   - The number of elements to shift up (negative values shift elements down)
; Return values .: Success   - Returns a new modified array
;                  Failure   - Returns zero and sets @error to the following values:
;                  |@error = 1 : The first parameter is not a one dimensional array
;                  |@error = 2 : Invalid shift value
; Author ........: czardas, Manadar
; Modified.......:
; Remarks .......:
; Related .......: _ArrayModalSelect
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _ArrayModalSpin($av_Array, $iShift)
    If (Not IsArray($av_Array)) Or (UBound($av_Array, 0) > 1) Then Return SetError(1, 0, 0)
    If Not IsInt($iShift) Then Return SetError(2, 0, 0)

    Local $iElements = UBound($av_Array)
    $iShift = Mod($iShift, $iElements)
    If $iShift = 0 Then Return $av_Array
    If $iShift > 0 Then
        $iStart = $iShift
        $iResume = $iElements -$iShift
    Else
        $iShift *= -1
        $iStart = $iElements -$iShift
        $iResume = $iShift
    EndIf
    $av_Temp = $av_Array
    For $i = 0 To $iResume -1
        $av_Array[$i] = $av_Temp[$iStart +$i]
    Next
    For $i = $iResume To $iElements -1
        $av_Array[$i] = $av_Temp[$i -$iResume]
    Next
    Return $av_Array
EndFunc ;==> _ArrayModalSpin

; #FUNCTION# ====================================================================================================================
; Name...........: _StringModalSpin
; Description ...: Rotates a string as if the string were a continuous modal loop.
; Syntax.........: _StringModalSpin($sString, $iShift)
; Parameters ....: $sString - Original string
;                  $iShift  - The number of characters to shift left (negative values shift characters to the right)
; Return values .: Success  - Returns the new modified string
;                  Failure  - Returns an empty string and sets @error to the following values:
;                  |@error = 1 : Invalid source string
;                  |@error = 2 : Invalid shift value
; Author ........: czardas
; Modified.......:
; Remarks .......:
; Related .......: _StringModalSelect
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _StringModalSpin($sString, $iShift)
    If ($sString = "") Or (Not IsString($sString)) Then Return SetError(1, 0, "")
    If Not IsInt($iShift) Then Return SetError(2, 0, "")

    Local $iStringLen = StringLen($sString)
    $iShift = Mod($iShift, $iStringLen)
    If $iShift = 0 Then Return $sString
    If $iShift > 0 Then
        Return StringRight($sString, $iStringLen -$iShift) & StringLeft($sString, $iShift)
    Else
        Return StringRight($sString, -$iShift) & StringLeft($sString, $iStringLen +$iShift)
    EndIf
EndFunc ;==> _StringModalSpin

; #FUNCTION# ====================================================================================================================
; Name...........: _ArrayModalSelect
; Description ...: Selects any element from a continuous modal array loop.
; Syntax.........: _ArrayModalSelect($av_Array, $iElement)
; Parameters ....: $av_Array - Infinite modal array
;                  $iElement - Element to select from the infinite array (negative values loop backwards)
; Return values .: Success   - Returns the array element
;                  Failure   - Returns zero and sets @error to the following values:
;                  |@error = 1 : Parameter 1 is not a one dimensional array
;                  |@error = 2 : Element is not an integer
; Author ........: czardas
; Modified.......:
; Remarks .......:
; Related .......: _ArrayModalSpin
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _ArrayModalSelect($av_Array, $iElement)
    If (IsArray($av_Array) = 0) Or (UBound($av_Array, 0) > 1) Then Return SetError(1, 0, 0)
    If Not IsInt($iElement) Then Return SetError(2, 0, 0)

    $iElement = Mod($iElement, UBound($av_Array))
    If $iElement >= 0 Then
        Return $av_Array[$iElement]
    Else
        Return $av_Array[UBound($av_Array) +$iElement]
    EndIf
EndFunc ;==> _ArrayModalSelect

; #FUNCTION# ====================================================================================================================
; Name...........: _StringModalSelect
; Description ...: Selects a number of characters from a continuous modal string loop.
; Syntax.........: _StringModalSelect( $sString [, $iShift [, $iChars]])
; Parameters ....: $sString - Original string
;                  $iShift  - The number of characters to shift left prior to selection (negative values shift characters right)
;                  $iChars  - The number of characters to select from the rotated string.
; Return values .: Success  - Returns the new string
;                  Failure  - Returns an empty string and sets @error to the following values
;                  |@error = 1 : Invalid source string
;                  |@error = 2 : Invalid shift value
;                  |@error = 3 : Invalid number of characters
; Author ........: czardas
; Modified.......:
; Remarks .......: Return string can be any length
; Related .......: _StringModalSpin
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _StringModalSelect($sString, $iShift = 0, $iChars = 1)
    If $sString = "" Or (Not IsString($sString)) Then Return SetError(1, 0, "")
    If Not IsInt($iShift) Then Return SetError(2, 0, "")
    If (Not IsInt($iChars)) Or $iChars <= 0 Then Return SetError(3, 0, "")

    ; Get the current position of the first character for the new string
    Local $iStringLen = StringLen($sString)
    $iShift = Mod($iShift, $iStringLen)
    If $iShift >= 0 Then
        $iStart = $iShift +1
    Else
        $iStart = $iStringLen +$iShift +1
    EndIf

    Local $iEnd = $iStart +$iChars -1 ; Get the projected end character position
    If $iEnd <= $iStringLen Then
        Return StringMid($sString, $iStart, $iChars) ; The return string is contained within the original string
    Else
        $sTemp = $sString
        For $i = 1 To Int($iEnd/$iStringLen) -1
            $sTemp &= $sString ; repeat the modal string loop as required
        Next
        $sTemp = StringTrimLeft($sTemp, $iStart -1) ; remove surplus leading chars
        Return $sTemp & StringLeft($sString, Mod($iEnd, $iStringLen)) ; Add the final character sequence
    EndIf
EndFunc ;==> _StringModalSelect

; #FUNCTION# ====================================================================================================================
; Name...........: _bitModalSpin
; Description ...: Performs a bit shifting operation, with rotation on 2-32 bits.
; Syntax.........: _bitModalSpin ( $bVal , $iShift , $iLoopSize )
; Parameters ....: $bVal       - The number to be operate on
;                  $iShift     - Number of bits to spin to the left (negative numbers spin right)
;                  $iLoopSize  - The number of bits in the loop - counting from the left
; Return values .: Success     - Returns the value with the required bits rotated.
;                  Failure     - Returns zero and sets @error to the following values:
;                 |@error = 1  - First parameter is not a valid number or is out of bounds
;                 |@error = 2  - Second parameter is not a valid integer
;                 |@error = 3  - Third  parameter is not a valid integer or is out of bounds
; Author ........: czardas
; Modified.......:
; Remarks .......: With a loop size of 8, 16 or 32 bits it is faster to use BitRotate.
; Related .......: BitRotate
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _bitModalSpin($bVal, $iShift, $iLoopSize)
    If (Not IsInt($bVal)) Or ($bVal < 0 - 2^31) Or ($bVal > 2^31 -1) Then Return SetError(1, 0, 0)
    If (Not IsInt($iLoopSize)) Or $iLoopSize > 32 Or $iLoopSize < 0 Then Return SetError(2, 0, 0)
    If Not IsInt($iShift) Then Return SetError(3, 0, 0)

    If $iLoopSize < 2 Then Return $bVal
    $iShift = Mod($iShift, $iLoopSize)
    If $iShift = 0 Then Return $bVal
    If $iLoopSize = 32 Then Return BitRotate($bVal, $iShift, "D") ; Spin all 32 bits

    If $iShift > 0 Then
        $iShift = $iShift - $iLoopSize
    EndIf

    Local $bLeft = BitShift( BitShift($bVal, $iLoopSize), -$iLoopSize)
    Local $bLoop = BitXOR($bLeft, $bVal)
    Local $bRight = BitShift($bLoop, -$iShift)
    Local $bMid = BitShift( BitXOR( BitShift($bRight, $iShift), $bLoop), -$iShift -$iLoopSize)
    Return BitOR($bLeft, $bMid, $bRight)
EndFunc ;==> _bitModalSpin

; #FUNCTION# ====================================================================================================================
; Name...........: _DecToNumBase
; Description ...: Converts a decimal integer to a new numeric base.
; Syntax.........: _DecToNumBase($iDecimal, $iBase)
; Parameters ....: $iDecimal - Decimal input value
;                  $iBase   - The numeric base to convert to
; Return values .: Success   - Returns the numeric base equivalent of the decimal.
;                  Failure   - Sets @error to the following values:
;                  |@error = 1 Invalid base value
;                  |@error = 2 Invalid decimal value
;                  |@error = 3 Float output limitation
; Author ........: czardas, MvGulik
; Modified.......:
; Remarks .......: Max input of 15 digits, and numeric base limitations from number bases 2 through 10.
; Related .......: _NumBaseToDec, _NumBaseToNumBase
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _DecToNumBase($iDecimal, $iBase)
    If IsInt($iBase) = 0 Or $iBase < 2 Or $iBase > 10 Then Return SetError(1, 0, 0) ; invalid base value
    If IsInt($iDecimal) = 0 Then Return SetError(2, 0, 0) ; invalid decimal value
    Local $iSign = 1, $iRet = 0
    If $iDecimal < 0 Then $iSign = -1
    $iDecimal *= $iSign ; force positive value
    If $iDecimal < $iBase Or $iBase = 10 Then Return $iDecimal*$iSign ; nothing to do
    If Floor(Log($iDecimal)/Log($iBase)) > 15 Then Return SetError(2, 0, 0) ; float output limitation
    __DecToNumBase($iDecimal, $iBase, $iRet)
    Return $iRet*$iSign
EndFunc ;=> _DecToNumBase

; #FUNCTION# ====================================================================================================================
; Name...........: _NumBaseToDec
; Description ...: Converts a numeric base value to its decimal equivalent.
; Syntax.........: _DecToNumBase($iDecimal, $iBase)
; Parameters ....: $iNumber - Numeric input
;                  $iBase   - The numeric base to convert from
; Return values .: Success   - Returns the decimal  equivalent of the numeric base input value.
;                  Failure   - Sets @error to the following values:
;                  |@error = 1 Invalid base value
;                  |@error = 2 Invalid numeric input
;                  |@error = 3 Float input limitation
; Author ........: czardas
; Modified.......:
; Remarks .......: Max input of 15 digits, and numeric base limitations from number bases 2 through 10.
; Related .......: _NumBaseToDec , _NumBaseToNumBase
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================

Func _NumBaseToDec($iNumber, $iBase)
    If IsInt($iBase) = 0 Or $iBase < 2 Or $iBase > 10 Then Return SetError(1, 0, 0) ; invalid base value
    If IsInt($iNumber) = 0 Then Return SetError(2, 0, 0) ; invalid numeric input
    If $iBase = 10 Then Return $iNumber ; nothing to do
    __ValidateNumBase($iNumber, $iBase)
    If @error Then Return SetError(2, 0, 0) ; invalid digits
    Local $aBaseDigit, $iExponent, $iSign = 1, $iRet = 0
    If $iNumber < 0 Then $iSign = -1
    $iNumber *= $iSign ; force positive value
    $iExponent = StringLen($iNumber) -1
    If $iExponent > 14 Then Return SetError(3, 0, 0) ; float input limitation
    $aBaseDigit = StringSplit($iNumber, "", 2)
    For $i = 0 To $iExponent
        $iRet += $aBaseDigit[$i]*($iBase^($iExponent - $i))
    Next
    Return $iRet*$iSign
EndFunc ;==> _NumBaseToDec

; #FUNCTION# ====================================================================================================================
; Name...........: _NumBaseToNumBase
; Description ...: Converts a numeric expression from one base to another.
; Syntax.........: _NumBaseToNumBase($iNumber, $iBase, $iNewBase)
; Parameters ....: $iNumber - Numeric input
;                  $iBase   - The numeric base to convert from
;                  $iNewBase - The numeric base to convert to
; Return values .: Success   - Returns the new numeric base equivalent of the input value.
;                  Failure   - Sets @error to the following values:
;                  |@error = 1 Invalid base value
;                  |@error = 2 Invalid numeric input
;                  |@error = 3 Float input limitation
;                  |@error = 4 Invalid new base value
; Author ........: czardas
; Modified.......:
; Remarks .......: Max input of 15 digits, and numeric base limitations from number bases 2 through 10.
; Related .......: _NumBaseToDec , _DecToNumBase
; Link ..........:
; Example .......: Yes

; ===============================================================================================================================

Func _NumBaseToNumBase($iNumber, $iBase, $iNewBase)
    __ValidateNumBase($iNumber, $iBase)
    If @error Then Return SetError(2, 0, 0)
    $iNumber = _NumBaseToDec($iNumber, $iBase)
    If @error Then Return SetError(@error, 0, 0)
    $iNumber = _DecToNumBase($iNumber, $iNewBase)
    If @error Then Return SetError(@error +3, 0, 0)
    Return $iNumber
EndFunc ;==> _NumBaseToNumBase

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __DecToNumBase
; Description ...: Internal function to convert from decimal to a new numeric base.
; Syntax.........: __DecToNumBase($iDecimal, $iBase, ByRef $iRet)
; Parameters ....: $iDecimal - Decimal input value
;                  $iBase   - The numeric base to convert to
;                  $iRet     - Recursive return value
; Return values .: Returns the numeric base value equivalent of the decimal integer
; Author ........: czardas, MvGulik
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================

Func __DecToNumBase($iDecimal, $iBase, ByRef $iRet)
    Local $iPower = Floor(Log($iDecimal) / Log($iBase))
    Local $iDigit = Int($iDecimal/($iBase^$iPower))
    $iRet += $iDigit*(10^$iPower)
    $iDecimal -= $iDigit*($iBase^$iPower)
    If $iDecimal < $iBase Then
        $iRet += $iDecimal
    Else
        __DecToNumBase($iDecimal, $iBase, $iRet)
    EndIf
EndFunc ;==> __DecToNumBase

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __ValidateNumBase
; Description ...: Internal function to check input only contains digits within the numeric mode.
; Syntax.........: __ValidateNumBase($iNumber, $iBase)
; Parameters ....: $iNumber - Numeric input value
;                  $iBase   - The numeric base to check
; Return values .: Sets @error to 1 if validation fails.
; Author ........: czardas
; Modified.......:
; Remarks .......:
; Related .......: None
; Link ..........:
; Example .......: No
; ===============================================================================================================================

Func __ValidateNumBase($iNumber, $iBase)
    If $iBase = 10 Then Return
    For $i = $iBase To 9
        If StringInStr($iNumber, $i) Then Return SetError(1)
    Next
EndFunc ; __ValidateNumBase