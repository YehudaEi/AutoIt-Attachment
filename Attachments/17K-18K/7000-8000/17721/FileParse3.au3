#include <file.au3>
#include <Date.au3>
$D = _NowCalcDate()
$Month = StringMid($D, 6, 2)
;MsgBox( 0, "Date/Time", "The current month is " & $Month)
$Day = StringRight($D, 2)
$Day = $Day - 1
MsgBox( 0, "Date/Time", "The current day is " & $Day)
$Year = StringMid($D, 3, 2)
;MsgBox( 0, "Date/Time", "The current year is " & $Year)
$Date = $Month & "/" & $Day & "/" & $Year
MsgBox( 0, "Date/Time", "The final date is " & $Date)

$l = 1
$file = FileOpen("c:\144\ft2p2.log", 0)

; Check if file opened for reading OK
If $file = -1 Then
    MsgBox(0, "Error", "Unable to open file.")
    Exit
EndIf

; Read in lines of text until the EOF is reached
Do
    $line = FileReadLine($file, $l)
    ;If @error = -1 Then ExitLoop
	If StringLeft ($line, 4) = "Fast" Then 
		Do
			$1 = $l +1 
			Msgbox(0,'Record:', $line)
		Until $l = $l + 1
	;Msgbox(0,'Record:', $line)
	$l = $l + 1	
Until $l = 6000
;$i = 0
;While $i <= 10
	;Msgbox(0,'Record:', $line)
	;$line = $line +1
	;If StringLeft ($line, 8) = $Date or StringLeft ($line, 9) = "completed" then Msgbox(0,'Record:', $line)	
		;If StringLeft ($line, 9) = "completed"  Then Msgbox(0,'Record:', $line)	
		;StringLeft ($aRecords[$X], 9) = "completed" or StringLeft ($aRecords[$X], 28) = "Fast Track 2+2 not connected" Then Msgbox(0,'Record:' & $x, $aRecords[$x])	
    ;MsgBox(0, "Line read:", $line)

;WEnd

FileClose($file)