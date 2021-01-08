#include <guiconstants.au3>
opt('guioneventmode',1)

guicreate('Hey!', 240,170)
;x1
$x1edit = guictrlcreateinput('', 0,0,50,20,$es_number)
guictrlcreatelabel('x1',50, 0,20,20) 
;y1
$y1edit = guictrlcreateinput('', 0,20,50,20,$es_number)
guictrlcreatelabel('y1',50,20,20,20) 

;x2
$x2edit = guictrlcreateinput('', 0,40,50,20,$es_number)
guictrlcreatelabel('x2',50, 40,20,20)
;y2 
$y2edit = guictrlcreateinput('', 0,60,50,20,$es_number)
guictrlcreatelabel('y2',50,60,20,20)

;button
$button = guictrlcreatebutton("Draw Line",0,82,70,20)

;canvas
$canvasLeft = 75
$canvasTop = 1
$canvasWidth = 150
$canvasHeight = 150
$test = guictrlcreatelabel('',$canvasLeft,$canvasTop,$canvasWidth,$canvasHeight,$ss_sunken)
$bg = guictrlcreatepic('blackdot.gif',$canvasLeft + 1,$canvasTop + 1,$canvasWidth - 3,$canvasHeight - 3)



guisetstate()
guisetonevent($gui_event_close,'close')
guictrlsetonevent($button,'drawline')


while 1
sleep(1000)
wend

func close()
exit
endfunc


func drawLine()
$x1 = guictrlread($x1edit)
$y1 = guictrlread($y1edit)
$x2 = guictrlread($x2edit)
$y2 = guictrlread($y2edit)
;find upper and lower y values
if $y1 < $y2 then
$lowerYValue = $y1
$upperYValue = $y2
endif

if $y1 > $y2 then
$upperYValue = $y1
$lowerYValue = $y2
endif

;find upper and lower x values
if $x1 < $x2 then
$lowerXValue = $x1
$upperXValue = $x2
endif

if $x1 > $x2 then
$upperXValue = $x1
$lowerXValue = $x2
endif

; draw vertical line
if $x1 = $x2 then
for $i = $lowerYValue to $upperYValue
plot($x1, $i,)
next
endif

;get slope
$slope = ($y2 - $y1) / ($x2 - $x1)

; draw other lines
for $currentX = $lowerXValue to $upperXValue
$currentY = $slope * ($currentX - $x1) + abs($y1)
plot($currentX, $currentY)
next

endfunc

func plot($x,$y)
$dot = guictrlcreatepic('whitedot.gif',$canvasLeft + 1 + $x,$canvasTop + 1 + $y,1,1)
guictrlsetstate($dot,$gui_show)
endfunc
