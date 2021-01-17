;--------------------------------------------------------
;AutoIt Version: 3.1.1.102 Beta
;
;Script Author: Andrew Calcutt
;Script Date: 01/21/2006
;Script Name: FileChangeSearch
;Script Function:
;    1. scan system partition to create a 'BEFORE' snapshot using DIR /s /b
;    2. scan sys partition again at a later date to create an 'AFTER' snapshot as above (after picking up new files)
;    3. Compare the differences between the two file lists and create a 'CHANGES' file.
;--------------------------------------------------------
#include <Array.au3>
#include <GuiConstants.au3>
#include <file.au3>
#Include <process.au3>
Dim $tempfile1 = "c:\list.txt"
Dim $tempfile2 = "c:\listafter.txt"
Dim $tempfile3 = "c:\FileChange_Results.txt"
Dim $array1, $array2
Dim $pos = 0
Dim $line = 1
;--------------------------------------------------------
FileDelete($tempfile1);remove old files if they exist
FileDelete($tempfile2)
FileDelete($tempfile3)
;--------------------------------------------------------

SplashTextOn ( "Scanning", "Scanning Files", 200, 75)
_RunDOS("c:\before.bat")
SplashOff ()
MsgBox(0, "", "Click OK when ready to scan again")
SplashTextOn ( "Scanning", "Scanning Files", 200, 75)
_RunDOS("c:\after.bat")
SplashOff ()
_FileReadToArray($tempfile1, $array1); create an array with tempfile1(each line contains a filename)
_FileReadToArray($tempfile2, $array2); create an array with tempfile2

;Comparing GUI
GuiCreate("Comparing", 392, 239)
$edit1 = GuiCtrlCreateEdit("", 10, 30, 370, 80, $WS_VSCROLL)
$edit2 = GuiCtrlCreateEdit("", 10, 150, 370, 80, $WS_VSCROLL)
$count1 = GuiCtrlCreateLabel("", 10, 10, 90, 20)
GuiSetState()
;Comparing GUI End
For $loop = 1 To $array2[0]
    GUICtrlSetData ( $edit2, $array2[$line])
    GUICtrlSetData ( $count1, $line)
    GUICtrlSetData ( $edit1, "Scanning For Match" & @CRLF)
    If $array2[$line] <> $tempfile2 Then
        $pos2 = $pos
        $pos = _ArraySearch ($array1, $array2[$line], $pos2, $array1[0])
        If @Error = 6 Or @Error = 4 Then FileWrite($tempfile3, $array2[$line] & @CRLF)
        If $pos = -1 Then
            GUICtrlSetData ( $edit1, "*** New File ***" & @CRLF)
            GUICtrlSetData ( $edit1, $array2[$line], 1)
            Sleep(1000)
            $pos = $pos2
        Else
            GUICtrlSetData ( $edit1, "Match Found on Line: " & $pos & @CRLF, 1)
            GUICtrlSetData ( $edit1, $array1[$pos], 1)
        EndIf
    EndIf
    $line += 1
Next