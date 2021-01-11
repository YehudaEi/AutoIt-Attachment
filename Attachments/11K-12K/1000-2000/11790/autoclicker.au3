opt("TrayIconDebug",1)
Opt("GUICoordMode",2)
Opt("GUIResizeMode", 0)
Opt("GUIOnEventMode", 1)   
Global $X1,$X2,$Y1,$y2,$pxcolor,$click=0,$L,$T,$R,$B,$CLICKDELAY=5000,$CLICKDELAY2=5000
Global $size[4],$size2[4]
$size2[0]="100"
$size2[1]="100"
$size2[2]="-1"
$size2[3]="-1"

$size[0]="100"
$size[1]="100"
$size[2]="-1"
$size[3]="-1"
#include <GUIConstants.au3>
#include-once
; code
while 1
HotKeySet("!{Esc}", "_quit")
HotKeySet("{PRINTSCREEN}","_jbwin")
HotKeySet("{scrolllock}","_getcolor")
HotKeySet("{F1}", "_stopclick")
HotKeySet("{F2}", "_clickcolor")
HotKeySet("{F3}", "_clickspot")
HotKeySet("+{F1}", "_setclick")
Select
    Case $click = 0
        
    Case $click = 1
		_clickspot()
    Case $click = 2
		_clickcolor()
	Case $click = 3
		
	Case $click = 4
		
	Case Else
        MsgBox(0, "", "No preceding case was true!")
EndSelect
sleep(100)
WEnd
; functions
func _stopclick()
tooltip("Idel Nothing To Do",0,0)
	$click = 0
EndFunc
func _setclick()
$answ=InputBox("Set Mouse Delay","1000 = 1 sec")
$CLICKDELAY=$answ
EndFunc
func _clickcolor()
$click = 2
$coord = PixelSearch($L, $T,$R ,$B , $pxcolor,2 )
If Not @error Then
MouseMove($coord[0],$coord[1],1)
tooltip($pxcolor &" found",0,0)
MouseClick("left")
sleep($CLICKDELAY)
Else
tooltip($pxcolor &" notfound",0,0)
sleep(500)
endif
EndFunc
func _setclick2()
$answ=InputBox("Set Mouse Delay","1000 = 1 sec")
$CLICKDELAY2=$answ
EndFunc
func _clickcolor()
$click = 2
$coord = PixelSearch($L, $T,$R ,$B , $pxcolor2,2 )
If Not @error Then
MouseMove($coord[0],$coord[1],1)
tooltip($pxcolor3 &" found",0,0)
MouseClick("left")
sleep($CLICKDELAY2)
Else
tooltip($pxcolor2 &" notfound",0,0)
sleep(500)
endif
EndFunc

func _clickspot()
tooltip("Click Spot",0,0)
$click = 1
MouseClick("left")
sleep($CLICKDELAY)
endfunc

func _jbwin()
tooltip("Resize and postion window for pixel search",0,0)	
if WinExists ("jbwin")Then
	 GUIDelete("jbwin")
endif
$window = GUICreate("jbwin",100,100,-1,-1,$WS_SIZEBOX,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)
WinSetTrans ( "jbwin", "", 75)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetState(@SW_SHOW)
While 1
 $msg = GUIGetMsg()
 If $msg = "SpecialEvents" Then ExitLoop
Sleep(10)
Wend
EndFunc
Func SpecialEvents()
                $size=WinGetPos("jbwin","")
				$L=$size[0]
				$T=$size[1]
				$R=$size[2]+$size[0]
				$B=$size[3]+$size[1]
				GUIDelete()
				ToolTip("size set two "& $l&" " & $T&" " & $R&" " & $B&" ",0,0)
EndFunc
func _jbwin2()
tooltip("Resize and postion window for pixel search",0,0)	
if WinExists ("jbwin")Then
	 GUIDelete("jbwin")
endif
$window2 = GUICreate("jbwin2",100,100,-1,-1,$WS_SIZEBOX,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)
WinSetTrans ( "jbwin2", "", 75)
GUISetOnEvent($GUI_EVENT_CLOSE, "SpecialEvents")
GUISetState(@SW_SHOW)
While 1
 $msg = GUIGetMsg()
 If $msg = "SpecialEvents" Then ExitLoop
Sleep(10)
Wend
EndFunc
Func SpecialEvents()
                $size=WinGetPos("jbwin","")
				$L=$size[0]
				$T=$size[1]
				$R=$size[2]+$size[0]
				$B=$size[3]+$size[1]
				GUIDelete()
				ToolTip("size set two "& $l&" " & $T&" " & $R&" " & $B&" ",0,0)
EndFunc
Func SpecialEvents2()
                $size=WinGetPos("jbwin","")
				$L2=$size2[0]
				$T2=$size2[1]
				$R2=$size2[2]+$size2[0]
				$B2=$size2[3]+$size2[1]
				GUIDelete()
				ToolTip("size set two "& $l2&" " & $T2&" " & $R2&" " & $B2&" ",0,0)
EndFunc

Func colorwin()
GUIDelete("color")
EndFunc
func _getcolor()
if WinExists ("color")Then
	 GUIDelete("color")
endif
$pos = MouseGetPos()
$pxcolor=PixelGetColor ( $pos[0] , $pos[1] )
$pxcolor="0x"&Hex($pxcolor, 6)
tooltip("Set pixel Color "&$pxcolor,0,0)
$window1 = GUICreate("color",60,40,0,15,$WS_SIZEBOX,$WS_EX_TOOLWINDOW+$WS_EX_TOPMOST)
GUISetOnEvent($GUI_EVENT_CLOSE, "colorwin")
GUISetState(@SW_SHOW)
GUISetBkColor($pxcolor)
EndFunc			

;***************************
Func OnAutoItStart()

EndFunc
Func _quit()
	exit
EndFunc
;***************************