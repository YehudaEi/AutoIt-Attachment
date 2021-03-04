#include-once
#include <Array.au3>
; #INDEX# =======================================================================================================================
; Title .........: MathsEx
; AutoIt Version : 3.2.10++
; Language ......: English
; Description ...: Functions for Carrying Out More Advanced Mathematical Calculations.
; Author(s) .....: Phoenix XL
; Included.......: Three Functions of Array.au3 i.e. _ArraySort and _ArrayReverse and __ArrayQuickSort1D Requires Array.au3
; ===============================================================================================================================

;  0xDead=57005...............I just Like The Number :)

; #CURRENT# =====================================================================================================================
; _Find_GCF
; _Find_LCM

; _Subtract_Fraction
; _Add_Fraction
; _Multiply_Fraction
; _Divide_Fraction

; _Reciprocal
; _Compare_Fraction

; _Quotient
; _Simplify

; _IntegerisNegative
; _IntegerisPositive

; _Get_Denominator
; _Get_Numerator

; _To_Fraction
; _To_Mixed_Fraction

; _Is_Fraction_Improper
; _Is_Fraction_Proper
; _Is_Fraction
; ===============================================================================================================================

; #INTERNAL_USE_ONLY# ===========================================================================================================
; _CheckArray
; _Greatest_Common_Factor
; _Operate_Fraction
; _Set_Sequence
; ===============================================================================================================================
#cs
	Name				_Quotient()

	Syntax:				_Quotient($sDivident,$sDivisor)

	Parameters:
						$sDivident		:The Divident can be a Whole Number(+ve Integer) as Well as a String Whole Number......
						$sDivisor		:The Divisor can be a Whole Number(+ve Integer) as Well as a String Whole Number......

	Return Values:
					On Success
						Returns the Quotient ....

					On Failure
						Returns @error to 1 and Returns -1 when either of the parameters are Incorrect


	Remarks: 			Get the Quotient by Using this Funtion......

	Author: 			Phoenix XL
#ce

Func _Quotient($sDivident,$sDivisor)
	If $sDivisor='0' Then Return SetError(1,0,-1)
	If Not _Is_Fraction($sDivident&'/'&$sDivisor) Then Return SetError(1,0,-1)
	Local $sRemainder=Mod($sDivident,$sDivisor)
	Switch $sRemainder
		Case 0
			Return $sDivident/$sDivisor
		Case Else
			Switch _Is_Fraction_Proper($sDivident&'/'&$sDivisor)
				Case 1
					Return SetError(0,0,0)
				Case Else
					Return SetError(0,0,($sDivident-$sRemainder)/$sDivisor)
			EndSwitch
	EndSwitch
EndFunc



#cs
	Name				_To_Fraction()

	Syntax:				_To_Fraction($sFloat)

	Parameters:
						$sFloat			:A Floating Number or Whole Number ......

	Return Values:
					On Success
						Returns the Fraction as a String....(Reason , an Integer containing the Sign '/' will perform the Division Operation)

					On Failure
						Returns -1 and Sets @error to 1 incase of a InValid Parameter
						Returns -2 and Sets @error to 1 incase of a InValid Decimal Parameter
						Returns -3 and Sets @error to 1 When The Parameter is Already a Fraction
						Returns -4 and Sets @error to 1 When The Array Parameter is Invalid


	Remarks: 			Convert a Floating POint Number to a Fraction......

	Author: 			Phoenix XL
#ce
Func _To_Fraction($sFloat)
	If IsArray($sFloat) Then				;Mixed Fraction
		If UBound($sFloat)=2 Then
			Return (_Get_Denominator($sFloat[2])*$sFloat[1])+_Get_Numerator($sFloat[2])&'/'&_Get_Denominator($sFloat[2])
		Else
			Return SetError(1,0,-4)
		EndIf
	EndIf
	If _Is_Fraction($sFloat) Then Return SetError(1,0,-3)
	If Not StringIsInt($sFloat) And Not StringIsFloat($sFloat) Then Return SetError(1,0,-1)
	If StringIsInt($sFloat) Then Return $sFloat
	Local $sArray=StringSplit($sFloat,".",1)
	If $sArray[0]>2 Then Return SetError(1,0,-2)
	Local $sLength=StringLen(String($sArray[2]))
	Local $sFraction=String($sArray[2])&'/'&String(10^$sLength)
	Return SetError(0,0,_Simplify($sArray[1]&$sFraction))
EndFunc

#cs
	Name				_Simplify()

	Syntax:				_Simplify($sFraction)

	Parameters:
						$sFraction		:The Fraction Which Has TO be Further Simplified ......

	Return Values:
					On Success
						Returns the Simplified Fraction as a String....(Reason , an Integer containing the Sign '/' will perform the Division Operation)

					On Failure
						Sets @error to 1 and Returns -1 if the Parameter is Invalid

	Remarks: 			Simplifies the Fraction ......

	Author: 			Phoenix XL
#ce
Func _Simplify($sFraction)
	If Not _Is_Fraction($sFraction) Then Return SetError(1,0,-1)
	Local $sHCF=_Greatest_Common_Factor(_Get_Numerator($sFraction),_Get_Denominator($sFraction))
	Local $sDenominator=_Get_Denominator($sFraction)/$sHCF
	If $sDenominator=1 Then Return _Get_Numerator($sFraction)/$sHCF
	Return SetError(0,0,(_Get_Numerator($sFraction)/$sHCF&'/'&$sDenominator))
EndFunc


#cs
	Name				_Is_Fraction_Improper()

	Syntax:				_Is_Fraction_Improper($sFraction)

	Parameters:
						$sFraction		:The Fraction Which Has TO be Checked if Improper......

	Return Values:
					On Success
						Returns 1 if the Fraction is Improper
						Returns 0 if the Fraction is Proper

					On Failure
						Returns -1 and Sets @error To 1 When The Supplied Paramete is not a Valid Fraction

	Remarks: 			Checks Whether the Fraction is Improper..............

	Author: 			Phoenix XL
#ce
Func _Is_Fraction_Improper($sFraction)
	If Not _Is_Fraction($sFraction) Then Return SetError(1,0,-1)
	If Number(_Get_Numerator($sFraction))>=Number(_Get_Denominator($sFraction)) Then Return SetError(0,0,1) ;Note That If the Numerator is Equal to The Denominator then Also its an Improper Fraction....
	Return SetError(0,0,0)
EndFunc

#cs
	Name				_Is_Fraction_Proper()

	Syntax:				_Is_Fraction_Proper($sFraction)

	Parameters:
						$sFraction		:The Fraction Which Has TO be Checked if Proper......

	Return Values:
					On Success
						Returns 0 if the Fraction is Improper
						Returns 1 if the Fraction is Proper

					On Failure
						Check _Is_Fraction_Improper For Return Values

	Remarks: 			Checks if the Fraction is Proper..............

	Author: 			Phoenix XL
#ce
Func _Is_Fraction_Proper($sFraction)
	;I could Have Coded the Vice-Versa Code of _Is_Fraction_Improper but Its Better to do it Otherwise............  :)
	If _Is_Fraction_Improper($sFraction) Then Return SetError(0,0,0)
	Return SetError(0,0,1)
EndFunc

#cs
	Name				_Get_Denominator()

	Syntax:				_Get_Denominator($sFraction)

	Parameters:
						$sFraction		:The Fraction from Which the Denominator Has TO be Extracted ......

	Return Values:
					On Success
						Returns the Denominator

					On Failure
						Sets @error to 1 and Returns
							|-2 When $sFraction is not a Valid Fraction
							|-1 When The Parameter contains two Slashes '/'

	Remarks: 			Returns The Denominator ......

	Author: 			Phoenix XL
#ce
Func _Get_Denominator($sFraction)
	If Not _Is_Fraction($sFraction) Then Return SetError(1,0,-2)   ;  U should Use  $sFraction=_To_Fraction($sFraction)
	Local $sArray=StringSplit($sFraction,'/',1)
	If $sArray[0]<2 Then Return '1'
	If $sArray[0]>2 Then Return SetError(1,0,-1);Checks if the The Number has Been Divided Twice or Has Two '/'.....
	Return SetError(0,0,$sArray[2])
EndFunc


#cs
	Name				_Get_Numerator()

	Syntax:				_Get_Numerator($sFraction)

	Parameters:
						$sFraction		:The Fraction from Which the Numerator Has TO be Extracted ......

	Return Values:
					On Success
						Returns the Numerator

					On Failure
						Sets @error to 1 and Returns
							|-2 When $sFraction is not a Valid Fraction
							|-1 When The Parameter contains two Slashes '/'

	Remarks: 			Returns The Numerator......

	Author: 			Phoenix XL
#ce
Func _Get_Numerator($sFraction)
	If Not _Is_Fraction($sFraction) Then Return SetError(1,0,-2) ;$sFraction=_To_Fraction($sFraction)
	Local $sArray=StringSplit($sFraction,'/',1)
	If $sArray[0]<2 Then Return $sFraction
	If $sArray[0]>2 Then Return SetError(1,0,-1)
	Return SetError(0,0,$sArray[1])
EndFunc


#cs
	Name				_To_Mixed_Fraction()

	Syntax:				_To_Mixed_Fraction($sFloat)

	Parameters:
						$sFloat			:The Floating Point Number  ......

	Return Values:
					On Success
						Returns an Array
							Array[1]=The Whole Number
							Array[2]=The Fraction Part

					On Failure
						Sets @error to 1 and Returns -1 If the Fraction Wasnt Improper

	Remarks: 			Converts the Improper Fraction into Mixed Fraction......

	Note:				A Improper Fraction or a Floating Point Number Can Be PAssed as a Parameter But .....
						On Conversion of the Floating Number into Fraction It should Be an Improper Fraction....
						OrElse Ensure that The Floating POint Number is >=1 or <=-1


	Author: 			Phoenix XL
#ce
Func _To_Mixed_Fraction($sFloat)
	If Not _Is_Fraction($sFloat) Then $sFloat=_To_Fraction($sFloat)
	If Not _Is_Fraction_Improper($sFloat) Then Return SetError(1,0,-1)
	Local $sQuotient=_Quotient(_Get_Numerator($sFloat),_Get_Denominator($sFloat))
	Local $sRemainder=Mod(_Get_Numerator($sFloat),_Get_Denominator($sFloat))
	Local $sArray[2]=[$sQuotient,$sRemainder&'/'&_Get_Denominator($sFloat)]
	Return SetError(0,0,$sArray)
EndFunc

#cs
	Name				_Is_Fraction()

	Syntax:				_Is_Fraction($sData)

	Parameters:
						$sData		:The Data Which has to Be Checked if it is a Fraction  ......
									Note For Mixed Fractions even Passing the Whole Array, The Function Will Only Check for the Fraction Part(if Present)

	Return Values:
					On Success
						Returns 1
						Returns 0

					On Failure
						Sets @error to 1 and Returns
							| -1 When String Doesn't Have Slash
							| -2 If The String Contains more than Two Slashes '/'

	Author: 			Phoenix XL
#ce
Func _Is_Fraction($sData)
	If IsArray($sData) Then $sData=$sData[1] 			;Mixed Fraction's Second Row[1] has the Real Fraction and the First Row[0] has the Whole Number
	If StringIsInt($sData) Then Return 1
	If Not StringInStr($sData,'/',2) Then Return SetError(1,0,-1)
	$sData=StringSplit($sData,'/',1)
	If $sData[0]>2 Then Return SetError(1,0,-2)
	Local $sNumerator=$sData[1]
	Local $sDenominator=$sData[2]
	If StringIsInt($sNumerator) And StringIsInt($sDenominator) Then Return 1
	Return SetError(0,0,0)
EndFunc

#cs
	Name				_Find_GCF()

	Syntax:				_Find_GCF($sArray)

	Parameters:
						$sArray		:The Data in 0 based Array containing all the Numbers For Which the Greatest/Highest Common Factor is to be Found......
									Note For finding the GCF/HCF of only Two Numbers Use the _Greatest_Common_Factor() Function Instead

	Return Values:
					On Success
						Returns GCF or HCF of the Specified Numbers in $sArray

					On Failure
						Sets @error to 1 and
						| Returns -1 when $sArray is not an Array
						| Returns -2 when $sArray Doesn't have More than 1 Value
						| Returns -3 when any of the value of $sArray is not a Valid Parameter

	Remarks: 			Returns GCF or HCF of the Specified Numbers

	Author: 			Phoenix XL
#ce
Func _Find_GCF($sArray)
	If Not IsArray($sArray) Then Return SetError(1,0,-1)
	If UBound($sArray)<2 Then Return SetError(1,0,-2)
	Local $sCount=0
	If UBound($sArray)=2 Then Return _Greatest_Common_Factor($sArray[0],$sArray[1])
	Local $sError=_Set_Sequence($sArray)
	If @error Then Return $sError
	Local $sGCF=_Greatest_Common_Factor($sArray[$sCount],$sArray[$sCount+1])
	While 1
		$sCount+=1
		If $sCount=UBound($sArray)-1 Then ExitLoop
		$sGCF= _Greatest_Common_Factor($sGCF,$sArray[$sCount+1])
	WEnd
	Return SetError(0,0,$sGCF)
EndFunc


#cs
	Name				_Find_LCM()

	Syntax:				_Find_LCM($sArray)

	Parameters:
						$sArray		:The Data in 0 based Array containing all the Numbers For Which the Least Common Multiple is to be Found......

	Return Values:
					On Success
						Returns LCM of the Specified Numbers in $sArray

					On Failure
						Sets @error to 1 and
						| Returns -1 when $sArray is not an Array
						| Returns -2 when $sArray Doesn't have More than 1 Value
						| Returns -3 when any of the value of $sArray is not a Valid Parameter

	Remarks: 			Returns LCM of the Specified Numbers

	Author: 			Phoenix XL
#ce
Func _Find_LCM($sArray)
	Local $sHCF=_Find_GCF($sArray)
	If Not @error Then Return ($sArray[0]*$sArray[1])/$sHCF
	Return SetError(0,0,$sHCF)
EndFunc

#cs
	Name				_Subtract_Fraction

	Syntax:				_Subtract_Fraction($sFraction,$hFraction)

	Parameters:
						$sFraction		:The Fraction From Which the $hFraction has to be Subtracted
						$hFraction		:The Fraction Which has to be Subtracted From $sFraction

	Return Values:
					On Success
						Returns the Subtracted Fraction....

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong


	Remarks: 			Get the Quotient by Using this Funtion......

	Author: 			Phoenix XL
#ce
Func _Subtract_Fraction($sFraction,$hFraction)
	Return SetError(0,0,_Operate_Fraction($sFraction,$hFraction,'-'))
EndFunc

#cs
	Name				_Add_Fraction

	Syntax:				_Add_Fraction($sFraction,$hFraction)

	Parameters:
						$sFraction		:The Fraction to be added
						$hFraction		:The Fraction to be added

	Return Values:
					On Success
						Returns the added Fraction....

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong

	Remarks: 			Add Two Fractions Using this Funtion......

	Author: 			Phoenix XL
#ce
Func _Add_Fraction($sFraction,$hFraction)
	Return SetError(0,0,_Operate_Fraction($sFraction,$hFraction,'+'))
EndFunc

#cs
	Name				_Multiply_Fraction

	Syntax:				_Multiply_Fraction($sFraction,$hFraction)

	Parameters:
						$sFraction		:The Fraction to be Multiplied
						$hFraction		:The Fraction to be Multiplied

	Return Values:
					On Success
						Returns the Multiplied Fraction....

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong

	Remarks: 			Multiply Two Fractions Using this Funtion......

	Author: 			Phoenix XL
#ce
Func _Multiply_Fraction($sFraction,$hFraction)
	If Not _Is_Fraction($sFraction) And Not _Is_Fraction($hFraction) Then Return SetError(1,0,-1)
	Return SetError(0,0,_Simplify(_Get_Numerator($sFraction)*_Get_Numerator($hFraction)&'/'&_Get_Denominator($sFraction)*_Get_Denominator($hFraction)))
EndFunc

#cs
	Name				_Reciprocal

	Syntax:				_Reciprocal($sFraction)

	Parameters:
						$sFraction		:The Fraction Whose Reciprocal Has to be Found

	Return Values:
					On Success
						Returns The UpsideDown Fraction.... :)

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong

	Remarks: 			Get THe Reciprocal of anyu Fraction......

	Author: 			Phoenix XL
#ce
Func _Reciprocal($sFraction)
	If Not _Is_Fraction($sFraction) Then Return SetError(1,0,-1)
	Return SetError(0,0,_Simplify(_Get_Denominator($sFraction)&'/'&_Get_Numerator($sFraction)))
EndFunc

#cs
	Name				_Divide_Fraction

	Syntax:				_Divide_Fraction($sDividentFraction,$hDivisorFraction)

	Parameters:
						$sDividentFraction			:The Divident
						$hDivisorFraction			:The Divisor

	Return Values:
					On Success
						Returns The Divided Fraction.... :)

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong

	Remarks: 			Divide any Two Fraction......

	Author: 			Phoenix XL
#ce
Func _Divide_Fraction($sDividentFraction,$hDivisorFraction)
	If Not _Is_Fraction($sDividentFraction) And Not _Is_Fraction($hDivisorFraction) Then Return SetError(1,0,-1)
	Return SetError(0,0,_Multiply_Fraction($sDividentFraction,_Reciprocal($hDivisorFraction)))
EndFunc


#cs
	Name				_Compare_Fraction

	Syntax:				_Compare_Fraction($sFraction,$hFraction,$sReturn=1)

	Parameters:
						$sFraction		:The Fraction to be Multiplied
						$hFraction		:The Fraction to be Multiplied
						$sReturn		:1=Return The Greater Fraction (Default)
										 0=Return The Smallest Fraction
	Return Values:
					On Success
						$sReturn		:1=Return The Greater Fraction (Default)
										 0=Return The Smallest Fraction

					On Failure
						Set @error to 1 and Returns -1 if The Parameters are Wrong

	Remarks: 			Compare Two Fraction USing This Function......

	Author: 			Phoenix XL
#ce
Func _Compare_Fraction($sFraction,$hFraction,$sReturn=1)
	Switch _IntegerisNegative(_Get_Numerator(_Subtract_Fraction($sFraction,$hFraction)))
		Case 1
			Switch $sReturn
				Case 1
					Return SetError(0,0,$hFraction)
				Case 0
					Return SetError(0,0,$sFraction)
			EndSwitch
		Case 0
			Switch $sReturn
				Case 0
					Return SetError(0,0,$hFraction)
				Case 1
					Return SetError(0,0,$sFraction)
			EndSwitch
	EndSwitch
EndFunc


#cs
	Name				_IntegerisNegative

	Syntax:				_IntegerisNegative($sInteger)

	Parameters:
						$sInteger		:The Integer to be Checked if is Negative

	Return Values:
					1 if Yes
					0 elsewise

	Remarks: 			Check if the Integer is Negative......

	Author: 			Phoenix XL
#ce
Func _IntegerisNegative($sInteger)
	If Int($sInteger)<0 Then Return 1
	Return 0
EndFunc


#cs
	Name				_IntegerisPositive

	Syntax:				_IntegerisPositive($sInteger)

	Parameters:
						$sInteger		:The Integer to be Checked if is Positive

	Return Values:
					1 if Yes
					0 elsewise

	Remarks: 			Check if the Integer is Positive......

	Author: 			Phoenix XL
#ce
Func _IntegerisPositive($sInteger)
	If Int($sInteger)>0 Then Return 1
	Return 0
EndFunc

;#================INTERNAL FUNTIONS======================================================#
; #INTERNAL FUNCTION# ==================#Internal Use Only===============================================================================
; Name...........: _Set_Sequence
; Description ...: Helper Funtion of _Find_GCF
; Syntax.........: _Set_Sequence(ByRef $sData,$sDecreasing=1)
; Parameters ....: ByRef $sData - Array to Check
;                  $sDecreasing  - 1(Default)=Descending
;								   2		 =Ascending
; Return values .: Success - Sorts The Array
;                  Failure - sets @error to 1
;				   Returns
;                  |-1 - $avArray is not an array
;                  |-2 - $avArray has Some Wrong Parameters
; Author ........: Phoenix XL
; Remarks .......:	TO Find The GCF/HCF of more than Two Numbers
;					First The GCF/HCF of the Two Greatest Numbers has to Be Found
;					The Following Function Sets The Array into Decreasing Order
; ===============================================================================================================================

Func _Set_Sequence(ByRef $sData,$sDecreasing=1)
	If Not IsArray($sData) Then Return SetError(1,0,-1)
	If Not _CheckArray($sData) Then Return SetError(1,0,-3)
	Return _ArraySort($sData,$sDecreasing)
	;_ArrayDisplay($sData,'Nothing')
EndFunc


; #INTERNAL FUNCTION# ==================#Internal Use Only===============================================================================
; Name...........: _CheckArray
; Description ...: Helper Funtion of _Set_Sequence......
; Syntax.........: _CheckArray($sData,$sCheck='StringIsInt')
; Parameters ....: $sData - Array to Check
;                  $sCheck  - 'StringIsInt'(Default)=Checks if the Supplied Parameter is a Interger or String Interger
;
; Return values .: Success - Returns 1
;                  Failure - Returns 0

; Author ........: Phoenix XL
; Remarks .......:	...........
; ===============================================================================================================================
Func _CheckArray($sData,$sCheck='StringIsInt')
	For $i=0 To UBound($sData)-1
		If Not Execute($sCheck&'('&$sData[$i]&')') Then Return 0
	Next
	Return 1
EndFunc

; #INTERNAL FUNCTION# ==================#Internal Use Only/Also Supports External Use====================================================
; Name...........: _Greatest_Common_Factor
; Description ...: Helper Funtion of _Find_GCF......
; Syntax.........: _Greatest_Common_Factor($sFirst,$sSecond)
; Parameters ....: $sFirst - First Number
;                  $sSecond - Second Number
;
; Return values .: Success - Returns GCF/HCF of the Two Numbers
;                  Failure - Returns -1 sets @error to 1 when Wrong Parameters Are Supplied
; Author ........: Phoenix XL
; Remarks .......:	To Find the GCF/HCF of Two Numbers You Can Directly use This Funtion
; ===============================================================================================================================
Func _Greatest_Common_Factor($sFirst,$sSecond)
	If Not StringIsInt($sFirst) Or Not StringIsInt($sSecond) Then Return SetError(1,0,-1)
	Local $sGreatInt,$sSmallInt
	If $sFirst>$sSecond Then
		$sGreatInt=$sFirst
		$sSmallInt=$sSecond
	ElseIf $sFirst=$sSecond Then
		Return $sFirst
	Else
		$sGreatInt=$sSecond
		$sSmallInt=$sFirst
	EndIf

	Local $sRemainder,$sQuotient
	While 1
		$sRemainder=Mod($sGreatInt,$sSmallInt)
		If $sRemainder=0 Then ExitLoop
		$sGreatInt=$sSmallInt
		$sSmallInt=$sRemainder
	WEnd
	Return $sSmallInt
EndFunc


; #INTERNAL FUNCTION# ====================================================================================================================
; Name...........: _Operate_Fraction
; Description ...: Helper Funtion For Adding and Subtracting Fractions
; Syntax.........: _Operate_Fraction($sFraction,$hFraction,$sOperator)
; Parameters ....: $avArray - Array to modify
;                  $sFraction  - The First Fraction With Which the OPeration has to be Carried Out
;                  $hFraction  - The Second Fraction With Which the OPeration has to be Carried Out
;				   $sOperator  - The Operation To Carry Out Either '+' or '-'
; Return values .: Success - Returns The Result
;                  Failure - Returns -1 sets @error to 1 when Wrong Parameters Are Supplied
; Author ........: Phoenix XL
; ===============================================================================================================================
Func _Operate_Fraction($sFraction,$hFraction,$sOperator)
	If Not _Is_Fraction($sFraction) Or Not _Is_Fraction($hFraction) Then Return SetError(1,0,-1)
	Local $sLCM[2]=[_Get_Denominator($sFraction),_Get_Denominator($hFraction)]
	$sLCM=_Find_LCM($sLCM)
	Local $sNumerator=($sLCM/_Get_Denominator($sFraction))*_Get_Numerator($sFraction)
	Local $hNumerator=($sLCM/_Get_Denominator($hFraction))*_Get_Numerator($hFraction)
	Return SetError(0,0,_Simplify(Execute($sNumerator&$sOperator&$hNumerator)&'/'&$sLCM))
EndFunc
;#================INTERNAL FUNTIONS Ends==================================================#