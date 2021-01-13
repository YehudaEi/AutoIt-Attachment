;Mindreader by spyrorocks
#include <GUIConstants.au3>
$wait = 10
$Form1 = GUICreate("MindReader - By Spyrorocks", 529, 411, 209, 149)
$Group1 = GUICtrlCreateGroup("Numbers/Colors", 168, 80, 353, 321)
;$num_0 = GUICtrlCreateLabel("0", 464, 376, 26, 17, $SS_CENTER)
;$color_num_0 = GUICtrlCreateLabel("", 496, 376, 18, 17)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Group2 = GUICtrlCreateGroup("Your Color", 8, 80, 153, 153)
GUICtrlCreateGroup("", -99, -99, 1, 1)
$DispColor = GUICtrlCreateLabel("", 35, 110, 100, 100)
$doit = GUICtrlCreateButton("Read My Mind!", 32, 248, 107, 41, 0)
$newcolors = GUICtrlCreateButton("Refresh Colors", 32, 290, 107, 26, 0)
$Edit1 = GUICtrlCreateEdit("", 8, 0, 513, 81, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("MindReader Instructions\r\n\r\n1. Pick a 2 digit number (Such as 47)\r\n\r\n2. Add both of the digits togeather (Example: If you had 47, add 4 + 7 to get 11)\r\n\r\n3. Subtract what you got for adding the digits togeather from your origanal number.\r\n\r\nFocus on the color behind your new number, and click "&Chr(34)&"Read My Mind!"&Chr(34)&""))
GUISetState(@SW_SHOW)

createtables()

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
		case $newcolors
			deletetables()
			createtables()
		case $doit
			showit()

	EndSwitch
WEnd

func CreateTables()
b_disable()
$slide = 17
$thecolor = specialcolor()

for $i = 0 to 15
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 470 - $slide, execute("(368) - ("&$i&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 16 to 31
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 430 - $slide, execute("(368) - ("&$i-16&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 32 to 47
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 390 - $slide, execute("(368) - ("&$i-16*2&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 48 to 63
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 350 - $slide, execute("(368) - ("&$i-16*3&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 64 to 79
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 310 - $slide, execute("(368) - ("&$i-16*4&" * 17)"), 26, 17, $SS_CENTER), 2)
GUICtrlSetBkColor (-1, rancolor())
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 80 to 95
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 270 - $slide, execute("(368) - ("&$i-16*5&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait)
next

for $i = 96 to 99
Assign ( "num_"&$i, GUICtrlCreateLabel($i, 230 - $slide, execute("(113 + (3 * 17)) - ("&$i-16*6&" * 17)"), 26, 17, $SS_CENTER), 2)
if stringinstr(string($i/9), ".") then
GUICtrlSetBkColor (-1, rancolor())
else
GUICtrlSetBkColor (-1, $thecolor)
endif
sleep($wait+20)
next

global $Guessme = $thecolor
b_enable()
endfunc

func deletetables()
b_disable()
guictrldelete($dispcolor)
for $i = 0 to 100
GUICtrlDelete (eval("num_"&$i))
sleep($wait)
next
endfunc

func RanColor()
switch random(0, 12, 1)
	case 0
		return 0XFFFFFF
	case 1
		return 0x00FF00
	case 2
		return 0xFF0000
	case 3
		return 0x0000FF
	case 4
		return 0xF0F000
	case 5
		return 0xCCCCCC
	case 6
		return 0x99FF00
	case 7
		return 0xFF9900
	case 8
		return 0x0FF0F0
	case 9
		return 0x660000
	case 10
		return 0xFF66CC
	case 11
		return 0xCC33CC
	case 12
		return 0x669900

endswitch
ENDFUNC

func SpecialColor()
return RanColor()
endfunc

func ShowIt()
b_disable()
guictrldelete($dispcolor)
global $dispcolor = GUICtrlCreateLabel("", 35, 110, 100, 100)

;Little bit of show

for $i = 94 to 114
GUICtrlSetBkColor (-1, rancolor())
sleep($i*2)
next
GUICtrlSetBkColor (-1, $GUI_BKCOLOR_DEFAULT)
for $i = 0 to 5
sleep(100)
GUICtrlSetBkColor (-1, $GUI_BKCOLOR_DEFAULT)
sleep(100)
GUICtrlSetBkColor (-1, $guessme)
next
b_enable()
GUICtrlSetState ($doit, $GUI_DISABLE)
endfunc

func onautoitexit()
deletetables()
exit
endfunc

func b_disable()
GUICtrlSetState ($doit, $GUI_DISABLE)
GUICtrlSetState ($newcolors, $GUI_DISABLE)
endfunc

func b_enable()
GUICtrlSetState ($doit, $GUI_ENABLE)
GUICtrlSetState ($newcolors, $GUI_ENABLE)
endfunc