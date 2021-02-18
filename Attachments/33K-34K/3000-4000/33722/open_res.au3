;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Idea:   Wojtek Zieliński (wzielins@gmail.com)                 ;;;;;
;;;;         Maciek Maksym (maksym@maksym.info)                    ;;;;;
;;;; Author: Wojtek Zieliński                                      ;;;;;
;;;;         Tomek Marcinkowski (tomasz.marcinkowski@gmail.com)    ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <ListBoxConstants.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TreeViewConstants.au3>
#Include <Array.au3>
#Include <Misc.au3>

If _Singleton("open_res", 1) = 0 Then
  WinActivate("Open Resource")
  Exit
EndIf



; v FIXME: reload dir_structure.dat file on Apply & Save
; v FIXME: search progress bar and matching files count info
; v FIXME: user defined 'start searching after N chars'
;   FIXME: use cursor keys for changing focus from 'What to find' field to 'Matched files list' field
; v FIXME: if configuration file is missing try to run script with default settings
; v FIXME: try to open matched file from each subdirecory of passed FilePath
;   FIXME: filter by popular files extensions
;   FIXME: search in files content (option)
; v FIXME: search only in files (option)
; v FIXME: search case insensitive (option)
; v FIXME: change path delimiter to backslash
; v FIXME: Open Resource plugin should be a singleton (one window instance)
;   FIXME: Open Resource window should be topmost and "always on top" but should not block parent editor window ???
; v FIXME: when pattern contains string which occures many times in structre dir file, ex. 'data' then program hangs on searching loop
;   FIXME: add user regex pattern
; v FIXME: add button "Create dir structure file"


;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ read config File ] */
Dim $ConfigFile = @ScriptDir & "\open_res.ini"

If FileExists($ConfigFile) Then
  $arrConfig = IniReadSection($ConfigFile, "GLOBAL")
Else
  Dim $arrConfig[6][2] = [["5", ""], ["project", "Unknown"], ["create_dir_structure_file_sequence", "create_dir_structure.exe"], ["dir_structure_file", @ScriptDir & "\dir_structure.dat"], ["editor_executable_file", @SystemDir & "\notepad.exe"], ["start_searching_after", "3"]]
  IniWriteSection(@ScriptDir & "\open_res.ini", "GLOBAL", $arrConfig)
  Dim $iMsgBoxAnswer
  $iMsgBoxAnswer = MsgBox(48, "Missing file", "Cannot read configuration file './open_res.ini'. Default settings will be used and configuration file will be saved with that settings.")
  Select
    Case $iMsgBoxAnswer = -1    ; Timeout
    Case Else                   ; OK
  EndSelect
EndIf

If not FileExists($arrConfig[4][1]) Then
  Dim $iMsgBoxAnswer
  $iMsgBoxAnswer = MsgBox(48, "Missing file", "Default Editor Executable File is missing. Check Configuration.", 10)
  Select
    Case $iMsgBoxAnswer = -1    ; Timeout
    Case Else                   ; OK
  EndSelect
EndIf
;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ end read config file ] */



;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ get file path ] */
If $CmdLine[0] = 0 Then
  Global $arrFilePath[1] = [@HomePath & "\Example.dat"]
  MsgBox(48, "Parameter not passed", "No parameters passed to the script. You should pass exactly one parameter contained path to existed file.")
Else
  Global $arrFilePath = StringSplit($CmdLine[1], "\", 1)
EndIf
;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ end get file path ] */



;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ read dir_structure file to array ] */
Global $arrFiles[99999]
Global $FilesCount

Func ReadDirStructureFile()
  $DataFile = FileOpen($arrConfig[3][1], 0);       ; read mode
  If $DataFile = -1 Then
    Dim $iMsgBoxAnswer
    $iMsgBoxAnswer = MsgBox(48, "File opening error", "Unable to open Dir Structure File." & @CRLF & "Check configuration.", 10)
    Select
       Case $iMsgBoxAnswer = -1                       ; Timeout
       Case Else                                      ; OK
    EndSelect
  Else
    Dim $i = 0;
    While 1
      $Line = FileReadLine($DataFile)
      If @error = -1 Then ExitLoop
      $arrFiles[$i] = StringReplace($Line, "/", "\");
      $i = $i + 1;
    WEnd
    $FilesCount = $i-1
  EndIf
EndFunc
ReadDirStructureFile()
;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ end read data file to array ] */



;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ GUI ] */
; GUI
$OpenResWin = GuiCreate("Open Resource", 600, 400, -1, -1, -1)
GuiSetIcon(@ScriptDir & "\open_res.ico", 0)


; MENU
$MenuFile = GUICtrlCreateMenu("Edit")
  $MenuConfigItem = GUICtrlCreateMenuItem("Configuration", $MenuFile)
  $MenuExitItem = GUICtrlCreateMenuItem("Exit", $MenuFile)
$MenuHelp = GUICtrlCreateMenu("?")
  $MenuAboutItem = GUICtrlCreateMenuItem("About...", $MenuHelp)

; LABEL
GuiCtrlCreateLabel("What to find:", 10, 20, 90, 16)
;GuiCtrlSetBkColor(-1, 0x00FF00)

; INPUT
Global $FileNameInput = GuiCtrlCreateInput("", 10, 40, 580, 20)

; CHECKBOX
Global $CheckboxSearchOnlyInFiles = GUICtrlCreateCheckbox("Search only files", 484, 19, 150, 16)
GUICtrlSetState($CheckboxSearchOnlyInFiles, $GUI_CHECKED)
Global $CheckboxCaseInsensitive = GUICtrlCreateCheckbox("Case insensitive searching", 300, 19, 150, 16)


; LABEL
GuiCtrlCreateLabel("Matched files:", 10, 76, 90, 16)
Global $LabelMatchedCount = GuiCtrlCreateLabel("Matched files count: 0", 10, 355, 380, 16)

; PROGRESS
Global $Progress = GuiCtrlCreateProgress(10, 340, 580, 8)
GuiCtrlSetData($Progress, 0)

; EDIT
;GuiCtrlCreateEdit(@CRLF & "  Sample Edit Control", 10, 110, 150, 70)

; LIST
$GuiFilesList = GuiCtrlCreateList("", 10, 96, 580, 250)


; LIST VIEW
;$listView = GuiCtrlCreateListView("Sample|ListView|", 110, 190, 110, 80)
;GuiCtrlCreateListViewItem("A|One", $listView)
;GuiCtrlCreateListViewItem("B|Two", $listView)
;GuiCtrlCreateListViewItem("C|Three", $listView)

; BUTTON
$CreateDirStructureFileButton = GuiCtrlCreateButton("Create dir structure file", 420, 355, 170, 20)

; TREEVIEW ONE
;$treeOne = GuiCtrlCreateTreeView(210, 290, 80, 80)
;$treeItem = GuiCtrlCreateTreeViewItem("TreeView", $treeOne)
;GuiCtrlCreateTreeViewItem("Item1", $treeItem)
;GuiCtrlCreateTreeViewItem("Item2", $treeItem)
;GuiCtrlCreateTreeViewItem("Foo", -1)
;GuiCtrlSetState($treeItem, $GUI_EXPAND)



; GUI MESSAGE LOOP
GuiSetState()
Dim $OldFileNameInputValue = ""

While 1
  $FileNameInputValue = GUICtrlRead($FileNameInput);
  If $FileNameInputValue <> $OldFileNameInputValue Then
    $OldFileNameInputValue = $FileNameInputValue;
    FileNameInputChange($FileNameInputValue)
  EndIf
  $GuiMsg = GuiGetMsg();
  Switch $GuiMsg
    Case $GUI_EVENT_CLOSE
      ExitLoop
    Case $MenuExitItem
      ExitLoop
    Case $MenuAboutItem
      GUISetState(@SW_DISABLE, $OpenResWin)
      OpenAboutWindow()
      GUISetState(@SW_ENABLE, $OpenResWin)
      GUISetState(@SW_SHOW, $OpenResWin)
    Case $MenuConfigItem
      GUISetState(@SW_DISABLE, $OpenResWin)
      OpenConfigWindow()
      GUISetState(@SW_ENABLE, $OpenResWin)
      GUISetState(@SW_SHOW, $OpenResWin)
    Case $FileNameInput
      ;MsgBox(0, "", "Input")
    Case $CheckboxSearchOnlyInFiles
      FileNameInputChange($FileNameInputValue)
    Case $CheckboxCaseInsensitive
      FileNameInputChange($FileNameInputValue)
    Case $GuiFilesList
      ProcessSelectedItem(GUICtrlRead($GuiFilesList))
    Case $CreateDirStructureFileButton
      $arrSequence = StringSplit($arrConfig[2][1], " ", 1)
      If $arrConfig[2][1] = "" Then                                     ; If no sequence is given
        MsgBox(48, "Cannot create dir structure file.", "Cannot create dir structure file. Check configuration if 'create dir structure file sequence' is defined.")
        ContinueCase
      EndIf
      Switch $arrSequence[0]
        Case 1                                                                                  ; Only then script is given
          Local $ret = ShellExecuteWait($arrSequence[1])
        Case 2                                                                                  ; Script and dir path are given
          Local $DirPath = $arrSequence[2]
          Local $ret = ShellExecuteWait($arrSequence[1], $DirPath)
        Case 3                                                                                  ; Script, dir path and dir_structure_file are given
          Local $DirPath = $arrSequence[2]
          Local $DirStructureFile = $arrSequence[3]
          Local $ret = ShellExecuteWait($arrSequence[1], $DirPath & " " & $DirStructureFile)
        Case Else                                                                               ; Four or more arguments
          Local $DirStructureFile = $arrConfig[3][1]
          Local $OldTime = FileGetTime($DirStructureFile, 0, 1)
          RunWait($arrConfig[2][1])
          Local $NewTime = FileGetTime($DirStructureFile, 0, 1)
          Local $arrNewTime = FileGetTime($DirStructureFile)
          If $OldTime <> $NewTime Then
            Local $ret = 1
          Else
            Local $ret = 0
          EndIf
      EndSwitch
      If $ret = 1 Then
        $iMsgBoxAnswer = MsgBox(64, "File has been created", "Dir structure file has been successfully created", 10, $OpenResWin)
        Select
          Case $iMsgBoxAnswer = -1    ; Timeout
          Case Else                   ; OK
        EndSelect
      Else
        $iMsgBoxAnswer = MsgBox(48, "File has not been created", "Dir structure file cannot be created. Check creation sequence/script and permissions to dir structure file", 10, $OpenResWin)
        Select
          Case $iMsgBoxAnswer = -1    ; Timeout
          Case Else                   ; OK
        EndSelect
      EndIf
    Case Else
  EndSwitch
WEnd
GUIDelete($OpenResWin)
;/* - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - [ end GUI ] */



Func OpenConfigWindow()
  $CfgWin = GUICreate("Configuration", 500, 300, -1, -1)

  $Label_5 = GuiCtrlCreateLabel("Create dir structure file sequence:", 10, 10, 165, 16)     ; PLINK.EXE my_login@host -pw my_password  "~/open_res/create_dir_structure.sh ~/projects/my_project_2"
  $Input_5 = GUICtrlCreateInput($arrConfig[2][1], 175, 6, 215, 20)

  $Label_1 = GuiCtrlCreateLabel("Use this dir structure file:", 10, 40, 165, 16)
  $Input_1 = GUICtrlCreateInput($arrConfig[3][1], 175, 36, 215, 20)
  $Button_1 = GuiCtrlCreateButton("Browse...", 400, 36, 70, 20)

  $Label_2 = GuiCtrlCreateLabel("Editor executable file:", 10, 70, 165, 16)
  $Input_2 = GUICtrlCreateInput($arrConfig[4][1], 175, 66, 215, 20)
  $Button_4 = GuiCtrlCreateButton("Browse...", 400, 66, 70, 20)

  $Label_3 = GuiCtrlCreateLabel("Start searching after:", 10, 100, 165, 16)
  $Input_3 = GUICtrlCreateInput($arrConfig[5][1], 175, 96, 30, 20)
  $Label_4 = GuiCtrlCreateLabel("chars", 210, 100, 60, 16)

  $Button_2 = GUICtrlCreateButton("Cancel", 425, 250, 60, 20)
  $Button_3 = GUICtrlCreateButton("Apply && Save", 325, 250, 89, 20)

  GUISetState()
  While 1
    $Gui2Msg = GUIGetMsg()
    Switch $Gui2Msg
      Case $GUI_EVENT_CLOSE
        ExitLoop
      Case $Button_1
        $val = FileOpenDialog("Choose dir srtucture data file", @WindowsDir, "Data (*.dat;*.txt;)|All files (*.*)", 1, $arrConfig[3][1])
        If not @error Then
          GUICtrlSetData($Input_1, $val)
        EndIf
      Case $Button_4
        $val = FileOpenDialog("Choose editor executable file", @ProgramFilesDir, "Executable (*.exe)|All files (*.*)", 1, $arrConfig[4][1])
        If not @error Then
          GUICtrlSetData($Input_2, $val)
      EndIf
      Case $Button_2
        ExitLoop
      Case $Button_3
        $arrConfig[2][1] = GUICtrlRead($Input_5)
        $arrConfig[3][1] = GUICtrlRead($Input_1)
        $arrConfig[4][1] = GUICtrlRead($Input_2)
        $arrConfig[5][1] = GUICtrlRead($Input_3)
        IniWriteSection($ConfigFile, "GLOBAL", $arrConfig)
        ReadDirStructureFile()
        FileNameInputChange(GUICtrlRead($FileNameInput))
        ExitLoop
      Case Else
    EndSwitch
  WEnd
  GUIDelete($CfgWin)
  WinActivate("Open Resource")
EndFunc



Func OpenAboutWindow()
  $CfgWin = GUICreate("About Open Resource Plugin", 300, 300, -1, -1)

  ; LABEL
  GUICtrlCreateLabel("Open Resource Plugin v.3.141.", 10, 10, 280, 160, $SS_CENTER)
  GuiCtrlCreateLabel( "Idea:" & @CRLF & "    Wojtek Zieliński (wzielins@gmail.com)" & @CRLF & "    Maciek Maksym (maksym@maksym.info)" & @CRLF & @CRLF & _
                      "Support:" & @CRLF & "    Tomek Marcinkowski (tomasz.marcinkowski@gmail.com)" & @CRLF & @CRLF & _
                      "Fuckups:" & @CRLF & "    Wojtek Zieliński" & @CRLF & @CRLF & _
                      "Special thanks to:" & @CRLF & "    Mom, Dad, Michael Jackson, Czesio", 10, 60, 280, 160, $SS_CENTER)
  ; BUTTON
  $ButtonOk = GuiCtrlCreateButton("Fajne!", 100, 240, 100, 30)

  SoundPlay(@ScriptDir & "\spaceballs_state_of_the_art.mp3")

  GUISetState()
  While 1
    $Gui2Msg = GUIGetMsg()
    Switch $Gui2Msg
      Case $GUI_EVENT_CLOSE
        ExitLoop
      Case $ButtonOk
        ExitLoop
    EndSwitch
  WEnd
  SoundPlay("")
  GUIDelete($CfgWin)
  WinActivate("Open Resource")
EndFunc



Func FileNameInputChange($val)
  $MatchedCount = 0;
  GuiCtrlSetData($GuiFilesList, "")                                         ; clear data in file list
  GuiCtrlSetData($LabelMatchedCount, "Matched files count: 0")
  GuiCtrlSetData($Progress, 0)
  $FileNamePattern = $val

  If StringLen($FileNamePattern) >= $arrConfig[5][1] Then
    GuiCtrlSetData($Progress, 10)
    GuiCtrlSetData($LabelMatchedCount, "Matched files count: ...working...")
    For $i = 0 To $FilesCount
      $Sub = $arrFiles[$i]
      If GuiCtrlRead($CheckboxSearchOnlyInFiles) = $GUI_CHECKED Then
        $Sub = StringSplit($Sub, "\", 1)
        $Sub = $Sub[$Sub[0]]
      Endif
      If RegExpTest($FileNamePattern, $Sub) <> False Then
        GuiCtrlSetData($GuiFilesList, $arrFiles[$i] & "|")
        $MatchedCount = $MatchedCount + 1;
      EndIf
      If GUICtrlRead($FileNameInput) <> $val Then                           ; break the searching loop if user changes pattern
        ExitLoop
      EndIf
      $x = $i * 100 / $FilesCount                                          ; progressbar filled with correlation of processed items' number
      GuiCtrlSetData($Progress, $x)
    Next
    ;GuiCtrlSetData($Progress, 100)                                          ; fake progress update
    GuiCtrlSetData($LabelMatchedCount, "Matched files count: " & $MatchedCount)
  EndIf
EndFunc



Func ProcessSelectedItem($FilePath)
  If FileExists($FilePath) Then
    Run($arrConfig[4][1] & " " & $FilePath)
    Exit
  EndIf
  Local $PathPart = ""
  $arrFilePathLen = UBound($arrFilePath)
  For $i = 1 To $arrFilePathLen - 2
    $PathPart = $PathPart & $arrFilePath[$i] & "\"
    If FileExists($PathPart & $FilePath) Then
      Run($arrConfig[4][1] & " " & $PathPart & $FilePath)
      Exit
    EndIf
  Next
  MsgBox(48, "Cannot find file", "Cannot find selected file. Check configuration if dir structure file is actual and accurate.", 10, $OpenResWin)
  Exit
EndFunc



Func RegExpTest($Pattern, $Subject)
  $ret = False
  $Pattern = $Pattern & ".*"
  $Pattern = StringRegExpReplace($Pattern, '([A-Z])', '[a-z0-9-_]*$1')
  If GuiCtrlRead($CheckboxCaseInsensitive) = $GUI_CHECKED Then
    $Pattern = "(?i)" & $Pattern
  Endif
  $array = StringRegExp($Subject, $Pattern, 3)
  If @error = 0 Then
    If $array[0] <> "" Then
      $ret = True
    EndIf
  EndIf
  Return $ret
EndFunc



Func alert($val)
  If IsArray($val) Then
    _ArrayDisplay($val)
  Else
    MsgBox(0, "alert", $val)
  EndIf
EndFunc
