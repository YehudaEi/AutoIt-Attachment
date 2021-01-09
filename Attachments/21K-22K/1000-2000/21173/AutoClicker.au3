; <AUT2EXE VERSION: 3.1.1.0>

; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-START: C:\Documents and Settings\Ramzy\Desktop\Scripts\1 edit.au3>
; ----------------------------------------------------------------------------

; The script

MsgBox(0, "Ramzy's Auto Clicker", "Refer to the ReadMe file for more help using this program."  & @CRLF & " " & @CRLF & "Thanks and enjoy.")

$startclick = InputBox("Question", "Button to start left clicking", "{F9}", "", -1, -1, 0, 0)
$Rightclick = InputBox("Question", "Button to start right clicking", "{F10}", "", -1, -1, 0, 0)
$HK_STOP = InputBox("Question", "Button to stop all clicking commands", "{F11}", "", -1, -1, 0, 0)

HotKeySet($startclick, "startclick")
HotkeySet($HK_STOP, "HK_STOP")
Hotkeyset($Rightclick,  "Rightclick")
;HotKeySet("{F8}",  "Autobuff")

; This is the clicking function
Func startclick()
; Continuous loop that clicks the left mouse button
while(1)

; Starts the auto clicker
MouseClick("left")
Opt("MouseClickDelay", 10)
WEnd
EndFunc

Func Rightclick()
; Continuous loop that clicks the left mouse button
while(1)
MouseClick("Right")
WEnd
EndFunc

Func Autobuff()
While (1)
Send("2")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,25)
Opt("MouseClickDownDelay", 200)
Send("3")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,25)
Opt("MouseClickDownDelay", 200)
Send("6")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,25)
Opt("MouseClickDownDelay", 700)
Send("2")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,65)
Opt("MouseClickDownDelay", 200)
Send("3")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,65)
Opt("MouseClickDownDelay", 200)
Send("6")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,65)
Opt("MouseClickDownDelay", 700)
Send("2")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,105)
Opt("MouseClickDownDelay", 200)
Send("3")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,105)
Opt("MouseClickDownDelay", 200)
Send("6")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,105)
Opt("MouseClickDownDelay", 700)
Send("2")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,160)
Opt("MouseClickDownDelay", 200)
Send("3")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,160)
Opt("MouseClickDownDelay", 200)
Send("6")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,160)
Opt("MouseClickDownDelay", 700)
Send("2")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,195)
Opt("MouseClickDownDelay", 200)
Send("3")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,195)
Opt("MouseClickDownDelay", 200)
Send("6")
Opt("MouseCoordMode", 1)
MouseClick("Right",1226,195)
Opt("MouseClickDownDelay", 700)

Wend
Endfunc


; Stops the program
Func HK_STOP()
while 1 = 1
  Sleep(1000)
wend
EndFunc

; Need to keep the program running until you press the hotkey
while(1)
sleep(1000)
WEnd



; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Documents and Settings\SSHS4\My Documents\Autoit files\ac3.au3>
; ----------------------------------------------------------------------------


; ----------------------------------------------------------------------------
; <AUT2EXE INCLUDE-END: C:\Documents and Settings\Ramzy\Desktop\Scripts\1 edit.au3>
; ----------------------------------------------------------------------------