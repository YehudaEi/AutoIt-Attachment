;Written By: John Harris (Inline853)
;Run in AutoItv3

Global $x = 0 ;<== Set the X Coordinate of where your mouse should be
Global $y = 0 ;<== Set the Y Coordinate of where your mouse should be
HotKeySet("{f10}", "end") ;<== This sets F10 as the Hotkey to Exit the Program. When Preseed it will begin Function end.

While 1 ;<== Starts the Loop to continue Function Horizontal (or Vertical)
horizontal() ;<== Sets which Function to Loop. Change to vertical() for the mouse to move vertical
Wend ;<== Goes to top of the Loop

Func horizontal() ;<== Begins the Function horizontal
MouseMove($x+1, $y) ;<== Moves the Mouse 1 pixel to the right
sleep(10000) ;<== Waits 10000ms(10 seconds). Change to any amount of time.
MouseMove($x-1, $y) ;<== Moves the Mouse 1 Pixel to the Left
EndFunc ;<== Ends the horizontal Function

Func vertical() ;<== Begins the Function vertical
MouseMove($x, $y+1) ;<== Moves the Mouse 1 pixel up
sleep(10000) ;<== Waits 10000ms(10 seconds). Change to any amount of time.
MouseMove($x, $y-1) ;<== Moves the Mouse 1 Pixel down
EndFunc ;<== Ends the vertical Function

Func end() ;<== Begins the Function end.
SplashTextOn("", "Ending Program ...", 200,30) ;<== Displays a Splash Text for 2 Seconds
Sleep(2000) ;<== Waits 2000ms (2 seconds). Change to any amount of time.
Exit	;<== Exits the Program
EndFunc	;<== Ends the Function Exit