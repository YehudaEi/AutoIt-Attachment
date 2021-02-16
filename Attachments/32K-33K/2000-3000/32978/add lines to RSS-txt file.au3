#include <file.au3>

AutoItSetOption("MustDeclareVars", 1)

Dim $SourceFileName = "C:\Users\Guest\Downloads\RSS.txt"
Dim $DestinFileName
Dim $Drives
Dim $i

$Drives = StringLeft(@ScriptFullPath, 3)

               				$DestinFileName = StringLeft(@ScriptFullPath, 3) & "C:\Users\Guest\Downloads\Weather.txt"


#cs
If $DestinFileName = "" Then
    MsgBox(4096,"Destination", "destination directory not found")
Else
    MsgBox(4096,"Destination", "Destination = " & $DestinFileName)
EndIf
#ce

; ---------------------------------
; copy file (with changing line #4)
; ---------------------------------

;  first open the source file ...
; -------------------------------
Dim $aRecords, $file
If Not _FileReadToArray($SourceFileName, $aRecords) Then
   MsgBox(4096,"Error", " Error reading file to Array     error:" & @error)
   Exit
EndIf
If $aRecords[0] < 4 Then
    Msgbox(0, "ERROR", "to less records in sourcefile: " & $aRecords[0])
    Exit
EndIf

;FileInsertText("RSS.txt", 5,0,"PH " & @CRLF)



$file = FileOpen("RSS.txt", 1)

; Check if file opened for writing OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

FileWrite($file, "Line1")
FileWrite($file, "Still Line1" & @CRLF)
FileWrite($file, "Line2")

FileClose($file)

; ... then change line #4 ...
; ---------------------------
$aRecords[4] = "local weather and other some such information."

; ... finally write file to destinaton
; -------------------------------------
_FileWriteFromArray($DestinFileName, $aRecords, 1)

; E N D ; =========================
;EndIf
;EndFunc