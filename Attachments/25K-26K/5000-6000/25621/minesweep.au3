run("winmine.exe")
WinWaitActive("Minesweeper")
sleep(100)
send("xyzzy")
send("{SHIFTDOWN}{ENTER}{SHIFTUP}") 
while 1
	$var = PixelGetColor( 0 , 0 )
	if $var = 0 then
		$posx = MouseGetPos(0)
		$posy = MouseGetPos(1)
		ToolTip("mine",$posx+14,$posy+5)
	Else
		$posx = MouseGetPos(0)
		$posy = MouseGetPos(1)
		ToolTip("")
	endif
	if WinExists("Minesweeper") =0 Then
		Exit
	EndIf
wend
