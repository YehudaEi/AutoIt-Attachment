
;===============================================================================
;
; Description:		Loan Amortization
; Parameter(s):		$A=Principal amount of the loan
; 					$B=Annual interest rate. Input format for 11% is 11, not 0.11
; 					$C=Total number of periodic payments
; Requirement:		None
; Return Value(s):	On Success - $E= Periodic payments of the loan
;									 And sets @ERROR = 0
;                   On Failure - Returns 0 value, and sets @ERROR = 1
; User CallTip:		_Loan_Amortization( ???
; Author(s):		ptrex
; Note(s):			:
;
;===============================================================================


Msgbox(0,'Loan_Amortization ','Result is : '&_Loan_Amortization(10000,4,24) & @CR)
 
Func _Loan_Amortization($A,$B,$C)
	Local $D, $E
	If BitAND(IsNumber($A),$A>0) And BitAND(IsNumber($B),$B>0,$B<=100) And BitAND(IsInt($C),$C>0) Then ; Modified Input check
		$E=$B/100;
		$D=$A*($E/12)/(1-1/(EXP($C*LOG(1+$E/12))))
			SetError(0)
			Return $D
	Else
		SetError(1)
		Return 0
	EndIf
EndFunc ;==>_Loan_Amortization

