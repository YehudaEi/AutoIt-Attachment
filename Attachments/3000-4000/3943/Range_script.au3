$train = "56"
If WinExists($train) Then Exit
AutoItWinSetTitle($train)
AutoItSetOption("PixelCoordMode", "1")
HotKeySet("{Esc}", "escape")
AutoItSetOption("SendKeyDelay", "12")
HotKeySet("{END}", "Pause")
$x = 0
$y = 0
$Clickselfloop = 0
$Clickselfloop2 = 0
$shakeloop = 0
$x = InputBox("Question", "set $X to...? (0 = 3 || 10 = 17 || 20 = 33 || 30 = 47 || 39 = 68", "0", "", -1, -1, 300, 250, 25)
runworld()
;g0blin searchin'!
Do
	WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "91", "800", "680") ;was 91 y
	;WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "-5", "800", "766") ;was 91 y
	Sleep(48000)
	$begin000 = TimerStart ()
	Do
		Sleep(1500)
		$frt1 = PixelGetColor(577, 430)
		$frt2 = PixelGetColor(219, 446)
		$frt3 = PixelGetColor(249, 475)
	Until $frt1 = 723723 And $frt2 = 723723 And $frt3 = 723723 Or TimerStop ($begin000) >= 1000 * 40
	Sleep(100)
	chars()
	randomizesleep()
	Sleep(15000 + $sleeper)
	$startxclose = 476
	$startyclose = 292
	$xclose = Int(Random($startxclose - 8, $startxclose + 8))
	$yclose = Int(Random($startyclose - 2, $startyclose + 2))
	MouseClick("left", $xclose, $yclose, 1, 5);Closes Welcome Screen
	randomizesleep()
	Sleep(1000 + $sleeper)
	Strengthandmageset()
	Send("{Down down}")
	randomizesleep()
	Sleep(1500 + $sleeper)
	Send("{Down up}")
	Sleep(1000)
	Send("{Right down}")
	$looptimer1 = TimerStart ()
	Do
		$comp1 = 0
		$comp2 = 0
		$comp3 = 0
		$comp4 = 0
		$comp5 = 0
		$comp6 = 0
		$comp7 = 0
		$comp8 = 0
		$comp9 = 0
		$comp1 = PixelGetColor(591, 219)
		$comp2 = PixelGetColor(593, 219)
		$comp3 = PixelGetColor(595, 219)
		$comp4 = PixelGetColor(597, 219)
		$comp5 = PixelGetColor(593, 220)
		$comp6 = PixelGetColor(595, 223)
		$comp7 = PixelGetColor(594, 222)
		$comp8 = PixelGetColor(591, 222)
		$comp9 = PixelGetColor(589, 222)
	Until $comp1 = 4128768 And $comp2 = 4128768 And $comp3 = 4128768 And $comp4 = 4128768 And $comp5 = 4128768 And $comp6 = 4128768 And $comp7 = 4128768 And $comp8 = 4128768 And $comp9 = 4128768 Or TimerStop ($looptimer1) >= 1000 * 20
	Send("{Right up}")
	$isalready = 0
	$searchloop = 0
	$autotrain1 = TimerStart ()
	Sleep(3000)
	Do
		Do
			$foundagob = 0
			randomizemore()
			MouseMove(108 + $clickmx, 595 + $clickmy, 0)
			If $searchloop = 0 Then
				$searchloop = 1
				$cowbar = PixelSearch(80, 217, 142, 261, 7027972, 3, 1);(129, 217, 271, 349, 7027972, 3, 1);(139, 237, 271, 349, 7027972, 3, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf
			If $searchloop = 1 Then
				$searchloop = 2
				$cowbar = PixelSearch(390, 302, 460, 349, 7027972, 3, 1);(271, 217, 390, 349, 7027972, 3, 1) ;(271, 200, 390, 349, 7027972, 3, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf
			If $searchloop = 2 Then
				$searchloop = 3
				$cowbar = PixelSearch(204, 261, 266, 305, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf
			If $searchloop = 3 Then
				$searchloop = 4
				$cowbar = PixelSearch(460, 255, 530, 302, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf
			If $searchloop = 4 Then
				$searchloop = 5
				$cowbar = PixelSearch(328, 261, 390, 305, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 5 Then
				$searchloop = 6
				$cowbar = PixelSearch(80, 305, 142, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 6 Then
				$searchloop = 7
				$cowbar = PixelSearch(390, 208, 460, 255, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 7 Then
				$searchloop = 8
				$cowbar = PixelSearch(204, 305, 266, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 8 Then
				$searchloop = 9
				$cowbar = PixelSearch(460, 302, 530, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 9 Then
				$searchloop = 10
				$cowbar = PixelSearch(80, 261, 142, 305, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 10 Then
				$searchloop = 11
				$cowbar = PixelSearch(266, 217, 328, 261, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 11 Then
				$searchloop = 12
				$cowbar = PixelSearch(266, 305, 328, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 12 Then
				$searchloop = 13
				$cowbar = PixelSearch(142, 305, 204, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 13 Then
				$searchloop = 14
				$cowbar = PixelSearch(328, 305, 390, 349, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 14 Then
				$searchloop = 15
				$cowbar = PixelSearch(142, 261, 204, 305, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 15 Then
				$searchloop = 16
				$cowbar = PixelSearch(390, 255, 460, 302, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 16 Then
				$searchloop = 17
				$cowbar = PixelSearch(266, 261, 328, 305, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 17 Then
				$searchloop = 18
				$cowbar = PixelSearch(142, 217, 204, 261, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 18 Then
				$searchloop = 19
				$cowbar = PixelSearch(328, 217, 390, 261, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		
			If $searchloop = 19 Then
				$searchloop = 0
				$cowbar = PixelSearch(204, 217, 266, 261, 7027972, 5, 1);(390, 208, 530, 349, 7027972, 5, 1) ;(390, 196, 500, 349, 7027972, 5, 1)
				If Not @error Then
					Randomizegoblin()
					$cowbarclickx = $cowbar[0] + $clickcx
					$cowbarclicky = $cowbar[1] + $clickcy
					MouseClick( "right", $cowbarclickx, $cowbarclicky, 1, 0)
					checkforgoblinname()
					ExitLoop
				EndIf
			EndIf		

	Until $foundagob = 1 Or TimerStop ($autotrain1) >= 1000 * 60 * 11
		If $foundagob = 1 Then
			makesureimfighting()
			makesureididntmove()
		EndIf
	Until TimerStop ($autotrain1) >= 1000 * 60 * 11
	logout()
	WinClose("RuneScape Game - Microsoft Internet Explorer", "")
	WinClose("Cannot find server - Microsoft Internet Explorer", "")
	Sleep(10)
	WinClose("RuneScape Game - Microsoft Internet Explorer", "")
	Sleep(100)
	runworld()
Until $y = 99
Func makesureididntmove()
	$movetimer = TimerStart ()
	Do
		Sleep(150)
		$water = PixelGetColor(663, 273);667, 276)
		$water1 = Round($water, -6)
		;MsgBox(0, "Value of $uhoh1 is:", $uhoh1)
		If $water1 <> 5000000 Then  ;5268621
			$1clickx = Int(Random(0 - 1, 0 + 1))
			$1clicky = Int(Random(0 - 1, 0 + 1))
			$1clickx1 = 665 + $1clickx
			$1clicky1 = 276 + $1clicky ;was 278
			;Send("{LCTRL Down}")
			MouseClick( "left", $1clickx1, $1clicky1, 1, 0)
			;Send("{LCTRL up}")
			randomizesleep()
			Sleep(4050 + $sleeper)
		EndIf
		$water2nd = PixelGetColor(663, 273)
		$1water2nd = Round($water2nd, -6)
	Until $1water2nd = 5000000 Or TimerStop ($movetimer) >= 1000 * 20
	$water3rd = PixelGetColor(663, 273)
	$water3rd1 = Round($water3rd, -6)
	;MsgBox(0, "Value of $uhoh1 is:", $uhoh1)
	If $water3rd1 <> 5000000 Then  ;5268621
		logout()
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		$soundplay = 0
		Do
			SoundPlay("C:\Windows\media\chimes.wav")
			$soundplay = $soundplay + 1
			Sleep(400)
		Until $soundplay = 25
	EndIf
	Sleep(1000)
	$water3rd = PixelGetColor(663, 273)
	$water3rd1 = Round($water3rd, -6)
	;MsgBox(0, "Value of $uhoh1 is:", $uhoh1)
	If $water3rd1 <> 5000000 Then  ;5268621
		logout()
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		SoundPlay("C:\Windows\media\Windows XP Battery Low.wav")
		Sleep(400)
		$soundplay = 0
		Do
			SoundPlay("C:\Windows\media\chimes.wav")
			$soundplay = $soundplay + 1
			Sleep(400)
		Until $soundplay = 25
	EndIf
EndFunc   ;==>makesureididntmove
Func makesureimfighting()
	;; -- ;; Sleep(2000)
	Do
		$01checkrunes01 = PixelGetColor(713, 449)  ; 713 to 720  --- 449 to 456
		$01checkrunes02 = PixelGetColor(713, 451)
		$01checkrunes03 = PixelGetColor(713, 452)
		$01checkrunes04 = PixelGetColor(713, 453)
		$01checkrunes05 = PixelGetColor(713, 454)
		$01checkrunes06 = PixelGetColor(713, 455)
		$01checkrunes07 = PixelGetColor(713, 456)
		$01checkrunes08 = PixelGetColor(714, 449)
		$01checkrunes09 = PixelGetColor(714, 451)
		$01checkrunes10 = PixelGetColor(714, 452)
		$01checkrunes11 = PixelGetColor(714, 453)
		$01checkrunes12 = PixelGetColor(714, 454)
		$01checkrunes13 = PixelGetColor(714, 455)
		$01checkrunes14 = PixelGetColor(714, 456)
		$01checkrunes15 = PixelGetColor(715, 449)
		$01checkrunes16 = PixelGetColor(715, 451)
		$01checkrunes17 = PixelGetColor(715, 452)
		$01checkrunes18 = PixelGetColor(715, 453)
		$01checkrunes19 = PixelGetColor(715, 454)
		$01checkrunes20 = PixelGetColor(715, 455)
		$01checkrunes21 = PixelGetColor(715, 456)
		$01checkrunes22 = PixelGetColor(716, 449)
		$01checkrunes23 = PixelGetColor(716, 451)
		$01checkrunes24 = PixelGetColor(716, 452)
		$01checkrunes25 = PixelGetColor(716, 453)
		$01checkrunes26 = PixelGetColor(716, 454)
		$01checkrunes27 = PixelGetColor(716, 455)
		$01checkrunes28 = PixelGetColor(716, 456)
		$01checkrunes29 = PixelGetColor(717, 449)
		$01checkrunes30 = PixelGetColor(717, 451)
		$01checkrunes31 = PixelGetColor(717, 452)
		$01checkrunes32 = PixelGetColor(717, 453)
		$01checkrunes33 = PixelGetColor(717, 454)
		$01checkrunes34 = PixelGetColor(717, 455)
		$01checkrunes35 = PixelGetColor(717, 456)
		$01checkrunes36 = PixelGetColor(718, 449)
		$01checkrunes37 = PixelGetColor(718, 451)
		$01checkrunes38 = PixelGetColor(718, 452)
		$01checkrunes39 = PixelGetColor(718, 453)
		$01checkrunes40 = PixelGetColor(718, 454)
		$01checkrunes41 = PixelGetColor(718, 455)
		$01checkrunes42 = PixelGetColor(718, 456)
		$01checkrunes43 = PixelGetColor(719, 449)
		$01checkrunes44 = PixelGetColor(719, 451)
		$01checkrunes45 = PixelGetColor(719, 452)
		$01checkrunes46 = PixelGetColor(719, 453)
		$01checkrunes47 = PixelGetColor(719, 454)
		$01checkrunes48 = PixelGetColor(719, 455)
		$01checkrunes49 = PixelGetColor(719, 456)
		$01checkrunes50 = PixelGetColor(720, 449)
		$01checkrunes51 = PixelGetColor(720, 451)
		$01checkrunes52 = PixelGetColor(720, 452)
		$01checkrunes53 = PixelGetColor(720, 453)
		$01checkrunes54 = PixelGetColor(720, 454)
		$01checkrunes55 = PixelGetColor(720, 455)
		$01checkrunes56 = PixelGetColor(720, 456)
		$01checkrunes57 = PixelGetColor(721, 449)
		$01checkrunes58 = PixelGetColor(721, 451)
		$01checkrunes59 = PixelGetColor(721, 452)
		$01checkrunes60 = PixelGetColor(721, 453)
		$01checkrunes61 = PixelGetColor(721, 454)
		$01checkrunes62 = PixelGetColor(721, 455)
		$01checkrunes63 = PixelGetColor(721, 456)
		$01checkrunes64 = PixelGetColor(707, 449); 707 - 712 x here
		$01checkrunes65 = PixelGetColor(707, 451)
		$01checkrunes66 = PixelGetColor(707, 452)
		$01checkrunes67 = PixelGetColor(707, 453)
		$01checkrunes68 = PixelGetColor(707, 454)
		$01checkrunes69 = PixelGetColor(707, 455)
		$01checkrunes70 = PixelGetColor(707, 456)
		$01checkrunes71 = PixelGetColor(708, 449)
		$01checkrunes72 = PixelGetColor(708, 451)
		$01checkrunes73 = PixelGetColor(708, 452)
		$01checkrunes74 = PixelGetColor(708, 453)
		$01checkrunes75 = PixelGetColor(708, 454)
		$01checkrunes76 = PixelGetColor(708, 455)
		$01checkrunes77 = PixelGetColor(708, 456)
		$01checkrunes78 = PixelGetColor(709, 449)
		$01checkrunes79 = PixelGetColor(709, 451)
		$01checkrunes80 = PixelGetColor(709, 452)
		$01checkrunes81 = PixelGetColor(709, 453)
		$01checkrunes82 = PixelGetColor(709, 454)
		$01checkrunes83 = PixelGetColor(709, 455)
		$01checkrunes84 = PixelGetColor(709, 456)
		$01checkrunes85 = PixelGetColor(710, 449)
		$01checkrunes86 = PixelGetColor(710, 451)
		$01checkrunes87 = PixelGetColor(710, 452)
		$01checkrunes88 = PixelGetColor(710, 453)
		$01checkrunes89 = PixelGetColor(710, 454)
		$01checkrunes90 = PixelGetColor(710, 455)
		$01checkrunes91 = PixelGetColor(710, 456)
		$01checkrunes92 = PixelGetColor(711, 449)
		$01checkrunes93 = PixelGetColor(711, 451)
		$01checkrunes94 = PixelGetColor(711, 452)
		$01checkrunes95 = PixelGetColor(711, 453)
		$01checkrunes96 = PixelGetColor(711, 454)
		$01checkrunes97 = PixelGetColor(711, 455)
		$01checkrunes98 = PixelGetColor(711, 456)
		$01checkrunes99 = PixelGetColor(712, 449)
		$01checkrunes100 = PixelGetColor(712, 451)
		$01checkrunes101 = PixelGetColor(712, 452)
		$01checkrunes102 = PixelGetColor(712, 453)
		$01checkrunes103 = PixelGetColor(712, 454)
		$01checkrunes104 = PixelGetColor(712, 455)
		$01checkrunes105 = PixelGetColor(712, 456)
		randomize()
		;$1x1 = 253 + $clickx
		;$1y1 = 645 + $clicky
		;MouseClick( "left", $1x1, $1y1, 1, 0)
		Sleep(2500)
		$0checkrunes01 = PixelGetColor(713, 449)
		$0checkrunes02 = PixelGetColor(713, 451)
		$0checkrunes03 = PixelGetColor(713, 452)
		$0checkrunes04 = PixelGetColor(713, 453)
		$0checkrunes05 = PixelGetColor(713, 454)
		$0checkrunes06 = PixelGetColor(713, 455)
		$0checkrunes07 = PixelGetColor(713, 456)
		$0checkrunes08 = PixelGetColor(714, 449)
		$0checkrunes09 = PixelGetColor(714, 451)
		$0checkrunes10 = PixelGetColor(714, 452)
		$0checkrunes11 = PixelGetColor(714, 453)
		$0checkrunes12 = PixelGetColor(714, 454)
		$0checkrunes13 = PixelGetColor(714, 455)
		$0checkrunes14 = PixelGetColor(714, 456)
		$0checkrunes15 = PixelGetColor(715, 449)
		$0checkrunes16 = PixelGetColor(715, 451)
		$0checkrunes17 = PixelGetColor(715, 452)
		$0checkrunes18 = PixelGetColor(715, 453)
		$0checkrunes19 = PixelGetColor(715, 454)
		$0checkrunes20 = PixelGetColor(715, 455)
		$0checkrunes21 = PixelGetColor(715, 456)
		$0checkrunes22 = PixelGetColor(716, 449)
		$0checkrunes23 = PixelGetColor(716, 451)
		$0checkrunes24 = PixelGetColor(716, 452)
		$0checkrunes25 = PixelGetColor(716, 453)
		$0checkrunes26 = PixelGetColor(716, 454)
		$0checkrunes27 = PixelGetColor(716, 455)
		$0checkrunes28 = PixelGetColor(716, 456)
		$0checkrunes29 = PixelGetColor(717, 449)
		$0checkrunes30 = PixelGetColor(717, 451)
		$0checkrunes31 = PixelGetColor(717, 452)
		$0checkrunes32 = PixelGetColor(717, 453)
		$0checkrunes33 = PixelGetColor(717, 454)
		$0checkrunes34 = PixelGetColor(717, 455)
		$0checkrunes35 = PixelGetColor(717, 456)
		$0checkrunes36 = PixelGetColor(718, 449)
		$0checkrunes37 = PixelGetColor(718, 451)
		$0checkrunes38 = PixelGetColor(718, 452)
		$0checkrunes39 = PixelGetColor(718, 453)
		$0checkrunes40 = PixelGetColor(718, 454)
		$0checkrunes41 = PixelGetColor(718, 455)
		$0checkrunes42 = PixelGetColor(718, 456)
		$0checkrunes43 = PixelGetColor(719, 449)
		$0checkrunes44 = PixelGetColor(719, 451)
		$0checkrunes45 = PixelGetColor(719, 452)
		$0checkrunes46 = PixelGetColor(719, 453)
		$0checkrunes47 = PixelGetColor(719, 454)
		$0checkrunes48 = PixelGetColor(719, 455)
		$0checkrunes49 = PixelGetColor(719, 456)
		$0checkrunes50 = PixelGetColor(720, 449)
		$0checkrunes51 = PixelGetColor(720, 451)
		$0checkrunes52 = PixelGetColor(720, 452)
		$0checkrunes53 = PixelGetColor(720, 453)
		$0checkrunes54 = PixelGetColor(720, 454)
		$0checkrunes55 = PixelGetColor(720, 455)
		$0checkrunes56 = PixelGetColor(720, 456)
		$0checkrunes57 = PixelGetColor(721, 449)
		$0checkrunes58 = PixelGetColor(721, 451)
		$0checkrunes59 = PixelGetColor(721, 452)
		$0checkrunes60 = PixelGetColor(721, 453)
		$0checkrunes61 = PixelGetColor(721, 454)
		$0checkrunes62 = PixelGetColor(721, 455)
		$0checkrunes63 = PixelGetColor(721, 456)
		$0checkrunes64 = PixelGetColor(707, 449); 707 - 712 x here
		$0checkrunes65 = PixelGetColor(707, 451)
		$0checkrunes66 = PixelGetColor(707, 452)
		$0checkrunes67 = PixelGetColor(707, 453)
		$0checkrunes68 = PixelGetColor(707, 454)
		$0checkrunes69 = PixelGetColor(707, 455)
		$0checkrunes70 = PixelGetColor(707, 456)
		$0checkrunes71 = PixelGetColor(708, 449)
		$0checkrunes72 = PixelGetColor(708, 451)
		$0checkrunes73 = PixelGetColor(708, 452)
		$0checkrunes74 = PixelGetColor(708, 453)
		$0checkrunes75 = PixelGetColor(708, 454)
		$0checkrunes76 = PixelGetColor(708, 455)
		$0checkrunes77 = PixelGetColor(708, 456)
		$0checkrunes78 = PixelGetColor(709, 449)
		$0checkrunes79 = PixelGetColor(709, 451)
		$0checkrunes80 = PixelGetColor(709, 452)
		$0checkrunes81 = PixelGetColor(709, 453)
		$0checkrunes82 = PixelGetColor(709, 454)
		$0checkrunes83 = PixelGetColor(709, 455)
		$0checkrunes84 = PixelGetColor(709, 456)
		$0checkrunes85 = PixelGetColor(710, 449)
		$0checkrunes86 = PixelGetColor(710, 451)
		$0checkrunes87 = PixelGetColor(710, 452)
		$0checkrunes88 = PixelGetColor(710, 453)
		$0checkrunes89 = PixelGetColor(710, 454)
		$0checkrunes90 = PixelGetColor(710, 455)
		$0checkrunes91 = PixelGetColor(710, 456)
		$0checkrunes92 = PixelGetColor(711, 449)
		$0checkrunes93 = PixelGetColor(711, 451)
		$0checkrunes94 = PixelGetColor(711, 452)
		$0checkrunes95 = PixelGetColor(711, 453)
		$0checkrunes96 = PixelGetColor(711, 454)
		$0checkrunes97 = PixelGetColor(711, 455)
		$0checkrunes98 = PixelGetColor(711, 456)
		$0checkrunes99 = PixelGetColor(712, 449)
		$0checkrunes100 = PixelGetColor(712, 451)
		$0checkrunes101 = PixelGetColor(712, 452)
		$0checkrunes102 = PixelGetColor(712, 453)
		$0checkrunes103 = PixelGetColor(712, 454)
		$0checkrunes104 = PixelGetColor(712, 455)
		$0checkrunes105 = PixelGetColor(712, 456)
		;$1x1 = 253 + $clickx
		;$1y1 = 645 + $clicky
		;MouseClick( "left", $1x1, $1y1, 1, 0)
	Until $01checkrunes01 = $0checkrunes01 And $01checkrunes02 = $0checkrunes02 And $01checkrunes03 = $0checkrunes03 And $01checkrunes04 = $0checkrunes04 And $01checkrunes05 = $0checkrunes05 And $01checkrunes06 = $0checkrunes06 And $01checkrunes07 = $0checkrunes07 And $01checkrunes08 = $0checkrunes08 And $01checkrunes09 = $0checkrunes09 And $01checkrunes10 = $0checkrunes10 And $01checkrunes11 = $0checkrunes11 And $01checkrunes12 = $0checkrunes12 And $01checkrunes13 = $0checkrunes13 And $01checkrunes14 = $0checkrunes14 And $01checkrunes15 = $0checkrunes15 And $01checkrunes16 = $0checkrunes16 And $01checkrunes17 = $0checkrunes17 And $01checkrunes18 = $0checkrunes18 And $01checkrunes19 = $0checkrunes19 And $01checkrunes20 = $0checkrunes20 And $01checkrunes21 = $0checkrunes21 And $01checkrunes22 = $0checkrunes22 And $01checkrunes23 = $0checkrunes23 And $01checkrunes24 = $0checkrunes24 And $01checkrunes25 = $0checkrunes25 And $01checkrunes26 = $0checkrunes26 And $01checkrunes27 = $0checkrunes27 And $01checkrunes28 = $0checkrunes28 And $01checkrunes29 = $0checkrunes29 And $01checkrunes30 = $0checkrunes30 And $01checkrunes31 = $0checkrunes31 And $01checkrunes32 = $0checkrunes32 And $01checkrunes33 = $0checkrunes33 And $01checkrunes34 = $0checkrunes34 And $01checkrunes35 = $0checkrunes35 And $01checkrunes36 = $0checkrunes36 And $01checkrunes37 = $0checkrunes37 And $01checkrunes38 = $0checkrunes38 And $01checkrunes39 = $0checkrunes39 And $01checkrunes40 = $0checkrunes40 And $01checkrunes41 = $0checkrunes41 And $01checkrunes42 = $0checkrunes42 And $01checkrunes43 = $0checkrunes43 And $01checkrunes44 = $0checkrunes44 And $01checkrunes45 = $0checkrunes45 And $01checkrunes46 = $0checkrunes46 And $01checkrunes47 = $0checkrunes47 And $01checkrunes48 = $0checkrunes48 And $01checkrunes49 = $0checkrunes49 And $01checkrunes50 = $0checkrunes50 And $01checkrunes51 = $0checkrunes51 And $01checkrunes52 = $0checkrunes52 And $01checkrunes53 = $0checkrunes53 And $01checkrunes54 = $0checkrunes54 And $01checkrunes55 = $0checkrunes55 And $01checkrunes56 = $0checkrunes56 And $01checkrunes57 = $0checkrunes57 And $01checkrunes58 = $0checkrunes58 And $01checkrunes59 = $0checkrunes59 And $01checkrunes60 = $0checkrunes60 And $01checkrunes61 = $0checkrunes61 And $01checkrunes62 = $0checkrunes62 And $01checkrunes63 = $0checkrunes63 And $01checkrunes64 = $0checkrunes64 And $01checkrunes65 = $0checkrunes65 And $01checkrunes66 = $0checkrunes66 And $01checkrunes67 = $0checkrunes67 And $01checkrunes68 = $0checkrunes68 And $01checkrunes69 = $0checkrunes69 And $01checkrunes70 = $0checkrunes70 And $01checkrunes71 = $0checkrunes71 And $01checkrunes72 = $0checkrunes72 And $01checkrunes73 = $0checkrunes73 And $01checkrunes74 = $0checkrunes74 And $01checkrunes75 = $0checkrunes75 And $01checkrunes76 = $0checkrunes76 And $01checkrunes77 = $0checkrunes77 And $01checkrunes78 = $0checkrunes78 And $01checkrunes79 = $0checkrunes79 And $01checkrunes80 = $0checkrunes80 And $01checkrunes81 = $0checkrunes81 And $01checkrunes82 = $0checkrunes82 And $01checkrunes83 = $0checkrunes83 And $01checkrunes84 = $0checkrunes84 And $01checkrunes85 = $0checkrunes85 And $01checkrunes86 = $0checkrunes86 And $01checkrunes87 = $0checkrunes87 And $01checkrunes88 = $0checkrunes88 And $01checkrunes89 = $0checkrunes89 And $01checkrunes90 = $0checkrunes90 And $01checkrunes91 = $0checkrunes91 And $01checkrunes92 = $0checkrunes92 And $01checkrunes93 = $0checkrunes93 And $01checkrunes94 = $0checkrunes94 And $01checkrunes95 = $0checkrunes95 And $01checkrunes96 = $0checkrunes96 And $01checkrunes97 = $0checkrunes97 And $01checkrunes98 = $0checkrunes98 And $01checkrunes99 = $0checkrunes99 And $01checkrunes100 = $0checkrunes100 And $01checkrunes101 = $0checkrunes101 And $01checkrunes102 = $0checkrunes102 And $01checkrunes103 = $0checkrunes103 And $01checkrunes104 = $0checkrunes104 And $01checkrunes105 = $0checkrunes105
	;Sleep(1500)
EndFunc   ;==>makesureimfighting
Func lookforalreadyunderattack()
	Sleep(1000)
	$isalready = 0
	$checkalready1 = 0
	$checkalready2 = 0
	$checkalready3 = 0
	$checkalready4 = 0
	$checkalready5 = 0
	$checkalready6 = 0
	$checkalready7 = 0
	$checkalready8 = 0
	$checkalready9 = 0
	$checkalready10 = 0
	$checkalready11 = 0
	$checkalready12 = 0
	$checkalready13 = 0
	$checkalready14 = 0
	$checkalready15 = 0
	$checkalready1 = PixelGetColor(41, 616)
	$checkalready2 = PixelGetColor(41, 616)
	$checkalready3 = PixelGetColor(40, 617)
	$checkalready4 = PixelGetColor(43, 617)
	$checkalready5 = PixelGetColor(39, 618)
	$checkalready6 = PixelGetColor(40, 619)
	$checkalready7 = PixelGetColor(41, 620)
	$checkalready8 = PixelGetColor(42, 621)
	$checkalready9 = PixelGetColor(43, 622)
	$checkalready10 = PixelGetColor(143, 629)
	$checkalready11 = PixelGetColor(144, 629)
	$checkalready12 = PixelGetColor(145, 629)
	$checkalready13 = PixelGetColor(172, 629)
	$checkalready14 = PixelGetColor(173, 629)
	$checkalready15 = PixelGetColor(174, 629)
	If $checkalready1 = 0 And $checkalready2 = 0 And $checkalready3 = 0 And $checkalready4 = 0 And $checkalready5 = 0 And $checkalready6 = 0 And $checkalready7 = 0 And $checkalready8 = 0 And $checkalready9 = 0 And $checkalready10 = 0 And $checkalready11 = 0 And $checkalready12 = 0 And $checkalready13 = 0 And $checkalready14 = 0 And $checkalready15 = 0 Then
		$isalready = 1
	EndIf
EndFunc   ;==>lookforalreadyunderattack
Func checkforgoblinname()
	$cowsnamesearch1x = $cowbarclickx - 150
	$cowsnamesearch1y = $cowbarclicky
	$cowsnamesearch2x = $cowbarclickx + 250
	$cowsnamesearch2y = $cowbarclicky + 250
	$elow100f = 0
	$elow101f = 0
	$elow102f = 0
	$elow103f = 0
	$elow104f = 0
	$elow105f = 0
	$elow106f = 0
	$elow107f = 0
	$elow108f = 0
	$elow109f = 0
	$coord2 = PixelSearch($cowsnamesearch1x, $cowsnamesearch1y, $cowsnamesearch2x, $cowsnamesearch2y, 16776960, 0, 0) ;look for name of NPC
	If Not @error Then
		$elow100y = $coord2[1] + 2
		$elow100y1 = $coord2[1] + 3
		$elow100y2 = $coord2[1] + 4
		$elow100y3 = $coord2[1] + 8
		$elow100 = $coord2[0] + 1
		$elow101 = $coord2[0] + 4
		$elow102 = $coord2[0] + 5
		$elow103 = $coord2[0] + 16
		$elow104 = $coord2[0] + 17
		$elow105 = $coord2[0]
		$elow106 = $coord2[0]
		$elow107 = $coord2[0]
		$elow108 = $coord2[0]
		$elow109 = $coord2[0]
		$elow100f = PixelGetColor($elow100, $elow100y)
		$elow101f = PixelGetColor($elow101, $elow100y1)
		$elow102f = PixelGetColor($elow102, $elow100y2)
		$elow103f = PixelGetColor($elow103, $elow100y3)
		$elow104f = PixelGetColor($elow104, $elow100y)
		$elow105f = PixelGetColor($elow105, $elow100y)
		$elow106f = PixelGetColor($elow106, $elow100y)
		$elow107f = PixelGetColor($elow107, $elow100y)
		$elow108f = PixelGetColor($elow108, $elow100y)
		$elow109f = PixelGetColor($elow109, $elow100y)
	EndIf
	If $elow100f = 16776960 And $elow101f = 16776960 And $elow102f = 16776960 And $elow103f = 16776960 And $elow104f = 16776960 And $elow105f = 16776960 And $elow106f = 16776960 And $elow107f = 16776960 And $elow108f = 16776960 And $elow109f = 16776960 Then
		randomizemore()
		$cownamex = $coord2[0] + $clickmx
		$cownamey = $coord2[1] + $clickmy
		;Send("{LCTRL down}")
		MouseClick("left", $cownamex, $cownamey, 1, 0)
		;Send("{LCTRL up}")
		Sleep(100)
		Global $foundagob = 1
	EndIf
EndFunc   ;==>checkforgoblinname
Func randomizesleep()
	Global $sleeper = Int(Random(0 - 97, 0 + 92))
EndFunc   ;==>randomizesleep
Func randomize()
	Global $clickx = Int(Random(0 - 4, 0 + 4))
	Global $clicky = Int(Random(0 - 4, 0 + 4))
EndFunc   ;==>randomize
Func randomizemore()
	Global $clickmx = Int(Random(0 - 25, 0 + 25))
	Global $clickmy = Int(Random(0 - 2, 0 + 2))
EndFunc   ;==>randomizemore
Func Randomizegoblin()
	Global $clickcx = Int(Random(0 - 6, 0 + 12))
	Global $clickcy = Int(Random(0 - 2, 0 + 8))
EndFunc   ;==>Randomizegoblin
Func Strengthandmageset()
	$clickx = Int(Random(0 - 0, 0 + 15))
	$clicky = Int(Random(0 - 0, 0 + 17))
	$strbarx = 570 + $clickx
	$strbary = 378 + $clicky
	MouseClick("left", $strbarx, $strbary, 1, 6)
	Sleep(150)
	$clickx = Int(Random(0 - 0, 0 + 45))
	$clicky = Int(Random(0 - 0, 0 + 17))
	$strsetx = 584 + $clickx
	$strsety = 520 + $clicky
	MouseClick("left", $strsetx, $strsety, 1, 6)
	Sleep(550)
	$clickx = Int(Random(0 - 0, 0 + 19))
	$clicky = Int(Random(0 - 0, 0 + 14))
	$inbarx = 691 + $clickx
	$inbary = 371 + $clicky
	MouseClick("left", $inbarx, $inbary, 1, 6)
EndFunc   ;==>Strengthandmageset
Func escape()
	Exit
EndFunc   ;==>escape
Func logout()
	Do
		$clickx = Int(Random(0 - 0, 0 + 18))
		$clicky = Int(Random(0 - 0, 0 + 22))
		$logout1x = 651 + $clickx
		$logout1y = 672 + $clicky
		MouseClick("left", $logout1x, $logout1y, 1, 6)
		$clickx = Int(Random(0 - 0, 0 + 18))
		$clicky = Int(Random(0 - 0, 0 + 22))
		$logout1x = 651 + $clickx
		$logout1y = 672 + $clicky
		MouseClick("left", $logout1x, $logout1y, 1, 6)
		$clickx = Int(Random(0 - 0, 0 + 127))
		$clicky = Int(Random(0 - 0, 0 + 21))
		$logout2x = 600 + $clickx
		$logout2y = 562 + $clicky
		MouseClick("left", $logout2x, $logout2y, 1, 6)
		$clickx = Int(Random(0 - 0, 0 + 127))
		$clicky = Int(Random(0 - 0, 0 + 21))
		$logout2x = 600 + $clickx
		$logout2y = 562 + $clicky
		MouseClick("left", $logout2x, $logout2y, 1, 6)
		Sleep(3000)
		$frt11 = PixelGetColor(577, 430)
		$frt22 = PixelGetColor(219, 446)
		$frt33 = PixelGetColor(249, 475)
	Until $frt11 = 723723 And $frt22 = 723723 And $frt33 = 723723 Or TimerStop ($begin000) >= 1000 * 20
	Sleep(1000)
EndFunc   ;==>logout
Func chars()
	;********************************************
	randomize()
	$login1x = 470 + $clickx
	$login1y = 490 + $clicky
	MouseClick("left", $login1x, $login1y, 3, 4)
	randomize()
	$login2x = 381 + $clickx
	$login2y = 455 + $clicky
	MouseClick("left", $login2x, $login2y, 3, 4)
	Send("tyu890")
	Sleep(100)
	randomize()
	$login3x = 384 + $clickx
	$login3y = 472 + $clicky
	MouseClick("left", $login3x, $login3y, 2, 4)
	Send("q12we3")
	randomize()
	$login4x = 317 + $clickx
	$login4y = 519 + $clicky
	MouseClick("left", $login4x, $login4y, 2, 4)
	;*********************************************
EndFunc   ;==>chars
Func runworld()
	Do
		If $x = 0 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 1
			ExitLoop
		EndIf
		If $x = 1 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 2
			ExitLoop
		EndIf
		If $x = 2 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 3
			ExitLoop
		EndIf
		If $x = 3 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 4
			ExitLoop
		EndIf
		If $x = 4 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 5
			ExitLoop
		EndIf
		If $x = 5 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 6
			ExitLoop
		EndIf
		If $x = 6 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 7
			ExitLoop
		EndIf
		If $x = 7 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 8
			ExitLoop
		EndIf
		If $x = 8 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 9
			ExitLoop
		EndIf
		If $x = 9 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 10
			ExitLoop
		EndIf
		If $x = 10 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 11
			ExitLoop
		EndIf
		If $x = 11 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 12
			ExitLoop
		EndIf
		If $x = 12 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 13
			ExitLoop
		EndIf
		If $x = 13 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",) ;offline;
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 14
			ExitLoop
		EndIf
		If $x = 14 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 15
			ExitLoop
		EndIf
		If $x = 15 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 16
			ExitLoop
		EndIf
		If $x = 16 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 17
			ExitLoop
		EndIf
		If $x = 17 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 18
			ExitLoop
		EndIf
		If $x = 18 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 19
			ExitLoop
		EndIf
		If $x = 19 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 20
			ExitLoop
		EndIf
		If $x = 20 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 21
			ExitLoop
		EndIf
		If $x = 21 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x - 21; equals 0 again
			ExitLoop
		EndIf
	Until $x = 9000 ;$x =  1 or $x =  2 or $x =  3
EndFunc   ;==>runworld
Func runworld2()
	Do
		If $x = 0 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 1
			ExitLoop
		EndIf
		If $x = 1 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 2
			ExitLoop
		EndIf
		If $x = 2 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 3
			ExitLoop
		EndIf
		If $x = 3 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 4
			ExitLoop
		EndIf
		If $x = 4 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 5
			ExitLoop
		EndIf
		If $x = 5 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 6
			ExitLoop
		EndIf
		If $x = 6 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 7
			ExitLoop
		EndIf
		If $x = 7 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 8
			ExitLoop
		EndIf
		If $x = 8 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 9
			ExitLoop
		EndIf
		If $x = 9 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 10
			ExitLoop
		EndIf
		If $x = 10 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 11
			ExitLoop
		EndIf
		If $x = 11 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 12
			ExitLoop
		EndIf
		If $x = 12 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 13
			ExitLoop
		EndIf
		If $x = 13 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",) ;offline;
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 14
			ExitLoop
		EndIf
		If $x = 14 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 15
			ExitLoop
		EndIf
		If $x = 15 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 16
			ExitLoop
		EndIf
		If $x = 16 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 17
			ExitLoop
		EndIf
		If $x = 17 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 18
			ExitLoop
		EndIf
		If $x = 18 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 19
			ExitLoop
		EndIf
		If $x = 19 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 20
			ExitLoop
		EndIf
		If $x = 20 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 21
			ExitLoop
		EndIf
		If $x = 21 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 22
			ExitLoop
		EndIf
		If $x = 22 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 23
			ExitLoop
		EndIf
		If $x = 23 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 24
			ExitLoop
		EndIf
		If $x = 24 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 25
			ExitLoop
		EndIf
		If $x = 25 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 26
			ExitLoop
		EndIf
		If $x = 26 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 27
			ExitLoop
		EndIf
		If $x = 27 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 28
			ExitLoop
		EndIf
		If $x = 28 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 29
			ExitLoop
		EndIf
		If $x = 29 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 30
			ExitLoop
		EndIf
		If $x = 30 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 31
			ExitLoop
		EndIf
		If $x = 31 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 32
			ExitLoop
		EndIf
		If $x = 32 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 33
			ExitLoop
		EndIf
		If $x = 33 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 34
			ExitLoop
		EndIf
		If $x = 34 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 35
			ExitLoop
		EndIf
		If $x = 35 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 36
			ExitLoop
		EndIf
		If $x = 36 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                            ', "",);removed world 56
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 37
			ExitLoop
		EndIf
		If $x = 37 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                         ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 38
			ExitLoop
		EndIf
		If $x = 38 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 39
			ExitLoop
		EndIf
		If $x = 39 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 40
			ExitLoop
		EndIf
		If $x = 40 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 41
			ExitLoop
		EndIf
		If $x = 41 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 42
			ExitLoop
		EndIf
		If $x = 42 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                        ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 43
			ExitLoop
		EndIf
		If $x = 43 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 44
			ExitLoop
		EndIf
		If $x = 44 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 45
			ExitLoop
		EndIf
		If $x = 45 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 46
			ExitLoop
		EndIf
		If $x = 46 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                           ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 47
			ExitLoop
		EndIf
		If $x = 47 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 48
			ExitLoop
		EndIf
		If $x = 48 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x + 1; equals 49
			ExitLoop
		EndIf
		If $x = 49 Then
			Run('C:\Program Files\Internet Explorer\iexplore                                                                          ', "",)
			WinWait("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinActivate("RuneScape Game - Microsoft Internet Explorer", "",)
			WinWaitActive("RuneScape Game - Microsoft Internet Explorer", "", 30)
			WinMove("RuneScape Game - Microsoft Internet Explorer", "", "0", "0", "800", "766")
			$x = $x - 49; equals 0 again
			ExitLoop
		EndIf
	Until $x = 9000 ;$x =  1 or $x =  2 or $x =  3
EndFunc   ;==>runworld2

Func Pause()
	MsgBox(0, "(good)Copy of tyu range(2).au3 is paused", "Click OK to Continue Automatic",)
EndFunc   ;==>Pause