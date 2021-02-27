#include <Date.au3>

Global $d_date
Global $language


; #FUNCTION# ====================================================================================================================
; Name...........: _WhatDayIsIt
; Description ...: Tells the name of the day on a specified date.
; Syntax.........: _WhatDayIsIt($date)
; Parameters ....: $date, date format yyyy/mm/dd
;                  $language: - English = eng
;                             - French = fra
;                             - German = ger
;                             - Hungarian = hun
;                             - Italian = ita
;                             - Portuguese = por
;                             - Romanian = rom
;                             - Spanish = esp
; Return values .: Success - Returns a string
;                  Failure - Returns null string and sets @error to 1.
; Author ........: Gery Nagy
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================


Func _WhatDayIsIt($d_date, $language)

	$ref_date = "1999/12/26 00:00:01"
	$dif = _DateDiff("D", $ref_date, $d_date)
	$daynr = Mod($dif, 7)
	$dayname = _DateDayOfWeek($daynr + 1)

	If $language = "eng" then $dayname = $dayname

	If $language = "hun" Then
		If $dayname = "Monday" Then $dayname = "Hétfõ"
		If $dayname = "Tuesday" Then $dayname = "Kedd"
		If $dayname = "Wednesday" Then $dayname = "Szerda"
		If $dayname = "Thursday" Then $dayname = "Csütörtök"
		If $dayname = "Friday" Then $dayname = "Péntek"
		If $dayname = "Saturday" Then $dayname = "Szombat"
		If $dayname = "Sunday" Then $dayname = "Vasárnap"
	EndIf

	If $language = "rom" Then
		If $dayname = "Monday" Then $dayname = "Luni"
		If $dayname = "Tuesday" Then $dayname = "Marþi"
		If $dayname = "Wednesday" Then $dayname = "Miercuri"
		If $dayname = "Thursday" Then $dayname = "Joi"
		If $dayname = "Friday" Then $dayname = "Vineri"
		If $dayname = "Saturday" Then $dayname = "Sâmbãtã"
		If $dayname = "Sunday" Then $dayname = "Duminicã"
	EndIf

	If $language = "ger" Then
		If $dayname = "Monday" Then $dayname = "Montag"
		If $dayname = "Tuesday" Then $dayname = "Dienstag"
		If $dayname = "Wednesday" Then $dayname = "Mittwoch"
		If $dayname = "Thursday" Then $dayname = "Donnerstag"
		If $dayname = "Friday" Then $dayname = "Freitag"
		If $dayname = "Saturday" Then $dayname = "Samstag"
		If $dayname = "Sunday" Then $dayname = "Sonnstag"
	EndIf

	If $language = "fra" Then
		If $dayname = "Monday" Then $dayname = "Lundi"
		If $dayname = "Tuesday" Then $dayname = "Mardi"
		If $dayname = "Wednesday" Then $dayname = "Mercredi"
		If $dayname = "Thursday" Then $dayname = "Jeudi"
		If $dayname = "Friday" Then $dayname = "Vendredi"
		If $dayname = "Saturday" Then $dayname = "Samedi"
		If $dayname = "Sunday" Then $dayname = "Dimanche"
	EndIf

	If $language = "ita" Then
		If $dayname = "Monday" Then $dayname = "Lunedi"
		If $dayname = "Tuesday" Then $dayname = "Martedi"
		If $dayname = "Wednesday" Then $dayname = "Mercoledi"
		If $dayname = "Thursday" Then $dayname = "Giovedi"
		If $dayname = "Friday" Then $dayname = "Venerdi"
		If $dayname = "Saturday" Then $dayname = "Sabato"
		If $dayname = "Sunday" Then $dayname = "Domenica"
	EndIf

	If $language = "esp" Then
		If $dayname = "Monday" Then $dayname = "Lunes"
		If $dayname = "Tuesday" Then $dayname = "Martes"
		If $dayname = "Wednesday" Then $dayname = "Miércoles"
		If $dayname = "Thursday" Then $dayname = "Jueves"
		If $dayname = "Friday" Then $dayname = "Viernes"
		If $dayname = "Saturday" Then $dayname = "Sábado"
		If $dayname = "Sunday" Then $dayname = "Domingo"
	EndIf

	If $language = "por" Then
		If $dayname = "Monday" Then $dayname = "Segunda-feira"
		If $dayname = "Tuesday" Then $dayname = "Terça-feira"
		If $dayname = "Wednesday" Then $dayname = "Quarta-feira"
		If $dayname = "Thursday" Then $dayname = "Quinta-feira"
		If $dayname = "Friday" Then $dayname = "Sexta-feira"
		If $dayname = "Saturday" Then $dayname = "Sábado"
		If $dayname = "Sunday" Then $dayname = "Domingo"
	EndIf

	Return $dayname
EndFunc   ;==>_WhatDayIsIt
