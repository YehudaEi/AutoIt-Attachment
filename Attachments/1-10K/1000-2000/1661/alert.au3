#NoTrayIcon
#Include <belltimes.au3>

Func NextBell()

   $hour = @hour
   $minute = @min
   $time = $hour & $minute
   $max = UBound($bells, 1) - 1

   For $x = 0 to $max step 1
      If $time > $bells[$x][1] then
         ContinueLoop
      Else
         $bhour = StringLeft($bells[$x][1], 2)
         $bmin = StringRight($bells[$x][1], 2)
         Dim $time[3]
         $time[0] = $bells[$x][0]
         $time[1] = $bhour
         $time[2] = $bmin
         $x = $max
      EndIf         

   Next

Return $time
EndFunc

$time = NextBell()

MsgBox(0, "This is a test", $time[0] & @LF & $time[1] & ":" & $time[2])