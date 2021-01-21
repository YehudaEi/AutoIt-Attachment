;WinMinimizeAll()
;mousemovereal(0,0,3,0,1)
;mousemovereal(200,200,3,0,1)
;mouseclickreal("left",50,100,1,1,0,1)
;mouseclickdragreal("left",100,100,400,400,1,1,10,0)
;mousedownreal("left")
;mousemovereal(600,600,1,0,1)
;mouseupreal("left")
;WinMinimizeAllUndo()
Testreal2(1,1);1=X ,2=Y ,3=Speed << How higher , how faster
; Note :	1 = x goto.
;			2 = y goto.
;			3 = Speed behide steps
;			4 = The total of steps .. For a nice example use speed 10 and steps 2
;			5 = automatic makes a the good step number. 1 to enable , 0 to disable
;This is named "Mousemovereal", something which simulates a normally moving mouse cursor. Be honest,
;how many times do you draw a straight line from point a to point b?
; If you're lucky, that means if blizzard is running a detector you don't want to be making perfect straight lines all the time. 
;This function moves your mouse to the desired position, but not in a straight line
;
;dit is mousemovereal dat betekend dat het een echte mousemove na maakt , want zeg zelf , hoe vaak
;trek je een rechte lijn van a tot b ? soms als je een keer mazzel hebt , dus als blizzard een
;detector heeft draaien moet je niet altijd een perfecte rechte lijn maken , daarom gebruik deze funcie
;deze is niet recht maar gaat wel naar gewenste posietie
;
;This is mouseclickreal , this is the same as mousemovereal but then with click funcion , parameters 1=Button 2=x 3=y 4=speed 5=nubclick 6=steps 

func mousemovereal($x,$y,$speed,$steps,$Auto)
	; The mousemover , but he dont make a perfect line :)
	dim $q[2]
	$q[0] = $x
	$q[1] = $y
	$p = MouseGetpos()
	$len = Sqrt(($p[0]+$q[0])*($p[0]+$q[0]))+(($p[1]+$q[1])*($p[1]+$q[1]))
	if $Auto = 1 Then
		$steps = $len / 2000
		tooltip("Auto Steps :"&$steps)
	endif
	$mousestart = MouseGetpos()
	for $i = 1 to $steps
		mousemove(($p[0]+($i*($q[0]-$p[0])/$steps))+random(random(-2,0),random(0,2)),$p[1]+($i*($q[1]-$p[1])/$steps)+random(random(-2,0),random(0,2)),$speed)
		$Secondmove = MouseGetPos()
	next
	mousemove($x,$y,$speed)
endfunc
func mouseclickreal($button ,$x,$y,$speed,$Nubofclicks,$steps,$Auto)
	;A mouseclick without a perfect line mouse move :)
	mousemovereal($x,$y,$speed,$steps,$Auto)
	$pos = mousegetpos()
	mouseclick($button,$pos[0],$pos[1],$Nubofclicks)
EndFunc
func mouseclickdragreal($button,$x,$y,$x2,$y2,$speed,$Nubofclicks,$steps,$Auto)
	;Drag with a real mouse move :) , How mutch time you move your mouse really in a perfect line ? , why you shall do it perfect in drag?
	mousemovereal($x,$y,$speed,$steps,$Auto)
	mousedown($button)
	mousemovereal($x2,$y2,$speed,$steps,$Auto)
	mouseup($button)
endfunc
func mousedownreal($button)
	;Maby its sicko , but do you click your mouse without a little mouse move ?
	$pos = MouseGetPos()
	mousemove($pos[0]-random(random(-2,0),random(0,2)),$pos[1]-random(random(-2,0),random(0,2)),1)
	mousedown($button)
EndFunc
func mouseupreal($button)
	;Maby its sicko , but do you click your mouse without a little mouse move ?
	$pos = MouseGetPos()
	mousemove($pos[0]-random(random(-2,0),random(0,2)),$pos[1]-random(random(-2,0),random(0,2)),1)
	mouseup($button)
EndFunc
;\/ = beta , alpha
; This here under is beta testing , TestReal Works..
; \/ = beta , alpha
func TestReal($x,$y)
	dim $q[2]
	$q[0] = $x
	$q[1] = $y
	$p = MouseGetpos()
	$len = Sqrt(($p[0]+$q[0])*($p[0]+$q[0]))+(($p[1]+$q[1])*($p[1]+$q[1]))
	$steps = $len / 1000
	tooltip("Auto Steps :"&$steps)
	sleep(5000)
	$mousestart = MouseGetpos()
	for $i = 1 to $steps
		mousemove(($p[0]+($i*($q[0]-$p[0])/$steps))+random(random(-2,0),random(0,2)),$p[1]+($i*($q[1]-$p[1])/$steps)+random(random(-2,0),random(0,2)),1)
		$S = MouseGetPos()
		tooltip("Auto Steps :"&sqrt(($S[0]+$q[0])*($S[0]+$q[0]))+(($S[1]+$q[1])*($S[1]+$q[1]))/1000,0,05)
	next
	mousemove($x,$y,1)
endfunc
func TestReal2($x,$y)
	$do = 1
	dim $q[2]
	$q[0] = $x
	$q[1] = $y
	$p = MouseGetpos()
	$len = Sqrt(($p[0]+$q[0])*($p[0]+$q[0]))+(($p[1]+$q[1])*($p[1]+$q[1]))
	$steps = $len / 1000
	$Random=random(0,1)
	tooltip("Auto Steps :"&$steps&"|random :"&$random)
	$do = 0 
	if $Random > 1.75 Then
		$Do = 1
	endif
	;sleep(5000)
	If $do =1 Then
		dim $r[2]
		dim $s[2]
	    $s[0]=$p[0]	/(+(Cos($q[1])*2))
		$s[1]=$p[1]	/(+(Cos($q[0])*2))
		$r[0]=$q[0]	/(+(Cos($p[1])*2))
		$r[1]=$q[1]	/(+(Cos($p[0])*2))	
		$max = random(-$steps,$steps)
		for $count = 1 to +$max
			$i = $max
			mousemove(($s[0]+($i*($r[0]-$s[0])/$steps))+random(random(-2,0),random(0,2)),$s[1]+($i*($r[1]-$s[1])/$steps)+random(random(-2,0),random(0,2)),1)
			tooltip("Auto Steps :"&sqrt(($S[0]+$q[0])*($S[0]+$q[0]))+(($S[1]+$q[1])*($S[1]+$q[1]))/1000,0,05)
		next
		return TestReal2($q[0],$q[1])
	endif
	$mousestart = MouseGetpos()
	for $i = 1 to $steps
		mousemove(($p[0]+($i*($q[0]-$p[0])/$steps))+random(random(-2,0),random(0,2)),$p[1]+($i*($q[1]-$p[1])/$steps)+random(random(-2,0),random(0,2)),1)
		$S = MouseGetPos()
		tooltip("Auto Steps :"&sqrt(($S[0]+$q[0])*($S[0]+$q[0]))+(($S[1]+$q[1])*($S[1]+$q[1]))/1000,0,05)
	next
EndFunc