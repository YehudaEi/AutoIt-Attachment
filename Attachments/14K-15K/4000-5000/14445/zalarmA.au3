Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

; launch program blocking focus
BlockInput(1)
Run("zalarm")

; start
WinWaitActive("ZoneAlarm Installation")
Send("{TAB}{TAB}{ENTER}")

; install path (default is C:\Programs\Zone Labs\ZoneAlarm)
WinWaitActive("Select Destination Directory")
Send("{RIGHT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}{LEFT}")
Send("{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}{BACKSPACE}")
Send("{ENTER}")

; continue
WinWaitActive("ZoneAlarm Installation")
Send("{ENTER}")

; info + privacy
WinWaitActive("User Information")
Send("{TAB}{TAB}")
Send("none@none.com")
Send("{TAB}{SPACE}{TAB}{SPACE}{TAB}{TAB}{ENTER}")

; license
WinWait("ZoneAlarm Installation")
Send("{TAB}{TAB}{TAB}{SPACE}{TAB}{ENTER}")

; survey
WinWait("User survey")
If Not WinActive("User survey") Then WinActivate("User survey")
Send("{TAB}{TAB}{TAB}{TAB}{ENTER}")

; start zone alarm (yes,no)
WinWait("ZoneAlarm Setup","",180)
If Not WinActive("ZoneAlarm Setup") Then WinActivate("ZoneAlarm Setup")
Send("{ENTER}")

; free or pro
WinWait("License Wizard","Select ZoneAlarm",180)
If Not WinActive("License Wizard") Then WinActivate("License Wizard")
MouseClick ("left", 440, 150, 1, 0)
Send("{TAB}{ENTER}")

; info
WinWaitActive("License Wizard","Finish")
Send("{TAB}{TAB}{ENTER}")

; welcome 01
WinWait("Configuration Wizard","Basic Internet Security")
If Not WinActive("Configuration Wizard") Then WinActivate("Configuration Wizard")
MouseClick ("left", 470, 370, 1, 0)

; welcome 02
WinWait("Configuration Wizard","Configure Internet access to allow Web surfing")
If Not WinActive("Configuration Wizard") Then WinActivate("Configuration Wizard")
MouseClick ("left", 470, 370, 1, 0)

; welcome 03
WinWait("Configuration Wizard","Click Done to exit the Wizard.")
If Not WinActive("Configuration Wizard") Then WinActivate("Configuration Wizard")
MouseClick ("left", 540, 370, 1, 0)
Send("{ENTER}")

; end - stop reboot by killing application
WinWaitActive("ZoneAlarm Installation")
RunWait(@ComSpec & " /c " & 'taskkill /f /im zlclient.exe ', "", @SW_HIDE)

; settings
Run("zalarmS")

;resumes user input
BlockInput(0)
