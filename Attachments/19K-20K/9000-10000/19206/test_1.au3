sleep (10000)


While ((@Hour<>"04") or (@MIN < "40"))

   ;Undock me Scotty!
   MouseMove( 16,984 )
   Sleep(1500)
   MouseDown("left")
   Sleep(500)
   MouseUp("left")
   
   
Sleep(26000) 

   ;Pull away from the station to avoid bumping
   MouseMove( 683, 969 )
   MouseDown("left")
   Sleep(1000)
   MouseUp("left")
   Sleep(20000)
   
   
   ;Stop the ship
   MouseMove( 593, 969 )
   MouseDown("left")
   Sleep(1000)
   MouseUp("left")
   Sleep(5000)
 

   ;Prepare for warp / warp to 0km
   MouseMove( 821, 1010 )
   Sleep(1500)
   MouseDown("right")
   MouseUp("right")
   Sleep( 1000 )
   MouseMove( 914, 934 )
   Sleep(1500)
   MouseDown("left")
   MouseUp("left")
 

;turn on shield boosters
Send("{ALTDOWN}")
Sleep(250)
Send("{F1}")
Sleep(250)
send("{F2}")
Sleep(250)
Send("{F3}")
Sleep(250)
Send("{F4}")
Sleep(250)
Send("{ALTUP}")
   Sleep (50000)

   ;wait 5 seconds to get into warp
   ;sleep (5000)
   
   ;check to make sure you are in warp before checking to see if you've arrived at the belt
   ;$warp = False
   ;$warp1 = False
   ;$warp2 = False
   ;$warp3 = False
   
   ;While ( $warp = False )
	  
	;  Sleep (1000)
	;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 );looks for blue at the far right of the speedometer to indicate warp
    ;  If Not @error Then
    ;     $warp1 = True
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 )
    ;  If Not @error Then
    ;     $warp2 = True
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 )
    ;  If Not @error Then
    ;     $warp3 = True
	;  EndIf
	; 
	; If $warp1 = True OR $warp2 = True OR $warp3 = True THEN
    ;     $warp = True
	; EndIf
	 
 ;Wend
 
 ;Wait 5 seconds once warp is initiated, just in case
 ;Sleep (5000)
      
   ;check to make sure you are out of warp before launching drones
   ;$warp = True
   ;$warp1 = True
   ;$warp2 = True
   ;$warp3 = True
      
   ;While ( $warp = True )
	  
	;  Sleep (1000)
	;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 );looks for gray just to the right of the 3/4 mark on the speedometer to indicate sublight speed
    ;  If Not @error Then
    ;     $warp1 = False
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 )
    ;  If Not @error Then
    ;     $warp2 = False
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 )
    ;  If Not @error Then
    ;     $warp3 = False
	;  EndIf
	 
	; If $warp1 = False OR $warp2 = False OR $warp3 = False THEN
    ;     $warp = False
	; EndIf
	 
   ;Wend

;Launch Drones from Bay
   ;MouseMove( 1295, 590 )
   ;Sleep(500)
   ;MouseDown("right")
   ;Sleep(500)
   ;MouseUp("right")
   ;Sleep(1000)
   ;MouseMove( 1355, 614 );was 1355,635
   ;Sleep(500)
   ;MouseDown("left")
   ;Sleep(500)
   ;MouseUp("left")
   ;Sleep(1000)
    
	
   ;Click Lock Target
   MouseMove( 989, 50 )
   Sleep(1000)
   MouseDown("right")
   Sleep(500)
   MouseUp("right")
   Sleep(500)
   MouseMove( 1045, 109 )
   MouseDown("left")
   Sleep(1000)
   MouseUp("left")
   Sleep(1500)
   
   Send("{F1}")
   Sleep( 500 )
   Send("{F2}")
   Sleep( 500 )
   ;Send("{F3}")
   ;Sleep( 500 )
 
   MouseMove( 989, 50 )
   Sleep(1500)
   MouseDown("left")
   Sleep(250)
   MouseUp("left")		
    
	
   ;double check
   ;MouseMove(1003, 94)
   ;Sleep(1500)
   ;MouseDown("left")
   ;Sleep(250)
   ;MouseUp("left")

	;Sleep( 575000 )
	
	;Initialize parameters for shield damage check
	 $health1 = False
	 $health2 = False
	 $health3 = False
	 $health = False
	
	$timer = 0
	
	Do
	
	  Sleep(3000)	 
	 
	  $coord = PixelSearch( 635,864, 638,867, 0xFF1E1D, 75 )
      If Not @error Then
         $health1 = True
      EndIf
      Sleep (1000)
      $coord = PixelSearch( 635,864, 638,867, 0xFF1E1D, 75 )
      If Not @error Then
         $health2 = True
      EndIf
      Sleep (1000)
      $coord = PixelSearch( 635,864, 638,867, 0xFF1E1D, 75 )
      If Not @error Then
         $health3 = True
	  EndIf
	 
	 ;If any of the values return true then health = true and end the For/Next loop.
      If $health1 = True OR $health2 = True OR $health3 = True THEN
         $health = True
		 ExitLoop
	 EndIf
	 
	 $timer = $timer + 5
	 
	Until $timer > 965

	;Recalls drones
	;MouseMove( 1259, 610 )
	;sleep(1000)
	;Mousedown("right")
	;sleep(50)
	;Mouseup("right")
	;sleep(1000)
	;mousemove( 1355,672 )
	;sleep(1000)
	;mousedown("left")
	;sleep(50)
	;mouseup("left")
	;sleep(12000)


   ;$docked = False
   ;Fly back to station
   MouseMove( 780, 991 )
   Sleep(1500)
   MouseDown("right")
   MouseUp("right")
   Sleep(1500)
   MouseMove ( 850, 937 )
   Sleep(1500)
   MouseDown("left")
   MouseUp("left")
   
   Sleep (45000)
   
   ;wait 5 seconds to get into warp
   ;sleep (5000)
   
   ;check to make sure you are in warp before checking to see if you've arrived at the station
   ;$warp = False
   ;$warp1 = False
   ;$warp2 = False
   ;$warp3 = False
   
   ;While ( $warp = False )
	  
	;  Sleep (1000)
	;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 );looks for blue at the far right of the speedometer to indicate warp
    ;  If Not @error Then
    ;     $warp1 = True
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 )
    ;  If Not @error Then
    ;     $warp2 = True
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 751,852, 752,853, 0x528EC2, 25 )
    ;  If Not @error Then
    ;     $warp3 = True
	;  EndIf
	 
	; If $warp1 = True OR $warp2 = True OR $warp3 = True THEN
    ;     $warp = True
	; EndIf
	 
 ;Wend
 
 ;Wait 5 seconds once warp is initiated, just in case
 ;Sleep (5000)
      
   ;check to make sure you are out of warp before docking
   ;$warp = True
   ;$warp1 = True
   ;$warp2 = True
   ;$warp3 = True
      
   ;While ( $warp = True )
	  
	;  Sleep (1000)
	;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 );looks for gray just to the right of the 3/4 mark on the speedometer to indicate sublight speed
    ;  If Not @error Then
    ;     $warp1 = False
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 )
    ;  If Not @error Then
    ;     $warp2 = False
    ;  EndIf
    ;  Sleep (1000)
    ;  $coord = PixelSearch( 720,861, 721,862, 0x979796, 25 )
    ;  If Not @error Then
    ;     $warp3 = False
	;  EndIf
	 
	; If $warp1 = False OR $warp2 = False OR $warp3 = False THEN
    ;     $warp = False
	; EndIf
	 
   ;Wend
   
   ;Wait 20 seconds in case you warped in far from the starbase
   ;Sleep (20000)
   
   ;Approach station
	;	 MouseMove( 1259, 186 )
    ;     Sleep(1000)
    ;     MouseDown("right")
    ;     Sleep(500)
    ;     MouseUp("right")
    ;     Sleep(500)
    ;     MouseMove( 1309, 196 )
    ;     MouseDown("left")
    ;     Sleep(1000)
    ;     MouseUp("left")
    ;     Sleep(10000)
   
    ;Initialize parameters for docking check
	 ;$docked1 = False
	 ;$docked2 = False
	 ;$docked3 = False
	 
	  ;$coord = PixelSearch( 16,864, 18,866, 0xFAD840, 75 )
      ;If Not @error Then
      ;   $docked1 = True
      ;EndIf
      ;Sleep (1000)
      ;$coord = PixelSearch( 16,864, 18,866, 0xFAD840, 75 )
      ;If Not @error Then
      ;   $docked2 = True
      ;EndIf
      ;Sleep (1000)
      ;$coord = PixelSearch( 16,864, 18,866, 0xFAD840, 75 )
      ;If Not @error Then
      ;   $docked3 = True
	  ;EndIf   
	 
	  ;If any of the values return true then docked = true and go back to dock.
      ;If $docked1 = True OR $docked2 = True OR $docked3 = True THEN
      ;   $docked = True
	  ;EndIf

      ;If $docked = False Then
         MouseMove( 989, 50 )
         Sleep(1000)
         MouseDown("right")
         Sleep(500)
         MouseUp("right")
         Sleep(500)
         MouseMove( 1038, 89 )
         MouseDown("left")
         Sleep(1000)
         MouseUp("left")
         Sleep(45000)
      ;EndIf

   ;Make sure Items is open   
   MouseMove( 15, 685 )
   Sleep ( 500 )
   MouseDown("left")
   Sleep ( 1000 )
   MouseUp("left")
   Sleep ( 4000 )
   
   
   ;Drop Loot using Control A for select all
   MouseMove( 86, 765 )
   MouseDown("left")
   Sleep( 500 )
   MouseUp("left")
   Sleep(2000)
   Send("{CTRLDOWN}")
   Sleep(250)
   Send("a")
   Sleep(250)
   Send("{CTRLUP}")
   Sleep(1000)
   MouseMove( 86, 765 )
   MouseDown("left")
   Sleep ( 1000 )
   MouseMove( 86, 955 )
   Sleep( 1500 )
   MouseUp("left")
   Sleep( 4000 )
   
   
	
WEnd

Send("{CTRLDOWN}")
sleep(250)
Send("q")
sleep(250)
Send("{CTRLUP}")
