#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.2.0
 Author: Kivin
 Script Function: Custom copy progressbar to any Windows style
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
#include <GUIConstants.au3>
GUICreate ("Demo Progress", 300,150)
$Label = GUICtrlCreateLabel ("0%",130,100,100,25)

$width = 200
$height = 50
$RGB = "FF"
$color = "0x00" & $RGB &"00"
$Bgcolor = 0xffffff
$Step = 2
$Mindata = 0
$Maxdata = 200
$left = 50
$top = 50
$currentdata = 0

$l=$left
$t=$top
$W=round ($Step/($Maxdata-$Mindata)*$width,0)
$h=$height

GUISetState (@SW_SHOW)
Progress ($left,$top,$width,$height,$color,$Bgcolor,$Step)
Func Progress ($left,$top,$width,$height,$color,$Bgcolor,$Step)
	GUICtrlCreateGraphic ( $left,$top,$width,$height)
	GUICtrlSetBkColor(-1,$Bgcolor)
	$temp4 = $RGB
While $Maxdata>$currentdata
	GUICtrlCreateGraphic ( $l,$t,$W, $h)
	$temp1= Dec ($temp4)
	$temp2=$temp1-2
	$temp3 = Hex ( $temp2)
	$temp4 = $temp3
	GUICtrlSetBkColor(-1,"0x" & $temp3)
	$currentdata = $currentdata + $Step
	$procent = $currentdata/$Maxdata*100
	
	$l=$l+$W
		
	Sleep ( 50 )
	GUICtrlSetData ($Label ,$procent & " %")
WEnd
msgbox (0,"Information","Copy has finished!")
EndFunc

do
    $msg = GUIGetMsg()    
until $msg = $GUI_EVENT_CLOSE