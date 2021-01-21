Global Const $SM_VIRTUALWIDTH = 78
Global Const $SM_VIRTUALHEIGHT = 79

Global $pixel =	Int(IniRead(".\PixelSearch.ini","Main","PixelColor","-1"))
Global $chksum = Int(IniRead(".\PixelSearch.ini","Main","PixelCheckSum","-1"))

If $pixel = -1 Or $chksum = -1 Then
	MsgBox(4096,"Error","Could not read INI")
	Exit
EndIf

$VIRTUALDESKTOPWIDTH = DLLCall("user32.dll","int","GetSystemMetrics","int",$SM_VIRTUALWIDTH)
$VIRTUALDESKTOPWIDTH = $VIRTUALDESKTOPWIDTH[0]
$VIRTUALDESKTOPHEIGHT = DLLCall("user32.dll","int","GetSystemMetrics","int",$SM_VIRTUALHEIGHT)
$VIRTUALDESKTOPHEIGHT = $VIRTUALDESKTOPHEIGHT[0]

HotKeySet("`","find")

While 1
	ToolTip("Press ` (Tilda key) to" & @LF & "find the area in PixelSearch.ini.")
	Sleep(100)
WEnd

Func find()
	$x = 0
	$y = 0
	$ypixel = $VIRTUALDESKTOPHEIGHT - 1
	While 1
		$xy = PixelSearch($x,$y,$VIRTUALDESKTOPWIDTH - 1,$ypixel,$pixel)
		If @error And $ypixel = ($VIRTUALDESKTOPHEIGHT - 1)Then
			MsgBox(4096,"Error","Could not find area.")
			Exit
		ElseIf @error Then
			$y = $ypixel + 1
			$ypixel = ($VIRTUALDESKTOPHEIGHT - 1)
			$x = 0
		ElseIf $chksum = PixelCheckSum($xy[0]-5,$xy[1]-5,$xy[0]+5,$xy[1]+5) Then
			MouseMove($xy[0],$xy[1])
			ToolTip("There it is.")
			Sleep(3000)
			Exit
		Else
			$y = $xy[1]
			$ypixel = $y
			$x = $xy[0] + 1
		EndIf
	WEnd
EndFunc

