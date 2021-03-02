;initial data.txt example below
;data in the source file will be in formats like below, where commas
;present it will already have apostrophes so it will not affect the csv file.

;Line1
;"Line, 2"
;"I am line, 3"
;4
;Line 5

#include <array.au3>
#include <file.au3>

Local $sOutput = "New Line" & ","

Local $hFile = "initialdata.txt" ; Path to file
$hFile = FileOpen($hFile, 0)
If $hFile = -1 Then _ErrorMsg("Unable to open text file.")

Local $sData = FileRead($hFile)
If @error Then _ErrorMsg("Unable to read text file.")

$sOutput &= $sData ; Concatenate

ConsoleWrite($sOutput)

Func _ErrorMsg($sMessage)
    MsgBox(0, "Error", $sMessage)
    Exit

Local $file = FileOpen("test.txt", 1)

; Check if file opened for writing OK
 If $file = -1 Then
     MsgBox(0, "Error", "Unable to output file test.txt")
     Exit
 EndIf

 FileWriteLine($file, $sData)

FileClose($file, $hFile)
EndFunc
