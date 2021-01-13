#include <GUIConstants.au3>
#include <File.au3>

local $figures[8][8],$gfx[8][8],$figuresum=0

GUICreate("8 queens - by bonebreaker",399,450)
GUICtrlCreateGraphic(0,0,400,400)
GUICtrlSetBkColor(-1,0x000000)
$reset=GUICtrlCreateButton("Reset",10,410,80,30)
GUICtrlCreateLabel("Time:",110,420)
$timerlabel=guictrlcreatelabel("0",140,420,100)
guictrlcreatelabel("Place 8 queens on the table without"& @CRLF &" making them able to hit each other.",200,410)
for $i=0 to 7
	for $j=0 to 7
		$gfx[$i][$j]=GUICtrlCreateGraphic($j*50,$i*50,49,49)
		GUICtrlSetBkColor(-1,0xffffff)
		$figures[$i][$j]=0
	next
next
$timesum=1
$timer=TimerInit()
GUISetState()

while 1
	$msg=GUIGetMsg()
	Select
	case (TimerDiff($timer) > $timesum*1000)
		GUICtrlSetData($timerlabel,$timesum)
		$timesum +=1
	case $msg=-3
		exit
	case $msg=$reset
		for $i=0 to 7
			for $j=0 to 7
				if $figures[$i][$j] then
				GUICtrlDelete($gfx[$i][$j])
				$gfx[$i][$j]=GUICtrlCreateGraphic($j*50,$i*50,49,49)
				GUICtrlSetBkColor(-1,0xffffff)
				$figures[$i][$j]=0
				endif
			next
		next
		$figuresum=0
	case $msg=$GUI_EVENT_PRIMARYDOWN
		$mousepos=GUIGetCursorInfo()
		$y=int($mousepos[1]/50)
		$x=int($mousepos[0]/50)
		if ($y<8) and ($x<8) then
			for $i=0 to 7
				if $figures[$i][$x] and ($i<>$y) then
					GUICtrlDelete($gfx[$i][$x])
					$gfx[$i][$x]=GUICtrlCreateGraphic($x*50,$i*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$i][$x],$GUI_GR_REFRESH)
					$figures[$i][$x]=0
					$figuresum -=1
					exitloop
				endif
			next
			for $i=0 to 7
				if $figures[$y][$i] and ($i<>$x) then
					GUICtrlDelete($gfx[$y][$i])
					$gfx[$y][$i]=GUICtrlCreateGraphic($i*50,$y*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$y][$i],$GUI_GR_REFRESH)
					$figures[$y][$i]=0
					$figuresum -=1
					ExitLoop
				endif
			next
			$i=1
			while (($y-$i)<>-1) and (($x-$i)<>-1)
				if $figures[$y-$i][$x-$i] then
					GUICtrlDelete($gfx[$y-$i][$x-$i])
					$gfx[$y-$i][$x-$i]=GUICtrlCreateGraphic(($x-$i)*50,($y-$i)*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$y-$i][$x-$i],$GUI_GR_REFRESH)
					$figures[$y-$i][$x-$i]=0
					$figuresum -=1
					ExitLoop
				endif
				$i +=1
			wend
			$i=-1
			while (($y-$i)<>8) and (($x-$i)<>8)
				if $figures[$y-$i][$x-$i] then
					GUICtrlDelete($gfx[$y-$i][$x-$i])
					$gfx[$y-$i][$x-$i]=GUICtrlCreateGraphic(($x-$i)*50,($y-$i)*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$y-$i][$x-$i],$GUI_GR_REFRESH)
					$figures[$y-$i][$x-$i]=0
					$figuresum -=1
					ExitLoop
				endif
				$i -=1
			wend
			$i=1
			while (($y+$i)<>8) and (($x-$i)<>-1)
				if $figures[$y+$i][$x-$i] then
					GUICtrlDelete($gfx[$y+$i][$x-$i])
					$gfx[$y+$i][$x-$i]=GUICtrlCreateGraphic(($x-$i)*50,($y+$i)*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$y+$i][$x-$i],$GUI_GR_REFRESH)
					$figures[$y+$i][$x-$i]=0
					$figuresum -=1
					ExitLoop
				endif
				$i +=1
			wend
			$i=-1
			while (($y+$i)<>-1) and (($x-$i)<>8)
				if $figures[$y+$i][$x-$i] then
					GUICtrlDelete($gfx[$y+$i][$x-$i])
					$gfx[$y+$i][$x-$i]=GUICtrlCreateGraphic(($x-$i)*50,($y+$i)*50,49,49)
					GUICtrlSetBkColor(-1,0xffffff)
					GUICtrlSetGraphic($gfx[$y+$i][$x-$i],$GUI_GR_REFRESH)
					$figures[$y+$i][$x-$i]=0
					$figuresum -=1
					ExitLoop
				endif
				$i -=1
			wend
			GUICtrlDelete($gfx[$y][$x])
			$gfx[$y][$x]=GUICtrlCreateGraphic($x*50,$y*50,49,49)
			GUICtrlSetBkColor(-1,0xffffff)
			GUICtrlSetGraphic($gfx[$y][$x],$GUI_GR_COLOR,0xffffff,0x000000)
			GUICtrlSetGraphic($gfx[$y][$x],$GUI_GR_ELLIPSE,10,10,30,30)
			GUICtrlSetGraphic($gfx[$y][$x],$GUI_GR_REFRESH)
			if $figures[$y][$x]=0 then
				$figures[$y][$x]=1
				$figuresum +=1
			endif
			if $figuresum=8 then
				$file=fileopen("solutions.txt",1)
				$size=_FileCountLines("solutions.txt")
				$string=""
				$write=1
				for $i=0 to 7
					for $j=0 to 7
						$string=$string&$figures[$i][$j]
					next
				next
				if $size <> 0 then
					for $i=1 to $size
						if FileReadLine("solutions.txt",$i)=$string then
							$write=0
							exitloop
						endif
					next
					if $write then
						FileWriteline($file,$string)
						msgbox(0,"Winner","Congratulations, you have won the game in "&$timesum&" seconds. "&$size+1&" solutions so far.")
						$timesum=1
						$timer=TimerInit()
					else
						msgbox(0,"Winner","This is not a new solution, sorry.")
					endif
				else
					FileWriteline($file,$string)
					msgbox(0,"Winner","Congratulations, you have won the game in "&$timesum&" seconds. 1 solution so far.")
					$timesum=1
					$timer=TimerInit()
				endif
				fileclose($file)
			endif
		endif
	EndSelect
wend