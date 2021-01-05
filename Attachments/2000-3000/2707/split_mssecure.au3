;===========================================================
; split categories in mssecure.xml
; Wolfgang Führer
; 04.06.2005
;===========================================================

$filename = "mssecure.xml"
$subfolder = "mssecure"

Dim $category[12]
$category[0] = "Bulletins"
$category[1] = "Products"
$category[2] = "ProductFamilies"
$category[3] = "ServicePacks"
$category[4] = "RegKeys"
$category[5] = "Files"
$category[6] = "Commands"
$category[7] = "Locations"
$category[8] = "Comments"
$category[9] = "Severities"
$category[10] = "SupercededBys"
$category[11] = "SUSMappings"

$filehandle1 = FileOpen($filename, 0)
If $filehandle1 = -1 Then
    MsgBox(0, "Error", "Unable to open mssecure.xml")
    Exit
EndIf

If Not FileExists(@WorkingDir & "\" & $subfolder) Then
    DirCreate(@WorkingDir & "\" & $subfolder)
EndIf

ProgressOn("Working on mssecure.xml", "Splitting ...")
ProgressSet(10)

For $x = 0 To 11
    
    ProgressSet(100 / 12 * $x + 10, $subfolder & "\" & $category[$x] & ".xml")
    
    $filename2 = $subfolder & "\" & $category[$x] & ".xml"
    $searchstring = '<' & $category[$x] & '>'
    $endstring = '</' & $category[$x] & '>'
    
    $filehandle2 = FileOpen($filename2, 2)
    If $filehandle2 = -1 Then
        MsgBox(0, "Error", "Unable to open file " & $filename2 & " for writing")
        Exit
    EndIf
    
    While 1
        ; read line
        $line = FileReadLine($filehandle1)
        If @error = -1 Then ExitLoop
        $line = StringStripWS($line, 1) ; delete leading spaces
        If StringLeft($line, StringLen($searchstring)) = $searchstring Then
            ; found right category
            FileWriteLine($filehandle2, $line & @CRLF) ; write first line to category file
            ExitLoop
        EndIf
    WEnd
    While 1
        ; read next line
        $line = FileReadLine($filehandle1)
        If @error = -1 Then ExitLoop
        $line = StringStripWS($line, 1) ; delete leading spaces
        If StringLeft($line, StringLen($endstring)) = $endstring Then
            FileWriteLine($filehandle2, $line & @CRLF) ; write last line to bulletin file
            ExitLoop
        Else
            FileWriteLine($filehandle2, $line & @CRLF) ; write next line to bulletin file
        EndIf
    WEnd
    
    FileClose($filehandle2)
    
Next

ProgressOff()
FileClose($filehandle1)

Exit