HotKeySet("^!x", "_TerminateApp") ;CTRL+ALT+x

For $i = 10 to 1 Step -2
MouseMove(476, 32)
MouseClick("left")
MouseClick("left")
Sleep(500)
MouseMove(300, 200)
MouseDown("left")
MouseUp("left")
MouseDown("left")
MouseUp("left")
Sleep(1000)
Next

Func _TerminateApp()
    Exit
EndFunc

