global $Paused,$b,$c=0

HotKeySet("+a", "terminat")
HotKeySet("+z", "pause")

while $c=0
$d=0
sleep (2000)

WinSetOnTop("OZ Interface", "", 1)
WinActivate ("OZ Interface")
$size = WinGetPos("OZ Interface")
fish()
WEnd

func fish()


$var = PixelGetColor( $size[0]+91 , $size[1]+146 )

while $var=3211280 
send("{ALT}")
sleep(1000)
$var = PixelGetColor( $size[0]+91 , $size[1]+146 )

WEnd

$var = PixelGetColor( $size[0]+80 , $size[1]+120 )


while $var=10267350
$var = PixelGetColor( $size[0]+80 , $size[1]+120 )
WEnd

while $var<>10267350
	
$var = PixelGetColor( $size[0]+80 , $size[1]+120 )
sleep(250)
send("{ALT}")

WEnd


sleep(2000)
$var = PixelGetColor( $size[0]+86 , $size[1]+151 )

while $var=8121343
$var = PixelGetColor( $size[0]+86 , $size[1]+151 )
sleep(150)
send("{ALT}")
WEnd
endfunc

Func Terminat()
    Exit 0
EndFunc


Func pause()
    $Paused = NOT $Paused
    While $Paused
if $b=0 then
$b=1
endif
 sleep(100)
        ToolTip('Shift-Z for continue,Shift-A For Quit',0,0)
WEnd
    ToolTip("")
    $b=0
EndFunc
