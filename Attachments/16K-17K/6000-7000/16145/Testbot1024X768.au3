HotKeySet( "{end}", "Terminate")
HotKeySet( "{pause}", "Pause")
$Paused = 0
$HealButton = "7"
$Found = 0
$Coord = 0
$Dieing = 0
$Find = 0
$Alive = 0
$Skill1 = "1"
$Skill2 = "2"
$Skill3 = "5"
$Skill4 = "6"
$Attempts = 0
$TimesToLoot = 1 ;Set this to how many times you want the macro to search for loot
$LootDone = 0
;WinActivate("Guild Wars")
WinWaitActive("Guild Wars")

$Find = 0
While $Find = 0
	Send("C")
	Send("^{Space}")	;Target Baddie for Heroes If you have them. This is crucial if fighting bosses so that we are all attacking the same baddie.
	Sleep(1000) 	;Sleep because it was looking for the baddie to fast =]
	_Dieing()		;Am I Dieing? Heal me before I run into battle
	_Alive()		;Is the guy that I Selected alive?
	$Attempts = $Attempts + 1
ToolTip($Attempts,0,0);
If $Attempts > 3 Then
	_RandomRun()
Else

	;_Loot()			;Baddies Dead now.
EndIf
WEnd

;------------Is he alive?-----------------------------;
Func _Alive()
$Alive = 0
While $Alive = 0
$x = PixelSearch(393, 24, 611, 37, 0xD94040, 6)		;Checks for Red box at the top of the screen. Considers this a Baddie =]
	If NOT @Error Then
		;_Attack()
		Send("{Space}")							
			Send($Skill1)
$x = PixelSearch(393, 24, 611, 37, 0xD94040, 6)		;Checks for Red box at the top of the screen. Considers this a Baddie =]
	If NOT @Error Then
			Send($Skill2)
$x = PixelSearch(393, 24, 611, 37, 0xD94040, 6)		;Checks for Red box at the top of the screen. Considers this a Baddie =]
	If NOT @Error Then
			Send($Skill3)
$x = PixelSearch(393, 24, 611, 37, 0xD94040, 6)		;Checks for Red box at the top of the screen. Considers this a Baddie =]
	If NOT @Error Then
			Send($Skill4)
$x = PixelSearch(393, 24, 611, 37, 0xD94040, 6)		;Checks for Red box at the top of the screen. Considers this a Baddie =]
	If NOT @Error Then
			_Dieing()								;Am i dieing?
			$LootDone = 0
			$Attempts = 0
EndIf
EndIf
EndIf
EndIf
		Sleep(1000)									;Wait for Item to drop
	Else
If $LootDone = 1 Then
	$Alive = $Alive + 1
	Else
	_Loot()
	$Alive = $Alive + 1
	EndIf
EndIf
WEnd
EndFunc

;-----------Run Randomly-----------------------------;
Func _RandomRun()
	$LTurnSleep = Random(500, 1000)
	$RTurnSleep = Random(500, 1000)
	$TurnRand = Random(0, 2)						;Generate Random Right Turning Radius 1-3 seconds
	$Run = Random(4000, 20000)						;Generate Random Running Length 1-10 seconds
	If $TurnRand > 1 Then
		Send("{D Down}")
		Sleep($RTurnSleep)
		Send("{D Up}")
			Else
		Send("{A Down}")
		Sleep($LTurnSleep)
		Send("{A Up}")
	EndIf
		Send("{W Down}")
		Sleep($Run)
		Send("{W Up}")
		$Found1 = 1
		$Left = 0
		$Right = 0
		$Temp0 = 0
		$Attempts = 0
EndFunc


;------------Loot Him when he dies--------------------------;
Func _Loot()
$LootDone = 0
$TimesToLoot = 3	
$Found = 0
While $Found < $TimesToLoot
	Send(";")
	Send("{Space}")
	Sleep(1000)
	$Found = $Found + 1
WEnd
	$LootDone = $LootDone + 1
EndFunc

;------------Inventory is full, Go back to City-------------------;
Func _InvFull()
	Send("m")
	Sleep(500)
	MouseClick("left", 842, 606) ;Click on Kamadan "NightFall"
	Sleep(500)
	Send("{ENTER}")
	Pause()
EndFunc

;------------Am I Dieing? Not working completely yet--------------;
Func _Dieing()
$Dieing = 0
	$Color = PixelGetColor (440, 398)
		If Hex($Color, 6) = "D63232" then
		Else
		Send($HealButton)
		;Sleep(1000)
		Endif
		$dieing = $dieing + 1		
	EndFunc
		
;Kill the Script
Func Terminate()
    Exit
EndFunc


;Pause the Script
Func Pause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc
		
