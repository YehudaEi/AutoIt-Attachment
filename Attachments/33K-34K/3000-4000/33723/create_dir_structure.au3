;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; Author: Wojtek Zieliński (wzielins@mail.com                                                ;;;;
;;;;                                                                                            ;;;;
;;;;                                                                                            ;;;;
;;;; Creates directories and files tree structure for given directory and save it to given file ;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#Include <Misc.au3>
#Include <Array.au3>

_Singleton("create_dir_structure")



If $CmdLine[0] < 1 Then
  MsgBox(16, "Parameters not passed", "Script needs at least one argument: create_dir_structure.exe path_to_dir [path_to_file]")
  Exit(0)
Else
  Local $Dir = $CmdLine[1]
  $Dir = $Dir & "\"
  $Dir = StringReplace($Dir, "/", "\");
  $Dir = StringReplace($Dir, "\\", "\");
  If Not FileExists($Dir) OR StringInStr(FileGetAttrib($Dir), "D") = 0 Then
    MsgBox(16, "Wrong Path", "Passed path does not point to existing directory")
    Exit(0)
  EndIf
  If $CmdLine[0] = 2 Then
    Local $DirStructureFile = $CmdLine[2]
  Else
    Local $DirStructureFile = @ScriptDir & "\dir_structure.dat"
  EndIf
EndIf

Local $FileInPath = @ScriptDir & "\dir_structure.dat.tmp"
RunWait(@ComSpec & " /c " & "dir " & $Dir & " /S/B|findstr /V .svn > " & $FileInPath, '', @SW_HIDE)

$FileIn = FileOpen($FileInPath)
$FileOut = FileOpen($DirStructureFile, 2)
If $FileIn = -1 Then
  MsgBox(16, "Error", "Unable to open temporary file")
  Exit(0)
EndIf
If $FileOut = -1 Then
  MsgBox(16, "Error", "Unable to open dir structure file in writing mode")
  Exit(0)
EndIf

While 1
  $Line = FileReadLine($FileIn)
  If @error = -1 Then ExitLoop
  If FileExists($Line) AND StringInStr(FileGetAttrib($Line), "D") =  0 Then
    $arrLine = StringSplit($Line, $Dir, 1)
    $Line = $arrLine[2]
    FileWriteLine($FileOut, $Line)
  EndIf
Wend
FileClose($FileIn)
FileClose($FileOut)
FileDelete($FileInPath)
MsgBox(64, "File has been created", "'" & $DirStructureFile & "' dir structure file has been successfully created")
Exit(1)



Func alert($val)
  If IsArray($val) Then
    _ArrayDisplay($val)
  Else
    MsgBox(0, "alert", $val)
  EndIf
EndFunc
