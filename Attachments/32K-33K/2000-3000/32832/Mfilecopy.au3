
#Include <File.au3>


;#include "c:\include.txt"





$message = "Hold down Ctrl or Shift to choose multiple files."

$var = FileOpenDialog($message,  @UserProfileDir & "", "All Files (*.*)", 4 + 8 )
;MsgBox(1,"var" ,$var)
$FileList = StringSplit($var, "|")
$n=_DirCopyEx($var, "C:/test2" & '\')
$sDest = "C:/test2"

Func _DirCopyEx($var, $sDest)

    Local $FileList, $FileName, $Time, $Path, $Name, $Ext, $Count



	If Not @error Then
        For $i = 1 To $FileList[0]
            $Count = 2
            While FileExists($var)
                $Path = $sDest
                $Count += 1
            WEnd
            If Not FileCopy($var & '\' & $FileList[$i], $Path, 8) Then
                Return 0
            EndIf
        Next
    EndIf
    $FileList = _FileListToArray($var, '*', 2)
    If Not @error Then
        For $i = 1 To $FileList[0]
            If Not _DirCopyEx($var & '\' & $FileList[$i], $sDest) Then
                Return 0
            EndIf
        Next
    EndIf
    Return 1
EndFunc   ;==>_DirCopyEx
