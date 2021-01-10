; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.1.0
; Author:         A.N.Other <myemail@nowhere.com>
;
; Script Function:
;	Template AutoIt script.
;
; ----------------------------------------------------------------------------

; Script Start - Add your code below here

$1 = Random(1, 22)
$2 = Random(1, 20)
$3 = random(1, 24)
$ii = StringSplit("The /One /Many /Turkey /Your /School /Big /Frank's /Cover /Fishes /Ice Cream /Blue /Red /Black /Wooden /Pomegranites /Teachers /Desks /Toilets /Banana /Bowling /Girls ", "/")
$mid = StringSplit("Dogs /Cats /Rain /Flush /is French for /Like /Coffee /Chocolate /Wine /Seat /Car /Brush /Hairdryer /book /notepad /Sea /Iraq /Iran /See /Wallet ", "/")
$end = StringSplit("is Spanish/is German/is Wet/is called Margret/Geraniums/Sorry/Left/Right/Center/Drive/Head/Bag/Stuffing/Seeds/Cold/Scales/Pencil/Pen/Ruler/Skin/Lung/Ball/Friends/Fight", "/")

MsgBox(0, "", $ii[$1] & $mid[$2] & $end[$3])