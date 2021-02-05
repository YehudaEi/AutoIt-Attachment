#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.0
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Parte iniziale
$capitale = 100
MsgBox(64, "Lancio della moneta", "Devi guadagnare almeno $1 al lancio della moneta. Ti sono stati prestati $100. Parteciperai a 3 giocate.")
$scommessa = InputBox("Quanto scommetti?", "Quanto hai intenzione di scommettere?")
; Viene chiesto l'esito atteso
$previsto = MsgBox(4, "Esito atteso", "Quale esito ti aspetti? Scegli Sì se pensi esca Croce, No se pensi esca Testa.") - 6
; Lancio della moneta;
$esito = Random(0, 10) + Random(0, 10); Assegna un numero da 0 a 1 alla variante $esito
If $esito <= 10 Then
	MsgBox(64, "Croce", "L'esito è: Croce.")
	$testacroce = 0
Else
	MsgBox(64, "Testa", "L'esito è: Testa.")
	$testacroce = 1
EndIf
; Comunicazione: hai vinto o hai perso
If $previsto + $testacroce = 0 Then
	MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Croce ed è uscito Croce.")
	; Vengono aggiunti i soldi della scommessa
	$capitale = $capitale + $scommessa
Else
	If $previsto + $testacroce = 2 Then
		MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Testa ed è uscito Testa.")
		; Vengono aggiunti i soldi della scommessa
		$capitale = $capitale + $scommessa
	Else 
		MsgBox(64, "Hai vinto?", "Hai Perso!!!")
		; Si perdono i soldi scommessi
		$capitale = $capitale - $scommessa
	EndIf
EndIf

;2o lancio
MsgBox(1, "Capitale attuale", "Il tuo capitale attuale è $" & $capitale & ".")
$scommessa = InputBox("Quanto scommetti?", "Quanto hai intenzione di scommettere?")
; Viene chiesto l'esito atteso
$previsto = MsgBox(4, "Esito atteso", "Quale esito ti aspetti? Scegli Sì se pensi esca Croce, No se pensi esca Testa.") - 6
; Lancio della moneta;
$esito = Random(0, 10) + Random(0, 10); Assegna un numero da 0 a 1 alla variante $esito
If $esito <= 10 Then
	MsgBox(64, "Croce", "L'esito è: Croce.")
	$testacroce = 0
Else
	MsgBox(64, "Testa", "L'esito è: Testa.")
	$testacroce = 1
EndIf
; Comunicazione: hai vinto o hai perso
If $previsto + $testacroce = 0 Then
	MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Croce ed è uscito Croce.")
	; Vengono aggiunti i soldi della scommessa
	$capitale = $capitale + $scommessa
Else
	If $previsto + $testacroce = 2 Then
		MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Testa ed è uscito Testa.")
		; Vengono aggiunti i soldi della scommessa
		$capitale = $capitale + $scommessa
	Else 
		MsgBox(64, "Hai vinto?", "Hai Perso!!!")
		; Si perdono i soldi scommessi
		$capitale = $capitale - $scommessa
	EndIf
EndIf

; 3o lancio
MsgBox(1, "Capitale attuale", "Il tuo capitale attuale è $" & $capitale & ".")
$scommessa = InputBox("Quanto scommetti?", "Quanto hai intenzione di scommettere?")
; Viene chiesto l'esito atteso
$previsto = MsgBox(4, "Esito atteso", "Quale esito ti aspetti? Scegli Sì se pensi esca Croce, No se pensi esca Testa.") - 6
; Lancio della moneta;
$esito = Random(0, 10) + Random(0, 10); Assegna un numero da 0 a 1 alla variante $esito
If $esito <= 10 Then
	MsgBox(64, "Croce", "L'esito è: Croce.")
	$testacroce = 0
Else
	MsgBox(64, "Testa", "L'esito è: Testa.")
	$testacroce = 1
EndIf
; Comunicazione: hai vinto o hai perso
If $previsto + $testacroce = 0 Then
	MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Croce ed è uscito Croce.")
	; Vengono aggiunti i soldi della scommessa
	$capitale = $capitale + $scommessa
Else
	If $previsto + $testacroce = 2 Then
		MsgBox(64, "Hai vinto?", "Hai Vinto!!! Hai previsto Testa ed è uscito Testa.")
		; Vengono aggiunti i soldi della scommessa
		$capitale = $capitale + $scommessa
	Else 
		MsgBox(64, "Hai vinto?", "Hai Perso!!!")
		; Si perdono i soldi scommessi
		$capitale = $capitale - $scommessa
	EndIf
EndIf

; Comunicazione punteggio
MsgBox(1, "Capitale attuale", "Il tuo capitale attuale è $" & $capitale & ".")
MsgBox(1, "Hai finito la partita", "Hai finito la partita.")
If $capitale > 100 Then
	MsgBox(1, "Hai Vinto il gioco", "Bravo! Hai guadagnato $" & $capitale - 100 & ".")
Else
	If $capitale = 100 Then
		MsgBox(1, "Hai 'pareggiato'!", "Hai 'pareggiato': non hai debiti, ma non hai nemmeno guadagnato denaro.")
	Else
		MsgBox(1, "Hai Perso!!!", "Hai Perso!!! Hai iniziato il gioco con $100, e adesso hai $ " & 100 - $capitale & " di debiti!")
	EndIf
EndIf