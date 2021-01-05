;============================================================:
;
; Description:
;
;    Returns the information in a file in the form of
;    an array in a message box.
;
; Function: 
;
;    _ArrayINI ($File)
;
;       $File = $Var (The file to array)
;
; Use:
;
;    $File = "Path\Name.Extention"
;    _ArrayINI ($file)
;
; Notes: FILE MUST EXIST ALREADY
;
; Author: Louie Raymond Coassin Jr. <frozenyam@hotmail.com>
;
;============================================================:

#Include-Once

Func _ArrayINI (ByRef $File)
   Global $CountFile = 0
   $Information = @CR
   $Header = 0
   $ArrayQuery = ""

   FileOpen ($File, 0)

   Do
      $CountFile = $CountFile + 1
      $CountLine = FileReadLine ($File, $CountFile)
   Until @Error = -1

   For $Count1 = 1 To ($CountFile - 1)
      $Read = FileReadLine ($File, $Count1)
      $Information = $Information & $Read & @CR 
   Next

   $StripSpace = StringStripWS ($Information, 7)
   $Info = StringSplit ($StripSpace, "=" & @CR)


   For $Count = 0 To UBound ($Info) - 1
   $ArrayQuery = $ArrayQuery & "[" & $Count & "] = " & _
   $Info[$Count] & @CR
   Next
   
   If IsArray ($Info) = 0 Then
      MsgBox (4096, "Error", "Array = Not Valid")
   Else
      MsgBox (4096, "", $ArrayQuery)
   EndIf
EndFunc

;============================================================: