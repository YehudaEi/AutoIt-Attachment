#include <GUIConstants.au3>
#include <Misc.au3>
#include <Array.au3>

Opt("GUIOnEventMode", 1)
;Opt("GUICloseOnESC", 0) 

$dll = DllOpen("user32.dll")

global $arrows = 0

global $arrow[10]
global $arrowx[10]
global $arrowy[10]

;$arrowx[1]=15
;$arrowy[1]=30
global $arrows = 0

global $title="blob crumbler"
GUICreate($title,410,420)

GUICtrlCreateGroup("", 4, 4, 400, 410)

GUICtrlCreateGroup("", -99, -99, 1, 1)  ;close group
GUISetState()

GUISetOnEvent($GUI_EVENT_CLOSE, "Quit")


Dim $buttons[52][52]

;sleep(50);sleep to emphasise the order the arrays are created
for $i = 0 to 52-1
for $j = 0 to 52-1
    $top  = 7.5*$j+7.5
    $left = 7.5*$i+7.5
    $buttons[$j][$i] = GUICtrlCreatepic("blank.gif",$top,$left,8,8)
    GuiCtrlSetOnEvent($Buttons[$j][$i], "Foo")
    
; Remember to subtract $buttons[0][0] which is the value of the first GuiID AutoIt chooses to assign,
; so that the labels start at index 0
   ;GuiCtrlSetData($buttons[$i][$j], $buttons[$i][$j]- $buttons[0][0])

next
next

$x = 5
$y = 10

$x2 = 5
$y2 = 10

$wait = 10

$xmin = 5
$ymin = 10

$xlimit = 580
$ylimit = 490

$xmultiply = 10
$ymultiply = 10

$arrowspeed=2

$xmulitply = $xmultiply * $wait
$ymulitply = $ymultiply * $wait

$arrowspeed*=$ymultiply

$xlimit = $xlimit - $xmin
$ylimit = $ylimit - $ymin

$xlim=$xlimit
$ylim=$xlimit

$xlimit = $xlimit / $xmultiply
$ylimit = $ylimit / $ymultiply

$xmin = $xmin / $xmultiply
$ymin = $ymin / $ymultiply

$x = $x / $xmultiply
$y = $y / $ymultiply

$x2 = $x2 / $xmultiply
$y2 = $y2 / $ymultiply

$multi = 1

$players=2
dim $d[$players] [4]


$p=1 
;------- Player 1 ------------

$d[$p][0] = 41 ; a
$d[$p][1] = 44 ;d
$d[$p][2] = 57 ; w
$d[$p][3] = 53 ; s

;------- Player 2 ------------
$p+=1

$d[$p][0] = 41 ; a
$d[$p][1] = 44 ;d
$d[$p][2] = 57 ; w
$d[$p][3] = 53 ; s


HotKeySet("{space}", "onspace")

	$lastxm=""
	$lastym=""

While 1

traytip("Arrows", $arrows,10,16)
	$now=0
	$arrows2=$arrows
	;$arrowmax=_ArrayMaxIndex ($arrowx,1)
	;if $arrowmax >$arrows2 then $arrows2=$arrowmax
	while $arrows2>$now
		$arrowx[$now]+=$arrowspeed
		;msgbox(0,"","Now:" & $now & " - X pos: " & $arrowx[$now])
		if $arrowx[$now]> $xlim then
			GUICtrlDelete($arrow[$now])
			_ArrayDelete ( $arrow,$now)
			_ArrayDelete ( $arrowx,$now)
			_ArrayDelete ( $arrowy,$now)
			$arrows-=1
traytip("Deleted",".",10,16)
		else
			if $arrow[0]<>"" then GUICtrlSetPos($arrow[$now],$arrowx[$now],$arrowy[$now])
		endif
		$now+=1
	wend

	onplayer1 ()
	onplayer2()
	Sleep($wait)
	
WEnd

$player2 = GUICtrlCreatePic("linkhead2.jpg", 5, 5, 15, 15)

Func onplayer() ;======== PLAYERS ==================

	If $multi = 0 Then
		Select
			Case _IsPressed ("25", $dll) ; left
				$x -= 1
			Case _IsPressed ("27", $dll)   ; right
				$x += 1
			Case _IsPressed ("26", $dll)   ; up
				$y -= 1
			Case _IsPressed ("28", $dll)   ; down
				$y += 1
		EndSelect
	Else
		If _IsPressed ("25", $dll) then	$x -= 1  ; left
		If _IsPressed ("27", $dll) Then $x += 1 ; right
		If _IsPressed ("26", $dll) Then $y -= 1 ; up
		If _IsPressed ("28", $dll) then	$y += 1   ; down
		
	EndIf
	
	If $x > $xlimit Then $x = $xlimit
	If $y > $ylimit Then $y = $ylimit
	
	If $x < $xmin Then $x = $xmin
	If $y < $ymin Then $y = $ymin
	
	$xm = $x * $xmultiply
	$ym = $y * $ymultiply
	
	If $xm<>$lastxm OR $ym<>$lastym Then 
		GUICtrlSetImage ($buttons[$lastyx][$lastym],"blank.jpg")
		$lastxm=$xm
		$lastym=$ym
		GUICtrlSetImage ($buttons[$lastyx][$lastym],"linkhead.bmp")
	endif
EndFunc   ;==>

Func onspace()
	if $arrows<10 then
		$now=0
		$fire = 1
		_ArrayAdd($arrowx,15)
		_ArrayAdd($arrowy,50)
		_ArrayAdd($arrow, GUICtrlCreatePic("arrowright.gif", $arrowx[$arrows], $arrowy[$arrows], 15, 15))
		guictrlsetonevent(-1,"onclick")
		$arrows += 1
	endif
EndFunc   ;==>onspace

func onclick()
   
	;$array=_ArrayToString ($arrow, "|",-1,-1)
	 ;   MsgBox(4096,"Place",@GUI_CtrlId & @CRLF &$array & @ERROR)
	_arraydisplay($arrow,"arrows")
	_arraydisplay($arrowx,"x")
	_arraydisplay($arrowy,"y")
endfunc


func Foo()
; Get the flat index which is a number between 0 and 728 (inclusive)
    $index = @GUI_CtrlId - $buttons[0][0]
    GuiCtrlSetData(@Gui_CtrlID, "X");mark the clicked button
    
    $row = Int($index / 9)
    $col = Mod($index, 9) 

    MsgBox(1096,"Place",$index & " - " & $row & "," & $col)
EndFunc

Func Quit()
	Exit
EndFunc   ;==>Quit


