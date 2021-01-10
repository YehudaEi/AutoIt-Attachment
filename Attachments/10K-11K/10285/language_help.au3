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

$1 = Random(1, 52)
$2 = Random(1, 12)
$3 = random(1, 29)
$ii = StringSplit("book /green /teddy /clock /imagination /can /rule /world /my /cow /gobble /food /often /sweet /banana /boat /cream /breaststroke /robyn /tom /sieve /face /left /right /center /back /front /derriere /crunchy /boat /persephone /The /every /One /Many /Turkey /Your /School /Big /Frank's /Cover /Fishes /Ice Cream /Blue /Red /Black /Wooden /Pomegranites /Teachers /Desks /Toilets /Banana /Bowling /Girls ", "/")
$mid = StringSplit("is French for /is German for /is Welsh for /is Italian for /is Dutch for /is Chinese for /is japanese for /is Scottish for /is Irish for /is dumb-speak for /is Owen Speak for /is Icelandic for /", "/")
$end = StringSplit("wall/angel/sailor/moon/blanket/Spanish/German/Wet/Margret/Geraniums/Sorry/Left/Right/Center/Drive/Head/Bag/Stuffing/Seeds/Cold/Scales/Pencil/Pen/Ruler/Skin/Lung/Ball/Friends/Fight", "/")

MsgBox(0, "", $ii[$1] & $mid[$2] & $end[$3])