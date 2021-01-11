#include <GUIConstants.au3>
Opt("GUIOnEventMode", 1)
$Form1 = GUICreate("AForm1", 622, 448, 192, 125)
GUISetOnEvent($GUI_EVENT_CLOSE, "CLOSE")
$progbar_labback = GUICtrlCreateLabel("",60,17,104,18,$WS_THICKFRAME+$SS_SUNKEN)
GuiCtrlSetState($progbar_labback,$GUI_DISABLE)
GUICtrlSetBkColor($progbar_labback,0x003322)
$progbar_lab = GUICtrlCreateLabel("",60,15,10,17)
GUICtrlSetFont($progbar_lab,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab,"bar_set1")
GUICtrlSetColor($progbar_lab,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab2 = GUICtrlCreateLabel("",70,15,10,17)
GUICtrlSetFont($progbar_lab2,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab2,"bar_set2")
GUICtrlSetColor($progbar_lab2,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab3 = GUICtrlCreateLabel("",80,15,10,17)
GUICtrlSetFont($progbar_lab3,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab3,"bar_set3")
GUICtrlSetColor($progbar_lab3,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab4 = GUICtrlCreateLabel("",90,15,10,17)
GUICtrlSetFont($progbar_lab4,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab4,"bar_set4")
GUICtrlSetColor($progbar_lab4,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab5 = GUICtrlCreateLabel("",100,15,10,17)
GUICtrlSetFont($progbar_lab5,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab5,"bar_set5")
GUICtrlSetColor($progbar_lab5,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab6 = GUICtrlCreateLabel("",110,15,10,17)
GUICtrlSetFont($progbar_lab6,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab6,"bar_set6")
GUICtrlSetColor($progbar_lab6,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab7 = GUICtrlCreateLabel("",120,15,10,17)
GUICtrlSetFont($progbar_lab7,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab7,"bar_set7")
GUICtrlSetColor($progbar_lab7,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab8 = GUICtrlCreateLabel("",130,15,10,17)
GUICtrlSetFont($progbar_lab8,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab8,"bar_set8")
GUICtrlSetColor($progbar_lab8,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab9 = GUICtrlCreateLabel("",140,15,10,17)
GUICtrlSetFont($progbar_lab9,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab9,"bar_set9")
GUICtrlSetColor($progbar_lab9,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$progbar_lab10 = GUICtrlCreateLabel("",150,15,10,17)
GUICtrlSetFont($progbar_lab10,15,500,1,"wingdings")
GUICtrlSetOnEvent($progbar_lab10,"bar_set10")
GUICtrlSetColor($progbar_lab10,0xff0000)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$btn2 = GUICtrlCreateButton("start",180,100,60,20)
GUICtrlSetOnEvent($btn2,"start")
$btn3 = GUICtrlCreateButton("stop",250,100,60,20)
GUICtrlSetOnEvent($btn3,"stop")
$progbar_label = GUICtrlCreateLabel("",10,10,40,20)


$sliderback = GUICtrlCreateLabel("",249,49,257,22,$WS_THICKFRAME+$SS_SUNKEN)
GUICtrlSetBkColor(-1,0x003322)
GUICtrlSetOnEvent($sliderback,"click")
$slider = GUICtrlCreateLabel("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||",252,51,10,16)
GUICtrlSetFont($slider,9,500)
GUICtrlSetBkColor($slider,0x003322)
GUICtrlSetColor($slider,0x003322)
;$slider = GUICtrlCreateButton("",325,43,10,25)

$label_pos = GUICtrlCreateLabel("",300,300,60,20)
$label_value = GUICtrlCreateLabel("",520,50,60,20)
$value_start = 445
$value_end = 687
GUISetState(@SW_SHOW)

$y = 0
$song_time = 355

While 1
	$pos = MouseGetPos()
	GUICtrlSetData($label_pos, $pos[0] & "," & $pos[1])
	If $y = 1 Then
		For $i = 0 To $song_time Step 1
				Select
					Case $i = $song_time
						$y = 0
						ExitLoop
					Case $i = Int($song_time/10)
						bar_sett()
						GUICtrlSetPos($slider,252,52,255/10,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*2)
						bar_sett2()
						GUICtrlSetPos($slider,252,52,255/10*2,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*3)
						bar_sett3()
						GUICtrlSetPos($slider,252,52,255/10*3,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*4)
						bar_sett4()
						GUICtrlSetPos($slider,252,52,255/10*4,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*5)
						bar_sett5()
						GUICtrlSetPos($slider,252,52,255/10*5,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*6)
						bar_sett6()
						GUICtrlSetPos($slider,252,52,255/10*6,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*7)
						bar_sett7()
						GUICtrlSetPos($slider,252,52,255/10*7,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*8)
						bar_sett8()
						GUICtrlSetPos($slider,252,52,255/10*8,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time/10*9)
						bar_sett9()
						GUICtrlSetPos($slider,252,52,255/10*9,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $i = Int($song_time-1)
						bar_sett10()
						GUICtrlSetPos($slider,252,52,255/10*10-4,16)
						GUICtrlSetColor($slider,0x00ff00)
						GUICtrlSetBkColor($slider,0xffff00)
					Case $y = 0
						ExitLoop
				EndSelect
					sleep(100)	
					GUICtrlSetData($progbar_label,$i)
		Next
	EndIf
WEnd

Func click()
$pos = MouseGetPos()
	GUICtrlSetPos($slider,252,52,$pos[0]-450,16)
	GUICtrlSetColor($slider,0x00ff00)
	GUICtrlSetBkColor($slider,0xffff00)
	GUICtrlSetData($label_value,$pos[0]-$value_start)
EndFunc

Func CLOSE()
	Exit
EndFunc

Func start()
$y = 1
EndFunc

Func stop()
$y = 0
GUICtrlSetData($progbar_lab,"")
GUICtrlSetData($progbar_lab2,"")
GUICtrlSetData($progbar_lab3,"")
GUICtrlSetData($progbar_lab4,"")
GUICtrlSetData($progbar_lab5,"")
GUICtrlSetData($progbar_lab6,"")
GUICtrlSetData($progbar_lab7,"")
GUICtrlSetData($progbar_lab8,"")
GUICtrlSetData($progbar_lab9,"")
GUICtrlSetData($progbar_lab10,"")
GUICtrlSetData($progbar_label,"0")
$i = 0
EndFunc

Func bar_sett()
	GUICtrlSetData($progbar_lab,"n")
EndFunc

Func bar_sett2()
	GUICtrlSetData($progbar_lab2,"n")
EndFunc

Func bar_sett3()
	GUICtrlSetData($progbar_lab3,"n")
EndFunc

Func bar_sett4()
	GUICtrlSetData($progbar_lab4,"n")
EndFunc

Func bar_sett5()
	GUICtrlSetData($progbar_lab5,"n")
EndFunc

Func bar_sett6()
	GUICtrlSetData($progbar_lab6,"n")
EndFunc

Func bar_sett7()
	GUICtrlSetData($progbar_lab7,"n")
EndFunc

Func bar_sett8()
	GUICtrlSetData($progbar_lab8,"n")
EndFunc

Func bar_sett9()
	GUICtrlSetData($progbar_lab9,"n")
EndFunc

Func bar_sett10()
	GUICtrlSetData($progbar_lab10,"n")
EndFunc

Func bar_set1()
		$1 = GUICtrlRead($progbar_lab)
		If $1 = "" Then			
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_label,$song_time/10)
			$i = $song_time/10
		Else
			$i = 0
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab,"")
			GUICtrlSetData($progbar_lab2,"")
			GUICtrlSetData($progbar_lab3,"")
			GUICtrlSetData($progbar_lab4,"")
			GUICtrlSetData($progbar_lab5,"")
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc	
	
Func bar_set2()
		$2 = GUICtrlRead($progbar_lab2)
		If $2 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_label,$song_time/10*2)
			$i = $song_time/10*2
		Else
			$i = $song_time/10*1
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab2,"")
			GUICtrlSetData($progbar_lab3,"")
			GUICtrlSetData($progbar_lab4,"")
			GUICtrlSetData($progbar_lab5,"")
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc	
	
Func bar_set3()
		$3 = GUICtrlRead($progbar_lab3)
		If $3 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_label,$song_time/10*3)
			$i = $song_time/10*3
		Else
			$i = $song_time/10*2
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab3,"")
			GUICtrlSetData($progbar_lab4,"")
			GUICtrlSetData($progbar_lab5,"")
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc

Func bar_set4()
		$4 = GUICtrlRead($progbar_lab4)
		If $4 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_label,$song_time/10*4)
			$i = $song_time/10*4
		Else
			$i = $song_time/10*3
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab4,"")
			GUICtrlSetData($progbar_lab5,"")
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc

Func bar_set5()
		$5 = GUICtrlRead($progbar_lab5)
		If $5 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_label,$song_time/10*5)
			$i = $song_time/10*5
		Else
			$i = $song_time/10*4
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab5,"")
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc

Func bar_set6()
		$6 = GUICtrlRead($progbar_lab6)
		If $6 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_lab6,"n")
			GUICtrlSetData($progbar_label,$song_time/10*6)
			$i = $song_time/10*6
		Else
			$i = $song_time/10*5
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab6,"")
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc
	
Func bar_set7()
		$7 = GUICtrlRead($progbar_lab7)
		If $7 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_lab6,"n")
			GUICtrlSetData($progbar_lab7,"n")
			GUICtrlSetData($progbar_label,$song_time/10*7)
			$i = $song_time/10*7
		Else
			$i = $song_time/10*6
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab7,"")
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc	
	
Func bar_set8()
		$8 = GUICtrlRead($progbar_lab8)
		If $8 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_lab6,"n")
			GUICtrlSetData($progbar_lab7,"n")
			GUICtrlSetData($progbar_lab8,"n")
			GUICtrlSetData($progbar_label,$song_time/10*8)
			$i = $song_time/10*8
		Else
			$i = $song_time/10*7
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab8,"")
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc	

Func bar_set9()
		$9 = GUICtrlRead($progbar_lab9)
		If $9 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_lab6,"n")
			GUICtrlSetData($progbar_lab7,"n")
			GUICtrlSetData($progbar_lab8,"n")
			GUICtrlSetData($progbar_lab9,"n")
			GUICtrlSetData($progbar_label,$song_time/10*9)
			$i = $song_time/10*9
		Else
			$i = $song_time/10*8
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab9,"")
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc	

Func bar_set10()
		$10 = GUICtrlRead($progbar_lab10)
		If $10 = "" Then
			GUICtrlSetData($progbar_lab,"n")
			GUICtrlSetData($progbar_lab2,"n")
			GUICtrlSetData($progbar_lab3,"n")
			GUICtrlSetData($progbar_lab4,"n")
			GUICtrlSetData($progbar_lab5,"n")
			GUICtrlSetData($progbar_lab6,"n")
			GUICtrlSetData($progbar_lab7,"n")
			GUICtrlSetData($progbar_lab8,"n")
			GUICtrlSetData($progbar_lab9,"n")
			GUICtrlSetData($progbar_lab10,"n")
			GUICtrlSetData($progbar_label,$song_time)
			$i = $song_time
		Else
			$i = $song_time/10*9
			GUICtrlSetData($progbar_label,$i)
			GUICtrlSetData($progbar_lab10,"")
		EndIf	
EndFunc