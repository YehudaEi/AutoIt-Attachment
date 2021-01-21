Run("cmd.exe /k")
; get a hold of the cmd window

$title = ""
$var = WinList()
For $i = 1 to $var[0][0]
 ; Only get cmd.exe window 
 If IsCmdWindow($var[$i][0]) Then
   $title = $var[$i][0] 
 EndIf
Next
;activate the command window
WinActivate($title)
$act = WinWaitActive($title)
If $act > 0 Then
; MsgBox(0, "ACTIVATED:", $title)
 Send("cd \smpdbk")
 Send("{ENTER}")
 Sleep (10)
 Send("smpdbk1.exe")
 Send("{ENTER}")
 Sleep (10)
 Send("smpdbk2.exe")
 Send("{ENTER}")
 Sleep (100)
 If ProcessExists("ntvdm") Then
   ProcessClose("ntdvm")
 EndIf
 If ProcessExists("cmd.exe") Then
   ProcessClose("cmd.exe")
 EndIf


Else
 MsgBox(0, "NOT ACTIVATED:", $title)
EndIf



Func IsCmdWindow ($myTitle)
  If StringInStr ( $myTitle, "cmd.exe" ) Then 
    Return 1
  Else
    Return 0
  EndIf
EndFunc



