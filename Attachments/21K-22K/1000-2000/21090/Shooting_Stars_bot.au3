HotKeySet("s", "ToggleTick") ; s key starts and stops
HotKeySet("q", "Quit") ; q key shuts down the script

Dim $TickTimer = "True"
AdlibEnable("ToggleTick", 60000)

Dim $Color[4] ; colors of the ballons
$Color[0]="0xF50002"
$Color[1]="0x6ebb1f"
$Color[2]="0xffd600"
$Color[3]="0x50b0d1"

WinActivate("Shooting Stars"); browser title here
MouseClick( "left", 360, 550, 1, 0) ; auto start
Sleep(500)

While 1
    While $TickTimer = "True"
       For $Colors In $Color
           $coor = PixelSearch( 75, 245, 655, 500, $Colors, 0, 10 )
            While Not @error
                MouseClick ( "left", ($Coor[0]), ($Coor[1]), 1, 3 ); seemed to work better without random
                Sleep(Random(30,100, 1))
                $coor = PixelSearch( 75, 245, 655, 500, $Colors, 0, 10 )
            WEnd
        Next
    WEnd
    Sleep(100)
WEnd


Func ToggleTick()
    If $TickTimer = "True" Then
		$TickTimer = "False"
		AdlibDisable()
	Else
			$TickTimer = "True"
			AdlibDisable()
			AdlibEnable( "Toggletick", 60000)
	EndIf
EndFunc

Func Quit()
	Exit
EndFunc