;===========================================================
; split bulletin definitions in bulletins.xml
; Wolfgang Führer
; 04.06.2005
;===========================================================

$filename = "mssecure\Bulletins.xml"
$subfolder = "mssecure\Bulletins"

If Not FileExists(@WorkingDir & "\" & $subfolder) Then
    DirCreate(@WorkingDir & "\" & $subfolder)
EndIf

$filehandle1 = FileOpen($filename, 0)
If $filehandle1 = -1 Then
    MsgBox(0, "Error", "Unable to open " & $filename & @CRLF & @CRLF & "Please use split_mssecure.exe first!")
    Exit
EndIf

ProgressOn("Working on Bulletins.xml", "Splitting ...")
$progresscounter = 1

While 1
    
    While 1
        ; read next line of Bulletins.xml
        $line = FileReadLine($filehandle1)
        If @error = -1 Then ; no more lines to read
            FileClose($filehandle1)
            Exit
        EndIf
        $line = StringStripWS($line, 1) ; delete leading spaces
        If StringLeft($line, StringLen('<Bulletin BulletinID="')) = '<Bulletin BulletinID="' Then
            ; found new bulletin
            $filename2 = $subfolder & "\" & StringMid($line, StringLen('<Bulletin BulletinID="') + 1, 8) & '.xml'
            ; some animation for work is in progress
            $progresscounter = $progresscounter + 0.2 ; animate progress bar
            If $progresscounter = 100 Then
                $progresscounter = 1
            EndIf
            ProgressSet($progresscounter, $filename2)
            
            $filehandle2 = FileOpen($filename2, 2)
            If $filehandle2 = -1 Then
                FileClose($filehandle1)
                FileClose($filehandle2)
                MsgBox(0, "Error", "Unable to open Bulletin file " & $filename2 & " for writing")
                Exit
            EndIf
            FileWriteLine($filehandle2, $line & @CRLF) ; write first line to bulletin file
            ExitLoop
        EndIf
    WEnd
    While 1
        ; read next line of bulletin block
        $line = FileReadLine($filehandle1)
        If @error = -1 Then ; no more lines
            FileClose($filehandle1)
            FileClose($filehandle2)
            Exit
        EndIf
        $line = StringStripWS($line, 1) ; delete leading spaces
        If StringLeft($line, StringLen('</Bulletin>')) = '</Bulletin>' Then
            FileWriteLine($filehandle2, $line & @CRLF) ; write last line to bulletin file
            ExitLoop
        Else
            ;$line = StringReplace($line, '" ', '"' & @CRLF & '  ')
            FileWriteLine($filehandle2, $line & @CRLF) ; write next line to bulletin file
        EndIf
    WEnd
    
    FileClose($filehandle2)
    
WEnd

ProgressOff()
FileClose($filehandle1)

Exit