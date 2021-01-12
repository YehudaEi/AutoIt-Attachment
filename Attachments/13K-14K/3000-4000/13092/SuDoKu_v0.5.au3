#include <GUIConstants.au3>
global $number[10][10],$solve[10][10],$number2[10][10],$helper[10],$stopitnow=0,$difficulty=0,$GUI_hwnd, $GUIMsg,$numbutton[10]

guicreate("sudoku - by bonebreaker - v0.5",335,360)
$addsudoku=guictrlcreatebutton("Save",14,290,67,30)
$testsudoku=guictrlcreatebutton("Check",82,290,67,30)
$generatesudoku=guictrlcreatebutton("Generate",150,290,67,30)
$customsudoku=guictrlcreatebutton("Add",218,290,67,30)
$loadsudoku=guictrlcreatebutton("Load",14,321,67,30)
$downloadsudoku=guictrlcreatebutton("Clear",82,321,67,30)
$infosudoku=guictrlcreatebutton("Solve",150,321,67,30)
$informations=guictrlcreatebutton("Info",218,321,67,30)
$erasebutton=guictrlcreatebutton("-",295,290,30,61)
for $i=1 to 9
	$numbutton[$i]=guictrlcreatebutton($i,295,$i*30-16,30,30)
next
for $i=1 to 9
	$helper[$i]=0
	for $j=1 to 9
		$number[$i][$j]=guictrlcreateinput("",($i*30)-15,($j*30)-16,29,29, BitOR($ES_CENTER, $ES_NUMBER),0)
		GUICtrlSetFont(-1, 14, default, 1)
		GUICtrlSetbkColor(-1,0xebebeb)
		GUICtrlSetCursor(-1,2)
	next
next
for $i=1 to 9
	for $j=1 to 9
		GUICtrlCreateGraphic((30*$i-15),(30*$j-16),30,30)
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0xb6b6b6)
		GUICtrlSetGraphic(-1, $GUI_GR_RECT, -1,-1,30,30)
		guictrlsetgraphic(-1,$GUI_GR_CLOSE)
	Next
next
for $i= 1 to 3
	for $j=1 to 3
		GUICtrlCreateGraphic(15+(90*$i-90),15+(90*$j-91),91,91)
		GUICtrlSetGraphic(-1, $GUI_GR_COLOR, 0x000000)
		GUICtrlSetGraphic(-1, $GUI_GR_RECT, -1, -1,91,91)
		guictrlsetgraphic(-1,$GUI_GR_CLOSE)
	next
next
guisetstate(@SW_SHOW)

func solve()
	local $voltmar=9,$vissza_i=1,$egyszer=1,$probalkozik=0,$repeat=1,$boxposj=0,$alj=0,$szamok[10],$boxposi=0
	for $i=1 to 9
		for $j=1 to 9
			$solve[$i][$j] = guictrlread($number[$i][$j])
		Next
	next
	while $voltmar=9
		if $stopitnow =0 then
			$probalkozik=$probalkozik+1
			$egyszer=1
			$voltmar=0
			for $bb=1 to 9
				$szamok[$bb]=0
			next
			for $i=$vissza_i to 9
				for $j=1 to 9
					if $solve[$i][$j] = "" then
						guictrlsetdata($number[$i][$j],"")
					endif
				Next
			next
			for $i=$vissza_i to 9
				for $j=1 to 9
					if guictrlread($number[$i][$j])= "" then
						while $repeat=1
							$randi=random(1,9,1)
							for $nezi=1 to 9
								if ($szamok[$nezi]>0) then
									$voltmar=$voltmar+1
								endif
							next
							if $voltmar=9 then
								if $egyszer=1 then
									$vissza_i=$i
									$egyszer=0
								endif
								if $probalkozik=1 then
									$vissza_i=$vissza_i-1
									$probalkozik=0
								endif
								exitloop(3)
							endif
							$voltmar=0
							for $z=1 to 9
								if (guictrlread($number[$i][$z])=$randi) or (guictrlread($number[$z][$j])=$randi) Then
									$alj=1
									exitloop(1)
								else
									$alj=0
								endif
							next
							if $alj=0 then
								$boxposj=$j
								while $boxposj-3 > 0
									$boxposj=$boxposj-3
								wend
								$boxposi=$i
								while $boxposi-3 > 0
									$boxposi=$boxposi-3
								wend
								for $z=$i-$boxposi+1 to $i-$boxposi+3
									for $p=$j-$boxposj+1 to $j-$boxposj+3
										if guictrlread($number[$z][$p])=$randi then
											$repeat=1
											exitloop(2)
										else
											$repeat=0
										endif
									Next
								next
							endif
							$szamok[$randi]=$szamok[$randi]+1
						wend
						$repeat=1
						for $bb=1 to 9
							$szamok[$bb]=0
						next
						guictrlsetdata($number[$i][$j],$randi)
					endif
				Next
			next
		else
			exitloop(1)
		endif
	wend
endfunc

func generate()
	local $voltmar=9,$vissza_i=1,$egyszer=1,$probalkozik=0,$repeat=1,$boxposj=0,$alj=0,$szamok[10],$boxposi=0
	while $voltmar=9
		if $stopitnow =0 then
			$probalkozik=$probalkozik+1
			$egyszer=1
			$voltmar=0
			for $bb=1 to 9
				$szamok[$bb]=0
			next
			for $i=$vissza_i to 9
				for $j=1 to 9
					$number2[$i][$j]=""
				Next
			next
			for $i=$vissza_i to 9
				for $j=1 to 9
					while $repeat=1
						$randi=random(1,9,1)
						for $nezi=1 to 9
							if ($szamok[$nezi]>0) then
								$voltmar=$voltmar+1
							endif
						next
						if $voltmar=9 then
							if $egyszer=1 then
								$vissza_i=$i
								$egyszer=0
							endif
							if $probalkozik=10 then
								$vissza_i=$vissza_i-1
								$probalkozik=0
							endif
							exitloop(3)
						endif
						$voltmar=0
						for $z=1 to 9
							if  ($number2[$i][$z]=$randi) or ($number2[$z][$j]=$randi) Then
								$alj=1
								exitloop(1)
							else
								$alj=0
							endif
						next
						if $alj=0 then
							$boxposj=$j
							while $boxposj-3 > 0
								$boxposj=$boxposj-3
							wend
							$boxposi=$i
							while $boxposi-3 > 0
								$boxposi=$boxposi-3
							wend
							for $z=$i-$boxposi+1 to $i-$boxposi+3
								for $p=$j-$boxposj+1 to $j-$boxposj+3
									if $number2[$z][$p]=$randi then
										$repeat=1
										exitloop(2)
									else
										$repeat=0
									endif
								Next
							next
						endif
						$szamok[$randi]=$szamok[$randi]+1
					wend
					$repeat=1
					for $bb=1 to 9
						$szamok[$bb]=0
					next
					$number2[$i][$j]=$randi
				Next
			next
		else
			exitloop(1)
		endif
	wend
	if $stopitnow=0 then
		select
			case $difficulty=1
				for $z=1 to 3
					for $j=1 to 5
						do
							$sim1=random(1,5,1)
						until $number2[$sim1][$j]) <> ""
						$number2[$sim1][$j]=""
						$number2[10-$sim1][$j]=""
						$number2[$sim1][10-$j]=""
						$number2[10-$sim1][10-$j]=""
					next
				next
			case $difficulty=2
				for $z=1 to 3
					for $j=1 to 9
						do
							$sim1=random(1,5,1)
						until $number2[$sim1][$j] <> ""
						$number2[$sim1][$j]=""
						$number2[10-$sim1][10-$j]=""
					Next
				Next
			case $difficulty=3
				for $z=1 to 4
					for $j=1 to 9
						do
							$sim1=random(1,5,1)
						until $number2[$sim1][$j] <> ""
						$number2[$sim1][$j]=""
						$number2[10-$sim1][10-$j]=""
					Next
				Next
		EndSelect
		for $i=1 to 9
			for $j=1 to 9
				if $number2[$i][$j] <> "" then
					guictrlsetstate($number[$i][$j],$GUI_DISABLE)
				endif
			next
		next
	endif
endfunc

func check()
	local $mistake=0
	local $wrong=0
	tooltip("checking boxes")
	sleep(1000)
	for $z=1 to 3
		for $g=1 to 3
			for $i=($z*3)-2 to $z*3
				for $j=($g*3)-2 to $g*3
					if (guictrlread($number[$i][$j]) > 0) then
						$helper[guictrlread($number[$i][$j])]=$helper[guictrlread($number[$i][$j])]+1
					else
						tooltip("Wrong number input(0..9) at line: "& $j &" column: " & $i)
						$wrong=1
						sleep(1000)
						exitloop(4)
					endif
				Next
			next
			for $test=1 to 9
				if $helper[$test]>1 then
					tooltip("mistake at line: " &  $g*3/3 & " box: " & $z*3/3 )
					sleep(500)
					$mistake=$mistake+1
				endif
				$helper[$test]=0
			next
		next
	next
	if $wrong = 0 then
		tooltip("checking lines and columns")
		sleep(1000)
		for $i=1 to 9
			for $j=1 to 9
				if (guictrlread($number[$i][$j]) > 0) then
					$helper[guictrlread($number[$i][$j])]=$helper[guictrlread($number[$i][$j])]+1
				else
					exitloop(2)
				endif
			next
			for $test=1 to 9
				if $helper[$test]>1 then
					tooltip("mistake at column: " &  $i )
					sleep(500)
					$mistake=$mistake+1
				endif
				$helper[$test]=0
			next
		next
		for $j=1 to 9
			for $i=1 to 9
				if (guictrlread($number[$i][$j]) > 0) then
					$helper[guictrlread($number[$i][$j])]=$helper[guictrlread($number[$i][$j])]+1
				else
					exitloop(2)
				endif
			next
			for $test=1 to 9
				if $helper[$test]>1 then
					tooltip("mistake at line: " &  $j )
					sleep(500)
					$mistake=$mistake+1
				endif
				$helper[$test]=0
			next
		next
		if $mistake = 0 then
			tooltip("Congratulations, you have won the game!")
		else
			tooltip("You had " & $mistake &" mistakes")
		endif
		sleep(2000)
	endif
	$mistake = 0
	$wrong=0
	tooltip("")
endfunc

while 1
	$msg1=guigetmsg()
	if $msg1=$testsudoku then
		check()
	endif
	If $msg1 = -3 Then
		exit
	endif
	If $msg1 = $generatesudoku Then
		$difficulty=inputbox("Difficulty","1 - Easy" & @CRLF & "2 - Medium" & @CRLF & "3 - Hard","2","",100,170)
		if ($difficulty > 0) and ($difficulty < 4) then
			for $i=1 to 9
				for $j=1 to 9
					guictrlsetdata($number[$i][$j],"")
					guictrlsetstate($number[$i][$j],$GUI_enable)
				next
			next
			_ShowSplash("New sudoku","...Generating..." & @LF & "...Please wait..."& @LF &"...F5 to stop...")
			hotkeyset("{F5}","stopit")
			GUISetState(@SW_DISABLE, $GUI_hwnd)
			$stopitnow=0
			generate()
			if $stopitnow=1 then
				for $i=1 to 9
					for $j=1 to 9
						guictrlsetdata($number[$i][$j],"")
					Next
				next
			endif
			$stopitnow=0
			GUISetState(@SW_ENABLE, $GUI_hwnd)
			hotkeyset("{F5}")
			_ShowSplash()
			for $i=1 to 9
				for $j=1 to 9
					guictrlsetdata($number[$i][$j],$number2[$i][$j])
				Next
			next
			$difficulty=0
		endif
	endif
	if $msg1 = $infosudoku then
		_ShowSplash("Solving puzzle","...Solving..." & @LF & "...Please wait..." & @LF &"...F5 to stop...")
		hotkeyset("{F5}","stopit")
		GUISetState(@SW_DISABLE, $GUI_hwnd)
		$stopitnow=0
		solve()
		if $stopitnow=1 then
			for $i=1 to 9
				for $j=1 to 9
					if $solve[$i][$j] = "" then
						guictrlsetdata($number[$i][$j],"")
					endif
				Next
			next
		endif
		$stopitnow=0
		GUISetState(@SW_ENABLE, $GUI_hwnd)
		hotkeyset("{F5}")
		_ShowSplash()
	endif
	if $msg1 = $addsudoku Then
		$location1=FileSavedialog("Saving sudoku","","text files(*.txt)")
		if not @error then
			if fileexists($location1) Then
				filedelete($location1)
			endif
			$openfile=fileopen($location1,1)
			for $i=1 to 9
				for $j=1 to 9
					filewrite($openfile,guictrlread($number[$i][$j]) & @CRLF)
				next
			next
			for $i=1 to 9
				for $j=1 to 9
					filewrite($openfile,guictrlgetstate($number[$i][$j]) & @CRLF)
				next
			next
			fileclose($openfile)
		endif
	endif
	if $msg1 = $loadsudoku Then
		$wtf=0
		$location2=fileopendialog("Loading sudoku","","text files(*.txt)")
		if not @error then
			for $i=1 to 9
				for $j=1 to 9
					$wtf=$wtf+1
					guictrlsetdata($number[$i][$j],filereadline($location2,$wtf))
				next
			next
			for $i=1 to 9
				for $j=1 to 9
					$wtf=$wtf+1
					guictrlsetstate($number[$i][$j],filereadline($location2,$wtf))
				next
			next
		endif
	endif
	if $msg1=$downloadsudoku Then
		for $i=1 to 9
			for $j=1 to 9
				guictrlsetstate($number[$i][$j],64)
				guictrlsetdata($number[$i][$j],"")
			Next
		next
	endif
	if $msg1=$informations Then
		msgbox(0,"sudoku - by bonebreaker - v0.5","Functions:" & @CRLF & "-random sudoku generator" & @CRLF & "-puzzle solving(slow)" & @CRLF & "-saving/loading puzzles" & @CRLF & "-checking if your puzzle is finished perfectly" & @CRLF & "-selecting difficulty for random puzzles" & @CRLF & "-Creating custom puzzles" & @CRLF & "Notices: " & @CRLF & "-Type .txt after the filename when you save a sudoku" & @CRLF & "-Add button completes your custom puzzle")
	endif
	if $msg1=$customsudoku then
		for $i=1 to 9
			for $j=1 to 9
				if guictrlread($number[$i][$j]) <> "" then
					guictrlsetstate($number[$i][$j],128)
				endif
			Next
		next
	endif
	for $i=1 to 9
		if $msg1 = $numbutton[$i] then
			send($i)
		endif
	next
	if $msg1 = $erasebutton then
		send("{BACKSPACE}")
	endif
wend

func stopit()
	$stopitnow=1
endfunc

Func _ShowSplash($Title = '', $Text = '')
	If NOT @NumParams Then
		SplashOff()
	Else
		SplashTextOn($Title, $Text, 130, 60,default,default , 1+32, 'Courier New', 9)
	EndIf
EndFunc

#cs
	-1.0-ba
	solve puzzle megoldása
		ha nem tud olyat generálni ami eltér az elözötöl akkor lépjen vissza 1 sort
	9 számot lépjen vissza ne sort
	
	-további verziokban:
	gombokkal számküldés
	generálás után egy számbol nem lehet több 4-nél
	hard fokozat rendbetétele
	optimalizálás
#ce