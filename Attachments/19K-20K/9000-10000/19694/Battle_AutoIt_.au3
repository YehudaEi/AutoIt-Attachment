#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Jacob Pannell

 Script Function:
	Battle

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here




;Splash--------------------------------------------------------------------------------------------------
splashtexton("Battle!","This is Jacob Pannell's version of 'Battle!' by Travis Sims. All rights reserved.")
sleep(2000)
splashoff()
;------vars
$player1roll = "go"
$player2roll = "go"
$p1rollstotal = 0
$p2rollstotal = 0

$p1stm = 0
$p1agi = 0
$p1str = 0

$p2stm = 0
$p2agi = 0
$p2str = 0

$p1status = "fine"
$p2status = "fine"


;----fucntions
func roll1()
	SplashTextOn($player1name & "'s Stats","Rolling....")
	do
		$p1stm = int(random(1,10))
		$p1agi = int(random(1,10))
		$p1str = int(random(1,10))
		$player1statstotal = $p1stm + $p1agi + $p1str
	Until $player1statstotal = 14
	sleep(1000)
	splashoff()
EndFunc




func roll2()
	SplashTextOn($player2name & "'s Stats","Rolling....")
	do
		$p2stm = int(random(1,10))
		$p2agi = int(random(1,10))
		$p2str = int(random(1,10))
		$player2statstotal = $p2stm + $p2agi + $p2str
	Until $player2statstotal = 14
	sleep(1000)
	splashoff()
EndFunc

func attack1()
	if $p1agi > $p2agi Then
		$hitchance1 = int(random(6,10))
		if $hitchance1 = 4 or $hitchance1 = 6 or $hitchance1 = 8 or $hitchance1 = 9 or $hitchance1 = 10 Then
			$damage1 = ($p1str * 10) + int(random(5,26))
			if $damage1 < (.05 * $p2health) Then
				do
					$damage1 = $damage1 + int(random(1,5)) + ($p1str * .02)
				until $damage1 >= (.05 * $p2health)
			EndIf
			$p2health = $p2health - $damage1
			msgbox(64,$player1name & "'s Attack",$player1name & " attacked " & $player2name & " for " & $damage1 & ".")
		Else
			msgbox(64,$player1name & "'s Attack",$player1name & " missed " & $player2name & ".")
		EndIf
	Elseif $p1agi < $p2agi or $p1agi = $p2agi then
		$hitchance1 = int(random(1,10))
		if $hitchance1 = 2 or $hitchance1 = 4 or $hitchance1 = 6 or $hitchance1 = 8 or $hitchance1 or 10 then
			$damage1 = ($p1str * 10) + int(random(2,13))
			if $damage1 < (.05 * $p2health) Then
				Do
					$damage1 = $damage1 + int(random(1,5)) + ($p1str * .02)
				until $damage1 >= (.05 * $p2health)
			EndIf
			$p2health = $p2health - $damage1
			msgbox(64,$player1name & "'s Attack",$player1name & " attacked " & $player2name & " for " & $damage1 & ".")
		Else
			msgbox(64,$player1name & "'s Attack",$player1name & " missed " & $player2name & ".")
		EndIf
	EndIf
EndFunc


func attack2()
	if $p2agi > $p1agi Then
		$hitchance2 = int(random(6,10))
		if $hitchance2 = 4 or $hitchance2 = 6 or $hitchance2 = 8 or $hitchance2 = 9 or $hitchance2 = 10 Then
			$damage2 = ($p2str * 10) + int(random(5,26))
			if $damage2 < (.05 * $p1health) Then
				do 
					$damage2 = $damage2 + int(random(1,5)) + ($p2str * .02)
				until $damage2 >= (.05 * $p1health)
			EndIf
			$p1health = $p1health - $damage2
			msgbox(64,$player2name & "'s Attack",$player2name & " attacked " & $player1name & " for " & $damage2 & ".")
		Else
			msgbox(64,$player2name & "'s Attack",$player2name & " missed " & $player1name & ".")
		EndIf
	Elseif $p2agi < $p1agi or $p2agi = $p1agi then
		$hitchance2 = int(random(1,10))
		if $hitchance2 = 2 or $hitchance2 = 4 or $hitchance2 = 6 or $hitchance2 = 8 or $hitchance2 or 10 then
			$damage2 = ($p2str * 10) + int(random(2,13))
				if $damage2 < (.05 * $p1health) Then
				Do
					$damage2 = $damage2 + int(random(1,5)) + ($p2str * .02)
				until $damage2 >= (.05 * $p1health)
			EndIf
			$p1health = $p1health - $damage2
			msgbox(64,$player2name & "'s Attack",$player2name & " attacked " & $player1name & " for " & $damage2 & ".")
		Else
			msgbox(64,$player2name & "'s Attack",$player2name & " missed " & $player1name & ".")
		EndIf
	EndIf
EndFunc
			



;START PROGRAM!!!______________________________________________________________________________________
msgbox(64,"Welcome","Welcome to battle!")


;Names
$player1name = inputbox("Name?","What is the first character's name?","Player1")
msgbox(64,"Thank You","Thank you " & $player1name & ".")
$player2name = inputbox("And you?","And the second players name is?","Player2")
msgbox(64,"Thanks","Thanks " & $player2name & ".")


;Stats
msgbox(64,"Stats","We will now determine stats.")



;player1
while $player1roll = "go"
	roll1()
	$yesorno = msgbox(4,$player1name & "'s Stats","Stamina is " & $p1stm & ". Agility is " & $p1agi & ". Strength is " & $p1str & ".Good?")
	if $yesorno = 6 Then
		ExitLoop
	ElseIf $yesorno = 7 Then
		$p1rollstotal = $p1rollstotal + 1
		if $p1rollstotal = 3 Then
			msgbox(64,"Sorry","You can only roll 3 times.")
			ExitLoop
		EndIf
	EndIf
WEnd

msgbox(64,"Player2","Now time for player two. Press 'ok' to roll for your stats!")



;player2
while $player2roll = "go"
	roll2()
	$yesorno2 = msgbox(4,$player2name & "'s Stats","Stamina is " & $p2stm & ". Agility is " & $p2agi & ". Strength is " & $p2str & ".Good?")
	if $yesorno2 = 6 Then
		ExitLoop
	ElseIf $yesorno2 = 7 Then
		$p2rollstotal = $p2rollstotal + 1
		if $p2rollstotal = 3 Then
			msgbox(64,"Sorry","You can only roll 3 times.")
			ExitLoop
		EndIf
	EndIf
WEnd


;Health
$p1health = 500 + ($p1stm * 10) + int(random(50,200))
$p2health = 500 + ($p2stm * 10) + int(random(50,200))

;Start!!!
msgbox(64,"Who goes first","Now we roll to see who goes first.")
msgbox(64,$player1name & "'s roll","Press OK to roll, " & $player1name & ".")
$p1roll = int(random(1,10))
msgbox(64,$player2name & "'s roll","Press OK to roll, " & $player2name & ".")
$p2roll = int(random(1,10))


msgbox(64,"Rolls","Player 1 rolled a " & $p1roll & ". Player 2 rolled a " & $p2roll & ".")

if $p1roll > $p2roll then
	$turn = "p1"
	msgbox(64,"Going first..",$player1name & " will go first.")
Else
	$turn = "p2"
	msgbox(64,"Going first..",$player2name & " will go first.")
EndIf



	

;Health Printout
;msgbox(64,"Health",$player1name & "'s health is " & $p1health & ".")
;msgbox(64,"Health",$player2name & "'s health is " & $p2health & ".")

;Fight!!!!
while $p1health > 0 and $p2health > 0
	if $turn = "p1" Then
		splashtexton("Health",$player1name & "'s health:" & $p1health & " " & $player2name & "'s health:" & $p2health,175,50,576,289,1 + 2 + 4,-1,-1,-1)
		attack1()
		$turn = "p2"
	Else
		splashtexton("Health",$player1name & "'s health:" & $p1health & " " & $player2name & "'s health:" & $p2health,175,50,576,289,1 + 2 + 4,-1,-1,-1)
		attack2()
		$turn = "p1"
	EndIf
WEnd
splashoff()
;determine whos dead
if $p1health = 0 Then
	$p1status = "dead"
elseif $p2health = 0 Then
	$p2status = "dead"
EndIf

;Ending
if $p1status = "dead" Then
	;splashimageon("GAME OVER!!","C:\Documents and Settings\UIL\Desktop\game.jpg")
	sleep(1000)
	splashoff()
	msgbox(64,"WINNER!!",$player2name & " has slain " & $player1name & "!!!!!")
	Exit
Else
	;splashimageon("GAME OVER!!","C:\Documents and Settings\UIL\Desktop\game.jpg")
	sleep(1000)
	splashoff()
	msgbox(64,"WINNER!!",$player1name & " has slain " & $player2name & "!!!!!")
	Exit
EndIf





