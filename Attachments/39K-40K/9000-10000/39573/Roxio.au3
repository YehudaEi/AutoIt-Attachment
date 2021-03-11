; Run Roxio installer
Run('C:\Temp\Roxio12\setup.exe')
WinWaitActive("Roxio Creator Starter Setup","Welcome to the Setup")
Send("!N")

WinWaitActive("Roxio Creator Starter Setup","I &accept the terms ")
Send("!A")
Send("!N")

WinWaitActive("Roxio Creator Starter Setup","&I will participate ")
Send("!N")

WinWaitActive("Roxio Creator Starter Setup","&Enter the install l")
Send("!N")

WinWaitActive("Roxio Creator Starter Setup","Click Install to beg")
Send("!I")

WinWaitActive("Roxio Creator Starter Setup","Setup Wizard Complet")
Send("!F")

WinWaitActive("Roxio Creator Starter","You must restart you")
Send("!N")

$SF_1 = "setup.exe"

If WinExists ( $SF_1 ) Then Exit
AutoItWinSetTitle ( $SF_1)
