
#include <GUIConstantsEx.au3>
Global $xGrid[1][1] ; an array containing all the control ID's for each item, Ichigo's grid udf
Global $dungeonFloor[1][1] ;$dungeonFloor values may actually represent something other than floor (walls/black space/door), it would be more accurate the call it first layer (the only layer at this point)
Global $dungeonExplored[1][1] ;squares already seen are rememberd by the character, so theres a picture there according to the squares "floor" type (floor/wall/etc)
Global $dungeonMob[1][1] ;ids of mobs
Global $dungeonItems[1][1][20] ;to be implemented
Global $charpos[2] ;main chars xy
Global $images[3][100] ;collection of image paths used, 0 is black, 1 is default floor, 2 is default wall, 3 is our hero; needs to be split up to diffrent arrays for different types (floor/character/monster)
Global $monster, $floor ; values set by _getSquareType()
Global $mobs[100][10] ;identifiers of mobs, at each step they can move in a random direction, 0 is their number
Global $shownimage[1][1][2]
Global $seen[1][1]
Local $x, $y
;FileInstalls here
$maingui = GUICreate('game',900,550)
$textbox = GUICtrlCreateLabel("Welcome!.....................................................................",10,380,890,50)
$label = GUICtrlCreateLabel("",0,360,900,10)
GUICtrlSetBkColor($label,0x0F00FF)
$helpmenu = GUICtrlCreateMenu("Help")
$fileitem = GUICtrlCreateMenuItem("Info", $helpmenu)
GUICtrlSetState(-1, $GUI_DEFBUTTON)

$images[0][0]= @ScriptDir&"\Img\black.bmp"
$images[0][1]= @ScriptDir&"\Img\floor.bmp"
$images[0][2]= @ScriptDir&"\Img\wall.bmp"
$images[0][3]= @ScriptDir&"\Img\door.bmp"

$images[1][0]= @ScriptDir&"\Img\hero.bmp"
$images[1][1] = @ScriptDir&"\Img\mons1.bmp"
$images[1][2] = @ScriptDir&"\Img\mons2.bmp"
$images[1][3] = @ScriptDir&"\Img\ozze1.bmp"
$images[1][4] = @ScriptDir&"\Img\koponya1.bmp"

$images[2][1] = @ScriptDir&"\Img\lada1.bmp"
$images[2][2] = @ScriptDir&"\Img\címmerpajzs1.bmp"

_CreateLevel_Memory(50,20)
_CreateLevel_Gui(50, 20, 18, $maingui)
_RenderCharSur($charpos[0],$charpos[1])
GUISetState(@SW_SHOW)


 
HotKeySet("w","Test1")
HotKeySet("s","Test2")
HotKeySet("a","Test3")
HotKeySet("d","Test4")
HotKeySet("q","Test5")
HotKeySet("e","RenderImages")
 while 1
	#CS 
	Select
		Case _IsPressed(57)
		_MoveCharacter("up")
		;sleep(50)
		Case _IsPressed(41)
		_MoveCharacter("left")
		;sleep(50)
		Case _IsPressed(53) 
		_MoveCharacter("down")
		;sleep(50)
		Case _IsPressed(44)
		_MoveCharacter("right")
		;sleep(50)
		Case 1
		sleep(100)
	EndSelect
#ce
sleep(100)
WEnd
#Region ;Dungeon creation
Func _CreateLevel_Gui($x, $y, $size, $gui) ;visualization of the "dungeon" as a grid of pictures. Based on the Grid UDF made by Ichigo
	If $x < 0 or $y < 0 or $size < 0 then Return -1
	GUICtrlCreatePic($images[1][0], $charpos[0] * $size, $charpos[1] * $size, $size, $size)
	ReDim $xGrid[$x][$y]
	$bX = $x 
	$bY = $y
	
	GUISwitch($gui)
	For $x = 0 to $bX - 1
		For $y = 0 to $bY - 1
		if $dungeonExplored[$x][$y] = 0 then
			$xGrid[$x][$y] = GUICtrlCreatePic($images[0][0], $x * $size, $y * $size, $size, $size)			;most of the place is black...
			
		Else
			$xGrid[$x][$y] = GUICtrlCreatePic($images[0][0], $x * $size, $y * $size, $size, $size) ;however, a few blocks are already "seen" by the mainchar at startup
			_RenderGrid($x,$y)
		EndIf
		Next 
	Next 
	
	Return 1
EndFunc
Func _CreateLevel_Memory($sizex, $sizey) ;creating the floor and a little house/fort/whatever for the character to start in. Some algorith to generate a level goes here

ReDim $dungeonExplored[$sizex][$sizey]
ReDim $dungeonFloor[$sizex][$sizey]
ReDim $dungeonItems[$sizex][$sizey][20]
ReDim $dungeonMob[$sizex][$sizey]
ReDim $shownimage[$sizex][$sizey][2]
ReDim $seen[$sizex][$sizey]
$charpos[0] = 5 ;Random(1,10,1)
$charpos[1] = 1 ;Random(1,10,1)
_CreateRoom(0,0,$sizex,$sizey,0,0,0,0)
_CreateRoom(0,0,10,10,0,5,5,0)
_CreateRoom(9,4,10,3,4,1,0,0) ;folyosó
_CreateRoom(9,6,8,9,4,0,4,0) 
_CreateRoom(0,10,10,10,5,5,0,0)
_CreateRoom(9,14,10,3,0,1,4,0)
_CreateRoom(18,0,20,20,0,10,0,10) ;bigroom
_CreateRoom(25,8,5,5,0,2,0,2)
_CreateRoom(29,8,5,5,0,2,0,2)
_CreateRoom(33,8,5,5,0,2,0,2);kicsi
for $x=0 to $sizex -1
	for $y=0 to $sizey -1
		If $dungeonFloor[$x][$y] = 1 OR $dungeonFloor[$x][$y] = "" And 3 > Random(0,99,1) Then
		$type = Random(1,4,1)
        _SpawnMob($x,$y,$type)
		EndIf
		if $dungeonFloor[$x][$y] = "" Then ;this is needed so the default squre type wont override rooms/corridors created before
		$dungeonFloor[$x][$y] = 1 ;set everything to 1, walkable floor. 
		$dungeonExplored[$x][$y] = 0 ;nothing is explored yet
		EndIf
		$seen[$x][$y] = 0	
	Next
Next
EndFunc
Func _CreateRoom($startx, $starty, $sizex , $sizey, $fal1 = 0,$fal2 = 0,$fal3 = 0,$fal4 = 0) ;creates a square room. last variable is the side of the room to have its door on
$sizex -= 1 ;room dimensions corretion, so _CreateRoom(10, 10, 4 , 4) is a 4x4 room rather then a 5x5
$sizey -= 1
$x = $startx
for $y=$starty to $sizey + $starty ;top wall
	If $dungeonFloor[$x][$y] <> 3  Then
	$dungeonFloor[$x][$y] = 2
	$dungeonExplored[$x][$y] = 0
	EndIf
Next
for $x = $startx + 1 to $sizex + $startx ; everything else, walls on the starting and ending position
	$y=$starty
	If $dungeonFloor[$x][$y] <> 3 Then
	$dungeonFloor[$x][$y] = 2
	$dungeonExplored[$x][$y] = 0
	EndIf
		for $y=$starty + 1 to $sizey + $starty
		If $dungeonFloor[$x][$y] <> 3 Then
		$dungeonFloor[$x][$y] = 1
		$dungeonExplored[$x][$y] = 0
		EndIf
		Next
	$y=$sizey + $starty
	If $dungeonFloor[$x][$y] <> 3 Then
	$dungeonFloor[$x][$y] = 2
	$dungeonExplored[$x][$y] = 0
	EndIf
Next
$x = $startx + $sizex
for $y=$starty to $sizey + $starty	;bottom wall
	If $dungeonFloor[$x][$y] <> 3 Then
	$dungeonFloor[$x][$y] = 2
	$dungeonExplored[$x][$y] = 0
	EndIf
Next
    If ($fal1 > 0 And $dungeonFloor[$startx+ $fal1][$starty] <> 1) Then ;if top wall
        $dungeonFloor[$startx+ $fal1][$starty] = 3
    EndIf
    If ($fal2 > 0 And $dungeonFloor[$startx + $sizex][$starty+ $fal2] <> 1) Then ;if right wall
        $dungeonFloor[$startx + $sizex][$starty+ $fal2] = 3
    EndIf
    If ($fal3 > 0 And $dungeonFloor[$startx + $fal3][$starty+ $sizey] <> 1) Then ;if bottom wall
        $dungeonFloor[$startx+ $fal3][$starty + $sizey] = 3
    EndIf
    If ($fal4 > 0 And $dungeonFloor[$startx][$starty+ $fal4] <> 1) Then;if left wall
        $dungeonFloor[$startx][$starty+ $fal4] = 3
    EndIf
EndFunc
#EndRegion
#Region ;Mobz
Func _MobProp($id)
;some SQLite here?
EndFunc
Func _SpawnMob($x,$y,$type)
		Dim $loot1,$image,$hp
		$mobs[0][0] +=1
		$dungeonMob[$x][$y] = $mobs[0][0]
		$mobs[$mobs[0][0]][0] = $type ;type of the mob == number of the image that gets rendered
		$mobs[$mobs[0][0]][1] = $type;$name
		$mobs[$mobs[0][0]][2] = $x
		$mobs[$mobs[0][0]][3] = $y
		$mobs[$mobs[0][0]][4] =  Random(1,3,1);$hp
		$loot1 = Random(1,2,1)
		$mobs[$mobs[0][0]][5] = $loot1
		$mobs[$mobs[0][0]][6] = Random(1,5,1)
	EndFunc

Func _KillMob($id)
		$mobs[$id][0] = "" 
		$mobs[$id][4] = 0 ;hp
		$dungeonMob[$mobs[$id][2]][$mobs[$id][3]] = ""
		$dungeonItems[$mobs[$id][2]][$mobs[$id][3]][0] += 1
		$itemnumber = $dungeonItems[$mobs[$id][2]][$mobs[$id][3]][0]
		$dungeonItems[$mobs[$id][2]][$mobs[$id][3]][$itemnumber] = $mobs[$id][5]
		$mobs[$id][2] = -1
		$mobs[$id][3] = -1
		
	EndFunc
	
Func _HitMob($id)
	$mobs[$id][4] -= 1
	If $mobs[$id][4] = 0 Then _KillMob($id)
	EndFunc

Func _MobMove()
For $mob = 1 to $mobs[0][0]
	If $mobs[$mob][6] = "" OR $mobs[$mob][6] = 5 OR 20 > Random(0,99,1) then 
	$direction = Random(1,5,1)
	Else
	$direction = $mobs[$mob][6]
	EndIf
	$tempx = $mobs[$mob][2]
	$tempy = $mobs[$mob][3]
	If $tempx = -1 Then ContinueLoop ;halott szörnyek nem ugrálnak
	Switch $direction
		Case 1 ;"left"
			$left = _getSquareType($mobs[$mob][2] - 1,$mobs[$mob][3])  
			If $left = -1 Then $direction = Random(3,4,1)
			If $left = 1 And $floor = 2 Then $direction = Random(3,4,1)
			If $left = 1 AND $floor = 1 Then $mobs[$mob][2] -= 1
			If $left = 1 And $floor = 3  AND 101 > Random(1,100) Then  _OpenDoor($mobs[$mob][2] - 1,$mobs[$mob][3])
			If $left = 2 And $monster <> $mobs[$mob][0] Then _HitMob($monster)
		Case 2; "right"
			$right = _getSquareType($mobs[$mob][2] + 1,$mobs[$mob][3])  
			If $right = -1 Then $direction = Random(3,4,1)
			If $right = 1 And $floor = 2 Then $direction = Random(3,4,1)
			If $right = 1 AND $floor = 1 Then $mobs[$mob][2] += 1
			If $right = 1 And $floor = 3 AND 101 > Random(1,100) Then  _OpenDoor($mobs[$mob][2]+1,$mobs[$mob][3])
			If $right = 2 And $monster <> $mobs[$mob][0] Then _HitMob($monster)
		Case 3; "up"
			$up = _getSquareType($mobs[$mob][2] ,$mobs[$mob][3]- 1) 
			If $up = -1 Then $direction = Random(1,2,1)
			If $up = 1 And $floor = 2 Then $direction = Random(1,2,1)
			If $up = 1 AND $floor = 1 Then $mobs[$mob][3] -= 1
			If $up = 1 And $floor = 3 AND 101 > Random(1,100) Then  _OpenDoor($mobs[$mob][2],$mobs[$mob][3] - 1)
			If $up = 2 And $monster <> $mobs[$mob][0] Then _HitMob($monster)
		Case 4; "down"
			$down = _getSquareType($mobs[$mob][2],$mobs[$mob][3] + 1) 
			If $down = -1 Then $direction = Random(1,2,1)
			If $down = 1 And $floor = 2 Then $direction = Random(1,2,1)
			If $down = 1 AND $floor = 1 Then $mobs[$mob][3] += 1
			If $down = 1 And $floor = 3 AND 101 > Random(1,100) Then  _OpenDoor($mobs[$mob][2],$mobs[$mob][3]+1)
			If $down = 2 And $monster <> $mobs[$mob][0] Then _HitMob($monster)
		EndSwitch
	$mobs[$mob][6] = $direction
	$dungeonMob[$tempx][$tempy] = ""
	$dungeonMob[$mobs[$mob][2]][$mobs[$mob][3]] = $mob
	Next	
EndFunc
#EndRegion


Func _MoveCharacter($direction) ;Character tries to go in a certain direction.
	$temp = $xGrid[$charpos[0]][$charpos[1]] ;point where he tries to move from
	Switch $direction
		Case "left"
			$left = _getSquareType($charpos[0] - 1,$charpos[1])
			If $left = -1 Then Return 0
			If $left = 1 And $floor = 2 Then return 0
			If $left = 1 AND $floor = 1 Then $charpos[0] -= 1
			If $left = 1 And $floor = 3 Then  _OpenDoor($charpos[0] - 1,$charpos[1])
			If $left = 2 THen _HitMob($monster)
		Case "right"
			$right = _getSquareType($charpos[0] + 1,$charpos[1])
			If $right = -1 Then Return 0
			If $right = 1 And $floor = 2 Then return 0
			If $right = 1 AND $floor = 1 Then $charpos[0] += 1
			If $right = 1 And $floor = 3 Then  _OpenDoor($charpos[0]+1,$charpos[1])
			If $right = 2 THen _HitMob($monster)
		Case "up"
			$up = _getSquareType($charpos[0] ,$charpos[1]- 1)
			If $up = -1 Then Return 0
			If $up = 1 And $floor = 2 Then return 0
			If $up = 1 AND $floor = 1 Then $charpos[1] -= 1
			If $up = 1 And $floor = 3 Then  _OpenDoor($charpos[0],$charpos[1] - 1)
			If $up = 2 THen _HitMob($monster)
		Case "down"
			$down = _getSquareType($charpos[0],$charpos[1] + 1)
			If $down = -1 Then Return 0
			If $down = 1 And $floor = 2 Then return 0
			If $down = 1 AND $floor = 1 Then $charpos[1] += 1
			If $down = 1 And $floor = 3 Then  _OpenDoor($charpos[0],$charpos[1]+1)
			If $down = 2 THen _HitMob($monster)
		EndSwitch
_MobMove()
#cs
Switch $direction ;de-render monsters
	case "up"
		For $x = -3 to 3
		_RenderGrid($charpos[0]+$x,$charpos[1]+4, 3)
		Next
	case "down"
		For $x = -3 to 3
		_RenderGrid($charpos[0]+$x,$charpos[1]-4, 3)
		Next
	case "left"
		For $x = -3 to 3
		_RenderGrid($charpos[0]+4,$charpos[1]+$x, 3)
		Next
	case "right"
		For $x = -3 to 3
		_RenderGrid($charpos[0]-4,$charpos[1]+$x, 3)
		Next
EndSwitch

For $y = -1 to 1 ;render your new surroundings: set those squres to explored, and show their picture accoring to "floor" value
	for $x = -1 to 1
		;$temp = _getSquareType($charpos[0]-$x,$charpos[1]-$y)
		;sleep(50)
		_RenderGrid($charpos[0]-$x,$charpos[1]-$y)
	Next
Next
#ce
_RenderCharSur($charpos[0],$charpos[1])
EndFunc
#Region ;Render
Func _RenderRay($x,$y,$level,$dirx,$diry)
	;MsgBox(0,"Rayx:","xy"&$x&"-"&$y&"-"&$dirx&"-"&$diry)
	_RenderGrid($x,$y)
	if $y+$diry >= 0 And $y+$diry >=0 AND $x+$dirx < UBound($xGrid,1) AND $y+$diry < UBound($xGrid,2) AND $dungeonFloor[$x][$y] = 1 Then
	_RenderRay($x+$dirx,$y+$diry,$level,$dirx,$diry)
	EndIf
EndFunc
Func _RenderParent($x,$y,$level,$dirx,$diry)
	;MsgBox(0,"Px:","xy"&$x&"-"&$y&"-"&$dirx&"-"&$diry)
	_RenderGrid($x,$y)
	if $dungeonFloor[$x][$y] = 1 Then
	_RenderParent($x + $dirx ,$y +$diry,$level,$dirx,$diry)
	_RenderRay($x,$y,$level,$dirx,0)
	_RenderRay($x,$y,$level,0,$diry)
	EndIf
EndFunc
Func _RenderCharSur($x ,$y)
	;MsgBox(0,$x,$y)
	_RenderRay($x,$y,0,1,0)
		;MsgBox(0,$x,$y)
	_RenderRay($x,$y,0,0,1)
		;MsgBox(0,$x,$y)
	_RenderRay($x,$y,0,0,-1)
		;MsgBox(0,$x,$y)
	_RenderRay($x,$y,0,-1,0)
		;MsgBox(0,$x,$y)
	_RenderParent($x+1,$y+1,0,1,1)
	_RenderParent($x-1,$y+1,0,-1,1)
	_RenderParent($x+1,$y-1,0,1,-1)
	_RenderParent($x-1,$y-1,0,-1,-1)
;#ce
EndFunc
Func _getSquareType($x,$y) ;sets $floor to floor type and returns 1, or returns 2 and sets $monster id if a monster is there
If $y >= 0 And $x >=0 AND $x < UBound($xGrid,1) AND $y < UBound($xGrid,2) Then
	Select
		Case $x = $charpos[0] AND $y = $charpos[1]
			return 0			
		Case $dungeonMob[$x][$y] <> ""
			$monster = $dungeonMob[$x][$y]
			Return 2	
		Case $dungeonFloor[$x][$y] <> ""
			$floor = $dungeonFloor[$x][$y]
			return 1
		Case $dungeonItems[$x][$y] <> ""
			$floor = $dungeonFloor[$x][$y]
			return 1	
	EndSelect		
Else
	Return -1
EndIf
EndFunc
Func _RenderGrid($x,$y,$exclude = "")
If $y >= 0 And $x >=0 AND $x < UBound($xGrid,1) AND $y < UBound($xGrid,2) Then ;errors avoided
$img_f = $dungeonFloor[$x][$y]
$img_i = $dungeonItems[$x][$y][0]
$img_m = $dungeonMob[$x][$y]
If $exclude = 1 Then $img_f = ""
If $exclude = 2 Then $img_i = 0
If $exclude = 3 Then $img_m = ""
	Select
		case $x = $charpos[0] And $y = $charpos[1]
			IF 	$shownimage[$x][$y][0] = 1 And	$shownimage[$x][$y][1] = 0 Then Return 0
			GUICtrlSetImage($xGrid[$x][$y], $images[1][0])
			$shownimage[$x][$y][0] = 1
			$shownimage[$x][$y][1] = 0
			$seen[$x][$y]=1
			$dungeonExplored[$x][$y]=1
		case $img_m <> ""
			$img_m = $mobs[$img_m][0]
			If $shownimage[$x][$y][0] = 1 and $shownimage[$x][$y][1] = $img_m then Return 0
			GUICtrlSetImage($xGrid[$x][$y], $images[1][$img_m])
			$shownimage[$x][$y][0] = 1
			$shownimage[$x][$y][1] = $img_m
			$seen[$x][$y]=1
			$dungeonExplored[$x][$y]=1
		case $img_i <> 0
			$img_i = $dungeonItems[$x][$y][$img_i]
			 If $shownimage[$x][$y][0] = 2 and $shownimage[$x][$y][1] = $img_i then Return 0
			GUICtrlSetImage($xGrid[$x][$y], $images[2][$img_i])
			$shownimage[$x][$y][0] = 2
			$shownimage[$x][$y][1] = $img_i
			$seen[$x][$y]=1	
			$dungeonExplored[$x][$y]=1
		case $img_f <> ""
			If $shownimage[$x][$y][0] = 0 and $shownimage[$x][$y][1] = $img_f then Return 0
			GUICtrlSetImage($xGrid[$x][$y], $images[0][$img_f])
			$shownimage[$x][$y][0] = 0
			$shownimage[$x][$y][1] = $img_f
			$seen[$x][$y]=1
			$dungeonExplored[$x][$y]=1
	EndSelect
Else
return 0
EndIf
EndFunc
Func RenderImages() ;defunct
	$bX = UBound($xGrid,1) -1
	$bY = UBound($xGrid,2) -1
	For $x = 0 to $bX - 1
	For $y = 0 to $bY - 1
		if $dungeonExplored[$x][$y] = 0 then ContinueLoop
		if $seen[$x][$y] = 0 And $shownimage[$x][$y][0] <> 1 then ContinueLoop
		if $seen[$x][$y] = 0 And $shownimage[$x][$y][0] = 1 then
		MsgBox(0, "monstaderend", $x&"-"&$y)
		$img_f = $dungeonFloor[$x][$y]
		$img_i = $dungeonItems[$x][$y][0]
		Select
			case $img_i > 0
			$img_i = $dungeonItems[$x][$y][$img_i]
			GUICtrlSetImage($xGrid[$x][$y], $images[2][$img_i])
			$shownimage[$x][$y][0] = 2
			$shownimage[$x][$y][1] = $img_i
			case $img_f <> ""
			GUICtrlSetImage($xGrid[$x][$y], $images[0][$img_f])
			$shownimage[$x][$y][0] = 0
			$shownimage[$x][$y][1] = $img_f
		EndSelect
		ContinueLoop
		EndIf
		If  $shownimage[$x][$y][0] = 1 And $dungeonMob[$x][$y] = $shownimage[$x][$y][1] Then ContinueLoop ;MsgBox(0, "1", $x&"-"&$y);
		If  $shownimage[$x][$y][0] = 2 And $dungeonItems[$x][$y][$dungeonItems[$x][$y][0]] = $shownimage[$x][$y][1] Then ContinueLoop ;MsgBox(0, "2", $x&"-"&$y);
		If  $shownimage[$x][$y][0] = 0 And $dungeonFloor[$x][$y] = $shownimage[$x][$y][1] Then ContinueLoop	;MsgBox(0, "3", $x&"-"&$y);
		$a = $shownimage[$x][$y][0]
		$b = $shownimage[$x][$y][1]
		MsgBox(0, "1", $x&"-"&$y&"//"&$a&"-"&$b)
		GUICtrlSetImage($xGrid[$x][$y], $images[$a][$b])
	Next 
	Next 
EndFunc
#EndRegion

Func _OpenDoor($bX,$bY)
$kocka = Random(0,100,1) ;d100 dice to get success of door "opening" (right now: smashing)
Switch $kocka 
	Case 1 to 75 ; 3 out of 4, you fail
	return 0
	case 76 to 100 ;you smash the door
	$dungeonFloor[$bX][$bY] = 1 ;the door there is now a floor
	return 2 
EndSwitch
EndFunc

Func Test1()
	_MoveCharacter("up")
EndFunc
Func Test2()
	_MoveCharacter("down")
EndFunc
Func Test3()
	_MoveCharacter("left")
EndFunc
Func Test4()
	_MoveCharacter("right")
EndFunc
Func Test5()
	_RenderCharSur($charpos[0],$charpos[1])
EndFunc
Func _IsPressed($hexKey)
 ; $hexKey must be the value of one of the keys.
 ; _IsPressed will return 0 if the key is not pressed, 1 if it is.
 ; $hexKey should entered as a string, don't forget the quotes!
 ; (yeah, layer. This is for you)
 
  Local $aR, $bO
 
  $hexKey = '0x' & $hexKey
  $aR = DllCall("user32", "int", "GetAsyncKeyState", "int", $hexKey)
  If Not @error And BitAND($aR[0], 0x8000) = 0x8000 Then
     $bO = 1
  Else
     $bO = 0
  EndIf
 
  Return $bO
EndFunc  ;==>_IsPressed

#cs
  01 Left mouse button
  02 Right mouse button
  04 Middle mouse button (three-button mouse)
  05 Windows 2000/XP: X1 mouse button
  06 Windows 2000/XP: X2 mouse button
  08 BACKSPACE key
  09 TAB key
  0C CLEAR key
  0D ENTER key
  10 SHIFT key
  11 CTRL key
  12 ALT key
  13 PAUSE key
  14 CAPS LOCK key
  1B ESC key
  20 SPACEBAR
  21 PAGE UP key
  22 PAGE DOWN key
  23 END key
  24 HOME key
  25 LEFT ARROW key
  26 UP ARROW key
  27 RIGHT ARROW key
  28 DOWN ARROW key
  29 SELECT key
  2A PRINT key
  2B EXECUTE key
  2C PRINT SCREEN key
  2D INS key
  2E DEL key
  30 0 key
  31 1 key
  32 2 key
  33 3 key
  34 4 key
  35 5 key
  36 6 key
  37 7 key
  38 8 key
  39 9 key
  41 A key
  42 B key
  43 C key
  44 D key
  45 E key
  46 F key
  47 G key
  48 H key
  49 I key
  4A J key
  4B K key
  4C L key
  4D M key
  4E N key
  4F O key
  50 P key
  51 Q key
  52 R key
  53 S key
  54 T key
  55 U key
  56 V key
  57 W key
  58 X key
  59 Y key
  5A Z key
  5B Left Windows key
  5C Right Windows key
  60 Numeric keypad 0 key
  61 Numeric keypad 1 key
  62 Numeric keypad 2 key
  63 Numeric keypad 3 key
  64 Numeric keypad 4 key
  65 Numeric keypad 5 key
  66 Numeric keypad 6 key
  67 Numeric keypad 7 key
  68 Numeric keypad 8 key
  69 Numeric keypad 9 key
  6A Multiply key
  6B Add key
  6C Separator key
  6D Subtract key
  6E Decimal key
  6F Divide key
  70 F1 key
  71 F2 key
  72 F3 key
  73 F4 key
  74 F5 key
  75 F6 key
  76 F7 key
  77 F8 key
  78 F9 key
  79 F10 key
  7A F11 key
  7B F12 key
  7C-7F F13 key - F16 key
  80H-87H F17 key - F24 key
  90 NUM LOCK key
  91 SCROLL LOCK key
  A0 Left SHIFT key
  A1 Right SHIFT key
  A2 Left CONTROL key
  A3 Right CONTROL key
  A4 Left MENU key
  A5 Right MENU key
#ce	