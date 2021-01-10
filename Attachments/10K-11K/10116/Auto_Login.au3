$username = InputBox("Username", "Enter the username.", "", "", 190, 115 )
Sleep(500)
$password = InputBox("Password", "Enter the password.", "", "", 190, 115 )



Run(@ComSpec & " /c " & 'control userpasswords2', "", @SW_HIDE)
WinWaitActive ("User Accounts", "Users must &enter a user name and password to use this computer.")
Send("!e" & "!a")
WinWaitActive ("Automatically Log On")
Send("!u" & $username & "!p" & $password & "!c" & $password & "{ENTER}")
WinWaitActive ("User Accounts")
Send("{ENTER}")
Shutdown ( 2 )
;Send("")
;Send("")
;Send("")