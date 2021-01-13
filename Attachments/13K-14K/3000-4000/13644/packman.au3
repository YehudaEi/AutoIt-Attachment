Global $LEVEL_DEMO_MODE = False

Global $CURRENTSPEED = 10
Global $ANIMODE = False
;~ Global $ANIMODE = True
;TODO
;fruit pos
;~ #include "pacman_vars.au3"
;~ #include "pacman_actions.au3"
HotKeySet("{ESC}","_exit")
HotKeySet("{UP}","moveup")
HotKeySet("{RIGHT}","moveright")
HotKeySet("{DOWN}","movedown")
HotKeySet("{LEFT}","moveleft")
HotKeySet("{SPACE}","pause")
Opt("GUICloseOnESC",1)
Opt("GUIOnEventMode", 1)


;If Not FileExists()

Global Const $GUI_EVENT_CLOSE			= -3
Global Const $GUI_EVENT_MINIMIZE		= -4
Global Const $GUI_EVENT_RESTORE			= -5
Global Const $GUI_EVENT_MAXIMIZE		= -6
Global Const $GUI_EVENT_PRIMARYDOWN		= -7
Global Const $GUI_EVENT_PRIMARYUP		= -8
Global Const $GUI_EVENT_SECONDARYDOWN	= -9
Global Const $GUI_EVENT_SECONDARYUP		= -10
Global Const $GUI_EVENT_MOUSEMOVE		= -11
Global Const $GUI_EVENT_RESIZED			= -12
Global Const $GUI_EVENT_DROPPED			= -13

Global Const $GUI_SHOW			= 16
Global Const $GUI_HIDE 			= 32
Global Const $GUI_ENABLE		= 64
Global Const $GUI_DISABLE		= 128
Global Const $GUI_FOCUS			= 256
Global Const $GUI_DEFBUTTON		= 512

;;;;;;;;;;graphics
Global Const $GUI_GR_CLOSE		= 1
Global Const $GUI_GR_LINE		= 2
Global Const $GUI_GR_BEZIER		= 4
Global Const $GUI_GR_MOVE		= 6
Global Const $GUI_GR_COLOR		= 8
Global Const $GUI_GR_RECT		= 10
Global Const $GUI_GR_ELLIPSE	= 12
Global Const $GUI_GR_PIE		= 14
Global Const $GUI_GR_DOT		= 16
Global Const $GUI_GR_PIXEL		= 18
Global Const $GUI_GR_HINT		= 20
Global Const $GUI_GR_REFRESH	= 22
Global Const $GUI_GR_PENSIZE	= 24
Global Const $GUI_GR_NOBKCOLOR	= -2

Global Const $guiname = "Pacman in AutoIt"
If WinExists($guiname) Then
	WinActivate($guiname)
	Exit
EndIf
Global Const $BLINKY = 0
Global Const $PINKY = 1
Global Const $INKEY = 2
Global Const $CLYDE = 3

Global Const $STATE_DEAD = 0
Global Const $STATE_BLUE = 1
Global Const $STATE_PINK = 2
Global Const $STATE_CHASE = 3

;; 0=x, 1=y, 2=state[ 0=dead, 1=blue, 2=normal, 3=chasing], 3=following a predefined path
;3 bodyid
Global Const $GSTATE = 2
Global Const $GMODEL = 3
Global Const $GDIR = 4
Global Const $GSTART = 5

;; default, copy, bodies
Global $Ghosts[4][6] = [ [116,121,2,0,4,0], [116,145,2,0,3,0], [100,145,2,0,1,1], [132,145,2,0,1,1] ]
Global $Ghostb[4][3][6]; 64 ghost bodies. bleh
Global $GBOTTOM = 0; toggle bottom crap
Global $GVELS[5][2] = [ [0,0], [0,-1], [1,0], [0,1], [-1,0] ];   -- velocities

Global $eyearr[5] = [fastarr(0,0,4,4,0), fastarr(2,1,3,1,0), fastarr(3,3,5,5,0), fastarr(2,4,3,7,0), fastarr(1,3,1,5,0)]
Global $bottomarr[3] = [StringSplit("2,6,7,11,1,2,3,6,7,10,11,12",","),StringSplit("4,9,0,3,4,5,8,9,10,13",","),StringSplit("2,3,6,7,10,11,1,4,5,8,9,12",",")]
Global $CORNERX = fastarr(1,1,1,1,1)
Global $CORNERL[5] = ['',fastarr(1,0,1,1,0),fastarr(1,0,0,1,1),fastarr(1,1,0,0,1),fastarr(1,1,1,0,0)]
Global $CORNERT[5] = ['',fastarr(1,1,1,0,1),fastarr(1,1,1,1,0),fastarr(1,0,1,1,1),fastarr(1,1,0,1,1)]
Global $VELS[5] = [fastarr2(0,0), fastarr2(0,-1), fastarr2(1,0), fastarr2(0,1), fastarr2(-1,0)] 
Global $DEFMOVES[5] = ['',fastarr(1,1,0,1,0),fastarr(1,0,1,0,1),fastarr(1,1,0,1,0),fastarr(1,0,1,0,1)]


Global $SCORE = 0
Global $SCORETOX = 10000
Global $GUYS = 2
Global $LEVEL = 1


Global $FRUITPOS[2] = [116,168]
Global $FRUITID
Global $FRUITID2
Global $FRUITTIME = TimerInit()
Global $FRUITHOWMANY
Global $FRUITHAVE = False
Global $FRUITCURRENT = 0
Global $FRUITPOINTS[14] = [0,1000,300,500,500,700,700,1000,1000,2000,2000,3000,3000,5000]

Global $GUIGUYS = 0

;;; 4 tragectories
;~ Global $trag[4][2] = [[0,-1],[1,0],[0,1],[-1,-1]] 

Global $MOUSEDOWN = False
Global $WINPOS[2]
;~ Global $FIRSTDOTID

Global $sounddll = DllOpen("winmm.dll")
Global $openchomp = "pacchomp.wav"

Global $dotdic1 = ObjCreate("Scripting.Dictionary")
Global $dotdic = ObjCreate("Scripting.Dictionary")
Global $dirdic = ObjCreate("Scripting.Dictionary")
Global $delayitems = ObjCreate("Scripting.Dictionary")
Global $delaytime = 5

Global $pac_set_arr = ''
Global $PACMOUTH = 0
Global $PACMOUTHC = 0
Global $PACBODY[5] = [0,135,45,315,225]
Global $PACNEXTMOVE = 4
Global $PACNOWMOVE = 4
Global $ONDOT = False
Global $PACMOVES[5] = [1,0,1,0,1]
Global $PACTRAG = $VELS[4]
Global $PACPOS[2] = [116,216]
Global $pacg[2]
Global $PACID

;;MISC
Global $SOUNDTIMER; to keep chomp sounds from playing too fast
Global $ISPAUSED = False

Func fastarr($a,$b,$c,$d,$e)
Local $temp[5]=[$a,$b,$c,$d,$e];	array functionality must be the biggest challenge when making a new language.
Return $temp
EndFunc
Func fastarr2($a,$b)
Local $temp[2]=[$a,$b]
Return $temp
EndFunc

;GHOSTS
;ISCHASING- is chasing pacman. then 75 % chance to follow
;STATE - dead, blue, normal
; model - up down, left , right 
Func game_initialize()
DllCall($sounddll, "int", "mciSendStringA", "str", "open " & FileGetShortName("sounds\pacchomp.wav") & " alias "& $openchomp, "str", "", "int", 65534, "hwnd", 0)
Global $gui = GUICreate ( $guiname, 234, 300, -1, -1, 0x80000000+0x00800000 )
GUISetBkColor(0x000000)
GUISetFont (9, 700, -1, "Courier")
GUICtrlCreateLabel ("Score", 8, 4)
GUICtrlSetColor(-1, 0xF0F0F0)
Global $guiscore = GUICtrlCreateLabel("0",66,4,80,12)
GUICtrlSetColor(-1,0xffffff)
GUISetOnEvent( $GUI_EVENT_PRIMARYDOWN, "DragWindow" )
If $ANIMODE Then GUISetState()
makeoutline()
makeghosts()
makedots()
makefruit()
fixguys()
Global $READYMSG = GUICtrlCreateGraphic (93, 165, 46, 7)
GUICtrlSetGraphic(-1, 8,0xffff00)
Local $moves[2] = [6,2]
$yel = 1
$arr = StringSplit("5363335422243,2322262122222322243,23222523212322222331,223252232123234422,54257123242513,2133252321222529,2232612321562414",",")
$y = 0
$x = 1
GUICtrlSetGraphic (-1, 6, $x, $y)
for $ii = 1 to $arr[0]
	$b = StringSplit($arr[$ii],"")
	GUICtrlSetGraphic (-1, 6, $x, $y)
	$yel = 1
	For $i = 1 to $b[0]
		$x += $b[$i]
		GUICtrlSetGraphic (-1, $moves[$yel], $x, $y)
		$yel = Not $yel
	Next
	$x = 0
	$y += 1
Next

If Not $ANIMODE Then GUISetState()
; if @error!!!!!!!!!!!!!!!!!!!!
new_round(1)
IF $LEVEL_DEMO_MODE Then $delayitems.Add("endroundaction",4)
;~ endroundaction()

EndFunc
game_initialize()


Func repositionghosts()
Global $Ghosts[4][6] = [ [116,121,2,0,4,0], [116,145,2,0,3,0], [100,145,2,0,1,1], [132,145,2,0,1,1] ]
Local $dirs[4] = [4,3,1,1]
For $G = $BLINKY to $CLYDE
	$ghosts[$G][$GMODEL] = $ghostb[$G][0][$dirs[$G]]
	GUICtrlSetPos( $ghosts[$G][$GMODEL] , $Ghosts[$G][0]-7, $Ghosts[$G][1]-7)
Next
EndFunc


Func new_round($ROUNDCHANGE)
If $ROUNDCHANGE Then
	If $LEVEL > 1 Then reloaddots()
	makefruit()
Else
	ctrlhide($FRUITID)
	adddelay("checkfruit", 10)
EndIf

repositionghosts()
$PACPOS[0] = 116
$PACPOS[1] = 216
$PACNEXTMOVE = 4
$PACNOWMOVE = 4
$PACMOUTH = 0
GUICtrlSetPos ( $PACBODY[0], 116-7, 216-7  )
$ONDOT = False
GUICtrlSetPos($READYMSG, 93, 165 )
;~ If $LEVEL == 1 Then SoundPlay("sounds\GAMEBEGINNING.wav",1)
sleep(1000); temp
ctrlhide($READYMSG)

;; ready message
	; reset ghosts
	;ready label
EndFunc

;~ I guess we'll just make everything in this one function
Func makeoutline()
;; we have to make all ghosts and eyes and positions of pacman and hide them
Local $grarr[14]
$grarr[0] = "0,24,224,5,0-0,266,224,5,1;6,4,0;2,220,0;6,5,3;2,107,3;6,117,3;2,219,3;18,2,1;18,3,1;18,1,2;18,1,3;18,0,4;18,4,4;18,107,4;18,116,4;18,219,4;18,223,4;18,220,1;18,221,1;18,222,2;18,222,3"
$grarr[1] = "0,29,4,70,0-219,29,4,70,2;6,0,0;2,0,70;6,3,0;2,3,70"
$grarr[2] = "0,99,44,33,0-0,147,44,33,1-179,99,44,33,2-179,147,44,33,3;"& _
"6,5,1;2,42,1;6,4,4;2,40,4;6,40,5;2,40,29;6,43,3;2,43,31;6,0,29;2,40,29;6,0,32;2,42,32;"& _
"18,0,0;18,4,0;18,1,1;18,1,2;18,2,3;18,3,3;18,42,2;18,42,31"
$grarr[3] = "108,29,10,30,0;6,0,0;2,0,28;2,2,30;2,5,30;2,7,28;2,7,-1"
$grarr[4] = "0,181,20,86,0-203,181,20,86,2;6,0,0;2,0,86;6,3,0;2,3,37;2,5,39;2,17,39;2,19,41;2,19,44;2,17,46;2,5,46;2,3,48;2,3,86"
$grarr[5] = "60,76,31,55,0-132,76,31,55,2;"& _
"6,0,2;2,2,0;2,5,0;2,7,2;2,7,22;2,9,24;2,29,24;2,31,26;2,31,29;2,29,31;2,9,31;2,7,33;2,7,53;2,5,55;2,2,55;2,0,53;2,0,2"
$grarr[6] = "84,76,55,31,0-84,172,55,31,0-84,220,55,31,0;6,0,2;2,2,0;2,53,0;2,55,2;2,55,5;2,53,7;2,33,7;2,31,9;2,31,29;2,29,31;2,26,31;2,24,29;2,24,9;2,22,7;2,2,7;2,0,5;2,0,2"
$grarr[7] = "20,220,71,31,0-132,220,71,31,2;6,0,29;2,0,26;2,2,24;2,38,24;2,40,22;2,40,2;2,42,0;2,45,0;2,47,2;2,47,22;2,49,24;2,69,24;2,71,26;2,71,29;2,69,31;2,2,31;2,0,29"
$grarr[8] = "20,196,23,31,0-180,196,23,31,2;6,0,2;2,2,0;2,21,0;2,23,2;2,23,29;2,21,31;2,18,31;2,16,29;2,16,9;2,14,7;2,2,7;2,0,5;2,0,2"
$grarr[9] = "20,44,23,15,0-180,44,23,15,0;6,0,2;2,2,0;2,21,0;2,23,2;2,23,13;2,21,15;2,2,15;2,0,13;2,0,2"
$grarr[10] = "60,44,31,15,0-132,44,31,15,0;6,0,2;2,2,0;2,29,0;2,31,2;2,31,13;2,29,15;2,2,15;2,0,13;2,0,2"
$grarr[11] = "20,76,23,7,0-180,76,23,7,0;6,0,2;2,2,0;2,21,0;2,23,2;2,23,5;2,21,7;2,2,7;2,0,5;2,0,2"
$grarr[12] = "60,148,7,31,0-156,148,7,31,0-60,196,31,7,4-132,196,31,7,4;6,0,2;2,2,0;2,5,0;2,7,2;2,7,29;2,5,31;2,2,31;2,0,29;2,0,2"
$grarr[13] = "84,124,28,31,0-111,124,28,31,2;6,28,31;2,0,31;2,0,0;2,19,0;2,19,3;2,3,3;2,3,28;2,28,28"
For $arr in $grarr
$arr = StringSplit($arr,';')
$places = StringSplit( $arr[1], '-' )
$skip = True
For $p in $places
	If $skip Then
		$skip = False
		ContinueLoop
	EndIf
	$x = StringSplit($p, ',')
	$x[1] += 4
	$x[2] += 5; Want the locations of the dots to be divisible by 8 for simplicity.
	$hw = $x[3] / 2
	$hh = $x[4] / 2
	$gr = GUICtrlCreateGraphic ( $x[1],$x[2],$x[3],$x[4] )
	$way = $x[5]
	GUICtrlSetGraphic ( $gr, $GUI_GR_COLOR, 0x2121DE )
	for $i = 2 to $arr[0]
		$x = StringSplit( $arr[$i], ',' )
		Switch $way
		Case "0";							 we can flip these upside down, over, and both - to reduce redundancy...
		Case "1"
			$x[3] = (($x[3] - $hh) * -1) + $hh;		upside down
		Case "2"
			$x[2] = (($x[2] - $hw) * -1) + $hw;		over
		Case "3"
			$x[3] = (($x[3] - $hh) * -1) + $hh;		both
			$x[2] = (($x[2] - $hw) * -1) + $hw
		Case "4"
			$t = $x[2];								NEW!! rotate 90 degrees
			$x[2] = $x[3]
			$x[3] = $t
		EndSwitch
		GUICtrlSetGraphic($gr, $x[1], $x[2], $x[3])
		If $ANIMODE Then
			GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			sleep(1)
		EndIf
	Next
;~ 	GUICtrlSetGraphic(-1,$GUI_GR_CLOSE)
;~ 	GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)
Next
Next
;;;;;patch
GUICtrlCreateGraphic( 111, 271, 9, 2 )
GUICtrlSetGraphic ( -1, $GUI_GR_COLOR, 0x000000 )
GUICtrlSetGraphic ( -1, 18, 0,1 )
GUICtrlSetGraphic ( -1, 18, 9,1 )
GUICtrlSetGraphic ( -1, 6, 0,2 )
GUICtrlSetGraphic ( -1, $GUI_GR_COLOR, 0x2121DE )
GUICtrlSetGraphic ( -1, 2, 10,2 )
GUICtrlCreateGraphic( 108,130,16,2 )
GUICtrlSetBkColor(-1,0xFFB8DE)
$carr = StringSplit("16,40;l1;56,40;t3;104,40;l2;128,40;l1;176,40;t3;216,40;l2;" & _
"16,72;t2;56,72;x;80,72;t3;104,72;t1;128,72;t1;152,72;t3;176,72;x;216,72;t4;" & _
"16,96;l4;56,96;t4;80,96;l4;104,96;l2;128,96;l1;152,96;l3;176,96;t2;216,96;l3;" & _
"80,120;l1;104,120;t1;128,120;t1;152,120;l2;" & _
"56,144;x;80,144;t4;152,144;t2;176,144;x;" & _
"80,168;t2;152,168;t4;" & _
"16,192;l1;56,192;x;80,192;t1;104,192;l2;128,192;l1;152,192;t1;176,192;x;216,192;l2;" & _
"16,216;l4;32,216;l2;56,216;t2;80,216;t3;104,216;t1;128,216;t1;152,216;t3;176,216;t4;200,216;l1;216,216;l3;" & _
"16,240;l1;32,240;t1;56,240;l3;80,240;l4;104,240;l2;128,240;l1;152,240;l3;176,240;l4;200,240;t1;216,240;l2;" & _
"16,264;l4;104,264;t1;128,264;t1;216,264;l3;", ";" )
With $dirdic
For $i = 1 to $carr[0]-1 step 2
	.Add ( $carr[$i], CornerTypes ( $carr[$i+1] ) )
Next
EndWith
; make pacman models
For $i = 0 to 4
	If $i Then
	$t = $PACBODY[$i]
	$PACBODY[$i] = GUICtrlCreateGraphic(0,-50, 14, 14)
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xffff00)
	GUICtrlSetGraphic(-1,$GUI_GR_PIE, 7,7, 7, $t, 270)
	Else
;~ 	$PACBODY[$i] = GUICtrlCreateGraphic(116,216,0,0)
	$PACBODY[$i] = GUICtrlCreateGraphic( $PACPOS[0]-7, $PACPOS[1]-7, 14, 14 )
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0,0xffff00)
	GUICtrlSetGraphic(-1,$GUI_GR_PIE, 7,7, 7, 0, 360)
	GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xffff00,0xffff00)
	GUICtrlSetGraphic(-1,$GUI_GR_DOT,7,7)
	GUICtrlSetGraphic(-1,$GUI_GR_DOT,9,7)
	GUICtrlSetGraphic(-1,$GUI_GR_DOT,12,7)
	$PACID = $PACBODY[$i]
	EndIf
Next
Global $deadpacs[8]
$st = 120
$sw = 300
For $i = 0 to 7
$deadpacs[$i] = GUICtrlCreateGraphic(0,-50, 14, 14)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xffff00, 0xffff00)
GUICtrlSetGraphic(-1,$GUI_GR_PIE, 7,7, 6, $st, $sw)
$st +=20
$sw -=40
Next
;~ GUICtrlCreateLabel("Lives",10,284,30,15)
EndFunc


Func CornerTypes($str)
	$t = stringsplit($str,"")
	Switch $t[1]
	Case "x"
		Return $CORNERX
	Case "l"
		Return $CORNERL[$t[2]]
	Case "t"
		Return $CORNERT[$t[2]]
	EndSwitch
EndFunc
Func makedots()
$posarr = StringSplit("1,0,12,14|3,0,1,5,6,11,12,14,15,20,21,25|1,0|2,0,1,5,6,8,9,17,18,20,21,25|"& _
"1,0,6,8,12,14,18,20|11,5,6,20,21|1,0,12,14|2,0,1,5,6,11,12,14,15,20,21,25|1,0,3,5,12,14,21,23|"& _
"2,2,3,5,6,8,9,17,18,20,21,23,24|1,0,6,8,12,14,18,20|2,0,1,11,12,14,15,25|1,0","|")
Local $a[8] = [0,0,0,1,-1,1,-1,0]
;16,56; -> location of pows
;16,216
;216,56
;216,216
; 26 / 29
$x = 16
$y = 40
For $pi = 1 to $posarr[0]
	$pa = StringSplit( $posarr[$pi], "," )
	For $yi = 1 to $pa[1]
		$xstart = 2
		$hasdot = False
		$x = 16
		For $xi = 0 to 25
			If $xi = $pa[$xstart] Then
				$hasdot = Not $hasdot
				If $xstart < $pa[0] Then $xstart += 1
			EndIf
			If $hasdot Then
				$id = GUICtrlCreateGraphic($x,$y,0,0)
;~ 				If $pi == 1 and $xi == 0 Then $FIRSTDOTID = $id
				$dotdic1.Add($x &","& $y, $id)
				GUICtrlSetGraphic ( $id, $GUI_GR_COLOR, 0xFFFFFF )
				If ispower($x, $y) Then
					GUICtrlSetGraphic ( $id, $GUI_GR_PENSIZE, 6 )
					GUICtrlSetGraphic ( $id, $GUI_GR_COLOR, 0xFFFFFF )
					GUICtrlSetGraphic ( $id, 6, -1,0 )
					GUICtrlSetGraphic ( $id, 2, -1,0 )
				Else
				for $j = 0 to 6 step 2
					GUICtrlSetGraphic ( $id, 18, $a[$j],$a[$j+1] )
				Next
				EndIf
				If $ANIMODE Then
					GUICtrlSetGraphic ( $id, $GUI_GR_REFRESH )
					sleep(1)
				EndIf
			EndIf
			$x += 8
		Next
		$y += 8
	Next
Next
copydotdics()
;~ SoundPlay("sounds\GAMEBEGINNING.wav")

EndFunc
Func makeghosts()
Local $colors[4] = [ 0xFF0000, 0xFFB8DE, 0x00FFDE, 0xFFB847 ]
Local $blues[4] = [ 0x3333CC, 0xFFFFFF, 0xFFEEEE, 0xFF0000 ]
For $ghost = $BLINKY to $CLYDE
;;; 4 ghosts
For $i = 1 to 4;  4 eye positions
$ids = makebody($colors[$ghost])
	For $ii = 0 to 1 ; 2 bottom wiggly things..
		$Ghostb[$ghost][$ii][$i] = $ids[$ii]
		makeeyes( $ids[$ii], $i )
	Next
$id = GUICtrlCreateGraphic(0, -50, 14, 14); 		make eyes w no body
makeeyes ($id, $i)
$Ghostb[$ghost][2][$i] = $id
Next
;blue edible ghosts. blue / 
For $i = 0 to 1; - 2 shades
	$ids = makebody( $blues[$i] )
	For $ii = 0 to 1; 2 bottoms
	makeeyes( $ids[$ii], 0, $blues[$i+2] )
	$Ghostb[$ghost][$ii][$i*5] = $ids[$ii]
	Next
Next
Next
EndFunc
Func makebody( $color )
Local $arr[2]
for $i = 0 to 1
$arr[$i] = GUICtrlCreateGraphic(0, -50, 14, 14)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, $color,$color)
GUICtrlSetGraphic(-1,$GUI_GR_ELLIPSE, 0,0, 14, 15)
GUICtrlSetGraphic(-1,$GUI_GR_RECT, 0,10, 14, 4)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x000000, 0x000000)
GUICtrlSetGraphic(-1,18, 0, 5)
GUICtrlSetGraphic(-1,18, 13, 5)
GUICtrlSetGraphic(-1,$GUI_GR_RECT, 5, 14, 4, 1)
makebottom($arr[$i], $i)
Next
Return $arr
EndFunc
Func makeeyes($id, $type, $color = 0x2121DE)
$a = $eyearr[$type]
If $type Then
	$b = 6
GUICtrlSetGraphic($id, $GUI_GR_COLOR, 0xDEDEDE, 0xDEDEDE)
GUICtrlSetGraphic($id, $GUI_GR_ELLIPSE, $a[0], $a[1], 4, 5)
GUICtrlSetGraphic($id, $GUI_GR_ELLIPSE, $a[0]+$b, $a[1], 4, 5)
GUICtrlSetGraphic($id, $GUI_GR_COLOR, $color, $color)
Else
	$b = 4
	makebottom($id, 2, $color)
EndIf;0xFFCC99
GUICtrlSetGraphic($id,$GUI_GR_COLOR, $color, $color)
GUICtrlSetGraphic($id,$GUI_GR_ELLIPSE, $a[2], $a[3], 2, 2)
GUICtrlSetGraphic($id,$GUI_GR_ELLIPSE, $a[2]+$b, $a[3], 2, 2)
EndFunc
Func makebottom($id, $type, $color = 0x000000)
$a = $bottomarr[$type]
$y = Iif ($type == 2, 8, 12)
GUICtrlSetGraphic($id,$GUI_GR_COLOR, $color, $color)
For $i = 1 to $a[0]
	If $a[$i] < 2 Then $y += 1
	GUICtrlSetGraphic( $id, 18, $a[$i], $y)
Next
EndFunc;~ 0xFFB897
Func copydotdics()
$a = $dotdic1.keys
$b = $dotdic1.items
For $i = 0 to $dotdic1.count-1
	$dotdic.add($a[$i], $b[$i])
Next
EndFunc
Func makefruit()
GUICtrlDelete($FRUITID)
$pos = 210
Switch $LEVEL
case 1
	Local $carr[4] = [0x000000, 0xDE9747, 0xFF0000, 0xDEDEDE]
	$arr = StringSplit("00120814061201110205110311020123110311032311220111042501211122022131220122112301223121012601012301213124010522312301062402","")
case 2
	$pos -= 15
	Local $carr[4] = [0x000000, 0x00FF00, 0xFF0000, 0xDEDEDE]
	$arr = StringSplit("05310602133113030122152202251123312101213125212301233121312501283122010121312231240201290202223122312103032504052106","")
case 3,4
	$pos -= 30
	Local $carr[4] = [0x000000, 0x00FF00, 0xFFCC33, 0xCC9933]
	$arr = StringSplit("071203053115010531011302022233230201243125012a2a2a2a012001012001032603","")
case 5,6
	$pos -= 45
	Local $carr[4] = [0x000000, 0x00FF00, 0xCC9933, 0xFFFFFF]
	$arr = StringSplit("06210501130121011302152115011a1a1a193112193112011731120101100102180203120113","")
case 7,8
	$pos -= 60
	Local $carr[4] = [0x000000, 0xFFFF00, 0xFFFFFF, 0xFFFFFF]
	$arr = StringSplit("001101091102001208140814071101130611011301051101140104110114020311011221120202110112211203152112040115", "")
case 9,10
	$pos -= 75
	Local $carr[4] = [0x000000, 0xFFFF00, 0xFF0000, 0x3333CC]
	$arr = StringSplit("052106310323033101310225023101311122112111221131013114211431013217320101321101110111320202320111013203033101110131040511060511","")
case 11,12
	$pos -= 90
	Local $carr[4] = [0x000000, 0xFFFF00, 0x3333CC, 0xFFFFFF]
	$arr = StringSplit("051205031202120302180202120115020211011602011201170101120117010110011201191201191a11253223110125322301","")
case Else
	$pos -= 105
	Local $carr[4] = [0x000000, 0xFFFF00, 0x3333CC, 0x3333CC]
	$arr = StringSplit("0423050222032203022703022703022703041101110504110112040411011105041107041101110504110112040411011105051106","")
EndSwitch
Local $ids[2]
$ids[0] = GUICtrlCreateGraphic(0,-50, 12, 12)
$ids[1] = GUICtrlCreateGraphic($pos, 284, 12, 12)
;~ Cherries 	100 1 
;~ Strawberry 	300 2 
;~ Peach 		500 3-4 
;~ Apple 		700 5-6 
;~ Melon 		1000 7-8 
;~ Galaxian flagship 2000 9-10 
;~ Bell 		3000 11-12 
;~ Key 		5000 13 and up 
;~ 1. Stage Cherry 100 pts. 
;~ 2. Stage  Strawberry 200 pts. 
;~ 3. Stage Orange 500 pts. 
;~ 4. Stage Orange 500 pts. 
;~ 5. Stage Apple 700 pts. 
;~ 6. Stage Apple 700 pts. 
;~ 7. Stage Grape 1000 pts. 
;~ 8. Stage Grape 1000 pts. 
;~ 9. Stage Ice compot 2000 pts. 
;~ 10. Stage Ice compot 2000 pts. 
;~ 11. Stage Stewed fruit 3000 pts 
;~ 12. Stage Stewed fruit 3000 pts. 
;~ 13. Stage Key 5000 pts. 
;cherry
;strawberry
;orange
;pear
;banana
For $idi = 0 to 1
$x = 0
$y = 0
For $ii = 1 to $arr[0]-1 Step 2
	GUICtrlSetGraphic( $ids[$idi], 8, $carr[$arr[$ii]])
	$times = $arr[$ii+1]
	If $times == "0" Then
		$times = "10"
	ElseIf $times == "a" Then
		$times = "12"
	EndIf
	For $i = 1 to $times
		If $arr[$ii] Then GUICtrlSetGraphic( $ids[$idi], 18, $x, $y )
		$x +=1
		If $x >= 12 Then
			$x = 0
			$y += 1
			ExitLoop
		EndIf
	Next
Next
Next
$FRUITID = $ids[0]
adddelay("checkfruit",10)
		;;temp
GUICtrlSetGraphic( $ids[1], $GUI_GR_REFRESH )
	$FRUITHAVE = True
EndFunc
Func fixguys()
If $GUIGUYS Then GUICtrlDelete($GUIGUYS)
$GUIGUYS = GUICtrlCreateGraphic(10,281,100,14)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xffff00)
$x = 5
For $i = 1 to $guys
GUICtrlSetGraphic(-1,$GUI_GR_PIE, $x,7, 7, 45, 270)
$x += 16
Next
GUICtrlSetGraphic(-1,$GUI_GR_REFRESH)
EndFunc

;; after new level
Func reloaddots()
copydotdics()
;~ With $dotdic
$a = $dotdic.keys
$b = $dotdic.Items
	For $i = 0 to $dotdic.count - 1
		$s = StringSplit($a[$i],",")
		GUICtrlSetPos ( $b[$i], $s[1], $s[2] )
	Next
;~ EndWith		
EndFunc

Func ispower($x,$y)
Switch $x
Case 16,216
	Switch $y
	Case 56,216
		Return 1
	EndSwitch
EndSwitch

EndFunc
;16,56; -> location of pows
;16,216
;216,56
;216,216


Func Iif($x,$y,$z)
	If $x Then Return $y
	Return $z
EndFunc


;;; @@@@@@ ACTIONS @@@@@@ ;;;
Func ghostsetstate($g, $state, $e, $all = 0)
	
EndFunc


Func checkghosts()
	$x = $PACPOS[0]
	$y = $PACPOS[1]
	For $g = $BLINKY to $CLYDE
		If Not $ghosts[$g][2] Then ContinueLoop
		If Abs ( $ghosts[$g][0] - $x ) < 9 Then
			If Abs ( $ghosts[$g][1] - $y ) < 9 Then
				If $ghosts[$g][2] == 1 Then
					$ghosts[$g][2] = 0
					ctrlhide($Ghosts[$g][$GMODEL])
;~ 					$Ghosts[$g][$GMODEL] = 
				Else
					deathaction()
				EndIf
			EndIf
		EndIf
	Next	
EndFunc


Func ghostaction($g)
	If 1 Then
		;; change ghost graphic number
	Else
		deathaction()
	EndIf
EndFunc

Func extraguyaction()
	$GUYS += 1
	fixguys()
	; add graphic for xtra guy
	SoundPlay("sounds\extrapac.wav")
	$SCORETOX += 20000
EndFunc

Func deathaction()
$GUYS -= 1
fixguys()
sleep(1000)
ctrlhide($PACID)
SoundPlay("sounds\killed.wav")
$x = $PACPOS[0]-7
$y = $PACPOS[1]-7
For $i = 0 to 7
	GUICtrlSetPos($deadpacs[$i],$x,$y)
	Sleep(60)
	If not $i then sleep(70)
	ctrlhide($deadpacs[$i])
Next
sleep(250)
new_round(0)
EndFunc


Func fruitaction()
	If Not $FRUITHAVE Then Return
	$FRUITHAVE = False
	ctrlhide( $FRUITID )
	addpoints($FRUITPOINTS[$LEVEL], "sounds\fruiteat.wav" )
	adddelay("checkfruit",8)
;~ Global $FRUITPOS[2] = [116,168]
;~ Global $FRUITID
;~ Global $FRUITTIME = TimerInit()
;~ Global $FRUITHOWMANY
;~ Global $FRUITHAVE = False
;~ Global $FRUITCURRENT = 0
;~ Global $FRUITPOINTS[13] = [100,300,500,500,700,700,1000,1000,2000,2000,3000,3000,5000]
;~ 	$delayitems.Add("checkfruit", 200)
EndFunc

;; this is where we check to see if we should place fruit or remove fruit
Func checkfruit()
	$FRUITHAVE = True
	GUICtrlSetPos($FRUITID, $FRUITPOS[0]-6, $FRUITPOS[1]-6)
EndFunc


Func poweraction()
	;
	;
	;
	SoundPlay("sounds\GHOSTEATEN.wav")
	$SOUNDTIMER = TimerInit()+1500000
EndFunc


Func endroundaction()

$dotdic.removeall
for $G = $BLINKY to $CLYDE
ctrlhide($Ghosts[$G][$GMODEL])
Next
ctrlhide($PACID)
sleep(700)
;~ $pos = WinGetPos($guiname)
;~ $roundgui = GUICreate("autoit_pacman_round", 234, 300, $pos[1], $pos[0], 0x80000000, BitOr(0x00080000,0x00000040),$gui)
$roundgui = GUICreate("autoit_pacman_round", 234, 300, 0, -30, 0x80000000, BitOr(0x00080000,0x00000040),$gui)
GUISetFont (14, 700, -1, "Courier New")
GUISetBkColor(0x000000)
GUISetState()
$LEVEL += 1
For $i = 0 to 10
WinSetTrans("autoit_pacman_round", "", 255 - $i*15)
sleep(100)
Next
$x1 = -25
$x2 = 235
$l1 = GUICtrlCreateLabel("Round",$x1, 150 )
GUICtrlSetColor(-1, 0xffff00)
$l2 = GUICtrlCreateLabel($LEVEL&"!",$x2,150)
GUICtrlSetColor(-1, 0xffffff)
SoundPlay("sounds\interm.wav")
For $i = 0 to 7
	$x1 += 12
	$x2 -= 12
	GUICtrlSetPos($l1, $x1, 150)
	GUICtrlSetPos($l2, $x2, 150)
	sleep (50)
Next
sleep(1000)
GUIDelete($roundgui)
new_round(1)
IF $LEVEL_DEMO_MODE Then $delayitems.Add("endroundaction",4)
EndFunc


Func addpoints($points, $soundfile = "")
	$SCORE += $points
	GUICtrlSetData($guiscore, $SCORE)
	If $soundfile <> "" Then
		ctrlhide($PACID)
		$temp = GUICtrlCreateLabel($points, $PACPOS[0]-8, $PACPOS[1]-5,30,12,0x0200)
		GUICtrlSetColor(-1, 0xFFFFFF)
		GUICtrlSetFont(-1,8,600,-1,"Comic Sans" )
		$delayitems.Add( "ctrldel,"& $temp, 5)
		SoundPlay($soundfile,1)
		GUICtrlSetPos( $PACID, $PACPOS[0]-7, $PACPOS[1]-7)
	EndIf
	If $SCORE >= $SCORETOX Then extraguyaction()
EndFunc


Func CheckDots($x,$y)
If $x == 116 Then;		fruit
	If $y == 168 Then
		fruitaction()
		Return
	EndIf
EndIf
If Not Mod($x,8) == 0 Then Return
If Not Mod($y,8) == 0 Then Return
If $y == 144 Then;		tunnel
	If $x == -8 Then
		$PACPOS[0] = 232
	ElseIf $x == 232 Then
		$PACPOS[0] = -8
	EndIf
EndIf
$xystr = $x &","& $y
If $dotdic.Exists($xystr) Then;		dots
	$id = $dotdic.item($xystr)
	$dotdic.Remove($xystr)
;~ 	GUICtrlDelete($id)
		GUICtrlSetPos($id,0,-50)
	If ispower($x,$y) Then
		poweraction()
		addpoints(50)
	Else
		If TimerDiff( $SOUNDTIMER ) > 667 Then
;~ 			SoundPlay("sounds\pacchomp.wav")
			DllCall($sounddll, "int", "mciSendStringA", "str", "seek "& $openchomp &" to start", "str", "", "int", 65534, "hwnd", 0)
			DllCall($sounddll, "int", "mciSendStringA", "str", "play "& $openchomp, "str", "", "int", 65534, "hwnd", 0)
			$SOUNDTIMER = TimerInit()
		EndIf
		addpoints(10)
	EndIf
	If not $dotdic.Count Then endroundaction()
EndIf
;~ 	 KNOWN BUG 1. gets off track and stops before if turn is not avialable;; BUG BUG BUG !! PATCH THIS PLEASE!!!!
If $dirdic.Exists($xystr) Then
	$tomove = False
	$ONDOT = True
;~ 	$lastmoves = $PACMOVES
	$PACMOVES = $dirdic.Item($xystr)
	If Not $PACMOVES[$PACNOWMOVE] Then $PACNOWMOVE = 0
	If $PACMOVES[$PACNEXTMOVE] Then
		If $PACNOWMOVE <> $PACNEXTMOVE Then $tomove = True
		$PACNOWMOVE = $PACNEXTMOVE
		If $tomove Then pacmove()
	EndIf
EndIf
EndFunc


Func moveup()
allmoves(1)
EndFunc
Func moveright()
allmoves(2)
EndFunc
Func movedown()
allmoves(3)
EndFunc
Func moveleft()
allmoves(4)
EndFunc
Func allmoves($dir)
$PACNEXTMOVE = $dir
If $PACNOWMOVE == $dir Then Return
If canmove($PACNEXTMOVE) Then $PACNOWMOVE = $dir
EndFunc


Func canmove($dir)
If $ONDOT Then
	If $PACMOVES[$dir] Then Return 1
Else
	If isoppositedir($dir) Then Return 1
EndIf
EndFunc

Func isoppositedir($dir)
If $dir < 3 Then
	If $PACNOWMOVE == $dir+2 Then Return 1
Else
	If $PACNOWMOVE == $dir-2 Then Return 1
EndIf
EndFunc


Func pacmove()
;~ 	If $OFFTHEDOT Then
;~ 		$OFFTHEDOT = False
;~ 		If $PACNOWMOVE Then $PACMOVES = $DEFMOVES[$PACNOWMOVE]
;~ 	EndIf
	If Not $PACNOWMOVE Then Return
;~ 	$PACMOUTHC = Not $PACMOUTHC
;~ 	$PACMOUTHC += 1
;~ 	If $PACMOUTHC Then
;~ 	If $PACMOUTHC == 2 Then
	$PACMOUTH = Not $PACMOUTH
;~ 		$PACMOUTHC = False
;~ 		$PACMOUTHC = 0
;~ 	EndIf
	$PACPOS[0] += $GVELS[$PACNOWMOVE][0]*4
	$PACPOS[1] += $GVELS[$PACNOWMOVE][1]*4
	$ONDOT = False
	GUICtrlSetPos($PACID, 0, -50)
	$PACID = $PACBODY[$PACNOWMOVE * $PACMOUTH]
	GUICtrlSetPos($PACID, $PACPOS[0]-7, $PACPOS[1]-7)
	 ; why shud we change these every time. . asigning an array again and again for nothing.....
CheckDots($PACPOS[0],$PACPOS[1])
EndFunc









Func DragWindow()
$mpos = MouseGetPos()
$pos = WinGetPos($gui)
$WINPOS[0] = $mpos[0] - $pos[0]
$WINPOS[1] = $mpos[1] - $pos[1]
$dll = DllOpen("user32.dll")
do
	$pos = MouseGetPos()
	WinMove( $gui, '', $pos[0]-$WINPOS[0], $pos[1]-$WINPOS[1] )
	sleep(30)
	$ispressed = DllCall($dll, "int", "GetAsyncKeyState", "int", '0x01' )
Until @error or BitAND($ispressed[0], 0x8000) <> 0x8000
DllClose($dll)
EndFunc
Func ctrlhide($id)
	GUICtrlSetPos($id, 0, -50)
EndFunc
Func ctrldel($id)
	GUICtrlDelete($id)
EndFunc
Func adddelay($string, $time)
	If Not $delayitems.Exists($string) Then $delayitems.Add($string, $time)
EndFunc
;~ AdlibEnable("pacmove", $CURRENTSPEED)
Func checkdelays(); I guess we'll check this every 5 incriments (5 x 70 = 350 ms { ~ 1/3 sec })
	$delaytime -= 1
	If $delaytime > 0 Then Return
	$delaytime = 5
	If $delayitems.Count Then
		With $delayitems
		For $key in .Keys
			$t = .Item($key)
			$t -= 1
			If $t < 0 Then
				.Remove($key)
				$a = StringSplit($key, ",")
				If $a[0] == 1 Then
					Call ($key)
				Else
					Call($a[1], $a[2])
				EndIf
			Else
				.remove($key); .item(key) [= x] method doesn't work here . that's wierd
				.add($key,$t)
;~ 				.Item($key) = $t-1
			EndIf				
		Next
		EndWith
	EndIf
EndFunc


func _exit()
DllCall($sounddll, "int", "mciSendStringA", "str", "close " & $openchomp, "str", "", "int", 65534, "hwnd", 0)
DllClose($sounddll)
Exit
EndFunc
Func pause()
$ISPAUSED = Not $ISPAUSED
EndFunc
While 1
	sleep($CURRENTSPEED)
	If $ISPAUSED Then ContinueLoop
	pacmove()
	checkghosts()
	checkdelays()
;~ sleep (2000)
WEnd
;is 24-21,22
;ps 34

;Blinky ReDim
;Pinky Pink
;Inkey lt blue
;Clyde orange