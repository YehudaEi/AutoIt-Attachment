;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;                                               ;;;;;
;;;;;  Automated DirectX Report Generation Program  ;;;;;
;;;;;                  Version 2.1                  ;;;;;
;;;;;                                               ;;;;;
;;;;;        Author:   Matthew Tucker               ;;;;;
;;;;;        Email:    matthewt@cfl.rr.com          ;;;;;
;;;;;        Created:  23-DEC-2004                  ;;;;;
;;;;;        Updated: 13-APR-05                     ;;;;;
;;;;;                                               ;;;;;
;;;;;        Added ProcessList functionality        ;;;;;
;;;;;                                               ;;;;;
;;;;;        Copies File Contents to Clipboard      ;;;;;
;;;;;        in background, instead of notepad      ;;;;;
;;;;;                                               ;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

#include<Array.au3>
#include<File.au3>

Dim $start = "", $title = "DirectX Diagnostic Report v2.1", $file = @TempDir & "\DxDiag.txt", $string, $array
While $start = ""
   $start = MsgBox(4, $title, "Do you wish for a DirectX Diagnostic Report to be created for you?", 5)
WEnd
If $start = "6" Then

   ;Starts DxDiag Diagnostic Program, and dumps output into file
   MsgBox(0, $title, "DirectX Diagnostic Report make take a few minutes to complete, do to the limitations of DirectX, please be patient!", 5)
   RunWait("dxdiag.exe /whql:on /t " & $file, "")
      Do
         Sleep("100")
      Until FileExists($file)


   ;Opens file DxDiag report is in, and dumps Process List into file
   $handle = FileOpen($file, 1)
   FileWriteLine($handle, "------------------")
   FileWriteLine($handle, "Process List")
   FileWriteLine($handle, "------------------")
   FileWriteLine($handle, "Name		ID")
   $list = ProcessList()
   For $i = 1 to $list[0][0]
      FileWriteLine($handle, $list[$i][0] & "		" & $list[$i][1])
   Next

   ;Copies File Contents to Clipboard and deletes file
   ClipPut(FileRead($file, FileGetSize($file)))
   FileClose($handle)
   FileDelete($file)

   ;MsgBox prompting user that file exists, copied to clipboard
   MsgBox(0, $title, "A DirectX Diagnostic Report has been generated and copied to your clipboard, please go to the forums, and paste the clipboard contents into the thread (Ctrl+V)", 5)


Else
   MsgBox(0, $title, "No DirectX Diagnostic Report was created", 5)
EndIf