;whatever-click-bot;not safe
dim $a = "", $b = "", $coord = "", $c = 0, $d[100]

HotKeySet("!{f10}", "getcolor")
HotKeySet("!{f11}", "getmorecolor")
HotKeySet("!{f9}", "start")
HotKeySet("!{f8}", "stop")
HotKeySet("!{f7}", "defposset")

while 1
    sleep (50)
WEnd

func getcolor()
    $a = MouseGetPos ()
    $b = hex(pixelgetcolor($a[0],$a[1]), 6)
    IniWrite ("color.ini", "color", "found0", "0x"&$b)
EndFunc

func getmorecolor()
    $a = MouseGetPos ()
    $b = hex(pixelgetcolor($a[0],$a[1]), 6)
    $c = $c + 1
    IniWrite ("color.ini", "color", "found"&$c, "0x"&$b)
EndFunc

func start()
    $get = inireadsection ("color.ini", "color")
    if iniread("color.ini", "color", "found0", "") = "" then
        msgbox(0, "", "No color pre-selected! - Exiting programm")
        Exit
    EndIf
    for $i = 0 to $get[0][0]-1 step 1
        $d[$i] = iniread ("color.ini", "color", "found", "")
    next
    While 1
        $j = -1
        do
        $j = $j + 1
        $coord = PixelSearch(0,0,@desktopwidth,@desktopheight,$d[$j],0,2)
        until not @error
        MouseClick ("left", $coord[0],$coord[1],1,1)
        MouseMove (iniread("color.ini", "mousepos", "x", 0), iniread("color.ini", "mousepos", "y", 0))
        sleep (5000)
    WEnd
EndFunc

func stop()
    while 1
        sleep (50)
    WEnd
EndFunc

func defposset()
    $a = mousegetpos()
    iniwrite("color.ini", "mousepos", "x", $a[0])
    iniwrite("color.ini", "mousepos", "y", $a[1])
EndFunc