$user=inputbox("Restarter","Give Login:")
$password=inputbox("Restarter","Give Password:")
$character=inputbox("Restarter","Which character to Select (1,2,3):")
$tab=inputbox("Restarter","Which tab will you fight on? (1,2,3,4):")
$start=inputbox("Restarter","Desktop Resolution?          1 = 800x600  ;            2 = 1024x768   ;   3 = 1280x1024")
$login=inputbox("Restarter","Ingame Resolution?           1 = 800x600  ;            2 = 1024x768   ;   3 = 1280x1024")
Global $Paused
HotKeySet("/", "Pause")

Func Pause()
    $Paused = NOT $Paused
While  $Paused
        Sleep (400)
WEnd
EndFunc

check()

Func start()
if $start == 1 then
start800()
endif
if $start = 2 then
start1024()
endif
if $start = 3 then
start1280()
endif
MsgBox(4096, "PROBLEM :(", "You've picked a resolution incorrectly.  Start the bot again and READ how to choose your resolution.")
exit
EndFunc

Func login()
if $login = 1 then
login800()
endif
if $login = 2 then
login1024()
endif
if $login = 3 then
login1280()
endif
MsgBox(4096, "PROBLEM :(", "You've picked a resolution incorrectly.  Start the bot again and READ how to choose your resolution.")
exit
EndFunc

Func charselect()
if $login = 1 then
charselect800()
endif
if $login = 2 then
charselect1024()
endif
if $login = 3 then
charselect1280()
endif
MsgBox(4096, "PROBLEM :(", "You've picked a resolution incorrectly.  Start the bot again and READ how to choose your resolution.")
exit
EndFunc

Func start800()
sleep (250)
if WinExists("SRO_Client") then
 login()    
 else 
 if Winexists("Silkroad Online Launcher") then
 sleep (250)
 winactivate("Silkroad Online Launcher")
 sleep (250)
 mousemove(680,435,0)
   sleep (250)
   $start1280 = pixelsearch (625,430,670,440,0xFFFFFF)
   if not @error then
    sleep (250)
    mousemove(680,435,0)
    sleep (500)
    mouseclick("left",630,436,2)
    login()
   else
   start()
   endif
  else
 Run("C:\Program Files\Silkroad\silkroad.exe")
 sleep (1000)
if pixelgetcolor(240,310) = 0xD4D0C8 then
MsgBox(4096, "PROBLEM :(", "Either the server is down, or you've lost internet connectivity")
exit
endif
 start()
 endif
endif
Endfunc

Func start1024()
sleep (250)
if WinExists("SRO_Client") then
 login()    
 else 
 if Winexists("Silkroad Online Launcher") then
 sleep (250)
 winactivate("Silkroad Online Launcher")
 sleep (250)
 mousemove(765,520,0)
   sleep (250)
   $start1280 = pixelsearch (735,510,785,525,0xFFFFFF)
   if not @error then
    sleep (250)
    mousemove(765,520,0)
    sleep (500)
    mouseclick("left",740,520,2)
   login()
  else
  start()
  endif
 else
 Run("C:\Program Files\Silkroad\silkroad.exe")
 sleep (1000)
  if pixelgetcolor(300,400) = 0xD4D0C8 then
  MsgBox(4096, "PROBLEM :(", "Either the server is down, or you've lost internet connectivity")
  exit
  endif
 start()
 endif
endif
Endfunc

Func start1280()
sleep (250)
if WinExists("SRO_Client") then
 login()    
 else 
 if Winexists("Silkroad Online Launcher") then
 sleep (250)
 winactivate("Silkroad Online Launcher")
 sleep (250)
 mousemove(890,648,0)
  sleep (250)
   $start1280 = pixelsearch (865,640,915,650,0xFFFFFF)
   if not @error then
    sleep (250)
    mousemove(890,648,0)
    sleep (500)
    mouseclick("left",878,648,2)
    login()
   else
   start()
   endif
 else
 Run("C:\Program Files\Silkroad\silkroad.exe")
 sleep (1000)
if pixelgetcolor(400,500) = 0xD4D0C8 then
MsgBox(4096, "PROBLEM :(", "Either the server is down, or you've lost internet connectivity")
exit
endif
 start()
 endif
endif
Endfunc

Func login800()
 while PixelGetColor(500,50) <> 0x000000
  winactivate("SRO_Client")
  sleep (250)
 wend
 sleep(2000)
 ControlSend("SRO_Client", "", "", "{ENTER}")
 sleep(1000)
 Send($user)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{TAB}")
 sleep(1000)
 send($password)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{Enter}")
  while PixelGetColor(390,590) = 0xFFFFFF
    $disconnect = pixelsearch(295,280,305,290,0x313131,25,1)
    if not @error then
     mousemove(405,340,0)
     mouseclick("left",405,340)
     sleep (250)
     mouseclick("left",405,340)
     sleep (2000)
     check()
    endif
   ControlSend("SRO_Client", "", "", "{ENTER}")
   sleep (1000)
  wend
charselect()
EndFunc

Func login1024()
 while PixelGetColor(500,50) <> 0x000000
  winactivate("SRO_Client")
  sleep (250)
 wend
 sleep(5000)
 ControlSend("SRO_Client", "", "", "{ENTER}")
 sleep(1000)
 Send($user)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{TAB}")
 sleep(1000)
 send($password)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{Enter}")
  while PixelGetColor(500,755) = 0xFFFFFF
    $disconnect = pixelsearch(410,360,420,370,0x313131,25,1)
    if not @error then
     sleep (250)
     mousemove(505,425,0)
     mouseclick("left",510,425)
     sleep (250)
     mouseclick("left",510,425)
     sleep (2000)
     check()
    endif
   ControlSend("SRO_Client", "", "", "{ENTER}")
   sleep (1000)
  wend
charselect()
EndFunc

Func login1280()
 while PixelGetColor(500,50) <> 0x000000
  winactivate("SRO_Client")
  sleep (250)
 wend
 sleep(2000)
 ControlSend("SRO_Client", "", "", "{ENTER}")
 sleep(1000)
 Send($user)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{TAB}")
 sleep(1000)
 send($password)
 sleep(1000)
 ControlSend("SRO_Client", "", "", "{Enter}")
  while PixelGetColor(625,1025) = 0xFFFFFF
    $disconnect = pixelsearch(535,490,545,500,0x313131,25,1)
    if not @error then
     sleep (250)
     mousemove(640,550,0)
     mouseclick("left",640,550)
     sleep (250)
     mouseclick("left",640,550)
     sleep (2000)
     check()
    endif
   ControlSend("SRO_Client", "", "", "{ENTER}")
   sleep (1000)
  wend
charselect()
EndFunc

func charselect800()
sleep(4000)
$char = PixelSearch ( 145, 58, 205, 75, 0xD5BC89, 25)
if not @error then
  sleep(2000)
   If $character=1 then
    MouseMove(225,290,0)
    MouseClick("left",255,290,2)
    MouseClick("left",255,290,2)
   EndIf
   If $character=2 then
    MouseMove(410,290,0)
    MouseClick("left",410,290,2)
    MouseClick("left",410,290,2)
   EndIf
   If $character=3 then
    MouseMove(550,290,0)
    MouseClick("left",550,290,2)
    MouseClick("left",550,290,2)
   EndIf
   sleep(800)
   If (PixelGetColor(540,145) = 0x9E8653) then
    SoundPlay("C:\Windows\media\notify.wav")
    sleep(2200)
    MouseMove(530,550,0)
    MouseClick("left",530,550,2)
   EndIf
while pixelgetcolor(690,16) <> 0x080808
sleep (2000)
wend
setup()
else
charselect()
endif
endfunc

func charselect1024()
sleep(4000)
$char = PixelSearch ( 185, 70, 265, 95, 0xD5BC89, 25)
if not @error then
  sleep(2000)
   If $character=1 then
    MouseMove(325,348,0)
    MouseClick("left",325,348,2)
    MouseClick("left",325,348,2)
   EndIf
   If $character=2 then
    MouseMove(521,362,0)
    MouseClick("left",521,362,2)
    MouseClick("left",521,362,2)
   EndIf
   If $character=3 then
    MouseMove(704,374,0)
    MouseClick("left",704,374,2)
    MouseClick("left",704,374,2)
   EndIf
   sleep(800)
   If (PixelGetColor(789,231) = 16765009) then
    SoundPlay("C:\Windows\media\notify.wav")
    sleep(2200)
    MouseMove(791,710,0)
    MouseClick("left",791,710,2)
   EndIf
while pixelgetcolor(795,760) <> 0x313131
sleep (2000)
wend
setup()
else
charselect()
endif
EndFunc

func charselect1280()
sleep(4000)
$char = PixelSearch ( 230, 100, 330, 125, 0xD5BC89, 25)
if not @error then
  sleep(2000)
   If $character=1 then
    MouseMove(400,500,0)
    MouseClick("left",400,500,2)
    MouseClick("left",400,500,2)
   EndIf
   If $character=2 then
    MouseMove(650,500,0)
    MouseClick("left",650,500,2)
    MouseClick("left",650,500,2)
   EndIf
   If $character=3 then
    MouseMove(875,500,0)
    MouseClick("left",875,500,2)
    MouseClick("left",875,500,2)
   EndIf
   sleep(800)
   If (PixelGetColor(999,332) = 0xCFAE6D) then
    SoundPlay("C:\Windows\media\notify.wav")
    sleep(2200)
    MouseMove(1000,940,0)
    MouseClick("left",1000,940,2)
   EndIf
while pixelgetcolor(1168,15) <> 0x080808
sleep (2000)
wend
setup()
else
charselect()
endif
endfunc

func check800()
if WinExists("SRO_Client") then
;DISCONNECTED TO THE SERVER, HURRR
    if pixelgetcolor(300,285) = 0x313131 then
    mousemove(405,340,0)
    mouseclick("left",405,340)
     sleep (250)
    mouseclick("left",405,340)
     sleep (2000)
     start()
   else
   fight()
  endif
;YOU DIED, HUH
 if pixelgetcolor(381,316) = 0x000000 then
  MsgBox(4096, "PROBLEM :(", "You seem to have died, the bot has stopped")
  exit
 endif
else
start()
endif
endfunc

func check1024()
if WinExists("SRO_Client") then
;DISCONNECTED TO THE SERVER, HURRR
  if pixelgetcolor(434,365) = 0xFFFFFF then
   mousemove(500,400,0)
   sleep(250)
   mouseclick("left",500,420,2)
   sleep(5000)
   start()
   else
   fight()
  endif
;YOU DIED, HUH
 if pixelgetcolor(539,494) = 0xFEFBD8 then
  MsgBox(4096, "PROBLEM :(", "You seem to have died, the bot has stopped")
  exit
 endif
else
start()
endif
endfunc

func check1280()
if WinExists("SRO_Client") then
;DISCONNECTED TO THE SERVER, HURRR
  if pixelgetcolor(662,521) = 0xFFFFFF then
   mousemove(650,570,0)
   sleep(250)
   mouseclick("left",650,570,2)
   sleep(5000)
   start()
   else
   fight()
  endif
;YOU DIED, HUH
 if pixelgetcolor(619,529) = 0xE6C631 then
  MsgBox(4096, "PROBLEM :(", "You seem to have died, the bot has stopped")
  exit
 endif
else
start()
endif
endfunc

func check()
if $login = 1 then
check800()
endif
if $login = 2 then
check1024()
endif
if $login = 3 then
check1280()
endif
MsgBox(4096, "PROBLEM :(", "You've picked a resolution incorrectly.  Start the bot again and READ how to choose your resolution.")
endfunc

func setup()
sleep (4000)
if $tab=1 then
 send("{f1}")
endif
if $tab=2 then
 send("{f2}")
endif
if $tab=3 then
 send("{f3}")
endif
if $tab=4 then
 send("{f4}")
endif
sleep (500)
send ("{F9}")
sleep (500)
MouseMove(500,500,0)
Sleep (500)
MouseClickDrag("right",500,500,500,530,10)
sleep (500)
MouseWheel("down")
fight()
endfunc

func fight()
if $login = 1 then
fight800()
endif
if $login = 2 then
fight1024()
endif
if $login = 3 then
fight1280()
endif
MsgBox(4096, "PROBLEM :(", "You've picked a resolution incorrectly.  Start the bot again and READ how to choose your resolution.")
endfunc

Func fight800()
$berserk = pixelsearch(24,8,36,18,0xFF4576 ,45,1)
if not @error then
send ("{tab}")
endif
;MONSTRZ light
$coord = PixelSearch( 50, 750, 80, 370, 0xFF00FF, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 415, 400, 750, 500, 0xFF00FF, 25, 1)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

;MONSTRZ dark
$coord = PixelSearch( 50, 750, 80, 370, 0x5E006D, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 415, 400, 750, 500, 0x5E006D, 25, 1)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

send ("{left 4}")
;Speed buff, if you have one, goes here
send ("5")

$health = PixelSearch( 362, 563, 390, 590, 0xFF0000, 25, 1)
if Not @error then
check()
else
send ("{esc}")
sleep (250)
mousemove (400,370,0)
sleep (250)
mouseclick ("left",400,370,2)
MsgBox(4096, "PROBLEM :(", "Sigh, you're out of health potions.  We quit while we were ahead, hopefully.")
exit
endif

EndFunc

Func fight1024()
$berserk = pixelsearch(25,7,35,17,0xFF4576 ,45,1)
if not @error then
send ("{tab}")
endif
;MONSTRZ light
$coord = PixelSearch( 50, 100, 1000, 525, 0xFF00FF, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 405, 275, 660, 650, 0xFF00FF, 25, 1)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

;MONSTRZ dark
$coord = PixelSearch( 50, 100, 1000, 525, 0x5E006D, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 405, 275, 660, 650, 0x5E006D, 25, 1)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

send ("{left 4}")
;Speed buff, if you have one, goes here
send ("5")

$health = PixelSearch( 480, 730, 508, 760, 0xFF0000, 25, 1)
if Not @error then
check()
else
send ("{esc}")
sleep (250)
mousemove (500,450,0)
sleep (250)
mouseclick ("left",500,450,2)
MsgBox(4096, "PROBLEM :(", "Sigh, you're out of health potions.  We quit while we were ahead, hopefully.")
exit
endif

EndFunc

Func fight1280()
$berserk = pixelsearch(24,7,35,21,0xFF4576 ,45,1)
if not @error then
send ("{tab}")
endif
;MONSTRZ light
$coord = PixelSearch( 50, 85, 1000, 790, 0xFF00FF, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 50, 85, 1000, 790, 0xFF00FF, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

;MONSTRZ dark
$coord = PixelSearch( 50, 85, 1000, 790, 0x5E006D, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1])
    Sleep (500)
attack()
Else
;searches for monsters under your character once the monster you were on is dead
$coord = PixelSearch( 50, 85, 1000, 790, 0x5E006D, 25, 2)
If Not @error Then
    MouseMove($coord[0],$coord[1],0)
    Sleep (100)
    MouseClick("left",$coord[0],$coord[1]+20)
    Sleep (500)
attack()
Endif
Endif

send ("{left 4}")
;Speed buff, if you have one, goes here
send ("5")

$health = PixelSearch( 605, 985, 630, 1012, 0xFF0000, 25, 1)
if Not @error then
check()
else
send ("{esc}")
sleep (250)
mousemove (640,580,0)
sleep (250)
mouseclick ("left",640,580,2)
MsgBox(4096, "PROBLEM :(", "Sigh, you're out of health potions.  We quit while we were ahead, hopefully.")
exit
endif

EndFunc

Func attack()
if $login = 1 then
attack800()
endif
if $login = 2 then
attack1024()
endif
if $login = 3 then
attack1280()
endif
endfunc

Func attack800()
$fight = pixelsearch(564,44,568,49,0xFF3131,25,1)
if not @error then
 ;Skill imbue
 send ("1")
 sleep (250)
 send ("2")
 sleep (750)
 attack() 
else
 sleep (250)
 send ("g")
 sleep (375)
 send ("g")
 sleep (375)
 send ("g")
fight()
endif
endfunc

Func attack1024()
$fight = pixelsearch(436,44,439,49,0xFF3131,25,1)
if not @error then
 ;Skill imbue
 send ("1")
 sleep (250)
 send ("2")
 sleep (750)
 attack() 
else
 sleep (250)
 send ("g")
 sleep (375)
 send ("g")
 sleep (375)
 send ("g")
fight()
endif
endfunc

Func attack1280()
$fight = pixelsearch(564,44,568,49,0xFF3131,25,1)
if not @error then
 ;Skill imbue
 send ("1")
 sleep (250)
 send ("2")
 sleep (750)
 attack() 
else
 sleep (250)
 send ("g")
 sleep (375)
 send ("g")
 sleep (375)
 send ("g")
fight()
endif
endfunc