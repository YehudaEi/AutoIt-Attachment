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
;       $File = "File Path And Name"
;       $Var = _CountLines ($File)
;       MsgBox (4096, "# Of Lines", $Var)
;
; Notes: N/A
;
; Author: Louie Raymond Coassin Jr. <frozenyam@hotmail.com>
;
;============================================================:

#Include-Once

Func _CountLines (ByRef $File)
   Global $Count = 0

   $Exists = FileOpen ($File, 0)
   If $Exists = -1 Then
      FileOpen ($File, 1)
   EndIf

   Do
      $Count = $Count + 1
      $CountLine = FileReadLine ($File, $Count)
   Until @Error = -1

   Return $Count - 1
EndFunc

;============================================================: