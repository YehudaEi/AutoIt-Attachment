
#Include <File.au3>


;#include "c:\include.txt"





$message = "Hold down Ctrl or Shift to choose multiple files."

$var = FileOpenDialog($message,  @UserProfileDir & "", "All Files (*.*)", 4 + 8 )
;MsgBox(1,"var" ,$var)

_DirCopyEx($var, "C:/test2" & '\')
$sDest = "C:/test2"

Func _DirCopyEx($var, $sDest, $sMask = '*')

    Local $FileList, $FileName, $Time, $Path, $Name, $Ext, $Count

    $FileList = _FileListToArray($var, $sMask, 1)

	If Not @error Then
        For $i = 1 To $FileList[0]
          ;  $Time = '[' & _WinAPI_GetDateFormat(0, 0, 0, 'dd-MMM-yy') & ' & ' & _WinAPI_GetTimeFormat(0, 0, 0, 'h-mm') & ']'
            $Name = StringRegExpReplace($FileList[$i], '\.[^.]*$', '') & ' ' & $Time
            $Ext = StringRegExpReplace($FileList[$i], '^.*\.', '')
            $Path = $sDest & '\' & $Name & '.' & $Ext
            $Count = 2
            While FileExists($Path)
                $Path = $sDest & '\' & $Name & ' (' & $Count & ').' & $Ext
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
            If Not _DirCopyEx($var & '\' & $FileList[$i], $sDest, $sMask) Then
                Return 0
            EndIf
        Next
    EndIf
    Return 1
EndFunc   ;==>_DirCopyEx
