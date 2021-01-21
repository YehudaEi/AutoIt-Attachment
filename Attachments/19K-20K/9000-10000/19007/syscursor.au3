#include <GUIConstants.au3>

menu()
func menu() ;                                                      

  local $msg, $gc[99], $n, $i, $t, $m

  GuiCreate( "syscursor", 155, 500, -1, -1)
  $n= 0

  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "000 default", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "101 custom", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "102 custom", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "512 select", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "513 insert", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "514 wait", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "515 cross", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "516 arrowUp", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "641 select", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "642 stretchDiagonalBack", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "643 stretchDiagonalForward", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "644 stretchHorizontal", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "645 stretchVertical", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "646 move", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "648 avoid", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "649 hand", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "650 selectWait", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "651 selectQuestion", 3, $n*24, 150, 24)
  $n+= 1
  $gc[$n]= GUICtrlCreateButton( "663 selectCD", 3, $n*24, 150, 24)

  GUISetState( @SW_SHOW)

  while true
    $msg = GUIGetMsg()
    if $msg = $GUI_EVENT_CLOSE then exitloop
    for $i= 1 to $n
      if $gc[$i] == $msg then
        syscursor( stringleft( guictrlread( $msg), 3) *1)
        exitloop
      endif
    next
  wend
  syscursor( 0) ; reset to default
endfunc

func syscursor( $i)

   global $syscursor_current
   local $a, $k, $file, $victim
   $victim= 32651
   
   if $syscursor_current > 500 then
     $k= 32000 +$syscursor_current
     $a= DllCall( "user32.dll", "int", "LoadCursor", "int", 0, "int", $k)
     DllCall( "user32.dll", "int", "SetSystemCursor", "int", $a[0], "int", 32512)
     
   elseif $syscursor_current then
     $a= DllCall( "user32.dll", "int", "LoadCursor", "int", 0, "int", $victim)
     DllCall( "user32.dll", "int", "SetSystemCursor", "int", $a[0], "int", 32512)
   endif   

   if $i > 500 then
     $k= 32000 +$i
     $a= DllCall( "user32.dll", "int", "LoadCursor", "int", 0, "int", $k)
     DllCall( "user32.dll", "int", "SetSystemCursor", "int", $a[0], "int", 32512)
     $syscursor_current= $i
     
   elseif $i then
     $file= @scriptdir & "\" & $i & ".cur"
     $a= DllCall( "user32.dll", "int", "LoadCursorFromFile", "str", $file)
     DllCall( "user32.dll", "int", "SetSystemCursor", "int", $a[0], "int", $victim)
     $a= DllCall( "user32.dll", "int", "LoadCursor", "int", 0, "int", $victim)
     DllCall( "user32.dll", "int", "SetSystemCursor", "int", $a[0], "int", 32512)
     $syscursor_current= $i
     
   else
     $syscursor_current= 0
   endif

endfunc
