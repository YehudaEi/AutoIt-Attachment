$hh1 = 0
$hmi1 = 0
$hma1 = 0
$mh1 = 0
$mmi1 = 0
$mma1 = 0

#include<guiconstants.au3>; for guicreation
$main = guicreate ("Main Window", 800, 250); main window of gui

;middle information
$health = guictrlcreatelabel ("Health", 250, 40, 100)
$mindmg = guictrlcreatelabel ("MinDmg", 250, 70, 100)
$maxdmg = guictrlcreatelabel ("MaxDmg", 250, 100, 100)

;hero stats
$hero = guictrlcreatelabel ("Hero", 160, 10, 130)
$hero_health = GUICtrlCreateInput (100, 160, 40, 80)
$hero_mindmg = GUICtrlCreateInput (0, 160, 70, 80)
$hero_maxdmg = GUICtrlCreateInput (10, 160, 100, 80)
$hero_pic = GUICtrlCreatePic ("paladin.jpg", 10, 20, 140, 200)

;monster stats
$monster = guictrlcreatelabel ("Monster", 360, 10, 130)
$monster_health = GUICtrlCreateInput (150, 360, 40, 80)
$monster_mindmg = GUICtrlCreateInput (1, 360, 70, 80)
$monster_maxdmg = GUICtrlCreateInput (5, 360, 100, 80)
$monster_pic = GUICtrlCreatePic ("goblin.jpg", 450, 20, 140, 200)

;fight_button
$fight = guictrlcreatebutton ("Fight", 160, 130, 140)
;reset_button
$reset = GUICtrlCreateButton ("Reset to Preset", 300, 130, 140)
;save_user_data
$save = GUICtrlCreateButton ("Save", 160, 160, 140)
;second reset
$reset2 = GUICtrlCreateButton ("Reset to Saved", 300, 160, 140)

;attack-styles
$attack = GUICtrlCreateGroup ("Attack-Style", 610, 10, 180, 230)
$hihi = GUICtrlCreateRadio ("Attack high - Block high", 620, 30)
$himi = GUICtrlCreateRadio ("Attack high - Block middle", 620, 50)
$hilo = GUICtrlCreateRadio ("Attack high - Block low", 620, 70)
$mihi = GUICtrlCreateRadio ("Attack middle - Block high", 620, 90)
$mimi = GUICtrlCreateRadio ("Attack middle - Block middle", 620, 110)
$milo = GUICtrlCreateRadio ("Attack middle - Block low", 620, 130)
$lohi = GUICtrlCreateRadio ("Attack low - Block high", 620, 150)
$lomi = GUICtrlCreateRadio ("Attack low - Block middle", 620, 170)
$lolo = GUICtrlCreateRadio ("Attack low - Block low", 620, 190)
$block = GUICtrlCreateRadio ("Just Block", 620, 210)
GUICtrlCreateGroup ("", -99, -99, -1, -1)

;new fight-button
$new_fight = GUICtrlCreateButton ("Fight (Round based)", 160, 220, 280)
;speed, because if you use high health it takes ages
$speed = GUICtrlCreateInput (1, 250, 190, 100)
GUICtrlSetLimit (GUICtrlCreateUpdown ($speed), 10, 1)

;make gui visible
guisetstate()

;infinite loop
while 1
;get which button is pressed
$msg = guigetmsg()
;multiple options
select
;X-Button
case $msg = $GUI_EVENT_CLOSE
exit
;Fight-Button
case $msg = $fight
;info to variable
$hh = guictrlread($hero_health)
$hmi = guictrlread ($hero_mindmg)
$hma = guictrlread ($hero_maxdmg)
$mh = guictrlread ($monster_health)
$mmi = guictrlread ($monster_mindmg)
$mma = guictrlread ($monster_maxdmg)
;start function
battle()
;Reset-Button
case $msg = $reset
guictrlsetdata ($hero_health, 100)
guictrlsetdata ($monster_health, 150)
guictrlsetdata ($hero_mindmg, 0)
GUICtrlSetData ($hero_maxdmg, 10)
GUICtrlSetData ($monster_mindmg, 1)
GUICtrlSetData ($monster_maxdmg, 5)
;Save-Button
case $msg = $save
$hh1 = guictrlread($hero_health)
$hmi1 = guictrlread ($hero_mindmg)
$hma1 = guictrlread ($hero_maxdmg)
$mh1 = guictrlread ($monster_health)
$mmi1 = guictrlread ($monster_mindmg)
$mma1 = guictrlread ($monster_maxdmg)
;2nd Reset-Button
case $msg = $reset2
if $hh1 <> 0 Then
guictrlsetdata ($hero_health, $hh1)
guictrlsetdata ($monster_health, $mh1)
guictrlsetdata ($hero_mindmg, $hmi1)
GUICtrlSetData ($hero_maxdmg, $hma1)
GUICtrlSetData ($monster_mindmg, $mmi1)
GUICtrlSetData ($monster_maxdmg, $mma1)
Else
msgbox (0, "Error", "No stored information")
EndIf
;Random Fight-Button
case $msg = $new_fight
$hh = guictrlread($hero_health)
$hmi = guictrlread ($hero_mindmg)
$hma = guictrlread ($hero_maxdmg)
$mh = guictrlread ($monster_health)
$mmi = guictrlread ($monster_mindmg)
$mma = guictrlread ($monster_maxdmg)
;Start Roundbased-System
fight()
;end of multiple options
endselect
;end of loop
wend

;now the battlingfunction
func battle()
;loop until someone is dead
do
;herodamage
$hd = random ($hmi, $hma, 1)
;monsterhealth
$mh = $mh - $hd
;monsterdamage
$md = random ($mmi, $mma, 1)
;herohealth
$hh = $hh - $md
;update the gui
guictrlsetdata ($hero_health, $hh)
guictrlsetdata ($monster_health, $mh)
;sleep_func so you can see what happens
sleepfunc()
;until someone is dead
until $hh < 1 or $mh < 1
;if its the hero
if $hh < 1 then
GUICtrlSetData ($hero_health, 0)
;messagebox he's dead
msgbox (0, "Someone died", "OMG it's the hero!")
endif
;if its the monster
if $mh < 1 then
GUICtrlSetData ($monster_health, 0)
;messagebox he did it
msgbox (0, "Someone died", "Yeah the monster is dead!")
endif
endfunc

;start the speed (sleep) function
func sleepfunc()
$level = guictrlread ($speed)
Select
case $level = 1 
	$time = 1000
case $level = 2
	$time = 800
case $level = 3
	$time = 700
case $level = 4
	$time = 600
case $level = 5
	$time = 500
case $level = 6
	$time = 400
case $level = 7
	$time = 300
case $level = 8
	$time = 200
case $level = 9
	$time = 100
case $level = 10
	$time = 0
case $level > 10
	$time = 0
case $level < 1
	$time = 1000
EndSelect
sleep ($time)
EndFunc
	
func fight()
	;attackstyle-monster
	$ma = random (1, 10, 1)
	Select
	case guictrlread ($hihi) = 1
		if $ma = 1 or $ma = 4 or $ma = 7 or $ma = 10 Then
			$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 1 or $ma = 2 or $ma = 3 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($himi) = 1
		if $ma = 1 or $ma = 4 or $ma = 7 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 4 or $ma = 5 or $ma = 6 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($hilo) = 1
		if $ma = 1 or $ma = 4 or $ma = 7 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 7 or $ma = 8 or $ma = 9 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($mihi) = 1
		if $ma = 2 or $ma = 5 or $ma = 8 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 1 or $ma = 2 or $ma = 3 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($mimi) = 1
		if $ma = 2 or $ma = 5 or $ma = 8 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 4 or $ma = 5 or $ma = 6 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($milo) = 1
		if $ma = 2 or $ma = 5 or $ma = 8 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 7 or $ma = 8 or $ma = 9 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($lohi) = 1
		if $ma = 3 or $ma = 6 or $ma = 9 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 1 or $ma = 2 or $ma = 3 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($lomi) = 1
		if $ma = 3 or $ma = 6 or $ma = 9 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 4 or $ma = 5 or $ma = 6 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($lolo) = 1
		if $ma = 3 or $ma = 6 or $ma = 9 or $ma = 10 Then
		$hd = 0
		Else
			;herodamage
			$hd = random ($hmi, $hma, 1)
			;monsterhealth
			$mh = $mh - $hd
		EndIf
		if $ma = 7 or $ma = 8 or $ma = 9 or $ma = 10 Then
		$md = 0
		Else
			;monsterdamage
			$md = random ($mmi, $mma, 1)
			;herohealth
			$hh = $hh - $md
		EndIf
	case guictrlread ($block) = 1
			;hero_life_gain
			$md = random (-5, 0, 1)
			;herohealth
			$hh = $hh - $md
	EndSelect
	;check if the monster gains life	
	If $ma = 10 Then
		;monster_life_gain
		$hd = random (-5, 0, 1)
		;monsterhealth
		$mh = $mh - $hd	
	EndIf
	;damage did
	;msgbox (0, "Damage inflicted", "Hero dealt " & $hd & " damage." & @CRLF & "Monster dealt " & $md & " damage.")
	;update the gui
	guictrlsetdata ($hero_health, $hh)
	guictrlsetdata ($monster_health, $mh)
	;check if someone is dead
	if $hh < 1 Then
		GUICtrlSetData ($hero_health, 0)
		;messagebox he's dead
		msgbox (0, "Someone died", "OMG it's the hero!")
	endif
	;if its the monster
	if $mh < 1 then
		GUICtrlSetData ($monster_health, 0)
		;messagebox he did it
		msgbox (0, "Someone died", "Yeah the monster is dead!")
	endif
EndFunc
