Run("iexplore.exe")
WinWaitActive("iexplore.exe")
MouseClick("left", 365, 48, 1)
MouseClick ( "button" [, 365, 48 [, 1 [, 10 ]]] )
Send("neopets.com")
Send("{ENTER}")
WinWaitActive("iexplore.exe")
MouseClick( "button" [, 1066, 315 [, 1 [, 10 ]]] )
MouseClick( "button" [, 636, 485 [, 1 [, 10 ]]] )
Send("username")
Send("{ENTER}") 
MouseClick( "button" [, 636, 485 [, 1 [, 10 ]]] )
Send("Password")
Send(" {ENTER}")
MsgBox(4096, "Congrats", "Congrats, your logged in!", 5)