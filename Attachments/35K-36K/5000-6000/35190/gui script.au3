#include <windowsconstants.au3>

guicreate("Window",302,278,100,100,$WS_POPUP,$WS_EX_LAYERED)
guisetbkcolor(0x808000)
guictrlcreatepic("window.bmp",-1,-1,302,278)
guisetstate()

while 1
autoitsetoption ("mousecoordmode",1)
$O3=iniread("mousehook.txt","mouse","event","error")
$O1=mousegetpos()
$O2=wingetpos("Window")
if $O1[0]>$O2[0] then
if $O1[1]>$O2[1] then
if $O1[0]<$O2[0]+$O2[2] then
if $O1[1]<$O2[1]+$O2[3] then
if $O3="Left Down" then
autoitsetoption ("mousecoordmode",0)
$O4=mousegetpos()
winmove("Window","",$O1[0]-$O4[0],$O1[1]-$O4[1])
endif
endif
endif
endif
endif
wend