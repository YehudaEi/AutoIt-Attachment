;blame herewasplato for this long winded script
;the script is for use with (Windows 2000/XP or later)

;the end result of running this script should be
;a PixelSearch line of code in the windows clipboard
;that you can paste into your script

; 1) Read all of the comments in this script

; 2) Run this script

; 3) Reposition/Resize the semi-transparent
;   splash screen to cover the area to be
;   searched by PixelSearch in your script

; 4) Press ESC

; 5) Move the mouse to the window and pixel
;   that you are searching for in your script

; 6) Press ESC

; 7) Paste the contents of the Windows clipboard
;   into your script


;more boring details:
;running the script should move the active window
;to position 0,0 on the desktop and a create a
;splash screen starting in that same 0,0 location

;the splash screen represents the size of the
;PixelSearch area

;if you must, you can change the
;transparency of the splash screen here:
$transparency = 100;A number in the range 0 - 255.
;The larger the number,
;the more transparent the window will become.
;hopefully you can find a transparency setting that
;will allow you to see allow of the info behind
;the splash screen

;move the splash screen (PixelSearch area)
;via the left/right/up/down arrow keys
;(faster = shift-left/right/up/down)
;to the area of interest to you

;control the size of the splash screen (PixelSearch area)
;via the control-left/right/up/down arrow keys
;(faster = control-shift-left/right/up/down)

;PixelSearchs over large areas take CPU time
;so use the smallest search area possible

;if you make a large splash screen (PixelSearch area)
;it may flicker - you might control some of that by
;slowing down the splash screen "refresh rate" here:
$RefreshRate = 200

;read the help file on each of these settings
AutoItSetOption("PixelCoordMode", 0);do not change*
AutoItSetOption("MouseCoordMode", 0);do not change*
AutoItSetOption("WinTitleMatchMode", 3)
AutoItSetOption("TrayIconDebug", 1)
;see the very bottom of the script for more info

;a lazy way to prevent two copies of this script
;from running at the same time
$S_running = "pix-splash-window"
If WinExists($S_running) Then
    MsgBox(0, "AutoIt", "This script is already running")
    Exit
EndIf
AutoItWinSetTitle($S_running)

;gives you a chance to make the window
;of interest active before the script
;moves the active window to 0,0
MsgBox(0, "AutoIt PixelSearch Tool", _
        "You have 10 seconds to make the " & _
        "window of interest Active.", 10)

;sets the splash screen's starting size and position
$left = 0;leave
$top = 0;leave
$right = 100;change the starting size if you wish
$bottom = 100;change the starting size if you wish
$Xoffset = 0;leave
$Yoffset = 0;leave

;sets the hotkeys
HotKeySet("{ESC}", "ExitEachLoop")

;moves the splash screen
HotKeySet("{RIGHT}", "Xoffset_up")
HotKeySet("{DOWN}", "Yoffset_up")
HotKeySet("{LEFT}", "Xoffset_down")
HotKeySet("{UP}", "Yoffset_down")

;moves the splash screen in larger increments
HotKeySet("+{RIGHT}", "Xoffset_upL")
HotKeySet("+{DOWN}", "Yoffset_upL")
HotKeySet("+{LEFT}", "Xoffset_downL")
HotKeySet("+{UP}", "Yoffset_downL")

;resizes the splash screen
HotKeySet("^{RIGHT}", "right_up")
HotKeySet("^{DOWN}", "bottom_up")
HotKeySet("^{LEFT}", "right_down")
HotKeySet("^{UP}", "bottom_down")

;resizes the splash screen in larger increments
HotKeySet("^+{RIGHT}", "right_upL")
HotKeySet("^+{DOWN}", "bottom_upL")
HotKeySet("^+{LEFT}", "right_downL")
HotKeySet("^+{UP}", "bottom_downL")

;gets the mouse cursor out of the way
$OriginalMousePosition = MouseGetPos()
$DW = @DesktopWidth;make small for post width
$DH = @DesktopHeight;make small for post width
MouseMove($DW, $DH, 0)

;moves the active window to 0,0
WinMove("", "", 0, 0)

;this loop allows you to Reposition/Resize
;the splash screen to cover the area of interest
$ExitEachLoop = "no"
While 1
    SplashTextOn("PixArea", "", _
            $right - $left, _
            $bottom - $top, _
            $left + $Xoffset, _
            $top + $Yoffset, 1 + 16)
    WinSetTrans("PixArea", "", $transparency)
    Sleep($RefreshRate)
    If $ExitEachLoop = "yes" Then ExitLoop
WEnd
SplashOff()

;save the location/size info of the area
;to search via PixelSearch
$part1 = '$PScoord = PixelSearch(' & _
        $left + $Xoffset & ',' & _
        $top + $Yoffset & ',' & _
        $right + $Xoffset & ',' & _
        $bottom + $Yoffset & ','

;puts the mouse back where it was
MouseMove($OriginalMousePosition[0], _
        $OriginalMousePosition[1], 0)

;this loop allows you to position the mouse over the
;pixel that has the color that you are interested in
;searching for in your script
$ExitEachLoop = "no"
While 1
    $pos = MouseGetPos()
    $part2 = PixelGetColor($pos[0], $pos[1])
    ToolTip($part2)
    Sleep(100)
    If $ExitEachLoop = "yes" Then ExitLoop
WEnd

;creates the line of code for your script
ClipPut($part1 & $part2 & ')')


Exit
Func ExitEachLoop()
    $ExitEachLoop = "yes"
EndFunc;==>ExitEachLoop


;moves
Func Xoffset_up()
    If ($right + $Xoffset) < $DW Then $Xoffset = $Xoffset + 1
EndFunc;==>Xoffset_up

Func Yoffset_up()
    If ($bottom + $Yoffset) < $DH Then $Yoffset = $Yoffset + 1
EndFunc;==>Yoffset_up

Func Xoffset_down()
    If $Xoffset > 0 Then $Xoffset = $Xoffset - 1
EndFunc;==>Xoffset_down

Func Yoffset_down()
    If $Yoffset > 0 Then $Yoffset = $Yoffset - 1
EndFunc;==>Yoffset_down


;moves in larger increments
Func Xoffset_upL()
    If ($right + $Xoffset) < $DW Then $Xoffset = $Xoffset + 10
EndFunc;==>Xoffset_upL

Func Yoffset_upL()
    If ($bottom + $Yoffset) < $DH Then $Yoffset = $Yoffset + 10
EndFunc;==>Yoffset_upL

Func Xoffset_downL()
    If $Xoffset > 0 Then $Xoffset = $Xoffset - 10
EndFunc;==>Xoffset_downL

Func Yoffset_downL()
    If $Yoffset > 0 Then $Yoffset = $Yoffset - 10
EndFunc;==>Yoffset_downL


;resize
Func right_up()
    If ($right - $left + $Xoffset) < $DW Then $right = $right + 1
EndFunc;==>right_up

Func bottom_up()
    If ($bottom - $top + $Yoffset) < $DH Then $bottom = $bottom + 1
EndFunc;==>bottom_up

Func right_down()
    If $right > 0 Then $right = $right - 1
EndFunc;==>right_down

Func bottom_down()
    If $bottom > 0 Then $bottom = $bottom - 1
EndFunc;==>bottom_down


;resize in larger increments
Func right_upL()
    If ($right - $left + $Xoffset) < $DW Then $right = $right + 10
EndFunc;==>right_upL

Func bottom_upL()
    If ($bottom - $top + $Yoffset) < $DH Then $bottom = $bottom + 10
EndFunc;==>bottom_upL

Func right_downL()
    If $right > 0 Then $right = $right - 10
EndFunc;==>right_downL

Func bottom_downL()
    If $bottom > 0 Then $bottom = $bottom - 10
EndFunc;==>bottom_downL


;;;;;;;;;;;start test script;;;;;;;;;;;;;;
;you can test the output of the script above
;with a small test script like this:
AutoItSetOption("PixelCoordMode", 0)
AutoItSetOption("MouseCoordMode", 0)

;just paste over the line below
;with the output of the script above
$PScoord = PixelSearch(0, 0, 10, 10, 8650752);*
;*consult help file for shades and steps

If IsArray($PScoord) Then
    MouseMove($PScoord[0], $PScoord[1])
Else
    MsgBox(0, "AutoIt", "Error")
EndIf
;;;;;;;;;;;end test script;;;;;;;;;;;;;;



;more info for your script:
;take a look at the help file to learn
;about these two settings
AutoItSetOption("PixelCoordMode", 0)
AutoItSetOption("MouseCoordMode", 0)
;you can/should put them near the top of your script
;you can change the "0" to a "1" BUT...
;you will probably want to do so for both lines
;if you are going to use mouse clicks

;your script does not have to position
;the window that you are searching at 0,0