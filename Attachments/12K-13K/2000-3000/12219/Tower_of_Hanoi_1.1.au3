#include <GUIConstants.au3>
$sleeptime=15


Opt("GUIOnEventMode", 1)
GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")



GUICreate("Tower of Hanoi 1.1    by Markus Braun",770,280)
Global $scheibe[100]
Global $scheiben_stapel_pos[100]
Global $scheiben_x_pos[100]
Global $scheiben_y_pos[100]
Global $scheiben_width[100]
Global $scheiben_height[100]
Global $scheiben_colour[100]

Global $zwischensteps[100]
Global $steps_to_next_movement[100]

Global $next_move_to[100]
Global $count_way[100] ;0=rückwärts 1=vorwärts

Global $anzahl_scheiben=10

Global $stapelhoehe[4]
Global $stapelstabxpos[4]

Global $step=0

$stapelhoehe[1]=10
$stapelhoehe[2]=0
$stapelhoehe[3]=0

$stapelstabxpos[1]=110
$stapelstabxpos[2]=330
$stapelstabxpos[3]=550
;left pos= 680 + 10
$id_label_steps=GUICtrlCreateLabel("Steps: 0", 690,60,70,20)

$id_button_higher=GUICtrlCreateButton("higher", 690,100,70,20)
$id_label_speed=GUICtrlCreateLabel("Speed: " & $sleeptime & "ms", 690,120,70,20,-1,$WS_EX_CLIENTEDGE )
$id_button_lower=GUICtrlCreateButton("lower", 690,140,70,20)

GUICtrlSetOnEvent($id_button_higher, "_higher_speed")
GUICtrlSetOnEvent($id_button_lower, "_lower_speed")


GuiCtrlCreateGraphic(110, 60, 20,200)
GUICtrlSetBkColor(-1,0x8B4513)
GUICtrlSetColor(-1,0)

GuiCtrlCreateGraphic(330, 60, 20,200)
GUICtrlSetBkColor(-1,0x8B4513)
GUICtrlSetColor(-1,0)

GuiCtrlCreateGraphic(550, 60, 20,200)
GUICtrlSetBkColor(-1,0x8B4513)
GUICtrlSetColor(-1,0)

For $i=$anzahl_scheiben To 1 Step -1 ;i=0!!
	$scheibe[$i]=GuiCtrlCreateGraphic(20+($anzahl_scheiben-$i)*10, 240-($anzahl_scheiben-$i)*20, 200-($anzahl_scheiben-$i)*20,20)
	If mod($i, 2) = 0 Then
		GUICtrlSetBkColor(-1,0xff0000)
		$scheiben_colour[$i]=1
	Else
		GUICtrlSetBkColor(-1,0x0000ff)
		$scheiben_colour[$i]=0
	EndIf
	
	GUICtrlSetColor(-1,0)
	$scheiben_stapel_pos[$i]=1
	$scheiben_x_pos[$i]=20+($anzahl_scheiben-$i)*10
	$scheiben_y_pos[$i]=240-($anzahl_scheiben-$i)*20
	$scheiben_width[$i]=200-($anzahl_scheiben-$i)*20
	$scheiben_height[$i]=20
Next


GUISetState()

;Versuch Folgen zu finden, durch Aufschreiben der perfekten Variante
#cs
_move_and_set_vars(1,3)
_move_and_set_vars(2,2)
_move_and_set_vars(1,2)
_move_and_set_vars(3,3)
_move_and_set_vars(1,1)
_move_and_set_vars(2,3)
_move_and_set_vars(1,3)

_move_and_set_vars(4,2)
_move_and_set_vars(1,2)
_move_and_set_vars(2,1)
_move_and_set_vars(1,1)
_move_and_set_vars(3,2)
_move_and_set_vars(1,3)
_move_and_set_vars(2,2)
_move_and_set_vars(1,2)

_move_and_set_vars(5,3)
_move_and_set_vars(1,1)
_move_and_set_vars(2,3)
_move_and_set_vars(1,3)
_move_and_set_vars(3,1)
_move_and_set_vars(1,2)
_move_and_set_vars(2,1)
_move_and_set_vars(1,1)
_move_and_set_vars(4,3)
_move_and_set_vars(1,3)
_move_and_set_vars(2,2)
_move_and_set_vars(1,2)
_move_and_set_vars(3,3)
_move_and_set_vars(1,1)
_move_and_set_vars(2,3)
_move_and_set_vars(1,3)
#ce

;-->Regelmäßigkeit der Scheiben die bewegt werden 1 2 1 3 1 2 1 4 1 2....
;zwischensteps bis scheibe wieder bewegt wird ist: 
;a(n+1)=a(n)+2^n -->rekursive folge
$zwischensteps[0]=0
For $i=1 To $anzahl_scheiben 
	$zwischensteps[$i]=$zwischensteps[$i-1]+2^($i-1)
	;MsgBox(0,$i,$zwischensteps[$i])
Next
;erste bewegung nach $zwischensteps(n-1)
For $i=1 To $anzahl_scheiben 
	$steps_to_next_movement[$i]=$zwischensteps[$i-1]+1
	
	;MsgBox(0,$i,$steps_to_next_movement[$i] & "   " & $zwischensteps[$i])
	;MsgBox(0,$i,$zwischensteps[$i])
Next

;-->Regelmäßigkeit der Stäbe wo sie hinbewegt werden.
;Scheibe 1 beginnt bei bewegung nach stab 3 und wird dann rückwärtsgezählt
;Scheibe 2 beginnt bei bewegung nach stab 2 und wird dann hochgezählt
$next_move_to[0]=2
For $i=1 To $anzahl_scheiben
	If $next_move_to[$i-1]=3 Then 
		$next_move_to[$i]=2
	Else
		$next_move_to[$i]=3
	EndIf
Next
$count_way[0]=1
For $i=1 To $anzahl_scheiben
	If $count_way[$i-1]=0 Then 
		$count_way[$i]=1
	Else
		$count_way[$i]=0
	EndIf
Next


While 1
	For $s=1 To $anzahl_scheiben
		$steps_to_next_movement[$s]-=1
		If $steps_to_next_movement[$s]=0 Then
			_move_and_set_vars($s,$next_move_to[$s])
			$step=$step+1
			GUICtrlSetData($id_label_steps,"Steps: " & $step)
			$steps_to_next_movement[$s]=$zwischensteps[$s]+1
			If $count_way[$s]=1 Then 
				$next_move_to[$s]+=1
				If $next_move_to[$s]=4 Then 
					$next_move_to[$s]=1
				EndIf
			Else
				$next_move_to[$s]-=1
				If $next_move_to[$s]=0 Then 
					$next_move_to[$s]=3
				EndIf
			EndIf
			;check finished?
			
			For $i=1 To $anzahl_scheiben 
				If $scheiben_stapel_pos[$i]<>$scheiben_stapel_pos[$anzahl_scheiben] Then 
					ExitLoop
				ElseIf $i=$anzahl_scheiben Then
					While 1
						
					WEnd
				EndIf
			Next
		EndIf
	Next
	
	
WEnd

Func _move_and_set_vars($scheiben_id,$ziel_stapel)
	;heben
	GUISetOnEvent($GUI_EVENT_CLOSE, "_exit")
	GUICtrlSetOnEvent($id_button_higher, "_higher_speed")
	GUICtrlSetOnEvent($id_button_lower, "_lower_speed")

	While $scheiben_y_pos[$scheiben_id]>40
		$scheiben_y_pos[$scheiben_id]-=20
		GUICtrlSetPos($scheibe[$scheiben_id],$scheiben_x_pos[$scheiben_id],$scheiben_y_pos[$scheiben_id])
		Sleep($sleeptime)
	WEnd
	
	;verschieben
	$verschiebung=($ziel_stapel-$scheiben_stapel_pos[$scheiben_id])*220
	For $i=20 To Abs($verschiebung) Step 20
		If $verschiebung<0 Then 
			$scheiben_x_pos[$scheiben_id]-=20
		Else
			$scheiben_x_pos[$scheiben_id]+=20
		EndIf
		
		GUICtrlSetPos($scheibe[$scheiben_id],$scheiben_x_pos[$scheiben_id],$scheiben_y_pos[$scheiben_id])
		Sleep($sleeptime)
	Next
	
	;senken
	$senktiefe=240-$stapelhoehe[$ziel_stapel]*20
	
	While $scheiben_y_pos[$scheiben_id]<$senktiefe
		$scheiben_y_pos[$scheiben_id]+=20
		GUICtrlSetPos($scheibe[$scheiben_id],$scheiben_x_pos[$scheiben_id],$scheiben_y_pos[$scheiben_id])
		Sleep($sleeptime)
	WEnd
	
	$stapelhoehe[$ziel_stapel]+=1
	$stapelhoehe[$scheiben_stapel_pos[$scheiben_id]]-=1
	$scheiben_stapel_pos[$scheiben_id]=$ziel_stapel
	;$scheiben_x_pos[1],$scheiben_y_pos[1],$scheiben_width[1],$scheiben_height[1],$scheiben_stapel_pos[1]
	
	;senken
EndFunc

Func _exit()
	Exit
EndFunc

Func _higher_speed()
	$sleeptime+=5
	GUICtrlSetData($id_label_speed,"Speed: " & $sleeptime & "ms")
EndFunc
Func _lower_speed()
	If $sleeptime>0 Then $sleeptime-=5
	GUICtrlSetData($id_label_speed,"Speed: " & $sleeptime & "ms")
EndFunc
