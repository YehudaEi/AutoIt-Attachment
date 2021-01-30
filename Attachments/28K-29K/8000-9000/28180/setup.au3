Run('isobuster_all_lang.exe')
WinWait("Select Setup Language", "")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Select Setup Language", "") Then WinActivate("Select Setup Language", "")
WinWaitActive("Select Setup Language", "")
Send("{ENTER}")
WinWait("Setup - IsoBuster", "")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{ENTER}")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{ENTER}")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{ENTER}")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{ENTER}")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{TAB}{SPACE}n")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{SPACE}{DOWN}{SPACE}n")
Sleep(1000) ;pause 1 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{SPACE}i")
Sleep(10000) ;pause 10 seconds
If Not WinActive("Setup - IsoBuster", "") Then WinActivate("Setup - IsoBuster", "")
WinWaitActive("Setup - IsoBuster", "")
Send("{SPACE}f")
