#NoTrayIcon
#Include <belltimes.au3>

$hour = @hour
$minute = @min
If $hour = 0 then $hour = 12
If $hour > 12 then $hour = $hour - 12
;;; @hour is always returned in a 24 hour format, numbered from 0 to 23.


$max = UBound($bells, 2)
For $x = 0 to $max step 1
   If $hour = 12 then ContinueLoop
      If $hour = $bells[$x][1] then
         If $minute < $bells[$x][2] Then
            Msgbox(0,"test",$bells[$x][1] & ":" & $bells[$x][2])
         EndIf
      ElseIf $hour = $bells[($x+1)][1] Then
            MsgBox(0,"test",$bells[($x+1)][1] & ":" & $bells[($x+1)][2])
      EndIf
         
Next