; Rishodi's Pindlebot v1.3a for Diablo II v1.10
; 
; AutoIt Version: 3.0
; Author:         Rishodi (Rishodi@yahoo.com)
; Thanks to FallnAngel for the IPB 3.4 script which I based a lot of this on


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Variable Declarations
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Global $borderWidth = 3
Global $titleHeight = 29
Global $corpseCheck
Global $currentHealth
Global $gameName[2]
Global $magicChar = "."
Global $temp
$gameName[1] = 1
Global $version
$version = "1.3a"
$mercResAttempts = 0 ;only used if NeedMerc=2
$mercAlive = 0
$marker = 0 ;keeps track of whether or not the bot knows where you are in the run
$inTemple = 0 ;keeps track of whether or not you are in Nihlathak's Temple in-game
$away = 0 ;keeps track of when the away chickmessage needs to be sent
$runWasCompleted = 0 ;keeps track of whether or not the last run was completed
$pauseTime = 0 ;used to subtract pause time from total run time
$restarts = 0 ;used to keep track of multiple D2 restarts in a row, if = 3 then bot will wait for a while before restarting D2 again
$currentInterval = 0 ;keeps track of run interval
$slotCheck = 0
$stashCount = 0
$quit = 0
$lastRuns = 0
$lastCompleted = 0
$lastDeaths = 0
$lastChickens = 0
$totalRuns = 0
$totalCompleted = 0
$totalDeaths = 0
$totalChickens = 0
$runTime = 0
$lastPotUse = 0 ;used to disable potion use for 1 second after using the last potion
$lastGameChicken = 0 ;if 1, then bot chickened out of last game
;the following variables are used in the stashing routine
Global $itemHeight
Global $itemWidth
Global $invLock[40]
For $i = 0 to 39
	$invLock[$i] = 0
Next
Global $spaceCheck[5][2] ;first dimension specifies which pixel # (0-4), second specifies whether x/y (0/1)
$spaceCheck[0][0] = 0
$spaceCheck[0][1] = -8
$spaceCheck[1][0] = -8
$spaceCheck[1][1] = 0
$spaceCheck[2][0] = 0
$spaceCheck[2][1] = 0
$spaceCheck[3][0] = 8
$spaceCheck[3][1] = 0
$spaceCheck[4][0] = 0
$spaceCheck[4][1] = 8

;sets the coordinates to operate within the active window
AutoItSetOption("MouseCoordMode", 0)
AutoItSetOption("PixelCoordMode", 0)

;read in user specifications
$slotToUse = MyIniRead("pindlebot.ini", "Global", "SlotToUse", "")
If (StringLen($slotToUse) = 0) Then
	$slotToUse = InputBox("Rishodi's Pindlebot v" & $version, "Use which configured slot?", "slot1")
	If NOT (@error = 0) Then
		Exit
	EndIf
EndIf

TrayTip("RPB v" & $version, "Rishodi's Pindlebot v" & $version & Chr(10) & "Reading configuration...", 6, 17)

;read in specific slot configuration
$account = MyIniRead("pindlebot.ini", $slotToUse, "Account", "")
$password = MyIniRead("pindlebot.ini", $slotToUse, "Password", "")
$charPosition = MyIniRead("pindlebot.ini", $slotToUse, "CharPosition", "")
$difficulty = MyIniRead("pindlebot.ini", $slotToUse, "Difficulty", "3")
$precast1 = MyIniRead("pindlebot.ini", $slotToUse, "Precast1", "")
$precast2 = MyIniRead("pindlebot.ini", $slotToUse, "Precast2", "")
$teleport = MyIniRead("pindlebot.ini", $slotToUse, "Teleport", "")
$attackSequence = MyIniRead("pindlebot.ini", $slotToUse, "AttackSequence", "")
$needMerc = MyIniRead("pindlebot.ini", $slotToUse, "NeedMerc", 0)
$healLife = Abs(MyIniRead("pindlebot.ini", $slotToUse, "HealLife", 0))
$chickenLife = Abs(MyIniRead("pindlebot.ini", $slotToUse, "ChickenLife", 0))

;global configurations
$d2path = MyIniRead("pindlebot.ini", "Global", "D2Path", RegRead("HKEY_CURRENT_USER\Software\Blizzard Entertainment\Diablo II", "InstallPath"))
If (StringRight($d2path, 1) = "\") Then
	$d2path = StringTrimRight($d2path, 1)
EndIf
$d2exe = MyIniRead("pindlebot.ini", "Global", "D2Exe", "Diablo II.exe")
$d2parameters = MyIniRead("pindlebot.ini", "Global", "D2Parameters", "")
$d2WinTitle = MyIniRead("pindlebot.ini", "Global", "D2WinTitle", "Diablo II")
If (StringLen($d2WinTitle) = 0) Then
	$d2WinTitle = "D2Loader v1.10b14 Build On Oct 29 2003"
EndIf
$gameName[0] = MyIniRead("pindlebot.ini", "Global", "GameName", StringLeft($account, 3))
$pauseButton = MyIniRead("pindlebot.ini", "Global", "PauseButton", "{PAUSE}")
HotKeySet($pauseButton, "PauseScript") ;sets hotkey to pause script
$awayMessage = MyIniRead("pindlebot.ini", "Global", "AwayMessage", "")
$moveWindow = MyIniRead("pindlebot.ini", "Global", "MoveWindow", "0")
$usePickit = MyIniRead("pindlebot.ini", "Global", "UsePickit", "1")
If ($usePickit = 1) Then ;find the magic character
	$magicChar = FindValue($d2path & "\Plugin\zoid.ini", "MagicChar", ".")
EndIf
$noPickup = MyIniRead("pindlebot.ini", "Global", "NoPickup", "")
$groundSelect = FindValue($d2path & "\Plugin\zoid.ini", "GroundSelect", "TRUE")
If (StringLen($noPickup) = 0) Then
	If (($groundSelect = "FALSE") OR ($groundSelect = "0")) Then
		$noPickup = 0
	Else
		$noPickup = 1
	EndIf
EndIf
$runs = MyIniRead("pindlebot.ini", "Global", "Runs", "-1")
$maxVariance = .01 * MyIniRead("pindlebot.ini", "Global", "MaxVariance", "20")
$runInterval = MyIniRead("pindlebot.ini", "Global", "RunInterval", "200")
$intervalVariance = MyIniRead("pindlebot.ini", "Global", "IntervalVariance", "50")
$sleepTime = MyIniRead("pindlebot.ini", "Global", "SleepTime", "900")
$sleepVariance = MyIniRead("pindlebot.ini", "Global", "SleepVariance", "600")
$stash = MyIniRead("pindlebot.ini", "Global", "Stash", "10")

;reads in user-configured delays
$dMouseClick = MyIniRead("pindlebot.ini", "Delays", "dMouseClick", "300")
$dStashDelay = MyIniRead("pindlebot.ini", "Delays", "dStashDelay", "750")
$dGetCorpse = MyIniRead("pindlebot.ini", "Delays", "dGetCorpse", "1500")
$dPickUpItems = MyIniRead("pindlebot.ini", "Delays", "dPickUpItems", "4500")
$dCloseD2 = MyIniRead("pindlebot.ini", "Delays", "dCloseD2", "5000")

;read in color checks in advanced.ini
$loginCheck = MyIniRead("advanced.ini", "ColorChecks", "Login", "4739160")
$charSelectCheck = MyIniRead("advanced.ini", "ColorChecks", "CharSelect", "6579300")
$chatCheck = MyIniRead("advanced.ini", "ColorChecks", "Chat", "4739160")
$inGameCheck = MyIniRead("advanced.ini", "ColorChecks", "InGame", "4753584")
$inact4 = MyIniRead("advanced.ini", "ColorChecks", "InAct4", "6842472")
$deathCheck = MyIniRead("advanced.ini", "ColorChecks", "Death", "1317980")
$mercInAct5 = MyIniRead("advanced.ini", "ColorChecks", "MercInAct5", "33792")
$stashOpen = MyIniRead("advanced.ini", "ColorChecks", "StashOpen", "11059396")
$fullRejuv = MyIniRead("advanced.ini", "ColorChecks", "FullRejuv", "6824048")
$rejuv = MyIniRead("advanced.ini", "ColorChecks", "Rejuv", "8158332")
$supHeal = MyIniRead("advanced.ini", "ColorChecks", "SupHeal", "144")
$greaterHeal = MyIniRead("advanced.ini", "ColorChecks", "GreaterHeal", "5526724")
$supMana1 = MyIniRead("advanced.ini", "ColorChecks", "SupMana1", "9711664")
$supMana2 = MyIniRead("advanced.ini", "ColorChecks", "SupMana2", "4739160")
$greaterMana = MyIniRead("advanced.ini", "ColorChecks", "GreaterMana", "14180388")

;read in mouse click settings in advanced.ini
$portalX = MyIniRead("advanced.ini", $slotToUse, "PortalX", "337")
$portalY = MyIniRead("advanced.ini", $slotToUse, "PortalY", "230")
$lastTeleX = MyIniRead("advanced.ini", $slotToUse, "LastTeleX", "692")
$lastTeleY = MyIniRead("advanced.ini", $slotToUse, "LastTeleY", "141")
$attackX = MyIniRead("advanced.ini", $slotToUse, "AttackX", "602")
$attackY = MyIniRead("advanced.ini", $slotToUse, "AttackY", "138")
$grabClickX = MyIniRead("advanced.ini", $slotToUse, "GrabClickX", "612")
$grabClickY = MyIniRead("advanced.ini", $slotToUse, "GrabClickY", "145")

;read in min/max delays in advanced.ini
$bnetConnectMin = MyIniRead("advanced.ini", "Delays", "BNetConnectMin", "800")
$bnetConnectMax = MyIniRead("advanced.ini", "Delays", "BNetConnectMax", "5000")
$loginMin = MyIniRead("advanced.ini", "Delays", "LoginMin", "1200")
$loginMax = MyIniRead("advanced.ini", "Delays", "LoginMax", "6000")
$charSelectMin = MyIniRead("advanced.ini", "Delays", "CharSelectMin", "400")
$charSelectMax = MyIniRead("advanced.ini", "Delays", "CharSelectMax", "8000")
$createGameMin = MyIniRead("advanced.ini", "Delays", "CreateGameMin", "600")
$createGameMax = MyIniRead("advanced.ini", "Delays", "CreateGameMax", "10000")
$runningMin = MyIniRead("advanced.ini", "Delays", "RunningMin", "400")
$runningMax = MyIniRead("advanced.ini", "Delays", "RunningMax", "3000")
$enterPortalMin = MyIniRead("advanced.ini", "Delays", "EnterPortalMin", "1200")
$exitGameMin = MyIniRead("advanced.ini", "Delays", "ExitGameMin", "1200")
$exitGameMax = MyIniRead("advanced.ini", "Delays", "ExitGameMax", "6000")

;reads in misc delays in advanced.ini
$mouseSpeed = MyIniRead("advanced.ini", "Misc", "MouseSpeed", "1")
$portalMouseSpeed = MyIniRead("advanced.ini", "Misc", "PortalMouseSpeed", "4")
$stashMouseSpeed = MyIniRead("advanced.ini", "Misc", "StashMouseSpeed", "6")
$healPeriod = MyIniRead("advanced.ini", "Misc", "HealPeriod", "250")


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; General Diablo II Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func WinSize()
If WinActive($d2WinTitle, "") Then
	$winSize = WinGetPos($d2WinTitle, "")
	$borderWidth = ($winSize[2] - 800) / 2
	$titleHeight = $winSize[3] - 600 - (2 * $borderWidth)
Else
	MsgBox(48, "Rishodi's Pindlebot v" & $version, 'Could not locate Diablo II window. Setting offsets to default, or previous values if valid.', 5)
EndIf
EndFunc

Func StartD2()
Run($d2path & "\" & $d2exe & " " & $d2parameters & ' -title "' & $d2WinTitle & '"', $d2path)
WinWait($d2WinTitle, "", 20)
ActivateD2()
WinSize()
Wait(401, 522, $loginCheck, $bnetConnectMin, $bnetConnectMax)
EndFunc

Func MyCloseProcess($process)
While ProcessExists($process)
	ProcessClose($process)
	ProcessWaitClose($process, 5)
WEnd
EndFunc

Func MyCloseWindow($win, $text)
While WinExists($win, $text)
	WinClose($win, $text)
	WinWaitClose($win, $text, 5)
WEnd
EndFunc

Func CloseD2($delay)
MyCloseProcess("Diablo II.exe")
MyCloseProcess("D2Loader.exe")
MyCloseProcess("Game.exe")
MyCloseWindow("Diablo II", "")
MyCloseWindow("D2Loader", "")
MyCloseWindow("Game", "")
MyCloseWindow("Diablo II Exception", "")
MyCloseWindow("Diablo II Error", "")
MyCloseWindow("Loader Error!", "")
MyCloseWindow("D2Loader Error!", "")
MyCloseWindow("D2Loader Exception", "")
MyCloseWindow("D2Loader Error", "")
MyCloseWindow("Hey guys", "")
MyCloseWindow("Microsoft Visual C++ Debug Library", "")
MyCloseWindow("End Program - " & $d2wintitle, "")
MyCloseWindow($d2WinTitle, "")
MyCloseProcess($d2WinTitle)
MyCloseWindow($d2exe, "")
MyCloseProcess($d2exe)
MyCloseWindow("D2stats", "")
MyCloseWindow("D2stats.exe", "")
MySleep($delay)
EndFunc

Func Quit()
AdlibDisable()
CloseD2(1) ;doesn't sleep after closing D2 processes
Exit
EndFunc

Func ActivateD2()
MySleep(750)
WinActivate($d2WinTitle, "") ;activating window
WinWaitActive($d2WinTitle, "", 5)
If ($moveWindow = 1) Then
	WinMove($d2WinTitle, "", 0, 0)
EndIf
MySleep(1000)
EndFunc

Func MyIniRead($file, $section, $key, $default)
Local $tempValue = IniRead($file, $section, $key, $default)
If (StringLen($tempValue) = 0) Then
	$tempValue = $default
EndIf
Return $tempValue
EndFunc

Func MyRMouseClick($button, $x, $y, $xFactor, $yFactor, $speed)
MyRMouseMove($x, $y, $xFactor, $yFactor, $speed)
MouseClick($button)
EndFunc

Func MyRMouseMove($x, $y, $xFactor, $yFactor, $speed)
MyMouseMove(Random($x - $xFactor, $x + $xFactor), Random($y - $yFactor, $y + $yFactor), $speed)
EndFunc

Func MyMouseClick($button, $x, $y, $speed)
MyMouseMove($x, $y, $speed)
MouseClick($button)
EndFunc

Func MyMouseMove($x, $y, $speed)
$x = $x + $borderWidth
$y = $y + $titleHeight + $borderWidth
MouseMove($x, $y, $speed)
EndFunc

Func MyPixelGetColor($coordX, $coordY)
$coordX = $coordX + $borderWidth
$coordY = $coordY + $titleHeight + $borderWidth
Return PixelGetColor($coordx, $coordy)
EndFunc

Func MyPixelSearch($leftX, $topY, $rightX, $bottomY, $tempColor)
$leftX = $leftX + $borderWidth
$topY = $topY + $titleHeight + $borderWidth
$rightX = $rightX + $borderWidth
$bottomY = $bottomY + $titleHeight + $borderWidth
Return PixelSearch($leftX, $topY, $rightX, $bottomY, $tempColor)
EndFunc

Func MySleep($delay)
If ($maxVariance = 0) Then
	Sleep($delay)
Else
	Sleep(Random($delay, $delay * (1 + $maxVariance)))
EndIf
EndFunc

Func Modulo($int1, $int2)
;performs the modulo operation: $int1 % $int2 for whole numbers only
Return $int1 - $int2 * Int($int1 / $int2)
EndFunc

Func BotSleep($time)
AdlibDisable()
CloseD2($dCloseD2)
;$time in seconds
For $i = 0 to $time
	$remaining = $time - $i
	$hours = Int($remaining/3600)
	If ($hours < 10) Then
		$hours = "0" & $hours
	EndIf
	$minutes = Modulo(Int($remaining/60), 60)
	If ($minutes < 10) Then
		$minutes = "0" & $minutes
	EndIf
	$seconds = Modulo($remaining, 60)
	If ($seconds < 10) Then
		$seconds = "0" & $seconds
	EndIf
	TrayTip("RPB v" & $version, "Script is sleeping." & Chr(10) & "Remaining time: " & $hours & ":" & $minutes & ":" & $seconds, 1, 17)
	Sleep(1000)
Next
TrayTip("RPB v" & $version, "Resuming script...", 6, 17)
StartD2()
AdlibEnable("GameCheck", $healPeriod)
EndFunc

Func PauseScript()
;pauses script due to user action
AdlibDisable()
If ($marker = 1) Then
	$pauseStart = TimerStart()
EndIf
$quit = MsgBox(51, "Rishodi's Pindlebot v" & $version, "RPB script is paused. Do you wish to continue runs?" & Chr(10) & Chr(10) & "Press 'Yes' to continue runs, 'No' to immediately exit, or 'Cancel' to quit after finishing the current run. RPB script will automatically resume in 30 seconds.", 30)
If ($quit = 7) Then
	Quit()
EndIf
ActivateD2()
If ($marker = 1) Then
	$pauseTime = $pauseTime + Int(TimerStop($pauseStart))
EndIf
AdlibEnable("GameCheck", $healPeriod)
EndFunc

Func GameCheck()
If NOT (WinActive($d2WinTitle, "")) Then
	If WinExists($d2WinTitle, "") Then
		Send($pauseButton)
	EndIf
ElseIf ($inTemple = 1) AND ($healLife > 0) Then
	GetStats()
	HealthCheck()
EndIf
EndFunc

Func FindValue($ini, $setting, $default)
;opens the $ini file and returns the value of the specified $setting
;returns $default if the setting is not found
$file = FileOpen($ini, 0)
If ($file = -1) Then
	Return $default
EndIf
Local $value = $default
While 1
	$line = FileReadLine($file)
	If (@error = -1) Then
		ExitLoop
	EndIf
	$string = StringInStr($line, $setting)
	If NOT ($string = 0) Then
		$value = StringTrimLeft($line, StringInStr($line, "="))
		While (StringLeft($value, 1) = " ")
			$value = StringTrimLeft($value, 1)
		WEnd
		$valueLength = StringInStr($value, ";")
		$value = StringLeft($value, $valueLength - 1)
		While (StringRight($value, 1) = " ")
			$value = StringTrimRight($value, 1)
		WEnd
		If ((StringLeft($value, 1) == '"') AND (StringRight($value, 1) = '"')) Then
			$value = StringTrimLeft(StringTrimRight($value, 1), 1)
		EndIf
		ExitLoop
	EndIf
WEnd
FileClose($file)
Return $value
EndFunc


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; In-Game Management and Detection Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func PotionTest($x, $y) ;checks to see if a potion is in the inv or belt at x,y
;returns 1 if it finds a rejuv
;returns 2 if it finds a healing potion
;returns 3 if it finds a mana potion
;returns 0 if it doesn't find a recognizable potion
$color = MyPixelGetColor($x, $y)
Select
	Case ($color = $fullRejuv)
		Return 1
	Case ($color = $rejuv)
		Return 1
	Case ($color = $supHeal)
		Return 2
	Case ($color = $greaterHeal)
		Return 2
	Case ($color = $supMana1) AND (MyPixelGetColor($x, $y+1) = $supMana2)
		Return 3
	Case ($color = $greaterMana)
		Return 3
	Case Else
		Return 0
EndSelect
EndFunc

Func FindPotInBelt($type)
;if $type is 2 (health) then searches for health or rejuv
;if $type is 3 (mana) then searches for mana or rejuv
;returns the belt slot (1-4) of the nearest viable potion, 0 if none is found
$x=437
$y=576
$healSlot=1
While $x < 530
	$pot = PotionTest($x, $y)
	If ($pot = 1) OR ($pot = $type) Then
		Return $healSlot
	EndIf
	$x = $x + 31
	$healSlot = $healSlot + 1
WEnd
Return 0
EndFunc

Func SendHotKey($hotkey)
If (StringLeft($hotkey, 1) = "F") AND (StringLen($hotkey) > 1) Then
	Send("{" & $hotkey & "}")
ElseIf ($hotkey = "NULL") Then
	;don't send a hotkey
Else
	Send($hotkey)
EndIf
EndFunc

Func GetStats()
Run("d2stats.exe")
EndFunc

Func HealthCheck()
If ($lastPotUse > 0) Then
	$lastPotUse = $lastPotUse - 1
EndIf
$currentHealth = Abs(MyIniRead("d2stats.ini", "Current", "Health", ""))
If ($currentHealth < $healLife) AND NOT ($currentHealth = 0) Then
	If ($currentHealth < $chickenLife) AND ($chickenLife > 0) Then ;chicken out of game
		ExitGame()
		TrayTip("RPB v" & $version, "Chickened out of game!" & Chr(10) & "Health was at " & $currentHealth, 6, 17)
		$lastGameChicken = 1
		$inTemple = 0
		$totalChickens = MyIniRead("statistics.ini", $slotToUse, "TotalChickens", "0") + 1
		$lastChickens = MyIniRead("statistics.ini", $slotToUse, "LastChickens", "0") + 1
		IniWrite("statistics.ini", $slotToUse, "TotalChickens", $totalChickens)
		IniWrite("statistics.ini", $slotToUse, "LastChickens", $lastChickens)
	ElseIf ($lastPotUse = 0) Then
		$healSlot = FindPotInBelt(2)
		If NOT ($healSlot = 0) Then
			Send($healSlot)
			$lastPotUse = 4
		EndIf
	EndIf
ElseIf ($currentHealth = 0) Then ;character is no longer in a game
	$inTemple = 0
EndIf
EndFunc

Func MercHealthCheck()
If NOT ($needMerc = 0) AND ($mercAlive = 1) AND NOT (MyPixelGetColor(23, 17) = $mercInAct5) Then
	$healSlot = FindPotInBelt(2)
	If NOT ($healSlot = 0) Then
		Send("+" & $healSlot)
	EndIf
EndIf
EndFunc

Func ResMerc()
MyRMouseClick("left", 97, 511, 2, 2, $mouseSpeed) ;go to wp
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 222, 511, 2, 2, $mouseSpeed)
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 311, 352, 32, 17, $mouseSpeed) ;click on wp
MySleep(1000)
MyRMouseClick("left", 303, 78, 24, 7, $mouseSpeed) ;click on "IV" tab
MySleep($dMouseClick)
MyRMouseClick("left", 112, 136, 9, 9, $mouseSpeed) ;click on "Pandemonium Fortress"
MySleep(4000)
MyMouseClick("left", 216, 202, $mouseSpeed) ;runs up between poles
RunningWait($runningMin, $runningMax)
MyMouseClick("left", 231, 168, $mouseSpeed) ;run to Tyreal
RunningWait($runningMin, $runningMax)
MyMouseClick("left", 368, 215, $mouseSpeed) ;click on Tyreal
MySleep(2500)
Send("{UP}")
MySleep(500)
Send("{UP}")
MySleep(500)
Send("n") ;clears all in-game messages
MySleep(500)
$tempColor = MyPixelGetColor(23, 17)
Send("{ENTER}") ;resurrects merc
MySleep(3000)
Send("n") ;clears all in-game messages
MySleep(250)
If (MyPixelGetColor(23, 17) = $tempColor) Then ;merc was not resurrected, possibly b/c character didn't have enough gold
	Send("{ENTER}")
	MySleep(1000)
	If ($needMerc = 2) Then
		ExitGame()
		$mercResAttempts = $mercResAttempts + 1
		If ($mercResAttempts = 5) Then
			Quit()
		EndIf
	EndIf
Else
	TrayTip("RPB v" & $version, "Mercenary resurrected.", 6, 17)
	$mercResAttempts = 0
	$mercAlive = 1
EndIf
MySleep(1000)
Send("{SPACE}")
MySleep(1500)
MyMouseClick("left", 368, 215, $mouseSpeed) ;click on Tyrael again
MySleep(2500)
If ($mercAlive = 0) Then
	Send("{UP}")
	MySleep(500)
EndIf
Send("{UP}")
MySleep(500)
Send("{UP}") ;point to Travel to Harrogath
MySleep(500)
Send("{ENTER}") ;goes back to act 5
MySleep(4000)
EndFunc

Func GoToActFive()
MyRMouseClick("left", 707, 51, 50, 20, $mouseSpeed)
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 364, 78, 25, 9, $mouseSpeed)
MySleep(1000)
MyRMouseClick("left", 112, 136, 10, 10, $mouseSpeed)
MySleep(3500)
EndFunc

Func Precast($precast)
If (StringLen($precast) > 0) Then
	$sequence = StringSplit(StringTrimRight($precast, 1), ";")
	For $i = 1 to $sequence[0] ;precast sequence
		$spell = StringSplit($sequence[$i], ",")
		;$spell[1] is the spell hotkey, $spell[2] is the delay
		If NOT ($spell[1] = "NULL") Then
			SendHotKey($spell[1])
			MySleep($dMouseClick)
			MyRMouseClick("right", 397, 271, 150, 100, $mouseSpeed)
		EndIf
		MySleep($spell[2])
	Next
EndIf
EndFunc

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Auto-Delay Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func Wait($x, $y, $color, $minDelay, $maxDelay)
; sleeps for a maximum delay ($maxDelay) or until the pixel at ($x, $y) is a certain color ($color)
; if $minDelay = $maxDelay then it will sleep for a set period of time
If NOT ($maxDelay = $minDelay) Then
	If ($minDelay > 0) Then
		MySleep($minDelay - 200)
	EndIf
	$maxDelay = ($maxDelay - $minDelay) / 200
	$time = 0
	Do
		MySleep(200)
		$time = $time + 1
		If ($time = $maxDelay) Then
			ExitLoop
		EndIf
	Until (MyPixelGetColor($x, $y) = $color)
Else
	Sleep($minDelay)
EndIf
EndFunc

Func RunningWait($minDelay, $maxDelay)
; sleeps for a maximum delay ($maxDelay) or until character no longer appears to be moving
; recommended minimum $maxDelay is 2000
If NOT ($maxDelay = $minDelay) Then
	If ($minDelay > 0) Then
		MySleep($minDelay - 200)
	EndIf
	$maxDelay = ($maxDelay - $minDelay) / 200
	$time = 0
	Local $runMatrix[2][4]
	Do
		$count = 0
		$time = $time + 1
		$runMatrix[0][0] = MyPixelGetColor(250, 200)
		$runMatrix[0][1] = MyPixelGetColor(550, 200)
		$runMatrix[0][2] = MyPixelGetColor(250, 400)
		$runMatrix[0][3] = MyPixelGetColor(550, 400)
		MySleep(200)
		$runMatrix[1][0] = MyPixelGetColor(250, 200)
		$runMatrix[1][1] = MyPixelGetColor(550, 200)
		$runMatrix[1][2] = MyPixelGetColor(250, 400)
		$runMatrix[1][3] = MyPixelGetColor(550, 400)
		For $i = 0 to 3
			If ($runMatrix[0][$i] = $runMatrix[1][$i]) Then
				$count = $count + 1
			EndIf
		Next
		If ($count > 2) Then
			ExitLoop
		EndIf
	Until ($time = $maxDelay)
Else
	Sleep($minDelay)
EndIf
EndFunc

;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Stashing Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func GridPos($x, $y)
;returns grid # of space in inventory or stash when given an x, y location
If $x > 400 Then ;inventory
	Return 10*(($y-329)/29) + ($x-433)/29
Else ;stash
	Return 6*(($y-156)/29) + ($x-168)/29
EndIf
EndFunc

Func EmptySpace($gridName, $x, $y)
For $i = 0 to 4
	If NOT (MyPixelGetColor($x + $spaceCheck[$i][0], $y + $spaceCheck[$i][1]) = MyIniRead("advanced.ini", $gridName, GridPos($x, $y) & "_" & $i, "")) Then
		Return 0
	EndIf
Next
Return 1
EndFunc

Func FindItemSize($x, $y)
Select
	Case $y = 416
		$maxHeight = 0
	Case $y = 387
		$maxHeight = 1
	Case $y = 358
		$maxHeight = 2
	Case $y = 329
		$maxHeight = 3
EndSelect
$itemHeight = 0
While $itemHeight < $maxHeight
	If EmptySpace("Inventory", $x, $y+29*($itemHeight+1)) Then
		ExitLoop
	EndIf
	$itemHeight = $itemHeight + 1
WEnd
If $x = 694 Then
	$itemWidth = 0
Else
	If NOT (EmptySpace("Inventory", $x + 29, $y)) Then
		$itemWidth = 1
	Else
		$itemWidth = 0
	EndIf
EndIf
MyMouseClick("left", $x, $y, $stashMouseSpeed)
MySleep($dStashDelay)
MyMouseMove(380, 50, $stashMouseSpeed)
MySleep($dStashDelay)
If ($itemWidth = 1) AND NOT (EmptySpace("Inventory", $x + 29, $y)) Then	
	$itemWidth = 0
EndIf
While $itemHeight > 0
	If NOT (EmptySpace("Inventory", $x, $y+29*$itemHeight)) Then
		$itemHeight = $itemHeight - 1
	Else
		ExitLoop
	EndIf
WEnd
EndFunc

Func SpaceFound($stashx, $stashy)
$tempHeight = 0
While $tempHeight <= $itemHeight
	$tempWidth = 0
	While $tempWidth <= $itemWidth
		If NOT (EmptySpace("Stash", $stashx+29*$tempWidth, $stashy+29*$tempHeight)) Then
			Return 0
		EndIf
		$tempWidth = $tempWidth + 1
	WEnd
	$tempHeight = $tempHeight + 1
WEnd
Return 1
EndFunc

Func StashItem($x, $y)
$itemStashed = 0
$stashY = 156
While $stashY <= 359
	$stashX = 168
	While $stashX <= 313
		If EmptySpace("Stash", $stashX, $stashY) Then
			If SpaceFound($stashX, $stashY) Then
				MyMouseClick("left", ($stashX*2+29*$itemWidth)/2, ($stashY*2+29*$itemHeight)/2, $stashMouseSpeed)
				MySleep($dStashDelay)
				$itemStashed = 1
				ExitLoop(2)
			EndIf
		EndIf
		$stashX = $stashX + 29
	WEnd
	$stashY = $stashY + 29
WEnd
If ($itemStashed = 0) Then ;no room for item in stash
	MyMouseClick("left", ($x*2+29*$itemWidth)/2, ($y*2+29*$itemHeight)/2, $stashMouseSpeed) ;puts item back in inventory
	$tempHeight = 0
	For $tempHeight = 0 to $itemHeight
		$tempWidth = 0
		For $tempWidth = 0 to $itemWidth
			$invLock[GridPos($x+29*$tempWidth, $y+29*$tempHeight)] = 1 ;locks item in inventory
		Next
	Next
	MySleep($dStashDelay)
EndIf
EndFunc

Func Stash()
MyRMouseClick("left", 493, 462, 10, 9, $mouseSpeed)
MySleep($dMouseClick)
Send("{ENTER}")
MySleep($dMouseClick)
$y = 329
While $y <= 416
	$x = 433
	While $x <= 694
		MyMouseMove(380, 50, $mouseSpeed)
		If NOT (EmptySpace("Inventory", $x, $y)) AND $invLock[GridPos($x, $y)] = 0 Then
			FindItemSize($x, $y)
			StashItem($x, $y)
		EndIf
		$x = $x + 29
	WEnd
	$y = $y + 29
WEnd
EndFunc


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Main Loop Functions
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

Func Login()
MyRMouseClick("left", 414, 334, 50, 5, $mouseSpeed)
Send("^a")
Send("{DEL}")
Send($account, 1)
MySleep(100)
Send("{TAB}")
MySleep(100)
Send($password, 1)
MySleep($dMouseClick)
MyRMouseClick("left", 401, 469, 105, 9, $mouseSpeed)
Wait(557, 486, $charSelectCheck, $loginMin, $loginMax)
EndFunc

Func CharacterSelect()
Select
	Case $charPosition = 1
		MyRMouseClick("left", 172, 134, 129, 39, $mouseSpeed)
	Case $charPosition = 2
		MyRMouseClick("left", 444, 134, 129, 39, $mouseSpeed)
	Case $charPosition = 3
		MyRMouseClick("left", 172, 227, 129, 39, $mouseSpeed)
	Case $charPosition = 4
		MyRMouseClick("left", 444, 227, 129, 39, $mouseSpeed)
	Case $charPosition = 5
		MyRMouseClick("left", 172, 320, 129, 39, $mouseSpeed)
	Case $charPosition = 6
		MyRMouseClick("left", 444, 320, 129, 39, $mouseSpeed)
	Case $charPosition = 7
		MyRMouseClick("left", 172, 413, 129, 39, $mouseSpeed)
	Case $charPosition = 8
		MyRMouseClick("left", 444, 413, 129, 39, $mouseSpeed)
EndSelect
Sleep(50)
MouseClick("left")
Wait(555, 461, $chatCheck, $charSelectMin, $charSelectMax)
EndFunc

Func CreateGame()
MyRMouseClick("left", 593, 459, 59, 9, $mouseSpeed)
MySleep($dMouseClick)
MyRMouseClick("left", 511, 152, 78, 9, $mouseSpeed)
MySleep($dMouseClick)
Send($gameName[0])
Send($gameName[1])
$gameName[1] = Modulo($gameName[1] + 1, 100)
MySleep($dMouseClick)
Send("{TAB}")
MySleep($dMouseClick)
Send(Round(Random(1000, 999999), 0))
MySleep($dMouseClick)
MyRMouseClick("left", 681, 418, 82, 12, $mouseSpeed)
Wait(274, 573, $inGameCheck, $createGameMin, $createGameMax)
EndFunc

Func PrePindle() ;performs a variety of functions before going to red portal
If ($away = 0) AND NOT (StringLen($awayMessage) = 0) Then ;types in away message
	Send("{ENTER}")
	MySleep($dMouseClick)
	Send("/dnd " & $awayMessage)
	MySleep($dMouseClick)
	Send("{ENTER}")
	$away = 1
EndIf

If (MyPixelGetColor(529, 311) = $inAct4) Then
	GoToActFive()
	ExitGame()
Else
	$totalRuns = MyIniRead("statistics.ini", $slotToUse, "TotalRuns", "0") + 1
	$lastRuns = MyIniRead("statistics.ini", $slotToUse, "LastRuns", "0") + 1
	IniWrite("statistics.ini", $slotToUse, "TotalRuns", $totalRuns)
	IniWrite("statistics.ini", $slotToUse, "LastRuns", $lastRuns)
	TrayTip("RPB v" & $version & " Stats", "Run #" & $lastRuns & Chr(10) & "Runs Completed: " & $lastCompleted & Chr(10) & "Success Rate: " & MyIniRead("statistics.ini", $slotToUse, "LastSuccessRate", "") & Chr(10) & "Deaths: " & $lastDeaths & Chr(10) & "Chickens: " & $lastChickens & Chr(10) & "Last Run Time: " & Round($runTime/1000, 3), 6, 17)

	If ($usePickit = 1) Then
		Send("{ENTER}") ;turns off pickit until after attack sequence
		MySleep($dMouseClick)
		Send($magicChar & "set pickit 0")
		MySleep($dMouseClick)
		Send("{ENTER}")
		If ($noPickup = 1) Then
			MySleep($dMouseClick)
			Send("{ENTER}")
			MySleep($dMouseClick)
			Send($magicChar & "set gselect 0")
			MySleep($dMouseClick)
			Send("{ENTER}")
		EndIf
		MySleep($dMouseClick)
	EndIf

	Send("i")
	MySleep($dMouseClick)

	MyMouseMove(350, 350, $mouseSpeed)

	If NOT (MyPixelGetColor(547, 171) = $corpseCheck) AND NOT ($lastCompleted = 0) Then ;character death on last run
		$totalDeaths = MyIniRead("statistics.ini", $slotToUse, "TotalDeaths", "0") + 1
		$lastDeaths = MyIniRead("statistics.ini", $slotToUse, "LastDeaths", "0") + 1
		IniWrite("statistics.ini", $slotToUse, "TotalDeaths", $totalDeaths)
		IniWrite("statistics.ini", $slotToUse, "LastDeaths", $lastDeaths)
		IniWrite("statistics.ini", $slotToUse, "TotalCompleted", $totalCompleted - 1)
		IniWrite("statistics.ini", $slotToUse, "LastCompleted", $lastCompleted - 1)

		MyRMouseClick("left", 200, 281, 2, 5, $mouseSpeed) ;picks up corpse
		MySleep($dGetCorpse)

		Send("{SHIFTDOWN}")
		$y = 329
		While $y <= 416 ;puts pots back in belt
			$x = 433
			While $x <= 694
				If NOT (PotionTest($x, $y) = 0) Then
					MyRMouseClick("left", $x, $y, 5, 5, $mouseSpeed)
					MySleep($dMouseClick)
				EndIf
				$x = $x + 29
			WEnd
			$y = $y + 29
		WEnd
		Send("{SHIFTUP}")
	EndIf

	$y = 329
	While $y <= 416 ;uses pots in inventory
		$x = 433
		While $x <= 694
			If NOT (PotionTest($x, $y) = 0) Then
				MyRMouseClick("right", $x, $y, 5, 5, $mouseSpeed)
				MySleep($dMouseClick)
			EndIf
			$x = $x + 29
		WEnd
		$y = $y + 29
	WEnd

	MyMouseMove(350, 350, $mouseSpeed)
	If ($lastCompleted = 0) Then ;on the first run
		$corpseCheck = MyPixelGetColor(547, 171)
		$y = 329
		While $y <= 416
			$x = 433
			While $x <= 694
				If NOT (EmptySpace("Inventory", $x, $y)) Then
					$invLock[GridPos($x, $y)] = 1 ;locks charms, etc. in inventory
				EndIf
				$x = $x + 29
			WEnd
			$y = $y + 29
		WEnd
	EndIf

	Send("i")
	MySleep($dMouseClick)

	If NOT ($needMerc = 0) Then ;resurrects merc if it died
		If (MyPixelGetColor(23, 17) = $mercInAct5) Then
			$mercAlive = 1 ;merc is alive, do nothing
		Else
			$mercAlive = 0
			ResMerc()
		EndIf
	EndIf

	Send("{SPACE}") ;makes sure screen is clear, e.g. inv is not still up

	If ($healLife > 0) Then
		RunWait("d2stats.exe") ;uses a potion from belt, if necessary
		$currenthealth = Abs(MyIniRead("d2stats.ini", "Current", "Health", ""))
		If ($currenthealth < $healLife) Then
			$healSlot = FindPotInBelt(2)
			Send($healSlot)
		EndIf
	EndIf
EndIf
EndFunc

Func MoveToPortal()
$stashCount = $stashCount + 1
MyRMouseClick("left", 97, 511, 2, 2, $mouseSpeed) ;goes down 1st set of stairs
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 216, 511, 2, 2, $mouseSpeed) ;goes down 2nd set of stairs
RunningWait($runningMin, $runningMax)
If ($stashCount = $stash) AND NOT ($stash = 0) Then
	MyMouseClick("left", 681, 336, $mouseSpeed) ;click on stash
	RunningWait($runningMin, $runningMax)
	Send("n") ;clears all in-game messages
	Wait(168, 93, $stashOpen, 400, 3000)
	If (MyPixelGetColor(168, 93) = $stashOpen) Then
		Stash()
		$stashCount = 0
	Else
		$stashCount = $stashCount - 1
	EndIf
	Do
		Send("{SPACE}")
		MySleep($dMouseClick)
	Until NOT (MyPixelGetColor(168, 93) = $stashOpen)
	MyRMouseClick("left", 148, 223, 2, 2, $mouseSpeed) ;return to normal path
	RunningWait($runningMin, $runningMax)
EndIf
MyRMouseClick("left", 197, 533, 2, 2, $mouseSpeed) ;runs across wp
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 202, 536, 2, 2, $mouseSpeed) ;runs to tree
RunningWait($runningMin, $runningMax)
MyRMouseClick("left", 47, 301, 2, 2, $mouseSpeed) ;runs past tree to portal
RunningWait($runningMin, $runningMax)
EndFunc

Func EnterPortal()
Precast($precast1) ;precast before entering portal
RunWait("d2stats.exe")
MyRMouseClick("left", $portalX, $portalY, 2, 2, $portalMouseSpeed) ;enter portal
RunningWait($enterPortalMin, $runningMax)
Precast($precast2) ;precast after entering portal
EndFunc()

Func GoToPindle()
$teleTemp = StringSplit(StringTrimRight($teleport, 1), ",")
;$teleTemp[1] is the teleport hotkey, $teleTemp[2] is the delay
SendHotKey($teleTemp[1]) ;teleporting to pindleskin
MySleep($dMouseClick)
MyRMouseClick("right", 747, 21, 2, 2, $mouseSpeed)
MySleep($teleTemp[2])
MyRMouseClick("right", 747, 21, 2, 2, $mouseSpeed)
MySleep($teleTemp[2])
MyRMouseClick("right", $lastTeleX, $lastTeleY, 2, 2, $mouseSpeed)
MySleep($teleTemp[2])
$inTemple = 1
EndFunc

Func Attack()
$attacks = StringSplit(StringTrimRight($attackSequence, 1), ";")
Local $mouseButton
For $i = 1 to $attacks[0]
	$currentAttack = StringSplit($attacks[$i], ",")
	;$currentAttack[1] is the hotkey
	;$currentAttack[2] is the # of repeats
	;$currentAttack[3] is the mouse button
	;$currentAttack[4] is the delay
	If ($currentAttack[3] = 1) Then
		$mouseButton = "left"
	ElseIf ($currentAttack[3] = 2) Then
		$mouseButton = "right"
	EndIf

	SendHotKey($currentAttack[1])
	MySleep($dMouseClick)

	;begin attack sequence
	If ($currentAttack[2] = "H") Then
		MyRMouseMove($attackX, $attackY, 15, 12, $mouseSpeed)
		MouseDown($mouseButton)
		MySleep($currentAttack[4])
		MouseUp($mouseButton)
	Else
		For $n = 1 to $currentAttack[2]
			If ($currentAttack[3] = 0) Then ;forces a delay if mouse button is 0
				MySleep($currentAttack[4])
			ElseIf ($currentAttack[3] = 1) Then
				Send("{SHIFTDOWN}")
				MySleep(20)
				MyRMouseClick($mouseButton, $attackX, $attackY, 15, 12, $mouseSpeed)
				Send("{SHIFTUP}")
			Else
				MyRMouseClick($mouseButton, $attackX, $attackY, 15, 12, $mouseSpeed)
			EndIf
			MercHealthCheck()
			MySleep($currentAttack[4])
		Next
	EndIf
Next
EndFunc

Func PostAttack()
MyRMouseClick("left", $grabClickX, $grabClickY, 5, 5, $mouseSpeed) ;run over to make sure items are picked up
If ($usePickit = 1) Then
	Send("{ENTER}") ;turns pickit back on
	MySleep($dMouseClick)
	Send($magicChar & "set pickit 1{ENTER}")
EndIf
MySleep($dPickUpItems)
If (MyPixelGetColor(191, 242) = $deathCheck) Then ;checks to see if player died
	Send("{ESC}")
	MySleep(2000)
EndIf
EndFunc

Func ExitGame()
$exitAttempts = 0
While (MyPixelGetColor(274, 573) = $inGameCheck)
	If ($exitAttempts = 5) Then
		CloseD2($dCloseD2)
		ExitLoop
	EndIf
	Send("{ESC}") ;exit game
	MyRMouseClick("left", 397, 261, 200, 20, $mouseSpeed)
	MySleep(1000)
	$exitAttempts = $exitAttempts + 1
WEnd
Wait(555, 461, $chatCheck, $exitGameMin, $exitGameMax)
EndFunc

Func MainLoop()
While 1
	$marker = 0
	$runWasCompleted = 0

	If ($currentInterval = 0) AND NOT ($runInterval = 0) Then
		$currentInterval = Round(Random($runInterval - $intervalVariance, $runInterval + $intervalVariance), 0) ;calculates the run interval length
		$lastCompletedInterval = 0
	EndIf

	If NOT (WinExists($d2WinTitle, "")) Then
		StartD2()
	EndIf

	If (MyPixelGetColor(401, 522) = $loginCheck) Then
		Login()
		$away = 0
	EndIf

	If (MyPixelGetColor(557, 486) = $charSelectCheck) Then
		CharacterSelect()
	EndIf
	
	If (MyPixelGetColor(555, 461) = $chatCheck) Then
		CreateGame()
	EndIf

	If (MyPixelGetColor(274, 573) = $inGameCheck) Then
		$startRun = TimerStart()
		$marker = 1
		$pauseTime = 0
		$restarts = 0
		$lastPotUse = 0

		PrePindle()
		If (MyPixelGetColor(274, 573) = $inGameCheck) Then
			MoveToPortal()
			If (MyPixelGetColor(274, 573) = $inGameCheck) Then
				EnterPortal()
				If (MyPixelGetColor(274, 573) = $inGameCheck) Then
					GoToPindle()
					If (MyPixelGetColor(274, 573) = $inGameCheck) Then
						Attack()
						If (MyPixelGetColor(274, 573) = $inGameCheck) Then
							PostAttack()
							$runWasCompleted = 1
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf

	$inTemple = 0

	If ($marker = 0) Then
		If ($restarts = 3) Then
			BotSleep(300)
		Else
			CloseD2($dCloseD2)
		EndIf
		TrayTip("RPB v" & $version, "Restarting Diablo II...", 6, 17)
		$restarts = $restarts + 1
	ElseIf (MyPixelGetColor(274, 573) = $inGameCheck) Then
		$runTime = Int(TimerStop($startRun) - $pauseTime)
		ExitGame()

		If ($runWasCompleted = 1) Then
			$lastCompletedInterval = $lastCompletedInterval + 1

			;calculates completed runs in statistics.ini
			$totalCompleted = MyIniRead("statistics.ini", $slotToUse, "TotalCompleted", "0") + 1
			$lastCompleted = MyIniRead("statistics.ini", $slotToUse, "LastCompleted", "0") + 1
			IniWrite("statistics.ini", $slotToUse, "TotalCompleted", $totalCompleted)
			IniWrite("statistics.ini", $slotToUse, "LastCompleted", $lastCompleted)

			;calculates run times in statistics.ini
			$bestruntime = MyIniRead("statistics.ini", $slotToUse, "BestRunTime", "")
			If (StringLen($bestruntime) = 0) OR ($runTime < $bestruntime) Then
				IniWrite("statistics.ini", $slotToUse, "BestRunTime", $runTime)
			EndIf
			$averageruntime = MyIniRead("statistics.ini", $slotToUse, "AverageRunTime", "0")
			$averageruntime = ($averageruntime * ($totalCompleted - 1) + $runTime) / $totalCompleted
			IniWrite("statistics.ini", $slotToUse, "AverageRunTime", Round($averageruntime, 0))
		EndIf
		IniWrite("statistics.ini", $slotToUse, "TotalSuccessRate", Round($totalCompleted * 100 / $totalRuns, 0))
		IniWrite("statistics.ini", $slotToUse, "LastSuccessRate", Round($lastCompleted * 100 / $lastRuns, 0))

		If ($lastCompleted = $runs) OR ($quit = 2) Then
			Quit()
		ElseIf ($lastCompletedInterval = $currentInterval) AND NOT ($currentInterval = 0) Then
			$currentInterval = 0 ;re-initializes run interval to 0
			BotSleep(Round(Random($sleepTime - $sleepVariance, $sleepTime + $sleepVariance), 0))
		EndIf
	EndIf
WEnd
EndFunc


;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Begin Script - Configuration Checks
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

TrayTip("RPB v" & $version, "Rishodi's Pindlebot v" & $version & Chr(10) & "Validating configuration...", 6, 17)
If (StringLen($attackSequence) = 0) Then ;checks to see if specified slot was found
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Invalid slot name ( " & $slotToUse & " ). Check your configuration.")
	Quit()
EndIf

Dim $temp[3][2]
$temp[0][0] = $teleport
$temp[0][1] = "teleport"
$temp[1][0] = $precast1
$temp[1][1] = "first precast"
$temp[2][0] = $precast2
$temp[2][1] = "second precast"
$errorMsg = ""

For $i = 0 to 2
;current config to check is $temp[$i][0]
If (($i = 0) OR (StringLen($temp[$i][0]) > 0)) Then
	If NOT (StringRight($temp[$i][0], 1) = ";") Then
		$errorMsg = "Add a semicolon to the end of the sequence."
		ExitLoop
	ElseIf (StringLen($temp[$i][0]) < 4) Then
		$errorMsg = "Specify a valid hotkey and delay."
		ExitLoop
	EndIf
	$j = 1
	$split = StringSplit(StringTrimRight($temp[$i][0], 1), ";")
	Do
		$stringCheck = StringSplit($split[$j], ",")
		If ($stringCheck[0] = 1) Then
			$errorMsg = "Invalid delay."
			ExitLoop(2)
		ElseIf ($stringCheck[0] > 2) Then
			$errorMsg = "Too many parameters, only two are needed."
			ExitLoop(2)
		ElseIf NOT ((StringLen($stringCheck[1]) > 0) AND (StringLen($stringCheck[2]) > 0)) Then
			$errorMsg = "Specify a valid hotkey and delay."
			ExitLoop(2)
		ElseIf NOT (StringRight($temp[$i][0], 1) = ";") Then
			$errorMsg = "Add a semicolon to the end of the sequence."
			ExitLoop(2)
		EndIf
		$j = $j + 1
	Until ($split[0] < $j)
EndIf
Next
If (StringLen($errorMsg) > 0) Then
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Invalid " & $temp[$i][1] & " sequence: '" & $temp[$i][0] & "'" & Chr(10) & "The correct format is: 'Hotkey,Delay;'" & Chr(10) & Chr(10) & "Error: " & $errorMsg)
	Quit()
EndIf
$temp = 0

$splitAttacks = StringSplit(StringTrimRight($attackSequence, 1), ";")
For $i = 1 to $splitAttacks[0]
	$oneAttack = StringSplit($splitAttacks[$i], ",")
	If ($oneAttack[0] < 4) Then
		$errorMsg = "Too few parameters, four are needed per attack."
		ExitLoop
	ElseIf ($oneAttack[0] > 4) Then
		$errorMsg = "Too many parameters, four are needed per attack."
		ExitLoop
	ElseIf NOT (StringLen($oneAttack[1]) > 0) Then
		$errorMsg = "Invalid hotkey."
		ExitLoop
	ElseIf NOT ((StringLen($oneAttack[2]) > 0) AND ($oneAttack[2] > 0) OR ($oneAttack[2] = "H")) Then
		$errorMsg = "Invalid number of attack repeats."
		ExitLoop
	ElseIf NOT ((($oneAttack[3] = 1) OR ($oneAttack[3] = 2)) AND (StringLen($oneAttack[3]) > 0)) Then
		$errorMsg = "Improperly configured mouse button. Acceptable values are 1 (left) and 2 (right)."
		ExitLoop
	ElseIf NOT (StringLen($oneAttack[4]) > 0) Then
		$errorMsg = "Invalid attack delay."
		ExitLoop
	EndIf
Next
If NOT (StringRight($attackSequence, 1) = ";") Then
	$errorMsg = "Add a semicolon to the end of the sequence."
EndIf
If (StringLen($errorMsg) > 0) Then
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Invalid attack sequence: '" & $attackSequence & "'" & Chr(10) & "The correct format is: 'Hotkey,Repeats,Button,Delay;'" & Chr(10) & Chr(10) & "Error: " & $errorMsg)
	Quit()
EndIf

Dim $temp[3]
$temp[0] = "pindlebot.ini"
$temp[1] = "advanced.ini"
$temp[2] = "d2stats.exe"

For $i = 0 to 2
	If NOT FileExists(@ScriptDir & "\" & $temp[$i]) AND NOT (($i = 2) AND ($healLife = 0)) Then
		$errorMsg = $temp[$i]
		ExitLoop
	EndIf
Next
If (StringLen($errorMsg) > 0) Then
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Could not find file: " & $errorMsg & Chr(10) & Chr(10) & "Please ensure that all RPB files are in the same directory.")
	Quit()
EndIf
$temp = 0
If NOT FileExists($d2path & "\" & $d2exe) Then
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Could not locate Diablo II executable: " & $d2path & "\" & $d2exe & Chr(10) & Chr(10) & "Please ensure that this path is correct.")
	Quit()
EndIf

If ($usePickit = 1) Then
	Dim $temp[3]
	$temp[0] = $d2path & "\Plugin\zoid.dll"
	$temp[1] = $d2path & "\Plugin\zoid.ini"
	$temp[2] = $d2path & "\Plugin\zpickit.ini"
	For $i = 0 to 2
		If NOT FileExists($temp[$i]) Then
			$errorMsg = $temp[$i]
			ExitLoop
		EndIf
	Next
	If (StringLen($errorMsg) > 0) Then
		MsgBox(16, "Rishodi's Pindlebot v" & $version, "Could not find file: " & $errorMsg & Chr(10) & Chr(10) & "zPickit should be installed in this directory: " & $d2path & "\Plugin\")
		Quit()
	EndIf
EndIf
$temp = 0

If ($healLife <= $chickenLife) Then
	$chickenLife = 0 ;disables chicken life for an invalid value, i.e. chicken life # is greater than heal life #
EndIf




;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
; Initialization
;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

;checks for updates
If (MyIniRead("advanced.ini", "Misc", "UpdateNotify", "0") = 1) Then
	TrayTip("RPB v" & $version, "Rishodi's Pindlebot v" & $version & Chr(10) & "Checking for updates...", 6, 17)
	URLDownloadToFile("                                          ", "version.txt")
	MySleep(100)
	$versionFile = FileOpen("version.txt", 0)
	If NOT ($versionFile = -1) Then
		$newestVersion = FileReadLine($versionFile, 1)
		If NOT ($newestVersion  = $version) Then
			$update = MsgBox(64, "Rishodi's Pindlebot v" & $version, "A newer version (v" & $newestVersion & ") is available for download at                               ")
		EndIf
		FileClose("version.txt")
	EndIf
	FileDelete("version.txt")
EndIf
TrayTip("RPB v" & $version, "Rishodi's Pindlebot v" & $version & Chr(10) & "Initializing...", 6, 17)

;sets statistics.ini for active slot name if it doesn't already exist
If (StringLen(MyIniRead("statistics.ini", $slotToUse, "TotalRuns", "")) = 0) Then
	IniWrite("statistics.ini", $slotToUse, "TotalRuns", "0")
	IniWrite("statistics.ini", $slotToUse, "TotalCompleted", "0")
	IniWrite("statistics.ini", $slotToUse, "TotalSuccessRate", "")
	IniWrite("statistics.ini", $slotToUse, "TotalDeaths", "0")
	IniWrite("statistics.ini", $slotToUse, "TotalChickens", "0")
	IniWrite("statistics.ini", $slotToUse, "BestRunTime", "")
	IniWrite("statistics.ini", $slotToUse, "AverageRunTime", "0")
EndIf
;resets last statistics to 0
IniWrite("statistics.ini", $slotToUse, "LastRuns", "0")
IniWrite("statistics.ini", $slotToUse, "LastCompleted", "0")
IniWrite("statistics.ini", $slotToUse, "LastSuccessRate", "")
IniWrite("statistics.ini", $slotToUse, "LastDeaths", "0")
IniWrite("statistics.ini", $slotToUse, "LastChickens", "0")

If FileExists("d2stats.ini") Then
	FileDelete("d2stats.ini")
EndIf
;writes new d2stats.ini file
IniWrite("d2stats.ini", "Current", "Health", "")

RegWrite("HKEY_CURRENT_USER\Software\Blizzard Entertainment\Diablo II", "Resolution", "REG_DWORD", "1")
;makes sure in-game resolution is 800x600

RegWrite("HKEY_CURRENT_USER\Software\Blizzard Entertainment\Diablo II", "DIFF_LEVEL", "REG_DWORD", $difficulty - 1)
;sets difficulty level: 0 = Normal, 1 = Nightmare, 2 = Hell

;AutoItSetOption("MouseCoordMode", 1)
;AutoItSetOption("PixelCoordMode", 1)

;For $i = 0 to 12
;	MyMouseMove(Random(200,800),Random(200,600))
;	Sleep(300000)
;Next

AutoItSetOption("MouseCoordMode", 0)
AutoItSetOption("PixelCoordMode", 0)

If NOT (WinActive($d2WinTitle, "")) Then
	If NOT (WinExists($d2WinTitle, "")) Then
		StartD2()
	Else
		ActivateD2()
		WinSize()
	EndIf
EndIf

AdlibEnable("GameCheck", $healPeriod)

MainLoop()


;disconnects from internet
AutoItSetOption("MouseCoordMode", 1)
AutoItSetOption("PixelCoordMode", 1)
MyMouseClick("left", 48, 716, $mouseSpeed)
MySleep(5000)
MyMouseClick("left", 273, 456, $mouseSpeed)
MySleep(5000)
MyMouseClick("left", 468, 456, $mouseSpeed)
MySleep(5000)
MyMouseClick("left", 484, 456, $mouseSpeed)