
HotKeySet("{PAUSE}", "EndScript")
HotKeySet("{END}", "SetPause0")

; [x]	variabile		[x]

$undock = 25
$warptobelt = 70
$fillcargo = 300
$warptostation = 70
$dock = 25
$target = 5

$difftpause = 0
$diffpause = 0

$W1PosX = 0
$W1PosY = 0

$WinSelect1X = 20
$WinSelect1Y = 740

If WinExists("EVE") Then	; check if eve online is running
	WinActivate("EVE")		; ( activate EVE window )
	WinMove("EVE", "", 0, 0)	; places the eve-online window to 0.0 coordonates ( unless you placed it there in advaced this does it for you)
Else
	MsgBox(0,"START EVE FIRST!" &  @CRLF )
	Exit
EndIf



	

While 1 ;START MASTER LOOP
    CloseInfoMsg()
    ExitStation()
	nowundocked()
    FixLos()
	WarpToBelt()
	$pausetime = 25	
	PauseTime()
	loadice()
    mousemoves()
	finishwarptobelt()
	$yroid1 = 1 
	Sleep(300)
	StartMining()
	Sleep(300)
	loadgank()
	Sleep(300)
	mousemoves3()
	runaway()
	$pausetime = 5	
	PauseTime()
	aligning()
	$pausetime = 645
	PauseTime()
	speedup()
	$pausetime =14	
	PauseTime()
	unlock()
	Sleep(100)
	WarpToStation()
	Sleep(100)
	$pausetime =29	
	PauseTime()
	loadice()
	mousemoves2()
	finishwarptodock()
	Dock()
	nowdocked()
	$pausetime =5	
	PauseTime()
	UnloadToStation()
	$pausetime = Int(Random(1,5)) 	
	PauseTime()
	
	
WEnd ; ENDING MASTER LOOP


;	F  U  N  C  T  I   O   N   S

Func runaway()
    If (PixelGetColor(380,741)=0x4a4d4a ) Then
    $xspot = Random(140 , 190)	
	$yspot = Random(476 , 477)
	MouseClick("right", $xspot, $yspot )	
	Sleep(800)
	MouseClick("right", $xspot + Random(30,100), $yspot + 43)
	
	Sleep(30000)
	
    EndIf
EndFunc






Func nowdocked()
Do

Until PixelGetColor(897,90) = 0xc6e3bd
EndFunc


Func finishwarptodock()
Do

Until PixelGetColor(492,552) = 0x000000
EndFunc

Func finishwarptobelt()
Do

Until PixelGetColor(492,552) = 0x000000
EndFunc


Func nowundocked()
  Do

Until PixelGetColor(548, 744) = 0x528ec6
EndFunc

Func mousemoves()
	Sleep(100)
	MouseMove( Random(310,405) , Random(668,683))	
EndFunc

Func mousemoves2()
	Sleep(100)
	MouseMove( Random(140,190) , Random(476,477))	
EndFunc

Func mousemoves3()
	Sleep(100)
	MouseMove( Random(335,395) , Random(741,743))	
EndFunc


Func ExitStation()
	Sleep(100)
	MouseClick("left", Random(15,28) , Random(762,765))	
EndFunc

Func aligning()
	$xspot = Random(140 , 190)	
	$yspot = Random(457 , 458)
	MouseClick("right", $xspot, $yspot )	
	Sleep(500)
	MouseClick("right", $xspot + Random(30,100), $yspot + 10 )
	Sleep(7000)
	MouseClick("left", Random(467,469) , Random(735,737))	
	Sleep(100)
	MouseClick("left", Random(467,469) , Random(735,737))	
EndFunc

Func speedup()
	MouseClick("left", Random(558,560) , Random(735,737))
	EndFunc

Func WarpToBelt()
	$xspot = Random(140,190)	
	$yspot = Random(496,591)  
	MouseClick("right", $xspot , $yspot )	
	Sleep(500)
	MouseClick("right", $xspot + Random(30,100) , $yspot + 10 )
	
EndFunc
		


Func WarpToStation()
; cycle complete > warp to station
	$xspot = Random(140 ,190)	
	$yspot = Random(457 ,458)
	MouseClick("right", $xspot, $yspot )	
	Sleep(500)
	MouseClick("right", $xspot + Random(30,100), $yspot + 10 )
	
EndFunc

Func Dock()
; miner is near station > do "dock"
	$xspot = Random(140 , 190)	
	$yspot = Random(476 , 477)
	MouseClick("right", $xspot, $yspot )	; right click on " 2 - station - dock "
	Sleep(800)
	MouseClick("right", $xspot + Random(30,100), $yspot + 26 )	; select option " dock " 
	
EndFunc

Func UnloadToStation()

	MouseClickDrag("left", Random(77, 110) , Random(700, 722), Random(325, 335), Random(700, 730))	; drag all to station hangar
	
	
EndFunc


	

Func StartMining()
Opt("MouseCoordMode", 0)
	Send("{CTRLDOWN}")
	MouseClick("left", Random(340, 390, 1) ,740+($yroid1*1) )		; target 1st item on overview
	Sleep(300)
	MouseClick("left", Random(340,390, 1) , 740+($yroid1*1) )
	Sleep(300)

	Send("{CTRLUP}")
	Sleep($target*500)
	; activate laser 1 on roid 1
	
	Sleep(100)
	Send("{F1}")	; activate laser #1 on roid #1
	Send("{F2}")
	

	
Opt("MouseCoordMode", 1)
EndFunc

	




Func PauseTime()
	$tpause =  TimerInit()
	While $diffpause < 1000 * $pausetime
	$diffpause = TimerDiff($tpause)
	$totalsecpause = $pausetime - Int($diffpause/1000)
	$minpause = Int($totalsecpause/60)
	$secpause = $totalsecpause - ($minpause*60)
	
	WEnd	
	$diffpause = 0
	$pausetime = 0
	ToolTip("")
EndFunc

Func SetPause0()
	If WinActive("EVE") Then
	$pausetime = 0
	$pausetime2 = 0
	EndIf
EndFunc

Func EndScript()
  $exit = MsgBox(4, "MACRO", "STOP????")
  If $exit = 6 Then
    Exit
  EndIf
EndFunc



Func FixLos()

	Sleep(100)
	MouseClickDrag("left", 515, 579, 460, 500)	
	Sleep(100)
EndFunc


Func CloseInfoMsg()
	MouseClick("left", 515,484)	; close the info
	Sleep(200)
EndFunc

Func unlock()

	Send("{F1}")
	EndFunc

Func loadice()
	$xspot = Random(305,307)	
	$yspot = Random(701,703)  
	MouseClick("right", $xspot , $yspot )	
	Sleep(1000)
	MouseClick("right", $xspot + Random(30,60) , $yspot + 12 )
	
EndFunc


Func loadgank()
	$xspot = Random(305,307)	
	$yspot = Random(701,703)  
	MouseClick("right", $xspot , $yspot )	
	Sleep(1000)
	MouseClick("right", $xspot + Random(30,60) , $yspot - 17 )
	
EndFunc