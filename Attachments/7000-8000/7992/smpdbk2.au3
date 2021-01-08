; get a hold of the smpbdk.exe window
$title = ""
$var = WinList()
For $i = 1 to $var[0][0]
 ; Only get smpdbk.exe window 
 If IsCmdWindow($var[$i][0]) Then
   $title = $var[$i][0] 
 EndIf
Next
WinActivate($title)
$act = WinWaitActive($title)
If $act > 0 Then
 ;MsgBox(0, "ACTIVATED:", $title) 
 Send("{ENTER}")
 Sleep (10)
 Send("NO")
 Send("{ENTER}")
 Sleep (10)
 Send("YES")
 Send("{ENTER}")
 Sleep (10)
 Send("INPUT.TXT")
 Send("{ENTER}")
 Sleep (50)
 Send("NO")
 Send("{ENTER}")
 Sleep (10)
 Send("OUTPUT.TXT")
 Send("{ENTER}")
 Sleep (10)
 Send("{ESC}")
 Sleep (10)
 WinClose($title)
Else
 MsgBox(0, "NOT ACTIVATED:", $title) 
EndIf



Func IsCmdWindow ($myTitle)
  If StringInStr ( $myTitle, "smpdbk.exe" ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc


