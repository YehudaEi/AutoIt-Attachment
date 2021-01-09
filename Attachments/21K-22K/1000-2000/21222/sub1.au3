#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.8.1
 Author:         myName

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; __GET PATHS
$SPLIT_DATE = StringSplit($a_DATE_FENSTER, "/")
$YEAR=$SPLIT_DATE[1]
$MON=$SPLIT_DATE[2]
$DAY=$SPLIT_DATE[3]
$a_DATE_FENSTER=$SPLIT_DATE[1]&$SPLIT_DATE[2]&$SPLIT_DATE[3]

;MSgBox(4096, "mon", $MON, 10)



;Read Global Counter
$a_Counter = IniRead($counterfile, "count", "Count", "NotFound")
;Dateinamen zusammensetzen
;MSgBox(4096, "Counter", $a_Counter, 10)
$neuer_dateiname=$a_Dokumentenart & "-" & $Firmenkuerzel &  "-" & $YEAR & "-" & $MON & "-" & StringLeft($a_Autor, 1) & "-" & $a_Autor & "-" & $a_Number & "-" & $a_DATE_FENSTER & "-" & $a_Counter & ".pdf"
;MSgBox(4096, "neuer dateiname", $neuer_dateiname, 10)
;gehört nur bei folgenden dokumentenarten
If $a_Dokumentenart="ERG" Then
	$a_ST = (1 + $a_Steuersatz)
	$a_NETTOBETRAG = ($a_BRUTTOBETRAG / $a_ST)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_ERG, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY &  ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & $a_NETTOBETRAG & ";" & "\\DATA_BH" & "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF)
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
Elseif $a_Dokumentenart="ARG" Then
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_ARG, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY &  ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & "\\DATA_BH" & "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF )
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
ElseIf $a_Dokumentenart="BAS" Then
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_BAS, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY & ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & "\\DATA_BH"& "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF )
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
ElseIf $a_Dokumentenart="CRE" Then
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_CRE, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY &  ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & "\\DATA_BH"& "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF )
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
ElseIf $a_Dokumentenart="BUE" Then
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_BUE, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY &  ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & "\\DATA_BH"& "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF )
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
ElseIf $a_Dokumentenart="KAS" Then
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\MONAT\" & $MON & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\" & $a_Dokumentenart & "\A-Z\" & StringLeft($a_Autor, 1) & "\" & $neuer_dateiname , 8)
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	$Csvdatei=FileOpen($DOKLW & "\" & $CSV_KAS, 1)
	FileWriteLine ( $Csvdatei, $a_Dokumentenart & ";" & $YEAR & "." & $MON & "." & $DAY &  ";" & $a_Number & ";" & $a_Autor & ";" & $a_Steuersatz & ";" & $a_BRUTTOBETRAG  & ";" & "\\DATA_BH"& "\"& $a_Dokumentenart & "\" & "MONAT\" & $MON & "\" & $neuer_dateiname & @CRLF )
	FileClose($CSVDATEI)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
Else
	;bei allen anderen dokumentenarten folgende kopien
	;if $a_dokumentenart=rest or
	FileCopy ( $DATENDIR, $DOKLW & "\Autor\" & $a_Autor & "\" & $neuer_dateiname , 8)
	;gehört immer als sicherungskopie
	Filecopy ( $DATENDIR, $Sicherungslw & "\" & $neuer_dateiname , 8)
	MSgBox(4096, "Kopien", $neuer_dateiname  & " erstellt!", 10)
EndIf

$SPLIT_DATENDIR=StringSplit($DATENDIR, "\")
$FILENAME= $SPLIT_DATENDIR[$SPLIT_DATENDIR[0]]
;MSgBox(4096, "filename", $FILENAME, 10)
FileMove ( $DATENDIR, $DoneLW & "\" & $FILENAME , 8 )



;globalen Counter raufzählen
$a_Counter=$a_Counter+1
IniWrite ($Counterfile, "count","count", $a_counter)
_GUICtrlStatusBar_SetText($StatusBar1, "Filecopy finished", 1)
