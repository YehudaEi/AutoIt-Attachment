;gcrackem
;zonehopper_v0.4! for Warhammer Online (1.2.1)
;
$loopnum = 1 ;system vars..
$Paused = 0
$tmp = 1
$top = 0
$timer = 0
$topleft = 0
$topright = 0
$mid = 0
$midleft = 0
$midright = 0
$bottom = 0
$bottomleft = 0
$bottomright = 0
$flytozone = 0
$flytoarea = 0
$waitflip = 0
$zonecount = 0
$stepforward = 0
$inzone = "Unkown"
;
;
; Until I find an efficient way to have the code search for the pixel's color codes within a given area
; please use AutoIT's (http://www.autoitscript.com/autoit3/downloads.shtml) window info tool to retrieve
; coordinates and color codes from Warhammer. Follow the example below to insert your own coords based on
; your game resolution and UI scale.
;
;
; --Flight Master Map Coords--
Dim $greenskin[2] = [1068, 260] ;Heres the x,y coords for the regions under "Realm Wars" on the flight master's map.
Dim $chaos[2] = [1069, 282]
Dim $elf[2] = [1072, 302]
;
Dim $kv[2] = [838, 327] ;Here you will put the coords for the actual zones from the flight master's map.
Dim $tm[2] = [839, 437]
Dim $bc[2] = [837, 551]
Dim $cw[2] = [836, 324]
Dim $praag[2] = [841, 442]
Dim $reik[2] = [838, 550]
Dim $eat[2] = [725, 683]
Dim $dw[2] = [613, 679]
Dim $cal[2] = [499, 683]
; --End Flight Master Map Coords--
;
;
; Here you will simply define a specific coord on your Action Point Bar, and the coords color code.
; Be sure that "Don't Fade Health Bar" is checked in your User settings.
; This is used by the code to check if the flight master map is open or not.  Make sure that the
; background area's fade when the map is opened. or the code will not work.
Dim $apbar[3] = [94, 32, 0xC3C41D] ;x, y, color code
;
; We need the same type of information from your Realm Status bar. Pick a coord that you know will
; be red when the zone flips on the bar, write down it's coords, then hover over the actual red part
; (if the zone hasn't flipped yet) and write down it's color code.
Dim $realmbar[3] = [712, 11, 0xB32B3E] ;x, y, color code
;
; Keep icon coords and color codes taken from the State of Realm interface.
Dim $keep_topleft[3] = [1331, 191, 0x962E2E] ;x, y, color code
Dim $keep_topright[3] = [1358, 191, 0x962E2E]
Dim $keep_midleft[3] = [1331, 237, 0x962E2E]
Dim $keep_midright[3] = [1358, 237, 0x962E2E]
Dim $keep_bottomleft[3] = [1331, 282, 0x952D2D]
Dim $keep_bottomright[3] = [1358, 282, 0x952D2D]
;
; Here you will enter the "Diamond Bar" coords from the state of realm for each region (dwarf vs greenskin
; , empire vs chaos, high elves vs dark eves).  The coordinates I am looking for are just to the right of
; each diamond.  Just make sure that the zone tooltip appears from SoR while you hover over the area.  This
; will let the bot know which zone is currently contested for each realm.
Dim $diamondbar_top_kv[3] = [1326, 197, 0xB00000]
Dim $diamondbar_top_tm[3] = [1358, 197, 0xB00000]
Dim $diamondbar_top_bc[3] = [1391, 197, 0xB00000]

Dim $diamondbar_mid_reik[3] = [1326, 242, 0xBD0000]
Dim $diamondbar_mid_praag[3] = [1358, 242, 0xBD0000]
Dim $diamondbar_mid_cw[3] = [1391, 242, 0xBD0000]

Dim $diamondbar_bottom_eat[3] = [1326, 288, 0xBD0000]
Dim $diamondbar_bottom_dw[3] = [1358, 288, 0xBD0000]
Dim $diamondbar_bottom_cal[3] = [1391, 288, 0xBD0000]
;
; That's it for setup.
;

HotKeySet("{f1}", "Pause")
HotKeySet("{f2}", "_stay_or_go") ;Press key to override zone searching and stay in current zone until it flips.

SplashTextOn("", "Zone Hopper: Loaded", "300", "100", "-1", "-1", 35, "Palatino Linotype", "12", "700")
Sleep(1200)
SplashOff()

While 1 ;main loop.  Waiting for two keeps to turn red from either the top, middle or bottom of SoR.
	Local $count
	ToolTip('Zone hopper: Running', 0, 0)
	While $waitflip = 1
		If PixelGetColor($realmbar[0], $realmbar[1]) = $realmbar[2] Then ;If the realm bar isn't red yet..
			$waitflip = 0
		Else
			ToolTip("Zone Hopper: Waiting on zone to flip", 0, 0)
			$zonecount = $zonecount + 1
			$timer = $zonecount * 340 / 60 ;was gonna make a visable timer on a tooltip.. still needs love.
		EndIf
		If $zonecount = 340 Then ;wait 28 mins then check SoR keeps again. (340 x 5 seconds)
			$zonecount = 0
			$waitflip = 0
		EndIf
		Sleep(5000)
	WEnd

	If PixelGetColor($keep_topleft[0], $keep_topleft[1]) = $keep_topleft[2] Then ;top left keep icon
		$topleft = 1
		Destro1() ;match
	Else
		$topleft = 0
		Order()
	EndIf

	If PixelGetColor($keep_topright[0], $keep_topright[1]) = $keep_topright[2] Then ;top right keep iconf
		$topright = 1
		Destro1()
	Else
		$topright = 0
		Order()
	EndIf

	If PixelGetColor($keep_midleft[0], $keep_midleft[1]) = $keep_midleft[2] Then ;mid left keep
		$midleft = 1
		Destro1();matching color
	Else
		$midleft = 0
		Order()
	EndIf
	If PixelGetColor($keep_midright[0], $keep_midright[1]) = $keep_midright[2] Then ;mid right keep
		$midright = 1
		Destro1();matching color
	Else
		$midright = 0
		Order()
	EndIf
	If PixelGetColor($keep_bottomleft[0], $keep_bottomleft[1]) = $keep_bottomleft[2] Then ;$zonebarred Then ;bottom left keep
		$bottomleft = 1
		Destro1()
	Else
		$bottomleft = 0
		Destro1()
	EndIf
	If PixelGetColor($keep_bottomright[0], $keep_bottomright[1]) = $keep_bottomright[2] Then ;$keepred[$x] Then ;bottom right keep
		$bottomright = 1
		Destro1()
	Else
		$bottomright = 0
		Order()
	EndIf
	If $tmp = 1 Then ;auto harvest when script is loaded, then wait on timers.
		$tmp = 0
		;Doclicks()
	EndIf
	;auto harvest stuff below
	Harvestcount()
WEnd

Func Destro1() ;heres the loop to verify that two keeps are red
	WinActivate("Warhammer: Age of Reckoning, Copyright 2001-2009 Electronic Arts, Inc.")
	;msgbox(0,"", "Destro1", 2)
	If $topright + $topleft = 2 Then
		$topleft = 0
		$topright = 0
		$flytoarea = "Dwarf vs Greenskin"
		Flyzone()
	EndIf
	If $midleft + $midright = 2 Then
		$midleft = 0
		$midright = 0
		$flytoarea = "Empire vs Chaos"
		Flyzone()
	EndIf
	If $bottomleft + $bottomright = 2 Then
		$bottomleft = 0
		$bottomright = 0
		;msgbox(0,"", "Destro1 elves.", 2)
		$flytoarea = "High Elves vs Dark Elves"
		Flyzone()
	EndIf

EndFunc   ;==>Destro1

Func Order()
EndFunc   ;==>Order


Func Flyzone() ;Designate the zone to fly to by reading the "diamond bar" in SoR.
	;Greenskin zones
	$waitflip = 1
	Sleep(1000)
	If $flytoarea = "Dwarf vs Greenskin" Then
		If PixelGetColor($diamondbar_top_kv[0], $diamondbar_top_kv[1]) = $diamondbar_top_kv[2] Then
			$flytozone = "Kadrin"
			Fly()
		EndIf
		If PixelGetColor($diamondbar_top_tm[0], $diamondbar_top_tm[1]) = $diamondbar_top_tm[2] Then
			$flytozone = "Thundermountain"
			;msgbox( 0, "", "Thundermountain",1)
			Fly()
		EndIf
		If PixelGetColor($diamondbar_top_bc[0], $diamondbar_top_bc[1]) = $diamondbar_top_bc[2] Then
			$flytozone = "Black Crag"
			Fly()
		EndIf
	EndIf
	;empire zones


	If $flytoarea = "Empire vs Chaos" Then
		If PixelGetColor($diamondbar_mid_reik[0], $diamondbar_mid_reik[1]) = $diamondbar_mid_reik[2] Then
			$flytozone = "Reikland"
			Fly()
		EndIf
		If PixelGetColor($diamondbar_mid_praag[0], $diamondbar_mid_praag[1]) = $diamondbar_mid_praag[2] Then
			$flytozone = "Praag"
			Fly()
		EndIf
		If PixelGetColor($diamondbar_mid_cw[0], $diamondbar_mid_cw[1]) = $diamondbar_mid_cw[2] Then
			$flytozone = "Chaos Wastes"
			Fly()
		EndIf
	EndIf
	;Elf zones

	If $flytoarea = "High Elves vs Dark Elves" Then
		;msgbox(0,"", "Destro1 elf", 2)
		If PixelGetColor($diamondbar_bottom_eat[0], $diamondbar_bottom_eat[1]) = $diamondbar_bottom_eat[2] Then
			$flytozone = "Eataine"
			Fly()
		EndIf
		If PixelGetColor($diamondbar_bottom_dw[0], $diamondbar_bottom_dw[1]) = $diamondbar_bottom_dw[2] Then
			$flytozone = "Dragon Wake"
			Fly()
		EndIf
		If PixelGetColor($diamondbar_bottom_cal[0], $diamondbar_bottom_cal[1]) = $diamondbar_bottom_cal[2] Then
			$flytozone = "Caledor"
			Fly()
		EndIf
	EndIf
EndFunc   ;==>Flyzone

Func Fly() ;This function does the actual mouse clicks checking for flight master and then zoning.
	Local $x1, $msg
	$x1 = 0
	$waitflip = 1
	$stepforward = 1
	$msg = StringFormat("Zone Hopper: Heading to %s from %s", $flytozone, $inzone)
	ToolTip($msg, 0, 0)
	Sleep(1000)
	WinActivate("Warhammer: Age of Reckoning, Copyright 2001-2009 Electronic Arts, Inc.")
	Sleep(1000)
	$x = 100
	While PixelGetColor($apbar[0], $apbar[1]) = $apbar[2] And $x < 800
		$x = $x + 20
		If $flytozone = $inzone Then ;only take that initial step forward if we are in a different zone.
			ToolTip("Zone Hopper: Waiting in" & $inzone, 0, 0)
		Else
			If $stepforward = 1 Then
				ToolTip("Zone Hopper: Stepping forward", 0, 0)
				Send("{w down}")
				Sleep(400)
				Send("{w up}")
				Sleep(1000)
			EndIf
			$stepforward = 0
		EndIf
		MouseMove(726, $x, 1)
		Sleep(100)
		MouseClick("right", 726, $x, 1, 1)
		Sleep(200)
		If $x > 750 Then
			Send("{a down}")
			Sleep(80)
			Send("{a up}")
			$x1 = $x1 + 1
			$x = 100
			If $x1 > 500 Then
				$stepforward = 1
				Send("{d down}")
				Sleep($x1 * 80)
				Send("{d up }")
				ExitLoop
			EndIf
		EndIf
	WEnd
	Sleep(1200)
	If $flytozone = "Kadrin" Then
		MouseClick("left", $greenskin[0], $greenskin[1], 1, 1)
		Sleep(2000)
		MouseClick("left", $kv[0], $kv[1], 1, 1)
		$waitflip = 1
	EndIf
	If $flytozone = "Thundermountain" Then
		MouseClick("left", $greenskin[0], $greenskin[1], 1, 1)
		Sleep(2000)
		MouseClick("left", $tm[0], $tm[1], 1)
		$waitflip = 1
	EndIf
	If $flytozone = "Black Crag" Then
		MouseClick("left", $greenskin[0], $greenskin[1], 1)
		Sleep(2000)
		MouseClick("left", $bc[0], $bc[1], 1)
		$waitflip = 1
	EndIf
	If $flytozone = "Chaos Wastes" Then
		MouseClick("left", $chaos[0], $chaos[1], 1)
		Sleep(2000)
		MouseClick("left", $cw[0], $cw[1], 1)
		$waitflip = 1
	EndIf

	If $flytozone = "Praag" Then
		MouseClick("left", $chaos[0], $chaos[1], 1)
		Sleep(2000)
		MouseClick("left", $praag[0], $praag[1], 1)
		$waitflip = 1
	EndIf

	If $flytozone = "Reikland" Then
		MouseClick("left", $chaos[0], $chaos[1], 1)
		Sleep(2000)
		MouseClick("left", $reik[0], $reik[1], 1)
		$waitflip = 1
	EndIf

	If $flytozone = "Eataine" Then
		MouseClick("left", $elf[0], $elf[1], 1)
		Sleep(2000)
		MouseClick("left", $eat[0], $eat[1], 1)
		$waitflip = 1
	EndIf

	If $flytozone = "Dragon Wake" Then
		MouseClick("left", $elf[0], $elf[1], 1)
		Sleep(1000)
		MouseClick("left", $dw[0], $dw[1], 1)
		Sleep(1000)
		$waitflip = 1
	EndIf

	If $flytozone = "Caledor" Then
		MouseClick("left", $elf[0], $elf[1], 1)
		Sleep(2000)
		MouseClick("left", $cal[0], $cal[1], 1)
		$waitflip = 1
	EndIf
	Sleep(2000)
	Send("{ESC}")
	$inzone = $flytozone
EndFunc   ;==>Fly



Func Doclicks() ;harvesting automation (not used yet)
	$activeWin = WinGetTitle("")
	WinActivate("Warhammer: Age of Reckoning, Copyright 2001-2009 Electronic Arts, Inc.")
	Sleep(1000)
	MouseClick("left", 1421, 496, 2)
	Sleep(1000)
	MouseClick("left", 1421, 515, 1)
	Sleep(1000)
	MouseClick("left", 1421, 534, 1)
	Sleep(1000)
	MouseClick("left", 1421, 553, 1)
	Sleep(1000)
	WinActivate($activeWin)
EndFunc   ;==>Doclicks

Func Harvestcount() ;(not used yet)
	$count = $count + 1
	Sleep(5 * 1000)
	If $count = 40 Then
		;Doclicks()
		Send("q")
		$count = 0
	EndIf
EndFunc   ;==>Harvestcount

Func Pause() ;pause button.
	ToolTip("")
	If $Paused = 0 Then
		$Paused = 1
	Else
		$Paused = 0
	EndIf
	While $Paused = 1
		Sleep(5000)
	WEnd
EndFunc   ;==>Pause

Func _stay_or_go()
	If $waitflip = 0 Then
		$waitflip = 1
	Else
		$waitflip = 0
	EndIf
EndFunc   ;==>_stay_or_go
