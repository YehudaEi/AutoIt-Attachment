' ------------------------ -------------------------------' 
'****************Kill Outlook Process******************************
Option Explicit
Dim objWMIService, objProcess, objsoftware, colProcess, colSoftware
Dim strComputer, strProcessKill 
strComputer = "."
strProcessKill = "'Outlook.exe'"

Set objWMIService = GetObject("winmgmts:" _
& "{impersonationLevel=impersonate}!\\" _ 
& strComputer & "\root\cimv2") 

Set colProcess = objWMIService.ExecQuery _
("Select * from Win32_Process Where Name = " & strProcessKill )
For Each objProcess in colProcess
objProcess.Terminate()
Next

'****************Uninstall Required Software***********************

strComputer = "."
Set objWMIService = GetObject("winmgmts:" _
    & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")

Set colSoftware = objWMIService.ExecQuery _
    ("Select * from Win32_Product Where Name = 'SOFTWARE NAME 1, SOFTWARE NAME 2 ETC'")

For Each objSoftware in colSoftware
    objSoftware.Uninstall()
Next

'***************Remove AdvanceDocs Printer*************************
strComputer = "." 
Set objWMIService = GetObject("winmgmts:" _ 
& "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2") 
Set colInstalledPrinters = objWMIService.ExecQuery _ 
("Select * from Win32_Printer where DeviceID = 'AdvanceDocs'") 
For Each objPrinter in colInstalledPrinters 
objPrinter.Delete_ 
Next

'***************Force Policy Update & Restart**********************

'Set objShell = CreateObject("WScript.Shell")
'objShell.Run "gpupdate /force", 1, True

MsgBox "Removal Finished"