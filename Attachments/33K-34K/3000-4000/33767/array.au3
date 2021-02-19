;
; This example reads any csv file to a AutoIt 2D array.
#include <array.au3>

Local $sFile = "C:\software\sunrise\Local files\test.csv"

;Get number of lines / rows
Local $aREResult = StringRegExp(FileRead($sFile), ".+(?=\v+|$)", 3) ; returns array of every line
Local $iNumLines = UBound($aREResult)
ConsoleWrite("$iNumLines; " & $iNumLines & @CRLF)

;Get number of commas / columns.
Local $aREResult = StringReplace(FileRead($sFile), ",", ",") ; returns number of commas in file
Local $iNumCommas = @extended
ConsoleWrite("$iNumCommas per row; " & Int($iNumCommas / $iNumLines) + 1 & @CRLF)

Global $aMain[$iNumLines][($iNumCommas / $iNumLines) + 1], $iRow = 0 ; Array for csv file

_CSVFileToArray($sFile) ; Fill array from file

_ArrayDisplay($aMain, "csv file Results")


Func _CSVFileToArray($sFile)
    Execute(StringTrimRight(StringRegExpReplace(StringRegExpReplace(FileRead($sFile), '"', '""'), "(\V+)(\v+|$)", 'Test1(StringRegExp("\1","([^,]+)(?:,|$)",3)) & '), 3))
EndFunc   ;==>_CSVFileToArray

; Fills each row of the required 2D array
Func Test1($aArr)
    For $x = 0 To UBound($aArr) - 1
        $aMain[$iRow][$x] = $aArr[$x]
    Next
    $iRow += 1
    Return
EndFunc   ;==>Test1
$content=$aMain
dircreate($content)
