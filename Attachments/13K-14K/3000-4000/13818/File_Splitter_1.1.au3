;--------------------------------------------------------------------------------------------------------------------------
; File Splitter 1.0 = Origional Script
;                                      -by Andrew Dunn (Hallman)
;--------------------------------------------------------------------------------------------------------------------------

;--------------------------------------------------------------------------------------------------------------------------
; File Splitter 1.1 = GUI modified, added functions
;                         -smashly
;
;                     New Progress Bars, modified split/join function
;                         -Hallman
;
;                     Fixed Broken drop files & hide n show gui for join & resized/moved progress window.
;                         -smashly
;
;                     Fixed a few minor bugs and typos
;                         -Hallman
;--------------------------------------------------------------------------------------------------------------------------

;==========================================================================================================================
; NOTE to script users: This script and or parts of this script may be used in your own script but please give some credit
; to the creators (Hallman and smashly)
;==========================================================================================================================

#include <GUIConstants.au3>
#include <file.au3>

Opt("GUIOnEventMode", 1)    ;1 = enable

$apw = 330
$aph = 134

$MainWindow = GUICreate("File Splitter 1.1", $apw, $aph, @DesktopWidth - $apw - 10, @DesktopHeight - $aph - 65, -1, $WS_EX_ACCEPTFILES)
WinSetOnTop($MainWindow, "", 1) ; Set the gui as always on top
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

GUICtrlCreateGroup("Drop or Browse for a file to Split or Join", 10, 10, 310, 114)

$InFile = GUICtrlCreateInput("", 20, 30, 190, 20)
$OutDirectory = GUICtrlCreateInput("", 20, 60, 190, 20)
$InBrowse = GUICtrlCreateButton("Input File", 220, 30, 90, 20)

GUICtrlSetOnEvent($InBrowse, "_handler")

$OutBrowse = GUICtrlCreateButton("Output Directory", 220, 60, 90, 20)

GUICtrlSetOnEvent($OutBrowse, "_handler")

$SplitInto = GUICtrlCreateLabel("Split File Into:", 22, 93, 64, 20)
$InSize = GUICtrlCreateInput("100", 90, 90, 60, 20)
$MB = GUICtrlCreateCombo("", 160, 90, 50, 21)
GUICtrlSetData($MB, "MB|KB|B", "MB")

$SplitJoin = GUICtrlCreateButton("", 220, 90, 90, 20)
GUICtrlSetOnEvent($SplitJoin, "_handler")

GUICtrlSetState($InFile, $GUI_DROPACCEPTED)
GUICtrlSetState($OutDirectory, $GUI_DROPACCEPTED)
GUISetOnEvent($GUI_EVENT_DROPPED, "_filedrop")

GUISetState(@SW_SHOW,$MainWindow)


;  Old Progress Bar
;~ $progressbar = GUICtrlCreateProgress (20,121,290,17,$PBS_SMOOTH)
;~ $percent = GUICtrlCreateLabel("", 155, 123, 30, 12, $SS_CENTER)
;~ GUICtrlSetFont($percent,8,500)
;~ GUICtrlSetBkColor($percent,0xffffff)

; ----- Create Progress GUI -----------------------------------------------------------------

$Progress_Win = GUICreate("file progress ...", $apw, $aph, @DesktopWidth - $apw - 10, @DesktopHeight - $aph - 65, $WS_CAPTION)

$Total_Percent_Label = GUICtrlCreateLabel("Total Percent Done = 0%", 10, 10, 300, 15)

$Total_Percent_Progress = GUICtrlCreateProgress(10, 25, 310, 25)
GUICtrlSetLimit(-1, 100, 0)

$File_Number_Label = GUICtrlCreateLabel("File 0 Of 0", 10, 65, 300, 15)

$File_Percent_Progress = GUICtrlCreateProgress(10, 80, 310, 25)
GUICtrlSetLimit(-1, 100, 0)

$File_Percent_Label = GUICtrlCreateLabel("Percent = 0", 10, 105, 300, 15)

; havn't done anything with this yet
;~ $Cancel_Btn = GUICtrlCreateButton("Cancel", 10, 130, 100, 20)

GUISetState(@SW_HIDE, $Progress_Win)

; --------------------------------------------------------------------------------------------

_StartUpDisable()

While 1
    Sleep(10)
WEnd

Func _handler()
    Select
        Case @GUI_CtrlId = $InBrowse ;Input File browse button, same sorta filtering as dropfile, so the gui will show the right controls depending on file opened.
            $Select_File = FileOpenDialog("Open ...", "::{20D04FE0-3AEA-1069-A2D8-08002B30309D}", "All Files (*.*)", 1)
            If Not @error Then
                Dim $szDrive, $szDir, $szFName, $szExt
                $FileType = _PathSplit($Select_File, $szDrive, $szDir, $szFName, $szExt)
                If StringLeft($FileType[4], 3) <> ".FS" Then
                    GUICtrlSetData($InFile, $Select_File)
                    GUICtrlSetData($OutDirectory, $FileType[1] & StringTrimRight($FileType[2], 1))
                    EnableSplitCtrls()
                ElseIf $FileType[4] = ".FS1" And $FileType[4] <> "" Then
                    GUICtrlSetData($InFile, $Select_File)
                    $sp = StringSplit($FileType[2], "\")
                    $i = $sp[0] - 1
                    $LastString = StringLen($sp[$i])
                    $DirOut = StringTrimRight($FileType[1] & $FileType[2], $LastString + 2)
                    GUICtrlSetData($OutDirectory, $DirOut)
                    EnableJoinCtrls()
                ElseIf StringLeft($FileType[4], 3) = ".FS" And StringRight($FileType[4], 2) <> "S1" Then
                    GUICtrlSetData($InFile, "", "")
                    GUICtrlSetData($OutDirectory, "", "")
                    _StartUpDisable()
                EndIf
            EndIf
        Case @GUI_CtrlId = $OutBrowse ; Output directory browse button.
            $OutputPath = FileSelectFolder("Choose the ISO folder you want to share.", "", 1)
            If Not @error Then
                GUICtrlSetData($OutDirectory, $OutputPath)
            EndIf
        Case @GUI_CtrlId = $SplitJoin ;Split or Join button depending what file is dropped/opened
            If GUICtrlRead($SplitJoin) = "Split File" Then
                GUICtrlSetState($SplitJoin, $GUI_DISABLE)
                Dim $szDrive, $szDir, $szFName, $szExt
                $OutFile = _PathSplit(GUICtrlRead($InFile), $szDrive, $szDir, $szFName, $szExt)
                $OutFile2 = GUICtrlRead($OutDirectory)
                $n = 0
                $outpath = $OutFile2 & '\Split' & $n & "_" & $OutFile[3] & $OutFile[4]
                Do
                    $n = $n + 1
                    $exist1 = FileExists($outpath)
                    $outpath = $OutFile2 & '\Split' & $n & "_" & $OutFile[3] & $OutFile[4]
                    $exist1 = FileExists($outpath)
                Until $exist1 = 0

                GUISetState(@SW_HIDE, $MainWindow)

                $File_Split = Split_File(GUICtrlRead($InFile), $outpath & "\", $OutFile[3] & $OutFile[4])

                GUISetState(@SW_SHOW, $MainWindow)

                If $File_Split = -1 Then
                    MsgBox(0, "error", "The size you inputed for the split size is larger than the file itself!")
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                ElseIf $File_Split = -2 Then
                    MsgBox(0, "error", "Unable to open the source file.")
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                ElseIf $File_Split = -3 Then
                    MsgBox(0, "error", "Unable to to create output files.")
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                ElseIf $File_Split = 1 Then
                    MsgBox(0, "Done!", 'Done splitting the file. The pieces have been saved in: ' & @CRLF & @CRLF & $outpath & '\')
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                EndIf
            ElseIf GUICtrlRead($SplitJoin) = "Join File" Then
                GUICtrlSetState($SplitJoin, $GUI_DISABLE)
                Dim $szDrive, $szDir, $szFName, $szExt
                $Path_Split = _PathSplit(GUICtrlRead($InFile), $szDrive, $szDir, $szFName, $szExt)
                $Temp_Split = StringSplit($Path_Split[3], ".")
                $Real_File_Name = ""
                For $i = 1 To ($Temp_Split[0] - 1) Step 1
                    $Real_File_Name &= $Temp_Split[$i] & "."
                Next
                $Real_File_Name = StringTrimRight($Real_File_Name, 1)
                $OutFile2 = GUICtrlRead($OutDirectory)
                $n = 0
                $outpath = $OutFile2 & '\Join' & $n & "_" & $Real_File_Name
                Do
                    $n = $n + 1
                    $exist1 = FileExists($outpath)
                    $outpath = $OutFile2 & '\Join' & $n & "_" & $Real_File_Name
                    $exist1 = FileExists($outpath)
                Until $exist1 = 0

                GUISetState(@SW_HIDE, $MainWindow)

                $File_Join = Join_File(GUICtrlRead($InFile), $outpath & "\" & $Real_File_Name, $Temp_Split[$Temp_Split[0]])

                GUISetState(@SW_SHOW, $MainWindow)

                If $File_Join = -1 Then
                    MsgBox(0, "error", "Unable to open the output file.")
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                ElseIf $File_Join = -2 Then
                    MsgBox(0, "error", "Unable to open the file part one.")
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                ElseIf $File_Join = 1 Then
                    MsgBox(0, "Done!", 'Done joining the file. The file has been saved in: ' & @CRLF & @CRLF & $outpath & '\')
                    GUICtrlSetState($SplitJoin, $GUI_ENABLE)
                EndIf
            EndIf
    EndSelect
EndFunc   ;==>_handler

Func _filedrop() ;Just some drop file filtering so the gui will offer the right controls for the file dropped
    Dim $szDrive, $szDir, $szFName, $szExt
    $FileType = _PathSplit(@GUI_DragFile, $szDrive, $szDir, $szFName, $szExt)
    If @GUI_DropId = $InFile Then
        If $FileType[4] <> "" And StringLeft($FileType[4], 3) <> ".FS" Then
            GUICtrlSetData($OutDirectory, $FileType[1] & StringTrimRight($FileType[2], 1))
            EnableSplitCtrls()
        ElseIf $FileType[4] = ".FS1" And $FileType[4] <> "" Then
            $sp = StringSplit($FileType[2], "\")
            $i = $sp[0] - 1
            $LastString = StringLen($sp[$i])
            $DirOut = StringTrimRight($FileType[1] & $FileType[2], $LastString + 2)
            GUICtrlSetData($OutDirectory, $DirOut)
            EnableJoinCtrls()
        ElseIf $FileType[4] = "" Or StringLeft($FileType[4], 3) = ".FS" And StringRight($FileType[4], 2) <> "S1" Then
            GUICtrlSetData($InFile, "", "")
            GUICtrlSetData($OutDirectory, "", "")
            _StartUpDisable()
        EndIf
    ElseIf @GUI_DropId = $OutDirectory Then
        If $FileType[4] <> "" Then
            GUICtrlSetData($OutDirectory, "", "")
        ElseIf $FileType[4] = "" Then
            GUICtrlSetData($OutDirectory, "", "")
            GUICtrlSetData($OutDirectory, @GUI_DragFile)
        EndIf
    EndIf
EndFunc   ;==>_filedrop


Func _StartUpDisable() ;Disable n hide some controls so a user can only do things in the right order.
    GUICtrlSetState($SplitInto, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($InSize, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($MB, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($SplitJoin, $GUI_DISABLE + $GUI_HIDE)
EndFunc   ;==>_StartUpDisable

Func EnableSplitCtrls() ;Show n Enable some controls if the user drops/opens a file to split.
    GUICtrlSetState($SplitInto, $GUI_ENABLE + $GUI_SHOW)
    GUICtrlSetState($InSize, $GUI_ENABLE + $GUI_SHOW)
    GUICtrlSetState($MB, $GUI_ENABLE + $GUI_SHOW)
    GUICtrlSetState($SplitJoin, $GUI_ENABLE + $GUI_SHOW)
    GUICtrlSetData($SplitJoin, "Split File")
EndFunc   ;==>EnableSplitCtrls

Func EnableJoinCtrls() ;Show n enable some controls if a user drops/opens .FS1 for join.
    GUICtrlSetState($SplitInto, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($InSize, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($MB, $GUI_DISABLE + $GUI_HIDE)
    GUICtrlSetState($SplitJoin, $GUI_ENABLE + $GUI_SHOW)
    GUICtrlSetData($SplitJoin, "Join File")
EndFunc   ;==>EnableJoinCtrls

Func Split_File($Source, $Output_Folder, $Base_Name)

    ; Reset progress to 0 in case the user has split a file before this
    GUICtrlSetData($Total_Percent_Label, "Total Percent Done = 0%")
    GUICtrlSetData($Total_Percent_Progress, 0)
    GUICtrlSetData($File_Number_Label, "File 0 Of 0")
    GUICtrlSetData($File_Percent_Progress, 0)
    GUICtrlSetData($File_Percent_Label, "Percent = 0")

	WinSetTitle($Progress_Win, '', 'Split file progress...')

    ; Check if the file is smaller than what the user inputed to be the split size
    If GUICtrlRead($MB) = "MB" And (FileGetSize($Source) / 1048576) <= GUICtrlRead($InSize) Then Return -1
    If GUICtrlRead($MB) = "KB" And (FileGetSize($Source) / 1024) <= GUICtrlRead($InSize) Then Return -1
    If GUICtrlRead($MB) = "B" And FileGetSize($Source) <= GUICtrlRead($InSize) Then Return -1

    ; open the file that will be split (source file)
    $Open_File = FileOpen($Source, 0)
    If $Open_File = -1 Then Return -2

	; show progress bar
    GUISetState(@SW_SHOW, $Progress_Win)

    ; get the size of the source file
    $File_Size = FileGetSize($Source)

    ; Calculate the total number of files the source file will be split into
    $Number_Of_Files = ""
    If GUICtrlRead($MB) = "MB" Then
        $Number_Of_Files = Ceiling($File_Size / (GUICtrlRead($InSize) * 1048576))
    ElseIf GUICtrlRead($MB) = "KB" Then
        $Number_Of_Files = Ceiling($File_Size / (GUICtrlRead($InSize) * 1024))
    ElseIf GUICtrlRead($MB) = "B" Then
        $Number_Of_Files = Ceiling($File_Size / GUICtrlRead($InSize))
    EndIf

    ; convert the split size form to bytes
    $Split_Size = ""
    If GUICtrlRead($MB) = "MB" Then
        $Split_Size = (GUICtrlRead($InSize) * 1048576)
    ElseIf GUICtrlRead($MB) = "KB" Then
        $Split_Size = (GUICtrlRead($InSize) * 1024)
    ElseIf GUICtrlRead($MB) = "B" Then
        $Split_Size = GUICtrlRead($InSize)
    EndIf

    ; create a variable to hold the current file number being wrote
    $Cur_File_Number = 0

    Sleep(1000)

    $Last_Per_Wrote = 0

    ; loop through all the file pieces (except for the last one since it wont be the same size as the others) and write it's chunk of the source files data
    For $i = 1 To $Number_Of_Files - 1
        $Cur_File_Number = $i

        If $i = 1 Then
            $Open_Cur_File = FileOpen($Output_Folder & $Base_Name & "." & $Number_Of_Files & ".FS" & $i, 10)
        Else
            $Open_Cur_File = FileOpen($Output_Folder & $Base_Name & ".FS" & $i, 10)
        EndIf

        If $Open_Cur_File = -1 Then
            FileClose($Open_File)
            DirRemove(StringTrimRight($Output_Folder, 1), 1)
            Return -3
        EndIf

        GUICtrlSetData($File_Number_Label, "File " & $i & " Of " & $Number_Of_Files)

        If $Split_Size >= 20000 Then

            $Loop_Amount = Floor($Split_Size / 20000)

            $Loop_To_Num = ($Loop_Amount * 20000)

            For $ii = 20000 To $Loop_To_Num Step 20000
                FileWrite($Open_Cur_File, FileRead($Open_File, 20000))

                $Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii, 0)

                If $Cur_File_Percent <> $Last_Per_Wrote Then
                    GUICtrlSetData($File_Percent_Progress, $Cur_File_Percent)
                    GUICtrlSetData($File_Percent_Label, "Percent = " & $Cur_File_Percent)

                    $Last_Per_Wrote = $Cur_File_Percent
                EndIf
            Next
			
			FileWrite($Open_Cur_File, FileRead($Open_File, $Split_Size - (20000 * $Loop_Amount)))

        Else
            FileWrite($Open_Cur_File, FileRead($Open_File, $Split_Size))
        EndIf
        

        GUICtrlSetData($File_Percent_Label, "Percent = 100")
        GUICtrlSetData($File_Percent_Progress, 100)

        FileClose($Open_Cur_File)


        ; calculate total percent done
        $Cur_Total_Per = Round((100 / $Number_Of_Files) * $i, 0)

        GUICtrlSetData($Total_Percent_Label, "Total Percent Done = " & $Cur_Total_Per & "%")

        GUICtrlSetData($Total_Percent_Progress, $Cur_Total_Per)
        ;-----------------------------
    Next

    ; calculate the total number of the source files data already wrote in the split files
    $Bytes_Wrote = $Cur_File_Number * $Split_Size

    ; calculate the number bytes left over that still need to be wrote
    $Left_Over_Bytes = $File_Size - $Bytes_Wrote

    ; Open the last split file
    $Open_Cur_File = FileOpen($Output_Folder & $Base_Name & ".FS" & ($Cur_File_Number + 1), 10)
    If $Open_Cur_File = -1 Then
        FileClose($Open_File)
        DirRemove(StringTrimRight($Output_Folder, 1), 1)
        Return -3
    EndIf

    GUICtrlSetData($File_Number_Label, "File " & $Number_Of_Files & " Of " & $Number_Of_Files)

    ; Write the rest of the bytes to the last file part
    If $Left_Over_Bytes > 20000 Then
        $Loop_Amount = Floor($Left_Over_Bytes / 20000)
        $Loop_To_Num = ($Loop_Amount * 20000)

        For $ii = 20000 To $Loop_To_Num Step 20000
            FileWrite($Open_Cur_File, FileRead($Open_File, 20000))

            $Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii, 0)

            If $Cur_File_Percent <> $Last_Per_Wrote Then
                GUICtrlSetData($File_Percent_Progress, $Cur_File_Percent)
                GUICtrlSetData($File_Percent_Label, "Percent = " & $Cur_File_Percent)
                $Last_Per_Wrote = $Cur_File_Percent
            EndIf

        Next
        FileWrite($Open_Cur_File, FileRead($Open_File, $Left_Over_Bytes - (20000 * $Loop_Amount)))
    Else
        FileWrite($Open_Cur_File, FileRead($Open_File, $Left_Over_Bytes))
    EndIf

    GUICtrlSetData($File_Percent_Progress, 100)
    GUICtrlSetData($File_Percent_Label, "Percent = 100")

    GUICtrlSetData($Total_Percent_Label, "Total Percent Done = 100%")
    GUICtrlSetData($Total_Percent_Progress, 100)

    Sleep(1000)

    ; close files
    FileClose($Open_Cur_File)
    FileClose($Open_File)

    GUISetState(@SW_HIDE, $Progress_Win)

    ; return success
    Return 1
EndFunc   ;==>Split_File

Func Join_File($File_Part_One_Path, $Output_File, $Number_Of_Pieces)
    ; Show progress bar


    ; Open the output file
    $Save_File = FileOpen($Output_File, 10)
    If $Save_File = -1 Then Return -1

	; Reset progress to 0 in case the user has split a file before this
    GUICtrlSetData($Total_Percent_Label, "Total Percent Done = 0%")
    GUICtrlSetData($Total_Percent_Progress, 0)
    GUICtrlSetData($File_Number_Label, "File 0 Of 0")
    GUICtrlSetData($File_Percent_Progress, 0)
    GUICtrlSetData($File_Percent_Label, "Percent = 0")

    WinSetTitle($Progress_Win, '', 'Join file progress...')

    ; Show progress bar
    GUISetState(@SW_SHOW, $Progress_Win)

    ; Open part one of the split file in read mode
    $Open_PartOne_File = FileOpen($File_Part_One_Path, 0)
    If $Open_PartOne_File = -1 Then
        FileClose($Save_File)
        GUISetState(@SW_HIDE, $Progress_Win)
        Return -2
    EndIf

    $Part_One_Size = FileGetSize($File_Part_One_Path)

    GUICtrlSetData($File_Number_Label, "File 1 Of " & $Number_Of_Pieces)

    ; Write the contents of part one to the output file
    If $Part_One_Size < 20000 Then
        FileWrite($Save_File, FileRead($Open_PartOne_File))
    Else

        $Last_Per_Wrote = 0

        $Loop_Amount = Floor($Part_One_Size / 20000)
        $Loop_To_Num = ($Loop_Amount * 20000)

        For $ii = 20000 To $Loop_To_Num Step 20000

            FileWrite($Save_File, FileRead($Open_PartOne_File, 20000))

            $Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii, 0)

            If $Cur_File_Percent <> $Last_Per_Wrote Then
                GUICtrlSetData($File_Percent_Progress, $Cur_File_Percent)
                GUICtrlSetData($File_Percent_Label, "Percent = " & $Cur_File_Percent)
                $Last_Per_Wrote = $Cur_File_Percent
            EndIf
        Next

        FileWrite($Save_File, FileRead($Open_PartOne_File, $Part_One_Size - $Loop_To_Num))

        GUICtrlSetData($File_Percent_Label, "Percent = 100")
        GUICtrlSetData($File_Percent_Progress, 100)

    EndIf

    FileClose($Open_PartOne_File)

    ; calculate total percent done
    $Cur_Total_Per = Round((100 / $Number_Of_Pieces) * 1, 0)

    GUICtrlSetData($Total_Percent_Label, "Total Percent Done = " & $Cur_Total_Per & "%")

    GUICtrlSetData($Total_Percent_Progress, $Cur_Total_Per)
    ;-----------------------------

    ; Set variable to the base file name of all the file parts
    $Base_Split_File_path = StringReplace($File_Part_One_Path, "." & $Number_Of_Pieces & ".FS1", "")

    ; Loop through all the file pieces writing their contents to the output file
    For $i = 2 To $Number_Of_Pieces Step 1
        $Open_Part_File = FileOpen($Base_Split_File_path & ".FS" & $i, 0)
        If $Open_Part_File = -1 Then
            FileClose($Save_File)
            GUISetState(@SW_HIDE, $Progress_Win)
            MsgBox(0, "Error", "Unable to locate """ & $Base_Split_File_path & ".FS" & $i & """. Make sure it's in the same directory as part one.")
            Return 0
        EndIf

        $Part_Size = FileGetSize($Base_Split_File_path & ".FS" & $i)

        GUICtrlSetData($File_Number_Label, "File " & $i & " Of " & $Number_Of_Pieces)

        If $Part_Size < 20000 Then
            FileWrite($Save_File, FileRead($Open_Part_File))
        Else

            $Last_Per_Wrote = 0

            $Loop_Amount = Floor($Part_Size / 20000)
            $Loop_To_Num = ($Loop_Amount * 20000)

            For $ii = 20000 To $Loop_To_Num Step 20000

                FileWrite($Save_File, FileRead($Open_Part_File, 20000))

                $Cur_File_Percent = Round((100 / $Loop_To_Num) * $ii, 0)

                If $Cur_File_Percent <> $Last_Per_Wrote Then
                    GUICtrlSetData($File_Percent_Progress, $Cur_File_Percent)
                    GUICtrlSetData($File_Percent_Label, "Percent = " & $Cur_File_Percent)
                    $Last_Per_Wrote = $Cur_File_Percent
                EndIf
            Next

            FileWrite($Save_File, FileRead($Open_Part_File, $Part_Size - $Loop_To_Num))

            GUICtrlSetData($File_Percent_Label, "Percent = 100")
            GUICtrlSetData($File_Percent_Progress, 100)

        EndIf


        FileClose($Open_Part_File)

        ; calculate total percent done
        $Cur_Total_Per = Round((100 / $Number_Of_Pieces) * $i, 0)

        GUICtrlSetData($Total_Percent_Label, "Total Percent Done = " & $Cur_Total_Per & "%")

        GUICtrlSetData($Total_Percent_Progress, $Cur_Total_Per)
        ;-----------------------------

    Next

    ; close the output file
    FileClose($Save_File)

    GUISetState(@SW_HIDE, $Progress_Win)

    ; return Success
    Return 1
EndFunc   ;==>Join_File

Func _Exit()
    Exit
EndFunc   ;==>_Exit 