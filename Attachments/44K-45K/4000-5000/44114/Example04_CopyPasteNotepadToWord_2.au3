; This script copies and pastes 5 lines between two open Word documents.
; Before running this script, open two Word files and save one as old.docx (or old.doc)
; and one as new.docx. The names must be in lower case to match the script.
; Type 5 lines of text in the file named old.

Opt("WinTitleMatchMode", 2) ; configures AutoIt to find a search term in any part of the window title

Dim $x

WinActivate("old") ; activates window with old in the title
WinWaitActive("old") ; waits for the window to be active
Send("^{HOME}") ; simulates pressing CTRL+Home to go to top of document
For $x = 1 to 5 ; this is a loop that is done 5 times
   WinActivate("old") ; activates window with Old in the title
   WinWaitActive("old"); waits for the window to be active
   Send("{HOME}") ; simulates pressing the Home key
   Sleep(500) ; pauses for 1/2 a second; I added the pauses to show you what the script is doing
   Send("+{END}") ; simulates pressing Shit+End
   Sleep(500) ; pauses for 1/2 a second
   Send("^c") ; simulates pressing CTRL+c
   Send("{RIGHT}") ; simulates pressing the right arrow key
   Sleep(500) ; pauses for 1/2 a second
   WinActivate("new") ; activates window with new in the title
   WinWaitActive("new"); waits for the window to be active
   Send("^v")  ; simulates pressing CTRL+v
   Sleep(500) ; pauses for 1/2 a second
Next
