;------------------------------------------------------------------------------------------------------------------------
Func fInvalidFileName($strIN)
; Controlla che la stringa ricevuta rispetti la sintassi ammessa per i nomi dei file.
; Restituisce 0 (falso) se il parametro ricevuto è sintatticamente corretto;
;             o (vero) indicato con una qualsiasi stringa uguale al parametro ricevuto privato dei caratteri non ammessi.
;------------------------------------------------------------------------------------------------------------------------
	Local $carNO = '\/:*?"<>|'
	Local $i, $strOUT = ""
	For $i=1 To StringLen($strIN)
		If StringInStr($carNO, StringMid($strIN, $i, 1)) = 0 Then $strOUT = $strOUT & StringMid($strIN, $i, 1)
	Next
	If $strOUT==$strIN Then
		Return 0
	Else
		Return $strOUT
	EndIf
EndFunc
