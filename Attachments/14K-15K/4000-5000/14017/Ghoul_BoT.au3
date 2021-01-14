; ;
; ; Ghoul BoT
; ; Maps: Twisted Medows, Turtle Rock, Two Rivers, 
; ;       Lost Temple Origianl and Snow, Bandit Ridge, 
; ;       Echo Isles, Terenas Stand, Phantom Grove
; ; Author:	Buddy Favors
; ;

#include <GuiConstants.au3>

; GUI
$dir = @ScriptDir
$old = IniRead($dir & "\Config.ini", "Version", 0, "NotFound")
GuiCreate("Ghoul BoT v" & $old, 500, 200)

; TABS
$tab=GUICtrlCreateTab (10,10, 480, 160)
$tab_solobot=GUICtrlCreateTabitem ("Solo BoT")
	$solotraytip = GUICtrlCreateInput ( "Click Start BoT after you have setup Warcraft III in the correct settings", 11,  147, 476, 20)
	$solostart = GuiCtrlCreateButton("Start BoT", 190, 57, 100, 30)
	$soloprogressbar = GUICtrlCreateProgress (20,110,455,30)
	GUICtrlCreateLabel ("0 Mins",  20, 90, 50)
	GUICtrlCreateLabel ("16 Mins",  435, 90, 50)
	GUICtrlCreatePic(@ScriptDir & "\logo.jpg",20,45, 44,42)
	
$tab=GUICtrlCreateTab (10,10, 480, 160)
$tab_4v4rtbot=GUICtrlCreateTabitem ("RT BoT")
	$rttraytip = GUICtrlCreateInput ( "Click Start BoT after you have setup Warcraft III in the correct settings", 11,  147, 476, 20)
	$rtstart = GuiCtrlCreateButton("Start BoT", 190, 57, 100, 30)
	$rtprogressbar = GUICtrlCreateProgress (20,110,455,30)
	GUICtrlCreateLabel ("0 Mins",  20, 90, 50)
	GUICtrlCreateLabel ("20 Mins",  435, 90, 50)
	GUICtrlCreatePic(@ScriptDir & "\logo.jpg",20,45, 44,42)
	
$tab_ghoulbotsetup=GUICtrlCreateTabitem ("Auto Config BoT")
	$ghoulbotsetupstart = GuiCtrlCreateButton("Start Setup", 20, 78, 100, 30)
	$setuptip = GUICtrlCreateInput ( "Click Start Setup after you have setup Warcraft III in the correct settings", 11,  147, 476, 20)
	$choosemap = GUICtrlCreateCombo ("Select Map", 150, 60, 100)
	GUICtrlSetData(-1,"Echo Isle|Terenas Stand|Tirisfal Glades|Lost Temple|Phantom Grove|Turtle Rock|Twisted Meadows")
	$colorstep = GUICtrlCreateCombo ("Select Step", 150, 104, 100)
	GUICtrlSetData(-1,"Step 1|Step 2|Step 3|Step 4")
	
$tab_pixelcolorbot=GUICtrlCreateTabitem ("Pixel Color BoT")
	$colorcoord = GuiCtrlCreateButton("Find Color", 135, 50, 100, 30)
	$xcolor = GUICtrlCreateInput ("0", 70,  43, 40, 20)
	$ycolor = GUICtrlCreateInput ("0", 70,  65, 40, 20)
	GUICtrlCreateLabel ("X Coord:",  20, 45, 50)
	GUICtrlCreateLabel ("Y Coord:",  20, 69, 50)
	GUICtrlCreateLabel ("After you click Find Color paste the value into the Config.ini",  20, 92)
	
$tab_mousemovebot=GUICtrlCreateTabitem ("Mouse Move BoT")
	$movecoord = GuiCtrlCreateButton("Move to Coord", 135, 50, 120, 30)
	$xmove = GUICtrlCreateInput ("0", 70,  43, 40, 20)
	$ymove = GUICtrlCreateInput ("0", 70,  65, 40, 20)
	GUICtrlCreateLabel ("X Coord:",  20, 45, 50)
	GUICtrlCreateLabel ("Y Coord:",  20, 69, 50)
	
; MENUS
$filemenu = GUICtrlCreateMenu ("&File")
$exititem = GUICtrlCreateMenuitem ("&Exit",$filemenu)
$helpmenu = GUICtrlCreateMenu ("&Help")
$help = GUICtrlCreateMenuitem ("&Help",$helpmenu)

;Version check
InetGet("                                                              ", "version.txt", 0)
$new = FileReadLine($dir & "\version.txt")
If $new <> $old then Msgbox(0,"Info","There is a new version to download!")

; GUI MESSAGE LOOP
GuiSetState()
While 1
$msg = GUIGetMsg()
If $msg = $GUI_EVENT_CLOSE Or $msg = $exititem Then ExitLoop

If $msg = $help Then Run($dir & "\Help.exe")

If $msg = $colorcoord Then
	WinActivate("Warcraft III")
	$x = GUICtrlRead ($xcolor)
	$y = GUICtrlRead ($ycolor)
	WinWaitActive("Warcraft III")
	$color = pixelgetcolor($x,$y)
	$new_color = Hex($color, 6)
	ClipPut ( $new_color )
	WinActivate("Ghoul BoT v" & $old)
EndIf

If $msg = $movecoord Then
	$x = GUICtrlRead ($xmove)
	$y = GUICtrlRead ($ymove)
	mousemove($x,$y,0)
EndIf

If $msg = $ghoulbotsetupstart Then

GUICtrlSetData($setuptip, "Waiting for Warcraft III to become acitve window")
WinWaitActive("Warcraft III")

GUICtrlSetData($setuptip, "Resizing window")
WinMove("Warcraft III", "", 0, 0, 1024, 731)
sleep(1500)

$step = GUICtrlRead ($colorstep)
$map = GUICtrlRead ($choosemap)

If $step = "Step 1" then	
	GUICtrlSetData($setuptip, "Selecting units")
	$checksum = PixelChecksum(824,590, 824,590)
	While $checksum = PixelChecksum(824,590, 824,590)
		mousemove(1015,59,0)
		MouseDown( "left" )
		sleep(100)
		mousemove(0,767,0)
		MouseUp( "left" )
	WEnd
		
	GUICtrlSetData($setuptip, "Clicking acolyte")
	mouseclick("left", 455, 629, 2, 0)
	sleep(500)
	
	GUICtrlSetData($setuptip, "Getting acolyte color")
	$acolyte = pixelgetcolor(882, 684)
	$new_color = Hex($acolyte, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "12", $new_color)
	
	GUICtrlSetData($setuptip, "Send build hotkey")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		send("{bs}b")
	WEnd
	
	GUICtrlSetData($setuptip, "Getting build color")
	$color = pixelgetcolor(809, 699)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "14", $new_color)
	
	GUICtrlSetData($setuptip, "Building a crypt")
	send("c")
	
	GUICtrlSetData($setuptip, "Trial and error of building")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		$x = Int(Random(20,1015))
		$y = Int(Random(55,573))
		sleep(100)
		mouseclick("left", $x, $y, 1, 0)
	WEnd
	$crypt = MouseGetPos()
	
	GUICtrlSetData($setuptip, "Selecting necropolis")
	$checksum = PixelChecksum(516, 300, 516, 300)
	While $checksum = PixelChecksum(516, 300, 516, 300)
		mouseclick("left", 516, 300, 1, 0)
	WEnd
	sleep(1000)
	
	GUICtrlSetData($setuptip, "Getting necropolis color")
	$color = pixelgetcolor(825 , 685)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "13", $new_color)
	
	GUICtrlSetData($setuptip, "Selecting crypt")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		mouseclick("left", $crypt[0], $crypt[1], 1, 0)
	WEnd
	
	$acolyte_test = pixelgetcolor(882, 684)
	If $acolyte = $acolyte_test then mouseclick("left", $crypt[0], $crypt[1], 1, 0)
	
	GUICtrlSetData($setuptip, "Saying cheat")
	sleep(1000)
	send("{enter}warpten{enter}")
	
	GUICtrlSetData($setuptip, "Waiting till crypt finishes")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
	sleep(1000)
	WEnd
	
	GUICtrlSetData($setuptip, "Getting crypt color")
	$color = pixelgetcolor(820 , 601)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "16", $new_color)
	
	GUICtrlSetData($setuptip, "Saying cheat")
	sleep(1000)
	send("{enter}warpten{enter}")
	
	GUICtrlSetData($setuptip, "Training 2 ghouls")
	$checksum = PixelChecksum(419,691, 419,691)
	While $checksum = PixelChecksum(419,691, 419,691)
	send("g")
	WEnd
	sleep(1000)
	
	GUICtrlSetData($setuptip, "Getting 2 ghouls color")
	$color = pixelgetcolor(426 , 696)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "17", $new_color)
	
	GUICtrlSetData($setuptip, "Not enough gold error")
	send("g")
	
	GUICtrlSetData($setuptip, "Getting not enough gold color")
	$color = pixelgetcolor(321, 505)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "23", $new_color)
	
	GUICtrlSetData($setuptip, "Canceling ghouls")
	$checksum = PixelChecksum(435,655, 435,655)
	While $checksum = PixelChecksum(435,655, 435,655)
	send("{esc}")
	WEnd
	
	GUICtrlSetData($setuptip, "Saying cheat")
	sleep(1000)
	send("{enter}greedisgood 180{enter}")
	
	GUICtrlSetData($setuptip, "Training 4 ghouls")
	$checksum = PixelChecksum(492, 700, 492, 700)
	While $checksum = PixelChecksum(492, 700, 492, 700)
	send("g")
	WEnd
	sleep(1000)
	
	GUICtrlSetData($setuptip, "Getting 3 ghouls color")
	$color = pixelgetcolor(463, 696)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "22", $new_color)
	
	GUICtrlSetData($setuptip, "Getting 4 ghouls color")
	$color = pixelgetcolor(502, 695)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "21", $new_color)
	
	GUICtrlSetData($setuptip, "Canceling ghouls")
	$checksum = PixelChecksum(435,655, 435,655)
	While $checksum = PixelChecksum(435,655, 435,655)
	send("{esc}")
	WEnd

	GUICtrlSetData($setuptip, "Saying cheat")
	sleep(1000)
	send("{enter}SomebodySetUpUsTheBomb{enter}")
	sleep(1000)
	
	GUICtrlSetData($setuptip, "Getting the defeated color")
	$color = pixelgetcolor(402, 288)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "10", $new_color)
	
	GUICtrlSetData($setuptip, "Going to the score screen")
	mouseclick("left",520,332,1,0)
	sleep(2000)
	
	GUICtrlSetData($setuptip, "Getting the score screen color")
	$color = pixelgetcolor(366, 559)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "27", $new_color)
	
	If $step = "Select Step" then $step = "the setup"
	GUICtrlSetData($setuptip, "Finished " & $step)
	
	WinActivate("Ghoul BoT v" & $old)
EndIf

If $step = "Step 2" then
	GUICtrlSetData($setuptip, "Getting the victory color")
	$color = pixelgetcolor(484, 264)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "9", $new_color)
	
	send("c")
	GUICtrlSetData($setuptip, "Selecting units")
	$checksum = PixelChecksum(824,590, 824,590)
	While $checksum = PixelChecksum(824,590, 824,590)
		mousemove(1015,59,0)
		MouseDown( "left" )
		sleep(100)
		mousemove(0,767,0)
		MouseUp( "left" )
	WEnd
	$hotkey_army = Chr(49)
	Send("+{" & $hotkey_army & "}")
	
	GUICtrlSetData($setuptip, "Clicking acolyte")
	mouseclick("left", 455, 629, 2, 0)
	sleep(500)
	
	GUICtrlSetData($setuptip, "Send build hotkey")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		send("{bs}b")
	WEnd
	
	GUICtrlSetData($setuptip, "Building an altar")
	send("a")
	
	GUICtrlSetData($setuptip, "Trial and error of building")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		$x = Int(Random(20,1015))
		$y = Int(Random(55,573))
		sleep(100)
		mouseclick("left", $x, $y, 1, 0)
	WEnd
	$altar = MouseGetPos()

	GUICtrlSetData($setuptip, "Selecting altar")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		mouseclick("left", $altar[0], $altar[1], 1, 0)
	WEnd
		
	GUICtrlSetData($setuptip, "Saying cheat")
	sleep(1000)
	send("{enter}warpten{enter}")
	
	GUICtrlSetData($setuptip, "Waiting till altar finishes")
	$checksum = PixelChecksum(812,696, 812,696)
	While $checksum = PixelChecksum(812,696, 812,696)
		sleep(1000)
	WEnd

	GUICtrlSetData($setuptip, "Training DK")
	$checksum = PixelChecksum(808,697, 808,697)
	While $checksum = PixelChecksum(808,697, 808,697)
		send("d")
	WEnd
	
	GUICtrlSetData($setuptip, "Selecing DK")
	$checksum = PixelChecksum(819,587, 819,587)
	While $checksum = PixelChecksum(819,587, 819,587)
		mouseclick("left", 29, 87, 1, 0)
	WEnd
	send("{bs}")
	
	GUICtrlSetData($setuptip, "Getting DK color")
	$color = pixelgetcolor(680, 610)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "20", $new_color)
	$color = pixelgetcolor(994, 660)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "24", $new_color)
	
	GUICtrlSetData($setuptip, "Killing DK")
	Send("{" & $hotkey_army & "}a")
	mouseclick("left", 29, 87, 1, 0)
	
	GUICtrlSetData($setuptip, "Waiting for DK to die")
	$checksum = PixelChecksum(29, 87, 29, 87)
	While $checksum = PixelChecksum(29, 87, 29, 87)
		sleep(1000)
	WEnd
	
	GUICtrlSetData($setuptip, "Getting DK death color")
	$color = pixelgetcolor(34, 78)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "31", $new_color)
	
	If $step = "Select Step" then $step = "the setup"
	GUICtrlSetData($setuptip, "Finished " & $step)
	
	WinActivate("Ghoul BoT v" & $old)
EndIf

If $step = "Step 3" then
	If $map = "Select Map" then Msgbox(0,"Info","Please select a map")
	
	If $map = "Echo Isle" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(176, 687)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "11", $new_color)
	EndIf
	
	If $map = "Terenas Stand" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(85, 597)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "29", $new_color)
	EndIf
	
	If $map = "Tirisfal Glades" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(133, 649)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "30", $new_color)
	EndIf
	
	If $map = "Lost Temple" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(106, 625)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "4", $new_color)
	EndIf
	
	If $map = "Phantom Grove" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(177, 704)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "15", $new_color)
	EndIf
	
	If $map = "Turtle Rock" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(96, 652)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "6", $new_color)
	EndIf
	
	If $map = "Twisted Meadows" then
		GUICtrlSetData($setuptip, "Getting " & $map & " color")
		$color = pixelgetcolor(107, 629)
		$new_color = Hex($color, 6)
		IniWrite($dir & "\Config.ini", "Game Colors", "3", $new_color)
	EndIf

	If $step = "Select Step" then $step = "the setup"
	GUICtrlSetData($setuptip, "Finished " & $map)
	
	WinActivate("Ghoul BoT v" & $old)
EndIf

If $step = "Step 4" then
	GUICtrlSetData($setuptip, "Getting quick play color")
	$color = pixelgetcolor(990, 177)
	$new_color = Hex($color, 6)
	IniWrite($dir & "\Config.ini", "Game Colors", "1", $new_color)
	
	GUICtrlSetData($setuptip, "Joining config channel")
	$var ="/join Auto Config BoT"
	ClipPut ($var)
	send("^v{enter}")
	
	GUICtrlSetData($setuptip, "Getting name color")
	mouseclick("left", 796, 256, 1, 0)
	send("!n")
	mousemove(555,674,0)
	mousedown("left")
	mousemove(19,677,0)
	mouseup("left")
	send("^c")
	$name = ClipGet()
	IniWrite($dir & "\Config.ini", "Other", "0", $name)
	send("{bs}")
	
	If $step = "Select Step" then $step = "the setup"
	GUICtrlSetData($setuptip, "Finished " & $step)	
	
	WinActivate("Ghoul BoT v" & $old)
EndIf

EndIf

If $msg = $solostart Then

;Set-up
Global $Paused, $begin
GUICtrlSetData($solotraytip, "Waiting for Warcraft III to become acitve window")
WinWaitActive("Warcraft III")
HotKeySet("!{ESC}", "Terminate")
HotKeySet("!{F1}", "Quit")
HotKeySet("!{F2}", "Bugged")
HotKeySet("!s", "Countdown")
HotKeySet("{PAUSE}", "TogglePause")
Opt("TrayIconDebug", 1)
$hotkey_crypt = Chr(51)
$hotkey_altar = Chr(52)
$hotkey_army = Chr(49)

GUICtrlSetData($solotraytip, "Resizing window")
WinMove("Warcraft III", "", 0, 0, 1024, 731)

While 1
$game = 0

;Quick Play
$message = "Countdown until search: "
$i = 5
Do
	GUICtrlSetData($solotraytip, $message & $i)
    $i = $i - 1
    If $i < 0 Then Exitloop
    sleep(1000)
Until $i = 0
GUICtrlSetData($solotraytip, $message & $i)

While 1
	$color = IniRead($dir & "\Config.ini", "Game Colors", 1, "NotFound")
	$coord = PixelSearch( 990, 177, 990, 177, "0x" & $color)
	If Not @error Then ExitLoop
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 813, 594, 813, 594, "0x" & $color)
	If Not @error Then ExitLoop
	sleep(1000)
WEnd
sleep(2500)
While 1
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 820, 705, 820, 705, "0x" & $color)
	If Not @error Then ExitLoop
	$keyboard_key = "!q"
	Send("!q")
	If $keyboard_key = "!q" Then ExitLoop
	sleep(100)
WEnd

;Start game
GUICtrlSetData($solotraytip, "Waiting for game to begin")
While 1
	$begin = TimerInit()
	GUICtrlSetData ($soloprogressbar, "0")
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 820, 705, 820, 705, "0x" & $color)
	If Not @error Then ExitLoop
	sleep(1000)
WEnd

;Tirisfal Glades
$color = IniRead($dir & "\Config.ini", "Game Colors", 30, "NotFound")
$coord = PixelSearch( 133, 649, 133, 649, "0x" & $color)
If Not @error Then

;Start game
;top
$white_x = 42
$white_y = 583
$first_tree_x = 911
$first_tree_y = 300
$gold_x = 544
$gold_y = 182
$acoylte_x = 479
$acoylte_y = 260
$crypt_x = 853
$crypt_y = 402
$zigg_x = 586
$zigg_y = 158
$altar_x = 226
$altar_y = 281
$zigg2_x = 490
$zigg2_y = 155
$crypt_rally_x = 959
$crypt_rally_y = 129
$scout_x = 161
$scout_y = 683
$scout2_x = 161
$scout2_y = 683
$scout3_x = 161
$scout3_y = 683
$hero_rally_x = 793
$hero_rally_y = 251
$zigg3_x = 397
$zigg3_y = 167
$zigg4_x = 403
$zigg4_y = 102
$select_start_x = 548
$select_start_y = 184
$select_finish_x = 1023
$select_finish_y = 557
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom
$white_x = 164
$white_y = 691
$first_tree_x = 857
$first_tree_y = 84
$gold_x = 616
$gold_y = 418
$acoylte_x = 483
$acoylte_y = 401
$crypt_x = 751
$crypt_y = 126
$zigg_x = 655
$zigg_y = 488
$altar_x = 940
$altar_y = 445
$zigg2_x = 775
$zigg2_y = 476
$crypt_rally_x = 992
$crypt_rally_y = 223
$scout_x = 47
$scout_y = 588
$scout2_x = 47
$scout2_y = 588
$scout3_x = 47
$scout3_y = 588
$hero_rally_x = 777
$hero_rally_y = 301
$zigg3_x = 534
$zigg3_y = 526
$zigg4_x = 405
$zigg4_y = 519
$select_start_x = 582
$select_start_y = 443
$select_finish_x = 1023
$select_finish_y = 67
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Terenas Stand
$color = IniRead($dir & "\Config.ini", "Game Colors", 29, "NotFound")
$coord = PixelSearch( 85, 597, 85, 597, "0x" & $color)
If Not @error Then

;Start game
;top
$white_x = 38
$white_y = 604
$first_tree_x = 664
$first_tree_y = 62
$gold_x = 337
$gold_y = 326
$acoylte_x = 448
$acoylte_y = 310
$crypt_x = 714
$crypt_y = 144
$zigg_x = 283
$zigg_y = 323
$altar_x = 480
$altar_y = 554
$zigg2_x = 287
$zigg2_y = 258
$crypt_rally_x = 570
$crypt_rally_y = 68
$scout_x = 165
$scout_y = 671
$scout2_x = 165
$scout2_y = 671
$scout3_x = 165
$scout3_y = 671
$hero_rally_x = 491
$hero_rally_y = 146
$zigg3_x = 251
$zigg3_y = 414
$zigg4_x = 232
$zigg4_y = 517
$select_start_x = 257
$select_start_y = 269
$select_finish_x = 739
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom
$white_x = 168
$white_y = 675
$first_tree_x = 356
$first_tree_y = 550
$gold_x = 698
$gold_y = 311
$acoylte_x = 577
$acoylte_y = 288
$crypt_x = 283
$crypt_y = 563
$zigg_x = 775
$zigg_y = 456
$altar_x = 746
$altar_y = 123
$zigg2_x = 907
$zigg2_y = 478
$crypt_rally_x = 593
$crypt_rally_y = 555
$scout_x = 41
$scout_y = 606
$scout2_x = 41
$scout2_y = 606
$scout3_x = 41
$scout3_y = 606
$hero_rally_x = 577
$hero_rally_y = 520
$zigg3_x = 746
$zigg3_y = 273
$zigg4_x = 723
$zigg4_y = 201
$select_start_x = 95
$select_start_y = 245
$select_finish_x = 1023
$select_finish_y = 766
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Echo Isles
$color = IniRead($dir & "\Config.ini", "Game Colors", 11, "NotFound")
$coord = PixelSearch( 176, 687, 176, 687, "0x" & $color)
If Not @error Then

;Start game
;left
$white_x = 44
$white_y = 603
$first_tree_x = 184
$first_tree_y = 516
$gold_x = 424
$gold_y = 204
$acoylte_x = 483
$acoylte_y = 288
$crypt_x = 376
$crypt_y = 544
$zigg_x = 341
$zigg_y = 211
$altar_x = 728
$altar_y = 234
$zigg2_x = 238
$zigg2_y = 202
$crypt_rally_x = 77
$crypt_rally_y = 399
$scout_x = 155
$scout_y = 603
$scout2_x = 155
$scout2_y = 603
$scout3_x = 155
$scout3_y = 603
$hero_rally_x = 221
$hero_rally_y = 365
$zigg3_x = 459
$zigg3_y = 187
$zigg4_x = 523
$zigg4_y = 120
$select_start_x = 438
$select_start_y = 199
$select_finish_x = 0
$select_finish_y = 543
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;right
$white_x = 159
$white_y = 604
$first_tree_x = 785
$first_tree_y = 492
$gold_x = 610
$gold_y = 190
$acoylte_x = 552
$acoylte_y = 273
$crypt_x = 589
$crypt_y = 515
$zigg_x = 693
$zigg_y = 203
$altar_x = 305
$altar_y = 195
$zigg2_x = 790
$zigg2_y = 205
$crypt_rally_x = 949
$crypt_rally_y = 384
$scout_x = 47
$scout_y = 604
$scout2_x = 47
$scout2_y = 604
$scout3_x = 47
$scout3_y = 604
$hero_rally_x = 753
$hero_rally_y = 365
$zigg3_x = 561
$zigg3_y = 179
$zigg4_x = 553
$zigg4_y = 114
$select_start_x = 555
$select_start_y = 190
$select_finish_x = 1023
$select_finish_y = 548
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Twisted Medows
$color = IniRead($dir & "\Config.ini", "Game Colors", 3, "NotFound")
$coord = PixelSearch( 107, 629, 107, 629, "0x" & $color)
If Not @error Then

;Start game
;bottom left
$white_x = 54
$white_y = 676
$first_tree_x = 312
$first_tree_y = 60
$gold_x = 332
$gold_y = 352
$acoylte_x = 460
$acoylte_y = 339
$crypt_x = 354
$crypt_y = 69
$zigg_x = 302
$zigg_y = 353
$altar_x = 492
$altar_y = 573
$zigg2_x = 291
$zigg2_y = 459
$crypt_rally_x = 75
$crypt_rally_y = 62
$scout_x = 66
$scout_y = 593
$scout2_x = 152
$scout2_y = 605
$scout3_x = 142
$scout3_y = 681
$hero_rally_x = 204
$hero_rally_y = 149
$zigg3_x = 193
$zigg3_y = 293
$zigg4_x = 266
$zigg4_y = 563
$select_start_x = 432
$select_start_y = 312
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top left
$white_x = 65
$white_y = 592
$first_tree_x = 850
$first_tree_y = 122
$gold_x = 412
$gold_y = 210
$acoylte_x = 467
$acoylte_y = 291
$crypt_x = 780
$crypt_y = 217
$zigg_x = 340
$zigg_y = 227
$altar_x = 85
$altar_y = 327
$zigg2_x = 428
$zigg2_y = 197
$crypt_rally_x = 715
$crypt_rally_y = 61
$scout_x = 152
$scout_y = 605
$scout2_x = 142
$scout2_y = 681
$scout3_x = 56
$scout3_y = 673
$hero_rally_x = 644
$hero_rally_y = 129
$zigg3_x = 428
$zigg3_y = 142
$zigg4_x = 225
$zigg4_y = 233
$select_start_x = 436
$select_start_y = 246
$select_finish_x = 840
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top right
$white_x = 157
$white_y = 599
$first_tree_x = 201
$first_tree_y = 109
$gold_x = 667
$gold_y = 224
$acoylte_x = 599
$acoylte_y = 298
$crypt_x = 273
$crypt_y = 242
$zigg_x = 695
$zigg_y = 280
$altar_x = 835
$altar_y = 436
$zigg2_x = 805
$zigg2_y = 277
$crypt_rally_x = 330
$crypt_rally_y = 65
$scout_x = 142
$scout_y = 681
$scout2_x = 56
$scout2_y = 673
$scout3_x = 66
$scout3_y = 593
$hero_rally_x = 433
$hero_rally_y = 121
$zigg3_x = 656
$zigg3_y = 179
$zigg4_x = 919
$zigg4_y = 268
$select_start_x = 671
$select_start_y = 209
$select_finish_x = 204
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom right
$white_x = 149
$white_y = 689
$first_tree_x = 917
$first_tree_y = 143
$gold_x = 505
$gold_y = 445
$acoylte_x = 369
$acoylte_y = 426
$crypt_x = 675
$crypt_y = 165
$zigg_x = 494
$zigg_y = 515
$altar_x = 196
$altar_y = 547
$zigg2_x = 621
$zigg2_y = 517
$crypt_rally_x = 927
$crypt_rally_y = 241
$scout_x = 56
$scout_y = 673
$scout2_x = 66
$scout2_y = 593
$scout3_x = 152
$scout3_y = 605
$hero_rally_x = 781
$hero_rally_y = 332
$zigg3_x = 748
$zigg3_y = 570
$zigg4_x = 363
$zigg4_y = 517
$select_start_x = 537
$select_start_y = 505
$select_finish_x = 1023
$select_finish_y = 104
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Phantom Grove
$color = IniRead($dir & "\Config.ini", "Game Colors", 15, "NotFound")
$coord = PixelSearch( 177, 704, 177, 704, "0x" & $color)
If Not @error Then

;Start game
;left
$white_x = 34
$white_y = 612
$first_tree_x = 887
$first_tree_y = 167
$gold_x = 416
$gold_y = 206
$acoylte_x = 483
$acoylte_y = 278
$crypt_x = 792
$crypt_y = 348
$zigg_x = 333
$zigg_y = 213
$altar_x = 171
$altar_y = 310
$zigg2_x = 235
$zigg2_y = 202
$crypt_rally_x = 844
$crypt_rally_y = 138
$scout_x = 130
$scout_y = 576
$scout2_x = 172
$scout2_y = 665
$scout3_x = 79
$scout3_y = 702
$hero_rally_x = 721
$hero_rally_y = 213
$zigg3_x = 474
$zigg3_y = 185
$zigg4_x = 138
$zigg4_y = 208
$select_start_x = 516
$select_start_y = 353
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top
$white_x = 135
$white_y = 574
$first_tree_x = 716
$first_tree_y = 559
$gold_x = 658
$gold_y = 218
$acoylte_x = 584
$acoylte_y = 294
$crypt_x = 550
$crypt_y = 544
$zigg_x = 697
$zigg_y = 253
$altar_x = 438
$altar_y = 126
$zigg2_x = 811
$zigg2_y = 255
$crypt_rally_x = 880
$crypt_rally_y = 469
$scout_x = 35
$scout_y = 615
$scout2_x = 79
$scout2_y = 702
$scout3_x = 172
$scout3_y = 665
$hero_rally_x = 775
$hero_rally_y = 429
$zigg3_x = 629
$zigg3_y = 184
$zigg4_x = 634
$zigg4_y = 115
$select_start_x = 542
$select_start_y = 231
$select_finish_x = 1023
$select_finish_y = 628
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;right
$white_x = 173
$white_y = 672
$first_tree_x = 40
$first_tree_y = 389
$gold_x = 616
$gold_y = 445
$acoylte_x = 492
$acoylte_y = 420
$crypt_x = 196
$crypt_y = 319
$zigg_x = 603
$zigg_y = 486
$altar_x = 856
$altar_y = 318
$zigg2_x = 733
$zigg2_y = 489
$crypt_rally_x = 71
$crypt_rally_y = 527
$scout_x = 79
$scout_y = 702
$scout2_x = 35
$scout2_y = 615
$scout3_x = 130
$scout3_y = 576
$hero_rally_x = 225
$hero_rally_y = 511
$zigg3_x = 871
$zigg3_y = 488
$zigg4_x = 985
$zigg4_y = 510
$select_start_x = 591
$select_start_y = 269
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom
$white_x = 76
$white_y = 705
$first_tree_x = 254
$first_tree_y = 67
$gold_x = 389
$gold_y = 418
$acoylte_x = 506
$acoylte_y = 402
$crypt_x = 397
$crypt_y = 96
$zigg_x = 412
$zigg_y = 472
$altar_x = 716
$altar_y = 508
$zigg2_x = 305
$zigg2_y = 423
$crypt_rally_x = 153
$crypt_rally_y = 100
$scout_x = 35
$scout_y = 615
$scout2_x = 130
$scout2_y = 576
$scout3_x = 172
$scout3_y = 665
$hero_rally_x = 219
$hero_rally_y = 216
$zigg3_x = 174
$zigg3_y = 415
$zigg4_x = 541
$zigg4_y = 548
$select_start_x = 436
$select_start_y = 399
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Lost Temple (Original)
$color = IniRead($dir & "\Config.ini", "Game Colors", 4, "NotFound")
$coord = PixelSearch( 106, 625, 106, 625, "0x" & $color)
If Not @error Then

;Start game
;bottom
$white_x = 121
$white_y = 705
$first_tree_x = 38
$first_tree_y = 408
$gold_x = 660
$gold_y = 400
$acoylte_x = 540
$acoylte_y = 386
$crypt_x = 191
$crypt_y = 346
$zigg_x = 663
$zigg_y = 489
$altar_x = 827
$altar_y = 200
$zigg2_x = 524
$zigg2_y = 560
$crypt_rally_x = 68
$crypt_rally_y = 532
$scout3_x = 176
$scout3_y = 621
$scout_x = 35
$scout_y = 662
$scout2_x = 96
$scout2_y = 578
$hero_rally_x = 262
$hero_rally_y = 416
$zigg3_x = 722
$zigg3_y = 393
$zigg4_x = 841
$zigg4_y = 388
$select_start_x = 497
$select_start_y = 270
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;left
$white_x = 29
$white_y = 664
$first_tree_x = 300
$first_tree_y = 76
$gold_x = 381
$gold_y = 443
$acoylte_x = 504
$acoylte_y = 393
$crypt_x = 401
$crypt_y = 142
$zigg_x = 400
$zigg_y = 487
$altar_x = 715
$altar_y = 556
$zigg2_x = 295
$zigg2_y = 422
$crypt_rally_x = 135
$crypt_rally_y = 118
$scout2_x = 176
$scout2_y = 621
$scout3_x = 96
$scout3_y = 578
$scout_x = 116
$scout_y = 699
$hero_rally_x = 265
$hero_rally_y = 251
$zigg3_x = 183
$zigg3_y = 414
$zigg4_x = 521
$zigg4_y = 551
$select_start_x = 399
$select_start_y = 405
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top
$white_x = 97
$white_y = 573
$first_tree_x = 801
$first_tree_y = 198
$gold_x = 417
$gold_y = 204
$acoylte_x = 481
$acoylte_y = 279
$crypt_x = 801
$crypt_y = 224
$zigg_x = 338
$zigg_y = 217
$altar_x = 190
$altar_y = 380
$zigg4_x = 132
$zigg4_y = 205
$crypt_rally_x = 764
$crypt_rally_y = 64
$scout_x = 176
$scout_y = 621
$scout2_x = 116
$scout2_y = 699
$scout3_x = 35
$scout3_y = 662
$hero_rally_x = 662
$hero_rally_y = 146
$zigg3_x = 460
$zigg3_y = 184
$zigg2_x = 235
$zigg2_y = 213
$select_start_x = 466
$select_start_y = 260
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;right
$white_x = 179
$white_y = 619
$first_tree_x = 895
$first_tree_y = 459
$gold_x = 615
$gold_y = 203
$acoylte_x = 544
$acoylte_y = 277
$crypt_x = 608
$crypt_y = 512
$zigg_x = 568
$zigg_y = 132
$altar_x = 376
$altar_y = 114
$zigg2_x = 692
$zigg2_y = 215
$crypt_rally_x = 998
$crypt_rally_y = 389
$scout2_x = 35
$scout2_y = 662
$scout_x = 96
$scout_y = 578
$scout3_x = 116
$scout3_y = 699
$hero_rally_x = 794
$hero_rally_y = 341
$zigg3_x = 794
$zigg3_y = 215
$zigg4_x = 550
$zigg4_y = 81
$select_start_x = 564
$select_start_y = 204
$select_finish_x = 1023
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Lost Temple (Snow)
$color = IniRead($dir & "\Config.ini", "Game Colors", 8, "NotFound")
$coord = PixelSearch( 82, 699, 82, 699, "0x" & $color)
If Not @error Then

;Start game
;bottom
$white_x = 121
$white_y = 705
$first_tree_x = 38
$first_tree_y = 408
$gold_x = 660
$gold_y = 400
$acoylte_x = 540
$acoylte_y = 386
$crypt_x = 191
$crypt_y = 346
$zigg_x = 663
$zigg_y = 489
$altar_x = 827
$altar_y = 200
$zigg2_x = 524
$zigg2_y = 560
$crypt_rally_x = 68
$crypt_rally_y = 532
$scout3_x = 176
$scout3_y = 621
$scout_x = 35
$scout_y = 662
$scout2_x = 96
$scout2_y = 578
$hero_rally_x = 262
$hero_rally_y = 416
$zigg3_x = 722
$zigg3_y = 393
$zigg4_x = 841
$zigg4_y = 388
$select_start_x = 497
$select_start_y = 270
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;left
$white_x = 31
$white_y = 663
$first_tree_x = 300
$first_tree_y = 76
$gold_x = 381
$gold_y = 443
$acoylte_x = 504
$acoylte_y = 393
$crypt_x = 401
$crypt_y = 142
$zigg_x = 400
$zigg_y = 487
$altar_x = 715
$altar_y = 556
$zigg2_x = 295
$zigg2_y = 422
$crypt_rally_x = 135
$crypt_rally_y = 118
$scout2_x = 176
$scout2_y = 621
$scout3_x = 96
$scout3_y = 578
$scout_x = 116
$scout_y = 699
$hero_rally_x = 265
$hero_rally_y = 251
$zigg3_x = 183
$zigg3_y = 414
$zigg4_x = 521
$zigg4_y = 551
$select_start_x = 399
$select_start_y = 405
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top
$white_x = 97
$white_y = 573
$first_tree_x = 801
$first_tree_y = 198
$gold_x = 417
$gold_y = 204
$acoylte_x = 481
$acoylte_y = 279
$crypt_x = 801
$crypt_y = 224
$zigg_x = 338
$zigg_y = 217
$altar_x = 190
$altar_y = 380
$zigg4_x = 132
$zigg4_y = 205
$crypt_rally_x = 764
$crypt_rally_y = 64
$scout_x = 176
$scout_y = 621
$scout2_x = 116
$scout2_y = 699
$scout3_x = 35
$scout3_y = 662
$hero_rally_x = 662
$hero_rally_y = 146
$zigg3_x = 460
$zigg3_y = 184
$zigg2_x = 235
$zigg2_y = 213
$select_start_x = 466
$select_start_y = 260
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;right
$white_x = 179
$white_y = 619
$first_tree_x = 895
$first_tree_y = 459
$gold_x = 615
$gold_y = 203
$acoylte_x = 544
$acoylte_y = 277
$crypt_x = 608
$crypt_y = 512
$zigg_x = 568
$zigg_y = 132
$altar_x = 376
$altar_y = 114
$zigg2_x = 692
$zigg2_y = 215
$crypt_rally_x = 998
$crypt_rally_y = 389
$scout2_x = 35
$scout2_y = 662
$scout_x = 96
$scout_y = 578
$scout3_x = 116
$scout3_y = 699
$hero_rally_x = 794
$hero_rally_y = 341
$zigg3_x = 794
$zigg3_y = 215
$zigg4_x = 550
$zigg4_y = 81
$select_start_x = 564
$select_start_y = 204
$select_finish_x = 1023
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Two Rivers
$color = IniRead($dir & "\Config.ini", "Game Colors", 5, "NotFound")
$coord = PixelSearch( 151, 691, 151, 691, "0x" & $color)
If Not @error Then

;Start game
;top
$white_x = 
$white_y = 
$first_tree_x = 
$first_tree_y = 
$gold_x = 
$gold_y = 
$acoylte_x = 
$acoylte_y = 
$crypt_x = 
$crypt_y = 
$zigg_x = 
$zigg_y = 
$altar_x = 
$altar_y = 
$zigg2_x = 
$zigg2_y = 
$crypt_rally_x = 
$crypt_rally_y = 
$scout_x = 
$scout_y = 
$scout2_x = 
$scout2_y = 
$scout3_x = 
$scout3_y = 
$hero_rally_x = 
$hero_rally_y = 
$zigg3_x = 
$zigg3_y = 
$zigg4_x = 
$zigg4_y = 
$select_start_x = 
$select_start_y = 
$select_finish_x = 
$select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom
$white_x = 
$white_y = 
$first_tree_x = 
$first_tree_y = 
$gold_x = 
$gold_y = 
$acoylte_x = 
$acoylte_y = 
$crypt_x = 
$crypt_y = 
$zigg_x = 
$zigg_y = 
$altar_x = 
$altar_y = 
$zigg2_x = 
$zigg2_y = 
$crypt_rally_x = 
$crypt_rally_y = 
$scout_x = 
$scout_y = 
$scout2_x = 
$scout2_y = 
$scout3_x = 
$scout3_y = 
$hero_rally_x = 
$hero_rally_y = 
$zigg3_x = 
$zigg3_y = 
$zigg4_x = 
$zigg4_y = 
$select_start_x = 
$select_start_y = 
$select_finish_x = 
$select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Turtle Rock
$color = IniRead($dir & "\Config.ini", "Game Colors", 6, "NotFound")
$coord = PixelSearch( 96, 652, 96, 652, "0x" & $color)
If Not @error Then

;Start game
;top left
$white_x = 36
$white_y = 618
$first_tree_x = 833
$first_tree_y = 206
$gold_x = 405
$gold_y = 212
$acoylte_x = 462
$acoylte_y = 275
$crypt_x = 763
$crypt_y = 292
$zigg_x = 343
$zigg_y = 228
$altar_x = 264
$altar_y = 355
$zigg2_x = 426
$zigg2_y = 186
$crypt_rally_x = 747
$crypt_rally_y = 86
$scout_x = 82
$scout_y = 586
$scout2_x = 170
$scout2_y = 658
$scout3_x = 134
$scout3_y = 696
$hero_rally_x = 667
$hero_rally_y = 180
$zigg3_x = 436
$zigg3_y = 120
$zigg4_x = 209
$zigg4_y = 227
$select_start_x = 444
$select_start_y = 300
$select_finish_x = 859
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom left
$white_x = 140
$white_y = 700
$first_tree_x = 798
$first_tree_y = 65
$gold_x = 646
$gold_y = 430
$acoylte_x = 511
$acoylte_y = 393
$crypt_x = 588
$crypt_y = 127
$zigg_x = 573
$zigg_y = 480
$altar_x = 214
$altar_y = 408
$zigg2_x = 721
$zigg2_y = 447
$crypt_rally_x = 869
$crypt_rally_y = 103
$scout_x = 40
$scout_y = 622
$scout2_x = 82
$scout2_y = 586
$scout3_x = 170
$scout3_y = 658
$hero_rally_x = 782
$hero_rally_y = 230
$zigg3_x = 854
$zigg3_y = 443
$zigg4_x = 446
$zigg4_y = 556
$select_start_x = 545
$select_start_y = 456
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom right
$white_x = 176
$white_y = 662
$first_tree_x = 61
$first_tree_y = 384
$gold_x = 665
$gold_y = 414
$acoylte_x = 529
$acoylte_y = 382
$crypt_x = 182
$crypt_y = 341
$zigg_x = 728
$zigg_y = 421
$altar_x = 740
$altar_y = 208
$zigg2_x = 845
$zigg2_y = 418
$crypt_rally_x = 118
$crypt_rally_y = 525
$scout_x = 134
$scout_y = 696
$scout2_x = 40
$scout2_y = 622
$scout3_x = 82
$scout3_y = 586
$hero_rally_x = 395
$hero_rally_y = 532
$zigg3_x = 623
$zigg3_y = 548
$zigg4_x = 831
$zigg4_y = 326
$select_start_x = 575
$select_start_y = 281
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;top right
$white_x = 76
$white_y = 583
$first_tree_x = 89
$first_tree_y = 493
$gold_x = 416
$gold_y = 198
$acoylte_x = 480
$acoylte_y = 263
$crypt_x = 431
$crypt_y = 547
$zigg_x = 325
$zigg_y = 210
$altar_x = 724
$altar_y = 222
$zigg2_x = 223
$zigg2_y = 207
$crypt_rally_x = 39
$crypt_rally_y = 426
$scout_x = 170
$scout_y = 658
$scout2_x = 134
$scout2_y = 696
$scout3_x = 40
$scout3_y = 622
$hero_rally_x = 208
$hero_rally_y = 408
$zigg3_x = 121
$zigg3_y = 198
$zigg4_x = 455
$zigg4_y = 176
$select_start_x = 455
$select_start_y = 259
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

;Bandit Ridge
$color = IniRead($dir & "\Config.ini", "Game Colors", 7, "NotFound")
$coord = PixelSearch( 27, 700, 27, 700, "0x" & $color)	
If Not @error Then

;Start game
;top
$white_x = 
$white_y = 
$first_tree_x = 
$first_tree_y = 
$gold_x = 
$gold_y = 
$acoylte_x = 
$acoylte_y = 
$crypt_x = 
$crypt_y = 
$zigg_x = 
$zigg_y = 
$altar_x = 
$altar_y = 
$zigg2_x = 
$zigg2_y = 
$crypt_rally_x = 
$crypt_rally_y = 
$scout_x = 
$scout_y = 
$scout2_x = 
$scout2_y = 
$scout3_x = 
$scout3_y = 
$hero_rally_x = 
$hero_rally_y = 
$zigg3_x = 
$zigg3_y = 
$zigg4_x = 
$zigg4_y = 
$select_start_x = 
$select_start_y = 
$select_finish_x = 
$select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

;Start game
;bottom
$white_x = 
$white_y = 
$first_tree_x = 
$first_tree_y = 
$gold_x = 
$gold_y = 
$acoylte_x = 
$acoylte_y = 
$crypt_x = 
$crypt_y = 
$zigg_x = 
$zigg_y = 
$altar_x = 
$altar_y = 
$zigg2_x = 
$zigg2_y = 
$crypt_rally_x = 
$crypt_rally_y = 
$scout_x = 
$scout_y = 
$scout2_x = 
$scout2_y = 
$scout3_x = 
$scout3_y = 
$hero_rally_x = 
$hero_rally_y = 
$zigg3_x = 
$zigg3_y = 
$zigg4_x = 
$zigg4_y = 
$select_start_x = 
$select_start_y = 
$select_finish_x = 
$select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("SoloBot")
EndIF ;end from bot

EndIF ;end from map

WEnd

EndIf

If $msg = $rtstart Then

;Set-up
Global $Paused, $begin
GUICtrlSetData($rttraytip, "Waiting for Warcraft III to become acitve window")
WinWaitActive("Warcraft III")
HotKeySet("!{ESC}", "Terminate")
HotKeySet("!{F1}", "Quit")
HotKeySet("!{F2}", "Bugged")
HotKeySet("!s", "Countdown")
HotKeySet("{PAUSE}", "TogglePause")
Opt("TrayIconDebug", 1)
$hotkey_crypt = Chr(51)
$hotkey_altar = Chr(52)
$hotkey_army = Chr(49)
$hotkey_hall = Chr(50)

GUICtrlSetData($rttraytip, "Resizing window")
WinMove("Warcraft III", "", 0, 0, 1024, 731)

While 1
$game = 0

;Quick Play
$message = "Countdown until search: "
$i = 5
Do
	GUICtrlSetData($rttraytip, $message & $i)
    $i = $i - 1
    If $i < 0 Then Exitloop
    sleep(1000)
Until $i = 0
GUICtrlSetData($rttraytip, $message & $i)

While 1
	$color = IniRead($dir & "\Config.ini", "Game Colors", 1, "NotFound")
	$coord = PixelSearch( 990, 177, 990, 177, "0x" & $color)
	If Not @error Then ExitLoop
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 813, 594, 813, 594, "0x" & $color)
	If Not @error Then ExitLoop
	sleep(1000)
WEnd
sleep(2500)
While 1
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 820, 705, 820, 705, "0x" & $color)
	If Not @error Then ExitLoop
	$keyboard_key = "!q"
	Send("!q")
	If $keyboard_key = "!q" Then ExitLoop
	sleep(100)
WEnd

;Start game
GUICtrlSetData($rttraytip, "Waiting for game to begin")
While 1
	$begin = TimerInit()
	GUICtrlSetData ($rtprogressbar, "0")
	$color = IniRead($dir & "\Config.ini", "Game Colors", 2, "NotFound")
	$coord = PixelSearch( 820, 705, 820, 705, "0x" & $color)
	If Not @error Then ExitLoop
	sleep(1000)
WEnd

;Battleground
$color = IniRead($dir & "\Config.ini", "Game Colors", 34, "NotFound")
$coord = PixelSearch( 74, 566, 74, 566, "0x" & $color)
If Not @error Then

;Start game
;teal
$white_x = 95
$white_y = 570
$first_tree_x = 965
$first_tree_y = 112
$gold_x = 402
$gold_y = 242
$acoylte_x = 455
$acoylte_y = 322
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 167
$white_y = 596
$first_tree_x = 682
$first_tree_y = 68
$gold_x = 642
$gold_y = 424
$acoylte_x = 526
$acoylte_y = 409
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 177
$white_y = 641
$first_tree_x = 12
$first_tree_y = 441
$gold_x = 650
$gold_y = 413
$acoylte_x = 523
$acoylte_y = 413
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 176
$white_y = 687
$first_tree_x = 331
$first_tree_y = 542
$gold_x = 709
$gold_y = 344
$acoylte_x = 572
$acoylte_y = 323
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 99
$white_y = 695
$first_tree_x = 442
$first_tree_y = 61
$gold_x = 348
$gold_y = 382
$acoylte_x = 479
$acoylte_y = 358
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;red
$white_x = 60
$white_y = 694
$first_tree_x = 143
$first_tree_y = 439
$gold_x = 683
$gold_y = 397
$acoylte_x = 538
$acoylte_y = 368
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 30
$white_y = 640
$first_tree_x = 363
$first_tree_y = 83
$gold_x = 339
$gold_y = 373
$acoylte_x = 469
$acoylte_y = 350
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 49
$white_y = 592
$first_tree_x = 1008
$first_tree_y = 484
$gold_x = 367
$gold_y = 404
$acoylte_x = 476
$acoylte_y = 382
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Cherryville
$color = IniRead($dir & "\Config.ini", "Game Colors", 35, "NotFound")
$coord = PixelSearch( 136, 700, 136, 700, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 64
$white_y = 590
$first_tree_x = 395
$first_tree_y = 58
$gold_x = 349
$gold_y = 376
$acoylte_x = 468
$acoylte_y = 369
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 32
$white_y = 600
$first_tree_x = 949
$first_tree_y = 90
$gold_x = 345
$gold_y = 318
$acoylte_x = 454
$acoylte_y = 298
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 30
$white_y = 669
$first_tree_x = 482
$first_tree_y = 75
$gold_x = 342
$gold_y = 359
$acoylte_x = 454
$acoylte_y = 336
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 64
$white_y = 680
$first_tree_x = 1005
$first_tree_y = 215
$gold_x = 383
$gold_y = 240
$acoylte_x = 436
$acoylte_y = 325
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 149
$white_y = 686
$first_tree_x = 39
$first_tree_y = 128
$gold_x = 658
$gold_y = 239
$acoylte_x = 588
$acoylte_y = 325
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 179
$white_y = 676
$first_tree_x = 476
$first_tree_y = 60
$gold_x = 710
$gold_y = 336
$acoylte_x = 583
$acoylte_y = 314
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 181
$white_y = 605
$first_tree_x = 79
$first_tree_y = 75
$gold_x = 703
$gold_y = 285
$acoylte_x = 577
$acoylte_y = 266
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 149
$white_y = 595
$first_tree_x = 19
$first_tree_y = 471
$gold_x = 684
$gold_y = 402
$acoylte_x = 557
$acoylte_y = 379
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Deadlock
$color = IniRead($dir & "\Config.ini", "Game Colors", 36, "NotFound")
$coord = PixelSearch( 124, 667, 124, 667, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 40
$white_y = 581
$first_tree_x = 971
$first_tree_y = 246
$gold_x = 410
$gold_y = 214
$acoylte_x = 464
$acoylte_y = 293
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 174
$white_y = 576
$first_tree_x = 38
$first_tree_y = 105
$gold_x = 679
$gold_y = 245
$acoylte_x = 605
$acoylte_y = 322
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 174
$white_y = 698
$first_tree_x = 11
$first_tree_y = 378
$gold_x = 642
$gold_y = 429
$acoylte_x = 530
$acoylte_y = 398
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 45
$white_y = 698
$first_tree_x = 219
$first_tree_y = 59
$gold_x = 344
$gold_y = 378
$acoylte_x = 458
$acoylte_y = 357
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 109
$white_y = 572
$first_tree_x = 962
$first_tree_y = 497
$gold_x = 507
$gold_y = 195
$acoylte_x = 438
$acoylte_y = 260
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 178
$white_y = 636
$first_tree_x = 568
$first_tree_y = 61
$gold_x = 710
$gold_y = 321
$acoylte_x = 587
$acoylte_y = 297
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 106
$white_y = 706
$first_tree_x = 246
$first_tree_y = 65
$gold_x = 474
$gold_y = 465
$acoylte_x = 578
$acoylte_y = 433
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 32
$white_y = 642
$first_tree_x = 1014
$first_tree_y = 155
$gold_x = 424
$gold_y = 221
$acoylte_x = 465
$acoylte_y = 294
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Dragon Falls
$color = IniRead($dir & "\Config.ini", "Game Colors", 37, "NotFound")
$coord = PixelSearch( 177, 710, 177, 710, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 42
$white_y = 607
$first_tree_x = 20
$first_tree_y = 231
$gold_x = 614
$gold_y = 429
$acoylte_x = 480
$acoylte_y = 411
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 70
$white_y = 587
$first_tree_x = 637
$first_tree_y = 69
$gold_x = 688
$gold_y = 385
$acoylte_x = 561
$acoylte_y = 362
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 143
$white_y = 586
$first_tree_x = 310
$first_tree_y = 57
$gold_x = 354
$gold_y = 383
$acoylte_x = 456
$acoylte_y = 360
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 168
$white_y = 606
$first_tree_x = 1007
$first_tree_y = 82
$gold_x = 464
$gold_y = 456
$acoylte_x = 566
$acoylte_y = 432
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 167
$white_y = 674
$first_tree_x = 959
$first_tree_y = 224
$gold_x = 444
$gold_y = 194
$acoylte_x = 491
$acoylte_y = 266
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 143
$white_y = 691
$first_tree_x = 204
$first_tree_y = 539
$gold_x = 366
$gold_y = 253
$acoylte_x = 412
$acoylte_y = 329
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 64
$white_y = 691
$first_tree_x = 46
$first_tree_y = 185
$gold_x = 686
$gold_y = 241
$acoylte_x = 613
$acoylte_y = 316
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 44
$white_y = 670
$first_tree_x = 26
$first_tree_y = 201
$gold_x = 577
$gold_y = 186
$acoylte_x = 503
$acoylte_y = 269
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Friends
$color = IniRead($dir & "\Config.ini", "Game Colors", 38, "NotFound")
$coord = PixelSearch( 190, 560, 190, 560, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 115
$white_y = 575
$tree_click_x = 120
$tree_click_y = 579
$first_tree_x = 650
$first_tree_y = 297
$gold_x = 468
$gold_y = 454
$acoylte_x = 583
$acoylte_y = 436
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 98
$white_y = 576
$tree_click_x = 92
$tree_click_y = 579
$first_tree_x = 319
$first_tree_y = 262
$gold_x = 543
$gold_y = 459
$acoylte_x = 417
$acoylte_y = 434
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 110
$white_y = 702
$first_tree_x = 995
$first_tree_y = 251
$gold_x = 495
$gold_y = 193
$acoylte_x = 544
$acoylte_y = 261
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 90
$white_y = 701
$first_tree_x = 18
$first_tree_y = 278
$gold_x = 551
$gold_y = 175
$acoylte_x = 477
$acoylte_y = 251
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 43
$white_y = 644
$tree_click_x = 43
$tree_click_y = 649
$first_tree_x = 189
$first_tree_y = 361
$gold_x = 712
$gold_y = 283
$acoylte_x = 626
$acoylte_y = 362
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 42
$white_y = 631
$tree_click_x = 43
$tree_click_y = 621
$first_tree_x = 322
$first_tree_y = 288
$gold_x = 710
$gold_y = 319
$acoylte_x = 633
$acoylte_y = 397
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 174
$white_y = 628
$first_tree_x = 310
$first_tree_y = 60
$gold_x = 332
$gold_y = 336
$acoylte_x = 444
$acoylte_y = 316
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 173
$white_y = 646
$tree_click_x = 171
$tree_click_y = 648
$first_tree_x = 420
$first_tree_y = 405
$gold_x = 343
$gold_y = 289
$acoylte_x = 443
$acoylte_y = 259
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Full Scale Assault
$color = IniRead($dir & "\Config.ini", "Game Colors", 39, "NotFound")
$coord = PixelSearch( 103, 666, 103, 666, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 37
$white_y = 596
$first_tree_x = 754
$first_tree_y = 62
$gold_x = 327
$gold_y = 284
$acoylte_x = 440
$acoylte_y = 266
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 35
$white_y = 619
$first_tree_x = 685
$first_tree_y = 72
$gold_x = 336
$gold_y = 283
$acoylte_x = 443
$acoylte_y = 283
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 36
$white_y = 656
$first_tree_x = 713
$first_tree_y = 562
$gold_x = 333
$gold_y = 288
$acoylte_x = 439
$acoylte_y = 280
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 36
$white_y = 684
$first_tree_x = 426
$first_tree_y = 562
$gold_x = 341
$gold_y = 297
$acoylte_x = 439
$acoylte_y = 270
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 176
$white_y = 597
$first_tree_x = 248
$first_tree_y = 66
$gold_x = 714
$gold_y = 316
$acoylte_x = 586
$acoylte_y = 291
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 176
$white_y = 619
$first_tree_x = 248
$first_tree_y = 70
$gold_x = 705
$gold_y = 315
$acoylte_x = 585
$acoylte_y = 291
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 175
$white_y = 658
$tree_click_x = 174
$tree_click_y = 663
$first_tree_x = 477
$first_tree_y = 337
$gold_x = 718
$gold_y = 292
$acoylte_x = 587
$acoylte_y = 279
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 178
$white_y = 686
$first_tree_x = 988
$first_tree_y = 512
$gold_x = 718
$gold_y = 306
$acoylte_x = 589
$acoylte_y = 287
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Gold Rush
$color = IniRead($dir & "\Config.ini", "Game Colors", 40, "NotFound")
$coord = PixelSearch( 130, 684, 130, 684, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 56
$white_y = 595
$first_tree_x = 161
$first_tree_y = 513
$gold_x = 468
$gold_y = 183
$acoylte_x = 519
$acoylte_y = 254
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 104
$white_y = 589
$first_tree_x = 104
$first_tree_y = 307
$gold_x = 538
$gold_y = 177
$acoylte_x = 463
$acoylte_y = 245
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 154
$white_y = 595
$first_tree_x = 864
$first_tree_y = 498
$gold_x = 592
$gold_y = 193
$acoylte_x = 519
$acoylte_y = 261
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 159
$white_y = 635
$first_tree_x = 513
$first_tree_y = 95
$gold_x = 709
$gold_y = 350
$acoylte_x = 579
$acoylte_y = 327
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 150
$white_y = 681
$first_tree_x = 736
$first_tree_y = 111
$gold_x = 666
$gold_y = 402
$acoylte_x = 542
$acoylte_y = 383
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 107
$white_y = 685
$first_tree_x = 900
$first_tree_y = 280
$gold_x = 480
$gold_y = 433
$acoylte_x = 357
$acoylte_y = 415
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 56
$white_y = 679
$first_tree_x = 215
$first_tree_y = 77
$gold_x = 427
$gold_y = 439
$acoylte_x = 550
$acoylte_y = 424
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 51
$white_y = 639
$first_tree_x = 473
$first_tree_y = 74
$gold_x = 335
$gold_y = 291
$acoylte_x = 440
$acoylte_y = 269
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Golems in the Mist
$color = IniRead($dir & "\Config.ini", "Game Colors", 41, "NotFound")
$coord = PixelSearch( 100, 559, 100, 559, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 177
$white_y = 693
$first_tree_x = 550
$first_tree_y = 80
$gold_x = 702
$gold_y = 350
$acoylte_x = 579
$acoylte_y = 327
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 184
$white_y = 632
$first_tree_x = 308
$first_tree_y = 551
$gold_x = 704
$gold_y = 297
$acoylte_x = 584
$acoylte_y = 280
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 179
$white_y = 583
$first_tree_x = 783
$first_tree_y = 525
$gold_x = 645
$gold_y = 241
$acoylte_x = 575
$acoylte_y = 313
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 68
$white_y = 576
$first_tree_x = 947
$first_tree_y = 405
$gold_x = 557
$gold_y = 200
$acoylte_x = 488
$acoylte_y = 265
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 32
$white_y = 611
$first_tree_x = 611
$first_tree_y = 535
$gold_x = 343
$gold_y = 295
$acoylte_x = 446
$acoylte_y = 280
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 30
$white_y = 659
$first_tree_x = 301
$first_tree_y = 529
$gold_x = 389
$gold_y = 235
$acoylte_x = 445
$acoylte_y = 304
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 44
$white_y = 704
$first_tree_x = 880
$first_tree_y = 294
$gold_x = 477
$gold_y = 455
$acoylte_x = 585
$acoylte_y = 436
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 136
$white_y = 709
$first_tree_x = 223
$first_tree_y = 228
$gold_x = 509
$gold_y = 468
$acoylte_x = 628
$acoylte_y = 451
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Market Square
$color = IniRead($dir & "\Config.ini", "Game Colors", 42, "NotFound")
$coord = PixelSearch( 110, 616, 110, 616, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 30
$white_y = 674
$first_tree_x = 455
$first_tree_y = 67
$gold_x = 334
$gold_y = 312
$acoylte_x = 441
$acoylte_y = 286
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 29
$white_y = 607
$first_tree_x = 449
$first_tree_y = 64
$gold_x = 334
$gold_y = 306
$acoylte_x = 441
$acoylte_y = 287
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 67
$white_y = 572
$first_tree_x = 26
$first_tree_y = 321
$gold_x = 520
$gold_y = 178
$acoylte_x = 573
$acoylte_y = 249
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 142
$white_y = 570
$first_tree_x = 48
$first_tree_y = 341
$gold_x = 523
$gold_y = 182
$acoylte_x = 449
$acoylte_y = 245
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 181
$white_y = 604
$first_tree_x = 460
$first_tree_y = 58
$gold_x = 711
$gold_y = 302
$acoylte_x = 586
$acoylte_y = 281
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 182
$white_y = 673
$first_tree_x = 477
$first_tree_y = 57
$gold_x = 708
$gold_y = 293
$acoylte_x = 586
$acoylte_y = 271
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 144
$white_y = 705
$first_tree_x = 57
$first_tree_y = 263
$gold_x = 520
$gold_y = 450
$acoylte_x = 627
$acoylte_y = 431
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 67
$white_y = 706
$first_tree_x = 59
$first_tree_y = 269
$gold_x = 526
$gold_y = 464
$acoylte_x = 397
$acoylte_y = 428
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Mur'gul Oasis
$color = IniRead($dir & "\Config.ini", "Game Colors", 43, "NotFound")
$coord = PixelSearch( 89, 638, 89, 638, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 31
$white_y = 608
$first_tree_x = 1011
$first_tree_y = 286
$gold_x = 437
$gold_y = 202
$acoylte_x = 494
$acoylte_y = 277
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 73
$white_y = 572
$first_tree_x = 438
$first_tree_y = 551
$gold_x = 364
$gold_y = 248
$acoylte_x = 415
$acoylte_y = 323
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 136
$white_y = 570
$first_tree_x = 267
$first_tree_y = 65
$gold_x = 695
$gold_y = 266
$acoylte_x = 577
$acoylte_y = 257
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 181
$white_y = 606
$first_tree_x = 21
$first_tree_y = 221
$gold_x = 599
$gold_y = 209
$acoylte_x = 531
$acoylte_y = 276
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 180
$white_y = 670
$first_tree_x = 46
$first_tree_y = 254
$gold_x = 637
$gold_y = 428
$acoylte_x = 512
$acoylte_y = 405
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 139
$white_y = 706
$first_tree_x = 657
$first_tree_y = 65
$gold_x = 690
$gold_y = 377
$acoylte_x = 569
$acoylte_y = 364
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 69
$white_y = 705
$first_tree_x = 223
$first_tree_y = 82
$gold_x = 368
$gold_y = 401
$acoylte_x = 478
$acoylte_y = 389
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 30
$white_y = 668
$first_tree_x = 40
$first_tree_y = 138
$gold_x = 432
$gold_y = 455
$acoylte_x = 535
$acoylte_y = 433
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Slalom
$color = IniRead($dir & "\Config.ini", "Game Colors", 44, "NotFound")
$coord = PixelSearch( 116, 638, 116, 638, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 24
$white_y = 620
$first_tree_x = 944
$first_tree_y = 246
$gold_x = 420
$gold_y = 208
$acoylte_x = 476
$acoylte_y = 283
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;blue
$white_x = 24
$white_y = 656
$first_tree_x = 194
$first_tree_y = 120
$gold_x = 404
$gold_y = 435
$acoylte_x = 516
$acoylte_y = 410
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;teal
$white_x = 25
$white_y = 637
$first_tree_x = 151
$first_tree_y = 75
$gold_x = 342
$gold_y = 295
$acoylte_x = 445
$acoylte_y = 281
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;purple
$white_x = 40
$white_y = 636
$first_tree_x = 387
$first_tree_y = 81
$gold_x = 708
$gold_y = 283
$acoylte_x = 579
$acoylte_y = 275
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;yellow
$white_x = 186
$white_y = 620
$first_tree_x = 107
$first_tree_y = 220
$gold_x = 601
$gold_y = 190
$acoylte_x = 533
$acoylte_y = 265
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;orange
$white_x = 186
$white_y = 657
$first_tree_x = 723
$first_tree_y = 82
$gold_x = 658
$gold_y = 406
$acoylte_x = 530
$acoylte_y = 392
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;green
$white_x = 186
$white_y = 639
$first_tree_x = 583
$first_tree_y = 72
$gold_x = 692
$gold_y = 276
$acoylte_x = 616
$acoylte_y = 347
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;pink
$white_x = 165
$white_y = 639
$first_tree_x = 693
$first_tree_y = 57
$gold_x = 346
$gold_y = 277
$acoylte_x = 450
$acoylte_y = 271
; $crypt_x = 
; $crypt_y = 
; $zigg_x = 
; $zigg_y = 
; $altar_x = 
; $altar_y = 
; $zigg2_x = 
; $zigg2_y = 
; $crypt_rally_x = 
; $crypt_rally_y = 
; $scout_x = 
; $scout_y = 
; $scout2_x = 
; $scout2_y = 
; $scout3_x = 
; $scout3_y = 
; $hero_rally_x = 
; $hero_rally_y = 
; $zigg3_x = 
; $zigg3_y = 
; $zigg4_x = 
; $zigg4_y = 
; $select_start_x = 
; $select_start_y = 
; $select_finish_x = 
; $select_finish_y = 
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Excavation Site
$color = IniRead($dir & "\Config.ini", "Game Colors", 47, "NotFound")
$coord = PixelSearch( 114, 629, 114, 629, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 35
$white_y = 571
$first_tree_x = 885
$first_tree_y = 200
$gold_x = 387
$gold_y = 203
$acoylte_x = 443
$acoylte_y = 277
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 34
$white_y = 705
$first_tree_x = 331
$first_tree_y = 94
$gold_x = 380
$gold_y = 403
$acoylte_x = 490
$acoylte_y = 383
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 176
$white_y = 573
$first_tree_x = 29
$first_tree_y = 155
$gold_x = 632
$gold_y = 206
$acoylte_x = 565
$acoylte_y = 283
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 175
$white_y = 705
$first_tree_x = 29
$first_tree_y = 373
$gold_x = 659
$gold_y = 414
$acoylte_x = 539
$acoylte_y = 377
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Goldshire
$color = IniRead($dir & "\Config.ini", "Game Colors", 48, "NotFound")
$coord = PixelSearch( 47, 584, 47, 584, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 41
$white_y = 653
$first_tree_x = 916
$first_tree_y = 194
$gold_x = 414
$gold_y = 215
$acoylte_x = 475
$acoylte_y = 277
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 117
$white_y = 692
$first_tree_x = 794
$first_tree_y = 515
$gold_x = 591
$gold_y = 194
$acoylte_x = 520
$acoylte_y = 262
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 123
$white_y = 578
$first_tree_x = 836
$first_tree_y = 442
$gold_x = 589
$gold_y = 189
$acoylte_x = 520
$acoylte_y = 258
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 181
$white_y = 646
$first_tree_x = 55
$first_tree_y = 384
$gold_x = 571
$gold_y = 186
$acoylte_x = 503
$acoylte_y = 258
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Wetlands
$color = IniRead($dir & "\Config.ini", "Game Colors", 49, "NotFound")
$coord = PixelSearch( 154, 637, 154, 637, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 35
$white_y = 574
$first_tree_x = 778
$first_tree_y = 200
$gold_x = 414
$gold_y = 228
$acoylte_x = 455
$acoylte_y = 298
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 173
$white_y = 580
$first_tree_x = 698
$first_tree_y = 531
$gold_x = 604
$gold_y = 186
$acoylte_x = 530
$acoylte_y = 252
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 175
$white_y = 703
$first_tree_x = 54
$first_tree_y = 325
$gold_x = 662
$gold_y = 421
$acoylte_x = 529
$acoylte_y = 393
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 35
$white_y = 701
$first_tree_x = 356
$first_tree_y = 108
$gold_x = 431
$gold_y = 455
$acoylte_x = 548
$acoylte_y = 428
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Tranquil Paths
$color = IniRead($dir & "\Config.ini", "Game Colors", 50, "NotFound")
$coord = PixelSearch( 65, 572, 65, 572, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 31
$white_y = 596
$first_tree_x = 206
$first_tree_y = 490
$gold_x = 385
$gold_y = 231
$acoylte_x = 428
$acoylte_y = 313
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 168
$white_y = 577
$first_tree_x = 99
$first_tree_y = 221
$gold_x = 633
$gold_y = 212
$acoylte_x = 564
$acoylte_y = 286
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 171
$white_y = 703
$first_tree_x = 706
$first_tree_y = 77
$gold_x = 655
$gold_y = 405
$acoylte_x = 531
$acoylte_y = 383
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 52
$white_y = 703
$first_tree_x = 535
$first_tree_y = 94
$gold_x = 342
$gold_y = 365
$acoylte_x = 458
$acoylte_y = 353
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Moonglade
$color = IniRead($dir & "\Config.ini", "Game Colors", 51, "NotFound")
$coord = PixelSearch( 112, 665, 112, 665, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 149
$white_y = 591
$first_tree_x = 43
$first_tree_y = 436
$gold_x = 632
$gold_y = 415
$acoylte_x = 516
$acoylte_y = 405
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 155
$white_y = 654
$first_tree_x = 786
$first_tree_y = 101
$gold_x = 611
$gold_y = 445
$acoylte_x = 482
$acoylte_y = 414
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 118
$white_y = 709
$first_tree_x = 291
$first_tree_y = 98
$gold_x = 369
$gold_y = 393
$acoylte_x = 472
$acoylte_y = 379
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 54
$white_y = 697
$first_tree_x = 165
$first_tree_y = 261
$gold_x = 469
$gold_y = 187
$acoylte_x = 518
$acoylte_y = 261
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;yellow
$white_x = 56
$white_y = 635
$first_tree_x = 277
$first_tree_y = 254
$gold_x = 470
$gold_y = 190
$acoylte_x = 522
$acoylte_y = 265
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;orange
$white_x = 90
$white_y = 572
$first_tree_x = 144
$first_tree_y = 236
$gold_x = 594
$gold_y = 197
$acoylte_x = 522
$acoylte_y = 265
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Emerald Shores
$color = IniRead($dir & "\Config.ini", "Game Colors", 52, "NotFound")
$coord = PixelSearch( 110, 661, 110, 661, "0x" & $color)
If Not @error Then

;Start game
;red
$white_x = 48
$white_y = 592
$first_tree_x = 768
$first_tree_y = 482
$gold_x = 404
$gold_y = 415
$acoylte_x = 519
$acoylte_y = 412
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;blue
$white_x = 45
$white_y = 642
$first_tree_x = 822
$first_tree_y = 461
$gold_x = 428
$gold_y = 442
$acoylte_x = 548
$acoylte_y = 416
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;teal
$white_x = 49
$white_y = 686
$first_tree_x = 859
$first_tree_y = 148
$gold_x = 417
$gold_y = 213
$acoylte_x = 459
$acoylte_y = 291
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;purple
$white_x = 159
$white_y = 591
$first_tree_x = 905
$first_tree_y = 357
$gold_x = 663
$gold_y = 424
$acoylte_x = 532
$acoylte_y = 386
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;yellow
$white_x = 163
$white_y = 645
$first_tree_x = 27
$first_tree_y = 453
$gold_x = 615
$gold_y = 453
$acoylte_x = 481
$acoylte_y = 416
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;orange
$white_x = 163
$white_y = 687
$first_tree_x = 55
$first_tree_y = 169
$gold_x = 593
$gold_y = 192
$acoylte_x = 520
$acoylte_y = 263
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIf ;end from map

;Lost Temple (Snow)
$color = IniRead($dir & "\Config.ini", "Game Colors", 8, "NotFound")
$coord = PixelSearch( 82, 699, 82, 699, "0x" & $color)
If Not @error Then

;Start game
;bottom
$white_x = 121
$white_y = 705
$first_tree_x = 38
$first_tree_y = 408
$gold_x = 660
$gold_y = 400
$acoylte_x = 540
$acoylte_y = 386
$crypt_x = 191
$crypt_y = 346
$zigg_x = 663
$zigg_y = 489
$altar_x = 827
$altar_y = 200
$zigg2_x = 524
$zigg2_y = 560
$crypt_rally_x = 68
$crypt_rally_y = 532
$scout3_x = 176
$scout3_y = 621
$scout_x = 35
$scout_y = 662
$scout2_x = 96
$scout2_y = 578
$hero_rally_x = 262
$hero_rally_y = 416
$zigg3_x = 722
$zigg3_y = 393
$zigg4_x = 841
$zigg4_y = 388
$select_start_x = 497
$select_start_y = 270
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;left
$white_x = 31
$white_y = 663
$first_tree_x = 300
$first_tree_y = 76
$gold_x = 381
$gold_y = 443
$acoylte_x = 504
$acoylte_y = 393
$crypt_x = 401
$crypt_y = 142
$zigg_x = 400
$zigg_y = 487
$altar_x = 715
$altar_y = 556
$zigg2_x = 295
$zigg2_y = 422
$crypt_rally_x = 135
$crypt_rally_y = 118
$scout2_x = 176
$scout2_y = 621
$scout3_x = 96
$scout3_y = 578
$scout_x = 116
$scout_y = 699
$hero_rally_x = 265
$hero_rally_y = 251
$zigg3_x = 183
$zigg3_y = 414
$zigg4_x = 521
$zigg4_y = 551
$select_start_x = 399
$select_start_y = 405
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;top
$white_x = 97
$white_y = 573
$first_tree_x = 801
$first_tree_y = 198
$gold_x = 417
$gold_y = 204
$acoylte_x = 481
$acoylte_y = 279
$crypt_x = 801
$crypt_y = 224
$zigg_x = 338
$zigg_y = 217
$altar_x = 93
$altar_y = 296
$zigg4_x = 132
$zigg4_y = 205
$crypt_rally_x = 764
$crypt_rally_y = 64
$scout_x = 176
$scout_y = 621
$scout2_x = 116
$scout2_y = 699
$scout3_x = 35
$scout3_y = 662
$hero_rally_x = 662
$hero_rally_y = 146
$zigg3_x = 460
$zigg3_y = 184
$zigg2_x = 235
$zigg2_y = 213
$select_start_x = 466
$select_start_y = 260
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;right
$white_x = 179
$white_y = 619
$first_tree_x = 895
$first_tree_y = 459
$gold_x = 615
$gold_y = 203
$acoylte_x = 544
$acoylte_y = 277
$crypt_x = 608
$crypt_y = 512
$zigg_x = 568
$zigg_y = 132
$altar_x = 376
$altar_y = 114
$zigg2_x = 692
$zigg2_y = 215
$crypt_rally_x = 998
$crypt_rally_y = 389
$scout2_x = 35
$scout2_y = 662
$scout_x = 96
$scout_y = 578
$scout3_x = 116
$scout3_y = 699
$hero_rally_x = 794
$hero_rally_y = 341
$zigg3_x = 794
$zigg3_y = 215
$zigg4_x = 550
$zigg4_y = 81
$select_start_x = 564
$select_start_y = 204
$select_finish_x = 1023
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIF ;end from map

;Phantom Grove
$color = IniRead($dir & "\Config.ini", "Game Colors", 15, "NotFound")
$coord = PixelSearch( 177, 704, 177, 704, "0x" & $color)
If Not @error Then

;Start game
;left
$white_x = 34
$white_y = 612
$first_tree_x = 887
$first_tree_y = 167
$gold_x = 416
$gold_y = 206
$acoylte_x = 483
$acoylte_y = 278
$crypt_x = 792
$crypt_y = 348
$zigg_x = 333
$zigg_y = 213
$altar_x = 171
$altar_y = 310
$zigg2_x = 235
$zigg2_y = 202
$crypt_rally_x = 844
$crypt_rally_y = 138
$scout_x = 130
$scout_y = 576
$scout2_x = 172
$scout2_y = 665
$scout3_x = 79
$scout3_y = 702
$hero_rally_x = 721
$hero_rally_y = 213
$zigg3_x = 474
$zigg3_y = 185
$zigg4_x = 138
$zigg4_y = 208
$select_start_x = 516
$select_start_y = 353
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;top
$white_x = 135
$white_y = 574
$first_tree_x = 716
$first_tree_y = 559
$gold_x = 658
$gold_y = 218
$acoylte_x = 584
$acoylte_y = 294
$crypt_x = 550
$crypt_y = 544
$zigg_x = 697
$zigg_y = 253
$altar_x = 438
$altar_y = 126
$zigg2_x = 811
$zigg2_y = 255
$crypt_rally_x = 880
$crypt_rally_y = 469
$scout_x = 35
$scout_y = 615
$scout2_x = 79
$scout2_y = 702
$scout3_x = 172
$scout3_y = 665
$hero_rally_x = 775
$hero_rally_y = 429
$zigg3_x = 629
$zigg3_y = 184
$zigg4_x = 634
$zigg4_y = 115
$select_start_x = 542
$select_start_y = 231
$select_finish_x = 1023
$select_finish_y = 628
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;right
$white_x = 173
$white_y = 672
$first_tree_x = 40
$first_tree_y = 389
$gold_x = 616
$gold_y = 445
$acoylte_x = 492
$acoylte_y = 420
$crypt_x = 196
$crypt_y = 319
$zigg_x = 603
$zigg_y = 486
$altar_x = 856
$altar_y = 318
$zigg2_x = 733
$zigg2_y = 489
$crypt_rally_x = 71
$crypt_rally_y = 527
$scout_x = 79
$scout_y = 702
$scout2_x = 35
$scout2_y = 615
$scout3_x = 130
$scout3_y = 576
$hero_rally_x = 225
$hero_rally_y = 511
$zigg3_x = 871
$zigg3_y = 488
$zigg4_x = 985
$zigg4_y = 510
$select_start_x = 591
$select_start_y = 269
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;bottom
$white_x = 76
$white_y = 705
$first_tree_x = 254
$first_tree_y = 67
$gold_x = 389
$gold_y = 418
$acoylte_x = 506
$acoylte_y = 402
$crypt_x = 397
$crypt_y = 96
$zigg_x = 412
$zigg_y = 472
$altar_x = 716
$altar_y = 508
$zigg2_x = 305
$zigg2_y = 423
$crypt_rally_x = 153
$crypt_rally_y = 100
$scout_x = 35
$scout_y = 615
$scout2_x = 130
$scout2_y = 576
$scout3_x = 172
$scout3_y = 665
$hero_rally_x = 219
$hero_rally_y = 216
$zigg3_x = 174
$zigg3_y = 415
$zigg4_x = 541
$zigg4_y = 548
$select_start_x = 436
$select_start_y = 399
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIF ;end from map

;Turtle Rock
$color = IniRead($dir & "\Config.ini", "Game Colors", 6, "NotFound")
$coord = PixelSearch( 96, 652, 96, 652, "0x" & $color)
If Not @error Then

;Start game
;top left
$white_x = 36
$white_y = 618
$first_tree_x = 833
$first_tree_y = 206
$gold_x = 405
$gold_y = 212
$acoylte_x = 462
$acoylte_y = 275
$crypt_x = 763
$crypt_y = 292
$zigg_x = 343
$zigg_y = 228
$altar_x = 264
$altar_y = 355
$zigg2_x = 426
$zigg2_y = 186
$crypt_rally_x = 747
$crypt_rally_y = 86
$scout_x = 82
$scout_y = 586
$scout2_x = 170
$scout2_y = 658
$scout3_x = 134
$scout3_y = 696
$hero_rally_x = 667
$hero_rally_y = 180
$zigg3_x = 436
$zigg3_y = 120
$zigg4_x = 209
$zigg4_y = 227
$select_start_x = 444
$select_start_y = 300
$select_finish_x = 859
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;bottom left
$white_x = 140
$white_y = 700
$first_tree_x = 798
$first_tree_y = 65
$gold_x = 646
$gold_y = 430
$acoylte_x = 511
$acoylte_y = 393
$crypt_x = 588
$crypt_y = 127
$zigg_x = 573
$zigg_y = 480
$altar_x = 214
$altar_y = 408
$zigg2_x = 721
$zigg2_y = 447
$crypt_rally_x = 869
$crypt_rally_y = 103
$scout_x = 40
$scout_y = 622
$scout2_x = 82
$scout2_y = 586
$scout3_x = 170
$scout3_y = 658
$hero_rally_x = 782
$hero_rally_y = 230
$zigg3_x = 854
$zigg3_y = 443
$zigg4_x = 446
$zigg4_y = 556
$select_start_x = 545
$select_start_y = 456
$select_finish_x = 1023
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;bottom right
$white_x = 176
$white_y = 662
$first_tree_x = 61
$first_tree_y = 384
$gold_x = 665
$gold_y = 414
$acoylte_x = 529
$acoylte_y = 382
$crypt_x = 182
$crypt_y = 341
$zigg_x = 728
$zigg_y = 421
$altar_x = 740
$altar_y = 208
$zigg2_x = 845
$zigg2_y = 418
$crypt_rally_x = 118
$crypt_rally_y = 525
$scout_x = 134
$scout_y = 696
$scout2_x = 40
$scout2_y = 622
$scout3_x = 82
$scout3_y = 586
$hero_rally_x = 395
$hero_rally_y = 532
$zigg3_x = 623
$zigg3_y = 548
$zigg4_x = 831
$zigg4_y = 326
$select_start_x = 575
$select_start_y = 281
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;top right
$white_x = 76
$white_y = 583
$first_tree_x = 89
$first_tree_y = 493
$gold_x = 416
$gold_y = 198
$acoylte_x = 480
$acoylte_y = 263
$crypt_x = 431
$crypt_y = 547
$zigg_x = 325
$zigg_y = 210
$altar_x = 724
$altar_y = 222
$zigg2_x = 223
$zigg2_y = 207
$crypt_rally_x = 39
$crypt_rally_y = 426
$scout_x = 170
$scout_y = 658
$scout2_x = 134
$scout2_y = 696
$scout3_x = 40
$scout3_y = 622
$hero_rally_x = 208
$hero_rally_y = 408
$zigg3_x = 121
$zigg3_y = 198
$zigg4_x = 455
$zigg4_y = 176
$select_start_x = 455
$select_start_y = 259
$select_finish_x = 0
$select_finish_y = 767
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIF ;end from map

;Twisted Medows
$color = IniRead($dir & "\Config.ini", "Game Colors", 3, "NotFound")
$coord = PixelSearch( 107, 629, 107, 629, "0x" & $color)
If Not @error Then

;Start game
;bottom left
$white_x = 54
$white_y = 676
$first_tree_x = 312
$first_tree_y = 60
$gold_x = 332
$gold_y = 352
$acoylte_x = 460
$acoylte_y = 339
$crypt_x = 354
$crypt_y = 69
$zigg_x = 302
$zigg_y = 353
$altar_x = 492
$altar_y = 573
$zigg2_x = 291
$zigg2_y = 459
$crypt_rally_x = 75
$crypt_rally_y = 62
$scout_x = 66
$scout_y = 593
$scout2_x = 152
$scout2_y = 605
$scout3_x = 142
$scout3_y = 681
$hero_rally_x = 204
$hero_rally_y = 149
$zigg3_x = 193
$zigg3_y = 293
$zigg4_x = 266
$zigg4_y = 563
$select_start_x = 432
$select_start_y = 312
$select_finish_x = 0
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;top left
$white_x = 65
$white_y = 592
$first_tree_x = 850
$first_tree_y = 122
$gold_x = 412
$gold_y = 210
$acoylte_x = 467
$acoylte_y = 291
$crypt_x = 780
$crypt_y = 217
$zigg_x = 340
$zigg_y = 227
$altar_x = 85
$altar_y = 327
$zigg2_x = 428
$zigg2_y = 197
$crypt_rally_x = 715
$crypt_rally_y = 61
$scout_x = 152
$scout_y = 605
$scout2_x = 142
$scout2_y = 681
$scout3_x = 56
$scout3_y = 673
$hero_rally_x = 644
$hero_rally_y = 129
$zigg3_x = 428
$zigg3_y = 142
$zigg4_x = 225
$zigg4_y = 233
$select_start_x = 436
$select_start_y = 246
$select_finish_x = 840
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;top right
$white_x = 157
$white_y = 599
$first_tree_x = 201
$first_tree_y = 109
$gold_x = 667
$gold_y = 224
$acoylte_x = 599
$acoylte_y = 298
$crypt_x = 273
$crypt_y = 242
$zigg_x = 695
$zigg_y = 280
$altar_x = 835
$altar_y = 436
$zigg2_x = 805
$zigg2_y = 277
$crypt_rally_x = 330
$crypt_rally_y = 65
$scout_x = 142
$scout_y = 681
$scout2_x = 56
$scout2_y = 673
$scout3_x = 66
$scout3_y = 593
$hero_rally_x = 433
$hero_rally_y = 121
$zigg3_x = 656
$zigg3_y = 179
$zigg4_x = 919
$zigg4_y = 268
$select_start_x = 671
$select_start_y = 209
$select_finish_x = 204
$select_finish_y = 0
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

;Start game
;bottom right
$white_x = 149
$white_y = 689
$first_tree_x = 917
$first_tree_y = 143
$gold_x = 505
$gold_y = 445
$acoylte_x = 369
$acoylte_y = 426
$crypt_x = 675
$crypt_y = 165
$zigg_x = 494
$zigg_y = 515
$altar_x = 196
$altar_y = 547
$zigg2_x = 621
$zigg2_y = 517
$crypt_rally_x = 927
$crypt_rally_y = 241
$scout_x = 56
$scout_y = 673
$scout2_x = 66
$scout2_y = 593
$scout3_x = 152
$scout3_y = 605
$hero_rally_x = 781
$hero_rally_y = 332
$zigg3_x = 748
$zigg3_y = 570
$zigg4_x = 363
$zigg4_y = 517
$select_start_x = 537
$select_start_y = 505
$select_finish_x = 1023
$select_finish_y = 104
$coord = PixelSearch( $white_x , $white_y, $white_x , $white_y, 0xFFFFFF, 75 )	
If Not @error Then
Call("RTBoT")
EndIF ;end from bot

EndIF ;end from map

WEnd

EndIf

WEnd

Func SoloBot()
	While 1
		$begin = TimerInit()
		AdlibEnable("SoloCheckConditions", 5000)
		
		;ghoul on wood
		GUICtrlSetData($solotraytip, "Putting ghoul on wood")
		sleep(1000)
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			If $game = 1 Then ExitLoop
			mousemove(1015,59,0)
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			MouseUp( "left" )
		WEnd
		
		$color = IniRead($dir & "\Config.ini", "Game Colors", 13 , "NotFound")
		$coord = PixelSearch( 825 , 590, 825 , 590, "0x" & $color)
		If Not @error Then 
			If $game = 1 Then ExitLoop
			mousemove(1015,59,0)
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			MouseUp( "left" )
		EndIf
		
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			send("g")
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			mouseclick("left", $first_tree_x, $first_tree_y, 1, 0)
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		While 1
			$hotkey = Chr(54)
			Send("^{" & $hotkey & "}")
			If $hotkey = "6" Then ExitLoop
			sleep(100)
		WEnd
		
		;Selecting acoyltes
		GUICtrlSetData($solotraytip, "Selecting acoyltes")
		$checksum = PixelChecksum(874,636,874,636)
		While $checksum = PixelChecksum(874,636,874,636)
			Send("{CTRLDOWN}")
			mouseclick("left", 458, 628, 1, 0)
			Send("{CTRLUP}")
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		;Find gold mine
		GUICtrlSetData($solotraytip, "Finding gold mine")
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			send("g")
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			mouseclick("left", $gold_x, $gold_y, 1, 0)
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		;Train 3 acoyltes
		GUICtrlSetData($solotraytip, "Training 3 acoyltes")
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			Send("{bs}")
			mouseclick("left", 516, 300, 1, 0)
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		Send("{c 3}{SPACE}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		mouseclick("right", $gold_x, $gold_y, 1, 0)
		If $game = 1 Then ExitLoop
		
		While 1
			mouseclick("left", $acoylte_x, $acoylte_y, 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		mouseclick("left", 423, 630, 1, 0)
		While 1
			$hotkey = Chr(53)
			Send("+{" & $hotkey & "}")
			If $hotkey = "5" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("{bs}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		;Build crypt
		GUICtrlSetData($solotraytip, "Building crypt")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 817, 600, 817, 600, "0x" & $color)
			If Not @error Then ExitLoop
			If $game = 1 Then ExitLoop
			send("c")
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		sleep(2000)
		mouseclick("left", $crypt_x, $crypt_y, 1, 0)
		sleep(2000)
		
		;Open chat
		GUICtrlSetData($solotraytip, "Saying the opening")
		Send("{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		$chat_number = IniRead($dir & "\Config.ini", "Chat Cheats", "0", "NotFound")
		$chat = Int(Random($chat_number)+1)
		$var = IniRead($dir & "\Config.ini", "Chat Cheats", $chat, "NotFound")
		$var1 = "                                                   "
		
		ClipPut ( $var1 & $var )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		
		sleep(5000)
		;Build Zigg
		GUICtrlSetData($solotraytip, "Build Zigg")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left", $zigg_x, $zigg_y, 1, 0)
		
		sleep(5000)
		;Build Altar
		GUICtrlSetData($solotraytip, "Building altar")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("a")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left", $altar_x, $altar_y, 1, 0)
		
		;Open chat
		GUICtrlSetData($solotraytip, "Saying the opening")
		Send("{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		$chat_number = IniRead($dir & "\Config.ini", "Chat Openings", "0", "NotFound")
		$chat = Int(Random($chat_number)+1)
		$var = IniRead($dir & "\Config.ini", "Chat Openings", $chat, "NotFound")
		
		ClipPut ( $var )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		
		sleep(5000)
		;Build Zigg
		GUICtrlSetData($solotraytip, "Build Zigg")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left", $zigg2_x, $zigg2_y, 1, 0)
		
		;Train 2 ghouls
		GUICtrlSetData($solotraytip, "Train 2 ghouls")
		While 1
			mouseclick("left", $crypt_x, $crypt_y, 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 16 , "NotFound")
			$coord = PixelSearch(  820 , 601, 820 , 601 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$hotkey = Chr(51)
			Send("^{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 17 , "NotFound")
			$coord = PixelSearch( 426 , 696, 426 , 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Rally crypt to wood
		GUICtrlSetData($solotraytip, "Rally crypt to wood")
		mouseclick("right", $crypt_rally_x, $crypt_rally_y, 1, 0)
		
		;Upgrade tower
		GUICtrlSetData($solotraytip, "Upgrade tower")
		If $game = 1 Then ExitLoop
		mouseclick("left", $zigg_x, $zigg_y, 1, 0)
		
		While 1
			Send("n")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 18 , "NotFound")
			$coord = PixelSearch( 874, 700, 874, 700, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Scout
		$hotkey = Chr(54)
		Send("{" & $hotkey & "}")
		
		Send("{bs}")
		mouseclick("left", 423, 632, 1, 0)
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("{SHIFTDOWN}")
		
		If $game = 1 Then ExitLoop
		mouseclick("right", $scout_x,$scout_y, 1, 0)
		If $game = 1 Then ExitLoop
		sleep(200)
		
		If $game = 1 Then ExitLoop
		mouseclick("right", $scout2_x,$scout2_y, 1, 0)
		If $game = 1 Then ExitLoop
		sleep(200)
		
		If $game = 1 Then ExitLoop
		mouseclick("right", $scout3_x,$scout3_y, 1, 0)
		If $game = 1 Then ExitLoop
		sleep(200)
		
		mouseclick("right", $crypt_rally_x, $crypt_rally_y, 1, 0)
		Send("{SHIFTUP}")
		If $game = 1 Then ExitLoop
		sleep(5000)
		
		;Build Zigg
		GUICtrlSetData($solotraytip, "Build Zigg")
		While 1
			While 1
				$hotkey = Chr(53)
				Send("{" & $hotkey & "}")
				If $hotkey = "5" Then ExitLoop
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("{bs}")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left", $zigg3_x, $zigg3_y, 1, 0)
		
		;Train DK
		GUICtrlSetData($solotraytip, "Train DK")
		If $game = 1 Then ExitLoop
		mouseclick("left", $altar_x, $altar_y, 1, 0)
		sleep(2000)
		mouseclick("right", $hero_rally_x, $hero_rally_y, 1, 0)
		
		While 1
			$hotkey = Chr(52)
			Send("^{" & $hotkey & "}")
			If $hotkey = "4" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			While 1
				$keyboard_key = "d"
				Send("d")
				If $keyboard_key = "d" Then ExitLoop
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 19 , "NotFound")
			$coord = PixelSearch( 818 , 700, 818 , 700, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Train 2 ghouls
		GUICtrlSetData($solotraytip, "Train 2 ghouls")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 17 , "NotFound")
			$coord = PixelSearch( 426 , 696, 426 , 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Select hero
		GUICtrlSetData($solotraytip, "Selecing hero")
		While 1
			mouseclick("left", 29, 87, 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 20 , "NotFound")
			$coord = PixelSearch( 680, 610, 680, 610 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("oc{bs}")
		If $game = 1 Then ExitLoop
		sleep(1000)
		
		;Rally barracks to hero
		GUICtrlSetData($solotraytip, "Rally barracks to hero")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("right", 29, 87, 1, 0)
		sleep(1000)
		
		;Train 4 ghouls
		GUICtrlSetData($solotraytip, "Train 4 ghouls")
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 21 , "NotFound")
			$coord = PixelSearch(  502, 695, 502, 695, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Build Zigg
		GUICtrlSetData($solotraytip, "Build Zigg")
		While 1
			While 1
				$hotkey = Chr(53)
				Send("{" & $hotkey & "}")
				If $hotkey = "5" Then ExitLoop
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$keyboard_key = "{bs}"
			Send("{bs}")
			If $keyboard_key = "{bs}" Then ExitLoop
			sleep(100)
		WEnd
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		sleep(500)
		mouseclick("left", $zigg4_x, $zigg4_y, 1, 0)
		sleep(500)
		mouseclick("left", $zigg4_x, $zigg4_y, 1, 0)
		
		;Train 3 ghouls
		GUICtrlSetData($solotraytip, "Train 3 ghouls")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 22 , "NotFound")
			$coord = PixelSearch( 463, 696, 463, 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Wait till ghouls finish
		GUICtrlSetData($solotraytip, "Waiting for ghouls")
		$checksum = PixelChecksum(433, 653, 433, 653)
		While $checksum = PixelChecksum(433, 653, 433, 653)
		  Sleep(500)
			If $game = 1 Then ExitLoop
		WEnd
		
		;Select army
		GUICtrlSetData($solotraytip, "Selecting army")
		While 1
			Send("{" & $hotkey_army & "}")
			sleep(200)
			$coord = PixelSearch( 428,695, 428,695, 0x000000 )	
			If @error Then Exitloop
			
			While 1
				$pos = MouseGetPos()
				If $pos[0] = $select_start_x AND $pos[1] = $select_start_y Then ExitLoop
				mousemove($select_start_x,$select_start_y,0)
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			MouseDown( "left" )
			
			While 1
				$pos = MouseGetPos()
				If $pos[0] = $select_finish_x AND $pos[1] = $select_finish_y Then ExitLoop
				mousemove($select_finish_x,$select_finish_y,0)
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			MouseUp( "left" )
			sleep(100)
			Send("+{" & $hotkey_army & "}")
			
			mouseclick("left", 461, 630, 2, 0)
			
			While 1
				$pos = MouseGetPos()
				If $pos[0] = 509 AND $pos[1] = 324 Then ExitLoop
				mousemove(509,324,0)
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			
			Send("{CTRLDOWN}c")
			mouseclick("left")
			Send("{CTRLUP}")
			Send("+{" & $hotkey_army & "}{bs}")
			If $game = 1 Then ExitLoop
		WEnd
		
		;Attack army
		GUICtrlSetData($solotraytip, "Attack army")
		Send("{" & $hotkey_army & "}")
		While 1
			$coord = PixelSearch( 21,560, 190,713, 0xFF0000, 75 )
			If Not @error Then
			mousemove($coord[0],$coord[1],0)
			ExitLoop
			EndIf
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$hotkey = "a"
			Send("a")
			If $hotkey = "a" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left")
		
		;Rally crypt & altar to enemy start location
		GUICtrlSetData($solotraytip, "Rally crypt & altar to enemy start location")
		Send("{" & $hotkey_altar & "}")
		mouseclick("right", $coord[0], $coord[1],1,0)
		Send("{" & $hotkey_crypt & "}")
		mouseclick("right", $coord[0], $coord[1],1,0)
		
		;Train mass ghouls
		GUICtrlSetData($solotraytip, "Train mass ghouls")
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 23 , "NotFound")
			$coord = PixelSearch( 321, 505, 321, 505, "0x" & $color)
			If Not @error Then ExitLoop
			send("g")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		sleep(6000)
		
		;Victory
		While 1
			;micro
			GUICtrlSetData($solotraytip, "Microing")
			Send("{" & $hotkey_army & "}^c")
			sleep(100)
			
			mousemove(1015,59,0)
			If $game = 1 Then ExitLoop
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			If $game = 1 Then ExitLoop
			MouseUp( "left" )
			sleep(100)
			
			Send("+{" & $hotkey_army & "}{" & $hotkey_army & "}")
			While 1
				$coord = PixelSearch( 21,560, 190,713, 0xFF0000, 75 )
				If Not @error Then
					mousemove($coord[0],$coord[1],0)
					ExitLoop
				EndIf
				sleep(100)
				If $game = 1 Then ExitLoop
			WEnd
			If $game = 1 Then ExitLoop
			
			Send("a")
			If $game = 1 Then ExitLoop
			mouseclick("left")
			
			;Checking if hero died
			GUICtrlSetData($solotraytip, "Checking if hero died")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 31 , "NotFound")
			$coord = PixelSearch( 34, 78, 34, 78, "0x" & $color)
			If Not @error Then Send("{" & $hotkey_crypt & "}{ESC}{ESC}{ESC}{" & $hotkey_altar & "}d")
			
			;Looking if gained lvl
			GUICtrlSetData($solotraytip, "Checking if gained lvl")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 24 , "NotFound")
			$coord = PixelSearch( 994, 660, 994, 660 , "0x" & $color)
			If Not @error Then send("ouac")
			
			$coord = PixelSearch( 444, 646, 629, 646, 0x9C8E00, 20 )
			If Not @error Then
				$pos = MouseGetPos()
				send("c")
				$var = PixelGetColor(826,690)
				If Hex($var, 6) = "000000" Then
					mouseclick("left",$coord[0]+8,$coord[1]-15,1,0)
					Send("{" & $hotkey_army & "}")
				EndIf
			EndIf
				
			$coord = PixelSearch( 405, 705, 629, 705, 0x9C8E00, 20 )
			If Not @error Then 
				$pos = MouseGetPos()
				send("c")
				$var = PixelGetColor(826,690)
				If Hex($var, 6) = "000000" Then
					mouseclick("left",$coord[0]+8,$coord[1]-15,1,0)
					Send("{" & $hotkey_army & "}")
				EndIf
			EndIf
			
			;Train mass ghouls
			GUICtrlSetData($solotraytip, "Train mass ghouls")
			Send("{" & $hotkey_crypt & "}")
			If $game = 1 Then ExitLoop
			send("{g 5}")
		WEnd
	WEnd
EndFunc

Func RTBot()
	While 1
		$begin = TimerInit()
		AdlibEnable("RTCheckConditions", 5000)
		
		;ghoul on wood
		GUICtrlSetData($rttraytip, "Putting ghoul on wood")
		sleep(1000)
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			If $game = 1 Then ExitLoop
			mousemove(1015,59,0)
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			MouseUp( "left" )
		WEnd
		
		$color = IniRead($dir & "\Config.ini", "Game Colors", 13 , "NotFound")
		$coord = PixelSearch( 825 , 590, 825 , 590, "0x" & $color)
		If Not @error Then 
			If $game = 1 Then ExitLoop
			mousemove(1015,59,0)
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			MouseUp( "left" )
		EndIf
		
		;Bug fix for for Friends
		$color = IniRead($dir & "\Config.ini", "Game Colors", 38, "NotFound")
		$coord = PixelSearch( 190, 560, 190, 560, "0x" & $color)
		If Not @error Then 
			If $game = 1 Then ExitLoop
			If $white_x = 115 or $white_x = 98 or $white_x = 43 or $white_x = 42 or $white_x = 173 then
				mouseclick("left", $tree_click_x, $tree_click_y, 1, 0)
				$checksum = PixelChecksum(824,590, 824,590)
				While $checksum = PixelChecksum(824,590, 824,590)
					send("g")
					If $game = 1 Then ExitLoop
					sleep(100)
				WEnd
				mouseclick("left", $first_tree_x, $first_tree_y, 1, 0)
				send("{space}")
			EndIf
		Else
			;Bug fix for Full Scale Assault
			$color = IniRead($dir & "\Config.ini", "Game Colors", 39, "NotFound")
			$coord = PixelSearch( 103, 666, 103, 666, "0x" & $color)
			If Not @error Then 
				If $game = 1 Then ExitLoop
				If $white_x = 175 then
					mouseclick("left", $tree_click_x, $tree_click_y, 1, 0)
					$checksum = PixelChecksum(824,590, 824,590)
					While $checksum = PixelChecksum(824,590, 824,590)
						send("g")
						If $game = 1 Then ExitLoop
						sleep(100)
					WEnd
					mouseclick("left", $first_tree_x, $first_tree_y, 1, 0)
					send("{space}")
				EndIf
			Else
				;Normal tree rally
				$checksum = PixelChecksum(824,590, 824,590)
				While $checksum = PixelChecksum(824,590, 824,590)
					send("g")
					If $game = 1 Then ExitLoop
					sleep(100)
				WEnd
				
				$checksum = PixelChecksum(824,590, 824,590)
				While $checksum = PixelChecksum(824,590, 824,590)
					mouseclick("left", $first_tree_x, $first_tree_y, 1, 0)
					If $game = 1 Then ExitLoop
					sleep(100)
				WEnd
			EndIf
		EndIf

		While 1
			$hotkey = Chr(54)
			Send("^{" & $hotkey & "}")
			If $hotkey = "6" Then ExitLoop
			sleep(100)
		WEnd
		
		;Selecting acoyltes
		GUICtrlSetData($rttraytip, "Selecting acoyltes")
		$checksum = PixelChecksum(874,636,874,636)
		While $checksum = PixelChecksum(874,636,874,636)
			Send("{CTRLDOWN}")
			mouseclick("left", 458, 628, 1, 0)
			Send("{CTRLUP}")
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		;Find gold mine
		GUICtrlSetData($rttraytip, "Finding gold mine")
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			send("g")
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			mouseclick("left", $gold_x, $gold_y, 1, 0)
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		;Train 3 acoyltes
		GUICtrlSetData($rttraytip, "Training 3 acoyltes")
		$checksum = PixelChecksum(824,590, 824,590)
		While $checksum = PixelChecksum(824,590, 824,590)
			Send("{bs}")
			mouseclick("left", 516, 300, 1, 0)
			If $game = 1 Then ExitLoop
			sleep(100)
		WEnd
		
		Send("^{" & $hotkey_hall & "}{c 3}{SPACE}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		mouseclick("right", $gold_x, $gold_y, 1, 0)
		If $game = 1 Then ExitLoop
		
		While 1
			mouseclick("left", $acoylte_x, $acoylte_y, 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		mouseclick("left", 423, 630, 1, 0)
		While 1
			$hotkey = Chr(53)
			Send("+{" & $hotkey & "}")
			If $hotkey = "5" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("{bs}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		;Build crypt
		GUICtrlSetData($rttraytip, "Building crypt")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 817, 600, 817, 600, "0x" & $color)
			If Not @error Then ExitLoop
			If $game = 1 Then ExitLoop
			send("c")
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		$crypt = MouseGetPos()
		
		;Open chat
		GUICtrlSetData($rttraytip, "Saying the opening")
		Send("+{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		$chat_number = IniRead($dir & "\Config.ini", "Chat Cheats", "0", "NotFound")
		$chat = Int(Random($chat_number)+1)
		$var = IniRead($dir & "\Config.ini", "Chat Cheats", $chat, "NotFound")
		$var1 = "                                                   "
		
		ClipPut ( $var1 & $var )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		sleep(2500)
		
		;Build Zigg
		GUICtrlSetData($rttraytip, "Build Zigg")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop

		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		$zigg = MouseGetPos()
		
		;Open chat
		GUICtrlSetData($rttraytip, "Talking to ally")
		Send("{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		ClipPut ( "can you scout plz?" )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		
		sleep(5000)
		;Build Altar
		GUICtrlSetData($rttraytip, "Building altar")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("a")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		$altar = MouseGetPos()
		
		;Open chat
		GUICtrlSetData($rttraytip, "Saying the opening")
		Send("+{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		$chat_number = IniRead($dir & "\Config.ini", "Chat Openings", "0", "NotFound")
		$chat = Int(Random($chat_number)+1)
		$var = IniRead($dir & "\Config.ini", "Chat Openings", $chat, "NotFound")
		
		ClipPut ( $var )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		
		sleep(5000)
		;Build Zigg
		GUICtrlSetData($rttraytip, "Build Zigg")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop

		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		
		;Open chat
		GUICtrlSetData($rttraytip, "Talking to ally")
		Send("{enter}")
		If $game = 1 Then ExitLoop
		sleep(100)
		
		ClipPut ( "rush, im getting ghouls" )
		If $game = 1 Then ExitLoop
		sleep(100)
		Send("^V{enter}")
		
		;Train 2 ghouls
		GUICtrlSetData($rttraytip, "Train 2 ghouls")
		While 1
			mouseclick("left", $crypt[0], $crypt[1], 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 16 , "NotFound")
			$coord = PixelSearch(  820 , 601, 820 , 601 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$hotkey = Chr(51)
			Send("^{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 17 , "NotFound")
			$coord = PixelSearch( 426 , 696, 426 , 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Rally crypt to necropolis
		GUICtrlSetData($rttraytip, "Rally crypt to necropolis")
		mouseclick("right", 516, 300, 1, 0)
		
		;Upgrade tower
		GUICtrlSetData($rttraytip, "Upgrade tower")
		If $game = 1 Then ExitLoop
		mouseclick("left", $zigg[0], $zigg[1], 1, 0)
		
		While 1
			Send("n")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 18 , "NotFound")
			$coord = PixelSearch( 874, 700, 874, 700, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop

		;Build Zigg
		GUICtrlSetData($rttraytip, "Build Zigg")
		While 1
			While 1
				$hotkey = Chr(53)
				Send("{" & $hotkey & "}")
				If $hotkey = "5" Then ExitLoop
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("{bs}")
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		
		;Train DK
		GUICtrlSetData($rttraytip, "Train DK")
		If $game = 1 Then ExitLoop
		mouseclick("left", $altar[0], $altar[1], 1, 0)
		sleep(2000)
		
		While 1
			$hotkey = Chr(52)
			Send("^{" & $hotkey & "}")
			If $hotkey = "4" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("d")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 19 , "NotFound")
			$coord = PixelSearch( 818 , 700, 818 , 700, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("right", 516, 300, 1, 0)
		
		;Train 2 ghouls
		GUICtrlSetData($rttraytip, "Train 2 ghouls")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 17 , "NotFound")
			$coord = PixelSearch( 426 , 696, 426 , 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Select hero
		GUICtrlSetData($rttraytip, "Selecing hero")
		While 1
			mouseclick("left", 29, 87, 1, 0)
			$color = IniRead($dir & "\Config.ini", "Game Colors", 20 , "NotFound")
			$coord = PixelSearch( 680, 610, 680, 610 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		Send("oc{bs}")
		Send("+{" & $hotkey_army & "}")
		If $game = 1 Then ExitLoop
		sleep(1000)
		
		;Rally crypt to hero
		GUICtrlSetData($rttraytip, "Rally crypt to hero")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("right", 29, 87, 1, 0)
		sleep(1000)
		
		;Train 4 ghouls
		GUICtrlSetData($rttraytip, "Train 4 ghouls")
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 21 , "NotFound")
			$coord = PixelSearch(  502, 695, 502, 695, "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Build Zigg
		GUICtrlSetData($rttraytip, "Build Zigg")
		While 1
			While 1
				$hotkey = Chr(53)
				Send("{" & $hotkey & "}")
				If $hotkey = "5" Then ExitLoop
				sleep(100)
			WEnd
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 12 , "NotFound")
			$coord = PixelSearch( 882 , 684, 882 , 684 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$keyboard_key = "{bs}"
			Send("{bs}")
			If $keyboard_key = "{bs}" Then ExitLoop
			sleep(100)
		WEnd
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 14 , "NotFound")
			$coord = PixelSearch( 809 , 699, 809 , 699 , "0x" & $color)
			If Not @error Then ExitLoop
			send("b")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
			$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
			If Not @error Then ExitLoop
			send("z")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop

		GUICtrlSetData($setuptip, "Trial and error of building")
		$checksum = PixelChecksum(819,587, 819,587)
		While $checksum = PixelChecksum(819,587, 819,587)
			$x = Int(Random(20,1015))
			$y = Int(Random(55,573))
			sleep(100)
			mouseclick("left", $x, $y, 1, 0)
		WEnd
		
		;Train 3 ghouls
		GUICtrlSetData($rttraytip, "Train 3 ghouls")
		While 1
			$hotkey = Chr(51)
			Send("{" & $hotkey & "}")
			If $hotkey = "3" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		
		While 1
			Send("g")
			If $game = 1 Then ExitLoop
			$color = IniRead($dir & "\Config.ini", "Game Colors", 22 , "NotFound")
			$coord = PixelSearch( 463, 696, 463, 696 , "0x" & $color)
			If Not @error Then ExitLoop
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Wait till ghouls finish
		GUICtrlSetData($rttraytip, "Waiting for ghouls")
		$checksum = PixelChecksum(433, 653, 433, 653)
		While $checksum = PixelChecksum(433, 653, 433, 653)
		  Sleep(500)
			If $game = 1 Then ExitLoop
		WEnd
		
		;Wait till see enemy
		GUICtrlSetData($rttraytip, "Waiting for enemy")
		$zig = 0
		While 1
			$coord = PixelSearch( 21,560, 190,713, 0xFF0000, 75 )
			If Not @error Then
				mousemove($coord[0],$coord[1],0)
				ExitLoop
			Else
				Send("{" & $hotkey_crypt & "}g{" & $hotkey_hall & "}u{" & $hotkey_altar & "}l")
				If $zig = 5 then Exitloop
				
				;Build Zigg
				GUICtrlSetData($rttraytip, "Build Zigg")
				$hotkey = Chr(53)
				Send("{" & $hotkey & "}{BS}bz")
				$color = IniRead($dir & "\Config.ini", "Game Colors", 25 , "NotFound")
				$coord = PixelSearch( 873, 700, 873, 700 , "0x" & $color)
				If Not @error Then
					GUICtrlSetData($setuptip, "Trial and error of building")
					$checksum = PixelChecksum(819,587, 819,587)
					While $checksum = PixelChecksum(819,587, 819,587)
						$x = Int(Random(20,1015))
						$y = Int(Random(55,573))
						sleep(100)
						mouseclick("left", $x, $y, 1, 0)
					WEnd
					$zig = $zig+1
				EndIf			
			EndIf
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		;Select army
		GUICtrlSetData($rttraytip, "Selecting army")
		$hotkey = Chr(54)
		Send("{" & $hotkey & "}")
		mouseclick("left", 421, 629, 1, 0)
		sleep(100)
		mouseclick("right", 516, 300, 1, 0)
		Send("+{" & $hotkey_army & "}")
		
		While 1
			Send("{" & $hotkey_army & "}{BS}")
			sleep(200)
			$coord = PixelSearch( 428,695, 428,695, 0x000000 )	
			If @error Then Exitloop
			mouseclick("left", 460, 629, 1, 0)
			sleep(100)
			mousemove(509,324,0)
			sleep(100)
			Send("{CTRLDOWN}c")
			mouseclick("left")
			Send("{CTRLUP}")
			Send("+{" & $hotkey_army & "}{bs}")
			If $game = 1 Then ExitLoop
		WEnd
		
		;Attack army
		GUICtrlSetData($rttraytip, "Attack army")
		Send("{" & $hotkey_army & "}")
		While 1
			$coord = PixelSearch( 21,560, 190,713, 0xFF0000, 75 )
			If Not @error Then
				mousemove($coord[0],$coord[1],0)
				ExitLoop
			Else
				Send("{" & $hotkey_crypt & "}{g 5}")
			EndIf
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		
		mouseclick("left", $coord[0],$coord[1], 1, 0)
		send("{ALT DOWN}")
		mouseclick("left", 516, 300, 10, 0)
		send("{ALT UP}")
		
		sleep(3000)
		While 1
			$hotkey = "a"
			Send("a")
			If $hotkey = "a" Then ExitLoop
			sleep(100)
		WEnd
		If $game = 1 Then ExitLoop
		mouseclick("left")
		
		;Rally crypt & altar to enemy start location
		GUICtrlSetData($rttraytip, "Rally crypt & altar to enemy start location")
		Send("{" & $hotkey_altar & "}")
		mouseclick("right", $coord[0], $coord[1],1,0)
		Send("{" & $hotkey_crypt & "}")
		mouseclick("right", $coord[0], $coord[1],1,0)
		
		;Train mass ghouls
		GUICtrlSetData($rttraytip, "Train mass ghouls")
		If $game = 1 Then ExitLoop
		
		While 1
			$color = IniRead($dir & "\Config.ini", "Game Colors", 23 , "NotFound")
			$coord = PixelSearch( 321, 505, 321, 505, "0x" & $color)
			If Not @error Then ExitLoop
			send("g")
			sleep(100)
			If $game = 1 Then ExitLoop
		WEnd
		If $game = 1 Then ExitLoop
		sleep(6000)
		
		;Victory
		While 1
			;micro
			GUICtrlSetData($rttraytip, "Microing")
			Send("{" & $hotkey_army & "}^c")
			sleep(100)
			
			mousemove(1015,59,0)
			If $game = 1 Then ExitLoop
			MouseDown( "left" )
			sleep(100)
			mousemove(0,767,0)
			If $game = 1 Then ExitLoop
			MouseUp( "left" )
			sleep(100)
			
			Send("+{" & $hotkey_army & "}{" & $hotkey_army & "}")
			While 1
				$coord = PixelSearch( 21,560, 190,713, 0xFF0000, 75 )
				If Not @error Then
					mousemove($coord[0],$coord[1],0)
					ExitLoop
				EndIf
				sleep(100)
				If $game = 1 Then ExitLoop
			WEnd
			If $game = 1 Then ExitLoop
			
			Send("a")
			If $game = 1 Then ExitLoop
			mouseclick("left")
			
			;Checking if hero died
			GUICtrlSetData($rttraytip, "Checking if hero died")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 31 , "NotFound")
			$coord = PixelSearch( 34, 78, 34, 78, "0x" & $color)
			If Not @error Then Send("{" & $hotkey_crypt & "}{ESC}{ESC}{ESC}{" & $hotkey_altar & "}d")
			
			;Looking if gained lvl
			GUICtrlSetData($rttraytip, "Checking if gained lvl")
			$color = IniRead($dir & "\Config.ini", "Game Colors", 24 , "NotFound")
			$coord = PixelSearch( 994, 660, 994, 660 , "0x" & $color)
			If Not @error Then send("ouac")
			
			$coord = PixelSearch( 444, 646, 629, 646, 0x9C8E00, 20 )
			If Not @error Then
				$pos = MouseGetPos()
				send("c")
				$var = PixelGetColor(826,690)
				If Hex($var, 6) = "000000" Then
					mouseclick("left",$coord[0]+8,$coord[1]-15,1,0)
					Send("{" & $hotkey_army & "}")
				EndIf
			EndIf
				
			$coord = PixelSearch( 405, 705, 629, 705, 0x9C8E00, 20 )
			If Not @error Then 
				$pos = MouseGetPos()
				send("c")
				$var = PixelGetColor(826,690)
				If Hex($var, 6) = "000000" Then
					mouseclick("left",$coord[0]+8,$coord[1]-15,1,0)
					Send("{" & $hotkey_army & "}")
				EndIf
			EndIf
			
			;Train mass ghouls
			GUICtrlSetData($rttraytip, "Train mass ghouls")
			Send("{" & $hotkey_crypt & "}")
			If $game = 1 Then ExitLoop
			send("{g 5}")
		WEnd
	WEnd
EndFunc

Func Terminate()
    Exit 0
EndFunc

Func Won()
	$game = 1
	
	While 1
		mouseclick("left",520,351,1,0)
		$color = IniRead($dir & "\Config.ini", "Game Colors", 27 , "NotFound")
		$coord = PixelSearch( 366, 559, 366, 559 , "0x" & $color)
		If Not @error Then ExitLoop
		sleep(100)
	WEnd
	sleep(5000)
	
	While 1
		$hotkey = "{ENTER}"
		Send("{ENTER}")
		If $hotkey = "{ENTER}" Then ExitLoop
		sleep(100)
	WEnd
	Call("BackUP")
EndFunc

Func Loss()
	$game = 1
	
	While 1
		mouseclick("left",520,332,1,0)
		$color = IniRead($dir & "\Config.ini", "Game Colors", 27 , "NotFound")
		$coord = PixelSearch( 366, 559, 366, 559 , "0x" & $color)
		If Not @error Then ExitLoop
		sleep(100)
	WEnd
	sleep(5000)
	
	While 1
		$hotkey = "{ENTER}"
		Send("{ENTER}")
		If $hotkey = "{ENTER}" Then ExitLoop
		sleep(100)
	WEnd
	Call("BackUP")
EndFunc

Func Quit()
	$game = 1
	
	;Open chat
	GUICtrlSetData($solotraytip, "Saying the Ending")
	GUICtrlSetData($rttraytip, "Saying the Ending")
	$chat_number = IniRead($dir & "\Config.ini", "Chat Endings", "0", "NotFound")
	$chat = Int(Random($chat_number)+1)
	$var = IniRead($dir & "\Config.ini", "Chat Endings", $chat, "NotFound")
	ClipPut ( $var )
	
	mouseclick("left", 516, 300, 1, 0)
	Send("+{enter}^V{enter}")
	sleep(1000)
	
	While 1
		Send("!q!q")
		$color = IniRead($dir & "\Config.ini", "Game Colors", 27 , "NotFound")
		$coord = PixelSearch( 366, 559, 366, 559 , "0x" & $color)
		If Not @error Then ExitLoop
		sleep(500)
	WEnd
	sleep(5000)
	
	While 1
		$hotkey = "{ENTER}"
		Send("{ENTER}")
		If $hotkey = "{ENTER}" Then ExitLoop
		sleep(100)
	WEnd
	Call("BackUP")
EndFunc

Func BackUP()
	$begin = TimerInit()
	GUICtrlSetData ($soloprogressbar, "0")
	GUICtrlSetData ($rtprogressbar, "0")
	sleep(1000)
EndFunc

Func Countdown()
    $i = 0
EndFunc

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
    WEnd
EndFunc

Func SoloCheckConditions()
	;Check to see if won or lost
	$color = IniRead($dir & "\Config.ini", "Game Colors", 9 , "NotFound")
	$won_coord = PixelSearch( 484, 264, 484, 264 , "0x" & $color)
	If Not @error Then 
		Call("Won")
	Else
		$color = IniRead($dir & "\Config.ini", "Game Colors", 10 , "NotFound")
		$loss_coord = PixelSearch( 402, 288, 402, 288 , "0x" & $color)
		If Not @error Then Call("Loss")
	EndIf
	
	;Progress bar
	$dif = TimerDiff($begin)
	If $dif > 960000 then Call("Quit")
	$progressbarvalue = Int($dif/960000*100)
	GUICtrlSetData ($soloprogressbar, $progressbarvalue)
	
	;Player failed to show
	$error_coord = PixelSearch( 366, 337, 366, 337, "0xFF0000")
	If Not @error Then
		send("{ENTER}")
		sleep(2000)
		send("!q")
	EndIf
	
	;They left the game
	$color = IniRead($dir & "\Config.ini", "Game Colors", 32 , "NotFound")
	$white_coord = PixelSearch( 75, 439, 75, 439 , "0x" & $color)
	If Not @error Then Call("Quit")
	
	;Bug fix where it goes to custom game
	$color = IniRead($dir & "\Config.ini", "Game Colors", 33 , "NotFound")
	$white_coord = PixelSearch(839, 711, 839, 711, "0x" & $color)
	If Not @error Then send("!b")
	
	;Bug fix where it clicks teh banner sometimes
	If Not WinActive("Warcraft III") Then
	    WinActivate("Warcraft III")
	    WinWaitActive("Warcraft III")
	EndIf
	
	;Disconnected
	$color = IniRead($dir & "\Config.ini", "Game Colors", 46, "NotFound")
	$white_coord = PixelSearch( 422, 297, 422, 297, "0x" & $color)
	If Not @error Then Call("Loss")
EndFunc

Func RTCheckConditions()
	;Check to see if won or lost
	$color = IniRead($dir & "\Config.ini", "Game Colors", 9 , "NotFound")
	$won_coord = PixelSearch( 484, 264, 484, 264 , "0x" & $color)
	If Not @error Then 
		Call("Won")
	Else
		$color = IniRead($dir & "\Config.ini", "Game Colors", 10 , "NotFound")
		$loss_coord = PixelSearch( 402, 288, 402, 288 , "0x" & $color)
		If Not @error Then Call("Loss")
	EndIf
	
	;Progress bar
	$dif = TimerDiff($begin)
	If $dif > 960000 then Call("Quit")
	$progressbarvalue = Int($dif/1200000*100)
	GUICtrlSetData ($rtprogressbar, $progressbarvalue)
	
	;Player failed to show
	$error_coord = PixelSearch( 366, 337, 366, 337, "0xFF0000")
	If Not @error Then
		send("{ENTER}")
		sleep(2000)
		send("!q")
	EndIf
	
	;Bug fix where it goes to custom game
	$color = IniRead($dir & "\Config.ini", "Game Colors", 33 , "NotFound")
	$white_coord = PixelSearch(839, 711, 839, 711, "0x" & $color)
	If Not @error Then send("!b")
	
	;Bug fix where it clicks teh banner sometimes
	If Not WinActive("Warcraft III") Then
	    WinActivate("Warcraft III")
	    WinWaitActive("Warcraft III")
	EndIf
	
	;Ally left the game
	$color = IniRead($dir & "\Config.ini", "Game Colors", 45, "NotFound")
	$ally_left_coord = PixelSearch( 804, 72, 804, 72, "0x" & $color)
	If Not @error Then 
	sleep(5000)
	Call("Quit")
	EndIf
	
	;Disconnected
	$color = IniRead($dir & "\Config.ini", "Game Colors", 46, "NotFound")
	$white_coord = PixelSearch( 422, 297, 422, 297, "0x" & $color)
	If Not @error Then Call("Loss")
EndFunc

Func Bugged()
	$game = 1
	
	;Open chat
	GUICtrlSetData($solotraytip, "Saying the Ending")
	GUICtrlSetData($rttraytip, "Saying the Ending")
	$chat_number = IniRead($dir & "\Config.ini", "Chat Endings", "0", "NotFound")
	$chat = Int(Random($chat_number)+1)
	$var = IniRead($dir & "\Config.ini", "Chat Endings", $chat, "NotFound")
	ClipPut ( $var )
	
	mouseclick("left", 516, 300, 1, 0)
	Send("{enter}^V{enter}")
	sleep(1000)
	
	While 1
		Send("!q!q")
		$color = IniRead($dir & "\Config.ini", "Game Colors", 27 , "NotFound")
		$coord = PixelSearch( 366, 559, 366, 559 , "0x" & $color)
		If Not @error Then ExitLoop
		sleep(500)
	WEnd
	sleep(3000)
	
	send("s")
	$number = Int(Random(9999)+1)
	sleep(500)
	send("Bugged game " & $number & "{ENTER}")
	sleep(1500)
	
	While 1
		$hotkey = "{ENTER}"
		Send("{ENTER}")
		If $hotkey = "{ENTER}" Then ExitLoop
		sleep(100)
	WEnd
	Call("BackUP")
EndFunc