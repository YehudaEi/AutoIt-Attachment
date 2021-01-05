; txt2au3
;
; converts text files to au3 scripts
; files like .bat .cmd .ini .txt .reg
;
;                                                     by albach_s@yahoo.de

$file = FileOpenDialog("Select Textfile to convert to .AU3", "", "Textfiles (*.txt;*.bat;*.cmd;*.reg;*.ini)", 1 )
If @error Then
    MsgBox(4096,"Fileconvert","No File chosen")
    Exit
EndIf

$fn = StringRight( $file , stringlen( $file ) - StringInStr($file, "\", 0, -1) )

if StringInStr($fn, ".") then $fn = StringLeft($fn, StringInStr($fn, ".")-1)

$newfile = FileSaveDialog( "Choose a name.", "", "AU3-Scripts (*.au3)", 24, $fn & "_Stringfile.au3")

If @error Then
    MsgBox(4096,"","Cancelled")
    exit
EndIf

$read = FileOpen($file, 0)

If $read = -1 Then
    MsgBox(0, "Error", "Unable to open " & $file)
    Exit
EndIf

$write = FileOpen($newfile , 2)

If $write = -1 Then
    MsgBox(0, "Error", "Unable to open " & $newfile)
    Exit
EndIf

$num = 0

While 1
   $line = FileReadLine($read)
   If @error = -1 Then
      if $num > 0 then FileWriteLine( $write, $newline )
      ExitLoop
   Else
      if $num > 0 then FileWriteLine( $write, $newline & " & @CRLF & _")
   EndIf
   $newline = StringReplace( $line, chr(34), chr(34)&chr(34))
   $newline = '"' & $newline & '"' 
   if $num = 0 then $newline = "$string = " & $newline
   $num = $num + 1
Wend

FileClose($read)
FileClose($write)

MsgBox(0, "", $num & " lines converted !")



 

 


