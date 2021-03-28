; this script copies an address from Mozilla Firefox and opens it in IE
; click in Firefox's address bar before running the script

Opt("WinTitleMatchMode", 2) ; this tells AutoIt to match any part of window title in the following window commands
WinActivate("Mozilla Firefox") ; activates the Mozilla Firefox window
WinWaitActive("Mozilla Firefox") ; waits for Mozilla Firefox to be the active window before continuing
Send("{HOME}") ; the Send command tells AutoIt to type text; this line simulates pressing the Home key
Send("+{END}") ; this line simulates pressing Shift+End
Send("^c") ; this line simulates CTRL+c
Run("C:\Program Files\Internet Explorer\iexplore.exe") ; starts IE; you may need to edit this path
WinActivate("Internet Explorer") ; activates the IE window
WinWaitActive("Internet Explorer") ; waits for IE to be the active window before continuing
Send("^t") ; opens new tab in IE
WinWaitActive("New Tab - Windows Internet Explorer") ; you may need to edit this text depending on you IE version 
Send("^v") ; pastes the contents of the clipboard
Send("{ENTER}") ; this line simulates pressing Enter
