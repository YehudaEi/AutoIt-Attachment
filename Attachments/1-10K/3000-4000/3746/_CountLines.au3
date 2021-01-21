;============================================================:
;
; Description:
;
;    Counts the lines in a file.
;
; Function: _CountLines ($File)
;
;              $File = $Var (The file to count the lines of)
;
; Use:
;
;       $File = "Path\Name.extention"
;       $Var = _CountLines ($File)
;       MsgBox (4096, "# Of Lines", $Var)
;
; Notes: FILE MUST EXIST ALREADY
;
; Author: Louie Raymond Coassin Jr. <frozenyam@hotmail.com>
;
;============================================================:

#Include-Once

Func _CountLines (ByRef $File)
   Global $Count = 0

   FileOpen ($File, 0)

   Do
      $Count = $Count + 1
      $CountLine = FileReadLine ($File, $Count)
   Until @Error = -1

   Return $Count - 1
EndFunc

;============================================================: