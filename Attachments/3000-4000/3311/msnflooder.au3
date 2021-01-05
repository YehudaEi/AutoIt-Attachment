#include <GuiConstants.au3>


GuiCreate("MSN Flooder 1.0", 353, 117,(@DesktopWidth-353)/2, (@DesktopHeight-117)/2 , $WS_OVERLAPPEDWINDOW + $WS_VISIBLE + $WS_CLIPSIBLINGS)
GuiSetIcon(@SystemDir & "\sndrec32.exe", 0)
GUICtrlSetColor(-1,0xff0000) 

$flood= GuiCtrlCreateButton("Spam", 150, 40, 80, 40)
$close = GuiCtrlCreateButton("Exit", 260, 40, 80, 40)
$ftext = GuiCtrlCreateInput("Text To Spam", 20, 10, 320, 20)
$amount = GuiCtrlCreateInput("Seconds To Spam)", 20, 40, 95, 40)
$Label_5 = GuiCtrlCreateLabel("MSN Spammer By Canada369", 100, 90, 150, 20)

GuiSetState()

While 1
	$msg = GUIGetMsg()
	

	Select
		Case $msg = $GUI_EVENT_CLOSE Or $msg = $close
			ExitLoop
                
			Case $msg = $flood
				$text = GUICtrlRead($ftext)
                        Msgbox(0, "Info", "You have 2 seconds to get to the msn window, then it will flood 20 times")
						sleep("2000")
						$t = GUICtrlRead($amount)
						 $timer = TimerInit()
Do
 send($text & "{ENTER}")
Until (TimerDiff($timer)/1000) > $t 
						send("MSN Spammer Made By Canada369 And thx to Semanuk for the help!" & "{ENTER}")
			
	EndSelect
WEnd