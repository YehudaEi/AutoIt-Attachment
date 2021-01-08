; Includes
#include-once
#include<file.au3>
#include<array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <string.au3>
#include <GuiListView.au3>
; Declarations
Global $sRet
Local $sFile_list
Local $sPath = "m:\movies"
Local $sFindFile = "*.avi"
Local $sFileName
Local $sReverse
Local $qQuery
Local $aRow
Local $tMsg
Local $aTitleArray[1]
Local $aTitle[1]
Local $gui
Local $listview
Local $iLastrow
Local $aTitleAndPath[1][2]
; Initialisations
If FileExists(@ScriptDir & "\Movie.db") Then FileDelete(@ScriptDir & "\Movie.db")
_SQLite_Startup()
$dbMovie = _SQLite_Open(@ScriptDir & "\Movie.db")
_SQLite_Exec(-1, "PRAGMA synchronous = OFF;")
; Create Table
_SQLite_Exec(-1, "CREATE TABLE Movies (Title, Path);")
$sFile_list = _FindPathName($sPath, $sFindFile)
$iMax = UBound($sFile_list) - 1
$aTitleArray[0] = $iMax
For $i = 1 To $iMax
    $sReverse = _StringReverse($sFile_list[$i])
    $sFileName = StringLeft($sReverse, StringInStr($sReverse, "\") - 1)
    $sFileName = _StringReverse($sFileName)
    _ArrayAdd($aTitleArray, $sFileName & '%&' & $sFile_list[$i])
Next
_ArraySort($aTitleArray, 0, 1)
_SQLite_Exec(-1, "BEGIN TRANSACTION")
For $i = 1 To $iMax
    $sFileName = $aTitleArray[$i]
    $aSplit = StringSplit($sFileName, '%&', 3)
    If StringInStr($aSplit[0], "'") > 0 Then
        $aSplit[0] = _SQLite_Escape($aSplit[0])
    Else
        $aSplit[0] = "'" & $aSplit[0] & "'"
    EndIf
    If StringInStr($aSplit[1], "'") > 0 Then
        $aSplit[1] = _SQLite_Escape($aSplit[1])
    Else
        $aSplit[1] = "'" & $aSplit[1] & "'"
    EndIf
    _SQLite_Exec(-1, "INSERT INTO Movies VALUES (" & $aSplit[0] & "," & $aSplit[1] & ");")
Next
_SQLite_Exec(-1, "COMMIT TRANSACTION")
_SQLite_Close()
_SQLite_Shutdown()
#include<Movie Database Viewer.au3>
; Found this function in the forum works a treat. Can't remember the author but whoever it was Thank you very much.
Func _FindPathName($sPath, $sFindFile)
    Local $sSubFolderPath, $iIndex, $aFolders
    $search = FileFindFirstFile($sPath & "\" & $sFindFile)
    $aFolders = _FileListToArray($sPath, "*", 2)
    While 1
        $file = FileFindNextFile($search)
        If @error Then
            ExitLoop
        Else
            $sRet &= $sPath & "\" & $file & "|"
        EndIf
    WEnd
    FileClose($search)
    For $iIndex = 1 To $aFolders[0]
        $sSubFolderPath = $sPath & "\" & $aFolders[$iIndex]
        $aFoldersSubs = _FileListToArray($sSubFolderPath, "*", 2)
        If IsArray($aFoldersSubs) Then _FindPathName($sSubFolderPath, $sFindFile)
    Next
    Return StringSplit(StringTrimRight($sRet, 1), "|")
EndFunc   ;==>_FindPathName
Func _getpath($sFile)
    $sReturn = _FindPathName("m:\movies", $sFile)
    If StringInStr($sReturn[0], "'") > 0 Then
        $sFileName = _SQLite_Escape($sReturn[0])
        Return $sFileName
    Else
        Return $sReturn[0]
    EndIf
EndFunc   ;==>_getpath
