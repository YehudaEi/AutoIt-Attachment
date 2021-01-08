; ------------------------------------------------------------------------------
;
; AutoIt Version: 3.1.1++
; Language:       English
; Description:    Financial Functions
;
; ------------------------------------------------------------------------------

; Function list
;===============================================================================
; _Annuity_Resid_Value
; _Loan_Amortisation
; _PV (Present Value)
; _FV (Future Value)
; _Compound_Periodic_Int (Interest)
; _Effective2Nominal (Interest)
; _Periodic2Effective (Interest)
;===============================================================================

;===============================================================================
;
; Description:		_Annuity_Residual_Value
; Parameter(s):		$A=Principal amount of the leasing
; 					$B=Residual value at the end of the periods
; 					$C=Total number of periodic payments
; 					$D=Payments done at the beginning or end of each period,
; 								0= at the end 
;								1= at the beginning
; 					$E=Frequency of the annual payments, 
; 								(example. 6 times a year or 12 teams a year or ... )
; 					$F=Annual interest rate. Input format for 11% is 11, not 0.11
;					$G=Switch 	1= $G (Returns the actual periodic interest)
;								2= $H (Returns interest paid on the residual value over time)
; 								3= $I (Returns the amount which should be paid over the periods)- Default
; 								4= $J (Returns the amount which should be paid over the periods + Interest)
; Requirement:		None
; Return Value(s):	On Success - $G=Returns the actual periodic interest
; 								 $H=Returns interest paid on the residual value over time
;			 					 $I=Returns the amount which should be paid over the periods
;								 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Annuity_Residual_Value( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_Annuity_Resid_Value',_Annuity_Residual_Value(100000,2000,24,1,12,4)) ;### Debug MSGBOX

Func _Annuity_Residual_Value ($A, $B, $C, $D, $E, $F,$K=3)
	Local $G, $H, $I, $J
	If IsNumber($A) And IsNumber($B) And IsInt($C) And IsInt($D) And IsInt($E)<=12 And (IsNumber($F)<=100) And IsInt($K)<=4 Then
	Select
		Case $K = 1
		$G=((1+($F/100))^(1/$E)-1)*100
			SetError(0)
			Return $G
		Case $K = 2
		$G=((1+($F/100))^(1/$E)-1)*100
		$H=($B*($G/100))/((1+($G/100))^$D)
			SetError(0)
			Return $H
		Case $K = 3
		$G=((1+($F/100))^(1/$E)-1)*100
		$H=($B*($G/100))/((1+($G/100))^$D)
		$I=(($A*($G/100*(1+$G/100)^$C))/((1+$G/100)^$C-1)*(1/(1+$G/100)^$D))
			SetError(0)
			Return $I
		Case $K = 4
		$G=((1+($F/100))^(1/$E)-1)*100
		$H=($B*($G/100))/((1+($G/100))^$D)
		$I=(($A*($G/100*(1+$G/100)^$C))/((1+$G/100)^$C-1)*(1/(1+$G/100)^$D))
		$J=$H+$I;
			SetError(0)
			Return $J
	EndSelect		
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_Annuity_Residual_Value

;===============================================================================
;
; Description:		Loan Amortisation
; Parameter(s):		$A=Principal amount of the loan
; 					$B=Annual interest rate. Input format for 11% is 11, not 0.11
; 					$C=Total number of periodic payments
; Requirement:		None
; Return Value(s):	On Success - $E= Periodic payments of the loan
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Loan_Amortisation( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================


 MsgBox(262144,'Debug_Loan_Amortisation',_Loan_Amortisation(10000,4,24)) ;### Debug MSGBOX
 
Func _Loan_Amortisation($A,$B,$C)
	Local $D, $E
	If IsNumber($A) And IsNumber($B)<=100 And IsInt($C) Then
		$E=$B/100;
		$D=$A*($E/12)/(1-1/(EXP($C*LOG(1+$E/12))))
			SetError(0)
			Return $D
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_Loan_Amortisation

;===============================================================================
;
; Description:		Present Value Calculation
; Parameter(s):		$A=Total number of periods
; 					$B=Future Value
; 					$C=Annual interest rate. Input format for 11% is 11, not 0.11
; Requirement:		None
; Return Value(s):	On Success - $D= Present Value
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_PV( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_PV',_PV(3,133.1,10)) ;### Debug MSGBOX ; P.98 = OK

Func _PV($A,$B,$C) 
	Local $D
	If IsNumber($A) And IsNumber($B) And IsInt($C)<=100 Then
		$D=$B/((1+($C/100))^$A);
			SetError(0)
			Return $D
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_PV

;===============================================================================
;
; Description:		Future Value Calculation
; Parameter(s):		$A=Total number of periods
; 					$B=Present Value
; 					$C=Annual interest rate. Input format for 11% is 11, not 0.11
; Requirement:		None
; Return Value(s):	On Success - $D= Future Value
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_FV( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_FV',_FV(3,100,10)) ;### Debug MSGBOX ; P.99 = OK

Func _FV($A,$B,$C) 
	Local $D
	If IsNumber($A) And IsNumber($B) And IsInt(($C)<=100) Then
		$D=$B*((1+($C/100))^$A);
			SetError(0)
			Return $D
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_FV

;===============================================================================
;
; Description:		Compound Periodic Interest
; Parameter(s):		$A=Total number of periods
; 					$B=Present Value
; 					$C=Future Value
; Requirement:		None
; Return Value(s):	On Success - $D= Compound Periodic Interest
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Compound_Periodic_Int( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_Compound_Periodic_Int', _Compound_Periodic_Int(3,100,133.1)) ;### Debug MSGBOX ;P.97 = OK

Func _Compound_Periodic_Int($A,$B,$C) 
	Local $D
	If IsInt($A) And IsNumber($B) And IsNumber($C) Then
		$D=((($C/$B)^(1/$A))-1)*100
			SetError(0)
			Return $D
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_Compound_Periodic_Int

;===============================================================================
;
; Description:		_Effective to Nominal Interest Conversion
; Parameter(s):		$A=Annual interest rate. Input format for 11% is 11, not 0.11
; 					$B=Total number of periods
; Requirement:		None
; Return Value(s):	On Success - $C= Nominal Interest rate
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Effective2Nominal( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_Effective2Nominal', _Effective2Nominal(12,14)) ;### Debug MSGBOX P.101 = OK

Func _Effective2Nominal($A,$B)
	Local $C
	If IsNumber($A)<=100 And IsInt($B) Then
		$C=((1+($B/100))^(1/$A)-1)*$A*100 
			SetError(0)
			Return $C
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc	;==>_Effective2Nominal

;===============================================================================
;
; Description:		Effective to Nominal Interest Conversion
; Parameter(s):		$A=Total number of periods
; 					$B=Periodic interest rate. Input format for 11% is 11, not 0.11
; Requirement:		None
; Return Value(s):	On Success - $C= Effective Interest rate
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Periodic2Effective (???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================

MsgBox(262144,'Debug_Periodic2Effective', _Periodic2Effective(24,0.5)) ;### Debug MSGBOX ; P.102 = OK

Func _Periodic2Effective($A,$B)
	Local $C
	If IsInt($A) And IsNumber($B)<=100 Then
		$C=((1+($B/100))^$A-1)*100;
			SetError(0)
			Return $C
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc	;==>_Periodic2Effective
