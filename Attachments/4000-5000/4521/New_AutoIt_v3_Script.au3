#include <GUIConstants.au3>
    
$MAXGr=7
Global $a[$MAXGr+1] ; 0 and $MAXGr entries not used to allow GUICtrlDelete result
Global $child, $del

GUICreate("My Main", -1,-1,100,100)
$del1=GuiCtrlCreateButton("Delete", 50,200, 50)
GUISetState()
CreateChild()

$i=1
$inc=1
;$i=5   ; uncomment to delete starting from last define Graphic control
;$inc=-1

Do
    $msg = GUIGetMsg()
    if $msg= $del1 then Del()

    if $msg= $del then
        GuiCtrlDelete($a[$i])
        $i = $i+$inc
        if $i <0 OR $i>$MAXGr then exit
    EndIf
Until $msg=$GUI_EVENT_CLOSE

Func Del()
    GuiDelete($child)
    CreateChild()
EndFunc

Func CreateChild()
$child=GUICreate("My Draw")
$del=GuiCtrlCreateButton("Delete", 50,165, 50)

$a[1]=GuiCtrlCreateGraphic(20, 50, 100,100)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetColor(-1,0)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff0000,0xff0000)
GUICtrlSetGraphic(-1,$GUI_GR_PIE, 50,50, 40,30,270)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x00ff00,0xffffff)
GUICtrlSetGraphic(-1,$GUI_GR_PIE, 58,50, 40,-60,90)

GUICtrlSetGraphic(-1,$GUI_GR_ELLIPSE, 100,100, 50,80)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x00ff00,0xc0c0ff)
GUICtrlSetGraphic(-1,$GUI_GR_RECT, 350,200, 50,80)
GuiCtrlCreateLabel("label", 65, 100, 30)
GUICtrlSetColor(-1,0xff)

$a[2]=GuiCtrlCreateGraphic(220, 10, 100,100)

GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xff)
GUICtrlSetGraphic(-1,$GUI_GR_PIE, 50,50, 40,30,270)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x00ff00,0xffffff)
GUICtrlSetGraphic(-1,$GUI_GR_PIE, 58,50, 40,-60,90)

$a[3]=GuiCtrlCreateGraphic(220, 110, 100,100)
GUICtrlSetBkColor(-1,0xf08080)
GUICtrlSetColor(-1,0xff)
GUICtrlSetGraphic(-1,$GUI_GR_HINT, 1)

GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff00)
GUICtrlSetGraphic(-1,$GUI_GR_RECT, 50,50, 80,80)

$a[4]=GuiCtrlCreateGraphic(20, 200, 80,80)
GUICtrlSetBkColor(-1,0xffffff)
GUICtrlSetGraphic(-1,$GUI_GR_HINT, 1)

GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 10,10)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 30,40)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff00)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 70,70)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff0000)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 10,50)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xffff00)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 10,10)

$a[5]=GuiCtrlCreateGraphic(150, 10, 50,50)
GUICtrlSetBkColor(-1,0xa0ffa0)
GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 20,20)       ; start point
; it is better to draw line and after point
; to avoid to switch color at each drawing
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0x0000ff)
GUICtrlSetGraphic(-1,$GUI_GR_DOT, 30,30)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 20,40)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0xff0000)
GUICtrlSetGraphic(-1,$GUI_GR_DOT, 25,25)
GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 40,40)
GUICtrlSetGraphic(-1,$GUI_GR_DOT, 30,40)

$a[6]=GuiCtrlCreateGraphic(110, 260, 230,130)
GUICtrlSetColor(-1,0)                       ; to display a balck border line
GUICtrlSetBkColor(-1,0xc0c0ff)
GUICtrlSetGraphic(-1,$GUI_GR_HINT, 3)       ; to display control lines and end points

GUICtrlSetGraphic(-1,$GUI_GR_COLOR, 0, 0xff); fill in blue
GUICtrlSetGraphic(-1,$GUI_GR_MOVE, 120,20)      ; start point
GUICtrlSetGraphic(-1,$GUI_GR_BEZIER, 120,100, 200,20, 200,100)
GUICtrlSetGraphic(-1,$GUI_GR_BEZIER+$GUI_GR_CLOSE, 100,40, 40,100, 40,20)
GUICtrlSetGraphic(-1,$GUI_GR_LINE, 60,30)       ; start point

GuiSetState()
EndFunc

#cs
#include <GUIConstants.au3>

GUICreate ("Ben", 400, 400)
$img = GUICtrlCreatePic ("E:\Pictures\DSCF0002.JPG", 0, 0, 400, 400)
$size = 16
$label = GUICtrlCreateLabel ("This is some example text", 9, 9, 380, 40)
GUICtrlSetFont ($label, $size, 400)
$label = GUICtrlCreateLabel ("This is some example text", 9, 11, 380, 40)
GUICtrlSetFont ($label, $size, 400)
$label = GUICtrlCreateLabel ("This is some example text", 11, 11, 380, 40)
GUICtrlSetFont ($label, $size, 400)
$label = GUICtrlCreateLabel ("This is some example text", 11, 9, 380, 40)
GUICtrlSetFont ($label, $size, 400)
$label2 = GUICtrlCreateLabel ("This is some example text", 10, 10, 380, 40)
GUICtrlSetFont ($label2, $size, 400)
GUICtrlSetColor ($label2, 0xffffff)
GUISetState (@SW_SHOW)

Do
	$msg = GUIGetMsg ()
Until $msg = $GUI_EVENT_CLOSE
#ce