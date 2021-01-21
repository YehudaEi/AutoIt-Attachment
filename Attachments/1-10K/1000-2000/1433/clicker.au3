#include <Array.au3>
#include <Constants.au3>

; Press Esc to terminate script, Pause/Break to "pause"

Global $Paused
HotKeySet("{PAUSE}", "TogglePause")
HotKeySet("{ESC}", "Terminate")
HotKeySet("+!d", "ShowMessage")  ;Shift-Alt-d

; This is the only area on this program that you should be modifying.

; Your personal information
$username = "Tasselhoff"
$password = "*****"

;Kingdom Loc Information
;For each plex you would like this program to embezzel set a new ("StartX","StartY","EndX","EndY")

Dim $Plex	;Setting $Plex as an Array Variable.
$Plex = _ArrayCreate( _
_ArrayCreate("154","59","167","70", "Hel"), _ 
_ArrayCreate("86","165","95","184","Sur"), _ 
_ArrayCreate("156","69","171","73","Sur"), _ 
_ArrayCreate("269","0","298","29","Sur"), _ 
_ArrayCreate("278","126","289","130","Sur"), _
_ArrayCreate("0","0","58","8","Sky"), _ 
_ArrayCreate("0","10","8","18","Sky"), _
_ArrayCreate("53","55","63","64","Sky"), _
_ArrayCreate("235","53","250","67","Sky"), _
_ArrayCreate("204","56","222","70","Hev") _
)
; Do not modify below this point

; Log in Program
Func _LogIn()
	Run("C:\Program Files\Internet Explorer\iexplore.exe")
	MouseMove(448,54)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	Send("http://www.racewarkingdoms.com")
	Sleep(100)
	Send("{ENTER}")
	Sleep(10000)
	Send("{TAB 24}")
	Sleep(100)
	Send($username)		;Enters your username into Username Box
	Send("{TAB}")
	Send($password)		;Enters your password into the password Box
	Send("{ENTER}")		;Sends the information to rwk to be processed.
	Sleep(3500)
EndFunc

Func _CurrentPos()
	; Obtaining Current Locs
	MouseClickDrag("left", 252, 97, 321, 97)	;Selects the Location Coordinates.
	Sleep(500)
	MouseUp("left")
	Send("^c")


	; Setting current loc in Variable
	$Current_Loc = ClipGet()
	$FirstLoc = StringTrimRight($Current_Loc, 7)
	$SecondLoc = StringTrimLeft($Current_Loc, 7)
	$Plain = StringMid($Current_Loc, 5, 3)
	Sleep(100)
EndFunc

Func _ResetMouseLoc()
	MouseMove(4,71)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
EndFunc

;Select Teleport
Func _teleport()
	MouseMove(116,370)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	MouseMove(132,448)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	Send("{ENTER}")
	Sleep(100)
	Send("{TAB}")
	Sleep(100)

	;Setting Teleport locs and Teleporting to starting Location
	;Setting the X Axis
	Send("{NUMPAD0}") ;Starting at 0
	Sleep(100)
	$XStart= $Plex[1][1]
	For $i = 0 to $XStart Step 1
		Send("{DOWN}")
	Next

	Send("{TAB}")

	;Setting Y Teleport Axis
	Send("{NUMPAD0}") ;Starting at 0
	Sleep(100)
	$YStart = $Plex[1][2]
	For $i = 0 to $YStart Step 1
		Send("{DOWN}")
	Next

	Send("{TAB}")
	Sleep(100)
	Send("{ENTER}")
	Sleep(3500)
EndFunc


; Clearing Cookies before script can be run again
Func _ScriptEnd()
	MouseMove(173,28)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	MouseMove(220,180)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	MouseMove(162,246)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	MouseMove(140,95)
	Sleep(100)
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
	Sleep(100)
	Send("{ESC}")
	Sleep(100)
	Send("!{F4}")
	Sleep(100)
EndFunc

_LogIn()
_CurrentPos()
_ResetMouseLoc()
_Teleport()
_ScriptEnd()

; Makeing sure the script has run it's course.
MsgBox(64, "Msg from: Tasselhoff AI", "I have completed my task.")

Func TogglePause()
    $Paused = NOT $Paused
    While $Paused
        sleep(100)
        ToolTip('Script is "Paused"',0,0)
    WEnd
    ToolTip("")
EndFunc

Func Terminate()
    Exit 0
EndFunc

Func ShowMessage()
    MsgBox(4096,"","You have ended the Tasselhoff AI")
EndFunc