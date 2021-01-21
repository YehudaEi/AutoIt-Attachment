sleep(2000)
$xpos=MouseGetPos (0)
$ypos=MouseGetPos (1)
sleep(2000)
$xpos1=MouseGetPos (0)
$ypos1=MouseGetPos (1)
while 1
$xpos1=MouseGetPos (0)
$ypos1=MouseGetPos (1)
if $ypos1=$ypos then
$pos=0
Else
Shutdown (12)
endif
$xpos=MouseGetPos (0)
$ypos=MouseGetPos (1)
sleep(100)
Wend