Run('C:\WINDOWS\EXPLORER.EXE /n,/e,F:\SHARED\Wall Street Tickets\Account.rpt')
WinWaitActive("Crystal Reports - [Account.rpt]","")
Send("{F5}")
WinWaitActive("Refresh Report Data","")
Send("{TAB}{TAB}{DOWN}{ENTER}")
WinWait("Enter Parameter Values","")
WinWait("ODBC (RDO)","")
WinWaitActive("ODBC (RDO)","")
Send("{TAB 8}{DEL}username{TAB}password{ENTER}")
WinWait("Crystal Reports - [Account.rpt]")
WinWaitActive("Crystal Reports - [Account.rpt]")
Send("{ALT}")
Send("{F}")
Send("{E}")
WinWait("Export")
WinWaitActive("Export")
Send("{ENTER}")
WinWait("Export Options")
WinWaitActive("Export Options")
Send("{ENTER}")
WinWait("Choose export file")
WinWaitActive("Choose export file")
Send("{TAB 5}")
Send("{SPACE}")
Send("{DEL}")
Send("C:\%USERPROFILE%\Desktop\Reports\");where file is being saved
Send("{ENTER}")
WinWait("Choose export file")
WinWaitActive("Choose export file")
Send("!S");saves file
WinWait("Crystal Reports - [Account.rpt]")
WinWaitActive("Crystal Reports - [Account.rpt]")
Send("{ALT}");send to default printer step1
Send("{F}");send to default printer step2
Send("{P}");send to default printer step3
Send("{P}");send to default printer step4
Send("{ENTER}") ;send to default printer step5
WinWait("Crystal Reports - [Account.rpt]")
WinWaitActive("Crystal Reports - [Account.rpt]")
Send("{ALT}")
Send("{F}")
Send("{X}")
WinWait("Crystal Reports")
WinWaitActive("Crystal Reports")
Send("{TAB 1}")
Send("{ENTER}")