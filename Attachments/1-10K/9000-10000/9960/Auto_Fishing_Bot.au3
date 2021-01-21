; AutoIt9 Version: 3.0 
; Language:       English 
; Platform:       WinXP 
; Author:         Spot23
; 
; Script Function: 
;  FishBot! 
; 

hotkeyset("{ESC}", "Term") 

; Colour of splash - 
;         0xA2A67D 
;         0xC1AD7A 
;         0xD0C08D 


$left = 90
$top = 110
$right = 748
$bottom = 350

$day = 0xF6F6F6 
$night = 0xEEEEEE 
$feather = 0x501C0D


; 2168603 548FBB
$colourVariance = 15 
$splashVariance = 10
$step = 3 
$s_offset = 40


dim $feather_cord, $width = 100, $height = 60, $time, $sp 

while 1 
   sleep(1000) 
   WinActivate("WORLD OF WARCRAFT") 
   send("0") 
   sleep(4000) 
   $start2 = Timerinit() 
   while 1 
       
      $dif = TimerDiff($start2) 
      if $dif > 25000 then 
      exitloop 
      endif 
      sleep(500) 
      $message = "Searching for feather..." 
      $height = 60 
      update_splash() 
      $feather_cord = PixelSearch ($left, $top, $right, $bottom, $feather, $colourVariance, $step) 
      if NOT @error = 1 then 
         seterror(1) 
         $message = "Found Something." 
         update_splash() 
         $featherx = $feather_cord[0] 
         $feathery = $feather_cord[1] 
         mousemove($featherx, $feathery) 
         exitloop 
      endif 
   WEnd 
    
   $start = Timerinit() 
   While 1 
      sleep(100) 
      $message = "Waiting for bite..." 
      $height = 100 
      update_splash() 
    
      ;calc area of probable splash 
      $s_left = ($featherx - $s_offset) 
      $s_top = ($feathery - $s_offset) 
      $s_right = ($featherx + $s_offset) 
      $s_bottom = ($feathery + $s_offset) 
       
      $sp = Pixelsearch($s_left, $s_top, $s_right, $s_bottom, $day, $splashvariance) 
      $sp = Pixelsearch($s_left, $s_top, $s_right, $s_bottom, $night, $splashvariance) 
       
      $dif = TimerDiff($start) 
      if $dif > 25000 then 
      exitloop 
      endif 
       
      if ubound($sp) > 1 then 
      ;if NOT @error = 1 then 
      seterror(1) 
      $message = "Fish!" 
      $height = 60 
      update_splash() 
      send("{shiftdown}") 
      mouseclick("right", $featherx, $feathery, 1, 1) 
      send("{shiftup}") 
      exitloop 
      endif 
   WEnd 
    
    
WEnd 


func update_splash () 
   SplashTextOn( "1", $message , $width , $height ,1 ,1 , 17) 
endfunc 
    
func Term () 
   exit 
endfunc