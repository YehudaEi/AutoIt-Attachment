#Include <Excel.au3>

;Local $sFileName = "backup.dat"
$sFileName = FileOpenDialog("Kies het .dat bestand.", @ScriptDir & "\", "Solarlog (*.dat)", 1 + 4 )
$startdatum = InputBox("Testing", "Vul datum in dd.mm.jj", "06.11.09", "", 190, 115, 200, 200,"","M")
$einddatum = InputBox("Testing", "Vul einddatum in dd.mm.jj", "06.06.10", "", 190, 115, 200, 200,"","M")
Local $iSearchStart = "2;1;" & $startdatum ;Including this date & time
Local $iSearchEnd = "2;1;" & $einddatum ; Excluding this date & time.

Local $sRes
Local $hFile = FileOpen($sFileName, 0)

; Check if file opened
If $hFile = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

Local $iCharNumStart = StringInStr(FileRead($sFileName), $iSearchStart, 0) - 1
If $iCharNumStart <= 0 Then
    MsgBox(16, "Error", 'Start date, "' & $iSearchStart & '" string not found in file.')
    Exit
EndIf

Local $iCharNumEnd = StringInStr(FileRead($sFileName), $iSearchEnd, 0)
If $iCharNumEnd <= 0 Then
    MsgBox(16, "Error", 'End date, "' & $iSearchEnd & '" string not found in file.')
    Exit
EndIf
;ConsoleWrite($iCharNumStart & " to " & $iCharNumEnd & @CRLF)

FileSetPos($hFile, $iCharNumStart, 0)

While 1
    $line = FileReadLine($hFile)
    If @error = -1 Or FileGetPos($hFile) >= $iCharNumEnd Then ExitLoop
    $sRes &= $line & @CRLF
    ;If FileGetPos($hFile) >= $iCharNumEnd Then ExitLoop ; If this line is used and line #33 edited, then end search date included.
WEnd

$file = FileOpen("DagMax.csv", 1)
FileWriteLine($file, $sRes & @CRLF)

; Close the handle.
FileClose($hFile)

;ConsoleWrite($sRes & @CRLF)

$tempcsv = _ExcelBookOpen(@ScriptDir &"\DagMax.csv", 0)
_ExcelBookSaveAs($tempcsv, @ScriptDir & "\DagMax", "xls")
_ExcelBookClose("DagMax.csv", 0)
ProcessClose("EXCEL.EXE") ; If not, DagMax.csv opens
$oExcel = _ExcelBookOpen(@ScriptDir &"\DagMax.xls", 0)
_ExcelColumnDelete($oExcel, 1, 2)
_ExcelColumnDelete($oExcel, 2)
_ExcelBookClose($oExcel)

FileDelete(@ScriptDir &"\DagMax.csv")







