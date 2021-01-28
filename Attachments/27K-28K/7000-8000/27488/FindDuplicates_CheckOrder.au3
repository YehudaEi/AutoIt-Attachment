#include <Array.au3>
#include <File.au3>

Dim $File,$ARRAY[1],$File1
Dim $FileReadLine,$OldValue,$ActualValue,$WrongOrder,$MinValue,$MaxValue,$Element

$File = @TempDir&"\targetnums.txt"

If FileExists($File) then FileDelete($File)

; generate a file with the second column of the file index_1.csv, except the first row; which contains the column names, the delimiter is the ";"
RunWait(@ComSpec & " /c for /f ""tokens=2 skip=1 delims=;"" %i in (index_1.csv) do echo %i>>%tmp%\targetnums.txt","",@SW_HIDE)

If Not _FileReadToArray($File,$ARRAY) Then
   MsgBox(4096,"Error", " Error reading log to Array     error:" & @error)
   Exit
EndIf

FileClose($File)

_ArrayDelete($ARRAY,0); Delete the first element, which has the amounth of elements as value

;_ArrayDisplay($ARRAY)

;######## Start: Check the numeric order of the array ########
$OldValue = 0
$WrongOrder = 0

For $i=1 to UBound($ARRAY)-1
	$ActualValue = $ARRAY[$i]
	If $OldValue < $ActualValue Then
		; if $OldValue is lower than $ActualValue, then the numeric order is correct
	Else
		ConsoleWrite("The following element is not in correct order:"&$OldValue&@CRLF)
		$WrongOrder = 1
	EndIf
	$OldValue = $ActualValue; Increment the $OldValue for the next loop
Next

If $WrongOrder = 1 Then
	ConsoleWrite("This list is not in a correct numerical order!"&@CRLF)
EndIf
;######## Stop: Check the numeric order of the array ########

;######## Start: Check the numeric order; search for missing numbers in sequence ########
_ArraySort($ARRAY); The array has to be sorted for the search

$MinValue = _ArrayMin($ARRAY,1) ; get element with lowest number from array in variable $MinValue

$MaxValue = _ArrayMax($ARRAY,1); get element with highest number from  array in variable $MaxValue

$Element = $MinValue ; Fill $Element with lowest number for the initial search below

For $i=1 to UBound($ARRAY)-1
	_ArraySearch($ARRAY,$Element)
	If @error Then
		ConsoleWrite($Element&" does not exist"&@CRLF)
	EndIf
	If $Element = $MaxValue Then ExitLoop; If $Element = $Maxvalue then stop the loop (because the next row in the script would search for a non-existing number (one higher than the hightes))
	$Element = $Element + 1 ; Increment $Element up to one for the next search in the loop
Next
;######## Stop: Check the numeric order; search for missing numbers in sequence ########

;######## Start: Check the duplicated numbers ########
$File1=FileOpen($File,2)
For $i=1 to UBound($ARRAY)-1
    FileWriteLine($File1,$ARRAY[$i])
    If ($i+1)>(UBound($ARRAY)-1) Then
        ExitLoop
    Else
        If $ARRAY[$i]=$ARRAY[$i+1] Then ConsoleWrite("Duplicate No:"& $ARRAY[$i]&@CRLF)
    EndIf
Next
FileClose($File1)
If $ARRAY[0]=$ARRAY[1] Then ConsoleWrite("Duplicate No:"& $ARRAY[1]&@CRLF);Check only the first two rows for duplicates
;######## Stop: Check the duplicated numbers ########
