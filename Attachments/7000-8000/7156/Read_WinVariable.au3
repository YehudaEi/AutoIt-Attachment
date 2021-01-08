; ----------------------------------------------------------------------------
;
; Read and use Windows variable
; Author:         Bert Nieuwenampsen
;
; Script Function:
;	Read Windows variable and use it
;
; ----------------------------------------------------------------------------


; Path
 $var = "%TEMP%\Bert Nieuwenampsen"

; Run a dos prompt and put output in text-file in the Temp directory
 RunWait (@ComSpec & " /c echo " & $var & " >" & @TempDir & "\var.txt")

; Read text-file
 $var = FileReadLine ( @TempDir & "\var.txt" )

; Show messagebox with the complete path
 MsgBox ("", "Variable", $var)

; Delete text-file
 FileDelete ( @TempDir & "\var.txt" )