Opt("TrayAutoPause",0)

if not FileExists("primes.txt") then
	do 
		$input=InputBox("Missing primes.txt","Since you don't have a pregenerated primelist we will create one. Add the limit until you want the primes:","10000")
		if @error then exit
	until isnumber($input)
	tooltip("..Prime generation until "&$input&" is in progress..",,@DesktopWidth-100,@DesktopHeight-100)	
	$primes=_PrimeSearch($input)
	tooltip("")
	$file=fileopen("primes.txt",2)
	FileWriteLine($file,$primes[0])
	for $i=2 to $primes[0]+1
		FileWriteLine($file,$primes[$i])
	next
	fileclose($file)
endif

guicreate("Primeitive - v1.0",200,155)
$number=guictrlcreatelabel("1",0,0,200,50,0x01)
GUICtrlSetFont(-1,40)
$yes=GUICtrlCreateButton("Yes",5,60,90,25)
$no=GUICtrlCreateButton("No",105,60,90,25)
guictrlcreatelabel("..Score..",5,90,90,default,0x01)
guictrlcreatelabel("..Time..",105,90,90,default,0x01)
$score=guictrlcreatelabel(0,5,105,90,default,0x01)
$time=guictrlcreatelabel(0,105,105,90,default,0x01)
$new=GUICtrlCreateButton("New",5,125,190,25)
GUISetState()

local $runing=0,$fileend=filereadline("primes.txt",1)+1

while 1
	$msg=GUIGetMsg()
	Select
		Case ($msg=$yes) and $runing 
			if $prime then 
				guictrlsetdata($score,GUICtrlRead($score)+1)
				$place +=1
				if $place <= $fileend then
					$rand=random(0,1,1)
					if $rand then 
						$prime=1
						guictrlsetdata($number,FileReadLine("primes.txt",$place))
					else
						$prime=0
						guictrlsetdata($number,random(FileReadLine("primes.txt",$place)+1,FileReadLine("primes.txt",$place+1)-1,1))
					endif
					guictrlsetdata($time,10)
					$i=1
					$timer=TimerInit()
				else
					$timer=0
					$runing=0
				endif
			else
				$timer=0
				$runing=0
			endif
		case ($msg=$no) and $runing 
			if not $prime then 
				guictrlsetdata($score,GUICtrlRead($score)+1)
				$place +=1
				if $place <= $fileend then
					$rand=random(0,1,1)
					if $rand then 
						$prime=1
						guictrlsetdata($number,FileReadLine("primes.txt",$place))
					else
						$prime=0
						guictrlsetdata($number,random(FileReadLine("primes.txt",$place)+1,FileReadLine("primes.txt",$place+1)-1,1))
					endif
					guictrlsetdata($time,10)
					$i=1
					$timer=TimerInit()
				else
					$timer=0
					$runing=0
				endif
			else
				$timer=0
				$runing=0
			endif
		case $msg=-3
			exit
		case $msg=$new
			$runing=1
			$place=2
			$i=1
			$timer=TimerInit()
			guictrlsetdata($score,0)
			guictrlsetdata($time,10)
			$rand=random(0,1,1)
			$place +=1
			if $rand then 
				$prime=1
				guictrlsetdata($number,FileReadLine("primes.txt",$place))
			else
				$prime=0
				guictrlsetdata($number,random(FileReadLine("primes.txt",$place)+1,FileReadLine("primes.txt",$place+1)-1,1))
			endif
	EndSelect
	if $runing then
		if (TimerDiff($timer)>10000) then
			guictrlsetdata($time,0)
			$runing=0
			$timer=0
		else
			if $i*1000<TimerDiff($timer) then
			GUICtrlSetData($time,10-int(TimerDiff($timer)/1000))
			$i +=1
			endif
		endif
	endif
WEnd

func _PrimeSearch($searchlimit)
	local $i=5,$primes[int($searchlimit/4)],$primenum,$step=2
	$primes[3]=5
	$primes[2]=3
	$primes[1]=2
	$primes[0]=3
	while $i<$searchlimit 
		guictrlsetdata($progress,$i/$searchlimit*100)
		$primenum=3
		$i+=$step
		$step=6-$step
		while $i >= ($primes[$primenum]*$primes[$primenum])
			if mod($i,$primes[$primenum])=0 Then continueloop 2
			$primenum+=1
		wend
		$primes[0]+=1
		$primes[$primes[0]]=$i
	wend
	redim $primes[$primes[0]+1]
	return $primes
endfunc