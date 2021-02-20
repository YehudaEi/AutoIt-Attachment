;Computer Management Shared Files 

RUN(@SystemDir & '\mmc.exe ' & @SystemDir & '\compmgmt.msc ')
WinWaitActive("Computer Management")
send("{DOWN}{DOWN}{DOWN}{DOWN}{RIGHT}{DOWN}{DOWN}{DOWN}")

