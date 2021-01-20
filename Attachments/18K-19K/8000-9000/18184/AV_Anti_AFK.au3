;########### 
; Globals 
;########### 
$title = "WoW FishBOT" 
$win_title = "World of Warcraft" 

; Sets up the Borders to Bot in 
$top_border_height = 23 
$left_border_width = 4 

; Sets up the Screen resolution $ make sure its in windowed mode 
$screen_width = 800 
$screen_height = 600 

; Just a simple Timer 
$time_to_wait = 30000 
dim $start_time 

$cast_duration = 600000
dim $cast_time
$pause_on = 0

;######################################################################### 
;                   Hot Keys Section                                    
;                                                                      
; Set up a Hot key to be used later to end the script                  
;######################################################################### 

HotKeySet("{`}", "request_end") 
HotKeySet("{PAUSE}", "request_pause") 


;######################################################################### 
;                     AV Anti-AFK Bot View Paremeters                          
;                                                                      
;  Sets up the boundaries of the AV Anti-AFK Bot on the screen and returns      
;  some visual confirmation by moving the mouse in a square showing    
;  where the bot will be searching for the fishing bobber              
;######################################################################### 

if not WinExists($win_title, "") then 
   msg($win_title & " window must be open.") 
   Exit 
endif 

WinActivate($win_title, "") 
WinSetOnTop($win_title, "", 0) 
Sleep(500) 

check_window() 

$win_pos = WinGetPos($win_title, "") 
$win_x = $win_pos[0] + $left_border_width 
$win_y = $win_pos[1] + $top_border_height 

$top = $win_y + (.25 * $screen_height) 
$bottom = $top + (.35 * $screen_height) - 1 
$left = $win_x + (.15 * $screen_width) 
$right = $left + $screen_width - (.15 * 2.0 * $screen_width) - 1 

;Start_Bot() 

;apply Buttons
	sleep (500)
	MouseClick("right");, 50, 50, 1, 2) 
	sleep(10000)
	AV()
;########################### 
; Visual confirmation      
; Area scanned for bobber 
;########################### 

MouseMove($left, $top, 2) 
MouseMove($right, $top, 2) 
MouseMove($right, $bottom, 2) 
MouseMove($left, $bottom, 2) 

cast_Attack() 
find_Target() 

;######################################################################### 

func find_Target() 
    
;#####################    
   ; Color Definitions 
   ;##################### 

	$color_AVBattleMAster_day = 339
   ;#########################################################    
   ; This is the color used to pixelsearch for the AV Battle Master. 1
   ; Change the color to a good color                      
   ; on the target that is prominent on the screen          
   ;######################################################### 

   $color_to_use =$color_AVBattleMAster_day
   ;################################################################## 
   ; This is the search tolerance. In areas where the target        
   ; colors really stand out, you can use a fairly high threshold. 
   ; In areas where the target colors are fairly muted in with      
   ; the background, you will have to lower the values considerably. 
   ;################################################################## 

   $bobber_search_tolerance = 40  
   ;######################################################################## 1
   ; It's better to use lower values here in favor of accurate searching. 
   ; This will take more time for it to detect the target.               
   ;######################################################################## 

   $bobber_search_step = 2 
    
   ;######################################################################### 
   ; Search for target.                        
   ;######################################################################### 

;########################### 
; Visual confirmation      
; Area scanned for target. 
;########################### 

 while 1 
      if TimerDiff($start_time) >= $time_to_wait then 
         if $pause_on == 0 then
			if $cast_time >= $cast_duration then
				sleep (3500)
				MouseClick("right");, 50, 50, 1, 2) 
				sleep(10000)
				AV()
			endif
			cast_attack() 
		 EndIf
      endif 
      
      $pos = PixelSearch($left, $top, $right, $bottom, $color_to_use, $bobber_search_tolerance, $bobber_search_step) 
         if @error then 
            SetError(0) 
         else 
            MouseMove($pos[0], $pos[1], 2) 
         endif 
      Sleep(10) 
   wend 
endfunc 

;###################### 
   ; Search for Target 
   ;###################### 

   while (TimerDiff($start_time) < $time_to_wait)
      $pos = PixelSearch($left, $top, $right, $bottom, $color_to_use, $bobber_search_tolerance, $bobber_search_step) 
      if @error then 
         SetError(0) 
	 else 
		 if $pause_on == 0 then
         ;##################### 
         ; Click on the AV Battle Master 
         ;##################### 

         MouseClick("right");, $pos[0], $pos[1], 1, 2) 
         Sleep(5500) 
         ExitLoop 
		 endif
      endif 
      Sleep(10) 
   wend 

   ;######################################    
   ; Cast Attack and start all over again. 
   ;###################################### 
   if $pause_on == 0 then
		if $cast_time >= $cast_duration then
				sleep (3500)
				MouseClick("right");, 50, 50, 1, 2) 
				sleep(10000)
				AV()
		endif
		sleep(500)
		cast_attack()
	else
		while (1 > 0)
			if $pause_on == 0 then
				ExitLoop
			endif
		wend
		sleep(500)
		Castpole()
   endif
End


;######################################    
; FONCTIONS: Help simplify the Script. 
;###################################### 

Func cast_attack() 
	if $pause_on == 0 then
   $start_time = TimerInit() 
   Send("1") 
   Sleep(1500) 
   endif
EndFunc 

; ############################################################################## 
func check_window() 
   $dimensions = WinGetClientSize($win_title, "") 
   if $dimensions[0] <> $screen_width or $dimensions[1] <> $screen_height then 
      msg("Invalid window size. You must use " & $screen_width & "x" & $screen_height & " resolution in window mode.") 
      Exit 
   endif 
endfunc 

; ############################################################################## 
func msg($text) 
   MsgBox(0, $title, $text) 
endfunc 

; ############################################################################## 
func msg_array($title, $array, $num_elements) 
   dim $text 
   $text = $array[0] 

   for $j = 1 to $num_elements - 1 
      $text = $text & ", " & $array[$j] 
   next 
   MsgBox(0, $title, $text) 
endfunc 


; ########################################################## 
func request_end() 
   $MB_YESNO = 4 
   $MB_YES = 6 
    
   if MsgBox($MB_YESNO, $title, "End script?") == $MB_YES then 
      Exit 
   endif 
endfunc 

;########################################################### 
;func Start_Bot() 
;   $MB_YESNO = 4 
;   $MB_YES = 6 
;    
;   if MsgBox($MB_YESNO, $title, "Do you want to start the Bot?") == $MB_Yes then 
;    
;   else 
;      Exit 
;   endif 
;endfunc 

; ########################################################## 
func drain_timer() 
   Msg("Restart") 
   $start_time = $start_time - $time_to_wait 
endfunc 

; ########################################################## 
func request_pause() 
	if $pause_on == 0 then
		$pause_on = 1
	else 
		if $pause_on == 1 then
		$pause_on = 0
		endif
	endif
endfunc 

; ############################################################################## 
func AV() 
   $Cast_time = TimerInit() 
endfunc 

