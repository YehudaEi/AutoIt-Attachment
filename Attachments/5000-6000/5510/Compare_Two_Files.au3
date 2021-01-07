$FileName_1 = @scriptdir & "\File1.txt"
$FileName_2 = @scriptdir & "\File2.txt"
$FileName_Diff = @scriptdir & "\Compared_DIFF.txt"


; Create an empty file for writing the result to.
$File_3 = FileOpen($FileName_Diff, 2)
If $File_3 = -1 Then
    MsgBox(0, "Error", "Unable to create file : " & $FileName_Diff)
    Exit
EndIf
FileClose($File_3)


; Open the first file
$File_1 = FileOpen($FileName_1, 0)
If $File_1 = -1 Then
    MsgBox(0, "Error", "Unable to open file : " & $FileName_1)
    Exit
EndIf
While 1
    $Line_1 = FileReadLine($File_1)
    If @error = -1 Then ExitLoop
; For each line in the first file, check every line in the second file.
; If an exact match is found, stop checking in the second file and read the next line of the first file.
; If the end of the second file is reached, this means that there is no exact match, so write to logFile and read the next line of the first file.
    $File_2 = FileOpen($FileName_2, 0)
    If $File_2 = -1 Then
        MsgBox(0, "Error", "Unable to open file : " & $FileName_2)
        FileClose($File_1)
        Exit
    EndIf
    While 1
        $Line_2 = FileReadLine($File_2)
        If @error = -1 Then
; The end of the second file is reached without finding an exact match.
; This means a difference and you have to write is to the Logfile
            Write_Diff_Log($FileName_Diff, $Line_1)
            ExitLoop
        Else
            If $Line_2 = $Line_1 then
; An exact match is found in the second file.
; It is useless to continue looking in the second file, because you already found it.
; Exit this loop and read the next line of the first file.
                ExitLoop
            Else
; This line in the second file is not the same.
; Read the next line in the second file.
            EndIf
        EndIf
    Wend
    FileClose($File_2)
Wend
FileClose($File_1)
Exit

; This function adds a Message in a File
; It returns 0 on failure
; It returns 1 on success
Func Write_Diff_Log($LogFileName, $LogMessage)
    Local $File_3
    Local $WriteToFile_3

    $File_3 = FileOpen($LogFileName, 1)
    If $File_3 = -1 Then
        Return 0
    EndIf
    $WriteToFile_3 = FileWriteLine($File_3, $LogMessage)
    If $WriteToFile_3 = -1 Then
        Return 0
    EndIf
    FileClose($File_3)
    Return 1
EndFunc
