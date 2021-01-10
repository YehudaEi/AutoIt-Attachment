;This is my script to auto login for warcraft Battle.net
;It assumes that your username is already saved because this just writes your password
;I had to use the Start->Run method because running the program directly would give me problems
Send("#r")
Sleep(500)
;Change this to the path of your Frozen throne.exe
Send("C:\Games\war3\Frozen Throne.exe")
Send("{ENTER}")
;Change these sleep times if your computer is slower/faster
;Although I wouldnt recommend setting these faster
Sleep(6000)
Send("!b")
Sleep(6000)
;Change this to your password
Send("password")
Send("!l")
Sleep(6000)
Send("!h")
Sleep(5000)
;The next bit is optional. It joins a chat channel and goes to the custom games list. Remove it if you want
Send("Channel")
Send("!j")
Sleep(4000)
Send("!g")
;Hope it helps ya