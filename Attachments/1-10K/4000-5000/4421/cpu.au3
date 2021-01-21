#include <GUIconstants.au3>
$turn = 0
Autoitsetoption("WinDetectHiddenText",1)
Run(@windowsdir & "\system32\taskmgr.exe","",@SW_HIDE)
processwait("taskmgr.exe")
sleep(500)
GUICreate("R",10,100,0,0,0x80000200)
$pro = GUICtrlCreateProgress(0,0,10,100,0x04)
GUISetState()
WinSetOnTop("R","",1)
while 1
	$msg = GuiGetMsg()
	$s = StatusbarGetText("Windows Task Manager","",2)
	$s = Stringsplit($s," ")
	$s = Stringsplit($s[3],"%")
	GUICtrlSetData(-1,$s[1])
	$mo = GUIGetCursorInfo()
	If $mo[2] = 1 and $mo[4] = $pro then
		Do
			$mo = GUIGetCursorInfo("R")
			$po = Wingetpos("R")
			WinMove("R","",$mo[0] + $po[0],$mo[1] + $po[1])
		Until $mo[2] = 0
	Endif
	If $mo[3] = 1 and $mo[4] = $pro then turn()
wend

Func turn()
	If $turn = 0 then
		$po = Wingetpos("R")
		Winmove("R","",$po[0],$po[1],100,10)
		GUICtrlSetPos($pro,0,0,100,10)
		GUICtrlSetStyle($pro,0x00)
	Endif
	If $turn = 1 then
		$po = Wingetpos("R")
		Winmove("R","",$po[0],$po[1],10,100)
		GUICtrlSetPos($pro,0,0,10,100)
		GUICtrlSetStyle($pro,0x04)
	endif
	Select 
		Case $turn = 0
			$turn = 1
		Case $turn = 1
			$turn = 0
	Endselect
	sleep(200)
Endfunc