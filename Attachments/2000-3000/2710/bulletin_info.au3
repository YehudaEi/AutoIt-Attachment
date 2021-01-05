;===========================================================
; modify bulletin information
; Wolfgang Führer
; 04.06.2005
;===========================================================


$subfolder = "Bulletininfo"
If Not FileExists(@WorkingDir & "\" & $subfolder) Then
    DirCreate(@WorkingDir & "\" & $subfolder)
EndIf

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


$filename = "mssecure\Bulletins\" & $bulletin & ".xml"

$filehandle1 = FileOpen($filename, 0)
If $filehandle1 = -1 Then
    MsgBox(0, "Error", "Unable to open " & $filename & @CRLF & @CRLF & "Please use split_bulletins.exe first!")
    Exit
EndIf


$filename2 = $subfolder & '\' & $bulletin & ".txt"

$filehandle2 = FileOpen($filename2, 2)
If $filehandle2 = -1 Then
    MsgBox(0, "Error", "Unable to open Bulletin file " & $filename2 & " for writing")
    Exit
EndIf

While 1
    $line = FileReadLine($filehandle1)
    If @error = -1 Then ExitLoop
    $line = StringStripWS($line, 1) ; delete leading spaces
	$pos = StringInStr($line," ")
	if $pos > 0 then
		$line = StringReplace($line, '>', @crlf & '> ' & @CRLF) ; split end marker
		$line = StringReplace($line, " ", @crlf & '-> ', 1)  ; replace first space
		$line = StringReplace($line, '" ', '"' & @crlf & '-> ') ; split definitions
		$line = StringReplace($line, '-> /' & @crlf & '>', '/>') ; correct /> endmarker
		$line = StringReplace($line, '<Patch' & @CRLF, '=============================' & @crlf & @crlf & '<Patch') ;
		FileWriteLine($filehandle2, $line & @CRLF) ; write line to bulletin file
	Else
		FileWriteLine($filehandle2, $line & @CRLF & @CRLF) ; write line to bulletin file
	EndIf
WEnd

FileClose($filehandle1)
FileClose($filehandle2)

Exit