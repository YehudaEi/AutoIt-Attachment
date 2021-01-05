$recall = 0
$sound = 0
$res = 0
$scored = 0
$catch = 0
$finish = 0


$w = 16777215
$w2 = 16645629
$y = 16373772
$g = 51220
$maze = 16770355




$a = 422
$b = 420
$c = 424


$dd = 464
$ee = 470
$ff = 467


$gg = 450
$hh = 456
$ii = 453


$jj = 436
$kk = 442
$ll = 439


$mm = 422
$nn = 428
$oo = 425


$pp = 408
$qq = 414
$rr = 411


$ss = 394
$tt = 400
$uu = 397


$vv = 342
$ww = 348
$xx = 345


$yy = 328
$zz = 334
$za = 331


$zb = 314
$zc = 320
$zd = 316


$ze = 300
$zf = 306
$zg = 303


$zh = 286
$zi = 292
$zj = 289


$zk = 272
$zl = 278
$zm = 275


$zn = 480


HotKeySet("{ESC}", "Terminate")
HotKeySet("1", "TogglePause")
opt ("wintitlematchmode", 2)
WinMinimizeAll()
MouseMove(0, 0, 0)
SplashTextOn("HIGH ROLLER is running!", "press ESC to exit at any time." & @cr & _
"press ""1"" to toggle pause", 400, 50, 300, 20)




While 1
   WinClose("Private")
   ;create game from lobby.
   Call("newgame")
   
   
   ;wait for game to load.
   Call("load")
   
   
   ;check if you roll first and if so then quit and make a new game.
   Call("rollfirst")
   
   
   ;wait for player to resign.
   Call("resign")
   
   
   ;roll and fill out scorecard.
   Do
      WinClose("Private")
      $finish = PixelGetColor(197, 438)
      Call("rolling")
   Until $finish = 15695363
   
   
   
   ;return to lobby at end of game.
   WinClose("Private")
   Call("endgame")
   

   
WEnd

;-----------------------------------------------------------------------------------------------------------------------------------
Func resign()
   $last_passed_sec = -1
   $day_start = @MDAY
   $hour_start = @HOUR
   $min_start = @MIN
   $sec_start = @SEC
   $start_secs = ( (@HOUR * 60) + @MIN) * 60 + @SEC
   WinClose("Private") ;in case they send you a private message.

   $pxc = 15695363
   $plr = PixelGetColor(481, 302) ;checks to see if you are playing a guest.
   If $plr = 0 Then
      SplashTextOn("BAD GAME!", "opponent is a guest!." & @CR & "going back to lobby.....", 250, 50, 700, 350)
      Do
         WinClose("Private")
         MouseClick("left", 428, 454, 1, 0) ;if the guest resigns lower box
         Sleep(100)
         MouseClick("left", 467, 419, 1, 0) ;if the guest resigns upper box
         Sleep(100)
         MouseClick("left", 294, 416, 1, 0) ;if the guest resigns rating box
         Sleep(100)
         MouseClick("left", 583, 332, 1, 0)   ;options tab.
         Sleep(100)
         MouseClick("left", 577, 468, 1, 0)  ;quit game.
         Sleep(100)
         MouseClick("left", 428, 416, 1, 0)   ;yes your sure.
         
         Sleep(100)
         MouseClick("left", 311, 417, 1, 0)
         Sleep(100)
         MouseClick("left", 583, 332, 1, 0)  ;options tab.
         Sleep(100)
         MouseClick("left", 582, 468, 1, 0)   ;back to lobby.
                  sleep(100)
         mouseclick("left",444,409,1,0) ;failed to join game box (you click ok)
         Sleep(500)
         $pxc = PixelGetColor(300, 230)
      Until $pxc = 15695363
      
      Call("newgame")
      Call("load")
      Call("rollfirst")
      Call("resign")
     ;############################################################################################################# 
   EndIf
   
   $afv = 0
   
   Do
      $afv = $afv + 1
      WinClose("Private")
      $quit = PixelGetColor(190, 266)
      Sleep(100)
      
      If $afv = 600 Then ;checks if game loaded for 1 minute
         $quit = 2259474
      EndIf
      
   Until $quit = 2259474
   
   If $afv = 600 Then
      Call("newgame")
      Call("load")
      Call("rollfirst")
      Call("resign")
      ;################################################################################################################
   EndIf
   
   
   $noroll = 0
   
   Do
   $rollwait = PixelGetColor(196, 523)
    $quit = PixelGetColor(190, 266)
      $noroll = $noroll + 1
      
      If $noroll = 3600 Then
         $quit = 0
         Call("newgame")
         Call("load")
         Call("rollfirst")
         Call("resign")
      ;##################################################################################################################
      EndIf
      
      Sleep(100)
      
      WinClose("Private")
      
      SplashTextOn("WAITING.....", "waiting for opponent to roll......", 250, 30, 700, 350)
      
      $chk = PixelGetColor(432, 349)
      If $chk = 0 Then ;opponent resignation box has appeared.
         SplashTextOn("QUITTER!", "opponent resigned before rolling!" & @CR & "going back to lobby.....", 250, 50, 700, 350)
         Sleep(1000)
         Do
            WinClose("Private")
            MouseClick("left", 428, 454, 1, 0) ;if the opponent resigns lower box
            Sleep(100)
            MouseClick("left", 467, 419, 1, 0) ;if the opponent resigns upper box
            Sleep(100)
            MouseClick("left", 294, 416, 1, 0) ;if the opponent resigns rating box
            Sleep(100)
            MouseClick("left", 583, 332, 1, 0)   ;options tab.
            Sleep(100)
            MouseClick("left", 577, 468, 1, 0)  ;quit game.
            Sleep(100)
            MouseClick("left", 428, 416, 1, 0)   ;yes your sure.
            Sleep(100)
            MouseClick("left", 311, 417, 1, 0)
            Sleep(100)
            MouseClick("left", 583, 332, 1, 0)  ;options tab.
            Sleep(100)
            MouseClick("left", 582, 468, 1, 0)   ;back to lobby.
                     sleep(100)
         mouseclick("left",444,409,1,0) ;failed to join game box (you click ok)
            Sleep(500)
            $pxc = PixelGetColor(300, 230)
         Until $pxc = 15695363
         
         Call("newgame")
         Call("load")
         Call("rollfirst")
         Call("resign")
         ;#############################################################################################################
      EndIf
      
      $plr = PixelGetColor(481, 302) ;checks to see if you are playing a guest.
      If $plr = 0 Then
         SplashTextOn("BAD GAME!", "opponent is a guest!." & @CR & "going back to lobby.....", 250, 50, 700, 350)
         Do
            WinClose("Private")
            MouseClick("left", 428, 454, 1, 0) ;if the guest resigns lower box
            Sleep(100)
            MouseClick("left", 467, 419, 1, 0) ;if the guest resigns upper box
            Sleep(100)
            MouseClick("left", 294, 416, 1, 0) ;if the guest resigns rating box
            Sleep(100)
            MouseClick("left", 583, 332, 1, 0)   ;options tab.
            Sleep(100)
            MouseClick("left", 577, 468, 1, 0)  ;quit game.
            Sleep(100)
            MouseClick("left", 428, 416, 1, 0)   ;yes your sure.
            
            Sleep(100)
            MouseClick("left", 311, 417, 1, 0)
            Sleep(100)
            MouseClick("left", 583, 332, 1, 0)  ;options tab.
            Sleep(100)
            MouseClick("left", 582, 468, 1, 0)   ;back to lobby.
                     sleep(100)
         mouseclick("left",444,409,1,0) ;failed to join game box (you click ok)
            Sleep(500)
            $pxc = PixelGetColor(300, 230)
         Until $pxc = 15695363
         Call("newgame")
         Call("load")
         Call("rollfirst")
         Call("resign")
         ;#############################################################################################
      EndIf
      
   Until $quit <> 2259474 Or $rollwait <> 940288
   
   If $noroll <> 360 Then
      
      Do
         WinClose("Private")
         SplashTextOn("WAITING.....", "waiting for opponent to resign......", 250, 30, 700, 350)
         Sleep(1500)
 SplashTextOn("HIGH ROLLER is running!", "press ESC to exit at any time." & @cr & _
"press ""1"" to toggle pause", 400, 50, 300, 20)
         Sleep(1000)
         $chk = PixelGetColor(432, 349) ;coordinates of black header on orange resignation box.
         $away = PixelGetColor(197, 456) ;coordinates of lower left corner on orange away box.
         
         
         If $chk = 0 Then   ;opponent resignation box has appeared.
            ;$res = PixelGetColor(196, 523) ; coordinates of the color of the cup when its there or not there.
            Do
               WinClose("Private")
               $chk = PixelGetColor(432, 349)
               Sleep(500)
               MouseClick("left", 428, 418, 1, 0)  ;click yes to continue playing.
            Until $chk <> 0
            
            $chk = 0
            $pxc = 0 ;stops the resign loop if the resign box appears.
         EndIf
         
         
         If $chk = 0 Then   ;opponent resignation box has appeared.
            $x = 60
            For $z = 1 To 60 ;this waits for 1 minute to be sure they left the game.
               WinClose("Private")
               Sleep(500)
               SplashTextOn("OPPONENT HAS RESIGNED!", "waiting 60 seconds..... " & $x, 250, 30, 700, 350)
               MouseMove(400, 400, 0) ;this keeps away box from appearing.
               $x = $x - 1
               Sleep(500)
               MouseMove(300, 300, 0)
            Next
            Do
               WinClose("Private")
               MouseClick("left", 428, 344, 1, 0)  ;click yes to continue playing if resignation box appears.
               Sleep(100)
               $chk = PixelGetColor(432, 349)
            Until $chk <> 0
         EndIf
         
         
         If $away = 15695363 Then ;orange away box has appeared.
            $pxc = 0 ;stops the resign loop if the away box appears, and goes through this "do until" loop.
            Do
               WinClose("Private")
               MouseMove(300, 300, 0)
               ;calculate the seconds passed by
               ;calculating here is only valid up to 24 hours!
               If @MDAY <> $day_start Then
                  $passed_secs = 24 * 60 * 60
               Else
                  $passed_secs = 0
               EndIf
               $passed_secs = $passed_secs - $start_secs + ( (@HOUR * 60) + @MIN) * 60 + @SEC
               
               
               $hour_passed = Int($passed_secs / 3600)
               $passed_secs = Mod($passed_secs, 3600)
               $min_passed = Int($passed_secs / 60)
               $sec_passed = Mod($passed_secs, 60)
               
               ;just to avoid unnecessary updates - flickering
               If $last_passed_sec <> $passed_secs Then
                  $last_passed_sec = $passed_secs
                  
                  $my_timestr = StringFormat("%02i:%02i:%02i", $hour_passed, $min_passed, $sec_passed)
                  
                  SplashTextOn("STUBBORN OPPONENT!", "idle time exceeded" & @CR & "moving mouse to avoid timeout" & @CR & _
                        "waiting for opponent to resign....." & @CR & @CR & "IDLE TIME:" & @CR & $my_timestr & @CR & @CR & _
                        "HIGH ROLLER is running!" & @CR & "press ESC to exit at any time.", 250, 190, 700, 350)
               EndIf
               
               Sleep(1000)
               
               $away = PixelGetColor(193, 505); coordinates of lower left corner of large orange resignation/away box.
               MouseMove(400, 400, 0)
            Until $away = 15695363
         EndIf
         
             If $away = 15695363 Then
         $x = 60
         For $z = 1 To 60 ;this waits for 1 minute to be sure they left the game.
            WinClose("Private")
            mousemove(300,300,0)
            Sleep(500)
            mousemove(400,400,0)
            SplashTextOn("OPPONENT HAS RESIGNED!", "waiting 60 seconds..... " & $x, 250, 30, 700, 350)
sleep(500)
            $x = $x - 1
         Next
         Do
            sleep(50)
                        MouseClick("left", 446, 451, 3, 0)  ;click yes im back if away box has appeared first.
            Sleep(50)
            MouseClick("left", 428, 418, 3, 0)  ;click yes to continue playing on resignation box.
                     $abc = PixelGetColor(432, 349)
            Until $abc = 16711422
            
             EndIf
         
         
         
      Until $pxc = 0
      
   EndIf
EndFunc
