#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_outfile=descred8.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <image_get_info.au3>

Opt("MustDeclareVars", 0)

Const $c1 = "Dieses Programm dient zur Beschreibung von JPG-Fotos."
Const $c2 = ""
Const $c3 = "Bedienungsanleitung:"
Const $c4 = "1. Mit Taste [...] oben ein Verzeichnis mit Fotos auswählen."
Const $c5 = "2. In das Feld unten eine Beschreibung für das dargestellte Foto eingeben."
Const $c6 = "3. Mit [Weiter], Strg+{RECHTS} oder {ENTER} zum nächsten Foto im Verzeichnis"
Const $c7 = "4. Schritt 2 und 3 für alle Fotos wiederholen."
Const $c8 = "Bei jedem Foto-Wechsel wird die Beschreibung gespeichert."
Const $c9 = ""
Const $c10 = "[EXIF] oder Strg+E zeigt die Exifdaten des aktuellen Fotos"
Const $c11 = "[Undo] oder Strg+U stellt die ursprüngliche Beschreibung wieder her"
Const $c12 = "[Letzte] oder Strg+L wiederholt die letzte Beschreibung vom vorigen Foto"
Const $c13 = "[Zurück] oder Strg+{LINKS} wechselt zum vorigen Foto im Verzeichnis."
Const $c14 = ""
Const $c15 = "Viel Spaß!"

Const $wmax = 600
Const $hmax = 400

Global $t, $Form1, $lbAnleitg, $Label2, $inVerz, $btOeffVerz, $Pic1, $Button3, $inDescr, $Group1
Global $btExif, $btZurueck, $btWeiter, $btLetzte, $btUndo, $nMsg
Global $verz, $aFiles[1], $idx, $description, $prevdescr

$Form1 = GUICreate("Description für Fotos v2", 632, 540, (@DesktopWidth - 632) / 2, (@DesktopHeight - 540) / 2 - 30)
GUISetFont(10, 400, 1, "Arial")
$t = 8 ; Verz.eingabe
$inVerz = GUICtrlCreateInput("Fotoverzeichnis", 16, $t, 550, 22)
$btOeffVerz = GUICtrlCreateButton("...", 580, $t, 33, 20, $WS_GROUP)
GUICtrlSetTip($btOeffVerz, "Fotoverzeichnis öffnen")
$t = $t + 28 ;oberer Bildrand
$Pic1 = GUICtrlCreatePic("", 16, $t, $wmax, $hmax, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))
$t = $t + 100
$lbAnleitg = GUICtrlCreateLabel($c1 & @CRLF & $c2 & @CRLF & $c3 & @CRLF & $c4 & @CRLF & $c5 & @CRLF & $c6 & _
		@CRLF & $c7 & @CRLF & $c8 & @CRLF & $c9 & @CRLF & $c10 & @CRLF & $c11 & @CRLF & $c12 & @CRLF & $c13 & _
		@CRLF & $c14 & @CRLF & $c15, 70, $t, 480, 250)
$t = $t + 300
$inDescr = GUICtrlCreateInput("Fotobeschreibung", 16, $t + 25, 601, 22)
$t = $t + 58 ; Button-zeile
$btExif = GUICtrlCreateButton("EXIF", 300, $t, 42, 25, $WS_GROUP)
GUICtrlSetTip($btExif, "-Daten zeigen")
GUICtrlSetState(-1, $GUI_DISABLE)
$btUndo = GUICtrlCreateButton("Undo", 388, $t, 42, 25, $WS_GROUP)
GUICtrlSetTip($btLetzte, "Beschreibung wiederherstellen")
GUICtrlSetState(-1, $GUI_DISABLE)
$btLetzte = GUICtrlCreateButton("Letzte", 438, $t, 42, 25, $WS_GROUP)
GUICtrlSetTip($btLetzte, "Letzte Beschreibung wiederholen")
GUICtrlSetState(-1, $GUI_DISABLE)
$btZurueck = GUICtrlCreateButton("Zurück", 530, $t, 42, 25, $WS_GROUP)
GUICtrlSetTip($btZurueck, "Beschreibung speichern" & @CRLF & "und zurück im Fotoverz.")
GUICtrlSetState(-1, $GUI_DISABLE)
$btWeiter = GUICtrlCreateButton("Weiter", 580, $t, 42, 25, $BS_DEFPUSHBUTTON)
GUICtrlSetTip($btWeiter, "Beschreibung speichern" & @CRLF & "und weiter im Fotoverz.")
GUICtrlSetState(-1, $GUI_DISABLE)
$Label2 = GUICtrlCreateLabel("", 16, $t + 5, 265, 25) ; Anzeigen des Dateinamens des Fotos
Dim $AccelKeys[5][2]=[["^u", $btUndo],["^e", $btExif],["^l", $btLetzte],["^{RIGHT}", $btWeiter], ["^{LEFT}", $btZurueck]]
GUISetAccelerators($AccelKeys)

GUISetState(@SW_SHOW)


TastenStatus()
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		Case $btOeffVerz
			OeffneVerz()
			TastenStatus()
		Case $btExif
			ZeigeExif()
		Case $btZurueck ;
			VorigesFoto()
		Case $btWeiter ;
			NaechstesFoto()
		Case $btLetzte ;
			Letzte()
		Case $btUndo ;
			GUICtrlSetData($inDescr, $description)
			SetzeCursor()
	EndSwitch
WEnd
;-----------------------------------------

Func Letzte()
	GUICtrlSetData($inDescr, $prevdescr)
	SetzeCursor()
EndFunc

Func debug($msg)
	MsgBox(0, "DEBUG", $msg)
EndFunc   ;==>debug

Func OeffneVerz()
	Local $search, $file
	$verz = FileSelectFolder("Verzeichnis mit Fotos wählen", "", 4, $verz, $Form1)
	GUICtrlSetData($inVerz, $verz)
	ReDim $aFiles[1]
	$description = ""
	FileChangeDir($verz)
	$search = FileFindFirstFile("*.jpg")
	If $search = -1 Then
		MsgBox(0, "", "Kein JPG-Foto im ausgewähltem Verzeichnis", 5)
	Else
		While 1
			$file = FileFindNextFile($search)
			If @error Then ExitLoop
			_ArrayInsert($aFiles, UBound($aFiles), $file)
		WEnd
		FileClose($search)
		_ArraySort($aFiles)
		$idx = 1
		GUICtrlDelete($lbAnleitg)
		ZeigeFoto()
	EndIf
EndFunc   ;==>OeffneVerz

Func TastenStatus()
	If $idx > 0 Then
		GUICtrlSetState($btExif, $GUI_ENABLE)
		GUICtrlSetState($btZurueck, $GUI_ENABLE)
		GUICtrlSetState($btWeiter, $GUI_FOCUS) ; sonst funkt. {ENTER} nicht
		GUICtrlSetState($btWeiter, $GUI_ENABLE)
		GUICtrlSetState($btLetzte, $GUI_ENABLE)
		GUICtrlSetState($btUndo, $GUI_ENABLE)
	Else
		GUICtrlSetState($btExif, $GUI_DISABLE)
		GUICtrlSetState($btZurueck, $GUI_DISABLE)
		GUICtrlSetState($btWeiter, $GUI_DISABLE)
		GUICtrlSetState($btLetzte, $GUI_DISABLE)
		GUICtrlSetState($btUndo, $GUI_DISABLE)
		GUICtrlSetState($btOeffVerz, $GUI_FOCUS)
	EndIf
EndFunc   ;==>TastenStatus

Func VorigesFoto()
	AktualDescription()
	If $idx > 1 Then
		$idx = $idx - 1
		ZeigeFoto()
	Else
		ZeigeFoto()
		MsgBox(0, "", "Erstes Foto im Verzeichnis", 1)
		TastenStatus()
	EndIf
EndFunc   ;==>VorigesFoto

Func NaechstesFoto()
	AktualDescription()
	If $idx < UBound($aFiles) - 1 Then
		$idx = $idx + 1
		ZeigeFoto()
	Else
		ZeigeFoto()
		MsgBox(0, "", "Letztes Foto im Verzeichnis", 1)
		TastenStatus()
	EndIf
EndFunc   ;==>NaechstesFoto

Func ZeigeFoto()
	Local $aInfo,$ew,$eh,$w,$h,$f,$x,$y
	$aInfo =_ImageGetInfo($aFiles[$idx])
	$ew = _ImageGetParam($aInfo, "Width")
	If $ew=0 Then $ew=$wmax
	$eh = _ImageGetParam($aInfo, "Height")
	If $eh=0 Then $eh=$hmax
	$f=$ew/$eh
	If $f>= $wmax/$hmax Then ;landscape
		$w=$wmax
		$h=$eh*$wmax/$ew
	Else                     ;portrait
		$h=$hmax
		$w=$ew*$hmax/$eh
	EndIf
	$x=16+($wmax-$w)/2
	$y=40+($hmax-$h)/2

	GUICtrlDelete($Pic1)
	$Pic1 = GUICtrlCreatePic("", $x, $y, $w, $h, BitOR($SS_NOTIFY, $WS_GROUP, $WS_CLIPSIBLINGS))



	GUICtrlSetData($Label2, $idx & "/" & UBound($aFiles) - 1 & "  " & $aFiles[$idx])
	GUICtrlSetImage($Pic1, $aFiles[$idx])
	LeseDescription()
	GUICtrlSetData($inDescr, $description)
	SetzeCursor()
EndFunc   ;==>ZeigeFoto

Func SetzeCursor()
	GUICtrlSetState($inDescr, $GUI_FOCUS)
	Sleep(100)
	Send("{END}")
EndFunc   ;==>SetzeCursor




Func FotoLoeschen()
	If MsgBox(4 + 32 + 256 + 262144, "", "Sicher?" & @CR & "Soll dieses Foto gelöscht werden?") = 6 Then
		FileDelete($aFiles[$idx])
		_ArrayDelete($aFiles, $idx)
		ZeigeFoto()
	EndIf
EndFunc   ;==>FotoLoeschen

Func LeseDescription() ;Beschreibung auslesen und in Formular eintragen
	Local $DescriptionR, $line, $p
	$DescriptionR = FileOpen("descript.ion", 0)
	If $DescriptionR <> -1 Then
		While 1
			$line = FileReadLine($DescriptionR)
			If @error = -1 Then ; bis zum EOF keine Beschreibung gefunden
				$description = ""
				ExitLoop ;
			Else
				If StringInStr($line, Chr(34), 2, 1, 2) Then ; Dateiname enthält '"'
					$p = StringInStr($line, Chr(34) & Chr(32)) + 1 ; Pos. nach '" '
				Else
					$p = StringInStr($line, Chr(32)) ; Pos. nach " "
				EndIf
				If StringInStr(StringLeft($line, $p), $aFiles[$idx]) Then
					$description = StringTrimLeft($line, $p)
					ExitLoop ; Beschreibung gefunden
				EndIf
			EndIf
		WEnd
		FileClose($DescriptionR)
	EndIf
EndFunc   ;==>LeseDescription

Func AktualDescription() ; EXIF auch Aktualisieren
	Local $DescriptionR, $DescriptionW, $newdescr, $fname, $line, $p, $attrib
	$newdescr = GUICtrlRead($inDescr)
	$prevdescr = $newdescr
	If $newdescr <> $description Then
		$DescriptionW = FileOpen("descript.new", 1)
		If $DescriptionW = -1 Then
			MsgBox(16, "Fehler", "Kann keine Beschreibungen speichern!" & @CRLF & "Ist das Fotoverzeichnis etwa schreibgeschützt?")
			Exit
		EndIf
		$fname = $aFiles[$idx]
		If StringInStr($fname, Chr(32)) Then $fname = Chr(34) & $fname & Chr(34) ;Dateiname mit Leerzeichen zwischen "" setzen
		If FileExists("descript.ion") Then
			$DescriptionR = FileOpen("descript.ion", 0)
			$attrib = FileGetAttrib("descript.ion")
			FileSetAttrib("descript.ion", "-RSH")
			While 1
				$line = FileReadLine($DescriptionR)
				If @error = -1 Then ; EOF
					ExitLoop ;
				Else
					If StringInStr($line, Chr(34), 2, 1, 2) Then ; Dateiname enthält '"'
						$p = StringInStr($line, Chr(34) & Chr(32)) + 1 ; Pos. nach '" '
					Else
						$p = StringInStr($line, Chr(32)) ; Pos. nach " "
					EndIf
					If Not StringInStr(StringLeft($line, $p), $aFiles[$idx]) Then
						FileWriteLine($DescriptionW, $line)
					EndIf
				EndIf
			WEnd
			FileClose($DescriptionR) ;descript.ion
		EndIf
		FileWriteLine($DescriptionW, $fname & Chr(32) & $newdescr)
		FileClose($DescriptionW) ;descript.new
		FileMove("descript.new", "descript.ion", 1) ; mit Überschreiben
		If $attrib = "" Then $attrib = "H" ; Hidden-Attribut setzen
		FileSetAttrib("descript.ion", "+" & $attrib)
	EndIf
EndFunc   ;==>AktualDescription

Func ZeigeExif()
	GUICtrlSetState($btExif, $GUI_DISABLE)
	GUICtrlSetState($btZurueck, $GUI_DISABLE)
	GUICtrlSetState($btWeiter, $GUI_DISABLE)
	GUICtrlSetState($btLetzte, $GUI_DISABLE)
	GUICtrlSetState($btUndo, $GUI_DISABLE)
	MsgBox(0, "EXIF", _ImageGetInfo($aFiles[$idx]))
	TastenStatus()
EndFunc   ;==>ZeigeExif


