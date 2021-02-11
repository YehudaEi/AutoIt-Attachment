MsgBox(0,"System Changes","System changes in progress by your IT department........",10)
;Lock mouse and keyboard
BlockInput(1)
; Open Network Connections Control Panel applet
Run("control ncpa.cpl")
WinWaitActive("Network Connections")
; Selects Local Area Connection properties
Send("l")
Send("!F")
Send("r")
WinWaitActive("Local Area Connection")
; Select File And Printer Sharing for Microsoft Networks
send("File")
Send("{TAB 5}")
Send("{ENTER}")
; Close Local Area Connection properties screen and Network Connections window
WinClose("Network Connections")
;Unlock mouse and keyboard
Blockinput(0)