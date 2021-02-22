#include <File.au3>
#include <Excel.au3>
#include <Array.au3>

Global $usrArray
_FileReadToArray("dir.csv", $usrArray)

$aArr = StringSplit(StringRegExpReplace(StringReplace(FileRead($usrArray), @CRLF, ","), "[,]+\z", ""), ",")
For $i = 1 To $usrArray[0]
    DirCreate(@ScriptDir&"\"&$usrArray[$i])
Next