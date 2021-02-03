#cs ----------------------------------------------------------------------------

 AutoIt Version: 	3.3.0.0
 Script:		 	get_id
 Date:			 	5 Oct 2009
 Author: 		 	Adams
 Script Function:	restituisce nuovo id

History:
1.1.0	19/10/2009	gestione cartella della tabella
1.0.0	05/10/2009	usate variabili locali in luogo di variabili globali
0.1.0	05/10/2009	beta iniziale

#ce ----------------------------------------------------------------------------

Func _get_id($Table, $Table_Dir)
	Local $Sequence = $Table_Dir & "\" & $Table & "_sequence.dat"
	Local $Sequence_id = 0
	If FileExists($Sequence) Then
		Local $Handle_Sequence_R = FileOpen($Sequence, 0)
		If $Handle_Sequence_R = -1 Then   ; Check if file opened for reading OK
			MsgBox(0, "Errore", "Non è possibile aprire la sequenza.")
			Exit
		EndIf
		While 1
			$Sequence_id = FileReadLine($Handle_Sequence_R)
			If @error = -1 Then ExitLoop
			If $Sequence_id <> 0 Then ExitLoop
		WEnd
		FileClose($Handle_Sequence_R)
	EndIf

	$Sequence_id += 1

	Local $Handle_Sequence_W = FileOpen($Sequence, 2)
	If $Handle_Sequence_W = -1 Then   ; Check if file opened for reading OK
		MsgBox(0, "Errore", "Non è possibile aprire la sequenza.")
		Exit
	EndIf
	FileWriteLine($Handle_Sequence_W, $Sequence_id)
	FileClose($Handle_Sequence_W)

	Return $Sequence_id
EndFunc

