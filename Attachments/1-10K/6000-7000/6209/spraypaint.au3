Opt("PixelCoordMode",0)
Opt("WinTitleMatchMode",2)
Opt("ColorMode",1)

$width = InputBox("SprayPaint", "Width:")
$height = InputBox("SprayPaint", "Height:")
$fname = InputBox("SprayPaint", "File Name:")
$ignorecolor=0xFFFFFF
Dim $spray[$width][$height]
WinActivate("- Paint")
WinWaitActive("- Paint")
For $x = 65 to (64 + $width) 
    For $y = 47 to (46 + $height)
	$spray[$x-65][$y-47] = PixelGetColor($x,$y)
    Next
Next
MsgBox(0,"SprayPaint","Spray Retrieved")

$myfile = FileOpen($fname, 2)

FileWrite($myfile, 'Opt("ColorMode",1)'& @CRLF)
FileWrite($myfile, 'HotKeySet("^e","quit")'& @CRLF)
FileWrite($myfile, "While 1" & @CRLF & "$pos= MouseGetPos()" & @CRLF & "pict($pos[0],$pos[1])" & @CRLF & _
	"Sleep(200)" & @CRLF & "WEnd" & @CRLF)
FileWrite($myfile, 'Func quit()'& @CRLF & "Exit" & @CRLF & "EndFunc" & @CRLF)
FileWrite($myfile, 'Func drawpix($dc,$x,$y,$color)' & @CRLF & _
	'DllCall ("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $x, "long", $y, "long", $color)' _
	 & @CRLF & "EndFunc" & @CRLF)
FileWrite($myfile, "Func pict($x,$y)" & @CRLF & '$dc= DllCall ("user32.dll", "int", "GetDC", "hwnd", "")' & @CRLF)
For $x = 0 to ($width-1)
    For $y = 0 to ($height-1)
	If $spray[$x][$y] <> $ignorecolor Then FileWrite ( $myfile, "drawpix($dc,$x+" & $x & ",$y+" & $y & ",0x" & hex($spray[$x][$y]) & ")" & @CRLF)
    Next
Next
FileWrite($myfile,'DllCall ("user32.dll", "int", "ReleaseDC", "hwnd", 0,  "int", $dc[0])' & @CRLF & "EndFunc")
FileClose($myfile)
MsgBox(0,"SprayPaint","Spray Written To " & $fname)

waiting()

Func waiting()
HotKeySet("^s","spray")
HotKeySet("^e","quittime")
While 1
   Sleep(50)
WEnd
EndFunc

Func quittime()
   Exit
EndFunc

Func spray()
    $dc= DllCall ("user32.dll", "int", "GetDC", "hwnd", "")
    $pos= MouseGetPos ()
    For $x = 0 to ($width-1)
	For $y = 0 to ($height-1)
	    If $spray[$x][$y] <> $ignorecolor Then DllCall ("gdi32.dll", "long", "SetPixel", "long", $dc[0], "long", $pos[0] + $x, "long", $pos[1] + $y, "long", "0x" & hex($spray[$x][$y]))
	Next
    Next
    DllCall ("user32.dll", "int", "ReleaseDC", "hwnd", 0,  "int", $dc[0])
EndFunc