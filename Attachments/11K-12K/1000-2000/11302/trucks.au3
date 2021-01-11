#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
Opt("TrayIconHide", 0)
Opt("GUICloseOnESC", 1)

$top1 = Random(10, @DesktopHeight - 60)
Do
	$top2 = Random(10, @DesktopHeight-60)
Until $top2 < ($top1-60) OR $top2 > ($top1+60)
Do
	$top3 = Random(10, @DesktopHeight-60)
Until ($top3 < ($top1-60) OR $top3 > ($top1+60)) AND ($top3 < ($top2-60) OR $top3 > ($top2+60))

$speed = 90 ; range from 1 to 100

$GUI = GUICreate("                      ", @DesktopWidth+5, @DesktopHeight, 0, 0, $WS_POPUP, BitOr($WS_EX_TOPMOST, $WS_EX_TOOLWINDOW))
GUISetBkColor("0x000000")
GUISetCursor(16, 1)

$truck1 = GUICtrlCreateLabel("|^^^^^^^^^^^^^||_____"&@CRLF&"|.                             | ||'""|""\_ _"&@CRLF&"| __                  __ l ||__|__|__|)"&@CRLF&"|(@)(@)****(@)(@)****|(@)**(@)", 10, $top1)
GUICtrlSetColor($truck1, "0xffff00")

$truck2 = GUICtrlCreateLabel("|^^^^^^^^^^^^^||_____"&@CRLF&"|.                             | ||'""|""\_ _"&@CRLF&"| __                  __ l ||__|__|__|)"&@CRLF&"|(@)(@)****(@)(@)****|(@)**(@)", @DesktopWidth/2, $top2)
GUICtrlSetColor($truck2, "0xff0000")

$truck3 = GUICtrlCreateLabel("|^^^^^^^^^^^^^||_____"&@CRLF&"|.                             | ||'""|""\_ _"&@CRLF&"| __                  __ l ||__|__|__|)"&@CRLF&"|(@)(@)****(@)(@)****|(@)**(@)", @DesktopWidth/4, $top3)
GUICtrlSetColor($truck3, "0x00ff00")

$speed1 = GUICtrlCreateLabel($speed * 5 & " pixel/sec", 5, 5, 100, 20)
GUICtrlSetColor($speed1, "0xffff00")
GUICtrlSetBkColor($speed1, $GUI_BKCOLOR_TRANSPARENT)

$speed2 = GUICtrlCreateLabel($speed * 6 & " pixel/sec", 5, 25, 100, 20)
GUICtrlSetColor($speed2, "0xff0000")
GUICtrlSetBkColor($speed2, $GUI_BKCOLOR_TRANSPARENT)

$speed3 = GUICtrlCreateLabel($speed * 4 & " pixel/sec", 5, 45, 100, 20)
GUICtrlSetColor($speed3, "0x00ff00")
GUICtrlSetBkColor($speed3, $GUI_BKCOLOR_TRANSPARENT)

GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")

GUISetState()

$left1 = 15
$left2 = @DesktopWidth/2 + 5
$left3 = @DesktopWidth/4
While 1
	sleep(1000/$speed)
	GUICtrlSetPos($truck1, $left1, $top1)
	GUICtrlSetPos($truck2, $left2, $top2)
	GUICtrlSetPos($truck3, $left3, $top3)
	$left1 += 5
	$left2 += 6
	$left3 += 4
	If $left1 > (@DesktopWidth - 20) Then
		$left1 = -120
		Do
	        $top1 = Random(10, @DesktopHeight-60)
        Until ($top1 < ($top2-60) OR $top1 > ($top2+60)) AND ($top1 < ($top3-60) OR $top1 > ($top3+60))
	EndIf
	If $left2 > (@DesktopWidth - 20) Then
		$left2 = -120
		Do
			$top2 = Random(10, @DesktopHeight-60)
        Until ($top2 < ($top1-60) OR $top2 > ($top1+60)) AND ($top2 < ($top3-60) OR $top2 > ($top3+60))
	EndIf
	If $left3 > (@DesktopWidth - 20) Then
		$left3 = -120
		Do
			$top3 = Random(10, @DesktopHeight-60)
        Until ($top3 < ($top1-60) OR $top3 > ($top1+60)) AND ($top3 < ($top2-60) OR $top3 > ($top2+60))
	EndIf
WEnd

Func _exit()
	Exit
EndFunc

