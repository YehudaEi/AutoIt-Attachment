#include <GUIConstants.au3>
#include <Prospeed.au3>

Opt("GUIOnEventMode", 1)
Opt("MouseCoordMode",2)
HotKeySet("{Esc}","_exit")

$NumOfSpr = 10
$EndDim = $NumOfSpr - 1
Dim $Copybee[$NumOfSpr]

$GUI = GUICreate("Prospeed",800,400,-1,-1,$WS_POPUP)
GUISetState()

Background(@scriptdir & "\back4.jpg", 0, 0, 800, 270)
Iniwater(270)

$Sprite1 = @scriptdir & "\Sprites.gif"

$bee1 = sprite($Sprite1, 0, 0, 24, 18, 4, 1, 6, 0, 0)

For $i = 1 to $EndDim
    $CopyBee[$i] = copysprite($bee1)
next

For $i = 1 to $EndDim
    SetSpriteAnimMove($Copybee[$i], 1, 0, 0)
    SetSpriteAnimMove($Copybee[$i], 2, 0, 0)
    SetSpriteAnimMove($Copybee[$i], 3, 0, 0)
    SetSpriteAnimMove($Copybee[$i], 5, 0, 32)
    SetSpriteAnimMove($Copybee[$i], 6, 0, 32)
    SetSpriteAnimMove($Copybee[$i], 7, 0, 32)
Next
	
	SetSpriteAnimMove($bee1, 1, 0, 0)
    SetSpriteAnimMove($bee1, 2, 0, 0)
    SetSpriteAnimMove($bee1, 3, 0, 0)
    SetSpriteAnimMove($bee1, 5, 0, 32)
    SetSpriteAnimMove($bee1, 6, 0, 32)
    SetSpriteAnimMove($bee1, 7, 0, 32)

For $i = 1 to $EndDim
   SetmovingRectangle($Copybee[$i], 0, 0, 800-24, 230)
next
SetmovingRectangle($bee1, 0, 0, 800-24, 230)

For $i = 1 to $EndDim
    SetSpriteMovingMode($Copybee[$i], 1)
next

For $i = 1 to $EndDim
    SetSpriteSpeed($Copybee[$i], 5, 3)
Next

For $i = 1 to $EndDim
    Movesprite($Copybee[$i], Random(0,800,1), Random(0,375,1))
    sleep(100)
next

For $i = 1 to $EndDim
    Movesprite($Copybee[$i], 850, Random(0,450,1))
    sleep(100)
next

$refresh = 1
While 1
	$refresh +=1
	Water(270)
	If $refresh = 70 Then
		For $i = 1 to $EndDim
			Movesprite($Copybee[$i],Random(0,850,1), Random(0,350,1))
			For $i = 1 to $EndDim
				SetSpriteSpeed($Copybee[$i], Random(1,6,1), Random(1,5,1))
			Next
		Next
	Movesprite($bee1,Random(0,850,1), Random(0,350,1))
	SetSpriteSpeed($bee1, Random(1,6,1), Random(1,5,1))
	$refresh = 1
	EndIf	
sleep(60)
WEnd

Func _exit()
Exit 
EndFunc