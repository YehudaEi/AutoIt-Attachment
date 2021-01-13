#include <GUIConstants.au3>
Opt("TrayAutoPause",0)

Global $dir[2],$user32 = DllOpen ( "user32" ),$i,$j,$z,$highscores,$score=0
local $mousepos,$running=0,$head[3][1000],$point[3],$snakelength=10,$place[3],$passed=0,$speed=30,$wallcrash=0,$size=124,$winpos, _
$enemynumber=0,$helper,$enemys[3][1],$xdiff,$ydiff,$this=0,$snakesize=4,$middle

GUICreate("Snake - v1.0",500,536)
$menugame=GUICtrlCreateMenu("Game")
$btnew=GUICtrlCreateMenuitem("New Game",$menugame)
$bthigh=GUICtrlCreateMenuitem("High Scores",$menugame)
$menuset=GUICtrlCreateMenu("Settings")
$btcrash= GUICtrlCreateMenuitem ("Wall crashing",$menuset)
$btsize= GUICtrlCreateMenuitem ("Map size",$menuset)
$btsnakesize= GUICtrlCreateMenuitem ("Snake size",$menuset)
$btenemy= GUICtrlCreateMenuitem ("Enemy",$menuset)
GUICtrlSetState(-1,$GUI_unCHECKED)
$whitelabel=GUICtrlCreateLabel("",0,0,500,500)
GUIctrlSetBkColor(-1,0xffffff)
$statuslabel = GUICtrlCreateLabel("Score: "&$score&"  /  Snake size: "&$snakelength&"  /  Delay: "&$speed,0,500,500,16,BitOr($SS_SIMPLE,$SS_SUNKEN))
GUICtrlSetResizing (-1,$GUI_DOCKBottom+$GUI_DOCKHEIGHT)
GUISetState()

while 1
	$msg=GUIGetMsg()
	Select
	case $msg=-3
		Exit
	case $msg=$btcrash
		if $wallcrash then
			GUICtrlSetState($btcrash,$GUI_unCHECKED)
			$wallcrash=0
		else
			GUICtrlSetState($btcrash,$GUI_CHECKED)
			$wallcrash=1
		endif
	case $msg=$bthigh
		highscore()
	case $msg=$btnew
		GUICtrlDelete($point[2])
		$point[0]=random(0,$size,1)*$snakesize
		$point[1]=random(0,$size,1)*$snakesize
		$point[2]=GUICtrlCreateLabel("",$point[0],$point[1],$snakesize,$snakesize)
		GUICtrlSetBkColor(-1,0xcc0033)
		$running=1
		$score=0
		$j=0
		$z=0
		for $i=1 to $enemynumber
			GUICtrlDelete($enemys[2][$i])
		next
		for $i=1 to $enemynumber
			if ($z*$snakesize*4)>($size*$snakesize) then 
				$j +=1
				$z=0
			endif
			$enemys[0][$i]=$z*random(2,4,1)*$snakesize
			$enemys[1][$i]=$size*$snakesize+$j*$snakesize
			$enemys[2][$i]=GUICtrlCreateLabel("",$enemys[0][$i],$enemys[1][$i],$snakesize,$snakesize)
			GUICtrlSetBkColor(-1,0x458B00)
			$z+=1
		next
		for $i=1 to $snakelength
			GUICtrlDelete($head[2][$i])
		next
		$snakelength=10
		$middle=int(($size*$snakesize)/2)-mod(int(($size*$snakesize)/2),$snakesize)
		for $i=1 to $snakelength
			$head[0][$i]=$middle
			$head[1][$i]=($middle-$snakelength*$snakesize)+$i*$snakesize
			$head[2][$i]=GUICtrlCreateLabel("",$head[0][$i],$head[1][$i],$snakesize,$snakesize)
			GUICtrlSetBkColor(-1,0x000000)
		next
		$place[2]=$snakelength
		$place[1]=$middle-($snakelength-1)*$snakesize
		$place[0]=$middle
		$dir[1]=1
		$dir[0]=0
		GUICtrlSetData($statuslabel,"Score: "&$score&"  /  Snake size: "&$snakelength&"  /  Delay: 30")
	case $running
		Select
		case _IsPressed(25) ;LEFT
			if ($dir[0]<>-1) and ($dir[1]<>0) then
				$dir[1]=0
				$dir[0]=1
			endif
		case _IsPressed(26) ;UP
			if ($dir[0]<>0) and ($dir[1]<>-1) then
				$dir[1]=1
				$dir[0]=0
			endif
		case _IsPressed(27) ;RIGHT
			if ($dir[0]<>1) and ($dir[1]<>0) then
				$dir[1]=0
				$dir[0]=-1
			endif
		case _IsPressed(28) ;DOWN
			if ($dir[0]<>0) and ($dir[1]<>1) then
				$dir[1]=-1
				$dir[0]=0
			endif
		EndSelect
		if ($snakelength < 40) then sleep(40-$snakelength)
		if $place[2] = 0 then $place[2] =$snakelength
		$place[0] -=$snakesize*$dir[0]
		$place[1] -=$snakesize*$dir[1]
		if $wallcrash then
			if ($place[1]=-$snakesize) or ($place[1]=$size*$snakesize+$snakesize) or ($place[0]=-$snakesize) or ($place[0]=$size*$snakesize+$snakesize) then 
				$running=0
				iniscore()
				ContinueLoop
			endif
		else
			select
			case ($place[1]=-$snakesize) and ($passed=0)
				$place[1]=$size*$snakesize
				$passed=1
			case ($place[1]=$size*$snakesize+$snakesize) and ($passed=0)
				$place[1]=0
				$passed=1
			case ($place[0]=-$snakesize) and ($passed=0)
				$place[0]=$size*$snakesize
				$passed=1
			case ($place[0]=$size*$snakesize+$snakesize) and ($passed=0)
				$place[0]=0
				$passed=1
			case else
				$passed=0
			EndSelect
		endif
		if ($place[0]=$point[0]) and ($place[1]=$point[1]) then
			$point[0]=random(0,$size,1)*$snakesize
			$point[1]=random(0,$size,1)*$snakesize
			GUICtrlSetPos($point[2],$point[0],$point[1])
			$snakelength +=1
			$score +=30-(40-$snakelength)
			$head[0][$snakelength]=$place[0]
			$head[1][$snakelength]=$place[1]
			$head[2][$snakelength]=GUICtrlCreateLabel("",$head[0][$snakelength],$head[1][$snakelength],$snakesize,$snakesize)
			GUICtrlSetBkColor(-1,0x000000)
			if ($snakelength >= 40) then 
				$speed="no delay"
			else
				$speed=40-$snakelength
			endif
			GUICtrlSetData($statuslabel,"Score: "&$score&"  /  Snake size: "&$snakelength&"  /  Delay: "&$speed)
		else
			for $i=1 to $snakelength
				for $j=1 to $enemynumber
					if ($enemys[0][$j]=$head[0][$i]) and ($enemys[1][$j]=$head[1][$i]) then 
						$running=0
						iniscore()
						ContinueLoop(3)
					endif
				next
				if ($place[0]=$head[0][$i]) and ($place[1]=$head[1][$i]) then 
					$running=0
					iniscore()
					ContinueLoop(2)
				endif
			next
		endif
		GUICtrlsetpos($head[2][$place[2]],$place[0],$place[1])
		$head[0][$place[2]]=$place[0]
		$head[1][$place[2]]=$place[1]
		$place[2] -=1
		if $enemynumber then
			for $i=1 to $enemynumber
				$xdiff=$place[0]-$enemys[0][$i]
				$ydiff=$place[1]-$enemys[1][$i]
				if $xdiff=0 then $this=2
				if $ydiff=0 then $this=1
				select
				case ($xdiff<0) and $this
					$enemys[0][$i]-=$snakesize
					GUICtrlsetpos($enemys[2][$i],$enemys[0][$i],$enemys[1][$i])
					$this=random(0,1,1)
				case ($xdiff>0) and $this
					$enemys[0][$i]+=$snakesize
					GUICtrlsetpos($enemys[2][$i],$enemys[0][$i],$enemys[1][$i])
					$this=random(0,1,1)
				case $ydiff<0 
					$enemys[1][$i]-=$snakesize
					GUICtrlsetpos($enemys[2][$i],$enemys[0][$i],$enemys[1][$i])
					$this=random(0,1,1)
				case $ydiff>0
					$enemys[1][$i]+=$snakesize
					GUICtrlsetpos($enemys[2][$i],$enemys[0][$i],$enemys[1][$i])
					$this=random(0,1,1)
				EndSelect
			next
		endif
	case $msg=$btsnakesize
		$helper=InputBox("Snake size","Enter the new snake size",$snakesize)
		if (not @error) and number($helper) then
			$snakesize=$helper
			$size=$size-mod($size,$snakesize)
			$winpos=wingetpos("Snake - v1.0")
			WinMove("","",$winpos[0],$winpos[1],$size*$snakesize+6+$snakesize,$size*$snakesize+62+$snakesize)
			GUICtrlSetPos ($whitelabel,0,0,$size*$snakesize+$snakesize,$size*$snakesize+$snakesize)
		endif
	case $msg=$btenemy
		for $i=1 to $enemynumber
			GUICtrlDelete($enemys[2][$i])
		next
		$enemynumber=number(InputBox("Number of Enemys","Write in how many enemys do you want to hunt you.",$enemynumber))
		dim $enemys[3][$enemynumber+1]
	case $msg=$btsize
		$helper=InputBox("New map size","Add a new mapsize for your game (it will be multiplied by "&$snakesize&").",$size)
		if (not @error) and number($helper) then
			$size=$helper-mod($helper,$snakesize)
			$winpos=wingetpos("Snake - v1.0")
			WinMove("","",$winpos[0],$winpos[1],$size*$snakesize+6+$snakesize,$size*$snakesize+62+$snakesize)
			GUICtrlSetPos ($whitelabel,0,0,$size*$snakesize+$snakesize,$size*$snakesize+$snakesize)
		endif
	EndSelect
WEnd

func iniscore()
	local $name
	if FileExists("stats.ini") then
		for $i=1 to 10
			if Iniread("stats.ini","score",$i,"0") < $score then
				$name=InputBox("High Score","You have made a new high score: "&$i&". place. Please, enter your name.","player")
				if not @error then
					for $j=10 to $i+1 step -1
						IniWrite("stats.ini","score",$j,Iniread("stats.ini","score",$j-1,"0"))
						IniWrite("stats.ini","name",$j,Iniread("stats.ini","name",$j-1,"-"))
					next
					IniWrite("stats.ini","name",$i,$name)
					IniWrite("stats.ini","score",$i,$score)
					highscore()
				endif
				exitloop
			EndIf
		next
	else
		$name=InputBox("High Score","You have made a new high score: 1. place. Please, enter your name.","player")
		if not @error then
			for $i=1 to 10 
				IniWrite("stats.ini","score",$i,"0")
				IniWrite("stats.ini","name",$i,"-")
			Next
			IniWrite("stats.ini","name",1,$name)
			IniWrite("stats.ini","score",1,$score)
		endif
	endif
endfunc

func highscore()
	if FileExists("stats.ini") then
		$highscores=""
		for $i=1 to 10
			$highscores &=$i&". "&Iniread("stats.ini","name",$i,"0")&"  "&Iniread("stats.ini","score",$i,"0")&@CRLF
		next
		msgbox(0,"High Scores",$highscores)
	endif
EndFunc

Func _IsPressed($s_hexKey)
	Local $a_R = DllCall($user32, "int", "GetAsyncKeyState", "int", '0x' & $s_hexKey)
	If Not @error And BitAND($a_R[0], 0x8000) = 0x8000 Then Return 1
	Return 0
EndFunc   