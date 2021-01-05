; Rishodi's Pindlebot v1.3a for Diablo II v1.10
; 
; AutoIt Version: 3.0
; Author:         Rishodi (Rishodi@yahoo.com)

$d2WinTitle = IniRead("pindlebot.ini", "Global", "D2WinTitle", "Diablo II")
$version = "1.3a"

$start = MsgBox(49, "Rishodi's Pindlebot v" & $version, "Before continuing, be sure that ALL of the following conditions are true:" & Chr(10) & Chr(10) & "1) Diablo II is running in a 800x600 window" & chr(10) & "2) Your character's inventory and stash are both completely empty" & Chr(10) & "3) Your character's stash is open", 15)
If (($start = 2) OR ($start = -1)) Then
	Exit
EndIf

If NOT WinExists($d2WinTitle, "") Then
	$d2WinTitle = "D2Loader v1.10b14 Build On Oct 29 2003"
EndIf
If NOT WinExists($d2WinTitle, "") Then
	MsgBox(16, "Rishodi's Pindlebot v" & $version, "Could not locate Diablo II window!")
	Exit
EndIf

WinActivate($d2WinTitle, "")
WinWaitActive($d2WinTitle, "", 5)
WinMove($d2WinTitle, "", 0, 0)
Sleep(500)
AutoItSetOption("MouseCoordMode", 0)
AutoItSetOption("PixelCoordMode", 0)
$winsize = WinGetPos($d2WinTitle, "")
$borderwidth = ($winsize[2] - 800) / 2
$titleheight = $winsize[3] - 600 - (2 * $borderwidth)

Global $spacecheck[5][2]
$spacecheck[0][0] = 0
$spacecheck[0][1] = -8
$spacecheck[1][0] = -8
$spacecheck[1][1] = 0
$spacecheck[2][0] = 0
$spacecheck[2][1] = 0
$spacecheck[3][0] = 8
$spacecheck[3][1] = 0
$spacecheck[4][0] = 0
$spacecheck[4][1] = 8


Func MyPixelGetColor($coordx, $coordy)
$coordx = $coordx + $borderwidth
$coordy = $coordy + $borderwidth + $titleheight
return PixelGetColor($coordx, $coordy)
EndFunc

Func MyMouseMove($x, $y)
$x = $x + $borderwidth
$y = $y + $titleheight + $borderwidth
MouseMove($x, $y, 1)
EndFunc

Func GridPos($x, $y)
;returns grid # of space in inventory or stash when given an x, y location
If $x > 400 Then ;inventory
	Return 10*(($y-329)/29) + ($x-433)/29
Else ;stash
	Return 6*(($y-156)/29) + ($x-168)/29
EndIf
EndFunc

Func SetupSpace($gridname, $x, $y)
For $i = 0 to 4
	IniWrite("advanced.ini", $gridname, GridPos($x, $y) & "_" & $i, MyPixelGetColor($x + $spacecheck[$i][0], $y + $spacecheck[$i][1]))
Next
EndFunc

TrayTip("RPB v" & $version, "Beginning color checks...", 6, 17)

MyMouseMove(380, 50)

Send("n")
Sleep(50)

$y = 329
While $y <= 416
	$x = 433
	While $x <= 694
		SetupSpace("Inventory", $x, $y)
		$x = $x + 29
	WEnd
	$y = $y + 29
WEnd

$y = 156
While $y <= 359
	$x = 168
	While $x <= 313
		SetupSpace("Stash", $x, $y)
		$x = $x + 29
	WEnd
	$y = $y + 29
WEnd

IniWrite("advanced.ini", "ColorChecks", "InGame", MyPixelGetColor(274, 573))
IniWrite("advanced.ini", "ColorChecks", "StashOpen", MyPixelGetColor(168, 93))

Send("{ESC}")

TrayTip("RPB v" & $version, "Setup completed.", 6, 17)
Sleep(1000)