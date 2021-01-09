#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Run_Au3check=n
#AutoIt3Wrapper_Au3Check_Parameters=-U
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Tidy_Stop_OnError=n
#Obfuscator_Parameters=/striponly
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <ListViewConstants.au3>
#include <IsPressed_UDF.au3>
#include <file.au3>
#include <array.au3>
#include <SQLite.au3>
#include <SQLite.dll.au3>
#include <string.au3>
#include <GuiListView.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
; Change $sPath01 to the path of your movies
Local $sPath01 = "m:\movies"
Local $sFindFile = "*.avi"
Local $qQuery
Local $aRow
Local $sTitle
Local $aTitleAndPath[1][2]
Local $aTitle
Local $aPath
Local $lListView
Local $lCountLabel
Local $inInput
Local $dll
Global $sRet
Local $sFile_list
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
Opt("wintitlematchmode", 3)
_DisplayResults()
Func RunQuery()
    _SQLite_Startup()
    _SQLite_Open(@ScriptDir & "\Movie.db")
    _SQLite_Query(-1, "SELECT * FROM Movies;", $qQuery)
    $sPath = ""
    $sTitle = ""
    While _SQLite_FetchData($qQuery, $aRow) = $SQLITE_OK
        $sTitle &= $aRow[0] & '%&'
        $sPath &= $aRow[1] & '$%'
    WEnd
    $aTitle = StringSplit($sTitle, '%&', 3)
    $aPath = StringSplit($sPath, '$%', 3)
    Dim $aTitleAndPath[UBound($aTitle)][2]
    For $i = 0 To UBound($aTitle) - 1
        $aTitleAndPath[$i][0] = $aTitle[$i]
        $aTitleAndPath[$i][1] = $aPath[$i]
    Next
    _SQLite_Close()
    _SQLite_Shutdown()
EndFunc   ;==>RunQuery
Func _DisplayResults()
    RunQuery()
    $gDisplayGui = GUICreate("Movies", @DesktopWidth * 0.7, @DesktopHeight * 0.7, -1, -1, BitOR($WS_MAXIMIZEBOX, $WS_SIZEBOX))
    $aWinPos = WinGetPos("Movies")
    $bUpdateButton = GUICtrlCreateButton("Update Database", $aWinPos[2] * 0.30, $aWinPos[3] * 0.87)
    $lListView = GUICtrlCreateListView("Title|Path", 0, 0, $aWinPos[2] * 0.982, $aWinPos[3] * 0.7)
    $lCountLabel = GUICtrlCreateLabel("", $aWinPos[2] * 0.01, $aWinPos[3] * 0.80, 200, 21)
    $inInput = GUICtrlCreateInput("", $aWinPos[2] * 0.01, $aWinPos[3] * 0.75, $aWinPos[2] * 0.20, 21)
    _GUICtrlListView_SetExtendedListViewStyle($lListView, BitOR($LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT, $LVS_EX_LABELTIP))
    _GUICtrlListView_AddArray($lListView, $aTitleAndPath)
    GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
    _GUICtrlListView_SetColumnWidth($lListView, 0, $LVSCW_AUTOSIZE)
    _GUICtrlListView_SetColumnWidth($lListView, 1, $LVSCW_AUTOSIZE)
    GUICtrlSetResizing($gDisplayGui, $GUI_DOCKAUTO)
    GUISetState()
    GUICtrlSetState($inInput, $GUI_FOCUS)
    $dll = DllOpen("user32.dll")
    While 1
        $mesg = GUIGetMsg()
        Select
            Case $mesg = $GUI_EVENT_CLOSE
                DllClose($dll)
                Exit
            Case $mesg = $bUpdateButton
                $aAnswer = MsgBox(4, "Movie Database", "Do you want to update the movie database?")
                If $aAnswer = 6 Then
                    GUICtrlSetData($lCountLabel, "Updating Database Please Wait!")
                    GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
                    Update_db()
                    RunQuery()
                    _GUICtrlListView_AddArray($lListView, $aTitleAndPath)
                    GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
                EndIf
        EndSelect
        If _IsPressed("0D", $dll) Then
            If WinActive("Movies") Then
                _SearchTitles()
            EndIf
        EndIf
        If _IsPressed("08", $dll) Then
            _SearchTitles()
        EndIf
        If _IsAlphaNumKeyPressed($dll) Then
            _SearchTitles()
        EndIf
    WEnd
EndFunc   ;==>_DisplayResults
Func _SearchTitles()
    $sTitles = ""
    $input = GUICtrlRead($inInput)
    If $input = "*" Or $input = "" Then
        GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
        _GUICtrlListView_AddArray($lListView, $aTitleAndPath)
        GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
    Else
        $iArrayIndex = _ArrayFindAll($aTitleAndPath, $input, 0, 0, 0, 1)
        If $iArrayIndex = -1 Then
            GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
        Else
            Dim $aFound[UBound($iArrayIndex)][2]
            For $iIterate = 0 To UBound($iArrayIndex) - 1
                $aFound[$iIterate][0] = $aTitleAndPath[$iArrayIndex[$iIterate]][0]
                $aFound[$iIterate][1] = $aTitleAndPath[$iArrayIndex[$iIterate]][1]
            Next
            GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
            _GUICtrlListView_AddArray($lListView, $aFound)
        EndIf
        GUICtrlSetData($lCountLabel, UBound($iArrayIndex) & " Titles match the search term")
    EndIf
EndFunc   ;==>_SearchTitles
Func _ShowAll()
    GUICtrlSetData($inInput, "")
    GUICtrlSendMsg($lListView, $LVM_DELETEALLITEMS, 0, 0)
    _GUICtrlListView_AddArray($lListView, $aTitleAndPath)
    GUICtrlSetData($lCountLabel, UBound($aTitleAndPath) & " Titles")
    GUICtrlSetState($inInput, $GUI_FOCUS)
EndFunc   ;==>_ShowAll
DllClose($dll)
Func Update_db()
    ; Initialisations
;~ 	If FileExists(@ScriptDir & "\Movie.db") Then FileDelete(@ScriptDir & "\Movie.db")
    _SQLite_Startup()
;~ 	$dbMovie = _SQLite_Open(@ScriptDir & "\Movie.db")
    _SQLite_Open(@ScriptDir & "\Movie.db")
;~ 	_SQLite_Exec(-1, "PRAGMA synchronous = OFF;")
    _SQLite_Exec(-1, "DROP TABLE IF EXISTS Movies;")
    ; Create Table
    _SQLite_Exec(-1, "CREATE TABLE Movies (Title, Path);")
    $sFile_list = _FindPathName($sPath01, $sFindFile)
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
EndFunc   ;==>Update_db
; Found this function in the forum works a treat. Can't remember the author but whoever it was Thank you very much.
Func _FindPathName($sPath01, $sFindFile)
    Local $sSubFolderPath, $iIndex, $aFolders
    $search = FileFindFirstFile($sPath01 & "\" & $sFindFile)
    $aFolders = _FileListToArray($sPath01, "*", 2)
    While 1
        $file = FileFindNextFile($search)
        If @error Then
            ExitLoop
        Else
            $sRet &= $sPath01 & "\" & $file & "|"
        EndIf
    WEnd
    FileClose($search)
    For $iIndex = 1 To UBound($aFolders) - 1
        $sSubFolderPath = $sPath01 & "\" & $aFolders[$iIndex]
        $aFoldersSubs = _FileListToArray($sSubFolderPath, "*", 2)
        If IsArray($aFoldersSubs) Then _FindPathName($sSubFolderPath, $sFindFile)
    Next
    Return StringSplit(StringTrimRight($sRet, 1), "|")
EndFunc   ;==>_FindPathName
Func _getpath($sFile)
    $sReturn = _FindPathName($sPath, $sFile)
    If StringInStr($sReturn[0], "'") > 0 Then
        $sFileName = _SQLite_Escape($sReturn[0])
        Return $sFileName
    Else
        Return $sReturn[0]
    EndIf
EndFunc   ;==>_getpath
