 ;Shows info about testin process when rolover mouse pointer to the icon of AutoIt in right bottom of the  screen 
Opt("TrayIconDebug", 1)
;Launches .exe file

ShellExecute("NumXLSetup-10SP4.exe")
; wait to activate welcome page and then click Next
WinWaitActive("NumXL - Setup")
Send("!n")
; wait to activate 2-nd page and then click Next
WinWaitActive("NumXL - Setup")
Send("!n")
; wait to activate License page and then click Next
WinWaitActive("NumXL - Setup", "License Agreement")
Send("{ENTER}")
; wait to activate License Key page and then click Next
WinWaitActive("NumXL - Setup", "License Key")
Send("!n")
; wait to activate Components page and then click Next
WinWaitActive("NumXL - Setup", "Choose Components")
Send("!n")
; wait to activate "Choose to install for all users or only for me"  page and then click Next
WinWaitActive("NumXL - Setup", "&Only for me")
; ControlClick function clicks to the radiobutton to choose one of the options
ControlClick("NumXL - Setup", "", "[ID:1201]")
; Click Next
Send("!n")
; wait to activate Installation Location page and then click Next
WinWaitActive("NumXL - Setup", "Choose Install Location")
Send("!n")
; wait to activate Start menu folder page and then click Next
WinWaitActive("NumXL - Setup", "Choose Start Menu Folder")
ControlClick("NumXL - Setup", "", "[ID:1]")
; wait Installation to be done 
; wait to activate Finish page and then click Finish
WinWaitActive("NumXL - Setup", "NumXL 1.0 Setup")
Send("{ENTER}")

;Activation
Sleep(2000)
; wait to activate Activation page 
WinWaitActive("NumXL - Setup", "Activation")
; Using ControlClick function, click to "Do it Latar" radiobutton
ControlClick("NumXL - Setup", "", "[ID:1202]")
; Click Next
Send("!n")
Sleep(2000)
; wait to activate License Key Activation page 
WinWaitActive("NumXL - Setup", "NumXL 1.0 License Key Activation")
; Using ControlClick function, Uncheck CheckBox, so when it clicks Finish the brouser will not be launched.
Sleep(2000)
ControlClick("NumXL - Setup", "", "[ID:1203]")
; Click Finish

Send("{ENTER}")