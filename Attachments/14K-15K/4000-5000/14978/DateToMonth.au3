;===============================================================================
;
; Description:      Returns the name of the month, based on the specified month number.
; Parameter(s):     $iMonthNum - Month number

; Requirement(s):   None
; Return Value(s):  On Success - Month name
;                   On Failure - A NULL string and sets @ERROR = 1
; Author(s):        Jason Brand <exodius at gmail dot com>
;					(Format based on _DateDayOfWeek by Jeremy Landes)
; Note(s):          English only
;
;===============================================================================
Func _DateToMonth($iMonthNum)
	;==============================================
	; Local Constant/Variable Declaration Section
	;==============================================
	Local $aMonthNumber[13]
	
	$aMonthNumber[1] = "January"
	$aMonthNumber[2] = "February"
	$aMonthNumber[3] = "March"
	$aMonthNumber[4] = "April"
	$aMonthNumber[5] = "May"
	$aMonthNumber[6] = "June"
	$aMonthNumber[7] = "July"
	$aMonthNumber[8] = "August"
	$aMonthNumber[9] = "September"
	$aMonthNumber[10] = "October"
	$aMonthNumber[11] = "November"
	$aMonthNumber[12] = "December"
	Select
		Case Not StringIsInt($iMonthNum)
			SetError(1)
			Return ""
		Case $iMonthNum < 1 Or $iMonthNum > 12
			SetError(1)
			Return ""
		Case Else
			Return $aMonthNumber[$iMonthNum]
	EndSelect
EndFunc   ;==>_DateToMonth