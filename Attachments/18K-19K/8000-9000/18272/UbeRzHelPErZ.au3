#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.2.10.0
 Author:         Darin

 Script Function:
	Template AutoIt script.

#ce ----------------------------------------------------------------------------

; Script Start - Add your code below here
MsgBox(0, "UbErZHeLpeRz (By: SwiFt)", "To BO, Just Press ' ." & @CRLF & "To Auto-Hammer. Press ] And To Stop Press ] ." & @CRLF & "To Shutdown The Script Completely Press END" & @CRLF & "Make Sure Your 2 BO's Are Set At F7, F8!")

Func bo()
	
Send("w")
Sleep(500)
Send("{F7}")
Sleep(200)
Mouseclick("right")
Sleep(250)
Send("{F8}")
Sleep(250)
Mouseclick("right")
Sleep(550)
Send("w")
Sleep(150)
Send("{F3}")
Sleep(350)
Mouseclick("right")
Sleep(350)
Send("{F2}")
	EndFunc
	
HotkeySet("'", 'bo')
HotkeySet(']', 'Hammer')
HotKeySet("}", "otherhammer") 
Hotkeyset("{END}", "Term")


Func Hammer()
   ; Variable to indicate whether the mouse is already down
    Global $Down
    If $Down Then
		MouseUp('Left')
		Send("{SHIFTUP}")
    Else
		MouseDown('Left')
		Send("{SHIFTDOWN}")
    EndIf
   ; Swap the value of the variable to reflect the new state
    $Down = Not $Down
EndFunc

Func otherhammer()
   ; Variable to indicate whether the mouse is already down
    Global $Down
    If $Down Then
		MouseUp('Left')
		Send("{SHIFTUP}")
    Else
		MouseDown('Left')
		Send("{SHIFTDOWN}")
    EndIf
   ; Swap the value of the variable to reflect the new state
    $Down = Not $Down
EndFunc

While 1
    Sleep(1000)
WEnd


Func Term()
	Mouseup("left")
	Send("{SHIFTUP}")
Exit 0 
EndFunc 

