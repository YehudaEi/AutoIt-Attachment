#include <Date.au3>
$i=1
$p=0
$time2=InputBox("Time by Italiano40", "Enter in the time with AM or PM ie.12:00:00 AM")
MsgBox(262145, "Time by Italiano40", $time2)
while($i>0)
if(_NowTime()=$time2) Then
MsgBox(1,"Standby Script by Italiano40","Standby will start in 30 seconds", 30)
ProgressOn("Standby Script by Italiano40", "The computer will standby in")
While($p<100)
sleep(1000)
ProgressSet($p)
$p=$p+3
WEnd
ProgressOff()
Shutdown(32)
Exit
EndIf
WEnd
