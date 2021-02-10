;EDIT 8.2.2010
;Bugs entfernt, Funktionen hinzugefügt
;Info auf http://wiki.services.openoffice.org/wiki/Spreadsheet_common
;
;Example & Functions

#include <Array.au3>
AutoItSetOption("WinTitleMatchMode", 2)
$oMyError = ObjEvent("AutoIt.Error", "_OOErrFunc") ; Implementiert einen eigenen Error-Handler


Dim $OpenPar[3];,$cellkoord[2]

Global $setOOoProp, $oSheet, $odoc, $oDesk, $osm, $oCell, $errormodul
Global $cellkoord[2]

$summe = 0
$file = @ScriptDir & "\testcalc1"

;*****************************************************
;*************************DEMO START******************
;*****************************************************

MsgBox(0, "Demo OpenOffice CALC-Functions", "Starting OpenOffice...", 2)
_OOInit() ;verbindung zu openoffice

MsgBox(0, "Demo OpenOffice CALC-Functions", "Create a new Book", 2)
_OOAddNewBook() ;testdatei erstellen

winwait("OpenOffice")
;WinSetState("OpenOffice","",@SW_MAXIMIZE)
WinActivate("OpenOffice", "")

if WinActive("OpenOffice", "")=0 then  ;sometimes the OO-window is not activated automatically ...
	msgbox(262144, 	"Demo OpenOffice CALC-Functions", _
					"AutoIt can´t activate the OpenOffice-Window!" & @CRLF & _
					"Please activate the OpenOffice-Window and press OK")
endif
If WinActive("OpenOffice", "")=0 then exit

MsgBox(0, "OpenOffice Calc Demo", "Write some Text and Data into the sheet...", 4)

_OOSheetSetCell(0, 0, "Tabellentest") ;man kann die Zellen entweder mit Reihe und Spalte ansprechen...
_OOSheetSetCellColor(0, 0, 0x0000FF, 0x00FF00) ;Vordergrundfarbe und Hintergrundfarbe in 0xRRGGBB
_OOSheetSetCell("A2", 0, "===================") ;...oder mit direkter Adresse
_OOSheetSetCellColor("A2", 0, 0x000000, 0xFF0000)
For $col = 1 To 5 ;testdaten auf 1. Tabelle anlegen
	For $row = 2 To 4
		_OOSheetSetCell($col, $row, Int(Random(10, 1000)), "value") ;diesmal werdem zahlen geschrieben
	Next
Next

MsgBox(262144, "OpenOffice Calc Demo", "Transfer some Data from an AutoIt-Array to the sheet...please close the following window to continue the demo", 4)
Dim $array[3][2] = [[11, 12],[13, 14],["TEST", 15]]  ;ein zweidimensionales array erstellen
_ArrayDisplay($array,"Testarray (pls close by hand)")
_OOSheetArrayToRange(0, "B7", $array) ;schreibt das Array an die Position der Zelle


MsgBox(262144, "OpenOffice Calc Demo", "Transfer some Data to an AutoIt-Array...please close the following windows to continue the demo", 4)
$array = _OOSheetRangetoArray(0, "c3", "h5", "")
_ArrayDisplay($array, "Array with data C3:H5 (pls close by hand)")
$array = _OOSheetRangetoArray(0, "A1", "A1", "ALL")
_ArrayDisplay($array, "Array with all data (pls close by hand)")

MsgBox(262144, "OpenOffice Calc Demo", "Add a new sheet but the Focus is still on the actual sheet...", 5)

_OOBookAddNewSheet("NeueTabelle") ;neues Tabellenblatt erstellen
_OOSheetActivate("NeueTabelle", 0) ;die folgenden Daten werden ins neue Tabellenblatt geschrieben, der Fokus ist aber immer noch bei Tabelle1
_OOSheetActivate(3, 0) ;macht genau dasselbe, entweder die Tabellennummer oder den Namen angeben

MsgBox(262144, "OpenOffice Calc Demo", "Copy some content from the actual sheet to the new sheet...", 5)

_OOSheetMoveOrCopyRange(0, "B3:c6", "NeueTabelle", "C2", 1) ;Bereiche  werden entweder kopiert oder verschoben
_OOSheetSetCell(0, 0, "Gesamtsumme Daten aus " & _OONameOfActiveSheet())

MsgBox(262144, "OpenOffice Calc Demo", "Activate the new sheet...", 4)

_OOSheetActivate(3, 1) ;auf diese Tabelle wechseln

MsgBox(262144, "OpenOffice Calc Demo", "Searching for some numbers, color these cells, and add them with a formula...", 6)

For $col = 2 To 3 ;Tabellenbereich nach zahlen durchsuchen...
	For $row = 1 To 3
		If _OOSheetGetCellType($col, $row) = "VALUE" Then ;..und wenn gefunden
			$summe = $summe + _OOSheetGetCellValue($col, $row) ;..zusammenzählen
			_OOSheetSetCellColor($col, $row, 0x0000FF, 0x00FF00) ;Vordergrundfarbe und Hintergrundfarbe in 0xRRGGBB
		EndIf
	Next
Next

_OOSheetSetCell(2, 6, "Summe aller Zahlen:", "string") ;string in Tabelle schreiben
_OOSheetSetCell(3, 6, $summe, "value") ;wert in Tabelle schreiben
_OOSheetSetCell(2, 8, "SUM(D2:D4)--->", "string") ;string
_OOSheetSetCell(3, 8, "=SUM(D2:D4)", "formula") ;oder Formel schreiben

MsgBox(262144, "OpenOffice Calc Demo", "set width of first column to optimum and second column to 10mm...", 6)
_OOSheetSetcolProperties(0, 5000, True, True, True) ;erste spalte verbreitern optimum
_OOSheetSetRowColor(0, 0xFF00F0, 0xF0FFF0)
_OOSheetSetcolProperties(1, 1000, False, True, False) ;zweite spalte verbreitern
_OOSheetSetcolProperties(2, 5000, True, True, False) ;dritte spalte verbreitern optimum

MsgBox(262144, "OpenOffice Calc Demo", "Delete 8th row ...", 4)
_OOSheetdeleteRow(7, 1)
MsgBox(262144, "OpenOffice Calc Demo", "Insert 3 rows ...", 4)
_OOSheetinsertRow(4, 3)

MsgBox(262144, "OpenOffice Calc Demo Store", "Save the Book in:" & @CRLF & ".ods  OOffice-Format" & @CRLF & ".xls   MS Excel 97" & @CRLF & ".pdf     calc_pdf_Export" & @CRLF & ".txt    Text - txt - csv (StarCalc)" & @CRLF & ".html    HTML (StarCalc)", 5)

;speichern in verschiedenen Formaten
_OOStoreBook($file & ".ods") ;speichern im OOcalc-format
_OOStoreBook($file & ".xls", "MS Excel 97")
_OOStoreBook($file & ".pdf", "calc_pdf_Export")
_OOStoreBook($file & ".txt", "Text - txt - csv (StarCalc)")
_OOStoreBook($file & ".html", "HTML (StarCalc)")
_OOCloseBook()

MsgBox(262144, "OpenOffice Calc Demo", "Show the stored files...", 5)
ShellExecute($file & ".pdf")
MsgBox(262144, "OpenOffice Calc Demo PDF", "Press OK")
ShellExecute($file & ".txt")
MsgBox(262144, "OpenOffice Calc Demo TXT", "Press OK")
ShellExecute($file & ".html")
MsgBox(262144, "OpenOffice Calc Demo HTML", "Press OK")

Exit
;*****************************************************
;********************DEMO END*************************
;*****************************************************


;Functions

Func _OOSetProp($cName, $uValue) ;Eigenschaften in struct übergeben
	$errormodul = "_OOSetProp"
	$osm = ObjCreate("com.sun.star.ServiceManager")
	$oPropertyValue = $osm.Bridge_GetStruct("com.sun.star.beans.PropertyValue")
	$oPropertyValue.Name = $cName
	$oPropertyValue.Value = $uValue
	$setOOoProp = $oPropertyValue
	Return $setOOoProp
EndFunc   ;==>_OOSetProp

Func _OOInit($pass = "", $readonly = False, $hidden = False) ;verbindung zu OO herstellen
	$errormodul = "_OOINIT"
	$osm = ObjCreate("com.sun.star.ServiceManager")
	$oDesk = $osm.createInstance("com.sun.star.frame.Desktop")
	$OpenPar[0] = _OOSetProp("ReadOnly", $readonly)
	$OpenPar[1] = _OOsetProp("Password", $pass) ;setzt das passwort des dokuments
	$OpenPar[2] = _OOsetProp("Hidden", $hidden)
EndFunc   ;==>_OOInit

Func _OOAddNewBook() ; neue Tabellendatei erstellen
	$errormodul = "_OOAddNewBook"
	$odoc = $oDesk.loadComponentFromURL("private:factory/scalc", "_blank", 0, $OpenPar)
	$oSheet = $odoc.CurrentController.ActiveSheet
EndFunc   ;==>_OOAddNewBook

Func _OOOpenFile($fname) ; bestehende *.Datei öffnen, OO importiert mit Filter wenn möglich
	$errormodul = "_OOOpenFile"
	$fname = StringReplace($fname, ":", "|")
	$fname = StringReplace($fname, " ", "%20")
	$fname = "file:///" & StringReplace($fname, "\", "/")
	$odoc = $oDesk.loadComponentFromURL($fname, "_blank", 0, $OpenPar)
EndFunc   ;==>_OOOpenFile

Func _OOOpenBook($fname) ; bestehende Tabellendatei öffnen
	$errormodul = "_OOOpenBook"
	$fname = StringReplace($fname, ":", "|")
	$fname = StringReplace($fname, " ", "%20")
	$fname = "file:///" & StringReplace($fname, "\", "/")
	$odoc = $oDesk.loadComponentFromURL($fname, "_blank", 0, $OpenPar)
	$oSheet = $odoc.CurrentController.ActiveSheet ;auskommentieren, um alle importierbaren Formate zu öffnen
EndFunc   ;==>_OOOpenBook

Func _OOStoreBook($fname, $filter = "StarOffice XML (Calc)") ;speichert Datei , angewandt wird der Dateifilter
	;Alle EXPORT-Filter von dieser Page sind anwendbar, es gelten die internen Namen!
	;http://wiki.services.openoffice.org/wiki/Framework/Article/Filter/FilterList_SO_7
	$errormodul = "_OOStoreBook"
	$fname = StringReplace($fname, ":", "|")
	$fname = StringReplace($fname, " ", "%20")
	$fname = "file:///" & StringReplace($fname, "\", "/")
	;MsgBox(0, "File saved", $filter)
	$oSave = _ArrayCreate(_OOsetProp("FilterName", $filter))
	$odoc.storetourl($fname, $oSave)
EndFunc   ;==>_OOStoreBook

Func _OOSheetActivate($sheetnameornumber, $activeflag = 1) ;Tabellenname oder nummer zum schreiben/lesen aktivieren
	;mit $activeflag=1 kommt die Tabelle in den Vordergrund
	;mit $activeflag=0 wird die Tabelle verdeckt aktiviert z.B.um im Hintergrund Daten zu ändern
	$errormodul = "_OOSheetactivate"
	If IsString($sheetnameornumber) Then
		$activesheet = $odoc.sheets.getbyname($sheetnameornumber)
	Else
		$activesheet = $odoc.sheets.getbyindex($sheetnameornumber) ;index starts with 0
	EndIf

	If $activeflag = 1 Then
		$oSheet = $odoc.CurrentController.setActiveSheet($activesheet)
	EndIf
	$oSheet = $activesheet
EndFunc   ;==>_OOSheetActivate

Func _OOBookAddNewSheet($sheetname) ;erstellt neues Tabellenblatt mit dem Namen $sheetname
	$errormodul = "_OOAddNewsheet"
	$eSheets = $odoc.getSheets.createEnumeration
	$flag = 0
	While $eSheets.hasMoreElements ;abfrage, ob sheet schon existiert
		$oElement = $eSheets.nextElement()
		If $oElement = $sheetname Then $flag = 1 ;wenn ja, merken
	WEnd
	If $flag = 0 Then
		$Inst = $odoc.createInstance("com.sun.star.sheet.Spreadsheet")
		$odoc.Sheets.insertByName($sheetname, $Inst)
	EndIf
EndFunc   ;==>_OOBookAddNewSheet

Func _OOSheetGetCellValue($col, $row) ;Inhalt der Zelle bsp; "A3" oder F22
	$errormodul = "_OOSheetGetCellValue"
	If IsString($col) Then
		_OOAdress2Koord($col)
		$col = $cellkoord[0]
		$row = $cellkoord[1]
	EndIf
	$oCell = $oSheet.getCellByPosition($col, $row).value
	Return $oCell
EndFunc   ;==>_OOSheetGetCellValue

Func _OONumberOfSheets() ; Anzahl der Tabellenblätter
	$errormodul = "_OONumberofsheets"
	Return $odoc.getsheets.getcount
EndFunc   ;==>_OONumberOfSheets

Func _OOAdress2Koord($cellname) ;wandelt "C1" in $cellkoord[0]=2 und $cellkoord[1]=0
	$errormodul = "_OOAdress2Koord"
	Local $textchar[3]
	Local $numchar[3]
	$cellname = StringUpper($cellname)
	$numchar = StringRegExp($cellname, '\d+', 1) ;y-Koordinate der Zelle, findet Zahlen im Zellennamen;
	;	msgbox (0,$cellname,$textchar[0]&" "&$numchar[0])
	$cellkoord[1] = $numchar[0] - 1
	$textchar = StringRegExp($cellname, '[[:alpha:]]{0,2}', 1) ;findet A oder AA im Zellennamen
	$x = (Asc(StringMid($textchar[0], 1, 1)) - 65) ;ascii erster Buchstabe
	If StringLen($textchar[0]) = 2 Then
		$x = (($x + 1) * 26) + (Asc(StringMid($textchar[0], 2, 1)) - 65)
	EndIf
	$cellkoord[0] = $x
	Return $cellkoord
EndFunc   ;==>_OOAdress2Koord

Func _OOKoordToAddress($row,$col) ;wandelt 2,3 in "C4"
	$x = Int($col / 26)
	$y = Mod($col, 26)

	If $x = 0 Then
		$char = Chr(64 + $y) ;A B C
	Else
		$char = Chr(64 + $x) & Chr(65 + $y) ; AA AB AC...
	EndIf
	Return $char & String($row + 1)
EndFunc   ;==>_OOKoordToAddress

Func _OONameOfActiveSheet()
	$errormodul = "_OONameofAvtiveSheet"
	Return $oSheet.name
EndFunc   ;==>_OONameOfActiveSheet

Func _OOSheetSetRowProperties($row, $height, $optheight = Default, $visible = Default, $newpage = Default) ;Eigenschaften der Zeile
	; $optheight, $visible $newpage all 	OO_true or OO_False
	$errormodul = "_OOSheetSetRowProperties"
	$orow = $oSheet.getRows().getByIndex($row)
	If IsNumber($height) Then $orow.Height = $height ;column height (in 100ths of mm)
	$orow.OptimalWidth = Number($optheight)
	$orow.IsVisible = Number($visible)
	$orow.IsStartOfNewPage = Number($newpage)
EndFunc   ;==>_OOSheetSetRowProperties

Func _OOSheetSetColProperties($col, $width, $optwidth = Default, $visible = Default, $newpage = Default) ;Eigenschaften Spalte
	; $opt, $visible $newpage all OO_true or OO_False
	$errormodul = "_OOSheetSetColProperties"
	If IsString($col) Then
		$ocol = $oSheet.getColumns().getByName($col)
	Else
		$ocol = $oSheet.getColumns().getByIndex($col)
	EndIf
	$ocol.Width = $width ;column width (in 100ths of mm)
	$ocol.OptimalWidth = Number($optwidth)
	$ocol.IsVisible = Number($visible)
	$ocol.IsStartOfNewPage = Number($newpage)
EndFunc   ;==>_OOSheetSetColProperties

Func _OOSheetdeleteRow($startrow, $numberofrows = 1) ;Zeile löschen
	$errormodul = "_OOSheetDeleteRow"
	$oSheet.getrows.removeByIndex($startrow, $numberofrows)
EndFunc   ;==>_OOSheetdeleteRow

Func _OOSheetinsertRow($startrow, $numberofrows = 1) ;Zeile einfügen
	$errormodul = "_OOSheetInsertRow"
	$oSheet.getrows.insertbyindex($startrow, $numberofrows)
EndFunc   ;==>_OOSheetinsertRow

Func _OOSheetdeleteCol($startcol, $numberofcols = 1) ;Spalte löschen
	$errormodul = "_OOSheetDeleteCol"
	$oSheet.getcolumns.removeByIndex($startcol, $numberofcols)
EndFunc   ;==>_OOSheetdeleteCol

Func _OOSheetinsertCol($startcol, $numberofcols = 1) ;spalte einfügen
	$errormodul = "_OOSheetInsertCol"
	$oSheet.getcolumns.insertbyindex($startcol, $numberofcols)
EndFunc   ;==>_OOSheetinsertCol

Func _OOSheetGetCellType($row, $col) ;Rückgabe: Zellentyp: value, string, formula, empty
	$errormodul = "_OOSheetGetCellType"
	If IsString($row) Then
		$cell = _OOAdress2Koord($row)
		$row = $cell[0]
		$col = $cell[1]
	EndIf
	$oCell = $oSheet.getcellbyposition($row, $col)
	Select
		Case $oCell.type = 1
			$celltype = "VALUE"
		Case $oCell.type = 2
			$celltype = "STRING"
		Case $oCell.type = 3
			$celltype = "FORMULA"
		Case $oCell.type = 0
			$celltype = "EMPTY"
		Case Else
			$celltype = "UNKNOWN"
	EndSelect
	Return $celltype
EndFunc   ;==>_OOSheetGetCellType

Func _OOSheetMoveOrCopyRange($fromsheetnameornumber, $fromrange, $tosheetnameornumber, $tocell, $flag) ;$fromrange="B2:c4"  $tocell="F4" flag: 0=move, 1=copy
	$errormodul = "_OOSheetMoveOrCopyRange"
	If IsString($fromsheetnameornumber) Then
		$fromsheet = $odoc.sheets.getbyname($fromsheetnameornumber)
	Else
		$fromsheet = $odoc.sheets.getbyindex($fromsheetnameornumber) ;index starts with 0
	EndIf
	If IsString($tosheetnameornumber) Then
		$tosheet = $odoc.sheets.getbyname($tosheetnameornumber)
	Else
		$tosheet = $odoc.sheets.getbyindex($tosheetnameornumber) ;index starts with 0
	EndIf
	$oRangeOrg = $fromsheet.getCellRangeByName($fromrange).RangeAddress ; copy range
	$oCellCpy = $tosheet.getCellrangeByname($tocell).CellAddress ; insert position
	If $flag = 0 Then ;move
		$oSheet.MoveRange($oCellCpy, $oRangeOrg)
	Else
		$oSheet.CopyRange($oCellCpy, $oRangeOrg)
	EndIf
EndFunc   ;==>_OOSheetMoveOrCopyRange

Func _OOSheetSetCell($xkoord, $ykoord, $data, $ref = "string") ;$ref= angabe, ob "string" "value" "formula"
	$errormodul = "_OOSheetSetCell"
	If IsString($xkoord) Then
		$cell = _OOAdress2Koord($xkoord)
		$xkoord = $cell[0]
		$ykoord = $cell[1]

	EndIf
	$ref = StringUpper($ref)
	Select
		Case $ref = "STRING"
			$oCell = $oSheet.getCellByPosition($xkoord, $ykoord)
			$oCell.setString($data)

		Case $ref = "VALUE"
			$oCell = $oSheet.getCellByPosition($xkoord, $ykoord)
			$oCell.setvalue($data)

		Case $ref = "FORMULA"
			$oCell = $oSheet.getCellByPosition($xkoord, $ykoord)
			$oCell.setformula($data)

		Case Else
			$oCell = $oSheet.getCellByPosition($xkoord, $ykoord)
			$oCell.setstring($data)
	EndSelect
EndFunc   ;==>_OOSheetSetCell

Func _OOCloseBook() ;Datei beenden
	$errormodul = "_OOCloseBook"
	$odoc.close(True)
EndFunc   ;==>_OOCloseBook


Func _OOSheetSetCellColor($col, $row, $front = Default, $back = Default) ;RRGGBB
	$errormodul = "_OOSheetSetCell"
	If IsString($col) Then
		$cell = _OOAdress2Koord($col)
		$col = $cell[0]
		$row = $cell[1]
	EndIf
	$oCell = $oSheet.getCellByPosition($col, $row)
	$oCell.CharColor = $front
	$oCell.CellBackColor = $back
EndFunc   ;==>_OOSheetSetCellColor

Func _OOSheetSetRowColor($row, $front = Default, $back = Default) ;RRGGBB
	$errormodul = "_OOSheetSetRowColor"
	$orow = $oSheet.getRows().getByIndex($row)
	$orow.CharColor = $front
	$orow.CellBackColor = $back
EndFunc   ;==>_OOSheetSetRowColor

Func _OOSheetSetColColor($col, $front = Default, $back = Default) ;RRGGBB
	$errormodul = "_OOSheetSetColColor"
	$ocol = $oSheet.getColumns().getByIndex($col)
	$ocol.CharColor = $front
	$ocol.CellBackColor = $back
EndFunc   ;==>_OOSheetSetColColor

Func _OOSheetRangeToArray($sheetnameornumber, $startcell, $endcell, $all = "ALL") ;gibt ein Array der Daten aus dem Bereich des Tabellenblatts
	$errormodul = "_OOSheetRangeToArray"
	If IsString($sheetnameornumber) Then
		$oSheet = $odoc.sheets.getbyname($sheetnameornumber)
	Else
		$oSheet = $odoc.sheets.getbyindex($sheetnameornumber) ;index starts with 0
	EndIf

	If StringUpper($all) = "ALL" Then ;used data of the whole sheet
		$oCursor = $oSheet.createCursor()
		$oCursor.GotoStartOfUsedArea(0) ;von der ersten ausgefüllten Zelle
		$start = $oCursor.getrangeaddress()
		$Start_row = $start.startRow
		$Start_col = $start.startColumn
		$oCursor.GotoEndOfUsedArea(1);bis zur letzten ausgefüllten Zelle
		$end = $oCursor.getrangeaddress()
		$end_row = $end.endRow
		$end_col = $end.endColumn
	Else
		If IsString($startcell) Then
			$cell = _OOAdress2Koord($startcell)
			$Start_row = $cell[1]
			$Start_col = $cell[0]
		EndIf
		If IsString($endcell) Then
			$cell = _OOAdress2Koord($endcell)
			$end_row = $cell[1]
			$end_col = $cell[0]
		EndIf
	EndIf

	$ooarray = $oSheet.getCellRangeByPosition($Start_col, $Start_row, $end_col, $end_row).getDataArray() ;verschachteltes array, in [0] ist die erste zeile, in [2] die 2. usw

	Dim $array[UBound($ooarray)][UBound($ooarray[0])]
	For $rows = 0 To UBound($ooarray) - 1
		$row = $ooarray[$rows]
		For $cols = 0 To UBound($row) - 1
			$array[$rows][$cols] = $row[$cols]
		Next
	Next
	Return $array
	;ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $GetUsedRangeAddress = ' & $GetUsedRangeAddress & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~   ; return $Range
EndFunc   ;==>_OOSheetRangeToArray


Func _OOSheetArrayToRange($sheetnameornumber, $cellname, $array) ;Array ins Tabellenblatt am Position cellname ("B4")
	$errormodul = "_OOSheetArrayToRange"
	If IsString($sheetnameornumber) Then
		$oSheet = $odoc.sheets.getbyname($sheetnameornumber) ;"Tabelle1"
	Else
		$oSheet = $odoc.sheets.getbyindex($sheetnameornumber) ;index starts with 0
	EndIf
	If IsString($cellname) Then
		$cell = _OOAdress2Koord($cellname)
		$row = $cell[1]
		$col = $cell[0]
	Else
		return seterror(1,0,0)
	EndIf
	$rangestring = $cellname & ":" & _OOKoordToAddress($row + UBound($array, 1) - 1, $col + UBound($array, 2)) ;calculate the cellname of the last arrayitem in the sheet
	;build ooArray
	$dimensions = UBound($array, 0)
	If $dimensions > 2 Then Return SetError(1, 0, 0) ;nur maximal 2-dimensionale arrays
	If $dimensions = 1 Then ;eine zeile im Array wird zu einer spalte im sheet!!!
		Dim $ooarray[1]
		$ooarray[0] = $array
	Else
		Dim $ooarray[UBound($array, 1)] ;anzahl der Zeilen
		Dim $arows[UBound($array, 2)] 	;länge der zeilen
		For $row = 0 To UBound($array, 1) - 1 ;alle Zeilen abarbeiten
			For $col = 0 To UBound($array, 2) - 1 ;alle Spalteneinträge in dieser Zeile
				$arows[$col] = $array[$row][$col] ;die Spalteneinträge als Reihe ins array
			Next
			$ooarray[$row] = $arows ;das array der gesamten Zeile in das ooarray an index $row
		Next
	EndIf
	$oRange = $oSheet.getCellRangeByName($rangestring)
	$oData = $oRange.setDataArray($ooarray)
EndFunc   ;==>_OOSheetArrayToRange



; Das ist unser eigener Error-Handler
Func _OOErrFunc() ;COM-Error-Handler
	$HexNumber = Hex($oMyError.number, 8)
	MsgBox(0, "COM-Error OpenOffice Script", "Ein COM-Fehler wurde abgefangen!" & @CRLF & _
			"Fehlernummer: " & $HexNumber & @CRLF & _
			"WinDescription: " & $oMyError.windescription & @CRLF & _
			"Error in Modul " & $errormodul)
	SetError(1)
EndFunc   ;==>_OOErrFunc
