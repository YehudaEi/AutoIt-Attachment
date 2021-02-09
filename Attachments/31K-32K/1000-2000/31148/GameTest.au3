HotKeySet("{ESC}", "Terminate")
Func Terminate()
	Exit 0
EndFunc

#include <GUIConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>
#include <StaticConstants.au3>

global $rand, $yes, $count = 0, $startbutton, $highscore, $time, $hsmsg, $clr = 0, $player, $namebutton, $name
dim $button[100], $hrs[5][5]

hotkeyset("{f1}", "showhighscore")

hsfilecheck()
startup()

while 1
	$start = guigetmsg()
	select
		case $start = $GUI_EVENT_CLOSE
			exit 0
		case $start = $startbutton
			cleartxt()
			startgame()
		case $count = 10
			$count = 0
			GUICtrlSetState($startbutton, $GUI_ENABLE)
	endselect
wend

func showhighscore()
	cleartxt()
	highscore()
endfunc

func setname()
	$name = guictrlread($namebutton)
endfunc

func hsfilecheck()
	$inicheck = inireadsection(@scriptdir & "\" & "highscores.ini", "highscores")
	if @error Then
		iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top1", "6")
		iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top2", "8")
		iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top3", "10")
		iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name1", "default1")
		iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name2", "default2")
		iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name3", "default3")
	endif
endfunc

func cleartxt()
	guictrlsetdata($highscore, "")
endfunc

func score($time)
	setname()
	$hrs = inireadsection(@scriptdir & "\" & "highscores.ini", "highscores")
	$pr = inireadsection(@scriptdir & "\" & "highscores.ini", "players")
	$time = round($time/1000, 2)
	
		select
			case $time < $hrs[1][1]
				$hsmsg = "You beat " & $pr[1][1] & "'s score by " & round(($hrs[1][1])-($time),2) & "s"
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top1", $time)
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top2", $hrs[1][1])
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top3", $hrs[2][1])
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name1", $name)
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name2", $pr[1][1])
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name3", $pr[2][1])
			case $time < $hrs[2][1]
				$hsmsg = "You beat " & $pr[2][1] & "'s score by " & round(($hrs[2][1])-($time),2) & "s"
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top2", $time)
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top3", $hrs[2][1])
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name2", $name)
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name3", $pr[2][1])
			case $time < $hrs[3][1]
				$hsmsg = "You beat " & $pr[3][1] & "'s score by " & round(($hrs[3][1])-($time),2) & "s"
				iniwrite(@scriptdir & "\" & "highscores.ini", "highscores", "Top3", $time)
				iniwrite(@scriptdir & "\" & "highscores.ini", "players", "Name3", $name)
			case else
				$hsmsg = "No highscore!"
		endselect
		
	GUICtrlSetData($highscore, @crlf & "-------------------------------------------" & @crlf, 1)
	GUICtrlSetData($highscore, "Player name: " & $name & @crlf, 1)
	GUICtrlSetData($highscore, "Your score: " & $time & "s" & @crlf, 1)
	GUICtrlSetData($highscore, $hsmsg & @crlf, 1)
	
	highscore()
endfunc

func highscore()
	$hrs = inireadsection(@scriptdir & "\" & "highscores.ini", "highscores")
	$pr = inireadsection(@scriptdir & "\" & "highscores.ini", "players")
	
	GUICtrlSetData($highscore, "-------------------------------------------" & @crlf, 1)
	GUICtrlSetData($highscore, "Highscores:" & @crlf, 1)
	GUICtrlSetData($highscore, $pr[1][1] & " at " & $hrs[1][1] & "s" & @crlf, 1)
	GUICtrlSetData($highscore, $pr[2][1] & " at " & $hrs[2][1] & "s" & @crlf, 1)
	GUICtrlSetData($highscore, $pr[3][1] & " at " & $hrs[3][1] & "s" & @crlf, 1)
	GUICtrlSetData($highscore, "-------------------------------------------" & @crlf, 1)
endfunc

func startgame()
	GUICtrlSetState($startbutton, $GUI_DISABLE)
	GUICtrlSetData($highscore, "Starting in..." & @crlf, 1)
	for $s = 3 to 1 step -1
		GUICtrlSetData($highscore, $s & "..." & @crlf, 1)
		sleep(1000)
	next
	GUICtrlSetData($highscore, "GO!" & @crlf, 1)
	$timer = timerinit()
	do
		activate()
		$count += 1
	until $count = 10
	score(timerdiff($timer))
endfunc

func activate()
	$rand = random(0, 89)
	GUICtrlSetState($button[$rand], $GUI_enable)
	guictrlsetbkcolor($button[$rand], 0x000000)
	do
		nextbutton(guigetmsg())
	until $yes = 1
	GUICtrlSetState($button[$rand], $GUI_DISABLE)
	guictrlsetbkcolor($button[$rand], 0xEDEDED)
endfunc

func nextbutton($clicked)
	$yes = 0
	select
		case $clicked = $button[$rand]
			$yes = 1
	endselect
endfunc

func startup()
local $y = 1, $o = 0, $row = 9
guicreate("Click it!", 676,451, -1, -1)
	$startbutton = guictrlcreatebutton("Start", 501, 1, 175, 35)
	$namebutton = guictrlcreateinput("Put your name here.", 502, 37, 175, 20)
	$highscore = guictrlcreateedit("", 501, 59, 175, 450, $ES_AUTOVSCROLL & $ES_AUTOHSCROLL & $ES_CENTER)
	guictrlsetbkcolor($highscore, 0xEDEDED)
	
	GUICtrlSetData($highscore, "Version 1.1 Clickit!" & @crlf & _
	 "Click start to play!" & @crlf & _
	 @crlf & @crlf & "Hotkeys: " & @crlf & _
	 "Press ESC to exit" & @crlf & _
	 "Press F1 for highscores" & @crlf, 1)
GUISetState (@SW_SHOW)
for $i = 0 to 89
	$button[$i] = guictrlcreatebutton("",$o*50,$y,50,50,$WS_DISABLED)
	guictrlsetbkcolor($button[$i], 0xEDEDED)
	$o += 1
	if ($i = $row) then
		$o = 0
		$row += 10
		$y += 50
	endif
next
endfunc