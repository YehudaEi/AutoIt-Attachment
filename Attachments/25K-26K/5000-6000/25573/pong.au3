#include <guiconstants.au3>
#include <array.au3>
#include <misc.au3>
#include <_SpriteEngine.au3>
$score = 0
$gui = GUICreate("Pong Score: " & $score, 800, 600)
GUISetBkColor(0)
_SpriteInit($gui, 100, 120)
$ball = _SpriteCreate("red.bmp", 400 - (10 / 2), 600-50, 10, 10)
_SpriteSetMovement($ball, 8,67)
$bat1 = _SpriteCreate("blue.bmp", 400 - (50 / 2), 600-10-22, 50, 10)
_SpriteSetMovement($bat1,0,0)
$bat2 = _SpriteCreate("green.bmp",400 - (50 / 2),22,50,10)
_SpriteSetMovement($bat2,0,0)
Dim $bat1x = 250 - (50 / 2), $bat1y = 600 - 10 - 22
GUISetState()
While 1
	$mouse = GUIGetCursorInfo()
	If IsArray($mouse) Then
		$bat1x = $mouse[0]
		_SpriteSetCoords($bat1, $bat1x, $bat1y)
	EndIf
	Sleep(5)
	collisioncheck()
	$ballpos = _SpriteGetCoords($ball)
	$bat2pos = _SpriteGetCoords($bat2)
	if $ballpos[0] > $bat2pos[0] Then
		_SpriteSetMovement($bat2,7,90)
	Elseif $ballpos[0] < $bat2pos[0] then
		_SpriteSetMovement($bat2,7,-90)
	Else
		_SpriteSetMovement($bat2,0,0)
	EndIf
;~ 	_SpriteSetCoords($bat2,$ballpos[0],22)
	if $ballpos[1] <= 11 Then
		MsgBox(0,"","You ,get a point!")
		_SpriteSetCoords($ball,400 - (50 / 2), 450)
		_SpriteSetMovement($ball,8,4+random(0,70,1))
		$score+=1
		WinSetTitle($gui,"","Pong Score: " & $score)
	EndIf
	if $ballpos[1] >= 600-11 Then
		MsgBox(0,"","You ,loose a point!")
		_SpriteSetCoords($ball,400 - (50 / 2), 450)
		_SpriteSetMovement($ball,8,4+random(0,70,1))
		$score-=1
		WinSetTitle($gui,"","Pong Score: " & $score)
	EndIf
WEnd
Func collisioncheck()
	$collision = _SpriteCheckCollision($bat1, $ball)
	If $collision = 1 Then
		$ballcoords = _SpriteGetCoords($ball)
		$bat1coords = _SpriteGetCoords($bat1)
		$ballsize = _SpriteGetSize($ball)
		$bat1size = _SpriteGetSize($bat1)
		$ballmovement = _SpriteGetMovement($ball)
		If $ballcoords[0] > $bat1coords[0] Then
			_SpriteSetMovement($ball,8,110 + 80 * ($bat1coords[0] - $ballcoords[0]) / $bat1size[0])
			ConsoleWrite("1" & @CRLF)
		Else
			_SpriteSetMovement($ball,8,70 + 80 * ($bat1coords[0] - $ballcoords[0]) / $bat1size[1])
			ConsoleWrite("2" & @CRLF)
		EndIf
		If $ballcoords[1] > $bat1coords[1] Then
			_SpriteSetMovement($ball,8,360 - $ballmovement[1])
		EndIf
	EndIf
	$collision = _SpriteCheckCollision($bat2, $ball)
	If $collision = 1 Then
		$ballcoords = _SpriteGetCoords($ball)
		$bat2coords = _SpriteGetCoords($bat2)
		$ballsize = _SpriteGetSize($ball)
		$bat2size = _SpriteGetSize($bat2)
		$ballmovement = _SpriteGetMovement($ball)
		If $ballcoords[0] > $bat2coords[0] Then
			_SpriteSetMovement($ball,8,110 + 80 * ($bat2coords[0] - $ballcoords[0]) / $bat2size[0])
			ConsoleWrite("1" & @CRLF)
		Else
			_SpriteSetMovement($ball,8,70 + 80 * ($bat2coords[0] - $ballcoords[0]) / $bat2size[1])
			ConsoleWrite("2" & @CRLF)
		EndIf
		If $ballcoords[1] > $bat2coords[1] Then
			_SpriteSetMovement($ball,8,180 - $ballmovement[1])
		EndIf
	EndIf
EndFunc   ;==>collisioncheck2