#cs
 /~~~~~~~~~~~~~~~~~~~~~~\
 |    Test Yourself!    |
 |       By Haavy       |
 |     - AutoIt 3 -     |
 \~~~~~~~~~~~~~~~~~~~~~~/
#ce

Global $react_started, $speed_started, $click_speed_started, $checkbox[151], $tab[6], $checked, $clicks, $highscore[4][3], $new_highscore
HotKeySet("{Space}", "AntiCheat")
HotKeySet("{Enter}", "AntiCheat")
$highscore[1][1] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Reaction Test", "Highscore", 3)
$highscore[1][2] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Reaction Test", "Date", @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN)
$highscore[2][1] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Speed Test", "Highscore", 0)
$highscore[2][2] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Speed Test", "Date", @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN)
$highscore[3][1] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Click Speed Test", "Highscore", 100)
$highscore[3][2] = IniRead(@ScriptDir & "\TestYourselfHighScores.ini", "Click Speed Test", "Date", @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN)
$window = GUICreate("Test Yourself!", 292, 286)
GUISetState(@SW_SHOW)
GuiCtrlCreateTab(2, 1, 290, 285)

$tab[1] = GuiCtrlCreateTabItem("Reaction")
	$color_field = GUICtrlCreateGraphic(96, 30, 100, 100)
	GUICtrlSetBkColor(-1, 0xffffff)
	GUICtrlSetColor (-1, 0x000000)
	GUICtrlSetState(-1, 2048)
	$react_click = GUICtrlCreateButton("Start", 122, 150, 50, 30)
	GUICtrlCreateLabel("Hit 'Start' to start. When the white box turns red and you", 13, 185) 
	GUICtrlCreateLabel("hear a beep, click the button again as fast as possible.", 13, 195) 

$tab[2] = GuiCtrlCreateTabItem("Mouse Speed")
	$left = -5
	$top = 35
	for $i = 1 to 150 
		$left = $left + 18
		$checkbox[$i] = GuiCtrlCreateCheckbox("", $left, $top, 13, 13)
		if mod($i,15) = 0 then
			$top = $top + 18
			$left = -5
		endif
	next
	$speed_click = GUICtrlCreateButton("Reset", 238, 220, 50, 30)
	GUICtrlCreateLabel("To start, check any of the boxes above.", 13, 220) 
	GUICtrlCreateLabel("Then, check the rest as fast as possible.", 13, 230) 
	GUICtrlCreateLabel("Time left:", 5, 255) 
	$speed_timelabel = GUICtrlCreateLabel("30 sec", 5, 267) 
	$speed_timebar = GUICtrlCreateProgress(50, 258, 237, 22)
	GUICtrlSetData(-1, 100)

$tab[3] = GuiCtrlCreateTabItem("Click Speed")
	$click_speed_click = GUICtrlCreateButton("Click me!", 110, 50, 74, 74)
	GUICtrlCreateLabel("This one is about clicking this button a hundred times as", 13, 150) 
	GUICtrlCreateLabel("fast as possible. To start, just click it.", 13, 161) 
	GUICtrlCreateLabel("Clicks done:", 110, 205) 
	$click_speed_timelabel = GUICtrlCreateLabel("0", 170, 205) 
	$click_speed_timebar = GUICtrlCreateProgress(20, 180, 250, 22)

$tab[4] = GuiCtrlCreateTabItem("Highscores")
	$stats_edit = GUICtrlCreateEdit("", 20, 50, 250, 60, 0x0400)
	$stats_click = GUICtrlCreateButton("Copy to clipboard", 96, 115, 100, 30)
	GUICtrlCreateLabel("Date format: DD/MM/YYYY", 80, 150)
	GUICtrlCreateLabel("Test Yourself AutoIt3 script by Haavy", 110, 268)
	UpdateScores()

GuiCtrlCreateTabItem("")
GUICtrlSetState($tab[1],16)

while $window
	$msg = GUIGetMsg()
	select
		case $msg = -3
			if $new_highscore = true then
				$save = MsgBox(36, "Save highscores?", "Do you want to save your highscores?")
				if $save = 7 then
					Exit
				else
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Reaction Test", "Highscore", $highscore[1][1])
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Reaction Test", "Date", $highscore[1][2])
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Speed Test", "Highscore", $highscore[2][1])
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Speed Test", "Date", $highscore[2][2])
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Click Speed Test", "Highscore", $highscore[3][1])
					IniWrite(@ScriptDir & "\TestYourselfHighScores.ini", "Click Speed Test", "Date", $highscore[3][2])
					MsgBox(64, "Done!", "Highscores saved to " & @ScriptDir & "\TestYourselfHighScores.ini")
					Exit
				endif
			else
				Exit
			endif
		case $msg = $react_click
			if $react_started = false then
				GUICtrlSetData($react_click, "Click")
				Sleep(Random(500, 10000))
				$init_time = TimerInit()
				GUICtrlSetBkColor($color_field, 0xff0000)
				Beep(1000, 150)
				$react_started = true
			elseif $react_started = true then
				$time = Round(TimerDiff($init_time)/1000, 3)
				MsgBox(64,"Your Time","You pressed the button after " & $time & " seconds.")
				if $time < $highscore[1][1] then
					MsgBox(64, "New highscore: " & $time & " seconds", "New highscore! You improved your last score by " & $highscore[1][1]-$time & " seconds. Good job :D")
					$highscore[1][1] = $time
					$highscore[1][2] = @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN
					$new_highscore = true
					UpdateScores()
				endif
				GUICtrlSetBkColor($Color_Field, 0xffffff)
				GUICtrlSetData($react_click, "Start")
				$react_started = false
			endif
		case $msg = $speed_click
			$speed_started = false
			$checked = 0
			for $m = 1 to 150
				GUICtrlSetState($checkbox[$m], 4)
			next
			GUICtrlSetData($speed_timebar, 100)
			GUICtrlSetData($speed_timelabel, "30 sec")
		case $msg = $click_speed_click
			$clicks += 1
			if $click_speed_started = false and $react_started = false then
				$init_time = TimerInit()
				$click_speed_started = true
			endif
			GUICtrlSetData($click_speed_timebar, $clicks)
			GUICtrlSetData($click_speed_timelabel, $clicks)
			if $clicks = 100 then
				$time = Round(TimerDiff($init_time)/1000)
				MsgBox(64, "Your Time", "You pressed the button 100 times in " & $time & " seconds. That's " & Round(100/$time, 3) & " clicks per second!")
				if $time < $highscore[3][1] then
					MsgBox(64, "New highscore: " & $time & " seconds", "New highscore! You improved your last score by " & $highscore[3][1]-$time & " seconds. Good job :D")
					$highscore[3][1] = $time
					$highscore[3][2] = @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN
					$new_highscore = true
					UpdateScores()
				endif
				GUICtrlSetData($click_speed_timebar, 0)
				GUICtrlSetData($click_speed_timelabel, "0")
				$clicks = 0
				$click_speed_started = false
			endif
		case $msg = $stats_click
			ClipPut ("Test Yourself! highscores:" & @CRLF & "Reaction: " & $highscore[1] & " seconds" & @CRLF & "Mouse Speed: " & $highscore[2] & " boxes" & @CRLF & "Click Speed: " & $highscore[3] & " seconds" & @CRLF & @CRLF & "Test yourself! Autoit v3 Script by Haavy")
			MsgBox(64, "Success", "Highscores copied to clipboard, use CTRL+V to paste them somewhere.")
	endselect
	for $j = 1 to 150
		if $msg = $checkbox[$j] then
			if $speed_started = false then
				$speed_started = true
				for $k = 30 to 0 step -1
					GUICtrlSetData($speed_timebar, $k*100/30)
					GUICtrlSetData($speed_timelabel, $k & " sec")
					Sleep(1000)
				next
				for $l = 1 to 150
					if GUICtrlRead($checkbox[$l]) = 1 then
						$checked += 1
					endif
				next
				MsgBox(64, "Results", "You checked " & $checked & " boxes. That's " & Round($checked/30, 3) & " boxes per second!")
				if $checked > $highscore[2][1] then
					MsgBox(64, "New highscore: " & $checked & " boxes", "New highscore! You improved your last score by " & $checked-$highscore[2][1] & " boxes. Good job :D")
					$highscore[2][1] = $checked
					$highscore[2][2] = @MDAY & "/" & @MON & " - " & @YEAR & " " & @HOUR & ":" & @MIN
					$new_highscore = true	
					UpdateScores()
				endif
			endif
		endif
	next
wend
func AntiCheat()
	MsgBox(64, "Enter/Space Pressed", "You pressed enter or space. Don't cheat :)")
endfunc
func UpdateScores()
	GUICtrlSetData($stats_edit, "Test Yourself! highscores:" & @CRLF & "Reaction: " & $highscore[1][1] & " seconds - " & $highscore[1][2] & @CRLF & "Mouse Speed: " & $highscore[2][1] & " boxes - " & $highscore[2][2] & @CRLF & "Click Speed: " & $highscore[3][1] & " seconds - " & $highscore[3][2])
endfunc