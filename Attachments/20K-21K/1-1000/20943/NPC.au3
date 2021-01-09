Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)
WinWait("Guild Wars","")
If Not WinActive("Guild Wars","") Then WinActivate("Guild Wars","")
WinWaitActive("Guild Wars","")

Sleep(3000)
Send("h")
Sleep(1200)
Send("h")
$Found = 0

Send("{Alt Down}")

Sleep(500)

While $Found = 0
    $Coord = PixelSearch( 250, 215, 250, 500, 0x99FF00 )
    If NOT @Error Then
        $Found = 1
    EndIf
wEnd

Send("{Alt Up}")

MouseClick("Left", $Coord[0], $Coord[1],1)