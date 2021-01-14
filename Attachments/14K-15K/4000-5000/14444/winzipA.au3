Opt("WinWaitDelay",100)
Opt("WinTitleMatchMode",4)
Opt("WinDetectHiddenText",1)
Opt("MouseCoordMode",0)

; launch program blocking focus
BlockInput(1)
Run("winzip")

; extract
WinWaitActive("WinZip® 10.0 Setup","&Setup")
Send("{ENTER}")

; install path
WinWait("WinZip Setup","&Install to:",180)
If Not WinActive("WinZip Setup","&Install to:") Then WinActivate("WinZip Setup","&Install to:")
Send("{ENTER}")

; google tools
WinWaitActive("WinZip Setup - Google Tools")
Send("{TAB}{SPACE}{TAB}{TAB}{TAB}{SPACE}{TAB}{TAB}{TAB}{ENTER}")

; select install options
WinWait("WinZip Setup","Thank you for installing WinZip!",180)
If Not WinActive("WinZip Setup","Thank you for installing WinZip!") Then WinActivate("WinZip Setup","Thank you for installing WinZip!")
Send("{ENTER}")

; license
WinWaitActive("License Agreement and Warranty Disclaimer")
Send("{TAB}{ENTER}")

; quick start
WinWaitActive("WinZip Setup","WinZip Quick Start")
Send("{ENTER}")

; classic or wizard
WinWaitActive("WinZip Setup","Start with WinZip &Classic")
Send("{ENTER}")

; express or custom
WinWaitActive("WinZip Setup","&Express setup (recommended)")
Send("{TAB}{TAB}{DOWN}{TAB}{TAB}{TAB}{ENTER}")

; options
WinWaitActive("WinZip Setup","Explorer Configuration")
Send("{TAB}{TAB}{TAB}{TAB}{SPACE}{TAB}{TAB}{SPACE}{TAB}{TAB}{SPACE}{TAB}{TAB}{TAB}{ENTER}")

; associate
WinWaitActive("WinZip Setup","WinZip needs to associate itself with your archives.")
Send("{ENTER}")

; updates
WinWait("WinZip Setup","Configure Check for Updates")
If Not WinActive("WinZip Setup","&Next >") Then WinActivate("WinZip Setup","&Next >")
MouseClick ("left", 160, 170, 1, 0)
Send("{TAB}{TAB}{TAB}{ENTER}")

; confirm
WinWaitActive("WinZip")
Send("{ENTER}")

; options
WinWaitActive("WinZip Setup","Other Options")
Send("{ENTER}")

; end
WinWaitActive("WinZip Setup","Finish")
Send("{ENTER}")

; program
WinWaitActive("WinZip (Evaluation Version)")
Send("!H")
Send("{DOWN}{DOWN}{DOWN}{DOWN}{DOWN}{ENTER}")

; enter code
WinWaitActive("Register WinZip")
Send("user")
Send("{TAB}")
Send("FJDTR-2XXEG-XMKR7-XM00M-8CW63")
Send("{ENTER}")

; confirm
WinWaitActive("WinZip")
Send("{ENTER}")

; license again
WinWaitActive("License Agreement and Warranty Disclaimer")
Send("{TAB}{ENTER}")

; program close
WinWaitActive("WinZip Pro")
Send("{ALTDOWN}{F4}{ALTUP}")

; settings
Run("winzipS")

;resumes user input
BlockInput(0)
