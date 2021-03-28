; This script copies and pastes one line of text between two open Word documents.
; Before running this script, open two Word files and save one as old.docx (or old.doc)
; and one as new.docx. The names must be in lower case to match the script.
; Type one line of text in the file named old.

Opt("WinTitleMatchMode", 2) ; configures AutoIt to find a search term in any part of the window title
WinActivate("old") ; activates the window that has old in the tilte bar
WinWaitActive("old") ; waits until the window is the active window
Send("{HOME}") ; simulates pressing the Home key 
Send("+{END}") ; simulates pressing the Shift+End keys 
Send("^c") ; simulates pressing the CTRL+c keys (copy)
WinActivate("new") ; activates the window that has new in the tilte bar
WinWaitActive("new") ; waits until the window is the active window
Send("^v") ; simulates pressing the CTRL+c keys 
Send("{ENTER}") ; simulates pressing the Enter key
