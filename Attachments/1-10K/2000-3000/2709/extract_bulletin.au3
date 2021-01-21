;===========================================================
; find bulletin definition in mssecure.xml
; Wolfgang Führer
; 04.06.2005
;===========================================================

$filename = "mssecure.xml"
$subfolder = "MS"

While 1
	$bulletin = InputBox("Bulletin selection", "Please enter bulletin numer [MS00-000]")
	if @error = 1 Then exit
    $bulletin = StringUpper($bulletin)
	If StringLen($bulletin) <> 8 Or StringLeft($bulletin, 2) <> "MS" Or StringMid($bulletin, 5, 1) <> "-" Then
        MsgBox(0, "Wrong input", "Please enter right bulletin numer!")
    Else
        ExitLoop
    EndIf
WEnd

If Not FileExists(@WorkingDir & "\" & $subfolder) Then
    DirCreate(@WorkingDir & "\" & $subfolder)
EndIf

$filename2 = $subfolder & '\' & $bulletin & ".xml"

$filehandle1 = FileOpen($filename, 0)
If $filehandle1 = -1 Then
    MsgBox(0, "Error", "Unable to open " & $filename)
    Exit
EndIf

$filehandle2 = FileOpen($filename2, 2)
If $filehandle2 = -1 Then
    MsgBox(0, "Error", "Unable to open Bulletin file " & $filename2 & " for writing")
    Exit
EndIf

While 1
    ; read line
    $line = FileReadLine($filehandle1)
    If @error = -1 Then ExitLoop
    $line = StringStripWS($line, 1) ; delete leading spaces
    If StringLeft($line, StringLen('<Bulletin BulletinID="' & $bulletin & '"')) = '<Bulletin BulletinID="' & $bulletin & '"' Then
        FileWriteLine($filename2, $line & @CRLF) ; write first line to bulletin file
        ExitLoop
    EndIf
WEnd
While 1
    ; read next line
    $line = FileReadLine($filehandle1)
    If @error = -1 Then ExitLoop
    $line = StringStripWS($line, 1) ; delete leading spaces
    If StringLeft($line, StringLen('</Bulletin>')) = '</Bulletin>' Then
        FileWriteLine($filename2, $line & @CRLF) ; write last line to bulletin file
        ExitLoop
    Else
        FileWriteLine($filename2, $line & @CRLF) ; write next line to bulletin file
    EndIf
WEnd

FileClose($filehandle1)
FileClose($filehandle2)
Exit